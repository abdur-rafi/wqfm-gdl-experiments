log_parent_folder=simulated-new/log

timestamp=$(date +"%Y%m%d_%H%M%S")

log_folder="$log_parent_folder/$timestamp"

mkdir -p "$log_folder"

model_conditions=(
  "sim200_dup3_ILS25" #1000 remaining
  "sim500_dup0_ILS25" # 500, 1000 remaining
  "sim500_dup0.25_loss0.1"
  "sim500_dup0.25_loss1"
  "sim500_dup1_ILS25"
  "sim500_dup1_loss1"
)

# model_conditions=(
#     # sim200_dup0_ILS70
#     # sim500_dup0_ILS70
#     # sim500_dup1_loss0.1
#     # sim500_dup3_ILS25
#     # sim500_dup3_loss0.1
#     # sim500_dup3_loss1
# )

model_conditions=(
    sim200_dup3_loss0.1
    sim200_dup3_loss1
)

n=$1

for cond in "${model_conditions[@]}"; do
    mkdir -p "$log_folder/$cond"
    bash run-on-simulated-scripts/runDisco.sh "simulated-new/estimated/$cond" $n > "$log_folder/$cond/run_output.log" 2> "$log_folder/$cond/run_error.log"

done

# bash run-on-simulated-scripts/runDisco.sh simulated-new/estimated/sim200_dup0.25_loss1 > "$log_folder/run_output.log" 2> "$log_folder/run_error.log"
