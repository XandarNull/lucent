#!/usr/bin/env bash
# ==============================================================================
# Lucent Theme Suite Distribution Packager
# Author: Xandar Null
# License: GPLv3
# Compatibility: KDE Plasma 6 (Linux)
# ==============================================================================

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="1.0"
DIST_DIR="${ROOT_DIR}/dist"
KDE_STORE_DIR="${DIST_DIR}/kde-store"

echo "Building Lucent Theme Suite distribution packages (v${VERSION})..."

# Clean and recreate dist folders
rm -rf "${DIST_DIR}"
mkdir -p "${DIST_DIR}" "${KDE_STORE_DIR}"

# 1. Package KDE Store: Plasma Desktop Style
echo "-> Packaging KDE Store: Plasma Desktop Style (Lucent-Plasma-Theme.tar.gz)..."
tar -czf "${KDE_STORE_DIR}/Lucent-Plasma-Theme.tar.gz" -C "${ROOT_DIR}/desktoptheme" Lucent

# 2. Package KDE Store: Global Theme / Look-and-Feel
echo "-> Packaging KDE Store: Global Look-and-Feel (Lucent-Global-Theme.tar.gz)..."
tar -czf "${KDE_STORE_DIR}/Lucent-Global-Theme.tar.gz" -C "${ROOT_DIR}/look-and-feel" Lucent

# 3. Copy KDE Store: Color Scheme
echo "-> Copying KDE Store: Color Scheme (Lucent.colors)..."
cp -f "${ROOT_DIR}/color-schemes/Lucent.colors" "${KDE_STORE_DIR}/Lucent.colors"

# 4. Package Complete Suite for GitHub Releases
echo "-> Packaging Complete Suite Archive for GitHub Releases (Lucent-Suite-v${VERSION}.tar.gz)..."
tar --exclude='.git' \
    --exclude='dist' \
    --exclude='.gemini' \
    --exclude='*.swp' \
    --exclude='*~' \
    -czf "${DIST_DIR}/Lucent-Suite-v${VERSION}.tar.gz" -C "${ROOT_DIR}" \
    install.sh \
    uninstall.sh \
    README.md \
    LICENSE \
    color-schemes \
    config \
    desktoptheme \
    look-and-feel

# 5. Generate Checksums
echo "-> Generating SHA-256 checksums..."
cd "${DIST_DIR}"
sha256sum Lucent-Suite-v${VERSION}.tar.gz kde-store/* > SHA256SUMS.txt
cd "${ROOT_DIR}"

echo ""
echo "Done! Distribution files generated in: ${DIST_DIR}"
ls -lh "${DIST_DIR}"
ls -lh "${KDE_STORE_DIR}"
