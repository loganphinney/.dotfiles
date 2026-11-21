{
  lib,
  stdenvNoCC,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  xz,
  bzip2,
}:

# The raw upstream binaries, autoPatchelf'd so kiro-cli itself runs on NixOS.
# This is enough for --version/--help and most of the CLI. The one thing it
# does NOT fix is the new TUI: on first `--tui` run kiro-cli-chat extracts an
# embedded, generic-glibc `bun` (interpreter /lib64/ld-linux-x86-64.so.2) to
# ~/.local/share/kiro-cli/ and exec()s it, which fails on NixOS (#516857).
# That is handled by the kiro-cli package, which wraps this one in an FHS env.
#
# As of 3.3.0 the macOS release ships as a universal tar.gz (not a .dmg), so
# undmg is no longer needed and the Darwin sourceRoot changed accordingly.
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kiro-cli-unwrapped";
  version = "3.3.0";

  __structuredAttrs = true;

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-x86_64-linux.tar.gz";
        hash = "";
      };
      aarch64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-aarch64-linux.tar.gz";
        hash = "";
      };
      # Universal binary (x86_64 + aarch64) covering both Darwin platforms.
      x86_64-darwin = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-universal-darwin.tar.gz";
        hash = "";
      };
      aarch64-darwin = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-universal-darwin.tar.gz";
        hash = "";
      };
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  sourceRoot = "kirocli";

  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    xz
    bzip2
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/kiro-cli -t $out/bin
    runHook postInstall
  '';

  passthru.updateScript = ./update;

  meta = {
    description = "Command-line interface for Kiro, an agentic IDE";
    homepage = "https://kiro.dev";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      jamesward
      pmw
    ];
    mainProgram = "kiro-cli";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
