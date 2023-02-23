# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }: {
  # Attributes applied to 'nixos-rebuild build-vm' builds
  virtualisation.vmVariant = { lib, pkgs, ... }: {
    nixpkgs.hostPlatform = "aarch64-linux";

    virtualisation = {
      # nixpkgs.pkgs = inputs.self.legacyPackages.${config.nixpkgs.system};
      host.pkgs = import pkgs.path { system = "aarch64-darwin"; };

      cores = 4;
      memorySize = 4096;

      msize = 104857600; # 100M

      graphics = true;
    };

    services.xserver.resolutions = lib.mkOverride 9 [{ x = 1680; y = 1050; }];
  };
}
