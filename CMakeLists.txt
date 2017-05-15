cmake_minimum_required(VERSION 3.2)
project(MsvsTestMain)

set(CMAKE_CXX_STANDARD 14)

message(STATUS "Project name: ${PROJECT_NAME}")

enable_testing()

add_subdirectory(libs)
add_subdirectory(generator)
add_subdirectory(gen_inputs)
