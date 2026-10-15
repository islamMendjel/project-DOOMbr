# DOOM in Browser (WebAssembly + Freedoom)

Play classic DOOM directly in your web browser with zero installation, zero proprietary binaries, and zero plugins. Powered by a single-threaded WebAssembly port of **Chocolate Doom** and open-source game assets from **Freedoom**.

🎮 **[Play Live on GitHub Pages](https://islamMendjel.github.io/project-DOOMbr/)**

---

## Features

- ⚡ **Pure WebAssembly Engine**: Historically accurate, single-threaded Chocolate Doom port compiled with Emscripten.
- 🌐 **Zero Special HTTP Headers**: Runs on standard static hosting (such as GitHub Pages) without requiring Cross-Origin Opener Policy (COOP) or Cross-Origin Embedder Policy (COEP) headers. No `SharedArrayBuffer` or web worker dependencies.
- 🆓 **100% Free & Open Source**: Powered by Freedoom (Phase 1 & Phase 2). Contains zero proprietary id Software binaries.
- 📁 **Custom WAD Support**: Drag-and-drop or upload your own `.wad` files (IWAD or PWAD), processed completely locally in the browser with magic byte header validation (`IWAD`/`PWAD`).
- 🎮 **Full Controls & Mouse Look**:
  - Keyboard: WASD / Arrow Keys for movement, Ctrl or Mouse Click to shoot, Space to open doors/use, Alt / `,` / `.` to strafe, Shift to run, 1-7 for weapon selection, Tab for automap, Esc for menu.
  - Mouse: Click canvas to engage Pointer Lock for mouse aiming; press Esc to release cursor.
  - Browser key-stealing prevention: Disables browser default scrolling (arrows, space) and shortcut hijacking while playing.
- 📱 **Mobile Touch Controls**: Automatic touch overlay featuring an on-screen D-pad, Fire, Use, Strafe, Run, and Esc buttons for mobile and tablet devices.
- 💾 **Persistent Saves**: Savegames (`/libsdl/doom-ws-wasm/savegames/*.dsg`) and configuration (`default.cfg`) persist automatically across page reloads via IndexedDB. Includes a "Reset Saves" button.
- 🔊 **Web Audio Volume & Mute**: Direct gain control and instant mute toggle routing through Web Audio.
- ⏸️ **Focus-Lost Pause Overlay**: Game pauses automatically when switching browser tabs or windows.
- 📐 **Crisp Aspect-Ratio Scaling**: 4:3 viewport scaling with `image-rendering: pixelated` for sharp retro pixels.

---

## Architecture & Technology Stack

```text
┌─────────────────────────────────────────────────────────────┐
│                       Browser Window                        │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │              Responsive 4:3 Canvas                  │   │
│   └─────────────────────────▲───────────────────────────┘   │
│                             │ WebGL Framebuffer             │
│   ┌─────────────────────────┴───────────────────────────┐   │
│   │         Chocolate Doom (WebAssembly / C)            │   │
│   │   - Single-threaded (no pthreads/SharedArrayBuffer) │   │
│   │   - Emscripten virtual file system (Module.FS)      │   │
│   └──────────────▲──────────────────────▲───────────────┘   │
│                  │                      │                   │
│   ┌──────────────┴───────┐      ┌───────┴───────────────┐   │
│   │  Freedoom Game WADs  │      │  IndexedDB Persistence│   │
│   │  - freedoom1.wad     │      │  - Saved Games (.dsg) │   │
│   │  - freedoom2.wad     │      │  - default.cfg        │   │
│   │  - Custom local WADs │      │                       │   │
│   └──────────────────────┘      └───────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

- **Engine**: Chocolate Doom WebAssembly port (GPL-2.0) vendored in `docs/engine/`.
- **Game Data**: Freedoom v0.13.0 Phase 1 & Phase 2 (BSD-3-Clause) downloaded and verified by `build.sh`.
- **Hosting**: GitHub Pages serving the self-contained `docs/` directory with relative asset paths.
- **CI / CD**: Modern GitHub Actions Pages deployment using official `actions/deploy-pages`.

---

## Quick Start & Local Development

### Prerequisites

- `bash`, `curl`, `unzip`, and `sha256sum` (to fetch Freedoom assets)
- `python3` (or any static HTTP server)
- `node` & `npm` (optional, for automated Playwright headless tests)

### 1. Clone the Repository

```bash
git clone https://github.com/islamMendjel/project-DOOMbr.git
cd project-DOOMbr
```

### 2. Download and Verify Game Assets

Run the idempotent build script to fetch and verify the Freedoom WAD assets:

```bash
chmod +x ./build.sh
./build.sh
```

This downloads Freedoom v0.13.0, validates the archive's SHA-256 checksum, and extracts `freedoom1.wad` and `freedoom2.wad` into `docs/wads/`.

### 3. Run Local Server

Start an HTTP server pointing at `docs/`:

```bash
cd docs
python3 -m http.server 8000
```

Or from the repository root (to test both root redirect and subpath serving):

```bash
python3 -m http.server 8000
```

Open your browser at `http://localhost:8000/`.

---

## Automated Verification

This repository includes automated end-to-end headless browser testing via Playwright:

```bash
# Install dependencies
npm i -D playwright
npx playwright install chromium

# Start local server (if not already running)
cd docs && python3 -m http.server 8000 &

# Run verification suite
node test-doom.js
```

The test validates:
- HTTP 200 loading with zero 404 network errors
- Zero browser console errors
- Start Game button interaction and WAD loading
- Chocolate Doom WebAssembly execution
- Canvas frame rendering verification (confirms non-black rendered pixels)
- Saves screenshot to `doom-test-screenshot.png`

---

## GitHub Pages Deployment

Deployment is completely automated via `.github/workflows/build-and-deploy.yml`:

1. **Trigger**: Pushes to `main` or manual workflow dispatch.
2. **Build**: Runs `build.sh` to download and checksum-verify the Freedoom WAD files.
3. **Validate**: Checks that `index.html`, `engine/chocolate-doom.js`, `engine/chocolate-doom.wasm`, `engine/default.cfg`, and both WADs exist.
4. **Deploy**: Packages `docs/` via `actions/upload-pages-artifact@v3` and deploys via `actions/deploy-pages@v4`.

### Enabling GitHub Pages in Repository Settings:

1. Go to **Settings** → **Pages**.
2. Under **Build and deployment** → **Source**, select **GitHub Actions**.
3. Push to `main` or run the workflow from the Actions tab.

---

## Repository Structure

```text
project-DOOMbr/
├── .github/
│   └── workflows/
│       └── build-and-deploy.yml     # Official GitHub Actions Pages deployment
├── docs/                            # Single source of truth for deployment
│   ├── index.html                   # Web DOOM player (UI, controls, audio, saves)
│   ├── .nojekyll                    # Disables Jekyll processing on GitHub Pages
│   ├── CHOCOLATE-DOOM-LICENSE.txt   # GNU GPL v2.0 license
│   ├── FREEDOOM-LICENSE.txt         # BSD 3-Clause license
│   ├── engine/
│   │   ├── chocolate-doom.js        # Chocolate Doom WebAssembly loader
│   │   ├── chocolate-doom.wasm      # Single-threaded Chocolate Doom WASM binary
│   │   ├── default.cfg              # Default engine controls and audio config
│   │   └── README.md                # Provenance and build notes for the engine
│   └── wads/
│       ├── freedoom1.wad            # Freedoom: Phase 1 (downloaded by build.sh)
│       └── freedoom2.wad            # Freedoom: Phase 2 (downloaded by build.sh)
├── build.sh                         # Idempotent SHA-256 asset downloader
├── test-doom.js                     # Playwright automated test script
├── index.html                       # Root fallback redirect to ./docs/
├── .gitignore                       # Clean ignore rules (excludes WADs & node_modules)
└── README.md                        # Documentation
```

---

## Legal & Licensing

- **Game Engine**: [Chocolate Doom](https://www.chocolate-doom.org/) WebAssembly port ([cloudflare/doom-wasm](https://github.com/cloudflare/doom-wasm), commit `65e0d3ae2ffa604155eebd96ed40da6567bd08f4`) is licensed under the **GNU General Public License v2.0 (GPL-2.0)**. Full text in `docs/CHOCOLATE-DOOM-LICENSE.txt`.
- **Game Data**: [Freedoom](https://freedoom.github.io/) is licensed under the **BSD 3-Clause License**. Full text in `docs/FREEDOOM-LICENSE.txt`.
- **Notice**: This repository does not contain or distribute any proprietary or commercial id Software binaries. All trademarks belong to their respective owners.
