# SPDX-FileCopyrightText: 2023 Connor Feeley
#
# SPDX-License-Identifier: BSD-3-Clause

{ flake, config, ... }:
# Source: https://fy.blackhats.net.au/blog/html/2021/03/22/time_machine_on_samba_with_zfs.html

# Server setup: sudo smbpasswd -a cfeeley
# MacOS setup: tmutil setdestination smb://cfeeley:<password>@workstation/timemachine
{
  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      ### GENERAL ###
      browseable = yes
      server string = workstation
      netbios name = workstation

      use sendfile = yes

      # note: localhost is the ipv6 localhost ::1
      hosts allow = 100. 192.168.0. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '' + ''
    '';
    shares = {
      global = {
        ### TIME MACHINE ###
        "min protocol" = "SMB2";
        "ea support" = "yes";

        # This needs to be global else time machine ops can fail.
        "vfs objects" = "fruit streams_xattr";
        "fruit:aapl" = "yes";
        "fruit:metadata" = "netatalk";
        "fruit:model" = "MacSamba";
        "fruit:posix_rename" = "yes";
        "fruit:veto_appledouble" = "no";
        "fruit:zero_file_id" = "yes";
        "fruit:nfs_aces" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
        "spotlight" = "no";
      };
      "Data" = {
        path = "/mnt/zfs/data";
        "valid users" = "cfeeley";
        public = "no";
        browsable = "yes";
        writeable = "yes";
        "force user" = "cfeeley";
        "fruit:aapl" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
      "Media" = {
        path = "/mnt/zfs/media";
        "valid users" = "cfeeley";
        public = "no";
        browsable = "yes";
        writeable = "yes";
        "force user" = "cfeeley";
        "fruit:aapl" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
      "Backup" = {
        path = "/mnt/zfs/backup";
        "valid users" = "cfeeley";
        public = "no";
        browsable = "yes";
        writeable = "yes";
        "force user" = "cfeeley";
        "fruit:aapl" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
      "${flake.config.people.myself}" = {
        path = "/home/${flake.config.people.myself}";
        "valid users" = "cfeeley";
        public = "no";
        browsable = "yes";
        writeable = "yes";
        "force user" = "cfeeley";
        "fruit:aapl" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
      tm_share = {
        path = "/mnt/zfs/backup/time_machine";
        "valid users" = "cfeeley";
        public = "no";
        writeable = "yes";
        "force user" = "cfeeley";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
    };
  };

  ### === Shares ============================================================
  fileSystems."/mnt/export/cfeeley" = {
    device = "/home/cfeeley";
    options = [ "bind" ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /mnt/export         100.66.73.0/24(rw,fsid=0,no_subtree_check,all_squash,anonuid=0,anongid=100)
    /mnt/export/cfeeley 100.66.73.0/24(rw,nohide,insecure,no_subtree_check,all_squash,anonuid=0,anongid=100)
  '';

  # services.webdav = {
  #   enable = true;
  #   user = "cfeeley";
  #   settings = {
  #     # Only expose via tailscale
  #     address = peers.hosts.${hostName}.tailscale;
  #     port = 33464;
  #     auth = false;
  #     tls = false;
  #     prefix = "/";
  #     debug = true; #FIXME

  #     # Default user settings (will be merged)
  #     scope = ".";
  #     modify = true;
  #     rules = [ ];
  #   };
  # };

}
