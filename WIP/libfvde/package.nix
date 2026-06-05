{
  lib,
  stdenv,
  fetchFromGitHub,
  gnumake,
  autoconf,
  automake,
  libtool,
  pkg-config,
  flex,
  byacc,
  gettext,
  git,
  cacert,
  which,
  coreutils,
  glibc,
}:
stdenv.mkDerivation rec {
  pname = "libfvde";
  version = "1a2dbccbde7a7073c42ddbbeeed42afd5c7daef9";

  src = fetchFromGitHub {
    owner = "MatthieuGomes";
    repo = pname;
    rev = version;
    sha256 = "1k5ad2nqjb9azc9qnsmkd601k02xra4m0aszl814a8xnxdcfhxw9";
  };

  nativeBuildInputs = [
    git
    gnumake
    autoconf
    automake
    libtool
    pkg-config
    flex
    byacc
    gettext
    cacert
    which
    coreutils
    glibc
  ];
  buildPhase = ''
    runHook preBuild

    ./synclibs.sh
    ./autogen.sh
    ./configure
    make

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    make DESTDIR=$out install

    runHook postInstall
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive"; # Specify "recursive" for directories, "flat" for files
  outputHash = ""; # Leave empty at first; let Nix determine the hash

  meta = with lib; {
    description = "libfvde is a library to access FileVault Drive Encryption (FVDE) (or FileVault2) encrypted volumes.";
    homepage = "https://github.com/MatthieuGomes/libfvde";
    license = with licenses; [
      gpl3Only
    ];
  };
}
