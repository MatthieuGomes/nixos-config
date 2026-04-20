{lib, ...}: let
  contextModuleImport = {
    imports,
    subfolder,
    context,
    currentDirPath,
    ...
  } @ deps:
    map (file:
      (import ./${currentDirPath}/${subfolder}/${file}.nix {
        inherit (deps) inputs config lib pkgs-list tools;
        parentPathAsList = deps.currentPathAsList;
      }).config.${
        context
      })
    imports;

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
  contextualModule = {
    options ? null,
    imports ? null,
    specialImports ? null,
    togglable ? true,
    Config,
    context,
    ...
  } @ deps: {
    lib,
    config,
    ...
  }: let
    inherit (deps) subfolder tools currentPathAsList lib config pkgs-list currentDirPath inputs;
  in
    (
      if options != null
      then {
        options = tools.inheritOptions {
          inherit currentPathAsList options;
        };
      }
      else {
      }
    )
    // (
      if imports != null
      then {
        imports =
          tools.contextModuleImport {
            inherit imports subfolder tools currentPathAsList lib config pkgs-list currentDirPath inputs;
            context = context;
          }
          ++ (
            if specialImports != null
            then
              if builtins.hasAttr context specialImports
              then specialImports.${context}
              else []
            else []
          );
      }
      else
        (
          if specialImports != null
          then {
            imports =
              if builtins.hasAttr context specialImports
              then specialImports.${context}
              else [];
          }
          else {
          }
        )
    )
    // {
      config =
        if togglable
        then (lib.mkIf deps.cfg.enable Config)
        else Config;
    };

  moduleParams = {
    config,
    lib,
    pkgs-list,
    parentPathAsList,
    tools,
    name,
    togglable ? true,
    subfolder ? null,
    main-repo ? null, # pas sur que ce soit necessaire plus j'y reflechis.
    branch ? null, # pas sur que ce soit necessaire plus j'y reflechis.
    imports ? null,
    specialImports ? null,
    options ? null,
    settings ? null,
    extras ? null,
  }: rec {
    inherit config lib pkgs-list parentPathAsList tools;
    inherit name togglable subfolder main-repo branch imports specialImports options settings extras;
    packages =
      if main-repo != null && branch != null
      then pkgs-list.${main-repo}.${branch}
      else null;
    currentPathAsList = parentPathAsList ++ [name];
    currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." parentPathAsList]);
    cfg = tools.inheritConfig {
      inherit config currentPathAsList;
    };
    inheritedSettings =
      if imports != null || settings != null
      then
        tools.inheritSettings {
          inherit currentPathAsList imports settings;
        }
      else {
      };
    Common =
      inheritedSettings
      // {
      };
  };
  fullModule = {
    config,
    lib,
    pkgs-list,
    parentPathAsList,
    tools,
    name,
    togglable ? true,
    subfolder ? null,
    main-repo ? null, # pas sur que ce soit necessaire plus j'y reflechis.
    branch ? null, # pas sur que ce soit necessaire plus j'y reflechis.
    imports ? null,
    specialImports ? null,
    options ? null,
    settings ? null,
    extras ? null,
    packages ? null,
    currentPathAsList,
    currentDirPath,
    cfg,
    inheritedSettings,
    Common,
    Home ? {},
    System ? {},
  }: let
    HomeConfig = Common // Home;
    SystemConfig = Common // System;
  in {
    config = {
      Home = tools.contextualModule {
        inherit lib config tools; # deps
        inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
        inherit imports options; # user defined
        inherit specialImports; # user defined
        inherit togglable; # user defined
        context = "Home";
        Config = HomeConfig;
      };
      System = tools.contextualModule {
        inherit lib config tools; # deps
        inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
        inherit imports options; # user defined
        inherit specialImports; # user defined
        inherit togglable; # user defined
        context = "System";
        Config = SystemConfig;
      };
    };
  };
in {
  inherit inheritSettings contextModuleImport inheritConfig inheritOptions contextualModule moduleParams fullModule;
}
