import os
import glob
import pandas as pd
import re

input_dir = "./csv_files/"
output_file = "merged_for_plot.csv"

def extract_info(column_name):
    match = re.search(r"dlrate-([0-9.eE+-]+)\.psize-([0-9]+)", column_name)
    if match:
        return float(match.group(1)), match.group(2)
    return None, None


def extract_taxa_dup_ils_loss_from_col(col_name):
    """
    Extract taxa, duplication rate, ILS, loss rate from a string like:
    'sim200_dup1_ILS25' or 'sim500_dup0.25_loss1'. if ILS or loss is missing, ILS = 70 and loss = 1
    """
    taxa_match = re.search(r"sim([0-9]+)", col_name)
    dup_match = re.search(r"dup([0-9.eE+-]+)", col_name)
    ils_match = re.search(r"ILS([0-9.eE+-]+)", col_name)
    loss_match = re.search(r"loss([0-9.eE+-]+)", col_name)

    taxa = int(taxa_match.group(1)) if taxa_match else None
    dup_rate = float(dup_match.group(1)) if dup_match else None
    ils = float(ils_match.group(1)) if ils_match else 70.0
    loss_rate = float(loss_match.group(1)) if loss_match else 1.0

    return taxa, dup_rate, ils, loss_rate

all_data = []


for file in glob.glob(os.path.join(input_dir, "*.csv")):
    filename = os.path.basename(file)
    method, gt = filename.replace(".csv", "").split("_")

    gt = gt.replace("gt", "")

    df = pd.read_csv(file)

    columns = df.columns.tolist()

    for col in columns:
        taxa, dup_rate, ils, loss_rate = extract_taxa_dup_ils_loss_from_col(col)
        if taxa is None:
            raise ValueError(f"Unexpected taxa info in column name: {col}")
        if dup_rate is None:
            raise ValueError(f"Unexpected dup_rate info in column name: {col}")
        
        col_values = df[[col]].copy()
        # remove NaN values
        col_values = col_values.dropna()

        col_df = pd.DataFrame()
        col_df["Error"] = col_values[col]
        col_df["Method"] = method
        col_df["gt"] = gt
        col_df["taxa"] = taxa
        col_df["dup"] = dup_rate
        col_df["ils"] = ils
        col_df["loss"] = loss_rate
        all_data.append(col_df)

final_df = pd.concat(all_data, ignore_index=True)

# ✅ Final column order
final_df = final_df[["Method", "gt", "taxa", "dup", "ils", "loss", "Error"]]

final_df.to_csv(output_file, index=False)
print(f"✅ Saved merged CSV with InputType → {output_file}")
