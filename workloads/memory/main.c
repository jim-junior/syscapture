#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MEGABYTE (1024 * 1024)

int main(int argc, char *argv[])
{

  if (argc < 3)
  {
    printf("Usage: %s <size_in_mb> <timeout>", argv[0]);
    return 1;
  }

  int size_in_mb = atoi(argv[1]);
  int timeout = atoi(argv[2]);
  size_t size_in_bytes = size_in_mb * MEGABYTE;

  // Allocate memory
  char *buffer = (char *)malloc(size_in_bytes);
  if (buffer == NULL)
  {
    perror("Failed to allocate memory");
    return 1;
  }

  // Fill the allocated memory with some data
  memset(buffer, 0, size_in_bytes);

  // Keep the program running for the specified timeout to allow observation of memory usage
  printf("Allocated %d MB of memory. Sleeping for %d seconds...\n", size_in_mb, timeout);
  sleep(timeout);

  // Free the allocated memory
  printf("Freeing allocated memory...\n");
  free(buffer);

  printf("Memory freed. Exiting program.\n");

  return 0;
}