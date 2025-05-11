#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  int class1_num;
  int rr_num;
  int fcfs_num;
} ptable;

void
change_num(struct proc* p, int inc_or_dec){
  if(p->queue==CLASS1){
    ptable.class1_num = ptable.class1_num + inc_or_dec;
  }
  else{
    if(p->queue==CLASS2_RR){
      ptable.rr_num = ptable.rr_num + inc_or_dec;
    }
    else{
      ptable.fcfs_num = ptable.fcfs_num + inc_or_dec;
    }
  }
}

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  p->arrival_time = ticks;
  p->deadline = 0;
  p->queue = CLASS2_RR;
  p->age = 0;
  p->cons_run = 0;

  change_num(p, 1);

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  np->arrival_time = ticks;
  np->deadline = 0;
  np->age=0;
  np->queue = CLASS2_FCFS;
  // if (strncmp(np->name,"sh",3)||strncmp(np->parent->name,"sh",3)){
  //   np->queue = CLASS2_RR;
  // }
  // else{
  //   np->queue = CLASS2_FCFS;
  // }
  if(np->parent){
    np->queue = np->parent->queue ;
  }

  np->cons_run= 0 ;

  inc_num(np);
  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  int nextTick = ticks;
  nextTick++;
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    //     if(p->state==RUNNABLE && p->queue==CLASS2_FCFS){
    //       p->age++;    
    //       //cprintf("age increased for PID: %d to %d\n",p->pid,p->age);
    //       if(p->age>=800){
    //         p->queue = CLASS2_RR ;
    //         p->age = 0;
    //         cprintf("PID %d: got increased priority to RR due to growing old!\n",p->pid);
    //       }
    //     }
    //   }

    /// پیاده سازی ایجینگ
    if(nextTick==ticks){
      nextTick++;
      for(p=ptable.proc; p< &ptable.proc[NPROC];p++){
        release(&ptable.lock);
        acquire(&ptable.lock);
        if(p->state==RUNNABLE && p->queue==CLASS2_FCFS){
          p->age++;
          //cprintf("age increased for %s to %d\n",p->name,p->age);
          if(p->age>=800){
            p->arrival_time = ticks;
            p->queue = CLASS2_RR ;
            p->age = 0;
            cprintf("PID %d: got increased priority to RR due to growing old!\n",p->pid);
          }
        }  
      }   
    }     
      struct proc *runable_p = 0;
      int min_dead = 1000000;

    if(ptable.class1_num>0){
      for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
        if(p->state==RUNNABLE && p->queue==CLASS1){
          int argMin = ticks - p->deadline ;
          if(!runable_p || argMin<min_dead){
            min_dead = argMin;
            runable_p = p;
          }
        }
      }
    }
      if(!runable_p && ptable.rr_num>0){
        for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
          if(p->state==RUNNABLE && p->queue==CLASS2_RR){
            runable_p=p;
            break;
          }
        }
      }
      if(!runable_p && ptable.fcfs_num>0){
        for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
          if(p->state==RUNNABLE && p->queue==CLASS2_FCFS){
            if(!runable_p || p->arrival_time < runable_p->arrival_time){
              runable_p = p ;
            }
  
          }
        }
      }
      if(runable_p){
        c->proc = runable_p;
        change_num(runable_p, -1);
        //cprintf("proc %d worked in age %d\n",runable_p->pid,runable_p->age);
        if(runable_p->queue==CLASS2_FCFS){
          runable_p->age = 0;
        }
        //cprintf("proc %d worked in age %d\n",runable_p->pid,runable_p->age);
        switchuvm(runable_p);
        runable_p->state = RUNNING;
        swtch(&(c->scheduler),runable_p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;

  change_num(myproc(), 1);

  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan){
      p->state = RUNNABLE;
      change_num(p, 1);
    }  
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
        //change_num(p, 1);
        p->state = RUNNABLE;
      }  
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }

}

int sys_setlevel(void){
    int pid, new_level;
    struct proc *p;

  
    if(argint(0, &pid) < 0)
        return -1;
    if(argint(1, &new_level) < 0)
        return -1;

 
    if(new_level != CLASS2_RR && new_level != CLASS2_FCFS)
        return -1;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->pid == pid){
          if(p->queue == new_level){
            release(&ptable.lock);
            cprintf("the process is in this level now, can't change level!\n");
            return -1;
          }
            if(p->queue == CLASS2_FCFS || p->queue == CLASS2_RR){
                //cprintf("%d\n",p->queue);
                p->queue = new_level;
                // p->age = 0;
                p->cons_run = 0;
                //cprintf("%d\n",p->queue);
                release(&ptable.lock);
                cprintf("changing level done!\n");
                return 0; 
            } if(p->queue == CLASS1) {
                release(&ptable.lock);
                cprintf("Not in class2, can't change level!\n");
                return -1; 
            }
        }
    }
    release(&ptable.lock);
    return -1; // pid not found
}







char* getStateString(enum procstate state) {
  switch(state) {
    case UNUSED: return "UNUSED";
    case EMBRYO: return "EMBRYO";
    case SLEEPING: return "SLEEPING";
    case RUNNABLE: return "RUNNABLE";
    case RUNNING: return "RUNNING";
    case ZOMBIE: return "ZOMBIE";
    default: return "UNKNOWN";
  }
}
char* getClassString(enum priority_queue q) {
  switch (q) {
    case CLASS1: return "real-time";
    case CLASS2_RR: return "normal";
    case CLASS2_FCFS: return "normal";
    default: return "unknown";
  }
}
char* getAlgorithmString(struct proc *p) {
  switch (p->queue) {
    case CLASS1: return "EDF";
    case CLASS2_RR: return "RR";
    case CLASS2_FCFS: return "FCFS";
    default: return "unknown";
  }
}


int count_digits(int number) {
  if (number == 0)
      return 1;  

  int count = 0;
  if (number < 0) {
      count++;     
      number = -number; 
  }

  while (number > 0) {
      count++;
      number /= 10; 
  }
  return count;
}

void printspaces(int count) { 
  for (int i = 0; i < count; i++) {
    cprintf(" ");
  }
}

void printprocinfo(void) {
  struct proc *p;

  acquire(&ptable.lock);

  cprintf("name            pid  state class   algorithm age deadline cons_run arrival\n"
    "------------------------------------------------------------------------------\n");

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->state == UNUSED)
      continue;

    static int columns[] = { 16, 5, 10, 9, 10, 8, 8, 8, 8 };

    cprintf("%s", p->name);
    printspaces(columns[0] - strlen(p->name));

    cprintf("%d", p->pid);
    printspaces(columns[1] - count_digits(p->pid));

    char *stateStr = getStateString(p->state);
    cprintf("%s", stateStr);
    printspaces(columns[2] - strlen(stateStr));

    char *classStr = getClassString(p->queue);
    cprintf("%s", classStr);
    printspaces(columns[3] - strlen(classStr));

    char *algoStr = getAlgorithmString(p);
    cprintf("%s", algoStr);
    printspaces(columns[4] - strlen(algoStr));

    cprintf("%d", p->age);
    printspaces(columns[5] - count_digits(p->age));

    cprintf("%d", p->deadline);
    printspaces(columns[6] - count_digits(p->deadline));

    cprintf("%d", p->cons_run);
    printspaces(columns[7] - count_digits(p->cons_run));

    cprintf("%d", p->arrival_time);
    printspaces(columns[8] - count_digits(p->arrival_time));

    cprintf("\n");
  }


  release(&ptable.lock);
}

int sys_dl_proc(void){
  int pid, dead_line;
  
    if(argint(0, &pid) < 0)
        return -1;
    if(argint(1, &dead_line) < 0)
        return -1;
    int flag = 0;
    acquire(&ptable.lock);
    for(int index = 0; index < NPROC; index++) {
      if(ptable.proc[index].pid == pid) {
        ptable.proc[index].deadline = dead_line;
        if(ptable.proc[index].state == RUNNABLE) {
          change_num(&ptable.proc[index], -1);
          ptable.proc[index].queue = CLASS1;
          change_num(&ptable.proc[index], 1);
        }
        else {
          ptable.proc[index].queue = CLASS1;
        }
        flag = 1;
        break;
      }
    }
    release(&ptable.lock);
    if(flag == 1){
      printprocinfo();
    }
    else {
      cprintf("proc not found!");

    }
    return 1;
}