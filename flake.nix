{
  description = "Gonzalo's darwin configuration";
  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-25-05.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-24-11.url = "github:nixos/nixpkgs/nixos-24.11";

    # Environment/system management
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake Utils
    flake-utils.url = "github:numtide/flake-utils";

    # Link macOS apps
    mkalias = {
      url = "github:reckenrode/mkalias";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      ...
    }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (nixpkgs.lib) attrValues makeOverridable optionalAttrs;
      inherit (builtins) listToAttrs;

      namedOverlays = attrValues {
        # Overlay useful on Macs with Apple Silicon
        apple-silicon =
          final: prev:
          optionalAttrs (prev.stdenv.system == "aarch64-darwin") rec {
            # Add access to x86 packages system is running Apple Silicon
            system = "x86_64-darwin";
            pkgs-x86 = import inputs.nixpkgs {
              inherit system;
              inherit (nixpkgsConfig) config;
            };
            pkgs-x86-stable = pkgs-x86-25-05;
            pkgs-x86-25-05 = import inputs.nixpkgs-25-05 {
              inherit system;
              inherit (nixpkgsConfig) config;
            };
            pkgs-x86-24-11 = import inputs.nixpkgs-24-11 {
              inherit system;
              inherit (nixpkgsConfig) config;
            };
          };

        stable = final: prev: rec {
          pkgs-stable = pkgs-25-05;
          pkgs-25-05 = import inputs.nixpkgs-25-05 {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        packages = import ./nix/pkgs;
      };

      dynamicOverlays =
        let
          path = ./nix/overlays;
        in
        with builtins;
        map (overlay: import (path + ("/" + overlay))) (
          filter (
            overlay: match ".*\\.nix" overlay != null || pathExists (path + ("/" + overlay + "/default.nix"))
          ) (attrNames (readDir path))
        );

      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
          allowInsecure = false;
          allowUnsupportedSystem = true;
          # NOTE: Fixes unfree problem, remove when
          # https://github.com/nix-community/home-manager/issues/2942
          allowUnfreePredicate = (pkg: true);
          allowBroken = false;
        };
        # Dynamic list of overlays
        overlays =
          namedOverlays
          ++ dynamicOverlays
          ++ [
            (final: prev: {
              mkalias = inputs.mkalias.outputs.apps.${prev.stdenv.system}.default.program;
            })
          ]
          ++ [
            # inputs.neovim-nightly-overlay.overlays.default
          ];
      };

      homeManagerStateVersion = "23.05";
      commonHomeManagerConfig = {
        imports = [
          ./nix/modules/home-manager
          ./nix/home
          {
            home.stateVersion = homeManagerStateVersion;
          }
        ];
      };

      nixGlobal = {
        nix = {
          registry = {
            nixpkgs.flake = nixpkgs;
            nixpkgs-25-05.flake = inputs.nixpkgs-25-05;
            nixpkgs-24-11.flake = inputs.nixpkgs-24-11;
          };

          nixPath = [
            "nixpkgs=${inputs.nixpkgs}"
            "nixpkgs-25-05=${inputs.nixpkgs-25-05}"
            "nixpkgs-24-11=${inputs.nixpkgs-24-11}"
            "darwin=${inputs.darwin}"
            "home-manager=${inputs.home-manager}"
          ];
        };
      };

      commonDarwinConfig =
        let
          user = "pecigonzalo";
          homeDirectory = "/Users/${user}";
        in
        [
          home-manager.darwinModules.home-manager
          nixGlobal
          ./nix/common
          ./nix/darwin
          {
            nixpkgs = nixpkgsConfig;
            # home-manager config
            users.users.${user}.home = homeDirectory;
            system.primaryUser = user;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              verbose = false;
              users.${user} = commonHomeManagerConfig;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];

    in
    {
      darwinConfigurations = rec {
        # Mininal configurations to bootstrap systems
        bootstrap-x86 = makeOverridable darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./nix/darwin/bootstrap.nix
            { nixpkgs = nixpkgsConfig; }
          ];
        };
        bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };

        githubCI = darwinSystem {
          system = "aarch64-darwin";
          modules = commonDarwinConfig ++ [
            (
              { lib, ... }:
              {
                networking.hostName = "runner";
                homebrew.enable = lib.mkForce false;
                nix.useDaemon = lib.mkForce false;
                services.nix-daemon.enable = lib.mkForce false;
                services.nix-daemon.enableSocketListener = lib.mkForce false;
                users.nix.configureBuildUsers = lib.mkForce false;
              }
            )
          ];
        };

        # Apple Silicon macOS
        pecigonzalo = darwinSystem {
          system = "aarch64-darwin";
          modules = commonDarwinConfig ++ [
            { networking.hostName = "pecigonzalo"; }
          ];
        };
      };

      homeConfigurations = rec {
        pecigonzalo = wslfish; # Alias
        wslfish = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            {
              home = {
                username = "pecigonzalo";
                homeDirectory = "/home/pecigonzalo";
                stateVersion = homeManagerStateVersion;
              };
              nixpkgs = nixpkgsConfig;
            }
            commonHomeManagerConfig
          ];
        };

        devel = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          modules = [
            {
              home = {
                username = "devel";
                homeDirectory = "/home/devel";
                stateVersion = homeManagerStateVersion;
              };
              nixpkgs = nixpkgsConfig;
            }
            commonHomeManagerConfig
          ];
        };

        revel = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            {
              home = {
                username = "ubuntu";
                homeDirectory = "/home/ubuntu";
                stateVersion = homeManagerStateVersion;
              };
              nixpkgs = nixpkgsConfig;
            }
            commonHomeManagerConfig
          ];
        };
      };

      checks = listToAttrs (
        # darwin checks
        (map (system: {
          name = system;
          value = {
            pecigonzalo = self.darwinConfigurations.githubCI.system;
          };
        }) nixpkgs.lib.platforms.darwin)
        ++
          # linux checks
          (map (system: {
            name = system;
            value = {
              wslfish = self.homeConfigurations.wslfish.activationPackage;
            };
          }) nixpkgs.lib.platforms.linux)
      );
    };
}
