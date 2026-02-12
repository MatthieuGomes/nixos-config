{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  # name = "filesystems";
  folder = "filesystems";
  # cfg = config.${name};
  # settings = {
  #   ntfs.enable = cfg.enable && cfg.ntfs;
  #   exfat.enable = cfg.enable && cfg.exfat;
  #   btrfs.enable = cfg.enable && cfg.btrfs;
  # };
in {
  # options.${name} = {
  #   enable = lib.mkEnableOption "Enables and configures ${name}.";
  #   ntfs = lib.mkEnableOption "Enables and configures NTFS filesystem support.";
  #   exfat = lib.mkEnableOption "Enables and configures exFAT filesystem support.";
  #   btrfs = lib.mkEnableOption "Enables and configures Btrfs filesystem support.";
  # };
  imports = map (file: ./${folder}/${file}) [
    "exfat.nix"
    "btrfs.nix"
    "ntfs.nix"
  ];
  config = {
    # inherit (settings) ntfs exfat btrfs;
  };
}
