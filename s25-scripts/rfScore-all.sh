output_sp_trees_folder="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/species-rax"
true_sp_trees_folder="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/species-trees"
score_output_folder="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/rf-scores"

sp_tree_filename="e500_species_rax_cleaned.tre"
true_sp_tree_filename="s_tree-cleaned.tre"

# Defaults (can be overridden with flags)
score_filename="species_rax_rf_scores.txt"
avg_score_filename="species_rax_rf_scores_avg.txt"

usage() {
  echo "Usage: $0 [-p output_sp_trees_folder] [-s sp_tree_filename] [-o score_filename] [-a avg_score_filename]"
  echo "  -p  folder containing inferred species trees (default: $output_sp_trees_folder)"
  echo "  -s  filename for inferred species tree inside each replicate (default: $sp_tree_filename)"
  echo "  -o  per-condition score output filename (default: $score_filename)"
  echo "  -a  per-condition averaged score filename (default: $avg_score_filename)"
  exit 1
}

# parse flags
while getopts ":p:s:o:a:h" opt; do
  case $opt in
    p) output_sp_trees_folder="$OPTARG" ;;
    s) sp_tree_filename="$OPTARG" ;;
    o) score_filename="$OPTARG" ;;
    a) avg_score_filename="$OPTARG" ;;
    h) usage ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
    :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
  esac
done


rfscore_script_path="rfScoreCalculator/getFpFn.py"
tfscore_averager_script_path="scripts/rfAverager.py"


mkdir -p "$score_output_folder"

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
  echo "processing condition: $cond"
  mkdir -p "$score_output_folder/$cond"
  score_file="$score_output_folder/$cond/$score_filename"
  > "$score_file"
  for ((n=1; n<=50; n++)); do
    rep=$(printf "%02d" "$n")
    output_sp_tree="$output_sp_trees_folder/$cond/$rep/$sp_tree_filename"
    true_sp_tree="$true_sp_trees_folder/$cond/$rep/$true_sp_tree_filename"

    if [ -f "$output_sp_tree" ] && [ -f "$true_sp_tree" ]; then
      python "$rfscore_script_path" -t "$true_sp_tree" -e "$output_sp_tree" >> "$score_file"
    else
      echo "Warning: missing tree file for $cond replicate $rep" >&2
    fi
  done
  avg_score_file="$score_output_folder/$cond/$avg_score_filename"
  python "$tfscore_averager_script_path" < "$score_file" > "$avg_score_file"
done

# bash s25-scripts/rfScore-all.sh -s e100_species_rax_cleaned.tre -o e100_species_rax_rf_scores.txt -a e100_species_rax_rf_scores_avg.txt
# bash s25-scripts/rfScore-all.sh -s e500_species_rax_cleaned.tre -o e500_species_rax_rf_scores.txt -a e500_species_rax_rf_scores_avg.txt
# bash s25-scripts/rfScore-all.sh -s e100_duploss2_unrooted_tree_only.tre -o e100_duploss2_unrooted_tree_only_rf_scores.txt -a e100_duploss2_unrooted_tree_only_rf_scores_avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/duploss2
# bash s25-scripts/rfScore-all.sh -s e500_duploss2_unrooted_tree_only.tre -o e500_duploss2_unrooted_tree_only_rf_scores.txt -a e500_duploss2_unrooted_tree_only_rf_scores_avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/duploss2
# bash s25-scripts/rfScore-all.sh -s e100-wqfm-2020.tre -o e100-wqfm-2020-rf-scores.txt -a e100-wqfm-2020-rf-scores-avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/wqfm-gdl-q
# bash s25-scripts/rfScore-all.sh -s e500-wqfm-2020.tre -o e500-wqfm-2020-rf-scores.txt -a e500-wqfm-2020-rf-scores-avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/wqfm-gdl-q
# bash s25-scripts/rfScore-all.sh -s e100-wqfm-gdl-per-node-norm-fixed.tre -o e100-wqfm-gdl-per-node-norm-fixed-rf-scores.txt -a e100-wqfm-gdl-per-node-norm-fixed-rf-scores-avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/wqfm-gdl-t
# bash s25-scripts/rfScore-all.sh -s e100_apro-cleaned.tre -o e100_apro-cleaned-rf-scores.txt -a e100_apro-cleaned-rf-scores-avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/Apro-3
# bash s25-scripts/rfScore-all.sh -s e500-wqfm-gdl-per-node-norm-fixed.tre -o e500-wqfm-gdl-per-node-norm-fixed-rf-scores.txt -a e500-wqfm-gdl-per-node-norm-fixed-rf-scores-avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/wqfm-gdl-t
# bash s25-scripts/rfScore-all.sh -s e500_apro-cleaned.tre -o e500_apro-cleaned-rf-scores.txt -a e500_apro-cleaned-rf-scores-avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/Apro-3

