/**
 * @file sketchybar.h
 * @brief API for creating custom C modules that communicate with sketchybar
 * @author Felix Kratz (sketchybar creator)
 *
 * This header provides the necessary functionality for C modules to send
 * commands to sketchybar via macOS Mach messaging system.
 */

#pragma once

#include <bootstrap.h>
#include <mach/arm/kern_return.h>
#include <mach/mach.h>
#include <mach/mach_port.h>
#include <mach/message.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

/** @brief Environment variable type alias */
typedef char *env;

/** @brief Macro to define a Mach message handler function */
#define MACH_HANDLER(name) void name(env env)
/** @brief Function pointer type for Mach message handlers */
typedef MACH_HANDLER(mach_handler);

/**
 * @brief Structure representing a Mach message for sketchybar communication
 */
struct mach_message {
  mach_msg_header_t header;              /**< Message header */
  mach_msg_size_t msgh_descriptor_count; /**< Number of descriptors */
  mach_msg_ool_descriptor_t descriptor;  /**< Out-of-line data descriptor */
};

/**
 * @brief Buffer structure containing message and trailer
 */
struct mach_buffer {
  struct mach_message message; /**< The actual message */
  mach_msg_trailer_t trailer;  /**< Message trailer */
};

/**
 * @brief Retrieves the bootstrap port for sketchybar communication
 * @return mach_port_t The bootstrap port, or 0 if not found
 *
 * This function discovers sketchybar's Mach port by looking up the service
 * name "git.felix.sketchybar" (or custom name from BAR_NAME environment
 * variable) in the bootstrap namespace.
 */
mach_port_t mach_get_bs_port(void);

/**
 * @brief Sends a message to sketchybar via Mach messaging
 * @param port The Mach port to send the message to
 * @param message The message string to send
 * @param len The length of the message
 * @return bool True if message was sent successfully, false otherwise
 *
 * This function constructs a Mach message with the provided string data
 * and sends it to the specified port using out-of-line descriptors.
 */
bool mach_send_message(mach_port_t port, char *message, uint32_t len);

/**
 * @brief Formats a command string for sketchybar by converting spaces to null
 * terminators
 * @param message The input command string
 * @param formatted_message Buffer to store the formatted message
 * @return uint32_t The length of the formatted message
 *
 * This function converts a space-separated command string into a
 * null-terminated argument array format that sketchybar expects. It handles
 * quoted strings by preserving spaces within quotes.
 *
 * @note This implementation is not robust according to the original author's
 * comment
 */
uint32_t format_message(char *message, char *formatted_message);

/**
 * @brief Main API function to send commands to sketchybar
 * @param message The command string to send (e.g., "--set myitem label=Hello")
 *
 * This is the primary function that C modules use to communicate with
 * sketchybar. It formats the message, establishes a connection if needed, and
 * sends the command. If sketchybar is not running, the program will exit.
 *
 * @example
 * sketchybar("--set clock label=12:34");
 * sketchybar("--add item myitem left");
 */
void sketchybar(char *message);
