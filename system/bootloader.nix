{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
in {
  options = {};
  imports = [];
  config = {
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
}
