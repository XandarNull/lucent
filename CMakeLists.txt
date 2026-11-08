cmake_minimum_required(VERSION 3.16)

project(
    lucent
    DESCRIPTION "Unified translucent application style and window decoration for KDE Plasma 6."
    VERSION 1.0.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(KF6_MIN_VERSION "6.0.0")
set(QT_MIN_VERSION "6.7.0")

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

set(KDE_COMPILERSETTINGS_LEVEL "5.82")

include(KDEInstallDirs6)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(FeatureSummary)

remove_definitions(-DQT_NO_FOREACH -DQT_NO_CAST_FROM_ASCII)
add_definitions(-DQT_ENABLE_KEYWORDS)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS Core Gui Widgets DBus Quick QuickWidgets)
find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS
    CoreAddons
    ColorScheme
    Config
    ConfigWidgets
    GuiAddons
    I18n
    IconThemes
    WindowSystem
)

find_package(KDecoration3 REQUIRED)
set(KDECORATION_VERSION ${KDecoration3_VERSION})
set(KDECORATION_VERSION_MAJOR ${KDecoration3_VERSION_MAJOR})
set(KDECORATION_VERSION_MINOR ${KDecoration3_VERSION_MINOR})
set(KDECORATION_VERSION_PATCH ${KDecoration3_VERSION_PATCH})

add_definitions(
    -DKDECORATION_VERSION_MAJOR=${KDECORATION_VERSION_MAJOR}
    -DKDECORATION_VERSION_MINOR=${KDECORATION_VERSION_MINOR}
    -DKDECORATION_VERSION_PATCH=${KDECORATION_VERSION_PATCH}
)

find_package(KF6KirigamiPlatform ${KF6_MIN_VERSION} QUIET)
find_package(KF6FrameworkIntegration ${KF6_MIN_VERSION} CONFIG QUIET)

set(LUCENT_HAVE_KSTYLE ${KF6FrameworkIntegration_FOUND})
set(LUCENT_HAVE_QTQUICK ${Qt6Quick_FOUND})

# Build native C++ plugins
add_subdirectory(src)

# Install themes
install(FILES color-schemes/Lucent.colors DESTINATION ${KDE_INSTALL_DATADIR}/color-schemes)
install(DIRECTORY desktoptheme/Lucent DESTINATION ${KDE_INSTALL_DATADIR}/plasma/desktoptheme)
install(DIRECTORY look-and-feel/Lucent DESTINATION ${KDE_INSTALL_DATADIR}/plasma/look-and-feel)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
