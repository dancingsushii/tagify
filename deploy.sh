#!/usr/bin/env bash

set -e

HOST="tagify"

# if [ -f /etc/NIXOS ]; then
#     echo "Detected NIXOS machine"
#     echo "Building locally and then transfer build"
#     PKG=$(nix-build nixos/tagify-backend.nix --cores "$(nproc)")
#     nix-copy-closure --to "$HOST" "$PKG"
# fi

rsync --delete --delete-excluded --inplace -Pav -e "ssh -i $HOME/.ssh/id_rsa -F $HOME/.ssh/config"\
    --dirs "$PWD/nixos/"* \
    --exclude-from .gitignore \
    --exclude .git \
    $HOST:/etc/nixos

ssh $HOST "nixos-rebuild switch --cores $(nproc)"
