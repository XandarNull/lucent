# Lucent — Standalone Translucent KDE Plasma 6 Desktop Suite

[![License: GPL-3.0-or-later](https://img.shields.io/badge/License-GPL--3.0--or--later-blue.svg)](LICENSE)
[![Platform: KDE Plasma 6](https://img.shields.io/badge/KDE-Plasma%206-orange.svg)](https://kde.org/plasma-desktop/)
[![Qt: 6.7+](https://img.shields.io/badge/Qt-6.7%2B-green.svg)](https://www.qt.io/)

**Lucent** is a high-performance, unified translucent dark desktop suite engineered specifically for **KDE Plasma 6**.

Unlike standard themes that leave QWidget applications (such as Dolphin or Kate) opaque or create mismatched opacities between windows, Lucent includes **native C++ plugins** that seamlessly synchronize translucency and background blur across both **QWidget** and **QtQuick / Kirigami** applications.

Everything is completely standalone: **no third-party theme packages or external configuration apps are required**.

---

## ✨ Features

- **Uniform 60% Translucency:** Window backgrounds, Dolphin file views and sidebars, menus, toolbars, and titlebars share a uniform 60% opacity (`alpha: 153` / `0.60`).
- **100% Solid Foreground:** Text, icons, buttons, badges, and active selections remain completely solid, crisp, and readable against any wallpaper.
- **Native C++ Performance:** Includes compiled `lucent6.so` (Qt6 Application Style) and `org.kde.lucent.so` (KDecoration3 Window Decoration) plugins.

---

## 🔮 Recommended: Background Blur

Lucent windows look best with background blur enabled so wallpapers and background windows soften smoothly behind them.

1. **Native KDE Blur (Works out-of-the-box on all distributions):**
   - Open **System Settings** → **Desktop Effects**.
   - Ensure **Blur** is checked and click **Apply**.

2. **Enhanced Blur (dx) (Recommended for artifact-free gradients):**
   - For an even smoother blur with optimized dual-filtering, installing **[kwin-effects-better-blur-dx](https://github.com/xarblu/kwin-effects-better-blur-dx)** is recommended.
   - **Arch Linux:**
     ```bash
     paru -S kwin-effects-better-blur-dx
     # or
     yay -S kwin-effects-better-blur-dx
     ```
   - **Ubuntu / Fedora / openSUSE (Build from source):**
     ```bash
     git clone https://github.com/xarblu/kwin-effects-better-blur-dx.git
     cd kwin-effects-better-blur-dx
     cmake -B build -S . -DCMAKE_BUILD_TYPE=Release
     cmake --build build -j$(nproc)
     sudo cmake --install build
     ```
   - In **System Settings** → **Desktop Effects**, enable **Enhanced Blur (dx)** (and disable the default "Blur" effect).

---

## 📦 What is Included in the Suite

```text
Lucent Suite
├── Application Style:       Lucent (lucent6.so)
├── Window Decorations:      Lucent (org.kde.lucent.so)
├── Color Scheme:            Lucent (4-channel RGBA .colors)
├── Plasma Desktop Style:    Lucent (translucent panels & launcher)
└── Global Theme:            Lucent (one-click Look-and-Feel package)
```

---

## 🛠️ Build & Installation

### Compatibility
> [!NOTE]
> Lucent is engineered for **KDE Plasma 6** and **Qt 6**. Compatible distributions include **Kubuntu 24.10+ / KDE Neon**, **Fedora 40+**, **openSUSE Tumbleweed**, and **Arch Linux** (or any rolling release with Plasma 6).

### 1. Install Prerequisites

Install CMake, Extra CMake Modules, and Qt6 / KDE Frameworks 6 development headers for your distribution:

#### Ubuntu / Kubuntu (24.10+) / Debian Testing / KDE Neon:
```bash
sudo apt update
sudo apt install -y build-essential cmake extra-cmake-modules \
    libkdecorations3-dev qt6-base-dev qt6-declarative-dev \
    libkf6colorscheme-dev libkf6config-dev libkf6configwidgets-dev \
    libkf6coreaddons-dev libkf6guiaddons-dev libkf6i18n-dev \
    libkf6iconthemes-dev libkf6windowsystem-dev
```

#### Fedora (40+):
```bash
sudo dnf install -y gcc-c++ cmake extra-cmake-modules \
    kdecoration-devel qt6-qtbase-devel qt6-qtdeclarative-devel \
    kf6-kcolorscheme-devel kf6-kconfig-devel kf6-kconfigwidgets-devel \
    kf6-kcoreaddons-devel kf6-kguiaddons-devel kf6-ki18n-devel \
    kf6-kiconthemes-devel kf6-kwindowsystem-devel
```

#### openSUSE (Tumbleweed):
```bash
sudo zypper install -y gcc-c++ cmake extra-cmake-modules \
    kdecoration6-devel qt6-base-devel qt6-declarative-devel \
    kf6-kcolorscheme-devel kf6-kconfig-devel kf6-kconfigwidgets-devel \
    kf6-kcoreaddons-devel kf6-kguiaddons-devel kf6-ki18n-devel \
    kf6-kiconthemes-devel kf6-kwindowsystem-devel
```

#### Arch Linux / EndeavourOS / Manjaro:
```bash
sudo pacman -S --needed base-devel cmake extra-cmake-modules \
    kdecoration qt6-base qt6-declarative \
    kcolorscheme kconfig kconfigwidgets kcoreaddons \
    kguiaddons ki18n kiconthemes kwindowsystem
```

---

### 2. Fast Install (Automated Script)

Clone the repository and run `install.sh`:

```bash
git clone https://github.com/XandarNull/lucent.git
cd lucent
chmod +x install.sh
./install.sh --apply
```

#### Optional Installer Flags:
| Flag | Description | Example |
| :--- | :--- | :--- |
| `-a, --apply` | Installs and immediately activates Lucent for your current session | `./install.sh --apply` |
| `-b, --build-only` | Compiles the C++ plugins without installing | `./install.sh -b` |
| `-h, --help` | Displays usage syntax and help | `./install.sh --help` |

---

### 3. Manual Build & System-Wide Installation

If you prefer building and installing with standard CMake tools:

```bash
# 1. Configure and compile
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)

# 2. Install plugins and themes globally (requires sudo)
sudo cmake --install build

# 3. Refresh system cache and apply
kbuildsycoca6
plasma-apply-colorscheme Lucent
plasma-apply-desktoptheme Lucent
plasma-apply-lookandfeel -a Lucent
qdbus6 org.kde.KWin /KWin reconfigure
```

---

## 🎨 How to Use / Apply Manually

If you prefer configuring themes through the KDE graphical interface:

1. **Global Theme:** Open **System Settings** → **Colors & Themes** → **Global Theme**, select **Lucent**, and click **Apply**.
2. **Application Style:** Open **System Settings** → **Colors & Themes** → **Application Style**, select **Lucent**, and click **Apply**.
3. **Window Decorations:** Open **System Settings** → **Colors & Themes** → **Window Decorations**, select **Lucent**, and click **Apply**.
4. **Plasma Style:** Open **System Settings** → **Colors & Themes** → **Plasma Style**, select **Lucent**, and click **Apply**.
5. **Color Scheme:** Open **System Settings** → **Colors & Themes** → **Colors**, select **Lucent**, and click **Apply**.

---

## 📄 License & Attribution

- **Author:** Xandar Null
- **License:** GNU General Public License v3.0 or later ([GPL-3.0-or-later](LICENSE))
- **Credits & Acknowledgements:**
  - Special thanks to **[Darkly](https://github.com/Bali10050/Darkly)** by **Bali10050** for the underlying Qt6 translucency and blur engine techniques adapted for Lucent.
  - Thanks to the upstream **Lightly** and **KDE Breeze** open-source developers whose foundational styling work powers modern Plasma aesthetics.
