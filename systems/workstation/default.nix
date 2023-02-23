# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: BSD-3-Clause

{ flake, modulesPath, self, inputs, config, options, lib, pkgs, profiles, ... }:
let inherit (pkgs.stdenv.hostPlatform) isx86_64;
in
{
  # imports = [ ./hardware-configuration.nix ./zfs-root.nix ./samba.nix ];
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./hardware-configuration.nix
      ./zfs-root.nix
      ./samba.nix
    ];

  #   # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # OKAY: make sure I don't bork my system remotely!
  # Bork bork: https://www.youtube.com/watch?v=i1H0leZhXcY
  # assertions = lib.mkIf isVm [{
  #   # Ensure eth0 (motherboard ethernet) is using DHCP and that
  #   # tailscale, tailscaleUnlock, initrd networking, and initrd SSH are enabled.
  #   assertion =
  #     config.networking.interfaces.eth0.useDHCP &&
  #     config.services.tailscale.enable &&
  #     (config.remote-machine.boot.tailscaleUnlock.enable or true) &&
  #     config.boot.initrd.network.enable &&
  #     config.boot.initrd.network.ssh.enable;
  #   message = "Workstation may not be remotely accessible via tailscale.";
  # }];


  boot.initrd.availableKernelModules = [ "nvme" "ahci" "usbhid" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a006ffe3-5d21-4439-8a00-a527beb18ff7";
    fsType = "ext4";
  };

  swapDevices = [ ];

  nix.settings.max-jobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  # Network (Hetzner uses static IP assignments, and we don't use DHCP here)
  networking.useDHCP = false;
  networking.firewall.checkReversePath = "loose"; # Tailscale recommends this

  networking.interfaces."enp7s0" = {
    ipv4 = {
      addresses = [{
        # Server main IPv4 address
        address = "85.10.192.137";
        prefixLength = 24;
      }];

      routes = [
        # Default IPv4 gateway route
        {
          address = "0.0.0.0";
          prefixLength = 0;
          via = "85.10.192.129";
        }
      ];
    };

    ipv6 = {
      addresses = [{
        address = "2a01:4f8:a0:64e7::1";
        prefixLength = 64;
      }];

      # Default IPv6 route
      routes = [{
        address = "::";
        prefixLength = 0;
        via = "fe80::1";
      }];
    };
  };


  networking = {
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    hostName = "workstation";
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
  };

  services.netdata.enable = true;

  environment.systemPackages = with pkgs; [
    lsof
    nil
    nixpkgs-fmt
  ];

  services.openssh.enable = true;

  services.nginx.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "git@cfeeley.org";

  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # Normally the machine will power down after 20 minutes if no user is logged in.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  ### === users ================================================================

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${flake.config.people.myself} = {
    uid = 1000;
    isNormalUser = true;
    initialHashedPassword = "$6$V/uLpKYBvGk/Eqs7$IMguTPDVu5v1B9QBkPcIi/7g17DPfE6LcSc48io8RKHUjJDOLTJob0qYEaiUCAS5AChK.YOoJrpP5Bx38XIDB0";
    hashedPassword = "$6$V/uLpKYBvGk/Eqs7$IMguTPDVu5v1B9QBkPcIi/7g17DPfE6LcSc48io8RKHUjJDOLTJob0qYEaiUCAS5AChK.YOoJrpP5Bx38XIDB0";
    extraGroups =
      [
        "wheel"
        "video"
        "audio"
        "networkmanager"
        "dialout"
        "cfeeley"
        "secrets"
        "wireshark"
      ]
      ++ (lib.optional config.networking.networkmanager.enable "networkmanager")
      ++ (lib.optional config.services.mysql.enable "mysql")
      ++ (lib.optional config.virtualisation.docker.enable "docker")
      ++ (lib.optional config.virtualisation.podman.enable "podman")
      ++ (lib.optional config.virtualisation.libvirtd.enable "libvirtd")
      ++ (lib.optional config.virtualisation.virtualbox.host.enable "vboxusers")
    ;
    openssh.authorizedKeys.keys = flake.config.people.users.${flake.config.people.myself}.sshKeys;
    shell = pkgs.zsh;
  };
  users.users.root.hashedPassword = "$6$V/uLpKYBvGk/Eqs7$IMguTPDVu5v1B9QBkPcIi/7g17DPfE6LcSc48io8RKHUjJDOLTJob0qYEaiUCAS5AChK.YOoJrpP5Bx38XIDB0";
  security.sudo.wheelNeedsPassword = false;

  ### === xorg ================================================================

  # Mapped from left to right
  # Affects /etc/X11/xorg.conf
  services.xserver = {
    xrandrHeads = [
      {
        output = "DP-0";
        monitorConfig = ''
          DisplaySize 607 345
          Option      "DPMS"
        '';
      }
      {
        output = "HDMI-0";
        primary = true;
        monitorConfig = ''
          DisplaySize 697 392
          Option      "DPMS"
        '';
      }
      {
        output = "DP-2";
        monitorConfig = ''
          DisplaySize 607 345
          Option      "DPMS"
        '';
      }
    ];
    displayManager = {
      autoLogin = {
        # Log in automatically
        enable = true;
        user = flake.config.people.myself;
      };

      sessionCommands = ''
        # Fix keyring unlock
        ${
          lib.getBin pkgs.dbus
        }/bin/dbus-update-activation-environment --systemd --all
      '';
    };
  };

  system.stateVersion = "20.03";
}
