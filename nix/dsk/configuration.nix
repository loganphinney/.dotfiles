{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "nixos-desktop";
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
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.timeout = 2;
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
  services.printing.enable = false;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;
  services.pcscd.enable = true;
  services.fail2ban.enable = true;
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";
  services.xserver.excludePackages = [ pkgs.xterm ];
  virtualisation.docker.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8096 ];
    allowedUDPPorts = [ 8096 ];
  };
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ rocmPackages.rocm-smi ];
  };
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "loganp";
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "niri";
  services.power-profiles-daemon.enable = true;
  environment.gnome.excludePackages = with pkgs; [
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
  programs.dconf.profiles.user.databases = [
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
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 4";
    clean.dates = "daily";
    flake = "/etc/nixos";
  };
  programs.niri.enable = true;
  programs.firefox.enable = true;
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;
    enableGlobalCompInit = false;
    promptInit = "";
  };
  environment.pathsToLink = [ "/share/zsh" ];
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
  services = {
    tailscale.enable = true;
    jellyfin = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
  };
  users.groups.media = {
    members = [
      "jellyfin"
    ];
  };
  environment.systemPackages = with pkgs; [
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
    docker
    docker-compose
    wireguard-tools
    dnslookup
    sysstat
    ffmpeg
    btop-cuda
    lazydocker
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
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    corefonts
    vista-fonts
    wineWow64Packages.fonts
    google-fonts
    inter
  ];
  security.sudo.wheelNeedsPassword = false;
  users.users.loganp = {
    isNormalUser = true;
    description = "Logan";
    extraGroups = [
      "wheel"
      "networkmanager"
      "media"
      "docker"
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
}
