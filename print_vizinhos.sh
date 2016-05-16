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
i_i=${meio}
i_f=${meio}

for ((j=1;j<=${n};j++))
do
    for ((i=${i_i};i<=${i_f};i++))
    do
        pj=$(( $j - $meio + ${ponto_j} ))
        pi=$(( $i - $meio + ${ponto_i} ))
        
        echo '('$pj , $pi')'
    done

    (( cont++ ))
    
    if [ $cont -le $meio ]
    then
        (( i_i-- ))
        (( i_f++ ))
    else
        (( i_i++ ))
        (( i_f-- ))
    fi
done
