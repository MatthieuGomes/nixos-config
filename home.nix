{
  config,
  lib,
  inputs,
  pkgs-list,
  nixos-version,
  settings,
  tools,
  ...
} @ Inputs: let
  folder = "programs";
  context = "home";
in {
  imports =
    [
      (import ./programs.nix {inherit config lib inputs pkgs-list tools;}).config.homeModule
    ]
    ++ [
      pkgs-list.others.zen-browser.homeModules.beta
    ];
  inherit (settings) programs;

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
