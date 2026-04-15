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
    Config,
    context,
    ...
  } @ deps: {
    lib,
    config,
    ...
  }: let
    inherit (deps) subfolder tools currentPathAsList lib config pkgs-list currentDirPath inputs cfg;
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
        imports = tools.contextModuleImport {
          inherit imports subfolder tools currentPathAsList lib config pkgs-list currentDirPath inputs;
          context = context;
        };
      }
      else {
      }
    )
    // {
      config = lib.mkIf cfg.enable Config;
    };
in {
  inherit inheritSettings contextModuleImport inheritConfig inheritOptions contextualModule;
}
