# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }: {
  home.packages = lib.mkIf pkgs.stdenv.isx86_64 (with pkgs.jetbrains; [
    clion
    datagrip
    gateway
    goland
    idea-ultimate
    pycharm-professional
    webstorm
  ]);
}
