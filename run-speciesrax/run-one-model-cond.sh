#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 <model_condition_dir> <output_dir>"
    echo "Example: $0 /path/to/model_condition /path/to/output_dir"
    exit 2
}

if [ "$#" -ne 2 ]; then
    usage
fi

model_cond_dir="$1"
out_dir="$2"

if [ ! -d "$model_cond_dir" ]; then
    echo "Error: model condition directory not found: $model_cond_dir" >&2
    exit 1
fi

if [ ! -d "$out_dir" ]; then
    echo "Error: output directory not found: $out_dir" >&2
    exit 1
fi

# Determine script directory and path to the per-replicate runner
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
replicate_script="$script_dir/run-one-replicate.sh"

if [ ! -f "$replicate_script" ]; then
    echo "Error: run-one-replicate.sh not found: $replicate_script" >&2
    exit 1
fi

# Iterate over replicate directories inside the model condition folder
shopt -s nullglob
for rep_path in "$model_cond_dir"/*; do
    [ -d "$rep_path" ] || continue
    rep_name="$(basename "$rep_path")"

    families_file="$rep_path/families-file.txt"
    out_prefix="$out_dir/$rep_name"

    mkdir -p "$out_prefix"

    if [ ! -f "$families_file" ]; then
        echo "Warning: families file not found for replicate $rep_name, skipping: $families_file"
        continue
    fi

    echo "Running GeneRax for replicate: $rep_name"
    bash "$replicate_script" "$families_file" "$out_prefix"
done

echo "All replicates processed for model condition: $model_cond_dir"