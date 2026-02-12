{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "plasma";
  subfolder = "";
  repo = "nix";
  branch = "latest";
  packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
  };
  cfg = config.${name};
  # settings = {
  # };
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
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.homeModule) [];
      config = lib.mkIf cfg.enable {
        # inherit (settings);
        programs.plasma = {
          enable = true;
          window-rules = [
            {
              description = "vscode-desktop-file";
              match.window-class = "code code-url-handler";
              apply.desktopfile = "/run/current-system/etc/profiles/per-user/matthieu/share/applications/code.desktop"; # TODO: make this dynamic
            }
          ];
          shortcuts = {
            "services/com.mitchellh.ghostty.desktop" = {
              _launch = [
                "Meta+Return"
                "Ctrl+Alt+T"
              ];
              new-window = ["Meta+Shift+Return"];
            };
            "ksmserver" = {
              "Lock Session" = ["Meta+L"];
              "Sleep" = ["Meta+Shift+L"];
            };
          };
          workspace = {
            colorScheme = "KlassyDark";
            windowDecorations = {
              library = "org.kde.klassy";
              theme = "Klassy";
            };
            iconTheme = "Klassy Dark";
            theme = "klassy";
          };
          panels = [
            {
              location = "top";
              height = 27;
              screen = "all";
              opacity = "adaptive";
              alignment = "center";
              widgets = [
                "org.kde.plasma.trash"
                "org.kde.plasma.panelspacer"
                "org.kde.plasma.digitalclock"
                "org.kde.plasma.notifications"
                "org.kde.plasma.panelspacer"
                {
                  name = "org.kde.plasma.systemtray";
                  config = {};
                }
                "org.kde.plasma.volume"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.battery"
                {
                  name = "org.kde.plasma.lock_logout";
                  # settings = {
                  #   showLogoutScreen = true;
                  # };
                }
                # {
                #   name = "luisbocanegra.panelspacer.extended";
                #   config = {
                #     expand = true;
                #   };
                # }
                # "org.kde.plasma.systemmonitor"
              ];
            }
            {
              location = "bottom";
              height = 44;
              screen = "all";
              opacity = "adaptive";
              alignment = "left";
              hiding = "dodgewindows";
              widgets = [
                "org.kde.plasma.kicker"
                # "org.kde.plasma.kickerdash"
                {
                  name = "org.kde.plasma.icontasks";
                  config = {
                    taskDisplayMode = "IconsOnly";
                    showOnlyCurrentDesktop = true;
                    groupTasks = true;
                    launchers = with packages; [
                      "applications:systemsettings.desktop"
                      "applications:org.kde.dolphin.desktop"
                      "applications:firefox.desktop"
                      "applications:chromium-browser.desktop"
                      "applications:com.mitchellh.ghostty.desktop"
                      # "applications:code-url-handler.desktop"
                      "applications:code.desktop"
                    ];
                  };
                }
                "org.kde.plasma.showdesktop"
              ];
            }
          ];
        };
        home.packages = with packages.kdePackages; [
          sddm-kcm
          qtvirtualkeyboard
          breeze
        ];
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
        services = {
          desktopManager.plasma6.enable = true;
          displayManager = {
            sddm = {
              enable = true;
              wayland.enable = true;
              settings = {
                General = {
                  InputMethod = "qtvirtualkeyboard";
                };
              };
              autoNumlock = true;
            };
          };
        };
        environment.plasma6.excludePackages = with packages.kdePackages; [
          elisa
          konsole
          discover
        ];
      };
    };
  };
}
