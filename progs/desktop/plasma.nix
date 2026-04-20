# FIXME : Refactor this
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
    name = "plasma";
    main-repo = "nix";
    branch = "latest";
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs.plasma = {
      enable = true;
      configFile.kdeglobals.General = {
        TerminalApplication = "ghostty";
        TerminalService = "com.mitchellh.ghostty.desktop";
      };
      window-rules = [
        {
          description = "vscode-desktop-file";
          match.window-class = "code code";
          apply.desktopfile = "/run/current-system/etc/profiles/per-user/matthieu/share/applications/code.desktop"; # TODO: make this dynamic
        }
        {
          description = "fix_LibreOffice_Icon";
          match.window-class = {
            value = "libreoffice-draw";
            type = "substring";
            match-whole = true;
          };
          apply.desktopfile = {
            value = "/run/current-system/etc/profiles/per-user/matthieu/share/applications/draw.desktop";
            apply = "initially";
          };
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
                launchers = [
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
      filelight
      dolphin-plugins
    ];
  };
  System = {
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
})
