{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "misc";
  subfolder = "misc";
  # repo = "nix";
  # branch = "latest";
  # packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    ledger = lib.mkEnableOption "Enables and configures Ledger support.";
    bambu-studio = lib.mkEnableOption "Enables and configures Bambu Studio.";
    bitwarden = lib.mkEnableOption "Enables and configures Bitwarden.";
    fastfetch = lib.mkEnableOption "Enables and configures Fastfetch.";
    iso-image-writer = lib.mkEnableOption "Enables and configures ISO Image Writer.";
    kdeconnect = lib.mkEnableOption "Enables and configures KDE Connect.";
    vesktop = lib.mkEnableOption "Enables and configures Vesktop.";
  };
  cfg = config.${name};
  settings = {
    ledger.enable = cfg.enable && cfg.ledger;
    bambu-studio.enable = cfg.enable && cfg.bambu-studio;
    bitwarden.enable = cfg.enable && cfg.bitwarden;
    fastfetch.enable = cfg.enable && cfg.fastfetch;
    iso-image-writer.enable = cfg.enable && cfg.iso-image-writer;
    kdeconnect.enable = cfg.enable && cfg.kdeconnect;
    vesktop.enable = cfg.enable && cfg.vesktop;
  };
in {
  config = {
    Home = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports =
        map (file: ./${subfolder}/${file}.nix) [
          "bambu-studio"
          "bitwarden"
          "fastfetch"
          "iso-image-writer"
          "vesktop"
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.Home) ["ledger" "kdeconnect"];
      config = lib.mkIf cfg.enable {
        inherit (settings) ledger bambu-studio bitwarden fastfetch iso-image-writer vesktop kdeconnect;
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
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.System) ["ledger" "kdeconnect"];
      config = lib.mkIf cfg.enable {
        inherit (settings) ledger kdeconnect;
      };
    };
  };
}
