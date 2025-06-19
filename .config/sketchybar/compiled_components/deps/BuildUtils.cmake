#[=[
    Set boiler settings that exist in all projects and not just unique
    to the current project
#]=]
function(SET_BOILER_SETTINGS)
    # Set Langauge standards
    set(CMAKE_C_STANDARD 17)
    set(CMAKE_CXX_STANDARD 20)

    # Perform static analysis with clang-tidy if package is found
    find_program(CLANG_TIDY_EXE NAMES "clang-tidy")
    if(CLANG_TIDY_EXE)
        set(
            CLANG_TIDY_COMMAND
            "${CLANG_TIDY_EXE}"
            "-checks=-*,readability-*, -header-filter=.*" CACHE STRING "" FORCE
        )
    elseif(NOT CLANG_TIDY_EXE)
        message(WARNING "Clan-Tidy not found. Will not apply static analysis")
    endif()

    # Warn to user that clang-format is not installed
    find_program(CLANG-format_PATH clang-format)
    if(NOT CLANG-format_PATH)
        message(WARNING "No clang-format binary found. Will not auto-format.")
    endif()

endfunction()


#[=[
    Function applies the `.clang-tidy` format by calling clang-tidy if the
    binary is found.

    param target: Target name provided
#]=]
function(format target)
    find_program(CLANG-format_PATH clang-format)
    if(CLANG-format_PATH)

        # Create regex strings with the src and include dirs
        set(SRC_REGEX h hpp hh c cc cxx cpp)
        set(INCLUDE_REGEX h hpp hh c cc cxx cpp)
        list(TRANSFORM SRC_REGEX PREPEND "${PROJECT_SOURCE_DIR}/src/*.")
        list(TRANSFORM INCLUDE_REGEX PREPEND "${PROJECT_SOURCE_DIR}/include/*.")

        # Glob for the regex files
        file(GLOB_RECURSE SOURCE_FILES FOLLOW_SYMLINKS
                LIST_DIRECTORIES false ${SRC_REGEX} ${INCLUDE_REGEX}
                )

        # Apply clang-tidy to the source files
        add_custom_command(TARGET ${target} PRE_BUILD COMMAND
                ${CLANG-format_PATH} -i --style=file ${SOURCE_FILES}
                )
    endif()

endfunction()

#[=[
    Macro is used to set variables for compiler flags.
    Macros scope populates inside the scope of the caller
    -D_FORITIFY_SOURCE=2 : Detect runtime buffer overflow
    -fpie, -Wl,-pie : full ASLR
    -fpic -shared : Disable text relocations for shared libraries
#]=]
macro(set_compiler_flags)
    # base flags for detecting errors
    set(base_exceptions
            "-Wall"
            "-Wshadow"
            "-Wconversion"
            "-Wpedantic"
            "-Wformat"
            "-Wvla"
            "-Wfloat-equal"
            "-fpie"
            "-Wl,-pie"
            "-fPIC"
            )

    # Base flags for static analysis. Only enable sanitizers in Debug mode
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_CXX_COMPILER_ID MATCHES "GNU")
            set(base_static_analysis
                    "-fsanitize=address"
                    "-fno-omit-frame-pointer"
                    "-fsanitize=undefined"
                    "-fno-sanitize-recover=all"
                    "-fsanitize=float-divide-by-zero"
                    "-fsanitize=float-cast-overflow"
                    "-fno-sanitize=null"
                    "-fno-sanitize=alignment"
            )
        elseif(CMAKE_C_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
            set(base_static_analysis
                    "-fsanitize=address"
                    "-fno-omit-frame-pointer"
                    "-fsanitize=undefined"
                    "-fno-sanitize-recover=all"
            )
        endif()
    else()
        # No sanitizers for Release builds
        set(base_static_analysis "")
    endif()


    # Add debuging symbols if in debug mode
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(debug_flag "-g3")
    endif()

    # Create a base flags variable to be linked
    set(base_flags ${base_exceptions} ${base_static_analysis} ${debug_flag})
endmacro()


#[=[
    set_project_properties the include directory using the relocatable generator
    syntax which allows the --prefix syntax to be used without breaking where
    the header files are located. Additionally, the function sets the compiler
    flags for the target.

    Param target_name: Name of the target to apply the configurations to

    Param include_directory: Additional include directory that is not
    ${PROJECT_SOURCE_DIR}/include

    Param ARGN: Every other variable passed in will be used as targets
    to link
#]=]
function(set_project_properties target_name)
    # Check if first argument is an include directory (contains /)
    if(ARGC GREATER 1 AND "${ARGV1}" MATCHES "/")
        set(include_directory "${ARGV1}")
        # Rest of arguments are for linking (ARGV2, ARGV3, etc.)
        if(ARGC GREATER 2)
            list(SUBLIST ARGV 2 -1 link_libraries)
        else()
            set(link_libraries "")
        endif()
    else()
        set(include_directory "")
        # All arguments after target_name are for linking
        set(link_libraries ${ARGN})
    endif()

    # Run macro to get the variables set
    set_compiler_flags()
    format(${target_name})

    # Separates the area of concern when it comes to the
    # build files and the installation files by using
    # the build in generator expression for relocation
    if(include_directory)
        target_include_directories(
            ${target_name} PUBLIC
            "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
            "$<BUILD_INTERFACE:${include_directory}>"
            "$<INSTALL_INTERFACE:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>"
        )
    else()
        target_include_directories(
            ${target_name} PUBLIC
            "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
            "$<INSTALL_INTERFACE:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>"
        )
    endif()

    # set additional target properties to include flags for static analysis
    set_target_properties(
        ${target_name} PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
        COMPILE_OPTIONS "${base_flags}"
        LINK_OPTIONS "${base_static_analysis}"
        CXX_CLANG_TIDY "$CACHE{CLANG_TIDY_COMMAND}"
        C_CLANG_TIDY "$CACHE{CLANG_TIDY_COMMAND}"
    )
    if(link_libraries)
        target_link_libraries(${target_name} ${link_libraries})
    endif()

endfunction()

#[=[
    Run the rename script so that the host machine can utilize the
    compile_commands.json file that the docker container spits out.

    You should only have to add this to the main binary that is created
    so that it runs when that is complete.
#]=]
function(run_compile_commands_rename target_name)
    # After the build is complete, run the bash script
    # to modify compile_commands.json
    add_custom_target(modify_compile_commands ALL
        COMMAND ${CMAKE_COMMAND} -E echo "Modifying paths in compile_commands.json..."
        COMMAND bash ${CMAKE_SOURCE_DIR}/deps/compile_rename.sh ${CMAKE_BINARY_DIR}/compile_commands.json
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Running path modification script"
    )

    # Make sure the target runs after the build is complete
    add_dependencies(modify_compile_commands ${target_name})
endfunction()


#[=[
    GTest_add_target sets the build path and flags for the gtest executable
    and places the result in the ${CMAKE_BINARY_DIR}/test_bin for easy retrival
#]=]
function(GTest_add_target target_name)
    # Include populates the scope of the caller
    include(GoogleTest)

    # run the flags macro
    set_compiler_flags()

    # Set flags and set the output of the binaries to a the test_bin
    set_target_properties(
            ${target_name} PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/test_bin
            COMPILE_OPTIONS "${base_flags}"
            LINK_OPTIONS "${base_static_analysis}"
    )
    target_link_libraries(${target_name} PRIVATE gtest_main)
    gtest_discover_tests(${target_name})

endfunction()
