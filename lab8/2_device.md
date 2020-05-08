# lab8 2/n 设备

在本实验中，为了统一地访问设备(device)，我们可以把一个设备看成一个文件，通过访问文件的接口来访问设备。目前实现了 stdin 设备文件文件、stdout 设备文件、disk0 设备。stdin 设备就是键盘，stdout 设备就是 CONSOLE（串口、并口和文本显示器），而 disk0 设备是承载 SFS 文件系统的磁盘设备。下面我们逐一分析 ucore 是如何让用户把设备看成文件来访问。

### 设备的定义

为了表示一个设备，需要有对应的数据结构，ucore 为此定义了 struct device，如下：

```c
// kern/fs/devs/dev.h
/*
 * Filesystem-namespace-accessible device.
 * d_io is for both reads and writes; the iobuf will indicates the direction.
 */
struct device {
    size_t d_blocks;
    size_t d_blocksize;
    int (*d_open)(struct device *dev, uint32_t open_flags);
    int (*d_close)(struct device *dev);
    int (*d_io)(struct device *dev, struct iobuf *iob, bool write);
    int (*d_ioctl)(struct device *dev, int op, void *data);
};

#define dop_open(dev, open_flags)           ((dev)->d_open(dev, open_flags))
#define dop_close(dev)                      ((dev)->d_close(dev))
#define dop_io(dev, iob, write)             ((dev)->d_io(dev, iob, write))
#define dop_ioctl(dev, op, data)            ((dev)->d_ioctl(dev, op, data))
```

这个数据结构能够支持对块设备（比如磁盘）、字符设备（比如键盘、串口）的表示，完成对设备的基本操作。

但这个设备描述没有与文件系统以及表示一个文件的 inode 数据结构建立关系，为此，还需要另外一个数据结构把 device 和 inode 联通起来，这就是 vfs_dev_t 数据结构。

利用 vfs_dev_t 数据结构，就可以让文件系统通过一个链接 vfs_dev_t 结构的双向链表找到 device 对应的 inode 数据结构，一个 inode 节点的成员变量 in_type 的值是 0x1234，则此 inode 的成员变量 in_info 将成为一个 device 结构。这样 inode 就和一个设备建立了联系，这个 inode 就是一个设备文件。

```c
// kern/fs/vfs/vfsdev.c
// device info entry in vdev_list 
typedef struct {
    const char *devname;
    struct inode *devnode;
    struct fs *fs;
    bool mountable;
    list_entry_t vdev_link;
} vfs_dev_t;
#define le2vdev(le, member)                         \
    to_struct((le), vfs_dev_t, member) //为了使用链表定义的宏, 做到现在应该对它很熟悉了

static list_entry_t vdev_list;     // device info list in vfs layer
static semaphore_t vdev_list_sem; // 互斥访问的semaphore
static void lock_vdev_list(void) {
    down(&vdev_list_sem);
}
static void unlock_vdev_list(void) {
    up(&vdev_list_sem);
}
```

ucore 虚拟文件系统为了把这些设备链接在一起，还定义了一个设备链表，即双向链表 vdev_list，这样通过访问此链表，可以找到 ucore 能够访问的所有设备文件。

注意这里的`vdev_list`对应一个`vdev_list_sem`。在文件系统中，互斥访问非常重要，所以我们将看到很多的`semaphore`, 体会它们如何确保：多进程访问文件系统的时候不出错。

### stdin设备

trap.c改变了对stdin的处理

### stdout设备

### disk0设备

