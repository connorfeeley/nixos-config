# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, config, ... }: {
  virtualisation.docker.enable = true;

  users.users.${config.people.myself} = {
    extraGroups = [ "docker" ];
  };
}
