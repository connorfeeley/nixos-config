# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }: {
  nix = {
    settings = {
      auto-optimise-store = true;
      # TODO: is it really reasonable to set these all as defaults?
      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.zsh.enable = true;

  programs.tmux.enableSensible = true;

  programs.nix-index.enable = true;

  # environment.enableAllTerminfo = true;

  environment.systemPackages =
    let apple_complete = (lib.lowPrio pkgs.apple_complete);
    in with pkgs; [
      #  Swiss Army Knife for macOS
      # => https://github.com/rgcr/m-cli
      m-cli
      mas
      terminal-notifier
      darwin.trash
      darwin.lsusb # <- lsusb for MacOS

      prefmanager # <- a tool for managing macOS defaults.
      wifi-password # <- what was that password again?

      macfuse-stubs # <- MacOS port of FUSE
      sshfs-fuse # <- sshfs for MacOS
      darwin.iproute2mac # <- MacOS implementation of iproute2
      apple_complete # <- bash completions for MacOS
      maclaunch # <- Manage your macOS startup items.
    ];

  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;
  services.nix-daemon = {
    enable = true;
    enableSocketListener = false; # 'true' causes connection refused error
  };
  nix.configureBuildUsers = true;

  # Add homebrew and macports packages to PATH
  environment.systemPath = [ config.homebrew.brewPrefix "/opt/local/bin" ];

  environment.pathsToLink = [ "/Applications" ];

  documentation = {
    # NOTE: All darwin-compatible documentation options are set in 'profiles/core'.
  };

  # Enable info and man pages
  programs = {
    info.enable = true;
    # Include "man" outputs of all systemPackages
    man.enable = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
