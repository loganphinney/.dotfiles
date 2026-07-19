{ pkgs, ... }:
{
  home = {
    username = "loganp";
    homeDirectory = "/home/loganp";
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
  programs = {
    zsh = {
      enable = true;
      initContent = "PROMPT='%B%F{2}[%1~]%f%b%F{8}%#%f '";
      completionInit = ''
        fpath=(/run/current-system/sw/share/zsh/site-functions /run/current-system/sw/share/zsh/$ZSH_VERSION/functions $fpath)
        autoload -Uz compinit bashcompinit
        compinit -C; bashcompinit
      '';
      shellAliases = {
        ".." = "cd ../";
        "~" = "cd ~/";
        cl = "clear";
        ls = "eza";
        la = "eza -a";
        ll = "eza -l";
        l1 = "eza -1";
        lt = "eza -T";
        nv = "nvim";
        nvsu = "sudo -E nvim";
        lg = "lazygit";
        lava = "lavat -c black -k magenta -s 3";
        cmatrix = "cmatrix -C magenta";
        nixed = "nvim ~/.dotfiles/nix/dsk";
        nixupdate = "sudo nixos-rebuild switch --flake ~/.dotfiles/nix/dsk";
        nixupgrade = "sudo nix flake update --flake ~/.dotfiles/nix/dsk";
        nhupdate = "nh os switch ~/.dotfiles/nix/dsk --no-nom";
        nhupgrade = "nh os switch -u ~/.dotfiles/nix/dsk --no-nom";
        nhclean = "nh clean all -k 4";
      };
      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
        }
      ];
      history = {
        share = true;
        append = true;
        ignoreDups = true;
        ignoreAllDups = true;
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
    kitty = {
      enable = true;
      font.name = "Hack Nerd Font Mono";
      font.size = 11;
      shellIntegration.mode = "no-rc no-title";
      settings = {
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
        window_padding_width = 3;
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
        wayland_titlebar_color = "#191724";
        hide_window_decorations = "titlebar-only";
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
    tmux = {
      enable = true;
      terminal = "xterm-kitty";
      baseIndex = 1;
      mouse = true;
      focusEvents = true;
      clock24 = true;
      shortcut = "s";
      extraConfig = ''
        set-option -g status-position top
        set -g renumber-windows on
        set -g pane-border-lines "single"
        set -g pane-border-style "fg=#1f1d2e"
        set -g pane-active-border-style "fg=#1f1d2e"
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
    helix = {
      enable = true;
      themes.rose-pine = fromTOML (
        builtins.replaceStrings [ "#31748f" ] [ "#3e8fb0" ] (
          builtins.readFile (
            pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/rose-pine/helix/2e8b94d54d48980ac9bbdfa6aae40b02227b71c3/rose_pine.toml";
              hash = "sha256-/Hf37vOO0JATRdGh9dbbblJUgOZaR41fL/V2Kg+sCes=";
            }
          )
        )
      );
      settings = {
        theme = "rose-pine";
        editor = {
          line-number = "relative";
          cursor-shape.insert = "bar";
        };
      };
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
    lazygit = {
      enable = true;
      settings = {
        promptToReturnFromSubprocess = false;
        gui.theme = {
          inactiveBorderColor = [ "#6e6a86" ];
        };
        git = {
          pagers = [
            {
              pager = builtins.replaceStrings [ "\n" ] [ " " ] ''
                delta --dark --paging=never --line-numbers --hunk-header-style=omit
                --minus-style="red normal" --minus-emph-style="red normal"
                --plus-style="green normal" --plus-emph-style="green normal"
                --line-numbers-minus-style="red" --line-numbers-plus-style="green"
                --line-numbers-zero-style="#524f67" --zero-style="#524f67 normal"
                --file-style="bold cyan" --file-decoration-style="magenta ul"
                --line-numbers-right-style="#21202e" --syntax-theme=none
              '';
            }
            {
              pager = builtins.replaceStrings [ "\n" ] [ " " ] ''
                delta --dark --paging=never --line-numbers --hunk-header-style=omit
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
    obsidian = {
      enable = true;
      vaults.notes = {
        target = "Documents/Notes";
        settings = {
          themes = [
            {
              pkg = pkgs.fetchFromGitHub {
                owner = "rose-pine";
                repo = "obsidian";
                rev = "e2b47ad4ff24626b597d0b2a36250e22073760e7";
                hash = "sha256-HSGFmmQcH2WlJBpPv2yek16iiz92leQbIspCN6oB1AA=";
              };
              enable = true;
            }
          ];
          cssSnippets = [
            {
              name = "wide-body";
              enable = true;
              text = "body { --file-line-width: 33vw; }";
            }
          ];
        };
      };
    };
    niri = {
      enable = true;
      settings = {
        hotkey-overlay.skip-at-startup = true;
        spawn-at-startup = [ { command = [ "noctalia" ]; } ];
        outputs."DP-2".mode = {
          width = 2560;
          height = 1440;
          refresh = 239.970;
        };
        layout = {
          gaps = 0;
          border.enable = false;
          border.active = {
            color = "#403d52";
          };
          border.inactive = {
            color = "#21202e";
          };
          border.width = 2;
          focus-ring.enable = false;
          default-column-width.proportion = 0.5;
          always-center-single-column = true;
        };
        overview = {
          backdrop-color = "#191724";
        };
        cursor.theme = "BreezeX-RosePine-Linux";
        binds = {
          "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];
          "Mod+Space".action.spawn-sh = "noctalia msg panel-toggle launcher";
          "Mod+Ctrl+Q".action.spawn-sh = "noctalia msg session lock";
          "Mod+T".action.spawn = "kitty";
          "Mod+B".action.spawn = "firefox";
          "Mod+N".action.spawn-sh = "nautilus -w ~";
          "XF86AudioRaiseVolume" = {
            action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0";
            allow-when-locked = true;
          };
          "XF86AudioLowerVolume" = {
            action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
            allow-when-locked = true;
          };
          "XF86AudioMute" = {
            action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            allow-when-locked = true;
          };
          "XF86AudioMicMute" = {
            action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            allow-when-locked = true;
          };
          "XF86AudioPlay" = {
            action.spawn-sh = "playerctl play-pause";
            allow-when-locked = true;
          };
          "XF86AudioStop" = {
            action.spawn-sh = "playerctl stop";
            allow-when-locked = true;
          };
          "XF86AudioPrev" = {
            action.spawn-sh = "playerctl previous";
            allow-when-locked = true;
          };
          "XF86AudioNext" = {
            action.spawn-sh = "playerctl next";
            allow-when-locked = true;
          };
          "XF86MonBrightnessUp" = {
            action.spawn = [
              "brightnessctl"
              "--class=backlight"
              "set"
              "+10%"
            ];
            allow-when-locked = true;
          };
          "XF86MonBrightnessDown" = {
            action.spawn = [
              "brightnessctl"
              "--class=backlight"
              "set"
              "10%-"
            ];
            allow-when-locked = true;
          };
          "Mod+O" = {
            action.toggle-overview = [ ];
            repeat = false;
          };
          "Mod+Q" = {
            action.close-window = [ ];
            repeat = false;
          };
          "Mod+Left".action.focus-column-left = [ ];
          "Mod+Down".action.focus-window-down = [ ];
          "Mod+Up".action.focus-window-up = [ ];
          "Mod+Right".action.focus-column-right = [ ];
          "Mod+H".action.focus-column-left = [ ];
          "Mod+J".action.focus-window-down = [ ];
          "Mod+K".action.focus-window-up = [ ];
          "Mod+L".action.focus-column-right = [ ];
          "Mod+Ctrl+Left".action.move-column-left = [ ];
          "Mod+Ctrl+Down".action.move-window-down = [ ];
          "Mod+Ctrl+Up".action.move-window-up = [ ];
          "Mod+Ctrl+Right".action.move-column-right = [ ];
          "Mod+Ctrl+H".action.move-column-left = [ ];
          "Mod+Ctrl+J".action.move-window-down = [ ];
          "Mod+Ctrl+K".action.move-window-up = [ ];
          "Mod+Ctrl+L".action.move-column-right = [ ];
          "Mod+Home".action.focus-column-first = [ ];
          "Mod+End".action.focus-column-last = [ ];
          "Mod+Ctrl+Home".action.move-column-to-first = [ ];
          "Mod+Ctrl+End".action.move-column-to-last = [ ];
          "Mod+Shift+Left".action.focus-monitor-left = [ ];
          "Mod+Shift+Down".action.focus-monitor-down = [ ];
          "Mod+Shift+Up".action.focus-monitor-up = [ ];
          "Mod+Shift+Right".action.focus-monitor-right = [ ];
          "Mod+Shift+H".action.focus-monitor-left = [ ];
          "Mod+Shift+J".action.focus-monitor-down = [ ];
          "Mod+Shift+K".action.focus-monitor-up = [ ];
          "Mod+Shift+L".action.focus-monitor-right = [ ];
          "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [ ];
          "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [ ];
          "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [ ];
          "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [ ];
          "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
          "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [ ];
          "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [ ];
          "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [ ];
          "Mod+Page_Down".action.focus-workspace-down = [ ];
          "Mod+Page_Up".action.focus-workspace-up = [ ];
          "Mod+U".action.focus-workspace-down = [ ];
          "Mod+I".action.focus-workspace-up = [ ];
          "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [ ];
          "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [ ];
          "Mod+Ctrl+U".action.move-column-to-workspace-down = [ ];
          "Mod+Ctrl+I".action.move-column-to-workspace-up = [ ];
          "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
          "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
          "Mod+Shift+U".action.move-workspace-down = [ ];
          "Mod+Shift+I".action.move-workspace-up = [ ];
          "Mod+WheelScrollDown" = {
            action.focus-workspace-down = [ ];
            cooldown-ms = 150;
          };
          "Mod+WheelScrollUp" = {
            action.focus-workspace-up = [ ];
            cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollDown" = {
            action.move-column-to-workspace-down = [ ];
            cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollUp" = {
            action.move-column-to-workspace-up = [ ];
            cooldown-ms = 150;
          };
          "Mod+WheelScrollRight".action.focus-column-right = [ ];
          "Mod+WheelScrollLeft".action.focus-column-left = [ ];
          "Mod+Ctrl+WheelScrollRight".action.move-column-right = [ ];
          "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [ ];
          "Mod+Shift+WheelScrollDown".action.focus-column-right = [ ];
          "Mod+Shift+WheelScrollUp".action.focus-column-left = [ ];
          "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [ ];
          "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [ ];
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Ctrl+1".action.move-column-to-workspace = 1;
          "Mod+Ctrl+2".action.move-column-to-workspace = 2;
          "Mod+Ctrl+3".action.move-column-to-workspace = 3;
          "Mod+Ctrl+4".action.move-column-to-workspace = 4;
          "Mod+Ctrl+5".action.move-column-to-workspace = 5;
          "Mod+Ctrl+6".action.move-column-to-workspace = 6;
          "Mod+Ctrl+7".action.move-column-to-workspace = 7;
          "Mod+Ctrl+8".action.move-column-to-workspace = 8;
          "Mod+Ctrl+9".action.move-column-to-workspace = 9;
          "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
          "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
          "Mod+Comma".action.consume-window-into-column = [ ];
          "Mod+Period".action.expel-window-from-column = [ ];
          "Mod+R".action.switch-preset-column-width = [ ];
          "Mod+Shift+R".action.switch-preset-window-height = [ ];
          "Mod+Ctrl+R".action.reset-window-height = [ ];
          "Mod+F".action.maximize-column = [ ];
          "Mod+Shift+F".action.fullscreen-window = [ ];
          #"Mod+M".action.maximize-window-to-edges = [ ];
          "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];
          "Mod+C".action.center-column = [ ];
          "Mod+Ctrl+C".action.center-visible-columns = [ ];
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";
          "Mod+V".action.toggle-window-floating = [ ];
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];
          "Mod+W".action.toggle-column-tabbed-display = [ ];
          "Print".action.screenshot = [ ];
          "Ctrl+Print".action.screenshot-screen = [ ];
          "Alt+Print".action.screenshot-window = [ ];
          "Mod+Escape" = {
            action.toggle-keyboard-shortcuts-inhibit = [ ];
            allow-inhibiting = false;
          };
          "Mod+Shift+E".action.quit = [ ];
          "Ctrl+Alt+Delete".action.quit = [ ];
          "Mod+Shift+P".action.power-off-monitors = [ ];
        };
      };
    };
    noctalia = {
      enable = true;
      settings = {
        bar.widgets = {
          center = [ "workspaces" ];
          end = [
            "weather"
            "notifications"
            "clock"
            "control-center"
            "session"
          ];
          margin_edge = 0;
          margin_ends = 0;
          padding = 9;
          radius = 0;
          shadow = false;
          start = [
            "launcher"
            "cpu"
            "ram"
            "network_rx"
            "sysmon"
          ];
          thickness = 28;
          widget_spacing = 9;
        };
        control_center.shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "power_profile"; }
          { type = "clipboard"; }
        ];
        desktop_widgets = {
          enabled = false;
          schema_version = 2;
          grid.cell_size = 16;
          grid.major_interval = 4;
          grid.visible = true;
        };
        dock.auto_hide = true;
        idle.pre_action_fade_seconds = 0;
        location.address = "Charlotte, NC";
        lockscreen_widgets = {
          enabled = false;
          schema_version = 2;
          widget_order = [ "lockscreen-login-box@DP-2" ];
          grid.cell_size = 16;
          grid.major_interval = 4;
          grid.visible = true;
          widget."lockscreen-login-box@DP-2" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 1280.0;
            cy = 1317.0;
            output = "DP-2";
            rotation = 0.0;
            type = "login_box";
          };
        };
        notification.position = "bottom_left";
        shell = {
          time_format = "{:%H:%M:%S}";
          panel.launcher_categories = false;
          panel.launcher_compact = true;
          panel.launcher_placement = "attached";
          panel.open_near_click_session = true;
          screenshot.directory = "/home/loganp/Pictures/Screenshots";
        };
        theme = {
          builtin = "Rosé Pine";
          templates.enable_builtin_templates = false;
          templates.enable_community_templates = false;
        };
        wallpaper.default.path = "/home/loganp/Pictures/rose-pine/felix-bacher--jEEnRx38wo.jpg";
        weather.unit = "imperial";
        widget.clock.format = "{:%H:%M:%S}";
        widget.cpu.display = "text";
        widget.cpu.stat = "cpu_temp";
        widget.launcher.glyph = "terminal-2";
        widget.network_rx.display = "text";
        widget.ram.display = "text";
        widget.ram.stat = "ram_pct";
        widget.session.glyph = "";
        widget.sysmon.display = "text";
        widget.sysmon.stat = "disk_pct";
        widget.temp.display = "text";
        widget.temp.stat = "gpu_usage";
        widget.notifications.hide_when_no_unread = false;
        widget.weather.show_condition = false;
      };
    };
  };
}
