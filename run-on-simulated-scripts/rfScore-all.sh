output_sp_trees_folder="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/species-rax"
true_sp_trees_folder="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/sp_trees"
score_output_folder="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/rf-scores"

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


for cond in "${model_conditions[@]}"; do
  # loop replicates 01..20 and preserve folder structure in $copy_to
  echo "processing condition: $cond"
  mkdir -p "$score_output_folder/$cond"
  score_file="$score_output_folder/$cond/$score_filename"
  > "$score_file"
  for ((n=1; n<=20; n++)); do
    rep=$(printf "%02d" "$n")
    output_sp_tree="$output_sp_trees_folder/$cond/$rep/$sp_tree_filename"
    true_sp_tree="$true_sp_trees_folder/$cond/$rep/$true_sp_tree_filename"

    if [ -f "$output_sp_tree" ] && [ -f "$true_sp_tree" ]; then
      python "$rfscore_script_path" -t "$true_sp_tree" -e "$output_sp_tree" >> "$score_file"
    else
      echo "Warning: missing tree file for $cond replicate $rep" >&2
    fi
  done
  
  # Check if score file is empty
  if [ ! -s "$score_file" ]; then
    echo "Warning: no scores found for $cond, removing empty file" >&2
    rm -f "$score_file"
    avg_score_file="$score_output_folder/$cond/$avg_score_filename"
    rm -f "$avg_score_file"
  else
    avg_score_file="$score_output_folder/$cond/$avg_score_filename"
    python "$tfscore_averager_script_path" < "$score_file" > "$avg_score_file"
  fi
done


# bash run-on-simulated-scripts/rfScore-all.sh -s 250_gt_apro-cleaned.tre -o 250_gt_apro_rf_scores.txt -a 250_gt_apro_rf_scores_avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/Apro-3
# bash run-on-simulated-scripts/rfScore-all.sh -s 250-gt-wqfm-tree-per-node-norm.tre -o 250_gt_wqfm_gdl_per_node_norm_rf_scores.txt -a 250_gt_wqfm_gdl_per_node_norm_rf_scores_avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/wQFM-GDL-T
# bash run-on-simulated-scripts/rfScore-all.sh -s 250_gt_species_rax_cleaned.tre -o 250_gt_species_rax_rf_scores.txt -a 250_gt_species_rax_rf_scores_avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/species-rax

# bash run-on-simulated-scripts/rfScore-all.sh -s 500_gt_apro-cleaned.tre -o 500_gt_apro_rf_scores.txt -a 500_gt_apro_rf_scores_avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/Apro-3
# bash run-on-simulated-scripts/rfScore-all.sh -s 500-gt-wqfm-tree-per-node-norm.tre -o 500_gt_wqfm_gdl_per_node_norm_rf_scores.txt -a 500_gt_wqfm_gdl_per_node_norm_rf_scores_avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/wQFM-GDL-T
# bash run-on-simulated-scripts/rfScore-all.sh -s 500_gt_species_rax_cleaned.tre -o 500_gt_species_rax_rf_scores.txt -a 500_gt_species_rax_rf_scores_avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/species-rax

# bash run-on-simulated-scripts/rfScore-all.sh -s 1000_gt_apro-cleaned.tre -o 1000_gt_apro_rf_scores.txt -a 1000_gt_apro_rf_scores_avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/Apro-3
# bash run-on-simulated-scripts/rfScore-all.sh -s 1000-gt-wqfm-tree-per-node-norm.tre -o 1000_gt_wqfm_gdl_per_node_norm_rf_scores.txt -a 1000_gt_wqfm_gdl_per_node_norm_rf_scores_avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/wQFM-GDL-T
# bash run-on-simulated-scripts/rfScore-all.sh -s 1000_gt_species_rax_cleaned.tre -o 1000_gt_species_rax_rf_scores.txt -a 1000_gt_species_rax_rf_scores_avg.txt -p /Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/species-rax