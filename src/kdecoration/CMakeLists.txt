add_definitions(-DTRANSLATION_DOMAIN="lucent_kwin_deco")

################# configuration #################
configure_file(config-lucent.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-lucent.h)

################# includes #################
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../liblucentcommon)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/../liblucentcommon)

################# target #################
set(lucentdecoration_SRCS
    lucentbutton.cpp
    lucentdecoration.cpp
    lucentexceptionlist.cpp
    lucentsettingsprovider.cpp
)

kconfig_add_kcfg_files(lucentdecoration_SRCS lucentsettings.kcfgc)

add_library(lucentdecoration MODULE ${lucentdecoration_SRCS})

set_target_properties(lucentdecoration PROPERTIES
    OUTPUT_NAME org.kde.lucent
)

target_link_libraries(lucentdecoration
    PRIVATE
        lucentcommon6
        KF6::CoreAddons
        KF6::ConfigWidgets
        KF6::GuiAddons
        KF6::I18n
        KF6::IconThemes
        KF6::WindowSystem
        Qt6::DBus
        KDecoration3::KDecoration
)

install(TARGETS lucentdecoration DESTINATION ${KDE_INSTALL_PLUGINDIR}/org.kde.kdecoration3)
