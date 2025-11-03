fastTreePath=./FastTree
treeCleanerScript=scripts/treeCleaner.py

if [ ! -f "$fastTreePath" ]; then
    echo "FastTree executable not found at $fastTreePath"
    exit 1
fi

inputFile=$1
outputFile=$2
if [ -z "$inputFile" ] || [ -z "$outputFile" ]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

echo "Running FastTree on $inputFile to generate tree in $outputFile"
"$fastTreePath" -gamma -gtr -out "$outputFile" "$inputFile"


if [ $? -ne 0 ]; then
    echo "FastTree failed to generate the tree."
    exit 1
fi

echo "Cleaning the tree using $treeCleanerScript"

python3 "$treeCleanerScript" < "$outputFile" > "${outputFile%.tree}_cleaned.tree"

if [ $? -ne 0 ]; then
    echo "Tree cleaning script failed."
    exit 1
fi

echo "Tree generation and cleaning completed successfully."