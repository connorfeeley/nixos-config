# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ config, pkgs, ... }:

# Based on https://nixos.wiki/wiki/Redshift
{
  services.redshift = {
    enable = true;
  };
}
