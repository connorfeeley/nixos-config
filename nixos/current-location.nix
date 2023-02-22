# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ config, pkgs, ... }:

{
  time.timeZone = "America/Toronto";

  location = {
    # Toronto
    latitude = 43.6532;
    longitude = -79.3832;
  };
}
