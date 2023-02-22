# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ config, pkgs, ... }:

{
  time.timeZone = "America/New_York";

  location = {
    # Quebec City
    latitude = 46.813359;
    longitude = -71.215796;
  };
}
