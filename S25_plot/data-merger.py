import os
import pandas as pd
import re

# Directory containing your CSV files
input_dir = "./csv_files/"
output_file = "merged_for_plot.csv"

# Function to extract metadata from column names
def parse_column(col_name):
    """
    Extract DupRate, LossRate, ILS, K (alignment length) from a string like:
    'n25/k1000/dup0.2/loss0.5/ils70'
    """
    parts = col_name.split('/')
    if len(parts) < 2:
        parts = col_name.split('-')
    info = {}
    for p in parts:
        if p.startswith('dup'):
            info['DupRate'] = p.replace('dup', '')
        elif p.startswith('loss'):
            info['LossRate'] = p.replace('loss', '')
        elif p.startswith('ils'):
            info['ILS'] = p.replace('ils', '')
        elif p.startswith('k'):
            info['K'] = p.replace('k', '')
    return info

# Function to infer Method and InputType from filename
def parse_filename(filename):
    """
    Assumes filenames like: MulRF_100bp.csv, A-Pro_true.csv etc.
    """
    name = os.path.splitext(filename)[0]
    parts = name.split('_')
    Method = parts[0]
    InputType = parts[1] if len(parts) > 1 else ''
    # Map input to expected labels
    if InputType == "100bp":
        InputType = "Input: Est. (100bp)"
    elif InputType == "500bp":
        InputType = "Input: Est. (500bp)"
    elif InputType.lower() == "true":
        InputType = "Input: true"
    return Method, InputType

# Final dataframe
all_data = []

for file in os.listdir(input_dir):
    if not file.endswith(".csv"):
        continue

    filepath = os.path.join(input_dir, file)
    Method, InputType = parse_filename(file)

    df = pd.read_csv(filepath)

    long_df = df.melt(var_name="Condition", value_name="Error")
    long_df["Method"] = Method
    long_df["InputType"] = InputType

    meta = long_df["Condition"].apply(parse_column).apply(pd.Series)
    long_df = pd.concat([long_df, meta], axis=1)

    final_df = long_df.dropna(subset=["DupRate", "LossRate"])
    all_data.append(final_df)

merged_df = pd.concat(all_data, ignore_index=True)

# print(merged_df.head())

# Convert numeric fields
for col in ["DupRate", "LossRate", "ILS", "K", "Error"]:
    merged_df[col] = pd.to_numeric(merged_df[col], errors="coerce")

# Save final CSV
merged_df.to_csv(output_file, index=False)
print(f"✅ Done! Saved processed dataset to {output_file}")
