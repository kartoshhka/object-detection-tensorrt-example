cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

project(detectrt)

find_package(CUDA REQUIRED)

set(CUDA_NVCC_FLAGS "-std=c++11;${CUDA_NVCC_FLAGS}")

# First, untar TensorRT
add_custom_target(${PROJECT_NAME}_tensorrt
	DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/TensorRT-5.1.5.0")
add_custom_command(
	OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/TensorRT-5.1.5.0"
	COMMAND ${CMAKE_COMMAND} -E tar xzf ${CMAKE_CURRENT_SOURCE_DIR}/TensorRT-5.1.5.0.tar.gz
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	COMMENT "Unpacking TensorRT SDK")

# Create Python virtual environment and install
# the required packages into it
add_custom_target(${PROJECT_NAME}_python
	DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/bin/wrapper" "${CMAKE_CURRENT_BINARY_DIR}/bin/activate"
	"${CMAKE_CURRENT_BINARY_DIR}/detectrt.py" "${CMAKE_CURRENT_BINARY_DIR}/detectrt" "${CMAKE_CURRENT_BINARY_DIR}/utils")
add_custom_command(
	OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/bin/wrapper"
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/wrapper" "${CMAKE_CURRENT_BINARY_DIR}/bin/wrapper"
	COMMENT "Copying Python environment sourcing wrapper")
add_custom_command(
	OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/bin/activate"
	COMMAND python3 -m venv .
	COMMAND "${CMAKE_CURRENT_BINARY_DIR}/bin/wrapper"
		pip3 install wheel opencv-python numpy Pillow pycuda requests tensorflow==1.12.0
	COMMAND "${CMAKE_CURRENT_BINARY_DIR}/bin/wrapper"
		pip3 install "${CMAKE_CURRENT_BINARY_DIR}/TensorRT-5.1.5.0/python/tensorrt-5.1.5.0-cp35-none-linux_x86_64.whl"
	COMMAND "${CMAKE_CURRENT_BINARY_DIR}/bin/wrapper"
		pip3 install "${CMAKE_CURRENT_BINARY_DIR}/TensorRT-5.1.5.0/python/graphsurgeon-0.4.1-py2.py3-none-any.whl"
	COMMAND "${CMAKE_CURRENT_BINARY_DIR}/bin/wrapper"
		pip3 install "${CMAKE_CURRENT_BINARY_DIR}/TensorRT-5.1.5.0/python/uff-0.6.3-py2.py3-none-any.whl"
	DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/bin/wrapper" "${CMAKE_CURRENT_BINARY_DIR}/TensorRT-5.1.5.0"
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	COMMENT "Creating Python virtual environment")

# Compile plugins
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/plugin")

# Copy python scripts
add_custom_command(
	OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/detectrt.py"
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/src/detectrt.py" "${CMAKE_CURRENT_BINARY_DIR}/detectrt.py"
	DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/detectrt.py"
	COMMENT "Copying detectrt.py")
add_custom_command(
	OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/detectrt"
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/src/detectrt" "${CMAKE_CURRENT_BINARY_DIR}/detectrt"
	DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/detectrt"
	COMMENT "Copying detectrt")
add_custom_command(
	OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/utils"
	COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_CURRENT_SOURCE_DIR}/src/utils" "${CMAKE_CURRENT_BINARY_DIR}/utils"
	DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/utils"
	COMMENT "Copying utils")

