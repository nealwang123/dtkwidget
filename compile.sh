#!/bin/bash
set -e

##################################################
# 1. 首次运行需要执行./compile.sh dep，以安装依赖
#   之后的编译直接执行./compile.sh 即可
# 2. 执行 ./compile.sh check 以运行单元测试
# 3. 执行 ./compile.sh clean 以清空目录并重新构建
# 4. 默认安装路径为当期路径 build/out,
#   cd build && make install 进行安装
# 5. 默认编译静态库，加 static 参数生成动态库
# 6. 如果单独编译src目录外的其他项目，需要导入环境
#   变量：export DWIDGET_BUILD_LIB_PATH=xxx. 环境
#   变量指向库文件所在路径, 注意路径必须是绝对路径
#
# 7. 比如你可以按以下方式一键编译：
# ./compile.sh clean static check dep
#
# 8. 默认方式与系统预装的 release 版本保持一致：
# ./compile.sh
##################################################

# 自动按照 debian/control 中的描述安装依赖
[[ ”$*“ =~ dep ]] && sudo apt update &&     \
    sudo apt -y install qtcreator lcov      \
    qt5-default build-essential &&          \
    sudo apt -y build-dep .

# 生成到当前目录的 build 目录下编译并提示目标文件生成位置
CURRENT_DIR=$(dirname $(readlink -f $0))
BUILD_DIR=${CURRENT_DIR}/build
INSTALL_DIR=${BUILD_DIR}/out
SHARED_LIB_TYPE="ON"

[[ "$*" =~ static ]] && SHARED_LIB_TYPE="OFF"

[[ "$*" =~ clean ]] && rm -rf "${BUILD_DIR}"

[[ -z "$*" || "$*" =~ clean ]] && cmake -S . -B ${BUILD_DIR}    \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}                       \
    -DBUILD_SHARED_LIBS:BOOL=${SHARED_LIB_TYPE}                 \
    -DDTK_HAS_UNIT_TEST:BOOL=ON                                 \
    && cmake --build ${BUILD_DIR} --target all -- -j$(nproc)

[[ "$*" =~ check ]] && cmake --build ${BUILD_DIR} --target check -- -j$(nproc)

[[ -z "$*" || $* =~ clean ]]  &&
{
    echo "============================ Generate all success! ============================"
    find ${BUILD_DIR} -regex ".*\(libdtk.*\|dtk-svgc\|collections\|unit-tests\)" -type f
    echo "==============================================================================="
}
