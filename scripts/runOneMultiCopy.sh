input=$1
output=$2

runCmd="/usr/bin/env /usr/lib/jvm/java-17-openjdk-amd64/bin/java  -Xmx64g @/tmp/cp_bbv86kpqnn2f2jbh5devg0szf.argfile src.Main"

# clean input 
cleanedInput=$input.cleaned
# continue if exists
if [ -f $cleanedInput ]; then
    echo "cleaned input already exists"
else
    echo "cleaning input"
    python ./scripts/treeCleaner.py < $input > $cleanedInput
    
fi



# run disco
discoOutput=$input.disco
discoCleaned=$input.disco.cleaned
discoNoDecompOutput=$input.disco.noDecomp
discoNoDecompCleaned=$input.disco.noDecomp.cleaned

if [ -f $discoOutput ]; then
    echo "disco output already exists"
else
    echo "running disco"
    # run disco
    python ./scripts/disco.py -i $cleanedInput -o $discoOutput -d _
    python ./scripts/treeCleaner.py < $discoOutput > $discoCleaned

    # run disco without decomposition
    python ./scripts/disco.py -i $cleanedInput -o $discoNoDecompOutput --no-decomp -d _
    python ./scripts/treeCleaner.py < $discoNoDecompOutput > $discoNoDecompCleaned
fi


consensusOutputPrefix=$input.disco.consensus
consensusTreePath=$consensusOutputPrefix.greedy.tree

if [ -f $consensusTreePath ]; then
    echo "consensus tree already exists"
else
    echo "running consensus"
    perl ./scripts/run_paup_consensus.pl -i $discoCleaned -o $consensusOutputPrefix  > consLog.txt 2>consErr.txt

fi


$runCmd $discoNoDecompCleaned $consensusTreePath $output