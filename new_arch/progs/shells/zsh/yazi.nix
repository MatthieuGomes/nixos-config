{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  ######  # user defined
  name = "yazi";
  subfolder = null;
  main-repo = "nix";
  branch = "latest";
  imports = null;
  options = {
    enable = lib.mkEnableOption "Enables ${name} program and related settings.";
  };
  extras = rec {
  };
  settings = null;
  ######  # computed
  packages =
    if main-repo != null && branch != null
    then pkgs-list.${main-repo}.${branch}
    else null;
  currentPathAsList = parentPathAsList ++ [name];
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." parentPathAsList]);
  cfg = tools.inheritConfig {
    inherit config currentPathAsList;
  };
  inheritedSettings =
    if imports != null || settings != null
    then
      tools.inheritSettings {
        inherit currentPathAsList imports settings;
      }
    else {
    };
  Common =
    inheritedSettings
    // {
    };
  ######  # user defined
  Home = {
    programs.yazi = {
      enable = true;
      initLua = ../../../static/yazi/init.lua;
      settings = {
        mgr = {
          show_hidden = true;
          show_symlink = true;
        };
      };
      plugins = with packages.yaziPlugins;
        {
          inherit chmod;
          inherit sudo;
          inherit git;
          inherit rich-preview;
        }
        // {
          "githead" = ../../../static/yazi/plugins/githead;
          "kdeconnect-send" = ../../../static/yazi/plugins/kdeconnect-send;
        };
      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = ["<C-s>"];
              run = "plugin kdeconnect-send";
              desc = "Send selected files via KDE Connect";
            }
          ];
        };
      };
    };
  };
  System = {
  };
  ######  # computed
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  config = {
    Home = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
      inherit imports options; # user defined
      context = "Home";
      Config = HomeConfig;
    };
    System = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
      inherit imports options; # user defined
      context = "System";
      Config = SystemConfig;
    };
  };
}
