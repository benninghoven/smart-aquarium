#!/bin/bash

PYTHON_EXECUTABLE=/usr/bin/python3

PYTHON_SCRIPT_PATH=./sensor_generator.py

ITERATIONS=10

for ((i=1; i<=$ITERATIONS; i++)); do
    echo "Iteration $i:"
    $PYTHON_EXECUTABLE $PYTHON_SCRIPT_PATH
    echo "------------------"
    sleep 3  # Adjust the sleep time (in seconds) between iterations as needed
done

