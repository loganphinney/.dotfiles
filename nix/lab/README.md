# Networking

| Port | TCP/UDP | Service | Access |
|------:|:--------:|---------|--------|
| 80 | TCP | Caddy | WAN |
| 443 | TCP/UDP | Caddy | WAN |
| 2222 | TCP | SSH | Tailnet |

| Port | TCP/UDP | Service | Access |
|------:|:--------:|---------|--------|
| 2283 | TCP | Immich | WAN |
| 8096 | TCP | Jellyfin | WAN |
| 5055 | TCP | Seerr | WAN |
| 7878 | TCP | Radarr | LAN |
| 8989 | TCP | Sonarr | LAN |
| 9696 | TCP | Prowlarr | LAN |
| 8191 |TCP| Flaresolverr | Internal |
| 6881 | TCP/UDP | qBittorrent | LAN |
| 8080 | TCP | qBittorrent | LAN |


| Port | TCP/UDP | Service | Access |
|------:|:--------:|---------|--------|
| 3000 | TCP | Grafana | WAN |
| 3100 | TCP | Loki | Internal |
| 9090 | TCP | Prometheus | Internal |
| 9100 | TCP | Node Exporter | Internal |
| 9256 | TCP | Process Exporter | Internal |
