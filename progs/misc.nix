{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
    name = "misc";
    subfolder = "misc";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "ledger"
      "bambu-studio"
      "bitwarden"
      "fastfetch"
      "iso-image-writer"
      "vesktop"
      "kdeconnect"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    settings = {
      ledger.enable = true;
      bambu-studio.enable = true;
      bitwarden.enable = true;
      fastfetch.enable = true;
      iso-image-writer.enable = true;
      kdeconnect.enable = true;
      vesktop.enable = true;
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    home.packages = with packages; [
      vlc # Misc
    ];
  };
  System = {
  };
})
