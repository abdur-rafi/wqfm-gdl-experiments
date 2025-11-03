# bash run-on-simulated-scripts/run_on_all.sh simulated-new/estimated

root_dir=$1
merge_one_replicate_script="run-on-simulated-scripts/merge_gene_trees_one_replicate.sh"

cleangt_script="run-on-simulated-scripts/cleangt.sh"
disco_script="run-on-simulated-scripts/runDisco.sh"

if [ -z "$root_dir" ]; then
  echo "Usage: $0 <root_directory>"
  exit 1
fi

num_trees=(250 500 1000)

# model_conditions=(
#   "sim200_dup0_ILS25"
#   "sim200_dup0_ILS50"
#   "sim200_dup1_ILS25"
#   "sim200_dup3_ILS25"
#   "sim500_dup0_ILS25"
#   "sim500_dup0_ILS50"
#   "sim500_dup0.25_loss0.1"
#   "sim500_dup0.25_loss1"
#   "sim500_dup1_ILS25"
# )

# model_conditions=(
#     sim200_dup0_ILS70
#     sim500_dup0_ILS70
#     sim500_dup1_loss0.1
#     sim500_dup3_ILS25
#     sim500_dup3_loss0.1
#     sim500_dup3_loss1
# )

model_conditions=(
    sim200_dup3_loss0.1
    sim200_dup3_loss1
)

# model_conditions=(
#     sim200_dup0_ILS70
#     sim200_dup3_loss1       
#     sim500_dup1_loss0.1 
#     sim200_dup1_ILS25    
#     sim500_dup0.25_loss0.1  
#     sim500_dup1_loss1
#     sim200_dup1_loss0.1  
#     sim500_dup0.25_loss1    
#     sim500_dup3_ILS25
#     sim200_dup0.25_loss0.1        
#     sim200_dup1_loss1    
#     sim500_dup0_ILS25       
#     sim500_dup3_loss0.1
#     sim200_dup0.25_loss1          
#     sim200_dup3_ILS25    
#     sim500_dup0_ILS70       
#     sim500_dup3_loss1
#     sim200_dup0_ILS25             
#     sim200_dup3_loss0.1  
#     sim500_dup1_ILS25
# )

for model_cond in "${model_conditions[@]}"; do 
    echo "Processing model condition: $model_cond"
    if [ ! -d "$root_dir/$model_cond" ]; then
        echo "Skipping $model_cond as it is not a directory."
        continue
    fi
    # for replicate in $(ls $root_dir/$model_cond); do
    #     echo "Processing replicate: $replicate"
    #     if [ ! -d "$root_dir/$model_cond/$replicate" ]; then
    #         echo "Skipping $replicate as it is not a directory."
    #         continue
    #     fi
    #     merged_file="$root_dir/$model_cond/$replicate/merged_gene_trees.trees"
    #     >$merged_file  # Clear the merged file before appending
    #     echo "Merging gene trees for $model_cond, $replicate into $merged_file"
    #     bash $merge_one_replicate_script "$root_dir/$model_cond/$replicate" "$root_dir/$model_cond/$replicate"

    for n in "${num_trees[@]}"; do
        echo "Processing $n trees for $model_cond"
        # input_file="$root_dir/$model_cond/$replicate/merged_gene_trees.trees"
        bash $disco_script "$root_dir/$model_cond" $n
    done

    # done
    # bash $cleangt_script "$root_dir/$model_cond" 1
    # bash $disco_script "$root_dir/$model_cond" 1
done