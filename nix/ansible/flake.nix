{
  description = "packages for ansible";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      ansible-language-server = pkgs.writeShellScriptBin "ansible-language-server" ''
        exec ${pkgs.nodejs}/bin/npx @ansible/ansible-language-server@1.2.3 "$@"
      '';
    in
    {
      packages.${system}.default =
        with pkgs;
        buildEnv {
          name = "loganp-packages";
          paths = [
            python314
            pyenv
            ansible
            ansible-language-server
            ansible-lint
            yamllint
            nodejs_24
          ];
        };
    };
}
