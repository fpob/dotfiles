{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = [ %HERE% ];
}
