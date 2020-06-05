# 项目组成和执行流

## 项目组成

```
lab1
├── Makefile
├── kern
│   ├── debug
│   │   ├── assert.h
│   │   ├── kdebug.c
│   │   ├── kdebug.h
│   │   ├── kmonitor.c
│   │   ├── kmonitor.h
│   │   ├── panic.c
│   │   └── stab.h
│   ├── driver
│   │   ├── clock.c
│   │   ├── clock.h
│   │   ├── console.c
│   │   ├── console.h
│   │   ├── intr.c
│   │   └── intr.h
│   ├── init
│   │   ├── entry.S
│   │   └── init.c
│   ├── libs
│   │   └── stdio.c
│   ├── mm
│   │   ├── memlayout.h
│   │   ├── mmu.h
│   │   ├── pmm.c
│   │   └── pmm.h
│   └── trap
│       ├── trap.c
│       ├── trap.h
│       └── trapentry.S
├── lab1.md
├── libs
│   ├── defs.h
│   ├── error.h
│   ├── printfmt.c
│   ├── readline.c
│   ├── riscv.h
│   ├── sbi.c
│   ├── sbi.h
│   ├── stdarg.h
│   ├── stdio.h
│   ├── string.c
│   └── string.h
├── readme.md
└── tools
    ├── function.mk
    ├── gdbinit
    ├── grade.sh
    ├── kernel.ld
    ├── sign.c
    └── vector.c

9 directories, 43 files
```

只介绍新增的或变动较大的文件。

##### 硬件驱动层

`kern/driver/clock.c(h)`: 通过`OpenSBI`的接口, 可以读取当前时间(rdtime), 设置时钟事件(sbi_set_timer)，是时钟中断必需的硬件支持。

`kern/driver/intr.c(h)`: 中断也需要CPU的硬件支持，这里提供了设置中断使能位的接口（其实只封装了一句riscv指令）。

##### 初始化

`kern/init/init.c`: 需要调用中断机制的初始化函数。

##### 中断处理

`kern/trap/trapentry.S`: 我们把中断入口点设置为这段汇编代码。这段汇编代码把寄存器的数据挪来挪去，进行上下文切换。

`kern/trap/trap.c(h)`: 分发不同类型的中断给不同的handler, 完成上下文切换之后对中断的具体处理，例如外设中断要处理外设发来的信息，时钟中断要触发特定的事件。中断处理初始化的函数也在这里，主要是把中断向量表(stvec)设置成所有中断都要跳到`trapentry.S`进行处理。

## 执行流

内核初始化函数`kern_init()`的执行流：(从`kern/init/entry.S`进入) -> 输出一些信息说明正在初始化 -> 设置中断向量表(stvec）跳转到的地方为`kern/trap/trapentry.S`里的一个标记 ->在`kern/driver/clock.c`设置第一个时钟事件，使能时钟中断->设置全局的S  mode中断使能位-> 现在开始不断地触发时钟中断

产生一次时钟中断的执行流：set_sbi_timer()通过OpenSBI的时钟事件触发一个中断，跳转到`kern/trap/trapentry.S`的`__alltraps`标记 -> 保存当前执行流的上下文，并通过函数调用，切换为`kern/trap/trap.c`的中断处理函数`trap()`的上下文，进入`trap()`的执行流。切换前的上下文作为一个结构体，传递给`trap()`作为函数参数 -> `kern/trap/trap.c`按照中断类型进行分发(`trap_dispatch(), interrupt_handler()`)->执行时钟中断对应的处理语句，累加计数器，设置下一次时钟中断->完成处理，返回到`kern/trap/trapentry.S`->恢复原先的上下文，中断处理结束。