# makefile 简介

makefile是一种自动构建项目的工具。在我们的ucore实现中， 我们使用了makefile进行项目的自动构建。下面我们来讨论一些关于makefile文件的基本知识。

## makefile文件的基本结构

makefile文件的基本结构是目标（target）、依赖（prerequisites）和命令（command）。每一个makefile文件的内部都包含了许多这样的生成规则。

```makefile
target ... : prerequisites ...
    command
    ...
    ...
```

这三个要件描述了一种依赖关系：当依赖比目标文件新的时候，则命令被执行。当我们在命令行输入make的时候，make程序会自动寻找目录下的makefile文件，依次检查依赖关系（以及依赖关系的依赖关系），最终按照合适的顺序执行命令，保证所需要的目标文件被生成。

## 使用宏变量

为了方便把重复的内容进行统一的管理，可以使用makefile的变量。这样，对于重复内容的修改就变成了对变量值的修改。我们一般使用大写的字符串表示变量，比如`OBJ`，`OBJECTS`等。变量定义的方法非常简单，只需要通过等号赋值即可，如下

```makefile
OBJ = a.o b.o
```

在需要使用变量的地方，我们用`$(变量名)`来使用变量。比如一段makefile代码如下所示：

```makefile
main: a.o b.o
	gcc a.o b.o -o main
```

使用了宏变量后就变成了下面这样：

```makefile
OBJ = a.o b.o
main: $(OBJ)
	gcc $(OBJ) -o main
```

如果我们需要添加一个新的`.o`文件，我们只需要修改第一行代码就可以啦~

变量也可以使用`shell`命令来定义，比如：

```makefile
cur_dir   := $(shell pwd)
```

使用这条命令会把当前所在的目录赋给变量`cur_dir`，这是也一种非常好的将shell指令和makefile结合起来的方式。

## 控制流和函数

在makefile中，可以使用`if`等方法控制makefile执行的控制流。比如下面这个例子：

```makefile
foo: $(objects)
ifeq ($(CC),gcc)
    $(CC) -o foo $(objects) $(libs_for_gcc)
else
    $(CC) -o foo $(objects) $(normal_libs)
endif
```

这里使用了`ifeq`指令判断变量`CC`是否为`gcc`，如果是则执行链接`gcc`相关的库，否则采取另外一套操作。类似的关键字还有`ifneq`（如果不相等）、`ifdef`（如果某个变量已定义）、`ifndef`（如果某个变量未定义）。

makefile中也可以使用函数。函数调用遵循下面的范式：

```makefile
$(<function> <arguments>)
```

makefile提供了许多函数，如字符处理函数，目录操作函数等等，可以帮助我们完成一些makefile中的常用操作。关于如何自定义函数的内容，感兴趣的同学可以自己去了解。

## 参考资料

[跟我一起写makefile](https://seisman.github.io/how-to-write-makefile/index.html)



