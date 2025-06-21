#pragma once

/*!
 * DEBUG_PRINT - Used to print debugging statements to stderr only when
 * the release mode is set to debug
 *
 * DEBUG_STATIC - Used to make static functions public when the release
 * mode is in debug. The purpose is to be able to unit test functions
 * that are meant to be private.
 */
#ifdef NDEBUG
#define DEBUG_PRINT 0
#define DEBUG_STATIC static
#else
#define DEBUG_PRINT 1
#define DEBUG_STATIC
#endif // End of DEBUG_PRINT

#include <errno.h>
#include <stdio.h>

/*
 * Enable printing debug messages when in debug mode. To print a non text
 * replacement you have to use debug_print("%s\n", "My text") otherwise
 * it is used just like any other printf variant
 * debug_print("My test %s\n", "more text");
 *
 * The debug_print_err adds the file and line number to the output for more
 * information when wanting to debug.
 */
#define debug_print_err(fmt, ...)                                                                                      \
    do {                                                                                                               \
        if (DEBUG_PRINT)                                                                                               \
            fprintf(stderr, "%s:%d:%s(): " fmt, __FILE__, __LINE__, __func__, __VA_ARGS__);                            \
    } while (0)

#define debug_print(fmt, ...)                                                                                          \
    do {                                                                                                               \
        if (DEBUG_PRINT)                                                                                               \
            fprintf(stderr, fmt, __VA_ARGS__);                                                                         \
    } while (0)
