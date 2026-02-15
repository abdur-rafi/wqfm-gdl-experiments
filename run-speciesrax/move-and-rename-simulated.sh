# bp="500"
species_rax_results_folder="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/stuffs-from-systems/species-rax-outputs/species-rax-output-sp-trees"

copy_to="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/species-rax"

mkdir -p "$copy_to"

# model_conditions=(
#   "n25/k1000/dup0/loss0/ils0"
#   "n25/k1000/dup0/loss0/ils20"
#   "n25/k1000/dup0/loss0/ils50"
#   "n25/k1000/dup0/loss0/ils70"
#   "n25/k1000/dup0.2/loss0/ils70"
#   "n25/k1000/dup0.2/loss0.1/ils70"
#   "n25/k1000/dup0.2/loss0.5/ils70"
#   "n25/k1000/dup0.2/loss1/ils70"
#   "n25/k1000/dup1/loss0/ils70"
#   "n25/k1000/dup1/loss0.1/ils70"
#   "n25/k1000/dup1/loss0.5/ils70"
#   "n25/k1000/dup1/loss1/ils0"
#   "n25/k1000/dup1/loss1/ils20"
#   "n25/k1000/dup1/loss1/ils50"
#   "n25/k1000/dup1/loss1/ils70"
#   "n25/k1000/dup2/loss0/ils70"
#   "n25/k1000/dup2/loss0.1/ils70"
#   "n25/k1000/dup2/loss0.5/ils70"
#   "n25/k1000/dup2/loss1/ils70"
#   "n25/k1000/dup5/loss0/ils70"
#   "n25/k1000/dup5/loss0.1/ils70"
#   "n25/k1000/dup5/loss0.5/ils70"
#   "n25/k1000/dup5/loss1/ils0"
#   "n25/k1000/dup5/loss1/ils20"
#   "n25/k1000/dup5/loss1/ils50"
#   "n25/k1000/dup5/loss1/ils70"
# )

model_conditions=(
    sim200_dup3_loss1       
    sim200_dup0_ILS70
    sim200_dup1_ILS25    
    sim200_dup1_loss0.1  
    sim200_dup0.25_loss0.1        
    sim200_dup1_loss1    
    sim200_dup0.25_loss1          
    sim200_dup3_ILS25    
    sim200_dup0_ILS25             
    sim200_dup3_loss0.1  
    # sim500_dup1_loss0.1 
    # sim500_dup0.25_loss0.1  
    # sim500_dup1_loss1
    # sim500_dup0.25_loss1    
    # sim500_dup3_ILS25
    # sim500_dup0_ILS25       
    # sim500_dup3_loss0.1
    # sim500_dup0_ILS70       
    # sim500_dup3_loss1
    # sim500_dup1_ILS25
)

# n=$1

for cond in "${model_conditions[@]}"; do
  # loop replicates 01..20 and preserve folder structure in $copy_to
  for ((n=1; n<=10; n++)); do
    rep=$(printf "%02d" "$n")
    src="$species_rax_results_folder/$cond/$rep/species_trees/inferred_species_tree.newick"
    dest_dir="$copy_to/$cond/$rep"
    mkdir -p "$dest_dir"
    if [ -f "$src" ]; then
      cp "$src" "$dest_dir/250_gt_species_rax.tre"
    else
      echo "Warning: source not found: $src" >&2
    fi
  done
done

# bash run-on-simulated-scripts/runDisco.sh simulated-new/estimated/sim200_dup0.25_loss1 > "$copy_to/run_output.log" 2> "$copy_to/run_error.log"
