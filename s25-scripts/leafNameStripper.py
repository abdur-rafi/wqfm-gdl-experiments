#!/usr/bin/env python3
import sys
import re
import argparse
from typing import Optional

# non-greedy match for a Newick tree in a line
newickReg = r'\(.*?;'


def clean_newick_strip_after_delim(line: str, delim: str) -> Optional[str]:
    """Extract Newick from a line and strip leaf-name suffix after `delim`.

    Leaves are assumed to be unquoted and composed of characters except
    parentheses, colons, commas and semicolons. The script removes the
    first occurrence of `delim` and anything after it for each leaf name.
    Returns None if no Newick is found on the line.
    """
    match = re.search(newickReg, line)
    if not match:
        return None

    s = match.group()
    esc = re.escape(delim)

    # Match leaf labels only (preceded by '(' or ',')
    pattern = r'(?<=\(|,)([^():,;{0}]+?){0}[^():,;]*?(?=[,:\)\;])'.format(esc)
    s = re.sub(pattern, r"\1", s)
    return s


def process_stream(in_stream, out_stream, delim):
    for line in in_stream:
        cleaned = clean_newick_strip_after_delim(line, delim)
        if cleaned is not None:
            out_stream.write(cleaned + "\n")


def main():
    parser = argparse.ArgumentParser(
        description="Strip leaf-name suffixes after a delimiter in Newick trees."
    )
    parser.add_argument("-i", "--input", help="Input file path (defaults to stdin)")
    parser.add_argument("-o", "--output", help="Output file path (defaults to stdout)")
    parser.add_argument(
        "-d", "--delimiter", default="_",
        help="Delimiter to split leaf names (default: '_')"
    )
    args = parser.parse_args()

    in_stream = open(args.input, 'r') if args.input else sys.stdin
    out_stream = open(args.output, 'w') if args.output else sys.stdout

    try:
        process_stream(in_stream, out_stream, args.delimiter)
    finally:
        if args.input:
            in_stream.close()
        if args.output:
            out_stream.close()


if __name__ == '__main__':
    main()
