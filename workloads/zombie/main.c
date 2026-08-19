#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char *argv[])
{

  if (argc < 2)
  {
    printf("Error: missing arguments\n");
    printf("Usage: %s <zombie_count>\n", argv[0]);
    return 1;
  }

  int zombie_count = atoi(argv[1]);

  for (int i = 0; i < zombie_count; i++)
  {
    pid_t pid = fork();

    if (pid == 0)
    {
      printf("Running Child process with PID: %d\n", getpid());

      sleep(60);

      if (i % 2 == 0)
      {
        pid_t gc_pid = fork(); // gc_pid meaning grand child pid

        if (gc_pid == 0)
        {
          printf("GC(%d):Running Grand Child process\n", getpid());

          sleep(60);

          exit(0);
        }
        else
        {
          printf("CHILD(%d):Running Grand Child process with PID: %d\n", getpid(), gc_pid);
        }
      }

      exit(0);
    }
    else
    {
      printf("PARENT(%d): Started Child process with PID: %d\n", getpid(), pid);

      int status;
      waitpid(pid, &status, 0);

      printf("Child PID done\n");
    }
  }

  return 0;
}