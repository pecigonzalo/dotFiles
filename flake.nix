{
  description = "Gonzalo's darwin configuration";
  inputs = {
    # Package sets
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

    # Determinate
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

    # Environment/system management
    darwin = {
      url = "https://flakehub.com/f/nix-darwin/nix-darwin/0.1";
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

    # WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Neovim
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Agenix
    agenix.url = "github:ryantm/agenix";
  };
  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      nixos-wsl,
      ...
    }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (nixpkgs.lib) attrValues makeOverridable;
      inherit (builtins) listToAttrs;

      namedOverlays = attrValues {
        # Overlay useful on Macs with Apple Silicon
        stable = final: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
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

      nixpkgsConfig = {
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
            # inputs.neovim-nightly-overlay.overlays.default
          ];
      };

      homeManagerStateVersion = "25.11";
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
            nixpkgs-stable.flake = inputs.nixpkgs-stable;
          };

          nixPath = [
            "nixpkgs=${inputs.nixpkgs}"
            "nixpkgs-stable=${inputs.nixpkgs-stable}"
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
              backupFileExtension = "nix-bkp";
            };
          }
        ];

    in
    {
      darwinConfigurations = {
        # Mininal configurations to bootstrap systems
        bootstrap-arm = makeOverridable darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./nix/darwin/bootstrap.nix
            { nixpkgs = nixpkgsConfig; }
          ];
        };

        githubCI = darwinSystem {
          system = "aarch64-darwin";
          modules = commonDarwinConfig ++ [
            {
              networking.hostName = "runner";
              homebrew.enable = false;
              nix.enable = false;
            }
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

      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixGlobal
            nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            ./nix/common
            {
              system.stateVersion = "25.05";
              wsl.enable = true;
              wsl.defaultUser = "pecigonzalo";
              fileSystems."/home" = {
                label = "vhdx-home";
                fsType = "ext4";
              };
              nixpkgs = nixpkgsConfig;
            }
            (
              { pkgs, ... }:
              {
                users = {
                  users.pecigonzalo = {
                    isNormalUser = true;
                    shell = pkgs.zsh;
                    home = "/home/pecigonzalo";
                    group = "pecigonzalo";
                    extraGroups = [ "wheel" ];
                  };
                  groups.pecigonzalo = { };
                };
                programs.zsh.enable = true;
              }
            )
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.pecigonzalo = commonHomeManagerConfig;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
        };
      };

      homeConfigurations = rec {
        pecigonzalo = wslfish; # Alias
        wslfish = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
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
          extraSpecialArgs = { inherit inputs; };
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
          extraSpecialArgs = { inherit inputs; };
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
            pecigonzalo = self.darwinConfigurations.githubCI.config.system.build.toplevel;
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
