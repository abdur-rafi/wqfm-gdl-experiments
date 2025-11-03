import os
import sys

def get_filename_from_input(line):
    return f"{line.strip()}.aln.treefile_renamed"

def concat_files(input_files, output_file):
    with open(output_file, 'w') as outfile:
        for fname in input_files:
            if os.path.isfile(fname):
                with open(fname, 'r') as infile:
                    outfile.write(infile.read())
                    outfile.write("\n")  # Ensure separation between files
            else:
                print(f"File not found: {fname}")

def remove_empty_lines(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    with open(file_path, 'w') as file:
        for line in lines:
            if line.strip():  # Only write non-empty lines
                file.write(line)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python concat_files.py <files_root> <output_file>")
        sys.exit(1)
    # read from stdin until EOF
    input_files = []
    files_root = sys.argv[1]
    print("Enter file paths to concatenate (one per line). Press Ctrl+D (or Ctrl+Z on Windows) to end input:")
    for line in sys.stdin:
        line = line.strip()
        filename = get_filename_from_input(line)
        input_files.append(os.path.join(files_root, filename))
    

    output_file = sys.argv[2]
    concat_files(input_files, output_file)
    remove_empty_lines(output_file)
    print(f"Concatenated {len(input_files)} files into {output_file} and removed empty lines.")

    
