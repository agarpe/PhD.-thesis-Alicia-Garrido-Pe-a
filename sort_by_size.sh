#!/bin/bash

# Input file
input_file="$1"

# Function to convert size to bytes for sorting
convert_to_bytes() {
    local size_str="$1"
    local size
    local unit
    size=$(echo "$size_str" | awk '{print $1}')
    unit=$(echo "$size_str" | awk '{print $2}')
    
    case "$unit" in
        KB) echo "$(echo "$size * 1024" | bc)";;
        MB) echo "$(echo "$size * 1048576" | bc)";;
        *) echo "$size";;
    esac
}

# Read and filter the input file
valid_lines=()
while IFS= read -r line; do
    if [[ "$line" =~ ^[^\ ]+\ -\ [0-9]+\.[0-9]+\ (KB|MB|bytes)\ -\ used\ in\ .+$ ]]; then
        valid_lines+=("$line")
    fi
done < "$input_file"

# Sort the lines by size
sorted_lines=$(for line in "${valid_lines[@]}"; do
    size_str=$(echo "$line" | awk '{print $3, $4}')
    size_in_bytes=$(convert_to_bytes "$size_str")
    echo "$size_in_bytes $line"
done | sort -n | awk '{$1=""; print $0}')

# Output the sorted lines
echo "$sorted_lines"
