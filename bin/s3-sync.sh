#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Bucket name required"
    exit 1
fi

SHORT_CACHE="--cache-control max-age=1800" # 30 minutes
LONG_CACHE="--cache-control max-age=2629800" # 1 month
ARGS="--acl public-read --delete --profile mdninteractive"
cd ../docs

for path in "pages live-examples"; do
    aws s3 sync $path s3://$1 ${SHORT_CACHE} ${ARGS}
done

for path in "css js"; do
    aws s3 sync $path s3://$1 --exclude '*' --include 'editor-*' ${SHORT_CACHE} ${ARGS}
    aws s3 sync $path s3://$1 --exclude 'editor-*' ${LONG_CACHE} ${ARGS}
done

aws s3 sync media s3://$1 ${LONG_CACHE} ${ARGS}
