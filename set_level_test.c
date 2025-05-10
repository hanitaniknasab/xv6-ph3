
#include "types.h"
#include "stat.h"
#include "user.h"




int main(int argc, char *argv[]) {
    if(argc != 3) {
        exit();
    }
    int target_pid = atoi(argv[1]);
    int queue = atoi(argv[2]);

    printf(1, "Starting test program for setlevel syscall\n");
    setlevel(target_pid , queue);
    printprocinfo();
    printf(1, "Test program finished.\n");
    exit();
}
