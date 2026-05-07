{ pkgs, ... }:
{
  home.username = "loganp";
  home.homeDirectory = "/home/loganp";
  home.stateVersion = "26.05";
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  programs = {
    zsh = {
      enable = true;
      initContent = "PROMPT='%F{8}[%1~]%#%f '";
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
        lzd = "lazydocker";
        dcdu = "docker compose down; docker compose up -d";
        nixed = "nvim ~/.dotfiles/nix/lab";
        nixupdate = "sudo nixos-rebuild switch --flake ~/.dotfiles/nix/lab";
        nixupgrade = "sudo nix flake update --flake ~/.dotfiles/nix/lab";
        nhupdate = "nh os switch ~/.dotfiles/nix/lab --no-nom";
        nhupgrade = "nh os switch -u ~/.dotfiles/nix/lab --no-nom";
        nhclean = "nh clean all -k 4";
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
              src = pkgs.runCommand "rose-pine-tmux-patched" { } ''
                cp -r ${
                  pkgs.fetchFromGitHub {
                    owner = "rose-pine";
                    repo = "tmux";
                    rev = "b6138c51573425ccdc33c91464597323baec3b7e";
                    hash = "sha256-HDmCCRhTCPfu7gL9VPHVGCiG5IcnkpQ4EaXN4IsQ0YE=";
                  }
                } $out
                chmod -R u+w $out
                substituteInPlace $out/rose-pine.tmux \
                  --replace "#31748f" "#3e8fb0"
              '';
              rtpFilePath = "rose-pine.tmux";
            }
          );
          extraConfig = ''
            set -g default-terminal "xterm-256color"
            set -as terminal-overrides ',xterm*:Tc'
            set -g @rose_pine_variant 'main'
            set -g @rose_pine_disable_active_window_menu 'on'
            set -g @rose_pine_show_current_program 'on'
            set -g @rose_pine_host 'on'
            set -g @rose_pine_date_time '%b-%d-%Y %H:%M:%S'
            set -g @rose_pine_user 'on' 
            set -g @rose_pine_directory 'on'
            set -g @rose_pine_field_separator ' '
            set -g @rose_pine_right_separator ' '
            set -g @rose_pine_status_right_prepend_section '#[fg=green]#{cpu_icon}#{cpu_percentage}#[default]'
          '';
        }
        cpu
      ];
    };
    vim = {
      enable = true;
      plugins = [
        (pkgs.vimUtils.buildVimPlugin {
          pname = "rose-pine-vim";
          version = "2025-11-09";
          src = pkgs.runCommand "rose-pine-vim-patched" { } ''
            cp -r ${
              pkgs.fetchFromGitHub {
                owner = "rose-pine";
                repo = "vim";
                rev = "ea0ad226b851b3aa132e2e234cc74ceecf9f4c7c";
                sha256 = "sha256-QAZKLTliWwZR6Zm0qyGpJiY2lFvBypBqBxpA0BlVcDc=";
              }
            } $out
            chmod -R u+w $out
            substituteInPlace $out/colors/rosepine.vim \
              --replace "#31748f" "#3e8fb0"
          '';
        })
      ];
      extraConfig = ''
        syntax on
        set relativenumber
        let g:disable_bg = 1
        colorscheme rosepine
        highlight StatusLine guibg=NONE ctermbg=NONE
        highlight StatusLineNC guibg=NONE ctermbg=NONE
      '';
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
        src =
          let
            src = pkgs.fetchFromGitHub {
              owner = "rose-pine";
              repo = "tm-theme";
              rev = "417d201beb5f0964faded5448147c252ff12c4ae";
              sha256 = "sha256-aNDOqY81FLFQ6bvsTiYgPyS5lJrqZnFMpvpTCSNyY0Y=";
            };
          in
          pkgs.runCommand "rose-pine-patched" { } ''
            cp -r ${src} $out
            chmod -R u+w $out
            substituteInPlace $out/dist/rose-pine.tmTheme --replace "#31748f" "#3e8fb0"
            file = "dist/rose-pine.tmTheme";
          '';
        file = "dist/rose-pine.tmTheme";
      };
    };
  };
}
