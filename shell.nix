  { pkgs ? import <nixpkgs> {}, unstable ? import <nixos-unstable> {} }:
  pkgs.mkShell {
    buildInputs = with pkgs; [
      nodejs
      postgresql
      rustup
    ];
    shellHook = ''
      export HISTFILE=${toString ./.history}
      export PATH=$PATH:~/.cargo/bin
      '';
  }
