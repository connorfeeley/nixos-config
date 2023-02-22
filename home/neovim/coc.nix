# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, inputs, system, ... }:
{
  programs.neovim = {
    coc = {
      enable = true;
    };

    extraPackages = [
      pkgs.nodejs # coc requires nodejs
    ];
  };
}
