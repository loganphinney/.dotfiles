{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  defaults = {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    config = {
      system.stateVersion = "26.11";
      networking = {
        useNetworkd = true;
        useDHCP = false;
      };
      microvm = {
        hypervisor = "qemu";
        mem = 256;
        vcpu = 1;
        shares = [
          {
            tag = "ro-store";
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
            proto = "virtiofs";
          }
        ];
      };
      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "yes";
      };
      users.users.root = {
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4O1vANM4piUIfJe77+ENlKQis+iuKERGG4L3duVBYn loganp@nix-lab"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIH4GJjV2o/IE2URjc6OEJkkiTCa7QvJxVY1fpcO0XM7 loganp@nixos-loganp"
        ];
      };
      environment.systemPackages = with pkgs; [
        btop
        dig
        eza
        fd
        jq
        kitty.terminfo
        ripgrep
        rsync
      ];
      programs = {
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
    };
  };
  mkVM =
    {
      name,
      ip,
      tapId,
      mac,
      conf ? { },
    }:
    lib.mkMerge [
      defaults
      {
        config = lib.mkMerge [
          {
            networking.hostName = name;
            microvm.interfaces = [
              {
                type = "tap";
                id = tapId;
                mac = mac;
              }
            ];
            microvm.volumes = [
              {
                image = "${name}.img";
                mountPoint = "/var";
                size = 2048;
              }
            ];
            systemd.network.networks."20-lan" = {
              matchConfig.Type = "ether";
              addresses = [ { Address = "${ip}/24"; } ];
              routes = [ { Gateway = "10.100.0.1"; } ];
              dns = [ "10.100.0.1" ];
            };
          }
          conf
        ];
      }
    ];
in
{
  microvm.autostart = [
    "vm0"
    "vm1"
  ];
  systemd.network.netdevs."10-microvm-br0" = {
    netdevConfig = {
      Kind = "bridge";
      Name = "microvm-br0";
    };
  };
  systemd.network.networks."10-microvm-br0" = {
    matchConfig.Name = "microvm-br0";
    addresses = [ { Address = "10.100.0.1/24"; } ];
  };
  systemd.network.networks."11-microvm-tap" = {
    matchConfig.Name = "vm-*";
    networkConfig.Bridge = "microvm-br0";
  };
  networking.firewall.extraCommands = ''
    iptables -t nat -A PREROUTING -i enp0s31f6 -p tcp --dport 9991 -j DNAT --to-destination 10.100.0.10:8080
    iptables -t nat -A PREROUTING -i enp0s31f6 -p tcp --dport 9992 -j DNAT --to-destination 10.100.0.11:8080
    iptables -t nat -A PREROUTING -i enp0s31f6 -p tcp --dport 2201 -j DNAT --to-destination 10.100.0.10:22
    iptables -t nat -A PREROUTING -i enp0s31f6 -p tcp --dport 2202 -j DNAT --to-destination 10.100.0.11:22
    iptables -A FORWARD -i enp0s31f6 -o microvm-br0 -p tcp --dport 8080 -d 10.100.0.0/24 -j ACCEPT
    iptables -A FORWARD -i enp0s31f6 -o microvm-br0 -p tcp --dport 22 -d 10.100.0.0/24 -j ACCEPT
    iptables -A FORWARD -i microvm-br0 -o enp0s31f6 -s 10.100.0.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
  '';
  networking.nat = {
    enable = true;
    internalInterfaces = [ "microvm-br0" ];
    externalInterface = "enp0s31f6";
  };
  microvm.vms."vm0" = mkVM {
    name = "vm0";
    ip = "10.100.0.10";
    tapId = "vm-vm0";
    mac = "02:00:00:01:00:01";
    conf = {
      networking.firewall.allowedTCPPorts = [ 8080 ];
      services.nginx = {
        enable = true;
        virtualHosts."_" = {
          listen = [
            {
              addr = "0.0.0.0";
              port = 8080;
            }
          ];
          locations."/".return = "200 'Hello from vm0'";
        };
      };
    };
  };
  microvm.vms."vm1" = mkVM {
    name = "vm1";
    ip = "10.100.0.11";
    tapId = "vm-vm1";
    mac = "02:00:00:01:00:02";
    conf = {
      networking.firewall.allowedTCPPorts = [ 8080 ];
      services.nginx = {
        enable = true;
        virtualHosts."_" = {
          listen = [
            {
              addr = "0.0.0.0";
              port = 8080;
            }
          ];
          locations."/".return = "200 'Hello from vm1'";
        };
      };
    };
  };
}
