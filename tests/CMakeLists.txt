cmake_minimum_required(VERSION 3.13)

include(../cmake/config.cmake)

project(unit-tests LANGUAGES CXX)

include(../cmake/dtkwidgets_common.cmake)

find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS Test)

include_directories(
    # testcase dir
    ./testcases/widgets

    # sources dir
    ../src
    ../src/widgets
    ../src/widgets/private/
    ../src/widgets/private/keyboardmonitor
    ../src/widgets/private/settings
    ../src/widgets/private/startupnotifications
    ../src/widgets/private/mpris

    ../src/util/private
)

set(CMAKE_CXX_FLAGS
    "-g -Wall -fprofile-arcs -ftest-coverage -fsanitize=address -fsanitize-recover=address -O2 -fno-access-control"
)

add_executable(${PROJECT_NAME}
    main.cpp

    ./testcases/widgets/ut_dalertcontrol.cpp
    ./testcases/widgets/ut_dcrumbedit.cpp
    ./testcases/widgets/ut_dboxwidget.cpp
    ./testcases/widgets/ut_dblureffectwidget.cpp
    ./testcases/widgets/ut_diconbutton.cpp
    ./testcases/widgets/ut_dtoolbutton.cpp
    ./testcases/widgets/ut_dprogressbar.cpp
    ./testcases/widgets/ut_dwaterprogress.cpp
    ./testcases/widgets/ut_danchor.cpp
    ./testcases/widgets/ut_dmainwindow.cpp
    ./testcases/widgets/ut_dfloatingmessage.cpp
    ./testcases/widgets/ut_dswitchbutton.cpp
    ./testcases/widgets/ut_dwarningbutton.cpp
    ./testcases/widgets/ut_dsimplelistview.cpp
    ./testcases/widgets/ut_dkeysequenceedit.cpp
    ./testcases/widgets/ut_dslider.cpp
    ./testcases/widgets/ut_dwindowmaxbutton.cpp
    ./testcases/widgets/ut_dipv4lineedit.cpp
    ./testcases/widgets/ut_darrowlinedrawer.cpp
    ./testcases/widgets/ut_darrowlineexpand.cpp
    ./testcases/widgets/ut_dspinner.cpp
    ./testcases/widgets/ut_dshaowline.cpp
    ./testcases/widgets/ut_dwindowclosebutton.cpp
    ./testcases/widgets/ut_dwindowminbutton.cpp
    ./testcases/widgets/ut_dwindowoptionbutton.cpp
    ./testcases/widgets/ut_dwindowquitfullbutton.cpp
    ./testcases/widgets/ut_dtextedit.cpp
    ./testcases/widgets/ut_dpushbutton.cpp
    ./testcases/widgets/ut_dtitlebar.cpp
    ./testcases/widgets/ut_dpageindicator.cpp
    ./testcases/widgets/ut_dtiplabel.cpp
)

if (NOT DEFINED ENV{DWIDGET_BUILD_LIB_PATH})
    find_package(DtkWidget${DTK_VERSION_SUFFIX} REQUIRED dtkwidget${DTK_VERSION_SUFFIX})
    set(DTKWIDGET_LIB ${DtkWidget${DTK_VERSION_SUFFIX}_LIBRARIES})
else()
    set(DTKWIDGET_LIB "-L$ENV{DWIDGET_BUILD_LIB_PATH} -ldtkwidget${DTK_VERSION_SUFFIX}")
endif()

target_link_libraries(${PROJECT_NAME}
    Qt5::Test
    ${DTKWIDGET_LIB}
    ${DTKWIDGETS_COMMON_LIBS}
    -L/usr/lib/${DTK_DEB_HOST_MULTIARCH} -lgtest # -lgmock
)

add_custom_target(check)
add_custom_command(TARGET check
    COMMAND export ASAN_OPTIONS=halt_on_error=0 && export LD_LIBRARY_PATH=$ENV{DWIDGET_BUILD_LIB_PATH}:$LD_LIBRARY_PATH && ./${PROJECT_NAME}
)
add_dependencies(check ${PROJECT_NAME})
