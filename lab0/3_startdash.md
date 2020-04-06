# lab0  3/3 开搞：搭建实验环境

现在让我们搭建基于riscv64的操作系统的开发环境。

提示1：如果你使用windows系统，那么建议在windows subsystem for linux（WSL) 下进行开发。

提示2：我们推荐你在系统里设置一个叫做**RISCV**的环境变量(在bash命令里通过**$RISCV**使用)，作为你安装所有和riscv有关的软件的路径。

理论上最小的软件开发环境只需要：能够编译程序，能够运行程序。系统软件也不例外。

问题在于：我们使用的计算机都是基于x86架构的。如何把程序编译到riscv64架构的汇编？这需要我们使用“目标语言为riscv64汇编的编译器”，在我们的电脑上进行**交叉编译**。如何运行riscv64的程序？这需要我们使用**模拟器**，也就是在x86架构的计算机上，通过软件模拟一个riscv64架构的硬件平台。

放心，不需要你自己写编译器或者造计算机。我们使用现有的riscv-gcc编译器即可。从https://github.com/riscv/riscv-gcc clone下来，然后在x86架构上编译你的riscv-gcc编译器为可执行的x86程序，就可以通过运行它，来把你的程序编译成riscv架构的可执行文件了。这有点绕口，理解起来需要一点编译原理的基础。

其实没必要那么麻烦，你大可使用别人已经编译好的编译器的可执行文件，也就是所谓的**预编译（prebuilt）**版本，下载下来，放在你喜欢的地方，配好路径（把编译器的位置加到系统的PATH环境变量里），就能在终端使用了。我们推荐使用sifive公司提供的预编译工具链，进入 https://www.sifive.com/boards ，找到 “Prebuilt RISC‑V GCC Toolchain and Emulator”，下载“GNU Embedded Toolchain ”中适合你的操作系统的版本即可。

关于模拟器，我们给出使用spike的解决方案。

从 https://github.com/riscv/riscv-isa-sim 把spike模拟器的源代码clone下来，然后照着它的提示做：

```bash
$ [sudo] apt-get install device-tree-compiler
$ mkdir build
$ cd build
$ ../configure --prefix=$RISCV
$ make
$ [sudo] make install 
```

[sudo]表示这个sudo是可选的。如果你不使用sudo的时候出现了“Permission Denied”之类的失败提示，那就在bash命令前面加上sudo再试试。（"sudo试试"有的时候和"重启试试"一样管用）

注意这里用到了环境变量 **RISCV**。如果你不想定义这么一个环境变量，也可以在用到这个环境变量的地方手动替换成你想安装riscv相关软件（或者说，“工具链”）的路径。

比如: `../configure --prefix=/usr/local/bin/riscv`

注意在做这一步的时候，环境变量**RISCV**(或者上面的`/usr/local/bin/riscv`或者其他什么路径)应该是一个存在的路径。

另外，我们还需要配置riscv-pk.

....todo...