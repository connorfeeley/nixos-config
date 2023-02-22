# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    steam
  ];

  # https://github.com/NixOS/nixpkgs/issues/47932#issuecomment-447508411
  hardware.opengl.driSupport32Bit = true;
}
