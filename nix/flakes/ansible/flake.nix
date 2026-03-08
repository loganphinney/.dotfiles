{
  description = "packages for ansible";
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    flake-utils.url = "https://flakehub.com/f/numtide/flake-utils/0.1.102";
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
            ansible
            ansible-lint
            yamllint
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
