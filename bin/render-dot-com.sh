#!/bin/bash

set -e -u -x -o pipefail

# Stolen from https://community.render.com/t/how-to-define-hugo-version/390/8
# In your Render dashboard, set the HUGO_VERSION env var for your static site. You'll get the same experience as, say, Netlify.

TAR_NAME="hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz"

hugo version # Output the OLD version
if [[ ! -f $XDG_CACHE_HOME/hugo ]]; then
    echo "...Downloading HUGO"
    mkdir -p ~/tmp
    wget -P ~/tmp https://github.com/gohugoio/hugo/releases/download/v"$HUGO_VERSION/$TAR_NAME"
    cd ~/tmp || exit 1
    echo "...Extracting HUGO"
    tar -xzvf "$TAR_NAME"
    echo "...Moving HUGO"
    mv hugo "$XDG_CACHE_HOME/hugo"
    # Make sure we return to where we were.
    cd "$HOME/project/src"
else
    echo "...Using HUGO from build cache"
fi

"$XDG_CACHE_HOME/hugo" version

# Render sets IS_PULL_REQUEST to true for PR previews.
if [ "${IS_PULL_REQUEST:-}" = "true" ]; then
    $XDG_CACHE_HOME/hugo --gc --buildDrafts --buildFuture -e preview
else
    $XDG_CACHE_HOME/hugo --gc --minify
fi
