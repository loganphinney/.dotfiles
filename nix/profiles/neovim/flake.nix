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
              neovim-unwrapped
              tree-sitter
              luajitPackages.jsregexp
              # language servers
              shellcheck
              shfmt
              bash-language-server
              pyright
              ruff
              perl5Packages.PLS
              lua-language-server
              nixd
              nixfmt
              ansible-language-server
              ansible-lint
              typescript-language-server
              terraform-ls
            ];
          };
        }
      );
    };
}
