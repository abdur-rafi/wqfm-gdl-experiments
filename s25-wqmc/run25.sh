#!/bin/bash
# bash scripts/run25.sh >> log.log
copyto="./wqmc-outputs"
n=5
wqmcscores="${n}-wqmc-scores.txt"

# root="../AstralPro"
root="s25-wqmc/wqmc-scores"

writeTo="s25-wqmc/collect-scores/$wqmcscores"

mkdir -p $(dirname $writeTo)

# Define an array with directories
paths=(
    "n25/k1000/dup0/loss0/ils0"
    "n25/k1000/dup0/loss0/ils20"
    "n25/k1000/dup0/loss0/ils50"
    "n25/k1000/dup0/loss0/ils70"
    "n25/k1000/dup0.2/loss0/ils70"
    "n25/k1000/dup0.2/loss0.1/ils70"
    "n25/k1000/dup0.2/loss0.5/ils70"
    "n25/k1000/dup0.2/loss1/ils70"
    "n25/k1000/dup1/loss0/ils70"
    "n25/k1000/dup1/loss0.1/ils70"
    "n25/k1000/dup1/loss0.5/ils70"
    "n25/k1000/dup1/loss1/ils0"
    "n25/k1000/dup1/loss1/ils20"
    "n25/k1000/dup1/loss1/ils50"
    "n25/k1000/dup1/loss1/ils70"
    "n25/k1000/dup2/loss0/ils70"
    "n25/k1000/dup2/loss0.1/ils70"
    "n25/k1000/dup2/loss0.5/ils70"
    "n25/k1000/dup2/loss1/ils70"
    "n25/k1000/dup5/loss0/ils70"
    "n25/k1000/dup5/loss0.1/ils70"
    "n25/k1000/dup5/loss0.5/ils70"
    "n25/k1000/dup5/loss1/ils0"/
    "n25/k1000/dup5/loss1/ils20"
    "n25/k1000/dup5/loss1/ils50"
    "n25/k1000/dup5/loss1/ils70"
    "n25/k2500/dup5/loss1/ils70"
    "n25/k10000/dup5/loss1/ils70"
)

# Iterate over the array
# mkdir -p $copyto
for path in "${paths[@]}"; do
    echo "Processing: $path"

    # mkdir -p $copyto/$path
    # bash scripts/cleangt.sh $root/$path 1
    # bash scripts/runDisco.sh $root/$path 5
    # Add your command here, e.g., cd "$path" or run a script in that directory
    # cp $root/$path/$wqmcscores $copyto/$path
    echo "$root/$path/$wqmcscores"
    
    echo $path >> $writeTo
    
    python ./scripts/scoreSep.py < $root/$path/$wqmcscores >> $writeTo

done
