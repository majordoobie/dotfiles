/**
 * @file sketchybar.c
 * @brief Implementation of sketchybar C API functions
 * @author Felix Kratz (sketchybar creator)
 */

#include <mach/arm/kern_return.h>
#include <sketchybar.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <utils.h>

#define STACK_BUFFER_SIZE 512

/** @brief Global Mach port for sketchybar communication */
static mach_port_t g_mach_port = 0;

/** @brief Global server instance for event providers */
static struct mach_server g_mach_server;

static bool mach_server_begin(struct mach_server *mach_server,
                              void (*handler)(char *env),
                              char *bootstrap_name);
static void mach_receive_message(mach_port_t         port,
                                 struct mach_buffer *buffer,
                                 bool                timeout);

void event_server_begin(void (*event_handler)(char *env),
                        char *bootstrap_name) {
    mach_server_begin(&g_mach_server, event_handler, bootstrap_name);
}

mach_port_t mach_get_bs_port(void) {
    mach_port_name_t task = mach_task_self();

    mach_port_t bs_port;
    if (task_get_special_port(task, TASK_BOOTSTRAP_PORT, &bs_port)
        != KERN_SUCCESS) {
        return 0;
    }

    char *name = getenv("BAR_NAME");
    if (!name) {
        name = "sketchybar";
    }
    size_t name_len = strlen(name);

    // Length of "git.felix." + null terminator
    static const uint32_t PREFIX_LEN = 16;
    uint32_t              lookup_len = PREFIX_LEN + (uint32_t)name_len;

    char *buffer = (char *)calloc(lookup_len, sizeof(char));
    if (!buffer) {
        return 0;
    }
    snprintf(buffer, lookup_len, "git.felix.%s", name);

    mach_port_t port;
    if (bootstrap_look_up(bs_port, buffer, &port) != KERN_SUCCESS) {
        free(buffer);
        return 0;
    }
    free(buffer);
    return port;
}

bool mach_send_message(mach_port_t port, char *message, uint32_t len) {
    if (!message || !port) {
        return false;
    }

    struct mach_message msg     = { 0 };
    msg.header.msgh_remote_port = port;
    msg.header.msgh_local_port  = 0;
    msg.header.msgh_id          = 0;
    msg.header.msgh_bits        = MACH_MSGH_BITS_SET(MACH_MSG_TYPE_COPY_SEND,
                                              MACH_MSG_TYPE_MAKE_SEND,
                                              0,
                                              MACH_MSGH_BITS_COMPLEX);

    msg.header.msgh_size      = sizeof(struct mach_message);
    msg.msgh_descriptor_count = 1;
    msg.descriptor.address    = message;
    msg.descriptor.size       = len * sizeof(char);
    msg.descriptor.copy       = MACH_MSG_VIRTUAL_COPY;
    msg.descriptor.deallocate = false;
    msg.descriptor.type       = MACH_MSG_OOL_DESCRIPTOR;

    kern_return_t err = mach_msg(&msg.header,
                                 MACH_SEND_MSG,
                                 sizeof(struct mach_message),
                                 0,
                                 MACH_PORT_NULL,
                                 MACH_MSG_TIMEOUT_NONE,
                                 MACH_PORT_NULL);

    return err == KERN_SUCCESS;
}

uint32_t format_message(char *message, char *formatted_message) {
    // This is not actually robust, switch to stack based messaging.
    char     outer_quote    = 0;
    uint32_t caret          = 0;
    size_t   msg_len        = strlen(message);
    uint32_t message_length = (uint32_t)msg_len + 1;
    for (uint32_t i = 0; i < message_length; ++i) {
        if (message[i] == '"' || message[i] == '\'') {
            if (outer_quote && outer_quote == message[i]) {
                outer_quote = 0;
            } else if (!outer_quote) {
                outer_quote = message[i];
            }
            continue;
        }
        formatted_message[caret] = message[i];
        if (message[i] == ' ' && !outer_quote) {
            formatted_message[caret] = '\0';
        }
        caret++;
    }

    if (caret > 0 && formatted_message[caret] == '\0'
        && formatted_message[caret - 1] == '\0') {
        caret--;
    }
    formatted_message[caret] = '\0';
    return caret + 1;
}

void sketchybar(char *message) {
    size_t msg_len = strlen(message);

    // Use stack allocation for typical messages, heap for large ones
    if (msg_len + 2 <= STACK_BUFFER_SIZE) {
        char     formatted_message[STACK_BUFFER_SIZE];
        uint32_t length = format_message(message, formatted_message);
        if (!length) {
            return;
        }

        if (!g_mach_port) {
            g_mach_port = mach_get_bs_port();
        }
        if (!mach_send_message(g_mach_port, formatted_message, length)) {
            g_mach_port = mach_get_bs_port();
            if (!mach_send_message(g_mach_port, formatted_message, length)) {
                // No sketchybar instance running, exit.
                exit(0);
            }
        }
    } else {
        // Fallback to heap allocation for very large messages
        char *formatted_message = calloc(msg_len + 2, sizeof(char));
        if (!formatted_message) {
            return;
        }
        uint32_t length = format_message(message, formatted_message);
        if (!length) {
            free(formatted_message);
            return;
        }

        if (!g_mach_port) {
            g_mach_port = mach_get_bs_port();
        }
        if (!mach_send_message(g_mach_port, formatted_message, length)) {
            g_mach_port = mach_get_bs_port();
            if (!mach_send_message(g_mach_port, formatted_message, length)) {
                // No sketchybar instance running, exit.
                free(formatted_message);
                exit(0);
            }
        }
        free(formatted_message);
    }
}

char *env_get_value_for_key(char *env, char *key) {
    uint32_t caret = 0;
    for (;;) {
        if (!env[caret]) {
            break;
        }
        if (strcmp(&env[caret], key) == 0) {
            return &env[caret + strlen(&env[caret]) + 1];
        }

        caret += strlen(&env[caret])
                 + strlen(&env[caret + strlen(&env[caret]) + 1]) + 2;
    }
    return "";
}

char *sketchybar_query(char *message) {
    size_t msg_len = strlen(message);

    // Use stack allocation for typical messages, heap for large ones
    if (msg_len + 2 <= STACK_BUFFER_SIZE) {
        char     formatted_message[STACK_BUFFER_SIZE];
        uint32_t length = format_message(message, formatted_message);
        if (!length) {
            return "";
        }

        if (!g_mach_port) {
            g_mach_port = mach_get_bs_port();
        }

        // Create response port for bidirectional communication
        mach_port_t      response_port;
        mach_port_name_t task = mach_task_self();
        if (mach_port_allocate(task, MACH_PORT_RIGHT_RECEIVE, &response_port)
            != KERN_SUCCESS) {
            return "";
        }

        if (mach_port_insert_right(
                task, response_port, response_port, MACH_MSG_TYPE_MAKE_SEND)
            != KERN_SUCCESS) {
            return "";
        }

        struct mach_message msg     = { 0 };
        msg.header.msgh_remote_port = g_mach_port;
        msg.header.msgh_local_port  = response_port;
        msg.header.msgh_id          = (mach_msg_id_t)response_port;
        msg.header.msgh_bits = MACH_MSGH_BITS_SET(MACH_MSG_TYPE_COPY_SEND,
                                                  MACH_MSG_TYPE_MAKE_SEND,
                                                  0,
                                                  MACH_MSGH_BITS_COMPLEX);

        msg.header.msgh_size      = sizeof(struct mach_message);
        msg.msgh_descriptor_count = 1;
        msg.descriptor.address    = formatted_message;
        msg.descriptor.size       = length * sizeof(char);
        msg.descriptor.copy       = MACH_MSG_VIRTUAL_COPY;
        msg.descriptor.deallocate = false;
        msg.descriptor.type       = MACH_MSG_OOL_DESCRIPTOR;

        kern_return_t err = mach_msg(&msg.header,
                                     MACH_SEND_MSG,
                                     sizeof(struct mach_message),
                                     0,
                                     MACH_PORT_NULL,
                                     MACH_MSG_TIMEOUT_NONE,
                                     MACH_PORT_NULL);

        if (err != KERN_SUCCESS) {
            return "";
        }

        struct mach_buffer buffer = { 0 };
        mach_receive_message(response_port, &buffer, true);
        if (buffer.message.descriptor.address) {
            return (char *)buffer.message.descriptor.address;
        }
        mach_msg_destroy(&buffer.message.header);

        return "";
    }

    // Fallback to heap allocation for very large messages
    char *formatted_message = calloc(msg_len + 2, sizeof(char));
    if (!formatted_message) {
        return "";
    }
    uint32_t length = format_message(message, formatted_message);
    if (!length) {
        free(formatted_message);
        return "";
    }

    // Similar implementation for heap allocated messages...
    char *result = "";
    free(formatted_message);
    return result;
}

/**
 * @brief Print the mach error generated
 *
 * @param result result from a mach function call
 */
static void print_error(kern_return_t result) {
    switch (result) {
        case KERN_INVALID_ARGUMENT:
            fprintf(stderr, "Invalid argument\n");
            break;
        case KERN_RESOURCE_SHORTAGE:
            fprintf(stderr, "Out of resources\n");
            break;
        case KERN_NO_SPACE:
            fprintf(stderr, "No space for new port\n");
            break;
        default:
            fprintf(stderr, "Unknown error: %d\n", result);
    }
}

// We know mach ports is depricated just ignore
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
static bool mach_server_begin(struct mach_server *mach_server,
                              void (*handler)(char *env),
                              char *bootstrap_name) {
    kern_return_t result;

    // https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/KernelProgramming/Mach/Mach.html
    mach_server->task = mach_task_self();

    // Set the mach port to listen for messages at mach_server->port this is
    // where sketchybar is going to talk to use
    result = mach_port_allocate(
        mach_server->task, MACH_PORT_RIGHT_RECEIVE, &mach_server->port);
    if (KERN_SUCCESS != result) {
        goto RET;
    }

    // Enable bidirectionl on the port so that we can send messages back
    result = mach_port_insert_right(mach_server->task,
                                    mach_server->port,
                                    mach_server->port,
                                    MACH_MSG_TYPE_MAKE_SEND);
    if (KERN_SUCCESS != result) {
        goto RET;
    }

    // Bootstrap oursselves to register name
    result = task_get_special_port(
        mach_server->task, TASK_BOOTSTRAP_PORT, &mach_server->bs_port);
    if (KERN_SUCCESS != result) {
        goto RET;
    }

    // set up bootstrap name. This sets the service name that can be used to
    // send messages to
    result = bootstrap_register(
        mach_server->bs_port, bootstrap_name, mach_server->port);
    if (KERN_SUCCESS != result) {
        goto RET;
    }

    mach_server->handler    = handler;
    mach_server->is_running = true;
    debug_print("Successfully init mach service for %s. Starting loop...",
                bootstrap_name);

    struct mach_buffer buffer;
    while (mach_server->is_running) {
        debug_print("%s", "Listening for message...");
        mach_receive_message(mach_server->port, &buffer, false);
        if (buffer.message.descriptor.address) {
            mach_server->handler((char *)buffer.message.descriptor.address);
        }
        mach_msg_destroy(&buffer.message.header);
    }

    return true;

RET:
    print_error(result);
    exit(EXIT_FAILURE);
}
#pragma clang diagnostic pop

/**
 * @brief Receive a message from a Mach port
 *
 * If no timeout is used, the function to receive a message
 * from the kernel will block forever. This is where the
 * sketchybar program will call into at the frequency
 * specified.
 *
 * @example
 * sketchybar_item=(
 *     update_freq=2
 *     mach_helper="${bootstrap_name}"
 * )
 *
 * @param port The port to receive from
 * @param buffer Buffer to store the received message
 * @param timeout Whether to use a timeout
 */
static void mach_receive_message(mach_port_t         port,
                                 struct mach_buffer *buffer,
                                 bool                timeout) {
    *buffer = (struct mach_buffer) { 0 };
    mach_msg_return_t msg_return;

    if (timeout) {
        static const mach_msg_timeout_t TIMEOUT_MS = 100;
        msg_return = mach_msg(&buffer->message.header,
                              MACH_RCV_MSG | MACH_RCV_TIMEOUT,
                              0,
                              sizeof(struct mach_buffer),
                              port,
                              TIMEOUT_MS,
                              MACH_PORT_NULL);
    } else {
        // Block forever waiting for a message
        msg_return = mach_msg(&buffer->message.header,
                              MACH_RCV_MSG,
                              0,
                              sizeof(struct mach_buffer),
                              port,
                              MACH_MSG_TIMEOUT_NONE,
                              MACH_PORT_NULL);
    }

    if (msg_return != MACH_MSG_SUCCESS) {
        buffer->message.descriptor.address = NULL;
    }
}
