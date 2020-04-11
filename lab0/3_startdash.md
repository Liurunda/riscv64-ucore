# lab0  3/3 开搞：搭建实验环境

说了这么多，现在该动手了。Make your hands dirty!

如果你使用windows系统，推荐在windows subsystem for linux（WSL) 下进行开发。

方便起见，可以先在终端里设置一个叫做**RISCV**的环境变量(在bash命令里可以通过**$RISCV**使用)，作为你安装所有和riscv有关的软件的路径。在`/etc/profile`里面写一行`export RISCV=/usr/local/riscv`之类的东西就行。

最小的软件开发环境需要：能够编译程序，能够运行程序。开发操作系统这样的系统软件也不例外。

## 编译器

问题在于：我们使用的计算机都是基于x86架构的。如何把程序编译到riscv64架构的汇编？这需要我们使用“目标语言为riscv64机器码的编译器”，在我们的电脑上进行**交叉编译**。

放心，这里不需要你自己写编译器。我们使用现有的riscv-gcc编译器即可。从https://github.com/riscv/riscv-gcc clone下来，然后在x86架构上编译riscv-gcc编译器为可执行的x86程序，就可以运行它，来把你的程序源代码编译成riscv架构的可执行文件了。这有点像绕口令，但只要有一点编译原理的基础就可以理解。不过，这个riscv-gcc仓库很大，而且自己编译工具链总是一件麻烦的事。

其实，没必要那么麻烦，我们大可以使用别人已经编译好的编译器的可执行文件，也就是所谓的**预编译（prebuilt）**工具链，下载下来，放在你喜欢的地方（比如之前定义的**\$RISCV**），配好路径（把编译器的位置加到系统的**PATH**环境变量里, 具体做法可以百度一下），就能在终端使用了。我们推荐使用sifive公司提供的预编译工具链，进入 https://www.sifive.com/boards ，找到 “Prebuilt RISC‑V GCC Toolchain and Emulator”，下载“GNU Embedded Toolchain ”中适合你的操作系统的版本即可。(注意，如果你是wsl, 需要下载适合ubuntu版本的编译器)

配置好后，在终端输入`riscv64-unknown-elf-gcc -v`查看安装的gcc版本, 如果输出一大堆东西且最后一行有`gcc version 某个数字.某个数字.某个数字`，说明gcc配置成功，否则需要检查一下哪里做错了，比如环境变量**PATH**配置是否正确。一般需要把一个形如`..../bin`的目录加到**PATH**里。 

## 模拟器

如何运行riscv64的程序？我们当然可以给大家每个人发一块riscv64架构处理器的开发板，再给大家一人一根JTAG线，让大家把程序烧写到上面去跑，然后各凭本事debug。但还是使用**模拟器（emulator）**更方便一些，也就是在x86架构的计算机上，通过软件模拟一个riscv64架构的硬件平台，从而能够运行riscv64的目标代码。

我们选择的是QEMU模拟器。它的优点在于，内置了一套OpenSBI固件的实现，可以简化我们的代码。

下面我们从[rCore tutorial](https://rcore-os.github.io/rCore_tutorial_doc/chapter2/part5.html)抄写了一段qemu安装的教程。

### 安装模拟器 Qemu

如果你在使用 Linux (Ubuntu) ，需要到 Qemu 官方网站下载源码并自行编译，因为 Ubuntu 自带的软件包管理器 `apt` 中的 Qemu 的版本过低无法使用。参考命令如下：

```sh
$ wget https://download.qemu.org/qemu-4.1.1.tar.xz
$ tar xvJf qemu-4.1.1.tar.xz
$ cd qemu-4.1.1
$ ./configure --target-list=riscv32-softmmu,riscv64-softmmu
$ make -j
$ export PATH=$PWD/riscv32-softmmu:$PWD/riscv64-softmmu:$PATH
```

可查看[更详细的安装和使用命令][riscv-qemu]。



如果你在使用 macOS，只需要 Homebrew 一个命令即可：

```sh
$ brew install qemu
```

最后确认一下 Qemu 已经安装好，且版本在 4.1.0 以上：

```bash
$ qemu-system-riscv64 --version
QEMU emulator version 4.1.1
Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
```

### 使用 OpenSBI

新版 Qemu 中内置了 [OpenSBI][opensbi] 固件（firmware），它主要负责在操作系统运行前的硬件初始化和加载操作系统的功能。我们使用以下命令尝试运行一下：

```bash
$ qemu-system-riscv64 \
  --machine virt \
  --nographic \
  --bios default

OpenSBI v0.4 (Jul  2 2019 11:53:53)
   ____                    _____ ____ _____
  / __ \                  / ____|  _ \_   _|
 | |  | |_ __   ___ _ __ | (___ | |_) || |
 | |  | | '_ \ / _ \ '_ \ \___ \|  _ < | |
 | |__| | |_) |  __/ | | |____) | |_) || |_
  \____/| .__/ \___|_| |_|_____/|____/_____|
        | |
        |_|

Platform Name          : QEMU Virt Machine
Platform HART Features : RV64ACDFIMSU
Platform Max HARTs     : 8
Current Hart           : 0
Firmware Base          : 0x80000000
Firmware Size          : 112 KB
Runtime SBI Version    : 0.1

PMP0: 0x0000000080000000-0x000000008001ffff (A)
PMP1: 0x0000000000000000-0xffffffffffffffff (A,R,W,X)
```

可以看到我们已经在 `qemu-system-riscv64` 模拟的 `virt machine` 硬件上将 `OpenSBI` 这个固件 跑起来了。Qemu 可以使用 `Ctrl+a` 再按下 `x` 退出。

如果无法正常使用 Qemu，可以尝试下面这个命令。

```bash
$ sudo sysctl vm.overcommit_memory=1
```

> **扩展**
>
> 如果对 `OpenSBI` 的内部实现感兴趣，可以看看[RISCV OpenSBI Deep_Dive 介绍文档][riscv_opensbi_deep_dive]。

[riscv_opensbi_deep_dive]: https://content.riscv.org/wp-content/uploads/2019/06/13.30-RISCV_OpenSBI_Deep_Dive_v5.pdf
[riscv-qemu]: https://github.com/riscv/riscv-qemu/wiki
[opensbi]: https://github.com/riscv/opensbi

