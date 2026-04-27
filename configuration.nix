# FEAT : unify format
{
  config,
  lib,
  inputs,
  pkgs-list,
  managers,
  baseSettings,
  tools,
  ...
}: let
  import_with_args = file: context:
    (import file {
      inherit config lib inputs pkgs-list tools baseSettings;
      parentPathAsList = [];
    }).config.${
      context
    };
in {
  imports =
    [
      (import
        ./sys.nix
        {
          inherit config lib pkgs-list tools inputs baseSettings;
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
  sys.version = baseSettings.sys.version;
  # environment.systemPackages = with pkgs-list.nix.latest; [wmctrl];
  networking.hostName = baseSettings.sys.hostname;
  system.nixos = {
    label = baseSettings.sys.label;
    tags = baseSettings.sys.tags;
  };
  virtualisation = {
    vmVariant = {
      # the following configuration is added only when building VM with `build-vm`
      virtualisation = {
        memorySize = 2048; # use 2048MiB memory
        cores = 3; # use 3 cpu cores
      };
    };
  };
}
