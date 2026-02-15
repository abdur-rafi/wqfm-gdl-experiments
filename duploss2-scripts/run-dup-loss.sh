#!/bin/bash

# Script to run DupLoss-2 on each estimated gene tree
# DupLoss-2 takes input (-i) and output (-o) flags

# Define paths
base_dir="/Users/abdurrafi/Desktop/ug-thesis/experiments-git/Main-10taxon-1000GT/DL-0.002"
est_gene_trees_dir="$base_dir/EstGeneTrees_cleaned"
output_dir="$base_dir/DupLoss2_outputs"
duploss_exec="/Users/abdurrafi/Desktop/ug-thesis/experiments-git/DupLoss-2.out"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Counter for processed files
count=0

# Process each newick file
for file in "$est_gene_trees_dir"/*.newick; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        output_file="$output_dir/${filename%.newick}_duploss.newick"
        
        echo "Processing $filename..."
        "$duploss_exec" -i "$file" -o "$output_file"
        
        ((count++))
    fi
done

echo "Processed $count files. Output saved to $output_dir"
