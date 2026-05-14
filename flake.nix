{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable?shallow=1";
    darwin = {
      url = "github:nix-darwin/nix-darwin?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew?shallow=1";

    llm-agents = {
      url = "github:numtide/llm-agents.nix?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    stylix = {
      url = "github:nix-community/stylix?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: https://github.com/NixOS/nixpkgs/pull/484661
    lumen = {
      url = "github:jnsahaj/lumen?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pytest-language-server = {
      url = "github:bellini666/pytest-language-server?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  outputs =
    {
      self,
      darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      llm-agents,
      lumen,
      pytest-language-server,
      stylix,
      treefmt-nix,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      user = "evgenii";

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      mkPkgs =
        { system }:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      mkHome =
        { system, modules }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs { inherit system; };
          extraSpecialArgs = {
            inherit
              user
              llm-agents
              lumen
              pytest-language-server
              stylix
              ;
          };

          inherit modules;
        };

      eachSystem = f: lib.genAttrs supportedSystems (system: f system nixpkgs.legacyPackages.${system});
      treefmtEval = eachSystem (_system: pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      darwinConfigurations = {
        mbp = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit self user nix-homebrew; };
          modules = [ ./modules/darwin.nix ];
        };
      };

      homeConfigurations = {
        "${user}@mbp" = mkHome {
          system = "aarch64-darwin";
          modules = [ ./modules/home/darwin.nix ];
        };

        "${user}@arch" = mkHome {
          system = "x86_64-linux";
          modules = [ ./modules/home/arch.nix ];
        };
      }
      // lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (
        system:
        mkHome {
          inherit system;
          modules = [
            ./modules/home/shared.nix
            ./modules/home/linux.nix
          ];
        }
      );

      formatter = eachSystem (system: _pkgs: treefmtEval.${system}.config.build.wrapper);
      checks = eachSystem (
        system: _pkgs: { formatting = treefmtEval.${system}.config.build.check self; }
      );
    };
}
