function(CMAKEJS_SETUP)

    find_program(NPM "npm" REQUIRED)
    message(VERBOSE "NPM found.")

    find_program(CMAKEJS "cmake-js")
    if(CMAKEJS)
        message(VERBOSE "CMakeJS found.")
    else(CMAKEJS)
        message(WARNING "CMakeJS not found, installing globally...")
        execute_process(COMMAND ${NPM} install -g cmake-js
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} 
            OUTPUT_VARIABLE CMAKEJS_INSTALL_OUTPUT)
        message(VERBOSE ${CMAKEJS_INSTALL_OUTPUT})
        message(STATUS "CMakeJS should now be installed.")
        find_program(CMAKEJS "cmake-js" REQUIRED)
    endif(CMAKEJS)

    function(GET_VARIABLE INPUT_STRING VARIABLE_TO_SELECT OUTPUT_VARIABLE)
        string(LENGTH ${INPUT_STRING} INPUT_STRING_LENGTH)
        set(SEPARATOR "\"")
        set(SEARCH_STRING "${VARIABLE_TO_SELECT}=${SEPARATOR}")
        string(LENGTH ${SEARCH_STRING} SEARCH_STRING_LENGTH)
        # string(REPLACE "\\\\" "\\" INPUT_STRING "${INPUT_STRING}")
        string(FIND ${INPUT_STRING} ${SEARCH_STRING} SEARCH_STRING_INDEX)
        if(SEARCH_STRING_INDEX EQUAL -1)
            set(SEPARATOR "'")
            set(SEARCH_STRING "${VARIABLE_TO_SELECT}=")
            string(LENGTH ${SEARCH_STRING} SEARCH_STRING_LENGTH)
            string(FIND ${INPUT_STRING} ${SEARCH_STRING} SEARCH_STRING_INDEX)
        endif()

        math(EXPR SEARCH_STRING_INDEX "${SEARCH_STRING_INDEX}+${SEARCH_STRING_LENGTH}")
        string(SUBSTRING ${INPUT_STRING} ${SEARCH_STRING_INDEX} ${INPUT_STRING_LENGTH} AFTER_SEARCH_STRING)
        string(FIND ${AFTER_SEARCH_STRING} ${SEPARATOR} SEPARATOR_INDEX)
        string(SUBSTRING ${AFTER_SEARCH_STRING} "0" ${SEPARATOR_INDEX} RESULT_STRING)
        set(${OUTPUT_VARIABLE} ${RESULT_STRING} PARENT_SCOPE)
    endfunction(GET_VARIABLE)

    if(WIN32)
        set(NPM "${NPM}.cmd")
        set(CMAKEJS "${CMAKEJS}.cmd")
    endif(WIN32)

    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(CMAKEJS_DEBUG_FLAGS "--debug")
    endif()
    
    execute_process(COMMAND ${CMAKEJS} print-configure ${CMAKEJS_DEBUG_FLAGS}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} 
        OUTPUT_VARIABLE CMAKE_JS_OUTPUT)

    message(VERBOSE ${CMAKE_JS_OUTPUT})

    foreach(VARIABLE IN ITEMS "CMAKE_JS_VERSION" "CMAKE_RUNTIME_OUTPUT_DIRECTORY" 
        "CMAKE_JS_INC" "CMAKE_JS_SRC" "NODE_RUNTIME" "NODE_RUNTIMEVERSION" "NODE_ARCH"
        "CMAKE_JS_LIB" "CMAKE_SHARED_LINKER_FLAGS")
        get_variable(${CMAKE_JS_OUTPUT} ${VARIABLE} ${VARIABLE})
        set(${VARIABLE} ${${VARIABLE}} PARENT_SCOPE)
    endforeach()

    message(STATUS "[CMakeJS] Setup build-in variables.")

endfunction(CMAKEJS_SETUP)

if(NOT CMAKE_JS_VERSION)
    cmakejs_setup()
endif()