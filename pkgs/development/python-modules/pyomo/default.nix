{ lib
, buildPythonPackage
, fetchFromGitHub
, parameterized
, ply
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyomo";
  version = "6.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "pyomo";
    owner = "pyomo";
    rev = "refs/tags/${version}";
    hash = "sha256-ZsoWz+35hQS15dbpe1IOzft6JwZygKjv5AQWjVe+8kQ=";
  };

  propagatedBuildInputs = [
    ply
  ];

  nativeCheckInputs = [
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyomo"
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTestPaths = [
    # Don't test the documentation and the examples
    "doc/"
    "examples/"
    # Tests don't work properly in the sandbox
    "pyomo/environ/tests/test_environ.py"
  ];

  disabledTests = [
    # Test requires lsb_release
    "test_get_os_version"
  ];

  meta = with lib; {
    description = "Python Optimization Modeling Objects";
    homepage = "http://pyomo.org";
    changelog = "https://github.com/Pyomo/pyomo/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
