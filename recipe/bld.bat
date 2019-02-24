set PATH=%CD%\official-binary\bin;%PATH%

mkdir build
pushd build

  set CMAKE_CONFIG="Release"

  dir /p %LIBRARY_PREFIX%\lib

  cmake -LAH -G"NMake Makefiles"                               ^
      -DCMAKE_BUILD_TYPE=%CMAKE_CONFIG%                        ^
      -DCMAKE_FIND_ROOT_PATH="%LIBRARY_PREFIX%"                ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ..
  if errorlevel 1 exit 1

  cmake --build . --config %CMAKE_CONFIG% --target install
  if errorlevel 1 exit 1
popd
