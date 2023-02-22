# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, flake, ... }: {
  virtualisation.lxd.enable = true;

  users.users.${flake.config.people.myself} = {
    extraGroups = [ "lxd" ];
  };
}
