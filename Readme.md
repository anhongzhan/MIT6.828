# Lab 3: User Environments

运行`git checkout -b lab3 origin/lab3`，切换到lab3的目录中

**随着学习进度的深入，对于不同内容的翻译可能会有所不同，本节中对于Environment e的翻译有时是环境e，有时是进程e，望见谅**

## 1、Part A: User Environments and Exception Handling

文件`kern/env.c`中包含我们需要使用的三个全局变量

```C
struct Env *envs = NULL;		// All environments
struct Env *curenv = NULL;		// The current env
static struct Env *env_free_list;	// Free environment list
```

### 1.1、Environment State

文件`inc/env.h`中JOS的用户环境(user environment)的基本定义

`envid_t`是一个用户环境的id

```c
typedef int32_t envid_t;

// An environment ID 'envid_t' has three parts:
//
// +1+---------------21-----------------+--------10--------+
// |0|          Uniqueifier             |   Environment    |
// | |                                  |      Index       |
// +------------------------------------+------------------+
//                                       \--- ENVX(eid) --/
//
// The environment index ENVX(eid) equals the environment's index in the
// 'envs[]' array.  The uniqueifier distinguishes environments that were
// created at different times, but share the same environment index.
//
// All real environments are greater than 0 (so the sign bit is zero).
// envid_ts less than 0 signify errors.  The envid_t == 0 is special, and
// stands for the current environment.
```



Env记录着一个用户环境的所有信息，在用户环境发生切换时，该环境对应的Env会记录着其对应的信息，以便下次切换回来时恢复执行环境

```C
struct Env {
	struct Trapframe env_tf;	// Saved registers
	struct Env *env_link;		// Next free Env
	envid_t env_id;			// Unique environment identifier
	envid_t env_parent_id;		// env_id of this env's parent
	enum EnvType env_type;		// Indicates special system environments
	unsigned env_status;		// Status of the environment
	uint32_t env_runs;		// Number of times environment has run

	// Address space
	pde_t *env_pgdir;		// Kernel virtual address of page dir
};
```



接下来解释Env中的每一项

`Trapframe`定义在`inc/trap.h`中，该数据结构记录着环境不运行时的寄存器的值，方便切换环境以及环境恢复

```C
struct Trapframe {
	struct PushRegs tf_regs;
	uint16_t tf_es;
	uint16_t tf_padding1;
	uint16_t tf_ds;
	uint16_t tf_padding2;
	uint32_t tf_trapno;
	/* below here defined by x86 hardware */
	uint32_t tf_err;
	uintptr_t tf_eip;
	uint16_t tf_cs;
	uint16_t tf_padding3;
	uint32_t tf_eflags;
	/* below here only when crossing rings, such as from user to kernel */
	uintptr_t tf_esp;
	uint16_t tf_ss;
	uint16_t tf_padding4;
} __attribute__((packed));
```



`env_link`指向`env_free_list`中的下一个`Env`，`env_free_list`指向第一个空闲环境

`end_id`用于标识区分用户环境，即使有两个或者多个环境使用相同的Env数据，他们的env_id也是不同的

`env_parent_id`存储着创建该环境的环境的env_id（The kernel stores here the `env_id` of the environment that created this environment. ）

`env_type`，枚举类型

```C
enum EnvType {
	ENV_TYPE_USER = 0,
};
```

用于标识特别的环境，后续的实验应该会涉及

`env_status`，枚举类型，标识环境状态

```C
// Values of env_status in struct Env
enum {
	ENV_FREE = 0,
	ENV_DYING,
	ENV_RUNNABLE,
	ENV_RUNNING,
	ENV_NOT_RUNNABLE
};
```



This variable holds one of the following values:

- `ENV_FREE`:

  Indicates that the `Env` structure is inactive, and therefore on the `env_free_list`.

- `ENV_RUNNABLE`:

  Indicates that the `Env` structure represents an environment that is waiting to run on the processor.

- `ENV_RUNNING`:

  Indicates that the `Env` structure represents the currently running environment.

- `ENV_NOT_RUNNABLE`:

  Indicates that the `Env` structure represents a currently active environment, but it is not currently ready to run: for example, because it is waiting for an interprocess communication (IPC) from another environment.

- `ENV_DYING`:

  Indicates that the `Env` structure represents a zombie environment. A zombie environment will be freed the next time it traps to the kernel. We will not use this flag until Lab 4.



`env_pgdir`，保存内核给这个环境分配的页目录(page directory)



### 1.2、Allocating the Environments Array

lab2中，我们分配了一个pages数组，用于内核追踪哪个页可用，哪个页占用。



**Exercise 1.** Modify `mem_init()` in `kern/pmap.c` to allocate and map the `envs` array. This array consists of exactly `NENV` instances of the `Env` structure allocated much like how you allocated the `pages` array. Also like the `pages` array, the memory backing `envs` should also be mapped user read-only at `UENVS` (defined in `inc/memlayout.h`) so user processes can read from this array.

You should run your code and make sure `check_kern_pgdir()` succeeds.



仿照前面lab2的写法，其中envs定义在`kern/env.h`

```C
	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
	// envs定义在kern/env.h
	envs = (struct Env*)boot_alloc(sizeof(struct Env) * NENV);
	memset(envs, 0, sizeof(struct Env) * NENV);

	//////////////////////////////////////////////////////////////////////
	// Map the 'envs' array read-only by the user at linear address UENVS
	// (ie. perm = PTE_U | PTE_P).
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
```



### 1.3、Creating and Running Environments

接下来需要完成`kern/env.c`中的内容去运行一个用户环境，由于我们没有文件系统，我们会设置成内核加载嵌入内核本身的静态二进制镜像



**Exercise 2.** In the file `env.c`, finish coding the following functions:

- `env_init()`

  Initialize all of the `Env` structures in the `envs` array and add them to the `env_free_list`. Also calls `env_init_percpu`, which configures the segmentation hardware with separate segments for privilege level 0 (kernel) and privilege level 3 (user).

- `env_setup_vm()`

  Allocate a page directory for a new environment and initialize the kernel portion of the new environment's address space.

- `region_alloc()`

  Allocates and maps physical memory for an environment

- `load_icode()`

  You will need to parse an ELF binary image, much like the boot loader already does, and load its contents into the user address space of a new environment.

- `env_create()`

  Allocate an environment with `env_alloc` and call `load_icode` to load an ELF binary into it.

- `env_run()`

  Start a given environment running in user mode.

As you write these functions, you might find the new cprintf verb `%e` useful -- it prints a description corresponding to an error code. For example,

```
	r = -E_NO_MEM;
	panic("env_alloc: %e", r);
```

will panic with the message "env_alloc: out of memory".



#### void env_init(void`

```C
// Mark all environments in 'envs' as free, set their env_ids to 0,
// and insert them into the env_free_list.
// Make sure the environments are in the free list in the same order
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
```

该函数要求把所有的Env数据结构置为free(env_id = 0)，然后插入到env_free_list

另外需要确保env_alloc()时分配的是envs[0]，意思是envs[0]是env_free_list的第一项

此处可以参考lab2 pmap.c中配置page_free_list时的写法，插入可以采用头插法，同时注意顺序

```C
void
env_init(void)
{
	// Set up envs array
	// LAB 3: Your code here.
	size_t i;
	env_free_list = NULL;
	for(i = NENV - 1; i >= 0; i--){
		envs[i].env_id = 0;
        envs[i].env_status = ENV_FREE;
		envs[i].env_link = env_free_list;
		env_free_list = &envs[i];
	}

	// Per-CPU part of the initialization
	env_init_percpu();
}
```



#### static int env_setup_vm(struct Env *e)

```C
//
// Initialize the kernel virtual memory layout for environment e.
// Allocate a page directory, set e->env_pgdir accordingly,
// and initialize the kernel portion of the new environment's address space.
// Do NOT (yet) map anything into the user portion
// of the environment's virtual address space.
//
// Returns 0 on success, < 0 on error.  Errors include:
//	-E_NO_MEM if page directory or table could not be allocated.
//
```

该函数要求为environment e创建页目录，将其设置为e->env_pgdir，并且初始化新环境地址空间的内核部分

```C
static int
env_setup_vm(struct Env *e)
{
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
		return -E_NO_MEM;

	// Now, set e->env_pgdir and initialize the page directory.
	//
	// Hint:
	//    - The VA space of all envs is identical above UTOP
	//	(except at UVPT, which we've set below).
	//	See inc/memlayout.h for permissions and layout.
	//	Can you use kern_pgdir as a template?  Hint: Yes.
	//	(Make sure you got the permissions right in Lab 2.)
	//    - The initial VA below UTOP is empty.
	//    - You do not need to make any more calls to page_alloc.
	//    - Note: In general, pp_ref is not maintained for
	//	physical pages mapped only above UTOP, but env_pgdir
	//	is an exception -- you need to increment env_pgdir's
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.
	p->pp_ref++;
	e->env_pgdir = (pde_t *)page2kva(p);
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);

	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;

	return 0;
}
```

根据提示，我们首先要将p->pp_ref加一，然后将申请下来的一个page的内存设置为environment e的页目录，

最后提示中问environment e的页目录可以以kern_pgdir为模板吗？并且得到答案：是

所以使用memcpy即可



#### static void region_alloc(struct Env *e, void *va, size_t len)

```C
//
// Allocate len bytes of physical memory for environment env,
// and map it at virtual address va in the environment's address space.
// Does not zero or otherwise initialize the mapped pages in any way.
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
```

为environment分配len字节的物理地址，并且将其映射到environment的虚拟内存中

不要对物理页做任何的初始化

```C
static void
region_alloc(struct Env *e, void *va, size_t len)
{
	// LAB 3: Your code here.
	// (But only if you need it for load_icode.)
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	// ROUNDDOWN/ROUNDUP在inc/types.h中
	void* begin = ROUNDDOWN(va, PGSIZE);
	void* end = ROUNDUP(va + len);
	while(begin < end){
		struct PageInfo* pp = page_alloc(0);
		if(!pp){
			panic("region_alloc failed\n");
		}
		page_insert(e->env_pgdir, pp, begin, PTE_W | PTE_U);
		begin += PGSIZE;
	}
}
```

根据提示，重新规划虚拟地址和len的大小，然后使用page_insert函数进行插入即可

思考：此处为什么不使用boot_map_region？

最开始我的想法是使用boot_map_region将虚拟地址和物理地址一一对应，但发现所有人都是用page_insert实现的，考虑了一下发现使用boot_ap_region需要知道物理地址的所有部分，此时我们是不知道物理地址的，想要获取物理地址的范围还需要花很多的力气，甚至物理地址很有可能是不连续的，所以使用page_insert实现。



#### static void load_icode(struct Env *e, uint8_t *binary)

```C
//
// Set up the initial program binary, stack, and processor flags
// for a user process.
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
//
// This function loads all loadable segments from the ELF binary image
// into the environment's user memory, starting at the appropriate
// virtual addresses indicated in the ELF program header.
// At the same time it clears to zero any portions of these segments
// that are marked in the program header as being mapped
// but not actually present in the ELF file - i.e., the program's bss section.
//
// All this is very similar to what our boot loader does, except the boot
// loader also needs to read the code from disk.  Take a look at
// boot/main.c to get ideas.
//
// Finally, this function maps one page for the program's initial stack.
//
// load_icode panics if it encounters problems.
//  - How might load_icode fail?  What might be wrong with the given input?
//
```

根据注释中的内容我们发现该函数目的是加载一个ELF文件，那么就需要弄清楚ELF到底是什么

Lab1中对ELF给出了描述，[参考资料](https://pdos.csail.mit.edu/6.828/2018/readings/elf.pdf)

```
To make sense out of boot/main.c you'll need to know what an ELF binary is. When you compile and link a C program such as the JOS kernel, the compiler transforms each C source ('.c') file into an object ('.o') file containing assembly language instructions encoded in the binary format expected by the hardware. The linker then combines all of the compiled object files into a single binary image such as obj/kern/kernel, which in this case is a binary in the ELF format, which stands for "Executable and Linkable Format".

Full information about this format is available in the ELF specification on our reference page, but you will not need to delve very deeply into the details of this format in this class. Although as a whole the format is quite powerful and complex, most of the complex parts are for supporting dynamic loading of shared libraries, which we will not do in this class. The Wikipedia page has a short description.
```

简单来说，ELF的格式如下：

| ELF Header | ELF头                                                     |
| ---------- | --------------------------------------------------------- |
| .text      | 已编译程序机器代码                                        |
| .rodata    | 只读数据                                                  |
| .data      | 已初始化的全局和静态C变量                                 |
| .bss       | 未初始化的全局和静态C变量，以及初始化为0的全局和静态C变量 |
| .symtab    |                                                           |
| .rel .text |                                                           |
| .rel .data |                                                           |
| .debug     |                                                           |
| .line      |                                                           |
| 节头部表   |                                                           |

ELF头部首先包含16字节的序列开始，这个序列描述了生成该文件的系统的字的大小和字节顺序

剩下的部分包含帮助链接器语法分析和解释目标文件的信息

在`inc/elf.h`中有这样一个数据结构

```C
struct Elf {
	uint32_t e_magic;	// must equal ELF_MAGIC   
	uint8_t e_elf[12];	// 与e_magic一起共16字节
	uint16_t e_type;	//
	uint16_t e_machine; //
	uint32_t e_version;	//
	uint32_t e_entry;	//ELF程序入口虚拟地址
	uint32_t e_phoff;	//start of program headers
	uint32_t e_shoff;	//start of section headers
	uint32_t e_flags;	//特定处理器格式标志
	uint16_t e_ehsize;	//size of this header
	uint16_t e_phentsize;//size of program header
	uint16_t e_phnum;	//number of program header
	uint16_t e_shentsize;//size of section header
	uint16_t e_shnum;	//number of section header
	uint16_t e_shstrndx;//字符串节所在节表中的下标，字符串节是一个section，这个section肯定在section table
    					//此处描述section在table中的下标
};
```

虽然命名为ELF，但实际上描述的是ELF Header的内容

ELF头部以下的每个区域都叫做Section(节)，比如.text   .bss都是一个Section(节)

每个Section中都存储着不同性质的数据



那么有的同学可能就有疑问了？我们之前说的不都是段(segment)吗？怎么突然就变成节(Section)了呢？

起始我也有这个疑问，直到看到了这张图，来自前面那个介绍ELF的[链接](https://pdos.csail.mit.edu/6.828/2018/readings/elf.pdf)第15页Figure 1-1

![ELF](03Lab3\ELF.PNG)

内存就那么大一块，怎么执行都那么多

段(segment)是从装载(从磁盘加载到内存中)的角度划分内存，每个段的内部都是连续的，段之间的划分是按照执行权限来的，比如数据段、代码段等等

节(Section)是从链接角度来划分内存的，每个节中的数据性质都是相同的，比如.data段中的数据都是已初始化的全局和静态C变量，他们因为性质相同而分配在相同的section中。从上图中可以看出，一个segment可能包含多个section（不知道存不存在相反的情况）。

综上，其实我也没有完全理解，不过解决目前的问题应该是够用了



另外，program header结构如下，后面用得到

```C
struct Proghdr {
	uint32_t p_type;	//segment类型，如ELF_PROG_LOAD
	uint32_t p_offset;	//segment在elf中的便宜
	uint32_t p_va;		//segment的虚拟地址
	uint32_t p_pa;		//segment的物理地址
	uint32_t p_filesz;	//segment在elf中所占空间
	uint32_t p_memsz;	//segment在虚拟地址中所占长度
	uint32_t p_flags;	//segemnt的权限属性
	uint32_t p_align;	//segment的对齐属性
};
```



再次回到代码注释

```C
// This function loads all loadable segments from the ELF binary image
// into the environment's user memory, starting at the appropriate
// virtual addresses indicated in the ELF program header.
// At the same time it clears to zero any portions of these segments
// that are marked in the program header as being mapped
// but not actually present in the ELF file - i.e., the program's bss section.
```

该函数要求将所有可加载的段都加入到用户环境的内存中，ELF header中肯定存储着段的地址，与e->env_pgdir的页目录中记录的内存一一对应起来即可

大致的工作就是为每个段都分配物理页，然后将虚拟地址和物理地址的对应关系记录到e->env_pgdir中即可

```C
static void
load_icode(struct Env *e, uint8_t *binary)
{
	// Hints:
	//  Load each program segment into virtual memory
	//  at the address specified in the ELF segment header.
	//  You should only load segments with ph->p_type == ELF_PROG_LOAD.
	//  Each segment's virtual address can be found in ph->p_va
	//  and its size in memory can be found in ph->p_memsz.
	//  The ph->p_filesz bytes from the ELF binary, starting at
	//  'binary + ph->p_offset', should be copied to virtual address
	//  ph->p_va.  Any remaining memory bytes should be cleared to zero.
	//  (The ELF header should have ph->p_filesz <= ph->p_memsz.)
	//  Use functions from the previous lab to allocate and map pages.
	//
	//  All page protection bits should be user read/write for now.
	//  ELF segments are not necessarily page-aligned, but you can
	//  assume for this function that no two segments will touch
	//  the same virtual page.
	//
	//  You may find a function like region_alloc useful.
	//
	//  Loading the segments is much simpler if you can move data
	//  directly into the virtual addresses stored in the ELF binary.
	//  So which page directory should be in force during
	//  this function?
	//
	//  You must also do something with the program's entry point,
	//  to make sure that the environment starts executing there.
	//  What?  (See env_run() and env_pop_tf() below.)

	// LAB 3: Your code here.
	struct Elf* header = (struct Elf*)binary;
	if(header->e_magic != ELF_MAGIC)
		panic("load_icode failed: the binary is not elf\n");
	if(header->e_entry == 0)
		panic("load_icode failed: the elf can't be executed\n");

	//inc/elf.h
	//struct Proghdr -> program header
	//这个数据结构记录着ELF中所有的段，找到ELF中的program header
	//然后根据提示中的要求就知道哪些段可以映射到虚拟内存上去了
	//head->e_phoff表示Proghdr所在的位置
	struct Proghdr* ph = (struct Proghdr*)((uint8_t*)header + head->e_phoff);
	//header->e_phnum表示segment的数量
	uint16_t phnum = header->e_phnum;

	//不看其他人的代码我是真的想不到
	//此时是内核初始化用户进程，为内核页目录，加载进程e的页目录从而实现地址映射
	//cr3寄存器主要功能是用来存放页目录表物理内存基地址
	//每当进程切换时，Linux就会把下一个将要运行进程的页目录表物理内存基地址等信息存放到CR3寄存器中
	//简单来说就是我们知道进程e的页目录，但是系统现在还不知道
	//要用lcr3函数来让系统知道知道才行
	//可以参考pmap.c   mem_init()
	lcr3(PADDR(e->env_pgdir));

	//页目录知道了，要进行映射的段也知道了
	//接下来就差给他们分配内存了
	uint16_t i;
	for(i = 0; i < phnum; i++){
		//  You should only load segments with ph->p_type == ELF_PROG_LOAD.
		if(ph[i].p_type == ELF_PROG_LOAD){
			// (The ELF header should have ph->p_filesz <= ph->p_memsz.)
			if(ph[i].p_memsz < ph[i].p_filesz){
				panic("load_icode failed: p_memsz < p_filesz.\n");
			}
			//为每个segment分配物理页
			region_alloc(e, (void*)ph[i].p_va, ph[i].p_memsz);
			// Any remaining memory bytes should be cleared to zero.
			memset((void*)ph[i].p_va, 0, ph[i].p_memsz);
			//  The ph->p_filesz bytes from the ELF binary, starting at
			//  'binary + ph->p_offset', should be copied to virtual address
			//  ph->p_va.  Any remaining memory bytes should be cleared to zero.
			//  由于不能保留原始数据，所以需要线将内存清零，然后再复制
			memcpy((void*)ph[i].p_va, binary + ph[i].p_offset, ph[i].p_filesz);
		}

	}

	//重新回到内核态
	lcr3(PADDR(kern_pgdir));

	//  You must also do something with the program's entry point,
	//  to make sure that the environment starts executing there.
	//  What?  (See env_run() and env_pop_tf() below.)
	//	进程e起始指令地址就是header的入口
	//  这部分也是不看其他人的代码就不知道要写什么
	e->env_tf.tf_eip = header->e_entry;


	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.

	// LAB 3: Your code here.
	region_alloc(e, (void*)(USTACKTOP - PGSIZE), PGSIZE);
}

```



#### void env_create(uint8_t *binary, enum EnvType type)

```C
// Allocates a new env with env_alloc, loads the named elf
// binary into it with load_icode, and sets its env_type.
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
```

使用env_alloc分配一个新的env，然后使用load_icode加载elf文件，并且设置他的env_type

```C
void
env_create(uint8_t *binary, enum EnvType type)
{
	// LAB 3: Your code here.

	// Allocates a new env with env_alloc
	struct Env* env;
	int r;
	if((r = env_alloc(&env, 0)) != 0){
		panic("env_create failed: create env failed\n");
	}

	// loads the named elf binary into it with load_icode
	load_icode(env, binary);

	// sets its env_type.
	env->env_type = type;
}
```



#### void env_run(struct Env *e)

```C
// Context switch from curenv to env e.
// Note: if this is the first call to env_run, curenv is NULL.
//
// This function does not return.
```

从当前的进程curenv切换到进程e，如果是第一次调用env_run函数，curenv是NULL



#### gdb对Hello进行断点调试

此处我试过很多解决办法，但定位到`int   $0x30`时，并不会显示出执行到这一句

但是没有找到代码中哪里有问题，替换成其他人写的代码也没有找出办法

有一个想法，Lab2时要求使用`add -f 6.828`去获取最新的QEMU版本，这个当时没有执行成功，不知道是不是这个问题



2023/3/31

喜大普奔，终于找到了问题的所在，[感谢大神](https://blog.csdn.net/wysiwygo/article/details/104296090)

上面的链接中提到，在进行make 然后 make qemu之后会出现报错

![bssquestion](..\03Lab3\bssquestion.PNG)

倒数第三行，会出现报错`kernel panic at kern/pmap.c:148: PADDR called with invalid kva 00000000`



使用`objdump -h obj/kern/kernel`查看各Section的分部

```
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         0000531d  f0100000  00100000  00001000  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .rodata       00001688  f0105320  00105320  00006320  2**5
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .stab         00009415  f01069a8  001069a8  000079a8  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .stabstr      00002a79  f010fdbd  0010fdbd  00010dbd  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .data         0007a014  f0113000  00113000  00014000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
  5 .got          00000008  f018d014  0018d014  0008e014  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  6 .got.plt      0000000c  f018d01c  0018d01c  0008e01c  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  7 .data.rel.local 0000100e  f018e000  0018e000  0008f000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
  8 .data.rel.ro.local 000000cc  f018f020  0018f020  00090020  2**5
                  CONTENTS, ALLOC, LOAD, DATA
  9 .bss          00000f14  f018f100  0018f100  00090100  2**5
                  CONTENTS, ALLOC, LOAD, DATA
 10 .comment      0000002b  00000000  00000000  00091014  2**0
                  CONTENTS, READONLY
```

可以看到,.bss段起始地址为0xf018f100，.bss段的大小为0xf14，所以lab2提供的end变量应该是0xf0190014

在`kern/pmap.c`的boot_alloc函数中修改

```C
if (!nextfree) {
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
		cprintf(".bss end is %08x\n", end);
	}
```

然后重新`make `以及`make qemu`可以得到

```
qemu-system-i386 -drive file=obj/kern/kernel.img,index=0,media=disk,format=raw -serial mon:stdio -gdb tcp::26000 -D qemu.log 
VNC server running on `127.0.0.1:5900'
6828 decimal is 15254 octal!
Physical memory: 131072K available, base = 640K, extended = 130432K
.bss end is f0190000
kernel panic at kern/pmap.c:149: PADDR called with invalid kva 00000000
Welcome to the JOS kernel monitor!
Type 'help' for a list of commands.
K> 
```

k恶意看到，打印出的.bss end地址是0xf0190000，并不是我们计算得到的0xf0190014，实际上，这个end的地址在.bss段内，而不是段的末尾

修改`kern/kernel.ld`

```
.bss : {
		PROVIDE(edata = .);
		*(.bss)
		*(COMMON)
		PROVIDE(end = .);
		BYTE(0)
	}
```

增加*(COMMON)，重新运行便看不到之前的报错`kernel panic at kern/pmap.c:148: PADDR called with invalid kva 00000000`，使用make grade也能得到Part A 的全部分数，并且make grade之后也会发现qemu打印了许多之前没见过的内容。



2023/3/31 后续

本以为问题已经解决，但是突然发现修改了kernel.ld之后，打印出来的end的地址根本没有改变

```
.bss end is f0190010
```

仍旧和之前一样，使用`objdump -h obj/kern/kernel`

```
ections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         0000533d  f0100000  00100000  00001000  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .rodata       00001698  f0105340  00105340  00006340  2**5
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .stab         0000942d  f01069d8  001069d8  000079d8  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .stabstr      00002a79  f010fe05  0010fe05  00010e05  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .data         0007a014  f0113000  00113000  00014000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
  5 .got          00000008  f018d014  0018d014  0008e014  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  6 .got.plt      0000000c  f018d01c  0018d01c  0008e01c  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  7 .data.rel.local 0000100e  f018e000  0018e000  0008f000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
  8 .data.rel.ro.local 000000cc  f018f020  0018f020  00090020  2**5
                  CONTENTS, ALLOC, LOAD, DATA
  9 .bss          00000f11  f018f100  0018f100  00090100  2**5
                  CONTENTS, ALLOC, LOAD, DATA
 10 .comment      0000002b  00000000  00000000  00091011  2**0
                  CONTENTS, READONLY
```

可以发现.bss段的末尾end仍然在.bss段内，但是问题解决了，这又是怎么回事呢？



重新打开[感谢大神](https://blog.csdn.net/wysiwygo/article/details/104296090)的链接，发现大神参考了一个[国外的链接](https://qiita.com/kagurazakakotori/items/334ab87a6eeb76711936)

里面有这样一段

The procedure is to link all `.bss` section of kernel objects to kernel, then set the `end` symbol. However, the output `objdump -t obj/kern/pmap.o | grep kern_pgdir` shows `kern_pgdir` is actually in `COMMON` section. In my personal opinion, the `COMMON` will be linked implicitly to `.bss` after `end` is set. To solve the problem, `COMMON` should be linked explicitly to `.bss` before `end` is set. That's why we need to modify the linker script as above.

我们将end的地址赋值给kern_pgdir，使用`objdump -t obj/kern/pmap.o | grep kern_pgdir`

```
00000004       O *COM*	00000004 kern_pgdir
```

发现kern_pgdir在COMMON段中，而修改之前的kernel.ld会将kern_pgdir存储到.bss段中，由此造成的错误

再次查询.bss段和COMMON段的区别

全局变量，初始化为0则存储在.bss段中，没有初始化则存储在common段中（看来COMMON段属于.bss段的一部分）

所以暂时的结论是：**我们的kern_pgdir变量最初存储在common段中，而kernel.ld并没有体现出common段，由此报错**

再深入我是真不会了！

```
he target architecture is assumed to be i8086
[f000:fff0]    0xffff0:	ljmp   $0xf000,$0xe05b
0x0000fff0 in ?? ()
+ symbol-file obj/kern/kernel
(gdb) b* 0x800bcb
Breakpoint 1 at 0x800bcb
(gdb) c
Continuing.
The target architecture is assumed to be i386
=> 0x800bcb:	int    $0x30

Breakpoint 1, 0x00800bcb in ?? ()
(gdb) 

```

这次终于可以调试Hello断点了，记得查找自己的`obj/user/hello.asm`，每个人的地址可能不一样





### 1.4、Setting Up the IDT

接下来我们要设置IDT

#### trapentry.S

**Exercise 4.** Edit `trapentry.S` and `trap.c` and implement the features described above. The macros `TRAPHANDLER` and `TRAPHANDLER_NOEC` in `trapentry.S` should help you, as well as the T_* defines in `inc/trap.h`. You will need to add an entry point in `trapentry.S` (using those macros) for each trap defined in `inc/trap.h`, and you'll have to provide `_alltraps` which the `TRAPHANDLER` macros refer to. You will also need to modify `trap_init()` to initialize the `idt` to point to each of these entry points defined in `trapentry.S`; the `SETGATE` macro will be helpful here.

Your `_alltraps` should:

1. push values to make the stack look like a struct Trapframe
2. load `GD_KD` into `%ds` and `%es`
3. `pushl %esp` to pass a pointer to the Trapframe as an argument to trap()
4. `call trap` (can `trap` ever return?)

Consider using the `pushal` instruction; it fits nicely with the layout of the `struct Trapframe`.

Test your trap handling code using some of the test programs in the `user` directory that cause exceptions before making any system calls, such as `user/divzero`. You should be able to get make grade to succeed on the `divzero`, `softint`, and `badsegment` tests at this point.



这部分练习我们要做的就是操作系统发生中断或异常时需要做的处理，简单来说就是将当前进程对应的内容压栈，然后调用相应的处理函数，在`inc/trap.h`中定义了如下的trap number

```C
// Trap numbers
// These are processor defined:
#define T_DIVIDE     0		// divide error
#define T_DEBUG      1		// debug exception
#define T_NMI        2		// non-maskable interrupt
#define T_BRKPT      3		// breakpoint
#define T_OFLOW      4		// overflow
#define T_BOUND      5		// bounds check
#define T_ILLOP      6		// illegal opcode
#define T_DEVICE     7		// device not available
#define T_DBLFLT     8		// double fault
/* #define T_COPROC  9 */	// reserved (not generated by recent processors)
#define T_TSS       10		// invalid task switch segment
#define T_SEGNP     11		// segment not present
#define T_STACK     12		// stack exception
#define T_GPFLT     13		// general protection fault
#define T_PGFLT     14		// page fault
/* #define T_RES    15 */	// reserved
#define T_FPERR     16		// floating point error
#define T_ALIGN     17		// aligment check
#define T_MCHK      18		// machine check
#define T_SIMDERR   19		// SIMD floating point error

// These are arbitrarily chosen, but with care not to overlap
// processor defined exceptions or interrupt vectors.
#define T_SYSCALL   48		// system call
#define T_DEFAULT   500		// catchall
```

练习4要求我们修改`trapentry.S` and `trap.c`，trapentry.S负责接收trap number之后的处理，trap.c负责初始化处理函数，并且让这些函数和IDT一一对应。

```C
/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps
```

先来看trapentry.S中的两个宏，lab4前面的介绍中写到过，x86系统在执行不同的中断或异常（这里的中断和异常都是泛指，我也不清楚他们具体属于interrupt trap还是exception中的哪类）时，会出现两种不同的处理方法：

如`divide by zero`时，只会压入五个word大小的数据：

```C
                     +--------------------+ KSTACKTOP             
                     | 0x00000 | old SS   |     " - 4
                     |      old ESP       |     " - 8
                     |     old EFLAGS     |     " - 12
                     | 0x00000 | old CS   |     " - 16
                     |      old EIP       |     " - 20 <---- ESP 
                     +--------------------+             
```

而在执行`page fault exception`时，则会压入六个word的数据，增加了一个`error code`

```C
                     +--------------------+ KSTACKTOP             
                     | 0x00000 | old SS   |     " - 4
                     |      old ESP       |     " - 8
                     |     old EFLAGS     |     " - 12
                     | 0x00000 | old CS   |     " - 16
                     |      old EIP       |     " - 20
                     |     error code     |     " - 24 <---- ESP
                     +--------------------+             
```

前面提到的两个宏就对应着这两种压栈的方式。



**那么，如何知道不同的中断或异常是否需要压入error code呢？**

经过大佬提示，我发现[IA32-3A](https://pdos.csail.mit.edu/6.828/2018/readings/ia32/IA32-3A.pdf)的5-15节专门介绍了这些中断是否有error code，没有则不需要压栈，有则需要压栈

拿0号中断divide by zero举例：

![Exception](..\03Lab3\Exception.PNG)

可以看到0号中断没有error code，所以调用宏TRAPHANDLER_NOEC即可，有中断号的则调用宏TRAPHANDLER



```C
/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(divide_handler,T_DIVIDE)
TRAPHANDLER_NOEC(debug_handler,T_DEBUG)
TRAPHANDLER_NOEC(nmi_handler,T_NMI)
TRAPHANDLER_NOEC(brkpt_handler,T_BRKPT)
TRAPHANDLER_NOEC(oflow_handler,T_OFLOW)
TRAPHANDLER_NOEC(bound_handler,T_BOUND)
TRAPHANDLER_NOEC(illop_handler,T_ILLOP)
TRAPHANDLER_NOEC(device_handler,T_DEVICE)
TRAPHANDLER(dblflt_handler,T_DBLFLT)
TRAPHANDLER(tss_handler,T_TSS)
TRAPHANDLER(segnp_handler,T_SEGNP)
TRAPHANDLER(stack_handler,T_STACK)
TRAPHANDLER(gpflt_handler,T_GPFLT)
TRAPHANDLER(pgflt_handler,T_PGFLT)
TRAPHANDLER_NOEC(fperr_handler,T_FPERR)
TRAPHANDLER(align_handler,T_ALIGN)
TRAPHANDLER_NOEC(mchk_handler,T_MCHK)
TRAPHANDLER_NOEC(simderr_handler,T_SIMDERR)
TRAPHANDLER_NOEC(syscall_handler,T_SYSCALL)
```



`trapentry.S`中还有一部分是让我们完成上述两个宏跳转位置`_alltraps`的编写

观察`inc/trap.h`中

```C
struct Trapframe {
	struct PushRegs tf_regs;
	uint16_t tf_es;
	uint16_t tf_padding1;
	uint16_t tf_ds;
	uint16_t tf_padding2;
	uint32_t tf_trapno;
	/* below here defined by x86 hardware */
	uint32_t tf_err;
	uintptr_t tf_eip;
	uint16_t tf_cs;
	uint16_t tf_padding3;
	uint32_t tf_eflags;
	/* below here only when crossing rings, such as from user to kernel */
	uintptr_t tf_esp;
	uint16_t tf_ss;
	uint16_t tf_padding4;
} __attribute__((packed));
```

可以发现我们刚刚压栈的数据和Trapframe数据结构从下网上是一致的，所以我们接下来要做的事情就是按照Trapframe的结构将剩下的数据压栈即可。



```C
/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl	%es
	pushl	%ds
	pushal
	movw	$(GD_KD), %ax
	movw 	%ax, %ds
	movw 	%ax, %es
	pushl	%esp
	call	trap
```

哎，又是一段不看其他人的实现自己就不会写的代码

按照Trapframe的结构，我们最后只需要压入es ds以及tf_regs即可，tf_regs属于

```C
struct PushRegs {
	/* registers as pushed by pusha */
	uint32_t reg_edi;
	uint32_t reg_esi;
	uint32_t reg_ebp;
	uint32_t reg_oesp;		/* Useless */
	uint32_t reg_ebx;
	uint32_t reg_edx;
	uint32_t reg_ecx;
	uint32_t reg_eax;
} __attribute__((packed));

```

代码中提示使用pusha指令即可，JOS中这类指令后面都有一个l，所以使用pushal指令即可

然后做出一些设置

```
	movw	$(GD_KD), %ax
	movw 	%ax, %ds
	movw 	%ax, %es
```

`GD_KD`定义在`inc/memlayout.h`中，表示内核数据段，我们马上要跳转到内核，所以将数据段切换到内核数据段

最后两句

```
	pushl	%esp
	call	trap
```

做好切换到内核态的准备之后，调用Trap函数即可

但是这里有一个问题困扰了我很久，那就是为什么要pushl %esp呢？

打开`kern/trap.c`

```C
void
trap(struct Trapframe *tf){}
```

我们发现trap函数需要传入一个参数，但是我们之前明明已经把Trapframe数据压入栈中了，为什么还要压入esp呢？

这个问题困扰了我很久，直到我发现trap函数里面的参数是指针类型的，我们需要传入的是trapframe的地址，而不是整个数据

恰好此时trapframe数据就在栈顶，而esp正好指向栈顶，所以我们将esp压栈即可

示意图如下：此时我们将trapframe数据结构压入栈中,esp指向栈顶，此时我们用oldesp代替

```C
// -------------------------
//     |    ss	       |			---------		
//     |    esp	   	   |				|
//     |    eflags	   |				|
//     |    cs		   |				|
//     |    eip		   |			Trapframe
//     |    err		   |				|
//     |    trapno	   |				|
//     |    ds		   |				|
//     |    es		   | <-- oldesp ---------
// -------------------------
```

由于我们要传入的是trapframe*类型，也就是一个地址，所以我们要将oldesp压栈，然后再调用trap函数

```C
// -------------------------
//     |    ss	       |			---------		
//     |    esp	   	   |				|
//     |    eflags	   |				|
//     |    cs		   |				|
//     |    eip		   |			Trapframe
//     |    err		   |				|
//     |    trapno	   |				|
//     |    ds		   |				|
//     |    es		   | 			---------
//     |    oldesp	   | <-- esp
// -------------------------
```

这里额外介绍以下汇编语言函数传递，假设函数void fun(int a, int b, int c);

我们在调用函数之前的参数压栈顺序是

```C
push a
push b
push c
call fun


// -------------------------
//     |    a	   |			
//     |    b	   |				
//     |    c	   |   <---- esp				
// -------------------------
//此时函数参数是三个数据，而不是指针，所以不需要将esp压栈
```



哎，研究了一上午上面为什么要这么写，还想着这东西我不可能想得到哇，然后发现Exercise 4的要求里面有这部分要求！

```
Your `_alltraps` should:

1. push values to make the stack look like a struct Trapframe
2. load `GD_KD` into `%ds` and `%es`
3. `pushl %esp` to pass a pointer to the Trapframe as an argument to trap()
4. `call trap` (can `trap` ever return?)
```





#### trap.c

题目要求我们在trap_init函数中初始化idt

```C
void divide_handler();
void debug_handler();
void nmi_handler();
void brkpt_handler();
void oflow_handler();
void bound_handler();
void illop_handler();
void device_handler();
void dblflt_handler();
void tss_handler();
void segnp_handler();
void stack_handler();
void gpflt_handler();
void pgflt_handler();
void fperr_handler();
void align_handler();
void mchk_handler();
void simderr_handler();
void syscall_handler();


void
trap_init(void)
{
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.
	SETGATE(idt[T_DIVIDE], 0, GD_KT, divide_handler, 0);
	SETGATE(idt[T_DEBUG], 0, GD_KT, debug_handler, 0);
	SETGATE(idt[T_NMI], 0, GD_KT, nmi_handler, 0);
	SETGATE(idt[T_BRKPT], 0, GD_KT, brkpt_handler, 3);
	SETGATE(idt[T_OFLOW], 0, GD_KT, oflow_handler, 0);
	SETGATE(idt[T_BOUND], 0, GD_KT, bound_handler, 0);
	SETGATE(idt[T_ILLOP], 0, GD_KT, illop_handler, 0);
	SETGATE(idt[T_DEVICE], 0, GD_KT, device_handler, 0);
	SETGATE(idt[T_DBLFLT], 0, GD_KT, dblflt_handler, 0);
	SETGATE(idt[T_TSS], 0, GD_KT, tss_handler, 0);
	SETGATE(idt[T_SEGNP], 0, GD_KT, segnp_handler, 0);
	SETGATE(idt[T_STACK], 0, GD_KT, stack_handler, 0);
	SETGATE(idt[T_GPFLT], 0, GD_KT, gpflt_handler, 0);
	SETGATE(idt[T_PGFLT], 0, GD_KT, pgflt_handler, 0);
	SETGATE(idt[T_FPERR], 0, GD_KT, fperr_handler, 0);
	SETGATE(idt[T_ALIGN], 0, GD_KT, align_handler, 0);
	SETGATE(idt[T_MCHK], 0, GD_KT, mchk_handler, 0);
	SETGATE(idt[T_SIMDERR], 0, GD_KT, simderr_handler, 0);
	SETGATE(idt[T_SYSCALL], 0, GD_KT, syscall_handler, 3);

	// Per-CPU setup 
	trap_init_percpu();
}
```

SETGATE的宏在`inc\mmu.h`中定义

```C
#define SETGATE(gate, istrap, sel, off, dpl)			\
{								\
	(gate).gd_off_15_0 = (uint32_t) (off) & 0xffff;		\
	(gate).gd_sel = (sel);					\
	(gate).gd_args = 0;					\
	(gate).gd_rsv1 = 0;					\
	(gate).gd_type = (istrap) ? STS_TG32 : STS_IG32;	\
	(gate).gd_s = 0;					\
	(gate).gd_dpl = (dpl);					\
	(gate).gd_p = 1;					\
	(gate).gd_off_31_16 = (uint32_t) (off) >> 16;		\
}
```



#### 梳理一下用户态到内核态的上下文切换压入过程：

1、由用户程序切换到内核，我们需要保存用户程序的各个寄存器信息，这些信息都被保存到用户程序的Trapframe里面

2、用户态发出一个异常，此时，需要进入内核态进行处理

3、CPU首先切换堆栈（用户栈—>内核栈），怎么切换？

​		通过TSS寄存器获得SS0和ESP0，这两个值描述了内核堆栈的位置，那么如何保存这两个值？

​		当然是需要保存在SS寄存器和ESP寄存器中。因此，CPU需要先将用户态的SS与ESP压入到内核栈上，同时还要压入EFLAGS。

4、因为要运行内核指令，所以CPU还需要压入用户态的CS和EIP

5、接下来，通过中断向量在IDT中查找对应的中断处理函数，其trapno（中断值）由TRAPHANDLER或TRAPHANDER_NOEC这两个宏函数压入

6、然后执行_alltraps，其作用就是压入剩下的寄存器：DS、ES以及tf_regs结构中的所有寄存器

7、此时ESP会指向内核栈的栈顶，压入ESP，表示完成了trapframe结构的构建，这个会作为参数传递给trap()函数

8、最后，call trap，此时，上下文已经切换完成了，可以调用trap()函数从而进入中断处理函数，进行处理了

### Questions

1、What is the purpose of having an individual handler function for each exception/interrupt? (i.e., if all exceptions/interrupts were delivered to the same handler, what feature that exists in the current implementation could not be provided?)

所有的中断异常肯定要有自己的处理函数，不然没法解决问题。

有的中断硬件会多压栈一个错误码，采用独立的handler可以处理不一致的trapframe

2、Did you have to do anything to make the `user/softint` program behave correctly? The grade script expects it to produce a general protection fault (trap 13), but `softint`'s code says `int $14`. *Why* should this produce interrupt vector 13? What happens if the kernel actually allows `softint`'s `int $14` instruction to invoke the kernel's page fault handler (which is interrupt vector 14)?

14号中断需要内核态的权限0才能调用，用户态权限为3，没有权限调用14号中断，所以会触发保护异常(General Protection Fault)

如果用户态直接可以触发缺页异常，会导致内核无法确定触发缺页异常的原因



## 2、Part B: Page Faults, Breakpoints Exceptions, and System Calls

### 2.1、Handling Page Faults

page fault exception，第14号中断向量，是本次实验和下次实验中非常重要的一个。当处理器发生page fault时，处理器会将导致fault的线性地址存储到`cr2`寄存器。在`trap.c`中我们提供了`page_fault_handler`函数来处理page fault



**Exercise 5.** Modify `trap_dispatch()` to dispatch page fault exceptions to `page_fault_handler()`. You should now be able to get make grade to succeed on the `faultread`, `faultreadkernel`, `faultwrite`, and `faultwritekernel` tests. If any of them don't work, figure out why and fix them. Remember that you can boot JOS into a particular user program using make run-*x* or make run-*x*-nox. For instance, make run-hello-nox runs the *hello* user program.



接着前面提到过的工作流程，捕捉到中断后，trapentry.S会压栈一个trapframe数据结构的数据，然后跳转到trap函数，trap函数验证trapframe是否正确，然后调用trap_dispatch函数来具体处理中断，trapframe中的tf_trapno存储着中断号，直接按照题目的意思调用page_fault_handler函数即可



```C
static void
trap_dispatch(struct Trapframe *tf)
{
	// Handle processor exceptions.
	// LAB 3: Your code here.
	switch(tf->tf_trapno)
	{
		case T_PGFLT:
			page_fault_handler(tf);
			return ;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
	if (tf->tf_cs == GD_KT)
		panic("unhandled trap in kernel");
	else {
		env_destroy(curenv);
		return;
	}
}
```



使用`make grade`可以得到

```
divzero: OK (2.0s) 
softint: OK (1.2s) 
badsegment: OK (1.1s) 
Part A score: 30/30

faultread: OK (2.0s) 
faultreadkernel: OK (1.7s) 
faultwrite: OK (1.1s) 
faultwritekernel: OK (1.2s) 

```



### 2.2、The Breakpoint Exception

breakpoint exception，中断号为3，被用来为程序打断点。原理为暂时性的替代当前执行的指令为int $3软件中断指令。

在JOS中，我们将轻微滥用这个异常，将其转换为一个基本的伪系统调用，任何用户环境都可以使用它来调用JOS内核监视器



**Exercise 6.** Modify `trap_dispatch()` to make breakpoint exceptions invoke the kernel monitor. You should now be able to get make grade to succeed on the `breakpoint` test.



在`kern/monitor.c`中存在monitor函数，调用这个函数表示invoke the kernle monitor

```C
void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
```



在trap_dispatch中添加

```C
case T_BRKPT:
			monitor(tf);
			return ;
```



运行make grade可以得到

```
breakpoint: OK (1.1s) 
    (Old jos.out.breakpoint failure log removed)
```



### 2.3、**Questions**

3、The break point test case will either generate a break point exception or a general protection fault depending on how you initialized the break point entry in the IDT (i.e., your call to `SETGATE` from `trap_init`). Why? How do you need to set it up in order to get the breakpoint exception to work as specified above and what incorrect setup would cause it to trigger a general protection fault?

```C
SETGATE(idt[T_BRKPT], 0, GD_KT, brkpt_handler, 3);
```

breakpoint的特权等级为3，用户在触发时拥有这个权限，所以不会触发page fault exception



4、What do you think is the point of these mechanisms, particularly in light of what the `user/softint` test program does?

可以防止用户随意地触发异常，但同时有流出一个接口供用户使用系统服务



### 2.4、System calls

用户进程通过调用system calls让内核为自己做一些事情。当用户进程调用system call时，processor进入内核模式，processer和内核共同保存用户进程状态，内核执行system call的相应代码。然后恢复用户进程。用户进程如何获得内核调用以及他如何指定要执行哪个调用因处理器的不同而发生变化

在JOS中，我们会使用`int`指令触发处理器中断。除此之外，我们会使用`int $0x30`作为系统调用异常。我们已经定义了T_SYSCALL。你需要设置中断描述符去允许用户进程触发该中断。注意中断0x30不能被硬件生成，意思是这个中断只能由用户代码触发

我们通过寄存器传递system call number和system call arguments。用这种方法内核就不需要在用户环境的堆栈或指令流中四处寻找。

system call number放置在eax中，argument（至多五个）放置在edx ebx ecx edi esi中，内核的返回值放置在eax中。



**Exercise 7.** Add a handler in the kernel for interrupt vector `T_SYSCALL`. You will have to edit `kern/trapentry.S` and `kern/trap.c`'s `trap_init()`. You also need to change `trap_dispatch()` to handle the system call interrupt by calling `syscall()` (defined in `kern/syscall.c`) with the appropriate arguments, and then arranging for the return value to be passed back to the user process in `%eax`. Finally, you need to implement `syscall()` in `kern/syscall.c`. Make sure `syscall()` returns `-E_INVAL` if the system call number is invalid. You should read and understand `lib/syscall.c` (especially the inline assembly routine) in order to confirm your understanding of the system call interface. Handle all the system calls listed in `inc/syscall.h` by invoking the corresponding kernel function for each call.

Run the `user/hello` program under your kernel (make run-hello). It should print "`hello, world`" on the console and then cause a page fault in user mode. If this does not happen, it probably means your system call handler isn't quite right. You should also now be able to get make grade to succeed on the `testbss` test.



对于trapentry.S以及trap_init()的处理前面已经设置完成了，本次练习只需要修改trap_dispatch以及syscall.c即可

```C

	switch(tf->tf_trapno)
	{
		case T_PGFLT:
			page_fault_handler(tf);
			return ;
		case T_BRKPT:
			monitor(tf);
			return ;
		case T_SYSCALL:{
			struct PushRegs *p = &tf->tf_regs;
			p->reg_eax = syscall(p->reg_eax, p->reg_edx, p->reg_ecx, p->reg_ebx, p->reg_edi, p->reg_esi);
			return ;
		}
		default:
			break;
	}
```

新增case T_SYSCALL，记得使用{}将这部分扩起来，不然会报错`a label can only be part of a statement and a declaration is not a statement`

syscall函数在kern/syscall.c中

```C
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	//panic("syscall not implemented");

	switch (syscallno) {
	default:
		return -E_INVAL;
	}
}
```

打开这个发现没有什么思路哇！switch里面都有什么case啊，完全不清楚，syscall函数前面确实有几个函数，但是不清楚他们的syscallno，都不清楚怎么调用呀！

突然灵机一动，这些数据肯定在.h文件中定义这，打开`kern/syscall.h`

```C
#ifndef JOS_KERN_SYSCALL_H
#define JOS_KERN_SYSCALL_H
#ifndef JOS_KERNEL
# error "This is a JOS kernel header; user programs should not #include it"
#endif

#include <inc/syscall.h>

int32_t syscall(uint32_t num, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5);

#endif /* !JOS_KERN_SYSCALL_H */
```

发现没有

但仔细观察发现这个.h文件引用了`inc/syscall.h`，打开`inc/syscall.h`，破案了

```C
#ifndef JOS_INC_SYSCALL_H
#define JOS_INC_SYSCALL_H

/* system call numbers */
enum {
	SYS_cputs = 0,
	SYS_cgetc,
	SYS_getenvid,
	SYS_env_destroy,
	NSYSCALLS
};

#endif /* !JOS_INC_SYSCALL_H */
```

这下就知道写什么了，另外记得参数以及哪些是参数以及eax是返回值

```C
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	//panic("syscall not implemented");

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
	default:
		return -E_INVAL;
	}
}
```

make grade之后

```
divzero: OK (1.7s) 
softint: OK (1.1s) 
badsegment: OK (1.7s) 
Part A score: 30/30

faultread: OK (1.1s) 
faultreadkernel: OK (1.2s) 
faultwrite: OK (1.2s) 
faultwritekernel: OK (1.5s) 
breakpoint: OK (1.1s) 
testbss: OK (1.2s) 
    (Old jos.out.testbss failure log removed)
```



### 2.5、User-mode startup

用户程序从`lib/entry.S`开始运行，在进行一些设置后，调用libmain()函数。我们需要修改libmain()函数来初始化全局指针`thisenv`，该指针指向envs数组

libmain()函数之后调用umain，umain在`user/hello.c`中。注意在打印"hello, world"之后，代码尝试达到thisenv->env_id。这是为什么代码在更早的时候就fault了。现在我们需要初始化thisenv，让他不要fault。

如果代码仍然fault，那就是你没有把UENVS映射用户只读区域



**Exercise 8.** Add the required code to the user library, then boot your kernel. You should see `user/hello` print "`hello, world`" and then print "`i am environment 00001000`". `user/hello` then attempts to "exit" by calling `sys_env_destroy()` (see `lib/libmain.c` and `lib/exit.c`). Since the kernel currently only supports one user environment, it should report that it has destroyed the only environment and then drop into the kernel monitor. You should be able to get make grade to succeed on the `hello` test.



Exercise 8虽然说了一大堆，但是实际上需要修改的只有`lib/libmain.c`

```C
#include <inc/lib.h>

extern void umain(int argc, char **argv);

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];

	// save the name of the program so that panic() can use it
	if (argc > 0)
		binaryname = argv[0];

	// call user main routine
	umain(argc, argv);

	// exit gracefully
	exit();
}
```

练习的要求是让thisenv指向我们当前的Env structure，ENVX是定义在`inc/env.h`中的宏，根据envid返回其在envs中的下标

sys_getenvid()直接返回curenv->envid



感觉直接thisenv = curenv;也可行



### 2.6、Page faults and memory protection

内存保护是操作系统中至关重要的特性，他确保了一个程序中的bug不会影响到另一个程序或者影响到操作系统本身

操作系统通常依赖已经去实现内存保护。操作系统告知硬件哪些虚拟地址是有效的，哪些是无效的。当程序尝试访问无效地址或者没有权限的地址时，处理器会在程序当前的指令处触发fault，然后进入内核，并向内核传递刚刚尝试操作的信息。如果fault是固定的，那么内核可以固定住这个操作并且让程序继续运行。否则不行。

接下来我们将详细检查从用户空间传递到内核的指针。当程序向内核传递指针时，内核会检查地址是否在用户的地址空间部分，并且检查页表是否允许内存操作



**Exercise 9.** Change `kern/trap.c` to panic if a page fault happens in kernel mode.

Hint: to determine whether a fault happened in user mode or in kernel mode, check the low bits of the `tf_cs`.

Read `user_mem_assert` in `kern/pmap.c` and implement `user_mem_check` in that same file.

Change `kern/syscall.c` to sanity check arguments to system calls.

Boot your kernel, running `user/buggyhello`. The environment should be destroyed, and the kernel should *not* panic. You should see:

```
	[00001000] user_mem_check assertion failure for va 00000001
	[00001000] free env 00001000
	Destroyed the only environment - nothing more to do!
	
```

Finally, change `debuginfo_eip` in `kern/kdebug.c` to call `user_mem_check` on `usd`, `stabs`, and `stabstr`. If you now run `user/breakpoint`, you should be able to run backtrace from the kernel monitor and see the backtrace traverse into `lib/libmain.c` before the kernel panics with a page fault. What causes this page fault? You don't need to fix it, but you should understand why it happens.



练习9要我们修改`kern/trap.c`，如果内核发生page fault则直接使用panic

并且提示我们查看tf_cs来判断fault发生在用户模式还是内核模式，tf_cs是Trapframe中的一项

题目要求我们阅读`user_mem_assert`

```C
// Checks that environment 'env' is allowed to access the range
// of memory [va, va+len) with permissions 'perm | PTE_U | PTE_P'.
// If it can, then the function simply returns.
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
		cprintf("[%08x] user_mem_check assertion failure for "
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
	}
}
```

可以看到，该函数查看env在[va, va+len)是否带有权限perm | PTE_U | PTE_P，如果可以则继续运行，如果不可以则进入destroy

我们要实现的`user_mem_check`主要负责检查是否有权限

```C
// Check that an environment is allowed to access the range of memory
// [va, va+len) with permissions 'perm | PTE_P'.
// Normally 'perm' will contain PTE_U at least, but this is not required.
// 'va' and 'len' need not be page-aligned; you must test every page that
// contains any of that range.  You will test either 'len/PGSIZE',
// 'len/PGSIZE + 1', or 'len/PGSIZE + 2' pages.
//
// A user program can access a virtual address if (1) the address is below
// ULIM, and (2) the page table gives it permission.  These are exactly
// the tests you should implement here.
//
// If there is an error, set the 'user_mem_check_addr' variable to the first
// erroneous virtual address.
//
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
```

根据注释中的提示我们可以知道，需要判断虚拟地址是否在ULIM之下或者页表是否有权限

虚拟地址范围类似前面的ROUNDDOWN(va) ~ ROUNDUP(va + len)

```C
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
	// LAB 3: Your code here.
	pte_t *pte;
    uintptr_t vstart, vend;

    vstart = ROUNDDOWN((uintptr_t)va, PGSIZE);
    vend = ROUNDUP((uintptr_t)va + len, PGSIZE);
    
    if (vend > ULIM) {
        user_mem_check_addr = MAX(ULIM, (uintptr_t)va);
        return -E_FAULT;
    }
    for (; vstart < vend; vstart += PGSIZE) {
        pte = pgdir_walk(env->env_pgdir, (void*)vstart, 0);
        if (!pte || (*pte & (perm | PTE_P)) != (perm | PTE_P)) {
            user_mem_check_addr = MAX(vstart, (uintptr_t)va);
            return -E_FAULT;
        }
    }

    return 0;
}
```

注意，使用pgdir_walk时的create参数必须为0，我们是要检查是否有权限，很有可能这个地址根本就没有分配物理页



接下来，修改`kern/syscall.c`，只有sys_cputs函数需要检查

```C
static void
sys_cputs(const char *s, size_t len)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.
	user_mem_assert(curenv, s, len, PTE_U);

	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
}
```



最后，修改`kern/kdebug.c`中的debuginfo_eip，共有两处需要填写

```C
		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if(curenv && user_mem_check(curenv, (void*)usd, sizeof(struct UserStabData), PTE_U) < 0){
			return -1;
		}
```

第一处根据提示使用user_mem_check确保内存可用，并且需要检查curenv是否存在



```C
// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (curenv && (
                user_mem_check(curenv, (void*)stabs, 
                               (uintptr_t)stab_end - (uintptr_t)stabs, PTE_U) < 0 || 
                user_mem_check(curenv, (void*)stabstr, 
                               (uintptr_t)stabstr_end - (uintptr_t)stabstr, PTE_U) < 0))
        	return -1;
```



上面两处都涉及了usd，usd结构如下所示:

```C
struct UserStabData {
	const struct Stab *stabs;
	const struct Stab *stab_end;
	const char *stabstr;
	const char *stabstr_end;
};
```



阅读代码可以得知，操作系统中有两种Stab，一种是单纯的stab，另一个是stabstr，这两种结构分别存储在stab table和stabstr table中，我们在debuginfo_eip要做的第二件事就是检查这两个table的权限是否合理。

注意，内核和用户都拥有各自的两种table，内核的table不需要我们检查，我们只检查用户环境下的table，所以看整体代码

```C
// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
	} else {
		// The user-application linker script, user/user.ld,
		// puts information about the application's stabs (equivalent
		// to __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__, and
		// __STABSTR_END__) in a structure located at virtual address
		// USTABDATA.
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if(curenv && user_mem_check(curenv, (void*)usd, sizeof(struct UserStabData), PTE_U) < 0){
			return -1;
		}

		stabs = usd->stabs;
		stab_end = usd->stab_end;
		stabstr = usd->stabstr;
		stabstr_end = usd->stabstr_end;

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (curenv && (
                user_mem_check(curenv, (void*)stabs, 
                               (uintptr_t)stab_end - (uintptr_t)stabs, PTE_U) < 0 || 
                user_mem_check(curenv, (void*)stabstr, 
                               (uintptr_t)stabstr_end - (uintptr_t)stabstr, PTE_U) < 0))
        	return -1;
	}

```

当地址大于ULIM时，说明此时处于内核态，不需要检查，出于用户态则需要检查usd本身以及usd所记录的两种table权限是覅偶合理



运行`make run-buggyhello`可以得到

```
[00001000] user_mem_check assertion failure for va 00000001
[00001000] free env 00001000
Destroyed the only environment - nothing more to do!
```



**Exercise 10.** Boot your kernel, running `user/evilhello`. The environment should be destroyed, and the kernel should not panic. You should see:

```
	[00000000] new env 00001000
	...
	[00001000] user_mem_check assertion failure for va f010000c
	[00001000] free env 00001000
	
```



运行`make run-evilhello`，可以得到

```
[00000000] new env 00001000
Incoming TRAP frame at 0xefffffbc
Incoming TRAP frame at 0xefffffbc
[00001000] user_mem_check assertion failure for va f010000c
[00001000] free env 00001000

```



有时间要好好总结一下这章的运行流程！！！
