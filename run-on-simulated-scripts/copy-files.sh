#!/bin/bash

# Script to copy files matching a substring pattern while preserving folder structure
# Usage: ./copy-files-by-pattern.sh <search_string> <source_root> <output_folder>

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <search_string> <source_root> <output_folder>"
    echo "  search_string: substring to match in filenames"
    echo "  source_root: root folder to search in"
    echo "  output_folder: destination folder (will preserve structure)"
    exit 1
fi

SEARCH_STRING="$1"
SOURCE_ROOT="$2"
OUTPUT_FOLDER="$3"

# Check if source root exists
if [ ! -d "$SOURCE_ROOT" ]; then
    echo "Error: Source root '$SOURCE_ROOT' does not exist or is not a directory"
    exit 1
fi

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_FOLDER"

# Convert source root to absolute path
SOURCE_ROOT=$(cd "$SOURCE_ROOT" && pwd)
OUTPUT_FOLDER=$(cd "$OUTPUT_FOLDER" && pwd)

echo "Searching for files containing '$SEARCH_STRING' in $SOURCE_ROOT"
echo "Copying to: $OUTPUT_FOLDER"
echo ""

# Counter for copied files
COUNT=0

# Find all files matching the pattern and copy them
while IFS= read -r -d '' file; do
    # Get the relative path from source root
    RELATIVE_PATH="${file#$SOURCE_ROOT/}"
    
    # Get the directory part of the relative path
    DIR_PATH=$(dirname "$RELATIVE_PATH")
    
    # Create the destination directory
    mkdir -p "$OUTPUT_FOLDER/$DIR_PATH"
    
    # Copy the file
    cp "$file" "$OUTPUT_FOLDER/$RELATIVE_PATH"
    
    if [ $? -eq 0 ]; then
        echo "Copied: $RELATIVE_PATH"
        COUNT=$((COUNT + 1))
    else
        echo "Failed to copy: $RELATIVE_PATH"
    fi
done < <(find "$SOURCE_ROOT" -type f -name "*${SEARCH_STRING}*" -print0)

echo ""
echo "Total files copied: $COUNT"
