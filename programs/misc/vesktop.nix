{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "vesktop";
in {
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}.";
  };
  imports = [];
  config = {
    programs.${name} = {
      enable = true;
    };
  };
}
