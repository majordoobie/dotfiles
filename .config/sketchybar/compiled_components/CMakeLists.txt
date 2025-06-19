cmake_minimum_required(VERSION 3.29)
set(CMAKE_C_COMPILER /usr/bin/gcc)
set(CMAKE_CXX_COMPILER /usr/bin/g++)

# Generates the compile_commands.json for clangd to perform lsp operations
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(sketchy_helper VERSION 1.0 LANGUAGES C CXX)

set(CMAKE_VERBOSE_MAKEFILE OFF)
# Add the cmake modules directory to call functions in them
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/deps")

# Set boiler settings
include(BuildUtils)
set_boiler_settings()

# Find CoreFoundation framework
find_library(COREFOUNDATION_LIBRARY CoreFoundation)
if(NOT COREFOUNDATION_LIBRARY)
    message(FATAL_ERROR "CoreFoundation framework not found")
endif()


add_subdirectory(src)

