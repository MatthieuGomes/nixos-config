{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  # name = "ntfs";
  repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${repo}.${branch};
  # cfg = config.${name};
in {
  # options = {
  #   enable = lib.mkEnableOption "Enables and configures NTFS.";
  # };
  imports = [];
  config = {
    # lib.mkIf cfg.enable
    environment.systemPackages = with packages; [
      ntfs3g
      ntfsprogs
    ];
    boot.supportedFilesystems = {
      ntfs = true;
    };
  };
}
