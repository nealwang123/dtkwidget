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
#   ./compile.sh clean static check dep
#
# 8. 默认方式与系统预装的 release 版本保持一致：
#   ./compile.sh
#
# 9. 若有修改，需要保证以下几点：
#   a. 以上两种编译方式都没问题，尤其是静态编译
#   b. cd build && make install 所安装文件与预期一致
#   c. 生成的动态库所链接的外部动态库与原来一致
##################################################

function ShowBuildResult
{
    RES_FILE=".*\(libdtk.*\|dtk-svgc\|collections\|unit-tests\)"
    echo "============================ Generate all success! ============================"
    find $1 -regex "${RES_FILE}" -type f -perm /111
    echo "==============================================================================="
    return 0;
}

# 自动按照 debian/control 中的描述安装依赖
function InstallDependency
{
    sudo apt update && sudo apt -y install qtcreator \
    qt5-default build-essential && sudo apt -y build-dep .
    return 0;
}

# 生成到当前目录的 build 目录下编译并提示目标文件生成位置
CURRENT_DIR=$(dirname $(readlink -f $0))
BUILD_DIR=${CURRENT_DIR}/build
INSTALL_DIR=${BUILD_DIR}/out
SHARED_LIB_TYPE="ON"

[[ "$*" =~ dep ]] && InstallDependency
[[ "$*" =~ res ]] && ShowBuildResult ${BUILD_DIR} && exit 0

[[ "$*" =~ static ]] && SHARED_LIB_TYPE="OFF"
[[ "$*" =~ clean ]] && rm -rf "${BUILD_DIR}"

cmake -S . -B ${BUILD_DIR}                      \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}       \
    -DBUILD_SHARED_LIBS:BOOL=${SHARED_LIB_TYPE} \
    -DDTK_HAS_UNIT_TEST:BOOL=ON                 \
    && cmake --build ${BUILD_DIR} --target all -- -j$(nproc)

[[ "$*" =~ check ]] && unset DISPLAY            \
    && cmake --build ${BUILD_DIR} --target check -- -j$(nproc)

ShowBuildResult
