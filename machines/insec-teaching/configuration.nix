{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./exercise03.nix
    ./exercise04.nix
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
    firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ config.networking.wireguard.interfaces.wg-insec.listenPort ];
      extraCommands = ''
        iptables -A OUTPUT -p all -m owner --uid-owner insecguest -d 127.0.0.1 -j ACCEPT
        iptables -A OUTPUT -p all -m owner --uid-owner insecguest -d 10.7.0.0/24 -j ACCEPT
        iptables -A OUTPUT -p all -m owner --uid-owner insecguest -j DROP
        ip6tables -A OUTPUT -p all -m owner --uid-owner insecguest -j DROP
      '';
      extraStopCommands = ''
        iptables -D OUTPUT -p all -m owner --uid-owner insecguest -d 127.0.0.1 -j ACCEPT || true
        iptables -D OUTPUT -p all -m owner --uid-owner insecguest -d 10.7.0.0/24 -j ACCEPT || true
        iptables -D OUTPUT -p all -m owner --uid-owner insecguest -j DROP || true
        ip6tables -D OUTPUT -p all -m owner --uid-owner insecguest -j DROP || true
      '';
    };
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIND9kUmAEwH+qD6T+Gs/G83SA/oyIzpz1Zj4oMAkOvhO emily@work"
        ];
        hashedPassword = "$6$SWgc2WIEw2c6fvrx$T21J7URJxvxAxgf4DkHd1rnIhgNWcjNxXFOu8rYGiGb2sodIrQXr4xK0fNHwuj53w1CgCo0Bk0j4QEE/MVFbG1";
      };
      berber = {
        isNormalUser = true;
        hashedPassword = "$6$7C5ZqpngNAFqab/H$dDrPyOQli9qy0rji8.cXYVO6v8Lnialwgjg8yYcdylYTGjFVuS5p0Eat.WLqOMelJ9laNGQ71NzgJ2IC18YIN0";
        extraGroups = [
          "wheel"
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdEFX7/vv+sZPi9tI8F/2M3HCKM0T0bCoYOIUjRTLxC berber@fox"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmT7ak1rBQqSq+TNcrHep5QdHs3Aq1PpZV6RY3QbAH2 berber@peach"
        ];
      };
      insecguest = {
        isNormalUser = true;
        homeMode = "500";
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
