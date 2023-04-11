
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 10 12 00       	mov    $0x121000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 10 12 f0       	mov    $0xf0121000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 62 00 00 00       	call   f01000a0 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	f3 0f 1e fb          	endbr32 
f0100044:	55                   	push   %ebp
f0100045:	89 e5                	mov    %esp,%ebp
f0100047:	56                   	push   %esi
f0100048:	53                   	push   %ebx
f0100049:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f010004c:	83 3d 80 7e 23 f0 00 	cmpl   $0x0,0xf0237e80
f0100053:	74 0f                	je     f0100064 <_panic+0x24>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100055:	83 ec 0c             	sub    $0xc,%esp
f0100058:	6a 00                	push   $0x0
f010005a:	e8 e8 08 00 00       	call   f0100947 <monitor>
f010005f:	83 c4 10             	add    $0x10,%esp
f0100062:	eb f1                	jmp    f0100055 <_panic+0x15>
	panicstr = fmt;
f0100064:	89 35 80 7e 23 f0    	mov    %esi,0xf0237e80
	asm volatile("cli; cld");
f010006a:	fa                   	cli    
f010006b:	fc                   	cld    
	va_start(ap, fmt);
f010006c:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006f:	e8 46 60 00 00       	call   f01060ba <cpunum>
f0100074:	ff 75 0c             	pushl  0xc(%ebp)
f0100077:	ff 75 08             	pushl  0x8(%ebp)
f010007a:	50                   	push   %eax
f010007b:	68 40 67 10 f0       	push   $0xf0106740
f0100080:	e8 aa 39 00 00       	call   f0103a2f <cprintf>
	vcprintf(fmt, ap);
f0100085:	83 c4 08             	add    $0x8,%esp
f0100088:	53                   	push   %ebx
f0100089:	56                   	push   %esi
f010008a:	e8 76 39 00 00       	call   f0103a05 <vcprintf>
	cprintf("\n");
f010008f:	c7 04 24 d6 6f 10 f0 	movl   $0xf0106fd6,(%esp)
f0100096:	e8 94 39 00 00       	call   f0103a2f <cprintf>
f010009b:	83 c4 10             	add    $0x10,%esp
f010009e:	eb b5                	jmp    f0100055 <_panic+0x15>

f01000a0 <i386_init>:
{
f01000a0:	f3 0f 1e fb          	endbr32 
f01000a4:	55                   	push   %ebp
f01000a5:	89 e5                	mov    %esp,%ebp
f01000a7:	53                   	push   %ebx
f01000a8:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000ab:	e8 95 05 00 00       	call   f0100645 <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000b0:	83 ec 08             	sub    $0x8,%esp
f01000b3:	68 ac 1a 00 00       	push   $0x1aac
f01000b8:	68 ac 67 10 f0       	push   $0xf01067ac
f01000bd:	e8 6d 39 00 00       	call   f0103a2f <cprintf>
	mem_init();
f01000c2:	e8 28 13 00 00       	call   f01013ef <mem_init>
	env_init();
f01000c7:	e8 46 31 00 00       	call   f0103212 <env_init>
	trap_init();
f01000cc:	e8 47 3a 00 00       	call   f0103b18 <trap_init>
	mp_init();
f01000d1:	e8 e5 5c 00 00       	call   f0105dbb <mp_init>
	lapic_init();
f01000d6:	e8 f9 5f 00 00       	call   f01060d4 <lapic_init>
	pic_init();
f01000db:	e8 64 38 00 00       	call   f0103944 <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000e0:	c7 04 24 c0 33 12 f0 	movl   $0xf01233c0,(%esp)
f01000e7:	e8 56 62 00 00       	call   f0106342 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000ec:	83 c4 10             	add    $0x10,%esp
f01000ef:	83 3d 88 7e 23 f0 07 	cmpl   $0x7,0xf0237e88
f01000f6:	76 27                	jbe    f010011f <i386_init+0x7f>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01000f8:	83 ec 04             	sub    $0x4,%esp
f01000fb:	b8 1e 5d 10 f0       	mov    $0xf0105d1e,%eax
f0100100:	2d a4 5c 10 f0       	sub    $0xf0105ca4,%eax
f0100105:	50                   	push   %eax
f0100106:	68 a4 5c 10 f0       	push   $0xf0105ca4
f010010b:	68 00 70 00 f0       	push   $0xf0007000
f0100110:	e8 d1 59 00 00       	call   f0105ae6 <memmove>
	for (c = cpus; c < cpus + ncpu; c++) {
f0100115:	83 c4 10             	add    $0x10,%esp
f0100118:	bb 20 80 23 f0       	mov    $0xf0238020,%ebx
f010011d:	eb 53                	jmp    f0100172 <i386_init+0xd2>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010011f:	68 00 70 00 00       	push   $0x7000
f0100124:	68 64 67 10 f0       	push   $0xf0106764
f0100129:	6a 50                	push   $0x50
f010012b:	68 c7 67 10 f0       	push   $0xf01067c7
f0100130:	e8 0b ff ff ff       	call   f0100040 <_panic>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100135:	89 d8                	mov    %ebx,%eax
f0100137:	2d 20 80 23 f0       	sub    $0xf0238020,%eax
f010013c:	c1 f8 02             	sar    $0x2,%eax
f010013f:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100145:	c1 e0 0f             	shl    $0xf,%eax
f0100148:	8d 80 00 10 24 f0    	lea    -0xfdbf000(%eax),%eax
f010014e:	a3 84 7e 23 f0       	mov    %eax,0xf0237e84
		lapic_startap(c->cpu_id, PADDR(code));
f0100153:	83 ec 08             	sub    $0x8,%esp
f0100156:	68 00 70 00 00       	push   $0x7000
f010015b:	0f b6 03             	movzbl (%ebx),%eax
f010015e:	50                   	push   %eax
f010015f:	e8 ca 60 00 00       	call   f010622e <lapic_startap>
		while(c->cpu_status != CPU_STARTED)
f0100164:	83 c4 10             	add    $0x10,%esp
f0100167:	8b 43 04             	mov    0x4(%ebx),%eax
f010016a:	83 f8 01             	cmp    $0x1,%eax
f010016d:	75 f8                	jne    f0100167 <i386_init+0xc7>
	for (c = cpus; c < cpus + ncpu; c++) {
f010016f:	83 c3 74             	add    $0x74,%ebx
f0100172:	6b 05 c4 83 23 f0 74 	imul   $0x74,0xf02383c4,%eax
f0100179:	05 20 80 23 f0       	add    $0xf0238020,%eax
f010017e:	39 c3                	cmp    %eax,%ebx
f0100180:	73 13                	jae    f0100195 <i386_init+0xf5>
		if (c == cpus + cpunum())  // We've started already.
f0100182:	e8 33 5f 00 00       	call   f01060ba <cpunum>
f0100187:	6b c0 74             	imul   $0x74,%eax,%eax
f010018a:	05 20 80 23 f0       	add    $0xf0238020,%eax
f010018f:	39 c3                	cmp    %eax,%ebx
f0100191:	74 dc                	je     f010016f <i386_init+0xcf>
f0100193:	eb a0                	jmp    f0100135 <i386_init+0x95>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f0100195:	83 ec 08             	sub    $0x8,%esp
f0100198:	6a 00                	push   $0x0
f010019a:	68 fc cb 22 f0       	push   $0xf022cbfc
f010019f:	e8 4c 32 00 00       	call   f01033f0 <env_create>
	sched_yield();
f01001a4:	e8 ae 46 00 00       	call   f0104857 <sched_yield>

f01001a9 <mp_main>:
{
f01001a9:	f3 0f 1e fb          	endbr32 
f01001ad:	55                   	push   %ebp
f01001ae:	89 e5                	mov    %esp,%ebp
f01001b0:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001b3:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01001b8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001bd:	76 52                	jbe    f0100211 <mp_main+0x68>
	return (physaddr_t)kva - KERNBASE;
f01001bf:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001c4:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001c7:	e8 ee 5e 00 00       	call   f01060ba <cpunum>
f01001cc:	83 ec 08             	sub    $0x8,%esp
f01001cf:	50                   	push   %eax
f01001d0:	68 d3 67 10 f0       	push   $0xf01067d3
f01001d5:	e8 55 38 00 00       	call   f0103a2f <cprintf>
	lapic_init();
f01001da:	e8 f5 5e 00 00       	call   f01060d4 <lapic_init>
	env_init_percpu();
f01001df:	e8 fe 2f 00 00       	call   f01031e2 <env_init_percpu>
	trap_init_percpu();
f01001e4:	e8 5e 38 00 00       	call   f0103a47 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01001e9:	e8 cc 5e 00 00       	call   f01060ba <cpunum>
f01001ee:	6b d0 74             	imul   $0x74,%eax,%edx
f01001f1:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f01001f4:	b8 01 00 00 00       	mov    $0x1,%eax
f01001f9:	f0 87 82 20 80 23 f0 	lock xchg %eax,-0xfdc7fe0(%edx)
f0100200:	c7 04 24 c0 33 12 f0 	movl   $0xf01233c0,(%esp)
f0100207:	e8 36 61 00 00       	call   f0106342 <spin_lock>
	sched_yield();
f010020c:	e8 46 46 00 00       	call   f0104857 <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100211:	50                   	push   %eax
f0100212:	68 88 67 10 f0       	push   $0xf0106788
f0100217:	6a 68                	push   $0x68
f0100219:	68 c7 67 10 f0       	push   $0xf01067c7
f010021e:	e8 1d fe ff ff       	call   f0100040 <_panic>

f0100223 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100223:	f3 0f 1e fb          	endbr32 
f0100227:	55                   	push   %ebp
f0100228:	89 e5                	mov    %esp,%ebp
f010022a:	53                   	push   %ebx
f010022b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f010022e:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100231:	ff 75 0c             	pushl  0xc(%ebp)
f0100234:	ff 75 08             	pushl  0x8(%ebp)
f0100237:	68 e9 67 10 f0       	push   $0xf01067e9
f010023c:	e8 ee 37 00 00       	call   f0103a2f <cprintf>
	vcprintf(fmt, ap);
f0100241:	83 c4 08             	add    $0x8,%esp
f0100244:	53                   	push   %ebx
f0100245:	ff 75 10             	pushl  0x10(%ebp)
f0100248:	e8 b8 37 00 00       	call   f0103a05 <vcprintf>
	cprintf("\n");
f010024d:	c7 04 24 d6 6f 10 f0 	movl   $0xf0106fd6,(%esp)
f0100254:	e8 d6 37 00 00       	call   f0103a2f <cprintf>
	va_end(ap);
}
f0100259:	83 c4 10             	add    $0x10,%esp
f010025c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010025f:	c9                   	leave  
f0100260:	c3                   	ret    

f0100261 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100261:	f3 0f 1e fb          	endbr32 
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100265:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010026a:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010026b:	a8 01                	test   $0x1,%al
f010026d:	74 0a                	je     f0100279 <serial_proc_data+0x18>
f010026f:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100274:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100275:	0f b6 c0             	movzbl %al,%eax
f0100278:	c3                   	ret    
		return -1;
f0100279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f010027e:	c3                   	ret    

f010027f <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010027f:	55                   	push   %ebp
f0100280:	89 e5                	mov    %esp,%ebp
f0100282:	53                   	push   %ebx
f0100283:	83 ec 04             	sub    $0x4,%esp
f0100286:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100288:	ff d3                	call   *%ebx
f010028a:	83 f8 ff             	cmp    $0xffffffff,%eax
f010028d:	74 29                	je     f01002b8 <cons_intr+0x39>
		if (c == 0)
f010028f:	85 c0                	test   %eax,%eax
f0100291:	74 f5                	je     f0100288 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f0100293:	8b 0d 24 72 23 f0    	mov    0xf0237224,%ecx
f0100299:	8d 51 01             	lea    0x1(%ecx),%edx
f010029c:	88 81 20 70 23 f0    	mov    %al,-0xfdc8fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002a2:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002a8:	b8 00 00 00 00       	mov    $0x0,%eax
f01002ad:	0f 44 d0             	cmove  %eax,%edx
f01002b0:	89 15 24 72 23 f0    	mov    %edx,0xf0237224
f01002b6:	eb d0                	jmp    f0100288 <cons_intr+0x9>
	}
}
f01002b8:	83 c4 04             	add    $0x4,%esp
f01002bb:	5b                   	pop    %ebx
f01002bc:	5d                   	pop    %ebp
f01002bd:	c3                   	ret    

f01002be <kbd_proc_data>:
{
f01002be:	f3 0f 1e fb          	endbr32 
f01002c2:	55                   	push   %ebp
f01002c3:	89 e5                	mov    %esp,%ebp
f01002c5:	53                   	push   %ebx
f01002c6:	83 ec 04             	sub    $0x4,%esp
f01002c9:	ba 64 00 00 00       	mov    $0x64,%edx
f01002ce:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002cf:	a8 01                	test   $0x1,%al
f01002d1:	0f 84 f2 00 00 00    	je     f01003c9 <kbd_proc_data+0x10b>
	if (stat & KBS_TERR)
f01002d7:	a8 20                	test   $0x20,%al
f01002d9:	0f 85 f1 00 00 00    	jne    f01003d0 <kbd_proc_data+0x112>
f01002df:	ba 60 00 00 00       	mov    $0x60,%edx
f01002e4:	ec                   	in     (%dx),%al
f01002e5:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002e7:	3c e0                	cmp    $0xe0,%al
f01002e9:	74 61                	je     f010034c <kbd_proc_data+0x8e>
	} else if (data & 0x80) {
f01002eb:	84 c0                	test   %al,%al
f01002ed:	78 70                	js     f010035f <kbd_proc_data+0xa1>
	} else if (shift & E0ESC) {
f01002ef:	8b 0d 00 70 23 f0    	mov    0xf0237000,%ecx
f01002f5:	f6 c1 40             	test   $0x40,%cl
f01002f8:	74 0e                	je     f0100308 <kbd_proc_data+0x4a>
		data |= 0x80;
f01002fa:	83 c8 80             	or     $0xffffff80,%eax
f01002fd:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01002ff:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100302:	89 0d 00 70 23 f0    	mov    %ecx,0xf0237000
	shift |= shiftcode[data];
f0100308:	0f b6 d2             	movzbl %dl,%edx
f010030b:	0f b6 82 60 69 10 f0 	movzbl -0xfef96a0(%edx),%eax
f0100312:	0b 05 00 70 23 f0    	or     0xf0237000,%eax
	shift ^= togglecode[data];
f0100318:	0f b6 8a 60 68 10 f0 	movzbl -0xfef97a0(%edx),%ecx
f010031f:	31 c8                	xor    %ecx,%eax
f0100321:	a3 00 70 23 f0       	mov    %eax,0xf0237000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100326:	89 c1                	mov    %eax,%ecx
f0100328:	83 e1 03             	and    $0x3,%ecx
f010032b:	8b 0c 8d 40 68 10 f0 	mov    -0xfef97c0(,%ecx,4),%ecx
f0100332:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100336:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100339:	a8 08                	test   $0x8,%al
f010033b:	74 61                	je     f010039e <kbd_proc_data+0xe0>
		if ('a' <= c && c <= 'z')
f010033d:	89 da                	mov    %ebx,%edx
f010033f:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100342:	83 f9 19             	cmp    $0x19,%ecx
f0100345:	77 4b                	ja     f0100392 <kbd_proc_data+0xd4>
			c += 'A' - 'a';
f0100347:	83 eb 20             	sub    $0x20,%ebx
f010034a:	eb 0c                	jmp    f0100358 <kbd_proc_data+0x9a>
		shift |= E0ESC;
f010034c:	83 0d 00 70 23 f0 40 	orl    $0x40,0xf0237000
		return 0;
f0100353:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100358:	89 d8                	mov    %ebx,%eax
f010035a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010035d:	c9                   	leave  
f010035e:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010035f:	8b 0d 00 70 23 f0    	mov    0xf0237000,%ecx
f0100365:	89 cb                	mov    %ecx,%ebx
f0100367:	83 e3 40             	and    $0x40,%ebx
f010036a:	83 e0 7f             	and    $0x7f,%eax
f010036d:	85 db                	test   %ebx,%ebx
f010036f:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100372:	0f b6 d2             	movzbl %dl,%edx
f0100375:	0f b6 82 60 69 10 f0 	movzbl -0xfef96a0(%edx),%eax
f010037c:	83 c8 40             	or     $0x40,%eax
f010037f:	0f b6 c0             	movzbl %al,%eax
f0100382:	f7 d0                	not    %eax
f0100384:	21 c8                	and    %ecx,%eax
f0100386:	a3 00 70 23 f0       	mov    %eax,0xf0237000
		return 0;
f010038b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100390:	eb c6                	jmp    f0100358 <kbd_proc_data+0x9a>
		else if ('A' <= c && c <= 'Z')
f0100392:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f0100395:	8d 4b 20             	lea    0x20(%ebx),%ecx
f0100398:	83 fa 1a             	cmp    $0x1a,%edx
f010039b:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010039e:	f7 d0                	not    %eax
f01003a0:	a8 06                	test   $0x6,%al
f01003a2:	75 b4                	jne    f0100358 <kbd_proc_data+0x9a>
f01003a4:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01003aa:	75 ac                	jne    f0100358 <kbd_proc_data+0x9a>
		cprintf("Rebooting!\n");
f01003ac:	83 ec 0c             	sub    $0xc,%esp
f01003af:	68 03 68 10 f0       	push   $0xf0106803
f01003b4:	e8 76 36 00 00       	call   f0103a2f <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003b9:	b8 03 00 00 00       	mov    $0x3,%eax
f01003be:	ba 92 00 00 00       	mov    $0x92,%edx
f01003c3:	ee                   	out    %al,(%dx)
}
f01003c4:	83 c4 10             	add    $0x10,%esp
f01003c7:	eb 8f                	jmp    f0100358 <kbd_proc_data+0x9a>
		return -1;
f01003c9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003ce:	eb 88                	jmp    f0100358 <kbd_proc_data+0x9a>
		return -1;
f01003d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003d5:	eb 81                	jmp    f0100358 <kbd_proc_data+0x9a>

f01003d7 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003d7:	55                   	push   %ebp
f01003d8:	89 e5                	mov    %esp,%ebp
f01003da:	57                   	push   %edi
f01003db:	56                   	push   %esi
f01003dc:	53                   	push   %ebx
f01003dd:	83 ec 1c             	sub    $0x1c,%esp
f01003e0:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f01003e2:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003e7:	bf fd 03 00 00       	mov    $0x3fd,%edi
f01003ec:	bb 84 00 00 00       	mov    $0x84,%ebx
f01003f1:	89 fa                	mov    %edi,%edx
f01003f3:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01003f4:	a8 20                	test   $0x20,%al
f01003f6:	75 13                	jne    f010040b <cons_putc+0x34>
f01003f8:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01003fe:	7f 0b                	jg     f010040b <cons_putc+0x34>
f0100400:	89 da                	mov    %ebx,%edx
f0100402:	ec                   	in     (%dx),%al
f0100403:	ec                   	in     (%dx),%al
f0100404:	ec                   	in     (%dx),%al
f0100405:	ec                   	in     (%dx),%al
	     i++)
f0100406:	83 c6 01             	add    $0x1,%esi
f0100409:	eb e6                	jmp    f01003f1 <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f010040b:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010040e:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100413:	89 c8                	mov    %ecx,%eax
f0100415:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100416:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010041b:	bf 79 03 00 00       	mov    $0x379,%edi
f0100420:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100425:	89 fa                	mov    %edi,%edx
f0100427:	ec                   	in     (%dx),%al
f0100428:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010042e:	7f 0f                	jg     f010043f <cons_putc+0x68>
f0100430:	84 c0                	test   %al,%al
f0100432:	78 0b                	js     f010043f <cons_putc+0x68>
f0100434:	89 da                	mov    %ebx,%edx
f0100436:	ec                   	in     (%dx),%al
f0100437:	ec                   	in     (%dx),%al
f0100438:	ec                   	in     (%dx),%al
f0100439:	ec                   	in     (%dx),%al
f010043a:	83 c6 01             	add    $0x1,%esi
f010043d:	eb e6                	jmp    f0100425 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010043f:	ba 78 03 00 00       	mov    $0x378,%edx
f0100444:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100448:	ee                   	out    %al,(%dx)
f0100449:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010044e:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100453:	ee                   	out    %al,(%dx)
f0100454:	b8 08 00 00 00       	mov    $0x8,%eax
f0100459:	ee                   	out    %al,(%dx)
		c |= 0x0700;
f010045a:	89 c8                	mov    %ecx,%eax
f010045c:	80 cc 07             	or     $0x7,%ah
f010045f:	f7 c1 00 ff ff ff    	test   $0xffffff00,%ecx
f0100465:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f0100468:	0f b6 c1             	movzbl %cl,%eax
f010046b:	80 f9 0a             	cmp    $0xa,%cl
f010046e:	0f 84 dd 00 00 00    	je     f0100551 <cons_putc+0x17a>
f0100474:	83 f8 0a             	cmp    $0xa,%eax
f0100477:	7f 46                	jg     f01004bf <cons_putc+0xe8>
f0100479:	83 f8 08             	cmp    $0x8,%eax
f010047c:	0f 84 a7 00 00 00    	je     f0100529 <cons_putc+0x152>
f0100482:	83 f8 09             	cmp    $0x9,%eax
f0100485:	0f 85 d3 00 00 00    	jne    f010055e <cons_putc+0x187>
		cons_putc(' ');
f010048b:	b8 20 00 00 00       	mov    $0x20,%eax
f0100490:	e8 42 ff ff ff       	call   f01003d7 <cons_putc>
		cons_putc(' ');
f0100495:	b8 20 00 00 00       	mov    $0x20,%eax
f010049a:	e8 38 ff ff ff       	call   f01003d7 <cons_putc>
		cons_putc(' ');
f010049f:	b8 20 00 00 00       	mov    $0x20,%eax
f01004a4:	e8 2e ff ff ff       	call   f01003d7 <cons_putc>
		cons_putc(' ');
f01004a9:	b8 20 00 00 00       	mov    $0x20,%eax
f01004ae:	e8 24 ff ff ff       	call   f01003d7 <cons_putc>
		cons_putc(' ');
f01004b3:	b8 20 00 00 00       	mov    $0x20,%eax
f01004b8:	e8 1a ff ff ff       	call   f01003d7 <cons_putc>
		break;
f01004bd:	eb 25                	jmp    f01004e4 <cons_putc+0x10d>
	switch (c & 0xff) {
f01004bf:	83 f8 0d             	cmp    $0xd,%eax
f01004c2:	0f 85 96 00 00 00    	jne    f010055e <cons_putc+0x187>
		crt_pos -= (crt_pos % CRT_COLS);
f01004c8:	0f b7 05 28 72 23 f0 	movzwl 0xf0237228,%eax
f01004cf:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004d5:	c1 e8 16             	shr    $0x16,%eax
f01004d8:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004db:	c1 e0 04             	shl    $0x4,%eax
f01004de:	66 a3 28 72 23 f0    	mov    %ax,0xf0237228
	if (crt_pos >= CRT_SIZE) {
f01004e4:	66 81 3d 28 72 23 f0 	cmpw   $0x7cf,0xf0237228
f01004eb:	cf 07 
f01004ed:	0f 87 8e 00 00 00    	ja     f0100581 <cons_putc+0x1aa>
	outb(addr_6845, 14);
f01004f3:	8b 0d 30 72 23 f0    	mov    0xf0237230,%ecx
f01004f9:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004fe:	89 ca                	mov    %ecx,%edx
f0100500:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100501:	0f b7 1d 28 72 23 f0 	movzwl 0xf0237228,%ebx
f0100508:	8d 71 01             	lea    0x1(%ecx),%esi
f010050b:	89 d8                	mov    %ebx,%eax
f010050d:	66 c1 e8 08          	shr    $0x8,%ax
f0100511:	89 f2                	mov    %esi,%edx
f0100513:	ee                   	out    %al,(%dx)
f0100514:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100519:	89 ca                	mov    %ecx,%edx
f010051b:	ee                   	out    %al,(%dx)
f010051c:	89 d8                	mov    %ebx,%eax
f010051e:	89 f2                	mov    %esi,%edx
f0100520:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100521:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100524:	5b                   	pop    %ebx
f0100525:	5e                   	pop    %esi
f0100526:	5f                   	pop    %edi
f0100527:	5d                   	pop    %ebp
f0100528:	c3                   	ret    
		if (crt_pos > 0) {
f0100529:	0f b7 05 28 72 23 f0 	movzwl 0xf0237228,%eax
f0100530:	66 85 c0             	test   %ax,%ax
f0100533:	74 be                	je     f01004f3 <cons_putc+0x11c>
			crt_pos--;
f0100535:	83 e8 01             	sub    $0x1,%eax
f0100538:	66 a3 28 72 23 f0    	mov    %ax,0xf0237228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f010053e:	0f b7 d0             	movzwl %ax,%edx
f0100541:	b1 00                	mov    $0x0,%cl
f0100543:	83 c9 20             	or     $0x20,%ecx
f0100546:	a1 2c 72 23 f0       	mov    0xf023722c,%eax
f010054b:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
f010054f:	eb 93                	jmp    f01004e4 <cons_putc+0x10d>
		crt_pos += CRT_COLS;
f0100551:	66 83 05 28 72 23 f0 	addw   $0x50,0xf0237228
f0100558:	50 
f0100559:	e9 6a ff ff ff       	jmp    f01004c8 <cons_putc+0xf1>
		crt_buf[crt_pos++] = c;		/* write the character */
f010055e:	0f b7 05 28 72 23 f0 	movzwl 0xf0237228,%eax
f0100565:	8d 50 01             	lea    0x1(%eax),%edx
f0100568:	66 89 15 28 72 23 f0 	mov    %dx,0xf0237228
f010056f:	0f b7 c0             	movzwl %ax,%eax
f0100572:	8b 15 2c 72 23 f0    	mov    0xf023722c,%edx
f0100578:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
		break;
f010057c:	e9 63 ff ff ff       	jmp    f01004e4 <cons_putc+0x10d>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100581:	a1 2c 72 23 f0       	mov    0xf023722c,%eax
f0100586:	83 ec 04             	sub    $0x4,%esp
f0100589:	68 00 0f 00 00       	push   $0xf00
f010058e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100594:	52                   	push   %edx
f0100595:	50                   	push   %eax
f0100596:	e8 4b 55 00 00       	call   f0105ae6 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f010059b:	8b 15 2c 72 23 f0    	mov    0xf023722c,%edx
f01005a1:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005a7:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005ad:	83 c4 10             	add    $0x10,%esp
f01005b0:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005b5:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005b8:	39 d0                	cmp    %edx,%eax
f01005ba:	75 f4                	jne    f01005b0 <cons_putc+0x1d9>
		crt_pos -= CRT_COLS;
f01005bc:	66 83 2d 28 72 23 f0 	subw   $0x50,0xf0237228
f01005c3:	50 
f01005c4:	e9 2a ff ff ff       	jmp    f01004f3 <cons_putc+0x11c>

f01005c9 <serial_intr>:
{
f01005c9:	f3 0f 1e fb          	endbr32 
	if (serial_exists)
f01005cd:	80 3d 34 72 23 f0 00 	cmpb   $0x0,0xf0237234
f01005d4:	75 01                	jne    f01005d7 <serial_intr+0xe>
f01005d6:	c3                   	ret    
{
f01005d7:	55                   	push   %ebp
f01005d8:	89 e5                	mov    %esp,%ebp
f01005da:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f01005dd:	b8 61 02 10 f0       	mov    $0xf0100261,%eax
f01005e2:	e8 98 fc ff ff       	call   f010027f <cons_intr>
}
f01005e7:	c9                   	leave  
f01005e8:	c3                   	ret    

f01005e9 <kbd_intr>:
{
f01005e9:	f3 0f 1e fb          	endbr32 
f01005ed:	55                   	push   %ebp
f01005ee:	89 e5                	mov    %esp,%ebp
f01005f0:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01005f3:	b8 be 02 10 f0       	mov    $0xf01002be,%eax
f01005f8:	e8 82 fc ff ff       	call   f010027f <cons_intr>
}
f01005fd:	c9                   	leave  
f01005fe:	c3                   	ret    

f01005ff <cons_getc>:
{
f01005ff:	f3 0f 1e fb          	endbr32 
f0100603:	55                   	push   %ebp
f0100604:	89 e5                	mov    %esp,%ebp
f0100606:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f0100609:	e8 bb ff ff ff       	call   f01005c9 <serial_intr>
	kbd_intr();
f010060e:	e8 d6 ff ff ff       	call   f01005e9 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100613:	a1 20 72 23 f0       	mov    0xf0237220,%eax
	return 0;
f0100618:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f010061d:	3b 05 24 72 23 f0    	cmp    0xf0237224,%eax
f0100623:	74 1c                	je     f0100641 <cons_getc+0x42>
		c = cons.buf[cons.rpos++];
f0100625:	8d 48 01             	lea    0x1(%eax),%ecx
f0100628:	0f b6 90 20 70 23 f0 	movzbl -0xfdc8fe0(%eax),%edx
			cons.rpos = 0;
f010062f:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f0100634:	b8 00 00 00 00       	mov    $0x0,%eax
f0100639:	0f 45 c1             	cmovne %ecx,%eax
f010063c:	a3 20 72 23 f0       	mov    %eax,0xf0237220
}
f0100641:	89 d0                	mov    %edx,%eax
f0100643:	c9                   	leave  
f0100644:	c3                   	ret    

f0100645 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100645:	f3 0f 1e fb          	endbr32 
f0100649:	55                   	push   %ebp
f010064a:	89 e5                	mov    %esp,%ebp
f010064c:	57                   	push   %edi
f010064d:	56                   	push   %esi
f010064e:	53                   	push   %ebx
f010064f:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100652:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f0100659:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100660:	5a a5 
	if (*cp != 0xA55A) {
f0100662:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f0100669:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010066d:	0f 84 d4 00 00 00    	je     f0100747 <cons_init+0x102>
		addr_6845 = MONO_BASE;
f0100673:	c7 05 30 72 23 f0 b4 	movl   $0x3b4,0xf0237230
f010067a:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010067d:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f0100682:	8b 3d 30 72 23 f0    	mov    0xf0237230,%edi
f0100688:	b8 0e 00 00 00       	mov    $0xe,%eax
f010068d:	89 fa                	mov    %edi,%edx
f010068f:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100690:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100693:	89 ca                	mov    %ecx,%edx
f0100695:	ec                   	in     (%dx),%al
f0100696:	0f b6 c0             	movzbl %al,%eax
f0100699:	c1 e0 08             	shl    $0x8,%eax
f010069c:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010069e:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006a3:	89 fa                	mov    %edi,%edx
f01006a5:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006a6:	89 ca                	mov    %ecx,%edx
f01006a8:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006a9:	89 35 2c 72 23 f0    	mov    %esi,0xf023722c
	pos |= inb(addr_6845 + 1);
f01006af:	0f b6 c0             	movzbl %al,%eax
f01006b2:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006b4:	66 a3 28 72 23 f0    	mov    %ax,0xf0237228
	kbd_intr();
f01006ba:	e8 2a ff ff ff       	call   f01005e9 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006bf:	83 ec 0c             	sub    $0xc,%esp
f01006c2:	0f b7 05 a8 33 12 f0 	movzwl 0xf01233a8,%eax
f01006c9:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006ce:	50                   	push   %eax
f01006cf:	e8 ee 31 00 00       	call   f01038c2 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006d4:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006d9:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01006de:	89 d8                	mov    %ebx,%eax
f01006e0:	89 ca                	mov    %ecx,%edx
f01006e2:	ee                   	out    %al,(%dx)
f01006e3:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01006e8:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f01006ed:	89 fa                	mov    %edi,%edx
f01006ef:	ee                   	out    %al,(%dx)
f01006f0:	b8 0c 00 00 00       	mov    $0xc,%eax
f01006f5:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006fa:	ee                   	out    %al,(%dx)
f01006fb:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100700:	89 d8                	mov    %ebx,%eax
f0100702:	89 f2                	mov    %esi,%edx
f0100704:	ee                   	out    %al,(%dx)
f0100705:	b8 03 00 00 00       	mov    $0x3,%eax
f010070a:	89 fa                	mov    %edi,%edx
f010070c:	ee                   	out    %al,(%dx)
f010070d:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100712:	89 d8                	mov    %ebx,%eax
f0100714:	ee                   	out    %al,(%dx)
f0100715:	b8 01 00 00 00       	mov    $0x1,%eax
f010071a:	89 f2                	mov    %esi,%edx
f010071c:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010071d:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100722:	ec                   	in     (%dx),%al
f0100723:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100725:	83 c4 10             	add    $0x10,%esp
f0100728:	3c ff                	cmp    $0xff,%al
f010072a:	0f 95 05 34 72 23 f0 	setne  0xf0237234
f0100731:	89 ca                	mov    %ecx,%edx
f0100733:	ec                   	in     (%dx),%al
f0100734:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100739:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f010073a:	80 fb ff             	cmp    $0xff,%bl
f010073d:	74 23                	je     f0100762 <cons_init+0x11d>
		cprintf("Serial port does not exist!\n");
}
f010073f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100742:	5b                   	pop    %ebx
f0100743:	5e                   	pop    %esi
f0100744:	5f                   	pop    %edi
f0100745:	5d                   	pop    %ebp
f0100746:	c3                   	ret    
		*cp = was;
f0100747:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010074e:	c7 05 30 72 23 f0 d4 	movl   $0x3d4,0xf0237230
f0100755:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100758:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010075d:	e9 20 ff ff ff       	jmp    f0100682 <cons_init+0x3d>
		cprintf("Serial port does not exist!\n");
f0100762:	83 ec 0c             	sub    $0xc,%esp
f0100765:	68 0f 68 10 f0       	push   $0xf010680f
f010076a:	e8 c0 32 00 00       	call   f0103a2f <cprintf>
f010076f:	83 c4 10             	add    $0x10,%esp
}
f0100772:	eb cb                	jmp    f010073f <cons_init+0xfa>

f0100774 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100774:	f3 0f 1e fb          	endbr32 
f0100778:	55                   	push   %ebp
f0100779:	89 e5                	mov    %esp,%ebp
f010077b:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f010077e:	8b 45 08             	mov    0x8(%ebp),%eax
f0100781:	e8 51 fc ff ff       	call   f01003d7 <cons_putc>
}
f0100786:	c9                   	leave  
f0100787:	c3                   	ret    

f0100788 <getchar>:

int
getchar(void)
{
f0100788:	f3 0f 1e fb          	endbr32 
f010078c:	55                   	push   %ebp
f010078d:	89 e5                	mov    %esp,%ebp
f010078f:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100792:	e8 68 fe ff ff       	call   f01005ff <cons_getc>
f0100797:	85 c0                	test   %eax,%eax
f0100799:	74 f7                	je     f0100792 <getchar+0xa>
		/* do nothing */;
	return c;
}
f010079b:	c9                   	leave  
f010079c:	c3                   	ret    

f010079d <iscons>:

int
iscons(int fdnum)
{
f010079d:	f3 0f 1e fb          	endbr32 
	// used by readline
	return 1;
}
f01007a1:	b8 01 00 00 00       	mov    $0x1,%eax
f01007a6:	c3                   	ret    

f01007a7 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007a7:	f3 0f 1e fb          	endbr32 
f01007ab:	55                   	push   %ebp
f01007ac:	89 e5                	mov    %esp,%ebp
f01007ae:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007b1:	68 60 6a 10 f0       	push   $0xf0106a60
f01007b6:	68 7e 6a 10 f0       	push   $0xf0106a7e
f01007bb:	68 83 6a 10 f0       	push   $0xf0106a83
f01007c0:	e8 6a 32 00 00       	call   f0103a2f <cprintf>
f01007c5:	83 c4 0c             	add    $0xc,%esp
f01007c8:	68 34 6b 10 f0       	push   $0xf0106b34
f01007cd:	68 8c 6a 10 f0       	push   $0xf0106a8c
f01007d2:	68 83 6a 10 f0       	push   $0xf0106a83
f01007d7:	e8 53 32 00 00       	call   f0103a2f <cprintf>
f01007dc:	83 c4 0c             	add    $0xc,%esp
f01007df:	68 5c 6b 10 f0       	push   $0xf0106b5c
f01007e4:	68 95 6a 10 f0       	push   $0xf0106a95
f01007e9:	68 83 6a 10 f0       	push   $0xf0106a83
f01007ee:	e8 3c 32 00 00       	call   f0103a2f <cprintf>
	return 0;
}
f01007f3:	b8 00 00 00 00       	mov    $0x0,%eax
f01007f8:	c9                   	leave  
f01007f9:	c3                   	ret    

f01007fa <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01007fa:	f3 0f 1e fb          	endbr32 
f01007fe:	55                   	push   %ebp
f01007ff:	89 e5                	mov    %esp,%ebp
f0100801:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100804:	68 9f 6a 10 f0       	push   $0xf0106a9f
f0100809:	e8 21 32 00 00       	call   f0103a2f <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f010080e:	83 c4 08             	add    $0x8,%esp
f0100811:	68 0c 00 10 00       	push   $0x10000c
f0100816:	68 84 6b 10 f0       	push   $0xf0106b84
f010081b:	e8 0f 32 00 00       	call   f0103a2f <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100820:	83 c4 0c             	add    $0xc,%esp
f0100823:	68 0c 00 10 00       	push   $0x10000c
f0100828:	68 0c 00 10 f0       	push   $0xf010000c
f010082d:	68 ac 6b 10 f0       	push   $0xf0106bac
f0100832:	e8 f8 31 00 00       	call   f0103a2f <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100837:	83 c4 0c             	add    $0xc,%esp
f010083a:	68 2d 67 10 00       	push   $0x10672d
f010083f:	68 2d 67 10 f0       	push   $0xf010672d
f0100844:	68 d0 6b 10 f0       	push   $0xf0106bd0
f0100849:	e8 e1 31 00 00       	call   f0103a2f <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010084e:	83 c4 0c             	add    $0xc,%esp
f0100851:	68 00 70 23 00       	push   $0x237000
f0100856:	68 00 70 23 f0       	push   $0xf0237000
f010085b:	68 f4 6b 10 f0       	push   $0xf0106bf4
f0100860:	e8 ca 31 00 00       	call   f0103a2f <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100865:	83 c4 0c             	add    $0xc,%esp
f0100868:	68 08 90 27 00       	push   $0x279008
f010086d:	68 08 90 27 f0       	push   $0xf0279008
f0100872:	68 18 6c 10 f0       	push   $0xf0106c18
f0100877:	e8 b3 31 00 00       	call   f0103a2f <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f010087c:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f010087f:	b8 08 90 27 f0       	mov    $0xf0279008,%eax
f0100884:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100889:	c1 f8 0a             	sar    $0xa,%eax
f010088c:	50                   	push   %eax
f010088d:	68 3c 6c 10 f0       	push   $0xf0106c3c
f0100892:	e8 98 31 00 00       	call   f0103a2f <cprintf>
	return 0;
}
f0100897:	b8 00 00 00 00       	mov    $0x0,%eax
f010089c:	c9                   	leave  
f010089d:	c3                   	ret    

f010089e <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f010089e:	f3 0f 1e fb          	endbr32 
f01008a2:	55                   	push   %ebp
f01008a3:	89 e5                	mov    %esp,%ebp
f01008a5:	57                   	push   %edi
f01008a6:	56                   	push   %esi
f01008a7:	53                   	push   %ebx
f01008a8:	83 ec 48             	sub    $0x48,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008ab:	89 ee                	mov    %ebp,%esi
	// Your code here.
	uint32_t* ebp = (uint32_t*) read_ebp();
	cprintf("Stack backtrace:\n");
f01008ad:	68 b8 6a 10 f0       	push   $0xf0106ab8
f01008b2:	e8 78 31 00 00       	call   f0103a2f <cprintf>
	while (ebp) {
f01008b7:	83 c4 10             	add    $0x10,%esp
f01008ba:	eb 41                	jmp    f01008fd <mon_backtrace+0x5f>
		uint32_t eip = ebp[1];
		cprintf("ebp %x  eip %x  args", ebp, eip);
		int i;
		for (i = 2; i <= 6; ++i)
			cprintf(" %08.x", ebp[i]);
		cprintf("\n");
f01008bc:	83 ec 0c             	sub    $0xc,%esp
f01008bf:	68 d6 6f 10 f0       	push   $0xf0106fd6
f01008c4:	e8 66 31 00 00       	call   f0103a2f <cprintf>
		struct Eipdebuginfo info;
		debuginfo_eip(eip, &info);
f01008c9:	83 c4 08             	add    $0x8,%esp
f01008cc:	8d 45 d0             	lea    -0x30(%ebp),%eax
f01008cf:	50                   	push   %eax
f01008d0:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f01008d3:	57                   	push   %edi
f01008d4:	e8 7c 46 00 00       	call   f0104f55 <debuginfo_eip>
		cprintf("\t%s:%d: %.*s+%d\n", 
f01008d9:	83 c4 08             	add    $0x8,%esp
f01008dc:	89 f8                	mov    %edi,%eax
f01008de:	2b 45 e0             	sub    -0x20(%ebp),%eax
f01008e1:	50                   	push   %eax
f01008e2:	ff 75 d8             	pushl  -0x28(%ebp)
f01008e5:	ff 75 dc             	pushl  -0x24(%ebp)
f01008e8:	ff 75 d4             	pushl  -0x2c(%ebp)
f01008eb:	ff 75 d0             	pushl  -0x30(%ebp)
f01008ee:	68 e6 6a 10 f0       	push   $0xf0106ae6
f01008f3:	e8 37 31 00 00       	call   f0103a2f <cprintf>
			info.eip_file, info.eip_line,
			info.eip_fn_namelen, info.eip_fn_name,
			eip-info.eip_fn_addr);
		ebp = (uint32_t*) *ebp;
f01008f8:	8b 36                	mov    (%esi),%esi
f01008fa:	83 c4 20             	add    $0x20,%esp
	while (ebp) {
f01008fd:	85 f6                	test   %esi,%esi
f01008ff:	74 39                	je     f010093a <mon_backtrace+0x9c>
		uint32_t eip = ebp[1];
f0100901:	8b 46 04             	mov    0x4(%esi),%eax
f0100904:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("ebp %x  eip %x  args", ebp, eip);
f0100907:	83 ec 04             	sub    $0x4,%esp
f010090a:	50                   	push   %eax
f010090b:	56                   	push   %esi
f010090c:	68 ca 6a 10 f0       	push   $0xf0106aca
f0100911:	e8 19 31 00 00       	call   f0103a2f <cprintf>
f0100916:	8d 5e 08             	lea    0x8(%esi),%ebx
f0100919:	8d 7e 1c             	lea    0x1c(%esi),%edi
f010091c:	83 c4 10             	add    $0x10,%esp
			cprintf(" %08.x", ebp[i]);
f010091f:	83 ec 08             	sub    $0x8,%esp
f0100922:	ff 33                	pushl  (%ebx)
f0100924:	68 df 6a 10 f0       	push   $0xf0106adf
f0100929:	e8 01 31 00 00       	call   f0103a2f <cprintf>
f010092e:	83 c3 04             	add    $0x4,%ebx
		for (i = 2; i <= 6; ++i)
f0100931:	83 c4 10             	add    $0x10,%esp
f0100934:	39 fb                	cmp    %edi,%ebx
f0100936:	75 e7                	jne    f010091f <mon_backtrace+0x81>
f0100938:	eb 82                	jmp    f01008bc <mon_backtrace+0x1e>
	}
	return 0;
}
f010093a:	b8 00 00 00 00       	mov    $0x0,%eax
f010093f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100942:	5b                   	pop    %ebx
f0100943:	5e                   	pop    %esi
f0100944:	5f                   	pop    %edi
f0100945:	5d                   	pop    %ebp
f0100946:	c3                   	ret    

f0100947 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100947:	f3 0f 1e fb          	endbr32 
f010094b:	55                   	push   %ebp
f010094c:	89 e5                	mov    %esp,%ebp
f010094e:	57                   	push   %edi
f010094f:	56                   	push   %esi
f0100950:	53                   	push   %ebx
f0100951:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100954:	68 68 6c 10 f0       	push   $0xf0106c68
f0100959:	e8 d1 30 00 00       	call   f0103a2f <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f010095e:	c7 04 24 8c 6c 10 f0 	movl   $0xf0106c8c,(%esp)
f0100965:	e8 c5 30 00 00       	call   f0103a2f <cprintf>

	if (tf != NULL)
f010096a:	83 c4 10             	add    $0x10,%esp
f010096d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100971:	0f 84 d9 00 00 00    	je     f0100a50 <monitor+0x109>
		print_trapframe(tf);
f0100977:	83 ec 0c             	sub    $0xc,%esp
f010097a:	ff 75 08             	pushl  0x8(%ebp)
f010097d:	e8 1a 38 00 00       	call   f010419c <print_trapframe>
f0100982:	83 c4 10             	add    $0x10,%esp
f0100985:	e9 c6 00 00 00       	jmp    f0100a50 <monitor+0x109>
		while (*buf && strchr(WHITESPACE, *buf))
f010098a:	83 ec 08             	sub    $0x8,%esp
f010098d:	0f be c0             	movsbl %al,%eax
f0100990:	50                   	push   %eax
f0100991:	68 fb 6a 10 f0       	push   $0xf0106afb
f0100996:	e8 ba 50 00 00       	call   f0105a55 <strchr>
f010099b:	83 c4 10             	add    $0x10,%esp
f010099e:	85 c0                	test   %eax,%eax
f01009a0:	74 63                	je     f0100a05 <monitor+0xbe>
			*buf++ = 0;
f01009a2:	c6 03 00             	movb   $0x0,(%ebx)
f01009a5:	89 f7                	mov    %esi,%edi
f01009a7:	8d 5b 01             	lea    0x1(%ebx),%ebx
f01009aa:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f01009ac:	0f b6 03             	movzbl (%ebx),%eax
f01009af:	84 c0                	test   %al,%al
f01009b1:	75 d7                	jne    f010098a <monitor+0x43>
	argv[argc] = 0;
f01009b3:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009ba:	00 
	if (argc == 0)
f01009bb:	85 f6                	test   %esi,%esi
f01009bd:	0f 84 8d 00 00 00    	je     f0100a50 <monitor+0x109>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009c3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f01009c8:	83 ec 08             	sub    $0x8,%esp
f01009cb:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01009ce:	ff 34 85 c0 6c 10 f0 	pushl  -0xfef9340(,%eax,4)
f01009d5:	ff 75 a8             	pushl  -0x58(%ebp)
f01009d8:	e8 12 50 00 00       	call   f01059ef <strcmp>
f01009dd:	83 c4 10             	add    $0x10,%esp
f01009e0:	85 c0                	test   %eax,%eax
f01009e2:	0f 84 8f 00 00 00    	je     f0100a77 <monitor+0x130>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009e8:	83 c3 01             	add    $0x1,%ebx
f01009eb:	83 fb 03             	cmp    $0x3,%ebx
f01009ee:	75 d8                	jne    f01009c8 <monitor+0x81>
	cprintf("Unknown command '%s'\n", argv[0]);
f01009f0:	83 ec 08             	sub    $0x8,%esp
f01009f3:	ff 75 a8             	pushl  -0x58(%ebp)
f01009f6:	68 1d 6b 10 f0       	push   $0xf0106b1d
f01009fb:	e8 2f 30 00 00       	call   f0103a2f <cprintf>
	return 0;
f0100a00:	83 c4 10             	add    $0x10,%esp
f0100a03:	eb 4b                	jmp    f0100a50 <monitor+0x109>
		if (*buf == 0)
f0100a05:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a08:	74 a9                	je     f01009b3 <monitor+0x6c>
		if (argc == MAXARGS-1) {
f0100a0a:	83 fe 0f             	cmp    $0xf,%esi
f0100a0d:	74 2f                	je     f0100a3e <monitor+0xf7>
		argv[argc++] = buf;
f0100a0f:	8d 7e 01             	lea    0x1(%esi),%edi
f0100a12:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a16:	0f b6 03             	movzbl (%ebx),%eax
f0100a19:	84 c0                	test   %al,%al
f0100a1b:	74 8d                	je     f01009aa <monitor+0x63>
f0100a1d:	83 ec 08             	sub    $0x8,%esp
f0100a20:	0f be c0             	movsbl %al,%eax
f0100a23:	50                   	push   %eax
f0100a24:	68 fb 6a 10 f0       	push   $0xf0106afb
f0100a29:	e8 27 50 00 00       	call   f0105a55 <strchr>
f0100a2e:	83 c4 10             	add    $0x10,%esp
f0100a31:	85 c0                	test   %eax,%eax
f0100a33:	0f 85 71 ff ff ff    	jne    f01009aa <monitor+0x63>
			buf++;
f0100a39:	83 c3 01             	add    $0x1,%ebx
f0100a3c:	eb d8                	jmp    f0100a16 <monitor+0xcf>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a3e:	83 ec 08             	sub    $0x8,%esp
f0100a41:	6a 10                	push   $0x10
f0100a43:	68 00 6b 10 f0       	push   $0xf0106b00
f0100a48:	e8 e2 2f 00 00       	call   f0103a2f <cprintf>
			return 0;
f0100a4d:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100a50:	83 ec 0c             	sub    $0xc,%esp
f0100a53:	68 f7 6a 10 f0       	push   $0xf0106af7
f0100a58:	e8 aa 4d 00 00       	call   f0105807 <readline>
f0100a5d:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100a5f:	83 c4 10             	add    $0x10,%esp
f0100a62:	85 c0                	test   %eax,%eax
f0100a64:	74 ea                	je     f0100a50 <monitor+0x109>
	argv[argc] = 0;
f0100a66:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100a6d:	be 00 00 00 00       	mov    $0x0,%esi
f0100a72:	e9 35 ff ff ff       	jmp    f01009ac <monitor+0x65>
			return commands[i].func(argc, argv, tf);
f0100a77:	83 ec 04             	sub    $0x4,%esp
f0100a7a:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a7d:	ff 75 08             	pushl  0x8(%ebp)
f0100a80:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100a83:	52                   	push   %edx
f0100a84:	56                   	push   %esi
f0100a85:	ff 14 85 c8 6c 10 f0 	call   *-0xfef9338(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100a8c:	83 c4 10             	add    $0x10,%esp
f0100a8f:	85 c0                	test   %eax,%eax
f0100a91:	79 bd                	jns    f0100a50 <monitor+0x109>
				break;
	}
f0100a93:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a96:	5b                   	pop    %ebx
f0100a97:	5e                   	pop    %esi
f0100a98:	5f                   	pop    %edi
f0100a99:	5d                   	pop    %ebp
f0100a9a:	c3                   	ret    

f0100a9b <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100a9b:	55                   	push   %ebp
f0100a9c:	89 e5                	mov    %esp,%ebp
f0100a9e:	53                   	push   %ebx
f0100a9f:	83 ec 04             	sub    $0x4,%esp
f0100aa2:	89 c3                	mov    %eax,%ebx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100aa4:	83 3d 38 72 23 f0 00 	cmpl   $0x0,0xf0237238
f0100aab:	74 1e                	je     f0100acb <boot_alloc+0x30>
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = nextfree;
f0100aad:	8b 15 38 72 23 f0    	mov    0xf0237238,%edx
	nextfree = ROUNDUP(result + n, PGSIZE);
f0100ab3:	8d 84 1a ff 0f 00 00 	lea    0xfff(%edx,%ebx,1),%eax
f0100aba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100abf:	a3 38 72 23 f0       	mov    %eax,0xf0237238

	// If we're out of memory, boot_alloc should panic.
	// 这部分目前没有思路

	return result;
}
f0100ac4:	89 d0                	mov    %edx,%eax
f0100ac6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100ac9:	c9                   	leave  
f0100aca:	c3                   	ret    
		cprintf(".bss end is %08x\n", end);
f0100acb:	83 ec 08             	sub    $0x8,%esp
f0100ace:	68 08 90 27 f0       	push   $0xf0279008
f0100ad3:	68 e4 6c 10 f0       	push   $0xf0106ce4
f0100ad8:	e8 52 2f 00 00       	call   f0103a2f <cprintf>
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100add:	b8 07 a0 27 f0       	mov    $0xf027a007,%eax
f0100ae2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ae7:	a3 38 72 23 f0       	mov    %eax,0xf0237238
f0100aec:	83 c4 10             	add    $0x10,%esp
f0100aef:	eb bc                	jmp    f0100aad <boot_alloc+0x12>

f0100af1 <nvram_read>:
{
f0100af1:	55                   	push   %ebp
f0100af2:	89 e5                	mov    %esp,%ebp
f0100af4:	56                   	push   %esi
f0100af5:	53                   	push   %ebx
f0100af6:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100af8:	83 ec 0c             	sub    $0xc,%esp
f0100afb:	50                   	push   %eax
f0100afc:	e8 8b 2d 00 00       	call   f010388c <mc146818_read>
f0100b01:	89 c6                	mov    %eax,%esi
f0100b03:	83 c3 01             	add    $0x1,%ebx
f0100b06:	89 1c 24             	mov    %ebx,(%esp)
f0100b09:	e8 7e 2d 00 00       	call   f010388c <mc146818_read>
f0100b0e:	c1 e0 08             	shl    $0x8,%eax
f0100b11:	09 f0                	or     %esi,%eax
}
f0100b13:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100b16:	5b                   	pop    %ebx
f0100b17:	5e                   	pop    %esi
f0100b18:	5d                   	pop    %ebp
f0100b19:	c3                   	ret    

f0100b1a <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100b1a:	89 d1                	mov    %edx,%ecx
f0100b1c:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100b1f:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100b22:	a8 01                	test   $0x1,%al
f0100b24:	74 51                	je     f0100b77 <check_va2pa+0x5d>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100b26:	89 c1                	mov    %eax,%ecx
f0100b28:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
	if (PGNUM(pa) >= npages)
f0100b2e:	c1 e8 0c             	shr    $0xc,%eax
f0100b31:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f0100b37:	73 23                	jae    f0100b5c <check_va2pa+0x42>
	if (!(p[PTX(va)] & PTE_P))
f0100b39:	c1 ea 0c             	shr    $0xc,%edx
f0100b3c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100b42:	8b 94 91 00 00 00 f0 	mov    -0x10000000(%ecx,%edx,4),%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100b49:	89 d0                	mov    %edx,%eax
f0100b4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b50:	f6 c2 01             	test   $0x1,%dl
f0100b53:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100b58:	0f 44 c2             	cmove  %edx,%eax
f0100b5b:	c3                   	ret    
{
f0100b5c:	55                   	push   %ebp
f0100b5d:	89 e5                	mov    %esp,%ebp
f0100b5f:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b62:	51                   	push   %ecx
f0100b63:	68 64 67 10 f0       	push   $0xf0106764
f0100b68:	68 ef 03 00 00       	push   $0x3ef
f0100b6d:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100b72:	e8 c9 f4 ff ff       	call   f0100040 <_panic>
		return ~0;
f0100b77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100b7c:	c3                   	ret    

f0100b7d <check_page_free_list>:
{
f0100b7d:	55                   	push   %ebp
f0100b7e:	89 e5                	mov    %esp,%ebp
f0100b80:	57                   	push   %edi
f0100b81:	56                   	push   %esi
f0100b82:	53                   	push   %ebx
f0100b83:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b86:	84 c0                	test   %al,%al
f0100b88:	0f 85 77 02 00 00    	jne    f0100e05 <check_page_free_list+0x288>
	if (!page_free_list)
f0100b8e:	83 3d 40 72 23 f0 00 	cmpl   $0x0,0xf0237240
f0100b95:	74 0a                	je     f0100ba1 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b97:	be 00 04 00 00       	mov    $0x400,%esi
f0100b9c:	e9 bf 02 00 00       	jmp    f0100e60 <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100ba1:	83 ec 04             	sub    $0x4,%esp
f0100ba4:	68 08 70 10 f0       	push   $0xf0107008
f0100ba9:	68 22 03 00 00       	push   $0x322
f0100bae:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100bb3:	e8 88 f4 ff ff       	call   f0100040 <_panic>
f0100bb8:	50                   	push   %eax
f0100bb9:	68 64 67 10 f0       	push   $0xf0106764
f0100bbe:	6a 58                	push   $0x58
f0100bc0:	68 02 6d 10 f0       	push   $0xf0106d02
f0100bc5:	e8 76 f4 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100bca:	8b 1b                	mov    (%ebx),%ebx
f0100bcc:	85 db                	test   %ebx,%ebx
f0100bce:	74 41                	je     f0100c11 <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100bd0:	89 d8                	mov    %ebx,%eax
f0100bd2:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0100bd8:	c1 f8 03             	sar    $0x3,%eax
f0100bdb:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100bde:	89 c2                	mov    %eax,%edx
f0100be0:	c1 ea 16             	shr    $0x16,%edx
f0100be3:	39 f2                	cmp    %esi,%edx
f0100be5:	73 e3                	jae    f0100bca <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100be7:	89 c2                	mov    %eax,%edx
f0100be9:	c1 ea 0c             	shr    $0xc,%edx
f0100bec:	3b 15 88 7e 23 f0    	cmp    0xf0237e88,%edx
f0100bf2:	73 c4                	jae    f0100bb8 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100bf4:	83 ec 04             	sub    $0x4,%esp
f0100bf7:	68 80 00 00 00       	push   $0x80
f0100bfc:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100c01:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100c06:	50                   	push   %eax
f0100c07:	e8 8e 4e 00 00       	call   f0105a9a <memset>
f0100c0c:	83 c4 10             	add    $0x10,%esp
f0100c0f:	eb b9                	jmp    f0100bca <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100c11:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c16:	e8 80 fe ff ff       	call   f0100a9b <boot_alloc>
f0100c1b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c1e:	8b 15 40 72 23 f0    	mov    0xf0237240,%edx
		assert(pp >= pages);
f0100c24:	8b 0d 90 7e 23 f0    	mov    0xf0237e90,%ecx
		assert(pp < pages + npages);
f0100c2a:	a1 88 7e 23 f0       	mov    0xf0237e88,%eax
f0100c2f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100c32:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100c35:	bf 00 00 00 00       	mov    $0x0,%edi
f0100c3a:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c3d:	e9 f9 00 00 00       	jmp    f0100d3b <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100c42:	68 10 6d 10 f0       	push   $0xf0106d10
f0100c47:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0100c4c:	68 3c 03 00 00       	push   $0x33c
f0100c51:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100c56:	e8 e5 f3 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100c5b:	68 31 6d 10 f0       	push   $0xf0106d31
f0100c60:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0100c65:	68 3d 03 00 00       	push   $0x33d
f0100c6a:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100c6f:	e8 cc f3 ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100c74:	68 2c 70 10 f0       	push   $0xf010702c
f0100c79:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0100c7e:	68 3e 03 00 00       	push   $0x33e
f0100c83:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100c88:	e8 b3 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100c8d:	68 45 6d 10 f0       	push   $0xf0106d45
f0100c92:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0100c97:	68 41 03 00 00       	push   $0x341
f0100c9c:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100ca1:	e8 9a f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100ca6:	68 56 6d 10 f0       	push   $0xf0106d56
f0100cab:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0100cb0:	68 42 03 00 00       	push   $0x342
f0100cb5:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100cba:	e8 81 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100cbf:	68 60 70 10 f0       	push   $0xf0107060
f0100cc4:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0100cc9:	68 43 03 00 00       	push   $0x343
f0100cce:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100cd3:	e8 68 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100cd8:	68 6f 6d 10 f0       	push   $0xf0106d6f
f0100cdd:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0100ce2:	68 44 03 00 00       	push   $0x344
f0100ce7:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100cec:	e8 4f f3 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100cf1:	89 c3                	mov    %eax,%ebx
f0100cf3:	c1 eb 0c             	shr    $0xc,%ebx
f0100cf6:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0100cf9:	76 0f                	jbe    f0100d0a <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f0100cfb:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d00:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0100d03:	77 17                	ja     f0100d1c <check_page_free_list+0x19f>
			++nfree_extmem;
f0100d05:	83 c7 01             	add    $0x1,%edi
f0100d08:	eb 2f                	jmp    f0100d39 <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d0a:	50                   	push   %eax
f0100d0b:	68 64 67 10 f0       	push   $0xf0106764
f0100d10:	6a 58                	push   $0x58
f0100d12:	68 02 6d 10 f0       	push   $0xf0106d02
f0100d17:	e8 24 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d1c:	68 84 70 10 f0       	push   $0xf0107084
f0100d21:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0100d26:	68 45 03 00 00       	push   $0x345
f0100d2b:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100d30:	e8 0b f3 ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f0100d35:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d39:	8b 12                	mov    (%edx),%edx
f0100d3b:	85 d2                	test   %edx,%edx
f0100d3d:	74 74                	je     f0100db3 <check_page_free_list+0x236>
		assert(pp >= pages);
f0100d3f:	39 d1                	cmp    %edx,%ecx
f0100d41:	0f 87 fb fe ff ff    	ja     f0100c42 <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f0100d47:	39 d6                	cmp    %edx,%esi
f0100d49:	0f 86 0c ff ff ff    	jbe    f0100c5b <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d4f:	89 d0                	mov    %edx,%eax
f0100d51:	29 c8                	sub    %ecx,%eax
f0100d53:	a8 07                	test   $0x7,%al
f0100d55:	0f 85 19 ff ff ff    	jne    f0100c74 <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f0100d5b:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100d5e:	c1 e0 0c             	shl    $0xc,%eax
f0100d61:	0f 84 26 ff ff ff    	je     f0100c8d <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d67:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100d6c:	0f 84 34 ff ff ff    	je     f0100ca6 <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d72:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100d77:	0f 84 42 ff ff ff    	je     f0100cbf <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d7d:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100d82:	0f 84 50 ff ff ff    	je     f0100cd8 <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d88:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100d8d:	0f 87 5e ff ff ff    	ja     f0100cf1 <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100d93:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100d98:	75 9b                	jne    f0100d35 <check_page_free_list+0x1b8>
f0100d9a:	68 89 6d 10 f0       	push   $0xf0106d89
f0100d9f:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0100da4:	68 47 03 00 00       	push   $0x347
f0100da9:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100dae:	e8 8d f2 ff ff       	call   f0100040 <_panic>
f0100db3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f0100db6:	85 db                	test   %ebx,%ebx
f0100db8:	7e 19                	jle    f0100dd3 <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f0100dba:	85 ff                	test   %edi,%edi
f0100dbc:	7e 2e                	jle    f0100dec <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0100dbe:	83 ec 0c             	sub    $0xc,%esp
f0100dc1:	68 cc 70 10 f0       	push   $0xf01070cc
f0100dc6:	e8 64 2c 00 00       	call   f0103a2f <cprintf>
}
f0100dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100dce:	5b                   	pop    %ebx
f0100dcf:	5e                   	pop    %esi
f0100dd0:	5f                   	pop    %edi
f0100dd1:	5d                   	pop    %ebp
f0100dd2:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100dd3:	68 a6 6d 10 f0       	push   $0xf0106da6
f0100dd8:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0100ddd:	68 4f 03 00 00       	push   $0x34f
f0100de2:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100de7:	e8 54 f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100dec:	68 b8 6d 10 f0       	push   $0xf0106db8
f0100df1:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0100df6:	68 50 03 00 00       	push   $0x350
f0100dfb:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100e00:	e8 3b f2 ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f0100e05:	a1 40 72 23 f0       	mov    0xf0237240,%eax
f0100e0a:	85 c0                	test   %eax,%eax
f0100e0c:	0f 84 8f fd ff ff    	je     f0100ba1 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100e12:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100e15:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100e18:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100e1b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100e1e:	89 c2                	mov    %eax,%edx
f0100e20:	2b 15 90 7e 23 f0    	sub    0xf0237e90,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100e26:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100e2c:	0f 95 c2             	setne  %dl
f0100e2f:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100e32:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100e36:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100e38:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e3c:	8b 00                	mov    (%eax),%eax
f0100e3e:	85 c0                	test   %eax,%eax
f0100e40:	75 dc                	jne    f0100e1e <check_page_free_list+0x2a1>
		*tp[1] = 0;
f0100e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100e4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100e4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e51:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100e53:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e56:	a3 40 72 23 f0       	mov    %eax,0xf0237240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100e5b:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100e60:	8b 1d 40 72 23 f0    	mov    0xf0237240,%ebx
f0100e66:	e9 61 fd ff ff       	jmp    f0100bcc <check_page_free_list+0x4f>

f0100e6b <page_init>:
{
f0100e6b:	f3 0f 1e fb          	endbr32 
f0100e6f:	55                   	push   %ebp
f0100e70:	89 e5                	mov    %esp,%ebp
f0100e72:	57                   	push   %edi
f0100e73:	56                   	push   %esi
f0100e74:	53                   	push   %ebx
f0100e75:	83 ec 0c             	sub    $0xc,%esp
	pages[0].pp_ref = 1;
f0100e78:	a1 90 7e 23 f0       	mov    0xf0237e90,%eax
f0100e7d:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	pages[0].pp_link = NULL;
f0100e83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 1; i < npages_basemem; i++) {
f0100e89:	8b 35 44 72 23 f0    	mov    0xf0237244,%esi
f0100e8f:	8b 1d 40 72 23 f0    	mov    0xf0237240,%ebx
f0100e95:	ba 00 00 00 00       	mov    $0x0,%edx
f0100e9a:	b8 01 00 00 00       	mov    $0x1,%eax
		page_free_list = &pages[i];
f0100e9f:	bf 01 00 00 00       	mov    $0x1,%edi
	for (i = 1; i < npages_basemem; i++) {
f0100ea4:	eb 03                	jmp    f0100ea9 <page_init+0x3e>
f0100ea6:	83 c0 01             	add    $0x1,%eax
f0100ea9:	39 c6                	cmp    %eax,%esi
f0100eab:	76 28                	jbe    f0100ed5 <page_init+0x6a>
		if(i == mpentry_index) continue;
f0100ead:	83 f8 07             	cmp    $0x7,%eax
f0100eb0:	74 f4                	je     f0100ea6 <page_init+0x3b>
f0100eb2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100eb9:	89 d1                	mov    %edx,%ecx
f0100ebb:	03 0d 90 7e 23 f0    	add    0xf0237e90,%ecx
f0100ec1:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100ec7:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0100ec9:	89 d3                	mov    %edx,%ebx
f0100ecb:	03 1d 90 7e 23 f0    	add    0xf0237e90,%ebx
f0100ed1:	89 fa                	mov    %edi,%edx
f0100ed3:	eb d1                	jmp    f0100ea6 <page_init+0x3b>
f0100ed5:	84 d2                	test   %dl,%dl
f0100ed7:	74 06                	je     f0100edf <page_init+0x74>
f0100ed9:	89 1d 40 72 23 f0    	mov    %ebx,0xf0237240
	for(i = io; i < ex; i++){
f0100edf:	b8 a0 00 00 00       	mov    $0xa0,%eax
		pages[i].pp_ref = 1;
f0100ee4:	8b 15 90 7e 23 f0    	mov    0xf0237e90,%edx
f0100eea:	8d 14 c2             	lea    (%edx,%eax,8),%edx
f0100eed:	66 c7 42 04 01 00    	movw   $0x1,0x4(%edx)
		pages[i].pp_link = NULL;
f0100ef3:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	for(i = io; i < ex; i++){
f0100ef9:	83 c0 01             	add    $0x1,%eax
f0100efc:	3d ff 00 00 00       	cmp    $0xff,%eax
f0100f01:	77 07                	ja     f0100f0a <page_init+0x9f>
		if(i == mpentry_index) continue;
f0100f03:	83 f8 07             	cmp    $0x7,%eax
f0100f06:	75 dc                	jne    f0100ee4 <page_init+0x79>
f0100f08:	eb ef                	jmp    f0100ef9 <page_init+0x8e>
	size_t fisrt_page = PADDR(boot_alloc(0)) / PGSIZE;
f0100f0a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f0f:	e8 87 fb ff ff       	call   f0100a9b <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100f14:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100f19:	76 0f                	jbe    f0100f2a <page_init+0xbf>
	return (physaddr_t)kva - KERNBASE;
f0100f1b:	05 00 00 00 10       	add    $0x10000000,%eax
f0100f20:	c1 e8 0c             	shr    $0xc,%eax
	for(i = ex; i < fisrt_page; i++){
f0100f23:	ba 00 01 00 00       	mov    $0x100,%edx
f0100f28:	eb 18                	jmp    f0100f42 <page_init+0xd7>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100f2a:	50                   	push   %eax
f0100f2b:	68 88 67 10 f0       	push   $0xf0106788
f0100f30:	68 6e 01 00 00       	push   $0x16e
f0100f35:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0100f3a:	e8 01 f1 ff ff       	call   f0100040 <_panic>
f0100f3f:	83 c2 01             	add    $0x1,%edx
f0100f42:	39 c2                	cmp    %eax,%edx
f0100f44:	73 1c                	jae    f0100f62 <page_init+0xf7>
		if(i == mpentry_index) continue;
f0100f46:	83 fa 07             	cmp    $0x7,%edx
f0100f49:	74 f4                	je     f0100f3f <page_init+0xd4>
		pages[i].pp_ref = 1;
f0100f4b:	8b 0d 90 7e 23 f0    	mov    0xf0237e90,%ecx
f0100f51:	8d 0c d1             	lea    (%ecx,%edx,8),%ecx
f0100f54:	66 c7 41 04 01 00    	movw   $0x1,0x4(%ecx)
		pages[i].pp_link = NULL;
f0100f5a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f0100f60:	eb dd                	jmp    f0100f3f <page_init+0xd4>
f0100f62:	8b 1d 40 72 23 f0    	mov    0xf0237240,%ebx
	for(i = ex; i < fisrt_page; i++){
f0100f68:	ba 00 00 00 00       	mov    $0x0,%edx
		page_free_list = &pages[i];
f0100f6d:	be 01 00 00 00       	mov    $0x1,%esi
f0100f72:	eb 24                	jmp    f0100f98 <page_init+0x12d>
f0100f74:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100f7b:	89 d1                	mov    %edx,%ecx
f0100f7d:	03 0d 90 7e 23 f0    	add    0xf0237e90,%ecx
f0100f83:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100f89:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0100f8b:	89 d3                	mov    %edx,%ebx
f0100f8d:	03 1d 90 7e 23 f0    	add    0xf0237e90,%ebx
f0100f93:	89 f2                	mov    %esi,%edx
	for(i = fisrt_page; i < npages; i++){
f0100f95:	83 c0 01             	add    $0x1,%eax
f0100f98:	39 05 88 7e 23 f0    	cmp    %eax,0xf0237e88
f0100f9e:	76 07                	jbe    f0100fa7 <page_init+0x13c>
		if(i == mpentry_index) continue;
f0100fa0:	83 f8 07             	cmp    $0x7,%eax
f0100fa3:	75 cf                	jne    f0100f74 <page_init+0x109>
f0100fa5:	eb ee                	jmp    f0100f95 <page_init+0x12a>
f0100fa7:	84 d2                	test   %dl,%dl
f0100fa9:	74 06                	je     f0100fb1 <page_init+0x146>
f0100fab:	89 1d 40 72 23 f0    	mov    %ebx,0xf0237240
}
f0100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100fb4:	5b                   	pop    %ebx
f0100fb5:	5e                   	pop    %esi
f0100fb6:	5f                   	pop    %edi
f0100fb7:	5d                   	pop    %ebp
f0100fb8:	c3                   	ret    

f0100fb9 <page_alloc>:
{
f0100fb9:	f3 0f 1e fb          	endbr32 
f0100fbd:	55                   	push   %ebp
f0100fbe:	89 e5                	mov    %esp,%ebp
f0100fc0:	53                   	push   %ebx
f0100fc1:	83 ec 04             	sub    $0x4,%esp
	if(!page_free_list) {
f0100fc4:	8b 1d 40 72 23 f0    	mov    0xf0237240,%ebx
f0100fca:	85 db                	test   %ebx,%ebx
f0100fcc:	74 1a                	je     f0100fe8 <page_alloc+0x2f>
	page_free_list = page_free_list->pp_link;
f0100fce:	8b 03                	mov    (%ebx),%eax
f0100fd0:	a3 40 72 23 f0       	mov    %eax,0xf0237240
	pp->pp_link = NULL;
f0100fd5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags && ALLOC_ZERO){
f0100fdb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100fdf:	75 19                	jne    f0100ffa <page_alloc+0x41>
}
f0100fe1:	89 d8                	mov    %ebx,%eax
f0100fe3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100fe6:	c9                   	leave  
f0100fe7:	c3                   	ret    
		cprintf("page_alloc: out of free memory\n");
f0100fe8:	83 ec 0c             	sub    $0xc,%esp
f0100feb:	68 f0 70 10 f0       	push   $0xf01070f0
f0100ff0:	e8 3a 2a 00 00       	call   f0103a2f <cprintf>
		return NULL;
f0100ff5:	83 c4 10             	add    $0x10,%esp
f0100ff8:	eb e7                	jmp    f0100fe1 <page_alloc+0x28>
	return (pp - pages) << PGSHIFT;
f0100ffa:	89 d8                	mov    %ebx,%eax
f0100ffc:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0101002:	c1 f8 03             	sar    $0x3,%eax
f0101005:	89 c2                	mov    %eax,%edx
f0101007:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010100a:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010100f:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f0101015:	73 1b                	jae    f0101032 <page_alloc+0x79>
		memset(page2kva(pp), '\0', PGSIZE);
f0101017:	83 ec 04             	sub    $0x4,%esp
f010101a:	68 00 10 00 00       	push   $0x1000
f010101f:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101021:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101027:	52                   	push   %edx
f0101028:	e8 6d 4a 00 00       	call   f0105a9a <memset>
f010102d:	83 c4 10             	add    $0x10,%esp
f0101030:	eb af                	jmp    f0100fe1 <page_alloc+0x28>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101032:	52                   	push   %edx
f0101033:	68 64 67 10 f0       	push   $0xf0106764
f0101038:	6a 58                	push   $0x58
f010103a:	68 02 6d 10 f0       	push   $0xf0106d02
f010103f:	e8 fc ef ff ff       	call   f0100040 <_panic>

f0101044 <page_free>:
{
f0101044:	f3 0f 1e fb          	endbr32 
f0101048:	55                   	push   %ebp
f0101049:	89 e5                	mov    %esp,%ebp
f010104b:	83 ec 08             	sub    $0x8,%esp
f010104e:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0){
f0101051:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101056:	75 14                	jne    f010106c <page_free+0x28>
	}else if(pp->pp_link != NULL){
f0101058:	83 38 00             	cmpl   $0x0,(%eax)
f010105b:	75 26                	jne    f0101083 <page_free+0x3f>
		pp->pp_link = page_free_list;
f010105d:	8b 15 40 72 23 f0    	mov    0xf0237240,%edx
f0101063:	89 10                	mov    %edx,(%eax)
		page_free_list = pp;
f0101065:	a3 40 72 23 f0       	mov    %eax,0xf0237240
}
f010106a:	c9                   	leave  
f010106b:	c3                   	ret    
		panic("page_free: pp->pp_ref is nonzero\n");
f010106c:	83 ec 04             	sub    $0x4,%esp
f010106f:	68 10 71 10 f0       	push   $0xf0107110
f0101074:	68 a8 01 00 00       	push   $0x1a8
f0101079:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010107e:	e8 bd ef ff ff       	call   f0100040 <_panic>
		panic("page_free: pp->pp_link is NULL\n");
f0101083:	83 ec 04             	sub    $0x4,%esp
f0101086:	68 34 71 10 f0       	push   $0xf0107134
f010108b:	68 aa 01 00 00       	push   $0x1aa
f0101090:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101095:	e8 a6 ef ff ff       	call   f0100040 <_panic>

f010109a <page_decref>:
{
f010109a:	f3 0f 1e fb          	endbr32 
f010109e:	55                   	push   %ebp
f010109f:	89 e5                	mov    %esp,%ebp
f01010a1:	83 ec 08             	sub    $0x8,%esp
f01010a4:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f01010a7:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01010ab:	83 e8 01             	sub    $0x1,%eax
f01010ae:	66 89 42 04          	mov    %ax,0x4(%edx)
f01010b2:	66 85 c0             	test   %ax,%ax
f01010b5:	74 02                	je     f01010b9 <page_decref+0x1f>
}
f01010b7:	c9                   	leave  
f01010b8:	c3                   	ret    
		page_free(pp);
f01010b9:	83 ec 0c             	sub    $0xc,%esp
f01010bc:	52                   	push   %edx
f01010bd:	e8 82 ff ff ff       	call   f0101044 <page_free>
f01010c2:	83 c4 10             	add    $0x10,%esp
}
f01010c5:	eb f0                	jmp    f01010b7 <page_decref+0x1d>

f01010c7 <pgdir_walk>:
{
f01010c7:	f3 0f 1e fb          	endbr32 
f01010cb:	55                   	push   %ebp
f01010cc:	89 e5                	mov    %esp,%ebp
f01010ce:	56                   	push   %esi
f01010cf:	53                   	push   %ebx
f01010d0:	8b 45 0c             	mov    0xc(%ebp),%eax
	uint32_t ptx = PTX(va);		//页表项索引
f01010d3:	89 c6                	mov    %eax,%esi
f01010d5:	c1 ee 0c             	shr    $0xc,%esi
f01010d8:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	uint32_t pdx = PDX(va);		//页目录项索引
f01010de:	c1 e8 16             	shr    $0x16,%eax
	pde = &pgdir[pdx];			//获取页目录项
f01010e1:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
f01010e8:	03 5d 08             	add    0x8(%ebp),%ebx
	if((*pde) & PTE_P){
f01010eb:	8b 03                	mov    (%ebx),%eax
f01010ed:	a8 01                	test   $0x1,%al
f01010ef:	74 38                	je     f0101129 <pgdir_walk+0x62>
		pte = (KADDR(PTE_ADDR(*pde)));
f01010f1:	89 c2                	mov    %eax,%edx
f01010f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f01010f9:	c1 e8 0c             	shr    $0xc,%eax
f01010fc:	39 05 88 7e 23 f0    	cmp    %eax,0xf0237e88
f0101102:	76 10                	jbe    f0101114 <pgdir_walk+0x4d>
	return (void *)(pa + KERNBASE);
f0101104:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	return (pte_t*)&pte[ptx];
f010110a:	8d 04 b0             	lea    (%eax,%esi,4),%eax
}
f010110d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101110:	5b                   	pop    %ebx
f0101111:	5e                   	pop    %esi
f0101112:	5d                   	pop    %ebp
f0101113:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101114:	52                   	push   %edx
f0101115:	68 64 67 10 f0       	push   $0xf0106764
f010111a:	68 e4 01 00 00       	push   $0x1e4
f010111f:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101124:	e8 17 ef ff ff       	call   f0100040 <_panic>
		if(!create){
f0101129:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010112d:	74 6f                	je     f010119e <pgdir_walk+0xd7>
		if(!(pp = page_alloc(ALLOC_ZERO))){
f010112f:	83 ec 0c             	sub    $0xc,%esp
f0101132:	6a 01                	push   $0x1
f0101134:	e8 80 fe ff ff       	call   f0100fb9 <page_alloc>
f0101139:	83 c4 10             	add    $0x10,%esp
f010113c:	85 c0                	test   %eax,%eax
f010113e:	74 cd                	je     f010110d <pgdir_walk+0x46>
		pp->pp_ref++;
f0101140:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101145:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f010114b:	c1 f8 03             	sar    $0x3,%eax
f010114e:	89 c2                	mov    %eax,%edx
f0101150:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101153:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101158:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f010115e:	73 17                	jae    f0101177 <pgdir_walk+0xb0>
	return (void *)(pa + KERNBASE);
f0101160:	8d 8a 00 00 00 f0    	lea    -0x10000000(%edx),%ecx
f0101166:	89 c8                	mov    %ecx,%eax
	if ((uint32_t)kva < KERNBASE)
f0101168:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f010116e:	76 19                	jbe    f0101189 <pgdir_walk+0xc2>
		*pde = PADDR(pte) | PTE_P | PTE_W | PTE_U;
f0101170:	83 ca 07             	or     $0x7,%edx
f0101173:	89 13                	mov    %edx,(%ebx)
f0101175:	eb 93                	jmp    f010110a <pgdir_walk+0x43>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101177:	52                   	push   %edx
f0101178:	68 64 67 10 f0       	push   $0xf0106764
f010117d:	6a 58                	push   $0x58
f010117f:	68 02 6d 10 f0       	push   $0xf0106d02
f0101184:	e8 b7 ee ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101189:	51                   	push   %ecx
f010118a:	68 88 67 10 f0       	push   $0xf0106788
f010118f:	68 f5 01 00 00       	push   $0x1f5
f0101194:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101199:	e8 a2 ee ff ff       	call   f0100040 <_panic>
			return NULL;
f010119e:	b8 00 00 00 00       	mov    $0x0,%eax
f01011a3:	e9 65 ff ff ff       	jmp    f010110d <pgdir_walk+0x46>

f01011a8 <boot_map_region>:
{
f01011a8:	55                   	push   %ebp
f01011a9:	89 e5                	mov    %esp,%ebp
f01011ab:	57                   	push   %edi
f01011ac:	56                   	push   %esi
f01011ad:	53                   	push   %ebx
f01011ae:	83 ec 1c             	sub    $0x1c,%esp
f01011b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01011b4:	8b 45 08             	mov    0x8(%ebp),%eax
	size_t pgs = (size + PGSIZE - 1) / PGSIZE;
f01011b7:	8d b1 ff 0f 00 00    	lea    0xfff(%ecx),%esi
f01011bd:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f01011c3:	01 c6                	add    %eax,%esi
	for(size_t i = 0; i < pgs; i++){
f01011c5:	89 c3                	mov    %eax,%ebx
		pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
f01011c7:	89 d7                	mov    %edx,%edi
f01011c9:	29 c7                	sub    %eax,%edi
	for(size_t i = 0; i < pgs; i++){
f01011cb:	39 f3                	cmp    %esi,%ebx
f01011cd:	74 28                	je     f01011f7 <boot_map_region+0x4f>
		pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
f01011cf:	83 ec 04             	sub    $0x4,%esp
f01011d2:	6a 01                	push   $0x1
f01011d4:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
f01011d7:	50                   	push   %eax
f01011d8:	ff 75 e4             	pushl  -0x1c(%ebp)
f01011db:	e8 e7 fe ff ff       	call   f01010c7 <pgdir_walk>
f01011e0:	89 c2                	mov    %eax,%edx
		*pte = pa | PTE_P | perm;
f01011e2:	89 d8                	mov    %ebx,%eax
f01011e4:	0b 45 0c             	or     0xc(%ebp),%eax
f01011e7:	83 c8 01             	or     $0x1,%eax
f01011ea:	89 02                	mov    %eax,(%edx)
		pa += PGSIZE;
f01011ec:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01011f2:	83 c4 10             	add    $0x10,%esp
f01011f5:	eb d4                	jmp    f01011cb <boot_map_region+0x23>
}
f01011f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011fa:	5b                   	pop    %ebx
f01011fb:	5e                   	pop    %esi
f01011fc:	5f                   	pop    %edi
f01011fd:	5d                   	pop    %ebp
f01011fe:	c3                   	ret    

f01011ff <page_lookup>:
{
f01011ff:	f3 0f 1e fb          	endbr32 
f0101203:	55                   	push   %ebp
f0101204:	89 e5                	mov    %esp,%ebp
f0101206:	53                   	push   %ebx
f0101207:	83 ec 08             	sub    $0x8,%esp
f010120a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t* pte = pgdir_walk(pgdir, va, false);
f010120d:	6a 00                	push   $0x0
f010120f:	ff 75 0c             	pushl  0xc(%ebp)
f0101212:	ff 75 08             	pushl  0x8(%ebp)
f0101215:	e8 ad fe ff ff       	call   f01010c7 <pgdir_walk>
	if(!pte || !((*pte) & PTE_P)){
f010121a:	83 c4 10             	add    $0x10,%esp
f010121d:	85 c0                	test   %eax,%eax
f010121f:	74 26                	je     f0101247 <page_lookup+0x48>
f0101221:	f6 00 01             	testb  $0x1,(%eax)
f0101224:	74 21                	je     f0101247 <page_lookup+0x48>
	if(pte_store != NULL){
f0101226:	85 db                	test   %ebx,%ebx
f0101228:	74 02                	je     f010122c <page_lookup+0x2d>
		*pte_store = pte;
f010122a:	89 03                	mov    %eax,(%ebx)
f010122c:	8b 00                	mov    (%eax),%eax
f010122e:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101231:	39 05 88 7e 23 f0    	cmp    %eax,0xf0237e88
f0101237:	76 25                	jbe    f010125e <page_lookup+0x5f>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101239:	8b 15 90 7e 23 f0    	mov    0xf0237e90,%edx
f010123f:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101245:	c9                   	leave  
f0101246:	c3                   	ret    
		cprintf("page_lookup: can not find out the page mapped at virtual address 'va'.\n");
f0101247:	83 ec 0c             	sub    $0xc,%esp
f010124a:	68 54 71 10 f0       	push   $0xf0107154
f010124f:	e8 db 27 00 00       	call   f0103a2f <cprintf>
		return NULL;
f0101254:	83 c4 10             	add    $0x10,%esp
f0101257:	b8 00 00 00 00       	mov    $0x0,%eax
f010125c:	eb e4                	jmp    f0101242 <page_lookup+0x43>
		panic("pa2page called with invalid pa");
f010125e:	83 ec 04             	sub    $0x4,%esp
f0101261:	68 9c 71 10 f0       	push   $0xf010719c
f0101266:	6a 51                	push   $0x51
f0101268:	68 02 6d 10 f0       	push   $0xf0106d02
f010126d:	e8 ce ed ff ff       	call   f0100040 <_panic>

f0101272 <tlb_invalidate>:
{
f0101272:	f3 0f 1e fb          	endbr32 
f0101276:	55                   	push   %ebp
f0101277:	89 e5                	mov    %esp,%ebp
f0101279:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f010127c:	e8 39 4e 00 00       	call   f01060ba <cpunum>
f0101281:	6b c0 74             	imul   $0x74,%eax,%eax
f0101284:	83 b8 28 80 23 f0 00 	cmpl   $0x0,-0xfdc7fd8(%eax)
f010128b:	74 16                	je     f01012a3 <tlb_invalidate+0x31>
f010128d:	e8 28 4e 00 00       	call   f01060ba <cpunum>
f0101292:	6b c0 74             	imul   $0x74,%eax,%eax
f0101295:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f010129b:	8b 55 08             	mov    0x8(%ebp),%edx
f010129e:	39 50 60             	cmp    %edx,0x60(%eax)
f01012a1:	75 06                	jne    f01012a9 <tlb_invalidate+0x37>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
f01012a6:	0f 01 38             	invlpg (%eax)
}
f01012a9:	c9                   	leave  
f01012aa:	c3                   	ret    

f01012ab <page_remove>:
{
f01012ab:	f3 0f 1e fb          	endbr32 
f01012af:	55                   	push   %ebp
f01012b0:	89 e5                	mov    %esp,%ebp
f01012b2:	56                   	push   %esi
f01012b3:	53                   	push   %ebx
f01012b4:	83 ec 14             	sub    $0x14,%esp
f01012b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01012ba:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo* pp = page_lookup(pgdir, va, &pte);
f01012bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01012c0:	50                   	push   %eax
f01012c1:	56                   	push   %esi
f01012c2:	53                   	push   %ebx
f01012c3:	e8 37 ff ff ff       	call   f01011ff <page_lookup>
	if(pp){
f01012c8:	83 c4 10             	add    $0x10,%esp
f01012cb:	85 c0                	test   %eax,%eax
f01012cd:	74 1f                	je     f01012ee <page_remove+0x43>
		page_decref(pp);
f01012cf:	83 ec 0c             	sub    $0xc,%esp
f01012d2:	50                   	push   %eax
f01012d3:	e8 c2 fd ff ff       	call   f010109a <page_decref>
		*pte = 0;
f01012d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01012db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, va);
f01012e1:	83 c4 08             	add    $0x8,%esp
f01012e4:	56                   	push   %esi
f01012e5:	53                   	push   %ebx
f01012e6:	e8 87 ff ff ff       	call   f0101272 <tlb_invalidate>
f01012eb:	83 c4 10             	add    $0x10,%esp
}
f01012ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01012f1:	5b                   	pop    %ebx
f01012f2:	5e                   	pop    %esi
f01012f3:	5d                   	pop    %ebp
f01012f4:	c3                   	ret    

f01012f5 <page_insert>:
{
f01012f5:	f3 0f 1e fb          	endbr32 
f01012f9:	55                   	push   %ebp
f01012fa:	89 e5                	mov    %esp,%ebp
f01012fc:	57                   	push   %edi
f01012fd:	56                   	push   %esi
f01012fe:	53                   	push   %ebx
f01012ff:	83 ec 10             	sub    $0x10,%esp
f0101302:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101305:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t* pte = pgdir_walk(pgdir, va, true);
f0101308:	6a 01                	push   $0x1
f010130a:	ff 75 10             	pushl  0x10(%ebp)
f010130d:	57                   	push   %edi
f010130e:	e8 b4 fd ff ff       	call   f01010c7 <pgdir_walk>
	if(!pte){
f0101313:	83 c4 10             	add    $0x10,%esp
f0101316:	85 c0                	test   %eax,%eax
f0101318:	74 67                	je     f0101381 <page_insert+0x8c>
f010131a:	89 c6                	mov    %eax,%esi
	if((*pte) & PTE_P){
f010131c:	8b 00                	mov    (%eax),%eax
f010131e:	a8 01                	test   $0x1,%al
f0101320:	74 1c                	je     f010133e <page_insert+0x49>
		if(PTE_ADDR(*pte) == page2pa(pp)){
f0101322:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	return (pp - pages) << PGSHIFT;
f0101327:	89 da                	mov    %ebx,%edx
f0101329:	2b 15 90 7e 23 f0    	sub    0xf0237e90,%edx
f010132f:	c1 fa 03             	sar    $0x3,%edx
f0101332:	c1 e2 0c             	shl    $0xc,%edx
f0101335:	39 d0                	cmp    %edx,%eax
f0101337:	75 37                	jne    f0101370 <page_insert+0x7b>
			pp->pp_ref--;
f0101339:	66 83 6b 04 01       	subw   $0x1,0x4(%ebx)
	pp->pp_ref++;
f010133e:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
f0101343:	2b 1d 90 7e 23 f0    	sub    0xf0237e90,%ebx
f0101349:	c1 fb 03             	sar    $0x3,%ebx
f010134c:	c1 e3 0c             	shl    $0xc,%ebx
	*pte = page2pa(pp) | perm | PTE_P;
f010134f:	0b 5d 14             	or     0x14(%ebp),%ebx
f0101352:	83 cb 01             	or     $0x1,%ebx
f0101355:	89 1e                	mov    %ebx,(%esi)
	pgdir[PDX(va)] |= perm;
f0101357:	8b 45 10             	mov    0x10(%ebp),%eax
f010135a:	c1 e8 16             	shr    $0x16,%eax
f010135d:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0101360:	09 0c 87             	or     %ecx,(%edi,%eax,4)
	return 0;
f0101363:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101368:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010136b:	5b                   	pop    %ebx
f010136c:	5e                   	pop    %esi
f010136d:	5f                   	pop    %edi
f010136e:	5d                   	pop    %ebp
f010136f:	c3                   	ret    
			page_remove(pgdir, va);
f0101370:	83 ec 08             	sub    $0x8,%esp
f0101373:	ff 75 10             	pushl  0x10(%ebp)
f0101376:	57                   	push   %edi
f0101377:	e8 2f ff ff ff       	call   f01012ab <page_remove>
f010137c:	83 c4 10             	add    $0x10,%esp
f010137f:	eb bd                	jmp    f010133e <page_insert+0x49>
		return -E_NO_MEM;
f0101381:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101386:	eb e0                	jmp    f0101368 <page_insert+0x73>

f0101388 <mmio_map_region>:
{
f0101388:	f3 0f 1e fb          	endbr32 
f010138c:	55                   	push   %ebp
f010138d:	89 e5                	mov    %esp,%ebp
f010138f:	53                   	push   %ebx
f0101390:	83 ec 04             	sub    $0x4,%esp
	size = ROUNDUP(size, PGSIZE);
f0101393:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101396:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f010139c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if(size + base > MMIOLIM){
f01013a2:	8b 15 00 33 12 f0    	mov    0xf0123300,%edx
f01013a8:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
f01013ab:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f01013b0:	77 26                	ja     f01013d8 <mmio_map_region+0x50>
	boot_map_region(kern_pgdir, base, size, pa, PTE_W | PTE_PCD | PTE_PWT);
f01013b2:	83 ec 08             	sub    $0x8,%esp
f01013b5:	6a 1a                	push   $0x1a
f01013b7:	ff 75 08             	pushl  0x8(%ebp)
f01013ba:	89 d9                	mov    %ebx,%ecx
f01013bc:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f01013c1:	e8 e2 fd ff ff       	call   f01011a8 <boot_map_region>
	base += size;
f01013c6:	a1 00 33 12 f0       	mov    0xf0123300,%eax
f01013cb:	01 c3                	add    %eax,%ebx
f01013cd:	89 1d 00 33 12 f0    	mov    %ebx,0xf0123300
}
f01013d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01013d6:	c9                   	leave  
f01013d7:	c3                   	ret    
		panic("MMIO_MAP_REGION failed: memory overflow MMIOLIM\n");
f01013d8:	83 ec 04             	sub    $0x4,%esp
f01013db:	68 bc 71 10 f0       	push   $0xf01071bc
f01013e0:	68 cb 02 00 00       	push   $0x2cb
f01013e5:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01013ea:	e8 51 ec ff ff       	call   f0100040 <_panic>

f01013ef <mem_init>:
{
f01013ef:	f3 0f 1e fb          	endbr32 
f01013f3:	55                   	push   %ebp
f01013f4:	89 e5                	mov    %esp,%ebp
f01013f6:	57                   	push   %edi
f01013f7:	56                   	push   %esi
f01013f8:	53                   	push   %ebx
f01013f9:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f01013fc:	b8 15 00 00 00       	mov    $0x15,%eax
f0101401:	e8 eb f6 ff ff       	call   f0100af1 <nvram_read>
f0101406:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0101408:	b8 17 00 00 00       	mov    $0x17,%eax
f010140d:	e8 df f6 ff ff       	call   f0100af1 <nvram_read>
f0101412:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101414:	b8 34 00 00 00       	mov    $0x34,%eax
f0101419:	e8 d3 f6 ff ff       	call   f0100af1 <nvram_read>
	if (ext16mem)
f010141e:	c1 e0 06             	shl    $0x6,%eax
f0101421:	0f 84 ea 00 00 00    	je     f0101511 <mem_init+0x122>
		totalmem = 16 * 1024 + ext16mem;
f0101427:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f010142c:	89 c2                	mov    %eax,%edx
f010142e:	c1 ea 02             	shr    $0x2,%edx
f0101431:	89 15 88 7e 23 f0    	mov    %edx,0xf0237e88
	npages_basemem = basemem / (PGSIZE / 1024);
f0101437:	89 da                	mov    %ebx,%edx
f0101439:	c1 ea 02             	shr    $0x2,%edx
f010143c:	89 15 44 72 23 f0    	mov    %edx,0xf0237244
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101442:	89 c2                	mov    %eax,%edx
f0101444:	29 da                	sub    %ebx,%edx
f0101446:	52                   	push   %edx
f0101447:	53                   	push   %ebx
f0101448:	50                   	push   %eax
f0101449:	68 f0 71 10 f0       	push   $0xf01071f0
f010144e:	e8 dc 25 00 00       	call   f0103a2f <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101453:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101458:	e8 3e f6 ff ff       	call   f0100a9b <boot_alloc>
f010145d:	a3 8c 7e 23 f0       	mov    %eax,0xf0237e8c
	memset(kern_pgdir, 0, PGSIZE);
f0101462:	83 c4 0c             	add    $0xc,%esp
f0101465:	68 00 10 00 00       	push   $0x1000
f010146a:	6a 00                	push   $0x0
f010146c:	50                   	push   %eax
f010146d:	e8 28 46 00 00       	call   f0105a9a <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101472:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0101477:	83 c4 10             	add    $0x10,%esp
f010147a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010147f:	0f 86 9c 00 00 00    	jbe    f0101521 <mem_init+0x132>
	return (physaddr_t)kva - KERNBASE;
f0101485:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010148b:	83 ca 05             	or     $0x5,%edx
f010148e:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);
f0101494:	a1 88 7e 23 f0       	mov    0xf0237e88,%eax
f0101499:	c1 e0 03             	shl    $0x3,%eax
f010149c:	e8 fa f5 ff ff       	call   f0100a9b <boot_alloc>
f01014a1:	a3 90 7e 23 f0       	mov    %eax,0xf0237e90
	memset(pages, 0, sizeof(struct PageInfo) * npages);
f01014a6:	83 ec 04             	sub    $0x4,%esp
f01014a9:	8b 0d 88 7e 23 f0    	mov    0xf0237e88,%ecx
f01014af:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f01014b6:	52                   	push   %edx
f01014b7:	6a 00                	push   $0x0
f01014b9:	50                   	push   %eax
f01014ba:	e8 db 45 00 00       	call   f0105a9a <memset>
	envs = (struct Env*)boot_alloc(sizeof(struct Env) * NENV);
f01014bf:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f01014c4:	e8 d2 f5 ff ff       	call   f0100a9b <boot_alloc>
f01014c9:	a3 48 72 23 f0       	mov    %eax,0xf0237248
	memset(envs, 0, sizeof(struct Env) * NENV);
f01014ce:	83 c4 0c             	add    $0xc,%esp
f01014d1:	68 00 f0 01 00       	push   $0x1f000
f01014d6:	6a 00                	push   $0x0
f01014d8:	50                   	push   %eax
f01014d9:	e8 bc 45 00 00       	call   f0105a9a <memset>
	page_init();
f01014de:	e8 88 f9 ff ff       	call   f0100e6b <page_init>
	check_page_free_list(1);
f01014e3:	b8 01 00 00 00       	mov    $0x1,%eax
f01014e8:	e8 90 f6 ff ff       	call   f0100b7d <check_page_free_list>
	if (!pages)
f01014ed:	83 c4 10             	add    $0x10,%esp
f01014f0:	83 3d 90 7e 23 f0 00 	cmpl   $0x0,0xf0237e90
f01014f7:	74 3d                	je     f0101536 <mem_init+0x147>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01014f9:	a1 40 72 23 f0       	mov    0xf0237240,%eax
f01014fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0101505:	85 c0                	test   %eax,%eax
f0101507:	74 44                	je     f010154d <mem_init+0x15e>
		++nfree;
f0101509:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010150d:	8b 00                	mov    (%eax),%eax
f010150f:	eb f4                	jmp    f0101505 <mem_init+0x116>
		totalmem = 1 * 1024 + extmem;
f0101511:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0101517:	85 f6                	test   %esi,%esi
f0101519:	0f 44 c3             	cmove  %ebx,%eax
f010151c:	e9 0b ff ff ff       	jmp    f010142c <mem_init+0x3d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101521:	50                   	push   %eax
f0101522:	68 88 67 10 f0       	push   $0xf0106788
f0101527:	68 97 00 00 00       	push   $0x97
f010152c:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101531:	e8 0a eb ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f0101536:	83 ec 04             	sub    $0x4,%esp
f0101539:	68 c9 6d 10 f0       	push   $0xf0106dc9
f010153e:	68 63 03 00 00       	push   $0x363
f0101543:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101548:	e8 f3 ea ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f010154d:	83 ec 0c             	sub    $0xc,%esp
f0101550:	6a 00                	push   $0x0
f0101552:	e8 62 fa ff ff       	call   f0100fb9 <page_alloc>
f0101557:	89 c3                	mov    %eax,%ebx
f0101559:	83 c4 10             	add    $0x10,%esp
f010155c:	85 c0                	test   %eax,%eax
f010155e:	0f 84 11 02 00 00    	je     f0101775 <mem_init+0x386>
	assert((pp1 = page_alloc(0)));
f0101564:	83 ec 0c             	sub    $0xc,%esp
f0101567:	6a 00                	push   $0x0
f0101569:	e8 4b fa ff ff       	call   f0100fb9 <page_alloc>
f010156e:	89 c6                	mov    %eax,%esi
f0101570:	83 c4 10             	add    $0x10,%esp
f0101573:	85 c0                	test   %eax,%eax
f0101575:	0f 84 13 02 00 00    	je     f010178e <mem_init+0x39f>
	assert((pp2 = page_alloc(0)));
f010157b:	83 ec 0c             	sub    $0xc,%esp
f010157e:	6a 00                	push   $0x0
f0101580:	e8 34 fa ff ff       	call   f0100fb9 <page_alloc>
f0101585:	89 c7                	mov    %eax,%edi
f0101587:	83 c4 10             	add    $0x10,%esp
f010158a:	85 c0                	test   %eax,%eax
f010158c:	0f 84 15 02 00 00    	je     f01017a7 <mem_init+0x3b8>
	assert(pp1 && pp1 != pp0);
f0101592:	39 f3                	cmp    %esi,%ebx
f0101594:	0f 84 26 02 00 00    	je     f01017c0 <mem_init+0x3d1>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010159a:	39 c6                	cmp    %eax,%esi
f010159c:	0f 84 37 02 00 00    	je     f01017d9 <mem_init+0x3ea>
f01015a2:	39 c3                	cmp    %eax,%ebx
f01015a4:	0f 84 2f 02 00 00    	je     f01017d9 <mem_init+0x3ea>
	return (pp - pages) << PGSHIFT;
f01015aa:	8b 0d 90 7e 23 f0    	mov    0xf0237e90,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f01015b0:	8b 15 88 7e 23 f0    	mov    0xf0237e88,%edx
f01015b6:	c1 e2 0c             	shl    $0xc,%edx
f01015b9:	89 d8                	mov    %ebx,%eax
f01015bb:	29 c8                	sub    %ecx,%eax
f01015bd:	c1 f8 03             	sar    $0x3,%eax
f01015c0:	c1 e0 0c             	shl    $0xc,%eax
f01015c3:	39 d0                	cmp    %edx,%eax
f01015c5:	0f 83 27 02 00 00    	jae    f01017f2 <mem_init+0x403>
f01015cb:	89 f0                	mov    %esi,%eax
f01015cd:	29 c8                	sub    %ecx,%eax
f01015cf:	c1 f8 03             	sar    $0x3,%eax
f01015d2:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f01015d5:	39 c2                	cmp    %eax,%edx
f01015d7:	0f 86 2e 02 00 00    	jbe    f010180b <mem_init+0x41c>
f01015dd:	89 f8                	mov    %edi,%eax
f01015df:	29 c8                	sub    %ecx,%eax
f01015e1:	c1 f8 03             	sar    $0x3,%eax
f01015e4:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f01015e7:	39 c2                	cmp    %eax,%edx
f01015e9:	0f 86 35 02 00 00    	jbe    f0101824 <mem_init+0x435>
	fl = page_free_list;
f01015ef:	a1 40 72 23 f0       	mov    0xf0237240,%eax
f01015f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f01015f7:	c7 05 40 72 23 f0 00 	movl   $0x0,0xf0237240
f01015fe:	00 00 00 
	assert(!page_alloc(0));
f0101601:	83 ec 0c             	sub    $0xc,%esp
f0101604:	6a 00                	push   $0x0
f0101606:	e8 ae f9 ff ff       	call   f0100fb9 <page_alloc>
f010160b:	83 c4 10             	add    $0x10,%esp
f010160e:	85 c0                	test   %eax,%eax
f0101610:	0f 85 27 02 00 00    	jne    f010183d <mem_init+0x44e>
	page_free(pp0);
f0101616:	83 ec 0c             	sub    $0xc,%esp
f0101619:	53                   	push   %ebx
f010161a:	e8 25 fa ff ff       	call   f0101044 <page_free>
	page_free(pp1);
f010161f:	89 34 24             	mov    %esi,(%esp)
f0101622:	e8 1d fa ff ff       	call   f0101044 <page_free>
	page_free(pp2);
f0101627:	89 3c 24             	mov    %edi,(%esp)
f010162a:	e8 15 fa ff ff       	call   f0101044 <page_free>
	assert((pp0 = page_alloc(0)));
f010162f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101636:	e8 7e f9 ff ff       	call   f0100fb9 <page_alloc>
f010163b:	89 c3                	mov    %eax,%ebx
f010163d:	83 c4 10             	add    $0x10,%esp
f0101640:	85 c0                	test   %eax,%eax
f0101642:	0f 84 0e 02 00 00    	je     f0101856 <mem_init+0x467>
	assert((pp1 = page_alloc(0)));
f0101648:	83 ec 0c             	sub    $0xc,%esp
f010164b:	6a 00                	push   $0x0
f010164d:	e8 67 f9 ff ff       	call   f0100fb9 <page_alloc>
f0101652:	89 c6                	mov    %eax,%esi
f0101654:	83 c4 10             	add    $0x10,%esp
f0101657:	85 c0                	test   %eax,%eax
f0101659:	0f 84 10 02 00 00    	je     f010186f <mem_init+0x480>
	assert((pp2 = page_alloc(0)));
f010165f:	83 ec 0c             	sub    $0xc,%esp
f0101662:	6a 00                	push   $0x0
f0101664:	e8 50 f9 ff ff       	call   f0100fb9 <page_alloc>
f0101669:	89 c7                	mov    %eax,%edi
f010166b:	83 c4 10             	add    $0x10,%esp
f010166e:	85 c0                	test   %eax,%eax
f0101670:	0f 84 12 02 00 00    	je     f0101888 <mem_init+0x499>
	assert(pp1 && pp1 != pp0);
f0101676:	39 f3                	cmp    %esi,%ebx
f0101678:	0f 84 23 02 00 00    	je     f01018a1 <mem_init+0x4b2>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010167e:	39 c3                	cmp    %eax,%ebx
f0101680:	0f 84 34 02 00 00    	je     f01018ba <mem_init+0x4cb>
f0101686:	39 c6                	cmp    %eax,%esi
f0101688:	0f 84 2c 02 00 00    	je     f01018ba <mem_init+0x4cb>
	assert(!page_alloc(0));
f010168e:	83 ec 0c             	sub    $0xc,%esp
f0101691:	6a 00                	push   $0x0
f0101693:	e8 21 f9 ff ff       	call   f0100fb9 <page_alloc>
f0101698:	83 c4 10             	add    $0x10,%esp
f010169b:	85 c0                	test   %eax,%eax
f010169d:	0f 85 30 02 00 00    	jne    f01018d3 <mem_init+0x4e4>
f01016a3:	89 d8                	mov    %ebx,%eax
f01016a5:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f01016ab:	c1 f8 03             	sar    $0x3,%eax
f01016ae:	89 c2                	mov    %eax,%edx
f01016b0:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01016b3:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01016b8:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f01016be:	0f 83 28 02 00 00    	jae    f01018ec <mem_init+0x4fd>
	memset(page2kva(pp0), 1, PGSIZE);
f01016c4:	83 ec 04             	sub    $0x4,%esp
f01016c7:	68 00 10 00 00       	push   $0x1000
f01016cc:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01016ce:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f01016d4:	52                   	push   %edx
f01016d5:	e8 c0 43 00 00       	call   f0105a9a <memset>
	page_free(pp0);
f01016da:	89 1c 24             	mov    %ebx,(%esp)
f01016dd:	e8 62 f9 ff ff       	call   f0101044 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01016e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01016e9:	e8 cb f8 ff ff       	call   f0100fb9 <page_alloc>
f01016ee:	83 c4 10             	add    $0x10,%esp
f01016f1:	85 c0                	test   %eax,%eax
f01016f3:	0f 84 05 02 00 00    	je     f01018fe <mem_init+0x50f>
	assert(pp && pp0 == pp);
f01016f9:	39 c3                	cmp    %eax,%ebx
f01016fb:	0f 85 16 02 00 00    	jne    f0101917 <mem_init+0x528>
	return (pp - pages) << PGSHIFT;
f0101701:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0101707:	c1 f8 03             	sar    $0x3,%eax
f010170a:	89 c2                	mov    %eax,%edx
f010170c:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010170f:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101714:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f010171a:	0f 83 10 02 00 00    	jae    f0101930 <mem_init+0x541>
	return (void *)(pa + KERNBASE);
f0101720:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101726:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f010172c:	80 38 00             	cmpb   $0x0,(%eax)
f010172f:	0f 85 0d 02 00 00    	jne    f0101942 <mem_init+0x553>
f0101735:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f0101738:	39 d0                	cmp    %edx,%eax
f010173a:	75 f0                	jne    f010172c <mem_init+0x33d>
	page_free_list = fl;
f010173c:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010173f:	a3 40 72 23 f0       	mov    %eax,0xf0237240
	page_free(pp0);
f0101744:	83 ec 0c             	sub    $0xc,%esp
f0101747:	53                   	push   %ebx
f0101748:	e8 f7 f8 ff ff       	call   f0101044 <page_free>
	page_free(pp1);
f010174d:	89 34 24             	mov    %esi,(%esp)
f0101750:	e8 ef f8 ff ff       	call   f0101044 <page_free>
	page_free(pp2);
f0101755:	89 3c 24             	mov    %edi,(%esp)
f0101758:	e8 e7 f8 ff ff       	call   f0101044 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010175d:	a1 40 72 23 f0       	mov    0xf0237240,%eax
f0101762:	83 c4 10             	add    $0x10,%esp
f0101765:	85 c0                	test   %eax,%eax
f0101767:	0f 84 ee 01 00 00    	je     f010195b <mem_init+0x56c>
		--nfree;
f010176d:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101771:	8b 00                	mov    (%eax),%eax
f0101773:	eb f0                	jmp    f0101765 <mem_init+0x376>
	assert((pp0 = page_alloc(0)));
f0101775:	68 e4 6d 10 f0       	push   $0xf0106de4
f010177a:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010177f:	68 6b 03 00 00       	push   $0x36b
f0101784:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101789:	e8 b2 e8 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010178e:	68 fa 6d 10 f0       	push   $0xf0106dfa
f0101793:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0101798:	68 6c 03 00 00       	push   $0x36c
f010179d:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01017a2:	e8 99 e8 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01017a7:	68 10 6e 10 f0       	push   $0xf0106e10
f01017ac:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01017b1:	68 6d 03 00 00       	push   $0x36d
f01017b6:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01017bb:	e8 80 e8 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01017c0:	68 26 6e 10 f0       	push   $0xf0106e26
f01017c5:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01017ca:	68 70 03 00 00       	push   $0x370
f01017cf:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01017d4:	e8 67 e8 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01017d9:	68 2c 72 10 f0       	push   $0xf010722c
f01017de:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01017e3:	68 71 03 00 00       	push   $0x371
f01017e8:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01017ed:	e8 4e e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f01017f2:	68 38 6e 10 f0       	push   $0xf0106e38
f01017f7:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01017fc:	68 72 03 00 00       	push   $0x372
f0101801:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101806:	e8 35 e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f010180b:	68 55 6e 10 f0       	push   $0xf0106e55
f0101810:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0101815:	68 73 03 00 00       	push   $0x373
f010181a:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010181f:	e8 1c e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101824:	68 72 6e 10 f0       	push   $0xf0106e72
f0101829:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010182e:	68 74 03 00 00       	push   $0x374
f0101833:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101838:	e8 03 e8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010183d:	68 8f 6e 10 f0       	push   $0xf0106e8f
f0101842:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0101847:	68 7b 03 00 00       	push   $0x37b
f010184c:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101851:	e8 ea e7 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0101856:	68 e4 6d 10 f0       	push   $0xf0106de4
f010185b:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0101860:	68 82 03 00 00       	push   $0x382
f0101865:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010186a:	e8 d1 e7 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010186f:	68 fa 6d 10 f0       	push   $0xf0106dfa
f0101874:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0101879:	68 83 03 00 00       	push   $0x383
f010187e:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101883:	e8 b8 e7 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101888:	68 10 6e 10 f0       	push   $0xf0106e10
f010188d:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0101892:	68 84 03 00 00       	push   $0x384
f0101897:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010189c:	e8 9f e7 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01018a1:	68 26 6e 10 f0       	push   $0xf0106e26
f01018a6:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01018ab:	68 86 03 00 00       	push   $0x386
f01018b0:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01018b5:	e8 86 e7 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018ba:	68 2c 72 10 f0       	push   $0xf010722c
f01018bf:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01018c4:	68 87 03 00 00       	push   $0x387
f01018c9:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01018ce:	e8 6d e7 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01018d3:	68 8f 6e 10 f0       	push   $0xf0106e8f
f01018d8:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01018dd:	68 88 03 00 00       	push   $0x388
f01018e2:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01018e7:	e8 54 e7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01018ec:	52                   	push   %edx
f01018ed:	68 64 67 10 f0       	push   $0xf0106764
f01018f2:	6a 58                	push   $0x58
f01018f4:	68 02 6d 10 f0       	push   $0xf0106d02
f01018f9:	e8 42 e7 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01018fe:	68 9e 6e 10 f0       	push   $0xf0106e9e
f0101903:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0101908:	68 8d 03 00 00       	push   $0x38d
f010190d:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101912:	e8 29 e7 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f0101917:	68 bc 6e 10 f0       	push   $0xf0106ebc
f010191c:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0101921:	68 8e 03 00 00       	push   $0x38e
f0101926:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010192b:	e8 10 e7 ff ff       	call   f0100040 <_panic>
f0101930:	52                   	push   %edx
f0101931:	68 64 67 10 f0       	push   $0xf0106764
f0101936:	6a 58                	push   $0x58
f0101938:	68 02 6d 10 f0       	push   $0xf0106d02
f010193d:	e8 fe e6 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f0101942:	68 cc 6e 10 f0       	push   $0xf0106ecc
f0101947:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010194c:	68 91 03 00 00       	push   $0x391
f0101951:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0101956:	e8 e5 e6 ff ff       	call   f0100040 <_panic>
	assert(nfree == 0);
f010195b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f010195f:	0f 85 43 09 00 00    	jne    f01022a8 <mem_init+0xeb9>
	cprintf("check_page_alloc() succeeded!\n");
f0101965:	83 ec 0c             	sub    $0xc,%esp
f0101968:	68 4c 72 10 f0       	push   $0xf010724c
f010196d:	e8 bd 20 00 00       	call   f0103a2f <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101972:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101979:	e8 3b f6 ff ff       	call   f0100fb9 <page_alloc>
f010197e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101981:	83 c4 10             	add    $0x10,%esp
f0101984:	85 c0                	test   %eax,%eax
f0101986:	0f 84 35 09 00 00    	je     f01022c1 <mem_init+0xed2>
	assert((pp1 = page_alloc(0)));
f010198c:	83 ec 0c             	sub    $0xc,%esp
f010198f:	6a 00                	push   $0x0
f0101991:	e8 23 f6 ff ff       	call   f0100fb9 <page_alloc>
f0101996:	89 c7                	mov    %eax,%edi
f0101998:	83 c4 10             	add    $0x10,%esp
f010199b:	85 c0                	test   %eax,%eax
f010199d:	0f 84 37 09 00 00    	je     f01022da <mem_init+0xeeb>
	assert((pp2 = page_alloc(0)));
f01019a3:	83 ec 0c             	sub    $0xc,%esp
f01019a6:	6a 00                	push   $0x0
f01019a8:	e8 0c f6 ff ff       	call   f0100fb9 <page_alloc>
f01019ad:	89 c3                	mov    %eax,%ebx
f01019af:	83 c4 10             	add    $0x10,%esp
f01019b2:	85 c0                	test   %eax,%eax
f01019b4:	0f 84 39 09 00 00    	je     f01022f3 <mem_init+0xf04>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f01019ba:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f01019bd:	0f 84 49 09 00 00    	je     f010230c <mem_init+0xf1d>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019c3:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f01019c6:	0f 84 59 09 00 00    	je     f0102325 <mem_init+0xf36>
f01019cc:	39 c7                	cmp    %eax,%edi
f01019ce:	0f 84 51 09 00 00    	je     f0102325 <mem_init+0xf36>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f01019d4:	a1 40 72 23 f0       	mov    0xf0237240,%eax
f01019d9:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f01019dc:	c7 05 40 72 23 f0 00 	movl   $0x0,0xf0237240
f01019e3:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f01019e6:	83 ec 0c             	sub    $0xc,%esp
f01019e9:	6a 00                	push   $0x0
f01019eb:	e8 c9 f5 ff ff       	call   f0100fb9 <page_alloc>
f01019f0:	83 c4 10             	add    $0x10,%esp
f01019f3:	85 c0                	test   %eax,%eax
f01019f5:	0f 85 43 09 00 00    	jne    f010233e <mem_init+0xf4f>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01019fb:	83 ec 04             	sub    $0x4,%esp
f01019fe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101a01:	50                   	push   %eax
f0101a02:	6a 00                	push   $0x0
f0101a04:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101a0a:	e8 f0 f7 ff ff       	call   f01011ff <page_lookup>
f0101a0f:	83 c4 10             	add    $0x10,%esp
f0101a12:	85 c0                	test   %eax,%eax
f0101a14:	0f 85 3d 09 00 00    	jne    f0102357 <mem_init+0xf68>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101a1a:	6a 02                	push   $0x2
f0101a1c:	6a 00                	push   $0x0
f0101a1e:	57                   	push   %edi
f0101a1f:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101a25:	e8 cb f8 ff ff       	call   f01012f5 <page_insert>
f0101a2a:	83 c4 10             	add    $0x10,%esp
f0101a2d:	85 c0                	test   %eax,%eax
f0101a2f:	0f 89 3b 09 00 00    	jns    f0102370 <mem_init+0xf81>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101a35:	83 ec 0c             	sub    $0xc,%esp
f0101a38:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101a3b:	e8 04 f6 ff ff       	call   f0101044 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101a40:	6a 02                	push   $0x2
f0101a42:	6a 00                	push   $0x0
f0101a44:	57                   	push   %edi
f0101a45:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101a4b:	e8 a5 f8 ff ff       	call   f01012f5 <page_insert>
f0101a50:	83 c4 20             	add    $0x20,%esp
f0101a53:	85 c0                	test   %eax,%eax
f0101a55:	0f 85 2e 09 00 00    	jne    f0102389 <mem_init+0xf9a>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101a5b:	8b 35 8c 7e 23 f0    	mov    0xf0237e8c,%esi
	return (pp - pages) << PGSHIFT;
f0101a61:	8b 0d 90 7e 23 f0    	mov    0xf0237e90,%ecx
f0101a67:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101a6a:	8b 16                	mov    (%esi),%edx
f0101a6c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101a72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a75:	29 c8                	sub    %ecx,%eax
f0101a77:	c1 f8 03             	sar    $0x3,%eax
f0101a7a:	c1 e0 0c             	shl    $0xc,%eax
f0101a7d:	39 c2                	cmp    %eax,%edx
f0101a7f:	0f 85 1d 09 00 00    	jne    f01023a2 <mem_init+0xfb3>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101a85:	ba 00 00 00 00       	mov    $0x0,%edx
f0101a8a:	89 f0                	mov    %esi,%eax
f0101a8c:	e8 89 f0 ff ff       	call   f0100b1a <check_va2pa>
f0101a91:	89 c2                	mov    %eax,%edx
f0101a93:	89 f8                	mov    %edi,%eax
f0101a95:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0101a98:	c1 f8 03             	sar    $0x3,%eax
f0101a9b:	c1 e0 0c             	shl    $0xc,%eax
f0101a9e:	39 c2                	cmp    %eax,%edx
f0101aa0:	0f 85 15 09 00 00    	jne    f01023bb <mem_init+0xfcc>
	assert(pp1->pp_ref == 1);
f0101aa6:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101aab:	0f 85 23 09 00 00    	jne    f01023d4 <mem_init+0xfe5>
	assert(pp0->pp_ref == 1);
f0101ab1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ab4:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101ab9:	0f 85 2e 09 00 00    	jne    f01023ed <mem_init+0xffe>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101abf:	6a 02                	push   $0x2
f0101ac1:	68 00 10 00 00       	push   $0x1000
f0101ac6:	53                   	push   %ebx
f0101ac7:	56                   	push   %esi
f0101ac8:	e8 28 f8 ff ff       	call   f01012f5 <page_insert>
f0101acd:	83 c4 10             	add    $0x10,%esp
f0101ad0:	85 c0                	test   %eax,%eax
f0101ad2:	0f 85 2e 09 00 00    	jne    f0102406 <mem_init+0x1017>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101ad8:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101add:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f0101ae2:	e8 33 f0 ff ff       	call   f0100b1a <check_va2pa>
f0101ae7:	89 c2                	mov    %eax,%edx
f0101ae9:	89 d8                	mov    %ebx,%eax
f0101aeb:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0101af1:	c1 f8 03             	sar    $0x3,%eax
f0101af4:	c1 e0 0c             	shl    $0xc,%eax
f0101af7:	39 c2                	cmp    %eax,%edx
f0101af9:	0f 85 20 09 00 00    	jne    f010241f <mem_init+0x1030>
	assert(pp2->pp_ref == 1);
f0101aff:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101b04:	0f 85 2e 09 00 00    	jne    f0102438 <mem_init+0x1049>

	// should be no free memory
	assert(!page_alloc(0));
f0101b0a:	83 ec 0c             	sub    $0xc,%esp
f0101b0d:	6a 00                	push   $0x0
f0101b0f:	e8 a5 f4 ff ff       	call   f0100fb9 <page_alloc>
f0101b14:	83 c4 10             	add    $0x10,%esp
f0101b17:	85 c0                	test   %eax,%eax
f0101b19:	0f 85 32 09 00 00    	jne    f0102451 <mem_init+0x1062>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101b1f:	6a 02                	push   $0x2
f0101b21:	68 00 10 00 00       	push   $0x1000
f0101b26:	53                   	push   %ebx
f0101b27:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101b2d:	e8 c3 f7 ff ff       	call   f01012f5 <page_insert>
f0101b32:	83 c4 10             	add    $0x10,%esp
f0101b35:	85 c0                	test   %eax,%eax
f0101b37:	0f 85 2d 09 00 00    	jne    f010246a <mem_init+0x107b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b3d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b42:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f0101b47:	e8 ce ef ff ff       	call   f0100b1a <check_va2pa>
f0101b4c:	89 c2                	mov    %eax,%edx
f0101b4e:	89 d8                	mov    %ebx,%eax
f0101b50:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0101b56:	c1 f8 03             	sar    $0x3,%eax
f0101b59:	c1 e0 0c             	shl    $0xc,%eax
f0101b5c:	39 c2                	cmp    %eax,%edx
f0101b5e:	0f 85 1f 09 00 00    	jne    f0102483 <mem_init+0x1094>
	assert(pp2->pp_ref == 1);
f0101b64:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101b69:	0f 85 2d 09 00 00    	jne    f010249c <mem_init+0x10ad>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101b6f:	83 ec 0c             	sub    $0xc,%esp
f0101b72:	6a 00                	push   $0x0
f0101b74:	e8 40 f4 ff ff       	call   f0100fb9 <page_alloc>
f0101b79:	83 c4 10             	add    $0x10,%esp
f0101b7c:	85 c0                	test   %eax,%eax
f0101b7e:	0f 85 31 09 00 00    	jne    f01024b5 <mem_init+0x10c6>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101b84:	8b 0d 8c 7e 23 f0    	mov    0xf0237e8c,%ecx
f0101b8a:	8b 01                	mov    (%ecx),%eax
f0101b8c:	89 c2                	mov    %eax,%edx
f0101b8e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101b94:	c1 e8 0c             	shr    $0xc,%eax
f0101b97:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f0101b9d:	0f 83 2b 09 00 00    	jae    f01024ce <mem_init+0x10df>
	return (void *)(pa + KERNBASE);
f0101ba3:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101ba9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101bac:	83 ec 04             	sub    $0x4,%esp
f0101baf:	6a 00                	push   $0x0
f0101bb1:	68 00 10 00 00       	push   $0x1000
f0101bb6:	51                   	push   %ecx
f0101bb7:	e8 0b f5 ff ff       	call   f01010c7 <pgdir_walk>
f0101bbc:	89 c2                	mov    %eax,%edx
f0101bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101bc1:	83 c0 04             	add    $0x4,%eax
f0101bc4:	83 c4 10             	add    $0x10,%esp
f0101bc7:	39 d0                	cmp    %edx,%eax
f0101bc9:	0f 85 14 09 00 00    	jne    f01024e3 <mem_init+0x10f4>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101bcf:	6a 06                	push   $0x6
f0101bd1:	68 00 10 00 00       	push   $0x1000
f0101bd6:	53                   	push   %ebx
f0101bd7:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101bdd:	e8 13 f7 ff ff       	call   f01012f5 <page_insert>
f0101be2:	83 c4 10             	add    $0x10,%esp
f0101be5:	85 c0                	test   %eax,%eax
f0101be7:	0f 85 0f 09 00 00    	jne    f01024fc <mem_init+0x110d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101bed:	8b 35 8c 7e 23 f0    	mov    0xf0237e8c,%esi
f0101bf3:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101bf8:	89 f0                	mov    %esi,%eax
f0101bfa:	e8 1b ef ff ff       	call   f0100b1a <check_va2pa>
f0101bff:	89 c2                	mov    %eax,%edx
	return (pp - pages) << PGSHIFT;
f0101c01:	89 d8                	mov    %ebx,%eax
f0101c03:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0101c09:	c1 f8 03             	sar    $0x3,%eax
f0101c0c:	c1 e0 0c             	shl    $0xc,%eax
f0101c0f:	39 c2                	cmp    %eax,%edx
f0101c11:	0f 85 fe 08 00 00    	jne    f0102515 <mem_init+0x1126>
	assert(pp2->pp_ref == 1);
f0101c17:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101c1c:	0f 85 0c 09 00 00    	jne    f010252e <mem_init+0x113f>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101c22:	83 ec 04             	sub    $0x4,%esp
f0101c25:	6a 00                	push   $0x0
f0101c27:	68 00 10 00 00       	push   $0x1000
f0101c2c:	56                   	push   %esi
f0101c2d:	e8 95 f4 ff ff       	call   f01010c7 <pgdir_walk>
f0101c32:	83 c4 10             	add    $0x10,%esp
f0101c35:	f6 00 04             	testb  $0x4,(%eax)
f0101c38:	0f 84 09 09 00 00    	je     f0102547 <mem_init+0x1158>
	assert(kern_pgdir[0] & PTE_U);
f0101c3e:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f0101c43:	f6 00 04             	testb  $0x4,(%eax)
f0101c46:	0f 84 14 09 00 00    	je     f0102560 <mem_init+0x1171>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101c4c:	6a 02                	push   $0x2
f0101c4e:	68 00 10 00 00       	push   $0x1000
f0101c53:	53                   	push   %ebx
f0101c54:	50                   	push   %eax
f0101c55:	e8 9b f6 ff ff       	call   f01012f5 <page_insert>
f0101c5a:	83 c4 10             	add    $0x10,%esp
f0101c5d:	85 c0                	test   %eax,%eax
f0101c5f:	0f 85 14 09 00 00    	jne    f0102579 <mem_init+0x118a>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101c65:	83 ec 04             	sub    $0x4,%esp
f0101c68:	6a 00                	push   $0x0
f0101c6a:	68 00 10 00 00       	push   $0x1000
f0101c6f:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101c75:	e8 4d f4 ff ff       	call   f01010c7 <pgdir_walk>
f0101c7a:	83 c4 10             	add    $0x10,%esp
f0101c7d:	f6 00 02             	testb  $0x2,(%eax)
f0101c80:	0f 84 0c 09 00 00    	je     f0102592 <mem_init+0x11a3>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101c86:	83 ec 04             	sub    $0x4,%esp
f0101c89:	6a 00                	push   $0x0
f0101c8b:	68 00 10 00 00       	push   $0x1000
f0101c90:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101c96:	e8 2c f4 ff ff       	call   f01010c7 <pgdir_walk>
f0101c9b:	83 c4 10             	add    $0x10,%esp
f0101c9e:	f6 00 04             	testb  $0x4,(%eax)
f0101ca1:	0f 85 04 09 00 00    	jne    f01025ab <mem_init+0x11bc>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101ca7:	6a 02                	push   $0x2
f0101ca9:	68 00 00 40 00       	push   $0x400000
f0101cae:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101cb1:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101cb7:	e8 39 f6 ff ff       	call   f01012f5 <page_insert>
f0101cbc:	83 c4 10             	add    $0x10,%esp
f0101cbf:	85 c0                	test   %eax,%eax
f0101cc1:	0f 89 fd 08 00 00    	jns    f01025c4 <mem_init+0x11d5>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101cc7:	6a 02                	push   $0x2
f0101cc9:	68 00 10 00 00       	push   $0x1000
f0101cce:	57                   	push   %edi
f0101ccf:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101cd5:	e8 1b f6 ff ff       	call   f01012f5 <page_insert>
f0101cda:	83 c4 10             	add    $0x10,%esp
f0101cdd:	85 c0                	test   %eax,%eax
f0101cdf:	0f 85 f8 08 00 00    	jne    f01025dd <mem_init+0x11ee>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101ce5:	83 ec 04             	sub    $0x4,%esp
f0101ce8:	6a 00                	push   $0x0
f0101cea:	68 00 10 00 00       	push   $0x1000
f0101cef:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101cf5:	e8 cd f3 ff ff       	call   f01010c7 <pgdir_walk>
f0101cfa:	83 c4 10             	add    $0x10,%esp
f0101cfd:	f6 00 04             	testb  $0x4,(%eax)
f0101d00:	0f 85 f0 08 00 00    	jne    f01025f6 <mem_init+0x1207>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101d06:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f0101d0b:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101d0e:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d13:	e8 02 ee ff ff       	call   f0100b1a <check_va2pa>
f0101d18:	89 fe                	mov    %edi,%esi
f0101d1a:	2b 35 90 7e 23 f0    	sub    0xf0237e90,%esi
f0101d20:	c1 fe 03             	sar    $0x3,%esi
f0101d23:	c1 e6 0c             	shl    $0xc,%esi
f0101d26:	39 f0                	cmp    %esi,%eax
f0101d28:	0f 85 e1 08 00 00    	jne    f010260f <mem_init+0x1220>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101d2e:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d33:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101d36:	e8 df ed ff ff       	call   f0100b1a <check_va2pa>
f0101d3b:	39 c6                	cmp    %eax,%esi
f0101d3d:	0f 85 e5 08 00 00    	jne    f0102628 <mem_init+0x1239>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101d43:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f0101d48:	0f 85 f3 08 00 00    	jne    f0102641 <mem_init+0x1252>
	assert(pp2->pp_ref == 0);
f0101d4e:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101d53:	0f 85 01 09 00 00    	jne    f010265a <mem_init+0x126b>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101d59:	83 ec 0c             	sub    $0xc,%esp
f0101d5c:	6a 00                	push   $0x0
f0101d5e:	e8 56 f2 ff ff       	call   f0100fb9 <page_alloc>
f0101d63:	83 c4 10             	add    $0x10,%esp
f0101d66:	85 c0                	test   %eax,%eax
f0101d68:	0f 84 05 09 00 00    	je     f0102673 <mem_init+0x1284>
f0101d6e:	39 c3                	cmp    %eax,%ebx
f0101d70:	0f 85 fd 08 00 00    	jne    f0102673 <mem_init+0x1284>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101d76:	83 ec 08             	sub    $0x8,%esp
f0101d79:	6a 00                	push   $0x0
f0101d7b:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101d81:	e8 25 f5 ff ff       	call   f01012ab <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101d86:	8b 35 8c 7e 23 f0    	mov    0xf0237e8c,%esi
f0101d8c:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d91:	89 f0                	mov    %esi,%eax
f0101d93:	e8 82 ed ff ff       	call   f0100b1a <check_va2pa>
f0101d98:	83 c4 10             	add    $0x10,%esp
f0101d9b:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d9e:	0f 85 e8 08 00 00    	jne    f010268c <mem_init+0x129d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101da4:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101da9:	89 f0                	mov    %esi,%eax
f0101dab:	e8 6a ed ff ff       	call   f0100b1a <check_va2pa>
f0101db0:	89 c2                	mov    %eax,%edx
f0101db2:	89 f8                	mov    %edi,%eax
f0101db4:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0101dba:	c1 f8 03             	sar    $0x3,%eax
f0101dbd:	c1 e0 0c             	shl    $0xc,%eax
f0101dc0:	39 c2                	cmp    %eax,%edx
f0101dc2:	0f 85 dd 08 00 00    	jne    f01026a5 <mem_init+0x12b6>
	assert(pp1->pp_ref == 1);
f0101dc8:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101dcd:	0f 85 eb 08 00 00    	jne    f01026be <mem_init+0x12cf>
	assert(pp2->pp_ref == 0);
f0101dd3:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101dd8:	0f 85 f9 08 00 00    	jne    f01026d7 <mem_init+0x12e8>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101dde:	6a 00                	push   $0x0
f0101de0:	68 00 10 00 00       	push   $0x1000
f0101de5:	57                   	push   %edi
f0101de6:	56                   	push   %esi
f0101de7:	e8 09 f5 ff ff       	call   f01012f5 <page_insert>
f0101dec:	83 c4 10             	add    $0x10,%esp
f0101def:	85 c0                	test   %eax,%eax
f0101df1:	0f 85 f9 08 00 00    	jne    f01026f0 <mem_init+0x1301>
	assert(pp1->pp_ref);
f0101df7:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101dfc:	0f 84 07 09 00 00    	je     f0102709 <mem_init+0x131a>
	assert(pp1->pp_link == NULL);
f0101e02:	83 3f 00             	cmpl   $0x0,(%edi)
f0101e05:	0f 85 17 09 00 00    	jne    f0102722 <mem_init+0x1333>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101e0b:	83 ec 08             	sub    $0x8,%esp
f0101e0e:	68 00 10 00 00       	push   $0x1000
f0101e13:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101e19:	e8 8d f4 ff ff       	call   f01012ab <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101e1e:	8b 35 8c 7e 23 f0    	mov    0xf0237e8c,%esi
f0101e24:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e29:	89 f0                	mov    %esi,%eax
f0101e2b:	e8 ea ec ff ff       	call   f0100b1a <check_va2pa>
f0101e30:	83 c4 10             	add    $0x10,%esp
f0101e33:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e36:	0f 85 ff 08 00 00    	jne    f010273b <mem_init+0x134c>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101e3c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e41:	89 f0                	mov    %esi,%eax
f0101e43:	e8 d2 ec ff ff       	call   f0100b1a <check_va2pa>
f0101e48:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e4b:	0f 85 03 09 00 00    	jne    f0102754 <mem_init+0x1365>
	assert(pp1->pp_ref == 0);
f0101e51:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101e56:	0f 85 11 09 00 00    	jne    f010276d <mem_init+0x137e>
	assert(pp2->pp_ref == 0);
f0101e5c:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101e61:	0f 85 1f 09 00 00    	jne    f0102786 <mem_init+0x1397>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101e67:	83 ec 0c             	sub    $0xc,%esp
f0101e6a:	6a 00                	push   $0x0
f0101e6c:	e8 48 f1 ff ff       	call   f0100fb9 <page_alloc>
f0101e71:	83 c4 10             	add    $0x10,%esp
f0101e74:	39 c7                	cmp    %eax,%edi
f0101e76:	0f 85 23 09 00 00    	jne    f010279f <mem_init+0x13b0>
f0101e7c:	85 c0                	test   %eax,%eax
f0101e7e:	0f 84 1b 09 00 00    	je     f010279f <mem_init+0x13b0>

	// should be no free memory
	assert(!page_alloc(0));
f0101e84:	83 ec 0c             	sub    $0xc,%esp
f0101e87:	6a 00                	push   $0x0
f0101e89:	e8 2b f1 ff ff       	call   f0100fb9 <page_alloc>
f0101e8e:	83 c4 10             	add    $0x10,%esp
f0101e91:	85 c0                	test   %eax,%eax
f0101e93:	0f 85 1f 09 00 00    	jne    f01027b8 <mem_init+0x13c9>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101e99:	8b 0d 8c 7e 23 f0    	mov    0xf0237e8c,%ecx
f0101e9f:	8b 11                	mov    (%ecx),%edx
f0101ea1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101ea7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101eaa:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0101eb0:	c1 f8 03             	sar    $0x3,%eax
f0101eb3:	c1 e0 0c             	shl    $0xc,%eax
f0101eb6:	39 c2                	cmp    %eax,%edx
f0101eb8:	0f 85 13 09 00 00    	jne    f01027d1 <mem_init+0x13e2>
	kern_pgdir[0] = 0;
f0101ebe:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101ec4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ec7:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101ecc:	0f 85 18 09 00 00    	jne    f01027ea <mem_init+0x13fb>
	pp0->pp_ref = 0;
f0101ed2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ed5:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101edb:	83 ec 0c             	sub    $0xc,%esp
f0101ede:	50                   	push   %eax
f0101edf:	e8 60 f1 ff ff       	call   f0101044 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101ee4:	83 c4 0c             	add    $0xc,%esp
f0101ee7:	6a 01                	push   $0x1
f0101ee9:	68 00 10 40 00       	push   $0x401000
f0101eee:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101ef4:	e8 ce f1 ff ff       	call   f01010c7 <pgdir_walk>
f0101ef9:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101efc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101eff:	8b 0d 8c 7e 23 f0    	mov    0xf0237e8c,%ecx
f0101f05:	8b 41 04             	mov    0x4(%ecx),%eax
f0101f08:	89 c6                	mov    %eax,%esi
f0101f0a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0101f10:	8b 15 88 7e 23 f0    	mov    0xf0237e88,%edx
f0101f16:	c1 e8 0c             	shr    $0xc,%eax
f0101f19:	83 c4 10             	add    $0x10,%esp
f0101f1c:	39 d0                	cmp    %edx,%eax
f0101f1e:	0f 83 df 08 00 00    	jae    f0102803 <mem_init+0x1414>
	assert(ptep == ptep1 + PTX(va));
f0101f24:	81 ee fc ff ff 0f    	sub    $0xffffffc,%esi
f0101f2a:	39 75 d0             	cmp    %esi,-0x30(%ebp)
f0101f2d:	0f 85 e5 08 00 00    	jne    f0102818 <mem_init+0x1429>
	kern_pgdir[PDX(va)] = 0;
f0101f33:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
	pp0->pp_ref = 0;
f0101f3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f3d:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101f43:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0101f49:	c1 f8 03             	sar    $0x3,%eax
f0101f4c:	89 c1                	mov    %eax,%ecx
f0101f4e:	c1 e1 0c             	shl    $0xc,%ecx
	if (PGNUM(pa) >= npages)
f0101f51:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101f56:	39 c2                	cmp    %eax,%edx
f0101f58:	0f 86 d3 08 00 00    	jbe    f0102831 <mem_init+0x1442>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101f5e:	83 ec 04             	sub    $0x4,%esp
f0101f61:	68 00 10 00 00       	push   $0x1000
f0101f66:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101f6b:	81 e9 00 00 00 10    	sub    $0x10000000,%ecx
f0101f71:	51                   	push   %ecx
f0101f72:	e8 23 3b 00 00       	call   f0105a9a <memset>
	page_free(pp0);
f0101f77:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0101f7a:	89 34 24             	mov    %esi,(%esp)
f0101f7d:	e8 c2 f0 ff ff       	call   f0101044 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101f82:	83 c4 0c             	add    $0xc,%esp
f0101f85:	6a 01                	push   $0x1
f0101f87:	6a 00                	push   $0x0
f0101f89:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0101f8f:	e8 33 f1 ff ff       	call   f01010c7 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0101f94:	89 f0                	mov    %esi,%eax
f0101f96:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0101f9c:	c1 f8 03             	sar    $0x3,%eax
f0101f9f:	89 c2                	mov    %eax,%edx
f0101fa1:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101fa4:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101fa9:	83 c4 10             	add    $0x10,%esp
f0101fac:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f0101fb2:	0f 83 8b 08 00 00    	jae    f0102843 <mem_init+0x1454>
	return (void *)(pa + KERNBASE);
f0101fb8:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0101fbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101fc1:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0101fc7:	f6 00 01             	testb  $0x1,(%eax)
f0101fca:	0f 85 85 08 00 00    	jne    f0102855 <mem_init+0x1466>
f0101fd0:	83 c0 04             	add    $0x4,%eax
	for(i=0; i<NPTENTRIES; i++)
f0101fd3:	39 d0                	cmp    %edx,%eax
f0101fd5:	75 f0                	jne    f0101fc7 <mem_init+0xbd8>
	kern_pgdir[0] = 0;
f0101fd7:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f0101fdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0101fe2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fe5:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0101feb:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101fee:	89 0d 40 72 23 f0    	mov    %ecx,0xf0237240

	// free the pages we took
	page_free(pp0);
f0101ff4:	83 ec 0c             	sub    $0xc,%esp
f0101ff7:	50                   	push   %eax
f0101ff8:	e8 47 f0 ff ff       	call   f0101044 <page_free>
	page_free(pp1);
f0101ffd:	89 3c 24             	mov    %edi,(%esp)
f0102000:	e8 3f f0 ff ff       	call   f0101044 <page_free>
	page_free(pp2);
f0102005:	89 1c 24             	mov    %ebx,(%esp)
f0102008:	e8 37 f0 ff ff       	call   f0101044 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f010200d:	83 c4 08             	add    $0x8,%esp
f0102010:	68 01 10 00 00       	push   $0x1001
f0102015:	6a 00                	push   $0x0
f0102017:	e8 6c f3 ff ff       	call   f0101388 <mmio_map_region>
f010201c:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f010201e:	83 c4 08             	add    $0x8,%esp
f0102021:	68 00 10 00 00       	push   $0x1000
f0102026:	6a 00                	push   $0x0
f0102028:	e8 5b f3 ff ff       	call   f0101388 <mmio_map_region>
f010202d:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f010202f:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0102035:	83 c4 10             	add    $0x10,%esp
f0102038:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f010203e:	0f 86 2a 08 00 00    	jbe    f010286e <mem_init+0x147f>
f0102044:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102049:	0f 87 1f 08 00 00    	ja     f010286e <mem_init+0x147f>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f010204f:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0102055:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f010205b:	0f 87 26 08 00 00    	ja     f0102887 <mem_init+0x1498>
f0102061:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102067:	0f 86 1a 08 00 00    	jbe    f0102887 <mem_init+0x1498>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f010206d:	89 da                	mov    %ebx,%edx
f010206f:	09 f2                	or     %esi,%edx
f0102071:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102077:	0f 85 23 08 00 00    	jne    f01028a0 <mem_init+0x14b1>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f010207d:	39 c6                	cmp    %eax,%esi
f010207f:	0f 82 34 08 00 00    	jb     f01028b9 <mem_init+0x14ca>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102085:	8b 3d 8c 7e 23 f0    	mov    0xf0237e8c,%edi
f010208b:	89 da                	mov    %ebx,%edx
f010208d:	89 f8                	mov    %edi,%eax
f010208f:	e8 86 ea ff ff       	call   f0100b1a <check_va2pa>
f0102094:	85 c0                	test   %eax,%eax
f0102096:	0f 85 36 08 00 00    	jne    f01028d2 <mem_init+0x14e3>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f010209c:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f01020a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01020a5:	89 c2                	mov    %eax,%edx
f01020a7:	89 f8                	mov    %edi,%eax
f01020a9:	e8 6c ea ff ff       	call   f0100b1a <check_va2pa>
f01020ae:	3d 00 10 00 00       	cmp    $0x1000,%eax
f01020b3:	0f 85 32 08 00 00    	jne    f01028eb <mem_init+0x14fc>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f01020b9:	89 f2                	mov    %esi,%edx
f01020bb:	89 f8                	mov    %edi,%eax
f01020bd:	e8 58 ea ff ff       	call   f0100b1a <check_va2pa>
f01020c2:	85 c0                	test   %eax,%eax
f01020c4:	0f 85 3a 08 00 00    	jne    f0102904 <mem_init+0x1515>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f01020ca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f01020d0:	89 f8                	mov    %edi,%eax
f01020d2:	e8 43 ea ff ff       	call   f0100b1a <check_va2pa>
f01020d7:	83 f8 ff             	cmp    $0xffffffff,%eax
f01020da:	0f 85 3d 08 00 00    	jne    f010291d <mem_init+0x152e>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f01020e0:	83 ec 04             	sub    $0x4,%esp
f01020e3:	6a 00                	push   $0x0
f01020e5:	53                   	push   %ebx
f01020e6:	57                   	push   %edi
f01020e7:	e8 db ef ff ff       	call   f01010c7 <pgdir_walk>
f01020ec:	83 c4 10             	add    $0x10,%esp
f01020ef:	f6 00 1a             	testb  $0x1a,(%eax)
f01020f2:	0f 84 3e 08 00 00    	je     f0102936 <mem_init+0x1547>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f01020f8:	83 ec 04             	sub    $0x4,%esp
f01020fb:	6a 00                	push   $0x0
f01020fd:	53                   	push   %ebx
f01020fe:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0102104:	e8 be ef ff ff       	call   f01010c7 <pgdir_walk>
f0102109:	8b 00                	mov    (%eax),%eax
f010210b:	83 c4 10             	add    $0x10,%esp
f010210e:	83 e0 04             	and    $0x4,%eax
f0102111:	89 c7                	mov    %eax,%edi
f0102113:	0f 85 36 08 00 00    	jne    f010294f <mem_init+0x1560>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102119:	83 ec 04             	sub    $0x4,%esp
f010211c:	6a 00                	push   $0x0
f010211e:	53                   	push   %ebx
f010211f:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0102125:	e8 9d ef ff ff       	call   f01010c7 <pgdir_walk>
f010212a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102130:	83 c4 0c             	add    $0xc,%esp
f0102133:	6a 00                	push   $0x0
f0102135:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102138:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f010213e:	e8 84 ef ff ff       	call   f01010c7 <pgdir_walk>
f0102143:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102149:	83 c4 0c             	add    $0xc,%esp
f010214c:	6a 00                	push   $0x0
f010214e:	56                   	push   %esi
f010214f:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0102155:	e8 6d ef ff ff       	call   f01010c7 <pgdir_walk>
f010215a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102160:	c7 04 24 bf 6f 10 f0 	movl   $0xf0106fbf,(%esp)
f0102167:	e8 c3 18 00 00       	call   f0103a2f <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f010216c:	a1 90 7e 23 f0       	mov    0xf0237e90,%eax
	if ((uint32_t)kva < KERNBASE)
f0102171:	83 c4 10             	add    $0x10,%esp
f0102174:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102179:	0f 86 e9 07 00 00    	jbe    f0102968 <mem_init+0x1579>
f010217f:	83 ec 08             	sub    $0x8,%esp
f0102182:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102184:	05 00 00 00 10       	add    $0x10000000,%eax
f0102189:	50                   	push   %eax
f010218a:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010218f:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102194:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f0102199:	e8 0a f0 ff ff       	call   f01011a8 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f010219e:	a1 48 72 23 f0       	mov    0xf0237248,%eax
	if ((uint32_t)kva < KERNBASE)
f01021a3:	83 c4 10             	add    $0x10,%esp
f01021a6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021ab:	0f 86 cc 07 00 00    	jbe    f010297d <mem_init+0x158e>
f01021b1:	83 ec 08             	sub    $0x8,%esp
f01021b4:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01021b6:	05 00 00 00 10       	add    $0x10000000,%eax
f01021bb:	50                   	push   %eax
f01021bc:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01021c1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01021c6:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f01021cb:	e8 d8 ef ff ff       	call   f01011a8 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f01021d0:	83 c4 10             	add    $0x10,%esp
f01021d3:	b8 00 90 11 f0       	mov    $0xf0119000,%eax
f01021d8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021dd:	0f 86 af 07 00 00    	jbe    f0102992 <mem_init+0x15a3>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f01021e3:	83 ec 08             	sub    $0x8,%esp
f01021e6:	6a 02                	push   $0x2
f01021e8:	68 00 90 11 00       	push   $0x119000
f01021ed:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01021f2:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01021f7:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f01021fc:	e8 a7 ef ff ff       	call   f01011a8 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0xffffffff - KERNBASE, 0, PTE_W);
f0102201:	83 c4 08             	add    $0x8,%esp
f0102204:	6a 02                	push   $0x2
f0102206:	6a 00                	push   $0x0
f0102208:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f010220d:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102212:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f0102217:	e8 8c ef ff ff       	call   f01011a8 <boot_map_region>
f010221c:	c7 45 d0 00 90 23 f0 	movl   $0xf0239000,-0x30(%ebp)
f0102223:	83 c4 10             	add    $0x10,%esp
f0102226:	bb 00 90 23 f0       	mov    $0xf0239000,%ebx
f010222b:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102230:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102236:	0f 86 6b 07 00 00    	jbe    f01029a7 <mem_init+0x15b8>
		boot_map_region(kern_pgdir, 
f010223c:	83 ec 08             	sub    $0x8,%esp
f010223f:	6a 02                	push   $0x2
f0102241:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102247:	50                   	push   %eax
f0102248:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010224d:	89 f2                	mov    %esi,%edx
f010224f:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f0102254:	e8 4f ef ff ff       	call   f01011a8 <boot_map_region>
f0102259:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f010225f:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f0102265:	83 c4 10             	add    $0x10,%esp
f0102268:	81 fb 00 90 27 f0    	cmp    $0xf0279000,%ebx
f010226e:	75 c0                	jne    f0102230 <mem_init+0xe41>
	pgdir = kern_pgdir;
f0102270:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
f0102275:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102278:	a1 88 7e 23 f0       	mov    0xf0237e88,%eax
f010227d:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0102280:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102287:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010228c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010228f:	8b 35 90 7e 23 f0    	mov    0xf0237e90,%esi
f0102295:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f0102298:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f010229e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f01022a1:	89 fb                	mov    %edi,%ebx
f01022a3:	e9 2f 07 00 00       	jmp    f01029d7 <mem_init+0x15e8>
	assert(nfree == 0);
f01022a8:	68 d6 6e 10 f0       	push   $0xf0106ed6
f01022ad:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01022b2:	68 9e 03 00 00       	push   $0x39e
f01022b7:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01022bc:	e8 7f dd ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f01022c1:	68 e4 6d 10 f0       	push   $0xf0106de4
f01022c6:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01022cb:	68 04 04 00 00       	push   $0x404
f01022d0:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01022d5:	e8 66 dd ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01022da:	68 fa 6d 10 f0       	push   $0xf0106dfa
f01022df:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01022e4:	68 05 04 00 00       	push   $0x405
f01022e9:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01022ee:	e8 4d dd ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01022f3:	68 10 6e 10 f0       	push   $0xf0106e10
f01022f8:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01022fd:	68 06 04 00 00       	push   $0x406
f0102302:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102307:	e8 34 dd ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f010230c:	68 26 6e 10 f0       	push   $0xf0106e26
f0102311:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102316:	68 09 04 00 00       	push   $0x409
f010231b:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102320:	e8 1b dd ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102325:	68 2c 72 10 f0       	push   $0xf010722c
f010232a:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010232f:	68 0a 04 00 00       	push   $0x40a
f0102334:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102339:	e8 02 dd ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010233e:	68 8f 6e 10 f0       	push   $0xf0106e8f
f0102343:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102348:	68 11 04 00 00       	push   $0x411
f010234d:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102352:	e8 e9 dc ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102357:	68 6c 72 10 f0       	push   $0xf010726c
f010235c:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102361:	68 14 04 00 00       	push   $0x414
f0102366:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010236b:	e8 d0 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102370:	68 a4 72 10 f0       	push   $0xf01072a4
f0102375:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010237a:	68 17 04 00 00       	push   $0x417
f010237f:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102384:	e8 b7 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102389:	68 d4 72 10 f0       	push   $0xf01072d4
f010238e:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102393:	68 1b 04 00 00       	push   $0x41b
f0102398:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010239d:	e8 9e dc ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01023a2:	68 04 73 10 f0       	push   $0xf0107304
f01023a7:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01023ac:	68 1c 04 00 00       	push   $0x41c
f01023b1:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01023b6:	e8 85 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01023bb:	68 2c 73 10 f0       	push   $0xf010732c
f01023c0:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01023c5:	68 1d 04 00 00       	push   $0x41d
f01023ca:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01023cf:	e8 6c dc ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01023d4:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01023d9:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01023de:	68 1e 04 00 00       	push   $0x41e
f01023e3:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01023e8:	e8 53 dc ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f01023ed:	68 f2 6e 10 f0       	push   $0xf0106ef2
f01023f2:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01023f7:	68 1f 04 00 00       	push   $0x41f
f01023fc:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102401:	e8 3a dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102406:	68 5c 73 10 f0       	push   $0xf010735c
f010240b:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102410:	68 22 04 00 00       	push   $0x422
f0102415:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010241a:	e8 21 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010241f:	68 98 73 10 f0       	push   $0xf0107398
f0102424:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102429:	68 23 04 00 00       	push   $0x423
f010242e:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102433:	e8 08 dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102438:	68 03 6f 10 f0       	push   $0xf0106f03
f010243d:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102442:	68 24 04 00 00       	push   $0x424
f0102447:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010244c:	e8 ef db ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102451:	68 8f 6e 10 f0       	push   $0xf0106e8f
f0102456:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010245b:	68 27 04 00 00       	push   $0x427
f0102460:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102465:	e8 d6 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010246a:	68 5c 73 10 f0       	push   $0xf010735c
f010246f:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102474:	68 2a 04 00 00       	push   $0x42a
f0102479:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010247e:	e8 bd db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102483:	68 98 73 10 f0       	push   $0xf0107398
f0102488:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010248d:	68 2b 04 00 00       	push   $0x42b
f0102492:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102497:	e8 a4 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010249c:	68 03 6f 10 f0       	push   $0xf0106f03
f01024a1:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01024a6:	68 2c 04 00 00       	push   $0x42c
f01024ab:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01024b0:	e8 8b db ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01024b5:	68 8f 6e 10 f0       	push   $0xf0106e8f
f01024ba:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01024bf:	68 30 04 00 00       	push   $0x430
f01024c4:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01024c9:	e8 72 db ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01024ce:	52                   	push   %edx
f01024cf:	68 64 67 10 f0       	push   $0xf0106764
f01024d4:	68 33 04 00 00       	push   $0x433
f01024d9:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01024de:	e8 5d db ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f01024e3:	68 c8 73 10 f0       	push   $0xf01073c8
f01024e8:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01024ed:	68 34 04 00 00       	push   $0x434
f01024f2:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01024f7:	e8 44 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f01024fc:	68 08 74 10 f0       	push   $0xf0107408
f0102501:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102506:	68 37 04 00 00       	push   $0x437
f010250b:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102510:	e8 2b db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102515:	68 98 73 10 f0       	push   $0xf0107398
f010251a:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010251f:	68 38 04 00 00       	push   $0x438
f0102524:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102529:	e8 12 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010252e:	68 03 6f 10 f0       	push   $0xf0106f03
f0102533:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102538:	68 39 04 00 00       	push   $0x439
f010253d:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102542:	e8 f9 da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102547:	68 48 74 10 f0       	push   $0xf0107448
f010254c:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102551:	68 3a 04 00 00       	push   $0x43a
f0102556:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010255b:	e8 e0 da ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102560:	68 14 6f 10 f0       	push   $0xf0106f14
f0102565:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010256a:	68 3b 04 00 00       	push   $0x43b
f010256f:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102574:	e8 c7 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102579:	68 5c 73 10 f0       	push   $0xf010735c
f010257e:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102583:	68 3e 04 00 00       	push   $0x43e
f0102588:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010258d:	e8 ae da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102592:	68 7c 74 10 f0       	push   $0xf010747c
f0102597:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010259c:	68 3f 04 00 00       	push   $0x43f
f01025a1:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01025a6:	e8 95 da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01025ab:	68 b0 74 10 f0       	push   $0xf01074b0
f01025b0:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01025b5:	68 40 04 00 00       	push   $0x440
f01025ba:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01025bf:	e8 7c da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f01025c4:	68 e8 74 10 f0       	push   $0xf01074e8
f01025c9:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01025ce:	68 43 04 00 00       	push   $0x443
f01025d3:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01025d8:	e8 63 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01025dd:	68 20 75 10 f0       	push   $0xf0107520
f01025e2:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01025e7:	68 46 04 00 00       	push   $0x446
f01025ec:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01025f1:	e8 4a da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01025f6:	68 b0 74 10 f0       	push   $0xf01074b0
f01025fb:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102600:	68 47 04 00 00       	push   $0x447
f0102605:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010260a:	e8 31 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010260f:	68 5c 75 10 f0       	push   $0xf010755c
f0102614:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102619:	68 4a 04 00 00       	push   $0x44a
f010261e:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102623:	e8 18 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102628:	68 88 75 10 f0       	push   $0xf0107588
f010262d:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102632:	68 4b 04 00 00       	push   $0x44b
f0102637:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010263c:	e8 ff d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f0102641:	68 2a 6f 10 f0       	push   $0xf0106f2a
f0102646:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010264b:	68 4d 04 00 00       	push   $0x44d
f0102650:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102655:	e8 e6 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010265a:	68 3b 6f 10 f0       	push   $0xf0106f3b
f010265f:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102664:	68 4e 04 00 00       	push   $0x44e
f0102669:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010266e:	e8 cd d9 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102673:	68 b8 75 10 f0       	push   $0xf01075b8
f0102678:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010267d:	68 51 04 00 00       	push   $0x451
f0102682:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102687:	e8 b4 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010268c:	68 dc 75 10 f0       	push   $0xf01075dc
f0102691:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102696:	68 55 04 00 00       	push   $0x455
f010269b:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01026a0:	e8 9b d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01026a5:	68 88 75 10 f0       	push   $0xf0107588
f01026aa:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01026af:	68 56 04 00 00       	push   $0x456
f01026b4:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01026b9:	e8 82 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01026be:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01026c3:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01026c8:	68 57 04 00 00       	push   $0x457
f01026cd:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01026d2:	e8 69 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01026d7:	68 3b 6f 10 f0       	push   $0xf0106f3b
f01026dc:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01026e1:	68 58 04 00 00       	push   $0x458
f01026e6:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01026eb:	e8 50 d9 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01026f0:	68 00 76 10 f0       	push   $0xf0107600
f01026f5:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01026fa:	68 5b 04 00 00       	push   $0x45b
f01026ff:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102704:	e8 37 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f0102709:	68 4c 6f 10 f0       	push   $0xf0106f4c
f010270e:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102713:	68 5c 04 00 00       	push   $0x45c
f0102718:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010271d:	e8 1e d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f0102722:	68 58 6f 10 f0       	push   $0xf0106f58
f0102727:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010272c:	68 5d 04 00 00       	push   $0x45d
f0102731:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102736:	e8 05 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010273b:	68 dc 75 10 f0       	push   $0xf01075dc
f0102740:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102745:	68 61 04 00 00       	push   $0x461
f010274a:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010274f:	e8 ec d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102754:	68 38 76 10 f0       	push   $0xf0107638
f0102759:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010275e:	68 62 04 00 00       	push   $0x462
f0102763:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102768:	e8 d3 d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f010276d:	68 6d 6f 10 f0       	push   $0xf0106f6d
f0102772:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102777:	68 63 04 00 00       	push   $0x463
f010277c:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102781:	e8 ba d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102786:	68 3b 6f 10 f0       	push   $0xf0106f3b
f010278b:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102790:	68 64 04 00 00       	push   $0x464
f0102795:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010279a:	e8 a1 d8 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f010279f:	68 60 76 10 f0       	push   $0xf0107660
f01027a4:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01027a9:	68 67 04 00 00       	push   $0x467
f01027ae:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01027b3:	e8 88 d8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01027b8:	68 8f 6e 10 f0       	push   $0xf0106e8f
f01027bd:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01027c2:	68 6a 04 00 00       	push   $0x46a
f01027c7:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01027cc:	e8 6f d8 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01027d1:	68 04 73 10 f0       	push   $0xf0107304
f01027d6:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01027db:	68 6d 04 00 00       	push   $0x46d
f01027e0:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01027e5:	e8 56 d8 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f01027ea:	68 f2 6e 10 f0       	push   $0xf0106ef2
f01027ef:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01027f4:	68 6f 04 00 00       	push   $0x46f
f01027f9:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01027fe:	e8 3d d8 ff ff       	call   f0100040 <_panic>
f0102803:	56                   	push   %esi
f0102804:	68 64 67 10 f0       	push   $0xf0106764
f0102809:	68 76 04 00 00       	push   $0x476
f010280e:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102813:	e8 28 d8 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102818:	68 7e 6f 10 f0       	push   $0xf0106f7e
f010281d:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102822:	68 77 04 00 00       	push   $0x477
f0102827:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010282c:	e8 0f d8 ff ff       	call   f0100040 <_panic>
f0102831:	51                   	push   %ecx
f0102832:	68 64 67 10 f0       	push   $0xf0106764
f0102837:	6a 58                	push   $0x58
f0102839:	68 02 6d 10 f0       	push   $0xf0106d02
f010283e:	e8 fd d7 ff ff       	call   f0100040 <_panic>
f0102843:	52                   	push   %edx
f0102844:	68 64 67 10 f0       	push   $0xf0106764
f0102849:	6a 58                	push   $0x58
f010284b:	68 02 6d 10 f0       	push   $0xf0106d02
f0102850:	e8 eb d7 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102855:	68 96 6f 10 f0       	push   $0xf0106f96
f010285a:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010285f:	68 81 04 00 00       	push   $0x481
f0102864:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102869:	e8 d2 d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f010286e:	68 84 76 10 f0       	push   $0xf0107684
f0102873:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102878:	68 91 04 00 00       	push   $0x491
f010287d:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102882:	e8 b9 d7 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102887:	68 ac 76 10 f0       	push   $0xf01076ac
f010288c:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102891:	68 92 04 00 00       	push   $0x492
f0102896:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010289b:	e8 a0 d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01028a0:	68 d4 76 10 f0       	push   $0xf01076d4
f01028a5:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01028aa:	68 94 04 00 00       	push   $0x494
f01028af:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01028b4:	e8 87 d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f01028b9:	68 ad 6f 10 f0       	push   $0xf0106fad
f01028be:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01028c3:	68 96 04 00 00       	push   $0x496
f01028c8:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01028cd:	e8 6e d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01028d2:	68 fc 76 10 f0       	push   $0xf01076fc
f01028d7:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01028dc:	68 98 04 00 00       	push   $0x498
f01028e1:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01028e6:	e8 55 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f01028eb:	68 20 77 10 f0       	push   $0xf0107720
f01028f0:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01028f5:	68 99 04 00 00       	push   $0x499
f01028fa:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01028ff:	e8 3c d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102904:	68 50 77 10 f0       	push   $0xf0107750
f0102909:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010290e:	68 9a 04 00 00       	push   $0x49a
f0102913:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102918:	e8 23 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f010291d:	68 74 77 10 f0       	push   $0xf0107774
f0102922:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102927:	68 9b 04 00 00       	push   $0x49b
f010292c:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102931:	e8 0a d7 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102936:	68 a0 77 10 f0       	push   $0xf01077a0
f010293b:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102940:	68 9d 04 00 00       	push   $0x49d
f0102945:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010294a:	e8 f1 d6 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f010294f:	68 e4 77 10 f0       	push   $0xf01077e4
f0102954:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102959:	68 9e 04 00 00       	push   $0x49e
f010295e:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102963:	e8 d8 d6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102968:	50                   	push   %eax
f0102969:	68 88 67 10 f0       	push   $0xf0106788
f010296e:	68 c8 00 00 00       	push   $0xc8
f0102973:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102978:	e8 c3 d6 ff ff       	call   f0100040 <_panic>
f010297d:	50                   	push   %eax
f010297e:	68 88 67 10 f0       	push   $0xf0106788
f0102983:	68 d3 00 00 00       	push   $0xd3
f0102988:	68 f6 6c 10 f0       	push   $0xf0106cf6
f010298d:	e8 ae d6 ff ff       	call   f0100040 <_panic>
f0102992:	50                   	push   %eax
f0102993:	68 88 67 10 f0       	push   $0xf0106788
f0102998:	68 e0 00 00 00       	push   $0xe0
f010299d:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01029a2:	e8 99 d6 ff ff       	call   f0100040 <_panic>
f01029a7:	53                   	push   %ebx
f01029a8:	68 88 67 10 f0       	push   $0xf0106788
f01029ad:	68 22 01 00 00       	push   $0x122
f01029b2:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01029b7:	e8 84 d6 ff ff       	call   f0100040 <_panic>
f01029bc:	56                   	push   %esi
f01029bd:	68 88 67 10 f0       	push   $0xf0106788
f01029c2:	68 b6 03 00 00       	push   $0x3b6
f01029c7:	68 f6 6c 10 f0       	push   $0xf0106cf6
f01029cc:	e8 6f d6 ff ff       	call   f0100040 <_panic>
	for (i = 0; i < n; i += PGSIZE)
f01029d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01029d7:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f01029da:	76 3a                	jbe    f0102a16 <mem_init+0x1627>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01029dc:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f01029e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01029e5:	e8 30 e1 ff ff       	call   f0100b1a <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01029ea:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f01029f1:	76 c9                	jbe    f01029bc <mem_init+0x15cd>
f01029f3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f01029f6:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f01029f9:	39 d0                	cmp    %edx,%eax
f01029fb:	74 d4                	je     f01029d1 <mem_init+0x15e2>
f01029fd:	68 18 78 10 f0       	push   $0xf0107818
f0102a02:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102a07:	68 b6 03 00 00       	push   $0x3b6
f0102a0c:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102a11:	e8 2a d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102a16:	a1 48 72 23 f0       	mov    0xf0237248,%eax
f0102a1b:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0102a1e:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102a21:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102a26:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102a2c:	89 da                	mov    %ebx,%edx
f0102a2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a31:	e8 e4 e0 ff ff       	call   f0100b1a <check_va2pa>
f0102a36:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102a3d:	76 3b                	jbe    f0102a7a <mem_init+0x168b>
f0102a3f:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102a42:	39 d0                	cmp    %edx,%eax
f0102a44:	75 4b                	jne    f0102a91 <mem_init+0x16a2>
f0102a46:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102a4c:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f0102a52:	75 d8                	jne    f0102a2c <mem_init+0x163d>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102a54:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102a57:	c1 e6 0c             	shl    $0xc,%esi
f0102a5a:	89 fb                	mov    %edi,%ebx
f0102a5c:	39 f3                	cmp    %esi,%ebx
f0102a5e:	73 63                	jae    f0102ac3 <mem_init+0x16d4>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102a60:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102a66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a69:	e8 ac e0 ff ff       	call   f0100b1a <check_va2pa>
f0102a6e:	39 c3                	cmp    %eax,%ebx
f0102a70:	75 38                	jne    f0102aaa <mem_init+0x16bb>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102a72:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102a78:	eb e2                	jmp    f0102a5c <mem_init+0x166d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102a7a:	ff 75 c8             	pushl  -0x38(%ebp)
f0102a7d:	68 88 67 10 f0       	push   $0xf0106788
f0102a82:	68 bb 03 00 00       	push   $0x3bb
f0102a87:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102a8c:	e8 af d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102a91:	68 4c 78 10 f0       	push   $0xf010784c
f0102a96:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102a9b:	68 bb 03 00 00       	push   $0x3bb
f0102aa0:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102aa5:	e8 96 d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102aaa:	68 80 78 10 f0       	push   $0xf0107880
f0102aaf:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102ab4:	68 bf 03 00 00       	push   $0x3bf
f0102ab9:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102abe:	e8 7d d5 ff ff       	call   f0100040 <_panic>
f0102ac3:	c7 45 cc 00 90 24 00 	movl   $0x249000,-0x34(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102aca:	bb 00 80 ff ef       	mov    $0xefff8000,%ebx
f0102acf:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102ad2:	8d bb 00 80 ff ff    	lea    -0x8000(%ebx),%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102ad8:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102adb:	89 45 bc             	mov    %eax,-0x44(%ebp)
f0102ade:	89 de                	mov    %ebx,%esi
f0102ae0:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102ae3:	05 00 80 ff 0f       	add    $0xfff8000,%eax
f0102ae8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102aeb:	8d 83 00 80 00 00    	lea    0x8000(%ebx),%eax
f0102af1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102af4:	89 f2                	mov    %esi,%edx
f0102af6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102af9:	e8 1c e0 ff ff       	call   f0100b1a <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102afe:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102b05:	76 58                	jbe    f0102b5f <mem_init+0x1770>
f0102b07:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0102b0a:	8d 14 31             	lea    (%ecx,%esi,1),%edx
f0102b0d:	39 d0                	cmp    %edx,%eax
f0102b0f:	75 65                	jne    f0102b76 <mem_init+0x1787>
f0102b11:	81 c6 00 10 00 00    	add    $0x1000,%esi
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102b17:	3b 75 c4             	cmp    -0x3c(%ebp),%esi
f0102b1a:	75 d8                	jne    f0102af4 <mem_init+0x1705>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102b1c:	89 fa                	mov    %edi,%edx
f0102b1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b21:	e8 f4 df ff ff       	call   f0100b1a <check_va2pa>
f0102b26:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102b29:	75 64                	jne    f0102b8f <mem_init+0x17a0>
f0102b2b:	81 c7 00 10 00 00    	add    $0x1000,%edi
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102b31:	39 df                	cmp    %ebx,%edi
f0102b33:	75 e7                	jne    f0102b1c <mem_init+0x172d>
f0102b35:	81 eb 00 00 01 00    	sub    $0x10000,%ebx
f0102b3b:	81 45 d0 00 80 00 00 	addl   $0x8000,-0x30(%ebp)
f0102b42:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102b45:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
	for (n = 0; n < NCPU; n++) {
f0102b4c:	3d 00 90 27 f0       	cmp    $0xf0279000,%eax
f0102b51:	0f 85 7b ff ff ff    	jne    f0102ad2 <mem_init+0x16e3>
f0102b57:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0102b5a:	e9 84 00 00 00       	jmp    f0102be3 <mem_init+0x17f4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102b5f:	ff 75 bc             	pushl  -0x44(%ebp)
f0102b62:	68 88 67 10 f0       	push   $0xf0106788
f0102b67:	68 c7 03 00 00       	push   $0x3c7
f0102b6c:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102b71:	e8 ca d4 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102b76:	68 a8 78 10 f0       	push   $0xf01078a8
f0102b7b:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102b80:	68 c6 03 00 00       	push   $0x3c6
f0102b85:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102b8a:	e8 b1 d4 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102b8f:	68 f0 78 10 f0       	push   $0xf01078f0
f0102b94:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102b99:	68 c9 03 00 00       	push   $0x3c9
f0102b9e:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102ba3:	e8 98 d4 ff ff       	call   f0100040 <_panic>
			assert(pgdir[i] & PTE_P);
f0102ba8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102bab:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102baf:	75 4e                	jne    f0102bff <mem_init+0x1810>
f0102bb1:	68 d8 6f 10 f0       	push   $0xf0106fd8
f0102bb6:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102bbb:	68 d4 03 00 00       	push   $0x3d4
f0102bc0:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102bc5:	e8 76 d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102bca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102bcd:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0102bd0:	a8 01                	test   $0x1,%al
f0102bd2:	74 30                	je     f0102c04 <mem_init+0x1815>
				assert(pgdir[i] & PTE_W);
f0102bd4:	a8 02                	test   $0x2,%al
f0102bd6:	74 45                	je     f0102c1d <mem_init+0x182e>
	for (i = 0; i < NPDENTRIES; i++) {
f0102bd8:	83 c7 01             	add    $0x1,%edi
f0102bdb:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0102be1:	74 6c                	je     f0102c4f <mem_init+0x1860>
		switch (i) {
f0102be3:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f0102be9:	83 f8 04             	cmp    $0x4,%eax
f0102bec:	76 ba                	jbe    f0102ba8 <mem_init+0x17b9>
			if (i >= PDX(KERNBASE)) {
f0102bee:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102bf4:	77 d4                	ja     f0102bca <mem_init+0x17db>
				assert(pgdir[i] == 0);
f0102bf6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102bf9:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102bfd:	75 37                	jne    f0102c36 <mem_init+0x1847>
	for (i = 0; i < NPDENTRIES; i++) {
f0102bff:	83 c7 01             	add    $0x1,%edi
f0102c02:	eb df                	jmp    f0102be3 <mem_init+0x17f4>
				assert(pgdir[i] & PTE_P);
f0102c04:	68 d8 6f 10 f0       	push   $0xf0106fd8
f0102c09:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102c0e:	68 d8 03 00 00       	push   $0x3d8
f0102c13:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102c18:	e8 23 d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f0102c1d:	68 e9 6f 10 f0       	push   $0xf0106fe9
f0102c22:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102c27:	68 d9 03 00 00       	push   $0x3d9
f0102c2c:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102c31:	e8 0a d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102c36:	68 fa 6f 10 f0       	push   $0xf0106ffa
f0102c3b:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102c40:	68 db 03 00 00       	push   $0x3db
f0102c45:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102c4a:	e8 f1 d3 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102c4f:	83 ec 0c             	sub    $0xc,%esp
f0102c52:	68 14 79 10 f0       	push   $0xf0107914
f0102c57:	e8 d3 0d 00 00       	call   f0103a2f <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102c5c:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0102c61:	83 c4 10             	add    $0x10,%esp
f0102c64:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102c69:	0f 86 03 02 00 00    	jbe    f0102e72 <mem_init+0x1a83>
	return (physaddr_t)kva - KERNBASE;
f0102c6f:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102c74:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102c77:	b8 00 00 00 00       	mov    $0x0,%eax
f0102c7c:	e8 fc de ff ff       	call   f0100b7d <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102c81:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102c84:	83 e0 f3             	and    $0xfffffff3,%eax
f0102c87:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102c8c:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102c8f:	83 ec 0c             	sub    $0xc,%esp
f0102c92:	6a 00                	push   $0x0
f0102c94:	e8 20 e3 ff ff       	call   f0100fb9 <page_alloc>
f0102c99:	89 c6                	mov    %eax,%esi
f0102c9b:	83 c4 10             	add    $0x10,%esp
f0102c9e:	85 c0                	test   %eax,%eax
f0102ca0:	0f 84 e1 01 00 00    	je     f0102e87 <mem_init+0x1a98>
	assert((pp1 = page_alloc(0)));
f0102ca6:	83 ec 0c             	sub    $0xc,%esp
f0102ca9:	6a 00                	push   $0x0
f0102cab:	e8 09 e3 ff ff       	call   f0100fb9 <page_alloc>
f0102cb0:	89 c7                	mov    %eax,%edi
f0102cb2:	83 c4 10             	add    $0x10,%esp
f0102cb5:	85 c0                	test   %eax,%eax
f0102cb7:	0f 84 e3 01 00 00    	je     f0102ea0 <mem_init+0x1ab1>
	assert((pp2 = page_alloc(0)));
f0102cbd:	83 ec 0c             	sub    $0xc,%esp
f0102cc0:	6a 00                	push   $0x0
f0102cc2:	e8 f2 e2 ff ff       	call   f0100fb9 <page_alloc>
f0102cc7:	89 c3                	mov    %eax,%ebx
f0102cc9:	83 c4 10             	add    $0x10,%esp
f0102ccc:	85 c0                	test   %eax,%eax
f0102cce:	0f 84 e5 01 00 00    	je     f0102eb9 <mem_init+0x1aca>
	page_free(pp0);
f0102cd4:	83 ec 0c             	sub    $0xc,%esp
f0102cd7:	56                   	push   %esi
f0102cd8:	e8 67 e3 ff ff       	call   f0101044 <page_free>
	return (pp - pages) << PGSHIFT;
f0102cdd:	89 f8                	mov    %edi,%eax
f0102cdf:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0102ce5:	c1 f8 03             	sar    $0x3,%eax
f0102ce8:	89 c2                	mov    %eax,%edx
f0102cea:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102ced:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102cf2:	83 c4 10             	add    $0x10,%esp
f0102cf5:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f0102cfb:	0f 83 d1 01 00 00    	jae    f0102ed2 <mem_init+0x1ae3>
	memset(page2kva(pp1), 1, PGSIZE);
f0102d01:	83 ec 04             	sub    $0x4,%esp
f0102d04:	68 00 10 00 00       	push   $0x1000
f0102d09:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102d0b:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102d11:	52                   	push   %edx
f0102d12:	e8 83 2d 00 00       	call   f0105a9a <memset>
	return (pp - pages) << PGSHIFT;
f0102d17:	89 d8                	mov    %ebx,%eax
f0102d19:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0102d1f:	c1 f8 03             	sar    $0x3,%eax
f0102d22:	89 c2                	mov    %eax,%edx
f0102d24:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102d27:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102d2c:	83 c4 10             	add    $0x10,%esp
f0102d2f:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f0102d35:	0f 83 a9 01 00 00    	jae    f0102ee4 <mem_init+0x1af5>
	memset(page2kva(pp2), 2, PGSIZE);
f0102d3b:	83 ec 04             	sub    $0x4,%esp
f0102d3e:	68 00 10 00 00       	push   $0x1000
f0102d43:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102d45:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102d4b:	52                   	push   %edx
f0102d4c:	e8 49 2d 00 00       	call   f0105a9a <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102d51:	6a 02                	push   $0x2
f0102d53:	68 00 10 00 00       	push   $0x1000
f0102d58:	57                   	push   %edi
f0102d59:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0102d5f:	e8 91 e5 ff ff       	call   f01012f5 <page_insert>
	assert(pp1->pp_ref == 1);
f0102d64:	83 c4 20             	add    $0x20,%esp
f0102d67:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102d6c:	0f 85 84 01 00 00    	jne    f0102ef6 <mem_init+0x1b07>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102d72:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102d79:	01 01 01 
f0102d7c:	0f 85 8d 01 00 00    	jne    f0102f0f <mem_init+0x1b20>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102d82:	6a 02                	push   $0x2
f0102d84:	68 00 10 00 00       	push   $0x1000
f0102d89:	53                   	push   %ebx
f0102d8a:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0102d90:	e8 60 e5 ff ff       	call   f01012f5 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102d95:	83 c4 10             	add    $0x10,%esp
f0102d98:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102d9f:	02 02 02 
f0102da2:	0f 85 80 01 00 00    	jne    f0102f28 <mem_init+0x1b39>
	assert(pp2->pp_ref == 1);
f0102da8:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102dad:	0f 85 8e 01 00 00    	jne    f0102f41 <mem_init+0x1b52>
	assert(pp1->pp_ref == 0);
f0102db3:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102db8:	0f 85 9c 01 00 00    	jne    f0102f5a <mem_init+0x1b6b>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102dbe:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102dc5:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102dc8:	89 d8                	mov    %ebx,%eax
f0102dca:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0102dd0:	c1 f8 03             	sar    $0x3,%eax
f0102dd3:	89 c2                	mov    %eax,%edx
f0102dd5:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102dd8:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102ddd:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f0102de3:	0f 83 8a 01 00 00    	jae    f0102f73 <mem_init+0x1b84>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102de9:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f0102df0:	03 03 03 
f0102df3:	0f 85 8c 01 00 00    	jne    f0102f85 <mem_init+0x1b96>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102df9:	83 ec 08             	sub    $0x8,%esp
f0102dfc:	68 00 10 00 00       	push   $0x1000
f0102e01:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f0102e07:	e8 9f e4 ff ff       	call   f01012ab <page_remove>
	assert(pp2->pp_ref == 0);
f0102e0c:	83 c4 10             	add    $0x10,%esp
f0102e0f:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102e14:	0f 85 84 01 00 00    	jne    f0102f9e <mem_init+0x1baf>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102e1a:	8b 0d 8c 7e 23 f0    	mov    0xf0237e8c,%ecx
f0102e20:	8b 11                	mov    (%ecx),%edx
f0102e22:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102e28:	89 f0                	mov    %esi,%eax
f0102e2a:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f0102e30:	c1 f8 03             	sar    $0x3,%eax
f0102e33:	c1 e0 0c             	shl    $0xc,%eax
f0102e36:	39 c2                	cmp    %eax,%edx
f0102e38:	0f 85 79 01 00 00    	jne    f0102fb7 <mem_init+0x1bc8>
	kern_pgdir[0] = 0;
f0102e3e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102e44:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102e49:	0f 85 81 01 00 00    	jne    f0102fd0 <mem_init+0x1be1>
	pp0->pp_ref = 0;
f0102e4f:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0102e55:	83 ec 0c             	sub    $0xc,%esp
f0102e58:	56                   	push   %esi
f0102e59:	e8 e6 e1 ff ff       	call   f0101044 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102e5e:	c7 04 24 a8 79 10 f0 	movl   $0xf01079a8,(%esp)
f0102e65:	e8 c5 0b 00 00       	call   f0103a2f <cprintf>
}
f0102e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102e6d:	5b                   	pop    %ebx
f0102e6e:	5e                   	pop    %esi
f0102e6f:	5f                   	pop    %edi
f0102e70:	5d                   	pop    %ebp
f0102e71:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102e72:	50                   	push   %eax
f0102e73:	68 88 67 10 f0       	push   $0xf0106788
f0102e78:	68 f9 00 00 00       	push   $0xf9
f0102e7d:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102e82:	e8 b9 d1 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102e87:	68 e4 6d 10 f0       	push   $0xf0106de4
f0102e8c:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102e91:	68 b3 04 00 00       	push   $0x4b3
f0102e96:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102e9b:	e8 a0 d1 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102ea0:	68 fa 6d 10 f0       	push   $0xf0106dfa
f0102ea5:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102eaa:	68 b4 04 00 00       	push   $0x4b4
f0102eaf:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102eb4:	e8 87 d1 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102eb9:	68 10 6e 10 f0       	push   $0xf0106e10
f0102ebe:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102ec3:	68 b5 04 00 00       	push   $0x4b5
f0102ec8:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102ecd:	e8 6e d1 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102ed2:	52                   	push   %edx
f0102ed3:	68 64 67 10 f0       	push   $0xf0106764
f0102ed8:	6a 58                	push   $0x58
f0102eda:	68 02 6d 10 f0       	push   $0xf0106d02
f0102edf:	e8 5c d1 ff ff       	call   f0100040 <_panic>
f0102ee4:	52                   	push   %edx
f0102ee5:	68 64 67 10 f0       	push   $0xf0106764
f0102eea:	6a 58                	push   $0x58
f0102eec:	68 02 6d 10 f0       	push   $0xf0106d02
f0102ef1:	e8 4a d1 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102ef6:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102efb:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102f00:	68 ba 04 00 00       	push   $0x4ba
f0102f05:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102f0a:	e8 31 d1 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102f0f:	68 34 79 10 f0       	push   $0xf0107934
f0102f14:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102f19:	68 bb 04 00 00       	push   $0x4bb
f0102f1e:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102f23:	e8 18 d1 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102f28:	68 58 79 10 f0       	push   $0xf0107958
f0102f2d:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102f32:	68 bd 04 00 00       	push   $0x4bd
f0102f37:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102f3c:	e8 ff d0 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102f41:	68 03 6f 10 f0       	push   $0xf0106f03
f0102f46:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102f4b:	68 be 04 00 00       	push   $0x4be
f0102f50:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102f55:	e8 e6 d0 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102f5a:	68 6d 6f 10 f0       	push   $0xf0106f6d
f0102f5f:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102f64:	68 bf 04 00 00       	push   $0x4bf
f0102f69:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102f6e:	e8 cd d0 ff ff       	call   f0100040 <_panic>
f0102f73:	52                   	push   %edx
f0102f74:	68 64 67 10 f0       	push   $0xf0106764
f0102f79:	6a 58                	push   $0x58
f0102f7b:	68 02 6d 10 f0       	push   $0xf0106d02
f0102f80:	e8 bb d0 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102f85:	68 7c 79 10 f0       	push   $0xf010797c
f0102f8a:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102f8f:	68 c1 04 00 00       	push   $0x4c1
f0102f94:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102f99:	e8 a2 d0 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102f9e:	68 3b 6f 10 f0       	push   $0xf0106f3b
f0102fa3:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102fa8:	68 c3 04 00 00       	push   $0x4c3
f0102fad:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102fb2:	e8 89 d0 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102fb7:	68 04 73 10 f0       	push   $0xf0107304
f0102fbc:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102fc1:	68 c6 04 00 00       	push   $0x4c6
f0102fc6:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102fcb:	e8 70 d0 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102fd0:	68 f2 6e 10 f0       	push   $0xf0106ef2
f0102fd5:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0102fda:	68 c8 04 00 00       	push   $0x4c8
f0102fdf:	68 f6 6c 10 f0       	push   $0xf0106cf6
f0102fe4:	e8 57 d0 ff ff       	call   f0100040 <_panic>

f0102fe9 <user_mem_check>:
{
f0102fe9:	f3 0f 1e fb          	endbr32 
f0102fed:	55                   	push   %ebp
f0102fee:	89 e5                	mov    %esp,%ebp
f0102ff0:	57                   	push   %edi
f0102ff1:	56                   	push   %esi
f0102ff2:	53                   	push   %ebx
f0102ff3:	83 ec 0c             	sub    $0xc,%esp
    vstart = ROUNDDOWN((uintptr_t)va, PGSIZE);
f0102ff6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102ff9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    vend = ROUNDUP((uintptr_t)va + len, PGSIZE);
f0102fff:	8b 45 10             	mov    0x10(%ebp),%eax
f0103002:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103005:	8d bc 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edi
f010300c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if (vend > ULIM) {
f0103012:	81 ff 00 00 80 ef    	cmp    $0xef800000,%edi
f0103018:	77 08                	ja     f0103022 <user_mem_check+0x39>
        if (!pte || (*pte & (perm | PTE_P)) != (perm | PTE_P)) {
f010301a:	8b 75 14             	mov    0x14(%ebp),%esi
f010301d:	83 ce 01             	or     $0x1,%esi
f0103020:	eb 22                	jmp    f0103044 <user_mem_check+0x5b>
        user_mem_check_addr = MAX(ULIM, (uintptr_t)va);
f0103022:	81 7d 0c 00 00 80 ef 	cmpl   $0xef800000,0xc(%ebp)
f0103029:	b8 00 00 80 ef       	mov    $0xef800000,%eax
f010302e:	0f 43 45 0c          	cmovae 0xc(%ebp),%eax
f0103032:	a3 3c 72 23 f0       	mov    %eax,0xf023723c
        return -E_FAULT;
f0103037:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f010303c:	eb 3c                	jmp    f010307a <user_mem_check+0x91>
    for (; vstart < vend; vstart += PGSIZE) {
f010303e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103044:	39 fb                	cmp    %edi,%ebx
f0103046:	73 3a                	jae    f0103082 <user_mem_check+0x99>
        pte = pgdir_walk(env->env_pgdir, (void*)vstart, 0);
f0103048:	83 ec 04             	sub    $0x4,%esp
f010304b:	6a 00                	push   $0x0
f010304d:	53                   	push   %ebx
f010304e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103051:	ff 70 60             	pushl  0x60(%eax)
f0103054:	e8 6e e0 ff ff       	call   f01010c7 <pgdir_walk>
        if (!pte || (*pte & (perm | PTE_P)) != (perm | PTE_P)) {
f0103059:	83 c4 10             	add    $0x10,%esp
f010305c:	85 c0                	test   %eax,%eax
f010305e:	74 08                	je     f0103068 <user_mem_check+0x7f>
f0103060:	89 f2                	mov    %esi,%edx
f0103062:	23 10                	and    (%eax),%edx
f0103064:	39 d6                	cmp    %edx,%esi
f0103066:	74 d6                	je     f010303e <user_mem_check+0x55>
            user_mem_check_addr = MAX(vstart, (uintptr_t)va);
f0103068:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f010306b:	0f 42 5d 0c          	cmovb  0xc(%ebp),%ebx
f010306f:	89 1d 3c 72 23 f0    	mov    %ebx,0xf023723c
            return -E_FAULT;
f0103075:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f010307a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010307d:	5b                   	pop    %ebx
f010307e:	5e                   	pop    %esi
f010307f:	5f                   	pop    %edi
f0103080:	5d                   	pop    %ebp
f0103081:	c3                   	ret    
    return 0;
f0103082:	b8 00 00 00 00       	mov    $0x0,%eax
f0103087:	eb f1                	jmp    f010307a <user_mem_check+0x91>

f0103089 <user_mem_assert>:
{
f0103089:	f3 0f 1e fb          	endbr32 
f010308d:	55                   	push   %ebp
f010308e:	89 e5                	mov    %esp,%ebp
f0103090:	53                   	push   %ebx
f0103091:	83 ec 04             	sub    $0x4,%esp
f0103094:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103097:	8b 45 14             	mov    0x14(%ebp),%eax
f010309a:	83 c8 04             	or     $0x4,%eax
f010309d:	50                   	push   %eax
f010309e:	ff 75 10             	pushl  0x10(%ebp)
f01030a1:	ff 75 0c             	pushl  0xc(%ebp)
f01030a4:	53                   	push   %ebx
f01030a5:	e8 3f ff ff ff       	call   f0102fe9 <user_mem_check>
f01030aa:	83 c4 10             	add    $0x10,%esp
f01030ad:	85 c0                	test   %eax,%eax
f01030af:	78 05                	js     f01030b6 <user_mem_assert+0x2d>
}
f01030b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01030b4:	c9                   	leave  
f01030b5:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f01030b6:	83 ec 04             	sub    $0x4,%esp
f01030b9:	ff 35 3c 72 23 f0    	pushl  0xf023723c
f01030bf:	ff 73 48             	pushl  0x48(%ebx)
f01030c2:	68 d4 79 10 f0       	push   $0xf01079d4
f01030c7:	e8 63 09 00 00       	call   f0103a2f <cprintf>
		env_destroy(env);	// may not return
f01030cc:	89 1c 24             	mov    %ebx,(%esp)
f01030cf:	e8 70 06 00 00       	call   f0103744 <env_destroy>
f01030d4:	83 c4 10             	add    $0x10,%esp
}
f01030d7:	eb d8                	jmp    f01030b1 <user_mem_assert+0x28>

f01030d9 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f01030d9:	55                   	push   %ebp
f01030da:	89 e5                	mov    %esp,%ebp
f01030dc:	57                   	push   %edi
f01030dd:	56                   	push   %esi
f01030de:	53                   	push   %ebx
f01030df:	83 ec 0c             	sub    $0xc,%esp
f01030e2:	89 c7                	mov    %eax,%edi
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	// ROUNDDOWN/ROUNDUP在inc/types.h中
	void* begin = ROUNDDOWN(va, PGSIZE);
f01030e4:	89 d3                	mov    %edx,%ebx
f01030e6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	void* end = ROUNDUP(va + len, PGSIZE);
f01030ec:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f01030f3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	while(begin < end){
f01030f9:	39 f3                	cmp    %esi,%ebx
f01030fb:	73 3f                	jae    f010313c <region_alloc+0x63>
		struct PageInfo* pp = page_alloc(0);
f01030fd:	83 ec 0c             	sub    $0xc,%esp
f0103100:	6a 00                	push   $0x0
f0103102:	e8 b2 de ff ff       	call   f0100fb9 <page_alloc>
		if(!pp){
f0103107:	83 c4 10             	add    $0x10,%esp
f010310a:	85 c0                	test   %eax,%eax
f010310c:	74 17                	je     f0103125 <region_alloc+0x4c>
			panic("region_alloc failed\n");
		}
		page_insert(e->env_pgdir, pp, begin, PTE_W | PTE_U);
f010310e:	6a 06                	push   $0x6
f0103110:	53                   	push   %ebx
f0103111:	50                   	push   %eax
f0103112:	ff 77 60             	pushl  0x60(%edi)
f0103115:	e8 db e1 ff ff       	call   f01012f5 <page_insert>
		begin += PGSIZE;
f010311a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103120:	83 c4 10             	add    $0x10,%esp
f0103123:	eb d4                	jmp    f01030f9 <region_alloc+0x20>
			panic("region_alloc failed\n");
f0103125:	83 ec 04             	sub    $0x4,%esp
f0103128:	68 09 7a 10 f0       	push   $0xf0107a09
f010312d:	68 2c 01 00 00       	push   $0x12c
f0103132:	68 1e 7a 10 f0       	push   $0xf0107a1e
f0103137:	e8 04 cf ff ff       	call   f0100040 <_panic>
	}
}
f010313c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010313f:	5b                   	pop    %ebx
f0103140:	5e                   	pop    %esi
f0103141:	5f                   	pop    %edi
f0103142:	5d                   	pop    %ebp
f0103143:	c3                   	ret    

f0103144 <envid2env>:
{
f0103144:	f3 0f 1e fb          	endbr32 
f0103148:	55                   	push   %ebp
f0103149:	89 e5                	mov    %esp,%ebp
f010314b:	56                   	push   %esi
f010314c:	53                   	push   %ebx
f010314d:	8b 75 08             	mov    0x8(%ebp),%esi
f0103150:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f0103153:	85 f6                	test   %esi,%esi
f0103155:	74 2e                	je     f0103185 <envid2env+0x41>
	e = &envs[ENVX(envid)];
f0103157:	89 f3                	mov    %esi,%ebx
f0103159:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f010315f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103162:	03 1d 48 72 23 f0    	add    0xf0237248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103168:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f010316c:	74 2e                	je     f010319c <envid2env+0x58>
f010316e:	39 73 48             	cmp    %esi,0x48(%ebx)
f0103171:	75 29                	jne    f010319c <envid2env+0x58>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103173:	84 c0                	test   %al,%al
f0103175:	75 35                	jne    f01031ac <envid2env+0x68>
	*env_store = e;
f0103177:	8b 45 0c             	mov    0xc(%ebp),%eax
f010317a:	89 18                	mov    %ebx,(%eax)
	return 0;
f010317c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103181:	5b                   	pop    %ebx
f0103182:	5e                   	pop    %esi
f0103183:	5d                   	pop    %ebp
f0103184:	c3                   	ret    
		*env_store = curenv;
f0103185:	e8 30 2f 00 00       	call   f01060ba <cpunum>
f010318a:	6b c0 74             	imul   $0x74,%eax,%eax
f010318d:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0103193:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103196:	89 02                	mov    %eax,(%edx)
		return 0;
f0103198:	89 f0                	mov    %esi,%eax
f010319a:	eb e5                	jmp    f0103181 <envid2env+0x3d>
		*env_store = 0;
f010319c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010319f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01031a5:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01031aa:	eb d5                	jmp    f0103181 <envid2env+0x3d>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01031ac:	e8 09 2f 00 00       	call   f01060ba <cpunum>
f01031b1:	6b c0 74             	imul   $0x74,%eax,%eax
f01031b4:	39 98 28 80 23 f0    	cmp    %ebx,-0xfdc7fd8(%eax)
f01031ba:	74 bb                	je     f0103177 <envid2env+0x33>
f01031bc:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01031bf:	e8 f6 2e 00 00       	call   f01060ba <cpunum>
f01031c4:	6b c0 74             	imul   $0x74,%eax,%eax
f01031c7:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f01031cd:	3b 70 48             	cmp    0x48(%eax),%esi
f01031d0:	74 a5                	je     f0103177 <envid2env+0x33>
		*env_store = 0;
f01031d2:	8b 45 0c             	mov    0xc(%ebp),%eax
f01031d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01031db:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01031e0:	eb 9f                	jmp    f0103181 <envid2env+0x3d>

f01031e2 <env_init_percpu>:
{
f01031e2:	f3 0f 1e fb          	endbr32 
	asm volatile("lgdt (%0)" : : "r" (p));
f01031e6:	b8 20 33 12 f0       	mov    $0xf0123320,%eax
f01031eb:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f01031ee:	b8 23 00 00 00       	mov    $0x23,%eax
f01031f3:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f01031f5:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01031f7:	b8 10 00 00 00       	mov    $0x10,%eax
f01031fc:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01031fe:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103200:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103202:	ea 09 32 10 f0 08 00 	ljmp   $0x8,$0xf0103209
	asm volatile("lldt %0" : : "r" (sel));
f0103209:	b8 00 00 00 00       	mov    $0x0,%eax
f010320e:	0f 00 d0             	lldt   %ax
}
f0103211:	c3                   	ret    

f0103212 <env_init>:
{
f0103212:	f3 0f 1e fb          	endbr32 
f0103216:	55                   	push   %ebp
f0103217:	89 e5                	mov    %esp,%ebp
f0103219:	56                   	push   %esi
f010321a:	53                   	push   %ebx
		envs[i].env_id = 0;
f010321b:	8b 35 48 72 23 f0    	mov    0xf0237248,%esi
f0103221:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f0103227:	89 f3                	mov    %esi,%ebx
f0103229:	ba 00 00 00 00       	mov    $0x0,%edx
f010322e:	89 d1                	mov    %edx,%ecx
f0103230:	89 c2                	mov    %eax,%edx
f0103232:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_link = env_free_list;
f0103239:	89 48 44             	mov    %ecx,0x44(%eax)
f010323c:	83 e8 7c             	sub    $0x7c,%eax
	for(i = NENV - 1; i >= 0; i--){
f010323f:	39 da                	cmp    %ebx,%edx
f0103241:	75 eb                	jne    f010322e <env_init+0x1c>
f0103243:	89 35 4c 72 23 f0    	mov    %esi,0xf023724c
	env_init_percpu();
f0103249:	e8 94 ff ff ff       	call   f01031e2 <env_init_percpu>
}
f010324e:	5b                   	pop    %ebx
f010324f:	5e                   	pop    %esi
f0103250:	5d                   	pop    %ebp
f0103251:	c3                   	ret    

f0103252 <env_alloc>:
{
f0103252:	f3 0f 1e fb          	endbr32 
f0103256:	55                   	push   %ebp
f0103257:	89 e5                	mov    %esp,%ebp
f0103259:	53                   	push   %ebx
f010325a:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f010325d:	8b 1d 4c 72 23 f0    	mov    0xf023724c,%ebx
f0103263:	85 db                	test   %ebx,%ebx
f0103265:	0f 84 77 01 00 00    	je     f01033e2 <env_alloc+0x190>
	if (!(p = page_alloc(ALLOC_ZERO)))
f010326b:	83 ec 0c             	sub    $0xc,%esp
f010326e:	6a 01                	push   $0x1
f0103270:	e8 44 dd ff ff       	call   f0100fb9 <page_alloc>
f0103275:	83 c4 10             	add    $0x10,%esp
f0103278:	85 c0                	test   %eax,%eax
f010327a:	0f 84 69 01 00 00    	je     f01033e9 <env_alloc+0x197>
	p->pp_ref++;
f0103280:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0103285:	2b 05 90 7e 23 f0    	sub    0xf0237e90,%eax
f010328b:	c1 f8 03             	sar    $0x3,%eax
f010328e:	89 c2                	mov    %eax,%edx
f0103290:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0103293:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0103298:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f010329e:	0f 83 17 01 00 00    	jae    f01033bb <env_alloc+0x169>
	return (void *)(pa + KERNBASE);
f01032a4:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	e->env_pgdir = (pde_t *)page2kva(p);
f01032aa:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f01032ad:	83 ec 04             	sub    $0x4,%esp
f01032b0:	68 00 10 00 00       	push   $0x1000
f01032b5:	ff 35 8c 7e 23 f0    	pushl  0xf0237e8c
f01032bb:	50                   	push   %eax
f01032bc:	e8 8b 28 00 00       	call   f0105b4c <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f01032c1:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01032c4:	83 c4 10             	add    $0x10,%esp
f01032c7:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01032cc:	0f 86 fb 00 00 00    	jbe    f01033cd <env_alloc+0x17b>
	return (physaddr_t)kva - KERNBASE;
f01032d2:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01032d8:	83 ca 05             	or     $0x5,%edx
f01032db:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f01032e1:	8b 43 48             	mov    0x48(%ebx),%eax
f01032e4:	05 00 10 00 00       	add    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
f01032e9:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f01032ee:	ba 00 10 00 00       	mov    $0x1000,%edx
f01032f3:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01032f6:	89 da                	mov    %ebx,%edx
f01032f8:	2b 15 48 72 23 f0    	sub    0xf0237248,%edx
f01032fe:	c1 fa 02             	sar    $0x2,%edx
f0103301:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f0103307:	09 d0                	or     %edx,%eax
f0103309:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f010330c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010330f:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103312:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103319:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103320:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103327:	83 ec 04             	sub    $0x4,%esp
f010332a:	6a 44                	push   $0x44
f010332c:	6a 00                	push   $0x0
f010332e:	53                   	push   %ebx
f010332f:	e8 66 27 00 00       	call   f0105a9a <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f0103334:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f010333a:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103340:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103346:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f010334d:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f0103353:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f010335a:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f0103361:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f0103365:	8b 43 44             	mov    0x44(%ebx),%eax
f0103368:	a3 4c 72 23 f0       	mov    %eax,0xf023724c
	*newenv_store = e;
f010336d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103370:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103372:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0103375:	e8 40 2d 00 00       	call   f01060ba <cpunum>
f010337a:	6b c0 74             	imul   $0x74,%eax,%eax
f010337d:	83 c4 10             	add    $0x10,%esp
f0103380:	ba 00 00 00 00       	mov    $0x0,%edx
f0103385:	83 b8 28 80 23 f0 00 	cmpl   $0x0,-0xfdc7fd8(%eax)
f010338c:	74 11                	je     f010339f <env_alloc+0x14d>
f010338e:	e8 27 2d 00 00       	call   f01060ba <cpunum>
f0103393:	6b c0 74             	imul   $0x74,%eax,%eax
f0103396:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f010339c:	8b 50 48             	mov    0x48(%eax),%edx
f010339f:	83 ec 04             	sub    $0x4,%esp
f01033a2:	53                   	push   %ebx
f01033a3:	52                   	push   %edx
f01033a4:	68 29 7a 10 f0       	push   $0xf0107a29
f01033a9:	e8 81 06 00 00       	call   f0103a2f <cprintf>
	return 0;
f01033ae:	83 c4 10             	add    $0x10,%esp
f01033b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01033b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01033b9:	c9                   	leave  
f01033ba:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01033bb:	52                   	push   %edx
f01033bc:	68 64 67 10 f0       	push   $0xf0106764
f01033c1:	6a 58                	push   $0x58
f01033c3:	68 02 6d 10 f0       	push   $0xf0106d02
f01033c8:	e8 73 cc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033cd:	50                   	push   %eax
f01033ce:	68 88 67 10 f0       	push   $0xf0106788
f01033d3:	68 c7 00 00 00       	push   $0xc7
f01033d8:	68 1e 7a 10 f0       	push   $0xf0107a1e
f01033dd:	e8 5e cc ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f01033e2:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f01033e7:	eb cd                	jmp    f01033b6 <env_alloc+0x164>
		return -E_NO_MEM;
f01033e9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01033ee:	eb c6                	jmp    f01033b6 <env_alloc+0x164>

f01033f0 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f01033f0:	f3 0f 1e fb          	endbr32 
f01033f4:	55                   	push   %ebp
f01033f5:	89 e5                	mov    %esp,%ebp
f01033f7:	57                   	push   %edi
f01033f8:	56                   	push   %esi
f01033f9:	53                   	push   %ebx
f01033fa:	83 ec 34             	sub    $0x34,%esp
f01033fd:	8b 75 08             	mov    0x8(%ebp),%esi
	// LAB 3: Your code here.

	// Allocates a new env with env_alloc
	struct Env* env;
	int r;
	if(env_alloc(&env, 0)){
f0103400:	6a 00                	push   $0x0
f0103402:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103405:	50                   	push   %eax
f0103406:	e8 47 fe ff ff       	call   f0103252 <env_alloc>
f010340b:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010340e:	83 c4 10             	add    $0x10,%esp
f0103411:	85 c0                	test   %eax,%eax
f0103413:	75 3a                	jne    f010344f <env_create+0x5f>
		panic("env_create failed: create env failed\n");
	}

	// loads the named elf binary into it with load_icode
	load_icode(env, binary);
f0103415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103418:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(header->e_magic != ELF_MAGIC)
f010341b:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
f0103421:	75 43                	jne    f0103466 <env_create+0x76>
	if(header->e_entry == 0)
f0103423:	83 7e 18 00          	cmpl   $0x0,0x18(%esi)
f0103427:	74 54                	je     f010347d <env_create+0x8d>
	struct Proghdr* ph = (struct Proghdr*)((uint8_t*)header + header->e_phoff);
f0103429:	8b 5e 1c             	mov    0x1c(%esi),%ebx
	int phnum = header->e_phnum;
f010342c:	0f b7 46 2c          	movzwl 0x2c(%esi),%eax
f0103430:	89 45 cc             	mov    %eax,-0x34(%ebp)
	lcr3(PADDR(e->env_pgdir));
f0103433:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103436:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103439:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010343e:	76 54                	jbe    f0103494 <env_create+0xa4>
	return (physaddr_t)kva - KERNBASE;
f0103440:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103445:	0f 22 d8             	mov    %eax,%cr3
f0103448:	01 f3                	add    %esi,%ebx
	for(i = 0; i < phnum; i++){
f010344a:	e9 93 00 00 00       	jmp    f01034e2 <env_create+0xf2>
		panic("env_create failed: create env failed\n");
f010344f:	83 ec 04             	sub    $0x4,%esp
f0103452:	68 60 7a 10 f0       	push   $0xf0107a60
f0103457:	68 bf 01 00 00       	push   $0x1bf
f010345c:	68 1e 7a 10 f0       	push   $0xf0107a1e
f0103461:	e8 da cb ff ff       	call   f0100040 <_panic>
		panic("load_icode failed: the binary is not elf\n");
f0103466:	83 ec 04             	sub    $0x4,%esp
f0103469:	68 88 7a 10 f0       	push   $0xf0107a88
f010346e:	68 6b 01 00 00       	push   $0x16b
f0103473:	68 1e 7a 10 f0       	push   $0xf0107a1e
f0103478:	e8 c3 cb ff ff       	call   f0100040 <_panic>
		panic("load_icode failed: the elf can't be executed\n");
f010347d:	83 ec 04             	sub    $0x4,%esp
f0103480:	68 b4 7a 10 f0       	push   $0xf0107ab4
f0103485:	68 6d 01 00 00       	push   $0x16d
f010348a:	68 1e 7a 10 f0       	push   $0xf0107a1e
f010348f:	e8 ac cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103494:	50                   	push   %eax
f0103495:	68 88 67 10 f0       	push   $0xf0106788
f010349a:	68 7f 01 00 00       	push   $0x17f
f010349f:	68 1e 7a 10 f0       	push   $0xf0107a1e
f01034a4:	e8 97 cb ff ff       	call   f0100040 <_panic>
			region_alloc(e, (void*)ph[i].p_va, ph[i].p_memsz);
f01034a9:	8b 53 08             	mov    0x8(%ebx),%edx
f01034ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01034af:	e8 25 fc ff ff       	call   f01030d9 <region_alloc>
			memset((void*)ph[i].p_va, 0, ph[i].p_memsz);
f01034b4:	83 ec 04             	sub    $0x4,%esp
f01034b7:	ff 73 14             	pushl  0x14(%ebx)
f01034ba:	6a 00                	push   $0x0
f01034bc:	ff 73 08             	pushl  0x8(%ebx)
f01034bf:	e8 d6 25 00 00       	call   f0105a9a <memset>
			memcpy((void*)ph[i].p_va, binary + ph[i].p_offset, ph[i].p_filesz);
f01034c4:	83 c4 0c             	add    $0xc,%esp
f01034c7:	ff 73 10             	pushl  0x10(%ebx)
f01034ca:	89 f0                	mov    %esi,%eax
f01034cc:	03 43 04             	add    0x4(%ebx),%eax
f01034cf:	50                   	push   %eax
f01034d0:	ff 73 08             	pushl  0x8(%ebx)
f01034d3:	e8 74 26 00 00       	call   f0105b4c <memcpy>
f01034d8:	83 c4 10             	add    $0x10,%esp
	for(i = 0; i < phnum; i++){
f01034db:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
f01034df:	83 c3 20             	add    $0x20,%ebx
f01034e2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f01034e5:	39 4d cc             	cmp    %ecx,-0x34(%ebp)
f01034e8:	74 24                	je     f010350e <env_create+0x11e>
		if(ph[i].p_type == ELF_PROG_LOAD){
f01034ea:	83 3b 01             	cmpl   $0x1,(%ebx)
f01034ed:	75 ec                	jne    f01034db <env_create+0xeb>
			if(ph[i].p_memsz < ph[i].p_filesz){
f01034ef:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01034f2:	3b 4b 10             	cmp    0x10(%ebx),%ecx
f01034f5:	73 b2                	jae    f01034a9 <env_create+0xb9>
				panic("load_icode failed: p_memsz < p_filesz.\n");
f01034f7:	83 ec 04             	sub    $0x4,%esp
f01034fa:	68 e4 7a 10 f0       	push   $0xf0107ae4
f01034ff:	68 89 01 00 00       	push   $0x189
f0103504:	68 1e 7a 10 f0       	push   $0xf0107a1e
f0103509:	e8 32 cb ff ff       	call   f0100040 <_panic>
	e->env_tf.tf_eip = header->e_entry;
f010350e:	8b 46 18             	mov    0x18(%esi),%eax
f0103511:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0103514:	89 42 30             	mov    %eax,0x30(%edx)
	lcr3(PADDR(kern_pgdir));
f0103517:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f010351c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103521:	76 2b                	jbe    f010354e <env_create+0x15e>
	return (physaddr_t)kva - KERNBASE;
f0103523:	05 00 00 00 10       	add    $0x10000000,%eax
f0103528:	0f 22 d8             	mov    %eax,%cr3
	region_alloc(e, (void*)(USTACKTOP - PGSIZE), PGSIZE);
f010352b:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103530:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103535:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103538:	e8 9c fb ff ff       	call   f01030d9 <region_alloc>

	// sets its env_type.
	env->env_type = type;
f010353d:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103543:	89 50 50             	mov    %edx,0x50(%eax)
}
f0103546:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103549:	5b                   	pop    %ebx
f010354a:	5e                   	pop    %esi
f010354b:	5f                   	pop    %edi
f010354c:	5d                   	pop    %ebp
f010354d:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010354e:	50                   	push   %eax
f010354f:	68 88 67 10 f0       	push   $0xf0106788
f0103554:	68 a5 01 00 00       	push   $0x1a5
f0103559:	68 1e 7a 10 f0       	push   $0xf0107a1e
f010355e:	e8 dd ca ff ff       	call   f0100040 <_panic>

f0103563 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103563:	f3 0f 1e fb          	endbr32 
f0103567:	55                   	push   %ebp
f0103568:	89 e5                	mov    %esp,%ebp
f010356a:	57                   	push   %edi
f010356b:	56                   	push   %esi
f010356c:	53                   	push   %ebx
f010356d:	83 ec 1c             	sub    $0x1c,%esp
f0103570:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103573:	e8 42 2b 00 00       	call   f01060ba <cpunum>
f0103578:	6b c0 74             	imul   $0x74,%eax,%eax
f010357b:	39 b8 28 80 23 f0    	cmp    %edi,-0xfdc7fd8(%eax)
f0103581:	74 48                	je     f01035cb <env_free+0x68>
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103583:	8b 5f 48             	mov    0x48(%edi),%ebx
f0103586:	e8 2f 2b 00 00       	call   f01060ba <cpunum>
f010358b:	6b c0 74             	imul   $0x74,%eax,%eax
f010358e:	ba 00 00 00 00       	mov    $0x0,%edx
f0103593:	83 b8 28 80 23 f0 00 	cmpl   $0x0,-0xfdc7fd8(%eax)
f010359a:	74 11                	je     f01035ad <env_free+0x4a>
f010359c:	e8 19 2b 00 00       	call   f01060ba <cpunum>
f01035a1:	6b c0 74             	imul   $0x74,%eax,%eax
f01035a4:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f01035aa:	8b 50 48             	mov    0x48(%eax),%edx
f01035ad:	83 ec 04             	sub    $0x4,%esp
f01035b0:	53                   	push   %ebx
f01035b1:	52                   	push   %edx
f01035b2:	68 3e 7a 10 f0       	push   $0xf0107a3e
f01035b7:	e8 73 04 00 00       	call   f0103a2f <cprintf>
f01035bc:	83 c4 10             	add    $0x10,%esp
f01035bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01035c6:	e9 a9 00 00 00       	jmp    f0103674 <env_free+0x111>
		lcr3(PADDR(kern_pgdir));
f01035cb:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01035d0:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035d5:	76 0a                	jbe    f01035e1 <env_free+0x7e>
	return (physaddr_t)kva - KERNBASE;
f01035d7:	05 00 00 00 10       	add    $0x10000000,%eax
f01035dc:	0f 22 d8             	mov    %eax,%cr3
}
f01035df:	eb a2                	jmp    f0103583 <env_free+0x20>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01035e1:	50                   	push   %eax
f01035e2:	68 88 67 10 f0       	push   $0xf0106788
f01035e7:	68 d7 01 00 00       	push   $0x1d7
f01035ec:	68 1e 7a 10 f0       	push   $0xf0107a1e
f01035f1:	e8 4a ca ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01035f6:	56                   	push   %esi
f01035f7:	68 64 67 10 f0       	push   $0xf0106764
f01035fc:	68 e6 01 00 00       	push   $0x1e6
f0103601:	68 1e 7a 10 f0       	push   $0xf0107a1e
f0103606:	e8 35 ca ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010360b:	83 ec 08             	sub    $0x8,%esp
f010360e:	89 d8                	mov    %ebx,%eax
f0103610:	c1 e0 0c             	shl    $0xc,%eax
f0103613:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103616:	50                   	push   %eax
f0103617:	ff 77 60             	pushl  0x60(%edi)
f010361a:	e8 8c dc ff ff       	call   f01012ab <page_remove>
f010361f:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103622:	83 c3 01             	add    $0x1,%ebx
f0103625:	83 c6 04             	add    $0x4,%esi
f0103628:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f010362e:	74 07                	je     f0103637 <env_free+0xd4>
			if (pt[pteno] & PTE_P)
f0103630:	f6 06 01             	testb  $0x1,(%esi)
f0103633:	74 ed                	je     f0103622 <env_free+0xbf>
f0103635:	eb d4                	jmp    f010360b <env_free+0xa8>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103637:	8b 47 60             	mov    0x60(%edi),%eax
f010363a:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010363d:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103644:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103647:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f010364d:	73 65                	jae    f01036b4 <env_free+0x151>
		page_decref(pa2page(pa));
f010364f:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103652:	a1 90 7e 23 f0       	mov    0xf0237e90,%eax
f0103657:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010365a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f010365d:	50                   	push   %eax
f010365e:	e8 37 da ff ff       	call   f010109a <page_decref>
f0103663:	83 c4 10             	add    $0x10,%esp
f0103666:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f010366a:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f010366d:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103672:	74 54                	je     f01036c8 <env_free+0x165>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103674:	8b 47 60             	mov    0x60(%edi),%eax
f0103677:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010367a:	8b 04 10             	mov    (%eax,%edx,1),%eax
f010367d:	a8 01                	test   $0x1,%al
f010367f:	74 e5                	je     f0103666 <env_free+0x103>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103681:	89 c6                	mov    %eax,%esi
f0103683:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103689:	c1 e8 0c             	shr    $0xc,%eax
f010368c:	89 45 dc             	mov    %eax,-0x24(%ebp)
f010368f:	39 05 88 7e 23 f0    	cmp    %eax,0xf0237e88
f0103695:	0f 86 5b ff ff ff    	jbe    f01035f6 <env_free+0x93>
	return (void *)(pa + KERNBASE);
f010369b:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f01036a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01036a4:	c1 e0 14             	shl    $0x14,%eax
f01036a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01036aa:	bb 00 00 00 00       	mov    $0x0,%ebx
f01036af:	e9 7c ff ff ff       	jmp    f0103630 <env_free+0xcd>
		panic("pa2page called with invalid pa");
f01036b4:	83 ec 04             	sub    $0x4,%esp
f01036b7:	68 9c 71 10 f0       	push   $0xf010719c
f01036bc:	6a 51                	push   $0x51
f01036be:	68 02 6d 10 f0       	push   $0xf0106d02
f01036c3:	e8 78 c9 ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01036c8:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f01036cb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01036d0:	76 49                	jbe    f010371b <env_free+0x1b8>
	e->env_pgdir = 0;
f01036d2:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f01036d9:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01036de:	c1 e8 0c             	shr    $0xc,%eax
f01036e1:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f01036e7:	73 47                	jae    f0103730 <env_free+0x1cd>
	page_decref(pa2page(pa));
f01036e9:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01036ec:	8b 15 90 7e 23 f0    	mov    0xf0237e90,%edx
f01036f2:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01036f5:	50                   	push   %eax
f01036f6:	e8 9f d9 ff ff       	call   f010109a <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01036fb:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103702:	a1 4c 72 23 f0       	mov    0xf023724c,%eax
f0103707:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f010370a:	89 3d 4c 72 23 f0    	mov    %edi,0xf023724c
}
f0103710:	83 c4 10             	add    $0x10,%esp
f0103713:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103716:	5b                   	pop    %ebx
f0103717:	5e                   	pop    %esi
f0103718:	5f                   	pop    %edi
f0103719:	5d                   	pop    %ebp
f010371a:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010371b:	50                   	push   %eax
f010371c:	68 88 67 10 f0       	push   $0xf0106788
f0103721:	68 f4 01 00 00       	push   $0x1f4
f0103726:	68 1e 7a 10 f0       	push   $0xf0107a1e
f010372b:	e8 10 c9 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f0103730:	83 ec 04             	sub    $0x4,%esp
f0103733:	68 9c 71 10 f0       	push   $0xf010719c
f0103738:	6a 51                	push   $0x51
f010373a:	68 02 6d 10 f0       	push   $0xf0106d02
f010373f:	e8 fc c8 ff ff       	call   f0100040 <_panic>

f0103744 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103744:	f3 0f 1e fb          	endbr32 
f0103748:	55                   	push   %ebp
f0103749:	89 e5                	mov    %esp,%ebp
f010374b:	53                   	push   %ebx
f010374c:	83 ec 04             	sub    $0x4,%esp
f010374f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103752:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103756:	74 21                	je     f0103779 <env_destroy+0x35>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103758:	83 ec 0c             	sub    $0xc,%esp
f010375b:	53                   	push   %ebx
f010375c:	e8 02 fe ff ff       	call   f0103563 <env_free>

	if (curenv == e) {
f0103761:	e8 54 29 00 00       	call   f01060ba <cpunum>
f0103766:	6b c0 74             	imul   $0x74,%eax,%eax
f0103769:	83 c4 10             	add    $0x10,%esp
f010376c:	39 98 28 80 23 f0    	cmp    %ebx,-0xfdc7fd8(%eax)
f0103772:	74 1e                	je     f0103792 <env_destroy+0x4e>
		curenv = NULL;
		sched_yield();
	}
}
f0103774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103777:	c9                   	leave  
f0103778:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103779:	e8 3c 29 00 00       	call   f01060ba <cpunum>
f010377e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103781:	39 98 28 80 23 f0    	cmp    %ebx,-0xfdc7fd8(%eax)
f0103787:	74 cf                	je     f0103758 <env_destroy+0x14>
		e->env_status = ENV_DYING;
f0103789:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103790:	eb e2                	jmp    f0103774 <env_destroy+0x30>
		curenv = NULL;
f0103792:	e8 23 29 00 00       	call   f01060ba <cpunum>
f0103797:	6b c0 74             	imul   $0x74,%eax,%eax
f010379a:	c7 80 28 80 23 f0 00 	movl   $0x0,-0xfdc7fd8(%eax)
f01037a1:	00 00 00 
		sched_yield();
f01037a4:	e8 ae 10 00 00       	call   f0104857 <sched_yield>

f01037a9 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f01037a9:	f3 0f 1e fb          	endbr32 
f01037ad:	55                   	push   %ebp
f01037ae:	89 e5                	mov    %esp,%ebp
f01037b0:	53                   	push   %ebx
f01037b1:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f01037b4:	e8 01 29 00 00       	call   f01060ba <cpunum>
f01037b9:	6b c0 74             	imul   $0x74,%eax,%eax
f01037bc:	8b 98 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%ebx
f01037c2:	e8 f3 28 00 00       	call   f01060ba <cpunum>
f01037c7:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f01037ca:	8b 65 08             	mov    0x8(%ebp),%esp
f01037cd:	61                   	popa   
f01037ce:	07                   	pop    %es
f01037cf:	1f                   	pop    %ds
f01037d0:	83 c4 08             	add    $0x8,%esp
f01037d3:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f01037d4:	83 ec 04             	sub    $0x4,%esp
f01037d7:	68 54 7a 10 f0       	push   $0xf0107a54
f01037dc:	68 2b 02 00 00       	push   $0x22b
f01037e1:	68 1e 7a 10 f0       	push   $0xf0107a1e
f01037e6:	e8 55 c8 ff ff       	call   f0100040 <_panic>

f01037eb <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01037eb:	f3 0f 1e fb          	endbr32 
f01037ef:	55                   	push   %ebp
f01037f0:	89 e5                	mov    %esp,%ebp
f01037f2:	53                   	push   %ebx
f01037f3:	83 ec 04             	sub    $0x4,%esp
f01037f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != NULL && curenv->env_status == ENV_RUNNING){
f01037f9:	e8 bc 28 00 00       	call   f01060ba <cpunum>
f01037fe:	6b c0 74             	imul   $0x74,%eax,%eax
f0103801:	83 b8 28 80 23 f0 00 	cmpl   $0x0,-0xfdc7fd8(%eax)
f0103808:	74 14                	je     f010381e <env_run+0x33>
f010380a:	e8 ab 28 00 00       	call   f01060ba <cpunum>
f010380f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103812:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0103818:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010381c:	74 42                	je     f0103860 <env_run+0x75>
		//但是查看了好多人的实现都没有
		//暂时存疑
		//curenv->env_runs--;
	}

	curenv = e;
f010381e:	e8 97 28 00 00       	call   f01060ba <cpunum>
f0103823:	6b c0 74             	imul   $0x74,%eax,%eax
f0103826:	89 98 28 80 23 f0    	mov    %ebx,-0xfdc7fd8(%eax)
	e->env_status = ENV_RUNNING;
f010382c:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
	e->env_runs++;
f0103833:	83 43 58 01          	addl   $0x1,0x58(%ebx)
	lcr3(PADDR(e->env_pgdir));
f0103837:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010383a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010383f:	76 36                	jbe    f0103877 <env_run+0x8c>
	return (physaddr_t)kva - KERNBASE;
f0103841:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103846:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103849:	83 ec 0c             	sub    $0xc,%esp
f010384c:	68 c0 33 12 f0       	push   $0xf01233c0
f0103851:	e8 8a 2b 00 00       	call   f01063e0 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103856:	f3 90                	pause  
	unlock_kernel();
	env_pop_tf(&e->env_tf);
f0103858:	89 1c 24             	mov    %ebx,(%esp)
f010385b:	e8 49 ff ff ff       	call   f01037a9 <env_pop_tf>
		curenv->env_status = ENV_RUNNABLE;
f0103860:	e8 55 28 00 00       	call   f01060ba <cpunum>
f0103865:	6b c0 74             	imul   $0x74,%eax,%eax
f0103868:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f010386e:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103875:	eb a7                	jmp    f010381e <env_run+0x33>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103877:	50                   	push   %eax
f0103878:	68 88 67 10 f0       	push   $0xf0106788
f010387d:	68 54 02 00 00       	push   $0x254
f0103882:	68 1e 7a 10 f0       	push   $0xf0107a1e
f0103887:	e8 b4 c7 ff ff       	call   f0100040 <_panic>

f010388c <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010388c:	f3 0f 1e fb          	endbr32 
f0103890:	55                   	push   %ebp
f0103891:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103893:	8b 45 08             	mov    0x8(%ebp),%eax
f0103896:	ba 70 00 00 00       	mov    $0x70,%edx
f010389b:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010389c:	ba 71 00 00 00       	mov    $0x71,%edx
f01038a1:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01038a2:	0f b6 c0             	movzbl %al,%eax
}
f01038a5:	5d                   	pop    %ebp
f01038a6:	c3                   	ret    

f01038a7 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01038a7:	f3 0f 1e fb          	endbr32 
f01038ab:	55                   	push   %ebp
f01038ac:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01038ae:	8b 45 08             	mov    0x8(%ebp),%eax
f01038b1:	ba 70 00 00 00       	mov    $0x70,%edx
f01038b6:	ee                   	out    %al,(%dx)
f01038b7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01038ba:	ba 71 00 00 00       	mov    $0x71,%edx
f01038bf:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01038c0:	5d                   	pop    %ebp
f01038c1:	c3                   	ret    

f01038c2 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01038c2:	f3 0f 1e fb          	endbr32 
f01038c6:	55                   	push   %ebp
f01038c7:	89 e5                	mov    %esp,%ebp
f01038c9:	56                   	push   %esi
f01038ca:	53                   	push   %ebx
f01038cb:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f01038ce:	66 a3 a8 33 12 f0    	mov    %ax,0xf01233a8
	if (!didinit)
f01038d4:	80 3d 50 72 23 f0 00 	cmpb   $0x0,0xf0237250
f01038db:	75 07                	jne    f01038e4 <irq_setmask_8259A+0x22>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f01038dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01038e0:	5b                   	pop    %ebx
f01038e1:	5e                   	pop    %esi
f01038e2:	5d                   	pop    %ebp
f01038e3:	c3                   	ret    
f01038e4:	89 c6                	mov    %eax,%esi
f01038e6:	ba 21 00 00 00       	mov    $0x21,%edx
f01038eb:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f01038ec:	66 c1 e8 08          	shr    $0x8,%ax
f01038f0:	ba a1 00 00 00       	mov    $0xa1,%edx
f01038f5:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01038f6:	83 ec 0c             	sub    $0xc,%esp
f01038f9:	68 0c 7b 10 f0       	push   $0xf0107b0c
f01038fe:	e8 2c 01 00 00       	call   f0103a2f <cprintf>
f0103903:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103906:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f010390b:	0f b7 f6             	movzwl %si,%esi
f010390e:	f7 d6                	not    %esi
f0103910:	eb 19                	jmp    f010392b <irq_setmask_8259A+0x69>
			cprintf(" %d", i);
f0103912:	83 ec 08             	sub    $0x8,%esp
f0103915:	53                   	push   %ebx
f0103916:	68 db 7f 10 f0       	push   $0xf0107fdb
f010391b:	e8 0f 01 00 00       	call   f0103a2f <cprintf>
f0103920:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103923:	83 c3 01             	add    $0x1,%ebx
f0103926:	83 fb 10             	cmp    $0x10,%ebx
f0103929:	74 07                	je     f0103932 <irq_setmask_8259A+0x70>
		if (~mask & (1<<i))
f010392b:	0f a3 de             	bt     %ebx,%esi
f010392e:	73 f3                	jae    f0103923 <irq_setmask_8259A+0x61>
f0103930:	eb e0                	jmp    f0103912 <irq_setmask_8259A+0x50>
	cprintf("\n");
f0103932:	83 ec 0c             	sub    $0xc,%esp
f0103935:	68 d6 6f 10 f0       	push   $0xf0106fd6
f010393a:	e8 f0 00 00 00       	call   f0103a2f <cprintf>
f010393f:	83 c4 10             	add    $0x10,%esp
f0103942:	eb 99                	jmp    f01038dd <irq_setmask_8259A+0x1b>

f0103944 <pic_init>:
{
f0103944:	f3 0f 1e fb          	endbr32 
f0103948:	55                   	push   %ebp
f0103949:	89 e5                	mov    %esp,%ebp
f010394b:	57                   	push   %edi
f010394c:	56                   	push   %esi
f010394d:	53                   	push   %ebx
f010394e:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103951:	c6 05 50 72 23 f0 01 	movb   $0x1,0xf0237250
f0103958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010395d:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103962:	89 da                	mov    %ebx,%edx
f0103964:	ee                   	out    %al,(%dx)
f0103965:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f010396a:	89 ca                	mov    %ecx,%edx
f010396c:	ee                   	out    %al,(%dx)
f010396d:	bf 11 00 00 00       	mov    $0x11,%edi
f0103972:	be 20 00 00 00       	mov    $0x20,%esi
f0103977:	89 f8                	mov    %edi,%eax
f0103979:	89 f2                	mov    %esi,%edx
f010397b:	ee                   	out    %al,(%dx)
f010397c:	b8 20 00 00 00       	mov    $0x20,%eax
f0103981:	89 da                	mov    %ebx,%edx
f0103983:	ee                   	out    %al,(%dx)
f0103984:	b8 04 00 00 00       	mov    $0x4,%eax
f0103989:	ee                   	out    %al,(%dx)
f010398a:	b8 03 00 00 00       	mov    $0x3,%eax
f010398f:	ee                   	out    %al,(%dx)
f0103990:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103995:	89 f8                	mov    %edi,%eax
f0103997:	89 da                	mov    %ebx,%edx
f0103999:	ee                   	out    %al,(%dx)
f010399a:	b8 28 00 00 00       	mov    $0x28,%eax
f010399f:	89 ca                	mov    %ecx,%edx
f01039a1:	ee                   	out    %al,(%dx)
f01039a2:	b8 02 00 00 00       	mov    $0x2,%eax
f01039a7:	ee                   	out    %al,(%dx)
f01039a8:	b8 01 00 00 00       	mov    $0x1,%eax
f01039ad:	ee                   	out    %al,(%dx)
f01039ae:	bf 68 00 00 00       	mov    $0x68,%edi
f01039b3:	89 f8                	mov    %edi,%eax
f01039b5:	89 f2                	mov    %esi,%edx
f01039b7:	ee                   	out    %al,(%dx)
f01039b8:	b9 0a 00 00 00       	mov    $0xa,%ecx
f01039bd:	89 c8                	mov    %ecx,%eax
f01039bf:	ee                   	out    %al,(%dx)
f01039c0:	89 f8                	mov    %edi,%eax
f01039c2:	89 da                	mov    %ebx,%edx
f01039c4:	ee                   	out    %al,(%dx)
f01039c5:	89 c8                	mov    %ecx,%eax
f01039c7:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f01039c8:	0f b7 05 a8 33 12 f0 	movzwl 0xf01233a8,%eax
f01039cf:	66 83 f8 ff          	cmp    $0xffff,%ax
f01039d3:	75 08                	jne    f01039dd <pic_init+0x99>
}
f01039d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01039d8:	5b                   	pop    %ebx
f01039d9:	5e                   	pop    %esi
f01039da:	5f                   	pop    %edi
f01039db:	5d                   	pop    %ebp
f01039dc:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f01039dd:	83 ec 0c             	sub    $0xc,%esp
f01039e0:	0f b7 c0             	movzwl %ax,%eax
f01039e3:	50                   	push   %eax
f01039e4:	e8 d9 fe ff ff       	call   f01038c2 <irq_setmask_8259A>
f01039e9:	83 c4 10             	add    $0x10,%esp
}
f01039ec:	eb e7                	jmp    f01039d5 <pic_init+0x91>

f01039ee <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01039ee:	f3 0f 1e fb          	endbr32 
f01039f2:	55                   	push   %ebp
f01039f3:	89 e5                	mov    %esp,%ebp
f01039f5:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f01039f8:	ff 75 08             	pushl  0x8(%ebp)
f01039fb:	e8 74 cd ff ff       	call   f0100774 <cputchar>
	*cnt++;
}
f0103a00:	83 c4 10             	add    $0x10,%esp
f0103a03:	c9                   	leave  
f0103a04:	c3                   	ret    

f0103a05 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103a05:	f3 0f 1e fb          	endbr32 
f0103a09:	55                   	push   %ebp
f0103a0a:	89 e5                	mov    %esp,%ebp
f0103a0c:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103a0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103a16:	ff 75 0c             	pushl  0xc(%ebp)
f0103a19:	ff 75 08             	pushl  0x8(%ebp)
f0103a1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103a1f:	50                   	push   %eax
f0103a20:	68 ee 39 10 f0       	push   $0xf01039ee
f0103a25:	e8 19 19 00 00       	call   f0105343 <vprintfmt>
	return cnt;
}
f0103a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103a2d:	c9                   	leave  
f0103a2e:	c3                   	ret    

f0103a2f <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103a2f:	f3 0f 1e fb          	endbr32 
f0103a33:	55                   	push   %ebp
f0103a34:	89 e5                	mov    %esp,%ebp
f0103a36:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103a39:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103a3c:	50                   	push   %eax
f0103a3d:	ff 75 08             	pushl  0x8(%ebp)
f0103a40:	e8 c0 ff ff ff       	call   f0103a05 <vcprintf>
	va_end(ap);

	return cnt;
}
f0103a45:	c9                   	leave  
f0103a46:	c3                   	ret    

f0103a47 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103a47:	f3 0f 1e fb          	endbr32 
f0103a4b:	55                   	push   %ebp
f0103a4c:	89 e5                	mov    %esp,%ebp
f0103a4e:	57                   	push   %edi
f0103a4f:	56                   	push   %esi
f0103a50:	53                   	push   %ebx
f0103a51:	83 ec 1c             	sub    $0x1c,%esp
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	int i = cpunum();
f0103a54:	e8 61 26 00 00       	call   f01060ba <cpunum>
f0103a59:	89 c3                	mov    %eax,%ebx
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	// ts.ts_esp0 = KSTACKTOP;
	// ts.ts_ss0 = GD_KD;
	// ts.ts_iomb = sizeof(struct Taskstate);
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t)percpu_kstacks[i];
f0103a5b:	e8 5a 26 00 00       	call   f01060ba <cpunum>
f0103a60:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a63:	89 da                	mov    %ebx,%edx
f0103a65:	c1 e2 0f             	shl    $0xf,%edx
f0103a68:	81 c2 00 90 23 f0    	add    $0xf0239000,%edx
f0103a6e:	89 90 30 80 23 f0    	mov    %edx,-0xfdc7fd0(%eax)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0103a74:	e8 41 26 00 00       	call   f01060ba <cpunum>
f0103a79:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a7c:	66 c7 80 34 80 23 f0 	movw   $0x10,-0xfdc7fcc(%eax)
f0103a83:	10 00 
	thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f0103a85:	e8 30 26 00 00       	call   f01060ba <cpunum>
f0103a8a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a8d:	66 c7 80 92 80 23 f0 	movw   $0x68,-0xfdc7f6e(%eax)
f0103a94:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	// gdt[GD_TSS0 >> 3].sd_s = 0;
	gdt[(GD_TSS0 >> 3) + i] = SEG16(STS_T32A, (uint32_t)(&thiscpu->cpu_ts),
f0103a96:	8d 7b 05             	lea    0x5(%ebx),%edi
f0103a99:	e8 1c 26 00 00       	call   f01060ba <cpunum>
f0103a9e:	89 c6                	mov    %eax,%esi
f0103aa0:	e8 15 26 00 00       	call   f01060ba <cpunum>
f0103aa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103aa8:	e8 0d 26 00 00       	call   f01060ba <cpunum>
f0103aad:	66 c7 04 fd 40 33 12 	movw   $0x67,-0xfedccc0(,%edi,8)
f0103ab4:	f0 67 00 
f0103ab7:	6b f6 74             	imul   $0x74,%esi,%esi
f0103aba:	81 c6 2c 80 23 f0    	add    $0xf023802c,%esi
f0103ac0:	66 89 34 fd 42 33 12 	mov    %si,-0xfedccbe(,%edi,8)
f0103ac7:	f0 
f0103ac8:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103acc:	81 c2 2c 80 23 f0    	add    $0xf023802c,%edx
f0103ad2:	c1 ea 10             	shr    $0x10,%edx
f0103ad5:	88 14 fd 44 33 12 f0 	mov    %dl,-0xfedccbc(,%edi,8)
f0103adc:	c6 04 fd 46 33 12 f0 	movb   $0x40,-0xfedccba(,%edi,8)
f0103ae3:	40 
f0103ae4:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ae7:	05 2c 80 23 f0       	add    $0xf023802c,%eax
f0103aec:	c1 e8 18             	shr    $0x18,%eax
f0103aef:	88 04 fd 47 33 12 f0 	mov    %al,-0xfedccb9(,%edi,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + i].sd_s = 0;
f0103af6:	c6 04 fd 45 33 12 f0 	movb   $0x89,-0xfedccbb(,%edi,8)
f0103afd:	89 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + (i << 3));
f0103afe:	8d 1c dd 28 00 00 00 	lea    0x28(,%ebx,8),%ebx
	asm volatile("ltr %0" : : "r" (sel));
f0103b05:	0f 00 db             	ltr    %bx
	asm volatile("lidt (%0)" : : "r" (p));
f0103b08:	b8 ac 33 12 f0       	mov    $0xf01233ac,%eax
f0103b0d:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f0103b10:	83 c4 1c             	add    $0x1c,%esp
f0103b13:	5b                   	pop    %ebx
f0103b14:	5e                   	pop    %esi
f0103b15:	5f                   	pop    %edi
f0103b16:	5d                   	pop    %ebp
f0103b17:	c3                   	ret    

f0103b18 <trap_init>:
{
f0103b18:	f3 0f 1e fb          	endbr32 
f0103b1c:	55                   	push   %ebp
f0103b1d:	89 e5                	mov    %esp,%ebp
f0103b1f:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE], 0, GD_KT, divide_handler, 0);
f0103b22:	b8 80 46 10 f0       	mov    $0xf0104680,%eax
f0103b27:	66 a3 60 72 23 f0    	mov    %ax,0xf0237260
f0103b2d:	66 c7 05 62 72 23 f0 	movw   $0x8,0xf0237262
f0103b34:	08 00 
f0103b36:	c6 05 64 72 23 f0 00 	movb   $0x0,0xf0237264
f0103b3d:	c6 05 65 72 23 f0 8e 	movb   $0x8e,0xf0237265
f0103b44:	c1 e8 10             	shr    $0x10,%eax
f0103b47:	66 a3 66 72 23 f0    	mov    %ax,0xf0237266
	SETGATE(idt[T_DEBUG], 0, GD_KT, debug_handler, 0);
f0103b4d:	b8 8a 46 10 f0       	mov    $0xf010468a,%eax
f0103b52:	66 a3 68 72 23 f0    	mov    %ax,0xf0237268
f0103b58:	66 c7 05 6a 72 23 f0 	movw   $0x8,0xf023726a
f0103b5f:	08 00 
f0103b61:	c6 05 6c 72 23 f0 00 	movb   $0x0,0xf023726c
f0103b68:	c6 05 6d 72 23 f0 8e 	movb   $0x8e,0xf023726d
f0103b6f:	c1 e8 10             	shr    $0x10,%eax
f0103b72:	66 a3 6e 72 23 f0    	mov    %ax,0xf023726e
	SETGATE(idt[T_NMI], 0, GD_KT, nmi_handler, 0);
f0103b78:	b8 94 46 10 f0       	mov    $0xf0104694,%eax
f0103b7d:	66 a3 70 72 23 f0    	mov    %ax,0xf0237270
f0103b83:	66 c7 05 72 72 23 f0 	movw   $0x8,0xf0237272
f0103b8a:	08 00 
f0103b8c:	c6 05 74 72 23 f0 00 	movb   $0x0,0xf0237274
f0103b93:	c6 05 75 72 23 f0 8e 	movb   $0x8e,0xf0237275
f0103b9a:	c1 e8 10             	shr    $0x10,%eax
f0103b9d:	66 a3 76 72 23 f0    	mov    %ax,0xf0237276
	SETGATE(idt[T_BRKPT], 0, GD_KT, brkpt_handler, 3);
f0103ba3:	b8 9e 46 10 f0       	mov    $0xf010469e,%eax
f0103ba8:	66 a3 78 72 23 f0    	mov    %ax,0xf0237278
f0103bae:	66 c7 05 7a 72 23 f0 	movw   $0x8,0xf023727a
f0103bb5:	08 00 
f0103bb7:	c6 05 7c 72 23 f0 00 	movb   $0x0,0xf023727c
f0103bbe:	c6 05 7d 72 23 f0 ee 	movb   $0xee,0xf023727d
f0103bc5:	c1 e8 10             	shr    $0x10,%eax
f0103bc8:	66 a3 7e 72 23 f0    	mov    %ax,0xf023727e
	SETGATE(idt[T_OFLOW], 0, GD_KT, oflow_handler, 0);
f0103bce:	b8 a8 46 10 f0       	mov    $0xf01046a8,%eax
f0103bd3:	66 a3 80 72 23 f0    	mov    %ax,0xf0237280
f0103bd9:	66 c7 05 82 72 23 f0 	movw   $0x8,0xf0237282
f0103be0:	08 00 
f0103be2:	c6 05 84 72 23 f0 00 	movb   $0x0,0xf0237284
f0103be9:	c6 05 85 72 23 f0 8e 	movb   $0x8e,0xf0237285
f0103bf0:	c1 e8 10             	shr    $0x10,%eax
f0103bf3:	66 a3 86 72 23 f0    	mov    %ax,0xf0237286
	SETGATE(idt[T_BOUND], 0, GD_KT, bound_handler, 0);
f0103bf9:	b8 b2 46 10 f0       	mov    $0xf01046b2,%eax
f0103bfe:	66 a3 88 72 23 f0    	mov    %ax,0xf0237288
f0103c04:	66 c7 05 8a 72 23 f0 	movw   $0x8,0xf023728a
f0103c0b:	08 00 
f0103c0d:	c6 05 8c 72 23 f0 00 	movb   $0x0,0xf023728c
f0103c14:	c6 05 8d 72 23 f0 8e 	movb   $0x8e,0xf023728d
f0103c1b:	c1 e8 10             	shr    $0x10,%eax
f0103c1e:	66 a3 8e 72 23 f0    	mov    %ax,0xf023728e
	SETGATE(idt[T_ILLOP], 0, GD_KT, illop_handler, 0);
f0103c24:	b8 bc 46 10 f0       	mov    $0xf01046bc,%eax
f0103c29:	66 a3 90 72 23 f0    	mov    %ax,0xf0237290
f0103c2f:	66 c7 05 92 72 23 f0 	movw   $0x8,0xf0237292
f0103c36:	08 00 
f0103c38:	c6 05 94 72 23 f0 00 	movb   $0x0,0xf0237294
f0103c3f:	c6 05 95 72 23 f0 8e 	movb   $0x8e,0xf0237295
f0103c46:	c1 e8 10             	shr    $0x10,%eax
f0103c49:	66 a3 96 72 23 f0    	mov    %ax,0xf0237296
	SETGATE(idt[T_DEVICE], 0, GD_KT, device_handler, 0);
f0103c4f:	b8 c6 46 10 f0       	mov    $0xf01046c6,%eax
f0103c54:	66 a3 98 72 23 f0    	mov    %ax,0xf0237298
f0103c5a:	66 c7 05 9a 72 23 f0 	movw   $0x8,0xf023729a
f0103c61:	08 00 
f0103c63:	c6 05 9c 72 23 f0 00 	movb   $0x0,0xf023729c
f0103c6a:	c6 05 9d 72 23 f0 8e 	movb   $0x8e,0xf023729d
f0103c71:	c1 e8 10             	shr    $0x10,%eax
f0103c74:	66 a3 9e 72 23 f0    	mov    %ax,0xf023729e
	SETGATE(idt[T_DBLFLT], 0, GD_KT, dblflt_handler, 0);
f0103c7a:	b8 d0 46 10 f0       	mov    $0xf01046d0,%eax
f0103c7f:	66 a3 a0 72 23 f0    	mov    %ax,0xf02372a0
f0103c85:	66 c7 05 a2 72 23 f0 	movw   $0x8,0xf02372a2
f0103c8c:	08 00 
f0103c8e:	c6 05 a4 72 23 f0 00 	movb   $0x0,0xf02372a4
f0103c95:	c6 05 a5 72 23 f0 8e 	movb   $0x8e,0xf02372a5
f0103c9c:	c1 e8 10             	shr    $0x10,%eax
f0103c9f:	66 a3 a6 72 23 f0    	mov    %ax,0xf02372a6
	SETGATE(idt[T_TSS], 0, GD_KT, tss_handler, 0);
f0103ca5:	b8 d8 46 10 f0       	mov    $0xf01046d8,%eax
f0103caa:	66 a3 b0 72 23 f0    	mov    %ax,0xf02372b0
f0103cb0:	66 c7 05 b2 72 23 f0 	movw   $0x8,0xf02372b2
f0103cb7:	08 00 
f0103cb9:	c6 05 b4 72 23 f0 00 	movb   $0x0,0xf02372b4
f0103cc0:	c6 05 b5 72 23 f0 8e 	movb   $0x8e,0xf02372b5
f0103cc7:	c1 e8 10             	shr    $0x10,%eax
f0103cca:	66 a3 b6 72 23 f0    	mov    %ax,0xf02372b6
	SETGATE(idt[T_SEGNP], 0, GD_KT, segnp_handler, 0);
f0103cd0:	b8 e0 46 10 f0       	mov    $0xf01046e0,%eax
f0103cd5:	66 a3 b8 72 23 f0    	mov    %ax,0xf02372b8
f0103cdb:	66 c7 05 ba 72 23 f0 	movw   $0x8,0xf02372ba
f0103ce2:	08 00 
f0103ce4:	c6 05 bc 72 23 f0 00 	movb   $0x0,0xf02372bc
f0103ceb:	c6 05 bd 72 23 f0 8e 	movb   $0x8e,0xf02372bd
f0103cf2:	c1 e8 10             	shr    $0x10,%eax
f0103cf5:	66 a3 be 72 23 f0    	mov    %ax,0xf02372be
	SETGATE(idt[T_STACK], 0, GD_KT, stack_handler, 0);
f0103cfb:	b8 e8 46 10 f0       	mov    $0xf01046e8,%eax
f0103d00:	66 a3 c0 72 23 f0    	mov    %ax,0xf02372c0
f0103d06:	66 c7 05 c2 72 23 f0 	movw   $0x8,0xf02372c2
f0103d0d:	08 00 
f0103d0f:	c6 05 c4 72 23 f0 00 	movb   $0x0,0xf02372c4
f0103d16:	c6 05 c5 72 23 f0 8e 	movb   $0x8e,0xf02372c5
f0103d1d:	c1 e8 10             	shr    $0x10,%eax
f0103d20:	66 a3 c6 72 23 f0    	mov    %ax,0xf02372c6
	SETGATE(idt[T_GPFLT], 0, GD_KT, gpflt_handler, 0);
f0103d26:	b8 f0 46 10 f0       	mov    $0xf01046f0,%eax
f0103d2b:	66 a3 c8 72 23 f0    	mov    %ax,0xf02372c8
f0103d31:	66 c7 05 ca 72 23 f0 	movw   $0x8,0xf02372ca
f0103d38:	08 00 
f0103d3a:	c6 05 cc 72 23 f0 00 	movb   $0x0,0xf02372cc
f0103d41:	c6 05 cd 72 23 f0 8e 	movb   $0x8e,0xf02372cd
f0103d48:	c1 e8 10             	shr    $0x10,%eax
f0103d4b:	66 a3 ce 72 23 f0    	mov    %ax,0xf02372ce
	SETGATE(idt[T_PGFLT], 0, GD_KT, pgflt_handler, 0);
f0103d51:	b8 f8 46 10 f0       	mov    $0xf01046f8,%eax
f0103d56:	66 a3 d0 72 23 f0    	mov    %ax,0xf02372d0
f0103d5c:	66 c7 05 d2 72 23 f0 	movw   $0x8,0xf02372d2
f0103d63:	08 00 
f0103d65:	c6 05 d4 72 23 f0 00 	movb   $0x0,0xf02372d4
f0103d6c:	c6 05 d5 72 23 f0 8e 	movb   $0x8e,0xf02372d5
f0103d73:	c1 e8 10             	shr    $0x10,%eax
f0103d76:	66 a3 d6 72 23 f0    	mov    %ax,0xf02372d6
	SETGATE(idt[T_FPERR], 0, GD_KT, fperr_handler, 0);
f0103d7c:	b8 fc 46 10 f0       	mov    $0xf01046fc,%eax
f0103d81:	66 a3 e0 72 23 f0    	mov    %ax,0xf02372e0
f0103d87:	66 c7 05 e2 72 23 f0 	movw   $0x8,0xf02372e2
f0103d8e:	08 00 
f0103d90:	c6 05 e4 72 23 f0 00 	movb   $0x0,0xf02372e4
f0103d97:	c6 05 e5 72 23 f0 8e 	movb   $0x8e,0xf02372e5
f0103d9e:	c1 e8 10             	shr    $0x10,%eax
f0103da1:	66 a3 e6 72 23 f0    	mov    %ax,0xf02372e6
	SETGATE(idt[T_ALIGN], 0, GD_KT, align_handler, 0);
f0103da7:	b8 02 47 10 f0       	mov    $0xf0104702,%eax
f0103dac:	66 a3 e8 72 23 f0    	mov    %ax,0xf02372e8
f0103db2:	66 c7 05 ea 72 23 f0 	movw   $0x8,0xf02372ea
f0103db9:	08 00 
f0103dbb:	c6 05 ec 72 23 f0 00 	movb   $0x0,0xf02372ec
f0103dc2:	c6 05 ed 72 23 f0 8e 	movb   $0x8e,0xf02372ed
f0103dc9:	c1 e8 10             	shr    $0x10,%eax
f0103dcc:	66 a3 ee 72 23 f0    	mov    %ax,0xf02372ee
	SETGATE(idt[T_MCHK], 0, GD_KT, mchk_handler, 0);
f0103dd2:	b8 06 47 10 f0       	mov    $0xf0104706,%eax
f0103dd7:	66 a3 f0 72 23 f0    	mov    %ax,0xf02372f0
f0103ddd:	66 c7 05 f2 72 23 f0 	movw   $0x8,0xf02372f2
f0103de4:	08 00 
f0103de6:	c6 05 f4 72 23 f0 00 	movb   $0x0,0xf02372f4
f0103ded:	c6 05 f5 72 23 f0 8e 	movb   $0x8e,0xf02372f5
f0103df4:	c1 e8 10             	shr    $0x10,%eax
f0103df7:	66 a3 f6 72 23 f0    	mov    %ax,0xf02372f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, simderr_handler, 0);
f0103dfd:	b8 0c 47 10 f0       	mov    $0xf010470c,%eax
f0103e02:	66 a3 f8 72 23 f0    	mov    %ax,0xf02372f8
f0103e08:	66 c7 05 fa 72 23 f0 	movw   $0x8,0xf02372fa
f0103e0f:	08 00 
f0103e11:	c6 05 fc 72 23 f0 00 	movb   $0x0,0xf02372fc
f0103e18:	c6 05 fd 72 23 f0 8e 	movb   $0x8e,0xf02372fd
f0103e1f:	c1 e8 10             	shr    $0x10,%eax
f0103e22:	66 a3 fe 72 23 f0    	mov    %ax,0xf02372fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, syscall_handler, 3);
f0103e28:	b8 12 47 10 f0       	mov    $0xf0104712,%eax
f0103e2d:	66 a3 e0 73 23 f0    	mov    %ax,0xf02373e0
f0103e33:	66 c7 05 e2 73 23 f0 	movw   $0x8,0xf02373e2
f0103e3a:	08 00 
f0103e3c:	c6 05 e4 73 23 f0 00 	movb   $0x0,0xf02373e4
f0103e43:	c6 05 e5 73 23 f0 ee 	movb   $0xee,0xf02373e5
f0103e4a:	c1 e8 10             	shr    $0x10,%eax
f0103e4d:	66 a3 e6 73 23 f0    	mov    %ax,0xf02373e6
	SETGATE(idt[IRQ_OFFSET + 0], 0, GD_KT, irq_0_handler, 0);
f0103e53:	b8 18 47 10 f0       	mov    $0xf0104718,%eax
f0103e58:	66 a3 60 73 23 f0    	mov    %ax,0xf0237360
f0103e5e:	66 c7 05 62 73 23 f0 	movw   $0x8,0xf0237362
f0103e65:	08 00 
f0103e67:	c6 05 64 73 23 f0 00 	movb   $0x0,0xf0237364
f0103e6e:	c6 05 65 73 23 f0 8e 	movb   $0x8e,0xf0237365
f0103e75:	c1 e8 10             	shr    $0x10,%eax
f0103e78:	66 a3 66 73 23 f0    	mov    %ax,0xf0237366
	SETGATE(idt[IRQ_OFFSET + 1], 0, GD_KT, irq_1_handler, 0);
f0103e7e:	b8 1e 47 10 f0       	mov    $0xf010471e,%eax
f0103e83:	66 a3 68 73 23 f0    	mov    %ax,0xf0237368
f0103e89:	66 c7 05 6a 73 23 f0 	movw   $0x8,0xf023736a
f0103e90:	08 00 
f0103e92:	c6 05 6c 73 23 f0 00 	movb   $0x0,0xf023736c
f0103e99:	c6 05 6d 73 23 f0 8e 	movb   $0x8e,0xf023736d
f0103ea0:	c1 e8 10             	shr    $0x10,%eax
f0103ea3:	66 a3 6e 73 23 f0    	mov    %ax,0xf023736e
	SETGATE(idt[IRQ_OFFSET + 2], 0, GD_KT, irq_2_handler, 0);
f0103ea9:	b8 24 47 10 f0       	mov    $0xf0104724,%eax
f0103eae:	66 a3 70 73 23 f0    	mov    %ax,0xf0237370
f0103eb4:	66 c7 05 72 73 23 f0 	movw   $0x8,0xf0237372
f0103ebb:	08 00 
f0103ebd:	c6 05 74 73 23 f0 00 	movb   $0x0,0xf0237374
f0103ec4:	c6 05 75 73 23 f0 8e 	movb   $0x8e,0xf0237375
f0103ecb:	c1 e8 10             	shr    $0x10,%eax
f0103ece:	66 a3 76 73 23 f0    	mov    %ax,0xf0237376
	SETGATE(idt[IRQ_OFFSET + 3], 0, GD_KT, irq_3_handler, 0);
f0103ed4:	b8 2a 47 10 f0       	mov    $0xf010472a,%eax
f0103ed9:	66 a3 78 73 23 f0    	mov    %ax,0xf0237378
f0103edf:	66 c7 05 7a 73 23 f0 	movw   $0x8,0xf023737a
f0103ee6:	08 00 
f0103ee8:	c6 05 7c 73 23 f0 00 	movb   $0x0,0xf023737c
f0103eef:	c6 05 7d 73 23 f0 8e 	movb   $0x8e,0xf023737d
f0103ef6:	c1 e8 10             	shr    $0x10,%eax
f0103ef9:	66 a3 7e 73 23 f0    	mov    %ax,0xf023737e
	SETGATE(idt[IRQ_OFFSET + 4], 0, GD_KT, irq_4_handler, 0);
f0103eff:	b8 30 47 10 f0       	mov    $0xf0104730,%eax
f0103f04:	66 a3 80 73 23 f0    	mov    %ax,0xf0237380
f0103f0a:	66 c7 05 82 73 23 f0 	movw   $0x8,0xf0237382
f0103f11:	08 00 
f0103f13:	c6 05 84 73 23 f0 00 	movb   $0x0,0xf0237384
f0103f1a:	c6 05 85 73 23 f0 8e 	movb   $0x8e,0xf0237385
f0103f21:	c1 e8 10             	shr    $0x10,%eax
f0103f24:	66 a3 86 73 23 f0    	mov    %ax,0xf0237386
	SETGATE(idt[IRQ_OFFSET + 5], 0, GD_KT, irq_5_handler, 0);
f0103f2a:	b8 36 47 10 f0       	mov    $0xf0104736,%eax
f0103f2f:	66 a3 88 73 23 f0    	mov    %ax,0xf0237388
f0103f35:	66 c7 05 8a 73 23 f0 	movw   $0x8,0xf023738a
f0103f3c:	08 00 
f0103f3e:	c6 05 8c 73 23 f0 00 	movb   $0x0,0xf023738c
f0103f45:	c6 05 8d 73 23 f0 8e 	movb   $0x8e,0xf023738d
f0103f4c:	c1 e8 10             	shr    $0x10,%eax
f0103f4f:	66 a3 8e 73 23 f0    	mov    %ax,0xf023738e
	SETGATE(idt[IRQ_OFFSET + 6], 0, GD_KT, irq_6_handler, 0);
f0103f55:	b8 3c 47 10 f0       	mov    $0xf010473c,%eax
f0103f5a:	66 a3 90 73 23 f0    	mov    %ax,0xf0237390
f0103f60:	66 c7 05 92 73 23 f0 	movw   $0x8,0xf0237392
f0103f67:	08 00 
f0103f69:	c6 05 94 73 23 f0 00 	movb   $0x0,0xf0237394
f0103f70:	c6 05 95 73 23 f0 8e 	movb   $0x8e,0xf0237395
f0103f77:	c1 e8 10             	shr    $0x10,%eax
f0103f7a:	66 a3 96 73 23 f0    	mov    %ax,0xf0237396
	SETGATE(idt[IRQ_OFFSET + 7], 0, GD_KT, irq_7_handler, 0);
f0103f80:	b8 42 47 10 f0       	mov    $0xf0104742,%eax
f0103f85:	66 a3 98 73 23 f0    	mov    %ax,0xf0237398
f0103f8b:	66 c7 05 9a 73 23 f0 	movw   $0x8,0xf023739a
f0103f92:	08 00 
f0103f94:	c6 05 9c 73 23 f0 00 	movb   $0x0,0xf023739c
f0103f9b:	c6 05 9d 73 23 f0 8e 	movb   $0x8e,0xf023739d
f0103fa2:	c1 e8 10             	shr    $0x10,%eax
f0103fa5:	66 a3 9e 73 23 f0    	mov    %ax,0xf023739e
	SETGATE(idt[IRQ_OFFSET + 8], 0, GD_KT, irq_8_handler, 0);
f0103fab:	b8 48 47 10 f0       	mov    $0xf0104748,%eax
f0103fb0:	66 a3 a0 73 23 f0    	mov    %ax,0xf02373a0
f0103fb6:	66 c7 05 a2 73 23 f0 	movw   $0x8,0xf02373a2
f0103fbd:	08 00 
f0103fbf:	c6 05 a4 73 23 f0 00 	movb   $0x0,0xf02373a4
f0103fc6:	c6 05 a5 73 23 f0 8e 	movb   $0x8e,0xf02373a5
f0103fcd:	c1 e8 10             	shr    $0x10,%eax
f0103fd0:	66 a3 a6 73 23 f0    	mov    %ax,0xf02373a6
	SETGATE(idt[IRQ_OFFSET + 9], 0, GD_KT, irq_9_handler, 0);
f0103fd6:	b8 4e 47 10 f0       	mov    $0xf010474e,%eax
f0103fdb:	66 a3 a8 73 23 f0    	mov    %ax,0xf02373a8
f0103fe1:	66 c7 05 aa 73 23 f0 	movw   $0x8,0xf02373aa
f0103fe8:	08 00 
f0103fea:	c6 05 ac 73 23 f0 00 	movb   $0x0,0xf02373ac
f0103ff1:	c6 05 ad 73 23 f0 8e 	movb   $0x8e,0xf02373ad
f0103ff8:	c1 e8 10             	shr    $0x10,%eax
f0103ffb:	66 a3 ae 73 23 f0    	mov    %ax,0xf02373ae
	SETGATE(idt[IRQ_OFFSET + 10], 0, GD_KT, irq_10_handler, 0);
f0104001:	b8 54 47 10 f0       	mov    $0xf0104754,%eax
f0104006:	66 a3 b0 73 23 f0    	mov    %ax,0xf02373b0
f010400c:	66 c7 05 b2 73 23 f0 	movw   $0x8,0xf02373b2
f0104013:	08 00 
f0104015:	c6 05 b4 73 23 f0 00 	movb   $0x0,0xf02373b4
f010401c:	c6 05 b5 73 23 f0 8e 	movb   $0x8e,0xf02373b5
f0104023:	c1 e8 10             	shr    $0x10,%eax
f0104026:	66 a3 b6 73 23 f0    	mov    %ax,0xf02373b6
	SETGATE(idt[IRQ_OFFSET + 11], 0, GD_KT, irq_11_handler, 0);
f010402c:	b8 5a 47 10 f0       	mov    $0xf010475a,%eax
f0104031:	66 a3 b8 73 23 f0    	mov    %ax,0xf02373b8
f0104037:	66 c7 05 ba 73 23 f0 	movw   $0x8,0xf02373ba
f010403e:	08 00 
f0104040:	c6 05 bc 73 23 f0 00 	movb   $0x0,0xf02373bc
f0104047:	c6 05 bd 73 23 f0 8e 	movb   $0x8e,0xf02373bd
f010404e:	c1 e8 10             	shr    $0x10,%eax
f0104051:	66 a3 be 73 23 f0    	mov    %ax,0xf02373be
	SETGATE(idt[IRQ_OFFSET + 12], 0, GD_KT, irq_12_handler, 0);
f0104057:	b8 60 47 10 f0       	mov    $0xf0104760,%eax
f010405c:	66 a3 c0 73 23 f0    	mov    %ax,0xf02373c0
f0104062:	66 c7 05 c2 73 23 f0 	movw   $0x8,0xf02373c2
f0104069:	08 00 
f010406b:	c6 05 c4 73 23 f0 00 	movb   $0x0,0xf02373c4
f0104072:	c6 05 c5 73 23 f0 8e 	movb   $0x8e,0xf02373c5
f0104079:	c1 e8 10             	shr    $0x10,%eax
f010407c:	66 a3 c6 73 23 f0    	mov    %ax,0xf02373c6
	SETGATE(idt[IRQ_OFFSET + 13], 0, GD_KT, irq_13_handler, 0);
f0104082:	b8 66 47 10 f0       	mov    $0xf0104766,%eax
f0104087:	66 a3 c8 73 23 f0    	mov    %ax,0xf02373c8
f010408d:	66 c7 05 ca 73 23 f0 	movw   $0x8,0xf02373ca
f0104094:	08 00 
f0104096:	c6 05 cc 73 23 f0 00 	movb   $0x0,0xf02373cc
f010409d:	c6 05 cd 73 23 f0 8e 	movb   $0x8e,0xf02373cd
f01040a4:	c1 e8 10             	shr    $0x10,%eax
f01040a7:	66 a3 ce 73 23 f0    	mov    %ax,0xf02373ce
	SETGATE(idt[IRQ_OFFSET + 14], 0, GD_KT, irq_14_handler, 0);
f01040ad:	b8 6c 47 10 f0       	mov    $0xf010476c,%eax
f01040b2:	66 a3 d0 73 23 f0    	mov    %ax,0xf02373d0
f01040b8:	66 c7 05 d2 73 23 f0 	movw   $0x8,0xf02373d2
f01040bf:	08 00 
f01040c1:	c6 05 d4 73 23 f0 00 	movb   $0x0,0xf02373d4
f01040c8:	c6 05 d5 73 23 f0 8e 	movb   $0x8e,0xf02373d5
f01040cf:	c1 e8 10             	shr    $0x10,%eax
f01040d2:	66 a3 d6 73 23 f0    	mov    %ax,0xf02373d6
	SETGATE(idt[IRQ_OFFSET + 15], 0, GD_KT, irq_15_handler, 0);
f01040d8:	b8 72 47 10 f0       	mov    $0xf0104772,%eax
f01040dd:	66 a3 d8 73 23 f0    	mov    %ax,0xf02373d8
f01040e3:	66 c7 05 da 73 23 f0 	movw   $0x8,0xf02373da
f01040ea:	08 00 
f01040ec:	c6 05 dc 73 23 f0 00 	movb   $0x0,0xf02373dc
f01040f3:	c6 05 dd 73 23 f0 8e 	movb   $0x8e,0xf02373dd
f01040fa:	c1 e8 10             	shr    $0x10,%eax
f01040fd:	66 a3 de 73 23 f0    	mov    %ax,0xf02373de
	trap_init_percpu();
f0104103:	e8 3f f9 ff ff       	call   f0103a47 <trap_init_percpu>
}
f0104108:	c9                   	leave  
f0104109:	c3                   	ret    

f010410a <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f010410a:	f3 0f 1e fb          	endbr32 
f010410e:	55                   	push   %ebp
f010410f:	89 e5                	mov    %esp,%ebp
f0104111:	53                   	push   %ebx
f0104112:	83 ec 0c             	sub    $0xc,%esp
f0104115:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104118:	ff 33                	pushl  (%ebx)
f010411a:	68 20 7b 10 f0       	push   $0xf0107b20
f010411f:	e8 0b f9 ff ff       	call   f0103a2f <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104124:	83 c4 08             	add    $0x8,%esp
f0104127:	ff 73 04             	pushl  0x4(%ebx)
f010412a:	68 2f 7b 10 f0       	push   $0xf0107b2f
f010412f:	e8 fb f8 ff ff       	call   f0103a2f <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0104134:	83 c4 08             	add    $0x8,%esp
f0104137:	ff 73 08             	pushl  0x8(%ebx)
f010413a:	68 3e 7b 10 f0       	push   $0xf0107b3e
f010413f:	e8 eb f8 ff ff       	call   f0103a2f <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0104144:	83 c4 08             	add    $0x8,%esp
f0104147:	ff 73 0c             	pushl  0xc(%ebx)
f010414a:	68 4d 7b 10 f0       	push   $0xf0107b4d
f010414f:	e8 db f8 ff ff       	call   f0103a2f <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104154:	83 c4 08             	add    $0x8,%esp
f0104157:	ff 73 10             	pushl  0x10(%ebx)
f010415a:	68 5c 7b 10 f0       	push   $0xf0107b5c
f010415f:	e8 cb f8 ff ff       	call   f0103a2f <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104164:	83 c4 08             	add    $0x8,%esp
f0104167:	ff 73 14             	pushl  0x14(%ebx)
f010416a:	68 6b 7b 10 f0       	push   $0xf0107b6b
f010416f:	e8 bb f8 ff ff       	call   f0103a2f <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0104174:	83 c4 08             	add    $0x8,%esp
f0104177:	ff 73 18             	pushl  0x18(%ebx)
f010417a:	68 7a 7b 10 f0       	push   $0xf0107b7a
f010417f:	e8 ab f8 ff ff       	call   f0103a2f <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0104184:	83 c4 08             	add    $0x8,%esp
f0104187:	ff 73 1c             	pushl  0x1c(%ebx)
f010418a:	68 89 7b 10 f0       	push   $0xf0107b89
f010418f:	e8 9b f8 ff ff       	call   f0103a2f <cprintf>
}
f0104194:	83 c4 10             	add    $0x10,%esp
f0104197:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010419a:	c9                   	leave  
f010419b:	c3                   	ret    

f010419c <print_trapframe>:
{
f010419c:	f3 0f 1e fb          	endbr32 
f01041a0:	55                   	push   %ebp
f01041a1:	89 e5                	mov    %esp,%ebp
f01041a3:	56                   	push   %esi
f01041a4:	53                   	push   %ebx
f01041a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f01041a8:	e8 0d 1f 00 00       	call   f01060ba <cpunum>
f01041ad:	83 ec 04             	sub    $0x4,%esp
f01041b0:	50                   	push   %eax
f01041b1:	53                   	push   %ebx
f01041b2:	68 ed 7b 10 f0       	push   $0xf0107bed
f01041b7:	e8 73 f8 ff ff       	call   f0103a2f <cprintf>
	print_regs(&tf->tf_regs);
f01041bc:	89 1c 24             	mov    %ebx,(%esp)
f01041bf:	e8 46 ff ff ff       	call   f010410a <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f01041c4:	83 c4 08             	add    $0x8,%esp
f01041c7:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f01041cb:	50                   	push   %eax
f01041cc:	68 0b 7c 10 f0       	push   $0xf0107c0b
f01041d1:	e8 59 f8 ff ff       	call   f0103a2f <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01041d6:	83 c4 08             	add    $0x8,%esp
f01041d9:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f01041dd:	50                   	push   %eax
f01041de:	68 1e 7c 10 f0       	push   $0xf0107c1e
f01041e3:	e8 47 f8 ff ff       	call   f0103a2f <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01041e8:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f01041eb:	83 c4 10             	add    $0x10,%esp
f01041ee:	83 f8 13             	cmp    $0x13,%eax
f01041f1:	0f 86 da 00 00 00    	jbe    f01042d1 <print_trapframe+0x135>
		return "System call";
f01041f7:	ba 98 7b 10 f0       	mov    $0xf0107b98,%edx
	if (trapno == T_SYSCALL)
f01041fc:	83 f8 30             	cmp    $0x30,%eax
f01041ff:	74 13                	je     f0104214 <print_trapframe+0x78>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0104201:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0104204:	83 fa 0f             	cmp    $0xf,%edx
f0104207:	ba a4 7b 10 f0       	mov    $0xf0107ba4,%edx
f010420c:	b9 b3 7b 10 f0       	mov    $0xf0107bb3,%ecx
f0104211:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104214:	83 ec 04             	sub    $0x4,%esp
f0104217:	52                   	push   %edx
f0104218:	50                   	push   %eax
f0104219:	68 31 7c 10 f0       	push   $0xf0107c31
f010421e:	e8 0c f8 ff ff       	call   f0103a2f <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104223:	83 c4 10             	add    $0x10,%esp
f0104226:	39 1d 60 7a 23 f0    	cmp    %ebx,0xf0237a60
f010422c:	0f 84 ab 00 00 00    	je     f01042dd <print_trapframe+0x141>
	cprintf("  err  0x%08x", tf->tf_err);
f0104232:	83 ec 08             	sub    $0x8,%esp
f0104235:	ff 73 2c             	pushl  0x2c(%ebx)
f0104238:	68 52 7c 10 f0       	push   $0xf0107c52
f010423d:	e8 ed f7 ff ff       	call   f0103a2f <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0104242:	83 c4 10             	add    $0x10,%esp
f0104245:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104249:	0f 85 b1 00 00 00    	jne    f0104300 <print_trapframe+0x164>
			tf->tf_err & 1 ? "protection" : "not-present");
f010424f:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0104252:	a8 01                	test   $0x1,%al
f0104254:	b9 c6 7b 10 f0       	mov    $0xf0107bc6,%ecx
f0104259:	ba d1 7b 10 f0       	mov    $0xf0107bd1,%edx
f010425e:	0f 44 ca             	cmove  %edx,%ecx
f0104261:	a8 02                	test   $0x2,%al
f0104263:	be dd 7b 10 f0       	mov    $0xf0107bdd,%esi
f0104268:	ba e3 7b 10 f0       	mov    $0xf0107be3,%edx
f010426d:	0f 45 d6             	cmovne %esi,%edx
f0104270:	a8 04                	test   $0x4,%al
f0104272:	b8 e8 7b 10 f0       	mov    $0xf0107be8,%eax
f0104277:	be 16 7d 10 f0       	mov    $0xf0107d16,%esi
f010427c:	0f 44 c6             	cmove  %esi,%eax
f010427f:	51                   	push   %ecx
f0104280:	52                   	push   %edx
f0104281:	50                   	push   %eax
f0104282:	68 60 7c 10 f0       	push   $0xf0107c60
f0104287:	e8 a3 f7 ff ff       	call   f0103a2f <cprintf>
f010428c:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f010428f:	83 ec 08             	sub    $0x8,%esp
f0104292:	ff 73 30             	pushl  0x30(%ebx)
f0104295:	68 6f 7c 10 f0       	push   $0xf0107c6f
f010429a:	e8 90 f7 ff ff       	call   f0103a2f <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f010429f:	83 c4 08             	add    $0x8,%esp
f01042a2:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f01042a6:	50                   	push   %eax
f01042a7:	68 7e 7c 10 f0       	push   $0xf0107c7e
f01042ac:	e8 7e f7 ff ff       	call   f0103a2f <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f01042b1:	83 c4 08             	add    $0x8,%esp
f01042b4:	ff 73 38             	pushl  0x38(%ebx)
f01042b7:	68 91 7c 10 f0       	push   $0xf0107c91
f01042bc:	e8 6e f7 ff ff       	call   f0103a2f <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f01042c1:	83 c4 10             	add    $0x10,%esp
f01042c4:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01042c8:	75 4b                	jne    f0104315 <print_trapframe+0x179>
}
f01042ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01042cd:	5b                   	pop    %ebx
f01042ce:	5e                   	pop    %esi
f01042cf:	5d                   	pop    %ebp
f01042d0:	c3                   	ret    
		return excnames[trapno];
f01042d1:	8b 14 85 c0 7e 10 f0 	mov    -0xfef8140(,%eax,4),%edx
f01042d8:	e9 37 ff ff ff       	jmp    f0104214 <print_trapframe+0x78>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01042dd:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01042e1:	0f 85 4b ff ff ff    	jne    f0104232 <print_trapframe+0x96>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f01042e7:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f01042ea:	83 ec 08             	sub    $0x8,%esp
f01042ed:	50                   	push   %eax
f01042ee:	68 43 7c 10 f0       	push   $0xf0107c43
f01042f3:	e8 37 f7 ff ff       	call   f0103a2f <cprintf>
f01042f8:	83 c4 10             	add    $0x10,%esp
f01042fb:	e9 32 ff ff ff       	jmp    f0104232 <print_trapframe+0x96>
		cprintf("\n");
f0104300:	83 ec 0c             	sub    $0xc,%esp
f0104303:	68 d6 6f 10 f0       	push   $0xf0106fd6
f0104308:	e8 22 f7 ff ff       	call   f0103a2f <cprintf>
f010430d:	83 c4 10             	add    $0x10,%esp
f0104310:	e9 7a ff ff ff       	jmp    f010428f <print_trapframe+0xf3>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104315:	83 ec 08             	sub    $0x8,%esp
f0104318:	ff 73 3c             	pushl  0x3c(%ebx)
f010431b:	68 a0 7c 10 f0       	push   $0xf0107ca0
f0104320:	e8 0a f7 ff ff       	call   f0103a2f <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104325:	83 c4 08             	add    $0x8,%esp
f0104328:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f010432c:	50                   	push   %eax
f010432d:	68 af 7c 10 f0       	push   $0xf0107caf
f0104332:	e8 f8 f6 ff ff       	call   f0103a2f <cprintf>
f0104337:	83 c4 10             	add    $0x10,%esp
}
f010433a:	eb 8e                	jmp    f01042ca <print_trapframe+0x12e>

f010433c <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f010433c:	f3 0f 1e fb          	endbr32 
f0104340:	55                   	push   %ebp
f0104341:	89 e5                	mov    %esp,%ebp
f0104343:	57                   	push   %edi
f0104344:	56                   	push   %esi
f0104345:	53                   	push   %ebx
f0104346:	83 ec 1c             	sub    $0x1c,%esp
f0104349:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010434c:	0f 20 d0             	mov    %cr2,%eax
f010434f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if((tf->tf_cs & 0x3) == 0)
f0104352:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104356:	74 5f                	je     f01043b7 <page_fault_handler+0x7b>

	// LAB 4: Your code here.
	// 判断是否存在page fault的处理函数
	// 如果存在继续执行下去
	// 如果不存在则执行下面已经给定的销毁进程的代码
	if(curenv->env_pgfault_upcall) {
f0104358:	e8 5d 1d 00 00       	call   f01060ba <cpunum>
f010435d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104360:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0104366:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f010436a:	75 62                	jne    f01043ce <page_fault_handler+0x92>
    	tf->tf_eip = (uint32_t)curenv->env_pgfault_upcall;
		env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010436c:	8b 73 30             	mov    0x30(%ebx),%esi
		curenv->env_id, fault_va, tf->tf_eip);
f010436f:	e8 46 1d 00 00       	call   f01060ba <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104374:	56                   	push   %esi
f0104375:	ff 75 e4             	pushl  -0x1c(%ebp)
		curenv->env_id, fault_va, tf->tf_eip);
f0104378:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010437b:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0104381:	ff 70 48             	pushl  0x48(%eax)
f0104384:	68 90 7e 10 f0       	push   $0xf0107e90
f0104389:	e8 a1 f6 ff ff       	call   f0103a2f <cprintf>
	print_trapframe(tf);
f010438e:	89 1c 24             	mov    %ebx,(%esp)
f0104391:	e8 06 fe ff ff       	call   f010419c <print_trapframe>
	env_destroy(curenv);
f0104396:	e8 1f 1d 00 00       	call   f01060ba <cpunum>
f010439b:	83 c4 04             	add    $0x4,%esp
f010439e:	6b c0 74             	imul   $0x74,%eax,%eax
f01043a1:	ff b0 28 80 23 f0    	pushl  -0xfdc7fd8(%eax)
f01043a7:	e8 98 f3 ff ff       	call   f0103744 <env_destroy>
}
f01043ac:	83 c4 10             	add    $0x10,%esp
f01043af:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01043b2:	5b                   	pop    %ebx
f01043b3:	5e                   	pop    %esi
f01043b4:	5f                   	pop    %edi
f01043b5:	5d                   	pop    %ebp
f01043b6:	c3                   	ret    
		panic("page_fault_handler panic, page fault in kernel\n");
f01043b7:	83 ec 04             	sub    $0x4,%esp
f01043ba:	68 60 7e 10 f0       	push   $0xf0107e60
f01043bf:	68 7a 01 00 00       	push   $0x17a
f01043c4:	68 c2 7c 10 f0       	push   $0xf0107cc2
f01043c9:	e8 72 bc ff ff       	call   f0100040 <_panic>
		if(tf->tf_esp > UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP - 1){
f01043ce:	8b 4b 3c             	mov    0x3c(%ebx),%ecx
f01043d1:	8d 81 ff 0f 40 11    	lea    0x11400fff(%ecx),%eax
		uintptr_t exstacktop = UXSTACKTOP;
f01043d7:	3d fe 0f 00 00       	cmp    $0xffe,%eax
f01043dc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f01043e1:	0f 42 c1             	cmovb  %ecx,%eax
f01043e4:	89 c6                	mov    %eax,%esi
		user_mem_assert(curenv, (void*)exstacktop - stacksize, stacksize, PTE_U | PTE_W);
f01043e6:	8d 50 c8             	lea    -0x38(%eax),%edx
f01043e9:	89 d7                	mov    %edx,%edi
f01043eb:	e8 ca 1c 00 00       	call   f01060ba <cpunum>
f01043f0:	6a 06                	push   $0x6
f01043f2:	6a 38                	push   $0x38
f01043f4:	57                   	push   %edi
f01043f5:	6b c0 74             	imul   $0x74,%eax,%eax
f01043f8:	ff b0 28 80 23 f0    	pushl  -0xfdc7fd8(%eax)
f01043fe:	e8 86 ec ff ff       	call   f0103089 <user_mem_assert>
		utf->utf_eflags = tf->tf_eflags;
f0104403:	8b 43 38             	mov    0x38(%ebx),%eax
f0104406:	89 47 2c             	mov    %eax,0x2c(%edi)
    	utf->utf_eip = tf->tf_eip;
f0104409:	8b 43 30             	mov    0x30(%ebx),%eax
f010440c:	89 fa                	mov    %edi,%edx
f010440e:	89 47 28             	mov    %eax,0x28(%edi)
    	utf->utf_esp = tf->tf_esp;
f0104411:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104414:	89 47 30             	mov    %eax,0x30(%edi)
    	utf->utf_regs = tf->tf_regs;
f0104417:	89 75 e0             	mov    %esi,-0x20(%ebp)
f010441a:	8d 7e d0             	lea    -0x30(%esi),%edi
f010441d:	b9 08 00 00 00       	mov    $0x8,%ecx
f0104422:	89 de                	mov    %ebx,%esi
f0104424:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    	utf->utf_err = tf->tf_err;
f0104426:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104429:	89 42 04             	mov    %eax,0x4(%edx)
    	utf->utf_fault_va = fault_va;
f010442c:	8b 75 e0             	mov    -0x20(%ebp),%esi
f010442f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104432:	89 46 c8             	mov    %eax,-0x38(%esi)
		tf->tf_esp = (uintptr_t)utf;
f0104435:	89 53 3c             	mov    %edx,0x3c(%ebx)
    	tf->tf_eip = (uint32_t)curenv->env_pgfault_upcall;
f0104438:	e8 7d 1c 00 00       	call   f01060ba <cpunum>
f010443d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104440:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0104446:	8b 40 64             	mov    0x64(%eax),%eax
f0104449:	89 43 30             	mov    %eax,0x30(%ebx)
		env_run(curenv);
f010444c:	e8 69 1c 00 00       	call   f01060ba <cpunum>
f0104451:	83 c4 04             	add    $0x4,%esp
f0104454:	6b c0 74             	imul   $0x74,%eax,%eax
f0104457:	ff b0 28 80 23 f0    	pushl  -0xfdc7fd8(%eax)
f010445d:	e8 89 f3 ff ff       	call   f01037eb <env_run>

f0104462 <trap>:
{
f0104462:	f3 0f 1e fb          	endbr32 
f0104466:	55                   	push   %ebp
f0104467:	89 e5                	mov    %esp,%ebp
f0104469:	57                   	push   %edi
f010446a:	56                   	push   %esi
f010446b:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f010446e:	fc                   	cld    
	if (panicstr)
f010446f:	83 3d 80 7e 23 f0 00 	cmpl   $0x0,0xf0237e80
f0104476:	74 01                	je     f0104479 <trap+0x17>
		asm volatile("hlt");
f0104478:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104479:	e8 3c 1c 00 00       	call   f01060ba <cpunum>
f010447e:	6b d0 74             	imul   $0x74,%eax,%edx
f0104481:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104484:	b8 01 00 00 00       	mov    $0x1,%eax
f0104489:	f0 87 82 20 80 23 f0 	lock xchg %eax,-0xfdc7fe0(%edx)
f0104490:	83 f8 02             	cmp    $0x2,%eax
f0104493:	0f 84 87 00 00 00    	je     f0104520 <trap+0xbe>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0104499:	9c                   	pushf  
f010449a:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f010449b:	f6 c4 02             	test   $0x2,%ah
f010449e:	0f 85 91 00 00 00    	jne    f0104535 <trap+0xd3>
	if ((tf->tf_cs & 3) == 3) {
f01044a4:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f01044a8:	83 e0 03             	and    $0x3,%eax
f01044ab:	66 83 f8 03          	cmp    $0x3,%ax
f01044af:	0f 84 99 00 00 00    	je     f010454e <trap+0xec>
	last_tf = tf;
f01044b5:	89 35 60 7a 23 f0    	mov    %esi,0xf0237a60
	switch(tf->tf_trapno)
f01044bb:	8b 46 28             	mov    0x28(%esi),%eax
f01044be:	83 f8 0e             	cmp    $0xe,%eax
f01044c1:	0f 84 02 01 00 00    	je     f01045c9 <trap+0x167>
f01044c7:	83 f8 30             	cmp    $0x30,%eax
f01044ca:	0f 84 3d 01 00 00    	je     f010460d <trap+0x1ab>
f01044d0:	83 f8 03             	cmp    $0x3,%eax
f01044d3:	0f 84 26 01 00 00    	je     f01045ff <trap+0x19d>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f01044d9:	83 f8 27             	cmp    $0x27,%eax
f01044dc:	0f 84 4c 01 00 00    	je     f010462e <trap+0x1cc>
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f01044e2:	83 f8 20             	cmp    $0x20,%eax
f01044e5:	0f 84 5d 01 00 00    	je     f0104648 <trap+0x1e6>
	print_trapframe(tf);
f01044eb:	83 ec 0c             	sub    $0xc,%esp
f01044ee:	56                   	push   %esi
f01044ef:	e8 a8 fc ff ff       	call   f010419c <print_trapframe>
	if (tf->tf_cs == GD_KT)
f01044f4:	83 c4 10             	add    $0x10,%esp
f01044f7:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f01044fc:	0f 84 50 01 00 00    	je     f0104652 <trap+0x1f0>
		env_destroy(curenv);
f0104502:	e8 b3 1b 00 00       	call   f01060ba <cpunum>
f0104507:	83 ec 0c             	sub    $0xc,%esp
f010450a:	6b c0 74             	imul   $0x74,%eax,%eax
f010450d:	ff b0 28 80 23 f0    	pushl  -0xfdc7fd8(%eax)
f0104513:	e8 2c f2 ff ff       	call   f0103744 <env_destroy>
		return;
f0104518:	83 c4 10             	add    $0x10,%esp
f010451b:	e9 b5 00 00 00       	jmp    f01045d5 <trap+0x173>
	spin_lock(&kernel_lock);
f0104520:	83 ec 0c             	sub    $0xc,%esp
f0104523:	68 c0 33 12 f0       	push   $0xf01233c0
f0104528:	e8 15 1e 00 00       	call   f0106342 <spin_lock>
}
f010452d:	83 c4 10             	add    $0x10,%esp
f0104530:	e9 64 ff ff ff       	jmp    f0104499 <trap+0x37>
	assert(!(read_eflags() & FL_IF));
f0104535:	68 ce 7c 10 f0       	push   $0xf0107cce
f010453a:	68 1c 6d 10 f0       	push   $0xf0106d1c
f010453f:	68 44 01 00 00       	push   $0x144
f0104544:	68 c2 7c 10 f0       	push   $0xf0107cc2
f0104549:	e8 f2 ba ff ff       	call   f0100040 <_panic>
	spin_lock(&kernel_lock);
f010454e:	83 ec 0c             	sub    $0xc,%esp
f0104551:	68 c0 33 12 f0       	push   $0xf01233c0
f0104556:	e8 e7 1d 00 00       	call   f0106342 <spin_lock>
		if (curenv->env_status == ENV_DYING) {
f010455b:	e8 5a 1b 00 00       	call   f01060ba <cpunum>
f0104560:	6b c0 74             	imul   $0x74,%eax,%eax
f0104563:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0104569:	83 c4 10             	add    $0x10,%esp
f010456c:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104570:	74 2a                	je     f010459c <trap+0x13a>
		curenv->env_tf = *tf;
f0104572:	e8 43 1b 00 00       	call   f01060ba <cpunum>
f0104577:	6b c0 74             	imul   $0x74,%eax,%eax
f010457a:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0104580:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104585:	89 c7                	mov    %eax,%edi
f0104587:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104589:	e8 2c 1b 00 00       	call   f01060ba <cpunum>
f010458e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104591:	8b b0 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%esi
f0104597:	e9 19 ff ff ff       	jmp    f01044b5 <trap+0x53>
			env_free(curenv);
f010459c:	e8 19 1b 00 00       	call   f01060ba <cpunum>
f01045a1:	83 ec 0c             	sub    $0xc,%esp
f01045a4:	6b c0 74             	imul   $0x74,%eax,%eax
f01045a7:	ff b0 28 80 23 f0    	pushl  -0xfdc7fd8(%eax)
f01045ad:	e8 b1 ef ff ff       	call   f0103563 <env_free>
			curenv = NULL;
f01045b2:	e8 03 1b 00 00       	call   f01060ba <cpunum>
f01045b7:	6b c0 74             	imul   $0x74,%eax,%eax
f01045ba:	c7 80 28 80 23 f0 00 	movl   $0x0,-0xfdc7fd8(%eax)
f01045c1:	00 00 00 
			sched_yield();
f01045c4:	e8 8e 02 00 00       	call   f0104857 <sched_yield>
			page_fault_handler(tf);
f01045c9:	83 ec 0c             	sub    $0xc,%esp
f01045cc:	56                   	push   %esi
f01045cd:	e8 6a fd ff ff       	call   f010433c <page_fault_handler>
			return ;
f01045d2:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f01045d5:	e8 e0 1a 00 00       	call   f01060ba <cpunum>
f01045da:	6b c0 74             	imul   $0x74,%eax,%eax
f01045dd:	83 b8 28 80 23 f0 00 	cmpl   $0x0,-0xfdc7fd8(%eax)
f01045e4:	74 14                	je     f01045fa <trap+0x198>
f01045e6:	e8 cf 1a 00 00       	call   f01060ba <cpunum>
f01045eb:	6b c0 74             	imul   $0x74,%eax,%eax
f01045ee:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f01045f4:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01045f8:	74 6f                	je     f0104669 <trap+0x207>
		sched_yield();
f01045fa:	e8 58 02 00 00       	call   f0104857 <sched_yield>
			monitor(tf);
f01045ff:	83 ec 0c             	sub    $0xc,%esp
f0104602:	56                   	push   %esi
f0104603:	e8 3f c3 ff ff       	call   f0100947 <monitor>
			return ;
f0104608:	83 c4 10             	add    $0x10,%esp
f010460b:	eb c8                	jmp    f01045d5 <trap+0x173>
			p->reg_eax = syscall(p->reg_eax, p->reg_edx, p->reg_ecx, p->reg_ebx, p->reg_edi, p->reg_esi);
f010460d:	83 ec 08             	sub    $0x8,%esp
f0104610:	ff 76 04             	pushl  0x4(%esi)
f0104613:	ff 36                	pushl  (%esi)
f0104615:	ff 76 10             	pushl  0x10(%esi)
f0104618:	ff 76 18             	pushl  0x18(%esi)
f010461b:	ff 76 14             	pushl  0x14(%esi)
f010461e:	ff 76 1c             	pushl  0x1c(%esi)
f0104621:	e8 e0 02 00 00       	call   f0104906 <syscall>
f0104626:	89 46 1c             	mov    %eax,0x1c(%esi)
			return ;
f0104629:	83 c4 20             	add    $0x20,%esp
f010462c:	eb a7                	jmp    f01045d5 <trap+0x173>
		cprintf("Spurious interrupt on irq 7\n");
f010462e:	83 ec 0c             	sub    $0xc,%esp
f0104631:	68 e7 7c 10 f0       	push   $0xf0107ce7
f0104636:	e8 f4 f3 ff ff       	call   f0103a2f <cprintf>
		print_trapframe(tf);
f010463b:	89 34 24             	mov    %esi,(%esp)
f010463e:	e8 59 fb ff ff       	call   f010419c <print_trapframe>
		return;
f0104643:	83 c4 10             	add    $0x10,%esp
f0104646:	eb 8d                	jmp    f01045d5 <trap+0x173>
		lapic_eoi();
f0104648:	e8 bc 1b 00 00       	call   f0106209 <lapic_eoi>
		sched_yield();
f010464d:	e8 05 02 00 00       	call   f0104857 <sched_yield>
		panic("unhandled trap in kernel");
f0104652:	83 ec 04             	sub    $0x4,%esp
f0104655:	68 04 7d 10 f0       	push   $0xf0107d04
f010465a:	68 2a 01 00 00       	push   $0x12a
f010465f:	68 c2 7c 10 f0       	push   $0xf0107cc2
f0104664:	e8 d7 b9 ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f0104669:	e8 4c 1a 00 00       	call   f01060ba <cpunum>
f010466e:	83 ec 0c             	sub    $0xc,%esp
f0104671:	6b c0 74             	imul   $0x74,%eax,%eax
f0104674:	ff b0 28 80 23 f0    	pushl  -0xfdc7fd8(%eax)
f010467a:	e8 6c f1 ff ff       	call   f01037eb <env_run>
f010467f:	90                   	nop

f0104680 <divide_handler>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(divide_handler,T_DIVIDE)
f0104680:	6a 00                	push   $0x0
f0104682:	6a 00                	push   $0x0
f0104684:	e9 ef 00 00 00       	jmp    f0104778 <_alltraps>
f0104689:	90                   	nop

f010468a <debug_handler>:
TRAPHANDLER_NOEC(debug_handler,T_DEBUG)
f010468a:	6a 00                	push   $0x0
f010468c:	6a 01                	push   $0x1
f010468e:	e9 e5 00 00 00       	jmp    f0104778 <_alltraps>
f0104693:	90                   	nop

f0104694 <nmi_handler>:
TRAPHANDLER_NOEC(nmi_handler,T_NMI)
f0104694:	6a 00                	push   $0x0
f0104696:	6a 02                	push   $0x2
f0104698:	e9 db 00 00 00       	jmp    f0104778 <_alltraps>
f010469d:	90                   	nop

f010469e <brkpt_handler>:
TRAPHANDLER_NOEC(brkpt_handler,T_BRKPT)
f010469e:	6a 00                	push   $0x0
f01046a0:	6a 03                	push   $0x3
f01046a2:	e9 d1 00 00 00       	jmp    f0104778 <_alltraps>
f01046a7:	90                   	nop

f01046a8 <oflow_handler>:
TRAPHANDLER_NOEC(oflow_handler,T_OFLOW)
f01046a8:	6a 00                	push   $0x0
f01046aa:	6a 04                	push   $0x4
f01046ac:	e9 c7 00 00 00       	jmp    f0104778 <_alltraps>
f01046b1:	90                   	nop

f01046b2 <bound_handler>:
TRAPHANDLER_NOEC(bound_handler,T_BOUND)
f01046b2:	6a 00                	push   $0x0
f01046b4:	6a 05                	push   $0x5
f01046b6:	e9 bd 00 00 00       	jmp    f0104778 <_alltraps>
f01046bb:	90                   	nop

f01046bc <illop_handler>:
TRAPHANDLER_NOEC(illop_handler,T_ILLOP)
f01046bc:	6a 00                	push   $0x0
f01046be:	6a 06                	push   $0x6
f01046c0:	e9 b3 00 00 00       	jmp    f0104778 <_alltraps>
f01046c5:	90                   	nop

f01046c6 <device_handler>:
TRAPHANDLER_NOEC(device_handler,T_DEVICE)
f01046c6:	6a 00                	push   $0x0
f01046c8:	6a 07                	push   $0x7
f01046ca:	e9 a9 00 00 00       	jmp    f0104778 <_alltraps>
f01046cf:	90                   	nop

f01046d0 <dblflt_handler>:
TRAPHANDLER(dblflt_handler,T_DBLFLT)
f01046d0:	6a 08                	push   $0x8
f01046d2:	e9 a1 00 00 00       	jmp    f0104778 <_alltraps>
f01046d7:	90                   	nop

f01046d8 <tss_handler>:
TRAPHANDLER(tss_handler,T_TSS)
f01046d8:	6a 0a                	push   $0xa
f01046da:	e9 99 00 00 00       	jmp    f0104778 <_alltraps>
f01046df:	90                   	nop

f01046e0 <segnp_handler>:
TRAPHANDLER(segnp_handler,T_SEGNP)
f01046e0:	6a 0b                	push   $0xb
f01046e2:	e9 91 00 00 00       	jmp    f0104778 <_alltraps>
f01046e7:	90                   	nop

f01046e8 <stack_handler>:
TRAPHANDLER(stack_handler,T_STACK)
f01046e8:	6a 0c                	push   $0xc
f01046ea:	e9 89 00 00 00       	jmp    f0104778 <_alltraps>
f01046ef:	90                   	nop

f01046f0 <gpflt_handler>:
TRAPHANDLER(gpflt_handler,T_GPFLT)
f01046f0:	6a 0d                	push   $0xd
f01046f2:	e9 81 00 00 00       	jmp    f0104778 <_alltraps>
f01046f7:	90                   	nop

f01046f8 <pgflt_handler>:
TRAPHANDLER(pgflt_handler,T_PGFLT)
f01046f8:	6a 0e                	push   $0xe
f01046fa:	eb 7c                	jmp    f0104778 <_alltraps>

f01046fc <fperr_handler>:
TRAPHANDLER_NOEC(fperr_handler,T_FPERR)
f01046fc:	6a 00                	push   $0x0
f01046fe:	6a 10                	push   $0x10
f0104700:	eb 76                	jmp    f0104778 <_alltraps>

f0104702 <align_handler>:
TRAPHANDLER(align_handler,T_ALIGN)
f0104702:	6a 11                	push   $0x11
f0104704:	eb 72                	jmp    f0104778 <_alltraps>

f0104706 <mchk_handler>:
TRAPHANDLER_NOEC(mchk_handler,T_MCHK)
f0104706:	6a 00                	push   $0x0
f0104708:	6a 12                	push   $0x12
f010470a:	eb 6c                	jmp    f0104778 <_alltraps>

f010470c <simderr_handler>:
TRAPHANDLER_NOEC(simderr_handler,T_SIMDERR)
f010470c:	6a 00                	push   $0x0
f010470e:	6a 13                	push   $0x13
f0104710:	eb 66                	jmp    f0104778 <_alltraps>

f0104712 <syscall_handler>:
TRAPHANDLER_NOEC(syscall_handler,T_SYSCALL)
f0104712:	6a 00                	push   $0x0
f0104714:	6a 30                	push   $0x30
f0104716:	eb 60                	jmp    f0104778 <_alltraps>

f0104718 <irq_0_handler>:

/*
 * Lab 4: Add IRQ 0 - 15
 */

TRAPHANDLER_NOEC(irq_0_handler, IRQ_OFFSET + 0);
f0104718:	6a 00                	push   $0x0
f010471a:	6a 20                	push   $0x20
f010471c:	eb 5a                	jmp    f0104778 <_alltraps>

f010471e <irq_1_handler>:
TRAPHANDLER_NOEC(irq_1_handler, IRQ_OFFSET + 1);
f010471e:	6a 00                	push   $0x0
f0104720:	6a 21                	push   $0x21
f0104722:	eb 54                	jmp    f0104778 <_alltraps>

f0104724 <irq_2_handler>:
TRAPHANDLER_NOEC(irq_2_handler, IRQ_OFFSET + 2);
f0104724:	6a 00                	push   $0x0
f0104726:	6a 22                	push   $0x22
f0104728:	eb 4e                	jmp    f0104778 <_alltraps>

f010472a <irq_3_handler>:
TRAPHANDLER_NOEC(irq_3_handler, IRQ_OFFSET + 3);
f010472a:	6a 00                	push   $0x0
f010472c:	6a 23                	push   $0x23
f010472e:	eb 48                	jmp    f0104778 <_alltraps>

f0104730 <irq_4_handler>:
TRAPHANDLER_NOEC(irq_4_handler, IRQ_OFFSET + 4);
f0104730:	6a 00                	push   $0x0
f0104732:	6a 24                	push   $0x24
f0104734:	eb 42                	jmp    f0104778 <_alltraps>

f0104736 <irq_5_handler>:
TRAPHANDLER_NOEC(irq_5_handler, IRQ_OFFSET + 5);
f0104736:	6a 00                	push   $0x0
f0104738:	6a 25                	push   $0x25
f010473a:	eb 3c                	jmp    f0104778 <_alltraps>

f010473c <irq_6_handler>:
TRAPHANDLER_NOEC(irq_6_handler, IRQ_OFFSET + 6);
f010473c:	6a 00                	push   $0x0
f010473e:	6a 26                	push   $0x26
f0104740:	eb 36                	jmp    f0104778 <_alltraps>

f0104742 <irq_7_handler>:
TRAPHANDLER_NOEC(irq_7_handler, IRQ_OFFSET + 7);
f0104742:	6a 00                	push   $0x0
f0104744:	6a 27                	push   $0x27
f0104746:	eb 30                	jmp    f0104778 <_alltraps>

f0104748 <irq_8_handler>:
TRAPHANDLER_NOEC(irq_8_handler, IRQ_OFFSET + 8);
f0104748:	6a 00                	push   $0x0
f010474a:	6a 28                	push   $0x28
f010474c:	eb 2a                	jmp    f0104778 <_alltraps>

f010474e <irq_9_handler>:
TRAPHANDLER_NOEC(irq_9_handler, IRQ_OFFSET + 9);
f010474e:	6a 00                	push   $0x0
f0104750:	6a 29                	push   $0x29
f0104752:	eb 24                	jmp    f0104778 <_alltraps>

f0104754 <irq_10_handler>:
TRAPHANDLER_NOEC(irq_10_handler, IRQ_OFFSET + 10);
f0104754:	6a 00                	push   $0x0
f0104756:	6a 2a                	push   $0x2a
f0104758:	eb 1e                	jmp    f0104778 <_alltraps>

f010475a <irq_11_handler>:
TRAPHANDLER_NOEC(irq_11_handler, IRQ_OFFSET + 11);
f010475a:	6a 00                	push   $0x0
f010475c:	6a 2b                	push   $0x2b
f010475e:	eb 18                	jmp    f0104778 <_alltraps>

f0104760 <irq_12_handler>:
TRAPHANDLER_NOEC(irq_12_handler, IRQ_OFFSET + 12);
f0104760:	6a 00                	push   $0x0
f0104762:	6a 2c                	push   $0x2c
f0104764:	eb 12                	jmp    f0104778 <_alltraps>

f0104766 <irq_13_handler>:
TRAPHANDLER_NOEC(irq_13_handler, IRQ_OFFSET + 13);
f0104766:	6a 00                	push   $0x0
f0104768:	6a 2d                	push   $0x2d
f010476a:	eb 0c                	jmp    f0104778 <_alltraps>

f010476c <irq_14_handler>:
TRAPHANDLER_NOEC(irq_14_handler, IRQ_OFFSET + 14);
f010476c:	6a 00                	push   $0x0
f010476e:	6a 2e                	push   $0x2e
f0104770:	eb 06                	jmp    f0104778 <_alltraps>

f0104772 <irq_15_handler>:
TRAPHANDLER_NOEC(irq_15_handler, IRQ_OFFSET + 15);
f0104772:	6a 00                	push   $0x0
f0104774:	6a 2f                	push   $0x2f
f0104776:	eb 00                	jmp    f0104778 <_alltraps>

f0104778 <_alltraps>:

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl	%es
f0104778:	06                   	push   %es
	pushl	%ds
f0104779:	1e                   	push   %ds
	pushal
f010477a:	60                   	pusha  
	movw	$(GD_KD), %ax
f010477b:	66 b8 10 00          	mov    $0x10,%ax
	movw 	%ax, %ds
f010477f:	8e d8                	mov    %eax,%ds
	movw 	%ax, %es
f0104781:	8e c0                	mov    %eax,%es
	pushl	%esp
f0104783:	54                   	push   %esp
f0104784:	e8 d9 fc ff ff       	call   f0104462 <trap>

f0104789 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104789:	f3 0f 1e fb          	endbr32 
f010478d:	55                   	push   %ebp
f010478e:	89 e5                	mov    %esp,%ebp
f0104790:	83 ec 08             	sub    $0x8,%esp
f0104793:	a1 48 72 23 f0       	mov    0xf0237248,%eax
f0104798:	8d 50 54             	lea    0x54(%eax),%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f010479b:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f01047a0:	8b 02                	mov    (%edx),%eax
f01047a2:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f01047a5:	83 f8 02             	cmp    $0x2,%eax
f01047a8:	76 2d                	jbe    f01047d7 <sched_halt+0x4e>
	for (i = 0; i < NENV; i++) {
f01047aa:	83 c1 01             	add    $0x1,%ecx
f01047ad:	83 c2 7c             	add    $0x7c,%edx
f01047b0:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01047b6:	75 e8                	jne    f01047a0 <sched_halt+0x17>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f01047b8:	83 ec 0c             	sub    $0xc,%esp
f01047bb:	68 10 7f 10 f0       	push   $0xf0107f10
f01047c0:	e8 6a f2 ff ff       	call   f0103a2f <cprintf>
f01047c5:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f01047c8:	83 ec 0c             	sub    $0xc,%esp
f01047cb:	6a 00                	push   $0x0
f01047cd:	e8 75 c1 ff ff       	call   f0100947 <monitor>
f01047d2:	83 c4 10             	add    $0x10,%esp
f01047d5:	eb f1                	jmp    f01047c8 <sched_halt+0x3f>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f01047d7:	e8 de 18 00 00       	call   f01060ba <cpunum>
f01047dc:	6b c0 74             	imul   $0x74,%eax,%eax
f01047df:	c7 80 28 80 23 f0 00 	movl   $0x0,-0xfdc7fd8(%eax)
f01047e6:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f01047e9:	a1 8c 7e 23 f0       	mov    0xf0237e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01047ee:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01047f3:	76 50                	jbe    f0104845 <sched_halt+0xbc>
	return (physaddr_t)kva - KERNBASE;
f01047f5:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01047fa:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f01047fd:	e8 b8 18 00 00       	call   f01060ba <cpunum>
f0104802:	6b d0 74             	imul   $0x74,%eax,%edx
f0104805:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104808:	b8 02 00 00 00       	mov    $0x2,%eax
f010480d:	f0 87 82 20 80 23 f0 	lock xchg %eax,-0xfdc7fe0(%edx)
	spin_unlock(&kernel_lock);
f0104814:	83 ec 0c             	sub    $0xc,%esp
f0104817:	68 c0 33 12 f0       	push   $0xf01233c0
f010481c:	e8 bf 1b 00 00       	call   f01063e0 <spin_unlock>
	asm volatile("pause");
f0104821:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104823:	e8 92 18 00 00       	call   f01060ba <cpunum>
f0104828:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f010482b:	8b 80 30 80 23 f0    	mov    -0xfdc7fd0(%eax),%eax
f0104831:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104836:	89 c4                	mov    %eax,%esp
f0104838:	6a 00                	push   $0x0
f010483a:	6a 00                	push   $0x0
f010483c:	fb                   	sti    
f010483d:	f4                   	hlt    
f010483e:	eb fd                	jmp    f010483d <sched_halt+0xb4>
}
f0104840:	83 c4 10             	add    $0x10,%esp
f0104843:	c9                   	leave  
f0104844:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104845:	50                   	push   %eax
f0104846:	68 88 67 10 f0       	push   $0xf0106788
f010484b:	6a 56                	push   $0x56
f010484d:	68 39 7f 10 f0       	push   $0xf0107f39
f0104852:	e8 e9 b7 ff ff       	call   f0100040 <_panic>

f0104857 <sched_yield>:
{
f0104857:	f3 0f 1e fb          	endbr32 
f010485b:	55                   	push   %ebp
f010485c:	89 e5                	mov    %esp,%ebp
f010485e:	53                   	push   %ebx
f010485f:	83 ec 04             	sub    $0x4,%esp
	if (curenv){
f0104862:	e8 53 18 00 00       	call   f01060ba <cpunum>
f0104867:	6b c0 74             	imul   $0x74,%eax,%eax
f010486a:	83 b8 28 80 23 f0 00 	cmpl   $0x0,-0xfdc7fd8(%eax)
f0104871:	74 3e                	je     f01048b1 <sched_yield+0x5a>
		size_t eidx = ENVX(curenv->env_id);
f0104873:	e8 42 18 00 00       	call   f01060ba <cpunum>
f0104878:	6b c0 74             	imul   $0x74,%eax,%eax
f010487b:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0104881:	8b 48 48             	mov    0x48(%eax),%ecx
f0104884:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for (size_t i = (eidx + 1) & mask; i != eidx; i = (i + 1) & mask){
f010488a:	8d 41 01             	lea    0x1(%ecx),%eax
f010488d:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f0104892:	8b 1d 48 72 23 f0    	mov    0xf0237248,%ebx
		for (size_t i = (eidx + 1) & mask; i != eidx; i = (i + 1) & mask){
f0104898:	39 c8                	cmp    %ecx,%eax
f010489a:	74 3a                	je     f01048d6 <sched_yield+0x7f>
			if(envs[i].env_status == ENV_RUNNABLE){
f010489c:	6b d0 7c             	imul   $0x7c,%eax,%edx
f010489f:	01 da                	add    %ebx,%edx
f01048a1:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f01048a5:	74 26                	je     f01048cd <sched_yield+0x76>
		for (size_t i = (eidx + 1) & mask; i != eidx; i = (i + 1) & mask){
f01048a7:	83 c0 01             	add    $0x1,%eax
f01048aa:	25 ff 03 00 00       	and    $0x3ff,%eax
f01048af:	eb e7                	jmp    f0104898 <sched_yield+0x41>
f01048b1:	a1 48 72 23 f0       	mov    0xf0237248,%eax
f01048b6:	8d 88 00 f0 01 00    	lea    0x1f000(%eax),%ecx
			if(envs[i].env_status == ENV_RUNNABLE){
f01048bc:	89 c2                	mov    %eax,%edx
f01048be:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01048c2:	74 09                	je     f01048cd <sched_yield+0x76>
f01048c4:	83 c0 7c             	add    $0x7c,%eax
		for(size_t i = 0; i < NENV; ++i) {
f01048c7:	39 c8                	cmp    %ecx,%eax
f01048c9:	75 f1                	jne    f01048bc <sched_yield+0x65>
f01048cb:	eb 2f                	jmp    f01048fc <sched_yield+0xa5>
		env_run(idle);
f01048cd:	83 ec 0c             	sub    $0xc,%esp
f01048d0:	52                   	push   %edx
f01048d1:	e8 15 ef ff ff       	call   f01037eb <env_run>
		if(!idle && curenv->env_status == ENV_RUNNING){
f01048d6:	e8 df 17 00 00       	call   f01060ba <cpunum>
f01048db:	6b c0 74             	imul   $0x74,%eax,%eax
f01048de:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f01048e4:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01048e8:	75 12                	jne    f01048fc <sched_yield+0xa5>
			idle = curenv;
f01048ea:	e8 cb 17 00 00       	call   f01060ba <cpunum>
f01048ef:	6b c0 74             	imul   $0x74,%eax,%eax
f01048f2:	8b 90 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%edx
	if(idle){
f01048f8:	85 d2                	test   %edx,%edx
f01048fa:	75 d1                	jne    f01048cd <sched_yield+0x76>
	sched_halt();
f01048fc:	e8 88 fe ff ff       	call   f0104789 <sched_halt>
}
f0104901:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104904:	c9                   	leave  
f0104905:	c3                   	ret    

f0104906 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104906:	f3 0f 1e fb          	endbr32 
f010490a:	55                   	push   %ebp
f010490b:	89 e5                	mov    %esp,%ebp
f010490d:	57                   	push   %edi
f010490e:	56                   	push   %esi
f010490f:	53                   	push   %ebx
f0104910:	83 ec 1c             	sub    $0x1c,%esp
f0104913:	8b 45 08             	mov    0x8(%ebp),%eax
f0104916:	83 f8 0c             	cmp    $0xc,%eax
f0104919:	0f 87 37 05 00 00    	ja     f0104e56 <syscall+0x550>
f010491f:	3e ff 24 85 80 7f 10 	notrack jmp *-0xfef8080(,%eax,4)
f0104926:	f0 
	user_mem_assert(curenv, s, len, 0);
f0104927:	e8 8e 17 00 00       	call   f01060ba <cpunum>
f010492c:	6a 00                	push   $0x0
f010492e:	ff 75 10             	pushl  0x10(%ebp)
f0104931:	ff 75 0c             	pushl  0xc(%ebp)
f0104934:	6b c0 74             	imul   $0x74,%eax,%eax
f0104937:	ff b0 28 80 23 f0    	pushl  -0xfdc7fd8(%eax)
f010493d:	e8 47 e7 ff ff       	call   f0103089 <user_mem_assert>
	cprintf("%.*s", len, s);
f0104942:	83 c4 0c             	add    $0xc,%esp
f0104945:	ff 75 0c             	pushl  0xc(%ebp)
f0104948:	ff 75 10             	pushl  0x10(%ebp)
f010494b:	68 46 7f 10 f0       	push   $0xf0107f46
f0104950:	e8 da f0 ff ff       	call   f0103a2f <cprintf>
}
f0104955:	83 c4 10             	add    $0x10,%esp
	// LAB 3: Your code here.

	switch (syscallno) {
		case SYS_cputs:
			sys_cputs((char *) a1, a2);
			return 0;
f0104958:	b8 00 00 00 00       	mov    $0x0,%eax
		default:
			return -E_INVAL;
	}

	return -E_INVAL;
}
f010495d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104960:	5b                   	pop    %ebx
f0104961:	5e                   	pop    %esi
f0104962:	5f                   	pop    %edi
f0104963:	5d                   	pop    %ebp
f0104964:	c3                   	ret    
	return cons_getc();
f0104965:	e8 95 bc ff ff       	call   f01005ff <cons_getc>
			return sys_cgetc();
f010496a:	eb f1                	jmp    f010495d <syscall+0x57>
	return curenv->env_id;
f010496c:	e8 49 17 00 00       	call   f01060ba <cpunum>
f0104971:	6b c0 74             	imul   $0x74,%eax,%eax
f0104974:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f010497a:	8b 40 48             	mov    0x48(%eax),%eax
			return sys_getenvid();
f010497d:	eb de                	jmp    f010495d <syscall+0x57>
	if ((r = envid2env(envid, &e, 1)) < 0)
f010497f:	83 ec 04             	sub    $0x4,%esp
f0104982:	6a 01                	push   $0x1
f0104984:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104987:	50                   	push   %eax
f0104988:	ff 75 0c             	pushl  0xc(%ebp)
f010498b:	e8 b4 e7 ff ff       	call   f0103144 <envid2env>
f0104990:	83 c4 10             	add    $0x10,%esp
f0104993:	85 c0                	test   %eax,%eax
f0104995:	78 c6                	js     f010495d <syscall+0x57>
	if (e == curenv)
f0104997:	e8 1e 17 00 00       	call   f01060ba <cpunum>
f010499c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010499f:	6b c0 74             	imul   $0x74,%eax,%eax
f01049a2:	39 90 28 80 23 f0    	cmp    %edx,-0xfdc7fd8(%eax)
f01049a8:	74 3d                	je     f01049e7 <syscall+0xe1>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01049aa:	8b 5a 48             	mov    0x48(%edx),%ebx
f01049ad:	e8 08 17 00 00       	call   f01060ba <cpunum>
f01049b2:	83 ec 04             	sub    $0x4,%esp
f01049b5:	53                   	push   %ebx
f01049b6:	6b c0 74             	imul   $0x74,%eax,%eax
f01049b9:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f01049bf:	ff 70 48             	pushl  0x48(%eax)
f01049c2:	68 66 7f 10 f0       	push   $0xf0107f66
f01049c7:	e8 63 f0 ff ff       	call   f0103a2f <cprintf>
f01049cc:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f01049cf:	83 ec 0c             	sub    $0xc,%esp
f01049d2:	ff 75 e4             	pushl  -0x1c(%ebp)
f01049d5:	e8 6a ed ff ff       	call   f0103744 <env_destroy>
	return 0;
f01049da:	83 c4 10             	add    $0x10,%esp
f01049dd:	b8 00 00 00 00       	mov    $0x0,%eax
			return sys_env_destroy(a1);
f01049e2:	e9 76 ff ff ff       	jmp    f010495d <syscall+0x57>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f01049e7:	e8 ce 16 00 00       	call   f01060ba <cpunum>
f01049ec:	83 ec 08             	sub    $0x8,%esp
f01049ef:	6b c0 74             	imul   $0x74,%eax,%eax
f01049f2:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f01049f8:	ff 70 48             	pushl  0x48(%eax)
f01049fb:	68 4b 7f 10 f0       	push   $0xf0107f4b
f0104a00:	e8 2a f0 ff ff       	call   f0103a2f <cprintf>
f0104a05:	83 c4 10             	add    $0x10,%esp
f0104a08:	eb c5                	jmp    f01049cf <syscall+0xc9>
	sched_yield();
f0104a0a:	e8 48 fe ff ff       	call   f0104857 <sched_yield>
	int status = env_alloc(&child, curenv->env_id);
f0104a0f:	e8 a6 16 00 00       	call   f01060ba <cpunum>
f0104a14:	83 ec 08             	sub    $0x8,%esp
f0104a17:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a1a:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0104a20:	ff 70 48             	pushl  0x48(%eax)
f0104a23:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104a26:	50                   	push   %eax
f0104a27:	e8 26 e8 ff ff       	call   f0103252 <env_alloc>
	if (status < 0) return status;
f0104a2c:	83 c4 10             	add    $0x10,%esp
f0104a2f:	85 c0                	test   %eax,%eax
f0104a31:	0f 88 26 ff ff ff    	js     f010495d <syscall+0x57>
	child->env_tf = curenv->env_tf;
f0104a37:	e8 7e 16 00 00       	call   f01060ba <cpunum>
f0104a3c:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a3f:	8b b0 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%esi
f0104a45:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104a4a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104a4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child->env_status = ENV_NOT_RUNNABLE;
f0104a4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a52:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	child->env_tf.tf_regs.reg_eax = 0;		//新的用户环境从sys_exofork()的返回值应该为0
f0104a59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return child->env_id;
f0104a60:	8b 40 48             	mov    0x48(%eax),%eax
			return sys_exofork();
f0104a63:	e9 f5 fe ff ff       	jmp    f010495d <syscall+0x57>
	int state = envid2env(envid, &env, 1);
f0104a68:	83 ec 04             	sub    $0x4,%esp
f0104a6b:	6a 01                	push   $0x1
f0104a6d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104a70:	50                   	push   %eax
f0104a71:	ff 75 0c             	pushl  0xc(%ebp)
f0104a74:	e8 cb e6 ff ff       	call   f0103144 <envid2env>
	if (state < 0) return state;
f0104a79:	83 c4 10             	add    $0x10,%esp
f0104a7c:	85 c0                	test   %eax,%eax
f0104a7e:	0f 88 d9 fe ff ff    	js     f010495d <syscall+0x57>
	if (status != ENV_NOT_RUNNABLE && status != ENV_RUNNABLE) {
f0104a84:	8b 45 10             	mov    0x10(%ebp),%eax
f0104a87:	83 e8 02             	sub    $0x2,%eax
f0104a8a:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f0104a8f:	75 13                	jne    f0104aa4 <syscall+0x19e>
	env->env_status = status;
f0104a91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a94:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104a97:	89 78 54             	mov    %edi,0x54(%eax)
	return 0;
f0104a9a:	b8 00 00 00 00       	mov    $0x0,%eax
f0104a9f:	e9 b9 fe ff ff       	jmp    f010495d <syscall+0x57>
		return -E_INVAL;
f0104aa4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			return sys_env_set_status(a1, a2);
f0104aa9:	e9 af fe ff ff       	jmp    f010495d <syscall+0x57>
	int state = envid2env(envid, &env, 1);
f0104aae:	83 ec 04             	sub    $0x4,%esp
f0104ab1:	6a 01                	push   $0x1
f0104ab3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104ab6:	50                   	push   %eax
f0104ab7:	ff 75 0c             	pushl  0xc(%ebp)
f0104aba:	e8 85 e6 ff ff       	call   f0103144 <envid2env>
	if (state < 0) return state;
f0104abf:	83 c4 10             	add    $0x10,%esp
f0104ac2:	85 c0                	test   %eax,%eax
f0104ac4:	0f 88 93 fe ff ff    	js     f010495d <syscall+0x57>
	if ((size_t) va >= UTOP || ((size_t) va % PGSIZE) != 0) return -E_INVAL;
f0104aca:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104ad1:	77 60                	ja     f0104b33 <syscall+0x22d>
f0104ad3:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104ada:	75 61                	jne    f0104b3d <syscall+0x237>
	if ((perm & PTE_U) != PTE_U || (perm & PTE_P) != PTE_P) return -E_INVAL;
f0104adc:	8b 45 14             	mov    0x14(%ebp),%eax
f0104adf:	83 e0 05             	and    $0x5,%eax
f0104ae2:	83 f8 05             	cmp    $0x5,%eax
f0104ae5:	75 60                	jne    f0104b47 <syscall+0x241>
	struct PageInfo *pp = page_alloc(1);
f0104ae7:	83 ec 0c             	sub    $0xc,%esp
f0104aea:	6a 01                	push   $0x1
f0104aec:	e8 c8 c4 ff ff       	call   f0100fb9 <page_alloc>
f0104af1:	89 c3                	mov    %eax,%ebx
	if (pp == NULL) return -E_NO_MEM;
f0104af3:	83 c4 10             	add    $0x10,%esp
f0104af6:	85 c0                	test   %eax,%eax
f0104af8:	74 57                	je     f0104b51 <syscall+0x24b>
	if (page_insert(env->env_pgdir, pp, va, perm) < 0) {
f0104afa:	ff 75 14             	pushl  0x14(%ebp)
f0104afd:	ff 75 10             	pushl  0x10(%ebp)
f0104b00:	50                   	push   %eax
f0104b01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104b04:	ff 70 60             	pushl  0x60(%eax)
f0104b07:	e8 e9 c7 ff ff       	call   f01012f5 <page_insert>
f0104b0c:	83 c4 10             	add    $0x10,%esp
f0104b0f:	85 c0                	test   %eax,%eax
f0104b11:	78 0a                	js     f0104b1d <syscall+0x217>
	return 0;
f0104b13:	b8 00 00 00 00       	mov    $0x0,%eax
			return sys_page_alloc(a1, (void *) a2, a3);
f0104b18:	e9 40 fe ff ff       	jmp    f010495d <syscall+0x57>
		page_free(pp);
f0104b1d:	83 ec 0c             	sub    $0xc,%esp
f0104b20:	53                   	push   %ebx
f0104b21:	e8 1e c5 ff ff       	call   f0101044 <page_free>
		return -E_NO_MEM;
f0104b26:	83 c4 10             	add    $0x10,%esp
f0104b29:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0104b2e:	e9 2a fe ff ff       	jmp    f010495d <syscall+0x57>
	if ((size_t) va >= UTOP || ((size_t) va % PGSIZE) != 0) return -E_INVAL;
f0104b33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104b38:	e9 20 fe ff ff       	jmp    f010495d <syscall+0x57>
f0104b3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104b42:	e9 16 fe ff ff       	jmp    f010495d <syscall+0x57>
	if ((perm & PTE_U) != PTE_U || (perm & PTE_P) != PTE_P) return -E_INVAL;
f0104b47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104b4c:	e9 0c fe ff ff       	jmp    f010495d <syscall+0x57>
	if (pp == NULL) return -E_NO_MEM;
f0104b51:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0104b56:	e9 02 fe ff ff       	jmp    f010495d <syscall+0x57>
	if ((size_t) srcva >= UTOP || ((size_t) srcva % PGSIZE) != 0 || (size_t) dstva >= UTOP || ((size_t) dstva % PGSIZE) != 0) {
f0104b5b:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104b62:	0f 87 95 00 00 00    	ja     f0104bfd <syscall+0x2f7>
f0104b68:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0104b6f:	0f 87 92 00 00 00    	ja     f0104c07 <syscall+0x301>
f0104b75:	8b 45 10             	mov    0x10(%ebp),%eax
f0104b78:	0b 45 18             	or     0x18(%ebp),%eax
f0104b7b:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0104b80:	0f 85 8b 00 00 00    	jne    f0104c11 <syscall+0x30b>
	state1 = envid2env(srcenvid, &senv, 1);
f0104b86:	83 ec 04             	sub    $0x4,%esp
f0104b89:	6a 01                	push   $0x1
f0104b8b:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104b8e:	50                   	push   %eax
f0104b8f:	ff 75 0c             	pushl  0xc(%ebp)
f0104b92:	e8 ad e5 ff ff       	call   f0103144 <envid2env>
f0104b97:	89 c3                	mov    %eax,%ebx
	state2 = envid2env(dstenvid, &denv, 1);
f0104b99:	83 c4 0c             	add    $0xc,%esp
f0104b9c:	6a 01                	push   $0x1
f0104b9e:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104ba1:	50                   	push   %eax
f0104ba2:	ff 75 14             	pushl  0x14(%ebp)
f0104ba5:	e8 9a e5 ff ff       	call   f0103144 <envid2env>
	if (state1 < 0) return state1;
f0104baa:	83 c4 10             	add    $0x10,%esp
f0104bad:	85 db                	test   %ebx,%ebx
f0104baf:	78 6a                	js     f0104c1b <syscall+0x315>
	if (state2 < 0) return state2;
f0104bb1:	85 c0                	test   %eax,%eax
f0104bb3:	0f 88 a4 fd ff ff    	js     f010495d <syscall+0x57>
	struct PageInfo *pp = page_lookup(senv->env_pgdir, srcva, &pte);
f0104bb9:	83 ec 04             	sub    $0x4,%esp
f0104bbc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104bbf:	50                   	push   %eax
f0104bc0:	ff 75 10             	pushl  0x10(%ebp)
f0104bc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104bc6:	ff 70 60             	pushl  0x60(%eax)
f0104bc9:	e8 31 c6 ff ff       	call   f01011ff <page_lookup>
	if (pp == NULL) return -E_INVAL;
f0104bce:	83 c4 10             	add    $0x10,%esp
f0104bd1:	85 c0                	test   %eax,%eax
f0104bd3:	74 4d                	je     f0104c22 <syscall+0x31c>
	if (((*pte & PTE_W) == 0) && (perm & PTE_W)) return -E_INVAL;
f0104bd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104bd8:	f6 02 02             	testb  $0x2,(%edx)
f0104bdb:	75 06                	jne    f0104be3 <syscall+0x2dd>
f0104bdd:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0104be1:	75 49                	jne    f0104c2c <syscall+0x326>
	return page_insert(denv->env_pgdir, pp, dstva, perm);
f0104be3:	ff 75 1c             	pushl  0x1c(%ebp)
f0104be6:	ff 75 18             	pushl  0x18(%ebp)
f0104be9:	50                   	push   %eax
f0104bea:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104bed:	ff 70 60             	pushl  0x60(%eax)
f0104bf0:	e8 00 c7 ff ff       	call   f01012f5 <page_insert>
f0104bf5:	83 c4 10             	add    $0x10,%esp
f0104bf8:	e9 60 fd ff ff       	jmp    f010495d <syscall+0x57>
		return -E_INVAL;
f0104bfd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104c02:	e9 56 fd ff ff       	jmp    f010495d <syscall+0x57>
f0104c07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104c0c:	e9 4c fd ff ff       	jmp    f010495d <syscall+0x57>
f0104c11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104c16:	e9 42 fd ff ff       	jmp    f010495d <syscall+0x57>
	if (state1 < 0) return state1;
f0104c1b:	89 d8                	mov    %ebx,%eax
f0104c1d:	e9 3b fd ff ff       	jmp    f010495d <syscall+0x57>
	if (pp == NULL) return -E_INVAL;
f0104c22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104c27:	e9 31 fd ff ff       	jmp    f010495d <syscall+0x57>
	if (((*pte & PTE_W) == 0) && (perm & PTE_W)) return -E_INVAL;
f0104c2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			return sys_page_map(a1, (void *) a2, a3, (void *) a4, a5);
f0104c31:	e9 27 fd ff ff       	jmp    f010495d <syscall+0x57>
	if (envid2env(envid, &env, 1) < 0) return -E_BAD_ENV;
f0104c36:	83 ec 04             	sub    $0x4,%esp
f0104c39:	6a 01                	push   $0x1
f0104c3b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104c3e:	50                   	push   %eax
f0104c3f:	ff 75 0c             	pushl  0xc(%ebp)
f0104c42:	e8 fd e4 ff ff       	call   f0103144 <envid2env>
f0104c47:	83 c4 10             	add    $0x10,%esp
f0104c4a:	85 c0                	test   %eax,%eax
f0104c4c:	78 30                	js     f0104c7e <syscall+0x378>
	if ((size_t) va >= UTOP || ((size_t) va % PGSIZE) != 0) {
f0104c4e:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104c55:	77 31                	ja     f0104c88 <syscall+0x382>
f0104c57:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104c5e:	75 32                	jne    f0104c92 <syscall+0x38c>
	page_remove(env->env_pgdir, va);
f0104c60:	83 ec 08             	sub    $0x8,%esp
f0104c63:	ff 75 10             	pushl  0x10(%ebp)
f0104c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104c69:	ff 70 60             	pushl  0x60(%eax)
f0104c6c:	e8 3a c6 ff ff       	call   f01012ab <page_remove>
	return 0;
f0104c71:	83 c4 10             	add    $0x10,%esp
f0104c74:	b8 00 00 00 00       	mov    $0x0,%eax
f0104c79:	e9 df fc ff ff       	jmp    f010495d <syscall+0x57>
	if (envid2env(envid, &env, 1) < 0) return -E_BAD_ENV;
f0104c7e:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0104c83:	e9 d5 fc ff ff       	jmp    f010495d <syscall+0x57>
		return -E_INVAL;
f0104c88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104c8d:	e9 cb fc ff ff       	jmp    f010495d <syscall+0x57>
f0104c92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			return sys_page_unmap(a1, (void *) a2);
f0104c97:	e9 c1 fc ff ff       	jmp    f010495d <syscall+0x57>
	int state = envid2env(envid, &env, 1);
f0104c9c:	83 ec 04             	sub    $0x4,%esp
f0104c9f:	6a 01                	push   $0x1
f0104ca1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104ca4:	50                   	push   %eax
f0104ca5:	ff 75 0c             	pushl  0xc(%ebp)
f0104ca8:	e8 97 e4 ff ff       	call   f0103144 <envid2env>
	if (state < 0) return state;
f0104cad:	83 c4 10             	add    $0x10,%esp
f0104cb0:	85 c0                	test   %eax,%eax
f0104cb2:	0f 88 a5 fc ff ff    	js     f010495d <syscall+0x57>
	env->env_pgfault_upcall = func;
f0104cb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104cbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104cbe:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f0104cc1:	b8 00 00 00 00       	mov    $0x0,%eax
			return sys_env_set_pgfault_upcall(a1, (void *) a2);
f0104cc6:	e9 92 fc ff ff       	jmp    f010495d <syscall+0x57>
	if (envid2env(envid, &env, 0) < 0) return -E_BAD_ENV;
f0104ccb:	83 ec 04             	sub    $0x4,%esp
f0104cce:	6a 00                	push   $0x0
f0104cd0:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104cd3:	50                   	push   %eax
f0104cd4:	ff 75 0c             	pushl  0xc(%ebp)
f0104cd7:	e8 68 e4 ff ff       	call   f0103144 <envid2env>
f0104cdc:	83 c4 10             	add    $0x10,%esp
f0104cdf:	85 c0                	test   %eax,%eax
f0104ce1:	0f 88 ff 00 00 00    	js     f0104de6 <syscall+0x4e0>
	if (!env->env_ipc_recving) return -E_IPC_NOT_RECV;
f0104ce7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104cea:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0104cee:	0f 84 fc 00 00 00    	je     f0104df0 <syscall+0x4ea>
	if ((size_t) srcva < UTOP) {
f0104cf4:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0104cfb:	0f 87 a3 00 00 00    	ja     f0104da4 <syscall+0x49e>
			return -E_INVAL;
f0104d01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (((size_t) srcva % PGSIZE) != 0) {
f0104d06:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f0104d0d:	0f 85 4a fc ff ff    	jne    f010495d <syscall+0x57>
		if ((perm & PTE_U) != PTE_U || (perm & PTE_P) != PTE_P) return -E_INVAL;
f0104d13:	8b 55 18             	mov    0x18(%ebp),%edx
f0104d16:	83 e2 05             	and    $0x5,%edx
f0104d19:	83 fa 05             	cmp    $0x5,%edx
f0104d1c:	0f 85 3b fc ff ff    	jne    f010495d <syscall+0x57>
		struct PageInfo *pp = page_lookup(curenv->env_pgdir, srcva, &pte);
f0104d22:	e8 93 13 00 00       	call   f01060ba <cpunum>
f0104d27:	83 ec 04             	sub    $0x4,%esp
f0104d2a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104d2d:	52                   	push   %edx
f0104d2e:	ff 75 14             	pushl  0x14(%ebp)
f0104d31:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d34:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0104d3a:	ff 70 60             	pushl  0x60(%eax)
f0104d3d:	e8 bd c4 ff ff       	call   f01011ff <page_lookup>
f0104d42:	89 c2                	mov    %eax,%edx
		if (!pp) return -E_INVAL;
f0104d44:	83 c4 10             	add    $0x10,%esp
f0104d47:	85 c0                	test   %eax,%eax
f0104d49:	74 4f                	je     f0104d9a <syscall+0x494>
		if ((perm & PTE_W) && ((size_t) *pte & PTE_W) != PTE_W) return -E_INVAL;
f0104d4b:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104d4f:	74 11                	je     f0104d62 <syscall+0x45c>
f0104d51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104d56:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0104d59:	f6 01 02             	testb  $0x2,(%ecx)
f0104d5c:	0f 84 fb fb ff ff    	je     f010495d <syscall+0x57>
		if ((size_t) env->env_ipc_dstva < UTOP) {
f0104d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104d65:	8b 48 6c             	mov    0x6c(%eax),%ecx
f0104d68:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0104d6e:	77 3b                	ja     f0104dab <syscall+0x4a5>
			if (page_insert(env->env_pgdir, pp, env->env_ipc_dstva, perm) < 0) return -E_NO_MEM;
f0104d70:	ff 75 18             	pushl  0x18(%ebp)
f0104d73:	51                   	push   %ecx
f0104d74:	52                   	push   %edx
f0104d75:	ff 70 60             	pushl  0x60(%eax)
f0104d78:	e8 78 c5 ff ff       	call   f01012f5 <page_insert>
f0104d7d:	89 c2                	mov    %eax,%edx
f0104d7f:	83 c4 10             	add    $0x10,%esp
f0104d82:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0104d87:	85 d2                	test   %edx,%edx
f0104d89:	0f 88 ce fb ff ff    	js     f010495d <syscall+0x57>
			env->env_ipc_perm = perm;
f0104d8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104d92:	8b 7d 18             	mov    0x18(%ebp),%edi
f0104d95:	89 78 78             	mov    %edi,0x78(%eax)
f0104d98:	eb 11                	jmp    f0104dab <syscall+0x4a5>
		if (!pp) return -E_INVAL;
f0104d9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104d9f:	e9 b9 fb ff ff       	jmp    f010495d <syscall+0x57>
		env->env_ipc_perm = 0;
f0104da4:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
	env->env_ipc_from = curenv->env_id;
f0104dab:	e8 0a 13 00 00       	call   f01060ba <cpunum>
f0104db0:	89 c2                	mov    %eax,%edx
f0104db2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104db5:	6b d2 74             	imul   $0x74,%edx,%edx
f0104db8:	8b 92 28 80 23 f0    	mov    -0xfdc7fd8(%edx),%edx
f0104dbe:	8b 52 48             	mov    0x48(%edx),%edx
f0104dc1:	89 50 74             	mov    %edx,0x74(%eax)
	env->env_ipc_recving = 0;
f0104dc4:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	env->env_ipc_value = value;
f0104dc8:	8b 75 10             	mov    0x10(%ebp),%esi
f0104dcb:	89 70 70             	mov    %esi,0x70(%eax)
	env->env_status = ENV_RUNNABLE;
f0104dce:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	env->env_tf.tf_regs.reg_eax = 0;
f0104dd5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return 0;
f0104ddc:	b8 00 00 00 00       	mov    $0x0,%eax
f0104de1:	e9 77 fb ff ff       	jmp    f010495d <syscall+0x57>
	if (envid2env(envid, &env, 0) < 0) return -E_BAD_ENV;
f0104de6:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0104deb:	e9 6d fb ff ff       	jmp    f010495d <syscall+0x57>
	if (!env->env_ipc_recving) return -E_IPC_NOT_RECV;
f0104df0:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
			return sys_ipc_try_send(a1, a2, (void *) a3, a4);
f0104df5:	e9 63 fb ff ff       	jmp    f010495d <syscall+0x57>
	if ((size_t) dstva < UTOP && ((size_t) dstva % PGSIZE) != 0) return -E_INVAL;
f0104dfa:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0104e01:	77 13                	ja     f0104e16 <syscall+0x510>
f0104e03:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0104e0a:	74 0a                	je     f0104e16 <syscall+0x510>
			return sys_ipc_recv((void *) a1);
f0104e0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104e11:	e9 47 fb ff ff       	jmp    f010495d <syscall+0x57>
	curenv->env_ipc_recving = 1;
f0104e16:	e8 9f 12 00 00       	call   f01060ba <cpunum>
f0104e1b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e1e:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0104e24:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f0104e28:	e8 8d 12 00 00       	call   f01060ba <cpunum>
f0104e2d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e30:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0104e36:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0104e39:	89 78 6c             	mov    %edi,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0104e3c:	e8 79 12 00 00       	call   f01060ba <cpunum>
f0104e41:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e44:	8b 80 28 80 23 f0    	mov    -0xfdc7fd8(%eax),%eax
f0104e4a:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0104e51:	e8 01 fa ff ff       	call   f0104857 <sched_yield>
			return 0;
f0104e56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104e5b:	e9 fd fa ff ff       	jmp    f010495d <syscall+0x57>

f0104e60 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0104e60:	55                   	push   %ebp
f0104e61:	89 e5                	mov    %esp,%ebp
f0104e63:	57                   	push   %edi
f0104e64:	56                   	push   %esi
f0104e65:	53                   	push   %ebx
f0104e66:	83 ec 14             	sub    $0x14,%esp
f0104e69:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104e6c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104e6f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104e72:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104e75:	8b 1a                	mov    (%edx),%ebx
f0104e77:	8b 01                	mov    (%ecx),%eax
f0104e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104e7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104e83:	eb 23                	jmp    f0104ea8 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0104e85:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0104e88:	eb 1e                	jmp    f0104ea8 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104e8a:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104e8d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104e90:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104e94:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104e97:	73 46                	jae    f0104edf <stab_binsearch+0x7f>
			*region_left = m;
f0104e99:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104e9c:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0104e9e:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0104ea1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104ea8:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0104eab:	7f 5f                	jg     f0104f0c <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f0104ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104eb0:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0104eb3:	89 d0                	mov    %edx,%eax
f0104eb5:	c1 e8 1f             	shr    $0x1f,%eax
f0104eb8:	01 d0                	add    %edx,%eax
f0104eba:	89 c7                	mov    %eax,%edi
f0104ebc:	d1 ff                	sar    %edi
f0104ebe:	83 e0 fe             	and    $0xfffffffe,%eax
f0104ec1:	01 f8                	add    %edi,%eax
f0104ec3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104ec6:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104eca:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0104ecc:	39 c3                	cmp    %eax,%ebx
f0104ece:	7f b5                	jg     f0104e85 <stab_binsearch+0x25>
f0104ed0:	0f b6 0a             	movzbl (%edx),%ecx
f0104ed3:	83 ea 0c             	sub    $0xc,%edx
f0104ed6:	39 f1                	cmp    %esi,%ecx
f0104ed8:	74 b0                	je     f0104e8a <stab_binsearch+0x2a>
			m--;
f0104eda:	83 e8 01             	sub    $0x1,%eax
f0104edd:	eb ed                	jmp    f0104ecc <stab_binsearch+0x6c>
		} else if (stabs[m].n_value > addr) {
f0104edf:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104ee2:	76 14                	jbe    f0104ef8 <stab_binsearch+0x98>
			*region_right = m - 1;
f0104ee4:	83 e8 01             	sub    $0x1,%eax
f0104ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104eea:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104eed:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0104eef:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104ef6:	eb b0                	jmp    f0104ea8 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104ef8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104efb:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0104efd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104f01:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0104f03:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104f0a:	eb 9c                	jmp    f0104ea8 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0104f0c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104f10:	75 15                	jne    f0104f27 <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0104f12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104f15:	8b 00                	mov    (%eax),%eax
f0104f17:	83 e8 01             	sub    $0x1,%eax
f0104f1a:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104f1d:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0104f1f:	83 c4 14             	add    $0x14,%esp
f0104f22:	5b                   	pop    %ebx
f0104f23:	5e                   	pop    %esi
f0104f24:	5f                   	pop    %edi
f0104f25:	5d                   	pop    %ebp
f0104f26:	c3                   	ret    
		for (l = *region_right;
f0104f27:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104f2a:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104f2c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104f2f:	8b 0f                	mov    (%edi),%ecx
f0104f31:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104f34:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0104f37:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0104f3b:	eb 03                	jmp    f0104f40 <stab_binsearch+0xe0>
		     l--)
f0104f3d:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104f40:	39 c1                	cmp    %eax,%ecx
f0104f42:	7d 0a                	jge    f0104f4e <stab_binsearch+0xee>
		     l > *region_left && stabs[l].n_type != type;
f0104f44:	0f b6 1a             	movzbl (%edx),%ebx
f0104f47:	83 ea 0c             	sub    $0xc,%edx
f0104f4a:	39 f3                	cmp    %esi,%ebx
f0104f4c:	75 ef                	jne    f0104f3d <stab_binsearch+0xdd>
		*region_left = l;
f0104f4e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104f51:	89 07                	mov    %eax,(%edi)
}
f0104f53:	eb ca                	jmp    f0104f1f <stab_binsearch+0xbf>

f0104f55 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104f55:	f3 0f 1e fb          	endbr32 
f0104f59:	55                   	push   %ebp
f0104f5a:	89 e5                	mov    %esp,%ebp
f0104f5c:	57                   	push   %edi
f0104f5d:	56                   	push   %esi
f0104f5e:	53                   	push   %ebx
f0104f5f:	83 ec 4c             	sub    $0x4c,%esp
f0104f62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104f65:	c7 03 b4 7f 10 f0    	movl   $0xf0107fb4,(%ebx)
	info->eip_line = 0;
f0104f6b:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0104f72:	c7 43 08 b4 7f 10 f0 	movl   $0xf0107fb4,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0104f79:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0104f80:	8b 45 08             	mov    0x8(%ebp),%eax
f0104f83:	89 43 10             	mov    %eax,0x10(%ebx)
	info->eip_fn_narg = 0;
f0104f86:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104f8d:	3d ff ff 7f ef       	cmp    $0xef7fffff,%eax
f0104f92:	0f 86 10 01 00 00    	jbe    f01050a8 <debuginfo_eip+0x153>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0104f98:	c7 45 bc 91 87 11 f0 	movl   $0xf0118791,-0x44(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104f9f:	c7 45 b4 05 50 11 f0 	movl   $0xf0115005,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0104fa6:	bf 04 50 11 f0       	mov    $0xf0115004,%edi
		stabs = __STAB_BEGIN__;
f0104fab:	c7 45 b8 94 84 10 f0 	movl   $0xf0108494,-0x48(%ebp)
                               (uintptr_t)stabstr_end - (uintptr_t)stabstr, PTE_U) < 0))
        	return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104fb2:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104fb5:	39 75 b4             	cmp    %esi,-0x4c(%ebp)
f0104fb8:	0f 83 76 02 00 00    	jae    f0105234 <debuginfo_eip+0x2df>
f0104fbe:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
f0104fc2:	0f 85 73 02 00 00    	jne    f010523b <debuginfo_eip+0x2e6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104fc8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104fcf:	8b 75 b8             	mov    -0x48(%ebp),%esi
f0104fd2:	29 f7                	sub    %esi,%edi
f0104fd4:	c1 ff 02             	sar    $0x2,%edi
f0104fd7:	69 c7 ab aa aa aa    	imul   $0xaaaaaaab,%edi,%eax
f0104fdd:	83 e8 01             	sub    $0x1,%eax
f0104fe0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104fe3:	83 ec 08             	sub    $0x8,%esp
f0104fe6:	ff 75 08             	pushl  0x8(%ebp)
f0104fe9:	6a 64                	push   $0x64
f0104feb:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0104fee:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104ff1:	89 f0                	mov    %esi,%eax
f0104ff3:	e8 68 fe ff ff       	call   f0104e60 <stab_binsearch>
	if (lfile == 0)
f0104ff8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104ffb:	83 c4 10             	add    $0x10,%esp
f0104ffe:	85 c0                	test   %eax,%eax
f0105000:	0f 84 3c 02 00 00    	je     f0105242 <debuginfo_eip+0x2ed>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105006:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105009:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010500c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f010500f:	83 ec 08             	sub    $0x8,%esp
f0105012:	ff 75 08             	pushl  0x8(%ebp)
f0105015:	6a 24                	push   $0x24
f0105017:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f010501a:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010501d:	89 f0                	mov    %esi,%eax
f010501f:	e8 3c fe ff ff       	call   f0104e60 <stab_binsearch>

	if (lfun <= rfun) {
f0105024:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105027:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010502a:	83 c4 10             	add    $0x10,%esp
f010502d:	39 d0                	cmp    %edx,%eax
f010502f:	0f 8f 44 01 00 00    	jg     f0105179 <debuginfo_eip+0x224>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105035:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0105038:	8d 3c 8e             	lea    (%esi,%ecx,4),%edi
f010503b:	8b 0f                	mov    (%edi),%ecx
f010503d:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105040:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f0105043:	39 f1                	cmp    %esi,%ecx
f0105045:	73 06                	jae    f010504d <debuginfo_eip+0xf8>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105047:	03 4d b4             	add    -0x4c(%ebp),%ecx
f010504a:	89 4b 08             	mov    %ecx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f010504d:	8b 4f 08             	mov    0x8(%edi),%ecx
f0105050:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105053:	29 4d 08             	sub    %ecx,0x8(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
f0105056:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105059:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f010505c:	83 ec 08             	sub    $0x8,%esp
f010505f:	6a 3a                	push   $0x3a
f0105061:	ff 73 08             	pushl  0x8(%ebx)
f0105064:	e8 11 0a 00 00       	call   f0105a7a <strfind>
f0105069:	2b 43 08             	sub    0x8(%ebx),%eax
f010506c:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f010506f:	83 c4 08             	add    $0x8,%esp
f0105072:	ff 75 08             	pushl  0x8(%ebp)
f0105075:	6a 44                	push   $0x44
f0105077:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f010507a:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f010507d:	8b 75 b8             	mov    -0x48(%ebp),%esi
f0105080:	89 f0                	mov    %esi,%eax
f0105082:	e8 d9 fd ff ff       	call   f0104e60 <stab_binsearch>
	info->eip_line = stabs[lline].n_desc;
f0105087:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010508a:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010508d:	0f b7 4c 96 06       	movzwl 0x6(%esi,%edx,4),%ecx
f0105092:	89 4b 04             	mov    %ecx,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105095:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105098:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f010509c:	83 c4 10             	add    $0x10,%esp
f010509f:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f01050a3:	e9 f2 00 00 00       	jmp    f010519a <debuginfo_eip+0x245>
		if(curenv && user_mem_check(curenv, (void*)usd, sizeof(struct UserStabData), PTE_U) < 0){
f01050a8:	e8 0d 10 00 00       	call   f01060ba <cpunum>
f01050ad:	6b c0 74             	imul   $0x74,%eax,%eax
f01050b0:	83 b8 28 80 23 f0 00 	cmpl   $0x0,-0xfdc7fd8(%eax)
f01050b7:	74 27                	je     f01050e0 <debuginfo_eip+0x18b>
f01050b9:	e8 fc 0f 00 00       	call   f01060ba <cpunum>
f01050be:	6a 04                	push   $0x4
f01050c0:	6a 10                	push   $0x10
f01050c2:	68 00 00 20 00       	push   $0x200000
f01050c7:	6b c0 74             	imul   $0x74,%eax,%eax
f01050ca:	ff b0 28 80 23 f0    	pushl  -0xfdc7fd8(%eax)
f01050d0:	e8 14 df ff ff       	call   f0102fe9 <user_mem_check>
f01050d5:	83 c4 10             	add    $0x10,%esp
f01050d8:	85 c0                	test   %eax,%eax
f01050da:	0f 88 46 01 00 00    	js     f0105226 <debuginfo_eip+0x2d1>
		stabs = usd->stabs;
f01050e0:	8b 35 00 00 20 00    	mov    0x200000,%esi
f01050e6:	89 75 b8             	mov    %esi,-0x48(%ebp)
		stab_end = usd->stab_end;
f01050e9:	8b 3d 04 00 20 00    	mov    0x200004,%edi
		stabstr = usd->stabstr;
f01050ef:	a1 08 00 20 00       	mov    0x200008,%eax
f01050f4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f01050f7:	8b 0d 0c 00 20 00    	mov    0x20000c,%ecx
f01050fd:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		if (curenv && (
f0105100:	e8 b5 0f 00 00       	call   f01060ba <cpunum>
f0105105:	6b c0 74             	imul   $0x74,%eax,%eax
f0105108:	83 b8 28 80 23 f0 00 	cmpl   $0x0,-0xfdc7fd8(%eax)
f010510f:	0f 84 9d fe ff ff    	je     f0104fb2 <debuginfo_eip+0x5d>
                user_mem_check(curenv, (void*)stabs, 
f0105115:	89 fa                	mov    %edi,%edx
f0105117:	29 f2                	sub    %esi,%edx
f0105119:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f010511c:	e8 99 0f 00 00       	call   f01060ba <cpunum>
f0105121:	6a 04                	push   $0x4
f0105123:	ff 75 c4             	pushl  -0x3c(%ebp)
f0105126:	56                   	push   %esi
f0105127:	6b c0 74             	imul   $0x74,%eax,%eax
f010512a:	ff b0 28 80 23 f0    	pushl  -0xfdc7fd8(%eax)
f0105130:	e8 b4 de ff ff       	call   f0102fe9 <user_mem_check>
		if (curenv && (
f0105135:	83 c4 10             	add    $0x10,%esp
f0105138:	85 c0                	test   %eax,%eax
f010513a:	0f 88 ed 00 00 00    	js     f010522d <debuginfo_eip+0x2d8>
                user_mem_check(curenv, (void*)stabstr, 
f0105140:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105143:	8b 75 b4             	mov    -0x4c(%ebp),%esi
f0105146:	29 f1                	sub    %esi,%ecx
f0105148:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f010514b:	e8 6a 0f 00 00       	call   f01060ba <cpunum>
f0105150:	6a 04                	push   $0x4
f0105152:	ff 75 c4             	pushl  -0x3c(%ebp)
f0105155:	56                   	push   %esi
f0105156:	6b c0 74             	imul   $0x74,%eax,%eax
f0105159:	ff b0 28 80 23 f0    	pushl  -0xfdc7fd8(%eax)
f010515f:	e8 85 de ff ff       	call   f0102fe9 <user_mem_check>
                               (uintptr_t)stab_end - (uintptr_t)stabs, PTE_U) < 0 || 
f0105164:	83 c4 10             	add    $0x10,%esp
f0105167:	85 c0                	test   %eax,%eax
f0105169:	0f 89 43 fe ff ff    	jns    f0104fb2 <debuginfo_eip+0x5d>
        	return -1;
f010516f:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105174:	e9 d5 00 00 00       	jmp    f010524e <debuginfo_eip+0x2f9>
		info->eip_fn_addr = addr;
f0105179:	8b 45 08             	mov    0x8(%ebp),%eax
f010517c:	89 43 10             	mov    %eax,0x10(%ebx)
		lline = lfile;
f010517f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105182:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105185:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105188:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010518b:	e9 cc fe ff ff       	jmp    f010505c <debuginfo_eip+0x107>
f0105190:	83 e8 01             	sub    $0x1,%eax
f0105193:	83 ea 0c             	sub    $0xc,%edx
	while (lline >= lfile
f0105196:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f010519a:	89 45 c0             	mov    %eax,-0x40(%ebp)
f010519d:	39 c7                	cmp    %eax,%edi
f010519f:	7f 45                	jg     f01051e6 <debuginfo_eip+0x291>
	       && stabs[lline].n_type != N_SOL
f01051a1:	0f b6 0a             	movzbl (%edx),%ecx
f01051a4:	80 f9 84             	cmp    $0x84,%cl
f01051a7:	74 19                	je     f01051c2 <debuginfo_eip+0x26d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01051a9:	80 f9 64             	cmp    $0x64,%cl
f01051ac:	75 e2                	jne    f0105190 <debuginfo_eip+0x23b>
f01051ae:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f01051b2:	74 dc                	je     f0105190 <debuginfo_eip+0x23b>
f01051b4:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01051b8:	74 11                	je     f01051cb <debuginfo_eip+0x276>
f01051ba:	8b 7d c0             	mov    -0x40(%ebp),%edi
f01051bd:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01051c0:	eb 09                	jmp    f01051cb <debuginfo_eip+0x276>
f01051c2:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01051c6:	74 03                	je     f01051cb <debuginfo_eip+0x276>
f01051c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01051cb:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01051ce:	8b 7d b8             	mov    -0x48(%ebp),%edi
f01051d1:	8b 14 87             	mov    (%edi,%eax,4),%edx
f01051d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
f01051d7:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f01051da:	29 f8                	sub    %edi,%eax
f01051dc:	39 c2                	cmp    %eax,%edx
f01051de:	73 06                	jae    f01051e6 <debuginfo_eip+0x291>
		info->eip_file = stabstr + stabs[lline].n_strx;
f01051e0:	89 f8                	mov    %edi,%eax
f01051e2:	01 d0                	add    %edx,%eax
f01051e4:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f01051e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01051e9:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f01051ec:	ba 00 00 00 00       	mov    $0x0,%edx
	if (lfun < rfun)
f01051f1:	39 f0                	cmp    %esi,%eax
f01051f3:	7d 59                	jge    f010524e <debuginfo_eip+0x2f9>
		for (lline = lfun + 1;
f01051f5:	8d 50 01             	lea    0x1(%eax),%edx
f01051f8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f01051fb:	89 d0                	mov    %edx,%eax
f01051fd:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105200:	8b 7d b8             	mov    -0x48(%ebp),%edi
f0105203:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0105207:	eb 04                	jmp    f010520d <debuginfo_eip+0x2b8>
			info->eip_fn_narg++;
f0105209:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f010520d:	39 c6                	cmp    %eax,%esi
f010520f:	7e 38                	jle    f0105249 <debuginfo_eip+0x2f4>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105211:	0f b6 0a             	movzbl (%edx),%ecx
f0105214:	83 c0 01             	add    $0x1,%eax
f0105217:	83 c2 0c             	add    $0xc,%edx
f010521a:	80 f9 a0             	cmp    $0xa0,%cl
f010521d:	74 ea                	je     f0105209 <debuginfo_eip+0x2b4>
	return 0;
f010521f:	ba 00 00 00 00       	mov    $0x0,%edx
f0105224:	eb 28                	jmp    f010524e <debuginfo_eip+0x2f9>
			return -1;
f0105226:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f010522b:	eb 21                	jmp    f010524e <debuginfo_eip+0x2f9>
        	return -1;
f010522d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105232:	eb 1a                	jmp    f010524e <debuginfo_eip+0x2f9>
		return -1;
f0105234:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105239:	eb 13                	jmp    f010524e <debuginfo_eip+0x2f9>
f010523b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105240:	eb 0c                	jmp    f010524e <debuginfo_eip+0x2f9>
		return -1;
f0105242:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105247:	eb 05                	jmp    f010524e <debuginfo_eip+0x2f9>
	return 0;
f0105249:	ba 00 00 00 00       	mov    $0x0,%edx
}
f010524e:	89 d0                	mov    %edx,%eax
f0105250:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105253:	5b                   	pop    %ebx
f0105254:	5e                   	pop    %esi
f0105255:	5f                   	pop    %edi
f0105256:	5d                   	pop    %ebp
f0105257:	c3                   	ret    

f0105258 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105258:	55                   	push   %ebp
f0105259:	89 e5                	mov    %esp,%ebp
f010525b:	57                   	push   %edi
f010525c:	56                   	push   %esi
f010525d:	53                   	push   %ebx
f010525e:	83 ec 1c             	sub    $0x1c,%esp
f0105261:	89 c7                	mov    %eax,%edi
f0105263:	89 d6                	mov    %edx,%esi
f0105265:	8b 45 08             	mov    0x8(%ebp),%eax
f0105268:	8b 55 0c             	mov    0xc(%ebp),%edx
f010526b:	89 d1                	mov    %edx,%ecx
f010526d:	89 c2                	mov    %eax,%edx
f010526f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105272:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105275:	8b 45 10             	mov    0x10(%ebp),%eax
f0105278:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f010527b:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010527e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0105285:	39 c2                	cmp    %eax,%edx
f0105287:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f010528a:	72 3e                	jb     f01052ca <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f010528c:	83 ec 0c             	sub    $0xc,%esp
f010528f:	ff 75 18             	pushl  0x18(%ebp)
f0105292:	83 eb 01             	sub    $0x1,%ebx
f0105295:	53                   	push   %ebx
f0105296:	50                   	push   %eax
f0105297:	83 ec 08             	sub    $0x8,%esp
f010529a:	ff 75 e4             	pushl  -0x1c(%ebp)
f010529d:	ff 75 e0             	pushl  -0x20(%ebp)
f01052a0:	ff 75 dc             	pushl  -0x24(%ebp)
f01052a3:	ff 75 d8             	pushl  -0x28(%ebp)
f01052a6:	e8 25 12 00 00       	call   f01064d0 <__udivdi3>
f01052ab:	83 c4 18             	add    $0x18,%esp
f01052ae:	52                   	push   %edx
f01052af:	50                   	push   %eax
f01052b0:	89 f2                	mov    %esi,%edx
f01052b2:	89 f8                	mov    %edi,%eax
f01052b4:	e8 9f ff ff ff       	call   f0105258 <printnum>
f01052b9:	83 c4 20             	add    $0x20,%esp
f01052bc:	eb 13                	jmp    f01052d1 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01052be:	83 ec 08             	sub    $0x8,%esp
f01052c1:	56                   	push   %esi
f01052c2:	ff 75 18             	pushl  0x18(%ebp)
f01052c5:	ff d7                	call   *%edi
f01052c7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f01052ca:	83 eb 01             	sub    $0x1,%ebx
f01052cd:	85 db                	test   %ebx,%ebx
f01052cf:	7f ed                	jg     f01052be <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01052d1:	83 ec 08             	sub    $0x8,%esp
f01052d4:	56                   	push   %esi
f01052d5:	83 ec 04             	sub    $0x4,%esp
f01052d8:	ff 75 e4             	pushl  -0x1c(%ebp)
f01052db:	ff 75 e0             	pushl  -0x20(%ebp)
f01052de:	ff 75 dc             	pushl  -0x24(%ebp)
f01052e1:	ff 75 d8             	pushl  -0x28(%ebp)
f01052e4:	e8 f7 12 00 00       	call   f01065e0 <__umoddi3>
f01052e9:	83 c4 14             	add    $0x14,%esp
f01052ec:	0f be 80 be 7f 10 f0 	movsbl -0xfef8042(%eax),%eax
f01052f3:	50                   	push   %eax
f01052f4:	ff d7                	call   *%edi
}
f01052f6:	83 c4 10             	add    $0x10,%esp
f01052f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01052fc:	5b                   	pop    %ebx
f01052fd:	5e                   	pop    %esi
f01052fe:	5f                   	pop    %edi
f01052ff:	5d                   	pop    %ebp
f0105300:	c3                   	ret    

f0105301 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105301:	f3 0f 1e fb          	endbr32 
f0105305:	55                   	push   %ebp
f0105306:	89 e5                	mov    %esp,%ebp
f0105308:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f010530b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f010530f:	8b 10                	mov    (%eax),%edx
f0105311:	3b 50 04             	cmp    0x4(%eax),%edx
f0105314:	73 0a                	jae    f0105320 <sprintputch+0x1f>
		*b->buf++ = ch;
f0105316:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105319:	89 08                	mov    %ecx,(%eax)
f010531b:	8b 45 08             	mov    0x8(%ebp),%eax
f010531e:	88 02                	mov    %al,(%edx)
}
f0105320:	5d                   	pop    %ebp
f0105321:	c3                   	ret    

f0105322 <printfmt>:
{
f0105322:	f3 0f 1e fb          	endbr32 
f0105326:	55                   	push   %ebp
f0105327:	89 e5                	mov    %esp,%ebp
f0105329:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f010532c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010532f:	50                   	push   %eax
f0105330:	ff 75 10             	pushl  0x10(%ebp)
f0105333:	ff 75 0c             	pushl  0xc(%ebp)
f0105336:	ff 75 08             	pushl  0x8(%ebp)
f0105339:	e8 05 00 00 00       	call   f0105343 <vprintfmt>
}
f010533e:	83 c4 10             	add    $0x10,%esp
f0105341:	c9                   	leave  
f0105342:	c3                   	ret    

f0105343 <vprintfmt>:
{
f0105343:	f3 0f 1e fb          	endbr32 
f0105347:	55                   	push   %ebp
f0105348:	89 e5                	mov    %esp,%ebp
f010534a:	57                   	push   %edi
f010534b:	56                   	push   %esi
f010534c:	53                   	push   %ebx
f010534d:	83 ec 3c             	sub    $0x3c,%esp
f0105350:	8b 75 08             	mov    0x8(%ebp),%esi
f0105353:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105356:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105359:	e9 8e 03 00 00       	jmp    f01056ec <vprintfmt+0x3a9>
		padc = ' ';
f010535e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
f0105362:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
f0105369:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105370:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105377:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f010537c:	8d 47 01             	lea    0x1(%edi),%eax
f010537f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105382:	0f b6 17             	movzbl (%edi),%edx
f0105385:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105388:	3c 55                	cmp    $0x55,%al
f010538a:	0f 87 df 03 00 00    	ja     f010576f <vprintfmt+0x42c>
f0105390:	0f b6 c0             	movzbl %al,%eax
f0105393:	3e ff 24 85 80 80 10 	notrack jmp *-0xfef7f80(,%eax,4)
f010539a:	f0 
f010539b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f010539e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f01053a2:	eb d8                	jmp    f010537c <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f01053a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01053a7:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f01053ab:	eb cf                	jmp    f010537c <vprintfmt+0x39>
f01053ad:	0f b6 d2             	movzbl %dl,%edx
f01053b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f01053b3:	b8 00 00 00 00       	mov    $0x0,%eax
f01053b8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f01053bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01053be:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01053c2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f01053c5:	8d 4a d0             	lea    -0x30(%edx),%ecx
f01053c8:	83 f9 09             	cmp    $0x9,%ecx
f01053cb:	77 55                	ja     f0105422 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
f01053cd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f01053d0:	eb e9                	jmp    f01053bb <vprintfmt+0x78>
			precision = va_arg(ap, int);
f01053d2:	8b 45 14             	mov    0x14(%ebp),%eax
f01053d5:	8b 00                	mov    (%eax),%eax
f01053d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01053da:	8b 45 14             	mov    0x14(%ebp),%eax
f01053dd:	8d 40 04             	lea    0x4(%eax),%eax
f01053e0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01053e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f01053e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01053ea:	79 90                	jns    f010537c <vprintfmt+0x39>
				width = precision, precision = -1;
f01053ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01053ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01053f2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f01053f9:	eb 81                	jmp    f010537c <vprintfmt+0x39>
f01053fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01053fe:	85 c0                	test   %eax,%eax
f0105400:	ba 00 00 00 00       	mov    $0x0,%edx
f0105405:	0f 49 d0             	cmovns %eax,%edx
f0105408:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010540b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f010540e:	e9 69 ff ff ff       	jmp    f010537c <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f0105413:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105416:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
f010541d:	e9 5a ff ff ff       	jmp    f010537c <vprintfmt+0x39>
f0105422:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105425:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105428:	eb bc                	jmp    f01053e6 <vprintfmt+0xa3>
			lflag++;
f010542a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f010542d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105430:	e9 47 ff ff ff       	jmp    f010537c <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
f0105435:	8b 45 14             	mov    0x14(%ebp),%eax
f0105438:	8d 78 04             	lea    0x4(%eax),%edi
f010543b:	83 ec 08             	sub    $0x8,%esp
f010543e:	53                   	push   %ebx
f010543f:	ff 30                	pushl  (%eax)
f0105441:	ff d6                	call   *%esi
			break;
f0105443:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0105446:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0105449:	e9 9b 02 00 00       	jmp    f01056e9 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
f010544e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105451:	8d 78 04             	lea    0x4(%eax),%edi
f0105454:	8b 00                	mov    (%eax),%eax
f0105456:	99                   	cltd   
f0105457:	31 d0                	xor    %edx,%eax
f0105459:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010545b:	83 f8 08             	cmp    $0x8,%eax
f010545e:	7f 23                	jg     f0105483 <vprintfmt+0x140>
f0105460:	8b 14 85 e0 81 10 f0 	mov    -0xfef7e20(,%eax,4),%edx
f0105467:	85 d2                	test   %edx,%edx
f0105469:	74 18                	je     f0105483 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
f010546b:	52                   	push   %edx
f010546c:	68 2e 6d 10 f0       	push   $0xf0106d2e
f0105471:	53                   	push   %ebx
f0105472:	56                   	push   %esi
f0105473:	e8 aa fe ff ff       	call   f0105322 <printfmt>
f0105478:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010547b:	89 7d 14             	mov    %edi,0x14(%ebp)
f010547e:	e9 66 02 00 00       	jmp    f01056e9 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
f0105483:	50                   	push   %eax
f0105484:	68 d6 7f 10 f0       	push   $0xf0107fd6
f0105489:	53                   	push   %ebx
f010548a:	56                   	push   %esi
f010548b:	e8 92 fe ff ff       	call   f0105322 <printfmt>
f0105490:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105493:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105496:	e9 4e 02 00 00       	jmp    f01056e9 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
f010549b:	8b 45 14             	mov    0x14(%ebp),%eax
f010549e:	83 c0 04             	add    $0x4,%eax
f01054a1:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01054a4:	8b 45 14             	mov    0x14(%ebp),%eax
f01054a7:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f01054a9:	85 d2                	test   %edx,%edx
f01054ab:	b8 cf 7f 10 f0       	mov    $0xf0107fcf,%eax
f01054b0:	0f 45 c2             	cmovne %edx,%eax
f01054b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f01054b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01054ba:	7e 06                	jle    f01054c2 <vprintfmt+0x17f>
f01054bc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f01054c0:	75 0d                	jne    f01054cf <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
f01054c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01054c5:	89 c7                	mov    %eax,%edi
f01054c7:	03 45 e0             	add    -0x20(%ebp),%eax
f01054ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01054cd:	eb 55                	jmp    f0105524 <vprintfmt+0x1e1>
f01054cf:	83 ec 08             	sub    $0x8,%esp
f01054d2:	ff 75 d8             	pushl  -0x28(%ebp)
f01054d5:	ff 75 cc             	pushl  -0x34(%ebp)
f01054d8:	e8 2c 04 00 00       	call   f0105909 <strnlen>
f01054dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01054e0:	29 c2                	sub    %eax,%edx
f01054e2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f01054e5:	83 c4 10             	add    $0x10,%esp
f01054e8:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
f01054ea:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f01054ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f01054f1:	85 ff                	test   %edi,%edi
f01054f3:	7e 11                	jle    f0105506 <vprintfmt+0x1c3>
					putch(padc, putdat);
f01054f5:	83 ec 08             	sub    $0x8,%esp
f01054f8:	53                   	push   %ebx
f01054f9:	ff 75 e0             	pushl  -0x20(%ebp)
f01054fc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f01054fe:	83 ef 01             	sub    $0x1,%edi
f0105501:	83 c4 10             	add    $0x10,%esp
f0105504:	eb eb                	jmp    f01054f1 <vprintfmt+0x1ae>
f0105506:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0105509:	85 d2                	test   %edx,%edx
f010550b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105510:	0f 49 c2             	cmovns %edx,%eax
f0105513:	29 c2                	sub    %eax,%edx
f0105515:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0105518:	eb a8                	jmp    f01054c2 <vprintfmt+0x17f>
					putch(ch, putdat);
f010551a:	83 ec 08             	sub    $0x8,%esp
f010551d:	53                   	push   %ebx
f010551e:	52                   	push   %edx
f010551f:	ff d6                	call   *%esi
f0105521:	83 c4 10             	add    $0x10,%esp
f0105524:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105527:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105529:	83 c7 01             	add    $0x1,%edi
f010552c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105530:	0f be d0             	movsbl %al,%edx
f0105533:	85 d2                	test   %edx,%edx
f0105535:	74 4b                	je     f0105582 <vprintfmt+0x23f>
f0105537:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f010553b:	78 06                	js     f0105543 <vprintfmt+0x200>
f010553d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105541:	78 1e                	js     f0105561 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
f0105543:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0105547:	74 d1                	je     f010551a <vprintfmt+0x1d7>
f0105549:	0f be c0             	movsbl %al,%eax
f010554c:	83 e8 20             	sub    $0x20,%eax
f010554f:	83 f8 5e             	cmp    $0x5e,%eax
f0105552:	76 c6                	jbe    f010551a <vprintfmt+0x1d7>
					putch('?', putdat);
f0105554:	83 ec 08             	sub    $0x8,%esp
f0105557:	53                   	push   %ebx
f0105558:	6a 3f                	push   $0x3f
f010555a:	ff d6                	call   *%esi
f010555c:	83 c4 10             	add    $0x10,%esp
f010555f:	eb c3                	jmp    f0105524 <vprintfmt+0x1e1>
f0105561:	89 cf                	mov    %ecx,%edi
f0105563:	eb 0e                	jmp    f0105573 <vprintfmt+0x230>
				putch(' ', putdat);
f0105565:	83 ec 08             	sub    $0x8,%esp
f0105568:	53                   	push   %ebx
f0105569:	6a 20                	push   $0x20
f010556b:	ff d6                	call   *%esi
			for (; width > 0; width--)
f010556d:	83 ef 01             	sub    $0x1,%edi
f0105570:	83 c4 10             	add    $0x10,%esp
f0105573:	85 ff                	test   %edi,%edi
f0105575:	7f ee                	jg     f0105565 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
f0105577:	8b 45 c8             	mov    -0x38(%ebp),%eax
f010557a:	89 45 14             	mov    %eax,0x14(%ebp)
f010557d:	e9 67 01 00 00       	jmp    f01056e9 <vprintfmt+0x3a6>
f0105582:	89 cf                	mov    %ecx,%edi
f0105584:	eb ed                	jmp    f0105573 <vprintfmt+0x230>
	if (lflag >= 2)
f0105586:	83 f9 01             	cmp    $0x1,%ecx
f0105589:	7f 1b                	jg     f01055a6 <vprintfmt+0x263>
	else if (lflag)
f010558b:	85 c9                	test   %ecx,%ecx
f010558d:	74 63                	je     f01055f2 <vprintfmt+0x2af>
		return va_arg(*ap, long);
f010558f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105592:	8b 00                	mov    (%eax),%eax
f0105594:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105597:	99                   	cltd   
f0105598:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010559b:	8b 45 14             	mov    0x14(%ebp),%eax
f010559e:	8d 40 04             	lea    0x4(%eax),%eax
f01055a1:	89 45 14             	mov    %eax,0x14(%ebp)
f01055a4:	eb 17                	jmp    f01055bd <vprintfmt+0x27a>
		return va_arg(*ap, long long);
f01055a6:	8b 45 14             	mov    0x14(%ebp),%eax
f01055a9:	8b 50 04             	mov    0x4(%eax),%edx
f01055ac:	8b 00                	mov    (%eax),%eax
f01055ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01055b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01055b4:	8b 45 14             	mov    0x14(%ebp),%eax
f01055b7:	8d 40 08             	lea    0x8(%eax),%eax
f01055ba:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01055bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01055c0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f01055c3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f01055c8:	85 c9                	test   %ecx,%ecx
f01055ca:	0f 89 ff 00 00 00    	jns    f01056cf <vprintfmt+0x38c>
				putch('-', putdat);
f01055d0:	83 ec 08             	sub    $0x8,%esp
f01055d3:	53                   	push   %ebx
f01055d4:	6a 2d                	push   $0x2d
f01055d6:	ff d6                	call   *%esi
				num = -(long long) num;
f01055d8:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01055db:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01055de:	f7 da                	neg    %edx
f01055e0:	83 d1 00             	adc    $0x0,%ecx
f01055e3:	f7 d9                	neg    %ecx
f01055e5:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01055e8:	b8 0a 00 00 00       	mov    $0xa,%eax
f01055ed:	e9 dd 00 00 00       	jmp    f01056cf <vprintfmt+0x38c>
		return va_arg(*ap, int);
f01055f2:	8b 45 14             	mov    0x14(%ebp),%eax
f01055f5:	8b 00                	mov    (%eax),%eax
f01055f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01055fa:	99                   	cltd   
f01055fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01055fe:	8b 45 14             	mov    0x14(%ebp),%eax
f0105601:	8d 40 04             	lea    0x4(%eax),%eax
f0105604:	89 45 14             	mov    %eax,0x14(%ebp)
f0105607:	eb b4                	jmp    f01055bd <vprintfmt+0x27a>
	if (lflag >= 2)
f0105609:	83 f9 01             	cmp    $0x1,%ecx
f010560c:	7f 1e                	jg     f010562c <vprintfmt+0x2e9>
	else if (lflag)
f010560e:	85 c9                	test   %ecx,%ecx
f0105610:	74 32                	je     f0105644 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
f0105612:	8b 45 14             	mov    0x14(%ebp),%eax
f0105615:	8b 10                	mov    (%eax),%edx
f0105617:	b9 00 00 00 00       	mov    $0x0,%ecx
f010561c:	8d 40 04             	lea    0x4(%eax),%eax
f010561f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105622:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
f0105627:	e9 a3 00 00 00       	jmp    f01056cf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f010562c:	8b 45 14             	mov    0x14(%ebp),%eax
f010562f:	8b 10                	mov    (%eax),%edx
f0105631:	8b 48 04             	mov    0x4(%eax),%ecx
f0105634:	8d 40 08             	lea    0x8(%eax),%eax
f0105637:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010563a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
f010563f:	e9 8b 00 00 00       	jmp    f01056cf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f0105644:	8b 45 14             	mov    0x14(%ebp),%eax
f0105647:	8b 10                	mov    (%eax),%edx
f0105649:	b9 00 00 00 00       	mov    $0x0,%ecx
f010564e:	8d 40 04             	lea    0x4(%eax),%eax
f0105651:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105654:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
f0105659:	eb 74                	jmp    f01056cf <vprintfmt+0x38c>
	if (lflag >= 2)
f010565b:	83 f9 01             	cmp    $0x1,%ecx
f010565e:	7f 1b                	jg     f010567b <vprintfmt+0x338>
	else if (lflag)
f0105660:	85 c9                	test   %ecx,%ecx
f0105662:	74 2c                	je     f0105690 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
f0105664:	8b 45 14             	mov    0x14(%ebp),%eax
f0105667:	8b 10                	mov    (%eax),%edx
f0105669:	b9 00 00 00 00       	mov    $0x0,%ecx
f010566e:	8d 40 04             	lea    0x4(%eax),%eax
f0105671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105674:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
f0105679:	eb 54                	jmp    f01056cf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f010567b:	8b 45 14             	mov    0x14(%ebp),%eax
f010567e:	8b 10                	mov    (%eax),%edx
f0105680:	8b 48 04             	mov    0x4(%eax),%ecx
f0105683:	8d 40 08             	lea    0x8(%eax),%eax
f0105686:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105689:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
f010568e:	eb 3f                	jmp    f01056cf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f0105690:	8b 45 14             	mov    0x14(%ebp),%eax
f0105693:	8b 10                	mov    (%eax),%edx
f0105695:	b9 00 00 00 00       	mov    $0x0,%ecx
f010569a:	8d 40 04             	lea    0x4(%eax),%eax
f010569d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01056a0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
f01056a5:	eb 28                	jmp    f01056cf <vprintfmt+0x38c>
			putch('0', putdat);
f01056a7:	83 ec 08             	sub    $0x8,%esp
f01056aa:	53                   	push   %ebx
f01056ab:	6a 30                	push   $0x30
f01056ad:	ff d6                	call   *%esi
			putch('x', putdat);
f01056af:	83 c4 08             	add    $0x8,%esp
f01056b2:	53                   	push   %ebx
f01056b3:	6a 78                	push   $0x78
f01056b5:	ff d6                	call   *%esi
			num = (unsigned long long)
f01056b7:	8b 45 14             	mov    0x14(%ebp),%eax
f01056ba:	8b 10                	mov    (%eax),%edx
f01056bc:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f01056c1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01056c4:	8d 40 04             	lea    0x4(%eax),%eax
f01056c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01056ca:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01056cf:	83 ec 0c             	sub    $0xc,%esp
f01056d2:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
f01056d6:	57                   	push   %edi
f01056d7:	ff 75 e0             	pushl  -0x20(%ebp)
f01056da:	50                   	push   %eax
f01056db:	51                   	push   %ecx
f01056dc:	52                   	push   %edx
f01056dd:	89 da                	mov    %ebx,%edx
f01056df:	89 f0                	mov    %esi,%eax
f01056e1:	e8 72 fb ff ff       	call   f0105258 <printnum>
			break;
f01056e6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f01056e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01056ec:	83 c7 01             	add    $0x1,%edi
f01056ef:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01056f3:	83 f8 25             	cmp    $0x25,%eax
f01056f6:	0f 84 62 fc ff ff    	je     f010535e <vprintfmt+0x1b>
			if (ch == '\0')
f01056fc:	85 c0                	test   %eax,%eax
f01056fe:	0f 84 8b 00 00 00    	je     f010578f <vprintfmt+0x44c>
			putch(ch, putdat);
f0105704:	83 ec 08             	sub    $0x8,%esp
f0105707:	53                   	push   %ebx
f0105708:	50                   	push   %eax
f0105709:	ff d6                	call   *%esi
f010570b:	83 c4 10             	add    $0x10,%esp
f010570e:	eb dc                	jmp    f01056ec <vprintfmt+0x3a9>
	if (lflag >= 2)
f0105710:	83 f9 01             	cmp    $0x1,%ecx
f0105713:	7f 1b                	jg     f0105730 <vprintfmt+0x3ed>
	else if (lflag)
f0105715:	85 c9                	test   %ecx,%ecx
f0105717:	74 2c                	je     f0105745 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
f0105719:	8b 45 14             	mov    0x14(%ebp),%eax
f010571c:	8b 10                	mov    (%eax),%edx
f010571e:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105723:	8d 40 04             	lea    0x4(%eax),%eax
f0105726:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105729:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
f010572e:	eb 9f                	jmp    f01056cf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f0105730:	8b 45 14             	mov    0x14(%ebp),%eax
f0105733:	8b 10                	mov    (%eax),%edx
f0105735:	8b 48 04             	mov    0x4(%eax),%ecx
f0105738:	8d 40 08             	lea    0x8(%eax),%eax
f010573b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010573e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
f0105743:	eb 8a                	jmp    f01056cf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f0105745:	8b 45 14             	mov    0x14(%ebp),%eax
f0105748:	8b 10                	mov    (%eax),%edx
f010574a:	b9 00 00 00 00       	mov    $0x0,%ecx
f010574f:	8d 40 04             	lea    0x4(%eax),%eax
f0105752:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105755:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
f010575a:	e9 70 ff ff ff       	jmp    f01056cf <vprintfmt+0x38c>
			putch(ch, putdat);
f010575f:	83 ec 08             	sub    $0x8,%esp
f0105762:	53                   	push   %ebx
f0105763:	6a 25                	push   $0x25
f0105765:	ff d6                	call   *%esi
			break;
f0105767:	83 c4 10             	add    $0x10,%esp
f010576a:	e9 7a ff ff ff       	jmp    f01056e9 <vprintfmt+0x3a6>
			putch('%', putdat);
f010576f:	83 ec 08             	sub    $0x8,%esp
f0105772:	53                   	push   %ebx
f0105773:	6a 25                	push   $0x25
f0105775:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105777:	83 c4 10             	add    $0x10,%esp
f010577a:	89 f8                	mov    %edi,%eax
f010577c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0105780:	74 05                	je     f0105787 <vprintfmt+0x444>
f0105782:	83 e8 01             	sub    $0x1,%eax
f0105785:	eb f5                	jmp    f010577c <vprintfmt+0x439>
f0105787:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010578a:	e9 5a ff ff ff       	jmp    f01056e9 <vprintfmt+0x3a6>
}
f010578f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105792:	5b                   	pop    %ebx
f0105793:	5e                   	pop    %esi
f0105794:	5f                   	pop    %edi
f0105795:	5d                   	pop    %ebp
f0105796:	c3                   	ret    

f0105797 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0105797:	f3 0f 1e fb          	endbr32 
f010579b:	55                   	push   %ebp
f010579c:	89 e5                	mov    %esp,%ebp
f010579e:	83 ec 18             	sub    $0x18,%esp
f01057a1:	8b 45 08             	mov    0x8(%ebp),%eax
f01057a4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01057a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01057aa:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01057ae:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01057b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01057b8:	85 c0                	test   %eax,%eax
f01057ba:	74 26                	je     f01057e2 <vsnprintf+0x4b>
f01057bc:	85 d2                	test   %edx,%edx
f01057be:	7e 22                	jle    f01057e2 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01057c0:	ff 75 14             	pushl  0x14(%ebp)
f01057c3:	ff 75 10             	pushl  0x10(%ebp)
f01057c6:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01057c9:	50                   	push   %eax
f01057ca:	68 01 53 10 f0       	push   $0xf0105301
f01057cf:	e8 6f fb ff ff       	call   f0105343 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01057d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01057d7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01057da:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01057dd:	83 c4 10             	add    $0x10,%esp
}
f01057e0:	c9                   	leave  
f01057e1:	c3                   	ret    
		return -E_INVAL;
f01057e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01057e7:	eb f7                	jmp    f01057e0 <vsnprintf+0x49>

f01057e9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01057e9:	f3 0f 1e fb          	endbr32 
f01057ed:	55                   	push   %ebp
f01057ee:	89 e5                	mov    %esp,%ebp
f01057f0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f01057f3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f01057f6:	50                   	push   %eax
f01057f7:	ff 75 10             	pushl  0x10(%ebp)
f01057fa:	ff 75 0c             	pushl  0xc(%ebp)
f01057fd:	ff 75 08             	pushl  0x8(%ebp)
f0105800:	e8 92 ff ff ff       	call   f0105797 <vsnprintf>
	va_end(ap);

	return rc;
}
f0105805:	c9                   	leave  
f0105806:	c3                   	ret    

f0105807 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0105807:	f3 0f 1e fb          	endbr32 
f010580b:	55                   	push   %ebp
f010580c:	89 e5                	mov    %esp,%ebp
f010580e:	57                   	push   %edi
f010580f:	56                   	push   %esi
f0105810:	53                   	push   %ebx
f0105811:	83 ec 0c             	sub    $0xc,%esp
f0105814:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0105817:	85 c0                	test   %eax,%eax
f0105819:	74 11                	je     f010582c <readline+0x25>
		cprintf("%s", prompt);
f010581b:	83 ec 08             	sub    $0x8,%esp
f010581e:	50                   	push   %eax
f010581f:	68 2e 6d 10 f0       	push   $0xf0106d2e
f0105824:	e8 06 e2 ff ff       	call   f0103a2f <cprintf>
f0105829:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f010582c:	83 ec 0c             	sub    $0xc,%esp
f010582f:	6a 00                	push   $0x0
f0105831:	e8 67 af ff ff       	call   f010079d <iscons>
f0105836:	89 c7                	mov    %eax,%edi
f0105838:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010583b:	be 00 00 00 00       	mov    $0x0,%esi
f0105840:	eb 4b                	jmp    f010588d <readline+0x86>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
f0105842:	83 ec 08             	sub    $0x8,%esp
f0105845:	50                   	push   %eax
f0105846:	68 04 82 10 f0       	push   $0xf0108204
f010584b:	e8 df e1 ff ff       	call   f0103a2f <cprintf>
			return NULL;
f0105850:	83 c4 10             	add    $0x10,%esp
f0105853:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0105858:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010585b:	5b                   	pop    %ebx
f010585c:	5e                   	pop    %esi
f010585d:	5f                   	pop    %edi
f010585e:	5d                   	pop    %ebp
f010585f:	c3                   	ret    
			if (echoing)
f0105860:	85 ff                	test   %edi,%edi
f0105862:	75 05                	jne    f0105869 <readline+0x62>
			i--;
f0105864:	83 ee 01             	sub    $0x1,%esi
f0105867:	eb 24                	jmp    f010588d <readline+0x86>
				cputchar('\b');
f0105869:	83 ec 0c             	sub    $0xc,%esp
f010586c:	6a 08                	push   $0x8
f010586e:	e8 01 af ff ff       	call   f0100774 <cputchar>
f0105873:	83 c4 10             	add    $0x10,%esp
f0105876:	eb ec                	jmp    f0105864 <readline+0x5d>
				cputchar(c);
f0105878:	83 ec 0c             	sub    $0xc,%esp
f010587b:	53                   	push   %ebx
f010587c:	e8 f3 ae ff ff       	call   f0100774 <cputchar>
f0105881:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f0105884:	88 9e 80 7a 23 f0    	mov    %bl,-0xfdc8580(%esi)
f010588a:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f010588d:	e8 f6 ae ff ff       	call   f0100788 <getchar>
f0105892:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0105894:	85 c0                	test   %eax,%eax
f0105896:	78 aa                	js     f0105842 <readline+0x3b>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0105898:	83 f8 08             	cmp    $0x8,%eax
f010589b:	0f 94 c2             	sete   %dl
f010589e:	83 f8 7f             	cmp    $0x7f,%eax
f01058a1:	0f 94 c0             	sete   %al
f01058a4:	08 c2                	or     %al,%dl
f01058a6:	74 04                	je     f01058ac <readline+0xa5>
f01058a8:	85 f6                	test   %esi,%esi
f01058aa:	7f b4                	jg     f0105860 <readline+0x59>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01058ac:	83 fb 1f             	cmp    $0x1f,%ebx
f01058af:	7e 0e                	jle    f01058bf <readline+0xb8>
f01058b1:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01058b7:	7f 06                	jg     f01058bf <readline+0xb8>
			if (echoing)
f01058b9:	85 ff                	test   %edi,%edi
f01058bb:	74 c7                	je     f0105884 <readline+0x7d>
f01058bd:	eb b9                	jmp    f0105878 <readline+0x71>
		} else if (c == '\n' || c == '\r') {
f01058bf:	83 fb 0a             	cmp    $0xa,%ebx
f01058c2:	74 05                	je     f01058c9 <readline+0xc2>
f01058c4:	83 fb 0d             	cmp    $0xd,%ebx
f01058c7:	75 c4                	jne    f010588d <readline+0x86>
			if (echoing)
f01058c9:	85 ff                	test   %edi,%edi
f01058cb:	75 11                	jne    f01058de <readline+0xd7>
			buf[i] = 0;
f01058cd:	c6 86 80 7a 23 f0 00 	movb   $0x0,-0xfdc8580(%esi)
			return buf;
f01058d4:	b8 80 7a 23 f0       	mov    $0xf0237a80,%eax
f01058d9:	e9 7a ff ff ff       	jmp    f0105858 <readline+0x51>
				cputchar('\n');
f01058de:	83 ec 0c             	sub    $0xc,%esp
f01058e1:	6a 0a                	push   $0xa
f01058e3:	e8 8c ae ff ff       	call   f0100774 <cputchar>
f01058e8:	83 c4 10             	add    $0x10,%esp
f01058eb:	eb e0                	jmp    f01058cd <readline+0xc6>

f01058ed <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f01058ed:	f3 0f 1e fb          	endbr32 
f01058f1:	55                   	push   %ebp
f01058f2:	89 e5                	mov    %esp,%ebp
f01058f4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f01058f7:	b8 00 00 00 00       	mov    $0x0,%eax
f01058fc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105900:	74 05                	je     f0105907 <strlen+0x1a>
		n++;
f0105902:	83 c0 01             	add    $0x1,%eax
f0105905:	eb f5                	jmp    f01058fc <strlen+0xf>
	return n;
}
f0105907:	5d                   	pop    %ebp
f0105908:	c3                   	ret    

f0105909 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105909:	f3 0f 1e fb          	endbr32 
f010590d:	55                   	push   %ebp
f010590e:	89 e5                	mov    %esp,%ebp
f0105910:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105913:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105916:	b8 00 00 00 00       	mov    $0x0,%eax
f010591b:	39 d0                	cmp    %edx,%eax
f010591d:	74 0d                	je     f010592c <strnlen+0x23>
f010591f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0105923:	74 05                	je     f010592a <strnlen+0x21>
		n++;
f0105925:	83 c0 01             	add    $0x1,%eax
f0105928:	eb f1                	jmp    f010591b <strnlen+0x12>
f010592a:	89 c2                	mov    %eax,%edx
	return n;
}
f010592c:	89 d0                	mov    %edx,%eax
f010592e:	5d                   	pop    %ebp
f010592f:	c3                   	ret    

f0105930 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105930:	f3 0f 1e fb          	endbr32 
f0105934:	55                   	push   %ebp
f0105935:	89 e5                	mov    %esp,%ebp
f0105937:	53                   	push   %ebx
f0105938:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010593b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010593e:	b8 00 00 00 00       	mov    $0x0,%eax
f0105943:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f0105947:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f010594a:	83 c0 01             	add    $0x1,%eax
f010594d:	84 d2                	test   %dl,%dl
f010594f:	75 f2                	jne    f0105943 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
f0105951:	89 c8                	mov    %ecx,%eax
f0105953:	5b                   	pop    %ebx
f0105954:	5d                   	pop    %ebp
f0105955:	c3                   	ret    

f0105956 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105956:	f3 0f 1e fb          	endbr32 
f010595a:	55                   	push   %ebp
f010595b:	89 e5                	mov    %esp,%ebp
f010595d:	53                   	push   %ebx
f010595e:	83 ec 10             	sub    $0x10,%esp
f0105961:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105964:	53                   	push   %ebx
f0105965:	e8 83 ff ff ff       	call   f01058ed <strlen>
f010596a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f010596d:	ff 75 0c             	pushl  0xc(%ebp)
f0105970:	01 d8                	add    %ebx,%eax
f0105972:	50                   	push   %eax
f0105973:	e8 b8 ff ff ff       	call   f0105930 <strcpy>
	return dst;
}
f0105978:	89 d8                	mov    %ebx,%eax
f010597a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010597d:	c9                   	leave  
f010597e:	c3                   	ret    

f010597f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f010597f:	f3 0f 1e fb          	endbr32 
f0105983:	55                   	push   %ebp
f0105984:	89 e5                	mov    %esp,%ebp
f0105986:	56                   	push   %esi
f0105987:	53                   	push   %ebx
f0105988:	8b 75 08             	mov    0x8(%ebp),%esi
f010598b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010598e:	89 f3                	mov    %esi,%ebx
f0105990:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105993:	89 f0                	mov    %esi,%eax
f0105995:	39 d8                	cmp    %ebx,%eax
f0105997:	74 11                	je     f01059aa <strncpy+0x2b>
		*dst++ = *src;
f0105999:	83 c0 01             	add    $0x1,%eax
f010599c:	0f b6 0a             	movzbl (%edx),%ecx
f010599f:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01059a2:	80 f9 01             	cmp    $0x1,%cl
f01059a5:	83 da ff             	sbb    $0xffffffff,%edx
f01059a8:	eb eb                	jmp    f0105995 <strncpy+0x16>
	}
	return ret;
}
f01059aa:	89 f0                	mov    %esi,%eax
f01059ac:	5b                   	pop    %ebx
f01059ad:	5e                   	pop    %esi
f01059ae:	5d                   	pop    %ebp
f01059af:	c3                   	ret    

f01059b0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01059b0:	f3 0f 1e fb          	endbr32 
f01059b4:	55                   	push   %ebp
f01059b5:	89 e5                	mov    %esp,%ebp
f01059b7:	56                   	push   %esi
f01059b8:	53                   	push   %ebx
f01059b9:	8b 75 08             	mov    0x8(%ebp),%esi
f01059bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01059bf:	8b 55 10             	mov    0x10(%ebp),%edx
f01059c2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01059c4:	85 d2                	test   %edx,%edx
f01059c6:	74 21                	je     f01059e9 <strlcpy+0x39>
f01059c8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01059cc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01059ce:	39 c2                	cmp    %eax,%edx
f01059d0:	74 14                	je     f01059e6 <strlcpy+0x36>
f01059d2:	0f b6 19             	movzbl (%ecx),%ebx
f01059d5:	84 db                	test   %bl,%bl
f01059d7:	74 0b                	je     f01059e4 <strlcpy+0x34>
			*dst++ = *src++;
f01059d9:	83 c1 01             	add    $0x1,%ecx
f01059dc:	83 c2 01             	add    $0x1,%edx
f01059df:	88 5a ff             	mov    %bl,-0x1(%edx)
f01059e2:	eb ea                	jmp    f01059ce <strlcpy+0x1e>
f01059e4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f01059e6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01059e9:	29 f0                	sub    %esi,%eax
}
f01059eb:	5b                   	pop    %ebx
f01059ec:	5e                   	pop    %esi
f01059ed:	5d                   	pop    %ebp
f01059ee:	c3                   	ret    

f01059ef <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01059ef:	f3 0f 1e fb          	endbr32 
f01059f3:	55                   	push   %ebp
f01059f4:	89 e5                	mov    %esp,%ebp
f01059f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01059f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01059fc:	0f b6 01             	movzbl (%ecx),%eax
f01059ff:	84 c0                	test   %al,%al
f0105a01:	74 0c                	je     f0105a0f <strcmp+0x20>
f0105a03:	3a 02                	cmp    (%edx),%al
f0105a05:	75 08                	jne    f0105a0f <strcmp+0x20>
		p++, q++;
f0105a07:	83 c1 01             	add    $0x1,%ecx
f0105a0a:	83 c2 01             	add    $0x1,%edx
f0105a0d:	eb ed                	jmp    f01059fc <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105a0f:	0f b6 c0             	movzbl %al,%eax
f0105a12:	0f b6 12             	movzbl (%edx),%edx
f0105a15:	29 d0                	sub    %edx,%eax
}
f0105a17:	5d                   	pop    %ebp
f0105a18:	c3                   	ret    

f0105a19 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0105a19:	f3 0f 1e fb          	endbr32 
f0105a1d:	55                   	push   %ebp
f0105a1e:	89 e5                	mov    %esp,%ebp
f0105a20:	53                   	push   %ebx
f0105a21:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a24:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105a27:	89 c3                	mov    %eax,%ebx
f0105a29:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0105a2c:	eb 06                	jmp    f0105a34 <strncmp+0x1b>
		n--, p++, q++;
f0105a2e:	83 c0 01             	add    $0x1,%eax
f0105a31:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105a34:	39 d8                	cmp    %ebx,%eax
f0105a36:	74 16                	je     f0105a4e <strncmp+0x35>
f0105a38:	0f b6 08             	movzbl (%eax),%ecx
f0105a3b:	84 c9                	test   %cl,%cl
f0105a3d:	74 04                	je     f0105a43 <strncmp+0x2a>
f0105a3f:	3a 0a                	cmp    (%edx),%cl
f0105a41:	74 eb                	je     f0105a2e <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105a43:	0f b6 00             	movzbl (%eax),%eax
f0105a46:	0f b6 12             	movzbl (%edx),%edx
f0105a49:	29 d0                	sub    %edx,%eax
}
f0105a4b:	5b                   	pop    %ebx
f0105a4c:	5d                   	pop    %ebp
f0105a4d:	c3                   	ret    
		return 0;
f0105a4e:	b8 00 00 00 00       	mov    $0x0,%eax
f0105a53:	eb f6                	jmp    f0105a4b <strncmp+0x32>

f0105a55 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105a55:	f3 0f 1e fb          	endbr32 
f0105a59:	55                   	push   %ebp
f0105a5a:	89 e5                	mov    %esp,%ebp
f0105a5c:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a5f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105a63:	0f b6 10             	movzbl (%eax),%edx
f0105a66:	84 d2                	test   %dl,%dl
f0105a68:	74 09                	je     f0105a73 <strchr+0x1e>
		if (*s == c)
f0105a6a:	38 ca                	cmp    %cl,%dl
f0105a6c:	74 0a                	je     f0105a78 <strchr+0x23>
	for (; *s; s++)
f0105a6e:	83 c0 01             	add    $0x1,%eax
f0105a71:	eb f0                	jmp    f0105a63 <strchr+0xe>
			return (char *) s;
	return 0;
f0105a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105a78:	5d                   	pop    %ebp
f0105a79:	c3                   	ret    

f0105a7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105a7a:	f3 0f 1e fb          	endbr32 
f0105a7e:	55                   	push   %ebp
f0105a7f:	89 e5                	mov    %esp,%ebp
f0105a81:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a84:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105a88:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0105a8b:	38 ca                	cmp    %cl,%dl
f0105a8d:	74 09                	je     f0105a98 <strfind+0x1e>
f0105a8f:	84 d2                	test   %dl,%dl
f0105a91:	74 05                	je     f0105a98 <strfind+0x1e>
	for (; *s; s++)
f0105a93:	83 c0 01             	add    $0x1,%eax
f0105a96:	eb f0                	jmp    f0105a88 <strfind+0xe>
			break;
	return (char *) s;
}
f0105a98:	5d                   	pop    %ebp
f0105a99:	c3                   	ret    

f0105a9a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105a9a:	f3 0f 1e fb          	endbr32 
f0105a9e:	55                   	push   %ebp
f0105a9f:	89 e5                	mov    %esp,%ebp
f0105aa1:	57                   	push   %edi
f0105aa2:	56                   	push   %esi
f0105aa3:	53                   	push   %ebx
f0105aa4:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105aa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0105aaa:	85 c9                	test   %ecx,%ecx
f0105aac:	74 31                	je     f0105adf <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0105aae:	89 f8                	mov    %edi,%eax
f0105ab0:	09 c8                	or     %ecx,%eax
f0105ab2:	a8 03                	test   $0x3,%al
f0105ab4:	75 23                	jne    f0105ad9 <memset+0x3f>
		c &= 0xFF;
f0105ab6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0105aba:	89 d3                	mov    %edx,%ebx
f0105abc:	c1 e3 08             	shl    $0x8,%ebx
f0105abf:	89 d0                	mov    %edx,%eax
f0105ac1:	c1 e0 18             	shl    $0x18,%eax
f0105ac4:	89 d6                	mov    %edx,%esi
f0105ac6:	c1 e6 10             	shl    $0x10,%esi
f0105ac9:	09 f0                	or     %esi,%eax
f0105acb:	09 c2                	or     %eax,%edx
f0105acd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0105acf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0105ad2:	89 d0                	mov    %edx,%eax
f0105ad4:	fc                   	cld    
f0105ad5:	f3 ab                	rep stos %eax,%es:(%edi)
f0105ad7:	eb 06                	jmp    f0105adf <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0105ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105adc:	fc                   	cld    
f0105add:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0105adf:	89 f8                	mov    %edi,%eax
f0105ae1:	5b                   	pop    %ebx
f0105ae2:	5e                   	pop    %esi
f0105ae3:	5f                   	pop    %edi
f0105ae4:	5d                   	pop    %ebp
f0105ae5:	c3                   	ret    

f0105ae6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105ae6:	f3 0f 1e fb          	endbr32 
f0105aea:	55                   	push   %ebp
f0105aeb:	89 e5                	mov    %esp,%ebp
f0105aed:	57                   	push   %edi
f0105aee:	56                   	push   %esi
f0105aef:	8b 45 08             	mov    0x8(%ebp),%eax
f0105af2:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105af5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105af8:	39 c6                	cmp    %eax,%esi
f0105afa:	73 32                	jae    f0105b2e <memmove+0x48>
f0105afc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105aff:	39 c2                	cmp    %eax,%edx
f0105b01:	76 2b                	jbe    f0105b2e <memmove+0x48>
		s += n;
		d += n;
f0105b03:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105b06:	89 fe                	mov    %edi,%esi
f0105b08:	09 ce                	or     %ecx,%esi
f0105b0a:	09 d6                	or     %edx,%esi
f0105b0c:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105b12:	75 0e                	jne    f0105b22 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105b14:	83 ef 04             	sub    $0x4,%edi
f0105b17:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105b1a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105b1d:	fd                   	std    
f0105b1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105b20:	eb 09                	jmp    f0105b2b <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105b22:	83 ef 01             	sub    $0x1,%edi
f0105b25:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105b28:	fd                   	std    
f0105b29:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105b2b:	fc                   	cld    
f0105b2c:	eb 1a                	jmp    f0105b48 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105b2e:	89 c2                	mov    %eax,%edx
f0105b30:	09 ca                	or     %ecx,%edx
f0105b32:	09 f2                	or     %esi,%edx
f0105b34:	f6 c2 03             	test   $0x3,%dl
f0105b37:	75 0a                	jne    f0105b43 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0105b39:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105b3c:	89 c7                	mov    %eax,%edi
f0105b3e:	fc                   	cld    
f0105b3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105b41:	eb 05                	jmp    f0105b48 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
f0105b43:	89 c7                	mov    %eax,%edi
f0105b45:	fc                   	cld    
f0105b46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105b48:	5e                   	pop    %esi
f0105b49:	5f                   	pop    %edi
f0105b4a:	5d                   	pop    %ebp
f0105b4b:	c3                   	ret    

f0105b4c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105b4c:	f3 0f 1e fb          	endbr32 
f0105b50:	55                   	push   %ebp
f0105b51:	89 e5                	mov    %esp,%ebp
f0105b53:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0105b56:	ff 75 10             	pushl  0x10(%ebp)
f0105b59:	ff 75 0c             	pushl  0xc(%ebp)
f0105b5c:	ff 75 08             	pushl  0x8(%ebp)
f0105b5f:	e8 82 ff ff ff       	call   f0105ae6 <memmove>
}
f0105b64:	c9                   	leave  
f0105b65:	c3                   	ret    

f0105b66 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105b66:	f3 0f 1e fb          	endbr32 
f0105b6a:	55                   	push   %ebp
f0105b6b:	89 e5                	mov    %esp,%ebp
f0105b6d:	56                   	push   %esi
f0105b6e:	53                   	push   %ebx
f0105b6f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b72:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105b75:	89 c6                	mov    %eax,%esi
f0105b77:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105b7a:	39 f0                	cmp    %esi,%eax
f0105b7c:	74 1c                	je     f0105b9a <memcmp+0x34>
		if (*s1 != *s2)
f0105b7e:	0f b6 08             	movzbl (%eax),%ecx
f0105b81:	0f b6 1a             	movzbl (%edx),%ebx
f0105b84:	38 d9                	cmp    %bl,%cl
f0105b86:	75 08                	jne    f0105b90 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0105b88:	83 c0 01             	add    $0x1,%eax
f0105b8b:	83 c2 01             	add    $0x1,%edx
f0105b8e:	eb ea                	jmp    f0105b7a <memcmp+0x14>
			return (int) *s1 - (int) *s2;
f0105b90:	0f b6 c1             	movzbl %cl,%eax
f0105b93:	0f b6 db             	movzbl %bl,%ebx
f0105b96:	29 d8                	sub    %ebx,%eax
f0105b98:	eb 05                	jmp    f0105b9f <memcmp+0x39>
	}

	return 0;
f0105b9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105b9f:	5b                   	pop    %ebx
f0105ba0:	5e                   	pop    %esi
f0105ba1:	5d                   	pop    %ebp
f0105ba2:	c3                   	ret    

f0105ba3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0105ba3:	f3 0f 1e fb          	endbr32 
f0105ba7:	55                   	push   %ebp
f0105ba8:	89 e5                	mov    %esp,%ebp
f0105baa:	8b 45 08             	mov    0x8(%ebp),%eax
f0105bad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0105bb0:	89 c2                	mov    %eax,%edx
f0105bb2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0105bb5:	39 d0                	cmp    %edx,%eax
f0105bb7:	73 09                	jae    f0105bc2 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
f0105bb9:	38 08                	cmp    %cl,(%eax)
f0105bbb:	74 05                	je     f0105bc2 <memfind+0x1f>
	for (; s < ends; s++)
f0105bbd:	83 c0 01             	add    $0x1,%eax
f0105bc0:	eb f3                	jmp    f0105bb5 <memfind+0x12>
			break;
	return (void *) s;
}
f0105bc2:	5d                   	pop    %ebp
f0105bc3:	c3                   	ret    

f0105bc4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0105bc4:	f3 0f 1e fb          	endbr32 
f0105bc8:	55                   	push   %ebp
f0105bc9:	89 e5                	mov    %esp,%ebp
f0105bcb:	57                   	push   %edi
f0105bcc:	56                   	push   %esi
f0105bcd:	53                   	push   %ebx
f0105bce:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105bd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0105bd4:	eb 03                	jmp    f0105bd9 <strtol+0x15>
		s++;
f0105bd6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0105bd9:	0f b6 01             	movzbl (%ecx),%eax
f0105bdc:	3c 20                	cmp    $0x20,%al
f0105bde:	74 f6                	je     f0105bd6 <strtol+0x12>
f0105be0:	3c 09                	cmp    $0x9,%al
f0105be2:	74 f2                	je     f0105bd6 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
f0105be4:	3c 2b                	cmp    $0x2b,%al
f0105be6:	74 2a                	je     f0105c12 <strtol+0x4e>
	int neg = 0;
f0105be8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0105bed:	3c 2d                	cmp    $0x2d,%al
f0105bef:	74 2b                	je     f0105c1c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105bf1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0105bf7:	75 0f                	jne    f0105c08 <strtol+0x44>
f0105bf9:	80 39 30             	cmpb   $0x30,(%ecx)
f0105bfc:	74 28                	je     f0105c26 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0105bfe:	85 db                	test   %ebx,%ebx
f0105c00:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105c05:	0f 44 d8             	cmove  %eax,%ebx
f0105c08:	b8 00 00 00 00       	mov    $0x0,%eax
f0105c0d:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105c10:	eb 46                	jmp    f0105c58 <strtol+0x94>
		s++;
f0105c12:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105c15:	bf 00 00 00 00       	mov    $0x0,%edi
f0105c1a:	eb d5                	jmp    f0105bf1 <strtol+0x2d>
		s++, neg = 1;
f0105c1c:	83 c1 01             	add    $0x1,%ecx
f0105c1f:	bf 01 00 00 00       	mov    $0x1,%edi
f0105c24:	eb cb                	jmp    f0105bf1 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105c26:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105c2a:	74 0e                	je     f0105c3a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105c2c:	85 db                	test   %ebx,%ebx
f0105c2e:	75 d8                	jne    f0105c08 <strtol+0x44>
		s++, base = 8;
f0105c30:	83 c1 01             	add    $0x1,%ecx
f0105c33:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105c38:	eb ce                	jmp    f0105c08 <strtol+0x44>
		s += 2, base = 16;
f0105c3a:	83 c1 02             	add    $0x2,%ecx
f0105c3d:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105c42:	eb c4                	jmp    f0105c08 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0105c44:	0f be d2             	movsbl %dl,%edx
f0105c47:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105c4a:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105c4d:	7d 3a                	jge    f0105c89 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105c4f:	83 c1 01             	add    $0x1,%ecx
f0105c52:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105c56:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105c58:	0f b6 11             	movzbl (%ecx),%edx
f0105c5b:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105c5e:	89 f3                	mov    %esi,%ebx
f0105c60:	80 fb 09             	cmp    $0x9,%bl
f0105c63:	76 df                	jbe    f0105c44 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
f0105c65:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105c68:	89 f3                	mov    %esi,%ebx
f0105c6a:	80 fb 19             	cmp    $0x19,%bl
f0105c6d:	77 08                	ja     f0105c77 <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105c6f:	0f be d2             	movsbl %dl,%edx
f0105c72:	83 ea 57             	sub    $0x57,%edx
f0105c75:	eb d3                	jmp    f0105c4a <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
f0105c77:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105c7a:	89 f3                	mov    %esi,%ebx
f0105c7c:	80 fb 19             	cmp    $0x19,%bl
f0105c7f:	77 08                	ja     f0105c89 <strtol+0xc5>
			dig = *s - 'A' + 10;
f0105c81:	0f be d2             	movsbl %dl,%edx
f0105c84:	83 ea 37             	sub    $0x37,%edx
f0105c87:	eb c1                	jmp    f0105c4a <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105c89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0105c8d:	74 05                	je     f0105c94 <strtol+0xd0>
		*endptr = (char *) s;
f0105c8f:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105c92:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0105c94:	89 c2                	mov    %eax,%edx
f0105c96:	f7 da                	neg    %edx
f0105c98:	85 ff                	test   %edi,%edi
f0105c9a:	0f 45 c2             	cmovne %edx,%eax
}
f0105c9d:	5b                   	pop    %ebx
f0105c9e:	5e                   	pop    %esi
f0105c9f:	5f                   	pop    %edi
f0105ca0:	5d                   	pop    %ebp
f0105ca1:	c3                   	ret    
f0105ca2:	66 90                	xchg   %ax,%ax

f0105ca4 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0105ca4:	fa                   	cli    

	xorw    %ax, %ax
f0105ca5:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0105ca7:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105ca9:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105cab:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0105cad:	0f 01 16             	lgdtl  (%esi)
f0105cb0:	74 70                	je     f0105d22 <mpsearch1+0x3>
	movl    %cr0, %eax
f0105cb2:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0105cb5:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0105cb9:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0105cbc:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0105cc2:	08 00                	or     %al,(%eax)

f0105cc4 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0105cc4:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0105cc8:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105cca:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105ccc:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0105cce:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0105cd2:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0105cd4:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0105cd6:	b8 00 10 12 00       	mov    $0x121000,%eax
	movl    %eax, %cr3
f0105cdb:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0105cde:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0105ce1:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0105ce6:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0105ce9:	8b 25 84 7e 23 f0    	mov    0xf0237e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105cef:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105cf4:	b8 a9 01 10 f0       	mov    $0xf01001a9,%eax
	call    *%eax
f0105cf9:	ff d0                	call   *%eax

f0105cfb <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105cfb:	eb fe                	jmp    f0105cfb <spin>
f0105cfd:	8d 76 00             	lea    0x0(%esi),%esi

f0105d00 <gdt>:
	...
f0105d08:	ff                   	(bad)  
f0105d09:	ff 00                	incl   (%eax)
f0105d0b:	00 00                	add    %al,(%eax)
f0105d0d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105d14:	00                   	.byte 0x0
f0105d15:	92                   	xchg   %eax,%edx
f0105d16:	cf                   	iret   
	...

f0105d18 <gdtdesc>:
f0105d18:	17                   	pop    %ss
f0105d19:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0105d1e <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105d1e:	90                   	nop

f0105d1f <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105d1f:	55                   	push   %ebp
f0105d20:	89 e5                	mov    %esp,%ebp
f0105d22:	57                   	push   %edi
f0105d23:	56                   	push   %esi
f0105d24:	53                   	push   %ebx
f0105d25:	83 ec 0c             	sub    $0xc,%esp
f0105d28:	89 c7                	mov    %eax,%edi
	if (PGNUM(pa) >= npages)
f0105d2a:	a1 88 7e 23 f0       	mov    0xf0237e88,%eax
f0105d2f:	89 f9                	mov    %edi,%ecx
f0105d31:	c1 e9 0c             	shr    $0xc,%ecx
f0105d34:	39 c1                	cmp    %eax,%ecx
f0105d36:	73 19                	jae    f0105d51 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0105d38:	8d 9f 00 00 00 f0    	lea    -0x10000000(%edi),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105d3e:	01 d7                	add    %edx,%edi
	if (PGNUM(pa) >= npages)
f0105d40:	89 fa                	mov    %edi,%edx
f0105d42:	c1 ea 0c             	shr    $0xc,%edx
f0105d45:	39 c2                	cmp    %eax,%edx
f0105d47:	73 1a                	jae    f0105d63 <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105d49:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0105d4f:	eb 27                	jmp    f0105d78 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105d51:	57                   	push   %edi
f0105d52:	68 64 67 10 f0       	push   $0xf0106764
f0105d57:	6a 57                	push   $0x57
f0105d59:	68 a1 83 10 f0       	push   $0xf01083a1
f0105d5e:	e8 dd a2 ff ff       	call   f0100040 <_panic>
f0105d63:	57                   	push   %edi
f0105d64:	68 64 67 10 f0       	push   $0xf0106764
f0105d69:	6a 57                	push   $0x57
f0105d6b:	68 a1 83 10 f0       	push   $0xf01083a1
f0105d70:	e8 cb a2 ff ff       	call   f0100040 <_panic>
f0105d75:	83 c3 10             	add    $0x10,%ebx
f0105d78:	39 fb                	cmp    %edi,%ebx
f0105d7a:	73 30                	jae    f0105dac <mpsearch1+0x8d>
f0105d7c:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105d7e:	83 ec 04             	sub    $0x4,%esp
f0105d81:	6a 04                	push   $0x4
f0105d83:	68 b1 83 10 f0       	push   $0xf01083b1
f0105d88:	53                   	push   %ebx
f0105d89:	e8 d8 fd ff ff       	call   f0105b66 <memcmp>
f0105d8e:	83 c4 10             	add    $0x10,%esp
f0105d91:	85 c0                	test   %eax,%eax
f0105d93:	75 e0                	jne    f0105d75 <mpsearch1+0x56>
f0105d95:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0105d97:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0105d9a:	0f b6 0a             	movzbl (%edx),%ecx
f0105d9d:	01 c8                	add    %ecx,%eax
f0105d9f:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0105da2:	39 f2                	cmp    %esi,%edx
f0105da4:	75 f4                	jne    f0105d9a <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105da6:	84 c0                	test   %al,%al
f0105da8:	75 cb                	jne    f0105d75 <mpsearch1+0x56>
f0105daa:	eb 05                	jmp    f0105db1 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0105dac:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105db1:	89 d8                	mov    %ebx,%eax
f0105db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105db6:	5b                   	pop    %ebx
f0105db7:	5e                   	pop    %esi
f0105db8:	5f                   	pop    %edi
f0105db9:	5d                   	pop    %ebp
f0105dba:	c3                   	ret    

f0105dbb <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0105dbb:	f3 0f 1e fb          	endbr32 
f0105dbf:	55                   	push   %ebp
f0105dc0:	89 e5                	mov    %esp,%ebp
f0105dc2:	57                   	push   %edi
f0105dc3:	56                   	push   %esi
f0105dc4:	53                   	push   %ebx
f0105dc5:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105dc8:	c7 05 c0 83 23 f0 20 	movl   $0xf0238020,0xf02383c0
f0105dcf:	80 23 f0 
	if (PGNUM(pa) >= npages)
f0105dd2:	83 3d 88 7e 23 f0 00 	cmpl   $0x0,0xf0237e88
f0105dd9:	0f 84 a3 00 00 00    	je     f0105e82 <mp_init+0xc7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0105ddf:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0105de6:	85 c0                	test   %eax,%eax
f0105de8:	0f 84 aa 00 00 00    	je     f0105e98 <mp_init+0xdd>
		p <<= 4;	// Translate from segment to PA
f0105dee:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0105df1:	ba 00 04 00 00       	mov    $0x400,%edx
f0105df6:	e8 24 ff ff ff       	call   f0105d1f <mpsearch1>
f0105dfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105dfe:	85 c0                	test   %eax,%eax
f0105e00:	75 1a                	jne    f0105e1c <mp_init+0x61>
	return mpsearch1(0xF0000, 0x10000);
f0105e02:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105e07:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105e0c:	e8 0e ff ff ff       	call   f0105d1f <mpsearch1>
f0105e11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0105e14:	85 c0                	test   %eax,%eax
f0105e16:	0f 84 35 02 00 00    	je     f0106051 <mp_init+0x296>
	if (mp->physaddr == 0 || mp->type != 0) {
f0105e1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105e1f:	8b 58 04             	mov    0x4(%eax),%ebx
f0105e22:	85 db                	test   %ebx,%ebx
f0105e24:	0f 84 97 00 00 00    	je     f0105ec1 <mp_init+0x106>
f0105e2a:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0105e2e:	0f 85 8d 00 00 00    	jne    f0105ec1 <mp_init+0x106>
f0105e34:	89 d8                	mov    %ebx,%eax
f0105e36:	c1 e8 0c             	shr    $0xc,%eax
f0105e39:	3b 05 88 7e 23 f0    	cmp    0xf0237e88,%eax
f0105e3f:	0f 83 91 00 00 00    	jae    f0105ed6 <mp_init+0x11b>
	return (void *)(pa + KERNBASE);
f0105e45:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0105e4b:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105e4d:	83 ec 04             	sub    $0x4,%esp
f0105e50:	6a 04                	push   $0x4
f0105e52:	68 b6 83 10 f0       	push   $0xf01083b6
f0105e57:	53                   	push   %ebx
f0105e58:	e8 09 fd ff ff       	call   f0105b66 <memcmp>
f0105e5d:	83 c4 10             	add    $0x10,%esp
f0105e60:	85 c0                	test   %eax,%eax
f0105e62:	0f 85 83 00 00 00    	jne    f0105eeb <mp_init+0x130>
f0105e68:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105e6c:	01 df                	add    %ebx,%edi
	sum = 0;
f0105e6e:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0105e70:	39 fb                	cmp    %edi,%ebx
f0105e72:	0f 84 88 00 00 00    	je     f0105f00 <mp_init+0x145>
		sum += ((uint8_t *)addr)[i];
f0105e78:	0f b6 0b             	movzbl (%ebx),%ecx
f0105e7b:	01 ca                	add    %ecx,%edx
f0105e7d:	83 c3 01             	add    $0x1,%ebx
f0105e80:	eb ee                	jmp    f0105e70 <mp_init+0xb5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105e82:	68 00 04 00 00       	push   $0x400
f0105e87:	68 64 67 10 f0       	push   $0xf0106764
f0105e8c:	6a 6f                	push   $0x6f
f0105e8e:	68 a1 83 10 f0       	push   $0xf01083a1
f0105e93:	e8 a8 a1 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105e98:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105e9f:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105ea2:	2d 00 04 00 00       	sub    $0x400,%eax
f0105ea7:	ba 00 04 00 00       	mov    $0x400,%edx
f0105eac:	e8 6e fe ff ff       	call   f0105d1f <mpsearch1>
f0105eb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105eb4:	85 c0                	test   %eax,%eax
f0105eb6:	0f 85 60 ff ff ff    	jne    f0105e1c <mp_init+0x61>
f0105ebc:	e9 41 ff ff ff       	jmp    f0105e02 <mp_init+0x47>
		cprintf("SMP: Default configurations not implemented\n");
f0105ec1:	83 ec 0c             	sub    $0xc,%esp
f0105ec4:	68 14 82 10 f0       	push   $0xf0108214
f0105ec9:	e8 61 db ff ff       	call   f0103a2f <cprintf>
		return NULL;
f0105ece:	83 c4 10             	add    $0x10,%esp
f0105ed1:	e9 7b 01 00 00       	jmp    f0106051 <mp_init+0x296>
f0105ed6:	53                   	push   %ebx
f0105ed7:	68 64 67 10 f0       	push   $0xf0106764
f0105edc:	68 90 00 00 00       	push   $0x90
f0105ee1:	68 a1 83 10 f0       	push   $0xf01083a1
f0105ee6:	e8 55 a1 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0105eeb:	83 ec 0c             	sub    $0xc,%esp
f0105eee:	68 44 82 10 f0       	push   $0xf0108244
f0105ef3:	e8 37 db ff ff       	call   f0103a2f <cprintf>
		return NULL;
f0105ef8:	83 c4 10             	add    $0x10,%esp
f0105efb:	e9 51 01 00 00       	jmp    f0106051 <mp_init+0x296>
	if (sum(conf, conf->length) != 0) {
f0105f00:	84 d2                	test   %dl,%dl
f0105f02:	75 22                	jne    f0105f26 <mp_init+0x16b>
	if (conf->version != 1 && conf->version != 4) {
f0105f04:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0105f08:	80 fa 01             	cmp    $0x1,%dl
f0105f0b:	74 05                	je     f0105f12 <mp_init+0x157>
f0105f0d:	80 fa 04             	cmp    $0x4,%dl
f0105f10:	75 29                	jne    f0105f3b <mp_init+0x180>
f0105f12:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105f16:	01 d9                	add    %ebx,%ecx
	for (i = 0; i < len; i++)
f0105f18:	39 d9                	cmp    %ebx,%ecx
f0105f1a:	74 38                	je     f0105f54 <mp_init+0x199>
		sum += ((uint8_t *)addr)[i];
f0105f1c:	0f b6 13             	movzbl (%ebx),%edx
f0105f1f:	01 d0                	add    %edx,%eax
f0105f21:	83 c3 01             	add    $0x1,%ebx
f0105f24:	eb f2                	jmp    f0105f18 <mp_init+0x15d>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105f26:	83 ec 0c             	sub    $0xc,%esp
f0105f29:	68 78 82 10 f0       	push   $0xf0108278
f0105f2e:	e8 fc da ff ff       	call   f0103a2f <cprintf>
		return NULL;
f0105f33:	83 c4 10             	add    $0x10,%esp
f0105f36:	e9 16 01 00 00       	jmp    f0106051 <mp_init+0x296>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105f3b:	83 ec 08             	sub    $0x8,%esp
f0105f3e:	0f b6 d2             	movzbl %dl,%edx
f0105f41:	52                   	push   %edx
f0105f42:	68 9c 82 10 f0       	push   $0xf010829c
f0105f47:	e8 e3 da ff ff       	call   f0103a2f <cprintf>
		return NULL;
f0105f4c:	83 c4 10             	add    $0x10,%esp
f0105f4f:	e9 fd 00 00 00       	jmp    f0106051 <mp_init+0x296>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105f54:	02 46 2a             	add    0x2a(%esi),%al
f0105f57:	75 1c                	jne    f0105f75 <mp_init+0x1ba>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0105f59:	c7 05 00 80 23 f0 01 	movl   $0x1,0xf0238000
f0105f60:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105f63:	8b 46 24             	mov    0x24(%esi),%eax
f0105f66:	a3 00 90 27 f0       	mov    %eax,0xf0279000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105f6b:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0105f6e:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105f73:	eb 4d                	jmp    f0105fc2 <mp_init+0x207>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105f75:	83 ec 0c             	sub    $0xc,%esp
f0105f78:	68 bc 82 10 f0       	push   $0xf01082bc
f0105f7d:	e8 ad da ff ff       	call   f0103a2f <cprintf>
		return NULL;
f0105f82:	83 c4 10             	add    $0x10,%esp
f0105f85:	e9 c7 00 00 00       	jmp    f0106051 <mp_init+0x296>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105f8a:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0105f8e:	74 11                	je     f0105fa1 <mp_init+0x1e6>
				bootcpu = &cpus[ncpu];
f0105f90:	6b 05 c4 83 23 f0 74 	imul   $0x74,0xf02383c4,%eax
f0105f97:	05 20 80 23 f0       	add    $0xf0238020,%eax
f0105f9c:	a3 c0 83 23 f0       	mov    %eax,0xf02383c0
			if (ncpu < NCPU) {
f0105fa1:	a1 c4 83 23 f0       	mov    0xf02383c4,%eax
f0105fa6:	83 f8 07             	cmp    $0x7,%eax
f0105fa9:	7f 33                	jg     f0105fde <mp_init+0x223>
				cpus[ncpu].cpu_id = ncpu;
f0105fab:	6b d0 74             	imul   $0x74,%eax,%edx
f0105fae:	88 82 20 80 23 f0    	mov    %al,-0xfdc7fe0(%edx)
				ncpu++;
f0105fb4:	83 c0 01             	add    $0x1,%eax
f0105fb7:	a3 c4 83 23 f0       	mov    %eax,0xf02383c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105fbc:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105fbf:	83 c3 01             	add    $0x1,%ebx
f0105fc2:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0105fc6:	39 d8                	cmp    %ebx,%eax
f0105fc8:	76 4f                	jbe    f0106019 <mp_init+0x25e>
		switch (*p) {
f0105fca:	0f b6 07             	movzbl (%edi),%eax
f0105fcd:	84 c0                	test   %al,%al
f0105fcf:	74 b9                	je     f0105f8a <mp_init+0x1cf>
f0105fd1:	8d 50 ff             	lea    -0x1(%eax),%edx
f0105fd4:	80 fa 03             	cmp    $0x3,%dl
f0105fd7:	77 1c                	ja     f0105ff5 <mp_init+0x23a>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105fd9:	83 c7 08             	add    $0x8,%edi
			continue;
f0105fdc:	eb e1                	jmp    f0105fbf <mp_init+0x204>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105fde:	83 ec 08             	sub    $0x8,%esp
f0105fe1:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0105fe5:	50                   	push   %eax
f0105fe6:	68 ec 82 10 f0       	push   $0xf01082ec
f0105feb:	e8 3f da ff ff       	call   f0103a2f <cprintf>
f0105ff0:	83 c4 10             	add    $0x10,%esp
f0105ff3:	eb c7                	jmp    f0105fbc <mp_init+0x201>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105ff5:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0105ff8:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0105ffb:	50                   	push   %eax
f0105ffc:	68 14 83 10 f0       	push   $0xf0108314
f0106001:	e8 29 da ff ff       	call   f0103a2f <cprintf>
			ismp = 0;
f0106006:	c7 05 00 80 23 f0 00 	movl   $0x0,0xf0238000
f010600d:	00 00 00 
			i = conf->entry;
f0106010:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106014:	83 c4 10             	add    $0x10,%esp
f0106017:	eb a6                	jmp    f0105fbf <mp_init+0x204>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106019:	a1 c0 83 23 f0       	mov    0xf02383c0,%eax
f010601e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106025:	83 3d 00 80 23 f0 00 	cmpl   $0x0,0xf0238000
f010602c:	74 2b                	je     f0106059 <mp_init+0x29e>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f010602e:	83 ec 04             	sub    $0x4,%esp
f0106031:	ff 35 c4 83 23 f0    	pushl  0xf02383c4
f0106037:	0f b6 00             	movzbl (%eax),%eax
f010603a:	50                   	push   %eax
f010603b:	68 bb 83 10 f0       	push   $0xf01083bb
f0106040:	e8 ea d9 ff ff       	call   f0103a2f <cprintf>

	if (mp->imcrp) {
f0106045:	83 c4 10             	add    $0x10,%esp
f0106048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010604b:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f010604f:	75 2e                	jne    f010607f <mp_init+0x2c4>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106051:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106054:	5b                   	pop    %ebx
f0106055:	5e                   	pop    %esi
f0106056:	5f                   	pop    %edi
f0106057:	5d                   	pop    %ebp
f0106058:	c3                   	ret    
		ncpu = 1;
f0106059:	c7 05 c4 83 23 f0 01 	movl   $0x1,0xf02383c4
f0106060:	00 00 00 
		lapicaddr = 0;
f0106063:	c7 05 00 90 27 f0 00 	movl   $0x0,0xf0279000
f010606a:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f010606d:	83 ec 0c             	sub    $0xc,%esp
f0106070:	68 34 83 10 f0       	push   $0xf0108334
f0106075:	e8 b5 d9 ff ff       	call   f0103a2f <cprintf>
		return;
f010607a:	83 c4 10             	add    $0x10,%esp
f010607d:	eb d2                	jmp    f0106051 <mp_init+0x296>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f010607f:	83 ec 0c             	sub    $0xc,%esp
f0106082:	68 60 83 10 f0       	push   $0xf0108360
f0106087:	e8 a3 d9 ff ff       	call   f0103a2f <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010608c:	b8 70 00 00 00       	mov    $0x70,%eax
f0106091:	ba 22 00 00 00       	mov    $0x22,%edx
f0106096:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106097:	ba 23 00 00 00       	mov    $0x23,%edx
f010609c:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f010609d:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01060a0:	ee                   	out    %al,(%dx)
}
f01060a1:	83 c4 10             	add    $0x10,%esp
f01060a4:	eb ab                	jmp    f0106051 <mp_init+0x296>

f01060a6 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f01060a6:	8b 0d 04 90 27 f0    	mov    0xf0279004,%ecx
f01060ac:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f01060af:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f01060b1:	a1 04 90 27 f0       	mov    0xf0279004,%eax
f01060b6:	8b 40 20             	mov    0x20(%eax),%eax
}
f01060b9:	c3                   	ret    

f01060ba <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f01060ba:	f3 0f 1e fb          	endbr32 
	if (lapic)
f01060be:	8b 15 04 90 27 f0    	mov    0xf0279004,%edx
		return lapic[ID] >> 24;
	return 0;
f01060c4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f01060c9:	85 d2                	test   %edx,%edx
f01060cb:	74 06                	je     f01060d3 <cpunum+0x19>
		return lapic[ID] >> 24;
f01060cd:	8b 42 20             	mov    0x20(%edx),%eax
f01060d0:	c1 e8 18             	shr    $0x18,%eax
}
f01060d3:	c3                   	ret    

f01060d4 <lapic_init>:
{
f01060d4:	f3 0f 1e fb          	endbr32 
	if (!lapicaddr)
f01060d8:	a1 00 90 27 f0       	mov    0xf0279000,%eax
f01060dd:	85 c0                	test   %eax,%eax
f01060df:	75 01                	jne    f01060e2 <lapic_init+0xe>
f01060e1:	c3                   	ret    
{
f01060e2:	55                   	push   %ebp
f01060e3:	89 e5                	mov    %esp,%ebp
f01060e5:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f01060e8:	68 00 10 00 00       	push   $0x1000
f01060ed:	50                   	push   %eax
f01060ee:	e8 95 b2 ff ff       	call   f0101388 <mmio_map_region>
f01060f3:	a3 04 90 27 f0       	mov    %eax,0xf0279004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f01060f8:	ba 27 01 00 00       	mov    $0x127,%edx
f01060fd:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106102:	e8 9f ff ff ff       	call   f01060a6 <lapicw>
	lapicw(TDCR, X1);
f0106107:	ba 0b 00 00 00       	mov    $0xb,%edx
f010610c:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106111:	e8 90 ff ff ff       	call   f01060a6 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106116:	ba 20 00 02 00       	mov    $0x20020,%edx
f010611b:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106120:	e8 81 ff ff ff       	call   f01060a6 <lapicw>
	lapicw(TICR, 10000000); 
f0106125:	ba 80 96 98 00       	mov    $0x989680,%edx
f010612a:	b8 e0 00 00 00       	mov    $0xe0,%eax
f010612f:	e8 72 ff ff ff       	call   f01060a6 <lapicw>
	if (thiscpu != bootcpu)
f0106134:	e8 81 ff ff ff       	call   f01060ba <cpunum>
f0106139:	6b c0 74             	imul   $0x74,%eax,%eax
f010613c:	05 20 80 23 f0       	add    $0xf0238020,%eax
f0106141:	83 c4 10             	add    $0x10,%esp
f0106144:	39 05 c0 83 23 f0    	cmp    %eax,0xf02383c0
f010614a:	74 0f                	je     f010615b <lapic_init+0x87>
		lapicw(LINT0, MASKED);
f010614c:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106151:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106156:	e8 4b ff ff ff       	call   f01060a6 <lapicw>
	lapicw(LINT1, MASKED);
f010615b:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106160:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106165:	e8 3c ff ff ff       	call   f01060a6 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f010616a:	a1 04 90 27 f0       	mov    0xf0279004,%eax
f010616f:	8b 40 30             	mov    0x30(%eax),%eax
f0106172:	c1 e8 10             	shr    $0x10,%eax
f0106175:	a8 fc                	test   $0xfc,%al
f0106177:	75 7c                	jne    f01061f5 <lapic_init+0x121>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106179:	ba 33 00 00 00       	mov    $0x33,%edx
f010617e:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106183:	e8 1e ff ff ff       	call   f01060a6 <lapicw>
	lapicw(ESR, 0);
f0106188:	ba 00 00 00 00       	mov    $0x0,%edx
f010618d:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106192:	e8 0f ff ff ff       	call   f01060a6 <lapicw>
	lapicw(ESR, 0);
f0106197:	ba 00 00 00 00       	mov    $0x0,%edx
f010619c:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01061a1:	e8 00 ff ff ff       	call   f01060a6 <lapicw>
	lapicw(EOI, 0);
f01061a6:	ba 00 00 00 00       	mov    $0x0,%edx
f01061ab:	b8 2c 00 00 00       	mov    $0x2c,%eax
f01061b0:	e8 f1 fe ff ff       	call   f01060a6 <lapicw>
	lapicw(ICRHI, 0);
f01061b5:	ba 00 00 00 00       	mov    $0x0,%edx
f01061ba:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01061bf:	e8 e2 fe ff ff       	call   f01060a6 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f01061c4:	ba 00 85 08 00       	mov    $0x88500,%edx
f01061c9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01061ce:	e8 d3 fe ff ff       	call   f01060a6 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f01061d3:	8b 15 04 90 27 f0    	mov    0xf0279004,%edx
f01061d9:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f01061df:	f6 c4 10             	test   $0x10,%ah
f01061e2:	75 f5                	jne    f01061d9 <lapic_init+0x105>
	lapicw(TPR, 0);
f01061e4:	ba 00 00 00 00       	mov    $0x0,%edx
f01061e9:	b8 20 00 00 00       	mov    $0x20,%eax
f01061ee:	e8 b3 fe ff ff       	call   f01060a6 <lapicw>
}
f01061f3:	c9                   	leave  
f01061f4:	c3                   	ret    
		lapicw(PCINT, MASKED);
f01061f5:	ba 00 00 01 00       	mov    $0x10000,%edx
f01061fa:	b8 d0 00 00 00       	mov    $0xd0,%eax
f01061ff:	e8 a2 fe ff ff       	call   f01060a6 <lapicw>
f0106204:	e9 70 ff ff ff       	jmp    f0106179 <lapic_init+0xa5>

f0106209 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f0106209:	f3 0f 1e fb          	endbr32 
	if (lapic)
f010620d:	83 3d 04 90 27 f0 00 	cmpl   $0x0,0xf0279004
f0106214:	74 17                	je     f010622d <lapic_eoi+0x24>
{
f0106216:	55                   	push   %ebp
f0106217:	89 e5                	mov    %esp,%ebp
f0106219:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f010621c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106221:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106226:	e8 7b fe ff ff       	call   f01060a6 <lapicw>
}
f010622b:	c9                   	leave  
f010622c:	c3                   	ret    
f010622d:	c3                   	ret    

f010622e <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f010622e:	f3 0f 1e fb          	endbr32 
f0106232:	55                   	push   %ebp
f0106233:	89 e5                	mov    %esp,%ebp
f0106235:	56                   	push   %esi
f0106236:	53                   	push   %ebx
f0106237:	8b 75 08             	mov    0x8(%ebp),%esi
f010623a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010623d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106242:	ba 70 00 00 00       	mov    $0x70,%edx
f0106247:	ee                   	out    %al,(%dx)
f0106248:	b8 0a 00 00 00       	mov    $0xa,%eax
f010624d:	ba 71 00 00 00       	mov    $0x71,%edx
f0106252:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106253:	83 3d 88 7e 23 f0 00 	cmpl   $0x0,0xf0237e88
f010625a:	74 7e                	je     f01062da <lapic_startap+0xac>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f010625c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106263:	00 00 
	wrv[1] = addr >> 4;
f0106265:	89 d8                	mov    %ebx,%eax
f0106267:	c1 e8 04             	shr    $0x4,%eax
f010626a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106270:	c1 e6 18             	shl    $0x18,%esi
f0106273:	89 f2                	mov    %esi,%edx
f0106275:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010627a:	e8 27 fe ff ff       	call   f01060a6 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f010627f:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106284:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106289:	e8 18 fe ff ff       	call   f01060a6 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f010628e:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106293:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106298:	e8 09 fe ff ff       	call   f01060a6 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010629d:	c1 eb 0c             	shr    $0xc,%ebx
f01062a0:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f01062a3:	89 f2                	mov    %esi,%edx
f01062a5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01062aa:	e8 f7 fd ff ff       	call   f01060a6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01062af:	89 da                	mov    %ebx,%edx
f01062b1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01062b6:	e8 eb fd ff ff       	call   f01060a6 <lapicw>
		lapicw(ICRHI, apicid << 24);
f01062bb:	89 f2                	mov    %esi,%edx
f01062bd:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01062c2:	e8 df fd ff ff       	call   f01060a6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01062c7:	89 da                	mov    %ebx,%edx
f01062c9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01062ce:	e8 d3 fd ff ff       	call   f01060a6 <lapicw>
		microdelay(200);
	}
}
f01062d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01062d6:	5b                   	pop    %ebx
f01062d7:	5e                   	pop    %esi
f01062d8:	5d                   	pop    %ebp
f01062d9:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01062da:	68 67 04 00 00       	push   $0x467
f01062df:	68 64 67 10 f0       	push   $0xf0106764
f01062e4:	68 98 00 00 00       	push   $0x98
f01062e9:	68 d8 83 10 f0       	push   $0xf01083d8
f01062ee:	e8 4d 9d ff ff       	call   f0100040 <_panic>

f01062f3 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f01062f3:	f3 0f 1e fb          	endbr32 
f01062f7:	55                   	push   %ebp
f01062f8:	89 e5                	mov    %esp,%ebp
f01062fa:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f01062fd:	8b 55 08             	mov    0x8(%ebp),%edx
f0106300:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106306:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010630b:	e8 96 fd ff ff       	call   f01060a6 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106310:	8b 15 04 90 27 f0    	mov    0xf0279004,%edx
f0106316:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010631c:	f6 c4 10             	test   $0x10,%ah
f010631f:	75 f5                	jne    f0106316 <lapic_ipi+0x23>
		;
}
f0106321:	c9                   	leave  
f0106322:	c3                   	ret    

f0106323 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106323:	f3 0f 1e fb          	endbr32 
f0106327:	55                   	push   %ebp
f0106328:	89 e5                	mov    %esp,%ebp
f010632a:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f010632d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106333:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106336:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106339:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106340:	5d                   	pop    %ebp
f0106341:	c3                   	ret    

f0106342 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106342:	f3 0f 1e fb          	endbr32 
f0106346:	55                   	push   %ebp
f0106347:	89 e5                	mov    %esp,%ebp
f0106349:	56                   	push   %esi
f010634a:	53                   	push   %ebx
f010634b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f010634e:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106351:	75 07                	jne    f010635a <spin_lock+0x18>
	asm volatile("lock; xchgl %0, %1"
f0106353:	ba 01 00 00 00       	mov    $0x1,%edx
f0106358:	eb 34                	jmp    f010638e <spin_lock+0x4c>
f010635a:	8b 73 08             	mov    0x8(%ebx),%esi
f010635d:	e8 58 fd ff ff       	call   f01060ba <cpunum>
f0106362:	6b c0 74             	imul   $0x74,%eax,%eax
f0106365:	05 20 80 23 f0       	add    $0xf0238020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f010636a:	39 c6                	cmp    %eax,%esi
f010636c:	75 e5                	jne    f0106353 <spin_lock+0x11>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f010636e:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106371:	e8 44 fd ff ff       	call   f01060ba <cpunum>
f0106376:	83 ec 0c             	sub    $0xc,%esp
f0106379:	53                   	push   %ebx
f010637a:	50                   	push   %eax
f010637b:	68 e8 83 10 f0       	push   $0xf01083e8
f0106380:	6a 41                	push   $0x41
f0106382:	68 4a 84 10 f0       	push   $0xf010844a
f0106387:	e8 b4 9c ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f010638c:	f3 90                	pause  
f010638e:	89 d0                	mov    %edx,%eax
f0106390:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f0106393:	85 c0                	test   %eax,%eax
f0106395:	75 f5                	jne    f010638c <spin_lock+0x4a>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106397:	e8 1e fd ff ff       	call   f01060ba <cpunum>
f010639c:	6b c0 74             	imul   $0x74,%eax,%eax
f010639f:	05 20 80 23 f0       	add    $0xf0238020,%eax
f01063a4:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01063a7:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f01063a9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01063ae:	83 f8 09             	cmp    $0x9,%eax
f01063b1:	7f 21                	jg     f01063d4 <spin_lock+0x92>
f01063b3:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f01063b9:	76 19                	jbe    f01063d4 <spin_lock+0x92>
		pcs[i] = ebp[1];          // saved %eip
f01063bb:	8b 4a 04             	mov    0x4(%edx),%ecx
f01063be:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f01063c2:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f01063c4:	83 c0 01             	add    $0x1,%eax
f01063c7:	eb e5                	jmp    f01063ae <spin_lock+0x6c>
		pcs[i] = 0;
f01063c9:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f01063d0:	00 
	for (; i < 10; i++)
f01063d1:	83 c0 01             	add    $0x1,%eax
f01063d4:	83 f8 09             	cmp    $0x9,%eax
f01063d7:	7e f0                	jle    f01063c9 <spin_lock+0x87>
	get_caller_pcs(lk->pcs);
#endif
}
f01063d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01063dc:	5b                   	pop    %ebx
f01063dd:	5e                   	pop    %esi
f01063de:	5d                   	pop    %ebp
f01063df:	c3                   	ret    

f01063e0 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f01063e0:	f3 0f 1e fb          	endbr32 
f01063e4:	55                   	push   %ebp
f01063e5:	89 e5                	mov    %esp,%ebp
f01063e7:	57                   	push   %edi
f01063e8:	56                   	push   %esi
f01063e9:	53                   	push   %ebx
f01063ea:	83 ec 4c             	sub    $0x4c,%esp
f01063ed:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f01063f0:	83 3e 00             	cmpl   $0x0,(%esi)
f01063f3:	75 35                	jne    f010642a <spin_unlock+0x4a>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f01063f5:	83 ec 04             	sub    $0x4,%esp
f01063f8:	6a 28                	push   $0x28
f01063fa:	8d 46 0c             	lea    0xc(%esi),%eax
f01063fd:	50                   	push   %eax
f01063fe:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106401:	53                   	push   %ebx
f0106402:	e8 df f6 ff ff       	call   f0105ae6 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106407:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f010640a:	0f b6 38             	movzbl (%eax),%edi
f010640d:	8b 76 04             	mov    0x4(%esi),%esi
f0106410:	e8 a5 fc ff ff       	call   f01060ba <cpunum>
f0106415:	57                   	push   %edi
f0106416:	56                   	push   %esi
f0106417:	50                   	push   %eax
f0106418:	68 14 84 10 f0       	push   $0xf0108414
f010641d:	e8 0d d6 ff ff       	call   f0103a2f <cprintf>
f0106422:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106425:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106428:	eb 4e                	jmp    f0106478 <spin_unlock+0x98>
	return lock->locked && lock->cpu == thiscpu;
f010642a:	8b 5e 08             	mov    0x8(%esi),%ebx
f010642d:	e8 88 fc ff ff       	call   f01060ba <cpunum>
f0106432:	6b c0 74             	imul   $0x74,%eax,%eax
f0106435:	05 20 80 23 f0       	add    $0xf0238020,%eax
	if (!holding(lk)) {
f010643a:	39 c3                	cmp    %eax,%ebx
f010643c:	75 b7                	jne    f01063f5 <spin_unlock+0x15>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f010643e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106445:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f010644c:	b8 00 00 00 00       	mov    $0x0,%eax
f0106451:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106454:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106457:	5b                   	pop    %ebx
f0106458:	5e                   	pop    %esi
f0106459:	5f                   	pop    %edi
f010645a:	5d                   	pop    %ebp
f010645b:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f010645c:	83 ec 08             	sub    $0x8,%esp
f010645f:	ff 36                	pushl  (%esi)
f0106461:	68 71 84 10 f0       	push   $0xf0108471
f0106466:	e8 c4 d5 ff ff       	call   f0103a2f <cprintf>
f010646b:	83 c4 10             	add    $0x10,%esp
f010646e:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106471:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106474:	39 c3                	cmp    %eax,%ebx
f0106476:	74 40                	je     f01064b8 <spin_unlock+0xd8>
f0106478:	89 de                	mov    %ebx,%esi
f010647a:	8b 03                	mov    (%ebx),%eax
f010647c:	85 c0                	test   %eax,%eax
f010647e:	74 38                	je     f01064b8 <spin_unlock+0xd8>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106480:	83 ec 08             	sub    $0x8,%esp
f0106483:	57                   	push   %edi
f0106484:	50                   	push   %eax
f0106485:	e8 cb ea ff ff       	call   f0104f55 <debuginfo_eip>
f010648a:	83 c4 10             	add    $0x10,%esp
f010648d:	85 c0                	test   %eax,%eax
f010648f:	78 cb                	js     f010645c <spin_unlock+0x7c>
					pcs[i] - info.eip_fn_addr);
f0106491:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106493:	83 ec 04             	sub    $0x4,%esp
f0106496:	89 c2                	mov    %eax,%edx
f0106498:	2b 55 b8             	sub    -0x48(%ebp),%edx
f010649b:	52                   	push   %edx
f010649c:	ff 75 b0             	pushl  -0x50(%ebp)
f010649f:	ff 75 b4             	pushl  -0x4c(%ebp)
f01064a2:	ff 75 ac             	pushl  -0x54(%ebp)
f01064a5:	ff 75 a8             	pushl  -0x58(%ebp)
f01064a8:	50                   	push   %eax
f01064a9:	68 5a 84 10 f0       	push   $0xf010845a
f01064ae:	e8 7c d5 ff ff       	call   f0103a2f <cprintf>
f01064b3:	83 c4 20             	add    $0x20,%esp
f01064b6:	eb b6                	jmp    f010646e <spin_unlock+0x8e>
		panic("spin_unlock");
f01064b8:	83 ec 04             	sub    $0x4,%esp
f01064bb:	68 79 84 10 f0       	push   $0xf0108479
f01064c0:	6a 67                	push   $0x67
f01064c2:	68 4a 84 10 f0       	push   $0xf010844a
f01064c7:	e8 74 9b ff ff       	call   f0100040 <_panic>
f01064cc:	66 90                	xchg   %ax,%ax
f01064ce:	66 90                	xchg   %ax,%ax

f01064d0 <__udivdi3>:
f01064d0:	f3 0f 1e fb          	endbr32 
f01064d4:	55                   	push   %ebp
f01064d5:	57                   	push   %edi
f01064d6:	56                   	push   %esi
f01064d7:	53                   	push   %ebx
f01064d8:	83 ec 1c             	sub    $0x1c,%esp
f01064db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f01064df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01064e3:	8b 74 24 34          	mov    0x34(%esp),%esi
f01064e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01064eb:	85 d2                	test   %edx,%edx
f01064ed:	75 19                	jne    f0106508 <__udivdi3+0x38>
f01064ef:	39 f3                	cmp    %esi,%ebx
f01064f1:	76 4d                	jbe    f0106540 <__udivdi3+0x70>
f01064f3:	31 ff                	xor    %edi,%edi
f01064f5:	89 e8                	mov    %ebp,%eax
f01064f7:	89 f2                	mov    %esi,%edx
f01064f9:	f7 f3                	div    %ebx
f01064fb:	89 fa                	mov    %edi,%edx
f01064fd:	83 c4 1c             	add    $0x1c,%esp
f0106500:	5b                   	pop    %ebx
f0106501:	5e                   	pop    %esi
f0106502:	5f                   	pop    %edi
f0106503:	5d                   	pop    %ebp
f0106504:	c3                   	ret    
f0106505:	8d 76 00             	lea    0x0(%esi),%esi
f0106508:	39 f2                	cmp    %esi,%edx
f010650a:	76 14                	jbe    f0106520 <__udivdi3+0x50>
f010650c:	31 ff                	xor    %edi,%edi
f010650e:	31 c0                	xor    %eax,%eax
f0106510:	89 fa                	mov    %edi,%edx
f0106512:	83 c4 1c             	add    $0x1c,%esp
f0106515:	5b                   	pop    %ebx
f0106516:	5e                   	pop    %esi
f0106517:	5f                   	pop    %edi
f0106518:	5d                   	pop    %ebp
f0106519:	c3                   	ret    
f010651a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106520:	0f bd fa             	bsr    %edx,%edi
f0106523:	83 f7 1f             	xor    $0x1f,%edi
f0106526:	75 48                	jne    f0106570 <__udivdi3+0xa0>
f0106528:	39 f2                	cmp    %esi,%edx
f010652a:	72 06                	jb     f0106532 <__udivdi3+0x62>
f010652c:	31 c0                	xor    %eax,%eax
f010652e:	39 eb                	cmp    %ebp,%ebx
f0106530:	77 de                	ja     f0106510 <__udivdi3+0x40>
f0106532:	b8 01 00 00 00       	mov    $0x1,%eax
f0106537:	eb d7                	jmp    f0106510 <__udivdi3+0x40>
f0106539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106540:	89 d9                	mov    %ebx,%ecx
f0106542:	85 db                	test   %ebx,%ebx
f0106544:	75 0b                	jne    f0106551 <__udivdi3+0x81>
f0106546:	b8 01 00 00 00       	mov    $0x1,%eax
f010654b:	31 d2                	xor    %edx,%edx
f010654d:	f7 f3                	div    %ebx
f010654f:	89 c1                	mov    %eax,%ecx
f0106551:	31 d2                	xor    %edx,%edx
f0106553:	89 f0                	mov    %esi,%eax
f0106555:	f7 f1                	div    %ecx
f0106557:	89 c6                	mov    %eax,%esi
f0106559:	89 e8                	mov    %ebp,%eax
f010655b:	89 f7                	mov    %esi,%edi
f010655d:	f7 f1                	div    %ecx
f010655f:	89 fa                	mov    %edi,%edx
f0106561:	83 c4 1c             	add    $0x1c,%esp
f0106564:	5b                   	pop    %ebx
f0106565:	5e                   	pop    %esi
f0106566:	5f                   	pop    %edi
f0106567:	5d                   	pop    %ebp
f0106568:	c3                   	ret    
f0106569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106570:	89 f9                	mov    %edi,%ecx
f0106572:	b8 20 00 00 00       	mov    $0x20,%eax
f0106577:	29 f8                	sub    %edi,%eax
f0106579:	d3 e2                	shl    %cl,%edx
f010657b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010657f:	89 c1                	mov    %eax,%ecx
f0106581:	89 da                	mov    %ebx,%edx
f0106583:	d3 ea                	shr    %cl,%edx
f0106585:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106589:	09 d1                	or     %edx,%ecx
f010658b:	89 f2                	mov    %esi,%edx
f010658d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106591:	89 f9                	mov    %edi,%ecx
f0106593:	d3 e3                	shl    %cl,%ebx
f0106595:	89 c1                	mov    %eax,%ecx
f0106597:	d3 ea                	shr    %cl,%edx
f0106599:	89 f9                	mov    %edi,%ecx
f010659b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010659f:	89 eb                	mov    %ebp,%ebx
f01065a1:	d3 e6                	shl    %cl,%esi
f01065a3:	89 c1                	mov    %eax,%ecx
f01065a5:	d3 eb                	shr    %cl,%ebx
f01065a7:	09 de                	or     %ebx,%esi
f01065a9:	89 f0                	mov    %esi,%eax
f01065ab:	f7 74 24 08          	divl   0x8(%esp)
f01065af:	89 d6                	mov    %edx,%esi
f01065b1:	89 c3                	mov    %eax,%ebx
f01065b3:	f7 64 24 0c          	mull   0xc(%esp)
f01065b7:	39 d6                	cmp    %edx,%esi
f01065b9:	72 15                	jb     f01065d0 <__udivdi3+0x100>
f01065bb:	89 f9                	mov    %edi,%ecx
f01065bd:	d3 e5                	shl    %cl,%ebp
f01065bf:	39 c5                	cmp    %eax,%ebp
f01065c1:	73 04                	jae    f01065c7 <__udivdi3+0xf7>
f01065c3:	39 d6                	cmp    %edx,%esi
f01065c5:	74 09                	je     f01065d0 <__udivdi3+0x100>
f01065c7:	89 d8                	mov    %ebx,%eax
f01065c9:	31 ff                	xor    %edi,%edi
f01065cb:	e9 40 ff ff ff       	jmp    f0106510 <__udivdi3+0x40>
f01065d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01065d3:	31 ff                	xor    %edi,%edi
f01065d5:	e9 36 ff ff ff       	jmp    f0106510 <__udivdi3+0x40>
f01065da:	66 90                	xchg   %ax,%ax
f01065dc:	66 90                	xchg   %ax,%ax
f01065de:	66 90                	xchg   %ax,%ax

f01065e0 <__umoddi3>:
f01065e0:	f3 0f 1e fb          	endbr32 
f01065e4:	55                   	push   %ebp
f01065e5:	57                   	push   %edi
f01065e6:	56                   	push   %esi
f01065e7:	53                   	push   %ebx
f01065e8:	83 ec 1c             	sub    $0x1c,%esp
f01065eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01065ef:	8b 74 24 30          	mov    0x30(%esp),%esi
f01065f3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01065f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01065fb:	85 c0                	test   %eax,%eax
f01065fd:	75 19                	jne    f0106618 <__umoddi3+0x38>
f01065ff:	39 df                	cmp    %ebx,%edi
f0106601:	76 5d                	jbe    f0106660 <__umoddi3+0x80>
f0106603:	89 f0                	mov    %esi,%eax
f0106605:	89 da                	mov    %ebx,%edx
f0106607:	f7 f7                	div    %edi
f0106609:	89 d0                	mov    %edx,%eax
f010660b:	31 d2                	xor    %edx,%edx
f010660d:	83 c4 1c             	add    $0x1c,%esp
f0106610:	5b                   	pop    %ebx
f0106611:	5e                   	pop    %esi
f0106612:	5f                   	pop    %edi
f0106613:	5d                   	pop    %ebp
f0106614:	c3                   	ret    
f0106615:	8d 76 00             	lea    0x0(%esi),%esi
f0106618:	89 f2                	mov    %esi,%edx
f010661a:	39 d8                	cmp    %ebx,%eax
f010661c:	76 12                	jbe    f0106630 <__umoddi3+0x50>
f010661e:	89 f0                	mov    %esi,%eax
f0106620:	89 da                	mov    %ebx,%edx
f0106622:	83 c4 1c             	add    $0x1c,%esp
f0106625:	5b                   	pop    %ebx
f0106626:	5e                   	pop    %esi
f0106627:	5f                   	pop    %edi
f0106628:	5d                   	pop    %ebp
f0106629:	c3                   	ret    
f010662a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106630:	0f bd e8             	bsr    %eax,%ebp
f0106633:	83 f5 1f             	xor    $0x1f,%ebp
f0106636:	75 50                	jne    f0106688 <__umoddi3+0xa8>
f0106638:	39 d8                	cmp    %ebx,%eax
f010663a:	0f 82 e0 00 00 00    	jb     f0106720 <__umoddi3+0x140>
f0106640:	89 d9                	mov    %ebx,%ecx
f0106642:	39 f7                	cmp    %esi,%edi
f0106644:	0f 86 d6 00 00 00    	jbe    f0106720 <__umoddi3+0x140>
f010664a:	89 d0                	mov    %edx,%eax
f010664c:	89 ca                	mov    %ecx,%edx
f010664e:	83 c4 1c             	add    $0x1c,%esp
f0106651:	5b                   	pop    %ebx
f0106652:	5e                   	pop    %esi
f0106653:	5f                   	pop    %edi
f0106654:	5d                   	pop    %ebp
f0106655:	c3                   	ret    
f0106656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010665d:	8d 76 00             	lea    0x0(%esi),%esi
f0106660:	89 fd                	mov    %edi,%ebp
f0106662:	85 ff                	test   %edi,%edi
f0106664:	75 0b                	jne    f0106671 <__umoddi3+0x91>
f0106666:	b8 01 00 00 00       	mov    $0x1,%eax
f010666b:	31 d2                	xor    %edx,%edx
f010666d:	f7 f7                	div    %edi
f010666f:	89 c5                	mov    %eax,%ebp
f0106671:	89 d8                	mov    %ebx,%eax
f0106673:	31 d2                	xor    %edx,%edx
f0106675:	f7 f5                	div    %ebp
f0106677:	89 f0                	mov    %esi,%eax
f0106679:	f7 f5                	div    %ebp
f010667b:	89 d0                	mov    %edx,%eax
f010667d:	31 d2                	xor    %edx,%edx
f010667f:	eb 8c                	jmp    f010660d <__umoddi3+0x2d>
f0106681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106688:	89 e9                	mov    %ebp,%ecx
f010668a:	ba 20 00 00 00       	mov    $0x20,%edx
f010668f:	29 ea                	sub    %ebp,%edx
f0106691:	d3 e0                	shl    %cl,%eax
f0106693:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106697:	89 d1                	mov    %edx,%ecx
f0106699:	89 f8                	mov    %edi,%eax
f010669b:	d3 e8                	shr    %cl,%eax
f010669d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f01066a1:	89 54 24 04          	mov    %edx,0x4(%esp)
f01066a5:	8b 54 24 04          	mov    0x4(%esp),%edx
f01066a9:	09 c1                	or     %eax,%ecx
f01066ab:	89 d8                	mov    %ebx,%eax
f01066ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01066b1:	89 e9                	mov    %ebp,%ecx
f01066b3:	d3 e7                	shl    %cl,%edi
f01066b5:	89 d1                	mov    %edx,%ecx
f01066b7:	d3 e8                	shr    %cl,%eax
f01066b9:	89 e9                	mov    %ebp,%ecx
f01066bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01066bf:	d3 e3                	shl    %cl,%ebx
f01066c1:	89 c7                	mov    %eax,%edi
f01066c3:	89 d1                	mov    %edx,%ecx
f01066c5:	89 f0                	mov    %esi,%eax
f01066c7:	d3 e8                	shr    %cl,%eax
f01066c9:	89 e9                	mov    %ebp,%ecx
f01066cb:	89 fa                	mov    %edi,%edx
f01066cd:	d3 e6                	shl    %cl,%esi
f01066cf:	09 d8                	or     %ebx,%eax
f01066d1:	f7 74 24 08          	divl   0x8(%esp)
f01066d5:	89 d1                	mov    %edx,%ecx
f01066d7:	89 f3                	mov    %esi,%ebx
f01066d9:	f7 64 24 0c          	mull   0xc(%esp)
f01066dd:	89 c6                	mov    %eax,%esi
f01066df:	89 d7                	mov    %edx,%edi
f01066e1:	39 d1                	cmp    %edx,%ecx
f01066e3:	72 06                	jb     f01066eb <__umoddi3+0x10b>
f01066e5:	75 10                	jne    f01066f7 <__umoddi3+0x117>
f01066e7:	39 c3                	cmp    %eax,%ebx
f01066e9:	73 0c                	jae    f01066f7 <__umoddi3+0x117>
f01066eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
f01066ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01066f3:	89 d7                	mov    %edx,%edi
f01066f5:	89 c6                	mov    %eax,%esi
f01066f7:	89 ca                	mov    %ecx,%edx
f01066f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01066fe:	29 f3                	sub    %esi,%ebx
f0106700:	19 fa                	sbb    %edi,%edx
f0106702:	89 d0                	mov    %edx,%eax
f0106704:	d3 e0                	shl    %cl,%eax
f0106706:	89 e9                	mov    %ebp,%ecx
f0106708:	d3 eb                	shr    %cl,%ebx
f010670a:	d3 ea                	shr    %cl,%edx
f010670c:	09 d8                	or     %ebx,%eax
f010670e:	83 c4 1c             	add    $0x1c,%esp
f0106711:	5b                   	pop    %ebx
f0106712:	5e                   	pop    %esi
f0106713:	5f                   	pop    %edi
f0106714:	5d                   	pop    %ebp
f0106715:	c3                   	ret    
f0106716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010671d:	8d 76 00             	lea    0x0(%esi),%esi
f0106720:	29 fe                	sub    %edi,%esi
f0106722:	19 c3                	sbb    %eax,%ebx
f0106724:	89 f2                	mov    %esi,%edx
f0106726:	89 d9                	mov    %ebx,%ecx
f0106728:	e9 1d ff ff ff       	jmp    f010664a <__umoddi3+0x6a>
