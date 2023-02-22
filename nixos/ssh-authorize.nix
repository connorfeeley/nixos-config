# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ config, pkgs, lib, flake, ... }:

{
  # Let me login
  users.users =
    let
      people = flake.config.people;
      myKeys = people.users.${people.myself}.sshKeys;
    in
    {
      root.openssh.authorizedKeys.keys = myKeys;
      ${people.myself}.openssh.authorizedKeys.keys = myKeys;
    };
}
