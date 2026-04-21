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
    name = "dev";
    subfolder = "dev";
    main-repo = "nix";
    branch = "latest";
    imports = [
      ## "editors" => # "vim" "vscode"
      ## "lang" => # "nix"
      ## "terminals" => # "ghostty"
      ## "virtualization" => # "docker"
      ## "network" => # "postman"
      "nix"
      "boot"
      "network"
      "git" #solo
      "docker"
      "postman"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    settings = {
      nix.enable = true;
      boot.enable = true;
      network.enable = true;
      git.enable = true;
      docker.enable = true;
      postman.enable = true;
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    home.packages = with packages; [
      python3 # Lang
      nmap # Network
      netcat-openbsd # Network
    ];
  };
  System = {
  };
})
