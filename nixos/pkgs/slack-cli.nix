{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, deno
, git
}:

# Slack's official Platform CLI (https://docs.slack.dev/tools/slack-cli), used to
# create, run and deploy Slack apps. Not the `slack-cli` in nixpkgs, which is
# rockymadden's unrelated bash wrapper for posting messages.
#
# Upstream ships a prebuilt Go binary via a curl|bash installer; there is no
# source release, so the tarball is fetched directly.
#
# The tarball's binary is named `slack`, which would collide with the Slack
# desktop app in home.packages. Upstream's installer supports installing under a
# custom alias, so it is installed as `slack-cli` here.
#
# `slack-cli upgrade` cannot work (the store is read-only) — bump `version` and
# the hash here, then rebuild.

stdenv.mkDerivation (finalAttrs: {
  pname = "slack-cli";
  version = "3.10.0";

  src = fetchurl {
    url = "https://downloads.slack-edge.com/slack-cli/slack_cli_${finalAttrs.version}_linux_64-bit.tar.gz";
    hash = "sha256-sODK4Jp7up2AA0URYPMgYWeG0oiMnVO9Usp2GCWw5+I=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/slack $out/bin/slack-cli
    install -Dm644 LICENSE $out/share/licenses/slack-cli/LICENSE

    runHook postInstall
  '';

  # Deno runs Slack app hooks and the local dev server; git backs `slack create`
  # from a template repo.
  postFixup = ''
    wrapProgram $out/bin/slack-cli \
      --prefix PATH : ${lib.makeBinPath [ deno git ]}
  '';

  meta = {
    description = "CLI for creating, building, and deploying Slack apps";
    homepage = "https://docs.slack.dev/tools/slack-cli";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "slack-cli";
  };
})
