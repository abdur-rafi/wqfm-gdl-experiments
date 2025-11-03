import os
import sys

def  parse_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    data = []
    for line in lines:
        parts = line.strip().split()
        if len(parts) == 2:
            try:
                name=parts[0]
                rank = parts[1]
            except Exception as e:
                print(f"Error parsing line: {line}. Error: {e}")
                continue
            data.append((name, rank))
        else:
            print(f"Skipping malformed line: {line}")
    return data

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python find_top_n.py <input_file> <rank>")
        sys.exit(1)

    input_file = sys.argv[1]
    target_rank = sys.argv[2]
    if not os.path.isfile(input_file):
        print(f"File not found: {input_file}")
        sys.exit(1)
    data = parse_file(input_file)
    filtered_data = [name for name, rank in data if rank == target_rank]
    # print("Number of entries with rank", target_rank, ":", len(filtered_data))
    for name in filtered_data:
        print(name)