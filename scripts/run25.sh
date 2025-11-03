#!/bin/bash
# bash scripts/run25.sh >> log.log

# Define an array with directories
paths=(
    # "../AstralPro/n25/k1000/dup0/loss0/ils0"
    # "../AstralPro/n25/k1000/dup0/loss0/ils20"
    # "../AstralPro/n25/k1000/dup0/loss0/ils50"
    # "../AstralPro/n25/k1000/dup0/loss0/ils70"
    # "../AstralPro/n25/k1000/dup0.2/loss0/ils70"
    # "../AstralPro/n25/k1000/dup0.2/loss0.1/ils70"
    # "../AstralPro/n25/k1000/dup0.2/loss0.5/ils70"
    # "../AstralPro/n25/k1000/dup0.2/loss1/ils70"
    # "../AstralPro/n25/k1000/dup1/loss0/ils70"
    # "../AstralPro/n25/k1000/dup1/loss0.1/ils70"
    # "../AstralPro/n25/k1000/dup1/loss0.5/ils70"
    # "../AstralPro/n25/k1000/dup1/loss1/ils0"
    # "../AstralPro/n25/k1000/dup1/loss1/ils20"
    # "../AstralPro/n25/k1000/dup1/loss1/ils50"
    # "../AstralPro/n25/k1000/dup1/loss1/ils70"
    # "../AstralPro/n25/k1000/dup2/loss0/ils70"
    # "../AstralPro/n25/k1000/dup2/loss0.1/ils70"
    # "../AstralPro/n25/k1000/dup2/loss0.5/ils70"
    # "../AstralPro/n25/k1000/dup2/loss1/ils70"
    # "../AstralPro/n25/k1000/dup5/loss0/ils70"
    # "../AstralPro/n25/k1000/dup5/loss0.1/ils70"
    # "../AstralPro/n25/k1000/dup5/loss0.5/ils70"
    # "../AstralPro/n25/k1000/dup5/loss1/ils0"/
    # "../AstralPro/n25/k1000/dup5/loss1/ils20"
    "../AstralPro/n25/k1000/dup5/loss1/ils50"
    # "../AstralPro/n25/k1000/dup5/loss1/ils70"
    # "../AstralPro/n25/k2500/dup5/loss1/ils70"
    # "../AstralPro/n25/k10000/dup5/loss1/ils70"
)

# Iterate over the array
for path in "${paths[@]}"; do
    echo "Processing: $path"
    # bash scripts/cleangt.sh $path 5
    bash scripts/runDisco.sh $path 5
    # Add your command here, e.g., cd "$path" or run a script in that directory
done
