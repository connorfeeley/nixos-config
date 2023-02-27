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
      # nixpkgs overlay module
      nixpkgs.imports = [{ nixpkgs.overlays = self.lib.commonOverlays; }];

      home-manager = {
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
      guests.imports = [
        # Temporarily sharing with Uday, until he gets better machine.
        (mkHomeModule "uday" [ ])
      ];
      myself = mkHomeModule config.people.myself [
        ../home/shellcommon.nix
        self.homeModules.emacs
        self.homeModules.docker
      ];
      default.imports = [
        self.nixosModules.home-manager
        self.nixosModules.myself
        inputs.agenix.nixosModules.age

        (mkHomeModule "cfeeley" [
          self.homeModules.jetbrains
        ])

        ./vmVariant.nix
        ./distributed-build.nix
        ./boot-unlock.nix
        ./tailscale.nix
        ./caches
        ./self-ide.nix
        ./ssh-authorize.nix
        ./current-location.nix
        ./terminal.nix
        ./gnome.nix
        ./nvidia.nix
      ];
      docker.imports = [ ./virtualisation/docker.nix ];
      jellyfin.imports = [ ./containers/jellyfin.nix ];
    };
  };
}
