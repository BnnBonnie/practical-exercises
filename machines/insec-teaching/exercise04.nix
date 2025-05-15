{
  ...
}: {
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      juice-shop = {
        image = "bkimminich/juice-shop";
        ports = ["127.0.0.1:3010:3000"];
        autoStart = true;
      };
    };
  };
}
