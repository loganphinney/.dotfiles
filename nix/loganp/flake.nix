{
  description = "loganp's nix packages";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs =
    { self, nixpkgs }:
    {
      packages.x86_64-linux.default =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        in
        with pkgs;
        buildEnv {
          name = "loganp-packages";
          paths = [
            #neovim stuff
            vim
            neovim
            tree-sitter
            gcc
            luajitPackages.jsregexp
            bash-completion
            shellcheck
            shfmt
            bash-language-server
            lua-language-server
            typescript-language-server
            nixd
            nixfmt-rfc-style
            perl540Packages.PLS
            vscode-langservers-extracted
            yaml-language-server
            #for fun
            lavat
            pokeget-rs
            #GNOME
            gnome-tweaks
            xdg-terminal-exec
            rose-pine-cursor
            mission-center
            gnomeExtensions.open-bar
            gnomeExtensions.hide-top-bar
            gnomeExtensions.user-themes
            gnomeExtensions.vitals
            gnomeExtensions.wallpaper-slideshow
            gnomeExtensions.color-picker
            gnomeExtensions.executor
            #GUI apps
            qbittorrent
            prismlauncher
          ];
        };
    };
}
