# Lab 4: Preemptive Multitasking

本次实验我们要实现在多个同时活动的用户模式环境中抢占多任务处理

part A要为JOS添加multiprocessor(多处理器)，实现循环调度(round-robin scheduling)，并添加基本的环境管理系统调用

part B要实现一个类Unix的fork()，该函数允许用户模式环境创造一个自己的复制版本

part C要添加进程间通信，允许不同的用户模式环境显式地互相通信和同步。我们要添加对硬件的时钟中断和抢占的支持。



## 1、Part A: Multiprocessor Support and Cooperative Multitasking

本部分要将JOS扩展成一个多任务处理系统，然后实现一些新的JOS内核系统调用，以便允许用户级别环境去创建额外的新环境。我们也要实现cooperative round-robin调度，当当前环境自动放弃CPU时，允许内核从一个环境切换到另一个。

### 1.1、Multiprocessor Support

我们要让JOS支持对称多处理器(symmetric multiprocessing,简称SMP)，多处理器模式指所有的CPU有对于系统资源例如内存和IO桥相同的访问权限。由于所有的CPU在SMP模式中功能都是相同的，在boot的过程中他们可以被分为两类：

- bootstrap peocessor(BSP):负责初始化系统并且boot the operating system
- application processors(APs):在操作系统建立并且启动之后，被BSP激活

哪个进程是BSP由硬件和BIOS决定，所有的JOS代码都是运行在BSP处理器上的。



在SMP系统中，每个CPU有an accompanying local APIC(LAPIC) unit。LAPIC unit负责系统之间传递中断，也为其连接的CPU提供唯一的标识符。本次实验中，我们要使用LAPIC unit的基本功能如下(`kern/lapic.c`)：

- 读取LAPIC identifier(APIC ID)以识别我们的代码整运行在哪个CPU上(see cpunum())
- 发送STARTUP处理器间中断，从BSP发送到APs，以打开其他的CPU(see lapic_startap())
- Part C中，我们建立LAPIC的内置定时器去触发时钟中断，以支持抢占式多任务处理

处理器使用内存映射IO(MMIO)完成他的LAPIC。在MMIO中，一部分物理内存被硬连接到一些IO设备的寄存器上，因此，通常用于访问内存的加载/存储指令也可以用于访问设备寄存器。你已经看到一个IO hole在物理地址0xA0000中。LAPIC lives in a hole starting at physical address 0xFE000000(32MB short of 4GB)，因此这部分地址对我们来说使用我们平常的直接映射太高了（映射不到）。JOS虚拟内存映射在MMIOBASE上留下了一个4MB的空白，这样我们就有了地方来映射这样的设备。由于后面的实验引入了更多的MMIO区域，因此我们将编写一个简单的函数从该区域分配空间，并将设备内存映射到该区域。



**Exercise 1.** Implement `mmio_map_region` in `kern/pmap.c`. To see how this is used, look at the beginning of `lapic_init` in `kern/lapic.c`. You'll have to do the next exercise, too, before the tests for `mmio_map_region` will run.



#### mmio_map_region



```C
// Reserve size bytes in the MMIO region and map [pa,pa+size) at this
// location.  Return the base of the reserved region.  size does *not*
// have to be multiple of PGSIZE.
```

函数前面的注释中写道`size does *not* have to be multiple of PGSIZE.`，但是代码里面的注释写道size必须向PGSIZE ROUNDUP，代码中要求`handle if this reservation would overflow MMIOLIM (it's okay to simply panic if this happens).`，所以代码中要使用panic。

本函数的目的就是将虚拟地址[MMIOBASE, MMIOBASE + size)和物理地址[pa, pa + size)映射到一起，base是静态变量，需要更新他，下一次分配的时候base就变了(base部分参考了网上的实现，我并没有在实验要求中找到相关的描述)

```C
void *
mmio_map_region(physaddr_t pa, size_t size)
{
	// Where to start the next region.  Initially, this is the
	// beginning of the MMIO region.  Because this is static, its
	// value will be preserved between calls to mmio_map_region
	// (just like nextfree in boot_alloc).
	static uintptr_t base = MMIOBASE;

	// Reserve size bytes of virtual memory starting at base and
	// map physical pages [pa,pa+size) to virtual addresses
	// [base,base+size).  Since this is device memory and not
	// regular DRAM, you'll have to tell the CPU that it isn't
	// safe to cache access to this memory.  Luckily, the page
	// tables provide bits for this purpose; simply create the
	// mapping with PTE_PCD|PTE_PWT (cache-disable and
	// write-through) in addition to PTE_W.  (If you're interested
	// in more details on this, see section 10.5 of IA32 volume
	// 3A.)
	//
	// Be sure to round size up to a multiple of PGSIZE and to
	// handle if this reservation would overflow MMIOLIM (it's
	// okay to simply panic if this happens).
	//
	// Hint: The staff solution uses boot_map_region.
	//
	// Your code here:
	//panic("mmio_map_region not implemented");
	size = ROUNDUP(size, PGSIZE);
	if(size + base > MMIOLIM){
		panic("MMIO_MAP_REGION failed: memory overflow MMIOLIM\n");
	}
	boot_map_region(kern_pgdir, base, size, pa, PTE_W | PTE_PCD | PTE_PWT);
	base += size;
	return (void*)(base - size);
}
```



这部分需要做完下一个联系之后才能验证对错！



### 1.2、Application Processor Bootstrap

在booting up APs之前，BSP应该先收集关于多处理器系统的信息，例如CPU的全部数量，他们的APIC ID以及LAPIC单元的MMIO地址。

`kern/mpconfig.c`中的mp_init函数阅读存储在BIOS区域的MP configuration table中的信息检索这些信息。

`kern/init.c`中的函数boot_aps()驱动AP bootstrap process。APs在实模式开启(boot/boot.S)，boot_aps函数复制AP entry code(kern/mpconfig.c)到实模式可以访问到的内存地址。和bootloader不同的是，我们可以控制AP从哪里开始执行代码。我们复制entry code到0x7000(MPENTRY_PADDR)，但是没有使用，页面对齐的物理地址只有低于640KB的区域可以工作。（虽然忘了哪里写着实模式下只有低于640KB的地址空间可以工作，但是0x7000可以换算成700KB，确实是大于640KB的）

复制之后，boot_aps()一个个的激活APs，通过给相关的AP发送STARTUP IPIs到LAPIC unit，以及初始的CS:IP地址，AP应该在该地址开始运行其入口代码（本例中为MPENTRY_PADDR）。`kern/mpconfig.c`中的entry code和`boot/boot.S`中非常相似。

After some brief setup, it puts the AP into protected mode with paging enabled, and then calls the C setup routine `mp_main()` (also in `kern/init.c`)（不会翻译了）

boot_aps等待AP发送一个CPU_STARTED的信号，收到信号后唤醒下一个AP



CPU_STARTED所在的数据结构

```C
// Values of status in struct Cpu
enum {
	CPU_UNUSED = 0,
	CPU_STARTED,
	CPU_HALTED,
};

// Per-CPU state
struct CpuInfo {
	uint8_t cpu_id;                 // Local APIC ID; index into cpus[] below
	volatile unsigned cpu_status;   // The status of the CPU
	struct Env *cpu_env;            // The currently-running environment.
	struct Taskstate cpu_ts;        // Used by x86 to find stack for interrupt
};
```



#### page_init()



**Exercise 2.** Read `boot_aps()` and `mp_main()` in `kern/init.c`, and the assembly code in `kern/mpentry.S`. Make sure you understand the control flow transfer during the bootstrap of APs. Then modify your implementation of `page_init()` in `kern/pmap.c` to avoid adding the page at `MPENTRY_PADDR` to the free list, so that we can safely copy and run AP bootstrap code at that physical address. Your code should pass the updated `check_page_free_list()` test (but might fail the updated `check_kern_pgdir()` test, which we will fix soon).



阅读boot_aps()以及mp_main()函数以及myentry.S，确保了解AP之间传输的控制流，然后实现page_init()以避免将MPENTRY_PADDR页加入到free_list中。



这三个函数的运行流程：

- 系统加载过程中调用boot_aps()函数

使用memmove()函数将mpentry.S中mpentry_start到mpentry_end部分的数据拷贝到MPENTRY_PADDR(0x7000)

```C
	// Write entry code to unused memory at MPENTRY_PADDR
	// mpentry_start mpentry_end可以见mpentry.S
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
```

然后开始Boot每一个AP，如下代码所示:

ncpu定义在`mpconfig.c`中表示CPU的个数，cpus定义在`cpu.h`中，是一个包含8个数据的数组，说明我们的系统中最多8个CPU

cpunum()函数会返回当前cpu的index，c == cpus + cpunum()说明这个CPU是当前正在运行着的CPU，不需要初始化了

percpu_kstacks是为每个CPU准备的栈，每个栈大小KSTKSIZE字节，并且需要注意，栈是从高地址向低地址扩展的，所以在设置栈地址的时候为percpu_kstacks[c - cpus] + KSTKSIZE

```C
// Per-CPU kernel stacks
unsigned char percpu_kstacks[NCPU][KSTKSIZE]
```

lapic_startap()函数会初始化AP，然后运行我们复制到0x7000处的代码，这部分代码最后会调用mp_main()并且发送CPU_STARTED参数

boot_aps接收到这个参数之后会初始化下一个CPU

```C
// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
		if (c == cpus + cpunum())  // We've started already.
			continue;

		// Tell mpentry.S what stack to use 
		// 栈从高地址向低地址扩展
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
		// Start the CPU at mpentry_start
		lapic_startap(c->cpu_id, PADDR(code));
		// Wait for the CPU to finish some basic setup in mp_main()
		while(c->cpu_status != CPU_STARTED)
			;
	}
```



我们要做的事情是完成`kern/pmap.c`中的page_init()函数，这个函数之前的实验中我们已经实现过，本次我们需要完成的工作如下：

```C
	// LAB 4:
	// Change your code to mark the physical page at MPENTRY_PADDR
	// as in use
```

代码如下：

```C
	// 5) Lab4
	// Change your code to mark the physical page at MPENTRY_PADDR
	// as in use
	size_t mpentry_index = PGNUM(MPENTRY_PADDR);

	// 1)
	pages[0].pp_ref = 1;
	pages[0].pp_link = NULL;

	// 2)
	size_t i;
	//for (i = 0; i < npages; i++) {
	for (i = 1; i < npages_basemem; i++) {
		if(i == mpentry_index) continue;
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}

	// 3)
	size_t io = (size_t)IOPHYSMEM / PGSIZE;
	size_t ex = (size_t)EXTPHYSMEM / PGSIZE;
	for(i = io; i < ex; i++){
		if(i == mpentry_index) continue;
		pages[i].pp_ref = 1;
		pages[i].pp_link = NULL;
	}
	
	// 4)
	// boot_alloc(0)返回第一个可用page的虚拟地址，此处需要转换成物理地址
	// ex = (size_t)EXTPHYSMEM / PGSIZE;
	// ex 往后的所有page有的可以使用，有的不可使用
	// 综上， [ex, boot_alloc(0))不可用， [boot_alloc(0), npages)可用
	size_t fisrt_page = PADDR(boot_alloc(0)) / PGSIZE;
	for(i = ex; i < fisrt_page; i++){
		if(i == mpentry_index) continue;
		pages[i].pp_ref = 1;
		pages[i].pp_link = NULL;
	}

	for(i = fisrt_page; i < npages; i++){
		if(i == mpentry_index) continue;
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}
```

在每个部分里面都增加判断`if(i == mpentry_index) continue;`



运行`make qemu`

```
heck_page_free_list() succeeded!
page_alloc: out of free memory
page_alloc: out of free memory
check_page_alloc() succeeded!
page_alloc: out of free memory
page_alloc: out of free memory
page_alloc: out of free memory
page_alloc: out of free memory
page_alloc: out of free memory
page_alloc: out of free memory
kernel panic on CPU 0 at kern/pmap.c:1174: assertion failed: !(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U)
```



### 1.3、Question

1. Compare `kern/mpentry.S` side by side with `boot/boot.S`. Bearing in mind that `kern/mpentry.S` is compiled and linked to run above `KERNBASE` just like everything else in the kernel, what is the purpose of macro `MPBOOTPHYS`? Why is it necessary in `kern/mpentry.S` but not in `boot/boot.S`? In other words, what could go wrong if it were omitted in `kern/mpentry.S`?
   Hint: recall the differences between the link address and the load address that we have discussed in Lab 1.

`MPBOOTPHYS`=0x7000，其作用是获取变量的物理地址，由于当前执行的代码是`mpentry.S`复制过去的代码，此时通过标签获取相对地址的方法已经失效（因为标签是原本复制之前的地址），所以只能通过绝对地址的方式进行访问。而Boot.S是整个扇区的数据都被加载到0x7c00，可以使用相对寻址的方式。



### 1.4、Per-CPU State and Initialization

编写多处理器OS时，区分那部分属于处理器私有内存，那部分属于处理器间公用的内存非常重要。

`kern/cpu.h`定义了大多数的单个CPU状态，包括`struct CpuInfo`，存储单个CPU变量；`cpunum()`返回CPU在cpus数组中的下标；

宏`thiscpu`代表当前CPU的`struct CpuInfo`

下面是我们需要知道的单个CPU状态信息

- Per-CPU kernel stack

​		由于多个CPU可以同时tarp into 内核，因此我们需要给每个处理器一个单独的栈来防止CPU之间执行彼此之间冲突。    percpu_kstacks [NCPU] [KSTKSIZE]为多个CPU保存栈空间

​		实验2中我们将物理地址bootstack映射到BSP内核栈，这部分地址就在KSTACKTOP下面。类似地，本次实验也要将CPU的栈映射到这部分区域。CPU0的栈仍然在KSTACKTOP下面，CPU1的栈距离CPU0占地KSTKGAP。具体分步可以见`memlayout.h`

- Per-CPU TSS and TSS descriptor

​	 	per-CPU task state segment(TSS)指定每个CPU的内核栈分步在哪里。CPU i的TSS存储在cpus[i].cpu_ts，相关的TSS descriptor记录在GDT中gdt[(GD_TSS0 >> 3) + i]。全局ts变量定义在`kern/trap.c`中，永远不会被用到。

- Per-CPU current environment pointer

​		 因为每个CPU都可以同时运行不同的用户进程，所以我们将curenv重新定义为cpus[cpunum()]。cpu_env(或者说thiscpu->cou_env)指向当前CPU所运行的环境中。

- Per-CPU system registers

​		 所有的寄存器，包括系统寄存器，都是CPU私有的。因此，初始化这些寄存器的指令，如lcr3(),ltr()等必须在每个CPU上面都执行。

​		 函数env_init_percpu()以及trap_init_percpu()因此被定义。



除此之外，如果前面的实验中你已经添加了任何额外的per-CPU state或者执行任何额外的CPU初始化，请将其还原回来！！！



#### mem_init_mp



**Exercise 3.** Modify `mem_init_mp()` (in `kern/pmap.c`) to map per-CPU stacks starting at `KSTACKTOP`, as shown in `inc/memlayout.h`. The size of each stack is `KSTKSIZE` bytes plus `KSTKGAP` bytes of unmapped guard pages. Your code should pass the new check in `check_kern_pgdir()`.



题目要求我们按照memlayout.h中的分步为每个CPU的栈进行映射

```C
 *    KERNBASE, ---->  +------------------------------+ 0xf0000000      --+
 *    KSTACKTOP        |     CPU0's Kernel Stack      | RW/--  KSTKSIZE   |
 *                     | - - - - - - - - - - - - - - -|                   |
 *                     |      Invalid Memory (*)      | --/--  KSTKGAP    |
 *                     +------------------------------+                   |
 *                     |     CPU1's Kernel Stack      | RW/--  KSTKSIZE   |
 *                     | - - - - - - - - - - - - - - -|                 PTSIZE
 *                     |      Invalid Memory (*)      | --/--  KSTKGAP    |
 *                     +------------------------------+                   |
```

另外记得栈是从高地址向低地址扩展的

```C
static void
mem_init_mp(void)
{
	// Map per-CPU stacks starting at KSTACKTOP, for up to 'NCPU' CPUs.
	//
	// For CPU i, use the physical memory that 'percpu_kstacks[i]' refers
	// to as its kernel stack. CPU i's kernel stack grows down from virtual
	// address kstacktop_i = KSTACKTOP - i * (KSTKSIZE + KSTKGAP), and is
	// divided into two pieces, just like the single stack you set up in
	// mem_init:
	//     * [kstacktop_i - KSTKSIZE, kstacktop_i)
	//          -- backed by physical memory
	//     * [kstacktop_i - (KSTKSIZE + KSTKGAP), kstacktop_i - KSTKSIZE)
	//          -- not backed; so if the kernel overflows its stack,
	//             it will fault rather than overwrite another CPU's stack.
	//             Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	//
	// LAB 4: Your code here:
	for(int i = 0; i < NCPU; i++){
		boot_map_region(kern_pgdir, 
						KSTACKTOP - i * (KSTKSIZE + KSTKGAP) - KSTKSIZE,
						KSTKSIZE,
						PADDR(percpu_kstacks[i]),
						PTE_W);
	}
}
```



运行`make qemu`可以得到

```
check_page() succeeded!
check_kern_pgdir() succeeded!
check_page_free_list() succeeded!
check_page_installed_pgdir() succeeded!
```





#### trap_init_percpu



**Exercise 4.** The code in `trap_init_percpu()` (`kern/trap.c`) initializes the TSS and TSS descriptor for the BSP. It worked in Lab 3, but is incorrect when running on other CPUs. Change the code so that it can work on all CPUs. (Note: your new code should not use the global `ts` variable any more.)



修改`kern/trap.c`中的trap_init_percpu函数，该函数为BSP初始化TSS以及TSS描述符，但是在其他CPU上运行会出错，我们要修改这个错误。注意：不可以使用global `ts` variable



注意本次练习要求我们修改代码，修改的部分如下：

```C
// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
	ts.ts_ss0 = GD_KD;
	ts.ts_iomb = sizeof(struct Taskstate);

	// Initialize the TSS slot of the gdt.
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0);
```



首先我们要了解以下TSS以及TSS descriptor的结构

```C
// Task state segment format (as described by the Pentium architecture book)
struct Taskstate {
	uint32_t ts_link;	// Old ts selector
	uintptr_t ts_esp0;	// Stack pointers and segment selectors
	uint16_t ts_ss0;	//   after an increase in privilege level
	uint16_t ts_padding1;
	uintptr_t ts_esp1;
	uint16_t ts_ss1;
	uint16_t ts_padding2;
	uintptr_t ts_esp2;
	uint16_t ts_ss2;
	uint16_t ts_padding3;
	physaddr_t ts_cr3;	// Page directory base
	uintptr_t ts_eip;	// Saved state from last task switch
	uint32_t ts_eflags;
	uint32_t ts_eax;	// More saved state (registers)
	uint32_t ts_ecx;
	uint32_t ts_edx;
	uint32_t ts_ebx;
	uintptr_t ts_esp;
	uintptr_t ts_ebp;
	uint32_t ts_esi;
	uint32_t ts_edi;
	uint16_t ts_es;		// Even more saved state (segment selectors)
	uint16_t ts_padding4;
	uint16_t ts_cs;
	uint16_t ts_padding5;
	uint16_t ts_ss;
	uint16_t ts_padding6;
	uint16_t ts_ds;
	uint16_t ts_padding7;
	uint16_t ts_fs;
	uint16_t ts_padding8;
	uint16_t ts_gs;
	uint16_t ts_padding9;
	uint16_t ts_ldt;
	uint16_t ts_padding10;
	uint16_t ts_t;		// Trap on task switch
	uint16_t ts_iomb;	// I/O map base address
};

// Segment Descriptors
struct Segdesc {
	unsigned sd_lim_15_0 : 16;  // Low bits of segment limit
	unsigned sd_base_15_0 : 16; // Low bits of segment base address
	unsigned sd_base_23_16 : 8; // Middle bits of segment base address
	unsigned sd_type : 4;       // Segment type (see STS_ constants)
	unsigned sd_s : 1;          // 0 = system, 1 = application
	unsigned sd_dpl : 2;        // Descriptor Privilege Level
	unsigned sd_p : 1;          // Present
	unsigned sd_lim_19_16 : 4;  // High bits of segment limit
	unsigned sd_avl : 1;        // Unused (available for software use)
	unsigned sd_rsv1 : 1;       // Reserved
	unsigned sd_db : 1;         // 0 = 16-bit segment, 1 = 32-bit segment
	unsigned sd_g : 1;          // Granularity: limit scaled by 4K when set
	unsigned sd_base_31_24 : 8; // High bits of segment base address
};
```



我们要修改的内容包括栈指针、段名、I/O map base address、sd_s、以及整个TSS descriptor

仿照原本修改BSP的代码以及提示里面的内存修改即可：

```C
void
trap_init_percpu(void)
{
	// The example code here sets up the Task State Segment (TSS) and
	// the TSS descriptor for CPU 0. But it is incorrect if we are
	// running on other CPUs because each CPU has its own kernel stack.
	// Fix the code so that it works for all CPUs.
	//
	// Hints:
	//   - The macro "thiscpu" always refers to the current CPU's
	//     struct CpuInfo;
	//   - The ID of the current CPU is given by cpunum() or
	//     thiscpu->cpu_id;
	//   - Use "thiscpu->cpu_ts" as the TSS for the current CPU,
	//     rather than the global "ts" variable;
	//   - Use gdt[(GD_TSS0 >> 3) + i] for CPU i's TSS descriptor;
	//   - You mapped the per-CPU kernel stacks in mem_init_mp()
	//   - Initialize cpu_ts.ts_iomb to prevent unauthorized environments
	//     from doing IO (0 is not the correct value!)
	//
	// ltr sets a 'busy' flag in the TSS selector, so if you
	// accidentally load the same TSS on more than one CPU, you'll
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	int i = cpunum();

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	// ts.ts_esp0 = KSTACKTOP;
	// ts.ts_ss0 = GD_KD;
	// ts.ts_iomb = sizeof(struct Taskstate);
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t)percpu_kstacks[i];
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
	thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);


	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	// gdt[GD_TSS0 >> 3].sd_s = 0;
	gdt[(GD_TSS0 >> 3) + i] = SEG16(STS_T32A, (uint32_t)(&thiscpu->cpu_ts),
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + i].sd_s = 0;

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + (i << 3));

	// Load the IDT
	lidt(&idt_pd);
}
```



运行`make qemu CPUS = 4`可以得到：

```
check_page() succeeded!
check_kern_pgdir() succeeded!
check_page_free_list() succeeded!
check_page_installed_pgdir() succeeded!
SMP: CPU 0 found 4 CPU(s)
enabled interrupts: 1 2
SMP: CPU 1 starting
SMP: CPU 2 starting
SMP: CPU 3 starting
```



### 1.5、Locking

我们在mp_main()函数初始化AP之后需要停一下，在让AP运行的更久之前，我们需要解决多个CPU同时运行内核代码时的竞争问题。最简单的解决办法就是使用一个大的内核锁(a big kernel lock)。大的内核锁维护着环境何时进入内核模式以及环境何时离开内核模式返回用户模式。在这种模型中，用户模式中的环境可以同时运行在任何可用的CPU上，但不会有超过一个环境可以运行在内核模式。任何要进入内核模式的环境要强制进行等待。

`kern/spinlock.h`定义了打的内核锁，命名为`kernel_lock`。这个文件中还有`lock_kernel`以及`unlock_kernel`，属于获取和释放所得快捷键，我们需要将内核锁应用到四个场景：

- In `i386_init()`, acquire the lock before the BSP wakes up the other CPUs.
- In `mp_main()`, acquire the lock after initializing the AP, and then call `sched_yield()` to start running environments on this AP.
- In `trap()`, acquire the lock when trapped from user mode. To determine whether a trap happened in user mode or in kernel mode, check the low bits of the `tf_cs`.
- In `env_run()`, release the lock *right before* switching to user mode. Do not do that too early or too late, otherwise you will experience races or deadlocks.



**Exercise 5.** Apply the big kernel lock as described above, by calling `lock_kernel()` and `unlock_kernel()` at the proper locations.



首先我们来看 `lock_kernel()` 以及 `unlock_kernel()` 

```C
static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
}

```

这两个函数本质上就是在调用`spin_lock`以及`spin_unlock`函数，这两个函数的参数都是`struct spinlock`

里面最重要的内容就是`struct CpuInfo *cpu`，表示这个锁是否在锁着某个CPU

```C
// Mutual exclusion lock.
struct spinlock {
	unsigned locked;       // Is the lock held?

#ifdef DEBUG_SPINLOCK
	// For debugging:
	char *name;            // Name of lock.
	struct CpuInfo *cpu;   // The CPU holding the lock.
	uintptr_t pcs[10];     // The call stack (an array of program counters)
	                       // that locked the lock.
#endif
};
```



观察`spin_lock`以及`spin_unlock`函数

```
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
	get_caller_pcs(lk->pcs);
#endif
}

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
	lk->cpu = 0;
#endif

	// The xchg instruction is atomic (i.e. uses the "lock" prefix) with
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
```



最重要的部分我觉得是如下两点：

```C
lk->cpu = thiscpu;		//spin_lock
lk->cpu = 0;			//spin_unlock
```

这两部分表示cpu上锁以及解锁



接下来修改代码，按照题目要求的四个部分来



#### i386_init

```C
	// Acquire the big kernel lock before waking up APs
	// Your code here:
	lock_kernel();
```



#### mp_main

```C
	// Now that we have finished some basic setup, call sched_yield()
	// to start running processes on this CPU.  But make sure that
	// only one CPU can enter the scheduler at a time!
	//
	// Your code here:
	lock_kernel();
```



#### trap

```C
	if ((tf->tf_cs & 3) == 3) {
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.
		// assert(curenv);
		lock_kernel();
```



#### env_run

```C
	curenv = e;
	e->env_status = ENV_RUNNING;
	e->env_runs++;
	lcr3(PADDR(e->env_pgdir));
	unlock_kernel();			//  <------ 添加这句
	env_pop_tf(&e->env_tf);
```



本练习后暂时无法测试是否正确，我们在完成下一个练习之后一起测试！



### 1.6、Question

2. It seems that using the big kernel lock guarantees that only one CPU can run the kernel code at a time. Why do we still need separate kernel stacks for each CPU? Describe a scenario in which using a shared kernel stack will go wrong, even with the protection of the big kernel lock.

内核锁的获取实在trap in kernel之后，在这之前已经向栈中压入cs eip等内容，如果使用共享栈会使栈出现错乱。



### 1.7、Round-Robin Scheduling

我们接下来的工作就是修改内核，让内核以循环(Round-Robin)的方式在多个环境之间交替使用。

Round-Robin scheduling in JOS works as follows:

- `kern/sched.c`中的sched_yield()函数负责选择一个新的environment去运行。他以循环的方式搜索envs[]数组，在当前环境刚刚运行之后就开始选择。选择第一个带有ENV_RUNNABLE状态的环境，并且调用env_run()函数跳转到该环境。
- sched_yield()函数一定不能在两个CPU上运行相同的环境。他能识别某个环境是否运行在某个CPU上，因为环境的状态是ENV_RUNNING
- 我们实现了一个新的系统调用sys_yield()，在该系统中用户环境可以调用内核的sched_yield函数，因此其无法选择其他的CPU



**Exercise 6.** Implement round-robin scheduling in `sched_yield()` as described above. Don't forget to modify `syscall()` to dispatch `sys_yield()`.

Make sure to invoke `sched_yield()` in `mp_main`.

Modify `kern/init.c` to create three (or more!) environments that all run the program `user/yield.c`.

Run make qemu. You should see the environments switch back and forth between each other five times before terminating, like below.

Test also with several CPUS: make qemu CPUS=2.

```
...
Hello, I am environment 00001000.
Hello, I am environment 00001001.
Hello, I am environment 00001002.
Back in environment 00001000, iteration 0.
Back in environment 00001001, iteration 0.
Back in environment 00001002, iteration 0.
Back in environment 00001000, iteration 1.
Back in environment 00001001, iteration 1.
Back in environment 00001002, iteration 1.
...
```

After the `yield` programs exit, there will be no runnable environment in the system, the scheduler should invoke the JOS kernel monitor. If any of this does not happen, then fix your code before proceeding.



#### sched_yield

使用循环的方式找到下一个状态为ENV_RUNNABLE的环境

```C
void
sched_yield(void)
{
	struct Env *idle;

	// Implement simple round-robin scheduling.
	//
	// Search through 'envs' for an ENV_RUNNABLE environment in
	// circular fashion starting just after the env this CPU was
	// last running.  Switch to the first such environment found.
	//
	// If no envs are runnable, but the environment previously
	// running on this CPU is still ENV_RUNNING, it's okay to
	// choose that environment.
	//
	// Never choose an environment that's currently running on
	// another CPU (env_status == ENV_RUNNING). If there are
	// no runnable environments, simply drop through to the code
	// below to halt the cpu.

	// LAB 4: Your code here.
	idle = NULL;
	if (curenv){ //如果curenv存在
		size_t eidx = ENVX(curenv->env_id);
		uint32_t mask = NENV - 1;
		for (size_t i = (eidx + 1) & mask; i != eidx; i = (i + 1) & mask){
			if(envs[i].env_status == ENV_RUNNABLE){
				idle = &envs[i];
				break;
			}
		}
		if(!idle && curenv->env_status == ENV_RUNNING){
			idle = curenv;
		}
	} else { //curenv不存在
		for(size_t i = 0; i < NENV; ++i) {
			if(envs[i].env_status == ENV_RUNNABLE){
				idle = &envs[i];
				break;
			}
		}
	}

	if(idle){
		env_run(idle);
	}

	// sched_halt never returns
	sched_halt();
}
```



#### syscall

```C
switch (syscallno) {
	case SYS_cputs:
		sys_cputs((const char*)a1, (size_t)a2);
		return 0;
	case SYS_cgetc:
		return sys_cgetc();
	case SYS_getenvid:
		return (envid_t)sys_getenvid();
	case SYS_env_destroy:
		return sys_env_destroy((envid_t)a1);
	case SYS_yield:   //添加
		sys_yield();  //添加
		return 0;	  //添加
	default:
		return -E_INVAL;
	}
```



#### mp_main

接下来修改mp_main()，根据提示将死循环去掉然后调用sched_yield()即可

```C
// Remove this after you finish Exercise 6
	// for (;;);
	sched_yield();
```



#### i386_init

`kern/init.c`中，为程序创造三个或更多环境

```C
#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
#else
	// Touch all you want.
	//ENV_CREATE(user_primes, ENV_TYPE_USER);
	ENV_CREATE(user_yield, ENV_TYPE_USER);
	ENV_CREATE(user_yield, ENV_TYPE_USER);
	ENV_CREATE(user_yield, ENV_TYPE_USER);
#endif // TEST*
```



运行make qemu

![exercise6](https://github.com/anhongzhan/MIT6.828/blob/lab4/04Lab4/exercise6.PNG)



### 1.8、Question

3. In your implementation of `env_run()` you should have called `lcr3()`. Before and after the call to `lcr3()`, your code makes references (at least it should) to the variable `e`, the argument to `env_run`. Upon loading the `%cr3` register, the addressing context used by the MMU is instantly changed. But a virtual address (namely `e`) has meaning relative to a given address context--the address context specifies the physical address to which the virtual address maps. Why can the pointer `e` be dereferenced both before and after the addressing switch?

答：所有进程的地址空间在内核部分都是相同的，就算换了页表也是相同的



4. Whenever the kernel switches from one environment to another, it must ensure the old environment's registers are saved so they can be restored properly later. Why? Where does this happen?

答：进程没有自己单独的内核栈，而进程又必须要恢复，所以必须要有某种数据结构来保存进程的信息



### 1.9、System Calls for Environment Creation

虽然现在可以支持多个用户进程运行，但目前仍然局限于内核初始化的进程。接下来我们的目的就是要让用户进程自己创建新的进程

Unix提供了fork()系统调用来进行系统创建。Unix fork复制调用进程的完整的地址空间来创建新的进程（子进程）。两个进程唯一的不同就是process ID不同。父进程调用fork()返回紫禁城的process ID，子进程中，fork()返回0。默认情况下，每个进程都有它自己的地址空间，且每个进程对内存的修改其他进程都是不可见的

我们要实现一个比较简陋的JOS系统调用，来创建新的用户模式进程(就是环境)。使用如下这些系统调用我们能够在用户模式中实现类Unix的fork()。我们要实现的系统调用如下：

`sys_exofork`:

This system call creates a new environment with an almost blank slate: nothing is mapped in the user portion of its address space, and it is not runnable. The new environment will have the same register state as the parent environment at the time of the `sys_exofork` call. In the parent, `sys_exofork` will return the `envid_t` of the newly created environment (or a negative error code if the environment allocation failed). In the child, however, it will return 0. (Since the child starts out marked as not runnable, `sys_exofork` will not actually return in the child until the parent has explicitly allowed this by marking the child runnable using....)

`sys_env_set_status`:

Sets the status of a specified environment to `ENV_RUNNABLE` or `ENV_NOT_RUNNABLE`. This system call is typically used to mark a new environment ready to run, once its address space and register state has been fully initialized.

`sys_page_alloc`:

Allocates a page of physical memory and maps it at a given virtual address in a given environment's address space.

`sys_page_map`:

Copy a page mapping (*not* the contents of a page!) from one environment's address space to another, leaving a memory sharing arrangement in place so that the new and the old mappings both refer to the same page of physical memory.

`sys_page_unmap`:

Unmap a page mapped at a given virtual address in a given environment.



以上所有的系统调用接收environment id，内核支持输入0代表当前进程。这部分由`kern/env.c`中的envid2env()来实现

实验提供了一个非常简陋的类Unix的fork()实现(`user/dumbfork.c`)，测试程序使用上面提到的系统调用去创建和运行带有自己地址空间副本的子进程。然后两个进程switch back（这个应该是怎么切换？）并且强制使用sys_yield实现循环调用。父进程诗词迭代后退出，子进程二十次迭代后退出。



**Exercise 7.** Implement the system calls described above in `kern/syscall.c` and make sure `syscall()` calls them. You will need to use various functions in `kern/pmap.c` and `kern/env.c`, particularly `envid2env()`. For now, whenever you call `envid2env()`, pass 1 in the `checkperm` parameter. Be sure you check for any invalid system call arguments, returning `-E_INVAL` in that case. Test your JOS kernel with `user/dumbfork` and make sure it works before proceeding.



实验要求我们实现前面提到过的系统调用，并在syscall.c中调用他们。我们需要使用`kern/pamp.c`以及`kern/env.c`中的各种函数，尤其是envid2env()。



#### sys_exofork

```C
// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
//	-E_NO_MEM on memory exhaustion.
```

分配一个新的进程（环境），并且规定好了返回值

```C
static envid_t
sys_exofork(void)
{
	// Create the new environment with env_alloc(), from kern/env.c.
	// It should be left as env_alloc created it, except that
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	// LAB 4: Your code here.
	// panic("sys_exofork not implemented");
	int e;
	struct Env *parent, *child;
	parent = curenv;

	// Create the new environment with env_alloc()
	if((e = env_alloc(&child, parent->env_id)) < 0){
		//失败的情况和env_alloc失败的情况相同
		return e;
	}

	//子进程和父进程由相同的寄存器状态，实验描述中写着的
	child->env_tf = parent->env_tf;
	//子进程状态设置，函数注释中写着的
	child->env_status = ENV_NOT_RUNNABLE;
	//子进程返回值为0，但是为什么eax是返回值
	//而且看网上的实现大家都默认这件事了
	//我只记得Lab3中提到过系统调用eax是第一个参数以及返回值
	//不知道是否和这个有关
	child->env_tf.tf_regs.reg_eax = 0;
	return child->env_id;
}
```



#### sys_env_set_status

```C
// Set envid's env_status to status, which must be ENV_RUNNABLE
// or ENV_NOT_RUNNABLE.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
```

根据envid设置该env的状态为ENV_RUNNABLE或ENV_NOT_RUNNABLE

```C
static int
sys_env_set_status(envid_t envid, int status)
{
	// Hint: Use the 'envid2env' function from kern/env.c to translate an
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	// panic("sys_env_set_status not implemented");
	struct Env* e;
	//	-E_INVAL if status is not a valid status for an environment.
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE){
		return -E_INVAL;
	}
	//	-E_BAD_ENV if environment envid doesn't currently exist,
	if(envid2env(envid, &e, 1) != 0){
		return -E_BAD_ENV;
	}
	e->env_status = status;
	return 0;
}
```

这部分代码根据提示写就可以



#### sys_page_alloc

```C
// Allocate a page of memory and map it at 'va' with permission
// 'perm' in the address space of 'envid'.
// The page's contents are set to 0.
// If a page is already mapped at 'va', that page is unmapped as a
// side effect.
//
// perm -- PTE_U | PTE_P must be set, PTE_AVAIL | PTE_W may or may not be set,
//         but no other bits may be set.  See PTE_SYSCALL in inc/mmu.h.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
```

分配一页内存并将其映射到va，且带有权限perm

页的内容设置为0，如果某个页已经映射到va了，那么就解绑该页

```C
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	// Hint: This function is a wrapper around page_alloc() and
	//   page_insert() from kern/pmap.c.
	//   Most of the new code you write should be to check the
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	// LAB 4: Your code here.
	// panic("sys_page_alloc not implemented");
	struct PageInfo* pp = NULL;
	struct Env* e = NULL;
	int r;
	int flag = PTE_U | PTE_P;

	va = (uintptr_t)va;

	//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
	if(envid2env(envid, &e) < 0)
		return -E_BAD_ENV;
	
	//	-E_INVAL if va >= UTOP, or va is not page-aligned.
	if(va >= UTOP || (ROUNDDOWN(va, PGSIZE) != va))
		return -E_INVAL;

	//	-E_INVAL if perm is inappropriate (see above).
	if((perm & flag != flag) || (perm & ~PTE_SYSCALL) != 0)
		return -E_INVAL;

	//	-E_NO_MEM if there's no memory to allocate the new page,
	if((pp = page_alloc(ALLOC_ZERO)) == NULL)
		return -E_NO_MEM;

	if((r = page_insert(e->env_pgdir, pp, (void*)va, perm)) < 0){
		page_free(pp);
		return r;
	}

	return 0;
		 
}
```



#### sys_page_map

```C
// Map the page of memory at 'srcva' in srcenvid's address space
// at 'dstva' in dstenvid's address space with permission 'perm'.
// Perm has the same restrictions as in sys_page_alloc, except
// that it also must not grant write access to a read-only
// page.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
//		or the caller doesn't have permission to change one of them.
//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
//		or dstva >= UTOP or dstva is not page-aligned.
//	-E_INVAL is srcva is not mapped in srcenvid's address space.
//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
```

srcva表示source virtual address，dstva表示destination virtual address

该函数的作用是将一个进程的页映射到另一个进程中

```C
static int
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
	// Hint: This function is a wrapper around page_lookup() and
	//   page_insert() from kern/pmap.c.
	//   Again, most of the new code you write should be to check the
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 4: Your code here.
	// panic("sys_page_map not implemented");
	struct Env* src = NULL;
	struct Env* dst = NULL;

	//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
	if(envid2env(srcenvid, &src, 1) < 0 || envid2env(dstenvid, &dst, 1))
		return -E_BAD_ENV;

	//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned
	if((uintptr_t)srcva >= UTOP || ROUNDDOWN((uintptr_t)srcva, PGSIZE) != (uintptr_t)srcva)
		return -E_INVAL;

	//		or dstva >= UTOP or dstva is not page-aligned.
	if((uintptr_t)dstva >= UTOP || ROUNDDOWN((uintptr_t)dstva, PGSIZE) != (uintptr_t)dstva)
		return -E_INVAL;

	//	-E_INVAL is srcva is not mapped in srcenvid's address space.
	pte_t* pte_addr = NULL;
	struct PageInfo* page = NULL;
	if((page = page_lookup(src->env_pgdir, srcva, &pte_addr)) == NULL)
		return -E_INVAL;

	//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
	if(((perm & PTE_U) == 0) || ((perm & PTE_P) == 0) || ((perm & ~PTE_SYSCALL) != 0))
		return -E_INVAL;

	//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
	//		address space.
	if(((perm & PTE_U) == 0) || ((perm & PTE_P) == 0) || ((perm & ~PTE_SYSCALL) != 0))
		return -E_INVAL;

	//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
	if(page_insert(dst->env_pgdir, page, dstva, perm) < 0)
		return -E_NO_MEM;

	return 0;
}
```



#### sys_page_unmap

```C
// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.

static int
sys_page_unmap(envid_t envid, void *va)
{
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
	// panic("sys_page_unmap not implemented");
	struct Env* e;

	//	-E_BAD_ENV if environment envid doesn't currently exist,
	if(envid2env(envid, &e, 1) < 0)
		return -E_BAD_ENV;

	//	-E_INVAL if va >= UTOP, or va is not page-aligned.
	if((uintptr_t)va >= UTOP || PGOFF(va))
		return -E_INVAL

	page_remove(e->env_pgdir, va);
	return 0;
}
```

发现了一个宏

```C
#define PGOFF(la)	(((uintptr_t) (la)) & 0xFFF)
```

这个宏可以直接判断虚拟地址是否是page-aligned的



#### syscall

最后增加syscall里面的case即可

```C
case SYS_exofork:
		return sys_exofork();
	case SYS_env_set_status:
		return (envid_t)sys_env_set_status((envid_t)a1, (int)a2);
	case SYS_page_alloc:
		return (envid_t)sys_page_alloc((envid_t)a1, (void*)a2, (int)a3);
	case SYS_page_map:
		return (envid_t)sys_page_map((envid_t)a1, (void*)a2, (envid_t)a3, (void*)a4, (int)a5);
	case SYS_page_unmap:
		return (envid_t)sys_page_unmap((envid_t)a1, (void*)a2);
```



运行`make grade`，可以得到

```
dumbfork: OK (2.9s) 
    (Old jos.out.dumbfork failure log removed)
Part A score: 5/5
```

Part A完成



## 2、Part B: Copy-on-Write Fork

前面提到过，Unix提供fork()系统调用进行进程创建。fork()复制原始地址进程的地址空间创建新的进程。

xv6 Unix实现fork()的方法是将父节点页面中的所有数据复制到分配给子节点的新页面中。这本质上与dumbfork()采用的方法相同。将父进程的地址空间复制到子进程中是fork()操作中开销最大的部分。

但是，调用fork()之后，通常会立即在子进程中调用exec()，浙江用一个新的程序替换子进程的内存，这是shell经常做的事情。如果这样的话，拿我们复制地址空间的工作就被浪费了，因为子进程在调用exec()之前只用了很少的一部分内存。

因为这个原因，之后版本的Unix系统允许子进程和父进程共享映射到各地的内存空间，直到某个进程实际修改了某段内存。这个机制被叫做`copy-on-write`。为了这样做，fork函数会复制父进程的地址空间**映射**给子进程代替原本的复制地址空间，同时标记当前共享的页为只读的。当两个进程中有需要写共享页时，进程会发出一次page fault。此时，Unix内核会知道当前的映射页面是原始的虚拟地址还是`cpoy-on-write`版本的，并且创造一个新的私有的可以写的复制页面给faulting process（因为这个进程刚刚take a page fault）。用这种方法，私人页面的内容在被written之前就不会被复制。这种优化使得紧接着fork()执行的exec()函数的执行非常有效率：子进程在执行exec()之前只需要复制一个page。



### 2.1、User-level page fault handling

用户级别的`copy-on-write`的fork()函数需要知道page faults on write-protected pages，这就是我们要先实现的内容。

通常设置一个地址空间，以便页面错误指示何时需要执行某些操作。例如，大多数Unix内核最初只在新进程的堆栈区域中映射一个页面，然后随着页面消耗的增加，并在尚未映射的堆栈地址上导致页面错误，然后“按需”分配和映射额外的堆栈页面。

这种方法内核需要跟踪大量的信息。与采用传统的Unix方法不同，您将决定如何处理用户空间中的每个页面错误。这种设计的额外好处是允许程序在定义他们的内存区域时具有很大的灵活性；稍后将使用用户级页面错误处理来映射和访问基于磁盘的文件系统上的文件。



### 2.2、Setting the Page Fault Handler

为了处理自己的page faults，用户进程需要注册一个page fault handler entrypoint。

用户进程通过一个新的系统调用`sys_env_set_pgfault_upcall`来注册新的page fault entrypoint。

我们已经为`Env`数据结构添加了一个新的成员`env_pgfault_upcall`，为了记录这段信息



**Exercise 8.** Implement the `sys_env_set_pgfault_upcall` system call. Be sure to enable permission checking when looking up the environment ID of the target environment, since this is a "dangerous" system call.



我们需要完成`sys_env_set_pgfault_upcall`，在`kern/syscall`中

```C
// Set the page fault upcall for 'envid' by modifying the corresponding struct
// Env's 'env_pgfault_upcall' field.  When 'envid' causes a page fault, the
// kernel will push a fault record onto the exception stack, then branch to
// 'func'.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
```

我们首先来看修改后的Env数据结构，新增了如下内容

```C
	// Exception handling
	void *env_pgfault_upcall;	// Page fault upcall entry point
```

我们要做的工作就是设置Env的这部分内容，按照题目要求需要先判断是否拥有权限

```C
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
	// panic("sys_env_set_pgfault_upcall not implemented");
	struct Env* e;
	if(envid2env(envid, &e, 1) < 0)
		return -E_BAD_ENV;
	e->env_pgfault_upcall = func;
	return 0;
}
```

最后添加case

```C
	case SYS_env_set_pgfault_upcall:
		return (envid_t)sys_env_set_pgfault_upcall((envid_t)a1, (void*)a2);
```



### 2.3、Normal and Exception Stacks in User Environments

JOS的用户进程使用用户栈，ESP指针指向USTACKTOP，栈数据存储在 `USTACKTOP-PGSIZE` and `USTACKTOP-1`之间。但是，当用户模式下发生page fault时，内核需要重启进程，此进程运行在一个设计好的不同的栈上，此栈命名为user exception stack。除此之外，我们让JOS实现自动栈切换代表用户环境。

JOS user exception stack的大小也是一个页的大小，其栈顶位于虚拟地址UXSTACKTOP，因此该栈可用的地址从UXSTACKTOP-PGSIZE到UXSTACKTOP-1。当运行在user exception stack上时，用户级页面错误处理程序可以使用JOS的常规系统调用来映射新页面或调整映射，以修复最初导致页面错误的任何问题。然后运行用户级别的处理返回，通过一句汇编语言stub，最后回到原始栈。



### 2.4、Invoking the User Page Fault Handler

我们现在需要修改`kern/trap.c`中的处理page fault的代码。我们将故障发生时的用户环境状态称为陷阱时间状态。

如果没有注册页面错误处理程序，那么JOS内核会像以前一样用一条消息破坏用户环境。否则，内核会在异常堆栈上设置一个陷阱框架，看起来像inc/trap.h中的struct UTrapframe:

```
                    <-- UXSTACKTOP
trap-time esp
trap-time eflags
trap-time eip
trap-time eax       start of struct PushRegs
trap-time ecx
trap-time edx
trap-time ebx
trap-time esp
trap-time ebp
trap-time esi
trap-time edi       end of struct PushRegs
tf_err (error code)
fault_va            <-- %esp when handler is run
```



然后，内核安排用户环境使用运行在异常堆栈上的页面错误处理程序恢复执行;你必须想办法做到这一点。fault_va是导致页面错误的虚拟地址。

如果发生异常时用户环境已经在用户异常堆栈上运行，则页面错误处理程序本身已经发生故障。在这种情况下，您应该在当前tf->tf_esp下面启动新的堆栈帧，而不是在UXSTACKTOP。你应该先推一个空的32位字，然后是一个struct UTrapframe。

要测试tf->tf_esp是否已经在用户异常堆栈中，请检查它是否在UXSTACKTOP-PGSIZE和UXSTACKTOP-1之间(包括UXSTACKTOP-1)。



**Exercise 9.** Implement the code in `page_fault_handler` in `kern/trap.c` required to dispatch page faults to the user-mode handler. Be sure to take appropriate precautions when writing into the exception stack. (What happens if the user environment runs out of space on the exception stack?)



#### page_fault_handler

```C

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
	//
	// The page fault upcall might cause another page fault, in which case
	// we branch to the page fault upcall recursively, pushing another
	// page fault stack frame on top of the user exception stack.
	//
	// It is convenient for our code which returns from a page fault
	// (lib/pfentry.S) to have one word of scratch space at the top of the
	// trap-time stack; it allows us to more easily restore the eip/esp. In
	// the non-recursive case, we don't have to worry about this because
	// the top of the regular user stack is free.  In the recursive case,
	// this means we have to leave an extra word between the current top of
	// the exception stack and the new stack frame because the exception
	// stack _is_ the trap-time stack.
	//
	// If there's no page fault upcall, the environment didn't allocate a
	// page for its exception stack or can't write to it, or the exception
	// stack overflows, then destroy the environment that caused the fault.
	// Note that the grade script assumes you will first check for the page
	// fault upcall and print the "user fault va" message below if there is
	// none.  The remaining three checks can be combined into a single test.
	//
	// Hints:
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').
```



根据代码注释中的提示，我们需要做如下四点工作：

1. 判断esp是否在UXSTACKTOP-PGSIZE` and `UXSTACKTOP-1
2. 判断`curenv->env_pgfault_upcall`是否存在，如果不存在，则销毁当前的进程
3. 修改esp，切换到用户异常栈
4. 在栈中压入`UTrapframe`结构
5. 将eip设置为`curenv->env_pgfault_upcall`，然后回答用户态执行`curenv->env_pgfault_upcall`处的代码



```C
// LAB 4: Your code here.
	if(curenv->env_pgfault_upcall) {
		uintptr_t exstacktop = UXSTACKTOP;
        //第一次使用异常处理栈则栈顶为UXSTACKTOP
        //否则就是tf->tf_esp
		if(tf->tf_esp > UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP - 1){
			exstacktop = tf->tf_esp;
		}
        //exercise 9前面的描述中写着
		//You should first push an empty 32-bit word, then a struct UTrapframe.
		uint32_t stacksize = sizeof(struct UTrapframe) + sizeof(uint32_t);
		//检查进程是否有访问这段内存的权限
		user_mem_assert(curenv, (void*)exstacktop - stacksize, stacksize, PTE_U | PTE_W);
		struct UTrapframe* utf = (struct UTrapframe*)(exstacktop - stacksize);
		utf->utf_eflags = tf->tf_eflags;
    	utf->utf_eip = tf->tf_eip;
    	utf->utf_esp = tf->tf_esp;
    	utf->utf_regs = tf->tf_regs;
    	utf->utf_err = tf->tf_err;
    	utf->utf_fault_va = fault_va;

		//   (the 'tf' variable points at 'curenv->env_tf').
		tf->tf_esp = (uintptr_t)utf;
    	tf->tf_eip = (uint32_t)curenv->env_pgfault_upcall;
		env_run(curenv);
	}
```



其中，UTrapframe定义在`inc/trap.h`中，其具体结构如下：

```C
struct UTrapframe {
	/* information about the fault */
	uint32_t utf_fault_va;	/* va for T_PGFLT, 0 otherwise */
	uint32_t utf_err;
	/* trap-time return state */
	struct PushRegs utf_regs;
	uintptr_t utf_eip;
	uint32_t utf_eflags;
	/* the trap-time stack to return to */
	uintptr_t utf_esp;
} __attribute__((packed));
```



### 2.5、User-mode Page Fault Entrypoint

接下来，我们需要实现汇编程序，该程序负责调用C语言的缺页处理程序以及在原来的错误指令上恢复执行。这段汇编代码将使用sys_env_pgfault_upcall()向内核注册的处理程序。



#### _pgfault_upcall



**Exercise 10.** Implement the `_pgfault_upcall` routine in `lib/pfentry.S`. The interesting part is returning to the original point in the user code that caused the page fault. You'll return directly there, without going back through the kernel. The hard part is simultaneously switching stacks and re-loading the EIP.



```C
// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
	movl 40(%esp), %ebx
	subl $4, %eax
	movl %ebx, (%eax)
	movl %eax, 48(%esp)


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
	popal


	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
	popfl

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
	ret
```



#### set_pgfault_handler

最后，我们需要实现C语言的用户级别的页面缺失故障处理机制



**Exercise 11.** Finish `set_pgfault_handler()` in `lib/pgfault.c`.



```C
// Set the page fault handler function.
// If there isn't one yet, _pgfault_handler will be 0.
// The first time we register a handler, we need to
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
```

我们需要完成第一次注册处理page fault的函数

第一次需要分配一个页作为exeption stack，并且告诉内核发生page fault时调用汇编函数_pgfault_upcall

这部分在练习描述中也有一丢丢提示

**Each user environment that wants to support user-level page fault handling will need to allocate memory for its own exception stack, using the `sys_page_alloc()` system call introduced in part A.**



```C
if (_pgfault_handler == 0) {
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
		}
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}
```



运行结果

`make run-faultread`

![faultread](https://github.com/anhongzhan/MIT6.828/blob/lab4/04Lab4/faultread.PNG)

`make run-faultdie`

![faultdie](https://github.com/anhongzhan/MIT6.828/blob/lab4/04Lab4/faultdie.PNG)

`make run-faultalloc`

![faultalloc](https://github.com/anhongzhan/MIT6.828/blob/lab4/04Lab4/faultalloc.PNG)

`make run-faultallocbad`

![faultallocbad](https://github.com/anhongzhan/MIT6.828/blob/lab4/04Lab4/faultallocbad.PNG)



### 2.6、Implementing Copy-on-Write Fork

现在，我们要在用户空间中实现完整的copy-on-write

`lib/fork.c`中为我们提供了一个fork()的框架。类似dumbfork()，fork()应该创建新的进程，然后扫描父进程的地址空间并且在子进程中设置相应的映射。关键的不同在于，当dumbfork()复制所有的页时，fork()只复制映射的那一页。

fork()的基本控制流程如下：

1. 父进程使用set_pgfault_handler设置号C语言级别的page fault处理函数
2. 父进程调用sys_exofork()函数创建子进程
3. 对于每个writable或者copy-on-write并且在UTOP下面的地址空间，父进程都调用duppage，该调用将copy-on-write页映射到子进程的地址空间，然后再重新映射回自己的地址空间（自己就是指父进程，先把子进程标记为COW，然后标记父进程为COW）。duppage将父子进程的PTE都设置为not writable，并且再可用域添加`PTE_COW`标识。
4. 父进程为子进程设置一个和自己相同的page fault entrypoint
5. 子进程准备好运行了，父进程将其标记为runnable

每次一个进程要像一个未被写过的page中写入内容时，进程都会调用page fault。下面是用户缺页处理控制流程：

1. 内核调用fork()的pgfault向_pgfault_upcall发送缺页
2. pgfault()检查这个fault是否可写(check FEC_WR in the error code)以及页的PTE是否被标记为PTE_COW，如果没有，panic
3. pgfault()分配一个新页并且映射到临时的一块内存上面，然后复制faulting page上的内容到这个页上。然后，故障处理程序将新页面映射到具有读/写权限的适当地址，以取代旧的只读映射



用户级别的`lib/fork.c`代码必须咨询进程的页表中国的几个标记项(例：PTE_COW)。内核将进程页表映射到UVPT也是这个目的。内核用了[一种聪明的映射方法](https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html)让用户代码容易看到PTEs。`lib/entry.S`设置uvpt和uvpd以便于我们可以轻松地看到`lib/fork.c`中的页表信息。



**Exercise 12.** Implement `fork`, `duppage` and `pgfault` in `lib/fork.c`.

Test your code with the `forktree` program. It should produce the following messages, with interspersed 'new env', 'free env', and 'exiting gracefully' messages. The messages may not appear in this order, and the environment IDs may be different.

```
	1000: I am ''
	1001: I am '0'
	2000: I am '00'
	2001: I am '000'
	1002: I am '1'
	3000: I am '11'
	3001: I am '10'
	4000: I am '100'
	1003: I am '01'
	5000: I am '010'
	4001: I am '011'
	2002: I am '110'
	1004: I am '001'
	1005: I am '111'
	1006: I am '101'
```



#### pgfault

```C
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
```

pgfault函数自定义了page fault handler，前提是页是copy-on-write的，将其映射到我们自己私有的可写的copy中（这是什么意思？？？）



```C
static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;

	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
	if (!(
            (uvpd[PDX(addr)] & PTE_P) && 
            (uvpt[PGNUM(addr)] & PTE_P) && 
            (uvpt[PGNUM(addr)] & PTE_U) && 
            (uvpt[PGNUM(addr)] & PTE_COW) && 
            (err & FEC_WR) && 
            1
        )) {
        panic(
            "[0x%08x] user page fault va 0x%08x ip 0x%08x: "
            "[%s, %s, %s]",
            sys_getenvid(),
            utf->utf_fault_va,
            utf->utf_eip,
            err & 4 ? "user" : "kernel",
            err & 2 ? "write" : "read",
            err & 1 ? "protection" : "not-present"
        );
    }

	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	//panic("pgfault not implemented");
	if((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0){
		PANIC;
	}
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	memmove(PFTEMP, addr, PGSIZE);
	// sys_page_map:
	// Copy a page mapping (not the contents of a page!) from one 
	// environment's address space to another, leaving a memory 
	// sharing arrangement in place so that the new and the old 
	// mappings both refer to the same page of physical memory.
	if((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W)) < 0)
		PANIC;
	
	// sys_page_unmap:
	// Unmap a page mapped at a given virtual address 
	// in a given environment.
	if((r = sys_page_umap(0, PFTEMP)) < 0)
		PANIC;
	return ;
}
```





#### duppage

```C
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
```

这个函数的功能就是把pn页从父进程映射到子进程中，并且要把该页标记成COW

```C
static int
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	void *pg;
    pte_t pte;

    pg = (void*)(pn * PGSIZE);
    pte = uvpt[pn];

    assert(pte & PTE_P && pte & PTE_U);
    if (pte & PTE_W || pte & PTE_COW) {
        if (r = sys_page_map(0, pg, envid, pg, PTE_P | PTE_U | PTE_COW), r < 0)
            return r;
        if (r = sys_page_map(0, pg, 0, pg, PTE_P | PTE_U | PTE_COW), r < 0)
            return r;
    } else {
        if (r = sys_page_map(0, pg, envid, pg, PTE_P | PTE_U), r < 0)
            return r;
    }

    return 0;
}
```



#### fork

```C
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
```

该函数主要分为以下几步：

- 创建一个子进程，使用exofork
- 如果返回的是0，则直接运行
- 如果大于0，则在父进程中完成copy操作，使用duppage
- 我们要从UTEXT开始到USTACKTOP位置所有的页进行复制，把属于父进程的页copy给子进程
- 我们还需要分配一个页作为用户进程的异常栈

```C
static int
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	void *pg;
    pte_t pte;

    pg = (void*)(pn * PGSIZE);
    pte = uvpt[pn];

    assert(pte & PTE_P && pte & PTE_U);
    if (pte & PTE_W || pte & PTE_COW) {
        if (r = sys_page_map(0, pg, envid, pg, PTE_P | PTE_U | PTE_COW), r < 0)
            return r;
        if (r = sys_page_map(0, pg, 0, pg, PTE_P | PTE_U | PTE_COW), r < 0)
            return r;
    } else {
        if (r = sys_page_map(0, pg, envid, pg, PTE_P | PTE_U), r < 0)
            return r;
    }

    return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
	// LAB 4: Your code here.
	//panic("fork not implemented");
	int r;
	envid_t ceid;

	set_pgfault_handler(pgfault);

	if((ceid = sys_exofork()) == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
	}else if(ceid > 0){
		for (size_t pn = 0; pn < UTOP / PGSIZE - 1;) {
            uint32_t pde = uvpd[pn / NPDENTRIES];
            if (!(pde & PTE_P)) {
                pn += NPDENTRIES;
            } else {
                size_t next = MIN(UTOP / PGSIZE - 1, pn + NPDENTRIES);
                for (; pn < next; ++pn) {
                    uint32_t pte = uvpt[pn];
                    if (pte & PTE_P && pte & PTE_U)
                        if (r = duppage(ceid, pn), r < 0)
                            panic("fork: duppage error\n");
                }
            }
        }
        if (r = sys_page_alloc(ceid, (void*)(UXSTACKTOP - PGSIZE), 
                                PTE_P | PTE_U | PTE_W), r < 0)
            panic("fork: sys_page_alloc error\n");
        if (r = sys_env_set_pgfault_upcall(ceid, _pgfault_upcall), r < 0)
            panic("fork: sys_env_set_pgfault_upcall error\n");
        if (r = sys_env_set_status(ceid, ENV_RUNNABLE), r < 0)
            panic("fork: sys_env_set_status error\n");
	}

	return ceid;
}
```



由于我们调用了_pgfault_upcall，我们需要在fork.c中添加

```C
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);
```



运行`make grade`，可以得到

```
faultread: OK (1.4s) 
faultwrite: OK (1.4s) 
faultdie: OK (1.2s) 
    (Old jos.out.faultdie failure log removed)
faultregs: OK (1.9s) 
    (Old jos.out.faultregs failure log removed)
faultalloc: OK (1.3s) 
    (Old jos.out.faultalloc failure log removed)
faultallocbad: OK (1.6s) 
    (Old jos.out.faultallocbad failure log removed)
faultnostack: OK (1.3s) 
    (Old jos.out.faultnostack failure log removed)
faultbadhandler: OK (1.8s) 
    (Old jos.out.faultbadhandler failure log removed)
faultevilhandler: OK (1.3s) 
    (Old jos.out.faultevilhandler failure log removed)
forktree: OK (1.8s) 
    (Old jos.out.forktree failure log removed)
Part B score: 50/50

```





## 3、Part C: Preemptive Multitasking and Inter-Process communication (IPC)

最后一部分我们要修改内核抢占不合作的进程并且允许进程之间传输信息

### 3.1、Clock Interrupts and Preemption

运行`user/spin`测试程序，使用`make run-spin`指令，可以得到如下结果：

![spin](F:\MIT6828\note\04Lab4\spin.PNG)

测试程序创建了一个子进程，这个子进程收到CPU的控制权之后就永远都不退出了。父进程和内核都不会重新获得CPU的控制权了。很明显这不是保护系统防止bug以及恶意代码的理想情况，因为任何的用户模式的进程都能让整个系统停止工作。为了让内核能够抢占运行中的进程，强制重新获得CPU的控制权，我们必须要扩展内核以支持来自时钟硬件的硬件中断。



### 3.2、Interrupt discipline

扩展中断(例：设备中断)被成为IRQs。有16中可能的IRQs，从0到15。从IRQ到IDT的映射不是固定的。

`picirq.c`中的`pic_init`函数映射IRQs的0-15到IDT entries 的IRQ_OFFSET到IRQ_OFFSET+15，即32-47号

例：时钟中断是IRQ0，IDT[IRQ_OFFSET + 0]存储内核中国时钟中断处理函数的地址

使用IRQ_OFFSET可以防止与处理器异常重合。



在JOS中，我们对照xv6做了一些简化。在内核中扩展的设备中断永远不可见。扩展中断被%eflags寄存器中的FL_IF位控制。当该位被设置时，扩展中断是可用的。因为我们的简化，该位可以被多种方式修改，我们将仅通过在进入和离开用户模式时保存和恢复%eflags寄存器的过程来处理它。



我们必须保证FL_IF位在用户进程中被设置，以便于当中断到达时，他能通过处理器被我们的中断代码处理。否则，中断不可见或者被忽略，知道中断重新可用。我们遮住中断使其不可见的代码在bootloader的非常靠前的位置，到目前位置我们从未重新启用他们。



**Exercise 13.** Modify `kern/trapentry.S` and `kern/trap.c` to initialize the appropriate entries in the IDT and provide handlers for IRQs 0 through 15. Then modify the code in `env_alloc()` in `kern/env.c` to ensure that user environments are always run with interrupts enabled.

Also uncomment the `sti` instruction in `sched_halt()` so that idle CPUs unmask interrupts.

The processor never pushes an error code when invoking a hardware interrupt handler. You might want to re-read section 9.2 of the [80386 Reference Manual](https://pdos.csail.mit.edu/6.828/2018/readings/i386/toc.htm), or section 5.8 of the [IA-32 Intel Architecture Software Developer's Manual, Volume 3](https://pdos.csail.mit.edu/6.828/2018/readings/ia32/IA32-3A.pdf), at this time.

After doing this exercise, if you run your kernel with any test program that runs for a non-trivial length of time (e.g., `spin`), you should see the kernel print trap frames for hardware interrupts. While interrupts are now enabled in the processor, JOS isn't yet handling them, so you should see it misattribute each interrupt to the currently running user environment and destroy it. Eventually it should run out of environments to destroy and drop into the monitor.



实验要求我们添加新增的十五个硬件中断的处理程序，并且要在用户模式中能够处理这些中断(设置FL_IF位)



#### trapentry.S

```
TRAPHANDLER_NOEC(irq_0_handler, IRQ_OFFSET + 0);
TRAPHANDLER_NOEC(irq_1_handler, IRQ_OFFSET + 1);
TRAPHANDLER_NOEC(irq_2_handler, IRQ_OFFSET + 2);
TRAPHANDLER_NOEC(irq_3_handler, IRQ_OFFSET + 3);
TRAPHANDLER_NOEC(irq_4_handler, IRQ_OFFSET + 4);
TRAPHANDLER_NOEC(irq_5_handler, IRQ_OFFSET + 5);
TRAPHANDLER_NOEC(irq_6_handler, IRQ_OFFSET + 6);
TRAPHANDLER_NOEC(irq_7_handler, IRQ_OFFSET + 7);
TRAPHANDLER_NOEC(irq_8_handler, IRQ_OFFSET + 8);
TRAPHANDLER_NOEC(irq_9_handler, IRQ_OFFSET + 9);
TRAPHANDLER_NOEC(irq_10_handler, IRQ_OFFSET + 10);
TRAPHANDLER_NOEC(irq_11_handler, IRQ_OFFSET + 11);
TRAPHANDLER_NOEC(irq_12_handler, IRQ_OFFSET + 12);
TRAPHANDLER_NOEC(irq_13_handler, IRQ_OFFSET + 13);
TRAPHANDLER_NOEC(irq_14_handler, IRQ_OFFSET + 14);
TRAPHANDLER_NOEC(irq_15_handler, IRQ_OFFSET + 15);
```



#### trap.c

```C
void irq_0_handler();
void irq_1_handler();
void irq_2_handler();
void irq_3_handler();
void irq_4_handler();
void irq_5_handler();
void irq_6_handler();
void irq_7_handler();
void irq_8_handler();
void irq_9_handler();
void irq_10_handler();
void irq_11_handler();
void irq_12_handler();
void irq_13_handler();
void irq_14_handler();
void irq_15_handler();
```



```C
	SETGATE(idt[IRQ_OFFSET + 0], 0, GD_KT, irq_0_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 1], 0, GD_KT, irq_1_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 2], 0, GD_KT, irq_2_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 3], 0, GD_KT, irq_3_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 4], 0, GD_KT, irq_4_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 5], 0, GD_KT, irq_5_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 6], 0, GD_KT, irq_6_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 7], 0, GD_KT, irq_7_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 8], 0, GD_KT, irq_8_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 9], 0, GD_KT, irq_9_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 10], 0, GD_KT, irq_10_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 11], 0, GD_KT, irq_11_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 12], 0, GD_KT, irq_12_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 13], 0, GD_KT, irq_13_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 14], 0, GD_KT, irq_14_handler, 0);
	SETGATE(idt[IRQ_OFFSET + 15], 0, GD_KT, irq_15_handler, 0);
```



#### env_alloc

```C
	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
	e->env_tf.tf_eflags |= FL_IF;
```



### 3.3、Handling Clock Interrupts

在`user/spin`程序中，子进程第一次运行之后，就会陷入一个循环，内核永远不会重新获得其控制权。我们需要对硬件编程实现定期的时钟中断，这会使得内核重新获取不同用户进程的控制权。

调用lapic_init和pic_init设置了时钟和中断控制器去生成中断。我们需要写代码处理这些中断



#### sched_yield



**Exercise 14.** Modify the kernel's `trap_dispatch()` function so that it calls `sched_yield()` to find and run a different environment whenever a clock interrupt takes place.

You should now be able to get the `user/spin` test to work: the parent environment should fork off the child, `sys_yield()` to it a couple times but in each case regain control of the CPU after one time slice, and finally kill the child environment and terminate gracefully.

IRQ_TIMER定义在`inc/trap.h`中，其值为0。练习中要求使用sched_yield()函数，代码提示中写着先使用lapic_eoi()函数。

```C
	// Handle clock interrupts. Don't forget to acknowledge the
	// interrupt using lapic_eoi() before calling the scheduler!
	// LAB 4: Your code here.
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
		lapic_eoi();
		sched_yield();
		return ;
	}
```



最后，取消`sched_halt()`函数中的注释`sti`，如下所示：

```C
asm volatile (
		"movl $0, %%ebp\n"
		"movl %0, %%esp\n"
		"pushl $0\n"
		"pushl $0\n"
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
```



使用make grade，不取消注释只有60分，取消之后才有65分



### 3.4、Inter-Process communication (IPC)

在JOS中应该叫做Inter-environment communication或者IEC，但是大家都叫IPC，所以下面就用IPC代替

我们一直关注操作系统的隔离方面，这提供了一种错觉：每个程序都有自己的机器。操作系统的另一个服务是程序之间可以进行通信。让程序与其他程序交互是非常强大的。Unix管道模型就是一个典型的例子。

目前有许多进程间通信模型。即使在今天，人们仍在争论哪种模式是最好的。我们指挥实现一个简单的IPC机制，然后进行实验。



### 3.5、IPC in JOS

我们要实现一些额外的JOS内核系统调用，他们共同提供了一个简单的进程间通信机制。我们要实现两个系统调用：sys_ipc_recv以及sys_ipc_try_send。然后需要实现两个库包装器`ipc_recv` and `ipc_send`.

JOS IPC机制中用户进程之间可以传输的信息包含两个部分：一个单独的32位数据和一个可选的页面映射。允许进程在消息中传递页面映射这项功能，提供了一种有效的方式传输比32位整数更大的数据，还允许京城轻松地设置共享内存。



### 3.6、Sending and Receiving Messages

为了接收尽心，进程需要调用sys_ipc_recv。该系统调用撤销运行当前的进程并且在接收信息后才再次运行。当一个进程等待接收信息，**任何其他的进程都可以发送信息**，并不是某个特定的进程，也不是只有具有父子关系的进程之间才有信息传递功能。

为了发送信息，进程调用sys_ipc_try_send，带有两个参数：接收者的envid以及要发送的信息。如果目标进程接出于receiving状态)(调用了sys_ipc_recv但是还没有接收到数据)，然后发送者就会传递信息并且返回0。否则发送者返回 `-E_IPC_NOT_RECV`表示目标进程不希望接收数据。

用户空间中的库函数ipc_recv负责调用sys_ipc_recv，然后在当前进程的结构体Env中查找接收到的值的信息。

类似地，ipc_send负责调用sys_ipc_try_send直到发送成功。



### 3.7、Transferring Pages

当进程调用sys_ipc_recv并且带有一个参数dstva(below UTOP)，意味着进程想要接受一个page映射。如果发送者发送了一个page，该page会映射到dstva，如果已经有一个page映射到dstva上，那就解绑该页，然后和我们传输的page映射（这里很明显用page_insert）

当进程调用sys_ipc_try_send并且带有一个参数srcva(below UTOP)，意味着发送者想要发送一个page给接收者，该page映射在srcva上，并且带着权限perm。一次成功的IPC之后，发送者保持原有的page映射，即映射到srcva上，接收者收到的page则映射到dstva上。结果就是该页变成了两个进程共享的了。

任何IPC之后，内核将接收者的Env结构中的新字段env_ipc_perm设置为接收到页面的权限，如果没有接收到页面，则设置为零。



### 3.8、Implementing IPC



**Exercise 15.** Implement `sys_ipc_recv` and `sys_ipc_try_send` in `kern/syscall.c`. Read the comments on both before implementing them, since they have to work together. When you call `envid2env` in these routines, you should set the `checkperm` flag to 0, meaning that any environment is allowed to send IPC messages to any other environment, and the kernel does no special permission checking other than verifying that the target envid is valid.

Then implement the `ipc_recv` and `ipc_send` functions in `lib/ipc.c`.

Use the `user/pingpong` and `user/primes` functions to test your IPC mechanism. `user/primes` will generate for each prime number a new environment until JOS runs out of environments. You might find it interesting to read `user/primes.c` to see all the forking and IPC going on behind the scenes.



练习要求我们先实现 `sys_ipc_recv` and `sys_ipc_try_send` ，然后是 `ipc_recv` and `ipc_send`，并且对实现细节做了一些补充



#### sys_ipc_recv

```C
// Block until a value is ready.  Record that you want to receive
// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// mark yourself not runnable, and then give up the CPU.
//
// If 'dstva' is < UTOP, then you are willing to receive a page of data.
// 'dstva' is the virtual address at which the sent page should be mapped.
//
// This function only returns on error, but the system call will eventually
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
	//panic("sys_ipc_recv not implemented");

	//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
	if((uintptr_t)dstva < UTOP || (uintptr_t)dstva & (PGSIZE - 1)){
		return -E_INVAL;
	}

	struct Env* cur_env;
	envid2env(0, &cur_env, 0);
	assert(cur_env);

	// Block until a value is ready.  Record that you want to receive
	// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
	// mark yourself not runnable, and then give up the CPU.
	cur_env->env_ipc_recving = 1;
	cur_env->env_ipc_dstva = dstva;
	cur_env->env_status = ENV_NOT_RUNNABLE;

	sched_yield();

	// This function only returns on error, but the system call will eventually
	// return 0 on success.
	//return 0;
}
```



#### sys_ipc_try_send

```C
// Try to send 'value' to the target env 'envid'.
// If srcva < UTOP, then also send page currently mapped at 'srcva',
// so that receiver gets a duplicate mapping of the same page.
//
// The send fails with a return value of -E_IPC_NOT_RECV if the
// target is not blocked, waiting for an IPC.
//
// The send also can fail for the other reasons listed below.
//
// Otherwise, the send succeeds, and the target's ipc fields are
// updated as follows:
//    env_ipc_recving is set to 0 to block future sends;
//    env_ipc_from is set to the sending envid;
//    env_ipc_value is set to the 'value' parameter;
//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// The target environment is marked runnable again, returning 0
// from the paused sys_ipc_recv system call.  (Hint: does the
// sys_ipc_recv function ever actually return?)
//
// If the sender wants to send a page but the receiver isn't asking for one,
// then no page mapping is transferred, but no error occurs.
// The ipc only happens when no errors occur.
//
// Returns 0 on success, < 0 on error.
// Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist.
//		(No need to check permissions.)
//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
//		or another environment managed to send first.
//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
//	-E_INVAL if srcva < UTOP and perm is inappropriate
//		(see sys_page_alloc).
//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
//		address space.
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
	// LAB 4: Your code here.
	//panic("sys_ipc_try_send not implemented");
	struct Env *rec_env, *cur_env;
	int r;
	int flag = PTE_U | PTE_P;
	struct PageInfo* pg;
	pte_t* pte;

	//get current env
	envid2env(0, &cur_env, 0);

	//	-E_BAD_ENV if environment envid doesn't currently exist.
	//  envid2env return -E_BAD_ENV
	//  所以我们直接返回r即可
	if((r = envid2env(envid, &rec_env, 0)) < 0){
		return r;
	}

	//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
	//	or another environment managed to send first.
	// env_ipc_recving 表示 Env is blocked receiving
	if(!rec_env->env_ipc_recving){
		return -E_IPC_NOT_RECV;
	}

	// After any IPC the kernel sets the new field env_ipc_perm 
	// in the receiver's Env structure to the permissions of the page received, 
	// or zero if no page was received.
	if(rec_env->env_ipc_from){
		return -E_IPC_NOT_RECV;
	}

	if((uintptr_t)srcva >= UTOP){
		perm = 0;
	}

	//	-E_INVAL if srcva < UTOP
	if(perm){
		//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
		if((uintptr_t)srcva & (PGSIZE - 1)){
			return -E_INVAL;
		}

		//	-E_INVAL if srcva < UTOP and perm is inappropriate
		//		(see sys_page_alloc).
		if(((perm & flag) != flag) || (perm & ~PTE_SYSCALL) != 0){
			return -E_INVAL;
		}

		//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
		//		address space.
		if(!(pg = page_lookup(cur_env->env_pgdir, srcva, &pte))){
			return -E_INVAL;
		}	

		//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
		//		current environment's address space.
		if((perm & PTE_W) && !((*pte) & PTE_W)){
			return -E_INVAL;
		}

		//	-E_NO_MEM if there's not enough memory to map srcva in envid's
		//		address space.
		//  page_insert失败后返回-E_NO_MEM
		if((uintptr_t)rec_env->env_ipc_dstva < UTOP){
			if((r = page_insert(rec_env->env_pgdir, pg, rec_env->env_ipc_dstva, perm)) < 0){
				return r;
			}
		}
	}

	// Otherwise, the send succeeds, and the target's ipc fields are
	// updated as follows:
	//    env_ipc_recving is set to 0 to block future sends;
	//    env_ipc_from is set to the sending envid;
	//    env_ipc_value is set to the 'value' parameter;
	//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
	rec_env->env_ipc_recving = 0;
	rec_env->env_ipc_from = cur_env->env_id;
	rec_env->env_ipc_value = value;
	rec_env->env_ipc_perm = perm;

	// The target environment is marked runnable again
	rec_env->env_status = runnable;

	// returning 0 from the paused sys_ipc_recv system call. 
	rec_env->env_tf.reg_eax = 0;

	return 0;
}
```



#### ipc_recv

判断pg不等于NULL是if(pg)，我写成了if(!pg)，然后pgfault一直告诉我page不是copy-on-write的，debug了好久

```C
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;

	// If 'pg' is nonnull, then any page sent by the sender will be mapped at
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
		r = sys_ipc_recv(pg);
	}else{
		// 注释提示我们pg = null 时传入一个sys_ipc_recv能够识别出来的
		// 表示 no page的值
		// recv里面要求地址低于UTOP，所以我们传入UTOP即可
		r = sys_ipc_recv((void*)UTOP);
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
		*from_env_store = thisenv->env_ipc_from;
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
		*perm_store = thisenv->env_ipc_perm;
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
}

```



#### ipc_send

```C
// Send 'val' (and 'pg' with 'perm', if 'pg' is nonnull) to 'toenv'.
// This function keeps trying until it succeeds.
// It should panic() on any error other than -E_IPC_NOT_RECV.
//
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
		if(r != -E_IPC_NOT_RECV){
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
	}
}
```



运行`make grade`，可以得到如下运行结果：

![makegrade](https://github.com/anhongzhan/MIT6.828/blob/lab4/04Lab4/makegrade.PNG)
