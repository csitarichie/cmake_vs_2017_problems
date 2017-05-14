cmake_minimum_required(VERSION 3.2)
project(MsvsTestCtests)

include(ctest)

message(STATUS "Project name: ${PROJECT_NAME}")


function( msvs_test_builTest test_name test_src_dir)
    
    file(GLOB MSVS_TEST_SRC "${test_src_dir}/*.cpp")
    
    add_executable(${test_name} ${MSVS_TEST_SRC})

    include(${test_src_dir}/test.cmake)

    foreach(MSVS_REQURED_LIB ${MSVS_REQURED_LIBS})
        message(STATUS "msvs_test_builTest:${test_name} adding dep:${MSVS_REQURED_LIB}")
        add_dependencies(${test_name} ${MSVS_REQURED_LIB})
        target_link_libraries(${test_name} ${MSVS_REQURED_LIB})
    endforeach()
endfunction()

file(GLOB MSVS_TEST_GEN_TEST_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/*)
foreach(MSVS_TEST_GEN_TEST_DIR ${MSVS_TEST_GEN_TEST_DIRS})
    if(IS_DIRECTORY ${MSVS_TEST_GEN_TEST_DIR})
        get_filename_component(MSVS_GEN_TEST_NAME ${MSVS_TEST_GEN_TEST_DIR} NAME)
        set(MSVS_GEN_TEST_TARGET_DIR ${CMAKE_CURRENT_BINARY_DIR}/${MSVS_GEN_TEST_NAME})
        set(MSVS_GEN_TEST_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${MSVS_GEN_TEST_NAME})
        set(MSVS_GEN_TEST_RUN_SCRIPT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
        file(MAKE_DIRECTORY ${MSVS_GEN_TEST_TARGET_DIR})
        
        message(STATUS "${PROJECT_NAME}: creating test ${MSVS_GEN_TEST_NAME}")
        
        msvs_test_builTest(${MSVS_GEN_TEST_NAME} ${MSVS_GEN_TEST_SOURCE_DIR})

        set(MSVS_TEST_CTEST_EXE_PATH ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE})
        string(REGEX REPLACE "/" "\\\\" MSVS_TEST_CTEST_EXE_PATH ${MSVS_TEST_CTEST_EXE_PATH})

        set(MSVS_TEST_SCRIPT run_test.bat)
        configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${MSVS_TEST_SCRIPT}.in ${MSVS_GEN_TEST_TARGET_DIR}/${MSVS_TEST_SCRIPT} @ONLY)
        add_test(NAME ${MSVS_GEN_TEST_NAME}
                 COMMAND ${MSVS_GEN_TEST_TARGET_DIR}/${MSVS_TEST_SCRIPT}
                 WORKING_DIRECTORY ${MSVS_GEN_TEST_SOURCE_DIR})
    endif()
endforeach()