# SPDX-FileCopyrightText: 2020 zimbatm
#
# SPDX-License-Identifier: MIT

/*
  Filter package derivations based on their `meta.platforms` attribute.
  This is a function taken from flake-utils.
  @param  system   system for which to filter for
  @param  packages attrset of package derivations
  @return          attrset of all derivations for given system
  */
{ allSystems }:
system: packages:
let
  # Adopted from nixpkgs.lib
  inherit (builtins) listToAttrs concatMap attrNames;
  nameValuePair = name: value: { inherit name value; };
  filterAttrs = pred: set:
    listToAttrs (
      concatMap
        (name:
          let v = set.${name}; in
          if pred name v then [ (nameValuePair name v) ] else [ ]
        )
        (attrNames set)
    );

  # Everything that nix flake check requires for the packages output
  sieve = _n: v:
    with v;
    let
      inherit (builtins) isAttrs;
      isDerivation = x: isAttrs x && x ? type && x.type == "derivation";
      isBroken = meta.broken or false;
      platforms = meta.platforms or allSystems;
      badPlatforms = meta.badPlatforms or [ ];
    in
    # check for isDerivation, so this is independently useful of
      # flattenTree, which also does filter on derivations
    isDerivation v && !isBroken && (builtins.elem system platforms) &&
    !(builtins.elem system badPlatforms)
  ;
in
filterAttrs sieve packages
