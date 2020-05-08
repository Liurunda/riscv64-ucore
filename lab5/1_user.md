# lab5 1/n 用户进程

我们在`proc_init()`函数里初始化进程的时候, 认为启动时运行的ucore程序, 是一个内核进程("第0个"内核进程), 并将其初始化为`idleproc`进程。然后我们新建了一个内核进程执行`init_main()`函数。

我们比较lab4和lab5的`init_main()`有何不同。

```c
// kern/process/proc.c (lab4)
static int init_main(void *arg) {
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
    cprintf("To U: \"%s\".\n", (const char *)arg);
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
    return 0;
}

// kern/process/proc.c (lab5)
static int init_main(void *arg) {
    size_t nr_free_pages_store = nr_free_pages();
    size_t kernel_allocated_store = kallocated();

    int pid = kernel_thread(user_main, NULL, 0);
    if (pid <= 0) {
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
        schedule();
    }

    cprintf("all user-mode processes have quit.\n");
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
    assert(nr_process == 2);
    assert(list_next(&proc_list) == &(initproc->list_link));
    assert(list_prev(&proc_list) == &(initproc->list_link));

    cprintf("init check memory pass.\n");
    return 0;
}
```

注意到，lab5新建了一个内核进程，执行函数`user_main()`,这个内核进程里我们将要开始执行用户进程。

`do_wait(0, NULL)`等待子进程退出，也就是等待`user_main()`退出。

我们来看`user_main()`和`do_wait()`里做了什么

```c
// kern/process/proc.c
#define __KERNEL_EXECVE(name, binary, size) ({                          \
            cprintf("kernel_execve: pid = %d, name = \"%s\".\n",        \
                    current->pid, name);                                \
            kernel_execve(name, binary, (size_t)(size));                \
        })

#define KERNEL_EXECVE(x) ({                                             \
            extern unsigned char _binary_obj___user_##x##_out_start[],  \
                _binary_obj___user_##x##_out_size[];                    \
            __KERNEL_EXECVE(#x, _binary_obj___user_##x##_out_start,     \
                            _binary_obj___user_##x##_out_size);         \
        })

#define __KERNEL_EXECVE2(x, xstart, xsize) ({                           \
            extern unsigned char xstart[], xsize[];                     \
            __KERNEL_EXECVE(#x, xstart, (size_t)xsize);                 \
        })

#define KERNEL_EXECVE2(x, xstart, xsize)        __KERNEL_EXECVE2(x, xstart, xsize)

// user_main - kernel thread used to exec a user program
static int
user_main(void *arg) {
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
}
```

lab5的Makefile进行了改动， 把用户程序编译到我们的镜像里。

`_binary_obj___user_##x##_out_start`和`_binary_obj___user_##x##_out_size`都是编译的时候自动生成的符号。注意这里的`##x##`，按照C语言宏的语法，会直接把x的变量名代替进去。

于是，我们在`user_main()`所做的，就是执行了

`kern_execve("exit", _binary_obj___user_exit_out_start,_binary_obj___user_exit_out_size)`

这么一个函数。

如果你熟悉`execve()`函数，或许已经猜到这里我们做了什么。

实际上，就是加载了存储在这个位置的程序`exit`并在`user_main`这个进程里开始执行。这时`user_main`就从内核进程变成了用户进程。我们在下一节介绍`kern_execve()`的实现。

我们在`user`目录下存储了一些用户程序，在编译的时候放到生成的镜像里。

```c
// user/exit.c
#include <stdio.h>
#include <ulib.h>

int magic = -0x10384;

int main(void) {
    int pid, code;
    cprintf("I am the parent. Forking the child...\n");
    if ((pid = fork()) == 0) {
        cprintf("I am the child.\n");
        yield();
        yield();
        yield();
        yield();
        yield();
        yield();
        yield();
        exit(magic);
    }
    else {
        cprintf("I am parent, fork a child pid %d\n",pid);
    }
    assert(pid > 0);
    cprintf("I am the parent, waiting now..\n");

    assert(waitpid(pid, &code) == 0 && code == magic);
    assert(waitpid(pid, &code) != 0 && wait() != 0);
    cprintf("waitpid %d ok.\n", pid);

    cprintf("exit pass.\n");
    return 0;
}
```

这个用户程序`exit`里我们测试了`fork()` `wait()`这些函数。这些函数都是`user/libs/ulib.h`对系统调用的封装。

```c
// user/libs/ulib.c
#include <defs.h>
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>
void exit(int error_code) {
    sys_exit(error_code);
    //执行完sys_exit后，按理说进程就结束了，后面的语句不应该再执行，
    //所以执行到这里就说明exit失败了
    cprintf("BUG: exit failed.\n"); 
    while (1);
}
int fork(void) { return sys_fork(); }
int wait(void) { return sys_wait(0, NULL); }
int waitpid(int pid, int *store) { return sys_wait(pid, store); }
void yield(void) { sys_yield();}
int kill(int pid) { return sys_kill(pid); }
int getpid(void) { return sys_getpid(); }
```

在用户程序里使用的`cprintf()`也是在`user/libs/stdio.c`重新实现的，和之前比最大的区别是，打印字符的时候需要经过系统调用`sys_putc()`，而不能直接调用`sbi_console_putchar()`。这是自然的，因为只有在Supervisor Mode才能通过`ecall`调用Machine Mode的OpenSBI接口，而在用户态(U Mode)就不能直接使用M mode的接口，而是要通过系统调用。

```c
// user/libs/stdio.c
#include <defs.h>
#include <stdio.h>
#include <syscall.h>

/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
    sys_putc(c);//系统调用
    (*cnt) ++;
}

/* *
 * vcprintf - format a string and writes it to stdout
 *
 * The return value is the number of characters which would be
 * written to stdout.
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
    //注意这里复用了vprintfmt, 但是传入了cputch函数指针
    return cnt;
}
```

下面我们来看这些系统调用的实现。