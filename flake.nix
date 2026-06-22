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

    # WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

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
      inherit (nixpkgs.lib) makeOverridable;
      inherit (builtins) mapAttrs;

      systems = import ./nix/flake/systems.nix;
      inherit (systems) forAllSystems;

      pkgsLib = import ./nix/flake/pkgs.nix { inherit inputs nixpkgs; };
      inherit (pkgsLib) nixpkgsConfig pkgsFor mkDevShell;

      # State versions control migration defaults; do not bump just because inputs update.
      homeManagerStateVersion = "25.11";
      homeTargets = import ./nix/flake/home-targets.nix;

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
          inputs.determinate.darwinModules.default
          home-manager.darwinModules.home-manager
          nixGlobal
          ./nix/common
          ./nix/darwin
          {
            determinateNix = {
              enable = true;
              registry = {
                nixpkgs.flake = nixpkgs;
                nixpkgs-stable.flake = inputs.nixpkgs-stable;
              };
              customSettings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
                substituters = [
                  "https://cache.nixos.org/"
                  "https://pecigonzalo.cachix.org"
                  "https://nix-community.cachix.org"
                ];
                trusted-public-keys = [
                  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                  "pecigonzalo.cachix.org-1:KIojNF24XoRSCGsQu+fwzY/fJhEtANoxKB1Tu45hid8="
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                ];
                trusted-users = [ "@admin" ];
                extra-platforms = [
                  "aarch64-darwin"
                  "x86_64-darwin"
                ];
                keep-outputs = true;
                keep-derivations = true;
                auto-optimise-store = false;
              };
            };
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

      mkHomeConfiguration =
        {
          system,
          username,
          homeDirectory,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            {
              home = {
                inherit username homeDirectory;
                stateVersion = homeManagerStateVersion;
              };
              nixpkgs = nixpkgsConfig;
            }
            commonHomeManagerConfig
          ];
        };

      homeConfigurationsBase = mapAttrs (_name: mkHomeConfiguration) homeTargets;
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
              # State versions control migration defaults; do not bump just because inputs update.
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

      homeConfigurations = homeConfigurationsBase // {
        pecigonzalo = homeConfigurationsBase.wslfish;
      };

      devShells = forAllSystems (system: {
        default = mkDevShell system;
      });

      formatter = forAllSystems (system: (pkgsFor system).nixfmt);

      checks = {
        aarch64-darwin = {
          githubCI = self.darwinConfigurations.githubCI.config.system.build.toplevel;
          pecigonzalo = self.darwinConfigurations.pecigonzalo.config.system.build.toplevel;
        };

        x86_64-linux = {
          wsl = self.nixosConfigurations.wsl.config.system.build.toplevel;
          wslfish = self.homeConfigurations.wslfish.activationPackage;
          revel = self.homeConfigurations.revel.activationPackage;
        };

        aarch64-linux = {
          devel = self.homeConfigurations.devel.activationPackage;
        };
      };
    };
}
