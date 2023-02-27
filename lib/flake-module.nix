# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

# Support code for this repo. This module could be made its own external repo.
{ self, inputs, config, ... }:
{
  flake = {
    # WARNING: don't define modules here
    lib = {
      commonOverlays = with inputs; [
        agenix.overlay
        emacs-overlay.overlays.default
        gitignore.overlay
        nur.overlay
        nvfetcher.overlays.default

        nix-xilinx.overlay

        (final: _prev:
          let
            packagesFrom = inputAttr: inputAttr.packages.${final.system};
          in
          {
            inherit (packagesFrom self.packages) emacs-plus;
            inherit (packagesFrom inputs.devenv) devenv;
            inherit (packagesFrom inputs.deploy) deploy-rs;
            inherit (packagesFrom inputs.deploy-flake) deploy-flake;
            inherit (packagesFrom inputs.prefmanager) prefmanager;
            inherit (packagesFrom inputs.nix-nil) nil;
            inherit (packagesFrom inputs.nix-alien) nix-alien;
            inherit (packagesFrom inputs.nix-alien) nix-index-update;
            inherit (packagesFrom inputs.nix-autobahn) nix-autobahn;
            inherit (packagesFrom inputs.chatgpt-wrapper) chatgpt-wrapper;

            # Personal packages
            inherit (packagesFrom inputs.nurpkgs) apple_complete maclaunch toronto-backgrounds;
            inherit (packagesFrom inputs.xmonad-config) xmonad-config;
            inherit (packagesFrom inputs.ttc-subway-font) ttc-subway bloor-yonge-font;

            inherit (inputs.nixpkgs-input-leap.legacyPackages.${final.system}) input-leap;

            nix-init = inputs.nix-init.packages.${final.system}.default;
            emacsGitDarwin = inputs.darwin-emacs.packages.${final.system}.default;
            neovim-plusultra = inputs.neovim-plusultra.packages.${final.system}.neovim;
          }
        )
      ];
      mkLinuxSystem = system: mod: inputs.nixpkgs.lib.nixosSystem rec {
        inherit system;
        # Arguments to pass to all modules.
        specialArgs = {
          inherit system inputs;
          flake = { inherit config; };
          # Pass flake packages with system pre-selected as arg.
          packages' = self.packages.${system};
        };
        modules = [ self.nixosModules.nixpkgs mod ];
      };

      mkMacosSystem = system: mod: inputs.darwin.lib.darwinSystem rec {
        inherit system;
        specialArgs = {
          inherit inputs system;
          flake = { inherit config; };
          # Pass flake packages with system pre-selected as arg.
          packages' = self.packages.${system};
          rosettaPkgs = import inputs.nixpkgs { system = "x86_64-darwin"; };
        };
        modules = [ self.darwinModules.nixpkgs mod ];
      };
    };
  };

  perSystem = { system, config, pkgs, lib, ... }: {
    # NOTE: Override the darwin.builder package to use more cores
    # See nixpkgs:doc/builders/special/darwin-builder.section.md
    packages.builder =
      let
        modulesPath = "${inputs.nixpkgs}/nixos/modules";
        toGuest = builtins.replaceStrings [ "darwin" ] [ "linux" ];

        nixos = import "${inputs.nixpkgs}/nixos" {
          configuration = {
            imports = [ (modulesPath + "/profiles/macos-builder.nix") ];

            # Embed my pubilc SSH key into the builder
            # users.users.builder.openssh.authorizedKeys.keys = self.config.people.users.${config.people.myself}.sshKeys;

            # Hercules CI seems to have a build-time dependency on x86_64-linux
            boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

            virtualisation = {
              host = { inherit pkgs; };

              cores = 8; # Builder go brrrr
              memorySize = lib.mkOverride 9 (1024 * 6); # 6 GiB - otherwise OOMs on emacsGit

              msize = 1024 * 1024 * 100; # 100M
            };
          };

          system = toGuest pkgs.stdenv.hostPlatform.system;
        };
      in
      nixos.config.system.build.macos-builder-installer;

    packages.workstation-aarch64-vm =
      let
        modulesPath = "${inputs.nixpkgs}/nixos/modules";
        toGuest = builtins.replaceStrings [ "darwin" ] [ "linux" ];

        nixos = self.lib.mkLinuxSystem (toGuest pkgs.stdenv.hostPlatform.system) {
          imports = [
            self.nixosConfigurations.workstation.config.system
            {
              # Platform of the VM
              nixpkgs.hostPlatform = "aarch64-linux";

              virtualisation = {
                # Platform of the host
                host = { inherit pkgs; };
              };
              environment.systemPackages = [pkgs.hello];
            }
          ];
        };
      in
      nixos.config.system.build.vm;
      # nixos.config.system.build.toplevel;

    mission-control.scripts = {
      builder = {
        description = "Run NixOS aarch64-linux builder on macOS ('C-a x' to shutdown)";
        exec = "${self.packages.${system}.builder}/bin/create-builder";
      };
      update-primary = {
        description = ''
          Update primary flake inputs
        '';
        exec =
          let
            inputs = [ "nixpkgs" "home-manager" "darwin" ];
          in
          ''
            nix flake lock ${lib.foldl' (acc: x: acc + " --update-input " + x) "" inputs}
          '';
      };

      activate = {
        description = "Activate the current configuration for local system";
        exec =
          # TODO: Replace with deploy-rs or (new) nixinate
          if system == "aarch64-darwin" then
            ''
              cd "$(${lib.getExe config.flake-root.package})"
              ${self.darwinConfigurations.MacBook-Pro.system}/sw/bin/darwin-rebuild \
                switch --flake .#default
            ''
          else
            ''
              ${lib.getExe pkgs.nixos-rebuild} --use-remote-sudo switch -j auto
            '';
        category = "Main";
      };

      fmt = {
        description = "Autoformat repo tree";
        exec = "nix fmt";
      };
    };
  };
}
