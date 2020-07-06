#!/bin/sh

npm run build-backend
ops run app/backend/target/release/backend --config nanovm_config.json
