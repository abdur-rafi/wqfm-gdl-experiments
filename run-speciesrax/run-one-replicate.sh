#!/usr/bin/env bash
set -euo pipefail

usage() {
	echo "Usage: $0 <families_file> <output_prefix>"
	echo "Example: $0 /path/to/families-file.txt /path/to/output_prefix"
	exit 2
}

if [ "$#" -ne 2 ]; then
	usage
fi

cores=8
generax=GeneRax/build/bin/generax
families="$1"
output="$2"
speciestree=MiniNJ
sprradius=2

if [ ! -f "$families" ]; then
	echo "Error: families file not found: $families" >&2
	exit 1
fi

if [ ! -x "$generax" ]; then
	echo "Error: generax binary not found or not executable: $generax" >&2
	exit 1
fi

mpiexec -np "$cores" "$generax" \
	--families "$families" \
	--species-tree "$speciestree" \
	--strategy SKIP \
	--rec-model UndatedDTL \
	--per-family-rates \
	--prune-species-tree \
	--prefix "$output" \
	--si-strategy HYBRID

