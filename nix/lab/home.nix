{ pkgs, ... }:
{
  home = {
    username = "loganp";
    homeDirectory = "/home/loganp";
    stateVersion = "26.05";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      NH_FLAKE = "$HOME/.dotfiles/nix/lab";
    };
  };
  programs = {
    zsh = {
      enable = true;
      initContent = "PROMPT='%F{8}[%1~]%#%f '";
      enableCompletion = true;
      completionInit = ''
        fpath=(/run/current-system/sw/share/zsh/site-functions /run/current-system/sw/share/zsh/$ZSH_VERSION/functions $fpath)
        autoload -Uz compinit bashcompinit
        compinit -C; bashcompinit
      '';
      history = {
        share = true;
        append = true;
        ignoreDups = true;
        ignoreAllDups = true;
      };
      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
        }
      ];
      shellAliases = {
        ".." = "cd ../";
        "~" = "cd ~/";
        cl = "clear";
        ls = "eza";
        la = "eza -a";
        l = "eza -glo";
        ll = "eza -aglo";
        l1 = "eza -1";
        lt = "eza -T";
        nv = "nvim";
        nvsu = "sudo -E nvim";
        lg = "lazygit";
        nixed = "nvim ~/.dotfiles/nix/lab";
        nixupdate = "sudo nixos-rebuild switch --flake ~/.dotfiles/nix/lab";
        nixupgrade = "sudo nix flake update --flake ~/.dotfiles/nix/lab";
        nhupdate = "nh os switch --no-nom";
        nhupgrade = "nh os switch -u";
        nhclean = "nh clean all -k 4";
      };
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    tmux = {
      enable = true;
      baseIndex = 1;
      mouse = true;
      focusEvents = true;
      clock24 = true;
      shortcut = "s";
      extraConfig = ''
        set -s extended-keys on
        set -g set-clipboard external
        set -g renumber-windows on
        set -g status-position top
        set -g pane-border-lines "single"
        set -g pane-border-style "fg=#1f1d2e"
        set -g pane-active-border-style "fg=#1f1d2e"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[5 q'
        bind "|" split-window -h -c "#{pane_current_path}"
        bind "\\" split-window -fh -c "#{pane_current_path}"
        bind "-" split-window -v -c "#{pane_current_path}"
        bind "_" split-window -fv -c "#{pane_current_path}"
      '';
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = (
            mkTmuxPlugin {
              pluginName = "rose-pine-tmux";
              version = "1-unstable-2026-07-23";
              src = pkgs.fetchFromGitHub {
                owner = "rose-pine";
                repo = "tmux";
                rev = "43d03507427ac3ad92cadfdf0d1307b8b0ff5128";
                hash = "sha256-niFXeZRyJ26ukNxEgQjzGbNPPQPtpoe5/7cF/9VGOTk=";
              };
              postInstall = ''
                substituteInPlace $target/rose-pine.tmux --replace "#31748f" "#3e8fb0"
              '';
              rtpFilePath = "rose-pine.tmux";
            }
          );
          extraConfig = ''
            set -g default-terminal "xterm-256color"
            set -as terminal-overrides ',xterm*:Tc'
            set -g @rose_pine_variant 'main'
            set -g @rose_pine_session_icon ''
            set -g @rose_pine_date_time '%b-%d-%Y %H:%M:%S'
            set -g @rose_pine_disable_active_window_menu 'on'
            set -g @rose_pine_show_current_program 'on'
            set -g @rose_pine_host 'on'
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
          version = "2026-06-05";
          src = pkgs.fetchFromGitHub {
            owner = "rose-pine";
            repo = "vim";
            rev = "d7bc0ccbbd71d632f5737a1a880a0ed32d1be6bf";
            sha256 = "1qia0hbcjfba4w4s6ax4l99f0hnnc1vqjkkhvgpicpk7jzq51r6h";
          };
          postInstall = ''
            substituteInPlace $out/colors/rosepine.vim --replace "#31748f" "#3e8fb0"
          '';
        })
      ];
      extraConfig = ''
        set mouse=a
        syntax on
        set relativenumber
        set termguicolors
        set tabstop=4
        set shiftwidth=4
        set autoindent
        set smartindent
        set wildmenu
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
      historyWidget.options = [ "--no-preview" ];
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
        style = "-numbers,-header,-grid,-changes";
      };
      themes.rose-pine = {
        src = pkgs.applyPatches {
          src = pkgs.fetchFromGitHub {
            owner = "rose-pine";
            repo = "tm-theme";
            rev = "6d556734541ccb04172e81fd58de4a35fff72d19";
            sha256 = "0sk4aq8ia5rh6p4vgmxc6449ypmn8lzr6czv7vfvc1wvabdwdrz7";
          };
          postPatch = ''
            substituteInPlace dist/rose-pine.tmTheme --replace "#31748f" "#3e8fb0"
          '';
        };
        file = "dist/rose-pine.tmTheme";
      };
    };
    jq = {
      enable = true;
      colors = {
        null = "0;90";
        false = "0;39";
        true = "0;39";
        numbers = "0;39";
        strings = "0;37";
        arrays = "1;90";
        objects = "1;90";
        objectKeys = "0;34";
      };
    };
    lazygit = {
      enable = true;
      settings = {
        promptToReturnFromSubprocess = false;
        gui.theme = {
          inactiveBorderColor = [ "#6e6a86" ];
        };
        git = {
          diffRenderers = [
            {
              command = builtins.replaceStrings [ "\n" ] [ " " ] ''
                delta --dark --paging=never --hunk-header-style=omit
                --minus-style="red normal" --minus-emph-style="red normal"
                --plus-style="green normal" --plus-emph-style="green normal"
                --line-numbers-minus-style="red" --line-numbers-plus-style="green"
                --line-numbers-zero-style="#524f67" --zero-style="#524f67 normal"
                --file-style="bold cyan" --file-decoration-style="magenta ul"
                --line-numbers-right-style="#21202e" --syntax-theme=none
              '';
            }
            {
              command = builtins.replaceStrings [ "\n" ] [ " " ] ''
                delta --dark --paging=never --hunk-header-style=omit
                --minus-style="red normal" --minus-emph-style="red normal"
                --plus-style="syntax normal" --plus-emph-style="syntax normal"
                --line-numbers-minus-style="red" --line-numbers-plus-style="green"
                --line-numbers-zero-style="#524f67" --zero-style="#524f67 normal"
                --file-style="bold cyan" --file-decoration-style="magenta ul"
                --line-numbers-right-style="#21202e" --syntax-theme=rose-pine
              '';
            }
          ];
        };
      };
    };
  };
}
