#!/usr/bin/env bash
#
# 
# yearly mean from monthtly timesteps 
# remap list of nc files 
#

# input directory 
INPUT_DIR='/chuva/db2/CESM-LENS/fully_coupled/mon/pop/SSH/BRCP85C5CNBDRD'
# input file
INPUT_FILE='b.e11.BRCP85C5CNBDRD.f09_g16.007.pop.h.SSH.208101-210012.nc'

# output dir
OUTPUT_DIR='.'

# create yearly mean files (true); else (false)
YRMEAN=true

# set a 1x1 degrees regular grid with lon = 0 to 359 and lat = -89.5 to 89.5:
MODELNAME='CESM'
GRID_INFO='r360x180'
WEIGHTS_FILE='weights_'${MODELNAME}'_'${GRID_INFO}'.nc'

#******************************************************************************
#******************************************************************************

# create interp weight file 
if [ ! -f ${WEIGHTS_FILE} ]; then
    echo "Creating weights file ..."
    cdo genbil,${GRID_INFO} ${INPUT_DIR}/${INPUT_FILE} ${WEIGHTS_FILE}
fi

# list of files
FILELIST=$(ls ${INPUT_DIR}/*.nc)

# regrid and yearmean (optional) each file
for f in ${FILELIST}; do
    INPUT_FILE=$(basename $f)    
    if [ "$YRMEAN" = true ] ; then
    # year mean and remap 
        OUTPUT_FILE=$(sed 's/'.nc'/'_yr_remap.nc'/g' <<< ${INPUT_FILE})
        echo "Remaping (yearmean) " ${OUTPUT_FILE}  
        # year mean (yearmean doesnt work with CESM history files)
        # cdo -f nc4 yearmean ${INPUT_DIR}/${INPUT_FILE}  ${OUTPUT_DIR}/year_${OUTPUT_FILE} 
        NTIME=$(cdo ntime ${INPUT_DIR}/${INPUT_FILE})
        FCOUNT=1
        for i in $(seq 1 12 ${NTIME}); do
            TMPNAME=$(printf "%04d" $FCOUNT)
            #echo $TMPNAME
            tf=$(( $i + 11 ))
            # select 12 months and perform time mean
            cdo -f nc4 timmean -seltimestep,${i}/${tf} ${INPUT_DIR}/${INPUT_FILE} tmp_file_${TMPNAME}.nc
            (( FCOUNT++ ))
        done
        # cat all yearly files
        cdo -f nc4 cat tmp_file_0*.nc ${OUTPUT_DIR}/year_${OUTPUT_FILE} 
        rm -f tmp_file_0*.nc

        # remap
        cdo -P 4 -f nc4 -z zip_4 remap,${GRID_INFO},${WEIGHTS_FILE} ./year_${OUTPUT_FILE} ${OUTPUT_DIR}/${OUTPUT_FILE} 
        rm -f  ${OUTPUT_DIR}/year_${OUTPUT_FILE}
    else
    # remap    
        OUTPUT_FILE=$(sed 's/'.nc'/'_remap.nc'/g' <<< ${INPUT_FILE})
        echo "Remaping " ${OUTPUT_FILE}  
        cdo -P 4 -f nc4 -z zip_4 remap,${GRID_INFO},${WEIGHTS_FILE} ${INPUT_DIR}/${INPUT_FILE}  ${OUTPUT_DIR}/${OUTPUT_FILE} 
    fi
done

