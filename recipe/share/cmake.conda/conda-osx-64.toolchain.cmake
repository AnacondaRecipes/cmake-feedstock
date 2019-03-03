set(CMAKE_SYSTEM_NAME Darwin)
# It is unclear what value to pass here in the general case, ONLY or NEVER.
# We are controlling whether we search in ${CMAKE_FIND_ROOT_PATH}+dir ONLY
# or NEVER. I think CMAKE_SYSROOT is also considered a ROOT_PATH for this.
# We do not use CMAKE_FIND_ROOT_PATH nor CMAKE_SYSROOT though!
set(CMAKE_FIND_ROOT_PATH_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_PROGRAM ONLY)
set(CMAKE_FIND_ROOT_PATH_PACKAGE ONLY)
set(CMAKE_SYSTEM_APPBUNDLE_PATH)
