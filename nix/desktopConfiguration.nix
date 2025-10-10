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
    home.packages = with pkgs; [ nvtopPackages.amd ];
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
