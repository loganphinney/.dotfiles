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
stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "kiro-cli-unwrapped";
  version = "3.5.0";
  src =
    {
      x86_64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-x86_64-linux.tar.gz";
        hash = "sha256-mPAWt0azQtgzeg6TfKvsw4EDfi6SDqD/quZJ5R71nU4=";
      };
      aarch64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-aarch64-linux.tar.gz";
        hash = "sha256-NERP7gMpRANygsdi30/2kppR6CfdctQCy3qK++yzPn8=";
      };
      # Universal binary (x86_64 + aarch64) covering both Darwin platforms.
      x86_64-darwin = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-universal-darwin.tar.gz";
        hash = "sha256-byb1H+iy8m2wWORa0tT4vOd6SRZ7J9otzmcClSo2MNs=";
      };
      aarch64-darwin = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-universal-darwin.tar.gz";
        hash = "sha256-byb1H+iy8m2wWORa0tT4vOd6SRZ7J9otzmcClSo2MNs=";
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
