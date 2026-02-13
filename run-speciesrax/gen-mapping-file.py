import re
import argparse
from collections import defaultdict

# ----------------------------
# Argument Parsing
# ----------------------------
parser = argparse.ArgumentParser(
    description="Create a mapping file from a Newick gene tree."
)
parser.add_argument(
    "-i", "--input",
    required=True,
    help="Path to input Newick file"
)
parser.add_argument(
    "-o", "--output",
    required=True,
    help="Path to output mapping file"
)

args = parser.parse_args()

input_file = args.input
output_file = args.output

# ----------------------------
# Regex to match taxa:
# Supports:
# A_0_1, B_12_4, 1A_0_0, 12_3_4, etc.
# ----------------------------
TAXA_PATTERN = re.compile(r"\b([A-Za-z0-9]+_\d+_\d+)\b")

# Dictionary to store grouped taxa
grouped = defaultdict(set)

# ----------------------------
# Read Newick File
# ----------------------------
with open(input_file, "r") as f:
    newick = f.read()

# ----------------------------
# Extract & Group Taxa
# ----------------------------
matches = TAXA_PATTERN.findall(newick)

for taxon in matches:
    prefix = taxon.split("_")[0]
    grouped[prefix].add(taxon)

# ----------------------------
# Write Mapping File
# ----------------------------
with open(output_file, "w") as f:
    for prefix in sorted(grouped.keys()):
        joined_taxa = ";".join(sorted(grouped[prefix]))
        f.write(f"{prefix}:{joined_taxa}\n")

print(f"✅ Mapping file written to: {output_file}")
