# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let inherit (pkgs.stdenv) isx86_64;
in {
  programs.htop.enable = true;

  programs.atop = {
    enable = true;
    atopgpu.enable = isx86_64;
    netatop.enable = true;
    setuidWrapper.enable = true;
    atopService.enable = true;
    atopRotateTimer.enable = true;
  };

}
