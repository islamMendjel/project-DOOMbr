# WebAssembly Chocolate Doom Engine

This directory contains the vendored WebAssembly port of **Chocolate Doom**.

## Upstream Provenance

- **Upstream Repository**: [https://github.com/cloudflare/doom-wasm](https://github.com/cloudflare/doom-wasm)
- **Base Engine**: Chocolate Doom 3.0.0 ([https://www.chocolate-doom.org/](https://www.chocolate-doom.org/))
- **Upstream Commit Hash**: `65e0d3ae2ffa604155eebd96ed40da6567bd08f4`
- **License**: GNU General Public License v2.0 (GPL-2.0) — see `CHOCOLATE-DOOM-LICENSE.txt`

## Architecture & Characteristics

- **Single-Threaded**: Runs completely in a single WebAssembly thread without `SharedArrayBuffer` or `pthread`.
- **Zero COOP/COEP Requirements**: Works out-of-the-box on standard static hosting (such as GitHub Pages) without needing special HTTP headers or cross-origin isolation service workers.
- **Pure Open Source**: Does not contain or require any proprietary id Software files. Runs free and open-source game data such as Freedoom Phase 1, Freedoom Phase 2, and user-provided custom WADs.

## Building from Source

To compile the engine yourself using Emscripten:

```bash
git clone https://github.com/cloudflare/doom-wasm.git
cd doom-wasm
git checkout 65e0d3ae2ffa604155eebd96ed40da6567bd08f4

# Prerequisites: emsdk, automake, autoconf, libtool
./scripts/build.sh
```

The resulting `websockets-doom.js` and `websockets-doom.wasm` correspond directly to `chocolate-doom.js` and `chocolate-doom.wasm`.
