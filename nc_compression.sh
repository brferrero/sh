#!/usr/bin/env bash
#
# compress a list of netcdf files using minimal deflation {'1' : ~60% compression}
#

MATCH=$1

FILELIST=$(ls *${MATCH}*.nc)

if [ ! -z "$FILELIST" ]
then
    for f in ${FILELIST}
    do
        echo "Compressing " ${f} "..." 
        echo ncks -4 --deflate 1 -O ${f} ${f}
    done
else
    echo "No file to compress"
fi
