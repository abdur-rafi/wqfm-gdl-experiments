#!/bin/bash

root_dir=$1
save_to=$2


if [ -z "$save_to" ]; then
  echo "Usage: $0 <root_directory> <save_to>"
  exit 1
fi

merged_file="$save_to/merged_gene_trees.trees"

for i in $(seq 1 1000); do
    curr_4_digit_id=$(printf "%04d" $i)
    curr_gene_tree="$root_dir/est_g_trees$curr_4_digit_id.trees"
    if [ -f "$curr_gene_tree" ]; then
        echo "Merging $curr_gene_tree into $merged_file"
        cat "$curr_gene_tree" >> "$merged_file"
        echo "Adding new line after merging."
        echo "" >> "$merged_file"
    else
        echo "File $curr_gene_tree does not exist, skipping."
    fi

done

echo "All gene trees merged into $merged_file"
random_number=$(shuf -i 1-1000 -n 1)
echo "Random number generated: $random_number"
grep -v '^$' $merged_file > "temp_file_$random_number.txt" && mv "temp_file_$random_number.txt" $merged_file
echo "Removed empty lines from $merged_file"

# rm $merged_file