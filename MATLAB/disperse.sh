#!/bin/bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

ccc="/scratch/libs/disperse/bin/mse $1"
$ccc

exit

