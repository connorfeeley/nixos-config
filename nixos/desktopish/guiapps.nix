# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, ... }: {
  imports = [
    ./vscode.nix
  ];

  # Apps I use on desktops and laptops
  environment.systemPackages = with pkgs; [
    brave
    firefox
    # onlyoffice-bin
    obsidian

    _1password
    _1password-gui

    simplescreenrecorder
    obs-studio

    vlc
    qbittorrent

    # X stuff
    caffeine-ng
    xorg.xdpyinfo
    xorg.xrandr
    xclip
    xsel
    arandr
  ];
}
