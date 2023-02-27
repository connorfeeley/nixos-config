# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{ flake, config, pkgs, lib, packages', ... }:

# https://nixos.wiki/wiki/Distributed_build
{
  nix.buildMachines = [
    {
      hostName = "workstation";
      sshUser = "${flake.config.people.myself}";
      # system = "x86_64-linux";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.,
      systems = [ "x86_64-linux" "aarch64-linux" ];
      maxJobs = 16;
      speedFactor = 3;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
    {
      hostName = "localhost";
      sshUser = "builder";
      # system = "x86_64-linux";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.,
      systems = [ "x86_64-linux" "aarch64-linux" ];
      maxJobs = 16;
      speedFactor = 3;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
      sshKey = "/Users/cfeeley/source/nixos-config/keys/builder_ed25519";
    }
  ];
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  # Customized MacOS builder (with aarch64-linux and x86_64-linux support)
  environment.systemPackages = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin [ packages'.builder ];
}
