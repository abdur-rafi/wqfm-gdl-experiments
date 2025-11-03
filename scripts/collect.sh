n=$2
fileName1=wqfm-tree-pro-scores.txt
fileName2=apro-3-scores.txt
fileName1="${n}-wqfm-tree-scores.txt"
fileName2="${n}-apro-scores.txt"
fileName=$fileName2

writeTo=100taxa/scores/$fileName

# writeTo=./scores_compiled/500.astral.txt
# writeTo=./scores_compiled/200.astral.txt

root=$1
>$writeTo
for file in $(ls $root)
# for file in "1X-500-500"
do
    if [ -d $root/$file ]
    then
        echo $file >> $writeTo

        if [ -d $root/$file ]
        then
            python ./scripts/scoreSep.py < $root/$file/$fileName >> $writeTo
        fi
    fi
done

# /usr/bin/env /usr/lib/jvm/java-17-openjdk-amd64/bin/java -XX:+ShowCodeDetailsInExceptionMessages -cp /home/abdur-rafi/.config/Code/User/workspaceStorage/da91ba3e148e5727246c82da7f9911d2/redhat.java/jdt_ws/E-WQFM_731a4073/bin src.Main 