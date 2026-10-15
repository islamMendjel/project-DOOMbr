#!/usr/bin/env bash
################################################################################
# build.sh - Download and prepare Freedoom game assets for browser DOOM
#
# Idempotently downloads Freedoom v0.13.0, verifies SHA-256 checksums,
# and extracts freedoom1.wad and freedoom2.wad into docs/wads/
################################################################################

set -euo pipefail

FREEDOOM_VERSION="0.13.0"
FREEDOOM_ZIP_SHA256="3f9b264f3e3ce503b4fb7f6bdcb1f419d93c7b546f4df3e874dd878db9688f59"
FREEDOOM1_SHA256="7323bcc168c5a45ff10749b339960e98314740a734c30d4b9f3337001f9e703d"
FREEDOOM2_SHA256="a8772e088847032510d97ba2312406a6998f21cbab44d4ff10696faa9c0ecd4b"

FREEDOOM_URL="https://github.com/freedoom/freedoom/releases/download/v${FREEDOOM_VERSION}/freedoom-${FREEDOOM_VERSION}.zip"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${SCRIPT_DIR}/docs/wads"

echo "========================================="
echo "DOOM Browser Assets - Freedoom Download"
echo "========================================="
echo "Target directory: ${TARGET_DIR}"

# Check required commands
for cmd in curl unzip sha256sum; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: Required tool '$cmd' is not installed." >&2
        echo "Please install $cmd to build/download assets." >&2
        exit 1
    fi
done

mkdir -p "${TARGET_DIR}"

# Verify helper
check_file_sha256() {
    local file="$1"
    local expected="$2"
    if [[ ! -f "$file" ]]; then
        return 1
    fi
    local actual
    actual="$(sha256sum "$file" | awk '{print $1}')"
    [[ "$actual" == "$expected" ]]
}

# Check if both WADs already exist and match expected checksums
if check_file_sha256 "${TARGET_DIR}/freedoom1.wad" "${FREEDOOM1_SHA256}" && \
   check_file_sha256 "${TARGET_DIR}/freedoom2.wad" "${FREEDOOM2_SHA256}"; then
    echo "✓ Freedoom Phase 1 & 2 WADs already present with verified checksums. Skipping download."
    exit 0
fi

TEMP_DIR="$(mktemp -d -t freedoom-build-XXXXXX)"
cleanup() {
    rm -rf "${TEMP_DIR}"
}
trap cleanup EXIT

ZIP_PATH="${TEMP_DIR}/freedoom-${FREEDOOM_VERSION}.zip"

echo "Downloading Freedoom v${FREEDOOM_VERSION}..."
curl -fsSL -o "${ZIP_PATH}" "${FREEDOOM_URL}"

echo "Verifying archive SHA-256 checksum..."
ACTUAL_ZIP_SHA="$(sha256sum "${ZIP_PATH}" | awk '{print $1}')"
if [[ "${ACTUAL_ZIP_SHA}" != "${FREEDOOM_ZIP_SHA256}" ]]; then
    echo "ERROR: SHA-256 checksum mismatch for ${ZIP_PATH}!" >&2
    echo "Expected: ${FREEDOOM_ZIP_SHA256}" >&2
    echo "Got:      ${ACTUAL_ZIP_SHA}" >&2
    exit 1
fi
echo "✓ Archive checksum verified."

echo "Extracting WADs..."
unzip -q -j "${ZIP_PATH}" "freedoom-${FREEDOOM_VERSION}/freedoom1.wad" "freedoom-${FREEDOOM_VERSION}/freedoom2.wad" -d "${TARGET_DIR}"

echo "Verifying extracted WAD checksums..."
if ! check_file_sha256 "${TARGET_DIR}/freedoom1.wad" "${FREEDOOM1_SHA256}"; then
    echo "ERROR: freedoom1.wad checksum mismatch!" >&2
    exit 1
fi

if ! check_file_sha256 "${TARGET_DIR}/freedoom2.wad" "${FREEDOOM2_SHA256}"; then
    echo "ERROR: freedoom2.wad checksum mismatch!" >&2
    exit 1
fi

echo "========================================="
echo "✓ Freedoom assets prepared successfully!"
echo "  - ${TARGET_DIR}/freedoom1.wad ($(du -h "${TARGET_DIR}/freedoom1.wad" | cut -f1))"
echo "  - ${TARGET_DIR}/freedoom2.wad ($(du -h "${TARGET_DIR}/freedoom2.wad" | cut -f1))"
echo "========================================="
