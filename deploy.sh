#!/usr/bin/env bash

HOST="tagify"

rsync --delete --delete-excluded --inplace -Pav -e "ssh -i $HOME/.ssh/id_rsa -F $HOME/.ssh/config"\
    --dirs "$PWD/nixos/"* \
    --exclude-from .gitignore \
    --exclude .git \
    $HOST:/etc/nixos

ssh $HOST nixos-rebuild switch
