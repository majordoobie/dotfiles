/**
 * @file clock.c
 * @brief Sketchybar clock component that displays formatted time
 *
 * This program creates a real-time clock display for sketchybar using CoreFoundation
 * timers. It updates every second with a user-specified time format.
 */

#include <CoreFoundation/CoreFoundation.h>
#include <sketchybar.h>
#include <stdlib.h>
#include <time.h>

#define TIME_BUFFER_SIZE 64   /**< Buffer size for formatted time string */
#define MESSAGE_EXTRA_SIZE 64 /**< Extra space for sketchybar command formatting */

typedef struct {
    char *item_name;
    char *item_format;
} clock_item_t;

/**
 * @brief Timer callback function that updates the clock display
 * @param timer The CoreFoundation timer (unused)
 * @param info User data containing pointer to clock_item_t struct
 *
 * This function is called every second by the CoreFoundation run loop timer.
 * It formats the current time using the format from the clock_item struct
 * and sends it to sketchybar to update the specified item.
 *
 * @note The format string should follow strftime() conventions
 * @example For "%H:%M:%S" format, displays "14:30:25"
 */
void callback(CFRunLoopTimerRef timer __attribute__((unused)), void *info) {
    clock_item_t *clock_item = (clock_item_t *) info;

    time_t current_time;
    time(&current_time);
    char buffer[TIME_BUFFER_SIZE];
    strftime(buffer, TIME_BUFFER_SIZE, clock_item->item_format, localtime(&current_time));

    // Use stack allocation instead of malloc for better performance
    char message[TIME_BUFFER_SIZE + MESSAGE_EXTRA_SIZE];
    snprintf(message, sizeof(message), "--set %s label=\"%s\"", clock_item->item_name, buffer);
    sketchybar(message);
}

/**
 * @brief Main function that sets up and runs the clock timer
 * @param argc Argument count (unused)
 * @param argv Argument vector - argv[1] should contain the time format string
 * @return int Exit status (0 for success, 1 for error)
 *
 * This function initializes a CoreFoundation timer that fires every second
 * and calls the callback function to update the clock display. The timer
 * runs indefinitely until the program is terminated.
 *
 * @param argv[1] Time format string following strftime() conventions
 *
 * @example
 * ./sketchybar_clock "%H:%M:%S"    // 24-hour format with seconds
 * ./sketchybar_clock "%I:%M %p"    // 12-hour format with AM/PM
 * ./sketchybar_clock "%a %b %d"    // Day, month, date
 *
 * @note The program will exit with status 1 if:
 *       - No format string is provided
 *       - Timer creation fails
 *       - Sketchybar is not running (handled by sketchybar() function)
 */
int main(int argc, char *argv[]) {
    // Check if format string is provided
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <item_name> <time_format>\n", argv[0]);
        return 1;
    }

    clock_item_t *clock_item = malloc(sizeof(clock_item_t));
    if (!clock_item) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }
    *clock_item = (clock_item_t) {.item_name = argv[1], .item_format = argv[2]};

    // Setup timer context with the clock_item as user data
    CFRunLoopTimerContext ctx = {.version = 0,
                                 .info = (void *) clock_item,
                                 .retain = NULL,  // if you were passing a CF type you'd use CFRetain
                                 .release = NULL, // and CFRelease here
                                 .copyDescription = NULL};

    // Create timer that fires after 1 second, then every 1 second thereafter
    CFAbsoluteTime start_time = CFAbsoluteTimeGetCurrent() + 1.0;
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, start_time, 1.0, 0, 0, callback, &ctx);

    if (!timer) {
        fprintf(stderr, "Failed to create timer\n");
        return 1;
    }

    // Add timer to the main run loop and start the event loop
    CFRunLoopAddTimer(CFRunLoopGetMain(), timer, kCFRunLoopDefaultMode);
    CFRunLoopRun();
    return 0;
}
