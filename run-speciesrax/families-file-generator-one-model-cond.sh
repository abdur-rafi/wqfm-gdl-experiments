#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <model_condition_path> <output_dir> <link_dir>"
  echo "Example: $0 /path/to/model_condition /path/to/output /path/to/link"
  exit 2
}

if [ "$#" -ne 3 ]; then
  usage
fi

model_cond_path="$1"
out_dir="$2"
link_dir="$3"

if [ ! -d "$model_cond_path" ]; then
  echo "Error: model condition path not found or not a directory: $model_cond_path" >&2
  exit 1
fi

# Do not create the top-level output directory; require it to exist
if [ ! -d "$out_dir" ]; then
  echo "Error: output directory not found or not a directory: $out_dir" >&2
  exit 1
fi

if [ ! -d "$link_dir" ]; then
  echo "Error: link directory not found or not a directory: $link_dir" >&2
  exit 1
fi


# Determine directory of this script so we can call the per-replicate script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
replicate_script="$script_dir/families-file-generator-one-replicate.sh"

if [ ! -f "$replicate_script" ]; then
  echo "Error: replicate generator script not found: $replicate_script" >&2
  exit 1
fi

# Iterate over replicate directories inside the model condition folder
shopt -s nullglob
for rep_path in "$model_cond_path"/*; do
  [ -d "$rep_path" ] || continue
  rep_name="$(basename "$rep_path")"

  # Create replicate output folder if it doesn't exist
  out_rep_dir="$out_dir/$rep_name"
  mkdir -p "$out_rep_dir"

  link_path="$link_dir/$rep_name"

  echo "Running families file generation for replicate: $rep_name"
  bash "$replicate_script" "$rep_path" "$out_rep_dir" "$link_path"
done

echo "All model condition replicates processed. Outputs in: $out_dir"