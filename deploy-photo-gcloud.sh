#!/bin/sh

export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/tagify-key.json
export GOOGLE_CLOUD_PROJECT=tagify-281610
export GOOGLE_CLOUD_ZONE=europe-west3-a
go build app/go_photos_server/src/main.go -o app/go_photos_server/main
ops image delete go-photo-image
set -xe
ops image create -a app/go_photos_server -c nanovm_config_photo_server.json go-photo-image
ops instance create -c nanovm_config_photo_server.json -i go-photo-image

ops instance list
echo  "$ ops instance logs"
