{
  description = "packages for ansible";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        ansible-language-server = pkgs.writeShellScriptBin "ansible-language-server" ''
          exec ${pkgs.nodejs_24}/bin/npx --yes @ansible/ansible-language-server@1.2.3 "$@"
        '';
      in
      {
        packages.default = pkgs.buildEnv {
          name = "loganp-packages";
          paths = with pkgs; [
            python314
            pyenv
            ansible
            ansible-lint
            yamllint
            nodejs_24
            ansible-language-server
          ];
        };
        devShells.default = pkgs.mkShell {
          packages = [ self.packages.${system}.default ];
          shellHook = ''
            export PATH="$PATH:$(pwd)/node_modules/.bin"
            echo "Ansible Dev Environment Loaded"
          '';
        };
      }
    );
}
