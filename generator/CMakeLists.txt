cmake_minimum_required(VERSION 3.2)
project(MsvsTestGenerator)


# version of FadacCore
SET( LIBMSVSTESTGEN_MAJOR_VERSION 0 )
SET( LIBMSVSTESTGEN_MINOR_VERSION 0 )
SET( LIBMSVSTESTGEN_PATCH_VERSION 1 )

message(STATUS "Project name: ${PROJECT_NAME}")

set(COMPONENT_VERSION ${LIBMSVSTESTGEN_MAJOR_VERSION}.${LIBMSVSTESTGEN_MINOR_VERSION}.${LIBMSVSTESTGEN_PATCH_VERSION})

set(PACKAGE_VERSION "${COMPONENT_VERSION}") # used in *.cmake.in
message(STATUS "This is CMake for MsvsTest Generator Version ${COMPONENT_VERSION}.")

add_subdirectory(test)
add_subdirectory(src)