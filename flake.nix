# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{
  description = "Srid's NixOS configuration";

  outputs = inputs@{ self, home-manager, nixpkgs, darwin, ... }:
    let lib = nixpkgs.lib.extend (_: _: import ./lib { inherit (nixpkgs) lib; });
    in inputs.flake-parts.lib.mkFlake { inherit inputs; specialArgs = { inherit lib; }; } {
      # Expose private flake values to the repl for inspection
      debug = true;

      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      imports = [
        inputs.flake-root.flakeModule
        inputs.mission-control.flakeModule
        ./lib/flake-module.nix
        ./users
        ./home
        ./nixos
        ./nix-darwin
      ];

      flake = {
        # Configurations for Linux (NixOS) systems
        nixosConfigurations = {
          hetzner-ax101 = self.lib.mkLinuxSystem "x86_64-linux" {
            imports = [
              self.nixosModules.default # Defined in nixos/default.nix
              ./systems/hetzner/ax101.nix
              ./nixos/server/harden.nix
              ./nixos/hercules.nix
            ];
          };
          rosy = self.lib.mkLinuxSystem "aarch64-linux" {
            imports = [
              self.nixosModules.default # Defined in nixos/default.nix
              ./systems/rosy
              ./nixos/server/harden.nix
              ./nixos/hercules.nix
            ];
          };
          workstation = self.lib.mkLinuxSystem "x86_64-linux" {
            imports = [
              self.nixosModules.default # Defined in nixos/default.nix
              self.nixosModules.docker # Defined in nixos/default.nix
              ./systems/workstation
              ./nixos/server/harden.nix
              ./nixos/hercules.nix
              ./nixos/xorg.nix
            ];
          };
        };
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

  inputs = {
    ##: --- nixpkgs flavours ----------------------------------------------------------
    nixpkgs.follows = "nixos-unstable";

    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-21-11.url = "github:NixOS/nixpkgs/nixos-21.11"; # Last release w/ sourcetrail

    ##: --- system -------------------------------------------------------------
    home-manager = { url = "github:nix-community/home-manager/release-22.11"; inputs.nixpkgs.follows = "nixpkgs"; };
    darwin = { url = "github:LnL7/nix-darwin"; inputs.nixpkgs.follows = "nixpkgs"; };
    digga = {
      url = "github:divnix/digga";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "darwin";
    };
    nixos-wsl = { url = "github:nix-community/NixOS-WSL"; inputs.nixpkgs.follows = "nixpkgs"; };
    agenix.url = "github:montchr/agenix";
    sops-nix = { url = "github:pogobanane/sops-nix/feat/home-manager-darwin"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # : ~~~ Devshell inputs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    mission-control.url = "github:Platonic-Systems/mission-control";
    flake-root.url = "github:srid/flake-root";
    nixpkgs-match.url = "github:srid/nixpkgs-match";

    # : ~~~ FHS compat ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    nix-alien = { url = "github:thiagokokada/nix-alien"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-autobahn = { url = "github:Lassulus/nix-autobahn"; inputs.nixpkgs.follows = "nixpkgs"; };
    envfs = { url = "github:Mic92/envfs"; inputs.nixpkgs.follows = "nixpkgs"; };

    ##: --- utilities ----------------------------------------------------------
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts = { url = "github:hercules-ci/flake-parts"; };

    nur.url = "github:nix-community/NUR";
    nixos-generators = { url = "github:nix-community/nixos-generators"; inputs.nixpkgs.follows = "nixpkgs"; };
    nvfetcher.url = "github:berberman/nvfetcher";
    arion = { url = "github:hercules-ci/arion"; inputs.nixpkgs.follows = "nixpkgs"; }; # FIXME: checks fail on darwin
    nix-serve-ng = { url = "github:aristanetworks/nix-serve-ng"; inputs.nixpkgs.follows = "nixpkgs"; inputs.utils.follows = "flake-utils"; };
    nixago = { url = "github:nix-community/nixago"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-vscode-server = { url = "github:msteen/nixos-vscode-server"; };

    ##: --- sources ------------------------------------------------------------
    mach-nix.url = "github:DavHau/mach-nix/refs/tags/3.5.0";
    gitignore.url = "github:hercules-ci/gitignore.nix";
    nix-colors.url = "github:Misterio77/nix-colors";
    deadnix = { url = "github:astro/deadnix/refs/tags/v1.0.0"; inputs.nixpkgs.follows = "nixpkgs"; };
    comma = { url = "github:nix-community/comma"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-index-database = { url = "github:Mic92/nix-index-database"; inputs.nixpkgs.follows = "nixpkgs"; };
    rnix-lsp = { url = "github:nix-community/rnix-lsp"; inputs.nixpkgs.follows = "nixpkgs"; };
    hercules-ci-agent = { url = "github:hercules-ci/hercules-ci-agent"; inputs = { nixpkgs.follows = "nixpkgs"; flake-parts.follows = "flake-parts"; nix-darwin.follows = "darwin"; }; };
    poetry2nix = { url = "github:nix-community/poetry2nix"; inputs = { nixpkgs.follows = "nixpkgs"; flake-utils.follows = "flake-utils"; }; };

    ##: --- Vim & its plugins (not in nixpkgs) ---------------------------------
    zk-nvim = { url = "github:mickael-menu/zk-nvim"; flake = false; };
    coc-rust-analyzer = { url = "github:fannheyward/coc-rust-analyzer"; flake = false; };

    ##: --- personal packages --------------------------------------------------
    nurpkgs = { url = "github:connorfeeley/nurpkgs"; inputs.nixpkgs.follows = "nixpkgs"; };
    xmonad-config = { url = "git+https://git.sr.ht/~cfeeley/xmonad-config"; inputs.flake-utils.follows = "flake-utils"; };
    chatgpt-wrapper = { url = "git+https://git.sr.ht/~cfeeley/chatgpt-wrapper"; inputs.flake-utils.follows = "flake-utils"; inputs.nixpkgs.follows = "nixpkgs"; inputs.nixpkgs-darwin.follows = "nixpkgs-darwin"; };
    ttc-subway-font = { url = "git+ssh://git@git.sr.ht/~cfeeley/ttc-subway-font"; inputs.nixpkgs.follows = "nixpkgs"; }; # Private repo
    nixpkgs-input-leap = { url = "sourcehut:~cfeeley/nixpkgs/feat/input-leap"; };

    ##: --- meta packages ------------------------------------------------------
    emacs-overlay = { url = "github:nix-community/emacs-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    darwin-emacs = { url = "github:c4710n/nix-darwin-emacs"; };
    nix-xilinx = { url = "git+https://git.sr.ht/~cfeeley/nix-xilinx"; };

    ##: --- packages -----------------------------------------------------------
    nickel = { url = "github:tweag/nickel"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-nil = { url = "github:oxalica/nil"; };
    nix-init = { url = "github:nix-community/nix-init"; };
    devenv = { url = "github:cachix/devenv/v0.5"; };
    deploy = { url = "github:serokell/deploy-rs"; inputs.nixpkgs.follows = "nixpkgs"; };
    deploy-flake = { url = "github:antifuchs/deploy-flake"; inputs.nixpkgs.follows = "nixpkgs"; };
    prefmanager.url = "github:malob/prefmanager";
    tum-dse-config = { url = "github:TUM-DSE/doctor-cluster-config"; inputs.nixpkgs.follows = "nixpkgs"; inputs.nixpkgs-unstable.follows = "nixpkgs"; inputs.flake-parts.follows = "flake-parts"; };
    neovim-plusultra = { url = "github:jakehamilton/neovim"; };
    emacstool = { url = "github:paulotome/emacstool"; flake = false; };

    ##: --- other --------------------------------------------------------------
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    dwarffs.url = "github:edolstra/dwarffs";
    base16-kitty = { url = "github:kdrag0n/base16-kitty"; flake = false; };
    firefox-lepton = { url = "github:black7375/Firefox-UI-Fix"; flake = false; };
    modded-minecraft-servers = { url = "github:mkaito/nixos-modded-minecraft-servers"; inputs.nixpkgs.follows = "nixpkgs"; };
    plasma-manager = { url = "github:pjones/plasma-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    doom-corfu = { url = "sourcehut:~gagbo/doom-config"; flake = false; };
  };
}
