#!/bin/bash
# Scan for TODO/FIXME comments in code changes
# Usage: ./scan-todos.sh <file_or_directory>

if [ -z "$1" ]; then
    echo "Usage: $0 <file_or_directory>"
    exit 1
fi

echo "Scanning for TODO/FIXME comments in: $1"
echo "========================================"

# Search for TODO without ticket/context
echo -e "\n### TODOs without ticket/context:"
grep -rn "TODO:" "$1" | grep -v "ticket\|ALE-\|#" || echo "None found"

# Search for FIXME without description
echo -e "\n### FIXMEs without description:"
grep -rn "FIXME:" "$1" | grep -v ":\s*[a-zA-Z]" || echo "None found"

# Search for XXX comments
echo -e "\n### XXX comments:"
grep -rn "XXX:" "$1" || echo "None found"

echo -e "\n========================================"
echo "Scan complete"
