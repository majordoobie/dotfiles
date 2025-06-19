include(BuildUtils)

# Create sketchybar shared library
add_library(sketchybar_comms SHARED sketchybar.c)
set_project_properties(sketchybar_comms)

# Clock component
add_executable(sketchybar_clock clock.c)
set_project_properties(
    sketchybar_clock
    sketchybar_comms
    ${COREFOUNDATION_LIBRARY}
)

# CPU component
add_executable(sketchybar_cpu cpu.c)
set_project_properties(
    sketchybar_cpu
    sketchybar_comms
)
