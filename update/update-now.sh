#!/bin/sh

set -e

verbose() {
  echo >&2 $ "$@"
  "$@"
}

# Grab image from clipboard.
verbose pngpaste update/pasteboard.png

BRIGHTNESS="$(verbose identify -format "%[fx:mean]" update/pasteboard.png)"
ADJUSTED_BRIGHTNESS="$(echo "(0.4 - $BRIGHTNESS) * 50" | bc)"
ABS_ADJUSTED_BRIGHTNESS="$(echo "$ADJUSTED_BRIGHTNESS" | sed 's/-//')"
echo "BRIGHTNESS=$BRIGHTNESS, ADJUSTED_BRIGHTNESS=$ADJUSTED_BRIGHTNESS"
verbose convert update/pasteboard.png \
  -brightness-contrast "${ADJUSTED_BRIGHTNESS}x${ABS_ADJUSTED_BRIGHTNESS}" \
  update/pasteboard.png \
  ;

# Resize the image to fit inside 800x480, padding with black.
verbose rsvg-convert update/index.gen.svg >index.png

# Convert to monochrome image.
# verbose convert index.png \
#   -ordered-dither checks \
#   -brightness-contrast 70x80 \
#   -remap pattern:gray50 \
#   -resize 800x480 \
#   index.png \
#   ;
verbose convert index.png \
  -ordered-dither checks \
  -remap pattern:gray50 \
  index.png \
  ;

# Deploy.
verbose vercel --prod
