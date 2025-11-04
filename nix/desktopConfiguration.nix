{ pkgs, lib, ... }:
let
  lanzaboote = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/lanzaboote/archive/master.tar.gz";
    sha256 = "016pgbh27zjwbzq1li1d4r40b37vwmnz8khh04vspd5gw91szzi1";
  });
in {
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
    lanzaboote.nixosModules.lanzaboote
  ];
  networking.hostName = "nixos-loganp";
  system.stateVersion = "24.11"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.optimise.automatic = true;
  nixpkgs.config.allowUnfree = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
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
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";
  services.xserver.excludePackages = [ pkgs.xterm ];
  virtualisation.docker.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 8096 32400 ];
    allowedUDPPorts = [ 80 8096 32400 ];
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  security.sudo.wheelNeedsPassword = false;
  users.users.loganp = {
    isNormalUser = true;
    description = "Logan";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "loganp";
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
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
    openssh
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
    sbctl
    gnumake
    vlc
    libreoffice-fresh
  ];
  programs.firefox.enable = true;
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;
  };
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    corefonts
    vista-fonts
    wineWow64Packages.fonts
    google-fonts
    inter
  ];

  home-manager.users.loganp = { pkgs, ... }: {
    home.stateVersion = "25.11";
    #home.packages = with pkgs; [ ];
    programs.zsh = {
      enable = true;
      initContent = "PROMPT='%B%F{green}[%1~]%f%b%F{grey}%#%f '";
      shellAliases = {
        ".." = "cd ../";
        "~" = "cd ~/";
        cl = "clear";
        ls = "eza";
        la = "eza -a";
        ll = "eza -l";
        l1 = "eza -1";
        tree = "eza -T";
        nv = "nvim";
        nvsu = "sudo -E nvim";
        bat =
          "bat --color=always --theme=ansi --style=-numbers,-header,+changes";
        dcdu = "docker compose down; docker compose up -d";
        fzf =
          "fzf --style full --preview 'bat --color=always --theme=ansi --style=-numbers,-header,+changes {}'";
        lava = "lavat -c black -k magenta -s 3";
        cmatrix = "cmatrix -C magenta";
        nixsysup = "sudo nixos-rebuild switch --upgrade";
        nixsysed = "nvsu /etc/nixos/configuration.nix";
        nixlsgens =
          "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        nixusrup = "nix profile upgrade nix/loganp --verbose";
      };
      plugins = [{
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file =
          "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }];
    };
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      mouse = true;
      focusEvents = true;
      clock24 = true;
      shortcut = "s";
      extraConfig = ''
        set-option -g status-position top
        set -g renumber-windows on
        set -g pane-border-lines "single"
        set -g pane-active-border-style "fg=#3e8fb0"
        bind-key "|" split-window -h -c "#{pane_current_path}"
        bind-key "\\" split-window -fh -c "#{pane_current_path}"
        bind-key "-" split-window -v -c "#{pane_current_path}"
        bind-key "_" split-window -fv -c "#{pane_current_path}"
      '';
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = (mkTmuxPlugin {
            pluginName = "rose-pine-tmux";
            version = "unstable-2025-08-26";
            src = pkgs.fetchFromGitHub {
              owner = "rose-pine";
              repo = "tmux";
              rev = "009800e5c892c0e75de648881f8ba09a90c145b0";
              hash = "sha256-OJMBCZwqrEu2DTlojqQ3pIp2sfjIzT9ORw0ajVgZ8vo=";
            };
            rtpFilePath = "rose-pine.tmux";
          });
          extraConfig = ''
            set -g @rose_pine_variant 'main'
            set -g @rose_pine_disable_active_window_menu 'on'
            set -g @rose_pine_show_current_program 'on'
            set -g @rose_pine_host 'on'
            set -g @rose_pine_date_time '%b-%d-%Y %H:%M:%S'
            set -g @rose_pine_user 'on' 
            set -g @rose_pine_directory 'on'
            set -g @rose_pine_right_separator ' '
            set -g @rose_pine_status_right_prepend_section '#{cpu_icon}#{cpu_percentage} ' 
          '';
        }
        cpu
      ];
    };
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
  };
}
