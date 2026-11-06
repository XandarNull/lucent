# Lucent — Unified Translucent KDE Plasma 6 & Darkly Theme Suite

**Author:** Xandar Null  
**License:** GPLv3  
**Compatibility:** KDE Plasma 6 (Arch Linux, Fedora, openSUSE, Debian/Ubuntu KDE, Wayland & X11)

---

## Overview

**Lucent** is a high-performance, unified translucent dark desktop suite engineered specifically for KDE Plasma 6. It eliminates mismatched window opacities by synchronizing:
- **Darkly Application Style** (`darkly6.so`)
- **Darkly Window Decoration** (`org.kde.darkly.so`)
- **Lucent Color Scheme** (`Lucent.colors` with 4-channel `R,G,B,A` roles)
- **Lucent Plasma Desktop Style** (Breeze-fallback with translucent panel and launcher)
- **Lucent Global Theme** (One-click Look-and-Feel package)

All backgrounds (window surfaces, Dolphin file views and sidebars, Kirigami pages, menus, toolbars, and titlebars) share **60% opacity** (`alpha: 153` / `0.60`) over `kwin-effects-better-blur-dx`. All foreground elements (text, folder icons, buttons, selection markers) remain **100% solid and crisp**.

---

## Prerequisites

1. **Darkly Application Style & Window Decoration (Qt6):**
   - **Arch Linux / Manjaro / EndeavourOS:**
     ```bash
     yay -S darkly-bin
     # or
     paru -S darkly-bin
     ```
   - **From Source:** [https://github.com/Bali10050/Darkly](https://github.com/Bali10050/Darkly)
2. **KWin Background Blur (Recommended):**
   - Install `kwin-effects-better-blur-dx` (AUR) or ensure KDE's native Blur effect is enabled in **System Settings -> Desktop Effects -> Blur**.

---

## Quick Installation

Clone this repository and run the automated installer:

```bash
git clone https://github.com/your-username/lucent-darkly.git
cd lucent-darkly
chmod +x install.sh
./install.sh --apply
```

### Installation Options

| Flag | Description | Example |
| :--- | :--- | :--- |
| `-a, --apply` | Automatically applies the theme and reloads KWin & Plasma | `./install.sh --apply` |
| `-o, --opacity <60\|70>` | Sets base opacity to 60% (default) or 70% | `./install.sh -a -o 70` |
| `-h, --help` | Displays help message and command syntax | `./install.sh --help` |

---

## Uninstallation

To remove all installed theme files and restore previous configurations:

```bash
chmod +x uninstall.sh
./uninstall.sh --revert
```
The `--revert` flag restores your active session back to default **Breeze Dark**.

---

## Packaging & Distribution

If you want to distribute Lucent to other users or upload it to KDE Store:

Run the included packager:
```bash
chmod +x package.sh
./package.sh
```

This creates the `dist/` directory containing:

1. **`dist/Lucent-Suite-v1.0.tar.gz`**:
   The full standalone release archive. Attach this to your **GitHub Releases** page.
2. **`dist/kde-store/`**:
   Pre-packaged archives ready to upload to [store.kde.org](https://store.kde.org) (Pling / OpenDesktop):
   - `Lucent-Global-Theme.tar.gz` &rarr; Upload to **Plasma 6 Global Themes**
   - `Lucent-Plasma-Theme.tar.gz` &rarr; Upload to **Plasma 6 Desktop Themes**
   - `Lucent.colors` &rarr; Upload to **Plasma 6 Color Schemes**
3. **`packaging/aur/PKGBUILD`**:
   Ready to submit to the Arch User Repository (AUR) under `lucent-theme-git`.

---

## Directory Layout

```text
lucent_darkly/
├── color-schemes/
│   └── Lucent.colors                        # 4-channel RGBA color scheme
├── config/
│   └── darklyrc                             # Darkly style & windeco configuration
├── desktoptheme/Lucent/                     # Standalone Plasma Desktop Style
│   ├── metadata.json
│   ├── plasmarc                             # Declares FallbackTheme=breeze-dark
│   ├── colors                               # Plasma color definitions
│   ├── widgets/
│   │   ├── panel-background.svgz            # 60% translucent blurred bottom panel
│   │   ├── line.svgz                        # Zero-opacity line separators for Kickoff/dialogs
│   │   └── scrollbar.svgz                   # Zero-opacity scrollbar for Kickoff
│   └── dialogs/background.svg               # 60% translucent blurred application launcher
├── look-and-feel/Lucent/                    # One-Click Global Theme Package
│   ├── metadata.json
│   └── contents/defaults
├── packaging/aur/
│   └── PKGBUILD                             # Arch Linux AUR package definition
├── install.sh                               # Automated installer with --apply and --opacity
├── uninstall.sh                             # Automated uninstaller with --revert
├── package.sh                               # Release packager for GitHub & KDE Store
├── README.md                                # Documentation
└── LICENSE                                  # GPLv3 License
```

---

## How to Adjust Translucency Between 60% and 70%

If you wish to switch from 60% to 70% opacity manually without re-running the installer:

### 1. Darkly Configuration (`~/.config/darklyrc`)
Change the values under `[Style]` from `60` to `70`:
```ini
[Style]
DolphinSidebarOpacity=70
DolphinViewOpacity=70
MenuBarOpacity=70
MenuOpacity=70
TabBarOpacity=70
ToolBarOpacity=70
```

### 2. Color Scheme (`~/.local/share/color-schemes/Lucent.colors`)
Change `,153` (60%) to `,179` (70%) on the following lines:
- `[Colors:Window]` &rarr; `BackgroundNormal=15,17,26,179` and `BackgroundAlternate=47,52,63,179`
- `[Colors:View]` &rarr; `BackgroundNormal=19,21,32,179` and `BackgroundAlternate=20,26,33,179`
- `[Colors:Header]` &rarr; `BackgroundNormal=15,17,26,179` and `BackgroundAlternate=47,52,63,179`
- `[Colors:Header:Inactive]` &rarr; `BackgroundNormal=15,17,26,179` and `BackgroundAlternate=47,52,63,179`
- `[Colors:Complementary]` &rarr; `BackgroundNormal=15,17,26,179` and `BackgroundAlternate=47,52,63,179`
- `[WM]` &rarr; `activeBackground=47,52,63,179`, `activeBlend=47,52,63,179`, `inactiveBackground=47,52,63,179`, `inactiveBlend=47,52,63,179`

### 3. Desktop Theme SVGs (`~/.local/share/plasma/desktoptheme/Lucent/`)
In `widgets/panel-background.svgz` and `dialogs/background.svg`:
- Change `opacity:0.6` to `opacity:0.7`.

### 4. Reload Desktop
```bash
plasma-apply-colorscheme Lucent
plasma-apply-desktoptheme Lucent
qdbus6 org.kde.KWin /KWin reconfigure
```
