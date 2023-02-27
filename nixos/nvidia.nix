# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, pkgs, lib, ... }:
let
  nvidia_x11 = nvStable.nvidia_x11;
  nvidia_gl = nvidia_x11.out;
  nvidia_gl_32 = nvidia_x11.lib32;

  nvStable = pkgs.nur.repos.arc.packages.nvidia-patch.override {
    nvidia_x11 = config.boot.kernelPackages.nvidiaPackages.stable;
  };
in
# Nvidia hates ARM
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = nvStable;
    modesetting.enable = false;
    nvidiaSettings = true; # Enable nvidia-settings utility
    nvidiaPersistenced = false; # Don't run daemon to keep GPU state alive
    # Prevent display corruption upon wake from a suspended or hibernated state.
    powerManagement.enable = true;

    # "Whether to force-enable the full composition pipeline. This sometimes fixes
    # screen tearing issues. This has been reported to reduce the performance of
    # some OpenGL applications and may produce issues in WebGL. It also drastically
    # increases the time the driver needs to clock down after load."
    forceFullCompositionPipeline = false;
  };

  hardware.opengl = {
    enable = true;

    driSupport = true;
    # https://github.com/NixOS/nixpkgs/issues/47932#issuecomment-447508411
    driSupport32Bit = true;

    extraPackages = [ nvidia_gl ];
    extraPackages32 = [ nvidia_gl_32 ];
  };

  virtualisation.docker = {
    enableNvidia = true;
  };
}
