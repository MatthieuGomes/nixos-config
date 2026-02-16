{
  config,
  lib,
  inputs,
  system,
  pkgs-list,
  ...
} @ Inputs: let
  name = "system";
  repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${repo}.${branch};
in {
  options.${name} = {
    version = lib.mkOption {
      type = lib.types.str;
      default = "25.11";
      description = "The system state version.";
    };
  };
  imports = map (file: ./system/${file}) [
    "bootloader.nix"
    "lang.nix"
    "users.nix"
    "hardware.nix"
    "networking.nix"
    "filesystems.nix"
  ];
  config = {
    system.stateVersion = config.system.version;
    nix.settings.experimental-features = ["nix-command" "flakes"];
    boot.kernelPackages = packages.linuxPackages_latest;
  };
}
