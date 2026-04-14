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
    first = lib.lists.last (lib.lists.take 1 pathNames);
  in
    builtins.listToAttrs (map (setting: {
        name =
          if (pathNames == [])
          then setting
          else first;
        value =
          if (pathNames == [])
          then settings.${setting}
          else
            (inheritSettings {
              pathNames = lib.lists.drop 1 pathNames;
              imports = imports;
              settings = settings;
            });
      })
      imports);
  contextModuleImport = {
    imports,
    subfolder,
    context,
    ...
  } @ basicDependencies:
    map (file:
      (import ./${subfolder}/${file}.nix {
        inherit (basicDependencies) inputs config lib pkgs-list tools;
        oldPathNames = basicDependencies.pathNames;
      }).config.${
        context
      })
    imports;

  inheritConfig = {
    pathNames,
    config,
  }: let
    first = lib.lists.last (lib.lists.take 1 pathNames);
  in
    if (pathNames == [])
    then config
    else
      inheritConfig {
        pathNames = lib.lists.drop 1 pathNames;
        config = config.${first};
      };

  inheritOptions = {
    pathNames,
    options,
  }: let
    first = lib.lists.last (lib.lists.take 1 pathNames);
  in (lib.listToAttrs [
    {
      name = first;
      value =
        if (pathNames == [first])
        then options
        else
          inheritOptions {
            pathNames = lib.lists.drop 1 pathNames;
            inherit options;
          };
    }
  ]);

  universalModule = {
    lib,
    config,
    pkgs-list,
    inputs,
    name,
    subfolder ? null,
    options,
    imports ? [],
    settings ? {},
    oldPathNames ? [name],
    Home ? {},
    System ? {},
  } @ Inputs: let
    cfg = config.${name};
    pathNames = oldPathNames ++ [name];
    fullPath = lib.concatStringsSep "." pathNames;
    options.${fullPath} = options;
    settings.${fullPath} = settings;
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
            pathNames = pathNames;
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
            pathNames = pathNames;
            imports = imports;
            settings = settings;
          })
          // System;
      };
    };
  };
in {
  inherit importWithArgs contextArgsImport defaultContextArgsImport inheritSettings universalModule contextModuleImport inheritConfig inheritOptions;
  # multiContextModule;
}
