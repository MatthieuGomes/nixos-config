{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  latest = Inputs.pkgs-list.nix.latest;
in {
  options = {};
  imports = [];
  config = {
    users = {
      defaultUserShell = latest.zsh;
      users = {
        matthieu = {
          description = "Moi";
          isNormalUser = true;
          group = "users";
          extraGroups = [
            "wheel"
            "docker"
            "libvirtd"
          ]; # Enable ‘sudo’ for the user.
          createHome = true;
          home = "/home/matthieu";
          /*
          openssh.authorizedKeys.keys = [
            ""
          ];
          */
        };
      };
      groups = {
        libvirtd.members = ["matthieu"];
      };
    };
  };
}
