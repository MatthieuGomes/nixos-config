{
  description = "System flake";

  inputs = {
    unstablePkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    latestPkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "latestPkgs";
    };
    nur-latest-pkgs = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "latestPkgs";
    };
    nur-klassy-version = {
      url = "github:nix-community/nur/82a02f13454ca5b23248d9fe8fb15618a11b09f0";
      # sha256 = "0d8iwisgw15ivwbd9s041fbf33mqgccsmwxcvgwf3y84i2d1rb7a";
    };
    nur-unstable-pkgs = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "unstablePkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        nixpkgs.follows = "unstablePkgs";
        home-manager.follows = "home-manager";
      };
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "latestPkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    self,
    unstablePkgs,
    latestPkgs,
    ...
  } @ Inputs: let
    system = "x86_64-linux";
    latest-version = "25.11";
    nixos-version = latest-version;
    latest = import latestPkgs {
      inherit system;
      ### Not sure if needed
      overlays = [
        Inputs.nur-latest-pkgs.overlays.default
      ];
      config = {
        allowUnfree = true;
      };
    };
    unstable = import unstablePkgs {
      inherit system;
      ### Not sure if needed
      overlays = [
        Inputs.nur-unstable-pkgs.overlays.default
      ];
      config = {
        allowUnfree = true;
      };
    };
    nix = {
      latest = latest;
      unstable = unstable;
    };
    nur-latest = Inputs.nur-latest-pkgs.legacyPackages.${system};
    nur-unstable = Inputs.nur-unstable-pkgs.legacyPackages.${system};
    nur-klassy = Inputs.nur-klassy-version.legacyPackages.${system};

    nur = {
      latest = nur-latest;
      unstable = nur-unstable;
      klassy = nur-klassy;
    };
    others = {
      zen-browser = Inputs.zen-browser;
    };
    pkgs-list = {
      inherit nix;
      inherit nur;
      inherit others;
    };
    managers = {
      home = Inputs.home-manager;
      plasma = Inputs.plasma-manager;
    };
    inherit (Inputs) home-manager plasma-manager;
    lib = latest.lib;
    inheritSettings = {
      pathNames,
      imports,
      settings,
    }: let
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
                imports = imports;
                settings = settings;
              });
        })
        imports);
    opt = {
      programs = {
        enable = true;
        shells = {
          enable = true;
          zsh = true;
        };
        misc = {
          enable = true;
          ledger = true;
          bambu-studio = true;
          bitwarden = true;
          fastfetch = true;
          iso-image-writer = true;
          vesktop = true;
          kdeconnect = true;
        };
        office = {
          enable = true;
          libreoffice = true;
          qualculate = true;
        };
        dev = {
          enable = true;
          boot = {
            enable = true;
            efibootmgr = true;
            grub = true;
            gparted = true;
            os-prober = true;
          };
          nix = {
            enable = true;
            nixd = true;
            alejandra = true;
          };
          # network = true;
          docker = true;
          ghostty = true;
          git = true;
          postman = true;
          vscode = true;
          vim = true;
        };
        browsers = {
          enable = true;
          firefox = true;
          chromium = true;
        };
        desktop = {
          enable = true;
          plasma = true;
          klassy = true;
          rofi = true;
        };
      };
    };
    testProgramOptions = {
    };
  in {
    nixosConfigurations.NixOs = latestPkgs.lib.nixosSystem {
      pkgs = pkgs-list.nix.latest;
      specialArgs = {
        inherit pkgs-list;
        inherit Inputs;
        inherit managers;
        inherit nixos-version;
        inherit opt;
        inherit inheritSettings;
      };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = {
              inherit Inputs;
              inherit pkgs-list;
              inherit latest;
              inherit nixos-version;
              inherit opt;
              inherit inheritSettings;
            };
            useUserPackages = true;
            useGlobalPkgs = true;
            sharedModules = [plasma-manager.homeModules.plasma-manager];
            users.matthieu = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
