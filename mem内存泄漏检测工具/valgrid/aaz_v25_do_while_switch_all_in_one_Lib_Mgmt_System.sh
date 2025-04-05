ChatGPT建议：
write 和 _IO_file_write 的问题可能与文件操作有关，检查你的文件指针是否正确初始化，文件是否成功打开再进行写入操作。另外，检查是否在写入文件时遇到了错误。

==26287== Process terminating with default action of signal 2 (SIGINT)
        信号2（SIGINT）：这通常是程序被中断时发送的信号，通常是用户手动按 Ctrl+C 来终止程序时触发的。这是正常的中断信号，意味着你的程序在执行时被强制终止了。
==26287==    at 0x497B572: write (write.c:26)
==26287==    by 0x48F2974: _IO_file_write@@GLIBC_2.2.5 (fileops.c:1181)
        write 函数和 _IO_file_write：问题似乎与程序中的文件或控制台输出操作相关。可能是在写文件时出现了问题，或者是输出处理出现了异常。
==26287==    by 0x48F1570: new_do_write (fileops.c:449)
==26287==    by 0x48F1570: _IO_do_write@@GLIBC_2.2.5 (fileops.c:426)
==26287==    by 0x48F1EF2: _IO_file_overflow@@GLIBC_2.2.5 (fileops.c:784)
==26287==    by 0x48E6DD9: puts (ioputs.c:41)
==26287==    by 0x10ADC3: menu (in /home/yan/lihuiqin/lihuiqin/aar_v22_control_flow/aaz_v25_do_while_switch_all_in_one_Lib_Mgmt_System/a.out)
==26287==    by 0x10AE22: main (in /home/yan/lihuiqin/lihuiqin/aar_v22_control_flow/aaz_v25_do_while_switch_all_in_one_Lib_Mgmt_System/a.out)
==26287==
==26287== HEAP SUMMARY:
==26287==     in use at exit: 2,048 bytes in 2 blocks
          退出时仍在使用的内存：程序退出时，有 2048 字节的堆内存仍然被占用，但没有被释放。虽然这不一定是严重的 bug，但应该注意这可能是内存泄漏的信号。
==26287==   total heap usage: 2 allocs, 0 frees, 2,048 bytes allocated
==26287==
==26287== LEAK SUMMARY:
==26287==    definitely lost: 0 bytes in 0 blocks
==26287==    indirectly lost: 0 bytes in 0 blocks
==26287==      possibly lost: 0 bytes in 0 blocks
==26287==    still reachable: 2,048 bytes in 2 blocks
          内存泄漏总结：报告显示“仍然可达”的内存块，这意味着这些内存块虽然没有被释放，但程序仍然可以访问它们。这可能表明你没有正确地清理分配的内存。
==26287==         suppressed: 0 bytes in 0 blocks
==26287== Reachable blocks (those to which a pointer was found) are not shown.
==26287== To see them, rerun with: --leak-check=full --show-leak-kinds=all
        加上 --leak-check=full --show-leak-kinds=all 参数，查看更详细的内存泄漏报告，定位哪些部分的代码存在内存泄漏。
==26287==
==26287== Use --track-origins=yes to see where uninitialised values come from
        使用 --track-origins=yes 可以追踪未初始化的值。这有助于你找到使用了未初始化变量的地方，可能导致程序出现未定义的行为。
==26287== For lists of detected and suppressed errors, rerun with: -s
==26287== ERROR SUMMARY: 54860 errors from 1 contexts (suppressed: 0 from 0)
        报告指出出现了 54860 个错误，这可能说明你的内存管理存在重大问题，比如访问了未初始化的变量、内存分配不正确，或者内存损坏。

