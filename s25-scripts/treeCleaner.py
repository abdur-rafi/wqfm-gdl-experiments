import sys
import re
import argparse

newickReg = r'[(].*[;]'
reg = r"[:].*?(?=[),])"
reg2 = r"[)].*?(?=[),])"
reg3 = r"[:].*(?=[;])"


def clean_newick_from_line(line: str) -> str | None:
    """Extract and clean a Newick string from a line. Returns None if no match."""
    match = re.search(newickReg, line)
    if not match:
        return None
    s = match.group()
    s = re.sub(reg, "", s)
    s = re.sub(reg2, ")", s)
    s = re.sub(reg3, "", s)
    # Remove anything between the last closing parenthesis and the ending semicolon
    # e.g. transform "... )EXTRA;" into "...) ;" (keeps the final ")" and ";")
    last_paren = s.rfind(')')
    last_semicolon = s.rfind(';')
    if last_paren != -1 and last_semicolon != -1 and last_paren < last_semicolon:
        s = s[: last_paren + 1] + s[last_semicolon:]
    return s


def process_stream(in_stream, out_stream):
    for line in in_stream:
        cleaned = clean_newick_from_line(line)
        if cleaned is not None:
            out_stream.write(cleaned + "\n")


def main():
    parser = argparse.ArgumentParser(description="Clean Newick trees from input lines.")
    parser.add_argument("-i", "--input", help="Input file path (defaults to stdin)")
    parser.add_argument("-o", "--output", help="Output file path (defaults to stdout)")
    args = parser.parse_args()

    # Determine input stream
    if args.input:
        in_stream = open(args.input, 'r')
    else:
        in_stream = sys.stdin

    # Determine output stream
    if args.output:
        out_stream = open(args.output, 'w')
    else:
        out_stream = sys.stdout

    try:
        process_stream(in_stream, out_stream)
    finally:
        # Only close streams that we opened
        if args.input:
            in_stream.close()
        if args.output:
            out_stream.close()


if __name__ == "__main__":
    main()


