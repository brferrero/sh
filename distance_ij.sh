#!/bin/bash
GRIDNAME=$1
SECTION=$2

more ${GRIDNAME}_ij_grade_${SECTION}.dat |grep -e XMOUSE| awk '{print $6}' >x.dat
more ${GRIDNAME}_ij_grade_${SECTION}.dat |grep -e YMOUSE| awk '{print $6}' >y.dat

SAIDA1=${GRIDNAME}_dij_${SECTION}.dat
SAIDA2=${GRIDNAME}_dtrans_${SECTION}.dat
SAIDA3=${GRIDNAME}_dd_${SECTION}.dat

rm -f $SAIDA1
rm -f $SAIDA2
rm -f $SAIDA3

touch $SAIDA1
touch $SAIDA2
touch $SAIDA3

printf "{" >>$SAIDA2

VARX=( `cat x.dat` )
VARY=( `more y.dat` )
TRIPA=''
#rm -f x.dat y.dat
sz=$(( ${#VARX[@]} -1 ))
for ((i=0;i<${sz};i++))
do
    j=`echo ${VARX[$i]}`
    l=`echo ${VARY[$i]}`

    x1=`printf "%.4f "  $j` 
    y1=`printf  "%.4f\n" $l`
    
    j=`echo ${VARX[$(($i+1))]}`
    l=`echo ${VARY[$(($i+1))]}`
    
    x2=`printf "%.4f "  $j` 
    y2=`printf  "%.4f\n" $l`

    if [ $i -eq 0 ]
        then
        dist=0.0
    else
        #sqrt ((x2-x1)^2 + (y2-y1^2))
        x=$(( $x2 - $x1 ))
        y=$(( $y2 - $y1 ))
        nova=`echo "scale = 3; sqrt($x*$x + $y*$y)" | bc`
        #echo $x $y $nova
        dist=`echo "${dist}+${nova}" |bc`
        #echo $dist

    fi
	#dist=`printf "%.2f" $dist`
	printf "%.2f," $dist >>${SAIDA2}
	short_dist=`printf "%.4f" $dist`
	#TRIPA=${TRIPA},${dist}
    	echo $x1  $y1  $short_dist >> $SAIDA1
    	echo $short_dist >> $SAIDA3
	
done
sed 's/,$/\}/g' ${SAIDA2} > caca
more caca > $SAIDA2
rm -f caca

EIXO=`more $SAIDA2`
export EIXO
#echo $EIXO
#echo $TRIPA >$SAIDA2
