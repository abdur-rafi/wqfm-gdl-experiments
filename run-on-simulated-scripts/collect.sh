#!/usr/bin/env bash
fileName1="250-gt-wqfm-tree-per-node-norm.tre"
fileName2="250_gt_apro3-scores.txt"
fileName3="250_gt_species_rax_rf_scores.txt"

# default fileName (can be overridden with -f)
fileName=$fileName3

# writeTo default will be set after parsing flags so it can reflect -f
writeTo=""

usage() {
    echo "Usage: $0 [-f filename] [-w writeto]"
    echo "  -f  filename to read from each condition (default: $fileName)"
    echo "  -w  output file to write aggregated scores to (default: simulated-scores/<filename>)"
    exit 1
}

# parse flags
while getopts ":f:w:h" opt; do
    case $opt in
        f) fileName="$OPTARG" ;;
        w) writeTo="$OPTARG" ;;
        h) usage ;;
        \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
    esac
done

# if writeTo not provided, use default based on fileName
if [ -z "$writeTo" ]; then
    writeTo="simulated-scores/$fileName"
fi

# prefix for paths under which the datasets live
score_prefix="/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/rf-scores"

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

mkdir -p "$(dirname "$writeTo")"
> "$writeTo"

for cond in "${model_conditions[@]}"; do
    echo "Processing $cond"
    full_root="$score_prefix/$cond"
    if [ -d "$full_root" ]; then
        echo "$cond" >> "$writeTo"
        target="$full_root/$fileName"
        if [ -f "$target" ]; then
            python ./scripts/scoreSep.py < "$target" >> "$writeTo"
        else
            echo "Warning: missing $target" >&2
        fi
    else
        echo "Warning: root not found: $full_root" >&2
    fi
done 


# PREFIX=/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/simulated-dataset-outputs/rf-scores

# bash run-on-simulated-scripts/collect.sh -f 250_gt_wqfm_gdl_per_node_norm_rf_scores.txt -w "$PREFIX/250_gt_wqfm_gdl_per_node_norm_rf_scores_collected.txt"
# bash run-on-simulated-scripts/collect.sh -f 250_gt_species_rax_rf_scores.txt -w "$PREFIX/250_gt_species_rax_rf_scores_collected.txt"
# bash run-on-simulated-scripts/collect.sh -f 250_gt_apro_rf_scores.txt -w "$PREFIX/250_gt_apro_rf_scores_collected.txt"

# bash run-on-simulated-scripts/collect.sh -f 500_gt_wqfm_gdl_per_node_norm_rf_scores.txt -w "$PREFIX/500_gt_wqfm_gdl_per_node_norm_rf_scores_collected.txt"
# # bash run-on-simulated-scripts/collect.sh -f 500_gt_species_rax_rf_scores.txt -w "$PREFIX/500_gt_species_rax_rf_scores_collected.txt"
# bash run-on-simulated-scripts/collect.sh -f 500_gt_apro_rf_scores.txt -w "$PREFIX/500_gt_apro_rf_scores_collected.txt"

# bash run-on-simulated-scripts/collect.sh -f 1000_gt_wqfm_gdl_per_node_norm_rf_scores.txt -w "$PREFIX/1000_gt_wqfm_gdl_per_node_norm_rf_scores_collected.txt"
# # bash run-on-simulated-scripts/collect.sh -f 1000_gt_species_rax_rf_scores.txt -w "$PREFIX/1000_gt_species_rax_rf_scores_collected.txt"
# bash run-on-simulated-scripts/collect.sh -f 1000_gt_apro_rf_scores.txt -w "$PREFIX/1000_gt_apro_rf_scores_collected.txt"