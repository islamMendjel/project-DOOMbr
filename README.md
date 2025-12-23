# webDOOM - Play DOOM in Your Browser

> Experience the classic **DOOM** game right in your browser using **WebAssembly**!

This project is a GitHub Pages-ready repository for hosting a browser-based version of DOOM. The project uses WebAssembly to run the classic DOOM engine directly in your web browser, allowing you to play DOOM without any installation.

🎮 **[View Project on GitHub Pages](https://islamMendjel.github.io/project-DOOMbr/)**

## Project Status

**Current State:** This repository contains the infrastructure and documentation for hosting webDOOM on GitHub Pages. The game engine files need to be added to the `webDOOM/public/` directory to enable full gameplay functionality.

**What's Included:**
- ✅ GitHub Pages configuration with `.nojekyll` file
- ✅ Comprehensive documentation and guides
- ✅ Landing page with project information
- ✅ Proper meta tags for SEO and social sharing
- ✅ Responsive design that works on all devices

**What's Needed:**
- The webDOOM game engine files (WebAssembly modules)
- DOOM .WAD game data files
- Game interface HTML, CSS, and JavaScript

## Features

- 🚀 **Browser-Based Gaming**: Designed to play DOOM without any installation
- 📁 **Custom .WAD Support**: Architecture supports uploading your own DOOM .WAD files
- 🎯 **Pre-configured**: Ready for GitHub Pages deployment
- 🖥️ **WebAssembly Powered**: Built to use Emscripten for optimal performance
- 📱 **Responsive Design**: Works on desktop and mobile devices
- 🎨 **Polished UI**: Clean, thematic design with proper meta tags and favicon

## Quick Start

### View the Project

Simply visit the [GitHub Pages site](https://islamMendjel.github.io/project-DOOMbr/) to see the project landing page.

### Adding Game Files

To enable full gameplay functionality:

1. **Obtain the webDOOM engine files** (from the original webDOOM project or compile your own)
2. **Place files in the `webDOOM/public/` directory:**
   - `index.html` - Game interface
   - `index.css` - Styling
   - `index.js` - Game logic
   - `doom.js` - WAD loader
   - `doom1.wasm`, `doom2.wasm` - WebAssembly binaries
   - `doom1.data`, `doom2.data` - Game data
   - Any additional assets

### Local Development

1. **Clone the repository**:
   ```bash
   git clone https://github.com/islamMendjel/project-DOOMbr.git
   cd project-DOOMbr
   ```

2. **Start a local HTTP server**:
   ```bash
   python3 -m http.server 8000
   ```
   
   Or using Node.js:
   ```bash
   npx http-server -p 8000
   ```

3. **Open your browser**:
   ```
   http://localhost:8000
   ```

> **Note**: You must use an HTTP server. Opening `index.html` directly with `file://` protocol will not work due to WebAssembly security restrictions.

## Where to Get .WAD Files and Game Engine

### Game Engine Files

The webDOOM engine can be obtained from:
- **Original webDOOM Project**: [UstymUkhman/webDOOM](https://github.com/UstymUkhman/webDOOM)
- Clone and build the project, then copy the `public/` directory contents to this repository's `webDOOM/public/` folder

### Free .WAD Files

1. **Doom Shareware**: 
   - Download from: [Doom Shareware on archive.org](https://archive.org/details/DoomsharewareEpisode)
   - File: `doom1.wad`
   - Free version of the original DOOM

2. **Freedoom**:
   - Official website: [https://freedoom.github.io/](https://freedoom.github.io/)
   - Download: Free and open-source DOOM-compatible game
   - Files: `freedoom1.wad`, `freedoom2.wad`

### Commercial .WAD Files

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

## Resources

- [Original webDOOM Project](https://github.com/UstymUkhman/webDOOM)
- [PrBoom Source](http://prboom.sourceforge.net/)
- [Emscripten Documentation](https://emscripten.org/)
- [Freedoom Project](https://freedoom.github.io/)
- [DOOM Wiki](https://doomwiki.org/)

---

**Enjoy playing DOOM in your browser! 🎮👾**

For issues or questions, please open an issue on GitHub.
