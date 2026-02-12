{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  main-repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${main-repo}.${branch};
in {
  options = {};
  imports = [];
  config = {
    programs.plasma = {
      enable = true;
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
    };
    # services.desktopManager.plasma6.enable = true;
  };
}
