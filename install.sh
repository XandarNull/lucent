#!/usr/bin/env bash
# ==============================================================================
# Lucent Theme Suite Installer
# Author: Xandar Null
# License: GPLv3
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
OPACITY=60
APPLY_NOW=false

print_banner() {
    echo -e "${PURPLE}${BOLD}"
    echo "  _                          _     _____ _                         "
    echo " | |   _   _  ___ ___ _ __  | |_  |_   _| |__   ___ _ __ ___   ___ "
    echo " | |  | | | |/ __/ _ \ '_ \ | __|   | | | '_ \ / _ \ '_ \` _ \ / _ \\"
    echo " | |__| |_| | (_|  __/ | | || |_    | | | | | |  __/ | | | | |  __/"
    echo " |_____\__,_|\___\___|_| |_| \__|   |_| |_| |_|\___|_| |_| |_|\___|"
    echo -e "${NC}"
    echo -e "${CYAN}Lucent Theme Suite Installer — Unified Translucent KDE Plasma 6 Theme${NC}"
    echo -e "${CYAN}Authored by: Xandar Null${NC}"
    echo "------------------------------------------------------------------"
}

show_help() {
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -a, --apply            Apply the theme immediately to the current Plasma session"
    echo "  -o, --opacity <60|70>  Set target opacity (default: 60)"
    echo "  -h, --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./install.sh                  # Installs theme files without changing active theme"
    echo "  ./install.sh --apply          # Installs and immediately activates Lucent"
    echo "  ./install.sh -a -o 70         # Installs and activates with 70% opacity"
}

# Parse commandline arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -a|--apply)
            APPLY_NOW=true
            shift
            ;;
        -o|--opacity)
            if [[ "$2" == "60" || "$2" == "70" ]]; then
                OPACITY="$2"
                shift 2
            else
                echo -e "${RED}Error: Opacity must be either 60 or 70.${NC}"
                exit 1
            fi
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

# Step 1: Check prerequisites
echo -e "${BOLD}[1/5] Checking dependencies...${NC}"
HAS_DARKLY=false
if pacman -Qs darkly >/dev/null 2>&1 || [ -f /usr/lib/qt6/plugins/styles/darkly6.so ] || [ -f /usr/lib64/qt6/plugins/styles/darkly6.so ]; then
    HAS_DARKLY=true
    echo -e "  ${GREEN}✓${NC} Darkly style found."
else
    echo -e "  ${YELLOW}!${NC} Darkly is not installed. Lucent requires Darkly for window/view translucency."
    echo -e "    On Arch Linux, install it via: ${CYAN}yay -S darkly-bin${NC} or ${CYAN}paru -S darkly-bin${NC}"
fi

# Step 2: Prepare target directories
echo -e "${BOLD}[2/5] Preparing installation directories...${NC}"
COLOR_SCHEMES_DIR="${HOME}/.local/share/color-schemes"
DESKTOPTHEME_DIR="${HOME}/.local/share/plasma/desktoptheme/Lucent"
LOOKANDFEEL_DIR="${HOME}/.local/share/plasma/look-and-feel/Lucent"
CONFIG_DIR="${HOME}/.config"

mkdir -p "${COLOR_SCHEMES_DIR}"
mkdir -p "${DESKTOPTHEME_DIR}/widgets" "${DESKTOPTHEME_DIR}/dialogs"
mkdir -p "${LOOKANDFEEL_DIR}/contents"
mkdir -p "${CONFIG_DIR}"

# Step 3: Install Color Scheme
echo -e "${BOLD}[3/5] Installing Color Scheme...${NC}"
if [ "${OPACITY}" -eq 70 ]; then
    echo -e "  Configuring for 70% opacity (alpha 179)..."
    sed 's/,153/,179/g' "${ROOT_DIR}/color-schemes/Lucent.colors" > "${COLOR_SCHEMES_DIR}/Lucent.colors"
else
    cp -f "${ROOT_DIR}/color-schemes/Lucent.colors" "${COLOR_SCHEMES_DIR}/Lucent.colors"
fi
echo -e "  ${GREEN}✓${NC} Installed to ${COLOR_SCHEMES_DIR}/Lucent.colors"

# Step 4: Install Plasma Desktop Theme & Look-and-Feel
echo -e "${BOLD}[4/5] Installing Desktop Theme & Look-and-Feel packages...${NC}"
cp -f "${ROOT_DIR}/desktoptheme/Lucent/metadata.json" "${DESKTOPTHEME_DIR}/"
cp -f "${ROOT_DIR}/desktoptheme/Lucent/plasmarc" "${DESKTOPTHEME_DIR}/"
cp -f "${ROOT_DIR}/desktoptheme/Lucent/colors" "${DESKTOPTHEME_DIR}/"
cp -f "${ROOT_DIR}/desktoptheme/Lucent/widgets/"* "${DESKTOPTHEME_DIR}/widgets/"
cp -f "${ROOT_DIR}/desktoptheme/Lucent/dialogs/"* "${DESKTOPTHEME_DIR}/dialogs/"

# Adjust SVG opacity if 70% was chosen
if [ "${OPACITY}" -eq 70 ]; then
    gzip -dc "${DESKTOPTHEME_DIR}/widgets/panel-background.svgz" | sed 's/opacity:0.6/opacity:0.7/g' | gzip -cn9 > "${DESKTOPTHEME_DIR}/widgets/panel-background.svgz"
    sed -i 's/opacity:0.6/opacity:0.7/g' "${DESKTOPTHEME_DIR}/dialogs/background.svg"
fi
echo -e "  ${GREEN}✓${NC} Installed Plasma Style to ${DESKTOPTHEME_DIR}"

cp -f "${ROOT_DIR}/look-and-feel/Lucent/metadata.json" "${LOOKANDFEEL_DIR}/"
cp -f "${ROOT_DIR}/look-and-feel/Lucent/contents/defaults" "${LOOKANDFEEL_DIR}/contents/"
echo -e "  ${GREEN}✓${NC} Installed Global Look-and-Feel to ${LOOKANDFEEL_DIR}"

# Step 5: Install Darkly Configuration
echo -e "${BOLD}[5/5] Installing Darkly Configuration...${NC}"
if [ -f "${CONFIG_DIR}/darklyrc" ]; then
    cp -f "${CONFIG_DIR}/darklyrc" "${CONFIG_DIR}/darklyrc.bak"
    echo -e "  Backed up existing darklyrc to ${CONFIG_DIR}/darklyrc.bak"
fi

if [ "${OPACITY}" -eq 70 ]; then
    sed -E 's/(DolphinSidebarOpacity|DolphinViewOpacity|MenuBarOpacity|MenuOpacity|TabBarOpacity|ToolBarOpacity)=60/\1=70/g' \
        "${ROOT_DIR}/config/darklyrc" > "${CONFIG_DIR}/darklyrc"
else
    cp -f "${ROOT_DIR}/config/darklyrc" "${CONFIG_DIR}/darklyrc"
fi
echo -e "  ${GREEN}✓${NC} Installed to ${CONFIG_DIR}/darklyrc"

# Update Sycoca
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
    echo -e "Or apply it from ${BOLD}System Settings -> Colors / Plasma Style / Global Theme${NC}."
fi
