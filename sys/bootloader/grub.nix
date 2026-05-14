{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
    name = "grub";
    main-repo = "nix";
    branch = "latest";
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    home.packages = with packages; [
      grub2
    ];
  };
  System = {
    boot = {
      loader = {
        grub = {
          enable = true;
          devices = ["nodev"];
          efiSupport = true;
          useOSProber = true;
          extraEntries = let
            extraEntryFolder = "./extraEntries";
          in ''
            ${builtins.readFile "${./${extraEntryFolder}/00_Arch_Btrfs}"}
            ${builtins.readFile "${./${extraEntryFolder}/99_UEFI_Firmware}"}
          '';
          backgroundColor = "#000000";
          # theme = "${packages.kdePackages.breeze-grub}/grub/themes/breeze";
          splashImage = null;
        };
        timeout = 1;
      };
    };
  };
})
