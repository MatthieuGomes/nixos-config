{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  ######  # user defined
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
    "ghostty"
    "git" #solo
    "vim"
    "vscode"
    "docker"
    "postman"
  ];
  options = {
    enable = lib.mkEnableOption "Enables ${name} program and related settings.";
  };
  extras = {
  };
  settings = {
    nix.enable = true;
    boot.enable = true;
    network.enable = true;
    ghostty.enable = true;
    git.enable = true;
    vim.enable = true;
    vscode.enable = true;
    docker.enable = true;
    postman.enable = true;
  };
  ######  # computed
  packages =
    if main-repo != null && branch != null
    then pkgs-list.${main-repo}.${branch}
    else null;
  currentPathAsList = parentPathAsList ++ [name];
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." parentPathAsList]);
  cfg = tools.inheritConfig {
    inherit config currentPathAsList;
  };
  inheritedSettings =
    if imports != null || settings != null
    then
      tools.inheritSettings {
        inherit currentPathAsList imports settings;
      }
    else {
    };
  Common =
    inheritedSettings
    // {
    };
  ######  # user defined
  Home = {
    home.packages = with packages; [
      python3
      nmap # for network
      netcat-openbsd # for network
    ];
  };
  System = {
  };
  ######  # computed
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  config = {
    Home = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
      inherit imports options; # user defined
      context = "Home";
      Config = HomeConfig;
    };
    System = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
      inherit imports options; # user defined
      context = "System";
      Config = SystemConfig;
    };
  };
}
