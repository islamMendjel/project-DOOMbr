# Play DOOM in Your Browser

> Experience the classic **DOOM** game right in your browser using **WebAssembly**!

This project allows you to play DOOM directly in your web browser. You can either use the pre-loaded game versions or upload your own .WAD files (Doom Shareware, Freedoom, or any compatible DOOM .WAD file).

🎮 **[Play Now on GitHub Pages](https://yourusername.github.io/project-webDOOM/webDOOM/public/)** _(Update with your GitHub username)_

![DOOM Preview](webDOOM/public/preview.gif)

## Features

- 🚀 **Browser-Based Gaming**: Play DOOM without any installation
- 📁 **Custom .WAD Support**: Upload your own DOOM .WAD files
- 🎯 **Pre-loaded Games**: Includes DOOM and DOOM II ready to play
- 🖥️ **WebAssembly Powered**: Compiled using Emscripten for optimal performance
- 📱 **Responsive Design**: Works on desktop and mobile devices

## How to Play

### Option 1: Upload Your Own .WAD File

1. Visit the game page
2. Click on **"Choose .WAD File"** button
3. Select your .WAD file from your computer:
   - **Doom Shareware** (`doom1.wad`) - Free version available online
   - **Freedoom** (`freedoom1.wad` or `freedoom2.wad`) - Free and open-source alternative
   - **Full Doom/Doom II** - If you own the original game
4. The game will automatically load and start!

### Option 2: Play Pre-loaded Games

1. Visit the game page
2. Click on either the **DOOM** or **DOOM II** preview image
3. Wait for the game to load
4. Start playing!

### Game Controls

- **W/A/S/D** or **Arrow Keys**: Move
- **Mouse**: Look around
- **Left Click**: Shoot
- **Space**: Use/Open doors
- **Shift**: Run
- **Ctrl**: Fire
- **E**: Use
- **Tab**: Map
- **Esc**: Menu

## Where to Get .WAD Files

### Free Options:

1. **Doom Shareware**: 
   - Download from: [Doom Shareware on archive.org](https://archive.org/details/DoomsharewareEpisode)
   - File: `doom1.wad`

2. **Freedoom**:
   - Official website: [https://freedoom.github.io/](https://freedoom.github.io/)
   - Download: Free and open-source DOOM-compatible game
   - Files: `freedoom1.wad`, `freedoom2.wad`

### Commercial Options:

If you own the original games, you can use:
- **DOOM** (`doom.wad`)
- **DOOM II** (`doom2.wad`)
- **Ultimate DOOM** (`doomu.wad`)
- Other compatible DOOM engine games

> **Note**: This project does not include copyrighted game assets. You must provide your own .WAD files.

## Local Development & Testing

### Prerequisites

- Python 3.x (for local server) or any HTTP server
- Modern web browser (Chrome, Firefox, Edge, Safari)

### Running Locally

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/project-webDOOM.git
   cd project-webDOOM
   ```

2. **Navigate to the public folder**:
   ```bash
   cd webDOOM/public
   ```

3. **Start a local HTTP server**:
   
   Using Python 3:
   ```bash
   python3 -m http.server 8000
   ```
   
   Or using Python 2:
   ```bash
   python -m SimpleHTTPServer 8000
   ```
   
   Or using Node.js (if you have `http-server` installed):
   ```bash
   npx http-server -p 8000
   ```

4. **Open your browser**:
   ```
   http://localhost:8000
   ```

5. **Upload a .WAD file or select a pre-loaded game** and start playing!

> **Important**: You must use an HTTP server. Opening `index.html` directly with `file://` protocol will not work due to WebAssembly security restrictions.

## GitHub Pages Deployment

This project is configured to be hosted on **GitHub Pages**. Follow these steps to deploy:

### Setup Instructions

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

3. **Wait for deployment**:
   - GitHub will build and deploy your site (usually takes 1-2 minutes)
   - Your site will be available at: `https://yourusername.github.io/project-webDOOM/webDOOM/public/`

4. **Configure Custom Path (Optional)**:
   - If you want the game at the root URL, you can move the contents of `webDOOM/public/` to a `docs/` folder in the root
   - Then select **docs** folder in GitHub Pages settings

### Important Files for GitHub Pages

- **`.nojekyll`**: This file (already included) tells GitHub to bypass Jekyll processing
- **`index.html`**: Main entry point in the `public` folder

## Project Structure

```
project-webDOOM/
├── .nojekyll                 # Bypass Jekyll processing
├── README.md                 # This file
└── webDOOM/                  # Cloned webDOOM repository
    ├── public/               # Web files for GitHub Pages
    │   ├── index.html        # Main HTML page
    │   ├── index.css         # Styling
    │   ├── index.js          # Main JavaScript logic
    │   ├── doom.js           # WAD file loader
    │   ├── doom1.js          # DOOM 1 WebAssembly module
    │   ├── doom1.wasm        # DOOM 1 WebAssembly binary
    │   ├── doom1.data        # DOOM 1 game data
    │   ├── doom2.js          # DOOM 2 WebAssembly module
    │   ├── doom2.wasm        # DOOM 2 WebAssembly binary
    │   ├── doom2.data        # DOOM 2 game data
    │   └── img/              # Images
    └── src/                  # Source code (C files)
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

Tested and working on:
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Edge 90+
- ✅ Safari 14+

Requires:
- WebAssembly support
- JavaScript enabled
- Modern browser with ES6 support

## Troubleshooting

### Game won't load
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
