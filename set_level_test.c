
#include "types.h"
#include "stat.h"
#include "user.h"

#define RR 1
#define FCFS 2
#include "syscall.h"

// int setlevel(int pid, int level) {
//     return syscall(SYS_setlevel, pid, level);
// }
// // Dummy functions to simulate getting process level from kernel.
// // You must have implemented actual syscall(s) to get process info to use these.
// // For demonstration, assuming sys_getlevel(pid) exists which returns level or -1 on error.
// int getlevel(int pid);

// // The syscall wrapper you implemented (change name/code if different)
// int setlevel(int pid, int level);

int main(int argc, char *argv[]) {
    int pids[3];
    int i;

    int target_pid = atoi(argv[1]);
    int queue = atoi(argv[2]);

    printf(1, "Starting test program for setlevel syscall\n");

    // Create 3 child processes
    for(i = 0; i < 3; i++) {
        int pid = fork();
        if(pid < 0) {
            printf(2, "fork failed\n");
            exit();
        }
        if(pid == 0) {
            // Child process – infinite loop to keep alive
            while(1) {
                // Busy wait (simulate workload)
            }
            // Should never reach here
            exit();
        }
        // Parent tracks child pids
        pids[i] = pid;
    }

    // Give some time for children to become runnable (optional)
    sleep(10);

    // Print their current levels, change levels, print again
    //for(i = 0; i < 3; i++) {
        //int pid = pids[i];

        // int old_level = getlevel(pid);
        // if(old_level < 0) {
        //     printf(2, "Failed to get level for pid %d\n", pid);
        //     continue;
        // }

        // printf(1, "PID %d: Current level: %d\n", pid, old_level);

        // Toggle level: if RR(1) then FCFS(2), else RR(1)
        //int new_level = (old_level == RR) ? FCFS : RR;
        setlevel(target_pid , queue);
        

        // int updated_level = getlevel(pid);
        // if(updated_level < 0) {
        //     printf(2, "Failed to get updated level for pid %d\n", pid);
        //     continue;
        // }

       // printf(1, "PID %d: Updated level: %d\n", pid, updated_level);
    //}

    // Cleanup: kill all child processes
    for(i = 0; i < 3; i++) {
        kill(pids[i]);
        wait();
    }

    printf(1, "Test program finished.\n");
    exit();
}