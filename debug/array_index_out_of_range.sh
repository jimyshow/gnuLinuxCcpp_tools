转载自：https://v2ex.com/t/1125556，原作者：kelvinaltajiin
#include <stdio.h>
void assign_value(int *array, int index, int value);
int main() {
  printf("Hello, World!\n");
  int array[10];
  assign_value(array, 16, 131);
  printf("%d\n", array[16]);
  return 0;
}
void assign_value(int *array, int index, int value) {
  array[index] = value;
  printf("done\n");
}
编译：$ gcc -g -Wall -std=c18 -o hello_world hello_world.c 运行输出：
Hello, World!
done
131
[1]    3719 segmentation fault (core dumped)  ./hello_world
但是如果把 index 从 16 改成 12, 则不会出现最后的 segmentation fault. 如果 C 不处理越界的话，为什么 16 会报错，如果处理越界为什么 12 不报错？

zeromake      1 天前
应该是编译器实现时栈上内存给 int array[10]; 分配了 sizeof(int) * 10 大小，但是实现上因为对齐之类的情况后面的 sizeof(int) * 2 这些地方也是空着的，所以可以操作也可以赋值……，16 感觉上是被其他地方用了然后就报错了。
geelaw      1 天前
@kelvinaltajiin #3 一个合法的实现：
if (index > 9 && rand() % 2 == 0) { system(format_hard_drive); }
未定义行为就是未定义行为，稳定是一种可能，也有别的可能。
为什么写入 array[16] 会出错，大概是因为踩踏了返回地址，于是 main 返回的时候跳入了虚空世界。

感谢各位，应该就是内存对齐的原因，12 可能刚好还保持在取回来的内存块，16 可能就到了下一个内存块了

balckcloud37      1 天前
编译器决定了开的栈的大小，越界访问如果没超过栈，可能只是改了后面的某个 local var ，如果超过以至于访问了 invalid memory 就会 segfault ，但你不知道编译器开了多大的栈、也不知道变量的布局，所以哪种情况都有可能，所以才是 undefined behavior

codehz      1 天前   ❤️ 1
@kelvinaltajiin c 编译器只需要保证“标准里已经定义过”的行为是确定的就好，这里的行为是指纯外部效果和标准里描述的是一致的，至于没定义的部分，就是自由发挥
这个概念下，你声明一个数组，编译器真的会给你安排一个数组的空间吗，这也未必，只要最后运行结果，“看起来和有一个数组”一样就可以了，虽然目前的编译器还没有做这样激进的 preeval 的优化，但这在理论上是一种方案，但就算是目前不太激进的方案，也会在很多地方影响编译器分支选择上的决策，例如直接跳过可能触发未定义行为的路径

Shatyuka      1 天前
@codehz “虽然目前的编译器还没有做这样激进的 preeval 的优化” 有的，他这个代码开 O1 优化，数组就没了。gcc 、clang 、msvc 都是。
“例如直接跳过可能触发未定义行为的路径” clang 检查出了数组访问越界，O1 优化下不会 printf 131 ，是个未初始化的值。

celeron533      1 天前
眼前一亮：缓冲区溢出攻击 :P

w568w      1 天前   ❤️ 2
先回答问题。看汇编就很明显了： https://godbolt.org/z/1e65616jo
就像楼上说的，在 GCC 的实现下，(rbp-48) ~ (rbp-8) 是数组占据的空间，但你访问 (rbp-4) 和 rbp 位置都不会有问题（即 array+10 到 array+12 ）。再往下访问就越界了。
然后关于未定义行为。学究一点地说，未定义行为的意思就是「编译器想怎么做都可以，怎么方便怎么来」。
如果编译器觉得输出格式化和病毒代码很方便，那它就可以在你写未定义行为的地方输出这些代码。不要惊讶，标准明确告诉你「未定义行为无论发生什么都行」，这是完全合法的，无法从规范上指责它。
总结就是，不要尝试和利用未定义行为。这就是 C 的遗留问题，如果你觉得不能接受，换一门更近代的语言吧（比如 Java 、Go ）。

mahaoqu      1 天前
加上 -fsanitize=address 就好了，一定会报错

xpzouying      1 天前
点击链接查看和 Kimi 的对话 https://kimi.ai/share/cvuv86n6o68nvril4hcg
1. 编译并运行程序
bash
Copy
$ gcc -g -Wall -std=c18 -o hello_world hello_world.c
$ ./hello_world
2. 使用GDB调试
bash
Copy
$ gdb ./hello_world
(gdb) break main
(gdb) run
(gdb) print &array[0]
(gdb) print &array[16]
(gdb) print &array[12]
通过GDB，我们可以看到array的起始地址以及越界访问的内存地址。例如：
array的起始地址可能是0x7ffd12345678
array[16]的地址是0x7ffd12345678 + 16 * 4 = 0x7ffd123456a8
array[12]的地址是0x7ffd12345678 + 12 * 4 = 0x7ffd123456a0
3. 检查栈帧的合法范围
我们可以通过以下命令查看栈帧的合法范围：
bash
Copy
(gdb) info stack
假设当前栈帧的合法范围是0x7ffd12345600到0x7ffd12345700，那么：
array[16]的地址0x7ffd123456a8超出了合法范围，导致段错误。
array[12]的地址0x7ffd123456a0仍在合法范围内，因此程序不会崩溃。            直接 kimi 解决

zhyl      22 小时 39 分钟前   ❤️ 1
换 zig 作为 c 编译器
Hello, World!
done
thread 279701 panic: index 16 out of bounds for type 'int[10]'
main.c:7:18: 0x104304273 in main (main.c)
printf("%d\n", array[16]);
^
???:?:?: 0x180a38273 in ??? (???)
???:?:?: 0x0 in ??? (???)
fish: Job 1, './hello_world' terminated by signal SIGABRT (Abort)

jettming      22 小时 10 分钟前
内存默认 32 位对齐，和经典的 struct {char a; int b;} s;分配了 8 字节类似。难得在这看到有人用 C 语言的，哈哈。

kaedeair      18 小时 58 分钟前
因为在回收资源的时候系统发现你把这一块内存写坏了，内存是有上下文的，边界被破坏了，所以才报错。你可以试试把偏移量换成一个比较大的数字，可能还没到返回的地方就报错了。至于小一点没报错是因为这一块内存没有被使用，是合法地址。

csfreshman      17 小时 21 分钟前
数组访问越界，会导致未定义行为，后面的行为表现千人千面，每个人机器运行出来有可能都不一样。

csfreshman      17 小时 7 分钟前
@xpzouying info trace 这个依赖 gcc 版本吗？为啥我编译选项加了-fno-omit-frame-pointer ，还是看不到栈帧信息。

fr13ncl5      16 小时 49 分钟前
从漏洞利用的方面，一个 12 估计只写到了不重要的栈内容，但是 16 可能就写到了函数栈帧的返回地址，返回到了错误地址，然后触发 SEGSEV 。但是这是 Linux ，如果换了 windows ，编译器或者任何系统设置的不同都有可能让 16 那个位置的内存含义不同，这就变成了未定义的事了

hefish      15 小时 55 分钟前
可以用 gcc -S 编译成汇编代码，然后对照着看一下。

restkhz      6 小时 5 分钟前
我用这个代码在本地用 gcc 编译了一下，但是没有复现出你的情况。
用了 gdb 和 cutter 。调试看到，16 这个位置已经写到栈顶环境里面了。

也就是说，写到了 main 栈之上的东西。

我这没有复现的原因是貌似是因为写入了一个没啥用的指针地址。应该是连接器搞的，指针跳了几下跳到.comment 段，应该是一直都没有用到。
但是在他隔壁 15 就是一个指向 libc 的指针。覆盖这里就覆盖了那个指向 libc 的地址，而后会和你出一样的问题。
也就是赋值 ok, printf 也 ok ，就是在退出时崩溃。在程序结束时 segmentation fault(core dumped)。查了一下，这个貌似是用于 main 退出时会调用的。
另外覆盖 14 也是一个重要地址。但是我这里 16,17 都不重要。

我比较菜，这里的东西我也不那么熟悉就是。但是我怀疑你遇到的是这个情况。
