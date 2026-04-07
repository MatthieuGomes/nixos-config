{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "dev-nix";
  subfolder = "nix";
  # repo = "";
  # branch = "";
  # packages = pkgs-list.${repo}.${branch};
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
          inherit config lib;
          inherit (Inputs) pkgs-list inputs;
        }).config.Home)
      imports;
      config = lib.mkIf cfg.enable {
        inherit (settings) nixd alejandra; # TODO : function to inherit all settings based on imports list
      };
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports =
        map (file: ./${subfolder}/${file}.nix) [
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.System)
        imports;
      config = lib.mkIf cfg.enable {
        inherit (settings) nixd alejandra;
      };
    };
  };
}
