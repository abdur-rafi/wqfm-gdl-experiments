#!/bin/bash
# bash scripts/run25.sh >> log.log

log_parent_folder=n25_duploss_logs

timestamp=$(date +"%Y%m%d_%H%M%S")

log_folder="$log_parent_folder/$timestamp"

mkdir -p "$log_folder"



# Define an array with directories
paths=(
    "../AstralPro/n25/k1000/dup0/loss0/ils0"
    "../AstralPro/n25/k1000/dup0/loss0/ils20"
    "../AstralPro/n25/k1000/dup0/loss0/ils50"
    "../AstralPro/n25/k1000/dup0/loss0/ils70"
    "../AstralPro/n25/k1000/dup0.2/loss0/ils70"
    "../AstralPro/n25/k1000/dup0.2/loss0.1/ils70"
    "../AstralPro/n25/k1000/dup0.2/loss0.5/ils70"
    "../AstralPro/n25/k1000/dup0.2/loss1/ils70"
    "../AstralPro/n25/k1000/dup1/loss0/ils70"
    "../AstralPro/n25/k1000/dup1/loss0.1/ils70"
    "../AstralPro/n25/k1000/dup1/loss0.5/ils70"
    "../AstralPro/n25/k1000/dup1/loss1/ils0"
    "../AstralPro/n25/k1000/dup1/loss1/ils20"
    "../AstralPro/n25/k1000/dup1/loss1/ils50"
    "../AstralPro/n25/k1000/dup1/loss1/ils70"
    "../AstralPro/n25/k1000/dup2/loss0/ils70"
    "../AstralPro/n25/k1000/dup2/loss0.1/ils70"
    "../AstralPro/n25/k1000/dup2/loss0.5/ils70"
    "../AstralPro/n25/k1000/dup2/loss1/ils70"
    "../AstralPro/n25/k1000/dup5/loss0/ils70"
    "../AstralPro/n25/k1000/dup5/loss0.1/ils70"
    "../AstralPro/n25/k1000/dup5/loss0.5/ils70"
    "../AstralPro/n25/k1000/dup5/loss1/ils0"
    "../AstralPro/n25/k1000/dup5/loss1/ils20"
    "../AstralPro/n25/k1000/dup5/loss1/ils50"
    "../AstralPro/n25/k1000/dup5/loss1/ils70"
    # "../AstralPro/n25/k2500/dup5/loss1/ils70"
    # "../AstralPro/n25/k10000/dup5/loss1/ils70"
)

# Iterate over the array
for path in "${paths[@]}"; do
    echo "Processing: $path"
    
    # Extract n, k, dup, loss, ils from the path
    # Path format: ../AstralPro/n25/k1000/dup0/loss0/ils0
    # Extract n value (e.g., n25 -> 25)
    n=$(echo "$path" | sed 's|.*/n||' | sed 's|/.*||')
    
    # Remove leading ../AstralPro/n25/ and split by /
    path_part=$(echo "$path" | sed 's|.*/n25/||')
    
    # Extract each component
    k=$(echo "$path_part" | sed 's|/.*||' | sed 's|k||')
    dup=$(echo "$path_part" | sed 's|.*/dup||' | sed 's|/.*||')
    loss=$(echo "$path_part" | sed 's|.*/loss||' | sed 's|/.*||')
    ils=$(echo "$path_part" | sed 's|.*/ils||')
    
    # Create folder name: n25_k1000_dup0_loss0_ils0
    output_folder="$log_folder/n${n}_k${k}_dup${dup}_loss${loss}_ils${ils}"
    mkdir -p "$output_folder"
    
    # Log files for this run
    log_file="$output_folder/output.log"
    error_file="$output_folder/error.log"
    
    echo "Output folder: $output_folder"
    echo "Log file: $log_file"
    echo "Error log file: $error_file"
    
    # Run the script and redirect stdout and stderr to separate files
    # bash s25-scripts/cleangt.sh $path 1 >> "$log_file" 2>> "$error_file"
    bash s25-scripts/stripDupSuffix.sh $path $1 >> "$log_file" 2>> "$error_file"
    
    echo "Completed: $path"
    echo "---"
done
