#!/bin/bash
for f in *; do
	lower="$(echo $(basename $f) | tr '[:upper:]' '[:lower:]')"
	if [ x"$lower" != x"$(basename $f)" ] && [ ! -d "$f" ]; then
		cp "$(dirname $f)/$(basename $f)" "$(dirname $f)/$lower"
	fi
done
