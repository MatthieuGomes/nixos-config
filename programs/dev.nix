{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "dev";
  subfolder = "dev";
  repo = "nix";
  branch = "latest";
  packages = pkgs-list.${repo}.${branch};
  imports = [
    "nix"
    "boot"
    "vim"
    "docker"
    "ghostty"
  ];
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    docker = lib.mkEnableOption "Enables and configures Docker.";
    boot = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      description = "Enables and configures boot related tools.";
    };
    dev-nix = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      description = "Enables and configures Nix related tools.";
    };
    network = lib.mkEnableOption "Enables and configures Network tools.";
    ghostty = lib.mkEnableOption "Enables and configures Ghostty.";
    git = lib.mkEnableOption "Enables and configures Git.";
    postman = lib.mkEnableOption "Enables and configures Postman.";
    vscode = lib.mkEnableOption "Enables and configures VSCode.";
    vim = lib.mkEnableOption "Enables and configures Vim.";
  };
  cfg = config.${name};
  settings = {
    docker.enable = cfg.enable && cfg.docker;
    boot = {
      enable = cfg.enable && cfg.boot.enable;
      efibootmgr = cfg.enable && cfg.boot.efibootmgr;
      grub = cfg.enable && cfg.boot.grub;
      gparted = cfg.enable && cfg.boot.gparted;
      os-prober = cfg.enable && cfg.boot.os-prober;
    };
    dev-nix = {
      enable = cfg.enable && cfg.dev-nix.enable;
      nixd = cfg.enable && cfg.dev-nix.nixd;
      alejandra = cfg.enable && cfg.dev-nix.alejandra;
    };
    # network.enable = cfg.enable && cfg.network;
    ghostty.enable = cfg.enable && cfg.ghostty;
    git.enable = cfg.enable && cfg.git;
    postman.enable = cfg.enable && cfg.postman;
    vscode.enable = cfg.enable && cfg.vscode;
    vim.enable = cfg.enable && cfg.vim;
  };
  Common = {
    inherit (settings) docker vim;
  };
  Home = {
    inherit (settings) dev-nix ghostty git postman vscode boot;
    home.packages = with packages; [
      python3
      nmap # for network
      netcat-openbsd # for network
    ];
  };
  System = {
  };

  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  config = {
    Home = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports =
        map (file: ./${subfolder}/${file}.nix) [
          # "ghostty"
          "vscode"
          "postman"
          "git"
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config lib pkgs-list tools;
            inherit (Inputs) inputs;
            oldPathNames = pathNames;
          }).config.Home)
        imports;
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports = map (file:
        (import ./${subfolder}/${file}.nix {
          inherit config lib pkgs-list tools;
          inherit (Inputs) inputs;
          oldPathNames = pathNames;
        }).config.System)
      imports;
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
