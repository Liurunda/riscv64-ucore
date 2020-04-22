# lab0  1/3 溯源: ucore的历史

2006年, MIT的Frans Kaashoek等人参考PDP-11上的UNIX Version 6写了一个可在x86指令集架构上运行的操作系统xv6（基于MIT License)。（cited from [classical ucore](https://chyyuu.gitbooks.io/ucore_os_docs/content/lab0/lab0_2_1_about_labs.html)）

2010年, 清华大学操作系统教学团队参考MIT的教学操作系统xv6, 开发了在x86指令集架构上运行的操作系统ucore, 多年来作为操作系统课程的实验框架使用, 已经成为了大家口中的"祖传实验". 

ucore麻雀虽小，五脏俱全。在不超过5k的代码量中包含虚拟内存管理、进程管理、处理器调度、同步互斥、进程间通信、文件系统等主要内核功能，充分体现了“小而全”的指导思想。

到了如今，x86指令集架构的问题渐渐开始暴露出来。 虽然在PC平台上占据绝对主流，但出于兼容性考虑x86架构仍然保留了许多的历史包袱，用于教学的时候总有些累赘。另一方面，为了更好的和计算机组成原理课程衔接，将ucore移植到RISC-V架构势在必行。

> **趣闻**
>
> Intel曾经在1989到2000年之间开发过一种[Itanium](https://en.wikipedia.org/wiki/Itanium)处理器，它基于全新的IA-64架构, 但这个指令集/处理器产品线以失败告终。其中一个失败原因就是向后兼容性太差，2001年有人测试在Itanium处理器上运行原先的x86软件时，性能仅为同时代x86奔腾处理器的十分之一。

由图灵奖得主设计的年轻的精简指令集架构RISC-V(reduced instruction set computer V)具有诸多优势，特别是在教学方面。其设计优雅，开源共享，没有x86指令集那样的历史包袱，学起来更加轻松，为计算机组成原理和操作系统课程的教学提供了一种新思路。

> **趣闻**
>
> RISCV在嵌入式领域异军突起。嵌入式领域的巨头ARM公司受到威胁后，上线了一个网站riscv-basics.com，把RISC-V批判了一番，批判的方面包括：成本、生态系统、碎片化风险、安全性问题、设计验证。但最终迫于业界舆论恶评，ARM关闭了该网站。（cited from [Wikipedia: RISCV](https://zh.wikipedia.org/wiki/RISC-V#历史)）

我们将ucore的代码移植到64位的RISC-V指令集架构，并借鉴[rcore tutorial](https://rcore-os.github.io/rCore_tutorial_doc/)的做法，改进实验指导书。通过本教程，你可以一步一步，一个模块一个模块地从零开始搭建出一个可以运行简单命令行的操作系统。由于使用了step by step的组织方式，每一章都假设你已经完成了前一章的内容阅读和实践，所以建议完成了前一章的实验学习再进入下一章。实验的所有参考代码可以在[这里](https://github.com/Liurunda/riscv64-ucore/)找到。

那么还等什么，我们现在开始吧！

step by step, to the light of ucore!