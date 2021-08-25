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
# /use/local -> /usr/lib or /usr/include ...
string(COMPARE EQUAL "/usr/local" "${CMAKE_INSTALL_PREFIX}" dont_use_default_prefix)
if (dont_use_default_prefix)
    set(CMAKE_INSTALL_PREFIX "/usr")
endif()

if (${CMAKE_SYSTEM_PROCESSOR} MATCHES "mips64")
    target_compile_options(${PROJECT_NAME} PRIVATE
        "-O3                        \
        -ftree-vectorize            \
        -march=loongson3a           \
        -mhard-float                \
        -mno-micromips              \
        -mno-mips16                 \
        -flax-vector-conversions    \
        -mloongson-ext2             \
        -mloongson-mmi"
    )

    if (BUILD_SHARED_LIBS)
        target_compile_options(${PROJECT_NAME} PRIVATE "-Wl,-z,noexecstack")
    endif()
endif()

# Default, compile and install translation files separately,
# search tarnslation files from fixed path.
option(DTK_HAS_UNIT_TEST "Control unit test generate coverage." OFF)
option(DTK_HAS_TRANSLATION "Control whether translated files are compiled and install." ON)
option(DTK_STATIC_TRANSLATION "Control whether translated files are compiled with binary." OFF)

set(DWIDGET_TRANSLATIONS_PATH
    "/usr/share/libdtk-${DTK_WIDGET_VERSION}/DWidget${DTK_VERSION_SUFFIX}/translations"
)
set(DWIDGET_TRANSLATIONS_DIR
    "libdtk-${DTK_WIDGET_VERSION}/DWidget${DTK_VERSION_SUFFIX}/translations"
)

