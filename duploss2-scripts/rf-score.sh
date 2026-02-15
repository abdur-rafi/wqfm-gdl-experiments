#!/bin/bash

# Script to calculate RF scores between true species trees (ModelTrees)
# and estimated trees (DupLoss2 outputs)

# Define paths
base_dir="/Users/abdurrafi/Desktop/ug-thesis/experiments-git/Main-10taxon-1000GT/DL-0.002"
duploss_cleaned_dir="$base_dir/DupLoss2_cleaned"
model_trees_dir="$base_dir/ModelTrees_cleaned"
output_file="$base_dir/duploss2_rf_scores.txt"
avg_output_file="$base_dir/duploss2_rf_scores_avg.txt"
rf_calculator="/Users/abdurrafi/Desktop/ug-thesis/experiments-git/rfScoreCalculator/getFpFn.py"
rf_averager="/Users/abdurrafi/Desktop/ug-thesis/experiments-git/scripts/rfAverager.py"

# Clear output file if it exists
> "$output_file"

# Counter for processed files
count=0

# Process each cleaned DupLoss2 output file
for est_file in "$duploss_cleaned_dir"/*.newick; do
    if [ -f "$est_file" ]; then
        filename=$(basename "$est_file")
        
        # Extract replicate number from filename
        # EstGeneTrees_X_duploss.newick -> X
        replicate=$(echo "$filename" | sed -n 's/EstGeneTrees_\([0-9]*\)_duploss.newick/\1/p')
        
        # Find corresponding model tree
        true_file="$model_trees_dir/Model_${replicate}.newick"
        
        if [ -f "$true_file" ]; then
            echo "Calculating RF score for replicate $replicate..."
            echo "Replicate $replicate:" >> "$output_file"
            python "$rf_calculator" -t "$true_file" -e "$est_file" >> "$output_file"
            echo "" >> "$output_file"
            ((count++))
        else
            echo "Warning: True tree not found for replicate $replicate"
        fi
    fi
done

echo "Processed $count files. Scores saved to $output_file"

# Calculate average RF scores
echo "Calculating average RF scores..."
grep -E '^\([0-9]' "$output_file" | python "$rf_averager" > "$avg_output_file"

echo "Average RF scores saved to $avg_output_file"
cat "$avg_output_file"
