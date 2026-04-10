{
  config,
  lib,
  pkgs-list,
  inheritSettings,
  ...
} @ Inputs: let
  name = "programs";
  subfolder = "programs";
  repo = "nix";
  branch = "latest";
  packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    shells = {
      enable = lib.mkEnableOption "Enable various shell configurations.";
      zsh = lib.mkEnableOption "Enable Zsh shell configuration.";
    };
    misc = {
      enable = lib.mkEnableOption "Enables and configures miscellaneous programs.";
      ledger = lib.mkEnableOption "Enables and configures Ledger support.";
      bambu-studio = lib.mkEnableOption "Enables and configures Bambu Studio.";
      bitwarden = lib.mkEnableOption "Enables and configures Bitwarden.";
      fastfetch = lib.mkEnableOption "Enables and configures Fastfetch.";
      iso-image-writer = lib.mkEnableOption "Enables and configures ISO Image Writer.";
      kdeconnect = lib.mkEnableOption "Enables and configures KDE Connect.";
      vesktop = lib.mkEnableOption "Enables and configures Vesktop.";
    };
    office = {
      enable = lib.mkEnableOption "Enables and configures office applications.";
      libreoffice = lib.mkEnableOption "Enables and configures LibreOffice.";
      qualculate = lib.mkEnableOption "Enables and configures Qualculate.";
    };
    dev = {
      enable = lib.mkEnableOption "Enables and configures development tools.";
      docker = lib.mkEnableOption "Enables and configures Docker.";
      boot = lib.mkOption {
        type = lib.types.attrsOf lib.types.bool;
        description = "Enables and configures boot related tools.";
      };
      dev-nix = lib.mkOption {
        type = lib.types.attrsOf lib.types.bool;
        description = "Enables and configures Nix related tools.";
      };
      network = lib.mkEnableOption "Enables and configures Network tools.";
      vim = lib.mkEnableOption "Enables and configures Vim.";
      vscode = lib.mkEnableOption "Enables and configures VSCode.";
      postman = lib.mkEnableOption "Enables and configures Postman.";
      git = lib.mkEnableOption "Enables and configures Git.";
      ghostty = lib.mkEnableOption "Enables and configures Ghostty.";
    };
    browsers = {
      enable = lib.mkEnableOption "Enables and configures web browsers.";
      firefox = lib.mkEnableOption "Enables and configures Firefox.";
      chromium = lib.mkEnableOption "Enables and configures Chromium.";
    };
    desktop = {
      enable = lib.mkEnableOption "Enables and configures desktop environment.";
      plasma = lib.mkEnableOption "Enables and configures KDE Plasma.";
      klassy = lib.mkEnableOption "Enables and configures Klassy.";
      rofi = lib.mkEnableOption "Enables and configures Rofi.";
    };
  };
  cfg = config.${name};
  settings = {
    dev = {
      enable = cfg.enable;
      docker = cfg.enable && cfg.dev.docker;
      boot = rec {
        enable = cfg.enable && cfg.dev.boot.enable;
        efibootmgr = enable && cfg.dev.boot.efibootmgr;
        grub = enable && cfg.dev.boot.grub;
        gparted = enable && cfg.dev.boot.gparted;
        os-prober = enable && cfg.dev.boot.os-prober;
      };
dev-nix = rec {
        enable = cfg.enable && cfg.dev.dev-nix.enable;
        nixd = enable && cfg.dev.dev-nix.nixd;
        alejandra = enable && cfg.dev.dev-nix.alejandra;
      };
      network = cfg.enable && cfg.dev.network;
      git = cfg.enable && cfg.dev.git;
      postman = cfg.enable && cfg.dev.postman;
      vscode = cfg.enable && cfg.dev.vscode;
      vim = cfg.enable && cfg.dev.vim;
      ghostty = cfg.enable && cfg.dev.ghostty;
    };
    shells = rec {
      enable = cfg.shells.enable;
      zsh = enable && cfg.shells.zsh;
    };
    misc = rec {
      enable = cfg.misc.enable;
      ledger = enable && cfg.misc.ledger;
      bambu-studio = enable && cfg.misc.bambu-studio;
      bitwarden = enable && cfg.misc.bitwarden;
      fastfetch = enable && cfg.misc.fastfetch;
      iso-image-writer = enable && cfg.misc.iso-image-writer;
      kdeconnect = enable && cfg.misc.kdeconnect;
      vesktop = enable && cfg.misc.vesktop;
    };
    office = rec {
      enable = cfg.office.enable;
      libreoffice = enable && cfg.office.libreoffice;
      qualculate = enable && cfg.office.qualculate;
    };
    browsers = rec {
      enable = cfg.browsers.enable;
      firefox = enable && cfg.browsers.firefox;
      chromium = enable && cfg.browsers.chromium;
    };
    desktop = rec {
      enable = cfg.desktop.enable;
      plasma = enable && cfg.desktop.plasma;
      klassy = enable && cfg.desktop.klassy;
      rofi = enable && cfg.desktop.rofi;
    };
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
          # "desktop"
          # "boot-dev"
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
            oldPathNames = pathNames;
            inherit inheritSettings;
          }).config.homeModule) ["dev" "misc" "shells" "office" "browsers" "desktop"];
      config = lib.mkIf cfg.enable {
        inherit (settings) dev shells misc office browsers desktop;
        programs = {
          thunderbird = {
            enable = true;
            profiles = {};
          };
        };
        # meld = {
        #   enable = true;
        # };
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
            oldPathNames = pathNames;
            inherit (Inputs) inheritSettings;
          }).config.nixosModule) ["dev" "misc" "shells" "office" "desktop"];
      config = lib.mkIf cfg.enable {
        inherit (settings) dev shells misc office desktop;
        environment.systemPackages = with packages; [
          mangohud
          plocate
          mlocate
          xdotool
          protonup-ng
          meld
          wget
        ];
        environment.sessionVariables = {
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/user/.steam/root/compatibilitytools.d";
        };
        programs = {
          gamemode.enable = true;
          steam = {
            enable = true;
            gamescopeSession.enable = true;
          };
          virt-manager.enable = true;
        };
      };
    };
  };
}
