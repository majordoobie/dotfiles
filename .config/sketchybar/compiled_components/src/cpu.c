/**
 * @file cpu.c
 * @brief Simple CPU monitor for sketchybar using mach_helper approach
 *
 * This program calculates CPU usage and outputs sketchybar commands.
 * It's designed to be called periodically by sketchybar as a mach_helper.
 */

#include <cpu.h>
#include <sketchybar.h>

/**
 * @brief Main function - calculates CPU usage and outputs commands
 * @return int Exit status (0 for success)
 *
 * This program runs once, calculates CPU usage, and outputs the appropriate
 * sketchybar commands. Sketchybar will call this program periodically based
 * on the update_freq setting.
 *
 * @note On first run, no output is produced since we need previous CPU
 *       measurements to calculate usage percentages.
 */
int main(void) {
    struct cpu g_cpu;

    // Initialize CPU monitoring
    cpu_init(&g_cpu);

    // Update CPU statistics
    cpu_update(&g_cpu);

    // Output sketchybar commands if we have valid data
    if (strlen(g_cpu.command) > 0) {
        printf("%s\n", g_cpu.command);
    }

    return 0;
}
