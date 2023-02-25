# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, ... }:
let
  nvidia_x11 = config.boot.kernelPackages.nvidia_x11;
  nvidia_gl = nvidia_x11.out;
  nvidia_gl_32 = nvidia_x11.lib32;
in
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ nvidia_gl ];
    extraPackages32 = [ nvidia_gl_32 ];
  };

  virtualisation.docker = {
    enableNvidia = true;
  };
}
