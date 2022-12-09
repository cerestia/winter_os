# 从1开始写操作系统

这是一篇关于写操作系统的笔记，主要参考了子牙老师的课程和操作系统真相还原的代码

## 环境配置
ubuntu 22.04
bochs 3.7
qemu-system-i386

## 前置知识
c语言基础语法，x86汇编基础语法，c语言编译详细过程（如果对这一部分不熟请参考《程序员的自我修养》）。

## 操作系统是什么
操作系统是一个软件程序，用来管理硬件资源，给应用层程序提供运行时的环境，对应用层程序进行调度。相关概念可以参考南京大学蒋炎岩老师的课程 http://jyywiki.cn/OS/2022/。

## 这个操作系统将要实现哪些内容

目前将实现32位x86环境下的多任务调度，将来实现文件管理和硬盘管理（真相还原的大部分内容）。

##  参考资料
子牙老师的课程

《操作系统真相还原》

hurlex的代码及文档 https://github.com/hurley25/hurlex-doc.git