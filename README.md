# elm-compiler-wasm

Fork of https://github.com/elm/compiler that tries to compile to WebAssembly.

It is used inside [elm.run](https://github.com/marc136/elm.run) to power the [repl](https://elm.run/repl) and [editor](https://elm.run/editor).

## Changelog
See [./CHANGELOG.md](./CHANGELOG.md)

## TODO

Introduce a state monad to read the dependency artifacts only once.

Use a web worker for compilation, see https://web.dev/articles/webassembly-performance-patterns-for-web-apps#good_task_runs_in_web_worker_and_loads_and_compiles_only_once

Add a replacement for elm-src/builder/src/Stuff.hs `withRegistryLock`.
The missing lock might be the reason why installing many dependencies at once can fail.
See my experiments inside Ulm.Details with `acquireLock`.

Install and remove Elm packages.

Using `Reporting.Doc` to turn the errors into human-readable formatted JSON adds 2MiB to the wasm bundle size. I want to instead return a direct representation of the actual error, and then transform it in the viewer to the same or similar readable data.
This will also allow to show the errors in [different languages](https://github.com/katjam/local-elm).

## Development

Get the [GHC compiler with wasm backend](https://gitlab.haskell.org/ghc/ghc-wasm-meta). I used nix for that, see the `./init.sh` file for the current revision.

Then run `./build-wasm.sh` to build the `dist/ulm.wasm` and `dist/repl.wasm` binaries.\
`./dev.sh` re-runs those builds on file change.

### Important directories

The directory `./elm-src` contains a fork of the [Elm compiler](https://github.com/elm/compiler) with minimal changes required to build for wams32-wasi. I try to use code from there whenever possible and only create new files in `lib-src` when I need to.\
The branch of the submodule tries to track upstream and might be rebased in the future with the next Elm release. I will try to create a elm-0.19.1 branch once the next version is released.

The directory `./exe-wasm` contains the actual entry points to build the wasm binaries.

## Other Elm forks
There are several other interesting forks of the official Elm compiler, I'll try to keep a list here:

- [mdgriffith/elm-dev](https://github.com/mdgriffith/elm-dev) runs in watch mode and can be used to query information about the Elm code, like "what is the inferred type of this declaration?"
- [lamdera](https://github.com/lamdera/compiler) powers https://lamdera.com/ and also https://elm-pages.com/
- [zokka](https://github.com/Zokka-Dev/zokka-compiler/) adds support for [custom package servers](https://github.com/Zokka-Dev/zokka-custom-package-server) and bugfixes.
- [pithub/elm-compiler-in-elm-ui](https://github.com/pithub/elm-compiler-in-elm-ui) is a port of the Elm compiler and its cli to Elm and runs in the browser, see [demo video (2024-08)](https://www.youtube.com/watch?v=OK9S_HUdReA).
- [guida-lang/compiler](https://github.com/guida-lang/compiler) is a port of the Elm compiler and its cli to Elm and runs in node.js.
