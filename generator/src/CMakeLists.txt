cmake_minimum_required(VERSION 3.2)
project(MsvsTestGenerator)

message(STATUS "Project name: ${PROJECT_NAME}")


get_filename_component(MSVS_TEST_GEN_EXE_PATH_LOCAL "." ABSOLUTE)
set(MSVS_TEST_GEN_EXE_PATH "${MSVS_TEST_GEN_EXE_PATH_LOCAL}" CACHE INTERNAL "MSVC_TEST code generator exe Path")

file(GLOB_RECURSE MSVS_TEST_GEN_EXE_SRCS_LOCAL "${CMAKE_CURRENT_SOURCE_DIR}/*.bat")
list(SORT MSVS_TEST_GEN_EXE_SRCS_LOCAL)
set(MSVS_TEST_GEN_EXE_SRCS ${MSVS_TEST_GEN_EXE_SRCS_LOCAL} CACHE INTERNAL "MSVS TEST generator soruce files")


function(msvs_test_gen_lib gen_src_dir)
    # get_filename_component(gen_src_dir "${gen_src_dir}" DIRECTORY)
    get_filename_component(gen_src_dir "${gen_src_dir}" ABSOLUTE)
    get_filename_component(MSVS_TEST_GEN_LIB_NAME "${gen_src_dir}" NAME)

    set(MSVS_TEST_GEN_TARGET_DIR "${CMAKE_CURRENT_BINARY_DIR}/${MSVS_TEST_GEN_LIB_NAME}")
    set(MSVS_TEST_GEN_LIB_STAMP "${MSVS_TEST_GEN_TARGET_DIR}/${MSVS_TEST_GEN_LIB_NAME}.stamp")

    file(MAKE_DIRECTORY "${MSVS_TEST_GEN_TARGET_DIR}")

    string(REGEX REPLACE "/" "\\\\" MSVS_TEST_GEN_EXE_PATH_WIN_PATH ${MSVS_TEST_GEN_EXE_PATH})
    string(REGEX REPLACE "/" "\\\\" MSVS_TEST_GEN_SRC_DIR_WIN_PATH ${gen_src_dir})
    string(REGEX REPLACE "/" "\\\\" MSVS_TEST_GEN_TARGET_DIR_WIN_PATH ${MSVS_TEST_GEN_TARGET_DIR})

    set(MSVS_TEST_GEN_COMMAND cmd.exe /c ${MSVS_TEST_GEN_EXE_PATH_WIN_PATH}\\generator.bat ${MSVS_TEST_GEN_LIB_NAME} ${MSVS_TEST_GEN_SRC_DIR_WIN_PATH} ${MSVS_TEST_GEN_TARGET_DIR_WIN_PATH})
    # message(STATUS "msvs_test_gen_lib: MSVS_TEST_GEN_COMMAND \"${MSVS_TEST_GEN_COMMAND}\" ")
   


    execute_process(
            COMMAND ${MSVS_TEST_GEN_COMMAND}
            COMMAND "${CMAKE_COMMAND}" -E touch "${MSVS_TEST_GEN_LIB_STAMP}"
            OUTPUT_VARIABLE  output
            RESULT_VARIABLE  result
    )
     message(STATUS "execute_process result:${result}")
     message(STATUS "execute_process output:${output}")

    file(
            GLOB MSVS_TEST_GEN_OUT_FILES
            "${MSVS_TEST_GEN_TARGET_DIR}/*.cpp"
            "${MSVS_TEST_GEN_TARGET_DIR}/*.hpp"
    )
    list(SORT MSVS_TEST_GEN_OUT_FILES)

        
    message(STATUS "lib:${MSVS_TEST_GEN_LIB_NAME} adding generated files:\"${MSVS_TEST_GEN_OUT_FILES}\"")

    file(GLOB MSVS_TEST_GEN_INPUT_FILES "${gen_src_dir}/*.gensrc")
    list(SORT MSVS_TEST_GEN_INPUT_FILES)

    add_custom_command(
            OUTPUT ${MSVS_TEST_GEN_LIB_STAMP}
            COMMAND "${CMAKE_COMMAND}" -E make_directory "${MSVS_TEST_GEN_TARGET_DIR}"
            COMMAND ${MSVS_TEST_GEN_COMMAND}
            COMMAND "${CMAKE_COMMAND}" -E touch ${MSVS_TEST_GEN_LIB_STAMP}
            DEPENDS  ${MSVS_TEST_GEN_INPUT_FILES} ${MSVS_TEST_GEN_EXE_SRCS}
            COMMENT "Generating MSVS Lib ${MSVS_TEST_GEN_LIB_NAME}"
            VERBATIM
    )

    set_source_files_properties(
            ${MSVS_TEST_GEN_OUT_FILES}
            PROPERTIES GENERATED TRUE
    )
    set_property(
            DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" APPEND PROPERTY
            ADDITIONAL_MAKE_CLEAN_FILES ${MSVS_TEST_GEN_OUT_FILES}
    )
    add_custom_target(GEN_MSVS_TEST_${MSVS_TEST_GEN_LIB_NAME}_LIB_SRC DEPENDS ${MSVS_TEST_GEN_LIB_STAMP})

    get_filename_component(MSVS_TEST_GEN_LIB_INC ${MSVS_TEST_GEN_TARGET_DIR}/../ ABSOLUTE)
    add_library(${MSVS_TEST_GEN_LIB_NAME} STATIC ${MSVS_TEST_GEN_OUT_FILES})
    add_dependencies(${MSVS_TEST_GEN_LIB_NAME} GEN_MSVS_TEST_${MSVS_TEST_GEN_LIB_NAME}_LIB_SRC)
    target_include_directories(
            ${MSVS_TEST_GEN_LIB_NAME}
            PRIVATE ${MSVS_TEST_GEN_LIB_INC}
            INTERFACE ${MSVS_TEST_GEN_LIB_INC}
    )
endfunction()
