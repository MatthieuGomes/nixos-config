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
    name = "autonumlock";
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
  System = {
    boot.initrd.systemd.services.autonumlock = {
      enable = true;
      serviceConfig = {
        ExecStart = "${packages.kbd}/bin/setleds +num";
        RemainAfterExit = true;
      };
    };
    services.displayManager.sddm = {
      autoNumlock = true;
      setupScript = "${packages.kbd}/bin/setleds +num";
    };
    environment.systemPackages = with packages; [
      kbd
    ];
  };
  Home = {
    programs.plasma = {
      input.keyboard.numlockOnStartup = "on";
      configFile.kcminputrc.Keyboard.NumLock = 0;
    };
  };
})
