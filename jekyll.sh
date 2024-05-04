#!/bin/bash

JEKYLL_VERSION=pages
docker run --rm \
    --mount type=bind,source="$(pwd)",target=/srv/jekyll \
    -it \
    jekyll/jekyll:$JEKYLL_VERSION \
    jekyll "$@"