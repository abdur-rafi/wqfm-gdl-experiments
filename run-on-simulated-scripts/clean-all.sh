bp="500"
results_folder="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/species-rax"

output_folder="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/species-rax"

mkdir -p "$output_folder"

# input_file_name="e${bp}_species_rax.tre"
input_file_name="250_gt_species_rax.tre"
# output_file_name="e${bp}_species_rax_cleaned.tre"
output_file_name="250_gt_species_rax_cleaned.tre"

treecleaner_script_path="./s25-scripts/treecleaner.py"

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
    sim500_dup1_loss0.1 
    sim500_dup0.25_loss0.1  
    sim500_dup1_loss1
    sim500_dup0.25_loss1    
    sim500_dup3_ILS25
    sim500_dup0_ILS25       
    sim500_dup3_loss0.1
    sim500_dup0_ILS70       
    sim500_dup3_loss1
    sim500_dup1_ILS25
)


# n=$1

for cond in "${model_conditions[@]}"; do
  # loop replicates 01..50 and preserve folder structure in $copy_to
  for ((n=1; n<=50; n++)); do
    rep=$(printf "%02d" "$n")
    src="$results_folder/$cond/$rep/$input_file_name"
    dest_dir="$output_folder/$cond/$rep"
    if [ -f "$src" ]; then
      mkdir -p "$dest_dir"
      python "$treecleaner_script_path" < "$src" > "$dest_dir/$output_file_name"
    else
      echo "Warning: source not found: $src" >&2
    fi
  done
done
