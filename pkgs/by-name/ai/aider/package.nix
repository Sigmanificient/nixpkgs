{
  lib,
  python311Packages,
  fetchFromGitHub,
  git,
  portaudio,
}:

# pinned to python311Packages to to tree-sitter
# not supported for interpreter python3.12
python311Packages.buildPythonApplication rec {
  pname = "aider";
  version = "0.47.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "refs/tags/v${version}";
    hash = "sha256-kDGmP6X59H0nGPChSTiOBTbnJS3NRQqywjpo9qoB/rg=";
  };

  build-system = with python311Packages; [ setuptools ];

  dependencies = with python311Packages; [
    aiohttp
    aiosignal
    annotated-types
    anyio
    attrs
    backoff
    beautifulsoup4
    certifi
    cffi
    charset-normalizer
    click
    configargparse
    diff-match-patch
    diskcache
    distro
    filelock
    flake8
    frozenlist
    fsspec
    gitdb
    gitpython
    grep-ast
    h11
    httpcore
    httpx
    huggingface-hub
    idna
    importlib-metadata
    importlib-resources
    jinja2
    jsonschema
    jsonschema-specifications
    litellm
    markdown-it-py
    markupsafe
    mccabe
    mdurl
    multidict
    networkx
    numpy
    openai
    pathspec
    pillow
    prompt-toolkit
    pycodestyle
    pycparser
    pydantic
    pydantic-core
    pyflakes
    pygments
    pypandoc
    python-dotenv
    pyyaml
    referencing
    regex
    requests
    rich
    rpds-py
    scipy
    smmap
    sniffio
    sounddevice
    soundfile
    soupsieve
    tiktoken
    tokenizers
    tqdm
    tree-sitter-languages
    typing-extensions
    urllib3
    wcwidth
    yarl
    zipp
  ] ++ [ portaudio ];

  pythonRelaxDeps = [
    "anyio"
    "certifi"
    "filelock"
    "fsspec"
    "grep-ast"
    "huggingface-hub"
    "importlib-metadata"
    "jsonschema"
    "litellm"
    "networkx"
    "pillow"
    "pydantic"
    "pydantic-core"
    "referencing"
    "rpds-py"
    "scipy"
    "smmap"
  ];

  nativeCheckInputs = with python311Packages; [
    pytestCheckHook
    playwright
  ] ++ [ git ];

  disabledTestPaths = [
    # requires network
    "tests/scrape/test_scrape.py"

    # Expected 'mock' to have been called once
    "tests/help/test_help.py"
  ];

  disabledTests = [
    # requires network
    "test_urls"
    "test_get_commit_message_with_custom_prompt"

    # FileNotFoundError
    "test_get_commit_message"
    # "test_get_commit_message_strip_quotes"

    # Expected 'launch_gui' to have been called once
    "test_browser_flag_imports_streamlit"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "AI pair programming in your terminal";
    homepage = "https://github.com/paul-gauthier/aider";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ taha-yassine ];
    mainProgram = "aider";
  };
}
