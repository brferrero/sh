#!/bin/bash

FILEIN=${1:-animation.gif}
FILEOUT=${2:-animation.mp4}
FPS=10

# gif to frames
convert ${FILEIN} -trim -resize 664x764! frame_%04d.png

# frames to mp4
avconv -r ${FPS} -i frame_%04d.png -c:v libx264 -crf 10 ${FILEOUT}

# clean
rm -f frame_*.png
