{
  description = "Gonzalo's darwin configuration";
  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-22-05.url = "github:nixos/nixpkgs/22.05";
    nixpkgs-21-11.url = "github:nixos/nixpkgs/21.11";
    nixpkgs-21-05.url = "github:nixos/nixpkgs/21.05";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Flake Utils
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, darwin, home-manager, flake-utils, ... }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (nixpkgs.lib) attrValues makeOverridable optionalAttrs;
      inherit (builtins) listToAttrs;

      dynamicOverlays =
        let path = ./nix/overlays; in
        with builtins;
        map (overlay: import (path + ("/" + overlay)))
          (
            filter (overlay: match ".*\\.nix" overlay != null || pathExists (path + ("/" + overlay + "/default.nix")))
              (attrNames (readDir path))
          );

      namedOverlays = attrValues {
        # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") rec {
          # Add access to x86 packages system is running Apple Silicon
          system = "x86_64-darwin";
          pkgs-x86 = import inputs.nixpkgs {
            inherit system;
            inherit (nixpkgsConfig) config;
          };
          pkgs-x86-stable = pkgs-x86-22-05;
          pkgs-x86-22-05 = import inputs.nixpkgs-22-05 {
            inherit system;
            inherit (nixpkgsConfig) config;
          };
          pkgs-x86-21-11 = import inputs.nixpkgs-21-11 {
            inherit system;
            inherit (nixpkgsConfig) config;
          };
          pkgs-x86-21-05 = import inputs.nixpkgs-21-05 {
            inherit system;
            inherit (nixpkgsConfig) config;
          };
        };

        stable = final: prev: rec {
          pkgs-stable = pkgs-21-11;
          pkgs-22-05 = import inputs.nixpkgs-22-05 {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
          pkgs-21-11 = import inputs.nixpkgs-21-11 {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
          pkgs-21-05 = import inputs.nixpkgs-21-05 {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        packages = import ./nix/nixpkgs;
      };

      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
          allowBroken = false;
          allowInsecure = false;
          allowUnsupportedSystem = true;
          # NOTE: Fixes unfree problem, remove when
          # https://github.com/nix-community/home-manager/issues/2942
          allowUnfreePredicate = (pkg: true);
        };
        # Dynamic list of patches
        # patches =
        #   let path = ./nix/patches; in
        #   with builtins;
        #   map (patch: path + "/${patch}")
        #     (
        #       filter (x: x != ".keep")
        #       (attrNames (readDir path))
        #     );
        # Dynamic list of overlays
        overlays = namedOverlays ++ dynamicOverlays;
      };

      homeManagerStateVersion = "22.05";
      commonHomeManagerConfig = {
        imports = [
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
            nixpkgs-22-05.flake = inputs.nixpkgs-22-05;
          };

          nixPath = [
            "nixpkgs=${inputs.nixpkgs}"
            "nixpkgs-22-05=${inputs.nixpkgs-22-05}"
            "darwin=${inputs.darwin}"
            "home-manager=${inputs.home-manager}"
          ];
        };
      };

      commonDarwinConfig =
        let
          user = "gonzalopeci";
          homeDirectory = "/Users/${user}";
        in
        [
          nixGlobal
          ./nix/common
          ./nix/darwin
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # home-manager config
            users.users.${user}.home = homeDirectory;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              verbose = false;
              users.${user} = commonHomeManagerConfig;
            };
          }
        ];

    in
    {
      darwinConfigurations = rec {
        # Mininal configurations to bootstrap systems
        bootstrap-x86 = makeOverridable darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./nix/darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
        };
        bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };

        githubCI = darwinSystem {
          system = "aarch64-darwin";
          modules = commonDarwinConfig ++ [
            ({ lib, ... }: {
              networking.hostName = "runner";
              homebrew.enable = lib.mkForce false;
              nix.useDaemon = lib.mkForce false;
              services.nix-daemon.enable = lib.mkForce false;
              services.nix-daemon.enableSocketListener = lib.mkForce false;
              users.nix.configureBuildUsers = lib.mkForce false;
            })
          ];
        };

        # Apple Silicon macOS
        gonzalopeci = darwinSystem {
          system = "aarch64-darwin";
          modules = commonDarwinConfig ++ [
            { networking.hostName = "gonzalopeci"; }
          ];
        };
      };

      homeConfigurations = rec {
        pecigonzalo = wslfish; # Alias
        wslfish = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          stateVersion = homeManagerStateVersion;
          homeDirectory = "/home/davyjones";
          username = "davyjones";
          configuration = {
            imports = [
              commonHomeManagerConfig
              {
                targets.genericLinux.enable = true;
              }
            ];
            nixpkgs = nixpkgsConfig;
          };
        };

        devel = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          stateVersion = homeManagerStateVersion;
          homeDirectory = "/home/devel";
          username = "devel";
          configuration = {
            imports = [
              commonHomeManagerConfig
              {
                targets.genericLinux.enable = true;
              }
            ];
            nixpkgs = nixpkgsConfig;
          };
        };

        revel = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          stateVersion = homeManagerStateVersion;
          homeDirectory = "/home/ubuntu";
          username = "ubuntu";
          configuration = {
            imports = [
              commonHomeManagerConfig
              {
                targets.genericLinux.enable = true;
              }
            ];
            nixpkgs = nixpkgsConfig;
          };
        };
      };

      checks = listToAttrs (
        # darwin checks
        (map
          (system: {
            name = system;
            value = {
              gonzalopeci =
                self.darwinConfigurations.githubCI.system;
            };
          })
          nixpkgs.lib.platforms.darwin) ++
        # linux checks
        (map
          (system: {
            name = system;
            value = {
              wslfish = self.homeConfigurations.wslfish.activationPackage;
            };
          })
          nixpkgs.lib.platforms.linux)
      );
    };
}
