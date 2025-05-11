#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
   
    if (argc != 5) {
        printf(1, "Usage: 4 input\n");
        exit();
    }
    
    int t_pid = atoi(argv[1]);
    int t_deadline = atoi(argv[2]);
    int pid_for_change_level = atoi(argv[3]);
    int level = atoi(argv[4]);


    if(dl_proc(t_pid , t_deadline) == -1){
        exit();
    }

    printprocinfo();   
    
    setlevel(pid_for_change_level, level);

    printprocinfo();

    exit();
}
