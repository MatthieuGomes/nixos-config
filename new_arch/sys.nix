{
  config,
  lib,
  pkgs-list,
  tools,
  baseSettings,
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
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." oldPathNames]);
  options.sys = {
    version = lib.mkOption {
      type = lib.types.str;
      default = "25.11";
      description = "The system state version.";
    };
  };
  newSettings.${name} = {
    lang = {
      timeZone = "America/Toronto";
      defaultLang = "en_US.UTF-8";
      keyboardLayout = "fr";
    };
  };
  settings = (lib.recursiveUpdate baseSettings newSettings).${name};
  inheritedSettings = tools.inheritSettings {
    inherit settings;
    inherit pathNames;
    inherit imports;
  };
in {
  inherit options;
  imports = tools.contextModuleImport {
    inherit imports subfolder tools pathNames lib config pkgs-list currentDirPath;
    inherit (Inputs) inputs;
    context = "System";
  };
  config =
    inheritedSettings
    // {
      system.stateVersion = config.sys.version;
      nix.settings.experimental-features = ["nix-command" "flakes"];
      boot.kernelPackages = packages.linuxPackages_latest;
    };
}
