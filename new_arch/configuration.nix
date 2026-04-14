{
  config,
  lib,
  inputs,
  pkgs-list,
  managers,
  settings,
  tools,
  ...
}: let
  import_with_args = file: context:
    (import file {
      inherit config lib inputs pkgs-list tools settings;
      oldPathNames = [];
    }).config.${
      context
    };
in {
  imports =
    [
      (import
        ./sys.nix
        {
          inherit config lib pkgs-list tools inputs settings;
          oldPathNames = [];
        })
    ]
    ++ [
      ./hardware-configuration.nix
      managers.home.nixosModules.default
    ]
    ++ [
      (import_with_args
        ./progs.nix
        "System")
    ];
  sys.version = settings.sys.version;
  # environment.systemPackages = with pkgs-list.nix.latest; [wmctrl];
  networking.hostName = "NixOs";
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  }; # FIXME : Move to somewhere else
  fonts.packages = with pkgs-list.nix.latest; [nerd-fonts.jetbrains-mono]; # FIXME : Move to somewhere else
}
