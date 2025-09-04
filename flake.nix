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
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    ...
  }: {
    darwinConfigurations.mac = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit self;};
      modules = [
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        ./modules/darwin.nix
      ];
    };

    homeConfigurations = {
      server = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [./modules/home/server.nix];
      };
      kit = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        modules = [./modules/home/kit.nix];
      };
    };
  };
}
