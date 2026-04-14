{
  config,
  lib,
  pkgs-list,
  tools,
  settings,
  ...
} @ Inputs: let
  name = "sys";
  subfolder = "sys";
  repo = "nix";
  branch = "unstable";
  packages = pkgs-list.${repo}.${branch};
  imports = [
    "bootloader"
    "lang"
    "users"
    "hardware"
    "networking"
    "filesystems"
  ];
  oldPathNames = [];
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames; # NOTE : Doesnt work as intended, need a function to generate the full path
  options.sys = {
    version = lib.mkOption {
      type = lib.types.str;
      default = "25.11";
      description = "The system state version.";
    };
  };
  inhritedSettings.sys.users.enable = settings.sys.users.enable;
  inheritedSettings = tools.inheritSettings {
    settings = settings.sys;
    inherit pathNames;
    inherit imports;
  };
in {
  inherit options;
  imports = map (file:
    (import ./${subfolder}/${file}.nix
      {
        inherit config lib pkgs-list tools;
        inherit (Inputs) inputs;
        oldPathNames = pathNames;
      }).config.System)
  imports;
  config =
    inheritedSettings
    // {
      system.stateVersion = config.sys.version;
      nix.settings.experimental-features = ["nix-command" "flakes"];
      boot.kernelPackages = packages.linuxPackages_latest;
    };
}
