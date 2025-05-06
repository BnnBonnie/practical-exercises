{
  config,
  lib,
  ...
}: {
  networking = {
    nat = {
      enable = true;
      externalInterface = "enX0";
      internalInterfaces = [ "wg-insec" ];
    };
    firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ config.networking.wireguard.interfaces.wg-insec.listenPort ];
      extraCommands = ''
        iptables -A OUTPUT -p all -m owner --uid-owner insecguest -d 127.0.0.1 -j ACCEPT
        iptables -A OUTPUT -p all -m owner --uid-owner insecguest -d 10.100.0.0/24 -j ACCEPT
        iptables -A OUTPUT -p all -m owner --uid-owner insecguest -j DROP
        ip6tables -A OUTPUT -p all -m owner --uid-owner insecguest -j DROP
      '';
      extraStopCommands = ''
        iptables -D OUTPUT -p all -m owner --uid-owner insecguest -d 127.0.0.1 -j ACCEPT || true
        iptables -D OUTPUT -p all -m owner --uid-owner insecguest -d 10.100.0.0/24 -j ACCEPT || true
        iptables -D OUTPUT -p all -m owner --uid-owner insecguest -j DROP || true
        ip6tables -D OUTPUT -p all -m owner --uid-owner insecguest -j DROP || true
      '';
    };
    wireguard.interfaces = {
      wg-insec = {
        ips = [ "10.100.0.255/24" ];
        listenPort = 51820;
      #   postSetup = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enX0 -j MASQUERADE
      # '';
      #   postShutdown = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enX0 -j MASQUERADE
      # '';
        privateKeyFile = "/root/wireguard-keys/private";
        peers = (
          lib.lists.imap1
          (
            i:
            key:
            { publicKey = key; allowedIPs = [ "10.100.0.${toString i}/32" ]; }
          )
          (lib.strings.splitString "\n" (builtins.readFile ./wireguard-peers))
        );
      };
    };
  };
  users.users.insecguest = {
    isNormalUser = true;
    homeMode = "500";
    openssh.authorizedKeys.keys = lib.strings.splitString "\n" (builtins.readFile ./ssh-keys);
  };
  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "isthis.crypto" = {
          root = "/var/www/isthis.crypto/"; # please make reproducible within nix next!
          locations."/" = {            
            extraConfig = ''
              allow 10.100.0.0/24;
              deny all;
            '';
          };
        };
      };
    };
    meme-bingo-web = {
      enable = true;
      baseUrl = "http://localhost:41678/";
      port = 41678;
    };
  };
}
