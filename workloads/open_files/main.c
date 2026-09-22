#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>

int main(int argc, char *argv[])
{
  // print process PID
  pid_t pid = getpid();

  printf("Started Process, PID: %d\n", pid);

  char **files_to_open = malloc((argc - 1) * sizeof(char *));

  if (argc > 1)
  {
    for (int i = 1; i < argc; i++)
    {
      files_to_open[i - 1] = argv[i];
    }
  }

  char temp[] = "/tmp/defaulttemp_XXXXXX";

  // Open Temprory file
  int temp_fd = mkstemp(temp);
  if (temp_fd == -1)
  {
    printf("Error: Failed to create temp file");
    return 1;
  }

  // write to temprorary file
  write(temp_fd, "Hello World", 11);

  // open filed provided in args
  FILE **fds = malloc((argc - 1) * sizeof(FILE *));
  if (fds == NULL)
  {
    printf("Error: Failed to Allocate memory for file descriptors");
    return 1;
  }

  for (int i = 0; i < argc - 1; i++)
  {
    FILE *fd = fopen(files_to_open[i], "r");
    if (fd == NULL)
    {
      printf("Error: Failed to open file %s\n", files_to_open[i]);
      return 1;
    }
    fds[i] = fd;
  }

  unlink(temp);

  sleep(120);

  close(temp_fd);

  // close open files

  for (int i = 0; i < argc - 1; i++)
  {
    if (fds[i] != NULL)
    {
      fclose(fds[i]);
    }
  }
  printf("Done...\n");

  return 0;
}
