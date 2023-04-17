
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
  80002c:	e8 47 1b 00 00       	call   801b78 <libmain>
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
  8000b4:	68 c0 3a 80 00       	push   $0x803ac0
  8000b9:	e8 09 1c 00 00       	call   801cc7 <cprintf>
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
  8000e1:	68 d7 3a 80 00       	push   $0x803ad7
  8000e6:	6a 3a                	push   $0x3a
  8000e8:	68 e7 3a 80 00       	push   $0x803ae7
  8000ed:	e8 ee 1a 00 00       	call   801be0 <_panic>

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
  800170:	68 f0 3a 80 00       	push   $0x803af0
  800175:	68 fd 3a 80 00       	push   $0x803afd
  80017a:	6a 44                	push   $0x44
  80017c:	68 e7 3a 80 00       	push   $0x803ae7
  800181:	e8 5a 1a 00 00       	call   801be0 <_panic>
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
  80023a:	68 f0 3a 80 00       	push   $0x803af0
  80023f:	68 fd 3a 80 00       	push   $0x803afd
  800244:	6a 5d                	push   $0x5d
  800246:	68 e7 3a 80 00       	push   $0x803ae7
  80024b:	e8 90 19 00 00       	call   801be0 <_panic>
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
  8002af:	a1 08 a0 80 00       	mov    0x80a008,%eax
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
  8002cf:	e8 3f 24 00 00       	call   802713 <sys_page_alloc>
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
  80031a:	e8 3b 24 00 00       	call   80275a <sys_page_map>
  80031f:	83 c4 20             	add    $0x20,%esp
  800322:	85 c0                	test   %eax,%eax
  800324:	78 72                	js     800398 <bc_pgfault+0x112>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800326:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
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
  800351:	68 14 3b 80 00       	push   $0x803b14
  800356:	6a 26                	push   $0x26
  800358:	68 f4 3b 80 00       	push   $0x803bf4
  80035d:	e8 7e 18 00 00       	call   801be0 <_panic>
		panic("reading non-existent block %08x\n", blockno);
  800362:	57                   	push   %edi
  800363:	68 44 3b 80 00       	push   $0x803b44
  800368:	6a 2b                	push   $0x2b
  80036a:	68 f4 3b 80 00       	push   $0x803bf4
  80036f:	e8 6c 18 00 00       	call   801be0 <_panic>
		panic("in bc_pgfault, sys_page_alloc: %e\n", r);
  800374:	50                   	push   %eax
  800375:	68 68 3b 80 00       	push   $0x803b68
  80037a:	6a 35                	push   $0x35
  80037c:	68 f4 3b 80 00       	push   $0x803bf4
  800381:	e8 5a 18 00 00       	call   801be0 <_panic>
		panic("in bc_pgfault, ide_read: %e\n", r);
  800386:	50                   	push   %eax
  800387:	68 fc 3b 80 00       	push   $0x803bfc
  80038c:	6a 38                	push   $0x38
  80038e:	68 f4 3b 80 00       	push   $0x803bf4
  800393:	e8 48 18 00 00       	call   801be0 <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800398:	50                   	push   %eax
  800399:	68 8c 3b 80 00       	push   $0x803b8c
  80039e:	6a 3d                	push   $0x3d
  8003a0:	68 f4 3b 80 00       	push   $0x803bf4
  8003a5:	e8 36 18 00 00       	call   801be0 <_panic>
		panic("reading free block %08x\n", blockno);
  8003aa:	57                   	push   %edi
  8003ab:	68 19 3c 80 00       	push   $0x803c19
  8003b0:	6a 43                	push   $0x43
  8003b2:	68 f4 3b 80 00       	push   $0x803bf4
  8003b7:	e8 24 18 00 00       	call   801be0 <_panic>

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
  8003cd:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
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
  8003e7:	68 ac 3b 80 00       	push   $0x803bac
  8003ec:	6a 09                	push   $0x9
  8003ee:	68 f4 3b 80 00       	push   $0x803bf4
  8003f3:	e8 e8 17 00 00       	call   801be0 <_panic>

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
  80047e:	68 32 3c 80 00       	push   $0x803c32
  800483:	6a 53                	push   $0x53
  800485:	68 f4 3b 80 00       	push   $0x803bf4
  80048a:	e8 51 17 00 00       	call   801be0 <_panic>
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
  8004d3:	e8 82 22 00 00       	call   80275a <sys_page_map>
  8004d8:	83 c4 20             	add    $0x20,%esp
  8004db:	85 c0                	test   %eax,%eax
  8004dd:	79 97                	jns    800476 <flush_block+0x30>
		panic("flush_block: sys_page_map %e\n", r);
  8004df:	50                   	push   %eax
  8004e0:	68 68 3c 80 00       	push   $0x803c68
  8004e5:	6a 60                	push   $0x60
  8004e7:	68 f4 3b 80 00       	push   $0x803bf4
  8004ec:	e8 ef 16 00 00       	call   801be0 <_panic>
		panic("flush_block: ide_write %e\n", r);
  8004f1:	50                   	push   %eax
  8004f2:	68 4d 3c 80 00       	push   $0x803c4d
  8004f7:	6a 5c                	push   $0x5c
  8004f9:	68 f4 3b 80 00       	push   $0x803bf4
  8004fe:	e8 dd 16 00 00       	call   801be0 <_panic>

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
  800516:	e8 09 24 00 00       	call   802924 <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  80051b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800522:	e8 95 fe ff ff       	call   8003bc <diskaddr>
  800527:	83 c4 0c             	add    $0xc,%esp
  80052a:	68 08 01 00 00       	push   $0x108
  80052f:	50                   	push   %eax
  800530:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800536:	50                   	push   %eax
  800537:	e8 4b 1f 00 00       	call   802487 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  80053c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800543:	e8 74 fe ff ff       	call   8003bc <diskaddr>
  800548:	83 c4 08             	add    $0x8,%esp
  80054b:	68 86 3c 80 00       	push   $0x803c86
  800550:	50                   	push   %eax
  800551:	e8 7b 1d 00 00       	call   8022d1 <strcpy>
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
  8005b6:	e8 e5 21 00 00       	call   8027a0 <sys_page_unmap>
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
  8005e7:	68 86 3c 80 00       	push   $0x803c86
  8005ec:	50                   	push   %eax
  8005ed:	e8 9e 1d 00 00       	call   802390 <strcmp>
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
  800617:	e8 6b 1e 00 00       	call   802487 <memmove>
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
  800646:	e8 3c 1e 00 00       	call   802487 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  80064b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800652:	e8 65 fd ff ff       	call   8003bc <diskaddr>
  800657:	83 c4 08             	add    $0x8,%esp
  80065a:	68 86 3c 80 00       	push   $0x803c86
  80065f:	50                   	push   %eax
  800660:	e8 6c 1c 00 00       	call   8022d1 <strcpy>
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
  8006ab:	e8 f0 20 00 00       	call   8027a0 <sys_page_unmap>
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
  8006dc:	68 86 3c 80 00       	push   $0x803c86
  8006e1:	50                   	push   %eax
  8006e2:	e8 a9 1c 00 00       	call   802390 <strcmp>
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
  80070c:	e8 76 1d 00 00       	call   802487 <memmove>
	flush_block(diskaddr(1));
  800711:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800718:	e8 9f fc ff ff       	call   8003bc <diskaddr>
  80071d:	89 04 24             	mov    %eax,(%esp)
  800720:	e8 21 fd ff ff       	call   800446 <flush_block>
	cprintf("block cache is good\n");
  800725:	c7 04 24 c2 3c 80 00 	movl   $0x803cc2,(%esp)
  80072c:	e8 96 15 00 00       	call   801cc7 <cprintf>
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
  80074d:	e8 35 1d 00 00       	call   802487 <memmove>
}
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800758:	c9                   	leave  
  800759:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  80075a:	68 a8 3c 80 00       	push   $0x803ca8
  80075f:	68 fd 3a 80 00       	push   $0x803afd
  800764:	6a 70                	push   $0x70
  800766:	68 f4 3b 80 00       	push   $0x803bf4
  80076b:	e8 70 14 00 00       	call   801be0 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  800770:	68 8d 3c 80 00       	push   $0x803c8d
  800775:	68 fd 3a 80 00       	push   $0x803afd
  80077a:	6a 71                	push   $0x71
  80077c:	68 f4 3b 80 00       	push   $0x803bf4
  800781:	e8 5a 14 00 00       	call   801be0 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800786:	68 a7 3c 80 00       	push   $0x803ca7
  80078b:	68 fd 3a 80 00       	push   $0x803afd
  800790:	6a 75                	push   $0x75
  800792:	68 f4 3b 80 00       	push   $0x803bf4
  800797:	e8 44 14 00 00       	call   801be0 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80079c:	68 d0 3b 80 00       	push   $0x803bd0
  8007a1:	68 fd 3a 80 00       	push   $0x803afd
  8007a6:	6a 78                	push   $0x78
  8007a8:	68 f4 3b 80 00       	push   $0x803bf4
  8007ad:	e8 2e 14 00 00       	call   801be0 <_panic>
	assert(va_is_mapped(diskaddr(1)));
  8007b2:	68 a8 3c 80 00       	push   $0x803ca8
  8007b7:	68 fd 3a 80 00       	push   $0x803afd
  8007bc:	68 89 00 00 00       	push   $0x89
  8007c1:	68 f4 3b 80 00       	push   $0x803bf4
  8007c6:	e8 15 14 00 00       	call   801be0 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  8007cb:	68 a7 3c 80 00       	push   $0x803ca7
  8007d0:	68 fd 3a 80 00       	push   $0x803afd
  8007d5:	68 91 00 00 00       	push   $0x91
  8007da:	68 f4 3b 80 00       	push   $0x803bf4
  8007df:	e8 fc 13 00 00       	call   801be0 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007e4:	68 d0 3b 80 00       	push   $0x803bd0
  8007e9:	68 fd 3a 80 00       	push   $0x803afd
  8007ee:	68 94 00 00 00       	push   $0x94
  8007f3:	68 f4 3b 80 00       	push   $0x803bf4
  8007f8:	e8 e3 13 00 00       	call   801be0 <_panic>

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
  800807:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80080c:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  800812:	75 1b                	jne    80082f <check_super+0x32>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800814:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  80081b:	77 26                	ja     800843 <check_super+0x46>
		panic("file system is too large");

	cprintf("superblock is good\n");
  80081d:	83 ec 0c             	sub    $0xc,%esp
  800820:	68 15 3d 80 00       	push   $0x803d15
  800825:	e8 9d 14 00 00       	call   801cc7 <cprintf>
}
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	c9                   	leave  
  80082e:	c3                   	ret    
		panic("bad file system magic number");
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 d7 3c 80 00       	push   $0x803cd7
  800837:	6a 0f                	push   $0xf
  800839:	68 f4 3c 80 00       	push   $0x803cf4
  80083e:	e8 9d 13 00 00       	call   801be0 <_panic>
		panic("file system is too large");
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	68 fc 3c 80 00       	push   $0x803cfc
  80084b:	6a 12                	push   $0x12
  80084d:	68 f4 3c 80 00       	push   $0x803cf4
  800852:	e8 89 13 00 00       	call   801be0 <_panic>

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
  800862:	a1 08 a0 80 00       	mov    0x80a008,%eax
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
  800881:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
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
  8008b0:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  8008b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8008bb:	d3 e0                	shl    %cl,%eax
  8008bd:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  8008c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    
		panic("attempt to free zero block");
  8008c5:	83 ec 04             	sub    $0x4,%esp
  8008c8:	68 29 3d 80 00       	push   $0x803d29
  8008cd:	6a 2d                	push   $0x2d
  8008cf:	68 f4 3c 80 00       	push   $0x803cf4
  8008d4:	e8 07 13 00 00       	call   801be0 <_panic>

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
  8008e2:	a1 08 a0 80 00       	mov    0x80a008,%eax
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
  800912:	03 35 04 a0 80 00    	add    0x80a004,%esi
  800918:	ba 01 00 00 00       	mov    $0x1,%edx
  80091d:	89 d9                	mov    %ebx,%ecx
  80091f:	d3 e2                	shl    %cl,%edx
  800921:	f7 d2                	not    %edx
  800923:	21 16                	and    %edx,(%esi)
	//flush the changed bitmap block to disk.
	flush_block(&bitmap[blockno / 32]);
  800925:	83 ec 0c             	sub    $0xc,%esp
  800928:	03 05 04 a0 80 00    	add    0x80a004,%eax
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
  80099d:	e8 99 1a 00 00       	call   80243b <memset>
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
  800a0a:	a1 08 a0 80 00       	mov    0x80a008,%eax
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
  800a38:	68 44 3d 80 00       	push   $0x803d44
  800a3d:	68 fd 3a 80 00       	push   $0x803afd
  800a42:	6a 5a                	push   $0x5a
  800a44:	68 f4 3c 80 00       	push   $0x803cf4
  800a49:	e8 92 11 00 00       	call   801be0 <_panic>
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
  800a73:	68 7c 3d 80 00       	push   $0x803d7c
  800a78:	e8 4a 12 00 00       	call   801cc7 <cprintf>
}
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a83:	5b                   	pop    %ebx
  800a84:	5e                   	pop    %esi
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    
	assert(!block_is_free(0));
  800a87:	68 58 3d 80 00       	push   $0x803d58
  800a8c:	68 fd 3a 80 00       	push   $0x803afd
  800a91:	6a 5d                	push   $0x5d
  800a93:	68 f4 3c 80 00       	push   $0x803cf4
  800a98:	e8 43 11 00 00       	call   801be0 <_panic>
	assert(!block_is_free(1));
  800a9d:	68 6a 3d 80 00       	push   $0x803d6a
  800aa2:	68 fd 3a 80 00       	push   $0x803afd
  800aa7:	6a 5e                	push   $0x5e
  800aa9:	68 f4 3c 80 00       	push   $0x803cf4
  800aae:	e8 2d 11 00 00       	call   801be0 <_panic>

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
  800ae2:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_super();
  800ae7:	e8 11 fd ff ff       	call   8007fd <check_super>
	bitmap = diskaddr(2);
  800aec:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800af3:	e8 c4 f8 ff ff       	call   8003bc <diskaddr>
  800af8:	a3 04 a0 80 00       	mov    %eax,0x80a004
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
  800b66:	e8 d0 18 00 00       	call   80243b <memset>
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
  800bc1:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
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
  800c25:	e8 5d 18 00 00       	call   802487 <memmove>
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
  800cd7:	e8 b4 16 00 00       	call   802390 <strcmp>
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
  800cfa:	68 8c 3d 80 00       	push   $0x803d8c
  800cff:	68 fd 3a 80 00       	push   $0x803afd
  800d04:	68 f0 00 00 00       	push   $0xf0
  800d09:	68 f4 3c 80 00       	push   $0x803cf4
  800d0e:	e8 cd 0e 00 00       	call   801be0 <_panic>
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
  800d48:	e8 84 15 00 00       	call   8022d1 <strcpy>
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
  800e81:	e8 01 16 00 00       	call   802487 <memmove>
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
  800f2e:	68 a9 3d 80 00       	push   $0x803da9
  800f33:	e8 8f 0d 00 00       	call   801cc7 <cprintf>
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
  800ffb:	e8 87 14 00 00       	call   802487 <memmove>
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
  80117e:	68 8c 3d 80 00       	push   $0x803d8c
  801183:	68 fd 3a 80 00       	push   $0x803afd
  801188:	68 09 01 00 00       	push   $0x109
  80118d:	68 f4 3c 80 00       	push   $0x803cf4
  801192:	e8 49 0a 00 00       	call   801be0 <_panic>
				*file = &f[j];
  801197:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  80119d:	83 ec 08             	sub    $0x8,%esp
  8011a0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8011a6:	50                   	push   %eax
  8011a7:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  8011ad:	e8 1f 11 00 00       	call   8022d1 <strcpy>
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
  801222:	a1 08 a0 80 00       	mov    0x80a008,%eax
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
  8012af:	e8 6d 20 00 00       	call   803321 <pageref>
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
  8012e4:	e8 2a 14 00 00       	call   802713 <sys_page_alloc>
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
  801315:	e8 21 11 00 00       	call   80243b <memset>
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
  801352:	e8 ca 1f 00 00       	call   803321 <pageref>
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
  801493:	e8 39 0e 00 00       	call   8022d1 <strcpy>
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
  801525:	e8 5d 0f 00 00       	call   802487 <memmove>
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
  8016a1:	68 f8 3d 80 00       	push   $0x803df8
  8016a6:	e8 1c 06 00 00       	call   801cc7 <cprintf>
  8016ab:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  8016ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  8016b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8016b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b9:	50                   	push   %eax
  8016ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8016bd:	e8 80 13 00 00       	call   802a42 <ipc_send>
		sys_page_unmap(0, fsreq);
  8016c2:	83 c4 08             	add    $0x8,%esp
  8016c5:	ff 35 44 50 80 00    	pushl  0x805044
  8016cb:	6a 00                	push   $0x0
  8016cd:	e8 ce 10 00 00       	call   8027a0 <sys_page_unmap>
  8016d2:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  8016d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	53                   	push   %ebx
  8016e0:	ff 35 44 50 80 00    	pushl  0x805044
  8016e6:	56                   	push   %esi
  8016e7:	e8 d1 12 00 00       	call   8029bd <ipc_recv>
		if (!(perm & PTE_P)) {
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  8016f3:	0f 85 5a ff ff ff    	jne    801653 <serve+0x17>
			cprintf("Invalid request from %08x: no argument page\n",
  8016f9:	83 ec 08             	sub    $0x8,%esp
  8016fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ff:	68 c8 3d 80 00       	push   $0x803dc8
  801704:	e8 be 05 00 00       	call   801cc7 <cprintf>
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
  801718:	c7 05 60 90 80 00 1b 	movl   $0x803e1b,0x809060
  80171f:	3e 80 00 
	cprintf("FS is running\n");
  801722:	68 1e 3e 80 00       	push   $0x803e1e
  801727:	e8 9b 05 00 00       	call   801cc7 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80172c:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  801731:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801736:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  801738:	c7 04 24 2d 3e 80 00 	movl   $0x803e2d,(%esp)
  80173f:	e8 83 05 00 00       	call   801cc7 <cprintf>

	serve_init();
  801744:	e8 17 fb ff ff       	call   801260 <serve_init>
	fs_init();
  801749:	e8 65 f3 ff ff       	call   800ab3 <fs_init>
        fs_test();
  80174e:	e8 05 00 00 00       	call   801758 <fs_test>
	serve();
  801753:	e8 e4 fe ff ff       	call   80163c <serve>

00801758 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  801758:	f3 0f 1e fb          	endbr32 
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	53                   	push   %ebx
  801760:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801763:	6a 07                	push   $0x7
  801765:	68 00 10 00 00       	push   $0x1000
  80176a:	6a 00                	push   $0x0
  80176c:	e8 a2 0f 00 00       	call   802713 <sys_page_alloc>
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	0f 88 68 02 00 00    	js     8019e4 <fs_test+0x28c>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  80177c:	83 ec 04             	sub    $0x4,%esp
  80177f:	68 00 10 00 00       	push   $0x1000
  801784:	ff 35 04 a0 80 00    	pushl  0x80a004
  80178a:	68 00 10 00 00       	push   $0x1000
  80178f:	e8 f3 0c 00 00       	call   802487 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  801794:	e8 40 f1 ff ff       	call   8008d9 <alloc_block>
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	85 c0                	test   %eax,%eax
  80179e:	0f 88 52 02 00 00    	js     8019f6 <fs_test+0x29e>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8017a4:	8d 50 1f             	lea    0x1f(%eax),%edx
  8017a7:	0f 49 d0             	cmovns %eax,%edx
  8017aa:	c1 fa 05             	sar    $0x5,%edx
  8017ad:	89 c3                	mov    %eax,%ebx
  8017af:	c1 fb 1f             	sar    $0x1f,%ebx
  8017b2:	c1 eb 1b             	shr    $0x1b,%ebx
  8017b5:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  8017b8:	83 e1 1f             	and    $0x1f,%ecx
  8017bb:	29 d9                	sub    %ebx,%ecx
  8017bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c2:	d3 e0                	shl    %cl,%eax
  8017c4:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  8017cb:	0f 84 37 02 00 00    	je     801a08 <fs_test+0x2b0>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8017d1:	8b 0d 04 a0 80 00    	mov    0x80a004,%ecx
  8017d7:	85 04 91             	test   %eax,(%ecx,%edx,4)
  8017da:	0f 85 3e 02 00 00    	jne    801a1e <fs_test+0x2c6>
	cprintf("alloc_block is good\n");
  8017e0:	83 ec 0c             	sub    $0xc,%esp
  8017e3:	68 84 3e 80 00       	push   $0x803e84
  8017e8:	e8 da 04 00 00       	call   801cc7 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  8017ed:	83 c4 08             	add    $0x8,%esp
  8017f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f3:	50                   	push   %eax
  8017f4:	68 99 3e 80 00       	push   $0x803e99
  8017f9:	e8 d0 f5 ff ff       	call   800dce <file_open>
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801804:	74 08                	je     80180e <fs_test+0xb6>
  801806:	85 c0                	test   %eax,%eax
  801808:	0f 88 26 02 00 00    	js     801a34 <fs_test+0x2dc>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  80180e:	85 c0                	test   %eax,%eax
  801810:	0f 84 30 02 00 00    	je     801a46 <fs_test+0x2ee>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  801816:	83 ec 08             	sub    $0x8,%esp
  801819:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181c:	50                   	push   %eax
  80181d:	68 bd 3e 80 00       	push   $0x803ebd
  801822:	e8 a7 f5 ff ff       	call   800dce <file_open>
  801827:	83 c4 10             	add    $0x10,%esp
  80182a:	85 c0                	test   %eax,%eax
  80182c:	0f 88 28 02 00 00    	js     801a5a <fs_test+0x302>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  801832:	83 ec 0c             	sub    $0xc,%esp
  801835:	68 dd 3e 80 00       	push   $0x803edd
  80183a:	e8 88 04 00 00       	call   801cc7 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  80183f:	83 c4 0c             	add    $0xc,%esp
  801842:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801845:	50                   	push   %eax
  801846:	6a 00                	push   $0x0
  801848:	ff 75 f4             	pushl  -0xc(%ebp)
  80184b:	e8 c6 f2 ff ff       	call   800b16 <file_get_block>
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	85 c0                	test   %eax,%eax
  801855:	0f 88 11 02 00 00    	js     801a6c <fs_test+0x314>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  80185b:	83 ec 08             	sub    $0x8,%esp
  80185e:	68 24 40 80 00       	push   $0x804024
  801863:	ff 75 f0             	pushl  -0x10(%ebp)
  801866:	e8 25 0b 00 00       	call   802390 <strcmp>
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	85 c0                	test   %eax,%eax
  801870:	0f 85 08 02 00 00    	jne    801a7e <fs_test+0x326>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  801876:	83 ec 0c             	sub    $0xc,%esp
  801879:	68 03 3f 80 00       	push   $0x803f03
  80187e:	e8 44 04 00 00       	call   801cc7 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801886:	0f b6 10             	movzbl (%eax),%edx
  801889:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80188b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188e:	c1 e8 0c             	shr    $0xc,%eax
  801891:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	a8 40                	test   $0x40,%al
  80189d:	0f 84 ef 01 00 00    	je     801a92 <fs_test+0x33a>
	file_flush(f);
  8018a3:	83 ec 0c             	sub    $0xc,%esp
  8018a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a9:	e8 79 f7 ff ff       	call   801027 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8018ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b1:	c1 e8 0c             	shr    $0xc,%eax
  8018b4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	a8 40                	test   $0x40,%al
  8018c0:	0f 85 e2 01 00 00    	jne    801aa8 <fs_test+0x350>
	cprintf("file_flush is good\n");
  8018c6:	83 ec 0c             	sub    $0xc,%esp
  8018c9:	68 37 3f 80 00       	push   $0x803f37
  8018ce:	e8 f4 03 00 00       	call   801cc7 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  8018d3:	83 c4 08             	add    $0x8,%esp
  8018d6:	6a 00                	push   $0x0
  8018d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018db:	e8 ba f5 ff ff       	call   800e9a <file_set_size>
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	0f 88 d3 01 00 00    	js     801abe <fs_test+0x366>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  8018eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ee:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  8018f5:	0f 85 d5 01 00 00    	jne    801ad0 <fs_test+0x378>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8018fb:	c1 e8 0c             	shr    $0xc,%eax
  8018fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801905:	a8 40                	test   $0x40,%al
  801907:	0f 85 d9 01 00 00    	jne    801ae6 <fs_test+0x38e>
	cprintf("file_truncate is good\n");
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	68 8b 3f 80 00       	push   $0x803f8b
  801915:	e8 ad 03 00 00       	call   801cc7 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  80191a:	c7 04 24 24 40 80 00 	movl   $0x804024,(%esp)
  801921:	e8 68 09 00 00       	call   80228e <strlen>
  801926:	83 c4 08             	add    $0x8,%esp
  801929:	50                   	push   %eax
  80192a:	ff 75 f4             	pushl  -0xc(%ebp)
  80192d:	e8 68 f5 ff ff       	call   800e9a <file_set_size>
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	85 c0                	test   %eax,%eax
  801937:	0f 88 bf 01 00 00    	js     801afc <fs_test+0x3a4>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801940:	89 c2                	mov    %eax,%edx
  801942:	c1 ea 0c             	shr    $0xc,%edx
  801945:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80194c:	f6 c2 40             	test   $0x40,%dl
  80194f:	0f 85 b9 01 00 00    	jne    801b0e <fs_test+0x3b6>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801955:	83 ec 04             	sub    $0x4,%esp
  801958:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80195b:	52                   	push   %edx
  80195c:	6a 00                	push   $0x0
  80195e:	50                   	push   %eax
  80195f:	e8 b2 f1 ff ff       	call   800b16 <file_get_block>
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	85 c0                	test   %eax,%eax
  801969:	0f 88 b5 01 00 00    	js     801b24 <fs_test+0x3cc>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  80196f:	83 ec 08             	sub    $0x8,%esp
  801972:	68 24 40 80 00       	push   $0x804024
  801977:	ff 75 f0             	pushl  -0x10(%ebp)
  80197a:	e8 52 09 00 00       	call   8022d1 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80197f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801982:	c1 e8 0c             	shr    $0xc,%eax
  801985:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	a8 40                	test   $0x40,%al
  801991:	0f 84 9f 01 00 00    	je     801b36 <fs_test+0x3de>
	file_flush(f);
  801997:	83 ec 0c             	sub    $0xc,%esp
  80199a:	ff 75 f4             	pushl  -0xc(%ebp)
  80199d:	e8 85 f6 ff ff       	call   801027 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8019a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a5:	c1 e8 0c             	shr    $0xc,%eax
  8019a8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	a8 40                	test   $0x40,%al
  8019b4:	0f 85 92 01 00 00    	jne    801b4c <fs_test+0x3f4>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8019ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bd:	c1 e8 0c             	shr    $0xc,%eax
  8019c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019c7:	a8 40                	test   $0x40,%al
  8019c9:	0f 85 93 01 00 00    	jne    801b62 <fs_test+0x40a>
	cprintf("file rewrite is good\n");
  8019cf:	83 ec 0c             	sub    $0xc,%esp
  8019d2:	68 cb 3f 80 00       	push   $0x803fcb
  8019d7:	e8 eb 02 00 00       	call   801cc7 <cprintf>
}
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8019e4:	50                   	push   %eax
  8019e5:	68 3c 3e 80 00       	push   $0x803e3c
  8019ea:	6a 12                	push   $0x12
  8019ec:	68 4f 3e 80 00       	push   $0x803e4f
  8019f1:	e8 ea 01 00 00       	call   801be0 <_panic>
		panic("alloc_block: %e", r);
  8019f6:	50                   	push   %eax
  8019f7:	68 59 3e 80 00       	push   $0x803e59
  8019fc:	6a 17                	push   $0x17
  8019fe:	68 4f 3e 80 00       	push   $0x803e4f
  801a03:	e8 d8 01 00 00       	call   801be0 <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801a08:	68 69 3e 80 00       	push   $0x803e69
  801a0d:	68 fd 3a 80 00       	push   $0x803afd
  801a12:	6a 19                	push   $0x19
  801a14:	68 4f 3e 80 00       	push   $0x803e4f
  801a19:	e8 c2 01 00 00       	call   801be0 <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801a1e:	68 e4 3f 80 00       	push   $0x803fe4
  801a23:	68 fd 3a 80 00       	push   $0x803afd
  801a28:	6a 1b                	push   $0x1b
  801a2a:	68 4f 3e 80 00       	push   $0x803e4f
  801a2f:	e8 ac 01 00 00       	call   801be0 <_panic>
		panic("file_open /not-found: %e", r);
  801a34:	50                   	push   %eax
  801a35:	68 a4 3e 80 00       	push   $0x803ea4
  801a3a:	6a 1f                	push   $0x1f
  801a3c:	68 4f 3e 80 00       	push   $0x803e4f
  801a41:	e8 9a 01 00 00       	call   801be0 <_panic>
		panic("file_open /not-found succeeded!");
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	68 04 40 80 00       	push   $0x804004
  801a4e:	6a 21                	push   $0x21
  801a50:	68 4f 3e 80 00       	push   $0x803e4f
  801a55:	e8 86 01 00 00       	call   801be0 <_panic>
		panic("file_open /newmotd: %e", r);
  801a5a:	50                   	push   %eax
  801a5b:	68 c6 3e 80 00       	push   $0x803ec6
  801a60:	6a 23                	push   $0x23
  801a62:	68 4f 3e 80 00       	push   $0x803e4f
  801a67:	e8 74 01 00 00       	call   801be0 <_panic>
		panic("file_get_block: %e", r);
  801a6c:	50                   	push   %eax
  801a6d:	68 f0 3e 80 00       	push   $0x803ef0
  801a72:	6a 27                	push   $0x27
  801a74:	68 4f 3e 80 00       	push   $0x803e4f
  801a79:	e8 62 01 00 00       	call   801be0 <_panic>
		panic("file_get_block returned wrong data");
  801a7e:	83 ec 04             	sub    $0x4,%esp
  801a81:	68 4c 40 80 00       	push   $0x80404c
  801a86:	6a 29                	push   $0x29
  801a88:	68 4f 3e 80 00       	push   $0x803e4f
  801a8d:	e8 4e 01 00 00       	call   801be0 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a92:	68 1c 3f 80 00       	push   $0x803f1c
  801a97:	68 fd 3a 80 00       	push   $0x803afd
  801a9c:	6a 2d                	push   $0x2d
  801a9e:	68 4f 3e 80 00       	push   $0x803e4f
  801aa3:	e8 38 01 00 00       	call   801be0 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801aa8:	68 1b 3f 80 00       	push   $0x803f1b
  801aad:	68 fd 3a 80 00       	push   $0x803afd
  801ab2:	6a 2f                	push   $0x2f
  801ab4:	68 4f 3e 80 00       	push   $0x803e4f
  801ab9:	e8 22 01 00 00       	call   801be0 <_panic>
		panic("file_set_size: %e", r);
  801abe:	50                   	push   %eax
  801abf:	68 4b 3f 80 00       	push   $0x803f4b
  801ac4:	6a 33                	push   $0x33
  801ac6:	68 4f 3e 80 00       	push   $0x803e4f
  801acb:	e8 10 01 00 00       	call   801be0 <_panic>
	assert(f->f_direct[0] == 0);
  801ad0:	68 5d 3f 80 00       	push   $0x803f5d
  801ad5:	68 fd 3a 80 00       	push   $0x803afd
  801ada:	6a 34                	push   $0x34
  801adc:	68 4f 3e 80 00       	push   $0x803e4f
  801ae1:	e8 fa 00 00 00       	call   801be0 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801ae6:	68 71 3f 80 00       	push   $0x803f71
  801aeb:	68 fd 3a 80 00       	push   $0x803afd
  801af0:	6a 35                	push   $0x35
  801af2:	68 4f 3e 80 00       	push   $0x803e4f
  801af7:	e8 e4 00 00 00       	call   801be0 <_panic>
		panic("file_set_size 2: %e", r);
  801afc:	50                   	push   %eax
  801afd:	68 a2 3f 80 00       	push   $0x803fa2
  801b02:	6a 39                	push   $0x39
  801b04:	68 4f 3e 80 00       	push   $0x803e4f
  801b09:	e8 d2 00 00 00       	call   801be0 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b0e:	68 71 3f 80 00       	push   $0x803f71
  801b13:	68 fd 3a 80 00       	push   $0x803afd
  801b18:	6a 3a                	push   $0x3a
  801b1a:	68 4f 3e 80 00       	push   $0x803e4f
  801b1f:	e8 bc 00 00 00       	call   801be0 <_panic>
		panic("file_get_block 2: %e", r);
  801b24:	50                   	push   %eax
  801b25:	68 b6 3f 80 00       	push   $0x803fb6
  801b2a:	6a 3c                	push   $0x3c
  801b2c:	68 4f 3e 80 00       	push   $0x803e4f
  801b31:	e8 aa 00 00 00       	call   801be0 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801b36:	68 1c 3f 80 00       	push   $0x803f1c
  801b3b:	68 fd 3a 80 00       	push   $0x803afd
  801b40:	6a 3e                	push   $0x3e
  801b42:	68 4f 3e 80 00       	push   $0x803e4f
  801b47:	e8 94 00 00 00       	call   801be0 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b4c:	68 1b 3f 80 00       	push   $0x803f1b
  801b51:	68 fd 3a 80 00       	push   $0x803afd
  801b56:	6a 40                	push   $0x40
  801b58:	68 4f 3e 80 00       	push   $0x803e4f
  801b5d:	e8 7e 00 00 00       	call   801be0 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b62:	68 71 3f 80 00       	push   $0x803f71
  801b67:	68 fd 3a 80 00       	push   $0x803afd
  801b6c:	6a 41                	push   $0x41
  801b6e:	68 4f 3e 80 00       	push   $0x803e4f
  801b73:	e8 68 00 00 00       	call   801be0 <_panic>

00801b78 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801b78:	f3 0f 1e fb          	endbr32 
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	56                   	push   %esi
  801b80:	53                   	push   %ebx
  801b81:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b84:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801b87:	e8 41 0b 00 00       	call   8026cd <sys_getenvid>
  801b8c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b91:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b94:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b99:	a3 0c a0 80 00       	mov    %eax,0x80a00c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801b9e:	85 db                	test   %ebx,%ebx
  801ba0:	7e 07                	jle    801ba9 <libmain+0x31>
		binaryname = argv[0];
  801ba2:	8b 06                	mov    (%esi),%eax
  801ba4:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801ba9:	83 ec 08             	sub    $0x8,%esp
  801bac:	56                   	push   %esi
  801bad:	53                   	push   %ebx
  801bae:	e8 5b fb ff ff       	call   80170e <umain>

	// exit gracefully
	exit();
  801bb3:	e8 0a 00 00 00       	call   801bc2 <exit>
}
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbe:	5b                   	pop    %ebx
  801bbf:	5e                   	pop    %esi
  801bc0:	5d                   	pop    %ebp
  801bc1:	c3                   	ret    

00801bc2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801bc2:	f3 0f 1e fb          	endbr32 
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801bcc:	e8 f5 10 00 00       	call   802cc6 <close_all>
	sys_env_destroy(0);
  801bd1:	83 ec 0c             	sub    $0xc,%esp
  801bd4:	6a 00                	push   $0x0
  801bd6:	e8 ad 0a 00 00       	call   802688 <sys_env_destroy>
}
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801be0:	f3 0f 1e fb          	endbr32 
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	56                   	push   %esi
  801be8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801be9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801bec:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801bf2:	e8 d6 0a 00 00       	call   8026cd <sys_getenvid>
  801bf7:	83 ec 0c             	sub    $0xc,%esp
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	ff 75 08             	pushl  0x8(%ebp)
  801c00:	56                   	push   %esi
  801c01:	50                   	push   %eax
  801c02:	68 7c 40 80 00       	push   $0x80407c
  801c07:	e8 bb 00 00 00       	call   801cc7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c0c:	83 c4 18             	add    $0x18,%esp
  801c0f:	53                   	push   %ebx
  801c10:	ff 75 10             	pushl  0x10(%ebp)
  801c13:	e8 5a 00 00 00       	call   801c72 <vcprintf>
	cprintf("\n");
  801c18:	c7 04 24 8b 3c 80 00 	movl   $0x803c8b,(%esp)
  801c1f:	e8 a3 00 00 00       	call   801cc7 <cprintf>
  801c24:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c27:	cc                   	int3   
  801c28:	eb fd                	jmp    801c27 <_panic+0x47>

00801c2a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801c2a:	f3 0f 1e fb          	endbr32 
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	53                   	push   %ebx
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c38:	8b 13                	mov    (%ebx),%edx
  801c3a:	8d 42 01             	lea    0x1(%edx),%eax
  801c3d:	89 03                	mov    %eax,(%ebx)
  801c3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c42:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801c46:	3d ff 00 00 00       	cmp    $0xff,%eax
  801c4b:	74 09                	je     801c56 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801c4d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801c56:	83 ec 08             	sub    $0x8,%esp
  801c59:	68 ff 00 00 00       	push   $0xff
  801c5e:	8d 43 08             	lea    0x8(%ebx),%eax
  801c61:	50                   	push   %eax
  801c62:	e8 dc 09 00 00       	call   802643 <sys_cputs>
		b->idx = 0;
  801c67:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	eb db                	jmp    801c4d <putch+0x23>

00801c72 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801c72:	f3 0f 1e fb          	endbr32 
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801c7f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c86:	00 00 00 
	b.cnt = 0;
  801c89:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801c90:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801c93:	ff 75 0c             	pushl  0xc(%ebp)
  801c96:	ff 75 08             	pushl  0x8(%ebp)
  801c99:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801c9f:	50                   	push   %eax
  801ca0:	68 2a 1c 80 00       	push   $0x801c2a
  801ca5:	e8 20 01 00 00       	call   801dca <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801caa:	83 c4 08             	add    $0x8,%esp
  801cad:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801cb3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801cb9:	50                   	push   %eax
  801cba:	e8 84 09 00 00       	call   802643 <sys_cputs>

	return b.cnt;
}
  801cbf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801cc7:	f3 0f 1e fb          	endbr32 
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cd1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801cd4:	50                   	push   %eax
  801cd5:	ff 75 08             	pushl  0x8(%ebp)
  801cd8:	e8 95 ff ff ff       	call   801c72 <vcprintf>
	va_end(ap);

	return cnt;
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	57                   	push   %edi
  801ce3:	56                   	push   %esi
  801ce4:	53                   	push   %ebx
  801ce5:	83 ec 1c             	sub    $0x1c,%esp
  801ce8:	89 c7                	mov    %eax,%edi
  801cea:	89 d6                	mov    %edx,%esi
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf2:	89 d1                	mov    %edx,%ecx
  801cf4:	89 c2                	mov    %eax,%edx
  801cf6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801cf9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cff:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801d02:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d05:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801d0c:	39 c2                	cmp    %eax,%edx
  801d0e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801d11:	72 3e                	jb     801d51 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	ff 75 18             	pushl  0x18(%ebp)
  801d19:	83 eb 01             	sub    $0x1,%ebx
  801d1c:	53                   	push   %ebx
  801d1d:	50                   	push   %eax
  801d1e:	83 ec 08             	sub    $0x8,%esp
  801d21:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d24:	ff 75 e0             	pushl  -0x20(%ebp)
  801d27:	ff 75 dc             	pushl  -0x24(%ebp)
  801d2a:	ff 75 d8             	pushl  -0x28(%ebp)
  801d2d:	e8 2e 1b 00 00       	call   803860 <__udivdi3>
  801d32:	83 c4 18             	add    $0x18,%esp
  801d35:	52                   	push   %edx
  801d36:	50                   	push   %eax
  801d37:	89 f2                	mov    %esi,%edx
  801d39:	89 f8                	mov    %edi,%eax
  801d3b:	e8 9f ff ff ff       	call   801cdf <printnum>
  801d40:	83 c4 20             	add    $0x20,%esp
  801d43:	eb 13                	jmp    801d58 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801d45:	83 ec 08             	sub    $0x8,%esp
  801d48:	56                   	push   %esi
  801d49:	ff 75 18             	pushl  0x18(%ebp)
  801d4c:	ff d7                	call   *%edi
  801d4e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801d51:	83 eb 01             	sub    $0x1,%ebx
  801d54:	85 db                	test   %ebx,%ebx
  801d56:	7f ed                	jg     801d45 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801d58:	83 ec 08             	sub    $0x8,%esp
  801d5b:	56                   	push   %esi
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d62:	ff 75 e0             	pushl  -0x20(%ebp)
  801d65:	ff 75 dc             	pushl  -0x24(%ebp)
  801d68:	ff 75 d8             	pushl  -0x28(%ebp)
  801d6b:	e8 00 1c 00 00       	call   803970 <__umoddi3>
  801d70:	83 c4 14             	add    $0x14,%esp
  801d73:	0f be 80 9f 40 80 00 	movsbl 0x80409f(%eax),%eax
  801d7a:	50                   	push   %eax
  801d7b:	ff d7                	call   *%edi
}
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    

00801d88 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801d88:	f3 0f 1e fb          	endbr32 
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801d92:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801d96:	8b 10                	mov    (%eax),%edx
  801d98:	3b 50 04             	cmp    0x4(%eax),%edx
  801d9b:	73 0a                	jae    801da7 <sprintputch+0x1f>
		*b->buf++ = ch;
  801d9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801da0:	89 08                	mov    %ecx,(%eax)
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	88 02                	mov    %al,(%edx)
}
  801da7:	5d                   	pop    %ebp
  801da8:	c3                   	ret    

00801da9 <printfmt>:
{
  801da9:	f3 0f 1e fb          	endbr32 
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801db3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801db6:	50                   	push   %eax
  801db7:	ff 75 10             	pushl  0x10(%ebp)
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	ff 75 08             	pushl  0x8(%ebp)
  801dc0:	e8 05 00 00 00       	call   801dca <vprintfmt>
}
  801dc5:	83 c4 10             	add    $0x10,%esp
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <vprintfmt>:
{
  801dca:	f3 0f 1e fb          	endbr32 
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	57                   	push   %edi
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 3c             	sub    $0x3c,%esp
  801dd7:	8b 75 08             	mov    0x8(%ebp),%esi
  801dda:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ddd:	8b 7d 10             	mov    0x10(%ebp),%edi
  801de0:	e9 8e 03 00 00       	jmp    802173 <vprintfmt+0x3a9>
		padc = ' ';
  801de5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801de9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801df0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801df7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801dfe:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801e03:	8d 47 01             	lea    0x1(%edi),%eax
  801e06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e09:	0f b6 17             	movzbl (%edi),%edx
  801e0c:	8d 42 dd             	lea    -0x23(%edx),%eax
  801e0f:	3c 55                	cmp    $0x55,%al
  801e11:	0f 87 df 03 00 00    	ja     8021f6 <vprintfmt+0x42c>
  801e17:	0f b6 c0             	movzbl %al,%eax
  801e1a:	3e ff 24 85 e0 41 80 	notrack jmp *0x8041e0(,%eax,4)
  801e21:	00 
  801e22:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801e25:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801e29:	eb d8                	jmp    801e03 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801e2b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801e2e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801e32:	eb cf                	jmp    801e03 <vprintfmt+0x39>
  801e34:	0f b6 d2             	movzbl %dl,%edx
  801e37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801e42:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801e45:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801e49:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801e4c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801e4f:	83 f9 09             	cmp    $0x9,%ecx
  801e52:	77 55                	ja     801ea9 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801e54:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801e57:	eb e9                	jmp    801e42 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801e59:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5c:	8b 00                	mov    (%eax),%eax
  801e5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e61:	8b 45 14             	mov    0x14(%ebp),%eax
  801e64:	8d 40 04             	lea    0x4(%eax),%eax
  801e67:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801e6a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801e6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e71:	79 90                	jns    801e03 <vprintfmt+0x39>
				width = precision, precision = -1;
  801e73:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e76:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e79:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801e80:	eb 81                	jmp    801e03 <vprintfmt+0x39>
  801e82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e85:	85 c0                	test   %eax,%eax
  801e87:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8c:	0f 49 d0             	cmovns %eax,%edx
  801e8f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801e92:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801e95:	e9 69 ff ff ff       	jmp    801e03 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801e9a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801e9d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801ea4:	e9 5a ff ff ff       	jmp    801e03 <vprintfmt+0x39>
  801ea9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801eac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801eaf:	eb bc                	jmp    801e6d <vprintfmt+0xa3>
			lflag++;
  801eb1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801eb4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801eb7:	e9 47 ff ff ff       	jmp    801e03 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801ebc:	8b 45 14             	mov    0x14(%ebp),%eax
  801ebf:	8d 78 04             	lea    0x4(%eax),%edi
  801ec2:	83 ec 08             	sub    $0x8,%esp
  801ec5:	53                   	push   %ebx
  801ec6:	ff 30                	pushl  (%eax)
  801ec8:	ff d6                	call   *%esi
			break;
  801eca:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801ecd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801ed0:	e9 9b 02 00 00       	jmp    802170 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed8:	8d 78 04             	lea    0x4(%eax),%edi
  801edb:	8b 00                	mov    (%eax),%eax
  801edd:	99                   	cltd   
  801ede:	31 d0                	xor    %edx,%eax
  801ee0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801ee2:	83 f8 0f             	cmp    $0xf,%eax
  801ee5:	7f 23                	jg     801f0a <vprintfmt+0x140>
  801ee7:	8b 14 85 40 43 80 00 	mov    0x804340(,%eax,4),%edx
  801eee:	85 d2                	test   %edx,%edx
  801ef0:	74 18                	je     801f0a <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  801ef2:	52                   	push   %edx
  801ef3:	68 0f 3b 80 00       	push   $0x803b0f
  801ef8:	53                   	push   %ebx
  801ef9:	56                   	push   %esi
  801efa:	e8 aa fe ff ff       	call   801da9 <printfmt>
  801eff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801f02:	89 7d 14             	mov    %edi,0x14(%ebp)
  801f05:	e9 66 02 00 00       	jmp    802170 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801f0a:	50                   	push   %eax
  801f0b:	68 b7 40 80 00       	push   $0x8040b7
  801f10:	53                   	push   %ebx
  801f11:	56                   	push   %esi
  801f12:	e8 92 fe ff ff       	call   801da9 <printfmt>
  801f17:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801f1a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801f1d:	e9 4e 02 00 00       	jmp    802170 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801f22:	8b 45 14             	mov    0x14(%ebp),%eax
  801f25:	83 c0 04             	add    $0x4,%eax
  801f28:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801f2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801f2e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801f30:	85 d2                	test   %edx,%edx
  801f32:	b8 b0 40 80 00       	mov    $0x8040b0,%eax
  801f37:	0f 45 c2             	cmovne %edx,%eax
  801f3a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801f3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f41:	7e 06                	jle    801f49 <vprintfmt+0x17f>
  801f43:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801f47:	75 0d                	jne    801f56 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f49:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f4c:	89 c7                	mov    %eax,%edi
  801f4e:	03 45 e0             	add    -0x20(%ebp),%eax
  801f51:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f54:	eb 55                	jmp    801fab <vprintfmt+0x1e1>
  801f56:	83 ec 08             	sub    $0x8,%esp
  801f59:	ff 75 d8             	pushl  -0x28(%ebp)
  801f5c:	ff 75 cc             	pushl  -0x34(%ebp)
  801f5f:	e8 46 03 00 00       	call   8022aa <strnlen>
  801f64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f67:	29 c2                	sub    %eax,%edx
  801f69:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801f71:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801f75:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801f78:	85 ff                	test   %edi,%edi
  801f7a:	7e 11                	jle    801f8d <vprintfmt+0x1c3>
					putch(padc, putdat);
  801f7c:	83 ec 08             	sub    $0x8,%esp
  801f7f:	53                   	push   %ebx
  801f80:	ff 75 e0             	pushl  -0x20(%ebp)
  801f83:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801f85:	83 ef 01             	sub    $0x1,%edi
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	eb eb                	jmp    801f78 <vprintfmt+0x1ae>
  801f8d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801f90:	85 d2                	test   %edx,%edx
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
  801f97:	0f 49 c2             	cmovns %edx,%eax
  801f9a:	29 c2                	sub    %eax,%edx
  801f9c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801f9f:	eb a8                	jmp    801f49 <vprintfmt+0x17f>
					putch(ch, putdat);
  801fa1:	83 ec 08             	sub    $0x8,%esp
  801fa4:	53                   	push   %ebx
  801fa5:	52                   	push   %edx
  801fa6:	ff d6                	call   *%esi
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801fae:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801fb0:	83 c7 01             	add    $0x1,%edi
  801fb3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801fb7:	0f be d0             	movsbl %al,%edx
  801fba:	85 d2                	test   %edx,%edx
  801fbc:	74 4b                	je     802009 <vprintfmt+0x23f>
  801fbe:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801fc2:	78 06                	js     801fca <vprintfmt+0x200>
  801fc4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801fc8:	78 1e                	js     801fe8 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801fca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801fce:	74 d1                	je     801fa1 <vprintfmt+0x1d7>
  801fd0:	0f be c0             	movsbl %al,%eax
  801fd3:	83 e8 20             	sub    $0x20,%eax
  801fd6:	83 f8 5e             	cmp    $0x5e,%eax
  801fd9:	76 c6                	jbe    801fa1 <vprintfmt+0x1d7>
					putch('?', putdat);
  801fdb:	83 ec 08             	sub    $0x8,%esp
  801fde:	53                   	push   %ebx
  801fdf:	6a 3f                	push   $0x3f
  801fe1:	ff d6                	call   *%esi
  801fe3:	83 c4 10             	add    $0x10,%esp
  801fe6:	eb c3                	jmp    801fab <vprintfmt+0x1e1>
  801fe8:	89 cf                	mov    %ecx,%edi
  801fea:	eb 0e                	jmp    801ffa <vprintfmt+0x230>
				putch(' ', putdat);
  801fec:	83 ec 08             	sub    $0x8,%esp
  801fef:	53                   	push   %ebx
  801ff0:	6a 20                	push   $0x20
  801ff2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801ff4:	83 ef 01             	sub    $0x1,%edi
  801ff7:	83 c4 10             	add    $0x10,%esp
  801ffa:	85 ff                	test   %edi,%edi
  801ffc:	7f ee                	jg     801fec <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801ffe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802001:	89 45 14             	mov    %eax,0x14(%ebp)
  802004:	e9 67 01 00 00       	jmp    802170 <vprintfmt+0x3a6>
  802009:	89 cf                	mov    %ecx,%edi
  80200b:	eb ed                	jmp    801ffa <vprintfmt+0x230>
	if (lflag >= 2)
  80200d:	83 f9 01             	cmp    $0x1,%ecx
  802010:	7f 1b                	jg     80202d <vprintfmt+0x263>
	else if (lflag)
  802012:	85 c9                	test   %ecx,%ecx
  802014:	74 63                	je     802079 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  802016:	8b 45 14             	mov    0x14(%ebp),%eax
  802019:	8b 00                	mov    (%eax),%eax
  80201b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80201e:	99                   	cltd   
  80201f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802022:	8b 45 14             	mov    0x14(%ebp),%eax
  802025:	8d 40 04             	lea    0x4(%eax),%eax
  802028:	89 45 14             	mov    %eax,0x14(%ebp)
  80202b:	eb 17                	jmp    802044 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80202d:	8b 45 14             	mov    0x14(%ebp),%eax
  802030:	8b 50 04             	mov    0x4(%eax),%edx
  802033:	8b 00                	mov    (%eax),%eax
  802035:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802038:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80203b:	8b 45 14             	mov    0x14(%ebp),%eax
  80203e:	8d 40 08             	lea    0x8(%eax),%eax
  802041:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  802044:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802047:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80204a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80204f:	85 c9                	test   %ecx,%ecx
  802051:	0f 89 ff 00 00 00    	jns    802156 <vprintfmt+0x38c>
				putch('-', putdat);
  802057:	83 ec 08             	sub    $0x8,%esp
  80205a:	53                   	push   %ebx
  80205b:	6a 2d                	push   $0x2d
  80205d:	ff d6                	call   *%esi
				num = -(long long) num;
  80205f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802062:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  802065:	f7 da                	neg    %edx
  802067:	83 d1 00             	adc    $0x0,%ecx
  80206a:	f7 d9                	neg    %ecx
  80206c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80206f:	b8 0a 00 00 00       	mov    $0xa,%eax
  802074:	e9 dd 00 00 00       	jmp    802156 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  802079:	8b 45 14             	mov    0x14(%ebp),%eax
  80207c:	8b 00                	mov    (%eax),%eax
  80207e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802081:	99                   	cltd   
  802082:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802085:	8b 45 14             	mov    0x14(%ebp),%eax
  802088:	8d 40 04             	lea    0x4(%eax),%eax
  80208b:	89 45 14             	mov    %eax,0x14(%ebp)
  80208e:	eb b4                	jmp    802044 <vprintfmt+0x27a>
	if (lflag >= 2)
  802090:	83 f9 01             	cmp    $0x1,%ecx
  802093:	7f 1e                	jg     8020b3 <vprintfmt+0x2e9>
	else if (lflag)
  802095:	85 c9                	test   %ecx,%ecx
  802097:	74 32                	je     8020cb <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  802099:	8b 45 14             	mov    0x14(%ebp),%eax
  80209c:	8b 10                	mov    (%eax),%edx
  80209e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020a3:	8d 40 04             	lea    0x4(%eax),%eax
  8020a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020a9:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8020ae:	e9 a3 00 00 00       	jmp    802156 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8020b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b6:	8b 10                	mov    (%eax),%edx
  8020b8:	8b 48 04             	mov    0x4(%eax),%ecx
  8020bb:	8d 40 08             	lea    0x8(%eax),%eax
  8020be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020c1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8020c6:	e9 8b 00 00 00       	jmp    802156 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8020cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ce:	8b 10                	mov    (%eax),%edx
  8020d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020d5:	8d 40 04             	lea    0x4(%eax),%eax
  8020d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020db:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8020e0:	eb 74                	jmp    802156 <vprintfmt+0x38c>
	if (lflag >= 2)
  8020e2:	83 f9 01             	cmp    $0x1,%ecx
  8020e5:	7f 1b                	jg     802102 <vprintfmt+0x338>
	else if (lflag)
  8020e7:	85 c9                	test   %ecx,%ecx
  8020e9:	74 2c                	je     802117 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8020eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ee:	8b 10                	mov    (%eax),%edx
  8020f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020f5:	8d 40 04             	lea    0x4(%eax),%eax
  8020f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8020fb:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  802100:	eb 54                	jmp    802156 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  802102:	8b 45 14             	mov    0x14(%ebp),%eax
  802105:	8b 10                	mov    (%eax),%edx
  802107:	8b 48 04             	mov    0x4(%eax),%ecx
  80210a:	8d 40 08             	lea    0x8(%eax),%eax
  80210d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802110:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  802115:	eb 3f                	jmp    802156 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  802117:	8b 45 14             	mov    0x14(%ebp),%eax
  80211a:	8b 10                	mov    (%eax),%edx
  80211c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802121:	8d 40 04             	lea    0x4(%eax),%eax
  802124:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802127:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80212c:	eb 28                	jmp    802156 <vprintfmt+0x38c>
			putch('0', putdat);
  80212e:	83 ec 08             	sub    $0x8,%esp
  802131:	53                   	push   %ebx
  802132:	6a 30                	push   $0x30
  802134:	ff d6                	call   *%esi
			putch('x', putdat);
  802136:	83 c4 08             	add    $0x8,%esp
  802139:	53                   	push   %ebx
  80213a:	6a 78                	push   $0x78
  80213c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80213e:	8b 45 14             	mov    0x14(%ebp),%eax
  802141:	8b 10                	mov    (%eax),%edx
  802143:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  802148:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80214b:	8d 40 04             	lea    0x4(%eax),%eax
  80214e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802151:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  802156:	83 ec 0c             	sub    $0xc,%esp
  802159:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80215d:	57                   	push   %edi
  80215e:	ff 75 e0             	pushl  -0x20(%ebp)
  802161:	50                   	push   %eax
  802162:	51                   	push   %ecx
  802163:	52                   	push   %edx
  802164:	89 da                	mov    %ebx,%edx
  802166:	89 f0                	mov    %esi,%eax
  802168:	e8 72 fb ff ff       	call   801cdf <printnum>
			break;
  80216d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  802170:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802173:	83 c7 01             	add    $0x1,%edi
  802176:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80217a:	83 f8 25             	cmp    $0x25,%eax
  80217d:	0f 84 62 fc ff ff    	je     801de5 <vprintfmt+0x1b>
			if (ch == '\0')
  802183:	85 c0                	test   %eax,%eax
  802185:	0f 84 8b 00 00 00    	je     802216 <vprintfmt+0x44c>
			putch(ch, putdat);
  80218b:	83 ec 08             	sub    $0x8,%esp
  80218e:	53                   	push   %ebx
  80218f:	50                   	push   %eax
  802190:	ff d6                	call   *%esi
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	eb dc                	jmp    802173 <vprintfmt+0x3a9>
	if (lflag >= 2)
  802197:	83 f9 01             	cmp    $0x1,%ecx
  80219a:	7f 1b                	jg     8021b7 <vprintfmt+0x3ed>
	else if (lflag)
  80219c:	85 c9                	test   %ecx,%ecx
  80219e:	74 2c                	je     8021cc <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8021a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a3:	8b 10                	mov    (%eax),%edx
  8021a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021aa:	8d 40 04             	lea    0x4(%eax),%eax
  8021ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021b0:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8021b5:	eb 9f                	jmp    802156 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8021b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ba:	8b 10                	mov    (%eax),%edx
  8021bc:	8b 48 04             	mov    0x4(%eax),%ecx
  8021bf:	8d 40 08             	lea    0x8(%eax),%eax
  8021c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021c5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8021ca:	eb 8a                	jmp    802156 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8021cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8021cf:	8b 10                	mov    (%eax),%edx
  8021d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021d6:	8d 40 04             	lea    0x4(%eax),%eax
  8021d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021dc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8021e1:	e9 70 ff ff ff       	jmp    802156 <vprintfmt+0x38c>
			putch(ch, putdat);
  8021e6:	83 ec 08             	sub    $0x8,%esp
  8021e9:	53                   	push   %ebx
  8021ea:	6a 25                	push   $0x25
  8021ec:	ff d6                	call   *%esi
			break;
  8021ee:	83 c4 10             	add    $0x10,%esp
  8021f1:	e9 7a ff ff ff       	jmp    802170 <vprintfmt+0x3a6>
			putch('%', putdat);
  8021f6:	83 ec 08             	sub    $0x8,%esp
  8021f9:	53                   	push   %ebx
  8021fa:	6a 25                	push   $0x25
  8021fc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	89 f8                	mov    %edi,%eax
  802203:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  802207:	74 05                	je     80220e <vprintfmt+0x444>
  802209:	83 e8 01             	sub    $0x1,%eax
  80220c:	eb f5                	jmp    802203 <vprintfmt+0x439>
  80220e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802211:	e9 5a ff ff ff       	jmp    802170 <vprintfmt+0x3a6>
}
  802216:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802219:	5b                   	pop    %ebx
  80221a:	5e                   	pop    %esi
  80221b:	5f                   	pop    %edi
  80221c:	5d                   	pop    %ebp
  80221d:	c3                   	ret    

0080221e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80221e:	f3 0f 1e fb          	endbr32 
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	83 ec 18             	sub    $0x18,%esp
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80222e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802231:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802235:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802238:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80223f:	85 c0                	test   %eax,%eax
  802241:	74 26                	je     802269 <vsnprintf+0x4b>
  802243:	85 d2                	test   %edx,%edx
  802245:	7e 22                	jle    802269 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802247:	ff 75 14             	pushl  0x14(%ebp)
  80224a:	ff 75 10             	pushl  0x10(%ebp)
  80224d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802250:	50                   	push   %eax
  802251:	68 88 1d 80 00       	push   $0x801d88
  802256:	e8 6f fb ff ff       	call   801dca <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80225b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	83 c4 10             	add    $0x10,%esp
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    
		return -E_INVAL;
  802269:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80226e:	eb f7                	jmp    802267 <vsnprintf+0x49>

00802270 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802270:	f3 0f 1e fb          	endbr32 
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80227a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80227d:	50                   	push   %eax
  80227e:	ff 75 10             	pushl  0x10(%ebp)
  802281:	ff 75 0c             	pushl  0xc(%ebp)
  802284:	ff 75 08             	pushl  0x8(%ebp)
  802287:	e8 92 ff ff ff       	call   80221e <vsnprintf>
	va_end(ap);

	return rc;
}
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80228e:	f3 0f 1e fb          	endbr32 
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802298:	b8 00 00 00 00       	mov    $0x0,%eax
  80229d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8022a1:	74 05                	je     8022a8 <strlen+0x1a>
		n++;
  8022a3:	83 c0 01             	add    $0x1,%eax
  8022a6:	eb f5                	jmp    80229d <strlen+0xf>
	return n;
}
  8022a8:	5d                   	pop    %ebp
  8022a9:	c3                   	ret    

008022aa <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8022aa:	f3 0f 1e fb          	endbr32 
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022b4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bc:	39 d0                	cmp    %edx,%eax
  8022be:	74 0d                	je     8022cd <strnlen+0x23>
  8022c0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8022c4:	74 05                	je     8022cb <strnlen+0x21>
		n++;
  8022c6:	83 c0 01             	add    $0x1,%eax
  8022c9:	eb f1                	jmp    8022bc <strnlen+0x12>
  8022cb:	89 c2                	mov    %eax,%edx
	return n;
}
  8022cd:	89 d0                	mov    %edx,%eax
  8022cf:	5d                   	pop    %ebp
  8022d0:	c3                   	ret    

008022d1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022d1:	f3 0f 1e fb          	endbr32 
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
  8022d8:	53                   	push   %ebx
  8022d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8022df:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8022e8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8022eb:	83 c0 01             	add    $0x1,%eax
  8022ee:	84 d2                	test   %dl,%dl
  8022f0:	75 f2                	jne    8022e4 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8022f2:	89 c8                	mov    %ecx,%eax
  8022f4:	5b                   	pop    %ebx
  8022f5:	5d                   	pop    %ebp
  8022f6:	c3                   	ret    

008022f7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8022f7:	f3 0f 1e fb          	endbr32 
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	53                   	push   %ebx
  8022ff:	83 ec 10             	sub    $0x10,%esp
  802302:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802305:	53                   	push   %ebx
  802306:	e8 83 ff ff ff       	call   80228e <strlen>
  80230b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80230e:	ff 75 0c             	pushl  0xc(%ebp)
  802311:	01 d8                	add    %ebx,%eax
  802313:	50                   	push   %eax
  802314:	e8 b8 ff ff ff       	call   8022d1 <strcpy>
	return dst;
}
  802319:	89 d8                	mov    %ebx,%eax
  80231b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802320:	f3 0f 1e fb          	endbr32 
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	56                   	push   %esi
  802328:	53                   	push   %ebx
  802329:	8b 75 08             	mov    0x8(%ebp),%esi
  80232c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232f:	89 f3                	mov    %esi,%ebx
  802331:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802334:	89 f0                	mov    %esi,%eax
  802336:	39 d8                	cmp    %ebx,%eax
  802338:	74 11                	je     80234b <strncpy+0x2b>
		*dst++ = *src;
  80233a:	83 c0 01             	add    $0x1,%eax
  80233d:	0f b6 0a             	movzbl (%edx),%ecx
  802340:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  802343:	80 f9 01             	cmp    $0x1,%cl
  802346:	83 da ff             	sbb    $0xffffffff,%edx
  802349:	eb eb                	jmp    802336 <strncpy+0x16>
	}
	return ret;
}
  80234b:	89 f0                	mov    %esi,%eax
  80234d:	5b                   	pop    %ebx
  80234e:	5e                   	pop    %esi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    

00802351 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802351:	f3 0f 1e fb          	endbr32 
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
  802358:	56                   	push   %esi
  802359:	53                   	push   %ebx
  80235a:	8b 75 08             	mov    0x8(%ebp),%esi
  80235d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802360:	8b 55 10             	mov    0x10(%ebp),%edx
  802363:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802365:	85 d2                	test   %edx,%edx
  802367:	74 21                	je     80238a <strlcpy+0x39>
  802369:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80236d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80236f:	39 c2                	cmp    %eax,%edx
  802371:	74 14                	je     802387 <strlcpy+0x36>
  802373:	0f b6 19             	movzbl (%ecx),%ebx
  802376:	84 db                	test   %bl,%bl
  802378:	74 0b                	je     802385 <strlcpy+0x34>
			*dst++ = *src++;
  80237a:	83 c1 01             	add    $0x1,%ecx
  80237d:	83 c2 01             	add    $0x1,%edx
  802380:	88 5a ff             	mov    %bl,-0x1(%edx)
  802383:	eb ea                	jmp    80236f <strlcpy+0x1e>
  802385:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  802387:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80238a:	29 f0                	sub    %esi,%eax
}
  80238c:	5b                   	pop    %ebx
  80238d:	5e                   	pop    %esi
  80238e:	5d                   	pop    %ebp
  80238f:	c3                   	ret    

00802390 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802390:	f3 0f 1e fb          	endbr32 
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80239a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80239d:	0f b6 01             	movzbl (%ecx),%eax
  8023a0:	84 c0                	test   %al,%al
  8023a2:	74 0c                	je     8023b0 <strcmp+0x20>
  8023a4:	3a 02                	cmp    (%edx),%al
  8023a6:	75 08                	jne    8023b0 <strcmp+0x20>
		p++, q++;
  8023a8:	83 c1 01             	add    $0x1,%ecx
  8023ab:	83 c2 01             	add    $0x1,%edx
  8023ae:	eb ed                	jmp    80239d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8023b0:	0f b6 c0             	movzbl %al,%eax
  8023b3:	0f b6 12             	movzbl (%edx),%edx
  8023b6:	29 d0                	sub    %edx,%eax
}
  8023b8:	5d                   	pop    %ebp
  8023b9:	c3                   	ret    

008023ba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8023ba:	f3 0f 1e fb          	endbr32 
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	53                   	push   %ebx
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c8:	89 c3                	mov    %eax,%ebx
  8023ca:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8023cd:	eb 06                	jmp    8023d5 <strncmp+0x1b>
		n--, p++, q++;
  8023cf:	83 c0 01             	add    $0x1,%eax
  8023d2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8023d5:	39 d8                	cmp    %ebx,%eax
  8023d7:	74 16                	je     8023ef <strncmp+0x35>
  8023d9:	0f b6 08             	movzbl (%eax),%ecx
  8023dc:	84 c9                	test   %cl,%cl
  8023de:	74 04                	je     8023e4 <strncmp+0x2a>
  8023e0:	3a 0a                	cmp    (%edx),%cl
  8023e2:	74 eb                	je     8023cf <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023e4:	0f b6 00             	movzbl (%eax),%eax
  8023e7:	0f b6 12             	movzbl (%edx),%edx
  8023ea:	29 d0                	sub    %edx,%eax
}
  8023ec:	5b                   	pop    %ebx
  8023ed:	5d                   	pop    %ebp
  8023ee:	c3                   	ret    
		return 0;
  8023ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f4:	eb f6                	jmp    8023ec <strncmp+0x32>

008023f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8023f6:	f3 0f 1e fb          	endbr32 
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802404:	0f b6 10             	movzbl (%eax),%edx
  802407:	84 d2                	test   %dl,%dl
  802409:	74 09                	je     802414 <strchr+0x1e>
		if (*s == c)
  80240b:	38 ca                	cmp    %cl,%dl
  80240d:	74 0a                	je     802419 <strchr+0x23>
	for (; *s; s++)
  80240f:	83 c0 01             	add    $0x1,%eax
  802412:	eb f0                	jmp    802404 <strchr+0xe>
			return (char *) s;
	return 0;
  802414:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802419:	5d                   	pop    %ebp
  80241a:	c3                   	ret    

0080241b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80241b:	f3 0f 1e fb          	endbr32 
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802429:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80242c:	38 ca                	cmp    %cl,%dl
  80242e:	74 09                	je     802439 <strfind+0x1e>
  802430:	84 d2                	test   %dl,%dl
  802432:	74 05                	je     802439 <strfind+0x1e>
	for (; *s; s++)
  802434:	83 c0 01             	add    $0x1,%eax
  802437:	eb f0                	jmp    802429 <strfind+0xe>
			break;
	return (char *) s;
}
  802439:	5d                   	pop    %ebp
  80243a:	c3                   	ret    

0080243b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80243b:	f3 0f 1e fb          	endbr32 
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
  802442:	57                   	push   %edi
  802443:	56                   	push   %esi
  802444:	53                   	push   %ebx
  802445:	8b 7d 08             	mov    0x8(%ebp),%edi
  802448:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80244b:	85 c9                	test   %ecx,%ecx
  80244d:	74 31                	je     802480 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80244f:	89 f8                	mov    %edi,%eax
  802451:	09 c8                	or     %ecx,%eax
  802453:	a8 03                	test   $0x3,%al
  802455:	75 23                	jne    80247a <memset+0x3f>
		c &= 0xFF;
  802457:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80245b:	89 d3                	mov    %edx,%ebx
  80245d:	c1 e3 08             	shl    $0x8,%ebx
  802460:	89 d0                	mov    %edx,%eax
  802462:	c1 e0 18             	shl    $0x18,%eax
  802465:	89 d6                	mov    %edx,%esi
  802467:	c1 e6 10             	shl    $0x10,%esi
  80246a:	09 f0                	or     %esi,%eax
  80246c:	09 c2                	or     %eax,%edx
  80246e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802470:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  802473:	89 d0                	mov    %edx,%eax
  802475:	fc                   	cld    
  802476:	f3 ab                	rep stos %eax,%es:(%edi)
  802478:	eb 06                	jmp    802480 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80247a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247d:	fc                   	cld    
  80247e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802480:	89 f8                	mov    %edi,%eax
  802482:	5b                   	pop    %ebx
  802483:	5e                   	pop    %esi
  802484:	5f                   	pop    %edi
  802485:	5d                   	pop    %ebp
  802486:	c3                   	ret    

00802487 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802487:	f3 0f 1e fb          	endbr32 
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
  80248e:	57                   	push   %edi
  80248f:	56                   	push   %esi
  802490:	8b 45 08             	mov    0x8(%ebp),%eax
  802493:	8b 75 0c             	mov    0xc(%ebp),%esi
  802496:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802499:	39 c6                	cmp    %eax,%esi
  80249b:	73 32                	jae    8024cf <memmove+0x48>
  80249d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8024a0:	39 c2                	cmp    %eax,%edx
  8024a2:	76 2b                	jbe    8024cf <memmove+0x48>
		s += n;
		d += n;
  8024a4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8024a7:	89 fe                	mov    %edi,%esi
  8024a9:	09 ce                	or     %ecx,%esi
  8024ab:	09 d6                	or     %edx,%esi
  8024ad:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8024b3:	75 0e                	jne    8024c3 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8024b5:	83 ef 04             	sub    $0x4,%edi
  8024b8:	8d 72 fc             	lea    -0x4(%edx),%esi
  8024bb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8024be:	fd                   	std    
  8024bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8024c1:	eb 09                	jmp    8024cc <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8024c3:	83 ef 01             	sub    $0x1,%edi
  8024c6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8024c9:	fd                   	std    
  8024ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8024cc:	fc                   	cld    
  8024cd:	eb 1a                	jmp    8024e9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8024cf:	89 c2                	mov    %eax,%edx
  8024d1:	09 ca                	or     %ecx,%edx
  8024d3:	09 f2                	or     %esi,%edx
  8024d5:	f6 c2 03             	test   $0x3,%dl
  8024d8:	75 0a                	jne    8024e4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8024da:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8024dd:	89 c7                	mov    %eax,%edi
  8024df:	fc                   	cld    
  8024e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8024e2:	eb 05                	jmp    8024e9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8024e4:	89 c7                	mov    %eax,%edi
  8024e6:	fc                   	cld    
  8024e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8024e9:	5e                   	pop    %esi
  8024ea:	5f                   	pop    %edi
  8024eb:	5d                   	pop    %ebp
  8024ec:	c3                   	ret    

008024ed <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8024ed:	f3 0f 1e fb          	endbr32 
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8024f7:	ff 75 10             	pushl  0x10(%ebp)
  8024fa:	ff 75 0c             	pushl  0xc(%ebp)
  8024fd:	ff 75 08             	pushl  0x8(%ebp)
  802500:	e8 82 ff ff ff       	call   802487 <memmove>
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802507:	f3 0f 1e fb          	endbr32 
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
  80250e:	56                   	push   %esi
  80250f:	53                   	push   %ebx
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	8b 55 0c             	mov    0xc(%ebp),%edx
  802516:	89 c6                	mov    %eax,%esi
  802518:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80251b:	39 f0                	cmp    %esi,%eax
  80251d:	74 1c                	je     80253b <memcmp+0x34>
		if (*s1 != *s2)
  80251f:	0f b6 08             	movzbl (%eax),%ecx
  802522:	0f b6 1a             	movzbl (%edx),%ebx
  802525:	38 d9                	cmp    %bl,%cl
  802527:	75 08                	jne    802531 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  802529:	83 c0 01             	add    $0x1,%eax
  80252c:	83 c2 01             	add    $0x1,%edx
  80252f:	eb ea                	jmp    80251b <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  802531:	0f b6 c1             	movzbl %cl,%eax
  802534:	0f b6 db             	movzbl %bl,%ebx
  802537:	29 d8                	sub    %ebx,%eax
  802539:	eb 05                	jmp    802540 <memcmp+0x39>
	}

	return 0;
  80253b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802540:	5b                   	pop    %ebx
  802541:	5e                   	pop    %esi
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    

00802544 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802544:	f3 0f 1e fb          	endbr32 
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  802551:	89 c2                	mov    %eax,%edx
  802553:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802556:	39 d0                	cmp    %edx,%eax
  802558:	73 09                	jae    802563 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80255a:	38 08                	cmp    %cl,(%eax)
  80255c:	74 05                	je     802563 <memfind+0x1f>
	for (; s < ends; s++)
  80255e:	83 c0 01             	add    $0x1,%eax
  802561:	eb f3                	jmp    802556 <memfind+0x12>
			break;
	return (void *) s;
}
  802563:	5d                   	pop    %ebp
  802564:	c3                   	ret    

00802565 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802565:	f3 0f 1e fb          	endbr32 
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	57                   	push   %edi
  80256d:	56                   	push   %esi
  80256e:	53                   	push   %ebx
  80256f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802572:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802575:	eb 03                	jmp    80257a <strtol+0x15>
		s++;
  802577:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80257a:	0f b6 01             	movzbl (%ecx),%eax
  80257d:	3c 20                	cmp    $0x20,%al
  80257f:	74 f6                	je     802577 <strtol+0x12>
  802581:	3c 09                	cmp    $0x9,%al
  802583:	74 f2                	je     802577 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  802585:	3c 2b                	cmp    $0x2b,%al
  802587:	74 2a                	je     8025b3 <strtol+0x4e>
	int neg = 0;
  802589:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80258e:	3c 2d                	cmp    $0x2d,%al
  802590:	74 2b                	je     8025bd <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802592:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  802598:	75 0f                	jne    8025a9 <strtol+0x44>
  80259a:	80 39 30             	cmpb   $0x30,(%ecx)
  80259d:	74 28                	je     8025c7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80259f:	85 db                	test   %ebx,%ebx
  8025a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8025a6:	0f 44 d8             	cmove  %eax,%ebx
  8025a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8025b1:	eb 46                	jmp    8025f9 <strtol+0x94>
		s++;
  8025b3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8025b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8025bb:	eb d5                	jmp    802592 <strtol+0x2d>
		s++, neg = 1;
  8025bd:	83 c1 01             	add    $0x1,%ecx
  8025c0:	bf 01 00 00 00       	mov    $0x1,%edi
  8025c5:	eb cb                	jmp    802592 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025c7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8025cb:	74 0e                	je     8025db <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8025cd:	85 db                	test   %ebx,%ebx
  8025cf:	75 d8                	jne    8025a9 <strtol+0x44>
		s++, base = 8;
  8025d1:	83 c1 01             	add    $0x1,%ecx
  8025d4:	bb 08 00 00 00       	mov    $0x8,%ebx
  8025d9:	eb ce                	jmp    8025a9 <strtol+0x44>
		s += 2, base = 16;
  8025db:	83 c1 02             	add    $0x2,%ecx
  8025de:	bb 10 00 00 00       	mov    $0x10,%ebx
  8025e3:	eb c4                	jmp    8025a9 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8025e5:	0f be d2             	movsbl %dl,%edx
  8025e8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8025eb:	3b 55 10             	cmp    0x10(%ebp),%edx
  8025ee:	7d 3a                	jge    80262a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8025f0:	83 c1 01             	add    $0x1,%ecx
  8025f3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8025f7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8025f9:	0f b6 11             	movzbl (%ecx),%edx
  8025fc:	8d 72 d0             	lea    -0x30(%edx),%esi
  8025ff:	89 f3                	mov    %esi,%ebx
  802601:	80 fb 09             	cmp    $0x9,%bl
  802604:	76 df                	jbe    8025e5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  802606:	8d 72 9f             	lea    -0x61(%edx),%esi
  802609:	89 f3                	mov    %esi,%ebx
  80260b:	80 fb 19             	cmp    $0x19,%bl
  80260e:	77 08                	ja     802618 <strtol+0xb3>
			dig = *s - 'a' + 10;
  802610:	0f be d2             	movsbl %dl,%edx
  802613:	83 ea 57             	sub    $0x57,%edx
  802616:	eb d3                	jmp    8025eb <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  802618:	8d 72 bf             	lea    -0x41(%edx),%esi
  80261b:	89 f3                	mov    %esi,%ebx
  80261d:	80 fb 19             	cmp    $0x19,%bl
  802620:	77 08                	ja     80262a <strtol+0xc5>
			dig = *s - 'A' + 10;
  802622:	0f be d2             	movsbl %dl,%edx
  802625:	83 ea 37             	sub    $0x37,%edx
  802628:	eb c1                	jmp    8025eb <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80262a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80262e:	74 05                	je     802635 <strtol+0xd0>
		*endptr = (char *) s;
  802630:	8b 75 0c             	mov    0xc(%ebp),%esi
  802633:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802635:	89 c2                	mov    %eax,%edx
  802637:	f7 da                	neg    %edx
  802639:	85 ff                	test   %edi,%edi
  80263b:	0f 45 c2             	cmovne %edx,%eax
}
  80263e:	5b                   	pop    %ebx
  80263f:	5e                   	pop    %esi
  802640:	5f                   	pop    %edi
  802641:	5d                   	pop    %ebp
  802642:	c3                   	ret    

00802643 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802643:	f3 0f 1e fb          	endbr32 
  802647:	55                   	push   %ebp
  802648:	89 e5                	mov    %esp,%ebp
  80264a:	57                   	push   %edi
  80264b:	56                   	push   %esi
  80264c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80264d:	b8 00 00 00 00       	mov    $0x0,%eax
  802652:	8b 55 08             	mov    0x8(%ebp),%edx
  802655:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802658:	89 c3                	mov    %eax,%ebx
  80265a:	89 c7                	mov    %eax,%edi
  80265c:	89 c6                	mov    %eax,%esi
  80265e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  802660:	5b                   	pop    %ebx
  802661:	5e                   	pop    %esi
  802662:	5f                   	pop    %edi
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    

00802665 <sys_cgetc>:

int
sys_cgetc(void)
{
  802665:	f3 0f 1e fb          	endbr32 
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	57                   	push   %edi
  80266d:	56                   	push   %esi
  80266e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80266f:	ba 00 00 00 00       	mov    $0x0,%edx
  802674:	b8 01 00 00 00       	mov    $0x1,%eax
  802679:	89 d1                	mov    %edx,%ecx
  80267b:	89 d3                	mov    %edx,%ebx
  80267d:	89 d7                	mov    %edx,%edi
  80267f:	89 d6                	mov    %edx,%esi
  802681:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  802683:	5b                   	pop    %ebx
  802684:	5e                   	pop    %esi
  802685:	5f                   	pop    %edi
  802686:	5d                   	pop    %ebp
  802687:	c3                   	ret    

00802688 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802688:	f3 0f 1e fb          	endbr32 
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
  80268f:	57                   	push   %edi
  802690:	56                   	push   %esi
  802691:	53                   	push   %ebx
  802692:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802695:	b9 00 00 00 00       	mov    $0x0,%ecx
  80269a:	8b 55 08             	mov    0x8(%ebp),%edx
  80269d:	b8 03 00 00 00       	mov    $0x3,%eax
  8026a2:	89 cb                	mov    %ecx,%ebx
  8026a4:	89 cf                	mov    %ecx,%edi
  8026a6:	89 ce                	mov    %ecx,%esi
  8026a8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	7f 08                	jg     8026b6 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8026ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026b1:	5b                   	pop    %ebx
  8026b2:	5e                   	pop    %esi
  8026b3:	5f                   	pop    %edi
  8026b4:	5d                   	pop    %ebp
  8026b5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026b6:	83 ec 0c             	sub    $0xc,%esp
  8026b9:	50                   	push   %eax
  8026ba:	6a 03                	push   $0x3
  8026bc:	68 9f 43 80 00       	push   $0x80439f
  8026c1:	6a 23                	push   $0x23
  8026c3:	68 bc 43 80 00       	push   $0x8043bc
  8026c8:	e8 13 f5 ff ff       	call   801be0 <_panic>

008026cd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8026cd:	f3 0f 1e fb          	endbr32 
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
  8026d4:	57                   	push   %edi
  8026d5:	56                   	push   %esi
  8026d6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8026d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026dc:	b8 02 00 00 00       	mov    $0x2,%eax
  8026e1:	89 d1                	mov    %edx,%ecx
  8026e3:	89 d3                	mov    %edx,%ebx
  8026e5:	89 d7                	mov    %edx,%edi
  8026e7:	89 d6                	mov    %edx,%esi
  8026e9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8026eb:	5b                   	pop    %ebx
  8026ec:	5e                   	pop    %esi
  8026ed:	5f                   	pop    %edi
  8026ee:	5d                   	pop    %ebp
  8026ef:	c3                   	ret    

008026f0 <sys_yield>:

void
sys_yield(void)
{
  8026f0:	f3 0f 1e fb          	endbr32 
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
  8026f7:	57                   	push   %edi
  8026f8:	56                   	push   %esi
  8026f9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8026fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ff:	b8 0b 00 00 00       	mov    $0xb,%eax
  802704:	89 d1                	mov    %edx,%ecx
  802706:	89 d3                	mov    %edx,%ebx
  802708:	89 d7                	mov    %edx,%edi
  80270a:	89 d6                	mov    %edx,%esi
  80270c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80270e:	5b                   	pop    %ebx
  80270f:	5e                   	pop    %esi
  802710:	5f                   	pop    %edi
  802711:	5d                   	pop    %ebp
  802712:	c3                   	ret    

00802713 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802713:	f3 0f 1e fb          	endbr32 
  802717:	55                   	push   %ebp
  802718:	89 e5                	mov    %esp,%ebp
  80271a:	57                   	push   %edi
  80271b:	56                   	push   %esi
  80271c:	53                   	push   %ebx
  80271d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802720:	be 00 00 00 00       	mov    $0x0,%esi
  802725:	8b 55 08             	mov    0x8(%ebp),%edx
  802728:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80272b:	b8 04 00 00 00       	mov    $0x4,%eax
  802730:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802733:	89 f7                	mov    %esi,%edi
  802735:	cd 30                	int    $0x30
	if(check && ret > 0)
  802737:	85 c0                	test   %eax,%eax
  802739:	7f 08                	jg     802743 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80273b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80273e:	5b                   	pop    %ebx
  80273f:	5e                   	pop    %esi
  802740:	5f                   	pop    %edi
  802741:	5d                   	pop    %ebp
  802742:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802743:	83 ec 0c             	sub    $0xc,%esp
  802746:	50                   	push   %eax
  802747:	6a 04                	push   $0x4
  802749:	68 9f 43 80 00       	push   $0x80439f
  80274e:	6a 23                	push   $0x23
  802750:	68 bc 43 80 00       	push   $0x8043bc
  802755:	e8 86 f4 ff ff       	call   801be0 <_panic>

0080275a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80275a:	f3 0f 1e fb          	endbr32 
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
  802761:	57                   	push   %edi
  802762:	56                   	push   %esi
  802763:	53                   	push   %ebx
  802764:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802767:	8b 55 08             	mov    0x8(%ebp),%edx
  80276a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80276d:	b8 05 00 00 00       	mov    $0x5,%eax
  802772:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802775:	8b 7d 14             	mov    0x14(%ebp),%edi
  802778:	8b 75 18             	mov    0x18(%ebp),%esi
  80277b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80277d:	85 c0                	test   %eax,%eax
  80277f:	7f 08                	jg     802789 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802781:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802784:	5b                   	pop    %ebx
  802785:	5e                   	pop    %esi
  802786:	5f                   	pop    %edi
  802787:	5d                   	pop    %ebp
  802788:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802789:	83 ec 0c             	sub    $0xc,%esp
  80278c:	50                   	push   %eax
  80278d:	6a 05                	push   $0x5
  80278f:	68 9f 43 80 00       	push   $0x80439f
  802794:	6a 23                	push   $0x23
  802796:	68 bc 43 80 00       	push   $0x8043bc
  80279b:	e8 40 f4 ff ff       	call   801be0 <_panic>

008027a0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8027a0:	f3 0f 1e fb          	endbr32 
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
  8027a7:	57                   	push   %edi
  8027a8:	56                   	push   %esi
  8027a9:	53                   	push   %ebx
  8027aa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027b8:	b8 06 00 00 00       	mov    $0x6,%eax
  8027bd:	89 df                	mov    %ebx,%edi
  8027bf:	89 de                	mov    %ebx,%esi
  8027c1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	7f 08                	jg     8027cf <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8027c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027ca:	5b                   	pop    %ebx
  8027cb:	5e                   	pop    %esi
  8027cc:	5f                   	pop    %edi
  8027cd:	5d                   	pop    %ebp
  8027ce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027cf:	83 ec 0c             	sub    $0xc,%esp
  8027d2:	50                   	push   %eax
  8027d3:	6a 06                	push   $0x6
  8027d5:	68 9f 43 80 00       	push   $0x80439f
  8027da:	6a 23                	push   $0x23
  8027dc:	68 bc 43 80 00       	push   $0x8043bc
  8027e1:	e8 fa f3 ff ff       	call   801be0 <_panic>

008027e6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8027e6:	f3 0f 1e fb          	endbr32 
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	57                   	push   %edi
  8027ee:	56                   	push   %esi
  8027ef:	53                   	push   %ebx
  8027f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027fe:	b8 08 00 00 00       	mov    $0x8,%eax
  802803:	89 df                	mov    %ebx,%edi
  802805:	89 de                	mov    %ebx,%esi
  802807:	cd 30                	int    $0x30
	if(check && ret > 0)
  802809:	85 c0                	test   %eax,%eax
  80280b:	7f 08                	jg     802815 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80280d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802810:	5b                   	pop    %ebx
  802811:	5e                   	pop    %esi
  802812:	5f                   	pop    %edi
  802813:	5d                   	pop    %ebp
  802814:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802815:	83 ec 0c             	sub    $0xc,%esp
  802818:	50                   	push   %eax
  802819:	6a 08                	push   $0x8
  80281b:	68 9f 43 80 00       	push   $0x80439f
  802820:	6a 23                	push   $0x23
  802822:	68 bc 43 80 00       	push   $0x8043bc
  802827:	e8 b4 f3 ff ff       	call   801be0 <_panic>

0080282c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80282c:	f3 0f 1e fb          	endbr32 
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
  802833:	57                   	push   %edi
  802834:	56                   	push   %esi
  802835:	53                   	push   %ebx
  802836:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802839:	bb 00 00 00 00       	mov    $0x0,%ebx
  80283e:	8b 55 08             	mov    0x8(%ebp),%edx
  802841:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802844:	b8 09 00 00 00       	mov    $0x9,%eax
  802849:	89 df                	mov    %ebx,%edi
  80284b:	89 de                	mov    %ebx,%esi
  80284d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80284f:	85 c0                	test   %eax,%eax
  802851:	7f 08                	jg     80285b <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802853:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802856:	5b                   	pop    %ebx
  802857:	5e                   	pop    %esi
  802858:	5f                   	pop    %edi
  802859:	5d                   	pop    %ebp
  80285a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80285b:	83 ec 0c             	sub    $0xc,%esp
  80285e:	50                   	push   %eax
  80285f:	6a 09                	push   $0x9
  802861:	68 9f 43 80 00       	push   $0x80439f
  802866:	6a 23                	push   $0x23
  802868:	68 bc 43 80 00       	push   $0x8043bc
  80286d:	e8 6e f3 ff ff       	call   801be0 <_panic>

00802872 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802872:	f3 0f 1e fb          	endbr32 
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
  802879:	57                   	push   %edi
  80287a:	56                   	push   %esi
  80287b:	53                   	push   %ebx
  80287c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80287f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802884:	8b 55 08             	mov    0x8(%ebp),%edx
  802887:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80288a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80288f:	89 df                	mov    %ebx,%edi
  802891:	89 de                	mov    %ebx,%esi
  802893:	cd 30                	int    $0x30
	if(check && ret > 0)
  802895:	85 c0                	test   %eax,%eax
  802897:	7f 08                	jg     8028a1 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802899:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80289c:	5b                   	pop    %ebx
  80289d:	5e                   	pop    %esi
  80289e:	5f                   	pop    %edi
  80289f:	5d                   	pop    %ebp
  8028a0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8028a1:	83 ec 0c             	sub    $0xc,%esp
  8028a4:	50                   	push   %eax
  8028a5:	6a 0a                	push   $0xa
  8028a7:	68 9f 43 80 00       	push   $0x80439f
  8028ac:	6a 23                	push   $0x23
  8028ae:	68 bc 43 80 00       	push   $0x8043bc
  8028b3:	e8 28 f3 ff ff       	call   801be0 <_panic>

008028b8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8028b8:	f3 0f 1e fb          	endbr32 
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
  8028bf:	57                   	push   %edi
  8028c0:	56                   	push   %esi
  8028c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8028c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028c8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8028cd:	be 00 00 00 00       	mov    $0x0,%esi
  8028d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028d5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8028d8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8028da:	5b                   	pop    %ebx
  8028db:	5e                   	pop    %esi
  8028dc:	5f                   	pop    %edi
  8028dd:	5d                   	pop    %ebp
  8028de:	c3                   	ret    

008028df <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8028df:	f3 0f 1e fb          	endbr32 
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	57                   	push   %edi
  8028e7:	56                   	push   %esi
  8028e8:	53                   	push   %ebx
  8028e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8028ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8028f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f4:	b8 0d 00 00 00       	mov    $0xd,%eax
  8028f9:	89 cb                	mov    %ecx,%ebx
  8028fb:	89 cf                	mov    %ecx,%edi
  8028fd:	89 ce                	mov    %ecx,%esi
  8028ff:	cd 30                	int    $0x30
	if(check && ret > 0)
  802901:	85 c0                	test   %eax,%eax
  802903:	7f 08                	jg     80290d <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802905:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802908:	5b                   	pop    %ebx
  802909:	5e                   	pop    %esi
  80290a:	5f                   	pop    %edi
  80290b:	5d                   	pop    %ebp
  80290c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80290d:	83 ec 0c             	sub    $0xc,%esp
  802910:	50                   	push   %eax
  802911:	6a 0d                	push   $0xd
  802913:	68 9f 43 80 00       	push   $0x80439f
  802918:	6a 23                	push   $0x23
  80291a:	68 bc 43 80 00       	push   $0x8043bc
  80291f:	e8 bc f2 ff ff       	call   801be0 <_panic>

00802924 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802924:	f3 0f 1e fb          	endbr32 
  802928:	55                   	push   %ebp
  802929:	89 e5                	mov    %esp,%ebp
  80292b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80292e:	83 3d 10 a0 80 00 00 	cmpl   $0x0,0x80a010
  802935:	74 0a                	je     802941 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	a3 10 a0 80 00       	mov    %eax,0x80a010
}
  80293f:	c9                   	leave  
  802940:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802941:	83 ec 04             	sub    $0x4,%esp
  802944:	6a 07                	push   $0x7
  802946:	68 00 f0 bf ee       	push   $0xeebff000
  80294b:	6a 00                	push   $0x0
  80294d:	e8 c1 fd ff ff       	call   802713 <sys_page_alloc>
  802952:	83 c4 10             	add    $0x10,%esp
  802955:	85 c0                	test   %eax,%eax
  802957:	78 2a                	js     802983 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802959:	83 ec 08             	sub    $0x8,%esp
  80295c:	68 97 29 80 00       	push   $0x802997
  802961:	6a 00                	push   $0x0
  802963:	e8 0a ff ff ff       	call   802872 <sys_env_set_pgfault_upcall>
  802968:	83 c4 10             	add    $0x10,%esp
  80296b:	85 c0                	test   %eax,%eax
  80296d:	79 c8                	jns    802937 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80296f:	83 ec 04             	sub    $0x4,%esp
  802972:	68 f8 43 80 00       	push   $0x8043f8
  802977:	6a 25                	push   $0x25
  802979:	68 30 44 80 00       	push   $0x804430
  80297e:	e8 5d f2 ff ff       	call   801be0 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802983:	83 ec 04             	sub    $0x4,%esp
  802986:	68 cc 43 80 00       	push   $0x8043cc
  80298b:	6a 22                	push   $0x22
  80298d:	68 30 44 80 00       	push   $0x804430
  802992:	e8 49 f2 ff ff       	call   801be0 <_panic>

00802997 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802997:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802998:	a1 10 a0 80 00       	mov    0x80a010,%eax
	call *%eax
  80299d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80299f:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8029a2:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8029a6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8029aa:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8029ad:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8029af:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8029b3:	83 c4 08             	add    $0x8,%esp
	popal
  8029b6:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8029b7:	83 c4 04             	add    $0x4,%esp
	popfl
  8029ba:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8029bb:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8029bc:	c3                   	ret    

008029bd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029bd:	f3 0f 1e fb          	endbr32 
  8029c1:	55                   	push   %ebp
  8029c2:	89 e5                	mov    %esp,%ebp
  8029c4:	56                   	push   %esi
  8029c5:	53                   	push   %ebx
  8029c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8029c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	74 3d                	je     802a10 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8029d3:	83 ec 0c             	sub    $0xc,%esp
  8029d6:	50                   	push   %eax
  8029d7:	e8 03 ff ff ff       	call   8028df <sys_ipc_recv>
  8029dc:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8029df:	85 f6                	test   %esi,%esi
  8029e1:	74 0b                	je     8029ee <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8029e3:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8029e9:	8b 52 74             	mov    0x74(%edx),%edx
  8029ec:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8029ee:	85 db                	test   %ebx,%ebx
  8029f0:	74 0b                	je     8029fd <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8029f2:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8029f8:	8b 52 78             	mov    0x78(%edx),%edx
  8029fb:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	78 21                	js     802a22 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802a01:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802a06:	8b 40 70             	mov    0x70(%eax),%eax
}
  802a09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a0c:	5b                   	pop    %ebx
  802a0d:	5e                   	pop    %esi
  802a0e:	5d                   	pop    %ebp
  802a0f:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802a10:	83 ec 0c             	sub    $0xc,%esp
  802a13:	68 00 00 c0 ee       	push   $0xeec00000
  802a18:	e8 c2 fe ff ff       	call   8028df <sys_ipc_recv>
  802a1d:	83 c4 10             	add    $0x10,%esp
  802a20:	eb bd                	jmp    8029df <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802a22:	85 f6                	test   %esi,%esi
  802a24:	74 10                	je     802a36 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802a26:	85 db                	test   %ebx,%ebx
  802a28:	75 df                	jne    802a09 <ipc_recv+0x4c>
  802a2a:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802a31:	00 00 00 
  802a34:	eb d3                	jmp    802a09 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802a36:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802a3d:	00 00 00 
  802a40:	eb e4                	jmp    802a26 <ipc_recv+0x69>

00802a42 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a42:	f3 0f 1e fb          	endbr32 
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
  802a49:	57                   	push   %edi
  802a4a:	56                   	push   %esi
  802a4b:	53                   	push   %ebx
  802a4c:	83 ec 0c             	sub    $0xc,%esp
  802a4f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a52:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802a58:	85 db                	test   %ebx,%ebx
  802a5a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a5f:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802a62:	ff 75 14             	pushl  0x14(%ebp)
  802a65:	53                   	push   %ebx
  802a66:	56                   	push   %esi
  802a67:	57                   	push   %edi
  802a68:	e8 4b fe ff ff       	call   8028b8 <sys_ipc_try_send>
  802a6d:	83 c4 10             	add    $0x10,%esp
  802a70:	85 c0                	test   %eax,%eax
  802a72:	79 1e                	jns    802a92 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802a74:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a77:	75 07                	jne    802a80 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802a79:	e8 72 fc ff ff       	call   8026f0 <sys_yield>
  802a7e:	eb e2                	jmp    802a62 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802a80:	50                   	push   %eax
  802a81:	68 3e 44 80 00       	push   $0x80443e
  802a86:	6a 59                	push   $0x59
  802a88:	68 59 44 80 00       	push   $0x804459
  802a8d:	e8 4e f1 ff ff       	call   801be0 <_panic>
	}
}
  802a92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a95:	5b                   	pop    %ebx
  802a96:	5e                   	pop    %esi
  802a97:	5f                   	pop    %edi
  802a98:	5d                   	pop    %ebp
  802a99:	c3                   	ret    

00802a9a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a9a:	f3 0f 1e fb          	endbr32 
  802a9e:	55                   	push   %ebp
  802a9f:	89 e5                	mov    %esp,%ebp
  802aa1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802aa4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802aa9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802aac:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802ab2:	8b 52 50             	mov    0x50(%edx),%edx
  802ab5:	39 ca                	cmp    %ecx,%edx
  802ab7:	74 11                	je     802aca <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802ab9:	83 c0 01             	add    $0x1,%eax
  802abc:	3d 00 04 00 00       	cmp    $0x400,%eax
  802ac1:	75 e6                	jne    802aa9 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac8:	eb 0b                	jmp    802ad5 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802aca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802acd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802ad2:	8b 40 48             	mov    0x48(%eax),%eax
}
  802ad5:	5d                   	pop    %ebp
  802ad6:	c3                   	ret    

00802ad7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802ad7:	f3 0f 1e fb          	endbr32 
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	05 00 00 00 30       	add    $0x30000000,%eax
  802ae6:	c1 e8 0c             	shr    $0xc,%eax
}
  802ae9:	5d                   	pop    %ebp
  802aea:	c3                   	ret    

00802aeb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802aeb:	f3 0f 1e fb          	endbr32 
  802aef:	55                   	push   %ebp
  802af0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802afa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802aff:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    

00802b06 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802b06:	f3 0f 1e fb          	endbr32 
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
  802b0d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802b12:	89 c2                	mov    %eax,%edx
  802b14:	c1 ea 16             	shr    $0x16,%edx
  802b17:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802b1e:	f6 c2 01             	test   $0x1,%dl
  802b21:	74 2d                	je     802b50 <fd_alloc+0x4a>
  802b23:	89 c2                	mov    %eax,%edx
  802b25:	c1 ea 0c             	shr    $0xc,%edx
  802b28:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802b2f:	f6 c2 01             	test   $0x1,%dl
  802b32:	74 1c                	je     802b50 <fd_alloc+0x4a>
  802b34:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802b39:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802b3e:	75 d2                	jne    802b12 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802b49:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802b4e:	eb 0a                	jmp    802b5a <fd_alloc+0x54>
			*fd_store = fd;
  802b50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b53:	89 01                	mov    %eax,(%ecx)
			return 0;
  802b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b5a:	5d                   	pop    %ebp
  802b5b:	c3                   	ret    

00802b5c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b5c:	f3 0f 1e fb          	endbr32 
  802b60:	55                   	push   %ebp
  802b61:	89 e5                	mov    %esp,%ebp
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b66:	83 f8 1f             	cmp    $0x1f,%eax
  802b69:	77 30                	ja     802b9b <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802b6b:	c1 e0 0c             	shl    $0xc,%eax
  802b6e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802b73:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802b79:	f6 c2 01             	test   $0x1,%dl
  802b7c:	74 24                	je     802ba2 <fd_lookup+0x46>
  802b7e:	89 c2                	mov    %eax,%edx
  802b80:	c1 ea 0c             	shr    $0xc,%edx
  802b83:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802b8a:	f6 c2 01             	test   $0x1,%dl
  802b8d:	74 1a                	je     802ba9 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b92:	89 02                	mov    %eax,(%edx)
	return 0;
  802b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b99:	5d                   	pop    %ebp
  802b9a:	c3                   	ret    
		return -E_INVAL;
  802b9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ba0:	eb f7                	jmp    802b99 <fd_lookup+0x3d>
		return -E_INVAL;
  802ba2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ba7:	eb f0                	jmp    802b99 <fd_lookup+0x3d>
  802ba9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bae:	eb e9                	jmp    802b99 <fd_lookup+0x3d>

00802bb0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802bb0:	f3 0f 1e fb          	endbr32 
  802bb4:	55                   	push   %ebp
  802bb5:	89 e5                	mov    %esp,%ebp
  802bb7:	83 ec 08             	sub    $0x8,%esp
  802bba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bbd:	ba e0 44 80 00       	mov    $0x8044e0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  802bc2:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802bc7:	39 08                	cmp    %ecx,(%eax)
  802bc9:	74 33                	je     802bfe <dev_lookup+0x4e>
  802bcb:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  802bce:	8b 02                	mov    (%edx),%eax
  802bd0:	85 c0                	test   %eax,%eax
  802bd2:	75 f3                	jne    802bc7 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802bd4:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802bd9:	8b 40 48             	mov    0x48(%eax),%eax
  802bdc:	83 ec 04             	sub    $0x4,%esp
  802bdf:	51                   	push   %ecx
  802be0:	50                   	push   %eax
  802be1:	68 64 44 80 00       	push   $0x804464
  802be6:	e8 dc f0 ff ff       	call   801cc7 <cprintf>
	*dev = 0;
  802beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802bf4:	83 c4 10             	add    $0x10,%esp
  802bf7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802bfc:	c9                   	leave  
  802bfd:	c3                   	ret    
			*dev = devtab[i];
  802bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c01:	89 01                	mov    %eax,(%ecx)
			return 0;
  802c03:	b8 00 00 00 00       	mov    $0x0,%eax
  802c08:	eb f2                	jmp    802bfc <dev_lookup+0x4c>

00802c0a <fd_close>:
{
  802c0a:	f3 0f 1e fb          	endbr32 
  802c0e:	55                   	push   %ebp
  802c0f:	89 e5                	mov    %esp,%ebp
  802c11:	57                   	push   %edi
  802c12:	56                   	push   %esi
  802c13:	53                   	push   %ebx
  802c14:	83 ec 24             	sub    $0x24,%esp
  802c17:	8b 75 08             	mov    0x8(%ebp),%esi
  802c1a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c1d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802c20:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802c21:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802c27:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c2a:	50                   	push   %eax
  802c2b:	e8 2c ff ff ff       	call   802b5c <fd_lookup>
  802c30:	89 c3                	mov    %eax,%ebx
  802c32:	83 c4 10             	add    $0x10,%esp
  802c35:	85 c0                	test   %eax,%eax
  802c37:	78 05                	js     802c3e <fd_close+0x34>
	    || fd != fd2)
  802c39:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802c3c:	74 16                	je     802c54 <fd_close+0x4a>
		return (must_exist ? r : 0);
  802c3e:	89 f8                	mov    %edi,%eax
  802c40:	84 c0                	test   %al,%al
  802c42:	b8 00 00 00 00       	mov    $0x0,%eax
  802c47:	0f 44 d8             	cmove  %eax,%ebx
}
  802c4a:	89 d8                	mov    %ebx,%eax
  802c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c4f:	5b                   	pop    %ebx
  802c50:	5e                   	pop    %esi
  802c51:	5f                   	pop    %edi
  802c52:	5d                   	pop    %ebp
  802c53:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c54:	83 ec 08             	sub    $0x8,%esp
  802c57:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802c5a:	50                   	push   %eax
  802c5b:	ff 36                	pushl  (%esi)
  802c5d:	e8 4e ff ff ff       	call   802bb0 <dev_lookup>
  802c62:	89 c3                	mov    %eax,%ebx
  802c64:	83 c4 10             	add    $0x10,%esp
  802c67:	85 c0                	test   %eax,%eax
  802c69:	78 1a                	js     802c85 <fd_close+0x7b>
		if (dev->dev_close)
  802c6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c6e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802c71:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802c76:	85 c0                	test   %eax,%eax
  802c78:	74 0b                	je     802c85 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  802c7a:	83 ec 0c             	sub    $0xc,%esp
  802c7d:	56                   	push   %esi
  802c7e:	ff d0                	call   *%eax
  802c80:	89 c3                	mov    %eax,%ebx
  802c82:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802c85:	83 ec 08             	sub    $0x8,%esp
  802c88:	56                   	push   %esi
  802c89:	6a 00                	push   $0x0
  802c8b:	e8 10 fb ff ff       	call   8027a0 <sys_page_unmap>
	return r;
  802c90:	83 c4 10             	add    $0x10,%esp
  802c93:	eb b5                	jmp    802c4a <fd_close+0x40>

00802c95 <close>:

int
close(int fdnum)
{
  802c95:	f3 0f 1e fb          	endbr32 
  802c99:	55                   	push   %ebp
  802c9a:	89 e5                	mov    %esp,%ebp
  802c9c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ca2:	50                   	push   %eax
  802ca3:	ff 75 08             	pushl  0x8(%ebp)
  802ca6:	e8 b1 fe ff ff       	call   802b5c <fd_lookup>
  802cab:	83 c4 10             	add    $0x10,%esp
  802cae:	85 c0                	test   %eax,%eax
  802cb0:	79 02                	jns    802cb4 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  802cb2:	c9                   	leave  
  802cb3:	c3                   	ret    
		return fd_close(fd, 1);
  802cb4:	83 ec 08             	sub    $0x8,%esp
  802cb7:	6a 01                	push   $0x1
  802cb9:	ff 75 f4             	pushl  -0xc(%ebp)
  802cbc:	e8 49 ff ff ff       	call   802c0a <fd_close>
  802cc1:	83 c4 10             	add    $0x10,%esp
  802cc4:	eb ec                	jmp    802cb2 <close+0x1d>

00802cc6 <close_all>:

void
close_all(void)
{
  802cc6:	f3 0f 1e fb          	endbr32 
  802cca:	55                   	push   %ebp
  802ccb:	89 e5                	mov    %esp,%ebp
  802ccd:	53                   	push   %ebx
  802cce:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802cd1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802cd6:	83 ec 0c             	sub    $0xc,%esp
  802cd9:	53                   	push   %ebx
  802cda:	e8 b6 ff ff ff       	call   802c95 <close>
	for (i = 0; i < MAXFD; i++)
  802cdf:	83 c3 01             	add    $0x1,%ebx
  802ce2:	83 c4 10             	add    $0x10,%esp
  802ce5:	83 fb 20             	cmp    $0x20,%ebx
  802ce8:	75 ec                	jne    802cd6 <close_all+0x10>
}
  802cea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ced:	c9                   	leave  
  802cee:	c3                   	ret    

00802cef <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802cef:	f3 0f 1e fb          	endbr32 
  802cf3:	55                   	push   %ebp
  802cf4:	89 e5                	mov    %esp,%ebp
  802cf6:	57                   	push   %edi
  802cf7:	56                   	push   %esi
  802cf8:	53                   	push   %ebx
  802cf9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802cfc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802cff:	50                   	push   %eax
  802d00:	ff 75 08             	pushl  0x8(%ebp)
  802d03:	e8 54 fe ff ff       	call   802b5c <fd_lookup>
  802d08:	89 c3                	mov    %eax,%ebx
  802d0a:	83 c4 10             	add    $0x10,%esp
  802d0d:	85 c0                	test   %eax,%eax
  802d0f:	0f 88 81 00 00 00    	js     802d96 <dup+0xa7>
		return r;
	close(newfdnum);
  802d15:	83 ec 0c             	sub    $0xc,%esp
  802d18:	ff 75 0c             	pushl  0xc(%ebp)
  802d1b:	e8 75 ff ff ff       	call   802c95 <close>

	newfd = INDEX2FD(newfdnum);
  802d20:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d23:	c1 e6 0c             	shl    $0xc,%esi
  802d26:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802d2c:	83 c4 04             	add    $0x4,%esp
  802d2f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d32:	e8 b4 fd ff ff       	call   802aeb <fd2data>
  802d37:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802d39:	89 34 24             	mov    %esi,(%esp)
  802d3c:	e8 aa fd ff ff       	call   802aeb <fd2data>
  802d41:	83 c4 10             	add    $0x10,%esp
  802d44:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802d46:	89 d8                	mov    %ebx,%eax
  802d48:	c1 e8 16             	shr    $0x16,%eax
  802d4b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802d52:	a8 01                	test   $0x1,%al
  802d54:	74 11                	je     802d67 <dup+0x78>
  802d56:	89 d8                	mov    %ebx,%eax
  802d58:	c1 e8 0c             	shr    $0xc,%eax
  802d5b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802d62:	f6 c2 01             	test   $0x1,%dl
  802d65:	75 39                	jne    802da0 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d6a:	89 d0                	mov    %edx,%eax
  802d6c:	c1 e8 0c             	shr    $0xc,%eax
  802d6f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802d76:	83 ec 0c             	sub    $0xc,%esp
  802d79:	25 07 0e 00 00       	and    $0xe07,%eax
  802d7e:	50                   	push   %eax
  802d7f:	56                   	push   %esi
  802d80:	6a 00                	push   $0x0
  802d82:	52                   	push   %edx
  802d83:	6a 00                	push   $0x0
  802d85:	e8 d0 f9 ff ff       	call   80275a <sys_page_map>
  802d8a:	89 c3                	mov    %eax,%ebx
  802d8c:	83 c4 20             	add    $0x20,%esp
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	78 31                	js     802dc4 <dup+0xd5>
		goto err;

	return newfdnum;
  802d93:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802d96:	89 d8                	mov    %ebx,%eax
  802d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d9b:	5b                   	pop    %ebx
  802d9c:	5e                   	pop    %esi
  802d9d:	5f                   	pop    %edi
  802d9e:	5d                   	pop    %ebp
  802d9f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802da0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802da7:	83 ec 0c             	sub    $0xc,%esp
  802daa:	25 07 0e 00 00       	and    $0xe07,%eax
  802daf:	50                   	push   %eax
  802db0:	57                   	push   %edi
  802db1:	6a 00                	push   $0x0
  802db3:	53                   	push   %ebx
  802db4:	6a 00                	push   $0x0
  802db6:	e8 9f f9 ff ff       	call   80275a <sys_page_map>
  802dbb:	89 c3                	mov    %eax,%ebx
  802dbd:	83 c4 20             	add    $0x20,%esp
  802dc0:	85 c0                	test   %eax,%eax
  802dc2:	79 a3                	jns    802d67 <dup+0x78>
	sys_page_unmap(0, newfd);
  802dc4:	83 ec 08             	sub    $0x8,%esp
  802dc7:	56                   	push   %esi
  802dc8:	6a 00                	push   $0x0
  802dca:	e8 d1 f9 ff ff       	call   8027a0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802dcf:	83 c4 08             	add    $0x8,%esp
  802dd2:	57                   	push   %edi
  802dd3:	6a 00                	push   $0x0
  802dd5:	e8 c6 f9 ff ff       	call   8027a0 <sys_page_unmap>
	return r;
  802dda:	83 c4 10             	add    $0x10,%esp
  802ddd:	eb b7                	jmp    802d96 <dup+0xa7>

00802ddf <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ddf:	f3 0f 1e fb          	endbr32 
  802de3:	55                   	push   %ebp
  802de4:	89 e5                	mov    %esp,%ebp
  802de6:	53                   	push   %ebx
  802de7:	83 ec 1c             	sub    $0x1c,%esp
  802dea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ded:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802df0:	50                   	push   %eax
  802df1:	53                   	push   %ebx
  802df2:	e8 65 fd ff ff       	call   802b5c <fd_lookup>
  802df7:	83 c4 10             	add    $0x10,%esp
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	78 3f                	js     802e3d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dfe:	83 ec 08             	sub    $0x8,%esp
  802e01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e04:	50                   	push   %eax
  802e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e08:	ff 30                	pushl  (%eax)
  802e0a:	e8 a1 fd ff ff       	call   802bb0 <dev_lookup>
  802e0f:	83 c4 10             	add    $0x10,%esp
  802e12:	85 c0                	test   %eax,%eax
  802e14:	78 27                	js     802e3d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802e16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e19:	8b 42 08             	mov    0x8(%edx),%eax
  802e1c:	83 e0 03             	and    $0x3,%eax
  802e1f:	83 f8 01             	cmp    $0x1,%eax
  802e22:	74 1e                	je     802e42 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 40 08             	mov    0x8(%eax),%eax
  802e2a:	85 c0                	test   %eax,%eax
  802e2c:	74 35                	je     802e63 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	ff 75 10             	pushl  0x10(%ebp)
  802e34:	ff 75 0c             	pushl  0xc(%ebp)
  802e37:	52                   	push   %edx
  802e38:	ff d0                	call   *%eax
  802e3a:	83 c4 10             	add    $0x10,%esp
}
  802e3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e40:	c9                   	leave  
  802e41:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e42:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802e47:	8b 40 48             	mov    0x48(%eax),%eax
  802e4a:	83 ec 04             	sub    $0x4,%esp
  802e4d:	53                   	push   %ebx
  802e4e:	50                   	push   %eax
  802e4f:	68 a5 44 80 00       	push   $0x8044a5
  802e54:	e8 6e ee ff ff       	call   801cc7 <cprintf>
		return -E_INVAL;
  802e59:	83 c4 10             	add    $0x10,%esp
  802e5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e61:	eb da                	jmp    802e3d <read+0x5e>
		return -E_NOT_SUPP;
  802e63:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e68:	eb d3                	jmp    802e3d <read+0x5e>

00802e6a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e6a:	f3 0f 1e fb          	endbr32 
  802e6e:	55                   	push   %ebp
  802e6f:	89 e5                	mov    %esp,%ebp
  802e71:	57                   	push   %edi
  802e72:	56                   	push   %esi
  802e73:	53                   	push   %ebx
  802e74:	83 ec 0c             	sub    $0xc,%esp
  802e77:	8b 7d 08             	mov    0x8(%ebp),%edi
  802e7a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e82:	eb 02                	jmp    802e86 <readn+0x1c>
  802e84:	01 c3                	add    %eax,%ebx
  802e86:	39 f3                	cmp    %esi,%ebx
  802e88:	73 21                	jae    802eab <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e8a:	83 ec 04             	sub    $0x4,%esp
  802e8d:	89 f0                	mov    %esi,%eax
  802e8f:	29 d8                	sub    %ebx,%eax
  802e91:	50                   	push   %eax
  802e92:	89 d8                	mov    %ebx,%eax
  802e94:	03 45 0c             	add    0xc(%ebp),%eax
  802e97:	50                   	push   %eax
  802e98:	57                   	push   %edi
  802e99:	e8 41 ff ff ff       	call   802ddf <read>
		if (m < 0)
  802e9e:	83 c4 10             	add    $0x10,%esp
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	78 04                	js     802ea9 <readn+0x3f>
			return m;
		if (m == 0)
  802ea5:	75 dd                	jne    802e84 <readn+0x1a>
  802ea7:	eb 02                	jmp    802eab <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ea9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802eab:	89 d8                	mov    %ebx,%eax
  802ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802eb0:	5b                   	pop    %ebx
  802eb1:	5e                   	pop    %esi
  802eb2:	5f                   	pop    %edi
  802eb3:	5d                   	pop    %ebp
  802eb4:	c3                   	ret    

00802eb5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802eb5:	f3 0f 1e fb          	endbr32 
  802eb9:	55                   	push   %ebp
  802eba:	89 e5                	mov    %esp,%ebp
  802ebc:	53                   	push   %ebx
  802ebd:	83 ec 1c             	sub    $0x1c,%esp
  802ec0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ec3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ec6:	50                   	push   %eax
  802ec7:	53                   	push   %ebx
  802ec8:	e8 8f fc ff ff       	call   802b5c <fd_lookup>
  802ecd:	83 c4 10             	add    $0x10,%esp
  802ed0:	85 c0                	test   %eax,%eax
  802ed2:	78 3a                	js     802f0e <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ed4:	83 ec 08             	sub    $0x8,%esp
  802ed7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802eda:	50                   	push   %eax
  802edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ede:	ff 30                	pushl  (%eax)
  802ee0:	e8 cb fc ff ff       	call   802bb0 <dev_lookup>
  802ee5:	83 c4 10             	add    $0x10,%esp
  802ee8:	85 c0                	test   %eax,%eax
  802eea:	78 22                	js     802f0e <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eef:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802ef3:	74 1e                	je     802f13 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef8:	8b 52 0c             	mov    0xc(%edx),%edx
  802efb:	85 d2                	test   %edx,%edx
  802efd:	74 35                	je     802f34 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802eff:	83 ec 04             	sub    $0x4,%esp
  802f02:	ff 75 10             	pushl  0x10(%ebp)
  802f05:	ff 75 0c             	pushl  0xc(%ebp)
  802f08:	50                   	push   %eax
  802f09:	ff d2                	call   *%edx
  802f0b:	83 c4 10             	add    $0x10,%esp
}
  802f0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f11:	c9                   	leave  
  802f12:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802f13:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802f18:	8b 40 48             	mov    0x48(%eax),%eax
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	53                   	push   %ebx
  802f1f:	50                   	push   %eax
  802f20:	68 c1 44 80 00       	push   $0x8044c1
  802f25:	e8 9d ed ff ff       	call   801cc7 <cprintf>
		return -E_INVAL;
  802f2a:	83 c4 10             	add    $0x10,%esp
  802f2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f32:	eb da                	jmp    802f0e <write+0x59>
		return -E_NOT_SUPP;
  802f34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802f39:	eb d3                	jmp    802f0e <write+0x59>

00802f3b <seek>:

int
seek(int fdnum, off_t offset)
{
  802f3b:	f3 0f 1e fb          	endbr32 
  802f3f:	55                   	push   %ebp
  802f40:	89 e5                	mov    %esp,%ebp
  802f42:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f48:	50                   	push   %eax
  802f49:	ff 75 08             	pushl  0x8(%ebp)
  802f4c:	e8 0b fc ff ff       	call   802b5c <fd_lookup>
  802f51:	83 c4 10             	add    $0x10,%esp
  802f54:	85 c0                	test   %eax,%eax
  802f56:	78 0e                	js     802f66 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  802f58:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802f61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f66:	c9                   	leave  
  802f67:	c3                   	ret    

00802f68 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f68:	f3 0f 1e fb          	endbr32 
  802f6c:	55                   	push   %ebp
  802f6d:	89 e5                	mov    %esp,%ebp
  802f6f:	53                   	push   %ebx
  802f70:	83 ec 1c             	sub    $0x1c,%esp
  802f73:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f76:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f79:	50                   	push   %eax
  802f7a:	53                   	push   %ebx
  802f7b:	e8 dc fb ff ff       	call   802b5c <fd_lookup>
  802f80:	83 c4 10             	add    $0x10,%esp
  802f83:	85 c0                	test   %eax,%eax
  802f85:	78 37                	js     802fbe <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f87:	83 ec 08             	sub    $0x8,%esp
  802f8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f8d:	50                   	push   %eax
  802f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f91:	ff 30                	pushl  (%eax)
  802f93:	e8 18 fc ff ff       	call   802bb0 <dev_lookup>
  802f98:	83 c4 10             	add    $0x10,%esp
  802f9b:	85 c0                	test   %eax,%eax
  802f9d:	78 1f                	js     802fbe <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802fa6:	74 1b                	je     802fc3 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802fa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fab:	8b 52 18             	mov    0x18(%edx),%edx
  802fae:	85 d2                	test   %edx,%edx
  802fb0:	74 32                	je     802fe4 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802fb2:	83 ec 08             	sub    $0x8,%esp
  802fb5:	ff 75 0c             	pushl  0xc(%ebp)
  802fb8:	50                   	push   %eax
  802fb9:	ff d2                	call   *%edx
  802fbb:	83 c4 10             	add    $0x10,%esp
}
  802fbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fc1:	c9                   	leave  
  802fc2:	c3                   	ret    
			thisenv->env_id, fdnum);
  802fc3:	a1 0c a0 80 00       	mov    0x80a00c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802fc8:	8b 40 48             	mov    0x48(%eax),%eax
  802fcb:	83 ec 04             	sub    $0x4,%esp
  802fce:	53                   	push   %ebx
  802fcf:	50                   	push   %eax
  802fd0:	68 84 44 80 00       	push   $0x804484
  802fd5:	e8 ed ec ff ff       	call   801cc7 <cprintf>
		return -E_INVAL;
  802fda:	83 c4 10             	add    $0x10,%esp
  802fdd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fe2:	eb da                	jmp    802fbe <ftruncate+0x56>
		return -E_NOT_SUPP;
  802fe4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802fe9:	eb d3                	jmp    802fbe <ftruncate+0x56>

00802feb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802feb:	f3 0f 1e fb          	endbr32 
  802fef:	55                   	push   %ebp
  802ff0:	89 e5                	mov    %esp,%ebp
  802ff2:	53                   	push   %ebx
  802ff3:	83 ec 1c             	sub    $0x1c,%esp
  802ff6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ff9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ffc:	50                   	push   %eax
  802ffd:	ff 75 08             	pushl  0x8(%ebp)
  803000:	e8 57 fb ff ff       	call   802b5c <fd_lookup>
  803005:	83 c4 10             	add    $0x10,%esp
  803008:	85 c0                	test   %eax,%eax
  80300a:	78 4b                	js     803057 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80300c:	83 ec 08             	sub    $0x8,%esp
  80300f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803012:	50                   	push   %eax
  803013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803016:	ff 30                	pushl  (%eax)
  803018:	e8 93 fb ff ff       	call   802bb0 <dev_lookup>
  80301d:	83 c4 10             	add    $0x10,%esp
  803020:	85 c0                	test   %eax,%eax
  803022:	78 33                	js     803057 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80302b:	74 2f                	je     80305c <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80302d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  803030:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  803037:	00 00 00 
	stat->st_isdir = 0;
  80303a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803041:	00 00 00 
	stat->st_dev = dev;
  803044:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80304a:	83 ec 08             	sub    $0x8,%esp
  80304d:	53                   	push   %ebx
  80304e:	ff 75 f0             	pushl  -0x10(%ebp)
  803051:	ff 50 14             	call   *0x14(%eax)
  803054:	83 c4 10             	add    $0x10,%esp
}
  803057:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80305a:	c9                   	leave  
  80305b:	c3                   	ret    
		return -E_NOT_SUPP;
  80305c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803061:	eb f4                	jmp    803057 <fstat+0x6c>

00803063 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803063:	f3 0f 1e fb          	endbr32 
  803067:	55                   	push   %ebp
  803068:	89 e5                	mov    %esp,%ebp
  80306a:	56                   	push   %esi
  80306b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80306c:	83 ec 08             	sub    $0x8,%esp
  80306f:	6a 00                	push   $0x0
  803071:	ff 75 08             	pushl  0x8(%ebp)
  803074:	e8 fb 01 00 00       	call   803274 <open>
  803079:	89 c3                	mov    %eax,%ebx
  80307b:	83 c4 10             	add    $0x10,%esp
  80307e:	85 c0                	test   %eax,%eax
  803080:	78 1b                	js     80309d <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  803082:	83 ec 08             	sub    $0x8,%esp
  803085:	ff 75 0c             	pushl  0xc(%ebp)
  803088:	50                   	push   %eax
  803089:	e8 5d ff ff ff       	call   802feb <fstat>
  80308e:	89 c6                	mov    %eax,%esi
	close(fd);
  803090:	89 1c 24             	mov    %ebx,(%esp)
  803093:	e8 fd fb ff ff       	call   802c95 <close>
	return r;
  803098:	83 c4 10             	add    $0x10,%esp
  80309b:	89 f3                	mov    %esi,%ebx
}
  80309d:	89 d8                	mov    %ebx,%eax
  80309f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030a2:	5b                   	pop    %ebx
  8030a3:	5e                   	pop    %esi
  8030a4:	5d                   	pop    %ebp
  8030a5:	c3                   	ret    

008030a6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8030a6:	55                   	push   %ebp
  8030a7:	89 e5                	mov    %esp,%ebp
  8030a9:	56                   	push   %esi
  8030aa:	53                   	push   %ebx
  8030ab:	89 c6                	mov    %eax,%esi
  8030ad:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8030af:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  8030b6:	74 27                	je     8030df <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8030b8:	6a 07                	push   $0x7
  8030ba:	68 00 b0 80 00       	push   $0x80b000
  8030bf:	56                   	push   %esi
  8030c0:	ff 35 00 a0 80 00    	pushl  0x80a000
  8030c6:	e8 77 f9 ff ff       	call   802a42 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8030cb:	83 c4 0c             	add    $0xc,%esp
  8030ce:	6a 00                	push   $0x0
  8030d0:	53                   	push   %ebx
  8030d1:	6a 00                	push   $0x0
  8030d3:	e8 e5 f8 ff ff       	call   8029bd <ipc_recv>
}
  8030d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030db:	5b                   	pop    %ebx
  8030dc:	5e                   	pop    %esi
  8030dd:	5d                   	pop    %ebp
  8030de:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8030df:	83 ec 0c             	sub    $0xc,%esp
  8030e2:	6a 01                	push   $0x1
  8030e4:	e8 b1 f9 ff ff       	call   802a9a <ipc_find_env>
  8030e9:	a3 00 a0 80 00       	mov    %eax,0x80a000
  8030ee:	83 c4 10             	add    $0x10,%esp
  8030f1:	eb c5                	jmp    8030b8 <fsipc+0x12>

008030f3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8030f3:	f3 0f 1e fb          	endbr32 
  8030f7:	55                   	push   %ebp
  8030f8:	89 e5                	mov    %esp,%ebp
  8030fa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	8b 40 0c             	mov    0xc(%eax),%eax
  803103:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  803108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310b:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  803110:	ba 00 00 00 00       	mov    $0x0,%edx
  803115:	b8 02 00 00 00       	mov    $0x2,%eax
  80311a:	e8 87 ff ff ff       	call   8030a6 <fsipc>
}
  80311f:	c9                   	leave  
  803120:	c3                   	ret    

00803121 <devfile_flush>:
{
  803121:	f3 0f 1e fb          	endbr32 
  803125:	55                   	push   %ebp
  803126:	89 e5                	mov    %esp,%ebp
  803128:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	8b 40 0c             	mov    0xc(%eax),%eax
  803131:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  803136:	ba 00 00 00 00       	mov    $0x0,%edx
  80313b:	b8 06 00 00 00       	mov    $0x6,%eax
  803140:	e8 61 ff ff ff       	call   8030a6 <fsipc>
}
  803145:	c9                   	leave  
  803146:	c3                   	ret    

00803147 <devfile_stat>:
{
  803147:	f3 0f 1e fb          	endbr32 
  80314b:	55                   	push   %ebp
  80314c:	89 e5                	mov    %esp,%ebp
  80314e:	53                   	push   %ebx
  80314f:	83 ec 04             	sub    $0x4,%esp
  803152:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	8b 40 0c             	mov    0xc(%eax),%eax
  80315b:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803160:	ba 00 00 00 00       	mov    $0x0,%edx
  803165:	b8 05 00 00 00       	mov    $0x5,%eax
  80316a:	e8 37 ff ff ff       	call   8030a6 <fsipc>
  80316f:	85 c0                	test   %eax,%eax
  803171:	78 2c                	js     80319f <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803173:	83 ec 08             	sub    $0x8,%esp
  803176:	68 00 b0 80 00       	push   $0x80b000
  80317b:	53                   	push   %ebx
  80317c:	e8 50 f1 ff ff       	call   8022d1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  803181:	a1 80 b0 80 00       	mov    0x80b080,%eax
  803186:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80318c:	a1 84 b0 80 00       	mov    0x80b084,%eax
  803191:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  803197:	83 c4 10             	add    $0x10,%esp
  80319a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80319f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031a2:	c9                   	leave  
  8031a3:	c3                   	ret    

008031a4 <devfile_write>:
{
  8031a4:	f3 0f 1e fb          	endbr32 
  8031a8:	55                   	push   %ebp
  8031a9:	89 e5                	mov    %esp,%ebp
  8031ab:	83 ec 0c             	sub    $0xc,%esp
  8031ae:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b4:	8b 52 0c             	mov    0xc(%edx),%edx
  8031b7:	89 15 00 b0 80 00    	mov    %edx,0x80b000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8031bd:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8031c2:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8031c7:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8031ca:	a3 04 b0 80 00       	mov    %eax,0x80b004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8031cf:	50                   	push   %eax
  8031d0:	ff 75 0c             	pushl  0xc(%ebp)
  8031d3:	68 08 b0 80 00       	push   $0x80b008
  8031d8:	e8 aa f2 ff ff       	call   802487 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8031dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8031e2:	b8 04 00 00 00       	mov    $0x4,%eax
  8031e7:	e8 ba fe ff ff       	call   8030a6 <fsipc>
}
  8031ec:	c9                   	leave  
  8031ed:	c3                   	ret    

008031ee <devfile_read>:
{
  8031ee:	f3 0f 1e fb          	endbr32 
  8031f2:	55                   	push   %ebp
  8031f3:	89 e5                	mov    %esp,%ebp
  8031f5:	56                   	push   %esi
  8031f6:	53                   	push   %ebx
  8031f7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803200:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  803205:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80320b:	ba 00 00 00 00       	mov    $0x0,%edx
  803210:	b8 03 00 00 00       	mov    $0x3,%eax
  803215:	e8 8c fe ff ff       	call   8030a6 <fsipc>
  80321a:	89 c3                	mov    %eax,%ebx
  80321c:	85 c0                	test   %eax,%eax
  80321e:	78 1f                	js     80323f <devfile_read+0x51>
	assert(r <= n);
  803220:	39 f0                	cmp    %esi,%eax
  803222:	77 24                	ja     803248 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  803224:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803229:	7f 33                	jg     80325e <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80322b:	83 ec 04             	sub    $0x4,%esp
  80322e:	50                   	push   %eax
  80322f:	68 00 b0 80 00       	push   $0x80b000
  803234:	ff 75 0c             	pushl  0xc(%ebp)
  803237:	e8 4b f2 ff ff       	call   802487 <memmove>
	return r;
  80323c:	83 c4 10             	add    $0x10,%esp
}
  80323f:	89 d8                	mov    %ebx,%eax
  803241:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803244:	5b                   	pop    %ebx
  803245:	5e                   	pop    %esi
  803246:	5d                   	pop    %ebp
  803247:	c3                   	ret    
	assert(r <= n);
  803248:	68 f0 44 80 00       	push   $0x8044f0
  80324d:	68 fd 3a 80 00       	push   $0x803afd
  803252:	6a 7c                	push   $0x7c
  803254:	68 f7 44 80 00       	push   $0x8044f7
  803259:	e8 82 e9 ff ff       	call   801be0 <_panic>
	assert(r <= PGSIZE);
  80325e:	68 02 45 80 00       	push   $0x804502
  803263:	68 fd 3a 80 00       	push   $0x803afd
  803268:	6a 7d                	push   $0x7d
  80326a:	68 f7 44 80 00       	push   $0x8044f7
  80326f:	e8 6c e9 ff ff       	call   801be0 <_panic>

00803274 <open>:
{
  803274:	f3 0f 1e fb          	endbr32 
  803278:	55                   	push   %ebp
  803279:	89 e5                	mov    %esp,%ebp
  80327b:	56                   	push   %esi
  80327c:	53                   	push   %ebx
  80327d:	83 ec 1c             	sub    $0x1c,%esp
  803280:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  803283:	56                   	push   %esi
  803284:	e8 05 f0 ff ff       	call   80228e <strlen>
  803289:	83 c4 10             	add    $0x10,%esp
  80328c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803291:	7f 6c                	jg     8032ff <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  803293:	83 ec 0c             	sub    $0xc,%esp
  803296:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803299:	50                   	push   %eax
  80329a:	e8 67 f8 ff ff       	call   802b06 <fd_alloc>
  80329f:	89 c3                	mov    %eax,%ebx
  8032a1:	83 c4 10             	add    $0x10,%esp
  8032a4:	85 c0                	test   %eax,%eax
  8032a6:	78 3c                	js     8032e4 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8032a8:	83 ec 08             	sub    $0x8,%esp
  8032ab:	56                   	push   %esi
  8032ac:	68 00 b0 80 00       	push   $0x80b000
  8032b1:	e8 1b f0 ff ff       	call   8022d1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8032b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b9:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8032be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c6:	e8 db fd ff ff       	call   8030a6 <fsipc>
  8032cb:	89 c3                	mov    %eax,%ebx
  8032cd:	83 c4 10             	add    $0x10,%esp
  8032d0:	85 c0                	test   %eax,%eax
  8032d2:	78 19                	js     8032ed <open+0x79>
	return fd2num(fd);
  8032d4:	83 ec 0c             	sub    $0xc,%esp
  8032d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8032da:	e8 f8 f7 ff ff       	call   802ad7 <fd2num>
  8032df:	89 c3                	mov    %eax,%ebx
  8032e1:	83 c4 10             	add    $0x10,%esp
}
  8032e4:	89 d8                	mov    %ebx,%eax
  8032e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032e9:	5b                   	pop    %ebx
  8032ea:	5e                   	pop    %esi
  8032eb:	5d                   	pop    %ebp
  8032ec:	c3                   	ret    
		fd_close(fd, 0);
  8032ed:	83 ec 08             	sub    $0x8,%esp
  8032f0:	6a 00                	push   $0x0
  8032f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8032f5:	e8 10 f9 ff ff       	call   802c0a <fd_close>
		return r;
  8032fa:	83 c4 10             	add    $0x10,%esp
  8032fd:	eb e5                	jmp    8032e4 <open+0x70>
		return -E_BAD_PATH;
  8032ff:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  803304:	eb de                	jmp    8032e4 <open+0x70>

00803306 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  803306:	f3 0f 1e fb          	endbr32 
  80330a:	55                   	push   %ebp
  80330b:	89 e5                	mov    %esp,%ebp
  80330d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803310:	ba 00 00 00 00       	mov    $0x0,%edx
  803315:	b8 08 00 00 00       	mov    $0x8,%eax
  80331a:	e8 87 fd ff ff       	call   8030a6 <fsipc>
}
  80331f:	c9                   	leave  
  803320:	c3                   	ret    

00803321 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803321:	f3 0f 1e fb          	endbr32 
  803325:	55                   	push   %ebp
  803326:	89 e5                	mov    %esp,%ebp
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80332b:	89 c2                	mov    %eax,%edx
  80332d:	c1 ea 16             	shr    $0x16,%edx
  803330:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  803337:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80333c:	f6 c1 01             	test   $0x1,%cl
  80333f:	74 1c                	je     80335d <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  803341:	c1 e8 0c             	shr    $0xc,%eax
  803344:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80334b:	a8 01                	test   $0x1,%al
  80334d:	74 0e                	je     80335d <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80334f:	c1 e8 0c             	shr    $0xc,%eax
  803352:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  803359:	ef 
  80335a:	0f b7 d2             	movzwl %dx,%edx
}
  80335d:	89 d0                	mov    %edx,%eax
  80335f:	5d                   	pop    %ebp
  803360:	c3                   	ret    

00803361 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803361:	f3 0f 1e fb          	endbr32 
  803365:	55                   	push   %ebp
  803366:	89 e5                	mov    %esp,%ebp
  803368:	56                   	push   %esi
  803369:	53                   	push   %ebx
  80336a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80336d:	83 ec 0c             	sub    $0xc,%esp
  803370:	ff 75 08             	pushl  0x8(%ebp)
  803373:	e8 73 f7 ff ff       	call   802aeb <fd2data>
  803378:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80337a:	83 c4 08             	add    $0x8,%esp
  80337d:	68 0e 45 80 00       	push   $0x80450e
  803382:	53                   	push   %ebx
  803383:	e8 49 ef ff ff       	call   8022d1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803388:	8b 46 04             	mov    0x4(%esi),%eax
  80338b:	2b 06                	sub    (%esi),%eax
  80338d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803393:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80339a:	00 00 00 
	stat->st_dev = &devpipe;
  80339d:	c7 83 88 00 00 00 80 	movl   $0x809080,0x88(%ebx)
  8033a4:	90 80 00 
	return 0;
}
  8033a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8033af:	5b                   	pop    %ebx
  8033b0:	5e                   	pop    %esi
  8033b1:	5d                   	pop    %ebp
  8033b2:	c3                   	ret    

008033b3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8033b3:	f3 0f 1e fb          	endbr32 
  8033b7:	55                   	push   %ebp
  8033b8:	89 e5                	mov    %esp,%ebp
  8033ba:	53                   	push   %ebx
  8033bb:	83 ec 0c             	sub    $0xc,%esp
  8033be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8033c1:	53                   	push   %ebx
  8033c2:	6a 00                	push   $0x0
  8033c4:	e8 d7 f3 ff ff       	call   8027a0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8033c9:	89 1c 24             	mov    %ebx,(%esp)
  8033cc:	e8 1a f7 ff ff       	call   802aeb <fd2data>
  8033d1:	83 c4 08             	add    $0x8,%esp
  8033d4:	50                   	push   %eax
  8033d5:	6a 00                	push   $0x0
  8033d7:	e8 c4 f3 ff ff       	call   8027a0 <sys_page_unmap>
}
  8033dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033df:	c9                   	leave  
  8033e0:	c3                   	ret    

008033e1 <_pipeisclosed>:
{
  8033e1:	55                   	push   %ebp
  8033e2:	89 e5                	mov    %esp,%ebp
  8033e4:	57                   	push   %edi
  8033e5:	56                   	push   %esi
  8033e6:	53                   	push   %ebx
  8033e7:	83 ec 1c             	sub    $0x1c,%esp
  8033ea:	89 c7                	mov    %eax,%edi
  8033ec:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8033ee:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8033f3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8033f6:	83 ec 0c             	sub    $0xc,%esp
  8033f9:	57                   	push   %edi
  8033fa:	e8 22 ff ff ff       	call   803321 <pageref>
  8033ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803402:	89 34 24             	mov    %esi,(%esp)
  803405:	e8 17 ff ff ff       	call   803321 <pageref>
		nn = thisenv->env_runs;
  80340a:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  803410:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803413:	83 c4 10             	add    $0x10,%esp
  803416:	39 cb                	cmp    %ecx,%ebx
  803418:	74 1b                	je     803435 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80341a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80341d:	75 cf                	jne    8033ee <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80341f:	8b 42 58             	mov    0x58(%edx),%eax
  803422:	6a 01                	push   $0x1
  803424:	50                   	push   %eax
  803425:	53                   	push   %ebx
  803426:	68 15 45 80 00       	push   $0x804515
  80342b:	e8 97 e8 ff ff       	call   801cc7 <cprintf>
  803430:	83 c4 10             	add    $0x10,%esp
  803433:	eb b9                	jmp    8033ee <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803435:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803438:	0f 94 c0             	sete   %al
  80343b:	0f b6 c0             	movzbl %al,%eax
}
  80343e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803441:	5b                   	pop    %ebx
  803442:	5e                   	pop    %esi
  803443:	5f                   	pop    %edi
  803444:	5d                   	pop    %ebp
  803445:	c3                   	ret    

00803446 <devpipe_write>:
{
  803446:	f3 0f 1e fb          	endbr32 
  80344a:	55                   	push   %ebp
  80344b:	89 e5                	mov    %esp,%ebp
  80344d:	57                   	push   %edi
  80344e:	56                   	push   %esi
  80344f:	53                   	push   %ebx
  803450:	83 ec 28             	sub    $0x28,%esp
  803453:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803456:	56                   	push   %esi
  803457:	e8 8f f6 ff ff       	call   802aeb <fd2data>
  80345c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80345e:	83 c4 10             	add    $0x10,%esp
  803461:	bf 00 00 00 00       	mov    $0x0,%edi
  803466:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803469:	74 4f                	je     8034ba <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80346b:	8b 43 04             	mov    0x4(%ebx),%eax
  80346e:	8b 0b                	mov    (%ebx),%ecx
  803470:	8d 51 20             	lea    0x20(%ecx),%edx
  803473:	39 d0                	cmp    %edx,%eax
  803475:	72 14                	jb     80348b <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  803477:	89 da                	mov    %ebx,%edx
  803479:	89 f0                	mov    %esi,%eax
  80347b:	e8 61 ff ff ff       	call   8033e1 <_pipeisclosed>
  803480:	85 c0                	test   %eax,%eax
  803482:	75 3b                	jne    8034bf <devpipe_write+0x79>
			sys_yield();
  803484:	e8 67 f2 ff ff       	call   8026f0 <sys_yield>
  803489:	eb e0                	jmp    80346b <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80348b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80348e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803492:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803495:	89 c2                	mov    %eax,%edx
  803497:	c1 fa 1f             	sar    $0x1f,%edx
  80349a:	89 d1                	mov    %edx,%ecx
  80349c:	c1 e9 1b             	shr    $0x1b,%ecx
  80349f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8034a2:	83 e2 1f             	and    $0x1f,%edx
  8034a5:	29 ca                	sub    %ecx,%edx
  8034a7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8034ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8034af:	83 c0 01             	add    $0x1,%eax
  8034b2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8034b5:	83 c7 01             	add    $0x1,%edi
  8034b8:	eb ac                	jmp    803466 <devpipe_write+0x20>
	return i;
  8034ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8034bd:	eb 05                	jmp    8034c4 <devpipe_write+0x7e>
				return 0;
  8034bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8034c7:	5b                   	pop    %ebx
  8034c8:	5e                   	pop    %esi
  8034c9:	5f                   	pop    %edi
  8034ca:	5d                   	pop    %ebp
  8034cb:	c3                   	ret    

008034cc <devpipe_read>:
{
  8034cc:	f3 0f 1e fb          	endbr32 
  8034d0:	55                   	push   %ebp
  8034d1:	89 e5                	mov    %esp,%ebp
  8034d3:	57                   	push   %edi
  8034d4:	56                   	push   %esi
  8034d5:	53                   	push   %ebx
  8034d6:	83 ec 18             	sub    $0x18,%esp
  8034d9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8034dc:	57                   	push   %edi
  8034dd:	e8 09 f6 ff ff       	call   802aeb <fd2data>
  8034e2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8034e4:	83 c4 10             	add    $0x10,%esp
  8034e7:	be 00 00 00 00       	mov    $0x0,%esi
  8034ec:	3b 75 10             	cmp    0x10(%ebp),%esi
  8034ef:	75 14                	jne    803505 <devpipe_read+0x39>
	return i;
  8034f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8034f4:	eb 02                	jmp    8034f8 <devpipe_read+0x2c>
				return i;
  8034f6:	89 f0                	mov    %esi,%eax
}
  8034f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8034fb:	5b                   	pop    %ebx
  8034fc:	5e                   	pop    %esi
  8034fd:	5f                   	pop    %edi
  8034fe:	5d                   	pop    %ebp
  8034ff:	c3                   	ret    
			sys_yield();
  803500:	e8 eb f1 ff ff       	call   8026f0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  803505:	8b 03                	mov    (%ebx),%eax
  803507:	3b 43 04             	cmp    0x4(%ebx),%eax
  80350a:	75 18                	jne    803524 <devpipe_read+0x58>
			if (i > 0)
  80350c:	85 f6                	test   %esi,%esi
  80350e:	75 e6                	jne    8034f6 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  803510:	89 da                	mov    %ebx,%edx
  803512:	89 f8                	mov    %edi,%eax
  803514:	e8 c8 fe ff ff       	call   8033e1 <_pipeisclosed>
  803519:	85 c0                	test   %eax,%eax
  80351b:	74 e3                	je     803500 <devpipe_read+0x34>
				return 0;
  80351d:	b8 00 00 00 00       	mov    $0x0,%eax
  803522:	eb d4                	jmp    8034f8 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803524:	99                   	cltd   
  803525:	c1 ea 1b             	shr    $0x1b,%edx
  803528:	01 d0                	add    %edx,%eax
  80352a:	83 e0 1f             	and    $0x1f,%eax
  80352d:	29 d0                	sub    %edx,%eax
  80352f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803534:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803537:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80353a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80353d:	83 c6 01             	add    $0x1,%esi
  803540:	eb aa                	jmp    8034ec <devpipe_read+0x20>

00803542 <pipe>:
{
  803542:	f3 0f 1e fb          	endbr32 
  803546:	55                   	push   %ebp
  803547:	89 e5                	mov    %esp,%ebp
  803549:	56                   	push   %esi
  80354a:	53                   	push   %ebx
  80354b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80354e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803551:	50                   	push   %eax
  803552:	e8 af f5 ff ff       	call   802b06 <fd_alloc>
  803557:	89 c3                	mov    %eax,%ebx
  803559:	83 c4 10             	add    $0x10,%esp
  80355c:	85 c0                	test   %eax,%eax
  80355e:	0f 88 23 01 00 00    	js     803687 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803564:	83 ec 04             	sub    $0x4,%esp
  803567:	68 07 04 00 00       	push   $0x407
  80356c:	ff 75 f4             	pushl  -0xc(%ebp)
  80356f:	6a 00                	push   $0x0
  803571:	e8 9d f1 ff ff       	call   802713 <sys_page_alloc>
  803576:	89 c3                	mov    %eax,%ebx
  803578:	83 c4 10             	add    $0x10,%esp
  80357b:	85 c0                	test   %eax,%eax
  80357d:	0f 88 04 01 00 00    	js     803687 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  803583:	83 ec 0c             	sub    $0xc,%esp
  803586:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803589:	50                   	push   %eax
  80358a:	e8 77 f5 ff ff       	call   802b06 <fd_alloc>
  80358f:	89 c3                	mov    %eax,%ebx
  803591:	83 c4 10             	add    $0x10,%esp
  803594:	85 c0                	test   %eax,%eax
  803596:	0f 88 db 00 00 00    	js     803677 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80359c:	83 ec 04             	sub    $0x4,%esp
  80359f:	68 07 04 00 00       	push   $0x407
  8035a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8035a7:	6a 00                	push   $0x0
  8035a9:	e8 65 f1 ff ff       	call   802713 <sys_page_alloc>
  8035ae:	89 c3                	mov    %eax,%ebx
  8035b0:	83 c4 10             	add    $0x10,%esp
  8035b3:	85 c0                	test   %eax,%eax
  8035b5:	0f 88 bc 00 00 00    	js     803677 <pipe+0x135>
	va = fd2data(fd0);
  8035bb:	83 ec 0c             	sub    $0xc,%esp
  8035be:	ff 75 f4             	pushl  -0xc(%ebp)
  8035c1:	e8 25 f5 ff ff       	call   802aeb <fd2data>
  8035c6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035c8:	83 c4 0c             	add    $0xc,%esp
  8035cb:	68 07 04 00 00       	push   $0x407
  8035d0:	50                   	push   %eax
  8035d1:	6a 00                	push   $0x0
  8035d3:	e8 3b f1 ff ff       	call   802713 <sys_page_alloc>
  8035d8:	89 c3                	mov    %eax,%ebx
  8035da:	83 c4 10             	add    $0x10,%esp
  8035dd:	85 c0                	test   %eax,%eax
  8035df:	0f 88 82 00 00 00    	js     803667 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035e5:	83 ec 0c             	sub    $0xc,%esp
  8035e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8035eb:	e8 fb f4 ff ff       	call   802aeb <fd2data>
  8035f0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8035f7:	50                   	push   %eax
  8035f8:	6a 00                	push   $0x0
  8035fa:	56                   	push   %esi
  8035fb:	6a 00                	push   $0x0
  8035fd:	e8 58 f1 ff ff       	call   80275a <sys_page_map>
  803602:	89 c3                	mov    %eax,%ebx
  803604:	83 c4 20             	add    $0x20,%esp
  803607:	85 c0                	test   %eax,%eax
  803609:	78 4e                	js     803659 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80360b:	a1 80 90 80 00       	mov    0x809080,%eax
  803610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803613:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  803615:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803618:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80361f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803622:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  803624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803627:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80362e:	83 ec 0c             	sub    $0xc,%esp
  803631:	ff 75 f4             	pushl  -0xc(%ebp)
  803634:	e8 9e f4 ff ff       	call   802ad7 <fd2num>
  803639:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80363c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80363e:	83 c4 04             	add    $0x4,%esp
  803641:	ff 75 f0             	pushl  -0x10(%ebp)
  803644:	e8 8e f4 ff ff       	call   802ad7 <fd2num>
  803649:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80364c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80364f:	83 c4 10             	add    $0x10,%esp
  803652:	bb 00 00 00 00       	mov    $0x0,%ebx
  803657:	eb 2e                	jmp    803687 <pipe+0x145>
	sys_page_unmap(0, va);
  803659:	83 ec 08             	sub    $0x8,%esp
  80365c:	56                   	push   %esi
  80365d:	6a 00                	push   $0x0
  80365f:	e8 3c f1 ff ff       	call   8027a0 <sys_page_unmap>
  803664:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803667:	83 ec 08             	sub    $0x8,%esp
  80366a:	ff 75 f0             	pushl  -0x10(%ebp)
  80366d:	6a 00                	push   $0x0
  80366f:	e8 2c f1 ff ff       	call   8027a0 <sys_page_unmap>
  803674:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803677:	83 ec 08             	sub    $0x8,%esp
  80367a:	ff 75 f4             	pushl  -0xc(%ebp)
  80367d:	6a 00                	push   $0x0
  80367f:	e8 1c f1 ff ff       	call   8027a0 <sys_page_unmap>
  803684:	83 c4 10             	add    $0x10,%esp
}
  803687:	89 d8                	mov    %ebx,%eax
  803689:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80368c:	5b                   	pop    %ebx
  80368d:	5e                   	pop    %esi
  80368e:	5d                   	pop    %ebp
  80368f:	c3                   	ret    

00803690 <pipeisclosed>:
{
  803690:	f3 0f 1e fb          	endbr32 
  803694:	55                   	push   %ebp
  803695:	89 e5                	mov    %esp,%ebp
  803697:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80369a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80369d:	50                   	push   %eax
  80369e:	ff 75 08             	pushl  0x8(%ebp)
  8036a1:	e8 b6 f4 ff ff       	call   802b5c <fd_lookup>
  8036a6:	83 c4 10             	add    $0x10,%esp
  8036a9:	85 c0                	test   %eax,%eax
  8036ab:	78 18                	js     8036c5 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8036ad:	83 ec 0c             	sub    $0xc,%esp
  8036b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8036b3:	e8 33 f4 ff ff       	call   802aeb <fd2data>
  8036b8:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8036ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bd:	e8 1f fd ff ff       	call   8033e1 <_pipeisclosed>
  8036c2:	83 c4 10             	add    $0x10,%esp
}
  8036c5:	c9                   	leave  
  8036c6:	c3                   	ret    

008036c7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8036c7:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8036cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d0:	c3                   	ret    

008036d1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8036d1:	f3 0f 1e fb          	endbr32 
  8036d5:	55                   	push   %ebp
  8036d6:	89 e5                	mov    %esp,%ebp
  8036d8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8036db:	68 2d 45 80 00       	push   $0x80452d
  8036e0:	ff 75 0c             	pushl  0xc(%ebp)
  8036e3:	e8 e9 eb ff ff       	call   8022d1 <strcpy>
	return 0;
}
  8036e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ed:	c9                   	leave  
  8036ee:	c3                   	ret    

008036ef <devcons_write>:
{
  8036ef:	f3 0f 1e fb          	endbr32 
  8036f3:	55                   	push   %ebp
  8036f4:	89 e5                	mov    %esp,%ebp
  8036f6:	57                   	push   %edi
  8036f7:	56                   	push   %esi
  8036f8:	53                   	push   %ebx
  8036f9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8036ff:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  803704:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80370a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80370d:	73 31                	jae    803740 <devcons_write+0x51>
		m = n - tot;
  80370f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803712:	29 f3                	sub    %esi,%ebx
  803714:	83 fb 7f             	cmp    $0x7f,%ebx
  803717:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80371c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80371f:	83 ec 04             	sub    $0x4,%esp
  803722:	53                   	push   %ebx
  803723:	89 f0                	mov    %esi,%eax
  803725:	03 45 0c             	add    0xc(%ebp),%eax
  803728:	50                   	push   %eax
  803729:	57                   	push   %edi
  80372a:	e8 58 ed ff ff       	call   802487 <memmove>
		sys_cputs(buf, m);
  80372f:	83 c4 08             	add    $0x8,%esp
  803732:	53                   	push   %ebx
  803733:	57                   	push   %edi
  803734:	e8 0a ef ff ff       	call   802643 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803739:	01 de                	add    %ebx,%esi
  80373b:	83 c4 10             	add    $0x10,%esp
  80373e:	eb ca                	jmp    80370a <devcons_write+0x1b>
}
  803740:	89 f0                	mov    %esi,%eax
  803742:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803745:	5b                   	pop    %ebx
  803746:	5e                   	pop    %esi
  803747:	5f                   	pop    %edi
  803748:	5d                   	pop    %ebp
  803749:	c3                   	ret    

0080374a <devcons_read>:
{
  80374a:	f3 0f 1e fb          	endbr32 
  80374e:	55                   	push   %ebp
  80374f:	89 e5                	mov    %esp,%ebp
  803751:	83 ec 08             	sub    $0x8,%esp
  803754:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803759:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80375d:	74 21                	je     803780 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80375f:	e8 01 ef ff ff       	call   802665 <sys_cgetc>
  803764:	85 c0                	test   %eax,%eax
  803766:	75 07                	jne    80376f <devcons_read+0x25>
		sys_yield();
  803768:	e8 83 ef ff ff       	call   8026f0 <sys_yield>
  80376d:	eb f0                	jmp    80375f <devcons_read+0x15>
	if (c < 0)
  80376f:	78 0f                	js     803780 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  803771:	83 f8 04             	cmp    $0x4,%eax
  803774:	74 0c                	je     803782 <devcons_read+0x38>
	*(char*)vbuf = c;
  803776:	8b 55 0c             	mov    0xc(%ebp),%edx
  803779:	88 02                	mov    %al,(%edx)
	return 1;
  80377b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803780:	c9                   	leave  
  803781:	c3                   	ret    
		return 0;
  803782:	b8 00 00 00 00       	mov    $0x0,%eax
  803787:	eb f7                	jmp    803780 <devcons_read+0x36>

00803789 <cputchar>:
{
  803789:	f3 0f 1e fb          	endbr32 
  80378d:	55                   	push   %ebp
  80378e:	89 e5                	mov    %esp,%ebp
  803790:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803793:	8b 45 08             	mov    0x8(%ebp),%eax
  803796:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803799:	6a 01                	push   $0x1
  80379b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80379e:	50                   	push   %eax
  80379f:	e8 9f ee ff ff       	call   802643 <sys_cputs>
}
  8037a4:	83 c4 10             	add    $0x10,%esp
  8037a7:	c9                   	leave  
  8037a8:	c3                   	ret    

008037a9 <getchar>:
{
  8037a9:	f3 0f 1e fb          	endbr32 
  8037ad:	55                   	push   %ebp
  8037ae:	89 e5                	mov    %esp,%ebp
  8037b0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8037b3:	6a 01                	push   $0x1
  8037b5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8037b8:	50                   	push   %eax
  8037b9:	6a 00                	push   $0x0
  8037bb:	e8 1f f6 ff ff       	call   802ddf <read>
	if (r < 0)
  8037c0:	83 c4 10             	add    $0x10,%esp
  8037c3:	85 c0                	test   %eax,%eax
  8037c5:	78 06                	js     8037cd <getchar+0x24>
	if (r < 1)
  8037c7:	74 06                	je     8037cf <getchar+0x26>
	return c;
  8037c9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8037cd:	c9                   	leave  
  8037ce:	c3                   	ret    
		return -E_EOF;
  8037cf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8037d4:	eb f7                	jmp    8037cd <getchar+0x24>

008037d6 <iscons>:
{
  8037d6:	f3 0f 1e fb          	endbr32 
  8037da:	55                   	push   %ebp
  8037db:	89 e5                	mov    %esp,%ebp
  8037dd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8037e3:	50                   	push   %eax
  8037e4:	ff 75 08             	pushl  0x8(%ebp)
  8037e7:	e8 70 f3 ff ff       	call   802b5c <fd_lookup>
  8037ec:	83 c4 10             	add    $0x10,%esp
  8037ef:	85 c0                	test   %eax,%eax
  8037f1:	78 11                	js     803804 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8037f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f6:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  8037fc:	39 10                	cmp    %edx,(%eax)
  8037fe:	0f 94 c0             	sete   %al
  803801:	0f b6 c0             	movzbl %al,%eax
}
  803804:	c9                   	leave  
  803805:	c3                   	ret    

00803806 <opencons>:
{
  803806:	f3 0f 1e fb          	endbr32 
  80380a:	55                   	push   %ebp
  80380b:	89 e5                	mov    %esp,%ebp
  80380d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803810:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803813:	50                   	push   %eax
  803814:	e8 ed f2 ff ff       	call   802b06 <fd_alloc>
  803819:	83 c4 10             	add    $0x10,%esp
  80381c:	85 c0                	test   %eax,%eax
  80381e:	78 3a                	js     80385a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803820:	83 ec 04             	sub    $0x4,%esp
  803823:	68 07 04 00 00       	push   $0x407
  803828:	ff 75 f4             	pushl  -0xc(%ebp)
  80382b:	6a 00                	push   $0x0
  80382d:	e8 e1 ee ff ff       	call   802713 <sys_page_alloc>
  803832:	83 c4 10             	add    $0x10,%esp
  803835:	85 c0                	test   %eax,%eax
  803837:	78 21                	js     80385a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  803839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383c:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803842:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803847:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80384e:	83 ec 0c             	sub    $0xc,%esp
  803851:	50                   	push   %eax
  803852:	e8 80 f2 ff ff       	call   802ad7 <fd2num>
  803857:	83 c4 10             	add    $0x10,%esp
}
  80385a:	c9                   	leave  
  80385b:	c3                   	ret    
  80385c:	66 90                	xchg   %ax,%ax
  80385e:	66 90                	xchg   %ax,%ax

00803860 <__udivdi3>:
  803860:	f3 0f 1e fb          	endbr32 
  803864:	55                   	push   %ebp
  803865:	57                   	push   %edi
  803866:	56                   	push   %esi
  803867:	53                   	push   %ebx
  803868:	83 ec 1c             	sub    $0x1c,%esp
  80386b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80386f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803873:	8b 74 24 34          	mov    0x34(%esp),%esi
  803877:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80387b:	85 d2                	test   %edx,%edx
  80387d:	75 19                	jne    803898 <__udivdi3+0x38>
  80387f:	39 f3                	cmp    %esi,%ebx
  803881:	76 4d                	jbe    8038d0 <__udivdi3+0x70>
  803883:	31 ff                	xor    %edi,%edi
  803885:	89 e8                	mov    %ebp,%eax
  803887:	89 f2                	mov    %esi,%edx
  803889:	f7 f3                	div    %ebx
  80388b:	89 fa                	mov    %edi,%edx
  80388d:	83 c4 1c             	add    $0x1c,%esp
  803890:	5b                   	pop    %ebx
  803891:	5e                   	pop    %esi
  803892:	5f                   	pop    %edi
  803893:	5d                   	pop    %ebp
  803894:	c3                   	ret    
  803895:	8d 76 00             	lea    0x0(%esi),%esi
  803898:	39 f2                	cmp    %esi,%edx
  80389a:	76 14                	jbe    8038b0 <__udivdi3+0x50>
  80389c:	31 ff                	xor    %edi,%edi
  80389e:	31 c0                	xor    %eax,%eax
  8038a0:	89 fa                	mov    %edi,%edx
  8038a2:	83 c4 1c             	add    $0x1c,%esp
  8038a5:	5b                   	pop    %ebx
  8038a6:	5e                   	pop    %esi
  8038a7:	5f                   	pop    %edi
  8038a8:	5d                   	pop    %ebp
  8038a9:	c3                   	ret    
  8038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8038b0:	0f bd fa             	bsr    %edx,%edi
  8038b3:	83 f7 1f             	xor    $0x1f,%edi
  8038b6:	75 48                	jne    803900 <__udivdi3+0xa0>
  8038b8:	39 f2                	cmp    %esi,%edx
  8038ba:	72 06                	jb     8038c2 <__udivdi3+0x62>
  8038bc:	31 c0                	xor    %eax,%eax
  8038be:	39 eb                	cmp    %ebp,%ebx
  8038c0:	77 de                	ja     8038a0 <__udivdi3+0x40>
  8038c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c7:	eb d7                	jmp    8038a0 <__udivdi3+0x40>
  8038c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8038d0:	89 d9                	mov    %ebx,%ecx
  8038d2:	85 db                	test   %ebx,%ebx
  8038d4:	75 0b                	jne    8038e1 <__udivdi3+0x81>
  8038d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038db:	31 d2                	xor    %edx,%edx
  8038dd:	f7 f3                	div    %ebx
  8038df:	89 c1                	mov    %eax,%ecx
  8038e1:	31 d2                	xor    %edx,%edx
  8038e3:	89 f0                	mov    %esi,%eax
  8038e5:	f7 f1                	div    %ecx
  8038e7:	89 c6                	mov    %eax,%esi
  8038e9:	89 e8                	mov    %ebp,%eax
  8038eb:	89 f7                	mov    %esi,%edi
  8038ed:	f7 f1                	div    %ecx
  8038ef:	89 fa                	mov    %edi,%edx
  8038f1:	83 c4 1c             	add    $0x1c,%esp
  8038f4:	5b                   	pop    %ebx
  8038f5:	5e                   	pop    %esi
  8038f6:	5f                   	pop    %edi
  8038f7:	5d                   	pop    %ebp
  8038f8:	c3                   	ret    
  8038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803900:	89 f9                	mov    %edi,%ecx
  803902:	b8 20 00 00 00       	mov    $0x20,%eax
  803907:	29 f8                	sub    %edi,%eax
  803909:	d3 e2                	shl    %cl,%edx
  80390b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80390f:	89 c1                	mov    %eax,%ecx
  803911:	89 da                	mov    %ebx,%edx
  803913:	d3 ea                	shr    %cl,%edx
  803915:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803919:	09 d1                	or     %edx,%ecx
  80391b:	89 f2                	mov    %esi,%edx
  80391d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803921:	89 f9                	mov    %edi,%ecx
  803923:	d3 e3                	shl    %cl,%ebx
  803925:	89 c1                	mov    %eax,%ecx
  803927:	d3 ea                	shr    %cl,%edx
  803929:	89 f9                	mov    %edi,%ecx
  80392b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80392f:	89 eb                	mov    %ebp,%ebx
  803931:	d3 e6                	shl    %cl,%esi
  803933:	89 c1                	mov    %eax,%ecx
  803935:	d3 eb                	shr    %cl,%ebx
  803937:	09 de                	or     %ebx,%esi
  803939:	89 f0                	mov    %esi,%eax
  80393b:	f7 74 24 08          	divl   0x8(%esp)
  80393f:	89 d6                	mov    %edx,%esi
  803941:	89 c3                	mov    %eax,%ebx
  803943:	f7 64 24 0c          	mull   0xc(%esp)
  803947:	39 d6                	cmp    %edx,%esi
  803949:	72 15                	jb     803960 <__udivdi3+0x100>
  80394b:	89 f9                	mov    %edi,%ecx
  80394d:	d3 e5                	shl    %cl,%ebp
  80394f:	39 c5                	cmp    %eax,%ebp
  803951:	73 04                	jae    803957 <__udivdi3+0xf7>
  803953:	39 d6                	cmp    %edx,%esi
  803955:	74 09                	je     803960 <__udivdi3+0x100>
  803957:	89 d8                	mov    %ebx,%eax
  803959:	31 ff                	xor    %edi,%edi
  80395b:	e9 40 ff ff ff       	jmp    8038a0 <__udivdi3+0x40>
  803960:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803963:	31 ff                	xor    %edi,%edi
  803965:	e9 36 ff ff ff       	jmp    8038a0 <__udivdi3+0x40>
  80396a:	66 90                	xchg   %ax,%ax
  80396c:	66 90                	xchg   %ax,%ax
  80396e:	66 90                	xchg   %ax,%ax

00803970 <__umoddi3>:
  803970:	f3 0f 1e fb          	endbr32 
  803974:	55                   	push   %ebp
  803975:	57                   	push   %edi
  803976:	56                   	push   %esi
  803977:	53                   	push   %ebx
  803978:	83 ec 1c             	sub    $0x1c,%esp
  80397b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80397f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803983:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803987:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80398b:	85 c0                	test   %eax,%eax
  80398d:	75 19                	jne    8039a8 <__umoddi3+0x38>
  80398f:	39 df                	cmp    %ebx,%edi
  803991:	76 5d                	jbe    8039f0 <__umoddi3+0x80>
  803993:	89 f0                	mov    %esi,%eax
  803995:	89 da                	mov    %ebx,%edx
  803997:	f7 f7                	div    %edi
  803999:	89 d0                	mov    %edx,%eax
  80399b:	31 d2                	xor    %edx,%edx
  80399d:	83 c4 1c             	add    $0x1c,%esp
  8039a0:	5b                   	pop    %ebx
  8039a1:	5e                   	pop    %esi
  8039a2:	5f                   	pop    %edi
  8039a3:	5d                   	pop    %ebp
  8039a4:	c3                   	ret    
  8039a5:	8d 76 00             	lea    0x0(%esi),%esi
  8039a8:	89 f2                	mov    %esi,%edx
  8039aa:	39 d8                	cmp    %ebx,%eax
  8039ac:	76 12                	jbe    8039c0 <__umoddi3+0x50>
  8039ae:	89 f0                	mov    %esi,%eax
  8039b0:	89 da                	mov    %ebx,%edx
  8039b2:	83 c4 1c             	add    $0x1c,%esp
  8039b5:	5b                   	pop    %ebx
  8039b6:	5e                   	pop    %esi
  8039b7:	5f                   	pop    %edi
  8039b8:	5d                   	pop    %ebp
  8039b9:	c3                   	ret    
  8039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8039c0:	0f bd e8             	bsr    %eax,%ebp
  8039c3:	83 f5 1f             	xor    $0x1f,%ebp
  8039c6:	75 50                	jne    803a18 <__umoddi3+0xa8>
  8039c8:	39 d8                	cmp    %ebx,%eax
  8039ca:	0f 82 e0 00 00 00    	jb     803ab0 <__umoddi3+0x140>
  8039d0:	89 d9                	mov    %ebx,%ecx
  8039d2:	39 f7                	cmp    %esi,%edi
  8039d4:	0f 86 d6 00 00 00    	jbe    803ab0 <__umoddi3+0x140>
  8039da:	89 d0                	mov    %edx,%eax
  8039dc:	89 ca                	mov    %ecx,%edx
  8039de:	83 c4 1c             	add    $0x1c,%esp
  8039e1:	5b                   	pop    %ebx
  8039e2:	5e                   	pop    %esi
  8039e3:	5f                   	pop    %edi
  8039e4:	5d                   	pop    %ebp
  8039e5:	c3                   	ret    
  8039e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8039ed:	8d 76 00             	lea    0x0(%esi),%esi
  8039f0:	89 fd                	mov    %edi,%ebp
  8039f2:	85 ff                	test   %edi,%edi
  8039f4:	75 0b                	jne    803a01 <__umoddi3+0x91>
  8039f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039fb:	31 d2                	xor    %edx,%edx
  8039fd:	f7 f7                	div    %edi
  8039ff:	89 c5                	mov    %eax,%ebp
  803a01:	89 d8                	mov    %ebx,%eax
  803a03:	31 d2                	xor    %edx,%edx
  803a05:	f7 f5                	div    %ebp
  803a07:	89 f0                	mov    %esi,%eax
  803a09:	f7 f5                	div    %ebp
  803a0b:	89 d0                	mov    %edx,%eax
  803a0d:	31 d2                	xor    %edx,%edx
  803a0f:	eb 8c                	jmp    80399d <__umoddi3+0x2d>
  803a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803a18:	89 e9                	mov    %ebp,%ecx
  803a1a:	ba 20 00 00 00       	mov    $0x20,%edx
  803a1f:	29 ea                	sub    %ebp,%edx
  803a21:	d3 e0                	shl    %cl,%eax
  803a23:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a27:	89 d1                	mov    %edx,%ecx
  803a29:	89 f8                	mov    %edi,%eax
  803a2b:	d3 e8                	shr    %cl,%eax
  803a2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803a31:	89 54 24 04          	mov    %edx,0x4(%esp)
  803a35:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a39:	09 c1                	or     %eax,%ecx
  803a3b:	89 d8                	mov    %ebx,%eax
  803a3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a41:	89 e9                	mov    %ebp,%ecx
  803a43:	d3 e7                	shl    %cl,%edi
  803a45:	89 d1                	mov    %edx,%ecx
  803a47:	d3 e8                	shr    %cl,%eax
  803a49:	89 e9                	mov    %ebp,%ecx
  803a4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a4f:	d3 e3                	shl    %cl,%ebx
  803a51:	89 c7                	mov    %eax,%edi
  803a53:	89 d1                	mov    %edx,%ecx
  803a55:	89 f0                	mov    %esi,%eax
  803a57:	d3 e8                	shr    %cl,%eax
  803a59:	89 e9                	mov    %ebp,%ecx
  803a5b:	89 fa                	mov    %edi,%edx
  803a5d:	d3 e6                	shl    %cl,%esi
  803a5f:	09 d8                	or     %ebx,%eax
  803a61:	f7 74 24 08          	divl   0x8(%esp)
  803a65:	89 d1                	mov    %edx,%ecx
  803a67:	89 f3                	mov    %esi,%ebx
  803a69:	f7 64 24 0c          	mull   0xc(%esp)
  803a6d:	89 c6                	mov    %eax,%esi
  803a6f:	89 d7                	mov    %edx,%edi
  803a71:	39 d1                	cmp    %edx,%ecx
  803a73:	72 06                	jb     803a7b <__umoddi3+0x10b>
  803a75:	75 10                	jne    803a87 <__umoddi3+0x117>
  803a77:	39 c3                	cmp    %eax,%ebx
  803a79:	73 0c                	jae    803a87 <__umoddi3+0x117>
  803a7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803a7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803a83:	89 d7                	mov    %edx,%edi
  803a85:	89 c6                	mov    %eax,%esi
  803a87:	89 ca                	mov    %ecx,%edx
  803a89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803a8e:	29 f3                	sub    %esi,%ebx
  803a90:	19 fa                	sbb    %edi,%edx
  803a92:	89 d0                	mov    %edx,%eax
  803a94:	d3 e0                	shl    %cl,%eax
  803a96:	89 e9                	mov    %ebp,%ecx
  803a98:	d3 eb                	shr    %cl,%ebx
  803a9a:	d3 ea                	shr    %cl,%edx
  803a9c:	09 d8                	or     %ebx,%eax
  803a9e:	83 c4 1c             	add    $0x1c,%esp
  803aa1:	5b                   	pop    %ebx
  803aa2:	5e                   	pop    %esi
  803aa3:	5f                   	pop    %edi
  803aa4:	5d                   	pop    %ebp
  803aa5:	c3                   	ret    
  803aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803aad:	8d 76 00             	lea    0x0(%esi),%esi
  803ab0:	29 fe                	sub    %edi,%esi
  803ab2:	19 c3                	sbb    %eax,%ebx
  803ab4:	89 f2                	mov    %esi,%edx
  803ab6:	89 d9                	mov    %ebx,%ecx
  803ab8:	e9 1d ff ff ff       	jmp    8039da <__umoddi3+0x6a>
