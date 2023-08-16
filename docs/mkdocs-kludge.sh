#!/bin/bash

readonly DOCDIRS=(ros1 ros2)

for docdir in "${DOCDIRS[@]}"; do
	# Create directory inside the current one
	mkdir -pv "${docdir}"

	for f in ../"${docdir}"/*.md; do
		# Link relative to the new directory with the same file name
		ln -sv "../$f" "${docdir}/$(basename "$f")"
	done
done
