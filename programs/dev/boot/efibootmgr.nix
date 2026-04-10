{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  ...
} @ Inputs: let
  name = "efibootmgr";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  cfg = config.${name};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures EFIBOOTMGR.";
  };
in {
  config = {
    Home = {
      lib,
      config,
      ...
    }: {
      inherit options;
      config = lib.mkIf cfg.enable {
        home.packages = with packages; [
          efibootmgr
        ];
      };
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      config =
        lib.mkIf cfg.enable {
        };
    };
  };
}
