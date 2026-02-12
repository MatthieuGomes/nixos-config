{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  # name = "btrfs";
  repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${repo}.${branch};
  # cfg = config.${name};
in {
  # options.${name} = {
  #   enable = lib.mkEnableOption "Enables and configures Btrfs.";
  # };
  imports = [];
  config = {
    #lib.mkIf cfg.enable
    environment.systemPackages = with packages; [
      btrfs-progs
    ];
    boot.supportedFilesystems = {
      btrfs = true;
    };
  };
}
