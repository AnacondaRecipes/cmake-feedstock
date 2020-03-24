
if "%ARCH%"=="32" (set CPU_ARCH=x86) else (set CPU_ARCH=x64)
set PATH=%CD%\cmake-bin\cmake-%PKG_VERSION%-win%ARCH%-%CPU_ARCH%\bin;%PATH%
cmake --version

mkdir build && cd build

if "%PY_INTERP_DEBUG%" neq "" (
  set CMAKE_CONFIG="Debug"
) else (
  set CMAKE_CONFIG="Release"
)

dir /p %LIBRARY_PREFIX%\lib


cmake -LAH -G"NMake Makefiles JOM"                           ^
    -DCMAKE_BUILD_TYPE=%CMAKE_CONFIG%                        ^
    -DCMAKE_FIND_ROOT_PATH="%LIBRARY_PREFIX%"                ^
    -DCMAKE_PREFIX_PATH="%PREFIX%"                           ^
    -DCMAKE_CXX_STANDARD:STRING=17                           ^
    -DCMake_HAVE_CXX_MAKE_UNIQUE:INTERNAL=TRUE               ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ..\cmake
if errorlevel 1 exit 1

cmake --build . --config %CMAKE_CONFIG% --target install
if errorlevel 1 exit 1
