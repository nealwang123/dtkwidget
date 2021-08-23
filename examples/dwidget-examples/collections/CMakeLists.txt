cmake_minimum_required(VERSION 3.13)

include(../../../cmake/config.cmake)

project(collections LANGUAGES CXX)

include(../../../cmake/dtkwidgets_common.cmake)

include_directories(
    ${CMAKE_CURRENT_LIST_DIR}/../../../src          # mainwindow.h:27: #include widgets/dmainwindow.h
    ${CMAKE_CURRENT_LIST_DIR}/../../../src/util
    ${CMAKE_CURRENT_LIST_DIR}/../../../src/widgets
)

set(SOURCES
    main.cpp
    mainwindow.cpp
    buttonexample.cpp
    examplewindowinterface.cpp
    pagewindowinterface.cpp
    editexample.cpp
    sliderexample.cpp
    listviewexample.cpp
    windowexample.cpp
    tooltipexample.cpp
    spinnerexample.cpp
    dialogexample.cpp
    progressbarexample.cpp
    layoutexample.cpp
    scrollbarexample.cpp
    rubberbandexample.cpp
    widgetexample.cpp
    lcdnumberexample.cpp
    menuexample.cpp
)

set(HEADERS
    mainwindow.h
    buttonexample.h
    examplewindowinterface.h
    pagewindowinterface.h
    editexample.h
    sliderexample.h
    listviewexample.h
    windowexample.h
    tooltipexample.h
    spinnerexample.h
    dialogexample.h
    progressbarexample.h
    layoutexample.h
    scrollbarexample.h
    rubberbandexample.h
    widgetexample.h
    lcdnumberexample.h
    menuexample.h
)

set(RESOURCES
    images.qrc
    resources.qrc
    icons/theme-icons.qrc
)

qt5_wrap_cpp(${PROJECT_NAME}
        mainwindow.cpp
        buttonexample.cpp
        editexample.cpp
        sliderexample.cpp
        listviewexample.cpp
        windowexample.cpp
        tooltipexample.cpp
        spinnerexample.cpp
        dialogexample.cpp
        progressbarexample.cpp
        layoutexample.cpp
        scrollbarexample.cpp
        rubberbandexample.cpp
        widgetexample.cpp
        lcdnumberexample.cpp
        menuexample.cpp
)

add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS} ${RESOURCES})

if (NOT DEFINED ENV{DWIDGET_BUILD_LIB_PATH})
    find_package(DtkWidget${DTK_VERSION_SUFFIX} REQUIRED dtkwidget${DTK_VERSION_SUFFIX})
    set(DTKWIDGET_LIB ${DtkWidget${DTK_VERSION_SUFFIX}_LIBRARIES})
else()
    set(DTKWIDGET_LIB "-L$ENV{DWIDGET_BUILD_LIB_PATH} -ldtkwidget${DTK_VERSION_SUFFIX}")
endif()

target_link_libraries(${PROJECT_NAME}
    ${DTKWIDGET_LIB}
    ${DTKWIDGETS_COMMON_LIBS}
)

# /usr/lib/mips64el-linux-gnuabi64/examples/collections
# executable file must set permission 0755
install(
    FILES ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/${DTK_DEB_HOST_MULTIARCH}/examples
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
)

