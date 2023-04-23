
obj/fs/fs:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 42 1b 00 00       	call   801b73 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	f3 0f 1e fb          	endbr32 
  800063:	55                   	push   %ebp
  800064:	89 e5                	mov    %esp,%ebp
  800066:	53                   	push   %ebx
  800067:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	e8 bf ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800074:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800079:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007e:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007f:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800084:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800089:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  80008a:	a8 a1                	test   $0xa1,%al
  80008c:	74 0b                	je     800099 <ide_probe_disk1+0x3a>
	     x++)
  80008e:	83 c1 01             	add    $0x1,%ecx
	for (x = 0;
  800091:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800097:	75 f0                	jne    800089 <ide_probe_disk1+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800099:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009e:	ba f6 01 00 00       	mov    $0x1f6,%edx
  8000a3:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a4:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000aa:	0f 9e c3             	setle  %bl
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	0f b6 c3             	movzbl %bl,%eax
  8000b3:	50                   	push   %eax
  8000b4:	68 40 40 80 00       	push   $0x804040
  8000b9:	e8 04 1c 00 00       	call   801cc2 <cprintf>
	return (x < 1000);
}
  8000be:	89 d8                	mov    %ebx,%eax
  8000c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000c3:	c9                   	leave  
  8000c4:	c3                   	ret    

008000c5 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c5:	f3 0f 1e fb          	endbr32 
  8000c9:	55                   	push   %ebp
  8000ca:	89 e5                	mov    %esp,%ebp
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000d2:	83 f8 01             	cmp    $0x1,%eax
  8000d5:	77 07                	ja     8000de <ide_set_disk+0x19>
		panic("bad disk number");
	diskno = d;
  8000d7:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000dc:	c9                   	leave  
  8000dd:	c3                   	ret    
		panic("bad disk number");
  8000de:	83 ec 04             	sub    $0x4,%esp
  8000e1:	68 57 40 80 00       	push   $0x804057
  8000e6:	6a 3a                	push   $0x3a
  8000e8:	68 67 40 80 00       	push   $0x804067
  8000ed:	e8 e9 1a 00 00       	call   801bdb <_panic>

008000f2 <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000f2:	f3 0f 1e fb          	endbr32 
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	57                   	push   %edi
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  800102:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800105:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800108:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  80010e:	77 60                	ja     800170 <ide_read+0x7e>

	ide_wait_ready(0);
  800110:	b8 00 00 00 00       	mov    $0x0,%eax
  800115:	e8 19 ff ff ff       	call   800033 <ide_wait_ready>
  80011a:	ba f2 01 00 00       	mov    $0x1f2,%edx
  80011f:	89 f0                	mov    %esi,%eax
  800121:	ee                   	out    %al,(%dx)
  800122:	ba f3 01 00 00       	mov    $0x1f3,%edx
  800127:	89 f8                	mov    %edi,%eax
  800129:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  80012a:	89 f8                	mov    %edi,%eax
  80012c:	c1 e8 08             	shr    $0x8,%eax
  80012f:	ba f4 01 00 00       	mov    $0x1f4,%edx
  800134:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800135:	89 f8                	mov    %edi,%eax
  800137:	c1 e8 10             	shr    $0x10,%eax
  80013a:	ba f5 01 00 00       	mov    $0x1f5,%edx
  80013f:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800140:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800147:	c1 e0 04             	shl    $0x4,%eax
  80014a:	83 e0 10             	and    $0x10,%eax
  80014d:	c1 ef 18             	shr    $0x18,%edi
  800150:	83 e7 0f             	and    $0xf,%edi
  800153:	09 f8                	or     %edi,%eax
  800155:	83 c8 e0             	or     $0xffffffe0,%eax
  800158:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80015d:	ee                   	out    %al,(%dx)
  80015e:	b8 20 00 00 00       	mov    $0x20,%eax
  800163:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800168:	ee                   	out    %al,(%dx)
  800169:	c1 e6 09             	shl    $0x9,%esi
  80016c:	01 de                	add    %ebx,%esi
}
  80016e:	eb 2b                	jmp    80019b <ide_read+0xa9>
	assert(nsecs <= 256);
  800170:	68 70 40 80 00       	push   $0x804070
  800175:	68 7d 40 80 00       	push   $0x80407d
  80017a:	6a 44                	push   $0x44
  80017c:	68 67 40 80 00       	push   $0x804067
  800181:	e8 55 1a 00 00       	call   801bdb <_panic>
	asm volatile("cld\n\trepne\n\tinsl"
  800186:	89 df                	mov    %ebx,%edi
  800188:	b9 80 00 00 00       	mov    $0x80,%ecx
  80018d:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800192:	fc                   	cld    
  800193:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800195:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80019b:	39 f3                	cmp    %esi,%ebx
  80019d:	74 10                	je     8001af <ide_read+0xbd>
		if ((r = ide_wait_ready(1)) < 0)
  80019f:	b8 01 00 00 00       	mov    $0x1,%eax
  8001a4:	e8 8a fe ff ff       	call   800033 <ide_wait_ready>
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	79 d9                	jns    800186 <ide_read+0x94>
  8001ad:	eb 05                	jmp    8001b4 <ide_read+0xc2>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b7:	5b                   	pop    %ebx
  8001b8:	5e                   	pop    %esi
  8001b9:	5f                   	pop    %edi
  8001ba:	5d                   	pop    %ebp
  8001bb:	c3                   	ret    

008001bc <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001bc:	f3 0f 1e fb          	endbr32 
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8001cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001cf:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001d2:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001d8:	77 60                	ja     80023a <ide_write+0x7e>

	ide_wait_ready(0);
  8001da:	b8 00 00 00 00       	mov    $0x0,%eax
  8001df:	e8 4f fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001e4:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001e9:	89 f8                	mov    %edi,%eax
  8001eb:	ee                   	out    %al,(%dx)
  8001ec:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001f1:	89 f0                	mov    %esi,%eax
  8001f3:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001f4:	89 f0                	mov    %esi,%eax
  8001f6:	c1 e8 08             	shr    $0x8,%eax
  8001f9:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001fe:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001ff:	89 f0                	mov    %esi,%eax
  800201:	c1 e8 10             	shr    $0x10,%eax
  800204:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800209:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80020a:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800211:	c1 e0 04             	shl    $0x4,%eax
  800214:	83 e0 10             	and    $0x10,%eax
  800217:	c1 ee 18             	shr    $0x18,%esi
  80021a:	83 e6 0f             	and    $0xf,%esi
  80021d:	09 f0                	or     %esi,%eax
  80021f:	83 c8 e0             	or     $0xffffffe0,%eax
  800222:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800227:	ee                   	out    %al,(%dx)
  800228:	b8 30 00 00 00       	mov    $0x30,%eax
  80022d:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800232:	ee                   	out    %al,(%dx)
  800233:	c1 e7 09             	shl    $0x9,%edi
  800236:	01 df                	add    %ebx,%edi
}
  800238:	eb 2b                	jmp    800265 <ide_write+0xa9>
	assert(nsecs <= 256);
  80023a:	68 70 40 80 00       	push   $0x804070
  80023f:	68 7d 40 80 00       	push   $0x80407d
  800244:	6a 5d                	push   $0x5d
  800246:	68 67 40 80 00       	push   $0x804067
  80024b:	e8 8b 19 00 00       	call   801bdb <_panic>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800250:	89 de                	mov    %ebx,%esi
  800252:	b9 80 00 00 00       	mov    $0x80,%ecx
  800257:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80025c:	fc                   	cld    
  80025d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80025f:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800265:	39 fb                	cmp    %edi,%ebx
  800267:	74 10                	je     800279 <ide_write+0xbd>
		if ((r = ide_wait_ready(1)) < 0)
  800269:	b8 01 00 00 00       	mov    $0x1,%eax
  80026e:	e8 c0 fd ff ff       	call   800033 <ide_wait_ready>
  800273:	85 c0                	test   %eax,%eax
  800275:	79 d9                	jns    800250 <ide_write+0x94>
  800277:	eb 05                	jmp    80027e <ide_write+0xc2>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  800279:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80027e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800281:	5b                   	pop    %ebx
  800282:	5e                   	pop    %esi
  800283:	5f                   	pop    %edi
  800284:	5d                   	pop    %ebp
  800285:	c3                   	ret    

00800286 <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  800286:	f3 0f 1e fb          	endbr32 
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	57                   	push   %edi
  80028e:	56                   	push   %esi
  80028f:	53                   	push   %ebx
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800296:	8b 18                	mov    (%eax),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800298:	8d b3 00 00 00 f0    	lea    -0x10000000(%ebx),%esi
  80029e:	89 f7                	mov    %esi,%edi
  8002a0:	c1 ef 0c             	shr    $0xc,%edi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  8002a3:	81 fe ff ff ff bf    	cmp    $0xbfffffff,%esi
  8002a9:	0f 87 98 00 00 00    	ja     800347 <bc_pgfault+0xc1>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8002af:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8002b4:	85 c0                	test   %eax,%eax
  8002b6:	74 09                	je     8002c1 <bc_pgfault+0x3b>
  8002b8:	39 78 04             	cmp    %edi,0x4(%eax)
  8002bb:	0f 86 a1 00 00 00    	jbe    800362 <bc_pgfault+0xdc>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr = ROUNDDOWN(addr, PGSIZE);
  8002c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if((r = sys_page_alloc(0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	6a 07                	push   $0x7
  8002cc:	53                   	push   %ebx
  8002cd:	6a 00                	push   $0x0
  8002cf:	e8 3a 24 00 00       	call   80270e <sys_page_alloc>
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	85 c0                	test   %eax,%eax
  8002d9:	0f 88 95 00 00 00    	js     800374 <bc_pgfault+0xee>
		panic("in bc_pgfault, sys_page_alloc: %e\n", r);

	if((r = ide_read(blockno * BLKSIZE / SECTSIZE, addr, BLKSIZE / SECTSIZE)) < 0)
  8002df:	83 ec 04             	sub    $0x4,%esp
  8002e2:	6a 08                	push   $0x8
  8002e4:	53                   	push   %ebx
  8002e5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  8002eb:	c1 ee 09             	shr    $0x9,%esi
  8002ee:	56                   	push   %esi
  8002ef:	e8 fe fd ff ff       	call   8000f2 <ide_read>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	85 c0                	test   %eax,%eax
  8002f9:	0f 88 87 00 00 00    	js     800386 <bc_pgfault+0x100>
		panic("in bc_pgfault, ide_read: %e\n", r);

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002ff:	89 d8                	mov    %ebx,%eax
  800301:	c1 e8 0c             	shr    $0xc,%eax
  800304:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80030b:	83 ec 0c             	sub    $0xc,%esp
  80030e:	25 07 0e 00 00       	and    $0xe07,%eax
  800313:	50                   	push   %eax
  800314:	53                   	push   %ebx
  800315:	6a 00                	push   $0x0
  800317:	53                   	push   %ebx
  800318:	6a 00                	push   $0x0
  80031a:	e8 36 24 00 00       	call   802755 <sys_page_map>
  80031f:	83 c4 20             	add    $0x20,%esp
  800322:	85 c0                	test   %eax,%eax
  800324:	78 72                	js     800398 <bc_pgfault+0x112>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800326:	83 3d 08 a0 80 00 00 	cmpl   $0x0,0x80a008
  80032d:	74 10                	je     80033f <bc_pgfault+0xb9>
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	57                   	push   %edi
  800333:	e8 1f 05 00 00       	call   800857 <block_is_free>
  800338:	83 c4 10             	add    $0x10,%esp
  80033b:	84 c0                	test   %al,%al
  80033d:	75 6b                	jne    8003aa <bc_pgfault+0x124>
		panic("reading free block %08x\n", blockno);
}
  80033f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800342:	5b                   	pop    %ebx
  800343:	5e                   	pop    %esi
  800344:	5f                   	pop    %edi
  800345:	5d                   	pop    %ebp
  800346:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800347:	83 ec 08             	sub    $0x8,%esp
  80034a:	ff 70 04             	pushl  0x4(%eax)
  80034d:	53                   	push   %ebx
  80034e:	ff 70 28             	pushl  0x28(%eax)
  800351:	68 94 40 80 00       	push   $0x804094
  800356:	6a 26                	push   $0x26
  800358:	68 74 41 80 00       	push   $0x804174
  80035d:	e8 79 18 00 00       	call   801bdb <_panic>
		panic("reading non-existent block %08x\n", blockno);
  800362:	57                   	push   %edi
  800363:	68 c4 40 80 00       	push   $0x8040c4
  800368:	6a 2b                	push   $0x2b
  80036a:	68 74 41 80 00       	push   $0x804174
  80036f:	e8 67 18 00 00       	call   801bdb <_panic>
		panic("in bc_pgfault, sys_page_alloc: %e\n", r);
  800374:	50                   	push   %eax
  800375:	68 e8 40 80 00       	push   $0x8040e8
  80037a:	6a 35                	push   $0x35
  80037c:	68 74 41 80 00       	push   $0x804174
  800381:	e8 55 18 00 00       	call   801bdb <_panic>
		panic("in bc_pgfault, ide_read: %e\n", r);
  800386:	50                   	push   %eax
  800387:	68 7c 41 80 00       	push   $0x80417c
  80038c:	6a 38                	push   $0x38
  80038e:	68 74 41 80 00       	push   $0x804174
  800393:	e8 43 18 00 00       	call   801bdb <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800398:	50                   	push   %eax
  800399:	68 0c 41 80 00       	push   $0x80410c
  80039e:	6a 3d                	push   $0x3d
  8003a0:	68 74 41 80 00       	push   $0x804174
  8003a5:	e8 31 18 00 00       	call   801bdb <_panic>
		panic("reading free block %08x\n", blockno);
  8003aa:	57                   	push   %edi
  8003ab:	68 99 41 80 00       	push   $0x804199
  8003b0:	6a 43                	push   $0x43
  8003b2:	68 74 41 80 00       	push   $0x804174
  8003b7:	e8 1f 18 00 00       	call   801bdb <_panic>

008003bc <diskaddr>:
{
  8003bc:	f3 0f 1e fb          	endbr32 
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8003c9:	85 c0                	test   %eax,%eax
  8003cb:	74 19                	je     8003e6 <diskaddr+0x2a>
  8003cd:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8003d3:	85 d2                	test   %edx,%edx
  8003d5:	74 05                	je     8003dc <diskaddr+0x20>
  8003d7:	39 42 04             	cmp    %eax,0x4(%edx)
  8003da:	76 0a                	jbe    8003e6 <diskaddr+0x2a>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  8003dc:	05 00 00 01 00       	add    $0x10000,%eax
  8003e1:	c1 e0 0c             	shl    $0xc,%eax
}
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  8003e6:	50                   	push   %eax
  8003e7:	68 2c 41 80 00       	push   $0x80412c
  8003ec:	6a 09                	push   $0x9
  8003ee:	68 74 41 80 00       	push   $0x804174
  8003f3:	e8 e3 17 00 00       	call   801bdb <_panic>

008003f8 <va_is_mapped>:
{
  8003f8:	f3 0f 1e fb          	endbr32 
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  800402:	89 d0                	mov    %edx,%eax
  800404:	c1 e8 16             	shr    $0x16,%eax
  800407:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  80040e:	b8 00 00 00 00       	mov    $0x0,%eax
  800413:	f6 c1 01             	test   $0x1,%cl
  800416:	74 0d                	je     800425 <va_is_mapped+0x2d>
  800418:	c1 ea 0c             	shr    $0xc,%edx
  80041b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800422:	83 e0 01             	and    $0x1,%eax
  800425:	83 e0 01             	and    $0x1,%eax
}
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    

0080042a <va_is_dirty>:
{
  80042a:	f3 0f 1e fb          	endbr32 
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	c1 e8 0c             	shr    $0xc,%eax
  800437:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80043e:	c1 e8 06             	shr    $0x6,%eax
  800441:	83 e0 01             	and    $0x1,%eax
}
  800444:	5d                   	pop    %ebp
  800445:	c3                   	ret    

00800446 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800446:	f3 0f 1e fb          	endbr32 
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
  80044d:	56                   	push   %esi
  80044e:	53                   	push   %ebx
  80044f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800452:	8d b3 00 00 00 f0    	lea    -0x10000000(%ebx),%esi

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800458:	81 fe ff ff ff bf    	cmp    $0xbfffffff,%esi
  80045e:	77 1d                	ja     80047d <flush_block+0x37>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	//panic("flush_block not implemented");
	int r;
	addr = ROUNDDOWN(addr, PGSIZE);
  800460:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if(!va_is_mapped(addr) || !va_is_dirty(addr)) return ;
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	53                   	push   %ebx
  80046a:	e8 89 ff ff ff       	call   8003f8 <va_is_mapped>
  80046f:	83 c4 10             	add    $0x10,%esp
  800472:	84 c0                	test   %al,%al
  800474:	75 19                	jne    80048f <flush_block+0x49>
		panic("flush_block: ide_write %e\n", r);
	
	// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
	if((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
		panic("flush_block: sys_page_map %e\n", r);
}
  800476:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800479:	5b                   	pop    %ebx
  80047a:	5e                   	pop    %esi
  80047b:	5d                   	pop    %ebp
  80047c:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  80047d:	53                   	push   %ebx
  80047e:	68 b2 41 80 00       	push   $0x8041b2
  800483:	6a 53                	push   $0x53
  800485:	68 74 41 80 00       	push   $0x804174
  80048a:	e8 4c 17 00 00       	call   801bdb <_panic>
	if(!va_is_mapped(addr) || !va_is_dirty(addr)) return ;
  80048f:	83 ec 0c             	sub    $0xc,%esp
  800492:	53                   	push   %ebx
  800493:	e8 92 ff ff ff       	call   80042a <va_is_dirty>
  800498:	83 c4 10             	add    $0x10,%esp
  80049b:	84 c0                	test   %al,%al
  80049d:	74 d7                	je     800476 <flush_block+0x30>
	if((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	6a 08                	push   $0x8
  8004a4:	53                   	push   %ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8004a5:	c1 ee 0c             	shr    $0xc,%esi
	if((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  8004a8:	c1 e6 03             	shl    $0x3,%esi
  8004ab:	56                   	push   %esi
  8004ac:	e8 0b fd ff ff       	call   8001bc <ide_write>
  8004b1:	83 c4 10             	add    $0x10,%esp
  8004b4:	85 c0                	test   %eax,%eax
  8004b6:	78 39                	js     8004f1 <flush_block+0xab>
	if((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8004b8:	89 d8                	mov    %ebx,%eax
  8004ba:	c1 e8 0c             	shr    $0xc,%eax
  8004bd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8004c4:	83 ec 0c             	sub    $0xc,%esp
  8004c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8004cc:	50                   	push   %eax
  8004cd:	53                   	push   %ebx
  8004ce:	6a 00                	push   $0x0
  8004d0:	53                   	push   %ebx
  8004d1:	6a 00                	push   $0x0
  8004d3:	e8 7d 22 00 00       	call   802755 <sys_page_map>
  8004d8:	83 c4 20             	add    $0x20,%esp
  8004db:	85 c0                	test   %eax,%eax
  8004dd:	79 97                	jns    800476 <flush_block+0x30>
		panic("flush_block: sys_page_map %e\n", r);
  8004df:	50                   	push   %eax
  8004e0:	68 e8 41 80 00       	push   $0x8041e8
  8004e5:	6a 60                	push   $0x60
  8004e7:	68 74 41 80 00       	push   $0x804174
  8004ec:	e8 ea 16 00 00       	call   801bdb <_panic>
		panic("flush_block: ide_write %e\n", r);
  8004f1:	50                   	push   %eax
  8004f2:	68 cd 41 80 00       	push   $0x8041cd
  8004f7:	6a 5c                	push   $0x5c
  8004f9:	68 74 41 80 00       	push   $0x804174
  8004fe:	e8 d8 16 00 00       	call   801bdb <_panic>

00800503 <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  800503:	f3 0f 1e fb          	endbr32 
  800507:	55                   	push   %ebp
  800508:	89 e5                	mov    %esp,%ebp
  80050a:	53                   	push   %ebx
  80050b:	81 ec 20 02 00 00    	sub    $0x220,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800511:	68 86 02 80 00       	push   $0x800286
  800516:	e8 b3 24 00 00       	call   8029ce <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  80051b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800522:	e8 95 fe ff ff       	call   8003bc <diskaddr>
  800527:	83 c4 0c             	add    $0xc,%esp
  80052a:	68 08 01 00 00       	push   $0x108
  80052f:	50                   	push   %eax
  800530:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800536:	50                   	push   %eax
  800537:	e8 46 1f 00 00       	call   802482 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  80053c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800543:	e8 74 fe ff ff       	call   8003bc <diskaddr>
  800548:	83 c4 08             	add    $0x8,%esp
  80054b:	68 06 42 80 00       	push   $0x804206
  800550:	50                   	push   %eax
  800551:	e8 76 1d 00 00       	call   8022cc <strcpy>
	flush_block(diskaddr(1));
  800556:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80055d:	e8 5a fe ff ff       	call   8003bc <diskaddr>
  800562:	89 04 24             	mov    %eax,(%esp)
  800565:	e8 dc fe ff ff       	call   800446 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  80056a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800571:	e8 46 fe ff ff       	call   8003bc <diskaddr>
  800576:	89 04 24             	mov    %eax,(%esp)
  800579:	e8 7a fe ff ff       	call   8003f8 <va_is_mapped>
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	84 c0                	test   %al,%al
  800583:	0f 84 d1 01 00 00    	je     80075a <bc_init+0x257>
	assert(!va_is_dirty(diskaddr(1)));
  800589:	83 ec 0c             	sub    $0xc,%esp
  80058c:	6a 01                	push   $0x1
  80058e:	e8 29 fe ff ff       	call   8003bc <diskaddr>
  800593:	89 04 24             	mov    %eax,(%esp)
  800596:	e8 8f fe ff ff       	call   80042a <va_is_dirty>
  80059b:	83 c4 10             	add    $0x10,%esp
  80059e:	84 c0                	test   %al,%al
  8005a0:	0f 85 ca 01 00 00    	jne    800770 <bc_init+0x26d>
	sys_page_unmap(0, diskaddr(1));
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	6a 01                	push   $0x1
  8005ab:	e8 0c fe ff ff       	call   8003bc <diskaddr>
  8005b0:	83 c4 08             	add    $0x8,%esp
  8005b3:	50                   	push   %eax
  8005b4:	6a 00                	push   $0x0
  8005b6:	e8 e0 21 00 00       	call   80279b <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  8005bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005c2:	e8 f5 fd ff ff       	call   8003bc <diskaddr>
  8005c7:	89 04 24             	mov    %eax,(%esp)
  8005ca:	e8 29 fe ff ff       	call   8003f8 <va_is_mapped>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	84 c0                	test   %al,%al
  8005d4:	0f 85 ac 01 00 00    	jne    800786 <bc_init+0x283>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8005da:	83 ec 0c             	sub    $0xc,%esp
  8005dd:	6a 01                	push   $0x1
  8005df:	e8 d8 fd ff ff       	call   8003bc <diskaddr>
  8005e4:	83 c4 08             	add    $0x8,%esp
  8005e7:	68 06 42 80 00       	push   $0x804206
  8005ec:	50                   	push   %eax
  8005ed:	e8 99 1d 00 00       	call   80238b <strcmp>
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	85 c0                	test   %eax,%eax
  8005f7:	0f 85 9f 01 00 00    	jne    80079c <bc_init+0x299>
	memmove(diskaddr(1), &backup, sizeof backup);
  8005fd:	83 ec 0c             	sub    $0xc,%esp
  800600:	6a 01                	push   $0x1
  800602:	e8 b5 fd ff ff       	call   8003bc <diskaddr>
  800607:	83 c4 0c             	add    $0xc,%esp
  80060a:	68 08 01 00 00       	push   $0x108
  80060f:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  800615:	53                   	push   %ebx
  800616:	50                   	push   %eax
  800617:	e8 66 1e 00 00       	call   802482 <memmove>
	flush_block(diskaddr(1));
  80061c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800623:	e8 94 fd ff ff       	call   8003bc <diskaddr>
  800628:	89 04 24             	mov    %eax,(%esp)
  80062b:	e8 16 fe ff ff       	call   800446 <flush_block>
	memmove(&backup, diskaddr(1), sizeof backup);
  800630:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800637:	e8 80 fd ff ff       	call   8003bc <diskaddr>
  80063c:	83 c4 0c             	add    $0xc,%esp
  80063f:	68 08 01 00 00       	push   $0x108
  800644:	50                   	push   %eax
  800645:	53                   	push   %ebx
  800646:	e8 37 1e 00 00       	call   802482 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  80064b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800652:	e8 65 fd ff ff       	call   8003bc <diskaddr>
  800657:	83 c4 08             	add    $0x8,%esp
  80065a:	68 06 42 80 00       	push   $0x804206
  80065f:	50                   	push   %eax
  800660:	e8 67 1c 00 00       	call   8022cc <strcpy>
	flush_block(diskaddr(1) + 20);
  800665:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80066c:	e8 4b fd ff ff       	call   8003bc <diskaddr>
  800671:	83 c0 14             	add    $0x14,%eax
  800674:	89 04 24             	mov    %eax,(%esp)
  800677:	e8 ca fd ff ff       	call   800446 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  80067c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800683:	e8 34 fd ff ff       	call   8003bc <diskaddr>
  800688:	89 04 24             	mov    %eax,(%esp)
  80068b:	e8 68 fd ff ff       	call   8003f8 <va_is_mapped>
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	84 c0                	test   %al,%al
  800695:	0f 84 17 01 00 00    	je     8007b2 <bc_init+0x2af>
	sys_page_unmap(0, diskaddr(1));
  80069b:	83 ec 0c             	sub    $0xc,%esp
  80069e:	6a 01                	push   $0x1
  8006a0:	e8 17 fd ff ff       	call   8003bc <diskaddr>
  8006a5:	83 c4 08             	add    $0x8,%esp
  8006a8:	50                   	push   %eax
  8006a9:	6a 00                	push   $0x0
  8006ab:	e8 eb 20 00 00       	call   80279b <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  8006b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006b7:	e8 00 fd ff ff       	call   8003bc <diskaddr>
  8006bc:	89 04 24             	mov    %eax,(%esp)
  8006bf:	e8 34 fd ff ff       	call   8003f8 <va_is_mapped>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	84 c0                	test   %al,%al
  8006c9:	0f 85 fc 00 00 00    	jne    8007cb <bc_init+0x2c8>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006cf:	83 ec 0c             	sub    $0xc,%esp
  8006d2:	6a 01                	push   $0x1
  8006d4:	e8 e3 fc ff ff       	call   8003bc <diskaddr>
  8006d9:	83 c4 08             	add    $0x8,%esp
  8006dc:	68 06 42 80 00       	push   $0x804206
  8006e1:	50                   	push   %eax
  8006e2:	e8 a4 1c 00 00       	call   80238b <strcmp>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	85 c0                	test   %eax,%eax
  8006ec:	0f 85 f2 00 00 00    	jne    8007e4 <bc_init+0x2e1>
	memmove(diskaddr(1), &backup, sizeof backup);
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	6a 01                	push   $0x1
  8006f7:	e8 c0 fc ff ff       	call   8003bc <diskaddr>
  8006fc:	83 c4 0c             	add    $0xc,%esp
  8006ff:	68 08 01 00 00       	push   $0x108
  800704:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  80070a:	52                   	push   %edx
  80070b:	50                   	push   %eax
  80070c:	e8 71 1d 00 00       	call   802482 <memmove>
	flush_block(diskaddr(1));
  800711:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800718:	e8 9f fc ff ff       	call   8003bc <diskaddr>
  80071d:	89 04 24             	mov    %eax,(%esp)
  800720:	e8 21 fd ff ff       	call   800446 <flush_block>
	cprintf("block cache is good\n");
  800725:	c7 04 24 42 42 80 00 	movl   $0x804242,(%esp)
  80072c:	e8 91 15 00 00       	call   801cc2 <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800731:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800738:	e8 7f fc ff ff       	call   8003bc <diskaddr>
  80073d:	83 c4 0c             	add    $0xc,%esp
  800740:	68 08 01 00 00       	push   $0x108
  800745:	50                   	push   %eax
  800746:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80074c:	50                   	push   %eax
  80074d:	e8 30 1d 00 00       	call   802482 <memmove>
}
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800758:	c9                   	leave  
  800759:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  80075a:	68 28 42 80 00       	push   $0x804228
  80075f:	68 7d 40 80 00       	push   $0x80407d
  800764:	6a 70                	push   $0x70
  800766:	68 74 41 80 00       	push   $0x804174
  80076b:	e8 6b 14 00 00       	call   801bdb <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  800770:	68 0d 42 80 00       	push   $0x80420d
  800775:	68 7d 40 80 00       	push   $0x80407d
  80077a:	6a 71                	push   $0x71
  80077c:	68 74 41 80 00       	push   $0x804174
  800781:	e8 55 14 00 00       	call   801bdb <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800786:	68 27 42 80 00       	push   $0x804227
  80078b:	68 7d 40 80 00       	push   $0x80407d
  800790:	6a 75                	push   $0x75
  800792:	68 74 41 80 00       	push   $0x804174
  800797:	e8 3f 14 00 00       	call   801bdb <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80079c:	68 50 41 80 00       	push   $0x804150
  8007a1:	68 7d 40 80 00       	push   $0x80407d
  8007a6:	6a 78                	push   $0x78
  8007a8:	68 74 41 80 00       	push   $0x804174
  8007ad:	e8 29 14 00 00       	call   801bdb <_panic>
	assert(va_is_mapped(diskaddr(1)));
  8007b2:	68 28 42 80 00       	push   $0x804228
  8007b7:	68 7d 40 80 00       	push   $0x80407d
  8007bc:	68 89 00 00 00       	push   $0x89
  8007c1:	68 74 41 80 00       	push   $0x804174
  8007c6:	e8 10 14 00 00       	call   801bdb <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  8007cb:	68 27 42 80 00       	push   $0x804227
  8007d0:	68 7d 40 80 00       	push   $0x80407d
  8007d5:	68 91 00 00 00       	push   $0x91
  8007da:	68 74 41 80 00       	push   $0x804174
  8007df:	e8 f7 13 00 00       	call   801bdb <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007e4:	68 50 41 80 00       	push   $0x804150
  8007e9:	68 7d 40 80 00       	push   $0x80407d
  8007ee:	68 94 00 00 00       	push   $0x94
  8007f3:	68 74 41 80 00       	push   $0x804174
  8007f8:	e8 de 13 00 00       	call   801bdb <_panic>

008007fd <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8007fd:	f3 0f 1e fb          	endbr32 
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  800807:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80080c:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  800812:	75 1b                	jne    80082f <check_super+0x32>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800814:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  80081b:	77 26                	ja     800843 <check_super+0x46>
		panic("file system is too large");

	cprintf("superblock is good\n");
  80081d:	83 ec 0c             	sub    $0xc,%esp
  800820:	68 95 42 80 00       	push   $0x804295
  800825:	e8 98 14 00 00       	call   801cc2 <cprintf>
}
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	c9                   	leave  
  80082e:	c3                   	ret    
		panic("bad file system magic number");
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 57 42 80 00       	push   $0x804257
  800837:	6a 0f                	push   $0xf
  800839:	68 74 42 80 00       	push   $0x804274
  80083e:	e8 98 13 00 00       	call   801bdb <_panic>
		panic("file system is too large");
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	68 7c 42 80 00       	push   $0x80427c
  80084b:	6a 12                	push   $0x12
  80084d:	68 74 42 80 00       	push   $0x804274
  800852:	e8 84 13 00 00       	call   801bdb <_panic>

00800857 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800857:	f3 0f 1e fb          	endbr32 
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800862:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800867:	85 c0                	test   %eax,%eax
  800869:	74 27                	je     800892 <block_is_free+0x3b>
		return 0;
  80086b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (super == 0 || blockno >= super->s_nblocks)
  800870:	39 48 04             	cmp    %ecx,0x4(%eax)
  800873:	76 18                	jbe    80088d <block_is_free+0x36>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800875:	89 cb                	mov    %ecx,%ebx
  800877:	c1 eb 05             	shr    $0x5,%ebx
  80087a:	b8 01 00 00 00       	mov    $0x1,%eax
  80087f:	d3 e0                	shl    %cl,%eax
  800881:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  800887:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  80088a:	0f 95 c2             	setne  %dl
		return 1;
	return 0;
}
  80088d:	89 d0                	mov    %edx,%eax
  80088f:	5b                   	pop    %ebx
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    
		return 0;
  800892:	ba 00 00 00 00       	mov    $0x0,%edx
  800897:	eb f4                	jmp    80088d <block_is_free+0x36>

00800899 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800899:	f3 0f 1e fb          	endbr32 
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	53                   	push   %ebx
  8008a1:	83 ec 04             	sub    $0x4,%esp
  8008a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  8008a7:	85 c9                	test   %ecx,%ecx
  8008a9:	74 1a                	je     8008c5 <free_block+0x2c>
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
  8008ab:	89 cb                	mov    %ecx,%ebx
  8008ad:	c1 eb 05             	shr    $0x5,%ebx
  8008b0:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  8008b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8008bb:	d3 e0                	shl    %cl,%eax
  8008bd:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  8008c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    
		panic("attempt to free zero block");
  8008c5:	83 ec 04             	sub    $0x4,%esp
  8008c8:	68 a9 42 80 00       	push   $0x8042a9
  8008cd:	6a 2d                	push   $0x2d
  8008cf:	68 74 42 80 00       	push   $0x804274
  8008d4:	e8 02 13 00 00       	call   801bdb <_panic>

008008d9 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  8008d9:	f3 0f 1e fb          	endbr32 
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	56                   	push   %esi
  8008e1:	53                   	push   %ebx
	// LAB 5: Your code here.
	//panic("alloc_block not implemented");

	uint32_t blockno;
	//找到空闲的blockno
	for(blockno = 2; blockno < super->s_nblocks && !block_is_free(blockno); blockno++);
  8008e2:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8008e7:	8b 70 04             	mov    0x4(%eax),%esi
  8008ea:	bb 02 00 00 00       	mov    $0x2,%ebx
  8008ef:	39 de                	cmp    %ebx,%esi
  8008f1:	76 4d                	jbe    800940 <alloc_block+0x67>
  8008f3:	83 ec 0c             	sub    $0xc,%esp
  8008f6:	53                   	push   %ebx
  8008f7:	e8 5b ff ff ff       	call   800857 <block_is_free>
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	84 c0                	test   %al,%al
  800901:	75 05                	jne    800908 <alloc_block+0x2f>
  800903:	83 c3 01             	add    $0x1,%ebx
  800906:	eb e7                	jmp    8008ef <alloc_block+0x16>
	//如果没有空闲，返回-E_NO_DISK
	if(blockno >= super->s_nblocks) return -E_NO_DISK;
	//将空闲块标记为不空闲
	bitmap[blockno / 32] &= ~(1 << (blockno % 32));
  800908:	89 d8                	mov    %ebx,%eax
  80090a:	c1 e8 05             	shr    $0x5,%eax
  80090d:	c1 e0 02             	shl    $0x2,%eax
  800910:	89 c6                	mov    %eax,%esi
  800912:	03 35 08 a0 80 00    	add    0x80a008,%esi
  800918:	ba 01 00 00 00       	mov    $0x1,%edx
  80091d:	89 d9                	mov    %ebx,%ecx
  80091f:	d3 e2                	shl    %cl,%edx
  800921:	f7 d2                	not    %edx
  800923:	21 16                	and    %edx,(%esi)
	//flush the changed bitmap block to disk.
	flush_block(&bitmap[blockno / 32]);
  800925:	83 ec 0c             	sub    $0xc,%esp
  800928:	03 05 08 a0 80 00    	add    0x80a008,%eax
  80092e:	50                   	push   %eax
  80092f:	e8 12 fb ff ff       	call   800446 <flush_block>
	return blockno;
  800934:	89 d8                	mov    %ebx,%eax
  800936:	83 c4 10             	add    $0x10,%esp
}
  800939:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80093c:	5b                   	pop    %ebx
  80093d:	5e                   	pop    %esi
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    
	if(blockno >= super->s_nblocks) return -E_NO_DISK;
  800940:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800945:	eb f2                	jmp    800939 <alloc_block+0x60>

00800947 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	57                   	push   %edi
  80094b:	56                   	push   %esi
  80094c:	53                   	push   %ebx
  80094d:	83 ec 1c             	sub    $0x1c,%esp
  800950:	89 c6                	mov    %eax,%esi
  800952:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;
	//	-E_INVAL if filebno is out of range (it's >= NDIRECT + NINDIRECT).
	// inc/fs.h  
    // #define NDIRECT		10
    // #define NINDIRECT	(BLKSIZE / 4)
	if(filebno >= NDIRECT + NINDIRECT)
  800958:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  80095e:	0f 87 88 00 00 00    	ja     8009ec <file_block_walk+0xa5>
  800964:	89 d3                	mov    %edx,%ebx
		return -E_INVAL;
	
	//如果小于10，则直接把f->f_direct的第filebno的地址给他
	if(filebno < NDIRECT){
  800966:	83 fa 09             	cmp    $0x9,%edx
  800969:	76 71                	jbe    8009dc <file_block_walk+0x95>

	//如果大于等于10，则需要找indirect block
	//注意 File 数据结构中的f_indirect并不是一个指针
	//而是一个 uint32_t
	//所以说我们只能有一个indirect block
	if(f->f_indirect == 0){
  80096b:	83 be b0 00 00 00 00 	cmpl   $0x0,0xb0(%esi)
  800972:	75 41                	jne    8009b5 <file_block_walk+0x6e>
		//	-E_NOT_FOUND if the function needed to allocate an indirect block, but
		//		alloc was 0.
		if(alloc == 0)
  800974:	84 c0                	test   %al,%al
  800976:	74 7b                	je     8009f3 <file_block_walk+0xac>
			return -E_NOT_FOUND;
		//	-E_NO_DISK if there's no space on the disk for an indirect block.
		if((r = alloc_block()) < 0)
  800978:	e8 5c ff ff ff       	call   8008d9 <alloc_block>
  80097d:	89 c7                	mov    %eax,%edi
  80097f:	85 c0                	test   %eax,%eax
  800981:	78 77                	js     8009fa <file_block_walk+0xb3>
			return -E_NO_DISK;
		f->f_indirect = r;
  800983:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
		// When 'alloc' is set, this function will allocate an indirect block
		// if necessary.
		memset(diskaddr(r), 0, BLKSIZE);
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	50                   	push   %eax
  80098d:	e8 2a fa ff ff       	call   8003bc <diskaddr>
  800992:	83 c4 0c             	add    $0xc,%esp
  800995:	68 00 10 00 00       	push   $0x1000
  80099a:	6a 00                	push   $0x0
  80099c:	50                   	push   %eax
  80099d:	e8 94 1a 00 00       	call   802436 <memset>
		// Hint: Don't forget to clear any block you allocate.
		flush_block(diskaddr(r));
  8009a2:	89 3c 24             	mov    %edi,(%esp)
  8009a5:	e8 12 fa ff ff       	call   8003bc <diskaddr>
  8009aa:	89 04 24             	mov    %eax,(%esp)
  8009ad:	e8 94 fa ff ff       	call   800446 <flush_block>
  8009b2:	83 c4 10             	add    $0x10,%esp
	}


	//获得对应的物理块号的地址
	*ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
  8009b5:	83 ec 0c             	sub    $0xc,%esp
  8009b8:	ff b6 b0 00 00 00    	pushl  0xb0(%esi)
  8009be:	e8 f9 f9 ff ff       	call   8003bc <diskaddr>
  8009c3:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  8009c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009ca:	89 07                	mov    %eax,(%edi)
	return 0;
  8009cc:	83 c4 10             	add    $0x10,%esp
  8009cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009d7:	5b                   	pop    %ebx
  8009d8:	5e                   	pop    %esi
  8009d9:	5f                   	pop    %edi
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    
		*ppdiskbno = &(f->f_direct[filebno]);
  8009dc:	8d 84 96 88 00 00 00 	lea    0x88(%esi,%edx,4),%eax
  8009e3:	89 01                	mov    %eax,(%ecx)
		return 0;
  8009e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ea:	eb e8                	jmp    8009d4 <file_block_walk+0x8d>
		return -E_INVAL;
  8009ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f1:	eb e1                	jmp    8009d4 <file_block_walk+0x8d>
			return -E_NOT_FOUND;
  8009f3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8009f8:	eb da                	jmp    8009d4 <file_block_walk+0x8d>
			return -E_NO_DISK;
  8009fa:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8009ff:	eb d3                	jmp    8009d4 <file_block_walk+0x8d>

00800a01 <check_bitmap>:
{
  800a01:	f3 0f 1e fb          	endbr32 
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	56                   	push   %esi
  800a09:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800a0a:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800a0f:	8b 70 04             	mov    0x4(%eax),%esi
  800a12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a17:	89 d8                	mov    %ebx,%eax
  800a19:	c1 e0 0f             	shl    $0xf,%eax
  800a1c:	39 c6                	cmp    %eax,%esi
  800a1e:	76 2e                	jbe    800a4e <check_bitmap+0x4d>
		assert(!block_is_free(2+i));
  800a20:	83 ec 0c             	sub    $0xc,%esp
  800a23:	8d 43 02             	lea    0x2(%ebx),%eax
  800a26:	50                   	push   %eax
  800a27:	e8 2b fe ff ff       	call   800857 <block_is_free>
  800a2c:	83 c4 10             	add    $0x10,%esp
  800a2f:	84 c0                	test   %al,%al
  800a31:	75 05                	jne    800a38 <check_bitmap+0x37>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800a33:	83 c3 01             	add    $0x1,%ebx
  800a36:	eb df                	jmp    800a17 <check_bitmap+0x16>
		assert(!block_is_free(2+i));
  800a38:	68 c4 42 80 00       	push   $0x8042c4
  800a3d:	68 7d 40 80 00       	push   $0x80407d
  800a42:	6a 5a                	push   $0x5a
  800a44:	68 74 42 80 00       	push   $0x804274
  800a49:	e8 8d 11 00 00       	call   801bdb <_panic>
	assert(!block_is_free(0));
  800a4e:	83 ec 0c             	sub    $0xc,%esp
  800a51:	6a 00                	push   $0x0
  800a53:	e8 ff fd ff ff       	call   800857 <block_is_free>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	84 c0                	test   %al,%al
  800a5d:	75 28                	jne    800a87 <check_bitmap+0x86>
	assert(!block_is_free(1));
  800a5f:	83 ec 0c             	sub    $0xc,%esp
  800a62:	6a 01                	push   $0x1
  800a64:	e8 ee fd ff ff       	call   800857 <block_is_free>
  800a69:	83 c4 10             	add    $0x10,%esp
  800a6c:	84 c0                	test   %al,%al
  800a6e:	75 2d                	jne    800a9d <check_bitmap+0x9c>
	cprintf("bitmap is good\n");
  800a70:	83 ec 0c             	sub    $0xc,%esp
  800a73:	68 fc 42 80 00       	push   $0x8042fc
  800a78:	e8 45 12 00 00       	call   801cc2 <cprintf>
}
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a83:	5b                   	pop    %ebx
  800a84:	5e                   	pop    %esi
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    
	assert(!block_is_free(0));
  800a87:	68 d8 42 80 00       	push   $0x8042d8
  800a8c:	68 7d 40 80 00       	push   $0x80407d
  800a91:	6a 5d                	push   $0x5d
  800a93:	68 74 42 80 00       	push   $0x804274
  800a98:	e8 3e 11 00 00       	call   801bdb <_panic>
	assert(!block_is_free(1));
  800a9d:	68 ea 42 80 00       	push   $0x8042ea
  800aa2:	68 7d 40 80 00       	push   $0x80407d
  800aa7:	6a 5e                	push   $0x5e
  800aa9:	68 74 42 80 00       	push   $0x804274
  800aae:	e8 28 11 00 00       	call   801bdb <_panic>

00800ab3 <fs_init>:
{
  800ab3:	f3 0f 1e fb          	endbr32 
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800abd:	e8 9d f5 ff ff       	call   80005f <ide_probe_disk1>
  800ac2:	84 c0                	test   %al,%al
  800ac4:	74 41                	je     800b07 <fs_init+0x54>
		ide_set_disk(1);
  800ac6:	83 ec 0c             	sub    $0xc,%esp
  800ac9:	6a 01                	push   $0x1
  800acb:	e8 f5 f5 ff ff       	call   8000c5 <ide_set_disk>
  800ad0:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800ad3:	e8 2b fa ff ff       	call   800503 <bc_init>
	super = diskaddr(1);
  800ad8:	83 ec 0c             	sub    $0xc,%esp
  800adb:	6a 01                	push   $0x1
  800add:	e8 da f8 ff ff       	call   8003bc <diskaddr>
  800ae2:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	check_super();
  800ae7:	e8 11 fd ff ff       	call   8007fd <check_super>
	bitmap = diskaddr(2);
  800aec:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800af3:	e8 c4 f8 ff ff       	call   8003bc <diskaddr>
  800af8:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_bitmap();
  800afd:	e8 ff fe ff ff       	call   800a01 <check_bitmap>
}
  800b02:	83 c4 10             	add    $0x10,%esp
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    
		ide_set_disk(0);
  800b07:	83 ec 0c             	sub    $0xc,%esp
  800b0a:	6a 00                	push   $0x0
  800b0c:	e8 b4 f5 ff ff       	call   8000c5 <ide_set_disk>
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	eb bd                	jmp    800ad3 <fs_init+0x20>

00800b16 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800b16:	f3 0f 1e fb          	endbr32 
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	53                   	push   %ebx
  800b1e:	83 ec 20             	sub    $0x20,%esp
    // LAB 5: Your code here.
    //panic("file_get_block not implemented");
	int r;
	uint32_t *ppdiskbno;
	//先获取文件的物理块号
	if((r = file_block_walk(f, filebno, &ppdiskbno, 1)) < 0){
  800b21:	6a 01                	push   $0x1
  800b23:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	e8 16 fe ff ff       	call   800947 <file_block_walk>
  800b31:	89 c3                	mov    %eax,%ebx
  800b33:	83 c4 10             	add    $0x10,%esp
  800b36:	85 c0                	test   %eax,%eax
  800b38:	78 5e                	js     800b98 <file_get_block+0x82>
		return r;
	}
	//物理块在磁盘上(DISKMAP之上)
	//如果当前的块号还没有对应的物理块
	if((*ppdiskbno) == 0){
  800b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b3d:	83 38 00             	cmpl   $0x0,(%eax)
  800b40:	75 3c                	jne    800b7e <file_get_block+0x68>
		//我们自己给该块分配一个
		if((r = alloc_block()) < 0)
  800b42:	e8 92 fd ff ff       	call   8008d9 <alloc_block>
  800b47:	89 c3                	mov    %eax,%ebx
  800b49:	85 c0                	test   %eax,%eax
  800b4b:	78 4b                	js     800b98 <file_get_block+0x82>
			return r;
		*ppdiskbno = r;
  800b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b50:	89 18                	mov    %ebx,(%eax)
		//分配好之后应该将分配的物理块中的数据清除
		//以免读取到其他文件的脏数据
		memset(diskaddr(r), 0, BLKSIZE);
  800b52:	83 ec 0c             	sub    $0xc,%esp
  800b55:	53                   	push   %ebx
  800b56:	e8 61 f8 ff ff       	call   8003bc <diskaddr>
  800b5b:	83 c4 0c             	add    $0xc,%esp
  800b5e:	68 00 10 00 00       	push   $0x1000
  800b63:	6a 00                	push   $0x0
  800b65:	50                   	push   %eax
  800b66:	e8 cb 18 00 00       	call   802436 <memset>
		//将文件写入该物理块
		flush_block(diskaddr(r));
  800b6b:	89 1c 24             	mov    %ebx,(%esp)
  800b6e:	e8 49 f8 ff ff       	call   8003bc <diskaddr>
  800b73:	89 04 24             	mov    %eax,(%esp)
  800b76:	e8 cb f8 ff ff       	call   800446 <flush_block>
  800b7b:	83 c4 10             	add    $0x10,%esp
	}
	*blk = diskaddr(*ppdiskbno);
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b84:	ff 30                	pushl  (%eax)
  800b86:	e8 31 f8 ff ff       	call   8003bc <diskaddr>
  800b8b:	8b 55 10             	mov    0x10(%ebp),%edx
  800b8e:	89 02                	mov    %eax,(%edx)
	return 0;
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	bb 00 00 00 00       	mov    $0x0,%ebx
}
  800b98:	89 d8                	mov    %ebx,%eax
  800b9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	57                   	push   %edi
  800ba3:	56                   	push   %esi
  800ba4:	53                   	push   %ebx
  800ba5:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800bab:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800bb1:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
	while (*p == '/')
  800bb7:	80 38 2f             	cmpb   $0x2f,(%eax)
  800bba:	75 05                	jne    800bc1 <walk_path+0x22>
		p++;
  800bbc:	83 c0 01             	add    $0x1,%eax
  800bbf:	eb f6                	jmp    800bb7 <walk_path+0x18>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800bc1:	8b 0d 0c a0 80 00    	mov    0x80a00c,%ecx
  800bc7:	83 c1 08             	add    $0x8,%ecx
  800bca:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800bd0:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800bd7:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800bdd:	85 c9                	test   %ecx,%ecx
  800bdf:	74 06                	je     800be7 <walk_path+0x48>
		*pdir = 0;
  800be1:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800be7:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800bed:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  800bf3:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800bf8:	e9 c5 01 00 00       	jmp    800dc2 <walk_path+0x223>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800bfd:	83 c6 01             	add    $0x1,%esi
		while (*path != '/' && *path != '\0')
  800c00:	0f b6 16             	movzbl (%esi),%edx
  800c03:	80 fa 2f             	cmp    $0x2f,%dl
  800c06:	74 04                	je     800c0c <walk_path+0x6d>
  800c08:	84 d2                	test   %dl,%dl
  800c0a:	75 f1                	jne    800bfd <walk_path+0x5e>
		if (path - p >= MAXNAMELEN)
  800c0c:	89 f3                	mov    %esi,%ebx
  800c0e:	29 c3                	sub    %eax,%ebx
  800c10:	83 fb 7f             	cmp    $0x7f,%ebx
  800c13:	0f 8f 71 01 00 00    	jg     800d8a <walk_path+0x1eb>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800c19:	83 ec 04             	sub    $0x4,%esp
  800c1c:	53                   	push   %ebx
  800c1d:	50                   	push   %eax
  800c1e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800c24:	50                   	push   %eax
  800c25:	e8 58 18 00 00       	call   802482 <memmove>
		name[path - p] = '\0';
  800c2a:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800c31:	00 
	while (*p == '/')
  800c32:	83 c4 10             	add    $0x10,%esp
  800c35:	80 3e 2f             	cmpb   $0x2f,(%esi)
  800c38:	75 05                	jne    800c3f <walk_path+0xa0>
		p++;
  800c3a:	83 c6 01             	add    $0x1,%esi
  800c3d:	eb f6                	jmp    800c35 <walk_path+0x96>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800c3f:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c45:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800c4c:	0f 85 3f 01 00 00    	jne    800d91 <walk_path+0x1f2>
	assert((dir->f_size % BLKSIZE) == 0);
  800c52:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800c58:	89 c1                	mov    %eax,%ecx
  800c5a:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
  800c60:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
  800c66:	0f 85 8e 00 00 00    	jne    800cfa <walk_path+0x15b>
	nblock = dir->f_size / BLKSIZE;
  800c6c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800c72:	85 c0                	test   %eax,%eax
  800c74:	0f 48 c2             	cmovs  %edx,%eax
  800c77:	c1 f8 0c             	sar    $0xc,%eax
  800c7a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
			if (strcmp(f[j].f_name, name) == 0) {
  800c80:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
  800c86:	89 b5 44 ff ff ff    	mov    %esi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800c8c:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800c92:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  800c98:	74 79                	je     800d13 <walk_path+0x174>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800c9a:	83 ec 04             	sub    $0x4,%esp
  800c9d:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800ca3:	50                   	push   %eax
  800ca4:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
  800caa:	ff b5 4c ff ff ff    	pushl  -0xb4(%ebp)
  800cb0:	e8 61 fe ff ff       	call   800b16 <file_get_block>
  800cb5:	83 c4 10             	add    $0x10,%esp
  800cb8:	85 c0                	test   %eax,%eax
  800cba:	0f 88 d8 00 00 00    	js     800d98 <walk_path+0x1f9>
  800cc0:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  800cc6:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
			if (strcmp(f[j].f_name, name) == 0) {
  800ccc:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800cd2:	83 ec 08             	sub    $0x8,%esp
  800cd5:	57                   	push   %edi
  800cd6:	53                   	push   %ebx
  800cd7:	e8 af 16 00 00       	call   80238b <strcmp>
  800cdc:	83 c4 10             	add    $0x10,%esp
  800cdf:	85 c0                	test   %eax,%eax
  800ce1:	0f 84 c1 00 00 00    	je     800da8 <walk_path+0x209>
  800ce7:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800ced:	39 f3                	cmp    %esi,%ebx
  800cef:	75 db                	jne    800ccc <walk_path+0x12d>
	for (i = 0; i < nblock; i++) {
  800cf1:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800cf8:	eb 92                	jmp    800c8c <walk_path+0xed>
	assert((dir->f_size % BLKSIZE) == 0);
  800cfa:	68 0c 43 80 00       	push   $0x80430c
  800cff:	68 7d 40 80 00       	push   $0x80407d
  800d04:	68 f0 00 00 00       	push   $0xf0
  800d09:	68 74 42 80 00       	push   $0x804274
  800d0e:	e8 c8 0e 00 00       	call   801bdb <_panic>
  800d13:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800d19:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d1e:	80 3e 00             	cmpb   $0x0,(%esi)
  800d21:	75 5f                	jne    800d82 <walk_path+0x1e3>
				if (pdir)
  800d23:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d29:	85 c0                	test   %eax,%eax
  800d2b:	74 08                	je     800d35 <walk_path+0x196>
					*pdir = dir;
  800d2d:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d33:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800d35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d39:	74 15                	je     800d50 <walk_path+0x1b1>
					strcpy(lastelem, name);
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800d44:	50                   	push   %eax
  800d45:	ff 75 08             	pushl  0x8(%ebp)
  800d48:	e8 7f 15 00 00       	call   8022cc <strcpy>
  800d4d:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800d50:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800d5c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d61:	eb 1f                	jmp    800d82 <walk_path+0x1e3>
		}
	}

	if (pdir)
  800d63:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	74 02                	je     800d6f <walk_path+0x1d0>
		*pdir = dir;
  800d6d:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800d6f:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d75:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d7b:	89 08                	mov    %ecx,(%eax)
	return 0;
  800d7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5f                   	pop    %edi
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    
			return -E_BAD_PATH;
  800d8a:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800d8f:	eb f1                	jmp    800d82 <walk_path+0x1e3>
			return -E_NOT_FOUND;
  800d91:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d96:	eb ea                	jmp    800d82 <walk_path+0x1e3>
  800d98:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d9e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800da1:	75 df                	jne    800d82 <walk_path+0x1e3>
  800da3:	e9 71 ff ff ff       	jmp    800d19 <walk_path+0x17a>
  800da8:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
  800dae:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0) {
  800db4:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800dba:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800dc0:	89 f0                	mov    %esi,%eax
	while (*path != '\0') {
  800dc2:	80 38 00             	cmpb   $0x0,(%eax)
  800dc5:	74 9c                	je     800d63 <walk_path+0x1c4>
  800dc7:	89 c6                	mov    %eax,%esi
  800dc9:	e9 32 fe ff ff       	jmp    800c00 <walk_path+0x61>

00800dce <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800dce:	f3 0f 1e fb          	endbr32 
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800dd8:	6a 00                	push   $0x0
  800dda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddd:	ba 00 00 00 00       	mov    $0x0,%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	e8 b5 fd ff ff       	call   800b9f <walk_path>
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800dec:	f3 0f 1e fb          	endbr32 
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
  800df6:	83 ec 2c             	sub    $0x2c,%esp
  800df9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800dfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dff:	8b 4d 14             	mov    0x14(%ebp),%ecx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800e0b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  800e10:	39 ca                	cmp    %ecx,%edx
  800e12:	7e 7e                	jle    800e92 <file_read+0xa6>

	count = MIN(count, f->f_size - offset);
  800e14:	29 ca                	sub    %ecx,%edx
  800e16:	39 da                	cmp    %ebx,%edx
  800e18:	89 d8                	mov    %ebx,%eax
  800e1a:	0f 46 c2             	cmovbe %edx,%eax
  800e1d:	89 45 d0             	mov    %eax,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800e20:	89 cb                	mov    %ecx,%ebx
  800e22:	01 c1                	add    %eax,%ecx
  800e24:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800e27:	89 de                	mov    %ebx,%esi
  800e29:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800e2c:	76 61                	jbe    800e8f <file_read+0xa3>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800e2e:	83 ec 04             	sub    $0x4,%esp
  800e31:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e34:	50                   	push   %eax
  800e35:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800e3b:	85 db                	test   %ebx,%ebx
  800e3d:	0f 49 c3             	cmovns %ebx,%eax
  800e40:	c1 f8 0c             	sar    $0xc,%eax
  800e43:	50                   	push   %eax
  800e44:	ff 75 08             	pushl  0x8(%ebp)
  800e47:	e8 ca fc ff ff       	call   800b16 <file_get_block>
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	78 3f                	js     800e92 <file_read+0xa6>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800e53:	89 da                	mov    %ebx,%edx
  800e55:	c1 fa 1f             	sar    $0x1f,%edx
  800e58:	c1 ea 14             	shr    $0x14,%edx
  800e5b:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800e5e:	25 ff 0f 00 00       	and    $0xfff,%eax
  800e63:	29 d0                	sub    %edx,%eax
  800e65:	ba 00 10 00 00       	mov    $0x1000,%edx
  800e6a:	29 c2                	sub    %eax,%edx
  800e6c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e6f:	29 f1                	sub    %esi,%ecx
  800e71:	89 ce                	mov    %ecx,%esi
  800e73:	39 ca                	cmp    %ecx,%edx
  800e75:	0f 46 f2             	cmovbe %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800e78:	83 ec 04             	sub    $0x4,%esp
  800e7b:	56                   	push   %esi
  800e7c:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e7f:	50                   	push   %eax
  800e80:	57                   	push   %edi
  800e81:	e8 fc 15 00 00       	call   802482 <memmove>
		pos += bn;
  800e86:	01 f3                	add    %esi,%ebx
		buf += bn;
  800e88:	01 f7                	add    %esi,%edi
  800e8a:	83 c4 10             	add    $0x10,%esp
  800e8d:	eb 98                	jmp    800e27 <file_read+0x3b>
	}

	return count;
  800e8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800e92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    

00800e9a <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800e9a:	f3 0f 1e fb          	endbr32 
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 2c             	sub    $0x2c,%esp
  800ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800eaa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if (f->f_size > newsize)
  800ead:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  800eb3:	39 f8                	cmp    %edi,%eax
  800eb5:	7f 1c                	jg     800ed3 <file_set_size+0x39>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800eb7:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
	flush_block(f);
  800ebd:	83 ec 0c             	sub    $0xc,%esp
  800ec0:	53                   	push   %ebx
  800ec1:	e8 80 f5 ff ff       	call   800446 <flush_block>
	return 0;
}
  800ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800ed3:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800ed9:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ede:	0f 48 c2             	cmovs  %edx,%eax
  800ee1:	c1 f8 0c             	sar    $0xc,%eax
  800ee4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800ee7:	8d 87 fe 1f 00 00    	lea    0x1ffe(%edi),%eax
  800eed:	89 fa                	mov    %edi,%edx
  800eef:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800ef5:	0f 49 c2             	cmovns %edx,%eax
  800ef8:	c1 f8 0c             	sar    $0xc,%eax
  800efb:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800efe:	89 c6                	mov    %eax,%esi
  800f00:	eb 3c                	jmp    800f3e <file_set_size+0xa4>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800f02:	83 7d d0 0a          	cmpl   $0xa,-0x30(%ebp)
  800f06:	77 af                	ja     800eb7 <file_set_size+0x1d>
  800f08:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	74 a5                	je     800eb7 <file_set_size+0x1d>
		free_block(f->f_indirect);
  800f12:	83 ec 0c             	sub    $0xc,%esp
  800f15:	50                   	push   %eax
  800f16:	e8 7e f9 ff ff       	call   800899 <free_block>
		f->f_indirect = 0;
  800f1b:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
  800f22:	00 00 00 
  800f25:	83 c4 10             	add    $0x10,%esp
  800f28:	eb 8d                	jmp    800eb7 <file_set_size+0x1d>
			cprintf("warning: file_free_block: %e", r);
  800f2a:	83 ec 08             	sub    $0x8,%esp
  800f2d:	50                   	push   %eax
  800f2e:	68 29 43 80 00       	push   $0x804329
  800f33:	e8 8a 0d 00 00       	call   801cc2 <cprintf>
  800f38:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800f3b:	83 c6 01             	add    $0x1,%esi
  800f3e:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800f41:	76 bf                	jbe    800f02 <file_set_size+0x68>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800f43:	83 ec 0c             	sub    $0xc,%esp
  800f46:	6a 00                	push   $0x0
  800f48:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800f4b:	89 f2                	mov    %esi,%edx
  800f4d:	89 d8                	mov    %ebx,%eax
  800f4f:	e8 f3 f9 ff ff       	call   800947 <file_block_walk>
  800f54:	83 c4 10             	add    $0x10,%esp
  800f57:	85 c0                	test   %eax,%eax
  800f59:	78 cf                	js     800f2a <file_set_size+0x90>
	if (*ptr) {
  800f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f5e:	8b 00                	mov    (%eax),%eax
  800f60:	85 c0                	test   %eax,%eax
  800f62:	74 d7                	je     800f3b <file_set_size+0xa1>
		free_block(*ptr);
  800f64:	83 ec 0c             	sub    $0xc,%esp
  800f67:	50                   	push   %eax
  800f68:	e8 2c f9 ff ff       	call   800899 <free_block>
		*ptr = 0;
  800f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800f76:	83 c4 10             	add    $0x10,%esp
  800f79:	eb c0                	jmp    800f3b <file_set_size+0xa1>

00800f7b <file_write>:
{
  800f7b:	f3 0f 1e fb          	endbr32 
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
  800f85:	83 ec 2c             	sub    $0x2c,%esp
  800f88:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	if (offset + count > f->f_size)
  800f8e:	89 d8                	mov    %ebx,%eax
  800f90:	03 45 10             	add    0x10(%ebp),%eax
  800f93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800f96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f99:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  800f9f:	77 68                	ja     801009 <file_write+0x8e>
	for (pos = offset; pos < offset + count; ) {
  800fa1:	89 de                	mov    %ebx,%esi
  800fa3:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800fa6:	76 74                	jbe    80101c <file_write+0xa1>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800fa8:	83 ec 04             	sub    $0x4,%esp
  800fab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fae:	50                   	push   %eax
  800faf:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800fb5:	85 db                	test   %ebx,%ebx
  800fb7:	0f 49 c3             	cmovns %ebx,%eax
  800fba:	c1 f8 0c             	sar    $0xc,%eax
  800fbd:	50                   	push   %eax
  800fbe:	ff 75 08             	pushl  0x8(%ebp)
  800fc1:	e8 50 fb ff ff       	call   800b16 <file_get_block>
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	78 52                	js     80101f <file_write+0xa4>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800fcd:	89 da                	mov    %ebx,%edx
  800fcf:	c1 fa 1f             	sar    $0x1f,%edx
  800fd2:	c1 ea 14             	shr    $0x14,%edx
  800fd5:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800fd8:	25 ff 0f 00 00       	and    $0xfff,%eax
  800fdd:	29 d0                	sub    %edx,%eax
  800fdf:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800fe4:	29 c1                	sub    %eax,%ecx
  800fe6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fe9:	29 f2                	sub    %esi,%edx
  800feb:	39 d1                	cmp    %edx,%ecx
  800fed:	89 d6                	mov    %edx,%esi
  800fef:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  800ff2:	83 ec 04             	sub    $0x4,%esp
  800ff5:	56                   	push   %esi
  800ff6:	57                   	push   %edi
  800ff7:	03 45 e4             	add    -0x1c(%ebp),%eax
  800ffa:	50                   	push   %eax
  800ffb:	e8 82 14 00 00       	call   802482 <memmove>
		pos += bn;
  801000:	01 f3                	add    %esi,%ebx
		buf += bn;
  801002:	01 f7                	add    %esi,%edi
  801004:	83 c4 10             	add    $0x10,%esp
  801007:	eb 98                	jmp    800fa1 <file_write+0x26>
		if ((r = file_set_size(f, offset + count)) < 0)
  801009:	83 ec 08             	sub    $0x8,%esp
  80100c:	50                   	push   %eax
  80100d:	51                   	push   %ecx
  80100e:	e8 87 fe ff ff       	call   800e9a <file_set_size>
  801013:	83 c4 10             	add    $0x10,%esp
  801016:	85 c0                	test   %eax,%eax
  801018:	79 87                	jns    800fa1 <file_write+0x26>
  80101a:	eb 03                	jmp    80101f <file_write+0xa4>
	return count;
  80101c:	8b 45 10             	mov    0x10(%ebp),%eax
}
  80101f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801022:	5b                   	pop    %ebx
  801023:	5e                   	pop    %esi
  801024:	5f                   	pop    %edi
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801027:	f3 0f 1e fb          	endbr32 
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
  801030:	83 ec 10             	sub    $0x10,%esp
  801033:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801036:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103b:	eb 03                	jmp    801040 <file_flush+0x19>
  80103d:	83 c3 01             	add    $0x1,%ebx
  801040:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  801046:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  80104c:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801052:	0f 49 c2             	cmovns %edx,%eax
  801055:	c1 f8 0c             	sar    $0xc,%eax
  801058:	39 d8                	cmp    %ebx,%eax
  80105a:	7e 3b                	jle    801097 <file_flush+0x70>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80105c:	83 ec 0c             	sub    $0xc,%esp
  80105f:	6a 00                	push   $0x0
  801061:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  801064:	89 da                	mov    %ebx,%edx
  801066:	89 f0                	mov    %esi,%eax
  801068:	e8 da f8 ff ff       	call   800947 <file_block_walk>
  80106d:	83 c4 10             	add    $0x10,%esp
  801070:	85 c0                	test   %eax,%eax
  801072:	78 c9                	js     80103d <file_flush+0x16>
		    pdiskbno == NULL || *pdiskbno == 0)
  801074:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801077:	85 c0                	test   %eax,%eax
  801079:	74 c2                	je     80103d <file_flush+0x16>
		    pdiskbno == NULL || *pdiskbno == 0)
  80107b:	8b 00                	mov    (%eax),%eax
  80107d:	85 c0                	test   %eax,%eax
  80107f:	74 bc                	je     80103d <file_flush+0x16>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801081:	83 ec 0c             	sub    $0xc,%esp
  801084:	50                   	push   %eax
  801085:	e8 32 f3 ff ff       	call   8003bc <diskaddr>
  80108a:	89 04 24             	mov    %eax,(%esp)
  80108d:	e8 b4 f3 ff ff       	call   800446 <flush_block>
  801092:	83 c4 10             	add    $0x10,%esp
  801095:	eb a6                	jmp    80103d <file_flush+0x16>
	}
	flush_block(f);
  801097:	83 ec 0c             	sub    $0xc,%esp
  80109a:	56                   	push   %esi
  80109b:	e8 a6 f3 ff ff       	call   800446 <flush_block>
	if (f->f_indirect)
  8010a0:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  8010a6:	83 c4 10             	add    $0x10,%esp
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	75 07                	jne    8010b4 <file_flush+0x8d>
		flush_block(diskaddr(f->f_indirect));
}
  8010ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5d                   	pop    %ebp
  8010b3:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  8010b4:	83 ec 0c             	sub    $0xc,%esp
  8010b7:	50                   	push   %eax
  8010b8:	e8 ff f2 ff ff       	call   8003bc <diskaddr>
  8010bd:	89 04 24             	mov    %eax,(%esp)
  8010c0:	e8 81 f3 ff ff       	call   800446 <flush_block>
  8010c5:	83 c4 10             	add    $0x10,%esp
}
  8010c8:	eb e3                	jmp    8010ad <file_flush+0x86>

008010ca <file_create>:
{
  8010ca:	f3 0f 1e fb          	endbr32 
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	57                   	push   %edi
  8010d2:	56                   	push   %esi
  8010d3:	53                   	push   %ebx
  8010d4:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  8010da:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8010e0:	50                   	push   %eax
  8010e1:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  8010e7:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	e8 aa fa ff ff       	call   800b9f <walk_path>
  8010f5:	83 c4 10             	add    $0x10,%esp
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	0f 84 0b 01 00 00    	je     80120b <file_create+0x141>
	if (r != -E_NOT_FOUND || dir == 0)
  801100:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801103:	0f 85 ca 00 00 00    	jne    8011d3 <file_create+0x109>
  801109:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  80110f:	85 f6                	test   %esi,%esi
  801111:	0f 84 bc 00 00 00    	je     8011d3 <file_create+0x109>
	assert((dir->f_size % BLKSIZE) == 0);
  801117:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  80111d:	89 c3                	mov    %eax,%ebx
  80111f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  801125:	75 57                	jne    80117e <file_create+0xb4>
	nblock = dir->f_size / BLKSIZE;
  801127:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  80112d:	85 c0                	test   %eax,%eax
  80112f:	0f 48 c2             	cmovs  %edx,%eax
  801132:	c1 f8 0c             	sar    $0xc,%eax
  801135:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		if ((r = file_get_block(dir, i, &blk)) < 0)
  80113b:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
	for (i = 0; i < nblock; i++) {
  801141:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  801147:	0f 84 8e 00 00 00    	je     8011db <file_create+0x111>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  80114d:	83 ec 04             	sub    $0x4,%esp
  801150:	57                   	push   %edi
  801151:	53                   	push   %ebx
  801152:	56                   	push   %esi
  801153:	e8 be f9 ff ff       	call   800b16 <file_get_block>
  801158:	83 c4 10             	add    $0x10,%esp
  80115b:	85 c0                	test   %eax,%eax
  80115d:	78 74                	js     8011d3 <file_create+0x109>
  80115f:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801165:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
			if (f[j].f_name[0] == '\0') {
  80116b:	80 38 00             	cmpb   $0x0,(%eax)
  80116e:	74 27                	je     801197 <file_create+0xcd>
  801170:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  801175:	39 d0                	cmp    %edx,%eax
  801177:	75 f2                	jne    80116b <file_create+0xa1>
	for (i = 0; i < nblock; i++) {
  801179:	83 c3 01             	add    $0x1,%ebx
  80117c:	eb c3                	jmp    801141 <file_create+0x77>
	assert((dir->f_size % BLKSIZE) == 0);
  80117e:	68 0c 43 80 00       	push   $0x80430c
  801183:	68 7d 40 80 00       	push   $0x80407d
  801188:	68 09 01 00 00       	push   $0x109
  80118d:	68 74 42 80 00       	push   $0x804274
  801192:	e8 44 0a 00 00       	call   801bdb <_panic>
				*file = &f[j];
  801197:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  80119d:	83 ec 08             	sub    $0x8,%esp
  8011a0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8011a6:	50                   	push   %eax
  8011a7:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  8011ad:	e8 1a 11 00 00       	call   8022cc <strcpy>
	*pf = f;
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  8011bb:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  8011bd:	83 c4 04             	add    $0x4,%esp
  8011c0:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
  8011c6:	e8 5c fe ff ff       	call   801027 <file_flush>
	return 0;
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d6:	5b                   	pop    %ebx
  8011d7:	5e                   	pop    %esi
  8011d8:	5f                   	pop    %edi
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    
	dir->f_size += BLKSIZE;
  8011db:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  8011e2:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  8011e5:	83 ec 04             	sub    $0x4,%esp
  8011e8:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  8011ee:	50                   	push   %eax
  8011ef:	53                   	push   %ebx
  8011f0:	56                   	push   %esi
  8011f1:	e8 20 f9 ff ff       	call   800b16 <file_get_block>
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	78 d6                	js     8011d3 <file_create+0x109>
	*file = &f[0];
  8011fd:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801203:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	return 0;
  801209:	eb 92                	jmp    80119d <file_create+0xd3>
		return -E_FILE_EXISTS;
  80120b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801210:	eb c1                	jmp    8011d3 <file_create+0x109>

00801212 <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801212:	f3 0f 1e fb          	endbr32 
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	53                   	push   %ebx
  80121a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  80121d:	bb 01 00 00 00       	mov    $0x1,%ebx
  801222:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  801227:	39 58 04             	cmp    %ebx,0x4(%eax)
  80122a:	76 19                	jbe    801245 <fs_sync+0x33>
		flush_block(diskaddr(i));
  80122c:	83 ec 0c             	sub    $0xc,%esp
  80122f:	53                   	push   %ebx
  801230:	e8 87 f1 ff ff       	call   8003bc <diskaddr>
  801235:	89 04 24             	mov    %eax,(%esp)
  801238:	e8 09 f2 ff ff       	call   800446 <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  80123d:	83 c3 01             	add    $0x1,%ebx
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	eb dd                	jmp    801222 <fs_sync+0x10>
}
  801245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  80124a:	f3 0f 1e fb          	endbr32 
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  801254:	e8 b9 ff ff ff       	call   801212 <fs_sync>
	return 0;
}
  801259:	b8 00 00 00 00       	mov    $0x0,%eax
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    

00801260 <serve_init>:
{
  801260:	f3 0f 1e fb          	endbr32 
  801264:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  801269:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  80126e:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801273:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  801275:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  801278:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  80127e:	83 c0 01             	add    $0x1,%eax
  801281:	83 c2 10             	add    $0x10,%edx
  801284:	3d 00 04 00 00       	cmp    $0x400,%eax
  801289:	75 e8                	jne    801273 <serve_init+0x13>
}
  80128b:	c3                   	ret    

0080128c <openfile_alloc>:
{
  80128c:	f3 0f 1e fb          	endbr32 
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	57                   	push   %edi
  801294:	56                   	push   %esi
  801295:	53                   	push   %ebx
  801296:	83 ec 0c             	sub    $0xc,%esp
  801299:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  80129c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a1:	89 de                	mov    %ebx,%esi
  8012a3:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  8012a6:	83 ec 0c             	sub    $0xc,%esp
  8012a9:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
  8012af:	e8 1c 21 00 00       	call   8033d0 <pageref>
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	74 17                	je     8012d2 <openfile_alloc+0x46>
  8012bb:	83 f8 01             	cmp    $0x1,%eax
  8012be:	74 30                	je     8012f0 <openfile_alloc+0x64>
	for (i = 0; i < MAXOPEN; i++) {
  8012c0:	83 c3 01             	add    $0x1,%ebx
  8012c3:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8012c9:	75 d6                	jne    8012a1 <openfile_alloc+0x15>
	return -E_MAX_OPEN;
  8012cb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012d0:	eb 4f                	jmp    801321 <openfile_alloc+0x95>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  8012d2:	83 ec 04             	sub    $0x4,%esp
  8012d5:	6a 07                	push   $0x7
  8012d7:	89 d8                	mov    %ebx,%eax
  8012d9:	c1 e0 04             	shl    $0x4,%eax
  8012dc:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  8012e2:	6a 00                	push   $0x0
  8012e4:	e8 25 14 00 00       	call   80270e <sys_page_alloc>
  8012e9:	83 c4 10             	add    $0x10,%esp
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	78 31                	js     801321 <openfile_alloc+0x95>
			opentab[i].o_fileid += MAXOPEN;
  8012f0:	c1 e3 04             	shl    $0x4,%ebx
  8012f3:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  8012fa:	04 00 00 
			*o = &opentab[i];
  8012fd:	81 c6 60 50 80 00    	add    $0x805060,%esi
  801303:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  801305:	83 ec 04             	sub    $0x4,%esp
  801308:	68 00 10 00 00       	push   $0x1000
  80130d:	6a 00                	push   $0x0
  80130f:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  801315:	e8 1c 11 00 00       	call   802436 <memset>
			return (*o)->o_fileid;
  80131a:	8b 07                	mov    (%edi),%eax
  80131c:	8b 00                	mov    (%eax),%eax
  80131e:	83 c4 10             	add    $0x10,%esp
}
  801321:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801324:	5b                   	pop    %ebx
  801325:	5e                   	pop    %esi
  801326:	5f                   	pop    %edi
  801327:	5d                   	pop    %ebp
  801328:	c3                   	ret    

00801329 <openfile_lookup>:
{
  801329:	f3 0f 1e fb          	endbr32 
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	57                   	push   %edi
  801331:	56                   	push   %esi
  801332:	53                   	push   %ebx
  801333:	83 ec 18             	sub    $0x18,%esp
  801336:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  801339:	89 fb                	mov    %edi,%ebx
  80133b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  801341:	89 de                	mov    %ebx,%esi
  801343:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  801346:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  80134c:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  801352:	e8 79 20 00 00       	call   8033d0 <pageref>
  801357:	83 c4 10             	add    $0x10,%esp
  80135a:	83 f8 01             	cmp    $0x1,%eax
  80135d:	7e 1d                	jle    80137c <openfile_lookup+0x53>
  80135f:	c1 e3 04             	shl    $0x4,%ebx
  801362:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  801368:	75 19                	jne    801383 <openfile_lookup+0x5a>
	*po = o;
  80136a:	8b 45 10             	mov    0x10(%ebp),%eax
  80136d:	89 30                	mov    %esi,(%eax)
	return 0;
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801374:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801377:	5b                   	pop    %ebx
  801378:	5e                   	pop    %esi
  801379:	5f                   	pop    %edi
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    
		return -E_INVAL;
  80137c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801381:	eb f1                	jmp    801374 <openfile_lookup+0x4b>
  801383:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801388:	eb ea                	jmp    801374 <openfile_lookup+0x4b>

0080138a <serve_set_size>:
{
  80138a:	f3 0f 1e fb          	endbr32 
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	53                   	push   %ebx
  801392:	83 ec 18             	sub    $0x18,%esp
  801395:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801398:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139b:	50                   	push   %eax
  80139c:	ff 33                	pushl  (%ebx)
  80139e:	ff 75 08             	pushl  0x8(%ebp)
  8013a1:	e8 83 ff ff ff       	call   801329 <openfile_lookup>
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	78 14                	js     8013c1 <serve_set_size+0x37>
	return file_set_size(o->o_file, req->req_size);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	ff 73 04             	pushl  0x4(%ebx)
  8013b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b6:	ff 70 04             	pushl  0x4(%eax)
  8013b9:	e8 dc fa ff ff       	call   800e9a <file_set_size>
  8013be:	83 c4 10             	add    $0x10,%esp
}
  8013c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <serve_read>:
{
  8013c6:	f3 0f 1e fb          	endbr32 
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	53                   	push   %ebx
  8013ce:	83 ec 18             	sub    $0x18,%esp
  8013d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d7:	50                   	push   %eax
  8013d8:	ff 33                	pushl  (%ebx)
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	e8 47 ff ff ff       	call   801329 <openfile_lookup>
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	78 25                	js     80140e <serve_read+0x48>
	if((r = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset)) < 0)
  8013e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8013ef:	ff 72 04             	pushl  0x4(%edx)
  8013f2:	ff 73 04             	pushl  0x4(%ebx)
  8013f5:	53                   	push   %ebx
  8013f6:	ff 70 04             	pushl  0x4(%eax)
  8013f9:	e8 ee f9 ff ff       	call   800dec <file_read>
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	78 09                	js     80140e <serve_read+0x48>
	o->o_fd->fd_offset += r;
  801405:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801408:	8b 52 0c             	mov    0xc(%edx),%edx
  80140b:	01 42 04             	add    %eax,0x4(%edx)
}
  80140e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <serve_write>:
{
  801413:	f3 0f 1e fb          	endbr32 
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	53                   	push   %ebx
  80141b:	83 ec 18             	sub    $0x18,%esp
  80141e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801421:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801424:	50                   	push   %eax
  801425:	ff 33                	pushl  (%ebx)
  801427:	ff 75 08             	pushl  0x8(%ebp)
  80142a:	e8 fa fe ff ff       	call   801329 <openfile_lookup>
  80142f:	83 c4 10             	add    $0x10,%esp
  801432:	85 c0                	test   %eax,%eax
  801434:	78 2b                	js     801461 <serve_write+0x4e>
	if ((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0)
  801436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801439:	8b 50 0c             	mov    0xc(%eax),%edx
  80143c:	ff 72 04             	pushl  0x4(%edx)
  80143f:	ff 73 04             	pushl  0x4(%ebx)
  801442:	8d 53 08             	lea    0x8(%ebx),%edx
  801445:	52                   	push   %edx
  801446:	ff 70 04             	pushl  0x4(%eax)
  801449:	e8 2d fb ff ff       	call   800f7b <file_write>
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	78 0c                	js     801461 <serve_write+0x4e>
	o->o_fd->fd_offset += req->req_n;
  801455:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801458:	8b 52 0c             	mov    0xc(%edx),%edx
  80145b:	8b 4b 04             	mov    0x4(%ebx),%ecx
  80145e:	01 4a 04             	add    %ecx,0x4(%edx)
}
  801461:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <serve_stat>:
{
  801466:	f3 0f 1e fb          	endbr32 
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	53                   	push   %ebx
  80146e:	83 ec 18             	sub    $0x18,%esp
  801471:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801474:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801477:	50                   	push   %eax
  801478:	ff 33                	pushl  (%ebx)
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	e8 a7 fe ff ff       	call   801329 <openfile_lookup>
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 3f                	js     8014c8 <serve_stat+0x62>
	strcpy(ret->ret_name, o->o_file->f_name);
  801489:	83 ec 08             	sub    $0x8,%esp
  80148c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148f:	ff 70 04             	pushl  0x4(%eax)
  801492:	53                   	push   %ebx
  801493:	e8 34 0e 00 00       	call   8022cc <strcpy>
	ret->ret_size = o->o_file->f_size;
  801498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149b:	8b 50 04             	mov    0x4(%eax),%edx
  80149e:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  8014a4:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8014aa:	8b 40 04             	mov    0x4(%eax),%eax
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  8014b7:	0f 94 c0             	sete   %al
  8014ba:	0f b6 c0             	movzbl %al,%eax
  8014bd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <serve_flush>:
{
  8014cd:	f3 0f 1e fb          	endbr32 
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8014d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014da:	50                   	push   %eax
  8014db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014de:	ff 30                	pushl  (%eax)
  8014e0:	ff 75 08             	pushl  0x8(%ebp)
  8014e3:	e8 41 fe ff ff       	call   801329 <openfile_lookup>
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 16                	js     801505 <serve_flush+0x38>
	file_flush(o->o_file);
  8014ef:	83 ec 0c             	sub    $0xc,%esp
  8014f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f5:	ff 70 04             	pushl  0x4(%eax)
  8014f8:	e8 2a fb ff ff       	call   801027 <file_flush>
	return 0;
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <serve_open>:
{
  801507:	f3 0f 1e fb          	endbr32 
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	53                   	push   %ebx
  80150f:	81 ec 18 04 00 00    	sub    $0x418,%esp
  801515:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  801518:	68 00 04 00 00       	push   $0x400
  80151d:	53                   	push   %ebx
  80151e:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801524:	50                   	push   %eax
  801525:	e8 58 0f 00 00       	call   802482 <memmove>
	path[MAXPATHLEN-1] = 0;
  80152a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  80152e:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801534:	89 04 24             	mov    %eax,(%esp)
  801537:	e8 50 fd ff ff       	call   80128c <openfile_alloc>
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	0f 88 f0 00 00 00    	js     801637 <serve_open+0x130>
	if (req->req_omode & O_CREAT) {
  801547:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  80154e:	74 33                	je     801583 <serve_open+0x7c>
		if ((r = file_create(path, &f)) < 0) {
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801559:	50                   	push   %eax
  80155a:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801560:	50                   	push   %eax
  801561:	e8 64 fb ff ff       	call   8010ca <file_create>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	85 c0                	test   %eax,%eax
  80156b:	79 37                	jns    8015a4 <serve_open+0x9d>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  80156d:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801574:	0f 85 bd 00 00 00    	jne    801637 <serve_open+0x130>
  80157a:	83 f8 f3             	cmp    $0xfffffff3,%eax
  80157d:	0f 85 b4 00 00 00    	jne    801637 <serve_open+0x130>
		if ((r = file_open(path, &f)) < 0) {
  801583:	83 ec 08             	sub    $0x8,%esp
  801586:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80158c:	50                   	push   %eax
  80158d:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801593:	50                   	push   %eax
  801594:	e8 35 f8 ff ff       	call   800dce <file_open>
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	85 c0                	test   %eax,%eax
  80159e:	0f 88 93 00 00 00    	js     801637 <serve_open+0x130>
	if (req->req_omode & O_TRUNC) {
  8015a4:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  8015ab:	74 17                	je     8015c4 <serve_open+0xbd>
		if ((r = file_set_size(f, 0)) < 0) {
  8015ad:	83 ec 08             	sub    $0x8,%esp
  8015b0:	6a 00                	push   $0x0
  8015b2:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  8015b8:	e8 dd f8 ff ff       	call   800e9a <file_set_size>
  8015bd:	83 c4 10             	add    $0x10,%esp
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	78 73                	js     801637 <serve_open+0x130>
	if ((r = file_open(path, &f)) < 0) {
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8015cd:	50                   	push   %eax
  8015ce:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015d4:	50                   	push   %eax
  8015d5:	e8 f4 f7 ff ff       	call   800dce <file_open>
  8015da:	83 c4 10             	add    $0x10,%esp
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	78 56                	js     801637 <serve_open+0x130>
	o->o_file = f;
  8015e1:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8015e7:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  8015ed:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  8015f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8015f3:	8b 08                	mov    (%eax),%ecx
  8015f5:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  8015f8:	8b 48 0c             	mov    0xc(%eax),%ecx
  8015fb:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801601:	83 e2 03             	and    $0x3,%edx
  801604:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801607:	8b 40 0c             	mov    0xc(%eax),%eax
  80160a:	8b 15 64 90 80 00    	mov    0x809064,%edx
  801610:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  801612:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801618:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80161e:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  801621:	8b 50 0c             	mov    0xc(%eax),%edx
  801624:	8b 45 10             	mov    0x10(%ebp),%eax
  801627:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  801629:	8b 45 14             	mov    0x14(%ebp),%eax
  80162c:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  801632:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801637:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  80163c:	f3 0f 1e fb          	endbr32 
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	56                   	push   %esi
  801644:	53                   	push   %ebx
  801645:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801648:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  80164b:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80164e:	e9 82 00 00 00       	jmp    8016d5 <serve+0x99>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  801653:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  80165a:	83 f8 01             	cmp    $0x1,%eax
  80165d:	74 23                	je     801682 <serve+0x46>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  80165f:	83 f8 08             	cmp    $0x8,%eax
  801662:	77 36                	ja     80169a <serve+0x5e>
  801664:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  80166b:	85 d2                	test   %edx,%edx
  80166d:	74 2b                	je     80169a <serve+0x5e>
			r = handlers[req](whom, fsreq);
  80166f:	83 ec 08             	sub    $0x8,%esp
  801672:	ff 35 44 50 80 00    	pushl  0x805044
  801678:	ff 75 f4             	pushl  -0xc(%ebp)
  80167b:	ff d2                	call   *%edx
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	eb 31                	jmp    8016b3 <serve+0x77>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  801682:	53                   	push   %ebx
  801683:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801686:	50                   	push   %eax
  801687:	ff 35 44 50 80 00    	pushl  0x805044
  80168d:	ff 75 f4             	pushl  -0xc(%ebp)
  801690:	e8 72 fe ff ff       	call   801507 <serve_open>
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	eb 19                	jmp    8016b3 <serve+0x77>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a0:	50                   	push   %eax
  8016a1:	68 78 43 80 00       	push   $0x804378
  8016a6:	e8 17 06 00 00       	call   801cc2 <cprintf>
  8016ab:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  8016ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  8016b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8016b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b9:	50                   	push   %eax
  8016ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8016bd:	e8 2a 14 00 00       	call   802aec <ipc_send>
		sys_page_unmap(0, fsreq);
  8016c2:	83 c4 08             	add    $0x8,%esp
  8016c5:	ff 35 44 50 80 00    	pushl  0x805044
  8016cb:	6a 00                	push   $0x0
  8016cd:	e8 c9 10 00 00       	call   80279b <sys_page_unmap>
  8016d2:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  8016d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	53                   	push   %ebx
  8016e0:	ff 35 44 50 80 00    	pushl  0x805044
  8016e6:	56                   	push   %esi
  8016e7:	e8 7b 13 00 00       	call   802a67 <ipc_recv>
		if (!(perm & PTE_P)) {
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  8016f3:	0f 85 5a ff ff ff    	jne    801653 <serve+0x17>
			cprintf("Invalid request from %08x: no argument page\n",
  8016f9:	83 ec 08             	sub    $0x8,%esp
  8016fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ff:	68 48 43 80 00       	push   $0x804348
  801704:	e8 b9 05 00 00       	call   801cc2 <cprintf>
			continue; // just leave it hanging...
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	eb c7                	jmp    8016d5 <serve+0x99>

0080170e <umain>:
	}
}

void
umain(int argc, char **argv)
{
  80170e:	f3 0f 1e fb          	endbr32 
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801718:	c7 05 60 90 80 00 9b 	movl   $0x80439b,0x809060
  80171f:	43 80 00 
	cprintf("FS is running\n");
  801722:	68 9e 43 80 00       	push   $0x80439e
  801727:	e8 96 05 00 00       	call   801cc2 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80172c:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  801731:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801736:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  801738:	c7 04 24 ad 43 80 00 	movl   $0x8043ad,(%esp)
  80173f:	e8 7e 05 00 00       	call   801cc2 <cprintf>

	serve_init();
  801744:	e8 17 fb ff ff       	call   801260 <serve_init>
	fs_init();
  801749:	e8 65 f3 ff ff       	call   800ab3 <fs_init>
	serve();
  80174e:	e8 e9 fe ff ff       	call   80163c <serve>

00801753 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  801753:	f3 0f 1e fb          	endbr32 
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	53                   	push   %ebx
  80175b:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80175e:	6a 07                	push   $0x7
  801760:	68 00 10 00 00       	push   $0x1000
  801765:	6a 00                	push   $0x0
  801767:	e8 a2 0f 00 00       	call   80270e <sys_page_alloc>
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	85 c0                	test   %eax,%eax
  801771:	0f 88 68 02 00 00    	js     8019df <fs_test+0x28c>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	68 00 10 00 00       	push   $0x1000
  80177f:	ff 35 08 a0 80 00    	pushl  0x80a008
  801785:	68 00 10 00 00       	push   $0x1000
  80178a:	e8 f3 0c 00 00       	call   802482 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  80178f:	e8 45 f1 ff ff       	call   8008d9 <alloc_block>
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	85 c0                	test   %eax,%eax
  801799:	0f 88 52 02 00 00    	js     8019f1 <fs_test+0x29e>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  80179f:	8d 50 1f             	lea    0x1f(%eax),%edx
  8017a2:	0f 49 d0             	cmovns %eax,%edx
  8017a5:	c1 fa 05             	sar    $0x5,%edx
  8017a8:	89 c3                	mov    %eax,%ebx
  8017aa:	c1 fb 1f             	sar    $0x1f,%ebx
  8017ad:	c1 eb 1b             	shr    $0x1b,%ebx
  8017b0:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  8017b3:	83 e1 1f             	and    $0x1f,%ecx
  8017b6:	29 d9                	sub    %ebx,%ecx
  8017b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017bd:	d3 e0                	shl    %cl,%eax
  8017bf:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  8017c6:	0f 84 37 02 00 00    	je     801a03 <fs_test+0x2b0>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8017cc:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
  8017d2:	85 04 91             	test   %eax,(%ecx,%edx,4)
  8017d5:	0f 85 3e 02 00 00    	jne    801a19 <fs_test+0x2c6>
	cprintf("alloc_block is good\n");
  8017db:	83 ec 0c             	sub    $0xc,%esp
  8017de:	68 04 44 80 00       	push   $0x804404
  8017e3:	e8 da 04 00 00       	call   801cc2 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  8017e8:	83 c4 08             	add    $0x8,%esp
  8017eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ee:	50                   	push   %eax
  8017ef:	68 19 44 80 00       	push   $0x804419
  8017f4:	e8 d5 f5 ff ff       	call   800dce <file_open>
  8017f9:	83 c4 10             	add    $0x10,%esp
  8017fc:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8017ff:	74 08                	je     801809 <fs_test+0xb6>
  801801:	85 c0                	test   %eax,%eax
  801803:	0f 88 26 02 00 00    	js     801a2f <fs_test+0x2dc>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  801809:	85 c0                	test   %eax,%eax
  80180b:	0f 84 30 02 00 00    	je     801a41 <fs_test+0x2ee>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  801811:	83 ec 08             	sub    $0x8,%esp
  801814:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801817:	50                   	push   %eax
  801818:	68 3d 44 80 00       	push   $0x80443d
  80181d:	e8 ac f5 ff ff       	call   800dce <file_open>
  801822:	83 c4 10             	add    $0x10,%esp
  801825:	85 c0                	test   %eax,%eax
  801827:	0f 88 28 02 00 00    	js     801a55 <fs_test+0x302>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  80182d:	83 ec 0c             	sub    $0xc,%esp
  801830:	68 5d 44 80 00       	push   $0x80445d
  801835:	e8 88 04 00 00       	call   801cc2 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  80183a:	83 c4 0c             	add    $0xc,%esp
  80183d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801840:	50                   	push   %eax
  801841:	6a 00                	push   $0x0
  801843:	ff 75 f4             	pushl  -0xc(%ebp)
  801846:	e8 cb f2 ff ff       	call   800b16 <file_get_block>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	0f 88 11 02 00 00    	js     801a67 <fs_test+0x314>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  801856:	83 ec 08             	sub    $0x8,%esp
  801859:	68 a4 45 80 00       	push   $0x8045a4
  80185e:	ff 75 f0             	pushl  -0x10(%ebp)
  801861:	e8 25 0b 00 00       	call   80238b <strcmp>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	85 c0                	test   %eax,%eax
  80186b:	0f 85 08 02 00 00    	jne    801a79 <fs_test+0x326>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  801871:	83 ec 0c             	sub    $0xc,%esp
  801874:	68 83 44 80 00       	push   $0x804483
  801879:	e8 44 04 00 00       	call   801cc2 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  80187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801881:	0f b6 10             	movzbl (%eax),%edx
  801884:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801889:	c1 e8 0c             	shr    $0xc,%eax
  80188c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	a8 40                	test   $0x40,%al
  801898:	0f 84 ef 01 00 00    	je     801a8d <fs_test+0x33a>
	file_flush(f);
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a4:	e8 7e f7 ff ff       	call   801027 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8018a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ac:	c1 e8 0c             	shr    $0xc,%eax
  8018af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	a8 40                	test   $0x40,%al
  8018bb:	0f 85 e2 01 00 00    	jne    801aa3 <fs_test+0x350>
	cprintf("file_flush is good\n");
  8018c1:	83 ec 0c             	sub    $0xc,%esp
  8018c4:	68 b7 44 80 00       	push   $0x8044b7
  8018c9:	e8 f4 03 00 00       	call   801cc2 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  8018ce:	83 c4 08             	add    $0x8,%esp
  8018d1:	6a 00                	push   $0x0
  8018d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d6:	e8 bf f5 ff ff       	call   800e9a <file_set_size>
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	85 c0                	test   %eax,%eax
  8018e0:	0f 88 d3 01 00 00    	js     801ab9 <fs_test+0x366>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  8018e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e9:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  8018f0:	0f 85 d5 01 00 00    	jne    801acb <fs_test+0x378>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8018f6:	c1 e8 0c             	shr    $0xc,%eax
  8018f9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801900:	a8 40                	test   $0x40,%al
  801902:	0f 85 d9 01 00 00    	jne    801ae1 <fs_test+0x38e>
	cprintf("file_truncate is good\n");
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	68 0b 45 80 00       	push   $0x80450b
  801910:	e8 ad 03 00 00       	call   801cc2 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801915:	c7 04 24 a4 45 80 00 	movl   $0x8045a4,(%esp)
  80191c:	e8 68 09 00 00       	call   802289 <strlen>
  801921:	83 c4 08             	add    $0x8,%esp
  801924:	50                   	push   %eax
  801925:	ff 75 f4             	pushl  -0xc(%ebp)
  801928:	e8 6d f5 ff ff       	call   800e9a <file_set_size>
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	0f 88 bf 01 00 00    	js     801af7 <fs_test+0x3a4>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193b:	89 c2                	mov    %eax,%edx
  80193d:	c1 ea 0c             	shr    $0xc,%edx
  801940:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801947:	f6 c2 40             	test   $0x40,%dl
  80194a:	0f 85 b9 01 00 00    	jne    801b09 <fs_test+0x3b6>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801956:	52                   	push   %edx
  801957:	6a 00                	push   $0x0
  801959:	50                   	push   %eax
  80195a:	e8 b7 f1 ff ff       	call   800b16 <file_get_block>
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	85 c0                	test   %eax,%eax
  801964:	0f 88 b5 01 00 00    	js     801b1f <fs_test+0x3cc>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	68 a4 45 80 00       	push   $0x8045a4
  801972:	ff 75 f0             	pushl  -0x10(%ebp)
  801975:	e8 52 09 00 00       	call   8022cc <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80197a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197d:	c1 e8 0c             	shr    $0xc,%eax
  801980:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	a8 40                	test   $0x40,%al
  80198c:	0f 84 9f 01 00 00    	je     801b31 <fs_test+0x3de>
	file_flush(f);
  801992:	83 ec 0c             	sub    $0xc,%esp
  801995:	ff 75 f4             	pushl  -0xc(%ebp)
  801998:	e8 8a f6 ff ff       	call   801027 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80199d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a0:	c1 e8 0c             	shr    $0xc,%eax
  8019a3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019aa:	83 c4 10             	add    $0x10,%esp
  8019ad:	a8 40                	test   $0x40,%al
  8019af:	0f 85 92 01 00 00    	jne    801b47 <fs_test+0x3f4>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	c1 e8 0c             	shr    $0xc,%eax
  8019bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019c2:	a8 40                	test   $0x40,%al
  8019c4:	0f 85 93 01 00 00    	jne    801b5d <fs_test+0x40a>
	cprintf("file rewrite is good\n");
  8019ca:	83 ec 0c             	sub    $0xc,%esp
  8019cd:	68 4b 45 80 00       	push   $0x80454b
  8019d2:	e8 eb 02 00 00       	call   801cc2 <cprintf>
}
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8019df:	50                   	push   %eax
  8019e0:	68 bc 43 80 00       	push   $0x8043bc
  8019e5:	6a 12                	push   $0x12
  8019e7:	68 cf 43 80 00       	push   $0x8043cf
  8019ec:	e8 ea 01 00 00       	call   801bdb <_panic>
		panic("alloc_block: %e", r);
  8019f1:	50                   	push   %eax
  8019f2:	68 d9 43 80 00       	push   $0x8043d9
  8019f7:	6a 17                	push   $0x17
  8019f9:	68 cf 43 80 00       	push   $0x8043cf
  8019fe:	e8 d8 01 00 00       	call   801bdb <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801a03:	68 e9 43 80 00       	push   $0x8043e9
  801a08:	68 7d 40 80 00       	push   $0x80407d
  801a0d:	6a 19                	push   $0x19
  801a0f:	68 cf 43 80 00       	push   $0x8043cf
  801a14:	e8 c2 01 00 00       	call   801bdb <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801a19:	68 64 45 80 00       	push   $0x804564
  801a1e:	68 7d 40 80 00       	push   $0x80407d
  801a23:	6a 1b                	push   $0x1b
  801a25:	68 cf 43 80 00       	push   $0x8043cf
  801a2a:	e8 ac 01 00 00       	call   801bdb <_panic>
		panic("file_open /not-found: %e", r);
  801a2f:	50                   	push   %eax
  801a30:	68 24 44 80 00       	push   $0x804424
  801a35:	6a 1f                	push   $0x1f
  801a37:	68 cf 43 80 00       	push   $0x8043cf
  801a3c:	e8 9a 01 00 00       	call   801bdb <_panic>
		panic("file_open /not-found succeeded!");
  801a41:	83 ec 04             	sub    $0x4,%esp
  801a44:	68 84 45 80 00       	push   $0x804584
  801a49:	6a 21                	push   $0x21
  801a4b:	68 cf 43 80 00       	push   $0x8043cf
  801a50:	e8 86 01 00 00       	call   801bdb <_panic>
		panic("file_open /newmotd: %e", r);
  801a55:	50                   	push   %eax
  801a56:	68 46 44 80 00       	push   $0x804446
  801a5b:	6a 23                	push   $0x23
  801a5d:	68 cf 43 80 00       	push   $0x8043cf
  801a62:	e8 74 01 00 00       	call   801bdb <_panic>
		panic("file_get_block: %e", r);
  801a67:	50                   	push   %eax
  801a68:	68 70 44 80 00       	push   $0x804470
  801a6d:	6a 27                	push   $0x27
  801a6f:	68 cf 43 80 00       	push   $0x8043cf
  801a74:	e8 62 01 00 00       	call   801bdb <_panic>
		panic("file_get_block returned wrong data");
  801a79:	83 ec 04             	sub    $0x4,%esp
  801a7c:	68 cc 45 80 00       	push   $0x8045cc
  801a81:	6a 29                	push   $0x29
  801a83:	68 cf 43 80 00       	push   $0x8043cf
  801a88:	e8 4e 01 00 00       	call   801bdb <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a8d:	68 9c 44 80 00       	push   $0x80449c
  801a92:	68 7d 40 80 00       	push   $0x80407d
  801a97:	6a 2d                	push   $0x2d
  801a99:	68 cf 43 80 00       	push   $0x8043cf
  801a9e:	e8 38 01 00 00       	call   801bdb <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801aa3:	68 9b 44 80 00       	push   $0x80449b
  801aa8:	68 7d 40 80 00       	push   $0x80407d
  801aad:	6a 2f                	push   $0x2f
  801aaf:	68 cf 43 80 00       	push   $0x8043cf
  801ab4:	e8 22 01 00 00       	call   801bdb <_panic>
		panic("file_set_size: %e", r);
  801ab9:	50                   	push   %eax
  801aba:	68 cb 44 80 00       	push   $0x8044cb
  801abf:	6a 33                	push   $0x33
  801ac1:	68 cf 43 80 00       	push   $0x8043cf
  801ac6:	e8 10 01 00 00       	call   801bdb <_panic>
	assert(f->f_direct[0] == 0);
  801acb:	68 dd 44 80 00       	push   $0x8044dd
  801ad0:	68 7d 40 80 00       	push   $0x80407d
  801ad5:	6a 34                	push   $0x34
  801ad7:	68 cf 43 80 00       	push   $0x8043cf
  801adc:	e8 fa 00 00 00       	call   801bdb <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801ae1:	68 f1 44 80 00       	push   $0x8044f1
  801ae6:	68 7d 40 80 00       	push   $0x80407d
  801aeb:	6a 35                	push   $0x35
  801aed:	68 cf 43 80 00       	push   $0x8043cf
  801af2:	e8 e4 00 00 00       	call   801bdb <_panic>
		panic("file_set_size 2: %e", r);
  801af7:	50                   	push   %eax
  801af8:	68 22 45 80 00       	push   $0x804522
  801afd:	6a 39                	push   $0x39
  801aff:	68 cf 43 80 00       	push   $0x8043cf
  801b04:	e8 d2 00 00 00       	call   801bdb <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b09:	68 f1 44 80 00       	push   $0x8044f1
  801b0e:	68 7d 40 80 00       	push   $0x80407d
  801b13:	6a 3a                	push   $0x3a
  801b15:	68 cf 43 80 00       	push   $0x8043cf
  801b1a:	e8 bc 00 00 00       	call   801bdb <_panic>
		panic("file_get_block 2: %e", r);
  801b1f:	50                   	push   %eax
  801b20:	68 36 45 80 00       	push   $0x804536
  801b25:	6a 3c                	push   $0x3c
  801b27:	68 cf 43 80 00       	push   $0x8043cf
  801b2c:	e8 aa 00 00 00       	call   801bdb <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801b31:	68 9c 44 80 00       	push   $0x80449c
  801b36:	68 7d 40 80 00       	push   $0x80407d
  801b3b:	6a 3e                	push   $0x3e
  801b3d:	68 cf 43 80 00       	push   $0x8043cf
  801b42:	e8 94 00 00 00       	call   801bdb <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b47:	68 9b 44 80 00       	push   $0x80449b
  801b4c:	68 7d 40 80 00       	push   $0x80407d
  801b51:	6a 40                	push   $0x40
  801b53:	68 cf 43 80 00       	push   $0x8043cf
  801b58:	e8 7e 00 00 00       	call   801bdb <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b5d:	68 f1 44 80 00       	push   $0x8044f1
  801b62:	68 7d 40 80 00       	push   $0x80407d
  801b67:	6a 41                	push   $0x41
  801b69:	68 cf 43 80 00       	push   $0x8043cf
  801b6e:	e8 68 00 00 00       	call   801bdb <_panic>

00801b73 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801b73:	f3 0f 1e fb          	endbr32 
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	56                   	push   %esi
  801b7b:	53                   	push   %ebx
  801b7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b7f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801b82:	e8 41 0b 00 00       	call   8026c8 <sys_getenvid>
  801b87:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b8c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b8f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b94:	a3 10 a0 80 00       	mov    %eax,0x80a010

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801b99:	85 db                	test   %ebx,%ebx
  801b9b:	7e 07                	jle    801ba4 <libmain+0x31>
		binaryname = argv[0];
  801b9d:	8b 06                	mov    (%esi),%eax
  801b9f:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801ba4:	83 ec 08             	sub    $0x8,%esp
  801ba7:	56                   	push   %esi
  801ba8:	53                   	push   %ebx
  801ba9:	e8 60 fb ff ff       	call   80170e <umain>

	// exit gracefully
	exit();
  801bae:	e8 0a 00 00 00       	call   801bbd <exit>
}
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb9:	5b                   	pop    %ebx
  801bba:	5e                   	pop    %esi
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    

00801bbd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801bbd:	f3 0f 1e fb          	endbr32 
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801bc7:	e8 a9 11 00 00       	call   802d75 <close_all>
	sys_env_destroy(0);
  801bcc:	83 ec 0c             	sub    $0xc,%esp
  801bcf:	6a 00                	push   $0x0
  801bd1:	e8 ad 0a 00 00       	call   802683 <sys_env_destroy>
}
  801bd6:	83 c4 10             	add    $0x10,%esp
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801bdb:	f3 0f 1e fb          	endbr32 
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	56                   	push   %esi
  801be3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801be4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801be7:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801bed:	e8 d6 0a 00 00       	call   8026c8 <sys_getenvid>
  801bf2:	83 ec 0c             	sub    $0xc,%esp
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	56                   	push   %esi
  801bfc:	50                   	push   %eax
  801bfd:	68 fc 45 80 00       	push   $0x8045fc
  801c02:	e8 bb 00 00 00       	call   801cc2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c07:	83 c4 18             	add    $0x18,%esp
  801c0a:	53                   	push   %ebx
  801c0b:	ff 75 10             	pushl  0x10(%ebp)
  801c0e:	e8 5a 00 00 00       	call   801c6d <vcprintf>
	cprintf("\n");
  801c13:	c7 04 24 0b 42 80 00 	movl   $0x80420b,(%esp)
  801c1a:	e8 a3 00 00 00       	call   801cc2 <cprintf>
  801c1f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c22:	cc                   	int3   
  801c23:	eb fd                	jmp    801c22 <_panic+0x47>

00801c25 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801c25:	f3 0f 1e fb          	endbr32 
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	53                   	push   %ebx
  801c2d:	83 ec 04             	sub    $0x4,%esp
  801c30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c33:	8b 13                	mov    (%ebx),%edx
  801c35:	8d 42 01             	lea    0x1(%edx),%eax
  801c38:	89 03                	mov    %eax,(%ebx)
  801c3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801c41:	3d ff 00 00 00       	cmp    $0xff,%eax
  801c46:	74 09                	je     801c51 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801c48:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801c4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801c51:	83 ec 08             	sub    $0x8,%esp
  801c54:	68 ff 00 00 00       	push   $0xff
  801c59:	8d 43 08             	lea    0x8(%ebx),%eax
  801c5c:	50                   	push   %eax
  801c5d:	e8 dc 09 00 00       	call   80263e <sys_cputs>
		b->idx = 0;
  801c62:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	eb db                	jmp    801c48 <putch+0x23>

00801c6d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801c6d:	f3 0f 1e fb          	endbr32 
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801c7a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c81:	00 00 00 
	b.cnt = 0;
  801c84:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801c8b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	ff 75 08             	pushl  0x8(%ebp)
  801c94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801c9a:	50                   	push   %eax
  801c9b:	68 25 1c 80 00       	push   $0x801c25
  801ca0:	e8 20 01 00 00       	call   801dc5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801ca5:	83 c4 08             	add    $0x8,%esp
  801ca8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801cae:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801cb4:	50                   	push   %eax
  801cb5:	e8 84 09 00 00       	call   80263e <sys_cputs>

	return b.cnt;
}
  801cba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801cc2:	f3 0f 1e fb          	endbr32 
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ccc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801ccf:	50                   	push   %eax
  801cd0:	ff 75 08             	pushl  0x8(%ebp)
  801cd3:	e8 95 ff ff ff       	call   801c6d <vcprintf>
	va_end(ap);

	return cnt;
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	57                   	push   %edi
  801cde:	56                   	push   %esi
  801cdf:	53                   	push   %ebx
  801ce0:	83 ec 1c             	sub    $0x1c,%esp
  801ce3:	89 c7                	mov    %eax,%edi
  801ce5:	89 d6                	mov    %edx,%esi
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ced:	89 d1                	mov    %edx,%ecx
  801cef:	89 c2                	mov    %eax,%edx
  801cf1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801cf4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfa:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801cfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801d07:	39 c2                	cmp    %eax,%edx
  801d09:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801d0c:	72 3e                	jb     801d4c <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	ff 75 18             	pushl  0x18(%ebp)
  801d14:	83 eb 01             	sub    $0x1,%ebx
  801d17:	53                   	push   %ebx
  801d18:	50                   	push   %eax
  801d19:	83 ec 08             	sub    $0x8,%esp
  801d1c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d1f:	ff 75 e0             	pushl  -0x20(%ebp)
  801d22:	ff 75 dc             	pushl  -0x24(%ebp)
  801d25:	ff 75 d8             	pushl  -0x28(%ebp)
  801d28:	e8 a3 20 00 00       	call   803dd0 <__udivdi3>
  801d2d:	83 c4 18             	add    $0x18,%esp
  801d30:	52                   	push   %edx
  801d31:	50                   	push   %eax
  801d32:	89 f2                	mov    %esi,%edx
  801d34:	89 f8                	mov    %edi,%eax
  801d36:	e8 9f ff ff ff       	call   801cda <printnum>
  801d3b:	83 c4 20             	add    $0x20,%esp
  801d3e:	eb 13                	jmp    801d53 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801d40:	83 ec 08             	sub    $0x8,%esp
  801d43:	56                   	push   %esi
  801d44:	ff 75 18             	pushl  0x18(%ebp)
  801d47:	ff d7                	call   *%edi
  801d49:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801d4c:	83 eb 01             	sub    $0x1,%ebx
  801d4f:	85 db                	test   %ebx,%ebx
  801d51:	7f ed                	jg     801d40 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801d53:	83 ec 08             	sub    $0x8,%esp
  801d56:	56                   	push   %esi
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d5d:	ff 75 e0             	pushl  -0x20(%ebp)
  801d60:	ff 75 dc             	pushl  -0x24(%ebp)
  801d63:	ff 75 d8             	pushl  -0x28(%ebp)
  801d66:	e8 75 21 00 00       	call   803ee0 <__umoddi3>
  801d6b:	83 c4 14             	add    $0x14,%esp
  801d6e:	0f be 80 1f 46 80 00 	movsbl 0x80461f(%eax),%eax
  801d75:	50                   	push   %eax
  801d76:	ff d7                	call   *%edi
}
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7e:	5b                   	pop    %ebx
  801d7f:	5e                   	pop    %esi
  801d80:	5f                   	pop    %edi
  801d81:	5d                   	pop    %ebp
  801d82:	c3                   	ret    

00801d83 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801d83:	f3 0f 1e fb          	endbr32 
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801d8d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801d91:	8b 10                	mov    (%eax),%edx
  801d93:	3b 50 04             	cmp    0x4(%eax),%edx
  801d96:	73 0a                	jae    801da2 <sprintputch+0x1f>
		*b->buf++ = ch;
  801d98:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d9b:	89 08                	mov    %ecx,(%eax)
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	88 02                	mov    %al,(%edx)
}
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <printfmt>:
{
  801da4:	f3 0f 1e fb          	endbr32 
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801dae:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801db1:	50                   	push   %eax
  801db2:	ff 75 10             	pushl  0x10(%ebp)
  801db5:	ff 75 0c             	pushl  0xc(%ebp)
  801db8:	ff 75 08             	pushl  0x8(%ebp)
  801dbb:	e8 05 00 00 00       	call   801dc5 <vprintfmt>
}
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <vprintfmt>:
{
  801dc5:	f3 0f 1e fb          	endbr32 
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	57                   	push   %edi
  801dcd:	56                   	push   %esi
  801dce:	53                   	push   %ebx
  801dcf:	83 ec 3c             	sub    $0x3c,%esp
  801dd2:	8b 75 08             	mov    0x8(%ebp),%esi
  801dd5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801dd8:	8b 7d 10             	mov    0x10(%ebp),%edi
  801ddb:	e9 8e 03 00 00       	jmp    80216e <vprintfmt+0x3a9>
		padc = ' ';
  801de0:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801de4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801deb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801df2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801df9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801dfe:	8d 47 01             	lea    0x1(%edi),%eax
  801e01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e04:	0f b6 17             	movzbl (%edi),%edx
  801e07:	8d 42 dd             	lea    -0x23(%edx),%eax
  801e0a:	3c 55                	cmp    $0x55,%al
  801e0c:	0f 87 df 03 00 00    	ja     8021f1 <vprintfmt+0x42c>
  801e12:	0f b6 c0             	movzbl %al,%eax
  801e15:	3e ff 24 85 60 47 80 	notrack jmp *0x804760(,%eax,4)
  801e1c:	00 
  801e1d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801e20:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801e24:	eb d8                	jmp    801dfe <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801e26:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801e29:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801e2d:	eb cf                	jmp    801dfe <vprintfmt+0x39>
  801e2f:	0f b6 d2             	movzbl %dl,%edx
  801e32:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801e35:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801e3d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801e40:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801e44:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801e47:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801e4a:	83 f9 09             	cmp    $0x9,%ecx
  801e4d:	77 55                	ja     801ea4 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801e4f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801e52:	eb e9                	jmp    801e3d <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801e54:	8b 45 14             	mov    0x14(%ebp),%eax
  801e57:	8b 00                	mov    (%eax),%eax
  801e59:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e5c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5f:	8d 40 04             	lea    0x4(%eax),%eax
  801e62:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801e65:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801e68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e6c:	79 90                	jns    801dfe <vprintfmt+0x39>
				width = precision, precision = -1;
  801e6e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e71:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e74:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801e7b:	eb 81                	jmp    801dfe <vprintfmt+0x39>
  801e7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e80:	85 c0                	test   %eax,%eax
  801e82:	ba 00 00 00 00       	mov    $0x0,%edx
  801e87:	0f 49 d0             	cmovns %eax,%edx
  801e8a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801e8d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801e90:	e9 69 ff ff ff       	jmp    801dfe <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801e95:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801e98:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801e9f:	e9 5a ff ff ff       	jmp    801dfe <vprintfmt+0x39>
  801ea4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801ea7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801eaa:	eb bc                	jmp    801e68 <vprintfmt+0xa3>
			lflag++;
  801eac:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801eaf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801eb2:	e9 47 ff ff ff       	jmp    801dfe <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eba:	8d 78 04             	lea    0x4(%eax),%edi
  801ebd:	83 ec 08             	sub    $0x8,%esp
  801ec0:	53                   	push   %ebx
  801ec1:	ff 30                	pushl  (%eax)
  801ec3:	ff d6                	call   *%esi
			break;
  801ec5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801ec8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801ecb:	e9 9b 02 00 00       	jmp    80216b <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801ed0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed3:	8d 78 04             	lea    0x4(%eax),%edi
  801ed6:	8b 00                	mov    (%eax),%eax
  801ed8:	99                   	cltd   
  801ed9:	31 d0                	xor    %edx,%eax
  801edb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801edd:	83 f8 0f             	cmp    $0xf,%eax
  801ee0:	7f 23                	jg     801f05 <vprintfmt+0x140>
  801ee2:	8b 14 85 c0 48 80 00 	mov    0x8048c0(,%eax,4),%edx
  801ee9:	85 d2                	test   %edx,%edx
  801eeb:	74 18                	je     801f05 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  801eed:	52                   	push   %edx
  801eee:	68 8f 40 80 00       	push   $0x80408f
  801ef3:	53                   	push   %ebx
  801ef4:	56                   	push   %esi
  801ef5:	e8 aa fe ff ff       	call   801da4 <printfmt>
  801efa:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801efd:	89 7d 14             	mov    %edi,0x14(%ebp)
  801f00:	e9 66 02 00 00       	jmp    80216b <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801f05:	50                   	push   %eax
  801f06:	68 37 46 80 00       	push   $0x804637
  801f0b:	53                   	push   %ebx
  801f0c:	56                   	push   %esi
  801f0d:	e8 92 fe ff ff       	call   801da4 <printfmt>
  801f12:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801f15:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801f18:	e9 4e 02 00 00       	jmp    80216b <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801f1d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f20:	83 c0 04             	add    $0x4,%eax
  801f23:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801f26:	8b 45 14             	mov    0x14(%ebp),%eax
  801f29:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801f2b:	85 d2                	test   %edx,%edx
  801f2d:	b8 30 46 80 00       	mov    $0x804630,%eax
  801f32:	0f 45 c2             	cmovne %edx,%eax
  801f35:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801f38:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f3c:	7e 06                	jle    801f44 <vprintfmt+0x17f>
  801f3e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801f42:	75 0d                	jne    801f51 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f44:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f47:	89 c7                	mov    %eax,%edi
  801f49:	03 45 e0             	add    -0x20(%ebp),%eax
  801f4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f4f:	eb 55                	jmp    801fa6 <vprintfmt+0x1e1>
  801f51:	83 ec 08             	sub    $0x8,%esp
  801f54:	ff 75 d8             	pushl  -0x28(%ebp)
  801f57:	ff 75 cc             	pushl  -0x34(%ebp)
  801f5a:	e8 46 03 00 00       	call   8022a5 <strnlen>
  801f5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f62:	29 c2                	sub    %eax,%edx
  801f64:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801f6c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801f70:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801f73:	85 ff                	test   %edi,%edi
  801f75:	7e 11                	jle    801f88 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801f77:	83 ec 08             	sub    $0x8,%esp
  801f7a:	53                   	push   %ebx
  801f7b:	ff 75 e0             	pushl  -0x20(%ebp)
  801f7e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801f80:	83 ef 01             	sub    $0x1,%edi
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	eb eb                	jmp    801f73 <vprintfmt+0x1ae>
  801f88:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801f8b:	85 d2                	test   %edx,%edx
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f92:	0f 49 c2             	cmovns %edx,%eax
  801f95:	29 c2                	sub    %eax,%edx
  801f97:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801f9a:	eb a8                	jmp    801f44 <vprintfmt+0x17f>
					putch(ch, putdat);
  801f9c:	83 ec 08             	sub    $0x8,%esp
  801f9f:	53                   	push   %ebx
  801fa0:	52                   	push   %edx
  801fa1:	ff d6                	call   *%esi
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801fa9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801fab:	83 c7 01             	add    $0x1,%edi
  801fae:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801fb2:	0f be d0             	movsbl %al,%edx
  801fb5:	85 d2                	test   %edx,%edx
  801fb7:	74 4b                	je     802004 <vprintfmt+0x23f>
  801fb9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801fbd:	78 06                	js     801fc5 <vprintfmt+0x200>
  801fbf:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801fc3:	78 1e                	js     801fe3 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801fc5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801fc9:	74 d1                	je     801f9c <vprintfmt+0x1d7>
  801fcb:	0f be c0             	movsbl %al,%eax
  801fce:	83 e8 20             	sub    $0x20,%eax
  801fd1:	83 f8 5e             	cmp    $0x5e,%eax
  801fd4:	76 c6                	jbe    801f9c <vprintfmt+0x1d7>
					putch('?', putdat);
  801fd6:	83 ec 08             	sub    $0x8,%esp
  801fd9:	53                   	push   %ebx
  801fda:	6a 3f                	push   $0x3f
  801fdc:	ff d6                	call   *%esi
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	eb c3                	jmp    801fa6 <vprintfmt+0x1e1>
  801fe3:	89 cf                	mov    %ecx,%edi
  801fe5:	eb 0e                	jmp    801ff5 <vprintfmt+0x230>
				putch(' ', putdat);
  801fe7:	83 ec 08             	sub    $0x8,%esp
  801fea:	53                   	push   %ebx
  801feb:	6a 20                	push   $0x20
  801fed:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801fef:	83 ef 01             	sub    $0x1,%edi
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	85 ff                	test   %edi,%edi
  801ff7:	7f ee                	jg     801fe7 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801ff9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ffc:	89 45 14             	mov    %eax,0x14(%ebp)
  801fff:	e9 67 01 00 00       	jmp    80216b <vprintfmt+0x3a6>
  802004:	89 cf                	mov    %ecx,%edi
  802006:	eb ed                	jmp    801ff5 <vprintfmt+0x230>
	if (lflag >= 2)
  802008:	83 f9 01             	cmp    $0x1,%ecx
  80200b:	7f 1b                	jg     802028 <vprintfmt+0x263>
	else if (lflag)
  80200d:	85 c9                	test   %ecx,%ecx
  80200f:	74 63                	je     802074 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  802011:	8b 45 14             	mov    0x14(%ebp),%eax
  802014:	8b 00                	mov    (%eax),%eax
  802016:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802019:	99                   	cltd   
  80201a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80201d:	8b 45 14             	mov    0x14(%ebp),%eax
  802020:	8d 40 04             	lea    0x4(%eax),%eax
  802023:	89 45 14             	mov    %eax,0x14(%ebp)
  802026:	eb 17                	jmp    80203f <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  802028:	8b 45 14             	mov    0x14(%ebp),%eax
  80202b:	8b 50 04             	mov    0x4(%eax),%edx
  80202e:	8b 00                	mov    (%eax),%eax
  802030:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802033:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802036:	8b 45 14             	mov    0x14(%ebp),%eax
  802039:	8d 40 08             	lea    0x8(%eax),%eax
  80203c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80203f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802042:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  802045:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80204a:	85 c9                	test   %ecx,%ecx
  80204c:	0f 89 ff 00 00 00    	jns    802151 <vprintfmt+0x38c>
				putch('-', putdat);
  802052:	83 ec 08             	sub    $0x8,%esp
  802055:	53                   	push   %ebx
  802056:	6a 2d                	push   $0x2d
  802058:	ff d6                	call   *%esi
				num = -(long long) num;
  80205a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80205d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  802060:	f7 da                	neg    %edx
  802062:	83 d1 00             	adc    $0x0,%ecx
  802065:	f7 d9                	neg    %ecx
  802067:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80206a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80206f:	e9 dd 00 00 00       	jmp    802151 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  802074:	8b 45 14             	mov    0x14(%ebp),%eax
  802077:	8b 00                	mov    (%eax),%eax
  802079:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80207c:	99                   	cltd   
  80207d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802080:	8b 45 14             	mov    0x14(%ebp),%eax
  802083:	8d 40 04             	lea    0x4(%eax),%eax
  802086:	89 45 14             	mov    %eax,0x14(%ebp)
  802089:	eb b4                	jmp    80203f <vprintfmt+0x27a>
	if (lflag >= 2)
  80208b:	83 f9 01             	cmp    $0x1,%ecx
  80208e:	7f 1e                	jg     8020ae <vprintfmt+0x2e9>
	else if (lflag)
  802090:	85 c9                	test   %ecx,%ecx
  802092:	74 32                	je     8020c6 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  802094:	8b 45 14             	mov    0x14(%ebp),%eax
  802097:	8b 10                	mov    (%eax),%edx
  802099:	b9 00 00 00 00       	mov    $0x0,%ecx
  80209e:	8d 40 04             	lea    0x4(%eax),%eax
  8020a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020a4:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8020a9:	e9 a3 00 00 00       	jmp    802151 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8020ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b1:	8b 10                	mov    (%eax),%edx
  8020b3:	8b 48 04             	mov    0x4(%eax),%ecx
  8020b6:	8d 40 08             	lea    0x8(%eax),%eax
  8020b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020bc:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8020c1:	e9 8b 00 00 00       	jmp    802151 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8020c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c9:	8b 10                	mov    (%eax),%edx
  8020cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020d0:	8d 40 04             	lea    0x4(%eax),%eax
  8020d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020d6:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8020db:	eb 74                	jmp    802151 <vprintfmt+0x38c>
	if (lflag >= 2)
  8020dd:	83 f9 01             	cmp    $0x1,%ecx
  8020e0:	7f 1b                	jg     8020fd <vprintfmt+0x338>
	else if (lflag)
  8020e2:	85 c9                	test   %ecx,%ecx
  8020e4:	74 2c                	je     802112 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8020e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e9:	8b 10                	mov    (%eax),%edx
  8020eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020f0:	8d 40 04             	lea    0x4(%eax),%eax
  8020f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8020f6:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8020fb:	eb 54                	jmp    802151 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8020fd:	8b 45 14             	mov    0x14(%ebp),%eax
  802100:	8b 10                	mov    (%eax),%edx
  802102:	8b 48 04             	mov    0x4(%eax),%ecx
  802105:	8d 40 08             	lea    0x8(%eax),%eax
  802108:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80210b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  802110:	eb 3f                	jmp    802151 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  802112:	8b 45 14             	mov    0x14(%ebp),%eax
  802115:	8b 10                	mov    (%eax),%edx
  802117:	b9 00 00 00 00       	mov    $0x0,%ecx
  80211c:	8d 40 04             	lea    0x4(%eax),%eax
  80211f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802122:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  802127:	eb 28                	jmp    802151 <vprintfmt+0x38c>
			putch('0', putdat);
  802129:	83 ec 08             	sub    $0x8,%esp
  80212c:	53                   	push   %ebx
  80212d:	6a 30                	push   $0x30
  80212f:	ff d6                	call   *%esi
			putch('x', putdat);
  802131:	83 c4 08             	add    $0x8,%esp
  802134:	53                   	push   %ebx
  802135:	6a 78                	push   $0x78
  802137:	ff d6                	call   *%esi
			num = (unsigned long long)
  802139:	8b 45 14             	mov    0x14(%ebp),%eax
  80213c:	8b 10                	mov    (%eax),%edx
  80213e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  802143:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  802146:	8d 40 04             	lea    0x4(%eax),%eax
  802149:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80214c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  802151:	83 ec 0c             	sub    $0xc,%esp
  802154:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  802158:	57                   	push   %edi
  802159:	ff 75 e0             	pushl  -0x20(%ebp)
  80215c:	50                   	push   %eax
  80215d:	51                   	push   %ecx
  80215e:	52                   	push   %edx
  80215f:	89 da                	mov    %ebx,%edx
  802161:	89 f0                	mov    %esi,%eax
  802163:	e8 72 fb ff ff       	call   801cda <printnum>
			break;
  802168:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80216b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80216e:	83 c7 01             	add    $0x1,%edi
  802171:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  802175:	83 f8 25             	cmp    $0x25,%eax
  802178:	0f 84 62 fc ff ff    	je     801de0 <vprintfmt+0x1b>
			if (ch == '\0')
  80217e:	85 c0                	test   %eax,%eax
  802180:	0f 84 8b 00 00 00    	je     802211 <vprintfmt+0x44c>
			putch(ch, putdat);
  802186:	83 ec 08             	sub    $0x8,%esp
  802189:	53                   	push   %ebx
  80218a:	50                   	push   %eax
  80218b:	ff d6                	call   *%esi
  80218d:	83 c4 10             	add    $0x10,%esp
  802190:	eb dc                	jmp    80216e <vprintfmt+0x3a9>
	if (lflag >= 2)
  802192:	83 f9 01             	cmp    $0x1,%ecx
  802195:	7f 1b                	jg     8021b2 <vprintfmt+0x3ed>
	else if (lflag)
  802197:	85 c9                	test   %ecx,%ecx
  802199:	74 2c                	je     8021c7 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80219b:	8b 45 14             	mov    0x14(%ebp),%eax
  80219e:	8b 10                	mov    (%eax),%edx
  8021a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021a5:	8d 40 04             	lea    0x4(%eax),%eax
  8021a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021ab:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8021b0:	eb 9f                	jmp    802151 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8021b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b5:	8b 10                	mov    (%eax),%edx
  8021b7:	8b 48 04             	mov    0x4(%eax),%ecx
  8021ba:	8d 40 08             	lea    0x8(%eax),%eax
  8021bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021c0:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8021c5:	eb 8a                	jmp    802151 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8021c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ca:	8b 10                	mov    (%eax),%edx
  8021cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021d1:	8d 40 04             	lea    0x4(%eax),%eax
  8021d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021d7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8021dc:	e9 70 ff ff ff       	jmp    802151 <vprintfmt+0x38c>
			putch(ch, putdat);
  8021e1:	83 ec 08             	sub    $0x8,%esp
  8021e4:	53                   	push   %ebx
  8021e5:	6a 25                	push   $0x25
  8021e7:	ff d6                	call   *%esi
			break;
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	e9 7a ff ff ff       	jmp    80216b <vprintfmt+0x3a6>
			putch('%', putdat);
  8021f1:	83 ec 08             	sub    $0x8,%esp
  8021f4:	53                   	push   %ebx
  8021f5:	6a 25                	push   $0x25
  8021f7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	89 f8                	mov    %edi,%eax
  8021fe:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  802202:	74 05                	je     802209 <vprintfmt+0x444>
  802204:	83 e8 01             	sub    $0x1,%eax
  802207:	eb f5                	jmp    8021fe <vprintfmt+0x439>
  802209:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80220c:	e9 5a ff ff ff       	jmp    80216b <vprintfmt+0x3a6>
}
  802211:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802214:	5b                   	pop    %ebx
  802215:	5e                   	pop    %esi
  802216:	5f                   	pop    %edi
  802217:	5d                   	pop    %ebp
  802218:	c3                   	ret    

00802219 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802219:	f3 0f 1e fb          	endbr32 
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
  802220:	83 ec 18             	sub    $0x18,%esp
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802229:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80222c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802230:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802233:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80223a:	85 c0                	test   %eax,%eax
  80223c:	74 26                	je     802264 <vsnprintf+0x4b>
  80223e:	85 d2                	test   %edx,%edx
  802240:	7e 22                	jle    802264 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802242:	ff 75 14             	pushl  0x14(%ebp)
  802245:	ff 75 10             	pushl  0x10(%ebp)
  802248:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80224b:	50                   	push   %eax
  80224c:	68 83 1d 80 00       	push   $0x801d83
  802251:	e8 6f fb ff ff       	call   801dc5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802256:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802259:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	83 c4 10             	add    $0x10,%esp
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    
		return -E_INVAL;
  802264:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802269:	eb f7                	jmp    802262 <vsnprintf+0x49>

0080226b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80226b:	f3 0f 1e fb          	endbr32 
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802275:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802278:	50                   	push   %eax
  802279:	ff 75 10             	pushl  0x10(%ebp)
  80227c:	ff 75 0c             	pushl  0xc(%ebp)
  80227f:	ff 75 08             	pushl  0x8(%ebp)
  802282:	e8 92 ff ff ff       	call   802219 <vsnprintf>
	va_end(ap);

	return rc;
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802289:	f3 0f 1e fb          	endbr32 
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
  802298:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80229c:	74 05                	je     8022a3 <strlen+0x1a>
		n++;
  80229e:	83 c0 01             	add    $0x1,%eax
  8022a1:	eb f5                	jmp    802298 <strlen+0xf>
	return n;
}
  8022a3:	5d                   	pop    %ebp
  8022a4:	c3                   	ret    

008022a5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8022a5:	f3 0f 1e fb          	endbr32 
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022af:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b7:	39 d0                	cmp    %edx,%eax
  8022b9:	74 0d                	je     8022c8 <strnlen+0x23>
  8022bb:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8022bf:	74 05                	je     8022c6 <strnlen+0x21>
		n++;
  8022c1:	83 c0 01             	add    $0x1,%eax
  8022c4:	eb f1                	jmp    8022b7 <strnlen+0x12>
  8022c6:	89 c2                	mov    %eax,%edx
	return n;
}
  8022c8:	89 d0                	mov    %edx,%eax
  8022ca:	5d                   	pop    %ebp
  8022cb:	c3                   	ret    

008022cc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022cc:	f3 0f 1e fb          	endbr32 
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	53                   	push   %ebx
  8022d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8022e3:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8022e6:	83 c0 01             	add    $0x1,%eax
  8022e9:	84 d2                	test   %dl,%dl
  8022eb:	75 f2                	jne    8022df <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8022ed:	89 c8                	mov    %ecx,%eax
  8022ef:	5b                   	pop    %ebx
  8022f0:	5d                   	pop    %ebp
  8022f1:	c3                   	ret    

008022f2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8022f2:	f3 0f 1e fb          	endbr32 
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	53                   	push   %ebx
  8022fa:	83 ec 10             	sub    $0x10,%esp
  8022fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802300:	53                   	push   %ebx
  802301:	e8 83 ff ff ff       	call   802289 <strlen>
  802306:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  802309:	ff 75 0c             	pushl  0xc(%ebp)
  80230c:	01 d8                	add    %ebx,%eax
  80230e:	50                   	push   %eax
  80230f:	e8 b8 ff ff ff       	call   8022cc <strcpy>
	return dst;
}
  802314:	89 d8                	mov    %ebx,%eax
  802316:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80231b:	f3 0f 1e fb          	endbr32 
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	8b 75 08             	mov    0x8(%ebp),%esi
  802327:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232a:	89 f3                	mov    %esi,%ebx
  80232c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80232f:	89 f0                	mov    %esi,%eax
  802331:	39 d8                	cmp    %ebx,%eax
  802333:	74 11                	je     802346 <strncpy+0x2b>
		*dst++ = *src;
  802335:	83 c0 01             	add    $0x1,%eax
  802338:	0f b6 0a             	movzbl (%edx),%ecx
  80233b:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80233e:	80 f9 01             	cmp    $0x1,%cl
  802341:	83 da ff             	sbb    $0xffffffff,%edx
  802344:	eb eb                	jmp    802331 <strncpy+0x16>
	}
	return ret;
}
  802346:	89 f0                	mov    %esi,%eax
  802348:	5b                   	pop    %ebx
  802349:	5e                   	pop    %esi
  80234a:	5d                   	pop    %ebp
  80234b:	c3                   	ret    

0080234c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80234c:	f3 0f 1e fb          	endbr32 
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	56                   	push   %esi
  802354:	53                   	push   %ebx
  802355:	8b 75 08             	mov    0x8(%ebp),%esi
  802358:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80235b:	8b 55 10             	mov    0x10(%ebp),%edx
  80235e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802360:	85 d2                	test   %edx,%edx
  802362:	74 21                	je     802385 <strlcpy+0x39>
  802364:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  802368:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80236a:	39 c2                	cmp    %eax,%edx
  80236c:	74 14                	je     802382 <strlcpy+0x36>
  80236e:	0f b6 19             	movzbl (%ecx),%ebx
  802371:	84 db                	test   %bl,%bl
  802373:	74 0b                	je     802380 <strlcpy+0x34>
			*dst++ = *src++;
  802375:	83 c1 01             	add    $0x1,%ecx
  802378:	83 c2 01             	add    $0x1,%edx
  80237b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80237e:	eb ea                	jmp    80236a <strlcpy+0x1e>
  802380:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  802382:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802385:	29 f0                	sub    %esi,%eax
}
  802387:	5b                   	pop    %ebx
  802388:	5e                   	pop    %esi
  802389:	5d                   	pop    %ebp
  80238a:	c3                   	ret    

0080238b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80238b:	f3 0f 1e fb          	endbr32 
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802395:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802398:	0f b6 01             	movzbl (%ecx),%eax
  80239b:	84 c0                	test   %al,%al
  80239d:	74 0c                	je     8023ab <strcmp+0x20>
  80239f:	3a 02                	cmp    (%edx),%al
  8023a1:	75 08                	jne    8023ab <strcmp+0x20>
		p++, q++;
  8023a3:	83 c1 01             	add    $0x1,%ecx
  8023a6:	83 c2 01             	add    $0x1,%edx
  8023a9:	eb ed                	jmp    802398 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8023ab:	0f b6 c0             	movzbl %al,%eax
  8023ae:	0f b6 12             	movzbl (%edx),%edx
  8023b1:	29 d0                	sub    %edx,%eax
}
  8023b3:	5d                   	pop    %ebp
  8023b4:	c3                   	ret    

008023b5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8023b5:	f3 0f 1e fb          	endbr32 
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	53                   	push   %ebx
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c3:	89 c3                	mov    %eax,%ebx
  8023c5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8023c8:	eb 06                	jmp    8023d0 <strncmp+0x1b>
		n--, p++, q++;
  8023ca:	83 c0 01             	add    $0x1,%eax
  8023cd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8023d0:	39 d8                	cmp    %ebx,%eax
  8023d2:	74 16                	je     8023ea <strncmp+0x35>
  8023d4:	0f b6 08             	movzbl (%eax),%ecx
  8023d7:	84 c9                	test   %cl,%cl
  8023d9:	74 04                	je     8023df <strncmp+0x2a>
  8023db:	3a 0a                	cmp    (%edx),%cl
  8023dd:	74 eb                	je     8023ca <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023df:	0f b6 00             	movzbl (%eax),%eax
  8023e2:	0f b6 12             	movzbl (%edx),%edx
  8023e5:	29 d0                	sub    %edx,%eax
}
  8023e7:	5b                   	pop    %ebx
  8023e8:	5d                   	pop    %ebp
  8023e9:	c3                   	ret    
		return 0;
  8023ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ef:	eb f6                	jmp    8023e7 <strncmp+0x32>

008023f1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8023f1:	f3 0f 1e fb          	endbr32 
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8023ff:	0f b6 10             	movzbl (%eax),%edx
  802402:	84 d2                	test   %dl,%dl
  802404:	74 09                	je     80240f <strchr+0x1e>
		if (*s == c)
  802406:	38 ca                	cmp    %cl,%dl
  802408:	74 0a                	je     802414 <strchr+0x23>
	for (; *s; s++)
  80240a:	83 c0 01             	add    $0x1,%eax
  80240d:	eb f0                	jmp    8023ff <strchr+0xe>
			return (char *) s;
	return 0;
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802414:	5d                   	pop    %ebp
  802415:	c3                   	ret    

00802416 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802416:	f3 0f 1e fb          	endbr32 
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802424:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  802427:	38 ca                	cmp    %cl,%dl
  802429:	74 09                	je     802434 <strfind+0x1e>
  80242b:	84 d2                	test   %dl,%dl
  80242d:	74 05                	je     802434 <strfind+0x1e>
	for (; *s; s++)
  80242f:	83 c0 01             	add    $0x1,%eax
  802432:	eb f0                	jmp    802424 <strfind+0xe>
			break;
	return (char *) s;
}
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    

00802436 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802436:	f3 0f 1e fb          	endbr32 
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	57                   	push   %edi
  80243e:	56                   	push   %esi
  80243f:	53                   	push   %ebx
  802440:	8b 7d 08             	mov    0x8(%ebp),%edi
  802443:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802446:	85 c9                	test   %ecx,%ecx
  802448:	74 31                	je     80247b <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80244a:	89 f8                	mov    %edi,%eax
  80244c:	09 c8                	or     %ecx,%eax
  80244e:	a8 03                	test   $0x3,%al
  802450:	75 23                	jne    802475 <memset+0x3f>
		c &= 0xFF;
  802452:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802456:	89 d3                	mov    %edx,%ebx
  802458:	c1 e3 08             	shl    $0x8,%ebx
  80245b:	89 d0                	mov    %edx,%eax
  80245d:	c1 e0 18             	shl    $0x18,%eax
  802460:	89 d6                	mov    %edx,%esi
  802462:	c1 e6 10             	shl    $0x10,%esi
  802465:	09 f0                	or     %esi,%eax
  802467:	09 c2                	or     %eax,%edx
  802469:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80246b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80246e:	89 d0                	mov    %edx,%eax
  802470:	fc                   	cld    
  802471:	f3 ab                	rep stos %eax,%es:(%edi)
  802473:	eb 06                	jmp    80247b <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802475:	8b 45 0c             	mov    0xc(%ebp),%eax
  802478:	fc                   	cld    
  802479:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80247b:	89 f8                	mov    %edi,%eax
  80247d:	5b                   	pop    %ebx
  80247e:	5e                   	pop    %esi
  80247f:	5f                   	pop    %edi
  802480:	5d                   	pop    %ebp
  802481:	c3                   	ret    

00802482 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802482:	f3 0f 1e fb          	endbr32 
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	57                   	push   %edi
  80248a:	56                   	push   %esi
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802491:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802494:	39 c6                	cmp    %eax,%esi
  802496:	73 32                	jae    8024ca <memmove+0x48>
  802498:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80249b:	39 c2                	cmp    %eax,%edx
  80249d:	76 2b                	jbe    8024ca <memmove+0x48>
		s += n;
		d += n;
  80249f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8024a2:	89 fe                	mov    %edi,%esi
  8024a4:	09 ce                	or     %ecx,%esi
  8024a6:	09 d6                	or     %edx,%esi
  8024a8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8024ae:	75 0e                	jne    8024be <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8024b0:	83 ef 04             	sub    $0x4,%edi
  8024b3:	8d 72 fc             	lea    -0x4(%edx),%esi
  8024b6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8024b9:	fd                   	std    
  8024ba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8024bc:	eb 09                	jmp    8024c7 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8024be:	83 ef 01             	sub    $0x1,%edi
  8024c1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8024c4:	fd                   	std    
  8024c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8024c7:	fc                   	cld    
  8024c8:	eb 1a                	jmp    8024e4 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8024ca:	89 c2                	mov    %eax,%edx
  8024cc:	09 ca                	or     %ecx,%edx
  8024ce:	09 f2                	or     %esi,%edx
  8024d0:	f6 c2 03             	test   $0x3,%dl
  8024d3:	75 0a                	jne    8024df <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8024d5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8024d8:	89 c7                	mov    %eax,%edi
  8024da:	fc                   	cld    
  8024db:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8024dd:	eb 05                	jmp    8024e4 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8024df:	89 c7                	mov    %eax,%edi
  8024e1:	fc                   	cld    
  8024e2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8024e4:	5e                   	pop    %esi
  8024e5:	5f                   	pop    %edi
  8024e6:	5d                   	pop    %ebp
  8024e7:	c3                   	ret    

008024e8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8024e8:	f3 0f 1e fb          	endbr32 
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8024f2:	ff 75 10             	pushl  0x10(%ebp)
  8024f5:	ff 75 0c             	pushl  0xc(%ebp)
  8024f8:	ff 75 08             	pushl  0x8(%ebp)
  8024fb:	e8 82 ff ff ff       	call   802482 <memmove>
}
  802500:	c9                   	leave  
  802501:	c3                   	ret    

00802502 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802502:	f3 0f 1e fb          	endbr32 
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	56                   	push   %esi
  80250a:	53                   	push   %ebx
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802511:	89 c6                	mov    %eax,%esi
  802513:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802516:	39 f0                	cmp    %esi,%eax
  802518:	74 1c                	je     802536 <memcmp+0x34>
		if (*s1 != *s2)
  80251a:	0f b6 08             	movzbl (%eax),%ecx
  80251d:	0f b6 1a             	movzbl (%edx),%ebx
  802520:	38 d9                	cmp    %bl,%cl
  802522:	75 08                	jne    80252c <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  802524:	83 c0 01             	add    $0x1,%eax
  802527:	83 c2 01             	add    $0x1,%edx
  80252a:	eb ea                	jmp    802516 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  80252c:	0f b6 c1             	movzbl %cl,%eax
  80252f:	0f b6 db             	movzbl %bl,%ebx
  802532:	29 d8                	sub    %ebx,%eax
  802534:	eb 05                	jmp    80253b <memcmp+0x39>
	}

	return 0;
  802536:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253b:	5b                   	pop    %ebx
  80253c:	5e                   	pop    %esi
  80253d:	5d                   	pop    %ebp
  80253e:	c3                   	ret    

0080253f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80253f:	f3 0f 1e fb          	endbr32 
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80254c:	89 c2                	mov    %eax,%edx
  80254e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802551:	39 d0                	cmp    %edx,%eax
  802553:	73 09                	jae    80255e <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  802555:	38 08                	cmp    %cl,(%eax)
  802557:	74 05                	je     80255e <memfind+0x1f>
	for (; s < ends; s++)
  802559:	83 c0 01             	add    $0x1,%eax
  80255c:	eb f3                	jmp    802551 <memfind+0x12>
			break;
	return (void *) s;
}
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    

00802560 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802560:	f3 0f 1e fb          	endbr32 
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	57                   	push   %edi
  802568:	56                   	push   %esi
  802569:	53                   	push   %ebx
  80256a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80256d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802570:	eb 03                	jmp    802575 <strtol+0x15>
		s++;
  802572:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  802575:	0f b6 01             	movzbl (%ecx),%eax
  802578:	3c 20                	cmp    $0x20,%al
  80257a:	74 f6                	je     802572 <strtol+0x12>
  80257c:	3c 09                	cmp    $0x9,%al
  80257e:	74 f2                	je     802572 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  802580:	3c 2b                	cmp    $0x2b,%al
  802582:	74 2a                	je     8025ae <strtol+0x4e>
	int neg = 0;
  802584:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  802589:	3c 2d                	cmp    $0x2d,%al
  80258b:	74 2b                	je     8025b8 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80258d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  802593:	75 0f                	jne    8025a4 <strtol+0x44>
  802595:	80 39 30             	cmpb   $0x30,(%ecx)
  802598:	74 28                	je     8025c2 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80259a:	85 db                	test   %ebx,%ebx
  80259c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8025a1:	0f 44 d8             	cmove  %eax,%ebx
  8025a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8025ac:	eb 46                	jmp    8025f4 <strtol+0x94>
		s++;
  8025ae:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8025b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b6:	eb d5                	jmp    80258d <strtol+0x2d>
		s++, neg = 1;
  8025b8:	83 c1 01             	add    $0x1,%ecx
  8025bb:	bf 01 00 00 00       	mov    $0x1,%edi
  8025c0:	eb cb                	jmp    80258d <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025c2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8025c6:	74 0e                	je     8025d6 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8025c8:	85 db                	test   %ebx,%ebx
  8025ca:	75 d8                	jne    8025a4 <strtol+0x44>
		s++, base = 8;
  8025cc:	83 c1 01             	add    $0x1,%ecx
  8025cf:	bb 08 00 00 00       	mov    $0x8,%ebx
  8025d4:	eb ce                	jmp    8025a4 <strtol+0x44>
		s += 2, base = 16;
  8025d6:	83 c1 02             	add    $0x2,%ecx
  8025d9:	bb 10 00 00 00       	mov    $0x10,%ebx
  8025de:	eb c4                	jmp    8025a4 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8025e0:	0f be d2             	movsbl %dl,%edx
  8025e3:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8025e6:	3b 55 10             	cmp    0x10(%ebp),%edx
  8025e9:	7d 3a                	jge    802625 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8025eb:	83 c1 01             	add    $0x1,%ecx
  8025ee:	0f af 45 10          	imul   0x10(%ebp),%eax
  8025f2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8025f4:	0f b6 11             	movzbl (%ecx),%edx
  8025f7:	8d 72 d0             	lea    -0x30(%edx),%esi
  8025fa:	89 f3                	mov    %esi,%ebx
  8025fc:	80 fb 09             	cmp    $0x9,%bl
  8025ff:	76 df                	jbe    8025e0 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  802601:	8d 72 9f             	lea    -0x61(%edx),%esi
  802604:	89 f3                	mov    %esi,%ebx
  802606:	80 fb 19             	cmp    $0x19,%bl
  802609:	77 08                	ja     802613 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80260b:	0f be d2             	movsbl %dl,%edx
  80260e:	83 ea 57             	sub    $0x57,%edx
  802611:	eb d3                	jmp    8025e6 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  802613:	8d 72 bf             	lea    -0x41(%edx),%esi
  802616:	89 f3                	mov    %esi,%ebx
  802618:	80 fb 19             	cmp    $0x19,%bl
  80261b:	77 08                	ja     802625 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80261d:	0f be d2             	movsbl %dl,%edx
  802620:	83 ea 37             	sub    $0x37,%edx
  802623:	eb c1                	jmp    8025e6 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  802625:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802629:	74 05                	je     802630 <strtol+0xd0>
		*endptr = (char *) s;
  80262b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80262e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802630:	89 c2                	mov    %eax,%edx
  802632:	f7 da                	neg    %edx
  802634:	85 ff                	test   %edi,%edi
  802636:	0f 45 c2             	cmovne %edx,%eax
}
  802639:	5b                   	pop    %ebx
  80263a:	5e                   	pop    %esi
  80263b:	5f                   	pop    %edi
  80263c:	5d                   	pop    %ebp
  80263d:	c3                   	ret    

0080263e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80263e:	f3 0f 1e fb          	endbr32 
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
  802645:	57                   	push   %edi
  802646:	56                   	push   %esi
  802647:	53                   	push   %ebx
	asm volatile("int %1\n"
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
  80264d:	8b 55 08             	mov    0x8(%ebp),%edx
  802650:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802653:	89 c3                	mov    %eax,%ebx
  802655:	89 c7                	mov    %eax,%edi
  802657:	89 c6                	mov    %eax,%esi
  802659:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80265b:	5b                   	pop    %ebx
  80265c:	5e                   	pop    %esi
  80265d:	5f                   	pop    %edi
  80265e:	5d                   	pop    %ebp
  80265f:	c3                   	ret    

00802660 <sys_cgetc>:

int
sys_cgetc(void)
{
  802660:	f3 0f 1e fb          	endbr32 
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
  802667:	57                   	push   %edi
  802668:	56                   	push   %esi
  802669:	53                   	push   %ebx
	asm volatile("int %1\n"
  80266a:	ba 00 00 00 00       	mov    $0x0,%edx
  80266f:	b8 01 00 00 00       	mov    $0x1,%eax
  802674:	89 d1                	mov    %edx,%ecx
  802676:	89 d3                	mov    %edx,%ebx
  802678:	89 d7                	mov    %edx,%edi
  80267a:	89 d6                	mov    %edx,%esi
  80267c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80267e:	5b                   	pop    %ebx
  80267f:	5e                   	pop    %esi
  802680:	5f                   	pop    %edi
  802681:	5d                   	pop    %ebp
  802682:	c3                   	ret    

00802683 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802683:	f3 0f 1e fb          	endbr32 
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	57                   	push   %edi
  80268b:	56                   	push   %esi
  80268c:	53                   	push   %ebx
  80268d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802690:	b9 00 00 00 00       	mov    $0x0,%ecx
  802695:	8b 55 08             	mov    0x8(%ebp),%edx
  802698:	b8 03 00 00 00       	mov    $0x3,%eax
  80269d:	89 cb                	mov    %ecx,%ebx
  80269f:	89 cf                	mov    %ecx,%edi
  8026a1:	89 ce                	mov    %ecx,%esi
  8026a3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	7f 08                	jg     8026b1 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8026a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026ac:	5b                   	pop    %ebx
  8026ad:	5e                   	pop    %esi
  8026ae:	5f                   	pop    %edi
  8026af:	5d                   	pop    %ebp
  8026b0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026b1:	83 ec 0c             	sub    $0xc,%esp
  8026b4:	50                   	push   %eax
  8026b5:	6a 03                	push   $0x3
  8026b7:	68 1f 49 80 00       	push   $0x80491f
  8026bc:	6a 23                	push   $0x23
  8026be:	68 3c 49 80 00       	push   $0x80493c
  8026c3:	e8 13 f5 ff ff       	call   801bdb <_panic>

008026c8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8026c8:	f3 0f 1e fb          	endbr32 
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
  8026cf:	57                   	push   %edi
  8026d0:	56                   	push   %esi
  8026d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8026d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8026dc:	89 d1                	mov    %edx,%ecx
  8026de:	89 d3                	mov    %edx,%ebx
  8026e0:	89 d7                	mov    %edx,%edi
  8026e2:	89 d6                	mov    %edx,%esi
  8026e4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8026e6:	5b                   	pop    %ebx
  8026e7:	5e                   	pop    %esi
  8026e8:	5f                   	pop    %edi
  8026e9:	5d                   	pop    %ebp
  8026ea:	c3                   	ret    

008026eb <sys_yield>:

void
sys_yield(void)
{
  8026eb:	f3 0f 1e fb          	endbr32 
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
  8026f2:	57                   	push   %edi
  8026f3:	56                   	push   %esi
  8026f4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8026f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fa:	b8 0b 00 00 00       	mov    $0xb,%eax
  8026ff:	89 d1                	mov    %edx,%ecx
  802701:	89 d3                	mov    %edx,%ebx
  802703:	89 d7                	mov    %edx,%edi
  802705:	89 d6                	mov    %edx,%esi
  802707:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  802709:	5b                   	pop    %ebx
  80270a:	5e                   	pop    %esi
  80270b:	5f                   	pop    %edi
  80270c:	5d                   	pop    %ebp
  80270d:	c3                   	ret    

0080270e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80270e:	f3 0f 1e fb          	endbr32 
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
  802715:	57                   	push   %edi
  802716:	56                   	push   %esi
  802717:	53                   	push   %ebx
  802718:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80271b:	be 00 00 00 00       	mov    $0x0,%esi
  802720:	8b 55 08             	mov    0x8(%ebp),%edx
  802723:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802726:	b8 04 00 00 00       	mov    $0x4,%eax
  80272b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80272e:	89 f7                	mov    %esi,%edi
  802730:	cd 30                	int    $0x30
	if(check && ret > 0)
  802732:	85 c0                	test   %eax,%eax
  802734:	7f 08                	jg     80273e <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  802736:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802739:	5b                   	pop    %ebx
  80273a:	5e                   	pop    %esi
  80273b:	5f                   	pop    %edi
  80273c:	5d                   	pop    %ebp
  80273d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80273e:	83 ec 0c             	sub    $0xc,%esp
  802741:	50                   	push   %eax
  802742:	6a 04                	push   $0x4
  802744:	68 1f 49 80 00       	push   $0x80491f
  802749:	6a 23                	push   $0x23
  80274b:	68 3c 49 80 00       	push   $0x80493c
  802750:	e8 86 f4 ff ff       	call   801bdb <_panic>

00802755 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802755:	f3 0f 1e fb          	endbr32 
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
  80275c:	57                   	push   %edi
  80275d:	56                   	push   %esi
  80275e:	53                   	push   %ebx
  80275f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802762:	8b 55 08             	mov    0x8(%ebp),%edx
  802765:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802768:	b8 05 00 00 00       	mov    $0x5,%eax
  80276d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802770:	8b 7d 14             	mov    0x14(%ebp),%edi
  802773:	8b 75 18             	mov    0x18(%ebp),%esi
  802776:	cd 30                	int    $0x30
	if(check && ret > 0)
  802778:	85 c0                	test   %eax,%eax
  80277a:	7f 08                	jg     802784 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80277c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80277f:	5b                   	pop    %ebx
  802780:	5e                   	pop    %esi
  802781:	5f                   	pop    %edi
  802782:	5d                   	pop    %ebp
  802783:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802784:	83 ec 0c             	sub    $0xc,%esp
  802787:	50                   	push   %eax
  802788:	6a 05                	push   $0x5
  80278a:	68 1f 49 80 00       	push   $0x80491f
  80278f:	6a 23                	push   $0x23
  802791:	68 3c 49 80 00       	push   $0x80493c
  802796:	e8 40 f4 ff ff       	call   801bdb <_panic>

0080279b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80279b:	f3 0f 1e fb          	endbr32 
  80279f:	55                   	push   %ebp
  8027a0:	89 e5                	mov    %esp,%ebp
  8027a2:	57                   	push   %edi
  8027a3:	56                   	push   %esi
  8027a4:	53                   	push   %ebx
  8027a5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027b3:	b8 06 00 00 00       	mov    $0x6,%eax
  8027b8:	89 df                	mov    %ebx,%edi
  8027ba:	89 de                	mov    %ebx,%esi
  8027bc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	7f 08                	jg     8027ca <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8027c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027c5:	5b                   	pop    %ebx
  8027c6:	5e                   	pop    %esi
  8027c7:	5f                   	pop    %edi
  8027c8:	5d                   	pop    %ebp
  8027c9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027ca:	83 ec 0c             	sub    $0xc,%esp
  8027cd:	50                   	push   %eax
  8027ce:	6a 06                	push   $0x6
  8027d0:	68 1f 49 80 00       	push   $0x80491f
  8027d5:	6a 23                	push   $0x23
  8027d7:	68 3c 49 80 00       	push   $0x80493c
  8027dc:	e8 fa f3 ff ff       	call   801bdb <_panic>

008027e1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8027e1:	f3 0f 1e fb          	endbr32 
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	57                   	push   %edi
  8027e9:	56                   	push   %esi
  8027ea:	53                   	push   %ebx
  8027eb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027f9:	b8 08 00 00 00       	mov    $0x8,%eax
  8027fe:	89 df                	mov    %ebx,%edi
  802800:	89 de                	mov    %ebx,%esi
  802802:	cd 30                	int    $0x30
	if(check && ret > 0)
  802804:	85 c0                	test   %eax,%eax
  802806:	7f 08                	jg     802810 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802808:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80280b:	5b                   	pop    %ebx
  80280c:	5e                   	pop    %esi
  80280d:	5f                   	pop    %edi
  80280e:	5d                   	pop    %ebp
  80280f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802810:	83 ec 0c             	sub    $0xc,%esp
  802813:	50                   	push   %eax
  802814:	6a 08                	push   $0x8
  802816:	68 1f 49 80 00       	push   $0x80491f
  80281b:	6a 23                	push   $0x23
  80281d:	68 3c 49 80 00       	push   $0x80493c
  802822:	e8 b4 f3 ff ff       	call   801bdb <_panic>

00802827 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802827:	f3 0f 1e fb          	endbr32 
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
  80282e:	57                   	push   %edi
  80282f:	56                   	push   %esi
  802830:	53                   	push   %ebx
  802831:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802834:	bb 00 00 00 00       	mov    $0x0,%ebx
  802839:	8b 55 08             	mov    0x8(%ebp),%edx
  80283c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80283f:	b8 09 00 00 00       	mov    $0x9,%eax
  802844:	89 df                	mov    %ebx,%edi
  802846:	89 de                	mov    %ebx,%esi
  802848:	cd 30                	int    $0x30
	if(check && ret > 0)
  80284a:	85 c0                	test   %eax,%eax
  80284c:	7f 08                	jg     802856 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80284e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802851:	5b                   	pop    %ebx
  802852:	5e                   	pop    %esi
  802853:	5f                   	pop    %edi
  802854:	5d                   	pop    %ebp
  802855:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802856:	83 ec 0c             	sub    $0xc,%esp
  802859:	50                   	push   %eax
  80285a:	6a 09                	push   $0x9
  80285c:	68 1f 49 80 00       	push   $0x80491f
  802861:	6a 23                	push   $0x23
  802863:	68 3c 49 80 00       	push   $0x80493c
  802868:	e8 6e f3 ff ff       	call   801bdb <_panic>

0080286d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80286d:	f3 0f 1e fb          	endbr32 
  802871:	55                   	push   %ebp
  802872:	89 e5                	mov    %esp,%ebp
  802874:	57                   	push   %edi
  802875:	56                   	push   %esi
  802876:	53                   	push   %ebx
  802877:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80287a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80287f:	8b 55 08             	mov    0x8(%ebp),%edx
  802882:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802885:	b8 0a 00 00 00       	mov    $0xa,%eax
  80288a:	89 df                	mov    %ebx,%edi
  80288c:	89 de                	mov    %ebx,%esi
  80288e:	cd 30                	int    $0x30
	if(check && ret > 0)
  802890:	85 c0                	test   %eax,%eax
  802892:	7f 08                	jg     80289c <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802894:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802897:	5b                   	pop    %ebx
  802898:	5e                   	pop    %esi
  802899:	5f                   	pop    %edi
  80289a:	5d                   	pop    %ebp
  80289b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80289c:	83 ec 0c             	sub    $0xc,%esp
  80289f:	50                   	push   %eax
  8028a0:	6a 0a                	push   $0xa
  8028a2:	68 1f 49 80 00       	push   $0x80491f
  8028a7:	6a 23                	push   $0x23
  8028a9:	68 3c 49 80 00       	push   $0x80493c
  8028ae:	e8 28 f3 ff ff       	call   801bdb <_panic>

008028b3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8028b3:	f3 0f 1e fb          	endbr32 
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	57                   	push   %edi
  8028bb:	56                   	push   %esi
  8028bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8028bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028c3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8028c8:	be 00 00 00 00       	mov    $0x0,%esi
  8028cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028d0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8028d3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8028d5:	5b                   	pop    %ebx
  8028d6:	5e                   	pop    %esi
  8028d7:	5f                   	pop    %edi
  8028d8:	5d                   	pop    %ebp
  8028d9:	c3                   	ret    

008028da <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8028da:	f3 0f 1e fb          	endbr32 
  8028de:	55                   	push   %ebp
  8028df:	89 e5                	mov    %esp,%ebp
  8028e1:	57                   	push   %edi
  8028e2:	56                   	push   %esi
  8028e3:	53                   	push   %ebx
  8028e4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8028e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8028ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ef:	b8 0d 00 00 00       	mov    $0xd,%eax
  8028f4:	89 cb                	mov    %ecx,%ebx
  8028f6:	89 cf                	mov    %ecx,%edi
  8028f8:	89 ce                	mov    %ecx,%esi
  8028fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	7f 08                	jg     802908 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802900:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802903:	5b                   	pop    %ebx
  802904:	5e                   	pop    %esi
  802905:	5f                   	pop    %edi
  802906:	5d                   	pop    %ebp
  802907:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802908:	83 ec 0c             	sub    $0xc,%esp
  80290b:	50                   	push   %eax
  80290c:	6a 0d                	push   $0xd
  80290e:	68 1f 49 80 00       	push   $0x80491f
  802913:	6a 23                	push   $0x23
  802915:	68 3c 49 80 00       	push   $0x80493c
  80291a:	e8 bc f2 ff ff       	call   801bdb <_panic>

0080291f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80291f:	f3 0f 1e fb          	endbr32 
  802923:	55                   	push   %ebp
  802924:	89 e5                	mov    %esp,%ebp
  802926:	57                   	push   %edi
  802927:	56                   	push   %esi
  802928:	53                   	push   %ebx
	asm volatile("int %1\n"
  802929:	ba 00 00 00 00       	mov    $0x0,%edx
  80292e:	b8 0e 00 00 00       	mov    $0xe,%eax
  802933:	89 d1                	mov    %edx,%ecx
  802935:	89 d3                	mov    %edx,%ebx
  802937:	89 d7                	mov    %edx,%edi
  802939:	89 d6                	mov    %edx,%esi
  80293b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80293d:	5b                   	pop    %ebx
  80293e:	5e                   	pop    %esi
  80293f:	5f                   	pop    %edi
  802940:	5d                   	pop    %ebp
  802941:	c3                   	ret    

00802942 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  802942:	f3 0f 1e fb          	endbr32 
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	57                   	push   %edi
  80294a:	56                   	push   %esi
  80294b:	53                   	push   %ebx
  80294c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80294f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802954:	8b 55 08             	mov    0x8(%ebp),%edx
  802957:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80295a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80295f:	89 df                	mov    %ebx,%edi
  802961:	89 de                	mov    %ebx,%esi
  802963:	cd 30                	int    $0x30
	if(check && ret > 0)
  802965:	85 c0                	test   %eax,%eax
  802967:	7f 08                	jg     802971 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  802969:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80296c:	5b                   	pop    %ebx
  80296d:	5e                   	pop    %esi
  80296e:	5f                   	pop    %edi
  80296f:	5d                   	pop    %ebp
  802970:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802971:	83 ec 0c             	sub    $0xc,%esp
  802974:	50                   	push   %eax
  802975:	6a 0f                	push   $0xf
  802977:	68 1f 49 80 00       	push   $0x80491f
  80297c:	6a 23                	push   $0x23
  80297e:	68 3c 49 80 00       	push   $0x80493c
  802983:	e8 53 f2 ff ff       	call   801bdb <_panic>

00802988 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  802988:	f3 0f 1e fb          	endbr32 
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	57                   	push   %edi
  802990:	56                   	push   %esi
  802991:	53                   	push   %ebx
  802992:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802995:	bb 00 00 00 00       	mov    $0x0,%ebx
  80299a:	8b 55 08             	mov    0x8(%ebp),%edx
  80299d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029a0:	b8 10 00 00 00       	mov    $0x10,%eax
  8029a5:	89 df                	mov    %ebx,%edi
  8029a7:	89 de                	mov    %ebx,%esi
  8029a9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	7f 08                	jg     8029b7 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  8029af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029b2:	5b                   	pop    %ebx
  8029b3:	5e                   	pop    %esi
  8029b4:	5f                   	pop    %edi
  8029b5:	5d                   	pop    %ebp
  8029b6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8029b7:	83 ec 0c             	sub    $0xc,%esp
  8029ba:	50                   	push   %eax
  8029bb:	6a 10                	push   $0x10
  8029bd:	68 1f 49 80 00       	push   $0x80491f
  8029c2:	6a 23                	push   $0x23
  8029c4:	68 3c 49 80 00       	push   $0x80493c
  8029c9:	e8 0d f2 ff ff       	call   801bdb <_panic>

008029ce <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029ce:	f3 0f 1e fb          	endbr32 
  8029d2:	55                   	push   %ebp
  8029d3:	89 e5                	mov    %esp,%ebp
  8029d5:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029d8:	83 3d 14 a0 80 00 00 	cmpl   $0x0,0x80a014
  8029df:	74 0a                	je     8029eb <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	a3 14 a0 80 00       	mov    %eax,0x80a014
}
  8029e9:	c9                   	leave  
  8029ea:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  8029eb:	83 ec 04             	sub    $0x4,%esp
  8029ee:	6a 07                	push   $0x7
  8029f0:	68 00 f0 bf ee       	push   $0xeebff000
  8029f5:	6a 00                	push   $0x0
  8029f7:	e8 12 fd ff ff       	call   80270e <sys_page_alloc>
  8029fc:	83 c4 10             	add    $0x10,%esp
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	78 2a                	js     802a2d <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802a03:	83 ec 08             	sub    $0x8,%esp
  802a06:	68 41 2a 80 00       	push   $0x802a41
  802a0b:	6a 00                	push   $0x0
  802a0d:	e8 5b fe ff ff       	call   80286d <sys_env_set_pgfault_upcall>
  802a12:	83 c4 10             	add    $0x10,%esp
  802a15:	85 c0                	test   %eax,%eax
  802a17:	79 c8                	jns    8029e1 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802a19:	83 ec 04             	sub    $0x4,%esp
  802a1c:	68 78 49 80 00       	push   $0x804978
  802a21:	6a 25                	push   $0x25
  802a23:	68 b0 49 80 00       	push   $0x8049b0
  802a28:	e8 ae f1 ff ff       	call   801bdb <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802a2d:	83 ec 04             	sub    $0x4,%esp
  802a30:	68 4c 49 80 00       	push   $0x80494c
  802a35:	6a 22                	push   $0x22
  802a37:	68 b0 49 80 00       	push   $0x8049b0
  802a3c:	e8 9a f1 ff ff       	call   801bdb <_panic>

00802a41 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a41:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a42:	a1 14 a0 80 00       	mov    0x80a014,%eax
	call *%eax
  802a47:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a49:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802a4c:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802a50:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802a54:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802a57:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802a59:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  802a5d:	83 c4 08             	add    $0x8,%esp
	popal
  802a60:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  802a61:	83 c4 04             	add    $0x4,%esp
	popfl
  802a64:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  802a65:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  802a66:	c3                   	ret    

00802a67 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a67:	f3 0f 1e fb          	endbr32 
  802a6b:	55                   	push   %ebp
  802a6c:	89 e5                	mov    %esp,%ebp
  802a6e:	56                   	push   %esi
  802a6f:	53                   	push   %ebx
  802a70:	8b 75 08             	mov    0x8(%ebp),%esi
  802a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	74 3d                	je     802aba <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802a7d:	83 ec 0c             	sub    $0xc,%esp
  802a80:	50                   	push   %eax
  802a81:	e8 54 fe ff ff       	call   8028da <sys_ipc_recv>
  802a86:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802a89:	85 f6                	test   %esi,%esi
  802a8b:	74 0b                	je     802a98 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802a8d:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  802a93:	8b 52 74             	mov    0x74(%edx),%edx
  802a96:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802a98:	85 db                	test   %ebx,%ebx
  802a9a:	74 0b                	je     802aa7 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802a9c:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  802aa2:	8b 52 78             	mov    0x78(%edx),%edx
  802aa5:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802aa7:	85 c0                	test   %eax,%eax
  802aa9:	78 21                	js     802acc <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802aab:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802ab0:	8b 40 70             	mov    0x70(%eax),%eax
}
  802ab3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ab6:	5b                   	pop    %ebx
  802ab7:	5e                   	pop    %esi
  802ab8:	5d                   	pop    %ebp
  802ab9:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802aba:	83 ec 0c             	sub    $0xc,%esp
  802abd:	68 00 00 c0 ee       	push   $0xeec00000
  802ac2:	e8 13 fe ff ff       	call   8028da <sys_ipc_recv>
  802ac7:	83 c4 10             	add    $0x10,%esp
  802aca:	eb bd                	jmp    802a89 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802acc:	85 f6                	test   %esi,%esi
  802ace:	74 10                	je     802ae0 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802ad0:	85 db                	test   %ebx,%ebx
  802ad2:	75 df                	jne    802ab3 <ipc_recv+0x4c>
  802ad4:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802adb:	00 00 00 
  802ade:	eb d3                	jmp    802ab3 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802ae0:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802ae7:	00 00 00 
  802aea:	eb e4                	jmp    802ad0 <ipc_recv+0x69>

00802aec <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802aec:	f3 0f 1e fb          	endbr32 
  802af0:	55                   	push   %ebp
  802af1:	89 e5                	mov    %esp,%ebp
  802af3:	57                   	push   %edi
  802af4:	56                   	push   %esi
  802af5:	53                   	push   %ebx
  802af6:	83 ec 0c             	sub    $0xc,%esp
  802af9:	8b 7d 08             	mov    0x8(%ebp),%edi
  802afc:	8b 75 0c             	mov    0xc(%ebp),%esi
  802aff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802b02:	85 db                	test   %ebx,%ebx
  802b04:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802b09:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802b0c:	ff 75 14             	pushl  0x14(%ebp)
  802b0f:	53                   	push   %ebx
  802b10:	56                   	push   %esi
  802b11:	57                   	push   %edi
  802b12:	e8 9c fd ff ff       	call   8028b3 <sys_ipc_try_send>
  802b17:	83 c4 10             	add    $0x10,%esp
  802b1a:	85 c0                	test   %eax,%eax
  802b1c:	79 1e                	jns    802b3c <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802b1e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b21:	75 07                	jne    802b2a <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802b23:	e8 c3 fb ff ff       	call   8026eb <sys_yield>
  802b28:	eb e2                	jmp    802b0c <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802b2a:	50                   	push   %eax
  802b2b:	68 be 49 80 00       	push   $0x8049be
  802b30:	6a 59                	push   $0x59
  802b32:	68 d9 49 80 00       	push   $0x8049d9
  802b37:	e8 9f f0 ff ff       	call   801bdb <_panic>
	}
}
  802b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b3f:	5b                   	pop    %ebx
  802b40:	5e                   	pop    %esi
  802b41:	5f                   	pop    %edi
  802b42:	5d                   	pop    %ebp
  802b43:	c3                   	ret    

00802b44 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b44:	f3 0f 1e fb          	endbr32 
  802b48:	55                   	push   %ebp
  802b49:	89 e5                	mov    %esp,%ebp
  802b4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802b4e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802b53:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802b56:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802b5c:	8b 52 50             	mov    0x50(%edx),%edx
  802b5f:	39 ca                	cmp    %ecx,%edx
  802b61:	74 11                	je     802b74 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802b63:	83 c0 01             	add    $0x1,%eax
  802b66:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b6b:	75 e6                	jne    802b53 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b72:	eb 0b                	jmp    802b7f <ipc_find_env+0x3b>
			return envs[i].env_id;
  802b74:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802b77:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b7c:	8b 40 48             	mov    0x48(%eax),%eax
}
  802b7f:	5d                   	pop    %ebp
  802b80:	c3                   	ret    

00802b81 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802b81:	f3 0f 1e fb          	endbr32 
  802b85:	55                   	push   %ebp
  802b86:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	05 00 00 00 30       	add    $0x30000000,%eax
  802b90:	c1 e8 0c             	shr    $0xc,%eax
}
  802b93:	5d                   	pop    %ebp
  802b94:	c3                   	ret    

00802b95 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802b95:	f3 0f 1e fb          	endbr32 
  802b99:	55                   	push   %ebp
  802b9a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802ba4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802ba9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802bae:	5d                   	pop    %ebp
  802baf:	c3                   	ret    

00802bb0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802bb0:	f3 0f 1e fb          	endbr32 
  802bb4:	55                   	push   %ebp
  802bb5:	89 e5                	mov    %esp,%ebp
  802bb7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802bbc:	89 c2                	mov    %eax,%edx
  802bbe:	c1 ea 16             	shr    $0x16,%edx
  802bc1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802bc8:	f6 c2 01             	test   $0x1,%dl
  802bcb:	74 2d                	je     802bfa <fd_alloc+0x4a>
  802bcd:	89 c2                	mov    %eax,%edx
  802bcf:	c1 ea 0c             	shr    $0xc,%edx
  802bd2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802bd9:	f6 c2 01             	test   $0x1,%dl
  802bdc:	74 1c                	je     802bfa <fd_alloc+0x4a>
  802bde:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802be3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802be8:	75 d2                	jne    802bbc <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802bf3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802bf8:	eb 0a                	jmp    802c04 <fd_alloc+0x54>
			*fd_store = fd;
  802bfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bfd:	89 01                	mov    %eax,(%ecx)
			return 0;
  802bff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c04:	5d                   	pop    %ebp
  802c05:	c3                   	ret    

00802c06 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802c06:	f3 0f 1e fb          	endbr32 
  802c0a:	55                   	push   %ebp
  802c0b:	89 e5                	mov    %esp,%ebp
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802c10:	83 f8 1f             	cmp    $0x1f,%eax
  802c13:	77 30                	ja     802c45 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802c15:	c1 e0 0c             	shl    $0xc,%eax
  802c18:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802c1d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802c23:	f6 c2 01             	test   $0x1,%dl
  802c26:	74 24                	je     802c4c <fd_lookup+0x46>
  802c28:	89 c2                	mov    %eax,%edx
  802c2a:	c1 ea 0c             	shr    $0xc,%edx
  802c2d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802c34:	f6 c2 01             	test   $0x1,%dl
  802c37:	74 1a                	je     802c53 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802c39:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c3c:	89 02                	mov    %eax,(%edx)
	return 0;
  802c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c43:	5d                   	pop    %ebp
  802c44:	c3                   	ret    
		return -E_INVAL;
  802c45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c4a:	eb f7                	jmp    802c43 <fd_lookup+0x3d>
		return -E_INVAL;
  802c4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c51:	eb f0                	jmp    802c43 <fd_lookup+0x3d>
  802c53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c58:	eb e9                	jmp    802c43 <fd_lookup+0x3d>

00802c5a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802c5a:	f3 0f 1e fb          	endbr32 
  802c5e:	55                   	push   %ebp
  802c5f:	89 e5                	mov    %esp,%ebp
  802c61:	83 ec 08             	sub    $0x8,%esp
  802c64:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802c67:	ba 00 00 00 00       	mov    $0x0,%edx
  802c6c:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802c71:	39 08                	cmp    %ecx,(%eax)
  802c73:	74 38                	je     802cad <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  802c75:	83 c2 01             	add    $0x1,%edx
  802c78:	8b 04 95 60 4a 80 00 	mov    0x804a60(,%edx,4),%eax
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	75 ee                	jne    802c71 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802c83:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802c88:	8b 40 48             	mov    0x48(%eax),%eax
  802c8b:	83 ec 04             	sub    $0x4,%esp
  802c8e:	51                   	push   %ecx
  802c8f:	50                   	push   %eax
  802c90:	68 e4 49 80 00       	push   $0x8049e4
  802c95:	e8 28 f0 ff ff       	call   801cc2 <cprintf>
	*dev = 0;
  802c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802ca3:	83 c4 10             	add    $0x10,%esp
  802ca6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802cab:	c9                   	leave  
  802cac:	c3                   	ret    
			*dev = devtab[i];
  802cad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cb0:	89 01                	mov    %eax,(%ecx)
			return 0;
  802cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb7:	eb f2                	jmp    802cab <dev_lookup+0x51>

00802cb9 <fd_close>:
{
  802cb9:	f3 0f 1e fb          	endbr32 
  802cbd:	55                   	push   %ebp
  802cbe:	89 e5                	mov    %esp,%ebp
  802cc0:	57                   	push   %edi
  802cc1:	56                   	push   %esi
  802cc2:	53                   	push   %ebx
  802cc3:	83 ec 24             	sub    $0x24,%esp
  802cc6:	8b 75 08             	mov    0x8(%ebp),%esi
  802cc9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802ccc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802ccf:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802cd0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802cd6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802cd9:	50                   	push   %eax
  802cda:	e8 27 ff ff ff       	call   802c06 <fd_lookup>
  802cdf:	89 c3                	mov    %eax,%ebx
  802ce1:	83 c4 10             	add    $0x10,%esp
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	78 05                	js     802ced <fd_close+0x34>
	    || fd != fd2)
  802ce8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802ceb:	74 16                	je     802d03 <fd_close+0x4a>
		return (must_exist ? r : 0);
  802ced:	89 f8                	mov    %edi,%eax
  802cef:	84 c0                	test   %al,%al
  802cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf6:	0f 44 d8             	cmove  %eax,%ebx
}
  802cf9:	89 d8                	mov    %ebx,%eax
  802cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cfe:	5b                   	pop    %ebx
  802cff:	5e                   	pop    %esi
  802d00:	5f                   	pop    %edi
  802d01:	5d                   	pop    %ebp
  802d02:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802d03:	83 ec 08             	sub    $0x8,%esp
  802d06:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802d09:	50                   	push   %eax
  802d0a:	ff 36                	pushl  (%esi)
  802d0c:	e8 49 ff ff ff       	call   802c5a <dev_lookup>
  802d11:	89 c3                	mov    %eax,%ebx
  802d13:	83 c4 10             	add    $0x10,%esp
  802d16:	85 c0                	test   %eax,%eax
  802d18:	78 1a                	js     802d34 <fd_close+0x7b>
		if (dev->dev_close)
  802d1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802d20:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802d25:	85 c0                	test   %eax,%eax
  802d27:	74 0b                	je     802d34 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  802d29:	83 ec 0c             	sub    $0xc,%esp
  802d2c:	56                   	push   %esi
  802d2d:	ff d0                	call   *%eax
  802d2f:	89 c3                	mov    %eax,%ebx
  802d31:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802d34:	83 ec 08             	sub    $0x8,%esp
  802d37:	56                   	push   %esi
  802d38:	6a 00                	push   $0x0
  802d3a:	e8 5c fa ff ff       	call   80279b <sys_page_unmap>
	return r;
  802d3f:	83 c4 10             	add    $0x10,%esp
  802d42:	eb b5                	jmp    802cf9 <fd_close+0x40>

00802d44 <close>:

int
close(int fdnum)
{
  802d44:	f3 0f 1e fb          	endbr32 
  802d48:	55                   	push   %ebp
  802d49:	89 e5                	mov    %esp,%ebp
  802d4b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d51:	50                   	push   %eax
  802d52:	ff 75 08             	pushl  0x8(%ebp)
  802d55:	e8 ac fe ff ff       	call   802c06 <fd_lookup>
  802d5a:	83 c4 10             	add    $0x10,%esp
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	79 02                	jns    802d63 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  802d61:	c9                   	leave  
  802d62:	c3                   	ret    
		return fd_close(fd, 1);
  802d63:	83 ec 08             	sub    $0x8,%esp
  802d66:	6a 01                	push   $0x1
  802d68:	ff 75 f4             	pushl  -0xc(%ebp)
  802d6b:	e8 49 ff ff ff       	call   802cb9 <fd_close>
  802d70:	83 c4 10             	add    $0x10,%esp
  802d73:	eb ec                	jmp    802d61 <close+0x1d>

00802d75 <close_all>:

void
close_all(void)
{
  802d75:	f3 0f 1e fb          	endbr32 
  802d79:	55                   	push   %ebp
  802d7a:	89 e5                	mov    %esp,%ebp
  802d7c:	53                   	push   %ebx
  802d7d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802d80:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802d85:	83 ec 0c             	sub    $0xc,%esp
  802d88:	53                   	push   %ebx
  802d89:	e8 b6 ff ff ff       	call   802d44 <close>
	for (i = 0; i < MAXFD; i++)
  802d8e:	83 c3 01             	add    $0x1,%ebx
  802d91:	83 c4 10             	add    $0x10,%esp
  802d94:	83 fb 20             	cmp    $0x20,%ebx
  802d97:	75 ec                	jne    802d85 <close_all+0x10>
}
  802d99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d9c:	c9                   	leave  
  802d9d:	c3                   	ret    

00802d9e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802d9e:	f3 0f 1e fb          	endbr32 
  802da2:	55                   	push   %ebp
  802da3:	89 e5                	mov    %esp,%ebp
  802da5:	57                   	push   %edi
  802da6:	56                   	push   %esi
  802da7:	53                   	push   %ebx
  802da8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802dab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802dae:	50                   	push   %eax
  802daf:	ff 75 08             	pushl  0x8(%ebp)
  802db2:	e8 4f fe ff ff       	call   802c06 <fd_lookup>
  802db7:	89 c3                	mov    %eax,%ebx
  802db9:	83 c4 10             	add    $0x10,%esp
  802dbc:	85 c0                	test   %eax,%eax
  802dbe:	0f 88 81 00 00 00    	js     802e45 <dup+0xa7>
		return r;
	close(newfdnum);
  802dc4:	83 ec 0c             	sub    $0xc,%esp
  802dc7:	ff 75 0c             	pushl  0xc(%ebp)
  802dca:	e8 75 ff ff ff       	call   802d44 <close>

	newfd = INDEX2FD(newfdnum);
  802dcf:	8b 75 0c             	mov    0xc(%ebp),%esi
  802dd2:	c1 e6 0c             	shl    $0xc,%esi
  802dd5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802ddb:	83 c4 04             	add    $0x4,%esp
  802dde:	ff 75 e4             	pushl  -0x1c(%ebp)
  802de1:	e8 af fd ff ff       	call   802b95 <fd2data>
  802de6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802de8:	89 34 24             	mov    %esi,(%esp)
  802deb:	e8 a5 fd ff ff       	call   802b95 <fd2data>
  802df0:	83 c4 10             	add    $0x10,%esp
  802df3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802df5:	89 d8                	mov    %ebx,%eax
  802df7:	c1 e8 16             	shr    $0x16,%eax
  802dfa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802e01:	a8 01                	test   $0x1,%al
  802e03:	74 11                	je     802e16 <dup+0x78>
  802e05:	89 d8                	mov    %ebx,%eax
  802e07:	c1 e8 0c             	shr    $0xc,%eax
  802e0a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802e11:	f6 c2 01             	test   $0x1,%dl
  802e14:	75 39                	jne    802e4f <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802e16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e19:	89 d0                	mov    %edx,%eax
  802e1b:	c1 e8 0c             	shr    $0xc,%eax
  802e1e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802e25:	83 ec 0c             	sub    $0xc,%esp
  802e28:	25 07 0e 00 00       	and    $0xe07,%eax
  802e2d:	50                   	push   %eax
  802e2e:	56                   	push   %esi
  802e2f:	6a 00                	push   $0x0
  802e31:	52                   	push   %edx
  802e32:	6a 00                	push   $0x0
  802e34:	e8 1c f9 ff ff       	call   802755 <sys_page_map>
  802e39:	89 c3                	mov    %eax,%ebx
  802e3b:	83 c4 20             	add    $0x20,%esp
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	78 31                	js     802e73 <dup+0xd5>
		goto err;

	return newfdnum;
  802e42:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802e45:	89 d8                	mov    %ebx,%eax
  802e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e4a:	5b                   	pop    %ebx
  802e4b:	5e                   	pop    %esi
  802e4c:	5f                   	pop    %edi
  802e4d:	5d                   	pop    %ebp
  802e4e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802e4f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802e56:	83 ec 0c             	sub    $0xc,%esp
  802e59:	25 07 0e 00 00       	and    $0xe07,%eax
  802e5e:	50                   	push   %eax
  802e5f:	57                   	push   %edi
  802e60:	6a 00                	push   $0x0
  802e62:	53                   	push   %ebx
  802e63:	6a 00                	push   $0x0
  802e65:	e8 eb f8 ff ff       	call   802755 <sys_page_map>
  802e6a:	89 c3                	mov    %eax,%ebx
  802e6c:	83 c4 20             	add    $0x20,%esp
  802e6f:	85 c0                	test   %eax,%eax
  802e71:	79 a3                	jns    802e16 <dup+0x78>
	sys_page_unmap(0, newfd);
  802e73:	83 ec 08             	sub    $0x8,%esp
  802e76:	56                   	push   %esi
  802e77:	6a 00                	push   $0x0
  802e79:	e8 1d f9 ff ff       	call   80279b <sys_page_unmap>
	sys_page_unmap(0, nva);
  802e7e:	83 c4 08             	add    $0x8,%esp
  802e81:	57                   	push   %edi
  802e82:	6a 00                	push   $0x0
  802e84:	e8 12 f9 ff ff       	call   80279b <sys_page_unmap>
	return r;
  802e89:	83 c4 10             	add    $0x10,%esp
  802e8c:	eb b7                	jmp    802e45 <dup+0xa7>

00802e8e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802e8e:	f3 0f 1e fb          	endbr32 
  802e92:	55                   	push   %ebp
  802e93:	89 e5                	mov    %esp,%ebp
  802e95:	53                   	push   %ebx
  802e96:	83 ec 1c             	sub    $0x1c,%esp
  802e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e9c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e9f:	50                   	push   %eax
  802ea0:	53                   	push   %ebx
  802ea1:	e8 60 fd ff ff       	call   802c06 <fd_lookup>
  802ea6:	83 c4 10             	add    $0x10,%esp
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	78 3f                	js     802eec <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ead:	83 ec 08             	sub    $0x8,%esp
  802eb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802eb3:	50                   	push   %eax
  802eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb7:	ff 30                	pushl  (%eax)
  802eb9:	e8 9c fd ff ff       	call   802c5a <dev_lookup>
  802ebe:	83 c4 10             	add    $0x10,%esp
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	78 27                	js     802eec <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802ec5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec8:	8b 42 08             	mov    0x8(%edx),%eax
  802ecb:	83 e0 03             	and    $0x3,%eax
  802ece:	83 f8 01             	cmp    $0x1,%eax
  802ed1:	74 1e                	je     802ef1 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 40 08             	mov    0x8(%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 35                	je     802f12 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802edd:	83 ec 04             	sub    $0x4,%esp
  802ee0:	ff 75 10             	pushl  0x10(%ebp)
  802ee3:	ff 75 0c             	pushl  0xc(%ebp)
  802ee6:	52                   	push   %edx
  802ee7:	ff d0                	call   *%eax
  802ee9:	83 c4 10             	add    $0x10,%esp
}
  802eec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802eef:	c9                   	leave  
  802ef0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802ef1:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802ef6:	8b 40 48             	mov    0x48(%eax),%eax
  802ef9:	83 ec 04             	sub    $0x4,%esp
  802efc:	53                   	push   %ebx
  802efd:	50                   	push   %eax
  802efe:	68 25 4a 80 00       	push   $0x804a25
  802f03:	e8 ba ed ff ff       	call   801cc2 <cprintf>
		return -E_INVAL;
  802f08:	83 c4 10             	add    $0x10,%esp
  802f0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f10:	eb da                	jmp    802eec <read+0x5e>
		return -E_NOT_SUPP;
  802f12:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802f17:	eb d3                	jmp    802eec <read+0x5e>

00802f19 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802f19:	f3 0f 1e fb          	endbr32 
  802f1d:	55                   	push   %ebp
  802f1e:	89 e5                	mov    %esp,%ebp
  802f20:	57                   	push   %edi
  802f21:	56                   	push   %esi
  802f22:	53                   	push   %ebx
  802f23:	83 ec 0c             	sub    $0xc,%esp
  802f26:	8b 7d 08             	mov    0x8(%ebp),%edi
  802f29:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802f2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f31:	eb 02                	jmp    802f35 <readn+0x1c>
  802f33:	01 c3                	add    %eax,%ebx
  802f35:	39 f3                	cmp    %esi,%ebx
  802f37:	73 21                	jae    802f5a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802f39:	83 ec 04             	sub    $0x4,%esp
  802f3c:	89 f0                	mov    %esi,%eax
  802f3e:	29 d8                	sub    %ebx,%eax
  802f40:	50                   	push   %eax
  802f41:	89 d8                	mov    %ebx,%eax
  802f43:	03 45 0c             	add    0xc(%ebp),%eax
  802f46:	50                   	push   %eax
  802f47:	57                   	push   %edi
  802f48:	e8 41 ff ff ff       	call   802e8e <read>
		if (m < 0)
  802f4d:	83 c4 10             	add    $0x10,%esp
  802f50:	85 c0                	test   %eax,%eax
  802f52:	78 04                	js     802f58 <readn+0x3f>
			return m;
		if (m == 0)
  802f54:	75 dd                	jne    802f33 <readn+0x1a>
  802f56:	eb 02                	jmp    802f5a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802f58:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802f5a:	89 d8                	mov    %ebx,%eax
  802f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f5f:	5b                   	pop    %ebx
  802f60:	5e                   	pop    %esi
  802f61:	5f                   	pop    %edi
  802f62:	5d                   	pop    %ebp
  802f63:	c3                   	ret    

00802f64 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802f64:	f3 0f 1e fb          	endbr32 
  802f68:	55                   	push   %ebp
  802f69:	89 e5                	mov    %esp,%ebp
  802f6b:	53                   	push   %ebx
  802f6c:	83 ec 1c             	sub    $0x1c,%esp
  802f6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f72:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f75:	50                   	push   %eax
  802f76:	53                   	push   %ebx
  802f77:	e8 8a fc ff ff       	call   802c06 <fd_lookup>
  802f7c:	83 c4 10             	add    $0x10,%esp
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	78 3a                	js     802fbd <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f83:	83 ec 08             	sub    $0x8,%esp
  802f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f89:	50                   	push   %eax
  802f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8d:	ff 30                	pushl  (%eax)
  802f8f:	e8 c6 fc ff ff       	call   802c5a <dev_lookup>
  802f94:	83 c4 10             	add    $0x10,%esp
  802f97:	85 c0                	test   %eax,%eax
  802f99:	78 22                	js     802fbd <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802fa2:	74 1e                	je     802fc2 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802fa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa7:	8b 52 0c             	mov    0xc(%edx),%edx
  802faa:	85 d2                	test   %edx,%edx
  802fac:	74 35                	je     802fe3 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802fae:	83 ec 04             	sub    $0x4,%esp
  802fb1:	ff 75 10             	pushl  0x10(%ebp)
  802fb4:	ff 75 0c             	pushl  0xc(%ebp)
  802fb7:	50                   	push   %eax
  802fb8:	ff d2                	call   *%edx
  802fba:	83 c4 10             	add    $0x10,%esp
}
  802fbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fc0:	c9                   	leave  
  802fc1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802fc2:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802fc7:	8b 40 48             	mov    0x48(%eax),%eax
  802fca:	83 ec 04             	sub    $0x4,%esp
  802fcd:	53                   	push   %ebx
  802fce:	50                   	push   %eax
  802fcf:	68 41 4a 80 00       	push   $0x804a41
  802fd4:	e8 e9 ec ff ff       	call   801cc2 <cprintf>
		return -E_INVAL;
  802fd9:	83 c4 10             	add    $0x10,%esp
  802fdc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fe1:	eb da                	jmp    802fbd <write+0x59>
		return -E_NOT_SUPP;
  802fe3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802fe8:	eb d3                	jmp    802fbd <write+0x59>

00802fea <seek>:

int
seek(int fdnum, off_t offset)
{
  802fea:	f3 0f 1e fb          	endbr32 
  802fee:	55                   	push   %ebp
  802fef:	89 e5                	mov    %esp,%ebp
  802ff1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ff4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ff7:	50                   	push   %eax
  802ff8:	ff 75 08             	pushl  0x8(%ebp)
  802ffb:	e8 06 fc ff ff       	call   802c06 <fd_lookup>
  803000:	83 c4 10             	add    $0x10,%esp
  803003:	85 c0                	test   %eax,%eax
  803005:	78 0e                	js     803015 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  803007:	8b 55 0c             	mov    0xc(%ebp),%edx
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  803010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803015:	c9                   	leave  
  803016:	c3                   	ret    

00803017 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803017:	f3 0f 1e fb          	endbr32 
  80301b:	55                   	push   %ebp
  80301c:	89 e5                	mov    %esp,%ebp
  80301e:	53                   	push   %ebx
  80301f:	83 ec 1c             	sub    $0x1c,%esp
  803022:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803025:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803028:	50                   	push   %eax
  803029:	53                   	push   %ebx
  80302a:	e8 d7 fb ff ff       	call   802c06 <fd_lookup>
  80302f:	83 c4 10             	add    $0x10,%esp
  803032:	85 c0                	test   %eax,%eax
  803034:	78 37                	js     80306d <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803036:	83 ec 08             	sub    $0x8,%esp
  803039:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80303c:	50                   	push   %eax
  80303d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803040:	ff 30                	pushl  (%eax)
  803042:	e8 13 fc ff ff       	call   802c5a <dev_lookup>
  803047:	83 c4 10             	add    $0x10,%esp
  80304a:	85 c0                	test   %eax,%eax
  80304c:	78 1f                	js     80306d <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  803055:	74 1b                	je     803072 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  803057:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305a:	8b 52 18             	mov    0x18(%edx),%edx
  80305d:	85 d2                	test   %edx,%edx
  80305f:	74 32                	je     803093 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  803061:	83 ec 08             	sub    $0x8,%esp
  803064:	ff 75 0c             	pushl  0xc(%ebp)
  803067:	50                   	push   %eax
  803068:	ff d2                	call   *%edx
  80306a:	83 c4 10             	add    $0x10,%esp
}
  80306d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803070:	c9                   	leave  
  803071:	c3                   	ret    
			thisenv->env_id, fdnum);
  803072:	a1 10 a0 80 00       	mov    0x80a010,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803077:	8b 40 48             	mov    0x48(%eax),%eax
  80307a:	83 ec 04             	sub    $0x4,%esp
  80307d:	53                   	push   %ebx
  80307e:	50                   	push   %eax
  80307f:	68 04 4a 80 00       	push   $0x804a04
  803084:	e8 39 ec ff ff       	call   801cc2 <cprintf>
		return -E_INVAL;
  803089:	83 c4 10             	add    $0x10,%esp
  80308c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803091:	eb da                	jmp    80306d <ftruncate+0x56>
		return -E_NOT_SUPP;
  803093:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803098:	eb d3                	jmp    80306d <ftruncate+0x56>

0080309a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80309a:	f3 0f 1e fb          	endbr32 
  80309e:	55                   	push   %ebp
  80309f:	89 e5                	mov    %esp,%ebp
  8030a1:	53                   	push   %ebx
  8030a2:	83 ec 1c             	sub    $0x1c,%esp
  8030a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8030ab:	50                   	push   %eax
  8030ac:	ff 75 08             	pushl  0x8(%ebp)
  8030af:	e8 52 fb ff ff       	call   802c06 <fd_lookup>
  8030b4:	83 c4 10             	add    $0x10,%esp
  8030b7:	85 c0                	test   %eax,%eax
  8030b9:	78 4b                	js     803106 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030bb:	83 ec 08             	sub    $0x8,%esp
  8030be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030c1:	50                   	push   %eax
  8030c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c5:	ff 30                	pushl  (%eax)
  8030c7:	e8 8e fb ff ff       	call   802c5a <dev_lookup>
  8030cc:	83 c4 10             	add    $0x10,%esp
  8030cf:	85 c0                	test   %eax,%eax
  8030d1:	78 33                	js     803106 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8030da:	74 2f                	je     80310b <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8030dc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8030df:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8030e6:	00 00 00 
	stat->st_isdir = 0;
  8030e9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8030f0:	00 00 00 
	stat->st_dev = dev;
  8030f3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8030f9:	83 ec 08             	sub    $0x8,%esp
  8030fc:	53                   	push   %ebx
  8030fd:	ff 75 f0             	pushl  -0x10(%ebp)
  803100:	ff 50 14             	call   *0x14(%eax)
  803103:	83 c4 10             	add    $0x10,%esp
}
  803106:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803109:	c9                   	leave  
  80310a:	c3                   	ret    
		return -E_NOT_SUPP;
  80310b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803110:	eb f4                	jmp    803106 <fstat+0x6c>

00803112 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803112:	f3 0f 1e fb          	endbr32 
  803116:	55                   	push   %ebp
  803117:	89 e5                	mov    %esp,%ebp
  803119:	56                   	push   %esi
  80311a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80311b:	83 ec 08             	sub    $0x8,%esp
  80311e:	6a 00                	push   $0x0
  803120:	ff 75 08             	pushl  0x8(%ebp)
  803123:	e8 fb 01 00 00       	call   803323 <open>
  803128:	89 c3                	mov    %eax,%ebx
  80312a:	83 c4 10             	add    $0x10,%esp
  80312d:	85 c0                	test   %eax,%eax
  80312f:	78 1b                	js     80314c <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  803131:	83 ec 08             	sub    $0x8,%esp
  803134:	ff 75 0c             	pushl  0xc(%ebp)
  803137:	50                   	push   %eax
  803138:	e8 5d ff ff ff       	call   80309a <fstat>
  80313d:	89 c6                	mov    %eax,%esi
	close(fd);
  80313f:	89 1c 24             	mov    %ebx,(%esp)
  803142:	e8 fd fb ff ff       	call   802d44 <close>
	return r;
  803147:	83 c4 10             	add    $0x10,%esp
  80314a:	89 f3                	mov    %esi,%ebx
}
  80314c:	89 d8                	mov    %ebx,%eax
  80314e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803151:	5b                   	pop    %ebx
  803152:	5e                   	pop    %esi
  803153:	5d                   	pop    %ebp
  803154:	c3                   	ret    

00803155 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803155:	55                   	push   %ebp
  803156:	89 e5                	mov    %esp,%ebp
  803158:	56                   	push   %esi
  803159:	53                   	push   %ebx
  80315a:	89 c6                	mov    %eax,%esi
  80315c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80315e:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  803165:	74 27                	je     80318e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803167:	6a 07                	push   $0x7
  803169:	68 00 b0 80 00       	push   $0x80b000
  80316e:	56                   	push   %esi
  80316f:	ff 35 00 a0 80 00    	pushl  0x80a000
  803175:	e8 72 f9 ff ff       	call   802aec <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80317a:	83 c4 0c             	add    $0xc,%esp
  80317d:	6a 00                	push   $0x0
  80317f:	53                   	push   %ebx
  803180:	6a 00                	push   $0x0
  803182:	e8 e0 f8 ff ff       	call   802a67 <ipc_recv>
}
  803187:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80318a:	5b                   	pop    %ebx
  80318b:	5e                   	pop    %esi
  80318c:	5d                   	pop    %ebp
  80318d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80318e:	83 ec 0c             	sub    $0xc,%esp
  803191:	6a 01                	push   $0x1
  803193:	e8 ac f9 ff ff       	call   802b44 <ipc_find_env>
  803198:	a3 00 a0 80 00       	mov    %eax,0x80a000
  80319d:	83 c4 10             	add    $0x10,%esp
  8031a0:	eb c5                	jmp    803167 <fsipc+0x12>

008031a2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031a2:	f3 0f 1e fb          	endbr32 
  8031a6:	55                   	push   %ebp
  8031a7:	89 e5                	mov    %esp,%ebp
  8031a9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b2:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  8031b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ba:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8031c4:	b8 02 00 00 00       	mov    $0x2,%eax
  8031c9:	e8 87 ff ff ff       	call   803155 <fsipc>
}
  8031ce:	c9                   	leave  
  8031cf:	c3                   	ret    

008031d0 <devfile_flush>:
{
  8031d0:	f3 0f 1e fb          	endbr32 
  8031d4:	55                   	push   %ebp
  8031d5:	89 e5                	mov    %esp,%ebp
  8031d7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e0:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  8031e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8031ea:	b8 06 00 00 00       	mov    $0x6,%eax
  8031ef:	e8 61 ff ff ff       	call   803155 <fsipc>
}
  8031f4:	c9                   	leave  
  8031f5:	c3                   	ret    

008031f6 <devfile_stat>:
{
  8031f6:	f3 0f 1e fb          	endbr32 
  8031fa:	55                   	push   %ebp
  8031fb:	89 e5                	mov    %esp,%ebp
  8031fd:	53                   	push   %ebx
  8031fe:	83 ec 04             	sub    $0x4,%esp
  803201:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	8b 40 0c             	mov    0xc(%eax),%eax
  80320a:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80320f:	ba 00 00 00 00       	mov    $0x0,%edx
  803214:	b8 05 00 00 00       	mov    $0x5,%eax
  803219:	e8 37 ff ff ff       	call   803155 <fsipc>
  80321e:	85 c0                	test   %eax,%eax
  803220:	78 2c                	js     80324e <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803222:	83 ec 08             	sub    $0x8,%esp
  803225:	68 00 b0 80 00       	push   $0x80b000
  80322a:	53                   	push   %ebx
  80322b:	e8 9c f0 ff ff       	call   8022cc <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  803230:	a1 80 b0 80 00       	mov    0x80b080,%eax
  803235:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80323b:	a1 84 b0 80 00       	mov    0x80b084,%eax
  803240:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  803246:	83 c4 10             	add    $0x10,%esp
  803249:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80324e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803251:	c9                   	leave  
  803252:	c3                   	ret    

00803253 <devfile_write>:
{
  803253:	f3 0f 1e fb          	endbr32 
  803257:	55                   	push   %ebp
  803258:	89 e5                	mov    %esp,%ebp
  80325a:	83 ec 0c             	sub    $0xc,%esp
  80325d:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803260:	8b 55 08             	mov    0x8(%ebp),%edx
  803263:	8b 52 0c             	mov    0xc(%edx),%edx
  803266:	89 15 00 b0 80 00    	mov    %edx,0x80b000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80326c:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  803271:	ba f8 0f 00 00       	mov    $0xff8,%edx
  803276:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  803279:	a3 04 b0 80 00       	mov    %eax,0x80b004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80327e:	50                   	push   %eax
  80327f:	ff 75 0c             	pushl  0xc(%ebp)
  803282:	68 08 b0 80 00       	push   $0x80b008
  803287:	e8 f6 f1 ff ff       	call   802482 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80328c:	ba 00 00 00 00       	mov    $0x0,%edx
  803291:	b8 04 00 00 00       	mov    $0x4,%eax
  803296:	e8 ba fe ff ff       	call   803155 <fsipc>
}
  80329b:	c9                   	leave  
  80329c:	c3                   	ret    

0080329d <devfile_read>:
{
  80329d:	f3 0f 1e fb          	endbr32 
  8032a1:	55                   	push   %ebp
  8032a2:	89 e5                	mov    %esp,%ebp
  8032a4:	56                   	push   %esi
  8032a5:	53                   	push   %ebx
  8032a6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8032af:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  8032b4:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8032ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8032bf:	b8 03 00 00 00       	mov    $0x3,%eax
  8032c4:	e8 8c fe ff ff       	call   803155 <fsipc>
  8032c9:	89 c3                	mov    %eax,%ebx
  8032cb:	85 c0                	test   %eax,%eax
  8032cd:	78 1f                	js     8032ee <devfile_read+0x51>
	assert(r <= n);
  8032cf:	39 f0                	cmp    %esi,%eax
  8032d1:	77 24                	ja     8032f7 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8032d3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8032d8:	7f 33                	jg     80330d <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8032da:	83 ec 04             	sub    $0x4,%esp
  8032dd:	50                   	push   %eax
  8032de:	68 00 b0 80 00       	push   $0x80b000
  8032e3:	ff 75 0c             	pushl  0xc(%ebp)
  8032e6:	e8 97 f1 ff ff       	call   802482 <memmove>
	return r;
  8032eb:	83 c4 10             	add    $0x10,%esp
}
  8032ee:	89 d8                	mov    %ebx,%eax
  8032f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032f3:	5b                   	pop    %ebx
  8032f4:	5e                   	pop    %esi
  8032f5:	5d                   	pop    %ebp
  8032f6:	c3                   	ret    
	assert(r <= n);
  8032f7:	68 74 4a 80 00       	push   $0x804a74
  8032fc:	68 7d 40 80 00       	push   $0x80407d
  803301:	6a 7c                	push   $0x7c
  803303:	68 7b 4a 80 00       	push   $0x804a7b
  803308:	e8 ce e8 ff ff       	call   801bdb <_panic>
	assert(r <= PGSIZE);
  80330d:	68 86 4a 80 00       	push   $0x804a86
  803312:	68 7d 40 80 00       	push   $0x80407d
  803317:	6a 7d                	push   $0x7d
  803319:	68 7b 4a 80 00       	push   $0x804a7b
  80331e:	e8 b8 e8 ff ff       	call   801bdb <_panic>

00803323 <open>:
{
  803323:	f3 0f 1e fb          	endbr32 
  803327:	55                   	push   %ebp
  803328:	89 e5                	mov    %esp,%ebp
  80332a:	56                   	push   %esi
  80332b:	53                   	push   %ebx
  80332c:	83 ec 1c             	sub    $0x1c,%esp
  80332f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  803332:	56                   	push   %esi
  803333:	e8 51 ef ff ff       	call   802289 <strlen>
  803338:	83 c4 10             	add    $0x10,%esp
  80333b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803340:	7f 6c                	jg     8033ae <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  803342:	83 ec 0c             	sub    $0xc,%esp
  803345:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803348:	50                   	push   %eax
  803349:	e8 62 f8 ff ff       	call   802bb0 <fd_alloc>
  80334e:	89 c3                	mov    %eax,%ebx
  803350:	83 c4 10             	add    $0x10,%esp
  803353:	85 c0                	test   %eax,%eax
  803355:	78 3c                	js     803393 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  803357:	83 ec 08             	sub    $0x8,%esp
  80335a:	56                   	push   %esi
  80335b:	68 00 b0 80 00       	push   $0x80b000
  803360:	e8 67 ef ff ff       	call   8022cc <strcpy>
	fsipcbuf.open.req_omode = mode;
  803365:	8b 45 0c             	mov    0xc(%ebp),%eax
  803368:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80336d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803370:	b8 01 00 00 00       	mov    $0x1,%eax
  803375:	e8 db fd ff ff       	call   803155 <fsipc>
  80337a:	89 c3                	mov    %eax,%ebx
  80337c:	83 c4 10             	add    $0x10,%esp
  80337f:	85 c0                	test   %eax,%eax
  803381:	78 19                	js     80339c <open+0x79>
	return fd2num(fd);
  803383:	83 ec 0c             	sub    $0xc,%esp
  803386:	ff 75 f4             	pushl  -0xc(%ebp)
  803389:	e8 f3 f7 ff ff       	call   802b81 <fd2num>
  80338e:	89 c3                	mov    %eax,%ebx
  803390:	83 c4 10             	add    $0x10,%esp
}
  803393:	89 d8                	mov    %ebx,%eax
  803395:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803398:	5b                   	pop    %ebx
  803399:	5e                   	pop    %esi
  80339a:	5d                   	pop    %ebp
  80339b:	c3                   	ret    
		fd_close(fd, 0);
  80339c:	83 ec 08             	sub    $0x8,%esp
  80339f:	6a 00                	push   $0x0
  8033a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8033a4:	e8 10 f9 ff ff       	call   802cb9 <fd_close>
		return r;
  8033a9:	83 c4 10             	add    $0x10,%esp
  8033ac:	eb e5                	jmp    803393 <open+0x70>
		return -E_BAD_PATH;
  8033ae:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8033b3:	eb de                	jmp    803393 <open+0x70>

008033b5 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8033b5:	f3 0f 1e fb          	endbr32 
  8033b9:	55                   	push   %ebp
  8033ba:	89 e5                	mov    %esp,%ebp
  8033bc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8033bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8033c4:	b8 08 00 00 00       	mov    $0x8,%eax
  8033c9:	e8 87 fd ff ff       	call   803155 <fsipc>
}
  8033ce:	c9                   	leave  
  8033cf:	c3                   	ret    

008033d0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8033d0:	f3 0f 1e fb          	endbr32 
  8033d4:	55                   	push   %ebp
  8033d5:	89 e5                	mov    %esp,%ebp
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8033da:	89 c2                	mov    %eax,%edx
  8033dc:	c1 ea 16             	shr    $0x16,%edx
  8033df:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8033e6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8033eb:	f6 c1 01             	test   $0x1,%cl
  8033ee:	74 1c                	je     80340c <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8033f0:	c1 e8 0c             	shr    $0xc,%eax
  8033f3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8033fa:	a8 01                	test   $0x1,%al
  8033fc:	74 0e                	je     80340c <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8033fe:	c1 e8 0c             	shr    $0xc,%eax
  803401:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  803408:	ef 
  803409:	0f b7 d2             	movzwl %dx,%edx
}
  80340c:	89 d0                	mov    %edx,%eax
  80340e:	5d                   	pop    %ebp
  80340f:	c3                   	ret    

00803410 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803410:	f3 0f 1e fb          	endbr32 
  803414:	55                   	push   %ebp
  803415:	89 e5                	mov    %esp,%ebp
  803417:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80341a:	68 92 4a 80 00       	push   $0x804a92
  80341f:	ff 75 0c             	pushl  0xc(%ebp)
  803422:	e8 a5 ee ff ff       	call   8022cc <strcpy>
	return 0;
}
  803427:	b8 00 00 00 00       	mov    $0x0,%eax
  80342c:	c9                   	leave  
  80342d:	c3                   	ret    

0080342e <devsock_close>:
{
  80342e:	f3 0f 1e fb          	endbr32 
  803432:	55                   	push   %ebp
  803433:	89 e5                	mov    %esp,%ebp
  803435:	53                   	push   %ebx
  803436:	83 ec 10             	sub    $0x10,%esp
  803439:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80343c:	53                   	push   %ebx
  80343d:	e8 8e ff ff ff       	call   8033d0 <pageref>
  803442:	89 c2                	mov    %eax,%edx
  803444:	83 c4 10             	add    $0x10,%esp
		return 0;
  803447:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  80344c:	83 fa 01             	cmp    $0x1,%edx
  80344f:	74 05                	je     803456 <devsock_close+0x28>
}
  803451:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803454:	c9                   	leave  
  803455:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  803456:	83 ec 0c             	sub    $0xc,%esp
  803459:	ff 73 0c             	pushl  0xc(%ebx)
  80345c:	e8 e3 02 00 00       	call   803744 <nsipc_close>
  803461:	83 c4 10             	add    $0x10,%esp
  803464:	eb eb                	jmp    803451 <devsock_close+0x23>

00803466 <devsock_write>:
{
  803466:	f3 0f 1e fb          	endbr32 
  80346a:	55                   	push   %ebp
  80346b:	89 e5                	mov    %esp,%ebp
  80346d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803470:	6a 00                	push   $0x0
  803472:	ff 75 10             	pushl  0x10(%ebp)
  803475:	ff 75 0c             	pushl  0xc(%ebp)
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	ff 70 0c             	pushl  0xc(%eax)
  80347e:	e8 b5 03 00 00       	call   803838 <nsipc_send>
}
  803483:	c9                   	leave  
  803484:	c3                   	ret    

00803485 <devsock_read>:
{
  803485:	f3 0f 1e fb          	endbr32 
  803489:	55                   	push   %ebp
  80348a:	89 e5                	mov    %esp,%ebp
  80348c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80348f:	6a 00                	push   $0x0
  803491:	ff 75 10             	pushl  0x10(%ebp)
  803494:	ff 75 0c             	pushl  0xc(%ebp)
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	ff 70 0c             	pushl  0xc(%eax)
  80349d:	e8 1f 03 00 00       	call   8037c1 <nsipc_recv>
}
  8034a2:	c9                   	leave  
  8034a3:	c3                   	ret    

008034a4 <fd2sockid>:
{
  8034a4:	55                   	push   %ebp
  8034a5:	89 e5                	mov    %esp,%ebp
  8034a7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8034aa:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8034ad:	52                   	push   %edx
  8034ae:	50                   	push   %eax
  8034af:	e8 52 f7 ff ff       	call   802c06 <fd_lookup>
  8034b4:	83 c4 10             	add    $0x10,%esp
  8034b7:	85 c0                	test   %eax,%eax
  8034b9:	78 10                	js     8034cb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034be:	8b 0d 80 90 80 00    	mov    0x809080,%ecx
  8034c4:	39 08                	cmp    %ecx,(%eax)
  8034c6:	75 05                	jne    8034cd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8034c8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8034cb:	c9                   	leave  
  8034cc:	c3                   	ret    
		return -E_NOT_SUPP;
  8034cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8034d2:	eb f7                	jmp    8034cb <fd2sockid+0x27>

008034d4 <alloc_sockfd>:
{
  8034d4:	55                   	push   %ebp
  8034d5:	89 e5                	mov    %esp,%ebp
  8034d7:	56                   	push   %esi
  8034d8:	53                   	push   %ebx
  8034d9:	83 ec 1c             	sub    $0x1c,%esp
  8034dc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8034de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8034e1:	50                   	push   %eax
  8034e2:	e8 c9 f6 ff ff       	call   802bb0 <fd_alloc>
  8034e7:	89 c3                	mov    %eax,%ebx
  8034e9:	83 c4 10             	add    $0x10,%esp
  8034ec:	85 c0                	test   %eax,%eax
  8034ee:	78 43                	js     803533 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8034f0:	83 ec 04             	sub    $0x4,%esp
  8034f3:	68 07 04 00 00       	push   $0x407
  8034f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8034fb:	6a 00                	push   $0x0
  8034fd:	e8 0c f2 ff ff       	call   80270e <sys_page_alloc>
  803502:	89 c3                	mov    %eax,%ebx
  803504:	83 c4 10             	add    $0x10,%esp
  803507:	85 c0                	test   %eax,%eax
  803509:	78 28                	js     803533 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80350b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350e:	8b 15 80 90 80 00    	mov    0x809080,%edx
  803514:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803519:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803520:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803523:	83 ec 0c             	sub    $0xc,%esp
  803526:	50                   	push   %eax
  803527:	e8 55 f6 ff ff       	call   802b81 <fd2num>
  80352c:	89 c3                	mov    %eax,%ebx
  80352e:	83 c4 10             	add    $0x10,%esp
  803531:	eb 0c                	jmp    80353f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  803533:	83 ec 0c             	sub    $0xc,%esp
  803536:	56                   	push   %esi
  803537:	e8 08 02 00 00       	call   803744 <nsipc_close>
		return r;
  80353c:	83 c4 10             	add    $0x10,%esp
}
  80353f:	89 d8                	mov    %ebx,%eax
  803541:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803544:	5b                   	pop    %ebx
  803545:	5e                   	pop    %esi
  803546:	5d                   	pop    %ebp
  803547:	c3                   	ret    

00803548 <accept>:
{
  803548:	f3 0f 1e fb          	endbr32 
  80354c:	55                   	push   %ebp
  80354d:	89 e5                	mov    %esp,%ebp
  80354f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803552:	8b 45 08             	mov    0x8(%ebp),%eax
  803555:	e8 4a ff ff ff       	call   8034a4 <fd2sockid>
  80355a:	85 c0                	test   %eax,%eax
  80355c:	78 1b                	js     803579 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80355e:	83 ec 04             	sub    $0x4,%esp
  803561:	ff 75 10             	pushl  0x10(%ebp)
  803564:	ff 75 0c             	pushl  0xc(%ebp)
  803567:	50                   	push   %eax
  803568:	e8 22 01 00 00       	call   80368f <nsipc_accept>
  80356d:	83 c4 10             	add    $0x10,%esp
  803570:	85 c0                	test   %eax,%eax
  803572:	78 05                	js     803579 <accept+0x31>
	return alloc_sockfd(r);
  803574:	e8 5b ff ff ff       	call   8034d4 <alloc_sockfd>
}
  803579:	c9                   	leave  
  80357a:	c3                   	ret    

0080357b <bind>:
{
  80357b:	f3 0f 1e fb          	endbr32 
  80357f:	55                   	push   %ebp
  803580:	89 e5                	mov    %esp,%ebp
  803582:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	e8 17 ff ff ff       	call   8034a4 <fd2sockid>
  80358d:	85 c0                	test   %eax,%eax
  80358f:	78 12                	js     8035a3 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  803591:	83 ec 04             	sub    $0x4,%esp
  803594:	ff 75 10             	pushl  0x10(%ebp)
  803597:	ff 75 0c             	pushl  0xc(%ebp)
  80359a:	50                   	push   %eax
  80359b:	e8 45 01 00 00       	call   8036e5 <nsipc_bind>
  8035a0:	83 c4 10             	add    $0x10,%esp
}
  8035a3:	c9                   	leave  
  8035a4:	c3                   	ret    

008035a5 <shutdown>:
{
  8035a5:	f3 0f 1e fb          	endbr32 
  8035a9:	55                   	push   %ebp
  8035aa:	89 e5                	mov    %esp,%ebp
  8035ac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8035af:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b2:	e8 ed fe ff ff       	call   8034a4 <fd2sockid>
  8035b7:	85 c0                	test   %eax,%eax
  8035b9:	78 0f                	js     8035ca <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8035bb:	83 ec 08             	sub    $0x8,%esp
  8035be:	ff 75 0c             	pushl  0xc(%ebp)
  8035c1:	50                   	push   %eax
  8035c2:	e8 57 01 00 00       	call   80371e <nsipc_shutdown>
  8035c7:	83 c4 10             	add    $0x10,%esp
}
  8035ca:	c9                   	leave  
  8035cb:	c3                   	ret    

008035cc <connect>:
{
  8035cc:	f3 0f 1e fb          	endbr32 
  8035d0:	55                   	push   %ebp
  8035d1:	89 e5                	mov    %esp,%ebp
  8035d3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	e8 c6 fe ff ff       	call   8034a4 <fd2sockid>
  8035de:	85 c0                	test   %eax,%eax
  8035e0:	78 12                	js     8035f4 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8035e2:	83 ec 04             	sub    $0x4,%esp
  8035e5:	ff 75 10             	pushl  0x10(%ebp)
  8035e8:	ff 75 0c             	pushl  0xc(%ebp)
  8035eb:	50                   	push   %eax
  8035ec:	e8 71 01 00 00       	call   803762 <nsipc_connect>
  8035f1:	83 c4 10             	add    $0x10,%esp
}
  8035f4:	c9                   	leave  
  8035f5:	c3                   	ret    

008035f6 <listen>:
{
  8035f6:	f3 0f 1e fb          	endbr32 
  8035fa:	55                   	push   %ebp
  8035fb:	89 e5                	mov    %esp,%ebp
  8035fd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	e8 9c fe ff ff       	call   8034a4 <fd2sockid>
  803608:	85 c0                	test   %eax,%eax
  80360a:	78 0f                	js     80361b <listen+0x25>
	return nsipc_listen(r, backlog);
  80360c:	83 ec 08             	sub    $0x8,%esp
  80360f:	ff 75 0c             	pushl  0xc(%ebp)
  803612:	50                   	push   %eax
  803613:	e8 83 01 00 00       	call   80379b <nsipc_listen>
  803618:	83 c4 10             	add    $0x10,%esp
}
  80361b:	c9                   	leave  
  80361c:	c3                   	ret    

0080361d <socket>:

int
socket(int domain, int type, int protocol)
{
  80361d:	f3 0f 1e fb          	endbr32 
  803621:	55                   	push   %ebp
  803622:	89 e5                	mov    %esp,%ebp
  803624:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803627:	ff 75 10             	pushl  0x10(%ebp)
  80362a:	ff 75 0c             	pushl  0xc(%ebp)
  80362d:	ff 75 08             	pushl  0x8(%ebp)
  803630:	e8 65 02 00 00       	call   80389a <nsipc_socket>
  803635:	83 c4 10             	add    $0x10,%esp
  803638:	85 c0                	test   %eax,%eax
  80363a:	78 05                	js     803641 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  80363c:	e8 93 fe ff ff       	call   8034d4 <alloc_sockfd>
}
  803641:	c9                   	leave  
  803642:	c3                   	ret    

00803643 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803643:	55                   	push   %ebp
  803644:	89 e5                	mov    %esp,%ebp
  803646:	53                   	push   %ebx
  803647:	83 ec 04             	sub    $0x4,%esp
  80364a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80364c:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  803653:	74 26                	je     80367b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803655:	6a 07                	push   $0x7
  803657:	68 00 c0 80 00       	push   $0x80c000
  80365c:	53                   	push   %ebx
  80365d:	ff 35 04 a0 80 00    	pushl  0x80a004
  803663:	e8 84 f4 ff ff       	call   802aec <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803668:	83 c4 0c             	add    $0xc,%esp
  80366b:	6a 00                	push   $0x0
  80366d:	6a 00                	push   $0x0
  80366f:	6a 00                	push   $0x0
  803671:	e8 f1 f3 ff ff       	call   802a67 <ipc_recv>
}
  803676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803679:	c9                   	leave  
  80367a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80367b:	83 ec 0c             	sub    $0xc,%esp
  80367e:	6a 02                	push   $0x2
  803680:	e8 bf f4 ff ff       	call   802b44 <ipc_find_env>
  803685:	a3 04 a0 80 00       	mov    %eax,0x80a004
  80368a:	83 c4 10             	add    $0x10,%esp
  80368d:	eb c6                	jmp    803655 <nsipc+0x12>

0080368f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80368f:	f3 0f 1e fb          	endbr32 
  803693:	55                   	push   %ebp
  803694:	89 e5                	mov    %esp,%ebp
  803696:	56                   	push   %esi
  803697:	53                   	push   %ebx
  803698:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80369b:	8b 45 08             	mov    0x8(%ebp),%eax
  80369e:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8036a3:	8b 06                	mov    (%esi),%eax
  8036a5:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8036aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8036af:	e8 8f ff ff ff       	call   803643 <nsipc>
  8036b4:	89 c3                	mov    %eax,%ebx
  8036b6:	85 c0                	test   %eax,%eax
  8036b8:	79 09                	jns    8036c3 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8036ba:	89 d8                	mov    %ebx,%eax
  8036bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8036bf:	5b                   	pop    %ebx
  8036c0:	5e                   	pop    %esi
  8036c1:	5d                   	pop    %ebp
  8036c2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8036c3:	83 ec 04             	sub    $0x4,%esp
  8036c6:	ff 35 10 c0 80 00    	pushl  0x80c010
  8036cc:	68 00 c0 80 00       	push   $0x80c000
  8036d1:	ff 75 0c             	pushl  0xc(%ebp)
  8036d4:	e8 a9 ed ff ff       	call   802482 <memmove>
		*addrlen = ret->ret_addrlen;
  8036d9:	a1 10 c0 80 00       	mov    0x80c010,%eax
  8036de:	89 06                	mov    %eax,(%esi)
  8036e0:	83 c4 10             	add    $0x10,%esp
	return r;
  8036e3:	eb d5                	jmp    8036ba <nsipc_accept+0x2b>

008036e5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8036e5:	f3 0f 1e fb          	endbr32 
  8036e9:	55                   	push   %ebp
  8036ea:	89 e5                	mov    %esp,%ebp
  8036ec:	53                   	push   %ebx
  8036ed:	83 ec 08             	sub    $0x8,%esp
  8036f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8036f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f6:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8036fb:	53                   	push   %ebx
  8036fc:	ff 75 0c             	pushl  0xc(%ebp)
  8036ff:	68 04 c0 80 00       	push   $0x80c004
  803704:	e8 79 ed ff ff       	call   802482 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803709:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  80370f:	b8 02 00 00 00       	mov    $0x2,%eax
  803714:	e8 2a ff ff ff       	call   803643 <nsipc>
}
  803719:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80371c:	c9                   	leave  
  80371d:	c3                   	ret    

0080371e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80371e:	f3 0f 1e fb          	endbr32 
  803722:	55                   	push   %ebp
  803723:	89 e5                	mov    %esp,%ebp
  803725:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803728:	8b 45 08             	mov    0x8(%ebp),%eax
  80372b:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  803730:	8b 45 0c             	mov    0xc(%ebp),%eax
  803733:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  803738:	b8 03 00 00 00       	mov    $0x3,%eax
  80373d:	e8 01 ff ff ff       	call   803643 <nsipc>
}
  803742:	c9                   	leave  
  803743:	c3                   	ret    

00803744 <nsipc_close>:

int
nsipc_close(int s)
{
  803744:	f3 0f 1e fb          	endbr32 
  803748:	55                   	push   %ebp
  803749:	89 e5                	mov    %esp,%ebp
  80374b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  803756:	b8 04 00 00 00       	mov    $0x4,%eax
  80375b:	e8 e3 fe ff ff       	call   803643 <nsipc>
}
  803760:	c9                   	leave  
  803761:	c3                   	ret    

00803762 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803762:	f3 0f 1e fb          	endbr32 
  803766:	55                   	push   %ebp
  803767:	89 e5                	mov    %esp,%ebp
  803769:	53                   	push   %ebx
  80376a:	83 ec 08             	sub    $0x8,%esp
  80376d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803770:	8b 45 08             	mov    0x8(%ebp),%eax
  803773:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803778:	53                   	push   %ebx
  803779:	ff 75 0c             	pushl  0xc(%ebp)
  80377c:	68 04 c0 80 00       	push   $0x80c004
  803781:	e8 fc ec ff ff       	call   802482 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803786:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  80378c:	b8 05 00 00 00       	mov    $0x5,%eax
  803791:	e8 ad fe ff ff       	call   803643 <nsipc>
}
  803796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803799:	c9                   	leave  
  80379a:	c3                   	ret    

0080379b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80379b:	f3 0f 1e fb          	endbr32 
  80379f:	55                   	push   %ebp
  8037a0:	89 e5                	mov    %esp,%ebp
  8037a2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8037a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a8:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  8037ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b0:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  8037b5:	b8 06 00 00 00       	mov    $0x6,%eax
  8037ba:	e8 84 fe ff ff       	call   803643 <nsipc>
}
  8037bf:	c9                   	leave  
  8037c0:	c3                   	ret    

008037c1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8037c1:	f3 0f 1e fb          	endbr32 
  8037c5:	55                   	push   %ebp
  8037c6:	89 e5                	mov    %esp,%ebp
  8037c8:	56                   	push   %esi
  8037c9:	53                   	push   %ebx
  8037ca:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8037cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d0:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  8037d5:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  8037db:	8b 45 14             	mov    0x14(%ebp),%eax
  8037de:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8037e3:	b8 07 00 00 00       	mov    $0x7,%eax
  8037e8:	e8 56 fe ff ff       	call   803643 <nsipc>
  8037ed:	89 c3                	mov    %eax,%ebx
  8037ef:	85 c0                	test   %eax,%eax
  8037f1:	78 26                	js     803819 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  8037f3:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  8037f9:	b8 3f 06 00 00       	mov    $0x63f,%eax
  8037fe:	0f 4e c6             	cmovle %esi,%eax
  803801:	39 c3                	cmp    %eax,%ebx
  803803:	7f 1d                	jg     803822 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803805:	83 ec 04             	sub    $0x4,%esp
  803808:	53                   	push   %ebx
  803809:	68 00 c0 80 00       	push   $0x80c000
  80380e:	ff 75 0c             	pushl  0xc(%ebp)
  803811:	e8 6c ec ff ff       	call   802482 <memmove>
  803816:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  803819:	89 d8                	mov    %ebx,%eax
  80381b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80381e:	5b                   	pop    %ebx
  80381f:	5e                   	pop    %esi
  803820:	5d                   	pop    %ebp
  803821:	c3                   	ret    
		assert(r < 1600 && r <= len);
  803822:	68 9e 4a 80 00       	push   $0x804a9e
  803827:	68 7d 40 80 00       	push   $0x80407d
  80382c:	6a 62                	push   $0x62
  80382e:	68 b3 4a 80 00       	push   $0x804ab3
  803833:	e8 a3 e3 ff ff       	call   801bdb <_panic>

00803838 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803838:	f3 0f 1e fb          	endbr32 
  80383c:	55                   	push   %ebp
  80383d:	89 e5                	mov    %esp,%ebp
  80383f:	53                   	push   %ebx
  803840:	83 ec 04             	sub    $0x4,%esp
  803843:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803846:	8b 45 08             	mov    0x8(%ebp),%eax
  803849:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  80384e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803854:	7f 2e                	jg     803884 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803856:	83 ec 04             	sub    $0x4,%esp
  803859:	53                   	push   %ebx
  80385a:	ff 75 0c             	pushl  0xc(%ebp)
  80385d:	68 0c c0 80 00       	push   $0x80c00c
  803862:	e8 1b ec ff ff       	call   802482 <memmove>
	nsipcbuf.send.req_size = size;
  803867:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  80386d:	8b 45 14             	mov    0x14(%ebp),%eax
  803870:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  803875:	b8 08 00 00 00       	mov    $0x8,%eax
  80387a:	e8 c4 fd ff ff       	call   803643 <nsipc>
}
  80387f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803882:	c9                   	leave  
  803883:	c3                   	ret    
	assert(size < 1600);
  803884:	68 bf 4a 80 00       	push   $0x804abf
  803889:	68 7d 40 80 00       	push   $0x80407d
  80388e:	6a 6d                	push   $0x6d
  803890:	68 b3 4a 80 00       	push   $0x804ab3
  803895:	e8 41 e3 ff ff       	call   801bdb <_panic>

0080389a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80389a:	f3 0f 1e fb          	endbr32 
  80389e:	55                   	push   %ebp
  80389f:	89 e5                	mov    %esp,%ebp
  8038a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8038a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a7:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  8038ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038af:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  8038b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8038b7:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  8038bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8038c1:	e8 7d fd ff ff       	call   803643 <nsipc>
}
  8038c6:	c9                   	leave  
  8038c7:	c3                   	ret    

008038c8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8038c8:	f3 0f 1e fb          	endbr32 
  8038cc:	55                   	push   %ebp
  8038cd:	89 e5                	mov    %esp,%ebp
  8038cf:	56                   	push   %esi
  8038d0:	53                   	push   %ebx
  8038d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8038d4:	83 ec 0c             	sub    $0xc,%esp
  8038d7:	ff 75 08             	pushl  0x8(%ebp)
  8038da:	e8 b6 f2 ff ff       	call   802b95 <fd2data>
  8038df:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8038e1:	83 c4 08             	add    $0x8,%esp
  8038e4:	68 cb 4a 80 00       	push   $0x804acb
  8038e9:	53                   	push   %ebx
  8038ea:	e8 dd e9 ff ff       	call   8022cc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8038ef:	8b 46 04             	mov    0x4(%esi),%eax
  8038f2:	2b 06                	sub    (%esi),%eax
  8038f4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8038fa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803901:	00 00 00 
	stat->st_dev = &devpipe;
  803904:	c7 83 88 00 00 00 9c 	movl   $0x80909c,0x88(%ebx)
  80390b:	90 80 00 
	return 0;
}
  80390e:	b8 00 00 00 00       	mov    $0x0,%eax
  803913:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803916:	5b                   	pop    %ebx
  803917:	5e                   	pop    %esi
  803918:	5d                   	pop    %ebp
  803919:	c3                   	ret    

0080391a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80391a:	f3 0f 1e fb          	endbr32 
  80391e:	55                   	push   %ebp
  80391f:	89 e5                	mov    %esp,%ebp
  803921:	53                   	push   %ebx
  803922:	83 ec 0c             	sub    $0xc,%esp
  803925:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803928:	53                   	push   %ebx
  803929:	6a 00                	push   $0x0
  80392b:	e8 6b ee ff ff       	call   80279b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803930:	89 1c 24             	mov    %ebx,(%esp)
  803933:	e8 5d f2 ff ff       	call   802b95 <fd2data>
  803938:	83 c4 08             	add    $0x8,%esp
  80393b:	50                   	push   %eax
  80393c:	6a 00                	push   $0x0
  80393e:	e8 58 ee ff ff       	call   80279b <sys_page_unmap>
}
  803943:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803946:	c9                   	leave  
  803947:	c3                   	ret    

00803948 <_pipeisclosed>:
{
  803948:	55                   	push   %ebp
  803949:	89 e5                	mov    %esp,%ebp
  80394b:	57                   	push   %edi
  80394c:	56                   	push   %esi
  80394d:	53                   	push   %ebx
  80394e:	83 ec 1c             	sub    $0x1c,%esp
  803951:	89 c7                	mov    %eax,%edi
  803953:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  803955:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80395a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80395d:	83 ec 0c             	sub    $0xc,%esp
  803960:	57                   	push   %edi
  803961:	e8 6a fa ff ff       	call   8033d0 <pageref>
  803966:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803969:	89 34 24             	mov    %esi,(%esp)
  80396c:	e8 5f fa ff ff       	call   8033d0 <pageref>
		nn = thisenv->env_runs;
  803971:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  803977:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80397a:	83 c4 10             	add    $0x10,%esp
  80397d:	39 cb                	cmp    %ecx,%ebx
  80397f:	74 1b                	je     80399c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  803981:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803984:	75 cf                	jne    803955 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803986:	8b 42 58             	mov    0x58(%edx),%eax
  803989:	6a 01                	push   $0x1
  80398b:	50                   	push   %eax
  80398c:	53                   	push   %ebx
  80398d:	68 d2 4a 80 00       	push   $0x804ad2
  803992:	e8 2b e3 ff ff       	call   801cc2 <cprintf>
  803997:	83 c4 10             	add    $0x10,%esp
  80399a:	eb b9                	jmp    803955 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80399c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80399f:	0f 94 c0             	sete   %al
  8039a2:	0f b6 c0             	movzbl %al,%eax
}
  8039a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8039a8:	5b                   	pop    %ebx
  8039a9:	5e                   	pop    %esi
  8039aa:	5f                   	pop    %edi
  8039ab:	5d                   	pop    %ebp
  8039ac:	c3                   	ret    

008039ad <devpipe_write>:
{
  8039ad:	f3 0f 1e fb          	endbr32 
  8039b1:	55                   	push   %ebp
  8039b2:	89 e5                	mov    %esp,%ebp
  8039b4:	57                   	push   %edi
  8039b5:	56                   	push   %esi
  8039b6:	53                   	push   %ebx
  8039b7:	83 ec 28             	sub    $0x28,%esp
  8039ba:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8039bd:	56                   	push   %esi
  8039be:	e8 d2 f1 ff ff       	call   802b95 <fd2data>
  8039c3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8039c5:	83 c4 10             	add    $0x10,%esp
  8039c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8039cd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8039d0:	74 4f                	je     803a21 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039d2:	8b 43 04             	mov    0x4(%ebx),%eax
  8039d5:	8b 0b                	mov    (%ebx),%ecx
  8039d7:	8d 51 20             	lea    0x20(%ecx),%edx
  8039da:	39 d0                	cmp    %edx,%eax
  8039dc:	72 14                	jb     8039f2 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8039de:	89 da                	mov    %ebx,%edx
  8039e0:	89 f0                	mov    %esi,%eax
  8039e2:	e8 61 ff ff ff       	call   803948 <_pipeisclosed>
  8039e7:	85 c0                	test   %eax,%eax
  8039e9:	75 3b                	jne    803a26 <devpipe_write+0x79>
			sys_yield();
  8039eb:	e8 fb ec ff ff       	call   8026eb <sys_yield>
  8039f0:	eb e0                	jmp    8039d2 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8039f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8039f5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8039f9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8039fc:	89 c2                	mov    %eax,%edx
  8039fe:	c1 fa 1f             	sar    $0x1f,%edx
  803a01:	89 d1                	mov    %edx,%ecx
  803a03:	c1 e9 1b             	shr    $0x1b,%ecx
  803a06:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803a09:	83 e2 1f             	and    $0x1f,%edx
  803a0c:	29 ca                	sub    %ecx,%edx
  803a0e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803a12:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803a16:	83 c0 01             	add    $0x1,%eax
  803a19:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  803a1c:	83 c7 01             	add    $0x1,%edi
  803a1f:	eb ac                	jmp    8039cd <devpipe_write+0x20>
	return i;
  803a21:	8b 45 10             	mov    0x10(%ebp),%eax
  803a24:	eb 05                	jmp    803a2b <devpipe_write+0x7e>
				return 0;
  803a26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803a2e:	5b                   	pop    %ebx
  803a2f:	5e                   	pop    %esi
  803a30:	5f                   	pop    %edi
  803a31:	5d                   	pop    %ebp
  803a32:	c3                   	ret    

00803a33 <devpipe_read>:
{
  803a33:	f3 0f 1e fb          	endbr32 
  803a37:	55                   	push   %ebp
  803a38:	89 e5                	mov    %esp,%ebp
  803a3a:	57                   	push   %edi
  803a3b:	56                   	push   %esi
  803a3c:	53                   	push   %ebx
  803a3d:	83 ec 18             	sub    $0x18,%esp
  803a40:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803a43:	57                   	push   %edi
  803a44:	e8 4c f1 ff ff       	call   802b95 <fd2data>
  803a49:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803a4b:	83 c4 10             	add    $0x10,%esp
  803a4e:	be 00 00 00 00       	mov    $0x0,%esi
  803a53:	3b 75 10             	cmp    0x10(%ebp),%esi
  803a56:	75 14                	jne    803a6c <devpipe_read+0x39>
	return i;
  803a58:	8b 45 10             	mov    0x10(%ebp),%eax
  803a5b:	eb 02                	jmp    803a5f <devpipe_read+0x2c>
				return i;
  803a5d:	89 f0                	mov    %esi,%eax
}
  803a5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803a62:	5b                   	pop    %ebx
  803a63:	5e                   	pop    %esi
  803a64:	5f                   	pop    %edi
  803a65:	5d                   	pop    %ebp
  803a66:	c3                   	ret    
			sys_yield();
  803a67:	e8 7f ec ff ff       	call   8026eb <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  803a6c:	8b 03                	mov    (%ebx),%eax
  803a6e:	3b 43 04             	cmp    0x4(%ebx),%eax
  803a71:	75 18                	jne    803a8b <devpipe_read+0x58>
			if (i > 0)
  803a73:	85 f6                	test   %esi,%esi
  803a75:	75 e6                	jne    803a5d <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  803a77:	89 da                	mov    %ebx,%edx
  803a79:	89 f8                	mov    %edi,%eax
  803a7b:	e8 c8 fe ff ff       	call   803948 <_pipeisclosed>
  803a80:	85 c0                	test   %eax,%eax
  803a82:	74 e3                	je     803a67 <devpipe_read+0x34>
				return 0;
  803a84:	b8 00 00 00 00       	mov    $0x0,%eax
  803a89:	eb d4                	jmp    803a5f <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a8b:	99                   	cltd   
  803a8c:	c1 ea 1b             	shr    $0x1b,%edx
  803a8f:	01 d0                	add    %edx,%eax
  803a91:	83 e0 1f             	and    $0x1f,%eax
  803a94:	29 d0                	sub    %edx,%eax
  803a96:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803a9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803a9e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803aa1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803aa4:	83 c6 01             	add    $0x1,%esi
  803aa7:	eb aa                	jmp    803a53 <devpipe_read+0x20>

00803aa9 <pipe>:
{
  803aa9:	f3 0f 1e fb          	endbr32 
  803aad:	55                   	push   %ebp
  803aae:	89 e5                	mov    %esp,%ebp
  803ab0:	56                   	push   %esi
  803ab1:	53                   	push   %ebx
  803ab2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803ab5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ab8:	50                   	push   %eax
  803ab9:	e8 f2 f0 ff ff       	call   802bb0 <fd_alloc>
  803abe:	89 c3                	mov    %eax,%ebx
  803ac0:	83 c4 10             	add    $0x10,%esp
  803ac3:	85 c0                	test   %eax,%eax
  803ac5:	0f 88 23 01 00 00    	js     803bee <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803acb:	83 ec 04             	sub    $0x4,%esp
  803ace:	68 07 04 00 00       	push   $0x407
  803ad3:	ff 75 f4             	pushl  -0xc(%ebp)
  803ad6:	6a 00                	push   $0x0
  803ad8:	e8 31 ec ff ff       	call   80270e <sys_page_alloc>
  803add:	89 c3                	mov    %eax,%ebx
  803adf:	83 c4 10             	add    $0x10,%esp
  803ae2:	85 c0                	test   %eax,%eax
  803ae4:	0f 88 04 01 00 00    	js     803bee <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  803aea:	83 ec 0c             	sub    $0xc,%esp
  803aed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803af0:	50                   	push   %eax
  803af1:	e8 ba f0 ff ff       	call   802bb0 <fd_alloc>
  803af6:	89 c3                	mov    %eax,%ebx
  803af8:	83 c4 10             	add    $0x10,%esp
  803afb:	85 c0                	test   %eax,%eax
  803afd:	0f 88 db 00 00 00    	js     803bde <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b03:	83 ec 04             	sub    $0x4,%esp
  803b06:	68 07 04 00 00       	push   $0x407
  803b0b:	ff 75 f0             	pushl  -0x10(%ebp)
  803b0e:	6a 00                	push   $0x0
  803b10:	e8 f9 eb ff ff       	call   80270e <sys_page_alloc>
  803b15:	89 c3                	mov    %eax,%ebx
  803b17:	83 c4 10             	add    $0x10,%esp
  803b1a:	85 c0                	test   %eax,%eax
  803b1c:	0f 88 bc 00 00 00    	js     803bde <pipe+0x135>
	va = fd2data(fd0);
  803b22:	83 ec 0c             	sub    $0xc,%esp
  803b25:	ff 75 f4             	pushl  -0xc(%ebp)
  803b28:	e8 68 f0 ff ff       	call   802b95 <fd2data>
  803b2d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b2f:	83 c4 0c             	add    $0xc,%esp
  803b32:	68 07 04 00 00       	push   $0x407
  803b37:	50                   	push   %eax
  803b38:	6a 00                	push   $0x0
  803b3a:	e8 cf eb ff ff       	call   80270e <sys_page_alloc>
  803b3f:	89 c3                	mov    %eax,%ebx
  803b41:	83 c4 10             	add    $0x10,%esp
  803b44:	85 c0                	test   %eax,%eax
  803b46:	0f 88 82 00 00 00    	js     803bce <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b4c:	83 ec 0c             	sub    $0xc,%esp
  803b4f:	ff 75 f0             	pushl  -0x10(%ebp)
  803b52:	e8 3e f0 ff ff       	call   802b95 <fd2data>
  803b57:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803b5e:	50                   	push   %eax
  803b5f:	6a 00                	push   $0x0
  803b61:	56                   	push   %esi
  803b62:	6a 00                	push   $0x0
  803b64:	e8 ec eb ff ff       	call   802755 <sys_page_map>
  803b69:	89 c3                	mov    %eax,%ebx
  803b6b:	83 c4 20             	add    $0x20,%esp
  803b6e:	85 c0                	test   %eax,%eax
  803b70:	78 4e                	js     803bc0 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  803b72:	a1 9c 90 80 00       	mov    0x80909c,%eax
  803b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b7a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  803b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b7f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  803b86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b89:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  803b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b8e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803b95:	83 ec 0c             	sub    $0xc,%esp
  803b98:	ff 75 f4             	pushl  -0xc(%ebp)
  803b9b:	e8 e1 ef ff ff       	call   802b81 <fd2num>
  803ba0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803ba3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803ba5:	83 c4 04             	add    $0x4,%esp
  803ba8:	ff 75 f0             	pushl  -0x10(%ebp)
  803bab:	e8 d1 ef ff ff       	call   802b81 <fd2num>
  803bb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803bb3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803bb6:	83 c4 10             	add    $0x10,%esp
  803bb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  803bbe:	eb 2e                	jmp    803bee <pipe+0x145>
	sys_page_unmap(0, va);
  803bc0:	83 ec 08             	sub    $0x8,%esp
  803bc3:	56                   	push   %esi
  803bc4:	6a 00                	push   $0x0
  803bc6:	e8 d0 eb ff ff       	call   80279b <sys_page_unmap>
  803bcb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803bce:	83 ec 08             	sub    $0x8,%esp
  803bd1:	ff 75 f0             	pushl  -0x10(%ebp)
  803bd4:	6a 00                	push   $0x0
  803bd6:	e8 c0 eb ff ff       	call   80279b <sys_page_unmap>
  803bdb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803bde:	83 ec 08             	sub    $0x8,%esp
  803be1:	ff 75 f4             	pushl  -0xc(%ebp)
  803be4:	6a 00                	push   $0x0
  803be6:	e8 b0 eb ff ff       	call   80279b <sys_page_unmap>
  803beb:	83 c4 10             	add    $0x10,%esp
}
  803bee:	89 d8                	mov    %ebx,%eax
  803bf0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803bf3:	5b                   	pop    %ebx
  803bf4:	5e                   	pop    %esi
  803bf5:	5d                   	pop    %ebp
  803bf6:	c3                   	ret    

00803bf7 <pipeisclosed>:
{
  803bf7:	f3 0f 1e fb          	endbr32 
  803bfb:	55                   	push   %ebp
  803bfc:	89 e5                	mov    %esp,%ebp
  803bfe:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803c04:	50                   	push   %eax
  803c05:	ff 75 08             	pushl  0x8(%ebp)
  803c08:	e8 f9 ef ff ff       	call   802c06 <fd_lookup>
  803c0d:	83 c4 10             	add    $0x10,%esp
  803c10:	85 c0                	test   %eax,%eax
  803c12:	78 18                	js     803c2c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  803c14:	83 ec 0c             	sub    $0xc,%esp
  803c17:	ff 75 f4             	pushl  -0xc(%ebp)
  803c1a:	e8 76 ef ff ff       	call   802b95 <fd2data>
  803c1f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  803c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c24:	e8 1f fd ff ff       	call   803948 <_pipeisclosed>
  803c29:	83 c4 10             	add    $0x10,%esp
}
  803c2c:	c9                   	leave  
  803c2d:	c3                   	ret    

00803c2e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803c2e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  803c32:	b8 00 00 00 00       	mov    $0x0,%eax
  803c37:	c3                   	ret    

00803c38 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803c38:	f3 0f 1e fb          	endbr32 
  803c3c:	55                   	push   %ebp
  803c3d:	89 e5                	mov    %esp,%ebp
  803c3f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  803c42:	68 ea 4a 80 00       	push   $0x804aea
  803c47:	ff 75 0c             	pushl  0xc(%ebp)
  803c4a:	e8 7d e6 ff ff       	call   8022cc <strcpy>
	return 0;
}
  803c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c54:	c9                   	leave  
  803c55:	c3                   	ret    

00803c56 <devcons_write>:
{
  803c56:	f3 0f 1e fb          	endbr32 
  803c5a:	55                   	push   %ebp
  803c5b:	89 e5                	mov    %esp,%ebp
  803c5d:	57                   	push   %edi
  803c5e:	56                   	push   %esi
  803c5f:	53                   	push   %ebx
  803c60:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  803c66:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  803c6b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  803c71:	3b 75 10             	cmp    0x10(%ebp),%esi
  803c74:	73 31                	jae    803ca7 <devcons_write+0x51>
		m = n - tot;
  803c76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803c79:	29 f3                	sub    %esi,%ebx
  803c7b:	83 fb 7f             	cmp    $0x7f,%ebx
  803c7e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803c83:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  803c86:	83 ec 04             	sub    $0x4,%esp
  803c89:	53                   	push   %ebx
  803c8a:	89 f0                	mov    %esi,%eax
  803c8c:	03 45 0c             	add    0xc(%ebp),%eax
  803c8f:	50                   	push   %eax
  803c90:	57                   	push   %edi
  803c91:	e8 ec e7 ff ff       	call   802482 <memmove>
		sys_cputs(buf, m);
  803c96:	83 c4 08             	add    $0x8,%esp
  803c99:	53                   	push   %ebx
  803c9a:	57                   	push   %edi
  803c9b:	e8 9e e9 ff ff       	call   80263e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803ca0:	01 de                	add    %ebx,%esi
  803ca2:	83 c4 10             	add    $0x10,%esp
  803ca5:	eb ca                	jmp    803c71 <devcons_write+0x1b>
}
  803ca7:	89 f0                	mov    %esi,%eax
  803ca9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803cac:	5b                   	pop    %ebx
  803cad:	5e                   	pop    %esi
  803cae:	5f                   	pop    %edi
  803caf:	5d                   	pop    %ebp
  803cb0:	c3                   	ret    

00803cb1 <devcons_read>:
{
  803cb1:	f3 0f 1e fb          	endbr32 
  803cb5:	55                   	push   %ebp
  803cb6:	89 e5                	mov    %esp,%ebp
  803cb8:	83 ec 08             	sub    $0x8,%esp
  803cbb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803cc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803cc4:	74 21                	je     803ce7 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  803cc6:	e8 95 e9 ff ff       	call   802660 <sys_cgetc>
  803ccb:	85 c0                	test   %eax,%eax
  803ccd:	75 07                	jne    803cd6 <devcons_read+0x25>
		sys_yield();
  803ccf:	e8 17 ea ff ff       	call   8026eb <sys_yield>
  803cd4:	eb f0                	jmp    803cc6 <devcons_read+0x15>
	if (c < 0)
  803cd6:	78 0f                	js     803ce7 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  803cd8:	83 f8 04             	cmp    $0x4,%eax
  803cdb:	74 0c                	je     803ce9 <devcons_read+0x38>
	*(char*)vbuf = c;
  803cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ce0:	88 02                	mov    %al,(%edx)
	return 1;
  803ce2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ce7:	c9                   	leave  
  803ce8:	c3                   	ret    
		return 0;
  803ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cee:	eb f7                	jmp    803ce7 <devcons_read+0x36>

00803cf0 <cputchar>:
{
  803cf0:	f3 0f 1e fb          	endbr32 
  803cf4:	55                   	push   %ebp
  803cf5:	89 e5                	mov    %esp,%ebp
  803cf7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803d00:	6a 01                	push   $0x1
  803d02:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803d05:	50                   	push   %eax
  803d06:	e8 33 e9 ff ff       	call   80263e <sys_cputs>
}
  803d0b:	83 c4 10             	add    $0x10,%esp
  803d0e:	c9                   	leave  
  803d0f:	c3                   	ret    

00803d10 <getchar>:
{
  803d10:	f3 0f 1e fb          	endbr32 
  803d14:	55                   	push   %ebp
  803d15:	89 e5                	mov    %esp,%ebp
  803d17:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  803d1a:	6a 01                	push   $0x1
  803d1c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803d1f:	50                   	push   %eax
  803d20:	6a 00                	push   $0x0
  803d22:	e8 67 f1 ff ff       	call   802e8e <read>
	if (r < 0)
  803d27:	83 c4 10             	add    $0x10,%esp
  803d2a:	85 c0                	test   %eax,%eax
  803d2c:	78 06                	js     803d34 <getchar+0x24>
	if (r < 1)
  803d2e:	74 06                	je     803d36 <getchar+0x26>
	return c;
  803d30:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803d34:	c9                   	leave  
  803d35:	c3                   	ret    
		return -E_EOF;
  803d36:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803d3b:	eb f7                	jmp    803d34 <getchar+0x24>

00803d3d <iscons>:
{
  803d3d:	f3 0f 1e fb          	endbr32 
  803d41:	55                   	push   %ebp
  803d42:	89 e5                	mov    %esp,%ebp
  803d44:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803d4a:	50                   	push   %eax
  803d4b:	ff 75 08             	pushl  0x8(%ebp)
  803d4e:	e8 b3 ee ff ff       	call   802c06 <fd_lookup>
  803d53:	83 c4 10             	add    $0x10,%esp
  803d56:	85 c0                	test   %eax,%eax
  803d58:	78 11                	js     803d6b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  803d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5d:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803d63:	39 10                	cmp    %edx,(%eax)
  803d65:	0f 94 c0             	sete   %al
  803d68:	0f b6 c0             	movzbl %al,%eax
}
  803d6b:	c9                   	leave  
  803d6c:	c3                   	ret    

00803d6d <opencons>:
{
  803d6d:	f3 0f 1e fb          	endbr32 
  803d71:	55                   	push   %ebp
  803d72:	89 e5                	mov    %esp,%ebp
  803d74:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803d77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803d7a:	50                   	push   %eax
  803d7b:	e8 30 ee ff ff       	call   802bb0 <fd_alloc>
  803d80:	83 c4 10             	add    $0x10,%esp
  803d83:	85 c0                	test   %eax,%eax
  803d85:	78 3a                	js     803dc1 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d87:	83 ec 04             	sub    $0x4,%esp
  803d8a:	68 07 04 00 00       	push   $0x407
  803d8f:	ff 75 f4             	pushl  -0xc(%ebp)
  803d92:	6a 00                	push   $0x0
  803d94:	e8 75 e9 ff ff       	call   80270e <sys_page_alloc>
  803d99:	83 c4 10             	add    $0x10,%esp
  803d9c:	85 c0                	test   %eax,%eax
  803d9e:	78 21                	js     803dc1 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  803da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da3:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803da9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803db5:	83 ec 0c             	sub    $0xc,%esp
  803db8:	50                   	push   %eax
  803db9:	e8 c3 ed ff ff       	call   802b81 <fd2num>
  803dbe:	83 c4 10             	add    $0x10,%esp
}
  803dc1:	c9                   	leave  
  803dc2:	c3                   	ret    
  803dc3:	66 90                	xchg   %ax,%ax
  803dc5:	66 90                	xchg   %ax,%ax
  803dc7:	66 90                	xchg   %ax,%ax
  803dc9:	66 90                	xchg   %ax,%ax
  803dcb:	66 90                	xchg   %ax,%ax
  803dcd:	66 90                	xchg   %ax,%ax
  803dcf:	90                   	nop

00803dd0 <__udivdi3>:
  803dd0:	f3 0f 1e fb          	endbr32 
  803dd4:	55                   	push   %ebp
  803dd5:	57                   	push   %edi
  803dd6:	56                   	push   %esi
  803dd7:	53                   	push   %ebx
  803dd8:	83 ec 1c             	sub    $0x1c,%esp
  803ddb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803ddf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803de3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803de7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803deb:	85 d2                	test   %edx,%edx
  803ded:	75 19                	jne    803e08 <__udivdi3+0x38>
  803def:	39 f3                	cmp    %esi,%ebx
  803df1:	76 4d                	jbe    803e40 <__udivdi3+0x70>
  803df3:	31 ff                	xor    %edi,%edi
  803df5:	89 e8                	mov    %ebp,%eax
  803df7:	89 f2                	mov    %esi,%edx
  803df9:	f7 f3                	div    %ebx
  803dfb:	89 fa                	mov    %edi,%edx
  803dfd:	83 c4 1c             	add    $0x1c,%esp
  803e00:	5b                   	pop    %ebx
  803e01:	5e                   	pop    %esi
  803e02:	5f                   	pop    %edi
  803e03:	5d                   	pop    %ebp
  803e04:	c3                   	ret    
  803e05:	8d 76 00             	lea    0x0(%esi),%esi
  803e08:	39 f2                	cmp    %esi,%edx
  803e0a:	76 14                	jbe    803e20 <__udivdi3+0x50>
  803e0c:	31 ff                	xor    %edi,%edi
  803e0e:	31 c0                	xor    %eax,%eax
  803e10:	89 fa                	mov    %edi,%edx
  803e12:	83 c4 1c             	add    $0x1c,%esp
  803e15:	5b                   	pop    %ebx
  803e16:	5e                   	pop    %esi
  803e17:	5f                   	pop    %edi
  803e18:	5d                   	pop    %ebp
  803e19:	c3                   	ret    
  803e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803e20:	0f bd fa             	bsr    %edx,%edi
  803e23:	83 f7 1f             	xor    $0x1f,%edi
  803e26:	75 48                	jne    803e70 <__udivdi3+0xa0>
  803e28:	39 f2                	cmp    %esi,%edx
  803e2a:	72 06                	jb     803e32 <__udivdi3+0x62>
  803e2c:	31 c0                	xor    %eax,%eax
  803e2e:	39 eb                	cmp    %ebp,%ebx
  803e30:	77 de                	ja     803e10 <__udivdi3+0x40>
  803e32:	b8 01 00 00 00       	mov    $0x1,%eax
  803e37:	eb d7                	jmp    803e10 <__udivdi3+0x40>
  803e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803e40:	89 d9                	mov    %ebx,%ecx
  803e42:	85 db                	test   %ebx,%ebx
  803e44:	75 0b                	jne    803e51 <__udivdi3+0x81>
  803e46:	b8 01 00 00 00       	mov    $0x1,%eax
  803e4b:	31 d2                	xor    %edx,%edx
  803e4d:	f7 f3                	div    %ebx
  803e4f:	89 c1                	mov    %eax,%ecx
  803e51:	31 d2                	xor    %edx,%edx
  803e53:	89 f0                	mov    %esi,%eax
  803e55:	f7 f1                	div    %ecx
  803e57:	89 c6                	mov    %eax,%esi
  803e59:	89 e8                	mov    %ebp,%eax
  803e5b:	89 f7                	mov    %esi,%edi
  803e5d:	f7 f1                	div    %ecx
  803e5f:	89 fa                	mov    %edi,%edx
  803e61:	83 c4 1c             	add    $0x1c,%esp
  803e64:	5b                   	pop    %ebx
  803e65:	5e                   	pop    %esi
  803e66:	5f                   	pop    %edi
  803e67:	5d                   	pop    %ebp
  803e68:	c3                   	ret    
  803e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803e70:	89 f9                	mov    %edi,%ecx
  803e72:	b8 20 00 00 00       	mov    $0x20,%eax
  803e77:	29 f8                	sub    %edi,%eax
  803e79:	d3 e2                	shl    %cl,%edx
  803e7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  803e7f:	89 c1                	mov    %eax,%ecx
  803e81:	89 da                	mov    %ebx,%edx
  803e83:	d3 ea                	shr    %cl,%edx
  803e85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803e89:	09 d1                	or     %edx,%ecx
  803e8b:	89 f2                	mov    %esi,%edx
  803e8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e91:	89 f9                	mov    %edi,%ecx
  803e93:	d3 e3                	shl    %cl,%ebx
  803e95:	89 c1                	mov    %eax,%ecx
  803e97:	d3 ea                	shr    %cl,%edx
  803e99:	89 f9                	mov    %edi,%ecx
  803e9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803e9f:	89 eb                	mov    %ebp,%ebx
  803ea1:	d3 e6                	shl    %cl,%esi
  803ea3:	89 c1                	mov    %eax,%ecx
  803ea5:	d3 eb                	shr    %cl,%ebx
  803ea7:	09 de                	or     %ebx,%esi
  803ea9:	89 f0                	mov    %esi,%eax
  803eab:	f7 74 24 08          	divl   0x8(%esp)
  803eaf:	89 d6                	mov    %edx,%esi
  803eb1:	89 c3                	mov    %eax,%ebx
  803eb3:	f7 64 24 0c          	mull   0xc(%esp)
  803eb7:	39 d6                	cmp    %edx,%esi
  803eb9:	72 15                	jb     803ed0 <__udivdi3+0x100>
  803ebb:	89 f9                	mov    %edi,%ecx
  803ebd:	d3 e5                	shl    %cl,%ebp
  803ebf:	39 c5                	cmp    %eax,%ebp
  803ec1:	73 04                	jae    803ec7 <__udivdi3+0xf7>
  803ec3:	39 d6                	cmp    %edx,%esi
  803ec5:	74 09                	je     803ed0 <__udivdi3+0x100>
  803ec7:	89 d8                	mov    %ebx,%eax
  803ec9:	31 ff                	xor    %edi,%edi
  803ecb:	e9 40 ff ff ff       	jmp    803e10 <__udivdi3+0x40>
  803ed0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ed3:	31 ff                	xor    %edi,%edi
  803ed5:	e9 36 ff ff ff       	jmp    803e10 <__udivdi3+0x40>
  803eda:	66 90                	xchg   %ax,%ax
  803edc:	66 90                	xchg   %ax,%ax
  803ede:	66 90                	xchg   %ax,%ax

00803ee0 <__umoddi3>:
  803ee0:	f3 0f 1e fb          	endbr32 
  803ee4:	55                   	push   %ebp
  803ee5:	57                   	push   %edi
  803ee6:	56                   	push   %esi
  803ee7:	53                   	push   %ebx
  803ee8:	83 ec 1c             	sub    $0x1c,%esp
  803eeb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803eef:	8b 74 24 30          	mov    0x30(%esp),%esi
  803ef3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803ef7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803efb:	85 c0                	test   %eax,%eax
  803efd:	75 19                	jne    803f18 <__umoddi3+0x38>
  803eff:	39 df                	cmp    %ebx,%edi
  803f01:	76 5d                	jbe    803f60 <__umoddi3+0x80>
  803f03:	89 f0                	mov    %esi,%eax
  803f05:	89 da                	mov    %ebx,%edx
  803f07:	f7 f7                	div    %edi
  803f09:	89 d0                	mov    %edx,%eax
  803f0b:	31 d2                	xor    %edx,%edx
  803f0d:	83 c4 1c             	add    $0x1c,%esp
  803f10:	5b                   	pop    %ebx
  803f11:	5e                   	pop    %esi
  803f12:	5f                   	pop    %edi
  803f13:	5d                   	pop    %ebp
  803f14:	c3                   	ret    
  803f15:	8d 76 00             	lea    0x0(%esi),%esi
  803f18:	89 f2                	mov    %esi,%edx
  803f1a:	39 d8                	cmp    %ebx,%eax
  803f1c:	76 12                	jbe    803f30 <__umoddi3+0x50>
  803f1e:	89 f0                	mov    %esi,%eax
  803f20:	89 da                	mov    %ebx,%edx
  803f22:	83 c4 1c             	add    $0x1c,%esp
  803f25:	5b                   	pop    %ebx
  803f26:	5e                   	pop    %esi
  803f27:	5f                   	pop    %edi
  803f28:	5d                   	pop    %ebp
  803f29:	c3                   	ret    
  803f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803f30:	0f bd e8             	bsr    %eax,%ebp
  803f33:	83 f5 1f             	xor    $0x1f,%ebp
  803f36:	75 50                	jne    803f88 <__umoddi3+0xa8>
  803f38:	39 d8                	cmp    %ebx,%eax
  803f3a:	0f 82 e0 00 00 00    	jb     804020 <__umoddi3+0x140>
  803f40:	89 d9                	mov    %ebx,%ecx
  803f42:	39 f7                	cmp    %esi,%edi
  803f44:	0f 86 d6 00 00 00    	jbe    804020 <__umoddi3+0x140>
  803f4a:	89 d0                	mov    %edx,%eax
  803f4c:	89 ca                	mov    %ecx,%edx
  803f4e:	83 c4 1c             	add    $0x1c,%esp
  803f51:	5b                   	pop    %ebx
  803f52:	5e                   	pop    %esi
  803f53:	5f                   	pop    %edi
  803f54:	5d                   	pop    %ebp
  803f55:	c3                   	ret    
  803f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803f5d:	8d 76 00             	lea    0x0(%esi),%esi
  803f60:	89 fd                	mov    %edi,%ebp
  803f62:	85 ff                	test   %edi,%edi
  803f64:	75 0b                	jne    803f71 <__umoddi3+0x91>
  803f66:	b8 01 00 00 00       	mov    $0x1,%eax
  803f6b:	31 d2                	xor    %edx,%edx
  803f6d:	f7 f7                	div    %edi
  803f6f:	89 c5                	mov    %eax,%ebp
  803f71:	89 d8                	mov    %ebx,%eax
  803f73:	31 d2                	xor    %edx,%edx
  803f75:	f7 f5                	div    %ebp
  803f77:	89 f0                	mov    %esi,%eax
  803f79:	f7 f5                	div    %ebp
  803f7b:	89 d0                	mov    %edx,%eax
  803f7d:	31 d2                	xor    %edx,%edx
  803f7f:	eb 8c                	jmp    803f0d <__umoddi3+0x2d>
  803f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803f88:	89 e9                	mov    %ebp,%ecx
  803f8a:	ba 20 00 00 00       	mov    $0x20,%edx
  803f8f:	29 ea                	sub    %ebp,%edx
  803f91:	d3 e0                	shl    %cl,%eax
  803f93:	89 44 24 08          	mov    %eax,0x8(%esp)
  803f97:	89 d1                	mov    %edx,%ecx
  803f99:	89 f8                	mov    %edi,%eax
  803f9b:	d3 e8                	shr    %cl,%eax
  803f9d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803fa1:	89 54 24 04          	mov    %edx,0x4(%esp)
  803fa5:	8b 54 24 04          	mov    0x4(%esp),%edx
  803fa9:	09 c1                	or     %eax,%ecx
  803fab:	89 d8                	mov    %ebx,%eax
  803fad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fb1:	89 e9                	mov    %ebp,%ecx
  803fb3:	d3 e7                	shl    %cl,%edi
  803fb5:	89 d1                	mov    %edx,%ecx
  803fb7:	d3 e8                	shr    %cl,%eax
  803fb9:	89 e9                	mov    %ebp,%ecx
  803fbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fbf:	d3 e3                	shl    %cl,%ebx
  803fc1:	89 c7                	mov    %eax,%edi
  803fc3:	89 d1                	mov    %edx,%ecx
  803fc5:	89 f0                	mov    %esi,%eax
  803fc7:	d3 e8                	shr    %cl,%eax
  803fc9:	89 e9                	mov    %ebp,%ecx
  803fcb:	89 fa                	mov    %edi,%edx
  803fcd:	d3 e6                	shl    %cl,%esi
  803fcf:	09 d8                	or     %ebx,%eax
  803fd1:	f7 74 24 08          	divl   0x8(%esp)
  803fd5:	89 d1                	mov    %edx,%ecx
  803fd7:	89 f3                	mov    %esi,%ebx
  803fd9:	f7 64 24 0c          	mull   0xc(%esp)
  803fdd:	89 c6                	mov    %eax,%esi
  803fdf:	89 d7                	mov    %edx,%edi
  803fe1:	39 d1                	cmp    %edx,%ecx
  803fe3:	72 06                	jb     803feb <__umoddi3+0x10b>
  803fe5:	75 10                	jne    803ff7 <__umoddi3+0x117>
  803fe7:	39 c3                	cmp    %eax,%ebx
  803fe9:	73 0c                	jae    803ff7 <__umoddi3+0x117>
  803feb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803fef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803ff3:	89 d7                	mov    %edx,%edi
  803ff5:	89 c6                	mov    %eax,%esi
  803ff7:	89 ca                	mov    %ecx,%edx
  803ff9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803ffe:	29 f3                	sub    %esi,%ebx
  804000:	19 fa                	sbb    %edi,%edx
  804002:	89 d0                	mov    %edx,%eax
  804004:	d3 e0                	shl    %cl,%eax
  804006:	89 e9                	mov    %ebp,%ecx
  804008:	d3 eb                	shr    %cl,%ebx
  80400a:	d3 ea                	shr    %cl,%edx
  80400c:	09 d8                	or     %ebx,%eax
  80400e:	83 c4 1c             	add    $0x1c,%esp
  804011:	5b                   	pop    %ebx
  804012:	5e                   	pop    %esi
  804013:	5f                   	pop    %edi
  804014:	5d                   	pop    %ebp
  804015:	c3                   	ret    
  804016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80401d:	8d 76 00             	lea    0x0(%esi),%esi
  804020:	29 fe                	sub    %edi,%esi
  804022:	19 c3                	sbb    %eax,%ebx
  804024:	89 f2                	mov    %esi,%edx
  804026:	89 d9                	mov    %ebx,%ecx
  804028:	e9 1d ff ff ff       	jmp    803f4a <__umoddi3+0x6a>
