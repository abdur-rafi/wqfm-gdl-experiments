#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 <model_condition_dir> <output_file> <true_tree_dir>"
    echo "Example: $0 /path/to/model_condition /path/to/output_file /path/to/true_tree_dir"
    exit 2
}

if [ "$#" -ne 3 ]; then
    usage
fi

model_cond_dir="$1"
out_file="$2"
true_tree_dir="$3"

if [ ! -d "$model_cond_dir" ]; then
    echo "Error: model condition directory not found: $model_cond_dir" >&2
    exit 1
fi


rf_score_script="./rfScoreCalculator/getFpFn.py"
tree_cleaner_script="./scripts/treeCleaner.py"
rf_score_averager_script="./scripts/rfAverager.py"

>$out_file

# Iterate over replicate directories inside the model condition folder
shopt -s nullglob
for rep_path in "$model_cond_dir"/*; do
    [ -d "$rep_path" ] || continue
    
    sp_rax_output_file="$rep_path/species_trees/inferred_species_tree.newick"
    sp_rax_output_file_cleaned="$rep_path/species_trees/inferred_species_tree_cleaned.newick"


    python "$tree_cleaner_script" --input "$sp_rax_output_file" --output "$sp_rax_output_file_cleaned"

    true_sp_tree_file="$true_tree_dir/$(basename "$rep_path")/s_tree-cleaned.tre"
    
    python "$rf_score_script" -t "$true_sp_tree_file" -e "$sp_rax_output_file_cleaned" >> "$out_file"
    
done

# Build averaged output filename by prefixing the base name with "avg_" in the same directory
out_dir="$(dirname "$out_file")"
out_base="$(basename "$out_file")"
avg_out_file="$out_dir/avg_${out_base}"

python "$rf_score_averager_script" --input "$out_file" --output "$avg_out_file"



echo "All replicates processed for model condition: $model_cond_dir"