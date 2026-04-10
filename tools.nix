{lib, ...}: let
  importWithAndContextArgs = {
    file,
    context,
    args,
  }:
    (
      import file
      args
    ).config.${
      context
    };

  importWithArgs = {
    file,
    args,
  }:
    (import file args).config;

  contextArgsImport = {
    file,
    context,
    args,
  }:
    (importWithArgs {
      inherit file args;
    }).${
      context
    };

  defaultContextArgsImport = {
    file,
    context,
    args,
  }: {
    file,
    context,
  }: (
    contextArgsImport file context args
  );
  contextualModule = {
    name,
    config,
    lib,
    options,
    import-list ? [],
    context,
  }: let
    cfg = config.${name};
  in {
    config = lib.mkIf cfg.enable {
      inherit options;
      imports = import-list;
    };
  };
  inheritSettings = {
    pathNames,
    imports,
    settings,
  }: let
    importsWithEnable = imports ++ ["enable"];
    first = lib.lists.last (lib.lists.take 1 pathNames);
    last = lib.lists.last pathNames;
  in
    builtins.listToAttrs (map (setting: {
        name = first;
        value =
          if (first == last)
          then settings.${setting}
          else
            (inheritSettings {
              pathNames = lib.lists.drop 1 pathNames;
              imports = importsWithEnable;
              settings = settings;
            });
      })
      importsWithEnable);
  unversialModule = {
    lib,
    config,
    pkgs-list,
    inputs,
    name,
    subfolder ? null,
    options,
    imports ? [],
    settings ? {},
    pathNames ? [name],
    Home ? {},
    System ? {},
  } @ Inputs: let
    cfg = config.${name};
    fullPathNames = pathNames ++ [name];
  in {
    config = {
      Home = {
        lib,
        config,
        ...
      }: {
        inherit options;
        imports =
          if Inputs.imports
          then
            map (file:
              (import ./${subfolder}/${file}.nix {
                inherit config;
                inherit lib;
                inherit (Inputs) pkgs-list inputs;
              }).config.Home)
            Inputs.imports
          else [];
        config =
          lib.mkIf cfg.enable (inheritSettings {
            pathNames = fullPathNames;
            imports = imports;
            settings = settings;
          })
          // Home;
      };
      System = {
        lib,
        config,
        ...
      }: {
        inherit options;
        imports = map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.System)
        imports;
        config =
          lib.mkIf cfg.enable (inheritSettings {
            pathNames = fullPathNames;
            imports = imports;
            settings = settings;
          })
          // System;
      };
    };
  };
in {
  inherit importWithArgs contextArgsImport defaultContextArgsImport inheritSettings;
  # multiContextModule;
}
