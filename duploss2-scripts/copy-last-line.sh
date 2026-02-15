#!/bin/bash

# Script to extract the last line (tree) from DupLoss2 outputs,
# clean them using treeCleaner.py, and save to a new folder

# Define paths
base_dir="/Users/abdurrafi/Desktop/ug-thesis/experiments-git/Main-10taxon-1000GT/DL-0.002"
duploss_outputs_dir="$base_dir/DupLoss2_outputs"
output_dir="$base_dir/DupLoss2_cleaned"
tree_cleaner="/Users/abdurrafi/Desktop/ug-thesis/experiments-git/scripts/treeCleaner.py"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Counter for processed files
count=0

# Process each newick file in DupLoss2_outputs
for file in "$duploss_outputs_dir"/*.newick; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        output_file="$output_dir/$filename"
        
        echo "Processing $filename..."
        # Extract last line and pipe to treeCleaner.py
        tail -n 1 "$file" | python "$tree_cleaner" > "$output_file"
        
        ((count++))
    fi
done

echo "Processed $count files. Output saved to $output_dir"
