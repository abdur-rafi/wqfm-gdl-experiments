import re
import os

def relabel_gene_trees(input_file, output_trees_file, output_map_file):
    """
    Relabels gene trees in Newick format, shortens labels, and creates a mapping.

    Args:
        input_file (str): Path to the file containing gene trees (one per line).
        output_trees_file (str): Path to the file where relabeled trees will be saved.
        output_map_file (str): Path to the file where the label mapping will be saved.
    """
    original_to_short_map = {}
    short_label_counter = 1
    
    with open(input_file, 'r') as infile, \
         open(output_trees_file, 'w') as outfile_trees, \
         open(output_map_file, 'w') as outfile_map:

        # Write header for the map file
        outfile_map.write("original_label\tshort_label\n")

        for line in infile:
            original_tree = line.strip()
            if not original_tree:
                continue

            # Find all potential labels in the Newick string
            # This regex looks for sequences of characters that are not ( ) : , ; or numbers followed by : (branch length)
            # It's a bit simplified and assumes labels don't contain problematic characters within them.
            # For more robust parsing, consider a dedicated Newick parsing library (e.g., dendropy, ete3)
            labels_in_tree = re.findall(r'[^\(\):,;]+(?=[:,\)])', original_tree) 
            
            # Remove any empty matches or pure numbers if they appear (due to branch lengths)
            labels_in_tree = [label.strip() for label in labels_in_tree if label.strip() and not re.fullmatch(r'\d+(\.\d*)?', label.strip())]


            relabeld_tree = original_tree
            for original_label in sorted(set(labels_in_tree)): # Process unique labels
                if original_label not in original_to_short_map:
                    short_label = f"G{short_label_counter}"
                    original_to_short_map[original_label] = short_label
                    outfile_map.write(f"{original_label}\t{short_label}\n")
                    short_label_counter += 1
                else:
                    short_label = original_to_short_map[original_label]
                
                # Replace the original label with the short one in the tree string
                # Use word boundaries to avoid replacing parts of other labels
                relabeld_tree = re.sub(r'\b' + re.escape(original_label) + r'\b', short_label, relabeld_tree)
            
            outfile_trees.write(relabeld_tree + "\n")

    # print(f"Relabeled trees saved to: {output_trees_file}")
    # print(f"Label mapping saved to: {output_map_file}")

def convert_back_to_original(input_relabeled_tree_file, map_file, output_original_tree_file):
    """
    Converts relabeled trees back to original labels using the map file.

    Args:
        input_relabeled_tree_file (str): Path to the file with relabeled trees.
        map_file (str): Path to the label mapping file.
        output_original_tree_file (str): Path to save trees with original labels.
    """
    short_to_original_map = {}
    with open(map_file, 'r') as f:
        # Skip header
        next(f)
        for line in f:
            original, short = line.strip().split('\t')
            short_to_original_map[short] = original

    with open(input_relabeled_tree_file, 'r') as infile, \
         open(output_original_tree_file, 'w') as outfile:
        
        for line in infile:
            relabeled_tree = line.strip()
            if not relabeled_tree:
                continue

            converted_tree = relabeled_tree
            # Iterate through the map to replace short labels with original ones
            # Start with longer short labels first to avoid partial replacements (e.g., G1 before G10)
            for short_label in sorted(short_to_original_map.keys(), key=len, reverse=True):
                original_label = short_to_original_map[short_label]
                # Use word boundaries for accurate replacement
                converted_tree = re.sub(r'\b' + re.escape(short_label) + r'\b', original_label, converted_tree)
            
            outfile.write(converted_tree + "\n")
    # print(f"Trees with original labels saved to: {output_original_tree_file}")


if __name__ == "__main__":
    # --- Configuration ---
    input_gene_trees_file = "Archae364/364_combined_treefile.txt"
    output_relabeled_trees_file = "Archae364/364_relabeled_gene_trees.txt"
    output_label_map_file = "Archae364/364_gene_label_map.tsv"
    output_original_trees_file = "Archae364/364_converted_back_trees.txt" # For verification

    convert_back_input_file = "Archae364/wqfm_tree_pro.tre"
    converted_back_file = "Archae364/wqfm_tree_pro_original.txt"

    # --- Create a dummy input file for demonstration ---
    # if not os.path.exists(input_gene_trees_file):
    #     with open(input_gene_trees_file, 'w') as f:
    #         f.write("((long_gene_label_1:0.1,another_very_long_gene_label_2:0.2):0.05,third_gene_label_3:0.3);\n")
    #         f.write("((long_gene_label_1:0.15,fourth_gene_label_4:0.25):0.07,another_very_long_gene_label_2:0.35);\n")
    #         f.write("(fifth_gene_label_5:0.1,sixth_gene_label_6:0.2);\n")
    #     print(f"Created a dummy input file: {input_gene_trees_file}")

    # --- Step 1: Relabel gene trees and create map ---
    # relabel_gene_trees(input_gene_trees_file, output_relabeled_trees_file, output_label_map_file)

    # --- Step 2: (Optional) Convert back to original labels for verification ---
    # print("\n--- Verifying conversion back to original labels ---")
    convert_back_to_original(convert_back_input_file, output_label_map_file, converted_back_file)

    # print(f"\nCompare '{input_gene_trees_file}' and '{output_original_trees_file}' to verify the process.")