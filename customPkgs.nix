{pkgs ? import <nixpkgs> {}}:
pkgs.lib.filesystem.packagesFromDirectoryRecursive {
  callPackage = pkgs.callPackage;
  directory = ./customPkgs;
}
