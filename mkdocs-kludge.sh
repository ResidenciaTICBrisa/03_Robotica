#!/bin/bash

readonly DOCDIRS=(ros1 ros2 vms/ubuntu-14 vms/ubuntu-16 naoqi-2.1/cpp)

for docdir in "${DOCDIRS[@]}"; do
	# Create directory inside the current one
	rm -rv "${docdir}"
	mkdir -pv "${docdir}"

	dirlevel="$(perl -ne 'print tr/\///' <<< "${docdir}")"
	linklevel="../"

	for (( i = 0; i < dirlevel; i++ )); do
		linklevel="${linklevel}../"
	done

	for f in ../{scripts,nao-programs}/"${docdir}"/*.md; do
		# Link relative to the new directory with the same file name
		if [[ -f "${f}" ]]; then
			ln -sv "${linklevel}${f}" "${docdir}/$(basename "$f")"
		fi
	done
done
