# MIT6.828总结

## 1、写在最前面

很开心，历时一个月，在老师的重重压力下，终于完成了MIT6.828的学习，虽然效果并不理想，但是也只能到此为止了，后续还需要准备找工作和写论文！！！



MIT6.828共有六个实验:

Lab1忘记记录了，等想起来记录一下时已经merge到lab2了，所以没有关于lab1的讲解，我会将属于Lab1的分支设置成master，其他实验请参考其他的分支；

Lab2-Lab5我都在尽力的去完成，虽然大部分都是参考网上的实现，但我尽量的把每一步都写清楚了；

Lab 6文件传输和网络相关的实验，提示实在是太少，再加上最近时间比较紧，我就只能完成最低的要求将其实现了，并没有做注释，有些地方也是不求甚解，但暂时也只能如此了。



## 2、环境配置

1、安装qemu时使用`make && make install`时，会出现问题

```
install -d -m 0755 "/usr/local/share/doc/qemu"
install: cannot create directory ‘/usr/local/share/doc’: Permission denied
make: *** [Makefile:364: install-doc] Error 1
```

解决方法：分步执行，先执行`make`，然后执行`sudo make install`

2、执行`make qemu`后，退出的方法为`Ctrl + A`，松开后按`X`即可

3、`gdb`的使用，打开两个terminal，进入qemu/lab文件夹，第一个termial输入`make qemu-gdb`。此时启动了`gemu`，但是`qemu`只停留在处理器执行的第一条指令之前，并且等待着来自`gdb`的debugging connection；第二个terminal中，在同样的文件夹下，运行`make gdb`

4、`gdb`中查看某寄存器的值使用`p/x *(unsigned int*)$ebp`	其中`$ebp`可以换成其他寄存器的名称

5、运行`sudo make grade`时报错

```
Command 'python' not found, did you mean:

  command 'python3' from deb python3
  command 'python' from deb python-is-python3

```

解决办法：`sudo ln -s /usr/bin/python3 /usr/bin/python`

6、下载xv6时报错：

```
fatal: unable to connect to github.com:
github.com[0: 20.205.243.166]: errno=Unknown error
```

解决办法：

`git config --global url."https://github.com".insteadOf git://github.com`

7、调试gdb时不会运行`make gdb`显示没有这项指令，打开`Makefile`会发现没有gdb命令，添加

```
gdb:
	gdb -n -x .gdbinit
```

添加之后可能会报错`missing separator. Stop.`

这是因为`Makefile`指令只能识别出tab，可能由于vim设置问题导致tab无法识别，最简单的方法就是使用`gedit`打开Makefile，然后复制其他行的代码，改成上面的gdb的样式即可。

其他的设置方式肯定存在，也肯定是长久解决问题的办法，但是我没有找到，大概的思路就是修改`vimrc`的某条设置

8、进行时延分支合并时，首先使用`git remote -v`查看当前的分支，使用git commit -am ""之后才能使用git merge命令

参考链接：https://blog.csdn.net/a747979985/article/details/95203548

