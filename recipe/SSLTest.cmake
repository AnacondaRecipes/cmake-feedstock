set(FILE_NAME "LICENSE.txt")
set(DOWNLOAD_URL "https://raw.githubusercontent.com/conda-forge/cmake-feedstock/master/${FILE_NAME}")
set(EXPECTED_SHA256 "b76585ad68860b271fc4c5a346444e4a70cacd48a3fd688cb2e8dd18d5935cd1")

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
