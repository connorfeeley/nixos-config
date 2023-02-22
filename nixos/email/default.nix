# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, ... }: {
  imports = [
    ./protonmail-bridge.nix
  ];
}
