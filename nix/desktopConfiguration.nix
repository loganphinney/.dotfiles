{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix <home-manager/nixos> ];
  networking.hostName = "nixos-loganp";
  system.stateVersion = "24.11"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.timeout = 1;

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

  networking.networkmanager.enable = true;
  security.rtkit.enable = true;
  services.openssh.enable = true;
  services.fail2ban.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";
  services.xserver.excludePackages = [ pkgs.xterm ];
  environment.gnome.excludePackages = with pkgs; [
    snapshot
    decibels
    epiphany
    simple-scan
    totem
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

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    rsync
    nmap
    dnslookup
    ipmitool
    stow
    tmux
    docker
    docker-compose
    wireguard-tools
    sysstat
    ffmpeg
    btop-cuda
    lazydocker
    lazygit
    wl-clipboard
    bat
    eza
    ripgrep
    fd
    fzf
    fastfetch
    nodePackages.nodejs
    jre
  ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableBashCompletion = true;
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  security.sudo.wheelNeedsPassword = false;
  users.users.loganp = {
    isNormalUser = true;
    description = "Logan";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  home-manager.users.loganp = { pkgs, ... }: {
    #home.packages = with pkgs; [ ];
    programs.kitty = {
      enable = true;
      font.name = "Hack Nerd Font Mono";
      font.size = 11;
      settings = {
        linux_display_server = "x11";
        sync_to_monitor = false;
        cursor_shape = "beam";
        cursor_trail = 1;
        cursor_trail_decay = "0.1 0.3";
        enable_audio_bell = false;
        tab_bar_style = "slant";
        tab_bar_align = "right";
        remember_window_size = false;
        initial_window_width = "120c";
        initial_window_height = "40c";
        foreground = "#e0def4";
        background = "#191724";
        selection_foreground = "#e0def4";
        selection_background = "#403d52";
        cursor = "#e0def4";
        cursor_text_color = "#e0def4";
        url_color = "#c4a7e7";
        active_tab_foreground = "#e0def4";
        active_tab_background = "#26233a";
        inactive_tab_foreground = "#6e6a86";
        inactive_tab_background = "#191724";
        active_border_color = " #3e8fb0";
        inactive_border_color = "#403d52";
        color0 = "#26233a";
        color8 = "#6e6a86";
        color1 = "#eb6f92";
        color9 = "#eb6f92";
        color2 = "#3e8fb0";
        color10 = "#3e8fb0";
        color3 = "#f6c177";
        color11 = "#f6c177";
        color4 = "#9ccfd8";
        color12 = "#9ccfd8";
        color5 = "#c4a7e7";
        color13 = "#c4a7e7";
        color6 = "#ebbcba";
        color14 = "#ebbcba";
        color7 = "#e0def4";
        color15 = "#e0def4";
      };
    };
    home.stateVersion = "25.11";
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "loganp";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    corefonts
    vista-fonts
    wineWow64Packages.fonts
    google-fonts
    inter
  ];

  virtualisation.docker.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 8096 32400 ];
    allowedUDPPorts = [ 80 8096 32400 ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ rocmPackages.rocm-smi amf ];
  };
}
