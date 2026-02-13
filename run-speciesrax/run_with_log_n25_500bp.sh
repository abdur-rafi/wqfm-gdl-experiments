log_parent_folder=25_taxa_separated_trees_500bp/log

timestamp=$(date +"%Y%m%d_%H%M%S")

log_folder="$log_parent_folder/$timestamp"

mkdir -p "$log_folder"

model_conditions=(
  "n25/k1000/dup0/loss0/ils0"
  "n25/k1000/dup0/loss0/ils20"
  "n25/k1000/dup0/loss0/ils50"
  "n25/k1000/dup0/loss0/ils70"
  "n25/k1000/dup0.2/loss0/ils70"
  "n25/k1000/dup0.2/loss0.1/ils70"
  "n25/k1000/dup0.2/loss0.5/ils70"
  "n25/k1000/dup0.2/loss1/ils70"
  "n25/k1000/dup1/loss0/ils70"
  "n25/k1000/dup1/loss0.1/ils70"
  "n25/k1000/dup1/loss0.5/ils70"
  "n25/k1000/dup1/loss1/ils0"
  "n25/k1000/dup1/loss1/ils20"
  "n25/k1000/dup1/loss1/ils50"
  "n25/k1000/dup1/loss1/ils70"
  "n25/k1000/dup2/loss0/ils70"
  "n25/k1000/dup2/loss0.1/ils70"
  "n25/k1000/dup2/loss0.5/ils70"
  "n25/k1000/dup2/loss1/ils70"
  "n25/k1000/dup5/loss0/ils70"
  "n25/k1000/dup5/loss0.1/ils70"
  "n25/k1000/dup5/loss0.5/ils70"
  "n25/k1000/dup5/loss1/ils0"
  "n25/k1000/dup5/loss1/ils20"
  "n25/k1000/dup5/loss1/ils50"
  "n25/k1000/dup5/loss1/ils70"
)


n=$1

for cond in "${model_conditions[@]}"; do
    mkdir -p "$log_folder/$cond"
    mkdir -p "25_taxa_separated_trees_500bp/species-rax-outputs/$cond"
    bash run-speciesrax/run-one-model-cond_n25.sh "25_taxa_separated_trees_500bp/species-rax-family-files/$cond" "25_taxa_separated_trees_500bp/species-rax-outputs/$cond" > "$log_folder/$cond/run_output.log" 2> "$log_folder/$cond/run_error.log"

done

# bash run-on-simulated-scripts/runDisco.sh simulated-new/estimated/sim200_dup0.25_loss1 > "$log_folder/run_output.log" 2> "$log_folder/run_error.log"
