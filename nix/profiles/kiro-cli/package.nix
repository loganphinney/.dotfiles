{
  lib,
  stdenv,
  buildFHSEnv,
  makeWrapper,
  testers,
  writeShellScript,
  kiro-cli-unwrapped,
  waylandSupport ? stdenv.hostPlatform.isLinux,
}:
let
  inherit (kiro-cli-unwrapped) version meta;
  fhsenv = buildFHSEnv {
    pname = "kiro-cli";
    inherit version;
    runScript = writeShellScript "kiro-cli" ''
      exec kiro-cli "$@"
    '';
    targetPkgs =
      pkgs:
      [
        kiro-cli-unwrapped
        pkgs.stdenv.cc.cc.lib
      ]
      ++ lib.optional waylandSupport pkgs.wl-clipboard;
    nativeBuildInputs = [ makeWrapper ];
    extraInstallCommands = ''
      mkdir -p $out/libexec/kiro-cli
      mv $out/bin/kiro-cli $out/libexec/kiro-cli/kiro-cli-wrapper
      makeWrapper "$out/libexec/kiro-cli/kiro-cli-wrapper" "$out/bin/kiro-cli"
    '';
    passthru = {
      unwrapped = kiro-cli-unwrapped;
      tests.version = testers.testVersion {
        package = kiro-cli-unwrapped;
        inherit version;
      };
    };
    meta = meta // {
      mainProgram = "kiro-cli";
    };
  };
in
if stdenv.hostPlatform.isLinux then
  fhsenv
else
  kiro-cli-unwrapped.overrideAttrs { pname = "kiro-cli"; }
