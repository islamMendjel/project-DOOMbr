#!/bin/bash
################################################################################
# build.sh - Build DOOM engine to WebAssembly using Emscripten
#
# This script compiles DOOM C/C++ source files into WebAssembly modules
# (doom.js and doom.wasm) for deployment to GitHub Pages.
#
# REQUIREMENTS:
#   - Emscripten SDK (emsdk) installed and activated (emcc must be in PATH)
#   - DOOM engine source files (adjust SOURCE_FILES below to match your layout)
#   - Optional: WAD file at data/doom.wad for preloading
#
# USAGE:
#   ./build.sh
#
# OUTPUT:
#   Generates docs/doom.js and docs/doom.wasm
#
# CUSTOMIZATION:
#   - Edit SOURCE_FILES to point to your actual C/C++ source files
#   - Edit INCLUDE_DIRS to add include directories for headers
#   - Edit EMSCRIPTEN_FLAGS to adjust compilation settings
#   - Edit WAD_PATH if your WAD file is in a different location
#
################################################################################

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

echo "========================================="
echo "DOOM WebAssembly Build Script"
echo "========================================="

# Check if emcc is available
if ! command -v emcc &> /dev/null; then
    echo "ERROR: emcc not found in PATH"
    echo "Please install and activate Emscripten SDK (emsdk) before running this script."
    echo ""
    echo "Installation instructions:"
    echo "  git clone https://github.com/emscripten-core/emsdk.git"
    echo "  cd emsdk"
    echo "  ./emsdk install latest"
    echo "  ./emsdk activate latest"
    echo "  source ./emsdk_env.sh"
    exit 1
fi

echo "✓ Emscripten found: $(emcc --version | head -n 1)"

# Create output directory
OUTPUT_DIR="docs"
echo "Creating output directory: ${OUTPUT_DIR}/"
mkdir -p "${OUTPUT_DIR}"

# =============================================================================
# SOURCE FILES CONFIGURATION
# =============================================================================
# IMPORTANT: Adjust these paths to match your repository structure!
#
# This is a placeholder configuration. You will need to:
# 1. Replace these globs with actual paths to your DOOM source files
# 2. Ensure all required .c and .cpp files are included
# 3. Add any subdirectories that contain source files
#
# Examples:
#   SOURCE_FILES="src/*.c src/*.cpp src/engine/*.c"
#   SOURCE_FILES="prboom/*.c prboom/engine/*.c"
#   SOURCE_FILES="$(find src -name '*.c' -o -name '*.cpp')"
#
# =============================================================================
SOURCE_FILES="src/*.c src/*.cpp"

# Check if source files exist
echo ""
echo "Checking for source files..."
if ! compgen -G ${SOURCE_FILES} > /dev/null 2>&1; then
    echo "WARNING: No source files found matching pattern: ${SOURCE_FILES}"
    echo ""
    echo "CONFIGURATION REQUIRED:"
    echo "  Please edit this script and update SOURCE_FILES to point to your"
    echo "  actual DOOM engine source files (C/C++ files)."
    echo ""
    echo "  Current pattern: ${SOURCE_FILES}"
    echo ""
    echo "  If you don't have source files yet, you need to:"
    echo "  1. Add DOOM engine source code to your repository, OR"
    echo "  2. Use a DOOM port like PrBoom or Chocolate DOOM"
    echo ""
    exit 1
fi

echo "✓ Source files found"

# =============================================================================
# INCLUDE DIRECTORIES
# =============================================================================
# Add any directories containing header files (.h)
# Examples:
#   INCLUDE_DIRS="-Isrc -Isrc/engine -Iinclude"
# =============================================================================
INCLUDE_DIRS="-Isrc -Iinclude"

# =============================================================================
# EMSCRIPTEN COMPILATION FLAGS
# =============================================================================
# These flags control how the code is compiled to WebAssembly.
# Adjust as needed for your specific DOOM port and requirements.
# =============================================================================
EMSCRIPTEN_FLAGS=(
    -O3                                    # Optimization level (O3 = high performance)
    -s WASM=1                              # Generate WebAssembly
    -s ALLOW_MEMORY_GROWTH=1               # Allow dynamic memory allocation
    -s USE_SDL=2                           # Use SDL2 for graphics/input
    -s ASSERTIONS=0                        # Disable assertions (for production)
    -s FORCE_FILESYSTEM=1                  # Enable filesystem support
    -s EXPORTED_RUNTIME_METHODS='["callMain","FS"]'  # Export Module methods
    --shell-file "${OUTPUT_DIR}/index.html"  # Use our custom HTML shell
    -o "${OUTPUT_DIR}/doom.js"             # Output JavaScript file
)

# =============================================================================
# WAD FILE PRELOADING
# =============================================================================
# Check if WAD file exists and add preload flag
# The WAD file contains game data (levels, textures, sounds, etc.)
# =============================================================================
WAD_PATH="data/doom.wad"

echo ""
echo "Checking for WAD file..."
if [ -f "${WAD_PATH}" ]; then
    echo "✓ WAD file found: ${WAD_PATH}"
    echo "  This file will be preloaded into the virtual filesystem."
    EMSCRIPTEN_FLAGS+=(--preload-file "${WAD_PATH}@/doom.wad")
else
    echo "⚠ WARNING: WAD file not found at ${WAD_PATH}"
    echo ""
    echo "  The game will be compiled, but won't have game data to load."
    echo "  To include game data:"
    echo "    1. Place a WAD file at ${WAD_PATH}, OR"
    echo "    2. Modify this script to fetch a WAD from an external URL, OR"
    echo "    3. Implement runtime WAD loading in your JavaScript code"
    echo ""
    echo "  Free WAD options:"
    echo "    - Freedoom: https://freedoom.github.io/"
    echo "    - DOOM Shareware: https://distro.ibiblio.org/slitaz/sources/packages/d/doom1.wad"
    echo ""
    echo "  NOTE: Commercial WAD files (doom.wad, doom2.wad) are copyrighted."
    echo "        Only use them if you own the original game."
    echo ""
    echo "  Continuing build without WAD preloading..."
fi

# =============================================================================
# COMPILE
# =============================================================================
echo ""
echo "Starting compilation..."
echo "This may take several minutes depending on the size of the codebase."
echo ""

# Build the command with all source files expanded
set -x  # Show the actual command being executed
emcc ${SOURCE_FILES} \
    ${INCLUDE_DIRS} \
    "${EMSCRIPTEN_FLAGS[@]}"
set +x

echo ""
echo "========================================="
echo "✓ Build completed successfully!"
echo "========================================="
echo ""
echo "Output files:"
echo "  - ${OUTPUT_DIR}/doom.js"
echo "  - ${OUTPUT_DIR}/doom.wasm"
echo "  - ${OUTPUT_DIR}/index.html"
if [ -f "${WAD_PATH}" ]; then
    echo "  - ${OUTPUT_DIR}/doom.data (preloaded WAD)"
fi
echo ""
echo "To test locally:"
echo "  cd ${OUTPUT_DIR}"
echo "  python3 -m http.server 8000"
echo "  # Then open http://localhost:8000 in your browser"
echo ""
echo "To deploy to GitHub Pages:"
echo "  git add ${OUTPUT_DIR}/"
echo "  git commit -m 'Add DOOM WebAssembly build'"
echo "  git push origin main"
echo ""
