{
  description = "packages for neovim";
  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      packages = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.buildEnv {
            name = "loganp-packages";
            paths = with pkgs; [
              neovim
              tree-sitter
              luajitPackages.jsregexp
              python313Packages.pynvim
              luajitPackages.luarocks
              # language servers
              shellcheck
              shfmt
              bash-language-server
              perl5Packages.PLS
              lua-language-server
              nixd
              nixfmt
              typescript-language-server
            ];
          };
        }
      );
    };
}
