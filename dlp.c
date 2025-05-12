#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    if(argc != 2) {
        exit();
    }
    int deadline = atoi(argv[1]);

    printf(1, "Starting test program for set dl_proc\n");
    if(fork() == 0){
        if(dl_proc(deadline) == -1){
            printf(1,"dlp boom!");
        }
        printprocinfo();
        exit();
    }
    wait();
    printf(1, "Test program finished.\n");
    exit();
}