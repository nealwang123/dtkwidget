cmake_minimum_required(VERSION 3.10)
project(DtkWidgetProject)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/config.cmake)

set(ENV{DWIDGET_BUILD_LIB_PATH}
    ${CMAKE_CURRENT_BINARY_DIR}/src
)

add_subdirectory(src)
add_subdirectory(tests)
add_subdirectory(tools/svgc)
add_subdirectory(examples/dwidget-examples/collections)
add_dependencies(dtk-svgc dtkwidget${DTK_VERSION_SUFFIX})
add_dependencies(unit-tests dtkwidget${DTK_VERSION_SUFFIX})
add_dependencies(collections dtkwidget${DTK_VERSION_SUFFIX})

