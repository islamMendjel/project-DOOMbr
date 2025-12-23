#!/bin/bash
################################################################################
# build.sh - Build DOOM engine to WebAssembly using Emscripten
#
# This script compiles the DOOM engine source code to WebAssembly (doom.js and
# doom.wasm) and outputs them to the docs/ directory for GitHub Pages deployment.
#
# PREREQUISITES:
#   - Emscripten SDK (emsdk) must be installed and activated
#   - DOOM engine source files must be present
#   - (Optional) DOOM WAD file at data/doom.wad for embedding
#
# CUSTOMIZATION INSTRUCTIONS:
#   1. Update SOURCE_FILES to match your actual source file locations
#      Current: src/*.c src/*.cpp (placeholders)
#      Example: src/doom/*.c src/doom/*.cpp linuxdoom-1.10/*.c
#
#   2. Update INCLUDE_DIRS to match your header file locations
#      Current: -Isrc -Iinclude (placeholders)
#      Example: -Ilinuxdoom-1.10 -Isrc/doom
#
#   3. If you have a WAD file, place it at data/doom.wad
#      The script will automatically embed it using --preload-file
#
#   4. Adjust Emscripten flags if needed (memory, optimizations, etc.)
#
# USAGE:
#   ./build.sh
#
################################################################################

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "  DOOM WebAssembly Build Script"
echo "========================================="
echo ""

# Check if emcc is available
if ! command -v emcc &> /dev/null; then
    echo -e "${RED}Error: emcc (Emscripten compiler) not found!${NC}"
    echo "Please install and activate the Emscripten SDK:"
    echo "  git clone https://github.com/emscripten-core/emsdk.git"
    echo "  cd emsdk"
    echo "  ./emsdk install latest"
    echo "  ./emsdk activate latest"
    echo "  source ./emsdk_env.sh"
    exit 1
fi

echo -e "${GREEN}✓ Emscripten compiler found${NC}"
emcc --version | head -n1

# Create output directory
echo ""
echo "Creating output directory..."
mkdir -p docs
echo -e "${GREEN}✓ docs/ directory ready${NC}"

# Source files configuration
# TODO: Update these paths to match your DOOM source code layout
SOURCE_FILES="src/*.c src/*.cpp"
INCLUDE_DIRS="-Isrc -Iinclude"

echo ""
echo "Checking for source files..."
# Check if source files exist
if ! compgen -G "src/*.c" > /dev/null 2>&1 && ! compgen -G "src/*.cpp" > /dev/null 2>&1; then
    echo -e "${YELLOW}Warning: No source files found matching: ${SOURCE_FILES}${NC}"
    echo -e "${YELLOW}This is expected if you haven't added DOOM source code yet.${NC}"
    echo ""
    echo "To complete the build:"
    echo "  1. Add DOOM engine source files to your repository"
    echo "  2. Update SOURCE_FILES in this script to match your file locations"
    echo "  3. Update INCLUDE_DIRS to point to your header file directories"
    echo "  4. Run this script again"
    echo ""
    echo "Example source file locations:"
    echo "  - linuxdoom-1.10/*.c"
    echo "  - prboom/*.c"
    echo "  - chocolate-doom/src/*.c"
    exit 1
fi

echo -e "${GREEN}✓ Source files found${NC}"

# Check for WAD file
WAD_FILE="data/doom.wad"
PRELOAD_FLAG=""

echo ""
echo "Checking for WAD file..."
if [ -f "$WAD_FILE" ]; then
    echo -e "${GREEN}✓ WAD file found at ${WAD_FILE}${NC}"
    PRELOAD_FLAG="--preload-file ${WAD_FILE}"
else
    echo -e "${YELLOW}⚠ No WAD file found at ${WAD_FILE}${NC}"
    echo "  The build will continue, but the game won't run without a WAD file."
    echo "  To add a WAD file:"
    echo "    1. Obtain a legal DOOM WAD file (shareware, Freedoom, or purchased)"
    echo "    2. Place it at: ${WAD_FILE}"
    echo "    3. Run this script again"
fi

# Emscripten compiler flags
EMCC_FLAGS=(
    -O3                                    # Optimization level
    -s WASM=1                             # Enable WebAssembly
    -s ALLOW_MEMORY_GROWTH=1              # Allow memory to grow
    -s INITIAL_MEMORY=67108864            # 64MB initial memory
    -s MAXIMUM_MEMORY=268435456           # 256MB maximum memory
    -s USE_SDL=2                          # Use SDL2
    -s ASYNCIFY=1                         # Enable async operations
    -s EXPORTED_RUNTIME_METHODS='["callMain"]'  # Export callMain
    -s EXPORTED_FUNCTIONS='["_main"]'     # Export main function
    --shell-file /dev/null                # No default shell (we have custom HTML)
    -o docs/doom.js                       # Output file
)

# Add preload flag if WAD exists
if [ -n "$PRELOAD_FLAG" ]; then
    EMCC_FLAGS+=($PRELOAD_FLAG)
fi

# Build command
echo ""
echo "========================================="
echo "  Starting compilation..."
echo "========================================="
echo ""
echo "Command:"
echo "emcc $SOURCE_FILES $INCLUDE_DIRS ${EMCC_FLAGS[*]}"
echo ""

# Execute the build
if emcc $SOURCE_FILES $INCLUDE_DIRS "${EMCC_FLAGS[@]}"; then
    echo ""
    echo "========================================="
    echo -e "${GREEN}  ✓ Build successful!${NC}"
    echo "========================================="
    echo ""
    echo "Output files:"
    ls -lh docs/doom.js docs/doom.wasm 2>/dev/null || true
    if [ -f "docs/doom.data" ]; then
        ls -lh docs/doom.data
    fi
    echo ""
    echo "Next steps:"
    echo "  1. Test locally: python3 -m http.server 8000"
    echo "     Then visit: http://localhost:8000/docs/"
    echo "  2. Push to GitHub to trigger automatic deployment"
    echo "  3. Visit your GitHub Pages site to play DOOM!"
else
    echo ""
    echo "========================================="
    echo -e "${RED}  ✗ Build failed!${NC}"
    echo "========================================="
    echo ""
    echo "Common issues:"
    echo "  - Check that SOURCE_FILES paths are correct"
    echo "  - Check that INCLUDE_DIRS paths are correct"
    echo "  - Make sure all source files compile without errors"
    echo "  - Check Emscripten compiler output above for specific errors"
    exit 1
fi
