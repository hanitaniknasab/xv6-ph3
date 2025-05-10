#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    if(argc != 3) {
        exit();
    }
    int target_pid = atoi(argv[1]);
    int deadline = atoi(argv[2]);

    printf(1, "Starting test program for set dl_proc\n");
    if(dl_proc(target_pid , deadline) == -1){
        exit();
    }
    printprocinfo();
    printf(1, "Test program finished.\n");
    exit();
}