{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "plymouth-theme-pedro-raccoon";
  version = "v1.1";

  src = fetchFromGitHub {
    owner = "FilaCo";
    repo = pname;
    rev = version;
    sha256 = "0wdhlhwbyw2lja39gqpb3n57nzdg27mh3sd8majdw74xcwgxzs1g";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes/pedro-raccoon
    cp -r pedro-raccoon/* $out/share/plymouth/themes/pedro-raccoon
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;

    runHook postInstall
  '';

  meta = {
    description = "Plymouth theme with Pedro raccoon meme";
    homepage = "https://github.com/FilaCo/plymouth-theme-pedro-raccoon";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
