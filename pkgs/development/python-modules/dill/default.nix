{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.3.5.1";
  doCheck = !isPy27;

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = pname;
    rev = "refs/tags/dill-${version}";
    sha256 = "sha256-gWE7aQodblgHjUqGAzOJGgxJ4qx9wHo/DU4KRE6JMWo=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  # Tests seem to fail because of import pathing and referencing items/classes in modules.
  # Seems to be a Nix/pathing related issue, not the codebase, so disabling failing tests.
  disabledTestPaths = [
    "tests/test_diff.py"
    "tests/test_module.py"
    "tests/test_objects.py"
  ];

  disabledTests = [
    "test_class_objects"
    "test_method_decorator"
    "test_importable"
    "test_the_rest"
  ];

  pythonImportsCheck = [ "dill" ];

  meta = with lib; {
    description = "Serialize all of python (almost)";
    homepage = "https://github.com/uqfoundation/dill/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
