#!/usr/bin/env bash
# ==============================================================================
# Lucent Theme Suite Installer
# Author: Xandar Null
# License: GPL-3.0-or-later
# Compatibility: KDE Plasma 6 (Linux)
# ==============================================================================

set -e

# ANSI color codes
BOLD='\033[1m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPLY_NOW=false
BUILD_ONLY=false

print_banner() {
    echo -e "${PURPLE}${BOLD}"
    echo "  _                          _     _____ _                         "
    echo " | |   _   _  ___ ___ _ __  | |_  |_   _| |__   ___ _ __ ___   ___ "
    echo " | |  | | | |/ __/ _ \ '_ \ | __|   | | | '_ \ / _ \ '_ \` _ \ / _ \\"
    echo " | |__| |_| | (_|  __/ | | || |_    | | | | | |  __/ | | | | |  __/"
    echo " |_____\__,_|\___\___|_| |_| \__|   |_| |_| |_|\___|_| |_| |_|\___|"
    echo -e "${NC}"
    echo -e "${CYAN}Lucent Theme Suite Installer — Standalone Translucent KDE Plasma 6 Suite${NC}"
    echo -e "${CYAN}Authored by: Xandar Null${NC}"
    echo "------------------------------------------------------------------"
}

show_help() {
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -a, --apply            Apply the theme immediately to the current Plasma session"
    echo "  -b, --build-only       Compile native plugins without installing"
    echo "  -h, --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./install.sh                  # Builds and installs theme & plugins"
    echo "  ./install.sh --apply          # Builds, installs and immediately activates Lucent"
}

# Parse commandline arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -a|--apply)
            APPLY_NOW=true
            shift
            ;;
        -b|--build-only)
            BUILD_ONLY=true
            shift
            ;;
        -h|--help)
            print_banner
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

print_banner

# Step 1: Check dependencies
echo -e "${BOLD}[1/6] Checking build dependencies...${NC}"
MISSING_DEPS=()
for cmd in cmake extra-cmake-modules kdecoration; do
    if ! pacman -Q "$cmd" >/dev/null 2>&1 && ! command -v "$cmd" >/dev/null 2>&1; then
        MISSING_DEPS+=("$cmd")
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo -e "  ${YELLOW}!${NC} Missing build dependencies: ${MISSING_DEPS[*]}"
    echo -e "    Install with: ${CYAN}sudo pacman -S --needed cmake extra-cmake-modules kdecoration${NC}"
fi

# Step 2: Compile native C++ plugins
echo -e "${BOLD}[2/6] Building native C++ Lucent plugins (lucent6 & org.kde.lucent)...${NC}"
cmake -B "${ROOT_DIR}/build" -S "${ROOT_DIR}" -DCMAKE_BUILD_TYPE=Release
cmake --build "${ROOT_DIR}/build" -j"$(nproc)"
echo -e "  ${GREEN}✓${NC} C++ plugins compiled successfully."

if [ "${BUILD_ONLY}" = true ]; then
    echo -e "${GREEN}${BOLD}Build complete! (Build-only requested)${NC}"
    exit 0
fi

# Step 3: Install C++ plugins
echo -e "${BOLD}[3/6] Installing C++ plugins...${NC}"
if [ "$EUID" -eq 0 ]; then
    cmake --install "${ROOT_DIR}/build"
    echo -e "  ${GREEN}✓${NC} Installed native plugins to system."
else
    if sudo -n true 2>/dev/null; then
        echo -e "  ${CYAN}Installing plugins system-wide via sudo...${NC}"
        sudo cmake --install "${ROOT_DIR}/build"
        echo -e "  ${GREEN}✓${NC} Installed native plugins to system."
    else
        echo -e "  ${CYAN}Installing plugins to user environment (~/.local)...${NC}"
        mkdir -p "${HOME}/.local/lib/qt6/plugins/styles"
        mkdir -p "${HOME}/.local/lib/qt6/plugins/org.kde.kdecoration3"
        mkdir -p "${HOME}/.local/share/kstyle/themes"
        mkdir -p "${HOME}/.config/plasma-workspace/env"

        cp -f "${ROOT_DIR}/build/bin/lucent6.so" "${HOME}/.local/lib/qt6/plugins/styles/"
        cp -f "${ROOT_DIR}/build/bin/org.kde.lucent.so" "${HOME}/.local/lib/qt6/plugins/org.kde.kdecoration3/"
        cp -f "${ROOT_DIR}/src/kstyle/lucent.themerc" "${HOME}/.local/share/kstyle/themes/"
        echo 'export QT_PLUGIN_PATH="$HOME/.local/lib/qt6/plugins${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"' > "${HOME}/.config/plasma-workspace/env/lucent-env.sh"
        chmod +x "${HOME}/.config/plasma-workspace/env/lucent-env.sh"
        echo -e "  ${GREEN}✓${NC} Installed plugins to ~/.local/lib/qt6/plugins and configured environment hook."
    fi
fi

# Step 4: Install User Themes & Packages
echo -e "${BOLD}[4/6] Installing user themes (Color Scheme, Plasma Style, Look-and-Feel)...${NC}"
COLOR_SCHEMES_DIR="${HOME}/.local/share/color-schemes"
DESKTOPTHEME_DIR="${HOME}/.local/share/plasma/desktoptheme/Lucent"
LOOKANDFEEL_DIR="${HOME}/.local/share/plasma/look-and-feel/Lucent"
CONFIG_DIR="${HOME}/.config"

mkdir -p "${COLOR_SCHEMES_DIR}"
mkdir -p "${DESKTOPTHEME_DIR}/widgets" "${DESKTOPTHEME_DIR}/dialogs"
mkdir -p "${LOOKANDFEEL_DIR}/contents"
mkdir -p "${CONFIG_DIR}"

cp -f "${ROOT_DIR}/color-schemes/Lucent.colors" "${COLOR_SCHEMES_DIR}/Lucent.colors"
echo -e "  ${GREEN}✓${NC} Installed Color Scheme to ${COLOR_SCHEMES_DIR}/Lucent.colors"

cp -f "${ROOT_DIR}/desktoptheme/Lucent/metadata.json" "${DESKTOPTHEME_DIR}/"
cp -f "${ROOT_DIR}/desktoptheme/Lucent/plasmarc" "${DESKTOPTHEME_DIR}/"
cp -f "${ROOT_DIR}/desktoptheme/Lucent/colors" "${DESKTOPTHEME_DIR}/"
cp -f "${ROOT_DIR}/desktoptheme/Lucent/widgets/"* "${DESKTOPTHEME_DIR}/widgets/"
cp -f "${ROOT_DIR}/desktoptheme/Lucent/dialogs/"* "${DESKTOPTHEME_DIR}/dialogs/"
echo -e "  ${GREEN}✓${NC} Installed Plasma Style to ${DESKTOPTHEME_DIR}"

cp -f "${ROOT_DIR}/look-and-feel/Lucent/metadata.json" "${LOOKANDFEEL_DIR}/"
cp -f "${ROOT_DIR}/look-and-feel/Lucent/contents/defaults" "${LOOKANDFEEL_DIR}/contents/"
echo -e "  ${GREEN}✓${NC} Installed Global Look-and-Feel to ${LOOKANDFEEL_DIR}"

# Step 5: Install Lucent Configuration
echo -e "${BOLD}[5/6] Installing Lucent configuration...${NC}"
if [ -f "${CONFIG_DIR}/lucentrc" ]; then
    cp -f "${CONFIG_DIR}/lucentrc" "${CONFIG_DIR}/lucentrc.bak"
    echo -e "  Backed up existing lucentrc to ${CONFIG_DIR}/lucentrc.bak"
fi

cp -f "${ROOT_DIR}/config/lucentrc" "${CONFIG_DIR}/lucentrc"
echo -e "  ${GREEN}✓${NC} Installed to ${CONFIG_DIR}/lucentrc"

# Step 6: Refresh caches
echo -e "${BOLD}[6/6] Refreshing system caches...${NC}"
if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 >/dev/null 2>&1 || true
fi

echo ""
echo -e "${GREEN}${BOLD}Installation Complete!${NC}"
echo "------------------------------------------------------------------"

if [ "${APPLY_NOW}" = true ]; then
    echo -e "${CYAN}Applying Lucent theme suite now...${NC}"
    if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
        plasma-apply-colorscheme Lucent >/dev/null 2>&1 || true
    fi
    if command -v plasma-apply-desktoptheme >/dev/null 2>&1; then
        plasma-apply-desktoptheme Lucent >/dev/null 2>&1 || true
    fi
    if command -v kwriteconfig6 >/dev/null 2>&1; then
        kwriteconfig6 --file kdeglobals --group KDE --key widgetStyle Lucent
        kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library org.kde.lucent
        kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme Lucent
    fi
    if command -v plasma-apply-lookandfeel >/dev/null 2>&1; then
        plasma-apply-lookandfeel -a Lucent >/dev/null 2>&1 || true
    fi
    if command -v qdbus6 >/dev/null 2>&1; then
        qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
    fi
    echo -e "${GREEN}${BOLD}Lucent Theme Suite successfully applied!${NC}"
else
    echo -e "To apply the theme, run:"
    echo -e "  ${BOLD}./install.sh --apply${NC}"
    echo -e "Or apply it from ${BOLD}System Settings -> Colors / Application Style / Window Decorations / Global Theme${NC}."
fi
