{
  description = "nix-darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
  };
  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, mac-app-util }:
    let
      configuration = { pkgs, ... }: {
        nix.settings.experimental-features = "nix-command flakes";
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
          enableSyntaxHighlighting = true;
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
          #brews = [ "" ];
          casks = [
            "firefox"
            "docker-desktop"
            "macs-fan-control"
            "minecraft"
            "figma"
          ];
          global.autoUpdate = true;
        };
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
            bug = "brew upgrade --greedy";
            fzf =
              "fzf --style full --preview 'bat --color=always --theme=ansi --style=-numbers,-header,+changes {}'";
            lava = "lavat -c black -k magenta -s 3";
            cmatrix = "cmatrix -C magenta";
            darwinup = "sudo darwin-rebuild switch --verbose";
            darwined = "nvsu /etc/nix-darwin/flake.nix";
          };
        };
        programs.fzf = {
          enable = true;
          enableZshIntegration = true;
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
