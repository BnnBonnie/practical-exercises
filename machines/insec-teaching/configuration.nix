{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
  ];

  my.serverBase.enable = true;
  networking.useDHCP = false;

  users = {
    mutableUsers = false;
    users = {
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdEFX7/vv+sZPi9tI8F/2M3HCKM0T0bCoYOIUjRTLxC berber@fox"
        ];
      };
      berber = {
        isNormalUser = true;
        hashedPassword = "$6$NdDxI59jZjRuNl2.$QNR7xECzE0YuGFjCBt.mxTyte3kAu7FT3RztMYg4dcKHYFSPuBH3QFCxNV6zxePgrp0lTS7HsehOtnZPPStai.";
        extraGroups = [
          "wheel"
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdEFX7/vv+sZPi9tI8F/2M3HCKM0T0bCoYOIUjRTLxC berber@fox"
        ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    python3
  ];
}
