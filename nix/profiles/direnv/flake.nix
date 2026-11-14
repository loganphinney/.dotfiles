{
  description = "nix-direnv dev shell";
  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      forAllSystems =
        f:
        lib.genAttrs systems (
          system:
          f (
            import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }
          )
        );
    in
    {
      devShells = forAllSystems (
        pkgs:
        let
          env = {
            ENV_EXAMPLE = "Hello from nix-direnv";
          };
          packages = with pkgs; [
            fastfetch
            (writeShellScriptBin "hello" ''
              echo "Hello from nix-direnv!"
            '')
          ];
        in
        {
          default = pkgs.mkShell {
            inherit packages env;
            shellHook = ''
              printf '\e[1;36menv\e[0m\n%s' ${lib.escapeShellArg (lib.concatLines (lib.attrNames env))}
              printf '\e[1;36mpkgs\e[0m\n%s' ${lib.escapeShellArg (lib.concatLines (map lib.getName packages))}
            '';
          };
        }
      );
    };
}
