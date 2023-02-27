# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ self, inputs, config, ... }:
let
  mkHomeModule = name: extraModules: {
    home-manager.users.${name} = {
      imports = [
        self.homeModules.common-darwin
        ../home/git.nix

        ../home/darwin/keyboard
      ] ++ extraModules;
    };
  };
in
{
  # Configuration common to all Linux systems
  flake = {
    # nixpkgs overlay module
    # TODO: just use nixosModules.home-manager instead?
    darwinModules.nixpkgs.imports = [{ nixpkgs.overlays = self.lib.commonOverlays; }];

    darwinModules.home-manager = { pkgs, inputs, system, ... }: {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        ({
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs system;
            flake = { inherit config; };
          };
        })
      ];
    };
    darwinModules.myself = mkHomeModule config.people.myself [
      ../home/shellcommon.nix
      self.homeModules.emacs
      self.homeModules.docker
    ];
    darwinModules.default.imports = [
      self.darwinModules.home-manager
      self.darwinModules.myself
      inputs.agenix.darwinModules.age
      ../nixos/distributed-build.nix

      (mkHomeModule "cfeeley" [
        self.homeModules.jetbrains
      ])
    ];
  };
}
