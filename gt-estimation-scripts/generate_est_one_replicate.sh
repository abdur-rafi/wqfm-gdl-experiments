#!/bin/bash
# bash gt-estimation-scripts/generate_est_one_replicate.sh ./simulated-new/true/sim200_dup3_loss0.1/18 ./simulated-new/estimated/sim200_dup3_loss0.1/18
# bash gt-estimation-scripts/generate_est_one_replicate.sh ./simulated-new/true/sim200_dup3_loss1/17 ./simulated-new/estimated/sim200_dup3_loss1/17

path_for_single_tree_gen_script="gt-estimation-scripts/generate_est_tree.sh"
rf_score_script="gt-estimation-scripts/rf_score_one_tree.sh"
rf_averager_script="scripts/rfAverager.py"

concatenated_file="est_g_trees.trees"
rf_score_file="rf_score.txt"

replicate_folder_path=$1
if [ -z "$replicate_folder_path" ]; then
  echo "Usage: $0 <replicate_folder_path>"
  exit 1
fi

# check if folder exists
if [ ! -d "$replicate_folder_path" ]; then
  echo "The specified folder does not exist: $replicate_folder_path"
  exit 1
fi

save_directory_replicate_path=$2

if [ -z "$save_directory_replicate_path" ]; then
  echo "Usage: $0 <replicate_folder_path> <save_to>"
  exit 1
fi

if [ ! -d "$save_directory_replicate_path" ]; then
  echo "The specified save directory does not exist."
  exit 1
fi

# Function to generate a filename based on a sequence number
# Arguments:
#   $1 - The raw sequence number (e.g., 1, 10, 100)
# Returns:
#   Echoes the formatted filename (e.g., "file_0001.txt")
get_input_filename_from_sequence() {
  local raw_number="$1"
  local formatted_number=$(printf "%04d" "$raw_number")
  local filename="MSA${formatted_number}.phy"
  echo "$filename"
}

get_output_filename_from_sequence() {
  local raw_number="$1"
  local formatted_number=$(printf "%04d" "$raw_number")
  local filename="est_g_trees${formatted_number}.trees"
  echo "$filename"
}

get_true_tree_filename_from_sequence() {
  local raw_number="$1"
  local formatted_number=$(printf "%04d" "$raw_number")
  local filename="g_trees${formatted_number}.trees"
  echo "$filename"
}

append_to_concatenated_file() {
  local input_file="$1"
  local output_file="$2"
  if [ -f "$input_file" ]; then
    cat "$input_file" >> "$output_file"
    echo "Appended $input_file to $output_file"
  else
    echo "Input file does not exist: $input_file"
  fi
}


# --- Example Usage ---

calculate_rf_score() {
  local est_file="$1"
  local true_file="$2"
  if [ -z "$est_file" ] || [ -z "$true_file" ]; then
    echo "Usage: $0 <est_file> <true_file>"
    exit 1
  fi

  # Call the RF score script
  bash "$rf_score_script" "$est_file" "$true_file"
}

calculate_average_rf_score() {
  local rf_score_file="$1"
  if [ -z "$rf_score_file" ]; then
    echo "Usage: $0 <rf_score_file>"
    exit 1
  fi

  # Call the RF averager script
  python3 "$rf_averager_script" < "$rf_score_file" > "${rf_score_file%.txt}_average.txt"
}


# Loop from 1 to 1000 and get the filename for each
for i in $(seq 1 200); do
  current_input_filename=$(get_input_filename_from_sequence "$i")
  current_output_filename=$(get_output_filename_from_sequence "$i")
  # echo "Processing sequence $i with input file: $current_input_filename and output file: $current_output_filename"
  # Call the script to generate the tree
  bash "$path_for_single_tree_gen_script" "$replicate_folder_path/$current_input_filename"\
  "$save_directory_replicate_path/$current_output_filename"
  # if [ $? -ne 0 ]; then
  #   echo "Error generating tree for sequence $i with input file: $current_input_filename"
  #   continue
  # fi

  # Append the output to the concatenated file
  # append_to_concatenated_file "$replicate_folder_path/$current_output_filename" "$replicate_folder_path/$concatenated_file"

  # calculate rf score
  current_true_tree_filename=$(get_true_tree_filename_from_sequence "$i")
  # echo "Calculating RF score for estimated tree: $current_output_filename against true tree: $current_true_tree_filename"
  calculate_rf_score "$save_directory_replicate_path/$current_output_filename" \
   "$replicate_folder_path/$current_true_tree_filename" >> "$save_directory_replicate_path/$rf_score_file"
  # if [ $? -ne 0 ]; then
  #   echo "Error calculating RF score for sequence $i with estimated tree: $current_output_filename"
  #   continue
  # fi 

done

calculate_average_rf_score "$save_directory_replicate_path/$rf_score_file"