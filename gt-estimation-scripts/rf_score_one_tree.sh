est_file=$1
true_file=$2

rf_calculator_script="./rfScoreCalculator/getFpFn.py"
rename_script="gt-estimation-scripts/rename.py"

if [ -z "$est_file" ] || [ -z "$true_file" ]; then
    echo "Usage: $0 <est_file> <true_file>"
    exit 1
fi
if [ ! -f "$est_file" ]; then
    echo "The specified EST file does not exist: $est_file"
    exit 1
fi
if [ ! -f "$true_file" ]; then
    echo "The specified true file does not exist: $true_file"
    exit 1
fi

# create a temporary file for the renamed EST file
temp_file=tmp_est_file_$(date +%s).trees
# sed 's/_/a/g' "$est_file" > "$temp_file"

temp_mapping_file=tmp_mapping_file_$(date +%s).txt

python3 "$rename_script" relabel -i "$est_file" -o "$temp_file" -m "$temp_mapping_file"

# check if the rename script ran successfully
if [ $? -ne 0 ]; then
    echo "Renaming script failed."
    exit 1
fi

# do the same for the output file
temp_true_file=tmp_true_file_$(date +%s).trees
python3 "$rename_script" apply-map -i "$true_file" -o "$temp_true_file" -m "$temp_mapping_file"

# run the RF calculator script
python3 "$rf_calculator_script" -e "$temp_file" -t "$temp_true_file"


# check if the script ran successfully
if [ $? -ne 0 ]; then
    echo "RF score calculation failed."
    exit 1
fi
# echo "RF score calculation completed successfully. Results saved to $true_file"

# clean up temporary files
rm "$temp_file" "$temp_true_file" "$temp_mapping_file"
# exit with success
exit 0