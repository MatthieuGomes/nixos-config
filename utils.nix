{lib, ...}: let
  importWithArgs = {
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
  # multiContextModule = {
  #   lib,
  #   module-path,
  #   pkgs-list,
  #   name,
  #   subfolder ? "",
  #   repo ? "",
  #   branch ? "",
  #   options ? {},
  #   settings ? {},
  #   multiContextImports ? [],
  #   homeOnlyImports ? [],
  #   homeConfig ? {},
  #   nixosOnlyImports ? [],
  #   nixosConfig ? {},
  # }: let
  #   packages =
  #     if repo != "" && branch != ""
  #     then pkgs-list.${repo}.${branch}
  #     else null;
  #   opt_path = module-path.${name};
  #   cfg = options.${opt_path};
  # in {
  #   inherit options;
  #   imports = multiContextImports;
  #   homeModule = {
  #     lib,
  #     config,
  #     ...
  #   }: {
  #     imports = homeOnlyImports;
  #     config = lib.mkIf (cfg.enable) homeConfig;
  #   };
  #   nixosModule = {
  #     lib,
  #     config,
  #     ...
  #   }: {
  #     imports = nixosOnlyImports;
  #     config = lib.mkIf (cfg.enable) nixosConfig;
  #   };
  # };
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
in {
  inherit importWithArgs;
  # multiContextModule;
}
