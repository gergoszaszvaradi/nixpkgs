{ pkgs ? import <nixpkgs> {} }:
rec {
  mixxx = pkgs.callPackage ./pkgs/mixxx.nix {};
}
