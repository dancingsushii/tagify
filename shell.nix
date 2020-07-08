  { pkgs ? import <nixpkgs> {}, unstable ? import <nixos-unstable> {} }:
  pkgs.mkShell {
    buildInputs = with pkgs; [
      nodejs
      pkg-config
      openssl
      go
      postgresql
      glibc.static
      glibc_multi.out
      wrk
      rustup
    ];
    shellHook = ''
      export HISTFILE=${toString ./.history}
      export PATH=$PATH:~/.cargo/bin
      export GOPATH=~/go
      export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/tagify-key.json
      export GOOGLE_CLOUD_PROJECT=tagify-281610
      export GOOGLE_CLOUD_ZONE=europe-west3-a
      '';
  }
