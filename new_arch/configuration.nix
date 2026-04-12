{
  config,
  lib,
  inputs,
  pkgs-list,
  managers,
  nixos-version,
  settings,
  tools,
  ...
}: let
  import_with_args = file: context:
    (import file {
      inherit config lib inputs pkgs-list tools;
      oldPathNames = [];
    }).config.${
      context
    };
in {
  imports =
    [
      ./hardware-configuration.nix
      ./sys.nix
      managers.home.nixosModules.default
    ]
    ++ [
      (import_with_args
        ./progs.nix
        "System")
    ];
  inherit (settings) progs;

  # environment.systemPackages = with pkgs-list.nix.latest; [wmctrl];
  system.version = nixos-version;
  networking.hostName = "NixOs";
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  }; # FIXME : Move to somewhere else
  fonts.packages = with pkgs-list.nix.latest; [nerd-fonts.jetbrains-mono]; # FIXME : Move to somewhere else
}
