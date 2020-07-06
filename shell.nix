  { pkgs ? import <nixpkgs> {}, unstable ? import <nixos-unstable> {} }:
  pkgs.mkShell {
    buildInputs = with pkgs; [
      nodejs
      pkg-config
      openssl
      go
      postgresql
      rustup
    ];
    shellHook = ''
      export HISTFILE=${toString ./.history}
      export PATH=$PATH:~/.cargo/bin
      export GOPATH=~/go
      '';
  }
