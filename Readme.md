# Lab2:Memory Management

## 1、概述

```
In this lab, you will write the memory management code for your operating system. Memory management has two components.

The first component is a physical memory allocator for the kernel, so that the kernel can allocate memory and later free it. Your allocator will operate in units of 4096 bytes, called pages. Your task will be to maintain data structures that record which physical pages are free and which are allocated, and how many processes are sharing each allocated page. You will also write the routines to allocate and free pages of memory.

The second component of memory management is virtual memory, which maps the virtual addresses used by kernel and user software to addresses in physical memory. The x86 hardware's memory management unit (MMU) performs the mapping when instructions use memory, consulting a set of page tables. You will modify JOS to set up the MMU's page tables according to a specification we provide.
```



本实验主要分两个部分，

第一部分：维护数据结构，这种数据结构负责记录哪些物理页空闲，哪些被分配以及多少进程正在共享着每一个被分配的页。

第二部分：虚拟内存，将内核和用户软件的地址映射到物理地址上。

## 2、Getting Start

使用`git checkout -b lab2 origin/lab2`转换到lab2的分支

lab2包含一些新的文件

- `inc/memlayout.h`
- `kern/pmap.c`
- `kern/pmap.h`
- `kern/kclock.h`
- `kern/kclock.c`

`memlayout.h`描述虚拟地址的分步，你必须通过修改`pmap.c`，`memlayout.h`以及`pmap.h`来完成`PageInfo`数据结构的定义。

`kclock.c`和`kclosk.h`操作the PC's battery-backed clock and CMOS RAM hardware, in which the BIOS records the amount of physical memory the PC contains, among other things.（不太会翻译）

`pmap.c`代码需要需要读取硬件设备的信息以便弄清有多少物理内存，其中我们不需要知道CMOS hardware的工作细节。



**开始lab之前，记得使用`add -f 6.828`获得新的QEMU的版本**（这部分目前我没操作清楚，不知道后续是否会有影响）



## 3、Part 1: Physical Page Management

操作系统必须了解哪部分物理地址是空闲的，哪部分是已经占用的。JOS使用page granularity(页粒度)管理物理内存，以便于可以使用MMU映射和保护每一块分配的内存。

我们需要实现物理内存分配器。分配器会使用list of struct PageInfo来跟踪哪些页面空闲，哪些页面占用

```
Exercise 1. In the file kern/pmap.c, you must implement code for the following functions (probably in the order given).

boot_alloc()
mem_init() (only up to the call to check_page_free_list(1))
page_init()
page_alloc()
page_free()

check_page_free_list() and check_page_alloc() test your physical page allocator. You should boot JOS and see whether check_page_alloc() reports success. Fix your code so that it passes. You may find it helpful to add your own assert()s to verify that your assumptions are correct.
```

 我们需要实现题目中的五个函数，其中`mem_init()`函数只需要实现到`check_page_free_list(1)`为止即可，练习中使用check_page_free_list()和check_page_alloc()函数进行测试。



前面还提到以上函数中涉及的内容可以参考`pmap.h`，'memlayout.h'和`mmu.h`



### boot_alloc()

`static void *boot_alloc(uint32_t n)`

boot_alloc是一个简单的物理页面分配器，他只在JOS设置好虚拟地址之前使用。

如果`n>0`，为物理页分配n字节的连续物理内存，但是不要初始化，返回虚拟地址

如果`n=0`，返回下一个可用的空闲的物理页，不要分配任何内容

```C
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = nextfree;
	nextfree = ROUNDUP(result + n, PGSIZE);

	// If we're out of memory, boot_alloc should panic.
	// 这部分目前没有思路

	return result;
```



### mem_init()

`void mem_init(void)`

虚拟地址的问题我们放到下一节说，我们只需要知道我们目前使用的是物理地址

`PADDR`函数可以将虚拟地址转换成物理地址

`KADDR`函数可以将物理地址转换成虚拟地址

进入写代码部分

```C
//////////////////////////////////////////////////////////////////////
	// Allocate an array of npages 'struct PageInfo's and store it in 'pages'.
	// The kernel uses this array to keep track of physical pages: for
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:

	// 此时还没有堆栈的概念，所以不可以使用malloc
	// 另外下面会对这部分内存进行填充0，所以使用boot_alloc即可
	// pages = (struct PageInfo*)malloc(sizeof(struct PageInfo) * npages);
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);
	memset(pages, 0, sizeof(struct PageInfo) * npages);

```

本次练习所需要写的代码仅有这一段，按照题目要求分配pageInfo数组之后将其全部填充为0

### page_init()

`void page_init(void)`

该函数需要完成四项工作，我们直接结合代码来说

```C
// The example code here marks all physical pages as free.
	// However this is not truly the case.  What memory is free?
	//  1) Mark physical page 0 as in use.
	//     This way we preserve the real-mode IDT and BIOS structures
	//     in case we ever need them.  (Currently we don't, but...)
	//  2) The rest of base memory, [PGSIZE, npages_basemem * PGSIZE)
	//     is free.
	//  3) Then comes the IO hole [IOPHYSMEM, EXTPHYSMEM), which must
	//     never be allocated.
	//  4) Then extended memory [EXTPHYSMEM, ...).
	//     Some of it is in use, some is free. Where is the kernel
	//     in physical memory?  Which pages are already in use for
	//     page tables and other data structures?
	//
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!

	// 1)page 0设置为占用
	pages[0].pp_ref = 1;
	pages[0].pp_link = NULL;

	// 2)[PGSIZE, npages_basemem * PGSIZE) 设置为空闲
	size_t i;
	//for (i = 0; i < npages; i++) {
	for (i = 1; i < npages_basemem; i++) {
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}

	// 3)IO hole [IOPHYSMEM, EXTPHYSMEM)不可以被分配
	size_t io = (size_t)IOPHYSMEM / PGSIZE;
	size_t ex = (size_t)EXTPHYSMEM / PGSIZE;
	for(i = io; i < ex; i++){
		pages[i].pp_ref = 1;
		pages[i].pp_link = NULL;
	}
	
	// 4)其他位置
	// boot_alloc(0)返回第一个可用page的虚拟地址，此处需要转换成物理地址
	// ex = (size_t)EXTPHYSMEM / PGSIZE;
	// ex 往后的所有page有的可以使用，有的不可使用
	// 综上， [ex, boot_alloc(0))不可用， [boot_alloc(0), npages)可用
	size_t fisrt_page = PADDR(boot_alloc(0)) / PGSIZE;
	for(i = ex; i < fisrt_page; i++){
		pages[i].pp_ref = 1;
		pages[i].pp_link = NULL;
	}

	for(i = fisrt_page; i < npages; i++){
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}
}
```

### page_alloc()

`struct PageInfo * page_alloc(int alloc_flags)`

分配一个物理页，If (alloc_flags & ALLOC_ZERO)，将整个要返回的物理页填充满'\0'，

确保pp_link指向NULL，以免出现double-free bugs

如果超出内存则返回NULL

page2kva()函数在`pmap.h`中，作用是通过物理页获取内核虚拟地址

```C
struct PageInfo *
page_alloc(int alloc_flags)
{
	// Fill this function in
	struct PageInfo* pp;
	if(!page_free_list) {
		cprintf("page_alloc: out of free memory\n");
		return NULL;
	}

	pp = page_free_list;
	page_free_list = page_free_list->pp_link;
	pp->pp_link = NULL;

	if(alloc_flags && ALLOC_ZERO){
		memset(page2kva(pp), '\0', PGSIZE);
	}
	return pp;
}
```

### page_free()

`void page_free(struct PageInfo *pp)`

Return a page to the free list.意思就是返回释放一个页，然后将改页加入到page_free_list中

```C
void
page_free(struct PageInfo *pp)
{
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
	if(pp->pp_ref != 0){
		panic("page_free: pp->pp_ref is nonzero\n");
	}else if(pp->pp_link != NULL){
		panic("page_free: pp->pp_link is NULL\n");
	}else{
		pp->pp_link = page_free_list;
		page_free_list = pp;
	}

	return ;
}
```

代码中提示需要判断pp_ref非零以及pp_link非空（注意！非空）

插入到page_free_list采用page_alloc中的头插法即可

## 4、Part 2: Virtual Memory

首先我们需要了解x86保护模式内存管理体系结构，叫做段(segment)和页转换(page translation)

**Exercise 2**:要求我们阅读chapters 5 and 6 of the [Intel 80386 Reference Manual](https://pdos.csail.mit.edu/6.828/2018/readings/i386/toc.htm)

第五章主要介绍线性地址、物理地址和虚拟地址的关系

第六章主要介绍保护模式中PTE、GDT、segment selector等数据结构如何维护其特权等级，以及他们的关系



```
Exercise 3. While GDB can only access QEMU's memory by virtual address, it's often useful to be able to inspect physical memory while setting up virtual memory. Review the QEMU monitor commands from the lab tools guide, especially the xp command, which lets you inspect physical memory. To access the QEMU monitor, press Ctrl-a c in the terminal (the same binding returns to the serial console).

Use the xp command in the QEMU monitor and the x command in GDB to inspect memory at corresponding physical and virtual addresses and make sure you see the same data.

Our patched version of QEMU provides an info pg command that may also prove useful: it shows a compact but detailed representation of the current page tables, including all mapped memory ranges, permissions, and flags. Stock QEMU also provides an info mem command that shows an overview of which ranges of virtual addresses are mapped and with what permissions.
```



GDB只能通过虚拟地址访问QEMU的内存，但在虚拟内存建立时查看物理内存也是很有必要的

按照提示make qemu-gdb后输入ctrl+a c后

```
(gdb) x/16x 0x0
0x0:	0xf000ff53	0xf000ff53	0xf000e2c3	0xf000ff53
0x10:	0xf000ff53	0xf000ff53	0xf000ff53	0xf000ff53
0x20:	0xf000fea5	0xf000e987	0xf000d62c	0xf000d62c
0x30:	0xf000d62c	0xf000d62c	0xf000ef57	0xf000d62c
(qemu) xp/16x 0x0
0000000000000000: 0xf000ff53 0xf000ff53 0xf000e2c3 0xf000ff53
0000000000000010: 0xf000ff53 0xf000ff53 0xf000ff53 0xf000ff53
0000000000000020: 0xf000fea5 0xf000e987 0xf000d62c 0xf000d62c
0000000000000030: 0xf000d62c 0xf000d62c 0xf000ef57 0xf000d62c
```



```C
Question

1、Assuming that the following JOS kernel code is correct, what type should variable x have, uintptr_t or physaddr_t?
	mystery_t x;
	char* value = return_a_pointer();
	*value = 10;
	x = (mystery_t) value;
```

上面的描述中有一句

`The JOS kernel can dereference a uintptr_t by first casting it to a pointer type. In contrast, the kernel can't sensibly dereference a physical address, since the MMU translates all memory references. If you cast a `physaddr_t` to a pointer and dereference it, you may be able to load and store to the resulting address (the hardware will interpret it as a virtual address), but you probably won't get the memory location you intended.`

JOS内核可以通过通过将一个uintptr_t类型的数据转换成指针类型即可废弃掉，而废弃physaddr_t类型则需要加载和存储结果的地址，最后得到的结果的内存地址和设想的也可能不一样，而题目中假设是内核中正确的代码，最后`x = (mystery_t) value;`只能是将虚拟地址类型强制转换成指针类型，所以`mystery_t`应该是`uintptr_t`



```C
Exercise 4. In the file kern/pmap.c, you must implement code for the following functions.

        pgdir_walk()
        boot_map_region()
        page_lookup()
        page_remove()
        page_insert()
	
check_page(), called from mem_init(), tests your page table management routines. You should make sure it reports success before proceeding.
```



### pgdir_walk()

`pte_t *pgdir_walk(pde_t *pgdir, const void *va, int create)`

打开`mmu.h`，可以找到宏`PDX`和`PTX`

```
// A linear address 'la' has a three-part structure as follows:
//
// +--------10------+-------10-------+---------12----------+
// | Page Directory |   Page Table   | Offset within Page  |
// |      Index     |      Index     |                     |
// +----------------+----------------+---------------------+
//  \--- PDX(la) --/ \--- PTX(la) --/ \---- PGOFF(la) ----/
//  \---------- PGNUM(la) ----------/
//
// The PDX, PTX, PGOFF, and PGNUM macros decompose linear addresses as shown.
// To construct a linear address la from PDX(la), PTX(la), and PGOFF(la),
// use PGADDR(PDX(la), PTX(la), PGOFF(la)).
```

PDX负责找到线性地址的page directory index，PTX负责找到线性地址的page table index

其中代码注释中提到`pgdir`代表page directory，所以通过pgdir以及PDX(va)即可找到page table的起始位置，然后根据PTX(va)即可找到我们所需要找的page的具体位置。

该函数就是要找到这个位置，返回这个位置之前我们还需要将所需的page与该位置对应，代码如下：

```C
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
	// Fill this function in
	uint32_t pdx = PDX(va);		//页目录项索引
	uint32_t ptx = PTX(va);		//页表项索引
	pte_t*   pte;				//页表项指针
	pde_t*	 pde; 				//页目录项指针
	struct PageInfo* pp;

	pde = &pgdir[pdx];			//获取页目录项

	if(*pde & PTE_P){
		//https://pdos.csail.mit.edu/6.828/2018/readings/i386/s05_02.htm
		//PTE的第0位P表示是否可用，为1表示可用
		//PTE_ADDR返回物理地址，KADDR转换为虚拟地址
		pte = (KADDR(PTE_ADDR(*pde)));
	}else{
		//二级页表不存在并且create == false
		if(!create){
			return NULL;
		}

		//可以自己创建则使用page_alloc
		if(!(pp = page_alloc(ALLOC_ZERO))){
			return NULL;
		}
		//the new page's reference count is incremented
		pp->pp_ref++;

		//目前page已经创建好了，还差的工作就是将这个page放置到当前的地址中去
		//或者说是把这page的地址和线性地址对应起来
		pte = (pte_t*)page2kva(pp);
		*pde = PADDR(pte) | PTE_P | PTE_W | PTE_U;
	}

	//返回page的虚拟地址
	return &pte[ptx];
}

```

### boot_map_region()

`static void boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)`

```C
//
// Map [va, va+size) of virtual address space to physical [pa, pa+size)
// in the page table rooted at pgdir.  Size is a multiple of PGSIZE, and
// va and pa are both page-aligned.
// Use permission bits perm|PTE_P for the entries.
//
// This function is only intended to set up the ``static'' mappings
// above UTOP. As such, it should *not* change the pp_ref field on the
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
```

该函数要将虚拟地址[va, va+size)和物理地址[pa, pa+size)进行对应，具体的做法就是通过page table进行对应，其中size是PGSIZE的倍数，并且va和pa都是向page对齐的

该函数只是将虚拟地址和物理地址一一对应的，没有将page分配出去，所以不要改变pp_ref

代码如下：

```C
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
	// Fill this function in

	// 题目中说size是PGSIZE的倍数，但在实际应用中并不能完全保证
	// for(uintptr_t end = va + size; va != end; va += PGSIZE, pa += PGSIZE){
	// 	pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
	// 	*pte = pa | perm | PTE_P;
	// }
	size_t pgs = (size + PGSIZE - 1) / PGSIZE;
	for(size_t i = 0; i < pgs; i++){
		pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
		*pte = pa | PTE_P | perm;
		va += PGSIZE;
		pa += PGSIZE;
	}
}
```

### page_lookup()

`struct PageInfo * page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)`

```C
//
// Return the page mapped at virtual address 'va'.
// If pte_store is not zero, then we store in it the address
// of the pte for this page.  This is used by page_remove and
// can be used to verify page permissions for syscall arguments,
// but should not be used by most callers.
//
// Return NULL if there is no page mapped at va.
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
```

该函数要求返回虚拟地址va所对应的物理地址上的page，其中如果pte_store非0，则将该页的地址存储到pte_store处

如果va处没有对应的page，则返回NULL

提示可以使用pgdir_walk，而虚拟地址可能没有对应的page，所以pgdir_walk的create参数应该是false

```C
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
	// Fill this function in
	//Return NULL if there is no page mapped at va.
	//所以此处create参数应该为false;
	pte_t* pte = pgdir_walk(pgdir, va, false);
	if(!pte || !(*pte & PTE_P)){
		return NULL;
	}
    
    // If pte_store is not zero, then we store in it the address
	// of the pte for this page
	if(pte_store != 0){
		*pte_store = pte;
	}
	//https://pdos.csail.mit.edu/6.828/2018/readings/i386/s05_02.htm
	//The page frame address specifies the physical starting address of a page. 
	//Because pages are located on 4K boundaries, 
	//the low-order 12 bits are always zero.

	//而我们的*pte中存储的内容可以参考pgdir_walk
	//地位存储着不同的权限信息，如PTE_P PTE_U等，
	//当我们需要物理地址时，则需要将这些权限信息去掉
	//mmu.h
	//#define PTE_ADDR(pte)	((physaddr_t) (pte) & ~0xFFF)
	return pa2page(PTE_ADDR(*pte));
}
```

### page_remove()

`void page_remove(pde_t *pgdir, void *va)`

```C
//
// Unmaps the physical page at virtual address 'va'.
// If there is no physical page at that address, silently does nothing.
//
// Details:
//   - The ref count on the physical page should decrement.
//   - The physical page should be freed if the refcount reaches 0.
//   - The pg table entry corresponding to 'va' should be set to 0.
//     (if such a PTE exists)
//   - The TLB must be invalidated if you remove an entry from
//     the page table.
//
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
```

该函数目的为了将虚拟地址va与其对应的page解除绑定，当然页存在根本就没有对应的page的情况

有以下几点细节：

- 对应物理页的pp_ref需要减一
- 物理页的pp_ref如果为0，则需要标记为free
- 和va相关的pte需要变为0
- 如果从page table中移除了某个entry，则必须将TLB置为无效



```C
//
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
```

根据提示，tlb_invalidate直接使用即可，然后看page_decref函数

```C
void
page_decref(struct PageInfo* pp)
{
	if (--pp->pp_ref == 0)
		page_free(pp);
}
```

可以发现这个函数就是在做我们前面细节中提到的前两点，pp_ref减一以及pp_ref为0后应该做的操作



代码如下:

```C
void
page_remove(pde_t *pgdir, void *va)
{
	// Fill this function in
	pte_t* pte;
	PageInfo* pp = page_lookup(pgdir, va, &pte);

	//If there is no physical page at that address, silently does nothing.
	//   - The ref count on the physical page should decrement.
	//   - The physical page should be freed if the refcount reaches 0.
	if(pp){
		page_decref(pp);
		//   - The pg table entry corresponding to 'va' should be set to 0.
		//     (if such a PTE exists)
		*pte = 0;
		//   - The TLB must be invalidated if you remove an entry from
		//     the page table.
		tlb_invalidate(pgdir, va);
	}
}
```



### page_insert()

`int page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)`

```C
//
// Map the physical page 'pp' at virtual address 'va'.
// The permissions (the low 12 bits) of the page table entry
// should be set to 'perm|PTE_P'.
//
// Requirements
//   - If there is already a page mapped at 'va', it should be page_remove()d.
//   - If necessary, on demand, a page table should be allocated and inserted
//     into 'pgdir'.
//   - pp->pp_ref should be incremented if the insertion succeeds.
//   - The TLB must be invalidated if a page was formerly present at 'va'.
//
// Corner-case hint: Make sure to consider what happens when the same
// pp is re-inserted at the same virtual address in the same pgdir.
// However, try not to distinguish this case in your code, as this
// frequently leads to subtle bugs; there's an elegant way to handle
// everything in one code path.
//
// RETURNS:
//   0 on success
//   -E_NO_MEM, if page table couldn't be allocated
//
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
```



该函数将页(page)与虚拟地址va关联到一起，如果当前的虚拟地址已经和其他页(page)关联，则解除该关联，然后与本页(page)关联



```C
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
	// Fill this function in
	pte_t* pte = pgdir_walk(pgdir, va, true);
	//page table couldn't be allocated
	if(!pte){
		return -E_NO_MEM;
	}
	// 如果va对应的页面存在，使用page_remove
	// 并且对应的page->pp_ref--
	if(*pte * PTE_P){
		//考虑极端情况，要和va对应的page和当前和va对应的page是一个
		//题目要求不要频繁的对同一个页(page)进行操作
		//所以判断是否为同一个page，如果是则只修改pp->ref以及权限即可
		if(PTE_ADDR(*pte) == page2pa(pp)){
			pp->pp_ref--;
		}else{
			page_remove(pgdir, va);
		}
	}

	pp->ref++;
	*pte = page2pa(pp) | perm | PTE_P;

	return 0;
}
```



## 5、Part 3: Kernel Address Space

这部分主要讲虚拟地址空间分步

```C
/*
 * Virtual memory map:                                Permissions
 *                                                    kernel/user
 *
 *    4 Gig -------->  +------------------------------+
 *                     |                              | RW/--
 *                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *                     :              .               :
 *                     :              .               :
 *                     :              .               :
 *                     |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~| RW/--
 *                     |                              | RW/--
 *                     |   Remapped Physical Memory   | RW/--
 *                     |                              | RW/--
 *    KERNBASE, ---->  +------------------------------+ 0xf0000000      --+
 *    KSTACKTOP        |     CPU0's Kernel Stack      | RW/--  KSTKSIZE   |
 *                     | - - - - - - - - - - - - - - -|                   |
 *                     |      Invalid Memory (*)      | --/--  KSTKGAP    |
 *                     +------------------------------+                   |
 *                     |     CPU1's Kernel Stack      | RW/--  KSTKSIZE   |
 *                     | - - - - - - - - - - - - - - -|                 PTSIZE
 *                     |      Invalid Memory (*)      | --/--  KSTKGAP    |
 *                     +------------------------------+                   |
 *                     :              .               :                   |
 *                     :              .               :                   |
 *    MMIOLIM ------>  +------------------------------+ 0xefc00000      --+
 *                     |       Memory-mapped I/O      | RW/--  PTSIZE
 * ULIM, MMIOBASE -->  +------------------------------+ 0xef800000
 *                     |  Cur. Page Table (User R-)   | R-/R-  PTSIZE
 *    UVPT      ---->  +------------------------------+ 0xef400000
 *                     |          RO PAGES            | R-/R-  PTSIZE
 *    UPAGES    ---->  +------------------------------+ 0xef000000
 *                     |           RO ENVS            | R-/R-  PTSIZE
 * UTOP,UENVS ------>  +------------------------------+ 0xeec00000
 * UXSTACKTOP -/       |     User Exception Stack     | RW/RW  PGSIZE
 *                     +------------------------------+ 0xeebff000
 *                     |       Empty Memory (*)       | --/--  PGSIZE
 *    USTACKTOP  --->  +------------------------------+ 0xeebfe000
 *                     |      Normal User Stack       | RW/RW  PGSIZE
 *                     +------------------------------+ 0xeebfd000
 *                     |                              |
 *                     |                              |
 *                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *                     .                              .
 *                     .                              .
 *                     .                              .
 *                     |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
 *                     |     Program Data & Heap      |
 *    UTEXT -------->  +------------------------------+ 0x00800000
 *    PFTEMP ------->  |       Empty Memory (*)       |        PTSIZE
 *                     |                              |
 *    UTEMP -------->  +------------------------------+ 0x00400000      --+
 *                     |       Empty Memory (*)       |                   |
 *                     | - - - - - - - - - - - - - - -|                   |
 *                     |  User STAB Data (optional)   |                 PTSIZE
 *    USTABDATA ---->  +------------------------------+ 0x00200000        |
 *                     |       Empty Memory (*)       |                   |
 *    0 ------------>  +------------------------------+                 --+
 *
 * (*) Note: The kernel ensures that "Invalid Memory" is *never* mapped.
 *     "Empty Memory" is normally unmapped, but user programs may map pages
 *     there if desired.  JOS user programs map pages temporarily at UTEMP.
 */

```



```
Exercise 5. Fill in the missing code in mem_init() after the call to check_page().

Your code should now pass the check_kern_pgdir() and check_page_installed_pgdir() checks.
```

我们需要完成`mem_init()`函数后面部分的内容，这部分主要的作用是初始化虚拟内存

### mem_init()

首先是将前面申请的pages数组对应到虚拟地址UPAGES上面

**Note:此处有一个问题，boot_map_region函数的perm参数是根据什么设定的？我没有找到参考资料，只能照抄照搬了**

```C
	//////////////////////////////////////////////////////////////////////
	// Now we set up virtual memory

	//////////////////////////////////////////////////////////////////////
	// Map 'pages' read-only by the user at linear address UPAGES
	// Permissions:
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
	// 注意pages是mem_init函数里面自己定义的page数组的起始地址
	// pages是虚拟地址，boot_map_region要求输入物理地址
	// boot_map_region函数会自动给pte赋予PTE_P
	// 所以最后一个参数只需要填写PTE_U即可
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
```



然后初始化栈区

```C
	//////////////////////////////////////////////////////////////////////
	// Use the physical memory that 'bootstack' refers to as the kernel
	// stack.  The kernel stack grows down from virtual address KSTACKTOP.
	// We consider the entire range from [KSTACKTOP-PTSIZE, KSTACKTOP)
	// to be the kernel stack, but break this into two pieces:
	//     * [KSTACKTOP-KSTKSIZE, KSTACKTOP) -- backed by physical memory
	//     * [KSTACKTOP-PTSIZE, KSTACKTOP-KSTKSIZE) -- not backed; so if
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);

```



最后将所有的物理内存从0开始的位置都与虚拟地址对应

```C
	//////////////////////////////////////////////////////////////////////
	// Map all of physical memory at KERNBASE.
	// Ie.  the VA range [KERNBASE, 2^32) should map to
	//      the PA range [0, 2^32 - KERNBASE)
	// We might not have 2^32 - KERNBASE bytes of physical memory, but
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:
	boot_map_region(kern_pgdir, KERNBASE, 0xffffffff - KERNBASE, 0, PTE_W);

```



### Question

question 1为前面的mystery_t的问题

2、What entries (rows) in the page directory have been filled in at this point? What addresses do they map and where do they point? In other words, fill out this table as much as possible:

| Entry | Base Virtual Address  | Points to (Logically)                      |
| ----- | --------------------- | ------------------------------------------ |
| 1023  | 0xFFC0_0000           | Page table for [252, 256)MB of phys memory |
| 1022  | 0xFFF0_0000           | Page table for [248, 252)MB of phys memory |
| ...   | ...                   | ...                                        |
| 961   | 0xF040_0000           | Page table [4MB - 8MB) of phys memory      |
| 960   | KERNBASE(0xF000_0000) | Page table [0 - 4MB) of phys memory        |
| 959   | MMIOLIM(0xEFC0_0000)  | STACK                                      |
| 958   | ULIM(0xEF80_0000)     |                                            |
| ...   | ...                   | ...                                        |
| 3     | 0x0080_0000           |                                            |
| 2     | 0x0040_0000           |                                            |
| 1     | 0x0000_0000           |                                            |

32位虚拟地址被分为三部分，分别为：

```C
//
// +--------10------+-------10-------+---------12----------+
// | Page Directory |   Page Table   | Offset within Page  |
// |      Index     |      Index     |                     |
// +----------------+----------------+---------------------+
//  \--- PDX(la) --/ \--- PTX(la) --/ \---- PGOFF(la) ----/
//  \---------- PGNUM(la) ----------/
//
```

前10位代表一个页面，一共有1024个目录项，对应表格中的0-1023项，每个页面有1024个页表目录，每个页表目录有$$2^{12}$$项数据，所以每个页面能代表的大小为$$2^{10 + 12} = 2^{22}$$，所以每个entry之间的间距为0x0040_0000

内核的大小为256MB，表格第一行提到每个entry代表4MB内容，所以一共有64个entry负责记录内核，即960-1023，剩余的内容参考`memlayout.h`即可得出结论

3、We have placed the kernel and user environment in the same address space. Why will user programs not be able to read or write the kernel's memory? What specific mechanisms protect the kernel memory?

页(page)的物理地址要向PGSIZE对齐，所以其低12位为0，所以在设置pte时可以利用这低12位给页(page)赋予访问权限，如果没有设置PTE_U则用户无写读权限。所以我们在提取物理地址时需要使用`PTE_ADDR`

`#define PTE_ADDR(pte)   ((physaddr_t) (pte) & ~0xFFF)`

4、What is the maximum amount of physical memory that this operating system can support? Why?

所有的空闲物理页最开始都存储在pages数组中，即struct PageInfo，每个PageInfo占8字节的内存，而JOS为Page分配了1PTSIZE字节的空间，共计4096  * 1024bytes大小，4096  * 1024  / 8 = $$2^{19}$$，即最多有$$2^{19}$$个页，每个页的大小为4096字节，所以最多的内存容量为

$$2^{19} \times 4096 = 4GB$$

5、How much space overhead is there for managing memory, if we actually had the maximum amount of physical memory? How is this overhead broken down?

根据上一个问题，我们有$$2^{19}$$个页，每个页都需要一条32位的数据记录，所以一共需要$$2^{19} \times 32 = 2^{24}bits = 2MB$$，前面是PTE的数据，我们还需要4K的内存存储PDE，所以一共需要2MB+4KB的内存

6、Revisit the page table setup in `kern/entry.S` and `kern/entrypgdir.c`. Immediately after we turn on paging, EIP is still a low number (a little over 1MB). At what point do we transition to running at an EIP above KERNBASE? What makes it possible for us to continue executing at a low EIP between when we enable paging and when we begin running at an EIP above KERNBASE? Why is this transition necessary?

cr3寄存器负责存储下一个运行进程的页表地址

```
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
	# Turn on paging.
	movl	%cr0, %eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
	movl	%eax, %cr0
```

可以看到，JOS更新了cr3寄存器的内容，然后转换到分页(paging)模式

接下来

```
mov	$relocated, %eax
	jmp	*%eax
```

$relocated的位置已经在KENRBASE之上了，此时就跳转到高地址运行了



那么，既然已经开启了paging模式，为什么还可以在低地址运行呢(mov 和 jmp指令都是在低地址)，打开entrypgdir.c

```C
__attribute__((__aligned__(PGSIZE)))
pde_t entry_pgdir[NPDENTRIES] = {
	// Map VA's [0, 4MB) to PA's [0, 4MB)
	[0]
		= ((uintptr_t)entry_pgtable - KERNBASE) + PTE_P,
	// Map VA's [KERNBASE, KERNBASE+4MB) to PA's [0, 4MB)
	[KERNBASE>>PDXSHIFT]
		= ((uintptr_t)entry_pgtable - KERNBASE) + PTE_P + PTE_W
};
```

可以看到此处做了两个映射，将虚拟地址[0,4M)映射到物理地址[0,4M)，以及虚拟地址[KERNBASE, KERNBASE+4MB)映射到物理地址[0,4M)上面。



## 6、Challenge

有机会再来挑战！
