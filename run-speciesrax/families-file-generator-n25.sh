#!/usr/bin/env bash
set -euo pipefail


usage() {
    echo "Usage: $0 <root_dir> <out_dir> <link_root>" >&2
    echo "Example: $0 /path/to/simulations /path/to/output /path/to/links" >&2
    exit 2
}

if [ "$#" -ne 3 ]; then
    usage
fi

root_dir=$1
out_dir=$2
link_root=$3

if [ ! -d "$root_dir" ]; then
    echo "Error: root_dir not found or not a directory: $root_dir" >&2
    exit 1
fi

# Ensure link_root exists (we'll create per-model link dirs inside)
mkdir -p "$link_root"

# Create top-level output dir if it doesn't exist (we will create per-model dirs inside)
mkdir -p "$out_dir"

# Model conditions copied from mapping-files-generator-n25.sh
model_conditions=(
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

# Determine script directory and path to the model-condition generator
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
model_cond_script="$script_dir/families-file-generator-one-model-cond.sh"

if [ ! -f "$model_cond_script" ]; then
    echo "Error: model-condition generator script not found: $model_cond_script" >&2
    exit 1
fi

for model_cond in "${model_conditions[@]}"; do
    # normalize remove trailing slash if any
    model_cond="${model_cond%/}"

    model_cond_path="$root_dir/$model_cond"

    if [ ! -d "$model_cond_path" ]; then
        echo "Warning: model condition folder not found, skipping: $model_cond_path"
        continue
    fi

    out_model_dir="$out_dir/$model_cond"
    # Create per-model output directory (required by the model-cond script)
    mkdir -p "$out_model_dir"

    # Corresponding link directory is expected to already exist under link_root
    link_dir="$link_root/$model_cond"
    if [ ! -d "$link_dir" ]; then
        echo "Warning: link directory missing, skipping model: $link_dir" >&2
        continue
    fi

    echo "Processing model condition: $model_cond"
    bash "$model_cond_script" "$model_cond_path" "$out_model_dir" "$link_dir"
done

echo "All model conditions processed. Outputs under: $out_dir"
