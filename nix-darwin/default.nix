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
  # Configuration common to all macOS systems
  flake = {
    darwinModules = {
      myself = mkHomeModule config.people.myself [
        ../home/shellcommon.nix
        self.homeModules.emacs
        self.homeModules.docker
      ];
      default = {
        imports = [
          self.darwinModules.home-manager
          self.darwinModules.myself
          ../nixos/caches
          ./homebrew.nix
        ];
      };
    };
  };
}
