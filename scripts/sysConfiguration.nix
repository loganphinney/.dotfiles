{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  system.stateVersion = "24.11"; # Did you read the comment?
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos-loganp";
  networking.networkmanager.enable = true;
  security.rtkit.enable = true;

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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ rocmPackages.rocm-smi amf ];
  };

  #environment.systemPackages = with pkgs; [ ];
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableBashCompletion = true;
  };

  services.openssh.enable = true;
  services.fail2ban.enable = true;

  users.users.loganp = {
    isNormalUser = true;
    description = "Logan";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    #packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };
  security.sudo.wheelNeedsPassword = false;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "loganp";
  };
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
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
    allowedTCPPorts = [ 80 2283 8096 32400 1984 ];
    allowedUDPPorts = [ 80 2283 8096 32400 1984 ];
  };
}
