{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, importlib-metadata
, packaging
# Check Inputs
, pytestCheckHook
, pytest-subtests
, numpy
, matplotlib
, uncertainties
}:

buildPythonPackage rec {
  pname = "pint";
  version = "0.19.2";

  src = fetchPypi {
    inherit version;
    pname = "Pint";
    sha256 = "sha256-4dSYn/UQs3ja1k+RcR572r5cp411sGoYVprEVGeMS68=";
  };

  disabled = pythonOlder "3.6";

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ packaging ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # Test suite explicitly requires pytest
  checkInputs = [
    pytestCheckHook
    pytest-subtests
    numpy
    matplotlib
    uncertainties
  ];
  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    description = "Physical quantities module";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
    maintainers = with maintainers; [ costrouc doronbehar ];
  };

}
