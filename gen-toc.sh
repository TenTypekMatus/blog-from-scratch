#!/bin/bash

# Set the input file as the first argument to the script
input_file=$1

# Get all of the headings from the input file
headings=$(grep "^#" "$input_file")

# Loop through the headings and print them out as a table of contents
echo "Table of Contents:"
echo ""

while read -r line; do
    # Get the level of the heading (i.e. the number of # characters)
    level=$(echo "$line" | awk '{print gsub(/#/, "")}')
    
    # Get the text of the heading (without the # characters)
    text=$(echo "$line" | sed -e 's/^#\+//' -e 's/^[[:space:]]*//')
    
    # Create a string of spaces to indent the heading based on its level
    indent=$(printf ' %.0s' $(seq 1 "$level"))
    
    # Print out the heading with the appropriate indentation
    echo "${indent}- [${text}](${input_file}#${text})"
done <<< "$headings"