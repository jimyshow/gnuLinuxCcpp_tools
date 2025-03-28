转载：https://blog.csdn.net/weixin_38391755/article/details/80380786（感谢整理）转载自：
http://blog.csdn.net/haoel/article/details/2886（感谢原创作者--haoel--陈皓MegaEase创始人--的创作）
1976年（个人推断）在云南出生。1998刚毕业成为云南省工商银行的一名技术员. https://www.cnblogs.com/moonfdd/p/17403371.html。
https://www.sohu.com/a/106437470_437992，作者：华创资本：2000年离开昆明，辞职后去上海，加入给银行做系统集成软件的南天公司，
2002年去北京，加入做分布式计算平台软件的公司-Platform，
2007年，陈皓加入了汤森路透，4年多时间从一名普通技术人员做到了部门主管，最多的时候他负责北京研发中心八个项目组的技术管理和产品研发工作
2010互联网复苏，得到亚马逊的机会，但职位和工资不是很好，而在汤森路透做则是风生水起，是公司重点培养的人，选择降薪降职去了亚马逊。
“卖书都能卖出全世界第一个推荐系统，第一个云平台，我必须要去看一下”，做到研发经理，负责电子商务全球化业务（全球开店）和全球库存预测系统的研发。后因团队被整体迁到美国，
2012年去了阿里做了聚石塔和阿里云。作者刘燕，cloud.tencent.com.cn/developer/article/2256174

1.
    把源文件编译成中间代码文件，在Windows下也就是 .obj 文件，UNIX下是 .o 文件，即 Object File，这个动作叫做编译（compile）。然后再把大量的Object File合成执行文件，这个动作叫作链接（link）。        
    编译时，编译器需要的是语法的正确，函数与变量的声明的正确。对于后者，通常是你需要告诉编译器头文件的所在位置（头文件中应该只是声明，而定义应该放在C/C++文件中），只要所有的语法正确，
编译器就可以编译出中间目标文件。一般来说，每个源文件都应该对应于一个中间目标文件（O文件或是OBJ文件）。 
    链接时，主要是链接函数和全局变量，所以，我们可以使用这些中间目标文件（O文件或是OBJ文件）来链接我们的应用程序。链接器并不管函数所在的源文件，只管函数的中间目标文件（Object File），
    在大多数时候，由于源文件太多，编译生成的中间目标文件太多，而在链接时需要明显地指出中间目标文件名，这对于编译很不方便，所以，我们要给中间目标文件打个包，在Windows下这种包叫“库文件”（Library File)，
也就是 .lib 文件，在UNIX下，是Archive File，也就是 .a 文件。  
    源文件首先会生成中间目标文件，再由中间目标文件生成执行文件

2.
 1.如果这个工程没有编译过，那么我们的所有C文件都要编译并被链接。
 2.如果这个工程的某几个C文件被修改，那么我们只编译被修改的C文件，并链接目标程序。
 3.如果这个工程的头文件被改变了，那么我们需要编译引用了这几个头文件的C文件，并链接目标程序。

3.
规则
target... : prerequisites ...
  command
...
...
target也就是一个目标文件，可以是Object File，也可以是执行文件。还可以是一个标签（Label），对于标签这种特性，在后续的“伪目标”章节中会有叙述。
prerequisites就是，要生成那个target所需要的文件或是目标。
command也就是make需要执行的命令。（任意的Shell命令）
这是一个文件的依赖关系，也就是说，target这一个或多个的目标文件依赖于prerequisites中的文件，其生成规则定义在command中。说白一点就是说，
prerequisites中如果有一个以上的文件比target文件要新的话，command所定义的命令就会被执行。这就是Makefile的规则。也就是Makefile中最核心的内容。

4.
$@--目标文件，$^--所有的依赖文件，$<--第一个依赖文件。

5. 一个例子：
   edit : main.o kbd.o command.o display.o \
          insert.o search.o files.o utils.o
           cc -o edit main.o kbd.o command.o display.o \
                      insert.o search.o files.o utils.o
   main.o : main.c defs.h
           cc -c main.c
   kbd.o : kbd.c defs.h command.h
           cc -c kbd.c
   command.o : command.c defs.h command.h
           cc -c command.c
   display.o : display.c defs.h buffer.h
           cc -c display.c
   insert.o : insert.c defs.h buffer.h
           cc -c insert.c
   search.o : search.c defs.h buffer.h
           cc -c search.c
   files.o : files.c defs.h buffer.h command.h
           cc -c files.c
   utils.o : utils.c defs.h
           cc -c utils.c
   clean :
           rm edit main.o kbd.o command.o display.o \
              insert.o search.o files.o utils.o
6.
make是如何工作的
在默认的方式下，也就是我们只输入make命令。那么，
  1. make会在当前目录下找名字叫“Makefile”或“makefile”的文件。
  2. 如果找到，它会找文件中的第一个目标文件（target），在上面的例子中，他会找到“edit”这个文件，并把这个文件作为最终的目标文件。
  3. 如果edit文件不存在，或是edit所依赖的后面的 .o 文件的文件修改时间要比edit这个文件新，那么，他就会执行后面所定义的命令来生成edit这个文件。
  4. 如果edit所依赖的.o文件也存在，那么make会在当前文件中找目标为.o文件的依赖性，如果找到则再根据那一个规则生成.o文件。（这有点像一个堆栈的过程）
  5. 当然，你的C文件和H文件是存在的啦，于是make会生成 .o 文件，然后再用 .o 文件声明make的终极任务，也就是执行文件edit了。
这就是整个make的依赖性，make会一层又一层地去找文件的依赖关系，直到最终编译出第一个目标文件。在找寻的过程中，如果出现错误，比如最后被依赖的文件找不到，那么make就会直接退出，并报错，
而对于所定义的命令的错误，或是编译不成功，make根本不理。
make只管文件的依赖性，即，如果在我找了依赖关系之后，冒号后面的文件还是不在，那么对不起，我就不工作啦。
7.
如果这个工程已被编译过了，当我们修改了其中一个源文件，比如file.c，那么根据我们的依赖性，我们的目标file.o会被重编译（也就是在这个依性关系后面所定义的命令），
于是file.o的文件也是最新的啦，于是file.o的文件修改时间要比edit要新，所以edit也会被重新链接了（详见edit目标文件后定义的命令）。
8.
makefile中使用变量
我们声明一个变量，叫objects, OBJECTS, objs, OBJS, obj, 或是 OBJ，反正不管什么啦，只要能够表示obj文件就行了。我们在makefile一开始就这样定义：
    objects = main.o kbd.o command.o display.o \
             insert.o search.o files.o utils.o
改良版makefile就变成下面：
   objects = main.o kbd.o command.o display.o \
             insert.osearch.o files.o utils.o 
   edit : $(objects)
           cc -o edit $(objects)
   main.o : main.c defs.h
           cc -c main.c
   kbd.o : kbd.c defs.h command.h
           cc -c kbd.c
   command.o : command.c defs.h command.h
           cc -c command.c
   display.o : display.c defs.h buffer.h
           cc -c display.c
   insert.o : insert.c defs.h buffer.h
           cc -c insert.c
   search.o : search.c defs.h buffer.h
           cc -c search.c
   files.o : files.c defs.h buffer.h command.h
           cc -c files.c
   utils.o : utils.c defs.h
           cc -c utils.c
   clean :
           rm edit $(objects)
           
  
