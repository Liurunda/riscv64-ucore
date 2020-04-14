# lab1 3/n "真正的"入口点

我们在`kern/init/init.c`编写函数`kern_init`, 作为“真正的”内核入口点。为了让我们能看到一些效果，我们希望它能在命令行进行格式化输出。

如果我们在linux下运行一个C程序，需要格式化输出，那么大一学生都知道我们应该`#include<stdio.h>`。于是我们在`kern/init/init.c`也这么写一句。且慢！linux下，当我们调用C语言标准库的函数时，实际上依赖于`glibc`提供的运行时环境，也就是一定程度上依赖于操作系统提供的支持。可是我们并没有把`glibc`移植到ucore里！

怎么办呢？只能自己动手，丰衣足食。QEMU里的OpenSBI固件提供了输入一个字符和输出一个字符的接口，我们一会把这个接口一层层封装起来，提供`stdio.h`里的格式化输出函数`cprintf()`来使用。这里格式化输出函数的名字不使用原先的`printf()`，强调这是我们在ucore里重新实现的函数。

```c
// kern/init/init.c
#include <stdio.h>
#include <string.h>
//这里include的头文件， 并不是C语言的标准库，而是我们自己编写的！

//noreturn 告诉编译器这个函数不会返回
int kern_init(void) __attribute__((noreturn));

int kern_init(void) {
    extern char edata[], end[]; 
    //这里声明的两个符号，实际上由链接器ld在链接过程中定义, 所以加了extern关键字
    memset(edata, 0, end - edata); 
    //内核运行的时候并没有c标准库可以使用，memset函数是我们自己在string.h定义的

    const char *message = "(THU.CST) os is loading ...\n";
    cprintf("%s\n\n", message); //cprintf是我们自己定义的格式化输出函数
   	while (1)
        ;
}
```

接下来就去看看，我们是怎么从OpenSBI的接口一层层封装到格式化输入输出函数的。