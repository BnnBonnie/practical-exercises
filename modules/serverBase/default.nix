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
    networking.hostName = data.hostName;

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
    
    users = {
      users = {
        guest = {
          uid = 1000;
          isNormalUser = true;
        };
      };
    };
    environment.systemPackages = with pkgs; [
      emacs-nox
      git      
      nvim
      python3
      toybox
    ];
  };
}

