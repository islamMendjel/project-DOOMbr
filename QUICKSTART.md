# Quick Start Guide for webDOOM

## ✅ Setup Complete!

Your project is now ready for GitHub Pages deployment with custom .WAD file upload support!

## 📁 Files Created/Modified

### Root Directory (`/project-DOOMbr/`)
- ✅ `.nojekyll` - Bypasses Jekyll processing on GitHub Pages
- ✅ `index.html` - Root redirect page to webDOOM
- ✅ `README.md` - Comprehensive documentation
- ✅ `GITHUB_PAGES.md` - GitHub Pages setup instructions

### Public Directory (`/webDOOM/public/`)
- ✅ `index.html` - Updated with .WAD upload interface
- ✅ `doom.js` - **NEW** - WebAssembly loader for custom .WAD files
- ✅ `index.css` - Updated with new styling for upload section
- ✅ `index.js` - Existing game logic (unchanged)
- ✅ `doom1.js`, `doom2.js` - Existing WebAssembly modules (unchanged)

## 🚀 Next Steps

### 1. Test Locally (Recommended)

```bash
cd webDOOM/public
python3 -m http.server 8000
```

Then visit: `http://localhost:8000`

### 2. Push to GitHub

```bash
git add .
git commit -m "Add WAD file upload support and GitHub Pages configuration"
git push origin main
```

### 3. Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** → **Pages**
3. Under **Source**:
   - Branch: `main` (or `master`)
   - Folder: `/ (root)`
4. Click **Save**

### 4. Access Your Game

After 1-2 minutes, visit:
```
https://[your-username].github.io/project-webDOOM/
```

Or directly:
```
https://[your-username].github.io/project-webDOOM/webDOOM/public/
```

## 🎮 How to Use

### Upload Custom .WAD Files
1. Visit your deployed site
2. Click "Choose .WAD File"
3. Select a .WAD file (Freedoom, Doom Shareware, etc.)
4. Game loads automatically!

### Play Pre-loaded Games
1. Click on DOOM or DOOM II preview images
2. Wait for loading
3. Start playing!

## 📥 Where to Get Free .WAD Files

1. **Freedoom**: https://freedoom.github.io/
   - Free and open-source
   - Files: `freedoom1.wad`, `freedoom2.wad`

2. **Doom Shareware**: https://archive.org/details/DoomsharewareEpisode
   - Free official shareware version
   - File: `doom1.wad`

## 🔧 Technical Features Implemented

✅ **File Upload Interface**
- HTML5 file input for .WAD files
- Real-time file name display
- Accepts .wad and .WAD extensions

✅ **WebAssembly Integration**
- Automatic WASM module loading
- Virtual filesystem mounting via Emscripten
- Dynamic .WAD file integration

✅ **User Experience**
- Loading indicators
- Fullscreen support
- Responsive design
- Mobile-friendly interface
- Clean, themed UI

✅ **GitHub Pages Ready**
- .nojekyll file for static serving
- Optimized structure
- Root-level redirect
- Clear documentation

## 🐛 Troubleshooting

### Issue: Game won't load
**Solution**: Make sure you're using an HTTP server, not opening files directly

### Issue: WAD file rejected
**Solution**: Ensure file has .wad extension and is a valid DOOM WAD file

### Issue: Black screen
**Solution**: Wait for loading to complete, then click on canvas to start

### Issue: GitHub Pages not working
**Solution**: Check that:
- `.nojekyll` file exists in root
- GitHub Pages is enabled in Settings
- Branch and folder are correctly selected
- Wait 2-3 minutes for deployment

## 📚 Documentation

- Full README: `README.md`
- GitHub Pages Info: `GITHUB_PAGES.md`
- This Guide: `QUICKSTART.md`

## 🎉 You're All Set!

Your webDOOM project is now configured and ready to deploy. Enjoy playing DOOM in the browser!

---

**Happy Gaming! 🎮**
