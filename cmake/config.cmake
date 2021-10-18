# DTK_WIDGET_VERSION synchronized with git tag
# git describe --tags --abbrev=0
set(DTK_WIDGET_VERSION "5.5.9")

# architectureod of pc, such as x86_64-linux-gnu
set(DTK_DEB_HOST_MULTIARCH)
execute_process(COMMAND
    dpkg-architecture -qDEB_HOST_MULTIARCH
    TIMEOUT 5
    OUTPUT_VARIABLE DTK_DEB_HOST_MULTIARCH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

# such as dtkwidget, dtkwidget5, dtkwidget5.5
# for example, it can be combined into libdtkwidget5.5.so.5.4.3
set(DTK_VERSION_SUFFIX "")

# generate moc_predefs.h
set(AUTOMOC_COMPILER_PREDEFINES ON)

# rewrite install prefix of target
# /usr/local -> /usr/lib or /usr/include ...
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "/usr")
endif()

# Default, compile and install translation files separately,
# search tarnslation files from fixed path.
option(BUILD_SHARED_LIBS "Build using shared libraries" ON)
option(DTK_HAS_UNIT_TEST "Control unit test generate coverage." OFF)
option(DTK_HAS_TRANSLATION "Control whether translated files are compiled and install." ON)
option(DTK_STATIC_TRANSLATION "Control whether translated files are compiled with binary." OFF)

set(DWIDGET_TRANSLATIONS_PATH
    "${CMAKE_INSTALL_PREFIX}/share/libdtk-${DTK_WIDGET_VERSION}/DWidget${DTK_VERSION_SUFFIX}/translations"
)
set(DWIDGET_TRANSLATIONS_DIR
    "libdtk-${DTK_WIDGET_VERSION}/DWidget${DTK_VERSION_SUFFIX}/translations"
)

