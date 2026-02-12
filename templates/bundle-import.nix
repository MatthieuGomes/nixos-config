{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  folder = "";
in {
  options = {};
  imports = map (file: ./${folder}/${file}) [];
  config = {};
}
