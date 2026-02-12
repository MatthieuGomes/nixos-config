{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  latest = Inputs.latest;
in {
  options = {
    yazi.enable = lib.mkEnableOption "Enable Yazi file manager for Zsh.";
  };
  imports = [];
  config = lib.mkIf config.yazi.enable {
    programs.yazi = {
      enable = true;
      plugins = with latest.yaziPlugins;
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
      settings = {
        mgr = {
          show_hidden = true;
          show_symlink = true;
        };
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
      initLua = ../../../static/yazi/init.lua;
    };
  };
}
