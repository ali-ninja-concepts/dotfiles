{ lib
, python313Packages
, fetchPypi
, makeWrapper
, git
, ripgrep
, ffmpeg
, nodejs_22
, chromium
}:

# Hermes: Nous Research's self-improving agent (https://hermes-agent.nousresearch.com).
#
# Upstream ships a curl|bash installer that git-clones the repo into ~/.hermes and
# builds a uv venv, which does not fit a declarative system. The same code is
# published to PyPI as a pure-python wheel, so it is packaged from there instead.
#
# Consequences of skipping the installer:
#   * `hermes update` (git pull on the checkout) does not apply — bump `version`
#     here and rebuild instead.
#   * The installer's dependency bootstrap (node, ripgrep, ffmpeg, Chromium for
#     the browser tool) is replaced by the PATH wrapper below.
#   * State, config, skills and sessions still live in $HERMES_HOME (~/.hermes).
#
# Needs python < 3.14, hence python313Packages rather than the default python3.

python313Packages.buildPythonApplication rec {
  pname = "hermes-agent";
  version = "0.19.0";
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "hermes_agent";
    dist = "py3";
    python = "py3";
    hash = "sha256-vQusASruOKYIlHgfRZfcKe577bNEhUAkmSHxDTvvMn8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # Upstream pins every dependency with `==` to whatever was current at release;
  # nixpkgs carries newer point releases of several of them.
  pythonRelaxDeps = true;

  dependencies = with python313Packages; [
    certifi
    croniter
    cryptography
    fastapi
    fire
    httpx
    jinja2
    markdown
    openai
    packaging
    pathspec
    pillow
    prompt-toolkit
    psutil
    ptyprocess
    pydantic
    pyjwt
    python-dotenv
    python-multipart
    pyyaml
    requests
    rich
    ruamel-yaml
    socksio # httpx[socks]
    tenacity
    urllib3
    uvicorn
    websockets
    # extras: cli (setup wizard menus) and mcp (MCP server/client tools)
    simple-term-menu
    mcp
    starlette
  ];

  # The wheel unpacks its modules at the top level of site-packages (agent/,
  # tools/, providers/, ...), so importing the package name proves nothing.
  pythonImportsCheck = [ "hermes_cli" "run_agent" ];

  # Tools shell out to these; the installer would otherwise fetch them itself.
  postFixup = ''
    for prog in hermes hermes-acp hermes-agent; do
      wrapProgram $out/bin/$prog \
        --prefix PATH : ${lib.makeBinPath [ git ripgrep ffmpeg nodejs_22 chromium ]} \
        --set-default PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD 1 \
        --set-default PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH ${lib.getExe chromium}
    done
  '';

  meta = with lib; {
    description = "Self-improving AI agent that creates skills from experience";
    homepage = "https://hermes-agent.nousresearch.com";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "hermes";
  };
}
