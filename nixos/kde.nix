# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, lib, ... }: {
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  hardware.video.hidpi.enable = lib.mkDefault true;
  # services.xserver.dpi = 192;

  environment.systemPackages = with pkgs; [
  ];
}
