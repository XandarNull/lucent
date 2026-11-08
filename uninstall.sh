#!/usr/bin/env bash
# ==============================================================================
# Lucent Theme Suite Uninstaller
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

REVERT_DEFAULT=false

print_banner() {
    echo -e "${PURPLE}${BOLD}"
    echo "  _                          _     _   _       _           _        _ _ "
    echo " | |   _   _  ___ ___ _ __  | |_  | | | |_ __ (_)_ __  ___| |_ __ _| | |"
    echo " | |  | | | |/ __/ _ \ '_ \ | __| | | | | '_ \| | '_ \/ __| __/ _\` | | |"
    echo " | |__| |_| | (_|  __/ | | || |_  | |_| | | | | | | | \__ \ || (_| | | |"
    echo " |_____\__,_|\___\___|_| |_| \__|  \___/|_| |_|_|_| |_|___/\__\__,_|_|_|"
    echo -e "${NC}"
    echo -e "${CYAN}Lucent Theme Suite Uninstaller${NC}"
    echo -e "${CYAN}Authored by: Xandar Null${NC}"
    echo "------------------------------------------------------------------"
}

show_help() {
    echo "Usage: ./uninstall.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -r, --revert           Revert active session to default Breeze Dark theme"
    echo "  -h, --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./uninstall.sh         # Removes Lucent files without resetting current session"
    echo "  ./uninstall.sh --revert# Removes Lucent and activates default Breeze Dark"
}

# Parse commandline arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -r|--revert)
            REVERT_DEFAULT=true
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

COLOR_SCHEMES_DIR="${HOME}/.local/share/color-schemes"
DESKTOPTHEME_DIR="${HOME}/.local/share/plasma/desktoptheme/Lucent"
LOOKANDFEEL_DIR="${HOME}/.local/share/plasma/look-and-feel/Lucent"
CONFIG_DIR="${HOME}/.config"

echo -e "${BOLD}[1/5] Removing system C++ plugins...${NC}"
SYSTEM_PLUGINS=(
    "/usr/lib/qt6/plugins/styles/lucent6.so"
    "/usr/lib/qt6/plugins/org.kde.kdecoration3/org.kde.lucent.so"
    "/usr/share/kstyle/themes/lucent.themerc"
)

SUDO_CMD=""
if [ "$EUID" -ne 0 ]; then
    SUDO_CMD="sudo"
fi

for plugin in "${SYSTEM_PLUGINS[@]}"; do
    if [ -f "$plugin" ]; then
        echo -e "  Removing $plugin..."
        $SUDO_CMD rm -f "$plugin"
    fi
done
echo -e "  ${GREEN}✓${NC} Cleaned system plugins"

echo -e "${BOLD}[2/5] Removing Lucent color scheme...${NC}"
if [ -f "${COLOR_SCHEMES_DIR}/Lucent.colors" ]; then
    rm -f "${COLOR_SCHEMES_DIR}/Lucent.colors"
    echo -e "  ${GREEN}✓${NC} Removed ${COLOR_SCHEMES_DIR}/Lucent.colors"
else
    echo -e "  ${YELLOW}!${NC} Lucent.colors not found."
fi

echo -e "${BOLD}[3/5] Removing Plasma Desktop Theme & Look-and-Feel packages...${NC}"
if [ -d "${DESKTOPTHEME_DIR}" ]; then
    rm -rf "${DESKTOPTHEME_DIR}"
    echo -e "  ${GREEN}✓${NC} Removed ${DESKTOPTHEME_DIR}"
else
    echo -e "  ${YELLOW}!${NC} Desktop theme directory not found."
fi

if [ -d "${LOOKANDFEEL_DIR}" ]; then
    rm -rf "${LOOKANDFEEL_DIR}"
    echo -e "  ${GREEN}✓${NC} Removed ${LOOKANDFEEL_DIR}"
else
    echo -e "  ${YELLOW}!${NC} Look-and-feel directory not found."
fi

echo -e "${BOLD}[4/5] Checking lucentrc backups...${NC}"
if [ -f "${CONFIG_DIR}/lucentrc.bak" ]; then
    echo -e "  Found ${CONFIG_DIR}/lucentrc.bak. Restoring original configuration..."
    mv -f "${CONFIG_DIR}/lucentrc.bak" "${CONFIG_DIR}/lucentrc"
    echo -e "  ${GREEN}✓${NC} Restored original lucentrc"
elif [ -f "${CONFIG_DIR}/lucentrc" ]; then
    rm -f "${CONFIG_DIR}/lucentrc"
    echo -e "  ${GREEN}✓${NC} Removed ${CONFIG_DIR}/lucentrc"
fi

echo -e "${BOLD}[5/5] Updating Sycoca cache...${NC}"
if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 >/dev/null 2>&1 || true
    echo -e "  ${GREEN}✓${NC} Cache refreshed"
fi

if [ "${REVERT_DEFAULT}" = true ]; then
    echo ""
    echo -e "${CYAN}Reverting to standard Breeze Dark theme...${NC}"
    if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
        plasma-apply-colorscheme BreezeDark >/dev/null 2>&1 || true
    fi
    if command -v plasma-apply-desktoptheme >/dev/null 2>&1; then
        plasma-apply-desktoptheme breeze-dark >/dev/null 2>&1 || true
    fi
    if command -v kwriteconfig6 >/dev/null 2>&1; then
        kwriteconfig6 --file kdeglobals --group KDE --key widgetStyle Breeze
        kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library org.kde.breeze
        kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme Breeze
    fi
    if command -v plasma-apply-lookandfeel >/dev/null 2>&1; then
        plasma-apply-lookandfeel -a org.kde.breezedark.desktop >/dev/null 2>&1 || true
    fi
    if command -v qdbus6 >/dev/null 2>&1; then
        qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
    fi
    echo -e "  ${GREEN}✓${NC} Session reset to Breeze Dark"
fi

echo ""
echo -e "${GREEN}${BOLD}Uninstallation Complete!${NC}"
echo "------------------------------------------------------------------"
