#!/usr/bin/env bash
n=250
n=500
n=1000
fileName1="${n}-gt-wqfm-tree-pro-scores.txt"
fileName2=apro-3-scores.txt
fileName3="wqfm-tree-gdl-per-node-norm-fixed-scores.txt"

fileName=$fileName3

writeTo=Apro-scores/500bp-$fileName

paths=(
    "../AstralPro/n25/k1000/dup0/loss0/ils0"
    "../AstralPro/n25/k1000/dup0/loss0/ils20"
    "../AstralPro/n25/k1000/dup0/loss0/ils50"
    "../AstralPro/n25/k1000/dup0/loss0/ils70"
    "../AstralPro/n25/k1000/dup0.2/loss0/ils70"
    "../AstralPro/n25/k1000/dup0.2/loss0.1/ils70"
    "../AstralPro/n25/k1000/dup0.2/loss0.5/ils70"
    "../AstralPro/n25/k1000/dup0.2/loss1/ils70"
    "../AstralPro/n25/k1000/dup1/loss0/ils70"
    "../AstralPro/n25/k1000/dup1/loss0.1/ils70"
    "../AstralPro/n25/k1000/dup1/loss0.5/ils70"
    "../AstralPro/n25/k1000/dup1/loss1/ils0"
    "../AstralPro/n25/k1000/dup1/loss1/ils20"
    "../AstralPro/n25/k1000/dup1/loss1/ils50"
    "../AstralPro/n25/k1000/dup1/loss1/ils70"
    "../AstralPro/n25/k1000/dup2/loss0/ils70"
    "../AstralPro/n25/k1000/dup2/loss0.1/ils70"
    "../AstralPro/n25/k1000/dup2/loss0.5/ils70"
    "../AstralPro/n25/k1000/dup2/loss1/ils70"
    "../AstralPro/n25/k1000/dup5/loss0/ils70"
    "../AstralPro/n25/k1000/dup5/loss0.1/ils70"
    "../AstralPro/n25/k1000/dup5/loss0.5/ils70"
    "../AstralPro/n25/k1000/dup5/loss1/ils0"
    "../AstralPro/n25/k1000/dup5/loss1/ils20"
    "../AstralPro/n25/k1000/dup5/loss1/ils50"
    "../AstralPro/n25/k1000/dup5/loss1/ils70"
    "../AstralPro/n25/k2500/dup5/loss1/ils70"
    "../AstralPro/n25/k10000/dup5/loss1/ils70"
)

mkdir -p "$(dirname "$writeTo")"
> "$writeTo"

for root in "${paths[@]}"; do
    if [ -d "$root" ]; then
        if [[ $root =~ (n25/.*) ]]; then
            id="${BASH_REMATCH[1]}"
            id="${id//\//-}"
            echo "$id" >> "$writeTo"
        else
            base=$(basename "$root")
            echo "$base" >> "$writeTo"
        fi
        target="$root/$fileName"
        if [ -f "$target" ]; then
            python ./scripts/scoreSep.py < "$target" >> "$writeTo"
        else
            echo "Warning: missing $target" >&2
        fi
    else
        echo "Warning: root not found: $root" >&2
    fi
done
