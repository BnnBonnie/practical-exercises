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
      wg-pokemisch = {
        ips = [ "10.100.0.1/24" ];
        listenPort = 51820;
        postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enX0 -j MASQUERADE
      '';
        postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enX0 -j MASQUERADE
      '';
        privateKeyFile = "/roots/wireguard-keys/private";
        peers = [
          {
            publicKey = "";
            allowedIPs = [ "10.100.0.2/32" ];
          }
        ];
      };
    };
  };
}
