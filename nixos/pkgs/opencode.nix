{ pkgs, lib, stdenv, fetchurl, makeWrapper }:

let
  version = "1.0.180";
  
  system = stdenv.hostPlatform.system;
  
  sources = {
    "x86_64-linux" = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-linux-x64.tar.gz";
      sha256 = "sha256-0Pt+AOzcsGedeWOWgJuHJapvWJVcefql/FbWoHI9vr0=";
    };
  };

  src = fetchurl (sources.${system} or (throw "Unsupported system: ${system}"));

in stdenv.mkDerivation {
  pname = "opencode";
  inherit version src;

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    cp opencode $out/bin/.opencode-unwrapped
    makeWrapper $out/bin/.opencode-unwrapped $out/bin/opencode \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
  '';

  meta = with lib; {
    description = "AI coding agent";
    homepage = "https://opencode.ai";
    platforms = [ "x86_64-linux" ];
  };
}
