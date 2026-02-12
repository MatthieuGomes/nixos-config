{
  config,
  lib,
  inputs,
  pkgs-list,
  nixos-version,
  opt,
  ...
} @ Inputs: let
  folder = "programs";
  context = "home";
in {
  imports =
    [
      (import ./programs.nix {inherit config lib inputs pkgs-list;}).config.homeModule
    ]
    ++ [
      pkgs-list.others.zen-browser.homeModules.beta
    ];
  inherit (opt) programs;

  home.stateVersion = nixos-version;
  home.username = "matthieu";
  home.homeDirectory = "/home/matthieu";
  # TODO: Move to another folder later
  # home.packages = with Inputs.pkgs-list.nix.latest; [
  #   ntfs3g
  #   ntfsprogs
  #   btrfs-progs
  #   exfat
  #   exfatprogs
  # ];
}
