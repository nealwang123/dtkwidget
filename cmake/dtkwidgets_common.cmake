# 1. 该文件需要包含在 CMakeLists.txt 文件的最前面，project 的后面
# 2. 这里的宏定义、以来库主要用于 src 目录下生成 libdtkwidget 动态库
# 3. 另外保证项目内部的单元测试、示例程序等可以方便的包含使用这些内容
# 4. 关于静态库的使用：对于使用 libdtkwidget.a 的目标程序来说，需要
#   添加以下所有的库链接到目标程序。如果以下库的静态版本已被链接进
#   libdtkwidget.a，则不需要再额外添加。

# 5. 切记：和 libdtkwidget.so 无关的库、宏定义一定不能放在这里！！！
#   要在各自的项目中单独添加。

set(REQUIRED_QT_VERSION 5.11.3)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(AUTOMOC_COMPILER_PREDEFINES ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
# set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_CXX_FLAGS "-pipe -O2 -std=gnu++11 -Wall -Wextra -D_REENTRANT")
set(QT_USE_QTOPENGL TRUE)

find_library(Xi_LIB Xi REQUIRED)
find_library(Xcb_LIB xcb REQUIRED)
find_library(X11_LIB X11 REQUIRED)
find_library(Xext_LIB Xext REQUIRED)
find_library(XcbUtil_LIB xcb-util REQUIRED)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GSettings_Qt REQUIRED IMPORTED_TARGET gsettings-qt)
pkg_check_modules(StartupNotification1 REQUIRED IMPORTED_TARGET libstartup-notification-1.0)
include_directories(${GSettings_Qt_INCLUDE_DIRS})
link_directories(${GSettings_Qt_LIBRARY_DIRS})

find_package(Qt5PrintSupport CONFIG REQUIRED)
find_package(DtkGui${DTK_VERSION_SUFFIX} REQUIRED dtkgui${DTK_VERSION_SUFFIX})
find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS Core Gui Widgets Network DBus Xml Concurrent X11Extras)

# for qm files, need qttools5-dev
# find_package(Qt5LinguistTools REQUIRED)

set(DTKWIDGETS_COMMON_LIBS
    Qt5::Core

    Qt5::Gui
    Qt5::GuiPrivate

    Qt5::Widgets
    Qt5::WidgetsPrivate

    Qt5::PrintSupport
    Qt5::PrintSupportPrivate

    Qt5::X11Extras

    ${DtkGui${DTK_VERSION_SUFFIX}_LIBRARIES}

    ${GSettings_Qt}
    ${Xext_LIB}
    ${X11_LIB}
    ${Xi_LIB}
    ${Xcb_LIB}
    ${XcbUtil_LIB}

    PkgConfig::StartupNotification1

    Qt5::DBus
    Qt5::Xml
    Qt5::Network
    Qt5::Concurrent

    -lpthread
    # TODO support gtk+-2.0
)

add_definitions(
    -DENABLE_AI
    -DQT_NO_DEBUG
    -DQT_NO_DEBUG_OUTPUT
    -DDTK_NO_MULTIMEDIA
    -DQT_MESSAGELOGCONTEXT
    -DLIBDTKWIDGET_LIBRARY
    -DSN_API_NOT_YET_FROZEN
    -DDTK_LIB_DIR_NAME=\"libdtk-${PROJECT_VERSION}\"
    -DDWIDGET_TRANSLATIONS_PATH=\"${DWIDGET_TRANSLATIONS_PATH}\"
    -DDWIDGET_TRANSLATIONS_DIR=\"${DWIDGET_TRANSLATIONS_DIR}\"
    # -DQT_NO_KEYWORDS
    -DQT_GUI_LIB
    -DQT_CORE_LIB
    -DQT_XML_LIB
    -DQT_DBUS_LIB
    -DQT_WIDGETS_LIB
    -DQT_NETWORK_LIB
    -DQT_X11EXTRAS_LIB
    -DQT_CONCURRENT_LIB
    -DQT_PRINTSUPPORT_LIB
)
