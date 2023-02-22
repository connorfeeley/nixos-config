# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, flake, ... }: {
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  users.extraGroups.vboxusers.members = [ flake.config.people.myself ];
}
