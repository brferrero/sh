#!/bin/bash

# nome do processo monitorado
PROCESSO='zumbi.sh'

# pid do processo monitorado
pidcheck=$(pgrep ${PROCESSO})
echo ${pidcheck}

while :
do
    sleep 1
    
    # conta o numero de his_*.nc
    ncfiles=`ls his_*.nc | wc -l`
    
    if [ "$ncfiles" -gt "1" ]; 
    then
        MVFILE=`ls -1 his_0*.nc |head -1`
        echo "Opa! vou mover o arquivo: " ${MVFILE}
        echo "mv $MVFILE ../diretorio/. "
    else
        echo "nao vou fazer nada!" 
    fi
    
    pidcheck=$(pgrep ${PROCESSO})
    if [ -z "${pidcheck}" ];
    then
        echo "acabou o processo! To caindo fora!" 
        break
    fi
done

