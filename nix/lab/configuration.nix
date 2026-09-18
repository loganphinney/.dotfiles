{ pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  system.stateVersion = "26.05";
  nix.settings = {
    auto-optimise-store = true;
    extra-substituters = [ "https://install.determinate.systems" ];
    extra-trusted-public-keys = [ "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=" ];
  };
  nixpkgs.config.permittedInsecurePackages = [ "intel-media-sdk-23.2.2" ];
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 1;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "i915.enable_guc=2" ];
  };
  time.timeZone = "America/New_York";
  security.sudo.wheelNeedsPassword = false;
  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-media-sdk
        intel-vaapi-driver
      ];
    };
  };
  services.xserver.videoDrivers = [ "modesetting" ];
  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
    systemPackages = with pkgs; [
      gcc
      gnumake
      cargo
      git
      delta
      wireguard-tools
      wget
      curl
      dig
      dnslookup
      rsync
      btop
      lazydocker
      eza
      fd
      ripgrep
      jq
      python314
      uv
      kitty.terminfo
      ffmpeg-full
      intel-gpu-tools
      zsh-patina
      fastfetch
      tree-sitter
      luajitPackages.jsregexp
      shellcheck
      shfmt
      bash-language-server
      pyright
      ruff
      perl5Packages.PLS
      lua-language-server
      nixd
      nixfmt
      vscode-json-languageserver
      yaml-language-server
      yamlfmt
    ];
  };
  users = {
    users.root = {
      shell = pkgs.zsh;
    };
    users.loganp = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "media"
      ];
      shell = pkgs.zsh;
    };
    groups.media = { };
  };
  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep 4";
      clean.dates = "daily";
      flake = "/home/loganp/.dotfiles/nix/lab/";
    };
    zsh = {
      enable = true;
      enableBashCompletion = true;
      enableCompletion = true;
      enableGlobalCompInit = false;
      promptInit = ''
        PROMPT="%B%F{1}[%1~]%f%b%F{8}%#%f "
      '';
    };
    neovim.enable = true;
    rust-motd = {
      enable = true;
      enableMotdInSSHD = true;
      settings.banner = {
        color = "white";
        command = "${pkgs.fastfetch}/bin/fastfetch --pipe false --structure-disabled title:shell:terminal:packages:display:locale --logo-color-1 yellow --logo-color-2 green --logo-color-3 blue --logo-color-4 magenta --logo-color-5 red --logo-color-6 cyan";
      };
    };
  };
  networking = {
    hostName = "nix-lab";
    networkmanager.enable = true;
    wireguard.enable = true;
    firewall = {
      enable = true;
      checkReversePath = false;
      allowPing = true;
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 443 ];
    };
  };
  systemd.network = {
    enable = true;
    wait-online.enable = false;
    config = {
      routeTables = {
        vpn = 1000;
        killswitch = 2000;
      };
    };
    networks."42-wg0" = {
      matchConfig.Name = "wg0";
      address = [
        "2a07:b944::2:2/128"
        "10.2.0.2/32"
      ];
      dns = [
        "10.2.0.1"
        "2a07:b944::2:1"
      ];
    };
    netdevs."42-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };
      wireguardConfig = {
        PrivateKeyFile = /etc/wireguard/proton.key;
        RouteTable = 1000;
        FirewallMark = 42;
      };
      wireguardPeers = [
        {
          PublicKey = "qu/0mYdJ/EpPfshOEB1oUTvOa1ro/HNaICI3vbq0k2k=";
          AllowedIPs = [
            "::/0"
            "0.0.0.0/0"
          ];
          Endpoint = "79.127.184.31:51820";
          PersistentKeepalive = 25;
        }
      ];
    };
    networks."10-killswitch" = {
      matchConfig.Name = "killswitch";
      routes = [
        {
          Destination = "0.0.0.0/0";
          Type = "unreachable";
          Table = 2000;
        }
        {
          Destination = "::/0";
          Type = "unreachable";
          Table = 2000;
        }
      ];
      routingPolicyRules = [
        {
          Table = 1000;
          User = "qbittorrent";
          Priority = 30001;
          Family = "both";
        }
        {
          Table = 2000;
          User = "qbittorrent";
          Priority = 30002;
          Family = "both";
        }
      ];
    };
    netdevs."10-killswitch" = {
      netdevConfig = {
        Kind = "dummy";
        Name = "killswitch";
      };
    };
  };
  services = {
    openssh = {
      enable = true;
      ports = [ 2222 ];
      settings = {
        PasswordAuthentication = false;
        PrintLastLog = false;
      };
    };
    fail2ban.enable = true;
    power-profiles-daemon.enable = true;
    caddy = {
      enable = true;
      virtualHosts."jellyfin.loganphinney.com".extraConfig = ''
        reverse_proxy localhost:8096
      '';
      virtualHosts."seerr.loganphinney.com".extraConfig = ''
        reverse_proxy localhost:5055
      '';
      virtualHosts."immich.loganphinney.com".extraConfig = ''
        reverse_proxy localhost:2283
      '';
      virtualHosts."grafana.loganphinney.com".extraConfig = ''
        reverse_proxy localhost:3000
      '';
    };
    jellyfin = {
      enable = true;
      group = "media";
      openFirewall = true;
    };
    seerr = {
      enable = true;
      openFirewall = true;
    };
    prowlarr = {
      enable = true;
      openFirewall = true;
    };
    sonarr = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
    radarr = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
    flaresolverr = {
      enable = true;
      openFirewall = true;
    };
    qbittorrent = {
      enable = true;
      openFirewall = true;
      extraArgs = [ "--confirm-legal-notice" ];
      group = "media";
    };
    immich = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
    };
    grafana = {
      enable = true;
      openFirewall = true;
      settings = {
        security.secret_key = "/etc/grafana/grafana.key";
        analytics.reporting_enabled = false;
        server.http_addr = "0.0.0.0";
        server.http_port = 3000;
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
            jsonData.timeInterval = "30s";
          }
        ];
      };
    };
    prometheus = {
      enable = true;
      retentionTime = "45d";
      exporters = {
        node = {
          enable = true;
          port = 9100;
          enabledCollectors = [
            "systemd"
            "processes"
          ];
        };
        process = {
          enable = true;
          port = 9256;
          settings.process_names = [
            {
              name = "{{.Comm}}";
              cmdline = [ ".*" ];
            }
          ];
        };
      };
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [ { targets = [ "127.0.0.1:9100" ]; } ];
        }
        {
          job_name = "process-exporter";
          static_configs = [ { targets = [ "127.0.0.1:9256" ]; } ];
        }
      ];
    };
    loki = {
      enable = true;
      configuration = {
        auth_enabled = false;
        server.http_listen_port = 3100;
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
        storage_config.filesystem.directory = "/tmp/loki/chunks";
      };
    };
    fluent-bit = {
      enable = true;
      settings = {
        service = {
          flush = 5;
          log_level = "info";
          storage_path = "/var/log/flb-storage/";
          storage_type = "filesystem";
          storage_inherit = true;
          storage_sync = "normal";
        };
        pipeline =
          let
            services = {
              caddy = "caddy";
              jellyfin = "jellyfin";
              seerr = "seerr";
              prowlarr = "prowlarr";
              sonarr = "sonarr";
              radarr = "radarr";
              qbittorrent = "qbittorrent";
              immich = "immich-server";
              grafana = "grafana";
            };
          in
          {
            inputs = lib.mapAttrsToList (name: unit: {
              name = "systemd";
              tag = "${name}";
              systemd_filter = "_SYSTEMD_UNIT=${unit}.service";
            }) services;
            filters = [
              {
                name = "record_modifier";
                match = "*";
                remove_key = [
                  "SYSLOG_FACILITY"
                  "PRIORITY"
                  "_BOOT_ID"
                  "_MACHINE_ID"
                  "_HOSTNAME"
                  "_RUNTIME_SCOPE"
                  "_TRANSPORT"
                  "_CAP_EFFECTIVE"
                  "_SYSTEMD_SLICE"
                  "_STREAM_ID"
                  "SYSLOG_IDENTIFIER"
                  "_EXE"
                  "_SYSTEMD_CGROUP"
                  "_SYSTEMD_INVOCATION_ID"
                  "_CMDLINE"
                ];
              }
            ];
            outputs = [
              {
                name = "loki";
                match = "*";
                host = "127.0.0.1";
                port = 3100;
                labels = "unit=$_SYSTEMD_UNIT";
                line_format = "json";
              }
            ];
          };
      };
    };
  };
}
