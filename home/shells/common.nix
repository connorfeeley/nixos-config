# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: BSD-3-Clause

{ lib
, pkgs
, ...
}:
{
  imports = [
    ./fzf.nix
    ./starship.nix
  ];

  home.packages =
    let
      md = pkgs.writeShellScriptBin "md" ''
        [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1"
      '';

      stderred-wrapper = pkgs.writeShellApplication {
        name = "stderred";
        runtimeInputs = with pkgs; [ stderred ];
        text = ''
          # Export LD_PRELOAD with stderred hooks
          export LD_PRELOAD="${pkgs.stderred}/lib/libstderred.so''${LD_PRELOAD:+:$LD_PRELOAD}"

          # Run command
          "$@"
        '';
      };
    in
    [
      md
      stderred-wrapper # Highlight stderr in red
      pkgs.emacsPackages.vterm
    ];

  programs.bashmount = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
