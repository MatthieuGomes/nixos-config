{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "pipewire";
in {
  options = {};
  imports = [];
  config = {
    services.${name} = {
      enable = true;
      pulse.enable = true;
    };
  };
}
