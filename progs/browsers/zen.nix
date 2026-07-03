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
      bitwarden-ID = "446900e4-71c2-419f-a6a7-df9c091e268b";
      adBlocker-ID = "adblockultimate@adblockultimate.net";
      plasmaIntegration-ID = "plasma-browser-integration@kde.org";
      qwant-ID = "qwantcomforfirefox@jetpack";
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
        GenerativeAI = {
          Enabled = false;
        };
        TranslateEnabled = false;
        DisableSafeMode = true;
        DisableTelemetry = true;
        Extensions = {
          Locked = [
            extras.bitwarden-ID
            extras.adBlocker-ID
            extras.plasmaIntegration-ID
            extras.qwant-ID
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
