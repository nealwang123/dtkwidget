if (NOT TARGET Qt5::release)
    add_executable(Qt5::lrelease IMPORTED)
    set(imported_location "/usr/bin/lrelease")
    if (NOT EXISTS "${imported_location}")
        message(FATAL_ERROR "/usr/bin/lrelease does not exist. please install dependences qttools5-dev-tools.")
    endif()

    set_target_properties(Qt5::lrelease PROPERTIES
        IMPORTED_LOCATION ${imported_location}
    )
endif()

set(Qt5_LRELEASE_EXECUTABLE Qt5::lrelease)

function(DTK_CREATE_QM_FROM_TS QM_FILE_LIST)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs OPTIONS)
    cmake_parse_arguments(_LRELEASE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    set(LRELEASE_FILES ${_LRELEASE_UNPARSED_ARGUMENTS})

    dtk_add_translation(${QM_FILE_LIST} ${LRELEASE_FILES})
    set(${QM_FILE_LIST} ${${QM_FILE_LIST}} PARENT_SCOPE)
endfunction()

function(DTK_ADD_TRANSLATION _qm_files)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs OPTIONS)

    cmake_parse_arguments(_LRELEASE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    set(_lrelease_files ${_LRELEASE_UNPARSED_ARGUMENTS})

    foreach(_current_FILE ${_lrelease_files})
        get_filename_component(_abs_FILE ${_current_FILE} ABSOLUTE)
        get_filename_component(qm ${_abs_FILE} NAME)
        # everything before the last dot has to be considered the file name (including other dots)
        string(REGEX REPLACE "\\.[^.]*$" "" FILE_NAME ${qm})
        get_source_file_property(output_location ${_abs_FILE} OUTPUT_LOCATION)
        if(output_location)
            file(MAKE_DIRECTORY "${output_location}")
            set(qm "${output_location}/${FILE_NAME}.qm")
        else()
            set(qm "${CMAKE_CURRENT_BINARY_DIR}/${FILE_NAME}.qm")
        endif()

        add_custom_command(OUTPUT ${qm}
            COMMAND ${Qt5_LRELEASE_EXECUTABLE}
            ARGS ${_LRELEASE_OPTIONS} ${_abs_FILE} -qm ${qm}
            DEPENDS ${_abs_FILE} VERBATIM
        )
        list(APPEND ${_qm_files} ${qm})
    endforeach()
    set(${_qm_files} ${${_qm_files}} PARENT_SCOPE)
endfunction()

function(DTK_CREATE_RCC_FILES FILE_LIST)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs OPTIONS)
    cmake_parse_arguments(_RCCGEN "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    set(RCCGEN_FILES ${_RCCGEN_UNPARSED_ARGUMENTS})

    set(RCC_FILES_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/qm_files.qrc)
    file(WRITE ${RCC_FILES_OUTPUT_PATH} "<RCC>\n    <qresource prefix=\"/dtk/translations\">\n")
    foreach(RCC_FILE_PATH ${RCCGEN_FILES})
        get_filename_component(FILE_NAME_NO_SUFFIX ${RCC_FILE_PATH} NAME_WE)
        file(APPEND ${RCC_FILES_OUTPUT_PATH} "        <file>${FILE_NAME_NO_SUFFIX}.qm</file>\n")
    endforeach()
    file(APPEND ${RCC_FILES_OUTPUT_PATH} "    </qresource>\n</RCC>")
    set(${FILE_LIST} ${RCC_FILES_OUTPUT_PATH} PARENT_SCOPE)
endfunction()
