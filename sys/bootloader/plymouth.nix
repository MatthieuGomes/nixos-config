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
    name = "plymouth";
    main-repo = "nix";
    branch = "latest";
    togglable = false;
    options = {
      enable = lib.mkEnableOption "Enables ${name} related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  # TODO : Optimize kernelParams + Fix plyMouth them freezes and is not that smooth on boot.
  System = let
  in {
    boot = {
      consoleLogLevel = 3;
      initrd = {
        verbose = true;
        systemd.enable = true;
      };
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
      ];
      plymouth = {
        enable = true;
        theme = "pedro-raccoon";
        themePackages = [
          pkgs-list.others.customPkgs.plymouth-theme-pedro-raccoon
        ];
      };
    };
    environment.systemPackages = with packages.kdePackages; [
      plymouth-kcm
    ];
  };
})
