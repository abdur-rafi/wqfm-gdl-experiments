
#!/bin/bash
replicate_count=50
script_for_one_replicate="gt-estimation-scripts/generate_est_one_replicate.sh"

model_condition_folder_path=$1
save_to=$2
if [ -z "$model_condition_folder_path" ]; then
  echo "Usage: $0 <model_condition_folder_path>"
  exit 1
fi
# Check if folder exists
if [ ! -d "$model_condition_folder_path" ]; then
  echo "The specified folder does not exist: $model_condition_folder_path"
  exit 1
fi

if [ -z "$save_to" ]; then
  echo "Usage: $0 <model_condition_folder_path> <save_to>"
  exit 1
fi

if [ ! -d "$save_to" ]; then
  echo "The specified save directory does not exist."
  exit 1
fi

for i in $(seq 1 $replicate_count); do
    current_replicate=$(printf "%02d" "$i")
    echo "Processing replicate $current_replicate"
    mkdir -p "$save_to/$current_replicate"
    bash "$script_for_one_replicate" "$model_condition_folder_path/$current_replicate"\
    "$save_to/$current_replicate"

done