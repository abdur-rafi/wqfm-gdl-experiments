# bash run-on-simulated-scripts/copy_disco.sh 250
n=$1
root_folder="simulated-new/estimated"
copy_to_folder="simulated-new/consensus"

# file_to_copy=g_trees-with-gt3species-disco-decomp-cleaned.tre
# file_to_copy="g_trees-raxml-sqlen-${n}-disco-decomp-cleaned.tre"
file_to_copy=merged_gene_trees-disco-decomp-cleaned.tre
file_to_copy="${n}-gt-disco-decomp-cleaned.tre"
# file_to_copy=s_tree-cleaned.tre

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

for model_condition in "${model_conditions[@]}"; do
    if [ -d $root_folder/$model_condition ]; then
        for replicate in $(ls $root_folder/$model_condition); do
            if [ -d $root_folder/$model_condition/$replicate ]; then
                echo "Processing $model_condition/$replicate"
                mkdir -p $copy_to_folder/$model_condition/$replicate
                cp $root_folder/$model_condition/$replicate/$file_to_copy $copy_to_folder/$model_condition/$replicate/
            fi
        done    
    fi
done