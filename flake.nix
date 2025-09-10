{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
  };

  outputs = inputs @ {
    self,
    darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    nixgl,
    ...
  }: let
    user = "evgenii";
  in {
    darwinConfigurations = {
      mbp = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = inputs // {inherit user;};
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          ./modules/darwin.nix
        ];
      };
    };

    homeConfigurations =
      {
        "${user}@mbp" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {inherit user;};
          modules = [
            {
              home.username = user;
              home.homeDirectory = "/Users/${user}";
            }
            ./modules/home/darwin.nix
          ];
        };

        "${user}@arch" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit user nixgl;};
          modules = [./modules/home/arch.nix];
        };
      }
      // nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"] (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
        in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {inherit user;};
            modules = [
              ./modules/home/shared.nix
              ./modules/home/linux.nix
            ];
          }
      );
  };
}
