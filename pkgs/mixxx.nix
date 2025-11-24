{ pkgs }:

let
  libdjinterop = pkgs.libdjinterop.overrideAttrs (old: {
    version = "0.26.1";
    src = pkgs.fetchFromGitHub {
      owner = "xsco";
      repo = "libdjinterop";
      rev = "0.26.1";
      hash = "sha256-HwNhCemqVR1xNSbcht0AuwTfpRhVi70ZH5ksSTSRFoc=";
    };
  });
in
pkgs.stdenv.mkDerivation rec {
  pname = "mixxx";
  version = "2.6.0";

  src = pkgs.fetchFromGitHub {
    owner = "gergoszaszvaradi";
    repo = "mixxx";
    rev = "main";
    hash = "sha256-j4Gjy3OhJ1078YwwUfosBeewsZIv3JXbC1eMoIl+yis=";
  };

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.pkg-config
    pkgs.kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    pkgs.chromaprint
    pkgs.faad2
    pkgs.ffmpeg
    pkgs.fftw
    pkgs.flac
    pkgs.gbenchmark
    pkgs.glibcLocales
    pkgs.gtest
    pkgs.hidapi
    pkgs.lame
    pkgs.libebur128
    pkgs.libGLU
    pkgs.libid3tag
    libdjinterop
    pkgs.libkeyfinder
    pkgs.libmad
    pkgs.libmodplug
    pkgs.libopus
    pkgs.libsecret
    pkgs.libshout
    pkgs.libsndfile
    pkgs.libusb1
    pkgs.libvorbis
    pkgs.xorg.libxcb
    pkgs.lilv
    pkgs.lv2
    pkgs.microsoft-gsl
    pkgs.mp4v2
    pkgs.opusfile
    pkgs.portaudio
    pkgs.portmidi
    pkgs.protobuf
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.qtbase
    pkgs.kdePackages.qtdeclarative
    pkgs.kdePackages.qtkeychain
    pkgs.kdePackages.qtsvg
    pkgs.rubberband
    pkgs.serd
    pkgs.sord
    pkgs.soundtouch
    pkgs.sratom
    pkgs.sqlite
    pkgs.taglib
    pkgs.upower
    pkgs.vamp-plugin-sdk
    pkgs.wavpack
  ];

  qtWrapperArgs = [ "--set LOCALE_ARCHIVE ${pkgs.glibcLocales}/lib/locale/locale-archive" ];

  cmakeFlags = [
    "-DINSTALL_USER_UDEV_RULES=OFF"
    # "BUILD_TESTING=OFF" must imply "BUILD_BENCH=OFF"
    "-DBUILD_BENCH=OFF"
  ];

  postInstall = pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
    rules="$src/res/linux/mixxx-usb-uaccess.rules"
    if [ ! -f "$rules" ]; then
        echo "$rules is missing, must update the Nix file."
        exit 1
    fi
    mkdir -p "$out/lib/udev/rules.d"
    cp "$rules" "$out/lib/udev/rules.d/69-mixxx-usb-uaccess.rules"
  '';

  meta = with pkgs.lib; {
    homepage = "https://mixxx.org";
    description = "Digital DJ mixing software";
    mainProgram = "mixxx";
    changelog = "https://github.com/mixxxdj/mixxx/blob/${version}/CHANGELOG.md";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      gergoszaszvaradi
    ];
    platforms = platforms.linux;
  };
}
