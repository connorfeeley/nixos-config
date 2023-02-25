# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: MIT

{ flake, config, ... }:
let people = flake.config.people;
in {
  virtualisation.oci-containers.backend = "docker";

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      # Default: /var/lib/docker
      data-root = "/var/lib/docker"; # "/mnt/ssd/docker";
    };

    # Fixes nixos hanging on shutdown for a few minutes
    liveRestore = false;
  };

  users.users.${people.myself}.extraGroups = [ "docker" ];
}
