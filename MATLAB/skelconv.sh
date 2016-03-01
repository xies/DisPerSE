$!/bin/bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

ccc="/scratch/libs/disperse/bin/skelconv $1"
echo $ccc
$ccc

exit
