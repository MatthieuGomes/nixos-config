{
  config,
  lib,
  inputs,
  pkgs-list,
  managers,
  nixos-version,
  opt,
  ...
}: let
  import_with_args = file: context:
    (import file {
      inherit config lib inputs pkgs-list;
    }).config.${
      context
    };
in {
  imports =
    [
      ./hardware-configuration.nix
      ./system.nix
      managers.home.nixosModules.default
    ]
    ++ [
      (import_with_args
        ./programs.nix
        "nixosModule")
    ];
  inherit (opt) programs;

  # environment.systemPackages = with pkgs-list.nix.latest; [wmctrl];
  system.version = nixos-version;
  networking.hostName = "NixOs";
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  fonts.packages = with pkgs-list.nix.latest; [nerd-fonts.jetbrains-mono];
}
