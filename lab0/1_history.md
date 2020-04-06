# lab0  1/3 溯源: ucore的历史

2006年, MIT的Frans Kaashoek等人参考PDP-11上的UNIX Version 6写了一个可在x86指令集架构上运行的操作系统xv6（基于MIT License)。（cited from [classical ucore](https://chyyuu.gitbooks.io/ucore_os_docs/content/lab0/lab0_2_1_about_labs.html)）

2010年, 清华大学操作系统教学团队参考MIT的教学操作系统xv6, 开发了在x86指令集架构上运行的操作系统ucore, 多年来作为操作系统课程的实验框架使用, 已经成为了大家口中的"祖传实验". 

ucore麻雀虽小，五脏俱全。此“麻雀”包含虚拟内存管理、进程管理、处理器调度、同步互斥、进程间通信、文件系统等主要内核功能，总的内核代码量（C+asm）不会超过5K行。充分体现了“小而全”的指导思想。

ucore也并不完美。x86指令集架构历史包袱多, 虽然在PC平台上占据绝对主流，但用于教学的时候总有些累赘。

年轻的精简指令集架构RISC-V，设计优雅，简洁明了，开源共享，为计算机组成原理和操作系统课程的教学提供了一种新思路，并且在嵌入式领域异军突起。嵌入式领域的巨头ARM公司受到威胁后，上线了一个网站riscv-basics.com，把RISC-V批判了一番，批判的方面包括：成本、生态系统、碎片化风险、安全性问题、设计验证。但最终迫于业界舆论恶评，ARM关闭了该网站。（cited from [Wikipedia](https://zh.wikipedia.org/wiki/RISC-V#历史)）

我们将ucore的代码移植到64位的RISC-V指令集架构，并借鉴[rcore tutorial](https://rcore-os.github.io/rCore_tutorial_doc/)的做法，改进实验指导书。

step by step, to the light of ucore!