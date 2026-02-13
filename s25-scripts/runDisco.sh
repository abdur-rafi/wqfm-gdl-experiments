# bash ./scripts/runDisco.sh ../astral-pro-10-25/n25/k1000/dup2/loss1/ils70
# bash ./scripts/runDisco.sh ../AstralPro/n25/k1000/dup5/loss1/ils70 1
# bash ./scripts/runDisco.sh ../AstralPro/n250/k1000/dup5/loss1/ils70 1
# bash ./scripts/runDisco.sh ../AstralPro/n25/k1000/dup0/loss0/ils0 1
# bash ./scripts/runDisco.sh ../AstralPro/n10/k1000/dup5/loss1/ils70 1
# bash ./scripts/runDisco.sh ../AstralPro/n500/k1000/dup5/loss1/ils70 5

root=$1
n=$2
speciesTreeLabelCleaned="s_tree-cleaned.tre"

astralOutputFile="e${n}00_apro-cleaned.tre"

trueGeneTreeLabel="true.tre"

geneTreeLabelCleaned="e${n}00-resolved.tre"
# geneTreeLabelCleaned="merged_gene_trees.resolved.tre"
# geneTreeLabelCleaned="g_trees-with-gt3species.resolved.tre"


trueResolved="true.resolved.cleaned.tre"

discoOutput="e${n}00-disco-decomp.tre"
# discoOutput=merged_gene_trees-disco-decomp.tre
# discoOutput=g_trees-with-gt3species-disco-decomp.tre

discoCleaned="e${n}00-disco-decomp-cleaned.tre"
# discoCleaned=merged_gene_trees-disco-decomp-cleaned.tre
# discoCleaned=g_trees-with-gt3species-disco-decomp-cleaned.tre

discoNoDecomp="e${n}00-disco-rooted.tre"
# discoNoDecomp=merged_gene_trees-disco-rooted.tre
# discoNoDecomp=g_trees-with-gt3species-disco-rooted.tre

discoNoDecompCleaned="e${n}00-disco-rooted-cleaned.tre"
# discoNoDecompCleaned=merged_gene_trees-disco-rooted-cleaned.tre
# discoNoDecompCleaned=g_trees-with-gt3species-disco-rooted-cleaned.tre


consensusTreePrefix="e${n}00-consensus"
# consensusTreePrefix=merged_gene_trees-consensus
# consensusTreePrefix=g_trees-with-gt3species-consensus
consensusTree=$consensusTreePrefix.greedy.tree
# consensusTree=cons.greedy.tree


discoOutputTrueGt="true-disco-decomp.tre"
discoCleanedTrueGt="true-disco-decomp-cleaned.tre"
discoNoDecompTrueGt="true-disco-rooted.tre"
discoNoDecompCleanedTrueGt="true-disco-rooted-cleaned.tre"
consensusTreePrefixTrueGt="true-consensus"
consensusTreeTrueGt=$consensusTreePrefixTrueGt.greedy.tree


# consensusTree=$astralOutputFile
# consensusTree=$speciesTreeLabelCleaned
outputFile="e${n}00-wqfm-gdl.tre"
# outputFile="merged_gene_trees-wqfm-tree.tre"
# outputFile="g_trees-with-gt3species-wqfm-tree.tre"

outputFileApro="merged_gene_trees-apro.tre"
outputFileApro="g_trees-with-gt3species-apro.tre"

outputFileTrue="true-wqfm-tree-updated.tre"
outputFileTrue="true-wqfm-tree-sp.tre"

aproTrueOutputFile="apro_true.tre"
# wqfm2020OutputFile="e${n}00-wqfm-2020-norm-perTree.tre"
wqfm2020OutputFile="e${n}00-wqfm-2020.tre"
wqfm2020OutputFileTrue="true-wqfm-2020.tre"
# quartetFile=sqQuartetsNormedPerTree.txt
quartetFile=sqQuartets.txt
quartetFileTrue=sqQuartetsTrue.txt
# outputFile="e${n}00-wqfm-with-sp.tre"
wscores="e${n}00_wqfm_scores_updated.txt"
wscores="e${n}00_wqfm_tree_sp.txt"
wscores="wqfm-tree-pro-scores.txt"
wscores="wqfm-tree-gdl-scores.txt"

ascores="apro-3-scores.txt"

wscoresTrue="true_wqfm_scores_updated.txt"
wscoresTrue="true_wqfm_tree_sp.txt"

# wscores="e${n}00_wqfm_scores.txt"
# w2020scores="e${n}00_wqfm_2020_norm_pertree_scores.txt"
w2020scores="e${n}00_wqfm_2020_scores.txt"
w2020scoresTrue="true_wqfm_2020_scores.txt"
wscoresAvg="avg-$wscores"
wscoresAvgTrue="avg-$wscoresTrue"
w2020scoresAvgTrue="avg-$w2020scoresTrue"

ascoresAvg="avg-$ascores"




# wqfmTreeSrcPath="/usr/lib/jvm/java-17-openjdk-amd64/bin/java @/tmp/cp_bbv86kpqnn2f2jbh5devg0szf.argfile"
wqfmTreeSrcPath="/usr/bin/env /home/system3/anaconda3/bin/java @/tmp/cp_bbv86kpqnn2f2jbh5devg0szf.argfile"
wqfmTreeSrcPath="/usr/bin/env /home/system3/anaconda3/bin/java -XX:+ShowCodeDetailsInExceptionMessages -cp /home/system3/.config/Code/User/workspaceStorage/30aa6bf12ee6fa01d2c267d76a0405f2/redhat.java/jdt_ws/wQFM-GDL_da4af3e7/bin"
aproSrcPath="/mnt/disk1/wqfm-tree-stuff/ASTER-Linux/bin/astral-pro3"
# create a function


runDiscoAndCreateCons() {
    for file in $(ls "$root"); do
        if [ -d "$root/$file" ]; then
            echo "$file"

            # Define output file paths for clarity and reusability
            local disco_output="$root/$file/$discoOutput"
            local disco_cleaned="$root/$file/$discoCleaned"
            # Assuming consensusTreePrefix leads to a full path for the consensus tree file
            # You'll need to define how $consensusTreePrefix and the eventual filename combine.
            # For this example, let's assume $consensusTree is the full path to the consensus file.
            local consensus_tree_output=$root/$file/"$consensusTree" # This variable needs to be defined outside or within the loop if it changes per 'file'
            local disco_no_decomp="$root/$file/$discoNoDecomp"
            local disco_no_decomp_cleaned="$root/$file/$discoNoDecompCleaned"

            # Check and skip disco.py
            if [ ! -f "$disco_output" ]; then
                python3 ./scripts/disco.py -i "$root/$file/$geneTreeLabelCleaned" -o "$disco_output" -d _
            else
                echo "Skipping disco.py for $file: $disco_output already exists."
            fi

            # Check and skip treeCleaner.py for disco output
            if [ ! -f "$disco_cleaned" ]; then
                python3 ./scripts/treeCleaner.py < "$disco_output" > "$disco_cleaned"
            else
                echo "Skipping treeCleaner.py for $file (disco): $disco_cleaned already exists."
            fi

            # Check and skip perl ./scripts/run_paup_consensus.pl
            # As per the prompt, assume $consensusTree holds the full path to the output of this perl script.
            if [ ! -f "$consensus_tree_output" ]; then
                perl ./scripts/run_paup_consensus.pl -i "$disco_cleaned" -o "$root/$file/$consensusTreePrefix" > consLog.txt 2>consErr.txt
            else
                echo "Skipping run_paup_consensus.pl for $file: $consensus_tree_output already exists."
            fi

            # Check and skip disco.py --no-decomp
            if [ ! -f "$disco_no_decomp" ]; then
                python3 ./scripts/disco.py -i "$root/$file/$geneTreeLabelCleaned" -o "$disco_no_decomp" -d _ --no-decomp
            else
                echo "Skipping disco.py --no-decomp for $file: $disco_no_decomp already exists."
            fi

            # Check and skip treeCleaner.py for discoNoDecomp output
            if [ ! -f "$disco_no_decomp_cleaned" ]; then
                python3 ./scripts/treeCleaner.py < "$disco_no_decomp" > "$disco_no_decomp_cleaned"
            else
                echo "Skipping treeCleaner.py for $file (discoNoDecomp): $disco_no_decomp_cleaned already exists."
            fi

            # break # Uncomment this if you want to process only the first directory
        fi
    done
}

runDiscoAndCreateConsTrueGT() {
    for file in $(ls $root); do
        if [ -d $root/$file ]; then
            echo $file
            # continue if file less than 31
            
            python3 ./scripts/disco.py -i $root/$file/$trueResolved -o $root/$file/$discoOutputTrueGt -d _
            python3 ./scripts/treeCleaner.py < $root/$file/$discoOutputTrueGt > $root/$file/$discoCleanedTrueGt
            perl ./scripts/run_paup_consensus.pl -i $root/$file/$discoCleanedTrueGt -o $root/$file/$consensusTreePrefixTrueGt > consLog.txt 2>consErr.txt
            python3 ./scripts/disco.py -i $root/$file/$trueResolved -o $root/$file/$discoNoDecompTrueGt -d _ --no-decomp
            python3 ./scripts/treeCleaner.py < $root/$file/$discoNoDecompTrueGt > $root/$file/$discoNoDecompCleanedTrueGt


            # break
        fi

    done
}

runApro3(){
    for file in $(ls $root); do
        if [[ -d $root/$file ]]; then
            echo $file
            # continue if outputfile exists and is not empty
            if [[ -f $root/$file/$astralOutputFile && -s $root/$file/$astralOutputFile ]]; then
                echo "Skipping $file, $astralOutputFile already exists and is not empty."
                continue
            fi
            $aproSrcPath -i $root/$file/$discoNoDecomp -o $root/$file/$astralOutputFile
        fi
    done
}

runWqfmTree(){
    for file in $(ls "$root"); do
        if [[ -d "$root/$file" ]]; then
            echo "$file"

            # Define the output file path for the current iteration
            local output_file="$root/$file/$outputFile"

            # Check if the output file already exists and is not empty
            # if [ -s "$output_file" ]; then
            #     echo "Skipping WQFM Tree for $file: Output '$output_file' already exists and is not empty."
            # else
                echo "Running WQFM Tree for $file..."
                # Execute the WQFM Tree command
                /usr/bin/env $wqfmTreeSrcPath src.Main \
                "$root/$file/$discoNoDecompCleaned" \
                "$root/$file/$consensusTree" \
                "$output_file"
            # fi
        fi
    done
}

runWqfmTreeWithSpTree(){
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
            /usr/bin/env $wqfmTreeSrcPath src.Main \
            $root/$file/$discoNoDecompCleaned \
            $root/$file/$speciesTreeLabelCleaned \
            $root/$file/$outputFile 

            rfScoreWqfm
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
            /usr/bin/env $wqfmTreeSrcPath src.Main \
            $root/$file/$discoNoDecompCleanedTrueGt \
            $root/$file/$consensusTreeTrueGt \
            $root/$file/$outputFileTrue

            # break;
        fi
    done
}


runWqfmTreeTrueGtWithSp(){
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
            /usr/bin/env $wqfmTreeSrcPath src.Main \
            $root/$file/$discoNoDecompCleanedTrueGt \
            $root/$file/$speciesTreeLabelCleaned \
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


rfScoreApro3(){
    
    > $root/$ascores
    > $root/$ascoresAvg
    

    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            echo $file
            python3 ./rfScoreCalculator/getFpFn.py -e $root/$file/$astralOutputFile -t $root/$file/$speciesTreeLabelCleaned >> $root/$ascores
            # break
        fi

    done

    python3 ./scripts/rfAverager.py < $root/$ascores > $root/$ascoresAvg
}

rfScoreWqfm(){

    > $root/$wscores
    > $root/$wscoresAvg
    

    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            echo $file
            python3 ./rfScoreCalculator/getFpFn.py -e $root/$file/$outputFile -t $root/$file/$speciesTreeLabelCleaned >> $root/$wscores
            # break
        fi

    done

    python3 ./scripts/rfAverager.py < $root/$wscores > $root/$wscoresAvg
}


rfScoreWqfmTrueGt(){

    > $root/$wscoresTrue
    > $root/$wscoresAvgTrue
    

    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            echo $file
            python3 ./rfScoreCalculator/getFpFn.py -e $root/$file/$outputFileTrue -t $root/$file/$speciesTreeLabelCleaned >> $root/$wscoresTrue
            # break
        fi

    done

    python3 ./scripts/rfAverager.py < $root/$wscores > $root/$wscoresAvgTrue
}


rfScoreWqfm2020(){

    > $root/$w2020scores
    > $root/$w2020scoresAvg
    

    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            # echo $file
            python3 ./rfScoreCalculator/getFpFn.py -e $root/$file/$wqfm2020OutputFile -t $root/$file/$speciesTreeLabelCleaned >> $root/$w2020scores
            # break
        fi

    done

    python3 ./scripts/rfAverager.py < $root/$w2020scores > $root/$w2020scoresAvg
    python3 ./scripts/rfAverager.py < $root/$w2020scores
}


rfScoreWqfm2020TrueGt(){

    > $root/$w2020scoresTrue
    > $root/$w2020scoresAvgTrue
    

    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            # echo $file
            python3 ./rfScoreCalculator/getFpFn.py -e $root/$file/$wqfm2020OutputFileTrue -t $root/$file/$speciesTreeLabelCleaned >> $root/$w2020scoresTrue
            # break
        fi

    done

    python3 ./scripts/rfAverager.py < $root/$w2020scoresTrue > $root/$w2020scoresAvgTrue
    python3 ./scripts/rfAverager.py < $root/$w2020scoresTrue
}



generateSqQuartets(){
    for file in $(ls $root); do

    # check if $file is a directory
        if [ -d $root/$file ]; then
            echo $file
            # python3 ./scripts/arb_resolve_polytomies.py $root/$file/$geneTreeLabelCleaned
            # python3 ./scripts/treeCleaner.py < $root/$file/$geneTreeLabelCleaned.resolved > $root/$file/$resolved
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
            # python3 ./scripts/arb_resolve_polytomies.py $root/$file/$geneTreeLabelCleaned
            # python3 ./scripts/treeCleaner.py < $root/$file/$geneTreeLabelCleaned.resolved > $root/$file/$resolved
            # java -jar -Xmx60g genSQNorm-v2.jar $root/$file/$discoNoDecompCleaned > $root/$file/$quartetFile
            java -jar -Xmx60g genSQ.jar $root/$file/$discoNoDecompCleanedTrueGt > $root/$file/$quartetFileTrue
            # rm $root/$file/$quartetFile
            # break
        fi

    done
}


# runAproTrueGt(){
#     for file in $(ls $root); do

#     # check if $file is a directory
#         if [ -d $root/$file ]; then
#             echo $file
#             java  -Xmx60g -D"java.library.path=apro/lib" -jar apro/astral.1.1.6.jar -i $root/$file/$trueGeneTreeLabel -o $root/$file/$aproTrueOutputFile  
#         fi

#     done
# }

runAproTrueGt(){
    for file in $(ls "$root"); do
        if [ "$file" -lt 15 ]; then
            continue
        fi
        echo "$file"
        java -Xmx60g -D"java.library.path=apro/lib" -jar apro/astral.1.1.6.jar -i "$root/$file/$trueGeneTreeLabel" -o "$root/$file/$aproTrueOutputFile"
    done
}


# runApro3

# runWqfmTree
# generateSqQuartets
# runWqfm2020
# rfScoreWqfm2020
runDiscoAndCreateCons
runWqfmTree
rfScoreWqfm
# 
# runDiscoAndCreateConsTrueGT
# generateSqQuartetsTrueGt
# runWqfm2020TrueGt
# runWqfmTreeTrueGt
# rfScoreWqfm2020TrueGt
# rfScoreWqfmTrueGt
# runAproTrueGt


# runWqfmTreeWithSpTree

# rfScoreWqfm
# rfScoreApro3


# runWqfmTreeTrueGtWithSp
# rfScoreWqfmTrueGt