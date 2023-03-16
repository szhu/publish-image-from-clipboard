#!/bin/sh

set -e

verbose() {
  echo >&2 $ "$@"
  "$@"
}

# Grab image from clipboard.
verbose pngpaste update/pasteboard.png

# Resize the image to fit inside 800x480, padding with black.
verbose rsvg-convert update/index.gen.svg >index.png

# Deploy.
verbose vercel --prod
