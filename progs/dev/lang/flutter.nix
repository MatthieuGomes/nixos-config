{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}:
# TODO : needs to be throughly tested/configured
let
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
    name = "flutter";
    main-repo = "nix";
    branch = "unstable";
    extras = rec {
      androidComposition = pkgs-list.nix.unstable.androidenv.composeAndroidPackages {
        toolsVersion = "26.1.1";
        platformToolsVersion = "35.0.1";
        buildToolsVersions = [
          "30.0.3"
          "33.0.1"
          "34.0.0"
        ];
        platformVersions = [
          "31"
          "33"
          "34"
        ];
        abiVersions = ["x86_64"];
        includeEmulator = true;
        emulatorVersion = "35.1.4";
        includeSystemImages = true;
        systemImageTypes = ["google_apis_playstore"];
        includeSources = false;
        extraLicenses = [
          "android-googletv-license"
          "android-sdk-arm-dbt-license"
          "android-sdk-license"
          "android-sdk-preview-license"
          "google-gdk-license"
          "intel-android-extra-license"
          "intel-android-sysimage-license"
          "mips-android-sysimage-license"
        ];
      };
      androidSdk = androidComposition.androidsdk;
      buildToolsVersion = "33.0.1";
    };
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
      addToKvmGroup = lib.mkEnableOption "Add user to KVM group for hardware acceleration";
      enableAdb = lib.mkEnableOption "Enable ADB and add user to adbusers group";
      user = lib.mkOption {
        type = lib.types.str;
        description = "Username for Flutter development";
      };
    };
    # specialOptions = {
    #   options.programs.flutter = {
    #     enable = lib.mkEnableOption "Flutter development environment";
    #   };
    # };
  };
in
  with tools; (fullModule rec {
    inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
    inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
    inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
    System = with extras; {
      environment.systemPackages = with packages; [
        flutter
        androidSdk
        # android-studio
        jdk17
        firebase-tools
      ];
      environment.variables = {
        ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
        ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
        JAVA_HOME = "${packages.jdk17}";
        GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/34.0.0/aapt2";
      };
      environment.shellInit = ''
        export PATH=$PATH:${androidSdk}/libexec/android-sdk/platform-tools
        export PATH=$PATH:${androidSdk}/libexec/android-sdk/cmdline-tools/latest/bin
        export PATH=$PATH:${androidSdk}/libexec/android-sdk/emulator
        export PATH="$PATH":"$HOME/.pub-cache/bin"
        export NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE=1
      '';
    };
  })
