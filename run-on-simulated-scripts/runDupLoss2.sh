#!/usr/bin/env bash
echo "Starting Disco and subsequent analyses..."
set -euo pipefail

# Minimal script keeping only variables and function needed for runApro3
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <root_dir> <n>" >&2
    echo "Example: $0 /path/to/root 100" >&2
    exit 2
fi

root=$1
n=$2

# Path to Astral-Pro executable
dupLossSrcPath="./DupLoss-2.out"

# Files used by runApro3
dupLossOutputFile="${n}_gt_duploss2_unrooted.tre"
discoNoDecomp="${n}-gt-stripped.tre"

runDupLoss2(){
    for file in $(ls "$root"); do
        if [[ -d "$root/$file" ]]; then
            echo "$file"
            # skip if outputfile exists and is not empty
            if [[ -f "$root/$file/$dupLossOutputFile" && -s "$root/$file/$dupLossOutputFile" ]]; then
                echo "Skipping $file, $dupLossOutputFile already exists and is not empty."
                continue
            fi
            "$dupLossSrcPath" -i "$root/$file/$discoNoDecomp" -o "$root/$file/$dupLossOutputFile"
        fi
    done
}
    
echo "Running DupLoss2 on directories under: $root"
runDupLoss2