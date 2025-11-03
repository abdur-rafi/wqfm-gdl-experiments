# bash ./scripts/recurse25.sh  ../AstralPro/n25 > 25.wqfm.2020.pertree.norm.log
# bash ./scripts/recurse25.sh  ../AstralPro/n25 > 25.true.wqfm.both.log
# bash ./scripts/recurse25.sh  ../AstralPro/n25 >> 25.true.apro.log
# bash ./scripts/recurse25.sh  ../AstralPro/n25 > dup1.log
# bash ./scripts/recurse25.sh  ../AstralPro/n25 > dup2.log
# bash ./scripts/recurse25.sh  ../AstralPro/n25 > dup5.log



root=$1
# copyRoot=$2


# scoreInputFile=e100_wqfm_2020_norm_pertree_scores.txt
# scoreInputFile=e500_wqfm_scores_updated.txt
# scoreInputFile=e500_wqfm_2020_scores.txt
# scoreInputFile=e500_apro_scores.txt
scoreInputFile=e500_apro_scores.txt
scoreInputFile=true_apro_scores.txt

# scoreInputFile=true_wqfm_scores_updated.txt
# scoreInputFile=true_astral_scores.txt


# scoreAggregatedFile=25.wqfm.2020.norm.pertree.scores
# scoreAggregatedFile=25.500bp.wqfm-tree-updated.scores
# scoreAggregatedFile=25.500bp.wqfm.2020.scores
# scoreAggregatedFile=25.500bp.astral.scores
# scoreAggregatedFile=25.true.wqfm.2020.scores
scoreAggregatedFile=25.true.wqfm-tree.scores
scoreAggregatedFile=25.true.apro.scores


> $scoreAggregatedFile
# for k in $(ls $root); do
# for k in k1000 k2500 k10000 ; do
for k in k25 k100 k250 ; do
# for k in k1000 k2500 k10000 ; do
    # for dup in dup5 ; do 
    for dup in $(ls $root/$k); do 
        for loss in $(ls $root/$k/$dup); do
        # for loss in loss1 ; do
            for ils in $(ls $root/$k/$dup/$loss); do
                # echo "$k $dup $loss $ils"
                echo "$root/$k/$dup/$loss/$ils"
                # mkdir -p $copyRoot/$k/$dup/$loss/$ils
                # bash ./scripts/cleangt.sh $root/$k/$dup/$loss/$ils 5
                # bash ./scripts/cleangt.sh $root/$k/$dup/$loss/$ils 5 ../AstralPro/n25/$k/$dup/$loss/$ils
                bash ./scripts/cleangt.sh $root/$k/$dup/$loss/$ils 1
                
                bash ./scripts/runDisco2.sh $root/$k/$dup/$loss/$ils 1

                # ls $root/$k/$dup/$loss/$ils/e100-wqfm-updated.txt
                # echo "$k-$dup-$loss-$ils-true " >> $scoreAggregatedFile
                # python scripts/scoreSep.py < $root/$k/$dup/$loss/$ils/$scoreInputFile >> $scoreAggregatedFile
                # rm $root/$k/$dup/$loss/$ils/$scoreInputFile
                # exit
            done
        done
    done
done