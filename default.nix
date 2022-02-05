# Example from https://churchman.nl/2019/01/22/using-nix-to-create-python-virtual-environments/

{ pkgs ? import <nixpkgs> {}}:

with pkgs;
let
  my-python-packages = python-packages: [
    python-packages.pip
    python-packages.numpy
  ];
  my-python = python36.withPackages my-python-packages;
in
  pkgs.mkShell {
    buildInputs = [
      bashInteractive
      my-python
    ];
    shellHook = ''
      export PIP_PREFIX="$(pwd)/_build/pip_packages"
      export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.6/site-packages:$PYTHONPATH"
      unset SOURCE_DATE_EPOCH
    '';
  }
