{
  lib,
  elfutils,
  buildPythonPackage,
  cython,
  distutils,
  fetchFromGitHub,
  greenlet,
  ipython,
  jinja2,
  libunwind,
  pkgs,
  pkg-config,
  pkgconfig,
  pytest-cov-stub,
  pytest-textual-snapshot,
  pytestCheckHook,
  pythonOlder,
  rich,
  setuptools,
  textual,
}:

buildPythonPackage (finalAttrs: {
  pname = "memray";
  version = "1.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "memray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RdOtgNSkFIVl8Uve2iaJ7G0X1IHJ/Yo4h8hWP3pTV8g=";
  };

  build-system = [
    distutils
    setuptools
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    elfutils # for `-ldebuginfod`
    libunwind
    pkgs.lz4
  ]
  ++ [ cython ];

  dependencies = [
    pkgconfig
    textual
    jinja2
    rich
  ];

  nativeCheckInputs =
    [
      ipython
      pytest-cov-stub # fix Unknown pytest.mark.no_cover
      pytest-textual-snapshot
      pytestCheckHook
    ]
    ++ lib.optionals (pythonOlder "3.14") [ greenlet ];

  pythonImportsCheck = [ "memray" ];

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # Import issue
    "test_header_allocator"
    "test_hybrid_stack_of_allocations_inside_ceval"

    # The following snapshot tests started failing since updating textual to 3.5.0
    "TestTUILooks"
    "test_merge_threads"
    "test_tui_basic"
    "test_tui_gradient"
    "test_tui_pause"
    "test_unmerge_threads"
  ];

  disabledTestPaths = [
    # Very time-consuming and some tests fails (performance-related?)
    "tests/integration/test_main.py"
  ];

  meta = {
    description = "Memory profiler for Python";
    homepage = "https://bloomberg.github.io/memray/";
    changelog = "https://github.com/bloomberg/memray/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
})
