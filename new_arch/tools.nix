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
    currentPathAsList,
    imports,
    settings,
  }: let
    first = lib.lists.last (lib.lists.take 1 currentPathAsList);
  in
    builtins.listToAttrs (map (setting: {
        name =
          if (currentPathAsList == [])
          then setting
          else first;
        value =
          if (currentPathAsList == [])
          then settings.${setting}
          else
            (inheritSettings {
              currentPathAsList = lib.lists.drop 1 currentPathAsList;
              imports = imports;
              settings = settings;
            });
      })
      imports);
  contextModuleImport = {
    imports,
    subfolder,
    context,
    currentDirPath,
    ...
  } @ basicDependencies:
    map (file:
      (import ./${currentDirPath}/${subfolder}/${file}.nix {
        inherit (basicDependencies) inputs config lib pkgs-list tools;
        parentPathAsList = basicDependencies.currentPathAsList;
      }).config.${
        context
      })
    imports;

  inheritConfig = {
    currentPathAsList,
    config,
  }: let
    first = lib.lists.last (lib.lists.take 1 currentPathAsList);
  in
    if (currentPathAsList == [])
    then config
    else
      inheritConfig {
        currentPathAsList = lib.lists.drop 1 currentPathAsList;
        config = config.${first};
      };

  inheritOptions = {
    currentPathAsList,
    options,
  }: let
    first = lib.lists.last (lib.lists.take 1 currentPathAsList);
  in (lib.listToAttrs [
    {
      name = first;
      value =
        if (currentPathAsList == [first])
        then options
        else
          inheritOptions {
            currentPathAsList = lib.lists.drop 1 currentPathAsList;
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
