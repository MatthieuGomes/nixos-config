{lib, ...}:
with lib; let
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
    first = lists.last (lists.take 1 currentPathAsList);
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
              currentPathAsList = lists.drop 1 currentPathAsList;
              imports = imports;
              settings = settings;
            });
      })
      imports);

  inheritConfig = {
    currentPathAsList,
    config,
  }: let
    first = lists.last (lists.take 1 currentPathAsList);
  in
    if (currentPathAsList == [])
    then config
    else
      inheritConfig {
        currentPathAsList = lists.drop 1 currentPathAsList;
        config = config.${first};
      };

  inheritOptions = {
    currentPathAsList,
    options,
  }: let
    first = lists.last (lists.take 1 currentPathAsList);
  in (listToAttrs [
    {
      name = first;
      value =
        if (currentPathAsList == [first])
        then options
        else
          inheritOptions {
            currentPathAsList = lists.drop 1 currentPathAsList;
            inherit options;
          };
    }
  ]);
  contextualModule = {
    options ? null,
    specialOptions ? null,
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
        options =
          inheritOptions {
            inherit currentPathAsList options;
          }
          // (
            if specialOptions != null
            then
              if builtins.hasAttr context specialOptions
              then specialOptions
              else {}
            else {}
          );
      }
      else {
      }
    )
    // (
      if imports != null
      then {
        imports =
          contextModuleImport {
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
        then (mkIf deps.cfg.enable Config)
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
    specialOptions ? null,
    settings ? null,
    extras ? null,
  }: rec {
    inherit config lib pkgs-list parentPathAsList tools;
    inherit name togglable subfolder main-repo branch imports specialImports options specialOptions settings extras;
    packages =
      if main-repo != null && branch != null
      then pkgs-list.${main-repo}.${branch}
      else null;
    currentPathAsList = parentPathAsList ++ [name];
    currentDirPath = path.subpath.join (lists.flatten ["./." parentPathAsList]);
    cfg = inheritConfig {
      inherit config currentPathAsList;
    };
    inheritedSettings =
      if imports != null || settings != null
      then
        inheritSettings {
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
    specialOptions ? null,
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
      Home = contextualModule {
        inherit lib config tools; # deps
        inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
        inherit imports options; # user defined
        inherit specialImports specialOptions; # user defined
        inherit togglable; # user defined
        context = "Home";
        Config = HomeConfig;
      };
      System = contextualModule {
        inherit lib config tools; # deps
        inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
        inherit imports options; # user defined
        inherit specialImports specialOptions; # user defined
        inherit togglable; # user defined
        context = "System";
        Config = SystemConfig;
      };
    };
  };
  # TODO : group inheritance functions together
  inheritance = {
    settings = {
      currentPathAsList,
      imports,
      settings,
    }: let
      first = lists.last (lists.take 1 currentPathAsList);
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
                currentPathAsList = lists.drop 1 currentPathAsList;
                imports = imports;
                settings = settings;
              });
        })
        imports);
    config = {
      currentPathAsList,
      config,
    }: let
      first = lists.last (lists.take 1 currentPathAsList);
    in
      if (currentPathAsList == [])
      then config
      else
        inheritConfig {
          currentPathAsList = lists.drop 1 currentPathAsList;
          config = config.${first};
        };
    options = {
      currentPathAsList,
      options,
    }: let
      first = lists.last (lists.take 1 currentPathAsList);
    in (listToAttrs [
      {
        name = first;
        value =
          if (currentPathAsList == [first])
          then options
          else
            inheritOptions {
              currentPathAsList = lists.drop 1 currentPathAsList;
              inherit options;
            };
      }
    ]);
  };

  # TODO : the 3 following can be one function using isStr, isList, ... to determine the type of value to return
  ifExists = config: configPathString: value: let
    pathAsList = splitString "." configPathString;
    name = lists.last pathAsList;
    parentPathAsList = lists.drop 1 (lists.reverseList (lists.drop 1 (lists.reverseList pathAsList)));
    parentPath = attrsets.getAttrFromPath parentPathAsList config;
    configPath = attrsets.getAttrFromPath (lists.drop 1 pathAsList) config;
    modulePath = configPath.enable;
    emptyValue =
      if isString value
      then ""
      else if isList value
      then []
      else {};
  in
    if parentPath.enable && builtins.hasAttr name parentPath && modulePath
    then value
    else emptyValue;
in {
  inherit inheritSettings contextModuleImport inheritConfig inheritOptions contextualModule moduleParams fullModule ifExists;
}
