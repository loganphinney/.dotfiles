{
  description = "kiro-cli";
  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          kiro-cli-unwrapped = pkgs.callPackage ./unwrapped-package.nix { };
          kiro-cli = pkgs.callPackage ./package.nix { inherit kiro-cli-unwrapped; };
        in
        {
          inherit kiro-cli kiro-cli-unwrapped;
          default = kiro-cli;
        }
      );
    };
}
