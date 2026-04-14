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
  cfg = config.sys.${name};
  options = {
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
        # FEAT : maybe move static files in dedicated folder.
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
      options = tools.inheritOptions {
        inherit pathNames options;
      };
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      options = tools.inheritOptions {
        inherit pathNames options;
      };
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
