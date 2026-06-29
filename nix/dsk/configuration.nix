{ pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [
      "root"
      "loganp"
    ];
    extra-substituters = [
      "https://install.determinate.systems"
      "https://niri-epireyn.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
  networking = {
    hostName = "nix-dsk";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8096 ];
      allowedUDPPorts = [ 8096 ];
    };
  };
  time.timeZone = "America/New_York";
  boot = {
    loader = {
      systemd-boot.enable = lib.mkForce false;
      systemd-boot.consoleMode = "max";
      timeout = 2;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ rocmPackages.rocm-smi ];
  };
  services = {
    printing.enable = false;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    pcscd.enable = true;
    xserver.enable = true;
    xserver.xkb.layout = "us";
    xserver.xkb.variant = "";
    xserver.excludePackages = [ pkgs.xterm ];
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "loganp";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    displayManager.defaultSession = "niri";
    power-profiles-daemon.enable = true;
    openssh = {
      enable = true;
      ports = [ 2222 ];
    };
    tailscale.enable = true;
    jellyfin = {
      enable = true;
      openFirewall = true;
      group = "media";
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
    zsh = {
      enable = true;
      enableBashCompletion = true;
      enableCompletion = true;
      enableGlobalCompInit = false;
      promptInit = "";
    };
    niri.enable = true;
    firefox.enable = true;
    steam.enable = true;
    steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
    dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            accent-color = "purple";
            color-scheme = "prefer-dark";
            cursor-theme = "BreezeX-RosePine-Linux";
          };
          "org/gnome/settings-daemon/plugins/power" = {
            idle-brightness = lib.gvariant.mkInt32 100;
            idle-dim = false;
          };
          "org/gnome/desktop/session" = {
            idle-delay = lib.gvariant.mkUint32 0;
          };
          "org/gnome/desktop/wm/preferences" = {
            num-workspaces = lib.gvariant.mkInt32 1;
          };
        };
      }
    ];
  };
  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };
  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      nom
      xwayland-satellite
      sbctl
      openssh
      git
      delta
      wget
      curl
      rsync
      gcc
      nmap
      dnslookup
      ipmitool
      python314
      uv
      nodejs_24
      jq
      stow
      tmux
      wireguard-tools
      dnslookup
      dig
      sysstat
      ffmpeg
      btop-cuda
      wl-clipboard
      bat
      eza
      ripgrep
      fd
      fzf
      nodejs_24
      jre
      cargo
      gnumake
      fastfetch
      ansible
      kubectl
      minikube
      neovim-unwrapped
      tree-sitter
      luajitPackages.jsregexp
      bash-language-server
      shellcheck
      shfmt
      lua-language-server
      perl5Packages.PLS
      nixd
      nixfmt
      pyright
      ruff
      vscode-json-languageserver
      yaml-language-server
      yamlfmt
      ansible-language-server
      ansible-lint
      terraform-ls
      typescript-language-server
      gnome-tweaks
      xdg-terminal-exec
      gnomeExtensions.open-bar
      gnomeExtensions.hide-top-bar
      gnomeExtensions.user-themes
      gnomeExtensions.vitals
      gnomeExtensions.wallpaper-slideshow
      gnomeExtensions.color-picker
      gnomeExtensions.executor
      rose-pine-cursor
    ];
    gnome.excludePackages = with pkgs; [
      snapshot
      decibels
      epiphany
      simple-scan
      showtime
      yelp
      geary
      seahorse
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-contacts
      gnome-font-viewer
      gnome-maps
      gnome-music
      gnome-system-monitor
      gnome-weather
      gnome-connections
      gnome-tour
      gnome-text-editor
    ];
  };
  users = {
    users.loganp = {
      isNormalUser = true;
      description = "Logan";
      extraGroups = [
        "wheel"
        "networkmanager"
        "media"
      ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        yubioath-flutter
        libreoffice-fresh
        vlc
        proton-vpn
        qbittorrent
        darktable
        prismlauncher
        dolphin-emu
        the-powder-toy
        cava
        cbonsai
        cmatrix
        lavat
        pokeget-rs
      ];
    };
    groups.media = {
      members = [
        "jellyfin"
      ];
    };
  };
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    corefonts
    vista-fonts
    wineWow64Packages.fonts
    google-fonts
    inter
  ];
}
