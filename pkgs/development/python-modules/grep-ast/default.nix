{
  buildPythonPackage,
  fetchPypi,
  lib,

  pathspec,
  pytestCheckHook,
  setuptools,
  tree-sitter-languages,
}:

buildPythonPackage rec {
  pname = "grep-ast";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "grep_ast";
    hash = "sha256-QriIfVcwHcVWNDaPjVSenEnJE9r7TRnJtUw922BPzPQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    tree-sitter-languages
    pathspec
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "grep_ast" ];

  meta = {
    description = "Tool to grep through the AST of a source file";
    homepage = "https://github.com/paul-gauthier/grep-ast";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ greg taha-yassine sigmanificient ];
    mainProgram = "grep-ast";
  };
}
