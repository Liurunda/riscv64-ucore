# riscv64 ucore tutorial组 大实验报告

曹鼎原  2017011417  刘润达  2018013412

## 实验目标描述

1. 编写类似rcore step-by-step tutorial的, 从零开始自己构建一个OS的文档(基础目标）
2. 加入多核的支持, 在真实多核硬件上进行演示, 提供类似简化过的pthread之类的接口供用户程序使用多核特性.（挑战目标）
3. 设计基于多核特性的新lab / challenge

在进行过程中，放弃了多核特性，目标改为：完成ucore到riscv64的移植，编写完成step by step的文档，并完成实验题目。

## 相关工作介绍

ucore(x86)，操作系统课程长期使用的实验框架和配套文档, 这是我们需要移植的对象。

rcore tutorial, 基于riscv64用rust编写教学操作系统的代码和文档。我们希望参照rcore tutorial的格式来进行文档的编写。关于QEMU的Open SBI的使用我们参考了rcore。

bbl-ucore（张蔚），基于berkeley bootloader, riscv32的ucore。riscv64-spec-1.10(石振兴)，基于berkeley bootloader, riscv64的ucore。我们的代码主要参考了这两个项目。

## 小组成员分工

•曹鼎原：lab4, lab6, lab7的文档编写，lab1-lab4的代码移植。Lab2 best fit, lab3 clock置换算法的参考代码编写。添加项目组成，编写关于Makefile的讲解。

•刘润达：lab1,2,3,5,8的文档编写，lab5之后的代码移植和调试。出练习题，给代码框架挖空，尝试进行自动评分。在文档里添加执行流的分析。

## 关于代码框架移植的描述

### lab1: 固件、模拟器使用的选择

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

### lab2, lab3: 内存管理，多级页表

原先ucore的内存管理方案是：启动时为裸机模式(直接使用物理内存)，然后在`pmm_init()`初始化页表并使用虚拟内存。bbl-ucore采用了这个方案，变量名都用了原来的（如页表基址使用`cr3`而不是`satp`，我们的代码里目前也使用了很多这样legacy的变量名，需要进一步修改）。

rcore的内存管理方案是：在汇编的内核入口点`entry.S`里就实现一个简单的虚拟内存“大页”映射，然后进行更加精细的重映射。

我们在两种初始化方案之间纠结了一下，没有很快地确定下来，开发过程中有的时候采用第一种方案，有的时候采用第二种方案，还导致了一些bug。最后才确定统一使用较为简单的（不出bug的）第二种方案。目前在代码实现中，缺乏更加精细的内核重映射，相对rcore是一个不足。

我们在移植过程中，还遇到一个困难，就是要从Sv32移植到Sv39，从二级页表的使用改为三级页表的使用，稍微有点复杂度，我们有一些畏难情绪，工作也比较慢。这个坑是直到第十周开会的时候，我们知道了有石振兴的代码可以参考，才参考着完成了实现，这里代码工作主要由cdy完成。

（这之后我们就从参考bbl-ucore代码，变成了主要参考石振兴的代码在上面做改动，这其实也造成一些麻烦，因为石振兴在移植的时候并不是所有地方都处理干净了）

同时开始了文档的编写。这个时候文档编写工作还是比较细致（拖拉）的，由于代码量比较小，所以对大部分代码进行了梳理和讲解，也有关于原理的详细介绍。到第十周周末lrd基本完成了lab3之前的文档，十一周的时候cdy完成了Lab4的文档，这一部分文档的质量我们感觉相对后半部分是比较好的，没有赶工的痕迹。

lab2和lab3的代码框架里，后来又加入了best-fit物理内存分配和clock页面置换算法的实现。

### lab4,lab5:内核态使用系统调用

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

### lab6: 调度算法的调参（

13周之前改的时候, 感觉lab6实际上没有多大问题，但是问题出在stride调度算法的测试程序不能输出”运行时间和优先级成正比“的输出结果"1,2,3,4,5"。经过思考之后，感觉这个现象是由于我们使用的时钟频率和之前bbl不一样导致的，导致测试的时候调度的时间片的个数不够多。多试了一些调度参数的组合之后，得到了正常的结果。

13周后改实验框架的时候, 发现lab6代码的进程控制块初始化有问题, 改了之后就好了，之前输出了正确的结果可能是一种幸运。

### lab7，lab8：syscall和用户程序的bug

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



## 关于文档工作的描述

文档部署演示：https://1790865014.gitbook.io/ucore-step-by-step/intro-1 

我们的文档分成lab0：实验环境搭建，lab0.5: 最小可执行内核和后面对应8个实验的lab1到lab8, 每个lab一章，可以认为一共十章，每章分三节或更多，介绍代码的实现细节和相关理论知识。

 在13周的时候，我们完成了文档的第一个版本，对应所有lab都有了讲解，但是赶工痕迹比较多，例如lab8的文档结构比较混乱。

13周之后进行了一些改进，如lab8文档结构按照文件系统功能实现的层次重新组织，加入了关于Makefile的介绍。

> 相对于上百万行的现代操作系统(linux, windows), 几千行的ucore是一只"麻雀"。但这只麻雀依然是一只胖麻雀，我们一眼看不过来几千行的代码。所以，我们要再做简化，先用好刀法，片掉麻雀的血肉, 搞出一个"麻雀骨架"，看得通透，再像组装哪吒一样，把血肉安回去，变成一个活生生的麻雀。这就是我们的ucore step-by-step tutorial的思路。

麻雀有骨头，有肉，有皮毛。地位并不相同。骨头要嚼碎了咽，肉要吞，皮毛就随意了。

- “骨头”：操作系统核心原理/知识点，以及在ucore中的实现。应当在文本和编程练习中反复体现。

- “肉”：需要掌握的知识点，但不是那么核心，在文本中体现。

- “皮毛”：有趣的知识点，但对本课程也许不是必须的。选择一些，以补充的形式出现。

我们希望在教学文档里呈现的知识也分核心和外围，一套教学文档应当把知识按照不同的层次，呈现为一个完善的系统。

最终我们希望文档能够实现“麻雀论”：

- 核心的知识（麻雀骨架）重点突出，

- 其他需要掌握的知识（麻雀肉）覆盖全面，

- 额外补充的知识（麻雀皮毛）作为添头，不喧宾夺主。

对于“麻雀皮毛”，我们希望在文档里以引用的格式，加入”扩展“ ”趣闻“之类的模块。

一部分比较重要的前置知识可能和操作系统本身联系不是特别紧密，我们作为"须知"模块和正文剥离开。

文档的正文和练习题，体现的是麻雀的骨肉（核心知识以及其他需要掌握的知识）。

只要掌握核心的概念和理论知识，能弄清楚操作系统重要功能的完整执行流，就可以认为消化了操作系统的骨肉。

为此，我们参照原先的ucore tutorial在文档里增加了”项目组成“，解释各个文件的作用。增加了”执行流“，简要分析了操作系统执行重要功能时候代码执行流所经过的函数。

## 其他工作

我们尝试进行自动化的评分和测试。感觉通过独立于内核的脚本进行评测，有些麻烦。采用的做法是：将用于“评分”的部分，放到内核里，通过编译选项确定是否把“评分”的代码加入编译。但这里还不是很完善。

```c
#ifdef ucore_test 
//当进行评分时执行的代码
#else
//当不进行评分的时候执行的代码
#endif 
```

我们对实验框架进行了挖空，提供给填空的练习题使用。目前还有一些注释不是很完善（过时），需要完善。

## 实验总结和后续设想

在完成这个作业的过程中，我们既需要进行代码的编写调试，也需要进行文档的设计编写。需要搞明白很多之前自己做实验时不需要搞明白的细节，加深了我自己对操作系统的理解。同时也体会到一套高质量的教学文档、实验设计是很不容易的，需要做大量的权衡舍弃，还需要大量细致的工作，我们现在的成果依然不能直接用于明年的操作系统教学，还需要接下来半年做进一步改进。

后续的工作，主要就围绕”让这套教学文档能够真正使用在教学中“。

最关键的是实验习题的完善：框架的注释需要完善好，习题的要求需要更加明确和统一，并且一些题目的可行性，难度和知识性还需要进行讨论和验证。另外还要完善好自动评分的代码。在下学期正式使用之前，最好找同学试做一下。

其次是文档本身质量的完善：虽然我们尽量做到叙述准确，覆盖全面，有时自我感觉也很良好，但肯定免不了有一些错漏，有些粗糙的地方可能要打回重写。按照”覆盖关键功能执行流“的思路，对文档重新审视。增加更多的”趣闻“ ”扩展“ ”须知",改善文档阅读的体验。

另外，我们本学期一个很大的不足就是较少进行讨论交流，也没有找过其他同学对我们的文档进行review。准备找三到五个感兴趣的同学，暑假/下学期/寒假全面检查一遍文档。

## 附：工作日志

#### 2020.6.2 week16 Tues.

调试自动测试脚本, 在文档中加入项目组成、执行流。准备增加关于Makefile的讲解。

#### 2020.5.25 week14 Mon.

基本完成所有的练习用实验框架, 对lab8文档进行了一些改动

#### 2020 5.15 Week13 Fri.

完成了全部tutorial文档(初稿?)

#### 2020.5.8 Week 12 Fri.

调通了全部代码

完成了lab1到lab6的文档, 完成了lab8的部分文档

#### 2020.5.3 Week 11 sun.

文档写到了lab4

https://1790865014.gitbook.io/ucore-step-by-step/intro-5/1_process

代码改到了lab7

https://github.com/Liurunda/riscv64-ucore/tree/lab7

#### 2020.4.26 Week10 Sun.

改好了Lab3，lab4的代码

完成了lab3 tutorial的大部分

#### 2020.4.20 Week10 Mon.

进行交流, 发现其实前人实现过完整的riscv64的ucore, 非常感动. 预计代码方面的进度可以大大加快.

#### 2020.4.19 Week9 Sun.

完成了lab2简化后的代码和文档(只包括物理内存管理和内核初始映射)

lab3的坑还没有解决

#### 2020.4.18 Week9 Sat.

写完了lab1的文档以及整理出代码

https://1790865014.gitbook.io/ucore-step-by-step/v/tutorial/intro-2

https://github.com/Liurunda/riscv64-ucore/tree/lab1/

发现lab2, lab3的代码移植遇到一些困难：

需要从sv32的二级页表迁移到sv39的三级页表，但是原先的代码并不是很好懂...感觉可能需要重写页表管理模块...

#### 2020.4.14 Week9 Tues.

初步写完了最小可执行内核的文档, 并整理出了代码

https://github.com/Liurunda/riscv64-ucore/tree/lab0

#### 2020.4.12 Week8 Sun.

cdy把bbl-ucore的lab2改出来了， lrd在吭哧吭哧写lab1的文档，半天写了两页

#### 2020.4.11 Week8 Sat.

cdy大力写了一波, 把bbl-ucore的lab1改出来了(现在不用bbl了, 改用qemu-virt的OpenSBI), 需要抓紧改后面的代码, 并同时开始写lab0和lab1的文档...

lab0的文档已经搞出来了

https://1790865014.gitbook.io/ucore-step-by-step/v/tutorial/intro

#### 2020.4.10 Week8 Fri.

踩到了坑...之前以为正常跑起来的bbl-ucore lab1其实并不正常...

链接的时候一个relocation truncated to fit错误似乎改不太动...

最新的riscv-pk似乎找不到sbi的接口.... 不知道怎么从上面改出来....

放弃spike, 改在qemu上搞(有自带的OpenSBI)???

之前部署了一下gitbook, 但是还没有什么内容

https://1790865014.gitbook.io/ucore-step-by-step/v/tutorial/

## 第八周

#### 2020.4.3 Week7 Fri.

搭好了开发环境, 简单改动了bbl-ucore的lab1并使用riscv64工具链编译成功

意识到对不熟悉的人来说, 配置riscv的工具链(包括编译器 + 模拟器)不是一件容易的事情, 计划在tutorial里提供完善的教程, 以及一些常用环境下预编译的工具链(如x86 CPU上的ubuntu)

## 第七周

#### 2020.3.29 Week6 Sun.

定了一下干活方式:

首先搞出能在riscv64跑的完整ucore代码, 然后一个一个lab的捋, 每个lab都由两人合作, 轮换角色.

下周就开始rush(

#### 2020.3.28 Week6 Sat.

进行了开题前的讨论并rush了开题报告:

https://github.com/Liurunda/riscv64-ucore/blob/master/week6_report/开题报告.md

#### 2020.3.27 Week6 Fri.

lrd: "Real World Multicore Embedded Systems" 的Chapter 6: Operating Systems in Multicore Platforms读完了, 感觉最后也没有特别细节的东西...有点浪费时间...

#### 2020.3.26 Week6 Thu.

和rcore remake组一起和陈老师讨论, 交流了关于设计目标的一些问题.

我们组基本确定除了lab1, 实验题目先照抄原有ucore实验, 主要工作是编写step-by-step tutorial

#### 2020.3.24 Week6 Tues.

组内讨论. 为了将来支持多核, 暂定使用Spike作为模拟器(试了试QEMU的riscv64 -smp选项, 发现似乎不能使用多于1个的CPU?也许是配置不对?)

准备进行多核OS写法的调查, 阅读 "Real World Multicore Embedded Systems" 的Chapter 6: Operating Systems in Multicore Platforms

#### 2020.3.23 Week6 Mon.

课上和老师进行了交流，细化了基础目标是做step-by-step tutorial，提高目标是支持riscv64多核。

todo:

和老师进一步交流， 和rcore tutorial重构组交流， 和王润基，贾跃凯交流多核实现的经验，做前期调研和计划，准备第6周周末报告

## 第六周

#### 2020.3.21 Week5 Sat.

初始化了wiki和仓库, 可以开始干活了?