# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    steam
  ];
}
