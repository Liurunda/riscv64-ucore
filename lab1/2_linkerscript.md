# 链接脚本，入口点

gnu工具链中，包含一个链接器`ld`

如果你很好奇，可以看[linker script的详细语法](http://www.scoberlin.de/content/media/http/informatik/gcc_docs/ld_3.html)

链接器的作用是把输入文件(往往是 .o文件)链接成输出文件(往往是elf文件)。一般来说，输入文件和输出文件都有很多section, 链接脚本(linker script)的作用，就是描述怎样把输入文件的section映射到输出文件的section, 同时规定这些section的内存布局。

如果你不提供链接脚本，ld会使用默认的一个链接脚本，这个默认的链接脚本适合链接出一个能在现有操作系统下运行的应用程序，但是并不适合链接一个操作系统内核。你可以通过`ld --verbose`来查看默认的链接脚本。

下面给出我们使用的链接脚本

```
// tools/kernel.ld

OUTPUT_ARCH(riscv) // 指定输出文件的指令集架构, 在riscv平台上运行
ENTRY(kern_entry)  // 指定程序的入口点, 是一个叫做kern_entry的符号。
// 我们之后会在汇编代码里定义kern_entry这个符号, 并使他恰好在0x80200000的内存位置 。

BASE_ADDRESS = 0x80200000;//定义了一个变量BASE_ADDRESS并初始化

//链接脚本剩余的部分是一整条SECTIONS指令，用来指定输出文件的所有SECTION
// "." 是SECTIONS指令内的一个特殊变量/计数器，对应内存里的一个地址。
SECTIONS
{
    /* Load the kernel at this address: "." means the current address */
    . = BASE_ADDRESS;//对 "."进行赋值
	// 下面一句的意思是：从.的当前值（当前地址）开始放置一个叫做text的section. 
	// 花括号内部的*(.text.kern_entry .text .stub .text.* .gnu.linkonce.t.*)是正则表达式
	// 如果输入文件中有一个section的名称符合花括号内部的格式
	// 那么这个section就被加到输出文件的text这个section里
    .text : {
        *(.text.kern_entry .text .stub .text.* .gnu.linkonce.t.*)
    }

    PROVIDE(etext = .); /* Define the 'etext' symbol to this value */
	//read only data, 只读数据，如程序里的常量
    .rodata : {
        *(.rodata .rodata.* .gnu.linkonce.r.*)
    }

    //进行地址对齐，将 "."增加到 2的0x1000次方的整数倍，也就是下一个内存页的起始处
    . = ALIGN(0x1000);

  	
    .data : {
        *(.data)
        *(.data.*)
    }
	//small data section, 存储字节数小于某个标准的变量，一般是char, short等类型的
    .sdata : {
        *(.sdata)
        *(.sdata.*)
    }

    PROVIDE(edata = .);
	//初始化为零的数据
    .bss : {
        *(.bss)
        *(.bss.*)
        *(.sbss*)
    }

    PROVIDE(end = .);
	// /DISCARD/表示忽略，输入文件里 *(.eh_frame .note.GNU-stack)这些section都被忽略，不会加入到输出文件中
    /DISCARD/ : {
        *(.eh_frame .note.GNU-stack)
    }
}
```

我们在链接脚本里把程序的入口点定义为`kern_entry`, 那么我们的程序里需要有一个名称为`kern_entry`的符号。

（这里还没写完）

```assembly
# kern/init/entry.S
#include <mmu.h>
#include <memlayout.h>

.section .text,"ax",%progbits #开始.text 这个section
    .globl kern_entry #可在其他文件看到kern_entry这个符号
kern_entry:
    la sp, bootstacktop

    tail kern_init

.section .data
    .align PGSHIFT
    .global bootstack #启动时的栈
bootstack:
    .space KSTACKSIZE #预留栈空间
    .global bootstacktop
bootstacktop:                              
```



