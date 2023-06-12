set(FILE_NAME "LICENSE.txt")
set(DOWNLOAD_URL "https://raw.githubusercontent.com/conda-forge/cmake-feedstock/master/${FILE_NAME}")
set(EXPECTED_SHA256 "86dc4bc79c9fa4d5dc3ae5558441d5bb8b8736403e70997cf9ae8f671ab5d0ca")

file(DOWNLOAD ${DOWNLOAD_URL} ${CMAKE_CURRENT_BINARY_DIR}/${FILE_NAME}
 SHOW_PROGRESS
 EXPECTED_HASH  SHA256=${EXPECTED_SHA256}
 STATUS STATUS
 TLS_VERIFY on )

list( GET STATUS 0 RET )
list( GET STATUS 1 MESSAGE )

if( NOT RET EQUAL 0 )
  message(FATAL "Error Downloading file: ${MESSAGE}")
endif()
