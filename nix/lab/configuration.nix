{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  system.stateVersion = "26.05";
  nix.settings = {
    auto-optimise-store = true;
    extra-substituters = [ "https://install.determinate.systems" ];
    extra-trusted-public-keys = [ "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=" ];
  };
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 1;
    kernelPackages = pkgs.linuxPackages_latest;
  };
  networking = {
    hostName = "determinate-lab";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 443 ];
    };
  };
  time.timeZone = "America/New_York";
  security.sudo.wheelNeedsPassword = false;
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    cargo
    git
    wget
    curl
    rsync
    btop
    lazydocker
    eza
    fd
    ripgrep
    jq
    python313
    uv
    kitty.terminfo
    neovim-unwrapped
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
  ];
  users = {
    users.loganp = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "media"
      ];
      shell = pkgs.zsh;
      # packages = with pkgs; [ ];
    };
    groups.media = {
      members = [
        "jellyfin"
      ];
    };
  };
  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep 4";
      clean.dates = "daily";
      flake = "/etc/nixos";
    };
    zsh.enable = true;
  };
  services = {
    openssh = {
      enable = true;
      ports = [ 2222 ];
      settings = {
        PasswordAuthentication = false;
      };
    };
    caddy = {
      enable = true;
      virtualHosts."jellyfin.loganphinney.com".extraConfig = ''
        reverse_proxy localhost:8096
      '';
      virtualHosts."immich.loganphinney.com".extraConfig = ''
        reverse_proxy localhost:2283
      '';
      virtualHosts."grafana.loganphinney.com".extraConfig = ''
        reverse_proxy localhost:3000
      '';
    };
    fail2ban.enable = true;
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
      openFirewall = true;
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
            jsonData = {
              timeInterval = "30s";
            };
          }
        ];
      };
    };
    prometheus = {
      enable = true;
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
          flush = 5;
          log_level = "info";
          storage_path = "/var/log/flb-storage/";
          storage_type = "filesystem";
          storage_inherit = true;
          storage_sync = "normal";
        };
        pipeline = {
          inputs = [
            {
              name = "systemd";
              tag = "services.caddy";
              systemd_filter = "_SYSTEMD_UNIT=caddy.service";
            }
            {
              name = "systemd";
              tag = "services.jellyfin";
              systemd_filter = "_SYSTEMD_UNIT=jellyfin.service";
            }
            {
              name = "systemd";
              tag = "services.immich";
              systemd_filter = "_SYSTEMD_UNIT=immich-server.service";
            }
            {
              name = "systemd";
              tag = "services.grafana";
              systemd_filter = "_SYSTEMD_UNIT=grafana.service";
            }
          ];
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
