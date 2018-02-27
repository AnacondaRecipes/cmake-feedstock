REM Move only desired files as the downloaded package contains even Qt5 dlls
move bin\cmake.exe %LIBRARY_BIN%\
if errorlevel 1 exit 1
move bin\cmcldeps.exe %LIBRARY_BIN%\
if errorlevel 1 exit 1
move bin\cpack.exe %LIBRARY_BIN%\
if errorlevel 1 exit 1
move bin\ctest.exe %LIBRARY_BIN%\
if errorlevel 1 exit 1

move share %LIBRARY_PREFIX%\
if errorlevel 1 exit 1
