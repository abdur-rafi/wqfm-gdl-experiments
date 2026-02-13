#!/bin/bash

# Script to recursively copy folder structure and files starting with numbers
# Usage: ./copy-numbered-files.sh <source_folder> <destination_folder>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_folder> <destination_folder>"
    exit 1
fi

SOURCE="$1"
DEST="$2"

# Check if source exists
if [ ! -d "$SOURCE" ]; then
    echo "Error: Source folder '$SOURCE' does not exist"
    exit 1
fi

# Remove trailing slashes
SOURCE="${SOURCE%/}"
DEST="${DEST%/}"

echo "Copying folder structure from '$SOURCE' to '$DEST'"
echo "Keeping only files starting with numbers..."

# Create destination folder if it doesn't exist
mkdir -p "$DEST"

# Find all directories in source and recreate them in destination
find "$SOURCE" -type d | while read -r dir; do
    # Get relative path from source
    rel_path="${dir#$SOURCE}"
    
    # Create corresponding directory in destination
    if [ -n "$rel_path" ]; then
        mkdir -p "$DEST$rel_path"
    fi
done

# Find all files starting with numbers and copy them
find "$SOURCE" -type f | while read -r file; do
    # Get the basename of the file
    filename=$(basename "$file")
    
    # Check if filename starts with a number (0-9)
    if [[ "$filename" =~ ^[0-9] ]]; then
        # Get relative path from source
        rel_path="${file#$SOURCE}"
        
        # Copy file to destination
        cp "$file" "$DEST$rel_path"
        echo "Copied: $rel_path"
    fi
done

echo "Done! Files starting with numbers have been copied to '$DEST'"
