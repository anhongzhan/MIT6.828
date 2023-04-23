# Lab 6: Network Driver (default final project)

网卡驱动不足以让我们的操作系统连接到互联网。在最新的lab6的代码中，我们提供了一个网络栈和一个网络服务器。其具体内容在`/net`文件夹中，`/kern`文件夹中也有文件更新。



除了写驱动外，我们也需要为驱动提供一个系统调用的接口。我们需要实现在网络栈和驱动之间传入包所缺失的代码。我们也需要实现一个web服务器将所有的东西整合到一起。使用新的web服务器，我么将能够serve files from your file system



大部分内核设备驱动程序代码都必须从头开始编写。与前面的实验相比，本实验提供的指导要少很多：没有框架文件，没有一成不变的系统调用接口，需要设计决策要留给自己。



## 1、QEMU's virtual network

我们会使用QEMU的用户模式网络栈因为它不需要管理员权限运行。我们已经更新了makefile使QEMU用户模式网络栈和虚拟E1000网卡可用。



默认情况下，QEMU提供一个虚拟路径，IP地址为10.0.2.2并且给JOS分配一个IP地址10.0.2.15。为了保证简单，我们在`net/ns.h`中将这些内容硬编码进去了。



当QEMU虚拟网络允许JOS随意地链接互联网时，JOS的IP地址10.0.2.15在QEMU意外的虚拟网络中没有意义（也就是说，QEMU使用了类似NAT网络）。因此我们不能直接在JOS内部链接服务器，即使是从QEMU的host地址也不行。为了能够访问到外部，我们将QEMU配置为在主机上的某个端口上运行的服务器，该服务器仅通过连接到JOS中的某个端口，并在真实主机和虚拟网络之间来回传输数据。



我们要在端口7(echo)和端口80(http)运行JOS。为了防止共享Athena machines中冲突，makefile根据我们的用户ID为这些端口生成了对应的转发端口。运行`make chich-posts`可以找到相应的端口映射到哪些端口上了。更多的细节可以运行`make nc-7`以及`make nc-80`。

它允许你直接与终端中运行的端口上的服务器进行交互。



### 1.1、Packet Inspection

makefile也配置QEMU的网络栈来记录所有传入和传输数据包，具体内容记录在qemu.pcap中

使用`tcpdump -XXnr qemu.pcap`可以得到被捕获的包的二进制ASCII码的转储

同样，也可以用wireshark直接获取pcap文件。



### 1.2、Debugging the E1000

我们非常幸运地使用虚拟硬件。因为E1000运行在软件上，虚拟的E1000可以向我们报告它内部状态和遇到的任何问题。通常，对于使用逻辑编写驱动程序的开发人员来说，这种情况是非常奢侈的。



E1000可以产生大量的调试输出，因此必须启动特定的日志通道。你可能会发现一些有用的渠道：

| Flag      | Meaning                                            |
| --------- | -------------------------------------------------- |
| tx        | Log packet transmit operations                     |
| txerr     | Log transmit ring errors                           |
| rx        | Log changes to RCTL                                |
| rxfilter  | Log filtering of incoming packets                  |
| rxerr     | Log receive ring errors                            |
| unknown   | Log reads and writes of unknown registers          |
| eeprom    | Log reads from the EEPROM                          |
| interrupt | Log interrupts and changes to interrupt registers. |



为了使`tx`和`txerr`日志可用，可以使用`make E1000_DEBUG=tx, txerr`

注意：**E1000_DEBUG标志仅在6.828版本的QEMU中可用**



你可以进一步使用软件来模拟硬件进行调试。如果你曾经卡住并且不理解为什么E1000没有按照你期望的方式相应，你可以查看QEMU在hw/net/e1000.c中E1000的实现。



## 2、The Network Server

从头写一个网络栈是一项艰难的工作。作为替代，我们要使用IwIP，一款轻量级TCP/IP协议套件，其中就包含一个网络栈。本次实验中，IwIP就是一个实现BSD套接字接口，并具有包输入输出端口的黑盒。



网络服务器实际上是以下四个进程的组合

- core network server environment (includes socket call dispatcher and lwIP)
- input environment
- output environment
- timer environment



下图展示了进程之间的不同与联系。该图片展示了包括设备驱动的整个系统。本次实验中，我们要实现高亮为绿色的部分。

![ns](F:\MIT6828\note\06Lab6\ns.png)



### 2.1、The Core Network Server Environment

内核网络服务器进程包括socket call dispatcher和IwIP本身。socket call dispatcher像文件服务器一样工作。用户进程使用stubs(lib/nsipc.c)向核心网络进程发送IPC。如果你看lib/nsipc.c，你就会发现我们使用和文件服务器一样的方法去寻找核心网络服务器：i386_init使用NS_TYPE_NS创建NS进程，因此我们扫描envs，寻找这个特殊的进程类型。对于每个用户进程IPC，网络服务器中的调度程序代表用户调用IwIP提供的适当的BSD套接字接口函数。



常规的用户进程不会直接使用nsipc_*调用。相反，他们使用lib/socket.c中的函数，该函数提供一个基于文件描述符的socket API。因此，用户进程通过文件描述符引用套接字，就像他们引用磁盘上的文件一样。许多操作(connect、accept等)都是特定于套接字的，但是read、write和close都要经过lib/fd.c中普通的文件描述符设备调度代码。就像文件服务器为所有打开的文件维护唯一的内部ID一样，IwIP也为所有打开的套接字生成唯一ID。在文件服务器和网络服务器中，我们都使用存储在结构体Fd中的信息将每个环境的文件描述符映射到这些唯一的ID空间。



尽管文件服务器和网络服务器的IPC调度程序看起来是一样的，但有一个关键区别。像accept和recv这样的BSD套接字调用可以无限期地阻塞。如果调度程序让IwIP执行这些阻塞调用中的一个，那么调度程序也会阻塞，并且整个系统一次只能有一个未完成的网络调用。由于这是不可接受的，因此网络服务器使用用户级线程来避免阻塞整个服务器环境。对于每个传入的IPC消息，调度程序创建一个线程，并在新创建的线程中处理请求。如果线程阻塞，则只有该线程进入睡眠状态，而其他线程继续运行。



除了核心网络环境之外，还有三种辅助环境。除了接受来自用户应用程序的消息外，核心网络环境的调度程序还接受来自输入和计时器环境的消息。



### 2.2、The Output Environment

当服务用户环境套接字调用时，IwIP将生成数据包供网卡传输。LwIP将使用NSREQ_OUTPUT IPC消息将每个要传输的数据包发送到输出助手进程，并将数据包附加在IPC消息的page参数中。输出进程负责接收这些信息并且通过我们将要实现的系统调用接口将这些包传输到设备驱动上。



### 2.3、The Input Environment

被网卡接受的包需要被注入到IwIP。对于每一个被设备驱动接收的包，输入进程将包拉出内核空间然后使用NSREQ_INPUT IPC信息将包发送到核心服务进程。



数据包输入功能与核心网络环境分离，因为JOS很难同时接受IPC消息并轮询或等待来自设备驱动程序的数据包。我们没有可选择的系统调用去允许进程监听不同的输入资源去识别哪个输入准备好进行了。



如果你看`net/input.c`和`net/output.c`，你会发现他们都需要被实现。这主要是因为实现取决于你的系统调用接口。在你实现驱动和系统调用接口之后，你需要写代码去实现两个helper environment。



### 2.4、The Timer Environment

定时器进程定时向核心网服务器发送类型为NSREQ_TIMER的定时器超时消息。lwIP使用来自该线程的计时器消息来实现各种网络超时。



## 3、Part A: Initialization and transmitting packets

我们的内核没有时间的概念，因此我们需要添加它。有一个硬件产生的10ms触发一次的时钟中断。每次时钟中断我们可以自增一个变量来表示时间增加了10ms。这部分内容在`keen/time.c`中实现，但是还没有嵌入到你的内核中



**Exercise 1.** Add a call to `time_tick` for every clock interrupt in `kern/trap.c`. Implement `sys_time_msec` and add it to `syscall` in `kern/syscall.c` so that user space has access to the time.



#### trap_dispatch

首先在`kern/trap.c`中添加time_tick的调用，IRQ_OFFSET + IRQ_TIMER是时钟中断的trap号

```C
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
		//IRQ_OFFSET + IRQ_TIMER是时钟中断的trap号
		time_tick();
		lapic_eoi();
		sched_yield();
		return ;
	}

	// Add time tick increment to clock interrupts.
	// Be careful! In multiprocessors, clock interrupts are
	// triggered on every CPU.
	// LAB 6: Your code here.
```



#### sys_time_msec

```C
// Return the current time.
static int
sys_time_msec(void)
{
	// LAB 6: Your code here.
	//panic("sys_time_msec not implemented");
	return (int)time_msec();
}
```



`kern/time.c`中的函数time_msec()返回当前的时间

```C
void
time_tick(void)
{
	ticks++;
	if (ticks * 10 < ticks)
		panic("time_tick: time overflowed");
}

unsigned int
time_msec(void)
{
	return ticks * 10;
}
```

由于ticks是unsigned int类型，我们也可以看一下time_tick的实现原理，ticks * 10 < ticks说明此时ticks已经到了unsigned int的最大值出，由于数据类型的原因增加十倍之后反而变小了。



#### syscall

最后添加调用

```C
		case SYS_time_msec:
			return sys_time_msec();
```



### 3.1、The Network Interface Card

编写驱动程序需要深入了解硬件和提供给软件的接口。实验文本将提供如何与E1000接口互动，但您需要在编写驱动程序时广泛地使用Intel手册



**Exercise 2.** Browse Intel's [Software Developer's Manual](https://pdos.csail.mit.edu/6.828/2018/readings/hardware/8254x_GBe_SDM.pdf) for the E1000. This manual covers several closely related Ethernet controllers. QEMU emulates the 82540EM.

You should skim over chapter 2 now to get a feel for the device. To write your driver, you'll need to be familiar with chapters 3 and 14, as well as 4.1 (though not 4.1's subsections). You'll also need to use chapter 13 as reference. The other chapters mostly cover components of the E1000 that your driver won't have to interact with. Don't worry about the details right now; just get a feel for how the document is structured so you can find things later.

While reading the manual, keep in mind that the E1000 is a sophisticated device with many advanced features. A working E1000 driver only needs a fraction of the features and interfaces that the NIC provides. Think carefully about the easiest way to interface with the card. We strongly recommend that you get a basic driver working before taking advantage of the advanced features.



### 3.2、PCI Interface

E1000是一个PCI设备，也就是说它通过主板连接到PCI总线上。PCI总线包括地址、数据和中断线，并且允许CPU与PCI设备通信以及PCI设备读写内存。PCI设备在使用之前需要被发现和初始化。发现是通过遍历PCI总线寻找相应的设备，初始化是分配IO和内存空间，以及协商给设备使用的IRQ(Interrupt ReQuest)



`kern/pci.c`中已经提供了PCI的代码。为了在boot期间初始化执行PCI初始化，PCI代码遍历PCI总线寻找设备。当他发现设备时，读取设备的vendor ID以及device ID，然后使用这两个值作为key去搜索`pci_array_vendor`数组。该数组由`struct pci_driver`组成

```C
struct pci_driver {
    uint32_t key1, key2;
    int (*attachfn) (struct pci_func *pcif);
};
```

如果被发现的设备vendor ID和device ID匹配到了数组中的一项，PCI代码调用该项的`attachfn`去展开设备初始化。



attach function通过一个PCI function去初始化。PCI卡可以暴漏很多功能，但是E1000仅暴漏一个。下面是JOS如何表示一个PCI函数：

```C
struct pci_func {
    struct pci_bus *bus;

    uint32_t dev;
    uint32_t func;

    uint32_t dev_id;
    uint32_t dev_class;

    uint32_t reg_base[6];
    uint32_t reg_size[6];
    uint8_t irq_line;
};
```



上述结构反映了开发手册地4.1节中的表4-1中的一些条目。`struct pci_func`的最后三项是我们尤其感兴趣的，分别表示他们记录的协商内存、IO以及中断资源。`reg_base`和`reg_size`数组包含之多六个Base Address Register(BARs)。`reg_base`存储内存映射区域的基地址，`reg_size`存储字节数的大小或者来自reg_base的IO端口的相关基础数据。`irq_line`包含为中断分配给设备的IRQ线。E1000 BARs的具体意义在表4-2的第二半部分。



当一个设备的attach function被调用时，设备已经被发现但是还不可用。这意味着PCI代码还没有确定分配给设备的资源，例如地址空间和IRQ线。也就是说`struct pci_func`的最后三项还没有被填入。attach function应该调用pci_func_enable，使设备可用，协商他们的资源，然后填入到`struct pci_func`中。



**Exercise 3.** Implement an attach function to initialize the E1000. Add an entry to the `pci_attach_vendor` array in `kern/pci.c` to trigger your function if a matching PCI device is found (be sure to put it before the `{0, 0, 0}` entry that mark the end of the table). You can find the vendor ID and device ID of the 82540EM that QEMU emulates in section 5.2. You should also see these listed when JOS scans the PCI bus while booting.

For now, just enable the E1000 device via `pci_func_enable`. We'll add more initialization throughout the lab.

We have provided the `kern/e1000.c` and `kern/e1000.h` files for you so that you do not need to mess with the build system. They are currently blank; you need to fill them in for this exercise. You may also need to include the `e1000.h` file in other places in the kernel.

When you boot your kernel, you should see it print that the PCI function of the E1000 card was enabled. Your code should now pass the `pci attach` test of make grade.



首先，查找用户手册的5.2节，可以发现，这里我们应该用Desktop对应的ID

| Stepping  | Vendor ID | Device ID | Description |
| --------- | --------- | --------- | ----------- |
| 82540EM-A | 8086h     | 100E      | Desktop     |
| 82540EM-A | 8086h     | 1015      | Mobile      |



题目中要求我们查找到两个ID之后填写这一部分，我们会发现他是一个pci_driver类型的数组

```C
struct pci_driver pci_attach_vendor[] = {
	{ 0, 0, 0 },
};
```

这个数据结构前面介绍过，第三部分是一个`int (*attachfn) (struct pci_func *pcif);`

当vendor ID和device ID匹配成功时，我们会调用attach function去初始化该设备。

**所以我们的目标就是要找到这个初始化函数**



练习3接下来告诉我们调用pci_func_enable使设备可用即可，再加上前面的介绍`当一个设备的attach function被调用时，设备已经被发现但是还不可用。`我们知道设备初始化函数需要调用这个函数，且根据练习3接下来的描述可知初始化函数需要写在e1000.h以及e1000.c中

~~说实话，这部分描述的感觉没啥逻辑，这个也是我阅读英文教程常见的问题（也有可能使我得问题），就感觉这部分根本就没讲清除具体要怎么办，看了好久都没有思路，整理出上面的内容是看了其他人的实现之后强行联系起来的！！！~~



#### e1000.h

需要使用pci.h中的pci_func_enable函数，所以需要include一下

```C
#include <kern/pci.h>

#define E1000_VENDER_ID_82540EM 0x8086
#define E1000_DEV_ID_82540EM 0x100E

int 
e1000_attachfn(struct pci_func *pcif);
```



#### e1000.c

```C
int
e1000_attachfn(struct pci_func *pcif)
{
	pci_func_enable(pcif);
	return 0;
}
```



#### pci.h

```C
// pci_attach_vendor matches the vendor ID and device ID of a PCI device. key1
// and key2 should be the vendor ID and device ID respectively
struct pci_driver pci_attach_vendor[] = {
	{ E1000_VENDER_ID_82540EM, E1000_DEV_ID_82540EM, &e1000_attachfn },
	{ 0, 0, 0 },
};
```



### 3.3、Memory-mapped I/O

软件通过memory-mapped I/O(mmio)与E1000通信。在JOS之前你已经看到这个两遍：CGA控制台和LAPIC都是通过写入和读取“内存”来控制和查询的设备。但是他们读写都不经过DRAM。他们直接访问设备。



pci_func_enable和E1000协商了一块MMIO并且尺寸大小存储在BAR 0(reg_base[0]以及reg_size[0])。这是分配给设备的物理内存的地址范围，意思是必须做些什么使得我们可以通过虚拟地址访问这块区域。由于MMIO区域被分配给非常高的物理内存（一般高于3G），我们不能使用KADDR去访问它（由于内核的2556MB限制）。因此，我们不得不创建一个新的内存映射。我们会使用MMIOBASE以上的区域。由于PCI设备初始化发生在JOS创建用户进程之前，我们可以在kern_pgdir中创建映射并且他会一直可用。



**Exercise 4.** In your attach function, create a virtual memory mapping for the E1000's BAR 0 by calling `mmio_map_region` (which you wrote in lab 4 to support memory-mapping the LAPIC).

You'll want to record the location of this mapping in a variable so you can later access the registers you just mapped. Take a look at the `lapic` variable in `kern/lapic.c` for an example of one way to do this. If you do use a pointer to the device register mapping, be sure to declare it `volatile`; otherwise, the compiler is allowed to cache values and reorder accesses to this memory.

To test your mapping, try printing out the device status register (section 13.4.2). This is a 4 byte register that starts at byte 8 of the register space. You should get `0x80080783`, which indicates a full duplex link is up at 1000 MB/s, among other things.



练习4要求我们在附加函数中添加映射，也就是在e1000.c中我们自创的函数，并且提到我们需要创建一个变量保存映射的位置，且参考`kern/lapic.c`中的lapic变量，并且使用volatile

```C
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;
```

我们创建一个类似于lapic的变量即可：



#### e1000.c

题目要求我们打印寄存器空间第8个字节开始的4字节内容

```C
volatile void *bar_va;

// LAB 6: Your driver code here
int
e1000_attachfn(struct pci_func *pcif)
{
	pci_func_enable(pcif);
	//Exercise4 create virtual memory mapping
	bar_va = mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
	uint32_t *status_reg = E1000REG(E1000_STATUS);
	assert(*status_reg == 0x80080783);
	return 0;
}
```



#### e1000.h

```C
#define E1000_DEVICE_STATUS 0x00008
```



![ds](F:\MIT6828\note\06Lab6\ds.PNG)



### 3.4、DMA

你可以想象通过读写E1000寄存器来进行数据发送和接收，但是这样会很慢，并且需要E1000缓存包数据。作为替代，E1000使用Direct Memory Access(DMA)不需要设计CPU直接读写内存。驱动负责为传输和接收队列分配内存，设置DMA描述符，然后使用这些队列的位置配置E1000，但之后的一切都是异步的。想要传输一个包，驱动将其复制到传输队列中的下一个DMA描述符中，并且通知E1000有另一个包可用。E1000会在传输包的时间讲数据复制出描述符。类似地，当E1000接收到一个包时，将包复制到接收队列中的下一个描述符，驱动下一次会将数据读出。



接收和传输队列非常类似，他们都包含一系列的描述符。虽然这些描述符的确切结构各不相同，但每个描述符都包含一些标志和包含数据包数据的缓冲区的物理地址。



队列时一个环形数组，意思是当个卡或者驱动到达队尾时，他会折回到队首去。两种队列都有头指针和尾指针，队列的内容时两个指针之间的描述符。硬件总是先消耗头部的描述符并且移动头指针，而驱动程序总是向尾部添加描述符并移动尾指针。传输队列中的描述符表示等待发送的包，接收队列中的描述符是card可以接收数据包的自由描述符。



指向这些数组的指针以及描述符中数据包缓冲区的地址必须都是物理地址，因为硬件直接在物理RAM之间执行DMA，而不需要经过MMU。



### 3.5、Transmitting Packets

E1000的传输和接收函数并不互相依赖，因此我们可以单独使一个进行工作。我们将首先攻击发送数据包，因为如果不先发送一个“I'm here”数据包，我们就无法测试接收。



首先，我们必须初始化传输card，遵守14.5节中描述的步骤。首先设置传输队列，队列的精确结构在3.4节中描述，描述符的结构在3.3.3节中描述。我们不使用E1000的TCP卸载特性，因此我们可以专注于“遗留传输描述符格式”。



### 3.5.1、C Structures

使用C的struct描述E1000非常方便。类似于我们已经用过的struct Trapframe，C struct可以精确地让你知道内存中的数据布局。C可以在字段之间插入填充，但是E1000的结构被布置成这样，应该不是问题。如果你遇到对齐问题，请查看GCC的“packed”属性。



下面是表3-8中描述的legacy transmit descriptor

```C
 63            48 47   40 39   32 31   24 23   16 15             0
  +---------------------------------------------------------------+
  |                         Buffer address                        |
  +---------------+-------+-------+-------+-------+---------------+
  |    Special    |  CSS  | Status|  Cmd  |  CSO  |    Length     |
  +---------------+-------+-------+-------+-------+---------------+
```



该结构的第一个字节在最右侧，所以将其转换成C struct需要从有到左，从上到下。如果你斜视它，你会发现所有的字段都适合一个标准大小的类型：

```C
struct tx_desc
{
	uint64_t addr;
	uint16_t length;
	uint8_t cso;
	uint8_t cmd;
	uint8_t status;
	uint8_t css;
	uint16_t special;
};
```



你的驱动必须为传输描述符数组和由传输描述符指向的数据包缓冲区保留内存。有很多种方式可以实现，从动态分配到简单地在全局变量中声明他们。无论选择什么，请记住E1000直接访问物理地址，这意味着它访问的任何缓冲区都必须在物理内存中是连续的。



也有其他的处理缓冲区的方式。最简单的，也是我们推荐的，就是在驱动程序初始化期间，为每个描述符保留一个包缓冲区的空间，并简单地将包数据复制到这些预分配的缓冲区中。以太网数据包最大大小是1518字节，这限制了缓冲区的大小。



**Exercise 5.** Perform the initialization steps described in section 14.5 (but not its subsections). Use section 13 as a reference for the registers the initialization process refers to and sections 3.3.3 and 3.4 for reference to the transmit descriptors and transmit descriptor array.

Be mindful of the alignment requirements on the transmit descriptor array and the restrictions on length of this array. Since TDLEN must be 128-byte aligned and each transmit descriptor is 16 bytes, your transmit descriptor array will need some multiple of 8 transmit descriptors. However, don't use more than 64 descriptors or our tests won't be able to test transmit ring overflow.

For the TCTL.COLD, you can assume full-duplex operation. For TIPG, refer to the default values described in table 13-77 of section 13.4.34 for the IEEE 802.3 standard IPG (don't use the values in the table in section 14.5).



说实话，知道大概的流程，但是完全不知道从哪开始！只能参考网上的实现了



首先打开操作手册14.5，其流程大致如下：

- 为transmit descriptor list分配一块内存区域。软件要保证内存16字节对齐。TDBAL/TDBAH寄存器存储该区域的地址，内存地址是64位，这俩寄存器32位，所以分别表示low和high，拼起来是64位
- 将循环数组的大小存储到Transmit Descriptor Length (TDLEN)寄存器中，以字节为单位
- 电源启动或者重置时，Transmit Descriptor Head and Tail (TDH/TDT)寄存器应该被设置为0
- 初始化Transmit Control Register (TCTL)，TCTL.EN = 1b，TCTL.PSP = 1b, TCTL.CT = 10h, TCTL.COLD = 40h(假设全双工)
- 使用下面二进制值编写 Transmit IPG (TIPG) register，去获得最小的legal Inter Packet Gap

![TIPG](F:\MIT6828\note\06Lab6\TIPG.PNG)





接下来查询第13节，找出寄存器的位置

| **category** | **Abbreviation** | offset |
| ------------ | ---------------- | ------ |
| Transmit     | TDBAL            | 03800h |
| Transmit     | TDBAH            | 03804h |
| Transmit     | TDLEN            | 03808h |
| Transmit     | TDH              | 03810h |
| Transmit     | TDT              | 03818h |
| Transmit     | TCTL             | 00400h |
| Transmit     | TIPG             | 00410h |



再然后，参考3.3.3节的transmit descriptor的结构，和前面的描述相同

```C
 63            48 47   40 39   32 31   24 23   16 15             0
  +---------------------------------------------------------------+
  |                         Buffer address                        |
  +---------------+-------+-------+-------+-------+---------------+
  |    Special    |  CSS  | Status|  Cmd  |  CSO  |    Length     |
  +---------------+-------+-------+-------+-------+---------------+
```



接下来是3.4节的transmit descriptor array的结构

![RT](F:\MIT6828\note\06Lab6\RT.PNG)

这里还详细介绍了一些寄存器的作用和大小：

![RTdetail](F:\MIT6828\note\06Lab6\RTdetail.PNG)



接下来开始写代码：

首先完成寄存器地址以及描述符的定义

#### e1000.h

```C
#define E1000_STATUS   0x00008  /* Device Status - RO */
#define E1000_TCTL     0x00400  /* TX Control - RW */
#define E1000_TIPG     0x00410  /* TX Inter-packet gap -RW */
#define E1000_TDBAL    0x03800  /* TX Descriptor Base Address Low - RW */
#define E1000_TDBAH    0x03804  /* TX Descriptor Base Address High - RW */
#define E1000_TDLEN    0x03808  /* TX Descriptor Length - RW */
#define E1000_TDH      0x03810  /* TX Descriptor Head - RW */
#define E1000_TDT      0x03818  /* TX Descripotr Tail - RW */
#define E1000_TXD_STAT_DD    0x00000001 /* Descriptor Done */
#define E1000_TXD_CMD_EOP    0x00000001 /* End of Packet */
#define E1000_TXD_CMD_RS     0x00000008 /* Report Status */

struct e1000_tx_desc
{
       uint64_t addr;
       uint16_t length;
       uint8_t cso;
       uint8_t cmd;
       uint8_t status;
       uint8_t css;
       uint16_t special;
}__attribute__((packed));

struct e1000_tdt {
       uint16_t tdt;
       uint16_t rsv;
};

struct e1000_tdlen {
       uint32_t zero: 7;
       uint32_t len:  13;
       uint32_t rsv:  12;
};

static void 
e1000_transmit_init();
```



#### e1000.c

```C
struct e1000_tdh *tdh;
struct e1000_tdt *tdt;
struct e1000_tx_desc tx_desc_array[TXDESCS];
char tx_buffer_array[TXDESCS][TX_PKT_SIZE];

//see section 14.5 in https://pdos.csail.mit.edu/6.828/2018/labs/lab6/e1000_hw.h
static void
e1000_transmit_init()
{
       int i;
       for (i = 0; i < TXDESCS; i++) {
               tx_desc_array[i].addr = PADDR(tx_buffer_array[i]);
               tx_desc_array[i].cmd = 0;
               tx_desc_array[i].status |= E1000_TXD_STAT_DD;
       }
			 //TDLEN register
       struct e1000_tdlen *tdlen = (struct e1000_tdlen *)E1000REG(E1000_TDLEN);
       tdlen->len = TXDESCS;
			 
			 //TDBAL register
       uint32_t *tdbal = (uint32_t *)E1000REG(E1000_TDBAL);
       *tdbal = PADDR(tx_desc_array);

			 //TDBAH regsiter
       uint32_t *tdbah = (uint32_t *)E1000REG(E1000_TDBAH);
       *tdbah = 0;

		   //TDH register, should be init 0
       tdh = (struct e1000_tdh *)E1000REG(E1000_TDH);
       tdh->tdh = 0;

		   //TDT register, should be init 0
       tdt = (struct e1000_tdt *)E1000REG(E1000_TDT);
       tdt->tdt = 0;

			 //TCTL register
       struct e1000_tctl *tctl = (struct e1000_tctl *)E1000REG(E1000_TCTL);
       tctl->en = 1;
       tctl->psp = 1;
       tctl->ct = 0x10;
       tctl->cold = 0x40;

			 //TIPG register
       struct e1000_tipg *tipg = (struct e1000_tipg *)E1000REG(E1000_TIPG);
       tipg->ipgt = 10;
       tipg->ipgr1 = 4;
       tipg->ipgr2 = 6;
}
```



最后将e1000_transmit_init()函数加入到e1000_attachfn()中：

```C
int
e1000_attachfn(struct pci_func *pcif)
{
	pci_func_enable(pcif);
	cprintf("reg_base:%x, reg_size:%x\n", pcif->reg_base[0], pcif->reg_size[0]);
			
	//Exercise4 create virtual memory mapping
	bar_va = mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
	
	uint32_t *status_reg = E1000REG(E1000_STATUS);
	assert(*status_reg == 0x80080783);

	e1000_transmit_init();
	return 0;
}
```



运行**make E1000_DEBUG=TXERR,TX qemu**，可以看到`e1000: tx disabled`



既然传输已经初始化完成，我们就不得不写代码传输一个包并且通过系统调用使其到达用户空间。为了传输一个包，我们必须要将其加入到传输队列尾部，也就是说要将包数据拷贝到下一个包buffer中，然后更新TDT(transmit descriptor tail)寄存器用来告诉card有另一个包进入了传输队列。



但是，传输队列只有这么大。如果card落后于包传输，并且传输队列已满，会发送什么情况？为了检测这种情况，我们需要从E1000得到一些反馈。不幸的是，我们不能使用TDH(transmit descriptor head)寄存器，文档中明确声明从软件中读取寄存器是不可靠的。但是，如果我们再传输描述符的cmd字段中设置RS位(Report Status)，那么，当card再该描述符中传输了数据包之后，card将在描述符的status字段中设置DD位(Descriptor Done)。如果设置了描述符的DD位，说明我们可以安全地回收该描述符并使用它传输另一个包。



如果用户使用了传输系统调用，但是下一个描述符的DD位没有被设置，说明传输队列已满，该怎么办？我们必须决定这种情况下应该怎么办。我们可以直接将packet扔掉。网络协议对此的弹性是有限的，如果我们丢弃大量的包，协议可能会无法恢复。我们也可以提示用户去重试，这样做的好处就是将问题回退给生成数据的环境。



**Exercise 6.** Write a function to transmit a packet by checking that the next descriptor is free, copying the packet data into the next descriptor, and updating TDT. Make sure you handle the transmit queue being full.



#### e1000.h

```C
int 
e1000_transmit(void *data, size_t len);
```



#### e1000.c

```C
int
e1000_transmit(void *data, size_t len)
{
       uint32_t current = tdt->tdt;		//tail index in queue
       if(!(tx_desc_array[current].status & E1000_TXD_STAT_DD)) {
               return -E_TRANSMIT_RETRY;
       }
       tx_desc_array[current].length = len;
       tx_desc_array[current].status &= ~E1000_TXD_STAT_DD;
       tx_desc_array[current].cmd |= (E1000_TXD_CMD_EOP | E1000_TXD_CMD_RS);
       memcpy(tx_buffer_array[current], data, len);
       uint32_t next = (current + 1) % TXDESCS;
       tdt->tdt = next;
       return 0;
}
```



**Exercise 7.** Add a system call that lets you transmit packets from user space. The exact interface is up to you. Don't forget to check any pointers passed to the kernel from user space.



#### lib.h

`inc/lib.h`中添加函数声明

```C
int sys_pkt_send(void *addr, size_t len);
```



#### kern/syscall.c

```C
int
sys_pkt_send(void *data, size_t len)
{
	return e1000_transmit(data, len);
}
```



添加case

```C
		case SYS_pkt_send:
			return sys_pkt_send((void *)a1, (size_t)a2);
```



#### inc/syscall.h

添加SYS_packet_try_send

```
enum {
	SYS_cputs = 0,
	SYS_cgetc,
	SYS_getenvid,
	SYS_env_destroy,
	SYS_page_alloc,
	SYS_page_map,
	SYS_page_unmap,
	SYS_exofork,
	SYS_env_set_status,
	SYS_env_set_trapframe,
	SYS_env_set_pgfault_upcall,
	SYS_yield,
	SYS_ipc_try_send,
	SYS_ipc_recv,
	SYS_time_msec,
	SYS_pkt_send,
	NSYSCALLS
};
```



### 3.6、Transmitting Packets: Network Server

我们的设备驱动成熟传输端已经有了一个系统调用接口，是时候发送数据包了。output helper environment的目标是在循环中执行以下操作:接受来自core network server的NSREQ_OUTPUT IPC消息，并使用上面添加的系统调用将伴随这些IPC消息的数据包发送到网络设备驱动程序。NSREQ_OUTPUT IPC由net/lwip/jos/jif/jif.c中的low_level_output函数发送，它将lwIP堆栈绑定到JOS的network system。每个IPC将包含一个页面，该页面由一个union Nsipc和它的struct jif_pkt pkt字段中的包组成(参见`inc/ns.h`)。



```C
struct jif_pkt {
    int jp_len;
    char jp_data[0];
};
```



jp_len表示数据包长度。IPC页面上的所有后续字节都专用于包内容(除了jp_len以外所有数据都是data)。结构的末尾使用jp_data[0]这样的零长度数组是一种常见的C语言技巧，用于表示缓冲区没有预先确定长度。由于C不做数组边界检查，只要确保结构后面有足够的未使用内存，就可以像使用任何大小的数组一样使用jp_data(这也太不安全了！！！)



当设备驱动程序的传输队列中没有更多空间时，要注意the device driver, the output environment and the core network server之间的交互。core network server使用IPC向output environment发送数据包。如果由于send packet系统调用而导致output environment挂起(suspended)，因为驱动程序没有更多的缓冲空间来容纳新包，那么core network server将阻塞，等待output environmnet接受IPC调用。



**Exercise 8.** Implement `net/output.c`.



#### output

```C
void
output(envid_t ns_envid)
{
	binaryname = "ns_output";

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
	uint32_t whom;
	int perm;
	int32_t req;

	while (1) {
		req = ipc_recv((envid_t *)&whom, &nsipcbuf,  &perm);     //接收核心网络进程发来的请求
		if (req != NSREQ_OUTPUT) {
			cprintf("not a nsreq output\n");
			continue;
		}

    	struct jif_pkt *pkt = &(nsipcbuf.pkt);
    	while (sys_pkt_send(pkt->jp_data, pkt->jp_len) < 0) {        //通过系统调用发送数据包
       		sys_yield();
    	}	
	}
}
```



运行`make E1000_DEBUG=TXERR,TX run-net_testoutput`之后，会出现

```C
ld: obj/net/output.o: in function `output':
net/output.c:18: undefined reference to `sys_packet_try_send'
```



#### sys_pkt_send

查找了一下发现，output.c引用了`inc/lib.h`，而`inc/lib.h`中定义的函数在`lib/syscall.c`中实现的

所以我们需要在`lib/syscall.c`中添加实现

```C
int
sys_pkt_send(void *data, size_t len)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
```



**注意添加到lib/syscall.c**中，而不是`kern/syscall.c`



运行`make grade`

![partA](F:\MIT6828\note\06Lab6\partA.PNG)



## 4、Part B: Receiving packets and the web server

### 4.1、Receiving Packets

就像我们传输包时所作的一样，我们必须配置E1000来接收数据包，并提供receive descriptor queue and receive descriptor。第3.2节描述包接收的工作原理，包括接收队列结构和接收描述符



**Exercise 9.** Read section 3.2. You can ignore anything about interrupts and checksum offloading (you can return to these sections if you decide to use these features later), and you don't have to be concerned with the details of thresholds and how the card's internal caches work.



receive queue和transmit queue非常相似，除了它由等待被传入的包填充的empty packet buffers组成。当网络空闲时，传输队列是空的，而接收队列是满的。



当E1000接收到一个数据包时，它首先检查它是否匹配card配置的过滤器，如果数据包不匹配任何过滤器，则忽略他。否则，E1000将尝试从接收队列的头部检索下一个接收描述符。如果头(RDH)赶上了尾(RDT)，那么接收队列就没有可用的描述符，因此卡将丢弃数据包。如果有一个空闲的接收描述符，它将包数据复制到描述符指向的缓冲区中，设置描述符的DD(Descriptor Done)和EOP(End of Packet) status bits，并增加RDH。

如果E1000在一个接收描述符中接收到一个大于packet buffer的包，它将从接收队列中检索尽可能多的描述符来存储包的全部内容。为了表明这已经发生，它将在所有这些描述符上设置DD状态位，但只在最后一个描述符上设置EOP status bit 。您可以在驱动程序中处理这种可能性，或者简单地将卡配置为不接受“long packets”(也称为巨型帧(jumbo frames))，并确保接收缓冲区足够大，可以存储尽可能大的standard Ethernet packet (1518字节)。





**Exercise 10.** Set up the receive queue and configure the E1000 by following the process in section 14.4. You don't have to support "long packets" or multicast. For now, don't configure the card to use interrupts; you can change that later if you decide to use receive interrupts. Also, configure the E1000 to strip the Ethernet CRC, since the grade script expects it to be stripped.

By default, the card will filter out *all* packets. You have to configure the Receive Address Registers (RAL and RAH) with the card's own MAC address in order to accept packets addressed to that card. You can simply hard-code QEMU's default MAC address of 52:54:00:12:34:56 (we already hard-code this in lwIP, so doing it here too doesn't make things any worse). Be very careful with the byte order; MAC addresses are written from lowest-order byte to highest-order byte, so 52:54:00:12 are the low-order 32 bits of the MAC address and 34:56 are the high-order 16 bits.

The E1000 only supports a specific set of receive buffer sizes (given in the description of RCTL.BSIZE in 13.4.22). If you make your receive packet buffers large enough and disable long packets, you won't have to worry about packets spanning multiple receive buffers. Also, remember that, just like for transmit, the receive queue and the packet buffers must be contiguous in physical memory.

You should use at least 128 receive descriptors



#### e1000.h

```C
static void 
e1000_receive_init();
```



#### e1000.c

```C
static void
e1000_receive_init()
{			 //RDBAL and RDBAH register
       uint32_t *rdbal = (uint32_t *)E1000REG(E1000_RDBAL);
       uint32_t *rdbah = (uint32_t *)E1000REG(E1000_RDBAH);
       *rdbal = PADDR(rx_desc_array);
       *rdbah = 0;

       int i;
       for (i = 0; i < RXDESCS; i++) {
               rx_desc_array[i].addr = PADDR(rx_buffer_array[i]);
       }
			 //RDLEN register
       struct e1000_rdlen *rdlen = (struct e1000_rdlen *)E1000REG(E1000_RDLEN);
       rdlen->len = RXDESCS;

			 //RDH and RDT register
       rdh = (struct e1000_rdh *)E1000REG(E1000_RDH);
       rdt = (struct e1000_rdt *)E1000REG(E1000_RDT);
       rdh->rdh = 0;
       rdt->rdt = RXDESCS-1;

       uint32_t *rctl = (uint32_t *)E1000REG(E1000_RCTL);
       *rctl = E1000_RCTL_EN | E1000_RCTL_BAM | E1000_RCTL_SECRC;

       uint32_t *ra = (uint32_t *)E1000REG(E1000_RA);
       uint32_t ral, rah;
       get_ra_address(E1000_MAC, &ral, &rah);
       ra[0] = ral;
       ra[1] = rah;
}
```



现在可以实现接收包了。要接收数据包，驱动程序必须跟踪下一个准备接收数据包的描述符(提示:根据您的设计，E1000中可能已经有一个寄存器记录了这一点)。与传输类似，文档声明RDH寄存器不能可靠地从软件中读取，因此，为了确定包是否已被发送到描述符的包缓冲区，您必须读取描述符中的DD状态位。如果设置了DD位，您可以从描述符的包缓冲区复制包数据，然后通过更新队列的尾部索引RDT告诉card描述符是空闲的。



如果没有设置了DD位的描述符，则没有收到包。这是接收端等效于传输队列已满时的情况，在这种情况下可以做几件事。



您可以简单地返回一个“try again”错误，并要求caller(要从接收队列拿数据的环境)重试。虽然这种方法适用于满的transmit queues ，因为这是一种瞬态条件，但是不适用于 receive queues，因为接收队列可能会在很长一段时间内保持空。



第二种方法是挂起调用环境，直到接收队列中有要处理的包为止。这个策略非常类似于sys_ipc_recv。就像在IPC中一样，因为每个CPU只有一个内核堆栈，所以一旦我们离开内核，堆栈上的状态就会丢失。我们需要设置一个标志，指示receive queue underflow已挂起一个环境，并记录系统调用参数。这种方法的缺点是复杂性:必须指示E1000生成接收中断，驱动程序必须处理这些中断，以便恢复阻塞的等待数据包的环境。



**Exercise 11.** Write a function to receive a packet from the E1000 and expose it to user space by adding a system call. Make sure you handle the receive queue being empty.



#### e1000.h

```C
struct e1000_rx_desc {
       uint64_t addr;
       uint16_t length;
       uint16_t chksum;
       uint8_t status;
       uint8_t errors;
       uint16_t special;
}__attribute__((packed));

int 
e1000_receive(void *addr, size_t *len);
```



#### e1000.c

```C
struct e1000_rdh *rdh;
struct e1000_rdt *rdt;
struct e1000_rx_desc rx_desc_array[RXDESCS];
char rx_buffer_array[RXDESCS][RX_PKT_SIZE];

int
e1000_receive(void *addr, size_t *len)
{
       static int32_t next = 0;
       if(!(rx_desc_array[next].status & E1000_RXD_STAT_DD)) {	//simply tell client to retry
               return -E_RECEIVE_RETRY;
       }
       if(rx_desc_array[next].errors) {
               cprintf("receive errors\n");
               return -E_RECEIVE_RETRY;
       }
       *len = rx_desc_array[next].length;
       memcpy(addr, rx_buffer_array[next], *len);

       rdt->rdt = (rdt->rdt + 1) % RXDESCS;
       next = (next + 1) % RXDESCS;
       return 0;
}
```



#### inc/lib.h

```C
int sys_pkt_recv(void *addr, size_t *len);
```



#### kern/syscall.c

```C
static int
sys_pkt_recv(void *addr, size_t *len)
{
	return e1000_receive(addr, len);
}
```



添加Case：

```C
		case SYS_pkt_recv:
			return sys_pkt_recv((void *)a1, (size_t *)a2);
```



#### inc/syscall.h

添加`SYS_pkt_recv`

```C
enum {
	SYS_cputs = 0,
	SYS_cgetc,
	SYS_getenvid,
	SYS_env_destroy,
	SYS_page_alloc,
	SYS_page_map,
	SYS_page_unmap,
	SYS_exofork,
	SYS_env_set_status,
	SYS_env_set_trapframe,
	SYS_env_set_pgfault_upcall,
	SYS_yield,
	SYS_ipc_try_send,
	SYS_ipc_recv,
	SYS_time_msec,
	SYS_pkt_send,
	SYS_pkt_recv,
	NSYSCALLS
};
```



#### lib/syscall.c

```C
int
sys_pkt_recv(void *addr, size_t *len)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
}
```



### 4.2、Receiving Packets: Network Server

在 network server input environment中，我们需要使用新的接收系统调用来接收数据包，并使用NSREQ_INPUT IPC消息将它们传递到 core network server environment。这些IPC输入消息应该有一个带有union Nsipc的页面，该页面的struct jif_pkt pkt字段由从网络接收到的包填充。



**Exercise 12.** Implement `net/input.c`.



#### input.c

```C
void
sleep(int msec)
{
       unsigned now = sys_time_msec();
       unsigned end = now + msec;

       if ((int)now < 0 && (int)now > -MAXERROR)
               panic("sys_time_msec: %e", (int)now);

       while (sys_time_msec() < end)
               sys_yield();
}

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";

	// LAB 6: Your code here:
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.

	size_t len;
	char buf[RX_PKT_SIZE];
	while (1) {
		if (sys_pkt_recv(buf, &len) < 0) {
			continue;
		}

		memcpy(nsipcbuf.pkt.jp_data, buf, len);
		nsipcbuf.pkt.jp_len = len;
		ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_U|PTE_W);
		sleep(50);
	}
}
```



### 4.3、The Web Server

最简单的web server发送一个文件的内容到需要的服务器中。在`user/httpd.c`中，我们提供了一个非常简单的web server的骨架代码。骨架代码处理输入链接和解析头部的功能。



**Exercise 13.** The web server is missing the code that deals with sending the contents of a file back to the client. Finish the web server by implementing `send_file` and `send_data`.



#### send_data

```C
static int
send_data(struct http_request *req, int fd)
{
	// LAB 6: Your code here.
	//panic("send_data not implemented");
	struct Stat stat;
	fstat(fd, &stat);
	void *buf = malloc(stat.st_size);
	//read from file
	if (readn(fd, buf, stat.st_size) != stat.st_size) {
		panic("Failed to read requested file");
	}

	//write to socket
  	if (write(req->sock, buf, stat.st_size) != stat.st_size) {
		panic("Failed to send bytes to client");
	}
	free(buf);
	return 0;
}
```



#### send_file

```C
// open the requested url for reading
	// if the file does not exist, send a 404 error using send_error
	// if the file is a directory, send a 404 error using send_error
	// set file_size to the size of the file

	// LAB 6: Your code here.
	//panic("send_file not implemented");
	if((fd = open(req->url, O_RDONLY)) < 0){
		send_error(req, 404);
		goto end;
	}

	struct Stat stat;
	fstat(fd, &stat);
	if (stat.st_isdir) {
		send_error(req, 404);
		goto end;
	}
```



运行`make grade`

![partB](F:\MIT6828\note\06Lab6\partB.PNG)
