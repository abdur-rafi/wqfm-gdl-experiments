import re
import os
import argparse

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

            relabeled_tree = original_tree
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
                relabeled_tree = re.sub(r'\b' + re.escape(original_label) + r'\b', short_label, relabeled_tree)
            
            outfile_trees.write(relabeled_tree + "\n")

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

def relabel_tree_with_existing_map(input_tree_file, map_file, output_relabeled_tree_file):
    """
    Relabels gene trees using an existing mapping file.

    Args:
        input_tree_file (str): Path to the file containing gene trees to be relabeled.
        map_file (str): Path to the existing label mapping file (original_label\tshort_label).
        output_relabeled_tree_file (str): Path to save the relabeled trees.
    """
    original_to_short_map = {}
    with open(map_file, 'r') as f:
        # Skip header
        next(f)
        for line in f:
            original, short = line.strip().split('\t')
            original_to_short_map[original] = short

    with open(input_tree_file, 'r') as infile, \
         open(output_relabeled_tree_file, 'w') as outfile:
        
        for line in infile:
            original_tree = line.strip()
            if not original_tree:
                continue

            relabeled_tree = original_tree
            # Iterate through the map to replace original labels with short ones
            # Sort by length in reverse to avoid partial replacements (e.g., "gene10" before "gene1")
            for original_label in sorted(original_to_short_map.keys(), key=len, reverse=True):
                short_label = original_to_short_map[original_label]
                # Use word boundaries for accurate replacement
                relabeled_tree = re.sub(r'\b' + re.escape(original_label) + r'\b', short_label, relabeled_tree)
            
            outfile.write(relabeled_tree + "\n")
    # print(f"Trees relabeled using existing map saved to: {output_relabeled_tree_file}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="A script for relabeling gene trees in Newick format.",
        formatter_class=argparse.RawTextHelpFormatter
    )

    subparsers = parser.add_subparsers(dest="command", help="Choose a command")

    # Subparser for 'relabel' command
    relabel_parser = subparsers.add_parser(
        "relabel",
        help="Relabel gene trees, shorten labels, and create a mapping file.",
        description="""Relabel gene trees, shorten labels, and create a mapping file.
        This command takes an input tree file, relabels the gene names to
        shorter forms (e.g., G1, G2), and generates a mapping file
        between original and short labels."""
    )
    relabel_parser.add_argument(
        "-i", "--input",
        required=True,
        help="Path to the input file containing gene trees (one per line)."
    )
    relabel_parser.add_argument(
        "-o", "--output-trees",
        required=True,
        help="Path to the file where relabeled trees will be saved."
    )
    relabel_parser.add_argument(
        "-m", "--output-map",
        required=True,
        help="Path to the file where the label mapping will be saved."
    )

    # Subparser for 'convert-back' command
    convert_back_parser = subparsers.add_parser(
        "convert-back",
        help="Convert relabeled trees back to original labels using a map file.",
        description="""Convert relabeled trees back to original labels using a map file.
        This command uses an existing mapping file (created by 'relabel' command)
        to restore the original gene labels in a relabeled tree file."""
    )
    convert_back_parser.add_argument(
        "-i", "--input",
        required=True,
        help="Path to the file with relabeled trees."
    )
    convert_back_parser.add_argument(
        "-m", "--map-file",
        required=True,
        help="Path to the label mapping file (original_label\\tshort_label)."
    )
    convert_back_parser.add_argument(
        "-o", "--output-original-trees",
        required=True,
        help="Path to save trees with original labels."
    )

    # Subparser for 'apply-map' command
    apply_map_parser = subparsers.add_parser(
        "apply-map",
        help="Relabel gene trees using an existing mapping file.",
        description="""Relabel gene trees using an existing mapping file.
        This command takes an input tree file and an existing mapping file
        to relabel the gene names in the input tree file based on the provided map."""
    )
    apply_map_parser.add_argument(
        "-i", "--input",
        required=True,
        help="Path to the file containing gene trees to be relabeled."
    )
    apply_map_parser.add_argument(
        "-m", "--map-file",
        required=True,
        help="Path to the existing label mapping file (original_label\\tshort_label)."
    )
    apply_map_parser.add_argument(
        "-o", "--output-relabeled-trees",
        required=True,
        help="Path to save the relabeled trees."
    )

    args = parser.parse_args()

    if args.command == "relabel":
        relabel_gene_trees(args.input, args.output_trees, args.output_map)
    elif args.command == "convert-back":
        convert_back_to_original(args.input, args.map_file, args.output_original_trees)
    elif args.command == "apply-map":
        relabel_tree_with_existing_map(args.input, args.map_file, args.output_relabeled_trees)
    else:
        parser.print_help()