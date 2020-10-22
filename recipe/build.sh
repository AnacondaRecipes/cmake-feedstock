#!/bin/sh
set -ex

pushd cmake

  ./bootstrap \
    --verbose \
    --prefix="${PREFIX}" \
    --system-libs \
    --no-qt-gui \
    --no-system-libarchive \
    --no-system-jsoncpp \
    --parallel=${CPU_COUNT} \
    -- \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_FIND_ROOT_PATH="${PREFIX}" \
    -DCMAKE_INSTALL_RPATH="${PREFIX}/lib" \
    -DCURSES_INCLUDE_PATH="${PREFIX}/include" \
    -DCMAKE_USE_SYSTEM_ZSTD=TRUE \
    -DCMAKE_USE_SYSTEM_LIBUV=TRUE \
    -DCMAKE_USE_SYSTEM_LIBLZMA=TRUE \
    -DCMAKE_USE_SYSTEM_ZLIB=TRUE \
    -DCMAKE_USE_SYSTEM_BZIP2=TRUE \
    -DBUILD_CursesDialog=ON \
    -DCMake_HAVE_CXX_MAKE_UNIQUE:INTERNAL=FALSE \
    -DCMAKE_OSX_SYSROOT:PATH=${CONDA_BUILD_SYSROOT} \
    -DCMAKE_PREFIX_PATH:PATH="${PREFIX}"

  # CMake automatically selects the highest C++ standard available
  make install -j${CPU_COUNT}

popd

