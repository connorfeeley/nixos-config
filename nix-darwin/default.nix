# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ self, inputs, config, ... }:
let
  mkHomeModule = name: extraModules: {
    users.users.${name}.isNormalUser = true;
    home-manager.users.${name} = {
      imports = [
        self.homeModules.common-darwin
        ../home/git.nix
      ] ++ extraModules;
    };
  };
in
{
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      myself = mkHomeModule config.people.myself [
        ../home/shellcommon.nix
        self.homeModules.emacs
        self.homeModules.docker
      ];
      default.imports = [
        self.darwinModules.home-manager
        self.darwinModules.myself
        inputs.agenix.darwinModules.age
      ];
    };

    # Configurations for macOS machines (using nix-darwin)
    darwinConfigurations = {
      MacBook-Pro = self.lib.mkMacosSystem "aarch64-darwin" {
        imports = [
          # FIXME: self.darwinModules.default cases nix to segfault
          # self.darwinModules.default # Defined in nix-darwin/default.nix
          ../systems/MacBook-Pro.nix
          ../nixos/hercules.nix
        ];
      };
    };
  };
}
