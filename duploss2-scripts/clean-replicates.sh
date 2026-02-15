#!/bin/bash

# Script to clean gene trees by removing branch lengths and annotations
# using treeCleaner.py

# Define paths
base_dir="/Users/abdurrafi/Desktop/ug-thesis/experiments-git/Main-10taxon-1000GT/DL-0.002"
est_gene_trees_dir="$base_dir/EstGeneTrees"
output_dir="$base_dir/EstGeneTrees_cleaned"
tree_cleaner="/Users/abdurrafi/Desktop/ug-thesis/experiments-git/scripts/treeCleaner.py"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Counter for processed files
count=0

# Process each newick file
for file in "$est_gene_trees_dir"/*.newick; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo "Processing $filename..."
        python "$tree_cleaner" < "$file" > "$output_dir/$filename"
        ((count++))
    fi
done

echo "Processed $count files. Output saved to $output_dir"
