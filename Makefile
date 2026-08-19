CC = gcc
CFLAGS = -Wall -Wextra -O2

MEMORY_C_SRC = workloads/memory/main.c
MEMORY_C_TARGET = bin/memory
ZOMBIE_C_SRC = workloads/zombie/main.c
ZOMBIE_C_TARGET = bin/zombie

.PHONY: all clean

all: $(MEMORY_C_TARGET) $(ZOMBIE_C_TARGET)

$(MEMORY_C_TARGET): $(MEMORY_C_SRC)
	mkdir -p bin
	$(CC) $(CFLAGS) -o $(MEMORY_C_TARGET) $(MEMORY_C_SRC)

$(ZOMBIE_C_TARGET): $(ZOMBIE_C_SRC)
	mkdir -p bin
	$(CC) $(CFLAGS) -o $(ZOMBIE_C_TARGET) $(ZOMBIE_C_SRC)

clean:
	rm -rf bin
	rm -rf build
