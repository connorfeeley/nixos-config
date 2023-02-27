# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, pkgs, lib, ... }:
let
  nvidia_x11 = config.boot.kernelPackages.nvidia_x11;
  nvidia_gl = nvidia_x11.out;
  nvidia_gl_32 = nvidia_x11.lib32;
in
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    # https://github.com/NixOS/nixpkgs/issues/47932#issuecomment-447508411
    driSupport32Bit = pkgs.stdenv.is64bit && pkgs.stdenv.isx86_64;
    extraPackages = [ nvidia_gl ];
    extraPackages32 = [ nvidia_gl_32 ];
  };

  virtualisation.docker = {
    enableNvidia = pkgs.stdenv.is64bit && pkgs.stdenv.isx86_64;
  };
}
