{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
}:
stdenv.mkDerivation rec {
  pname = "klassy";
  version = "v6.5.3";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = pname;
    rev = version;
    sha256 = "1pvc69bchwwagwfpzz5kr65i16nvrhdbw3jv09spc4hjcqd55kfq";
  };

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DBUILD_QT5=OFF"
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kdecoration
    kdePackages.kcoreaddons
    kdePackages.kguiaddons
    kdePackages.kconfigwidgets
    kdePackages.kiconthemes
    kdePackages.kwayland
    kdePackages.kwindowsystem
    kdePackages.kirigami
    kdePackages.frameworkintegration
    kdePackages.kcmutils
    kdePackages.qtsvg
  ];

  meta = with lib; {
    description = "A highly customizable binary Window Decoration and Application Style plugin for recent versions of the KDE Plasma desktop";
    homepage = "https://github.com/paulmcauley/klassy";
    license = with licenses; [
      gpl2Only
      gpl2Plus
      gpl3Only
      bsd3
      mit
    ];
  };
}
