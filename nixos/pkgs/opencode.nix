# Add this to your configuration.nix or create a separate file like ~/.config/nixpkgs/opencode.nix

{ pkgs }:

let
  version = "1.0.180"; # Check https://github.com/anomalyco/opencode/releases for latest
  
  # Determine the right binary for your system
  system = pkgs.stdenv.hostPlatform.system;
  
  sources = {
    "x86_64-linux" = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-linux-x64.tar.gz";
      sha256 = "sha256-0Pt+AOzcsGedeWOWgJuHJapvWJVcefql/FbWoHI9vr0="; # Leave empty for now, Nix will tell you the correct hash
    };
    "aarch64-linux" = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-linux-arm64.tar.gz";
      sha256 = "";
    };
    "x86_64-darwin" = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-darwin-x64.zip";
      sha256 = "";
    };
    "aarch64-darwin" = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-darwin-arm64.zip";
      sha256 = "";
    };
  };

  src = pkgs.fetchurl (sources.${system} or (throw "Unsupported system: ${system}"));

in pkgs.stdenv.mkDerivation {
  pname = "opencode";
  inherit version;
  inherit src;

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    unzip
  ];

  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp opencode $out/bin/
    chmod +x $out/bin/opencode
    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "AI coding agent";
    homepage = "https://opencode.ai";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
