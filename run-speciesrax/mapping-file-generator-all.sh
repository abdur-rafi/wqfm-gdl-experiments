
#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 <root_dir> <out_dir>"
    echo "Example: $0 /path/to/simulations /path/to/output"
    exit 2
}

if [ "$#" -ne 2 ]; then
    usage
fi

root_dir=$1
out_dir=$2

if [ ! -d "$root_dir" ]; then
    echo "Error: root_dir not found or not a directory: $root_dir" >&2
    exit 1
fi

# Create top-level output dir if it doesn't exist (we will create per-model dirs inside)
mkdir -p "$out_dir"

# List of model conditions to process
model_conditions=(
        sim200_dup3_loss1
        sim200_dup0_ILS70
        sim500_dup1_loss0.1
        sim200_dup1_ILS25
        sim500_dup0.25_loss0.1
        sim500_dup1_loss1
        sim200_dup1_loss0.1
        sim500_dup0.25_loss1
        sim500_dup3_ILS25
        sim200_dup0.25_loss0.1
        sim200_dup1_loss1
        sim500_dup0_ILS25
        sim500_dup3_loss0.1
        sim200_dup0.25_loss1
        sim200_dup3_ILS25
        sim500_dup0_ILS70
        sim500_dup3_loss1
        sim200_dup0_ILS25
        sim200_dup3_loss0.1
        sim500_dup1_ILS25
)

# Determine script directory and path to the model-condition generator
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
model_cond_script="$script_dir/mapping-file-generator-one-model-cond.sh"

if [ ! -f "$model_cond_script" ]; then
    echo "Error: model-condition generator script not found: $model_cond_script" >&2
    exit 1
fi

for model_cond in "${model_conditions[@]}"; do
    model_cond_path="$root_dir/$model_cond"

    if [ ! -d "$model_cond_path" ]; then
        echo "Warning: model condition folder not found, skipping: $model_cond_path"
        continue
    fi

    out_model_dir="$out_dir/$model_cond"
    # Create per-model output directory (required by the model-cond script)
    mkdir -p "$out_model_dir"

    echo "Processing model condition: $model_cond"
    bash "$model_cond_script" "$model_cond_path" "$out_model_dir"
done

echo "All model conditions processed. Outputs under: $out_dir"
