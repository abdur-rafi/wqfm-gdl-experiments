import csv

def convert_to_csv(input_file, output_file):
    with open(input_file, 'r') as f:
        lines = f.readlines()
    
    # Ensure the file has an even number of lines
    if len(lines) % 2 != 0:
        raise ValueError("The input file must have an even number of lines.")
    
    headers = []
    rows = []
    
    for i in range(0, len(lines), 2):
        header = lines[i].strip()
        values = lines[i+1].strip().split(',')
        if lines[i+1].strip() == '':
            values = ['' for i in range(50)]
        headers.append(header)
        rows.append(values)
    
    # Transpose rows to match CSV format
    transposed_rows = zip(*rows)
    
    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(headers)
        writer.writerows(transposed_rows)

# Example usage
n=250
method="wqfm-tree"
output_filename = f"100taxa/scores/{n}-{method}-scores.csv"  # Change to your desired output file
input_filename = f"100taxa/scores/{n}-{method}-scores.txt"  # Change to your actual input file
# output_filename = output_filename + ".csv"

convert_to_csv(input_filename, output_filename)
