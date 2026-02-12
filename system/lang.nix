{
  config,
  lib,
  inputs,
  ...
}: let
in {
  options = {};
  imports = [];
  config = {
    time.timeZone = "America/Toronto";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_TIME = "fr_FR.UTF-8";
      };
    };
    console.keyMap = "fr";
    services.xserver.xkb.layout = "fr";
  };
}
