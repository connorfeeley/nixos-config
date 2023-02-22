# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{
  description = "Srid's NixOS configuration";

  inputs = {
    # Principle inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # CI server
    hci.url = "github:hercules-ci/hercules-ci-agent";
    nix-serve-ng.url = "github:aristanetworks/nix-serve-ng";

    # Devshell inputs
    mission-control.url = "github:Platonic-Systems/mission-control";
    mission-control.inputs.nixpkgs.follows = "nixpkgs";
    flake-root.url = "github:srid/flake-root";

    # Software inputs
    nixos-shell.url = "github:Mic92/nixos-shell";
    nixos-vscode-server.url = "github:msteen/nixos-vscode-server";
    nixos-vscode-server.flake = false;
    comma.url = "github:nix-community/comma";
    comma.inputs.nixpkgs.follows = "nixpkgs";
    emanote.url = "github:srid/emanote";
    nixpkgs-match.url = "github:srid/nixpkgs-match";

    # Emacs
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    # Vim & its plugins (not in nixpkgs)
    zk-nvim.url = "github:mickael-menu/zk-nvim";
    zk-nvim.flake = false;
    coc-rust-analyzer.url = "github:fannheyward/coc-rust-analyzer";
    coc-rust-analyzer.flake = false;
  };

  outputs = inputs@{ self, home-manager, nixpkgs, darwin, ... }:
    inputs.flake-parts.lib.mkFlake { inherit (inputs) self; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      imports = [
        inputs.flake-root.flakeModule
        inputs.mission-control.flakeModule
        ./lib.nix
        ./users
        ./home
        ./nixos
        ./nix-darwin
      ];

      flake = {
        # Configurations for Linux (NixOS) systems
        nixosConfigurations = {
          workstation = self.lib.mkLinuxSystem {
            imports = [
              self.nixosModules.default # Defined in nixos/default.nix
              ./systems/hetzner/ax101.nix
              ./nixos/server/harden.nix
              ./nixos/hercules.nix
              # I host a Nix cache
              # (import ./nixos/cache-server.nix {
              #   keyName = "cache-priv-key";
              #   domain = "cache.srid.ca";
              # })
            ];
          };
        };

        # Configurations for macOS machines (using nix-darwin)
        darwinConfigurations =
          let
            default = MacBook-Pro;
            MacBook-Pro = self.lib.mkMacosSystem {
              imports = [
                self.darwinModules.default # Defined in nix-darwin/default.nix
                ./nixos/hercules.nix
                ./systems/darwin.nix
              ];
            };
          in
          { inherit default MacBook-Pro; };
      };

      perSystem = { pkgs, config, inputs', ... }: {
        devShells.default = config.mission-control.installToDevShell (pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt
            inputs'.agenix.packages.agenix
          ];
        });
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
