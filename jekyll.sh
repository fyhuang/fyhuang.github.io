#!/bin/bash

set -exu

#JEKYLL_IMAGE=jekyll/jekyll:pages
JEKYLL_IMAGE=bretfisher/jekyll:latest

export PUID=1024
export PGID=100

docker run --rm \
    --mount type=bind,source="$(pwd)",target=/site \
    -it \
    -p 127.0.0.1:4000:4000 \
    $JEKYLL_IMAGE \
    "$@"
