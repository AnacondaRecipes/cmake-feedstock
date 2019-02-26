#!/bin/sh

mkdir build || true
pushd build
source "${RECIPE_DIR}/share/cmake.conda/conda-env-vars.sh"

# Remove any --* option as they break building CMake itself!
declare -a CONDA_CMAKE_DEFAULTS_NO_DASH_DASH_OPTS
for elem in "${CONDA_CMAKE_DEFAULTS[@]}"; do [[ $elem =~ --.* ]] || CONDA_CMAKE_DEFAULTS_NO_DASH_DASH_OPTS+=("$elem"); done

# Filter out -I${PREFIX}/include from CXXFLAGS as it causes issues with bad header
# *and* macro name hygiene around libuv (queue.h / QUEUE etc, urgh).
re="(.*[[:space:]])\-I${PREFIX}/include[^[:space:]]*(.*)"
if [[ "${CXXFLAGS}" =~ $re ]]; then
  export CXXFLAGS="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
fi
if [[ "${CFLAGS}" =~ $re ]]; then
  export CFLAGS="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
fi

../cmake/bootstrap \
  --prefix="${PREFIX}" \
  --system-libs \
  --no-qt-gui \
  --no-system-libuv \
  --no-system-libarchive \
  --no-system-jsoncpp \
  --parallel=${CPU_COUNT} \
  -- \
  "${CONDA_CMAKE_DEFAULTS_NO_DASH_DASH_OPTS[@]}" \
  "${CONDA_CMAKE_TOOLCHAIN[@]}" \
  -DCMAKE_USE_SYSTEM_LIBRARY_LIBUV=NO
make install -j${CPU_COUNT} ${VERBOSE_CM}

# Copy conda-cmake config/build meta files.
mkdir "${PREFIX}/share/cmake.conda"
cp -rf "${RECIPE_DIR}"/share/cmake.conda/*.sh "${RECIPE_DIR}"/share/cmake.conda/*.cmake "${PREFIX}/share/cmake.conda"
