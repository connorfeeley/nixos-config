# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, lib, inputs, system, ... }:

{
  # TODO: use agenix to manage
  # - secrets
  # - ssh keys
  services.hercules-ci-agent = {
    # FIXME: upstream is 9 kinds of broken
    # enable = with pkgs.stdenv; is64bit && isx86_64;
    enable = true;
    # nixpkgs may not always have the latest HCI.
    # package = inputs.hercules-ci-agent.packages.${system}.hercules-ci-agent;
  };

  # Regularly optimize nix store if using CI, because CI use can produce *lots*
  # of derivations.
  nix.gc = {
    automatic = ! pkgs.stdenv.isDarwin; # Enable only on Linux
    options = "--delete-older-than 90d";
  };
}
