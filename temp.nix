{ pkgs ? import <nixpkgs> {}, system ? builtins.currentSystem }:

with pkgs;
derivation {
  name = "temptest";
  builder = "${bash}/bin/bash";
  inherit system;

  # builder script args and env
  args = [ ./temp.sh ];
  virtualenv = python38Packages.virtualenv;
}
