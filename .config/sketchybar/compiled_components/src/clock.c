#include <CoreFoundation/CoreFoundation.h>
#include <sketchybar.h>
#include <time.h>

void callback(CFRunLoopTimerRef timer, void *info) {
  time_t current_time;
  time(&current_time);
  const char *format = info;
  char buffer[64];
  strftime(buffer, sizeof(buffer), format, localtime(&current_time));

  uint32_t message_size = sizeof(buffer) + 64;
  char message[message_size];
  snprintf(message, message_size, "--set time label=\"%s\"", buffer);
  sketchybar(message);
}

int main(int argc, char *argv[]) {

  CFRunLoopTimerContext ctx = {
      .version = 0,
      .info = (void *) argv[1],
      .retain = NULL,  // if you were passing a CF type you'd use CFRetain
      .release = NULL, // and CFRelease here
      .copyDescription = NULL};

  CFRunLoopTimerRef timer = CFRunLoopTimerCreate(
      kCFAllocatorDefault, (int64_t) CFAbsoluteTimeGetCurrent() + 1.0, 1.0, 0,
      0, callback, &ctx);

  // add to the run loop
  CFRunLoopAddTimer(CFRunLoopGetMain(), timer, kCFRunLoopDefaultMode);
  CFRunLoopRun();
  return 0;
}
