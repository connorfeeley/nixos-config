# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ config, pkgs, ... }:
{
  services.xserver.xkbOptions = "ctrl:swapcaps";
  console.useXkbConfig = true;
}
