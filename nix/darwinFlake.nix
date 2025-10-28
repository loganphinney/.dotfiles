{
  description = "nix-darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    rose-pine-tmux.url = "path:/Users/loganphinney/nix/flakes/rose-pine-tmux/";
  };
  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, mac-app-util
    , rose-pine-tmux }:
    let
      configuration = { pkgs, ... }: {
        nix.settings.experimental-features = "nix-command flakes";
        nix.optimise.automatic = true;
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 6;
        nixpkgs.hostPlatform = "aarch64-darwin";
        networking.hostName = "mac-loganp";
        system.primaryUser = "loganphinney";
        users.users."loganphinney" = {
          name = "loganphinney";
          home = "/Users/loganphinney";
        };
        security.pam.services.sudo_local = {
          enable = true;
          reattach = true;
          touchIdAuth = true;
        };
        nixpkgs.config.allowUnfree = true;
        fonts.packages = with pkgs; [ nerd-fonts.hack ];
        programs.zsh = {
          enable = true;
          enableFastSyntaxHighlighting = true;
          enableBashCompletion = true;
          enableCompletion = true;
        };
        environment.systemPackages = with pkgs; [
          kitty
          rectangle
          jetbrains.datagrip
          utm
          git
          rsync
          wget
          curl
          openssl
          openssh
          nmap
          tmux
          nano
          fzf
          bat
          ripgrep
          fd
          eza
          stow
          btop
          unixtools.watch
          gnumake
          docker-compose
          fastfetch
          lazygit
          lazydocker
          perl
          ruby
          lua
          nodePackages_latest.nodejs
        ];
        homebrew = {
          enable = true;
          casks =
            [ "firefox" "docker-desktop" "macs-fan-control" "utm" "figma" ];
          global.autoUpdate = true;
        };
        environment.variables = { EDITOR = "nvim"; };
      };

      homeManagerConfig = { pkgs, ... }: {
        home.stateVersion = "25.11";
        home.username = "loganphinney";
        home.homeDirectory = "/Users/loganphinney";
        home.packages = with pkgs; [
          neovim
          tree-sitter
          bash-language-server
          lua-language-server
          typescript-language-server
          nixd
          shellcheck
          shfmt
          nixfmt-classic
          perl540Packages.PLS
          luajitPackages.luarocks
          python313Packages.pynvim
          lavat
          cmatrix
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
            bug = "brew upgrade --greedy";
            darwinup = "sudo darwin-rebuild switch --verbose";
            darwined = "nvsu /etc/nix-darwin/flake.nix";
          };
        };
        programs.fzf = {
          enable = true;
          enableZshIntegration = true;
        };
        programs.kitty = {
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
            active_border_color = "#3e8fb0";
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
            bind-key "|" split-window -h -c "#{pane_current_path}"
            bind-key "\\" split-window -fh -c "#{pane_current_path}"
            bind-key "-" split-window -v -c "#{pane_current_path}"
            bind-key "_" split-window -fv -c "#{pane_current_path}"
            set -g pane-active-border-style "fg=#3e8fb0"
          '';
          plugins = with pkgs.tmuxPlugins; [
            {
              plugin =
                inputs.rose-pine-tmux.packages.${pkgs.system}.rose-pine-tmux;
              extraConfig = ''
                set -g @rose_pine_variant 'main'
                set -g @rose_pine_disable_active_window_menu 'on'
                set -g @rose_pine_show_current_program 'on'
                set -g @rose_pine_host 'on'
                set -g @rose_pine_date_time '%m-%d-%Y %H:%M:%S'
                #set -g @rose_pine_user 'on' 
                set -g @rose_pine_directory 'on'
                set -g @rose_pine_right_separator ' '
                set -g @rose_pine_status_right_prepend_section '#{cpu_icon}#{cpu_percentage} #{battery_percentage} ' 
              '';
            }
            cpu
            battery
          ];
        };
      };

    in {
      darwinConfigurations."mac-loganp" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.loganphinney = homeManagerConfig;
          }
        ];
      };
    };
}
