{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # python
    poetry
    python3Packages.jedi-language-server
    # rust
    cargo
    rust-analyzer
    # go
    go
    gopls
    # other
    bump2version
    j2cli
    sqlite
  ];
}
