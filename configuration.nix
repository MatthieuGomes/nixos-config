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

  sys = with baseSettings.sys; {
    label = label;
    tags = tags;
    version = version;
    hostname = hostname;
    main-user = main-user;
  };
  # environment.systemPackages = with pkgs-list.nix.latest; [wmctrl];
  networking.hostName = config.sys.hostname;
  system.nixos = {
    label = config.sys.label;
    tags = config.sys.tags;
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
