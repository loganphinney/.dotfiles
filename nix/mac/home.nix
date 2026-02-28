{ pkgs, ... }:
{
  home = {
    stateVersion = "25.11";
    username = "loganphinney";
    homeDirectory = "/Users/loganphinney";
    packages = with pkgs; [
      firefox
      vlc-bin
      kitty
      iterm2
      qbittorrent
      rectangle
      lavat
      cmatrix
    ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
  programs = {
    kitty = {
      enable = true;
      font.name = "Hack Nerd Font Mono";
      font.size = 12;
      settings = {
        confirm_os_window_close = 0;
        sync_to_monitor = false;
        cursor_shape = "beam";
        cursor_trail = 1;
        cursor_trail_decay = "0.1 0.3";
        enable_audio_bell = false;
        tab_bar_style = "slant";
        tab_bar_align = "right";
        window_padding_width = 2;
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
        active_border_color = "#403d52";
        inactive_border_color = "#403d52";
        macos_titlebar_color = "background";
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
    zsh = {
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
        darwinupdate = "sudo darwin-rebuild switch --verbose --flake /etc/nix-darwin --verbose";
        darwinupgrade = "sudo nix flake update --verbose --flake /etc/nix-darwin --verbose";
        darwined = "nvsu /etc/nix-darwin/flake.nix";
      };
      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
        }
      ];
    };
    tmux = {
      enable = true;
      baseIndex = 1;
      mouse = true;
      focusEvents = true;
      clock24 = true;
      shortcut = "s";
      extraConfig = ''
        set-option -g set-clipboard external
        set-option -g status-position top
        set -g renumber-windows on
        set -g pane-border-lines "single"
        bind-key "|" split-window -h -c "#{pane_current_path}"
        bind-key "\\" split-window -fh -c "#{pane_current_path}"
        bind-key "-" split-window -v -c "#{pane_current_path}"
        bind-key "_" split-window -fv -c "#{pane_current_path}"
        set -g pane-active-border-style "fg=#6e6a86"
      '';
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
            pluginName = "rose-pine-tmux";
            version = "1-unstable-2025-11-22";
            src = pkgs.fetchFromGitHub {
              owner = "rose-pine";
              repo = "tmux";
              rev = "ab5068a95828cdbff20010c8873f9805e3626698";
              hash = "sha256-qZ5wGBpYGN951dW6MSAMFxcdLma6KC6/SeTv4XinwiQ=";
            };
            rtpFilePath = "rose-pine.tmux";
          };
          extraConfig = ''
            set -g @rose_pine_variant 'main'
            set -g @rose_pine_disable_active_window_menu 'on'
            set -g @rose_pine_show_current_program 'on'
            set -g @rose_pine_host 'on'
            set -g @rose_pine_date_time '%m-%d-%Y %H:%M:%S'
            set -g @rose_pine_user 'on'
            set -g @rose_pine_directory 'on'
            set -g @rose_pine_right_separator ' '
            set -g @rose_pine_status_right_prepend_section '#{cpu_icon}#{cpu_percentage} #{battery_percentage} '
          '';
        }
        cpu
        battery
      ];
    };
    fzf = {
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
    bat = {
      enable = true;
      config = {
        color = "always";
        theme = "rose-pine";
        style = "-numbers,-header,-grid,+changes";
      };
      themes.rose-pine = {
        src = pkgs.fetchFromGitHub {
          owner = "rose-pine";
          repo = "tm-theme";
          rev = "417d201beb5f0964faded5448147c252ff12c4ae";
          sha256 = "sha256-aNDOqY81FLFQ6bvsTiYgPyS5lJrqZnFMpvpTCSNyY0Y=";
        };
        file = "dist/rose-pine.tmTheme";
      };
    };
    vim = {
      enable = true;
      plugins = [
        (pkgs.vimUtils.buildVimPlugin {
          pname = "rose-pine-vim";
          version = "2025-11-09";
          src = pkgs.fetchFromGitHub {
            owner = "rose-pine";
            repo = "vim";
            rev = "ea0ad226b851b3aa132e2e234cc74ceecf9f4c7c";
            sha256 = "sha256-QAZKLTliWwZR6Zm0qyGpJiY2lFvBypBqBxpA0BlVcDc=";
          };
        })
      ];
      extraConfig = ''
        syntax on
        set relativenumber
        let g:disable_bg = 1
        colorscheme rosepine
      '';
    };
  };
}
