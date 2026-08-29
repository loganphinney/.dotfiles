{
  description = "Ansible 2.9.7";
  inputs.nixpkgs = {
    url = "github:NixOS/nixpkgs?rev=dde157780c80af9a10820c7c07794abb65b1fdbf";
    flake = false;
  };
  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = builtins.listToAttrs (
        map (system: {
          name = system;
          value =
            let
              pkgs = import nixpkgs {
                inherit system;
              };
              ansible = pkgs.python3Packages.buildPythonPackage rec {
                pname = "ansible";
                version = "2.9.7";
                src = pkgs.fetchFromGitHub {
                  owner = "ansible";
                  repo = "ansible";
                  rev = "v${version}";
                  sha256 = "0miid7h720i630qljcjdmgdblflhrl2pwqjgiq5wm8jr61c3ld6s";
                };
                prePatch = ''
                  sed -i "s/\[python, /[/" lib/ansible/executor/task_executor.py
                '';
                postInstall = ''
                  for m in docs/man/man1/*; do
                    install -vD "$m" -t "$out/share/man/man1"
                  done
                '';
                propagatedBuildInputs = with pkgs.python3Packages; [
                  pycrypto
                  paramiko
                  jinja2
                  pyyaml
                  httplib2
                  six
                  netaddr
                  dnspython
                  jmespath
                  dopy
                  ncclient
                ];
                doCheck = false;
                meta = with pkgs.lib; {
                  homepage = "http://www.ansible.com";
                  description = "Radically simple IT automation";
                  license = licenses.gpl3;
                  platforms = platforms.linux ++ platforms.darwin;
                };
              };
            in
            {
              default = ansible;
              ansible = ansible;
            };
        }) systems
      );
    in
    {
      packages = forAllSystems;
    };
}
