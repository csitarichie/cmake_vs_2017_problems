cmake_minimum_required(VERSION 3.2)
project(MsvsTestGeneratedLibs)

message(STATUS "Project name: ${PROJECT_NAME}")

function(check_and_generate_with_dep lib_dir)

    get_filename_component(lib_dir "${lib_dir}" ABSOLUTE)
    include(${lib_dir}/gen.cmake)
    get_filename_component(MSVS_TEST_LIB_NAME_TO_GEN "${lib_dir}" NAME)
    
    # first generating dependencies if they not allready done
    foreach(MSVS_TEST_LIB_DEP ${MSVS_REQURED_GEN_LIBS})
        if(NOT TARGET ${MSVS_TEST_LIB_DEP})
                check_and_generate_with_dep(${CMAKE_CURRENT_SOURCE_DIR}/${MSVS_TEST_LIB_DEP})
        endif()
    endforeach()
    
    # generating lib 
    if(NOT TARGET ${MSVS_TEST_LIB_NAME_TO_GEN})
        msvs_test_gen_lib(${lib_dir})
        # adding dependent lib to generated lib depency.
        foreach(MSVS_TEST_LIB_DEP ${MSVS_REQURED_GEN_LIBS})
            message(STATUS "check_and_generate_with_dep:${MSVS_TEST_LIB_NAME_TO_GEN} adding dep:${MSVS_TEST_LIB_DEP}")
            add_dependencies(${MSVS_TEST_LIB_NAME_TO_GEN} ${MSVS_TEST_LIB_DEP})
            target_link_libraries(${MSVS_TEST_LIB_NAME_TO_GEN} ${MSVS_TEST_LIB_DEP})
        endforeach()
    endif()
    
endfunction()

file(GLOB MSVS_TEST_GEN_SRC_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/*)
foreach(MSVS_TEST_GEN_SRC_DIR ${MSVS_TEST_GEN_SRC_DIRS})
    if(IS_DIRECTORY ${MSVS_TEST_GEN_SRC_DIR})
        check_and_generate_with_dep(${MSVS_TEST_GEN_SRC_DIR})
    endif()
endforeach()