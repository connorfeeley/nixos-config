# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ pkgs, inputs, system, ... }:
{
  programs.neovim = {
    coc.settings.languageserver.rust = {
      command = "rust-analyzer";
      args = [ ];
      rootPatterns = [
        "Cargo.lock"
      ];
      filetypes = [ "rust" ];
    };

    plugins = with pkgs.vimPlugins; [
      rust-vim
      {
        plugin =
          (pkgs.vimUtils.buildVimPlugin {
            name = "coc-rust-analyzer";
            src = inputs.coc-rust-analyzer;
          });
        type = "lua";
        config = ''
        '';
      }
    ];

  };
}
