# bash run-on-simulated-scripts/merge_gene_trees_simu.sh simulated-new/estimated simulated-new/estimated

root_dir=$1
save_to=$2

merge_one_replicate_script="run-on-simulated-scripts/merge_gene_trees_one_replicate.sh"
if [ -z "$root_dir" ]; then
  echo "Usage: $0 <root_directory>"
  exit 1
fi

if [ -z "$save_to" ]; then
  echo "Usage: $0 <root_directory> <save_to>"
  exit 1
fi


model_conditions=(
  "sim200_dup0_ILS25"
  "sim200_dup0_ILS50"
  "sim200_dup1_ILS25"
  "sim200_dup3_ILS25"
)
  # "sim200_dup1_ILS25"
  # "sim200_dup3_ILS25"

model_conditions=(
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


# for model_cond in $(ls $root_dir); do 
for model_cond in "${model_conditions[@]}"; do 
    echo "Processing model condition: $model_cond"
    if [ ! -d "$root_dir/$model_cond" ]; then
        echo "Skipping $model_cond as it is not a directory."
        continue
    fi
    for replicate in $(ls $root_dir/$model_cond); do
        echo "Processing replicate: $replicate"
        if [ ! -d "$root_dir/$model_cond/$replicate" ]; then
            echo "Skipping $replicate as it is not a directory."
            continue
        fi
        mkdir -p "$save_to/$model_cond/$replicate"

        merged_file="$save_to/$model_cond/$replicate/merged_gene_trees.trees"
        

        >$merged_file  # Clear the merged file before appending
        echo "Merging gene trees for $model_cond, $replicate into $merged_file"
        bash $merge_one_replicate_script "$root_dir/$model_cond/$replicate" "$save_to/$model_cond/$replicate"
        echo "Merging completed for $model_cond, $replicate"
    done
done