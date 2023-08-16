#!/bin/bash

# Create ros2 directory inside the current one
mkdir -p ros2
# Look for markdown files inside ros2 directory
for f in ../ros2/*.md; do
	# Link relative to the new ros2 directory with the same file name
	ln -s "../$f" "ros2/$(basename "$f")"
done
