
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
f0100015:	b8 00 40 12 00       	mov    $0x124000,%eax
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
f0100034:	bc 00 40 12 f0       	mov    $0xf0124000,%esp

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
f010004c:	83 3d 90 1e 2c f0 00 	cmpl   $0x0,0xf02c1e90
f0100053:	74 0f                	je     f0100064 <_panic+0x24>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100055:	83 ec 0c             	sub    $0xc,%esp
f0100058:	6a 00                	push   $0x0
f010005a:	e8 36 09 00 00       	call   f0100995 <monitor>
f010005f:	83 c4 10             	add    $0x10,%esp
f0100062:	eb f1                	jmp    f0100055 <_panic+0x15>
	panicstr = fmt;
f0100064:	89 35 90 1e 2c f0    	mov    %esi,0xf02c1e90
	asm volatile("cli; cld");
f010006a:	fa                   	cli    
f010006b:	fc                   	cld    
	va_start(ap, fmt);
f010006c:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006f:	e8 76 61 00 00       	call   f01061ea <cpunum>
f0100074:	ff 75 0c             	pushl  0xc(%ebp)
f0100077:	ff 75 08             	pushl  0x8(%ebp)
f010007a:	50                   	push   %eax
f010007b:	68 00 72 10 f0       	push   $0xf0107200
f0100080:	e8 b1 39 00 00       	call   f0103a36 <cprintf>
	vcprintf(fmt, ap);
f0100085:	83 c4 08             	add    $0x8,%esp
f0100088:	53                   	push   %ebx
f0100089:	56                   	push   %esi
f010008a:	e8 7d 39 00 00       	call   f0103a0c <vcprintf>
	cprintf("\n");
f010008f:	c7 04 24 96 7a 10 f0 	movl   $0xf0107a96,(%esp)
f0100096:	e8 9b 39 00 00       	call   f0103a36 <cprintf>
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
f01000ab:	e8 c2 05 00 00       	call   f0100672 <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000b0:	83 ec 08             	sub    $0x8,%esp
f01000b3:	68 ac 1a 00 00       	push   $0x1aac
f01000b8:	68 6c 72 10 f0       	push   $0xf010726c
f01000bd:	e8 74 39 00 00       	call   f0103a36 <cprintf>
	mem_init();
f01000c2:	e8 76 13 00 00       	call   f010143d <mem_init>
	env_init();
f01000c7:	e8 94 31 00 00       	call   f0103260 <env_init>
	trap_init();
f01000cc:	e8 4e 3a 00 00       	call   f0103b1f <trap_init>
	mp_init();
f01000d1:	e8 15 5e 00 00       	call   f0105eeb <mp_init>
	lapic_init();
f01000d6:	e8 29 61 00 00       	call   f0106204 <lapic_init>
	pic_init();
f01000db:	e8 55 38 00 00       	call   f0103935 <pic_init>
	time_init();
f01000e0:	e8 56 6e 00 00       	call   f0106f3b <time_init>
	pci_init();
f01000e5:	e8 2d 6e 00 00       	call   f0106f17 <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000ea:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f01000f1:	e8 7c 63 00 00       	call   f0106472 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000f6:	83 c4 10             	add    $0x10,%esp
f01000f9:	83 3d 98 1e 2c f0 07 	cmpl   $0x7,0xf02c1e98
f0100100:	76 27                	jbe    f0100129 <i386_init+0x89>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100102:	83 ec 04             	sub    $0x4,%esp
f0100105:	b8 4e 5e 10 f0       	mov    $0xf0105e4e,%eax
f010010a:	2d d4 5d 10 f0       	sub    $0xf0105dd4,%eax
f010010f:	50                   	push   %eax
f0100110:	68 d4 5d 10 f0       	push   $0xf0105dd4
f0100115:	68 00 70 00 f0       	push   $0xf0007000
f010011a:	e8 f6 5a 00 00       	call   f0105c15 <memmove>
	for (c = cpus; c < cpus + ncpu; c++) {
f010011f:	83 c4 10             	add    $0x10,%esp
f0100122:	bb 20 20 2c f0       	mov    $0xf02c2020,%ebx
f0100127:	eb 53                	jmp    f010017c <i386_init+0xdc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100129:	68 00 70 00 00       	push   $0x7000
f010012e:	68 24 72 10 f0       	push   $0xf0107224
f0100133:	6a 62                	push   $0x62
f0100135:	68 87 72 10 f0       	push   $0xf0107287
f010013a:	e8 01 ff ff ff       	call   f0100040 <_panic>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f010013f:	89 d8                	mov    %ebx,%eax
f0100141:	2d 20 20 2c f0       	sub    $0xf02c2020,%eax
f0100146:	c1 f8 02             	sar    $0x2,%eax
f0100149:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f010014f:	c1 e0 0f             	shl    $0xf,%eax
f0100152:	8d 80 00 b0 2c f0    	lea    -0xfd35000(%eax),%eax
f0100158:	a3 94 1e 2c f0       	mov    %eax,0xf02c1e94
		lapic_startap(c->cpu_id, PADDR(code));
f010015d:	83 ec 08             	sub    $0x8,%esp
f0100160:	68 00 70 00 00       	push   $0x7000
f0100165:	0f b6 03             	movzbl (%ebx),%eax
f0100168:	50                   	push   %eax
f0100169:	e8 f0 61 00 00       	call   f010635e <lapic_startap>
		while(c->cpu_status != CPU_STARTED)
f010016e:	83 c4 10             	add    $0x10,%esp
f0100171:	8b 43 04             	mov    0x4(%ebx),%eax
f0100174:	83 f8 01             	cmp    $0x1,%eax
f0100177:	75 f8                	jne    f0100171 <i386_init+0xd1>
	for (c = cpus; c < cpus + ncpu; c++) {
f0100179:	83 c3 74             	add    $0x74,%ebx
f010017c:	6b 05 c4 23 2c f0 74 	imul   $0x74,0xf02c23c4,%eax
f0100183:	05 20 20 2c f0       	add    $0xf02c2020,%eax
f0100188:	39 c3                	cmp    %eax,%ebx
f010018a:	73 13                	jae    f010019f <i386_init+0xff>
		if (c == cpus + cpunum())  // We've started already.
f010018c:	e8 59 60 00 00       	call   f01061ea <cpunum>
f0100191:	6b c0 74             	imul   $0x74,%eax,%eax
f0100194:	05 20 20 2c f0       	add    $0xf02c2020,%eax
f0100199:	39 c3                	cmp    %eax,%ebx
f010019b:	74 dc                	je     f0100179 <i386_init+0xd9>
f010019d:	eb a0                	jmp    f010013f <i386_init+0x9f>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f010019f:	83 ec 08             	sub    $0x8,%esp
f01001a2:	6a 01                	push   $0x1
f01001a4:	68 f0 25 1e f0       	push   $0xf01e25f0
f01001a9:	e8 54 32 00 00       	call   f0103402 <env_create>
	ENV_CREATE(net_ns, ENV_TYPE_NS);
f01001ae:	83 c4 08             	add    $0x8,%esp
f01001b1:	6a 02                	push   $0x2
f01001b3:	68 ec 0c 24 f0       	push   $0xf0240cec
f01001b8:	e8 45 32 00 00       	call   f0103402 <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001bd:	83 c4 08             	add    $0x8,%esp
f01001c0:	6a 00                	push   $0x0
f01001c2:	68 80 4e 20 f0       	push   $0xf0204e80
f01001c7:	e8 36 32 00 00       	call   f0103402 <env_create>
	kbd_intr();
f01001cc:	e8 45 04 00 00       	call   f0100616 <kbd_intr>
	sched_yield();
f01001d1:	e8 b7 46 00 00       	call   f010488d <sched_yield>

f01001d6 <mp_main>:
{
f01001d6:	f3 0f 1e fb          	endbr32 
f01001da:	55                   	push   %ebp
f01001db:	89 e5                	mov    %esp,%ebp
f01001dd:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001e0:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
	if ((uint32_t)kva < KERNBASE)
f01001e5:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001ea:	76 52                	jbe    f010023e <mp_main+0x68>
	return (physaddr_t)kva - KERNBASE;
f01001ec:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001f1:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001f4:	e8 f1 5f 00 00       	call   f01061ea <cpunum>
f01001f9:	83 ec 08             	sub    $0x8,%esp
f01001fc:	50                   	push   %eax
f01001fd:	68 93 72 10 f0       	push   $0xf0107293
f0100202:	e8 2f 38 00 00       	call   f0103a36 <cprintf>
	lapic_init();
f0100207:	e8 f8 5f 00 00       	call   f0106204 <lapic_init>
	env_init_percpu();
f010020c:	e8 1f 30 00 00       	call   f0103230 <env_init_percpu>
	trap_init_percpu();
f0100211:	e8 38 38 00 00       	call   f0103a4e <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100216:	e8 cf 5f 00 00       	call   f01061ea <cpunum>
f010021b:	6b d0 74             	imul   $0x74,%eax,%edx
f010021e:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100221:	b8 01 00 00 00       	mov    $0x1,%eax
f0100226:	f0 87 82 20 20 2c f0 	lock xchg %eax,-0xfd3dfe0(%edx)
f010022d:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f0100234:	e8 39 62 00 00       	call   f0106472 <spin_lock>
	sched_yield();
f0100239:	e8 4f 46 00 00       	call   f010488d <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010023e:	50                   	push   %eax
f010023f:	68 48 72 10 f0       	push   $0xf0107248
f0100244:	6a 7a                	push   $0x7a
f0100246:	68 87 72 10 f0       	push   $0xf0107287
f010024b:	e8 f0 fd ff ff       	call   f0100040 <_panic>

f0100250 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100250:	f3 0f 1e fb          	endbr32 
f0100254:	55                   	push   %ebp
f0100255:	89 e5                	mov    %esp,%ebp
f0100257:	53                   	push   %ebx
f0100258:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f010025b:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f010025e:	ff 75 0c             	pushl  0xc(%ebp)
f0100261:	ff 75 08             	pushl  0x8(%ebp)
f0100264:	68 a9 72 10 f0       	push   $0xf01072a9
f0100269:	e8 c8 37 00 00       	call   f0103a36 <cprintf>
	vcprintf(fmt, ap);
f010026e:	83 c4 08             	add    $0x8,%esp
f0100271:	53                   	push   %ebx
f0100272:	ff 75 10             	pushl  0x10(%ebp)
f0100275:	e8 92 37 00 00       	call   f0103a0c <vcprintf>
	cprintf("\n");
f010027a:	c7 04 24 96 7a 10 f0 	movl   $0xf0107a96,(%esp)
f0100281:	e8 b0 37 00 00       	call   f0103a36 <cprintf>
	va_end(ap);
}
f0100286:	83 c4 10             	add    $0x10,%esp
f0100289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010028c:	c9                   	leave  
f010028d:	c3                   	ret    

f010028e <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f010028e:	f3 0f 1e fb          	endbr32 
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100292:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100297:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100298:	a8 01                	test   $0x1,%al
f010029a:	74 0a                	je     f01002a6 <serial_proc_data+0x18>
f010029c:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01002a1:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f01002a2:	0f b6 c0             	movzbl %al,%eax
f01002a5:	c3                   	ret    
		return -1;
f01002a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f01002ab:	c3                   	ret    

f01002ac <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01002ac:	55                   	push   %ebp
f01002ad:	89 e5                	mov    %esp,%ebp
f01002af:	53                   	push   %ebx
f01002b0:	83 ec 04             	sub    $0x4,%esp
f01002b3:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01002b5:	ff d3                	call   *%ebx
f01002b7:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002ba:	74 29                	je     f01002e5 <cons_intr+0x39>
		if (c == 0)
f01002bc:	85 c0                	test   %eax,%eax
f01002be:	74 f5                	je     f01002b5 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002c0:	8b 0d 24 12 2c f0    	mov    0xf02c1224,%ecx
f01002c6:	8d 51 01             	lea    0x1(%ecx),%edx
f01002c9:	88 81 20 10 2c f0    	mov    %al,-0xfd3efe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002cf:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002d5:	b8 00 00 00 00       	mov    $0x0,%eax
f01002da:	0f 44 d0             	cmove  %eax,%edx
f01002dd:	89 15 24 12 2c f0    	mov    %edx,0xf02c1224
f01002e3:	eb d0                	jmp    f01002b5 <cons_intr+0x9>
	}
}
f01002e5:	83 c4 04             	add    $0x4,%esp
f01002e8:	5b                   	pop    %ebx
f01002e9:	5d                   	pop    %ebp
f01002ea:	c3                   	ret    

f01002eb <kbd_proc_data>:
{
f01002eb:	f3 0f 1e fb          	endbr32 
f01002ef:	55                   	push   %ebp
f01002f0:	89 e5                	mov    %esp,%ebp
f01002f2:	53                   	push   %ebx
f01002f3:	83 ec 04             	sub    $0x4,%esp
f01002f6:	ba 64 00 00 00       	mov    $0x64,%edx
f01002fb:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002fc:	a8 01                	test   $0x1,%al
f01002fe:	0f 84 f2 00 00 00    	je     f01003f6 <kbd_proc_data+0x10b>
	if (stat & KBS_TERR)
f0100304:	a8 20                	test   $0x20,%al
f0100306:	0f 85 f1 00 00 00    	jne    f01003fd <kbd_proc_data+0x112>
f010030c:	ba 60 00 00 00       	mov    $0x60,%edx
f0100311:	ec                   	in     (%dx),%al
f0100312:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100314:	3c e0                	cmp    $0xe0,%al
f0100316:	74 61                	je     f0100379 <kbd_proc_data+0x8e>
	} else if (data & 0x80) {
f0100318:	84 c0                	test   %al,%al
f010031a:	78 70                	js     f010038c <kbd_proc_data+0xa1>
	} else if (shift & E0ESC) {
f010031c:	8b 0d 00 10 2c f0    	mov    0xf02c1000,%ecx
f0100322:	f6 c1 40             	test   $0x40,%cl
f0100325:	74 0e                	je     f0100335 <kbd_proc_data+0x4a>
		data |= 0x80;
f0100327:	83 c8 80             	or     $0xffffff80,%eax
f010032a:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f010032c:	83 e1 bf             	and    $0xffffffbf,%ecx
f010032f:	89 0d 00 10 2c f0    	mov    %ecx,0xf02c1000
	shift |= shiftcode[data];
f0100335:	0f b6 d2             	movzbl %dl,%edx
f0100338:	0f b6 82 20 74 10 f0 	movzbl -0xfef8be0(%edx),%eax
f010033f:	0b 05 00 10 2c f0    	or     0xf02c1000,%eax
	shift ^= togglecode[data];
f0100345:	0f b6 8a 20 73 10 f0 	movzbl -0xfef8ce0(%edx),%ecx
f010034c:	31 c8                	xor    %ecx,%eax
f010034e:	a3 00 10 2c f0       	mov    %eax,0xf02c1000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100353:	89 c1                	mov    %eax,%ecx
f0100355:	83 e1 03             	and    $0x3,%ecx
f0100358:	8b 0c 8d 00 73 10 f0 	mov    -0xfef8d00(,%ecx,4),%ecx
f010035f:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100363:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100366:	a8 08                	test   $0x8,%al
f0100368:	74 61                	je     f01003cb <kbd_proc_data+0xe0>
		if ('a' <= c && c <= 'z')
f010036a:	89 da                	mov    %ebx,%edx
f010036c:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f010036f:	83 f9 19             	cmp    $0x19,%ecx
f0100372:	77 4b                	ja     f01003bf <kbd_proc_data+0xd4>
			c += 'A' - 'a';
f0100374:	83 eb 20             	sub    $0x20,%ebx
f0100377:	eb 0c                	jmp    f0100385 <kbd_proc_data+0x9a>
		shift |= E0ESC;
f0100379:	83 0d 00 10 2c f0 40 	orl    $0x40,0xf02c1000
		return 0;
f0100380:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100385:	89 d8                	mov    %ebx,%eax
f0100387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010038a:	c9                   	leave  
f010038b:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010038c:	8b 0d 00 10 2c f0    	mov    0xf02c1000,%ecx
f0100392:	89 cb                	mov    %ecx,%ebx
f0100394:	83 e3 40             	and    $0x40,%ebx
f0100397:	83 e0 7f             	and    $0x7f,%eax
f010039a:	85 db                	test   %ebx,%ebx
f010039c:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f010039f:	0f b6 d2             	movzbl %dl,%edx
f01003a2:	0f b6 82 20 74 10 f0 	movzbl -0xfef8be0(%edx),%eax
f01003a9:	83 c8 40             	or     $0x40,%eax
f01003ac:	0f b6 c0             	movzbl %al,%eax
f01003af:	f7 d0                	not    %eax
f01003b1:	21 c8                	and    %ecx,%eax
f01003b3:	a3 00 10 2c f0       	mov    %eax,0xf02c1000
		return 0;
f01003b8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003bd:	eb c6                	jmp    f0100385 <kbd_proc_data+0x9a>
		else if ('A' <= c && c <= 'Z')
f01003bf:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003c2:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003c5:	83 fa 1a             	cmp    $0x1a,%edx
f01003c8:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01003cb:	f7 d0                	not    %eax
f01003cd:	a8 06                	test   $0x6,%al
f01003cf:	75 b4                	jne    f0100385 <kbd_proc_data+0x9a>
f01003d1:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01003d7:	75 ac                	jne    f0100385 <kbd_proc_data+0x9a>
		cprintf("Rebooting!\n");
f01003d9:	83 ec 0c             	sub    $0xc,%esp
f01003dc:	68 c3 72 10 f0       	push   $0xf01072c3
f01003e1:	e8 50 36 00 00       	call   f0103a36 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003e6:	b8 03 00 00 00       	mov    $0x3,%eax
f01003eb:	ba 92 00 00 00       	mov    $0x92,%edx
f01003f0:	ee                   	out    %al,(%dx)
}
f01003f1:	83 c4 10             	add    $0x10,%esp
f01003f4:	eb 8f                	jmp    f0100385 <kbd_proc_data+0x9a>
		return -1;
f01003f6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003fb:	eb 88                	jmp    f0100385 <kbd_proc_data+0x9a>
		return -1;
f01003fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100402:	eb 81                	jmp    f0100385 <kbd_proc_data+0x9a>

f0100404 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100404:	55                   	push   %ebp
f0100405:	89 e5                	mov    %esp,%ebp
f0100407:	57                   	push   %edi
f0100408:	56                   	push   %esi
f0100409:	53                   	push   %ebx
f010040a:	83 ec 1c             	sub    $0x1c,%esp
f010040d:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f010040f:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100414:	bf fd 03 00 00       	mov    $0x3fd,%edi
f0100419:	bb 84 00 00 00       	mov    $0x84,%ebx
f010041e:	89 fa                	mov    %edi,%edx
f0100420:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100421:	a8 20                	test   $0x20,%al
f0100423:	75 13                	jne    f0100438 <cons_putc+0x34>
f0100425:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010042b:	7f 0b                	jg     f0100438 <cons_putc+0x34>
f010042d:	89 da                	mov    %ebx,%edx
f010042f:	ec                   	in     (%dx),%al
f0100430:	ec                   	in     (%dx),%al
f0100431:	ec                   	in     (%dx),%al
f0100432:	ec                   	in     (%dx),%al
	     i++)
f0100433:	83 c6 01             	add    $0x1,%esi
f0100436:	eb e6                	jmp    f010041e <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f0100438:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010043b:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100440:	89 c8                	mov    %ecx,%eax
f0100442:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100443:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100448:	bf 79 03 00 00       	mov    $0x379,%edi
f010044d:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100452:	89 fa                	mov    %edi,%edx
f0100454:	ec                   	in     (%dx),%al
f0100455:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010045b:	7f 0f                	jg     f010046c <cons_putc+0x68>
f010045d:	84 c0                	test   %al,%al
f010045f:	78 0b                	js     f010046c <cons_putc+0x68>
f0100461:	89 da                	mov    %ebx,%edx
f0100463:	ec                   	in     (%dx),%al
f0100464:	ec                   	in     (%dx),%al
f0100465:	ec                   	in     (%dx),%al
f0100466:	ec                   	in     (%dx),%al
f0100467:	83 c6 01             	add    $0x1,%esi
f010046a:	eb e6                	jmp    f0100452 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010046c:	ba 78 03 00 00       	mov    $0x378,%edx
f0100471:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100475:	ee                   	out    %al,(%dx)
f0100476:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010047b:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100480:	ee                   	out    %al,(%dx)
f0100481:	b8 08 00 00 00       	mov    $0x8,%eax
f0100486:	ee                   	out    %al,(%dx)
		c |= 0x0700;
f0100487:	89 c8                	mov    %ecx,%eax
f0100489:	80 cc 07             	or     $0x7,%ah
f010048c:	f7 c1 00 ff ff ff    	test   $0xffffff00,%ecx
f0100492:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f0100495:	0f b6 c1             	movzbl %cl,%eax
f0100498:	80 f9 0a             	cmp    $0xa,%cl
f010049b:	0f 84 dd 00 00 00    	je     f010057e <cons_putc+0x17a>
f01004a1:	83 f8 0a             	cmp    $0xa,%eax
f01004a4:	7f 46                	jg     f01004ec <cons_putc+0xe8>
f01004a6:	83 f8 08             	cmp    $0x8,%eax
f01004a9:	0f 84 a7 00 00 00    	je     f0100556 <cons_putc+0x152>
f01004af:	83 f8 09             	cmp    $0x9,%eax
f01004b2:	0f 85 d3 00 00 00    	jne    f010058b <cons_putc+0x187>
		cons_putc(' ');
f01004b8:	b8 20 00 00 00       	mov    $0x20,%eax
f01004bd:	e8 42 ff ff ff       	call   f0100404 <cons_putc>
		cons_putc(' ');
f01004c2:	b8 20 00 00 00       	mov    $0x20,%eax
f01004c7:	e8 38 ff ff ff       	call   f0100404 <cons_putc>
		cons_putc(' ');
f01004cc:	b8 20 00 00 00       	mov    $0x20,%eax
f01004d1:	e8 2e ff ff ff       	call   f0100404 <cons_putc>
		cons_putc(' ');
f01004d6:	b8 20 00 00 00       	mov    $0x20,%eax
f01004db:	e8 24 ff ff ff       	call   f0100404 <cons_putc>
		cons_putc(' ');
f01004e0:	b8 20 00 00 00       	mov    $0x20,%eax
f01004e5:	e8 1a ff ff ff       	call   f0100404 <cons_putc>
		break;
f01004ea:	eb 25                	jmp    f0100511 <cons_putc+0x10d>
	switch (c & 0xff) {
f01004ec:	83 f8 0d             	cmp    $0xd,%eax
f01004ef:	0f 85 96 00 00 00    	jne    f010058b <cons_putc+0x187>
		crt_pos -= (crt_pos % CRT_COLS);
f01004f5:	0f b7 05 28 12 2c f0 	movzwl 0xf02c1228,%eax
f01004fc:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100502:	c1 e8 16             	shr    $0x16,%eax
f0100505:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100508:	c1 e0 04             	shl    $0x4,%eax
f010050b:	66 a3 28 12 2c f0    	mov    %ax,0xf02c1228
	if (crt_pos >= CRT_SIZE) {
f0100511:	66 81 3d 28 12 2c f0 	cmpw   $0x7cf,0xf02c1228
f0100518:	cf 07 
f010051a:	0f 87 8e 00 00 00    	ja     f01005ae <cons_putc+0x1aa>
	outb(addr_6845, 14);
f0100520:	8b 0d 30 12 2c f0    	mov    0xf02c1230,%ecx
f0100526:	b8 0e 00 00 00       	mov    $0xe,%eax
f010052b:	89 ca                	mov    %ecx,%edx
f010052d:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010052e:	0f b7 1d 28 12 2c f0 	movzwl 0xf02c1228,%ebx
f0100535:	8d 71 01             	lea    0x1(%ecx),%esi
f0100538:	89 d8                	mov    %ebx,%eax
f010053a:	66 c1 e8 08          	shr    $0x8,%ax
f010053e:	89 f2                	mov    %esi,%edx
f0100540:	ee                   	out    %al,(%dx)
f0100541:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100546:	89 ca                	mov    %ecx,%edx
f0100548:	ee                   	out    %al,(%dx)
f0100549:	89 d8                	mov    %ebx,%eax
f010054b:	89 f2                	mov    %esi,%edx
f010054d:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010054e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100551:	5b                   	pop    %ebx
f0100552:	5e                   	pop    %esi
f0100553:	5f                   	pop    %edi
f0100554:	5d                   	pop    %ebp
f0100555:	c3                   	ret    
		if (crt_pos > 0) {
f0100556:	0f b7 05 28 12 2c f0 	movzwl 0xf02c1228,%eax
f010055d:	66 85 c0             	test   %ax,%ax
f0100560:	74 be                	je     f0100520 <cons_putc+0x11c>
			crt_pos--;
f0100562:	83 e8 01             	sub    $0x1,%eax
f0100565:	66 a3 28 12 2c f0    	mov    %ax,0xf02c1228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f010056b:	0f b7 d0             	movzwl %ax,%edx
f010056e:	b1 00                	mov    $0x0,%cl
f0100570:	83 c9 20             	or     $0x20,%ecx
f0100573:	a1 2c 12 2c f0       	mov    0xf02c122c,%eax
f0100578:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
f010057c:	eb 93                	jmp    f0100511 <cons_putc+0x10d>
		crt_pos += CRT_COLS;
f010057e:	66 83 05 28 12 2c f0 	addw   $0x50,0xf02c1228
f0100585:	50 
f0100586:	e9 6a ff ff ff       	jmp    f01004f5 <cons_putc+0xf1>
		crt_buf[crt_pos++] = c;		/* write the character */
f010058b:	0f b7 05 28 12 2c f0 	movzwl 0xf02c1228,%eax
f0100592:	8d 50 01             	lea    0x1(%eax),%edx
f0100595:	66 89 15 28 12 2c f0 	mov    %dx,0xf02c1228
f010059c:	0f b7 c0             	movzwl %ax,%eax
f010059f:	8b 15 2c 12 2c f0    	mov    0xf02c122c,%edx
f01005a5:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
		break;
f01005a9:	e9 63 ff ff ff       	jmp    f0100511 <cons_putc+0x10d>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005ae:	a1 2c 12 2c f0       	mov    0xf02c122c,%eax
f01005b3:	83 ec 04             	sub    $0x4,%esp
f01005b6:	68 00 0f 00 00       	push   $0xf00
f01005bb:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005c1:	52                   	push   %edx
f01005c2:	50                   	push   %eax
f01005c3:	e8 4d 56 00 00       	call   f0105c15 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005c8:	8b 15 2c 12 2c f0    	mov    0xf02c122c,%edx
f01005ce:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005d4:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005da:	83 c4 10             	add    $0x10,%esp
f01005dd:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005e2:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005e5:	39 d0                	cmp    %edx,%eax
f01005e7:	75 f4                	jne    f01005dd <cons_putc+0x1d9>
		crt_pos -= CRT_COLS;
f01005e9:	66 83 2d 28 12 2c f0 	subw   $0x50,0xf02c1228
f01005f0:	50 
f01005f1:	e9 2a ff ff ff       	jmp    f0100520 <cons_putc+0x11c>

f01005f6 <serial_intr>:
{
f01005f6:	f3 0f 1e fb          	endbr32 
	if (serial_exists)
f01005fa:	80 3d 34 12 2c f0 00 	cmpb   $0x0,0xf02c1234
f0100601:	75 01                	jne    f0100604 <serial_intr+0xe>
f0100603:	c3                   	ret    
{
f0100604:	55                   	push   %ebp
f0100605:	89 e5                	mov    %esp,%ebp
f0100607:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010060a:	b8 8e 02 10 f0       	mov    $0xf010028e,%eax
f010060f:	e8 98 fc ff ff       	call   f01002ac <cons_intr>
}
f0100614:	c9                   	leave  
f0100615:	c3                   	ret    

f0100616 <kbd_intr>:
{
f0100616:	f3 0f 1e fb          	endbr32 
f010061a:	55                   	push   %ebp
f010061b:	89 e5                	mov    %esp,%ebp
f010061d:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100620:	b8 eb 02 10 f0       	mov    $0xf01002eb,%eax
f0100625:	e8 82 fc ff ff       	call   f01002ac <cons_intr>
}
f010062a:	c9                   	leave  
f010062b:	c3                   	ret    

f010062c <cons_getc>:
{
f010062c:	f3 0f 1e fb          	endbr32 
f0100630:	55                   	push   %ebp
f0100631:	89 e5                	mov    %esp,%ebp
f0100633:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f0100636:	e8 bb ff ff ff       	call   f01005f6 <serial_intr>
	kbd_intr();
f010063b:	e8 d6 ff ff ff       	call   f0100616 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100640:	a1 20 12 2c f0       	mov    0xf02c1220,%eax
	return 0;
f0100645:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f010064a:	3b 05 24 12 2c f0    	cmp    0xf02c1224,%eax
f0100650:	74 1c                	je     f010066e <cons_getc+0x42>
		c = cons.buf[cons.rpos++];
f0100652:	8d 48 01             	lea    0x1(%eax),%ecx
f0100655:	0f b6 90 20 10 2c f0 	movzbl -0xfd3efe0(%eax),%edx
			cons.rpos = 0;
f010065c:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f0100661:	b8 00 00 00 00       	mov    $0x0,%eax
f0100666:	0f 45 c1             	cmovne %ecx,%eax
f0100669:	a3 20 12 2c f0       	mov    %eax,0xf02c1220
}
f010066e:	89 d0                	mov    %edx,%eax
f0100670:	c9                   	leave  
f0100671:	c3                   	ret    

f0100672 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100672:	f3 0f 1e fb          	endbr32 
f0100676:	55                   	push   %ebp
f0100677:	89 e5                	mov    %esp,%ebp
f0100679:	57                   	push   %edi
f010067a:	56                   	push   %esi
f010067b:	53                   	push   %ebx
f010067c:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f010067f:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f0100686:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f010068d:	5a a5 
	if (*cp != 0xA55A) {
f010068f:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f0100696:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010069a:	0f 84 de 00 00 00    	je     f010077e <cons_init+0x10c>
		addr_6845 = MONO_BASE;
f01006a0:	c7 05 30 12 2c f0 b4 	movl   $0x3b4,0xf02c1230
f01006a7:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006aa:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006af:	8b 3d 30 12 2c f0    	mov    0xf02c1230,%edi
f01006b5:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006ba:	89 fa                	mov    %edi,%edx
f01006bc:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006bd:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006c0:	89 ca                	mov    %ecx,%edx
f01006c2:	ec                   	in     (%dx),%al
f01006c3:	0f b6 c0             	movzbl %al,%eax
f01006c6:	c1 e0 08             	shl    $0x8,%eax
f01006c9:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006cb:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006d0:	89 fa                	mov    %edi,%edx
f01006d2:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006d3:	89 ca                	mov    %ecx,%edx
f01006d5:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006d6:	89 35 2c 12 2c f0    	mov    %esi,0xf02c122c
	pos |= inb(addr_6845 + 1);
f01006dc:	0f b6 c0             	movzbl %al,%eax
f01006df:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006e1:	66 a3 28 12 2c f0    	mov    %ax,0xf02c1228
	kbd_intr();
f01006e7:	e8 2a ff ff ff       	call   f0100616 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006ec:	83 ec 0c             	sub    $0xc,%esp
f01006ef:	0f b7 05 a8 63 12 f0 	movzwl 0xf01263a8,%eax
f01006f6:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006fb:	50                   	push   %eax
f01006fc:	e8 b2 31 00 00       	call   f01038b3 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100701:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100706:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f010070b:	89 d8                	mov    %ebx,%eax
f010070d:	89 ca                	mov    %ecx,%edx
f010070f:	ee                   	out    %al,(%dx)
f0100710:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100715:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010071a:	89 fa                	mov    %edi,%edx
f010071c:	ee                   	out    %al,(%dx)
f010071d:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100722:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100727:	ee                   	out    %al,(%dx)
f0100728:	be f9 03 00 00       	mov    $0x3f9,%esi
f010072d:	89 d8                	mov    %ebx,%eax
f010072f:	89 f2                	mov    %esi,%edx
f0100731:	ee                   	out    %al,(%dx)
f0100732:	b8 03 00 00 00       	mov    $0x3,%eax
f0100737:	89 fa                	mov    %edi,%edx
f0100739:	ee                   	out    %al,(%dx)
f010073a:	ba fc 03 00 00       	mov    $0x3fc,%edx
f010073f:	89 d8                	mov    %ebx,%eax
f0100741:	ee                   	out    %al,(%dx)
f0100742:	b8 01 00 00 00       	mov    $0x1,%eax
f0100747:	89 f2                	mov    %esi,%edx
f0100749:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010074a:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010074f:	ec                   	in     (%dx),%al
f0100750:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100752:	83 c4 10             	add    $0x10,%esp
f0100755:	3c ff                	cmp    $0xff,%al
f0100757:	0f 95 05 34 12 2c f0 	setne  0xf02c1234
f010075e:	89 ca                	mov    %ecx,%edx
f0100760:	ec                   	in     (%dx),%al
f0100761:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100766:	ec                   	in     (%dx),%al
	if (serial_exists)
f0100767:	80 fb ff             	cmp    $0xff,%bl
f010076a:	75 2d                	jne    f0100799 <cons_init+0x127>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f010076c:	83 ec 0c             	sub    $0xc,%esp
f010076f:	68 cf 72 10 f0       	push   $0xf01072cf
f0100774:	e8 bd 32 00 00       	call   f0103a36 <cprintf>
f0100779:	83 c4 10             	add    $0x10,%esp
}
f010077c:	eb 3c                	jmp    f01007ba <cons_init+0x148>
		*cp = was;
f010077e:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100785:	c7 05 30 12 2c f0 d4 	movl   $0x3d4,0xf02c1230
f010078c:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f010078f:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100794:	e9 16 ff ff ff       	jmp    f01006af <cons_init+0x3d>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f0100799:	83 ec 0c             	sub    $0xc,%esp
f010079c:	0f b7 05 a8 63 12 f0 	movzwl 0xf01263a8,%eax
f01007a3:	25 ef ff 00 00       	and    $0xffef,%eax
f01007a8:	50                   	push   %eax
f01007a9:	e8 05 31 00 00       	call   f01038b3 <irq_setmask_8259A>
	if (!serial_exists)
f01007ae:	83 c4 10             	add    $0x10,%esp
f01007b1:	80 3d 34 12 2c f0 00 	cmpb   $0x0,0xf02c1234
f01007b8:	74 b2                	je     f010076c <cons_init+0xfa>
}
f01007ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007bd:	5b                   	pop    %ebx
f01007be:	5e                   	pop    %esi
f01007bf:	5f                   	pop    %edi
f01007c0:	5d                   	pop    %ebp
f01007c1:	c3                   	ret    

f01007c2 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007c2:	f3 0f 1e fb          	endbr32 
f01007c6:	55                   	push   %ebp
f01007c7:	89 e5                	mov    %esp,%ebp
f01007c9:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007cc:	8b 45 08             	mov    0x8(%ebp),%eax
f01007cf:	e8 30 fc ff ff       	call   f0100404 <cons_putc>
}
f01007d4:	c9                   	leave  
f01007d5:	c3                   	ret    

f01007d6 <getchar>:

int
getchar(void)
{
f01007d6:	f3 0f 1e fb          	endbr32 
f01007da:	55                   	push   %ebp
f01007db:	89 e5                	mov    %esp,%ebp
f01007dd:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007e0:	e8 47 fe ff ff       	call   f010062c <cons_getc>
f01007e5:	85 c0                	test   %eax,%eax
f01007e7:	74 f7                	je     f01007e0 <getchar+0xa>
		/* do nothing */;
	return c;
}
f01007e9:	c9                   	leave  
f01007ea:	c3                   	ret    

f01007eb <iscons>:

int
iscons(int fdnum)
{
f01007eb:	f3 0f 1e fb          	endbr32 
	// used by readline
	return 1;
}
f01007ef:	b8 01 00 00 00       	mov    $0x1,%eax
f01007f4:	c3                   	ret    

f01007f5 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007f5:	f3 0f 1e fb          	endbr32 
f01007f9:	55                   	push   %ebp
f01007fa:	89 e5                	mov    %esp,%ebp
f01007fc:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007ff:	68 20 75 10 f0       	push   $0xf0107520
f0100804:	68 3e 75 10 f0       	push   $0xf010753e
f0100809:	68 43 75 10 f0       	push   $0xf0107543
f010080e:	e8 23 32 00 00       	call   f0103a36 <cprintf>
f0100813:	83 c4 0c             	add    $0xc,%esp
f0100816:	68 f4 75 10 f0       	push   $0xf01075f4
f010081b:	68 4c 75 10 f0       	push   $0xf010754c
f0100820:	68 43 75 10 f0       	push   $0xf0107543
f0100825:	e8 0c 32 00 00       	call   f0103a36 <cprintf>
f010082a:	83 c4 0c             	add    $0xc,%esp
f010082d:	68 1c 76 10 f0       	push   $0xf010761c
f0100832:	68 55 75 10 f0       	push   $0xf0107555
f0100837:	68 43 75 10 f0       	push   $0xf0107543
f010083c:	e8 f5 31 00 00       	call   f0103a36 <cprintf>
	return 0;
}
f0100841:	b8 00 00 00 00       	mov    $0x0,%eax
f0100846:	c9                   	leave  
f0100847:	c3                   	ret    

f0100848 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100848:	f3 0f 1e fb          	endbr32 
f010084c:	55                   	push   %ebp
f010084d:	89 e5                	mov    %esp,%ebp
f010084f:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100852:	68 5f 75 10 f0       	push   $0xf010755f
f0100857:	e8 da 31 00 00       	call   f0103a36 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f010085c:	83 c4 08             	add    $0x8,%esp
f010085f:	68 0c 00 10 00       	push   $0x10000c
f0100864:	68 44 76 10 f0       	push   $0xf0107644
f0100869:	e8 c8 31 00 00       	call   f0103a36 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010086e:	83 c4 0c             	add    $0xc,%esp
f0100871:	68 0c 00 10 00       	push   $0x10000c
f0100876:	68 0c 00 10 f0       	push   $0xf010000c
f010087b:	68 6c 76 10 f0       	push   $0xf010766c
f0100880:	e8 b1 31 00 00       	call   f0103a36 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100885:	83 c4 0c             	add    $0xc,%esp
f0100888:	68 ed 71 10 00       	push   $0x1071ed
f010088d:	68 ed 71 10 f0       	push   $0xf01071ed
f0100892:	68 90 76 10 f0       	push   $0xf0107690
f0100897:	e8 9a 31 00 00       	call   f0103a36 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010089c:	83 c4 0c             	add    $0xc,%esp
f010089f:	68 00 10 2c 00       	push   $0x2c1000
f01008a4:	68 00 10 2c f0       	push   $0xf02c1000
f01008a9:	68 b4 76 10 f0       	push   $0xf01076b4
f01008ae:	e8 83 31 00 00       	call   f0103a36 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008b3:	83 c4 0c             	add    $0xc,%esp
f01008b6:	68 48 ef 33 00       	push   $0x33ef48
f01008bb:	68 48 ef 33 f0       	push   $0xf033ef48
f01008c0:	68 d8 76 10 f0       	push   $0xf01076d8
f01008c5:	e8 6c 31 00 00       	call   f0103a36 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008ca:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01008cd:	b8 48 ef 33 f0       	mov    $0xf033ef48,%eax
f01008d2:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008d7:	c1 f8 0a             	sar    $0xa,%eax
f01008da:	50                   	push   %eax
f01008db:	68 fc 76 10 f0       	push   $0xf01076fc
f01008e0:	e8 51 31 00 00       	call   f0103a36 <cprintf>
	return 0;
}
f01008e5:	b8 00 00 00 00       	mov    $0x0,%eax
f01008ea:	c9                   	leave  
f01008eb:	c3                   	ret    

f01008ec <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008ec:	f3 0f 1e fb          	endbr32 
f01008f0:	55                   	push   %ebp
f01008f1:	89 e5                	mov    %esp,%ebp
f01008f3:	57                   	push   %edi
f01008f4:	56                   	push   %esi
f01008f5:	53                   	push   %ebx
f01008f6:	83 ec 48             	sub    $0x48,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008f9:	89 ee                	mov    %ebp,%esi
	// Your code here.
	uint32_t* ebp = (uint32_t*) read_ebp();
	cprintf("Stack backtrace:\n");
f01008fb:	68 78 75 10 f0       	push   $0xf0107578
f0100900:	e8 31 31 00 00       	call   f0103a36 <cprintf>
	while (ebp) {
f0100905:	83 c4 10             	add    $0x10,%esp
f0100908:	eb 41                	jmp    f010094b <mon_backtrace+0x5f>
		uint32_t eip = ebp[1];
		cprintf("ebp %x  eip %x  args", ebp, eip);
		int i;
		for (i = 2; i <= 6; ++i)
			cprintf(" %08.x", ebp[i]);
		cprintf("\n");
f010090a:	83 ec 0c             	sub    $0xc,%esp
f010090d:	68 96 7a 10 f0       	push   $0xf0107a96
f0100912:	e8 1f 31 00 00       	call   f0103a36 <cprintf>
		struct Eipdebuginfo info;
		debuginfo_eip(eip, &info);
f0100917:	83 c4 08             	add    $0x8,%esp
f010091a:	8d 45 d0             	lea    -0x30(%ebp),%eax
f010091d:	50                   	push   %eax
f010091e:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0100921:	57                   	push   %edi
f0100922:	e8 51 47 00 00       	call   f0105078 <debuginfo_eip>
		cprintf("\t%s:%d: %.*s+%d\n", 
f0100927:	83 c4 08             	add    $0x8,%esp
f010092a:	89 f8                	mov    %edi,%eax
f010092c:	2b 45 e0             	sub    -0x20(%ebp),%eax
f010092f:	50                   	push   %eax
f0100930:	ff 75 d8             	pushl  -0x28(%ebp)
f0100933:	ff 75 dc             	pushl  -0x24(%ebp)
f0100936:	ff 75 d4             	pushl  -0x2c(%ebp)
f0100939:	ff 75 d0             	pushl  -0x30(%ebp)
f010093c:	68 a6 75 10 f0       	push   $0xf01075a6
f0100941:	e8 f0 30 00 00       	call   f0103a36 <cprintf>
			info.eip_file, info.eip_line,
			info.eip_fn_namelen, info.eip_fn_name,
			eip-info.eip_fn_addr);
		ebp = (uint32_t*) *ebp;
f0100946:	8b 36                	mov    (%esi),%esi
f0100948:	83 c4 20             	add    $0x20,%esp
	while (ebp) {
f010094b:	85 f6                	test   %esi,%esi
f010094d:	74 39                	je     f0100988 <mon_backtrace+0x9c>
		uint32_t eip = ebp[1];
f010094f:	8b 46 04             	mov    0x4(%esi),%eax
f0100952:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("ebp %x  eip %x  args", ebp, eip);
f0100955:	83 ec 04             	sub    $0x4,%esp
f0100958:	50                   	push   %eax
f0100959:	56                   	push   %esi
f010095a:	68 8a 75 10 f0       	push   $0xf010758a
f010095f:	e8 d2 30 00 00       	call   f0103a36 <cprintf>
f0100964:	8d 5e 08             	lea    0x8(%esi),%ebx
f0100967:	8d 7e 1c             	lea    0x1c(%esi),%edi
f010096a:	83 c4 10             	add    $0x10,%esp
			cprintf(" %08.x", ebp[i]);
f010096d:	83 ec 08             	sub    $0x8,%esp
f0100970:	ff 33                	pushl  (%ebx)
f0100972:	68 9f 75 10 f0       	push   $0xf010759f
f0100977:	e8 ba 30 00 00       	call   f0103a36 <cprintf>
f010097c:	83 c3 04             	add    $0x4,%ebx
		for (i = 2; i <= 6; ++i)
f010097f:	83 c4 10             	add    $0x10,%esp
f0100982:	39 fb                	cmp    %edi,%ebx
f0100984:	75 e7                	jne    f010096d <mon_backtrace+0x81>
f0100986:	eb 82                	jmp    f010090a <mon_backtrace+0x1e>
	}
	return 0;
}
f0100988:	b8 00 00 00 00       	mov    $0x0,%eax
f010098d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100990:	5b                   	pop    %ebx
f0100991:	5e                   	pop    %esi
f0100992:	5f                   	pop    %edi
f0100993:	5d                   	pop    %ebp
f0100994:	c3                   	ret    

f0100995 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100995:	f3 0f 1e fb          	endbr32 
f0100999:	55                   	push   %ebp
f010099a:	89 e5                	mov    %esp,%ebp
f010099c:	57                   	push   %edi
f010099d:	56                   	push   %esi
f010099e:	53                   	push   %ebx
f010099f:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	//e1000_transmit("I'm here", 10);

	cprintf("Welcome to the JOS kernel monitor!\n");
f01009a2:	68 28 77 10 f0       	push   $0xf0107728
f01009a7:	e8 8a 30 00 00       	call   f0103a36 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01009ac:	c7 04 24 4c 77 10 f0 	movl   $0xf010774c,(%esp)
f01009b3:	e8 7e 30 00 00       	call   f0103a36 <cprintf>

	if (tf != NULL)
f01009b8:	83 c4 10             	add    $0x10,%esp
f01009bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f01009bf:	0f 84 d9 00 00 00    	je     f0100a9e <monitor+0x109>
		print_trapframe(tf);
f01009c5:	83 ec 0c             	sub    $0xc,%esp
f01009c8:	ff 75 08             	pushl  0x8(%ebp)
f01009cb:	e8 d3 37 00 00       	call   f01041a3 <print_trapframe>
f01009d0:	83 c4 10             	add    $0x10,%esp
f01009d3:	e9 c6 00 00 00       	jmp    f0100a9e <monitor+0x109>
		while (*buf && strchr(WHITESPACE, *buf))
f01009d8:	83 ec 08             	sub    $0x8,%esp
f01009db:	0f be c0             	movsbl %al,%eax
f01009de:	50                   	push   %eax
f01009df:	68 bb 75 10 f0       	push   $0xf01075bb
f01009e4:	e8 9b 51 00 00       	call   f0105b84 <strchr>
f01009e9:	83 c4 10             	add    $0x10,%esp
f01009ec:	85 c0                	test   %eax,%eax
f01009ee:	74 63                	je     f0100a53 <monitor+0xbe>
			*buf++ = 0;
f01009f0:	c6 03 00             	movb   $0x0,(%ebx)
f01009f3:	89 f7                	mov    %esi,%edi
f01009f5:	8d 5b 01             	lea    0x1(%ebx),%ebx
f01009f8:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f01009fa:	0f b6 03             	movzbl (%ebx),%eax
f01009fd:	84 c0                	test   %al,%al
f01009ff:	75 d7                	jne    f01009d8 <monitor+0x43>
	argv[argc] = 0;
f0100a01:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100a08:	00 
	if (argc == 0)
f0100a09:	85 f6                	test   %esi,%esi
f0100a0b:	0f 84 8d 00 00 00    	je     f0100a9e <monitor+0x109>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a11:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100a16:	83 ec 08             	sub    $0x8,%esp
f0100a19:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a1c:	ff 34 85 80 77 10 f0 	pushl  -0xfef8880(,%eax,4)
f0100a23:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a26:	e8 f3 50 00 00       	call   f0105b1e <strcmp>
f0100a2b:	83 c4 10             	add    $0x10,%esp
f0100a2e:	85 c0                	test   %eax,%eax
f0100a30:	0f 84 8f 00 00 00    	je     f0100ac5 <monitor+0x130>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a36:	83 c3 01             	add    $0x1,%ebx
f0100a39:	83 fb 03             	cmp    $0x3,%ebx
f0100a3c:	75 d8                	jne    f0100a16 <monitor+0x81>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a3e:	83 ec 08             	sub    $0x8,%esp
f0100a41:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a44:	68 dd 75 10 f0       	push   $0xf01075dd
f0100a49:	e8 e8 2f 00 00       	call   f0103a36 <cprintf>
	return 0;
f0100a4e:	83 c4 10             	add    $0x10,%esp
f0100a51:	eb 4b                	jmp    f0100a9e <monitor+0x109>
		if (*buf == 0)
f0100a53:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a56:	74 a9                	je     f0100a01 <monitor+0x6c>
		if (argc == MAXARGS-1) {
f0100a58:	83 fe 0f             	cmp    $0xf,%esi
f0100a5b:	74 2f                	je     f0100a8c <monitor+0xf7>
		argv[argc++] = buf;
f0100a5d:	8d 7e 01             	lea    0x1(%esi),%edi
f0100a60:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a64:	0f b6 03             	movzbl (%ebx),%eax
f0100a67:	84 c0                	test   %al,%al
f0100a69:	74 8d                	je     f01009f8 <monitor+0x63>
f0100a6b:	83 ec 08             	sub    $0x8,%esp
f0100a6e:	0f be c0             	movsbl %al,%eax
f0100a71:	50                   	push   %eax
f0100a72:	68 bb 75 10 f0       	push   $0xf01075bb
f0100a77:	e8 08 51 00 00       	call   f0105b84 <strchr>
f0100a7c:	83 c4 10             	add    $0x10,%esp
f0100a7f:	85 c0                	test   %eax,%eax
f0100a81:	0f 85 71 ff ff ff    	jne    f01009f8 <monitor+0x63>
			buf++;
f0100a87:	83 c3 01             	add    $0x1,%ebx
f0100a8a:	eb d8                	jmp    f0100a64 <monitor+0xcf>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a8c:	83 ec 08             	sub    $0x8,%esp
f0100a8f:	6a 10                	push   $0x10
f0100a91:	68 c0 75 10 f0       	push   $0xf01075c0
f0100a96:	e8 9b 2f 00 00       	call   f0103a36 <cprintf>
			return 0;
f0100a9b:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100a9e:	83 ec 0c             	sub    $0xc,%esp
f0100aa1:	68 b7 75 10 f0       	push   $0xf01075b7
f0100aa6:	e8 7f 4e 00 00       	call   f010592a <readline>
f0100aab:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100aad:	83 c4 10             	add    $0x10,%esp
f0100ab0:	85 c0                	test   %eax,%eax
f0100ab2:	74 ea                	je     f0100a9e <monitor+0x109>
	argv[argc] = 0;
f0100ab4:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100abb:	be 00 00 00 00       	mov    $0x0,%esi
f0100ac0:	e9 35 ff ff ff       	jmp    f01009fa <monitor+0x65>
			return commands[i].func(argc, argv, tf);
f0100ac5:	83 ec 04             	sub    $0x4,%esp
f0100ac8:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100acb:	ff 75 08             	pushl  0x8(%ebp)
f0100ace:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100ad1:	52                   	push   %edx
f0100ad2:	56                   	push   %esi
f0100ad3:	ff 14 85 88 77 10 f0 	call   *-0xfef8878(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100ada:	83 c4 10             	add    $0x10,%esp
f0100add:	85 c0                	test   %eax,%eax
f0100adf:	79 bd                	jns    f0100a9e <monitor+0x109>
				break;
	}
f0100ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100ae4:	5b                   	pop    %ebx
f0100ae5:	5e                   	pop    %esi
f0100ae6:	5f                   	pop    %edi
f0100ae7:	5d                   	pop    %ebp
f0100ae8:	c3                   	ret    

f0100ae9 <boot_alloc>:
// before the page_free_list list has been set up.
// Note that when this function is called, we are still using entry_pgdir,
// which only maps the first 4MB of physical memory.
static void *
boot_alloc(uint32_t n)
{
f0100ae9:	55                   	push   %ebp
f0100aea:	89 e5                	mov    %esp,%ebp
f0100aec:	53                   	push   %ebx
f0100aed:	83 ec 04             	sub    $0x4,%esp
f0100af0:	89 c3                	mov    %eax,%ebx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100af2:	83 3d 38 12 2c f0 00 	cmpl   $0x0,0xf02c1238
f0100af9:	74 1e                	je     f0100b19 <boot_alloc+0x30>
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = nextfree;
f0100afb:	8b 15 38 12 2c f0    	mov    0xf02c1238,%edx
	nextfree = ROUNDUP(result + n, PGSIZE);
f0100b01:	8d 84 1a ff 0f 00 00 	lea    0xfff(%edx,%ebx,1),%eax
f0100b08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b0d:	a3 38 12 2c f0       	mov    %eax,0xf02c1238

	// If we're out of memory, boot_alloc should panic.
	// 这部分目前没有思路

	return result;
}
f0100b12:	89 d0                	mov    %edx,%eax
f0100b14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100b17:	c9                   	leave  
f0100b18:	c3                   	ret    
		cprintf(".bss end is %08x\n", end);
f0100b19:	83 ec 08             	sub    $0x8,%esp
f0100b1c:	68 48 ef 33 f0       	push   $0xf033ef48
f0100b21:	68 a4 77 10 f0       	push   $0xf01077a4
f0100b26:	e8 0b 2f 00 00       	call   f0103a36 <cprintf>
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100b2b:	b8 47 ff 33 f0       	mov    $0xf033ff47,%eax
f0100b30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b35:	a3 38 12 2c f0       	mov    %eax,0xf02c1238
f0100b3a:	83 c4 10             	add    $0x10,%esp
f0100b3d:	eb bc                	jmp    f0100afb <boot_alloc+0x12>

f0100b3f <nvram_read>:
{
f0100b3f:	55                   	push   %ebp
f0100b40:	89 e5                	mov    %esp,%ebp
f0100b42:	56                   	push   %esi
f0100b43:	53                   	push   %ebx
f0100b44:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100b46:	83 ec 0c             	sub    $0xc,%esp
f0100b49:	50                   	push   %eax
f0100b4a:	e8 2e 2d 00 00       	call   f010387d <mc146818_read>
f0100b4f:	89 c6                	mov    %eax,%esi
f0100b51:	83 c3 01             	add    $0x1,%ebx
f0100b54:	89 1c 24             	mov    %ebx,(%esp)
f0100b57:	e8 21 2d 00 00       	call   f010387d <mc146818_read>
f0100b5c:	c1 e0 08             	shl    $0x8,%eax
f0100b5f:	09 f0                	or     %esi,%eax
}
f0100b61:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100b64:	5b                   	pop    %ebx
f0100b65:	5e                   	pop    %esi
f0100b66:	5d                   	pop    %ebp
f0100b67:	c3                   	ret    

f0100b68 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100b68:	89 d1                	mov    %edx,%ecx
f0100b6a:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100b6d:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100b70:	a8 01                	test   $0x1,%al
f0100b72:	74 51                	je     f0100bc5 <check_va2pa+0x5d>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100b74:	89 c1                	mov    %eax,%ecx
f0100b76:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
	if (PGNUM(pa) >= npages)
f0100b7c:	c1 e8 0c             	shr    $0xc,%eax
f0100b7f:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f0100b85:	73 23                	jae    f0100baa <check_va2pa+0x42>
	if (!(p[PTX(va)] & PTE_P))
f0100b87:	c1 ea 0c             	shr    $0xc,%edx
f0100b8a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100b90:	8b 94 91 00 00 00 f0 	mov    -0x10000000(%ecx,%edx,4),%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100b97:	89 d0                	mov    %edx,%eax
f0100b99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b9e:	f6 c2 01             	test   $0x1,%dl
f0100ba1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100ba6:	0f 44 c2             	cmove  %edx,%eax
f0100ba9:	c3                   	ret    
{
f0100baa:	55                   	push   %ebp
f0100bab:	89 e5                	mov    %esp,%ebp
f0100bad:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100bb0:	51                   	push   %ecx
f0100bb1:	68 24 72 10 f0       	push   $0xf0107224
f0100bb6:	68 f1 03 00 00       	push   $0x3f1
f0100bbb:	68 b6 77 10 f0       	push   $0xf01077b6
f0100bc0:	e8 7b f4 ff ff       	call   f0100040 <_panic>
		return ~0;
f0100bc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100bca:	c3                   	ret    

f0100bcb <check_page_free_list>:
{
f0100bcb:	55                   	push   %ebp
f0100bcc:	89 e5                	mov    %esp,%ebp
f0100bce:	57                   	push   %edi
f0100bcf:	56                   	push   %esi
f0100bd0:	53                   	push   %ebx
f0100bd1:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100bd4:	84 c0                	test   %al,%al
f0100bd6:	0f 85 77 02 00 00    	jne    f0100e53 <check_page_free_list+0x288>
	if (!page_free_list)
f0100bdc:	83 3d 40 12 2c f0 00 	cmpl   $0x0,0xf02c1240
f0100be3:	74 0a                	je     f0100bef <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100be5:	be 00 04 00 00       	mov    $0x400,%esi
f0100bea:	e9 bf 02 00 00       	jmp    f0100eae <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100bef:	83 ec 04             	sub    $0x4,%esp
f0100bf2:	68 c8 7a 10 f0       	push   $0xf0107ac8
f0100bf7:	68 24 03 00 00       	push   $0x324
f0100bfc:	68 b6 77 10 f0       	push   $0xf01077b6
f0100c01:	e8 3a f4 ff ff       	call   f0100040 <_panic>
f0100c06:	50                   	push   %eax
f0100c07:	68 24 72 10 f0       	push   $0xf0107224
f0100c0c:	6a 58                	push   $0x58
f0100c0e:	68 c2 77 10 f0       	push   $0xf01077c2
f0100c13:	e8 28 f4 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100c18:	8b 1b                	mov    (%ebx),%ebx
f0100c1a:	85 db                	test   %ebx,%ebx
f0100c1c:	74 41                	je     f0100c5f <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100c1e:	89 d8                	mov    %ebx,%eax
f0100c20:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0100c26:	c1 f8 03             	sar    $0x3,%eax
f0100c29:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100c2c:	89 c2                	mov    %eax,%edx
f0100c2e:	c1 ea 16             	shr    $0x16,%edx
f0100c31:	39 f2                	cmp    %esi,%edx
f0100c33:	73 e3                	jae    f0100c18 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100c35:	89 c2                	mov    %eax,%edx
f0100c37:	c1 ea 0c             	shr    $0xc,%edx
f0100c3a:	3b 15 98 1e 2c f0    	cmp    0xf02c1e98,%edx
f0100c40:	73 c4                	jae    f0100c06 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100c42:	83 ec 04             	sub    $0x4,%esp
f0100c45:	68 80 00 00 00       	push   $0x80
f0100c4a:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100c4f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100c54:	50                   	push   %eax
f0100c55:	e8 6f 4f 00 00       	call   f0105bc9 <memset>
f0100c5a:	83 c4 10             	add    $0x10,%esp
f0100c5d:	eb b9                	jmp    f0100c18 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100c5f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c64:	e8 80 fe ff ff       	call   f0100ae9 <boot_alloc>
f0100c69:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c6c:	8b 15 40 12 2c f0    	mov    0xf02c1240,%edx
		assert(pp >= pages);
f0100c72:	8b 0d a0 1e 2c f0    	mov    0xf02c1ea0,%ecx
		assert(pp < pages + npages);
f0100c78:	a1 98 1e 2c f0       	mov    0xf02c1e98,%eax
f0100c7d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100c80:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100c83:	bf 00 00 00 00       	mov    $0x0,%edi
f0100c88:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c8b:	e9 f9 00 00 00       	jmp    f0100d89 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100c90:	68 d0 77 10 f0       	push   $0xf01077d0
f0100c95:	68 dc 77 10 f0       	push   $0xf01077dc
f0100c9a:	68 3e 03 00 00       	push   $0x33e
f0100c9f:	68 b6 77 10 f0       	push   $0xf01077b6
f0100ca4:	e8 97 f3 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100ca9:	68 f1 77 10 f0       	push   $0xf01077f1
f0100cae:	68 dc 77 10 f0       	push   $0xf01077dc
f0100cb3:	68 3f 03 00 00       	push   $0x33f
f0100cb8:	68 b6 77 10 f0       	push   $0xf01077b6
f0100cbd:	e8 7e f3 ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100cc2:	68 ec 7a 10 f0       	push   $0xf0107aec
f0100cc7:	68 dc 77 10 f0       	push   $0xf01077dc
f0100ccc:	68 40 03 00 00       	push   $0x340
f0100cd1:	68 b6 77 10 f0       	push   $0xf01077b6
f0100cd6:	e8 65 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100cdb:	68 05 78 10 f0       	push   $0xf0107805
f0100ce0:	68 dc 77 10 f0       	push   $0xf01077dc
f0100ce5:	68 43 03 00 00       	push   $0x343
f0100cea:	68 b6 77 10 f0       	push   $0xf01077b6
f0100cef:	e8 4c f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100cf4:	68 16 78 10 f0       	push   $0xf0107816
f0100cf9:	68 dc 77 10 f0       	push   $0xf01077dc
f0100cfe:	68 44 03 00 00       	push   $0x344
f0100d03:	68 b6 77 10 f0       	push   $0xf01077b6
f0100d08:	e8 33 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d0d:	68 20 7b 10 f0       	push   $0xf0107b20
f0100d12:	68 dc 77 10 f0       	push   $0xf01077dc
f0100d17:	68 45 03 00 00       	push   $0x345
f0100d1c:	68 b6 77 10 f0       	push   $0xf01077b6
f0100d21:	e8 1a f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d26:	68 2f 78 10 f0       	push   $0xf010782f
f0100d2b:	68 dc 77 10 f0       	push   $0xf01077dc
f0100d30:	68 46 03 00 00       	push   $0x346
f0100d35:	68 b6 77 10 f0       	push   $0xf01077b6
f0100d3a:	e8 01 f3 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100d3f:	89 c3                	mov    %eax,%ebx
f0100d41:	c1 eb 0c             	shr    $0xc,%ebx
f0100d44:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0100d47:	76 0f                	jbe    f0100d58 <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f0100d49:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d4e:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0100d51:	77 17                	ja     f0100d6a <check_page_free_list+0x19f>
			++nfree_extmem;
f0100d53:	83 c7 01             	add    $0x1,%edi
f0100d56:	eb 2f                	jmp    f0100d87 <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d58:	50                   	push   %eax
f0100d59:	68 24 72 10 f0       	push   $0xf0107224
f0100d5e:	6a 58                	push   $0x58
f0100d60:	68 c2 77 10 f0       	push   $0xf01077c2
f0100d65:	e8 d6 f2 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d6a:	68 44 7b 10 f0       	push   $0xf0107b44
f0100d6f:	68 dc 77 10 f0       	push   $0xf01077dc
f0100d74:	68 47 03 00 00       	push   $0x347
f0100d79:	68 b6 77 10 f0       	push   $0xf01077b6
f0100d7e:	e8 bd f2 ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f0100d83:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d87:	8b 12                	mov    (%edx),%edx
f0100d89:	85 d2                	test   %edx,%edx
f0100d8b:	74 74                	je     f0100e01 <check_page_free_list+0x236>
		assert(pp >= pages);
f0100d8d:	39 d1                	cmp    %edx,%ecx
f0100d8f:	0f 87 fb fe ff ff    	ja     f0100c90 <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f0100d95:	39 d6                	cmp    %edx,%esi
f0100d97:	0f 86 0c ff ff ff    	jbe    f0100ca9 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d9d:	89 d0                	mov    %edx,%eax
f0100d9f:	29 c8                	sub    %ecx,%eax
f0100da1:	a8 07                	test   $0x7,%al
f0100da3:	0f 85 19 ff ff ff    	jne    f0100cc2 <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f0100da9:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100dac:	c1 e0 0c             	shl    $0xc,%eax
f0100daf:	0f 84 26 ff ff ff    	je     f0100cdb <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f0100db5:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100dba:	0f 84 34 ff ff ff    	je     f0100cf4 <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100dc0:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100dc5:	0f 84 42 ff ff ff    	je     f0100d0d <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100dcb:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100dd0:	0f 84 50 ff ff ff    	je     f0100d26 <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100dd6:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100ddb:	0f 87 5e ff ff ff    	ja     f0100d3f <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100de1:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100de6:	75 9b                	jne    f0100d83 <check_page_free_list+0x1b8>
f0100de8:	68 49 78 10 f0       	push   $0xf0107849
f0100ded:	68 dc 77 10 f0       	push   $0xf01077dc
f0100df2:	68 49 03 00 00       	push   $0x349
f0100df7:	68 b6 77 10 f0       	push   $0xf01077b6
f0100dfc:	e8 3f f2 ff ff       	call   f0100040 <_panic>
f0100e01:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f0100e04:	85 db                	test   %ebx,%ebx
f0100e06:	7e 19                	jle    f0100e21 <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f0100e08:	85 ff                	test   %edi,%edi
f0100e0a:	7e 2e                	jle    f0100e3a <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0100e0c:	83 ec 0c             	sub    $0xc,%esp
f0100e0f:	68 8c 7b 10 f0       	push   $0xf0107b8c
f0100e14:	e8 1d 2c 00 00       	call   f0103a36 <cprintf>
}
f0100e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e1c:	5b                   	pop    %ebx
f0100e1d:	5e                   	pop    %esi
f0100e1e:	5f                   	pop    %edi
f0100e1f:	5d                   	pop    %ebp
f0100e20:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100e21:	68 66 78 10 f0       	push   $0xf0107866
f0100e26:	68 dc 77 10 f0       	push   $0xf01077dc
f0100e2b:	68 51 03 00 00       	push   $0x351
f0100e30:	68 b6 77 10 f0       	push   $0xf01077b6
f0100e35:	e8 06 f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100e3a:	68 78 78 10 f0       	push   $0xf0107878
f0100e3f:	68 dc 77 10 f0       	push   $0xf01077dc
f0100e44:	68 52 03 00 00       	push   $0x352
f0100e49:	68 b6 77 10 f0       	push   $0xf01077b6
f0100e4e:	e8 ed f1 ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f0100e53:	a1 40 12 2c f0       	mov    0xf02c1240,%eax
f0100e58:	85 c0                	test   %eax,%eax
f0100e5a:	0f 84 8f fd ff ff    	je     f0100bef <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100e60:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100e63:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100e66:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100e69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100e6c:	89 c2                	mov    %eax,%edx
f0100e6e:	2b 15 a0 1e 2c f0    	sub    0xf02c1ea0,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100e74:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100e7a:	0f 95 c2             	setne  %dl
f0100e7d:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100e80:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100e84:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100e86:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e8a:	8b 00                	mov    (%eax),%eax
f0100e8c:	85 c0                	test   %eax,%eax
f0100e8e:	75 dc                	jne    f0100e6c <check_page_free_list+0x2a1>
		*tp[1] = 0;
f0100e90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100e99:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100e9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e9f:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100ea1:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100ea4:	a3 40 12 2c f0       	mov    %eax,0xf02c1240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ea9:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100eae:	8b 1d 40 12 2c f0    	mov    0xf02c1240,%ebx
f0100eb4:	e9 61 fd ff ff       	jmp    f0100c1a <check_page_free_list+0x4f>

f0100eb9 <page_init>:
{
f0100eb9:	f3 0f 1e fb          	endbr32 
f0100ebd:	55                   	push   %ebp
f0100ebe:	89 e5                	mov    %esp,%ebp
f0100ec0:	57                   	push   %edi
f0100ec1:	56                   	push   %esi
f0100ec2:	53                   	push   %ebx
f0100ec3:	83 ec 0c             	sub    $0xc,%esp
	pages[0].pp_ref = 1;
f0100ec6:	a1 a0 1e 2c f0       	mov    0xf02c1ea0,%eax
f0100ecb:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	pages[0].pp_link = NULL;
f0100ed1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 1; i < npages_basemem; i++) {
f0100ed7:	8b 35 44 12 2c f0    	mov    0xf02c1244,%esi
f0100edd:	8b 1d 40 12 2c f0    	mov    0xf02c1240,%ebx
f0100ee3:	ba 00 00 00 00       	mov    $0x0,%edx
f0100ee8:	b8 01 00 00 00       	mov    $0x1,%eax
		page_free_list = &pages[i];
f0100eed:	bf 01 00 00 00       	mov    $0x1,%edi
	for (i = 1; i < npages_basemem; i++) {
f0100ef2:	eb 03                	jmp    f0100ef7 <page_init+0x3e>
f0100ef4:	83 c0 01             	add    $0x1,%eax
f0100ef7:	39 c6                	cmp    %eax,%esi
f0100ef9:	76 28                	jbe    f0100f23 <page_init+0x6a>
		if(i == mpentry_index) continue;
f0100efb:	83 f8 07             	cmp    $0x7,%eax
f0100efe:	74 f4                	je     f0100ef4 <page_init+0x3b>
f0100f00:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100f07:	89 d1                	mov    %edx,%ecx
f0100f09:	03 0d a0 1e 2c f0    	add    0xf02c1ea0,%ecx
f0100f0f:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100f15:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0100f17:	89 d3                	mov    %edx,%ebx
f0100f19:	03 1d a0 1e 2c f0    	add    0xf02c1ea0,%ebx
f0100f1f:	89 fa                	mov    %edi,%edx
f0100f21:	eb d1                	jmp    f0100ef4 <page_init+0x3b>
f0100f23:	84 d2                	test   %dl,%dl
f0100f25:	74 06                	je     f0100f2d <page_init+0x74>
f0100f27:	89 1d 40 12 2c f0    	mov    %ebx,0xf02c1240
	for(i = io; i < ex; i++){
f0100f2d:	b8 a0 00 00 00       	mov    $0xa0,%eax
		pages[i].pp_ref = 1;
f0100f32:	8b 15 a0 1e 2c f0    	mov    0xf02c1ea0,%edx
f0100f38:	8d 14 c2             	lea    (%edx,%eax,8),%edx
f0100f3b:	66 c7 42 04 01 00    	movw   $0x1,0x4(%edx)
		pages[i].pp_link = NULL;
f0100f41:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	for(i = io; i < ex; i++){
f0100f47:	83 c0 01             	add    $0x1,%eax
f0100f4a:	3d ff 00 00 00       	cmp    $0xff,%eax
f0100f4f:	77 07                	ja     f0100f58 <page_init+0x9f>
		if(i == mpentry_index) continue;
f0100f51:	83 f8 07             	cmp    $0x7,%eax
f0100f54:	75 dc                	jne    f0100f32 <page_init+0x79>
f0100f56:	eb ef                	jmp    f0100f47 <page_init+0x8e>
	size_t fisrt_page = PADDR(boot_alloc(0)) / PGSIZE;
f0100f58:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f5d:	e8 87 fb ff ff       	call   f0100ae9 <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100f62:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100f67:	76 0f                	jbe    f0100f78 <page_init+0xbf>
	return (physaddr_t)kva - KERNBASE;
f0100f69:	05 00 00 00 10       	add    $0x10000000,%eax
f0100f6e:	c1 e8 0c             	shr    $0xc,%eax
	for(i = ex; i < fisrt_page; i++){
f0100f71:	ba 00 01 00 00       	mov    $0x100,%edx
f0100f76:	eb 18                	jmp    f0100f90 <page_init+0xd7>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100f78:	50                   	push   %eax
f0100f79:	68 48 72 10 f0       	push   $0xf0107248
f0100f7e:	68 70 01 00 00       	push   $0x170
f0100f83:	68 b6 77 10 f0       	push   $0xf01077b6
f0100f88:	e8 b3 f0 ff ff       	call   f0100040 <_panic>
f0100f8d:	83 c2 01             	add    $0x1,%edx
f0100f90:	39 c2                	cmp    %eax,%edx
f0100f92:	73 1c                	jae    f0100fb0 <page_init+0xf7>
		if(i == mpentry_index) continue;
f0100f94:	83 fa 07             	cmp    $0x7,%edx
f0100f97:	74 f4                	je     f0100f8d <page_init+0xd4>
		pages[i].pp_ref = 1;
f0100f99:	8b 0d a0 1e 2c f0    	mov    0xf02c1ea0,%ecx
f0100f9f:	8d 0c d1             	lea    (%ecx,%edx,8),%ecx
f0100fa2:	66 c7 41 04 01 00    	movw   $0x1,0x4(%ecx)
		pages[i].pp_link = NULL;
f0100fa8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f0100fae:	eb dd                	jmp    f0100f8d <page_init+0xd4>
f0100fb0:	8b 1d 40 12 2c f0    	mov    0xf02c1240,%ebx
	for(i = ex; i < fisrt_page; i++){
f0100fb6:	ba 00 00 00 00       	mov    $0x0,%edx
		page_free_list = &pages[i];
f0100fbb:	be 01 00 00 00       	mov    $0x1,%esi
f0100fc0:	eb 24                	jmp    f0100fe6 <page_init+0x12d>
f0100fc2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100fc9:	89 d1                	mov    %edx,%ecx
f0100fcb:	03 0d a0 1e 2c f0    	add    0xf02c1ea0,%ecx
f0100fd1:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100fd7:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0100fd9:	89 d3                	mov    %edx,%ebx
f0100fdb:	03 1d a0 1e 2c f0    	add    0xf02c1ea0,%ebx
f0100fe1:	89 f2                	mov    %esi,%edx
	for(i = fisrt_page; i < npages; i++){
f0100fe3:	83 c0 01             	add    $0x1,%eax
f0100fe6:	39 05 98 1e 2c f0    	cmp    %eax,0xf02c1e98
f0100fec:	76 07                	jbe    f0100ff5 <page_init+0x13c>
		if(i == mpentry_index) continue;
f0100fee:	83 f8 07             	cmp    $0x7,%eax
f0100ff1:	75 cf                	jne    f0100fc2 <page_init+0x109>
f0100ff3:	eb ee                	jmp    f0100fe3 <page_init+0x12a>
f0100ff5:	84 d2                	test   %dl,%dl
f0100ff7:	74 06                	je     f0100fff <page_init+0x146>
f0100ff9:	89 1d 40 12 2c f0    	mov    %ebx,0xf02c1240
}
f0100fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101002:	5b                   	pop    %ebx
f0101003:	5e                   	pop    %esi
f0101004:	5f                   	pop    %edi
f0101005:	5d                   	pop    %ebp
f0101006:	c3                   	ret    

f0101007 <page_alloc>:
{
f0101007:	f3 0f 1e fb          	endbr32 
f010100b:	55                   	push   %ebp
f010100c:	89 e5                	mov    %esp,%ebp
f010100e:	53                   	push   %ebx
f010100f:	83 ec 04             	sub    $0x4,%esp
	if(!page_free_list) {
f0101012:	8b 1d 40 12 2c f0    	mov    0xf02c1240,%ebx
f0101018:	85 db                	test   %ebx,%ebx
f010101a:	74 1a                	je     f0101036 <page_alloc+0x2f>
	page_free_list = page_free_list->pp_link;
f010101c:	8b 03                	mov    (%ebx),%eax
f010101e:	a3 40 12 2c f0       	mov    %eax,0xf02c1240
	pp->pp_link = NULL;
f0101023:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags && ALLOC_ZERO){
f0101029:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f010102d:	75 19                	jne    f0101048 <page_alloc+0x41>
}
f010102f:	89 d8                	mov    %ebx,%eax
f0101031:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101034:	c9                   	leave  
f0101035:	c3                   	ret    
		cprintf("page_alloc: out of free memory\n");
f0101036:	83 ec 0c             	sub    $0xc,%esp
f0101039:	68 b0 7b 10 f0       	push   $0xf0107bb0
f010103e:	e8 f3 29 00 00       	call   f0103a36 <cprintf>
		return NULL;
f0101043:	83 c4 10             	add    $0x10,%esp
f0101046:	eb e7                	jmp    f010102f <page_alloc+0x28>
	return (pp - pages) << PGSHIFT;
f0101048:	89 d8                	mov    %ebx,%eax
f010104a:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0101050:	c1 f8 03             	sar    $0x3,%eax
f0101053:	89 c2                	mov    %eax,%edx
f0101055:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101058:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010105d:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f0101063:	73 1b                	jae    f0101080 <page_alloc+0x79>
		memset(page2kva(pp), '\0', PGSIZE);
f0101065:	83 ec 04             	sub    $0x4,%esp
f0101068:	68 00 10 00 00       	push   $0x1000
f010106d:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f010106f:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101075:	52                   	push   %edx
f0101076:	e8 4e 4b 00 00       	call   f0105bc9 <memset>
f010107b:	83 c4 10             	add    $0x10,%esp
f010107e:	eb af                	jmp    f010102f <page_alloc+0x28>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101080:	52                   	push   %edx
f0101081:	68 24 72 10 f0       	push   $0xf0107224
f0101086:	6a 58                	push   $0x58
f0101088:	68 c2 77 10 f0       	push   $0xf01077c2
f010108d:	e8 ae ef ff ff       	call   f0100040 <_panic>

f0101092 <page_free>:
{
f0101092:	f3 0f 1e fb          	endbr32 
f0101096:	55                   	push   %ebp
f0101097:	89 e5                	mov    %esp,%ebp
f0101099:	83 ec 08             	sub    $0x8,%esp
f010109c:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0){
f010109f:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01010a4:	75 14                	jne    f01010ba <page_free+0x28>
	}else if(pp->pp_link != NULL){
f01010a6:	83 38 00             	cmpl   $0x0,(%eax)
f01010a9:	75 26                	jne    f01010d1 <page_free+0x3f>
		pp->pp_link = page_free_list;
f01010ab:	8b 15 40 12 2c f0    	mov    0xf02c1240,%edx
f01010b1:	89 10                	mov    %edx,(%eax)
		page_free_list = pp;
f01010b3:	a3 40 12 2c f0       	mov    %eax,0xf02c1240
}
f01010b8:	c9                   	leave  
f01010b9:	c3                   	ret    
		panic("page_free: pp->pp_ref is nonzero\n");
f01010ba:	83 ec 04             	sub    $0x4,%esp
f01010bd:	68 d0 7b 10 f0       	push   $0xf0107bd0
f01010c2:	68 aa 01 00 00       	push   $0x1aa
f01010c7:	68 b6 77 10 f0       	push   $0xf01077b6
f01010cc:	e8 6f ef ff ff       	call   f0100040 <_panic>
		panic("page_free: pp->pp_link is NULL\n");
f01010d1:	83 ec 04             	sub    $0x4,%esp
f01010d4:	68 f4 7b 10 f0       	push   $0xf0107bf4
f01010d9:	68 ac 01 00 00       	push   $0x1ac
f01010de:	68 b6 77 10 f0       	push   $0xf01077b6
f01010e3:	e8 58 ef ff ff       	call   f0100040 <_panic>

f01010e8 <page_decref>:
{
f01010e8:	f3 0f 1e fb          	endbr32 
f01010ec:	55                   	push   %ebp
f01010ed:	89 e5                	mov    %esp,%ebp
f01010ef:	83 ec 08             	sub    $0x8,%esp
f01010f2:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f01010f5:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01010f9:	83 e8 01             	sub    $0x1,%eax
f01010fc:	66 89 42 04          	mov    %ax,0x4(%edx)
f0101100:	66 85 c0             	test   %ax,%ax
f0101103:	74 02                	je     f0101107 <page_decref+0x1f>
}
f0101105:	c9                   	leave  
f0101106:	c3                   	ret    
		page_free(pp);
f0101107:	83 ec 0c             	sub    $0xc,%esp
f010110a:	52                   	push   %edx
f010110b:	e8 82 ff ff ff       	call   f0101092 <page_free>
f0101110:	83 c4 10             	add    $0x10,%esp
}
f0101113:	eb f0                	jmp    f0101105 <page_decref+0x1d>

f0101115 <pgdir_walk>:
{
f0101115:	f3 0f 1e fb          	endbr32 
f0101119:	55                   	push   %ebp
f010111a:	89 e5                	mov    %esp,%ebp
f010111c:	56                   	push   %esi
f010111d:	53                   	push   %ebx
f010111e:	8b 45 0c             	mov    0xc(%ebp),%eax
	uint32_t ptx = PTX(va);		//页表项索引
f0101121:	89 c6                	mov    %eax,%esi
f0101123:	c1 ee 0c             	shr    $0xc,%esi
f0101126:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	uint32_t pdx = PDX(va);		//页目录项索引
f010112c:	c1 e8 16             	shr    $0x16,%eax
	pde = &pgdir[pdx];			//获取页目录项
f010112f:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
f0101136:	03 5d 08             	add    0x8(%ebp),%ebx
	if((*pde) & PTE_P){
f0101139:	8b 03                	mov    (%ebx),%eax
f010113b:	a8 01                	test   $0x1,%al
f010113d:	74 38                	je     f0101177 <pgdir_walk+0x62>
		pte = (KADDR(PTE_ADDR(*pde)));
f010113f:	89 c2                	mov    %eax,%edx
f0101141:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101147:	c1 e8 0c             	shr    $0xc,%eax
f010114a:	39 05 98 1e 2c f0    	cmp    %eax,0xf02c1e98
f0101150:	76 10                	jbe    f0101162 <pgdir_walk+0x4d>
	return (void *)(pa + KERNBASE);
f0101152:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	return (pte_t*)&pte[ptx];
f0101158:	8d 04 b0             	lea    (%eax,%esi,4),%eax
}
f010115b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010115e:	5b                   	pop    %ebx
f010115f:	5e                   	pop    %esi
f0101160:	5d                   	pop    %ebp
f0101161:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101162:	52                   	push   %edx
f0101163:	68 24 72 10 f0       	push   $0xf0107224
f0101168:	68 e6 01 00 00       	push   $0x1e6
f010116d:	68 b6 77 10 f0       	push   $0xf01077b6
f0101172:	e8 c9 ee ff ff       	call   f0100040 <_panic>
		if(!create){
f0101177:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010117b:	74 6f                	je     f01011ec <pgdir_walk+0xd7>
		if(!(pp = page_alloc(ALLOC_ZERO))){
f010117d:	83 ec 0c             	sub    $0xc,%esp
f0101180:	6a 01                	push   $0x1
f0101182:	e8 80 fe ff ff       	call   f0101007 <page_alloc>
f0101187:	83 c4 10             	add    $0x10,%esp
f010118a:	85 c0                	test   %eax,%eax
f010118c:	74 cd                	je     f010115b <pgdir_walk+0x46>
		pp->pp_ref++;
f010118e:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101193:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0101199:	c1 f8 03             	sar    $0x3,%eax
f010119c:	89 c2                	mov    %eax,%edx
f010119e:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01011a1:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01011a6:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f01011ac:	73 17                	jae    f01011c5 <pgdir_walk+0xb0>
	return (void *)(pa + KERNBASE);
f01011ae:	8d 8a 00 00 00 f0    	lea    -0x10000000(%edx),%ecx
f01011b4:	89 c8                	mov    %ecx,%eax
	if ((uint32_t)kva < KERNBASE)
f01011b6:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f01011bc:	76 19                	jbe    f01011d7 <pgdir_walk+0xc2>
		*pde = PADDR(pte) | PTE_P | PTE_W | PTE_U;
f01011be:	83 ca 07             	or     $0x7,%edx
f01011c1:	89 13                	mov    %edx,(%ebx)
f01011c3:	eb 93                	jmp    f0101158 <pgdir_walk+0x43>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01011c5:	52                   	push   %edx
f01011c6:	68 24 72 10 f0       	push   $0xf0107224
f01011cb:	6a 58                	push   $0x58
f01011cd:	68 c2 77 10 f0       	push   $0xf01077c2
f01011d2:	e8 69 ee ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01011d7:	51                   	push   %ecx
f01011d8:	68 48 72 10 f0       	push   $0xf0107248
f01011dd:	68 f7 01 00 00       	push   $0x1f7
f01011e2:	68 b6 77 10 f0       	push   $0xf01077b6
f01011e7:	e8 54 ee ff ff       	call   f0100040 <_panic>
			return NULL;
f01011ec:	b8 00 00 00 00       	mov    $0x0,%eax
f01011f1:	e9 65 ff ff ff       	jmp    f010115b <pgdir_walk+0x46>

f01011f6 <boot_map_region>:
{
f01011f6:	55                   	push   %ebp
f01011f7:	89 e5                	mov    %esp,%ebp
f01011f9:	57                   	push   %edi
f01011fa:	56                   	push   %esi
f01011fb:	53                   	push   %ebx
f01011fc:	83 ec 1c             	sub    $0x1c,%esp
f01011ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101202:	8b 45 08             	mov    0x8(%ebp),%eax
	size_t pgs = (size + PGSIZE - 1) / PGSIZE;
f0101205:	8d b1 ff 0f 00 00    	lea    0xfff(%ecx),%esi
f010120b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f0101211:	01 c6                	add    %eax,%esi
	for(size_t i = 0; i < pgs; i++){
f0101213:	89 c3                	mov    %eax,%ebx
		pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
f0101215:	89 d7                	mov    %edx,%edi
f0101217:	29 c7                	sub    %eax,%edi
	for(size_t i = 0; i < pgs; i++){
f0101219:	39 f3                	cmp    %esi,%ebx
f010121b:	74 28                	je     f0101245 <boot_map_region+0x4f>
		pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
f010121d:	83 ec 04             	sub    $0x4,%esp
f0101220:	6a 01                	push   $0x1
f0101222:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
f0101225:	50                   	push   %eax
f0101226:	ff 75 e4             	pushl  -0x1c(%ebp)
f0101229:	e8 e7 fe ff ff       	call   f0101115 <pgdir_walk>
f010122e:	89 c2                	mov    %eax,%edx
		*pte = pa | PTE_P | perm;
f0101230:	89 d8                	mov    %ebx,%eax
f0101232:	0b 45 0c             	or     0xc(%ebp),%eax
f0101235:	83 c8 01             	or     $0x1,%eax
f0101238:	89 02                	mov    %eax,(%edx)
		pa += PGSIZE;
f010123a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101240:	83 c4 10             	add    $0x10,%esp
f0101243:	eb d4                	jmp    f0101219 <boot_map_region+0x23>
}
f0101245:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101248:	5b                   	pop    %ebx
f0101249:	5e                   	pop    %esi
f010124a:	5f                   	pop    %edi
f010124b:	5d                   	pop    %ebp
f010124c:	c3                   	ret    

f010124d <page_lookup>:
{
f010124d:	f3 0f 1e fb          	endbr32 
f0101251:	55                   	push   %ebp
f0101252:	89 e5                	mov    %esp,%ebp
f0101254:	53                   	push   %ebx
f0101255:	83 ec 08             	sub    $0x8,%esp
f0101258:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t* pte = pgdir_walk(pgdir, va, false);
f010125b:	6a 00                	push   $0x0
f010125d:	ff 75 0c             	pushl  0xc(%ebp)
f0101260:	ff 75 08             	pushl  0x8(%ebp)
f0101263:	e8 ad fe ff ff       	call   f0101115 <pgdir_walk>
	if(!pte || !((*pte) & PTE_P)){
f0101268:	83 c4 10             	add    $0x10,%esp
f010126b:	85 c0                	test   %eax,%eax
f010126d:	74 26                	je     f0101295 <page_lookup+0x48>
f010126f:	f6 00 01             	testb  $0x1,(%eax)
f0101272:	74 21                	je     f0101295 <page_lookup+0x48>
	if(pte_store != NULL){
f0101274:	85 db                	test   %ebx,%ebx
f0101276:	74 02                	je     f010127a <page_lookup+0x2d>
		*pte_store = pte;
f0101278:	89 03                	mov    %eax,(%ebx)
f010127a:	8b 00                	mov    (%eax),%eax
f010127c:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010127f:	39 05 98 1e 2c f0    	cmp    %eax,0xf02c1e98
f0101285:	76 25                	jbe    f01012ac <page_lookup+0x5f>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101287:	8b 15 a0 1e 2c f0    	mov    0xf02c1ea0,%edx
f010128d:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101290:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101293:	c9                   	leave  
f0101294:	c3                   	ret    
		cprintf("page_lookup: can not find out the page mapped at virtual address 'va'.\n");
f0101295:	83 ec 0c             	sub    $0xc,%esp
f0101298:	68 14 7c 10 f0       	push   $0xf0107c14
f010129d:	e8 94 27 00 00       	call   f0103a36 <cprintf>
		return NULL;
f01012a2:	83 c4 10             	add    $0x10,%esp
f01012a5:	b8 00 00 00 00       	mov    $0x0,%eax
f01012aa:	eb e4                	jmp    f0101290 <page_lookup+0x43>
		panic("pa2page called with invalid pa");
f01012ac:	83 ec 04             	sub    $0x4,%esp
f01012af:	68 5c 7c 10 f0       	push   $0xf0107c5c
f01012b4:	6a 51                	push   $0x51
f01012b6:	68 c2 77 10 f0       	push   $0xf01077c2
f01012bb:	e8 80 ed ff ff       	call   f0100040 <_panic>

f01012c0 <tlb_invalidate>:
{
f01012c0:	f3 0f 1e fb          	endbr32 
f01012c4:	55                   	push   %ebp
f01012c5:	89 e5                	mov    %esp,%ebp
f01012c7:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f01012ca:	e8 1b 4f 00 00       	call   f01061ea <cpunum>
f01012cf:	6b c0 74             	imul   $0x74,%eax,%eax
f01012d2:	83 b8 28 20 2c f0 00 	cmpl   $0x0,-0xfd3dfd8(%eax)
f01012d9:	74 16                	je     f01012f1 <tlb_invalidate+0x31>
f01012db:	e8 0a 4f 00 00       	call   f01061ea <cpunum>
f01012e0:	6b c0 74             	imul   $0x74,%eax,%eax
f01012e3:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f01012e9:	8b 55 08             	mov    0x8(%ebp),%edx
f01012ec:	39 50 60             	cmp    %edx,0x60(%eax)
f01012ef:	75 06                	jne    f01012f7 <tlb_invalidate+0x37>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01012f4:	0f 01 38             	invlpg (%eax)
}
f01012f7:	c9                   	leave  
f01012f8:	c3                   	ret    

f01012f9 <page_remove>:
{
f01012f9:	f3 0f 1e fb          	endbr32 
f01012fd:	55                   	push   %ebp
f01012fe:	89 e5                	mov    %esp,%ebp
f0101300:	56                   	push   %esi
f0101301:	53                   	push   %ebx
f0101302:	83 ec 14             	sub    $0x14,%esp
f0101305:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101308:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo* pp = page_lookup(pgdir, va, &pte);
f010130b:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010130e:	50                   	push   %eax
f010130f:	56                   	push   %esi
f0101310:	53                   	push   %ebx
f0101311:	e8 37 ff ff ff       	call   f010124d <page_lookup>
	if(pp){
f0101316:	83 c4 10             	add    $0x10,%esp
f0101319:	85 c0                	test   %eax,%eax
f010131b:	74 1f                	je     f010133c <page_remove+0x43>
		page_decref(pp);
f010131d:	83 ec 0c             	sub    $0xc,%esp
f0101320:	50                   	push   %eax
f0101321:	e8 c2 fd ff ff       	call   f01010e8 <page_decref>
		*pte = 0;
f0101326:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101329:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, va);
f010132f:	83 c4 08             	add    $0x8,%esp
f0101332:	56                   	push   %esi
f0101333:	53                   	push   %ebx
f0101334:	e8 87 ff ff ff       	call   f01012c0 <tlb_invalidate>
f0101339:	83 c4 10             	add    $0x10,%esp
}
f010133c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010133f:	5b                   	pop    %ebx
f0101340:	5e                   	pop    %esi
f0101341:	5d                   	pop    %ebp
f0101342:	c3                   	ret    

f0101343 <page_insert>:
{
f0101343:	f3 0f 1e fb          	endbr32 
f0101347:	55                   	push   %ebp
f0101348:	89 e5                	mov    %esp,%ebp
f010134a:	57                   	push   %edi
f010134b:	56                   	push   %esi
f010134c:	53                   	push   %ebx
f010134d:	83 ec 10             	sub    $0x10,%esp
f0101350:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101353:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t* pte = pgdir_walk(pgdir, va, true);
f0101356:	6a 01                	push   $0x1
f0101358:	ff 75 10             	pushl  0x10(%ebp)
f010135b:	57                   	push   %edi
f010135c:	e8 b4 fd ff ff       	call   f0101115 <pgdir_walk>
	if(!pte){
f0101361:	83 c4 10             	add    $0x10,%esp
f0101364:	85 c0                	test   %eax,%eax
f0101366:	74 67                	je     f01013cf <page_insert+0x8c>
f0101368:	89 c6                	mov    %eax,%esi
	if((*pte) & PTE_P){
f010136a:	8b 00                	mov    (%eax),%eax
f010136c:	a8 01                	test   $0x1,%al
f010136e:	74 1c                	je     f010138c <page_insert+0x49>
		if(PTE_ADDR(*pte) == page2pa(pp)){
f0101370:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	return (pp - pages) << PGSHIFT;
f0101375:	89 da                	mov    %ebx,%edx
f0101377:	2b 15 a0 1e 2c f0    	sub    0xf02c1ea0,%edx
f010137d:	c1 fa 03             	sar    $0x3,%edx
f0101380:	c1 e2 0c             	shl    $0xc,%edx
f0101383:	39 d0                	cmp    %edx,%eax
f0101385:	75 37                	jne    f01013be <page_insert+0x7b>
			pp->pp_ref--;
f0101387:	66 83 6b 04 01       	subw   $0x1,0x4(%ebx)
	pp->pp_ref++;
f010138c:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
f0101391:	2b 1d a0 1e 2c f0    	sub    0xf02c1ea0,%ebx
f0101397:	c1 fb 03             	sar    $0x3,%ebx
f010139a:	c1 e3 0c             	shl    $0xc,%ebx
	*pte = page2pa(pp) | perm | PTE_P;
f010139d:	0b 5d 14             	or     0x14(%ebp),%ebx
f01013a0:	83 cb 01             	or     $0x1,%ebx
f01013a3:	89 1e                	mov    %ebx,(%esi)
	pgdir[PDX(va)] |= perm;
f01013a5:	8b 45 10             	mov    0x10(%ebp),%eax
f01013a8:	c1 e8 16             	shr    $0x16,%eax
f01013ab:	8b 4d 14             	mov    0x14(%ebp),%ecx
f01013ae:	09 0c 87             	or     %ecx,(%edi,%eax,4)
	return 0;
f01013b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01013b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01013b9:	5b                   	pop    %ebx
f01013ba:	5e                   	pop    %esi
f01013bb:	5f                   	pop    %edi
f01013bc:	5d                   	pop    %ebp
f01013bd:	c3                   	ret    
			page_remove(pgdir, va);
f01013be:	83 ec 08             	sub    $0x8,%esp
f01013c1:	ff 75 10             	pushl  0x10(%ebp)
f01013c4:	57                   	push   %edi
f01013c5:	e8 2f ff ff ff       	call   f01012f9 <page_remove>
f01013ca:	83 c4 10             	add    $0x10,%esp
f01013cd:	eb bd                	jmp    f010138c <page_insert+0x49>
		return -E_NO_MEM;
f01013cf:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01013d4:	eb e0                	jmp    f01013b6 <page_insert+0x73>

f01013d6 <mmio_map_region>:
{
f01013d6:	f3 0f 1e fb          	endbr32 
f01013da:	55                   	push   %ebp
f01013db:	89 e5                	mov    %esp,%ebp
f01013dd:	53                   	push   %ebx
f01013de:	83 ec 04             	sub    $0x4,%esp
	size = ROUNDUP(size, PGSIZE);
f01013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01013e4:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f01013ea:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if(size + base > MMIOLIM){
f01013f0:	8b 15 00 63 12 f0    	mov    0xf0126300,%edx
f01013f6:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
f01013f9:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f01013fe:	77 26                	ja     f0101426 <mmio_map_region+0x50>
	boot_map_region(kern_pgdir, base, size, pa, PTE_W | PTE_PCD | PTE_PWT);
f0101400:	83 ec 08             	sub    $0x8,%esp
f0101403:	6a 1a                	push   $0x1a
f0101405:	ff 75 08             	pushl  0x8(%ebp)
f0101408:	89 d9                	mov    %ebx,%ecx
f010140a:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f010140f:	e8 e2 fd ff ff       	call   f01011f6 <boot_map_region>
	base += size;
f0101414:	a1 00 63 12 f0       	mov    0xf0126300,%eax
f0101419:	01 c3                	add    %eax,%ebx
f010141b:	89 1d 00 63 12 f0    	mov    %ebx,0xf0126300
}
f0101421:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101424:	c9                   	leave  
f0101425:	c3                   	ret    
		panic("MMIO_MAP_REGION failed: memory overflow MMIOLIM\n");
f0101426:	83 ec 04             	sub    $0x4,%esp
f0101429:	68 7c 7c 10 f0       	push   $0xf0107c7c
f010142e:	68 cd 02 00 00       	push   $0x2cd
f0101433:	68 b6 77 10 f0       	push   $0xf01077b6
f0101438:	e8 03 ec ff ff       	call   f0100040 <_panic>

f010143d <mem_init>:
{
f010143d:	f3 0f 1e fb          	endbr32 
f0101441:	55                   	push   %ebp
f0101442:	89 e5                	mov    %esp,%ebp
f0101444:	57                   	push   %edi
f0101445:	56                   	push   %esi
f0101446:	53                   	push   %ebx
f0101447:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f010144a:	b8 15 00 00 00       	mov    $0x15,%eax
f010144f:	e8 eb f6 ff ff       	call   f0100b3f <nvram_read>
f0101454:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0101456:	b8 17 00 00 00       	mov    $0x17,%eax
f010145b:	e8 df f6 ff ff       	call   f0100b3f <nvram_read>
f0101460:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101462:	b8 34 00 00 00       	mov    $0x34,%eax
f0101467:	e8 d3 f6 ff ff       	call   f0100b3f <nvram_read>
	if (ext16mem)
f010146c:	c1 e0 06             	shl    $0x6,%eax
f010146f:	0f 84 ea 00 00 00    	je     f010155f <mem_init+0x122>
		totalmem = 16 * 1024 + ext16mem;
f0101475:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f010147a:	89 c2                	mov    %eax,%edx
f010147c:	c1 ea 02             	shr    $0x2,%edx
f010147f:	89 15 98 1e 2c f0    	mov    %edx,0xf02c1e98
	npages_basemem = basemem / (PGSIZE / 1024);
f0101485:	89 da                	mov    %ebx,%edx
f0101487:	c1 ea 02             	shr    $0x2,%edx
f010148a:	89 15 44 12 2c f0    	mov    %edx,0xf02c1244
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101490:	89 c2                	mov    %eax,%edx
f0101492:	29 da                	sub    %ebx,%edx
f0101494:	52                   	push   %edx
f0101495:	53                   	push   %ebx
f0101496:	50                   	push   %eax
f0101497:	68 b0 7c 10 f0       	push   $0xf0107cb0
f010149c:	e8 95 25 00 00       	call   f0103a36 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01014a1:	b8 00 10 00 00       	mov    $0x1000,%eax
f01014a6:	e8 3e f6 ff ff       	call   f0100ae9 <boot_alloc>
f01014ab:	a3 9c 1e 2c f0       	mov    %eax,0xf02c1e9c
	memset(kern_pgdir, 0, PGSIZE);
f01014b0:	83 c4 0c             	add    $0xc,%esp
f01014b3:	68 00 10 00 00       	push   $0x1000
f01014b8:	6a 00                	push   $0x0
f01014ba:	50                   	push   %eax
f01014bb:	e8 09 47 00 00       	call   f0105bc9 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01014c0:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
	if ((uint32_t)kva < KERNBASE)
f01014c5:	83 c4 10             	add    $0x10,%esp
f01014c8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01014cd:	0f 86 9c 00 00 00    	jbe    f010156f <mem_init+0x132>
	return (physaddr_t)kva - KERNBASE;
f01014d3:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01014d9:	83 ca 05             	or     $0x5,%edx
f01014dc:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);
f01014e2:	a1 98 1e 2c f0       	mov    0xf02c1e98,%eax
f01014e7:	c1 e0 03             	shl    $0x3,%eax
f01014ea:	e8 fa f5 ff ff       	call   f0100ae9 <boot_alloc>
f01014ef:	a3 a0 1e 2c f0       	mov    %eax,0xf02c1ea0
	memset(pages, 0, sizeof(struct PageInfo) * npages);
f01014f4:	83 ec 04             	sub    $0x4,%esp
f01014f7:	8b 0d 98 1e 2c f0    	mov    0xf02c1e98,%ecx
f01014fd:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f0101504:	52                   	push   %edx
f0101505:	6a 00                	push   $0x0
f0101507:	50                   	push   %eax
f0101508:	e8 bc 46 00 00       	call   f0105bc9 <memset>
	envs = (struct Env*)boot_alloc(sizeof(struct Env) * NENV);
f010150d:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0101512:	e8 d2 f5 ff ff       	call   f0100ae9 <boot_alloc>
f0101517:	a3 48 12 2c f0       	mov    %eax,0xf02c1248
	memset(envs, 0, sizeof(struct Env) * NENV);
f010151c:	83 c4 0c             	add    $0xc,%esp
f010151f:	68 00 f0 01 00       	push   $0x1f000
f0101524:	6a 00                	push   $0x0
f0101526:	50                   	push   %eax
f0101527:	e8 9d 46 00 00       	call   f0105bc9 <memset>
	page_init();
f010152c:	e8 88 f9 ff ff       	call   f0100eb9 <page_init>
	check_page_free_list(1);
f0101531:	b8 01 00 00 00       	mov    $0x1,%eax
f0101536:	e8 90 f6 ff ff       	call   f0100bcb <check_page_free_list>
	if (!pages)
f010153b:	83 c4 10             	add    $0x10,%esp
f010153e:	83 3d a0 1e 2c f0 00 	cmpl   $0x0,0xf02c1ea0
f0101545:	74 3d                	je     f0101584 <mem_init+0x147>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101547:	a1 40 12 2c f0       	mov    0xf02c1240,%eax
f010154c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0101553:	85 c0                	test   %eax,%eax
f0101555:	74 44                	je     f010159b <mem_init+0x15e>
		++nfree;
f0101557:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010155b:	8b 00                	mov    (%eax),%eax
f010155d:	eb f4                	jmp    f0101553 <mem_init+0x116>
		totalmem = 1 * 1024 + extmem;
f010155f:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0101565:	85 f6                	test   %esi,%esi
f0101567:	0f 44 c3             	cmove  %ebx,%eax
f010156a:	e9 0b ff ff ff       	jmp    f010147a <mem_init+0x3d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010156f:	50                   	push   %eax
f0101570:	68 48 72 10 f0       	push   $0xf0107248
f0101575:	68 99 00 00 00       	push   $0x99
f010157a:	68 b6 77 10 f0       	push   $0xf01077b6
f010157f:	e8 bc ea ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f0101584:	83 ec 04             	sub    $0x4,%esp
f0101587:	68 89 78 10 f0       	push   $0xf0107889
f010158c:	68 65 03 00 00       	push   $0x365
f0101591:	68 b6 77 10 f0       	push   $0xf01077b6
f0101596:	e8 a5 ea ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f010159b:	83 ec 0c             	sub    $0xc,%esp
f010159e:	6a 00                	push   $0x0
f01015a0:	e8 62 fa ff ff       	call   f0101007 <page_alloc>
f01015a5:	89 c3                	mov    %eax,%ebx
f01015a7:	83 c4 10             	add    $0x10,%esp
f01015aa:	85 c0                	test   %eax,%eax
f01015ac:	0f 84 11 02 00 00    	je     f01017c3 <mem_init+0x386>
	assert((pp1 = page_alloc(0)));
f01015b2:	83 ec 0c             	sub    $0xc,%esp
f01015b5:	6a 00                	push   $0x0
f01015b7:	e8 4b fa ff ff       	call   f0101007 <page_alloc>
f01015bc:	89 c6                	mov    %eax,%esi
f01015be:	83 c4 10             	add    $0x10,%esp
f01015c1:	85 c0                	test   %eax,%eax
f01015c3:	0f 84 13 02 00 00    	je     f01017dc <mem_init+0x39f>
	assert((pp2 = page_alloc(0)));
f01015c9:	83 ec 0c             	sub    $0xc,%esp
f01015cc:	6a 00                	push   $0x0
f01015ce:	e8 34 fa ff ff       	call   f0101007 <page_alloc>
f01015d3:	89 c7                	mov    %eax,%edi
f01015d5:	83 c4 10             	add    $0x10,%esp
f01015d8:	85 c0                	test   %eax,%eax
f01015da:	0f 84 15 02 00 00    	je     f01017f5 <mem_init+0x3b8>
	assert(pp1 && pp1 != pp0);
f01015e0:	39 f3                	cmp    %esi,%ebx
f01015e2:	0f 84 26 02 00 00    	je     f010180e <mem_init+0x3d1>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01015e8:	39 c6                	cmp    %eax,%esi
f01015ea:	0f 84 37 02 00 00    	je     f0101827 <mem_init+0x3ea>
f01015f0:	39 c3                	cmp    %eax,%ebx
f01015f2:	0f 84 2f 02 00 00    	je     f0101827 <mem_init+0x3ea>
	return (pp - pages) << PGSHIFT;
f01015f8:	8b 0d a0 1e 2c f0    	mov    0xf02c1ea0,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f01015fe:	8b 15 98 1e 2c f0    	mov    0xf02c1e98,%edx
f0101604:	c1 e2 0c             	shl    $0xc,%edx
f0101607:	89 d8                	mov    %ebx,%eax
f0101609:	29 c8                	sub    %ecx,%eax
f010160b:	c1 f8 03             	sar    $0x3,%eax
f010160e:	c1 e0 0c             	shl    $0xc,%eax
f0101611:	39 d0                	cmp    %edx,%eax
f0101613:	0f 83 27 02 00 00    	jae    f0101840 <mem_init+0x403>
f0101619:	89 f0                	mov    %esi,%eax
f010161b:	29 c8                	sub    %ecx,%eax
f010161d:	c1 f8 03             	sar    $0x3,%eax
f0101620:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f0101623:	39 c2                	cmp    %eax,%edx
f0101625:	0f 86 2e 02 00 00    	jbe    f0101859 <mem_init+0x41c>
f010162b:	89 f8                	mov    %edi,%eax
f010162d:	29 c8                	sub    %ecx,%eax
f010162f:	c1 f8 03             	sar    $0x3,%eax
f0101632:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f0101635:	39 c2                	cmp    %eax,%edx
f0101637:	0f 86 35 02 00 00    	jbe    f0101872 <mem_init+0x435>
	fl = page_free_list;
f010163d:	a1 40 12 2c f0       	mov    0xf02c1240,%eax
f0101642:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101645:	c7 05 40 12 2c f0 00 	movl   $0x0,0xf02c1240
f010164c:	00 00 00 
	assert(!page_alloc(0));
f010164f:	83 ec 0c             	sub    $0xc,%esp
f0101652:	6a 00                	push   $0x0
f0101654:	e8 ae f9 ff ff       	call   f0101007 <page_alloc>
f0101659:	83 c4 10             	add    $0x10,%esp
f010165c:	85 c0                	test   %eax,%eax
f010165e:	0f 85 27 02 00 00    	jne    f010188b <mem_init+0x44e>
	page_free(pp0);
f0101664:	83 ec 0c             	sub    $0xc,%esp
f0101667:	53                   	push   %ebx
f0101668:	e8 25 fa ff ff       	call   f0101092 <page_free>
	page_free(pp1);
f010166d:	89 34 24             	mov    %esi,(%esp)
f0101670:	e8 1d fa ff ff       	call   f0101092 <page_free>
	page_free(pp2);
f0101675:	89 3c 24             	mov    %edi,(%esp)
f0101678:	e8 15 fa ff ff       	call   f0101092 <page_free>
	assert((pp0 = page_alloc(0)));
f010167d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101684:	e8 7e f9 ff ff       	call   f0101007 <page_alloc>
f0101689:	89 c3                	mov    %eax,%ebx
f010168b:	83 c4 10             	add    $0x10,%esp
f010168e:	85 c0                	test   %eax,%eax
f0101690:	0f 84 0e 02 00 00    	je     f01018a4 <mem_init+0x467>
	assert((pp1 = page_alloc(0)));
f0101696:	83 ec 0c             	sub    $0xc,%esp
f0101699:	6a 00                	push   $0x0
f010169b:	e8 67 f9 ff ff       	call   f0101007 <page_alloc>
f01016a0:	89 c6                	mov    %eax,%esi
f01016a2:	83 c4 10             	add    $0x10,%esp
f01016a5:	85 c0                	test   %eax,%eax
f01016a7:	0f 84 10 02 00 00    	je     f01018bd <mem_init+0x480>
	assert((pp2 = page_alloc(0)));
f01016ad:	83 ec 0c             	sub    $0xc,%esp
f01016b0:	6a 00                	push   $0x0
f01016b2:	e8 50 f9 ff ff       	call   f0101007 <page_alloc>
f01016b7:	89 c7                	mov    %eax,%edi
f01016b9:	83 c4 10             	add    $0x10,%esp
f01016bc:	85 c0                	test   %eax,%eax
f01016be:	0f 84 12 02 00 00    	je     f01018d6 <mem_init+0x499>
	assert(pp1 && pp1 != pp0);
f01016c4:	39 f3                	cmp    %esi,%ebx
f01016c6:	0f 84 23 02 00 00    	je     f01018ef <mem_init+0x4b2>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01016cc:	39 c3                	cmp    %eax,%ebx
f01016ce:	0f 84 34 02 00 00    	je     f0101908 <mem_init+0x4cb>
f01016d4:	39 c6                	cmp    %eax,%esi
f01016d6:	0f 84 2c 02 00 00    	je     f0101908 <mem_init+0x4cb>
	assert(!page_alloc(0));
f01016dc:	83 ec 0c             	sub    $0xc,%esp
f01016df:	6a 00                	push   $0x0
f01016e1:	e8 21 f9 ff ff       	call   f0101007 <page_alloc>
f01016e6:	83 c4 10             	add    $0x10,%esp
f01016e9:	85 c0                	test   %eax,%eax
f01016eb:	0f 85 30 02 00 00    	jne    f0101921 <mem_init+0x4e4>
f01016f1:	89 d8                	mov    %ebx,%eax
f01016f3:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f01016f9:	c1 f8 03             	sar    $0x3,%eax
f01016fc:	89 c2                	mov    %eax,%edx
f01016fe:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101701:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101706:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f010170c:	0f 83 28 02 00 00    	jae    f010193a <mem_init+0x4fd>
	memset(page2kva(pp0), 1, PGSIZE);
f0101712:	83 ec 04             	sub    $0x4,%esp
f0101715:	68 00 10 00 00       	push   $0x1000
f010171a:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f010171c:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101722:	52                   	push   %edx
f0101723:	e8 a1 44 00 00       	call   f0105bc9 <memset>
	page_free(pp0);
f0101728:	89 1c 24             	mov    %ebx,(%esp)
f010172b:	e8 62 f9 ff ff       	call   f0101092 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101730:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101737:	e8 cb f8 ff ff       	call   f0101007 <page_alloc>
f010173c:	83 c4 10             	add    $0x10,%esp
f010173f:	85 c0                	test   %eax,%eax
f0101741:	0f 84 05 02 00 00    	je     f010194c <mem_init+0x50f>
	assert(pp && pp0 == pp);
f0101747:	39 c3                	cmp    %eax,%ebx
f0101749:	0f 85 16 02 00 00    	jne    f0101965 <mem_init+0x528>
	return (pp - pages) << PGSHIFT;
f010174f:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0101755:	c1 f8 03             	sar    $0x3,%eax
f0101758:	89 c2                	mov    %eax,%edx
f010175a:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010175d:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101762:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f0101768:	0f 83 10 02 00 00    	jae    f010197e <mem_init+0x541>
	return (void *)(pa + KERNBASE);
f010176e:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101774:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f010177a:	80 38 00             	cmpb   $0x0,(%eax)
f010177d:	0f 85 0d 02 00 00    	jne    f0101990 <mem_init+0x553>
f0101783:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f0101786:	39 d0                	cmp    %edx,%eax
f0101788:	75 f0                	jne    f010177a <mem_init+0x33d>
	page_free_list = fl;
f010178a:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010178d:	a3 40 12 2c f0       	mov    %eax,0xf02c1240
	page_free(pp0);
f0101792:	83 ec 0c             	sub    $0xc,%esp
f0101795:	53                   	push   %ebx
f0101796:	e8 f7 f8 ff ff       	call   f0101092 <page_free>
	page_free(pp1);
f010179b:	89 34 24             	mov    %esi,(%esp)
f010179e:	e8 ef f8 ff ff       	call   f0101092 <page_free>
	page_free(pp2);
f01017a3:	89 3c 24             	mov    %edi,(%esp)
f01017a6:	e8 e7 f8 ff ff       	call   f0101092 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01017ab:	a1 40 12 2c f0       	mov    0xf02c1240,%eax
f01017b0:	83 c4 10             	add    $0x10,%esp
f01017b3:	85 c0                	test   %eax,%eax
f01017b5:	0f 84 ee 01 00 00    	je     f01019a9 <mem_init+0x56c>
		--nfree;
f01017bb:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01017bf:	8b 00                	mov    (%eax),%eax
f01017c1:	eb f0                	jmp    f01017b3 <mem_init+0x376>
	assert((pp0 = page_alloc(0)));
f01017c3:	68 a4 78 10 f0       	push   $0xf01078a4
f01017c8:	68 dc 77 10 f0       	push   $0xf01077dc
f01017cd:	68 6d 03 00 00       	push   $0x36d
f01017d2:	68 b6 77 10 f0       	push   $0xf01077b6
f01017d7:	e8 64 e8 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01017dc:	68 ba 78 10 f0       	push   $0xf01078ba
f01017e1:	68 dc 77 10 f0       	push   $0xf01077dc
f01017e6:	68 6e 03 00 00       	push   $0x36e
f01017eb:	68 b6 77 10 f0       	push   $0xf01077b6
f01017f0:	e8 4b e8 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01017f5:	68 d0 78 10 f0       	push   $0xf01078d0
f01017fa:	68 dc 77 10 f0       	push   $0xf01077dc
f01017ff:	68 6f 03 00 00       	push   $0x36f
f0101804:	68 b6 77 10 f0       	push   $0xf01077b6
f0101809:	e8 32 e8 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f010180e:	68 e6 78 10 f0       	push   $0xf01078e6
f0101813:	68 dc 77 10 f0       	push   $0xf01077dc
f0101818:	68 72 03 00 00       	push   $0x372
f010181d:	68 b6 77 10 f0       	push   $0xf01077b6
f0101822:	e8 19 e8 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101827:	68 ec 7c 10 f0       	push   $0xf0107cec
f010182c:	68 dc 77 10 f0       	push   $0xf01077dc
f0101831:	68 73 03 00 00       	push   $0x373
f0101836:	68 b6 77 10 f0       	push   $0xf01077b6
f010183b:	e8 00 e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101840:	68 f8 78 10 f0       	push   $0xf01078f8
f0101845:	68 dc 77 10 f0       	push   $0xf01077dc
f010184a:	68 74 03 00 00       	push   $0x374
f010184f:	68 b6 77 10 f0       	push   $0xf01077b6
f0101854:	e8 e7 e7 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101859:	68 15 79 10 f0       	push   $0xf0107915
f010185e:	68 dc 77 10 f0       	push   $0xf01077dc
f0101863:	68 75 03 00 00       	push   $0x375
f0101868:	68 b6 77 10 f0       	push   $0xf01077b6
f010186d:	e8 ce e7 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101872:	68 32 79 10 f0       	push   $0xf0107932
f0101877:	68 dc 77 10 f0       	push   $0xf01077dc
f010187c:	68 76 03 00 00       	push   $0x376
f0101881:	68 b6 77 10 f0       	push   $0xf01077b6
f0101886:	e8 b5 e7 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010188b:	68 4f 79 10 f0       	push   $0xf010794f
f0101890:	68 dc 77 10 f0       	push   $0xf01077dc
f0101895:	68 7d 03 00 00       	push   $0x37d
f010189a:	68 b6 77 10 f0       	push   $0xf01077b6
f010189f:	e8 9c e7 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f01018a4:	68 a4 78 10 f0       	push   $0xf01078a4
f01018a9:	68 dc 77 10 f0       	push   $0xf01077dc
f01018ae:	68 84 03 00 00       	push   $0x384
f01018b3:	68 b6 77 10 f0       	push   $0xf01077b6
f01018b8:	e8 83 e7 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01018bd:	68 ba 78 10 f0       	push   $0xf01078ba
f01018c2:	68 dc 77 10 f0       	push   $0xf01077dc
f01018c7:	68 85 03 00 00       	push   $0x385
f01018cc:	68 b6 77 10 f0       	push   $0xf01077b6
f01018d1:	e8 6a e7 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01018d6:	68 d0 78 10 f0       	push   $0xf01078d0
f01018db:	68 dc 77 10 f0       	push   $0xf01077dc
f01018e0:	68 86 03 00 00       	push   $0x386
f01018e5:	68 b6 77 10 f0       	push   $0xf01077b6
f01018ea:	e8 51 e7 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01018ef:	68 e6 78 10 f0       	push   $0xf01078e6
f01018f4:	68 dc 77 10 f0       	push   $0xf01077dc
f01018f9:	68 88 03 00 00       	push   $0x388
f01018fe:	68 b6 77 10 f0       	push   $0xf01077b6
f0101903:	e8 38 e7 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101908:	68 ec 7c 10 f0       	push   $0xf0107cec
f010190d:	68 dc 77 10 f0       	push   $0xf01077dc
f0101912:	68 89 03 00 00       	push   $0x389
f0101917:	68 b6 77 10 f0       	push   $0xf01077b6
f010191c:	e8 1f e7 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101921:	68 4f 79 10 f0       	push   $0xf010794f
f0101926:	68 dc 77 10 f0       	push   $0xf01077dc
f010192b:	68 8a 03 00 00       	push   $0x38a
f0101930:	68 b6 77 10 f0       	push   $0xf01077b6
f0101935:	e8 06 e7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010193a:	52                   	push   %edx
f010193b:	68 24 72 10 f0       	push   $0xf0107224
f0101940:	6a 58                	push   $0x58
f0101942:	68 c2 77 10 f0       	push   $0xf01077c2
f0101947:	e8 f4 e6 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f010194c:	68 5e 79 10 f0       	push   $0xf010795e
f0101951:	68 dc 77 10 f0       	push   $0xf01077dc
f0101956:	68 8f 03 00 00       	push   $0x38f
f010195b:	68 b6 77 10 f0       	push   $0xf01077b6
f0101960:	e8 db e6 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f0101965:	68 7c 79 10 f0       	push   $0xf010797c
f010196a:	68 dc 77 10 f0       	push   $0xf01077dc
f010196f:	68 90 03 00 00       	push   $0x390
f0101974:	68 b6 77 10 f0       	push   $0xf01077b6
f0101979:	e8 c2 e6 ff ff       	call   f0100040 <_panic>
f010197e:	52                   	push   %edx
f010197f:	68 24 72 10 f0       	push   $0xf0107224
f0101984:	6a 58                	push   $0x58
f0101986:	68 c2 77 10 f0       	push   $0xf01077c2
f010198b:	e8 b0 e6 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f0101990:	68 8c 79 10 f0       	push   $0xf010798c
f0101995:	68 dc 77 10 f0       	push   $0xf01077dc
f010199a:	68 93 03 00 00       	push   $0x393
f010199f:	68 b6 77 10 f0       	push   $0xf01077b6
f01019a4:	e8 97 e6 ff ff       	call   f0100040 <_panic>
	assert(nfree == 0);
f01019a9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01019ad:	0f 85 43 09 00 00    	jne    f01022f6 <mem_init+0xeb9>
	cprintf("check_page_alloc() succeeded!\n");
f01019b3:	83 ec 0c             	sub    $0xc,%esp
f01019b6:	68 0c 7d 10 f0       	push   $0xf0107d0c
f01019bb:	e8 76 20 00 00       	call   f0103a36 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01019c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01019c7:	e8 3b f6 ff ff       	call   f0101007 <page_alloc>
f01019cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01019cf:	83 c4 10             	add    $0x10,%esp
f01019d2:	85 c0                	test   %eax,%eax
f01019d4:	0f 84 35 09 00 00    	je     f010230f <mem_init+0xed2>
	assert((pp1 = page_alloc(0)));
f01019da:	83 ec 0c             	sub    $0xc,%esp
f01019dd:	6a 00                	push   $0x0
f01019df:	e8 23 f6 ff ff       	call   f0101007 <page_alloc>
f01019e4:	89 c7                	mov    %eax,%edi
f01019e6:	83 c4 10             	add    $0x10,%esp
f01019e9:	85 c0                	test   %eax,%eax
f01019eb:	0f 84 37 09 00 00    	je     f0102328 <mem_init+0xeeb>
	assert((pp2 = page_alloc(0)));
f01019f1:	83 ec 0c             	sub    $0xc,%esp
f01019f4:	6a 00                	push   $0x0
f01019f6:	e8 0c f6 ff ff       	call   f0101007 <page_alloc>
f01019fb:	89 c3                	mov    %eax,%ebx
f01019fd:	83 c4 10             	add    $0x10,%esp
f0101a00:	85 c0                	test   %eax,%eax
f0101a02:	0f 84 39 09 00 00    	je     f0102341 <mem_init+0xf04>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101a08:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f0101a0b:	0f 84 49 09 00 00    	je     f010235a <mem_init+0xf1d>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101a11:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101a14:	0f 84 59 09 00 00    	je     f0102373 <mem_init+0xf36>
f0101a1a:	39 c7                	cmp    %eax,%edi
f0101a1c:	0f 84 51 09 00 00    	je     f0102373 <mem_init+0xf36>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101a22:	a1 40 12 2c f0       	mov    0xf02c1240,%eax
f0101a27:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101a2a:	c7 05 40 12 2c f0 00 	movl   $0x0,0xf02c1240
f0101a31:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101a34:	83 ec 0c             	sub    $0xc,%esp
f0101a37:	6a 00                	push   $0x0
f0101a39:	e8 c9 f5 ff ff       	call   f0101007 <page_alloc>
f0101a3e:	83 c4 10             	add    $0x10,%esp
f0101a41:	85 c0                	test   %eax,%eax
f0101a43:	0f 85 43 09 00 00    	jne    f010238c <mem_init+0xf4f>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101a49:	83 ec 04             	sub    $0x4,%esp
f0101a4c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101a4f:	50                   	push   %eax
f0101a50:	6a 00                	push   $0x0
f0101a52:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101a58:	e8 f0 f7 ff ff       	call   f010124d <page_lookup>
f0101a5d:	83 c4 10             	add    $0x10,%esp
f0101a60:	85 c0                	test   %eax,%eax
f0101a62:	0f 85 3d 09 00 00    	jne    f01023a5 <mem_init+0xf68>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101a68:	6a 02                	push   $0x2
f0101a6a:	6a 00                	push   $0x0
f0101a6c:	57                   	push   %edi
f0101a6d:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101a73:	e8 cb f8 ff ff       	call   f0101343 <page_insert>
f0101a78:	83 c4 10             	add    $0x10,%esp
f0101a7b:	85 c0                	test   %eax,%eax
f0101a7d:	0f 89 3b 09 00 00    	jns    f01023be <mem_init+0xf81>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101a83:	83 ec 0c             	sub    $0xc,%esp
f0101a86:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101a89:	e8 04 f6 ff ff       	call   f0101092 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101a8e:	6a 02                	push   $0x2
f0101a90:	6a 00                	push   $0x0
f0101a92:	57                   	push   %edi
f0101a93:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101a99:	e8 a5 f8 ff ff       	call   f0101343 <page_insert>
f0101a9e:	83 c4 20             	add    $0x20,%esp
f0101aa1:	85 c0                	test   %eax,%eax
f0101aa3:	0f 85 2e 09 00 00    	jne    f01023d7 <mem_init+0xf9a>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101aa9:	8b 35 9c 1e 2c f0    	mov    0xf02c1e9c,%esi
	return (pp - pages) << PGSHIFT;
f0101aaf:	8b 0d a0 1e 2c f0    	mov    0xf02c1ea0,%ecx
f0101ab5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101ab8:	8b 16                	mov    (%esi),%edx
f0101aba:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101ac0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ac3:	29 c8                	sub    %ecx,%eax
f0101ac5:	c1 f8 03             	sar    $0x3,%eax
f0101ac8:	c1 e0 0c             	shl    $0xc,%eax
f0101acb:	39 c2                	cmp    %eax,%edx
f0101acd:	0f 85 1d 09 00 00    	jne    f01023f0 <mem_init+0xfb3>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101ad3:	ba 00 00 00 00       	mov    $0x0,%edx
f0101ad8:	89 f0                	mov    %esi,%eax
f0101ada:	e8 89 f0 ff ff       	call   f0100b68 <check_va2pa>
f0101adf:	89 c2                	mov    %eax,%edx
f0101ae1:	89 f8                	mov    %edi,%eax
f0101ae3:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0101ae6:	c1 f8 03             	sar    $0x3,%eax
f0101ae9:	c1 e0 0c             	shl    $0xc,%eax
f0101aec:	39 c2                	cmp    %eax,%edx
f0101aee:	0f 85 15 09 00 00    	jne    f0102409 <mem_init+0xfcc>
	assert(pp1->pp_ref == 1);
f0101af4:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101af9:	0f 85 23 09 00 00    	jne    f0102422 <mem_init+0xfe5>
	assert(pp0->pp_ref == 1);
f0101aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101b02:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101b07:	0f 85 2e 09 00 00    	jne    f010243b <mem_init+0xffe>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101b0d:	6a 02                	push   $0x2
f0101b0f:	68 00 10 00 00       	push   $0x1000
f0101b14:	53                   	push   %ebx
f0101b15:	56                   	push   %esi
f0101b16:	e8 28 f8 ff ff       	call   f0101343 <page_insert>
f0101b1b:	83 c4 10             	add    $0x10,%esp
f0101b1e:	85 c0                	test   %eax,%eax
f0101b20:	0f 85 2e 09 00 00    	jne    f0102454 <mem_init+0x1017>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b26:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b2b:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f0101b30:	e8 33 f0 ff ff       	call   f0100b68 <check_va2pa>
f0101b35:	89 c2                	mov    %eax,%edx
f0101b37:	89 d8                	mov    %ebx,%eax
f0101b39:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0101b3f:	c1 f8 03             	sar    $0x3,%eax
f0101b42:	c1 e0 0c             	shl    $0xc,%eax
f0101b45:	39 c2                	cmp    %eax,%edx
f0101b47:	0f 85 20 09 00 00    	jne    f010246d <mem_init+0x1030>
	assert(pp2->pp_ref == 1);
f0101b4d:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101b52:	0f 85 2e 09 00 00    	jne    f0102486 <mem_init+0x1049>

	// should be no free memory
	assert(!page_alloc(0));
f0101b58:	83 ec 0c             	sub    $0xc,%esp
f0101b5b:	6a 00                	push   $0x0
f0101b5d:	e8 a5 f4 ff ff       	call   f0101007 <page_alloc>
f0101b62:	83 c4 10             	add    $0x10,%esp
f0101b65:	85 c0                	test   %eax,%eax
f0101b67:	0f 85 32 09 00 00    	jne    f010249f <mem_init+0x1062>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101b6d:	6a 02                	push   $0x2
f0101b6f:	68 00 10 00 00       	push   $0x1000
f0101b74:	53                   	push   %ebx
f0101b75:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101b7b:	e8 c3 f7 ff ff       	call   f0101343 <page_insert>
f0101b80:	83 c4 10             	add    $0x10,%esp
f0101b83:	85 c0                	test   %eax,%eax
f0101b85:	0f 85 2d 09 00 00    	jne    f01024b8 <mem_init+0x107b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b8b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b90:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f0101b95:	e8 ce ef ff ff       	call   f0100b68 <check_va2pa>
f0101b9a:	89 c2                	mov    %eax,%edx
f0101b9c:	89 d8                	mov    %ebx,%eax
f0101b9e:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0101ba4:	c1 f8 03             	sar    $0x3,%eax
f0101ba7:	c1 e0 0c             	shl    $0xc,%eax
f0101baa:	39 c2                	cmp    %eax,%edx
f0101bac:	0f 85 1f 09 00 00    	jne    f01024d1 <mem_init+0x1094>
	assert(pp2->pp_ref == 1);
f0101bb2:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101bb7:	0f 85 2d 09 00 00    	jne    f01024ea <mem_init+0x10ad>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101bbd:	83 ec 0c             	sub    $0xc,%esp
f0101bc0:	6a 00                	push   $0x0
f0101bc2:	e8 40 f4 ff ff       	call   f0101007 <page_alloc>
f0101bc7:	83 c4 10             	add    $0x10,%esp
f0101bca:	85 c0                	test   %eax,%eax
f0101bcc:	0f 85 31 09 00 00    	jne    f0102503 <mem_init+0x10c6>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101bd2:	8b 0d 9c 1e 2c f0    	mov    0xf02c1e9c,%ecx
f0101bd8:	8b 01                	mov    (%ecx),%eax
f0101bda:	89 c2                	mov    %eax,%edx
f0101bdc:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101be2:	c1 e8 0c             	shr    $0xc,%eax
f0101be5:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f0101beb:	0f 83 2b 09 00 00    	jae    f010251c <mem_init+0x10df>
	return (void *)(pa + KERNBASE);
f0101bf1:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101bf7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101bfa:	83 ec 04             	sub    $0x4,%esp
f0101bfd:	6a 00                	push   $0x0
f0101bff:	68 00 10 00 00       	push   $0x1000
f0101c04:	51                   	push   %ecx
f0101c05:	e8 0b f5 ff ff       	call   f0101115 <pgdir_walk>
f0101c0a:	89 c2                	mov    %eax,%edx
f0101c0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101c0f:	83 c0 04             	add    $0x4,%eax
f0101c12:	83 c4 10             	add    $0x10,%esp
f0101c15:	39 d0                	cmp    %edx,%eax
f0101c17:	0f 85 14 09 00 00    	jne    f0102531 <mem_init+0x10f4>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101c1d:	6a 06                	push   $0x6
f0101c1f:	68 00 10 00 00       	push   $0x1000
f0101c24:	53                   	push   %ebx
f0101c25:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101c2b:	e8 13 f7 ff ff       	call   f0101343 <page_insert>
f0101c30:	83 c4 10             	add    $0x10,%esp
f0101c33:	85 c0                	test   %eax,%eax
f0101c35:	0f 85 0f 09 00 00    	jne    f010254a <mem_init+0x110d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101c3b:	8b 35 9c 1e 2c f0    	mov    0xf02c1e9c,%esi
f0101c41:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c46:	89 f0                	mov    %esi,%eax
f0101c48:	e8 1b ef ff ff       	call   f0100b68 <check_va2pa>
f0101c4d:	89 c2                	mov    %eax,%edx
	return (pp - pages) << PGSHIFT;
f0101c4f:	89 d8                	mov    %ebx,%eax
f0101c51:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0101c57:	c1 f8 03             	sar    $0x3,%eax
f0101c5a:	c1 e0 0c             	shl    $0xc,%eax
f0101c5d:	39 c2                	cmp    %eax,%edx
f0101c5f:	0f 85 fe 08 00 00    	jne    f0102563 <mem_init+0x1126>
	assert(pp2->pp_ref == 1);
f0101c65:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101c6a:	0f 85 0c 09 00 00    	jne    f010257c <mem_init+0x113f>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101c70:	83 ec 04             	sub    $0x4,%esp
f0101c73:	6a 00                	push   $0x0
f0101c75:	68 00 10 00 00       	push   $0x1000
f0101c7a:	56                   	push   %esi
f0101c7b:	e8 95 f4 ff ff       	call   f0101115 <pgdir_walk>
f0101c80:	83 c4 10             	add    $0x10,%esp
f0101c83:	f6 00 04             	testb  $0x4,(%eax)
f0101c86:	0f 84 09 09 00 00    	je     f0102595 <mem_init+0x1158>
	assert(kern_pgdir[0] & PTE_U);
f0101c8c:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f0101c91:	f6 00 04             	testb  $0x4,(%eax)
f0101c94:	0f 84 14 09 00 00    	je     f01025ae <mem_init+0x1171>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101c9a:	6a 02                	push   $0x2
f0101c9c:	68 00 10 00 00       	push   $0x1000
f0101ca1:	53                   	push   %ebx
f0101ca2:	50                   	push   %eax
f0101ca3:	e8 9b f6 ff ff       	call   f0101343 <page_insert>
f0101ca8:	83 c4 10             	add    $0x10,%esp
f0101cab:	85 c0                	test   %eax,%eax
f0101cad:	0f 85 14 09 00 00    	jne    f01025c7 <mem_init+0x118a>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101cb3:	83 ec 04             	sub    $0x4,%esp
f0101cb6:	6a 00                	push   $0x0
f0101cb8:	68 00 10 00 00       	push   $0x1000
f0101cbd:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101cc3:	e8 4d f4 ff ff       	call   f0101115 <pgdir_walk>
f0101cc8:	83 c4 10             	add    $0x10,%esp
f0101ccb:	f6 00 02             	testb  $0x2,(%eax)
f0101cce:	0f 84 0c 09 00 00    	je     f01025e0 <mem_init+0x11a3>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101cd4:	83 ec 04             	sub    $0x4,%esp
f0101cd7:	6a 00                	push   $0x0
f0101cd9:	68 00 10 00 00       	push   $0x1000
f0101cde:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101ce4:	e8 2c f4 ff ff       	call   f0101115 <pgdir_walk>
f0101ce9:	83 c4 10             	add    $0x10,%esp
f0101cec:	f6 00 04             	testb  $0x4,(%eax)
f0101cef:	0f 85 04 09 00 00    	jne    f01025f9 <mem_init+0x11bc>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101cf5:	6a 02                	push   $0x2
f0101cf7:	68 00 00 40 00       	push   $0x400000
f0101cfc:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101cff:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101d05:	e8 39 f6 ff ff       	call   f0101343 <page_insert>
f0101d0a:	83 c4 10             	add    $0x10,%esp
f0101d0d:	85 c0                	test   %eax,%eax
f0101d0f:	0f 89 fd 08 00 00    	jns    f0102612 <mem_init+0x11d5>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101d15:	6a 02                	push   $0x2
f0101d17:	68 00 10 00 00       	push   $0x1000
f0101d1c:	57                   	push   %edi
f0101d1d:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101d23:	e8 1b f6 ff ff       	call   f0101343 <page_insert>
f0101d28:	83 c4 10             	add    $0x10,%esp
f0101d2b:	85 c0                	test   %eax,%eax
f0101d2d:	0f 85 f8 08 00 00    	jne    f010262b <mem_init+0x11ee>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101d33:	83 ec 04             	sub    $0x4,%esp
f0101d36:	6a 00                	push   $0x0
f0101d38:	68 00 10 00 00       	push   $0x1000
f0101d3d:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101d43:	e8 cd f3 ff ff       	call   f0101115 <pgdir_walk>
f0101d48:	83 c4 10             	add    $0x10,%esp
f0101d4b:	f6 00 04             	testb  $0x4,(%eax)
f0101d4e:	0f 85 f0 08 00 00    	jne    f0102644 <mem_init+0x1207>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101d54:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f0101d59:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101d5c:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d61:	e8 02 ee ff ff       	call   f0100b68 <check_va2pa>
f0101d66:	89 fe                	mov    %edi,%esi
f0101d68:	2b 35 a0 1e 2c f0    	sub    0xf02c1ea0,%esi
f0101d6e:	c1 fe 03             	sar    $0x3,%esi
f0101d71:	c1 e6 0c             	shl    $0xc,%esi
f0101d74:	39 f0                	cmp    %esi,%eax
f0101d76:	0f 85 e1 08 00 00    	jne    f010265d <mem_init+0x1220>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101d7c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d81:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101d84:	e8 df ed ff ff       	call   f0100b68 <check_va2pa>
f0101d89:	39 c6                	cmp    %eax,%esi
f0101d8b:	0f 85 e5 08 00 00    	jne    f0102676 <mem_init+0x1239>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101d91:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f0101d96:	0f 85 f3 08 00 00    	jne    f010268f <mem_init+0x1252>
	assert(pp2->pp_ref == 0);
f0101d9c:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101da1:	0f 85 01 09 00 00    	jne    f01026a8 <mem_init+0x126b>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101da7:	83 ec 0c             	sub    $0xc,%esp
f0101daa:	6a 00                	push   $0x0
f0101dac:	e8 56 f2 ff ff       	call   f0101007 <page_alloc>
f0101db1:	83 c4 10             	add    $0x10,%esp
f0101db4:	85 c0                	test   %eax,%eax
f0101db6:	0f 84 05 09 00 00    	je     f01026c1 <mem_init+0x1284>
f0101dbc:	39 c3                	cmp    %eax,%ebx
f0101dbe:	0f 85 fd 08 00 00    	jne    f01026c1 <mem_init+0x1284>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101dc4:	83 ec 08             	sub    $0x8,%esp
f0101dc7:	6a 00                	push   $0x0
f0101dc9:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101dcf:	e8 25 f5 ff ff       	call   f01012f9 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101dd4:	8b 35 9c 1e 2c f0    	mov    0xf02c1e9c,%esi
f0101dda:	ba 00 00 00 00       	mov    $0x0,%edx
f0101ddf:	89 f0                	mov    %esi,%eax
f0101de1:	e8 82 ed ff ff       	call   f0100b68 <check_va2pa>
f0101de6:	83 c4 10             	add    $0x10,%esp
f0101de9:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101dec:	0f 85 e8 08 00 00    	jne    f01026da <mem_init+0x129d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101df2:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101df7:	89 f0                	mov    %esi,%eax
f0101df9:	e8 6a ed ff ff       	call   f0100b68 <check_va2pa>
f0101dfe:	89 c2                	mov    %eax,%edx
f0101e00:	89 f8                	mov    %edi,%eax
f0101e02:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0101e08:	c1 f8 03             	sar    $0x3,%eax
f0101e0b:	c1 e0 0c             	shl    $0xc,%eax
f0101e0e:	39 c2                	cmp    %eax,%edx
f0101e10:	0f 85 dd 08 00 00    	jne    f01026f3 <mem_init+0x12b6>
	assert(pp1->pp_ref == 1);
f0101e16:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101e1b:	0f 85 eb 08 00 00    	jne    f010270c <mem_init+0x12cf>
	assert(pp2->pp_ref == 0);
f0101e21:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101e26:	0f 85 f9 08 00 00    	jne    f0102725 <mem_init+0x12e8>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101e2c:	6a 00                	push   $0x0
f0101e2e:	68 00 10 00 00       	push   $0x1000
f0101e33:	57                   	push   %edi
f0101e34:	56                   	push   %esi
f0101e35:	e8 09 f5 ff ff       	call   f0101343 <page_insert>
f0101e3a:	83 c4 10             	add    $0x10,%esp
f0101e3d:	85 c0                	test   %eax,%eax
f0101e3f:	0f 85 f9 08 00 00    	jne    f010273e <mem_init+0x1301>
	assert(pp1->pp_ref);
f0101e45:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101e4a:	0f 84 07 09 00 00    	je     f0102757 <mem_init+0x131a>
	assert(pp1->pp_link == NULL);
f0101e50:	83 3f 00             	cmpl   $0x0,(%edi)
f0101e53:	0f 85 17 09 00 00    	jne    f0102770 <mem_init+0x1333>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101e59:	83 ec 08             	sub    $0x8,%esp
f0101e5c:	68 00 10 00 00       	push   $0x1000
f0101e61:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101e67:	e8 8d f4 ff ff       	call   f01012f9 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101e6c:	8b 35 9c 1e 2c f0    	mov    0xf02c1e9c,%esi
f0101e72:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e77:	89 f0                	mov    %esi,%eax
f0101e79:	e8 ea ec ff ff       	call   f0100b68 <check_va2pa>
f0101e7e:	83 c4 10             	add    $0x10,%esp
f0101e81:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e84:	0f 85 ff 08 00 00    	jne    f0102789 <mem_init+0x134c>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101e8a:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e8f:	89 f0                	mov    %esi,%eax
f0101e91:	e8 d2 ec ff ff       	call   f0100b68 <check_va2pa>
f0101e96:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e99:	0f 85 03 09 00 00    	jne    f01027a2 <mem_init+0x1365>
	assert(pp1->pp_ref == 0);
f0101e9f:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101ea4:	0f 85 11 09 00 00    	jne    f01027bb <mem_init+0x137e>
	assert(pp2->pp_ref == 0);
f0101eaa:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101eaf:	0f 85 1f 09 00 00    	jne    f01027d4 <mem_init+0x1397>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101eb5:	83 ec 0c             	sub    $0xc,%esp
f0101eb8:	6a 00                	push   $0x0
f0101eba:	e8 48 f1 ff ff       	call   f0101007 <page_alloc>
f0101ebf:	83 c4 10             	add    $0x10,%esp
f0101ec2:	39 c7                	cmp    %eax,%edi
f0101ec4:	0f 85 23 09 00 00    	jne    f01027ed <mem_init+0x13b0>
f0101eca:	85 c0                	test   %eax,%eax
f0101ecc:	0f 84 1b 09 00 00    	je     f01027ed <mem_init+0x13b0>

	// should be no free memory
	assert(!page_alloc(0));
f0101ed2:	83 ec 0c             	sub    $0xc,%esp
f0101ed5:	6a 00                	push   $0x0
f0101ed7:	e8 2b f1 ff ff       	call   f0101007 <page_alloc>
f0101edc:	83 c4 10             	add    $0x10,%esp
f0101edf:	85 c0                	test   %eax,%eax
f0101ee1:	0f 85 1f 09 00 00    	jne    f0102806 <mem_init+0x13c9>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101ee7:	8b 0d 9c 1e 2c f0    	mov    0xf02c1e9c,%ecx
f0101eed:	8b 11                	mov    (%ecx),%edx
f0101eef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101ef5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ef8:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0101efe:	c1 f8 03             	sar    $0x3,%eax
f0101f01:	c1 e0 0c             	shl    $0xc,%eax
f0101f04:	39 c2                	cmp    %eax,%edx
f0101f06:	0f 85 13 09 00 00    	jne    f010281f <mem_init+0x13e2>
	kern_pgdir[0] = 0;
f0101f0c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101f12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f15:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101f1a:	0f 85 18 09 00 00    	jne    f0102838 <mem_init+0x13fb>
	pp0->pp_ref = 0;
f0101f20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f23:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101f29:	83 ec 0c             	sub    $0xc,%esp
f0101f2c:	50                   	push   %eax
f0101f2d:	e8 60 f1 ff ff       	call   f0101092 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101f32:	83 c4 0c             	add    $0xc,%esp
f0101f35:	6a 01                	push   $0x1
f0101f37:	68 00 10 40 00       	push   $0x401000
f0101f3c:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101f42:	e8 ce f1 ff ff       	call   f0101115 <pgdir_walk>
f0101f47:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101f4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101f4d:	8b 0d 9c 1e 2c f0    	mov    0xf02c1e9c,%ecx
f0101f53:	8b 41 04             	mov    0x4(%ecx),%eax
f0101f56:	89 c6                	mov    %eax,%esi
f0101f58:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0101f5e:	8b 15 98 1e 2c f0    	mov    0xf02c1e98,%edx
f0101f64:	c1 e8 0c             	shr    $0xc,%eax
f0101f67:	83 c4 10             	add    $0x10,%esp
f0101f6a:	39 d0                	cmp    %edx,%eax
f0101f6c:	0f 83 df 08 00 00    	jae    f0102851 <mem_init+0x1414>
	assert(ptep == ptep1 + PTX(va));
f0101f72:	81 ee fc ff ff 0f    	sub    $0xffffffc,%esi
f0101f78:	39 75 d0             	cmp    %esi,-0x30(%ebp)
f0101f7b:	0f 85 e5 08 00 00    	jne    f0102866 <mem_init+0x1429>
	kern_pgdir[PDX(va)] = 0;
f0101f81:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
	pp0->pp_ref = 0;
f0101f88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f8b:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101f91:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0101f97:	c1 f8 03             	sar    $0x3,%eax
f0101f9a:	89 c1                	mov    %eax,%ecx
f0101f9c:	c1 e1 0c             	shl    $0xc,%ecx
	if (PGNUM(pa) >= npages)
f0101f9f:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101fa4:	39 c2                	cmp    %eax,%edx
f0101fa6:	0f 86 d3 08 00 00    	jbe    f010287f <mem_init+0x1442>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101fac:	83 ec 04             	sub    $0x4,%esp
f0101faf:	68 00 10 00 00       	push   $0x1000
f0101fb4:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101fb9:	81 e9 00 00 00 10    	sub    $0x10000000,%ecx
f0101fbf:	51                   	push   %ecx
f0101fc0:	e8 04 3c 00 00       	call   f0105bc9 <memset>
	page_free(pp0);
f0101fc5:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0101fc8:	89 34 24             	mov    %esi,(%esp)
f0101fcb:	e8 c2 f0 ff ff       	call   f0101092 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101fd0:	83 c4 0c             	add    $0xc,%esp
f0101fd3:	6a 01                	push   $0x1
f0101fd5:	6a 00                	push   $0x0
f0101fd7:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0101fdd:	e8 33 f1 ff ff       	call   f0101115 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0101fe2:	89 f0                	mov    %esi,%eax
f0101fe4:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0101fea:	c1 f8 03             	sar    $0x3,%eax
f0101fed:	89 c2                	mov    %eax,%edx
f0101fef:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101ff2:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101ff7:	83 c4 10             	add    $0x10,%esp
f0101ffa:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f0102000:	0f 83 8b 08 00 00    	jae    f0102891 <mem_init+0x1454>
	return (void *)(pa + KERNBASE);
f0102006:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f010200c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010200f:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102015:	f6 00 01             	testb  $0x1,(%eax)
f0102018:	0f 85 85 08 00 00    	jne    f01028a3 <mem_init+0x1466>
f010201e:	83 c0 04             	add    $0x4,%eax
	for(i=0; i<NPTENTRIES; i++)
f0102021:	39 d0                	cmp    %edx,%eax
f0102023:	75 f0                	jne    f0102015 <mem_init+0xbd8>
	kern_pgdir[0] = 0;
f0102025:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f010202a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102030:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102033:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102039:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010203c:	89 0d 40 12 2c f0    	mov    %ecx,0xf02c1240

	// free the pages we took
	page_free(pp0);
f0102042:	83 ec 0c             	sub    $0xc,%esp
f0102045:	50                   	push   %eax
f0102046:	e8 47 f0 ff ff       	call   f0101092 <page_free>
	page_free(pp1);
f010204b:	89 3c 24             	mov    %edi,(%esp)
f010204e:	e8 3f f0 ff ff       	call   f0101092 <page_free>
	page_free(pp2);
f0102053:	89 1c 24             	mov    %ebx,(%esp)
f0102056:	e8 37 f0 ff ff       	call   f0101092 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f010205b:	83 c4 08             	add    $0x8,%esp
f010205e:	68 01 10 00 00       	push   $0x1001
f0102063:	6a 00                	push   $0x0
f0102065:	e8 6c f3 ff ff       	call   f01013d6 <mmio_map_region>
f010206a:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f010206c:	83 c4 08             	add    $0x8,%esp
f010206f:	68 00 10 00 00       	push   $0x1000
f0102074:	6a 00                	push   $0x0
f0102076:	e8 5b f3 ff ff       	call   f01013d6 <mmio_map_region>
f010207b:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f010207d:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0102083:	83 c4 10             	add    $0x10,%esp
f0102086:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f010208c:	0f 86 2a 08 00 00    	jbe    f01028bc <mem_init+0x147f>
f0102092:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102097:	0f 87 1f 08 00 00    	ja     f01028bc <mem_init+0x147f>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f010209d:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f01020a3:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f01020a9:	0f 87 26 08 00 00    	ja     f01028d5 <mem_init+0x1498>
f01020af:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f01020b5:	0f 86 1a 08 00 00    	jbe    f01028d5 <mem_init+0x1498>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01020bb:	89 da                	mov    %ebx,%edx
f01020bd:	09 f2                	or     %esi,%edx
f01020bf:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f01020c5:	0f 85 23 08 00 00    	jne    f01028ee <mem_init+0x14b1>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f01020cb:	39 c6                	cmp    %eax,%esi
f01020cd:	0f 82 34 08 00 00    	jb     f0102907 <mem_init+0x14ca>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01020d3:	8b 3d 9c 1e 2c f0    	mov    0xf02c1e9c,%edi
f01020d9:	89 da                	mov    %ebx,%edx
f01020db:	89 f8                	mov    %edi,%eax
f01020dd:	e8 86 ea ff ff       	call   f0100b68 <check_va2pa>
f01020e2:	85 c0                	test   %eax,%eax
f01020e4:	0f 85 36 08 00 00    	jne    f0102920 <mem_init+0x14e3>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f01020ea:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f01020f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01020f3:	89 c2                	mov    %eax,%edx
f01020f5:	89 f8                	mov    %edi,%eax
f01020f7:	e8 6c ea ff ff       	call   f0100b68 <check_va2pa>
f01020fc:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102101:	0f 85 32 08 00 00    	jne    f0102939 <mem_init+0x14fc>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102107:	89 f2                	mov    %esi,%edx
f0102109:	89 f8                	mov    %edi,%eax
f010210b:	e8 58 ea ff ff       	call   f0100b68 <check_va2pa>
f0102110:	85 c0                	test   %eax,%eax
f0102112:	0f 85 3a 08 00 00    	jne    f0102952 <mem_init+0x1515>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102118:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f010211e:	89 f8                	mov    %edi,%eax
f0102120:	e8 43 ea ff ff       	call   f0100b68 <check_va2pa>
f0102125:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102128:	0f 85 3d 08 00 00    	jne    f010296b <mem_init+0x152e>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f010212e:	83 ec 04             	sub    $0x4,%esp
f0102131:	6a 00                	push   $0x0
f0102133:	53                   	push   %ebx
f0102134:	57                   	push   %edi
f0102135:	e8 db ef ff ff       	call   f0101115 <pgdir_walk>
f010213a:	83 c4 10             	add    $0x10,%esp
f010213d:	f6 00 1a             	testb  $0x1a,(%eax)
f0102140:	0f 84 3e 08 00 00    	je     f0102984 <mem_init+0x1547>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102146:	83 ec 04             	sub    $0x4,%esp
f0102149:	6a 00                	push   $0x0
f010214b:	53                   	push   %ebx
f010214c:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0102152:	e8 be ef ff ff       	call   f0101115 <pgdir_walk>
f0102157:	8b 00                	mov    (%eax),%eax
f0102159:	83 c4 10             	add    $0x10,%esp
f010215c:	83 e0 04             	and    $0x4,%eax
f010215f:	89 c7                	mov    %eax,%edi
f0102161:	0f 85 36 08 00 00    	jne    f010299d <mem_init+0x1560>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102167:	83 ec 04             	sub    $0x4,%esp
f010216a:	6a 00                	push   $0x0
f010216c:	53                   	push   %ebx
f010216d:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0102173:	e8 9d ef ff ff       	call   f0101115 <pgdir_walk>
f0102178:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f010217e:	83 c4 0c             	add    $0xc,%esp
f0102181:	6a 00                	push   $0x0
f0102183:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102186:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f010218c:	e8 84 ef ff ff       	call   f0101115 <pgdir_walk>
f0102191:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102197:	83 c4 0c             	add    $0xc,%esp
f010219a:	6a 00                	push   $0x0
f010219c:	56                   	push   %esi
f010219d:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f01021a3:	e8 6d ef ff ff       	call   f0101115 <pgdir_walk>
f01021a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f01021ae:	c7 04 24 7f 7a 10 f0 	movl   $0xf0107a7f,(%esp)
f01021b5:	e8 7c 18 00 00       	call   f0103a36 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f01021ba:	a1 a0 1e 2c f0       	mov    0xf02c1ea0,%eax
	if ((uint32_t)kva < KERNBASE)
f01021bf:	83 c4 10             	add    $0x10,%esp
f01021c2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021c7:	0f 86 e9 07 00 00    	jbe    f01029b6 <mem_init+0x1579>
f01021cd:	83 ec 08             	sub    $0x8,%esp
f01021d0:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01021d2:	05 00 00 00 10       	add    $0x10000000,%eax
f01021d7:	50                   	push   %eax
f01021d8:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01021dd:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01021e2:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f01021e7:	e8 0a f0 ff ff       	call   f01011f6 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f01021ec:	a1 48 12 2c f0       	mov    0xf02c1248,%eax
	if ((uint32_t)kva < KERNBASE)
f01021f1:	83 c4 10             	add    $0x10,%esp
f01021f4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021f9:	0f 86 cc 07 00 00    	jbe    f01029cb <mem_init+0x158e>
f01021ff:	83 ec 08             	sub    $0x8,%esp
f0102202:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102204:	05 00 00 00 10       	add    $0x10000000,%eax
f0102209:	50                   	push   %eax
f010220a:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010220f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102214:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f0102219:	e8 d8 ef ff ff       	call   f01011f6 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f010221e:	83 c4 10             	add    $0x10,%esp
f0102221:	b8 00 c0 11 f0       	mov    $0xf011c000,%eax
f0102226:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010222b:	0f 86 af 07 00 00    	jbe    f01029e0 <mem_init+0x15a3>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f0102231:	83 ec 08             	sub    $0x8,%esp
f0102234:	6a 02                	push   $0x2
f0102236:	68 00 c0 11 00       	push   $0x11c000
f010223b:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102240:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102245:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f010224a:	e8 a7 ef ff ff       	call   f01011f6 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0xffffffff - KERNBASE, 0, PTE_W);
f010224f:	83 c4 08             	add    $0x8,%esp
f0102252:	6a 02                	push   $0x2
f0102254:	6a 00                	push   $0x0
f0102256:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f010225b:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102260:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f0102265:	e8 8c ef ff ff       	call   f01011f6 <boot_map_region>
f010226a:	c7 45 d0 00 30 2c f0 	movl   $0xf02c3000,-0x30(%ebp)
f0102271:	83 c4 10             	add    $0x10,%esp
f0102274:	bb 00 30 2c f0       	mov    $0xf02c3000,%ebx
f0102279:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f010227e:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102284:	0f 86 6b 07 00 00    	jbe    f01029f5 <mem_init+0x15b8>
		boot_map_region(kern_pgdir, 
f010228a:	83 ec 08             	sub    $0x8,%esp
f010228d:	6a 02                	push   $0x2
f010228f:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102295:	50                   	push   %eax
f0102296:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010229b:	89 f2                	mov    %esi,%edx
f010229d:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f01022a2:	e8 4f ef ff ff       	call   f01011f6 <boot_map_region>
f01022a7:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f01022ad:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f01022b3:	83 c4 10             	add    $0x10,%esp
f01022b6:	81 fb 00 30 30 f0    	cmp    $0xf0303000,%ebx
f01022bc:	75 c0                	jne    f010227e <mem_init+0xe41>
	pgdir = kern_pgdir;
f01022be:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
f01022c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01022c6:	a1 98 1e 2c f0       	mov    0xf02c1e98,%eax
f01022cb:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01022ce:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01022d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01022da:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01022dd:	8b 35 a0 1e 2c f0    	mov    0xf02c1ea0,%esi
f01022e3:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01022e6:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01022ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f01022ef:	89 fb                	mov    %edi,%ebx
f01022f1:	e9 2f 07 00 00       	jmp    f0102a25 <mem_init+0x15e8>
	assert(nfree == 0);
f01022f6:	68 96 79 10 f0       	push   $0xf0107996
f01022fb:	68 dc 77 10 f0       	push   $0xf01077dc
f0102300:	68 a0 03 00 00       	push   $0x3a0
f0102305:	68 b6 77 10 f0       	push   $0xf01077b6
f010230a:	e8 31 dd ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f010230f:	68 a4 78 10 f0       	push   $0xf01078a4
f0102314:	68 dc 77 10 f0       	push   $0xf01077dc
f0102319:	68 06 04 00 00       	push   $0x406
f010231e:	68 b6 77 10 f0       	push   $0xf01077b6
f0102323:	e8 18 dd ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102328:	68 ba 78 10 f0       	push   $0xf01078ba
f010232d:	68 dc 77 10 f0       	push   $0xf01077dc
f0102332:	68 07 04 00 00       	push   $0x407
f0102337:	68 b6 77 10 f0       	push   $0xf01077b6
f010233c:	e8 ff dc ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102341:	68 d0 78 10 f0       	push   $0xf01078d0
f0102346:	68 dc 77 10 f0       	push   $0xf01077dc
f010234b:	68 08 04 00 00       	push   $0x408
f0102350:	68 b6 77 10 f0       	push   $0xf01077b6
f0102355:	e8 e6 dc ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f010235a:	68 e6 78 10 f0       	push   $0xf01078e6
f010235f:	68 dc 77 10 f0       	push   $0xf01077dc
f0102364:	68 0b 04 00 00       	push   $0x40b
f0102369:	68 b6 77 10 f0       	push   $0xf01077b6
f010236e:	e8 cd dc ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102373:	68 ec 7c 10 f0       	push   $0xf0107cec
f0102378:	68 dc 77 10 f0       	push   $0xf01077dc
f010237d:	68 0c 04 00 00       	push   $0x40c
f0102382:	68 b6 77 10 f0       	push   $0xf01077b6
f0102387:	e8 b4 dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010238c:	68 4f 79 10 f0       	push   $0xf010794f
f0102391:	68 dc 77 10 f0       	push   $0xf01077dc
f0102396:	68 13 04 00 00       	push   $0x413
f010239b:	68 b6 77 10 f0       	push   $0xf01077b6
f01023a0:	e8 9b dc ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01023a5:	68 2c 7d 10 f0       	push   $0xf0107d2c
f01023aa:	68 dc 77 10 f0       	push   $0xf01077dc
f01023af:	68 16 04 00 00       	push   $0x416
f01023b4:	68 b6 77 10 f0       	push   $0xf01077b6
f01023b9:	e8 82 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01023be:	68 64 7d 10 f0       	push   $0xf0107d64
f01023c3:	68 dc 77 10 f0       	push   $0xf01077dc
f01023c8:	68 19 04 00 00       	push   $0x419
f01023cd:	68 b6 77 10 f0       	push   $0xf01077b6
f01023d2:	e8 69 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01023d7:	68 94 7d 10 f0       	push   $0xf0107d94
f01023dc:	68 dc 77 10 f0       	push   $0xf01077dc
f01023e1:	68 1d 04 00 00       	push   $0x41d
f01023e6:	68 b6 77 10 f0       	push   $0xf01077b6
f01023eb:	e8 50 dc ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01023f0:	68 c4 7d 10 f0       	push   $0xf0107dc4
f01023f5:	68 dc 77 10 f0       	push   $0xf01077dc
f01023fa:	68 1e 04 00 00       	push   $0x41e
f01023ff:	68 b6 77 10 f0       	push   $0xf01077b6
f0102404:	e8 37 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102409:	68 ec 7d 10 f0       	push   $0xf0107dec
f010240e:	68 dc 77 10 f0       	push   $0xf01077dc
f0102413:	68 1f 04 00 00       	push   $0x41f
f0102418:	68 b6 77 10 f0       	push   $0xf01077b6
f010241d:	e8 1e dc ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102422:	68 a1 79 10 f0       	push   $0xf01079a1
f0102427:	68 dc 77 10 f0       	push   $0xf01077dc
f010242c:	68 20 04 00 00       	push   $0x420
f0102431:	68 b6 77 10 f0       	push   $0xf01077b6
f0102436:	e8 05 dc ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f010243b:	68 b2 79 10 f0       	push   $0xf01079b2
f0102440:	68 dc 77 10 f0       	push   $0xf01077dc
f0102445:	68 21 04 00 00       	push   $0x421
f010244a:	68 b6 77 10 f0       	push   $0xf01077b6
f010244f:	e8 ec db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102454:	68 1c 7e 10 f0       	push   $0xf0107e1c
f0102459:	68 dc 77 10 f0       	push   $0xf01077dc
f010245e:	68 24 04 00 00       	push   $0x424
f0102463:	68 b6 77 10 f0       	push   $0xf01077b6
f0102468:	e8 d3 db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010246d:	68 58 7e 10 f0       	push   $0xf0107e58
f0102472:	68 dc 77 10 f0       	push   $0xf01077dc
f0102477:	68 25 04 00 00       	push   $0x425
f010247c:	68 b6 77 10 f0       	push   $0xf01077b6
f0102481:	e8 ba db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102486:	68 c3 79 10 f0       	push   $0xf01079c3
f010248b:	68 dc 77 10 f0       	push   $0xf01077dc
f0102490:	68 26 04 00 00       	push   $0x426
f0102495:	68 b6 77 10 f0       	push   $0xf01077b6
f010249a:	e8 a1 db ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010249f:	68 4f 79 10 f0       	push   $0xf010794f
f01024a4:	68 dc 77 10 f0       	push   $0xf01077dc
f01024a9:	68 29 04 00 00       	push   $0x429
f01024ae:	68 b6 77 10 f0       	push   $0xf01077b6
f01024b3:	e8 88 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01024b8:	68 1c 7e 10 f0       	push   $0xf0107e1c
f01024bd:	68 dc 77 10 f0       	push   $0xf01077dc
f01024c2:	68 2c 04 00 00       	push   $0x42c
f01024c7:	68 b6 77 10 f0       	push   $0xf01077b6
f01024cc:	e8 6f db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01024d1:	68 58 7e 10 f0       	push   $0xf0107e58
f01024d6:	68 dc 77 10 f0       	push   $0xf01077dc
f01024db:	68 2d 04 00 00       	push   $0x42d
f01024e0:	68 b6 77 10 f0       	push   $0xf01077b6
f01024e5:	e8 56 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01024ea:	68 c3 79 10 f0       	push   $0xf01079c3
f01024ef:	68 dc 77 10 f0       	push   $0xf01077dc
f01024f4:	68 2e 04 00 00       	push   $0x42e
f01024f9:	68 b6 77 10 f0       	push   $0xf01077b6
f01024fe:	e8 3d db ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102503:	68 4f 79 10 f0       	push   $0xf010794f
f0102508:	68 dc 77 10 f0       	push   $0xf01077dc
f010250d:	68 32 04 00 00       	push   $0x432
f0102512:	68 b6 77 10 f0       	push   $0xf01077b6
f0102517:	e8 24 db ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010251c:	52                   	push   %edx
f010251d:	68 24 72 10 f0       	push   $0xf0107224
f0102522:	68 35 04 00 00       	push   $0x435
f0102527:	68 b6 77 10 f0       	push   $0xf01077b6
f010252c:	e8 0f db ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102531:	68 88 7e 10 f0       	push   $0xf0107e88
f0102536:	68 dc 77 10 f0       	push   $0xf01077dc
f010253b:	68 36 04 00 00       	push   $0x436
f0102540:	68 b6 77 10 f0       	push   $0xf01077b6
f0102545:	e8 f6 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f010254a:	68 c8 7e 10 f0       	push   $0xf0107ec8
f010254f:	68 dc 77 10 f0       	push   $0xf01077dc
f0102554:	68 39 04 00 00       	push   $0x439
f0102559:	68 b6 77 10 f0       	push   $0xf01077b6
f010255e:	e8 dd da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102563:	68 58 7e 10 f0       	push   $0xf0107e58
f0102568:	68 dc 77 10 f0       	push   $0xf01077dc
f010256d:	68 3a 04 00 00       	push   $0x43a
f0102572:	68 b6 77 10 f0       	push   $0xf01077b6
f0102577:	e8 c4 da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010257c:	68 c3 79 10 f0       	push   $0xf01079c3
f0102581:	68 dc 77 10 f0       	push   $0xf01077dc
f0102586:	68 3b 04 00 00       	push   $0x43b
f010258b:	68 b6 77 10 f0       	push   $0xf01077b6
f0102590:	e8 ab da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102595:	68 08 7f 10 f0       	push   $0xf0107f08
f010259a:	68 dc 77 10 f0       	push   $0xf01077dc
f010259f:	68 3c 04 00 00       	push   $0x43c
f01025a4:	68 b6 77 10 f0       	push   $0xf01077b6
f01025a9:	e8 92 da ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01025ae:	68 d4 79 10 f0       	push   $0xf01079d4
f01025b3:	68 dc 77 10 f0       	push   $0xf01077dc
f01025b8:	68 3d 04 00 00       	push   $0x43d
f01025bd:	68 b6 77 10 f0       	push   $0xf01077b6
f01025c2:	e8 79 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01025c7:	68 1c 7e 10 f0       	push   $0xf0107e1c
f01025cc:	68 dc 77 10 f0       	push   $0xf01077dc
f01025d1:	68 40 04 00 00       	push   $0x440
f01025d6:	68 b6 77 10 f0       	push   $0xf01077b6
f01025db:	e8 60 da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01025e0:	68 3c 7f 10 f0       	push   $0xf0107f3c
f01025e5:	68 dc 77 10 f0       	push   $0xf01077dc
f01025ea:	68 41 04 00 00       	push   $0x441
f01025ef:	68 b6 77 10 f0       	push   $0xf01077b6
f01025f4:	e8 47 da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01025f9:	68 70 7f 10 f0       	push   $0xf0107f70
f01025fe:	68 dc 77 10 f0       	push   $0xf01077dc
f0102603:	68 42 04 00 00       	push   $0x442
f0102608:	68 b6 77 10 f0       	push   $0xf01077b6
f010260d:	e8 2e da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102612:	68 a8 7f 10 f0       	push   $0xf0107fa8
f0102617:	68 dc 77 10 f0       	push   $0xf01077dc
f010261c:	68 45 04 00 00       	push   $0x445
f0102621:	68 b6 77 10 f0       	push   $0xf01077b6
f0102626:	e8 15 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f010262b:	68 e0 7f 10 f0       	push   $0xf0107fe0
f0102630:	68 dc 77 10 f0       	push   $0xf01077dc
f0102635:	68 48 04 00 00       	push   $0x448
f010263a:	68 b6 77 10 f0       	push   $0xf01077b6
f010263f:	e8 fc d9 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102644:	68 70 7f 10 f0       	push   $0xf0107f70
f0102649:	68 dc 77 10 f0       	push   $0xf01077dc
f010264e:	68 49 04 00 00       	push   $0x449
f0102653:	68 b6 77 10 f0       	push   $0xf01077b6
f0102658:	e8 e3 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010265d:	68 1c 80 10 f0       	push   $0xf010801c
f0102662:	68 dc 77 10 f0       	push   $0xf01077dc
f0102667:	68 4c 04 00 00       	push   $0x44c
f010266c:	68 b6 77 10 f0       	push   $0xf01077b6
f0102671:	e8 ca d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102676:	68 48 80 10 f0       	push   $0xf0108048
f010267b:	68 dc 77 10 f0       	push   $0xf01077dc
f0102680:	68 4d 04 00 00       	push   $0x44d
f0102685:	68 b6 77 10 f0       	push   $0xf01077b6
f010268a:	e8 b1 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f010268f:	68 ea 79 10 f0       	push   $0xf01079ea
f0102694:	68 dc 77 10 f0       	push   $0xf01077dc
f0102699:	68 4f 04 00 00       	push   $0x44f
f010269e:	68 b6 77 10 f0       	push   $0xf01077b6
f01026a3:	e8 98 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01026a8:	68 fb 79 10 f0       	push   $0xf01079fb
f01026ad:	68 dc 77 10 f0       	push   $0xf01077dc
f01026b2:	68 50 04 00 00       	push   $0x450
f01026b7:	68 b6 77 10 f0       	push   $0xf01077b6
f01026bc:	e8 7f d9 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01026c1:	68 78 80 10 f0       	push   $0xf0108078
f01026c6:	68 dc 77 10 f0       	push   $0xf01077dc
f01026cb:	68 53 04 00 00       	push   $0x453
f01026d0:	68 b6 77 10 f0       	push   $0xf01077b6
f01026d5:	e8 66 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01026da:	68 9c 80 10 f0       	push   $0xf010809c
f01026df:	68 dc 77 10 f0       	push   $0xf01077dc
f01026e4:	68 57 04 00 00       	push   $0x457
f01026e9:	68 b6 77 10 f0       	push   $0xf01077b6
f01026ee:	e8 4d d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01026f3:	68 48 80 10 f0       	push   $0xf0108048
f01026f8:	68 dc 77 10 f0       	push   $0xf01077dc
f01026fd:	68 58 04 00 00       	push   $0x458
f0102702:	68 b6 77 10 f0       	push   $0xf01077b6
f0102707:	e8 34 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f010270c:	68 a1 79 10 f0       	push   $0xf01079a1
f0102711:	68 dc 77 10 f0       	push   $0xf01077dc
f0102716:	68 59 04 00 00       	push   $0x459
f010271b:	68 b6 77 10 f0       	push   $0xf01077b6
f0102720:	e8 1b d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102725:	68 fb 79 10 f0       	push   $0xf01079fb
f010272a:	68 dc 77 10 f0       	push   $0xf01077dc
f010272f:	68 5a 04 00 00       	push   $0x45a
f0102734:	68 b6 77 10 f0       	push   $0xf01077b6
f0102739:	e8 02 d9 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f010273e:	68 c0 80 10 f0       	push   $0xf01080c0
f0102743:	68 dc 77 10 f0       	push   $0xf01077dc
f0102748:	68 5d 04 00 00       	push   $0x45d
f010274d:	68 b6 77 10 f0       	push   $0xf01077b6
f0102752:	e8 e9 d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f0102757:	68 0c 7a 10 f0       	push   $0xf0107a0c
f010275c:	68 dc 77 10 f0       	push   $0xf01077dc
f0102761:	68 5e 04 00 00       	push   $0x45e
f0102766:	68 b6 77 10 f0       	push   $0xf01077b6
f010276b:	e8 d0 d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f0102770:	68 18 7a 10 f0       	push   $0xf0107a18
f0102775:	68 dc 77 10 f0       	push   $0xf01077dc
f010277a:	68 5f 04 00 00       	push   $0x45f
f010277f:	68 b6 77 10 f0       	push   $0xf01077b6
f0102784:	e8 b7 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102789:	68 9c 80 10 f0       	push   $0xf010809c
f010278e:	68 dc 77 10 f0       	push   $0xf01077dc
f0102793:	68 63 04 00 00       	push   $0x463
f0102798:	68 b6 77 10 f0       	push   $0xf01077b6
f010279d:	e8 9e d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01027a2:	68 f8 80 10 f0       	push   $0xf01080f8
f01027a7:	68 dc 77 10 f0       	push   $0xf01077dc
f01027ac:	68 64 04 00 00       	push   $0x464
f01027b1:	68 b6 77 10 f0       	push   $0xf01077b6
f01027b6:	e8 85 d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f01027bb:	68 2d 7a 10 f0       	push   $0xf0107a2d
f01027c0:	68 dc 77 10 f0       	push   $0xf01077dc
f01027c5:	68 65 04 00 00       	push   $0x465
f01027ca:	68 b6 77 10 f0       	push   $0xf01077b6
f01027cf:	e8 6c d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01027d4:	68 fb 79 10 f0       	push   $0xf01079fb
f01027d9:	68 dc 77 10 f0       	push   $0xf01077dc
f01027de:	68 66 04 00 00       	push   $0x466
f01027e3:	68 b6 77 10 f0       	push   $0xf01077b6
f01027e8:	e8 53 d8 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f01027ed:	68 20 81 10 f0       	push   $0xf0108120
f01027f2:	68 dc 77 10 f0       	push   $0xf01077dc
f01027f7:	68 69 04 00 00       	push   $0x469
f01027fc:	68 b6 77 10 f0       	push   $0xf01077b6
f0102801:	e8 3a d8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102806:	68 4f 79 10 f0       	push   $0xf010794f
f010280b:	68 dc 77 10 f0       	push   $0xf01077dc
f0102810:	68 6c 04 00 00       	push   $0x46c
f0102815:	68 b6 77 10 f0       	push   $0xf01077b6
f010281a:	e8 21 d8 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010281f:	68 c4 7d 10 f0       	push   $0xf0107dc4
f0102824:	68 dc 77 10 f0       	push   $0xf01077dc
f0102829:	68 6f 04 00 00       	push   $0x46f
f010282e:	68 b6 77 10 f0       	push   $0xf01077b6
f0102833:	e8 08 d8 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102838:	68 b2 79 10 f0       	push   $0xf01079b2
f010283d:	68 dc 77 10 f0       	push   $0xf01077dc
f0102842:	68 71 04 00 00       	push   $0x471
f0102847:	68 b6 77 10 f0       	push   $0xf01077b6
f010284c:	e8 ef d7 ff ff       	call   f0100040 <_panic>
f0102851:	56                   	push   %esi
f0102852:	68 24 72 10 f0       	push   $0xf0107224
f0102857:	68 78 04 00 00       	push   $0x478
f010285c:	68 b6 77 10 f0       	push   $0xf01077b6
f0102861:	e8 da d7 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102866:	68 3e 7a 10 f0       	push   $0xf0107a3e
f010286b:	68 dc 77 10 f0       	push   $0xf01077dc
f0102870:	68 79 04 00 00       	push   $0x479
f0102875:	68 b6 77 10 f0       	push   $0xf01077b6
f010287a:	e8 c1 d7 ff ff       	call   f0100040 <_panic>
f010287f:	51                   	push   %ecx
f0102880:	68 24 72 10 f0       	push   $0xf0107224
f0102885:	6a 58                	push   $0x58
f0102887:	68 c2 77 10 f0       	push   $0xf01077c2
f010288c:	e8 af d7 ff ff       	call   f0100040 <_panic>
f0102891:	52                   	push   %edx
f0102892:	68 24 72 10 f0       	push   $0xf0107224
f0102897:	6a 58                	push   $0x58
f0102899:	68 c2 77 10 f0       	push   $0xf01077c2
f010289e:	e8 9d d7 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f01028a3:	68 56 7a 10 f0       	push   $0xf0107a56
f01028a8:	68 dc 77 10 f0       	push   $0xf01077dc
f01028ad:	68 83 04 00 00       	push   $0x483
f01028b2:	68 b6 77 10 f0       	push   $0xf01077b6
f01028b7:	e8 84 d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f01028bc:	68 44 81 10 f0       	push   $0xf0108144
f01028c1:	68 dc 77 10 f0       	push   $0xf01077dc
f01028c6:	68 93 04 00 00       	push   $0x493
f01028cb:	68 b6 77 10 f0       	push   $0xf01077b6
f01028d0:	e8 6b d7 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f01028d5:	68 6c 81 10 f0       	push   $0xf010816c
f01028da:	68 dc 77 10 f0       	push   $0xf01077dc
f01028df:	68 94 04 00 00       	push   $0x494
f01028e4:	68 b6 77 10 f0       	push   $0xf01077b6
f01028e9:	e8 52 d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01028ee:	68 94 81 10 f0       	push   $0xf0108194
f01028f3:	68 dc 77 10 f0       	push   $0xf01077dc
f01028f8:	68 96 04 00 00       	push   $0x496
f01028fd:	68 b6 77 10 f0       	push   $0xf01077b6
f0102902:	e8 39 d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102907:	68 6d 7a 10 f0       	push   $0xf0107a6d
f010290c:	68 dc 77 10 f0       	push   $0xf01077dc
f0102911:	68 98 04 00 00       	push   $0x498
f0102916:	68 b6 77 10 f0       	push   $0xf01077b6
f010291b:	e8 20 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102920:	68 bc 81 10 f0       	push   $0xf01081bc
f0102925:	68 dc 77 10 f0       	push   $0xf01077dc
f010292a:	68 9a 04 00 00       	push   $0x49a
f010292f:	68 b6 77 10 f0       	push   $0xf01077b6
f0102934:	e8 07 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102939:	68 e0 81 10 f0       	push   $0xf01081e0
f010293e:	68 dc 77 10 f0       	push   $0xf01077dc
f0102943:	68 9b 04 00 00       	push   $0x49b
f0102948:	68 b6 77 10 f0       	push   $0xf01077b6
f010294d:	e8 ee d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102952:	68 10 82 10 f0       	push   $0xf0108210
f0102957:	68 dc 77 10 f0       	push   $0xf01077dc
f010295c:	68 9c 04 00 00       	push   $0x49c
f0102961:	68 b6 77 10 f0       	push   $0xf01077b6
f0102966:	e8 d5 d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f010296b:	68 34 82 10 f0       	push   $0xf0108234
f0102970:	68 dc 77 10 f0       	push   $0xf01077dc
f0102975:	68 9d 04 00 00       	push   $0x49d
f010297a:	68 b6 77 10 f0       	push   $0xf01077b6
f010297f:	e8 bc d6 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102984:	68 60 82 10 f0       	push   $0xf0108260
f0102989:	68 dc 77 10 f0       	push   $0xf01077dc
f010298e:	68 9f 04 00 00       	push   $0x49f
f0102993:	68 b6 77 10 f0       	push   $0xf01077b6
f0102998:	e8 a3 d6 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f010299d:	68 a4 82 10 f0       	push   $0xf01082a4
f01029a2:	68 dc 77 10 f0       	push   $0xf01077dc
f01029a7:	68 a0 04 00 00       	push   $0x4a0
f01029ac:	68 b6 77 10 f0       	push   $0xf01077b6
f01029b1:	e8 8a d6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01029b6:	50                   	push   %eax
f01029b7:	68 48 72 10 f0       	push   $0xf0107248
f01029bc:	68 ca 00 00 00       	push   $0xca
f01029c1:	68 b6 77 10 f0       	push   $0xf01077b6
f01029c6:	e8 75 d6 ff ff       	call   f0100040 <_panic>
f01029cb:	50                   	push   %eax
f01029cc:	68 48 72 10 f0       	push   $0xf0107248
f01029d1:	68 d5 00 00 00       	push   $0xd5
f01029d6:	68 b6 77 10 f0       	push   $0xf01077b6
f01029db:	e8 60 d6 ff ff       	call   f0100040 <_panic>
f01029e0:	50                   	push   %eax
f01029e1:	68 48 72 10 f0       	push   $0xf0107248
f01029e6:	68 e2 00 00 00       	push   $0xe2
f01029eb:	68 b6 77 10 f0       	push   $0xf01077b6
f01029f0:	e8 4b d6 ff ff       	call   f0100040 <_panic>
f01029f5:	53                   	push   %ebx
f01029f6:	68 48 72 10 f0       	push   $0xf0107248
f01029fb:	68 24 01 00 00       	push   $0x124
f0102a00:	68 b6 77 10 f0       	push   $0xf01077b6
f0102a05:	e8 36 d6 ff ff       	call   f0100040 <_panic>
f0102a0a:	56                   	push   %esi
f0102a0b:	68 48 72 10 f0       	push   $0xf0107248
f0102a10:	68 b8 03 00 00       	push   $0x3b8
f0102a15:	68 b6 77 10 f0       	push   $0xf01077b6
f0102a1a:	e8 21 d6 ff ff       	call   f0100040 <_panic>
	for (i = 0; i < n; i += PGSIZE)
f0102a1f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102a25:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f0102a28:	76 3a                	jbe    f0102a64 <mem_init+0x1627>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102a2a:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0102a30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a33:	e8 30 e1 ff ff       	call   f0100b68 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102a38:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f0102a3f:	76 c9                	jbe    f0102a0a <mem_init+0x15cd>
f0102a41:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0102a44:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f0102a47:	39 d0                	cmp    %edx,%eax
f0102a49:	74 d4                	je     f0102a1f <mem_init+0x15e2>
f0102a4b:	68 d8 82 10 f0       	push   $0xf01082d8
f0102a50:	68 dc 77 10 f0       	push   $0xf01077dc
f0102a55:	68 b8 03 00 00       	push   $0x3b8
f0102a5a:	68 b6 77 10 f0       	push   $0xf01077b6
f0102a5f:	e8 dc d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102a64:	a1 48 12 2c f0       	mov    0xf02c1248,%eax
f0102a69:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0102a6c:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102a6f:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102a74:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102a7a:	89 da                	mov    %ebx,%edx
f0102a7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a7f:	e8 e4 e0 ff ff       	call   f0100b68 <check_va2pa>
f0102a84:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102a8b:	76 3b                	jbe    f0102ac8 <mem_init+0x168b>
f0102a8d:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102a90:	39 d0                	cmp    %edx,%eax
f0102a92:	75 4b                	jne    f0102adf <mem_init+0x16a2>
f0102a94:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102a9a:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f0102aa0:	75 d8                	jne    f0102a7a <mem_init+0x163d>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102aa2:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102aa5:	c1 e6 0c             	shl    $0xc,%esi
f0102aa8:	89 fb                	mov    %edi,%ebx
f0102aaa:	39 f3                	cmp    %esi,%ebx
f0102aac:	73 63                	jae    f0102b11 <mem_init+0x16d4>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102aae:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102ab4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102ab7:	e8 ac e0 ff ff       	call   f0100b68 <check_va2pa>
f0102abc:	39 c3                	cmp    %eax,%ebx
f0102abe:	75 38                	jne    f0102af8 <mem_init+0x16bb>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102ac0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102ac6:	eb e2                	jmp    f0102aaa <mem_init+0x166d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102ac8:	ff 75 c8             	pushl  -0x38(%ebp)
f0102acb:	68 48 72 10 f0       	push   $0xf0107248
f0102ad0:	68 bd 03 00 00       	push   $0x3bd
f0102ad5:	68 b6 77 10 f0       	push   $0xf01077b6
f0102ada:	e8 61 d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102adf:	68 0c 83 10 f0       	push   $0xf010830c
f0102ae4:	68 dc 77 10 f0       	push   $0xf01077dc
f0102ae9:	68 bd 03 00 00       	push   $0x3bd
f0102aee:	68 b6 77 10 f0       	push   $0xf01077b6
f0102af3:	e8 48 d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102af8:	68 40 83 10 f0       	push   $0xf0108340
f0102afd:	68 dc 77 10 f0       	push   $0xf01077dc
f0102b02:	68 c1 03 00 00       	push   $0x3c1
f0102b07:	68 b6 77 10 f0       	push   $0xf01077b6
f0102b0c:	e8 2f d5 ff ff       	call   f0100040 <_panic>
f0102b11:	c7 45 cc 00 30 2d 00 	movl   $0x2d3000,-0x34(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102b18:	bb 00 80 ff ef       	mov    $0xefff8000,%ebx
f0102b1d:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102b20:	8d bb 00 80 ff ff    	lea    -0x8000(%ebx),%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102b26:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102b29:	89 45 bc             	mov    %eax,-0x44(%ebp)
f0102b2c:	89 de                	mov    %ebx,%esi
f0102b2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102b31:	05 00 80 ff 0f       	add    $0xfff8000,%eax
f0102b36:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102b39:	8d 83 00 80 00 00    	lea    0x8000(%ebx),%eax
f0102b3f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102b42:	89 f2                	mov    %esi,%edx
f0102b44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b47:	e8 1c e0 ff ff       	call   f0100b68 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102b4c:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102b53:	76 58                	jbe    f0102bad <mem_init+0x1770>
f0102b55:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0102b58:	8d 14 31             	lea    (%ecx,%esi,1),%edx
f0102b5b:	39 d0                	cmp    %edx,%eax
f0102b5d:	75 65                	jne    f0102bc4 <mem_init+0x1787>
f0102b5f:	81 c6 00 10 00 00    	add    $0x1000,%esi
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102b65:	3b 75 c4             	cmp    -0x3c(%ebp),%esi
f0102b68:	75 d8                	jne    f0102b42 <mem_init+0x1705>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102b6a:	89 fa                	mov    %edi,%edx
f0102b6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b6f:	e8 f4 df ff ff       	call   f0100b68 <check_va2pa>
f0102b74:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102b77:	75 64                	jne    f0102bdd <mem_init+0x17a0>
f0102b79:	81 c7 00 10 00 00    	add    $0x1000,%edi
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102b7f:	39 df                	cmp    %ebx,%edi
f0102b81:	75 e7                	jne    f0102b6a <mem_init+0x172d>
f0102b83:	81 eb 00 00 01 00    	sub    $0x10000,%ebx
f0102b89:	81 45 d0 00 80 00 00 	addl   $0x8000,-0x30(%ebp)
f0102b90:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102b93:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
	for (n = 0; n < NCPU; n++) {
f0102b9a:	3d 00 30 30 f0       	cmp    $0xf0303000,%eax
f0102b9f:	0f 85 7b ff ff ff    	jne    f0102b20 <mem_init+0x16e3>
f0102ba5:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0102ba8:	e9 84 00 00 00       	jmp    f0102c31 <mem_init+0x17f4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102bad:	ff 75 bc             	pushl  -0x44(%ebp)
f0102bb0:	68 48 72 10 f0       	push   $0xf0107248
f0102bb5:	68 c9 03 00 00       	push   $0x3c9
f0102bba:	68 b6 77 10 f0       	push   $0xf01077b6
f0102bbf:	e8 7c d4 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102bc4:	68 68 83 10 f0       	push   $0xf0108368
f0102bc9:	68 dc 77 10 f0       	push   $0xf01077dc
f0102bce:	68 c8 03 00 00       	push   $0x3c8
f0102bd3:	68 b6 77 10 f0       	push   $0xf01077b6
f0102bd8:	e8 63 d4 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102bdd:	68 b0 83 10 f0       	push   $0xf01083b0
f0102be2:	68 dc 77 10 f0       	push   $0xf01077dc
f0102be7:	68 cb 03 00 00       	push   $0x3cb
f0102bec:	68 b6 77 10 f0       	push   $0xf01077b6
f0102bf1:	e8 4a d4 ff ff       	call   f0100040 <_panic>
			assert(pgdir[i] & PTE_P);
f0102bf6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102bf9:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102bfd:	75 4e                	jne    f0102c4d <mem_init+0x1810>
f0102bff:	68 98 7a 10 f0       	push   $0xf0107a98
f0102c04:	68 dc 77 10 f0       	push   $0xf01077dc
f0102c09:	68 d6 03 00 00       	push   $0x3d6
f0102c0e:	68 b6 77 10 f0       	push   $0xf01077b6
f0102c13:	e8 28 d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102c18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102c1b:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0102c1e:	a8 01                	test   $0x1,%al
f0102c20:	74 30                	je     f0102c52 <mem_init+0x1815>
				assert(pgdir[i] & PTE_W);
f0102c22:	a8 02                	test   $0x2,%al
f0102c24:	74 45                	je     f0102c6b <mem_init+0x182e>
	for (i = 0; i < NPDENTRIES; i++) {
f0102c26:	83 c7 01             	add    $0x1,%edi
f0102c29:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0102c2f:	74 6c                	je     f0102c9d <mem_init+0x1860>
		switch (i) {
f0102c31:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f0102c37:	83 f8 04             	cmp    $0x4,%eax
f0102c3a:	76 ba                	jbe    f0102bf6 <mem_init+0x17b9>
			if (i >= PDX(KERNBASE)) {
f0102c3c:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102c42:	77 d4                	ja     f0102c18 <mem_init+0x17db>
				assert(pgdir[i] == 0);
f0102c44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102c47:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102c4b:	75 37                	jne    f0102c84 <mem_init+0x1847>
	for (i = 0; i < NPDENTRIES; i++) {
f0102c4d:	83 c7 01             	add    $0x1,%edi
f0102c50:	eb df                	jmp    f0102c31 <mem_init+0x17f4>
				assert(pgdir[i] & PTE_P);
f0102c52:	68 98 7a 10 f0       	push   $0xf0107a98
f0102c57:	68 dc 77 10 f0       	push   $0xf01077dc
f0102c5c:	68 da 03 00 00       	push   $0x3da
f0102c61:	68 b6 77 10 f0       	push   $0xf01077b6
f0102c66:	e8 d5 d3 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f0102c6b:	68 a9 7a 10 f0       	push   $0xf0107aa9
f0102c70:	68 dc 77 10 f0       	push   $0xf01077dc
f0102c75:	68 db 03 00 00       	push   $0x3db
f0102c7a:	68 b6 77 10 f0       	push   $0xf01077b6
f0102c7f:	e8 bc d3 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102c84:	68 ba 7a 10 f0       	push   $0xf0107aba
f0102c89:	68 dc 77 10 f0       	push   $0xf01077dc
f0102c8e:	68 dd 03 00 00       	push   $0x3dd
f0102c93:	68 b6 77 10 f0       	push   $0xf01077b6
f0102c98:	e8 a3 d3 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102c9d:	83 ec 0c             	sub    $0xc,%esp
f0102ca0:	68 d4 83 10 f0       	push   $0xf01083d4
f0102ca5:	e8 8c 0d 00 00       	call   f0103a36 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102caa:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
	if ((uint32_t)kva < KERNBASE)
f0102caf:	83 c4 10             	add    $0x10,%esp
f0102cb2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102cb7:	0f 86 03 02 00 00    	jbe    f0102ec0 <mem_init+0x1a83>
	return (physaddr_t)kva - KERNBASE;
f0102cbd:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102cc2:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102cc5:	b8 00 00 00 00       	mov    $0x0,%eax
f0102cca:	e8 fc de ff ff       	call   f0100bcb <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102ccf:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102cd2:	83 e0 f3             	and    $0xfffffff3,%eax
f0102cd5:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102cda:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102cdd:	83 ec 0c             	sub    $0xc,%esp
f0102ce0:	6a 00                	push   $0x0
f0102ce2:	e8 20 e3 ff ff       	call   f0101007 <page_alloc>
f0102ce7:	89 c6                	mov    %eax,%esi
f0102ce9:	83 c4 10             	add    $0x10,%esp
f0102cec:	85 c0                	test   %eax,%eax
f0102cee:	0f 84 e1 01 00 00    	je     f0102ed5 <mem_init+0x1a98>
	assert((pp1 = page_alloc(0)));
f0102cf4:	83 ec 0c             	sub    $0xc,%esp
f0102cf7:	6a 00                	push   $0x0
f0102cf9:	e8 09 e3 ff ff       	call   f0101007 <page_alloc>
f0102cfe:	89 c7                	mov    %eax,%edi
f0102d00:	83 c4 10             	add    $0x10,%esp
f0102d03:	85 c0                	test   %eax,%eax
f0102d05:	0f 84 e3 01 00 00    	je     f0102eee <mem_init+0x1ab1>
	assert((pp2 = page_alloc(0)));
f0102d0b:	83 ec 0c             	sub    $0xc,%esp
f0102d0e:	6a 00                	push   $0x0
f0102d10:	e8 f2 e2 ff ff       	call   f0101007 <page_alloc>
f0102d15:	89 c3                	mov    %eax,%ebx
f0102d17:	83 c4 10             	add    $0x10,%esp
f0102d1a:	85 c0                	test   %eax,%eax
f0102d1c:	0f 84 e5 01 00 00    	je     f0102f07 <mem_init+0x1aca>
	page_free(pp0);
f0102d22:	83 ec 0c             	sub    $0xc,%esp
f0102d25:	56                   	push   %esi
f0102d26:	e8 67 e3 ff ff       	call   f0101092 <page_free>
	return (pp - pages) << PGSHIFT;
f0102d2b:	89 f8                	mov    %edi,%eax
f0102d2d:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0102d33:	c1 f8 03             	sar    $0x3,%eax
f0102d36:	89 c2                	mov    %eax,%edx
f0102d38:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102d3b:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102d40:	83 c4 10             	add    $0x10,%esp
f0102d43:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f0102d49:	0f 83 d1 01 00 00    	jae    f0102f20 <mem_init+0x1ae3>
	memset(page2kva(pp1), 1, PGSIZE);
f0102d4f:	83 ec 04             	sub    $0x4,%esp
f0102d52:	68 00 10 00 00       	push   $0x1000
f0102d57:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102d59:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102d5f:	52                   	push   %edx
f0102d60:	e8 64 2e 00 00       	call   f0105bc9 <memset>
	return (pp - pages) << PGSHIFT;
f0102d65:	89 d8                	mov    %ebx,%eax
f0102d67:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0102d6d:	c1 f8 03             	sar    $0x3,%eax
f0102d70:	89 c2                	mov    %eax,%edx
f0102d72:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102d75:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102d7a:	83 c4 10             	add    $0x10,%esp
f0102d7d:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f0102d83:	0f 83 a9 01 00 00    	jae    f0102f32 <mem_init+0x1af5>
	memset(page2kva(pp2), 2, PGSIZE);
f0102d89:	83 ec 04             	sub    $0x4,%esp
f0102d8c:	68 00 10 00 00       	push   $0x1000
f0102d91:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102d93:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102d99:	52                   	push   %edx
f0102d9a:	e8 2a 2e 00 00       	call   f0105bc9 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102d9f:	6a 02                	push   $0x2
f0102da1:	68 00 10 00 00       	push   $0x1000
f0102da6:	57                   	push   %edi
f0102da7:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0102dad:	e8 91 e5 ff ff       	call   f0101343 <page_insert>
	assert(pp1->pp_ref == 1);
f0102db2:	83 c4 20             	add    $0x20,%esp
f0102db5:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102dba:	0f 85 84 01 00 00    	jne    f0102f44 <mem_init+0x1b07>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102dc0:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102dc7:	01 01 01 
f0102dca:	0f 85 8d 01 00 00    	jne    f0102f5d <mem_init+0x1b20>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102dd0:	6a 02                	push   $0x2
f0102dd2:	68 00 10 00 00       	push   $0x1000
f0102dd7:	53                   	push   %ebx
f0102dd8:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0102dde:	e8 60 e5 ff ff       	call   f0101343 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102de3:	83 c4 10             	add    $0x10,%esp
f0102de6:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102ded:	02 02 02 
f0102df0:	0f 85 80 01 00 00    	jne    f0102f76 <mem_init+0x1b39>
	assert(pp2->pp_ref == 1);
f0102df6:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102dfb:	0f 85 8e 01 00 00    	jne    f0102f8f <mem_init+0x1b52>
	assert(pp1->pp_ref == 0);
f0102e01:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102e06:	0f 85 9c 01 00 00    	jne    f0102fa8 <mem_init+0x1b6b>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102e0c:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102e13:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102e16:	89 d8                	mov    %ebx,%eax
f0102e18:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0102e1e:	c1 f8 03             	sar    $0x3,%eax
f0102e21:	89 c2                	mov    %eax,%edx
f0102e23:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102e26:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102e2b:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f0102e31:	0f 83 8a 01 00 00    	jae    f0102fc1 <mem_init+0x1b84>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102e37:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f0102e3e:	03 03 03 
f0102e41:	0f 85 8c 01 00 00    	jne    f0102fd3 <mem_init+0x1b96>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102e47:	83 ec 08             	sub    $0x8,%esp
f0102e4a:	68 00 10 00 00       	push   $0x1000
f0102e4f:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0102e55:	e8 9f e4 ff ff       	call   f01012f9 <page_remove>
	assert(pp2->pp_ref == 0);
f0102e5a:	83 c4 10             	add    $0x10,%esp
f0102e5d:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102e62:	0f 85 84 01 00 00    	jne    f0102fec <mem_init+0x1baf>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102e68:	8b 0d 9c 1e 2c f0    	mov    0xf02c1e9c,%ecx
f0102e6e:	8b 11                	mov    (%ecx),%edx
f0102e70:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102e76:	89 f0                	mov    %esi,%eax
f0102e78:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f0102e7e:	c1 f8 03             	sar    $0x3,%eax
f0102e81:	c1 e0 0c             	shl    $0xc,%eax
f0102e84:	39 c2                	cmp    %eax,%edx
f0102e86:	0f 85 79 01 00 00    	jne    f0103005 <mem_init+0x1bc8>
	kern_pgdir[0] = 0;
f0102e8c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102e92:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102e97:	0f 85 81 01 00 00    	jne    f010301e <mem_init+0x1be1>
	pp0->pp_ref = 0;
f0102e9d:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0102ea3:	83 ec 0c             	sub    $0xc,%esp
f0102ea6:	56                   	push   %esi
f0102ea7:	e8 e6 e1 ff ff       	call   f0101092 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102eac:	c7 04 24 68 84 10 f0 	movl   $0xf0108468,(%esp)
f0102eb3:	e8 7e 0b 00 00       	call   f0103a36 <cprintf>
}
f0102eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102ebb:	5b                   	pop    %ebx
f0102ebc:	5e                   	pop    %esi
f0102ebd:	5f                   	pop    %edi
f0102ebe:	5d                   	pop    %ebp
f0102ebf:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102ec0:	50                   	push   %eax
f0102ec1:	68 48 72 10 f0       	push   $0xf0107248
f0102ec6:	68 fb 00 00 00       	push   $0xfb
f0102ecb:	68 b6 77 10 f0       	push   $0xf01077b6
f0102ed0:	e8 6b d1 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102ed5:	68 a4 78 10 f0       	push   $0xf01078a4
f0102eda:	68 dc 77 10 f0       	push   $0xf01077dc
f0102edf:	68 b5 04 00 00       	push   $0x4b5
f0102ee4:	68 b6 77 10 f0       	push   $0xf01077b6
f0102ee9:	e8 52 d1 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102eee:	68 ba 78 10 f0       	push   $0xf01078ba
f0102ef3:	68 dc 77 10 f0       	push   $0xf01077dc
f0102ef8:	68 b6 04 00 00       	push   $0x4b6
f0102efd:	68 b6 77 10 f0       	push   $0xf01077b6
f0102f02:	e8 39 d1 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102f07:	68 d0 78 10 f0       	push   $0xf01078d0
f0102f0c:	68 dc 77 10 f0       	push   $0xf01077dc
f0102f11:	68 b7 04 00 00       	push   $0x4b7
f0102f16:	68 b6 77 10 f0       	push   $0xf01077b6
f0102f1b:	e8 20 d1 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102f20:	52                   	push   %edx
f0102f21:	68 24 72 10 f0       	push   $0xf0107224
f0102f26:	6a 58                	push   $0x58
f0102f28:	68 c2 77 10 f0       	push   $0xf01077c2
f0102f2d:	e8 0e d1 ff ff       	call   f0100040 <_panic>
f0102f32:	52                   	push   %edx
f0102f33:	68 24 72 10 f0       	push   $0xf0107224
f0102f38:	6a 58                	push   $0x58
f0102f3a:	68 c2 77 10 f0       	push   $0xf01077c2
f0102f3f:	e8 fc d0 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102f44:	68 a1 79 10 f0       	push   $0xf01079a1
f0102f49:	68 dc 77 10 f0       	push   $0xf01077dc
f0102f4e:	68 bc 04 00 00       	push   $0x4bc
f0102f53:	68 b6 77 10 f0       	push   $0xf01077b6
f0102f58:	e8 e3 d0 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102f5d:	68 f4 83 10 f0       	push   $0xf01083f4
f0102f62:	68 dc 77 10 f0       	push   $0xf01077dc
f0102f67:	68 bd 04 00 00       	push   $0x4bd
f0102f6c:	68 b6 77 10 f0       	push   $0xf01077b6
f0102f71:	e8 ca d0 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102f76:	68 18 84 10 f0       	push   $0xf0108418
f0102f7b:	68 dc 77 10 f0       	push   $0xf01077dc
f0102f80:	68 bf 04 00 00       	push   $0x4bf
f0102f85:	68 b6 77 10 f0       	push   $0xf01077b6
f0102f8a:	e8 b1 d0 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102f8f:	68 c3 79 10 f0       	push   $0xf01079c3
f0102f94:	68 dc 77 10 f0       	push   $0xf01077dc
f0102f99:	68 c0 04 00 00       	push   $0x4c0
f0102f9e:	68 b6 77 10 f0       	push   $0xf01077b6
f0102fa3:	e8 98 d0 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102fa8:	68 2d 7a 10 f0       	push   $0xf0107a2d
f0102fad:	68 dc 77 10 f0       	push   $0xf01077dc
f0102fb2:	68 c1 04 00 00       	push   $0x4c1
f0102fb7:	68 b6 77 10 f0       	push   $0xf01077b6
f0102fbc:	e8 7f d0 ff ff       	call   f0100040 <_panic>
f0102fc1:	52                   	push   %edx
f0102fc2:	68 24 72 10 f0       	push   $0xf0107224
f0102fc7:	6a 58                	push   $0x58
f0102fc9:	68 c2 77 10 f0       	push   $0xf01077c2
f0102fce:	e8 6d d0 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102fd3:	68 3c 84 10 f0       	push   $0xf010843c
f0102fd8:	68 dc 77 10 f0       	push   $0xf01077dc
f0102fdd:	68 c3 04 00 00       	push   $0x4c3
f0102fe2:	68 b6 77 10 f0       	push   $0xf01077b6
f0102fe7:	e8 54 d0 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102fec:	68 fb 79 10 f0       	push   $0xf01079fb
f0102ff1:	68 dc 77 10 f0       	push   $0xf01077dc
f0102ff6:	68 c5 04 00 00       	push   $0x4c5
f0102ffb:	68 b6 77 10 f0       	push   $0xf01077b6
f0103000:	e8 3b d0 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103005:	68 c4 7d 10 f0       	push   $0xf0107dc4
f010300a:	68 dc 77 10 f0       	push   $0xf01077dc
f010300f:	68 c8 04 00 00       	push   $0x4c8
f0103014:	68 b6 77 10 f0       	push   $0xf01077b6
f0103019:	e8 22 d0 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f010301e:	68 b2 79 10 f0       	push   $0xf01079b2
f0103023:	68 dc 77 10 f0       	push   $0xf01077dc
f0103028:	68 ca 04 00 00       	push   $0x4ca
f010302d:	68 b6 77 10 f0       	push   $0xf01077b6
f0103032:	e8 09 d0 ff ff       	call   f0100040 <_panic>

f0103037 <user_mem_check>:
{
f0103037:	f3 0f 1e fb          	endbr32 
f010303b:	55                   	push   %ebp
f010303c:	89 e5                	mov    %esp,%ebp
f010303e:	57                   	push   %edi
f010303f:	56                   	push   %esi
f0103040:	53                   	push   %ebx
f0103041:	83 ec 0c             	sub    $0xc,%esp
    vstart = ROUNDDOWN((uintptr_t)va, PGSIZE);
f0103044:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103047:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    vend = ROUNDUP((uintptr_t)va + len, PGSIZE);
f010304d:	8b 45 10             	mov    0x10(%ebp),%eax
f0103050:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103053:	8d bc 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edi
f010305a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if (vend > ULIM) {
f0103060:	81 ff 00 00 80 ef    	cmp    $0xef800000,%edi
f0103066:	77 08                	ja     f0103070 <user_mem_check+0x39>
        if (!pte || (*pte & (perm | PTE_P)) != (perm | PTE_P)) {
f0103068:	8b 75 14             	mov    0x14(%ebp),%esi
f010306b:	83 ce 01             	or     $0x1,%esi
f010306e:	eb 22                	jmp    f0103092 <user_mem_check+0x5b>
        user_mem_check_addr = MAX(ULIM, (uintptr_t)va);
f0103070:	81 7d 0c 00 00 80 ef 	cmpl   $0xef800000,0xc(%ebp)
f0103077:	b8 00 00 80 ef       	mov    $0xef800000,%eax
f010307c:	0f 43 45 0c          	cmovae 0xc(%ebp),%eax
f0103080:	a3 3c 12 2c f0       	mov    %eax,0xf02c123c
        return -E_FAULT;
f0103085:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f010308a:	eb 3c                	jmp    f01030c8 <user_mem_check+0x91>
    for (; vstart < vend; vstart += PGSIZE) {
f010308c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103092:	39 fb                	cmp    %edi,%ebx
f0103094:	73 3a                	jae    f01030d0 <user_mem_check+0x99>
        pte = pgdir_walk(env->env_pgdir, (void*)vstart, 0);
f0103096:	83 ec 04             	sub    $0x4,%esp
f0103099:	6a 00                	push   $0x0
f010309b:	53                   	push   %ebx
f010309c:	8b 45 08             	mov    0x8(%ebp),%eax
f010309f:	ff 70 60             	pushl  0x60(%eax)
f01030a2:	e8 6e e0 ff ff       	call   f0101115 <pgdir_walk>
        if (!pte || (*pte & (perm | PTE_P)) != (perm | PTE_P)) {
f01030a7:	83 c4 10             	add    $0x10,%esp
f01030aa:	85 c0                	test   %eax,%eax
f01030ac:	74 08                	je     f01030b6 <user_mem_check+0x7f>
f01030ae:	89 f2                	mov    %esi,%edx
f01030b0:	23 10                	and    (%eax),%edx
f01030b2:	39 d6                	cmp    %edx,%esi
f01030b4:	74 d6                	je     f010308c <user_mem_check+0x55>
            user_mem_check_addr = MAX(vstart, (uintptr_t)va);
f01030b6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f01030b9:	0f 42 5d 0c          	cmovb  0xc(%ebp),%ebx
f01030bd:	89 1d 3c 12 2c f0    	mov    %ebx,0xf02c123c
            return -E_FAULT;
f01030c3:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f01030c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01030cb:	5b                   	pop    %ebx
f01030cc:	5e                   	pop    %esi
f01030cd:	5f                   	pop    %edi
f01030ce:	5d                   	pop    %ebp
f01030cf:	c3                   	ret    
    return 0;
f01030d0:	b8 00 00 00 00       	mov    $0x0,%eax
f01030d5:	eb f1                	jmp    f01030c8 <user_mem_check+0x91>

f01030d7 <user_mem_assert>:
{
f01030d7:	f3 0f 1e fb          	endbr32 
f01030db:	55                   	push   %ebp
f01030dc:	89 e5                	mov    %esp,%ebp
f01030de:	53                   	push   %ebx
f01030df:	83 ec 04             	sub    $0x4,%esp
f01030e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f01030e5:	8b 45 14             	mov    0x14(%ebp),%eax
f01030e8:	83 c8 04             	or     $0x4,%eax
f01030eb:	50                   	push   %eax
f01030ec:	ff 75 10             	pushl  0x10(%ebp)
f01030ef:	ff 75 0c             	pushl  0xc(%ebp)
f01030f2:	53                   	push   %ebx
f01030f3:	e8 3f ff ff ff       	call   f0103037 <user_mem_check>
f01030f8:	83 c4 10             	add    $0x10,%esp
f01030fb:	85 c0                	test   %eax,%eax
f01030fd:	78 05                	js     f0103104 <user_mem_assert+0x2d>
}
f01030ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103102:	c9                   	leave  
f0103103:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0103104:	83 ec 04             	sub    $0x4,%esp
f0103107:	ff 35 3c 12 2c f0    	pushl  0xf02c123c
f010310d:	ff 73 48             	pushl  0x48(%ebx)
f0103110:	68 94 84 10 f0       	push   $0xf0108494
f0103115:	e8 1c 09 00 00       	call   f0103a36 <cprintf>
		env_destroy(env);	// may not return
f010311a:	89 1c 24             	mov    %ebx,(%esp)
f010311d:	e8 13 06 00 00       	call   f0103735 <env_destroy>
f0103122:	83 c4 10             	add    $0x10,%esp
}
f0103125:	eb d8                	jmp    f01030ff <user_mem_assert+0x28>

f0103127 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0103127:	55                   	push   %ebp
f0103128:	89 e5                	mov    %esp,%ebp
f010312a:	57                   	push   %edi
f010312b:	56                   	push   %esi
f010312c:	53                   	push   %ebx
f010312d:	83 ec 0c             	sub    $0xc,%esp
f0103130:	89 c7                	mov    %eax,%edi
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	// ROUNDDOWN/ROUNDUP在inc/types.h中
	void* begin = ROUNDDOWN(va, PGSIZE);
f0103132:	89 d3                	mov    %edx,%ebx
f0103134:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	void* end = ROUNDUP(va + len, PGSIZE);
f010313a:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f0103141:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	while(begin < end){
f0103147:	39 f3                	cmp    %esi,%ebx
f0103149:	73 3f                	jae    f010318a <region_alloc+0x63>
		struct PageInfo* pp = page_alloc(0);
f010314b:	83 ec 0c             	sub    $0xc,%esp
f010314e:	6a 00                	push   $0x0
f0103150:	e8 b2 de ff ff       	call   f0101007 <page_alloc>
		if(!pp){
f0103155:	83 c4 10             	add    $0x10,%esp
f0103158:	85 c0                	test   %eax,%eax
f010315a:	74 17                	je     f0103173 <region_alloc+0x4c>
			panic("region_alloc failed\n");
		}
		page_insert(e->env_pgdir, pp, begin, PTE_W | PTE_U);
f010315c:	6a 06                	push   $0x6
f010315e:	53                   	push   %ebx
f010315f:	50                   	push   %eax
f0103160:	ff 77 60             	pushl  0x60(%edi)
f0103163:	e8 db e1 ff ff       	call   f0101343 <page_insert>
		begin += PGSIZE;
f0103168:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010316e:	83 c4 10             	add    $0x10,%esp
f0103171:	eb d4                	jmp    f0103147 <region_alloc+0x20>
			panic("region_alloc failed\n");
f0103173:	83 ec 04             	sub    $0x4,%esp
f0103176:	68 c9 84 10 f0       	push   $0xf01084c9
f010317b:	68 2c 01 00 00       	push   $0x12c
f0103180:	68 de 84 10 f0       	push   $0xf01084de
f0103185:	e8 b6 ce ff ff       	call   f0100040 <_panic>
	}
}
f010318a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010318d:	5b                   	pop    %ebx
f010318e:	5e                   	pop    %esi
f010318f:	5f                   	pop    %edi
f0103190:	5d                   	pop    %ebp
f0103191:	c3                   	ret    

f0103192 <envid2env>:
{
f0103192:	f3 0f 1e fb          	endbr32 
f0103196:	55                   	push   %ebp
f0103197:	89 e5                	mov    %esp,%ebp
f0103199:	56                   	push   %esi
f010319a:	53                   	push   %ebx
f010319b:	8b 75 08             	mov    0x8(%ebp),%esi
f010319e:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f01031a1:	85 f6                	test   %esi,%esi
f01031a3:	74 2e                	je     f01031d3 <envid2env+0x41>
	e = &envs[ENVX(envid)];
f01031a5:	89 f3                	mov    %esi,%ebx
f01031a7:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f01031ad:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f01031b0:	03 1d 48 12 2c f0    	add    0xf02c1248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f01031b6:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f01031ba:	74 2e                	je     f01031ea <envid2env+0x58>
f01031bc:	39 73 48             	cmp    %esi,0x48(%ebx)
f01031bf:	75 29                	jne    f01031ea <envid2env+0x58>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01031c1:	84 c0                	test   %al,%al
f01031c3:	75 35                	jne    f01031fa <envid2env+0x68>
	*env_store = e;
f01031c5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01031c8:	89 18                	mov    %ebx,(%eax)
	return 0;
f01031ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01031cf:	5b                   	pop    %ebx
f01031d0:	5e                   	pop    %esi
f01031d1:	5d                   	pop    %ebp
f01031d2:	c3                   	ret    
		*env_store = curenv;
f01031d3:	e8 12 30 00 00       	call   f01061ea <cpunum>
f01031d8:	6b c0 74             	imul   $0x74,%eax,%eax
f01031db:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f01031e1:	8b 55 0c             	mov    0xc(%ebp),%edx
f01031e4:	89 02                	mov    %eax,(%edx)
		return 0;
f01031e6:	89 f0                	mov    %esi,%eax
f01031e8:	eb e5                	jmp    f01031cf <envid2env+0x3d>
		*env_store = 0;
f01031ea:	8b 45 0c             	mov    0xc(%ebp),%eax
f01031ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01031f3:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01031f8:	eb d5                	jmp    f01031cf <envid2env+0x3d>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01031fa:	e8 eb 2f 00 00       	call   f01061ea <cpunum>
f01031ff:	6b c0 74             	imul   $0x74,%eax,%eax
f0103202:	39 98 28 20 2c f0    	cmp    %ebx,-0xfd3dfd8(%eax)
f0103208:	74 bb                	je     f01031c5 <envid2env+0x33>
f010320a:	8b 73 4c             	mov    0x4c(%ebx),%esi
f010320d:	e8 d8 2f 00 00       	call   f01061ea <cpunum>
f0103212:	6b c0 74             	imul   $0x74,%eax,%eax
f0103215:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f010321b:	3b 70 48             	cmp    0x48(%eax),%esi
f010321e:	74 a5                	je     f01031c5 <envid2env+0x33>
		*env_store = 0;
f0103220:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103223:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103229:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010322e:	eb 9f                	jmp    f01031cf <envid2env+0x3d>

f0103230 <env_init_percpu>:
{
f0103230:	f3 0f 1e fb          	endbr32 
	asm volatile("lgdt (%0)" : : "r" (p));
f0103234:	b8 20 63 12 f0       	mov    $0xf0126320,%eax
f0103239:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f010323c:	b8 23 00 00 00       	mov    $0x23,%eax
f0103241:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f0103243:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f0103245:	b8 10 00 00 00       	mov    $0x10,%eax
f010324a:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f010324c:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f010324e:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103250:	ea 57 32 10 f0 08 00 	ljmp   $0x8,$0xf0103257
	asm volatile("lldt %0" : : "r" (sel));
f0103257:	b8 00 00 00 00       	mov    $0x0,%eax
f010325c:	0f 00 d0             	lldt   %ax
}
f010325f:	c3                   	ret    

f0103260 <env_init>:
{
f0103260:	f3 0f 1e fb          	endbr32 
f0103264:	55                   	push   %ebp
f0103265:	89 e5                	mov    %esp,%ebp
f0103267:	56                   	push   %esi
f0103268:	53                   	push   %ebx
		envs[i].env_id = 0;
f0103269:	8b 35 48 12 2c f0    	mov    0xf02c1248,%esi
f010326f:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f0103275:	89 f3                	mov    %esi,%ebx
f0103277:	ba 00 00 00 00       	mov    $0x0,%edx
f010327c:	89 d1                	mov    %edx,%ecx
f010327e:	89 c2                	mov    %eax,%edx
f0103280:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_link = env_free_list;
f0103287:	89 48 44             	mov    %ecx,0x44(%eax)
f010328a:	83 e8 7c             	sub    $0x7c,%eax
	for(i = NENV - 1; i >= 0; i--){
f010328d:	39 da                	cmp    %ebx,%edx
f010328f:	75 eb                	jne    f010327c <env_init+0x1c>
f0103291:	89 35 4c 12 2c f0    	mov    %esi,0xf02c124c
	env_init_percpu();
f0103297:	e8 94 ff ff ff       	call   f0103230 <env_init_percpu>
}
f010329c:	5b                   	pop    %ebx
f010329d:	5e                   	pop    %esi
f010329e:	5d                   	pop    %ebp
f010329f:	c3                   	ret    

f01032a0 <env_alloc>:
{
f01032a0:	f3 0f 1e fb          	endbr32 
f01032a4:	55                   	push   %ebp
f01032a5:	89 e5                	mov    %esp,%ebp
f01032a7:	53                   	push   %ebx
f01032a8:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f01032ab:	8b 1d 4c 12 2c f0    	mov    0xf02c124c,%ebx
f01032b1:	85 db                	test   %ebx,%ebx
f01032b3:	0f 84 3b 01 00 00    	je     f01033f4 <env_alloc+0x154>
	if (!(p = page_alloc(ALLOC_ZERO)))
f01032b9:	83 ec 0c             	sub    $0xc,%esp
f01032bc:	6a 01                	push   $0x1
f01032be:	e8 44 dd ff ff       	call   f0101007 <page_alloc>
f01032c3:	83 c4 10             	add    $0x10,%esp
f01032c6:	85 c0                	test   %eax,%eax
f01032c8:	0f 84 2d 01 00 00    	je     f01033fb <env_alloc+0x15b>
	p->pp_ref++;
f01032ce:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01032d3:	2b 05 a0 1e 2c f0    	sub    0xf02c1ea0,%eax
f01032d9:	c1 f8 03             	sar    $0x3,%eax
f01032dc:	89 c2                	mov    %eax,%edx
f01032de:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01032e1:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01032e6:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f01032ec:	0f 83 db 00 00 00    	jae    f01033cd <env_alloc+0x12d>
	return (void *)(pa + KERNBASE);
f01032f2:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	e->env_pgdir = (pde_t *)page2kva(p);
f01032f8:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f01032fb:	83 ec 04             	sub    $0x4,%esp
f01032fe:	68 00 10 00 00       	push   $0x1000
f0103303:	ff 35 9c 1e 2c f0    	pushl  0xf02c1e9c
f0103309:	50                   	push   %eax
f010330a:	e8 6c 29 00 00       	call   f0105c7b <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f010330f:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103312:	83 c4 10             	add    $0x10,%esp
f0103315:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010331a:	0f 86 bf 00 00 00    	jbe    f01033df <env_alloc+0x13f>
	return (physaddr_t)kva - KERNBASE;
f0103320:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103326:	83 ca 05             	or     $0x5,%edx
f0103329:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f010332f:	8b 43 48             	mov    0x48(%ebx),%eax
f0103332:	05 00 10 00 00       	add    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
f0103337:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f010333c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103341:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103344:	89 da                	mov    %ebx,%edx
f0103346:	2b 15 48 12 2c f0    	sub    0xf02c1248,%edx
f010334c:	c1 fa 02             	sar    $0x2,%edx
f010334f:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f0103355:	09 d0                	or     %edx,%eax
f0103357:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f010335a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010335d:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103360:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103367:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f010336e:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103375:	83 ec 04             	sub    $0x4,%esp
f0103378:	6a 44                	push   $0x44
f010337a:	6a 00                	push   $0x0
f010337c:	53                   	push   %ebx
f010337d:	e8 47 28 00 00       	call   f0105bc9 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f0103382:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103388:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f010338e:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103394:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f010339b:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f01033a1:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f01033a8:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f01033af:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f01033b3:	8b 43 44             	mov    0x44(%ebx),%eax
f01033b6:	a3 4c 12 2c f0       	mov    %eax,0xf02c124c
	*newenv_store = e;
f01033bb:	8b 45 08             	mov    0x8(%ebp),%eax
f01033be:	89 18                	mov    %ebx,(%eax)
	return 0;
f01033c0:	83 c4 10             	add    $0x10,%esp
f01033c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01033c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01033cb:	c9                   	leave  
f01033cc:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01033cd:	52                   	push   %edx
f01033ce:	68 24 72 10 f0       	push   $0xf0107224
f01033d3:	6a 58                	push   $0x58
f01033d5:	68 c2 77 10 f0       	push   $0xf01077c2
f01033da:	e8 61 cc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033df:	50                   	push   %eax
f01033e0:	68 48 72 10 f0       	push   $0xf0107248
f01033e5:	68 c7 00 00 00       	push   $0xc7
f01033ea:	68 de 84 10 f0       	push   $0xf01084de
f01033ef:	e8 4c cc ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f01033f4:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f01033f9:	eb cd                	jmp    f01033c8 <env_alloc+0x128>
		return -E_NO_MEM;
f01033fb:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103400:	eb c6                	jmp    f01033c8 <env_alloc+0x128>

f0103402 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103402:	f3 0f 1e fb          	endbr32 
f0103406:	55                   	push   %ebp
f0103407:	89 e5                	mov    %esp,%ebp
f0103409:	57                   	push   %edi
f010340a:	56                   	push   %esi
f010340b:	53                   	push   %ebx
f010340c:	83 ec 34             	sub    $0x34,%esp
f010340f:	8b 75 08             	mov    0x8(%ebp),%esi
	// LAB 3: Your code here.

	// Allocates a new env with env_alloc
	struct Env* env;
	int r;
	if(env_alloc(&env, 0)){
f0103412:	6a 00                	push   $0x0
f0103414:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103417:	50                   	push   %eax
f0103418:	e8 83 fe ff ff       	call   f01032a0 <env_alloc>
f010341d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103420:	83 c4 10             	add    $0x10,%esp
f0103423:	85 c0                	test   %eax,%eax
f0103425:	75 3a                	jne    f0103461 <env_create+0x5f>
		panic("env_create failed: create env failed\n");
	}

	// loads the named elf binary into it with load_icode
	load_icode(env, binary);
f0103427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010342a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(header->e_magic != ELF_MAGIC)
f010342d:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
f0103433:	75 43                	jne    f0103478 <env_create+0x76>
	if(header->e_entry == 0)
f0103435:	83 7e 18 00          	cmpl   $0x0,0x18(%esi)
f0103439:	74 54                	je     f010348f <env_create+0x8d>
	struct Proghdr* ph = (struct Proghdr*)((uint8_t*)header + header->e_phoff);
f010343b:	8b 5e 1c             	mov    0x1c(%esi),%ebx
	int phnum = header->e_phnum;
f010343e:	0f b7 46 2c          	movzwl 0x2c(%esi),%eax
f0103442:	89 45 cc             	mov    %eax,-0x34(%ebp)
	lcr3(PADDR(e->env_pgdir));
f0103445:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103448:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f010344b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103450:	76 54                	jbe    f01034a6 <env_create+0xa4>
	return (physaddr_t)kva - KERNBASE;
f0103452:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103457:	0f 22 d8             	mov    %eax,%cr3
f010345a:	01 f3                	add    %esi,%ebx
	for(i = 0; i < phnum; i++){
f010345c:	e9 93 00 00 00       	jmp    f01034f4 <env_create+0xf2>
		panic("env_create failed: create env failed\n");
f0103461:	83 ec 04             	sub    $0x4,%esp
f0103464:	68 f8 84 10 f0       	push   $0xf01084f8
f0103469:	68 bf 01 00 00       	push   $0x1bf
f010346e:	68 de 84 10 f0       	push   $0xf01084de
f0103473:	e8 c8 cb ff ff       	call   f0100040 <_panic>
		panic("load_icode failed: the binary is not elf\n");
f0103478:	83 ec 04             	sub    $0x4,%esp
f010347b:	68 20 85 10 f0       	push   $0xf0108520
f0103480:	68 6b 01 00 00       	push   $0x16b
f0103485:	68 de 84 10 f0       	push   $0xf01084de
f010348a:	e8 b1 cb ff ff       	call   f0100040 <_panic>
		panic("load_icode failed: the elf can't be executed\n");
f010348f:	83 ec 04             	sub    $0x4,%esp
f0103492:	68 4c 85 10 f0       	push   $0xf010854c
f0103497:	68 6d 01 00 00       	push   $0x16d
f010349c:	68 de 84 10 f0       	push   $0xf01084de
f01034a1:	e8 9a cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01034a6:	50                   	push   %eax
f01034a7:	68 48 72 10 f0       	push   $0xf0107248
f01034ac:	68 7f 01 00 00       	push   $0x17f
f01034b1:	68 de 84 10 f0       	push   $0xf01084de
f01034b6:	e8 85 cb ff ff       	call   f0100040 <_panic>
			region_alloc(e, (void*)ph[i].p_va, ph[i].p_memsz);
f01034bb:	8b 53 08             	mov    0x8(%ebx),%edx
f01034be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01034c1:	e8 61 fc ff ff       	call   f0103127 <region_alloc>
			memset((void*)ph[i].p_va, 0, ph[i].p_memsz);
f01034c6:	83 ec 04             	sub    $0x4,%esp
f01034c9:	ff 73 14             	pushl  0x14(%ebx)
f01034cc:	6a 00                	push   $0x0
f01034ce:	ff 73 08             	pushl  0x8(%ebx)
f01034d1:	e8 f3 26 00 00       	call   f0105bc9 <memset>
			memcpy((void*)ph[i].p_va, binary + ph[i].p_offset, ph[i].p_filesz);
f01034d6:	83 c4 0c             	add    $0xc,%esp
f01034d9:	ff 73 10             	pushl  0x10(%ebx)
f01034dc:	89 f0                	mov    %esi,%eax
f01034de:	03 43 04             	add    0x4(%ebx),%eax
f01034e1:	50                   	push   %eax
f01034e2:	ff 73 08             	pushl  0x8(%ebx)
f01034e5:	e8 91 27 00 00       	call   f0105c7b <memcpy>
f01034ea:	83 c4 10             	add    $0x10,%esp
	for(i = 0; i < phnum; i++){
f01034ed:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
f01034f1:	83 c3 20             	add    $0x20,%ebx
f01034f4:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01034f7:	39 55 cc             	cmp    %edx,-0x34(%ebp)
f01034fa:	74 24                	je     f0103520 <env_create+0x11e>
		if(ph[i].p_type == ELF_PROG_LOAD){
f01034fc:	83 3b 01             	cmpl   $0x1,(%ebx)
f01034ff:	75 ec                	jne    f01034ed <env_create+0xeb>
			if(ph[i].p_memsz < ph[i].p_filesz){
f0103501:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0103504:	3b 4b 10             	cmp    0x10(%ebx),%ecx
f0103507:	73 b2                	jae    f01034bb <env_create+0xb9>
				panic("load_icode failed: p_memsz < p_filesz.\n");
f0103509:	83 ec 04             	sub    $0x4,%esp
f010350c:	68 7c 85 10 f0       	push   $0xf010857c
f0103511:	68 89 01 00 00       	push   $0x189
f0103516:	68 de 84 10 f0       	push   $0xf01084de
f010351b:	e8 20 cb ff ff       	call   f0100040 <_panic>
	e->env_tf.tf_eip = header->e_entry;
f0103520:	8b 46 18             	mov    0x18(%esi),%eax
f0103523:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103526:	89 41 30             	mov    %eax,0x30(%ecx)
	lcr3(PADDR(kern_pgdir));
f0103529:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
	if ((uint32_t)kva < KERNBASE)
f010352e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103533:	76 31                	jbe    f0103566 <env_create+0x164>
	return (physaddr_t)kva - KERNBASE;
f0103535:	05 00 00 00 10       	add    $0x10000000,%eax
f010353a:	0f 22 d8             	mov    %eax,%cr3
	region_alloc(e, (void*)(USTACKTOP - PGSIZE), PGSIZE);
f010353d:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103542:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103547:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010354a:	e8 d8 fb ff ff       	call   f0103127 <region_alloc>

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	if(type == ENV_TYPE_FS){
f010354f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f0103553:	74 26                	je     f010357b <env_create+0x179>
		env->env_tf.tf_eflags |= FL_IOPL_MASK;
	}

	// sets its env_type.
	env->env_type = type;
f0103555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103558:	8b 55 0c             	mov    0xc(%ebp),%edx
f010355b:	89 50 50             	mov    %edx,0x50(%eax)
}
f010355e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103561:	5b                   	pop    %ebx
f0103562:	5e                   	pop    %esi
f0103563:	5f                   	pop    %edi
f0103564:	5d                   	pop    %ebp
f0103565:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103566:	50                   	push   %eax
f0103567:	68 48 72 10 f0       	push   $0xf0107248
f010356c:	68 a5 01 00 00       	push   $0x1a5
f0103571:	68 de 84 10 f0       	push   $0xf01084de
f0103576:	e8 c5 ca ff ff       	call   f0100040 <_panic>
		env->env_tf.tf_eflags |= FL_IOPL_MASK;
f010357b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010357e:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
f0103585:	eb ce                	jmp    f0103555 <env_create+0x153>

f0103587 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103587:	f3 0f 1e fb          	endbr32 
f010358b:	55                   	push   %ebp
f010358c:	89 e5                	mov    %esp,%ebp
f010358e:	57                   	push   %edi
f010358f:	56                   	push   %esi
f0103590:	53                   	push   %ebx
f0103591:	83 ec 1c             	sub    $0x1c,%esp
f0103594:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103597:	e8 4e 2c 00 00       	call   f01061ea <cpunum>
f010359c:	6b c0 74             	imul   $0x74,%eax,%eax
f010359f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01035a6:	39 b8 28 20 2c f0    	cmp    %edi,-0xfd3dfd8(%eax)
f01035ac:	0f 85 b3 00 00 00    	jne    f0103665 <env_free+0xde>
		lcr3(PADDR(kern_pgdir));
f01035b2:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
	if ((uint32_t)kva < KERNBASE)
f01035b7:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035bc:	76 14                	jbe    f01035d2 <env_free+0x4b>
	return (physaddr_t)kva - KERNBASE;
f01035be:	05 00 00 00 10       	add    $0x10000000,%eax
f01035c3:	0f 22 d8             	mov    %eax,%cr3
}
f01035c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01035cd:	e9 93 00 00 00       	jmp    f0103665 <env_free+0xde>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01035d2:	50                   	push   %eax
f01035d3:	68 48 72 10 f0       	push   $0xf0107248
f01035d8:	68 dd 01 00 00       	push   $0x1dd
f01035dd:	68 de 84 10 f0       	push   $0xf01084de
f01035e2:	e8 59 ca ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01035e7:	56                   	push   %esi
f01035e8:	68 24 72 10 f0       	push   $0xf0107224
f01035ed:	68 ec 01 00 00       	push   $0x1ec
f01035f2:	68 de 84 10 f0       	push   $0xf01084de
f01035f7:	e8 44 ca ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01035fc:	83 ec 08             	sub    $0x8,%esp
f01035ff:	89 d8                	mov    %ebx,%eax
f0103601:	c1 e0 0c             	shl    $0xc,%eax
f0103604:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103607:	50                   	push   %eax
f0103608:	ff 77 60             	pushl  0x60(%edi)
f010360b:	e8 e9 dc ff ff       	call   f01012f9 <page_remove>
f0103610:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103613:	83 c3 01             	add    $0x1,%ebx
f0103616:	83 c6 04             	add    $0x4,%esi
f0103619:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f010361f:	74 07                	je     f0103628 <env_free+0xa1>
			if (pt[pteno] & PTE_P)
f0103621:	f6 06 01             	testb  $0x1,(%esi)
f0103624:	74 ed                	je     f0103613 <env_free+0x8c>
f0103626:	eb d4                	jmp    f01035fc <env_free+0x75>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103628:	8b 47 60             	mov    0x60(%edi),%eax
f010362b:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010362e:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103635:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103638:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f010363e:	73 65                	jae    f01036a5 <env_free+0x11e>
		page_decref(pa2page(pa));
f0103640:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103643:	a1 a0 1e 2c f0       	mov    0xf02c1ea0,%eax
f0103648:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010364b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f010364e:	50                   	push   %eax
f010364f:	e8 94 da ff ff       	call   f01010e8 <page_decref>
f0103654:	83 c4 10             	add    $0x10,%esp
f0103657:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f010365b:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f010365e:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103663:	74 54                	je     f01036b9 <env_free+0x132>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103665:	8b 47 60             	mov    0x60(%edi),%eax
f0103668:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010366b:	8b 04 10             	mov    (%eax,%edx,1),%eax
f010366e:	a8 01                	test   $0x1,%al
f0103670:	74 e5                	je     f0103657 <env_free+0xd0>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103672:	89 c6                	mov    %eax,%esi
f0103674:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f010367a:	c1 e8 0c             	shr    $0xc,%eax
f010367d:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103680:	39 05 98 1e 2c f0    	cmp    %eax,0xf02c1e98
f0103686:	0f 86 5b ff ff ff    	jbe    f01035e7 <env_free+0x60>
	return (void *)(pa + KERNBASE);
f010368c:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103692:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103695:	c1 e0 14             	shl    $0x14,%eax
f0103698:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f010369b:	bb 00 00 00 00       	mov    $0x0,%ebx
f01036a0:	e9 7c ff ff ff       	jmp    f0103621 <env_free+0x9a>
		panic("pa2page called with invalid pa");
f01036a5:	83 ec 04             	sub    $0x4,%esp
f01036a8:	68 5c 7c 10 f0       	push   $0xf0107c5c
f01036ad:	6a 51                	push   $0x51
f01036af:	68 c2 77 10 f0       	push   $0xf01077c2
f01036b4:	e8 87 c9 ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01036b9:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f01036bc:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01036c1:	76 49                	jbe    f010370c <env_free+0x185>
	e->env_pgdir = 0;
f01036c3:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f01036ca:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01036cf:	c1 e8 0c             	shr    $0xc,%eax
f01036d2:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f01036d8:	73 47                	jae    f0103721 <env_free+0x19a>
	page_decref(pa2page(pa));
f01036da:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01036dd:	8b 15 a0 1e 2c f0    	mov    0xf02c1ea0,%edx
f01036e3:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01036e6:	50                   	push   %eax
f01036e7:	e8 fc d9 ff ff       	call   f01010e8 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01036ec:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f01036f3:	a1 4c 12 2c f0       	mov    0xf02c124c,%eax
f01036f8:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f01036fb:	89 3d 4c 12 2c f0    	mov    %edi,0xf02c124c
}
f0103701:	83 c4 10             	add    $0x10,%esp
f0103704:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103707:	5b                   	pop    %ebx
f0103708:	5e                   	pop    %esi
f0103709:	5f                   	pop    %edi
f010370a:	5d                   	pop    %ebp
f010370b:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010370c:	50                   	push   %eax
f010370d:	68 48 72 10 f0       	push   $0xf0107248
f0103712:	68 fa 01 00 00       	push   $0x1fa
f0103717:	68 de 84 10 f0       	push   $0xf01084de
f010371c:	e8 1f c9 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f0103721:	83 ec 04             	sub    $0x4,%esp
f0103724:	68 5c 7c 10 f0       	push   $0xf0107c5c
f0103729:	6a 51                	push   $0x51
f010372b:	68 c2 77 10 f0       	push   $0xf01077c2
f0103730:	e8 0b c9 ff ff       	call   f0100040 <_panic>

f0103735 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103735:	f3 0f 1e fb          	endbr32 
f0103739:	55                   	push   %ebp
f010373a:	89 e5                	mov    %esp,%ebp
f010373c:	53                   	push   %ebx
f010373d:	83 ec 04             	sub    $0x4,%esp
f0103740:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103743:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103747:	74 21                	je     f010376a <env_destroy+0x35>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103749:	83 ec 0c             	sub    $0xc,%esp
f010374c:	53                   	push   %ebx
f010374d:	e8 35 fe ff ff       	call   f0103587 <env_free>

	if (curenv == e) {
f0103752:	e8 93 2a 00 00       	call   f01061ea <cpunum>
f0103757:	6b c0 74             	imul   $0x74,%eax,%eax
f010375a:	83 c4 10             	add    $0x10,%esp
f010375d:	39 98 28 20 2c f0    	cmp    %ebx,-0xfd3dfd8(%eax)
f0103763:	74 1e                	je     f0103783 <env_destroy+0x4e>
		curenv = NULL;
		sched_yield();
	}
}
f0103765:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103768:	c9                   	leave  
f0103769:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010376a:	e8 7b 2a 00 00       	call   f01061ea <cpunum>
f010376f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103772:	39 98 28 20 2c f0    	cmp    %ebx,-0xfd3dfd8(%eax)
f0103778:	74 cf                	je     f0103749 <env_destroy+0x14>
		e->env_status = ENV_DYING;
f010377a:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103781:	eb e2                	jmp    f0103765 <env_destroy+0x30>
		curenv = NULL;
f0103783:	e8 62 2a 00 00       	call   f01061ea <cpunum>
f0103788:	6b c0 74             	imul   $0x74,%eax,%eax
f010378b:	c7 80 28 20 2c f0 00 	movl   $0x0,-0xfd3dfd8(%eax)
f0103792:	00 00 00 
		sched_yield();
f0103795:	e8 f3 10 00 00       	call   f010488d <sched_yield>

f010379a <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f010379a:	f3 0f 1e fb          	endbr32 
f010379e:	55                   	push   %ebp
f010379f:	89 e5                	mov    %esp,%ebp
f01037a1:	53                   	push   %ebx
f01037a2:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f01037a5:	e8 40 2a 00 00       	call   f01061ea <cpunum>
f01037aa:	6b c0 74             	imul   $0x74,%eax,%eax
f01037ad:	8b 98 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%ebx
f01037b3:	e8 32 2a 00 00       	call   f01061ea <cpunum>
f01037b8:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f01037bb:	8b 65 08             	mov    0x8(%ebp),%esp
f01037be:	61                   	popa   
f01037bf:	07                   	pop    %es
f01037c0:	1f                   	pop    %ds
f01037c1:	83 c4 08             	add    $0x8,%esp
f01037c4:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f01037c5:	83 ec 04             	sub    $0x4,%esp
f01037c8:	68 e9 84 10 f0       	push   $0xf01084e9
f01037cd:	68 31 02 00 00       	push   $0x231
f01037d2:	68 de 84 10 f0       	push   $0xf01084de
f01037d7:	e8 64 c8 ff ff       	call   f0100040 <_panic>

f01037dc <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01037dc:	f3 0f 1e fb          	endbr32 
f01037e0:	55                   	push   %ebp
f01037e1:	89 e5                	mov    %esp,%ebp
f01037e3:	53                   	push   %ebx
f01037e4:	83 ec 04             	sub    $0x4,%esp
f01037e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != NULL && curenv->env_status == ENV_RUNNING){
f01037ea:	e8 fb 29 00 00       	call   f01061ea <cpunum>
f01037ef:	6b c0 74             	imul   $0x74,%eax,%eax
f01037f2:	83 b8 28 20 2c f0 00 	cmpl   $0x0,-0xfd3dfd8(%eax)
f01037f9:	74 14                	je     f010380f <env_run+0x33>
f01037fb:	e8 ea 29 00 00       	call   f01061ea <cpunum>
f0103800:	6b c0 74             	imul   $0x74,%eax,%eax
f0103803:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f0103809:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010380d:	74 42                	je     f0103851 <env_run+0x75>
		//但是查看了好多人的实现都没有
		//暂时存疑
		//curenv->env_runs--;
	}

	curenv = e;
f010380f:	e8 d6 29 00 00       	call   f01061ea <cpunum>
f0103814:	6b c0 74             	imul   $0x74,%eax,%eax
f0103817:	89 98 28 20 2c f0    	mov    %ebx,-0xfd3dfd8(%eax)
	e->env_status = ENV_RUNNING;
f010381d:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
	e->env_runs++;
f0103824:	83 43 58 01          	addl   $0x1,0x58(%ebx)
	lcr3(PADDR(e->env_pgdir));
f0103828:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010382b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103830:	76 36                	jbe    f0103868 <env_run+0x8c>
	return (physaddr_t)kva - KERNBASE;
f0103832:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103837:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f010383a:	83 ec 0c             	sub    $0xc,%esp
f010383d:	68 c0 63 12 f0       	push   $0xf01263c0
f0103842:	e8 c9 2c 00 00       	call   f0106510 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103847:	f3 90                	pause  
	unlock_kernel();
	env_pop_tf(&e->env_tf);
f0103849:	89 1c 24             	mov    %ebx,(%esp)
f010384c:	e8 49 ff ff ff       	call   f010379a <env_pop_tf>
		curenv->env_status = ENV_RUNNABLE;
f0103851:	e8 94 29 00 00       	call   f01061ea <cpunum>
f0103856:	6b c0 74             	imul   $0x74,%eax,%eax
f0103859:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f010385f:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103866:	eb a7                	jmp    f010380f <env_run+0x33>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103868:	50                   	push   %eax
f0103869:	68 48 72 10 f0       	push   $0xf0107248
f010386e:	68 5a 02 00 00       	push   $0x25a
f0103873:	68 de 84 10 f0       	push   $0xf01084de
f0103878:	e8 c3 c7 ff ff       	call   f0100040 <_panic>

f010387d <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010387d:	f3 0f 1e fb          	endbr32 
f0103881:	55                   	push   %ebp
f0103882:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103884:	8b 45 08             	mov    0x8(%ebp),%eax
f0103887:	ba 70 00 00 00       	mov    $0x70,%edx
f010388c:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010388d:	ba 71 00 00 00       	mov    $0x71,%edx
f0103892:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103893:	0f b6 c0             	movzbl %al,%eax
}
f0103896:	5d                   	pop    %ebp
f0103897:	c3                   	ret    

f0103898 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103898:	f3 0f 1e fb          	endbr32 
f010389c:	55                   	push   %ebp
f010389d:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010389f:	8b 45 08             	mov    0x8(%ebp),%eax
f01038a2:	ba 70 00 00 00       	mov    $0x70,%edx
f01038a7:	ee                   	out    %al,(%dx)
f01038a8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01038ab:	ba 71 00 00 00       	mov    $0x71,%edx
f01038b0:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01038b1:	5d                   	pop    %ebp
f01038b2:	c3                   	ret    

f01038b3 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01038b3:	f3 0f 1e fb          	endbr32 
f01038b7:	55                   	push   %ebp
f01038b8:	89 e5                	mov    %esp,%ebp
f01038ba:	56                   	push   %esi
f01038bb:	53                   	push   %ebx
f01038bc:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f01038bf:	66 a3 a8 63 12 f0    	mov    %ax,0xf01263a8
	if (!didinit)
f01038c5:	80 3d 50 12 2c f0 00 	cmpb   $0x0,0xf02c1250
f01038cc:	75 07                	jne    f01038d5 <irq_setmask_8259A+0x22>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f01038ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01038d1:	5b                   	pop    %ebx
f01038d2:	5e                   	pop    %esi
f01038d3:	5d                   	pop    %ebp
f01038d4:	c3                   	ret    
f01038d5:	89 c6                	mov    %eax,%esi
f01038d7:	ba 21 00 00 00       	mov    $0x21,%edx
f01038dc:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f01038dd:	66 c1 e8 08          	shr    $0x8,%ax
f01038e1:	ba a1 00 00 00       	mov    $0xa1,%edx
f01038e6:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01038e7:	83 ec 0c             	sub    $0xc,%esp
f01038ea:	68 a4 85 10 f0       	push   $0xf01085a4
f01038ef:	e8 42 01 00 00       	call   f0103a36 <cprintf>
f01038f4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01038f7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01038fc:	0f b7 f6             	movzwl %si,%esi
f01038ff:	f7 d6                	not    %esi
f0103901:	eb 19                	jmp    f010391c <irq_setmask_8259A+0x69>
			cprintf(" %d", i);
f0103903:	83 ec 08             	sub    $0x8,%esp
f0103906:	53                   	push   %ebx
f0103907:	68 8b 8a 10 f0       	push   $0xf0108a8b
f010390c:	e8 25 01 00 00       	call   f0103a36 <cprintf>
f0103911:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103914:	83 c3 01             	add    $0x1,%ebx
f0103917:	83 fb 10             	cmp    $0x10,%ebx
f010391a:	74 07                	je     f0103923 <irq_setmask_8259A+0x70>
		if (~mask & (1<<i))
f010391c:	0f a3 de             	bt     %ebx,%esi
f010391f:	73 f3                	jae    f0103914 <irq_setmask_8259A+0x61>
f0103921:	eb e0                	jmp    f0103903 <irq_setmask_8259A+0x50>
	cprintf("\n");
f0103923:	83 ec 0c             	sub    $0xc,%esp
f0103926:	68 96 7a 10 f0       	push   $0xf0107a96
f010392b:	e8 06 01 00 00       	call   f0103a36 <cprintf>
f0103930:	83 c4 10             	add    $0x10,%esp
f0103933:	eb 99                	jmp    f01038ce <irq_setmask_8259A+0x1b>

f0103935 <pic_init>:
{
f0103935:	f3 0f 1e fb          	endbr32 
f0103939:	55                   	push   %ebp
f010393a:	89 e5                	mov    %esp,%ebp
f010393c:	57                   	push   %edi
f010393d:	56                   	push   %esi
f010393e:	53                   	push   %ebx
f010393f:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103942:	c6 05 50 12 2c f0 01 	movb   $0x1,0xf02c1250
f0103949:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010394e:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103953:	89 da                	mov    %ebx,%edx
f0103955:	ee                   	out    %al,(%dx)
f0103956:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f010395b:	89 ca                	mov    %ecx,%edx
f010395d:	ee                   	out    %al,(%dx)
f010395e:	bf 11 00 00 00       	mov    $0x11,%edi
f0103963:	be 20 00 00 00       	mov    $0x20,%esi
f0103968:	89 f8                	mov    %edi,%eax
f010396a:	89 f2                	mov    %esi,%edx
f010396c:	ee                   	out    %al,(%dx)
f010396d:	b8 20 00 00 00       	mov    $0x20,%eax
f0103972:	89 da                	mov    %ebx,%edx
f0103974:	ee                   	out    %al,(%dx)
f0103975:	b8 04 00 00 00       	mov    $0x4,%eax
f010397a:	ee                   	out    %al,(%dx)
f010397b:	b8 03 00 00 00       	mov    $0x3,%eax
f0103980:	ee                   	out    %al,(%dx)
f0103981:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103986:	89 f8                	mov    %edi,%eax
f0103988:	89 da                	mov    %ebx,%edx
f010398a:	ee                   	out    %al,(%dx)
f010398b:	b8 28 00 00 00       	mov    $0x28,%eax
f0103990:	89 ca                	mov    %ecx,%edx
f0103992:	ee                   	out    %al,(%dx)
f0103993:	b8 02 00 00 00       	mov    $0x2,%eax
f0103998:	ee                   	out    %al,(%dx)
f0103999:	b8 01 00 00 00       	mov    $0x1,%eax
f010399e:	ee                   	out    %al,(%dx)
f010399f:	bf 68 00 00 00       	mov    $0x68,%edi
f01039a4:	89 f8                	mov    %edi,%eax
f01039a6:	89 f2                	mov    %esi,%edx
f01039a8:	ee                   	out    %al,(%dx)
f01039a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
f01039ae:	89 c8                	mov    %ecx,%eax
f01039b0:	ee                   	out    %al,(%dx)
f01039b1:	89 f8                	mov    %edi,%eax
f01039b3:	89 da                	mov    %ebx,%edx
f01039b5:	ee                   	out    %al,(%dx)
f01039b6:	89 c8                	mov    %ecx,%eax
f01039b8:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f01039b9:	0f b7 05 a8 63 12 f0 	movzwl 0xf01263a8,%eax
f01039c0:	66 83 f8 ff          	cmp    $0xffff,%ax
f01039c4:	75 08                	jne    f01039ce <pic_init+0x99>
}
f01039c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01039c9:	5b                   	pop    %ebx
f01039ca:	5e                   	pop    %esi
f01039cb:	5f                   	pop    %edi
f01039cc:	5d                   	pop    %ebp
f01039cd:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f01039ce:	83 ec 0c             	sub    $0xc,%esp
f01039d1:	0f b7 c0             	movzwl %ax,%eax
f01039d4:	50                   	push   %eax
f01039d5:	e8 d9 fe ff ff       	call   f01038b3 <irq_setmask_8259A>
f01039da:	83 c4 10             	add    $0x10,%esp
}
f01039dd:	eb e7                	jmp    f01039c6 <pic_init+0x91>

f01039df <irq_eoi>:

void
irq_eoi(void)
{
f01039df:	f3 0f 1e fb          	endbr32 
f01039e3:	b8 20 00 00 00       	mov    $0x20,%eax
f01039e8:	ba 20 00 00 00       	mov    $0x20,%edx
f01039ed:	ee                   	out    %al,(%dx)
f01039ee:	ba a0 00 00 00       	mov    $0xa0,%edx
f01039f3:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f01039f4:	c3                   	ret    

f01039f5 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01039f5:	f3 0f 1e fb          	endbr32 
f01039f9:	55                   	push   %ebp
f01039fa:	89 e5                	mov    %esp,%ebp
f01039fc:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f01039ff:	ff 75 08             	pushl  0x8(%ebp)
f0103a02:	e8 bb cd ff ff       	call   f01007c2 <cputchar>
	*cnt++;
}
f0103a07:	83 c4 10             	add    $0x10,%esp
f0103a0a:	c9                   	leave  
f0103a0b:	c3                   	ret    

f0103a0c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103a0c:	f3 0f 1e fb          	endbr32 
f0103a10:	55                   	push   %ebp
f0103a11:	89 e5                	mov    %esp,%ebp
f0103a13:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103a16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103a1d:	ff 75 0c             	pushl  0xc(%ebp)
f0103a20:	ff 75 08             	pushl  0x8(%ebp)
f0103a23:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103a26:	50                   	push   %eax
f0103a27:	68 f5 39 10 f0       	push   $0xf01039f5
f0103a2c:	e8 35 1a 00 00       	call   f0105466 <vprintfmt>
	return cnt;
}
f0103a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103a34:	c9                   	leave  
f0103a35:	c3                   	ret    

f0103a36 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103a36:	f3 0f 1e fb          	endbr32 
f0103a3a:	55                   	push   %ebp
f0103a3b:	89 e5                	mov    %esp,%ebp
f0103a3d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103a40:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103a43:	50                   	push   %eax
f0103a44:	ff 75 08             	pushl  0x8(%ebp)
f0103a47:	e8 c0 ff ff ff       	call   f0103a0c <vcprintf>
	va_end(ap);

	return cnt;
}
f0103a4c:	c9                   	leave  
f0103a4d:	c3                   	ret    

f0103a4e <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103a4e:	f3 0f 1e fb          	endbr32 
f0103a52:	55                   	push   %ebp
f0103a53:	89 e5                	mov    %esp,%ebp
f0103a55:	57                   	push   %edi
f0103a56:	56                   	push   %esi
f0103a57:	53                   	push   %ebx
f0103a58:	83 ec 1c             	sub    $0x1c,%esp
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	int i = cpunum();
f0103a5b:	e8 8a 27 00 00       	call   f01061ea <cpunum>
f0103a60:	89 c3                	mov    %eax,%ebx
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	// ts.ts_esp0 = KSTACKTOP;
	// ts.ts_ss0 = GD_KD;
	// ts.ts_iomb = sizeof(struct Taskstate);
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t)percpu_kstacks[i];
f0103a62:	e8 83 27 00 00       	call   f01061ea <cpunum>
f0103a67:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a6a:	89 da                	mov    %ebx,%edx
f0103a6c:	c1 e2 0f             	shl    $0xf,%edx
f0103a6f:	81 c2 00 30 2c f0    	add    $0xf02c3000,%edx
f0103a75:	89 90 30 20 2c f0    	mov    %edx,-0xfd3dfd0(%eax)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0103a7b:	e8 6a 27 00 00       	call   f01061ea <cpunum>
f0103a80:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a83:	66 c7 80 34 20 2c f0 	movw   $0x10,-0xfd3dfcc(%eax)
f0103a8a:	10 00 
	thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f0103a8c:	e8 59 27 00 00       	call   f01061ea <cpunum>
f0103a91:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a94:	66 c7 80 92 20 2c f0 	movw   $0x68,-0xfd3df6e(%eax)
f0103a9b:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	// gdt[GD_TSS0 >> 3].sd_s = 0;
	gdt[(GD_TSS0 >> 3) + i] = SEG16(STS_T32A, (uint32_t)(&thiscpu->cpu_ts),
f0103a9d:	8d 7b 05             	lea    0x5(%ebx),%edi
f0103aa0:	e8 45 27 00 00       	call   f01061ea <cpunum>
f0103aa5:	89 c6                	mov    %eax,%esi
f0103aa7:	e8 3e 27 00 00       	call   f01061ea <cpunum>
f0103aac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103aaf:	e8 36 27 00 00       	call   f01061ea <cpunum>
f0103ab4:	66 c7 04 fd 40 63 12 	movw   $0x67,-0xfed9cc0(,%edi,8)
f0103abb:	f0 67 00 
f0103abe:	6b f6 74             	imul   $0x74,%esi,%esi
f0103ac1:	81 c6 2c 20 2c f0    	add    $0xf02c202c,%esi
f0103ac7:	66 89 34 fd 42 63 12 	mov    %si,-0xfed9cbe(,%edi,8)
f0103ace:	f0 
f0103acf:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103ad3:	81 c2 2c 20 2c f0    	add    $0xf02c202c,%edx
f0103ad9:	c1 ea 10             	shr    $0x10,%edx
f0103adc:	88 14 fd 44 63 12 f0 	mov    %dl,-0xfed9cbc(,%edi,8)
f0103ae3:	c6 04 fd 46 63 12 f0 	movb   $0x40,-0xfed9cba(,%edi,8)
f0103aea:	40 
f0103aeb:	6b c0 74             	imul   $0x74,%eax,%eax
f0103aee:	05 2c 20 2c f0       	add    $0xf02c202c,%eax
f0103af3:	c1 e8 18             	shr    $0x18,%eax
f0103af6:	88 04 fd 47 63 12 f0 	mov    %al,-0xfed9cb9(,%edi,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + i].sd_s = 0;
f0103afd:	c6 04 fd 45 63 12 f0 	movb   $0x89,-0xfed9cbb(,%edi,8)
f0103b04:	89 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + (i << 3));
f0103b05:	8d 1c dd 28 00 00 00 	lea    0x28(,%ebx,8),%ebx
	asm volatile("ltr %0" : : "r" (sel));
f0103b0c:	0f 00 db             	ltr    %bx
	asm volatile("lidt (%0)" : : "r" (p));
f0103b0f:	b8 ac 63 12 f0       	mov    $0xf01263ac,%eax
f0103b14:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f0103b17:	83 c4 1c             	add    $0x1c,%esp
f0103b1a:	5b                   	pop    %ebx
f0103b1b:	5e                   	pop    %esi
f0103b1c:	5f                   	pop    %edi
f0103b1d:	5d                   	pop    %ebp
f0103b1e:	c3                   	ret    

f0103b1f <trap_init>:
{
f0103b1f:	f3 0f 1e fb          	endbr32 
f0103b23:	55                   	push   %ebp
f0103b24:	89 e5                	mov    %esp,%ebp
f0103b26:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE], 0, GD_KT, divide_handler, 0);
f0103b29:	b8 b6 46 10 f0       	mov    $0xf01046b6,%eax
f0103b2e:	66 a3 60 12 2c f0    	mov    %ax,0xf02c1260
f0103b34:	66 c7 05 62 12 2c f0 	movw   $0x8,0xf02c1262
f0103b3b:	08 00 
f0103b3d:	c6 05 64 12 2c f0 00 	movb   $0x0,0xf02c1264
f0103b44:	c6 05 65 12 2c f0 8e 	movb   $0x8e,0xf02c1265
f0103b4b:	c1 e8 10             	shr    $0x10,%eax
f0103b4e:	66 a3 66 12 2c f0    	mov    %ax,0xf02c1266
	SETGATE(idt[T_DEBUG], 0, GD_KT, debug_handler, 0);
f0103b54:	b8 c0 46 10 f0       	mov    $0xf01046c0,%eax
f0103b59:	66 a3 68 12 2c f0    	mov    %ax,0xf02c1268
f0103b5f:	66 c7 05 6a 12 2c f0 	movw   $0x8,0xf02c126a
f0103b66:	08 00 
f0103b68:	c6 05 6c 12 2c f0 00 	movb   $0x0,0xf02c126c
f0103b6f:	c6 05 6d 12 2c f0 8e 	movb   $0x8e,0xf02c126d
f0103b76:	c1 e8 10             	shr    $0x10,%eax
f0103b79:	66 a3 6e 12 2c f0    	mov    %ax,0xf02c126e
	SETGATE(idt[T_NMI], 0, GD_KT, nmi_handler, 0);
f0103b7f:	b8 ca 46 10 f0       	mov    $0xf01046ca,%eax
f0103b84:	66 a3 70 12 2c f0    	mov    %ax,0xf02c1270
f0103b8a:	66 c7 05 72 12 2c f0 	movw   $0x8,0xf02c1272
f0103b91:	08 00 
f0103b93:	c6 05 74 12 2c f0 00 	movb   $0x0,0xf02c1274
f0103b9a:	c6 05 75 12 2c f0 8e 	movb   $0x8e,0xf02c1275
f0103ba1:	c1 e8 10             	shr    $0x10,%eax
f0103ba4:	66 a3 76 12 2c f0    	mov    %ax,0xf02c1276
	SETGATE(idt[T_BRKPT], 0, GD_KT, brkpt_handler, 3);
f0103baa:	b8 d4 46 10 f0       	mov    $0xf01046d4,%eax
f0103baf:	66 a3 78 12 2c f0    	mov    %ax,0xf02c1278
f0103bb5:	66 c7 05 7a 12 2c f0 	movw   $0x8,0xf02c127a
f0103bbc:	08 00 
f0103bbe:	c6 05 7c 12 2c f0 00 	movb   $0x0,0xf02c127c
f0103bc5:	c6 05 7d 12 2c f0 ee 	movb   $0xee,0xf02c127d
f0103bcc:	c1 e8 10             	shr    $0x10,%eax
f0103bcf:	66 a3 7e 12 2c f0    	mov    %ax,0xf02c127e
	SETGATE(idt[T_OFLOW], 0, GD_KT, oflow_handler, 0);
f0103bd5:	b8 de 46 10 f0       	mov    $0xf01046de,%eax
f0103bda:	66 a3 80 12 2c f0    	mov    %ax,0xf02c1280
f0103be0:	66 c7 05 82 12 2c f0 	movw   $0x8,0xf02c1282
f0103be7:	08 00 
f0103be9:	c6 05 84 12 2c f0 00 	movb   $0x0,0xf02c1284
f0103bf0:	c6 05 85 12 2c f0 8e 	movb   $0x8e,0xf02c1285
f0103bf7:	c1 e8 10             	shr    $0x10,%eax
f0103bfa:	66 a3 86 12 2c f0    	mov    %ax,0xf02c1286
	SETGATE(idt[T_BOUND], 0, GD_KT, bound_handler, 0);
f0103c00:	b8 e8 46 10 f0       	mov    $0xf01046e8,%eax
f0103c05:	66 a3 88 12 2c f0    	mov    %ax,0xf02c1288
f0103c0b:	66 c7 05 8a 12 2c f0 	movw   $0x8,0xf02c128a
f0103c12:	08 00 
f0103c14:	c6 05 8c 12 2c f0 00 	movb   $0x0,0xf02c128c
f0103c1b:	c6 05 8d 12 2c f0 8e 	movb   $0x8e,0xf02c128d
f0103c22:	c1 e8 10             	shr    $0x10,%eax
f0103c25:	66 a3 8e 12 2c f0    	mov    %ax,0xf02c128e
	SETGATE(idt[T_ILLOP], 0, GD_KT, illop_handler, 0);
f0103c2b:	b8 f2 46 10 f0       	mov    $0xf01046f2,%eax
f0103c30:	66 a3 90 12 2c f0    	mov    %ax,0xf02c1290
f0103c36:	66 c7 05 92 12 2c f0 	movw   $0x8,0xf02c1292
f0103c3d:	08 00 
f0103c3f:	c6 05 94 12 2c f0 00 	movb   $0x0,0xf02c1294
f0103c46:	c6 05 95 12 2c f0 8e 	movb   $0x8e,0xf02c1295
f0103c4d:	c1 e8 10             	shr    $0x10,%eax
f0103c50:	66 a3 96 12 2c f0    	mov    %ax,0xf02c1296
	SETGATE(idt[T_DEVICE], 0, GD_KT, device_handler, 0);
f0103c56:	b8 fc 46 10 f0       	mov    $0xf01046fc,%eax
f0103c5b:	66 a3 98 12 2c f0    	mov    %ax,0xf02c1298
f0103c61:	66 c7 05 9a 12 2c f0 	movw   $0x8,0xf02c129a
f0103c68:	08 00 
f0103c6a:	c6 05 9c 12 2c f0 00 	movb   $0x0,0xf02c129c
f0103c71:	c6 05 9d 12 2c f0 8e 	movb   $0x8e,0xf02c129d
f0103c78:	c1 e8 10             	shr    $0x10,%eax
f0103c7b:	66 a3 9e 12 2c f0    	mov    %ax,0xf02c129e
	SETGATE(idt[T_DBLFLT], 0, GD_KT, dblflt_handler, 0);
f0103c81:	b8 06 47 10 f0       	mov    $0xf0104706,%eax
f0103c86:	66 a3 a0 12 2c f0    	mov    %ax,0xf02c12a0
f0103c8c:	66 c7 05 a2 12 2c f0 	movw   $0x8,0xf02c12a2
f0103c93:	08 00 
f0103c95:	c6 05 a4 12 2c f0 00 	movb   $0x0,0xf02c12a4
f0103c9c:	c6 05 a5 12 2c f0 8e 	movb   $0x8e,0xf02c12a5
f0103ca3:	c1 e8 10             	shr    $0x10,%eax
f0103ca6:	66 a3 a6 12 2c f0    	mov    %ax,0xf02c12a6
	SETGATE(idt[T_TSS], 0, GD_KT, tss_handler, 0);
f0103cac:	b8 0e 47 10 f0       	mov    $0xf010470e,%eax
f0103cb1:	66 a3 b0 12 2c f0    	mov    %ax,0xf02c12b0
f0103cb7:	66 c7 05 b2 12 2c f0 	movw   $0x8,0xf02c12b2
f0103cbe:	08 00 
f0103cc0:	c6 05 b4 12 2c f0 00 	movb   $0x0,0xf02c12b4
f0103cc7:	c6 05 b5 12 2c f0 8e 	movb   $0x8e,0xf02c12b5
f0103cce:	c1 e8 10             	shr    $0x10,%eax
f0103cd1:	66 a3 b6 12 2c f0    	mov    %ax,0xf02c12b6
	SETGATE(idt[T_SEGNP], 0, GD_KT, segnp_handler, 0);
f0103cd7:	b8 16 47 10 f0       	mov    $0xf0104716,%eax
f0103cdc:	66 a3 b8 12 2c f0    	mov    %ax,0xf02c12b8
f0103ce2:	66 c7 05 ba 12 2c f0 	movw   $0x8,0xf02c12ba
f0103ce9:	08 00 
f0103ceb:	c6 05 bc 12 2c f0 00 	movb   $0x0,0xf02c12bc
f0103cf2:	c6 05 bd 12 2c f0 8e 	movb   $0x8e,0xf02c12bd
f0103cf9:	c1 e8 10             	shr    $0x10,%eax
f0103cfc:	66 a3 be 12 2c f0    	mov    %ax,0xf02c12be
	SETGATE(idt[T_STACK], 0, GD_KT, stack_handler, 0);
f0103d02:	b8 1e 47 10 f0       	mov    $0xf010471e,%eax
f0103d07:	66 a3 c0 12 2c f0    	mov    %ax,0xf02c12c0
f0103d0d:	66 c7 05 c2 12 2c f0 	movw   $0x8,0xf02c12c2
f0103d14:	08 00 
f0103d16:	c6 05 c4 12 2c f0 00 	movb   $0x0,0xf02c12c4
f0103d1d:	c6 05 c5 12 2c f0 8e 	movb   $0x8e,0xf02c12c5
f0103d24:	c1 e8 10             	shr    $0x10,%eax
f0103d27:	66 a3 c6 12 2c f0    	mov    %ax,0xf02c12c6
	SETGATE(idt[T_GPFLT], 0, GD_KT, gpflt_handler, 0);
f0103d2d:	b8 26 47 10 f0       	mov    $0xf0104726,%eax
f0103d32:	66 a3 c8 12 2c f0    	mov    %ax,0xf02c12c8
f0103d38:	66 c7 05 ca 12 2c f0 	movw   $0x8,0xf02c12ca
f0103d3f:	08 00 
f0103d41:	c6 05 cc 12 2c f0 00 	movb   $0x0,0xf02c12cc
f0103d48:	c6 05 cd 12 2c f0 8e 	movb   $0x8e,0xf02c12cd
f0103d4f:	c1 e8 10             	shr    $0x10,%eax
f0103d52:	66 a3 ce 12 2c f0    	mov    %ax,0xf02c12ce
	SETGATE(idt[T_PGFLT], 0, GD_KT, pgflt_handler, 0);
f0103d58:	b8 2e 47 10 f0       	mov    $0xf010472e,%eax
f0103d5d:	66 a3 d0 12 2c f0    	mov    %ax,0xf02c12d0
f0103d63:	66 c7 05 d2 12 2c f0 	movw   $0x8,0xf02c12d2
f0103d6a:	08 00 
f0103d6c:	c6 05 d4 12 2c f0 00 	movb   $0x0,0xf02c12d4
f0103d73:	c6 05 d5 12 2c f0 8e 	movb   $0x8e,0xf02c12d5
f0103d7a:	c1 e8 10             	shr    $0x10,%eax
f0103d7d:	66 a3 d6 12 2c f0    	mov    %ax,0xf02c12d6
	SETGATE(idt[T_FPERR], 0, GD_KT, fperr_handler, 0);
f0103d83:	b8 32 47 10 f0       	mov    $0xf0104732,%eax
f0103d88:	66 a3 e0 12 2c f0    	mov    %ax,0xf02c12e0
f0103d8e:	66 c7 05 e2 12 2c f0 	movw   $0x8,0xf02c12e2
f0103d95:	08 00 
f0103d97:	c6 05 e4 12 2c f0 00 	movb   $0x0,0xf02c12e4
f0103d9e:	c6 05 e5 12 2c f0 8e 	movb   $0x8e,0xf02c12e5
f0103da5:	c1 e8 10             	shr    $0x10,%eax
f0103da8:	66 a3 e6 12 2c f0    	mov    %ax,0xf02c12e6
	SETGATE(idt[T_ALIGN], 0, GD_KT, align_handler, 0);
f0103dae:	b8 38 47 10 f0       	mov    $0xf0104738,%eax
f0103db3:	66 a3 e8 12 2c f0    	mov    %ax,0xf02c12e8
f0103db9:	66 c7 05 ea 12 2c f0 	movw   $0x8,0xf02c12ea
f0103dc0:	08 00 
f0103dc2:	c6 05 ec 12 2c f0 00 	movb   $0x0,0xf02c12ec
f0103dc9:	c6 05 ed 12 2c f0 8e 	movb   $0x8e,0xf02c12ed
f0103dd0:	c1 e8 10             	shr    $0x10,%eax
f0103dd3:	66 a3 ee 12 2c f0    	mov    %ax,0xf02c12ee
	SETGATE(idt[T_MCHK], 0, GD_KT, mchk_handler, 0);
f0103dd9:	b8 3c 47 10 f0       	mov    $0xf010473c,%eax
f0103dde:	66 a3 f0 12 2c f0    	mov    %ax,0xf02c12f0
f0103de4:	66 c7 05 f2 12 2c f0 	movw   $0x8,0xf02c12f2
f0103deb:	08 00 
f0103ded:	c6 05 f4 12 2c f0 00 	movb   $0x0,0xf02c12f4
f0103df4:	c6 05 f5 12 2c f0 8e 	movb   $0x8e,0xf02c12f5
f0103dfb:	c1 e8 10             	shr    $0x10,%eax
f0103dfe:	66 a3 f6 12 2c f0    	mov    %ax,0xf02c12f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, simderr_handler, 0);
f0103e04:	b8 42 47 10 f0       	mov    $0xf0104742,%eax
f0103e09:	66 a3 f8 12 2c f0    	mov    %ax,0xf02c12f8
f0103e0f:	66 c7 05 fa 12 2c f0 	movw   $0x8,0xf02c12fa
f0103e16:	08 00 
f0103e18:	c6 05 fc 12 2c f0 00 	movb   $0x0,0xf02c12fc
f0103e1f:	c6 05 fd 12 2c f0 8e 	movb   $0x8e,0xf02c12fd
f0103e26:	c1 e8 10             	shr    $0x10,%eax
f0103e29:	66 a3 fe 12 2c f0    	mov    %ax,0xf02c12fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, syscall_handler, 3);
f0103e2f:	b8 48 47 10 f0       	mov    $0xf0104748,%eax
f0103e34:	66 a3 e0 13 2c f0    	mov    %ax,0xf02c13e0
f0103e3a:	66 c7 05 e2 13 2c f0 	movw   $0x8,0xf02c13e2
f0103e41:	08 00 
f0103e43:	c6 05 e4 13 2c f0 00 	movb   $0x0,0xf02c13e4
f0103e4a:	c6 05 e5 13 2c f0 ee 	movb   $0xee,0xf02c13e5
f0103e51:	c1 e8 10             	shr    $0x10,%eax
f0103e54:	66 a3 e6 13 2c f0    	mov    %ax,0xf02c13e6
	SETGATE(idt[IRQ_OFFSET + 0], 0, GD_KT, irq_0_handler, 0);
f0103e5a:	b8 4e 47 10 f0       	mov    $0xf010474e,%eax
f0103e5f:	66 a3 60 13 2c f0    	mov    %ax,0xf02c1360
f0103e65:	66 c7 05 62 13 2c f0 	movw   $0x8,0xf02c1362
f0103e6c:	08 00 
f0103e6e:	c6 05 64 13 2c f0 00 	movb   $0x0,0xf02c1364
f0103e75:	c6 05 65 13 2c f0 8e 	movb   $0x8e,0xf02c1365
f0103e7c:	c1 e8 10             	shr    $0x10,%eax
f0103e7f:	66 a3 66 13 2c f0    	mov    %ax,0xf02c1366
	SETGATE(idt[IRQ_OFFSET + 1], 0, GD_KT, irq_1_handler, 0);
f0103e85:	b8 54 47 10 f0       	mov    $0xf0104754,%eax
f0103e8a:	66 a3 68 13 2c f0    	mov    %ax,0xf02c1368
f0103e90:	66 c7 05 6a 13 2c f0 	movw   $0x8,0xf02c136a
f0103e97:	08 00 
f0103e99:	c6 05 6c 13 2c f0 00 	movb   $0x0,0xf02c136c
f0103ea0:	c6 05 6d 13 2c f0 8e 	movb   $0x8e,0xf02c136d
f0103ea7:	c1 e8 10             	shr    $0x10,%eax
f0103eaa:	66 a3 6e 13 2c f0    	mov    %ax,0xf02c136e
	SETGATE(idt[IRQ_OFFSET + 2], 0, GD_KT, irq_2_handler, 0);
f0103eb0:	b8 5a 47 10 f0       	mov    $0xf010475a,%eax
f0103eb5:	66 a3 70 13 2c f0    	mov    %ax,0xf02c1370
f0103ebb:	66 c7 05 72 13 2c f0 	movw   $0x8,0xf02c1372
f0103ec2:	08 00 
f0103ec4:	c6 05 74 13 2c f0 00 	movb   $0x0,0xf02c1374
f0103ecb:	c6 05 75 13 2c f0 8e 	movb   $0x8e,0xf02c1375
f0103ed2:	c1 e8 10             	shr    $0x10,%eax
f0103ed5:	66 a3 76 13 2c f0    	mov    %ax,0xf02c1376
	SETGATE(idt[IRQ_OFFSET + 3], 0, GD_KT, irq_3_handler, 0);
f0103edb:	b8 60 47 10 f0       	mov    $0xf0104760,%eax
f0103ee0:	66 a3 78 13 2c f0    	mov    %ax,0xf02c1378
f0103ee6:	66 c7 05 7a 13 2c f0 	movw   $0x8,0xf02c137a
f0103eed:	08 00 
f0103eef:	c6 05 7c 13 2c f0 00 	movb   $0x0,0xf02c137c
f0103ef6:	c6 05 7d 13 2c f0 8e 	movb   $0x8e,0xf02c137d
f0103efd:	c1 e8 10             	shr    $0x10,%eax
f0103f00:	66 a3 7e 13 2c f0    	mov    %ax,0xf02c137e
	SETGATE(idt[IRQ_OFFSET + 4], 0, GD_KT, irq_4_handler, 0);
f0103f06:	b8 66 47 10 f0       	mov    $0xf0104766,%eax
f0103f0b:	66 a3 80 13 2c f0    	mov    %ax,0xf02c1380
f0103f11:	66 c7 05 82 13 2c f0 	movw   $0x8,0xf02c1382
f0103f18:	08 00 
f0103f1a:	c6 05 84 13 2c f0 00 	movb   $0x0,0xf02c1384
f0103f21:	c6 05 85 13 2c f0 8e 	movb   $0x8e,0xf02c1385
f0103f28:	c1 e8 10             	shr    $0x10,%eax
f0103f2b:	66 a3 86 13 2c f0    	mov    %ax,0xf02c1386
	SETGATE(idt[IRQ_OFFSET + 5], 0, GD_KT, irq_5_handler, 0);
f0103f31:	b8 6c 47 10 f0       	mov    $0xf010476c,%eax
f0103f36:	66 a3 88 13 2c f0    	mov    %ax,0xf02c1388
f0103f3c:	66 c7 05 8a 13 2c f0 	movw   $0x8,0xf02c138a
f0103f43:	08 00 
f0103f45:	c6 05 8c 13 2c f0 00 	movb   $0x0,0xf02c138c
f0103f4c:	c6 05 8d 13 2c f0 8e 	movb   $0x8e,0xf02c138d
f0103f53:	c1 e8 10             	shr    $0x10,%eax
f0103f56:	66 a3 8e 13 2c f0    	mov    %ax,0xf02c138e
	SETGATE(idt[IRQ_OFFSET + 6], 0, GD_KT, irq_6_handler, 0);
f0103f5c:	b8 72 47 10 f0       	mov    $0xf0104772,%eax
f0103f61:	66 a3 90 13 2c f0    	mov    %ax,0xf02c1390
f0103f67:	66 c7 05 92 13 2c f0 	movw   $0x8,0xf02c1392
f0103f6e:	08 00 
f0103f70:	c6 05 94 13 2c f0 00 	movb   $0x0,0xf02c1394
f0103f77:	c6 05 95 13 2c f0 8e 	movb   $0x8e,0xf02c1395
f0103f7e:	c1 e8 10             	shr    $0x10,%eax
f0103f81:	66 a3 96 13 2c f0    	mov    %ax,0xf02c1396
	SETGATE(idt[IRQ_OFFSET + 7], 0, GD_KT, irq_7_handler, 0);
f0103f87:	b8 78 47 10 f0       	mov    $0xf0104778,%eax
f0103f8c:	66 a3 98 13 2c f0    	mov    %ax,0xf02c1398
f0103f92:	66 c7 05 9a 13 2c f0 	movw   $0x8,0xf02c139a
f0103f99:	08 00 
f0103f9b:	c6 05 9c 13 2c f0 00 	movb   $0x0,0xf02c139c
f0103fa2:	c6 05 9d 13 2c f0 8e 	movb   $0x8e,0xf02c139d
f0103fa9:	c1 e8 10             	shr    $0x10,%eax
f0103fac:	66 a3 9e 13 2c f0    	mov    %ax,0xf02c139e
	SETGATE(idt[IRQ_OFFSET + 8], 0, GD_KT, irq_8_handler, 0);
f0103fb2:	b8 7e 47 10 f0       	mov    $0xf010477e,%eax
f0103fb7:	66 a3 a0 13 2c f0    	mov    %ax,0xf02c13a0
f0103fbd:	66 c7 05 a2 13 2c f0 	movw   $0x8,0xf02c13a2
f0103fc4:	08 00 
f0103fc6:	c6 05 a4 13 2c f0 00 	movb   $0x0,0xf02c13a4
f0103fcd:	c6 05 a5 13 2c f0 8e 	movb   $0x8e,0xf02c13a5
f0103fd4:	c1 e8 10             	shr    $0x10,%eax
f0103fd7:	66 a3 a6 13 2c f0    	mov    %ax,0xf02c13a6
	SETGATE(idt[IRQ_OFFSET + 9], 0, GD_KT, irq_9_handler, 0);
f0103fdd:	b8 84 47 10 f0       	mov    $0xf0104784,%eax
f0103fe2:	66 a3 a8 13 2c f0    	mov    %ax,0xf02c13a8
f0103fe8:	66 c7 05 aa 13 2c f0 	movw   $0x8,0xf02c13aa
f0103fef:	08 00 
f0103ff1:	c6 05 ac 13 2c f0 00 	movb   $0x0,0xf02c13ac
f0103ff8:	c6 05 ad 13 2c f0 8e 	movb   $0x8e,0xf02c13ad
f0103fff:	c1 e8 10             	shr    $0x10,%eax
f0104002:	66 a3 ae 13 2c f0    	mov    %ax,0xf02c13ae
	SETGATE(idt[IRQ_OFFSET + 10], 0, GD_KT, irq_10_handler, 0);
f0104008:	b8 8a 47 10 f0       	mov    $0xf010478a,%eax
f010400d:	66 a3 b0 13 2c f0    	mov    %ax,0xf02c13b0
f0104013:	66 c7 05 b2 13 2c f0 	movw   $0x8,0xf02c13b2
f010401a:	08 00 
f010401c:	c6 05 b4 13 2c f0 00 	movb   $0x0,0xf02c13b4
f0104023:	c6 05 b5 13 2c f0 8e 	movb   $0x8e,0xf02c13b5
f010402a:	c1 e8 10             	shr    $0x10,%eax
f010402d:	66 a3 b6 13 2c f0    	mov    %ax,0xf02c13b6
	SETGATE(idt[IRQ_OFFSET + 11], 0, GD_KT, irq_11_handler, 0);
f0104033:	b8 90 47 10 f0       	mov    $0xf0104790,%eax
f0104038:	66 a3 b8 13 2c f0    	mov    %ax,0xf02c13b8
f010403e:	66 c7 05 ba 13 2c f0 	movw   $0x8,0xf02c13ba
f0104045:	08 00 
f0104047:	c6 05 bc 13 2c f0 00 	movb   $0x0,0xf02c13bc
f010404e:	c6 05 bd 13 2c f0 8e 	movb   $0x8e,0xf02c13bd
f0104055:	c1 e8 10             	shr    $0x10,%eax
f0104058:	66 a3 be 13 2c f0    	mov    %ax,0xf02c13be
	SETGATE(idt[IRQ_OFFSET + 12], 0, GD_KT, irq_12_handler, 0);
f010405e:	b8 96 47 10 f0       	mov    $0xf0104796,%eax
f0104063:	66 a3 c0 13 2c f0    	mov    %ax,0xf02c13c0
f0104069:	66 c7 05 c2 13 2c f0 	movw   $0x8,0xf02c13c2
f0104070:	08 00 
f0104072:	c6 05 c4 13 2c f0 00 	movb   $0x0,0xf02c13c4
f0104079:	c6 05 c5 13 2c f0 8e 	movb   $0x8e,0xf02c13c5
f0104080:	c1 e8 10             	shr    $0x10,%eax
f0104083:	66 a3 c6 13 2c f0    	mov    %ax,0xf02c13c6
	SETGATE(idt[IRQ_OFFSET + 13], 0, GD_KT, irq_13_handler, 0);
f0104089:	b8 9c 47 10 f0       	mov    $0xf010479c,%eax
f010408e:	66 a3 c8 13 2c f0    	mov    %ax,0xf02c13c8
f0104094:	66 c7 05 ca 13 2c f0 	movw   $0x8,0xf02c13ca
f010409b:	08 00 
f010409d:	c6 05 cc 13 2c f0 00 	movb   $0x0,0xf02c13cc
f01040a4:	c6 05 cd 13 2c f0 8e 	movb   $0x8e,0xf02c13cd
f01040ab:	c1 e8 10             	shr    $0x10,%eax
f01040ae:	66 a3 ce 13 2c f0    	mov    %ax,0xf02c13ce
	SETGATE(idt[IRQ_OFFSET + 14], 0, GD_KT, irq_14_handler, 0);
f01040b4:	b8 a2 47 10 f0       	mov    $0xf01047a2,%eax
f01040b9:	66 a3 d0 13 2c f0    	mov    %ax,0xf02c13d0
f01040bf:	66 c7 05 d2 13 2c f0 	movw   $0x8,0xf02c13d2
f01040c6:	08 00 
f01040c8:	c6 05 d4 13 2c f0 00 	movb   $0x0,0xf02c13d4
f01040cf:	c6 05 d5 13 2c f0 8e 	movb   $0x8e,0xf02c13d5
f01040d6:	c1 e8 10             	shr    $0x10,%eax
f01040d9:	66 a3 d6 13 2c f0    	mov    %ax,0xf02c13d6
	SETGATE(idt[IRQ_OFFSET + 15], 0, GD_KT, irq_15_handler, 0);
f01040df:	b8 a8 47 10 f0       	mov    $0xf01047a8,%eax
f01040e4:	66 a3 d8 13 2c f0    	mov    %ax,0xf02c13d8
f01040ea:	66 c7 05 da 13 2c f0 	movw   $0x8,0xf02c13da
f01040f1:	08 00 
f01040f3:	c6 05 dc 13 2c f0 00 	movb   $0x0,0xf02c13dc
f01040fa:	c6 05 dd 13 2c f0 8e 	movb   $0x8e,0xf02c13dd
f0104101:	c1 e8 10             	shr    $0x10,%eax
f0104104:	66 a3 de 13 2c f0    	mov    %ax,0xf02c13de
	trap_init_percpu();
f010410a:	e8 3f f9 ff ff       	call   f0103a4e <trap_init_percpu>
}
f010410f:	c9                   	leave  
f0104110:	c3                   	ret    

f0104111 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0104111:	f3 0f 1e fb          	endbr32 
f0104115:	55                   	push   %ebp
f0104116:	89 e5                	mov    %esp,%ebp
f0104118:	53                   	push   %ebx
f0104119:	83 ec 0c             	sub    $0xc,%esp
f010411c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f010411f:	ff 33                	pushl  (%ebx)
f0104121:	68 b8 85 10 f0       	push   $0xf01085b8
f0104126:	e8 0b f9 ff ff       	call   f0103a36 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f010412b:	83 c4 08             	add    $0x8,%esp
f010412e:	ff 73 04             	pushl  0x4(%ebx)
f0104131:	68 c7 85 10 f0       	push   $0xf01085c7
f0104136:	e8 fb f8 ff ff       	call   f0103a36 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f010413b:	83 c4 08             	add    $0x8,%esp
f010413e:	ff 73 08             	pushl  0x8(%ebx)
f0104141:	68 d6 85 10 f0       	push   $0xf01085d6
f0104146:	e8 eb f8 ff ff       	call   f0103a36 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f010414b:	83 c4 08             	add    $0x8,%esp
f010414e:	ff 73 0c             	pushl  0xc(%ebx)
f0104151:	68 e5 85 10 f0       	push   $0xf01085e5
f0104156:	e8 db f8 ff ff       	call   f0103a36 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f010415b:	83 c4 08             	add    $0x8,%esp
f010415e:	ff 73 10             	pushl  0x10(%ebx)
f0104161:	68 f4 85 10 f0       	push   $0xf01085f4
f0104166:	e8 cb f8 ff ff       	call   f0103a36 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f010416b:	83 c4 08             	add    $0x8,%esp
f010416e:	ff 73 14             	pushl  0x14(%ebx)
f0104171:	68 03 86 10 f0       	push   $0xf0108603
f0104176:	e8 bb f8 ff ff       	call   f0103a36 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f010417b:	83 c4 08             	add    $0x8,%esp
f010417e:	ff 73 18             	pushl  0x18(%ebx)
f0104181:	68 12 86 10 f0       	push   $0xf0108612
f0104186:	e8 ab f8 ff ff       	call   f0103a36 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f010418b:	83 c4 08             	add    $0x8,%esp
f010418e:	ff 73 1c             	pushl  0x1c(%ebx)
f0104191:	68 21 86 10 f0       	push   $0xf0108621
f0104196:	e8 9b f8 ff ff       	call   f0103a36 <cprintf>
}
f010419b:	83 c4 10             	add    $0x10,%esp
f010419e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01041a1:	c9                   	leave  
f01041a2:	c3                   	ret    

f01041a3 <print_trapframe>:
{
f01041a3:	f3 0f 1e fb          	endbr32 
f01041a7:	55                   	push   %ebp
f01041a8:	89 e5                	mov    %esp,%ebp
f01041aa:	56                   	push   %esi
f01041ab:	53                   	push   %ebx
f01041ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f01041af:	e8 36 20 00 00       	call   f01061ea <cpunum>
f01041b4:	83 ec 04             	sub    $0x4,%esp
f01041b7:	50                   	push   %eax
f01041b8:	53                   	push   %ebx
f01041b9:	68 85 86 10 f0       	push   $0xf0108685
f01041be:	e8 73 f8 ff ff       	call   f0103a36 <cprintf>
	print_regs(&tf->tf_regs);
f01041c3:	89 1c 24             	mov    %ebx,(%esp)
f01041c6:	e8 46 ff ff ff       	call   f0104111 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f01041cb:	83 c4 08             	add    $0x8,%esp
f01041ce:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f01041d2:	50                   	push   %eax
f01041d3:	68 a3 86 10 f0       	push   $0xf01086a3
f01041d8:	e8 59 f8 ff ff       	call   f0103a36 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01041dd:	83 c4 08             	add    $0x8,%esp
f01041e0:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f01041e4:	50                   	push   %eax
f01041e5:	68 b6 86 10 f0       	push   $0xf01086b6
f01041ea:	e8 47 f8 ff ff       	call   f0103a36 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01041ef:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f01041f2:	83 c4 10             	add    $0x10,%esp
f01041f5:	83 f8 13             	cmp    $0x13,%eax
f01041f8:	0f 86 da 00 00 00    	jbe    f01042d8 <print_trapframe+0x135>
		return "System call";
f01041fe:	ba 30 86 10 f0       	mov    $0xf0108630,%edx
	if (trapno == T_SYSCALL)
f0104203:	83 f8 30             	cmp    $0x30,%eax
f0104206:	74 13                	je     f010421b <print_trapframe+0x78>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0104208:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f010420b:	83 fa 0f             	cmp    $0xf,%edx
f010420e:	ba 3c 86 10 f0       	mov    $0xf010863c,%edx
f0104213:	b9 4b 86 10 f0       	mov    $0xf010864b,%ecx
f0104218:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f010421b:	83 ec 04             	sub    $0x4,%esp
f010421e:	52                   	push   %edx
f010421f:	50                   	push   %eax
f0104220:	68 c9 86 10 f0       	push   $0xf01086c9
f0104225:	e8 0c f8 ff ff       	call   f0103a36 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010422a:	83 c4 10             	add    $0x10,%esp
f010422d:	39 1d 60 1a 2c f0    	cmp    %ebx,0xf02c1a60
f0104233:	0f 84 ab 00 00 00    	je     f01042e4 <print_trapframe+0x141>
	cprintf("  err  0x%08x", tf->tf_err);
f0104239:	83 ec 08             	sub    $0x8,%esp
f010423c:	ff 73 2c             	pushl  0x2c(%ebx)
f010423f:	68 ea 86 10 f0       	push   $0xf01086ea
f0104244:	e8 ed f7 ff ff       	call   f0103a36 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0104249:	83 c4 10             	add    $0x10,%esp
f010424c:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104250:	0f 85 b1 00 00 00    	jne    f0104307 <print_trapframe+0x164>
			tf->tf_err & 1 ? "protection" : "not-present");
f0104256:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0104259:	a8 01                	test   $0x1,%al
f010425b:	b9 5e 86 10 f0       	mov    $0xf010865e,%ecx
f0104260:	ba 69 86 10 f0       	mov    $0xf0108669,%edx
f0104265:	0f 44 ca             	cmove  %edx,%ecx
f0104268:	a8 02                	test   $0x2,%al
f010426a:	be 75 86 10 f0       	mov    $0xf0108675,%esi
f010426f:	ba 7b 86 10 f0       	mov    $0xf010867b,%edx
f0104274:	0f 45 d6             	cmovne %esi,%edx
f0104277:	a8 04                	test   $0x4,%al
f0104279:	b8 80 86 10 f0       	mov    $0xf0108680,%eax
f010427e:	be ae 87 10 f0       	mov    $0xf01087ae,%esi
f0104283:	0f 44 c6             	cmove  %esi,%eax
f0104286:	51                   	push   %ecx
f0104287:	52                   	push   %edx
f0104288:	50                   	push   %eax
f0104289:	68 f8 86 10 f0       	push   $0xf01086f8
f010428e:	e8 a3 f7 ff ff       	call   f0103a36 <cprintf>
f0104293:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104296:	83 ec 08             	sub    $0x8,%esp
f0104299:	ff 73 30             	pushl  0x30(%ebx)
f010429c:	68 07 87 10 f0       	push   $0xf0108707
f01042a1:	e8 90 f7 ff ff       	call   f0103a36 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f01042a6:	83 c4 08             	add    $0x8,%esp
f01042a9:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f01042ad:	50                   	push   %eax
f01042ae:	68 16 87 10 f0       	push   $0xf0108716
f01042b3:	e8 7e f7 ff ff       	call   f0103a36 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f01042b8:	83 c4 08             	add    $0x8,%esp
f01042bb:	ff 73 38             	pushl  0x38(%ebx)
f01042be:	68 29 87 10 f0       	push   $0xf0108729
f01042c3:	e8 6e f7 ff ff       	call   f0103a36 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f01042c8:	83 c4 10             	add    $0x10,%esp
f01042cb:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01042cf:	75 4b                	jne    f010431c <print_trapframe+0x179>
}
f01042d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01042d4:	5b                   	pop    %ebx
f01042d5:	5e                   	pop    %esi
f01042d6:	5d                   	pop    %ebp
f01042d7:	c3                   	ret    
		return excnames[trapno];
f01042d8:	8b 14 85 60 89 10 f0 	mov    -0xfef76a0(,%eax,4),%edx
f01042df:	e9 37 ff ff ff       	jmp    f010421b <print_trapframe+0x78>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01042e4:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01042e8:	0f 85 4b ff ff ff    	jne    f0104239 <print_trapframe+0x96>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f01042ee:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f01042f1:	83 ec 08             	sub    $0x8,%esp
f01042f4:	50                   	push   %eax
f01042f5:	68 db 86 10 f0       	push   $0xf01086db
f01042fa:	e8 37 f7 ff ff       	call   f0103a36 <cprintf>
f01042ff:	83 c4 10             	add    $0x10,%esp
f0104302:	e9 32 ff ff ff       	jmp    f0104239 <print_trapframe+0x96>
		cprintf("\n");
f0104307:	83 ec 0c             	sub    $0xc,%esp
f010430a:	68 96 7a 10 f0       	push   $0xf0107a96
f010430f:	e8 22 f7 ff ff       	call   f0103a36 <cprintf>
f0104314:	83 c4 10             	add    $0x10,%esp
f0104317:	e9 7a ff ff ff       	jmp    f0104296 <print_trapframe+0xf3>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f010431c:	83 ec 08             	sub    $0x8,%esp
f010431f:	ff 73 3c             	pushl  0x3c(%ebx)
f0104322:	68 38 87 10 f0       	push   $0xf0108738
f0104327:	e8 0a f7 ff ff       	call   f0103a36 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f010432c:	83 c4 08             	add    $0x8,%esp
f010432f:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104333:	50                   	push   %eax
f0104334:	68 47 87 10 f0       	push   $0xf0108747
f0104339:	e8 f8 f6 ff ff       	call   f0103a36 <cprintf>
f010433e:	83 c4 10             	add    $0x10,%esp
}
f0104341:	eb 8e                	jmp    f01042d1 <print_trapframe+0x12e>

f0104343 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104343:	f3 0f 1e fb          	endbr32 
f0104347:	55                   	push   %ebp
f0104348:	89 e5                	mov    %esp,%ebp
f010434a:	57                   	push   %edi
f010434b:	56                   	push   %esi
f010434c:	53                   	push   %ebx
f010434d:	83 ec 1c             	sub    $0x1c,%esp
f0104350:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104353:	0f 20 d0             	mov    %cr2,%eax
f0104356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if((tf->tf_cs & 0x3) == 0)
f0104359:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010435d:	74 5f                	je     f01043be <page_fault_handler+0x7b>

	// LAB 4: Your code here.
	// 判断是否存在page fault的处理函数
	// 如果存在继续执行下去
	// 如果不存在则执行下面已经给定的销毁进程的代码
	if(curenv->env_pgfault_upcall) {
f010435f:	e8 86 1e 00 00       	call   f01061ea <cpunum>
f0104364:	6b c0 74             	imul   $0x74,%eax,%eax
f0104367:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f010436d:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0104371:	75 62                	jne    f01043d5 <page_fault_handler+0x92>
    	tf->tf_eip = (uint32_t)curenv->env_pgfault_upcall;
		env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104373:	8b 73 30             	mov    0x30(%ebx),%esi
		curenv->env_id, fault_va, tf->tf_eip);
f0104376:	e8 6f 1e 00 00       	call   f01061ea <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010437b:	56                   	push   %esi
f010437c:	ff 75 e4             	pushl  -0x1c(%ebp)
		curenv->env_id, fault_va, tf->tf_eip);
f010437f:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104382:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f0104388:	ff 70 48             	pushl  0x48(%eax)
f010438b:	68 28 89 10 f0       	push   $0xf0108928
f0104390:	e8 a1 f6 ff ff       	call   f0103a36 <cprintf>
	print_trapframe(tf);
f0104395:	89 1c 24             	mov    %ebx,(%esp)
f0104398:	e8 06 fe ff ff       	call   f01041a3 <print_trapframe>
	env_destroy(curenv);
f010439d:	e8 48 1e 00 00       	call   f01061ea <cpunum>
f01043a2:	83 c4 04             	add    $0x4,%esp
f01043a5:	6b c0 74             	imul   $0x74,%eax,%eax
f01043a8:	ff b0 28 20 2c f0    	pushl  -0xfd3dfd8(%eax)
f01043ae:	e8 82 f3 ff ff       	call   f0103735 <env_destroy>
}
f01043b3:	83 c4 10             	add    $0x10,%esp
f01043b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01043b9:	5b                   	pop    %ebx
f01043ba:	5e                   	pop    %esi
f01043bb:	5f                   	pop    %edi
f01043bc:	5d                   	pop    %ebp
f01043bd:	c3                   	ret    
		panic("page_fault_handler panic, page fault in kernel\n");
f01043be:	83 ec 04             	sub    $0x4,%esp
f01043c1:	68 f8 88 10 f0       	push   $0xf01088f8
f01043c6:	68 8f 01 00 00       	push   $0x18f
f01043cb:	68 5a 87 10 f0       	push   $0xf010875a
f01043d0:	e8 6b bc ff ff       	call   f0100040 <_panic>
		if(tf->tf_esp > UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP - 1){
f01043d5:	8b 4b 3c             	mov    0x3c(%ebx),%ecx
f01043d8:	8d 81 ff 0f 40 11    	lea    0x11400fff(%ecx),%eax
		uintptr_t exstacktop = UXSTACKTOP;
f01043de:	3d fe 0f 00 00       	cmp    $0xffe,%eax
f01043e3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f01043e8:	0f 42 c1             	cmovb  %ecx,%eax
f01043eb:	89 c6                	mov    %eax,%esi
		user_mem_assert(curenv, (void*)exstacktop - stacksize, stacksize, PTE_U | PTE_W);
f01043ed:	8d 50 c8             	lea    -0x38(%eax),%edx
f01043f0:	89 d7                	mov    %edx,%edi
f01043f2:	e8 f3 1d 00 00       	call   f01061ea <cpunum>
f01043f7:	6a 06                	push   $0x6
f01043f9:	6a 38                	push   $0x38
f01043fb:	57                   	push   %edi
f01043fc:	6b c0 74             	imul   $0x74,%eax,%eax
f01043ff:	ff b0 28 20 2c f0    	pushl  -0xfd3dfd8(%eax)
f0104405:	e8 cd ec ff ff       	call   f01030d7 <user_mem_assert>
		utf->utf_eflags = tf->tf_eflags;
f010440a:	8b 43 38             	mov    0x38(%ebx),%eax
f010440d:	89 47 2c             	mov    %eax,0x2c(%edi)
    	utf->utf_eip = tf->tf_eip;
f0104410:	8b 43 30             	mov    0x30(%ebx),%eax
f0104413:	89 fa                	mov    %edi,%edx
f0104415:	89 47 28             	mov    %eax,0x28(%edi)
    	utf->utf_esp = tf->tf_esp;
f0104418:	8b 43 3c             	mov    0x3c(%ebx),%eax
f010441b:	89 47 30             	mov    %eax,0x30(%edi)
    	utf->utf_regs = tf->tf_regs;
f010441e:	89 75 e0             	mov    %esi,-0x20(%ebp)
f0104421:	8d 7e d0             	lea    -0x30(%esi),%edi
f0104424:	b9 08 00 00 00       	mov    $0x8,%ecx
f0104429:	89 de                	mov    %ebx,%esi
f010442b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    	utf->utf_err = tf->tf_err;
f010442d:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104430:	89 42 04             	mov    %eax,0x4(%edx)
    	utf->utf_fault_va = fault_va;
f0104433:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0104436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104439:	89 46 c8             	mov    %eax,-0x38(%esi)
		tf->tf_esp = (uintptr_t)utf;
f010443c:	89 53 3c             	mov    %edx,0x3c(%ebx)
    	tf->tf_eip = (uint32_t)curenv->env_pgfault_upcall;
f010443f:	e8 a6 1d 00 00       	call   f01061ea <cpunum>
f0104444:	6b c0 74             	imul   $0x74,%eax,%eax
f0104447:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f010444d:	8b 40 64             	mov    0x64(%eax),%eax
f0104450:	89 43 30             	mov    %eax,0x30(%ebx)
		env_run(curenv);
f0104453:	e8 92 1d 00 00       	call   f01061ea <cpunum>
f0104458:	83 c4 04             	add    $0x4,%esp
f010445b:	6b c0 74             	imul   $0x74,%eax,%eax
f010445e:	ff b0 28 20 2c f0    	pushl  -0xfd3dfd8(%eax)
f0104464:	e8 73 f3 ff ff       	call   f01037dc <env_run>

f0104469 <trap>:
{
f0104469:	f3 0f 1e fb          	endbr32 
f010446d:	55                   	push   %ebp
f010446e:	89 e5                	mov    %esp,%ebp
f0104470:	57                   	push   %edi
f0104471:	56                   	push   %esi
f0104472:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104475:	fc                   	cld    
	if (panicstr)
f0104476:	83 3d 90 1e 2c f0 00 	cmpl   $0x0,0xf02c1e90
f010447d:	74 01                	je     f0104480 <trap+0x17>
		asm volatile("hlt");
f010447f:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104480:	e8 65 1d 00 00       	call   f01061ea <cpunum>
f0104485:	6b d0 74             	imul   $0x74,%eax,%edx
f0104488:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010448b:	b8 01 00 00 00       	mov    $0x1,%eax
f0104490:	f0 87 82 20 20 2c f0 	lock xchg %eax,-0xfd3dfe0(%edx)
f0104497:	83 f8 02             	cmp    $0x2,%eax
f010449a:	0f 84 99 00 00 00    	je     f0104539 <trap+0xd0>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f01044a0:	9c                   	pushf  
f01044a1:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f01044a2:	f6 c4 02             	test   $0x2,%ah
f01044a5:	0f 85 a3 00 00 00    	jne    f010454e <trap+0xe5>
	if ((tf->tf_cs & 3) == 3) {
f01044ab:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f01044af:	83 e0 03             	and    $0x3,%eax
f01044b2:	66 83 f8 03          	cmp    $0x3,%ax
f01044b6:	0f 84 ab 00 00 00    	je     f0104567 <trap+0xfe>
	last_tf = tf;
f01044bc:	89 35 60 1a 2c f0    	mov    %esi,0xf02c1a60
	switch(tf->tf_trapno)
f01044c2:	8b 46 28             	mov    0x28(%esi),%eax
f01044c5:	83 f8 0e             	cmp    $0xe,%eax
f01044c8:	0f 84 14 01 00 00    	je     f01045e2 <trap+0x179>
f01044ce:	83 f8 30             	cmp    $0x30,%eax
f01044d1:	0f 84 53 01 00 00    	je     f010462a <trap+0x1c1>
f01044d7:	83 f8 03             	cmp    $0x3,%eax
f01044da:	0f 84 3c 01 00 00    	je     f010461c <trap+0x1b3>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f01044e0:	83 f8 27             	cmp    $0x27,%eax
f01044e3:	0f 84 62 01 00 00    	je     f010464b <trap+0x1e2>
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f01044e9:	83 f8 20             	cmp    $0x20,%eax
f01044ec:	0f 84 73 01 00 00    	je     f0104665 <trap+0x1fc>
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_KBD){
f01044f2:	83 f8 21             	cmp    $0x21,%eax
f01044f5:	0f 84 79 01 00 00    	je     f0104674 <trap+0x20b>
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL){
f01044fb:	83 f8 24             	cmp    $0x24,%eax
f01044fe:	0f 84 7a 01 00 00    	je     f010467e <trap+0x215>
	print_trapframe(tf);
f0104504:	83 ec 0c             	sub    $0xc,%esp
f0104507:	56                   	push   %esi
f0104508:	e8 96 fc ff ff       	call   f01041a3 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f010450d:	83 c4 10             	add    $0x10,%esp
f0104510:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104515:	0f 84 6d 01 00 00    	je     f0104688 <trap+0x21f>
		env_destroy(curenv);
f010451b:	e8 ca 1c 00 00       	call   f01061ea <cpunum>
f0104520:	83 ec 0c             	sub    $0xc,%esp
f0104523:	6b c0 74             	imul   $0x74,%eax,%eax
f0104526:	ff b0 28 20 2c f0    	pushl  -0xfd3dfd8(%eax)
f010452c:	e8 04 f2 ff ff       	call   f0103735 <env_destroy>
		return;
f0104531:	83 c4 10             	add    $0x10,%esp
f0104534:	e9 b5 00 00 00       	jmp    f01045ee <trap+0x185>
	spin_lock(&kernel_lock);
f0104539:	83 ec 0c             	sub    $0xc,%esp
f010453c:	68 c0 63 12 f0       	push   $0xf01263c0
f0104541:	e8 2c 1f 00 00       	call   f0106472 <spin_lock>
}
f0104546:	83 c4 10             	add    $0x10,%esp
f0104549:	e9 52 ff ff ff       	jmp    f01044a0 <trap+0x37>
	assert(!(read_eflags() & FL_IF));
f010454e:	68 66 87 10 f0       	push   $0xf0108766
f0104553:	68 dc 77 10 f0       	push   $0xf01077dc
f0104558:	68 59 01 00 00       	push   $0x159
f010455d:	68 5a 87 10 f0       	push   $0xf010875a
f0104562:	e8 d9 ba ff ff       	call   f0100040 <_panic>
	spin_lock(&kernel_lock);
f0104567:	83 ec 0c             	sub    $0xc,%esp
f010456a:	68 c0 63 12 f0       	push   $0xf01263c0
f010456f:	e8 fe 1e 00 00       	call   f0106472 <spin_lock>
		if (curenv->env_status == ENV_DYING) {
f0104574:	e8 71 1c 00 00       	call   f01061ea <cpunum>
f0104579:	6b c0 74             	imul   $0x74,%eax,%eax
f010457c:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f0104582:	83 c4 10             	add    $0x10,%esp
f0104585:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104589:	74 2a                	je     f01045b5 <trap+0x14c>
		curenv->env_tf = *tf;
f010458b:	e8 5a 1c 00 00       	call   f01061ea <cpunum>
f0104590:	6b c0 74             	imul   $0x74,%eax,%eax
f0104593:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f0104599:	b9 11 00 00 00       	mov    $0x11,%ecx
f010459e:	89 c7                	mov    %eax,%edi
f01045a0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f01045a2:	e8 43 1c 00 00       	call   f01061ea <cpunum>
f01045a7:	6b c0 74             	imul   $0x74,%eax,%eax
f01045aa:	8b b0 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%esi
f01045b0:	e9 07 ff ff ff       	jmp    f01044bc <trap+0x53>
			env_free(curenv);
f01045b5:	e8 30 1c 00 00       	call   f01061ea <cpunum>
f01045ba:	83 ec 0c             	sub    $0xc,%esp
f01045bd:	6b c0 74             	imul   $0x74,%eax,%eax
f01045c0:	ff b0 28 20 2c f0    	pushl  -0xfd3dfd8(%eax)
f01045c6:	e8 bc ef ff ff       	call   f0103587 <env_free>
			curenv = NULL;
f01045cb:	e8 1a 1c 00 00       	call   f01061ea <cpunum>
f01045d0:	6b c0 74             	imul   $0x74,%eax,%eax
f01045d3:	c7 80 28 20 2c f0 00 	movl   $0x0,-0xfd3dfd8(%eax)
f01045da:	00 00 00 
			sched_yield();
f01045dd:	e8 ab 02 00 00       	call   f010488d <sched_yield>
			page_fault_handler(tf);
f01045e2:	83 ec 0c             	sub    $0xc,%esp
f01045e5:	56                   	push   %esi
f01045e6:	e8 58 fd ff ff       	call   f0104343 <page_fault_handler>
			return ;
f01045eb:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f01045ee:	e8 f7 1b 00 00       	call   f01061ea <cpunum>
f01045f3:	6b c0 74             	imul   $0x74,%eax,%eax
f01045f6:	83 b8 28 20 2c f0 00 	cmpl   $0x0,-0xfd3dfd8(%eax)
f01045fd:	74 18                	je     f0104617 <trap+0x1ae>
f01045ff:	e8 e6 1b 00 00       	call   f01061ea <cpunum>
f0104604:	6b c0 74             	imul   $0x74,%eax,%eax
f0104607:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f010460d:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104611:	0f 84 88 00 00 00    	je     f010469f <trap+0x236>
		sched_yield();
f0104617:	e8 71 02 00 00       	call   f010488d <sched_yield>
			monitor(tf);
f010461c:	83 ec 0c             	sub    $0xc,%esp
f010461f:	56                   	push   %esi
f0104620:	e8 70 c3 ff ff       	call   f0100995 <monitor>
			return ;
f0104625:	83 c4 10             	add    $0x10,%esp
f0104628:	eb c4                	jmp    f01045ee <trap+0x185>
			p->reg_eax = syscall(p->reg_eax, p->reg_edx, p->reg_ecx, p->reg_ebx, p->reg_edi, p->reg_esi);
f010462a:	83 ec 08             	sub    $0x8,%esp
f010462d:	ff 76 04             	pushl  0x4(%esi)
f0104630:	ff 36                	pushl  (%esi)
f0104632:	ff 76 10             	pushl  0x10(%esi)
f0104635:	ff 76 18             	pushl  0x18(%esi)
f0104638:	ff 76 14             	pushl  0x14(%esi)
f010463b:	ff 76 1c             	pushl  0x1c(%esi)
f010463e:	e8 10 03 00 00       	call   f0104953 <syscall>
f0104643:	89 46 1c             	mov    %eax,0x1c(%esi)
			return ;
f0104646:	83 c4 20             	add    $0x20,%esp
f0104649:	eb a3                	jmp    f01045ee <trap+0x185>
		cprintf("Spurious interrupt on irq 7\n");
f010464b:	83 ec 0c             	sub    $0xc,%esp
f010464e:	68 7f 87 10 f0       	push   $0xf010877f
f0104653:	e8 de f3 ff ff       	call   f0103a36 <cprintf>
		print_trapframe(tf);
f0104658:	89 34 24             	mov    %esi,(%esp)
f010465b:	e8 43 fb ff ff       	call   f01041a3 <print_trapframe>
		return;
f0104660:	83 c4 10             	add    $0x10,%esp
f0104663:	eb 89                	jmp    f01045ee <trap+0x185>
		time_tick();
f0104665:	e8 e0 28 00 00       	call   f0106f4a <time_tick>
		lapic_eoi();
f010466a:	e8 ca 1c 00 00       	call   f0106339 <lapic_eoi>
		sched_yield();
f010466f:	e8 19 02 00 00       	call   f010488d <sched_yield>
		kbd_intr();
f0104674:	e8 9d bf ff ff       	call   f0100616 <kbd_intr>
		return ;
f0104679:	e9 70 ff ff ff       	jmp    f01045ee <trap+0x185>
		serial_intr();
f010467e:	e8 73 bf ff ff       	call   f01005f6 <serial_intr>
		return ;
f0104683:	e9 66 ff ff ff       	jmp    f01045ee <trap+0x185>
		panic("unhandled trap in kernel");
f0104688:	83 ec 04             	sub    $0x4,%esp
f010468b:	68 9c 87 10 f0       	push   $0xf010879c
f0104690:	68 3f 01 00 00       	push   $0x13f
f0104695:	68 5a 87 10 f0       	push   $0xf010875a
f010469a:	e8 a1 b9 ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f010469f:	e8 46 1b 00 00       	call   f01061ea <cpunum>
f01046a4:	83 ec 0c             	sub    $0xc,%esp
f01046a7:	6b c0 74             	imul   $0x74,%eax,%eax
f01046aa:	ff b0 28 20 2c f0    	pushl  -0xfd3dfd8(%eax)
f01046b0:	e8 27 f1 ff ff       	call   f01037dc <env_run>
f01046b5:	90                   	nop

f01046b6 <divide_handler>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(divide_handler,T_DIVIDE)
f01046b6:	6a 00                	push   $0x0
f01046b8:	6a 00                	push   $0x0
f01046ba:	e9 ef 00 00 00       	jmp    f01047ae <_alltraps>
f01046bf:	90                   	nop

f01046c0 <debug_handler>:
TRAPHANDLER_NOEC(debug_handler,T_DEBUG)
f01046c0:	6a 00                	push   $0x0
f01046c2:	6a 01                	push   $0x1
f01046c4:	e9 e5 00 00 00       	jmp    f01047ae <_alltraps>
f01046c9:	90                   	nop

f01046ca <nmi_handler>:
TRAPHANDLER_NOEC(nmi_handler,T_NMI)
f01046ca:	6a 00                	push   $0x0
f01046cc:	6a 02                	push   $0x2
f01046ce:	e9 db 00 00 00       	jmp    f01047ae <_alltraps>
f01046d3:	90                   	nop

f01046d4 <brkpt_handler>:
TRAPHANDLER_NOEC(brkpt_handler,T_BRKPT)
f01046d4:	6a 00                	push   $0x0
f01046d6:	6a 03                	push   $0x3
f01046d8:	e9 d1 00 00 00       	jmp    f01047ae <_alltraps>
f01046dd:	90                   	nop

f01046de <oflow_handler>:
TRAPHANDLER_NOEC(oflow_handler,T_OFLOW)
f01046de:	6a 00                	push   $0x0
f01046e0:	6a 04                	push   $0x4
f01046e2:	e9 c7 00 00 00       	jmp    f01047ae <_alltraps>
f01046e7:	90                   	nop

f01046e8 <bound_handler>:
TRAPHANDLER_NOEC(bound_handler,T_BOUND)
f01046e8:	6a 00                	push   $0x0
f01046ea:	6a 05                	push   $0x5
f01046ec:	e9 bd 00 00 00       	jmp    f01047ae <_alltraps>
f01046f1:	90                   	nop

f01046f2 <illop_handler>:
TRAPHANDLER_NOEC(illop_handler,T_ILLOP)
f01046f2:	6a 00                	push   $0x0
f01046f4:	6a 06                	push   $0x6
f01046f6:	e9 b3 00 00 00       	jmp    f01047ae <_alltraps>
f01046fb:	90                   	nop

f01046fc <device_handler>:
TRAPHANDLER_NOEC(device_handler,T_DEVICE)
f01046fc:	6a 00                	push   $0x0
f01046fe:	6a 07                	push   $0x7
f0104700:	e9 a9 00 00 00       	jmp    f01047ae <_alltraps>
f0104705:	90                   	nop

f0104706 <dblflt_handler>:
TRAPHANDLER(dblflt_handler,T_DBLFLT)
f0104706:	6a 08                	push   $0x8
f0104708:	e9 a1 00 00 00       	jmp    f01047ae <_alltraps>
f010470d:	90                   	nop

f010470e <tss_handler>:
TRAPHANDLER(tss_handler,T_TSS)
f010470e:	6a 0a                	push   $0xa
f0104710:	e9 99 00 00 00       	jmp    f01047ae <_alltraps>
f0104715:	90                   	nop

f0104716 <segnp_handler>:
TRAPHANDLER(segnp_handler,T_SEGNP)
f0104716:	6a 0b                	push   $0xb
f0104718:	e9 91 00 00 00       	jmp    f01047ae <_alltraps>
f010471d:	90                   	nop

f010471e <stack_handler>:
TRAPHANDLER(stack_handler,T_STACK)
f010471e:	6a 0c                	push   $0xc
f0104720:	e9 89 00 00 00       	jmp    f01047ae <_alltraps>
f0104725:	90                   	nop

f0104726 <gpflt_handler>:
TRAPHANDLER(gpflt_handler,T_GPFLT)
f0104726:	6a 0d                	push   $0xd
f0104728:	e9 81 00 00 00       	jmp    f01047ae <_alltraps>
f010472d:	90                   	nop

f010472e <pgflt_handler>:
TRAPHANDLER(pgflt_handler,T_PGFLT)
f010472e:	6a 0e                	push   $0xe
f0104730:	eb 7c                	jmp    f01047ae <_alltraps>

f0104732 <fperr_handler>:
TRAPHANDLER_NOEC(fperr_handler,T_FPERR)
f0104732:	6a 00                	push   $0x0
f0104734:	6a 10                	push   $0x10
f0104736:	eb 76                	jmp    f01047ae <_alltraps>

f0104738 <align_handler>:
TRAPHANDLER(align_handler,T_ALIGN)
f0104738:	6a 11                	push   $0x11
f010473a:	eb 72                	jmp    f01047ae <_alltraps>

f010473c <mchk_handler>:
TRAPHANDLER_NOEC(mchk_handler,T_MCHK)
f010473c:	6a 00                	push   $0x0
f010473e:	6a 12                	push   $0x12
f0104740:	eb 6c                	jmp    f01047ae <_alltraps>

f0104742 <simderr_handler>:
TRAPHANDLER_NOEC(simderr_handler,T_SIMDERR)
f0104742:	6a 00                	push   $0x0
f0104744:	6a 13                	push   $0x13
f0104746:	eb 66                	jmp    f01047ae <_alltraps>

f0104748 <syscall_handler>:
TRAPHANDLER_NOEC(syscall_handler,T_SYSCALL)
f0104748:	6a 00                	push   $0x0
f010474a:	6a 30                	push   $0x30
f010474c:	eb 60                	jmp    f01047ae <_alltraps>

f010474e <irq_0_handler>:

/*
 * Lab 4: Add IRQ 0 - 15
 */

TRAPHANDLER_NOEC(irq_0_handler, IRQ_OFFSET + 0);
f010474e:	6a 00                	push   $0x0
f0104750:	6a 20                	push   $0x20
f0104752:	eb 5a                	jmp    f01047ae <_alltraps>

f0104754 <irq_1_handler>:
TRAPHANDLER_NOEC(irq_1_handler, IRQ_OFFSET + 1);
f0104754:	6a 00                	push   $0x0
f0104756:	6a 21                	push   $0x21
f0104758:	eb 54                	jmp    f01047ae <_alltraps>

f010475a <irq_2_handler>:
TRAPHANDLER_NOEC(irq_2_handler, IRQ_OFFSET + 2);
f010475a:	6a 00                	push   $0x0
f010475c:	6a 22                	push   $0x22
f010475e:	eb 4e                	jmp    f01047ae <_alltraps>

f0104760 <irq_3_handler>:
TRAPHANDLER_NOEC(irq_3_handler, IRQ_OFFSET + 3);
f0104760:	6a 00                	push   $0x0
f0104762:	6a 23                	push   $0x23
f0104764:	eb 48                	jmp    f01047ae <_alltraps>

f0104766 <irq_4_handler>:
TRAPHANDLER_NOEC(irq_4_handler, IRQ_OFFSET + 4);
f0104766:	6a 00                	push   $0x0
f0104768:	6a 24                	push   $0x24
f010476a:	eb 42                	jmp    f01047ae <_alltraps>

f010476c <irq_5_handler>:
TRAPHANDLER_NOEC(irq_5_handler, IRQ_OFFSET + 5);
f010476c:	6a 00                	push   $0x0
f010476e:	6a 25                	push   $0x25
f0104770:	eb 3c                	jmp    f01047ae <_alltraps>

f0104772 <irq_6_handler>:
TRAPHANDLER_NOEC(irq_6_handler, IRQ_OFFSET + 6);
f0104772:	6a 00                	push   $0x0
f0104774:	6a 26                	push   $0x26
f0104776:	eb 36                	jmp    f01047ae <_alltraps>

f0104778 <irq_7_handler>:
TRAPHANDLER_NOEC(irq_7_handler, IRQ_OFFSET + 7);
f0104778:	6a 00                	push   $0x0
f010477a:	6a 27                	push   $0x27
f010477c:	eb 30                	jmp    f01047ae <_alltraps>

f010477e <irq_8_handler>:
TRAPHANDLER_NOEC(irq_8_handler, IRQ_OFFSET + 8);
f010477e:	6a 00                	push   $0x0
f0104780:	6a 28                	push   $0x28
f0104782:	eb 2a                	jmp    f01047ae <_alltraps>

f0104784 <irq_9_handler>:
TRAPHANDLER_NOEC(irq_9_handler, IRQ_OFFSET + 9);
f0104784:	6a 00                	push   $0x0
f0104786:	6a 29                	push   $0x29
f0104788:	eb 24                	jmp    f01047ae <_alltraps>

f010478a <irq_10_handler>:
TRAPHANDLER_NOEC(irq_10_handler, IRQ_OFFSET + 10);
f010478a:	6a 00                	push   $0x0
f010478c:	6a 2a                	push   $0x2a
f010478e:	eb 1e                	jmp    f01047ae <_alltraps>

f0104790 <irq_11_handler>:
TRAPHANDLER_NOEC(irq_11_handler, IRQ_OFFSET + 11);
f0104790:	6a 00                	push   $0x0
f0104792:	6a 2b                	push   $0x2b
f0104794:	eb 18                	jmp    f01047ae <_alltraps>

f0104796 <irq_12_handler>:
TRAPHANDLER_NOEC(irq_12_handler, IRQ_OFFSET + 12);
f0104796:	6a 00                	push   $0x0
f0104798:	6a 2c                	push   $0x2c
f010479a:	eb 12                	jmp    f01047ae <_alltraps>

f010479c <irq_13_handler>:
TRAPHANDLER_NOEC(irq_13_handler, IRQ_OFFSET + 13);
f010479c:	6a 00                	push   $0x0
f010479e:	6a 2d                	push   $0x2d
f01047a0:	eb 0c                	jmp    f01047ae <_alltraps>

f01047a2 <irq_14_handler>:
TRAPHANDLER_NOEC(irq_14_handler, IRQ_OFFSET + 14);
f01047a2:	6a 00                	push   $0x0
f01047a4:	6a 2e                	push   $0x2e
f01047a6:	eb 06                	jmp    f01047ae <_alltraps>

f01047a8 <irq_15_handler>:
TRAPHANDLER_NOEC(irq_15_handler, IRQ_OFFSET + 15);
f01047a8:	6a 00                	push   $0x0
f01047aa:	6a 2f                	push   $0x2f
f01047ac:	eb 00                	jmp    f01047ae <_alltraps>

f01047ae <_alltraps>:

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl	%es
f01047ae:	06                   	push   %es
	pushl	%ds
f01047af:	1e                   	push   %ds
	pushal
f01047b0:	60                   	pusha  
	movw	$(GD_KD), %ax
f01047b1:	66 b8 10 00          	mov    $0x10,%ax
	movw 	%ax, %ds
f01047b5:	8e d8                	mov    %eax,%ds
	movw 	%ax, %es
f01047b7:	8e c0                	mov    %eax,%es
	pushl	%esp
f01047b9:	54                   	push   %esp
f01047ba:	e8 aa fc ff ff       	call   f0104469 <trap>

f01047bf <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f01047bf:	f3 0f 1e fb          	endbr32 
f01047c3:	55                   	push   %ebp
f01047c4:	89 e5                	mov    %esp,%ebp
f01047c6:	83 ec 08             	sub    $0x8,%esp
f01047c9:	a1 48 12 2c f0       	mov    0xf02c1248,%eax
f01047ce:	8d 50 54             	lea    0x54(%eax),%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f01047d1:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f01047d6:	8b 02                	mov    (%edx),%eax
f01047d8:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f01047db:	83 f8 02             	cmp    $0x2,%eax
f01047de:	76 2d                	jbe    f010480d <sched_halt+0x4e>
	for (i = 0; i < NENV; i++) {
f01047e0:	83 c1 01             	add    $0x1,%ecx
f01047e3:	83 c2 7c             	add    $0x7c,%edx
f01047e6:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01047ec:	75 e8                	jne    f01047d6 <sched_halt+0x17>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f01047ee:	83 ec 0c             	sub    $0xc,%esp
f01047f1:	68 b0 89 10 f0       	push   $0xf01089b0
f01047f6:	e8 3b f2 ff ff       	call   f0103a36 <cprintf>
f01047fb:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f01047fe:	83 ec 0c             	sub    $0xc,%esp
f0104801:	6a 00                	push   $0x0
f0104803:	e8 8d c1 ff ff       	call   f0100995 <monitor>
f0104808:	83 c4 10             	add    $0x10,%esp
f010480b:	eb f1                	jmp    f01047fe <sched_halt+0x3f>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f010480d:	e8 d8 19 00 00       	call   f01061ea <cpunum>
f0104812:	6b c0 74             	imul   $0x74,%eax,%eax
f0104815:	c7 80 28 20 2c f0 00 	movl   $0x0,-0xfd3dfd8(%eax)
f010481c:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f010481f:	a1 9c 1e 2c f0       	mov    0xf02c1e9c,%eax
	if ((uint32_t)kva < KERNBASE)
f0104824:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104829:	76 50                	jbe    f010487b <sched_halt+0xbc>
	return (physaddr_t)kva - KERNBASE;
f010482b:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104830:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104833:	e8 b2 19 00 00       	call   f01061ea <cpunum>
f0104838:	6b d0 74             	imul   $0x74,%eax,%edx
f010483b:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010483e:	b8 02 00 00 00       	mov    $0x2,%eax
f0104843:	f0 87 82 20 20 2c f0 	lock xchg %eax,-0xfd3dfe0(%edx)
	spin_unlock(&kernel_lock);
f010484a:	83 ec 0c             	sub    $0xc,%esp
f010484d:	68 c0 63 12 f0       	push   $0xf01263c0
f0104852:	e8 b9 1c 00 00       	call   f0106510 <spin_unlock>
	asm volatile("pause");
f0104857:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104859:	e8 8c 19 00 00       	call   f01061ea <cpunum>
f010485e:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0104861:	8b 80 30 20 2c f0    	mov    -0xfd3dfd0(%eax),%eax
f0104867:	bd 00 00 00 00       	mov    $0x0,%ebp
f010486c:	89 c4                	mov    %eax,%esp
f010486e:	6a 00                	push   $0x0
f0104870:	6a 00                	push   $0x0
f0104872:	fb                   	sti    
f0104873:	f4                   	hlt    
f0104874:	eb fd                	jmp    f0104873 <sched_halt+0xb4>
}
f0104876:	83 c4 10             	add    $0x10,%esp
f0104879:	c9                   	leave  
f010487a:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010487b:	50                   	push   %eax
f010487c:	68 48 72 10 f0       	push   $0xf0107248
f0104881:	6a 57                	push   $0x57
f0104883:	68 d9 89 10 f0       	push   $0xf01089d9
f0104888:	e8 b3 b7 ff ff       	call   f0100040 <_panic>

f010488d <sched_yield>:
{
f010488d:	f3 0f 1e fb          	endbr32 
f0104891:	55                   	push   %ebp
f0104892:	89 e5                	mov    %esp,%ebp
f0104894:	53                   	push   %ebx
f0104895:	83 ec 04             	sub    $0x4,%esp
	if (curenv){
f0104898:	e8 4d 19 00 00       	call   f01061ea <cpunum>
f010489d:	6b c0 74             	imul   $0x74,%eax,%eax
f01048a0:	83 b8 28 20 2c f0 00 	cmpl   $0x0,-0xfd3dfd8(%eax)
f01048a7:	74 3e                	je     f01048e7 <sched_yield+0x5a>
		size_t eidx = ENVX(curenv->env_id);
f01048a9:	e8 3c 19 00 00       	call   f01061ea <cpunum>
f01048ae:	6b c0 74             	imul   $0x74,%eax,%eax
f01048b1:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f01048b7:	8b 48 48             	mov    0x48(%eax),%ecx
f01048ba:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for (size_t i = (eidx + 1) & mask; i != eidx; i = (i + 1) & mask){
f01048c0:	8d 41 01             	lea    0x1(%ecx),%eax
f01048c3:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f01048c8:	8b 1d 48 12 2c f0    	mov    0xf02c1248,%ebx
		for (size_t i = (eidx + 1) & mask; i != eidx; i = (i + 1) & mask){
f01048ce:	39 c8                	cmp    %ecx,%eax
f01048d0:	74 3a                	je     f010490c <sched_yield+0x7f>
			if(envs[i].env_status == ENV_RUNNABLE){
f01048d2:	6b d0 7c             	imul   $0x7c,%eax,%edx
f01048d5:	01 da                	add    %ebx,%edx
f01048d7:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f01048db:	74 26                	je     f0104903 <sched_yield+0x76>
		for (size_t i = (eidx + 1) & mask; i != eidx; i = (i + 1) & mask){
f01048dd:	83 c0 01             	add    $0x1,%eax
f01048e0:	25 ff 03 00 00       	and    $0x3ff,%eax
f01048e5:	eb e7                	jmp    f01048ce <sched_yield+0x41>
f01048e7:	a1 48 12 2c f0       	mov    0xf02c1248,%eax
f01048ec:	8d 88 00 f0 01 00    	lea    0x1f000(%eax),%ecx
			if(envs[i].env_status == ENV_RUNNABLE){
f01048f2:	89 c2                	mov    %eax,%edx
f01048f4:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01048f8:	74 09                	je     f0104903 <sched_yield+0x76>
f01048fa:	83 c0 7c             	add    $0x7c,%eax
		for(size_t i = 0; i < NENV; ++i) {
f01048fd:	39 c8                	cmp    %ecx,%eax
f01048ff:	75 f1                	jne    f01048f2 <sched_yield+0x65>
f0104901:	eb 2f                	jmp    f0104932 <sched_yield+0xa5>
		env_run(idle);
f0104903:	83 ec 0c             	sub    $0xc,%esp
f0104906:	52                   	push   %edx
f0104907:	e8 d0 ee ff ff       	call   f01037dc <env_run>
		if(!idle && curenv->env_status == ENV_RUNNING){
f010490c:	e8 d9 18 00 00       	call   f01061ea <cpunum>
f0104911:	6b c0 74             	imul   $0x74,%eax,%eax
f0104914:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f010491a:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010491e:	75 12                	jne    f0104932 <sched_yield+0xa5>
			idle = curenv;
f0104920:	e8 c5 18 00 00       	call   f01061ea <cpunum>
f0104925:	6b c0 74             	imul   $0x74,%eax,%eax
f0104928:	8b 90 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%edx
	if(idle){
f010492e:	85 d2                	test   %edx,%edx
f0104930:	75 d1                	jne    f0104903 <sched_yield+0x76>
	sched_halt();
f0104932:	e8 88 fe ff ff       	call   f01047bf <sched_halt>
}
f0104937:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010493a:	c9                   	leave  
f010493b:	c3                   	ret    

f010493c <sys_pkt_send>:
	return (int)time_msec();
}

int
sys_pkt_send(void *data, size_t len)
{
f010493c:	f3 0f 1e fb          	endbr32 
f0104940:	55                   	push   %ebp
f0104941:	89 e5                	mov    %esp,%ebp
f0104943:	83 ec 10             	sub    $0x10,%esp
	return e1000_transmit(data, len);
f0104946:	ff 75 0c             	pushl  0xc(%ebp)
f0104949:	ff 75 08             	pushl  0x8(%ebp)
f010494c:	e8 84 1f 00 00       	call   f01068d5 <e1000_transmit>
}
f0104951:	c9                   	leave  
f0104952:	c3                   	ret    

f0104953 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104953:	f3 0f 1e fb          	endbr32 
f0104957:	55                   	push   %ebp
f0104958:	89 e5                	mov    %esp,%ebp
f010495a:	57                   	push   %edi
f010495b:	56                   	push   %esi
f010495c:	53                   	push   %ebx
f010495d:	83 ec 1c             	sub    $0x1c,%esp
f0104960:	8b 45 08             	mov    0x8(%ebp),%eax
f0104963:	83 f8 10             	cmp    $0x10,%eax
f0104966:	0f 87 0d 06 00 00    	ja     f0104f79 <syscall+0x626>
f010496c:	3e ff 24 85 20 8a 10 	notrack jmp *-0xfef75e0(,%eax,4)
f0104973:	f0 
	user_mem_assert(curenv, s, len, PTE_U);
f0104974:	e8 71 18 00 00       	call   f01061ea <cpunum>
f0104979:	6a 04                	push   $0x4
f010497b:	ff 75 10             	pushl  0x10(%ebp)
f010497e:	ff 75 0c             	pushl  0xc(%ebp)
f0104981:	6b c0 74             	imul   $0x74,%eax,%eax
f0104984:	ff b0 28 20 2c f0    	pushl  -0xfd3dfd8(%eax)
f010498a:	e8 48 e7 ff ff       	call   f01030d7 <user_mem_assert>
	cprintf("%.*s", len, s);
f010498f:	83 c4 0c             	add    $0xc,%esp
f0104992:	ff 75 0c             	pushl  0xc(%ebp)
f0104995:	ff 75 10             	pushl  0x10(%ebp)
f0104998:	68 e6 89 10 f0       	push   $0xf01089e6
f010499d:	e8 94 f0 ff ff       	call   f0103a36 <cprintf>
}
f01049a2:	83 c4 10             	add    $0x10,%esp
	// LAB 3: Your code here.

	switch (syscallno) {
		case SYS_cputs:
			sys_cputs((char *) a1, a2);
			return 0;
f01049a5:	bb 00 00 00 00       	mov    $0x0,%ebx
		default:
			return -E_INVAL;
	}

	return -E_INVAL;
f01049aa:	89 d8                	mov    %ebx,%eax
f01049ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01049af:	5b                   	pop    %ebx
f01049b0:	5e                   	pop    %esi
f01049b1:	5f                   	pop    %edi
f01049b2:	5d                   	pop    %ebp
f01049b3:	c3                   	ret    
	return cons_getc();
f01049b4:	e8 73 bc ff ff       	call   f010062c <cons_getc>
f01049b9:	89 c3                	mov    %eax,%ebx
			return sys_cgetc();
f01049bb:	eb ed                	jmp    f01049aa <syscall+0x57>
	return curenv->env_id;
f01049bd:	e8 28 18 00 00       	call   f01061ea <cpunum>
f01049c2:	6b c0 74             	imul   $0x74,%eax,%eax
f01049c5:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f01049cb:	8b 58 48             	mov    0x48(%eax),%ebx
			return sys_getenvid();
f01049ce:	eb da                	jmp    f01049aa <syscall+0x57>
	if ((r = envid2env(envid, &e, 1)) < 0)
f01049d0:	83 ec 04             	sub    $0x4,%esp
f01049d3:	6a 01                	push   $0x1
f01049d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01049d8:	50                   	push   %eax
f01049d9:	ff 75 0c             	pushl  0xc(%ebp)
f01049dc:	e8 b1 e7 ff ff       	call   f0103192 <envid2env>
f01049e1:	89 c3                	mov    %eax,%ebx
f01049e3:	83 c4 10             	add    $0x10,%esp
f01049e6:	85 c0                	test   %eax,%eax
f01049e8:	78 c0                	js     f01049aa <syscall+0x57>
	if (e == curenv)
f01049ea:	e8 fb 17 00 00       	call   f01061ea <cpunum>
f01049ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01049f2:	6b c0 74             	imul   $0x74,%eax,%eax
f01049f5:	39 90 28 20 2c f0    	cmp    %edx,-0xfd3dfd8(%eax)
f01049fb:	74 3d                	je     f0104a3a <syscall+0xe7>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01049fd:	8b 5a 48             	mov    0x48(%edx),%ebx
f0104a00:	e8 e5 17 00 00       	call   f01061ea <cpunum>
f0104a05:	83 ec 04             	sub    $0x4,%esp
f0104a08:	53                   	push   %ebx
f0104a09:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a0c:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f0104a12:	ff 70 48             	pushl  0x48(%eax)
f0104a15:	68 06 8a 10 f0       	push   $0xf0108a06
f0104a1a:	e8 17 f0 ff ff       	call   f0103a36 <cprintf>
f0104a1f:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f0104a22:	83 ec 0c             	sub    $0xc,%esp
f0104a25:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104a28:	e8 08 ed ff ff       	call   f0103735 <env_destroy>
	return 0;
f0104a2d:	83 c4 10             	add    $0x10,%esp
f0104a30:	bb 00 00 00 00       	mov    $0x0,%ebx
			return sys_env_destroy(a1);
f0104a35:	e9 70 ff ff ff       	jmp    f01049aa <syscall+0x57>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0104a3a:	e8 ab 17 00 00       	call   f01061ea <cpunum>
f0104a3f:	83 ec 08             	sub    $0x8,%esp
f0104a42:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a45:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f0104a4b:	ff 70 48             	pushl  0x48(%eax)
f0104a4e:	68 eb 89 10 f0       	push   $0xf01089eb
f0104a53:	e8 de ef ff ff       	call   f0103a36 <cprintf>
f0104a58:	83 c4 10             	add    $0x10,%esp
f0104a5b:	eb c5                	jmp    f0104a22 <syscall+0xcf>
	sched_yield();
f0104a5d:	e8 2b fe ff ff       	call   f010488d <sched_yield>
	parent = curenv;
f0104a62:	e8 83 17 00 00       	call   f01061ea <cpunum>
f0104a67:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a6a:	8b b0 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%esi
	if((e = env_alloc(&child, parent->env_id)) < 0){
f0104a70:	83 ec 08             	sub    $0x8,%esp
f0104a73:	ff 76 48             	pushl  0x48(%esi)
f0104a76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104a79:	50                   	push   %eax
f0104a7a:	e8 21 e8 ff ff       	call   f01032a0 <env_alloc>
f0104a7f:	89 c3                	mov    %eax,%ebx
f0104a81:	83 c4 10             	add    $0x10,%esp
f0104a84:	85 c0                	test   %eax,%eax
f0104a86:	0f 88 1e ff ff ff    	js     f01049aa <syscall+0x57>
	child->env_tf = parent->env_tf;
f0104a8c:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104a91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104a94:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child->env_status = ENV_NOT_RUNNABLE;
f0104a96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a99:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	child->env_tf.tf_regs.reg_eax = 0;
f0104aa0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return child->env_id;
f0104aa7:	8b 58 48             	mov    0x48(%eax),%ebx
			return sys_exofork();
f0104aaa:	e9 fb fe ff ff       	jmp    f01049aa <syscall+0x57>
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE){
f0104aaf:	8b 45 10             	mov    0x10(%ebp),%eax
f0104ab2:	83 e8 02             	sub    $0x2,%eax
f0104ab5:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f0104aba:	75 28                	jne    f0104ae4 <syscall+0x191>
	if(envid2env(envid, &e, 1) != 0){
f0104abc:	83 ec 04             	sub    $0x4,%esp
f0104abf:	6a 01                	push   $0x1
f0104ac1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104ac4:	50                   	push   %eax
f0104ac5:	ff 75 0c             	pushl  0xc(%ebp)
f0104ac8:	e8 c5 e6 ff ff       	call   f0103192 <envid2env>
f0104acd:	89 c3                	mov    %eax,%ebx
f0104acf:	83 c4 10             	add    $0x10,%esp
f0104ad2:	85 c0                	test   %eax,%eax
f0104ad4:	75 18                	jne    f0104aee <syscall+0x19b>
	e->env_status = status;
f0104ad6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104ad9:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104adc:	89 78 54             	mov    %edi,0x54(%eax)
	return 0;
f0104adf:	e9 c6 fe ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_INVAL;
f0104ae4:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ae9:	e9 bc fe ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_BAD_ENV;
f0104aee:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
			return sys_env_set_status(a1, a2);
f0104af3:	e9 b2 fe ff ff       	jmp    f01049aa <syscall+0x57>
	struct Env* e = NULL;
f0104af8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if(envid2env(envid, &e, 1) < 0)
f0104aff:	83 ec 04             	sub    $0x4,%esp
f0104b02:	6a 01                	push   $0x1
f0104b04:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104b07:	50                   	push   %eax
f0104b08:	ff 75 0c             	pushl  0xc(%ebp)
f0104b0b:	e8 82 e6 ff ff       	call   f0103192 <envid2env>
f0104b10:	83 c4 10             	add    $0x10,%esp
f0104b13:	85 c0                	test   %eax,%eax
f0104b15:	78 6e                	js     f0104b85 <syscall+0x232>
	if((uintptr_t)va >= UTOP || PGOFF(va))
f0104b17:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104b1e:	77 6f                	ja     f0104b8f <syscall+0x23c>
f0104b20:	8b 45 10             	mov    0x10(%ebp),%eax
f0104b23:	25 ff 0f 00 00       	and    $0xfff,%eax
	if(((perm & flag) != flag) || (perm & ~PTE_SYSCALL) != 0)
f0104b28:	8b 55 14             	mov    0x14(%ebp),%edx
f0104b2b:	83 e2 05             	and    $0x5,%edx
f0104b2e:	83 fa 05             	cmp    $0x5,%edx
f0104b31:	75 66                	jne    f0104b99 <syscall+0x246>
f0104b33:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0104b36:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0104b3c:	09 c3                	or     %eax,%ebx
f0104b3e:	75 63                	jne    f0104ba3 <syscall+0x250>
	if((pp = page_alloc(ALLOC_ZERO)) == NULL)
f0104b40:	83 ec 0c             	sub    $0xc,%esp
f0104b43:	6a 01                	push   $0x1
f0104b45:	e8 bd c4 ff ff       	call   f0101007 <page_alloc>
f0104b4a:	89 c6                	mov    %eax,%esi
f0104b4c:	83 c4 10             	add    $0x10,%esp
f0104b4f:	85 c0                	test   %eax,%eax
f0104b51:	74 5a                	je     f0104bad <syscall+0x25a>
	if((r = page_insert(e->env_pgdir, pp, (void*)va, perm)) < 0){
f0104b53:	ff 75 14             	pushl  0x14(%ebp)
f0104b56:	ff 75 10             	pushl  0x10(%ebp)
f0104b59:	50                   	push   %eax
f0104b5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104b5d:	ff 70 60             	pushl  0x60(%eax)
f0104b60:	e8 de c7 ff ff       	call   f0101343 <page_insert>
f0104b65:	89 c7                	mov    %eax,%edi
f0104b67:	83 c4 10             	add    $0x10,%esp
f0104b6a:	85 c0                	test   %eax,%eax
f0104b6c:	0f 89 38 fe ff ff    	jns    f01049aa <syscall+0x57>
		page_free(pp);
f0104b72:	83 ec 0c             	sub    $0xc,%esp
f0104b75:	56                   	push   %esi
f0104b76:	e8 17 c5 ff ff       	call   f0101092 <page_free>
		return r;
f0104b7b:	83 c4 10             	add    $0x10,%esp
f0104b7e:	89 fb                	mov    %edi,%ebx
f0104b80:	e9 25 fe ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_BAD_ENV;
f0104b85:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104b8a:	e9 1b fe ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_INVAL;
f0104b8f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b94:	e9 11 fe ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_INVAL;
f0104b99:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b9e:	e9 07 fe ff ff       	jmp    f01049aa <syscall+0x57>
f0104ba3:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ba8:	e9 fd fd ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_NO_MEM;
f0104bad:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			return sys_page_alloc(a1, (void *) a2, a3);
f0104bb2:	e9 f3 fd ff ff       	jmp    f01049aa <syscall+0x57>
	struct Env* src = NULL;
f0104bb7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	struct Env* dst = NULL;
f0104bbe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	if(envid2env(srcenvid, &src, 1) < 0 || envid2env(dstenvid, &dst, 1))
f0104bc5:	83 ec 04             	sub    $0x4,%esp
f0104bc8:	6a 01                	push   $0x1
f0104bca:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104bcd:	50                   	push   %eax
f0104bce:	ff 75 0c             	pushl  0xc(%ebp)
f0104bd1:	e8 bc e5 ff ff       	call   f0103192 <envid2env>
f0104bd6:	83 c4 10             	add    $0x10,%esp
f0104bd9:	85 c0                	test   %eax,%eax
f0104bdb:	0f 88 9a 00 00 00    	js     f0104c7b <syscall+0x328>
f0104be1:	83 ec 04             	sub    $0x4,%esp
f0104be4:	6a 01                	push   $0x1
f0104be6:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104be9:	50                   	push   %eax
f0104bea:	ff 75 14             	pushl  0x14(%ebp)
f0104bed:	e8 a0 e5 ff ff       	call   f0103192 <envid2env>
f0104bf2:	89 c3                	mov    %eax,%ebx
f0104bf4:	83 c4 10             	add    $0x10,%esp
f0104bf7:	85 c0                	test   %eax,%eax
f0104bf9:	0f 85 86 00 00 00    	jne    f0104c85 <syscall+0x332>
	if((uintptr_t)srcva >= UTOP || PGOFF(srcva))
f0104bff:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104c06:	0f 87 83 00 00 00    	ja     f0104c8f <syscall+0x33c>
	if((uintptr_t)dstva >= UTOP || PGOFF(dstva))
f0104c0c:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0104c13:	0f 87 80 00 00 00    	ja     f0104c99 <syscall+0x346>
f0104c19:	8b 45 10             	mov    0x10(%ebp),%eax
f0104c1c:	0b 45 18             	or     0x18(%ebp),%eax
f0104c1f:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0104c24:	75 7d                	jne    f0104ca3 <syscall+0x350>
	pte_t* pte_addr = NULL;
f0104c26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if((page = page_lookup(src->env_pgdir, srcva, &pte_addr)) == NULL)
f0104c2d:	83 ec 04             	sub    $0x4,%esp
f0104c30:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104c33:	50                   	push   %eax
f0104c34:	ff 75 10             	pushl  0x10(%ebp)
f0104c37:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104c3a:	ff 70 60             	pushl  0x60(%eax)
f0104c3d:	e8 0b c6 ff ff       	call   f010124d <page_lookup>
f0104c42:	83 c4 10             	add    $0x10,%esp
f0104c45:	85 c0                	test   %eax,%eax
f0104c47:	74 64                	je     f0104cad <syscall+0x35a>
	if(((perm & PTE_U) == 0) || ((perm & PTE_P) == 0) || ((perm & ~PTE_SYSCALL) != 0))
f0104c49:	8b 55 1c             	mov    0x1c(%ebp),%edx
f0104c4c:	81 e2 fd f1 ff ff    	and    $0xfffff1fd,%edx
f0104c52:	83 fa 05             	cmp    $0x5,%edx
f0104c55:	75 60                	jne    f0104cb7 <syscall+0x364>
	if(page_insert(dst->env_pgdir, page, dstva, perm) < 0)
f0104c57:	ff 75 1c             	pushl  0x1c(%ebp)
f0104c5a:	ff 75 18             	pushl  0x18(%ebp)
f0104c5d:	50                   	push   %eax
f0104c5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104c61:	ff 70 60             	pushl  0x60(%eax)
f0104c64:	e8 da c6 ff ff       	call   f0101343 <page_insert>
f0104c69:	83 c4 10             	add    $0x10,%esp
		return -E_NO_MEM;
f0104c6c:	85 c0                	test   %eax,%eax
f0104c6e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0104c73:	0f 48 d8             	cmovs  %eax,%ebx
f0104c76:	e9 2f fd ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_BAD_ENV;
f0104c7b:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104c80:	e9 25 fd ff ff       	jmp    f01049aa <syscall+0x57>
f0104c85:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104c8a:	e9 1b fd ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_INVAL;
f0104c8f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104c94:	e9 11 fd ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_INVAL;
f0104c99:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104c9e:	e9 07 fd ff ff       	jmp    f01049aa <syscall+0x57>
f0104ca3:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ca8:	e9 fd fc ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_INVAL;
f0104cad:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104cb2:	e9 f3 fc ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_INVAL;
f0104cb7:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			return sys_page_map(a1, (void *) a2, a3, (void *) a4, a5);
f0104cbc:	e9 e9 fc ff ff       	jmp    f01049aa <syscall+0x57>
	if(envid2env(envid, &e, 1) < 0)
f0104cc1:	83 ec 04             	sub    $0x4,%esp
f0104cc4:	6a 01                	push   $0x1
f0104cc6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104cc9:	50                   	push   %eax
f0104cca:	ff 75 0c             	pushl  0xc(%ebp)
f0104ccd:	e8 c0 e4 ff ff       	call   f0103192 <envid2env>
f0104cd2:	83 c4 10             	add    $0x10,%esp
f0104cd5:	85 c0                	test   %eax,%eax
f0104cd7:	78 30                	js     f0104d09 <syscall+0x3b6>
	if((uintptr_t)va >= UTOP || PGOFF(va))
f0104cd9:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104ce0:	77 31                	ja     f0104d13 <syscall+0x3c0>
f0104ce2:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104ce9:	75 32                	jne    f0104d1d <syscall+0x3ca>
	page_remove(e->env_pgdir, va);
f0104ceb:	83 ec 08             	sub    $0x8,%esp
f0104cee:	ff 75 10             	pushl  0x10(%ebp)
f0104cf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104cf4:	ff 70 60             	pushl  0x60(%eax)
f0104cf7:	e8 fd c5 ff ff       	call   f01012f9 <page_remove>
	return 0;
f0104cfc:	83 c4 10             	add    $0x10,%esp
f0104cff:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104d04:	e9 a1 fc ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_BAD_ENV;
f0104d09:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104d0e:	e9 97 fc ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_INVAL;
f0104d13:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104d18:	e9 8d fc ff ff       	jmp    f01049aa <syscall+0x57>
f0104d1d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			return sys_page_unmap(a1, (void *) a2);
f0104d22:	e9 83 fc ff ff       	jmp    f01049aa <syscall+0x57>
	if(envid2env(envid, &e, 1) < 0)
f0104d27:	83 ec 04             	sub    $0x4,%esp
f0104d2a:	6a 01                	push   $0x1
f0104d2c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104d2f:	50                   	push   %eax
f0104d30:	ff 75 0c             	pushl  0xc(%ebp)
f0104d33:	e8 5a e4 ff ff       	call   f0103192 <envid2env>
f0104d38:	83 c4 10             	add    $0x10,%esp
f0104d3b:	85 c0                	test   %eax,%eax
f0104d3d:	78 13                	js     f0104d52 <syscall+0x3ff>
	e->env_pgfault_upcall = func;
f0104d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104d42:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104d45:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f0104d48:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104d4d:	e9 58 fc ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_BAD_ENV;
f0104d52:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
			return sys_env_set_pgfault_upcall(a1, (void *) a2);
f0104d57:	e9 4e fc ff ff       	jmp    f01049aa <syscall+0x57>
	if((r = envid2env(envid, &rec_env, 0)) < 0){
f0104d5c:	83 ec 04             	sub    $0x4,%esp
f0104d5f:	6a 00                	push   $0x0
f0104d61:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104d64:	50                   	push   %eax
f0104d65:	ff 75 0c             	pushl  0xc(%ebp)
f0104d68:	e8 25 e4 ff ff       	call   f0103192 <envid2env>
f0104d6d:	89 c3                	mov    %eax,%ebx
f0104d6f:	83 c4 10             	add    $0x10,%esp
f0104d72:	85 c0                	test   %eax,%eax
f0104d74:	0f 88 30 fc ff ff    	js     f01049aa <syscall+0x57>
	if(!rec_env->env_ipc_recving){
f0104d7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104d7d:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0104d81:	0f 84 de 00 00 00    	je     f0104e65 <syscall+0x512>
	if((uintptr_t)srcva < UTOP){
f0104d87:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0104d8e:	0f 87 8c 00 00 00    	ja     f0104e20 <syscall+0x4cd>
		if((uintptr_t)srcva & (PGSIZE - 1)){
f0104d94:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f0104d9b:	0f 85 ce 00 00 00    	jne    f0104e6f <syscall+0x51c>
		if((perm & PTE_U) != PTE_U || (perm & PTE_P) != PTE_P){
f0104da1:	8b 45 18             	mov    0x18(%ebp),%eax
f0104da4:	83 e0 05             	and    $0x5,%eax
f0104da7:	83 f8 05             	cmp    $0x5,%eax
f0104daa:	0f 85 c9 00 00 00    	jne    f0104e79 <syscall+0x526>
		if(!(pg = page_lookup(curenv->env_pgdir, srcva, &pte))){
f0104db0:	e8 35 14 00 00       	call   f01061ea <cpunum>
f0104db5:	83 ec 04             	sub    $0x4,%esp
f0104db8:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104dbb:	52                   	push   %edx
f0104dbc:	ff 75 14             	pushl  0x14(%ebp)
f0104dbf:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dc2:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f0104dc8:	ff 70 60             	pushl  0x60(%eax)
f0104dcb:	e8 7d c4 ff ff       	call   f010124d <page_lookup>
f0104dd0:	83 c4 10             	add    $0x10,%esp
f0104dd3:	85 c0                	test   %eax,%eax
f0104dd5:	0f 84 a8 00 00 00    	je     f0104e83 <syscall+0x530>
		if((perm & PTE_W) && ((size_t) *pte & PTE_W) != PTE_W){
f0104ddb:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104ddf:	74 0c                	je     f0104ded <syscall+0x49a>
f0104de1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104de4:	f6 02 02             	testb  $0x2,(%edx)
f0104de7:	0f 84 a0 00 00 00    	je     f0104e8d <syscall+0x53a>
		if((uintptr_t)rec_env->env_ipc_dstva < UTOP){
f0104ded:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104df0:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0104df3:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0104df9:	77 2c                	ja     f0104e27 <syscall+0x4d4>
			if((r = page_insert(rec_env->env_pgdir, pg, rec_env->env_ipc_dstva, perm)) < 0){
f0104dfb:	ff 75 18             	pushl  0x18(%ebp)
f0104dfe:	51                   	push   %ecx
f0104dff:	50                   	push   %eax
f0104e00:	ff 72 60             	pushl  0x60(%edx)
f0104e03:	e8 3b c5 ff ff       	call   f0101343 <page_insert>
f0104e08:	89 c3                	mov    %eax,%ebx
f0104e0a:	83 c4 10             	add    $0x10,%esp
f0104e0d:	85 c0                	test   %eax,%eax
f0104e0f:	0f 88 95 fb ff ff    	js     f01049aa <syscall+0x57>
			rec_env->env_ipc_perm = perm;
f0104e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104e18:	8b 7d 18             	mov    0x18(%ebp),%edi
f0104e1b:	89 78 78             	mov    %edi,0x78(%eax)
f0104e1e:	eb 07                	jmp    f0104e27 <syscall+0x4d4>
		rec_env->env_ipc_perm = 0;
f0104e20:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
	rec_env->env_ipc_recving = 0;
f0104e27:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104e2a:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	rec_env->env_ipc_from = curenv->env_id;
f0104e2e:	e8 b7 13 00 00       	call   f01061ea <cpunum>
f0104e33:	89 c2                	mov    %eax,%edx
f0104e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104e38:	6b d2 74             	imul   $0x74,%edx,%edx
f0104e3b:	8b 92 28 20 2c f0    	mov    -0xfd3dfd8(%edx),%edx
f0104e41:	8b 52 48             	mov    0x48(%edx),%edx
f0104e44:	89 50 74             	mov    %edx,0x74(%eax)
	rec_env->env_ipc_value = value;
f0104e47:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104e4a:	89 48 70             	mov    %ecx,0x70(%eax)
	rec_env->env_status = ENV_RUNNABLE;
f0104e4d:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	rec_env->env_tf.tf_regs.reg_eax = 0;
f0104e54:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return 0;
f0104e5b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104e60:	e9 45 fb ff ff       	jmp    f01049aa <syscall+0x57>
		return -E_IPC_NOT_RECV;
f0104e65:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f0104e6a:	e9 3b fb ff ff       	jmp    f01049aa <syscall+0x57>
			return -E_INVAL;
f0104e6f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104e74:	e9 31 fb ff ff       	jmp    f01049aa <syscall+0x57>
			return -E_INVAL;
f0104e79:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104e7e:	e9 27 fb ff ff       	jmp    f01049aa <syscall+0x57>
			return -E_INVAL;
f0104e83:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104e88:	e9 1d fb ff ff       	jmp    f01049aa <syscall+0x57>
			return -E_INVAL;
f0104e8d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			return sys_ipc_try_send(a1, a2, (void *) a3, a4);
f0104e92:	e9 13 fb ff ff       	jmp    f01049aa <syscall+0x57>
	if((uintptr_t)dstva < UTOP && (uintptr_t)dstva & (PGSIZE - 1)){
f0104e97:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0104e9e:	77 13                	ja     f0104eb3 <syscall+0x560>
f0104ea0:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0104ea7:	74 0a                	je     f0104eb3 <syscall+0x560>
			return sys_ipc_recv((void *) a1);
f0104ea9:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104eae:	e9 f7 fa ff ff       	jmp    f01049aa <syscall+0x57>
	curenv->env_ipc_recving = 1;
f0104eb3:	e8 32 13 00 00       	call   f01061ea <cpunum>
f0104eb8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ebb:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f0104ec1:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f0104ec5:	e8 20 13 00 00       	call   f01061ea <cpunum>
f0104eca:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ecd:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f0104ed3:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0104ed6:	89 78 6c             	mov    %edi,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0104ed9:	e8 0c 13 00 00       	call   f01061ea <cpunum>
f0104ede:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ee1:	8b 80 28 20 2c f0    	mov    -0xfd3dfd8(%eax),%eax
f0104ee7:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0104eee:	e8 9a f9 ff ff       	call   f010488d <sched_yield>
	if ((r = envid2env(envid, &env, 1)) < 0) return r;
f0104ef3:	83 ec 04             	sub    $0x4,%esp
f0104ef6:	6a 01                	push   $0x1
f0104ef8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104efb:	50                   	push   %eax
f0104efc:	ff 75 0c             	pushl  0xc(%ebp)
f0104eff:	e8 8e e2 ff ff       	call   f0103192 <envid2env>
f0104f04:	89 c3                	mov    %eax,%ebx
f0104f06:	83 c4 10             	add    $0x10,%esp
f0104f09:	85 c0                	test   %eax,%eax
f0104f0b:	0f 88 99 fa ff ff    	js     f01049aa <syscall+0x57>
	env->env_tf = *tf;
f0104f11:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104f16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104f19:	8b 75 10             	mov    0x10(%ebp),%esi
f0104f1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	env->env_tf.tf_eflags |= FL_IF;
f0104f1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	env->env_tf.tf_eflags &= ~FL_IOPL_MASK;
f0104f21:	8b 42 38             	mov    0x38(%edx),%eax
f0104f24:	80 e4 cf             	and    $0xcf,%ah
f0104f27:	80 cc 02             	or     $0x2,%ah
f0104f2a:	89 42 38             	mov    %eax,0x38(%edx)
	env->env_tf.tf_cs = GD_UT | 3;
f0104f2d:	66 c7 42 34 1b 00    	movw   $0x1b,0x34(%edx)
	return 0;
f0104f33:	bb 00 00 00 00       	mov    $0x0,%ebx
			return sys_env_set_trapframe(a1, (struct Trapframe*)a2);
f0104f38:	e9 6d fa ff ff       	jmp    f01049aa <syscall+0x57>
	return (int)time_msec();
f0104f3d:	e8 3a 20 00 00       	call   f0106f7c <time_msec>
f0104f42:	89 c3                	mov    %eax,%ebx
			return sys_time_msec();
f0104f44:	e9 61 fa ff ff       	jmp    f01049aa <syscall+0x57>
	return e1000_transmit(data, len);
f0104f49:	83 ec 08             	sub    $0x8,%esp
f0104f4c:	ff 75 10             	pushl  0x10(%ebp)
f0104f4f:	ff 75 0c             	pushl  0xc(%ebp)
f0104f52:	e8 7e 19 00 00       	call   f01068d5 <e1000_transmit>
f0104f57:	89 c3                	mov    %eax,%ebx
			return sys_pkt_send((void *)a1, (size_t)a2);
f0104f59:	83 c4 10             	add    $0x10,%esp
f0104f5c:	e9 49 fa ff ff       	jmp    f01049aa <syscall+0x57>
	return e1000_receive(addr, len);
f0104f61:	83 ec 08             	sub    $0x8,%esp
f0104f64:	ff 75 10             	pushl  0x10(%ebp)
f0104f67:	ff 75 0c             	pushl  0xc(%ebp)
f0104f6a:	e8 e5 19 00 00       	call   f0106954 <e1000_receive>
f0104f6f:	89 c3                	mov    %eax,%ebx
			return sys_pkt_recv((void *)a1, (size_t *)a2);
f0104f71:	83 c4 10             	add    $0x10,%esp
f0104f74:	e9 31 fa ff ff       	jmp    f01049aa <syscall+0x57>
			return 0;
f0104f79:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104f7e:	e9 27 fa ff ff       	jmp    f01049aa <syscall+0x57>

f0104f83 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0104f83:	55                   	push   %ebp
f0104f84:	89 e5                	mov    %esp,%ebp
f0104f86:	57                   	push   %edi
f0104f87:	56                   	push   %esi
f0104f88:	53                   	push   %ebx
f0104f89:	83 ec 14             	sub    $0x14,%esp
f0104f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104f8f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104f92:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104f95:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104f98:	8b 1a                	mov    (%edx),%ebx
f0104f9a:	8b 01                	mov    (%ecx),%eax
f0104f9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104f9f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104fa6:	eb 23                	jmp    f0104fcb <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0104fa8:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0104fab:	eb 1e                	jmp    f0104fcb <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104fad:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104fb0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104fb3:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104fb7:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104fba:	73 46                	jae    f0105002 <stab_binsearch+0x7f>
			*region_left = m;
f0104fbc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104fbf:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0104fc1:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0104fc4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104fcb:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0104fce:	7f 5f                	jg     f010502f <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f0104fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104fd3:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0104fd6:	89 d0                	mov    %edx,%eax
f0104fd8:	c1 e8 1f             	shr    $0x1f,%eax
f0104fdb:	01 d0                	add    %edx,%eax
f0104fdd:	89 c7                	mov    %eax,%edi
f0104fdf:	d1 ff                	sar    %edi
f0104fe1:	83 e0 fe             	and    $0xfffffffe,%eax
f0104fe4:	01 f8                	add    %edi,%eax
f0104fe6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104fe9:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104fed:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0104fef:	39 c3                	cmp    %eax,%ebx
f0104ff1:	7f b5                	jg     f0104fa8 <stab_binsearch+0x25>
f0104ff3:	0f b6 0a             	movzbl (%edx),%ecx
f0104ff6:	83 ea 0c             	sub    $0xc,%edx
f0104ff9:	39 f1                	cmp    %esi,%ecx
f0104ffb:	74 b0                	je     f0104fad <stab_binsearch+0x2a>
			m--;
f0104ffd:	83 e8 01             	sub    $0x1,%eax
f0105000:	eb ed                	jmp    f0104fef <stab_binsearch+0x6c>
		} else if (stabs[m].n_value > addr) {
f0105002:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105005:	76 14                	jbe    f010501b <stab_binsearch+0x98>
			*region_right = m - 1;
f0105007:	83 e8 01             	sub    $0x1,%eax
f010500a:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010500d:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105010:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0105012:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105019:	eb b0                	jmp    f0104fcb <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f010501b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010501e:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0105020:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0105024:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0105026:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f010502d:	eb 9c                	jmp    f0104fcb <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f010502f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105033:	75 15                	jne    f010504a <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0105035:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105038:	8b 00                	mov    (%eax),%eax
f010503a:	83 e8 01             	sub    $0x1,%eax
f010503d:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105040:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105042:	83 c4 14             	add    $0x14,%esp
f0105045:	5b                   	pop    %ebx
f0105046:	5e                   	pop    %esi
f0105047:	5f                   	pop    %edi
f0105048:	5d                   	pop    %ebp
f0105049:	c3                   	ret    
		for (l = *region_right;
f010504a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010504d:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f010504f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105052:	8b 0f                	mov    (%edi),%ecx
f0105054:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105057:	8b 7d ec             	mov    -0x14(%ebp),%edi
f010505a:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f010505e:	eb 03                	jmp    f0105063 <stab_binsearch+0xe0>
		     l--)
f0105060:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0105063:	39 c1                	cmp    %eax,%ecx
f0105065:	7d 0a                	jge    f0105071 <stab_binsearch+0xee>
		     l > *region_left && stabs[l].n_type != type;
f0105067:	0f b6 1a             	movzbl (%edx),%ebx
f010506a:	83 ea 0c             	sub    $0xc,%edx
f010506d:	39 f3                	cmp    %esi,%ebx
f010506f:	75 ef                	jne    f0105060 <stab_binsearch+0xdd>
		*region_left = l;
f0105071:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105074:	89 07                	mov    %eax,(%edi)
}
f0105076:	eb ca                	jmp    f0105042 <stab_binsearch+0xbf>

f0105078 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105078:	f3 0f 1e fb          	endbr32 
f010507c:	55                   	push   %ebp
f010507d:	89 e5                	mov    %esp,%ebp
f010507f:	57                   	push   %edi
f0105080:	56                   	push   %esi
f0105081:	53                   	push   %ebx
f0105082:	83 ec 4c             	sub    $0x4c,%esp
f0105085:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105088:	c7 03 64 8a 10 f0    	movl   $0xf0108a64,(%ebx)
	info->eip_line = 0;
f010508e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105095:	c7 43 08 64 8a 10 f0 	movl   $0xf0108a64,0x8(%ebx)
	info->eip_fn_namelen = 9;
f010509c:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f01050a3:	8b 45 08             	mov    0x8(%ebp),%eax
f01050a6:	89 43 10             	mov    %eax,0x10(%ebx)
	info->eip_fn_narg = 0;
f01050a9:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f01050b0:	3d ff ff 7f ef       	cmp    $0xef7fffff,%eax
f01050b5:	0f 86 10 01 00 00    	jbe    f01051cb <debuginfo_eip+0x153>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f01050bb:	c7 45 bc 14 be 11 f0 	movl   $0xf011be14,-0x44(%ebp)
		stabstr = __STABSTR_BEGIN__;
f01050c2:	c7 45 b4 6d 77 11 f0 	movl   $0xf011776d,-0x4c(%ebp)
		stab_end = __STAB_END__;
f01050c9:	bf 6c 77 11 f0       	mov    $0xf011776c,%edi
		stabs = __STAB_BEGIN__;
f01050ce:	c7 45 b8 b8 92 10 f0 	movl   $0xf01092b8,-0x48(%ebp)
                               (uintptr_t)stabstr_end - (uintptr_t)stabstr, PTE_U) < 0))
        	return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01050d5:	8b 75 bc             	mov    -0x44(%ebp),%esi
f01050d8:	39 75 b4             	cmp    %esi,-0x4c(%ebp)
f01050db:	0f 83 76 02 00 00    	jae    f0105357 <debuginfo_eip+0x2df>
f01050e1:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
f01050e5:	0f 85 73 02 00 00    	jne    f010535e <debuginfo_eip+0x2e6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01050eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01050f2:	8b 75 b8             	mov    -0x48(%ebp),%esi
f01050f5:	29 f7                	sub    %esi,%edi
f01050f7:	c1 ff 02             	sar    $0x2,%edi
f01050fa:	69 c7 ab aa aa aa    	imul   $0xaaaaaaab,%edi,%eax
f0105100:	83 e8 01             	sub    $0x1,%eax
f0105103:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0105106:	83 ec 08             	sub    $0x8,%esp
f0105109:	ff 75 08             	pushl  0x8(%ebp)
f010510c:	6a 64                	push   $0x64
f010510e:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0105111:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105114:	89 f0                	mov    %esi,%eax
f0105116:	e8 68 fe ff ff       	call   f0104f83 <stab_binsearch>
	if (lfile == 0)
f010511b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010511e:	83 c4 10             	add    $0x10,%esp
f0105121:	85 c0                	test   %eax,%eax
f0105123:	0f 84 3c 02 00 00    	je     f0105365 <debuginfo_eip+0x2ed>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105129:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f010512c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010512f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105132:	83 ec 08             	sub    $0x8,%esp
f0105135:	ff 75 08             	pushl  0x8(%ebp)
f0105138:	6a 24                	push   $0x24
f010513a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f010513d:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105140:	89 f0                	mov    %esi,%eax
f0105142:	e8 3c fe ff ff       	call   f0104f83 <stab_binsearch>

	if (lfun <= rfun) {
f0105147:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010514a:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010514d:	83 c4 10             	add    $0x10,%esp
f0105150:	39 d0                	cmp    %edx,%eax
f0105152:	0f 8f 44 01 00 00    	jg     f010529c <debuginfo_eip+0x224>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105158:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f010515b:	8d 3c 8e             	lea    (%esi,%ecx,4),%edi
f010515e:	8b 0f                	mov    (%edi),%ecx
f0105160:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105163:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f0105166:	39 f1                	cmp    %esi,%ecx
f0105168:	73 06                	jae    f0105170 <debuginfo_eip+0xf8>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f010516a:	03 4d b4             	add    -0x4c(%ebp),%ecx
f010516d:	89 4b 08             	mov    %ecx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105170:	8b 4f 08             	mov    0x8(%edi),%ecx
f0105173:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105176:	29 4d 08             	sub    %ecx,0x8(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
f0105179:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f010517c:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f010517f:	83 ec 08             	sub    $0x8,%esp
f0105182:	6a 3a                	push   $0x3a
f0105184:	ff 73 08             	pushl  0x8(%ebx)
f0105187:	e8 1d 0a 00 00       	call   f0105ba9 <strfind>
f010518c:	2b 43 08             	sub    0x8(%ebx),%eax
f010518f:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105192:	83 c4 08             	add    $0x8,%esp
f0105195:	ff 75 08             	pushl  0x8(%ebp)
f0105198:	6a 44                	push   $0x44
f010519a:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f010519d:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f01051a0:	8b 75 b8             	mov    -0x48(%ebp),%esi
f01051a3:	89 f0                	mov    %esi,%eax
f01051a5:	e8 d9 fd ff ff       	call   f0104f83 <stab_binsearch>
	info->eip_line = stabs[lline].n_desc;
f01051aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01051ad:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01051b0:	0f b7 4c 96 06       	movzwl 0x6(%esi,%edx,4),%ecx
f01051b5:	89 4b 04             	mov    %ecx,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f01051b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01051bb:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f01051bf:	83 c4 10             	add    $0x10,%esp
f01051c2:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f01051c6:	e9 f2 00 00 00       	jmp    f01052bd <debuginfo_eip+0x245>
		if(curenv && user_mem_check(curenv, (void*)usd, sizeof(struct UserStabData), PTE_U) < 0){
f01051cb:	e8 1a 10 00 00       	call   f01061ea <cpunum>
f01051d0:	6b c0 74             	imul   $0x74,%eax,%eax
f01051d3:	83 b8 28 20 2c f0 00 	cmpl   $0x0,-0xfd3dfd8(%eax)
f01051da:	74 27                	je     f0105203 <debuginfo_eip+0x18b>
f01051dc:	e8 09 10 00 00       	call   f01061ea <cpunum>
f01051e1:	6a 04                	push   $0x4
f01051e3:	6a 10                	push   $0x10
f01051e5:	68 00 00 20 00       	push   $0x200000
f01051ea:	6b c0 74             	imul   $0x74,%eax,%eax
f01051ed:	ff b0 28 20 2c f0    	pushl  -0xfd3dfd8(%eax)
f01051f3:	e8 3f de ff ff       	call   f0103037 <user_mem_check>
f01051f8:	83 c4 10             	add    $0x10,%esp
f01051fb:	85 c0                	test   %eax,%eax
f01051fd:	0f 88 46 01 00 00    	js     f0105349 <debuginfo_eip+0x2d1>
		stabs = usd->stabs;
f0105203:	8b 35 00 00 20 00    	mov    0x200000,%esi
f0105209:	89 75 b8             	mov    %esi,-0x48(%ebp)
		stab_end = usd->stab_end;
f010520c:	8b 3d 04 00 20 00    	mov    0x200004,%edi
		stabstr = usd->stabstr;
f0105212:	a1 08 00 20 00       	mov    0x200008,%eax
f0105217:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f010521a:	8b 0d 0c 00 20 00    	mov    0x20000c,%ecx
f0105220:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		if (curenv && (
f0105223:	e8 c2 0f 00 00       	call   f01061ea <cpunum>
f0105228:	6b c0 74             	imul   $0x74,%eax,%eax
f010522b:	83 b8 28 20 2c f0 00 	cmpl   $0x0,-0xfd3dfd8(%eax)
f0105232:	0f 84 9d fe ff ff    	je     f01050d5 <debuginfo_eip+0x5d>
                user_mem_check(curenv, (void*)stabs, 
f0105238:	89 fa                	mov    %edi,%edx
f010523a:	29 f2                	sub    %esi,%edx
f010523c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f010523f:	e8 a6 0f 00 00       	call   f01061ea <cpunum>
f0105244:	6a 04                	push   $0x4
f0105246:	ff 75 c4             	pushl  -0x3c(%ebp)
f0105249:	56                   	push   %esi
f010524a:	6b c0 74             	imul   $0x74,%eax,%eax
f010524d:	ff b0 28 20 2c f0    	pushl  -0xfd3dfd8(%eax)
f0105253:	e8 df dd ff ff       	call   f0103037 <user_mem_check>
		if (curenv && (
f0105258:	83 c4 10             	add    $0x10,%esp
f010525b:	85 c0                	test   %eax,%eax
f010525d:	0f 88 ed 00 00 00    	js     f0105350 <debuginfo_eip+0x2d8>
                user_mem_check(curenv, (void*)stabstr, 
f0105263:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105266:	8b 75 b4             	mov    -0x4c(%ebp),%esi
f0105269:	29 f1                	sub    %esi,%ecx
f010526b:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f010526e:	e8 77 0f 00 00       	call   f01061ea <cpunum>
f0105273:	6a 04                	push   $0x4
f0105275:	ff 75 c4             	pushl  -0x3c(%ebp)
f0105278:	56                   	push   %esi
f0105279:	6b c0 74             	imul   $0x74,%eax,%eax
f010527c:	ff b0 28 20 2c f0    	pushl  -0xfd3dfd8(%eax)
f0105282:	e8 b0 dd ff ff       	call   f0103037 <user_mem_check>
                               (uintptr_t)stab_end - (uintptr_t)stabs, PTE_U) < 0 || 
f0105287:	83 c4 10             	add    $0x10,%esp
f010528a:	85 c0                	test   %eax,%eax
f010528c:	0f 89 43 fe ff ff    	jns    f01050d5 <debuginfo_eip+0x5d>
        	return -1;
f0105292:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105297:	e9 d5 00 00 00       	jmp    f0105371 <debuginfo_eip+0x2f9>
		info->eip_fn_addr = addr;
f010529c:	8b 45 08             	mov    0x8(%ebp),%eax
f010529f:	89 43 10             	mov    %eax,0x10(%ebx)
		lline = lfile;
f01052a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01052a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f01052a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01052ab:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01052ae:	e9 cc fe ff ff       	jmp    f010517f <debuginfo_eip+0x107>
f01052b3:	83 e8 01             	sub    $0x1,%eax
f01052b6:	83 ea 0c             	sub    $0xc,%edx
	while (lline >= lfile
f01052b9:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f01052bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01052c0:	39 c7                	cmp    %eax,%edi
f01052c2:	7f 45                	jg     f0105309 <debuginfo_eip+0x291>
	       && stabs[lline].n_type != N_SOL
f01052c4:	0f b6 0a             	movzbl (%edx),%ecx
f01052c7:	80 f9 84             	cmp    $0x84,%cl
f01052ca:	74 19                	je     f01052e5 <debuginfo_eip+0x26d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01052cc:	80 f9 64             	cmp    $0x64,%cl
f01052cf:	75 e2                	jne    f01052b3 <debuginfo_eip+0x23b>
f01052d1:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f01052d5:	74 dc                	je     f01052b3 <debuginfo_eip+0x23b>
f01052d7:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01052db:	74 11                	je     f01052ee <debuginfo_eip+0x276>
f01052dd:	8b 7d c0             	mov    -0x40(%ebp),%edi
f01052e0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01052e3:	eb 09                	jmp    f01052ee <debuginfo_eip+0x276>
f01052e5:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01052e9:	74 03                	je     f01052ee <debuginfo_eip+0x276>
f01052eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01052ee:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01052f1:	8b 7d b8             	mov    -0x48(%ebp),%edi
f01052f4:	8b 14 87             	mov    (%edi,%eax,4),%edx
f01052f7:	8b 45 bc             	mov    -0x44(%ebp),%eax
f01052fa:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f01052fd:	29 f8                	sub    %edi,%eax
f01052ff:	39 c2                	cmp    %eax,%edx
f0105301:	73 06                	jae    f0105309 <debuginfo_eip+0x291>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105303:	89 f8                	mov    %edi,%eax
f0105305:	01 d0                	add    %edx,%eax
f0105307:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105309:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010530c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f010530f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (lfun < rfun)
f0105314:	39 f0                	cmp    %esi,%eax
f0105316:	7d 59                	jge    f0105371 <debuginfo_eip+0x2f9>
		for (lline = lfun + 1;
f0105318:	8d 50 01             	lea    0x1(%eax),%edx
f010531b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f010531e:	89 d0                	mov    %edx,%eax
f0105320:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105323:	8b 7d b8             	mov    -0x48(%ebp),%edi
f0105326:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f010532a:	eb 04                	jmp    f0105330 <debuginfo_eip+0x2b8>
			info->eip_fn_narg++;
f010532c:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0105330:	39 c6                	cmp    %eax,%esi
f0105332:	7e 38                	jle    f010536c <debuginfo_eip+0x2f4>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105334:	0f b6 0a             	movzbl (%edx),%ecx
f0105337:	83 c0 01             	add    $0x1,%eax
f010533a:	83 c2 0c             	add    $0xc,%edx
f010533d:	80 f9 a0             	cmp    $0xa0,%cl
f0105340:	74 ea                	je     f010532c <debuginfo_eip+0x2b4>
	return 0;
f0105342:	ba 00 00 00 00       	mov    $0x0,%edx
f0105347:	eb 28                	jmp    f0105371 <debuginfo_eip+0x2f9>
			return -1;
f0105349:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f010534e:	eb 21                	jmp    f0105371 <debuginfo_eip+0x2f9>
        	return -1;
f0105350:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105355:	eb 1a                	jmp    f0105371 <debuginfo_eip+0x2f9>
		return -1;
f0105357:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f010535c:	eb 13                	jmp    f0105371 <debuginfo_eip+0x2f9>
f010535e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105363:	eb 0c                	jmp    f0105371 <debuginfo_eip+0x2f9>
		return -1;
f0105365:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f010536a:	eb 05                	jmp    f0105371 <debuginfo_eip+0x2f9>
	return 0;
f010536c:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0105371:	89 d0                	mov    %edx,%eax
f0105373:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105376:	5b                   	pop    %ebx
f0105377:	5e                   	pop    %esi
f0105378:	5f                   	pop    %edi
f0105379:	5d                   	pop    %ebp
f010537a:	c3                   	ret    

f010537b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f010537b:	55                   	push   %ebp
f010537c:	89 e5                	mov    %esp,%ebp
f010537e:	57                   	push   %edi
f010537f:	56                   	push   %esi
f0105380:	53                   	push   %ebx
f0105381:	83 ec 1c             	sub    $0x1c,%esp
f0105384:	89 c7                	mov    %eax,%edi
f0105386:	89 d6                	mov    %edx,%esi
f0105388:	8b 45 08             	mov    0x8(%ebp),%eax
f010538b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010538e:	89 d1                	mov    %edx,%ecx
f0105390:	89 c2                	mov    %eax,%edx
f0105392:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105395:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105398:	8b 45 10             	mov    0x10(%ebp),%eax
f010539b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f010539e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01053a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01053a8:	39 c2                	cmp    %eax,%edx
f01053aa:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f01053ad:	72 3e                	jb     f01053ed <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f01053af:	83 ec 0c             	sub    $0xc,%esp
f01053b2:	ff 75 18             	pushl  0x18(%ebp)
f01053b5:	83 eb 01             	sub    $0x1,%ebx
f01053b8:	53                   	push   %ebx
f01053b9:	50                   	push   %eax
f01053ba:	83 ec 08             	sub    $0x8,%esp
f01053bd:	ff 75 e4             	pushl  -0x1c(%ebp)
f01053c0:	ff 75 e0             	pushl  -0x20(%ebp)
f01053c3:	ff 75 dc             	pushl  -0x24(%ebp)
f01053c6:	ff 75 d8             	pushl  -0x28(%ebp)
f01053c9:	e8 c2 1b 00 00       	call   f0106f90 <__udivdi3>
f01053ce:	83 c4 18             	add    $0x18,%esp
f01053d1:	52                   	push   %edx
f01053d2:	50                   	push   %eax
f01053d3:	89 f2                	mov    %esi,%edx
f01053d5:	89 f8                	mov    %edi,%eax
f01053d7:	e8 9f ff ff ff       	call   f010537b <printnum>
f01053dc:	83 c4 20             	add    $0x20,%esp
f01053df:	eb 13                	jmp    f01053f4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01053e1:	83 ec 08             	sub    $0x8,%esp
f01053e4:	56                   	push   %esi
f01053e5:	ff 75 18             	pushl  0x18(%ebp)
f01053e8:	ff d7                	call   *%edi
f01053ea:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f01053ed:	83 eb 01             	sub    $0x1,%ebx
f01053f0:	85 db                	test   %ebx,%ebx
f01053f2:	7f ed                	jg     f01053e1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01053f4:	83 ec 08             	sub    $0x8,%esp
f01053f7:	56                   	push   %esi
f01053f8:	83 ec 04             	sub    $0x4,%esp
f01053fb:	ff 75 e4             	pushl  -0x1c(%ebp)
f01053fe:	ff 75 e0             	pushl  -0x20(%ebp)
f0105401:	ff 75 dc             	pushl  -0x24(%ebp)
f0105404:	ff 75 d8             	pushl  -0x28(%ebp)
f0105407:	e8 94 1c 00 00       	call   f01070a0 <__umoddi3>
f010540c:	83 c4 14             	add    $0x14,%esp
f010540f:	0f be 80 6e 8a 10 f0 	movsbl -0xfef7592(%eax),%eax
f0105416:	50                   	push   %eax
f0105417:	ff d7                	call   *%edi
}
f0105419:	83 c4 10             	add    $0x10,%esp
f010541c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010541f:	5b                   	pop    %ebx
f0105420:	5e                   	pop    %esi
f0105421:	5f                   	pop    %edi
f0105422:	5d                   	pop    %ebp
f0105423:	c3                   	ret    

f0105424 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105424:	f3 0f 1e fb          	endbr32 
f0105428:	55                   	push   %ebp
f0105429:	89 e5                	mov    %esp,%ebp
f010542b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f010542e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105432:	8b 10                	mov    (%eax),%edx
f0105434:	3b 50 04             	cmp    0x4(%eax),%edx
f0105437:	73 0a                	jae    f0105443 <sprintputch+0x1f>
		*b->buf++ = ch;
f0105439:	8d 4a 01             	lea    0x1(%edx),%ecx
f010543c:	89 08                	mov    %ecx,(%eax)
f010543e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105441:	88 02                	mov    %al,(%edx)
}
f0105443:	5d                   	pop    %ebp
f0105444:	c3                   	ret    

f0105445 <printfmt>:
{
f0105445:	f3 0f 1e fb          	endbr32 
f0105449:	55                   	push   %ebp
f010544a:	89 e5                	mov    %esp,%ebp
f010544c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f010544f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105452:	50                   	push   %eax
f0105453:	ff 75 10             	pushl  0x10(%ebp)
f0105456:	ff 75 0c             	pushl  0xc(%ebp)
f0105459:	ff 75 08             	pushl  0x8(%ebp)
f010545c:	e8 05 00 00 00       	call   f0105466 <vprintfmt>
}
f0105461:	83 c4 10             	add    $0x10,%esp
f0105464:	c9                   	leave  
f0105465:	c3                   	ret    

f0105466 <vprintfmt>:
{
f0105466:	f3 0f 1e fb          	endbr32 
f010546a:	55                   	push   %ebp
f010546b:	89 e5                	mov    %esp,%ebp
f010546d:	57                   	push   %edi
f010546e:	56                   	push   %esi
f010546f:	53                   	push   %ebx
f0105470:	83 ec 3c             	sub    $0x3c,%esp
f0105473:	8b 75 08             	mov    0x8(%ebp),%esi
f0105476:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105479:	8b 7d 10             	mov    0x10(%ebp),%edi
f010547c:	e9 8e 03 00 00       	jmp    f010580f <vprintfmt+0x3a9>
		padc = ' ';
f0105481:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
f0105485:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
f010548c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105493:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f010549a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f010549f:	8d 47 01             	lea    0x1(%edi),%eax
f01054a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01054a5:	0f b6 17             	movzbl (%edi),%edx
f01054a8:	8d 42 dd             	lea    -0x23(%edx),%eax
f01054ab:	3c 55                	cmp    $0x55,%al
f01054ad:	0f 87 df 03 00 00    	ja     f0105892 <vprintfmt+0x42c>
f01054b3:	0f b6 c0             	movzbl %al,%eax
f01054b6:	3e ff 24 85 c0 8b 10 	notrack jmp *-0xfef7440(,%eax,4)
f01054bd:	f0 
f01054be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f01054c1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f01054c5:	eb d8                	jmp    f010549f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f01054c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01054ca:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f01054ce:	eb cf                	jmp    f010549f <vprintfmt+0x39>
f01054d0:	0f b6 d2             	movzbl %dl,%edx
f01054d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f01054d6:	b8 00 00 00 00       	mov    $0x0,%eax
f01054db:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f01054de:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01054e1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01054e5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f01054e8:	8d 4a d0             	lea    -0x30(%edx),%ecx
f01054eb:	83 f9 09             	cmp    $0x9,%ecx
f01054ee:	77 55                	ja     f0105545 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
f01054f0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f01054f3:	eb e9                	jmp    f01054de <vprintfmt+0x78>
			precision = va_arg(ap, int);
f01054f5:	8b 45 14             	mov    0x14(%ebp),%eax
f01054f8:	8b 00                	mov    (%eax),%eax
f01054fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01054fd:	8b 45 14             	mov    0x14(%ebp),%eax
f0105500:	8d 40 04             	lea    0x4(%eax),%eax
f0105503:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105506:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105509:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010550d:	79 90                	jns    f010549f <vprintfmt+0x39>
				width = precision, precision = -1;
f010550f:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105512:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105515:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f010551c:	eb 81                	jmp    f010549f <vprintfmt+0x39>
f010551e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105521:	85 c0                	test   %eax,%eax
f0105523:	ba 00 00 00 00       	mov    $0x0,%edx
f0105528:	0f 49 d0             	cmovns %eax,%edx
f010552b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010552e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105531:	e9 69 ff ff ff       	jmp    f010549f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f0105536:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105539:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
f0105540:	e9 5a ff ff ff       	jmp    f010549f <vprintfmt+0x39>
f0105545:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105548:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010554b:	eb bc                	jmp    f0105509 <vprintfmt+0xa3>
			lflag++;
f010554d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105550:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105553:	e9 47 ff ff ff       	jmp    f010549f <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
f0105558:	8b 45 14             	mov    0x14(%ebp),%eax
f010555b:	8d 78 04             	lea    0x4(%eax),%edi
f010555e:	83 ec 08             	sub    $0x8,%esp
f0105561:	53                   	push   %ebx
f0105562:	ff 30                	pushl  (%eax)
f0105564:	ff d6                	call   *%esi
			break;
f0105566:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0105569:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f010556c:	e9 9b 02 00 00       	jmp    f010580c <vprintfmt+0x3a6>
			err = va_arg(ap, int);
f0105571:	8b 45 14             	mov    0x14(%ebp),%eax
f0105574:	8d 78 04             	lea    0x4(%eax),%edi
f0105577:	8b 00                	mov    (%eax),%eax
f0105579:	99                   	cltd   
f010557a:	31 d0                	xor    %edx,%eax
f010557c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010557e:	83 f8 0f             	cmp    $0xf,%eax
f0105581:	7f 23                	jg     f01055a6 <vprintfmt+0x140>
f0105583:	8b 14 85 20 8d 10 f0 	mov    -0xfef72e0(,%eax,4),%edx
f010558a:	85 d2                	test   %edx,%edx
f010558c:	74 18                	je     f01055a6 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
f010558e:	52                   	push   %edx
f010558f:	68 ee 77 10 f0       	push   $0xf01077ee
f0105594:	53                   	push   %ebx
f0105595:	56                   	push   %esi
f0105596:	e8 aa fe ff ff       	call   f0105445 <printfmt>
f010559b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010559e:	89 7d 14             	mov    %edi,0x14(%ebp)
f01055a1:	e9 66 02 00 00       	jmp    f010580c <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
f01055a6:	50                   	push   %eax
f01055a7:	68 86 8a 10 f0       	push   $0xf0108a86
f01055ac:	53                   	push   %ebx
f01055ad:	56                   	push   %esi
f01055ae:	e8 92 fe ff ff       	call   f0105445 <printfmt>
f01055b3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01055b6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f01055b9:	e9 4e 02 00 00       	jmp    f010580c <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
f01055be:	8b 45 14             	mov    0x14(%ebp),%eax
f01055c1:	83 c0 04             	add    $0x4,%eax
f01055c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01055c7:	8b 45 14             	mov    0x14(%ebp),%eax
f01055ca:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f01055cc:	85 d2                	test   %edx,%edx
f01055ce:	b8 7f 8a 10 f0       	mov    $0xf0108a7f,%eax
f01055d3:	0f 45 c2             	cmovne %edx,%eax
f01055d6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f01055d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01055dd:	7e 06                	jle    f01055e5 <vprintfmt+0x17f>
f01055df:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f01055e3:	75 0d                	jne    f01055f2 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
f01055e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01055e8:	89 c7                	mov    %eax,%edi
f01055ea:	03 45 e0             	add    -0x20(%ebp),%eax
f01055ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01055f0:	eb 55                	jmp    f0105647 <vprintfmt+0x1e1>
f01055f2:	83 ec 08             	sub    $0x8,%esp
f01055f5:	ff 75 d8             	pushl  -0x28(%ebp)
f01055f8:	ff 75 cc             	pushl  -0x34(%ebp)
f01055fb:	e8 38 04 00 00       	call   f0105a38 <strnlen>
f0105600:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105603:	29 c2                	sub    %eax,%edx
f0105605:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0105608:	83 c4 10             	add    $0x10,%esp
f010560b:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
f010560d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0105611:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105614:	85 ff                	test   %edi,%edi
f0105616:	7e 11                	jle    f0105629 <vprintfmt+0x1c3>
					putch(padc, putdat);
f0105618:	83 ec 08             	sub    $0x8,%esp
f010561b:	53                   	push   %ebx
f010561c:	ff 75 e0             	pushl  -0x20(%ebp)
f010561f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105621:	83 ef 01             	sub    $0x1,%edi
f0105624:	83 c4 10             	add    $0x10,%esp
f0105627:	eb eb                	jmp    f0105614 <vprintfmt+0x1ae>
f0105629:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010562c:	85 d2                	test   %edx,%edx
f010562e:	b8 00 00 00 00       	mov    $0x0,%eax
f0105633:	0f 49 c2             	cmovns %edx,%eax
f0105636:	29 c2                	sub    %eax,%edx
f0105638:	89 55 e0             	mov    %edx,-0x20(%ebp)
f010563b:	eb a8                	jmp    f01055e5 <vprintfmt+0x17f>
					putch(ch, putdat);
f010563d:	83 ec 08             	sub    $0x8,%esp
f0105640:	53                   	push   %ebx
f0105641:	52                   	push   %edx
f0105642:	ff d6                	call   *%esi
f0105644:	83 c4 10             	add    $0x10,%esp
f0105647:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010564a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010564c:	83 c7 01             	add    $0x1,%edi
f010564f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105653:	0f be d0             	movsbl %al,%edx
f0105656:	85 d2                	test   %edx,%edx
f0105658:	74 4b                	je     f01056a5 <vprintfmt+0x23f>
f010565a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f010565e:	78 06                	js     f0105666 <vprintfmt+0x200>
f0105660:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105664:	78 1e                	js     f0105684 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
f0105666:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f010566a:	74 d1                	je     f010563d <vprintfmt+0x1d7>
f010566c:	0f be c0             	movsbl %al,%eax
f010566f:	83 e8 20             	sub    $0x20,%eax
f0105672:	83 f8 5e             	cmp    $0x5e,%eax
f0105675:	76 c6                	jbe    f010563d <vprintfmt+0x1d7>
					putch('?', putdat);
f0105677:	83 ec 08             	sub    $0x8,%esp
f010567a:	53                   	push   %ebx
f010567b:	6a 3f                	push   $0x3f
f010567d:	ff d6                	call   *%esi
f010567f:	83 c4 10             	add    $0x10,%esp
f0105682:	eb c3                	jmp    f0105647 <vprintfmt+0x1e1>
f0105684:	89 cf                	mov    %ecx,%edi
f0105686:	eb 0e                	jmp    f0105696 <vprintfmt+0x230>
				putch(' ', putdat);
f0105688:	83 ec 08             	sub    $0x8,%esp
f010568b:	53                   	push   %ebx
f010568c:	6a 20                	push   $0x20
f010568e:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105690:	83 ef 01             	sub    $0x1,%edi
f0105693:	83 c4 10             	add    $0x10,%esp
f0105696:	85 ff                	test   %edi,%edi
f0105698:	7f ee                	jg     f0105688 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
f010569a:	8b 45 c8             	mov    -0x38(%ebp),%eax
f010569d:	89 45 14             	mov    %eax,0x14(%ebp)
f01056a0:	e9 67 01 00 00       	jmp    f010580c <vprintfmt+0x3a6>
f01056a5:	89 cf                	mov    %ecx,%edi
f01056a7:	eb ed                	jmp    f0105696 <vprintfmt+0x230>
	if (lflag >= 2)
f01056a9:	83 f9 01             	cmp    $0x1,%ecx
f01056ac:	7f 1b                	jg     f01056c9 <vprintfmt+0x263>
	else if (lflag)
f01056ae:	85 c9                	test   %ecx,%ecx
f01056b0:	74 63                	je     f0105715 <vprintfmt+0x2af>
		return va_arg(*ap, long);
f01056b2:	8b 45 14             	mov    0x14(%ebp),%eax
f01056b5:	8b 00                	mov    (%eax),%eax
f01056b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01056ba:	99                   	cltd   
f01056bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01056be:	8b 45 14             	mov    0x14(%ebp),%eax
f01056c1:	8d 40 04             	lea    0x4(%eax),%eax
f01056c4:	89 45 14             	mov    %eax,0x14(%ebp)
f01056c7:	eb 17                	jmp    f01056e0 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
f01056c9:	8b 45 14             	mov    0x14(%ebp),%eax
f01056cc:	8b 50 04             	mov    0x4(%eax),%edx
f01056cf:	8b 00                	mov    (%eax),%eax
f01056d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01056d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01056d7:	8b 45 14             	mov    0x14(%ebp),%eax
f01056da:	8d 40 08             	lea    0x8(%eax),%eax
f01056dd:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01056e0:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01056e3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f01056e6:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f01056eb:	85 c9                	test   %ecx,%ecx
f01056ed:	0f 89 ff 00 00 00    	jns    f01057f2 <vprintfmt+0x38c>
				putch('-', putdat);
f01056f3:	83 ec 08             	sub    $0x8,%esp
f01056f6:	53                   	push   %ebx
f01056f7:	6a 2d                	push   $0x2d
f01056f9:	ff d6                	call   *%esi
				num = -(long long) num;
f01056fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01056fe:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105701:	f7 da                	neg    %edx
f0105703:	83 d1 00             	adc    $0x0,%ecx
f0105706:	f7 d9                	neg    %ecx
f0105708:	83 c4 10             	add    $0x10,%esp
			base = 10;
f010570b:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105710:	e9 dd 00 00 00       	jmp    f01057f2 <vprintfmt+0x38c>
		return va_arg(*ap, int);
f0105715:	8b 45 14             	mov    0x14(%ebp),%eax
f0105718:	8b 00                	mov    (%eax),%eax
f010571a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010571d:	99                   	cltd   
f010571e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105721:	8b 45 14             	mov    0x14(%ebp),%eax
f0105724:	8d 40 04             	lea    0x4(%eax),%eax
f0105727:	89 45 14             	mov    %eax,0x14(%ebp)
f010572a:	eb b4                	jmp    f01056e0 <vprintfmt+0x27a>
	if (lflag >= 2)
f010572c:	83 f9 01             	cmp    $0x1,%ecx
f010572f:	7f 1e                	jg     f010574f <vprintfmt+0x2e9>
	else if (lflag)
f0105731:	85 c9                	test   %ecx,%ecx
f0105733:	74 32                	je     f0105767 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
f0105735:	8b 45 14             	mov    0x14(%ebp),%eax
f0105738:	8b 10                	mov    (%eax),%edx
f010573a:	b9 00 00 00 00       	mov    $0x0,%ecx
f010573f:	8d 40 04             	lea    0x4(%eax),%eax
f0105742:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105745:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
f010574a:	e9 a3 00 00 00       	jmp    f01057f2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f010574f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105752:	8b 10                	mov    (%eax),%edx
f0105754:	8b 48 04             	mov    0x4(%eax),%ecx
f0105757:	8d 40 08             	lea    0x8(%eax),%eax
f010575a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010575d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
f0105762:	e9 8b 00 00 00       	jmp    f01057f2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f0105767:	8b 45 14             	mov    0x14(%ebp),%eax
f010576a:	8b 10                	mov    (%eax),%edx
f010576c:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105771:	8d 40 04             	lea    0x4(%eax),%eax
f0105774:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105777:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
f010577c:	eb 74                	jmp    f01057f2 <vprintfmt+0x38c>
	if (lflag >= 2)
f010577e:	83 f9 01             	cmp    $0x1,%ecx
f0105781:	7f 1b                	jg     f010579e <vprintfmt+0x338>
	else if (lflag)
f0105783:	85 c9                	test   %ecx,%ecx
f0105785:	74 2c                	je     f01057b3 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
f0105787:	8b 45 14             	mov    0x14(%ebp),%eax
f010578a:	8b 10                	mov    (%eax),%edx
f010578c:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105791:	8d 40 04             	lea    0x4(%eax),%eax
f0105794:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105797:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
f010579c:	eb 54                	jmp    f01057f2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f010579e:	8b 45 14             	mov    0x14(%ebp),%eax
f01057a1:	8b 10                	mov    (%eax),%edx
f01057a3:	8b 48 04             	mov    0x4(%eax),%ecx
f01057a6:	8d 40 08             	lea    0x8(%eax),%eax
f01057a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01057ac:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
f01057b1:	eb 3f                	jmp    f01057f2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f01057b3:	8b 45 14             	mov    0x14(%ebp),%eax
f01057b6:	8b 10                	mov    (%eax),%edx
f01057b8:	b9 00 00 00 00       	mov    $0x0,%ecx
f01057bd:	8d 40 04             	lea    0x4(%eax),%eax
f01057c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01057c3:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
f01057c8:	eb 28                	jmp    f01057f2 <vprintfmt+0x38c>
			putch('0', putdat);
f01057ca:	83 ec 08             	sub    $0x8,%esp
f01057cd:	53                   	push   %ebx
f01057ce:	6a 30                	push   $0x30
f01057d0:	ff d6                	call   *%esi
			putch('x', putdat);
f01057d2:	83 c4 08             	add    $0x8,%esp
f01057d5:	53                   	push   %ebx
f01057d6:	6a 78                	push   $0x78
f01057d8:	ff d6                	call   *%esi
			num = (unsigned long long)
f01057da:	8b 45 14             	mov    0x14(%ebp),%eax
f01057dd:	8b 10                	mov    (%eax),%edx
f01057df:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f01057e4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01057e7:	8d 40 04             	lea    0x4(%eax),%eax
f01057ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01057ed:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01057f2:	83 ec 0c             	sub    $0xc,%esp
f01057f5:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
f01057f9:	57                   	push   %edi
f01057fa:	ff 75 e0             	pushl  -0x20(%ebp)
f01057fd:	50                   	push   %eax
f01057fe:	51                   	push   %ecx
f01057ff:	52                   	push   %edx
f0105800:	89 da                	mov    %ebx,%edx
f0105802:	89 f0                	mov    %esi,%eax
f0105804:	e8 72 fb ff ff       	call   f010537b <printnum>
			break;
f0105809:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f010580c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f010580f:	83 c7 01             	add    $0x1,%edi
f0105812:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105816:	83 f8 25             	cmp    $0x25,%eax
f0105819:	0f 84 62 fc ff ff    	je     f0105481 <vprintfmt+0x1b>
			if (ch == '\0')
f010581f:	85 c0                	test   %eax,%eax
f0105821:	0f 84 8b 00 00 00    	je     f01058b2 <vprintfmt+0x44c>
			putch(ch, putdat);
f0105827:	83 ec 08             	sub    $0x8,%esp
f010582a:	53                   	push   %ebx
f010582b:	50                   	push   %eax
f010582c:	ff d6                	call   *%esi
f010582e:	83 c4 10             	add    $0x10,%esp
f0105831:	eb dc                	jmp    f010580f <vprintfmt+0x3a9>
	if (lflag >= 2)
f0105833:	83 f9 01             	cmp    $0x1,%ecx
f0105836:	7f 1b                	jg     f0105853 <vprintfmt+0x3ed>
	else if (lflag)
f0105838:	85 c9                	test   %ecx,%ecx
f010583a:	74 2c                	je     f0105868 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
f010583c:	8b 45 14             	mov    0x14(%ebp),%eax
f010583f:	8b 10                	mov    (%eax),%edx
f0105841:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105846:	8d 40 04             	lea    0x4(%eax),%eax
f0105849:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010584c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
f0105851:	eb 9f                	jmp    f01057f2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f0105853:	8b 45 14             	mov    0x14(%ebp),%eax
f0105856:	8b 10                	mov    (%eax),%edx
f0105858:	8b 48 04             	mov    0x4(%eax),%ecx
f010585b:	8d 40 08             	lea    0x8(%eax),%eax
f010585e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105861:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
f0105866:	eb 8a                	jmp    f01057f2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f0105868:	8b 45 14             	mov    0x14(%ebp),%eax
f010586b:	8b 10                	mov    (%eax),%edx
f010586d:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105872:	8d 40 04             	lea    0x4(%eax),%eax
f0105875:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105878:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
f010587d:	e9 70 ff ff ff       	jmp    f01057f2 <vprintfmt+0x38c>
			putch(ch, putdat);
f0105882:	83 ec 08             	sub    $0x8,%esp
f0105885:	53                   	push   %ebx
f0105886:	6a 25                	push   $0x25
f0105888:	ff d6                	call   *%esi
			break;
f010588a:	83 c4 10             	add    $0x10,%esp
f010588d:	e9 7a ff ff ff       	jmp    f010580c <vprintfmt+0x3a6>
			putch('%', putdat);
f0105892:	83 ec 08             	sub    $0x8,%esp
f0105895:	53                   	push   %ebx
f0105896:	6a 25                	push   $0x25
f0105898:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f010589a:	83 c4 10             	add    $0x10,%esp
f010589d:	89 f8                	mov    %edi,%eax
f010589f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01058a3:	74 05                	je     f01058aa <vprintfmt+0x444>
f01058a5:	83 e8 01             	sub    $0x1,%eax
f01058a8:	eb f5                	jmp    f010589f <vprintfmt+0x439>
f01058aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01058ad:	e9 5a ff ff ff       	jmp    f010580c <vprintfmt+0x3a6>
}
f01058b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01058b5:	5b                   	pop    %ebx
f01058b6:	5e                   	pop    %esi
f01058b7:	5f                   	pop    %edi
f01058b8:	5d                   	pop    %ebp
f01058b9:	c3                   	ret    

f01058ba <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01058ba:	f3 0f 1e fb          	endbr32 
f01058be:	55                   	push   %ebp
f01058bf:	89 e5                	mov    %esp,%ebp
f01058c1:	83 ec 18             	sub    $0x18,%esp
f01058c4:	8b 45 08             	mov    0x8(%ebp),%eax
f01058c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01058ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01058cd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01058d1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01058d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01058db:	85 c0                	test   %eax,%eax
f01058dd:	74 26                	je     f0105905 <vsnprintf+0x4b>
f01058df:	85 d2                	test   %edx,%edx
f01058e1:	7e 22                	jle    f0105905 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01058e3:	ff 75 14             	pushl  0x14(%ebp)
f01058e6:	ff 75 10             	pushl  0x10(%ebp)
f01058e9:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01058ec:	50                   	push   %eax
f01058ed:	68 24 54 10 f0       	push   $0xf0105424
f01058f2:	e8 6f fb ff ff       	call   f0105466 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01058f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01058fa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01058fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105900:	83 c4 10             	add    $0x10,%esp
}
f0105903:	c9                   	leave  
f0105904:	c3                   	ret    
		return -E_INVAL;
f0105905:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010590a:	eb f7                	jmp    f0105903 <vsnprintf+0x49>

f010590c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010590c:	f3 0f 1e fb          	endbr32 
f0105910:	55                   	push   %ebp
f0105911:	89 e5                	mov    %esp,%ebp
f0105913:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105916:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0105919:	50                   	push   %eax
f010591a:	ff 75 10             	pushl  0x10(%ebp)
f010591d:	ff 75 0c             	pushl  0xc(%ebp)
f0105920:	ff 75 08             	pushl  0x8(%ebp)
f0105923:	e8 92 ff ff ff       	call   f01058ba <vsnprintf>
	va_end(ap);

	return rc;
}
f0105928:	c9                   	leave  
f0105929:	c3                   	ret    

f010592a <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010592a:	f3 0f 1e fb          	endbr32 
f010592e:	55                   	push   %ebp
f010592f:	89 e5                	mov    %esp,%ebp
f0105931:	57                   	push   %edi
f0105932:	56                   	push   %esi
f0105933:	53                   	push   %ebx
f0105934:	83 ec 0c             	sub    $0xc,%esp
f0105937:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f010593a:	85 c0                	test   %eax,%eax
f010593c:	74 11                	je     f010594f <readline+0x25>
		cprintf("%s", prompt);
f010593e:	83 ec 08             	sub    $0x8,%esp
f0105941:	50                   	push   %eax
f0105942:	68 ee 77 10 f0       	push   $0xf01077ee
f0105947:	e8 ea e0 ff ff       	call   f0103a36 <cprintf>
f010594c:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f010594f:	83 ec 0c             	sub    $0xc,%esp
f0105952:	6a 00                	push   $0x0
f0105954:	e8 92 ae ff ff       	call   f01007eb <iscons>
f0105959:	89 c7                	mov    %eax,%edi
f010595b:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010595e:	be 00 00 00 00       	mov    $0x0,%esi
f0105963:	eb 57                	jmp    f01059bc <readline+0x92>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0105965:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f010596a:	83 fb f8             	cmp    $0xfffffff8,%ebx
f010596d:	75 08                	jne    f0105977 <readline+0x4d>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f010596f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105972:	5b                   	pop    %ebx
f0105973:	5e                   	pop    %esi
f0105974:	5f                   	pop    %edi
f0105975:	5d                   	pop    %ebp
f0105976:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0105977:	83 ec 08             	sub    $0x8,%esp
f010597a:	53                   	push   %ebx
f010597b:	68 7f 8d 10 f0       	push   $0xf0108d7f
f0105980:	e8 b1 e0 ff ff       	call   f0103a36 <cprintf>
f0105985:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0105988:	b8 00 00 00 00       	mov    $0x0,%eax
f010598d:	eb e0                	jmp    f010596f <readline+0x45>
			if (echoing)
f010598f:	85 ff                	test   %edi,%edi
f0105991:	75 05                	jne    f0105998 <readline+0x6e>
			i--;
f0105993:	83 ee 01             	sub    $0x1,%esi
f0105996:	eb 24                	jmp    f01059bc <readline+0x92>
				cputchar('\b');
f0105998:	83 ec 0c             	sub    $0xc,%esp
f010599b:	6a 08                	push   $0x8
f010599d:	e8 20 ae ff ff       	call   f01007c2 <cputchar>
f01059a2:	83 c4 10             	add    $0x10,%esp
f01059a5:	eb ec                	jmp    f0105993 <readline+0x69>
				cputchar(c);
f01059a7:	83 ec 0c             	sub    $0xc,%esp
f01059aa:	53                   	push   %ebx
f01059ab:	e8 12 ae ff ff       	call   f01007c2 <cputchar>
f01059b0:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01059b3:	88 9e 80 1a 2c f0    	mov    %bl,-0xfd3e580(%esi)
f01059b9:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01059bc:	e8 15 ae ff ff       	call   f01007d6 <getchar>
f01059c1:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01059c3:	85 c0                	test   %eax,%eax
f01059c5:	78 9e                	js     f0105965 <readline+0x3b>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01059c7:	83 f8 08             	cmp    $0x8,%eax
f01059ca:	0f 94 c2             	sete   %dl
f01059cd:	83 f8 7f             	cmp    $0x7f,%eax
f01059d0:	0f 94 c0             	sete   %al
f01059d3:	08 c2                	or     %al,%dl
f01059d5:	74 04                	je     f01059db <readline+0xb1>
f01059d7:	85 f6                	test   %esi,%esi
f01059d9:	7f b4                	jg     f010598f <readline+0x65>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01059db:	83 fb 1f             	cmp    $0x1f,%ebx
f01059de:	7e 0e                	jle    f01059ee <readline+0xc4>
f01059e0:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01059e6:	7f 06                	jg     f01059ee <readline+0xc4>
			if (echoing)
f01059e8:	85 ff                	test   %edi,%edi
f01059ea:	74 c7                	je     f01059b3 <readline+0x89>
f01059ec:	eb b9                	jmp    f01059a7 <readline+0x7d>
		} else if (c == '\n' || c == '\r') {
f01059ee:	83 fb 0a             	cmp    $0xa,%ebx
f01059f1:	74 05                	je     f01059f8 <readline+0xce>
f01059f3:	83 fb 0d             	cmp    $0xd,%ebx
f01059f6:	75 c4                	jne    f01059bc <readline+0x92>
			if (echoing)
f01059f8:	85 ff                	test   %edi,%edi
f01059fa:	75 11                	jne    f0105a0d <readline+0xe3>
			buf[i] = 0;
f01059fc:	c6 86 80 1a 2c f0 00 	movb   $0x0,-0xfd3e580(%esi)
			return buf;
f0105a03:	b8 80 1a 2c f0       	mov    $0xf02c1a80,%eax
f0105a08:	e9 62 ff ff ff       	jmp    f010596f <readline+0x45>
				cputchar('\n');
f0105a0d:	83 ec 0c             	sub    $0xc,%esp
f0105a10:	6a 0a                	push   $0xa
f0105a12:	e8 ab ad ff ff       	call   f01007c2 <cputchar>
f0105a17:	83 c4 10             	add    $0x10,%esp
f0105a1a:	eb e0                	jmp    f01059fc <readline+0xd2>

f0105a1c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105a1c:	f3 0f 1e fb          	endbr32 
f0105a20:	55                   	push   %ebp
f0105a21:	89 e5                	mov    %esp,%ebp
f0105a23:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0105a26:	b8 00 00 00 00       	mov    $0x0,%eax
f0105a2b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105a2f:	74 05                	je     f0105a36 <strlen+0x1a>
		n++;
f0105a31:	83 c0 01             	add    $0x1,%eax
f0105a34:	eb f5                	jmp    f0105a2b <strlen+0xf>
	return n;
}
f0105a36:	5d                   	pop    %ebp
f0105a37:	c3                   	ret    

f0105a38 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105a38:	f3 0f 1e fb          	endbr32 
f0105a3c:	55                   	push   %ebp
f0105a3d:	89 e5                	mov    %esp,%ebp
f0105a3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105a42:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105a45:	b8 00 00 00 00       	mov    $0x0,%eax
f0105a4a:	39 d0                	cmp    %edx,%eax
f0105a4c:	74 0d                	je     f0105a5b <strnlen+0x23>
f0105a4e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0105a52:	74 05                	je     f0105a59 <strnlen+0x21>
		n++;
f0105a54:	83 c0 01             	add    $0x1,%eax
f0105a57:	eb f1                	jmp    f0105a4a <strnlen+0x12>
f0105a59:	89 c2                	mov    %eax,%edx
	return n;
}
f0105a5b:	89 d0                	mov    %edx,%eax
f0105a5d:	5d                   	pop    %ebp
f0105a5e:	c3                   	ret    

f0105a5f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105a5f:	f3 0f 1e fb          	endbr32 
f0105a63:	55                   	push   %ebp
f0105a64:	89 e5                	mov    %esp,%ebp
f0105a66:	53                   	push   %ebx
f0105a67:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105a6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105a6d:	b8 00 00 00 00       	mov    $0x0,%eax
f0105a72:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f0105a76:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f0105a79:	83 c0 01             	add    $0x1,%eax
f0105a7c:	84 d2                	test   %dl,%dl
f0105a7e:	75 f2                	jne    f0105a72 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
f0105a80:	89 c8                	mov    %ecx,%eax
f0105a82:	5b                   	pop    %ebx
f0105a83:	5d                   	pop    %ebp
f0105a84:	c3                   	ret    

f0105a85 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105a85:	f3 0f 1e fb          	endbr32 
f0105a89:	55                   	push   %ebp
f0105a8a:	89 e5                	mov    %esp,%ebp
f0105a8c:	53                   	push   %ebx
f0105a8d:	83 ec 10             	sub    $0x10,%esp
f0105a90:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105a93:	53                   	push   %ebx
f0105a94:	e8 83 ff ff ff       	call   f0105a1c <strlen>
f0105a99:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0105a9c:	ff 75 0c             	pushl  0xc(%ebp)
f0105a9f:	01 d8                	add    %ebx,%eax
f0105aa1:	50                   	push   %eax
f0105aa2:	e8 b8 ff ff ff       	call   f0105a5f <strcpy>
	return dst;
}
f0105aa7:	89 d8                	mov    %ebx,%eax
f0105aa9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105aac:	c9                   	leave  
f0105aad:	c3                   	ret    

f0105aae <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0105aae:	f3 0f 1e fb          	endbr32 
f0105ab2:	55                   	push   %ebp
f0105ab3:	89 e5                	mov    %esp,%ebp
f0105ab5:	56                   	push   %esi
f0105ab6:	53                   	push   %ebx
f0105ab7:	8b 75 08             	mov    0x8(%ebp),%esi
f0105aba:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105abd:	89 f3                	mov    %esi,%ebx
f0105abf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105ac2:	89 f0                	mov    %esi,%eax
f0105ac4:	39 d8                	cmp    %ebx,%eax
f0105ac6:	74 11                	je     f0105ad9 <strncpy+0x2b>
		*dst++ = *src;
f0105ac8:	83 c0 01             	add    $0x1,%eax
f0105acb:	0f b6 0a             	movzbl (%edx),%ecx
f0105ace:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0105ad1:	80 f9 01             	cmp    $0x1,%cl
f0105ad4:	83 da ff             	sbb    $0xffffffff,%edx
f0105ad7:	eb eb                	jmp    f0105ac4 <strncpy+0x16>
	}
	return ret;
}
f0105ad9:	89 f0                	mov    %esi,%eax
f0105adb:	5b                   	pop    %ebx
f0105adc:	5e                   	pop    %esi
f0105add:	5d                   	pop    %ebp
f0105ade:	c3                   	ret    

f0105adf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0105adf:	f3 0f 1e fb          	endbr32 
f0105ae3:	55                   	push   %ebp
f0105ae4:	89 e5                	mov    %esp,%ebp
f0105ae6:	56                   	push   %esi
f0105ae7:	53                   	push   %ebx
f0105ae8:	8b 75 08             	mov    0x8(%ebp),%esi
f0105aeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105aee:	8b 55 10             	mov    0x10(%ebp),%edx
f0105af1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0105af3:	85 d2                	test   %edx,%edx
f0105af5:	74 21                	je     f0105b18 <strlcpy+0x39>
f0105af7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f0105afb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f0105afd:	39 c2                	cmp    %eax,%edx
f0105aff:	74 14                	je     f0105b15 <strlcpy+0x36>
f0105b01:	0f b6 19             	movzbl (%ecx),%ebx
f0105b04:	84 db                	test   %bl,%bl
f0105b06:	74 0b                	je     f0105b13 <strlcpy+0x34>
			*dst++ = *src++;
f0105b08:	83 c1 01             	add    $0x1,%ecx
f0105b0b:	83 c2 01             	add    $0x1,%edx
f0105b0e:	88 5a ff             	mov    %bl,-0x1(%edx)
f0105b11:	eb ea                	jmp    f0105afd <strlcpy+0x1e>
f0105b13:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0105b15:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105b18:	29 f0                	sub    %esi,%eax
}
f0105b1a:	5b                   	pop    %ebx
f0105b1b:	5e                   	pop    %esi
f0105b1c:	5d                   	pop    %ebp
f0105b1d:	c3                   	ret    

f0105b1e <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105b1e:	f3 0f 1e fb          	endbr32 
f0105b22:	55                   	push   %ebp
f0105b23:	89 e5                	mov    %esp,%ebp
f0105b25:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105b28:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105b2b:	0f b6 01             	movzbl (%ecx),%eax
f0105b2e:	84 c0                	test   %al,%al
f0105b30:	74 0c                	je     f0105b3e <strcmp+0x20>
f0105b32:	3a 02                	cmp    (%edx),%al
f0105b34:	75 08                	jne    f0105b3e <strcmp+0x20>
		p++, q++;
f0105b36:	83 c1 01             	add    $0x1,%ecx
f0105b39:	83 c2 01             	add    $0x1,%edx
f0105b3c:	eb ed                	jmp    f0105b2b <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105b3e:	0f b6 c0             	movzbl %al,%eax
f0105b41:	0f b6 12             	movzbl (%edx),%edx
f0105b44:	29 d0                	sub    %edx,%eax
}
f0105b46:	5d                   	pop    %ebp
f0105b47:	c3                   	ret    

f0105b48 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0105b48:	f3 0f 1e fb          	endbr32 
f0105b4c:	55                   	push   %ebp
f0105b4d:	89 e5                	mov    %esp,%ebp
f0105b4f:	53                   	push   %ebx
f0105b50:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b53:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105b56:	89 c3                	mov    %eax,%ebx
f0105b58:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0105b5b:	eb 06                	jmp    f0105b63 <strncmp+0x1b>
		n--, p++, q++;
f0105b5d:	83 c0 01             	add    $0x1,%eax
f0105b60:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105b63:	39 d8                	cmp    %ebx,%eax
f0105b65:	74 16                	je     f0105b7d <strncmp+0x35>
f0105b67:	0f b6 08             	movzbl (%eax),%ecx
f0105b6a:	84 c9                	test   %cl,%cl
f0105b6c:	74 04                	je     f0105b72 <strncmp+0x2a>
f0105b6e:	3a 0a                	cmp    (%edx),%cl
f0105b70:	74 eb                	je     f0105b5d <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105b72:	0f b6 00             	movzbl (%eax),%eax
f0105b75:	0f b6 12             	movzbl (%edx),%edx
f0105b78:	29 d0                	sub    %edx,%eax
}
f0105b7a:	5b                   	pop    %ebx
f0105b7b:	5d                   	pop    %ebp
f0105b7c:	c3                   	ret    
		return 0;
f0105b7d:	b8 00 00 00 00       	mov    $0x0,%eax
f0105b82:	eb f6                	jmp    f0105b7a <strncmp+0x32>

f0105b84 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105b84:	f3 0f 1e fb          	endbr32 
f0105b88:	55                   	push   %ebp
f0105b89:	89 e5                	mov    %esp,%ebp
f0105b8b:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b8e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105b92:	0f b6 10             	movzbl (%eax),%edx
f0105b95:	84 d2                	test   %dl,%dl
f0105b97:	74 09                	je     f0105ba2 <strchr+0x1e>
		if (*s == c)
f0105b99:	38 ca                	cmp    %cl,%dl
f0105b9b:	74 0a                	je     f0105ba7 <strchr+0x23>
	for (; *s; s++)
f0105b9d:	83 c0 01             	add    $0x1,%eax
f0105ba0:	eb f0                	jmp    f0105b92 <strchr+0xe>
			return (char *) s;
	return 0;
f0105ba2:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105ba7:	5d                   	pop    %ebp
f0105ba8:	c3                   	ret    

f0105ba9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105ba9:	f3 0f 1e fb          	endbr32 
f0105bad:	55                   	push   %ebp
f0105bae:	89 e5                	mov    %esp,%ebp
f0105bb0:	8b 45 08             	mov    0x8(%ebp),%eax
f0105bb3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105bb7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0105bba:	38 ca                	cmp    %cl,%dl
f0105bbc:	74 09                	je     f0105bc7 <strfind+0x1e>
f0105bbe:	84 d2                	test   %dl,%dl
f0105bc0:	74 05                	je     f0105bc7 <strfind+0x1e>
	for (; *s; s++)
f0105bc2:	83 c0 01             	add    $0x1,%eax
f0105bc5:	eb f0                	jmp    f0105bb7 <strfind+0xe>
			break;
	return (char *) s;
}
f0105bc7:	5d                   	pop    %ebp
f0105bc8:	c3                   	ret    

f0105bc9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105bc9:	f3 0f 1e fb          	endbr32 
f0105bcd:	55                   	push   %ebp
f0105bce:	89 e5                	mov    %esp,%ebp
f0105bd0:	57                   	push   %edi
f0105bd1:	56                   	push   %esi
f0105bd2:	53                   	push   %ebx
f0105bd3:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105bd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0105bd9:	85 c9                	test   %ecx,%ecx
f0105bdb:	74 31                	je     f0105c0e <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0105bdd:	89 f8                	mov    %edi,%eax
f0105bdf:	09 c8                	or     %ecx,%eax
f0105be1:	a8 03                	test   $0x3,%al
f0105be3:	75 23                	jne    f0105c08 <memset+0x3f>
		c &= 0xFF;
f0105be5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0105be9:	89 d3                	mov    %edx,%ebx
f0105beb:	c1 e3 08             	shl    $0x8,%ebx
f0105bee:	89 d0                	mov    %edx,%eax
f0105bf0:	c1 e0 18             	shl    $0x18,%eax
f0105bf3:	89 d6                	mov    %edx,%esi
f0105bf5:	c1 e6 10             	shl    $0x10,%esi
f0105bf8:	09 f0                	or     %esi,%eax
f0105bfa:	09 c2                	or     %eax,%edx
f0105bfc:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0105bfe:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0105c01:	89 d0                	mov    %edx,%eax
f0105c03:	fc                   	cld    
f0105c04:	f3 ab                	rep stos %eax,%es:(%edi)
f0105c06:	eb 06                	jmp    f0105c0e <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0105c08:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105c0b:	fc                   	cld    
f0105c0c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0105c0e:	89 f8                	mov    %edi,%eax
f0105c10:	5b                   	pop    %ebx
f0105c11:	5e                   	pop    %esi
f0105c12:	5f                   	pop    %edi
f0105c13:	5d                   	pop    %ebp
f0105c14:	c3                   	ret    

f0105c15 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105c15:	f3 0f 1e fb          	endbr32 
f0105c19:	55                   	push   %ebp
f0105c1a:	89 e5                	mov    %esp,%ebp
f0105c1c:	57                   	push   %edi
f0105c1d:	56                   	push   %esi
f0105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c21:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105c24:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105c27:	39 c6                	cmp    %eax,%esi
f0105c29:	73 32                	jae    f0105c5d <memmove+0x48>
f0105c2b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105c2e:	39 c2                	cmp    %eax,%edx
f0105c30:	76 2b                	jbe    f0105c5d <memmove+0x48>
		s += n;
		d += n;
f0105c32:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105c35:	89 fe                	mov    %edi,%esi
f0105c37:	09 ce                	or     %ecx,%esi
f0105c39:	09 d6                	or     %edx,%esi
f0105c3b:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105c41:	75 0e                	jne    f0105c51 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105c43:	83 ef 04             	sub    $0x4,%edi
f0105c46:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105c49:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105c4c:	fd                   	std    
f0105c4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105c4f:	eb 09                	jmp    f0105c5a <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105c51:	83 ef 01             	sub    $0x1,%edi
f0105c54:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105c57:	fd                   	std    
f0105c58:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105c5a:	fc                   	cld    
f0105c5b:	eb 1a                	jmp    f0105c77 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105c5d:	89 c2                	mov    %eax,%edx
f0105c5f:	09 ca                	or     %ecx,%edx
f0105c61:	09 f2                	or     %esi,%edx
f0105c63:	f6 c2 03             	test   $0x3,%dl
f0105c66:	75 0a                	jne    f0105c72 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0105c68:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105c6b:	89 c7                	mov    %eax,%edi
f0105c6d:	fc                   	cld    
f0105c6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105c70:	eb 05                	jmp    f0105c77 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
f0105c72:	89 c7                	mov    %eax,%edi
f0105c74:	fc                   	cld    
f0105c75:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105c77:	5e                   	pop    %esi
f0105c78:	5f                   	pop    %edi
f0105c79:	5d                   	pop    %ebp
f0105c7a:	c3                   	ret    

f0105c7b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105c7b:	f3 0f 1e fb          	endbr32 
f0105c7f:	55                   	push   %ebp
f0105c80:	89 e5                	mov    %esp,%ebp
f0105c82:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0105c85:	ff 75 10             	pushl  0x10(%ebp)
f0105c88:	ff 75 0c             	pushl  0xc(%ebp)
f0105c8b:	ff 75 08             	pushl  0x8(%ebp)
f0105c8e:	e8 82 ff ff ff       	call   f0105c15 <memmove>
}
f0105c93:	c9                   	leave  
f0105c94:	c3                   	ret    

f0105c95 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105c95:	f3 0f 1e fb          	endbr32 
f0105c99:	55                   	push   %ebp
f0105c9a:	89 e5                	mov    %esp,%ebp
f0105c9c:	56                   	push   %esi
f0105c9d:	53                   	push   %ebx
f0105c9e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105ca4:	89 c6                	mov    %eax,%esi
f0105ca6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105ca9:	39 f0                	cmp    %esi,%eax
f0105cab:	74 1c                	je     f0105cc9 <memcmp+0x34>
		if (*s1 != *s2)
f0105cad:	0f b6 08             	movzbl (%eax),%ecx
f0105cb0:	0f b6 1a             	movzbl (%edx),%ebx
f0105cb3:	38 d9                	cmp    %bl,%cl
f0105cb5:	75 08                	jne    f0105cbf <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0105cb7:	83 c0 01             	add    $0x1,%eax
f0105cba:	83 c2 01             	add    $0x1,%edx
f0105cbd:	eb ea                	jmp    f0105ca9 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
f0105cbf:	0f b6 c1             	movzbl %cl,%eax
f0105cc2:	0f b6 db             	movzbl %bl,%ebx
f0105cc5:	29 d8                	sub    %ebx,%eax
f0105cc7:	eb 05                	jmp    f0105cce <memcmp+0x39>
	}

	return 0;
f0105cc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105cce:	5b                   	pop    %ebx
f0105ccf:	5e                   	pop    %esi
f0105cd0:	5d                   	pop    %ebp
f0105cd1:	c3                   	ret    

f0105cd2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0105cd2:	f3 0f 1e fb          	endbr32 
f0105cd6:	55                   	push   %ebp
f0105cd7:	89 e5                	mov    %esp,%ebp
f0105cd9:	8b 45 08             	mov    0x8(%ebp),%eax
f0105cdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0105cdf:	89 c2                	mov    %eax,%edx
f0105ce1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0105ce4:	39 d0                	cmp    %edx,%eax
f0105ce6:	73 09                	jae    f0105cf1 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
f0105ce8:	38 08                	cmp    %cl,(%eax)
f0105cea:	74 05                	je     f0105cf1 <memfind+0x1f>
	for (; s < ends; s++)
f0105cec:	83 c0 01             	add    $0x1,%eax
f0105cef:	eb f3                	jmp    f0105ce4 <memfind+0x12>
			break;
	return (void *) s;
}
f0105cf1:	5d                   	pop    %ebp
f0105cf2:	c3                   	ret    

f0105cf3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0105cf3:	f3 0f 1e fb          	endbr32 
f0105cf7:	55                   	push   %ebp
f0105cf8:	89 e5                	mov    %esp,%ebp
f0105cfa:	57                   	push   %edi
f0105cfb:	56                   	push   %esi
f0105cfc:	53                   	push   %ebx
f0105cfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105d00:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0105d03:	eb 03                	jmp    f0105d08 <strtol+0x15>
		s++;
f0105d05:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0105d08:	0f b6 01             	movzbl (%ecx),%eax
f0105d0b:	3c 20                	cmp    $0x20,%al
f0105d0d:	74 f6                	je     f0105d05 <strtol+0x12>
f0105d0f:	3c 09                	cmp    $0x9,%al
f0105d11:	74 f2                	je     f0105d05 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
f0105d13:	3c 2b                	cmp    $0x2b,%al
f0105d15:	74 2a                	je     f0105d41 <strtol+0x4e>
	int neg = 0;
f0105d17:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0105d1c:	3c 2d                	cmp    $0x2d,%al
f0105d1e:	74 2b                	je     f0105d4b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105d20:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0105d26:	75 0f                	jne    f0105d37 <strtol+0x44>
f0105d28:	80 39 30             	cmpb   $0x30,(%ecx)
f0105d2b:	74 28                	je     f0105d55 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0105d2d:	85 db                	test   %ebx,%ebx
f0105d2f:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105d34:	0f 44 d8             	cmove  %eax,%ebx
f0105d37:	b8 00 00 00 00       	mov    $0x0,%eax
f0105d3c:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105d3f:	eb 46                	jmp    f0105d87 <strtol+0x94>
		s++;
f0105d41:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105d44:	bf 00 00 00 00       	mov    $0x0,%edi
f0105d49:	eb d5                	jmp    f0105d20 <strtol+0x2d>
		s++, neg = 1;
f0105d4b:	83 c1 01             	add    $0x1,%ecx
f0105d4e:	bf 01 00 00 00       	mov    $0x1,%edi
f0105d53:	eb cb                	jmp    f0105d20 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105d55:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105d59:	74 0e                	je     f0105d69 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105d5b:	85 db                	test   %ebx,%ebx
f0105d5d:	75 d8                	jne    f0105d37 <strtol+0x44>
		s++, base = 8;
f0105d5f:	83 c1 01             	add    $0x1,%ecx
f0105d62:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105d67:	eb ce                	jmp    f0105d37 <strtol+0x44>
		s += 2, base = 16;
f0105d69:	83 c1 02             	add    $0x2,%ecx
f0105d6c:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105d71:	eb c4                	jmp    f0105d37 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0105d73:	0f be d2             	movsbl %dl,%edx
f0105d76:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105d79:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105d7c:	7d 3a                	jge    f0105db8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105d7e:	83 c1 01             	add    $0x1,%ecx
f0105d81:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105d85:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105d87:	0f b6 11             	movzbl (%ecx),%edx
f0105d8a:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105d8d:	89 f3                	mov    %esi,%ebx
f0105d8f:	80 fb 09             	cmp    $0x9,%bl
f0105d92:	76 df                	jbe    f0105d73 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
f0105d94:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105d97:	89 f3                	mov    %esi,%ebx
f0105d99:	80 fb 19             	cmp    $0x19,%bl
f0105d9c:	77 08                	ja     f0105da6 <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105d9e:	0f be d2             	movsbl %dl,%edx
f0105da1:	83 ea 57             	sub    $0x57,%edx
f0105da4:	eb d3                	jmp    f0105d79 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
f0105da6:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105da9:	89 f3                	mov    %esi,%ebx
f0105dab:	80 fb 19             	cmp    $0x19,%bl
f0105dae:	77 08                	ja     f0105db8 <strtol+0xc5>
			dig = *s - 'A' + 10;
f0105db0:	0f be d2             	movsbl %dl,%edx
f0105db3:	83 ea 37             	sub    $0x37,%edx
f0105db6:	eb c1                	jmp    f0105d79 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105db8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0105dbc:	74 05                	je     f0105dc3 <strtol+0xd0>
		*endptr = (char *) s;
f0105dbe:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105dc1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0105dc3:	89 c2                	mov    %eax,%edx
f0105dc5:	f7 da                	neg    %edx
f0105dc7:	85 ff                	test   %edi,%edi
f0105dc9:	0f 45 c2             	cmovne %edx,%eax
}
f0105dcc:	5b                   	pop    %ebx
f0105dcd:	5e                   	pop    %esi
f0105dce:	5f                   	pop    %edi
f0105dcf:	5d                   	pop    %ebp
f0105dd0:	c3                   	ret    
f0105dd1:	66 90                	xchg   %ax,%ax
f0105dd3:	90                   	nop

f0105dd4 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0105dd4:	fa                   	cli    

	xorw    %ax, %ax
f0105dd5:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0105dd7:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105dd9:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105ddb:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0105ddd:	0f 01 16             	lgdtl  (%esi)
f0105de0:	74 70                	je     f0105e52 <mpsearch1+0x3>
	movl    %cr0, %eax
f0105de2:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0105de5:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0105de9:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0105dec:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0105df2:	08 00                	or     %al,(%eax)

f0105df4 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0105df4:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0105df8:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105dfa:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105dfc:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0105dfe:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0105e02:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0105e04:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0105e06:	b8 00 40 12 00       	mov    $0x124000,%eax
	movl    %eax, %cr3
f0105e0b:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0105e0e:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0105e11:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0105e16:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0105e19:	8b 25 94 1e 2c f0    	mov    0xf02c1e94,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105e1f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105e24:	b8 d6 01 10 f0       	mov    $0xf01001d6,%eax
	call    *%eax
f0105e29:	ff d0                	call   *%eax

f0105e2b <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105e2b:	eb fe                	jmp    f0105e2b <spin>
f0105e2d:	8d 76 00             	lea    0x0(%esi),%esi

f0105e30 <gdt>:
	...
f0105e38:	ff                   	(bad)  
f0105e39:	ff 00                	incl   (%eax)
f0105e3b:	00 00                	add    %al,(%eax)
f0105e3d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105e44:	00                   	.byte 0x0
f0105e45:	92                   	xchg   %eax,%edx
f0105e46:	cf                   	iret   
	...

f0105e48 <gdtdesc>:
f0105e48:	17                   	pop    %ss
f0105e49:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0105e4e <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105e4e:	90                   	nop

f0105e4f <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105e4f:	55                   	push   %ebp
f0105e50:	89 e5                	mov    %esp,%ebp
f0105e52:	57                   	push   %edi
f0105e53:	56                   	push   %esi
f0105e54:	53                   	push   %ebx
f0105e55:	83 ec 0c             	sub    $0xc,%esp
f0105e58:	89 c7                	mov    %eax,%edi
	if (PGNUM(pa) >= npages)
f0105e5a:	a1 98 1e 2c f0       	mov    0xf02c1e98,%eax
f0105e5f:	89 f9                	mov    %edi,%ecx
f0105e61:	c1 e9 0c             	shr    $0xc,%ecx
f0105e64:	39 c1                	cmp    %eax,%ecx
f0105e66:	73 19                	jae    f0105e81 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0105e68:	8d 9f 00 00 00 f0    	lea    -0x10000000(%edi),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105e6e:	01 d7                	add    %edx,%edi
	if (PGNUM(pa) >= npages)
f0105e70:	89 fa                	mov    %edi,%edx
f0105e72:	c1 ea 0c             	shr    $0xc,%edx
f0105e75:	39 c2                	cmp    %eax,%edx
f0105e77:	73 1a                	jae    f0105e93 <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105e79:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0105e7f:	eb 27                	jmp    f0105ea8 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105e81:	57                   	push   %edi
f0105e82:	68 24 72 10 f0       	push   $0xf0107224
f0105e87:	6a 57                	push   $0x57
f0105e89:	68 1d 8f 10 f0       	push   $0xf0108f1d
f0105e8e:	e8 ad a1 ff ff       	call   f0100040 <_panic>
f0105e93:	57                   	push   %edi
f0105e94:	68 24 72 10 f0       	push   $0xf0107224
f0105e99:	6a 57                	push   $0x57
f0105e9b:	68 1d 8f 10 f0       	push   $0xf0108f1d
f0105ea0:	e8 9b a1 ff ff       	call   f0100040 <_panic>
f0105ea5:	83 c3 10             	add    $0x10,%ebx
f0105ea8:	39 fb                	cmp    %edi,%ebx
f0105eaa:	73 30                	jae    f0105edc <mpsearch1+0x8d>
f0105eac:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105eae:	83 ec 04             	sub    $0x4,%esp
f0105eb1:	6a 04                	push   $0x4
f0105eb3:	68 2d 8f 10 f0       	push   $0xf0108f2d
f0105eb8:	53                   	push   %ebx
f0105eb9:	e8 d7 fd ff ff       	call   f0105c95 <memcmp>
f0105ebe:	83 c4 10             	add    $0x10,%esp
f0105ec1:	85 c0                	test   %eax,%eax
f0105ec3:	75 e0                	jne    f0105ea5 <mpsearch1+0x56>
f0105ec5:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0105ec7:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0105eca:	0f b6 0a             	movzbl (%edx),%ecx
f0105ecd:	01 c8                	add    %ecx,%eax
f0105ecf:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0105ed2:	39 f2                	cmp    %esi,%edx
f0105ed4:	75 f4                	jne    f0105eca <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105ed6:	84 c0                	test   %al,%al
f0105ed8:	75 cb                	jne    f0105ea5 <mpsearch1+0x56>
f0105eda:	eb 05                	jmp    f0105ee1 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0105edc:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105ee1:	89 d8                	mov    %ebx,%eax
f0105ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105ee6:	5b                   	pop    %ebx
f0105ee7:	5e                   	pop    %esi
f0105ee8:	5f                   	pop    %edi
f0105ee9:	5d                   	pop    %ebp
f0105eea:	c3                   	ret    

f0105eeb <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0105eeb:	f3 0f 1e fb          	endbr32 
f0105eef:	55                   	push   %ebp
f0105ef0:	89 e5                	mov    %esp,%ebp
f0105ef2:	57                   	push   %edi
f0105ef3:	56                   	push   %esi
f0105ef4:	53                   	push   %ebx
f0105ef5:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105ef8:	c7 05 c0 23 2c f0 20 	movl   $0xf02c2020,0xf02c23c0
f0105eff:	20 2c f0 
	if (PGNUM(pa) >= npages)
f0105f02:	83 3d 98 1e 2c f0 00 	cmpl   $0x0,0xf02c1e98
f0105f09:	0f 84 a3 00 00 00    	je     f0105fb2 <mp_init+0xc7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0105f0f:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0105f16:	85 c0                	test   %eax,%eax
f0105f18:	0f 84 aa 00 00 00    	je     f0105fc8 <mp_init+0xdd>
		p <<= 4;	// Translate from segment to PA
f0105f1e:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0105f21:	ba 00 04 00 00       	mov    $0x400,%edx
f0105f26:	e8 24 ff ff ff       	call   f0105e4f <mpsearch1>
f0105f2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105f2e:	85 c0                	test   %eax,%eax
f0105f30:	75 1a                	jne    f0105f4c <mp_init+0x61>
	return mpsearch1(0xF0000, 0x10000);
f0105f32:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105f37:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105f3c:	e8 0e ff ff ff       	call   f0105e4f <mpsearch1>
f0105f41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0105f44:	85 c0                	test   %eax,%eax
f0105f46:	0f 84 35 02 00 00    	je     f0106181 <mp_init+0x296>
	if (mp->physaddr == 0 || mp->type != 0) {
f0105f4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105f4f:	8b 58 04             	mov    0x4(%eax),%ebx
f0105f52:	85 db                	test   %ebx,%ebx
f0105f54:	0f 84 97 00 00 00    	je     f0105ff1 <mp_init+0x106>
f0105f5a:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0105f5e:	0f 85 8d 00 00 00    	jne    f0105ff1 <mp_init+0x106>
f0105f64:	89 d8                	mov    %ebx,%eax
f0105f66:	c1 e8 0c             	shr    $0xc,%eax
f0105f69:	3b 05 98 1e 2c f0    	cmp    0xf02c1e98,%eax
f0105f6f:	0f 83 91 00 00 00    	jae    f0106006 <mp_init+0x11b>
	return (void *)(pa + KERNBASE);
f0105f75:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0105f7b:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105f7d:	83 ec 04             	sub    $0x4,%esp
f0105f80:	6a 04                	push   $0x4
f0105f82:	68 32 8f 10 f0       	push   $0xf0108f32
f0105f87:	53                   	push   %ebx
f0105f88:	e8 08 fd ff ff       	call   f0105c95 <memcmp>
f0105f8d:	83 c4 10             	add    $0x10,%esp
f0105f90:	85 c0                	test   %eax,%eax
f0105f92:	0f 85 83 00 00 00    	jne    f010601b <mp_init+0x130>
f0105f98:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105f9c:	01 df                	add    %ebx,%edi
	sum = 0;
f0105f9e:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0105fa0:	39 fb                	cmp    %edi,%ebx
f0105fa2:	0f 84 88 00 00 00    	je     f0106030 <mp_init+0x145>
		sum += ((uint8_t *)addr)[i];
f0105fa8:	0f b6 0b             	movzbl (%ebx),%ecx
f0105fab:	01 ca                	add    %ecx,%edx
f0105fad:	83 c3 01             	add    $0x1,%ebx
f0105fb0:	eb ee                	jmp    f0105fa0 <mp_init+0xb5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105fb2:	68 00 04 00 00       	push   $0x400
f0105fb7:	68 24 72 10 f0       	push   $0xf0107224
f0105fbc:	6a 6f                	push   $0x6f
f0105fbe:	68 1d 8f 10 f0       	push   $0xf0108f1d
f0105fc3:	e8 78 a0 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105fc8:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105fcf:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105fd2:	2d 00 04 00 00       	sub    $0x400,%eax
f0105fd7:	ba 00 04 00 00       	mov    $0x400,%edx
f0105fdc:	e8 6e fe ff ff       	call   f0105e4f <mpsearch1>
f0105fe1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105fe4:	85 c0                	test   %eax,%eax
f0105fe6:	0f 85 60 ff ff ff    	jne    f0105f4c <mp_init+0x61>
f0105fec:	e9 41 ff ff ff       	jmp    f0105f32 <mp_init+0x47>
		cprintf("SMP: Default configurations not implemented\n");
f0105ff1:	83 ec 0c             	sub    $0xc,%esp
f0105ff4:	68 90 8d 10 f0       	push   $0xf0108d90
f0105ff9:	e8 38 da ff ff       	call   f0103a36 <cprintf>
		return NULL;
f0105ffe:	83 c4 10             	add    $0x10,%esp
f0106001:	e9 7b 01 00 00       	jmp    f0106181 <mp_init+0x296>
f0106006:	53                   	push   %ebx
f0106007:	68 24 72 10 f0       	push   $0xf0107224
f010600c:	68 90 00 00 00       	push   $0x90
f0106011:	68 1d 8f 10 f0       	push   $0xf0108f1d
f0106016:	e8 25 a0 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f010601b:	83 ec 0c             	sub    $0xc,%esp
f010601e:	68 c0 8d 10 f0       	push   $0xf0108dc0
f0106023:	e8 0e da ff ff       	call   f0103a36 <cprintf>
		return NULL;
f0106028:	83 c4 10             	add    $0x10,%esp
f010602b:	e9 51 01 00 00       	jmp    f0106181 <mp_init+0x296>
	if (sum(conf, conf->length) != 0) {
f0106030:	84 d2                	test   %dl,%dl
f0106032:	75 22                	jne    f0106056 <mp_init+0x16b>
	if (conf->version != 1 && conf->version != 4) {
f0106034:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0106038:	80 fa 01             	cmp    $0x1,%dl
f010603b:	74 05                	je     f0106042 <mp_init+0x157>
f010603d:	80 fa 04             	cmp    $0x4,%dl
f0106040:	75 29                	jne    f010606b <mp_init+0x180>
f0106042:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0106046:	01 d9                	add    %ebx,%ecx
	for (i = 0; i < len; i++)
f0106048:	39 d9                	cmp    %ebx,%ecx
f010604a:	74 38                	je     f0106084 <mp_init+0x199>
		sum += ((uint8_t *)addr)[i];
f010604c:	0f b6 13             	movzbl (%ebx),%edx
f010604f:	01 d0                	add    %edx,%eax
f0106051:	83 c3 01             	add    $0x1,%ebx
f0106054:	eb f2                	jmp    f0106048 <mp_init+0x15d>
		cprintf("SMP: Bad MP configuration checksum\n");
f0106056:	83 ec 0c             	sub    $0xc,%esp
f0106059:	68 f4 8d 10 f0       	push   $0xf0108df4
f010605e:	e8 d3 d9 ff ff       	call   f0103a36 <cprintf>
		return NULL;
f0106063:	83 c4 10             	add    $0x10,%esp
f0106066:	e9 16 01 00 00       	jmp    f0106181 <mp_init+0x296>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f010606b:	83 ec 08             	sub    $0x8,%esp
f010606e:	0f b6 d2             	movzbl %dl,%edx
f0106071:	52                   	push   %edx
f0106072:	68 18 8e 10 f0       	push   $0xf0108e18
f0106077:	e8 ba d9 ff ff       	call   f0103a36 <cprintf>
		return NULL;
f010607c:	83 c4 10             	add    $0x10,%esp
f010607f:	e9 fd 00 00 00       	jmp    f0106181 <mp_init+0x296>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106084:	02 46 2a             	add    0x2a(%esi),%al
f0106087:	75 1c                	jne    f01060a5 <mp_init+0x1ba>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0106089:	c7 05 00 20 2c f0 01 	movl   $0x1,0xf02c2000
f0106090:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106093:	8b 46 24             	mov    0x24(%esi),%eax
f0106096:	a3 00 30 30 f0       	mov    %eax,0xf0303000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f010609b:	8d 7e 2c             	lea    0x2c(%esi),%edi
f010609e:	bb 00 00 00 00       	mov    $0x0,%ebx
f01060a3:	eb 4d                	jmp    f01060f2 <mp_init+0x207>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f01060a5:	83 ec 0c             	sub    $0xc,%esp
f01060a8:	68 38 8e 10 f0       	push   $0xf0108e38
f01060ad:	e8 84 d9 ff ff       	call   f0103a36 <cprintf>
		return NULL;
f01060b2:	83 c4 10             	add    $0x10,%esp
f01060b5:	e9 c7 00 00 00       	jmp    f0106181 <mp_init+0x296>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f01060ba:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f01060be:	74 11                	je     f01060d1 <mp_init+0x1e6>
				bootcpu = &cpus[ncpu];
f01060c0:	6b 05 c4 23 2c f0 74 	imul   $0x74,0xf02c23c4,%eax
f01060c7:	05 20 20 2c f0       	add    $0xf02c2020,%eax
f01060cc:	a3 c0 23 2c f0       	mov    %eax,0xf02c23c0
			if (ncpu < NCPU) {
f01060d1:	a1 c4 23 2c f0       	mov    0xf02c23c4,%eax
f01060d6:	83 f8 07             	cmp    $0x7,%eax
f01060d9:	7f 33                	jg     f010610e <mp_init+0x223>
				cpus[ncpu].cpu_id = ncpu;
f01060db:	6b d0 74             	imul   $0x74,%eax,%edx
f01060de:	88 82 20 20 2c f0    	mov    %al,-0xfd3dfe0(%edx)
				ncpu++;
f01060e4:	83 c0 01             	add    $0x1,%eax
f01060e7:	a3 c4 23 2c f0       	mov    %eax,0xf02c23c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f01060ec:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f01060ef:	83 c3 01             	add    $0x1,%ebx
f01060f2:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f01060f6:	39 d8                	cmp    %ebx,%eax
f01060f8:	76 4f                	jbe    f0106149 <mp_init+0x25e>
		switch (*p) {
f01060fa:	0f b6 07             	movzbl (%edi),%eax
f01060fd:	84 c0                	test   %al,%al
f01060ff:	74 b9                	je     f01060ba <mp_init+0x1cf>
f0106101:	8d 50 ff             	lea    -0x1(%eax),%edx
f0106104:	80 fa 03             	cmp    $0x3,%dl
f0106107:	77 1c                	ja     f0106125 <mp_init+0x23a>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106109:	83 c7 08             	add    $0x8,%edi
			continue;
f010610c:	eb e1                	jmp    f01060ef <mp_init+0x204>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f010610e:	83 ec 08             	sub    $0x8,%esp
f0106111:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0106115:	50                   	push   %eax
f0106116:	68 68 8e 10 f0       	push   $0xf0108e68
f010611b:	e8 16 d9 ff ff       	call   f0103a36 <cprintf>
f0106120:	83 c4 10             	add    $0x10,%esp
f0106123:	eb c7                	jmp    f01060ec <mp_init+0x201>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106125:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0106128:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f010612b:	50                   	push   %eax
f010612c:	68 90 8e 10 f0       	push   $0xf0108e90
f0106131:	e8 00 d9 ff ff       	call   f0103a36 <cprintf>
			ismp = 0;
f0106136:	c7 05 00 20 2c f0 00 	movl   $0x0,0xf02c2000
f010613d:	00 00 00 
			i = conf->entry;
f0106140:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106144:	83 c4 10             	add    $0x10,%esp
f0106147:	eb a6                	jmp    f01060ef <mp_init+0x204>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106149:	a1 c0 23 2c f0       	mov    0xf02c23c0,%eax
f010614e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106155:	83 3d 00 20 2c f0 00 	cmpl   $0x0,0xf02c2000
f010615c:	74 2b                	je     f0106189 <mp_init+0x29e>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f010615e:	83 ec 04             	sub    $0x4,%esp
f0106161:	ff 35 c4 23 2c f0    	pushl  0xf02c23c4
f0106167:	0f b6 00             	movzbl (%eax),%eax
f010616a:	50                   	push   %eax
f010616b:	68 37 8f 10 f0       	push   $0xf0108f37
f0106170:	e8 c1 d8 ff ff       	call   f0103a36 <cprintf>

	if (mp->imcrp) {
f0106175:	83 c4 10             	add    $0x10,%esp
f0106178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010617b:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f010617f:	75 2e                	jne    f01061af <mp_init+0x2c4>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106181:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106184:	5b                   	pop    %ebx
f0106185:	5e                   	pop    %esi
f0106186:	5f                   	pop    %edi
f0106187:	5d                   	pop    %ebp
f0106188:	c3                   	ret    
		ncpu = 1;
f0106189:	c7 05 c4 23 2c f0 01 	movl   $0x1,0xf02c23c4
f0106190:	00 00 00 
		lapicaddr = 0;
f0106193:	c7 05 00 30 30 f0 00 	movl   $0x0,0xf0303000
f010619a:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f010619d:	83 ec 0c             	sub    $0xc,%esp
f01061a0:	68 b0 8e 10 f0       	push   $0xf0108eb0
f01061a5:	e8 8c d8 ff ff       	call   f0103a36 <cprintf>
		return;
f01061aa:	83 c4 10             	add    $0x10,%esp
f01061ad:	eb d2                	jmp    f0106181 <mp_init+0x296>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f01061af:	83 ec 0c             	sub    $0xc,%esp
f01061b2:	68 dc 8e 10 f0       	push   $0xf0108edc
f01061b7:	e8 7a d8 ff ff       	call   f0103a36 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01061bc:	b8 70 00 00 00       	mov    $0x70,%eax
f01061c1:	ba 22 00 00 00       	mov    $0x22,%edx
f01061c6:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01061c7:	ba 23 00 00 00       	mov    $0x23,%edx
f01061cc:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f01061cd:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01061d0:	ee                   	out    %al,(%dx)
}
f01061d1:	83 c4 10             	add    $0x10,%esp
f01061d4:	eb ab                	jmp    f0106181 <mp_init+0x296>

f01061d6 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f01061d6:	8b 0d 04 30 30 f0    	mov    0xf0303004,%ecx
f01061dc:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f01061df:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f01061e1:	a1 04 30 30 f0       	mov    0xf0303004,%eax
f01061e6:	8b 40 20             	mov    0x20(%eax),%eax
}
f01061e9:	c3                   	ret    

f01061ea <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f01061ea:	f3 0f 1e fb          	endbr32 
	if (lapic)
f01061ee:	8b 15 04 30 30 f0    	mov    0xf0303004,%edx
		return lapic[ID] >> 24;
	return 0;
f01061f4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f01061f9:	85 d2                	test   %edx,%edx
f01061fb:	74 06                	je     f0106203 <cpunum+0x19>
		return lapic[ID] >> 24;
f01061fd:	8b 42 20             	mov    0x20(%edx),%eax
f0106200:	c1 e8 18             	shr    $0x18,%eax
}
f0106203:	c3                   	ret    

f0106204 <lapic_init>:
{
f0106204:	f3 0f 1e fb          	endbr32 
	if (!lapicaddr)
f0106208:	a1 00 30 30 f0       	mov    0xf0303000,%eax
f010620d:	85 c0                	test   %eax,%eax
f010620f:	75 01                	jne    f0106212 <lapic_init+0xe>
f0106211:	c3                   	ret    
{
f0106212:	55                   	push   %ebp
f0106213:	89 e5                	mov    %esp,%ebp
f0106215:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0106218:	68 00 10 00 00       	push   $0x1000
f010621d:	50                   	push   %eax
f010621e:	e8 b3 b1 ff ff       	call   f01013d6 <mmio_map_region>
f0106223:	a3 04 30 30 f0       	mov    %eax,0xf0303004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106228:	ba 27 01 00 00       	mov    $0x127,%edx
f010622d:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106232:	e8 9f ff ff ff       	call   f01061d6 <lapicw>
	lapicw(TDCR, X1);
f0106237:	ba 0b 00 00 00       	mov    $0xb,%edx
f010623c:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106241:	e8 90 ff ff ff       	call   f01061d6 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106246:	ba 20 00 02 00       	mov    $0x20020,%edx
f010624b:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106250:	e8 81 ff ff ff       	call   f01061d6 <lapicw>
	lapicw(TICR, 10000000); 
f0106255:	ba 80 96 98 00       	mov    $0x989680,%edx
f010625a:	b8 e0 00 00 00       	mov    $0xe0,%eax
f010625f:	e8 72 ff ff ff       	call   f01061d6 <lapicw>
	if (thiscpu != bootcpu)
f0106264:	e8 81 ff ff ff       	call   f01061ea <cpunum>
f0106269:	6b c0 74             	imul   $0x74,%eax,%eax
f010626c:	05 20 20 2c f0       	add    $0xf02c2020,%eax
f0106271:	83 c4 10             	add    $0x10,%esp
f0106274:	39 05 c0 23 2c f0    	cmp    %eax,0xf02c23c0
f010627a:	74 0f                	je     f010628b <lapic_init+0x87>
		lapicw(LINT0, MASKED);
f010627c:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106281:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106286:	e8 4b ff ff ff       	call   f01061d6 <lapicw>
	lapicw(LINT1, MASKED);
f010628b:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106290:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106295:	e8 3c ff ff ff       	call   f01061d6 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f010629a:	a1 04 30 30 f0       	mov    0xf0303004,%eax
f010629f:	8b 40 30             	mov    0x30(%eax),%eax
f01062a2:	c1 e8 10             	shr    $0x10,%eax
f01062a5:	a8 fc                	test   $0xfc,%al
f01062a7:	75 7c                	jne    f0106325 <lapic_init+0x121>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f01062a9:	ba 33 00 00 00       	mov    $0x33,%edx
f01062ae:	b8 dc 00 00 00       	mov    $0xdc,%eax
f01062b3:	e8 1e ff ff ff       	call   f01061d6 <lapicw>
	lapicw(ESR, 0);
f01062b8:	ba 00 00 00 00       	mov    $0x0,%edx
f01062bd:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01062c2:	e8 0f ff ff ff       	call   f01061d6 <lapicw>
	lapicw(ESR, 0);
f01062c7:	ba 00 00 00 00       	mov    $0x0,%edx
f01062cc:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01062d1:	e8 00 ff ff ff       	call   f01061d6 <lapicw>
	lapicw(EOI, 0);
f01062d6:	ba 00 00 00 00       	mov    $0x0,%edx
f01062db:	b8 2c 00 00 00       	mov    $0x2c,%eax
f01062e0:	e8 f1 fe ff ff       	call   f01061d6 <lapicw>
	lapicw(ICRHI, 0);
f01062e5:	ba 00 00 00 00       	mov    $0x0,%edx
f01062ea:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01062ef:	e8 e2 fe ff ff       	call   f01061d6 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f01062f4:	ba 00 85 08 00       	mov    $0x88500,%edx
f01062f9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01062fe:	e8 d3 fe ff ff       	call   f01061d6 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106303:	8b 15 04 30 30 f0    	mov    0xf0303004,%edx
f0106309:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010630f:	f6 c4 10             	test   $0x10,%ah
f0106312:	75 f5                	jne    f0106309 <lapic_init+0x105>
	lapicw(TPR, 0);
f0106314:	ba 00 00 00 00       	mov    $0x0,%edx
f0106319:	b8 20 00 00 00       	mov    $0x20,%eax
f010631e:	e8 b3 fe ff ff       	call   f01061d6 <lapicw>
}
f0106323:	c9                   	leave  
f0106324:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0106325:	ba 00 00 01 00       	mov    $0x10000,%edx
f010632a:	b8 d0 00 00 00       	mov    $0xd0,%eax
f010632f:	e8 a2 fe ff ff       	call   f01061d6 <lapicw>
f0106334:	e9 70 ff ff ff       	jmp    f01062a9 <lapic_init+0xa5>

f0106339 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f0106339:	f3 0f 1e fb          	endbr32 
	if (lapic)
f010633d:	83 3d 04 30 30 f0 00 	cmpl   $0x0,0xf0303004
f0106344:	74 17                	je     f010635d <lapic_eoi+0x24>
{
f0106346:	55                   	push   %ebp
f0106347:	89 e5                	mov    %esp,%ebp
f0106349:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f010634c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106351:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106356:	e8 7b fe ff ff       	call   f01061d6 <lapicw>
}
f010635b:	c9                   	leave  
f010635c:	c3                   	ret    
f010635d:	c3                   	ret    

f010635e <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f010635e:	f3 0f 1e fb          	endbr32 
f0106362:	55                   	push   %ebp
f0106363:	89 e5                	mov    %esp,%ebp
f0106365:	56                   	push   %esi
f0106366:	53                   	push   %ebx
f0106367:	8b 75 08             	mov    0x8(%ebp),%esi
f010636a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010636d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106372:	ba 70 00 00 00       	mov    $0x70,%edx
f0106377:	ee                   	out    %al,(%dx)
f0106378:	b8 0a 00 00 00       	mov    $0xa,%eax
f010637d:	ba 71 00 00 00       	mov    $0x71,%edx
f0106382:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106383:	83 3d 98 1e 2c f0 00 	cmpl   $0x0,0xf02c1e98
f010638a:	74 7e                	je     f010640a <lapic_startap+0xac>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f010638c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106393:	00 00 
	wrv[1] = addr >> 4;
f0106395:	89 d8                	mov    %ebx,%eax
f0106397:	c1 e8 04             	shr    $0x4,%eax
f010639a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f01063a0:	c1 e6 18             	shl    $0x18,%esi
f01063a3:	89 f2                	mov    %esi,%edx
f01063a5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01063aa:	e8 27 fe ff ff       	call   f01061d6 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f01063af:	ba 00 c5 00 00       	mov    $0xc500,%edx
f01063b4:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01063b9:	e8 18 fe ff ff       	call   f01061d6 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f01063be:	ba 00 85 00 00       	mov    $0x8500,%edx
f01063c3:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01063c8:	e8 09 fe ff ff       	call   f01061d6 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01063cd:	c1 eb 0c             	shr    $0xc,%ebx
f01063d0:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f01063d3:	89 f2                	mov    %esi,%edx
f01063d5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01063da:	e8 f7 fd ff ff       	call   f01061d6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01063df:	89 da                	mov    %ebx,%edx
f01063e1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01063e6:	e8 eb fd ff ff       	call   f01061d6 <lapicw>
		lapicw(ICRHI, apicid << 24);
f01063eb:	89 f2                	mov    %esi,%edx
f01063ed:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01063f2:	e8 df fd ff ff       	call   f01061d6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01063f7:	89 da                	mov    %ebx,%edx
f01063f9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01063fe:	e8 d3 fd ff ff       	call   f01061d6 <lapicw>
		microdelay(200);
	}
}
f0106403:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106406:	5b                   	pop    %ebx
f0106407:	5e                   	pop    %esi
f0106408:	5d                   	pop    %ebp
f0106409:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010640a:	68 67 04 00 00       	push   $0x467
f010640f:	68 24 72 10 f0       	push   $0xf0107224
f0106414:	68 98 00 00 00       	push   $0x98
f0106419:	68 54 8f 10 f0       	push   $0xf0108f54
f010641e:	e8 1d 9c ff ff       	call   f0100040 <_panic>

f0106423 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106423:	f3 0f 1e fb          	endbr32 
f0106427:	55                   	push   %ebp
f0106428:	89 e5                	mov    %esp,%ebp
f010642a:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f010642d:	8b 55 08             	mov    0x8(%ebp),%edx
f0106430:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106436:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010643b:	e8 96 fd ff ff       	call   f01061d6 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106440:	8b 15 04 30 30 f0    	mov    0xf0303004,%edx
f0106446:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010644c:	f6 c4 10             	test   $0x10,%ah
f010644f:	75 f5                	jne    f0106446 <lapic_ipi+0x23>
		;
}
f0106451:	c9                   	leave  
f0106452:	c3                   	ret    

f0106453 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106453:	f3 0f 1e fb          	endbr32 
f0106457:	55                   	push   %ebp
f0106458:	89 e5                	mov    %esp,%ebp
f010645a:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f010645d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106463:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106466:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106469:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106470:	5d                   	pop    %ebp
f0106471:	c3                   	ret    

f0106472 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106472:	f3 0f 1e fb          	endbr32 
f0106476:	55                   	push   %ebp
f0106477:	89 e5                	mov    %esp,%ebp
f0106479:	56                   	push   %esi
f010647a:	53                   	push   %ebx
f010647b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f010647e:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106481:	75 07                	jne    f010648a <spin_lock+0x18>
	asm volatile("lock; xchgl %0, %1"
f0106483:	ba 01 00 00 00       	mov    $0x1,%edx
f0106488:	eb 34                	jmp    f01064be <spin_lock+0x4c>
f010648a:	8b 73 08             	mov    0x8(%ebx),%esi
f010648d:	e8 58 fd ff ff       	call   f01061ea <cpunum>
f0106492:	6b c0 74             	imul   $0x74,%eax,%eax
f0106495:	05 20 20 2c f0       	add    $0xf02c2020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f010649a:	39 c6                	cmp    %eax,%esi
f010649c:	75 e5                	jne    f0106483 <spin_lock+0x11>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f010649e:	8b 5b 04             	mov    0x4(%ebx),%ebx
f01064a1:	e8 44 fd ff ff       	call   f01061ea <cpunum>
f01064a6:	83 ec 0c             	sub    $0xc,%esp
f01064a9:	53                   	push   %ebx
f01064aa:	50                   	push   %eax
f01064ab:	68 64 8f 10 f0       	push   $0xf0108f64
f01064b0:	6a 41                	push   $0x41
f01064b2:	68 c6 8f 10 f0       	push   $0xf0108fc6
f01064b7:	e8 84 9b ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f01064bc:	f3 90                	pause  
f01064be:	89 d0                	mov    %edx,%eax
f01064c0:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f01064c3:	85 c0                	test   %eax,%eax
f01064c5:	75 f5                	jne    f01064bc <spin_lock+0x4a>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f01064c7:	e8 1e fd ff ff       	call   f01061ea <cpunum>
f01064cc:	6b c0 74             	imul   $0x74,%eax,%eax
f01064cf:	05 20 20 2c f0       	add    $0xf02c2020,%eax
f01064d4:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01064d7:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f01064d9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01064de:	83 f8 09             	cmp    $0x9,%eax
f01064e1:	7f 21                	jg     f0106504 <spin_lock+0x92>
f01064e3:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f01064e9:	76 19                	jbe    f0106504 <spin_lock+0x92>
		pcs[i] = ebp[1];          // saved %eip
f01064eb:	8b 4a 04             	mov    0x4(%edx),%ecx
f01064ee:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f01064f2:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f01064f4:	83 c0 01             	add    $0x1,%eax
f01064f7:	eb e5                	jmp    f01064de <spin_lock+0x6c>
		pcs[i] = 0;
f01064f9:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0106500:	00 
	for (; i < 10; i++)
f0106501:	83 c0 01             	add    $0x1,%eax
f0106504:	83 f8 09             	cmp    $0x9,%eax
f0106507:	7e f0                	jle    f01064f9 <spin_lock+0x87>
	get_caller_pcs(lk->pcs);
#endif
}
f0106509:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010650c:	5b                   	pop    %ebx
f010650d:	5e                   	pop    %esi
f010650e:	5d                   	pop    %ebp
f010650f:	c3                   	ret    

f0106510 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106510:	f3 0f 1e fb          	endbr32 
f0106514:	55                   	push   %ebp
f0106515:	89 e5                	mov    %esp,%ebp
f0106517:	57                   	push   %edi
f0106518:	56                   	push   %esi
f0106519:	53                   	push   %ebx
f010651a:	83 ec 4c             	sub    $0x4c,%esp
f010651d:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106520:	83 3e 00             	cmpl   $0x0,(%esi)
f0106523:	75 35                	jne    f010655a <spin_unlock+0x4a>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106525:	83 ec 04             	sub    $0x4,%esp
f0106528:	6a 28                	push   $0x28
f010652a:	8d 46 0c             	lea    0xc(%esi),%eax
f010652d:	50                   	push   %eax
f010652e:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106531:	53                   	push   %ebx
f0106532:	e8 de f6 ff ff       	call   f0105c15 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106537:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f010653a:	0f b6 38             	movzbl (%eax),%edi
f010653d:	8b 76 04             	mov    0x4(%esi),%esi
f0106540:	e8 a5 fc ff ff       	call   f01061ea <cpunum>
f0106545:	57                   	push   %edi
f0106546:	56                   	push   %esi
f0106547:	50                   	push   %eax
f0106548:	68 90 8f 10 f0       	push   $0xf0108f90
f010654d:	e8 e4 d4 ff ff       	call   f0103a36 <cprintf>
f0106552:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106555:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106558:	eb 4e                	jmp    f01065a8 <spin_unlock+0x98>
	return lock->locked && lock->cpu == thiscpu;
f010655a:	8b 5e 08             	mov    0x8(%esi),%ebx
f010655d:	e8 88 fc ff ff       	call   f01061ea <cpunum>
f0106562:	6b c0 74             	imul   $0x74,%eax,%eax
f0106565:	05 20 20 2c f0       	add    $0xf02c2020,%eax
	if (!holding(lk)) {
f010656a:	39 c3                	cmp    %eax,%ebx
f010656c:	75 b7                	jne    f0106525 <spin_unlock+0x15>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f010656e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106575:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f010657c:	b8 00 00 00 00       	mov    $0x0,%eax
f0106581:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106584:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106587:	5b                   	pop    %ebx
f0106588:	5e                   	pop    %esi
f0106589:	5f                   	pop    %edi
f010658a:	5d                   	pop    %ebp
f010658b:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f010658c:	83 ec 08             	sub    $0x8,%esp
f010658f:	ff 36                	pushl  (%esi)
f0106591:	68 ed 8f 10 f0       	push   $0xf0108fed
f0106596:	e8 9b d4 ff ff       	call   f0103a36 <cprintf>
f010659b:	83 c4 10             	add    $0x10,%esp
f010659e:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f01065a1:	8d 45 e8             	lea    -0x18(%ebp),%eax
f01065a4:	39 c3                	cmp    %eax,%ebx
f01065a6:	74 40                	je     f01065e8 <spin_unlock+0xd8>
f01065a8:	89 de                	mov    %ebx,%esi
f01065aa:	8b 03                	mov    (%ebx),%eax
f01065ac:	85 c0                	test   %eax,%eax
f01065ae:	74 38                	je     f01065e8 <spin_unlock+0xd8>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01065b0:	83 ec 08             	sub    $0x8,%esp
f01065b3:	57                   	push   %edi
f01065b4:	50                   	push   %eax
f01065b5:	e8 be ea ff ff       	call   f0105078 <debuginfo_eip>
f01065ba:	83 c4 10             	add    $0x10,%esp
f01065bd:	85 c0                	test   %eax,%eax
f01065bf:	78 cb                	js     f010658c <spin_unlock+0x7c>
					pcs[i] - info.eip_fn_addr);
f01065c1:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f01065c3:	83 ec 04             	sub    $0x4,%esp
f01065c6:	89 c2                	mov    %eax,%edx
f01065c8:	2b 55 b8             	sub    -0x48(%ebp),%edx
f01065cb:	52                   	push   %edx
f01065cc:	ff 75 b0             	pushl  -0x50(%ebp)
f01065cf:	ff 75 b4             	pushl  -0x4c(%ebp)
f01065d2:	ff 75 ac             	pushl  -0x54(%ebp)
f01065d5:	ff 75 a8             	pushl  -0x58(%ebp)
f01065d8:	50                   	push   %eax
f01065d9:	68 d6 8f 10 f0       	push   $0xf0108fd6
f01065de:	e8 53 d4 ff ff       	call   f0103a36 <cprintf>
f01065e3:	83 c4 20             	add    $0x20,%esp
f01065e6:	eb b6                	jmp    f010659e <spin_unlock+0x8e>
		panic("spin_unlock");
f01065e8:	83 ec 04             	sub    $0x4,%esp
f01065eb:	68 f5 8f 10 f0       	push   $0xf0108ff5
f01065f0:	6a 67                	push   $0x67
f01065f2:	68 c6 8f 10 f0       	push   $0xf0108fc6
f01065f7:	e8 44 9a ff ff       	call   f0100040 <_panic>

f01065fc <e1000_attachfn>:

uint32_t E1000_MAC[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};

int
e1000_attachfn(struct pci_func *pcif)
{
f01065fc:	f3 0f 1e fb          	endbr32 
f0106600:	55                   	push   %ebp
f0106601:	89 e5                	mov    %esp,%ebp
f0106603:	57                   	push   %edi
f0106604:	56                   	push   %esi
f0106605:	53                   	push   %ebx
f0106606:	83 ec 28             	sub    $0x28,%esp
f0106609:	8b 5d 08             	mov    0x8(%ebp),%ebx
	pci_func_enable(pcif);
f010660c:	53                   	push   %ebx
f010660d:	e8 b8 07 00 00       	call   f0106dca <pci_func_enable>
	cprintf("reg_base:%x, reg_size:%x\n", pcif->reg_base[0], pcif->reg_size[0]);
f0106612:	83 c4 0c             	add    $0xc,%esp
f0106615:	ff 73 2c             	pushl  0x2c(%ebx)
f0106618:	ff 73 14             	pushl  0x14(%ebx)
f010661b:	68 0d 90 10 f0       	push   $0xf010900d
f0106620:	e8 11 d4 ff ff       	call   f0103a36 <cprintf>
			
	//Exercise4 create virtual memory mapping
	bar_va = mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
f0106625:	83 c4 08             	add    $0x8,%esp
f0106628:	ff 73 2c             	pushl  0x2c(%ebx)
f010662b:	ff 73 14             	pushl  0x14(%ebx)
f010662e:	e8 a3 ad ff ff       	call   f01013d6 <mmio_map_region>
f0106633:	a3 00 ee 30 f0       	mov    %eax,0xf030ee00
	
	uint32_t *status_reg = E1000REG(E1000_STATUS);
	assert(*status_reg == 0x80080783);
f0106638:	83 c4 10             	add    $0x10,%esp
f010663b:	81 78 08 83 07 08 80 	cmpl   $0x80080783,0x8(%eax)
f0106642:	0f 85 2f 02 00 00    	jne    f0106877 <e1000_attachfn+0x27b>
f0106648:	be 40 30 30 f0       	mov    $0xf0303040,%esi
f010664d:	b9 40 30 30 00       	mov    $0x303040,%ecx
f0106652:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106657:	bf 00 ee 30 f0       	mov    $0xf030ee00,%edi
f010665c:	ba 20 ee 30 f0       	mov    $0xf030ee20,%edx
static void
e1000_transmit_init()
{
       int i;
       for (i = 0; i < TXDESCS; i++) {
               tx_desc_array[i].addr = PADDR(tx_buffer_array[i]);
f0106661:	89 75 e4             	mov    %esi,-0x1c(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0106664:	81 fe ff ff ff ef    	cmp    $0xefffffff,%esi
f010666a:	0f 86 1d 02 00 00    	jbe    f010688d <e1000_attachfn+0x291>
f0106670:	89 0a                	mov    %ecx,(%edx)
f0106672:	89 5a 04             	mov    %ebx,0x4(%edx)
               tx_desc_array[i].cmd = 0;
f0106675:	c6 42 0b 00          	movb   $0x0,0xb(%edx)
               tx_desc_array[i].status |= E1000_TXD_STAT_DD;
f0106679:	80 4a 0c 01          	orb    $0x1,0xc(%edx)
f010667d:	81 c6 ee 05 00 00    	add    $0x5ee,%esi
f0106683:	81 c1 ee 05 00 00    	add    $0x5ee,%ecx
f0106689:	83 d3 00             	adc    $0x0,%ebx
f010668c:	83 c2 10             	add    $0x10,%edx
       for (i = 0; i < TXDESCS; i++) {
f010668f:	39 fe                	cmp    %edi,%esi
f0106691:	75 ce                	jne    f0106661 <e1000_attachfn+0x65>
       }
			 //TDLEN register
       struct e1000_tdlen *tdlen = (struct e1000_tdlen *)E1000REG(E1000_TDLEN);
       tdlen->len = TXDESCS;
f0106693:	8b 90 08 38 00 00    	mov    0x3808(%eax),%edx
f0106699:	81 e2 7f 00 f0 ff    	and    $0xfff0007f,%edx
f010669f:	80 ce 10             	or     $0x10,%dh
f01066a2:	89 90 08 38 00 00    	mov    %edx,0x3808(%eax)
f01066a8:	ba 20 ee 30 f0       	mov    $0xf030ee20,%edx
f01066ad:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01066b3:	0f 86 e6 01 00 00    	jbe    f010689f <e1000_attachfn+0x2a3>
	return (physaddr_t)kva - KERNBASE;
f01066b9:	c7 80 00 38 00 00 20 	movl   $0x30ee20,0x3800(%eax)
f01066c0:	ee 30 00 
       uint32_t *tdbal = (uint32_t *)E1000REG(E1000_TDBAL);
       *tdbal = PADDR(tx_desc_array);

			 //TDBAH regsiter
       uint32_t *tdbah = (uint32_t *)E1000REG(E1000_TDBAH);
       *tdbah = 0;
f01066c3:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
f01066ca:	00 00 00 

		   //TDH register, should be init 0
       tdh = (struct e1000_tdh *)E1000REG(E1000_TDH);
f01066cd:	8d 90 10 38 00 00    	lea    0x3810(%eax),%edx
f01066d3:	89 15 20 30 30 f0    	mov    %edx,0xf0303020
       tdh->tdh = 0;
f01066d9:	66 c7 80 10 38 00 00 	movw   $0x0,0x3810(%eax)
f01066e0:	00 00 

		   //TDT register, should be init 0
       tdt = (struct e1000_tdt *)E1000REG(E1000_TDT);
f01066e2:	8d 90 18 38 00 00    	lea    0x3818(%eax),%edx
f01066e8:	89 15 20 f8 30 f0    	mov    %edx,0xf030f820
       tdt->tdt = 0;
f01066ee:	66 c7 80 18 38 00 00 	movw   $0x0,0x3818(%eax)
f01066f5:	00 00 

			 //TCTL register
       struct e1000_tctl *tctl = (struct e1000_tctl *)E1000REG(E1000_TCTL);
       tctl->en = 1;
       tctl->psp = 1;
f01066f7:	80 88 00 04 00 00 0a 	orb    $0xa,0x400(%eax)
       tctl->ct = 0x10;
f01066fe:	0f b7 90 00 04 00 00 	movzwl 0x400(%eax),%edx
f0106705:	66 81 e2 0f f0       	and    $0xf00f,%dx
f010670a:	80 ce 01             	or     $0x1,%dh
f010670d:	66 89 90 00 04 00 00 	mov    %dx,0x400(%eax)
       tctl->cold = 0x40;
f0106714:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f010671a:	81 e2 ff 0f c0 ff    	and    $0xffc00fff,%edx
f0106720:	81 ca 00 00 04 00    	or     $0x40000,%edx
f0106726:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

			 //TIPG register
       struct e1000_tipg *tipg = (struct e1000_tipg *)E1000REG(E1000_TIPG);
       tipg->ipgt = 10;
f010672c:	0f b7 90 10 04 00 00 	movzwl 0x410(%eax),%edx
f0106733:	66 81 e2 00 fc       	and    $0xfc00,%dx
f0106738:	83 ca 0a             	or     $0xa,%edx
f010673b:	66 89 90 10 04 00 00 	mov    %dx,0x410(%eax)
       tipg->ipgr1 = 4;
f0106742:	8b 90 10 04 00 00    	mov    0x410(%eax),%edx
f0106748:	81 e2 ff 03 f0 ff    	and    $0xfff003ff,%edx
f010674e:	89 d1                	mov    %edx,%ecx
f0106750:	80 cd 10             	or     $0x10,%ch
f0106753:	89 88 10 04 00 00    	mov    %ecx,0x410(%eax)
       tipg->ipgr2 = 6;
f0106759:	c1 ea 10             	shr    $0x10,%edx
f010675c:	66 81 e2 0f c0       	and    $0xc00f,%dx
f0106761:	83 ca 60             	or     $0x60,%edx
f0106764:	66 89 90 12 04 00 00 	mov    %dx,0x412(%eax)
	if ((uint32_t)kva < KERNBASE)
f010676b:	be 20 f0 30 f0       	mov    $0xf030f020,%esi
f0106770:	81 fe ff ff ff ef    	cmp    $0xefffffff,%esi
f0106776:	0f 86 35 01 00 00    	jbe    f01068b1 <e1000_attachfn+0x2b5>
	return (physaddr_t)kva - KERNBASE;
f010677c:	c7 80 00 28 00 00 20 	movl   $0x30f020,0x2800(%eax)
f0106783:	f0 30 00 
e1000_receive_init()
{			 //RDBAL and RDBAH register
       uint32_t *rdbal = (uint32_t *)E1000REG(E1000_RDBAL);
       uint32_t *rdbah = (uint32_t *)E1000REG(E1000_RDBAH);
       *rdbal = PADDR(rx_desc_array);
       *rdbah = 0;
f0106786:	c7 80 04 28 00 00 00 	movl   $0x0,0x2804(%eax)
f010678d:	00 00 00 
f0106790:	ba 40 f8 30 f0       	mov    $0xf030f840,%edx
f0106795:	b9 40 f8 30 00       	mov    $0x30f840,%ecx
f010679a:	bb 00 00 00 00       	mov    $0x0,%ebx
f010679f:	bf 40 ef 33 f0       	mov    $0xf033ef40,%edi

       int i;
       for (i = 0; i < RXDESCS; i++) {
               rx_desc_array[i].addr = PADDR(rx_buffer_array[i]);
f01067a4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	if ((uint32_t)kva < KERNBASE)
f01067a7:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01067ad:	0f 86 10 01 00 00    	jbe    f01068c3 <e1000_attachfn+0x2c7>
f01067b3:	89 0e                	mov    %ecx,(%esi)
f01067b5:	89 5e 04             	mov    %ebx,0x4(%esi)
f01067b8:	81 c2 ee 05 00 00    	add    $0x5ee,%edx
f01067be:	81 c1 ee 05 00 00    	add    $0x5ee,%ecx
f01067c4:	83 d3 00             	adc    $0x0,%ebx
f01067c7:	83 c6 10             	add    $0x10,%esi
       for (i = 0; i < RXDESCS; i++) {
f01067ca:	39 fa                	cmp    %edi,%edx
f01067cc:	75 d6                	jne    f01067a4 <e1000_attachfn+0x1a8>
       }
			 //RDLEN register
       struct e1000_rdlen *rdlen = (struct e1000_rdlen *)E1000REG(E1000_RDLEN);
       rdlen->len = RXDESCS;
f01067ce:	8b 90 08 28 00 00    	mov    0x2808(%eax),%edx
f01067d4:	81 e2 7f 00 f0 ff    	and    $0xfff0007f,%edx
f01067da:	80 ce 40             	or     $0x40,%dh
f01067dd:	89 90 08 28 00 00    	mov    %edx,0x2808(%eax)

			 //RDH and RDT register
       rdh = (struct e1000_rdh *)E1000REG(E1000_RDH);
f01067e3:	8d 90 10 28 00 00    	lea    0x2810(%eax),%edx
f01067e9:	89 15 44 ef 33 f0    	mov    %edx,0xf033ef44
       rdt = (struct e1000_rdt *)E1000REG(E1000_RDT);
f01067ef:	8d 90 18 28 00 00    	lea    0x2818(%eax),%edx
f01067f5:	89 15 40 ef 33 f0    	mov    %edx,0xf033ef40
       rdh->rdh = 0;
f01067fb:	66 c7 80 10 28 00 00 	movw   $0x0,0x2810(%eax)
f0106802:	00 00 
       rdt->rdt = RXDESCS-1;
f0106804:	66 c7 80 18 28 00 00 	movw   $0x7f,0x2818(%eax)
f010680b:	7f 00 

       uint32_t *rctl = (uint32_t *)E1000REG(E1000_RCTL);
       *rctl = E1000_RCTL_EN | E1000_RCTL_BAM | E1000_RCTL_SECRC;
f010680d:	c7 80 00 01 00 00 02 	movl   $0x4008002,0x100(%eax)
f0106814:	80 00 04 
               low |= mac[i] << (8 * i);
f0106817:	8b 0d f8 63 12 f0    	mov    0xf01263f8,%ecx
f010681d:	c1 e1 08             	shl    $0x8,%ecx
f0106820:	0b 0d f4 63 12 f0    	or     0xf01263f4,%ecx
f0106826:	8b 1d fc 63 12 f0    	mov    0xf01263fc,%ebx
f010682c:	c1 e3 10             	shl    $0x10,%ebx
f010682f:	09 cb                	or     %ecx,%ebx
               high |= mac[i] << (8 * i);
f0106831:	8b 15 08 64 12 f0    	mov    0xf0126408,%edx
f0106837:	b9 28 00 00 00       	mov    $0x28,%ecx
f010683c:	d3 e2                	shl    %cl,%edx
f010683e:	8b 3d 04 64 12 f0    	mov    0xf0126404,%edi
f0106844:	b9 20 00 00 00       	mov    $0x20,%ecx
f0106849:	d3 e7                	shl    %cl,%edi
f010684b:	09 fa                	or     %edi,%edx
       *rah = high | E1000_RAH_AV;
f010684d:	81 ca 00 00 00 80    	or     $0x80000000,%edx
               low |= mac[i] << (8 * i);
f0106853:	8b 0d 00 64 12 f0    	mov    0xf0126400,%ecx
f0106859:	c1 e1 18             	shl    $0x18,%ecx
f010685c:	09 d9                	or     %ebx,%ecx
f010685e:	89 88 00 54 00 00    	mov    %ecx,0x5400(%eax)

       uint32_t *ra = (uint32_t *)E1000REG(E1000_RA);
       uint32_t ral, rah;
       get_ra_address(E1000_MAC, &ral, &rah);
       ra[0] = ral;
       ra[1] = rah;
f0106864:	89 90 04 54 00 00    	mov    %edx,0x5404(%eax)
}
f010686a:	b8 00 00 00 00       	mov    $0x0,%eax
f010686f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106872:	5b                   	pop    %ebx
f0106873:	5e                   	pop    %esi
f0106874:	5f                   	pop    %edi
f0106875:	5d                   	pop    %ebp
f0106876:	c3                   	ret    
	assert(*status_reg == 0x80080783);
f0106877:	68 27 90 10 f0       	push   $0xf0109027
f010687c:	68 dc 77 10 f0       	push   $0xf01077dc
f0106881:	6a 1f                	push   $0x1f
f0106883:	68 41 90 10 f0       	push   $0xf0109041
f0106888:	e8 b3 97 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010688d:	56                   	push   %esi
f010688e:	68 48 72 10 f0       	push   $0xf0107248
f0106893:	6a 2d                	push   $0x2d
f0106895:	68 41 90 10 f0       	push   $0xf0109041
f010689a:	e8 a1 97 ff ff       	call   f0100040 <_panic>
f010689f:	52                   	push   %edx
f01068a0:	68 48 72 10 f0       	push   $0xf0107248
f01068a5:	6a 37                	push   $0x37
f01068a7:	68 41 90 10 f0       	push   $0xf0109041
f01068ac:	e8 8f 97 ff ff       	call   f0100040 <_panic>
f01068b1:	56                   	push   %esi
f01068b2:	68 48 72 10 f0       	push   $0xf0107248
f01068b7:	6a 6a                	push   $0x6a
f01068b9:	68 41 90 10 f0       	push   $0xf0109041
f01068be:	e8 7d 97 ff ff       	call   f0100040 <_panic>
f01068c3:	52                   	push   %edx
f01068c4:	68 48 72 10 f0       	push   $0xf0107248
f01068c9:	6a 6f                	push   $0x6f
f01068cb:	68 41 90 10 f0       	push   $0xf0109041
f01068d0:	e8 6b 97 ff ff       	call   f0100040 <_panic>

f01068d5 <e1000_transmit>:



int
e1000_transmit(void *data, size_t len)
{
f01068d5:	f3 0f 1e fb          	endbr32 
f01068d9:	55                   	push   %ebp
f01068da:	89 e5                	mov    %esp,%ebp
f01068dc:	53                   	push   %ebx
f01068dd:	83 ec 04             	sub    $0x4,%esp
f01068e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
       uint32_t current = tdt->tdt;		//tail index in queue
f01068e3:	a1 20 f8 30 f0       	mov    0xf030f820,%eax
f01068e8:	0f b7 18             	movzwl (%eax),%ebx
       if(!(tx_desc_array[current].status & E1000_TXD_STAT_DD)) {
f01068eb:	89 d8                	mov    %ebx,%eax
f01068ed:	c1 e0 04             	shl    $0x4,%eax
f01068f0:	0f b6 90 2c ee 30 f0 	movzbl -0xfcf11d4(%eax),%edx
f01068f7:	f6 c2 01             	test   $0x1,%dl
f01068fa:	74 51                	je     f010694d <e1000_transmit+0x78>
               return -E_TRANSMIT_RETRY;
       }
       tx_desc_array[current].length = len;
f01068fc:	89 d8                	mov    %ebx,%eax
f01068fe:	c1 e0 04             	shl    $0x4,%eax
f0106901:	66 89 88 28 ee 30 f0 	mov    %cx,-0xfcf11d8(%eax)
       tx_desc_array[current].status &= ~E1000_TXD_STAT_DD;
f0106908:	83 e2 fe             	and    $0xfffffffe,%edx
f010690b:	88 90 2c ee 30 f0    	mov    %dl,-0xfcf11d4(%eax)
       tx_desc_array[current].length = len;
f0106911:	05 20 ee 30 f0       	add    $0xf030ee20,%eax
       tx_desc_array[current].cmd |= (E1000_TXD_CMD_EOP | E1000_TXD_CMD_RS);
f0106916:	80 48 0b 09          	orb    $0x9,0xb(%eax)
       memcpy(tx_buffer_array[current], data, len);
f010691a:	83 ec 04             	sub    $0x4,%esp
f010691d:	51                   	push   %ecx
f010691e:	ff 75 08             	pushl  0x8(%ebp)
f0106921:	69 c3 ee 05 00 00    	imul   $0x5ee,%ebx,%eax
f0106927:	05 40 30 30 f0       	add    $0xf0303040,%eax
f010692c:	50                   	push   %eax
f010692d:	e8 49 f3 ff ff       	call   f0105c7b <memcpy>
       uint32_t next = (current + 1) % TXDESCS;
f0106932:	83 c3 01             	add    $0x1,%ebx
f0106935:	83 e3 1f             	and    $0x1f,%ebx
       tdt->tdt = next;
f0106938:	a1 20 f8 30 f0       	mov    0xf030f820,%eax
f010693d:	66 89 18             	mov    %bx,(%eax)
       return 0;
f0106940:	83 c4 10             	add    $0x10,%esp
f0106943:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106948:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010694b:	c9                   	leave  
f010694c:	c3                   	ret    
               return -E_TRANSMIT_RETRY;
f010694d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0106952:	eb f4                	jmp    f0106948 <e1000_transmit+0x73>

f0106954 <e1000_receive>:

int
e1000_receive(void *addr, size_t *len)
{
f0106954:	f3 0f 1e fb          	endbr32 
       static int32_t next = 0;
       if(!(rx_desc_array[next].status & E1000_RXD_STAT_DD)) {	//simply tell client to retry
f0106958:	a1 80 1e 2c f0       	mov    0xf02c1e80,%eax
f010695d:	89 c2                	mov    %eax,%edx
f010695f:	c1 e2 04             	shl    $0x4,%edx
f0106962:	f6 82 2c f0 30 f0 01 	testb  $0x1,-0xfcf0fd4(%edx)
f0106969:	0f 84 88 00 00 00    	je     f01069f7 <e1000_receive+0xa3>
{
f010696f:	55                   	push   %ebp
f0106970:	89 e5                	mov    %esp,%ebp
f0106972:	83 ec 08             	sub    $0x8,%esp
               return -E_RECEIVE_RETRY;
       }
       if(rx_desc_array[next].errors) {
f0106975:	89 c2                	mov    %eax,%edx
f0106977:	c1 e2 04             	shl    $0x4,%edx
f010697a:	80 ba 2d f0 30 f0 00 	cmpb   $0x0,-0xfcf0fd3(%edx)
f0106981:	75 5d                	jne    f01069e0 <e1000_receive+0x8c>
               cprintf("receive errors\n");
               return -E_RECEIVE_RETRY;
       }
       *len = rx_desc_array[next].length;
f0106983:	89 c2                	mov    %eax,%edx
f0106985:	c1 e2 04             	shl    $0x4,%edx
f0106988:	0f b7 92 28 f0 30 f0 	movzwl -0xfcf0fd8(%edx),%edx
f010698f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106992:	89 11                	mov    %edx,(%ecx)
       memcpy(addr, rx_buffer_array[next], *len);
f0106994:	83 ec 04             	sub    $0x4,%esp
f0106997:	52                   	push   %edx
f0106998:	69 c0 ee 05 00 00    	imul   $0x5ee,%eax,%eax
f010699e:	05 40 f8 30 f0       	add    $0xf030f840,%eax
f01069a3:	50                   	push   %eax
f01069a4:	ff 75 08             	pushl  0x8(%ebp)
f01069a7:	e8 cf f2 ff ff       	call   f0105c7b <memcpy>

       rdt->rdt = (rdt->rdt + 1) % RXDESCS;
f01069ac:	8b 15 40 ef 33 f0    	mov    0xf033ef40,%edx
f01069b2:	0f b7 02             	movzwl (%edx),%eax
f01069b5:	83 c0 01             	add    $0x1,%eax
f01069b8:	83 e0 7f             	and    $0x7f,%eax
f01069bb:	66 89 02             	mov    %ax,(%edx)
       next = (next + 1) % RXDESCS;
f01069be:	a1 80 1e 2c f0       	mov    0xf02c1e80,%eax
f01069c3:	83 c0 01             	add    $0x1,%eax
f01069c6:	99                   	cltd   
f01069c7:	c1 ea 19             	shr    $0x19,%edx
f01069ca:	01 d0                	add    %edx,%eax
f01069cc:	83 e0 7f             	and    $0x7f,%eax
f01069cf:	29 d0                	sub    %edx,%eax
f01069d1:	a3 80 1e 2c f0       	mov    %eax,0xf02c1e80
       return 0;
f01069d6:	83 c4 10             	add    $0x10,%esp
f01069d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01069de:	c9                   	leave  
f01069df:	c3                   	ret    
               cprintf("receive errors\n");
f01069e0:	83 ec 0c             	sub    $0xc,%esp
f01069e3:	68 4e 90 10 f0       	push   $0xf010904e
f01069e8:	e8 49 d0 ff ff       	call   f0103a36 <cprintf>
               return -E_RECEIVE_RETRY;
f01069ed:	83 c4 10             	add    $0x10,%esp
f01069f0:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01069f5:	eb e7                	jmp    f01069de <e1000_receive+0x8a>
               return -E_RECEIVE_RETRY;
f01069f7:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
f01069fc:	c3                   	ret    

f01069fd <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f01069fd:	55                   	push   %ebp
f01069fe:	89 e5                	mov    %esp,%ebp
f0106a00:	57                   	push   %edi
f0106a01:	56                   	push   %esi
f0106a02:	53                   	push   %ebx
f0106a03:	83 ec 0c             	sub    $0xc,%esp
f0106a06:	8b 7d 08             	mov    0x8(%ebp),%edi
f0106a09:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0106a0c:	eb 03                	jmp    f0106a11 <pci_attach_match+0x14>
f0106a0e:	83 c3 0c             	add    $0xc,%ebx
f0106a11:	89 de                	mov    %ebx,%esi
f0106a13:	8b 43 08             	mov    0x8(%ebx),%eax
f0106a16:	85 c0                	test   %eax,%eax
f0106a18:	74 37                	je     f0106a51 <pci_attach_match+0x54>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0106a1a:	39 3b                	cmp    %edi,(%ebx)
f0106a1c:	75 f0                	jne    f0106a0e <pci_attach_match+0x11>
f0106a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106a21:	39 56 04             	cmp    %edx,0x4(%esi)
f0106a24:	75 e8                	jne    f0106a0e <pci_attach_match+0x11>
			int r = list[i].attachfn(pcif);
f0106a26:	83 ec 0c             	sub    $0xc,%esp
f0106a29:	ff 75 14             	pushl  0x14(%ebp)
f0106a2c:	ff d0                	call   *%eax
			if (r > 0)
f0106a2e:	83 c4 10             	add    $0x10,%esp
f0106a31:	85 c0                	test   %eax,%eax
f0106a33:	7f 1c                	jg     f0106a51 <pci_attach_match+0x54>
				return r;
			if (r < 0)
f0106a35:	79 d7                	jns    f0106a0e <pci_attach_match+0x11>
				cprintf("pci_attach_match: attaching "
f0106a37:	83 ec 0c             	sub    $0xc,%esp
f0106a3a:	50                   	push   %eax
f0106a3b:	ff 76 08             	pushl  0x8(%esi)
f0106a3e:	ff 75 0c             	pushl  0xc(%ebp)
f0106a41:	57                   	push   %edi
f0106a42:	68 60 90 10 f0       	push   $0xf0109060
f0106a47:	e8 ea cf ff ff       	call   f0103a36 <cprintf>
f0106a4c:	83 c4 20             	add    $0x20,%esp
f0106a4f:	eb bd                	jmp    f0106a0e <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0106a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106a54:	5b                   	pop    %ebx
f0106a55:	5e                   	pop    %esi
f0106a56:	5f                   	pop    %edi
f0106a57:	5d                   	pop    %ebp
f0106a58:	c3                   	ret    

f0106a59 <pci_conf1_set_addr>:
{
f0106a59:	55                   	push   %ebp
f0106a5a:	89 e5                	mov    %esp,%ebp
f0106a5c:	53                   	push   %ebx
f0106a5d:	83 ec 04             	sub    $0x4,%esp
f0106a60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f0106a63:	3d ff 00 00 00       	cmp    $0xff,%eax
f0106a68:	77 36                	ja     f0106aa0 <pci_conf1_set_addr+0x47>
	assert(dev < 32);
f0106a6a:	83 fa 1f             	cmp    $0x1f,%edx
f0106a6d:	77 47                	ja     f0106ab6 <pci_conf1_set_addr+0x5d>
	assert(func < 8);
f0106a6f:	83 f9 07             	cmp    $0x7,%ecx
f0106a72:	77 58                	ja     f0106acc <pci_conf1_set_addr+0x73>
	assert(offset < 256);
f0106a74:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0106a7a:	77 66                	ja     f0106ae2 <pci_conf1_set_addr+0x89>
	assert((offset & 0x3) == 0);
f0106a7c:	f6 c3 03             	test   $0x3,%bl
f0106a7f:	75 77                	jne    f0106af8 <pci_conf1_set_addr+0x9f>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0106a81:	c1 e0 10             	shl    $0x10,%eax
f0106a84:	09 d8                	or     %ebx,%eax
f0106a86:	c1 e1 08             	shl    $0x8,%ecx
f0106a89:	09 c8                	or     %ecx,%eax
f0106a8b:	c1 e2 0b             	shl    $0xb,%edx
f0106a8e:	09 d0                	or     %edx,%eax
	uint32_t v = (1 << 31) |		// config-space
f0106a90:	0d 00 00 00 80       	or     $0x80000000,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0106a95:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f0106a9a:	ef                   	out    %eax,(%dx)
}
f0106a9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106a9e:	c9                   	leave  
f0106a9f:	c3                   	ret    
	assert(bus < 256);
f0106aa0:	68 b7 91 10 f0       	push   $0xf01091b7
f0106aa5:	68 dc 77 10 f0       	push   $0xf01077dc
f0106aaa:	6a 2c                	push   $0x2c
f0106aac:	68 c1 91 10 f0       	push   $0xf01091c1
f0106ab1:	e8 8a 95 ff ff       	call   f0100040 <_panic>
	assert(dev < 32);
f0106ab6:	68 cc 91 10 f0       	push   $0xf01091cc
f0106abb:	68 dc 77 10 f0       	push   $0xf01077dc
f0106ac0:	6a 2d                	push   $0x2d
f0106ac2:	68 c1 91 10 f0       	push   $0xf01091c1
f0106ac7:	e8 74 95 ff ff       	call   f0100040 <_panic>
	assert(func < 8);
f0106acc:	68 d5 91 10 f0       	push   $0xf01091d5
f0106ad1:	68 dc 77 10 f0       	push   $0xf01077dc
f0106ad6:	6a 2e                	push   $0x2e
f0106ad8:	68 c1 91 10 f0       	push   $0xf01091c1
f0106add:	e8 5e 95 ff ff       	call   f0100040 <_panic>
	assert(offset < 256);
f0106ae2:	68 de 91 10 f0       	push   $0xf01091de
f0106ae7:	68 dc 77 10 f0       	push   $0xf01077dc
f0106aec:	6a 2f                	push   $0x2f
f0106aee:	68 c1 91 10 f0       	push   $0xf01091c1
f0106af3:	e8 48 95 ff ff       	call   f0100040 <_panic>
	assert((offset & 0x3) == 0);
f0106af8:	68 eb 91 10 f0       	push   $0xf01091eb
f0106afd:	68 dc 77 10 f0       	push   $0xf01077dc
f0106b02:	6a 30                	push   $0x30
f0106b04:	68 c1 91 10 f0       	push   $0xf01091c1
f0106b09:	e8 32 95 ff ff       	call   f0100040 <_panic>

f0106b0e <pci_conf_read>:
{
f0106b0e:	55                   	push   %ebp
f0106b0f:	89 e5                	mov    %esp,%ebp
f0106b11:	53                   	push   %ebx
f0106b12:	83 ec 10             	sub    $0x10,%esp
f0106b15:	89 d3                	mov    %edx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0106b17:	8b 48 08             	mov    0x8(%eax),%ecx
f0106b1a:	8b 50 04             	mov    0x4(%eax),%edx
f0106b1d:	8b 00                	mov    (%eax),%eax
f0106b1f:	8b 40 04             	mov    0x4(%eax),%eax
f0106b22:	53                   	push   %ebx
f0106b23:	e8 31 ff ff ff       	call   f0106a59 <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0106b28:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0106b2d:	ed                   	in     (%dx),%eax
}
f0106b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106b31:	c9                   	leave  
f0106b32:	c3                   	ret    

f0106b33 <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0106b33:	55                   	push   %ebp
f0106b34:	89 e5                	mov    %esp,%ebp
f0106b36:	57                   	push   %edi
f0106b37:	56                   	push   %esi
f0106b38:	53                   	push   %ebx
f0106b39:	81 ec 00 01 00 00    	sub    $0x100,%esp
f0106b3f:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0106b41:	6a 48                	push   $0x48
f0106b43:	6a 00                	push   $0x0
f0106b45:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0106b48:	50                   	push   %eax
f0106b49:	e8 7b f0 ff ff       	call   f0105bc9 <memset>
	df.bus = bus;
f0106b4e:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0106b51:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f0106b58:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f0106b5b:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f0106b62:	00 00 00 
f0106b65:	e9 27 01 00 00       	jmp    f0106c91 <pci_scan_bus+0x15e>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0106b6a:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0106b70:	83 ec 08             	sub    $0x8,%esp
f0106b73:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f0106b77:	57                   	push   %edi
f0106b78:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f0106b79:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0106b7c:	0f b6 c0             	movzbl %al,%eax
f0106b7f:	50                   	push   %eax
f0106b80:	51                   	push   %ecx
f0106b81:	89 d0                	mov    %edx,%eax
f0106b83:	c1 e8 10             	shr    $0x10,%eax
f0106b86:	50                   	push   %eax
f0106b87:	0f b7 d2             	movzwl %dx,%edx
f0106b8a:	52                   	push   %edx
f0106b8b:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f0106b91:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f0106b97:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0106b9d:	ff 70 04             	pushl  0x4(%eax)
f0106ba0:	68 8c 90 10 f0       	push   $0xf010908c
f0106ba5:	e8 8c ce ff ff       	call   f0103a36 <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f0106baa:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f0106bb0:	83 c4 30             	add    $0x30,%esp
f0106bb3:	53                   	push   %ebx
f0106bb4:	68 24 64 12 f0       	push   $0xf0126424
				 PCI_SUBCLASS(f->dev_class),
f0106bb9:	89 c2                	mov    %eax,%edx
f0106bbb:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f0106bbe:	0f b6 d2             	movzbl %dl,%edx
f0106bc1:	52                   	push   %edx
f0106bc2:	c1 e8 18             	shr    $0x18,%eax
f0106bc5:	50                   	push   %eax
f0106bc6:	e8 32 fe ff ff       	call   f01069fd <pci_attach_match>
				 &pci_attach_class[0], f) ||
f0106bcb:	83 c4 10             	add    $0x10,%esp
f0106bce:	85 c0                	test   %eax,%eax
f0106bd0:	0f 84 8a 00 00 00    	je     f0106c60 <pci_scan_bus+0x12d>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0106bd6:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0106bdd:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f0106be3:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f0106be9:	0f 83 94 00 00 00    	jae    f0106c83 <pci_scan_bus+0x150>
			struct pci_func af = f;
f0106bef:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f0106bf5:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f0106bfb:	b9 12 00 00 00       	mov    $0x12,%ecx
f0106c00:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0106c02:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c07:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0106c0d:	e8 fc fe ff ff       	call   f0106b0e <pci_conf_read>
f0106c12:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0106c18:	66 83 f8 ff          	cmp    $0xffff,%ax
f0106c1c:	74 b8                	je     f0106bd6 <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0106c1e:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0106c23:	89 d8                	mov    %ebx,%eax
f0106c25:	e8 e4 fe ff ff       	call   f0106b0e <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0106c2a:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0106c2d:	ba 08 00 00 00       	mov    $0x8,%edx
f0106c32:	89 d8                	mov    %ebx,%eax
f0106c34:	e8 d5 fe ff ff       	call   f0106b0e <pci_conf_read>
f0106c39:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0106c3f:	89 c1                	mov    %eax,%ecx
f0106c41:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f0106c44:	be ff 91 10 f0       	mov    $0xf01091ff,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0106c49:	3d ff ff ff 06       	cmp    $0x6ffffff,%eax
f0106c4e:	0f 87 16 ff ff ff    	ja     f0106b6a <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0106c54:	8b 34 8d 74 92 10 f0 	mov    -0xfef6d8c(,%ecx,4),%esi
f0106c5b:	e9 0a ff ff ff       	jmp    f0106b6a <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f0106c60:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0106c66:	53                   	push   %ebx
f0106c67:	68 0c 64 12 f0       	push   $0xf012640c
f0106c6c:	89 c2                	mov    %eax,%edx
f0106c6e:	c1 ea 10             	shr    $0x10,%edx
f0106c71:	52                   	push   %edx
f0106c72:	0f b7 c0             	movzwl %ax,%eax
f0106c75:	50                   	push   %eax
f0106c76:	e8 82 fd ff ff       	call   f01069fd <pci_attach_match>
f0106c7b:	83 c4 10             	add    $0x10,%esp
f0106c7e:	e9 53 ff ff ff       	jmp    f0106bd6 <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0106c83:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0106c86:	83 c0 01             	add    $0x1,%eax
f0106c89:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0106c8c:	83 f8 1f             	cmp    $0x1f,%eax
f0106c8f:	77 59                	ja     f0106cea <pci_scan_bus+0x1b7>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0106c91:	ba 0c 00 00 00       	mov    $0xc,%edx
f0106c96:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0106c99:	e8 70 fe ff ff       	call   f0106b0e <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0106c9e:	89 c2                	mov    %eax,%edx
f0106ca0:	c1 ea 10             	shr    $0x10,%edx
f0106ca3:	f6 c2 7e             	test   $0x7e,%dl
f0106ca6:	75 db                	jne    f0106c83 <pci_scan_bus+0x150>
		totaldev++;
f0106ca8:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f0106caf:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0106cb5:	8d 75 a0             	lea    -0x60(%ebp),%esi
f0106cb8:	b9 12 00 00 00       	mov    $0x12,%ecx
f0106cbd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0106cbf:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0106cc6:	00 00 00 
f0106cc9:	25 00 00 80 00       	and    $0x800000,%eax
f0106cce:	83 f8 01             	cmp    $0x1,%eax
f0106cd1:	19 c0                	sbb    %eax,%eax
f0106cd3:	83 e0 f9             	and    $0xfffffff9,%eax
f0106cd6:	83 c0 08             	add    $0x8,%eax
f0106cd9:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0106cdf:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0106ce5:	e9 f3 fe ff ff       	jmp    f0106bdd <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f0106cea:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0106cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106cf3:	5b                   	pop    %ebx
f0106cf4:	5e                   	pop    %esi
f0106cf5:	5f                   	pop    %edi
f0106cf6:	5d                   	pop    %ebp
f0106cf7:	c3                   	ret    

f0106cf8 <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f0106cf8:	f3 0f 1e fb          	endbr32 
f0106cfc:	55                   	push   %ebp
f0106cfd:	89 e5                	mov    %esp,%ebp
f0106cff:	57                   	push   %edi
f0106d00:	56                   	push   %esi
f0106d01:	53                   	push   %ebx
f0106d02:	83 ec 1c             	sub    $0x1c,%esp
f0106d05:	8b 75 08             	mov    0x8(%ebp),%esi
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0106d08:	ba 1c 00 00 00       	mov    $0x1c,%edx
f0106d0d:	89 f0                	mov    %esi,%eax
f0106d0f:	e8 fa fd ff ff       	call   f0106b0e <pci_conf_read>
f0106d14:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0106d16:	ba 18 00 00 00       	mov    $0x18,%edx
f0106d1b:	89 f0                	mov    %esi,%eax
f0106d1d:	e8 ec fd ff ff       	call   f0106b0e <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0106d22:	83 e7 0f             	and    $0xf,%edi
f0106d25:	83 ff 01             	cmp    $0x1,%edi
f0106d28:	74 52                	je     f0106d7c <pci_bridge_attach+0x84>
f0106d2a:	89 c3                	mov    %eax,%ebx
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f0106d2c:	83 ec 04             	sub    $0x4,%esp
f0106d2f:	6a 08                	push   $0x8
f0106d31:	6a 00                	push   $0x0
f0106d33:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0106d36:	57                   	push   %edi
f0106d37:	e8 8d ee ff ff       	call   f0105bc9 <memset>
	nbus.parent_bridge = pcif;
f0106d3c:	89 75 e0             	mov    %esi,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f0106d3f:	0f b6 c7             	movzbl %bh,%eax
f0106d42:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0106d45:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f0106d48:	c1 eb 10             	shr    $0x10,%ebx
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0106d4b:	0f b6 db             	movzbl %bl,%ebx
f0106d4e:	53                   	push   %ebx
f0106d4f:	50                   	push   %eax
f0106d50:	ff 76 08             	pushl  0x8(%esi)
f0106d53:	ff 76 04             	pushl  0x4(%esi)
f0106d56:	8b 06                	mov    (%esi),%eax
f0106d58:	ff 70 04             	pushl  0x4(%eax)
f0106d5b:	68 fc 90 10 f0       	push   $0xf01090fc
f0106d60:	e8 d1 cc ff ff       	call   f0103a36 <cprintf>

	pci_scan_bus(&nbus);
f0106d65:	83 c4 20             	add    $0x20,%esp
f0106d68:	89 f8                	mov    %edi,%eax
f0106d6a:	e8 c4 fd ff ff       	call   f0106b33 <pci_scan_bus>
	return 1;
f0106d6f:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0106d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106d77:	5b                   	pop    %ebx
f0106d78:	5e                   	pop    %esi
f0106d79:	5f                   	pop    %edi
f0106d7a:	5d                   	pop    %ebp
f0106d7b:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0106d7c:	ff 76 08             	pushl  0x8(%esi)
f0106d7f:	ff 76 04             	pushl  0x4(%esi)
f0106d82:	8b 06                	mov    (%esi),%eax
f0106d84:	ff 70 04             	pushl  0x4(%eax)
f0106d87:	68 c8 90 10 f0       	push   $0xf01090c8
f0106d8c:	e8 a5 cc ff ff       	call   f0103a36 <cprintf>
		return 0;
f0106d91:	83 c4 10             	add    $0x10,%esp
f0106d94:	b8 00 00 00 00       	mov    $0x0,%eax
f0106d99:	eb d9                	jmp    f0106d74 <pci_bridge_attach+0x7c>

f0106d9b <pci_conf_write>:
{
f0106d9b:	55                   	push   %ebp
f0106d9c:	89 e5                	mov    %esp,%ebp
f0106d9e:	56                   	push   %esi
f0106d9f:	53                   	push   %ebx
f0106da0:	89 d6                	mov    %edx,%esi
f0106da2:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0106da4:	8b 48 08             	mov    0x8(%eax),%ecx
f0106da7:	8b 50 04             	mov    0x4(%eax),%edx
f0106daa:	8b 00                	mov    (%eax),%eax
f0106dac:	8b 40 04             	mov    0x4(%eax),%eax
f0106daf:	83 ec 0c             	sub    $0xc,%esp
f0106db2:	56                   	push   %esi
f0106db3:	e8 a1 fc ff ff       	call   f0106a59 <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0106db8:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0106dbd:	89 d8                	mov    %ebx,%eax
f0106dbf:	ef                   	out    %eax,(%dx)
}
f0106dc0:	83 c4 10             	add    $0x10,%esp
f0106dc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106dc6:	5b                   	pop    %ebx
f0106dc7:	5e                   	pop    %esi
f0106dc8:	5d                   	pop    %ebp
f0106dc9:	c3                   	ret    

f0106dca <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0106dca:	f3 0f 1e fb          	endbr32 
f0106dce:	55                   	push   %ebp
f0106dcf:	89 e5                	mov    %esp,%ebp
f0106dd1:	57                   	push   %edi
f0106dd2:	56                   	push   %esi
f0106dd3:	53                   	push   %ebx
f0106dd4:	83 ec 2c             	sub    $0x2c,%esp
f0106dd7:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0106dda:	b9 07 00 00 00       	mov    $0x7,%ecx
f0106ddf:	ba 04 00 00 00       	mov    $0x4,%edx
f0106de4:	89 f8                	mov    %edi,%eax
f0106de6:	e8 b0 ff ff ff       	call   f0106d9b <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0106deb:	be 10 00 00 00       	mov    $0x10,%esi
f0106df0:	eb 56                	jmp    f0106e48 <pci_func_enable+0x7e>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0106df2:	83 e0 fc             	and    $0xfffffffc,%eax
f0106df5:	f7 d8                	neg    %eax
f0106df7:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f0106df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106dfc:	83 e0 fc             	and    $0xfffffffc,%eax
f0106dff:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f0106e02:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f0106e09:	e9 aa 00 00 00       	jmp    f0106eb8 <pci_func_enable+0xee>
		if (size && !base)
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0106e0e:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0106e11:	83 ec 0c             	sub    $0xc,%esp
f0106e14:	53                   	push   %ebx
f0106e15:	6a 00                	push   $0x0
f0106e17:	ff 75 d4             	pushl  -0x2c(%ebp)
f0106e1a:	89 c2                	mov    %eax,%edx
f0106e1c:	c1 ea 10             	shr    $0x10,%edx
f0106e1f:	52                   	push   %edx
f0106e20:	0f b7 c0             	movzwl %ax,%eax
f0106e23:	50                   	push   %eax
f0106e24:	ff 77 08             	pushl  0x8(%edi)
f0106e27:	ff 77 04             	pushl  0x4(%edi)
f0106e2a:	8b 07                	mov    (%edi),%eax
f0106e2c:	ff 70 04             	pushl  0x4(%eax)
f0106e2f:	68 2c 91 10 f0       	push   $0xf010912c
f0106e34:	e8 fd cb ff ff       	call   f0103a36 <cprintf>
f0106e39:	83 c4 30             	add    $0x30,%esp
	     bar += bar_width)
f0106e3c:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0106e3f:	83 fe 27             	cmp    $0x27,%esi
f0106e42:	0f 87 9f 00 00 00    	ja     f0106ee7 <pci_func_enable+0x11d>
		uint32_t oldv = pci_conf_read(f, bar);
f0106e48:	89 f2                	mov    %esi,%edx
f0106e4a:	89 f8                	mov    %edi,%eax
f0106e4c:	e8 bd fc ff ff       	call   f0106b0e <pci_conf_read>
f0106e51:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f0106e54:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0106e59:	89 f2                	mov    %esi,%edx
f0106e5b:	89 f8                	mov    %edi,%eax
f0106e5d:	e8 39 ff ff ff       	call   f0106d9b <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0106e62:	89 f2                	mov    %esi,%edx
f0106e64:	89 f8                	mov    %edi,%eax
f0106e66:	e8 a3 fc ff ff       	call   f0106b0e <pci_conf_read>
f0106e6b:	89 c3                	mov    %eax,%ebx
		bar_width = 4;
f0106e6d:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f0106e74:	85 c0                	test   %eax,%eax
f0106e76:	74 c4                	je     f0106e3c <pci_func_enable+0x72>
		int regnum = PCI_MAPREG_NUM(bar);
f0106e78:	8d 4e f0             	lea    -0x10(%esi),%ecx
f0106e7b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0106e7e:	c1 e9 02             	shr    $0x2,%ecx
f0106e81:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0106e84:	a8 01                	test   $0x1,%al
f0106e86:	0f 85 66 ff ff ff    	jne    f0106df2 <pci_func_enable+0x28>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0106e8c:	89 c1                	mov    %eax,%ecx
f0106e8e:	83 e1 06             	and    $0x6,%ecx
				bar_width = 8;
f0106e91:	83 f9 04             	cmp    $0x4,%ecx
f0106e94:	0f 94 c1             	sete   %cl
f0106e97:	0f b6 c9             	movzbl %cl,%ecx
f0106e9a:	8d 14 8d 04 00 00 00 	lea    0x4(,%ecx,4),%edx
f0106ea1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f0106ea4:	89 c2                	mov    %eax,%edx
f0106ea6:	83 e2 f0             	and    $0xfffffff0,%edx
f0106ea9:	89 d0                	mov    %edx,%eax
f0106eab:	f7 d8                	neg    %eax
f0106ead:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0106eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106eb2:	83 e0 f0             	and    $0xfffffff0,%eax
f0106eb5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		pci_conf_write(f, bar, oldv);
f0106eb8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0106ebb:	89 f2                	mov    %esi,%edx
f0106ebd:	89 f8                	mov    %edi,%eax
f0106ebf:	e8 d7 fe ff ff       	call   f0106d9b <pci_conf_write>
f0106ec4:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0106ec7:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f0106ec9:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0106ecc:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f0106ecf:	89 58 2c             	mov    %ebx,0x2c(%eax)
		if (size && !base)
f0106ed2:	85 db                	test   %ebx,%ebx
f0106ed4:	0f 84 62 ff ff ff    	je     f0106e3c <pci_func_enable+0x72>
f0106eda:	85 d2                	test   %edx,%edx
f0106edc:	0f 85 5a ff ff ff    	jne    f0106e3c <pci_func_enable+0x72>
f0106ee2:	e9 27 ff ff ff       	jmp    f0106e0e <pci_func_enable+0x44>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f0106ee7:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0106eea:	83 ec 08             	sub    $0x8,%esp
f0106eed:	89 c2                	mov    %eax,%edx
f0106eef:	c1 ea 10             	shr    $0x10,%edx
f0106ef2:	52                   	push   %edx
f0106ef3:	0f b7 c0             	movzwl %ax,%eax
f0106ef6:	50                   	push   %eax
f0106ef7:	ff 77 08             	pushl  0x8(%edi)
f0106efa:	ff 77 04             	pushl  0x4(%edi)
f0106efd:	8b 07                	mov    (%edi),%eax
f0106eff:	ff 70 04             	pushl  0x4(%eax)
f0106f02:	68 88 91 10 f0       	push   $0xf0109188
f0106f07:	e8 2a cb ff ff       	call   f0103a36 <cprintf>
}
f0106f0c:	83 c4 20             	add    $0x20,%esp
f0106f0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106f12:	5b                   	pop    %ebx
f0106f13:	5e                   	pop    %esi
f0106f14:	5f                   	pop    %edi
f0106f15:	5d                   	pop    %ebp
f0106f16:	c3                   	ret    

f0106f17 <pci_init>:

int
pci_init(void)
{
f0106f17:	f3 0f 1e fb          	endbr32 
f0106f1b:	55                   	push   %ebp
f0106f1c:	89 e5                	mov    %esp,%ebp
f0106f1e:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0106f21:	6a 08                	push   $0x8
f0106f23:	6a 00                	push   $0x0
f0106f25:	68 84 1e 2c f0       	push   $0xf02c1e84
f0106f2a:	e8 9a ec ff ff       	call   f0105bc9 <memset>

	return pci_scan_bus(&root_bus);
f0106f2f:	b8 84 1e 2c f0       	mov    $0xf02c1e84,%eax
f0106f34:	e8 fa fb ff ff       	call   f0106b33 <pci_scan_bus>
}
f0106f39:	c9                   	leave  
f0106f3a:	c3                   	ret    

f0106f3b <time_init>:

static unsigned int ticks;

void
time_init(void)
{
f0106f3b:	f3 0f 1e fb          	endbr32 
	ticks = 0;
f0106f3f:	c7 05 8c 1e 2c f0 00 	movl   $0x0,0xf02c1e8c
f0106f46:	00 00 00 
}
f0106f49:	c3                   	ret    

f0106f4a <time_tick>:

// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
f0106f4a:	f3 0f 1e fb          	endbr32 
	ticks++;
f0106f4e:	a1 8c 1e 2c f0       	mov    0xf02c1e8c,%eax
f0106f53:	83 c0 01             	add    $0x1,%eax
f0106f56:	a3 8c 1e 2c f0       	mov    %eax,0xf02c1e8c
	if (ticks * 10 < ticks)
f0106f5b:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0106f5e:	01 d2                	add    %edx,%edx
f0106f60:	39 d0                	cmp    %edx,%eax
f0106f62:	77 01                	ja     f0106f65 <time_tick+0x1b>
f0106f64:	c3                   	ret    
{
f0106f65:	55                   	push   %ebp
f0106f66:	89 e5                	mov    %esp,%ebp
f0106f68:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f0106f6b:	68 90 92 10 f0       	push   $0xf0109290
f0106f70:	6a 13                	push   $0x13
f0106f72:	68 ab 92 10 f0       	push   $0xf01092ab
f0106f77:	e8 c4 90 ff ff       	call   f0100040 <_panic>

f0106f7c <time_msec>:
}

unsigned int
time_msec(void)
{
f0106f7c:	f3 0f 1e fb          	endbr32 
	return ticks * 10;
f0106f80:	a1 8c 1e 2c f0       	mov    0xf02c1e8c,%eax
f0106f85:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0106f88:	01 c0                	add    %eax,%eax
}
f0106f8a:	c3                   	ret    
f0106f8b:	66 90                	xchg   %ax,%ax
f0106f8d:	66 90                	xchg   %ax,%ax
f0106f8f:	90                   	nop

f0106f90 <__udivdi3>:
f0106f90:	f3 0f 1e fb          	endbr32 
f0106f94:	55                   	push   %ebp
f0106f95:	57                   	push   %edi
f0106f96:	56                   	push   %esi
f0106f97:	53                   	push   %ebx
f0106f98:	83 ec 1c             	sub    $0x1c,%esp
f0106f9b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0106f9f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0106fa3:	8b 74 24 34          	mov    0x34(%esp),%esi
f0106fa7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0106fab:	85 d2                	test   %edx,%edx
f0106fad:	75 19                	jne    f0106fc8 <__udivdi3+0x38>
f0106faf:	39 f3                	cmp    %esi,%ebx
f0106fb1:	76 4d                	jbe    f0107000 <__udivdi3+0x70>
f0106fb3:	31 ff                	xor    %edi,%edi
f0106fb5:	89 e8                	mov    %ebp,%eax
f0106fb7:	89 f2                	mov    %esi,%edx
f0106fb9:	f7 f3                	div    %ebx
f0106fbb:	89 fa                	mov    %edi,%edx
f0106fbd:	83 c4 1c             	add    $0x1c,%esp
f0106fc0:	5b                   	pop    %ebx
f0106fc1:	5e                   	pop    %esi
f0106fc2:	5f                   	pop    %edi
f0106fc3:	5d                   	pop    %ebp
f0106fc4:	c3                   	ret    
f0106fc5:	8d 76 00             	lea    0x0(%esi),%esi
f0106fc8:	39 f2                	cmp    %esi,%edx
f0106fca:	76 14                	jbe    f0106fe0 <__udivdi3+0x50>
f0106fcc:	31 ff                	xor    %edi,%edi
f0106fce:	31 c0                	xor    %eax,%eax
f0106fd0:	89 fa                	mov    %edi,%edx
f0106fd2:	83 c4 1c             	add    $0x1c,%esp
f0106fd5:	5b                   	pop    %ebx
f0106fd6:	5e                   	pop    %esi
f0106fd7:	5f                   	pop    %edi
f0106fd8:	5d                   	pop    %ebp
f0106fd9:	c3                   	ret    
f0106fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106fe0:	0f bd fa             	bsr    %edx,%edi
f0106fe3:	83 f7 1f             	xor    $0x1f,%edi
f0106fe6:	75 48                	jne    f0107030 <__udivdi3+0xa0>
f0106fe8:	39 f2                	cmp    %esi,%edx
f0106fea:	72 06                	jb     f0106ff2 <__udivdi3+0x62>
f0106fec:	31 c0                	xor    %eax,%eax
f0106fee:	39 eb                	cmp    %ebp,%ebx
f0106ff0:	77 de                	ja     f0106fd0 <__udivdi3+0x40>
f0106ff2:	b8 01 00 00 00       	mov    $0x1,%eax
f0106ff7:	eb d7                	jmp    f0106fd0 <__udivdi3+0x40>
f0106ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107000:	89 d9                	mov    %ebx,%ecx
f0107002:	85 db                	test   %ebx,%ebx
f0107004:	75 0b                	jne    f0107011 <__udivdi3+0x81>
f0107006:	b8 01 00 00 00       	mov    $0x1,%eax
f010700b:	31 d2                	xor    %edx,%edx
f010700d:	f7 f3                	div    %ebx
f010700f:	89 c1                	mov    %eax,%ecx
f0107011:	31 d2                	xor    %edx,%edx
f0107013:	89 f0                	mov    %esi,%eax
f0107015:	f7 f1                	div    %ecx
f0107017:	89 c6                	mov    %eax,%esi
f0107019:	89 e8                	mov    %ebp,%eax
f010701b:	89 f7                	mov    %esi,%edi
f010701d:	f7 f1                	div    %ecx
f010701f:	89 fa                	mov    %edi,%edx
f0107021:	83 c4 1c             	add    $0x1c,%esp
f0107024:	5b                   	pop    %ebx
f0107025:	5e                   	pop    %esi
f0107026:	5f                   	pop    %edi
f0107027:	5d                   	pop    %ebp
f0107028:	c3                   	ret    
f0107029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107030:	89 f9                	mov    %edi,%ecx
f0107032:	b8 20 00 00 00       	mov    $0x20,%eax
f0107037:	29 f8                	sub    %edi,%eax
f0107039:	d3 e2                	shl    %cl,%edx
f010703b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010703f:	89 c1                	mov    %eax,%ecx
f0107041:	89 da                	mov    %ebx,%edx
f0107043:	d3 ea                	shr    %cl,%edx
f0107045:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107049:	09 d1                	or     %edx,%ecx
f010704b:	89 f2                	mov    %esi,%edx
f010704d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107051:	89 f9                	mov    %edi,%ecx
f0107053:	d3 e3                	shl    %cl,%ebx
f0107055:	89 c1                	mov    %eax,%ecx
f0107057:	d3 ea                	shr    %cl,%edx
f0107059:	89 f9                	mov    %edi,%ecx
f010705b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010705f:	89 eb                	mov    %ebp,%ebx
f0107061:	d3 e6                	shl    %cl,%esi
f0107063:	89 c1                	mov    %eax,%ecx
f0107065:	d3 eb                	shr    %cl,%ebx
f0107067:	09 de                	or     %ebx,%esi
f0107069:	89 f0                	mov    %esi,%eax
f010706b:	f7 74 24 08          	divl   0x8(%esp)
f010706f:	89 d6                	mov    %edx,%esi
f0107071:	89 c3                	mov    %eax,%ebx
f0107073:	f7 64 24 0c          	mull   0xc(%esp)
f0107077:	39 d6                	cmp    %edx,%esi
f0107079:	72 15                	jb     f0107090 <__udivdi3+0x100>
f010707b:	89 f9                	mov    %edi,%ecx
f010707d:	d3 e5                	shl    %cl,%ebp
f010707f:	39 c5                	cmp    %eax,%ebp
f0107081:	73 04                	jae    f0107087 <__udivdi3+0xf7>
f0107083:	39 d6                	cmp    %edx,%esi
f0107085:	74 09                	je     f0107090 <__udivdi3+0x100>
f0107087:	89 d8                	mov    %ebx,%eax
f0107089:	31 ff                	xor    %edi,%edi
f010708b:	e9 40 ff ff ff       	jmp    f0106fd0 <__udivdi3+0x40>
f0107090:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0107093:	31 ff                	xor    %edi,%edi
f0107095:	e9 36 ff ff ff       	jmp    f0106fd0 <__udivdi3+0x40>
f010709a:	66 90                	xchg   %ax,%ax
f010709c:	66 90                	xchg   %ax,%ax
f010709e:	66 90                	xchg   %ax,%ax

f01070a0 <__umoddi3>:
f01070a0:	f3 0f 1e fb          	endbr32 
f01070a4:	55                   	push   %ebp
f01070a5:	57                   	push   %edi
f01070a6:	56                   	push   %esi
f01070a7:	53                   	push   %ebx
f01070a8:	83 ec 1c             	sub    $0x1c,%esp
f01070ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01070af:	8b 74 24 30          	mov    0x30(%esp),%esi
f01070b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01070b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01070bb:	85 c0                	test   %eax,%eax
f01070bd:	75 19                	jne    f01070d8 <__umoddi3+0x38>
f01070bf:	39 df                	cmp    %ebx,%edi
f01070c1:	76 5d                	jbe    f0107120 <__umoddi3+0x80>
f01070c3:	89 f0                	mov    %esi,%eax
f01070c5:	89 da                	mov    %ebx,%edx
f01070c7:	f7 f7                	div    %edi
f01070c9:	89 d0                	mov    %edx,%eax
f01070cb:	31 d2                	xor    %edx,%edx
f01070cd:	83 c4 1c             	add    $0x1c,%esp
f01070d0:	5b                   	pop    %ebx
f01070d1:	5e                   	pop    %esi
f01070d2:	5f                   	pop    %edi
f01070d3:	5d                   	pop    %ebp
f01070d4:	c3                   	ret    
f01070d5:	8d 76 00             	lea    0x0(%esi),%esi
f01070d8:	89 f2                	mov    %esi,%edx
f01070da:	39 d8                	cmp    %ebx,%eax
f01070dc:	76 12                	jbe    f01070f0 <__umoddi3+0x50>
f01070de:	89 f0                	mov    %esi,%eax
f01070e0:	89 da                	mov    %ebx,%edx
f01070e2:	83 c4 1c             	add    $0x1c,%esp
f01070e5:	5b                   	pop    %ebx
f01070e6:	5e                   	pop    %esi
f01070e7:	5f                   	pop    %edi
f01070e8:	5d                   	pop    %ebp
f01070e9:	c3                   	ret    
f01070ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01070f0:	0f bd e8             	bsr    %eax,%ebp
f01070f3:	83 f5 1f             	xor    $0x1f,%ebp
f01070f6:	75 50                	jne    f0107148 <__umoddi3+0xa8>
f01070f8:	39 d8                	cmp    %ebx,%eax
f01070fa:	0f 82 e0 00 00 00    	jb     f01071e0 <__umoddi3+0x140>
f0107100:	89 d9                	mov    %ebx,%ecx
f0107102:	39 f7                	cmp    %esi,%edi
f0107104:	0f 86 d6 00 00 00    	jbe    f01071e0 <__umoddi3+0x140>
f010710a:	89 d0                	mov    %edx,%eax
f010710c:	89 ca                	mov    %ecx,%edx
f010710e:	83 c4 1c             	add    $0x1c,%esp
f0107111:	5b                   	pop    %ebx
f0107112:	5e                   	pop    %esi
f0107113:	5f                   	pop    %edi
f0107114:	5d                   	pop    %ebp
f0107115:	c3                   	ret    
f0107116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010711d:	8d 76 00             	lea    0x0(%esi),%esi
f0107120:	89 fd                	mov    %edi,%ebp
f0107122:	85 ff                	test   %edi,%edi
f0107124:	75 0b                	jne    f0107131 <__umoddi3+0x91>
f0107126:	b8 01 00 00 00       	mov    $0x1,%eax
f010712b:	31 d2                	xor    %edx,%edx
f010712d:	f7 f7                	div    %edi
f010712f:	89 c5                	mov    %eax,%ebp
f0107131:	89 d8                	mov    %ebx,%eax
f0107133:	31 d2                	xor    %edx,%edx
f0107135:	f7 f5                	div    %ebp
f0107137:	89 f0                	mov    %esi,%eax
f0107139:	f7 f5                	div    %ebp
f010713b:	89 d0                	mov    %edx,%eax
f010713d:	31 d2                	xor    %edx,%edx
f010713f:	eb 8c                	jmp    f01070cd <__umoddi3+0x2d>
f0107141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107148:	89 e9                	mov    %ebp,%ecx
f010714a:	ba 20 00 00 00       	mov    $0x20,%edx
f010714f:	29 ea                	sub    %ebp,%edx
f0107151:	d3 e0                	shl    %cl,%eax
f0107153:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107157:	89 d1                	mov    %edx,%ecx
f0107159:	89 f8                	mov    %edi,%eax
f010715b:	d3 e8                	shr    %cl,%eax
f010715d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107161:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107165:	8b 54 24 04          	mov    0x4(%esp),%edx
f0107169:	09 c1                	or     %eax,%ecx
f010716b:	89 d8                	mov    %ebx,%eax
f010716d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107171:	89 e9                	mov    %ebp,%ecx
f0107173:	d3 e7                	shl    %cl,%edi
f0107175:	89 d1                	mov    %edx,%ecx
f0107177:	d3 e8                	shr    %cl,%eax
f0107179:	89 e9                	mov    %ebp,%ecx
f010717b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010717f:	d3 e3                	shl    %cl,%ebx
f0107181:	89 c7                	mov    %eax,%edi
f0107183:	89 d1                	mov    %edx,%ecx
f0107185:	89 f0                	mov    %esi,%eax
f0107187:	d3 e8                	shr    %cl,%eax
f0107189:	89 e9                	mov    %ebp,%ecx
f010718b:	89 fa                	mov    %edi,%edx
f010718d:	d3 e6                	shl    %cl,%esi
f010718f:	09 d8                	or     %ebx,%eax
f0107191:	f7 74 24 08          	divl   0x8(%esp)
f0107195:	89 d1                	mov    %edx,%ecx
f0107197:	89 f3                	mov    %esi,%ebx
f0107199:	f7 64 24 0c          	mull   0xc(%esp)
f010719d:	89 c6                	mov    %eax,%esi
f010719f:	89 d7                	mov    %edx,%edi
f01071a1:	39 d1                	cmp    %edx,%ecx
f01071a3:	72 06                	jb     f01071ab <__umoddi3+0x10b>
f01071a5:	75 10                	jne    f01071b7 <__umoddi3+0x117>
f01071a7:	39 c3                	cmp    %eax,%ebx
f01071a9:	73 0c                	jae    f01071b7 <__umoddi3+0x117>
f01071ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
f01071af:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01071b3:	89 d7                	mov    %edx,%edi
f01071b5:	89 c6                	mov    %eax,%esi
f01071b7:	89 ca                	mov    %ecx,%edx
f01071b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01071be:	29 f3                	sub    %esi,%ebx
f01071c0:	19 fa                	sbb    %edi,%edx
f01071c2:	89 d0                	mov    %edx,%eax
f01071c4:	d3 e0                	shl    %cl,%eax
f01071c6:	89 e9                	mov    %ebp,%ecx
f01071c8:	d3 eb                	shr    %cl,%ebx
f01071ca:	d3 ea                	shr    %cl,%edx
f01071cc:	09 d8                	or     %ebx,%eax
f01071ce:	83 c4 1c             	add    $0x1c,%esp
f01071d1:	5b                   	pop    %ebx
f01071d2:	5e                   	pop    %esi
f01071d3:	5f                   	pop    %edi
f01071d4:	5d                   	pop    %ebp
f01071d5:	c3                   	ret    
f01071d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01071dd:	8d 76 00             	lea    0x0(%esi),%esi
f01071e0:	29 fe                	sub    %edi,%esi
f01071e2:	19 c3                	sbb    %eax,%ebx
f01071e4:	89 f2                	mov    %esi,%edx
f01071e6:	89 d9                	mov    %ebx,%ecx
f01071e8:	e9 1d ff ff ff       	jmp    f010710a <__umoddi3+0x6a>
