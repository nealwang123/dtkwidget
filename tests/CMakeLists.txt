cmake_minimum_required(VERSION 3.13)

include(../cmake/config.cmake)

project(unit-tests LANGUAGES CXX)

set(DTK_HAS_UNIT_TEST ON)
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

# for asan
if (NOT ${CMAKE_SYSTEM_PROCESSOR} MATCHES "mips64")
    set(BUILD_WITH_ASAN)
    set(CMAKE_CXX_FLAGS
        "-g -Wall -fsanitize=address -fsanitize-recover=address"
    )
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2 -fno-access-control")

add_executable(${PROJECT_NAME}
    main.cpp

    ./testcases/widgets/ut_daboutdialog.cpp
    ./testcases/widgets/ut_dabstractdialog.cpp
    ./testcases/widgets/ut_dalertcontrol.cpp
    ./testcases/widgets/ut_dcrumbedit.cpp
    ./testcases/widgets/ut_danchors.cpp
    ./testcases/widgets/ut_darrowbutton.cpp
    ./testcases/widgets/ut_darrowrectangle.cpp
    ./testcases/widgets/ut_dbackgroundgroup.cpp
    ./testcases/widgets/ut_dbaseline.cpp
    ./testcases/widgets/ut_dboxwidget.cpp
    ./testcases/widgets/ut_dblureffectwidget.cpp
    ./testcases/widgets/ut_dbuttonbox.cpp
    ./testcases/widgets/ut_dcircleprogress.cpp
    ./testcases/widgets/ut_dclipeffectwidget.cpp
    ./testcases/widgets/ut_dcoloredprogressbar.cpp
    ./testcases/widgets/ut_dcommandlinkbutton.cpp
    ./testcases/widgets/ut_ddialog.cpp
    ./testcases/widgets/ut_ddialogclosebutton.cpp
    ./testcases/widgets/ut_ddrawer.cpp
    ./testcases/widgets/ut_ddrawergroup.cpp
    ./testcases/widgets/ut_denhancedwidget.cpp
    ./testcases/widgets/ut_dfilechooseredit.cpp
    ./testcases/widgets/ut_dfiledialog.cpp
    ./testcases/widgets/ut_dfloatingbutton.cpp
    ./testcases/widgets/ut_dfloatingwidget.cpp
    ./testcases/widgets/ut_dflowlayout.cpp
    ./testcases/widgets/ut_dframe.cpp
    ./testcases/widgets/ut_dgraphicsclipeffect.cpp
    ./testcases/widgets/ut_dgraphicsgloweffect.cpp
    ./testcases/widgets/ut_dheaderline.cpp
    ./testcases/widgets/ut_diconbutton.cpp
    ./testcases/widgets/ut_dtoolbutton.cpp
    ./testcases/widgets/ut_dprogressbar.cpp
    ./testcases/widgets/ut_dwaterprogress.cpp
    ./testcases/widgets/ut_danchor.cpp
    ./testcases/widgets/ut_dinputdialog.cpp
    ./testcases/widgets/ut_dlabel.cpp
    ./testcases/widgets/ut_dlineedit.cpp
    ./testcases/widgets/ut_dlistview.cpp
    ./testcases/widgets/ut_dloadingindicator.cpp
    ./testcases/widgets/ut_dmainwindow.cpp
    ./testcases/widgets/ut_dfloatingmessage.cpp
    ./testcases/widgets/ut_dswitchbutton.cpp
    ./testcases/widgets/ut_dwarningbutton.cpp
    ./testcases/widgets/ut_dmessagemanager.cpp
    ./testcases/widgets/ut_dmpriscontrol.cpp
    ./testcases/widgets/ut_dpasswordedit.cpp
    ./testcases/widgets/ut_dpicturesequenceview.cpp
    ./testcases/widgets/ut_dsearchcombobox.cpp
    ./testcases/widgets/ut_dsearchedit.cpp
    ./testcases/widgets/ut_dsettingsdialog.cpp
    ./testcases/widgets/ut_dsettingswidgetfactory.cpp
    ./testcases/widgets/ut_dsimplelistview.cpp
    ./testcases/widgets/ut_dkeysequenceedit.cpp
    ./testcases/widgets/ut_dslider.cpp
    ./testcases/widgets/ut_dwindowmaxbutton.cpp
    ./testcases/widgets/ut_dipv4lineedit.cpp
    ./testcases/widgets/ut_darrowlinedrawer.cpp
    ./testcases/widgets/ut_darrowlineexpand.cpp
    ./testcases/widgets/ut_dspinbox.cpp
    ./testcases/widgets/ut_dspinner.cpp
    ./testcases/widgets/ut_dshaowline.cpp
    ./testcases/widgets/ut_dstackwidget.cpp
    ./testcases/widgets/ut_dstyle.cpp
    ./testcases/widgets/ut_dstyleditemdelegate.cpp
    ./testcases/widgets/ut_dstyleoption.cpp
    ./testcases/widgets/ut_dsuggestbutton.cpp
    ./testcases/widgets/ut_dtabbar.cpp
    ./testcases/widgets/ut_dtickeffect.cpp
    ./testcases/widgets/ut_dtooltip.cpp
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
