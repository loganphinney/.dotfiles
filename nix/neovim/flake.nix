{
  description = "packages for neovim";
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
            luajitPackages.jsregexp
            python313Packages.pynvim
            luajitPackages.luarocks
            #language servers
            shellcheck
            shfmt
            bash-language-server
            perl540Packages.PLS
            lua-language-server
            nixd
            nixfmt-rfc-style
            typescript-language-server
          ];
        };
    };
}
