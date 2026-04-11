{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "dev-nix";
  subfolder = "nix";
  # repo = "";
  # branch = "";
  # packages = pkgs-list.${repo}.${branch};
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    nixd = lib.mkEnableOption "Enables and configures Nixd.";
    alejandra = lib.mkEnableOption "Enables and configures Alejandra.";
  };
  cfg = config.${name};
  settings = {
    nixd.enable = cfg.enable && cfg.nixd;
    alejandra.enable = cfg.enable && cfg.alejandra;
  };
  imports = ["alejandra" "nixd"];
  inheritedSettings = tools.inheritSettings {
    inherit pathNames imports settings;
  };
  Common = {
    inherit (settings) nixd alejandra;
  };
  Home = {
  };
  System = {
  };
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  config = {
    Home = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports = map (file:
        (import ./${subfolder}/${file}.nix {
          inherit config lib pkgs-list tools;
          inherit (Inputs) inputs;
          oldPathNames = pathNames;
        }).config.Home)
      imports;
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports = map (file:
        (import ./${subfolder}/${file}.nix {
          inherit config lib pkgs-list tools;
          inherit (Inputs) inputs;
          oldPathNames = pathNames;
        }).config.System)
      imports;
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
