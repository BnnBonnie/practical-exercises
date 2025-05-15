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
    wireguard.interfaces = {
      wg-insec = {
        ips = [ "10.7.0.255/24" ];
        listenPort = 51820;
      #   postSetup = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enX0 -j MASQUERADE
      # '';
      #   postShutdown = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enX0 -j MASQUERADE
      # '';
        privateKeyFile = "/wireguard-private";  # dangerous!  but on purpose.
        peers = (
          lib.lists.imap1
          (
            i:
            key:
            { publicKey = key; allowedIPs = [ "10.7.0.${toString i}/32" ]; }
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
              allow 10.7.0.0/24;
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
