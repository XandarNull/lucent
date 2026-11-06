---
name: kde-darkly-plasma6-theme
description: >-
  Architect and build unified translucent desktop themes for KDE Plasma 6 using Darkly
  (application style and KDecoration3 window decoration), 4-channel RGBA KColorScheme files,
  Breeze-fallback Plasma desktop styles, and Look-and-Feel global themes. Use this skill when
  configuring translucent QWidget (Dolphin) and QtQuick/Kirigami apps, synchronizing Darkly
  opacities, creating blurred panel/launcher SVGs, or packaging complete Plasma 6 themes.
---

# KDE Darkly & Plasma 6 Theme Architect Skill

This skill provides complete architectural patterns and procedures for designing, configuring, and packaging high-performance, translucent dark themes for KDE Plasma 6 on Linux.

It achieves uniform background translucency (e.g. 60% opacity) across both **QWidget** applications (like Dolphin) and **QtQuick / Kirigami** applications (like System Settings and Discover), paired with native KWin background blur and 100% solid, sharp foreground controls.

---

## 1. Core Architecture & Synchronization Engine

Translucency in KDE Plasma 6 requires coordinating three distinct graphic layers:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        KDE COLOR SCHEME (.colors)                      │
│   Window, View, Header & WM: R,G,B,A  (e.g., A=153 for 60% opacity)    │
│   Button & Foreground roles: R,G,B    (solid 3-channel, alpha=255)     │
└───────────────┬────────────────────────────────────────┬───────────────┘
                │                                        │
        QWidget Pipeline                        QtQuick / Kirigami
  (Dolphin, Kate, KWrite)                   (System Settings, Discover)
                │                                        │
                ▼                                        ▼
┌────────────────────────────────┐       ┌───────────────────────────────┐
│ Darkly Style & Decoration      │       │ Kirigami Theme Engine         │
│ - Reads QPalette::Window alpha │       │ - Directly binds Window/View  │
│ - Sets WA_TranslucentBackground│       │   RGBA colors to QML Scene    │
│ - Registers window blur region │       │ - Keeps buttons/text solid    │
│ - DolphinViewOpacity punches   │       └───────────────────────────────┘
│   translucent holes in views   │
└────────────────────────────────┘
```

### The Translucency Handshake: QWidget vs QtQuick
1. **Kirigami / QtQuick Apps (`systemsettings`, `plasma-discover`):**
   - Kirigami directly queries `KColorScheme` for `Window` and `View` background colors.
   - When `BackgroundNormal=15,17,26,153` (4 components) is defined, Kirigami assigns `rgba(15, 17, 26, 0.6)` to page backgrounds.
   - Text and interactive elements use `ForegroundNormal` and `[Colors:Button]`, which remain 3 components (`255` alpha), staying 100% solid.
2. **QWidget Apps (`dolphin`, `kwrite`):**
   - Standard QWidgets are opaque by default.
   - Darkly's `Helper::shouldWindowHaveAlpha()` checks:
     `palette.color(QPalette::Window).alpha() < 255 || StyleConfigData::dolphinViewOpacity() < 100`
   - When true, Darkly activates `Qt::WA_TranslucentBackground` on the window during handle creation.
   - Darkly's `darklyblurhelper.cpp` registers the window polygon with KWin's compositor blur engine.
   - Darkly's `DolphinViewOpacity` and `DolphinSidebarOpacity` settings tell Darkly to paint the file item views (`KItemListContainer`) and side docks (`DolphinDockWidget`) at the matched alpha percentage.
3. **KWin Window Decoration (`org.kde.darkly`):**
   - When `BlurTransparentTitleBar=true` in `~/.config/darklyrc` `[Windeco]`:
     - Darkly reads `ToolBarOpacity` from `[Style]`.
     - It scales the titlebar background alpha to match: `color.setAlpha(qRound(opacity * 255.0 / 100));`.
     - It invokes `KDecoration3::setBlurRegion()` to blur the titlebar area directly under Wayland/X11.

---

## 2. Darkly Configuration (`~/.config/darklyrc`)

See detailed options in [darklyrc-schema.md](./references/darklyrc-schema.md).

### Standard Unified Translucency Template (60% Opacity)
```ini
[Common]
ButtonHeight=3
ButtonWidth=1
CornerRadius=8
FancyMargins=true
FloatingTitlebar=false
MenuItemHeight=4
OutlineCloseButton=false
ShadowColor=0,0,0
ShadowIntensity=Medium
ShadowSize=ShadowLarge
ShadowStrength=255
SunkenEffect=false
UseNewCheckBox=true

[Style]
AdjustToDarkThemes=false
AnimationsDuration=250
AnimationsEnabled=true
AnimationSteps=30
DisableDolphinUrlNavigatorBackground=true
DockWidgetDrawFrame=false
DocumentModeTabs=false
DolphinSidebarOpacity=60
DolphinViewOpacity=60
FullOutline=false
KTextEditDrawFrame=false
LineEditFocusAnimation=LFA_FADE
MenuBarOpacity=60
MenuItemDrawStrongFocus=true
MenuOpacity=60
MnemonicsMode=MN_AUTO
NewDolphinSelectionStyle=false
NoOutline=false
OldTabbar=false
OpaqueApps=
OpaqueInactiveWindows=false
ProgressBarAnimated=true
ProgressBarBusyStepDuration=800
RoundedRubberBandFrame=true
ScrollBarAddLineButtons=0
ScrollBarSubLineButtons=0
ScrollableMenu=true
SidePanelDrawFrame=false
SplitterProxyEnabled=true
SplitterProxyWidth=12
StackedWidgetTransitionsEnabled=false
TabBarAltStyle=false
TabBarDrawCenteredTabs=false
TabBarOpacity=60
TabBarTabExpandFullWidth=true
TabDrawHighlight=false
TabUseBrighterCloseIcon=false
TabUseHighlightColor=false
TabsHeight=0
TitleWidgetDrawFrame=false
ToolBarDrawItemSeparator=false
ToolBarDrawSeparator=false
ToolBarOpacity=60
TransparentDolphinView=true
UnifiedTabBarKonsole=false
UseWMMoveResize=true
ViewDrawFocusIndicator=true
ViewDrawTreeBranchLines=true
ViewInvertSortIndicator=false
WidgetDrawShadow=true
WidgetExplorerEnabled=false
WidgetToolBarShadow=false
renderThinSeperatorBetweenTheScrollBar=false

[Windeco]
AnimationsDuration=150
AnimationsEnabled=true
BlurTransparentTitleBar=true
BorderSize=BorderNormal
ButtonSize=ButtonDefault
DrawBackgroundGradient=false
DrawBorderOnMaximizedWindows=false
DrawHighlight=true
DrawTitleBarSeparator=false
Enabled=true
HideTitleBar=false
Mask=0
MatchInactiveTitleBar=false
OtherCornerRadius=-1
OutlineEnabled=false
RoundedCorners=true
TitleAlignment=AlignLeft
```

> [!TIP]
> **Switching between 60% and 70% Opacity:**
> - In `darklyrc`: change `60` to `70` for `DolphinSidebarOpacity`, `DolphinViewOpacity`, `MenuBarOpacity`, `MenuOpacity`, `TabBarOpacity`, and `ToolBarOpacity`.
> - In `.colors`: change `,153` to `,179` (where `round(0.70 * 255) = 179`).
> - In Desktop Theme SVGs: change `opacity:0.6` to `opacity:0.7`.

---

## 3. 4-Channel Color Scheme (`~/.local/share/color-schemes/<Theme>.colors`)

### Rules for Flawless Translucency:
1. **Background Roles (4 Channels):** Append `,153` (60%) or `,179` (70%) to:
   - `[Colors:Window] BackgroundNormal` & `BackgroundAlternate`
   - `[Colors:View] BackgroundNormal` & `BackgroundAlternate`
   - `[Colors:Header] BackgroundNormal` & `BackgroundAlternate`
   - `[Colors:Header:Inactive] BackgroundNormal` & `BackgroundAlternate`
   - `[Colors:Complementary] BackgroundNormal` & `BackgroundAlternate`
   - `[WM] activeBackground`, `activeBlend`, `inactiveBackground`, `inactiveBlend`
2. **Foreground Roles (3 Channels):**
   - Keep `ForegroundNormal`, `ForegroundActive`, `ForegroundInactive`, `ForegroundLink`, etc., as standard 3-channel RGB (`R,G,B`). This guarantees 100% opacity (`alpha: 255`).
3. **Button Roles (3 Channels):**
   - `[Colors:Button] BackgroundNormal` & `BackgroundAlternate` MUST remain 3-channel RGB. If buttons are made translucent, interactive controls look washed out or invisible over busy wallpapers.

---

## 4. Breeze-Fallback Plasma Style (`desktoptheme`)

Instead of maintaining hundreds of individual widget SVGs, Plasma 6 allows a lightweight theme that inherits from `breeze-dark` while overriding only specific surfaces.

### Directory Layout
```text
~/.local/share/plasma/desktoptheme/<ThemeName>/
├── metadata.json              # Theme metadata
├── plasmarc                   # Fallback declaration
├── colors                     # Desktop color definitions
├── widgets/
│   └── panel-background.svgz  # Translucent panel background
└── dialogs/
    └── background.svg         # Translucent launcher / popup background
```

### `plasmarc` Inheritance
```ini
[Settings]
FallbackTheme=breeze-dark

[AdaptiveTransparency]
enabled=true
```

### SVG Translucency Structure
In `widgets/panel-background.svgz` and `dialogs/background.svg`:
- Locate the main background elements (usually `rect` or `path` elements with ids like `center`, `base`, `background`).
- Set their fill to match the window color (e.g. `#0f111a`).
- Set `opacity:0.6;fill-opacity:1` for 60% opacity.
- Plasma automatically reads the blur hints from the SVG margins and instructs KWin to blur the panel and kickoff launcher.

---

## 5. Global Look-and-Feel Package

To bundle the entire suite into a one-click apply package:

### Directory Layout
```text
~/.local/share/plasma/look-and-feel/<ThemeName>/
├── metadata.json
└── contents/
    └── defaults
```

### `metadata.json` (Plasma 6 API Version 2)
```json
{
    "KPackageStructure": "Plasma/LookAndFeel",
    "KPlugin": {
        "Authors": [
            { "Name": "Xandar Null" }
        ],
        "Category": "Plasma Look And Feel",
        "Description": "Unified Translucent Theme Suite",
        "Id": "<ThemeName>",
        "License": "GPLv3",
        "Name": "<ThemeName>",
        "ServiceTypes": [ "Plasma/LookAndFeel" ],
        "Version": "1.0"
    },
    "X-Plasma-APIVersion": "2"
}
```

### `contents/defaults`
```ini
[kdeglobals][KDE]
widgetStyle=Darkly

[kdeglobals][General]
ColorScheme=<ThemeName>

[kdeglobals][Icons]
Theme=breeze-dark

[kcminputrc][Mouse]
cursorTheme=breeze_cursors

[plasmarc][Theme]
name=<ThemeName>

[kwinrc][org.kde.kdecoration2]
library=org.kde.darkly
theme=Darkly
```

---

## 6. Activation & Reload Procedure

Run the following commands to apply and refresh without rebooting:

```bash
# 1. Update sycoca cache
kbuildsycoca6

# 2. Apply color scheme, desktop style, and look-and-feel
plasma-apply-colorscheme <ThemeName>
plasma-apply-desktoptheme <ThemeName>
plasma-apply-lookandfeel -a <ThemeName>

# 3. Reload KWin window decoration & blur effects
qdbus6 org.kde.KWin /KWin reconfigure

# 4. Refresh Plasma shell surfaces
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.refreshCurrentShell 2>/dev/null || true
```
