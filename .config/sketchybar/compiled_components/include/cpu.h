#include <mach/mach.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

static const char TOPPROC[32] = {"/bin/ps -Aceo pid,pcpu,comm -r"};
static const char FILTER_PATTERN[16] = {"com.apple."};

struct cpu {
    host_t host;
    mach_msg_type_number_t count;
    host_cpu_load_info_data_t load;
    host_cpu_load_info_data_t prev_load;
    bool has_prev_load;

    char command[256];
};
