{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
  ];

  my.serverBase.enable = true;
  networking = {
    useDHCP = false;
    defaultGateway = {
      address = "130.149.221.222";
      interface = "enX0";
    };
    interfaces.enX0 = {
      ipv4 = {
        addresses = [
          {
            address = "130.149.221.218";
            prefixLength = 27;
          }
        ];
      };
    };
    nameservers = [
      "9.9.9.9"
    ];
  };

  boot = {
    loader = {
      systemd-boot.enable = lib.mkForce false;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        efiInstallAsRemovable = true;
      };
      efi.canTouchEfiVariables = lib.mkForce false;
    };
    growPartition = true;
  };

  users = {
    mutableUsers = false;
    users = {
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdEFX7/vv+sZPi9tI8F/2M3HCKM0T0bCoYOIUjRTLxC berber@fox"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmT7ak1rBQqSq+TNcrHep5QdHs3Aq1PpZV6RY3QbAH2 berber@peach"
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmT7ak1rBQqSq+TNcrHep5QdHs3Aq1PpZV6RY3QbAH2 berber@peach"
        ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    python3
  ];
}
