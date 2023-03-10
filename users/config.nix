# SPDX-FileCopyrightText: 2023 Sridhar Ratnakumar
#
# SPDX-License-Identifier: BSD-3-Clause

{
  myself = "cfeeley";
  users = {
    cfeeley = {
      name = "Connor Feeley";
      email = "git@cfeeley.org";
      sshKeys = [
        # Yubikey/GPG
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXwfYATGpZ/8EH8+i6idMaSWEW3EfgvT/cXy4zmgGbQRfHlG7jc8qokUtAy1xR4tSk8979bEzHZnBQ5LUGpu4a7W0ufd2uCg0OOxDs7lPPsxmrl4hdkn9kfw0fIdEpUej3EFuQjJcdLYT6z3zqK1KCzosa9AEiEwaflnI5+abqVhQ0q2IchYQqNxfpAIigxQ07h+EA7hJiOl8Vt9/z8Iky+iLnvdT6v1QO2XOhqD2uO+LzBThQ/5wJXsueLUw05FAe5zVCx55K1ui6HvMrgHUZ/rVSQr5X9AYvgCBwUPpY3TuyLBepHG4egccU8eFIY/uw0LFxN1Tkj91LA7mLcveVhNoWo6gIGlx6iJXidHPkZlJcAJ+eq4RNf+3gkSZ46m0p0X4hJgurMr5vTzSR4tDOSkrAgdJL6SSqNcnZZuQNg7JJDxRLrWuFup4UBGFb9/odwXa4rAgMP6dol6UhpIgVFklmbfg4FWD8YaJ1M1lVo6Jid6wVypYwpB+t13k5PdxVzjUJeOTV6jdENRE5+gk6GXoLrxYZp7u0JKmxybYcJ0U6H0azp35BKNYJaobqwtFA+3FL/pnpdRmwLWweqzZV46iO6Vq/T5r4fDxY6nc6d210VbAiFTz4HU743O30w/+3P3csu+E4LAaA8PAvJLNFPLBuMzc67mp00E1irz+Z5w== (none)"
        # MBP GPG?
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDl8t557a4X/GHvN7VF6KDdtPT2LETb7iFBCc4VPRzJZUTf1vYE7UD3WI5CRvFNtPOvRlYqiClViIXShB5KIW1X+UIvv81ls3bynZKfFofqD+lBtGnhwu3NyS93gwES4zaVt6tngkKXKgIPnlCXBhvoFRpN2MvueWg8moT+cYXbc4s8asc9v04DEPY2LZ9qtR5M/0Wkkh2tQByaUmIhLH80m++pfN/GN5Q74aCZ920YrifGYjvZoFPbdFvBdAxxqJTtpyFYJLo8BALZkXmbbjI11KYKH9AlWUrDGkRW95F6KF/9kWx+PCXLuPPqgXCz9JAyW7n5I3iupDrQplnecjs8iEficYcoFC8mZWmxOTYkOAEANg4tYVB2VgSoXeXDXanwTIvmOGhs/rdO9jbI6CAiPoj/A3s3Mc4t2eb/VPeHfyG5rvdLQU17zyatIAYyG2oUPZ3twkap6PvSw+gBi/npiy8XSWhqyn4rz9l+4upH1k7fydymZJSOKuu7EfoWrzAHgf3L/A9ggM7IiTbobssuIt3FyZ56npzpBbMbAhQXnV0Ch5RCcMHVRKkoYxgjSW4G7floFDuGjTEQ1SkX6+5EqrYUfIgPmiBbICEW4t92TZ+HJ6gYDs5wxICWxB9mcsZXw507rOh+zMa3PuCaf3SU9k+IKty/g8vFTe48Q4sMjw== (none)"
        # MacBook-Pro
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICyCzd5UcqFUC3O7r62N3sx6ywXcayHQRV3jWJC8OQyl cfeeley@Connors-MacBook-Pro.local"
        # Desktop
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCVmAx+FNqurkG9eQ7icgqS1tOzy1JyL+spWMr477mU cfeeley@workstation"
      ];
      gpgKey = { public = "0x77CB2390C53B4E5B"; publicKeyFile = ../secrets/gpg-0x77CB2390C53B4E5B.txt; keygrip = "C4A4A4DC29AB0B5672495337D1E313F5B57E11DE"; };
    };
  };
}
