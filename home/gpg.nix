{ flake
, config
, lib
, pkgs
, ...
}:
let
  people = flake.config.people;
  gpgKey = people.users.${people.myself}.gpgKey;
in
{
  home.sessionVariables.PGP_KEY = gpgKey.public;

  home.packages = with pkgs; [
    gnupg
    gpgme

    (writeShellScriptBin "gpg-agent-restart" ''
      pkill gpg-agent ; pkill ssh-agent ; pkill pinentry ; eval $(gpg-agent --daemon --enable-ssh-support)
    '')
  ];

  services.gpg-agent = {
    enable = pkgs.stdenv.isLinux;
    enableSshSupport = true;
    sshKeys = [ gpgKey.keygrip ];

    enableExtraSocket = true;

    enableZshIntegration = true;

    # 10 hour cache timeout
    defaultCacheTtl = 10 * 60 * 60;
    defaultCacheTtlSsh = 10 * 60 * 60;

    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

  programs.gpg = {
    enable = true;

    mutableKeys = false;
    mutableTrust = false;

    publicKeys = [
      {
        source = gpgKey.public;
        trust = "ultimate";
      }
    ];

    # https://github.com/drduh/config/blob/master/gpg.conf
    # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
    # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
    settings = {
      # Keyserver URL
      keyserver = "hkps://keys.openpgp.org";
      # keyserver hkps://keyserver.ubuntu.com:443
      # keyserver hkps://hkps.pool.sks-keyservers.net
      # keyserver hkps://pgp.ocf.berkeley.edu
    };
  };
}
