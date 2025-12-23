# DOOM in Browser - Play Classic DOOM Online

> Experience the classic **DOOM** game right in your browser using **js-dos** emulator!

Play DOOM directly in your web browser without any installation. This project uses js-dos (a DOS emulator for browsers) and Freedoom (free DOOM-compatible game data) to bring the classic FPS experience to the web.

🎮 **[Play Now on GitHub Pages](https://islamMendjel.github.io/project-DOOMbr/)**

## Project Status

**✅ Ready to Play!** This repository is fully configured and ready to deploy DOOM to GitHub Pages.

**What's Included:**
- ✅ Browser-based DOOM player using js-dos v8
- ✅ Freedoom Phase 1 WAD file (free, open-source game data)
- ✅ Automated deployment via GitHub Actions
- ✅ Dark red DOOM-themed interface
- ✅ Full keyboard controls support
- ✅ Responsive design for all devices

## Features

- 🚀 **No Installation Required**: Play DOOM directly in your browser
- 🎮 **DOS Emulation**: Powered by js-dos for authentic DOOM experience
- 🆓 **Free & Open Source**: Uses Freedoom, a completely free DOOM-compatible game
- 🎯 **One-Click Deploy**: Automated GitHub Actions workflow
- 📱 **Responsive**: Works on desktop and mobile devices
- 🎨 **Themed UI**: Classic DOOM dark red aesthetic

## Quick Start

### Play Online

Simply visit **[https://islamMendjel.github.io/project-DOOMbr/](https://islamMendjel.github.io/project-DOOMbr/)** to play DOOM in your browser!

### Local Development

1. **Clone the repository**:
   ```bash
   git clone https://github.com/islamMendjel/project-DOOMbr.git
   cd project-DOOMbr
   ```

2. **Download game assets** (if not already present):
   ```bash
   ./build.sh
   ```
   This downloads the Freedoom WAD file to the `docs/` directory.

3. **Start a local HTTP server**:
   ```bash
   cd docs
   python3 -m http.server 8000
   ```
   
   Or using Node.js:
   ```bash
   cd docs
   npx http-server -p 8000
   ```

4. **Open your browser**:
   ```
   http://localhost:8000
   ```

5. **Click "Start Game"** and enjoy!

> **Note**: You must use an HTTP server. Opening `index.html` directly with `file://` protocol will not work due to browser security restrictions.

## How It Works

### Technology Stack

- **js-dos v8**: DOS emulator that runs in the browser using WebAssembly
- **Freedoom**: Free and open-source DOOM-compatible game (Phase 1 WAD)
- **GitHub Pages**: Free hosting for the browser-based game
- **GitHub Actions**: Automated deployment workflow

### Architecture

```
┌─────────────────┐
│   Web Browser   │
│                 │
│  ┌───────────┐  │
│  │  js-dos   │  │  ← DOS emulator (WebAssembly)
│  │           │  │
│  │ ┌───────┐ │  │
│  │ │ DOOM  │ │  │  ← DOS game executable
│  │ │ .EXE  │ │  │
│  │ └───┬───┘ │  │
│  │     │     │  │
│  │ ┌───▼────┐│  │
│  │ │Freedoom││  │  ← Game data (WAD file)
│  │ │  .WAD  ││  │
│  │ └────────┘│  │
│  └───────────┘  │
└─────────────────┘
```

1. User visits the GitHub Pages URL
2. Browser loads `index.html` with js-dos library
3. js-dos initializes a DOS environment in the browser
4. DOOM executable and Freedoom WAD are loaded into the virtual filesystem
5. Game starts and renders directly in the browser canvas

## Game Controls

| Key | Action |
|-----|--------|
| **Arrow Keys** | Move forward/backward, turn left/right |
| **Ctrl** | Fire weapon |
| **Space** | Use/Open doors |
| **Alt** | Strafe (side-step) |
| **Shift** | Run |
| **1-7** | Select weapon |
| **Tab** | Map |
| **ESC** | Menu/Pause |

> **Tip**: Click inside the game window to lock the mouse cursor for better control. Press ESC to release.

## Deployment

### Automated Deployment (GitHub Actions)

The repository includes a GitHub Actions workflow that automatically:
1. Downloads the Freedoom WAD file
2. Prepares all game assets
3. Deploys to GitHub Pages

The workflow triggers on:
- **Push to main branch** (automatic deployment)
- **Manual dispatch** (via GitHub Actions UI)

### Manual Deployment

```bash
# Download game assets
./build.sh

# Commit and push
git add docs/
git commit -m "Update DOOM game assets"
git push origin main

# GitHub Actions will automatically deploy to Pages
```

### First-Time GitHub Pages Setup

1. Go to your repository on GitHub
2. Click **Settings** → **Pages**
3. Under **Source**, select:
   - Branch: **`gh-pages`** (created by workflow)
   - Folder: **`/ (root)`**
4. Click **Save**
5. Your site will be available at: `https://<username>.github.io/project-DOOMbr/`

## About Freedoom

This project uses **Freedoom**, a free and open-source DOOM-compatible game:

- **License**: BSD 3-Clause License
- **Website**: [https://freedoom.github.io/](https://freedoom.github.io/)
- **Compatibility**: Works with the original DOOM engine
- **Content**: Complete game with levels, textures, sounds, and music
- **Legal**: 100% free to use, modify, and distribute

Freedoom is not the original DOOM, but a completely free replacement that works with DOOM engines. It offers a similar gameplay experience without any licensing restrictions.

## Project Structure

```
project-DOOMbr/
├── .github/
│   └── workflows/
│       └── build-and-deploy.yml    # GitHub Actions deployment workflow
├── docs/                           # Deployment directory (GitHub Pages)
│   ├── index.html                  # DOOM player interface
│   └── freedoom1.wad              # Game data (27 MB)
├── build.sh                        # Script to download game assets
├── README.md                       # This file
└── .nojekyll                      # Bypass Jekyll processing
```

## Advanced Usage

### Using Custom WAD Files

Want to use your own DOOM WAD files? Here's how:

1. **Replace the WAD file** in `docs/`:
   ```bash
   # Remove Freedoom
   rm docs/freedoom1.wad
   
   # Add your WAD file
   cp /path/to/your/doom.wad docs/
   ```

2. **Update `docs/index.html`** to load your WAD file (search for `freedoom1.wad` and replace with your filename)

3. **Deploy**:
   ```bash
   git add docs/
   git commit -m "Add custom WAD file"
   git push origin main
   ```

> **Note**: Ensure you have legal rights to use any commercial WAD files. The original DOOM WAD files are copyrighted by id Software.

### Creating a Custom js-dos Bundle

For advanced users, you can create a pre-configured `.jsdos` bundle:

1. Install js-dos CLI tools
2. Create a bundle with DOOM.EXE and your WAD file
3. Host the bundle and update `index.html` to load it

See [js-dos documentation](https://js-dos.com/) for details.

## Troubleshooting

### Game Won't Start

**Problem**: Clicking "Start Game" shows an error.

**Solutions**:
- Ensure `freedoom1.wad` exists in the `docs/` directory
- Check browser console for errors (F12)
- Try refreshing the page
- Ensure you're using a modern browser (Chrome, Firefox, Edge, Safari)

### Black Screen

**Problem**: Game loads but shows a black screen.

**Solutions**:
- Wait for the game to fully load (can take 10-30 seconds)
- Click inside the game window to focus it
- Check if your browser supports WebAssembly
- Try disabling browser extensions

### No Sound

**Problem**: Game runs but there's no audio.

**Solutions**:
- Click inside the game window (browsers require user interaction for audio)
- Check browser volume settings
- Some browsers block audio by default - check browser permissions

### Slow Performance

**Problem**: Game is laggy or slow.

**Solutions**:
- Close other browser tabs
- Try a different browser (Chrome usually has best performance)
- Reduce browser window size
- Check CPU usage - DOS emulation can be CPU-intensive

## Browser Compatibility

| Browser | Supported | Notes |
|---------|-----------|-------|
| Chrome 90+ | ✅ Yes | Best performance |
| Firefox 88+ | ✅ Yes | Good performance |
| Edge 90+ | ✅ Yes | Good performance |
| Safari 14+ | ✅ Yes | May require additional permissions |
| Mobile Safari | ⚠️ Limited | Touch controls may be difficult |
| Mobile Chrome | ⚠️ Limited | Touch controls may be difficult |

## Credits & Acknowledgments

- **Original DOOM**: id Software
- **Freedoom**: Freedoom Project contributors
- **js-dos**: Alexey Gordienko ([js-dos.com](https://js-dos.com/))
- **DOSBox**: DOSBox Team (underlying emulation technology)

## License

- **This Project**: MIT License (see LICENSE file)
- **Freedoom**: BSD 3-Clause License
- **js-dos**: MIT License
- **Original DOOM**: id Software (not included, only used as inspiration)

This project provides the infrastructure to play DOOM in a browser. The original DOOM game assets are copyrighted by id Software. This project uses Freedoom, a free replacement, to avoid any licensing issues.

## Contributing

Contributions are welcome! Feel free to:
- Report bugs or issues
- Suggest improvements
- Submit pull requests
- Share your custom DOOM experiences

## Resources

- [js-dos Official Site](https://js-dos.com/)
- [js-dos GitHub](https://github.com/caiiiycuk/js-dos)
- [Freedoom Project](https://freedoom.github.io/)
- [DOOM Wiki](https://doomwiki.org/)
- [DOSBox](https://www.dosbox.com/)

---

**Enjoy playing DOOM in your browser! 🎮👾**

For issues or questions, please [open an issue](https://github.com/islamMendjel/project-DOOMbr/issues) on GitHub.

If you own the original games, you can use:
- **DOOM** (`doom.wad`)
- **DOOM II** (`doom2.wad`)
- **Ultimate DOOM** (`doomu.wad`)
- Other compatible DOOM engine games

> **Important**: This project does not include copyrighted game assets. You must provide your own .WAD files or use free alternatives like Freedoom.

## Local Development & Testing

### Prerequisites

- Python 3.x (for local server) or Node.js with http-server
- Modern web browser (Chrome, Firefox, Edge, Safari)
- webDOOM game files (see "Where to Get .WAD Files and Game Engine" section)

### Running Locally

1. **Clone the repository**:
   ```bash
   git clone https://github.com/islamMendjel/project-DOOMbr.git
   cd project-DOOMbr
   ```

2. **Add game files to `webDOOM/public/`** (if not already present)

3. **Start a local HTTP server** from the project root:
   
   Using Python 3:
   ```bash
   python3 -m http.server 8000
   ```
   
   Or using Node.js:
   ```bash
   npx http-server -p 8000
   ```

4. **Open your browser**:
   ```
   http://localhost:8000
   ```

> **Important**: You must use an HTTP server. Opening `index.html` directly with `file://` protocol will not work due to WebAssembly security restrictions.

### Testing the Game

Once game files are added:
1. Navigate to `http://localhost:8000/webDOOM/public/`
2. Upload a .WAD file or select a pre-loaded game
3. Wait for loading to complete
4. Start playing!

### Game Controls (When Playing)

- **W/A/S/D** or **Arrow Keys**: Move
- **Mouse**: Look around
- **Left Click**: Shoot
- **Space**: Use/Open doors
- **Shift**: Run
- **Ctrl**: Fire
- **E**: Use
- **Tab**: Map
- **Esc**: Menu

## GitHub Pages Deployment

This project is configured for **GitHub Pages** hosting.

### Deployment Steps

1. **Push your code to GitHub**:
   ```bash
   git add .
   git commit -m "Setup webDOOM for GitHub Pages"
   git push origin main
   ```

2. **Enable GitHub Pages**:
   - Go to your repository on GitHub
   - Click **Settings** → **Pages**
   - Under **Source**, select **Deploy from a branch**
   - Select branch: **main** (or **master**)
   - Select folder: **/ (root)**
   - Click **Save**

3. **Access your site**:
   - Your site will be available at: `https://islamMendjel.github.io/project-DOOMbr/`
   - Deployment typically takes 1-2 minutes

### Important Files

- **`.nojekyll`**: Tells GitHub to bypass Jekyll processing for static file serving
- **`index.html`**: Main entry point with project information and navigation

## Project Structure

```
project-DOOMbr/
├── .nojekyll                 # Bypass Jekyll processing on GitHub Pages
├── .gitignore                # Git ignore rules
├── index.html                # Main landing page with project info
├── README.md                 # This file
├── LICENSE                   # Project license
├── GITHUB_PAGES.md          # GitHub Pages setup guide
├── QUICKSTART.md            # Quick start guide
└── webDOOM/                 # Directory for game files
    └── public/              # Place webDOOM game files here
        ├── index.html       # (To be added) Game interface
        ├── index.css        # (To be added) Game styling
        ├── index.js         # (To be added) Game logic
        ├── doom.js          # (To be added) WAD loader
        ├── *.wasm           # (To be added) WebAssembly binaries
        ├── *.data           # (To be added) Game data files
        └── img/             # (To be added) Game images
```

## Technical Details

### WebAssembly & Emscripten

This project uses:
- **PrBoom**: Open-source DOOM engine
- **Emscripten**: C/C++ to WebAssembly compiler
- **Emscripten FS**: Virtual filesystem for mounting .WAD files

### How the WAD Loader Works

1. User selects a .WAD file using the file input
2. JavaScript reads the file as an ArrayBuffer
3. The file is mounted to Emscripten's virtual filesystem using `FS_createDataFile`
4. The DOOM engine is called with the mounted .WAD file using `Module.callMain(['-iwad', filename])`
5. The game starts rendering on the canvas element

### Browser Compatibility

Requires a modern browser with:
- ✅ WebAssembly support
- ✅ JavaScript ES6+ support
- ✅ HTML5 Canvas support

Tested and working on:
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Edge 90+
- ✅ Safari 14+

## Troubleshooting

### Site shows landing page but no game
**Solution**: Game files need to be added to the `webDOOM/public/` directory. See the "Where to Get .WAD Files and Game Engine" section.

### Game won't load (when files are present)
- Make sure you're using an HTTP server (not `file://`)
- Check browser console for errors
- Try a different .WAD file
- Clear browser cache and reload

### WAD file not working
- Ensure the file is a valid DOOM .WAD file
- File must have `.wad` extension
- Try with Doom Shareware or Freedoom first to test

### Performance issues
- Close other browser tabs
- Try a different browser
- Reduce browser window size
- Check CPU usage

### Black screen
- Wait for the game to fully load (check loading percentage)
- Click on the canvas to start the game
- Try refreshing the page

## Credits & Acknowledgments

- **Original DOOM**: id Software
- **PrBoom**: PrBoom development team
- **WebAssembly Port**: Based on [webDOOM by Ustym Ukhman](https://github.com/UstymUkhman/webDOOM)
- **Emscripten**: Emscripten developers
- **Freedoom**: Freedoom project contributors

## License

This project is for educational purposes. 

- The DOOM engine source code (PrBoom) is licensed under GPL
- Original DOOM game assets are copyrighted by id Software
- This web implementation inherits the original project's license

Please ensure you have legal rights to any .WAD files you use.

## Contributing

Feel free to fork this project and submit pull requests for:
- Bug fixes
- Performance improvements
- UI/UX enhancements
- Documentation improvements

## Run in Browser / GitHub Pages

This repository can be built to **WebAssembly** and deployed to **GitHub Pages** for in-browser gameplay.

### Automated Build and Deploy

The repository includes a **GitHub Actions workflow** (`.github/workflows/build-and-deploy.yml`) that automatically:
1. Compiles DOOM source code to WebAssembly using Emscripten
2. Packages the game with a web-based loader
3. Deploys to GitHub Pages

The workflow triggers on:
- **Push to main branch** (automatic deployment)
- **Manual dispatch** (via GitHub Actions UI)

### Important: WAD File Requirements

⚠️ **WAD files are NOT included** in this repository due to licensing restrictions.

To build and run the game, you need to:
1. **Obtain a WAD file** (game data):
   - **Free options**: [Freedoom](https://freedoom.github.io/) or [DOOM Shareware](https://distro.ibiblio.org/slitaz/sources/packages/d/doom1.wad)
   - **Commercial**: Use your own copy if you own the original game
2. **Place the WAD** at `data/doom.wad` in the repository
3. **Commit and push** to trigger the build workflow

Alternatively, modify `build.sh` to fetch a WAD from an external URL or implement runtime loading.

### Local Build Instructions

To build locally, you need **Emscripten SDK** installed:

```bash
# Install Emscripten SDK (one-time setup)
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh

# Return to project directory
cd /path/to/project-DOOMbr

# Configure source files (edit build.sh)
# Update SOURCE_FILES and INCLUDE_DIRS to match your source layout

# Place WAD file (optional but recommended)
mkdir -p data
cp /path/to/your/doom.wad data/

# Run build script
./build.sh

# Test locally
cd docs
python3 -m http.server 8000
# Open http://localhost:8000 in browser
```

### Enabling GitHub Pages

If Pages isn't enabled yet:

1. Go to **Settings** → **Pages** in your repository
2. Under **Source**, select:
   - Branch: **`gh-pages`** (created by workflow)
   - Folder: **`/ (root)`**
3. Click **Save**
4. Your site will be available at: `https://<username>.github.io/<repository>/`

### Notes on Large WADs and Git LFS

- **Large WAD files** (> 50 MB) may cause issues with standard Git
- Consider using **Git Large File Storage (LFS)** for WAD files:
  ```bash
  git lfs install
  git lfs track "*.wad"
  git add .gitattributes
  ```
- Alternatively, **fetch WADs at build time** by modifying `build.sh`:
  ```bash
  # Example: Download Freedoom WAD during build
  curl -L -o data/doom.wad https://example.com/freedoom1.wad
  ```

### Build Script Customization

The `build.sh` script uses **placeholder source file patterns**. Before building:

1. **Edit `build.sh`** to match your repository structure
2. Update these variables:
   - `SOURCE_FILES`: Glob pattern for C/C++ source files
   - `INCLUDE_DIRS`: Directories containing header files
   - `WAD_PATH`: Location of your WAD file
3. Adjust **Emscripten flags** if needed (optimization, memory settings, etc.)

Example configurations:
```bash
# For PrBoom source layout
SOURCE_FILES="prboom/*.c prboom/engine/*.c"
INCLUDE_DIRS="-Iprboom -Iprboom/engine"

# For Chocolate DOOM
SOURCE_FILES="src/*.c src/doom/*.c"
INCLUDE_DIRS="-Isrc -Isrc/doom"
```

## Resources

- [Original webDOOM Project](https://github.com/UstymUkhman/webDOOM)
- [PrBoom Source](http://prboom.sourceforge.net/)
- [Emscripten Documentation](https://emscripten.org/)
- [Freedoom Project](https://freedoom.github.io/)
- [DOOM Wiki](https://doomwiki.org/)

---

**Enjoy playing DOOM in your browser! 🎮👾**

For issues or questions, please open an issue on GitHub.
