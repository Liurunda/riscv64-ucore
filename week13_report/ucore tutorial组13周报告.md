# riscv64 ucore tutorial组 大实验报告

曹鼎原  2017011417  刘润达  2018013412

回顾开题时的目标: 

1. 编写类似rcore step-by-step tutorial的, 从零开始自己构建一个OS的文档(基础目标）
2. 加入多核的支持, 在真实多核硬件上进行演示, 提供类似简化过的pthread之类的接口供用户程序使用多核特性.（挑战目标）
3. 设计基于多核特性的新lab / challenge

完成情况: 仅完成了基础目标

计划中, 希望每周能够至少完成两个lab的代码梳理和文档编写, 实际中发现代码里会踩很多坑。

## 成果的不足

- 代码还没有进行更仔细的梳理，有一些过时的注释，一些地方缺乏注释
- 练习题、扩展练习还没有出完
- 后半部分的lab tutorial里，没有很好地区分”核心文本“和”补充知识“
- 后半部分的lab tutorial的结构不如前面划分的清晰，覆盖的代码没有前面全

## 工作流程的不足

- 前期调研和交流不足, 到很晚的时候才了解到有ucore仓库的riscv64-opensbi和riscv64-priv-1.10两个branch可以参考
- 两个人都做了rcore基础实验但是大实验却选择了ucore, 在熟悉框架的时候动作比较慢, 花费了一些精力



## lab1: 固件、模拟器使用的选择

一开始在spike(固件berkeley bootloader)和qemu(Open SBI)之间摇摆不定。在spike/bbl的调试上花费了一些时间，但是无法调通。最后我们选择了迁移到OpenSBI（使用qemu模拟）。

- 一开始希望选择bbl, 是因为张蔚riscv32的bbl-ucore是基于berkeley bootloader的，采用同样的固件可以尽量复用。

- 但是由于riscv-pk的版本更新，以及riscv指令集的一些更新，我们在使用bbl的时候遇到了较大困难，始终无法正常调用固件的sbi接口。(bbl的sbi接口实现中有很多魔法，其实现也难以理解)

- ```asm
  .globl sbi_hart_id; sbi_hart_id = -2048
  .globl sbi_num_harts; sbi_num_harts = -2032
  .globl sbi_query_memory; sbi_query_memory = -2016
  .globl sbi_console_putchar; sbi_console_putchar = -2000
  .globl sbi_console_getchar; sbi_console_getchar = -1984
  .globl sbi_send_ipi; sbi_send_ipi = -1952
  .globl sbi_clear_ipi; sbi_clear_ipi = -1936
  .globl sbi_timebase; sbi_timebase = -1920
  .globl sbi_shutdown; sbi_shutdown = -1904
  .globl sbi_set_timer; sbi_set_timer = -1888
  .globl sbi_mask_interrupt; sbi_mask_interrupt = -1872
  .globl sbi_unmask_interrupt; sbi_unmask_interrupt = -1856
  .globl sbi_remote_sfence_vm; sbi_remote_sfence_vm = -1840
  .globl sbi_remote_sfence_vm_range; sbi_remote_sfence_vm_range = -1824
  .globl sbi_remote_fence_i; sbi_remote_fence_i = -1808
  ```

- 查询一些资料，我们了解到，bbl的历史比OpenSBI长，OpenSBI在2019年1月才发布，之前bbl是主流的riscv固件(也就是bbl-ucore开发时的主流固件)。目前RISCV社区希望以OpenSBI来统一riscv的固件生态，且BBL会逐渐被取代。考虑到之前已经成功在OpenSBI（QEMU)上开发了rcore及其tutorial, 我们决定，把riscv64上的ucore迁移到OpenSBI固件上。

  > ### OpenSBI
  >
  > OpenSBI is a RISC-V bootloader and SBI firmware. It is a **recommended alternative to BBL** that has a **larger feature set and is more actively maintained**. Additionally, OpenSBI binaries don't have to be rebuilt with each FreeBSD kernel build, easing development and testing.
  >
  > ### BBL (Berkley Boot Loader)
  >
  > BBL is the RISC-V bootloader originally used by FreeBSD. It is **slowly becoming legacy software in favor of [OpenSBI](https://wiki.freebsd.org/riscv#OpenSBI)**, but it is **still maintained and may be useful** for bringup on platforms not yet supported by OpenSBI.
  >
  > from https://wiki.freebsd.org/riscv

- 由于lrd眼瞎，把在bbl上运行不正常的代码当成了运行正常的lab1代码，导致这一部分的工作紧迫感下降。到第八周周五才确定了要从bbl迁移到OpenSBI，在第八周结束之前终于由cdy完成了lab1在OpenSBI上运行的修改。进度从一开始就慢了。

## lab2, lab3: 内存管理，多级页表

原先ucore的内存管理方案是：启动时为裸机模式(直接使用物理内存)，然后在`pmm_init()`初始化页表并使用虚拟内存。bbl-ucore采用了这个方案，变量名都用了原来的（如页表基址使用`cr3`而不是`satp`，我们的代码里目前也使用了很多这样legacy的变量名，需要进一步修改）。

rcore的内存管理方案是：在汇编的内核入口点`entry.S`里就实现一个简单的虚拟内存“大页”映射，然后进行更加精细的重映射。

我们在两种初始化方案之间纠结了一下，没有很快地确定下来，开发过程中有的时候采用第一种方案，有的时候采用第二种方案，还导致了一些bug。最后才确定统一使用较为简单的（不出bug的）第二种方案。目前在代码实现中，缺乏更加精细的内核重映射，相对rcore是一个不足。

我们在移植过程中，还遇到一个困难，就是要从Sv32移植到Sv39，从二级页表的使用改为三级页表的使用，稍微有点复杂度，我们有一些畏难情绪，工作也比较慢。这个坑是直到第十周开会的时候，我们知道了有石振兴的代码可以参考，才参考着完成了实现，这里代码工作主要由cdy完成。

（这之后我们就从参考bbl-ucore代码，变成了主要参考石振兴的代码在上面做改动，这其实也造成一些麻烦，因为石振兴在移植的时候并不是所有地方都处理干净了）

同时开始了文档的编写。这个时候文档编写工作还是比较细致（拖拉）的，由于代码量比较小，所以对大部分代码进行了梳理和讲解，也有关于原理的详细介绍。到第十周周末lrd基本完成了lab3之前的文档，十一周的时候cdy完成了Lab4的文档，这一部分文档的质量我们感觉相对后半部分是比较好的，没有赶工的痕迹。

## lab4,lab5:内核态使用系统调用

cdy移植了lab4，lab4的内核进程使用没有太大的坑，需要做的是一些内存管理的修改。从这之后的代码移植由lrd进行，但是移植lab5的时候遇到了一些麻烦，主要问题在于从内核态使用系统调用的处理上。（ucore需要在内核态调用sys_exec系统调用，来启动第一个用户程序）

我们在用户态是通过`ecall`来进入内核态trap处理，进行系统调用的。但我们知道，在内核态（S mode)调用ecall，将会进入M态，尝试调用SBI的接口。在bbl-ucore里，由于可以直接修改M态的代码（bbl,riscv-pk), 所以直接修改了M态对ecall的处理，把它转发给S mode的trap handler. 但是使用QEMU和OpenSBI， 就不能直接修改M态代码（我们也不具备这个能力）。最终采用了一个临时的补救方法：因为我们需要的只是从S态代码跳转到S态的trap handler并转发给相应的syscall函数，那么未必需要ecall指令，用ebreak指令就可以产生这样的中断，我们通过给寄存器设置一些特殊的值来区分“正常的断点中断”和“伪装成断点中断的内核态系统调用“，解决了这个问题。这样做确实不太优雅，也不太安全，只是”先跑起来再说“的一个work around。我们希望能有更合理的实现（比如运行第一个用户程序的时候不使用系统调用？）

```c
void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
        case CAUSE_MISALIGNED_FETCH:
            cprintf("Instruction address misaligned\n");
            break;
        case CAUSE_FETCH_ACCESS:
            cprintf("Instruction access fault\n");
            break;
        case CAUSE_ILLEGAL_INSTRUCTION:
            cprintf("Illegal instruction\n");
            break;
        case CAUSE_BREAKPOINT:
            cprintf("Breakpoint\n");
            if(tf->gpr.a7 == 10){
                tf->epc += 4;
                syscall(); 
            }
            break;
    }
}
```

## lab6: 调度算法的调参（

lab6实际上没有多大问题，但是问题出在stride调度算法的测试程序不能输出”运行时间和优先级成正比“的输出结果"1,2,3,4,5"。经过思考之后，感觉这个现象是由于我们使用的时钟频率和之前bbl不一样导致的，导致测试的时候调度的时间片的个数不够多。多试了一些调度参数的组合之后，得到了正常的结果。

## lab7，lab8：syscall和用户程序的bug

lab7的代码基本上平台无关，手动把不同的地方修改之后就差不多了。

lab8的正常运行踩了很多坑，首先是修改的地方很多： stdin, trap.c, ramdisk, proc.c....使用文件系统之后几乎所有组件都受到影响。

另外石振兴的syscall处理的代码里有一个重大bug：把参数当成了32位整数。尤其是处理地址的时候，我们的地址是64位的，如果用32位的参数进行处理，将导致大量奇怪的bug。由于我们的理解不够深刻。并没有立刻发现这个bug(实际上这个bug早在lab5就应该发现)，而是在lab8程序运行异常的时候一点点顺藤摸瓜发现的这个bug。

石振兴的`ucore_rv64_porting.md`曾经提到过”整个文件系统中都要注意虚拟地址变为了64位。syscall.c, syscall.h, “， 但是不知道为啥这一句后来又删掉了。代码里似乎也没有注意这一点进行修改，还是把64位指针当成32位的参数（uint32_t)进行传参和解析。这就使人费解。尤其是`sys_exec`, 依次给syscall传入一个32位的系统调用编号，一个64位的指针，一个32位整数，又一个64位指针。然后syscall会把后三个参数解析成5个32位整数，分别在5个通用寄存器里传递参数，然后内核态的syscall处理似乎完全不知道这一档子事，直接把三个参数解析出来的第0，1，2个32位整数 暗中类型转换成64位整数，当成原先的三个参数使用，那完全不可能跑出正确的结果啊。。。

然后 https://github.com/chyyuu/ucore_os_lab/tree/ricv64-opensbi 似乎也是这么干的。。。左思右想，想不出这么写能在64位平台上正常工作的理由。然后我们就把一大堆32位整数改成了64位整数，终于正常一点跑起来了。

```c
/*
https://github.com/chyyuu/ucore_os_lab/blob/riscv64-priv-1.10/labcodes_answer/lab8/user/libs/syscall.c
*/
static inline int syscall(int num, ...) {
    va_list ap;
    va_start(ap, num);
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint32_t);
    }
    va_end(ap);

    asm volatile (
        "lw a0, %1\n"
        "lw a1, %2\n"	
        "lw a2, %3\n"
        "lw a3, %4\n"
        "lw a4, %5\n"
        "lw a5, %6\n"
        "ecall\n"
        "sw a0, %0"
        : "=m" (ret)
        : "m" (num),
          "m" (a[0]),
          "m" (a[1]),
          "m" (a[2]),
          "m" (a[3]),
          "m" (a[4])
        : "memory"
      );
    return ret;
}

int sys_exec(const char *name, int argc, const char **argv) {
    return syscall(SYS_exec, name, argc, argv);
}
```

然后lab8的终端还改了一个奇怪的地方，就是runcmd的函数里的一个数组，会出问题。追踪出错的地方，是`vmm.c`里面`copy_string()`函数的`user_mem_check()` 无法通过。很可能是我们的页表实现里面有潜在的bug，需要进一步修改。

```c
int runcmd(char *cmd) {
    static char argv0[BUFSIZE];
    static const char *argv[EXEC_MAX_ARG_NUM + 1];//就这个数组，不加static就会出错
    char *t;
    int argc, token, ret, p[2];
```