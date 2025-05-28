CC = clang
CFLAGS = -std=c99 -framework CoreFoundation
SRC = clock.c
TARGET = sketchybar_clock

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET)

clean:
	rm -f $(TARGET)
