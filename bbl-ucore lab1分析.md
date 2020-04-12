# bbl-ucore lab1分析

lab1

- kern
  - driver:
    - 操作系统里和sbi直接交互的部分.
    - clock.h,clock.c: 计时器, sbi_set_timer(), sbi_timebase(),这个timebase也许可以硬编码进去,不调用sbi_timebase()函数.
    - console.h,console.c: 封装sbi_console_getchar(), sbi_console_putchar(),输入输出字符
    - intr.h, intr.c: 中断使能
    - kbdreg.h: 键盘外设中断的编码?
    - picirq.c, picirq.h: 没看出有啥用处, 在lab1里是空的, 看注释可能是以前x86遗留的文件
  - init
    - 程序入口
    - entry.S: 用汇编写的程序入口, 调用init.c里面的kern_init函数. 用的汇编指令是tail kern_init而不是call kern_init, 有点奇怪. 用到mm/mmu.h mm/memlayout.h定义的常量.
    - init.c: 真正的程序入口, 在kern_init完成一系列初始化
  - libs
    - readline.c, stdio.c, 实现一些io函数, 依赖于console.h提供的输入输出字符接口
  - mm: 内存管理, 在lab1的作用是定义了页面大小和内核栈大小的常量
  - trap: 中断处理
    - trapentry.S: 保存和恢复上下文的汇编代码, 以及定义了中断处理的入口__alltraps, 之后需要到trap.c的trap函数里处理
    - trap.c, trap.h: 处理中断的代码
- libs
  - defs.h: 定义了一些类型和宏, 注意之前把intptr_t定义成了int32_t, 我们应该改成int64_t.
  - string.h, string.c: 类似cstring的库. 
  - stdio.h,printfmt.c: IO库
  - stdarg.h: 没看明白, 可能和内存管理有关
  - riscv.h: 应该是整合了riscv-pk的bits.h, encodings.h, 关于riscv的库, 很多地方都依赖....感觉可以考虑直接用bbl-ucore的版本?如果不行的话再用最新版本的riscv-pk里的东西?
  - sbi.h, sbi.S: sbi的接口, 之前是奇怪的硬编码, 在sbi_entry.S里面实现. 应该需要重写, 用内联汇编ecall调用qemu的opensbi
- tools
  - kernel.ld, 内存布局脚本, 可能需要改

