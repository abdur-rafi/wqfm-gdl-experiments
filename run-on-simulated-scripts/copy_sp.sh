#  bash run-on-simulated-scripts/copy_sp.sh simulated-new/true simulated-new/estimated
root=$1
copyTo=$2

fileToCopy="s_tree.trees"
for model_cond in $(ls $root); do 
    echo "Processing model condition: $model_cond"
    if [ ! -d "$root/$model_cond" ]; then
        echo "Skipping $model_cond as it is not a directory."
        continue
    fi
    for replicate in $(ls $root/$model_cond); do
        echo "Processing replicate: $replicate"
        if [ ! -d "$root/$model_cond/$replicate" ]; then
            echo "Skipping $replicate as it is not a directory."
            continue
        fi
        mkdir -p "$copyTo/$model_cond/$replicate"
        if [ -f "$root/$model_cond/$replicate/$fileToCopy" ]; then
            echo "Copying $fileToCopy from $root/$model_cond/$replicate to $copyTo/$model_cond/$replicate"
            cp "$root/$model_cond/$replicate/$fileToCopy" "$copyTo/$model_cond/$replicate/"
        else
            echo "File $fileToCopy does not exist in $root/$model_cond/$replicate, skipping."
        fi
    done
done
# for folder in $(ls $root); do
#     if [ -d $root/$folder ]; then
#         if [ -f $root/$folder/$fileToCopy ]; then
#             echo "Copying $fileToCopy from $root/$folder to $copyTo/$folder"
#             mkdir -p $copyTo/$folder
#             cp $root/$folder/$fileToCopy $copyTo/$folder/
#         else
#             echo "File $fileToCopy does not exist in $root/$folder, skipping."
#         fi
#     fi

# done