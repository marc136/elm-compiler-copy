#!/usr/bin/env bash
# From
# https://github.com/tweag/ormolu/blob/607978708809d97945c6036a60b8ffb9b719bc60/ormolu-live/build-wasm.sh

set -e

DIR=dist

for FILE in $DIR/*.wasm; do
    case $FILE in
        # ignore optimized files
        *.opt.wasm) continue;
    esac
    NAME=`basename -s .wasm $FILE`
    OUT="$DIR/${NAME}.opt.wasm"
    echo "Optimizing $FILE -> $OUT"
    # "-Oz" -> optimize for file size
    wasm-opt -Oz "$FILE" -o "$OUT"
    cp "$OUT" "../../www/dist/$NAME.wasm" # Copied there until I make esbuild load the wasm file
    gzip --keep --force --best "$OUT"
done

# tree -h "$DIR"
du -h $DIR/*.{wasm,gz} | sort -h

# https://github.com/tweag/ormolu/blob/607978708809d97945c6036a60b8ffb9b719bc60/ormolu-live/cbits/init.c
# For more optimization, look how wizer is used in
echo "NOTE: Disabled optimizer pass with wizer because I did not set it up properly"
exit 0

# TODO needs `wizer.initialize` exposed, see
# https://github.com/tweag/ormolu/blob/607978708809d97945c6036a60b8ffb9b719bc60/ormolu-live/cbits/init.c
wizer \
    --allow-wasi --wasm-bulk-memory true \
    "$BUILT" -o "$DIR/ulm.wizer.wasm"
wasm-opt "-Oz" "$DIR/ulm.wizer.wasm" -o "$DIR/ulm.wizer.opt.wasm"
tar -czvf "$DIR/ulm.wizer.opt.tar.gz" "$DIR/ulm.wizer.opt.wasm"
tree -h "$DIR"
