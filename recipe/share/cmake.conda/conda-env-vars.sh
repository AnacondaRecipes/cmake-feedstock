#!/bin/bash

#
# This file sets some bash arrays you can either use or not use when you call CMake (>=3.14, conda-special)
#
# CONDA_CMAKE_SYS_ISOLATION
# CONDA_CMAKE_TOOLCHAIN
# CONDA_CMAKE_PLATFORM_FLAGS
# CONDA_CMAKE_DEBUG_BS_FLAGS
#
# But mostly you should just use:
#
# CONDA_CMAKE_DEFAULTS (CONDA_CMAKE_SYS_ISOLATION+CONDA_CMAKE_PLATFORM_FLAGS+CONDA_CMAKE_DEBUG_BS_FLAGS) always
# and ..
# CONDA_CMAKE_TOOLCHAIN when it does not cause breakage (it will improve isolation from the system and save time)

CONDA_CMAKE_DEFAULTS=("${CONDA_CMAKE_SYS_ISOLATION[@]}" "${CONDA_CMAKE_PLATFORM_FLAGS}" "${CONDA_CMAKE_DEBUG_FLAGS}")

function _get_sourced_dirname() {
    if [ -n "${BASH_SOURCE[0]}" ]; then
        dirname "${BASH_SOURCE[0]}"
    elif [ -n "${(%):-%x}" ]; then
        # in zsh use prompt-style expansion to introspect the same information
        # see http://stackoverflow.com/questions/9901210/bash-source0-equivalent-in-zsh
        dirname "${(%):-%x}"
    else
        echo "UNKNOWN DIR"
    fi
}

if [ -z ${CONDA_BUILD+x} ]; then
  # Figure out sensible defaults.
  if [ -z ${CONDA_SUBDIR+x} ]; then
    PSIZE=0
    if [ $(getconf LONG_BIT) = "64" ]; then
      PSIZE=64
    elif [ $(getconf LONG_BIT) = "32" ]; then
      PSIZE=32
    fi
    case "${OSTYPE}" in
      linux*) OTYPE=linux ;;
      darwin*) OTYPE=osx ;;
      msys*) OTYPE=win ;;
      *) OTYPE=unknown ;;
    esac
    target_platform=${OTYPE}-${PSIZE}
  else
    target_platform=${CONDA_SUBDIR}
  fi
fi

declare -a CONDA_CMAKE_SYS_ISOLATION
CONDA_CMAKE_SYS_ISOLATION+=(-DCMAKE_FIND_ROOT_PATH_INCLUDE=ONLY)
CONDA_CMAKE_SYS_ISOLATION+=(-DCMAKE_FIND_ROOT_PATH_LIBRARY=ONLY)
CONDA_CMAKE_SYS_ISOLATION+=(-DCMAKE_FIND_ROOT_PATH_PROGRAM=ONLY)
CONDA_CMAKE_SYS_ISOLATION+=(-DCMAKE_FIND_ROOT_PATH_PACKAGE=ONLY)

# Maybe? -DFIND_LIBRARY_USE_LIB64_PATHS=NO may present trouble for CDTs.
CONDA_CMAKE_SYS_ISOLATION+=(-DCMAKE_FIND_LIBRARY_CUSTOM_LIB_SUFFIX=)
CONDA_CMAKE_SYS_ISOLATION+=(-DFIND_LIBRARY_USE_LIB32_PATHS=NO)
CONDA_CMAKE_SYS_ISOLATION+=(-DFIND_LIBRARY_USE_LIB64_PATHS=NO)
CONDA_CMAKE_SYS_ISOLATION+=(-DFIND_LIBRARY_USE_LIBX32_PATHS=NO)

declare -a CONDA_CMAKE_TOOLCHAIN
CONDA_CMAKE_TOOLCHAIN=(-DCMAKE_TOOLCHAIN="$(_get_sourced_dirname)/conda-${target_platform}.toolchain.cmake")

# Platform Flags should not include -DCMAKE_TOOLCHAIN as using
# that will probably break a lot of things.
declare -a CONDA_CMAKE_PLATFORM_FLAGS
if [[ ${target_platform} == osx-64 ]]; then
  CONDA_CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT})
  # Do we want to try to orthogonalize the IDEs/generators from the platforms here?
  if [[ ${CMAKE_GENERATOR_NAME} == XCODE ]]; then
    CONDA_CMAKE_PLATFORM_FLAGS+=(-G'Xcode')
    CONDA_CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_ARCHITECTURES=x86_64)
  fi
fi

# BS == Build System, i.e. for debugging the build system itself, nothing to do with
# making debug builds.
declare -a CONDA_CMAKE_DEBUG_BS_FLAGS
CONDA_CMAKE_DEBUG_BS_FLAGS+=(--debug-output)
CONDA_CMAKE_DEBUG_BS_FLAGS+=(--debug-trycompile)
CONDA_CMAKE_DEBUG_BS_FLAGS+=(--debug-find)
CONDA_CMAKE_DEBUG_BS_FLAGS+=(-Wdev)

declare -a CONDA_CMAKE_DEFAULTS
CONDA_CMAKE_DEFAULTS=("${CONDA_CMAKE_SYS_ISOLATION[@]}" "${CONDA_CMAKE_PLATFORM_FLAGS[@]}")
CONDA_CMAKE_DEFAULTS+=(-DCMAKE_FIND_ROOT_PATH="${PREFIX}")
CONDA_CMAKE_DEFAULTS+=(-DCMAKE_INSTALL_RPATH="${PREFIX}/lib")
CONDA_CMAKE_DEFAULTS+=(-DCMAKE_INSTALL_PREFIX="${PREFIX}")

if [[ ${DEBUG_C} == yes ]]; then
  CONDA_CMAKE_DEFAULTS+=(-DCMAKE_BUILD_TYPE:STRING=Debug)
else
  CONDA_CMAKE_DEFAULTS+=(-DCMAKE_BUILD_TYPE:STRING=Release)
fi
