add_library(lucentcommon6 OBJECT lucentboxshadowrenderer.cpp)

set_target_properties(lucentcommon6 PROPERTIES POSITION_INDEPENDENT_CODE TRUE)

target_link_libraries(lucentcommon6
    PUBLIC
        Qt6::Core
        Qt6::Gui)
