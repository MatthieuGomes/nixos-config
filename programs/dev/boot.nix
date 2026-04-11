{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "boot";
  subfolder = "boot";
  # repo = "";
  # branch = "";
  # packages = pkgs-list.${repo}.${branch};
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  imports = [
    "efibootmgr"
    "grub"
    "gparted"
    "os-prober"
  ];
  cfg = config.${name};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    efibootmgr = lib.mkEnableOption "Enables and configures efibootmgr.";
    grub = lib.mkEnableOption "Enables and configures GRUB.";
    gparted = lib.mkEnableOption "Enables and configures GParted.";
    os-prober = lib.mkEnableOption "Enables and configures os-prober.";
  };
  settings = {
    efibootmgr.enable = cfg.enable && cfg.efibootmgr;
    grub.enable = cfg.enable && cfg.grub;
    gparted.enable = cfg.enable && cfg.gparted;
    os-prober.enable = cfg.enable && cfg.os-prober;
  };
  inheritedSettings = tools.inheritSettings {
    inherit pathNames imports settings;
  };
  Common = {
    inherit (settings) efibootmgr grub gparted os-prober;
  };
  Home = {
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
      imports = map (file:
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
