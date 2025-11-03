#!/bin/bash

root_folder="100taxa/DOI-10-13012-b2idb-5721322_v1/estimated"
script_name="runDisco_s100.sh"
script_path="s100-scripts/${script_name}"
n=$1
timestamp=$(date +"%Y%m%d_%H%M%S")
log_folder="100taxa/run_logs/wqfm_and_apro3_${n}_${script_name}_${timestamp}"
log_folder="100taxa/run_logs/wqfm_2020_${n}_${script_name}_${timestamp}"


mkdir -p $log_folder

echo "Logs will be saved to $log_folder"
# script_path="scripts/cleangt.sh"

# Set to 1 for parallel execution, 0 for serial execution
RUN_PARALLEL=0
# Uncomment these if you want to run them
  # "$script_path $root_folder/ntaxa-100.dlrate-0.0.psize-10000000 >> $log_folder/estimated_psize-1-0.0.log 2>> $log_folder/estimated_psize-1-0.0.err"
  # "$script_path $root_folder/ntaxa-100.dlrate-0.0000000001.psize-10000000 >> $log_folder/estimated_psize-1-0.0000000001.log 2>> $log_folder/estimated_psize-1-0.0000000001.err"
  # "$script_path $root_folder/ntaxa-100.dlrate-0.0000000002.psize-10000000 >> $log_folder/estimated_psize-1-0.0000000002.log 2>> $log_folder/estimated_psize-1-0.0000000002.err"
  # "$script_path $root_folder/ntaxa-100.dlrate-0.0000000005.psize-10000000 >> $log_folder/estimated_psize-1-0.0000000005.log 2>> $log_folder/estimated_psize-1-0.0000000005.err"

  # Duplicate set with script_path="scripts/runDisco.sh" commented out
  # "$script_path $root_folder/ntaxa-100.dlrate-0.0.psize-50000000 >> $log_folder/estimated_psize-5-0.0.log 2>> $log_folder/estimated_psize-5-0.0.err"
  # "$script_path $root_folder/ntaxa-100.dlrate-0.0000000001.psize-50000000 >> $log_folder/estimated_psize-5-0.0000000001.log 2>> $log_folder/estimated_psize-5-0.0000000001.err"
  # "$script_path $root_folder/ntaxa-100.dlrate-0.0000000002.psize-50000000 >> $log_folder/estimated_psize-5-0.0000000002.log 2>> $log_folder/estimated_psize-5-0.0000000002.err"
  # "$script_path $root_folder/ntaxa-100.dlrate-0.0000000005.psize-50000000 >> $log_folder/estimated_psize-5-0.0000000005.log 2>> $log_folder/estimated_psize-5-0.0000000005.err"

commands=(
  "bash $script_path $root_folder/ntaxa-100.dlrate-0.0.psize-50000000 $n > $log_folder/estimated_psize-5-0.0.log 2> $log_folder/estimated_psize-5-0.0.err"
  "bash $script_path $root_folder/ntaxa-100.dlrate-0.0000000001.psize-50000000 $n > $log_folder/estimated_psize-5-0.0000000001.log 2> $log_folder/estimated_psize-5-0.0000000001.err"
  "bash $script_path $root_folder/ntaxa-100.dlrate-0.0000000002.psize-50000000 $n > $log_folder/estimated_psize-5-0.0000000002.log 2> $log_folder/estimated_psize-5-0.0000000002.err"
  "bash $script_path $root_folder/ntaxa-100.dlrate-0.0000000005.psize-50000000 $n > $log_folder/estimated_psize-5-0.0000000005.log 2> $log_folder/estimated_psize-5-0.0000000005.err"
  "bash $script_path $root_folder/ntaxa-100.dlrate-0.0.psize-10000000 $n > $log_folder/estimated_psize-1-0.0.log 2> $log_folder/estimated_psize-1-0.0.err"
  "bash $script_path $root_folder/ntaxa-100.dlrate-0.0000000001.psize-10000000 $n > $log_folder/estimated_psize-1-0.0000000001.log 2> $log_folder/estimated_psize-1-0.0000000001.err"
  "bash $script_path $root_folder/ntaxa-100.dlrate-0.0000000002.psize-10000000 $n > $log_folder/estimated_psize-1-0.0000000002.log 2> $log_folder/estimated_psize-1-0.0000000002.err"
  "bash $script_path $root_folder/ntaxa-100.dlrate-0.0000000005.psize-10000000 $n > $log_folder/estimated_psize-1-0.0000000005.log 2> $log_folder/estimated_psize-1-0.0000000005.err"
)

for cmd in "${commands[@]}"; do
  # Skip commented-out commands
#   [[ "$cmd" =~ ^# ]] && continue
    echo "Executing: $cmd"
  if [[ $RUN_PARALLEL -eq 1 ]]; then
    eval "$cmd" &
  else
    eval "$cmd"
  fi
done

# Wait for all background jobs if running in parallel
if [[ $RUN_PARALLEL -eq 1 ]]; then
  wait
fi
