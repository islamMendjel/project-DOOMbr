#!/bin/bash
################################################################################
# build.sh - Download and prepare DOOM assets for browser-based gameplay
#
# This script downloads the Freedoom WAD file which is used with js-dos
# to play DOOM in the browser. No compilation is needed.
#
# REQUIREMENTS:
#   - curl or wget for downloading files
#   - unzip for extracting archives
#
# USAGE:
#   ./build.sh
#
# OUTPUT:
#   Downloads freedoom1.wad to docs/ directory
#
################################################################################

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

echo "========================================="
echo "DOOM Browser Deployment - Asset Download"
echo "========================================="
echo ""
echo "This script downloads the Freedoom WAD file for use with js-dos."
echo "No compilation is needed - the game runs directly in the browser!"
echo ""

# Output directory
OUTPUT_DIR="docs"
echo "Output directory: ${OUTPUT_DIR}/"
mkdir -p "${OUTPUT_DIR}"

# Freedoom version
FREEDOOM_VERSION="0.12.1"
FREEDOOM_URL="https://github.com/freedoom/freedoom/releases/download/v${FREEDOOM_VERSION}/freedoom-${FREEDOOM_VERSION}.zip"
TEMP_DIR=$(mktemp -d)

echo "Downloading Freedoom ${FREEDOOM_VERSION}..."
echo "URL: ${FREEDOOM_URL}"
echo ""

# Download Freedoom
if command -v curl &> /dev/null; then
    curl -L -o "${TEMP_DIR}/freedoom.zip" "${FREEDOOM_URL}"
elif command -v wget &> /dev/null; then
    wget -O "${TEMP_DIR}/freedoom.zip" "${FREEDOOM_URL}"
else
    echo "ERROR: Neither curl nor wget is available."
    echo "Please install curl or wget to download files."
    exit 1
fi

echo ""
echo "Extracting Freedoom WAD file..."

# Extract the archive
unzip -q "${TEMP_DIR}/freedoom.zip" -d "${TEMP_DIR}"

# Copy the WAD file to the output directory
cp "${TEMP_DIR}/freedoom-${FREEDOOM_VERSION}/freedoom1.wad" "${OUTPUT_DIR}/"

# Get file size
WAD_SIZE=$(du -h "${OUTPUT_DIR}/freedoom1.wad" | cut -f1)

echo "✓ Freedoom WAD file extracted: ${OUTPUT_DIR}/freedoom1.wad (${WAD_SIZE})"

# Cleanup
rm -rf "${TEMP_DIR}"

echo ""
echo "========================================="
echo "✓ Build completed successfully!"
echo "========================================="
echo ""
echo "Output files:"
echo "  - ${OUTPUT_DIR}/index.html (DOOM player interface)"
echo "  - ${OUTPUT_DIR}/freedoom1.wad (Game data, ${WAD_SIZE})"
echo ""
echo "The game is ready to deploy!"
echo ""
echo "To test locally:"
echo "  cd ${OUTPUT_DIR}"
echo "  python3 -m http.server 8000"
echo "  # Then open http://localhost:8000 in your browser"
echo ""
echo "To deploy to GitHub Pages:"
echo "  git add ${OUTPUT_DIR}/"
echo "  git commit -m 'Add DOOM game assets'"
echo "  git push origin main"
echo ""
echo "The game uses js-dos to run DOOM directly in the browser."
echo "No compilation or build tools are required!"
echo ""
