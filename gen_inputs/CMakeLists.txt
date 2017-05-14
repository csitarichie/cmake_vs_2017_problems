cmake_minimum_required(VERSION 3.2)
project(MsvsTestGeneratedLibs)

message(STATUS "Project name: ${PROJECT_NAME}")

msvs_test_gen_lib(${CMAKE_CURRENT_SOURCE_DIR}/a_lib)