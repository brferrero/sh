#/bin/bash

# ponto central
ponto_i=${1:-0}
ponto_j=${2:-0}

# raio da "bola"
raio=${3:-1}

# tamanho do nr de linhas
n=$(( 2 * ${raio} + 1 ))

# ponto central
meio=$(( $raio + 1 ))

cont=1
ii=${meio}
if=${meio}

for ((j=1;j<=${n};j++))
do
    for ((i=${ii};i<=${if};i++))
    do
        pj=$(( $j - $meio + ${ponto_j} ))
        pi=$(( $i - $meio + ${ponto_i} ))
        
        echo '('$pj , $pi')'
    done

    (( cont++ ))
    
    if [ $cont -le $meio ]
    then
        (( ii-- ))
        (( if++ ))
    else
        (( ii++ ))
        (( if-- ))
    fi
done
