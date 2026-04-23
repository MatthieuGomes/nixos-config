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
    name = "yazi";
    subfolder = "yazi";
    main-repo = "nix";
    branch = "latest";
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs.yazi = {
      enable = true;
      initLua = ./${subfolder}/init.lua;
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
          "githead" = ./${subfolder}/plugins/githead;
          "kdeconnect-send" = ./${subfolder}/plugins/kdeconnect-send;
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
})
