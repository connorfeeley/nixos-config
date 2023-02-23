# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

# Support code for this repo. This module could be made its own external repo.
{ self, inputs, config, ... }:
let
  overlays = with inputs; [
    agenix.overlay
    emacs-overlay.overlays.default
    gitignore.overlay
    nur.overlay
    nvfetcher.overlays.default

    nix-xilinx.overlay

    (final: _prev:
      let
        packagesFrom = inputAttr: inputAttr.packages.${final.system};
      in
      {
        inherit (packagesFrom self.packages) emacs-plus;
        inherit (packagesFrom inputs.devenv) devenv;
        inherit (packagesFrom inputs.deploy) deploy-rs;
        inherit (packagesFrom inputs.deploy-flake) deploy-flake;
        inherit (packagesFrom inputs.prefmanager) prefmanager;
        inherit (packagesFrom inputs.nix-nil) nil;
        inherit (packagesFrom inputs.nix-alien) nix-alien;
        inherit (packagesFrom inputs.nix-alien) nix-index-update;
        inherit (packagesFrom inputs.nix-autobahn) nix-autobahn;
        inherit (packagesFrom inputs.chatgpt-wrapper) chatgpt-wrapper;

        # Personal packages
        inherit (packagesFrom inputs.nurpkgs) apple_complete maclaunch toronto-backgrounds;
        inherit (packagesFrom inputs.xmonad-config) xmonad-config;
        inherit (packagesFrom inputs.ttc-subway-font) ttc-subway bloor-yonge-font;

        inherit (inputs.nixpkgs-input-leap.legacyPackages.${final.system}) input-leap;

        nix-init = inputs.nix-init.packages.${final.system}.default;
        emacsGitDarwin = inputs.darwin-emacs.packages.${final.system}.default;
        neovim-plusultra = inputs.neovim-plusultra.packages.${final.system}.neovim;
      }
    )
  ];
in
{
  flake = {
    # Linux home-manager module
    nixosModules.nixpkgs = {
      imports = [{
        nixpkgs = { inherit overlays; };
      }];
    };
    nixosModules.home-manager = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        ({
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            system = "x86_64-linux";
            flake = { inherit config; };
          };
        })
      ];
    };
    # macOS home-manager module
    darwinModules.home-manager = {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        ({
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            system = "aarch64-darwin";
            flake = { inherit config; };
          };
        })
      ];
    };
    lib = {
      mkLinuxSystem = system: mod: inputs.nixpkgs.lib.nixosSystem rec {
        inherit system;
        # Arguments to pass to all modules.
        specialArgs = {
          inherit system inputs;
          flake = { inherit config; };
        };
        modules = [ self.nixosModules.nixpkgs mod ];
      };

      mkMacosSystem = system: mod: inputs.darwin.lib.darwinSystem rec {
        inherit system;
        specialArgs = {
          inherit inputs system;
          flake = { inherit config; };
          rosettaPkgs = import inputs.nixpkgs { system = "x86_64-darwin"; };
        };
        modules = [ self.nixosModules.nixpkgs mod ];
      };
    };
  };

  perSystem = { system, config, pkgs, lib, ... }: {
    mission-control.scripts = {
      update-primary = {
        description = ''
          Update primary flake inputs
        '';
        exec =
          let
            inputs = [ "nixpkgs" "home-manager" "darwin" ];
          in
          ''
            nix flake lock ${lib.foldl' (acc: x: acc + " --update-input " + x) "" inputs}
          '';
      };

      activate = {
        description = "Activate the current configuration for local system";
        exec =
          # TODO: Replace with deploy-rs or (new) nixinate
          if system == "aarch64-darwin" then
            ''
              cd "$(${lib.getExe config.flake-root.package})"
              ${self.darwinConfigurations.default.system}/sw/bin/darwin-rebuild \
                switch --flake .#default
            ''
          else
            ''
              ${lib.getExe pkgs.nixos-rebuild} --use-remote-sudo switch -j auto
            '';
        category = "Main";
      };

      fmt = {
        description = "Autoformat repo tree";
        exec = "nix fmt";
      };
    };
  };
}
