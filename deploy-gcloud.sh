#!/bin/sh

export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/tagify-key.json
export GOOGLE_CLOUD_PROJECT=tagify-281610
export GOOGLE_CLOUD_ZONE=europe-west3-a
npm run build-backend
ops image delete backend-image
set -xe
ops image create -a app/backend/target/release/backend -c nanovm_config.json backend-image
ops instance create -c nanovm_config.json -i backend-image

ops instance list
echo  "$ ops instance logs"
