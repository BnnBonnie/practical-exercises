{
  pkgs,
  data,
  config,
  lib,
  ...
}: let
  cfg = config.my.serverBase;
in {
  imports = [
  ];
  options = {
    my.serverBase = {
      enable = lib.mkEnableOption "My server base configuration";
    };
  };
  config = lib.mkIf cfg.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    system.stateVersion = data.stateVersion;
    networking = {
      hostName = data.hostName;
      firewall.allowedTCPPorts = [ 22 ];
    };

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      growPartition = true;
    };

    time.timeZone = "Europe/Berlin";

    i18n = {
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "en_DK.UTF-8/UTF-8"
      ];
      defaultLocale = "en_DK.UTF-8";
      extraLocaleSettings = {
        LC_MEASUREMENT = "en_DK.UTF-8";
        LC_TIME = "en_DK.UTF-8";
      };
    };

    services = {
      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
      };
      fail2ban = {
        enable = true;
      };
    };
    
    users = {
      users = {
        guest = {
          uid = 1000;
          isNormalUser = true;
        };
      };
    };
<<<<<<< HEAD
    nix.allowed-users = [
=======
    nix.settings.allowed-users = [
>>>>>>> bb8e8fe3d04e7e81cb997d3ddb5b2e94f29c5c8d
      "@wheel"
    ];
    environment.systemPackages = with pkgs; [
      emacs-nox
      git      
      neovim
      toybox
    ];
  };
}

