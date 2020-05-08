# lab6 2/n 调度算法框架

调度算法框架实现为一个结构体，其中保存了各个函数指针。通过实现这些函数指针即可实现各个调度算法。结构体的定义如下：

```c
struct sched_class {
    // 调度类的名字
    const char *name;
    // 初始化run queue
    void (*init)(struct run_queue *rq);
    // 把进程放进run queue，这个是run queue的维护函数
    void (*enqueue)(struct run_queue *rq, struct proc_struct *proc);
    // 把进程取出run queue
    void (*dequeue)(struct run_queue *rq, struct proc_struct *proc);
    // 选择下一个要执行的进程
    struct proc_struct *(*pick_next)(struct run_queue *rq);
    // 每次时钟中断调用
    void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc);
};
```

所有的进程被组织成一个`run_queue`数据结构。这个数据结构虽然没有保存在调度类中，但是是由调度类来管理的。目前ucore仅支持单个CPU核心，所以只有一个全局的`run_queue`。

我们在进程控制块中也记录了一些和调度有关的信息：

```c
struct proc_struct {
    // ...
    // 表示这个进程是否需要调度
    volatile bool need_resched;
    // run queue的指针
    struct run_queue *rq;
    // 与这个进程相关的run queue表项
    list_entry_t run_link;
    // 这个进程剩下的时间片
    int time_slice;
    // 以下几个都和Stride调度算法实现有关
    // 这个进程在优先队列中对应的项
    skew_heap_entry_t lab6_run_pool;
    // 该进程的Stride值
    uint32_t lab6_stride;
    // 该进程的优先级
    uint32_t lab6_priority;
};
```

前面的几个成员变量的含义都比较直接，最后面的几个的含义可以参见Stride调度算法。这也是本次lab的实验内容。

结构体`run_queue`实现了运行队列，其内部结构如下：

```c
struct run_queue {
    // 保存着链表头指针
    list_entry_t run_list;
    // 运行队列中的线程数
    unsigned int proc_num;
    // 最大的时间片大小
    int max_time_slice;
    // Stride调度算法中的优先队列
    skew_heap_entry_t *lab6_run_pool;
};
```

有了这些基础，我们就来实现一个最简单的调度算法：Round-Robin调度算法，也叫时间片轮转调度算法。

时间片轮转调度算法非常简单。它为每一个进程维护了一个最大运行时间片。当一个进程运行够了其最大运行时间片那么长的时间后，调度器会把它标记为需要调度，并且把它的进程控制块放在队尾，重置其时间片。这种调度算法保证了公平性，每个进程都有均等的机会使用CPU，但是没有区分不同进程的优先级（这个也就是在Stride算法中需要考虑的问题）。下面我们来实现以下时间片轮转算法相对应的调度器借口吧！

首先是`enqueue`操作。RR算法直接把需要入队的进程放在调度队列的尾端，并且如果这个进程的剩余时间片为0（刚刚用完时间片被收回CPU），则需要把它的剩余时间片设为最大时间片。具体的实现如下：

```c
static void
RR_enqueue(struct run_queue *rq, struct proc_struct *proc) {
    assert(list_empty(&(proc->run_link)));
    list_add_before(&(rq->run_list), &(proc->run_link));
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
        proc->time_slice = rq->max_time_slice;
    }
    proc->rq = rq;
    rq->proc_num ++;
}
```

`dequeue`操作非常普通，将相应的项从队列中删除即可：

```c
static void
RR_dequeue(struct run_queue *rq, struct proc_struct *proc) {
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
    list_del_init(&(proc->run_link));
    rq->proc_num --;
}
```

`pick_next`选取队列头的表项，用`le2proc`函数获得对应的进程控制块，返回：

```c
static struct proc_struct *
RR_pick_next(struct run_queue *rq) {
    list_entry_t *le = list_next(&(rq->run_list));
    if (le != &(rq->run_list)) {
        return le2proc(le, run_link);
    }
    return NULL;
}
```

`proc_tick`函数在每一次时钟中断调用。在这里，我们需要对当前正在运行的进程的剩余时间片减一。如果在减一后，其剩余时间片为0，那么我们就把这个进程标记为“需要调度”，这样在中断处理完之后内核判断进程是否需要调度的时候就会把它进行调度：

```c
static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
    if (proc->time_slice > 0) {
        proc->time_slice --;
    }
    if (proc->time_slice == 0) {
        proc->need_resched = 1;
    }
}
```

至此我们就实现完了和时间片轮转算法相关的所有重要接口。类似于RR算法，我们也可以参照这个方法实现自己的调度算法。本次实验中需要同学们自己实现Stride调度算法。