{
  lib,
  bison,
  jdupes,
  buildPackages,
  elfutils,
  expat,
  flex,
  glslang,
  spirv-tools,
  libdrm,
  libgbm,
  libglvnd,
  libpng,
  libunwind,
  llvmPackages,
  lm_sensors,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  spirv-llvm-translator,
  stdenv,
  udev,
  vulkan-loader,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zstd,
  zlib,
  mesa-gl-headers,
  makeSetupHook,
  libdisplay-info,
}:
let
  galliumDrivers = [ "iris" ]; # ideally, we want to use only zink
  eglPlatforms = [ "wayland" ];
  vulkanDrivers = [ "intel" ];

  # default
  vulkanLayers = [
    "device-select"
    "intel-nullhw"
    "overlay"
    "screenshot"
    "vram-report-limit"
  ];

  mesonFlags = [
    # Kind of mandatory
    "--sysconfdir=/etc"
    (lib.mesonEnable "gbm" true)
    (lib.mesonEnable "glvnd" true)
    (lib.mesonBool "libgbm-external" true)
    (lib.mesonOption "platforms" (lib.concatStringsSep "," eglPlatforms))
    (lib.mesonOption "gallium-drivers" (lib.concatStringsSep "," galliumDrivers))
    (lib.mesonOption "vulkan-drivers" (lib.concatStringsSep "," vulkanDrivers))
    (lib.mesonOption "vulkan-layers" (lib.concatStringsSep "," vulkanLayers))
    (lib.mesonOption "clang-libdir" "${lib.getLib llvmPackages.clang-unwrapped}/lib")

    # You have Battlemage, right?
    (lib.mesonEnable "intel-rt" (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64))

    # Not needed
    (lib.mesonEnable "gallium-mediafoundation" false)
    (lib.mesonEnable "gallium-vdpau" false)
    (lib.mesonEnable "gallium-va" false)
    (lib.mesonEnable "android-libbacktrace" false)
    (lib.mesonEnable "valgrind" false)
    (lib.mesonEnable "xlib-lease" false)
    (lib.mesonOption "glx" "disabled")
  ];
in
stdenv.mkDerivation {
  pname = "mesa";
  version = "25.3.0-devel";
  src = builtins.fetchGit /var/stuff/foss/mesa;

  patches = [
    ./new-mesa-patch.diff
  ];

  postPatch = ''
    patchShebangs .

    for header in ${toString mesa-gl-headers.headers}; do
      if ! diff -q $header ${mesa-gl-headers}/$header; then
        echo "File $header does not match between mesa and mesa-gl-headers, please update mesa-gl-headers first!"
        exit 42
      fi
    done
  '';

  outputs = ["out"];

  # Keep build-ids so drivers can use them for caching, etc.
  # Also some drivers segfault without this.
  separateDebugInfo = true;
  __structuredAttrs = true;

  # Needed to discover llvm-config for cross
  preConfigure = ''
    PATH=${lib.getDev llvmPackages.libllvm}/bin:$PATH
  '';

  inherit mesonFlags;
  strictDeps = true;

  buildInputs =
    [
      elfutils
      expat
      spirv-tools
      libdrm
      libgbm
      libglvnd
      libpng
      libunwind
      llvmPackages.clang
      llvmPackages.clang-unwrapped
      llvmPackages.libclc
      llvmPackages.libllvm
      lm_sensors
      python3Packages.python # for shebang
      spirv-llvm-translator
      udev
      vulkan-loader
      wayland
      wayland-protocols
      zstd
      zlib
      libdisplay-info
    ];

  depsBuildBuild = [
    pkg-config
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    bison
    flex
    python3Packages.python
    python3Packages.packaging
    python3Packages.pycparser
    python3Packages.mako
    python3Packages.pyyaml
    wayland-scanner
    jdupes

    # Use bin output from glslang to not propagate the dev output at
    # the build time with the host glslang.
    (lib.getBin glslang)
  ];

  doCheck = false;

  postFixup = ''
    # set full path in EGL driver manifest
    for js in $out/share/glvnd/egl_vendor.d/*.json; do
      substituteInPlace "$js" --replace-fail '"libEGL_' '"'"$out/lib/libEGL_"
    done

    # and in Vulkan layer manifests
    for js in $out/share/vulkan/{im,ex}plicit_layer.d/*.json; do
      substituteInPlace "$js" --replace '"libVkLayer_' '"'"$out/lib/libVkLayer_"
    done

    # remove DRI pkg-config file, provided by dri-pkgconfig-stub
    rm -f $out/lib/pkgconfig/dri.pc

    # remove headers moved to mesa-gl-headers
    for header in ${toString mesa-gl-headers.headers}; do
      rm -f $out/$header
    done

    # clean up after removing stuff
    find $out -type d -empty -delete

    # Don't depend on build python
    patchShebangs --host --update $out/bin/*

    # NAR doesn't support hard links, so convert them to symlinks to save space.
    jdupes --hard-links --link-soft --recurse "$out"

    # add RPATH here so Zink can find libvulkan.so
    patchelf --add-rpath ${vulkan-loader}/lib $out/lib/libgallium*.so
  '';

  passthru = {
    inherit (libglvnd) driverLink;
    inherit llvmPackages;
    inherit
      eglPlatforms
      galliumDrivers
      vulkanDrivers
      vulkanLayers
      ;
  };
}
