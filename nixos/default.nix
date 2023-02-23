# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ self, inputs, config, ... }:
let
  mkHomeModule = name: extraModules: {
    users.users.${name}.isNormalUser = true;
    home-manager.users.${name} = {
      imports = [
        self.homeModules.common-linux
        ../home/git.nix
      ] ++ extraModules;
    };
  };
in
{
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      guests.imports = [
        # Temporarily sharing with Uday, until he gets better machine.
        (mkHomeModule "uday" [ ])
      ];
      myself = mkHomeModule config.people.myself [
        ../home/shellcommon.nix
      ];
      default.imports = [
        self.nixosModules.home-manager
        self.nixosModules.myself
        inputs.agenix.nixosModules.default
        ./vmVariant.nix
        ./caches
        ./self-ide.nix
        ./ssh-authorize.nix
        ./current-location.nix
        ./terminal.nix
        ./gnome.nix
      ];
    };
  };
}
