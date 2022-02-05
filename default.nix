{
  pkgs ? import <nixpkgs> {},
  system ? builtins.currentSystem,

  # dependencies
  bash ? pkgs.bash,
  findutils ? pkgs.findutils,
  virtualenv ? pkgs.python38Packages.virtualenv,

  # other
  upperconstraints ? builtins.fetchurl "https://raw.githubusercontent.com/sapcc/requirements/stable/ussuri-m3/upper-constraints.txt",
}:

with pkgs;
derivation {
  name = "octavia-virtualenv";
  inherit system;
  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];

  # builder env
  inherit bash coreutils findutils upperconstraints virtualenv;
  octavia = ./octavia;
  f5pd = ./octavia-f5-provider-driver;
}
