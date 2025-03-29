# 用的wsl2，所以~/.bashrc里面初始化了很多内容，敲完make+一个空格命令后，再按2个tab，不能自动补全当前目录下的文件名
# 运行“bash --norc --noprofile”，bash变为“bash-5.2$", 此时可以自动补全，--norc：启动bash时不读取~/.bashrc文件。这意味着任何在~/.bashrc中定义的配置或别名都不会被加载。
--noprofile：启动bash时不读取任何配置文件（如/etc/profile、~/.bash_profile、~/.bash_login或~/.profile）。这意味着任何在这些文件中定义的环境变量或配置都不会被加载。

#下面的内容是使用Makefile实现通用功能：

CC = gcc
CFLAGS = -Wall
LDFLAGS = -lm

#C源文件在当前目录下，使用 wildcard 和 basename 获取所有 .c 文件并动态生成可执行文件名称：

# 查找所有 .c 文件
SRC = $(wildcard *.c)

# 生成对应的可执行文件名称（去掉 .c 扩展）
TARGETS = $(basename $(SRC))


OBJ = $(SRC:.c=.o)

# 规则：编译所有目标
all: $(TARGETS)

$(TARGETS): $(OBJ)
	$(CC)  $(OBJ) -o $(TARGETS) $(LDFLAGS)

# 通用编译规则
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
clean:
	rm -f $(OBJ) $(TARGETS)

# -c 选项的作用是 只编译，不链接（Compile only, no linking）。
# $(CC)：使用编译器（如 gcc 或 g++）。
# $(CFLAGS)：编译选项，例如 -Wall（显示警告）、-O2（优化）。
# -c：告诉编译器 只编译，不进行链接，生成 .o（目标文件）。
# $<：表示 依赖文件（即 .c 文件）。
# -o $@：指定输出文件，$@ 表示 目标文件（即 .o 文件）。
# 例子，如下Makefile
SRC = main.c utils.c
OBJ = $(SRC:.c=.o)
CC = gcc
CFLAGS = -Wall -O2

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

all: $(OBJ)
	$(CC) $(OBJ) -o myprogram
# 运行 make，会执行：
gcc -Wall -O2 -c main.c -o main.o
gcc -Wall -O2 -c utils.c -o utils.o
gcc main.o utils.o -o myprogram
第一步和第二步使用 -c 选项，只编译 .c 文件生成 .o，最后一步才进行链接生成最终可执行文件 myprogram。
总结： -c 让编译器只进行编译阶段，不会生成可执行文件，而是生成 .o 目标文件，后续再进行链接（linking）。
