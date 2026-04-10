{
  config,
  lib,
  inputs,
  pkgs-list,
  managers,
  nixos-version,
  settings,
  inheritSettings,
  tools,
  ...
}: let
  import_with_args = file: context:
    (import file {
      inherit config lib inputs pkgs-list;
      inherit inheritSettings;
      inherit tools;
    }).config.${
      context
    };
  test = tools.inheritSettings;
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
  inherit (settings) programs;

  # environment.systemPackages = with pkgs-list.nix.latest; [wmctrl];
  system.version = nixos-version;
  networking.hostName = "NixOs";
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  fonts.packages = with pkgs-list.nix.latest; [nerd-fonts.jetbrains-mono];
}
