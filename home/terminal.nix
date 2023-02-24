# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, inputs, system, ... }:
{
  # Key packages required on nixos and macos
  home.packages = with pkgs; [
    # Unixy tools
    gnumake
    ripgrep
    fd
    procs

    inputs.comma.packages.${system}.default
  ];

  programs = {
    bat.enable = true;
    exa.enable = true;
    htop.enable = true;
    autojump.enable = false;
    zoxide.enable = true;
    fzf.enable = true;
    jq.enable = true;

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
