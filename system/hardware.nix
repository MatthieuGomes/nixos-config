{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${repo}.${branch};
in {
  options = {};
  imports = map (file: ./hardware/${file}) [
    "nvidia.nix"
    "printer.nix"
    "sound.nix"
  ];
  config = {
    nvidia.enable = false;
    # Enable Ledger hardware wallet support, seeing if better options are possible
    hardware = {
      # ledger.enable = true;
      bluetooth.enable = true;
    };
    # not sure where to put it yet TODO : FIX
    services.libinput.enable = true;
    services.blueman.enable = true;
    # services.xserver.videoDrivers =
    environment.systemPackages = with packages; [
      lshw
      iw
    ];
  };
}
