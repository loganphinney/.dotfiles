{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];
  system.stateVersion = "26.05";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "determinate-lab";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  users.users.loganp = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "media"
    ];
    shell = pkgs.zsh;
    # packages = with pkgs; [ ];
  };
  security.sudo.wheelNeedsPassword = false;
  environment.systemPackages = with pkgs; [
    tmux
    gcc
    git
    wget
    curl
    rsync
    btop
    lazydocker
    lazygit
    eza
    fd
    ripgrep
    gnumake
    python314
    kitty.terminfo
  ];
  programs.zsh.enable = true;
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      PasswordAuthentication = false;
    };
  };
  services.fail2ban.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    80
    443
    3000
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];
  services.caddy = {
    enable = true;
    virtualHosts."jellyfin.loganphinney.com".extraConfig = ''
      reverse_proxy localhost:8096
    '';
    virtualHosts."immich.loganphinney.com".extraConfig = ''
      reverse_proxy localhost:2283
    '';
  };
  services = {
    jellyfin = {
      enable = true;
      group = "media";
      openFirewall = true;
    };
    immich = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
    };
    grafana = {
      enable = true;
      settings.security.secret_key = "77764cbb7ee9e979b8bae4b843808566";
      settings.server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://127.0.0.1:3100";
            isDefault = true;
          }
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://127.0.0.1:9090";
          }
        ];
      };
    };
    prometheus = {
      enable = true;
      exporters.node = {
        enable = true;
        port = 9100;
      };
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [ "127.0.0.1:9100" ];
            }
          ];
        }
      ];
    };
    loki = {
      enable = true;
      configuration = {
        auth_enabled = false;
        server = {
          http_listen_port = 3100;
        };
        common = {
          ring = {
            instance_addr = "127.0.0.1";
            kvstore.store = "inmemory";
          };
          replication_factor = 1;
          path_prefix = "/tmp/loki";
        };
        schema_config.configs = [
          {
            from = "2020-05-15";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
        storage_config.filesystem = {
          directory = "/tmp/loki/chunks";
        };
      };
    };
    fluent-bit = {
      enable = true;
      settings = {
        service = {
          flush = 1;
          log_level = "info";
        };
        pipeline = {
          inputs = [
            {
              name = "systemd";
              tag = "services.jellyfin";
              systemd_filter = "_SYSTEMD_UNIT=jellyfin.service";
            }
            {
              name = "systemd";
              tag = "services.immich";
              systemd_filter = "_SYSTEMD_UNIT=immich.service";
            }
            {
              name = "systemd";
              tag = "services.grafana";
              systemd_filter = "_SYSTEMD_UNIT=grafana.service";
            }
          ];
          outputs = [
            {
              name = "loki";
              match = "*";
              host = "127.0.0.1";
              port = 3100;
              labels = [ "job=fluent-bit" ];
              line_format = "json";
            }
          ];
        };
      };
    };
  };
  users.groups.media = {
    members = [
      "jellyfin"
    ];
  };
}
