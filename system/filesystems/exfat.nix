{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  # name = "exfat";
  repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${repo}.${branch};
  # cfg = config.${name};
in {
  # options = {
  #   enable = lib.mkEnableOption "Enables and configures exFAT.";
  # };
  imports = [];
  config = {
    #lib.mkIf cfg.enable
    environment.systemPackages = with packages; [
      exfat
      exfatprogs
    ];
    boot.supportedFilesystems = {
      exfat = true;
    };
  };
}
