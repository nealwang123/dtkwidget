cmake_minimum_required(VERSION 3.13)

include(../../cmake/config.cmake)

project(dtk-svgc LANGUAGES CXX)

include(../../cmake/dtkwidgets_common.cmake)

find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS Svg)

add_executable(${PROJECT_NAME} main.cpp)

if (NOT DEFINED ENV{DWIDGET_BUILD_LIB_PATH})
    find_package(DtkWidget${DTK_VERSION_SUFFIX} REQUIRED dtkwidget${DTK_VERSION_SUFFIX})
    set(DTKWIDGET_LIB ${DtkWidget${DTK_VERSION_SUFFIX}_LIBRARIES})
else()
    set(DTKWIDGET_LIB "-L$ENV{DWIDGET_BUILD_LIB_PATH} -ldtkwidget${DTK_VERSION_SUFFIX}")
endif()

target_link_libraries(${PROJECT_NAME}
    Qt5::Svg
    ${DTKWIDGET_LIB}
    ${DTKWIDGETS_COMMON_LIBS}
)

# /usr/lib/mips64el-linux-gnuabi64/libdtk-5.5.3/DWidget/bin/dtk-svgc
install(
    FILES ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/${DTK_DEB_HOST_MULTIARCH}/libdtk-${DTK_WIDGET_VERSION}/DWidget${DTK_VERSION_SUFFIX}/bin/
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
)
