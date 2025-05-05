{
  config,
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
        peers = [
          {
            publicKey = "+CNroCuPJLV+EM1x+ll8P5yntAKxyDNKKeHah805gXc=";
            allowedIPs = [ "10.100.0.1/32" ];
          }
        ];
           # map (strings: {attr1 = builtins.elemAt strings 0; attr2 = builtins.elemAt strings 1;}) (map (lib.strings.splitString " ") (lib.strings.splitString "\n" (builtins.readFile ./wireguard-peers)));
      };
    };
  };
  # services = {
  #   nginx = {
  #     enable = true;
  #     recommendedProxySettings = true;
  #     virtualHosts = {
  #       "crypto.nocrypto" = {
  #         locations."/" = {
  #           return = "200 '<html><body>Crypto good or crypto bad?</body></html>'";
  #           extraConfig = ''
  #             allow 10.100.0.0/24;
  #             deny all;
  #           '';
  #         };
  #       };
  #     };
  #   };
  # };
}
