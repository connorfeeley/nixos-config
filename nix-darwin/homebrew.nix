# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }: {
  environment.systemPath = [ config.homebrew.brewPrefix "/opt/local/bin" ];
  homebrew = {
    enable = true;
    onActivation = {
      upgrade = false;
      cleanup = "zap";
    };
    global = {
      brewfile = true; # Use generated Brewfile in the nix store
      autoUpdate = false; # Don't auto-update formulae when running brew manually
    };
    caskArgs = {
      appdir = "~/Applications";
      require_sha = false; # Casks must have a checksum
      no_binaries = false; # Enable linking of helper executables
      no_quarantine = true; # Disable quarantining of downloads
    };

    masApps = {
      "Tailscale" = 1475387142;
    };
    brews = [ ];
  };
}
