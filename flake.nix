{
  nixConfig = {
    narinfo-cache-positive-ttl = 3600;
    extra-substituters = [
      "https://cache.numtide.com"
      "https://cache.garnix.io"
      "https://helix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };

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

    helix = {
      url = "github:helix-editor/helix/master?shallow=1";
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

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
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

    hydra-lsp = {
      url = "github:m-lyon/hydra-lsp?shallow=1";
      flake = false;
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      darwin,
      nixpkgs,
      home-manager,
      nix-index-database,
      nix-homebrew,
      helix,
      hydra-lsp,
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

      pkgsFor = lib.genAttrs supportedSystems (system: mkPkgs { inherit system; });

      mkHome =
        { system, modules }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.${system};
          extraSpecialArgs = {
            inherit
              user
              helix
              hydra-lsp
              llm-agents
              lumen
              pytest-language-server
              stylix
              nix-index-database
              ;
          };

          inherit modules;
        };

      eachSystem = f: lib.genAttrs supportedSystems (system: f system pkgsFor.${system});
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
