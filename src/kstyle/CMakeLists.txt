################# includes #################
include_directories(
    animations
    debug
    ${CMAKE_CURRENT_SOURCE_DIR}/../liblucentcommon
    ${CMAKE_CURRENT_BINARY_DIR}/../liblucentcommon
)

################# configuration #################
configure_file(config-lucent.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-lucent.h)

########### target ###############
set(lucent_PART_SRCS
    animations/lucentanimation.cpp
    animations/lucentanimations.cpp
    animations/lucentanimationdata.cpp
    animations/lucentbaseengine.cpp
    animations/lucentbusyindicatordata.cpp
    animations/lucentbusyindicatorengine.cpp
    animations/lucentdialdata.cpp
    animations/lucentdialengine.cpp
    animations/lucentenabledata.cpp
    animations/lucentgenericdata.cpp
    animations/lucentheaderviewdata.cpp
    animations/lucentheaderviewengine.cpp
    animations/lucentscrollbardata.cpp
    animations/lucentscrollbarengine.cpp
    animations/lucentspinboxengine.cpp
    animations/lucentspinboxdata.cpp
    animations/lucentstackedwidgetdata.cpp
    animations/lucentstackedwidgetengine.cpp
    animations/lucenttabbarengine.cpp
    animations/lucenttabbardata.cpp
    animations/lucenttoolboxengine.cpp
    animations/lucenttransitiondata.cpp
    animations/lucenttransitionwidget.cpp
    animations/lucentwidgetstateengine.cpp
    animations/lucentwidgetstatedata.cpp
    debug/lucentwidgetexplorer.cpp
    lucentaddeventfilter.cpp
    lucentblurhelper.cpp
    lucentframeshadow.cpp
    lucenthelper.cpp
    lucentmdiwindowshadow.cpp
    lucentmnemonics.cpp
    lucentpropertynames.cpp
    lucentshadowhelper.cpp
    lucentsplitterproxy.cpp
    lucentstyle.cpp
    lucentstyleplugin.cpp
    lucenttileset.cpp
    lucentwindowmanager.cpp
    lucenttoolsareamanager.cpp
)

kconfig_add_kcfg_files(lucent_PART_SRCS lucentstyleconfigdata.kcfgc)

add_library(lucent6 MODULE ${lucent_PART_SRCS})

################# link libraries #################
target_link_libraries(lucent6
    PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::DBus
    Qt6::Quick
    Qt6::QuickWidgets
    KF6::CoreAddons
    KF6::ConfigCore
    KF6::ConfigGui
    KF6::GuiAddons
    KF6::IconThemes
    KF6::WindowSystem
    KF6::ColorScheme
    lucentcommon6
)

if(TARGET KF6::Style)
    target_link_libraries(lucent6 PRIVATE KF6::Style)
endif()

if(TARGET KF6::KirigamiPlatform)
    target_link_libraries(lucent6 PRIVATE KF6::KirigamiPlatform)
endif()

########### install files ###############
install(TARGETS lucent6 DESTINATION ${KDE_INSTALL_QTPLUGINDIR}/styles/)
install(FILES lucent.themerc DESTINATION ${KDE_INSTALL_DATADIR}/kstyle/themes)
