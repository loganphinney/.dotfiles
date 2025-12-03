{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    <nixos-wsl/modules>
    <home-manager/nixos>
  ];
  wsl.enable = true;
  wsl.defaultUser = "loganp";
  system.stateVersion = "25.05"; # Did you read the comment?
  networking.hostName = "nixos-wsl";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    rsync
    nmap
    dnslookup
    gnumake
    clang
    tmux
    btop
    lazygit
    bat
    eza
    fzf
    ripgrep
    fd
    xclip
  ];
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;
  };
  security.sudo.wheelNeedsPassword = false;
  users.users.loganp = {
    isNormalUser = true;
    description = "logan";
    shell = pkgs.zsh;
  };
  home-manager.users.loganp =
    { pkgs, ... }:
    {
      home.stateVersion = "25.05";
      #home.packages = with pkgs; [ ];
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
          nixsysup = "sudo nixos-rebuild switch --upgrade";
          nixsysed = "nvsu /etc/nixos/configuration.nix";
          nixlistgens = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        };
        plugins = [
          {
            name = "fast-syntax-highlighting";
            src = pkgs.zsh-fast-syntax-highlighting;
            file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
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
          set -g pane-active-border-style "fg=#3e8fb0"
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
              set-option -ga terminal-overrides ",xterm-256color:Tc"
              set -g @rose_pine_variant 'main'
              set -g @rose_pine_disable_active_window_menu 'on'
              set -g @rose_pine_show_current_program 'on'
              set -g @rose_pine_host 'on'
              set -g @rose_pine_date_time '%b-%d-%Y %H:%M:%S'
              set -g @rose_pine_user 'on' 
              set -g @rose_pine_directory 'on'
              set -g @rose_pine_right_separator ' '
            '';
          }
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
