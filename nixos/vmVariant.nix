# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:
let
  ### Set systems here
  ## When running from x86_64-linux:
  # targetSystem = "x86_64-linux"; # VM system
  # hostSystem = "x86_64-linux"; # Host platform

  ## When running from aarch64-darwin:
  targetSystem = "aarch64-linux"; # VM system
  hostSystem = "aarch64-darwin"; # Host platform
in
{
  # Attributes added to 'nixos-rebuild build-vm' hosts
  virtualisation.vmVariant = { lib, pkgs, ... }: {
    # Platform of the VM
    nixpkgs.hostPlatform = targetSystem;

    virtualisation = {
      # Platform of the host
      host.pkgs = import pkgs.path { system = hostSystem; };

      cores = 4;
      memorySize = 4096;

      msize = 1024 * 1024 * 100; # 100M

      graphics = true;

      # Cursor isn't shown in MacOS QEMU VMs
      qemu.options = lib.optionals
        (lib.hasSuffix hostSystem "-darwin"
          && config.virtualisation.vmVariant.virtualisation.graphics)
        [ "-display cocoa,show-cursor=on" ];
    };
    services.xserver.resolutions = lib.mkOverride 9 ([ ] ++
      (lib.optionals (lib.hasSuffix hostSystem "-darwin") [{
        x = 1680;
        y = 1050;
      }]) ++ (lib.optionals (lib.hasSuffix hostSystem "-linux") [{
      x = 1680 * 2;
      y = 1050 * 2;
    }]));
  };
}
