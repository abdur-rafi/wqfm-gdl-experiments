#!/usr/bin/env bash
n=250
n=500
n=1000
fileName1="${n}-gt-wqfm-tree-pro-scores.txt"
fileName2=apro-3-scores.txt
fileName3="wqfm-tree-gdl-per-node-norm-fixed-scores.txt"

# default fileName (can be overridden with -f)
fileName=$fileName3

# writeTo default will be set after parsing flags so it can reflect -f
writeTo=""

usage() {
    echo "Usage: $0 [-f filename] [-w writeto]"
    echo "  -f  filename to read from each root (default: $fileName)"
    echo "  -w  output file to write aggregated scores to (default: Apro-scores/500bp-<filename>)"
    exit 1
}

# parse flags
while getopts ":f:w:h" opt; do
    case $opt in
        f) fileName="$OPTARG" ;;
        w) writeTo="$OPTARG" ;;
        h) usage ;;
        \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
    esac
done

# if writeTo not provided, use default based on fileName
if [ -z "$writeTo" ]; then
    writeTo="Apro-scores/500bp-$fileName"
fi

# prefix for paths under which the datasets live
astralpro_prefix="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/rf-scores"

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
    "n25/k1000/dup5/loss1/ils0"
    "n25/k1000/dup5/loss1/ils20"
    "n25/k1000/dup5/loss1/ils50"
    "n25/k1000/dup5/loss1/ils70"
    # "n25/k2500/dup5/loss1/ils70"
    # "n25/k10000/dup5/loss1/ils70"
)

mkdir -p "$(dirname "$writeTo")"
> "$writeTo"

for root in "${paths[@]}"; do
    echo "Processing $root"
    full_root="$astralpro_prefix/$root"
    if [ -d "$full_root" ]; then
        if [[ $root =~ (n25/.*) ]]; then
            id="${BASH_REMATCH[1]}"
            id="${id//\//-}"
            echo "$id" >> "$writeTo"
        else
            base=$(basename "$root")
            echo "$base" >> "$writeTo"
        fi
        target="$full_root/$fileName"
        if [ -f "$target" ]; then
            python ./scripts/scoreSep.py < "$target" >> "$writeTo"
        else
            echo "Warning: missing $target" >&2
        fi
    else
        echo "Warning: root not found: $full_root" >&2
    fi
done


# PREFIX=/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/rf-scores

# bash s25-scripts/collect.sh -f e100_apro-cleaned-rf-scores.txt  -w "$PREFIX/e100_apro-cleaned-rf-scores.txt"
# bash s25-scripts/collect.sh -f e100_duploss2_unrooted_tree_only_rf_scores.txt -w "$PREFIX/e100_duploss2_unrooted_tree_only_rf_scores.txt"
# bash s25-scripts/collect.sh -f e100_species_rax_rf_scores.txt  -w "$PREFIX/e100_species_rax_rf_scores.txt"
# bash s25-scripts/collect.sh -f e100-wqfm-2020-rf-scores.txt   -w "$PREFIX/e100-wqfm-2020-rf-scores.txt"
# bash s25-scripts/collect.sh -f e100-wqfm-gdl-per-node-norm-fixed-rf-scores.txt -w "$PREFIX/e100-wqfm-gdl-per-node-norm-fixed-rf-scores.txt"

# bash s25-scripts/collect.sh -f e500_apro-cleaned-rf-scores.txt  -w "$PREFIX/e500_apro-cleaned-rf-scores.txt"
# bash s25-scripts/collect.sh -f e500_duploss2_unrooted_tree_only_rf_scores.txt -w "$PREFIX/e500_duploss2_unrooted_tree_only_rf_scores.txt"
# bash s25-scripts/collect.sh -f e500_species_rax_rf_scores.txt  -w "$PREFIX/e500_species_rax_rf_scores.txt"
# bash s25-scripts/collect.sh -f e500-wqfm-2020-rf-scores.txt   -w "$PREFIX/e500-wqfm-2020-rf-scores.txt"
# bash s25-scripts/collect.sh -f e500-wqfm-gdl-per-node-norm-fixed-rf-scores.txt -w "$PREFIX/e500-wqfm-gdl-per-node-norm-fixed-rf-scores.txt"
