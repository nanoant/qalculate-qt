#!/bin/bash

DIR=$(dirname $(realpath $0))
ROOT=$(dirname "$DIR")

bin=$DIR/Qalculate.app/Contents/MacOS
info=$DIR/Qalculate.app/Contents/Info.plist
libs=(
$DIR/../local/lib/libqalculate.22.dylib
$DIR/../local/lib/libmpfr.6.dylib
$DIR/../local/lib/libgmp.10.dylib
/opt/brew/opt/libxml2/lib/libxml2.2.dylib
/opt/brew/Cellar/icu4c/73.2/lib/*.73.dylib
)

log() {
	echo "$@" && "$@"
}

log plutil -replace CFBundleName -string "Qalculate!" "$info"

for lib in "${libs[@]}"; do
	if [ ! -f $bin/${lib##*/} ]; then
		log cp "$lib" $bin
		chmod 755 $bin/${lib##*/}
	fi
done

set +x
for bin in $bin/*; do
	args=()
	while read lib; do
		if [ "${lib##*/}" = "${bin##*/}" ]; then
			args+=(-id @executable_path/${lib##*/})
		else
			args+=(-change $lib @executable_path/${lib##*/})
		fi
	done < <(otool -L $bin|grep -Eo "($ROOT|/opt|@loader_path)[^ ]+")
	if [ ${#args[@]} -ne 0 ]; then
		log install_name_tool "${args[@]}" "$bin"
	fi
done
