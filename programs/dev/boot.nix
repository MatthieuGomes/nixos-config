{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "boot";
  subfolder = "boot";
  # repo = "";
  # branch = "";
  # packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    efibootmgr = lib.mkEnableOption "Enables and configures efibootmgr.";
    grub = lib.mkEnableOption "Enables and configures GRUB.";
    gparted = lib.mkEnableOption "Enables and configures GParted.";
    os-prober = lib.mkEnableOption "Enables and configures os-prober.";
  };
  cfg = config.${name};
  settings = {
    efibootmgr.enable = cfg.enable && cfg.efibootmgr;
    grub.enable = cfg.enable && cfg.grub;
    gparted.enable = cfg.enable && cfg.gparted;
    os-prober.enable = cfg.enable && cfg.os-prober;
    enable = cfg.enable && cfg.os-prober;
  };
in {
  config = {
    homeModule = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports =
        map (file: ./${subfolder}/${file}.nix) [
          "efibootmgr"
          "grub"
          "gparted"
          "os-prober"
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.homeModule) [];
      config = lib.mkIf cfg.enable {
        inherit (settings) efibootmgr grub gparted os-prober;
      };
    };
    nixosModule = {
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
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.nixosModule) [];
      config = lib.mkIf cfg.enable {
        # inherit (settings);
      };
    };
  };
}
