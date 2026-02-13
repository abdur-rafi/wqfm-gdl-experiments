#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 OUTPUT_BASE" >&2
  echo "Example: $0 /path/to/output_base" >&2
  exit 2
}

if [ "$#" -ne 1 ]; then
  usage
fi

OUT_BASE="$1"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAPPING_SCRIPT="$script_dir/mapping-file-generator-one-model-cond.sh"

# Number of model conditions to process in parallel before waiting
BATCH_SIZE=8

if [ ! -f "$MAPPING_SCRIPT" ]; then
  echo "Cannot find mapping-file-generator-one-model-cond.sh at $MAPPING_SCRIPT" >&2
  exit 2
fi

# Embedded ASTRAL prefix and MODELS array (copied from all_separate_trees.sh)
ASTRAL_PREFIX="./25_taxa_separated_trees"
MODELS=(
  # "n25/k1000/dup0/loss0/ils0"
  # "n25/k1000/dup0/loss0/ils20"
  # "n25/k1000/dup0/loss0/ils50"
  # "n25/k1000/dup0/loss0/ils70"
  # "n25/k1000/dup0.2/loss0/ils70"
  # "n25/k1000/dup0.2/loss0.1/ils70"
  # "n25/k1000/dup0.2/loss0.5/ils70"
  # "n25/k1000/dup0.2/loss1/ils70"
  # "n25/k1000/dup1/loss0/ils70"
  # "n25/k1000/dup1/loss0.1/ils70"
  # "n25/k1000/dup1/loss0.5/ils70"
  # "n25/k1000/dup1/loss1/ils0"
  # "n25/k1000/dup1/loss1/ils20"
  # "n25/k1000/dup1/loss1/ils50"
  # "n25/k1000/dup1/loss1/ils70"
  # "n25/k1000/dup2/loss0/ils70"
  # "n25/k1000/dup2/loss0.1/ils70"
  # "n25/k1000/dup2/loss0.5/ils70"
  # "n25/k1000/dup2/loss1/ils70"
  "n25/k1000/dup5/loss0/ils70"
  "n25/k1000/dup5/loss0.1/ils70"
  "n25/k1000/dup5/loss0.5/ils70"
  "n25/k1000/dup5/loss1/ils0"
  "n25/k1000/dup5/loss1/ils20"
  "n25/k1000/dup5/loss1/ils50"
  "n25/k1000/dup5/loss1/ils70"
#  "n25/k2500/dup5/loss1/ils70"
#  "n25/k10000/dup5/loss1/ils70"
)

batch_count=0

for model in "${MODELS[@]}"; do
  [ -z "$model" ] && continue
  # normalize: remove any trailing slash
  model="${model%/}"

  full_model="$ASTRAL_PREFIX/$model"
  if [ ! -d "$full_model" ]; then
    echo "Skipping missing model path: $full_model"
    continue
  fi

  dest="$OUT_BASE/$model"
  mkdir -p "$dest"

  echo "Generating mapping files for: $full_model -> $dest"
  bash "$MAPPING_SCRIPT" "$full_model" "$dest" &
  
  batch_count=$((batch_count + 1))
  
  # Wait for batch to complete
  if [ $((batch_count % BATCH_SIZE)) -eq 0 ]; then
    echo "Waiting for batch of $BATCH_SIZE model conditions to complete..."
    wait
  fi
done

# Wait for any remaining background jobs
wait

echo "All mapping files generated under: $OUT_BASE"
