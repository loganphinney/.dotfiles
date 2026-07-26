{
  description = "AWS MCP Proxy";
  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
            };
          }
        );
    in
    {
      packages = forEachSupportedSystem (
        { pkgs }:
        let
          python = pkgs.python3;
          aws-mcp-proxy = python.pkgs.buildPythonPackage {
            pname = "mcp-proxy-for-aws";
            version = "unstable";
            pyproject = true;
            src = pkgs.fetchFromGitHub {
              owner = "aws";
              repo = "mcp-proxy-for-aws";
              rev = "v1.6.3";
              hash = "sha256-l8SUe6yjO3D0vchmzrzs6HxJQbO62YICU3BkEr4NUSk=";
            };
            nativeBuildInputs = with python.pkgs; [
              hatchling
            ];
            propagatedBuildInputs = with python.pkgs; [
              boto3
              botocore
              click
              fastmcp
              httpx
              mcp
              pydantic
              pyyaml
            ];
            pythonImportsCheck = [
              "mcp_proxy_for_aws"
            ];
            meta = with pkgs.lib; {
              description = "AWS MCP Proxy";
              homepage = "https://github.com/aws/mcp-proxy-for-aws";
              license = licenses.asl20;
              platforms = platforms.unix;
            };
          };
        in
        {
          default = pkgs.buildEnv {
            name = "aws-mcp-proxy";
            paths = [
              aws-mcp-proxy
            ];
          };
        }
      );
    };
}
