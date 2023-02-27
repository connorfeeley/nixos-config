# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }: {
  home.packages = with pkgs.jetbrains; [
    clion
    datagrip
    gateway
    goland
    idea-ultimate
    pycharm-professional
    webstorm
  ];
}
