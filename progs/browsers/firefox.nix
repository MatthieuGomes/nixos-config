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
    name = "firefox";
    extras = {
      bitwarden-ID = "446900e4-71c2-419f-a6a7-df9c091e268b";
      adBlocker-ID = "adblockultimate@adblockultimate.net";
      plasmaIntegration-ID = "plasma-browser-integration@kde.org";
      qwant-ID = "qwantcomforfirefox@jetpack";
    };
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          # search = {
          #   default = "qwant";
          # };
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
            "browser.uiCustomization.state" = "{\"placements\":{\"unified-extensions-area\":[\"queryamoid_kaply_com-browser-action\",\"adblockultimate_adblockultimate_net-browser-action\",\"qwantcomforfirefox_jetpack-browser-action\",\"_${extras.bitwarden-ID}_browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"reset-pbm-toolbar-button\",\"urlbar-container\",\"downloads-button\",\"unified-extensions-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[],\"vertical-tabs\":[\"tabbrowser-tabs\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"queryamoid_kaply_com-browser-action\",\"adblockultimate_adblockultimate_net-browser-action\",\"developer-button\",\"screenshot-button\"],\"dirtyAreaCache\":[\"unified-extensions-area\",\"nav-bar\",\"toolbar-menubar\",\"TabsToolbar\",\"vertical-tabs\"],\"currentVersion\":23,\"newElementCount\":1}";
            "browser.uiCustomization.navBarWhenVerticalTabs" = "[\"back-button\",\"forward-button\",\"stop-reload-button\",\"reset-pbm-toolbar-button\",\"unified-extensions-button\",\"urlbar-container\",\"downloads-button\",\"unified-extensions-button\",\"fxa-toolbar-menu-button\"]";
            "services.sync.prefs.sync-seen.privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
            "services.sync.prefs.sync-seen.privacy.clearOnShutdown_v2.formData" = true;
            "sidebar.verticalTabs" = true;
            "sidebar.visibility" = "expand-on-hover";
            "sidebar.installed.extensions" = "{${extras.bitwarden-ID}}";
            "sidebar.main.tools" = "history,syncedtabs,bookmarks,{${extras.bitwarden-ID}}";

            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "extensions.pocket.enabled" = false;
            "extensions.pocket.api" = "";
            "extensions.pocket.oAuthConsumerKey" = "";
            "extensions.pocket.showHome" = false;
            "extensions.pocket.site" = "";
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
    };
  };
})
