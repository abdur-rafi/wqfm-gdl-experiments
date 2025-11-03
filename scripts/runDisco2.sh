# bash ./scripts/runDisco.sh ../astral-pro-10-25/n25/k1000/dup2/loss1/ils70
# bash ./scripts/runDisco.sh ../AstralPro/n25/k1000/dup5/loss1/ils70 1
# bash ./scripts/runDisco.sh ../AstralPro/n25/k1000/dup0/loss0/ils0 1
# bash ./scripts/runDisco.sh ../AstralPro/n10/k1000/dup5/loss1/ils70 1
# bash ./scripts/runDisco.sh ../AstralPro/n500/k1000/dup5/loss1/ils70 5
# bash ./scripts/runDisco2.sh ../


root=$1
n=$2
speciesTreeLabelCleaned="s_tree-cleaned.tre"
speciesTreeLabelCleaned="cleaned_species_tree.tre"

astralOutputFile="e${n}00_apro-cleaned.tre"
trueGeneTreeLabel="true.tre"
geneTreeLabelCleaned="e${n}00-resolved.tre"
geneTreeLabelCleaned="cleaned_gene_trees.tre"

trueResolved="true.resolved.cleaned.tre"

discoOutput="e${n}00-disco-decomp.tre"
discoOutput="simulated.disco.tre"
discoCleaned="e${n}00-disco-decomp-cleaned.tre"
discoCleaned="simulated.disco-cleaned.tre"
discoNoDecomp="e${n}00-disco-rooted.tre"
discoNoDecomp="simulated.disco-rooted.tre"
discoNoDecompCleaned="e${n}00-disco-rooted-cleaned.tre"
discoNoDecompCleaned="simulated.disco-rooted-cleaned.tre"
consensusTreePrefix="e${n}00-consensus"
consensusTreePrefix="simulated-consensus"
consensusTree=$consensusTreePrefix.greedy.tree



discoOutputTrueGt="true-disco-decomp.tre"
discoCleanedTrueGt="true-disco-decomp-cleaned.tre"
discoNoDecompTrueGt="true-disco-rooted.tre"
discoNoDecompCleanedTrueGt="true-disco-rooted-cleaned.tre"
consensusTreePrefixTrueGt="true-consensus"
consensusTreeTrueGt=$consensusTreePrefixTrueGt.greedy.tree

# consensusTree=$astralOutputFile
# consensusTree=$speciesTreeLabelCleaned
outputFile="e${n}00-updated.tre"
outputFile="simulated-wqfm-tree.tre"
outputFileTrue="true-wqfm-tree-updated.tre"
aproOutputFile="apro.tre"
aproOutputFileCleaned="apro-cleaned.tre"
aproOutputFileLabelFixed="apro-label-fixed.tre"
aproTrueOutputFile="apro_true.tre"
# wqfm2020OutputFile="e${n}00-wqfm-2020-norm-perTree.tre"
wqfm2020OutputFile="e${n}00-wqfm-2020.tre"
wqfm2020OutputFileTrue="true-wqfm-2020.tre"
# quartetFile=sqQuartetsNormedPerTree.txt
quartetFile=sqQuartets.txt
quartetFileTrue=sqQuartetsTrue.txt
# outputFile="e${n}00-wqfm-with-sp.tre"
wscores="e${n}00_wqfm_scores_updated.txt"
wscores="simulated_wqfm_scores.txt"
wscoresTrue="true_wqfm_scores_updated.txt"
aproscores="apro_scores.txt"

# wscores="e${n}00_wqfm_scores.txt"
# w2020scores="e${n}00_wqfm_2020_norm_pertree_scores.txt"
w2020scores="e${n}00_wqfm_2020_scores.txt"
w2020scoresTrue="true_wqfm_2020_scores.txt"
wscoresAvg="avg-$wscores"
wscoresAvgTrue="avg-$wscoresTrue"

w2020scoresAvgTrue="avg-$w2020scoresTrue"

aproscoresAvg="avg-$aproscores"

aproSrcPath="/mnt/disk1/wqfm-tree-stuff/ASTER-Linux/bin/astral-pro3"

# create a function
runDiscoAndCreateCons() {
    for file in $(ls $root); do
        if [ -d $root/$file ]; then
            echo $file
            # continue if file less than 31
            
            python ./scripts/disco.py -i $root/$file/$geneTreeLabelCleaned -o $root/$file/$discoOutput -d _
            python ./scripts/treeCleaner.py < $root/$file/$discoOutput > $root/$file/$discoCleaned
            perl ./scripts/run_paup_consensus.pl -i $root/$file/$discoCleaned -o $root/$file/$consensusTreePrefix > consLog.txt 2>consErr.txt
            python ./scripts/disco.py -i $root/$file/$geneTreeLabelCleaned -o $root/$file/$discoNoDecomp -d _ --no-decomp
            python ./scripts/treeCleaner.py < $root/$file/$discoNoDecomp > $root/$file/$discoNoDecompCleaned


            # break
        fi

    done
}

runDiscoAndCreateConsTrueGT() {
    for file in $(ls $root); do
        if [ -d $root/$file ]; then
            echo $file
            # continue if file less than 31
            
            # python ./scripts/disco.py -i $root/$file/$trueResolved -o $root/$file/$discoOutputTrueGt -d _
            # python ./scripts/treeCleaner.py < $root/$file/$discoOutputTrueGt > $root/$file/$discoCleanedTrueGt
            perl ./scripts/run_paup_consensus.pl -i $root/$file/$discoCleanedTrueGt -o $root/$file/$consensusTreePrefixTrueGt > consLog.txt 2>consErr.txt
            # python ./scripts/disco.py -i $root/$file/$trueResolved -o $root/$file/$discoNoDecompTrueGt -d _ --no-decomp
            # python ./scripts/treeCleaner.py < $root/$file/$discoNoDecompTrueGt > $root/$file/$discoNoDecompCleanedTrueGt


            # break
        fi

    done
}

prepAproOutputForRfCalculation(){
    for file in $(ls $root); do
        if [ -d $root/$file ]; then
            echo $file
            # continue if file less than 31
            python ./scripts/treeCleaner.py < $root/$file/$aproOutputFile > $root/$file/$aproOutputFileCleaned
            # python ./scripts/disco.py -i $root/$file/$aproOutputFileCleaned -o $root/$file/temp.tre -d _ --no-decomp
            # python ./scripts/treeCleaner.py < $root/$file/temp.tre > $root/$file/$aproOutputFileLabelFixed
            # break
        fi

    done
}

rfScoreApro3(){
    > $root/$aproscores
    > $root/$aproscoresAvg
    

    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            echo $file
            python ./rfScoreCalculator/getFpFn.py -e $root/$file/$aproOutputFileCleaned -t $root/$file/$speciesTreeLabelCleaned >> $root/$aproscores
            # break
        fi

    done

    python ./scripts/rfAverager.py < $root/$aproscores > $root/$aproscoresAvg
}


runWqfmTree(){
    for file in $(ls $root); do
        if [[ -d $root/$file ]]; then
            echo $file
            
            # if [ "$file" -lt 4 ]; then
            #     continue
            # fi
            # /usr/bin/env /usr/lib/jvm/java-11-openjdk-amd64/bin/java @/tmp/cp_8ydn8rvu0b5v0bzf1np8e9l5p.argfile src.Main \
            # /usr/bin/env /usr/lib/jvm/java-17-openjdk-amd64/bin/java -XX:+ShowCodeDetailsInExceptionMessages \
            # -cp /home/abdur-rafi/.config/Code/User/workspaceStorage/da91ba3e148e5727246c82da7f9911d2/redhat.java/jdt_ws/E-WQFM_731a4073/bin \
            # src.Main \
            # /usr/bin/env /usr/lib/jvm/java-11-openjdk-amd64/bin/java @/tmp/cp_6k5sgswqypnoi0yc4hoco19yx.argfile src.Main \
            /usr/bin/env /usr/lib/jvm/java-17-openjdk-amd64/bin/java @/tmp/cp_1smuutukx4hyf8tpkrvefswli.argfile src.Main \
            $root/$file/$discoNoDecompCleaned \
            $root/$file/$consensusTree \
            $root/$file/$outputFile 

            # break;
        fi
    done
}

runWqfmTreeTrueGt(){
    for file in $(ls $root); do
        if [[ -d $root/$file ]]; then
            echo $file
            
            # if [ "$file" -lt 4 ]; then
            #     continue
            # fi
            # /usr/bin/env /usr/lib/jvm/java-11-openjdk-amd64/bin/java @/tmp/cp_8ydn8rvu0b5v0bzf1np8e9l5p.argfile src.Main \
            # /usr/bin/env /usr/lib/jvm/java-17-openjdk-amd64/bin/java -XX:+ShowCodeDetailsInExceptionMessages \
            # -cp /home/abdur-rafi/.config/Code/User/workspaceStorage/da91ba3e148e5727246c82da7f9911d2/redhat.java/jdt_ws/E-WQFM_731a4073/bin \
            # src.Main \
            /usr/bin/env /usr/lib/jvm/java-11-openjdk-amd64/bin/java @/tmp/cp_6vv6mff86vhzzrx9d5o7x9var.argfile src.Main \
            $root/$file/$discoNoDecompCleanedTrueGt \
            $root/$file/$consensusTreeTrueGt \
            $root/$file/$outputFileTrue

            # break;
        fi
    done
}


runWqfm2020(){
    for file in $(ls $root); do
        if [ -d $root/$file ]; then
            echo $file
            
            # if [ $file -lt 21 ]; then
            #     continue
            # fi
            java -jar wQFM-v1.4.jar -i $root/$file/$quartetFile -o $root/$file/$wqfm2020OutputFile

            # break;
        fi
    done
}

runWqfm2020TrueGt(){
    for file in $(ls $root); do
        if [ -d $root/$file ]; then
            echo $file
            
            # if [ $file -lt 21 ]; then
            #     continue
            # fi
            java -jar wQFM-v1.4.jar -i $root/$file/$quartetFileTrue -o $root/$file/$wqfm2020OutputFileTrue

            # break;
        fi
    done
}

rfScoreWqfm(){

    > $root/$wscores
    > $root/$wscoresAvg
    

    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            echo $file
            python ./rfScoreCalculator/getFpFn.py -e $root/$file/$outputFile -t $root/$file/$speciesTreeLabelCleaned >> $root/$wscores
            # break
        fi

    done

    python ./scripts/rfAverager.py < $root/$wscores > $root/$wscoresAvg
}

rfScoreApro(){

    > $root/$aproscores
    > $root/$aproscoresAvg
    

    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            echo $file
            python ./rfScoreCalculator/getFpFn.py -e $root/$file/$aproOutputFile -t $root/$file/$speciesTreeLabelCleaned >> $root/$aproscores
            # break
        fi

    done

    python ./scripts/rfAverager.py < $root/$aproscores > $root/$aproscoresAvg
}


rfScoreWqfmTrueGt(){

    > $root/$wscoresTrue
    > $root/$wscoresAvgTrue
    

    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            echo $file
            python ./rfScoreCalculator/getFpFn.py -e $root/$file/$outputFileTrue -t $root/$file/$speciesTreeLabelCleaned >> $root/$wscoresTrue
            # break
        fi

    done

    python ./scripts/rfAverager.py < $root/$wscores > $root/$wscoresAvgTrue
}


rfScoreWqfm2020(){

    > $root/$w2020scores
    > $root/$w2020scoresAvg
    

    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            # echo $file
            python ./rfScoreCalculator/getFpFn.py -e $root/$file/$wqfm2020OutputFile -t $root/$file/$speciesTreeLabelCleaned >> $root/$w2020scores
            # break
        fi

    done

    python ./scripts/rfAverager.py < $root/$w2020scores > $root/$w2020scoresAvg
    python ./scripts/rfAverager.py < $root/$w2020scores
}


rfScoreWqfm2020TrueGt(){

    > $root/$w2020scoresTrue
    > $root/$w2020scoresAvgTrue
    

    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            # echo $file
            python ./rfScoreCalculator/getFpFn.py -e $root/$file/$wqfm2020OutputFileTrue -t $root/$file/$speciesTreeLabelCleaned >> $root/$w2020scoresTrue
            # break
        fi

    done

    python ./scripts/rfAverager.py < $root/$w2020scoresTrue > $root/$w2020scoresAvgTrue
    python ./scripts/rfAverager.py < $root/$w2020scoresTrue
}


generateSqQuartets(){
    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            echo $file
            # python ./scripts/arb_resolve_polytomies.py $root/$file/$geneTreeLabelCleaned
            # python ./scripts/treeCleaner.py < $root/$file/$geneTreeLabelCleaned.resolved > $root/$file/$resolved
            # java -jar -Xmx60g genSQNorm-v2.jar $root/$file/$discoNoDecompCleaned > $root/$file/$quartetFile
            java -jar -Xmx60g genSQ.jar $root/$file/$discoNoDecompCleaned > $root/$file/$quartetFile
            # rm $root/$file/$quartetFile
            # break
        fi

    done
}

generateSqQuartetsTrueGt(){
    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            echo $file
            # python ./scripts/arb_resolve_polytomies.py $root/$file/$geneTreeLabelCleaned
            # python ./scripts/treeCleaner.py < $root/$file/$geneTreeLabelCleaned.resolved > $root/$file/$resolved
            # java -jar -Xmx60g genSQNorm-v2.jar $root/$file/$discoNoDecompCleaned > $root/$file/$quartetFile
            java -jar -Xmx60g genSQ.jar $root/$file/$discoNoDecompCleanedTrueGt > $root/$file/$quartetFileTrue
            
            # rm $root/$file/$quartetFile
            # break
        fi

    done
}

runApro(){
    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            # if [ "$file" -lt 05 ]; then
            #         continue
            # fi
            echo $file
            # java -Xmx60g -D"java.library.path=apro/lib" -jar apro/astral.1.1.6.jar -i $root/$file/$geneTreeLabelCleaned -o $root/$file/$aproOutputFile  
            # ./ASTER-Linux/bin/astral-pro3 -i $root/$file/$geneTreeLabelCleaned -o $root/$file/$aproOutputFile
            $aproSrcPath -i $root/$file/$discoNoDecomp -o $root/$file/$aproOutputFile  

        fi

    done
}



runAproTrueGt(){
    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            echo $file
            # java -D"java.library.path=apro/lib" -jar apro/astral.1.1.6.jar -i $root/$file/$trueGeneTreeLabel -o $root/$file/$aproTrueOutputFile  
            ./ASTER-Linux/bin/astral-pro3 -i $root/$file/$trueGeneTreeLabel -o $root/$file/$aproTrueOutputFile  

        fi

    done
}

# runWqfmTree
# runDiscoAndCreateCons
# generateSqQuartets
# runWqfm2020
# rfScoreWqfm2020
# runWqfmTree
# rfScoreWqfm
# 
# runDiscoAndCreateConsTrueGT
# generateSqQuartetsTrueGt
# runWqfm2020TrueGt
# runWqfmTreeTrueGt
# rfScoreWqfm2020TrueGt
# rfScoreWqfmTrueGt
# runAproTrueGt

runApro
# rfScoreApro
prepAproOutputForRfCalculation
rfScoreApro3