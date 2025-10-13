{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nixgl.url = "github:nix-community/nixGL";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      nixgl,
      stylix,
      ...
    }:
    let
      user = "evgenii";
    in
    {
      darwinConfigurations = {
        mbp = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = inputs // {
            inherit user;
          };
          modules = [ ./modules/darwin.nix ];
        };
      };

      homeConfigurations = {
        "${user}@mbp" =
          let
            system = "aarch64-darwin";
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit user stylix; };
            modules = [ ./modules/home/darwin.nix ];
          };

        "${user}@arch" =
          let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit user stylix nixgl; };
            modules = [ ./modules/home/arch.nix ];
          };
      }
      // nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit user stylix; };
          modules = [
            ./modules/home/shared.nix
            ./modules/home/linux.nix
          ];
        }
      );
    };
}
