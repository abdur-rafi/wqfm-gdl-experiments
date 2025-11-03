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

all_data = []

for file in glob.glob(os.path.join(input_dir, "*.csv")):
    filename = os.path.basename(file)
    method, seq = filename.replace(".csv", "").split("_")

    df = pd.read_csv(file)
    df_long = df.melt(var_name="Condition", value_name="Error")

    df_long["DupRate"], df_long["Psize"] = zip(*df_long["Condition"].apply(extract_info))

    # ✅ Add InputType column in the format used in ggplot
    df_long["InputType"] = df_long["Psize"].apply(lambda x: f"Psize {x}")

    df_long["Method"] = method
    df_long["SeqLen"] = seq

    all_data.append(df_long)

final_df = pd.concat(all_data, ignore_index=True)

# ✅ Final column order
final_df = final_df[["Method", "SeqLen", "DupRate", "InputType", "Error"]]

final_df.to_csv(output_file, index=False)
print(f"✅ Saved merged CSV with InputType → {output_file}")
