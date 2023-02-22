# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, inputs, ... }:
{
  imports = [
    "${inputs.nixos-vscode-server}/modules/vscode-server/home.nix"
  ];

  services.vscode-server.enable = true;
}
