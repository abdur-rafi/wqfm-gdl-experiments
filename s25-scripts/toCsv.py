import csv
import sys


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
        if len(values) < 50:
            to_append = ['' for _ in range(50 - len(values))]
            values = values + to_append
        headers.append(header)
        rows.append(values)

    # Transpose rows to match CSV format
    transposed_rows = zip(*rows)

    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(headers)
        writer.writerows(transposed_rows)


def _parse_args():
    import argparse

    parser = argparse.ArgumentParser(description="Convert paired-lines score text file to CSV.")
    parser.add_argument('-i', '--input', required=True, help='Input text file to convert')
    parser.add_argument('-o', '--output', required=True, help='Output CSV file path')
    return parser.parse_args()


if __name__ == '__main__':
    args = _parse_args()
    try:
        convert_to_csv(args.input, args.output)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)



# PREFIX=/Users/abdurrafi/Desktop/thesis/wqfm-gdl-experiments-results/outputs/n25-outputs/rf-scores
# python s25-scripts/toCsv.py -i "$PREFIX/e100_apro-cleaned-rf-scores.txt"                        -o "$PREFIX/e100_apro-cleaned-rf-scores.csv"
# python s25-scripts/toCsv.py -i "$PREFIX/e100_duploss2_unrooted_tree_only_rf_scores.txt"          -o "$PREFIX/e100_duploss2_unrooted_tree_only_rf_scores.csv"
# python s25-scripts/toCsv.py -i "$PREFIX/e500_duploss2_unrooted_tree_only_rf_scores.txt"          -o "$PREFIX/e500_duploss2_unrooted_tree_only_rf_scores.csv"
# python s25-scripts/toCsv.py -i "$PREFIX/e100_species_rax_rf_scores.txt"                           -o "$PREFIX/e100_species_rax_rf_scores.csv"
# python s25-scripts/toCsv.py -i "$PREFIX/e100-wqfm-2020-rf-scores.txt"                             -o "$PREFIX/e100-wqfm-2020-rf-scores.csv"
# python s25-scripts/toCsv.py -i "$PREFIX/e100-wqfm-gdl-per-node-norm-fixed-rf-scores.txt"           -o "$PREFIX/e100-wqfm-gdl-per-node-norm-fixed-rf-scores.csv"
# python s25-scripts/toCsv.py -i "$PREFIX/e500_apro-cleaned-rf-scores.txt"                        -o "$PREFIX/e500_apro-cleaned-rf-scores.csv"
# python s25-scripts/toCsv.py -i "$PREFIX/e500_species_rax_rf_scores.txt"                           -o "$PREFIX/e500_species_rax_rf_scores.csv"
# python s25-scripts/toCsv.py -i "$PREFIX/e500-wqfm-2020-rf-scores.txt"                             -o "$PREFIX/e500-wqfm-2020-rf-scores.csv"
# python s25-scripts/toCsv.py -i "$PREFIX/e500-wqfm-gdl-per-node-norm-fixed-rf-scores.txt"           -o "$PREFIX/e500-wqfm-gdl-per-node-norm-fixed-rf-scores.csv"
