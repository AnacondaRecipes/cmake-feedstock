
if "%ARCH%"=="32" (set CPU_ARCH=x86) else (set CPU_ARCH=x64)
set PATH=%CD%\cmake-bin\bin;%PATH%
cmake --version

mkdir build || true
cd build

if "%PY_INTERP_DEBUG%" neq "" (
  set CMAKE_CONFIG="Debug"
) else (
  set CMAKE_CONFIG="Release"
)

dir /p %LIBRARY_PREFIX%\lib

cmake -LAH -G"NMake Makefiles"                               ^
    -DCMAKE_BUILD_TYPE=%CMAKE_CONFIG%                        ^
    -DCMAKE_FIND_ROOT_PATH="%LIBRARY_PREFIX%"                ^
    -DCMAKE_PREFIX_PATH="%PREFIX%"                           ^
    -DCMAKE_CXX_STANDARD:STRING=17                           ^
    -DCMake_HAVE_CXX_MAKE_UNIQUE:INTERNAL=TRUE               ^
    -DCMAKE_USE_SYSTEM_ZSTD=TRUE                             ^
    -DCMAKE_USE_SYSTEM_LIBUV=TRUE                            ^
    -DCMAKE_USE_SYSTEM_LIBLZMA=TRUE                          ^
    -DCMAKE_USE_SYSTEM_ZLIB=TRUE                             ^
    -DCMAKE_USE_SYSTEM_BZIP2=TRUE                            ^
    -DZLIB_LIBRARY="%LIBRARY_LIB%\zlib.lib"                  ^
    -DZLIB_INCLUDE_DIR="%LIBRARY_INC%"                       ^
    -DLIBLZMA_LIBRARY:FILEPATH="%LIBRARY_LIB%\liblzma.lib"   ^
    -DBZIP2_INCLUDE_DIR="%LIBRARY_INC%"                      ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ..
if errorlevel 1 exit 1

cmake --build . --config %CMAKE_CONFIG% --target install
if errorlevel 1 exit 1
