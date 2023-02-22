# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, ... }:

(self: super:
let
  justFuckingBuild = drv: with pkgs.haskell.lib; dontHaddock (dontCheck drv);
in
{
  xmonad = justFuckingBuild (self.callHackage "xmonad" "0.17.0" { });
  xmonad-contrib = justFuckingBuild (self.callHackage "xmonad-contrib" "0.17.0" { });
  xmonad-extras = justFuckingBuild (self.callHackage "xmonad-extras" "0.17.0" { });
}
)
