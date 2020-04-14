#include <console.h>
#include <defs.h>
#include <pmm.h>
#include <riscv.h>
#include <stdio.h>
#include <string.h>

int kern_init(void) __attribute__((noreturn));

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);

    cons_init();  // init the console

    const char *message = "(THU.CST) os is loading ...\n";
    cprintf("%s\n\n", message);
 
   while (1)
        ;
}
