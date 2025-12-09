{ pkgs, lib, ... }:
let
  lanzaboote = builtins.getFlake "github:nix-community/lanzaboote";
in
{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
    lanzaboote.nixosModules.lanzaboote
  ];
  networking.hostName = "nixos-loganp";
  system.stateVersion = "24.11";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
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
    allowedTCPPorts = [ 8096 ];
    allowedUDPPorts = [ 8096 ];
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
  programs.firefox.enable = true;
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;
  };
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
  environment.systemPackages = with pkgs; [
    sbctl
    openssh
    git
    wget
    curl
    rsync
    gcc
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
    nodePackages.nodejs
    jre
    gnumake
    fastfetch
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
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      vlc
      libreoffice-fresh
      qbittorrent
      prismlauncher
      lavat
      pokeget-rs
    ];
  };

  home-manager.users.loganp =
    { pkgs, ... }:
    {
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      home.stateVersion = "25.11";
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
          window_padding_width = 2;
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
          active_border_color = "#403d52";
          inactive_border_color = "#2a283e";
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
      programs.zsh = {
        enable = true;
        initContent = "PROMPT='%B%F{2}[%1~]%f%b%F{8}%#%f '";
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
          lg = "lazygit";
          dcdu = "docker compose down; docker compose up -d";
          lava = "lavat -c black -k magenta -s 3";
          cmatrix = "cmatrix -C magenta";
          nixsysup = "sudo nixos-rebuild switch --upgrade";
          nixsysed = "nvsu /etc/nixos/configuration.nix";
          nixlistgens = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        };
        plugins = [
          {
            name = "fast-syntax-highlighting";
            src = pkgs.zsh-fast-syntax-highlighting;
            file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
          }
        ];
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
          set -g pane-border-style "fg=#2a283e"
          set -g pane-active-border-style "fg=#403d52"
          bind-key "|" split-window -h -c "#{pane_current_path}"
          bind-key "\\" split-window -fh -c "#{pane_current_path}"
          bind-key "-" split-window -v -c "#{pane_current_path}"
          bind-key "_" split-window -fv -c "#{pane_current_path}"
        '';
        plugins = with pkgs.tmuxPlugins; [
          {
            plugin = (
              mkTmuxPlugin {
                pluginName = "rose-pine-tmux";
                version = "1-unstable-2025-11-09";
                src = pkgs.fetchFromGitHub {
                  owner = "rose-pine";
                  repo = "tmux";
                  rev = "ab5068a95828cdbff20010c8873f9805e3626698";
                  hash = "sha256-qZ5wGBpYGN951dW6MSAMFxcdLma6KC6/SeTv4XinwiQ=";
                };
                rtpFilePath = "rose-pine.tmux";
              }
            );
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
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultOptions = [
          "--style full"
          "--preview 'bat --color=always --theme=rose-pine --style=-numbers,-header,-grid,+changes {}'"
        ];
        historyWidgetOptions = [ "--no-preview" ];
        colors = {
          fg = "#908caa";
          bg = "#191724";
          hl = "#ebbcba";
          "fg+" = "#e0def4";
          "bg+" = "#26233a";
          "hl+" = "#ebbcba";
          border = "#403d52";
          header = "#31748f";
          gutter = "#191724";
          spinner = "#f6c177";
          info = "#9ccfd8";
          pointer = "#c4a7e7";
          marker = "#eb6f92";
          prompt = "#908caa";
        };
      };
      programs.bat = {
        enable = true;
        config = {
          color = "always";
          theme = "rose-pine";
          style = "-numbers,-header,-grid,+changes";
        };
        themes = {
          rose-pine = {
            src = pkgs.fetchFromGitHub {
              owner = "rose-pine";
              repo = "tm-theme";
              rev = "417d201beb5f0964faded5448147c252ff12c4ae";
              sha256 = "sha256-aNDOqY81FLFQ6bvsTiYgPyS5lJrqZnFMpvpTCSNyY0Y=";
            };
            file = "dist/rose-pine.tmTheme";
          };
        };
      };
    };
}
