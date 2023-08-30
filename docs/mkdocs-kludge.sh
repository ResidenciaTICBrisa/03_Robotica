#!/bin/bash

readonly DOCDIRS=(ros1 ros2 vms/ubuntu-12)

for docdir in "${DOCDIRS[@]}"; do
	# Create directory inside the current one
	rm -rv "${docdir}"
	mkdir -pv "${docdir}"

	dirlevel="$(perl -ne 'print tr/\///' <<< "${docdir}")"
	linklevel="../"

	for (( i = 0; i < dirlevel; i++ )); do
		linklevel="${linklevel}../"
	done

	for f in ../scripts/"${docdir}"/*.md; do
		# Link relative to the new directory with the same file name
		ln -sv "${linklevel}${f}" "${docdir}/$(basename "$f")"
	done
done
