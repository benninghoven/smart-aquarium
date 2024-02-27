#!/bin/bash

# Specify the path to your Python program
python_script="/mnt/nfsshare/smart-aquarium/aquarium-scripts/adc.py"

# Specify the output text file
output_file="automated_output.txt"

# Run the Python program 1000 times sequentially
for ((i=1; i<=100; i++)); do
    echo "Running iteration $i..."
    python3 "$python_script" >> "$output_file"
done

echo "Script completed. Check '$output_file' for the output."
