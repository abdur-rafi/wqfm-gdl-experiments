n=$1
root_folder="/mnt/disk1/wqfm-tree-stuff/experiments/100taxa/DOI-10-13012-b2idb-5721322_v1/estimated"
copy_to_folder="/mnt/disk1/wqfm-tree-stuff/experiments/100taxa/DOI-10-13012-b2idb-5721322_v1/consensus"

# file_to_copy=g_trees-with-gt3species-disco-decomp-cleaned.tre
file_to_copy="g_trees-raxml-sqlen-${n}-disco-decomp-cleaned.tre"

# file_to_copy=s_tree-cleaned.tre


for model_condition in $(ls $root_folder); do
    if [ -d $root_folder/$model_condition ]; then
        for replicate in $(ls $root_folder/$model_condition); do
            if [ -d $root_folder/$model_condition/$replicate ]; then
                echo "Processing $model_condition/$replicate"
                mkdir -p $copy_to_folder/$model_condition/$replicate
                cp $root_folder/$model_condition/$replicate/$file_to_copy $copy_to_folder/$model_condition/$replicate/
            fi
        done    
    fi
done