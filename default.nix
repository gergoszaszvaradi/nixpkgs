{ pkgs ? import <nixpkgs> {} }:

let
  mixxx = import ./pkgs/mixxx.nix { inherit pkgs; };
in
{
  inherit mixxx;
}
