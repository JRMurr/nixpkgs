{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, atomicwrites
, chardet
, cloudpickle
, cookiecutter
, diff-match-patch
, flake8
, intervaltree
, jedi
, jellyfish
, keyring
, matplotlib
, mccabe
, nbconvert
, numpy
, numpydoc
, psutil
, pygments
, pylint
, pylint-venv
, pyls-spyder
, pyopengl
, pyqtwebengine
, python-lsp-black
, python-lsp-server
, pyxdg
, pyzmq
, pycodestyle
, qdarkstyle
, qstylizer
, qtawesome
, qtconsole
, qtpy
, rope
, Rtree
, scipy
, spyder-kernels
, textdistance
, three-merge
, watchdog
}:

buildPythonPackage rec {
  pname = "spyder";
  version = "5.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kQBOYRXhjz+OQk7Vlxb/UKiDi92mA8ialsFQ+QzqhlE=";
  };

  patches = [
    ./dont-clear-pythonpath.patch
  ];

  nativeBuildInputs = [
    pyqtwebengine.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    atomicwrites
    chardet
    cloudpickle
    cookiecutter
    diff-match-patch
    intervaltree
    jedi
    jellyfish
    keyring
    matplotlib
    nbconvert
    numpy
    numpydoc
    psutil
    pygments
    pylint-venv
    pyls-spyder
    pyopengl
    pyqtwebengine
    python-lsp-black
    python-lsp-server
    pyxdg
    pyzmq
    qdarkstyle
    qstylizer
    qtawesome
    qtconsole
    qtpy
    rope
    Rtree
    scipy
    spyder-kernels
    textdistance
    three-merge
    watchdog
  ] ++ python-lsp-server.optional-dependencies.all;

  # There is no test for spyder
  doCheck = false;

  postPatch = ''
    # Remove dependency on pyqtwebengine
    # This is still part of the pyqt 5.11 version we have in nixpkgs
    sed -i /pyqtwebengine/d setup.py
    substituteInPlace setup.py \
      --replace "qdarkstyle>=3.0.2,<3.1.0" "qdarkstyle" \
      --replace "ipython>=7.31.1,<8.0.0" "ipython"
  '';

  postInstall = ''
    # Add Python libs to env so Spyder subprocesses
    # created to run compute kernels don't fail with ImportErrors
    wrapProgram $out/bin/spyder --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Scientific python development environment";
    longDescription = ''
      Spyder (previously known as Pydee) is a powerful interactive development
      environment for the Python language with advanced editing, interactive
      testing, debugging and introspection features.
    '';
    homepage = "https://www.spyder-ide.org/";
    downloadPage = "https://github.com/spyder-ide/spyder/releases";
    changelog = "https://github.com/spyder-ide/spyder/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.linux;
  };
}
