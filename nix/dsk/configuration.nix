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
      "https://niri.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
  networking = {
    hostName = "nixos-desktop";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8096 ];
      allowedUDPPorts = [ 8096 ];
    };
  };
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
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ rocmPackages.rocm-smi ];
    };
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
    fail2ban.enable = true;
    xserver.enable = true;
    xserver.xkb.layout = "us";
    xserver.xkb.variant = "";
    xserver.excludePackages = [ pkgs.xterm ];
    openssh = {
      enable = true;
      ports = [ 2222 ];
    };
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "loganp";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    displayManager.defaultSession = "niri";
    power-profiles-daemon.enable = true;
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
    firefox.enable = true;
    niri.enable = true;
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
      neovim-unwrapped
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
      ansible-language-server
      ansible-lint
      terraform-ls
      typescript-language-server
      #GNOME
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
        #apps
        yubioath-flutter
        libreoffice-fresh
        vlc
        proton-vpn
        qbittorrent
        transmission_4
        darktable
        prismlauncher
        vscodium
        the-powder-toy
        #fun
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
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
