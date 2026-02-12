{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "zen";
  cfg = config.${name};
  repos = "nur";
  branch = "unstable";
  packages = inputs.${repos}.${branch};
in {
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures Zen Browser.";
  };
  imports = [];
  config = {
    programs.zen-browser = {
      enable = true;
      # profiles = {
      #   default = {
      #     search = {
      #       default = "Qwant";
      #       extensions = {
      #         packages = with packages.repos.rycee.firefox-addons; [
      #           bitwarden
      #           plasma-integration
      #           ad-block-ultimate
      #         ];
      #       };
      #     };
      #   };
      # };
    };
  };
}
