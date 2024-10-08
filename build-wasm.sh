#!/usr/bin/env bash
# From
# https://github.com/tweag/ormolu/blob/607978708809d97945c6036a60b8ffb9b719bc60/ormolu-live/build-wasm.sh

set -e

wasm32-wasi-cabal build exe:ulm exe:repl
DIR=dist

for EXE in ulm repl; do
    cp "$(wasm32-wasi-cabal list-bin exe:$EXE)" "$DIR/$EXE.wasm"
    cp "$DIR/$EXE.wasm" ../../www/dist/ # Copied there until I make esbuild load the wasm file
    gzip --keep --force --best "$DIR/$EXE.wasm"
    $(wasm32-wasi-ghc --print-libdir)/post-link.mjs -i "$DIR/$EXE.wasm" -o "$DIR/$EXE.wasm.js"
    echo "built $DIR/$EXE.wasm (and a $DIR/$EXE.wasm.js wrapper)"
done

echo "NOTE: Run \`./optimize-wasm.sh\` to compress the files"
du -h $DIR/*.{wasm,gz}
