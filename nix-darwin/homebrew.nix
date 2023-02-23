# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }: {
  homebrew.caskArgs = {
    appdir = "~/Applications";
    require_sha = true;
  };
}
