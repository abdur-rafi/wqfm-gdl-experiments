echo "Starting Disco and subsequent analyses..."
#!/usr/bin/env bash
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
# dupLossSrcPath="/mnt/disk1/wqfm-tree-stuff/ASTER-Linux/bin/astral-pro3"
stripScriptPath="./run-on-simulated-scripts/leafNameStripper.py"

# Files used by runApro3
# dupLossOutputFile="${n}_gt_apro-cleaned.tre"
# discoNoDecomp="${n}-gt-disco-rooted.tre"

input_file="${n}-gt.tre"
output_file="${n}-gt-stripped.tre"

stripDupSuffix(){
    for file in $(ls "$root"); do
        if [[ -d "$root/$file" ]]; then
            echo "$file"
            # skip if outputfile exists and is not empty
            # if [[ -f "$root/$file/$output_file" && -s "$root/$file/$output_file" ]]; then
            #     echo "Skipping $file, $output_file already exists and is not empty."
            #     continue
            # fi
            python scripts/treeCleaner.py < "$root/$file/$input_file" | python "$stripScriptPath" -o "$root/$file/$output_file"
        fi
    done
}
    
echo "Running DupLoss2 on directories under: $root"
stripDupSuffix