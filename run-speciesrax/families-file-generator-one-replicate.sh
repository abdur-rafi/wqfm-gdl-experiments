#!/usr/bin/env bash
set -euo pipefail

usage() {
	echo "Usage: $0 <replicate_path> <output_dir> <link_path>"
	echo "Example: $0 /path/to/replicate /path/to/output /path/to/link" 
	exit 2
}

if [ "$#" -ne 3 ]; then
	usage
fi

rep_path="$1"
out_dir="$2"
link_dir="$3"

# Verify both replicate path and output directory exist (do not create)
if [ ! -d "$rep_path" ]; then
	echo "Error: replicate path not found or not a directory: $rep_path" >&2
	exit 1
fi

if [ ! -d "$out_dir" ]; then
	echo "Error: output directory not found or not a directory: $out_dir" >&2
	exit 1
fi


if [ ! -d "$link_dir" ]; then
	echo "Error: link directory not found or not a directory: $link_dir" >&2
	exit 1
fi



# Determine directory of this script so we can call gen-mapping-file.py next to it
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
gen_script="$script_dir/gen-mapping-file.py"

if [ ! -x "$gen_script" ] && [ ! -f "$gen_script" ]; then
	echo "Error: gen-mapping-file.py not found in script directory: $script_dir" >&2
	exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
	echo "Error: python3 not found in PATH" >&2
	exit 1
fi

output_file="$out_dir/families-file.txt"

# echo "Generating families file: $output_file"
> "$output_file"
echo "[FAMILIES] " >> "$output_file"

for i in $(seq -f "%04g" 1 1000); do
	input_file="$rep_path/est_g_trees${i}.trees"

	# if [ ! -f "$input_file" ]; then
	# 	echo "Warning: input not found: $input_file — skipping"
	# 	continue
	# fi

    # Append to the families file
    echo "- $i " >> "$output_file"
    echo "starting_gene_tree = $rep_path/est_g_trees${i}.trees_cleaned.tree.resolved" >> "$output_file"
    echo "mapping = $link_dir/${i}-mapping.link " >> "$output_file"

	# echo "Processing: $input_file -> $output_file"
	# python3 "$gen_script" -i "$input_file" -o "$output_file"

done

# echo "All done. Outputs written to: $out_dir"

