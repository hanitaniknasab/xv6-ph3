#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
   
    if (argc != 4) {
        printf(1, "Usage: 3 input\n");
        exit();
    }
    
    int t_deadline = atoi(argv[1]);
    int pid_for_change_level = atoi(argv[2]);
    int level = atoi(argv[3]);
    if(fork() == 0){
        if(dl_proc(t_deadline) == -1){
            printf(1,"dlp boom!");
        }
        if(fork() == 0){
            if(dl_proc(t_deadline/2) == -1){
                printf(1,"dlp boom!");
            }
            printprocinfo();
            exit(); 
        }
        wait();
        printprocinfo();
        exit();
    }
    wait();
    
    setlevel(pid_for_change_level, level);

    printprocinfo();

    exit();
}
