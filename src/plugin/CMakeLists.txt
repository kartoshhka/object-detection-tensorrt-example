#
# Copyright (c) 2019, NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
add_custom_target(plugin)

set(TARGET_NAME nvinfer_plugin)
set(SHARED_TARGET ${TARGET_NAME})

set(TARGET_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(PLUGIN_EXPORT_MAP ${TARGET_DIR}/exports.map)

if(${CMAKE_BUILD_TYPE} MATCHES "Debug")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
endif()

set(PLUGIN_SRCS)
set(PLUGIN_SOURCES)
set(CUDA_SRCS)
set(COMMON_SRCS)

set(PLUGIN_LISTS
    nmsPlugin
    gridAnchorPlugin
    flattenConcat
    )

include_directories(common common/kernels)
link_directories(${CMAKE_BINARY_DIR}/TensorRT-5.1.5.0/lib)

foreach(PLUGIN_ITER ${PLUGIN_LISTS})
    include_directories(${PLUGIN_ITER})
    add_subdirectory(${PLUGIN_ITER})
endforeach(PLUGIN_ITER)

# Add common
add_subdirectory(common)

################################## SHARED LIBRARY #######################################

cuda_add_library(${SHARED_TARGET} SHARED
    ${PLUGIN_SOURCES}
)

target_include_directories(${SHARED_TARGET}
    PUBLIC ${PROJECT_SOURCE_DIR}/include
    PUBLIC ${CUB_ROOT_DIR}
    PRIVATE ${PROJECT_SOURCE_DIR}/common
    PUBLIC ${CUDA_INSTALL_DIR}/include
    PRIVATE ${TARGET_DIR}
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../ThirdParty/cub
    PRIVATE ${CMAKE_BINARY_DIR}/TensorRT-5.1.5.0/include
)

set_target_properties(${SHARED_TARGET} PROPERTIES
    CXX_STANDARD "11"
    CXX_STANDARD_REQUIRED "YES"
    CXX_EXTENSIONS "NO"
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
)

set_property(TARGET ${SHARED_TARGET} PROPERTY CUDA_STANDARD 11)

target_link_libraries(${SHARED_TARGET}
    ${CUBLAS_LIB}
    ${CUDART_LIB}
    nvinfer
)

add_dependencies(${SHARED_TARGET} detectrt_tensorrt)

#########################################################################################

add_dependencies(plugin ${SHARED_TARGET})

