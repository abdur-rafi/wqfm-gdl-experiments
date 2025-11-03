#!/bin/bash
root=$1
geneTreeLabel=$2
geneTreeLabelCleaned="$geneTreeLabel-cleaned.tre"


# clean gene trees
# python ./scripts/treeCleaner.py < $root/$geneTreeLabel > $root/$geneTreeLabelCleaned

# discoOutput="$geneTreeLabelCleaned-disco-decomp.tre"
# discoCleaned="$discoOutput-cleaned.tre"
# discoNoDecomp="$discoOutput-no-decomp.tre"
# discoNoDecompCleaned="$discoNoDecomp-cleaned.tre"

# # # decompose using disco
# disco_output="$root/$discoOutput"
# python3 ./scripts/disco.py -i "$root/$geneTreeLabelCleaned" -o "$disco_output" -d _

# disco_no_decomp="$root/$discoNoDecomp"
# python3 ./scripts/disco.py -i "$root/$geneTreeLabelCleaned" -o "$disco_no_decomp" -d _ --no-decomp

# # # clean disco output
# python ./scripts/treeCleaner.py < $disco_output > $root/$discoCleaned
# python ./scripts/treeCleaner.py < $disco_no_decomp > $root/$discoNoDecompCleaned

wqfmTreeSrcPath="/usr/bin/env /home/system3/anaconda3/bin/java @/tmp/cp_bbv86kpqnn2f2jbh5devg0szf.argfile"
aproSrcPath="/mnt/disk1/wqfm-tree-stuff/ASTER-Linux/bin/astral-pro3"


for tree in "top25" "top50"
do
    consensusTree="Archaea364/consensus-gen/${tree}_cons.greedy.tree"
    output_file="Archaea364/outputs/${tree}_wqfm_tree_pro.tre"

    input_file="Archaea364/${tree}_relabeled.txt-cleaned.tre-disco-decomp.tre-no-decomp.tre-cleaned.tre"
    apro_output_file="Archaea364/outputs/${tree}_apro.tre"

    /usr/bin/env $wqfmTreeSrcPath src.Main \
    "$input_file" \
    "$consensusTree" \
    "$output_file"

    # $aproSrcPath -i $input_file -o $apro_output_file

done

# consensusTree="Archaea364/consensus/top25_true_label.greedy.tree"
# output_file="Archaea364/outputs/top25_wqfm_tree_pro.tre"

# wqfmTreeSrcPath="/usr/bin/env /home/system3/anaconda3/bin/java @/tmp/cp_bbv86kpqnn2f2jbh5devg0szf.argfile"
# aproSrcPath="/mnt/disk1/wqfm-tree-stuff/ASTER-Linux/bin/astral-pro3"

# /usr/bin/env $wqfmTreeSrcPath src.Main \
# "$root/$discoNoDecompCleaned" \
# "$root/$consensusTree" \
# "$output_file"