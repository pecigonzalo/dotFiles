{
  description = "Gonzalo's darwin configuration";
  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-21.05";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, darwin, home-manager, ... }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;

      user = "gonzalopeci";
      homedir = "/Users/${user}";
      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
          allowBroken = false;
          allowInsecure = false;
          allowUnsupportedSystem = true;
        };
      };

      commonHomeManagerConfig = {
        imports = [
          ./nix/home
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
        m1 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = commonDarwinConfig;
        };
      };
    };
}
