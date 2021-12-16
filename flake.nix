{
  description = "Gonzalo's darwin configuration";
  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-21-05.url = "github:nixos/nixpkgs/21.05";

    # Comma
    # https://github.com/nix-community/comma
    comma = { url = github:nix-community/comma; flake = false; };

    # Flake Utils
    flake-utils.url = "github:numtide/flake-utils";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, darwin, home-manager, flake-utils, ... }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;

      user = "gonzalopeci";
      homedir = "/Users/${user}";

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
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };

        pkgs-21-05 = final: prev: {
          pkgs-21-05 = import inputs.nixpkgs-21-05 {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        comma = final: prev: {
          comma = import inputs.comma { inherit (prev) pkgs; };
        };

        packages = import ./nix/nixpkgs;
      };

      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
          allowBroken = false;
          allowInsecure = false;
          allowUnsupportedSystem = true;
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

      commonDarwinConfig = [
        ./nix/darwin
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          # home-manager config
          users.users.${user}.home = homedir;
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

        # Apple Silicon macOS
        macfish = darwinSystem {
          system = "aarch64-darwin";
          modules = commonDarwinConfig;
        };
      };

      homeConfigurations = {
        landfish = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          stateVersion = homeManagerStateVersion;
          homeDirectory = "/home/davyjones";
          username = "davyjones";
          configuration = {
            imports = [commonHomeManagerConfig];
            nixpkgs = nixpkgsConfig;
          };
        };
      };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = import ./shell.nix { inherit pkgs; };
    });
}
