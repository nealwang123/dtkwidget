cmake_minimum_required(VERSION 3.13)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/config.cmake)

project(dtkwidget${DTK_VERSION_SUFFIX} VERSION ${DTK_WIDGET_VERSION} LANGUAGES CXX)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/dtkwidgets_common.cmake)

add_definitions(-DQT_NO_KEYWORDS)

if (DTK_HAS_UNIT_TEST)
    set(GCC_COVERAGE_COMPILE_FLAGS "-fprofile-arcs -ftest-coverage")
    set(GCC_COVERAGE_LINK_FLAGS "-lgcov")
endif()
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GCC_COVERAGE_COMPILE_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${GCC_COVERAGE_LINK_FLAGS}")

include_directories(platforms translations util widgets)

set(D_HEADERS
    util/DDesktopServices
    util/DHiDPIHelper
    util/DFileIconProvider
    util/DWidgetUtil

    widgets/DTextEdit
    widgets/DStyledIconEngine
    widgets/DMenu
    # widgets/DPaletteHelper    # in 5.5
    widgets/DStyleOptionButton
    widgets/DMessageManager
    widgets/DSegmentedHighlight
    widgets/DDialogButtonBox
    widgets/DCheckBox
    widgets/DColumnView
    widgets/DStatusBar
    widgets/DCrumbEdit
    widgets/DLabel
    widgets/DSearchComboBox
    widgets/DToolBox
    widgets/DLineEdit
    widgets/DTableView
    widgets/DBackgroundGroup
    widgets/DListView
    widgets/DColorDialog
    widgets/DMenuBar
    widgets/DSearchEdit
    widgets/DFontComboBox
    widgets/DFocusFrame
    widgets/DStylePainter
    widgets/DFloatingMessage
    widgets/DVerticalSlider
    widgets/DWarningButton
    widgets/DStyleOptionViewItem
    widgets/DArrowLineExpand
    widgets/DWindowMaxButton
    widgets/DSegmentedControl
    widgets/DGraphicsClipEffect
    widgets/DTabWidget
    widgets/DSpinner
    widgets/DBorderlessWindow
    widgets/DPasswordEdit
    widgets/DSlider
    widgets/DWebView
    widgets/DSwitchButton
    widgets/DStyleHelper
    widgets/DShadowLine
    widgets/DDockWidget
    widgets/DIpv4LineEdit
    widgets/DWizardPage
    widgets/DCalendarWidget
    widgets/DStyleOptionBackgroundGroup
    widgets/DVerticalLine
    widgets/DArrowButton
    widgets/DImageButton
    widgets/DDataWidgetMapper
    # widgets/DTabletWindowOptionButton     # in 5.5
    widgets/DCommandLinkButton
    widgets/DWhatsThis
    widgets/DHorizontalLine
    widgets/DStackedWidget
    widgets/DMDIArea
    widgets/DGraphicsDropShadowEffect
    widgets/DSpinBox
    #./widgets/private/mpris/org.freedesktop.DBus.xml
    widgets/DInputDialog
    widgets/DPlainTextEdit
    widgets/DDialogCloseButton
    widgets/DThemeManager
    widgets/DWindowMinButton
    widgets/DHeaderView
    widgets/DUndoView
    widgets/DMdiSubWindow
    widgets/DPlatformWindowHandle
    widgets/DSettingsWidgetFactory
    widgets/DDateTimeEdit
    widgets/DStyledItemDelegate
    widgets/DColoredProgressBar
    widgets/DWaterProgress
    widgets/DFontDialog
    widgets/DWindowCloseButton
    widgets/DListWidget
    widgets/DTextBrowser
    widgets/DFontSizeManager
    widgets/DLCDNumber
    widgets/DDrawerGroup
    widgets/DTipLabel
    widgets/DWizard
    widgets/DPageIndicator
    widgets/DProgressBar
    widgets/DApplicationSettings
    widgets/DSplitter
    widgets/DArrowRectangle
    widgets/DFileChooserEdit
    widgets/DSimpleListItem
    widgets/DStyleOptionLineEdit
    widgets/DPushButton
    widgets/DFloatingWidget
    widgets/DToolBar
    widgets/DKeySequenceEdit
    widgets/DTileRules
    widgets/DIconButton
    widgets/DGraphicsView
    widgets/DAboutDialog
    widgets/DGroupBox
    widgets/DToolTip
    widgets/DSuggestButton
    widgets/DStyle
    widgets/DFrame
    widgets/DWindowQuitFullButton
    widgets/DOpenGLWidget
    widgets/DAnchors
    widgets/DHorizontalSlider
    widgets/DQuickWidget
    widgets/DTreeWidget
    widgets/DAction
    widgets/DScrollBar
    widgets/DClipEffectWidget
    widgets/DToast
    widgets/DTreeView
    widgets/DPrintPreviewDialog
    widgets/DToolButton
    widgets/DArrowLineDrawer
    widgets/DWindowOptionButton
    widgets/DAnchorsBase
    # widgets/DVideoWidget
    widgets/DDateEdit
    widgets/DStyleOption
    widgets/DMainWindow
    widgets/DRubberBand
    widgets/DTimeEdit
    widgets/DFloatingButton
    widgets/DAlertControl
    widgets/DTitlebar
    widgets/DFileDialog
    widgets/DApplicationHelper
    widgets/DTabBar
    widgets/DErrorMessage
    widgets/DButtonBox
    widgets/DDialog
    widgets/DAbstractDialog
    widgets/DDial
    widgets/DDoubleSpinBox
    widgets/DWidget
    widgets/DComboBox
    widgets/DMdiArea
    widgets/DExpandGroup
    widgets/DTableWidget
    widgets/DScrollArea
    widgets/DSettingsDialog
    widgets/DRadioButton
    widgets/DAccessibleWidget
    widgets/DBlurEffectWidget
    widgets/DDrawer
    widgets/DStandardItem
    widgets/DSimpleListView
    widgets/DMessageBox
    widgets/DApplication
)

# generate dtkwidget_config.h version info from project version info
if (NOT PROJECT_VERSION_PATCH)
    set(PROJECT_VERSION_PATCH 0)
endif()

if (NOT PROJECT_VERSION_TWEAK)
    set(PROJECT_VERSION_TWEAK 0)
endif()

# generate dtkwidget_config.h defined info from Dxxx headers
string(REGEX MATCHALL "D[a-zA-Z0-9]+" FILE_BASENAME "${D_HEADERS}")
file(WRITE  ${CMAKE_CURRENT_LIST_DIR}/dtkwidget_config.h "#ifndef DTKWIDGET_CONFIG_H\n#define DTKWIDGET_CONFIG_H\n")
foreach(D_HEADERS_DEFINED ${FILE_BASENAME})
    file(APPEND ${CMAKE_CURRENT_LIST_DIR}/dtkwidget_config.h "#define DTKWIDGET_CLASS_${D_HEADERS_DEFINED}\n")
endforeach()
file(APPEND ${CMAKE_CURRENT_LIST_DIR}/dtkwidget_config.h "#endif //DTKWIDGET_CONFIG_H")

# qdbusxml2cpp from qtbase5-dev-tools
execute_process(
        COMMAND qdbusxml2cpp -p ${CMAKE_CURRENT_BINARY_DIR}/session_interface.h: ${CMAKE_CURRENT_LIST_DIR}/widgets/dbus/com.iflytek.aiservice.session.xml
        COMMAND qdbusxml2cpp -i ${CMAKE_CURRENT_BINARY_DIR}/session_interface.h -p :${CMAKE_CURRENT_BINARY_DIR}/session_interface.cpp ${CMAKE_CURRENT_LIST_DIR}/widgets/dbus/com.iflytek.aiservice.session.xml

        COMMAND qdbusxml2cpp -p ${CMAKE_CURRENT_BINARY_DIR}/iat_interface.h: ${CMAKE_CURRENT_LIST_DIR}/widgets/dbus/com.iflytek.aiservice.iat.xml
        COMMAND qdbusxml2cpp -i ${CMAKE_CURRENT_BINARY_DIR}/iat_interface.h -p :${CMAKE_CURRENT_BINARY_DIR}/iat_interface.cpp ${CMAKE_CURRENT_LIST_DIR}/widgets/dbus/com.iflytek.aiservice.iat.xml
)

set(PUBLIC_HEADERS
    dtkwidget_global.h
    dtkwidget_config.h

    ${CMAKE_CURRENT_BINARY_DIR}/session_interface.h
    ${CMAKE_CURRENT_BINARY_DIR}/iat_interface.h

    # platforms/mac/osxwindow.h
    platforms/x11/xutil.h
    # platforms/windows/popupmenustyle.h

    util/ddesktopservices.h
    util/dfileiconprovider.h
    util/dapplicationsettings.h
    util/dregionmonitor.h
    util/dwidgetutil.h
    util/dthumbnailprovider.h
    util/dhidpihelper.h
    util/dtrashmanager.h
    widgets/dstackwidget.h
    widgets/dframe.h
    widgets/dwidgetstype.h
    widgets/dipv4lineedit.h
    widgets/dtabbar.h
    widgets/ddialog.h
    widgets/dslider.h
    widgets/dwindowmaxbutton.h
    widgets/dfloatingmessage.h
    widgets/dcommandlinkbutton.h
    widgets/dsegmentedcontrol.h
    widgets/dabstractdialog.h
    widgets/dsimplelistitem.h
    widgets/dlistview.h
    widgets/dcircleprogress.h
    widgets/dstyleoption.h
    widgets/darrowlinedrawer.h
    # widgets/dvideowidget.h
    widgets/dsimplelistview.h
    widgets/dsearchedit.h
    widgets/dexpandgroup.h
    widgets/dpicturesequenceview.h
    widgets/dwindowquitfullbutton.h
    widgets/dmessagemanager.h
    widgets/dapplication.h
    widgets/dsettingsdialog.h
    widgets/dthememanager.h
    widgets/dimagebutton.h
    widgets/dwarningbutton.h
    widgets/dbaseline.h
    widgets/dflowlayout.h
    widgets/dtickeffect.h
    widgets/dboxwidget.h
    widgets/dcrumbedit.h
    widgets/darrowrectangle.h
    widgets/dspinbox.h
    widgets/dblureffectwidget.h
    widgets/ddrawer.h
    widgets/dalertcontrol.h
    widgets/dtooltip.h
    widgets/dsuggestbutton.h
    widgets/dplatformwindowhandle.h
    widgets/dtoolbutton.h
    widgets/denhancedwidget.h
    widgets/dsettingswidgetfactory.h
    widgets/dfloatingbutton.h
    widgets/dprogressbar.h
    widgets/dtitlebar.h
    widgets/dswitchlineexpand.h
    widgets/dspinner.h
    widgets/dtiplabel.h
    widgets/dconstants.h
    widgets/dfloatingwidget.h
    widgets/dstyle.h
    widgets/dmpriscontrol.h
    widgets/dtoast.h
    widgets/dprintpreviewwidget.h
    widgets/dgraphicsclipeffect.h
    widgets/dpasswordedit.h
    widgets/dprintpickcolorwidget.h
    widgets/danchors.h
    widgets/dloadingindicator.h
    # widgets/dpalettehelper.h    # in 5.5
    # widgets/dtabletwindowoptionbutton.h
    widgets/dswitchbutton.h
    widgets/dshadowline.h
    widgets/dclipeffectwidget.h
    widgets/dapplicationhelper.h
    widgets/dkeysequenceedit.h
    widgets/daboutdialog.h
    widgets/dwindowoptionbutton.h
    widgets/dmainwindow.h
    widgets/dinputdialog.h
    widgets/dpageindicator.h
    widgets/dheaderline.h
    widgets/dbaseexpand.h
    widgets/dx11window.h
    widgets/ddialogclosebutton.h
    widgets/diconbutton.h
    widgets/dlineedit.h
    widgets/dbackgroundgroup.h
    widgets/dwindowminbutton.h
    widgets/dwaterprogress.h
    widgets/dfilechooseredit.h
    widgets/dgraphicsgloweffect.h
    widgets/ddrawergroup.h
    widgets/dshortcutedit.h
    widgets/dfiledialog.h
    widgets/darrowbutton.h
    widgets/dialog_constants.h
    widgets/dwindowclosebutton.h
    widgets/dlabel.h
    widgets/dbuttonbox.h
    widgets/darrowlineexpand.h
    widgets/dstyleditemdelegate.h
    widgets/dtextedit.h
    widgets/dcoloredprogressbar.h
    widgets/dsearchcombobox.h
    widgets/dprintpreviewdialog.h
    # moc_predefs.h
)

include_directories(
    widgets/private/
    widgets/private/keyboardmonitor
    widgets/private/settings
    widgets/private/startupnotifications
    widgets/private/mpris

    util/private
)

set(PRIVATE_HEADERS
    util/private/dregionmonitor_p.h

    widgets/dinputdialog_p.h

    widgets/private/dcircleprogress_p.h
    widgets/private/dipv4lineedit_p.h
    widgets/private/dbuttonbox_p.h
    widgets/private/dtickeffect_p.h
    widgets/private/dfloatingmessage_p.h
    widgets/private/settings/combobox.h
    widgets/private/settings/buttongroup.h
    widgets/private/settings/navigation.h
    widgets/private/settings/content.h
    widgets/private/settings/shortcutedit.h
    widgets/private/settings/contenttitle.h
    widgets/private/settings/navigationdelegate.h
    widgets/private/dlistview_p.h
    widgets/private/dsearchcombobox_p.h
    widgets/private/dabstractdialogprivate_p.h
    widgets/private/ddrawer_p.h
    widgets/private/darrowrectangle_p.h
    widgets/private/dimagebutton_p.h
    widgets/private/mpris/dmprismonitor.h
    widgets/private/mpris/dbusinterface.h
    widgets/private/mpris/dbusmpris.h
    widgets/private/dalertcontrol_p.h
    widgets/private/dsearchedit_p.h
    widgets/private/ddialog_p.h
    widgets/private/dfloatingwidget_p.h
    widgets/private/dpicturesequenceview_p.h
    widgets/private/dspinbox_p.h
    widgets/private/dapplication_p.h
    widgets/private/keyboardmonitor/dkeyboardmonitor.h
    widgets/private/dinputdialog_p.h
    widgets/private/dtiplabel_p.h
    widgets/private/dkeysequenceedit_p.h
    widgets/private/dprintpreviewdialog_p.h
    widgets/private/dslider_p.h
    widgets/private/dmpriscontrol_p.h
    widgets/private/dthemehelper.h
    widgets/private/dlabel_p.h
    widgets/private/dframe_p.h
    # widgets/private/dpalettehelper_p.h        # in 5.5
    widgets/private/dblureffectwidget_p.h
    widgets/private/diconbutton_p.h
    widgets/private/dloadingindicator_p.h
    widgets/private/daboutdialog_p.h
    widgets/private/dmainwindow_p.h
    widgets/private/dlineedit_p.h
    widgets/private/dpasswordedit_p.h
    widgets/private/startupnotifications/startupnotificationmonitor.h
    widgets/private/dfilechooseredit_p.h
    widgets/private/dswitchbutton_p.h
    widgets/private/dflowlayout_p.h
    widgets/private/dboxwidget_p.h
    widgets/private/dpageindicator_p.h
    widgets/private/dstackwidget_p.h
    widgets/private/dprintpreviewwidget_p.h
)

# generate DtkWidgets from PUBLIC_HEADERS
file(WRITE  ${CMAKE_CURRENT_LIST_DIR}/DtkWidgets)
string(REGEX MATCHALL "d[a-zA-Z0-9_]+.h" PUB_HEADERS_BASENAME "${PUBLIC_HEADERS}")
foreach(PUB_HEADER ${PUB_HEADERS_BASENAME})
    file(APPEND ${CMAKE_CURRENT_LIST_DIR}/DtkWidgets "#include \"${PUB_HEADER}\"\n")
endforeach()

set(HEADERS
    ${PUBLIC_HEADERS}
    ${PRIVATE_HEADERS}
)

set(SOURCES
    platforms/x11/xutil.cpp

    util/dfileiconprovider.cpp
    util/dthumbnailprovider.cpp
    util/dwidgetutil.cpp
    util/dhidpihelper.cpp
    util/dapplicationsettings.cpp
    util/ddesktopservices_linux.cpp
    util/dtrashmanager_linux.cpp
    util/dregionmonitor.cpp

    widgets/private/keyboardmonitor/dkeyboardmonitor.cpp
    widgets/private/startupnotifications/startupnotificationmonitor.cpp
    widgets/private/mpris/dmprismonitor.cpp
    widgets/private/mpris/dbusinterface.cpp
    widgets/private/mpris/dbusmpris.cpp
    widgets/private/dthemehelper.cpp
    widgets/dabstractdialog.cpp
    widgets/ddialog.cpp
    widgets/dinputdialog.cpp
    widgets/daboutdialog.cpp
    widgets/dsettingsdialog.cpp
    widgets/private/settings/buttongroup.cpp
    widgets/private/settings/combobox.cpp
    widgets/private/settings/content.cpp
    widgets/private/settings/contenttitle.cpp
    widgets/private/settings/navigation.cpp
    widgets/private/settings/navigationdelegate.cpp
    widgets/private/settings/shortcutedit.cpp
    widgets/dfiledialog.cpp
    widgets/dprintpreviewdialog.cpp
    widgets/dmpriscontrol.cpp
    widgets/dslider.cpp
    widgets/dbackgroundgroup.cpp
    widgets/dthememanager.cpp
    widgets/dapplication.cpp
    widgets/dbaseline.cpp
    widgets/dheaderline.cpp
    widgets/dbaseexpand.cpp
    widgets/darrowbutton.cpp
    widgets/darrowlineexpand.cpp
    widgets/dswitchlineexpand.cpp
    widgets/dimagebutton.cpp
    widgets/dloadingindicator.cpp
    widgets/dsearchedit.cpp
    widgets/dswitchbutton.cpp
    widgets/dsegmentedcontrol.cpp
    widgets/dlineedit.cpp
    widgets/dwindowmaxbutton.cpp
    widgets/dwindowminbutton.cpp
    widgets/dwindowclosebutton.cpp
    widgets/dwindowoptionbutton.cpp
    # widgets/dtabletwindowoptionbutton.cpp
    widgets/dwindowquitfullbutton.cpp
    widgets/dshortcutedit.cpp
    widgets/dsimplelistview.cpp
    widgets/dsimplelistitem.cpp
    widgets/dexpandgroup.cpp
    widgets/darrowrectangle.cpp
    widgets/dgraphicsgloweffect.cpp
    widgets/dboxwidget.cpp
    widgets/dcircleprogress.cpp
    widgets/dstackwidget.cpp
    widgets/dfilechooseredit.cpp
    widgets/dpasswordedit.cpp
    widgets/dipv4lineedit.cpp
    widgets/dspinbox.cpp
    widgets/dpicturesequenceview.cpp
    widgets/dflowlayout.cpp
    widgets/dlistview.cpp
    widgets/denhancedwidget.cpp
    widgets/dtitlebar.cpp
    widgets/dplatformwindowhandle.cpp
    widgets/dmainwindow.cpp
    widgets/dblureffectwidget.cpp
    widgets/dpageindicator.cpp
    widgets/dclipeffectwidget.cpp
    widgets/dgraphicsclipeffect.cpp
    widgets/dtickeffect.cpp
    widgets/dwaterprogress.cpp
    widgets/dsettingswidgetfactory.cpp
    widgets/dspinner.cpp
    widgets/dcrumbedit.cpp
    widgets/dtabbar.cpp
    widgets/dsuggestbutton.cpp
    widgets/dstyleoption.cpp
    widgets/dtoast.cpp
    widgets/danchors.cpp
    widgets/dstyle.cpp
    widgets/dfloatingbutton.cpp
    widgets/dstyleditemdelegate.cpp
    widgets/diconbutton.cpp
    widgets/dfloatingwidget.cpp
    widgets/dapplicationhelper.cpp
    widgets/dfloatingmessage.cpp
    widgets/dmessagemanager.cpp
    widgets/dbuttonbox.cpp
    widgets/dwarningbutton.cpp
    widgets/dcommandlinkbutton.cpp
    widgets/ddialogclosebutton.cpp
    widgets/dtiplabel.cpp
    widgets/dtooltip.cpp
    widgets/dframe.cpp
    widgets/dshadowline.cpp
    widgets/dcoloredprogressbar.cpp
    widgets/dkeysequenceedit.cpp
    widgets/dprogressbar.cpp
    widgets/dlabel.cpp
    widgets/dtextedit.cpp
    widgets/ddrawer.cpp
    widgets/darrowlinedrawer.cpp
    widgets/ddrawergroup.cpp
    widgets/dalertcontrol.cpp
    widgets/dtoolbutton.cpp
    widgets/dsearchcombobox.cpp
    widgets/dprintpreviewwidget.cpp
    widgets/dprintpickcolorwidget.cpp
    # widgets/dpalettehelper.cpp    # in 5.5

    # qrc_icons.cpp                 # Created by Qt
    # qrc_dtk-icon-theme.cpp        # Created by Qt

    ${CMAKE_CURRENT_BINARY_DIR}/iat_interface.cpp               # generated by qdbusxml2cpp
    ${CMAKE_CURRENT_BINARY_DIR}/session_interface.cpp           # generated by qdbusxml2cpp
)

set(RESOURCES
    ./widgets/assets/icons/dtk-icon-theme.qrc
    ./widgets/icons.qrc
)

# 该命令依赖包：qttools5-dev-tools
# qt5_create_translation(QM_FILES ${LANGUAGE_TS_FILES})

# 重新实现上面的方法
include(../cmake/tools.cmake)
file(GLOB LANGUAGE_TS_FILES "translations/*.ts")
dtk_create_qm_from_ts(QM_FILES ${LANGUAGE_TS_FILES})

if (DTK_HAS_TRANSLATION)
    if (DTK_STATIC_TRANSLATION)
        # create qrc and build
        dtk_create_rcc_files(QRC_FILE_PATH ${QM_FILES})
        set(RESOURCES ${RESOURCES} ${QM_FILES} ${QRC_FILE_PATH})
    else()
        # generate and install
        add_custom_target(generate_qm ALL DEPENDS ${QM_FILES})
    endif()
endif()

option(BUILD_SHARED_LIBS "Build using shared libraries" ON)
if (BUILD_SHARED_LIBS)
    add_library(${PROJECT_NAME} SHARED ${HEADERS} ${SOURCES} ${RESOURCES})
else()
    add_library(${PROJECT_NAME} STATIC ${HEADERS} ${SOURCES} ${RESOURCES})
endif()

target_link_libraries(${PROJECT_NAME}
    ${DTKWIDGETS_COMMON_LIBS}
)

# set_target_properties(${PROJECT_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ${BUILD_SHARED_LIBS})
set_target_properties(${PROJECT_NAME} PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})

set(INSTALL_HEADERS
    ${HEADERS}
    ${D_HEADERS}
    DtkWidgets
)

# 库文件安装路径 /usr/lib/x86_64-linux-gnu/libdtkwidget5.5.so.5.5.3
install(TARGETS ${PROJECT_NAME}
    # EXPORT DtkWidgetsExport
    LIBRARY DESTINATION lib/${DTK_DEB_HOST_MULTIARCH}
    ARCHIVE DESTINATION lib/${DTK_DEB_HOST_MULTIARCH}
)

# 头文件安装路径 /usr/include/libdtk-5.5.3/DWidget5.5/*.h
install(FILES ${INSTALL_HEADERS}
    DESTINATION include/libdtk-${PROJECT_VERSION}/DWidget${DTK_VERSION_SUFFIX}
)

if (DTK_HAS_TRANSLATION)
    # 翻译文件安装路径
    install(FILES ${QM_FILES}
        DESTINATION ${DWIDGET_TRANSLATIONS_PATH}/${DWIDGET_TRANSLATIONS_DIR}
    )
endif()

# /usr/include/libdtk-5.5.3/DWidget
# TODO: delete this in dtkcore
# set(DCORE_HEADERS_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX}/include/libdtk-${PROJECT_VERSION}/DWidget${DTK_VERSION_SUFFIX})

# generate and install pkgconfig file to /usr/lib/x86_64-linux-gnu/pkgconfig/dtkwidget5.5.pc
configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/../cmake/DtkWidget${DTK_VERSION_SUFFIX}/dtkwidget${DTK_VERSION_SUFFIX}.pc.in
    ${CMAKE_CURRENT_BINARY_DIR}/../cmake/DtkWidget${DTK_VERSION_SUFFIX}/dtkwidget${DTK_VERSION_SUFFIX}.pc @ONLY
)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/../cmake/DtkWidget${DTK_VERSION_SUFFIX}/dtkwidget${DTK_VERSION_SUFFIX}.pc
    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/${DTK_DEB_HOST_MULTIARCH}/pkgconfig
)

# generate and install qt_lib_dtkwidget5.5.pri to /usr/lib/x86_64-linux-gnu/qt5/mkspecs/modules/qt_lib_dtkwidget5.5.pri
configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/../cmake/DtkWidget${DTK_VERSION_SUFFIX}/qt_lib_dtkwidget${DTK_VERSION_SUFFIX}.pri.in
    ${CMAKE_CURRENT_BINARY_DIR}/../cmake/DtkWidget${DTK_VERSION_SUFFIX}/qt_lib_dtkwidget${DTK_VERSION_SUFFIX}.pri @ONLY
)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/../cmake/DtkWidget${DTK_VERSION_SUFFIX}/qt_lib_dtkwidget${DTK_VERSION_SUFFIX}.pri
    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/${DTK_DEB_HOST_MULTIARCH}/qt5/mkspecs/modules
)

# generate and install DtkWidget5.5Config.cmake to /usr/lib/x86_64-linux-gnu/cmake/DtkWidget5.5/DtkWidget5.5Config.cmake
configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/../cmake/DtkWidget${DTK_VERSION_SUFFIX}/DtkWidget${DTK_VERSION_SUFFIX}Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/../cmake/DtkWidget${DTK_VERSION_SUFFIX}/DtkWidget${DTK_VERSION_SUFFIX}Config.cmake @ONLY
)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/../cmake/DtkWidget${DTK_VERSION_SUFFIX}/DtkWidget${DTK_VERSION_SUFFIX}Config.cmake
    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/${DTK_DEB_HOST_MULTIARCH}/cmake/DtkWidget${DTK_VERSION_SUFFIX}
)
