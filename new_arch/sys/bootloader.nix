{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "bootloader";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  cfg = config.sys.${name};
  options.sys.${name} = {
    enable = lib.mkEnableOption "Enables ${name} related settings.";
  };
  Common = {
  };
  Home = {
  };
  System = {
    boot.loader = {
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
        extraEntries = ''
          ${builtins.readFile "${../static/grub/00_Arch_Btrfs}"}
          ${builtins.readFile "${../static/grub/99_UEFI_Firmware}"}
        '';
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
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
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
