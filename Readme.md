# Lab 5: File system, Spawn and Shell

实验五要求我们merge lab4之后，仍然能够运行pingpong，primes以及forktree三个test case，运行之前需要注释`kern/init.c`中的ENV_CREATE(fs_fs)这一行，同时，注释`lib/exit.c`中的close_all()一行

运行`make run-pingpong`，发现报错：

```
lib/spawn.c: In function ‘spawn’:
lib/spawn.c:110:35: error: taking address of packed member of ‘struct Trapframe’ may result in an unaligned pointer value [-Werror=address-of-packed-member]
  110 |  if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
      |                                   ^~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
```



查了一些网上的资料，最终方法，打开GNUmakefile，第92行

```
CFLAGS += -Wall -Wno-format -Wno-unused -Werror -gstabs -m32
```

修改为

```
CFLAGS += -Wall -Wno-format -Wno-unused -gstabs -m32
```

之后便可顺利运行了

最后别忘了将前面的两行注释删掉，是否需要修改GNUmakefile稍后再看



## 1、On-Disk File System Structure

大多数UNIX文件系统将可用的硬盘空间分为两个部分：inode区域和data区域。UNIX文件系统为每个文件分配一个inode；文件inode保存着至关重要的元数据，例如：文件的统计属性以及指向数据块的指针。data区域被分为更多的数据块(data bolcks)，文件系统在数据块中存储文件数据和元目录数据；目录条目(Directory entries)包含文件名和指向inode的指针。如果文件系统中的多个目录条目引用了该文件的inode，则称该文件为硬链接文件。由于我们的文件系统不支持硬链接，我们不需要这种间接的层次，因此可以进行方便的简化：我们的文件系统甚至不会使用inode，而是使用目录条目存储文件的元数据。



文件和目录逻辑上都包含一系列的数据块，他们可能分散在整个磁盘中，就像进程的虚拟地址空间页面分散在物理内存中一样。文件系统隐藏了数据块分布的细节，提供了文件中任意偏移的连续字节的读取接口。文件系统进程在内部处理对目录的所有修改，视为执行文件创建和删除等操作的一部分。我们的文件系统允许用户进程直接读取元目录数据，这也就意味着用户进程可以自己执行目录扫描操作，而不必依赖对文件系统的额外特殊调用。这种目录扫描方法的缺点，以及大多数现在UNIX变体不鼓励他的原因是：他使得应用程序依赖目录元数据的格式，使得在不改变或至少重新编译应用程序的情况下很难改变文件系统的内部布局。



### 1.1、Sectors and Blocks

大部分硬盘不能读写单独的某些字节的数据，替代的方法是读写sector的单元。在JOS中，扇区(sector)大小为512字节。文件系统实际上使用的是Blocks的单元。要注意两个术语之间的区别：扇区大小是磁盘硬件的一个属性，而块大小是使用磁盘的操作系统的一个方面。文件系统的块的大小必须是扇区大小的整数倍。



UNIX xv6文件系统使用大小为512字节的块，和扇区的大小相同。大多数现在文件系统使用更大的block size，因为存储空间越来越偏移并且操作更大的细粒度更加方便。



**我们的文件系统会使用block size=4096bytes，方便匹配处理器的页面大小**



### 1.2、Superblocks

文件系统通常在磁盘上“易于找到”的位置保留特定的磁盘块，以保存描述整个文件系统属性的元数据，例如：block size，disk size，找到root目录的任何元数据，文件系统上次安装的时间以及文件系统上次被检查出错误的时间。这些特殊的块被称作“superblocks”。



我们的文件系统也存在一个superblock，永远脑婆睡觉哦磁盘的第一个块。其分布被定义在`inc/fs.h`的struct Super中

```C
// File system super-block (both in-memory and on-disk)

#define FS_MAGIC	0x4A0530AE	// related vaguely to 'J\0S!'

struct Super {
	uint32_t s_magic;		// Magic number: FS_MAGIC
	uint32_t s_nblocks;		// Total number of blocks on disk
	struct File s_root;		// Root directory node
};
```



Block0被用来保留bootloader和分区表。因此文件系统一般不会使用特别靠前的磁盘块。许多真实的文件系统保存大量的superblocks，在磁盘的几个宽间距区域中复制，以便于如果其中一个被损坏或磁盘在该区域出现media error，仍然可以找到其他superblock并使用他们访问文件系统



### 1.3、File Meta-data

我们的文件系统中描述文件的元数据的分布定义在`inc/fs.h`的struct File中

```C
struct File {
	char f_name[MAXNAMELEN];	// filename
	off_t f_size;			// file size in bytes
	uint32_t f_type;		// file type

	// Block pointers.
	// A block is allocated iff its value is != 0.
	uint32_t f_direct[NDIRECT];	// direct blocks
	uint32_t f_indirect;		// indirect block

	// Pad out to 256 bytes; must do arithmetic in case we're compiling
	// fsformat on a 64-bit machine.
	uint8_t f_pad[256 - MAXNAMELEN - 8 - 4*NDIRECT - 4];
} __attribute__((packed));	// required only on some 64-bit machines
```



前面提到过，我们的文件系统中没有inode，因此这个元数据存储在磁盘中的一个目录条目中。和大多数真正的文件系统不同，为了方便我们将会使用一个`File`结构来代表文件元数据，作为其在磁盘和内存中展现的内容。



`struct File`中的f_direct数组包含存储block number前10的块的空间，这部分我们称之为文件的direct blocks。对于不超过10*4096=40KB的文件，这意味着文件的所有块的块号将直接适合文件结构本身。但是，对于更大的文件，我们需要额外的blocks去承载文件剩余的部分。因此，对于任何大于40KB的文件，我们分配额外的磁盘块，叫做indirect block，去承载之多4096/4=1024个额外的块号。我们的文件系统最多允许文件装在到1034个块，或者最多4MB。为了支持更大的文件，真实的文件系统一般会支持double和triple-indirect blocks。



### 1.4、Directories versus Regular Files

在我们的文件系统中。一个`File`结构可以表示一个regular file或者一个目录，这两种类型被`File`结构中的`type`域标识。文件系统以相同的方式管理regular file和目录文件，除了他根本不解释域常规文件相关联的数据块的内容。而文件系统将目录文件的内容解释为一系列描述目录中的文件和子目录的文件结构。



我们的文件系统中的superblock中保存着文件系统根目录的元数据。目录文件的内容是一系列的`File`结构，描述着文件和文件系统根目录的存储位置。根目录中的任何子目录都可能包含更多表示子子目录的File结构，依此类推。



## 2、The File System

本次实验的目的并非让我们实现完整的文件系统，而是让我们实现关键部分。事实上，我们要负责读取块到块缓存，并将他们刷新回磁盘；分配磁盘块；在IPC接口实现读、写和打开。



### 2.1、Disk Access

操作系统中的文件系统进程需要能够访问磁盘，但是我们的内核中还没有实现访问磁盘的函数。我们没有采用传统的“单片”操作系统策略，即向内核中添加IDE磁盘驱动程序以及允许文件系统访问他的系统调用，相反，我们将IDE磁盘驱动程序实现作为用户及文件系统进程的一部分。我们仍然需要稍微修改内核，以便文件系统进程拥有自己实现访问磁盘所需的特权。



（不会翻译！！！）

It is easy to implement disk access in user space this way as long as we rely on polling, "programmed I/O" (PIO)-based disk access and do not use disk interrupts. It is possible to implement interrupt-driven device drivers in user mode as well (the L3 and L4 kernels do this, for example), but it is more difficult since the kernel must field device interrupts and dispatch them to the correct user-mode environment.



x86处理器使用EFLAGS寄存器中的IOPL位来确定是否允许保护模式代码执行特殊的设备IO指令，如IN和OUT指令。因为我们需要的所有的IDE磁盘寄存器位于 x86 IO地址空间，而不是内存映射空间。想要允许文件系统访问这些寄存器，我们只需要对文件系统进程给与**I/O Privilege**即可。



**Exercise 1.** `i386_init` identifies the file system environment by passing the type `ENV_TYPE_FS` to your environment creation function, `env_create`. Modify `env_create` in `env.c`, so that it gives the file system environment I/O privilege, but never gives that privilege to any other environment.

Make sure you can start the file environment without causing a General Protection fault. You should pass the "fs i/o" test in make grade.



#### env_create

实验要求我们修改`kern/env.c`中的env_create函数，保证type参数为ENV_TYPE_FS时，我们赋予要创建的进程访问IO的权利



前面提到过，**x86处理器使用EFLAGS寄存器中的IOPL位来确定是否允许保护模式代码执行特殊的设备IO指令**，全局搜索IOPL，会发现

`inc/mmu.h`中定义着Eflgas寄存器相关的内容，其中包括

```C
#define FL_IOPL_MASK	0x00003000	// I/O Privilege Level bitmask
#define FL_IOPL_0	0x00000000	//   IOPL == 0
#define FL_IOPL_1	0x00001000	//   IOPL == 1
#define FL_IOPL_2	0x00002000	//   IOPL == 2
#define FL_IOPL_3	0x00003000	//   IOPL == 3
```



按照经验判断，我们第一次使用IOPL，肯定要用大众化的FL_IOPL_MASK，后面如果有特殊需求可能会用到FL_IOPL_0，所以我们代码中写道，如果后续有问题我们再来修改:

```C
// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	if(type == ENV_TYPE_FS){
		env->env_tf.tf_eflags |= FL_IOPL_MASK;
	}
```



使用`make grade`，发现可以通过“fs i/o”，并且我们也**未**将前面注释的`-Werror`恢复过来，这个参数的意思是将warning当作error，所以目前不能恢复，不知道后续是否有相关的内容。



#### Question

1. Do you have to do anything else to ensure that this I/O privilege setting is saved and restored properly when you subsequently switch from one environment to another? Why?

答：不需要，进程切换时EFLAGS寄存器被保存起来，并不会被其他进程使用。



### 2.2、The Block Cache

我们要实现一个简单的"buffer cache"在处理器虚拟内存系统的帮助下。代码在`fs/bc.c`中

我们的文件系统被限制处理不超过3GB的磁盘空间。我们保留了一个大的，整好3GB的空间区域，从0x10000000(DISKMAP)到0xD0000000(DISKMAP + DISKMAX)，作为内存映射版本的硬盘。`fs/bc.c`中的diskaddr实现从磁盘块号到虚拟地址的转换。

由于我们的文件系统进程有自己的地址空间，独立于系统中所有其他环江的虚拟地址空间，文件系统进程需要做的唯一一件事情就是实现文件访问，以这种方式保留大部分文件系统环境的地址空间是合理的。

当然，把整个磁盘读取进入内存会花费很长的时间，因此作为替代我们会实现一种demand paging的方法，其中，我们只在磁盘映射区域中分配页，并从磁盘中读取相应的块以相应该区域中的缺页。



**Exercise 2.** Implement the `bc_pgfault` and `flush_block` functions in `fs/bc.c`. `bc_pgfault` is a page fault handler, just like the one your wrote in the previous lab for copy-on-write fork, except that its job is to load pages in from the disk in response to a page fault. When writing this, keep in mind that (1) `addr` may not be aligned to a block boundary and (2) `ide_read` operates in sectors, not blocks.

The `flush_block` function should write a block out to disk *if necessary*. `flush_block` shouldn't do anything if the block isn't even in the block cache (that is, the page isn't mapped) or if it's not dirty. We will use the VM hardware to keep track of whether a disk block has been modified since it was last read from or written to disk. To see whether a block needs writing, we can just look to see if the `PTE_D` "dirty" bit is set in the `uvpt` entry. (The `PTE_D` bit is set by the processor in response to a write to that page; see 5.2.4.3 in [chapter 5](http://pdos.csail.mit.edu/6.828/2011/readings/i386/s05_02.htm) of the 386 reference manual.) After writing the block to disk, `flush_block` should clear the `PTE_D` bit using `sys_page_map`.

Use make grade to test your code. Your code should pass "check_bc", "check_super", and "check_bitmap".



#### bc_pgfault

我们需要做两件事：

1. 为磁盘映射区域分配页
2. 将磁盘中的内容读取到页中（`fs/ide.c`中有读取的函数）

有两点提示：

1. addr需要向PGSIZE对齐
2. ide_read操作的是sector，不是block

```C
// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
		panic("reading non-existent block %08x\n", blockno);

	// Allocate a page in the disk map region, read the contents
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr = ROUNDDOWN(addr, PGSIZE);
	if((r = sys_page_alloc(0, addr, PTE_P | PTE_U | PTE_W)) < 0)
		panic("in bc_pgfault, sys_page_alloc: %e\n", r);

	if((r = ide_read(blockno * BLKSIZE / SECTSIZE, addr, BLKSIZE / SECTSIZE)) < 0)
		panic("in bc_pgfault, ide_read: %e\n", r);

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
		panic("reading free block %08x\n", blockno);
}
```



#### flush_block

将内存空间中的数据写入磁盘

```C
// Flush the contents of the block containing VA out to disk if
// necessary, then clear the PTE_D bit using sys_page_map.
// If the block is not in the block cache or is not dirty, does
// nothing.
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
```

清除超出disk的虚拟地址块的内容，然后使用sys_page_map清空PTE_D位

如果块不在块缓存或者不是脏的，什么都不需要做

```C
void
flush_block(void *addr)
{
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	//panic("flush_block not implemented");
	int r;
	addr = ROUNDDOWN(addr, PGSIZE);
	if(!va_is_mapped(addr) || !va_is_dirty(addr)) return ;
	// Flush the contents of the block containing VA out to disk if necessary
	if((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
		panic("flush_block: ide_write %e\n", r);
	
	// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
	if((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
		panic("flush_block: sys_page_map %e\n", r);
}
```



### 2.3、The Block Bitmap

在fs_init设置bitmap指针之后，我们可以将bitmap视为一组填充的位数组，磁盘上的每个块都有一个。例如，block_is_free简单的查看一个给定的block是否被标记为free



**Exercise 3.** Use `free_block` as a model to implement `alloc_block` in `fs/fs.c`, which should find a free disk block in the bitmap, mark it used, and return the number of that block. When you allocate a block, you should immediately flush the changed bitmap block to disk with `flush_block`, to help file system consistency.

Use make grade to test your code. Your code should now pass "alloc_block".



#### alloc_block

练习要求我们仿照free_block实现alloc_block，首先来看free_block，该函数可以将一个块在bitmap中标记为free

```C
// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
}
```

实际上我们要判断某个块是否是free，需要使用block_is_free()函数

```C
// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
		return 0;
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
		return 1;
	return 0;
}
```

可以看到，bitmap[blockno / 32]表示该块是否空闲，所以我们想要将其标记为不空闲，则将改位标记为~(1 << (blockno % 32))即可

接下来看alloc_block

```C
// Search the bitmap for a free block and allocate it.  When you
// allocate a block, immediately flush the changed bitmap block
// to disk.
//
// Return block number allocated on success,
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
```

搜索bitmap，找到一个空闲的块然后为其分配内存。当我们分配一个块时，立即清洗改变过的bitmap块



```C
int
alloc_block(void)
{
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	//panic("alloc_block not implemented");

	uint32_t blockno;
	//找到空闲的blockno
	for(blockno = 2; blockno < super->s_nblocks && !block_is_free(blockno); blockno++);
	//如果没有空闲，返回-E_NO_DISK
	if(blockno >= super->s_nblocks) return -E_NO_DISK;
	//将空闲块标记为不空闲
	bitmap[blockno / 32] &= ~(1 << (blockno % 32));
	//flush the changed bitmap block to disk.
	flush_block(&bitmap[blockno / 32]);
	return blockno;
}
```



运行`make grade`

```C
  alloc_block: OK 
```



### 2.4、File Operations

在`fs/fs.c`中我们已经提供了各种各样的函数去实现解释和管理文件结构、扫描和管理文件条目以及从根目录遍历文件系统以解析绝对路径名所需的各种基本功能。阅读`fs/fs.c`中的全部代码，保证开始练习之前你已经了解了每个函数都做了什么。

- fs_init：初始化文件系统
- dir_lookup：在dir中寻找name，找到就将*file指向该name
- dir_alloc_file：将*file指向dir中的空闲的File structure
- skip_slash：忽略'/'
- walk_path：从跟开始计算路径名



**Exercise 4.** Implement `file_block_walk` and `file_get_block`. `file_block_walk` maps from a block offset within a file to the pointer for that block in the `struct File` or the indirect block, very much like what `pgdir_walk` did for page tables. `file_get_block` goes one step further and maps to the actual disk block, allocating a new one if necessary.

Use make grade to test your code. Your code should pass "file_open", "file_get_block", and "file_flush/file_truncated/file rewrite", and "testfile".



#### file_block_walk



file_bolck_walk获取文件F对应的物理块号

```C
// Find the disk block number slot for the 'filebno'th block in file 'f'.
// Set '*ppdiskbno' to point to that slot.
// The slot will be one of the f->f_direct[] entries,
// or an entry in the indirect block.
// When 'alloc' is set, this function will allocate an indirect block
// if necessary.
//
// Returns:
//	0 on success (but note that *ppdiskbno might equal 0).
//	-E_NOT_FOUND if the function needed to allocate an indirect block, but
//		alloc was 0.
//	-E_NO_DISK if there's no space on the disk for an indirect block.
//	-E_INVAL if filebno is out of range (it's >= NDIRECT + NINDIRECT).
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
```

根据文件f中的fileno 的块号找到硬盘所对应的块号，并用*ppdiskbno指向该块



前面我们提到过struc File的结构，知道了一个文件有10个direct blocks，如果文件大小超过10个block，则分配indirect block

```C
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
    // LAB 5: Your code here.
    //panic("file_block_walk not implemented");
	int r;
	//	-E_INVAL if filebno is out of range (it's >= NDIRECT + NINDIRECT).
	// inc/fs.h  
    // #define NDIRECT		10
    // #define NINDIRECT	(BLKSIZE / 4)
	if(filebno >= NDIRECT + NINDIRECT)
		return -E_INVAL;
	
	//如果小于10，则直接把f->f_direct的第filebno的地址给他
	if(filebno < NDIRECT){
		*ppdiskbno = &f->f_direct[filebno];
		return 0;
	}

	//如果大于等于10，则需要找indirect block
	//注意 File 数据结构中的f_indirect并不是一个指针
	//而是一个 uint32_t
	//所以说我们只能有一个indirect block
	if(f->f_indirect == 0){
		//	-E_NOT_FOUND if the function needed to allocate an indirect block, but
		//		alloc was 0.
		if(alloc == 0)
			return -E_NOT_FOUND;
		//	-E_NO_DISK if there's no space on the disk for an indirect block.
		if((r = alloc_block()) < 0)
			return -E_NO_DISK;
		f->f_indirect = r;
		// When 'alloc' is set, this function will allocate an indirect block
		// if necessary.
		memset(diskaddr(r), 0, BLKSIZE);
		// Hint: Don't forget to clear any block you allocate.
		flush_block(diskaddr(r));
	}

	//获得对应的物理块号的地址
	*ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
	return 0;
}
```



#### file_get_block

获取文件F对应的磁盘上的地址



根据文件的块号获得其在文件系统进程中虚拟地址空间中映射的地址

当文件的块不存在对应的物理块时，还需要为其分配一个物理块

```C
// Set *blk to the address in memory where the filebno'th
// block of file 'f' would be mapped.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
```



```C
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
    // LAB 5: Your code here.
    //panic("file_get_block not implemented");
	int r;
	uint32_t *ppdiskbno;
	//先获取文件的物理块号
	if((r = file_block_walk(f, filebno, &ppdiskbno, 1)) < 0){
		return r;
	}
	//物理块在磁盘上(DISKMAP之上)
	//如果当前的块号还没有对应的物理块
	if((*ppdiskbno) == 0){
		//我们自己给该块分配一个
		if((r = alloc_block()) < 0)
			return r;
		*ppdiskbno = r;
		//分配好之后应该将分配的物理块中的数据清除
		//以免读取到其他文件的脏数据
		memset(diskaddr(r), 0, BLKSIZE);
		//将文件写入该物理块
		flush_block(diskaddr(r));
	}
	*blk = diskaddr(*ppdiskbno);
	return 0;
}
```

​	



file_block_walk和file_get_block是文件系统中干重活的人。例如，file_read和file_write只不过是在file_get_block的基础上，在分散的块和顺序缓冲区之间复制字节。



### 2.5、The file system interface

现在我们已经有了文件系统进程的必要的函数，我们必须要让其他希望使用文件系统的进程可以使用他们。因为其他进程无法直接调用文件系统进程的函数，我们通过a remote produce call 或者叫RPC提供了访问文件系统进程的方式。

```
      Regular env           FS env
   +---------------+   +---------------+
   |      read     |   |   file_read   |
   |   (lib/fd.c)  |   |   (fs/fs.c)   |
...|.......|.......|...|.......^.......|...............
   |       v       |   |       |       | RPC mechanism
   |  devfile_read |   |  serve_read   |
   |  (lib/file.c) |   |  (fs/serv.c)  |
   |       |       |   |       ^       |
   |       v       |   |       |       |
   |     fsipc     |   |     serve     |
   |  (lib/file.c) |   |  (fs/serv.c)  |
   |       |       |   |       ^       |
   |       v       |   |       |       |
   |   ipc_send    |   |   ipc_recv    |
   |       |       |   |       ^       |
   +-------|-------+   +-------|-------+
           |                   |
           +-------------------+
```



虚线以下的内容指示将读请求从常规进程读取到文件系统进程的机制。read(lib/fd.c)可以读取任何的文件描述符，并简单地分配到适当的device read function，在本例中是devfile_read（我们有很多类型的设备，如pipes）。devfile_read实现了专门针对磁盘文件的读取。这个函数和其他dev_file_*函数实现了FS操作的客户端，他们的工作方式大致相同，在request structure(保存在页面fsipcbuf)中绑定参数，调用fsipc发送IPC请求，然后捷豹并返回结果。fsipc函数只处理向服务器发送请求和接收相应的细节。



文件系统服务器的代码放置在`fs/serv.c`中。它在serve函数中循环，无休止地通过IPC接收请求，将请求分配给相应的处理函数，然后通过IPC将结果返回。在read例子中，serve将请求分配给serve_read，serve_read将处理与读请求相关的IPC细节，比如解包请求结构，最后调用file_read去实际上执行文件读取功能。



回想JOS的IPC机制允许进程发送一个32bit的字，并且可以选择分享一个页。为了从客户端向服务端发送请求，我们使用32位数据作为请求类型，并在通过IPC共享的页面上的union Fsipc中存储请求的参数。在客户端，我们总是在fsipcbuf共享页面；在服务端，沃恩将传入的请求页面映射到fsreq(0x0ffff000)



服务器页通过IPC发送请求。我们使用32位数据作为函数的返回代码。对于大多数RPC，这就是他们返回的全部了。FSREQ_READ` and `FSREQ_STAT也返回数据，他们指示将数据写入客户机发送请求的页面。无需再相应IPC中发送此页面，因为客户机与文件系统服务器一开始就共享此页面。同样，`FSREQ_OPEN` shares with the client a new "Fd page"。我们会返回到文件描述符页。



**Exercise 5.** Implement `serve_read` in `fs/serv.c`.

`serve_read`'s heavy lifting will be done by the already-implemented `file_read` in `fs/fs.c` (which, in turn, is just a bunch of calls to `file_get_block`). `serve_read` just has to provide the RPC interface for file reading. Look at the comments and code in `serve_set_size` to get a general idea of how the server functions should be structured.

Use make grade to test your code. Your code should pass "serve_open/file_stat/file_close" and "file_read" for a score of 70/150.



#### serve_read

serve_read就是为了读取文件提供给RPC接口，其中繁重的工作已经被file_read实现了，我们只需要参考注释以及serve_set_size中的代码完成该函数即可

首先来看file_read，f表示源，buf表示目的，count表示数量，offset表示起始位置

```C
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
```

serve_read中要求：

```C
// Read at most ipc->read.req_n bytes from the current seek position
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
```

根据要求我们会发现，最后就是要调用file_read，但是目前只知道一个读取数量ipc->read.req_n



打开Fsret_read(inc/fs.h)，结合注释中Return the bytes read from the file to the caller in ipc->readRet

```C
struct Fsret_read {
		char ret_buf[PGSIZE];
	} readRet;
```

可以大致猜出ret->ret_buf就是我们要读到的目的地



打开struct Fsreq_read(inc/fs.h)

```C
struct Fsreq_read {
		int req_fileid;
		size_t req_n;
	} read;
```

我们发现ipc->read.req_fileid是一个int类型的参数，说明该参数还不是读取源，所以综上，我们想要调用file_read还需要两个参数



然后突然想到前面提示我们看serve_set_size寻找思路

```C
// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
	struct OpenFile *o;
	int r;

	if (debug)
		cprintf("serve_set_size %08x %08x %08x\n", envid, req->req_fileid, req->req_size);

	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
}
```



该函数中有一个OpenFile(fs/serve.c)

```C
struct OpenFile {
	uint32_t o_fileid;	// file id
	struct File *o_file;	// mapped descriptor for open file
	int o_mode;		// open mode
	struct Fd *o_fd;	// Fd page
};
```

注释太长，就不粘贴过来了，可以看到，OpenFIle中存在我们需要的源struct File



且serve_set_size中调用openfile_lookup，可以找到相关的open file，并且发现恰好有我们刚刚不知道怎么用的req->req_fileid，这样我们就找到了file_read中的第一个参数，而最后一个参数也在struct OpenFile中



说实话，以上这些内容都是我看完网上的实现之后才尝试找到的一些思路，如果自己写的话根本写不出来



```C
int
serve_read(envid_t envid, union Fsipc *ipc)
{
	struct Fsreq_read *req = &ipc->read;
	struct Fsret_read *ret = &ipc->readRet;

	if (debug)
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// Lab 5: Your code here:
	int r;
	struct OpenFile* o;
	if((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;
	struct File* f = o->o_file;
	// 读取文件，seek position在fd中
	struct Fd* fd = o->o_fd;
	if((r = file_read(f, ret->ret_buf, req->req_n, fd->fd_offset)) < 0)
		return r;
	fd->fd_offset += r;
	return r;
}
```



**Exercise 6.** Implement `serve_write` in `fs/serv.c` and `devfile_write` in `lib/file.c`.

Use make grade to test your code. Your code should pass "file_write", "file_read after file_write", "open", and "large file" for a score of 90/150.



#### serve_write

仿照serve_read完成即可

```C
// Write req->req_n bytes from req->req_buf to req_fileid, starting at
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	//panic("serve_write not implemented");
	int r;
	struct OpenFile* o;
	if((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;
	int total = 0;
	while(1){
		if((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0)
			return r;
		total += r;
		o->o_fd->fd_offset += r;
		if(req->req_n <= total)
			break;
	}
	//o->o_fd->fd_offset += r;
	return total;
}

```



#### devfile_write

```C
// Write at most 'n' bytes from 'buf' to 'fd' at the current seek position.
//
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
	fsipcbuf.write.req_n = n;
	memmove(fsipcbuf.write.req_buf, buf, n);

	// Make an FSREQ_WRITE request to the file system server.
	return fsipc(FSREQ_WRITE, NULL);
}

```



## 3、Spawning Processes

此处首先介绍spawn与fork的区别

fork：使用copy-on-write机制，子进程最初只复制mapping page，但是由于大部分数据都是父进程的数据，所以不安全

spawn：从头构建一个子进程，将父进程的数据拷贝到子进程空间中，但是启动较慢（如前面实验提到过的要执行exec等），但是安全



`lib/spawn.c`中已经为spawn提供了创建新进程的代码，将文件系统的镜像加载进去，然后让子进程运行程序。父进程独立于子进程运行。spawn函数实际上就像UNIX系统中的一个fork，然后在子进程中立即执行exec



我们实现了spawn而不是一个UNIX类型的exec是因为spawn更容易从用户空间以"exokernel方式"实现，且不需要内核的帮助。



**Exercise 7.** `spawn` relies on the new syscall `sys_env_set_trapframe` to initialize the state of the newly created environment. Implement `sys_env_set_trapframe` in `kern/syscall.c` (don't forget to dispatch the new system call in `syscall()`).

Test your code by running the `user/spawnhello` program from `kern/init.c`, which will attempt to spawn `/hello` from the file system.

Use make grade to test your code.



#### sys_env_set_trapframe

首先我们来看spawn中的代码：

```C
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
```

child是使用exo_fork创建的子进程，但是还未做任何设置，child_tf是准备给child进程的设置，是一个struct Trapframe结构

另一个需要注意的点是spawn中使用了FL_IOPL_3，我们前面提到过**x86处理器使用EFLAGS寄存器中的IOPL位来确定是否允许保护模式代码执行特殊的设备IO指令**，IOPL一共定义了四个

```C
#define FL_IOPL_MASK	0x00003000	// I/O Privilege Level bitmask
#define FL_IOPL_0	0x00000000	//   IOPL == 0
#define FL_IOPL_1	0x00001000	//   IOPL == 1
#define FL_IOPL_2	0x00002000	//   IOPL == 2
#define FL_IOPL_3	0x00003000	//   IOPL == 3
```

此处他们使用的是FL_IOPL_3，在数量层面上与我们前面用的FL_IOPL_MASK相同，但具体的区别暂时还不清楚

下面来看函数实现

```C
// Set envid's trap frame to 'tf'.
// tf is modified to make sure that user environments always run at code
// protection level 3 (CPL 3), interrupts enabled, and IOPL of 0.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	struct Env *env;
	int r;
	if ((r = envid2env(envid, &env, 1)) < 0) return r;
	// Set envid's trap frame to 'tf'.
	env->env_tf = *tf;
	// interrupts enabled
    // Lab4中提到过，**扩展中断被%eflags寄存器中的FL_IF位控制**
	env->env_tf->tf_eflags |= FL_IF;
	// IOPL of 0
	env->env_tf->tf_eflags &= ~FL_IOPL_MASK;
	// tf is modified to make sure that user environments always run at code
	// protection level 3 (CPL 3)
	env->env_tf->tf_cs = GD_UT | 3;
	return 0;
}
```

最后，在syscall中添加新的case

```C
		case SYS_env_set_trapframe:
			return sys_env_set_trapframe(a1, (struct Trapframe*)a2);
```



### 3.1、Sharing library state across fork and spawn

Unix文件描述符是一个通用概念，他还包括pipe、控制台IO等。在JOS中，每个设备都有一个相关的`struct Dev`，该结构中有一个指向函数的指针，这些函数实现了如read/write等功能。`lib/fd.c`实现了类UNIX的文件描述符接口。每个struct Fd表明设备类型，并且大部分`lib/fd.c`中的函数简单地配置了相关的struct Dev的操作



`lib/fd.c`也在每个应用进程地址空间中保存了文件描述符表区域，起始于`FDTABLE`。这个区域为至多32个文件描述符提供了可以立即打开的一个page大小的区域。任何时候，一个文件描述符页表被映射，当且仅当相关的文件描述符在使用中。每个文件描述符还有一个可选择的“数据页”起始于FILEDATA。



我们想通过fork和spawn共享文件描述符状态，但是文件描述符状态被保存在用户空间。到目前位置，fork中内存会被标记为copy-on-write，所以文件描述符状态会被复制，而不是共享。（这意味着进程将无法在他们没有打开的文件中进行查找，并且pipe无法跨fork工作）。在spawn中，内存会被留下，而不是复制。也就是说，spawn的进程没有文件描述符



我们要将fork改为知道哪些区域被“库系统”使用，并将这些区域共享。我们不会硬编码某个区域，而是在页表条目中设置一个otherwise-unused位。



我们在`inc/lib.h`中定义了一个新的PTE_SHARE。该位是Intel和AMD手册中被标记为"available for software use"的三个PTE位之一。我们要建立一个约定，如果页表条目设置了这个位，PTE应该在fork和spawn中直接从父进程复制到子进程。注意：这将于copy-on-write不同：如第一段所述，我们希望确保共享对页面的更新。（这是页面更新时父子进程同时更新的意思吗？）



**Exercise 8.** Change `duppage` in `lib/fork.c` to follow the new convention. If the page table entry has the `PTE_SHARE` bit set, just copy the mapping directly. (You should use `PTE_SYSCALL`, not `0xfff`, to mask out the relevant bits from the page table entry. `0xfff` picks up the accessed and dirty bits as well.)

Likewise, implement `copy_shared_pages` in `lib/spawn.c`. It should loop through all page table entries in the current process (just like `fork` did), copying any page mappings that have the `PTE_SHARE` bit set into the child process.



#### duppage

```C
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	// LAB 4: Your code here.
	int perm = PTE_U | PTE_P;
	// 首先判断PTE_SHARE位
	// 如果有则将所有的page 拷贝过去
	if ((uvpt[pn] & PTE_SHARE)){
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
		perm |= PTE_COW;
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
			panic("duppage: %e\n", r);
		}

		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
			panic("duppage: %e\n", r);
		}
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
		panic("duppage: %e\n", r);
	}

	return 0;
}
```



#### copy_shared_pages

```C
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
				return r;
		}
	}
	return 0;
}
```



### 3.2、The keyboard interface

为了使shell工作，我么需要一种方法来输入它。QEMU一直在显示我们写入到CGA显示器和串口的输出，但是到目前为止我们只在内核监视器中获取输入。QEMU中，在图形窗口中键入的输入显示为从键盘到JOS的输入，当输入内容输入到控制台时，显示为串口上的字符。



`kern/console.c`中已经包含了从lab1开始就被使用的键盘和串口驱动，但是现在我们需要把这些附加到系统的其他部分。



**Exercise 9.** In your `kern/trap.c`, call `kbd_intr` to handle trap `IRQ_OFFSET+IRQ_KBD` and `serial_intr` to handle trap `IRQ_OFFSET+IRQ_SERIAL`.



`inc/trap.h`中定义，

```C
#define IRQ_KBD          1
#define IRQ_SERIAL       4
```



#### trap_dispatch

```C
// Handle keyboard and serial interrupts.
	// LAB 5: Your code here.
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_KBD){
		kbd_intr();
		return ;
	}

	if(tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL){
		serial_intr();
		return ;
	}
```



按照其他的trap类型以及提示的函数填写即可，其中：

```C
void
kbd_intr(void)
{
	cons_intr(kbd_proc_data);
}

//这个函数就是从接收数据
/*
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void); //这个函数有点长，就不放出来了

//这个函数将接受的数据打印出来，所以我们运行的时候控制台我们输入什么接下来就打印什么
// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
```

串口trap也与之类似

```C
static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
	if (serial_exists)
		cons_intr(serial_proc_data);
}
```



### 3.3、The Shell

运行`make run-icode`或者`make run-icode-nox`。这样会运行我们的内核并且开始`user/icode`。icode执行init，init会设置控制台作为文件描述符0和描述符1（标准输入输出）。icode之后会spawn sh，也就是shell。我们要能够运行以下的命令：

```
	echo hello world | cat
	cat lorem |cat
	cat lorem |num
	cat lorem |num |num |num |num |num
	lsfd
```

注意用户库cprintf直接打印到控制台中，没有使用描述符代码。这种方法对debug很有利但是对piping into other programs不利。为了将输出打印到一个特殊的描述符表中，使用

```C
fprintf(1, "...", ...)
```



**Exercise 10.**

The shell doesn't support I/O redirection. It would be nice to run sh <script instead of having to type in all the commands in the script by hand, as you did above. Add I/O redirection for < to `user/sh.c`.

Test your implementation by typing sh <script into your shell

Run make run-testshell to test your shell. `testshell` simply feeds the above commands (also found in `fs/testshell.sh`) into the shell and then checks that the output matches `fs/testshell.key`.



#### runcmd

```C
// Open 't' for reading as file descriptor 0
			// (which environments use as standard input).
			// We can't open a file onto a particular descriptor,
			// so open the file as 'fd',
			// then check whether 'fd' is 0.
			// If not, dup 'fd' onto file descriptor 0,
			// then close the original 'fd'.

			// LAB 5: Your code here.
			//panic("< redirection not implemented");

			// Open 't' for reading as file descriptor 0
			int fd = open(t, O_RDONLY);
			if(fd < 0){
				cprintf("case <:open err - %e\n", fd);
				exit();
			}else if(fd){// then check whether 'fd' is 0.
			// If not, dup 'fd' onto file descriptor 0,
			// then close the original 'fd'.
				dup(fd, 0);
				close(fd);
			}
			break;
```



运行结果：

![result](https://github.com/anhongzhan/MIT6.828/blob/lab5/05Lab5/result.PNG)
