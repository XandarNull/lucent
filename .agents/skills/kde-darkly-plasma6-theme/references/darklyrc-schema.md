# Darkly Configuration Schema Reference (`~/.config/darklyrc`)

Technical reference extracted from Darkly source (`kstyle/darkly.kcfg`, `kdecoration/darklysettingsdata.kcfg`, and C++ implementation).

---

## 1. Group `[Common]`
Shared metrics, shadows, and base styling parameters used by both the application style and window decorations.

| Key | Type | Default | Valid Values / Range | Description |
| :--- | :--- | :--- | :--- | :--- |
| `ButtonHeight` | Int | `3` | `0` - `20` | Additional vertical padding for buttons. |
| `ButtonWidth` | Int | `1` | `0` - `20` | Additional horizontal padding for buttons. |
| `CornerRadius` | Int | `9` (style) / `6` (windeco) | `1` - `16` | Corner radius for windows, dialogs, menus, and popups. Set to `8` or `6` for Breeze-aligned rounding. |
| `FancyMargins` | Bool | `true` | `true`, `false` | Enables padded margins around widget contents. |
| `FloatingTitlebar` | Bool | `true` (style) / `false` (windeco) | `true`, `false` | Detached floating titlebar style. Set to `false` for seamless titlebars. |
| `MenuItemHeight` | Int | `4` | `0` - `20` | Vertical padding between menu entries. |
| `OutlineCloseButton`| Bool | `false` | `true`, `false` | Draw subtle ring outline around titlebar close button. |
| `ShadowColor` | Color | `0, 0, 0` | `R, G, B` | Color of drop shadows. |
| `ShadowIntensity` | Enum | `Medium` | `Low`, `Medium`, `High`, `Maximum` | Drop shadow density. |
| `ShadowSize` | Enum | `ShadowLarge` | `ShadowNone`, `ShadowSmall`, `ShadowMedium`, `ShadowLarge`, `ShadowVeryLarge` | Window shadow extent. |
| `ShadowStrength` | Int | `255` (style) / `50` (windeco)| `25` - `255` | Alpha intensity of window shadows. |
| `SunkenEffect` | Bool | `false` | `true`, `false` | Sunken depression look on pressed controls. |
| `UseNewCheckBox` | Bool | `true` | `true`, `false` | Modern animated checkbox styling. |

---

## 2. Group `[Style]`
Widget style engine parameters loaded by `darkly6.so`.

### Opacity & Translucency
| Key | Type | Default | Valid Values | Description |
| :--- | :--- | :--- | :--- | :--- |
| `MenuOpacity` | Int | `100` | `0` - `100` | Opacity percentage for `QMenu` popups and dropdowns. |
| `DolphinSidebarOpacity` | Int | `100` | `0` - `100` | Opacity percentage for Dolphin's Places / Dock panels. |
| `DolphinViewOpacity` | Int | `100` | `0` - `100` | Opacity percentage for Dolphin's central file listing view (`KItemListContainer`). |
| `TransparentDolphinView`| Bool | `false` | `true`, `false` | Legacy toggle; auto-migrates to `DolphinViewOpacity=0` if opacity was `100`. Set to `true` alongside `DolphinViewOpacity` for compatibility. |
| `ToolBarOpacity` | Int | `100` | `0` - `100` | Opacity percentage for toolbars. Also read by `[Windeco]` when `BlurTransparentTitleBar=true`. |
| `MenuBarOpacity` | Int | `100` | `0` - `100` | Opacity percentage for menu bars (`QMenuBar`). |
| `TabBarOpacity` | Int | `100` | `0` - `100` | Opacity percentage for tab bars (e.g. Dolphin & Konsole tabs). |
| `OpaqueInactiveWindows`| Bool | `false` | `true`, `false` | If `true`, translucent surfaces become 100% solid when the window loses focus. |
| `OpaqueApps` | StringList | (empty) | Comma-separated app names | Applications where translucency should be forcefully suppressed. |
| `ForceOpaque` | StringList | `kscreenlocker,wine,vlc...` | Comma-separated app names | Built-in list of video players/VMs where alpha buffer causes artifacts. |

### Frames & Outlines
| Key | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `DockWidgetDrawFrame` | Bool | `false` | Draw border frame around dock panels. Must be `false` for transparent Dolphin sidebars. |
| `SidePanelDrawFrame` | Bool | `false` | Draw border frame around side panels. |
| `TitleWidgetDrawFrame`| Bool | `false` | Draw border frame around title widgets. |
| `KTextEditDrawFrame` | Bool | `false` | Draw outer frame around text editing areas. |
| `FullOutline` | Bool | `false` | Draw 1px accent outline around full windows. |
| `NoOutline` | Bool | `false` | Suppress all widget focus outlines. |
| `MenuItemDrawStrongFocus` | Bool | `true` | Solid colored background highlight on selected menu items. |
| `RoundedRubberBandFrame` | Bool | `true` | Rounded corners for selection rectangle in file views. |

### Widget Specifics
| Key | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `DisableDolphinUrlNavigatorBackground` | Bool | `true` | Makes Dolphin path breadcrumb bar background translucent/transparent. |
| `NewDolphinSelectionStyle` | Bool | `false` | Dolphin less-saturated selection style. |
| `TabBarTabExpandFullWidth` | Bool | `true` | Tabs stretch across the entire tabbar width. |
| `TabBarAltStyle` | Bool | `false` | Alternative underlined tab indicator style. |
| `DocumentModeTabs` | Bool | `false` | Compact document-style tabs. |
| `UnifiedTabBarKonsole` | Bool | `false` | Unified Konsole tabbar design. |
| `SplitterProxyEnabled` | Bool | `true` | Widened invisible hover zone for window/panel splitters. |
| `SplitterProxyWidth` | Int | `12` | Pixel hit width for splitter proxy. |
| `WindowDragMode` | Enum | `WD_MINIMAL` | `WD_NONE`, `WD_MINIMAL`, `WD_FULL` (drag window from empty areas). |
| `AnimationsEnabled` | Bool | `true` | Smooth hover/focus fade transitions. |
| `AnimationsDuration` | Int | `250` | Transition animation duration in ms. |

---

## 3. Group `[Windeco]`
Window decoration parameters loaded by `org.kde.darkly.so` (KDecoration3).

| Key | Type | Default | Valid Values | Description |
| :--- | :--- | :--- | :--- | :--- |
| `BlurTransparentTitleBar` | Bool | `false` | `true`, `false` | **Critical:** Makes titlebar translucent, syncs alpha to `ToolBarOpacity` in `[Style]`, and registers top blur polygon via `KDecoration3::setBlurRegion()`. |
| `BorderSize` | Enum | `BorderNone` | `BorderNone`, `BorderNoSides`, `BorderTiny`, `BorderNormal`, `BorderLarge`, etc. | Window border thickness. |
| `ButtonSize` | Enum | `ButtonDefault` | `ButtonTiny`, `ButtonSmall`, `ButtonDefault`, `ButtonLarge`, `ButtonVeryLarge` | Titlebar button scale (Breeze stock = `ButtonDefault`). |
| `DrawBorderOnMaximizedWindows` | Bool | `false` | `true`, `false` | Keep window border when maximized. |
| `DrawTitleBarSeparator` | Bool | `false` | `true`, `false` | Subtle separator line below titlebar. |
| `DrawBackgroundGradient` | Bool | `false` | `true`, `false` | Gradient shading across titlebar background. |
| `DrawHighlight` | Bool | `true` | `true`, `false` | Highlight active window borders. |
| `MatchInactiveTitleBar`| Bool | `false` | `true`, `false` | Use active titlebar color even when window is unfocused. |
| `TitleAlignment` | Enum | `AlignLeft` | `AlignLeft`, `AlignCenter`, `AlignCenterFullWidth`, `AlignRight` | Title text positioning. |
| `RoundedCorners` | Bool | `true` | `true`, `false` | Window frame top corners rounded to `CornerRadius`. |
| `OtherCornerRadius` | Int | `-1` | `-1` - `8` | Override for bottom corners (`-1` inherits `CornerRadius`). |
| `AnimationsEnabled` | Bool | `true` | `true`, `false` | Button hover animations. |
| `AnimationsDuration` | Int | `150` | ms | Button hover animation duration. |
