#!/usr/bin/env bash
#
# compress a list of netcdf files using minimal deflation {'1' : ~60% compression}
#

for f in $(ls *.nc)
do
    echo "Compressing " ${f} "..." 
    ncks -4 --deflate 1 -O ${f} ${f}
done
