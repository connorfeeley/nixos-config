# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ config, lib, ... }:
let
  userSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
      };
      email = lib.mkOption {
        type = lib.types.str;
      };
      sshKeys = lib.mkOption {
        description = "SSH public keys";
        type = lib.types.listOf lib.types.str;
      };
      gpgKey = lib.mkOption {
        description = "GPG key information";
        type = lib.types.submodule {
          options = {
            keygrip = lib.mkOption {
              type = lib.types.str;
              description = "Keygrip of the GPG key";
            };
            public = lib.mkOption {
              type = lib.types.str;
              description = "Public key";
            };
            publicKeyFile = lib.mkOption {
              type = lib.types.path;
              description = "Public key file";
            };
          };
        };
      };
    };
  };
  peopleSubmodule = lib.types.submodule {
    options = {
      users = lib.mkOption {
        type = lib.types.attrsOf userSubmodule;
      };
      myself = lib.mkOption {
        type = lib.types.str;
        description = ''
          The name of the user that represents myself.

          Admin user in all contexts.
        '';
      };
    };
  };
in
{
  options = {
    people = lib.mkOption {
      type = peopleSubmodule;
    };
  };
  config = {
    people = import ./config.nix;
  };
}
