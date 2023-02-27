# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ self, inputs, config, ... }:
{
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "21.11";
        imports = [
          ./tmux.nix
          ./neovim.nix
          ./starship.nix
          ./terminal.nix
          ./direnv.nix
          ./gpg.nix
          ./git.nix
          ./kitty
        ];
      };
      common-linux = {
        imports = [
          self.homeModules.common
          ./vscode-server.nix

          ./gnome
        ];
        programs.bash.enable = true;
      };
      docker.imports = [ ./virtualisation/docker.nix ];
      common-darwin = {
        imports = [
          self.homeModules.common
        ];
      };
      emacs = {
        imports = [ ./emacs ];
        programs.bash.enable = true;
      };
      jetbrains.imports = [ ./jetbrains ];
    };
  };
}
