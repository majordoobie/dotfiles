/**
 * @file sketchybar.c
 * @brief Implementation of sketchybar C API functions
 * @author Felix Kratz (sketchybar creator)
 */

#include <sketchybar.h>
#include <stdlib.h>
#include <string.h>

/** @brief Global Mach port for sketchybar communication */
static mach_port_t g_mach_port = 0;

mach_port_t mach_get_bs_port(void) {
  mach_port_name_t task = mach_task_self();

  mach_port_t bs_port;
  if (task_get_special_port(task, TASK_BOOTSTRAP_PORT, &bs_port) !=
      KERN_SUCCESS) {
    return 0;
  }

  char *name = getenv("BAR_NAME");
  if (!name) {
    name = "sketchybar";
  }
  size_t name_len = strlen(name);

  // Length of "git.felix." + null terminator
  static const uint32_t PREFIX_LEN = 16;
  uint32_t lookup_len = PREFIX_LEN + (uint32_t) name_len;

  char *buffer = (char *) calloc(lookup_len, sizeof(char));
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

  struct mach_message msg = {0};
  msg.header.msgh_remote_port = port;
  msg.header.msgh_local_port = 0;
  msg.header.msgh_id = 0;
  msg.header.msgh_bits =
      MACH_MSGH_BITS_SET(MACH_MSG_TYPE_COPY_SEND, MACH_MSG_TYPE_MAKE_SEND, 0,
                         MACH_MSGH_BITS_COMPLEX);

  msg.header.msgh_size = sizeof(struct mach_message);
  msg.msgh_descriptor_count = 1;
  msg.descriptor.address = message;
  msg.descriptor.size = len * sizeof(char);
  msg.descriptor.copy = MACH_MSG_VIRTUAL_COPY;
  msg.descriptor.deallocate = false;
  msg.descriptor.type = MACH_MSG_OOL_DESCRIPTOR;

  kern_return_t err =
      mach_msg(&msg.header, MACH_SEND_MSG, sizeof(struct mach_message), 0,
               MACH_PORT_NULL, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);

  return err == KERN_SUCCESS;
}

uint32_t format_message(char *message, char *formatted_message) {
  // This is not actually robust, switch to stack based messaging.
  char outer_quote = 0;
  uint32_t caret = 0;
  size_t msg_len = strlen(message);
  uint32_t message_length = (uint32_t) msg_len + 1;
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

  if (caret > 0 && formatted_message[caret] == '\0' &&
      formatted_message[caret - 1] == '\0') {
    caret--;
  }
  formatted_message[caret] = '\0';
  return caret + 1;
}

void sketchybar(char *message) {
  size_t msg_len = strlen(message);
  char *formatted_message = malloc(msg_len + 2);
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
