#!/bin/sh

declare -a CMAKE_SYS_ISOLATION
CMAKE_SYS_ISOLATION+=(-DCMAKE_FIND_ROOT_PATH_INCLUDE=ONLY)
CMAKE_SYS_ISOLATION+=(-DCMAKE_FIND_ROOT_PATH_LIBRARY=ONLY)
CMAKE_SYS_ISOLATION+=(-DCMAKE_FIND_ROOT_PATH_PROGRAM=ONLY)
CMAKE_SYS_ISOLATION+=(-DCMAKE_FIND_ROOT_PATH_PACKAGE=ONLY)

# Maybe? -DFIND_LIBRARY_USE_LIB64_PATHS=NO may present trouble for CDTs.
CMAKE_SYS_ISOLATION+=(-DCMAKE_FIND_LIBRARY_CUSTOM_LIB_SUFFIX=)
CMAKE_SYS_ISOLATION+=(-DFIND_LIBRARY_USE_LIB32_PATHS=NO)
CMAKE_SYS_ISOLATION+=(-DFIND_LIBRARY_USE_LIB64_PATHS=NO)
CMAKE_SYS_ISOLATION+=(-DFIND_LIBRARY_USE_LIBX32_PATHS=NO)

declare -a CMAKE_PLATFORM_FLAGS

# Filter out -I${PREFIX}/include from CXXFLAGS as it causes issues with bad header
# *and* macro name hygiene around libuv (queue.h / QUEUE etc, urgh).
re="(.*[[:space:]])\-I${PREFIX}/include[^[:space:]]*(.*)"
if [[ "${CXXFLAGS}" =~ $re ]]; then
  export CXXFLAGS="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
fi
if [[ "${CFLAGS}" =~ $re ]]; then
  export CFLAGS="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
fi

if [[ $target_platform == osx-64 ]]; then
  CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT})
fi

./bootstrap \
             --prefix="${PREFIX}" \
             --system-libs \
             --no-qt-gui \
             --no-system-libuv \
             --no-system-libarchive \
             --no-system-jsoncpp \
             --parallel=${CPU_COUNT} \
             -- \
             -DCMAKE_FIND_ROOT_PATH="${PREFIX}" \
             -DCMAKE_INSTALL_RPATH="${PREFIX}/lib" \
             "${CMAKE_SYS_ISOLATION[@]}" \
             "${CMAKE_PLATFORM_FLAGS[@]}" \
             -DCMAKE_CXX=${CXX} \
             -DCMAKE_CC=${CC} \
             -DCMAKE_BUILD_TYPE:STRING=Release \
             -DCMAKE_USE_SYSTEM_LIBRARY_LIBUV=NO
make install -j${CPU_COUNT} ${VERBOSE_CM}
