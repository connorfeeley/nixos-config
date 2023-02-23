# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }: {
  # Attributes added to 'nixos-rebuild build-vm' hosts
  virtualisation.vmVariant = { lib, pkgs, ... }: {
    # Platform of the VM
    nixpkgs.hostPlatform = "aarch64-linux";

    virtualisation = {
      # Platform of the host
      host.pkgs = import pkgs.path { system = "aarch64-darwin"; };

      cores = 4;
      memorySize = 4096;

      msize = 104857600; # 100M

      graphics = true;

      # Cursor isn't shown in MacOS QEMU VMs
      qemu.options = lib.optionals config.virtualisation.vmVariant.virtualisation.graphics [ "-display cocoa,show-cursor=on" ];
    };

    services.xserver.resolutions = lib.mkOverride 9 [{ x = 1680; y = 1050; }];
  };
}
