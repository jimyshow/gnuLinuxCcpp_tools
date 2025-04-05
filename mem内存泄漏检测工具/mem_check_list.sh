商业 内存泄漏检测工具，没有找到相关的


1. Valgrind是分析Linux和Mac OS x上各种内存问题的首选工具。它使用单独的工具进行特定的内存分析：如分析和内存检查。Valgrind在Windows上不可用，
    （1-1）KCacheGrind        KCacheGrind是一款Valgrind分析结果的可视化工具。
    （1-2）Massif Visualizer  Massif Visualizer是一个数据的可视化工具。配合Valgrind工具一起使用。
    （1-3）AddressSanitizer   AddressSanitizer是一款内置在gcc 4.8和clang中内存监控工具。
2. 


二、Windows下的内存检测工具
1. Deleaker
   Deleaker是一款功能强大的内存检测工具，但要收费。 当安装成功后，会作为插件添加到QtCreaotr中，我们直接在QtCreator中使用即可：
2. VLD 可用于Qt C++开发中进行内存检测的工具：vld。
   Visual Leak Detector (VLD)是一款用于Visual c++的内存泄漏检测工具。它的特点是:可以得到内存泄漏点的调用栈，如果可以，还可以得到它所在的文件和行号;
   可以获得泄漏内存的完整数据;您可以设置内存泄漏报告的级别;它是开源和免费的。美中不足的是，只能使用vc++编译器。
3. MTuner可以获得内存使用和分配模式的情况，能给我们分析内存提供数据和数据查看窗口。该工具开源、免费。能以时间轴的方式显示和记录软件运行期间的内存行为。
4. Diagnostic 是一款免费，开源的工具，支持32/64位架构。
5. heob工具免费，开源。已经集成到QtCreator中，用于检测缓冲区溢出和内存泄漏。
6. WonderLeak 该工具收费。是一个高性能的Windows堆和句柄分配分析器。软件界面如下：
