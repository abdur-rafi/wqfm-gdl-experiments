bp="100"
duploss2_results_folder="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/duploss2"

copy_to="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/duploss2"

mkdir -p "$copy_to"

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


# n=$1

for cond in "${model_conditions[@]}"; do
  # loop replicates 01..50 and preserve folder structure in $copy_to
  for ((n=1; n<=50; n++)); do
    rep=$(printf "%02d" "$n")
    src="$duploss2_results_folder/$cond/$rep/${bp}-duploss2_unrooted.tre"
    dest_dir="$copy_to/$cond/$rep"
    mkdir -p "$dest_dir"
    if [ -f "$src" ]; then
      # cp "$src" "$dest_dir/e${bp}_species_rax.tre"
      # copy the last line of src to a new file in dest dir named $n-duploss2_unrooted_tree_only.tre
      tail -n 1 "$src" > "$dest_dir/e${bp}_duploss2_unrooted_tree_only.tre"
    else
      echo "Warning: source not found: $src" >&2
    fi
  done
done

# bash run-on-simulated-scripts/runDisco.sh simulated-new/estimated/sim200_dup0.25_loss1 > "$copy_to/run_output.log" 2> "$copy_to/run_error.log"
