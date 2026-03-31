{ pkgs, lib, stdenv, fetchurl, autoPatchelfHook }:

let
  version = "0.83.0";

  system = stdenv.hostPlatform.system;

  sources = {
    "x86_64-linux" = {
      url = "https://github.com/marcus/sidecar/releases/download/v${version}/sidecar_${version}_linux_amd64.tar.gz";
      sha256 = "sha256-HuklTh6YxvgsBgGoyPlwp3mMQp8JbdRROAiP1jyUjgA=";
    };
  };

  src = fetchurl (sources.${system} or (throw "Unsupported system: ${system}"));

in stdenv.mkDerivation {
  pname = "sidecar";
  inherit version src;

  nativeBuildInputs = [ autoPatchelfHook ];

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp sidecar $out/bin/sidecar
  '';

  meta = with lib; {
    description = "Terminal UI companion for AI coding agents";
    homepage = "https://github.com/marcus/sidecar";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
