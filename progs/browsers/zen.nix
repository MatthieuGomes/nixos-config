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
    name = "zen";
    extras = {
      bitwarden = "446900e4-71c2-419f-a6a7-df9c091e268b";
      adBlocker = "adblockultimate@adblockultimate.net";
      plasmaIntegration = "plasma-browser-integration@kde.org";
      qwant = "qwantcomforfirefox@jetpack";
      qwantSearch = "qwant-search-firefox@qwant.com";
      hideAI = "Google_AI_Overviews_Blocker@zachbarnes.dev";
      googleUnlocked = "{1dccf21b-8742-4e2e-be36-47263c80c425}";
    };
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    specialImports = {
      Home = [pkgs-list.others.zen-browser.homeModules.beta];
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs.zen-browser = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          search = let
            pkgs = pkgs-list.nix.latest;
          in {
            force = true;
            default = "qwant";
            privateDefault = "qwant";
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np"];
              };

              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@no"];
              };

              "NixOS Wiki" = {
                urls = [
                  {
                    template = "https://wiki.nixos.org/w/index.php";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@nw"];
              };
            };
          };
          settings = {
            "privacy.donottrackheader.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "privacy.partition.network_state.ocsp_cache" = true;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.ping-centre.telemetry" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.hybridContent.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "experiments.activeExperiment" = false;
            "experiments.enabled" = false;
            "experiments.supported" = false;
            "network.allow-experiments" = false;
            "services.sync.username" = "nehril012601@gmail.com";
            "services.sync.prefs.sync-seen.privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
            "services.sync.prefs.sync-seen.privacy.clearOnShutdown_v2.formData" = true;
          };
        };
      };
      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardsEnabled = false;
        DisableFirefoxStudies = true;
        DisableFormHistory = true;
        DisablePasswordReveal = true;
        DisableFirefoxScreenshots = true;
        DisableForgetButton = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        PrimaryPassword = false;
        SkipTermsOfUse = true;
        DontCheckDefaultBrowser = true;
        OverrideFirstRunPage = true;
        DisableRemoteImprovements = true;
        DisableFeedbackCommands = true;
        AIControls = {
          Default = {
            Value = "blocked";
            Locked = true;
          };
        };
        GenerativeAI = {
          Enabled = false;
        };
        TranslateEnabled = false;
        DisableSafeMode = true;
        DisableTelemetry = true;

        ExtensionSettings = let
          mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
            installation_mode = "force_installed";
          });
        in
          mkExtensionSettings {
            "adblockultimate@adblockultimate.net" = "adblocker-ultimate";
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
            "{1dccf21b-8742-4e2e-be36-47263c80c425}" = "googleunlocked";
            "Google_AI_Overviews_Blocker@zachbarnes.dev" = "hide-google-ai-overviews";
            "plasma-browser-integration@kde.org" = "plasma-integration";
            "qwant-search-firefox@qwant.com" = "qwant-the-search-engine";
            "qwantcomforfirefox@jetpack" = "qwantcom-for-firefox";
          };
        Extensions = {
          Locked = with extras; [
            bitwarden
            adBlocker
            plasmaIntegration
            qwant
            qwantSearch
            hideAI
            googleUnlocked
          ];
        };
        HomePage = {
          StartPage = "none";
        };
        # SanitizeOnShutdown = {
        #   Cache = true;
        #   Cookies = true;
        #   FormData = true;
        #   History = false;
        #   Sessions = false;
        #   SiteSettings = false;
        #   Downloads = false;
        # };
        Cookies = {
          Allow = [
            "https://www.youtube.com"
            "https://www.google.com"
            "https://www.facebook.com"
            "https://web.whatsapp.com"
            "https://chat.mistral.ai/chat"
          ];
        };
      };
      # TODO: profiles, settings, etc.
    };
  };
})
