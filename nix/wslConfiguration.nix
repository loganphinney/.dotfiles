{ config, lib, pkgs, ... }: {
  imports = [ <nixos-wsl/modules> <home-manager/nixos> ];
  system.stateVersion = "25.05"; # Did you read the comment?
  wsl.enable = true;
  wsl.defaultUser = "loganp";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    rsync
    nmap
    dnslookup
    ipmitool
    stow
    docker
    docker-compose
    gnumake
    clang
    sysstat
    tmux
    btop
    lazydocker
    lazygit
    bat
    eza
    fastfetch
    fzf
    ripgrep
    fd
    nodePackages.nodejs
    perl
    gnumake
  ];
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableBashCompletion = true;
  };
  users.users.loganp = {
    isNormalUser = true;
    description = "Logan";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  home-manager.users.loganp = { pkgs, ... }: {
    home.stateVersion = "24.05"; # Please read the comment before changing.
    home.packages = with pkgs; [
      neovim
      tree-sitter
      luajitPackages.jsregexp
      bash-completion
      shellcheck
      shfmt
      bash-language-server
      lua-language-server
      nixd
      nixfmt-classic
      perl540Packages.PLS
    ];
    programs.zsh = {
      enable = true;
      initContent = "PROMPT='%B%F{green}[%1~]%f%b%F{grey}%#%f '";
      shellAliases = {
        ".." = "cd ../";
        "~" = "cd ~/";
        cl = "clear";
        ls = "eza";
        la = "eza -a";
        l1 = "eza -1";
        tree = "eza -T";
        nv = "nvim";
        nvsu = "sudo -E nvim";
        bat =
          "bat --color=always --theme=ansi --style=-numbers,-header,+changes";
        dcdu = "docker compose down; docker compose up -d";
        nixsysup = "sudo nixos-rebuild switch --upgrade";
        nixsysed = "nvsu /etc/nixos/configuration.nix";
        nixlsgens =
          "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        nixusrup = "nix profile upgrade loganp --verbose";
        fzf =
          "fzf --style full --preview 'bat --color=always --theme=ansi --style=-numbers,-header,+changes {}'";
      };
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
        set-option -ga terminal-overrides ",xterm-256color:Tc"
        set-option -g status-position top
        set -g renumber-windows on
        set -g pane-border-lines "single"
        set -g pane-active-border-style "fg=#3e8fb0"
        bind-key "|" split-window -h -c "#{pane_current_path}"
        bind-key "\\" split-window -fh -c "#{pane_current_path}"
        bind-key "-" split-window -v -c "#{pane_current_path}"
        bind-key "_" split-window -fv -c "#{pane_current_path}"
      '';
      plugins = with pkgs.tmuxPlugins; [{
        plugin = rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'main'
          set -g @rose_pine_disable_active_window_menu 'on'
          set -g @rose_pine_show_current_program 'on'
          set -g @rose_pine_host 'on'
          set -g @rose_pine_date_time '%b-%d-%Y %H:%M:%S'
          set -g @rose_pine_user 'on'
          set -g @rose_pine_directory 'on'
          set -g @rose_pine_right_separator ' '
        '';
      }];
    };
  };
}
