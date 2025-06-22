/**
 *
 *   The Flow:
 *
 *  Sketchybar -> "I need CPU data" -> bootstrap_look_up("cpu_provider")
 *            -> macOS returns your port -> sketchybar sends to your port
 *            -> your receive loop gets message -> calls your handler
 *            -> handler calculates CPU -> sends data back to sketchybar
 **/

#include <cpu.h>
#include <sketchybar.h>
#include <utils.h>

struct cpu g_cpu;

static void cpu_init(struct cpu *cpu) {
    cpu->host          = mach_host_self();
    cpu->count         = HOST_CPU_LOAD_INFO_COUNT;
    cpu->has_prev_load = false;
    snprintf(cpu->command, 100, "");
}

static void cpu_update(struct cpu *cpu) {
    kern_return_t error = host_statistics(
        cpu->host, HOST_CPU_LOAD_INFO, (host_info_t)&cpu->load, &cpu->count);

    if (error != KERN_SUCCESS) {
        debug_print("%s", "Could not read cpu statistics\n");
        return;
    }

    if (cpu->has_prev_load) {
        uint32_t delta_user = cpu->load.cpu_ticks[CPU_STATE_USER]
                              - cpu->prev_load.cpu_ticks[CPU_STATE_USER];

        uint32_t delta_system = cpu->load.cpu_ticks[CPU_STATE_SYSTEM]
                                - cpu->prev_load.cpu_ticks[CPU_STATE_SYSTEM];

        uint32_t delta_idle = cpu->load.cpu_ticks[CPU_STATE_IDLE]
                              - cpu->prev_load.cpu_ticks[CPU_STATE_IDLE];

        double user_perc = (double)delta_user
                           / (double)(delta_system + delta_user + delta_idle);

        double sys_perc = (double)delta_system
                          / (double)(delta_system + delta_user + delta_idle);

        double total_perc = user_perc + sys_perc;

        FILE *file;
        char  line[1024];

        debug_print("%s", "Attemting to open TOPPTOC\n");
        file = popen(TOPPROC, "r");
        if (NULL == file) {
            debug_print("%s", "Error: TOPPROC command errored out...\n");
            return;
        }

        fgets(line, sizeof(line), file);
        fgets(line, sizeof(line), file);

        char    *start = strstr(line, FILTER_PATTERN);
        char     topproc[32];
        uint32_t caret = 0;
        for (int i = 0; i < sizeof(line); i++) {
            if (start && i == start - line) {
                i += 9;
                continue;
            }

            if (caret >= 28 && caret <= 30) {
                topproc[caret++] = '.';
                continue;
            }
            if (caret > 30)
                break;
            topproc[caret++] = line[i];
            if (line[i] == '\0')
                break;
        }

        topproc[31] = '\0';

        pclose(file);

        char color[16];
        if (total_perc >= .7) {
            snprintf(color, 16, "%s", getenv("RED"));
        } else if (total_perc >= .3) {
            snprintf(color, 16, "%s", getenv("ORANGE"));
        } else if (total_perc >= .1) {
            snprintf(color, 16, "%s", getenv("YELLOW"));
        } else {
            snprintf(color, 16, "%s", getenv("LABEL_COLOR"));
        }

        snprintf(cpu->command,
                 256,
                 "--push cpu.sys %.2f "
                 "--push cpu.user %.2f "
                 "--set cpu.percent label=%.0f%% label.color=%s "
                 "--set cpu.top label=\"%s\"",
                 sys_perc,
                 user_perc,
                 total_perc * 100.,
                 color,
                 topproc);
    } else {
        snprintf(cpu->command, 256, "");
    }

    cpu->prev_load     = cpu->load;
    cpu->has_prev_load = true;
}

void handler(env env) {
    debug_print("%s", "Executing handler callback...\n");

    // Environment variables passed from sketchybar can be accessed as seen
    // below
    char *name     = env_get_value_for_key(env, "NAME");
    char *sender   = env_get_value_for_key(env, "SENDER");
    char *info     = env_get_value_for_key(env, "INFO");
    char *selected = env_get_value_for_key(env, "SELECTED");

    if ((strcmp(sender, "routine") == 0) || (strcmp(sender, "forced") == 0)) {
        // CPU graph updates
        cpu_update(&g_cpu);

        if (strlen(g_cpu.command) > 0) {
            sketchybar(g_cpu.command);
        }
    }
}

int main(int argc, char **argv) {
    cpu_init(&g_cpu);

    if (argc < 2) {
        printf("Usage: provider \"<bootstrap name>\"\n");
        exit(1);
    }

    debug_print("Starting server with '%s'\n", argv[1]);
    event_server_begin(handler, argv[1]);
    return 0;
}
