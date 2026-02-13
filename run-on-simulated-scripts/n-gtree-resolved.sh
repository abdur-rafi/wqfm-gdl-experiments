#  bash run-on-simulated-scripts/n-gtree.sh simulated-new/estimated

root=$1

if [ -z "$root" ]; then
  echo "Usage: $0 <root_directory>"
  exit 1
fi

geneTreeLabel="merged_gene_trees.resolved.tre"

tree_label_suffix="-gt-resolved.tre"

model_conditions=(
  "sim200_dup0_ILS25"
  "sim200_dup0_ILS50"
  "sim200_dup1_ILS25"
  "sim200_dup3_ILS25"
  "sim500_dup0_ILS25"
  "sim500_dup0_ILS50"
  "sim500_dup0.25_loss0.1"
  "sim500_dup0.25_loss1"
  "sim500_dup1_ILS25"
)

model_conditions=(
    sim200_dup0_ILS70
    sim500_dup0_ILS70
    sim500_dup1_loss0.1
    sim500_dup3_ILS25
    sim500_dup3_loss0.1
    sim500_dup3_loss1
)




trees_to_take=(250 500 1000)

for model_cond in "${model_conditions[@]}"; do 
    echo "Processing model condition: $model_cond"
    if [ ! -d "$root/$model_cond" ]; then
        echo "Skipping $model_cond as it is not a directory."
        continue
    fi
    for replicate in $(ls $root/$model_cond); do
        echo "Processing replicate: $replicate"
        if [ ! -d "$root/$model_cond/$replicate" ]; then
            echo "Skipping $replicate as it is not a directory."
            continue
        fi

        for num_trees in "${trees_to_take[@]}"; do
            echo "Processing $num_trees trees for $model_cond, $replicate"
            input_file="$root/$model_cond/$replicate/$geneTreeLabel"
            output_file="$root/$model_cond/$replicate/${num_trees}${tree_label_suffix}"
            head -n $num_trees "$input_file" > "$output_file"
            echo "Created $output_file with first $num_trees trees from $input_file"
        done

    done
done