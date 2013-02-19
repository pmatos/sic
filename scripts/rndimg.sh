#! /bin/bash

source random-between.sh

# Generate a random image

WIDTH=${1}
HEIGHT=${2}
OUTPUT=${3}

PPM=$(tempfile).ppm

# Create ppm
echo "P3" > $PPM
echo $WIDTH >> $PPM
echo $HEIGHT >> $PPM
echo 255 >> $PPM

for row in $(seq 1 $HEIGHT); do
    for col in $(seq 1 $WIDTH); do
	for colour in $(seq 1 3); do
	    randomBetween 0 255 1
	    echo -n $randomBetweenAnswer " " >> $PPM
	done
	echo -n " " >> $PPM
    done
    echo >> $PPM
done

# Convert to output
convert $PPM $OUTPUT
