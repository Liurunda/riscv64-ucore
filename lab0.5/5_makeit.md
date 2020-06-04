# lab1 5/n Just make it

我们需要：编译所有的源代码，把目标文件链接起来，生成elf文件，生成bin硬盘镜像，用qemu跑起来

这一系列复杂的命令，我们不想每次用到的时候都敲一遍，所以我们使用~~<u>*魔改的*</u>~~~~祖传~~`Makefile`。

我们的`Makefile`还依赖`tools/function.mk`

在源代码的根目录下`make qemu`, 我们就把ucore跑起来了。

它输出一行`(THU.CST) os is loading`, 然后进入死循环。

目前为止的代码可以在[这里](https://github.com/Liurunda/riscv64-ucore/tree/lab0/lab0)找到，遇到困难可以参考。

关于Makefile的语法, 如果不熟悉, 可以查看GNU手册, 或者这份中文教程: https://seisman.github.io/how-to-write-makefile/overview.html