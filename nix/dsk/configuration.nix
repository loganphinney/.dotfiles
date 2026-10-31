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
    ];
    extra-trusted-public-keys = [
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
    ];
    experimental-features = [ "baked-derivations" ];
  };
  networking = {
    hostName = "nix-dsk";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8096 ];
    };
  };
  time.timeZone = "America/New_York";
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    kernelPackages = pkgs.linuxPackages_latest;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      settings = {
        timeout = "menu-force";
        console-mode = "max";
      };
    };
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ rocmPackages.rocm-smi ];
  };
  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };
  services = {
    printing.enable = false;
    pulseaudio.enable = false;
    pcscd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
      excludePackages = [ pkgs.xterm ];
    };
    desktopManager.gnome.enable = true;
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "loganp";
      defaultSession = "niri";
      gdm.enable = false;
      noctalia-greeter = {
        enable = true;
        passwordlessSyncUsers = [ "loganp" ];
        settings = {
          user.default = "loganp";
          keyboard.layout = "us";
          appearance.hide_logo = true;
          clock = {
            enabled = true;
            position = "above-panel";
            time_format = "{:%H:%M}";
            date_format = "%A, %x";
          };
          output = {
            name = "DP-2";
            width = 2560;
            height = 1440;
            refresh_rate = 239.970;
          };
        };
        cursorTheme = {
          package = pkgs.rose-pine-cursor;
          name = "BreezeX-RosePine-Linux";
        };
      };
    };
    openssh = {
      enable = true;
      ports = [ 2222 ];
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
    power-profiles-daemon.enable = true;
    /*
      llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-rocm;
        settings = {
          port = 9999;
          hf-repo = "unsloth/gpt-oss-20b-GGUF:UD-Q4_K_XL";
          jinja = true;
          flash-attn = "on";
          temp = 1.0;
          "top-p" = 1.0;
          "top-k" = 0;
          "n-gpu-layers" = 99;
        };
      };
    */
  };
  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep 3 --no-gcroots";
      clean.dates = "daily";
      flake = "/home/loganp/.dotfiles/nix/dsk/";
    };
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
  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      ansible
      ansible-language-server
      ansible-lint
      bash-language-server
      bat
      btop-cuda
      cargo
      claude-code
      curl
      delta
      dig
      dnslookup
      easyeffects
      fastfetch
      fd
      ffmpeg
      fzf
      gcc
      git
      gnome-tweaks
      gnomeExtensions.color-picker
      gnomeExtensions.executor
      gnomeExtensions.hide-top-bar
      gnomeExtensions.open-bar
      gnomeExtensions.user-themes
      gnomeExtensions.vitals
      gnomeExtensions.wallpaper-slideshow
      gnumake
      ipmitool
      jq
      jre
      kiro-cli
      kubectl
      libreoffice-stable
      linux-wallpaperengine
      lua-language-server
      luajitPackages.jsregexp
      minikube
      nixd
      nixfmt
      nmap
      nodejs_24
      nom
      nvimpager
      openssh
      perl5Packages.PLS
      pyright
      python314
      ripgrep
      rose-pine-cursor
      rsync
      ruff
      sbctl
      shellcheck
      shfmt
      stow
      sysstat
      terraform-ls
      tmux
      tree-sitter
      uv
      vlc
      vscode-json-languageserver
      wget
      wireguard-tools
      wl-clipboard
      xdg-terminal-exec
      xwayland-satellite
      yaml-language-server
      yamlfmt
      zsh-patina
    ];
    gnome.excludePackages = with pkgs; [
      decibels
      epiphany
      geary
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-connections
      gnome-contacts
      gnome-font-viewer
      gnome-maps
      gnome-music
      gnome-system-monitor
      gnome-text-editor
      gnome-tour
      gnome-weather
      seahorse
      showtime
      simple-scan
      snapshot
      yelp
    ];
  };
  users = {
    users.root = {
      shell = pkgs.zsh;
    };
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
        cava
        cbonsai
        cmatrix
        darktable
        dolphin-emu
        lavat
        pokeget-rs
        prismlauncher
        proton-vpn
        qbittorrent
        the-powder-toy
        yubioath-flutter
      ];
    };
    groups.media.members = [ "jellyfin" ];
  };
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.noto
    nerd-fonts.ubuntu
  ];
}
