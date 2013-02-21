#! /bin/bash

# Generate a random image

WIDTH=${1}
HEIGHT=${2}
OUTPUT=${3}

PPM=/tmp/rndimg-${RANDOM}.ppm

# Create ppm
./writeppm $WIDTH $HEIGHT $PPM

# Convert to output
convert $PPM $OUTPUT

# delete tempfile
rm -f $PPM
