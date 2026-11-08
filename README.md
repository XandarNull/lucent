# Lucent — Standalone Translucent KDE Plasma 6 Desktop Suite

**Author:** Xandar Null  
**License:** GPL-3.0-or-later  
**Compatibility:** KDE Plasma 6 (Arch Linux, Fedora, openSUSE, Debian/Ubuntu KDE, Wayland & X11)

---

## Overview

**Lucent** is a high-performance, standalone translucent dark desktop suite engineered specifically for KDE Plasma 6. It includes native, lightweight C++ plugins for both the application style and window decorations, delivering seamless 60% background translucency and compositor blur with zero configuration bloat or third-party package dependencies.

### What is Included:
- **Application Style:** `Lucent` (`lucent6.so` Qt6 plugin)
- **Window Decorations:** `Lucent` (`org.kde.lucent.so` KDecoration3 plugin)
- **Color Scheme:** `Lucent` (`Lucent.colors` with 4-channel `R,G,B,A` roles)
- **Plasma Desktop Style:** `Lucent` (Breeze-fallback with translucent panel and launcher)
- **Global Theme:** `Lucent` (One-click Look-and-Feel package)

All backgrounds (window surfaces, Dolphin file views and sidebars, Kirigami pages, menus, toolbars, and titlebars) share **60% opacity** (`alpha: 153` / `0.60`) over background blur. All foreground elements (text, folder icons, buttons, selection markers) remain **100% solid and crisp**.

---

## Baked-In Styling Metrics

- **Corner Radius:** 7 px on buttons, input fields, and widgets.
- **Button Height:** 7 px padding height.
- **Window Corners:** 3 px rounded top/bottom window decoration corners.
- **Titlebar Buttons:** Large titlebar buttons for easy clicking and high contrast.
- **Title Alignment:** Centered window title across the full titlebar width.
- **Tabs:** Flat alternative tabs with purple accent underline on active tabs and clean spacing (no bottom lines on inactive tabs).
- **Checkboxes:** Modern flat checkbox styling.
- **Sidebar Separator:** Native Qt resize handle preserved with full drag functionality.

---

## Quick Installation

### Automated Installer (Builds and installs everything):
```bash
./install.sh --apply
```

If you have root access and want the C++ plugins installed system-wide to `/usr/lib/qt6/plugins`, run:
```bash
sudo cmake --install build
```

### Installation Options

| Flag | Description | Example |
| :--- | :--- | :--- |
| `-a, --apply` | Automatically applies the theme and reloads KWin & Plasma | `./install.sh --apply` |
| `-o, --opacity <60\|70>` | Sets base opacity to 60% (default) or 70% | `./install.sh -a -o 70` |
| `-b, --build-only` | Compiles the C++ plugins without installing | `./install.sh -b` |
| `-h, --help` | Displays help message and command syntax | `./install.sh --help` |

---

## Arch Linux / AUR (PKGBUILD)

To build and install cleanly using pacman:
```bash
cd packaging/aur
makepkg -si
```

---

## Uninstallation

To remove all installed theme files and plugins:

```bash
./uninstall.sh
```

To remove all files and revert your session back to stock Breeze Dark:
```bash
./uninstall.sh --revert
```
