#!/bin/bash
################################################################################
# build.sh - Build DOOM engine to WebAssembly using Emscripten
################################################################################
# This script compiles the DOOM engine source code to WebAssembly using emcc
# (Emscripten compiler). The output files (doom.js and doom.wasm) are placed
# in the docs/ directory for GitHub Pages deployment.
#
# PREREQUISITES:
#   - Emscripten SDK (emsdk) must be installed and activated
#   - emcc must be available in your PATH
#   - DOOM engine source code (adjust SOURCE_FILES and INCLUDES below)
#   - Optional: DOOM WAD file at data/doom.wad (will preload if present)
#
# USAGE:
#   ./build.sh
#
# CUSTOMIZATION:
#   - SOURCE_FILES: Adjust the glob patterns to match your source layout
#   - INCLUDES: Add -I flags for your include directories
#   - EMCC_FLAGS: Modify compiler/linker flags as needed
#   - WAD_FILE: Change the path if your WAD is located elsewhere
#
# OUTPUT:
#   - docs/doom.js       - JavaScript glue code
#   - docs/doom.wasm     - WebAssembly binary
#   - docs/doom.data     - Preloaded data (if WAD file exists)
################################################################################

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================"
echo "DOOM WebAssembly Build Script"
echo "========================================"

# Check if emcc is available
if ! command -v emcc &> /dev/null; then
    echo -e "${RED}ERROR: emcc not found in PATH${NC}"
    echo "Please install and activate Emscripten SDK (emsdk)"
    echo "Visit: https://emscripten.org/docs/getting_started/downloads.html"
    exit 1
fi

echo -e "${GREEN}✓ Emscripten found:${NC} $(emcc --version | head -n1)"

# Create output directory
OUTPUT_DIR="docs"
mkdir -p "$OUTPUT_DIR"
echo -e "${GREEN}✓ Output directory created:${NC} $OUTPUT_DIR/"

# Create data directory if it doesn't exist
mkdir -p data

################################################################################
# CONFIGURATION SECTION - ADJUST THESE FOR YOUR PROJECT
################################################################################

# Source files - ADJUST THESE GLOB PATTERNS TO MATCH YOUR SOURCE LAYOUT
# Example patterns:
#   - "src/*.c src/*.cpp"       - All C/C++ files in src/
#   - "src/**/*.c src/**/*.cpp" - All C/C++ files in src/ and subdirectories
#   - "prboom-2.5.0/src/*.c"    - Specific directory structure
#
# For a real DOOM port, you might have something like:
#   SOURCE_FILES="prboom2/src/*.c prboom2/src/SDL/*.c"
SOURCE_FILES="src/*.c src/*.cpp"

# Include directories - ADD YOUR INCLUDE PATHS HERE
# Example: INCLUDES="-Iinclude -Isrc -Iprboom2/include"
INCLUDES="-Iinclude -Isrc"

# Emscripten compiler flags
EMCC_FLAGS=(
    -O2                                    # Optimization level
    -s WASM=1                             # Enable WebAssembly
    -s ALLOW_MEMORY_GROWTH=1              # Allow memory to grow dynamically
    -s NO_EXIT_RUNTIME=1                  # Keep runtime alive
    -s EXPORTED_RUNTIME_METHODS='["callMain","FS"]'  # Export for JS access
    -s EXPORTED_FUNCTIONS='["_main"]'     # Export main function
    -s USE_SDL=2                          # Use SDL2 (Emscripten provides this)
    -s INITIAL_MEMORY=64MB                # Initial memory allocation
    -s STACK_SIZE=5MB                     # Stack size
    -lidbfs.js                            # IndexedDB filesystem support
)

# WAD file location - CHANGE IF YOUR WAD IS ELSEWHERE
WAD_FILE="data/doom.wad"

################################################################################
# END CONFIGURATION SECTION
################################################################################

echo ""
echo "Configuration:"
echo "  Source pattern: $SOURCE_FILES"
echo "  Include paths: $INCLUDES"
echo "  WAD file: $WAD_FILE"
echo ""

# Check for WAD file
if [ -f "$WAD_FILE" ]; then
    echo -e "${GREEN}✓ WAD file found:${NC} $WAD_FILE"
    WAD_SIZE=$(du -h "$WAD_FILE" | cut -f1)
    echo "  Size: $WAD_SIZE"
    PRELOAD_FLAG="--preload-file ${WAD_FILE}@/doom.wad"
    echo ""
    echo -e "${YELLOW}Note: WAD file will be embedded in the build.${NC}"
    echo "      This may result in a large doom.data file."
else
    echo -e "${YELLOW}⚠ WAD file not found:${NC} $WAD_FILE"
    echo "  The build will continue without a preloaded WAD."
    echo "  You can:"
    echo "    1. Place a WAD file at $WAD_FILE and rebuild"
    echo "    2. Modify the loader to fetch WAD files dynamically"
    echo "    3. Use Emscripten's filesystem API to load WADs at runtime"
    PRELOAD_FLAG=""
fi

# Collect source files
echo ""
echo "Searching for source files..."
SOURCE_LIST=""
for pattern in $SOURCE_FILES; do
    # Use shell globbing to find files
    for file in $pattern; do
        if [ -f "$file" ]; then
            SOURCE_LIST="$SOURCE_LIST $file"
        fi
    done
done

if [ -z "$SOURCE_LIST" ]; then
    echo -e "${YELLOW}⚠ No source files found matching pattern:${NC} $SOURCE_FILES"
    echo ""
    echo "This is expected if you haven't added DOOM source code yet."
    echo ""
    echo "To complete the build setup:"
    echo "  1. Obtain DOOM engine source code (e.g., PrBoom, Chocolate DOOM)"
    echo "  2. Place source files in the appropriate directory"
    echo "  3. Update SOURCE_FILES and INCLUDES variables in this script"
    echo "  4. Run this script again"
    echo ""
    echo "Creating placeholder files in docs/ for testing workflow..."
    
    # Create minimal placeholder files for workflow testing
    echo "// Placeholder - replace with actual Emscripten build output" > "$OUTPUT_DIR/doom.js"
    echo "console.log('DOOM WebAssembly placeholder - run build.sh with source code');" >> "$OUTPUT_DIR/doom.js"
    
    echo -e "${GREEN}✓ Placeholder files created${NC}"
    echo "  GitHub Actions workflow will run successfully but won't produce a working game"
    echo "  until source code is added and this script is customized."
    exit 0
fi

# Count files
FILE_COUNT=$(echo "$SOURCE_LIST" | wc -w)
echo -e "${GREEN}✓ Found $FILE_COUNT source file(s)${NC}"

# Build with emcc
echo ""
echo "Building with Emscripten..."
echo "This may take several minutes..."
echo ""

# Show the command (helpful for debugging)
echo "Command:"
echo "  emcc $INCLUDES $SOURCE_LIST ${EMCC_FLAGS[*]} $PRELOAD_FLAG -o $OUTPUT_DIR/doom.js"
echo ""

# Execute the build - use direct command instead of string variable for safety
if emcc $INCLUDES $SOURCE_LIST "${EMCC_FLAGS[@]}" $PRELOAD_FLAG -o "$OUTPUT_DIR/doom.js"; then
    echo ""
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo ""
    echo "Output files:"
    ls -lh "$OUTPUT_DIR/doom.js" "$OUTPUT_DIR/doom.wasm" 2>/dev/null || true
    if [ -f "$OUTPUT_DIR/doom.data" ]; then
        ls -lh "$OUTPUT_DIR/doom.data"
    fi
    echo ""
    echo "To test locally:"
    echo "  cd docs && python3 -m http.server 8000"
    echo "  Then open: http://localhost:8000"
    echo ""
    echo "Files are ready for GitHub Pages deployment!"
else
    echo ""
    echo -e "${RED}✗ Build failed${NC}"
    echo "Check the error messages above and verify:"
    echo "  1. Source files exist and paths are correct"
    echo "  2. Include paths are correct"
    echo "  3. All dependencies are available"
    echo "  4. Emscripten version is compatible"
    exit 1
fi
