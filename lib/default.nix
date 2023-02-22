# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ lib }:
let
  importers = import ./importers.nix { inherit lib; };
  filterPackages = import ./filterPackages.nix { allSystems = lib.platforms.all; };
in
lib.makeExtensible (_self: {
  inherit
    importers
    filterPackages
    ;
  inherit (importers) rakeLeaves flattenTree importOverlays importExportableModules importHosts;
})
