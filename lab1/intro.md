# lab1 0/n: 断,都可以断

*弱水汩其为难兮，路中断而不通。*

现在我们要在最小可执行内核的基础上, 支持中断机制, 并且用时钟中断来检验我们的中断处理系统。

**中断**（interrupt）机制，就是不管CPU现在手里在干啥活，收到“中断”的时候，都先放下来去处理其他事情，处理完其他事情可能再回来干手头的活。

例如，CPU要向磁盘发一个读取数据的请求，由于磁盘速度相对CPU较慢，在“发出请求”到“收到磁盘数据"之间会经过很多时间周期，如果CPU干等着磁盘干活就相当于CPU在磨洋工。因此我们可以让CPU发出读数据的请求后立刻开始干另一件事情。但是，等一段时间之后，磁盘的数据取到了，而CPU在干其他的事情，我们怎么办才能让CPU知道之前发出的磁盘请求已经完成了呢？我们可以让磁盘给CPU一个“中断”，让CPU放下手里的事情来接受磁盘的数据。

再比如，为了保证CPU正在执行的程序不会永远运行下去，我们需要定时检查一下它是否已经运行“超时”。想象有一个程序由于bug进入了死循环，如果CPU一直运行这个程序，那么其他的所有程序都会因为等待CPU资源而无法运行，造成严重的资源浪费。但是检查是否超时，需要CPU执行一段代码，也就是让CPU暂停当前执行的程序。我们不能假设当前执行的程序会主动地定时让出CPU，那么就需要CPU定时“打断”当前程序的执行，去进行一些处理，这通过时钟中断来实现。

从这些描述我们可以看出，中断机制需要软件硬件一起来支持。硬件进行中断和异常的发现，然后交给软件来进行处理。回忆一下组成原理课程中学到的各个控制寄存器以及他们的用途（下一小节会进行简单回顾），这些寄存器构成了重要的**硬件/软件接口**。由此，我们也可以得到在一般OS中进行中断处理支持的方法：

- 编写相应的中断处理代码
- 在启动中正确设置控制寄存器
- CPU捕获异常
- 控制转交给相应中断处理代码进行处理
- 返回正在运行的程序

由于中断处理需要进行较高权限的操作，中断处理程序一般处于**内核态**，或者说，处于“比被打断的程序更高的特权级”。注意，在RISCV里，中断(interrupt)和异常(exception)统称为"trap"。

> 扩展
>
> The RISC-V Instruction Set Manual Volume I: Unprivileged ISA （Document Version 20191213） 
>
> 1.6
>
> We use the term **exception** to refer to an unusual condition occurring at run time associated with an instruction in the current RISC-V hart. 
>
> We use the term **interrupt** to refer to an external asynchronous event that may cause a RISC-V hart to experience an unexpected transfer of control.
> We use the term **trap** to refer to the transfer of control to a trap handler caused by either an
> exception or an interrupt.

## 寄存器

除了32个通用寄存器之外，RISCV架构还有大量的 **控制状态寄存器** **Control and Status Registers**(CSRs)。其中有几个重要的寄存器和中断机制有关。

有些时候，禁止CPU产生中断很有用。（就像你在做重要的事情，如操作系统lab的时候，并不想被打断）。所以，`sstatus`寄存器(Supervisor Status Register)里面有一个二进制位`SIE`(supervisor interrupt enable，在RISCV标准里是2^1 对应的二进制位)，数值为0的时候，如果当程序在S态运行，将禁用全部中断。（对于在U态运行的程序，SIE这个二进制位的数值没有任何意义），`sstatus`还有一个二进制位`UIE`(user interrupt enable)可以在置零的时候禁止用户态程序产生中断。

在中断产生后，应该有个**中断处理程序**来处理中断。CPU怎么知道中断处理程序在哪？实际上，RISCV架构有个CSR叫做`stvec`(Supervisor Trap Vector Base Address Register)，即所谓的”中断向量表基址”。中断向量表的作用就是把不同种类的中断映射到对应的中断处理程序。如果只有一个中断处理程序，那么可以让`stvec`直接指向那个中断处理程序的地址。

对于RISCV架构，`stvec`会把最低位的两个二进制位用来编码一个“模式”，如果是“00”就说明更高的SXLEN-2个二进制位存储的是唯一的中断处理程序的地址(SXLEN是`stval`寄存器的位数)，如果是“01”说明更高的SXLEN-2个二进制位存储的是中断向量表基址，通过不同的异常原因来索引中断向量表。但是怎样用62个二进制位编码一个64位的地址？RISCV架构要求这个地址是四字节对齐的，总是在较高的62位后补两个0。

> ​	扩展
>
> 在旧版本的RISCV privileged ISA标准中（1.9.1及以前），RISCV不支持中断向量表，用最后两位数编码一个模式是1.10版本加入的。可以思考一下这个改动如何保证了后向兼容。[历史版本的ISA手册](https://github.com/riscv/riscv-isa-manual/releases/tag/archive)
>
> 1.9.1版本的RISCV privileged architecture手册：
>
> 4.1.3 Supervisor Trap Vector Base Address Register (stvec) The stvec register is an XLEN-bit read/write register that holds the base address of the S-mode trap vector. When an exception occurs, the pc is set to stvec. The stvec register is always aligned to a 4-byte boundary

当我们触发中断进入 S 态进行处理时，以下寄存器会被硬件自动设置，将一些信息提供给中断处理程序：

**sepc**(supervisor exception program counter)，它会记录触发中断的那条指令的地址；

**scause**，它会记录中断发生的原因，还会记录该中断是不是一个外部中断；

**stval**，它会记录一些中断处理所需要的辅助信息，比如指令获取(instruction fetch)、访存、缺页异常，它会把发生问题的目标地址或者出错的指令记录下来，这样我们在中断处理程序中就知道处理目标了。

> 扩展
>
> The RISC-V Instruction Set Manual Volume II: Privileged Architecture 
>
> （Document Version 20190608-Priv-MSU-Ratified）
>
> 4.1.1 Supervisor Status Register (sstatus)
>
> The SIE bit enables or disables all interrupts in supervisor mode. When SIE is clear, interrupts
> are not taken while in supervisor mode. When the hart is running in user-mode, the value in
> SIE is ignored, and supervisor-level interrupts are enabled. The supervisor can disable individual
> interrupt sources using the sie CSR.
> The SPIE bit indicates whether supervisor interrupts were enabled prior to trapping into supervisor
> mode. When a trap is taken into supervisor mode, SPIE is set to SIE, and SIE is set to 0. When
> an SRET instruction is executed, SIE is set to SPIE, then SPIE is set to 1.
> The UIE bit enables or disables user-mode interrupts. User-level interrupts are enabled only if UIE
> is set and the hart is running in user-mode. The UPIE bit indicates whether user-level interrupts
> were enabled prior to taking a user-level trap. When a URET instruction is executed, UIE is set
> to UPIE, and UPIE is set to 1. User-level interrupts are optional. If omitted, the UIE and UPIE
> bits are hardwired to zero.
>
> 4.1.9 Supervisor Exception Program Counter (sepc)
>
> When a trap is taken into S-mode, sepc is written with the virtual address of the instruction
> that was interrupted or that encountered the exception. Otherwise, sepc is never written by the
> implementation, though it may be explicitly written by software.
>
> 4.1.10 Supervisor Cause Register (scause)
>
> When a trap is taken into S-mode, scause is written with a code indicating the event that caused the trap. Otherwise, scause is never written by the implementation, though it may be explicitly written by
> software.
>
> 4.1.11 Supervisor Trap Value (stval) Register
>
> When a trap is taken into S-mode, stval is written with exception-specific information to assist software
> in handling the trap. Otherwise, stval is never written by the implementation, though it may
> be explicitly written by software. The hardware platform will specify which exceptions must set
> stval informatively and which may unconditionally set it to zero.
> When a hardware breakpoint is triggered, or an instruction-fetch, load, or store address-misaligned,
> access, or page-fault exception occurs, stval is written with the faulting virtual address. On an
> illegal instruction trap, stval may be written with the first XLEN or ILEN bits of the faulting
> instruction as described below. For other exceptions, stval is set to zero, but a future standard
> may redefine stval’s setting for other exceptions.

## 特权指令

RISCV支持以下和中断相关的特权指令：

**ecall**(environment call)，当我们在 S 态执行这条指令时，会触发一个 ecall-from-s-mode-exception，从而进入 M 模式中的中断处理流程（如设置定时器等）；当我们在 U 态执行这条指令时，会触发一个 ecall-from-u-mode-exception，从而进入 S 模式中的中断处理流程（常用来进行系统调用）。

**sret**，用于 S 态中断返回到 U 态，实际作用为pc←sepc，回顾**sepc**定义，返回到通过中断进入 S 态之前的地址。

**ebreak**(environment break)，执行这条指令会触发一个断点中断从而进入中断处理流程。

**mret**，用于 M 态中断返回到 S 态或 U 态，实际作用为pc←mepc，回顾**sepc**定义，返回到通过中断进入 M 态之前的地址。（一般不用涉及）