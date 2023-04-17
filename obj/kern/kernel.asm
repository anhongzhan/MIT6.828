
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
f010004c:	83 3d 80 7e 21 f0 00 	cmpl   $0x0,0xf0217e80
f0100053:	74 0f                	je     f0100064 <_panic+0x24>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100055:	83 ec 0c             	sub    $0xc,%esp
f0100058:	6a 00                	push   $0x0
f010005a:	e8 1d 09 00 00       	call   f010097c <monitor>
f010005f:	83 c4 10             	add    $0x10,%esp
f0100062:	eb f1                	jmp    f0100055 <_panic+0x15>
	panicstr = fmt;
f0100064:	89 35 80 7e 21 f0    	mov    %esi,0xf0217e80
	asm volatile("cli; cld");
f010006a:	fa                   	cli    
f010006b:	fc                   	cld    
	va_start(ap, fmt);
f010006c:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006f:	e8 ee 60 00 00       	call   f0106162 <cpunum>
f0100074:	ff 75 0c             	pushl  0xc(%ebp)
f0100077:	ff 75 08             	pushl  0x8(%ebp)
f010007a:	50                   	push   %eax
f010007b:	68 e0 67 10 f0       	push   $0xf01067e0
f0100080:	e8 82 39 00 00       	call   f0103a07 <cprintf>
	vcprintf(fmt, ap);
f0100085:	83 c4 08             	add    $0x8,%esp
f0100088:	53                   	push   %ebx
f0100089:	56                   	push   %esi
f010008a:	e8 4e 39 00 00       	call   f01039dd <vcprintf>
	cprintf("\n");
f010008f:	c7 04 24 76 70 10 f0 	movl   $0xf0107076,(%esp)
f0100096:	e8 6c 39 00 00       	call   f0103a07 <cprintf>
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
f01000ab:	e8 a9 05 00 00       	call   f0100659 <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000b0:	83 ec 08             	sub    $0x8,%esp
f01000b3:	68 ac 1a 00 00       	push   $0x1aac
f01000b8:	68 4c 68 10 f0       	push   $0xf010684c
f01000bd:	e8 45 39 00 00       	call   f0103a07 <cprintf>
	mem_init();
f01000c2:	e8 5d 13 00 00       	call   f0101424 <mem_init>
	env_init();
f01000c7:	e8 7b 31 00 00       	call   f0103247 <env_init>
	trap_init();
f01000cc:	e8 1f 3a 00 00       	call   f0103af0 <trap_init>
	mp_init();
f01000d1:	e8 8d 5d 00 00       	call   f0105e63 <mp_init>
	lapic_init();
f01000d6:	e8 a1 60 00 00       	call   f010617c <lapic_init>
	pic_init();
f01000db:	e8 3c 38 00 00       	call   f010391c <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000e0:	c7 04 24 c0 33 12 f0 	movl   $0xf01233c0,(%esp)
f01000e7:	e8 fe 62 00 00       	call   f01063ea <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000ec:	83 c4 10             	add    $0x10,%esp
f01000ef:	83 3d 88 7e 21 f0 07 	cmpl   $0x7,0xf0217e88
f01000f6:	76 27                	jbe    f010011f <i386_init+0x7f>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01000f8:	83 ec 04             	sub    $0x4,%esp
f01000fb:	b8 c6 5d 10 f0       	mov    $0xf0105dc6,%eax
f0100100:	2d 4c 5d 10 f0       	sub    $0xf0105d4c,%eax
f0100105:	50                   	push   %eax
f0100106:	68 4c 5d 10 f0       	push   $0xf0105d4c
f010010b:	68 00 70 00 f0       	push   $0xf0007000
f0100110:	e8 79 5a 00 00       	call   f0105b8e <memmove>
	for (c = cpus; c < cpus + ncpu; c++) {
f0100115:	83 c4 10             	add    $0x10,%esp
f0100118:	bb 20 80 21 f0       	mov    $0xf0218020,%ebx
f010011d:	eb 53                	jmp    f0100172 <i386_init+0xd2>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010011f:	68 00 70 00 00       	push   $0x7000
f0100124:	68 04 68 10 f0       	push   $0xf0106804
f0100129:	6a 57                	push   $0x57
f010012b:	68 67 68 10 f0       	push   $0xf0106867
f0100130:	e8 0b ff ff ff       	call   f0100040 <_panic>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100135:	89 d8                	mov    %ebx,%eax
f0100137:	2d 20 80 21 f0       	sub    $0xf0218020,%eax
f010013c:	c1 f8 02             	sar    $0x2,%eax
f010013f:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100145:	c1 e0 0f             	shl    $0xf,%eax
f0100148:	8d 80 00 10 22 f0    	lea    -0xfddf000(%eax),%eax
f010014e:	a3 84 7e 21 f0       	mov    %eax,0xf0217e84
		lapic_startap(c->cpu_id, PADDR(code));
f0100153:	83 ec 08             	sub    $0x8,%esp
f0100156:	68 00 70 00 00       	push   $0x7000
f010015b:	0f b6 03             	movzbl (%ebx),%eax
f010015e:	50                   	push   %eax
f010015f:	e8 72 61 00 00       	call   f01062d6 <lapic_startap>
		while(c->cpu_status != CPU_STARTED)
f0100164:	83 c4 10             	add    $0x10,%esp
f0100167:	8b 43 04             	mov    0x4(%ebx),%eax
f010016a:	83 f8 01             	cmp    $0x1,%eax
f010016d:	75 f8                	jne    f0100167 <i386_init+0xc7>
	for (c = cpus; c < cpus + ncpu; c++) {
f010016f:	83 c3 74             	add    $0x74,%ebx
f0100172:	6b 05 c4 83 21 f0 74 	imul   $0x74,0xf02183c4,%eax
f0100179:	05 20 80 21 f0       	add    $0xf0218020,%eax
f010017e:	39 c3                	cmp    %eax,%ebx
f0100180:	73 13                	jae    f0100195 <i386_init+0xf5>
		if (c == cpus + cpunum())  // We've started already.
f0100182:	e8 db 5f 00 00       	call   f0106162 <cpunum>
f0100187:	6b c0 74             	imul   $0x74,%eax,%eax
f010018a:	05 20 80 21 f0       	add    $0xf0218020,%eax
f010018f:	39 c3                	cmp    %eax,%ebx
f0100191:	74 dc                	je     f010016f <i386_init+0xcf>
f0100193:	eb a0                	jmp    f0100135 <i386_init+0x95>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f0100195:	83 ec 08             	sub    $0x8,%esp
f0100198:	6a 01                	push   $0x1
f010019a:	68 a8 38 1d f0       	push   $0xf01d38a8
f010019f:	e8 45 32 00 00       	call   f01033e9 <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001a4:	83 c4 08             	add    $0x8,%esp
f01001a7:	6a 00                	push   $0x0
f01001a9:	68 50 68 20 f0       	push   $0xf0206850
f01001ae:	e8 36 32 00 00       	call   f01033e9 <env_create>
	kbd_intr();
f01001b3:	e8 45 04 00 00       	call   f01005fd <kbd_intr>
	sched_yield();
f01001b8:	e8 9c 46 00 00       	call   f0104859 <sched_yield>

f01001bd <mp_main>:
{
f01001bd:	f3 0f 1e fb          	endbr32 
f01001c1:	55                   	push   %ebp
f01001c2:	89 e5                	mov    %esp,%ebp
f01001c4:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001c7:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01001cc:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001d1:	76 52                	jbe    f0100225 <mp_main+0x68>
	return (physaddr_t)kva - KERNBASE;
f01001d3:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001d8:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001db:	e8 82 5f 00 00       	call   f0106162 <cpunum>
f01001e0:	83 ec 08             	sub    $0x8,%esp
f01001e3:	50                   	push   %eax
f01001e4:	68 73 68 10 f0       	push   $0xf0106873
f01001e9:	e8 19 38 00 00       	call   f0103a07 <cprintf>
	lapic_init();
f01001ee:	e8 89 5f 00 00       	call   f010617c <lapic_init>
	env_init_percpu();
f01001f3:	e8 1f 30 00 00       	call   f0103217 <env_init_percpu>
	trap_init_percpu();
f01001f8:	e8 22 38 00 00       	call   f0103a1f <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01001fd:	e8 60 5f 00 00       	call   f0106162 <cpunum>
f0100202:	6b d0 74             	imul   $0x74,%eax,%edx
f0100205:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100208:	b8 01 00 00 00       	mov    $0x1,%eax
f010020d:	f0 87 82 20 80 21 f0 	lock xchg %eax,-0xfde7fe0(%edx)
f0100214:	c7 04 24 c0 33 12 f0 	movl   $0xf01233c0,(%esp)
f010021b:	e8 ca 61 00 00       	call   f01063ea <spin_lock>
	sched_yield();
f0100220:	e8 34 46 00 00       	call   f0104859 <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100225:	50                   	push   %eax
f0100226:	68 28 68 10 f0       	push   $0xf0106828
f010022b:	6a 6f                	push   $0x6f
f010022d:	68 67 68 10 f0       	push   $0xf0106867
f0100232:	e8 09 fe ff ff       	call   f0100040 <_panic>

f0100237 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100237:	f3 0f 1e fb          	endbr32 
f010023b:	55                   	push   %ebp
f010023c:	89 e5                	mov    %esp,%ebp
f010023e:	53                   	push   %ebx
f010023f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100242:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100245:	ff 75 0c             	pushl  0xc(%ebp)
f0100248:	ff 75 08             	pushl  0x8(%ebp)
f010024b:	68 89 68 10 f0       	push   $0xf0106889
f0100250:	e8 b2 37 00 00       	call   f0103a07 <cprintf>
	vcprintf(fmt, ap);
f0100255:	83 c4 08             	add    $0x8,%esp
f0100258:	53                   	push   %ebx
f0100259:	ff 75 10             	pushl  0x10(%ebp)
f010025c:	e8 7c 37 00 00       	call   f01039dd <vcprintf>
	cprintf("\n");
f0100261:	c7 04 24 76 70 10 f0 	movl   $0xf0107076,(%esp)
f0100268:	e8 9a 37 00 00       	call   f0103a07 <cprintf>
	va_end(ap);
}
f010026d:	83 c4 10             	add    $0x10,%esp
f0100270:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100273:	c9                   	leave  
f0100274:	c3                   	ret    

f0100275 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100275:	f3 0f 1e fb          	endbr32 
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100279:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010027e:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010027f:	a8 01                	test   $0x1,%al
f0100281:	74 0a                	je     f010028d <serial_proc_data+0x18>
f0100283:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100288:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100289:	0f b6 c0             	movzbl %al,%eax
f010028c:	c3                   	ret    
		return -1;
f010028d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100292:	c3                   	ret    

f0100293 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100293:	55                   	push   %ebp
f0100294:	89 e5                	mov    %esp,%ebp
f0100296:	53                   	push   %ebx
f0100297:	83 ec 04             	sub    $0x4,%esp
f010029a:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f010029c:	ff d3                	call   *%ebx
f010029e:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002a1:	74 29                	je     f01002cc <cons_intr+0x39>
		if (c == 0)
f01002a3:	85 c0                	test   %eax,%eax
f01002a5:	74 f5                	je     f010029c <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002a7:	8b 0d 24 72 21 f0    	mov    0xf0217224,%ecx
f01002ad:	8d 51 01             	lea    0x1(%ecx),%edx
f01002b0:	88 81 20 70 21 f0    	mov    %al,-0xfde8fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002b6:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002bc:	b8 00 00 00 00       	mov    $0x0,%eax
f01002c1:	0f 44 d0             	cmove  %eax,%edx
f01002c4:	89 15 24 72 21 f0    	mov    %edx,0xf0217224
f01002ca:	eb d0                	jmp    f010029c <cons_intr+0x9>
	}
}
f01002cc:	83 c4 04             	add    $0x4,%esp
f01002cf:	5b                   	pop    %ebx
f01002d0:	5d                   	pop    %ebp
f01002d1:	c3                   	ret    

f01002d2 <kbd_proc_data>:
{
f01002d2:	f3 0f 1e fb          	endbr32 
f01002d6:	55                   	push   %ebp
f01002d7:	89 e5                	mov    %esp,%ebp
f01002d9:	53                   	push   %ebx
f01002da:	83 ec 04             	sub    $0x4,%esp
f01002dd:	ba 64 00 00 00       	mov    $0x64,%edx
f01002e2:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002e3:	a8 01                	test   $0x1,%al
f01002e5:	0f 84 f2 00 00 00    	je     f01003dd <kbd_proc_data+0x10b>
	if (stat & KBS_TERR)
f01002eb:	a8 20                	test   $0x20,%al
f01002ed:	0f 85 f1 00 00 00    	jne    f01003e4 <kbd_proc_data+0x112>
f01002f3:	ba 60 00 00 00       	mov    $0x60,%edx
f01002f8:	ec                   	in     (%dx),%al
f01002f9:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002fb:	3c e0                	cmp    $0xe0,%al
f01002fd:	74 61                	je     f0100360 <kbd_proc_data+0x8e>
	} else if (data & 0x80) {
f01002ff:	84 c0                	test   %al,%al
f0100301:	78 70                	js     f0100373 <kbd_proc_data+0xa1>
	} else if (shift & E0ESC) {
f0100303:	8b 0d 00 70 21 f0    	mov    0xf0217000,%ecx
f0100309:	f6 c1 40             	test   $0x40,%cl
f010030c:	74 0e                	je     f010031c <kbd_proc_data+0x4a>
		data |= 0x80;
f010030e:	83 c8 80             	or     $0xffffff80,%eax
f0100311:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100313:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100316:	89 0d 00 70 21 f0    	mov    %ecx,0xf0217000
	shift |= shiftcode[data];
f010031c:	0f b6 d2             	movzbl %dl,%edx
f010031f:	0f b6 82 00 6a 10 f0 	movzbl -0xfef9600(%edx),%eax
f0100326:	0b 05 00 70 21 f0    	or     0xf0217000,%eax
	shift ^= togglecode[data];
f010032c:	0f b6 8a 00 69 10 f0 	movzbl -0xfef9700(%edx),%ecx
f0100333:	31 c8                	xor    %ecx,%eax
f0100335:	a3 00 70 21 f0       	mov    %eax,0xf0217000
	c = charcode[shift & (CTL | SHIFT)][data];
f010033a:	89 c1                	mov    %eax,%ecx
f010033c:	83 e1 03             	and    $0x3,%ecx
f010033f:	8b 0c 8d e0 68 10 f0 	mov    -0xfef9720(,%ecx,4),%ecx
f0100346:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f010034a:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f010034d:	a8 08                	test   $0x8,%al
f010034f:	74 61                	je     f01003b2 <kbd_proc_data+0xe0>
		if ('a' <= c && c <= 'z')
f0100351:	89 da                	mov    %ebx,%edx
f0100353:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100356:	83 f9 19             	cmp    $0x19,%ecx
f0100359:	77 4b                	ja     f01003a6 <kbd_proc_data+0xd4>
			c += 'A' - 'a';
f010035b:	83 eb 20             	sub    $0x20,%ebx
f010035e:	eb 0c                	jmp    f010036c <kbd_proc_data+0x9a>
		shift |= E0ESC;
f0100360:	83 0d 00 70 21 f0 40 	orl    $0x40,0xf0217000
		return 0;
f0100367:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f010036c:	89 d8                	mov    %ebx,%eax
f010036e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100371:	c9                   	leave  
f0100372:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100373:	8b 0d 00 70 21 f0    	mov    0xf0217000,%ecx
f0100379:	89 cb                	mov    %ecx,%ebx
f010037b:	83 e3 40             	and    $0x40,%ebx
f010037e:	83 e0 7f             	and    $0x7f,%eax
f0100381:	85 db                	test   %ebx,%ebx
f0100383:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100386:	0f b6 d2             	movzbl %dl,%edx
f0100389:	0f b6 82 00 6a 10 f0 	movzbl -0xfef9600(%edx),%eax
f0100390:	83 c8 40             	or     $0x40,%eax
f0100393:	0f b6 c0             	movzbl %al,%eax
f0100396:	f7 d0                	not    %eax
f0100398:	21 c8                	and    %ecx,%eax
f010039a:	a3 00 70 21 f0       	mov    %eax,0xf0217000
		return 0;
f010039f:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003a4:	eb c6                	jmp    f010036c <kbd_proc_data+0x9a>
		else if ('A' <= c && c <= 'Z')
f01003a6:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003a9:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003ac:	83 fa 1a             	cmp    $0x1a,%edx
f01003af:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01003b2:	f7 d0                	not    %eax
f01003b4:	a8 06                	test   $0x6,%al
f01003b6:	75 b4                	jne    f010036c <kbd_proc_data+0x9a>
f01003b8:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01003be:	75 ac                	jne    f010036c <kbd_proc_data+0x9a>
		cprintf("Rebooting!\n");
f01003c0:	83 ec 0c             	sub    $0xc,%esp
f01003c3:	68 a3 68 10 f0       	push   $0xf01068a3
f01003c8:	e8 3a 36 00 00       	call   f0103a07 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003cd:	b8 03 00 00 00       	mov    $0x3,%eax
f01003d2:	ba 92 00 00 00       	mov    $0x92,%edx
f01003d7:	ee                   	out    %al,(%dx)
}
f01003d8:	83 c4 10             	add    $0x10,%esp
f01003db:	eb 8f                	jmp    f010036c <kbd_proc_data+0x9a>
		return -1;
f01003dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003e2:	eb 88                	jmp    f010036c <kbd_proc_data+0x9a>
		return -1;
f01003e4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003e9:	eb 81                	jmp    f010036c <kbd_proc_data+0x9a>

f01003eb <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003eb:	55                   	push   %ebp
f01003ec:	89 e5                	mov    %esp,%ebp
f01003ee:	57                   	push   %edi
f01003ef:	56                   	push   %esi
f01003f0:	53                   	push   %ebx
f01003f1:	83 ec 1c             	sub    $0x1c,%esp
f01003f4:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f01003f6:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003fb:	bf fd 03 00 00       	mov    $0x3fd,%edi
f0100400:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100405:	89 fa                	mov    %edi,%edx
f0100407:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100408:	a8 20                	test   $0x20,%al
f010040a:	75 13                	jne    f010041f <cons_putc+0x34>
f010040c:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100412:	7f 0b                	jg     f010041f <cons_putc+0x34>
f0100414:	89 da                	mov    %ebx,%edx
f0100416:	ec                   	in     (%dx),%al
f0100417:	ec                   	in     (%dx),%al
f0100418:	ec                   	in     (%dx),%al
f0100419:	ec                   	in     (%dx),%al
	     i++)
f010041a:	83 c6 01             	add    $0x1,%esi
f010041d:	eb e6                	jmp    f0100405 <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f010041f:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100422:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100427:	89 c8                	mov    %ecx,%eax
f0100429:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010042a:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010042f:	bf 79 03 00 00       	mov    $0x379,%edi
f0100434:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100439:	89 fa                	mov    %edi,%edx
f010043b:	ec                   	in     (%dx),%al
f010043c:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100442:	7f 0f                	jg     f0100453 <cons_putc+0x68>
f0100444:	84 c0                	test   %al,%al
f0100446:	78 0b                	js     f0100453 <cons_putc+0x68>
f0100448:	89 da                	mov    %ebx,%edx
f010044a:	ec                   	in     (%dx),%al
f010044b:	ec                   	in     (%dx),%al
f010044c:	ec                   	in     (%dx),%al
f010044d:	ec                   	in     (%dx),%al
f010044e:	83 c6 01             	add    $0x1,%esi
f0100451:	eb e6                	jmp    f0100439 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100453:	ba 78 03 00 00       	mov    $0x378,%edx
f0100458:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f010045c:	ee                   	out    %al,(%dx)
f010045d:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100462:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100467:	ee                   	out    %al,(%dx)
f0100468:	b8 08 00 00 00       	mov    $0x8,%eax
f010046d:	ee                   	out    %al,(%dx)
		c |= 0x0700;
f010046e:	89 c8                	mov    %ecx,%eax
f0100470:	80 cc 07             	or     $0x7,%ah
f0100473:	f7 c1 00 ff ff ff    	test   $0xffffff00,%ecx
f0100479:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f010047c:	0f b6 c1             	movzbl %cl,%eax
f010047f:	80 f9 0a             	cmp    $0xa,%cl
f0100482:	0f 84 dd 00 00 00    	je     f0100565 <cons_putc+0x17a>
f0100488:	83 f8 0a             	cmp    $0xa,%eax
f010048b:	7f 46                	jg     f01004d3 <cons_putc+0xe8>
f010048d:	83 f8 08             	cmp    $0x8,%eax
f0100490:	0f 84 a7 00 00 00    	je     f010053d <cons_putc+0x152>
f0100496:	83 f8 09             	cmp    $0x9,%eax
f0100499:	0f 85 d3 00 00 00    	jne    f0100572 <cons_putc+0x187>
		cons_putc(' ');
f010049f:	b8 20 00 00 00       	mov    $0x20,%eax
f01004a4:	e8 42 ff ff ff       	call   f01003eb <cons_putc>
		cons_putc(' ');
f01004a9:	b8 20 00 00 00       	mov    $0x20,%eax
f01004ae:	e8 38 ff ff ff       	call   f01003eb <cons_putc>
		cons_putc(' ');
f01004b3:	b8 20 00 00 00       	mov    $0x20,%eax
f01004b8:	e8 2e ff ff ff       	call   f01003eb <cons_putc>
		cons_putc(' ');
f01004bd:	b8 20 00 00 00       	mov    $0x20,%eax
f01004c2:	e8 24 ff ff ff       	call   f01003eb <cons_putc>
		cons_putc(' ');
f01004c7:	b8 20 00 00 00       	mov    $0x20,%eax
f01004cc:	e8 1a ff ff ff       	call   f01003eb <cons_putc>
		break;
f01004d1:	eb 25                	jmp    f01004f8 <cons_putc+0x10d>
	switch (c & 0xff) {
f01004d3:	83 f8 0d             	cmp    $0xd,%eax
f01004d6:	0f 85 96 00 00 00    	jne    f0100572 <cons_putc+0x187>
		crt_pos -= (crt_pos % CRT_COLS);
f01004dc:	0f b7 05 28 72 21 f0 	movzwl 0xf0217228,%eax
f01004e3:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004e9:	c1 e8 16             	shr    $0x16,%eax
f01004ec:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004ef:	c1 e0 04             	shl    $0x4,%eax
f01004f2:	66 a3 28 72 21 f0    	mov    %ax,0xf0217228
	if (crt_pos >= CRT_SIZE) {
f01004f8:	66 81 3d 28 72 21 f0 	cmpw   $0x7cf,0xf0217228
f01004ff:	cf 07 
f0100501:	0f 87 8e 00 00 00    	ja     f0100595 <cons_putc+0x1aa>
	outb(addr_6845, 14);
f0100507:	8b 0d 30 72 21 f0    	mov    0xf0217230,%ecx
f010050d:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100512:	89 ca                	mov    %ecx,%edx
f0100514:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100515:	0f b7 1d 28 72 21 f0 	movzwl 0xf0217228,%ebx
f010051c:	8d 71 01             	lea    0x1(%ecx),%esi
f010051f:	89 d8                	mov    %ebx,%eax
f0100521:	66 c1 e8 08          	shr    $0x8,%ax
f0100525:	89 f2                	mov    %esi,%edx
f0100527:	ee                   	out    %al,(%dx)
f0100528:	b8 0f 00 00 00       	mov    $0xf,%eax
f010052d:	89 ca                	mov    %ecx,%edx
f010052f:	ee                   	out    %al,(%dx)
f0100530:	89 d8                	mov    %ebx,%eax
f0100532:	89 f2                	mov    %esi,%edx
f0100534:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100535:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100538:	5b                   	pop    %ebx
f0100539:	5e                   	pop    %esi
f010053a:	5f                   	pop    %edi
f010053b:	5d                   	pop    %ebp
f010053c:	c3                   	ret    
		if (crt_pos > 0) {
f010053d:	0f b7 05 28 72 21 f0 	movzwl 0xf0217228,%eax
f0100544:	66 85 c0             	test   %ax,%ax
f0100547:	74 be                	je     f0100507 <cons_putc+0x11c>
			crt_pos--;
f0100549:	83 e8 01             	sub    $0x1,%eax
f010054c:	66 a3 28 72 21 f0    	mov    %ax,0xf0217228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100552:	0f b7 d0             	movzwl %ax,%edx
f0100555:	b1 00                	mov    $0x0,%cl
f0100557:	83 c9 20             	or     $0x20,%ecx
f010055a:	a1 2c 72 21 f0       	mov    0xf021722c,%eax
f010055f:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
f0100563:	eb 93                	jmp    f01004f8 <cons_putc+0x10d>
		crt_pos += CRT_COLS;
f0100565:	66 83 05 28 72 21 f0 	addw   $0x50,0xf0217228
f010056c:	50 
f010056d:	e9 6a ff ff ff       	jmp    f01004dc <cons_putc+0xf1>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100572:	0f b7 05 28 72 21 f0 	movzwl 0xf0217228,%eax
f0100579:	8d 50 01             	lea    0x1(%eax),%edx
f010057c:	66 89 15 28 72 21 f0 	mov    %dx,0xf0217228
f0100583:	0f b7 c0             	movzwl %ax,%eax
f0100586:	8b 15 2c 72 21 f0    	mov    0xf021722c,%edx
f010058c:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
		break;
f0100590:	e9 63 ff ff ff       	jmp    f01004f8 <cons_putc+0x10d>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100595:	a1 2c 72 21 f0       	mov    0xf021722c,%eax
f010059a:	83 ec 04             	sub    $0x4,%esp
f010059d:	68 00 0f 00 00       	push   $0xf00
f01005a2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005a8:	52                   	push   %edx
f01005a9:	50                   	push   %eax
f01005aa:	e8 df 55 00 00       	call   f0105b8e <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005af:	8b 15 2c 72 21 f0    	mov    0xf021722c,%edx
f01005b5:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005bb:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005c1:	83 c4 10             	add    $0x10,%esp
f01005c4:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005c9:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005cc:	39 d0                	cmp    %edx,%eax
f01005ce:	75 f4                	jne    f01005c4 <cons_putc+0x1d9>
		crt_pos -= CRT_COLS;
f01005d0:	66 83 2d 28 72 21 f0 	subw   $0x50,0xf0217228
f01005d7:	50 
f01005d8:	e9 2a ff ff ff       	jmp    f0100507 <cons_putc+0x11c>

f01005dd <serial_intr>:
{
f01005dd:	f3 0f 1e fb          	endbr32 
	if (serial_exists)
f01005e1:	80 3d 34 72 21 f0 00 	cmpb   $0x0,0xf0217234
f01005e8:	75 01                	jne    f01005eb <serial_intr+0xe>
f01005ea:	c3                   	ret    
{
f01005eb:	55                   	push   %ebp
f01005ec:	89 e5                	mov    %esp,%ebp
f01005ee:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f01005f1:	b8 75 02 10 f0       	mov    $0xf0100275,%eax
f01005f6:	e8 98 fc ff ff       	call   f0100293 <cons_intr>
}
f01005fb:	c9                   	leave  
f01005fc:	c3                   	ret    

f01005fd <kbd_intr>:
{
f01005fd:	f3 0f 1e fb          	endbr32 
f0100601:	55                   	push   %ebp
f0100602:	89 e5                	mov    %esp,%ebp
f0100604:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100607:	b8 d2 02 10 f0       	mov    $0xf01002d2,%eax
f010060c:	e8 82 fc ff ff       	call   f0100293 <cons_intr>
}
f0100611:	c9                   	leave  
f0100612:	c3                   	ret    

f0100613 <cons_getc>:
{
f0100613:	f3 0f 1e fb          	endbr32 
f0100617:	55                   	push   %ebp
f0100618:	89 e5                	mov    %esp,%ebp
f010061a:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f010061d:	e8 bb ff ff ff       	call   f01005dd <serial_intr>
	kbd_intr();
f0100622:	e8 d6 ff ff ff       	call   f01005fd <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100627:	a1 20 72 21 f0       	mov    0xf0217220,%eax
	return 0;
f010062c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f0100631:	3b 05 24 72 21 f0    	cmp    0xf0217224,%eax
f0100637:	74 1c                	je     f0100655 <cons_getc+0x42>
		c = cons.buf[cons.rpos++];
f0100639:	8d 48 01             	lea    0x1(%eax),%ecx
f010063c:	0f b6 90 20 70 21 f0 	movzbl -0xfde8fe0(%eax),%edx
			cons.rpos = 0;
f0100643:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f0100648:	b8 00 00 00 00       	mov    $0x0,%eax
f010064d:	0f 45 c1             	cmovne %ecx,%eax
f0100650:	a3 20 72 21 f0       	mov    %eax,0xf0217220
}
f0100655:	89 d0                	mov    %edx,%eax
f0100657:	c9                   	leave  
f0100658:	c3                   	ret    

f0100659 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100659:	f3 0f 1e fb          	endbr32 
f010065d:	55                   	push   %ebp
f010065e:	89 e5                	mov    %esp,%ebp
f0100660:	57                   	push   %edi
f0100661:	56                   	push   %esi
f0100662:	53                   	push   %ebx
f0100663:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100666:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010066d:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100674:	5a a5 
	if (*cp != 0xA55A) {
f0100676:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010067d:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100681:	0f 84 de 00 00 00    	je     f0100765 <cons_init+0x10c>
		addr_6845 = MONO_BASE;
f0100687:	c7 05 30 72 21 f0 b4 	movl   $0x3b4,0xf0217230
f010068e:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f0100691:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f0100696:	8b 3d 30 72 21 f0    	mov    0xf0217230,%edi
f010069c:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006a1:	89 fa                	mov    %edi,%edx
f01006a3:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006a4:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006a7:	89 ca                	mov    %ecx,%edx
f01006a9:	ec                   	in     (%dx),%al
f01006aa:	0f b6 c0             	movzbl %al,%eax
f01006ad:	c1 e0 08             	shl    $0x8,%eax
f01006b0:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006b2:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006b7:	89 fa                	mov    %edi,%edx
f01006b9:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006ba:	89 ca                	mov    %ecx,%edx
f01006bc:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006bd:	89 35 2c 72 21 f0    	mov    %esi,0xf021722c
	pos |= inb(addr_6845 + 1);
f01006c3:	0f b6 c0             	movzbl %al,%eax
f01006c6:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006c8:	66 a3 28 72 21 f0    	mov    %ax,0xf0217228
	kbd_intr();
f01006ce:	e8 2a ff ff ff       	call   f01005fd <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006d3:	83 ec 0c             	sub    $0xc,%esp
f01006d6:	0f b7 05 a8 33 12 f0 	movzwl 0xf01233a8,%eax
f01006dd:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006e2:	50                   	push   %eax
f01006e3:	e8 b2 31 00 00       	call   f010389a <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006e8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006ed:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01006f2:	89 d8                	mov    %ebx,%eax
f01006f4:	89 ca                	mov    %ecx,%edx
f01006f6:	ee                   	out    %al,(%dx)
f01006f7:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01006fc:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100701:	89 fa                	mov    %edi,%edx
f0100703:	ee                   	out    %al,(%dx)
f0100704:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100709:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010070e:	ee                   	out    %al,(%dx)
f010070f:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100714:	89 d8                	mov    %ebx,%eax
f0100716:	89 f2                	mov    %esi,%edx
f0100718:	ee                   	out    %al,(%dx)
f0100719:	b8 03 00 00 00       	mov    $0x3,%eax
f010071e:	89 fa                	mov    %edi,%edx
f0100720:	ee                   	out    %al,(%dx)
f0100721:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100726:	89 d8                	mov    %ebx,%eax
f0100728:	ee                   	out    %al,(%dx)
f0100729:	b8 01 00 00 00       	mov    $0x1,%eax
f010072e:	89 f2                	mov    %esi,%edx
f0100730:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100731:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100736:	ec                   	in     (%dx),%al
f0100737:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100739:	83 c4 10             	add    $0x10,%esp
f010073c:	3c ff                	cmp    $0xff,%al
f010073e:	0f 95 05 34 72 21 f0 	setne  0xf0217234
f0100745:	89 ca                	mov    %ecx,%edx
f0100747:	ec                   	in     (%dx),%al
f0100748:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010074d:	ec                   	in     (%dx),%al
	if (serial_exists)
f010074e:	80 fb ff             	cmp    $0xff,%bl
f0100751:	75 2d                	jne    f0100780 <cons_init+0x127>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f0100753:	83 ec 0c             	sub    $0xc,%esp
f0100756:	68 af 68 10 f0       	push   $0xf01068af
f010075b:	e8 a7 32 00 00       	call   f0103a07 <cprintf>
f0100760:	83 c4 10             	add    $0x10,%esp
}
f0100763:	eb 3c                	jmp    f01007a1 <cons_init+0x148>
		*cp = was;
f0100765:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010076c:	c7 05 30 72 21 f0 d4 	movl   $0x3d4,0xf0217230
f0100773:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100776:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010077b:	e9 16 ff ff ff       	jmp    f0100696 <cons_init+0x3d>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f0100780:	83 ec 0c             	sub    $0xc,%esp
f0100783:	0f b7 05 a8 33 12 f0 	movzwl 0xf01233a8,%eax
f010078a:	25 ef ff 00 00       	and    $0xffef,%eax
f010078f:	50                   	push   %eax
f0100790:	e8 05 31 00 00       	call   f010389a <irq_setmask_8259A>
	if (!serial_exists)
f0100795:	83 c4 10             	add    $0x10,%esp
f0100798:	80 3d 34 72 21 f0 00 	cmpb   $0x0,0xf0217234
f010079f:	74 b2                	je     f0100753 <cons_init+0xfa>
}
f01007a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007a4:	5b                   	pop    %ebx
f01007a5:	5e                   	pop    %esi
f01007a6:	5f                   	pop    %edi
f01007a7:	5d                   	pop    %ebp
f01007a8:	c3                   	ret    

f01007a9 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007a9:	f3 0f 1e fb          	endbr32 
f01007ad:	55                   	push   %ebp
f01007ae:	89 e5                	mov    %esp,%ebp
f01007b0:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007b3:	8b 45 08             	mov    0x8(%ebp),%eax
f01007b6:	e8 30 fc ff ff       	call   f01003eb <cons_putc>
}
f01007bb:	c9                   	leave  
f01007bc:	c3                   	ret    

f01007bd <getchar>:

int
getchar(void)
{
f01007bd:	f3 0f 1e fb          	endbr32 
f01007c1:	55                   	push   %ebp
f01007c2:	89 e5                	mov    %esp,%ebp
f01007c4:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007c7:	e8 47 fe ff ff       	call   f0100613 <cons_getc>
f01007cc:	85 c0                	test   %eax,%eax
f01007ce:	74 f7                	je     f01007c7 <getchar+0xa>
		/* do nothing */;
	return c;
}
f01007d0:	c9                   	leave  
f01007d1:	c3                   	ret    

f01007d2 <iscons>:

int
iscons(int fdnum)
{
f01007d2:	f3 0f 1e fb          	endbr32 
	// used by readline
	return 1;
}
f01007d6:	b8 01 00 00 00       	mov    $0x1,%eax
f01007db:	c3                   	ret    

f01007dc <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007dc:	f3 0f 1e fb          	endbr32 
f01007e0:	55                   	push   %ebp
f01007e1:	89 e5                	mov    %esp,%ebp
f01007e3:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007e6:	68 00 6b 10 f0       	push   $0xf0106b00
f01007eb:	68 1e 6b 10 f0       	push   $0xf0106b1e
f01007f0:	68 23 6b 10 f0       	push   $0xf0106b23
f01007f5:	e8 0d 32 00 00       	call   f0103a07 <cprintf>
f01007fa:	83 c4 0c             	add    $0xc,%esp
f01007fd:	68 d4 6b 10 f0       	push   $0xf0106bd4
f0100802:	68 2c 6b 10 f0       	push   $0xf0106b2c
f0100807:	68 23 6b 10 f0       	push   $0xf0106b23
f010080c:	e8 f6 31 00 00       	call   f0103a07 <cprintf>
f0100811:	83 c4 0c             	add    $0xc,%esp
f0100814:	68 fc 6b 10 f0       	push   $0xf0106bfc
f0100819:	68 35 6b 10 f0       	push   $0xf0106b35
f010081e:	68 23 6b 10 f0       	push   $0xf0106b23
f0100823:	e8 df 31 00 00       	call   f0103a07 <cprintf>
	return 0;
}
f0100828:	b8 00 00 00 00       	mov    $0x0,%eax
f010082d:	c9                   	leave  
f010082e:	c3                   	ret    

f010082f <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f010082f:	f3 0f 1e fb          	endbr32 
f0100833:	55                   	push   %ebp
f0100834:	89 e5                	mov    %esp,%ebp
f0100836:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100839:	68 3f 6b 10 f0       	push   $0xf0106b3f
f010083e:	e8 c4 31 00 00       	call   f0103a07 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100843:	83 c4 08             	add    $0x8,%esp
f0100846:	68 0c 00 10 00       	push   $0x10000c
f010084b:	68 24 6c 10 f0       	push   $0xf0106c24
f0100850:	e8 b2 31 00 00       	call   f0103a07 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100855:	83 c4 0c             	add    $0xc,%esp
f0100858:	68 0c 00 10 00       	push   $0x10000c
f010085d:	68 0c 00 10 f0       	push   $0xf010000c
f0100862:	68 4c 6c 10 f0       	push   $0xf0106c4c
f0100867:	e8 9b 31 00 00       	call   f0103a07 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010086c:	83 c4 0c             	add    $0xc,%esp
f010086f:	68 dd 67 10 00       	push   $0x1067dd
f0100874:	68 dd 67 10 f0       	push   $0xf01067dd
f0100879:	68 70 6c 10 f0       	push   $0xf0106c70
f010087e:	e8 84 31 00 00       	call   f0103a07 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100883:	83 c4 0c             	add    $0xc,%esp
f0100886:	68 00 70 21 00       	push   $0x217000
f010088b:	68 00 70 21 f0       	push   $0xf0217000
f0100890:	68 94 6c 10 f0       	push   $0xf0106c94
f0100895:	e8 6d 31 00 00       	call   f0103a07 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010089a:	83 c4 0c             	add    $0xc,%esp
f010089d:	68 08 90 25 00       	push   $0x259008
f01008a2:	68 08 90 25 f0       	push   $0xf0259008
f01008a7:	68 b8 6c 10 f0       	push   $0xf0106cb8
f01008ac:	e8 56 31 00 00       	call   f0103a07 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008b1:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01008b4:	b8 08 90 25 f0       	mov    $0xf0259008,%eax
f01008b9:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008be:	c1 f8 0a             	sar    $0xa,%eax
f01008c1:	50                   	push   %eax
f01008c2:	68 dc 6c 10 f0       	push   $0xf0106cdc
f01008c7:	e8 3b 31 00 00       	call   f0103a07 <cprintf>
	return 0;
}
f01008cc:	b8 00 00 00 00       	mov    $0x0,%eax
f01008d1:	c9                   	leave  
f01008d2:	c3                   	ret    

f01008d3 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008d3:	f3 0f 1e fb          	endbr32 
f01008d7:	55                   	push   %ebp
f01008d8:	89 e5                	mov    %esp,%ebp
f01008da:	57                   	push   %edi
f01008db:	56                   	push   %esi
f01008dc:	53                   	push   %ebx
f01008dd:	83 ec 48             	sub    $0x48,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008e0:	89 ee                	mov    %ebp,%esi
	// Your code here.
	uint32_t* ebp = (uint32_t*) read_ebp();
	cprintf("Stack backtrace:\n");
f01008e2:	68 58 6b 10 f0       	push   $0xf0106b58
f01008e7:	e8 1b 31 00 00       	call   f0103a07 <cprintf>
	while (ebp) {
f01008ec:	83 c4 10             	add    $0x10,%esp
f01008ef:	eb 41                	jmp    f0100932 <mon_backtrace+0x5f>
		uint32_t eip = ebp[1];
		cprintf("ebp %x  eip %x  args", ebp, eip);
		int i;
		for (i = 2; i <= 6; ++i)
			cprintf(" %08.x", ebp[i]);
		cprintf("\n");
f01008f1:	83 ec 0c             	sub    $0xc,%esp
f01008f4:	68 76 70 10 f0       	push   $0xf0107076
f01008f9:	e8 09 31 00 00       	call   f0103a07 <cprintf>
		struct Eipdebuginfo info;
		debuginfo_eip(eip, &info);
f01008fe:	83 c4 08             	add    $0x8,%esp
f0100901:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100904:	50                   	push   %eax
f0100905:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0100908:	57                   	push   %edi
f0100909:	e8 e3 46 00 00       	call   f0104ff1 <debuginfo_eip>
		cprintf("\t%s:%d: %.*s+%d\n", 
f010090e:	83 c4 08             	add    $0x8,%esp
f0100911:	89 f8                	mov    %edi,%eax
f0100913:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100916:	50                   	push   %eax
f0100917:	ff 75 d8             	pushl  -0x28(%ebp)
f010091a:	ff 75 dc             	pushl  -0x24(%ebp)
f010091d:	ff 75 d4             	pushl  -0x2c(%ebp)
f0100920:	ff 75 d0             	pushl  -0x30(%ebp)
f0100923:	68 86 6b 10 f0       	push   $0xf0106b86
f0100928:	e8 da 30 00 00       	call   f0103a07 <cprintf>
			info.eip_file, info.eip_line,
			info.eip_fn_namelen, info.eip_fn_name,
			eip-info.eip_fn_addr);
		ebp = (uint32_t*) *ebp;
f010092d:	8b 36                	mov    (%esi),%esi
f010092f:	83 c4 20             	add    $0x20,%esp
	while (ebp) {
f0100932:	85 f6                	test   %esi,%esi
f0100934:	74 39                	je     f010096f <mon_backtrace+0x9c>
		uint32_t eip = ebp[1];
f0100936:	8b 46 04             	mov    0x4(%esi),%eax
f0100939:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("ebp %x  eip %x  args", ebp, eip);
f010093c:	83 ec 04             	sub    $0x4,%esp
f010093f:	50                   	push   %eax
f0100940:	56                   	push   %esi
f0100941:	68 6a 6b 10 f0       	push   $0xf0106b6a
f0100946:	e8 bc 30 00 00       	call   f0103a07 <cprintf>
f010094b:	8d 5e 08             	lea    0x8(%esi),%ebx
f010094e:	8d 7e 1c             	lea    0x1c(%esi),%edi
f0100951:	83 c4 10             	add    $0x10,%esp
			cprintf(" %08.x", ebp[i]);
f0100954:	83 ec 08             	sub    $0x8,%esp
f0100957:	ff 33                	pushl  (%ebx)
f0100959:	68 7f 6b 10 f0       	push   $0xf0106b7f
f010095e:	e8 a4 30 00 00       	call   f0103a07 <cprintf>
f0100963:	83 c3 04             	add    $0x4,%ebx
		for (i = 2; i <= 6; ++i)
f0100966:	83 c4 10             	add    $0x10,%esp
f0100969:	39 fb                	cmp    %edi,%ebx
f010096b:	75 e7                	jne    f0100954 <mon_backtrace+0x81>
f010096d:	eb 82                	jmp    f01008f1 <mon_backtrace+0x1e>
	}
	return 0;
}
f010096f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100974:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100977:	5b                   	pop    %ebx
f0100978:	5e                   	pop    %esi
f0100979:	5f                   	pop    %edi
f010097a:	5d                   	pop    %ebp
f010097b:	c3                   	ret    

f010097c <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f010097c:	f3 0f 1e fb          	endbr32 
f0100980:	55                   	push   %ebp
f0100981:	89 e5                	mov    %esp,%ebp
f0100983:	57                   	push   %edi
f0100984:	56                   	push   %esi
f0100985:	53                   	push   %ebx
f0100986:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100989:	68 08 6d 10 f0       	push   $0xf0106d08
f010098e:	e8 74 30 00 00       	call   f0103a07 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100993:	c7 04 24 2c 6d 10 f0 	movl   $0xf0106d2c,(%esp)
f010099a:	e8 68 30 00 00       	call   f0103a07 <cprintf>

	if (tf != NULL)
f010099f:	83 c4 10             	add    $0x10,%esp
f01009a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f01009a6:	0f 84 d9 00 00 00    	je     f0100a85 <monitor+0x109>
		print_trapframe(tf);
f01009ac:	83 ec 0c             	sub    $0xc,%esp
f01009af:	ff 75 08             	pushl  0x8(%ebp)
f01009b2:	e8 bd 37 00 00       	call   f0104174 <print_trapframe>
f01009b7:	83 c4 10             	add    $0x10,%esp
f01009ba:	e9 c6 00 00 00       	jmp    f0100a85 <monitor+0x109>
		while (*buf && strchr(WHITESPACE, *buf))
f01009bf:	83 ec 08             	sub    $0x8,%esp
f01009c2:	0f be c0             	movsbl %al,%eax
f01009c5:	50                   	push   %eax
f01009c6:	68 9b 6b 10 f0       	push   $0xf0106b9b
f01009cb:	e8 2d 51 00 00       	call   f0105afd <strchr>
f01009d0:	83 c4 10             	add    $0x10,%esp
f01009d3:	85 c0                	test   %eax,%eax
f01009d5:	74 63                	je     f0100a3a <monitor+0xbe>
			*buf++ = 0;
f01009d7:	c6 03 00             	movb   $0x0,(%ebx)
f01009da:	89 f7                	mov    %esi,%edi
f01009dc:	8d 5b 01             	lea    0x1(%ebx),%ebx
f01009df:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f01009e1:	0f b6 03             	movzbl (%ebx),%eax
f01009e4:	84 c0                	test   %al,%al
f01009e6:	75 d7                	jne    f01009bf <monitor+0x43>
	argv[argc] = 0;
f01009e8:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009ef:	00 
	if (argc == 0)
f01009f0:	85 f6                	test   %esi,%esi
f01009f2:	0f 84 8d 00 00 00    	je     f0100a85 <monitor+0x109>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009f8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f01009fd:	83 ec 08             	sub    $0x8,%esp
f0100a00:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a03:	ff 34 85 60 6d 10 f0 	pushl  -0xfef92a0(,%eax,4)
f0100a0a:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a0d:	e8 85 50 00 00       	call   f0105a97 <strcmp>
f0100a12:	83 c4 10             	add    $0x10,%esp
f0100a15:	85 c0                	test   %eax,%eax
f0100a17:	0f 84 8f 00 00 00    	je     f0100aac <monitor+0x130>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a1d:	83 c3 01             	add    $0x1,%ebx
f0100a20:	83 fb 03             	cmp    $0x3,%ebx
f0100a23:	75 d8                	jne    f01009fd <monitor+0x81>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a25:	83 ec 08             	sub    $0x8,%esp
f0100a28:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a2b:	68 bd 6b 10 f0       	push   $0xf0106bbd
f0100a30:	e8 d2 2f 00 00       	call   f0103a07 <cprintf>
	return 0;
f0100a35:	83 c4 10             	add    $0x10,%esp
f0100a38:	eb 4b                	jmp    f0100a85 <monitor+0x109>
		if (*buf == 0)
f0100a3a:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a3d:	74 a9                	je     f01009e8 <monitor+0x6c>
		if (argc == MAXARGS-1) {
f0100a3f:	83 fe 0f             	cmp    $0xf,%esi
f0100a42:	74 2f                	je     f0100a73 <monitor+0xf7>
		argv[argc++] = buf;
f0100a44:	8d 7e 01             	lea    0x1(%esi),%edi
f0100a47:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a4b:	0f b6 03             	movzbl (%ebx),%eax
f0100a4e:	84 c0                	test   %al,%al
f0100a50:	74 8d                	je     f01009df <monitor+0x63>
f0100a52:	83 ec 08             	sub    $0x8,%esp
f0100a55:	0f be c0             	movsbl %al,%eax
f0100a58:	50                   	push   %eax
f0100a59:	68 9b 6b 10 f0       	push   $0xf0106b9b
f0100a5e:	e8 9a 50 00 00       	call   f0105afd <strchr>
f0100a63:	83 c4 10             	add    $0x10,%esp
f0100a66:	85 c0                	test   %eax,%eax
f0100a68:	0f 85 71 ff ff ff    	jne    f01009df <monitor+0x63>
			buf++;
f0100a6e:	83 c3 01             	add    $0x1,%ebx
f0100a71:	eb d8                	jmp    f0100a4b <monitor+0xcf>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a73:	83 ec 08             	sub    $0x8,%esp
f0100a76:	6a 10                	push   $0x10
f0100a78:	68 a0 6b 10 f0       	push   $0xf0106ba0
f0100a7d:	e8 85 2f 00 00       	call   f0103a07 <cprintf>
			return 0;
f0100a82:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100a85:	83 ec 0c             	sub    $0xc,%esp
f0100a88:	68 97 6b 10 f0       	push   $0xf0106b97
f0100a8d:	e8 11 4e 00 00       	call   f01058a3 <readline>
f0100a92:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100a94:	83 c4 10             	add    $0x10,%esp
f0100a97:	85 c0                	test   %eax,%eax
f0100a99:	74 ea                	je     f0100a85 <monitor+0x109>
	argv[argc] = 0;
f0100a9b:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100aa2:	be 00 00 00 00       	mov    $0x0,%esi
f0100aa7:	e9 35 ff ff ff       	jmp    f01009e1 <monitor+0x65>
			return commands[i].func(argc, argv, tf);
f0100aac:	83 ec 04             	sub    $0x4,%esp
f0100aaf:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100ab2:	ff 75 08             	pushl  0x8(%ebp)
f0100ab5:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100ab8:	52                   	push   %edx
f0100ab9:	56                   	push   %esi
f0100aba:	ff 14 85 68 6d 10 f0 	call   *-0xfef9298(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100ac1:	83 c4 10             	add    $0x10,%esp
f0100ac4:	85 c0                	test   %eax,%eax
f0100ac6:	79 bd                	jns    f0100a85 <monitor+0x109>
				break;
	}
f0100ac8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100acb:	5b                   	pop    %ebx
f0100acc:	5e                   	pop    %esi
f0100acd:	5f                   	pop    %edi
f0100ace:	5d                   	pop    %ebp
f0100acf:	c3                   	ret    

f0100ad0 <boot_alloc>:
// before the page_free_list list has been set up.
// Note that when this function is called, we are still using entry_pgdir,
// which only maps the first 4MB of physical memory.
static void *
boot_alloc(uint32_t n)
{
f0100ad0:	55                   	push   %ebp
f0100ad1:	89 e5                	mov    %esp,%ebp
f0100ad3:	53                   	push   %ebx
f0100ad4:	83 ec 04             	sub    $0x4,%esp
f0100ad7:	89 c3                	mov    %eax,%ebx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100ad9:	83 3d 38 72 21 f0 00 	cmpl   $0x0,0xf0217238
f0100ae0:	74 1e                	je     f0100b00 <boot_alloc+0x30>
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = nextfree;
f0100ae2:	8b 15 38 72 21 f0    	mov    0xf0217238,%edx
	nextfree = ROUNDUP(result + n, PGSIZE);
f0100ae8:	8d 84 1a ff 0f 00 00 	lea    0xfff(%edx,%ebx,1),%eax
f0100aef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100af4:	a3 38 72 21 f0       	mov    %eax,0xf0217238

	// If we're out of memory, boot_alloc should panic.
	// 这部分目前没有思路

	return result;
}
f0100af9:	89 d0                	mov    %edx,%eax
f0100afb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100afe:	c9                   	leave  
f0100aff:	c3                   	ret    
		cprintf(".bss end is %08x\n", end);
f0100b00:	83 ec 08             	sub    $0x8,%esp
f0100b03:	68 08 90 25 f0       	push   $0xf0259008
f0100b08:	68 84 6d 10 f0       	push   $0xf0106d84
f0100b0d:	e8 f5 2e 00 00       	call   f0103a07 <cprintf>
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100b12:	b8 07 a0 25 f0       	mov    $0xf025a007,%eax
f0100b17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b1c:	a3 38 72 21 f0       	mov    %eax,0xf0217238
f0100b21:	83 c4 10             	add    $0x10,%esp
f0100b24:	eb bc                	jmp    f0100ae2 <boot_alloc+0x12>

f0100b26 <nvram_read>:
{
f0100b26:	55                   	push   %ebp
f0100b27:	89 e5                	mov    %esp,%ebp
f0100b29:	56                   	push   %esi
f0100b2a:	53                   	push   %ebx
f0100b2b:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100b2d:	83 ec 0c             	sub    $0xc,%esp
f0100b30:	50                   	push   %eax
f0100b31:	e8 2e 2d 00 00       	call   f0103864 <mc146818_read>
f0100b36:	89 c6                	mov    %eax,%esi
f0100b38:	83 c3 01             	add    $0x1,%ebx
f0100b3b:	89 1c 24             	mov    %ebx,(%esp)
f0100b3e:	e8 21 2d 00 00       	call   f0103864 <mc146818_read>
f0100b43:	c1 e0 08             	shl    $0x8,%eax
f0100b46:	09 f0                	or     %esi,%eax
}
f0100b48:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100b4b:	5b                   	pop    %ebx
f0100b4c:	5e                   	pop    %esi
f0100b4d:	5d                   	pop    %ebp
f0100b4e:	c3                   	ret    

f0100b4f <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100b4f:	89 d1                	mov    %edx,%ecx
f0100b51:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100b54:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100b57:	a8 01                	test   $0x1,%al
f0100b59:	74 51                	je     f0100bac <check_va2pa+0x5d>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100b5b:	89 c1                	mov    %eax,%ecx
f0100b5d:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
	if (PGNUM(pa) >= npages)
f0100b63:	c1 e8 0c             	shr    $0xc,%eax
f0100b66:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0100b6c:	73 23                	jae    f0100b91 <check_va2pa+0x42>
	if (!(p[PTX(va)] & PTE_P))
f0100b6e:	c1 ea 0c             	shr    $0xc,%edx
f0100b71:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100b77:	8b 94 91 00 00 00 f0 	mov    -0x10000000(%ecx,%edx,4),%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100b7e:	89 d0                	mov    %edx,%eax
f0100b80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b85:	f6 c2 01             	test   $0x1,%dl
f0100b88:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100b8d:	0f 44 c2             	cmove  %edx,%eax
f0100b90:	c3                   	ret    
{
f0100b91:	55                   	push   %ebp
f0100b92:	89 e5                	mov    %esp,%ebp
f0100b94:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b97:	51                   	push   %ecx
f0100b98:	68 04 68 10 f0       	push   $0xf0106804
f0100b9d:	68 f1 03 00 00       	push   $0x3f1
f0100ba2:	68 96 6d 10 f0       	push   $0xf0106d96
f0100ba7:	e8 94 f4 ff ff       	call   f0100040 <_panic>
		return ~0;
f0100bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100bb1:	c3                   	ret    

f0100bb2 <check_page_free_list>:
{
f0100bb2:	55                   	push   %ebp
f0100bb3:	89 e5                	mov    %esp,%ebp
f0100bb5:	57                   	push   %edi
f0100bb6:	56                   	push   %esi
f0100bb7:	53                   	push   %ebx
f0100bb8:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100bbb:	84 c0                	test   %al,%al
f0100bbd:	0f 85 77 02 00 00    	jne    f0100e3a <check_page_free_list+0x288>
	if (!page_free_list)
f0100bc3:	83 3d 40 72 21 f0 00 	cmpl   $0x0,0xf0217240
f0100bca:	74 0a                	je     f0100bd6 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100bcc:	be 00 04 00 00       	mov    $0x400,%esi
f0100bd1:	e9 bf 02 00 00       	jmp    f0100e95 <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100bd6:	83 ec 04             	sub    $0x4,%esp
f0100bd9:	68 a8 70 10 f0       	push   $0xf01070a8
f0100bde:	68 24 03 00 00       	push   $0x324
f0100be3:	68 96 6d 10 f0       	push   $0xf0106d96
f0100be8:	e8 53 f4 ff ff       	call   f0100040 <_panic>
f0100bed:	50                   	push   %eax
f0100bee:	68 04 68 10 f0       	push   $0xf0106804
f0100bf3:	6a 58                	push   $0x58
f0100bf5:	68 a2 6d 10 f0       	push   $0xf0106da2
f0100bfa:	e8 41 f4 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100bff:	8b 1b                	mov    (%ebx),%ebx
f0100c01:	85 db                	test   %ebx,%ebx
f0100c03:	74 41                	je     f0100c46 <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100c05:	89 d8                	mov    %ebx,%eax
f0100c07:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0100c0d:	c1 f8 03             	sar    $0x3,%eax
f0100c10:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100c13:	89 c2                	mov    %eax,%edx
f0100c15:	c1 ea 16             	shr    $0x16,%edx
f0100c18:	39 f2                	cmp    %esi,%edx
f0100c1a:	73 e3                	jae    f0100bff <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100c1c:	89 c2                	mov    %eax,%edx
f0100c1e:	c1 ea 0c             	shr    $0xc,%edx
f0100c21:	3b 15 88 7e 21 f0    	cmp    0xf0217e88,%edx
f0100c27:	73 c4                	jae    f0100bed <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100c29:	83 ec 04             	sub    $0x4,%esp
f0100c2c:	68 80 00 00 00       	push   $0x80
f0100c31:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100c36:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100c3b:	50                   	push   %eax
f0100c3c:	e8 01 4f 00 00       	call   f0105b42 <memset>
f0100c41:	83 c4 10             	add    $0x10,%esp
f0100c44:	eb b9                	jmp    f0100bff <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100c46:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c4b:	e8 80 fe ff ff       	call   f0100ad0 <boot_alloc>
f0100c50:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c53:	8b 15 40 72 21 f0    	mov    0xf0217240,%edx
		assert(pp >= pages);
f0100c59:	8b 0d 90 7e 21 f0    	mov    0xf0217e90,%ecx
		assert(pp < pages + npages);
f0100c5f:	a1 88 7e 21 f0       	mov    0xf0217e88,%eax
f0100c64:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100c67:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100c6a:	bf 00 00 00 00       	mov    $0x0,%edi
f0100c6f:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c72:	e9 f9 00 00 00       	jmp    f0100d70 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100c77:	68 b0 6d 10 f0       	push   $0xf0106db0
f0100c7c:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0100c81:	68 3e 03 00 00       	push   $0x33e
f0100c86:	68 96 6d 10 f0       	push   $0xf0106d96
f0100c8b:	e8 b0 f3 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100c90:	68 d1 6d 10 f0       	push   $0xf0106dd1
f0100c95:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0100c9a:	68 3f 03 00 00       	push   $0x33f
f0100c9f:	68 96 6d 10 f0       	push   $0xf0106d96
f0100ca4:	e8 97 f3 ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100ca9:	68 cc 70 10 f0       	push   $0xf01070cc
f0100cae:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0100cb3:	68 40 03 00 00       	push   $0x340
f0100cb8:	68 96 6d 10 f0       	push   $0xf0106d96
f0100cbd:	e8 7e f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100cc2:	68 e5 6d 10 f0       	push   $0xf0106de5
f0100cc7:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0100ccc:	68 43 03 00 00       	push   $0x343
f0100cd1:	68 96 6d 10 f0       	push   $0xf0106d96
f0100cd6:	e8 65 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100cdb:	68 f6 6d 10 f0       	push   $0xf0106df6
f0100ce0:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0100ce5:	68 44 03 00 00       	push   $0x344
f0100cea:	68 96 6d 10 f0       	push   $0xf0106d96
f0100cef:	e8 4c f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100cf4:	68 00 71 10 f0       	push   $0xf0107100
f0100cf9:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0100cfe:	68 45 03 00 00       	push   $0x345
f0100d03:	68 96 6d 10 f0       	push   $0xf0106d96
f0100d08:	e8 33 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d0d:	68 0f 6e 10 f0       	push   $0xf0106e0f
f0100d12:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0100d17:	68 46 03 00 00       	push   $0x346
f0100d1c:	68 96 6d 10 f0       	push   $0xf0106d96
f0100d21:	e8 1a f3 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100d26:	89 c3                	mov    %eax,%ebx
f0100d28:	c1 eb 0c             	shr    $0xc,%ebx
f0100d2b:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0100d2e:	76 0f                	jbe    f0100d3f <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f0100d30:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d35:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0100d38:	77 17                	ja     f0100d51 <check_page_free_list+0x19f>
			++nfree_extmem;
f0100d3a:	83 c7 01             	add    $0x1,%edi
f0100d3d:	eb 2f                	jmp    f0100d6e <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d3f:	50                   	push   %eax
f0100d40:	68 04 68 10 f0       	push   $0xf0106804
f0100d45:	6a 58                	push   $0x58
f0100d47:	68 a2 6d 10 f0       	push   $0xf0106da2
f0100d4c:	e8 ef f2 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d51:	68 24 71 10 f0       	push   $0xf0107124
f0100d56:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0100d5b:	68 47 03 00 00       	push   $0x347
f0100d60:	68 96 6d 10 f0       	push   $0xf0106d96
f0100d65:	e8 d6 f2 ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f0100d6a:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d6e:	8b 12                	mov    (%edx),%edx
f0100d70:	85 d2                	test   %edx,%edx
f0100d72:	74 74                	je     f0100de8 <check_page_free_list+0x236>
		assert(pp >= pages);
f0100d74:	39 d1                	cmp    %edx,%ecx
f0100d76:	0f 87 fb fe ff ff    	ja     f0100c77 <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f0100d7c:	39 d6                	cmp    %edx,%esi
f0100d7e:	0f 86 0c ff ff ff    	jbe    f0100c90 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d84:	89 d0                	mov    %edx,%eax
f0100d86:	29 c8                	sub    %ecx,%eax
f0100d88:	a8 07                	test   $0x7,%al
f0100d8a:	0f 85 19 ff ff ff    	jne    f0100ca9 <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f0100d90:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100d93:	c1 e0 0c             	shl    $0xc,%eax
f0100d96:	0f 84 26 ff ff ff    	je     f0100cc2 <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d9c:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100da1:	0f 84 34 ff ff ff    	je     f0100cdb <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100da7:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100dac:	0f 84 42 ff ff ff    	je     f0100cf4 <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100db2:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100db7:	0f 84 50 ff ff ff    	je     f0100d0d <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100dbd:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100dc2:	0f 87 5e ff ff ff    	ja     f0100d26 <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100dc8:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100dcd:	75 9b                	jne    f0100d6a <check_page_free_list+0x1b8>
f0100dcf:	68 29 6e 10 f0       	push   $0xf0106e29
f0100dd4:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0100dd9:	68 49 03 00 00       	push   $0x349
f0100dde:	68 96 6d 10 f0       	push   $0xf0106d96
f0100de3:	e8 58 f2 ff ff       	call   f0100040 <_panic>
f0100de8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f0100deb:	85 db                	test   %ebx,%ebx
f0100ded:	7e 19                	jle    f0100e08 <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f0100def:	85 ff                	test   %edi,%edi
f0100df1:	7e 2e                	jle    f0100e21 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0100df3:	83 ec 0c             	sub    $0xc,%esp
f0100df6:	68 6c 71 10 f0       	push   $0xf010716c
f0100dfb:	e8 07 2c 00 00       	call   f0103a07 <cprintf>
}
f0100e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e03:	5b                   	pop    %ebx
f0100e04:	5e                   	pop    %esi
f0100e05:	5f                   	pop    %edi
f0100e06:	5d                   	pop    %ebp
f0100e07:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100e08:	68 46 6e 10 f0       	push   $0xf0106e46
f0100e0d:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0100e12:	68 51 03 00 00       	push   $0x351
f0100e17:	68 96 6d 10 f0       	push   $0xf0106d96
f0100e1c:	e8 1f f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100e21:	68 58 6e 10 f0       	push   $0xf0106e58
f0100e26:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0100e2b:	68 52 03 00 00       	push   $0x352
f0100e30:	68 96 6d 10 f0       	push   $0xf0106d96
f0100e35:	e8 06 f2 ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f0100e3a:	a1 40 72 21 f0       	mov    0xf0217240,%eax
f0100e3f:	85 c0                	test   %eax,%eax
f0100e41:	0f 84 8f fd ff ff    	je     f0100bd6 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100e47:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100e4a:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100e4d:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100e50:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100e53:	89 c2                	mov    %eax,%edx
f0100e55:	2b 15 90 7e 21 f0    	sub    0xf0217e90,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100e5b:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100e61:	0f 95 c2             	setne  %dl
f0100e64:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100e67:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100e6b:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100e6d:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e71:	8b 00                	mov    (%eax),%eax
f0100e73:	85 c0                	test   %eax,%eax
f0100e75:	75 dc                	jne    f0100e53 <check_page_free_list+0x2a1>
		*tp[1] = 0;
f0100e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100e80:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e86:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100e88:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e8b:	a3 40 72 21 f0       	mov    %eax,0xf0217240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100e90:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100e95:	8b 1d 40 72 21 f0    	mov    0xf0217240,%ebx
f0100e9b:	e9 61 fd ff ff       	jmp    f0100c01 <check_page_free_list+0x4f>

f0100ea0 <page_init>:
{
f0100ea0:	f3 0f 1e fb          	endbr32 
f0100ea4:	55                   	push   %ebp
f0100ea5:	89 e5                	mov    %esp,%ebp
f0100ea7:	57                   	push   %edi
f0100ea8:	56                   	push   %esi
f0100ea9:	53                   	push   %ebx
f0100eaa:	83 ec 0c             	sub    $0xc,%esp
	pages[0].pp_ref = 1;
f0100ead:	a1 90 7e 21 f0       	mov    0xf0217e90,%eax
f0100eb2:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	pages[0].pp_link = NULL;
f0100eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 1; i < npages_basemem; i++) {
f0100ebe:	8b 35 44 72 21 f0    	mov    0xf0217244,%esi
f0100ec4:	8b 1d 40 72 21 f0    	mov    0xf0217240,%ebx
f0100eca:	ba 00 00 00 00       	mov    $0x0,%edx
f0100ecf:	b8 01 00 00 00       	mov    $0x1,%eax
		page_free_list = &pages[i];
f0100ed4:	bf 01 00 00 00       	mov    $0x1,%edi
	for (i = 1; i < npages_basemem; i++) {
f0100ed9:	eb 03                	jmp    f0100ede <page_init+0x3e>
f0100edb:	83 c0 01             	add    $0x1,%eax
f0100ede:	39 c6                	cmp    %eax,%esi
f0100ee0:	76 28                	jbe    f0100f0a <page_init+0x6a>
		if(i == mpentry_index) continue;
f0100ee2:	83 f8 07             	cmp    $0x7,%eax
f0100ee5:	74 f4                	je     f0100edb <page_init+0x3b>
f0100ee7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100eee:	89 d1                	mov    %edx,%ecx
f0100ef0:	03 0d 90 7e 21 f0    	add    0xf0217e90,%ecx
f0100ef6:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100efc:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0100efe:	89 d3                	mov    %edx,%ebx
f0100f00:	03 1d 90 7e 21 f0    	add    0xf0217e90,%ebx
f0100f06:	89 fa                	mov    %edi,%edx
f0100f08:	eb d1                	jmp    f0100edb <page_init+0x3b>
f0100f0a:	84 d2                	test   %dl,%dl
f0100f0c:	74 06                	je     f0100f14 <page_init+0x74>
f0100f0e:	89 1d 40 72 21 f0    	mov    %ebx,0xf0217240
	for(i = io; i < ex; i++){
f0100f14:	b8 a0 00 00 00       	mov    $0xa0,%eax
		pages[i].pp_ref = 1;
f0100f19:	8b 15 90 7e 21 f0    	mov    0xf0217e90,%edx
f0100f1f:	8d 14 c2             	lea    (%edx,%eax,8),%edx
f0100f22:	66 c7 42 04 01 00    	movw   $0x1,0x4(%edx)
		pages[i].pp_link = NULL;
f0100f28:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	for(i = io; i < ex; i++){
f0100f2e:	83 c0 01             	add    $0x1,%eax
f0100f31:	3d ff 00 00 00       	cmp    $0xff,%eax
f0100f36:	77 07                	ja     f0100f3f <page_init+0x9f>
		if(i == mpentry_index) continue;
f0100f38:	83 f8 07             	cmp    $0x7,%eax
f0100f3b:	75 dc                	jne    f0100f19 <page_init+0x79>
f0100f3d:	eb ef                	jmp    f0100f2e <page_init+0x8e>
	size_t fisrt_page = PADDR(boot_alloc(0)) / PGSIZE;
f0100f3f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f44:	e8 87 fb ff ff       	call   f0100ad0 <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100f49:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100f4e:	76 0f                	jbe    f0100f5f <page_init+0xbf>
	return (physaddr_t)kva - KERNBASE;
f0100f50:	05 00 00 00 10       	add    $0x10000000,%eax
f0100f55:	c1 e8 0c             	shr    $0xc,%eax
	for(i = ex; i < fisrt_page; i++){
f0100f58:	ba 00 01 00 00       	mov    $0x100,%edx
f0100f5d:	eb 18                	jmp    f0100f77 <page_init+0xd7>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100f5f:	50                   	push   %eax
f0100f60:	68 28 68 10 f0       	push   $0xf0106828
f0100f65:	68 70 01 00 00       	push   $0x170
f0100f6a:	68 96 6d 10 f0       	push   $0xf0106d96
f0100f6f:	e8 cc f0 ff ff       	call   f0100040 <_panic>
f0100f74:	83 c2 01             	add    $0x1,%edx
f0100f77:	39 c2                	cmp    %eax,%edx
f0100f79:	73 1c                	jae    f0100f97 <page_init+0xf7>
		if(i == mpentry_index) continue;
f0100f7b:	83 fa 07             	cmp    $0x7,%edx
f0100f7e:	74 f4                	je     f0100f74 <page_init+0xd4>
		pages[i].pp_ref = 1;
f0100f80:	8b 0d 90 7e 21 f0    	mov    0xf0217e90,%ecx
f0100f86:	8d 0c d1             	lea    (%ecx,%edx,8),%ecx
f0100f89:	66 c7 41 04 01 00    	movw   $0x1,0x4(%ecx)
		pages[i].pp_link = NULL;
f0100f8f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f0100f95:	eb dd                	jmp    f0100f74 <page_init+0xd4>
f0100f97:	8b 1d 40 72 21 f0    	mov    0xf0217240,%ebx
	for(i = ex; i < fisrt_page; i++){
f0100f9d:	ba 00 00 00 00       	mov    $0x0,%edx
		page_free_list = &pages[i];
f0100fa2:	be 01 00 00 00       	mov    $0x1,%esi
f0100fa7:	eb 24                	jmp    f0100fcd <page_init+0x12d>
f0100fa9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100fb0:	89 d1                	mov    %edx,%ecx
f0100fb2:	03 0d 90 7e 21 f0    	add    0xf0217e90,%ecx
f0100fb8:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100fbe:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0100fc0:	89 d3                	mov    %edx,%ebx
f0100fc2:	03 1d 90 7e 21 f0    	add    0xf0217e90,%ebx
f0100fc8:	89 f2                	mov    %esi,%edx
	for(i = fisrt_page; i < npages; i++){
f0100fca:	83 c0 01             	add    $0x1,%eax
f0100fcd:	39 05 88 7e 21 f0    	cmp    %eax,0xf0217e88
f0100fd3:	76 07                	jbe    f0100fdc <page_init+0x13c>
		if(i == mpentry_index) continue;
f0100fd5:	83 f8 07             	cmp    $0x7,%eax
f0100fd8:	75 cf                	jne    f0100fa9 <page_init+0x109>
f0100fda:	eb ee                	jmp    f0100fca <page_init+0x12a>
f0100fdc:	84 d2                	test   %dl,%dl
f0100fde:	74 06                	je     f0100fe6 <page_init+0x146>
f0100fe0:	89 1d 40 72 21 f0    	mov    %ebx,0xf0217240
}
f0100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100fe9:	5b                   	pop    %ebx
f0100fea:	5e                   	pop    %esi
f0100feb:	5f                   	pop    %edi
f0100fec:	5d                   	pop    %ebp
f0100fed:	c3                   	ret    

f0100fee <page_alloc>:
{
f0100fee:	f3 0f 1e fb          	endbr32 
f0100ff2:	55                   	push   %ebp
f0100ff3:	89 e5                	mov    %esp,%ebp
f0100ff5:	53                   	push   %ebx
f0100ff6:	83 ec 04             	sub    $0x4,%esp
	if(!page_free_list) {
f0100ff9:	8b 1d 40 72 21 f0    	mov    0xf0217240,%ebx
f0100fff:	85 db                	test   %ebx,%ebx
f0101001:	74 1a                	je     f010101d <page_alloc+0x2f>
	page_free_list = page_free_list->pp_link;
f0101003:	8b 03                	mov    (%ebx),%eax
f0101005:	a3 40 72 21 f0       	mov    %eax,0xf0217240
	pp->pp_link = NULL;
f010100a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags && ALLOC_ZERO){
f0101010:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0101014:	75 19                	jne    f010102f <page_alloc+0x41>
}
f0101016:	89 d8                	mov    %ebx,%eax
f0101018:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010101b:	c9                   	leave  
f010101c:	c3                   	ret    
		cprintf("page_alloc: out of free memory\n");
f010101d:	83 ec 0c             	sub    $0xc,%esp
f0101020:	68 90 71 10 f0       	push   $0xf0107190
f0101025:	e8 dd 29 00 00       	call   f0103a07 <cprintf>
		return NULL;
f010102a:	83 c4 10             	add    $0x10,%esp
f010102d:	eb e7                	jmp    f0101016 <page_alloc+0x28>
	return (pp - pages) << PGSHIFT;
f010102f:	89 d8                	mov    %ebx,%eax
f0101031:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101037:	c1 f8 03             	sar    $0x3,%eax
f010103a:	89 c2                	mov    %eax,%edx
f010103c:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010103f:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101044:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f010104a:	73 1b                	jae    f0101067 <page_alloc+0x79>
		memset(page2kva(pp), '\0', PGSIZE);
f010104c:	83 ec 04             	sub    $0x4,%esp
f010104f:	68 00 10 00 00       	push   $0x1000
f0101054:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101056:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f010105c:	52                   	push   %edx
f010105d:	e8 e0 4a 00 00       	call   f0105b42 <memset>
f0101062:	83 c4 10             	add    $0x10,%esp
f0101065:	eb af                	jmp    f0101016 <page_alloc+0x28>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101067:	52                   	push   %edx
f0101068:	68 04 68 10 f0       	push   $0xf0106804
f010106d:	6a 58                	push   $0x58
f010106f:	68 a2 6d 10 f0       	push   $0xf0106da2
f0101074:	e8 c7 ef ff ff       	call   f0100040 <_panic>

f0101079 <page_free>:
{
f0101079:	f3 0f 1e fb          	endbr32 
f010107d:	55                   	push   %ebp
f010107e:	89 e5                	mov    %esp,%ebp
f0101080:	83 ec 08             	sub    $0x8,%esp
f0101083:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0){
f0101086:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f010108b:	75 14                	jne    f01010a1 <page_free+0x28>
	}else if(pp->pp_link != NULL){
f010108d:	83 38 00             	cmpl   $0x0,(%eax)
f0101090:	75 26                	jne    f01010b8 <page_free+0x3f>
		pp->pp_link = page_free_list;
f0101092:	8b 15 40 72 21 f0    	mov    0xf0217240,%edx
f0101098:	89 10                	mov    %edx,(%eax)
		page_free_list = pp;
f010109a:	a3 40 72 21 f0       	mov    %eax,0xf0217240
}
f010109f:	c9                   	leave  
f01010a0:	c3                   	ret    
		panic("page_free: pp->pp_ref is nonzero\n");
f01010a1:	83 ec 04             	sub    $0x4,%esp
f01010a4:	68 b0 71 10 f0       	push   $0xf01071b0
f01010a9:	68 aa 01 00 00       	push   $0x1aa
f01010ae:	68 96 6d 10 f0       	push   $0xf0106d96
f01010b3:	e8 88 ef ff ff       	call   f0100040 <_panic>
		panic("page_free: pp->pp_link is NULL\n");
f01010b8:	83 ec 04             	sub    $0x4,%esp
f01010bb:	68 d4 71 10 f0       	push   $0xf01071d4
f01010c0:	68 ac 01 00 00       	push   $0x1ac
f01010c5:	68 96 6d 10 f0       	push   $0xf0106d96
f01010ca:	e8 71 ef ff ff       	call   f0100040 <_panic>

f01010cf <page_decref>:
{
f01010cf:	f3 0f 1e fb          	endbr32 
f01010d3:	55                   	push   %ebp
f01010d4:	89 e5                	mov    %esp,%ebp
f01010d6:	83 ec 08             	sub    $0x8,%esp
f01010d9:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f01010dc:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01010e0:	83 e8 01             	sub    $0x1,%eax
f01010e3:	66 89 42 04          	mov    %ax,0x4(%edx)
f01010e7:	66 85 c0             	test   %ax,%ax
f01010ea:	74 02                	je     f01010ee <page_decref+0x1f>
}
f01010ec:	c9                   	leave  
f01010ed:	c3                   	ret    
		page_free(pp);
f01010ee:	83 ec 0c             	sub    $0xc,%esp
f01010f1:	52                   	push   %edx
f01010f2:	e8 82 ff ff ff       	call   f0101079 <page_free>
f01010f7:	83 c4 10             	add    $0x10,%esp
}
f01010fa:	eb f0                	jmp    f01010ec <page_decref+0x1d>

f01010fc <pgdir_walk>:
{
f01010fc:	f3 0f 1e fb          	endbr32 
f0101100:	55                   	push   %ebp
f0101101:	89 e5                	mov    %esp,%ebp
f0101103:	56                   	push   %esi
f0101104:	53                   	push   %ebx
f0101105:	8b 45 0c             	mov    0xc(%ebp),%eax
	uint32_t ptx = PTX(va);		//页表项索引
f0101108:	89 c6                	mov    %eax,%esi
f010110a:	c1 ee 0c             	shr    $0xc,%esi
f010110d:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	uint32_t pdx = PDX(va);		//页目录项索引
f0101113:	c1 e8 16             	shr    $0x16,%eax
	pde = &pgdir[pdx];			//获取页目录项
f0101116:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
f010111d:	03 5d 08             	add    0x8(%ebp),%ebx
	if((*pde) & PTE_P){
f0101120:	8b 03                	mov    (%ebx),%eax
f0101122:	a8 01                	test   $0x1,%al
f0101124:	74 38                	je     f010115e <pgdir_walk+0x62>
		pte = (KADDR(PTE_ADDR(*pde)));
f0101126:	89 c2                	mov    %eax,%edx
f0101128:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f010112e:	c1 e8 0c             	shr    $0xc,%eax
f0101131:	39 05 88 7e 21 f0    	cmp    %eax,0xf0217e88
f0101137:	76 10                	jbe    f0101149 <pgdir_walk+0x4d>
	return (void *)(pa + KERNBASE);
f0101139:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	return (pte_t*)&pte[ptx];
f010113f:	8d 04 b0             	lea    (%eax,%esi,4),%eax
}
f0101142:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101145:	5b                   	pop    %ebx
f0101146:	5e                   	pop    %esi
f0101147:	5d                   	pop    %ebp
f0101148:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101149:	52                   	push   %edx
f010114a:	68 04 68 10 f0       	push   $0xf0106804
f010114f:	68 e6 01 00 00       	push   $0x1e6
f0101154:	68 96 6d 10 f0       	push   $0xf0106d96
f0101159:	e8 e2 ee ff ff       	call   f0100040 <_panic>
		if(!create){
f010115e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101162:	74 6f                	je     f01011d3 <pgdir_walk+0xd7>
		if(!(pp = page_alloc(ALLOC_ZERO))){
f0101164:	83 ec 0c             	sub    $0xc,%esp
f0101167:	6a 01                	push   $0x1
f0101169:	e8 80 fe ff ff       	call   f0100fee <page_alloc>
f010116e:	83 c4 10             	add    $0x10,%esp
f0101171:	85 c0                	test   %eax,%eax
f0101173:	74 cd                	je     f0101142 <pgdir_walk+0x46>
		pp->pp_ref++;
f0101175:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010117a:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101180:	c1 f8 03             	sar    $0x3,%eax
f0101183:	89 c2                	mov    %eax,%edx
f0101185:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101188:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010118d:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0101193:	73 17                	jae    f01011ac <pgdir_walk+0xb0>
	return (void *)(pa + KERNBASE);
f0101195:	8d 8a 00 00 00 f0    	lea    -0x10000000(%edx),%ecx
f010119b:	89 c8                	mov    %ecx,%eax
	if ((uint32_t)kva < KERNBASE)
f010119d:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f01011a3:	76 19                	jbe    f01011be <pgdir_walk+0xc2>
		*pde = PADDR(pte) | PTE_P | PTE_W | PTE_U;
f01011a5:	83 ca 07             	or     $0x7,%edx
f01011a8:	89 13                	mov    %edx,(%ebx)
f01011aa:	eb 93                	jmp    f010113f <pgdir_walk+0x43>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01011ac:	52                   	push   %edx
f01011ad:	68 04 68 10 f0       	push   $0xf0106804
f01011b2:	6a 58                	push   $0x58
f01011b4:	68 a2 6d 10 f0       	push   $0xf0106da2
f01011b9:	e8 82 ee ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01011be:	51                   	push   %ecx
f01011bf:	68 28 68 10 f0       	push   $0xf0106828
f01011c4:	68 f7 01 00 00       	push   $0x1f7
f01011c9:	68 96 6d 10 f0       	push   $0xf0106d96
f01011ce:	e8 6d ee ff ff       	call   f0100040 <_panic>
			return NULL;
f01011d3:	b8 00 00 00 00       	mov    $0x0,%eax
f01011d8:	e9 65 ff ff ff       	jmp    f0101142 <pgdir_walk+0x46>

f01011dd <boot_map_region>:
{
f01011dd:	55                   	push   %ebp
f01011de:	89 e5                	mov    %esp,%ebp
f01011e0:	57                   	push   %edi
f01011e1:	56                   	push   %esi
f01011e2:	53                   	push   %ebx
f01011e3:	83 ec 1c             	sub    $0x1c,%esp
f01011e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01011e9:	8b 45 08             	mov    0x8(%ebp),%eax
	size_t pgs = (size + PGSIZE - 1) / PGSIZE;
f01011ec:	8d b1 ff 0f 00 00    	lea    0xfff(%ecx),%esi
f01011f2:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f01011f8:	01 c6                	add    %eax,%esi
	for(size_t i = 0; i < pgs; i++){
f01011fa:	89 c3                	mov    %eax,%ebx
		pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
f01011fc:	89 d7                	mov    %edx,%edi
f01011fe:	29 c7                	sub    %eax,%edi
	for(size_t i = 0; i < pgs; i++){
f0101200:	39 f3                	cmp    %esi,%ebx
f0101202:	74 28                	je     f010122c <boot_map_region+0x4f>
		pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
f0101204:	83 ec 04             	sub    $0x4,%esp
f0101207:	6a 01                	push   $0x1
f0101209:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
f010120c:	50                   	push   %eax
f010120d:	ff 75 e4             	pushl  -0x1c(%ebp)
f0101210:	e8 e7 fe ff ff       	call   f01010fc <pgdir_walk>
f0101215:	89 c2                	mov    %eax,%edx
		*pte = pa | PTE_P | perm;
f0101217:	89 d8                	mov    %ebx,%eax
f0101219:	0b 45 0c             	or     0xc(%ebp),%eax
f010121c:	83 c8 01             	or     $0x1,%eax
f010121f:	89 02                	mov    %eax,(%edx)
		pa += PGSIZE;
f0101221:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101227:	83 c4 10             	add    $0x10,%esp
f010122a:	eb d4                	jmp    f0101200 <boot_map_region+0x23>
}
f010122c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010122f:	5b                   	pop    %ebx
f0101230:	5e                   	pop    %esi
f0101231:	5f                   	pop    %edi
f0101232:	5d                   	pop    %ebp
f0101233:	c3                   	ret    

f0101234 <page_lookup>:
{
f0101234:	f3 0f 1e fb          	endbr32 
f0101238:	55                   	push   %ebp
f0101239:	89 e5                	mov    %esp,%ebp
f010123b:	53                   	push   %ebx
f010123c:	83 ec 08             	sub    $0x8,%esp
f010123f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t* pte = pgdir_walk(pgdir, va, false);
f0101242:	6a 00                	push   $0x0
f0101244:	ff 75 0c             	pushl  0xc(%ebp)
f0101247:	ff 75 08             	pushl  0x8(%ebp)
f010124a:	e8 ad fe ff ff       	call   f01010fc <pgdir_walk>
	if(!pte || !((*pte) & PTE_P)){
f010124f:	83 c4 10             	add    $0x10,%esp
f0101252:	85 c0                	test   %eax,%eax
f0101254:	74 26                	je     f010127c <page_lookup+0x48>
f0101256:	f6 00 01             	testb  $0x1,(%eax)
f0101259:	74 21                	je     f010127c <page_lookup+0x48>
	if(pte_store != NULL){
f010125b:	85 db                	test   %ebx,%ebx
f010125d:	74 02                	je     f0101261 <page_lookup+0x2d>
		*pte_store = pte;
f010125f:	89 03                	mov    %eax,(%ebx)
f0101261:	8b 00                	mov    (%eax),%eax
f0101263:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101266:	39 05 88 7e 21 f0    	cmp    %eax,0xf0217e88
f010126c:	76 25                	jbe    f0101293 <page_lookup+0x5f>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f010126e:	8b 15 90 7e 21 f0    	mov    0xf0217e90,%edx
f0101274:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101277:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010127a:	c9                   	leave  
f010127b:	c3                   	ret    
		cprintf("page_lookup: can not find out the page mapped at virtual address 'va'.\n");
f010127c:	83 ec 0c             	sub    $0xc,%esp
f010127f:	68 f4 71 10 f0       	push   $0xf01071f4
f0101284:	e8 7e 27 00 00       	call   f0103a07 <cprintf>
		return NULL;
f0101289:	83 c4 10             	add    $0x10,%esp
f010128c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101291:	eb e4                	jmp    f0101277 <page_lookup+0x43>
		panic("pa2page called with invalid pa");
f0101293:	83 ec 04             	sub    $0x4,%esp
f0101296:	68 3c 72 10 f0       	push   $0xf010723c
f010129b:	6a 51                	push   $0x51
f010129d:	68 a2 6d 10 f0       	push   $0xf0106da2
f01012a2:	e8 99 ed ff ff       	call   f0100040 <_panic>

f01012a7 <tlb_invalidate>:
{
f01012a7:	f3 0f 1e fb          	endbr32 
f01012ab:	55                   	push   %ebp
f01012ac:	89 e5                	mov    %esp,%ebp
f01012ae:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f01012b1:	e8 ac 4e 00 00       	call   f0106162 <cpunum>
f01012b6:	6b c0 74             	imul   $0x74,%eax,%eax
f01012b9:	83 b8 28 80 21 f0 00 	cmpl   $0x0,-0xfde7fd8(%eax)
f01012c0:	74 16                	je     f01012d8 <tlb_invalidate+0x31>
f01012c2:	e8 9b 4e 00 00       	call   f0106162 <cpunum>
f01012c7:	6b c0 74             	imul   $0x74,%eax,%eax
f01012ca:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f01012d0:	8b 55 08             	mov    0x8(%ebp),%edx
f01012d3:	39 50 60             	cmp    %edx,0x60(%eax)
f01012d6:	75 06                	jne    f01012de <tlb_invalidate+0x37>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01012db:	0f 01 38             	invlpg (%eax)
}
f01012de:	c9                   	leave  
f01012df:	c3                   	ret    

f01012e0 <page_remove>:
{
f01012e0:	f3 0f 1e fb          	endbr32 
f01012e4:	55                   	push   %ebp
f01012e5:	89 e5                	mov    %esp,%ebp
f01012e7:	56                   	push   %esi
f01012e8:	53                   	push   %ebx
f01012e9:	83 ec 14             	sub    $0x14,%esp
f01012ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01012ef:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo* pp = page_lookup(pgdir, va, &pte);
f01012f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01012f5:	50                   	push   %eax
f01012f6:	56                   	push   %esi
f01012f7:	53                   	push   %ebx
f01012f8:	e8 37 ff ff ff       	call   f0101234 <page_lookup>
	if(pp){
f01012fd:	83 c4 10             	add    $0x10,%esp
f0101300:	85 c0                	test   %eax,%eax
f0101302:	74 1f                	je     f0101323 <page_remove+0x43>
		page_decref(pp);
f0101304:	83 ec 0c             	sub    $0xc,%esp
f0101307:	50                   	push   %eax
f0101308:	e8 c2 fd ff ff       	call   f01010cf <page_decref>
		*pte = 0;
f010130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, va);
f0101316:	83 c4 08             	add    $0x8,%esp
f0101319:	56                   	push   %esi
f010131a:	53                   	push   %ebx
f010131b:	e8 87 ff ff ff       	call   f01012a7 <tlb_invalidate>
f0101320:	83 c4 10             	add    $0x10,%esp
}
f0101323:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101326:	5b                   	pop    %ebx
f0101327:	5e                   	pop    %esi
f0101328:	5d                   	pop    %ebp
f0101329:	c3                   	ret    

f010132a <page_insert>:
{
f010132a:	f3 0f 1e fb          	endbr32 
f010132e:	55                   	push   %ebp
f010132f:	89 e5                	mov    %esp,%ebp
f0101331:	57                   	push   %edi
f0101332:	56                   	push   %esi
f0101333:	53                   	push   %ebx
f0101334:	83 ec 10             	sub    $0x10,%esp
f0101337:	8b 7d 08             	mov    0x8(%ebp),%edi
f010133a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t* pte = pgdir_walk(pgdir, va, true);
f010133d:	6a 01                	push   $0x1
f010133f:	ff 75 10             	pushl  0x10(%ebp)
f0101342:	57                   	push   %edi
f0101343:	e8 b4 fd ff ff       	call   f01010fc <pgdir_walk>
	if(!pte){
f0101348:	83 c4 10             	add    $0x10,%esp
f010134b:	85 c0                	test   %eax,%eax
f010134d:	74 67                	je     f01013b6 <page_insert+0x8c>
f010134f:	89 c6                	mov    %eax,%esi
	if((*pte) & PTE_P){
f0101351:	8b 00                	mov    (%eax),%eax
f0101353:	a8 01                	test   $0x1,%al
f0101355:	74 1c                	je     f0101373 <page_insert+0x49>
		if(PTE_ADDR(*pte) == page2pa(pp)){
f0101357:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	return (pp - pages) << PGSHIFT;
f010135c:	89 da                	mov    %ebx,%edx
f010135e:	2b 15 90 7e 21 f0    	sub    0xf0217e90,%edx
f0101364:	c1 fa 03             	sar    $0x3,%edx
f0101367:	c1 e2 0c             	shl    $0xc,%edx
f010136a:	39 d0                	cmp    %edx,%eax
f010136c:	75 37                	jne    f01013a5 <page_insert+0x7b>
			pp->pp_ref--;
f010136e:	66 83 6b 04 01       	subw   $0x1,0x4(%ebx)
	pp->pp_ref++;
f0101373:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
f0101378:	2b 1d 90 7e 21 f0    	sub    0xf0217e90,%ebx
f010137e:	c1 fb 03             	sar    $0x3,%ebx
f0101381:	c1 e3 0c             	shl    $0xc,%ebx
	*pte = page2pa(pp) | perm | PTE_P;
f0101384:	0b 5d 14             	or     0x14(%ebp),%ebx
f0101387:	83 cb 01             	or     $0x1,%ebx
f010138a:	89 1e                	mov    %ebx,(%esi)
	pgdir[PDX(va)] |= perm;
f010138c:	8b 45 10             	mov    0x10(%ebp),%eax
f010138f:	c1 e8 16             	shr    $0x16,%eax
f0101392:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0101395:	09 0c 87             	or     %ecx,(%edi,%eax,4)
	return 0;
f0101398:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010139d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01013a0:	5b                   	pop    %ebx
f01013a1:	5e                   	pop    %esi
f01013a2:	5f                   	pop    %edi
f01013a3:	5d                   	pop    %ebp
f01013a4:	c3                   	ret    
			page_remove(pgdir, va);
f01013a5:	83 ec 08             	sub    $0x8,%esp
f01013a8:	ff 75 10             	pushl  0x10(%ebp)
f01013ab:	57                   	push   %edi
f01013ac:	e8 2f ff ff ff       	call   f01012e0 <page_remove>
f01013b1:	83 c4 10             	add    $0x10,%esp
f01013b4:	eb bd                	jmp    f0101373 <page_insert+0x49>
		return -E_NO_MEM;
f01013b6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01013bb:	eb e0                	jmp    f010139d <page_insert+0x73>

f01013bd <mmio_map_region>:
{
f01013bd:	f3 0f 1e fb          	endbr32 
f01013c1:	55                   	push   %ebp
f01013c2:	89 e5                	mov    %esp,%ebp
f01013c4:	53                   	push   %ebx
f01013c5:	83 ec 04             	sub    $0x4,%esp
	size = ROUNDUP(size, PGSIZE);
f01013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01013cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f01013d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if(size + base > MMIOLIM){
f01013d7:	8b 15 00 33 12 f0    	mov    0xf0123300,%edx
f01013dd:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
f01013e0:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f01013e5:	77 26                	ja     f010140d <mmio_map_region+0x50>
	boot_map_region(kern_pgdir, base, size, pa, PTE_W | PTE_PCD | PTE_PWT);
f01013e7:	83 ec 08             	sub    $0x8,%esp
f01013ea:	6a 1a                	push   $0x1a
f01013ec:	ff 75 08             	pushl  0x8(%ebp)
f01013ef:	89 d9                	mov    %ebx,%ecx
f01013f1:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f01013f6:	e8 e2 fd ff ff       	call   f01011dd <boot_map_region>
	base += size;
f01013fb:	a1 00 33 12 f0       	mov    0xf0123300,%eax
f0101400:	01 c3                	add    %eax,%ebx
f0101402:	89 1d 00 33 12 f0    	mov    %ebx,0xf0123300
}
f0101408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010140b:	c9                   	leave  
f010140c:	c3                   	ret    
		panic("MMIO_MAP_REGION failed: memory overflow MMIOLIM\n");
f010140d:	83 ec 04             	sub    $0x4,%esp
f0101410:	68 5c 72 10 f0       	push   $0xf010725c
f0101415:	68 cd 02 00 00       	push   $0x2cd
f010141a:	68 96 6d 10 f0       	push   $0xf0106d96
f010141f:	e8 1c ec ff ff       	call   f0100040 <_panic>

f0101424 <mem_init>:
{
f0101424:	f3 0f 1e fb          	endbr32 
f0101428:	55                   	push   %ebp
f0101429:	89 e5                	mov    %esp,%ebp
f010142b:	57                   	push   %edi
f010142c:	56                   	push   %esi
f010142d:	53                   	push   %ebx
f010142e:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f0101431:	b8 15 00 00 00       	mov    $0x15,%eax
f0101436:	e8 eb f6 ff ff       	call   f0100b26 <nvram_read>
f010143b:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f010143d:	b8 17 00 00 00       	mov    $0x17,%eax
f0101442:	e8 df f6 ff ff       	call   f0100b26 <nvram_read>
f0101447:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101449:	b8 34 00 00 00       	mov    $0x34,%eax
f010144e:	e8 d3 f6 ff ff       	call   f0100b26 <nvram_read>
	if (ext16mem)
f0101453:	c1 e0 06             	shl    $0x6,%eax
f0101456:	0f 84 ea 00 00 00    	je     f0101546 <mem_init+0x122>
		totalmem = 16 * 1024 + ext16mem;
f010145c:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f0101461:	89 c2                	mov    %eax,%edx
f0101463:	c1 ea 02             	shr    $0x2,%edx
f0101466:	89 15 88 7e 21 f0    	mov    %edx,0xf0217e88
	npages_basemem = basemem / (PGSIZE / 1024);
f010146c:	89 da                	mov    %ebx,%edx
f010146e:	c1 ea 02             	shr    $0x2,%edx
f0101471:	89 15 44 72 21 f0    	mov    %edx,0xf0217244
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101477:	89 c2                	mov    %eax,%edx
f0101479:	29 da                	sub    %ebx,%edx
f010147b:	52                   	push   %edx
f010147c:	53                   	push   %ebx
f010147d:	50                   	push   %eax
f010147e:	68 90 72 10 f0       	push   $0xf0107290
f0101483:	e8 7f 25 00 00       	call   f0103a07 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101488:	b8 00 10 00 00       	mov    $0x1000,%eax
f010148d:	e8 3e f6 ff ff       	call   f0100ad0 <boot_alloc>
f0101492:	a3 8c 7e 21 f0       	mov    %eax,0xf0217e8c
	memset(kern_pgdir, 0, PGSIZE);
f0101497:	83 c4 0c             	add    $0xc,%esp
f010149a:	68 00 10 00 00       	push   $0x1000
f010149f:	6a 00                	push   $0x0
f01014a1:	50                   	push   %eax
f01014a2:	e8 9b 46 00 00       	call   f0105b42 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01014a7:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01014ac:	83 c4 10             	add    $0x10,%esp
f01014af:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01014b4:	0f 86 9c 00 00 00    	jbe    f0101556 <mem_init+0x132>
	return (physaddr_t)kva - KERNBASE;
f01014ba:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01014c0:	83 ca 05             	or     $0x5,%edx
f01014c3:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);
f01014c9:	a1 88 7e 21 f0       	mov    0xf0217e88,%eax
f01014ce:	c1 e0 03             	shl    $0x3,%eax
f01014d1:	e8 fa f5 ff ff       	call   f0100ad0 <boot_alloc>
f01014d6:	a3 90 7e 21 f0       	mov    %eax,0xf0217e90
	memset(pages, 0, sizeof(struct PageInfo) * npages);
f01014db:	83 ec 04             	sub    $0x4,%esp
f01014de:	8b 0d 88 7e 21 f0    	mov    0xf0217e88,%ecx
f01014e4:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f01014eb:	52                   	push   %edx
f01014ec:	6a 00                	push   $0x0
f01014ee:	50                   	push   %eax
f01014ef:	e8 4e 46 00 00       	call   f0105b42 <memset>
	envs = (struct Env*)boot_alloc(sizeof(struct Env) * NENV);
f01014f4:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f01014f9:	e8 d2 f5 ff ff       	call   f0100ad0 <boot_alloc>
f01014fe:	a3 48 72 21 f0       	mov    %eax,0xf0217248
	memset(envs, 0, sizeof(struct Env) * NENV);
f0101503:	83 c4 0c             	add    $0xc,%esp
f0101506:	68 00 f0 01 00       	push   $0x1f000
f010150b:	6a 00                	push   $0x0
f010150d:	50                   	push   %eax
f010150e:	e8 2f 46 00 00       	call   f0105b42 <memset>
	page_init();
f0101513:	e8 88 f9 ff ff       	call   f0100ea0 <page_init>
	check_page_free_list(1);
f0101518:	b8 01 00 00 00       	mov    $0x1,%eax
f010151d:	e8 90 f6 ff ff       	call   f0100bb2 <check_page_free_list>
	if (!pages)
f0101522:	83 c4 10             	add    $0x10,%esp
f0101525:	83 3d 90 7e 21 f0 00 	cmpl   $0x0,0xf0217e90
f010152c:	74 3d                	je     f010156b <mem_init+0x147>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010152e:	a1 40 72 21 f0       	mov    0xf0217240,%eax
f0101533:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010153a:	85 c0                	test   %eax,%eax
f010153c:	74 44                	je     f0101582 <mem_init+0x15e>
		++nfree;
f010153e:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101542:	8b 00                	mov    (%eax),%eax
f0101544:	eb f4                	jmp    f010153a <mem_init+0x116>
		totalmem = 1 * 1024 + extmem;
f0101546:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f010154c:	85 f6                	test   %esi,%esi
f010154e:	0f 44 c3             	cmove  %ebx,%eax
f0101551:	e9 0b ff ff ff       	jmp    f0101461 <mem_init+0x3d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101556:	50                   	push   %eax
f0101557:	68 28 68 10 f0       	push   $0xf0106828
f010155c:	68 99 00 00 00       	push   $0x99
f0101561:	68 96 6d 10 f0       	push   $0xf0106d96
f0101566:	e8 d5 ea ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f010156b:	83 ec 04             	sub    $0x4,%esp
f010156e:	68 69 6e 10 f0       	push   $0xf0106e69
f0101573:	68 65 03 00 00       	push   $0x365
f0101578:	68 96 6d 10 f0       	push   $0xf0106d96
f010157d:	e8 be ea ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0101582:	83 ec 0c             	sub    $0xc,%esp
f0101585:	6a 00                	push   $0x0
f0101587:	e8 62 fa ff ff       	call   f0100fee <page_alloc>
f010158c:	89 c3                	mov    %eax,%ebx
f010158e:	83 c4 10             	add    $0x10,%esp
f0101591:	85 c0                	test   %eax,%eax
f0101593:	0f 84 11 02 00 00    	je     f01017aa <mem_init+0x386>
	assert((pp1 = page_alloc(0)));
f0101599:	83 ec 0c             	sub    $0xc,%esp
f010159c:	6a 00                	push   $0x0
f010159e:	e8 4b fa ff ff       	call   f0100fee <page_alloc>
f01015a3:	89 c6                	mov    %eax,%esi
f01015a5:	83 c4 10             	add    $0x10,%esp
f01015a8:	85 c0                	test   %eax,%eax
f01015aa:	0f 84 13 02 00 00    	je     f01017c3 <mem_init+0x39f>
	assert((pp2 = page_alloc(0)));
f01015b0:	83 ec 0c             	sub    $0xc,%esp
f01015b3:	6a 00                	push   $0x0
f01015b5:	e8 34 fa ff ff       	call   f0100fee <page_alloc>
f01015ba:	89 c7                	mov    %eax,%edi
f01015bc:	83 c4 10             	add    $0x10,%esp
f01015bf:	85 c0                	test   %eax,%eax
f01015c1:	0f 84 15 02 00 00    	je     f01017dc <mem_init+0x3b8>
	assert(pp1 && pp1 != pp0);
f01015c7:	39 f3                	cmp    %esi,%ebx
f01015c9:	0f 84 26 02 00 00    	je     f01017f5 <mem_init+0x3d1>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01015cf:	39 c6                	cmp    %eax,%esi
f01015d1:	0f 84 37 02 00 00    	je     f010180e <mem_init+0x3ea>
f01015d7:	39 c3                	cmp    %eax,%ebx
f01015d9:	0f 84 2f 02 00 00    	je     f010180e <mem_init+0x3ea>
	return (pp - pages) << PGSHIFT;
f01015df:	8b 0d 90 7e 21 f0    	mov    0xf0217e90,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f01015e5:	8b 15 88 7e 21 f0    	mov    0xf0217e88,%edx
f01015eb:	c1 e2 0c             	shl    $0xc,%edx
f01015ee:	89 d8                	mov    %ebx,%eax
f01015f0:	29 c8                	sub    %ecx,%eax
f01015f2:	c1 f8 03             	sar    $0x3,%eax
f01015f5:	c1 e0 0c             	shl    $0xc,%eax
f01015f8:	39 d0                	cmp    %edx,%eax
f01015fa:	0f 83 27 02 00 00    	jae    f0101827 <mem_init+0x403>
f0101600:	89 f0                	mov    %esi,%eax
f0101602:	29 c8                	sub    %ecx,%eax
f0101604:	c1 f8 03             	sar    $0x3,%eax
f0101607:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f010160a:	39 c2                	cmp    %eax,%edx
f010160c:	0f 86 2e 02 00 00    	jbe    f0101840 <mem_init+0x41c>
f0101612:	89 f8                	mov    %edi,%eax
f0101614:	29 c8                	sub    %ecx,%eax
f0101616:	c1 f8 03             	sar    $0x3,%eax
f0101619:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f010161c:	39 c2                	cmp    %eax,%edx
f010161e:	0f 86 35 02 00 00    	jbe    f0101859 <mem_init+0x435>
	fl = page_free_list;
f0101624:	a1 40 72 21 f0       	mov    0xf0217240,%eax
f0101629:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f010162c:	c7 05 40 72 21 f0 00 	movl   $0x0,0xf0217240
f0101633:	00 00 00 
	assert(!page_alloc(0));
f0101636:	83 ec 0c             	sub    $0xc,%esp
f0101639:	6a 00                	push   $0x0
f010163b:	e8 ae f9 ff ff       	call   f0100fee <page_alloc>
f0101640:	83 c4 10             	add    $0x10,%esp
f0101643:	85 c0                	test   %eax,%eax
f0101645:	0f 85 27 02 00 00    	jne    f0101872 <mem_init+0x44e>
	page_free(pp0);
f010164b:	83 ec 0c             	sub    $0xc,%esp
f010164e:	53                   	push   %ebx
f010164f:	e8 25 fa ff ff       	call   f0101079 <page_free>
	page_free(pp1);
f0101654:	89 34 24             	mov    %esi,(%esp)
f0101657:	e8 1d fa ff ff       	call   f0101079 <page_free>
	page_free(pp2);
f010165c:	89 3c 24             	mov    %edi,(%esp)
f010165f:	e8 15 fa ff ff       	call   f0101079 <page_free>
	assert((pp0 = page_alloc(0)));
f0101664:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010166b:	e8 7e f9 ff ff       	call   f0100fee <page_alloc>
f0101670:	89 c3                	mov    %eax,%ebx
f0101672:	83 c4 10             	add    $0x10,%esp
f0101675:	85 c0                	test   %eax,%eax
f0101677:	0f 84 0e 02 00 00    	je     f010188b <mem_init+0x467>
	assert((pp1 = page_alloc(0)));
f010167d:	83 ec 0c             	sub    $0xc,%esp
f0101680:	6a 00                	push   $0x0
f0101682:	e8 67 f9 ff ff       	call   f0100fee <page_alloc>
f0101687:	89 c6                	mov    %eax,%esi
f0101689:	83 c4 10             	add    $0x10,%esp
f010168c:	85 c0                	test   %eax,%eax
f010168e:	0f 84 10 02 00 00    	je     f01018a4 <mem_init+0x480>
	assert((pp2 = page_alloc(0)));
f0101694:	83 ec 0c             	sub    $0xc,%esp
f0101697:	6a 00                	push   $0x0
f0101699:	e8 50 f9 ff ff       	call   f0100fee <page_alloc>
f010169e:	89 c7                	mov    %eax,%edi
f01016a0:	83 c4 10             	add    $0x10,%esp
f01016a3:	85 c0                	test   %eax,%eax
f01016a5:	0f 84 12 02 00 00    	je     f01018bd <mem_init+0x499>
	assert(pp1 && pp1 != pp0);
f01016ab:	39 f3                	cmp    %esi,%ebx
f01016ad:	0f 84 23 02 00 00    	je     f01018d6 <mem_init+0x4b2>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01016b3:	39 c3                	cmp    %eax,%ebx
f01016b5:	0f 84 34 02 00 00    	je     f01018ef <mem_init+0x4cb>
f01016bb:	39 c6                	cmp    %eax,%esi
f01016bd:	0f 84 2c 02 00 00    	je     f01018ef <mem_init+0x4cb>
	assert(!page_alloc(0));
f01016c3:	83 ec 0c             	sub    $0xc,%esp
f01016c6:	6a 00                	push   $0x0
f01016c8:	e8 21 f9 ff ff       	call   f0100fee <page_alloc>
f01016cd:	83 c4 10             	add    $0x10,%esp
f01016d0:	85 c0                	test   %eax,%eax
f01016d2:	0f 85 30 02 00 00    	jne    f0101908 <mem_init+0x4e4>
f01016d8:	89 d8                	mov    %ebx,%eax
f01016da:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f01016e0:	c1 f8 03             	sar    $0x3,%eax
f01016e3:	89 c2                	mov    %eax,%edx
f01016e5:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01016e8:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01016ed:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f01016f3:	0f 83 28 02 00 00    	jae    f0101921 <mem_init+0x4fd>
	memset(page2kva(pp0), 1, PGSIZE);
f01016f9:	83 ec 04             	sub    $0x4,%esp
f01016fc:	68 00 10 00 00       	push   $0x1000
f0101701:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101703:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101709:	52                   	push   %edx
f010170a:	e8 33 44 00 00       	call   f0105b42 <memset>
	page_free(pp0);
f010170f:	89 1c 24             	mov    %ebx,(%esp)
f0101712:	e8 62 f9 ff ff       	call   f0101079 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101717:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010171e:	e8 cb f8 ff ff       	call   f0100fee <page_alloc>
f0101723:	83 c4 10             	add    $0x10,%esp
f0101726:	85 c0                	test   %eax,%eax
f0101728:	0f 84 05 02 00 00    	je     f0101933 <mem_init+0x50f>
	assert(pp && pp0 == pp);
f010172e:	39 c3                	cmp    %eax,%ebx
f0101730:	0f 85 16 02 00 00    	jne    f010194c <mem_init+0x528>
	return (pp - pages) << PGSHIFT;
f0101736:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f010173c:	c1 f8 03             	sar    $0x3,%eax
f010173f:	89 c2                	mov    %eax,%edx
f0101741:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101744:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101749:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f010174f:	0f 83 10 02 00 00    	jae    f0101965 <mem_init+0x541>
	return (void *)(pa + KERNBASE);
f0101755:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f010175b:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f0101761:	80 38 00             	cmpb   $0x0,(%eax)
f0101764:	0f 85 0d 02 00 00    	jne    f0101977 <mem_init+0x553>
f010176a:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f010176d:	39 d0                	cmp    %edx,%eax
f010176f:	75 f0                	jne    f0101761 <mem_init+0x33d>
	page_free_list = fl;
f0101771:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101774:	a3 40 72 21 f0       	mov    %eax,0xf0217240
	page_free(pp0);
f0101779:	83 ec 0c             	sub    $0xc,%esp
f010177c:	53                   	push   %ebx
f010177d:	e8 f7 f8 ff ff       	call   f0101079 <page_free>
	page_free(pp1);
f0101782:	89 34 24             	mov    %esi,(%esp)
f0101785:	e8 ef f8 ff ff       	call   f0101079 <page_free>
	page_free(pp2);
f010178a:	89 3c 24             	mov    %edi,(%esp)
f010178d:	e8 e7 f8 ff ff       	call   f0101079 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101792:	a1 40 72 21 f0       	mov    0xf0217240,%eax
f0101797:	83 c4 10             	add    $0x10,%esp
f010179a:	85 c0                	test   %eax,%eax
f010179c:	0f 84 ee 01 00 00    	je     f0101990 <mem_init+0x56c>
		--nfree;
f01017a2:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01017a6:	8b 00                	mov    (%eax),%eax
f01017a8:	eb f0                	jmp    f010179a <mem_init+0x376>
	assert((pp0 = page_alloc(0)));
f01017aa:	68 84 6e 10 f0       	push   $0xf0106e84
f01017af:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01017b4:	68 6d 03 00 00       	push   $0x36d
f01017b9:	68 96 6d 10 f0       	push   $0xf0106d96
f01017be:	e8 7d e8 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01017c3:	68 9a 6e 10 f0       	push   $0xf0106e9a
f01017c8:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01017cd:	68 6e 03 00 00       	push   $0x36e
f01017d2:	68 96 6d 10 f0       	push   $0xf0106d96
f01017d7:	e8 64 e8 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01017dc:	68 b0 6e 10 f0       	push   $0xf0106eb0
f01017e1:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01017e6:	68 6f 03 00 00       	push   $0x36f
f01017eb:	68 96 6d 10 f0       	push   $0xf0106d96
f01017f0:	e8 4b e8 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01017f5:	68 c6 6e 10 f0       	push   $0xf0106ec6
f01017fa:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01017ff:	68 72 03 00 00       	push   $0x372
f0101804:	68 96 6d 10 f0       	push   $0xf0106d96
f0101809:	e8 32 e8 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010180e:	68 cc 72 10 f0       	push   $0xf01072cc
f0101813:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0101818:	68 73 03 00 00       	push   $0x373
f010181d:	68 96 6d 10 f0       	push   $0xf0106d96
f0101822:	e8 19 e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101827:	68 d8 6e 10 f0       	push   $0xf0106ed8
f010182c:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0101831:	68 74 03 00 00       	push   $0x374
f0101836:	68 96 6d 10 f0       	push   $0xf0106d96
f010183b:	e8 00 e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101840:	68 f5 6e 10 f0       	push   $0xf0106ef5
f0101845:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010184a:	68 75 03 00 00       	push   $0x375
f010184f:	68 96 6d 10 f0       	push   $0xf0106d96
f0101854:	e8 e7 e7 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101859:	68 12 6f 10 f0       	push   $0xf0106f12
f010185e:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0101863:	68 76 03 00 00       	push   $0x376
f0101868:	68 96 6d 10 f0       	push   $0xf0106d96
f010186d:	e8 ce e7 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101872:	68 2f 6f 10 f0       	push   $0xf0106f2f
f0101877:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010187c:	68 7d 03 00 00       	push   $0x37d
f0101881:	68 96 6d 10 f0       	push   $0xf0106d96
f0101886:	e8 b5 e7 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f010188b:	68 84 6e 10 f0       	push   $0xf0106e84
f0101890:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0101895:	68 84 03 00 00       	push   $0x384
f010189a:	68 96 6d 10 f0       	push   $0xf0106d96
f010189f:	e8 9c e7 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01018a4:	68 9a 6e 10 f0       	push   $0xf0106e9a
f01018a9:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01018ae:	68 85 03 00 00       	push   $0x385
f01018b3:	68 96 6d 10 f0       	push   $0xf0106d96
f01018b8:	e8 83 e7 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01018bd:	68 b0 6e 10 f0       	push   $0xf0106eb0
f01018c2:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01018c7:	68 86 03 00 00       	push   $0x386
f01018cc:	68 96 6d 10 f0       	push   $0xf0106d96
f01018d1:	e8 6a e7 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01018d6:	68 c6 6e 10 f0       	push   $0xf0106ec6
f01018db:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01018e0:	68 88 03 00 00       	push   $0x388
f01018e5:	68 96 6d 10 f0       	push   $0xf0106d96
f01018ea:	e8 51 e7 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018ef:	68 cc 72 10 f0       	push   $0xf01072cc
f01018f4:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01018f9:	68 89 03 00 00       	push   $0x389
f01018fe:	68 96 6d 10 f0       	push   $0xf0106d96
f0101903:	e8 38 e7 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101908:	68 2f 6f 10 f0       	push   $0xf0106f2f
f010190d:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0101912:	68 8a 03 00 00       	push   $0x38a
f0101917:	68 96 6d 10 f0       	push   $0xf0106d96
f010191c:	e8 1f e7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101921:	52                   	push   %edx
f0101922:	68 04 68 10 f0       	push   $0xf0106804
f0101927:	6a 58                	push   $0x58
f0101929:	68 a2 6d 10 f0       	push   $0xf0106da2
f010192e:	e8 0d e7 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101933:	68 3e 6f 10 f0       	push   $0xf0106f3e
f0101938:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010193d:	68 8f 03 00 00       	push   $0x38f
f0101942:	68 96 6d 10 f0       	push   $0xf0106d96
f0101947:	e8 f4 e6 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f010194c:	68 5c 6f 10 f0       	push   $0xf0106f5c
f0101951:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0101956:	68 90 03 00 00       	push   $0x390
f010195b:	68 96 6d 10 f0       	push   $0xf0106d96
f0101960:	e8 db e6 ff ff       	call   f0100040 <_panic>
f0101965:	52                   	push   %edx
f0101966:	68 04 68 10 f0       	push   $0xf0106804
f010196b:	6a 58                	push   $0x58
f010196d:	68 a2 6d 10 f0       	push   $0xf0106da2
f0101972:	e8 c9 e6 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f0101977:	68 6c 6f 10 f0       	push   $0xf0106f6c
f010197c:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0101981:	68 93 03 00 00       	push   $0x393
f0101986:	68 96 6d 10 f0       	push   $0xf0106d96
f010198b:	e8 b0 e6 ff ff       	call   f0100040 <_panic>
	assert(nfree == 0);
f0101990:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101994:	0f 85 43 09 00 00    	jne    f01022dd <mem_init+0xeb9>
	cprintf("check_page_alloc() succeeded!\n");
f010199a:	83 ec 0c             	sub    $0xc,%esp
f010199d:	68 ec 72 10 f0       	push   $0xf01072ec
f01019a2:	e8 60 20 00 00       	call   f0103a07 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01019a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01019ae:	e8 3b f6 ff ff       	call   f0100fee <page_alloc>
f01019b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01019b6:	83 c4 10             	add    $0x10,%esp
f01019b9:	85 c0                	test   %eax,%eax
f01019bb:	0f 84 35 09 00 00    	je     f01022f6 <mem_init+0xed2>
	assert((pp1 = page_alloc(0)));
f01019c1:	83 ec 0c             	sub    $0xc,%esp
f01019c4:	6a 00                	push   $0x0
f01019c6:	e8 23 f6 ff ff       	call   f0100fee <page_alloc>
f01019cb:	89 c7                	mov    %eax,%edi
f01019cd:	83 c4 10             	add    $0x10,%esp
f01019d0:	85 c0                	test   %eax,%eax
f01019d2:	0f 84 37 09 00 00    	je     f010230f <mem_init+0xeeb>
	assert((pp2 = page_alloc(0)));
f01019d8:	83 ec 0c             	sub    $0xc,%esp
f01019db:	6a 00                	push   $0x0
f01019dd:	e8 0c f6 ff ff       	call   f0100fee <page_alloc>
f01019e2:	89 c3                	mov    %eax,%ebx
f01019e4:	83 c4 10             	add    $0x10,%esp
f01019e7:	85 c0                	test   %eax,%eax
f01019e9:	0f 84 39 09 00 00    	je     f0102328 <mem_init+0xf04>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f01019ef:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f01019f2:	0f 84 49 09 00 00    	je     f0102341 <mem_init+0xf1d>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019f8:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f01019fb:	0f 84 59 09 00 00    	je     f010235a <mem_init+0xf36>
f0101a01:	39 c7                	cmp    %eax,%edi
f0101a03:	0f 84 51 09 00 00    	je     f010235a <mem_init+0xf36>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101a09:	a1 40 72 21 f0       	mov    0xf0217240,%eax
f0101a0e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101a11:	c7 05 40 72 21 f0 00 	movl   $0x0,0xf0217240
f0101a18:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101a1b:	83 ec 0c             	sub    $0xc,%esp
f0101a1e:	6a 00                	push   $0x0
f0101a20:	e8 c9 f5 ff ff       	call   f0100fee <page_alloc>
f0101a25:	83 c4 10             	add    $0x10,%esp
f0101a28:	85 c0                	test   %eax,%eax
f0101a2a:	0f 85 43 09 00 00    	jne    f0102373 <mem_init+0xf4f>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101a30:	83 ec 04             	sub    $0x4,%esp
f0101a33:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101a36:	50                   	push   %eax
f0101a37:	6a 00                	push   $0x0
f0101a39:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101a3f:	e8 f0 f7 ff ff       	call   f0101234 <page_lookup>
f0101a44:	83 c4 10             	add    $0x10,%esp
f0101a47:	85 c0                	test   %eax,%eax
f0101a49:	0f 85 3d 09 00 00    	jne    f010238c <mem_init+0xf68>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101a4f:	6a 02                	push   $0x2
f0101a51:	6a 00                	push   $0x0
f0101a53:	57                   	push   %edi
f0101a54:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101a5a:	e8 cb f8 ff ff       	call   f010132a <page_insert>
f0101a5f:	83 c4 10             	add    $0x10,%esp
f0101a62:	85 c0                	test   %eax,%eax
f0101a64:	0f 89 3b 09 00 00    	jns    f01023a5 <mem_init+0xf81>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101a6a:	83 ec 0c             	sub    $0xc,%esp
f0101a6d:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101a70:	e8 04 f6 ff ff       	call   f0101079 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101a75:	6a 02                	push   $0x2
f0101a77:	6a 00                	push   $0x0
f0101a79:	57                   	push   %edi
f0101a7a:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101a80:	e8 a5 f8 ff ff       	call   f010132a <page_insert>
f0101a85:	83 c4 20             	add    $0x20,%esp
f0101a88:	85 c0                	test   %eax,%eax
f0101a8a:	0f 85 2e 09 00 00    	jne    f01023be <mem_init+0xf9a>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101a90:	8b 35 8c 7e 21 f0    	mov    0xf0217e8c,%esi
	return (pp - pages) << PGSHIFT;
f0101a96:	8b 0d 90 7e 21 f0    	mov    0xf0217e90,%ecx
f0101a9c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101a9f:	8b 16                	mov    (%esi),%edx
f0101aa1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101aa7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101aaa:	29 c8                	sub    %ecx,%eax
f0101aac:	c1 f8 03             	sar    $0x3,%eax
f0101aaf:	c1 e0 0c             	shl    $0xc,%eax
f0101ab2:	39 c2                	cmp    %eax,%edx
f0101ab4:	0f 85 1d 09 00 00    	jne    f01023d7 <mem_init+0xfb3>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101aba:	ba 00 00 00 00       	mov    $0x0,%edx
f0101abf:	89 f0                	mov    %esi,%eax
f0101ac1:	e8 89 f0 ff ff       	call   f0100b4f <check_va2pa>
f0101ac6:	89 c2                	mov    %eax,%edx
f0101ac8:	89 f8                	mov    %edi,%eax
f0101aca:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0101acd:	c1 f8 03             	sar    $0x3,%eax
f0101ad0:	c1 e0 0c             	shl    $0xc,%eax
f0101ad3:	39 c2                	cmp    %eax,%edx
f0101ad5:	0f 85 15 09 00 00    	jne    f01023f0 <mem_init+0xfcc>
	assert(pp1->pp_ref == 1);
f0101adb:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101ae0:	0f 85 23 09 00 00    	jne    f0102409 <mem_init+0xfe5>
	assert(pp0->pp_ref == 1);
f0101ae6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ae9:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101aee:	0f 85 2e 09 00 00    	jne    f0102422 <mem_init+0xffe>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101af4:	6a 02                	push   $0x2
f0101af6:	68 00 10 00 00       	push   $0x1000
f0101afb:	53                   	push   %ebx
f0101afc:	56                   	push   %esi
f0101afd:	e8 28 f8 ff ff       	call   f010132a <page_insert>
f0101b02:	83 c4 10             	add    $0x10,%esp
f0101b05:	85 c0                	test   %eax,%eax
f0101b07:	0f 85 2e 09 00 00    	jne    f010243b <mem_init+0x1017>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b0d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b12:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0101b17:	e8 33 f0 ff ff       	call   f0100b4f <check_va2pa>
f0101b1c:	89 c2                	mov    %eax,%edx
f0101b1e:	89 d8                	mov    %ebx,%eax
f0101b20:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101b26:	c1 f8 03             	sar    $0x3,%eax
f0101b29:	c1 e0 0c             	shl    $0xc,%eax
f0101b2c:	39 c2                	cmp    %eax,%edx
f0101b2e:	0f 85 20 09 00 00    	jne    f0102454 <mem_init+0x1030>
	assert(pp2->pp_ref == 1);
f0101b34:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101b39:	0f 85 2e 09 00 00    	jne    f010246d <mem_init+0x1049>

	// should be no free memory
	assert(!page_alloc(0));
f0101b3f:	83 ec 0c             	sub    $0xc,%esp
f0101b42:	6a 00                	push   $0x0
f0101b44:	e8 a5 f4 ff ff       	call   f0100fee <page_alloc>
f0101b49:	83 c4 10             	add    $0x10,%esp
f0101b4c:	85 c0                	test   %eax,%eax
f0101b4e:	0f 85 32 09 00 00    	jne    f0102486 <mem_init+0x1062>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101b54:	6a 02                	push   $0x2
f0101b56:	68 00 10 00 00       	push   $0x1000
f0101b5b:	53                   	push   %ebx
f0101b5c:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101b62:	e8 c3 f7 ff ff       	call   f010132a <page_insert>
f0101b67:	83 c4 10             	add    $0x10,%esp
f0101b6a:	85 c0                	test   %eax,%eax
f0101b6c:	0f 85 2d 09 00 00    	jne    f010249f <mem_init+0x107b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b72:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b77:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0101b7c:	e8 ce ef ff ff       	call   f0100b4f <check_va2pa>
f0101b81:	89 c2                	mov    %eax,%edx
f0101b83:	89 d8                	mov    %ebx,%eax
f0101b85:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101b8b:	c1 f8 03             	sar    $0x3,%eax
f0101b8e:	c1 e0 0c             	shl    $0xc,%eax
f0101b91:	39 c2                	cmp    %eax,%edx
f0101b93:	0f 85 1f 09 00 00    	jne    f01024b8 <mem_init+0x1094>
	assert(pp2->pp_ref == 1);
f0101b99:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101b9e:	0f 85 2d 09 00 00    	jne    f01024d1 <mem_init+0x10ad>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101ba4:	83 ec 0c             	sub    $0xc,%esp
f0101ba7:	6a 00                	push   $0x0
f0101ba9:	e8 40 f4 ff ff       	call   f0100fee <page_alloc>
f0101bae:	83 c4 10             	add    $0x10,%esp
f0101bb1:	85 c0                	test   %eax,%eax
f0101bb3:	0f 85 31 09 00 00    	jne    f01024ea <mem_init+0x10c6>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101bb9:	8b 0d 8c 7e 21 f0    	mov    0xf0217e8c,%ecx
f0101bbf:	8b 01                	mov    (%ecx),%eax
f0101bc1:	89 c2                	mov    %eax,%edx
f0101bc3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101bc9:	c1 e8 0c             	shr    $0xc,%eax
f0101bcc:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0101bd2:	0f 83 2b 09 00 00    	jae    f0102503 <mem_init+0x10df>
	return (void *)(pa + KERNBASE);
f0101bd8:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101bde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101be1:	83 ec 04             	sub    $0x4,%esp
f0101be4:	6a 00                	push   $0x0
f0101be6:	68 00 10 00 00       	push   $0x1000
f0101beb:	51                   	push   %ecx
f0101bec:	e8 0b f5 ff ff       	call   f01010fc <pgdir_walk>
f0101bf1:	89 c2                	mov    %eax,%edx
f0101bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101bf6:	83 c0 04             	add    $0x4,%eax
f0101bf9:	83 c4 10             	add    $0x10,%esp
f0101bfc:	39 d0                	cmp    %edx,%eax
f0101bfe:	0f 85 14 09 00 00    	jne    f0102518 <mem_init+0x10f4>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101c04:	6a 06                	push   $0x6
f0101c06:	68 00 10 00 00       	push   $0x1000
f0101c0b:	53                   	push   %ebx
f0101c0c:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101c12:	e8 13 f7 ff ff       	call   f010132a <page_insert>
f0101c17:	83 c4 10             	add    $0x10,%esp
f0101c1a:	85 c0                	test   %eax,%eax
f0101c1c:	0f 85 0f 09 00 00    	jne    f0102531 <mem_init+0x110d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101c22:	8b 35 8c 7e 21 f0    	mov    0xf0217e8c,%esi
f0101c28:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c2d:	89 f0                	mov    %esi,%eax
f0101c2f:	e8 1b ef ff ff       	call   f0100b4f <check_va2pa>
f0101c34:	89 c2                	mov    %eax,%edx
	return (pp - pages) << PGSHIFT;
f0101c36:	89 d8                	mov    %ebx,%eax
f0101c38:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101c3e:	c1 f8 03             	sar    $0x3,%eax
f0101c41:	c1 e0 0c             	shl    $0xc,%eax
f0101c44:	39 c2                	cmp    %eax,%edx
f0101c46:	0f 85 fe 08 00 00    	jne    f010254a <mem_init+0x1126>
	assert(pp2->pp_ref == 1);
f0101c4c:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101c51:	0f 85 0c 09 00 00    	jne    f0102563 <mem_init+0x113f>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101c57:	83 ec 04             	sub    $0x4,%esp
f0101c5a:	6a 00                	push   $0x0
f0101c5c:	68 00 10 00 00       	push   $0x1000
f0101c61:	56                   	push   %esi
f0101c62:	e8 95 f4 ff ff       	call   f01010fc <pgdir_walk>
f0101c67:	83 c4 10             	add    $0x10,%esp
f0101c6a:	f6 00 04             	testb  $0x4,(%eax)
f0101c6d:	0f 84 09 09 00 00    	je     f010257c <mem_init+0x1158>
	assert(kern_pgdir[0] & PTE_U);
f0101c73:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0101c78:	f6 00 04             	testb  $0x4,(%eax)
f0101c7b:	0f 84 14 09 00 00    	je     f0102595 <mem_init+0x1171>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101c81:	6a 02                	push   $0x2
f0101c83:	68 00 10 00 00       	push   $0x1000
f0101c88:	53                   	push   %ebx
f0101c89:	50                   	push   %eax
f0101c8a:	e8 9b f6 ff ff       	call   f010132a <page_insert>
f0101c8f:	83 c4 10             	add    $0x10,%esp
f0101c92:	85 c0                	test   %eax,%eax
f0101c94:	0f 85 14 09 00 00    	jne    f01025ae <mem_init+0x118a>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101c9a:	83 ec 04             	sub    $0x4,%esp
f0101c9d:	6a 00                	push   $0x0
f0101c9f:	68 00 10 00 00       	push   $0x1000
f0101ca4:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101caa:	e8 4d f4 ff ff       	call   f01010fc <pgdir_walk>
f0101caf:	83 c4 10             	add    $0x10,%esp
f0101cb2:	f6 00 02             	testb  $0x2,(%eax)
f0101cb5:	0f 84 0c 09 00 00    	je     f01025c7 <mem_init+0x11a3>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101cbb:	83 ec 04             	sub    $0x4,%esp
f0101cbe:	6a 00                	push   $0x0
f0101cc0:	68 00 10 00 00       	push   $0x1000
f0101cc5:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101ccb:	e8 2c f4 ff ff       	call   f01010fc <pgdir_walk>
f0101cd0:	83 c4 10             	add    $0x10,%esp
f0101cd3:	f6 00 04             	testb  $0x4,(%eax)
f0101cd6:	0f 85 04 09 00 00    	jne    f01025e0 <mem_init+0x11bc>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101cdc:	6a 02                	push   $0x2
f0101cde:	68 00 00 40 00       	push   $0x400000
f0101ce3:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101ce6:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101cec:	e8 39 f6 ff ff       	call   f010132a <page_insert>
f0101cf1:	83 c4 10             	add    $0x10,%esp
f0101cf4:	85 c0                	test   %eax,%eax
f0101cf6:	0f 89 fd 08 00 00    	jns    f01025f9 <mem_init+0x11d5>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101cfc:	6a 02                	push   $0x2
f0101cfe:	68 00 10 00 00       	push   $0x1000
f0101d03:	57                   	push   %edi
f0101d04:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101d0a:	e8 1b f6 ff ff       	call   f010132a <page_insert>
f0101d0f:	83 c4 10             	add    $0x10,%esp
f0101d12:	85 c0                	test   %eax,%eax
f0101d14:	0f 85 f8 08 00 00    	jne    f0102612 <mem_init+0x11ee>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101d1a:	83 ec 04             	sub    $0x4,%esp
f0101d1d:	6a 00                	push   $0x0
f0101d1f:	68 00 10 00 00       	push   $0x1000
f0101d24:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101d2a:	e8 cd f3 ff ff       	call   f01010fc <pgdir_walk>
f0101d2f:	83 c4 10             	add    $0x10,%esp
f0101d32:	f6 00 04             	testb  $0x4,(%eax)
f0101d35:	0f 85 f0 08 00 00    	jne    f010262b <mem_init+0x1207>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101d3b:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0101d40:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101d43:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d48:	e8 02 ee ff ff       	call   f0100b4f <check_va2pa>
f0101d4d:	89 fe                	mov    %edi,%esi
f0101d4f:	2b 35 90 7e 21 f0    	sub    0xf0217e90,%esi
f0101d55:	c1 fe 03             	sar    $0x3,%esi
f0101d58:	c1 e6 0c             	shl    $0xc,%esi
f0101d5b:	39 f0                	cmp    %esi,%eax
f0101d5d:	0f 85 e1 08 00 00    	jne    f0102644 <mem_init+0x1220>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101d63:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d68:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101d6b:	e8 df ed ff ff       	call   f0100b4f <check_va2pa>
f0101d70:	39 c6                	cmp    %eax,%esi
f0101d72:	0f 85 e5 08 00 00    	jne    f010265d <mem_init+0x1239>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101d78:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f0101d7d:	0f 85 f3 08 00 00    	jne    f0102676 <mem_init+0x1252>
	assert(pp2->pp_ref == 0);
f0101d83:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101d88:	0f 85 01 09 00 00    	jne    f010268f <mem_init+0x126b>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101d8e:	83 ec 0c             	sub    $0xc,%esp
f0101d91:	6a 00                	push   $0x0
f0101d93:	e8 56 f2 ff ff       	call   f0100fee <page_alloc>
f0101d98:	83 c4 10             	add    $0x10,%esp
f0101d9b:	85 c0                	test   %eax,%eax
f0101d9d:	0f 84 05 09 00 00    	je     f01026a8 <mem_init+0x1284>
f0101da3:	39 c3                	cmp    %eax,%ebx
f0101da5:	0f 85 fd 08 00 00    	jne    f01026a8 <mem_init+0x1284>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101dab:	83 ec 08             	sub    $0x8,%esp
f0101dae:	6a 00                	push   $0x0
f0101db0:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101db6:	e8 25 f5 ff ff       	call   f01012e0 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101dbb:	8b 35 8c 7e 21 f0    	mov    0xf0217e8c,%esi
f0101dc1:	ba 00 00 00 00       	mov    $0x0,%edx
f0101dc6:	89 f0                	mov    %esi,%eax
f0101dc8:	e8 82 ed ff ff       	call   f0100b4f <check_va2pa>
f0101dcd:	83 c4 10             	add    $0x10,%esp
f0101dd0:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101dd3:	0f 85 e8 08 00 00    	jne    f01026c1 <mem_init+0x129d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101dd9:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101dde:	89 f0                	mov    %esi,%eax
f0101de0:	e8 6a ed ff ff       	call   f0100b4f <check_va2pa>
f0101de5:	89 c2                	mov    %eax,%edx
f0101de7:	89 f8                	mov    %edi,%eax
f0101de9:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101def:	c1 f8 03             	sar    $0x3,%eax
f0101df2:	c1 e0 0c             	shl    $0xc,%eax
f0101df5:	39 c2                	cmp    %eax,%edx
f0101df7:	0f 85 dd 08 00 00    	jne    f01026da <mem_init+0x12b6>
	assert(pp1->pp_ref == 1);
f0101dfd:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101e02:	0f 85 eb 08 00 00    	jne    f01026f3 <mem_init+0x12cf>
	assert(pp2->pp_ref == 0);
f0101e08:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101e0d:	0f 85 f9 08 00 00    	jne    f010270c <mem_init+0x12e8>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101e13:	6a 00                	push   $0x0
f0101e15:	68 00 10 00 00       	push   $0x1000
f0101e1a:	57                   	push   %edi
f0101e1b:	56                   	push   %esi
f0101e1c:	e8 09 f5 ff ff       	call   f010132a <page_insert>
f0101e21:	83 c4 10             	add    $0x10,%esp
f0101e24:	85 c0                	test   %eax,%eax
f0101e26:	0f 85 f9 08 00 00    	jne    f0102725 <mem_init+0x1301>
	assert(pp1->pp_ref);
f0101e2c:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101e31:	0f 84 07 09 00 00    	je     f010273e <mem_init+0x131a>
	assert(pp1->pp_link == NULL);
f0101e37:	83 3f 00             	cmpl   $0x0,(%edi)
f0101e3a:	0f 85 17 09 00 00    	jne    f0102757 <mem_init+0x1333>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101e40:	83 ec 08             	sub    $0x8,%esp
f0101e43:	68 00 10 00 00       	push   $0x1000
f0101e48:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101e4e:	e8 8d f4 ff ff       	call   f01012e0 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101e53:	8b 35 8c 7e 21 f0    	mov    0xf0217e8c,%esi
f0101e59:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e5e:	89 f0                	mov    %esi,%eax
f0101e60:	e8 ea ec ff ff       	call   f0100b4f <check_va2pa>
f0101e65:	83 c4 10             	add    $0x10,%esp
f0101e68:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e6b:	0f 85 ff 08 00 00    	jne    f0102770 <mem_init+0x134c>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101e71:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e76:	89 f0                	mov    %esi,%eax
f0101e78:	e8 d2 ec ff ff       	call   f0100b4f <check_va2pa>
f0101e7d:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e80:	0f 85 03 09 00 00    	jne    f0102789 <mem_init+0x1365>
	assert(pp1->pp_ref == 0);
f0101e86:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101e8b:	0f 85 11 09 00 00    	jne    f01027a2 <mem_init+0x137e>
	assert(pp2->pp_ref == 0);
f0101e91:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101e96:	0f 85 1f 09 00 00    	jne    f01027bb <mem_init+0x1397>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101e9c:	83 ec 0c             	sub    $0xc,%esp
f0101e9f:	6a 00                	push   $0x0
f0101ea1:	e8 48 f1 ff ff       	call   f0100fee <page_alloc>
f0101ea6:	83 c4 10             	add    $0x10,%esp
f0101ea9:	39 c7                	cmp    %eax,%edi
f0101eab:	0f 85 23 09 00 00    	jne    f01027d4 <mem_init+0x13b0>
f0101eb1:	85 c0                	test   %eax,%eax
f0101eb3:	0f 84 1b 09 00 00    	je     f01027d4 <mem_init+0x13b0>

	// should be no free memory
	assert(!page_alloc(0));
f0101eb9:	83 ec 0c             	sub    $0xc,%esp
f0101ebc:	6a 00                	push   $0x0
f0101ebe:	e8 2b f1 ff ff       	call   f0100fee <page_alloc>
f0101ec3:	83 c4 10             	add    $0x10,%esp
f0101ec6:	85 c0                	test   %eax,%eax
f0101ec8:	0f 85 1f 09 00 00    	jne    f01027ed <mem_init+0x13c9>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101ece:	8b 0d 8c 7e 21 f0    	mov    0xf0217e8c,%ecx
f0101ed4:	8b 11                	mov    (%ecx),%edx
f0101ed6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101edc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101edf:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101ee5:	c1 f8 03             	sar    $0x3,%eax
f0101ee8:	c1 e0 0c             	shl    $0xc,%eax
f0101eeb:	39 c2                	cmp    %eax,%edx
f0101eed:	0f 85 13 09 00 00    	jne    f0102806 <mem_init+0x13e2>
	kern_pgdir[0] = 0;
f0101ef3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101ef9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101efc:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101f01:	0f 85 18 09 00 00    	jne    f010281f <mem_init+0x13fb>
	pp0->pp_ref = 0;
f0101f07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f0a:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101f10:	83 ec 0c             	sub    $0xc,%esp
f0101f13:	50                   	push   %eax
f0101f14:	e8 60 f1 ff ff       	call   f0101079 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101f19:	83 c4 0c             	add    $0xc,%esp
f0101f1c:	6a 01                	push   $0x1
f0101f1e:	68 00 10 40 00       	push   $0x401000
f0101f23:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101f29:	e8 ce f1 ff ff       	call   f01010fc <pgdir_walk>
f0101f2e:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101f31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101f34:	8b 0d 8c 7e 21 f0    	mov    0xf0217e8c,%ecx
f0101f3a:	8b 41 04             	mov    0x4(%ecx),%eax
f0101f3d:	89 c6                	mov    %eax,%esi
f0101f3f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0101f45:	8b 15 88 7e 21 f0    	mov    0xf0217e88,%edx
f0101f4b:	c1 e8 0c             	shr    $0xc,%eax
f0101f4e:	83 c4 10             	add    $0x10,%esp
f0101f51:	39 d0                	cmp    %edx,%eax
f0101f53:	0f 83 df 08 00 00    	jae    f0102838 <mem_init+0x1414>
	assert(ptep == ptep1 + PTX(va));
f0101f59:	81 ee fc ff ff 0f    	sub    $0xffffffc,%esi
f0101f5f:	39 75 d0             	cmp    %esi,-0x30(%ebp)
f0101f62:	0f 85 e5 08 00 00    	jne    f010284d <mem_init+0x1429>
	kern_pgdir[PDX(va)] = 0;
f0101f68:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
	pp0->pp_ref = 0;
f0101f6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f72:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101f78:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101f7e:	c1 f8 03             	sar    $0x3,%eax
f0101f81:	89 c1                	mov    %eax,%ecx
f0101f83:	c1 e1 0c             	shl    $0xc,%ecx
	if (PGNUM(pa) >= npages)
f0101f86:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101f8b:	39 c2                	cmp    %eax,%edx
f0101f8d:	0f 86 d3 08 00 00    	jbe    f0102866 <mem_init+0x1442>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101f93:	83 ec 04             	sub    $0x4,%esp
f0101f96:	68 00 10 00 00       	push   $0x1000
f0101f9b:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101fa0:	81 e9 00 00 00 10    	sub    $0x10000000,%ecx
f0101fa6:	51                   	push   %ecx
f0101fa7:	e8 96 3b 00 00       	call   f0105b42 <memset>
	page_free(pp0);
f0101fac:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0101faf:	89 34 24             	mov    %esi,(%esp)
f0101fb2:	e8 c2 f0 ff ff       	call   f0101079 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101fb7:	83 c4 0c             	add    $0xc,%esp
f0101fba:	6a 01                	push   $0x1
f0101fbc:	6a 00                	push   $0x0
f0101fbe:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101fc4:	e8 33 f1 ff ff       	call   f01010fc <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0101fc9:	89 f0                	mov    %esi,%eax
f0101fcb:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101fd1:	c1 f8 03             	sar    $0x3,%eax
f0101fd4:	89 c2                	mov    %eax,%edx
f0101fd6:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101fd9:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101fde:	83 c4 10             	add    $0x10,%esp
f0101fe1:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0101fe7:	0f 83 8b 08 00 00    	jae    f0102878 <mem_init+0x1454>
	return (void *)(pa + KERNBASE);
f0101fed:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0101ff3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101ff6:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0101ffc:	f6 00 01             	testb  $0x1,(%eax)
f0101fff:	0f 85 85 08 00 00    	jne    f010288a <mem_init+0x1466>
f0102005:	83 c0 04             	add    $0x4,%eax
	for(i=0; i<NPTENTRIES; i++)
f0102008:	39 d0                	cmp    %edx,%eax
f010200a:	75 f0                	jne    f0101ffc <mem_init+0xbd8>
	kern_pgdir[0] = 0;
f010200c:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0102011:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102017:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010201a:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102020:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102023:	89 0d 40 72 21 f0    	mov    %ecx,0xf0217240

	// free the pages we took
	page_free(pp0);
f0102029:	83 ec 0c             	sub    $0xc,%esp
f010202c:	50                   	push   %eax
f010202d:	e8 47 f0 ff ff       	call   f0101079 <page_free>
	page_free(pp1);
f0102032:	89 3c 24             	mov    %edi,(%esp)
f0102035:	e8 3f f0 ff ff       	call   f0101079 <page_free>
	page_free(pp2);
f010203a:	89 1c 24             	mov    %ebx,(%esp)
f010203d:	e8 37 f0 ff ff       	call   f0101079 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102042:	83 c4 08             	add    $0x8,%esp
f0102045:	68 01 10 00 00       	push   $0x1001
f010204a:	6a 00                	push   $0x0
f010204c:	e8 6c f3 ff ff       	call   f01013bd <mmio_map_region>
f0102051:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102053:	83 c4 08             	add    $0x8,%esp
f0102056:	68 00 10 00 00       	push   $0x1000
f010205b:	6a 00                	push   $0x0
f010205d:	e8 5b f3 ff ff       	call   f01013bd <mmio_map_region>
f0102062:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102064:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f010206a:	83 c4 10             	add    $0x10,%esp
f010206d:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102073:	0f 86 2a 08 00 00    	jbe    f01028a3 <mem_init+0x147f>
f0102079:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f010207e:	0f 87 1f 08 00 00    	ja     f01028a3 <mem_init+0x147f>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102084:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f010208a:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102090:	0f 87 26 08 00 00    	ja     f01028bc <mem_init+0x1498>
f0102096:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f010209c:	0f 86 1a 08 00 00    	jbe    f01028bc <mem_init+0x1498>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01020a2:	89 da                	mov    %ebx,%edx
f01020a4:	09 f2                	or     %esi,%edx
f01020a6:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f01020ac:	0f 85 23 08 00 00    	jne    f01028d5 <mem_init+0x14b1>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f01020b2:	39 c6                	cmp    %eax,%esi
f01020b4:	0f 82 34 08 00 00    	jb     f01028ee <mem_init+0x14ca>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01020ba:	8b 3d 8c 7e 21 f0    	mov    0xf0217e8c,%edi
f01020c0:	89 da                	mov    %ebx,%edx
f01020c2:	89 f8                	mov    %edi,%eax
f01020c4:	e8 86 ea ff ff       	call   f0100b4f <check_va2pa>
f01020c9:	85 c0                	test   %eax,%eax
f01020cb:	0f 85 36 08 00 00    	jne    f0102907 <mem_init+0x14e3>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f01020d1:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f01020d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01020da:	89 c2                	mov    %eax,%edx
f01020dc:	89 f8                	mov    %edi,%eax
f01020de:	e8 6c ea ff ff       	call   f0100b4f <check_va2pa>
f01020e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
f01020e8:	0f 85 32 08 00 00    	jne    f0102920 <mem_init+0x14fc>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f01020ee:	89 f2                	mov    %esi,%edx
f01020f0:	89 f8                	mov    %edi,%eax
f01020f2:	e8 58 ea ff ff       	call   f0100b4f <check_va2pa>
f01020f7:	85 c0                	test   %eax,%eax
f01020f9:	0f 85 3a 08 00 00    	jne    f0102939 <mem_init+0x1515>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f01020ff:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102105:	89 f8                	mov    %edi,%eax
f0102107:	e8 43 ea ff ff       	call   f0100b4f <check_va2pa>
f010210c:	83 f8 ff             	cmp    $0xffffffff,%eax
f010210f:	0f 85 3d 08 00 00    	jne    f0102952 <mem_init+0x152e>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102115:	83 ec 04             	sub    $0x4,%esp
f0102118:	6a 00                	push   $0x0
f010211a:	53                   	push   %ebx
f010211b:	57                   	push   %edi
f010211c:	e8 db ef ff ff       	call   f01010fc <pgdir_walk>
f0102121:	83 c4 10             	add    $0x10,%esp
f0102124:	f6 00 1a             	testb  $0x1a,(%eax)
f0102127:	0f 84 3e 08 00 00    	je     f010296b <mem_init+0x1547>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f010212d:	83 ec 04             	sub    $0x4,%esp
f0102130:	6a 00                	push   $0x0
f0102132:	53                   	push   %ebx
f0102133:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0102139:	e8 be ef ff ff       	call   f01010fc <pgdir_walk>
f010213e:	8b 00                	mov    (%eax),%eax
f0102140:	83 c4 10             	add    $0x10,%esp
f0102143:	83 e0 04             	and    $0x4,%eax
f0102146:	89 c7                	mov    %eax,%edi
f0102148:	0f 85 36 08 00 00    	jne    f0102984 <mem_init+0x1560>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f010214e:	83 ec 04             	sub    $0x4,%esp
f0102151:	6a 00                	push   $0x0
f0102153:	53                   	push   %ebx
f0102154:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f010215a:	e8 9d ef ff ff       	call   f01010fc <pgdir_walk>
f010215f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102165:	83 c4 0c             	add    $0xc,%esp
f0102168:	6a 00                	push   $0x0
f010216a:	ff 75 d4             	pushl  -0x2c(%ebp)
f010216d:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0102173:	e8 84 ef ff ff       	call   f01010fc <pgdir_walk>
f0102178:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f010217e:	83 c4 0c             	add    $0xc,%esp
f0102181:	6a 00                	push   $0x0
f0102183:	56                   	push   %esi
f0102184:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f010218a:	e8 6d ef ff ff       	call   f01010fc <pgdir_walk>
f010218f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102195:	c7 04 24 5f 70 10 f0 	movl   $0xf010705f,(%esp)
f010219c:	e8 66 18 00 00       	call   f0103a07 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f01021a1:	a1 90 7e 21 f0       	mov    0xf0217e90,%eax
	if ((uint32_t)kva < KERNBASE)
f01021a6:	83 c4 10             	add    $0x10,%esp
f01021a9:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021ae:	0f 86 e9 07 00 00    	jbe    f010299d <mem_init+0x1579>
f01021b4:	83 ec 08             	sub    $0x8,%esp
f01021b7:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01021b9:	05 00 00 00 10       	add    $0x10000000,%eax
f01021be:	50                   	push   %eax
f01021bf:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01021c4:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01021c9:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f01021ce:	e8 0a f0 ff ff       	call   f01011dd <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f01021d3:	a1 48 72 21 f0       	mov    0xf0217248,%eax
	if ((uint32_t)kva < KERNBASE)
f01021d8:	83 c4 10             	add    $0x10,%esp
f01021db:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021e0:	0f 86 cc 07 00 00    	jbe    f01029b2 <mem_init+0x158e>
f01021e6:	83 ec 08             	sub    $0x8,%esp
f01021e9:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01021eb:	05 00 00 00 10       	add    $0x10000000,%eax
f01021f0:	50                   	push   %eax
f01021f1:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01021f6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01021fb:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0102200:	e8 d8 ef ff ff       	call   f01011dd <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102205:	83 c4 10             	add    $0x10,%esp
f0102208:	b8 00 90 11 f0       	mov    $0xf0119000,%eax
f010220d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102212:	0f 86 af 07 00 00    	jbe    f01029c7 <mem_init+0x15a3>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f0102218:	83 ec 08             	sub    $0x8,%esp
f010221b:	6a 02                	push   $0x2
f010221d:	68 00 90 11 00       	push   $0x119000
f0102222:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102227:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f010222c:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0102231:	e8 a7 ef ff ff       	call   f01011dd <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0xffffffff - KERNBASE, 0, PTE_W);
f0102236:	83 c4 08             	add    $0x8,%esp
f0102239:	6a 02                	push   $0x2
f010223b:	6a 00                	push   $0x0
f010223d:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f0102242:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102247:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f010224c:	e8 8c ef ff ff       	call   f01011dd <boot_map_region>
f0102251:	c7 45 d0 00 90 21 f0 	movl   $0xf0219000,-0x30(%ebp)
f0102258:	83 c4 10             	add    $0x10,%esp
f010225b:	bb 00 90 21 f0       	mov    $0xf0219000,%ebx
f0102260:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102265:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f010226b:	0f 86 6b 07 00 00    	jbe    f01029dc <mem_init+0x15b8>
		boot_map_region(kern_pgdir, 
f0102271:	83 ec 08             	sub    $0x8,%esp
f0102274:	6a 02                	push   $0x2
f0102276:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f010227c:	50                   	push   %eax
f010227d:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102282:	89 f2                	mov    %esi,%edx
f0102284:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0102289:	e8 4f ef ff ff       	call   f01011dd <boot_map_region>
f010228e:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f0102294:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f010229a:	83 c4 10             	add    $0x10,%esp
f010229d:	81 fb 00 90 25 f0    	cmp    $0xf0259000,%ebx
f01022a3:	75 c0                	jne    f0102265 <mem_init+0xe41>
	pgdir = kern_pgdir;
f01022a5:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f01022aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01022ad:	a1 88 7e 21 f0       	mov    0xf0217e88,%eax
f01022b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01022b5:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01022bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01022c1:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01022c4:	8b 35 90 7e 21 f0    	mov    0xf0217e90,%esi
f01022ca:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01022cd:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01022d3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f01022d6:	89 fb                	mov    %edi,%ebx
f01022d8:	e9 2f 07 00 00       	jmp    f0102a0c <mem_init+0x15e8>
	assert(nfree == 0);
f01022dd:	68 76 6f 10 f0       	push   $0xf0106f76
f01022e2:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01022e7:	68 a0 03 00 00       	push   $0x3a0
f01022ec:	68 96 6d 10 f0       	push   $0xf0106d96
f01022f1:	e8 4a dd ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f01022f6:	68 84 6e 10 f0       	push   $0xf0106e84
f01022fb:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102300:	68 06 04 00 00       	push   $0x406
f0102305:	68 96 6d 10 f0       	push   $0xf0106d96
f010230a:	e8 31 dd ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010230f:	68 9a 6e 10 f0       	push   $0xf0106e9a
f0102314:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102319:	68 07 04 00 00       	push   $0x407
f010231e:	68 96 6d 10 f0       	push   $0xf0106d96
f0102323:	e8 18 dd ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102328:	68 b0 6e 10 f0       	push   $0xf0106eb0
f010232d:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102332:	68 08 04 00 00       	push   $0x408
f0102337:	68 96 6d 10 f0       	push   $0xf0106d96
f010233c:	e8 ff dc ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0102341:	68 c6 6e 10 f0       	push   $0xf0106ec6
f0102346:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010234b:	68 0b 04 00 00       	push   $0x40b
f0102350:	68 96 6d 10 f0       	push   $0xf0106d96
f0102355:	e8 e6 dc ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010235a:	68 cc 72 10 f0       	push   $0xf01072cc
f010235f:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102364:	68 0c 04 00 00       	push   $0x40c
f0102369:	68 96 6d 10 f0       	push   $0xf0106d96
f010236e:	e8 cd dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102373:	68 2f 6f 10 f0       	push   $0xf0106f2f
f0102378:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010237d:	68 13 04 00 00       	push   $0x413
f0102382:	68 96 6d 10 f0       	push   $0xf0106d96
f0102387:	e8 b4 dc ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f010238c:	68 0c 73 10 f0       	push   $0xf010730c
f0102391:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102396:	68 16 04 00 00       	push   $0x416
f010239b:	68 96 6d 10 f0       	push   $0xf0106d96
f01023a0:	e8 9b dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01023a5:	68 44 73 10 f0       	push   $0xf0107344
f01023aa:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01023af:	68 19 04 00 00       	push   $0x419
f01023b4:	68 96 6d 10 f0       	push   $0xf0106d96
f01023b9:	e8 82 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01023be:	68 74 73 10 f0       	push   $0xf0107374
f01023c3:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01023c8:	68 1d 04 00 00       	push   $0x41d
f01023cd:	68 96 6d 10 f0       	push   $0xf0106d96
f01023d2:	e8 69 dc ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01023d7:	68 a4 73 10 f0       	push   $0xf01073a4
f01023dc:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01023e1:	68 1e 04 00 00       	push   $0x41e
f01023e6:	68 96 6d 10 f0       	push   $0xf0106d96
f01023eb:	e8 50 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01023f0:	68 cc 73 10 f0       	push   $0xf01073cc
f01023f5:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01023fa:	68 1f 04 00 00       	push   $0x41f
f01023ff:	68 96 6d 10 f0       	push   $0xf0106d96
f0102404:	e8 37 dc ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102409:	68 81 6f 10 f0       	push   $0xf0106f81
f010240e:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102413:	68 20 04 00 00       	push   $0x420
f0102418:	68 96 6d 10 f0       	push   $0xf0106d96
f010241d:	e8 1e dc ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102422:	68 92 6f 10 f0       	push   $0xf0106f92
f0102427:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010242c:	68 21 04 00 00       	push   $0x421
f0102431:	68 96 6d 10 f0       	push   $0xf0106d96
f0102436:	e8 05 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010243b:	68 fc 73 10 f0       	push   $0xf01073fc
f0102440:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102445:	68 24 04 00 00       	push   $0x424
f010244a:	68 96 6d 10 f0       	push   $0xf0106d96
f010244f:	e8 ec db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102454:	68 38 74 10 f0       	push   $0xf0107438
f0102459:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010245e:	68 25 04 00 00       	push   $0x425
f0102463:	68 96 6d 10 f0       	push   $0xf0106d96
f0102468:	e8 d3 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010246d:	68 a3 6f 10 f0       	push   $0xf0106fa3
f0102472:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102477:	68 26 04 00 00       	push   $0x426
f010247c:	68 96 6d 10 f0       	push   $0xf0106d96
f0102481:	e8 ba db ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102486:	68 2f 6f 10 f0       	push   $0xf0106f2f
f010248b:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102490:	68 29 04 00 00       	push   $0x429
f0102495:	68 96 6d 10 f0       	push   $0xf0106d96
f010249a:	e8 a1 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010249f:	68 fc 73 10 f0       	push   $0xf01073fc
f01024a4:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01024a9:	68 2c 04 00 00       	push   $0x42c
f01024ae:	68 96 6d 10 f0       	push   $0xf0106d96
f01024b3:	e8 88 db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01024b8:	68 38 74 10 f0       	push   $0xf0107438
f01024bd:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01024c2:	68 2d 04 00 00       	push   $0x42d
f01024c7:	68 96 6d 10 f0       	push   $0xf0106d96
f01024cc:	e8 6f db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01024d1:	68 a3 6f 10 f0       	push   $0xf0106fa3
f01024d6:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01024db:	68 2e 04 00 00       	push   $0x42e
f01024e0:	68 96 6d 10 f0       	push   $0xf0106d96
f01024e5:	e8 56 db ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01024ea:	68 2f 6f 10 f0       	push   $0xf0106f2f
f01024ef:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01024f4:	68 32 04 00 00       	push   $0x432
f01024f9:	68 96 6d 10 f0       	push   $0xf0106d96
f01024fe:	e8 3d db ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102503:	52                   	push   %edx
f0102504:	68 04 68 10 f0       	push   $0xf0106804
f0102509:	68 35 04 00 00       	push   $0x435
f010250e:	68 96 6d 10 f0       	push   $0xf0106d96
f0102513:	e8 28 db ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102518:	68 68 74 10 f0       	push   $0xf0107468
f010251d:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102522:	68 36 04 00 00       	push   $0x436
f0102527:	68 96 6d 10 f0       	push   $0xf0106d96
f010252c:	e8 0f db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102531:	68 a8 74 10 f0       	push   $0xf01074a8
f0102536:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010253b:	68 39 04 00 00       	push   $0x439
f0102540:	68 96 6d 10 f0       	push   $0xf0106d96
f0102545:	e8 f6 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010254a:	68 38 74 10 f0       	push   $0xf0107438
f010254f:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102554:	68 3a 04 00 00       	push   $0x43a
f0102559:	68 96 6d 10 f0       	push   $0xf0106d96
f010255e:	e8 dd da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102563:	68 a3 6f 10 f0       	push   $0xf0106fa3
f0102568:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010256d:	68 3b 04 00 00       	push   $0x43b
f0102572:	68 96 6d 10 f0       	push   $0xf0106d96
f0102577:	e8 c4 da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010257c:	68 e8 74 10 f0       	push   $0xf01074e8
f0102581:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102586:	68 3c 04 00 00       	push   $0x43c
f010258b:	68 96 6d 10 f0       	push   $0xf0106d96
f0102590:	e8 ab da ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102595:	68 b4 6f 10 f0       	push   $0xf0106fb4
f010259a:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010259f:	68 3d 04 00 00       	push   $0x43d
f01025a4:	68 96 6d 10 f0       	push   $0xf0106d96
f01025a9:	e8 92 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01025ae:	68 fc 73 10 f0       	push   $0xf01073fc
f01025b3:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01025b8:	68 40 04 00 00       	push   $0x440
f01025bd:	68 96 6d 10 f0       	push   $0xf0106d96
f01025c2:	e8 79 da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01025c7:	68 1c 75 10 f0       	push   $0xf010751c
f01025cc:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01025d1:	68 41 04 00 00       	push   $0x441
f01025d6:	68 96 6d 10 f0       	push   $0xf0106d96
f01025db:	e8 60 da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01025e0:	68 50 75 10 f0       	push   $0xf0107550
f01025e5:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01025ea:	68 42 04 00 00       	push   $0x442
f01025ef:	68 96 6d 10 f0       	push   $0xf0106d96
f01025f4:	e8 47 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f01025f9:	68 88 75 10 f0       	push   $0xf0107588
f01025fe:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102603:	68 45 04 00 00       	push   $0x445
f0102608:	68 96 6d 10 f0       	push   $0xf0106d96
f010260d:	e8 2e da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102612:	68 c0 75 10 f0       	push   $0xf01075c0
f0102617:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010261c:	68 48 04 00 00       	push   $0x448
f0102621:	68 96 6d 10 f0       	push   $0xf0106d96
f0102626:	e8 15 da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010262b:	68 50 75 10 f0       	push   $0xf0107550
f0102630:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102635:	68 49 04 00 00       	push   $0x449
f010263a:	68 96 6d 10 f0       	push   $0xf0106d96
f010263f:	e8 fc d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102644:	68 fc 75 10 f0       	push   $0xf01075fc
f0102649:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010264e:	68 4c 04 00 00       	push   $0x44c
f0102653:	68 96 6d 10 f0       	push   $0xf0106d96
f0102658:	e8 e3 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010265d:	68 28 76 10 f0       	push   $0xf0107628
f0102662:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102667:	68 4d 04 00 00       	push   $0x44d
f010266c:	68 96 6d 10 f0       	push   $0xf0106d96
f0102671:	e8 ca d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f0102676:	68 ca 6f 10 f0       	push   $0xf0106fca
f010267b:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102680:	68 4f 04 00 00       	push   $0x44f
f0102685:	68 96 6d 10 f0       	push   $0xf0106d96
f010268a:	e8 b1 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010268f:	68 db 6f 10 f0       	push   $0xf0106fdb
f0102694:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102699:	68 50 04 00 00       	push   $0x450
f010269e:	68 96 6d 10 f0       	push   $0xf0106d96
f01026a3:	e8 98 d9 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01026a8:	68 58 76 10 f0       	push   $0xf0107658
f01026ad:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01026b2:	68 53 04 00 00       	push   $0x453
f01026b7:	68 96 6d 10 f0       	push   $0xf0106d96
f01026bc:	e8 7f d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01026c1:	68 7c 76 10 f0       	push   $0xf010767c
f01026c6:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01026cb:	68 57 04 00 00       	push   $0x457
f01026d0:	68 96 6d 10 f0       	push   $0xf0106d96
f01026d5:	e8 66 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01026da:	68 28 76 10 f0       	push   $0xf0107628
f01026df:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01026e4:	68 58 04 00 00       	push   $0x458
f01026e9:	68 96 6d 10 f0       	push   $0xf0106d96
f01026ee:	e8 4d d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01026f3:	68 81 6f 10 f0       	push   $0xf0106f81
f01026f8:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01026fd:	68 59 04 00 00       	push   $0x459
f0102702:	68 96 6d 10 f0       	push   $0xf0106d96
f0102707:	e8 34 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010270c:	68 db 6f 10 f0       	push   $0xf0106fdb
f0102711:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102716:	68 5a 04 00 00       	push   $0x45a
f010271b:	68 96 6d 10 f0       	push   $0xf0106d96
f0102720:	e8 1b d9 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102725:	68 a0 76 10 f0       	push   $0xf01076a0
f010272a:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010272f:	68 5d 04 00 00       	push   $0x45d
f0102734:	68 96 6d 10 f0       	push   $0xf0106d96
f0102739:	e8 02 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f010273e:	68 ec 6f 10 f0       	push   $0xf0106fec
f0102743:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102748:	68 5e 04 00 00       	push   $0x45e
f010274d:	68 96 6d 10 f0       	push   $0xf0106d96
f0102752:	e8 e9 d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f0102757:	68 f8 6f 10 f0       	push   $0xf0106ff8
f010275c:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102761:	68 5f 04 00 00       	push   $0x45f
f0102766:	68 96 6d 10 f0       	push   $0xf0106d96
f010276b:	e8 d0 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102770:	68 7c 76 10 f0       	push   $0xf010767c
f0102775:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010277a:	68 63 04 00 00       	push   $0x463
f010277f:	68 96 6d 10 f0       	push   $0xf0106d96
f0102784:	e8 b7 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102789:	68 d8 76 10 f0       	push   $0xf01076d8
f010278e:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102793:	68 64 04 00 00       	push   $0x464
f0102798:	68 96 6d 10 f0       	push   $0xf0106d96
f010279d:	e8 9e d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f01027a2:	68 0d 70 10 f0       	push   $0xf010700d
f01027a7:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01027ac:	68 65 04 00 00       	push   $0x465
f01027b1:	68 96 6d 10 f0       	push   $0xf0106d96
f01027b6:	e8 85 d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01027bb:	68 db 6f 10 f0       	push   $0xf0106fdb
f01027c0:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01027c5:	68 66 04 00 00       	push   $0x466
f01027ca:	68 96 6d 10 f0       	push   $0xf0106d96
f01027cf:	e8 6c d8 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f01027d4:	68 00 77 10 f0       	push   $0xf0107700
f01027d9:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01027de:	68 69 04 00 00       	push   $0x469
f01027e3:	68 96 6d 10 f0       	push   $0xf0106d96
f01027e8:	e8 53 d8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01027ed:	68 2f 6f 10 f0       	push   $0xf0106f2f
f01027f2:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01027f7:	68 6c 04 00 00       	push   $0x46c
f01027fc:	68 96 6d 10 f0       	push   $0xf0106d96
f0102801:	e8 3a d8 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102806:	68 a4 73 10 f0       	push   $0xf01073a4
f010280b:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102810:	68 6f 04 00 00       	push   $0x46f
f0102815:	68 96 6d 10 f0       	push   $0xf0106d96
f010281a:	e8 21 d8 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f010281f:	68 92 6f 10 f0       	push   $0xf0106f92
f0102824:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102829:	68 71 04 00 00       	push   $0x471
f010282e:	68 96 6d 10 f0       	push   $0xf0106d96
f0102833:	e8 08 d8 ff ff       	call   f0100040 <_panic>
f0102838:	56                   	push   %esi
f0102839:	68 04 68 10 f0       	push   $0xf0106804
f010283e:	68 78 04 00 00       	push   $0x478
f0102843:	68 96 6d 10 f0       	push   $0xf0106d96
f0102848:	e8 f3 d7 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f010284d:	68 1e 70 10 f0       	push   $0xf010701e
f0102852:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102857:	68 79 04 00 00       	push   $0x479
f010285c:	68 96 6d 10 f0       	push   $0xf0106d96
f0102861:	e8 da d7 ff ff       	call   f0100040 <_panic>
f0102866:	51                   	push   %ecx
f0102867:	68 04 68 10 f0       	push   $0xf0106804
f010286c:	6a 58                	push   $0x58
f010286e:	68 a2 6d 10 f0       	push   $0xf0106da2
f0102873:	e8 c8 d7 ff ff       	call   f0100040 <_panic>
f0102878:	52                   	push   %edx
f0102879:	68 04 68 10 f0       	push   $0xf0106804
f010287e:	6a 58                	push   $0x58
f0102880:	68 a2 6d 10 f0       	push   $0xf0106da2
f0102885:	e8 b6 d7 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f010288a:	68 36 70 10 f0       	push   $0xf0107036
f010288f:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102894:	68 83 04 00 00       	push   $0x483
f0102899:	68 96 6d 10 f0       	push   $0xf0106d96
f010289e:	e8 9d d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f01028a3:	68 24 77 10 f0       	push   $0xf0107724
f01028a8:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01028ad:	68 93 04 00 00       	push   $0x493
f01028b2:	68 96 6d 10 f0       	push   $0xf0106d96
f01028b7:	e8 84 d7 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f01028bc:	68 4c 77 10 f0       	push   $0xf010774c
f01028c1:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01028c6:	68 94 04 00 00       	push   $0x494
f01028cb:	68 96 6d 10 f0       	push   $0xf0106d96
f01028d0:	e8 6b d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01028d5:	68 74 77 10 f0       	push   $0xf0107774
f01028da:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01028df:	68 96 04 00 00       	push   $0x496
f01028e4:	68 96 6d 10 f0       	push   $0xf0106d96
f01028e9:	e8 52 d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f01028ee:	68 4d 70 10 f0       	push   $0xf010704d
f01028f3:	68 bc 6d 10 f0       	push   $0xf0106dbc
f01028f8:	68 98 04 00 00       	push   $0x498
f01028fd:	68 96 6d 10 f0       	push   $0xf0106d96
f0102902:	e8 39 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102907:	68 9c 77 10 f0       	push   $0xf010779c
f010290c:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102911:	68 9a 04 00 00       	push   $0x49a
f0102916:	68 96 6d 10 f0       	push   $0xf0106d96
f010291b:	e8 20 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102920:	68 c0 77 10 f0       	push   $0xf01077c0
f0102925:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010292a:	68 9b 04 00 00       	push   $0x49b
f010292f:	68 96 6d 10 f0       	push   $0xf0106d96
f0102934:	e8 07 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102939:	68 f0 77 10 f0       	push   $0xf01077f0
f010293e:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102943:	68 9c 04 00 00       	push   $0x49c
f0102948:	68 96 6d 10 f0       	push   $0xf0106d96
f010294d:	e8 ee d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102952:	68 14 78 10 f0       	push   $0xf0107814
f0102957:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010295c:	68 9d 04 00 00       	push   $0x49d
f0102961:	68 96 6d 10 f0       	push   $0xf0106d96
f0102966:	e8 d5 d6 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f010296b:	68 40 78 10 f0       	push   $0xf0107840
f0102970:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102975:	68 9f 04 00 00       	push   $0x49f
f010297a:	68 96 6d 10 f0       	push   $0xf0106d96
f010297f:	e8 bc d6 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102984:	68 84 78 10 f0       	push   $0xf0107884
f0102989:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010298e:	68 a0 04 00 00       	push   $0x4a0
f0102993:	68 96 6d 10 f0       	push   $0xf0106d96
f0102998:	e8 a3 d6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010299d:	50                   	push   %eax
f010299e:	68 28 68 10 f0       	push   $0xf0106828
f01029a3:	68 ca 00 00 00       	push   $0xca
f01029a8:	68 96 6d 10 f0       	push   $0xf0106d96
f01029ad:	e8 8e d6 ff ff       	call   f0100040 <_panic>
f01029b2:	50                   	push   %eax
f01029b3:	68 28 68 10 f0       	push   $0xf0106828
f01029b8:	68 d5 00 00 00       	push   $0xd5
f01029bd:	68 96 6d 10 f0       	push   $0xf0106d96
f01029c2:	e8 79 d6 ff ff       	call   f0100040 <_panic>
f01029c7:	50                   	push   %eax
f01029c8:	68 28 68 10 f0       	push   $0xf0106828
f01029cd:	68 e2 00 00 00       	push   $0xe2
f01029d2:	68 96 6d 10 f0       	push   $0xf0106d96
f01029d7:	e8 64 d6 ff ff       	call   f0100040 <_panic>
f01029dc:	53                   	push   %ebx
f01029dd:	68 28 68 10 f0       	push   $0xf0106828
f01029e2:	68 24 01 00 00       	push   $0x124
f01029e7:	68 96 6d 10 f0       	push   $0xf0106d96
f01029ec:	e8 4f d6 ff ff       	call   f0100040 <_panic>
f01029f1:	56                   	push   %esi
f01029f2:	68 28 68 10 f0       	push   $0xf0106828
f01029f7:	68 b8 03 00 00       	push   $0x3b8
f01029fc:	68 96 6d 10 f0       	push   $0xf0106d96
f0102a01:	e8 3a d6 ff ff       	call   f0100040 <_panic>
	for (i = 0; i < n; i += PGSIZE)
f0102a06:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102a0c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f0102a0f:	76 3a                	jbe    f0102a4b <mem_init+0x1627>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102a11:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0102a17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a1a:	e8 30 e1 ff ff       	call   f0100b4f <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102a1f:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f0102a26:	76 c9                	jbe    f01029f1 <mem_init+0x15cd>
f0102a28:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0102a2b:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f0102a2e:	39 d0                	cmp    %edx,%eax
f0102a30:	74 d4                	je     f0102a06 <mem_init+0x15e2>
f0102a32:	68 b8 78 10 f0       	push   $0xf01078b8
f0102a37:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102a3c:	68 b8 03 00 00       	push   $0x3b8
f0102a41:	68 96 6d 10 f0       	push   $0xf0106d96
f0102a46:	e8 f5 d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102a4b:	a1 48 72 21 f0       	mov    0xf0217248,%eax
f0102a50:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0102a53:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102a56:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102a5b:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102a61:	89 da                	mov    %ebx,%edx
f0102a63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a66:	e8 e4 e0 ff ff       	call   f0100b4f <check_va2pa>
f0102a6b:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102a72:	76 3b                	jbe    f0102aaf <mem_init+0x168b>
f0102a74:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102a77:	39 d0                	cmp    %edx,%eax
f0102a79:	75 4b                	jne    f0102ac6 <mem_init+0x16a2>
f0102a7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102a81:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f0102a87:	75 d8                	jne    f0102a61 <mem_init+0x163d>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102a89:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102a8c:	c1 e6 0c             	shl    $0xc,%esi
f0102a8f:	89 fb                	mov    %edi,%ebx
f0102a91:	39 f3                	cmp    %esi,%ebx
f0102a93:	73 63                	jae    f0102af8 <mem_init+0x16d4>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102a95:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102a9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a9e:	e8 ac e0 ff ff       	call   f0100b4f <check_va2pa>
f0102aa3:	39 c3                	cmp    %eax,%ebx
f0102aa5:	75 38                	jne    f0102adf <mem_init+0x16bb>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102aa7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102aad:	eb e2                	jmp    f0102a91 <mem_init+0x166d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102aaf:	ff 75 c8             	pushl  -0x38(%ebp)
f0102ab2:	68 28 68 10 f0       	push   $0xf0106828
f0102ab7:	68 bd 03 00 00       	push   $0x3bd
f0102abc:	68 96 6d 10 f0       	push   $0xf0106d96
f0102ac1:	e8 7a d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102ac6:	68 ec 78 10 f0       	push   $0xf01078ec
f0102acb:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102ad0:	68 bd 03 00 00       	push   $0x3bd
f0102ad5:	68 96 6d 10 f0       	push   $0xf0106d96
f0102ada:	e8 61 d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102adf:	68 20 79 10 f0       	push   $0xf0107920
f0102ae4:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102ae9:	68 c1 03 00 00       	push   $0x3c1
f0102aee:	68 96 6d 10 f0       	push   $0xf0106d96
f0102af3:	e8 48 d5 ff ff       	call   f0100040 <_panic>
f0102af8:	c7 45 cc 00 90 22 00 	movl   $0x229000,-0x34(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102aff:	bb 00 80 ff ef       	mov    $0xefff8000,%ebx
f0102b04:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102b07:	8d bb 00 80 ff ff    	lea    -0x8000(%ebx),%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102b0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102b10:	89 45 bc             	mov    %eax,-0x44(%ebp)
f0102b13:	89 de                	mov    %ebx,%esi
f0102b15:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102b18:	05 00 80 ff 0f       	add    $0xfff8000,%eax
f0102b1d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102b20:	8d 83 00 80 00 00    	lea    0x8000(%ebx),%eax
f0102b26:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102b29:	89 f2                	mov    %esi,%edx
f0102b2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b2e:	e8 1c e0 ff ff       	call   f0100b4f <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102b33:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102b3a:	76 58                	jbe    f0102b94 <mem_init+0x1770>
f0102b3c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0102b3f:	8d 14 31             	lea    (%ecx,%esi,1),%edx
f0102b42:	39 d0                	cmp    %edx,%eax
f0102b44:	75 65                	jne    f0102bab <mem_init+0x1787>
f0102b46:	81 c6 00 10 00 00    	add    $0x1000,%esi
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102b4c:	3b 75 c4             	cmp    -0x3c(%ebp),%esi
f0102b4f:	75 d8                	jne    f0102b29 <mem_init+0x1705>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102b51:	89 fa                	mov    %edi,%edx
f0102b53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b56:	e8 f4 df ff ff       	call   f0100b4f <check_va2pa>
f0102b5b:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102b5e:	75 64                	jne    f0102bc4 <mem_init+0x17a0>
f0102b60:	81 c7 00 10 00 00    	add    $0x1000,%edi
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102b66:	39 df                	cmp    %ebx,%edi
f0102b68:	75 e7                	jne    f0102b51 <mem_init+0x172d>
f0102b6a:	81 eb 00 00 01 00    	sub    $0x10000,%ebx
f0102b70:	81 45 d0 00 80 00 00 	addl   $0x8000,-0x30(%ebp)
f0102b77:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102b7a:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
	for (n = 0; n < NCPU; n++) {
f0102b81:	3d 00 90 25 f0       	cmp    $0xf0259000,%eax
f0102b86:	0f 85 7b ff ff ff    	jne    f0102b07 <mem_init+0x16e3>
f0102b8c:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0102b8f:	e9 84 00 00 00       	jmp    f0102c18 <mem_init+0x17f4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102b94:	ff 75 bc             	pushl  -0x44(%ebp)
f0102b97:	68 28 68 10 f0       	push   $0xf0106828
f0102b9c:	68 c9 03 00 00       	push   $0x3c9
f0102ba1:	68 96 6d 10 f0       	push   $0xf0106d96
f0102ba6:	e8 95 d4 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102bab:	68 48 79 10 f0       	push   $0xf0107948
f0102bb0:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102bb5:	68 c8 03 00 00       	push   $0x3c8
f0102bba:	68 96 6d 10 f0       	push   $0xf0106d96
f0102bbf:	e8 7c d4 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102bc4:	68 90 79 10 f0       	push   $0xf0107990
f0102bc9:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102bce:	68 cb 03 00 00       	push   $0x3cb
f0102bd3:	68 96 6d 10 f0       	push   $0xf0106d96
f0102bd8:	e8 63 d4 ff ff       	call   f0100040 <_panic>
			assert(pgdir[i] & PTE_P);
f0102bdd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102be0:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102be4:	75 4e                	jne    f0102c34 <mem_init+0x1810>
f0102be6:	68 78 70 10 f0       	push   $0xf0107078
f0102beb:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102bf0:	68 d6 03 00 00       	push   $0x3d6
f0102bf5:	68 96 6d 10 f0       	push   $0xf0106d96
f0102bfa:	e8 41 d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102bff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102c02:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0102c05:	a8 01                	test   $0x1,%al
f0102c07:	74 30                	je     f0102c39 <mem_init+0x1815>
				assert(pgdir[i] & PTE_W);
f0102c09:	a8 02                	test   $0x2,%al
f0102c0b:	74 45                	je     f0102c52 <mem_init+0x182e>
	for (i = 0; i < NPDENTRIES; i++) {
f0102c0d:	83 c7 01             	add    $0x1,%edi
f0102c10:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0102c16:	74 6c                	je     f0102c84 <mem_init+0x1860>
		switch (i) {
f0102c18:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f0102c1e:	83 f8 04             	cmp    $0x4,%eax
f0102c21:	76 ba                	jbe    f0102bdd <mem_init+0x17b9>
			if (i >= PDX(KERNBASE)) {
f0102c23:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102c29:	77 d4                	ja     f0102bff <mem_init+0x17db>
				assert(pgdir[i] == 0);
f0102c2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102c2e:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102c32:	75 37                	jne    f0102c6b <mem_init+0x1847>
	for (i = 0; i < NPDENTRIES; i++) {
f0102c34:	83 c7 01             	add    $0x1,%edi
f0102c37:	eb df                	jmp    f0102c18 <mem_init+0x17f4>
				assert(pgdir[i] & PTE_P);
f0102c39:	68 78 70 10 f0       	push   $0xf0107078
f0102c3e:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102c43:	68 da 03 00 00       	push   $0x3da
f0102c48:	68 96 6d 10 f0       	push   $0xf0106d96
f0102c4d:	e8 ee d3 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f0102c52:	68 89 70 10 f0       	push   $0xf0107089
f0102c57:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102c5c:	68 db 03 00 00       	push   $0x3db
f0102c61:	68 96 6d 10 f0       	push   $0xf0106d96
f0102c66:	e8 d5 d3 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102c6b:	68 9a 70 10 f0       	push   $0xf010709a
f0102c70:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102c75:	68 dd 03 00 00       	push   $0x3dd
f0102c7a:	68 96 6d 10 f0       	push   $0xf0106d96
f0102c7f:	e8 bc d3 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102c84:	83 ec 0c             	sub    $0xc,%esp
f0102c87:	68 b4 79 10 f0       	push   $0xf01079b4
f0102c8c:	e8 76 0d 00 00       	call   f0103a07 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102c91:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0102c96:	83 c4 10             	add    $0x10,%esp
f0102c99:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102c9e:	0f 86 03 02 00 00    	jbe    f0102ea7 <mem_init+0x1a83>
	return (physaddr_t)kva - KERNBASE;
f0102ca4:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102ca9:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102cac:	b8 00 00 00 00       	mov    $0x0,%eax
f0102cb1:	e8 fc de ff ff       	call   f0100bb2 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102cb6:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102cb9:	83 e0 f3             	and    $0xfffffff3,%eax
f0102cbc:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102cc1:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102cc4:	83 ec 0c             	sub    $0xc,%esp
f0102cc7:	6a 00                	push   $0x0
f0102cc9:	e8 20 e3 ff ff       	call   f0100fee <page_alloc>
f0102cce:	89 c6                	mov    %eax,%esi
f0102cd0:	83 c4 10             	add    $0x10,%esp
f0102cd3:	85 c0                	test   %eax,%eax
f0102cd5:	0f 84 e1 01 00 00    	je     f0102ebc <mem_init+0x1a98>
	assert((pp1 = page_alloc(0)));
f0102cdb:	83 ec 0c             	sub    $0xc,%esp
f0102cde:	6a 00                	push   $0x0
f0102ce0:	e8 09 e3 ff ff       	call   f0100fee <page_alloc>
f0102ce5:	89 c7                	mov    %eax,%edi
f0102ce7:	83 c4 10             	add    $0x10,%esp
f0102cea:	85 c0                	test   %eax,%eax
f0102cec:	0f 84 e3 01 00 00    	je     f0102ed5 <mem_init+0x1ab1>
	assert((pp2 = page_alloc(0)));
f0102cf2:	83 ec 0c             	sub    $0xc,%esp
f0102cf5:	6a 00                	push   $0x0
f0102cf7:	e8 f2 e2 ff ff       	call   f0100fee <page_alloc>
f0102cfc:	89 c3                	mov    %eax,%ebx
f0102cfe:	83 c4 10             	add    $0x10,%esp
f0102d01:	85 c0                	test   %eax,%eax
f0102d03:	0f 84 e5 01 00 00    	je     f0102eee <mem_init+0x1aca>
	page_free(pp0);
f0102d09:	83 ec 0c             	sub    $0xc,%esp
f0102d0c:	56                   	push   %esi
f0102d0d:	e8 67 e3 ff ff       	call   f0101079 <page_free>
	return (pp - pages) << PGSHIFT;
f0102d12:	89 f8                	mov    %edi,%eax
f0102d14:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0102d1a:	c1 f8 03             	sar    $0x3,%eax
f0102d1d:	89 c2                	mov    %eax,%edx
f0102d1f:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102d22:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102d27:	83 c4 10             	add    $0x10,%esp
f0102d2a:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0102d30:	0f 83 d1 01 00 00    	jae    f0102f07 <mem_init+0x1ae3>
	memset(page2kva(pp1), 1, PGSIZE);
f0102d36:	83 ec 04             	sub    $0x4,%esp
f0102d39:	68 00 10 00 00       	push   $0x1000
f0102d3e:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102d40:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102d46:	52                   	push   %edx
f0102d47:	e8 f6 2d 00 00       	call   f0105b42 <memset>
	return (pp - pages) << PGSHIFT;
f0102d4c:	89 d8                	mov    %ebx,%eax
f0102d4e:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0102d54:	c1 f8 03             	sar    $0x3,%eax
f0102d57:	89 c2                	mov    %eax,%edx
f0102d59:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102d5c:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102d61:	83 c4 10             	add    $0x10,%esp
f0102d64:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0102d6a:	0f 83 a9 01 00 00    	jae    f0102f19 <mem_init+0x1af5>
	memset(page2kva(pp2), 2, PGSIZE);
f0102d70:	83 ec 04             	sub    $0x4,%esp
f0102d73:	68 00 10 00 00       	push   $0x1000
f0102d78:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102d7a:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102d80:	52                   	push   %edx
f0102d81:	e8 bc 2d 00 00       	call   f0105b42 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102d86:	6a 02                	push   $0x2
f0102d88:	68 00 10 00 00       	push   $0x1000
f0102d8d:	57                   	push   %edi
f0102d8e:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0102d94:	e8 91 e5 ff ff       	call   f010132a <page_insert>
	assert(pp1->pp_ref == 1);
f0102d99:	83 c4 20             	add    $0x20,%esp
f0102d9c:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102da1:	0f 85 84 01 00 00    	jne    f0102f2b <mem_init+0x1b07>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102da7:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102dae:	01 01 01 
f0102db1:	0f 85 8d 01 00 00    	jne    f0102f44 <mem_init+0x1b20>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102db7:	6a 02                	push   $0x2
f0102db9:	68 00 10 00 00       	push   $0x1000
f0102dbe:	53                   	push   %ebx
f0102dbf:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0102dc5:	e8 60 e5 ff ff       	call   f010132a <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102dca:	83 c4 10             	add    $0x10,%esp
f0102dcd:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102dd4:	02 02 02 
f0102dd7:	0f 85 80 01 00 00    	jne    f0102f5d <mem_init+0x1b39>
	assert(pp2->pp_ref == 1);
f0102ddd:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102de2:	0f 85 8e 01 00 00    	jne    f0102f76 <mem_init+0x1b52>
	assert(pp1->pp_ref == 0);
f0102de8:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102ded:	0f 85 9c 01 00 00    	jne    f0102f8f <mem_init+0x1b6b>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102df3:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102dfa:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102dfd:	89 d8                	mov    %ebx,%eax
f0102dff:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0102e05:	c1 f8 03             	sar    $0x3,%eax
f0102e08:	89 c2                	mov    %eax,%edx
f0102e0a:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102e0d:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102e12:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0102e18:	0f 83 8a 01 00 00    	jae    f0102fa8 <mem_init+0x1b84>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102e1e:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f0102e25:	03 03 03 
f0102e28:	0f 85 8c 01 00 00    	jne    f0102fba <mem_init+0x1b96>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102e2e:	83 ec 08             	sub    $0x8,%esp
f0102e31:	68 00 10 00 00       	push   $0x1000
f0102e36:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0102e3c:	e8 9f e4 ff ff       	call   f01012e0 <page_remove>
	assert(pp2->pp_ref == 0);
f0102e41:	83 c4 10             	add    $0x10,%esp
f0102e44:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102e49:	0f 85 84 01 00 00    	jne    f0102fd3 <mem_init+0x1baf>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102e4f:	8b 0d 8c 7e 21 f0    	mov    0xf0217e8c,%ecx
f0102e55:	8b 11                	mov    (%ecx),%edx
f0102e57:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102e5d:	89 f0                	mov    %esi,%eax
f0102e5f:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0102e65:	c1 f8 03             	sar    $0x3,%eax
f0102e68:	c1 e0 0c             	shl    $0xc,%eax
f0102e6b:	39 c2                	cmp    %eax,%edx
f0102e6d:	0f 85 79 01 00 00    	jne    f0102fec <mem_init+0x1bc8>
	kern_pgdir[0] = 0;
f0102e73:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102e79:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102e7e:	0f 85 81 01 00 00    	jne    f0103005 <mem_init+0x1be1>
	pp0->pp_ref = 0;
f0102e84:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0102e8a:	83 ec 0c             	sub    $0xc,%esp
f0102e8d:	56                   	push   %esi
f0102e8e:	e8 e6 e1 ff ff       	call   f0101079 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102e93:	c7 04 24 48 7a 10 f0 	movl   $0xf0107a48,(%esp)
f0102e9a:	e8 68 0b 00 00       	call   f0103a07 <cprintf>
}
f0102e9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102ea2:	5b                   	pop    %ebx
f0102ea3:	5e                   	pop    %esi
f0102ea4:	5f                   	pop    %edi
f0102ea5:	5d                   	pop    %ebp
f0102ea6:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102ea7:	50                   	push   %eax
f0102ea8:	68 28 68 10 f0       	push   $0xf0106828
f0102ead:	68 fb 00 00 00       	push   $0xfb
f0102eb2:	68 96 6d 10 f0       	push   $0xf0106d96
f0102eb7:	e8 84 d1 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102ebc:	68 84 6e 10 f0       	push   $0xf0106e84
f0102ec1:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102ec6:	68 b5 04 00 00       	push   $0x4b5
f0102ecb:	68 96 6d 10 f0       	push   $0xf0106d96
f0102ed0:	e8 6b d1 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102ed5:	68 9a 6e 10 f0       	push   $0xf0106e9a
f0102eda:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102edf:	68 b6 04 00 00       	push   $0x4b6
f0102ee4:	68 96 6d 10 f0       	push   $0xf0106d96
f0102ee9:	e8 52 d1 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102eee:	68 b0 6e 10 f0       	push   $0xf0106eb0
f0102ef3:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102ef8:	68 b7 04 00 00       	push   $0x4b7
f0102efd:	68 96 6d 10 f0       	push   $0xf0106d96
f0102f02:	e8 39 d1 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102f07:	52                   	push   %edx
f0102f08:	68 04 68 10 f0       	push   $0xf0106804
f0102f0d:	6a 58                	push   $0x58
f0102f0f:	68 a2 6d 10 f0       	push   $0xf0106da2
f0102f14:	e8 27 d1 ff ff       	call   f0100040 <_panic>
f0102f19:	52                   	push   %edx
f0102f1a:	68 04 68 10 f0       	push   $0xf0106804
f0102f1f:	6a 58                	push   $0x58
f0102f21:	68 a2 6d 10 f0       	push   $0xf0106da2
f0102f26:	e8 15 d1 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102f2b:	68 81 6f 10 f0       	push   $0xf0106f81
f0102f30:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102f35:	68 bc 04 00 00       	push   $0x4bc
f0102f3a:	68 96 6d 10 f0       	push   $0xf0106d96
f0102f3f:	e8 fc d0 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102f44:	68 d4 79 10 f0       	push   $0xf01079d4
f0102f49:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102f4e:	68 bd 04 00 00       	push   $0x4bd
f0102f53:	68 96 6d 10 f0       	push   $0xf0106d96
f0102f58:	e8 e3 d0 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102f5d:	68 f8 79 10 f0       	push   $0xf01079f8
f0102f62:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102f67:	68 bf 04 00 00       	push   $0x4bf
f0102f6c:	68 96 6d 10 f0       	push   $0xf0106d96
f0102f71:	e8 ca d0 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102f76:	68 a3 6f 10 f0       	push   $0xf0106fa3
f0102f7b:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102f80:	68 c0 04 00 00       	push   $0x4c0
f0102f85:	68 96 6d 10 f0       	push   $0xf0106d96
f0102f8a:	e8 b1 d0 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102f8f:	68 0d 70 10 f0       	push   $0xf010700d
f0102f94:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102f99:	68 c1 04 00 00       	push   $0x4c1
f0102f9e:	68 96 6d 10 f0       	push   $0xf0106d96
f0102fa3:	e8 98 d0 ff ff       	call   f0100040 <_panic>
f0102fa8:	52                   	push   %edx
f0102fa9:	68 04 68 10 f0       	push   $0xf0106804
f0102fae:	6a 58                	push   $0x58
f0102fb0:	68 a2 6d 10 f0       	push   $0xf0106da2
f0102fb5:	e8 86 d0 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102fba:	68 1c 7a 10 f0       	push   $0xf0107a1c
f0102fbf:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102fc4:	68 c3 04 00 00       	push   $0x4c3
f0102fc9:	68 96 6d 10 f0       	push   $0xf0106d96
f0102fce:	e8 6d d0 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102fd3:	68 db 6f 10 f0       	push   $0xf0106fdb
f0102fd8:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102fdd:	68 c5 04 00 00       	push   $0x4c5
f0102fe2:	68 96 6d 10 f0       	push   $0xf0106d96
f0102fe7:	e8 54 d0 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102fec:	68 a4 73 10 f0       	push   $0xf01073a4
f0102ff1:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102ff6:	68 c8 04 00 00       	push   $0x4c8
f0102ffb:	68 96 6d 10 f0       	push   $0xf0106d96
f0103000:	e8 3b d0 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0103005:	68 92 6f 10 f0       	push   $0xf0106f92
f010300a:	68 bc 6d 10 f0       	push   $0xf0106dbc
f010300f:	68 ca 04 00 00       	push   $0x4ca
f0103014:	68 96 6d 10 f0       	push   $0xf0106d96
f0103019:	e8 22 d0 ff ff       	call   f0100040 <_panic>

f010301e <user_mem_check>:
{
f010301e:	f3 0f 1e fb          	endbr32 
f0103022:	55                   	push   %ebp
f0103023:	89 e5                	mov    %esp,%ebp
f0103025:	57                   	push   %edi
f0103026:	56                   	push   %esi
f0103027:	53                   	push   %ebx
f0103028:	83 ec 0c             	sub    $0xc,%esp
    vstart = ROUNDDOWN((uintptr_t)va, PGSIZE);
f010302b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010302e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    vend = ROUNDUP((uintptr_t)va + len, PGSIZE);
f0103034:	8b 45 10             	mov    0x10(%ebp),%eax
f0103037:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010303a:	8d bc 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edi
f0103041:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if (vend > ULIM) {
f0103047:	81 ff 00 00 80 ef    	cmp    $0xef800000,%edi
f010304d:	77 08                	ja     f0103057 <user_mem_check+0x39>
        if (!pte || (*pte & (perm | PTE_P)) != (perm | PTE_P)) {
f010304f:	8b 75 14             	mov    0x14(%ebp),%esi
f0103052:	83 ce 01             	or     $0x1,%esi
f0103055:	eb 22                	jmp    f0103079 <user_mem_check+0x5b>
        user_mem_check_addr = MAX(ULIM, (uintptr_t)va);
f0103057:	81 7d 0c 00 00 80 ef 	cmpl   $0xef800000,0xc(%ebp)
f010305e:	b8 00 00 80 ef       	mov    $0xef800000,%eax
f0103063:	0f 43 45 0c          	cmovae 0xc(%ebp),%eax
f0103067:	a3 3c 72 21 f0       	mov    %eax,0xf021723c
        return -E_FAULT;
f010306c:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103071:	eb 3c                	jmp    f01030af <user_mem_check+0x91>
    for (; vstart < vend; vstart += PGSIZE) {
f0103073:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103079:	39 fb                	cmp    %edi,%ebx
f010307b:	73 3a                	jae    f01030b7 <user_mem_check+0x99>
        pte = pgdir_walk(env->env_pgdir, (void*)vstart, 0);
f010307d:	83 ec 04             	sub    $0x4,%esp
f0103080:	6a 00                	push   $0x0
f0103082:	53                   	push   %ebx
f0103083:	8b 45 08             	mov    0x8(%ebp),%eax
f0103086:	ff 70 60             	pushl  0x60(%eax)
f0103089:	e8 6e e0 ff ff       	call   f01010fc <pgdir_walk>
        if (!pte || (*pte & (perm | PTE_P)) != (perm | PTE_P)) {
f010308e:	83 c4 10             	add    $0x10,%esp
f0103091:	85 c0                	test   %eax,%eax
f0103093:	74 08                	je     f010309d <user_mem_check+0x7f>
f0103095:	89 f2                	mov    %esi,%edx
f0103097:	23 10                	and    (%eax),%edx
f0103099:	39 d6                	cmp    %edx,%esi
f010309b:	74 d6                	je     f0103073 <user_mem_check+0x55>
            user_mem_check_addr = MAX(vstart, (uintptr_t)va);
f010309d:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f01030a0:	0f 42 5d 0c          	cmovb  0xc(%ebp),%ebx
f01030a4:	89 1d 3c 72 21 f0    	mov    %ebx,0xf021723c
            return -E_FAULT;
f01030aa:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f01030af:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01030b2:	5b                   	pop    %ebx
f01030b3:	5e                   	pop    %esi
f01030b4:	5f                   	pop    %edi
f01030b5:	5d                   	pop    %ebp
f01030b6:	c3                   	ret    
    return 0;
f01030b7:	b8 00 00 00 00       	mov    $0x0,%eax
f01030bc:	eb f1                	jmp    f01030af <user_mem_check+0x91>

f01030be <user_mem_assert>:
{
f01030be:	f3 0f 1e fb          	endbr32 
f01030c2:	55                   	push   %ebp
f01030c3:	89 e5                	mov    %esp,%ebp
f01030c5:	53                   	push   %ebx
f01030c6:	83 ec 04             	sub    $0x4,%esp
f01030c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f01030cc:	8b 45 14             	mov    0x14(%ebp),%eax
f01030cf:	83 c8 04             	or     $0x4,%eax
f01030d2:	50                   	push   %eax
f01030d3:	ff 75 10             	pushl  0x10(%ebp)
f01030d6:	ff 75 0c             	pushl  0xc(%ebp)
f01030d9:	53                   	push   %ebx
f01030da:	e8 3f ff ff ff       	call   f010301e <user_mem_check>
f01030df:	83 c4 10             	add    $0x10,%esp
f01030e2:	85 c0                	test   %eax,%eax
f01030e4:	78 05                	js     f01030eb <user_mem_assert+0x2d>
}
f01030e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01030e9:	c9                   	leave  
f01030ea:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f01030eb:	83 ec 04             	sub    $0x4,%esp
f01030ee:	ff 35 3c 72 21 f0    	pushl  0xf021723c
f01030f4:	ff 73 48             	pushl  0x48(%ebx)
f01030f7:	68 74 7a 10 f0       	push   $0xf0107a74
f01030fc:	e8 06 09 00 00       	call   f0103a07 <cprintf>
		env_destroy(env);	// may not return
f0103101:	89 1c 24             	mov    %ebx,(%esp)
f0103104:	e8 13 06 00 00       	call   f010371c <env_destroy>
f0103109:	83 c4 10             	add    $0x10,%esp
}
f010310c:	eb d8                	jmp    f01030e6 <user_mem_assert+0x28>

f010310e <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f010310e:	55                   	push   %ebp
f010310f:	89 e5                	mov    %esp,%ebp
f0103111:	57                   	push   %edi
f0103112:	56                   	push   %esi
f0103113:	53                   	push   %ebx
f0103114:	83 ec 0c             	sub    $0xc,%esp
f0103117:	89 c7                	mov    %eax,%edi
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	// ROUNDDOWN/ROUNDUP在inc/types.h中
	void* begin = ROUNDDOWN(va, PGSIZE);
f0103119:	89 d3                	mov    %edx,%ebx
f010311b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	void* end = ROUNDUP(va + len, PGSIZE);
f0103121:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f0103128:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	while(begin < end){
f010312e:	39 f3                	cmp    %esi,%ebx
f0103130:	73 3f                	jae    f0103171 <region_alloc+0x63>
		struct PageInfo* pp = page_alloc(0);
f0103132:	83 ec 0c             	sub    $0xc,%esp
f0103135:	6a 00                	push   $0x0
f0103137:	e8 b2 de ff ff       	call   f0100fee <page_alloc>
		if(!pp){
f010313c:	83 c4 10             	add    $0x10,%esp
f010313f:	85 c0                	test   %eax,%eax
f0103141:	74 17                	je     f010315a <region_alloc+0x4c>
			panic("region_alloc failed\n");
		}
		page_insert(e->env_pgdir, pp, begin, PTE_W | PTE_U);
f0103143:	6a 06                	push   $0x6
f0103145:	53                   	push   %ebx
f0103146:	50                   	push   %eax
f0103147:	ff 77 60             	pushl  0x60(%edi)
f010314a:	e8 db e1 ff ff       	call   f010132a <page_insert>
		begin += PGSIZE;
f010314f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103155:	83 c4 10             	add    $0x10,%esp
f0103158:	eb d4                	jmp    f010312e <region_alloc+0x20>
			panic("region_alloc failed\n");
f010315a:	83 ec 04             	sub    $0x4,%esp
f010315d:	68 a9 7a 10 f0       	push   $0xf0107aa9
f0103162:	68 2c 01 00 00       	push   $0x12c
f0103167:	68 be 7a 10 f0       	push   $0xf0107abe
f010316c:	e8 cf ce ff ff       	call   f0100040 <_panic>
	}
}
f0103171:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103174:	5b                   	pop    %ebx
f0103175:	5e                   	pop    %esi
f0103176:	5f                   	pop    %edi
f0103177:	5d                   	pop    %ebp
f0103178:	c3                   	ret    

f0103179 <envid2env>:
{
f0103179:	f3 0f 1e fb          	endbr32 
f010317d:	55                   	push   %ebp
f010317e:	89 e5                	mov    %esp,%ebp
f0103180:	56                   	push   %esi
f0103181:	53                   	push   %ebx
f0103182:	8b 75 08             	mov    0x8(%ebp),%esi
f0103185:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f0103188:	85 f6                	test   %esi,%esi
f010318a:	74 2e                	je     f01031ba <envid2env+0x41>
	e = &envs[ENVX(envid)];
f010318c:	89 f3                	mov    %esi,%ebx
f010318e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103194:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103197:	03 1d 48 72 21 f0    	add    0xf0217248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010319d:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f01031a1:	74 2e                	je     f01031d1 <envid2env+0x58>
f01031a3:	39 73 48             	cmp    %esi,0x48(%ebx)
f01031a6:	75 29                	jne    f01031d1 <envid2env+0x58>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01031a8:	84 c0                	test   %al,%al
f01031aa:	75 35                	jne    f01031e1 <envid2env+0x68>
	*env_store = e;
f01031ac:	8b 45 0c             	mov    0xc(%ebp),%eax
f01031af:	89 18                	mov    %ebx,(%eax)
	return 0;
f01031b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01031b6:	5b                   	pop    %ebx
f01031b7:	5e                   	pop    %esi
f01031b8:	5d                   	pop    %ebp
f01031b9:	c3                   	ret    
		*env_store = curenv;
f01031ba:	e8 a3 2f 00 00       	call   f0106162 <cpunum>
f01031bf:	6b c0 74             	imul   $0x74,%eax,%eax
f01031c2:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f01031c8:	8b 55 0c             	mov    0xc(%ebp),%edx
f01031cb:	89 02                	mov    %eax,(%edx)
		return 0;
f01031cd:	89 f0                	mov    %esi,%eax
f01031cf:	eb e5                	jmp    f01031b6 <envid2env+0x3d>
		*env_store = 0;
f01031d1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01031d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01031da:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01031df:	eb d5                	jmp    f01031b6 <envid2env+0x3d>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01031e1:	e8 7c 2f 00 00       	call   f0106162 <cpunum>
f01031e6:	6b c0 74             	imul   $0x74,%eax,%eax
f01031e9:	39 98 28 80 21 f0    	cmp    %ebx,-0xfde7fd8(%eax)
f01031ef:	74 bb                	je     f01031ac <envid2env+0x33>
f01031f1:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01031f4:	e8 69 2f 00 00       	call   f0106162 <cpunum>
f01031f9:	6b c0 74             	imul   $0x74,%eax,%eax
f01031fc:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0103202:	3b 70 48             	cmp    0x48(%eax),%esi
f0103205:	74 a5                	je     f01031ac <envid2env+0x33>
		*env_store = 0;
f0103207:	8b 45 0c             	mov    0xc(%ebp),%eax
f010320a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103210:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103215:	eb 9f                	jmp    f01031b6 <envid2env+0x3d>

f0103217 <env_init_percpu>:
{
f0103217:	f3 0f 1e fb          	endbr32 
	asm volatile("lgdt (%0)" : : "r" (p));
f010321b:	b8 20 33 12 f0       	mov    $0xf0123320,%eax
f0103220:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f0103223:	b8 23 00 00 00       	mov    $0x23,%eax
f0103228:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f010322a:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f010322c:	b8 10 00 00 00       	mov    $0x10,%eax
f0103231:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f0103233:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103235:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103237:	ea 3e 32 10 f0 08 00 	ljmp   $0x8,$0xf010323e
	asm volatile("lldt %0" : : "r" (sel));
f010323e:	b8 00 00 00 00       	mov    $0x0,%eax
f0103243:	0f 00 d0             	lldt   %ax
}
f0103246:	c3                   	ret    

f0103247 <env_init>:
{
f0103247:	f3 0f 1e fb          	endbr32 
f010324b:	55                   	push   %ebp
f010324c:	89 e5                	mov    %esp,%ebp
f010324e:	56                   	push   %esi
f010324f:	53                   	push   %ebx
		envs[i].env_id = 0;
f0103250:	8b 35 48 72 21 f0    	mov    0xf0217248,%esi
f0103256:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f010325c:	89 f3                	mov    %esi,%ebx
f010325e:	ba 00 00 00 00       	mov    $0x0,%edx
f0103263:	89 d1                	mov    %edx,%ecx
f0103265:	89 c2                	mov    %eax,%edx
f0103267:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_link = env_free_list;
f010326e:	89 48 44             	mov    %ecx,0x44(%eax)
f0103271:	83 e8 7c             	sub    $0x7c,%eax
	for(i = NENV - 1; i >= 0; i--){
f0103274:	39 da                	cmp    %ebx,%edx
f0103276:	75 eb                	jne    f0103263 <env_init+0x1c>
f0103278:	89 35 4c 72 21 f0    	mov    %esi,0xf021724c
	env_init_percpu();
f010327e:	e8 94 ff ff ff       	call   f0103217 <env_init_percpu>
}
f0103283:	5b                   	pop    %ebx
f0103284:	5e                   	pop    %esi
f0103285:	5d                   	pop    %ebp
f0103286:	c3                   	ret    

f0103287 <env_alloc>:
{
f0103287:	f3 0f 1e fb          	endbr32 
f010328b:	55                   	push   %ebp
f010328c:	89 e5                	mov    %esp,%ebp
f010328e:	53                   	push   %ebx
f010328f:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f0103292:	8b 1d 4c 72 21 f0    	mov    0xf021724c,%ebx
f0103298:	85 db                	test   %ebx,%ebx
f010329a:	0f 84 3b 01 00 00    	je     f01033db <env_alloc+0x154>
	if (!(p = page_alloc(ALLOC_ZERO)))
f01032a0:	83 ec 0c             	sub    $0xc,%esp
f01032a3:	6a 01                	push   $0x1
f01032a5:	e8 44 dd ff ff       	call   f0100fee <page_alloc>
f01032aa:	83 c4 10             	add    $0x10,%esp
f01032ad:	85 c0                	test   %eax,%eax
f01032af:	0f 84 2d 01 00 00    	je     f01033e2 <env_alloc+0x15b>
	p->pp_ref++;
f01032b5:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01032ba:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f01032c0:	c1 f8 03             	sar    $0x3,%eax
f01032c3:	89 c2                	mov    %eax,%edx
f01032c5:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01032c8:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01032cd:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f01032d3:	0f 83 db 00 00 00    	jae    f01033b4 <env_alloc+0x12d>
	return (void *)(pa + KERNBASE);
f01032d9:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	e->env_pgdir = (pde_t *)page2kva(p);
f01032df:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f01032e2:	83 ec 04             	sub    $0x4,%esp
f01032e5:	68 00 10 00 00       	push   $0x1000
f01032ea:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f01032f0:	50                   	push   %eax
f01032f1:	e8 fe 28 00 00       	call   f0105bf4 <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f01032f6:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01032f9:	83 c4 10             	add    $0x10,%esp
f01032fc:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103301:	0f 86 bf 00 00 00    	jbe    f01033c6 <env_alloc+0x13f>
	return (physaddr_t)kva - KERNBASE;
f0103307:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010330d:	83 ca 05             	or     $0x5,%edx
f0103310:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103316:	8b 43 48             	mov    0x48(%ebx),%eax
f0103319:	05 00 10 00 00       	add    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
f010331e:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f0103323:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103328:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f010332b:	89 da                	mov    %ebx,%edx
f010332d:	2b 15 48 72 21 f0    	sub    0xf0217248,%edx
f0103333:	c1 fa 02             	sar    $0x2,%edx
f0103336:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f010333c:	09 d0                	or     %edx,%eax
f010333e:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f0103341:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103344:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103347:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f010334e:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103355:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f010335c:	83 ec 04             	sub    $0x4,%esp
f010335f:	6a 44                	push   $0x44
f0103361:	6a 00                	push   $0x0
f0103363:	53                   	push   %ebx
f0103364:	e8 d9 27 00 00       	call   f0105b42 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f0103369:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f010336f:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103375:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f010337b:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103382:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f0103388:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f010338f:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f0103396:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f010339a:	8b 43 44             	mov    0x44(%ebx),%eax
f010339d:	a3 4c 72 21 f0       	mov    %eax,0xf021724c
	*newenv_store = e;
f01033a2:	8b 45 08             	mov    0x8(%ebp),%eax
f01033a5:	89 18                	mov    %ebx,(%eax)
	return 0;
f01033a7:	83 c4 10             	add    $0x10,%esp
f01033aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01033af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01033b2:	c9                   	leave  
f01033b3:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01033b4:	52                   	push   %edx
f01033b5:	68 04 68 10 f0       	push   $0xf0106804
f01033ba:	6a 58                	push   $0x58
f01033bc:	68 a2 6d 10 f0       	push   $0xf0106da2
f01033c1:	e8 7a cc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033c6:	50                   	push   %eax
f01033c7:	68 28 68 10 f0       	push   $0xf0106828
f01033cc:	68 c7 00 00 00       	push   $0xc7
f01033d1:	68 be 7a 10 f0       	push   $0xf0107abe
f01033d6:	e8 65 cc ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f01033db:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f01033e0:	eb cd                	jmp    f01033af <env_alloc+0x128>
		return -E_NO_MEM;
f01033e2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01033e7:	eb c6                	jmp    f01033af <env_alloc+0x128>

f01033e9 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f01033e9:	f3 0f 1e fb          	endbr32 
f01033ed:	55                   	push   %ebp
f01033ee:	89 e5                	mov    %esp,%ebp
f01033f0:	57                   	push   %edi
f01033f1:	56                   	push   %esi
f01033f2:	53                   	push   %ebx
f01033f3:	83 ec 34             	sub    $0x34,%esp
f01033f6:	8b 75 08             	mov    0x8(%ebp),%esi
	// LAB 3: Your code here.

	// Allocates a new env with env_alloc
	struct Env* env;
	int r;
	if(env_alloc(&env, 0)){
f01033f9:	6a 00                	push   $0x0
f01033fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01033fe:	50                   	push   %eax
f01033ff:	e8 83 fe ff ff       	call   f0103287 <env_alloc>
f0103404:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103407:	83 c4 10             	add    $0x10,%esp
f010340a:	85 c0                	test   %eax,%eax
f010340c:	75 3a                	jne    f0103448 <env_create+0x5f>
		panic("env_create failed: create env failed\n");
	}

	// loads the named elf binary into it with load_icode
	load_icode(env, binary);
f010340e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103411:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(header->e_magic != ELF_MAGIC)
f0103414:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
f010341a:	75 43                	jne    f010345f <env_create+0x76>
	if(header->e_entry == 0)
f010341c:	83 7e 18 00          	cmpl   $0x0,0x18(%esi)
f0103420:	74 54                	je     f0103476 <env_create+0x8d>
	struct Proghdr* ph = (struct Proghdr*)((uint8_t*)header + header->e_phoff);
f0103422:	8b 5e 1c             	mov    0x1c(%esi),%ebx
	int phnum = header->e_phnum;
f0103425:	0f b7 46 2c          	movzwl 0x2c(%esi),%eax
f0103429:	89 45 cc             	mov    %eax,-0x34(%ebp)
	lcr3(PADDR(e->env_pgdir));
f010342c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010342f:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103432:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103437:	76 54                	jbe    f010348d <env_create+0xa4>
	return (physaddr_t)kva - KERNBASE;
f0103439:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010343e:	0f 22 d8             	mov    %eax,%cr3
f0103441:	01 f3                	add    %esi,%ebx
	for(i = 0; i < phnum; i++){
f0103443:	e9 93 00 00 00       	jmp    f01034db <env_create+0xf2>
		panic("env_create failed: create env failed\n");
f0103448:	83 ec 04             	sub    $0x4,%esp
f010344b:	68 d8 7a 10 f0       	push   $0xf0107ad8
f0103450:	68 bf 01 00 00       	push   $0x1bf
f0103455:	68 be 7a 10 f0       	push   $0xf0107abe
f010345a:	e8 e1 cb ff ff       	call   f0100040 <_panic>
		panic("load_icode failed: the binary is not elf\n");
f010345f:	83 ec 04             	sub    $0x4,%esp
f0103462:	68 00 7b 10 f0       	push   $0xf0107b00
f0103467:	68 6b 01 00 00       	push   $0x16b
f010346c:	68 be 7a 10 f0       	push   $0xf0107abe
f0103471:	e8 ca cb ff ff       	call   f0100040 <_panic>
		panic("load_icode failed: the elf can't be executed\n");
f0103476:	83 ec 04             	sub    $0x4,%esp
f0103479:	68 2c 7b 10 f0       	push   $0xf0107b2c
f010347e:	68 6d 01 00 00       	push   $0x16d
f0103483:	68 be 7a 10 f0       	push   $0xf0107abe
f0103488:	e8 b3 cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010348d:	50                   	push   %eax
f010348e:	68 28 68 10 f0       	push   $0xf0106828
f0103493:	68 7f 01 00 00       	push   $0x17f
f0103498:	68 be 7a 10 f0       	push   $0xf0107abe
f010349d:	e8 9e cb ff ff       	call   f0100040 <_panic>
			region_alloc(e, (void*)ph[i].p_va, ph[i].p_memsz);
f01034a2:	8b 53 08             	mov    0x8(%ebx),%edx
f01034a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01034a8:	e8 61 fc ff ff       	call   f010310e <region_alloc>
			memset((void*)ph[i].p_va, 0, ph[i].p_memsz);
f01034ad:	83 ec 04             	sub    $0x4,%esp
f01034b0:	ff 73 14             	pushl  0x14(%ebx)
f01034b3:	6a 00                	push   $0x0
f01034b5:	ff 73 08             	pushl  0x8(%ebx)
f01034b8:	e8 85 26 00 00       	call   f0105b42 <memset>
			memcpy((void*)ph[i].p_va, binary + ph[i].p_offset, ph[i].p_filesz);
f01034bd:	83 c4 0c             	add    $0xc,%esp
f01034c0:	ff 73 10             	pushl  0x10(%ebx)
f01034c3:	89 f0                	mov    %esi,%eax
f01034c5:	03 43 04             	add    0x4(%ebx),%eax
f01034c8:	50                   	push   %eax
f01034c9:	ff 73 08             	pushl  0x8(%ebx)
f01034cc:	e8 23 27 00 00       	call   f0105bf4 <memcpy>
f01034d1:	83 c4 10             	add    $0x10,%esp
	for(i = 0; i < phnum; i++){
f01034d4:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
f01034d8:	83 c3 20             	add    $0x20,%ebx
f01034db:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01034de:	39 55 cc             	cmp    %edx,-0x34(%ebp)
f01034e1:	74 24                	je     f0103507 <env_create+0x11e>
		if(ph[i].p_type == ELF_PROG_LOAD){
f01034e3:	83 3b 01             	cmpl   $0x1,(%ebx)
f01034e6:	75 ec                	jne    f01034d4 <env_create+0xeb>
			if(ph[i].p_memsz < ph[i].p_filesz){
f01034e8:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01034eb:	3b 4b 10             	cmp    0x10(%ebx),%ecx
f01034ee:	73 b2                	jae    f01034a2 <env_create+0xb9>
				panic("load_icode failed: p_memsz < p_filesz.\n");
f01034f0:	83 ec 04             	sub    $0x4,%esp
f01034f3:	68 5c 7b 10 f0       	push   $0xf0107b5c
f01034f8:	68 89 01 00 00       	push   $0x189
f01034fd:	68 be 7a 10 f0       	push   $0xf0107abe
f0103502:	e8 39 cb ff ff       	call   f0100040 <_panic>
	e->env_tf.tf_eip = header->e_entry;
f0103507:	8b 46 18             	mov    0x18(%esi),%eax
f010350a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010350d:	89 41 30             	mov    %eax,0x30(%ecx)
	lcr3(PADDR(kern_pgdir));
f0103510:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103515:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010351a:	76 31                	jbe    f010354d <env_create+0x164>
	return (physaddr_t)kva - KERNBASE;
f010351c:	05 00 00 00 10       	add    $0x10000000,%eax
f0103521:	0f 22 d8             	mov    %eax,%cr3
	region_alloc(e, (void*)(USTACKTOP - PGSIZE), PGSIZE);
f0103524:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103529:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f010352e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103531:	e8 d8 fb ff ff       	call   f010310e <region_alloc>

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	if(type == ENV_TYPE_FS){
f0103536:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f010353a:	74 26                	je     f0103562 <env_create+0x179>
		env->env_tf.tf_eflags |= FL_IOPL_MASK;
	}

	// sets its env_type.
	env->env_type = type;
f010353c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010353f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103542:	89 50 50             	mov    %edx,0x50(%eax)
}
f0103545:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103548:	5b                   	pop    %ebx
f0103549:	5e                   	pop    %esi
f010354a:	5f                   	pop    %edi
f010354b:	5d                   	pop    %ebp
f010354c:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010354d:	50                   	push   %eax
f010354e:	68 28 68 10 f0       	push   $0xf0106828
f0103553:	68 a5 01 00 00       	push   $0x1a5
f0103558:	68 be 7a 10 f0       	push   $0xf0107abe
f010355d:	e8 de ca ff ff       	call   f0100040 <_panic>
		env->env_tf.tf_eflags |= FL_IOPL_MASK;
f0103562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103565:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
f010356c:	eb ce                	jmp    f010353c <env_create+0x153>

f010356e <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f010356e:	f3 0f 1e fb          	endbr32 
f0103572:	55                   	push   %ebp
f0103573:	89 e5                	mov    %esp,%ebp
f0103575:	57                   	push   %edi
f0103576:	56                   	push   %esi
f0103577:	53                   	push   %ebx
f0103578:	83 ec 1c             	sub    $0x1c,%esp
f010357b:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f010357e:	e8 df 2b 00 00       	call   f0106162 <cpunum>
f0103583:	6b c0 74             	imul   $0x74,%eax,%eax
f0103586:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f010358d:	39 b8 28 80 21 f0    	cmp    %edi,-0xfde7fd8(%eax)
f0103593:	0f 85 b3 00 00 00    	jne    f010364c <env_free+0xde>
		lcr3(PADDR(kern_pgdir));
f0103599:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f010359e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035a3:	76 14                	jbe    f01035b9 <env_free+0x4b>
	return (physaddr_t)kva - KERNBASE;
f01035a5:	05 00 00 00 10       	add    $0x10000000,%eax
f01035aa:	0f 22 d8             	mov    %eax,%cr3
}
f01035ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01035b4:	e9 93 00 00 00       	jmp    f010364c <env_free+0xde>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01035b9:	50                   	push   %eax
f01035ba:	68 28 68 10 f0       	push   $0xf0106828
f01035bf:	68 dd 01 00 00       	push   $0x1dd
f01035c4:	68 be 7a 10 f0       	push   $0xf0107abe
f01035c9:	e8 72 ca ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01035ce:	56                   	push   %esi
f01035cf:	68 04 68 10 f0       	push   $0xf0106804
f01035d4:	68 ec 01 00 00       	push   $0x1ec
f01035d9:	68 be 7a 10 f0       	push   $0xf0107abe
f01035de:	e8 5d ca ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01035e3:	83 ec 08             	sub    $0x8,%esp
f01035e6:	89 d8                	mov    %ebx,%eax
f01035e8:	c1 e0 0c             	shl    $0xc,%eax
f01035eb:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01035ee:	50                   	push   %eax
f01035ef:	ff 77 60             	pushl  0x60(%edi)
f01035f2:	e8 e9 dc ff ff       	call   f01012e0 <page_remove>
f01035f7:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01035fa:	83 c3 01             	add    $0x1,%ebx
f01035fd:	83 c6 04             	add    $0x4,%esi
f0103600:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103606:	74 07                	je     f010360f <env_free+0xa1>
			if (pt[pteno] & PTE_P)
f0103608:	f6 06 01             	testb  $0x1,(%esi)
f010360b:	74 ed                	je     f01035fa <env_free+0x8c>
f010360d:	eb d4                	jmp    f01035e3 <env_free+0x75>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f010360f:	8b 47 60             	mov    0x60(%edi),%eax
f0103612:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103615:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f010361c:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010361f:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0103625:	73 65                	jae    f010368c <env_free+0x11e>
		page_decref(pa2page(pa));
f0103627:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010362a:	a1 90 7e 21 f0       	mov    0xf0217e90,%eax
f010362f:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103632:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103635:	50                   	push   %eax
f0103636:	e8 94 da ff ff       	call   f01010cf <page_decref>
f010363b:	83 c4 10             	add    $0x10,%esp
f010363e:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103642:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103645:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f010364a:	74 54                	je     f01036a0 <env_free+0x132>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f010364c:	8b 47 60             	mov    0x60(%edi),%eax
f010364f:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103652:	8b 04 10             	mov    (%eax,%edx,1),%eax
f0103655:	a8 01                	test   $0x1,%al
f0103657:	74 e5                	je     f010363e <env_free+0xd0>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103659:	89 c6                	mov    %eax,%esi
f010365b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103661:	c1 e8 0c             	shr    $0xc,%eax
f0103664:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103667:	39 05 88 7e 21 f0    	cmp    %eax,0xf0217e88
f010366d:	0f 86 5b ff ff ff    	jbe    f01035ce <env_free+0x60>
	return (void *)(pa + KERNBASE);
f0103673:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103679:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010367c:	c1 e0 14             	shl    $0x14,%eax
f010367f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103682:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103687:	e9 7c ff ff ff       	jmp    f0103608 <env_free+0x9a>
		panic("pa2page called with invalid pa");
f010368c:	83 ec 04             	sub    $0x4,%esp
f010368f:	68 3c 72 10 f0       	push   $0xf010723c
f0103694:	6a 51                	push   $0x51
f0103696:	68 a2 6d 10 f0       	push   $0xf0106da2
f010369b:	e8 a0 c9 ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01036a0:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f01036a3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01036a8:	76 49                	jbe    f01036f3 <env_free+0x185>
	e->env_pgdir = 0;
f01036aa:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f01036b1:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01036b6:	c1 e8 0c             	shr    $0xc,%eax
f01036b9:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f01036bf:	73 47                	jae    f0103708 <env_free+0x19a>
	page_decref(pa2page(pa));
f01036c1:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01036c4:	8b 15 90 7e 21 f0    	mov    0xf0217e90,%edx
f01036ca:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01036cd:	50                   	push   %eax
f01036ce:	e8 fc d9 ff ff       	call   f01010cf <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01036d3:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f01036da:	a1 4c 72 21 f0       	mov    0xf021724c,%eax
f01036df:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f01036e2:	89 3d 4c 72 21 f0    	mov    %edi,0xf021724c
}
f01036e8:	83 c4 10             	add    $0x10,%esp
f01036eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01036ee:	5b                   	pop    %ebx
f01036ef:	5e                   	pop    %esi
f01036f0:	5f                   	pop    %edi
f01036f1:	5d                   	pop    %ebp
f01036f2:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01036f3:	50                   	push   %eax
f01036f4:	68 28 68 10 f0       	push   $0xf0106828
f01036f9:	68 fa 01 00 00       	push   $0x1fa
f01036fe:	68 be 7a 10 f0       	push   $0xf0107abe
f0103703:	e8 38 c9 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f0103708:	83 ec 04             	sub    $0x4,%esp
f010370b:	68 3c 72 10 f0       	push   $0xf010723c
f0103710:	6a 51                	push   $0x51
f0103712:	68 a2 6d 10 f0       	push   $0xf0106da2
f0103717:	e8 24 c9 ff ff       	call   f0100040 <_panic>

f010371c <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f010371c:	f3 0f 1e fb          	endbr32 
f0103720:	55                   	push   %ebp
f0103721:	89 e5                	mov    %esp,%ebp
f0103723:	53                   	push   %ebx
f0103724:	83 ec 04             	sub    $0x4,%esp
f0103727:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010372a:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f010372e:	74 21                	je     f0103751 <env_destroy+0x35>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103730:	83 ec 0c             	sub    $0xc,%esp
f0103733:	53                   	push   %ebx
f0103734:	e8 35 fe ff ff       	call   f010356e <env_free>

	if (curenv == e) {
f0103739:	e8 24 2a 00 00       	call   f0106162 <cpunum>
f010373e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103741:	83 c4 10             	add    $0x10,%esp
f0103744:	39 98 28 80 21 f0    	cmp    %ebx,-0xfde7fd8(%eax)
f010374a:	74 1e                	je     f010376a <env_destroy+0x4e>
		curenv = NULL;
		sched_yield();
	}
}
f010374c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010374f:	c9                   	leave  
f0103750:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103751:	e8 0c 2a 00 00       	call   f0106162 <cpunum>
f0103756:	6b c0 74             	imul   $0x74,%eax,%eax
f0103759:	39 98 28 80 21 f0    	cmp    %ebx,-0xfde7fd8(%eax)
f010375f:	74 cf                	je     f0103730 <env_destroy+0x14>
		e->env_status = ENV_DYING;
f0103761:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103768:	eb e2                	jmp    f010374c <env_destroy+0x30>
		curenv = NULL;
f010376a:	e8 f3 29 00 00       	call   f0106162 <cpunum>
f010376f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103772:	c7 80 28 80 21 f0 00 	movl   $0x0,-0xfde7fd8(%eax)
f0103779:	00 00 00 
		sched_yield();
f010377c:	e8 d8 10 00 00       	call   f0104859 <sched_yield>

f0103781 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103781:	f3 0f 1e fb          	endbr32 
f0103785:	55                   	push   %ebp
f0103786:	89 e5                	mov    %esp,%ebp
f0103788:	53                   	push   %ebx
f0103789:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f010378c:	e8 d1 29 00 00       	call   f0106162 <cpunum>
f0103791:	6b c0 74             	imul   $0x74,%eax,%eax
f0103794:	8b 98 28 80 21 f0    	mov    -0xfde7fd8(%eax),%ebx
f010379a:	e8 c3 29 00 00       	call   f0106162 <cpunum>
f010379f:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f01037a2:	8b 65 08             	mov    0x8(%ebp),%esp
f01037a5:	61                   	popa   
f01037a6:	07                   	pop    %es
f01037a7:	1f                   	pop    %ds
f01037a8:	83 c4 08             	add    $0x8,%esp
f01037ab:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f01037ac:	83 ec 04             	sub    $0x4,%esp
f01037af:	68 c9 7a 10 f0       	push   $0xf0107ac9
f01037b4:	68 31 02 00 00       	push   $0x231
f01037b9:	68 be 7a 10 f0       	push   $0xf0107abe
f01037be:	e8 7d c8 ff ff       	call   f0100040 <_panic>

f01037c3 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01037c3:	f3 0f 1e fb          	endbr32 
f01037c7:	55                   	push   %ebp
f01037c8:	89 e5                	mov    %esp,%ebp
f01037ca:	53                   	push   %ebx
f01037cb:	83 ec 04             	sub    $0x4,%esp
f01037ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != NULL && curenv->env_status == ENV_RUNNING){
f01037d1:	e8 8c 29 00 00       	call   f0106162 <cpunum>
f01037d6:	6b c0 74             	imul   $0x74,%eax,%eax
f01037d9:	83 b8 28 80 21 f0 00 	cmpl   $0x0,-0xfde7fd8(%eax)
f01037e0:	74 14                	je     f01037f6 <env_run+0x33>
f01037e2:	e8 7b 29 00 00       	call   f0106162 <cpunum>
f01037e7:	6b c0 74             	imul   $0x74,%eax,%eax
f01037ea:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f01037f0:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01037f4:	74 42                	je     f0103838 <env_run+0x75>
		//但是查看了好多人的实现都没有
		//暂时存疑
		//curenv->env_runs--;
	}

	curenv = e;
f01037f6:	e8 67 29 00 00       	call   f0106162 <cpunum>
f01037fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01037fe:	89 98 28 80 21 f0    	mov    %ebx,-0xfde7fd8(%eax)
	e->env_status = ENV_RUNNING;
f0103804:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
	e->env_runs++;
f010380b:	83 43 58 01          	addl   $0x1,0x58(%ebx)
	lcr3(PADDR(e->env_pgdir));
f010380f:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103812:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103817:	76 36                	jbe    f010384f <env_run+0x8c>
	return (physaddr_t)kva - KERNBASE;
f0103819:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010381e:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103821:	83 ec 0c             	sub    $0xc,%esp
f0103824:	68 c0 33 12 f0       	push   $0xf01233c0
f0103829:	e8 5a 2c 00 00       	call   f0106488 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f010382e:	f3 90                	pause  
	unlock_kernel();
	env_pop_tf(&e->env_tf);
f0103830:	89 1c 24             	mov    %ebx,(%esp)
f0103833:	e8 49 ff ff ff       	call   f0103781 <env_pop_tf>
		curenv->env_status = ENV_RUNNABLE;
f0103838:	e8 25 29 00 00       	call   f0106162 <cpunum>
f010383d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103840:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0103846:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f010384d:	eb a7                	jmp    f01037f6 <env_run+0x33>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010384f:	50                   	push   %eax
f0103850:	68 28 68 10 f0       	push   $0xf0106828
f0103855:	68 5a 02 00 00       	push   $0x25a
f010385a:	68 be 7a 10 f0       	push   $0xf0107abe
f010385f:	e8 dc c7 ff ff       	call   f0100040 <_panic>

f0103864 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103864:	f3 0f 1e fb          	endbr32 
f0103868:	55                   	push   %ebp
f0103869:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010386b:	8b 45 08             	mov    0x8(%ebp),%eax
f010386e:	ba 70 00 00 00       	mov    $0x70,%edx
f0103873:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103874:	ba 71 00 00 00       	mov    $0x71,%edx
f0103879:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f010387a:	0f b6 c0             	movzbl %al,%eax
}
f010387d:	5d                   	pop    %ebp
f010387e:	c3                   	ret    

f010387f <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f010387f:	f3 0f 1e fb          	endbr32 
f0103883:	55                   	push   %ebp
f0103884:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103886:	8b 45 08             	mov    0x8(%ebp),%eax
f0103889:	ba 70 00 00 00       	mov    $0x70,%edx
f010388e:	ee                   	out    %al,(%dx)
f010388f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103892:	ba 71 00 00 00       	mov    $0x71,%edx
f0103897:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103898:	5d                   	pop    %ebp
f0103899:	c3                   	ret    

f010389a <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f010389a:	f3 0f 1e fb          	endbr32 
f010389e:	55                   	push   %ebp
f010389f:	89 e5                	mov    %esp,%ebp
f01038a1:	56                   	push   %esi
f01038a2:	53                   	push   %ebx
f01038a3:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f01038a6:	66 a3 a8 33 12 f0    	mov    %ax,0xf01233a8
	if (!didinit)
f01038ac:	80 3d 50 72 21 f0 00 	cmpb   $0x0,0xf0217250
f01038b3:	75 07                	jne    f01038bc <irq_setmask_8259A+0x22>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f01038b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01038b8:	5b                   	pop    %ebx
f01038b9:	5e                   	pop    %esi
f01038ba:	5d                   	pop    %ebp
f01038bb:	c3                   	ret    
f01038bc:	89 c6                	mov    %eax,%esi
f01038be:	ba 21 00 00 00       	mov    $0x21,%edx
f01038c3:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f01038c4:	66 c1 e8 08          	shr    $0x8,%ax
f01038c8:	ba a1 00 00 00       	mov    $0xa1,%edx
f01038cd:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01038ce:	83 ec 0c             	sub    $0xc,%esp
f01038d1:	68 84 7b 10 f0       	push   $0xf0107b84
f01038d6:	e8 2c 01 00 00       	call   f0103a07 <cprintf>
f01038db:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01038de:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01038e3:	0f b7 f6             	movzwl %si,%esi
f01038e6:	f7 d6                	not    %esi
f01038e8:	eb 19                	jmp    f0103903 <irq_setmask_8259A+0x69>
			cprintf(" %d", i);
f01038ea:	83 ec 08             	sub    $0x8,%esp
f01038ed:	53                   	push   %ebx
f01038ee:	68 5f 80 10 f0       	push   $0xf010805f
f01038f3:	e8 0f 01 00 00       	call   f0103a07 <cprintf>
f01038f8:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01038fb:	83 c3 01             	add    $0x1,%ebx
f01038fe:	83 fb 10             	cmp    $0x10,%ebx
f0103901:	74 07                	je     f010390a <irq_setmask_8259A+0x70>
		if (~mask & (1<<i))
f0103903:	0f a3 de             	bt     %ebx,%esi
f0103906:	73 f3                	jae    f01038fb <irq_setmask_8259A+0x61>
f0103908:	eb e0                	jmp    f01038ea <irq_setmask_8259A+0x50>
	cprintf("\n");
f010390a:	83 ec 0c             	sub    $0xc,%esp
f010390d:	68 76 70 10 f0       	push   $0xf0107076
f0103912:	e8 f0 00 00 00       	call   f0103a07 <cprintf>
f0103917:	83 c4 10             	add    $0x10,%esp
f010391a:	eb 99                	jmp    f01038b5 <irq_setmask_8259A+0x1b>

f010391c <pic_init>:
{
f010391c:	f3 0f 1e fb          	endbr32 
f0103920:	55                   	push   %ebp
f0103921:	89 e5                	mov    %esp,%ebp
f0103923:	57                   	push   %edi
f0103924:	56                   	push   %esi
f0103925:	53                   	push   %ebx
f0103926:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103929:	c6 05 50 72 21 f0 01 	movb   $0x1,0xf0217250
f0103930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103935:	bb 21 00 00 00       	mov    $0x21,%ebx
f010393a:	89 da                	mov    %ebx,%edx
f010393c:	ee                   	out    %al,(%dx)
f010393d:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103942:	89 ca                	mov    %ecx,%edx
f0103944:	ee                   	out    %al,(%dx)
f0103945:	bf 11 00 00 00       	mov    $0x11,%edi
f010394a:	be 20 00 00 00       	mov    $0x20,%esi
f010394f:	89 f8                	mov    %edi,%eax
f0103951:	89 f2                	mov    %esi,%edx
f0103953:	ee                   	out    %al,(%dx)
f0103954:	b8 20 00 00 00       	mov    $0x20,%eax
f0103959:	89 da                	mov    %ebx,%edx
f010395b:	ee                   	out    %al,(%dx)
f010395c:	b8 04 00 00 00       	mov    $0x4,%eax
f0103961:	ee                   	out    %al,(%dx)
f0103962:	b8 03 00 00 00       	mov    $0x3,%eax
f0103967:	ee                   	out    %al,(%dx)
f0103968:	bb a0 00 00 00       	mov    $0xa0,%ebx
f010396d:	89 f8                	mov    %edi,%eax
f010396f:	89 da                	mov    %ebx,%edx
f0103971:	ee                   	out    %al,(%dx)
f0103972:	b8 28 00 00 00       	mov    $0x28,%eax
f0103977:	89 ca                	mov    %ecx,%edx
f0103979:	ee                   	out    %al,(%dx)
f010397a:	b8 02 00 00 00       	mov    $0x2,%eax
f010397f:	ee                   	out    %al,(%dx)
f0103980:	b8 01 00 00 00       	mov    $0x1,%eax
f0103985:	ee                   	out    %al,(%dx)
f0103986:	bf 68 00 00 00       	mov    $0x68,%edi
f010398b:	89 f8                	mov    %edi,%eax
f010398d:	89 f2                	mov    %esi,%edx
f010398f:	ee                   	out    %al,(%dx)
f0103990:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0103995:	89 c8                	mov    %ecx,%eax
f0103997:	ee                   	out    %al,(%dx)
f0103998:	89 f8                	mov    %edi,%eax
f010399a:	89 da                	mov    %ebx,%edx
f010399c:	ee                   	out    %al,(%dx)
f010399d:	89 c8                	mov    %ecx,%eax
f010399f:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f01039a0:	0f b7 05 a8 33 12 f0 	movzwl 0xf01233a8,%eax
f01039a7:	66 83 f8 ff          	cmp    $0xffff,%ax
f01039ab:	75 08                	jne    f01039b5 <pic_init+0x99>
}
f01039ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01039b0:	5b                   	pop    %ebx
f01039b1:	5e                   	pop    %esi
f01039b2:	5f                   	pop    %edi
f01039b3:	5d                   	pop    %ebp
f01039b4:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f01039b5:	83 ec 0c             	sub    $0xc,%esp
f01039b8:	0f b7 c0             	movzwl %ax,%eax
f01039bb:	50                   	push   %eax
f01039bc:	e8 d9 fe ff ff       	call   f010389a <irq_setmask_8259A>
f01039c1:	83 c4 10             	add    $0x10,%esp
}
f01039c4:	eb e7                	jmp    f01039ad <pic_init+0x91>

f01039c6 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01039c6:	f3 0f 1e fb          	endbr32 
f01039ca:	55                   	push   %ebp
f01039cb:	89 e5                	mov    %esp,%ebp
f01039cd:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f01039d0:	ff 75 08             	pushl  0x8(%ebp)
f01039d3:	e8 d1 cd ff ff       	call   f01007a9 <cputchar>
	*cnt++;
}
f01039d8:	83 c4 10             	add    $0x10,%esp
f01039db:	c9                   	leave  
f01039dc:	c3                   	ret    

f01039dd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01039dd:	f3 0f 1e fb          	endbr32 
f01039e1:	55                   	push   %ebp
f01039e2:	89 e5                	mov    %esp,%ebp
f01039e4:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f01039e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01039ee:	ff 75 0c             	pushl  0xc(%ebp)
f01039f1:	ff 75 08             	pushl  0x8(%ebp)
f01039f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01039f7:	50                   	push   %eax
f01039f8:	68 c6 39 10 f0       	push   $0xf01039c6
f01039fd:	e8 dd 19 00 00       	call   f01053df <vprintfmt>
	return cnt;
}
f0103a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103a05:	c9                   	leave  
f0103a06:	c3                   	ret    

f0103a07 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103a07:	f3 0f 1e fb          	endbr32 
f0103a0b:	55                   	push   %ebp
f0103a0c:	89 e5                	mov    %esp,%ebp
f0103a0e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103a11:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103a14:	50                   	push   %eax
f0103a15:	ff 75 08             	pushl  0x8(%ebp)
f0103a18:	e8 c0 ff ff ff       	call   f01039dd <vcprintf>
	va_end(ap);

	return cnt;
}
f0103a1d:	c9                   	leave  
f0103a1e:	c3                   	ret    

f0103a1f <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103a1f:	f3 0f 1e fb          	endbr32 
f0103a23:	55                   	push   %ebp
f0103a24:	89 e5                	mov    %esp,%ebp
f0103a26:	57                   	push   %edi
f0103a27:	56                   	push   %esi
f0103a28:	53                   	push   %ebx
f0103a29:	83 ec 1c             	sub    $0x1c,%esp
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	int i = cpunum();
f0103a2c:	e8 31 27 00 00       	call   f0106162 <cpunum>
f0103a31:	89 c3                	mov    %eax,%ebx
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	// ts.ts_esp0 = KSTACKTOP;
	// ts.ts_ss0 = GD_KD;
	// ts.ts_iomb = sizeof(struct Taskstate);
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t)percpu_kstacks[i];
f0103a33:	e8 2a 27 00 00       	call   f0106162 <cpunum>
f0103a38:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a3b:	89 da                	mov    %ebx,%edx
f0103a3d:	c1 e2 0f             	shl    $0xf,%edx
f0103a40:	81 c2 00 90 21 f0    	add    $0xf0219000,%edx
f0103a46:	89 90 30 80 21 f0    	mov    %edx,-0xfde7fd0(%eax)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0103a4c:	e8 11 27 00 00       	call   f0106162 <cpunum>
f0103a51:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a54:	66 c7 80 34 80 21 f0 	movw   $0x10,-0xfde7fcc(%eax)
f0103a5b:	10 00 
	thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f0103a5d:	e8 00 27 00 00       	call   f0106162 <cpunum>
f0103a62:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a65:	66 c7 80 92 80 21 f0 	movw   $0x68,-0xfde7f6e(%eax)
f0103a6c:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	// gdt[GD_TSS0 >> 3].sd_s = 0;
	gdt[(GD_TSS0 >> 3) + i] = SEG16(STS_T32A, (uint32_t)(&thiscpu->cpu_ts),
f0103a6e:	8d 7b 05             	lea    0x5(%ebx),%edi
f0103a71:	e8 ec 26 00 00       	call   f0106162 <cpunum>
f0103a76:	89 c6                	mov    %eax,%esi
f0103a78:	e8 e5 26 00 00       	call   f0106162 <cpunum>
f0103a7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103a80:	e8 dd 26 00 00       	call   f0106162 <cpunum>
f0103a85:	66 c7 04 fd 40 33 12 	movw   $0x67,-0xfedccc0(,%edi,8)
f0103a8c:	f0 67 00 
f0103a8f:	6b f6 74             	imul   $0x74,%esi,%esi
f0103a92:	81 c6 2c 80 21 f0    	add    $0xf021802c,%esi
f0103a98:	66 89 34 fd 42 33 12 	mov    %si,-0xfedccbe(,%edi,8)
f0103a9f:	f0 
f0103aa0:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103aa4:	81 c2 2c 80 21 f0    	add    $0xf021802c,%edx
f0103aaa:	c1 ea 10             	shr    $0x10,%edx
f0103aad:	88 14 fd 44 33 12 f0 	mov    %dl,-0xfedccbc(,%edi,8)
f0103ab4:	c6 04 fd 46 33 12 f0 	movb   $0x40,-0xfedccba(,%edi,8)
f0103abb:	40 
f0103abc:	6b c0 74             	imul   $0x74,%eax,%eax
f0103abf:	05 2c 80 21 f0       	add    $0xf021802c,%eax
f0103ac4:	c1 e8 18             	shr    $0x18,%eax
f0103ac7:	88 04 fd 47 33 12 f0 	mov    %al,-0xfedccb9(,%edi,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + i].sd_s = 0;
f0103ace:	c6 04 fd 45 33 12 f0 	movb   $0x89,-0xfedccbb(,%edi,8)
f0103ad5:	89 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + (i << 3));
f0103ad6:	8d 1c dd 28 00 00 00 	lea    0x28(,%ebx,8),%ebx
	asm volatile("ltr %0" : : "r" (sel));
f0103add:	0f 00 db             	ltr    %bx
	asm volatile("lidt (%0)" : : "r" (p));
f0103ae0:	b8 ac 33 12 f0       	mov    $0xf01233ac,%eax
f0103ae5:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f0103ae8:	83 c4 1c             	add    $0x1c,%esp
f0103aeb:	5b                   	pop    %ebx
f0103aec:	5e                   	pop    %esi
f0103aed:	5f                   	pop    %edi
f0103aee:	5d                   	pop    %ebp
f0103aef:	c3                   	ret    

f0103af0 <trap_init>:
{
f0103af0:	f3 0f 1e fb          	endbr32 
f0103af4:	55                   	push   %ebp
f0103af5:	89 e5                	mov    %esp,%ebp
f0103af7:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE], 0, GD_KT, divide_handler, 0);
f0103afa:	b8 82 46 10 f0       	mov    $0xf0104682,%eax
f0103aff:	66 a3 60 72 21 f0    	mov    %ax,0xf0217260
f0103b05:	66 c7 05 62 72 21 f0 	movw   $0x8,0xf0217262
f0103b0c:	08 00 
f0103b0e:	c6 05 64 72 21 f0 00 	movb   $0x0,0xf0217264
f0103b15:	c6 05 65 72 21 f0 8e 	movb   $0x8e,0xf0217265
f0103b1c:	c1 e8 10             	shr    $0x10,%eax
f0103b1f:	66 a3 66 72 21 f0    	mov    %ax,0xf0217266
	SETGATE(idt[T_DEBUG], 0, GD_KT, debug_handler, 0);
f0103b25:	b8 8c 46 10 f0       	mov    $0xf010468c,%eax
f0103b2a:	66 a3 68 72 21 f0    	mov    %ax,0xf0217268
f0103b30:	66 c7 05 6a 72 21 f0 	movw   $0x8,0xf021726a
f0103b37:	08 00 
f0103b39:	c6 05 6c 72 21 f0 00 	movb   $0x0,0xf021726c
f0103b40:	c6 05 6d 72 21 f0 8e 	movb   $0x8e,0xf021726d
f0103b47:	c1 e8 10             	shr    $0x10,%eax
f0103b4a:	66 a3 6e 72 21 f0    	mov    %ax,0xf021726e
	SETGATE(idt[T_NMI], 0, GD_KT, nmi_handler, 0);
f0103b50:	b8 96 46 10 f0       	mov    $0xf0104696,%eax
f0103b55:	66 a3 70 72 21 f0    	mov    %ax,0xf0217270
f0103b5b:	66 c7 05 72 72 21 f0 	movw   $0x8,0xf0217272
f0103b62:	08 00 
f0103b64:	c6 05 74 72 21 f0 00 	movb   $0x0,0xf0217274
f0103b6b:	c6 05 75 72 21 f0 8e 	movb   $0x8e,0xf0217275
f0103b72:	c1 e8 10             	shr    $0x10,%eax
f0103b75:	66 a3 76 72 21 f0    	mov    %ax,0xf0217276
	SETGATE(idt[T_BRKPT], 0, GD_KT, brkpt_handler, 3);
f0103b7b:	b8 a0 46 10 f0       	mov    $0xf01046a0,%eax
f0103b80:	66 a3 78 72 21 f0    	mov    %ax,0xf0217278
f0103b86:	66 c7 05 7a 72 21 f0 	movw   $0x8,0xf021727a
f0103b8d:	08 00 
f0103b8f:	c6 05 7c 72 21 f0 00 	movb   $0x0,0xf021727c
f0103b96:	c6 05 7d 72 21 f0 ee 	movb   $0xee,0xf021727d
f0103b9d:	c1 e8 10             	shr    $0x10,%eax
f0103ba0:	66 a3 7e 72 21 f0    	mov    %ax,0xf021727e
	SETGATE(idt[T_OFLOW], 0, GD_KT, oflow_handler, 0);
f0103ba6:	b8 aa 46 10 f0       	mov    $0xf01046aa,%eax
f0103bab:	66 a3 80 72 21 f0    	mov    %ax,0xf0217280
f0103bb1:	66 c7 05 82 72 21 f0 	movw   $0x8,0xf0217282
f0103bb8:	08 00 
f0103bba:	c6 05 84 72 21 f0 00 	movb   $0x0,0xf0217284
f0103bc1:	c6 05 85 72 21 f0 8e 	movb   $0x8e,0xf0217285
f0103bc8:	c1 e8 10             	shr    $0x10,%eax
f0103bcb:	66 a3 86 72 21 f0    	mov    %ax,0xf0217286
	SETGATE(idt[T_BOUND], 0, GD_KT, bound_handler, 0);
f0103bd1:	b8 b4 46 10 f0       	mov    $0xf01046b4,%eax
f0103bd6:	66 a3 88 72 21 f0    	mov    %ax,0xf0217288
f0103bdc:	66 c7 05 8a 72 21 f0 	movw   $0x8,0xf021728a
f0103be3:	08 00 
f0103be5:	c6 05 8c 72 21 f0 00 	movb   $0x0,0xf021728c
f0103bec:	c6 05 8d 72 21 f0 8e 	movb   $0x8e,0xf021728d
f0103bf3:	c1 e8 10             	shr    $0x10,%eax
f0103bf6:	66 a3 8e 72 21 f0    	mov    %ax,0xf021728e
	SETGATE(idt[T_ILLOP], 0, GD_KT, illop_handler, 0);
f0103bfc:	b8 be 46 10 f0       	mov    $0xf01046be,%eax
f0103c01:	66 a3 90 72 21 f0    	mov    %ax,0xf0217290
f0103c07:	66 c7 05 92 72 21 f0 	movw   $0x8,0xf0217292
f0103c0e:	08 00 
f0103c10:	c6 05 94 72 21 f0 00 	movb   $0x0,0xf0217294
f0103c17:	c6 05 95 72 21 f0 8e 	movb   $0x8e,0xf0217295
f0103c1e:	c1 e8 10             	shr    $0x10,%eax
f0103c21:	66 a3 96 72 21 f0    	mov    %ax,0xf0217296
	SETGATE(idt[T_DEVICE], 0, GD_KT, device_handler, 0);
f0103c27:	b8 c8 46 10 f0       	mov    $0xf01046c8,%eax
f0103c2c:	66 a3 98 72 21 f0    	mov    %ax,0xf0217298
f0103c32:	66 c7 05 9a 72 21 f0 	movw   $0x8,0xf021729a
f0103c39:	08 00 
f0103c3b:	c6 05 9c 72 21 f0 00 	movb   $0x0,0xf021729c
f0103c42:	c6 05 9d 72 21 f0 8e 	movb   $0x8e,0xf021729d
f0103c49:	c1 e8 10             	shr    $0x10,%eax
f0103c4c:	66 a3 9e 72 21 f0    	mov    %ax,0xf021729e
	SETGATE(idt[T_DBLFLT], 0, GD_KT, dblflt_handler, 0);
f0103c52:	b8 d2 46 10 f0       	mov    $0xf01046d2,%eax
f0103c57:	66 a3 a0 72 21 f0    	mov    %ax,0xf02172a0
f0103c5d:	66 c7 05 a2 72 21 f0 	movw   $0x8,0xf02172a2
f0103c64:	08 00 
f0103c66:	c6 05 a4 72 21 f0 00 	movb   $0x0,0xf02172a4
f0103c6d:	c6 05 a5 72 21 f0 8e 	movb   $0x8e,0xf02172a5
f0103c74:	c1 e8 10             	shr    $0x10,%eax
f0103c77:	66 a3 a6 72 21 f0    	mov    %ax,0xf02172a6
	SETGATE(idt[T_TSS], 0, GD_KT, tss_handler, 0);
f0103c7d:	b8 da 46 10 f0       	mov    $0xf01046da,%eax
f0103c82:	66 a3 b0 72 21 f0    	mov    %ax,0xf02172b0
f0103c88:	66 c7 05 b2 72 21 f0 	movw   $0x8,0xf02172b2
f0103c8f:	08 00 
f0103c91:	c6 05 b4 72 21 f0 00 	movb   $0x0,0xf02172b4
f0103c98:	c6 05 b5 72 21 f0 8e 	movb   $0x8e,0xf02172b5
f0103c9f:	c1 e8 10             	shr    $0x10,%eax
f0103ca2:	66 a3 b6 72 21 f0    	mov    %ax,0xf02172b6
	SETGATE(idt[T_SEGNP], 0, GD_KT, segnp_handler, 0);
f0103ca8:	b8 e2 46 10 f0       	mov    $0xf01046e2,%eax
f0103cad:	66 a3 b8 72 21 f0    	mov    %ax,0xf02172b8
f0103cb3:	66 c7 05 ba 72 21 f0 	movw   $0x8,0xf02172ba
f0103cba:	08 00 
f0103cbc:	c6 05 bc 72 21 f0 00 	movb   $0x0,0xf02172bc
f0103cc3:	c6 05 bd 72 21 f0 8e 	movb   $0x8e,0xf02172bd
f0103cca:	c1 e8 10             	shr    $0x10,%eax
f0103ccd:	66 a3 be 72 21 f0    	mov    %ax,0xf02172be
	SETGATE(idt[T_STACK], 0, GD_KT, stack_handler, 0);
f0103cd3:	b8 ea 46 10 f0       	mov    $0xf01046ea,%eax
f0103cd8:	66 a3 c0 72 21 f0    	mov    %ax,0xf02172c0
f0103cde:	66 c7 05 c2 72 21 f0 	movw   $0x8,0xf02172c2
f0103ce5:	08 00 
f0103ce7:	c6 05 c4 72 21 f0 00 	movb   $0x0,0xf02172c4
f0103cee:	c6 05 c5 72 21 f0 8e 	movb   $0x8e,0xf02172c5
f0103cf5:	c1 e8 10             	shr    $0x10,%eax
f0103cf8:	66 a3 c6 72 21 f0    	mov    %ax,0xf02172c6
	SETGATE(idt[T_GPFLT], 0, GD_KT, gpflt_handler, 0);
f0103cfe:	b8 f2 46 10 f0       	mov    $0xf01046f2,%eax
f0103d03:	66 a3 c8 72 21 f0    	mov    %ax,0xf02172c8
f0103d09:	66 c7 05 ca 72 21 f0 	movw   $0x8,0xf02172ca
f0103d10:	08 00 
f0103d12:	c6 05 cc 72 21 f0 00 	movb   $0x0,0xf02172cc
f0103d19:	c6 05 cd 72 21 f0 8e 	movb   $0x8e,0xf02172cd
f0103d20:	c1 e8 10             	shr    $0x10,%eax
f0103d23:	66 a3 ce 72 21 f0    	mov    %ax,0xf02172ce
	SETGATE(idt[T_PGFLT], 0, GD_KT, pgflt_handler, 0);
f0103d29:	b8 fa 46 10 f0       	mov    $0xf01046fa,%eax
f0103d2e:	66 a3 d0 72 21 f0    	mov    %ax,0xf02172d0
f0103d34:	66 c7 05 d2 72 21 f0 	movw   $0x8,0xf02172d2
f0103d3b:	08 00 
f0103d3d:	c6 05 d4 72 21 f0 00 	movb   $0x0,0xf02172d4
f0103d44:	c6 05 d5 72 21 f0 8e 	movb   $0x8e,0xf02172d5
f0103d4b:	c1 e8 10             	shr    $0x10,%eax
f0103d4e:	66 a3 d6 72 21 f0    	mov    %ax,0xf02172d6
	SETGATE(idt[T_FPERR], 0, GD_KT, fperr_handler, 0);
f0103d54:	b8 fe 46 10 f0       	mov    $0xf01046fe,%eax
f0103d59:	66 a3 e0 72 21 f0    	mov    %ax,0xf02172e0
f0103d5f:	66 c7 05 e2 72 21 f0 	movw   $0x8,0xf02172e2
f0103d66:	08 00 
f0103d68:	c6 05 e4 72 21 f0 00 	movb   $0x0,0xf02172e4
f0103d6f:	c6 05 e5 72 21 f0 8e 	movb   $0x8e,0xf02172e5
f0103d76:	c1 e8 10             	shr    $0x10,%eax
f0103d79:	66 a3 e6 72 21 f0    	mov    %ax,0xf02172e6
	SETGATE(idt[T_ALIGN], 0, GD_KT, align_handler, 0);
f0103d7f:	b8 04 47 10 f0       	mov    $0xf0104704,%eax
f0103d84:	66 a3 e8 72 21 f0    	mov    %ax,0xf02172e8
f0103d8a:	66 c7 05 ea 72 21 f0 	movw   $0x8,0xf02172ea
f0103d91:	08 00 
f0103d93:	c6 05 ec 72 21 f0 00 	movb   $0x0,0xf02172ec
f0103d9a:	c6 05 ed 72 21 f0 8e 	movb   $0x8e,0xf02172ed
f0103da1:	c1 e8 10             	shr    $0x10,%eax
f0103da4:	66 a3 ee 72 21 f0    	mov    %ax,0xf02172ee
	SETGATE(idt[T_MCHK], 0, GD_KT, mchk_handler, 0);
f0103daa:	b8 08 47 10 f0       	mov    $0xf0104708,%eax
f0103daf:	66 a3 f0 72 21 f0    	mov    %ax,0xf02172f0
f0103db5:	66 c7 05 f2 72 21 f0 	movw   $0x8,0xf02172f2
f0103dbc:	08 00 
f0103dbe:	c6 05 f4 72 21 f0 00 	movb   $0x0,0xf02172f4
f0103dc5:	c6 05 f5 72 21 f0 8e 	movb   $0x8e,0xf02172f5
f0103dcc:	c1 e8 10             	shr    $0x10,%eax
f0103dcf:	66 a3 f6 72 21 f0    	mov    %ax,0xf02172f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, simderr_handler, 0);
f0103dd5:	b8 0e 47 10 f0       	mov    $0xf010470e,%eax
f0103dda:	66 a3 f8 72 21 f0    	mov    %ax,0xf02172f8
f0103de0:	66 c7 05 fa 72 21 f0 	movw   $0x8,0xf02172fa
f0103de7:	08 00 
f0103de9:	c6 05 fc 72 21 f0 00 	movb   $0x0,0xf02172fc
f0103df0:	c6 05 fd 72 21 f0 8e 	movb   $0x8e,0xf02172fd
f0103df7:	c1 e8 10             	shr    $0x10,%eax
f0103dfa:	66 a3 fe 72 21 f0    	mov    %ax,0xf02172fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, syscall_handler, 3);
f0103e00:	b8 14 47 10 f0       	mov    $0xf0104714,%eax
f0103e05:	66 a3 e0 73 21 f0    	mov    %ax,0xf02173e0
f0103e0b:	66 c7 05 e2 73 21 f0 	movw   $0x8,0xf02173e2
f0103e12:	08 00 
f0103e14:	c6 05 e4 73 21 f0 00 	movb   $0x0,0xf02173e4
f0103e1b:	c6 05 e5 73 21 f0 ee 	movb   $0xee,0xf02173e5
f0103e22:	c1 e8 10             	shr    $0x10,%eax
f0103e25:	66 a3 e6 73 21 f0    	mov    %ax,0xf02173e6
	SETGATE(idt[IRQ_OFFSET + 0], 0, GD_KT, irq_0_handler, 0);
f0103e2b:	b8 1a 47 10 f0       	mov    $0xf010471a,%eax
f0103e30:	66 a3 60 73 21 f0    	mov    %ax,0xf0217360
f0103e36:	66 c7 05 62 73 21 f0 	movw   $0x8,0xf0217362
f0103e3d:	08 00 
f0103e3f:	c6 05 64 73 21 f0 00 	movb   $0x0,0xf0217364
f0103e46:	c6 05 65 73 21 f0 8e 	movb   $0x8e,0xf0217365
f0103e4d:	c1 e8 10             	shr    $0x10,%eax
f0103e50:	66 a3 66 73 21 f0    	mov    %ax,0xf0217366
	SETGATE(idt[IRQ_OFFSET + 1], 0, GD_KT, irq_1_handler, 0);
f0103e56:	b8 20 47 10 f0       	mov    $0xf0104720,%eax
f0103e5b:	66 a3 68 73 21 f0    	mov    %ax,0xf0217368
f0103e61:	66 c7 05 6a 73 21 f0 	movw   $0x8,0xf021736a
f0103e68:	08 00 
f0103e6a:	c6 05 6c 73 21 f0 00 	movb   $0x0,0xf021736c
f0103e71:	c6 05 6d 73 21 f0 8e 	movb   $0x8e,0xf021736d
f0103e78:	c1 e8 10             	shr    $0x10,%eax
f0103e7b:	66 a3 6e 73 21 f0    	mov    %ax,0xf021736e
	SETGATE(idt[IRQ_OFFSET + 2], 0, GD_KT, irq_2_handler, 0);
f0103e81:	b8 26 47 10 f0       	mov    $0xf0104726,%eax
f0103e86:	66 a3 70 73 21 f0    	mov    %ax,0xf0217370
f0103e8c:	66 c7 05 72 73 21 f0 	movw   $0x8,0xf0217372
f0103e93:	08 00 
f0103e95:	c6 05 74 73 21 f0 00 	movb   $0x0,0xf0217374
f0103e9c:	c6 05 75 73 21 f0 8e 	movb   $0x8e,0xf0217375
f0103ea3:	c1 e8 10             	shr    $0x10,%eax
f0103ea6:	66 a3 76 73 21 f0    	mov    %ax,0xf0217376
	SETGATE(idt[IRQ_OFFSET + 3], 0, GD_KT, irq_3_handler, 0);
f0103eac:	b8 2c 47 10 f0       	mov    $0xf010472c,%eax
f0103eb1:	66 a3 78 73 21 f0    	mov    %ax,0xf0217378
f0103eb7:	66 c7 05 7a 73 21 f0 	movw   $0x8,0xf021737a
f0103ebe:	08 00 
f0103ec0:	c6 05 7c 73 21 f0 00 	movb   $0x0,0xf021737c
f0103ec7:	c6 05 7d 73 21 f0 8e 	movb   $0x8e,0xf021737d
f0103ece:	c1 e8 10             	shr    $0x10,%eax
f0103ed1:	66 a3 7e 73 21 f0    	mov    %ax,0xf021737e
	SETGATE(idt[IRQ_OFFSET + 4], 0, GD_KT, irq_4_handler, 0);
f0103ed7:	b8 32 47 10 f0       	mov    $0xf0104732,%eax
f0103edc:	66 a3 80 73 21 f0    	mov    %ax,0xf0217380
f0103ee2:	66 c7 05 82 73 21 f0 	movw   $0x8,0xf0217382
f0103ee9:	08 00 
f0103eeb:	c6 05 84 73 21 f0 00 	movb   $0x0,0xf0217384
f0103ef2:	c6 05 85 73 21 f0 8e 	movb   $0x8e,0xf0217385
f0103ef9:	c1 e8 10             	shr    $0x10,%eax
f0103efc:	66 a3 86 73 21 f0    	mov    %ax,0xf0217386
	SETGATE(idt[IRQ_OFFSET + 5], 0, GD_KT, irq_5_handler, 0);
f0103f02:	b8 38 47 10 f0       	mov    $0xf0104738,%eax
f0103f07:	66 a3 88 73 21 f0    	mov    %ax,0xf0217388
f0103f0d:	66 c7 05 8a 73 21 f0 	movw   $0x8,0xf021738a
f0103f14:	08 00 
f0103f16:	c6 05 8c 73 21 f0 00 	movb   $0x0,0xf021738c
f0103f1d:	c6 05 8d 73 21 f0 8e 	movb   $0x8e,0xf021738d
f0103f24:	c1 e8 10             	shr    $0x10,%eax
f0103f27:	66 a3 8e 73 21 f0    	mov    %ax,0xf021738e
	SETGATE(idt[IRQ_OFFSET + 6], 0, GD_KT, irq_6_handler, 0);
f0103f2d:	b8 3e 47 10 f0       	mov    $0xf010473e,%eax
f0103f32:	66 a3 90 73 21 f0    	mov    %ax,0xf0217390
f0103f38:	66 c7 05 92 73 21 f0 	movw   $0x8,0xf0217392
f0103f3f:	08 00 
f0103f41:	c6 05 94 73 21 f0 00 	movb   $0x0,0xf0217394
f0103f48:	c6 05 95 73 21 f0 8e 	movb   $0x8e,0xf0217395
f0103f4f:	c1 e8 10             	shr    $0x10,%eax
f0103f52:	66 a3 96 73 21 f0    	mov    %ax,0xf0217396
	SETGATE(idt[IRQ_OFFSET + 7], 0, GD_KT, irq_7_handler, 0);
f0103f58:	b8 44 47 10 f0       	mov    $0xf0104744,%eax
f0103f5d:	66 a3 98 73 21 f0    	mov    %ax,0xf0217398
f0103f63:	66 c7 05 9a 73 21 f0 	movw   $0x8,0xf021739a
f0103f6a:	08 00 
f0103f6c:	c6 05 9c 73 21 f0 00 	movb   $0x0,0xf021739c
f0103f73:	c6 05 9d 73 21 f0 8e 	movb   $0x8e,0xf021739d
f0103f7a:	c1 e8 10             	shr    $0x10,%eax
f0103f7d:	66 a3 9e 73 21 f0    	mov    %ax,0xf021739e
	SETGATE(idt[IRQ_OFFSET + 8], 0, GD_KT, irq_8_handler, 0);
f0103f83:	b8 4a 47 10 f0       	mov    $0xf010474a,%eax
f0103f88:	66 a3 a0 73 21 f0    	mov    %ax,0xf02173a0
f0103f8e:	66 c7 05 a2 73 21 f0 	movw   $0x8,0xf02173a2
f0103f95:	08 00 
f0103f97:	c6 05 a4 73 21 f0 00 	movb   $0x0,0xf02173a4
f0103f9e:	c6 05 a5 73 21 f0 8e 	movb   $0x8e,0xf02173a5
f0103fa5:	c1 e8 10             	shr    $0x10,%eax
f0103fa8:	66 a3 a6 73 21 f0    	mov    %ax,0xf02173a6
	SETGATE(idt[IRQ_OFFSET + 9], 0, GD_KT, irq_9_handler, 0);
f0103fae:	b8 50 47 10 f0       	mov    $0xf0104750,%eax
f0103fb3:	66 a3 a8 73 21 f0    	mov    %ax,0xf02173a8
f0103fb9:	66 c7 05 aa 73 21 f0 	movw   $0x8,0xf02173aa
f0103fc0:	08 00 
f0103fc2:	c6 05 ac 73 21 f0 00 	movb   $0x0,0xf02173ac
f0103fc9:	c6 05 ad 73 21 f0 8e 	movb   $0x8e,0xf02173ad
f0103fd0:	c1 e8 10             	shr    $0x10,%eax
f0103fd3:	66 a3 ae 73 21 f0    	mov    %ax,0xf02173ae
	SETGATE(idt[IRQ_OFFSET + 10], 0, GD_KT, irq_10_handler, 0);
f0103fd9:	b8 56 47 10 f0       	mov    $0xf0104756,%eax
f0103fde:	66 a3 b0 73 21 f0    	mov    %ax,0xf02173b0
f0103fe4:	66 c7 05 b2 73 21 f0 	movw   $0x8,0xf02173b2
f0103feb:	08 00 
f0103fed:	c6 05 b4 73 21 f0 00 	movb   $0x0,0xf02173b4
f0103ff4:	c6 05 b5 73 21 f0 8e 	movb   $0x8e,0xf02173b5
f0103ffb:	c1 e8 10             	shr    $0x10,%eax
f0103ffe:	66 a3 b6 73 21 f0    	mov    %ax,0xf02173b6
	SETGATE(idt[IRQ_OFFSET + 11], 0, GD_KT, irq_11_handler, 0);
f0104004:	b8 5c 47 10 f0       	mov    $0xf010475c,%eax
f0104009:	66 a3 b8 73 21 f0    	mov    %ax,0xf02173b8
f010400f:	66 c7 05 ba 73 21 f0 	movw   $0x8,0xf02173ba
f0104016:	08 00 
f0104018:	c6 05 bc 73 21 f0 00 	movb   $0x0,0xf02173bc
f010401f:	c6 05 bd 73 21 f0 8e 	movb   $0x8e,0xf02173bd
f0104026:	c1 e8 10             	shr    $0x10,%eax
f0104029:	66 a3 be 73 21 f0    	mov    %ax,0xf02173be
	SETGATE(idt[IRQ_OFFSET + 12], 0, GD_KT, irq_12_handler, 0);
f010402f:	b8 62 47 10 f0       	mov    $0xf0104762,%eax
f0104034:	66 a3 c0 73 21 f0    	mov    %ax,0xf02173c0
f010403a:	66 c7 05 c2 73 21 f0 	movw   $0x8,0xf02173c2
f0104041:	08 00 
f0104043:	c6 05 c4 73 21 f0 00 	movb   $0x0,0xf02173c4
f010404a:	c6 05 c5 73 21 f0 8e 	movb   $0x8e,0xf02173c5
f0104051:	c1 e8 10             	shr    $0x10,%eax
f0104054:	66 a3 c6 73 21 f0    	mov    %ax,0xf02173c6
	SETGATE(idt[IRQ_OFFSET + 13], 0, GD_KT, irq_13_handler, 0);
f010405a:	b8 68 47 10 f0       	mov    $0xf0104768,%eax
f010405f:	66 a3 c8 73 21 f0    	mov    %ax,0xf02173c8
f0104065:	66 c7 05 ca 73 21 f0 	movw   $0x8,0xf02173ca
f010406c:	08 00 
f010406e:	c6 05 cc 73 21 f0 00 	movb   $0x0,0xf02173cc
f0104075:	c6 05 cd 73 21 f0 8e 	movb   $0x8e,0xf02173cd
f010407c:	c1 e8 10             	shr    $0x10,%eax
f010407f:	66 a3 ce 73 21 f0    	mov    %ax,0xf02173ce
	SETGATE(idt[IRQ_OFFSET + 14], 0, GD_KT, irq_14_handler, 0);
f0104085:	b8 6e 47 10 f0       	mov    $0xf010476e,%eax
f010408a:	66 a3 d0 73 21 f0    	mov    %ax,0xf02173d0
f0104090:	66 c7 05 d2 73 21 f0 	movw   $0x8,0xf02173d2
f0104097:	08 00 
f0104099:	c6 05 d4 73 21 f0 00 	movb   $0x0,0xf02173d4
f01040a0:	c6 05 d5 73 21 f0 8e 	movb   $0x8e,0xf02173d5
f01040a7:	c1 e8 10             	shr    $0x10,%eax
f01040aa:	66 a3 d6 73 21 f0    	mov    %ax,0xf02173d6
	SETGATE(idt[IRQ_OFFSET + 15], 0, GD_KT, irq_15_handler, 0);
f01040b0:	b8 74 47 10 f0       	mov    $0xf0104774,%eax
f01040b5:	66 a3 d8 73 21 f0    	mov    %ax,0xf02173d8
f01040bb:	66 c7 05 da 73 21 f0 	movw   $0x8,0xf02173da
f01040c2:	08 00 
f01040c4:	c6 05 dc 73 21 f0 00 	movb   $0x0,0xf02173dc
f01040cb:	c6 05 dd 73 21 f0 8e 	movb   $0x8e,0xf02173dd
f01040d2:	c1 e8 10             	shr    $0x10,%eax
f01040d5:	66 a3 de 73 21 f0    	mov    %ax,0xf02173de
	trap_init_percpu();
f01040db:	e8 3f f9 ff ff       	call   f0103a1f <trap_init_percpu>
}
f01040e0:	c9                   	leave  
f01040e1:	c3                   	ret    

f01040e2 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f01040e2:	f3 0f 1e fb          	endbr32 
f01040e6:	55                   	push   %ebp
f01040e7:	89 e5                	mov    %esp,%ebp
f01040e9:	53                   	push   %ebx
f01040ea:	83 ec 0c             	sub    $0xc,%esp
f01040ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f01040f0:	ff 33                	pushl  (%ebx)
f01040f2:	68 98 7b 10 f0       	push   $0xf0107b98
f01040f7:	e8 0b f9 ff ff       	call   f0103a07 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f01040fc:	83 c4 08             	add    $0x8,%esp
f01040ff:	ff 73 04             	pushl  0x4(%ebx)
f0104102:	68 a7 7b 10 f0       	push   $0xf0107ba7
f0104107:	e8 fb f8 ff ff       	call   f0103a07 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f010410c:	83 c4 08             	add    $0x8,%esp
f010410f:	ff 73 08             	pushl  0x8(%ebx)
f0104112:	68 b6 7b 10 f0       	push   $0xf0107bb6
f0104117:	e8 eb f8 ff ff       	call   f0103a07 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f010411c:	83 c4 08             	add    $0x8,%esp
f010411f:	ff 73 0c             	pushl  0xc(%ebx)
f0104122:	68 c5 7b 10 f0       	push   $0xf0107bc5
f0104127:	e8 db f8 ff ff       	call   f0103a07 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f010412c:	83 c4 08             	add    $0x8,%esp
f010412f:	ff 73 10             	pushl  0x10(%ebx)
f0104132:	68 d4 7b 10 f0       	push   $0xf0107bd4
f0104137:	e8 cb f8 ff ff       	call   f0103a07 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f010413c:	83 c4 08             	add    $0x8,%esp
f010413f:	ff 73 14             	pushl  0x14(%ebx)
f0104142:	68 e3 7b 10 f0       	push   $0xf0107be3
f0104147:	e8 bb f8 ff ff       	call   f0103a07 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f010414c:	83 c4 08             	add    $0x8,%esp
f010414f:	ff 73 18             	pushl  0x18(%ebx)
f0104152:	68 f2 7b 10 f0       	push   $0xf0107bf2
f0104157:	e8 ab f8 ff ff       	call   f0103a07 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f010415c:	83 c4 08             	add    $0x8,%esp
f010415f:	ff 73 1c             	pushl  0x1c(%ebx)
f0104162:	68 01 7c 10 f0       	push   $0xf0107c01
f0104167:	e8 9b f8 ff ff       	call   f0103a07 <cprintf>
}
f010416c:	83 c4 10             	add    $0x10,%esp
f010416f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104172:	c9                   	leave  
f0104173:	c3                   	ret    

f0104174 <print_trapframe>:
{
f0104174:	f3 0f 1e fb          	endbr32 
f0104178:	55                   	push   %ebp
f0104179:	89 e5                	mov    %esp,%ebp
f010417b:	56                   	push   %esi
f010417c:	53                   	push   %ebx
f010417d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104180:	e8 dd 1f 00 00       	call   f0106162 <cpunum>
f0104185:	83 ec 04             	sub    $0x4,%esp
f0104188:	50                   	push   %eax
f0104189:	53                   	push   %ebx
f010418a:	68 65 7c 10 f0       	push   $0xf0107c65
f010418f:	e8 73 f8 ff ff       	call   f0103a07 <cprintf>
	print_regs(&tf->tf_regs);
f0104194:	89 1c 24             	mov    %ebx,(%esp)
f0104197:	e8 46 ff ff ff       	call   f01040e2 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f010419c:	83 c4 08             	add    $0x8,%esp
f010419f:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f01041a3:	50                   	push   %eax
f01041a4:	68 83 7c 10 f0       	push   $0xf0107c83
f01041a9:	e8 59 f8 ff ff       	call   f0103a07 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01041ae:	83 c4 08             	add    $0x8,%esp
f01041b1:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f01041b5:	50                   	push   %eax
f01041b6:	68 96 7c 10 f0       	push   $0xf0107c96
f01041bb:	e8 47 f8 ff ff       	call   f0103a07 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01041c0:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f01041c3:	83 c4 10             	add    $0x10,%esp
f01041c6:	83 f8 13             	cmp    $0x13,%eax
f01041c9:	0f 86 da 00 00 00    	jbe    f01042a9 <print_trapframe+0x135>
		return "System call";
f01041cf:	ba 10 7c 10 f0       	mov    $0xf0107c10,%edx
	if (trapno == T_SYSCALL)
f01041d4:	83 f8 30             	cmp    $0x30,%eax
f01041d7:	74 13                	je     f01041ec <print_trapframe+0x78>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01041d9:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f01041dc:	83 fa 0f             	cmp    $0xf,%edx
f01041df:	ba 1c 7c 10 f0       	mov    $0xf0107c1c,%edx
f01041e4:	b9 2b 7c 10 f0       	mov    $0xf0107c2b,%ecx
f01041e9:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01041ec:	83 ec 04             	sub    $0x4,%esp
f01041ef:	52                   	push   %edx
f01041f0:	50                   	push   %eax
f01041f1:	68 a9 7c 10 f0       	push   $0xf0107ca9
f01041f6:	e8 0c f8 ff ff       	call   f0103a07 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01041fb:	83 c4 10             	add    $0x10,%esp
f01041fe:	39 1d 60 7a 21 f0    	cmp    %ebx,0xf0217a60
f0104204:	0f 84 ab 00 00 00    	je     f01042b5 <print_trapframe+0x141>
	cprintf("  err  0x%08x", tf->tf_err);
f010420a:	83 ec 08             	sub    $0x8,%esp
f010420d:	ff 73 2c             	pushl  0x2c(%ebx)
f0104210:	68 ca 7c 10 f0       	push   $0xf0107cca
f0104215:	e8 ed f7 ff ff       	call   f0103a07 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f010421a:	83 c4 10             	add    $0x10,%esp
f010421d:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104221:	0f 85 b1 00 00 00    	jne    f01042d8 <print_trapframe+0x164>
			tf->tf_err & 1 ? "protection" : "not-present");
f0104227:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f010422a:	a8 01                	test   $0x1,%al
f010422c:	b9 3e 7c 10 f0       	mov    $0xf0107c3e,%ecx
f0104231:	ba 49 7c 10 f0       	mov    $0xf0107c49,%edx
f0104236:	0f 44 ca             	cmove  %edx,%ecx
f0104239:	a8 02                	test   $0x2,%al
f010423b:	be 55 7c 10 f0       	mov    $0xf0107c55,%esi
f0104240:	ba 5b 7c 10 f0       	mov    $0xf0107c5b,%edx
f0104245:	0f 45 d6             	cmovne %esi,%edx
f0104248:	a8 04                	test   $0x4,%al
f010424a:	b8 60 7c 10 f0       	mov    $0xf0107c60,%eax
f010424f:	be 8e 7d 10 f0       	mov    $0xf0107d8e,%esi
f0104254:	0f 44 c6             	cmove  %esi,%eax
f0104257:	51                   	push   %ecx
f0104258:	52                   	push   %edx
f0104259:	50                   	push   %eax
f010425a:	68 d8 7c 10 f0       	push   $0xf0107cd8
f010425f:	e8 a3 f7 ff ff       	call   f0103a07 <cprintf>
f0104264:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104267:	83 ec 08             	sub    $0x8,%esp
f010426a:	ff 73 30             	pushl  0x30(%ebx)
f010426d:	68 e7 7c 10 f0       	push   $0xf0107ce7
f0104272:	e8 90 f7 ff ff       	call   f0103a07 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104277:	83 c4 08             	add    $0x8,%esp
f010427a:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f010427e:	50                   	push   %eax
f010427f:	68 f6 7c 10 f0       	push   $0xf0107cf6
f0104284:	e8 7e f7 ff ff       	call   f0103a07 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104289:	83 c4 08             	add    $0x8,%esp
f010428c:	ff 73 38             	pushl  0x38(%ebx)
f010428f:	68 09 7d 10 f0       	push   $0xf0107d09
f0104294:	e8 6e f7 ff ff       	call   f0103a07 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104299:	83 c4 10             	add    $0x10,%esp
f010429c:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01042a0:	75 4b                	jne    f01042ed <print_trapframe+0x179>
}
f01042a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01042a5:	5b                   	pop    %ebx
f01042a6:	5e                   	pop    %esi
f01042a7:	5d                   	pop    %ebp
f01042a8:	c3                   	ret    
		return excnames[trapno];
f01042a9:	8b 14 85 40 7f 10 f0 	mov    -0xfef80c0(,%eax,4),%edx
f01042b0:	e9 37 ff ff ff       	jmp    f01041ec <print_trapframe+0x78>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01042b5:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01042b9:	0f 85 4b ff ff ff    	jne    f010420a <print_trapframe+0x96>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f01042bf:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f01042c2:	83 ec 08             	sub    $0x8,%esp
f01042c5:	50                   	push   %eax
f01042c6:	68 bb 7c 10 f0       	push   $0xf0107cbb
f01042cb:	e8 37 f7 ff ff       	call   f0103a07 <cprintf>
f01042d0:	83 c4 10             	add    $0x10,%esp
f01042d3:	e9 32 ff ff ff       	jmp    f010420a <print_trapframe+0x96>
		cprintf("\n");
f01042d8:	83 ec 0c             	sub    $0xc,%esp
f01042db:	68 76 70 10 f0       	push   $0xf0107076
f01042e0:	e8 22 f7 ff ff       	call   f0103a07 <cprintf>
f01042e5:	83 c4 10             	add    $0x10,%esp
f01042e8:	e9 7a ff ff ff       	jmp    f0104267 <print_trapframe+0xf3>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f01042ed:	83 ec 08             	sub    $0x8,%esp
f01042f0:	ff 73 3c             	pushl  0x3c(%ebx)
f01042f3:	68 18 7d 10 f0       	push   $0xf0107d18
f01042f8:	e8 0a f7 ff ff       	call   f0103a07 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f01042fd:	83 c4 08             	add    $0x8,%esp
f0104300:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104304:	50                   	push   %eax
f0104305:	68 27 7d 10 f0       	push   $0xf0107d27
f010430a:	e8 f8 f6 ff ff       	call   f0103a07 <cprintf>
f010430f:	83 c4 10             	add    $0x10,%esp
}
f0104312:	eb 8e                	jmp    f01042a2 <print_trapframe+0x12e>

f0104314 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104314:	f3 0f 1e fb          	endbr32 
f0104318:	55                   	push   %ebp
f0104319:	89 e5                	mov    %esp,%ebp
f010431b:	57                   	push   %edi
f010431c:	56                   	push   %esi
f010431d:	53                   	push   %ebx
f010431e:	83 ec 1c             	sub    $0x1c,%esp
f0104321:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104324:	0f 20 d0             	mov    %cr2,%eax
f0104327:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if((tf->tf_cs & 0x3) == 0)
f010432a:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010432e:	74 5f                	je     f010438f <page_fault_handler+0x7b>

	// LAB 4: Your code here.
	// 判断是否存在page fault的处理函数
	// 如果存在继续执行下去
	// 如果不存在则执行下面已经给定的销毁进程的代码
	if(curenv->env_pgfault_upcall) {
f0104330:	e8 2d 1e 00 00       	call   f0106162 <cpunum>
f0104335:	6b c0 74             	imul   $0x74,%eax,%eax
f0104338:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f010433e:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0104342:	75 62                	jne    f01043a6 <page_fault_handler+0x92>
    	tf->tf_eip = (uint32_t)curenv->env_pgfault_upcall;
		env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104344:	8b 73 30             	mov    0x30(%ebx),%esi
		curenv->env_id, fault_va, tf->tf_eip);
f0104347:	e8 16 1e 00 00       	call   f0106162 <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010434c:	56                   	push   %esi
f010434d:	ff 75 e4             	pushl  -0x1c(%ebp)
		curenv->env_id, fault_va, tf->tf_eip);
f0104350:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104353:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104359:	ff 70 48             	pushl  0x48(%eax)
f010435c:	68 08 7f 10 f0       	push   $0xf0107f08
f0104361:	e8 a1 f6 ff ff       	call   f0103a07 <cprintf>
	print_trapframe(tf);
f0104366:	89 1c 24             	mov    %ebx,(%esp)
f0104369:	e8 06 fe ff ff       	call   f0104174 <print_trapframe>
	env_destroy(curenv);
f010436e:	e8 ef 1d 00 00       	call   f0106162 <cpunum>
f0104373:	83 c4 04             	add    $0x4,%esp
f0104376:	6b c0 74             	imul   $0x74,%eax,%eax
f0104379:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f010437f:	e8 98 f3 ff ff       	call   f010371c <env_destroy>
}
f0104384:	83 c4 10             	add    $0x10,%esp
f0104387:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010438a:	5b                   	pop    %ebx
f010438b:	5e                   	pop    %esi
f010438c:	5f                   	pop    %edi
f010438d:	5d                   	pop    %ebp
f010438e:	c3                   	ret    
		panic("page_fault_handler panic, page fault in kernel\n");
f010438f:	83 ec 04             	sub    $0x4,%esp
f0104392:	68 d8 7e 10 f0       	push   $0xf0107ed8
f0104397:	68 86 01 00 00       	push   $0x186
f010439c:	68 3a 7d 10 f0       	push   $0xf0107d3a
f01043a1:	e8 9a bc ff ff       	call   f0100040 <_panic>
		if(tf->tf_esp > UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP - 1){
f01043a6:	8b 4b 3c             	mov    0x3c(%ebx),%ecx
f01043a9:	8d 81 ff 0f 40 11    	lea    0x11400fff(%ecx),%eax
		uintptr_t exstacktop = UXSTACKTOP;
f01043af:	3d fe 0f 00 00       	cmp    $0xffe,%eax
f01043b4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f01043b9:	0f 42 c1             	cmovb  %ecx,%eax
f01043bc:	89 c6                	mov    %eax,%esi
		user_mem_assert(curenv, (void*)exstacktop - stacksize, stacksize, PTE_U | PTE_W);
f01043be:	8d 50 c8             	lea    -0x38(%eax),%edx
f01043c1:	89 d7                	mov    %edx,%edi
f01043c3:	e8 9a 1d 00 00       	call   f0106162 <cpunum>
f01043c8:	6a 06                	push   $0x6
f01043ca:	6a 38                	push   $0x38
f01043cc:	57                   	push   %edi
f01043cd:	6b c0 74             	imul   $0x74,%eax,%eax
f01043d0:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f01043d6:	e8 e3 ec ff ff       	call   f01030be <user_mem_assert>
		utf->utf_eflags = tf->tf_eflags;
f01043db:	8b 43 38             	mov    0x38(%ebx),%eax
f01043de:	89 47 2c             	mov    %eax,0x2c(%edi)
    	utf->utf_eip = tf->tf_eip;
f01043e1:	8b 43 30             	mov    0x30(%ebx),%eax
f01043e4:	89 fa                	mov    %edi,%edx
f01043e6:	89 47 28             	mov    %eax,0x28(%edi)
    	utf->utf_esp = tf->tf_esp;
f01043e9:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01043ec:	89 47 30             	mov    %eax,0x30(%edi)
    	utf->utf_regs = tf->tf_regs;
f01043ef:	89 75 e0             	mov    %esi,-0x20(%ebp)
f01043f2:	8d 7e d0             	lea    -0x30(%esi),%edi
f01043f5:	b9 08 00 00 00       	mov    $0x8,%ecx
f01043fa:	89 de                	mov    %ebx,%esi
f01043fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    	utf->utf_err = tf->tf_err;
f01043fe:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104401:	89 42 04             	mov    %eax,0x4(%edx)
    	utf->utf_fault_va = fault_va;
f0104404:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0104407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010440a:	89 46 c8             	mov    %eax,-0x38(%esi)
		tf->tf_esp = (uintptr_t)utf;
f010440d:	89 53 3c             	mov    %edx,0x3c(%ebx)
    	tf->tf_eip = (uint32_t)curenv->env_pgfault_upcall;
f0104410:	e8 4d 1d 00 00       	call   f0106162 <cpunum>
f0104415:	6b c0 74             	imul   $0x74,%eax,%eax
f0104418:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f010441e:	8b 40 64             	mov    0x64(%eax),%eax
f0104421:	89 43 30             	mov    %eax,0x30(%ebx)
		env_run(curenv);
f0104424:	e8 39 1d 00 00       	call   f0106162 <cpunum>
f0104429:	83 c4 04             	add    $0x4,%esp
f010442c:	6b c0 74             	imul   $0x74,%eax,%eax
f010442f:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f0104435:	e8 89 f3 ff ff       	call   f01037c3 <env_run>

f010443a <trap>:
{
f010443a:	f3 0f 1e fb          	endbr32 
f010443e:	55                   	push   %ebp
f010443f:	89 e5                	mov    %esp,%ebp
f0104441:	57                   	push   %edi
f0104442:	56                   	push   %esi
f0104443:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104446:	fc                   	cld    
	if (panicstr)
f0104447:	83 3d 80 7e 21 f0 00 	cmpl   $0x0,0xf0217e80
f010444e:	74 01                	je     f0104451 <trap+0x17>
		asm volatile("hlt");
f0104450:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104451:	e8 0c 1d 00 00       	call   f0106162 <cpunum>
f0104456:	6b d0 74             	imul   $0x74,%eax,%edx
f0104459:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010445c:	b8 01 00 00 00       	mov    $0x1,%eax
f0104461:	f0 87 82 20 80 21 f0 	lock xchg %eax,-0xfde7fe0(%edx)
f0104468:	83 f8 02             	cmp    $0x2,%eax
f010446b:	0f 84 99 00 00 00    	je     f010450a <trap+0xd0>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0104471:	9c                   	pushf  
f0104472:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f0104473:	f6 c4 02             	test   $0x2,%ah
f0104476:	0f 85 a3 00 00 00    	jne    f010451f <trap+0xe5>
	if ((tf->tf_cs & 3) == 3) {
f010447c:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104480:	83 e0 03             	and    $0x3,%eax
f0104483:	66 83 f8 03          	cmp    $0x3,%ax
f0104487:	0f 84 ab 00 00 00    	je     f0104538 <trap+0xfe>
	last_tf = tf;
f010448d:	89 35 60 7a 21 f0    	mov    %esi,0xf0217a60
	switch(tf->tf_trapno)
f0104493:	8b 46 28             	mov    0x28(%esi),%eax
f0104496:	83 f8 0e             	cmp    $0xe,%eax
f0104499:	0f 84 14 01 00 00    	je     f01045b3 <trap+0x179>
f010449f:	83 f8 30             	cmp    $0x30,%eax
f01044a2:	0f 84 53 01 00 00    	je     f01045fb <trap+0x1c1>
f01044a8:	83 f8 03             	cmp    $0x3,%eax
f01044ab:	0f 84 3c 01 00 00    	je     f01045ed <trap+0x1b3>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f01044b1:	83 f8 27             	cmp    $0x27,%eax
f01044b4:	0f 84 62 01 00 00    	je     f010461c <trap+0x1e2>
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f01044ba:	83 f8 20             	cmp    $0x20,%eax
f01044bd:	0f 84 73 01 00 00    	je     f0104636 <trap+0x1fc>
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_KBD){
f01044c3:	83 f8 21             	cmp    $0x21,%eax
f01044c6:	0f 84 74 01 00 00    	je     f0104640 <trap+0x206>
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL){
f01044cc:	83 f8 24             	cmp    $0x24,%eax
f01044cf:	0f 84 75 01 00 00    	je     f010464a <trap+0x210>
	print_trapframe(tf);
f01044d5:	83 ec 0c             	sub    $0xc,%esp
f01044d8:	56                   	push   %esi
f01044d9:	e8 96 fc ff ff       	call   f0104174 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f01044de:	83 c4 10             	add    $0x10,%esp
f01044e1:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f01044e6:	0f 84 68 01 00 00    	je     f0104654 <trap+0x21a>
		env_destroy(curenv);
f01044ec:	e8 71 1c 00 00       	call   f0106162 <cpunum>
f01044f1:	83 ec 0c             	sub    $0xc,%esp
f01044f4:	6b c0 74             	imul   $0x74,%eax,%eax
f01044f7:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f01044fd:	e8 1a f2 ff ff       	call   f010371c <env_destroy>
		return;
f0104502:	83 c4 10             	add    $0x10,%esp
f0104505:	e9 b5 00 00 00       	jmp    f01045bf <trap+0x185>
	spin_lock(&kernel_lock);
f010450a:	83 ec 0c             	sub    $0xc,%esp
f010450d:	68 c0 33 12 f0       	push   $0xf01233c0
f0104512:	e8 d3 1e 00 00       	call   f01063ea <spin_lock>
}
f0104517:	83 c4 10             	add    $0x10,%esp
f010451a:	e9 52 ff ff ff       	jmp    f0104471 <trap+0x37>
	assert(!(read_eflags() & FL_IF));
f010451f:	68 46 7d 10 f0       	push   $0xf0107d46
f0104524:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0104529:	68 50 01 00 00       	push   $0x150
f010452e:	68 3a 7d 10 f0       	push   $0xf0107d3a
f0104533:	e8 08 bb ff ff       	call   f0100040 <_panic>
	spin_lock(&kernel_lock);
f0104538:	83 ec 0c             	sub    $0xc,%esp
f010453b:	68 c0 33 12 f0       	push   $0xf01233c0
f0104540:	e8 a5 1e 00 00       	call   f01063ea <spin_lock>
		if (curenv->env_status == ENV_DYING) {
f0104545:	e8 18 1c 00 00       	call   f0106162 <cpunum>
f010454a:	6b c0 74             	imul   $0x74,%eax,%eax
f010454d:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104553:	83 c4 10             	add    $0x10,%esp
f0104556:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f010455a:	74 2a                	je     f0104586 <trap+0x14c>
		curenv->env_tf = *tf;
f010455c:	e8 01 1c 00 00       	call   f0106162 <cpunum>
f0104561:	6b c0 74             	imul   $0x74,%eax,%eax
f0104564:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f010456a:	b9 11 00 00 00       	mov    $0x11,%ecx
f010456f:	89 c7                	mov    %eax,%edi
f0104571:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104573:	e8 ea 1b 00 00       	call   f0106162 <cpunum>
f0104578:	6b c0 74             	imul   $0x74,%eax,%eax
f010457b:	8b b0 28 80 21 f0    	mov    -0xfde7fd8(%eax),%esi
f0104581:	e9 07 ff ff ff       	jmp    f010448d <trap+0x53>
			env_free(curenv);
f0104586:	e8 d7 1b 00 00       	call   f0106162 <cpunum>
f010458b:	83 ec 0c             	sub    $0xc,%esp
f010458e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104591:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f0104597:	e8 d2 ef ff ff       	call   f010356e <env_free>
			curenv = NULL;
f010459c:	e8 c1 1b 00 00       	call   f0106162 <cpunum>
f01045a1:	6b c0 74             	imul   $0x74,%eax,%eax
f01045a4:	c7 80 28 80 21 f0 00 	movl   $0x0,-0xfde7fd8(%eax)
f01045ab:	00 00 00 
			sched_yield();
f01045ae:	e8 a6 02 00 00       	call   f0104859 <sched_yield>
			page_fault_handler(tf);
f01045b3:	83 ec 0c             	sub    $0xc,%esp
f01045b6:	56                   	push   %esi
f01045b7:	e8 58 fd ff ff       	call   f0104314 <page_fault_handler>
			return ;
f01045bc:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f01045bf:	e8 9e 1b 00 00       	call   f0106162 <cpunum>
f01045c4:	6b c0 74             	imul   $0x74,%eax,%eax
f01045c7:	83 b8 28 80 21 f0 00 	cmpl   $0x0,-0xfde7fd8(%eax)
f01045ce:	74 18                	je     f01045e8 <trap+0x1ae>
f01045d0:	e8 8d 1b 00 00       	call   f0106162 <cpunum>
f01045d5:	6b c0 74             	imul   $0x74,%eax,%eax
f01045d8:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f01045de:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01045e2:	0f 84 83 00 00 00    	je     f010466b <trap+0x231>
		sched_yield();
f01045e8:	e8 6c 02 00 00       	call   f0104859 <sched_yield>
			monitor(tf);
f01045ed:	83 ec 0c             	sub    $0xc,%esp
f01045f0:	56                   	push   %esi
f01045f1:	e8 86 c3 ff ff       	call   f010097c <monitor>
			return ;
f01045f6:	83 c4 10             	add    $0x10,%esp
f01045f9:	eb c4                	jmp    f01045bf <trap+0x185>
			p->reg_eax = syscall(p->reg_eax, p->reg_edx, p->reg_ecx, p->reg_ebx, p->reg_edi, p->reg_esi);
f01045fb:	83 ec 08             	sub    $0x8,%esp
f01045fe:	ff 76 04             	pushl  0x4(%esi)
f0104601:	ff 36                	pushl  (%esi)
f0104603:	ff 76 10             	pushl  0x10(%esi)
f0104606:	ff 76 18             	pushl  0x18(%esi)
f0104609:	ff 76 14             	pushl  0x14(%esi)
f010460c:	ff 76 1c             	pushl  0x1c(%esi)
f010460f:	e8 f4 02 00 00       	call   f0104908 <syscall>
f0104614:	89 46 1c             	mov    %eax,0x1c(%esi)
			return ;
f0104617:	83 c4 20             	add    $0x20,%esp
f010461a:	eb a3                	jmp    f01045bf <trap+0x185>
		cprintf("Spurious interrupt on irq 7\n");
f010461c:	83 ec 0c             	sub    $0xc,%esp
f010461f:	68 5f 7d 10 f0       	push   $0xf0107d5f
f0104624:	e8 de f3 ff ff       	call   f0103a07 <cprintf>
		print_trapframe(tf);
f0104629:	89 34 24             	mov    %esi,(%esp)
f010462c:	e8 43 fb ff ff       	call   f0104174 <print_trapframe>
		return;
f0104631:	83 c4 10             	add    $0x10,%esp
f0104634:	eb 89                	jmp    f01045bf <trap+0x185>
		lapic_eoi();
f0104636:	e8 76 1c 00 00       	call   f01062b1 <lapic_eoi>
		sched_yield();
f010463b:	e8 19 02 00 00       	call   f0104859 <sched_yield>
		kbd_intr();
f0104640:	e8 b8 bf ff ff       	call   f01005fd <kbd_intr>
		return ;
f0104645:	e9 75 ff ff ff       	jmp    f01045bf <trap+0x185>
		serial_intr();
f010464a:	e8 8e bf ff ff       	call   f01005dd <serial_intr>
		return ;
f010464f:	e9 6b ff ff ff       	jmp    f01045bf <trap+0x185>
		panic("unhandled trap in kernel");
f0104654:	83 ec 04             	sub    $0x4,%esp
f0104657:	68 7c 7d 10 f0       	push   $0xf0107d7c
f010465c:	68 36 01 00 00       	push   $0x136
f0104661:	68 3a 7d 10 f0       	push   $0xf0107d3a
f0104666:	e8 d5 b9 ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f010466b:	e8 f2 1a 00 00       	call   f0106162 <cpunum>
f0104670:	83 ec 0c             	sub    $0xc,%esp
f0104673:	6b c0 74             	imul   $0x74,%eax,%eax
f0104676:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f010467c:	e8 42 f1 ff ff       	call   f01037c3 <env_run>
f0104681:	90                   	nop

f0104682 <divide_handler>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(divide_handler,T_DIVIDE)
f0104682:	6a 00                	push   $0x0
f0104684:	6a 00                	push   $0x0
f0104686:	e9 ef 00 00 00       	jmp    f010477a <_alltraps>
f010468b:	90                   	nop

f010468c <debug_handler>:
TRAPHANDLER_NOEC(debug_handler,T_DEBUG)
f010468c:	6a 00                	push   $0x0
f010468e:	6a 01                	push   $0x1
f0104690:	e9 e5 00 00 00       	jmp    f010477a <_alltraps>
f0104695:	90                   	nop

f0104696 <nmi_handler>:
TRAPHANDLER_NOEC(nmi_handler,T_NMI)
f0104696:	6a 00                	push   $0x0
f0104698:	6a 02                	push   $0x2
f010469a:	e9 db 00 00 00       	jmp    f010477a <_alltraps>
f010469f:	90                   	nop

f01046a0 <brkpt_handler>:
TRAPHANDLER_NOEC(brkpt_handler,T_BRKPT)
f01046a0:	6a 00                	push   $0x0
f01046a2:	6a 03                	push   $0x3
f01046a4:	e9 d1 00 00 00       	jmp    f010477a <_alltraps>
f01046a9:	90                   	nop

f01046aa <oflow_handler>:
TRAPHANDLER_NOEC(oflow_handler,T_OFLOW)
f01046aa:	6a 00                	push   $0x0
f01046ac:	6a 04                	push   $0x4
f01046ae:	e9 c7 00 00 00       	jmp    f010477a <_alltraps>
f01046b3:	90                   	nop

f01046b4 <bound_handler>:
TRAPHANDLER_NOEC(bound_handler,T_BOUND)
f01046b4:	6a 00                	push   $0x0
f01046b6:	6a 05                	push   $0x5
f01046b8:	e9 bd 00 00 00       	jmp    f010477a <_alltraps>
f01046bd:	90                   	nop

f01046be <illop_handler>:
TRAPHANDLER_NOEC(illop_handler,T_ILLOP)
f01046be:	6a 00                	push   $0x0
f01046c0:	6a 06                	push   $0x6
f01046c2:	e9 b3 00 00 00       	jmp    f010477a <_alltraps>
f01046c7:	90                   	nop

f01046c8 <device_handler>:
TRAPHANDLER_NOEC(device_handler,T_DEVICE)
f01046c8:	6a 00                	push   $0x0
f01046ca:	6a 07                	push   $0x7
f01046cc:	e9 a9 00 00 00       	jmp    f010477a <_alltraps>
f01046d1:	90                   	nop

f01046d2 <dblflt_handler>:
TRAPHANDLER(dblflt_handler,T_DBLFLT)
f01046d2:	6a 08                	push   $0x8
f01046d4:	e9 a1 00 00 00       	jmp    f010477a <_alltraps>
f01046d9:	90                   	nop

f01046da <tss_handler>:
TRAPHANDLER(tss_handler,T_TSS)
f01046da:	6a 0a                	push   $0xa
f01046dc:	e9 99 00 00 00       	jmp    f010477a <_alltraps>
f01046e1:	90                   	nop

f01046e2 <segnp_handler>:
TRAPHANDLER(segnp_handler,T_SEGNP)
f01046e2:	6a 0b                	push   $0xb
f01046e4:	e9 91 00 00 00       	jmp    f010477a <_alltraps>
f01046e9:	90                   	nop

f01046ea <stack_handler>:
TRAPHANDLER(stack_handler,T_STACK)
f01046ea:	6a 0c                	push   $0xc
f01046ec:	e9 89 00 00 00       	jmp    f010477a <_alltraps>
f01046f1:	90                   	nop

f01046f2 <gpflt_handler>:
TRAPHANDLER(gpflt_handler,T_GPFLT)
f01046f2:	6a 0d                	push   $0xd
f01046f4:	e9 81 00 00 00       	jmp    f010477a <_alltraps>
f01046f9:	90                   	nop

f01046fa <pgflt_handler>:
TRAPHANDLER(pgflt_handler,T_PGFLT)
f01046fa:	6a 0e                	push   $0xe
f01046fc:	eb 7c                	jmp    f010477a <_alltraps>

f01046fe <fperr_handler>:
TRAPHANDLER_NOEC(fperr_handler,T_FPERR)
f01046fe:	6a 00                	push   $0x0
f0104700:	6a 10                	push   $0x10
f0104702:	eb 76                	jmp    f010477a <_alltraps>

f0104704 <align_handler>:
TRAPHANDLER(align_handler,T_ALIGN)
f0104704:	6a 11                	push   $0x11
f0104706:	eb 72                	jmp    f010477a <_alltraps>

f0104708 <mchk_handler>:
TRAPHANDLER_NOEC(mchk_handler,T_MCHK)
f0104708:	6a 00                	push   $0x0
f010470a:	6a 12                	push   $0x12
f010470c:	eb 6c                	jmp    f010477a <_alltraps>

f010470e <simderr_handler>:
TRAPHANDLER_NOEC(simderr_handler,T_SIMDERR)
f010470e:	6a 00                	push   $0x0
f0104710:	6a 13                	push   $0x13
f0104712:	eb 66                	jmp    f010477a <_alltraps>

f0104714 <syscall_handler>:
TRAPHANDLER_NOEC(syscall_handler,T_SYSCALL)
f0104714:	6a 00                	push   $0x0
f0104716:	6a 30                	push   $0x30
f0104718:	eb 60                	jmp    f010477a <_alltraps>

f010471a <irq_0_handler>:

/*
 * Lab 4: Add IRQ 0 - 15
 */

TRAPHANDLER_NOEC(irq_0_handler, IRQ_OFFSET + 0);
f010471a:	6a 00                	push   $0x0
f010471c:	6a 20                	push   $0x20
f010471e:	eb 5a                	jmp    f010477a <_alltraps>

f0104720 <irq_1_handler>:
TRAPHANDLER_NOEC(irq_1_handler, IRQ_OFFSET + 1);
f0104720:	6a 00                	push   $0x0
f0104722:	6a 21                	push   $0x21
f0104724:	eb 54                	jmp    f010477a <_alltraps>

f0104726 <irq_2_handler>:
TRAPHANDLER_NOEC(irq_2_handler, IRQ_OFFSET + 2);
f0104726:	6a 00                	push   $0x0
f0104728:	6a 22                	push   $0x22
f010472a:	eb 4e                	jmp    f010477a <_alltraps>

f010472c <irq_3_handler>:
TRAPHANDLER_NOEC(irq_3_handler, IRQ_OFFSET + 3);
f010472c:	6a 00                	push   $0x0
f010472e:	6a 23                	push   $0x23
f0104730:	eb 48                	jmp    f010477a <_alltraps>

f0104732 <irq_4_handler>:
TRAPHANDLER_NOEC(irq_4_handler, IRQ_OFFSET + 4);
f0104732:	6a 00                	push   $0x0
f0104734:	6a 24                	push   $0x24
f0104736:	eb 42                	jmp    f010477a <_alltraps>

f0104738 <irq_5_handler>:
TRAPHANDLER_NOEC(irq_5_handler, IRQ_OFFSET + 5);
f0104738:	6a 00                	push   $0x0
f010473a:	6a 25                	push   $0x25
f010473c:	eb 3c                	jmp    f010477a <_alltraps>

f010473e <irq_6_handler>:
TRAPHANDLER_NOEC(irq_6_handler, IRQ_OFFSET + 6);
f010473e:	6a 00                	push   $0x0
f0104740:	6a 26                	push   $0x26
f0104742:	eb 36                	jmp    f010477a <_alltraps>

f0104744 <irq_7_handler>:
TRAPHANDLER_NOEC(irq_7_handler, IRQ_OFFSET + 7);
f0104744:	6a 00                	push   $0x0
f0104746:	6a 27                	push   $0x27
f0104748:	eb 30                	jmp    f010477a <_alltraps>

f010474a <irq_8_handler>:
TRAPHANDLER_NOEC(irq_8_handler, IRQ_OFFSET + 8);
f010474a:	6a 00                	push   $0x0
f010474c:	6a 28                	push   $0x28
f010474e:	eb 2a                	jmp    f010477a <_alltraps>

f0104750 <irq_9_handler>:
TRAPHANDLER_NOEC(irq_9_handler, IRQ_OFFSET + 9);
f0104750:	6a 00                	push   $0x0
f0104752:	6a 29                	push   $0x29
f0104754:	eb 24                	jmp    f010477a <_alltraps>

f0104756 <irq_10_handler>:
TRAPHANDLER_NOEC(irq_10_handler, IRQ_OFFSET + 10);
f0104756:	6a 00                	push   $0x0
f0104758:	6a 2a                	push   $0x2a
f010475a:	eb 1e                	jmp    f010477a <_alltraps>

f010475c <irq_11_handler>:
TRAPHANDLER_NOEC(irq_11_handler, IRQ_OFFSET + 11);
f010475c:	6a 00                	push   $0x0
f010475e:	6a 2b                	push   $0x2b
f0104760:	eb 18                	jmp    f010477a <_alltraps>

f0104762 <irq_12_handler>:
TRAPHANDLER_NOEC(irq_12_handler, IRQ_OFFSET + 12);
f0104762:	6a 00                	push   $0x0
f0104764:	6a 2c                	push   $0x2c
f0104766:	eb 12                	jmp    f010477a <_alltraps>

f0104768 <irq_13_handler>:
TRAPHANDLER_NOEC(irq_13_handler, IRQ_OFFSET + 13);
f0104768:	6a 00                	push   $0x0
f010476a:	6a 2d                	push   $0x2d
f010476c:	eb 0c                	jmp    f010477a <_alltraps>

f010476e <irq_14_handler>:
TRAPHANDLER_NOEC(irq_14_handler, IRQ_OFFSET + 14);
f010476e:	6a 00                	push   $0x0
f0104770:	6a 2e                	push   $0x2e
f0104772:	eb 06                	jmp    f010477a <_alltraps>

f0104774 <irq_15_handler>:
TRAPHANDLER_NOEC(irq_15_handler, IRQ_OFFSET + 15);
f0104774:	6a 00                	push   $0x0
f0104776:	6a 2f                	push   $0x2f
f0104778:	eb 00                	jmp    f010477a <_alltraps>

f010477a <_alltraps>:

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl	%es
f010477a:	06                   	push   %es
	pushl	%ds
f010477b:	1e                   	push   %ds
	pushal
f010477c:	60                   	pusha  
	movw	$(GD_KD), %ax
f010477d:	66 b8 10 00          	mov    $0x10,%ax
	movw 	%ax, %ds
f0104781:	8e d8                	mov    %eax,%ds
	movw 	%ax, %es
f0104783:	8e c0                	mov    %eax,%es
	pushl	%esp
f0104785:	54                   	push   %esp
f0104786:	e8 af fc ff ff       	call   f010443a <trap>

f010478b <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f010478b:	f3 0f 1e fb          	endbr32 
f010478f:	55                   	push   %ebp
f0104790:	89 e5                	mov    %esp,%ebp
f0104792:	83 ec 08             	sub    $0x8,%esp
f0104795:	a1 48 72 21 f0       	mov    0xf0217248,%eax
f010479a:	8d 50 54             	lea    0x54(%eax),%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f010479d:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f01047a2:	8b 02                	mov    (%edx),%eax
f01047a4:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f01047a7:	83 f8 02             	cmp    $0x2,%eax
f01047aa:	76 2d                	jbe    f01047d9 <sched_halt+0x4e>
	for (i = 0; i < NENV; i++) {
f01047ac:	83 c1 01             	add    $0x1,%ecx
f01047af:	83 c2 7c             	add    $0x7c,%edx
f01047b2:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01047b8:	75 e8                	jne    f01047a2 <sched_halt+0x17>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f01047ba:	83 ec 0c             	sub    $0xc,%esp
f01047bd:	68 90 7f 10 f0       	push   $0xf0107f90
f01047c2:	e8 40 f2 ff ff       	call   f0103a07 <cprintf>
f01047c7:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f01047ca:	83 ec 0c             	sub    $0xc,%esp
f01047cd:	6a 00                	push   $0x0
f01047cf:	e8 a8 c1 ff ff       	call   f010097c <monitor>
f01047d4:	83 c4 10             	add    $0x10,%esp
f01047d7:	eb f1                	jmp    f01047ca <sched_halt+0x3f>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f01047d9:	e8 84 19 00 00       	call   f0106162 <cpunum>
f01047de:	6b c0 74             	imul   $0x74,%eax,%eax
f01047e1:	c7 80 28 80 21 f0 00 	movl   $0x0,-0xfde7fd8(%eax)
f01047e8:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f01047eb:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01047f0:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01047f5:	76 50                	jbe    f0104847 <sched_halt+0xbc>
	return (physaddr_t)kva - KERNBASE;
f01047f7:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01047fc:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f01047ff:	e8 5e 19 00 00       	call   f0106162 <cpunum>
f0104804:	6b d0 74             	imul   $0x74,%eax,%edx
f0104807:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010480a:	b8 02 00 00 00       	mov    $0x2,%eax
f010480f:	f0 87 82 20 80 21 f0 	lock xchg %eax,-0xfde7fe0(%edx)
	spin_unlock(&kernel_lock);
f0104816:	83 ec 0c             	sub    $0xc,%esp
f0104819:	68 c0 33 12 f0       	push   $0xf01233c0
f010481e:	e8 65 1c 00 00       	call   f0106488 <spin_unlock>
	asm volatile("pause");
f0104823:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104825:	e8 38 19 00 00       	call   f0106162 <cpunum>
f010482a:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f010482d:	8b 80 30 80 21 f0    	mov    -0xfde7fd0(%eax),%eax
f0104833:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104838:	89 c4                	mov    %eax,%esp
f010483a:	6a 00                	push   $0x0
f010483c:	6a 00                	push   $0x0
f010483e:	fb                   	sti    
f010483f:	f4                   	hlt    
f0104840:	eb fd                	jmp    f010483f <sched_halt+0xb4>
}
f0104842:	83 c4 10             	add    $0x10,%esp
f0104845:	c9                   	leave  
f0104846:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104847:	50                   	push   %eax
f0104848:	68 28 68 10 f0       	push   $0xf0106828
f010484d:	6a 57                	push   $0x57
f010484f:	68 b9 7f 10 f0       	push   $0xf0107fb9
f0104854:	e8 e7 b7 ff ff       	call   f0100040 <_panic>

f0104859 <sched_yield>:
{
f0104859:	f3 0f 1e fb          	endbr32 
f010485d:	55                   	push   %ebp
f010485e:	89 e5                	mov    %esp,%ebp
f0104860:	53                   	push   %ebx
f0104861:	83 ec 04             	sub    $0x4,%esp
	if (curenv){
f0104864:	e8 f9 18 00 00       	call   f0106162 <cpunum>
f0104869:	6b c0 74             	imul   $0x74,%eax,%eax
f010486c:	83 b8 28 80 21 f0 00 	cmpl   $0x0,-0xfde7fd8(%eax)
f0104873:	74 3e                	je     f01048b3 <sched_yield+0x5a>
		size_t eidx = ENVX(curenv->env_id);
f0104875:	e8 e8 18 00 00       	call   f0106162 <cpunum>
f010487a:	6b c0 74             	imul   $0x74,%eax,%eax
f010487d:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104883:	8b 48 48             	mov    0x48(%eax),%ecx
f0104886:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for (size_t i = (eidx + 1) & mask; i != eidx; i = (i + 1) & mask){
f010488c:	8d 41 01             	lea    0x1(%ecx),%eax
f010488f:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f0104894:	8b 1d 48 72 21 f0    	mov    0xf0217248,%ebx
		for (size_t i = (eidx + 1) & mask; i != eidx; i = (i + 1) & mask){
f010489a:	39 c8                	cmp    %ecx,%eax
f010489c:	74 3a                	je     f01048d8 <sched_yield+0x7f>
			if(envs[i].env_status == ENV_RUNNABLE){
f010489e:	6b d0 7c             	imul   $0x7c,%eax,%edx
f01048a1:	01 da                	add    %ebx,%edx
f01048a3:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f01048a7:	74 26                	je     f01048cf <sched_yield+0x76>
		for (size_t i = (eidx + 1) & mask; i != eidx; i = (i + 1) & mask){
f01048a9:	83 c0 01             	add    $0x1,%eax
f01048ac:	25 ff 03 00 00       	and    $0x3ff,%eax
f01048b1:	eb e7                	jmp    f010489a <sched_yield+0x41>
f01048b3:	a1 48 72 21 f0       	mov    0xf0217248,%eax
f01048b8:	8d 88 00 f0 01 00    	lea    0x1f000(%eax),%ecx
			if(envs[i].env_status == ENV_RUNNABLE){
f01048be:	89 c2                	mov    %eax,%edx
f01048c0:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01048c4:	74 09                	je     f01048cf <sched_yield+0x76>
f01048c6:	83 c0 7c             	add    $0x7c,%eax
		for(size_t i = 0; i < NENV; ++i) {
f01048c9:	39 c8                	cmp    %ecx,%eax
f01048cb:	75 f1                	jne    f01048be <sched_yield+0x65>
f01048cd:	eb 2f                	jmp    f01048fe <sched_yield+0xa5>
		env_run(idle);
f01048cf:	83 ec 0c             	sub    $0xc,%esp
f01048d2:	52                   	push   %edx
f01048d3:	e8 eb ee ff ff       	call   f01037c3 <env_run>
		if(!idle && curenv->env_status == ENV_RUNNING){
f01048d8:	e8 85 18 00 00       	call   f0106162 <cpunum>
f01048dd:	6b c0 74             	imul   $0x74,%eax,%eax
f01048e0:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f01048e6:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01048ea:	75 12                	jne    f01048fe <sched_yield+0xa5>
			idle = curenv;
f01048ec:	e8 71 18 00 00       	call   f0106162 <cpunum>
f01048f1:	6b c0 74             	imul   $0x74,%eax,%eax
f01048f4:	8b 90 28 80 21 f0    	mov    -0xfde7fd8(%eax),%edx
	if(idle){
f01048fa:	85 d2                	test   %edx,%edx
f01048fc:	75 d1                	jne    f01048cf <sched_yield+0x76>
	sched_halt();
f01048fe:	e8 88 fe ff ff       	call   f010478b <sched_halt>
}
f0104903:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104906:	c9                   	leave  
f0104907:	c3                   	ret    

f0104908 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104908:	f3 0f 1e fb          	endbr32 
f010490c:	55                   	push   %ebp
f010490d:	89 e5                	mov    %esp,%ebp
f010490f:	57                   	push   %edi
f0104910:	56                   	push   %esi
f0104911:	53                   	push   %ebx
f0104912:	83 ec 1c             	sub    $0x1c,%esp
f0104915:	8b 45 08             	mov    0x8(%ebp),%eax
f0104918:	83 f8 0d             	cmp    $0xd,%eax
f010491b:	0f 87 d1 05 00 00    	ja     f0104ef2 <syscall+0x5ea>
f0104921:	3e ff 24 85 00 80 10 	notrack jmp *-0xfef8000(,%eax,4)
f0104928:	f0 
	user_mem_assert(curenv, s, len, PTE_U);
f0104929:	e8 34 18 00 00       	call   f0106162 <cpunum>
f010492e:	6a 04                	push   $0x4
f0104930:	ff 75 10             	pushl  0x10(%ebp)
f0104933:	ff 75 0c             	pushl  0xc(%ebp)
f0104936:	6b c0 74             	imul   $0x74,%eax,%eax
f0104939:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f010493f:	e8 7a e7 ff ff       	call   f01030be <user_mem_assert>
	cprintf("%.*s", len, s);
f0104944:	83 c4 0c             	add    $0xc,%esp
f0104947:	ff 75 0c             	pushl  0xc(%ebp)
f010494a:	ff 75 10             	pushl  0x10(%ebp)
f010494d:	68 c6 7f 10 f0       	push   $0xf0107fc6
f0104952:	e8 b0 f0 ff ff       	call   f0103a07 <cprintf>
}
f0104957:	83 c4 10             	add    $0x10,%esp
	// LAB 3: Your code here.

	switch (syscallno) {
		case SYS_cputs:
			sys_cputs((char *) a1, a2);
			return 0;
f010495a:	bb 00 00 00 00       	mov    $0x0,%ebx
		default:
			return -E_INVAL;
	}

	return -E_INVAL;
f010495f:	89 d8                	mov    %ebx,%eax
f0104961:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104964:	5b                   	pop    %ebx
f0104965:	5e                   	pop    %esi
f0104966:	5f                   	pop    %edi
f0104967:	5d                   	pop    %ebp
f0104968:	c3                   	ret    
	return cons_getc();
f0104969:	e8 a5 bc ff ff       	call   f0100613 <cons_getc>
f010496e:	89 c3                	mov    %eax,%ebx
			return sys_cgetc();
f0104970:	eb ed                	jmp    f010495f <syscall+0x57>
	return curenv->env_id;
f0104972:	e8 eb 17 00 00       	call   f0106162 <cpunum>
f0104977:	6b c0 74             	imul   $0x74,%eax,%eax
f010497a:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104980:	8b 58 48             	mov    0x48(%eax),%ebx
			return sys_getenvid();
f0104983:	eb da                	jmp    f010495f <syscall+0x57>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104985:	83 ec 04             	sub    $0x4,%esp
f0104988:	6a 01                	push   $0x1
f010498a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010498d:	50                   	push   %eax
f010498e:	ff 75 0c             	pushl  0xc(%ebp)
f0104991:	e8 e3 e7 ff ff       	call   f0103179 <envid2env>
f0104996:	89 c3                	mov    %eax,%ebx
f0104998:	83 c4 10             	add    $0x10,%esp
f010499b:	85 c0                	test   %eax,%eax
f010499d:	78 c0                	js     f010495f <syscall+0x57>
	if (e == curenv)
f010499f:	e8 be 17 00 00       	call   f0106162 <cpunum>
f01049a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01049a7:	6b c0 74             	imul   $0x74,%eax,%eax
f01049aa:	39 90 28 80 21 f0    	cmp    %edx,-0xfde7fd8(%eax)
f01049b0:	74 3d                	je     f01049ef <syscall+0xe7>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01049b2:	8b 5a 48             	mov    0x48(%edx),%ebx
f01049b5:	e8 a8 17 00 00       	call   f0106162 <cpunum>
f01049ba:	83 ec 04             	sub    $0x4,%esp
f01049bd:	53                   	push   %ebx
f01049be:	6b c0 74             	imul   $0x74,%eax,%eax
f01049c1:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f01049c7:	ff 70 48             	pushl  0x48(%eax)
f01049ca:	68 e6 7f 10 f0       	push   $0xf0107fe6
f01049cf:	e8 33 f0 ff ff       	call   f0103a07 <cprintf>
f01049d4:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f01049d7:	83 ec 0c             	sub    $0xc,%esp
f01049da:	ff 75 e4             	pushl  -0x1c(%ebp)
f01049dd:	e8 3a ed ff ff       	call   f010371c <env_destroy>
	return 0;
f01049e2:	83 c4 10             	add    $0x10,%esp
f01049e5:	bb 00 00 00 00       	mov    $0x0,%ebx
			return sys_env_destroy(a1);
f01049ea:	e9 70 ff ff ff       	jmp    f010495f <syscall+0x57>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f01049ef:	e8 6e 17 00 00       	call   f0106162 <cpunum>
f01049f4:	83 ec 08             	sub    $0x8,%esp
f01049f7:	6b c0 74             	imul   $0x74,%eax,%eax
f01049fa:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104a00:	ff 70 48             	pushl  0x48(%eax)
f0104a03:	68 cb 7f 10 f0       	push   $0xf0107fcb
f0104a08:	e8 fa ef ff ff       	call   f0103a07 <cprintf>
f0104a0d:	83 c4 10             	add    $0x10,%esp
f0104a10:	eb c5                	jmp    f01049d7 <syscall+0xcf>
	sched_yield();
f0104a12:	e8 42 fe ff ff       	call   f0104859 <sched_yield>
	parent = curenv;
f0104a17:	e8 46 17 00 00       	call   f0106162 <cpunum>
f0104a1c:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a1f:	8b b0 28 80 21 f0    	mov    -0xfde7fd8(%eax),%esi
	if((e = env_alloc(&child, parent->env_id)) < 0){
f0104a25:	83 ec 08             	sub    $0x8,%esp
f0104a28:	ff 76 48             	pushl  0x48(%esi)
f0104a2b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104a2e:	50                   	push   %eax
f0104a2f:	e8 53 e8 ff ff       	call   f0103287 <env_alloc>
f0104a34:	89 c3                	mov    %eax,%ebx
f0104a36:	83 c4 10             	add    $0x10,%esp
f0104a39:	85 c0                	test   %eax,%eax
f0104a3b:	0f 88 1e ff ff ff    	js     f010495f <syscall+0x57>
	child->env_tf = parent->env_tf;
f0104a41:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104a46:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104a49:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child->env_status = ENV_NOT_RUNNABLE;
f0104a4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a4e:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	child->env_tf.tf_regs.reg_eax = 0;
f0104a55:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return child->env_id;
f0104a5c:	8b 58 48             	mov    0x48(%eax),%ebx
			return sys_exofork();
f0104a5f:	e9 fb fe ff ff       	jmp    f010495f <syscall+0x57>
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE){
f0104a64:	8b 45 10             	mov    0x10(%ebp),%eax
f0104a67:	83 e8 02             	sub    $0x2,%eax
f0104a6a:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f0104a6f:	75 28                	jne    f0104a99 <syscall+0x191>
	if(envid2env(envid, &e, 1) != 0){
f0104a71:	83 ec 04             	sub    $0x4,%esp
f0104a74:	6a 01                	push   $0x1
f0104a76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104a79:	50                   	push   %eax
f0104a7a:	ff 75 0c             	pushl  0xc(%ebp)
f0104a7d:	e8 f7 e6 ff ff       	call   f0103179 <envid2env>
f0104a82:	89 c3                	mov    %eax,%ebx
f0104a84:	83 c4 10             	add    $0x10,%esp
f0104a87:	85 c0                	test   %eax,%eax
f0104a89:	75 18                	jne    f0104aa3 <syscall+0x19b>
	e->env_status = status;
f0104a8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a8e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104a91:	89 78 54             	mov    %edi,0x54(%eax)
	return 0;
f0104a94:	e9 c6 fe ff ff       	jmp    f010495f <syscall+0x57>
		return -E_INVAL;
f0104a99:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a9e:	e9 bc fe ff ff       	jmp    f010495f <syscall+0x57>
		return -E_BAD_ENV;
f0104aa3:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
			return sys_env_set_status(a1, a2);
f0104aa8:	e9 b2 fe ff ff       	jmp    f010495f <syscall+0x57>
	struct Env* e = NULL;
f0104aad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if(envid2env(envid, &e, 1) < 0)
f0104ab4:	83 ec 04             	sub    $0x4,%esp
f0104ab7:	6a 01                	push   $0x1
f0104ab9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104abc:	50                   	push   %eax
f0104abd:	ff 75 0c             	pushl  0xc(%ebp)
f0104ac0:	e8 b4 e6 ff ff       	call   f0103179 <envid2env>
f0104ac5:	83 c4 10             	add    $0x10,%esp
f0104ac8:	85 c0                	test   %eax,%eax
f0104aca:	78 6e                	js     f0104b3a <syscall+0x232>
	if((uintptr_t)va >= UTOP || PGOFF(va))
f0104acc:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104ad3:	77 6f                	ja     f0104b44 <syscall+0x23c>
f0104ad5:	8b 45 10             	mov    0x10(%ebp),%eax
f0104ad8:	25 ff 0f 00 00       	and    $0xfff,%eax
	if(((perm & flag) != flag) || (perm & ~PTE_SYSCALL) != 0)
f0104add:	8b 55 14             	mov    0x14(%ebp),%edx
f0104ae0:	83 e2 05             	and    $0x5,%edx
f0104ae3:	83 fa 05             	cmp    $0x5,%edx
f0104ae6:	75 66                	jne    f0104b4e <syscall+0x246>
f0104ae8:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0104aeb:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0104af1:	09 c3                	or     %eax,%ebx
f0104af3:	75 63                	jne    f0104b58 <syscall+0x250>
	if((pp = page_alloc(ALLOC_ZERO)) == NULL)
f0104af5:	83 ec 0c             	sub    $0xc,%esp
f0104af8:	6a 01                	push   $0x1
f0104afa:	e8 ef c4 ff ff       	call   f0100fee <page_alloc>
f0104aff:	89 c6                	mov    %eax,%esi
f0104b01:	83 c4 10             	add    $0x10,%esp
f0104b04:	85 c0                	test   %eax,%eax
f0104b06:	74 5a                	je     f0104b62 <syscall+0x25a>
	if((r = page_insert(e->env_pgdir, pp, (void*)va, perm)) < 0){
f0104b08:	ff 75 14             	pushl  0x14(%ebp)
f0104b0b:	ff 75 10             	pushl  0x10(%ebp)
f0104b0e:	50                   	push   %eax
f0104b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104b12:	ff 70 60             	pushl  0x60(%eax)
f0104b15:	e8 10 c8 ff ff       	call   f010132a <page_insert>
f0104b1a:	89 c7                	mov    %eax,%edi
f0104b1c:	83 c4 10             	add    $0x10,%esp
f0104b1f:	85 c0                	test   %eax,%eax
f0104b21:	0f 89 38 fe ff ff    	jns    f010495f <syscall+0x57>
		page_free(pp);
f0104b27:	83 ec 0c             	sub    $0xc,%esp
f0104b2a:	56                   	push   %esi
f0104b2b:	e8 49 c5 ff ff       	call   f0101079 <page_free>
		return r;
f0104b30:	83 c4 10             	add    $0x10,%esp
f0104b33:	89 fb                	mov    %edi,%ebx
f0104b35:	e9 25 fe ff ff       	jmp    f010495f <syscall+0x57>
		return -E_BAD_ENV;
f0104b3a:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104b3f:	e9 1b fe ff ff       	jmp    f010495f <syscall+0x57>
		return -E_INVAL;
f0104b44:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b49:	e9 11 fe ff ff       	jmp    f010495f <syscall+0x57>
		return -E_INVAL;
f0104b4e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b53:	e9 07 fe ff ff       	jmp    f010495f <syscall+0x57>
f0104b58:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b5d:	e9 fd fd ff ff       	jmp    f010495f <syscall+0x57>
		return -E_NO_MEM;
f0104b62:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			return sys_page_alloc(a1, (void *) a2, a3);
f0104b67:	e9 f3 fd ff ff       	jmp    f010495f <syscall+0x57>
	struct Env* src = NULL;
f0104b6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	struct Env* dst = NULL;
f0104b73:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	if(envid2env(srcenvid, &src, 1) < 0 || envid2env(dstenvid, &dst, 1))
f0104b7a:	83 ec 04             	sub    $0x4,%esp
f0104b7d:	6a 01                	push   $0x1
f0104b7f:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104b82:	50                   	push   %eax
f0104b83:	ff 75 0c             	pushl  0xc(%ebp)
f0104b86:	e8 ee e5 ff ff       	call   f0103179 <envid2env>
f0104b8b:	83 c4 10             	add    $0x10,%esp
f0104b8e:	85 c0                	test   %eax,%eax
f0104b90:	0f 88 9a 00 00 00    	js     f0104c30 <syscall+0x328>
f0104b96:	83 ec 04             	sub    $0x4,%esp
f0104b99:	6a 01                	push   $0x1
f0104b9b:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104b9e:	50                   	push   %eax
f0104b9f:	ff 75 14             	pushl  0x14(%ebp)
f0104ba2:	e8 d2 e5 ff ff       	call   f0103179 <envid2env>
f0104ba7:	89 c3                	mov    %eax,%ebx
f0104ba9:	83 c4 10             	add    $0x10,%esp
f0104bac:	85 c0                	test   %eax,%eax
f0104bae:	0f 85 86 00 00 00    	jne    f0104c3a <syscall+0x332>
	if((uintptr_t)srcva >= UTOP || PGOFF(srcva))
f0104bb4:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104bbb:	0f 87 83 00 00 00    	ja     f0104c44 <syscall+0x33c>
	if((uintptr_t)dstva >= UTOP || PGOFF(dstva))
f0104bc1:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0104bc8:	0f 87 80 00 00 00    	ja     f0104c4e <syscall+0x346>
f0104bce:	8b 45 10             	mov    0x10(%ebp),%eax
f0104bd1:	0b 45 18             	or     0x18(%ebp),%eax
f0104bd4:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0104bd9:	75 7d                	jne    f0104c58 <syscall+0x350>
	pte_t* pte_addr = NULL;
f0104bdb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if((page = page_lookup(src->env_pgdir, srcva, &pte_addr)) == NULL)
f0104be2:	83 ec 04             	sub    $0x4,%esp
f0104be5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104be8:	50                   	push   %eax
f0104be9:	ff 75 10             	pushl  0x10(%ebp)
f0104bec:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104bef:	ff 70 60             	pushl  0x60(%eax)
f0104bf2:	e8 3d c6 ff ff       	call   f0101234 <page_lookup>
f0104bf7:	83 c4 10             	add    $0x10,%esp
f0104bfa:	85 c0                	test   %eax,%eax
f0104bfc:	74 64                	je     f0104c62 <syscall+0x35a>
	if(((perm & PTE_U) == 0) || ((perm & PTE_P) == 0) || ((perm & ~PTE_SYSCALL) != 0))
f0104bfe:	8b 55 1c             	mov    0x1c(%ebp),%edx
f0104c01:	81 e2 fd f1 ff ff    	and    $0xfffff1fd,%edx
f0104c07:	83 fa 05             	cmp    $0x5,%edx
f0104c0a:	75 60                	jne    f0104c6c <syscall+0x364>
	if(page_insert(dst->env_pgdir, page, dstva, perm) < 0)
f0104c0c:	ff 75 1c             	pushl  0x1c(%ebp)
f0104c0f:	ff 75 18             	pushl  0x18(%ebp)
f0104c12:	50                   	push   %eax
f0104c13:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104c16:	ff 70 60             	pushl  0x60(%eax)
f0104c19:	e8 0c c7 ff ff       	call   f010132a <page_insert>
f0104c1e:	83 c4 10             	add    $0x10,%esp
		return -E_NO_MEM;
f0104c21:	85 c0                	test   %eax,%eax
f0104c23:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0104c28:	0f 48 d8             	cmovs  %eax,%ebx
f0104c2b:	e9 2f fd ff ff       	jmp    f010495f <syscall+0x57>
		return -E_BAD_ENV;
f0104c30:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104c35:	e9 25 fd ff ff       	jmp    f010495f <syscall+0x57>
f0104c3a:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104c3f:	e9 1b fd ff ff       	jmp    f010495f <syscall+0x57>
		return -E_INVAL;
f0104c44:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104c49:	e9 11 fd ff ff       	jmp    f010495f <syscall+0x57>
		return -E_INVAL;
f0104c4e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104c53:	e9 07 fd ff ff       	jmp    f010495f <syscall+0x57>
f0104c58:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104c5d:	e9 fd fc ff ff       	jmp    f010495f <syscall+0x57>
		return -E_INVAL;
f0104c62:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104c67:	e9 f3 fc ff ff       	jmp    f010495f <syscall+0x57>
		return -E_INVAL;
f0104c6c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			return sys_page_map(a1, (void *) a2, a3, (void *) a4, a5);
f0104c71:	e9 e9 fc ff ff       	jmp    f010495f <syscall+0x57>
	if(envid2env(envid, &e, 1) < 0)
f0104c76:	83 ec 04             	sub    $0x4,%esp
f0104c79:	6a 01                	push   $0x1
f0104c7b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104c7e:	50                   	push   %eax
f0104c7f:	ff 75 0c             	pushl  0xc(%ebp)
f0104c82:	e8 f2 e4 ff ff       	call   f0103179 <envid2env>
f0104c87:	83 c4 10             	add    $0x10,%esp
f0104c8a:	85 c0                	test   %eax,%eax
f0104c8c:	78 30                	js     f0104cbe <syscall+0x3b6>
	if((uintptr_t)va >= UTOP || PGOFF(va))
f0104c8e:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104c95:	77 31                	ja     f0104cc8 <syscall+0x3c0>
f0104c97:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104c9e:	75 32                	jne    f0104cd2 <syscall+0x3ca>
	page_remove(e->env_pgdir, va);
f0104ca0:	83 ec 08             	sub    $0x8,%esp
f0104ca3:	ff 75 10             	pushl  0x10(%ebp)
f0104ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104ca9:	ff 70 60             	pushl  0x60(%eax)
f0104cac:	e8 2f c6 ff ff       	call   f01012e0 <page_remove>
	return 0;
f0104cb1:	83 c4 10             	add    $0x10,%esp
f0104cb4:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104cb9:	e9 a1 fc ff ff       	jmp    f010495f <syscall+0x57>
		return -E_BAD_ENV;
f0104cbe:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104cc3:	e9 97 fc ff ff       	jmp    f010495f <syscall+0x57>
		return -E_INVAL;
f0104cc8:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ccd:	e9 8d fc ff ff       	jmp    f010495f <syscall+0x57>
f0104cd2:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			return sys_page_unmap(a1, (void *) a2);
f0104cd7:	e9 83 fc ff ff       	jmp    f010495f <syscall+0x57>
	if(envid2env(envid, &e, 1) < 0)
f0104cdc:	83 ec 04             	sub    $0x4,%esp
f0104cdf:	6a 01                	push   $0x1
f0104ce1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104ce4:	50                   	push   %eax
f0104ce5:	ff 75 0c             	pushl  0xc(%ebp)
f0104ce8:	e8 8c e4 ff ff       	call   f0103179 <envid2env>
f0104ced:	83 c4 10             	add    $0x10,%esp
f0104cf0:	85 c0                	test   %eax,%eax
f0104cf2:	78 13                	js     f0104d07 <syscall+0x3ff>
	e->env_pgfault_upcall = func;
f0104cf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104cf7:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104cfa:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f0104cfd:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104d02:	e9 58 fc ff ff       	jmp    f010495f <syscall+0x57>
		return -E_BAD_ENV;
f0104d07:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
			return sys_env_set_pgfault_upcall(a1, (void *) a2);
f0104d0c:	e9 4e fc ff ff       	jmp    f010495f <syscall+0x57>
	if((r = envid2env(envid, &rec_env, 0)) < 0){
f0104d11:	83 ec 04             	sub    $0x4,%esp
f0104d14:	6a 00                	push   $0x0
f0104d16:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104d19:	50                   	push   %eax
f0104d1a:	ff 75 0c             	pushl  0xc(%ebp)
f0104d1d:	e8 57 e4 ff ff       	call   f0103179 <envid2env>
f0104d22:	89 c3                	mov    %eax,%ebx
f0104d24:	83 c4 10             	add    $0x10,%esp
f0104d27:	85 c0                	test   %eax,%eax
f0104d29:	0f 88 30 fc ff ff    	js     f010495f <syscall+0x57>
	if(!rec_env->env_ipc_recving){
f0104d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104d32:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0104d36:	0f 84 de 00 00 00    	je     f0104e1a <syscall+0x512>
	if((uintptr_t)srcva < UTOP){
f0104d3c:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0104d43:	0f 87 8c 00 00 00    	ja     f0104dd5 <syscall+0x4cd>
		if((uintptr_t)srcva & (PGSIZE - 1)){
f0104d49:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f0104d50:	0f 85 ce 00 00 00    	jne    f0104e24 <syscall+0x51c>
		if((perm & PTE_U) != PTE_U || (perm & PTE_P) != PTE_P){
f0104d56:	8b 45 18             	mov    0x18(%ebp),%eax
f0104d59:	83 e0 05             	and    $0x5,%eax
f0104d5c:	83 f8 05             	cmp    $0x5,%eax
f0104d5f:	0f 85 c9 00 00 00    	jne    f0104e2e <syscall+0x526>
		if(!(pg = page_lookup(curenv->env_pgdir, srcva, &pte))){
f0104d65:	e8 f8 13 00 00       	call   f0106162 <cpunum>
f0104d6a:	83 ec 04             	sub    $0x4,%esp
f0104d6d:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104d70:	52                   	push   %edx
f0104d71:	ff 75 14             	pushl  0x14(%ebp)
f0104d74:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d77:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104d7d:	ff 70 60             	pushl  0x60(%eax)
f0104d80:	e8 af c4 ff ff       	call   f0101234 <page_lookup>
f0104d85:	83 c4 10             	add    $0x10,%esp
f0104d88:	85 c0                	test   %eax,%eax
f0104d8a:	0f 84 a8 00 00 00    	je     f0104e38 <syscall+0x530>
		if((perm & PTE_W) && ((size_t) *pte & PTE_W) != PTE_W){
f0104d90:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104d94:	74 0c                	je     f0104da2 <syscall+0x49a>
f0104d96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104d99:	f6 02 02             	testb  $0x2,(%edx)
f0104d9c:	0f 84 a0 00 00 00    	je     f0104e42 <syscall+0x53a>
		if((uintptr_t)rec_env->env_ipc_dstva < UTOP){
f0104da2:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104da5:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0104da8:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0104dae:	77 2c                	ja     f0104ddc <syscall+0x4d4>
			if((r = page_insert(rec_env->env_pgdir, pg, rec_env->env_ipc_dstva, perm)) < 0){
f0104db0:	ff 75 18             	pushl  0x18(%ebp)
f0104db3:	51                   	push   %ecx
f0104db4:	50                   	push   %eax
f0104db5:	ff 72 60             	pushl  0x60(%edx)
f0104db8:	e8 6d c5 ff ff       	call   f010132a <page_insert>
f0104dbd:	89 c3                	mov    %eax,%ebx
f0104dbf:	83 c4 10             	add    $0x10,%esp
f0104dc2:	85 c0                	test   %eax,%eax
f0104dc4:	0f 88 95 fb ff ff    	js     f010495f <syscall+0x57>
			rec_env->env_ipc_perm = perm;
f0104dca:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104dcd:	8b 7d 18             	mov    0x18(%ebp),%edi
f0104dd0:	89 78 78             	mov    %edi,0x78(%eax)
f0104dd3:	eb 07                	jmp    f0104ddc <syscall+0x4d4>
		rec_env->env_ipc_perm = 0;
f0104dd5:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
	rec_env->env_ipc_recving = 0;
f0104ddc:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104ddf:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	rec_env->env_ipc_from = curenv->env_id;
f0104de3:	e8 7a 13 00 00       	call   f0106162 <cpunum>
f0104de8:	89 c2                	mov    %eax,%edx
f0104dea:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104ded:	6b d2 74             	imul   $0x74,%edx,%edx
f0104df0:	8b 92 28 80 21 f0    	mov    -0xfde7fd8(%edx),%edx
f0104df6:	8b 52 48             	mov    0x48(%edx),%edx
f0104df9:	89 50 74             	mov    %edx,0x74(%eax)
	rec_env->env_ipc_value = value;
f0104dfc:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104dff:	89 48 70             	mov    %ecx,0x70(%eax)
	rec_env->env_status = ENV_RUNNABLE;
f0104e02:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	rec_env->env_tf.tf_regs.reg_eax = 0;
f0104e09:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return 0;
f0104e10:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104e15:	e9 45 fb ff ff       	jmp    f010495f <syscall+0x57>
		return -E_IPC_NOT_RECV;
f0104e1a:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f0104e1f:	e9 3b fb ff ff       	jmp    f010495f <syscall+0x57>
			return -E_INVAL;
f0104e24:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104e29:	e9 31 fb ff ff       	jmp    f010495f <syscall+0x57>
			return -E_INVAL;
f0104e2e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104e33:	e9 27 fb ff ff       	jmp    f010495f <syscall+0x57>
			return -E_INVAL;
f0104e38:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104e3d:	e9 1d fb ff ff       	jmp    f010495f <syscall+0x57>
			return -E_INVAL;
f0104e42:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			return sys_ipc_try_send(a1, a2, (void *) a3, a4);
f0104e47:	e9 13 fb ff ff       	jmp    f010495f <syscall+0x57>
	if((uintptr_t)dstva < UTOP && (uintptr_t)dstva & (PGSIZE - 1)){
f0104e4c:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0104e53:	77 13                	ja     f0104e68 <syscall+0x560>
f0104e55:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0104e5c:	74 0a                	je     f0104e68 <syscall+0x560>
			return sys_ipc_recv((void *) a1);
f0104e5e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104e63:	e9 f7 fa ff ff       	jmp    f010495f <syscall+0x57>
	curenv->env_ipc_recving = 1;
f0104e68:	e8 f5 12 00 00       	call   f0106162 <cpunum>
f0104e6d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e70:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104e76:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f0104e7a:	e8 e3 12 00 00       	call   f0106162 <cpunum>
f0104e7f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e82:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104e88:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0104e8b:	89 78 6c             	mov    %edi,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0104e8e:	e8 cf 12 00 00       	call   f0106162 <cpunum>
f0104e93:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e96:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104e9c:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0104ea3:	e8 b1 f9 ff ff       	call   f0104859 <sched_yield>
	if ((r = envid2env(envid, &env, 1)) < 0) return r;
f0104ea8:	83 ec 04             	sub    $0x4,%esp
f0104eab:	6a 01                	push   $0x1
f0104ead:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104eb0:	50                   	push   %eax
f0104eb1:	ff 75 0c             	pushl  0xc(%ebp)
f0104eb4:	e8 c0 e2 ff ff       	call   f0103179 <envid2env>
f0104eb9:	89 c3                	mov    %eax,%ebx
f0104ebb:	83 c4 10             	add    $0x10,%esp
f0104ebe:	85 c0                	test   %eax,%eax
f0104ec0:	0f 88 99 fa ff ff    	js     f010495f <syscall+0x57>
	env->env_tf = *tf;
f0104ec6:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104ecb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104ece:	8b 75 10             	mov    0x10(%ebp),%esi
f0104ed1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	env->env_tf.tf_eflags |= FL_IF;
f0104ed3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	env->env_tf.tf_eflags &= ~FL_IOPL_MASK;
f0104ed6:	8b 42 38             	mov    0x38(%edx),%eax
f0104ed9:	80 e4 cf             	and    $0xcf,%ah
f0104edc:	80 cc 02             	or     $0x2,%ah
f0104edf:	89 42 38             	mov    %eax,0x38(%edx)
	env->env_tf.tf_cs = GD_UT | 3;
f0104ee2:	66 c7 42 34 1b 00    	movw   $0x1b,0x34(%edx)
	return 0;
f0104ee8:	bb 00 00 00 00       	mov    $0x0,%ebx
			return sys_env_set_trapframe(a1, (struct Trapframe*)a2);
f0104eed:	e9 6d fa ff ff       	jmp    f010495f <syscall+0x57>
			return 0;
f0104ef2:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ef7:	e9 63 fa ff ff       	jmp    f010495f <syscall+0x57>

f0104efc <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0104efc:	55                   	push   %ebp
f0104efd:	89 e5                	mov    %esp,%ebp
f0104eff:	57                   	push   %edi
f0104f00:	56                   	push   %esi
f0104f01:	53                   	push   %ebx
f0104f02:	83 ec 14             	sub    $0x14,%esp
f0104f05:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104f08:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104f0b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104f0e:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104f11:	8b 1a                	mov    (%edx),%ebx
f0104f13:	8b 01                	mov    (%ecx),%eax
f0104f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104f18:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104f1f:	eb 23                	jmp    f0104f44 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0104f21:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0104f24:	eb 1e                	jmp    f0104f44 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104f26:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104f29:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104f2c:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104f30:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104f33:	73 46                	jae    f0104f7b <stab_binsearch+0x7f>
			*region_left = m;
f0104f35:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104f38:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0104f3a:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0104f3d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104f44:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0104f47:	7f 5f                	jg     f0104fa8 <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f0104f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104f4c:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0104f4f:	89 d0                	mov    %edx,%eax
f0104f51:	c1 e8 1f             	shr    $0x1f,%eax
f0104f54:	01 d0                	add    %edx,%eax
f0104f56:	89 c7                	mov    %eax,%edi
f0104f58:	d1 ff                	sar    %edi
f0104f5a:	83 e0 fe             	and    $0xfffffffe,%eax
f0104f5d:	01 f8                	add    %edi,%eax
f0104f5f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104f62:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104f66:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0104f68:	39 c3                	cmp    %eax,%ebx
f0104f6a:	7f b5                	jg     f0104f21 <stab_binsearch+0x25>
f0104f6c:	0f b6 0a             	movzbl (%edx),%ecx
f0104f6f:	83 ea 0c             	sub    $0xc,%edx
f0104f72:	39 f1                	cmp    %esi,%ecx
f0104f74:	74 b0                	je     f0104f26 <stab_binsearch+0x2a>
			m--;
f0104f76:	83 e8 01             	sub    $0x1,%eax
f0104f79:	eb ed                	jmp    f0104f68 <stab_binsearch+0x6c>
		} else if (stabs[m].n_value > addr) {
f0104f7b:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104f7e:	76 14                	jbe    f0104f94 <stab_binsearch+0x98>
			*region_right = m - 1;
f0104f80:	83 e8 01             	sub    $0x1,%eax
f0104f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104f86:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104f89:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0104f8b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104f92:	eb b0                	jmp    f0104f44 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104f94:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104f97:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0104f99:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104f9d:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0104f9f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104fa6:	eb 9c                	jmp    f0104f44 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0104fa8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104fac:	75 15                	jne    f0104fc3 <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0104fae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104fb1:	8b 00                	mov    (%eax),%eax
f0104fb3:	83 e8 01             	sub    $0x1,%eax
f0104fb6:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104fb9:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0104fbb:	83 c4 14             	add    $0x14,%esp
f0104fbe:	5b                   	pop    %ebx
f0104fbf:	5e                   	pop    %esi
f0104fc0:	5f                   	pop    %edi
f0104fc1:	5d                   	pop    %ebp
f0104fc2:	c3                   	ret    
		for (l = *region_right;
f0104fc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104fc6:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104fc8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104fcb:	8b 0f                	mov    (%edi),%ecx
f0104fcd:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104fd0:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0104fd3:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0104fd7:	eb 03                	jmp    f0104fdc <stab_binsearch+0xe0>
		     l--)
f0104fd9:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104fdc:	39 c1                	cmp    %eax,%ecx
f0104fde:	7d 0a                	jge    f0104fea <stab_binsearch+0xee>
		     l > *region_left && stabs[l].n_type != type;
f0104fe0:	0f b6 1a             	movzbl (%edx),%ebx
f0104fe3:	83 ea 0c             	sub    $0xc,%edx
f0104fe6:	39 f3                	cmp    %esi,%ebx
f0104fe8:	75 ef                	jne    f0104fd9 <stab_binsearch+0xdd>
		*region_left = l;
f0104fea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104fed:	89 07                	mov    %eax,(%edi)
}
f0104fef:	eb ca                	jmp    f0104fbb <stab_binsearch+0xbf>

f0104ff1 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104ff1:	f3 0f 1e fb          	endbr32 
f0104ff5:	55                   	push   %ebp
f0104ff6:	89 e5                	mov    %esp,%ebp
f0104ff8:	57                   	push   %edi
f0104ff9:	56                   	push   %esi
f0104ffa:	53                   	push   %ebx
f0104ffb:	83 ec 4c             	sub    $0x4c,%esp
f0104ffe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105001:	c7 03 38 80 10 f0    	movl   $0xf0108038,(%ebx)
	info->eip_line = 0;
f0105007:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f010500e:	c7 43 08 38 80 10 f0 	movl   $0xf0108038,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0105015:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f010501c:	8b 45 08             	mov    0x8(%ebp),%eax
f010501f:	89 43 10             	mov    %eax,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105022:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105029:	3d ff ff 7f ef       	cmp    $0xef7fffff,%eax
f010502e:	0f 86 10 01 00 00    	jbe    f0105144 <debuginfo_eip+0x153>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0105034:	c7 45 bc da 89 11 f0 	movl   $0xf01189da,-0x44(%ebp)
		stabstr = __STABSTR_BEGIN__;
f010503b:	c7 45 b4 c5 51 11 f0 	movl   $0xf01151c5,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0105042:	bf c4 51 11 f0       	mov    $0xf01151c4,%edi
		stabs = __STAB_BEGIN__;
f0105047:	c7 45 b8 d0 85 10 f0 	movl   $0xf01085d0,-0x48(%ebp)
                               (uintptr_t)stabstr_end - (uintptr_t)stabstr, PTE_U) < 0))
        	return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f010504e:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105051:	39 75 b4             	cmp    %esi,-0x4c(%ebp)
f0105054:	0f 83 76 02 00 00    	jae    f01052d0 <debuginfo_eip+0x2df>
f010505a:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
f010505e:	0f 85 73 02 00 00    	jne    f01052d7 <debuginfo_eip+0x2e6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0105064:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f010506b:	8b 75 b8             	mov    -0x48(%ebp),%esi
f010506e:	29 f7                	sub    %esi,%edi
f0105070:	c1 ff 02             	sar    $0x2,%edi
f0105073:	69 c7 ab aa aa aa    	imul   $0xaaaaaaab,%edi,%eax
f0105079:	83 e8 01             	sub    $0x1,%eax
f010507c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f010507f:	83 ec 08             	sub    $0x8,%esp
f0105082:	ff 75 08             	pushl  0x8(%ebp)
f0105085:	6a 64                	push   $0x64
f0105087:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f010508a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010508d:	89 f0                	mov    %esi,%eax
f010508f:	e8 68 fe ff ff       	call   f0104efc <stab_binsearch>
	if (lfile == 0)
f0105094:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105097:	83 c4 10             	add    $0x10,%esp
f010509a:	85 c0                	test   %eax,%eax
f010509c:	0f 84 3c 02 00 00    	je     f01052de <debuginfo_eip+0x2ed>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f01050a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f01050a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01050a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f01050ab:	83 ec 08             	sub    $0x8,%esp
f01050ae:	ff 75 08             	pushl  0x8(%ebp)
f01050b1:	6a 24                	push   $0x24
f01050b3:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f01050b6:	8d 55 dc             	lea    -0x24(%ebp),%edx
f01050b9:	89 f0                	mov    %esi,%eax
f01050bb:	e8 3c fe ff ff       	call   f0104efc <stab_binsearch>

	if (lfun <= rfun) {
f01050c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01050c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01050c6:	83 c4 10             	add    $0x10,%esp
f01050c9:	39 d0                	cmp    %edx,%eax
f01050cb:	0f 8f 44 01 00 00    	jg     f0105215 <debuginfo_eip+0x224>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f01050d1:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f01050d4:	8d 3c 8e             	lea    (%esi,%ecx,4),%edi
f01050d7:	8b 0f                	mov    (%edi),%ecx
f01050d9:	8b 75 bc             	mov    -0x44(%ebp),%esi
f01050dc:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f01050df:	39 f1                	cmp    %esi,%ecx
f01050e1:	73 06                	jae    f01050e9 <debuginfo_eip+0xf8>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f01050e3:	03 4d b4             	add    -0x4c(%ebp),%ecx
f01050e6:	89 4b 08             	mov    %ecx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f01050e9:	8b 4f 08             	mov    0x8(%edi),%ecx
f01050ec:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f01050ef:	29 4d 08             	sub    %ecx,0x8(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
f01050f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f01050f5:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f01050f8:	83 ec 08             	sub    $0x8,%esp
f01050fb:	6a 3a                	push   $0x3a
f01050fd:	ff 73 08             	pushl  0x8(%ebx)
f0105100:	e8 1d 0a 00 00       	call   f0105b22 <strfind>
f0105105:	2b 43 08             	sub    0x8(%ebx),%eax
f0105108:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f010510b:	83 c4 08             	add    $0x8,%esp
f010510e:	ff 75 08             	pushl  0x8(%ebp)
f0105111:	6a 44                	push   $0x44
f0105113:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105116:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105119:	8b 75 b8             	mov    -0x48(%ebp),%esi
f010511c:	89 f0                	mov    %esi,%eax
f010511e:	e8 d9 fd ff ff       	call   f0104efc <stab_binsearch>
	info->eip_line = stabs[lline].n_desc;
f0105123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105126:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105129:	0f b7 4c 96 06       	movzwl 0x6(%esi,%edx,4),%ecx
f010512e:	89 4b 04             	mov    %ecx,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105131:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105134:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0105138:	83 c4 10             	add    $0x10,%esp
f010513b:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f010513f:	e9 f2 00 00 00       	jmp    f0105236 <debuginfo_eip+0x245>
		if(curenv && user_mem_check(curenv, (void*)usd, sizeof(struct UserStabData), PTE_U) < 0){
f0105144:	e8 19 10 00 00       	call   f0106162 <cpunum>
f0105149:	6b c0 74             	imul   $0x74,%eax,%eax
f010514c:	83 b8 28 80 21 f0 00 	cmpl   $0x0,-0xfde7fd8(%eax)
f0105153:	74 27                	je     f010517c <debuginfo_eip+0x18b>
f0105155:	e8 08 10 00 00       	call   f0106162 <cpunum>
f010515a:	6a 04                	push   $0x4
f010515c:	6a 10                	push   $0x10
f010515e:	68 00 00 20 00       	push   $0x200000
f0105163:	6b c0 74             	imul   $0x74,%eax,%eax
f0105166:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f010516c:	e8 ad de ff ff       	call   f010301e <user_mem_check>
f0105171:	83 c4 10             	add    $0x10,%esp
f0105174:	85 c0                	test   %eax,%eax
f0105176:	0f 88 46 01 00 00    	js     f01052c2 <debuginfo_eip+0x2d1>
		stabs = usd->stabs;
f010517c:	8b 35 00 00 20 00    	mov    0x200000,%esi
f0105182:	89 75 b8             	mov    %esi,-0x48(%ebp)
		stab_end = usd->stab_end;
f0105185:	8b 3d 04 00 20 00    	mov    0x200004,%edi
		stabstr = usd->stabstr;
f010518b:	a1 08 00 20 00       	mov    0x200008,%eax
f0105190:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105193:	8b 0d 0c 00 20 00    	mov    0x20000c,%ecx
f0105199:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		if (curenv && (
f010519c:	e8 c1 0f 00 00       	call   f0106162 <cpunum>
f01051a1:	6b c0 74             	imul   $0x74,%eax,%eax
f01051a4:	83 b8 28 80 21 f0 00 	cmpl   $0x0,-0xfde7fd8(%eax)
f01051ab:	0f 84 9d fe ff ff    	je     f010504e <debuginfo_eip+0x5d>
                user_mem_check(curenv, (void*)stabs, 
f01051b1:	89 fa                	mov    %edi,%edx
f01051b3:	29 f2                	sub    %esi,%edx
f01051b5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f01051b8:	e8 a5 0f 00 00       	call   f0106162 <cpunum>
f01051bd:	6a 04                	push   $0x4
f01051bf:	ff 75 c4             	pushl  -0x3c(%ebp)
f01051c2:	56                   	push   %esi
f01051c3:	6b c0 74             	imul   $0x74,%eax,%eax
f01051c6:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f01051cc:	e8 4d de ff ff       	call   f010301e <user_mem_check>
		if (curenv && (
f01051d1:	83 c4 10             	add    $0x10,%esp
f01051d4:	85 c0                	test   %eax,%eax
f01051d6:	0f 88 ed 00 00 00    	js     f01052c9 <debuginfo_eip+0x2d8>
                user_mem_check(curenv, (void*)stabstr, 
f01051dc:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f01051df:	8b 75 b4             	mov    -0x4c(%ebp),%esi
f01051e2:	29 f1                	sub    %esi,%ecx
f01051e4:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f01051e7:	e8 76 0f 00 00       	call   f0106162 <cpunum>
f01051ec:	6a 04                	push   $0x4
f01051ee:	ff 75 c4             	pushl  -0x3c(%ebp)
f01051f1:	56                   	push   %esi
f01051f2:	6b c0 74             	imul   $0x74,%eax,%eax
f01051f5:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f01051fb:	e8 1e de ff ff       	call   f010301e <user_mem_check>
                               (uintptr_t)stab_end - (uintptr_t)stabs, PTE_U) < 0 || 
f0105200:	83 c4 10             	add    $0x10,%esp
f0105203:	85 c0                	test   %eax,%eax
f0105205:	0f 89 43 fe ff ff    	jns    f010504e <debuginfo_eip+0x5d>
        	return -1;
f010520b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105210:	e9 d5 00 00 00       	jmp    f01052ea <debuginfo_eip+0x2f9>
		info->eip_fn_addr = addr;
f0105215:	8b 45 08             	mov    0x8(%ebp),%eax
f0105218:	89 43 10             	mov    %eax,0x10(%ebx)
		lline = lfile;
f010521b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010521e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105221:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105224:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105227:	e9 cc fe ff ff       	jmp    f01050f8 <debuginfo_eip+0x107>
f010522c:	83 e8 01             	sub    $0x1,%eax
f010522f:	83 ea 0c             	sub    $0xc,%edx
	while (lline >= lfile
f0105232:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0105236:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0105239:	39 c7                	cmp    %eax,%edi
f010523b:	7f 45                	jg     f0105282 <debuginfo_eip+0x291>
	       && stabs[lline].n_type != N_SOL
f010523d:	0f b6 0a             	movzbl (%edx),%ecx
f0105240:	80 f9 84             	cmp    $0x84,%cl
f0105243:	74 19                	je     f010525e <debuginfo_eip+0x26d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105245:	80 f9 64             	cmp    $0x64,%cl
f0105248:	75 e2                	jne    f010522c <debuginfo_eip+0x23b>
f010524a:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f010524e:	74 dc                	je     f010522c <debuginfo_eip+0x23b>
f0105250:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105254:	74 11                	je     f0105267 <debuginfo_eip+0x276>
f0105256:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0105259:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f010525c:	eb 09                	jmp    f0105267 <debuginfo_eip+0x276>
f010525e:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105262:	74 03                	je     f0105267 <debuginfo_eip+0x276>
f0105264:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105267:	8d 04 40             	lea    (%eax,%eax,2),%eax
f010526a:	8b 7d b8             	mov    -0x48(%ebp),%edi
f010526d:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105270:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0105273:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0105276:	29 f8                	sub    %edi,%eax
f0105278:	39 c2                	cmp    %eax,%edx
f010527a:	73 06                	jae    f0105282 <debuginfo_eip+0x291>
		info->eip_file = stabstr + stabs[lline].n_strx;
f010527c:	89 f8                	mov    %edi,%eax
f010527e:	01 d0                	add    %edx,%eax
f0105280:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105282:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105285:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105288:	ba 00 00 00 00       	mov    $0x0,%edx
	if (lfun < rfun)
f010528d:	39 f0                	cmp    %esi,%eax
f010528f:	7d 59                	jge    f01052ea <debuginfo_eip+0x2f9>
		for (lline = lfun + 1;
f0105291:	8d 50 01             	lea    0x1(%eax),%edx
f0105294:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105297:	89 d0                	mov    %edx,%eax
f0105299:	8d 14 52             	lea    (%edx,%edx,2),%edx
f010529c:	8b 7d b8             	mov    -0x48(%ebp),%edi
f010529f:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f01052a3:	eb 04                	jmp    f01052a9 <debuginfo_eip+0x2b8>
			info->eip_fn_narg++;
f01052a5:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f01052a9:	39 c6                	cmp    %eax,%esi
f01052ab:	7e 38                	jle    f01052e5 <debuginfo_eip+0x2f4>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01052ad:	0f b6 0a             	movzbl (%edx),%ecx
f01052b0:	83 c0 01             	add    $0x1,%eax
f01052b3:	83 c2 0c             	add    $0xc,%edx
f01052b6:	80 f9 a0             	cmp    $0xa0,%cl
f01052b9:	74 ea                	je     f01052a5 <debuginfo_eip+0x2b4>
	return 0;
f01052bb:	ba 00 00 00 00       	mov    $0x0,%edx
f01052c0:	eb 28                	jmp    f01052ea <debuginfo_eip+0x2f9>
			return -1;
f01052c2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01052c7:	eb 21                	jmp    f01052ea <debuginfo_eip+0x2f9>
        	return -1;
f01052c9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01052ce:	eb 1a                	jmp    f01052ea <debuginfo_eip+0x2f9>
		return -1;
f01052d0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01052d5:	eb 13                	jmp    f01052ea <debuginfo_eip+0x2f9>
f01052d7:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01052dc:	eb 0c                	jmp    f01052ea <debuginfo_eip+0x2f9>
		return -1;
f01052de:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01052e3:	eb 05                	jmp    f01052ea <debuginfo_eip+0x2f9>
	return 0;
f01052e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
f01052ea:	89 d0                	mov    %edx,%eax
f01052ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01052ef:	5b                   	pop    %ebx
f01052f0:	5e                   	pop    %esi
f01052f1:	5f                   	pop    %edi
f01052f2:	5d                   	pop    %ebp
f01052f3:	c3                   	ret    

f01052f4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f01052f4:	55                   	push   %ebp
f01052f5:	89 e5                	mov    %esp,%ebp
f01052f7:	57                   	push   %edi
f01052f8:	56                   	push   %esi
f01052f9:	53                   	push   %ebx
f01052fa:	83 ec 1c             	sub    $0x1c,%esp
f01052fd:	89 c7                	mov    %eax,%edi
f01052ff:	89 d6                	mov    %edx,%esi
f0105301:	8b 45 08             	mov    0x8(%ebp),%eax
f0105304:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105307:	89 d1                	mov    %edx,%ecx
f0105309:	89 c2                	mov    %eax,%edx
f010530b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010530e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105311:	8b 45 10             	mov    0x10(%ebp),%eax
f0105314:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0105317:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010531a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0105321:	39 c2                	cmp    %eax,%edx
f0105323:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0105326:	72 3e                	jb     f0105366 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0105328:	83 ec 0c             	sub    $0xc,%esp
f010532b:	ff 75 18             	pushl  0x18(%ebp)
f010532e:	83 eb 01             	sub    $0x1,%ebx
f0105331:	53                   	push   %ebx
f0105332:	50                   	push   %eax
f0105333:	83 ec 08             	sub    $0x8,%esp
f0105336:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105339:	ff 75 e0             	pushl  -0x20(%ebp)
f010533c:	ff 75 dc             	pushl  -0x24(%ebp)
f010533f:	ff 75 d8             	pushl  -0x28(%ebp)
f0105342:	e8 39 12 00 00       	call   f0106580 <__udivdi3>
f0105347:	83 c4 18             	add    $0x18,%esp
f010534a:	52                   	push   %edx
f010534b:	50                   	push   %eax
f010534c:	89 f2                	mov    %esi,%edx
f010534e:	89 f8                	mov    %edi,%eax
f0105350:	e8 9f ff ff ff       	call   f01052f4 <printnum>
f0105355:	83 c4 20             	add    $0x20,%esp
f0105358:	eb 13                	jmp    f010536d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f010535a:	83 ec 08             	sub    $0x8,%esp
f010535d:	56                   	push   %esi
f010535e:	ff 75 18             	pushl  0x18(%ebp)
f0105361:	ff d7                	call   *%edi
f0105363:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0105366:	83 eb 01             	sub    $0x1,%ebx
f0105369:	85 db                	test   %ebx,%ebx
f010536b:	7f ed                	jg     f010535a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f010536d:	83 ec 08             	sub    $0x8,%esp
f0105370:	56                   	push   %esi
f0105371:	83 ec 04             	sub    $0x4,%esp
f0105374:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105377:	ff 75 e0             	pushl  -0x20(%ebp)
f010537a:	ff 75 dc             	pushl  -0x24(%ebp)
f010537d:	ff 75 d8             	pushl  -0x28(%ebp)
f0105380:	e8 0b 13 00 00       	call   f0106690 <__umoddi3>
f0105385:	83 c4 14             	add    $0x14,%esp
f0105388:	0f be 80 42 80 10 f0 	movsbl -0xfef7fbe(%eax),%eax
f010538f:	50                   	push   %eax
f0105390:	ff d7                	call   *%edi
}
f0105392:	83 c4 10             	add    $0x10,%esp
f0105395:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105398:	5b                   	pop    %ebx
f0105399:	5e                   	pop    %esi
f010539a:	5f                   	pop    %edi
f010539b:	5d                   	pop    %ebp
f010539c:	c3                   	ret    

f010539d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f010539d:	f3 0f 1e fb          	endbr32 
f01053a1:	55                   	push   %ebp
f01053a2:	89 e5                	mov    %esp,%ebp
f01053a4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01053a7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f01053ab:	8b 10                	mov    (%eax),%edx
f01053ad:	3b 50 04             	cmp    0x4(%eax),%edx
f01053b0:	73 0a                	jae    f01053bc <sprintputch+0x1f>
		*b->buf++ = ch;
f01053b2:	8d 4a 01             	lea    0x1(%edx),%ecx
f01053b5:	89 08                	mov    %ecx,(%eax)
f01053b7:	8b 45 08             	mov    0x8(%ebp),%eax
f01053ba:	88 02                	mov    %al,(%edx)
}
f01053bc:	5d                   	pop    %ebp
f01053bd:	c3                   	ret    

f01053be <printfmt>:
{
f01053be:	f3 0f 1e fb          	endbr32 
f01053c2:	55                   	push   %ebp
f01053c3:	89 e5                	mov    %esp,%ebp
f01053c5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f01053c8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f01053cb:	50                   	push   %eax
f01053cc:	ff 75 10             	pushl  0x10(%ebp)
f01053cf:	ff 75 0c             	pushl  0xc(%ebp)
f01053d2:	ff 75 08             	pushl  0x8(%ebp)
f01053d5:	e8 05 00 00 00       	call   f01053df <vprintfmt>
}
f01053da:	83 c4 10             	add    $0x10,%esp
f01053dd:	c9                   	leave  
f01053de:	c3                   	ret    

f01053df <vprintfmt>:
{
f01053df:	f3 0f 1e fb          	endbr32 
f01053e3:	55                   	push   %ebp
f01053e4:	89 e5                	mov    %esp,%ebp
f01053e6:	57                   	push   %edi
f01053e7:	56                   	push   %esi
f01053e8:	53                   	push   %ebx
f01053e9:	83 ec 3c             	sub    $0x3c,%esp
f01053ec:	8b 75 08             	mov    0x8(%ebp),%esi
f01053ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01053f2:	8b 7d 10             	mov    0x10(%ebp),%edi
f01053f5:	e9 8e 03 00 00       	jmp    f0105788 <vprintfmt+0x3a9>
		padc = ' ';
f01053fa:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
f01053fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
f0105405:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f010540c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105413:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105418:	8d 47 01             	lea    0x1(%edi),%eax
f010541b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010541e:	0f b6 17             	movzbl (%edi),%edx
f0105421:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105424:	3c 55                	cmp    $0x55,%al
f0105426:	0f 87 df 03 00 00    	ja     f010580b <vprintfmt+0x42c>
f010542c:	0f b6 c0             	movzbl %al,%eax
f010542f:	3e ff 24 85 80 81 10 	notrack jmp *-0xfef7e80(,%eax,4)
f0105436:	f0 
f0105437:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f010543a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f010543e:	eb d8                	jmp    f0105418 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f0105440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105443:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f0105447:	eb cf                	jmp    f0105418 <vprintfmt+0x39>
f0105449:	0f b6 d2             	movzbl %dl,%edx
f010544c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f010544f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105454:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f0105457:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010545a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f010545e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0105461:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0105464:	83 f9 09             	cmp    $0x9,%ecx
f0105467:	77 55                	ja     f01054be <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
f0105469:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f010546c:	eb e9                	jmp    f0105457 <vprintfmt+0x78>
			precision = va_arg(ap, int);
f010546e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105471:	8b 00                	mov    (%eax),%eax
f0105473:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105476:	8b 45 14             	mov    0x14(%ebp),%eax
f0105479:	8d 40 04             	lea    0x4(%eax),%eax
f010547c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010547f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105482:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105486:	79 90                	jns    f0105418 <vprintfmt+0x39>
				width = precision, precision = -1;
f0105488:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010548b:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010548e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0105495:	eb 81                	jmp    f0105418 <vprintfmt+0x39>
f0105497:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010549a:	85 c0                	test   %eax,%eax
f010549c:	ba 00 00 00 00       	mov    $0x0,%edx
f01054a1:	0f 49 d0             	cmovns %eax,%edx
f01054a4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01054a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f01054aa:	e9 69 ff ff ff       	jmp    f0105418 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f01054af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f01054b2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
f01054b9:	e9 5a ff ff ff       	jmp    f0105418 <vprintfmt+0x39>
f01054be:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01054c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01054c4:	eb bc                	jmp    f0105482 <vprintfmt+0xa3>
			lflag++;
f01054c6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f01054c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f01054cc:	e9 47 ff ff ff       	jmp    f0105418 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
f01054d1:	8b 45 14             	mov    0x14(%ebp),%eax
f01054d4:	8d 78 04             	lea    0x4(%eax),%edi
f01054d7:	83 ec 08             	sub    $0x8,%esp
f01054da:	53                   	push   %ebx
f01054db:	ff 30                	pushl  (%eax)
f01054dd:	ff d6                	call   *%esi
			break;
f01054df:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f01054e2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f01054e5:	e9 9b 02 00 00       	jmp    f0105785 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
f01054ea:	8b 45 14             	mov    0x14(%ebp),%eax
f01054ed:	8d 78 04             	lea    0x4(%eax),%edi
f01054f0:	8b 00                	mov    (%eax),%eax
f01054f2:	99                   	cltd   
f01054f3:	31 d0                	xor    %edx,%eax
f01054f5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01054f7:	83 f8 0f             	cmp    $0xf,%eax
f01054fa:	7f 23                	jg     f010551f <vprintfmt+0x140>
f01054fc:	8b 14 85 e0 82 10 f0 	mov    -0xfef7d20(,%eax,4),%edx
f0105503:	85 d2                	test   %edx,%edx
f0105505:	74 18                	je     f010551f <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
f0105507:	52                   	push   %edx
f0105508:	68 ce 6d 10 f0       	push   $0xf0106dce
f010550d:	53                   	push   %ebx
f010550e:	56                   	push   %esi
f010550f:	e8 aa fe ff ff       	call   f01053be <printfmt>
f0105514:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105517:	89 7d 14             	mov    %edi,0x14(%ebp)
f010551a:	e9 66 02 00 00       	jmp    f0105785 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
f010551f:	50                   	push   %eax
f0105520:	68 5a 80 10 f0       	push   $0xf010805a
f0105525:	53                   	push   %ebx
f0105526:	56                   	push   %esi
f0105527:	e8 92 fe ff ff       	call   f01053be <printfmt>
f010552c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010552f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105532:	e9 4e 02 00 00       	jmp    f0105785 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
f0105537:	8b 45 14             	mov    0x14(%ebp),%eax
f010553a:	83 c0 04             	add    $0x4,%eax
f010553d:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0105540:	8b 45 14             	mov    0x14(%ebp),%eax
f0105543:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f0105545:	85 d2                	test   %edx,%edx
f0105547:	b8 53 80 10 f0       	mov    $0xf0108053,%eax
f010554c:	0f 45 c2             	cmovne %edx,%eax
f010554f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f0105552:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105556:	7e 06                	jle    f010555e <vprintfmt+0x17f>
f0105558:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f010555c:	75 0d                	jne    f010556b <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
f010555e:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0105561:	89 c7                	mov    %eax,%edi
f0105563:	03 45 e0             	add    -0x20(%ebp),%eax
f0105566:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105569:	eb 55                	jmp    f01055c0 <vprintfmt+0x1e1>
f010556b:	83 ec 08             	sub    $0x8,%esp
f010556e:	ff 75 d8             	pushl  -0x28(%ebp)
f0105571:	ff 75 cc             	pushl  -0x34(%ebp)
f0105574:	e8 38 04 00 00       	call   f01059b1 <strnlen>
f0105579:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010557c:	29 c2                	sub    %eax,%edx
f010557e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0105581:	83 c4 10             	add    $0x10,%esp
f0105584:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
f0105586:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f010558a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f010558d:	85 ff                	test   %edi,%edi
f010558f:	7e 11                	jle    f01055a2 <vprintfmt+0x1c3>
					putch(padc, putdat);
f0105591:	83 ec 08             	sub    $0x8,%esp
f0105594:	53                   	push   %ebx
f0105595:	ff 75 e0             	pushl  -0x20(%ebp)
f0105598:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f010559a:	83 ef 01             	sub    $0x1,%edi
f010559d:	83 c4 10             	add    $0x10,%esp
f01055a0:	eb eb                	jmp    f010558d <vprintfmt+0x1ae>
f01055a2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f01055a5:	85 d2                	test   %edx,%edx
f01055a7:	b8 00 00 00 00       	mov    $0x0,%eax
f01055ac:	0f 49 c2             	cmovns %edx,%eax
f01055af:	29 c2                	sub    %eax,%edx
f01055b1:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01055b4:	eb a8                	jmp    f010555e <vprintfmt+0x17f>
					putch(ch, putdat);
f01055b6:	83 ec 08             	sub    $0x8,%esp
f01055b9:	53                   	push   %ebx
f01055ba:	52                   	push   %edx
f01055bb:	ff d6                	call   *%esi
f01055bd:	83 c4 10             	add    $0x10,%esp
f01055c0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01055c3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01055c5:	83 c7 01             	add    $0x1,%edi
f01055c8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01055cc:	0f be d0             	movsbl %al,%edx
f01055cf:	85 d2                	test   %edx,%edx
f01055d1:	74 4b                	je     f010561e <vprintfmt+0x23f>
f01055d3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01055d7:	78 06                	js     f01055df <vprintfmt+0x200>
f01055d9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f01055dd:	78 1e                	js     f01055fd <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
f01055df:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01055e3:	74 d1                	je     f01055b6 <vprintfmt+0x1d7>
f01055e5:	0f be c0             	movsbl %al,%eax
f01055e8:	83 e8 20             	sub    $0x20,%eax
f01055eb:	83 f8 5e             	cmp    $0x5e,%eax
f01055ee:	76 c6                	jbe    f01055b6 <vprintfmt+0x1d7>
					putch('?', putdat);
f01055f0:	83 ec 08             	sub    $0x8,%esp
f01055f3:	53                   	push   %ebx
f01055f4:	6a 3f                	push   $0x3f
f01055f6:	ff d6                	call   *%esi
f01055f8:	83 c4 10             	add    $0x10,%esp
f01055fb:	eb c3                	jmp    f01055c0 <vprintfmt+0x1e1>
f01055fd:	89 cf                	mov    %ecx,%edi
f01055ff:	eb 0e                	jmp    f010560f <vprintfmt+0x230>
				putch(' ', putdat);
f0105601:	83 ec 08             	sub    $0x8,%esp
f0105604:	53                   	push   %ebx
f0105605:	6a 20                	push   $0x20
f0105607:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105609:	83 ef 01             	sub    $0x1,%edi
f010560c:	83 c4 10             	add    $0x10,%esp
f010560f:	85 ff                	test   %edi,%edi
f0105611:	7f ee                	jg     f0105601 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
f0105613:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0105616:	89 45 14             	mov    %eax,0x14(%ebp)
f0105619:	e9 67 01 00 00       	jmp    f0105785 <vprintfmt+0x3a6>
f010561e:	89 cf                	mov    %ecx,%edi
f0105620:	eb ed                	jmp    f010560f <vprintfmt+0x230>
	if (lflag >= 2)
f0105622:	83 f9 01             	cmp    $0x1,%ecx
f0105625:	7f 1b                	jg     f0105642 <vprintfmt+0x263>
	else if (lflag)
f0105627:	85 c9                	test   %ecx,%ecx
f0105629:	74 63                	je     f010568e <vprintfmt+0x2af>
		return va_arg(*ap, long);
f010562b:	8b 45 14             	mov    0x14(%ebp),%eax
f010562e:	8b 00                	mov    (%eax),%eax
f0105630:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105633:	99                   	cltd   
f0105634:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105637:	8b 45 14             	mov    0x14(%ebp),%eax
f010563a:	8d 40 04             	lea    0x4(%eax),%eax
f010563d:	89 45 14             	mov    %eax,0x14(%ebp)
f0105640:	eb 17                	jmp    f0105659 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
f0105642:	8b 45 14             	mov    0x14(%ebp),%eax
f0105645:	8b 50 04             	mov    0x4(%eax),%edx
f0105648:	8b 00                	mov    (%eax),%eax
f010564a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010564d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105650:	8b 45 14             	mov    0x14(%ebp),%eax
f0105653:	8d 40 08             	lea    0x8(%eax),%eax
f0105656:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f0105659:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010565c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f010565f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f0105664:	85 c9                	test   %ecx,%ecx
f0105666:	0f 89 ff 00 00 00    	jns    f010576b <vprintfmt+0x38c>
				putch('-', putdat);
f010566c:	83 ec 08             	sub    $0x8,%esp
f010566f:	53                   	push   %ebx
f0105670:	6a 2d                	push   $0x2d
f0105672:	ff d6                	call   *%esi
				num = -(long long) num;
f0105674:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105677:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010567a:	f7 da                	neg    %edx
f010567c:	83 d1 00             	adc    $0x0,%ecx
f010567f:	f7 d9                	neg    %ecx
f0105681:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0105684:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105689:	e9 dd 00 00 00       	jmp    f010576b <vprintfmt+0x38c>
		return va_arg(*ap, int);
f010568e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105691:	8b 00                	mov    (%eax),%eax
f0105693:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105696:	99                   	cltd   
f0105697:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010569a:	8b 45 14             	mov    0x14(%ebp),%eax
f010569d:	8d 40 04             	lea    0x4(%eax),%eax
f01056a0:	89 45 14             	mov    %eax,0x14(%ebp)
f01056a3:	eb b4                	jmp    f0105659 <vprintfmt+0x27a>
	if (lflag >= 2)
f01056a5:	83 f9 01             	cmp    $0x1,%ecx
f01056a8:	7f 1e                	jg     f01056c8 <vprintfmt+0x2e9>
	else if (lflag)
f01056aa:	85 c9                	test   %ecx,%ecx
f01056ac:	74 32                	je     f01056e0 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
f01056ae:	8b 45 14             	mov    0x14(%ebp),%eax
f01056b1:	8b 10                	mov    (%eax),%edx
f01056b3:	b9 00 00 00 00       	mov    $0x0,%ecx
f01056b8:	8d 40 04             	lea    0x4(%eax),%eax
f01056bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01056be:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
f01056c3:	e9 a3 00 00 00       	jmp    f010576b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f01056c8:	8b 45 14             	mov    0x14(%ebp),%eax
f01056cb:	8b 10                	mov    (%eax),%edx
f01056cd:	8b 48 04             	mov    0x4(%eax),%ecx
f01056d0:	8d 40 08             	lea    0x8(%eax),%eax
f01056d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01056d6:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
f01056db:	e9 8b 00 00 00       	jmp    f010576b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f01056e0:	8b 45 14             	mov    0x14(%ebp),%eax
f01056e3:	8b 10                	mov    (%eax),%edx
f01056e5:	b9 00 00 00 00       	mov    $0x0,%ecx
f01056ea:	8d 40 04             	lea    0x4(%eax),%eax
f01056ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01056f0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
f01056f5:	eb 74                	jmp    f010576b <vprintfmt+0x38c>
	if (lflag >= 2)
f01056f7:	83 f9 01             	cmp    $0x1,%ecx
f01056fa:	7f 1b                	jg     f0105717 <vprintfmt+0x338>
	else if (lflag)
f01056fc:	85 c9                	test   %ecx,%ecx
f01056fe:	74 2c                	je     f010572c <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
f0105700:	8b 45 14             	mov    0x14(%ebp),%eax
f0105703:	8b 10                	mov    (%eax),%edx
f0105705:	b9 00 00 00 00       	mov    $0x0,%ecx
f010570a:	8d 40 04             	lea    0x4(%eax),%eax
f010570d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105710:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
f0105715:	eb 54                	jmp    f010576b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f0105717:	8b 45 14             	mov    0x14(%ebp),%eax
f010571a:	8b 10                	mov    (%eax),%edx
f010571c:	8b 48 04             	mov    0x4(%eax),%ecx
f010571f:	8d 40 08             	lea    0x8(%eax),%eax
f0105722:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105725:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
f010572a:	eb 3f                	jmp    f010576b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f010572c:	8b 45 14             	mov    0x14(%ebp),%eax
f010572f:	8b 10                	mov    (%eax),%edx
f0105731:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105736:	8d 40 04             	lea    0x4(%eax),%eax
f0105739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010573c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
f0105741:	eb 28                	jmp    f010576b <vprintfmt+0x38c>
			putch('0', putdat);
f0105743:	83 ec 08             	sub    $0x8,%esp
f0105746:	53                   	push   %ebx
f0105747:	6a 30                	push   $0x30
f0105749:	ff d6                	call   *%esi
			putch('x', putdat);
f010574b:	83 c4 08             	add    $0x8,%esp
f010574e:	53                   	push   %ebx
f010574f:	6a 78                	push   $0x78
f0105751:	ff d6                	call   *%esi
			num = (unsigned long long)
f0105753:	8b 45 14             	mov    0x14(%ebp),%eax
f0105756:	8b 10                	mov    (%eax),%edx
f0105758:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f010575d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0105760:	8d 40 04             	lea    0x4(%eax),%eax
f0105763:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105766:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f010576b:	83 ec 0c             	sub    $0xc,%esp
f010576e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
f0105772:	57                   	push   %edi
f0105773:	ff 75 e0             	pushl  -0x20(%ebp)
f0105776:	50                   	push   %eax
f0105777:	51                   	push   %ecx
f0105778:	52                   	push   %edx
f0105779:	89 da                	mov    %ebx,%edx
f010577b:	89 f0                	mov    %esi,%eax
f010577d:	e8 72 fb ff ff       	call   f01052f4 <printnum>
			break;
f0105782:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f0105785:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105788:	83 c7 01             	add    $0x1,%edi
f010578b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f010578f:	83 f8 25             	cmp    $0x25,%eax
f0105792:	0f 84 62 fc ff ff    	je     f01053fa <vprintfmt+0x1b>
			if (ch == '\0')
f0105798:	85 c0                	test   %eax,%eax
f010579a:	0f 84 8b 00 00 00    	je     f010582b <vprintfmt+0x44c>
			putch(ch, putdat);
f01057a0:	83 ec 08             	sub    $0x8,%esp
f01057a3:	53                   	push   %ebx
f01057a4:	50                   	push   %eax
f01057a5:	ff d6                	call   *%esi
f01057a7:	83 c4 10             	add    $0x10,%esp
f01057aa:	eb dc                	jmp    f0105788 <vprintfmt+0x3a9>
	if (lflag >= 2)
f01057ac:	83 f9 01             	cmp    $0x1,%ecx
f01057af:	7f 1b                	jg     f01057cc <vprintfmt+0x3ed>
	else if (lflag)
f01057b1:	85 c9                	test   %ecx,%ecx
f01057b3:	74 2c                	je     f01057e1 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
f01057b5:	8b 45 14             	mov    0x14(%ebp),%eax
f01057b8:	8b 10                	mov    (%eax),%edx
f01057ba:	b9 00 00 00 00       	mov    $0x0,%ecx
f01057bf:	8d 40 04             	lea    0x4(%eax),%eax
f01057c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01057c5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
f01057ca:	eb 9f                	jmp    f010576b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f01057cc:	8b 45 14             	mov    0x14(%ebp),%eax
f01057cf:	8b 10                	mov    (%eax),%edx
f01057d1:	8b 48 04             	mov    0x4(%eax),%ecx
f01057d4:	8d 40 08             	lea    0x8(%eax),%eax
f01057d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01057da:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
f01057df:	eb 8a                	jmp    f010576b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f01057e1:	8b 45 14             	mov    0x14(%ebp),%eax
f01057e4:	8b 10                	mov    (%eax),%edx
f01057e6:	b9 00 00 00 00       	mov    $0x0,%ecx
f01057eb:	8d 40 04             	lea    0x4(%eax),%eax
f01057ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01057f1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
f01057f6:	e9 70 ff ff ff       	jmp    f010576b <vprintfmt+0x38c>
			putch(ch, putdat);
f01057fb:	83 ec 08             	sub    $0x8,%esp
f01057fe:	53                   	push   %ebx
f01057ff:	6a 25                	push   $0x25
f0105801:	ff d6                	call   *%esi
			break;
f0105803:	83 c4 10             	add    $0x10,%esp
f0105806:	e9 7a ff ff ff       	jmp    f0105785 <vprintfmt+0x3a6>
			putch('%', putdat);
f010580b:	83 ec 08             	sub    $0x8,%esp
f010580e:	53                   	push   %ebx
f010580f:	6a 25                	push   $0x25
f0105811:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105813:	83 c4 10             	add    $0x10,%esp
f0105816:	89 f8                	mov    %edi,%eax
f0105818:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f010581c:	74 05                	je     f0105823 <vprintfmt+0x444>
f010581e:	83 e8 01             	sub    $0x1,%eax
f0105821:	eb f5                	jmp    f0105818 <vprintfmt+0x439>
f0105823:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105826:	e9 5a ff ff ff       	jmp    f0105785 <vprintfmt+0x3a6>
}
f010582b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010582e:	5b                   	pop    %ebx
f010582f:	5e                   	pop    %esi
f0105830:	5f                   	pop    %edi
f0105831:	5d                   	pop    %ebp
f0105832:	c3                   	ret    

f0105833 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0105833:	f3 0f 1e fb          	endbr32 
f0105837:	55                   	push   %ebp
f0105838:	89 e5                	mov    %esp,%ebp
f010583a:	83 ec 18             	sub    $0x18,%esp
f010583d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105840:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0105843:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105846:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f010584a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f010584d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0105854:	85 c0                	test   %eax,%eax
f0105856:	74 26                	je     f010587e <vsnprintf+0x4b>
f0105858:	85 d2                	test   %edx,%edx
f010585a:	7e 22                	jle    f010587e <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f010585c:	ff 75 14             	pushl  0x14(%ebp)
f010585f:	ff 75 10             	pushl  0x10(%ebp)
f0105862:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105865:	50                   	push   %eax
f0105866:	68 9d 53 10 f0       	push   $0xf010539d
f010586b:	e8 6f fb ff ff       	call   f01053df <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0105870:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105873:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105876:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105879:	83 c4 10             	add    $0x10,%esp
}
f010587c:	c9                   	leave  
f010587d:	c3                   	ret    
		return -E_INVAL;
f010587e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105883:	eb f7                	jmp    f010587c <vsnprintf+0x49>

f0105885 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0105885:	f3 0f 1e fb          	endbr32 
f0105889:	55                   	push   %ebp
f010588a:	89 e5                	mov    %esp,%ebp
f010588c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f010588f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0105892:	50                   	push   %eax
f0105893:	ff 75 10             	pushl  0x10(%ebp)
f0105896:	ff 75 0c             	pushl  0xc(%ebp)
f0105899:	ff 75 08             	pushl  0x8(%ebp)
f010589c:	e8 92 ff ff ff       	call   f0105833 <vsnprintf>
	va_end(ap);

	return rc;
}
f01058a1:	c9                   	leave  
f01058a2:	c3                   	ret    

f01058a3 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f01058a3:	f3 0f 1e fb          	endbr32 
f01058a7:	55                   	push   %ebp
f01058a8:	89 e5                	mov    %esp,%ebp
f01058aa:	57                   	push   %edi
f01058ab:	56                   	push   %esi
f01058ac:	53                   	push   %ebx
f01058ad:	83 ec 0c             	sub    $0xc,%esp
f01058b0:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f01058b3:	85 c0                	test   %eax,%eax
f01058b5:	74 11                	je     f01058c8 <readline+0x25>
		cprintf("%s", prompt);
f01058b7:	83 ec 08             	sub    $0x8,%esp
f01058ba:	50                   	push   %eax
f01058bb:	68 ce 6d 10 f0       	push   $0xf0106dce
f01058c0:	e8 42 e1 ff ff       	call   f0103a07 <cprintf>
f01058c5:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f01058c8:	83 ec 0c             	sub    $0xc,%esp
f01058cb:	6a 00                	push   $0x0
f01058cd:	e8 00 af ff ff       	call   f01007d2 <iscons>
f01058d2:	89 c7                	mov    %eax,%edi
f01058d4:	83 c4 10             	add    $0x10,%esp
	i = 0;
f01058d7:	be 00 00 00 00       	mov    $0x0,%esi
f01058dc:	eb 57                	jmp    f0105935 <readline+0x92>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f01058de:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f01058e3:	83 fb f8             	cmp    $0xfffffff8,%ebx
f01058e6:	75 08                	jne    f01058f0 <readline+0x4d>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f01058e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01058eb:	5b                   	pop    %ebx
f01058ec:	5e                   	pop    %esi
f01058ed:	5f                   	pop    %edi
f01058ee:	5d                   	pop    %ebp
f01058ef:	c3                   	ret    
				cprintf("read error: %e\n", c);
f01058f0:	83 ec 08             	sub    $0x8,%esp
f01058f3:	53                   	push   %ebx
f01058f4:	68 3f 83 10 f0       	push   $0xf010833f
f01058f9:	e8 09 e1 ff ff       	call   f0103a07 <cprintf>
f01058fe:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0105901:	b8 00 00 00 00       	mov    $0x0,%eax
f0105906:	eb e0                	jmp    f01058e8 <readline+0x45>
			if (echoing)
f0105908:	85 ff                	test   %edi,%edi
f010590a:	75 05                	jne    f0105911 <readline+0x6e>
			i--;
f010590c:	83 ee 01             	sub    $0x1,%esi
f010590f:	eb 24                	jmp    f0105935 <readline+0x92>
				cputchar('\b');
f0105911:	83 ec 0c             	sub    $0xc,%esp
f0105914:	6a 08                	push   $0x8
f0105916:	e8 8e ae ff ff       	call   f01007a9 <cputchar>
f010591b:	83 c4 10             	add    $0x10,%esp
f010591e:	eb ec                	jmp    f010590c <readline+0x69>
				cputchar(c);
f0105920:	83 ec 0c             	sub    $0xc,%esp
f0105923:	53                   	push   %ebx
f0105924:	e8 80 ae ff ff       	call   f01007a9 <cputchar>
f0105929:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f010592c:	88 9e 80 7a 21 f0    	mov    %bl,-0xfde8580(%esi)
f0105932:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f0105935:	e8 83 ae ff ff       	call   f01007bd <getchar>
f010593a:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f010593c:	85 c0                	test   %eax,%eax
f010593e:	78 9e                	js     f01058de <readline+0x3b>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0105940:	83 f8 08             	cmp    $0x8,%eax
f0105943:	0f 94 c2             	sete   %dl
f0105946:	83 f8 7f             	cmp    $0x7f,%eax
f0105949:	0f 94 c0             	sete   %al
f010594c:	08 c2                	or     %al,%dl
f010594e:	74 04                	je     f0105954 <readline+0xb1>
f0105950:	85 f6                	test   %esi,%esi
f0105952:	7f b4                	jg     f0105908 <readline+0x65>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0105954:	83 fb 1f             	cmp    $0x1f,%ebx
f0105957:	7e 0e                	jle    f0105967 <readline+0xc4>
f0105959:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f010595f:	7f 06                	jg     f0105967 <readline+0xc4>
			if (echoing)
f0105961:	85 ff                	test   %edi,%edi
f0105963:	74 c7                	je     f010592c <readline+0x89>
f0105965:	eb b9                	jmp    f0105920 <readline+0x7d>
		} else if (c == '\n' || c == '\r') {
f0105967:	83 fb 0a             	cmp    $0xa,%ebx
f010596a:	74 05                	je     f0105971 <readline+0xce>
f010596c:	83 fb 0d             	cmp    $0xd,%ebx
f010596f:	75 c4                	jne    f0105935 <readline+0x92>
			if (echoing)
f0105971:	85 ff                	test   %edi,%edi
f0105973:	75 11                	jne    f0105986 <readline+0xe3>
			buf[i] = 0;
f0105975:	c6 86 80 7a 21 f0 00 	movb   $0x0,-0xfde8580(%esi)
			return buf;
f010597c:	b8 80 7a 21 f0       	mov    $0xf0217a80,%eax
f0105981:	e9 62 ff ff ff       	jmp    f01058e8 <readline+0x45>
				cputchar('\n');
f0105986:	83 ec 0c             	sub    $0xc,%esp
f0105989:	6a 0a                	push   $0xa
f010598b:	e8 19 ae ff ff       	call   f01007a9 <cputchar>
f0105990:	83 c4 10             	add    $0x10,%esp
f0105993:	eb e0                	jmp    f0105975 <readline+0xd2>

f0105995 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105995:	f3 0f 1e fb          	endbr32 
f0105999:	55                   	push   %ebp
f010599a:	89 e5                	mov    %esp,%ebp
f010599c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010599f:	b8 00 00 00 00       	mov    $0x0,%eax
f01059a4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f01059a8:	74 05                	je     f01059af <strlen+0x1a>
		n++;
f01059aa:	83 c0 01             	add    $0x1,%eax
f01059ad:	eb f5                	jmp    f01059a4 <strlen+0xf>
	return n;
}
f01059af:	5d                   	pop    %ebp
f01059b0:	c3                   	ret    

f01059b1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f01059b1:	f3 0f 1e fb          	endbr32 
f01059b5:	55                   	push   %ebp
f01059b6:	89 e5                	mov    %esp,%ebp
f01059b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01059bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01059be:	b8 00 00 00 00       	mov    $0x0,%eax
f01059c3:	39 d0                	cmp    %edx,%eax
f01059c5:	74 0d                	je     f01059d4 <strnlen+0x23>
f01059c7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f01059cb:	74 05                	je     f01059d2 <strnlen+0x21>
		n++;
f01059cd:	83 c0 01             	add    $0x1,%eax
f01059d0:	eb f1                	jmp    f01059c3 <strnlen+0x12>
f01059d2:	89 c2                	mov    %eax,%edx
	return n;
}
f01059d4:	89 d0                	mov    %edx,%eax
f01059d6:	5d                   	pop    %ebp
f01059d7:	c3                   	ret    

f01059d8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f01059d8:	f3 0f 1e fb          	endbr32 
f01059dc:	55                   	push   %ebp
f01059dd:	89 e5                	mov    %esp,%ebp
f01059df:	53                   	push   %ebx
f01059e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01059e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f01059e6:	b8 00 00 00 00       	mov    $0x0,%eax
f01059eb:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f01059ef:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f01059f2:	83 c0 01             	add    $0x1,%eax
f01059f5:	84 d2                	test   %dl,%dl
f01059f7:	75 f2                	jne    f01059eb <strcpy+0x13>
		/* do nothing */;
	return ret;
}
f01059f9:	89 c8                	mov    %ecx,%eax
f01059fb:	5b                   	pop    %ebx
f01059fc:	5d                   	pop    %ebp
f01059fd:	c3                   	ret    

f01059fe <strcat>:

char *
strcat(char *dst, const char *src)
{
f01059fe:	f3 0f 1e fb          	endbr32 
f0105a02:	55                   	push   %ebp
f0105a03:	89 e5                	mov    %esp,%ebp
f0105a05:	53                   	push   %ebx
f0105a06:	83 ec 10             	sub    $0x10,%esp
f0105a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105a0c:	53                   	push   %ebx
f0105a0d:	e8 83 ff ff ff       	call   f0105995 <strlen>
f0105a12:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0105a15:	ff 75 0c             	pushl  0xc(%ebp)
f0105a18:	01 d8                	add    %ebx,%eax
f0105a1a:	50                   	push   %eax
f0105a1b:	e8 b8 ff ff ff       	call   f01059d8 <strcpy>
	return dst;
}
f0105a20:	89 d8                	mov    %ebx,%eax
f0105a22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105a25:	c9                   	leave  
f0105a26:	c3                   	ret    

f0105a27 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0105a27:	f3 0f 1e fb          	endbr32 
f0105a2b:	55                   	push   %ebp
f0105a2c:	89 e5                	mov    %esp,%ebp
f0105a2e:	56                   	push   %esi
f0105a2f:	53                   	push   %ebx
f0105a30:	8b 75 08             	mov    0x8(%ebp),%esi
f0105a33:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105a36:	89 f3                	mov    %esi,%ebx
f0105a38:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105a3b:	89 f0                	mov    %esi,%eax
f0105a3d:	39 d8                	cmp    %ebx,%eax
f0105a3f:	74 11                	je     f0105a52 <strncpy+0x2b>
		*dst++ = *src;
f0105a41:	83 c0 01             	add    $0x1,%eax
f0105a44:	0f b6 0a             	movzbl (%edx),%ecx
f0105a47:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0105a4a:	80 f9 01             	cmp    $0x1,%cl
f0105a4d:	83 da ff             	sbb    $0xffffffff,%edx
f0105a50:	eb eb                	jmp    f0105a3d <strncpy+0x16>
	}
	return ret;
}
f0105a52:	89 f0                	mov    %esi,%eax
f0105a54:	5b                   	pop    %ebx
f0105a55:	5e                   	pop    %esi
f0105a56:	5d                   	pop    %ebp
f0105a57:	c3                   	ret    

f0105a58 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0105a58:	f3 0f 1e fb          	endbr32 
f0105a5c:	55                   	push   %ebp
f0105a5d:	89 e5                	mov    %esp,%ebp
f0105a5f:	56                   	push   %esi
f0105a60:	53                   	push   %ebx
f0105a61:	8b 75 08             	mov    0x8(%ebp),%esi
f0105a64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105a67:	8b 55 10             	mov    0x10(%ebp),%edx
f0105a6a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0105a6c:	85 d2                	test   %edx,%edx
f0105a6e:	74 21                	je     f0105a91 <strlcpy+0x39>
f0105a70:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f0105a74:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f0105a76:	39 c2                	cmp    %eax,%edx
f0105a78:	74 14                	je     f0105a8e <strlcpy+0x36>
f0105a7a:	0f b6 19             	movzbl (%ecx),%ebx
f0105a7d:	84 db                	test   %bl,%bl
f0105a7f:	74 0b                	je     f0105a8c <strlcpy+0x34>
			*dst++ = *src++;
f0105a81:	83 c1 01             	add    $0x1,%ecx
f0105a84:	83 c2 01             	add    $0x1,%edx
f0105a87:	88 5a ff             	mov    %bl,-0x1(%edx)
f0105a8a:	eb ea                	jmp    f0105a76 <strlcpy+0x1e>
f0105a8c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0105a8e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105a91:	29 f0                	sub    %esi,%eax
}
f0105a93:	5b                   	pop    %ebx
f0105a94:	5e                   	pop    %esi
f0105a95:	5d                   	pop    %ebp
f0105a96:	c3                   	ret    

f0105a97 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105a97:	f3 0f 1e fb          	endbr32 
f0105a9b:	55                   	push   %ebp
f0105a9c:	89 e5                	mov    %esp,%ebp
f0105a9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105aa4:	0f b6 01             	movzbl (%ecx),%eax
f0105aa7:	84 c0                	test   %al,%al
f0105aa9:	74 0c                	je     f0105ab7 <strcmp+0x20>
f0105aab:	3a 02                	cmp    (%edx),%al
f0105aad:	75 08                	jne    f0105ab7 <strcmp+0x20>
		p++, q++;
f0105aaf:	83 c1 01             	add    $0x1,%ecx
f0105ab2:	83 c2 01             	add    $0x1,%edx
f0105ab5:	eb ed                	jmp    f0105aa4 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105ab7:	0f b6 c0             	movzbl %al,%eax
f0105aba:	0f b6 12             	movzbl (%edx),%edx
f0105abd:	29 d0                	sub    %edx,%eax
}
f0105abf:	5d                   	pop    %ebp
f0105ac0:	c3                   	ret    

f0105ac1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0105ac1:	f3 0f 1e fb          	endbr32 
f0105ac5:	55                   	push   %ebp
f0105ac6:	89 e5                	mov    %esp,%ebp
f0105ac8:	53                   	push   %ebx
f0105ac9:	8b 45 08             	mov    0x8(%ebp),%eax
f0105acc:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105acf:	89 c3                	mov    %eax,%ebx
f0105ad1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0105ad4:	eb 06                	jmp    f0105adc <strncmp+0x1b>
		n--, p++, q++;
f0105ad6:	83 c0 01             	add    $0x1,%eax
f0105ad9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105adc:	39 d8                	cmp    %ebx,%eax
f0105ade:	74 16                	je     f0105af6 <strncmp+0x35>
f0105ae0:	0f b6 08             	movzbl (%eax),%ecx
f0105ae3:	84 c9                	test   %cl,%cl
f0105ae5:	74 04                	je     f0105aeb <strncmp+0x2a>
f0105ae7:	3a 0a                	cmp    (%edx),%cl
f0105ae9:	74 eb                	je     f0105ad6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105aeb:	0f b6 00             	movzbl (%eax),%eax
f0105aee:	0f b6 12             	movzbl (%edx),%edx
f0105af1:	29 d0                	sub    %edx,%eax
}
f0105af3:	5b                   	pop    %ebx
f0105af4:	5d                   	pop    %ebp
f0105af5:	c3                   	ret    
		return 0;
f0105af6:	b8 00 00 00 00       	mov    $0x0,%eax
f0105afb:	eb f6                	jmp    f0105af3 <strncmp+0x32>

f0105afd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105afd:	f3 0f 1e fb          	endbr32 
f0105b01:	55                   	push   %ebp
f0105b02:	89 e5                	mov    %esp,%ebp
f0105b04:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b07:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105b0b:	0f b6 10             	movzbl (%eax),%edx
f0105b0e:	84 d2                	test   %dl,%dl
f0105b10:	74 09                	je     f0105b1b <strchr+0x1e>
		if (*s == c)
f0105b12:	38 ca                	cmp    %cl,%dl
f0105b14:	74 0a                	je     f0105b20 <strchr+0x23>
	for (; *s; s++)
f0105b16:	83 c0 01             	add    $0x1,%eax
f0105b19:	eb f0                	jmp    f0105b0b <strchr+0xe>
			return (char *) s;
	return 0;
f0105b1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105b20:	5d                   	pop    %ebp
f0105b21:	c3                   	ret    

f0105b22 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105b22:	f3 0f 1e fb          	endbr32 
f0105b26:	55                   	push   %ebp
f0105b27:	89 e5                	mov    %esp,%ebp
f0105b29:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b2c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105b30:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0105b33:	38 ca                	cmp    %cl,%dl
f0105b35:	74 09                	je     f0105b40 <strfind+0x1e>
f0105b37:	84 d2                	test   %dl,%dl
f0105b39:	74 05                	je     f0105b40 <strfind+0x1e>
	for (; *s; s++)
f0105b3b:	83 c0 01             	add    $0x1,%eax
f0105b3e:	eb f0                	jmp    f0105b30 <strfind+0xe>
			break;
	return (char *) s;
}
f0105b40:	5d                   	pop    %ebp
f0105b41:	c3                   	ret    

f0105b42 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105b42:	f3 0f 1e fb          	endbr32 
f0105b46:	55                   	push   %ebp
f0105b47:	89 e5                	mov    %esp,%ebp
f0105b49:	57                   	push   %edi
f0105b4a:	56                   	push   %esi
f0105b4b:	53                   	push   %ebx
f0105b4c:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105b4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0105b52:	85 c9                	test   %ecx,%ecx
f0105b54:	74 31                	je     f0105b87 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0105b56:	89 f8                	mov    %edi,%eax
f0105b58:	09 c8                	or     %ecx,%eax
f0105b5a:	a8 03                	test   $0x3,%al
f0105b5c:	75 23                	jne    f0105b81 <memset+0x3f>
		c &= 0xFF;
f0105b5e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0105b62:	89 d3                	mov    %edx,%ebx
f0105b64:	c1 e3 08             	shl    $0x8,%ebx
f0105b67:	89 d0                	mov    %edx,%eax
f0105b69:	c1 e0 18             	shl    $0x18,%eax
f0105b6c:	89 d6                	mov    %edx,%esi
f0105b6e:	c1 e6 10             	shl    $0x10,%esi
f0105b71:	09 f0                	or     %esi,%eax
f0105b73:	09 c2                	or     %eax,%edx
f0105b75:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0105b77:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0105b7a:	89 d0                	mov    %edx,%eax
f0105b7c:	fc                   	cld    
f0105b7d:	f3 ab                	rep stos %eax,%es:(%edi)
f0105b7f:	eb 06                	jmp    f0105b87 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0105b81:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105b84:	fc                   	cld    
f0105b85:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0105b87:	89 f8                	mov    %edi,%eax
f0105b89:	5b                   	pop    %ebx
f0105b8a:	5e                   	pop    %esi
f0105b8b:	5f                   	pop    %edi
f0105b8c:	5d                   	pop    %ebp
f0105b8d:	c3                   	ret    

f0105b8e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105b8e:	f3 0f 1e fb          	endbr32 
f0105b92:	55                   	push   %ebp
f0105b93:	89 e5                	mov    %esp,%ebp
f0105b95:	57                   	push   %edi
f0105b96:	56                   	push   %esi
f0105b97:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b9a:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105b9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105ba0:	39 c6                	cmp    %eax,%esi
f0105ba2:	73 32                	jae    f0105bd6 <memmove+0x48>
f0105ba4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105ba7:	39 c2                	cmp    %eax,%edx
f0105ba9:	76 2b                	jbe    f0105bd6 <memmove+0x48>
		s += n;
		d += n;
f0105bab:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105bae:	89 fe                	mov    %edi,%esi
f0105bb0:	09 ce                	or     %ecx,%esi
f0105bb2:	09 d6                	or     %edx,%esi
f0105bb4:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105bba:	75 0e                	jne    f0105bca <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105bbc:	83 ef 04             	sub    $0x4,%edi
f0105bbf:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105bc2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105bc5:	fd                   	std    
f0105bc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105bc8:	eb 09                	jmp    f0105bd3 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105bca:	83 ef 01             	sub    $0x1,%edi
f0105bcd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105bd0:	fd                   	std    
f0105bd1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105bd3:	fc                   	cld    
f0105bd4:	eb 1a                	jmp    f0105bf0 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105bd6:	89 c2                	mov    %eax,%edx
f0105bd8:	09 ca                	or     %ecx,%edx
f0105bda:	09 f2                	or     %esi,%edx
f0105bdc:	f6 c2 03             	test   $0x3,%dl
f0105bdf:	75 0a                	jne    f0105beb <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0105be1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105be4:	89 c7                	mov    %eax,%edi
f0105be6:	fc                   	cld    
f0105be7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105be9:	eb 05                	jmp    f0105bf0 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
f0105beb:	89 c7                	mov    %eax,%edi
f0105bed:	fc                   	cld    
f0105bee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105bf0:	5e                   	pop    %esi
f0105bf1:	5f                   	pop    %edi
f0105bf2:	5d                   	pop    %ebp
f0105bf3:	c3                   	ret    

f0105bf4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105bf4:	f3 0f 1e fb          	endbr32 
f0105bf8:	55                   	push   %ebp
f0105bf9:	89 e5                	mov    %esp,%ebp
f0105bfb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0105bfe:	ff 75 10             	pushl  0x10(%ebp)
f0105c01:	ff 75 0c             	pushl  0xc(%ebp)
f0105c04:	ff 75 08             	pushl  0x8(%ebp)
f0105c07:	e8 82 ff ff ff       	call   f0105b8e <memmove>
}
f0105c0c:	c9                   	leave  
f0105c0d:	c3                   	ret    

f0105c0e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105c0e:	f3 0f 1e fb          	endbr32 
f0105c12:	55                   	push   %ebp
f0105c13:	89 e5                	mov    %esp,%ebp
f0105c15:	56                   	push   %esi
f0105c16:	53                   	push   %ebx
f0105c17:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105c1d:	89 c6                	mov    %eax,%esi
f0105c1f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105c22:	39 f0                	cmp    %esi,%eax
f0105c24:	74 1c                	je     f0105c42 <memcmp+0x34>
		if (*s1 != *s2)
f0105c26:	0f b6 08             	movzbl (%eax),%ecx
f0105c29:	0f b6 1a             	movzbl (%edx),%ebx
f0105c2c:	38 d9                	cmp    %bl,%cl
f0105c2e:	75 08                	jne    f0105c38 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0105c30:	83 c0 01             	add    $0x1,%eax
f0105c33:	83 c2 01             	add    $0x1,%edx
f0105c36:	eb ea                	jmp    f0105c22 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
f0105c38:	0f b6 c1             	movzbl %cl,%eax
f0105c3b:	0f b6 db             	movzbl %bl,%ebx
f0105c3e:	29 d8                	sub    %ebx,%eax
f0105c40:	eb 05                	jmp    f0105c47 <memcmp+0x39>
	}

	return 0;
f0105c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105c47:	5b                   	pop    %ebx
f0105c48:	5e                   	pop    %esi
f0105c49:	5d                   	pop    %ebp
f0105c4a:	c3                   	ret    

f0105c4b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0105c4b:	f3 0f 1e fb          	endbr32 
f0105c4f:	55                   	push   %ebp
f0105c50:	89 e5                	mov    %esp,%ebp
f0105c52:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0105c58:	89 c2                	mov    %eax,%edx
f0105c5a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0105c5d:	39 d0                	cmp    %edx,%eax
f0105c5f:	73 09                	jae    f0105c6a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
f0105c61:	38 08                	cmp    %cl,(%eax)
f0105c63:	74 05                	je     f0105c6a <memfind+0x1f>
	for (; s < ends; s++)
f0105c65:	83 c0 01             	add    $0x1,%eax
f0105c68:	eb f3                	jmp    f0105c5d <memfind+0x12>
			break;
	return (void *) s;
}
f0105c6a:	5d                   	pop    %ebp
f0105c6b:	c3                   	ret    

f0105c6c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0105c6c:	f3 0f 1e fb          	endbr32 
f0105c70:	55                   	push   %ebp
f0105c71:	89 e5                	mov    %esp,%ebp
f0105c73:	57                   	push   %edi
f0105c74:	56                   	push   %esi
f0105c75:	53                   	push   %ebx
f0105c76:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105c79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0105c7c:	eb 03                	jmp    f0105c81 <strtol+0x15>
		s++;
f0105c7e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0105c81:	0f b6 01             	movzbl (%ecx),%eax
f0105c84:	3c 20                	cmp    $0x20,%al
f0105c86:	74 f6                	je     f0105c7e <strtol+0x12>
f0105c88:	3c 09                	cmp    $0x9,%al
f0105c8a:	74 f2                	je     f0105c7e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
f0105c8c:	3c 2b                	cmp    $0x2b,%al
f0105c8e:	74 2a                	je     f0105cba <strtol+0x4e>
	int neg = 0;
f0105c90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0105c95:	3c 2d                	cmp    $0x2d,%al
f0105c97:	74 2b                	je     f0105cc4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105c99:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0105c9f:	75 0f                	jne    f0105cb0 <strtol+0x44>
f0105ca1:	80 39 30             	cmpb   $0x30,(%ecx)
f0105ca4:	74 28                	je     f0105cce <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0105ca6:	85 db                	test   %ebx,%ebx
f0105ca8:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105cad:	0f 44 d8             	cmove  %eax,%ebx
f0105cb0:	b8 00 00 00 00       	mov    $0x0,%eax
f0105cb5:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105cb8:	eb 46                	jmp    f0105d00 <strtol+0x94>
		s++;
f0105cba:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105cbd:	bf 00 00 00 00       	mov    $0x0,%edi
f0105cc2:	eb d5                	jmp    f0105c99 <strtol+0x2d>
		s++, neg = 1;
f0105cc4:	83 c1 01             	add    $0x1,%ecx
f0105cc7:	bf 01 00 00 00       	mov    $0x1,%edi
f0105ccc:	eb cb                	jmp    f0105c99 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105cce:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105cd2:	74 0e                	je     f0105ce2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105cd4:	85 db                	test   %ebx,%ebx
f0105cd6:	75 d8                	jne    f0105cb0 <strtol+0x44>
		s++, base = 8;
f0105cd8:	83 c1 01             	add    $0x1,%ecx
f0105cdb:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105ce0:	eb ce                	jmp    f0105cb0 <strtol+0x44>
		s += 2, base = 16;
f0105ce2:	83 c1 02             	add    $0x2,%ecx
f0105ce5:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105cea:	eb c4                	jmp    f0105cb0 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0105cec:	0f be d2             	movsbl %dl,%edx
f0105cef:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105cf2:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105cf5:	7d 3a                	jge    f0105d31 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105cf7:	83 c1 01             	add    $0x1,%ecx
f0105cfa:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105cfe:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105d00:	0f b6 11             	movzbl (%ecx),%edx
f0105d03:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105d06:	89 f3                	mov    %esi,%ebx
f0105d08:	80 fb 09             	cmp    $0x9,%bl
f0105d0b:	76 df                	jbe    f0105cec <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
f0105d0d:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105d10:	89 f3                	mov    %esi,%ebx
f0105d12:	80 fb 19             	cmp    $0x19,%bl
f0105d15:	77 08                	ja     f0105d1f <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105d17:	0f be d2             	movsbl %dl,%edx
f0105d1a:	83 ea 57             	sub    $0x57,%edx
f0105d1d:	eb d3                	jmp    f0105cf2 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
f0105d1f:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105d22:	89 f3                	mov    %esi,%ebx
f0105d24:	80 fb 19             	cmp    $0x19,%bl
f0105d27:	77 08                	ja     f0105d31 <strtol+0xc5>
			dig = *s - 'A' + 10;
f0105d29:	0f be d2             	movsbl %dl,%edx
f0105d2c:	83 ea 37             	sub    $0x37,%edx
f0105d2f:	eb c1                	jmp    f0105cf2 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105d31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0105d35:	74 05                	je     f0105d3c <strtol+0xd0>
		*endptr = (char *) s;
f0105d37:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105d3a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0105d3c:	89 c2                	mov    %eax,%edx
f0105d3e:	f7 da                	neg    %edx
f0105d40:	85 ff                	test   %edi,%edi
f0105d42:	0f 45 c2             	cmovne %edx,%eax
}
f0105d45:	5b                   	pop    %ebx
f0105d46:	5e                   	pop    %esi
f0105d47:	5f                   	pop    %edi
f0105d48:	5d                   	pop    %ebp
f0105d49:	c3                   	ret    
f0105d4a:	66 90                	xchg   %ax,%ax

f0105d4c <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0105d4c:	fa                   	cli    

	xorw    %ax, %ax
f0105d4d:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0105d4f:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105d51:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105d53:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0105d55:	0f 01 16             	lgdtl  (%esi)
f0105d58:	74 70                	je     f0105dca <mpsearch1+0x3>
	movl    %cr0, %eax
f0105d5a:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0105d5d:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0105d61:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0105d64:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0105d6a:	08 00                	or     %al,(%eax)

f0105d6c <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0105d6c:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0105d70:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105d72:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105d74:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0105d76:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0105d7a:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0105d7c:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0105d7e:	b8 00 10 12 00       	mov    $0x121000,%eax
	movl    %eax, %cr3
f0105d83:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0105d86:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0105d89:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0105d8e:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0105d91:	8b 25 84 7e 21 f0    	mov    0xf0217e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105d97:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105d9c:	b8 bd 01 10 f0       	mov    $0xf01001bd,%eax
	call    *%eax
f0105da1:	ff d0                	call   *%eax

f0105da3 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105da3:	eb fe                	jmp    f0105da3 <spin>
f0105da5:	8d 76 00             	lea    0x0(%esi),%esi

f0105da8 <gdt>:
	...
f0105db0:	ff                   	(bad)  
f0105db1:	ff 00                	incl   (%eax)
f0105db3:	00 00                	add    %al,(%eax)
f0105db5:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105dbc:	00                   	.byte 0x0
f0105dbd:	92                   	xchg   %eax,%edx
f0105dbe:	cf                   	iret   
	...

f0105dc0 <gdtdesc>:
f0105dc0:	17                   	pop    %ss
f0105dc1:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0105dc6 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105dc6:	90                   	nop

f0105dc7 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105dc7:	55                   	push   %ebp
f0105dc8:	89 e5                	mov    %esp,%ebp
f0105dca:	57                   	push   %edi
f0105dcb:	56                   	push   %esi
f0105dcc:	53                   	push   %ebx
f0105dcd:	83 ec 0c             	sub    $0xc,%esp
f0105dd0:	89 c7                	mov    %eax,%edi
	if (PGNUM(pa) >= npages)
f0105dd2:	a1 88 7e 21 f0       	mov    0xf0217e88,%eax
f0105dd7:	89 f9                	mov    %edi,%ecx
f0105dd9:	c1 e9 0c             	shr    $0xc,%ecx
f0105ddc:	39 c1                	cmp    %eax,%ecx
f0105dde:	73 19                	jae    f0105df9 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0105de0:	8d 9f 00 00 00 f0    	lea    -0x10000000(%edi),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105de6:	01 d7                	add    %edx,%edi
	if (PGNUM(pa) >= npages)
f0105de8:	89 fa                	mov    %edi,%edx
f0105dea:	c1 ea 0c             	shr    $0xc,%edx
f0105ded:	39 c2                	cmp    %eax,%edx
f0105def:	73 1a                	jae    f0105e0b <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105df1:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0105df7:	eb 27                	jmp    f0105e20 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105df9:	57                   	push   %edi
f0105dfa:	68 04 68 10 f0       	push   $0xf0106804
f0105dff:	6a 57                	push   $0x57
f0105e01:	68 dd 84 10 f0       	push   $0xf01084dd
f0105e06:	e8 35 a2 ff ff       	call   f0100040 <_panic>
f0105e0b:	57                   	push   %edi
f0105e0c:	68 04 68 10 f0       	push   $0xf0106804
f0105e11:	6a 57                	push   $0x57
f0105e13:	68 dd 84 10 f0       	push   $0xf01084dd
f0105e18:	e8 23 a2 ff ff       	call   f0100040 <_panic>
f0105e1d:	83 c3 10             	add    $0x10,%ebx
f0105e20:	39 fb                	cmp    %edi,%ebx
f0105e22:	73 30                	jae    f0105e54 <mpsearch1+0x8d>
f0105e24:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105e26:	83 ec 04             	sub    $0x4,%esp
f0105e29:	6a 04                	push   $0x4
f0105e2b:	68 ed 84 10 f0       	push   $0xf01084ed
f0105e30:	53                   	push   %ebx
f0105e31:	e8 d8 fd ff ff       	call   f0105c0e <memcmp>
f0105e36:	83 c4 10             	add    $0x10,%esp
f0105e39:	85 c0                	test   %eax,%eax
f0105e3b:	75 e0                	jne    f0105e1d <mpsearch1+0x56>
f0105e3d:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0105e3f:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0105e42:	0f b6 0a             	movzbl (%edx),%ecx
f0105e45:	01 c8                	add    %ecx,%eax
f0105e47:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0105e4a:	39 f2                	cmp    %esi,%edx
f0105e4c:	75 f4                	jne    f0105e42 <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105e4e:	84 c0                	test   %al,%al
f0105e50:	75 cb                	jne    f0105e1d <mpsearch1+0x56>
f0105e52:	eb 05                	jmp    f0105e59 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0105e54:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105e59:	89 d8                	mov    %ebx,%eax
f0105e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105e5e:	5b                   	pop    %ebx
f0105e5f:	5e                   	pop    %esi
f0105e60:	5f                   	pop    %edi
f0105e61:	5d                   	pop    %ebp
f0105e62:	c3                   	ret    

f0105e63 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0105e63:	f3 0f 1e fb          	endbr32 
f0105e67:	55                   	push   %ebp
f0105e68:	89 e5                	mov    %esp,%ebp
f0105e6a:	57                   	push   %edi
f0105e6b:	56                   	push   %esi
f0105e6c:	53                   	push   %ebx
f0105e6d:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105e70:	c7 05 c0 83 21 f0 20 	movl   $0xf0218020,0xf02183c0
f0105e77:	80 21 f0 
	if (PGNUM(pa) >= npages)
f0105e7a:	83 3d 88 7e 21 f0 00 	cmpl   $0x0,0xf0217e88
f0105e81:	0f 84 a3 00 00 00    	je     f0105f2a <mp_init+0xc7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0105e87:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0105e8e:	85 c0                	test   %eax,%eax
f0105e90:	0f 84 aa 00 00 00    	je     f0105f40 <mp_init+0xdd>
		p <<= 4;	// Translate from segment to PA
f0105e96:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0105e99:	ba 00 04 00 00       	mov    $0x400,%edx
f0105e9e:	e8 24 ff ff ff       	call   f0105dc7 <mpsearch1>
f0105ea3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105ea6:	85 c0                	test   %eax,%eax
f0105ea8:	75 1a                	jne    f0105ec4 <mp_init+0x61>
	return mpsearch1(0xF0000, 0x10000);
f0105eaa:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105eaf:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105eb4:	e8 0e ff ff ff       	call   f0105dc7 <mpsearch1>
f0105eb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0105ebc:	85 c0                	test   %eax,%eax
f0105ebe:	0f 84 35 02 00 00    	je     f01060f9 <mp_init+0x296>
	if (mp->physaddr == 0 || mp->type != 0) {
f0105ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105ec7:	8b 58 04             	mov    0x4(%eax),%ebx
f0105eca:	85 db                	test   %ebx,%ebx
f0105ecc:	0f 84 97 00 00 00    	je     f0105f69 <mp_init+0x106>
f0105ed2:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0105ed6:	0f 85 8d 00 00 00    	jne    f0105f69 <mp_init+0x106>
f0105edc:	89 d8                	mov    %ebx,%eax
f0105ede:	c1 e8 0c             	shr    $0xc,%eax
f0105ee1:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0105ee7:	0f 83 91 00 00 00    	jae    f0105f7e <mp_init+0x11b>
	return (void *)(pa + KERNBASE);
f0105eed:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0105ef3:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105ef5:	83 ec 04             	sub    $0x4,%esp
f0105ef8:	6a 04                	push   $0x4
f0105efa:	68 f2 84 10 f0       	push   $0xf01084f2
f0105eff:	53                   	push   %ebx
f0105f00:	e8 09 fd ff ff       	call   f0105c0e <memcmp>
f0105f05:	83 c4 10             	add    $0x10,%esp
f0105f08:	85 c0                	test   %eax,%eax
f0105f0a:	0f 85 83 00 00 00    	jne    f0105f93 <mp_init+0x130>
f0105f10:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105f14:	01 df                	add    %ebx,%edi
	sum = 0;
f0105f16:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0105f18:	39 fb                	cmp    %edi,%ebx
f0105f1a:	0f 84 88 00 00 00    	je     f0105fa8 <mp_init+0x145>
		sum += ((uint8_t *)addr)[i];
f0105f20:	0f b6 0b             	movzbl (%ebx),%ecx
f0105f23:	01 ca                	add    %ecx,%edx
f0105f25:	83 c3 01             	add    $0x1,%ebx
f0105f28:	eb ee                	jmp    f0105f18 <mp_init+0xb5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105f2a:	68 00 04 00 00       	push   $0x400
f0105f2f:	68 04 68 10 f0       	push   $0xf0106804
f0105f34:	6a 6f                	push   $0x6f
f0105f36:	68 dd 84 10 f0       	push   $0xf01084dd
f0105f3b:	e8 00 a1 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105f40:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105f47:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105f4a:	2d 00 04 00 00       	sub    $0x400,%eax
f0105f4f:	ba 00 04 00 00       	mov    $0x400,%edx
f0105f54:	e8 6e fe ff ff       	call   f0105dc7 <mpsearch1>
f0105f59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105f5c:	85 c0                	test   %eax,%eax
f0105f5e:	0f 85 60 ff ff ff    	jne    f0105ec4 <mp_init+0x61>
f0105f64:	e9 41 ff ff ff       	jmp    f0105eaa <mp_init+0x47>
		cprintf("SMP: Default configurations not implemented\n");
f0105f69:	83 ec 0c             	sub    $0xc,%esp
f0105f6c:	68 50 83 10 f0       	push   $0xf0108350
f0105f71:	e8 91 da ff ff       	call   f0103a07 <cprintf>
		return NULL;
f0105f76:	83 c4 10             	add    $0x10,%esp
f0105f79:	e9 7b 01 00 00       	jmp    f01060f9 <mp_init+0x296>
f0105f7e:	53                   	push   %ebx
f0105f7f:	68 04 68 10 f0       	push   $0xf0106804
f0105f84:	68 90 00 00 00       	push   $0x90
f0105f89:	68 dd 84 10 f0       	push   $0xf01084dd
f0105f8e:	e8 ad a0 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0105f93:	83 ec 0c             	sub    $0xc,%esp
f0105f96:	68 80 83 10 f0       	push   $0xf0108380
f0105f9b:	e8 67 da ff ff       	call   f0103a07 <cprintf>
		return NULL;
f0105fa0:	83 c4 10             	add    $0x10,%esp
f0105fa3:	e9 51 01 00 00       	jmp    f01060f9 <mp_init+0x296>
	if (sum(conf, conf->length) != 0) {
f0105fa8:	84 d2                	test   %dl,%dl
f0105faa:	75 22                	jne    f0105fce <mp_init+0x16b>
	if (conf->version != 1 && conf->version != 4) {
f0105fac:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0105fb0:	80 fa 01             	cmp    $0x1,%dl
f0105fb3:	74 05                	je     f0105fba <mp_init+0x157>
f0105fb5:	80 fa 04             	cmp    $0x4,%dl
f0105fb8:	75 29                	jne    f0105fe3 <mp_init+0x180>
f0105fba:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105fbe:	01 d9                	add    %ebx,%ecx
	for (i = 0; i < len; i++)
f0105fc0:	39 d9                	cmp    %ebx,%ecx
f0105fc2:	74 38                	je     f0105ffc <mp_init+0x199>
		sum += ((uint8_t *)addr)[i];
f0105fc4:	0f b6 13             	movzbl (%ebx),%edx
f0105fc7:	01 d0                	add    %edx,%eax
f0105fc9:	83 c3 01             	add    $0x1,%ebx
f0105fcc:	eb f2                	jmp    f0105fc0 <mp_init+0x15d>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105fce:	83 ec 0c             	sub    $0xc,%esp
f0105fd1:	68 b4 83 10 f0       	push   $0xf01083b4
f0105fd6:	e8 2c da ff ff       	call   f0103a07 <cprintf>
		return NULL;
f0105fdb:	83 c4 10             	add    $0x10,%esp
f0105fde:	e9 16 01 00 00       	jmp    f01060f9 <mp_init+0x296>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105fe3:	83 ec 08             	sub    $0x8,%esp
f0105fe6:	0f b6 d2             	movzbl %dl,%edx
f0105fe9:	52                   	push   %edx
f0105fea:	68 d8 83 10 f0       	push   $0xf01083d8
f0105fef:	e8 13 da ff ff       	call   f0103a07 <cprintf>
		return NULL;
f0105ff4:	83 c4 10             	add    $0x10,%esp
f0105ff7:	e9 fd 00 00 00       	jmp    f01060f9 <mp_init+0x296>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105ffc:	02 46 2a             	add    0x2a(%esi),%al
f0105fff:	75 1c                	jne    f010601d <mp_init+0x1ba>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0106001:	c7 05 00 80 21 f0 01 	movl   $0x1,0xf0218000
f0106008:	00 00 00 
	lapicaddr = conf->lapicaddr;
f010600b:	8b 46 24             	mov    0x24(%esi),%eax
f010600e:	a3 00 90 25 f0       	mov    %eax,0xf0259000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106013:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0106016:	bb 00 00 00 00       	mov    $0x0,%ebx
f010601b:	eb 4d                	jmp    f010606a <mp_init+0x207>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f010601d:	83 ec 0c             	sub    $0xc,%esp
f0106020:	68 f8 83 10 f0       	push   $0xf01083f8
f0106025:	e8 dd d9 ff ff       	call   f0103a07 <cprintf>
		return NULL;
f010602a:	83 c4 10             	add    $0x10,%esp
f010602d:	e9 c7 00 00 00       	jmp    f01060f9 <mp_init+0x296>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106032:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106036:	74 11                	je     f0106049 <mp_init+0x1e6>
				bootcpu = &cpus[ncpu];
f0106038:	6b 05 c4 83 21 f0 74 	imul   $0x74,0xf02183c4,%eax
f010603f:	05 20 80 21 f0       	add    $0xf0218020,%eax
f0106044:	a3 c0 83 21 f0       	mov    %eax,0xf02183c0
			if (ncpu < NCPU) {
f0106049:	a1 c4 83 21 f0       	mov    0xf02183c4,%eax
f010604e:	83 f8 07             	cmp    $0x7,%eax
f0106051:	7f 33                	jg     f0106086 <mp_init+0x223>
				cpus[ncpu].cpu_id = ncpu;
f0106053:	6b d0 74             	imul   $0x74,%eax,%edx
f0106056:	88 82 20 80 21 f0    	mov    %al,-0xfde7fe0(%edx)
				ncpu++;
f010605c:	83 c0 01             	add    $0x1,%eax
f010605f:	a3 c4 83 21 f0       	mov    %eax,0xf02183c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0106064:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106067:	83 c3 01             	add    $0x1,%ebx
f010606a:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f010606e:	39 d8                	cmp    %ebx,%eax
f0106070:	76 4f                	jbe    f01060c1 <mp_init+0x25e>
		switch (*p) {
f0106072:	0f b6 07             	movzbl (%edi),%eax
f0106075:	84 c0                	test   %al,%al
f0106077:	74 b9                	je     f0106032 <mp_init+0x1cf>
f0106079:	8d 50 ff             	lea    -0x1(%eax),%edx
f010607c:	80 fa 03             	cmp    $0x3,%dl
f010607f:	77 1c                	ja     f010609d <mp_init+0x23a>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106081:	83 c7 08             	add    $0x8,%edi
			continue;
f0106084:	eb e1                	jmp    f0106067 <mp_init+0x204>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106086:	83 ec 08             	sub    $0x8,%esp
f0106089:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f010608d:	50                   	push   %eax
f010608e:	68 28 84 10 f0       	push   $0xf0108428
f0106093:	e8 6f d9 ff ff       	call   f0103a07 <cprintf>
f0106098:	83 c4 10             	add    $0x10,%esp
f010609b:	eb c7                	jmp    f0106064 <mp_init+0x201>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f010609d:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f01060a0:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f01060a3:	50                   	push   %eax
f01060a4:	68 50 84 10 f0       	push   $0xf0108450
f01060a9:	e8 59 d9 ff ff       	call   f0103a07 <cprintf>
			ismp = 0;
f01060ae:	c7 05 00 80 21 f0 00 	movl   $0x0,0xf0218000
f01060b5:	00 00 00 
			i = conf->entry;
f01060b8:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f01060bc:	83 c4 10             	add    $0x10,%esp
f01060bf:	eb a6                	jmp    f0106067 <mp_init+0x204>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f01060c1:	a1 c0 83 21 f0       	mov    0xf02183c0,%eax
f01060c6:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f01060cd:	83 3d 00 80 21 f0 00 	cmpl   $0x0,0xf0218000
f01060d4:	74 2b                	je     f0106101 <mp_init+0x29e>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f01060d6:	83 ec 04             	sub    $0x4,%esp
f01060d9:	ff 35 c4 83 21 f0    	pushl  0xf02183c4
f01060df:	0f b6 00             	movzbl (%eax),%eax
f01060e2:	50                   	push   %eax
f01060e3:	68 f7 84 10 f0       	push   $0xf01084f7
f01060e8:	e8 1a d9 ff ff       	call   f0103a07 <cprintf>

	if (mp->imcrp) {
f01060ed:	83 c4 10             	add    $0x10,%esp
f01060f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01060f3:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f01060f7:	75 2e                	jne    f0106127 <mp_init+0x2c4>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f01060f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01060fc:	5b                   	pop    %ebx
f01060fd:	5e                   	pop    %esi
f01060fe:	5f                   	pop    %edi
f01060ff:	5d                   	pop    %ebp
f0106100:	c3                   	ret    
		ncpu = 1;
f0106101:	c7 05 c4 83 21 f0 01 	movl   $0x1,0xf02183c4
f0106108:	00 00 00 
		lapicaddr = 0;
f010610b:	c7 05 00 90 25 f0 00 	movl   $0x0,0xf0259000
f0106112:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106115:	83 ec 0c             	sub    $0xc,%esp
f0106118:	68 70 84 10 f0       	push   $0xf0108470
f010611d:	e8 e5 d8 ff ff       	call   f0103a07 <cprintf>
		return;
f0106122:	83 c4 10             	add    $0x10,%esp
f0106125:	eb d2                	jmp    f01060f9 <mp_init+0x296>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106127:	83 ec 0c             	sub    $0xc,%esp
f010612a:	68 9c 84 10 f0       	push   $0xf010849c
f010612f:	e8 d3 d8 ff ff       	call   f0103a07 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106134:	b8 70 00 00 00       	mov    $0x70,%eax
f0106139:	ba 22 00 00 00       	mov    $0x22,%edx
f010613e:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010613f:	ba 23 00 00 00       	mov    $0x23,%edx
f0106144:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106145:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106148:	ee                   	out    %al,(%dx)
}
f0106149:	83 c4 10             	add    $0x10,%esp
f010614c:	eb ab                	jmp    f01060f9 <mp_init+0x296>

f010614e <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f010614e:	8b 0d 04 90 25 f0    	mov    0xf0259004,%ecx
f0106154:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106157:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106159:	a1 04 90 25 f0       	mov    0xf0259004,%eax
f010615e:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106161:	c3                   	ret    

f0106162 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0106162:	f3 0f 1e fb          	endbr32 
	if (lapic)
f0106166:	8b 15 04 90 25 f0    	mov    0xf0259004,%edx
		return lapic[ID] >> 24;
	return 0;
f010616c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f0106171:	85 d2                	test   %edx,%edx
f0106173:	74 06                	je     f010617b <cpunum+0x19>
		return lapic[ID] >> 24;
f0106175:	8b 42 20             	mov    0x20(%edx),%eax
f0106178:	c1 e8 18             	shr    $0x18,%eax
}
f010617b:	c3                   	ret    

f010617c <lapic_init>:
{
f010617c:	f3 0f 1e fb          	endbr32 
	if (!lapicaddr)
f0106180:	a1 00 90 25 f0       	mov    0xf0259000,%eax
f0106185:	85 c0                	test   %eax,%eax
f0106187:	75 01                	jne    f010618a <lapic_init+0xe>
f0106189:	c3                   	ret    
{
f010618a:	55                   	push   %ebp
f010618b:	89 e5                	mov    %esp,%ebp
f010618d:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0106190:	68 00 10 00 00       	push   $0x1000
f0106195:	50                   	push   %eax
f0106196:	e8 22 b2 ff ff       	call   f01013bd <mmio_map_region>
f010619b:	a3 04 90 25 f0       	mov    %eax,0xf0259004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f01061a0:	ba 27 01 00 00       	mov    $0x127,%edx
f01061a5:	b8 3c 00 00 00       	mov    $0x3c,%eax
f01061aa:	e8 9f ff ff ff       	call   f010614e <lapicw>
	lapicw(TDCR, X1);
f01061af:	ba 0b 00 00 00       	mov    $0xb,%edx
f01061b4:	b8 f8 00 00 00       	mov    $0xf8,%eax
f01061b9:	e8 90 ff ff ff       	call   f010614e <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f01061be:	ba 20 00 02 00       	mov    $0x20020,%edx
f01061c3:	b8 c8 00 00 00       	mov    $0xc8,%eax
f01061c8:	e8 81 ff ff ff       	call   f010614e <lapicw>
	lapicw(TICR, 10000000); 
f01061cd:	ba 80 96 98 00       	mov    $0x989680,%edx
f01061d2:	b8 e0 00 00 00       	mov    $0xe0,%eax
f01061d7:	e8 72 ff ff ff       	call   f010614e <lapicw>
	if (thiscpu != bootcpu)
f01061dc:	e8 81 ff ff ff       	call   f0106162 <cpunum>
f01061e1:	6b c0 74             	imul   $0x74,%eax,%eax
f01061e4:	05 20 80 21 f0       	add    $0xf0218020,%eax
f01061e9:	83 c4 10             	add    $0x10,%esp
f01061ec:	39 05 c0 83 21 f0    	cmp    %eax,0xf02183c0
f01061f2:	74 0f                	je     f0106203 <lapic_init+0x87>
		lapicw(LINT0, MASKED);
f01061f4:	ba 00 00 01 00       	mov    $0x10000,%edx
f01061f9:	b8 d4 00 00 00       	mov    $0xd4,%eax
f01061fe:	e8 4b ff ff ff       	call   f010614e <lapicw>
	lapicw(LINT1, MASKED);
f0106203:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106208:	b8 d8 00 00 00       	mov    $0xd8,%eax
f010620d:	e8 3c ff ff ff       	call   f010614e <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106212:	a1 04 90 25 f0       	mov    0xf0259004,%eax
f0106217:	8b 40 30             	mov    0x30(%eax),%eax
f010621a:	c1 e8 10             	shr    $0x10,%eax
f010621d:	a8 fc                	test   $0xfc,%al
f010621f:	75 7c                	jne    f010629d <lapic_init+0x121>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106221:	ba 33 00 00 00       	mov    $0x33,%edx
f0106226:	b8 dc 00 00 00       	mov    $0xdc,%eax
f010622b:	e8 1e ff ff ff       	call   f010614e <lapicw>
	lapicw(ESR, 0);
f0106230:	ba 00 00 00 00       	mov    $0x0,%edx
f0106235:	b8 a0 00 00 00       	mov    $0xa0,%eax
f010623a:	e8 0f ff ff ff       	call   f010614e <lapicw>
	lapicw(ESR, 0);
f010623f:	ba 00 00 00 00       	mov    $0x0,%edx
f0106244:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106249:	e8 00 ff ff ff       	call   f010614e <lapicw>
	lapicw(EOI, 0);
f010624e:	ba 00 00 00 00       	mov    $0x0,%edx
f0106253:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106258:	e8 f1 fe ff ff       	call   f010614e <lapicw>
	lapicw(ICRHI, 0);
f010625d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106262:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106267:	e8 e2 fe ff ff       	call   f010614e <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f010626c:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106271:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106276:	e8 d3 fe ff ff       	call   f010614e <lapicw>
	while(lapic[ICRLO] & DELIVS)
f010627b:	8b 15 04 90 25 f0    	mov    0xf0259004,%edx
f0106281:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106287:	f6 c4 10             	test   $0x10,%ah
f010628a:	75 f5                	jne    f0106281 <lapic_init+0x105>
	lapicw(TPR, 0);
f010628c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106291:	b8 20 00 00 00       	mov    $0x20,%eax
f0106296:	e8 b3 fe ff ff       	call   f010614e <lapicw>
}
f010629b:	c9                   	leave  
f010629c:	c3                   	ret    
		lapicw(PCINT, MASKED);
f010629d:	ba 00 00 01 00       	mov    $0x10000,%edx
f01062a2:	b8 d0 00 00 00       	mov    $0xd0,%eax
f01062a7:	e8 a2 fe ff ff       	call   f010614e <lapicw>
f01062ac:	e9 70 ff ff ff       	jmp    f0106221 <lapic_init+0xa5>

f01062b1 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f01062b1:	f3 0f 1e fb          	endbr32 
	if (lapic)
f01062b5:	83 3d 04 90 25 f0 00 	cmpl   $0x0,0xf0259004
f01062bc:	74 17                	je     f01062d5 <lapic_eoi+0x24>
{
f01062be:	55                   	push   %ebp
f01062bf:	89 e5                	mov    %esp,%ebp
f01062c1:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f01062c4:	ba 00 00 00 00       	mov    $0x0,%edx
f01062c9:	b8 2c 00 00 00       	mov    $0x2c,%eax
f01062ce:	e8 7b fe ff ff       	call   f010614e <lapicw>
}
f01062d3:	c9                   	leave  
f01062d4:	c3                   	ret    
f01062d5:	c3                   	ret    

f01062d6 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f01062d6:	f3 0f 1e fb          	endbr32 
f01062da:	55                   	push   %ebp
f01062db:	89 e5                	mov    %esp,%ebp
f01062dd:	56                   	push   %esi
f01062de:	53                   	push   %ebx
f01062df:	8b 75 08             	mov    0x8(%ebp),%esi
f01062e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01062e5:	b8 0f 00 00 00       	mov    $0xf,%eax
f01062ea:	ba 70 00 00 00       	mov    $0x70,%edx
f01062ef:	ee                   	out    %al,(%dx)
f01062f0:	b8 0a 00 00 00       	mov    $0xa,%eax
f01062f5:	ba 71 00 00 00       	mov    $0x71,%edx
f01062fa:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f01062fb:	83 3d 88 7e 21 f0 00 	cmpl   $0x0,0xf0217e88
f0106302:	74 7e                	je     f0106382 <lapic_startap+0xac>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106304:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f010630b:	00 00 
	wrv[1] = addr >> 4;
f010630d:	89 d8                	mov    %ebx,%eax
f010630f:	c1 e8 04             	shr    $0x4,%eax
f0106312:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106318:	c1 e6 18             	shl    $0x18,%esi
f010631b:	89 f2                	mov    %esi,%edx
f010631d:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106322:	e8 27 fe ff ff       	call   f010614e <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106327:	ba 00 c5 00 00       	mov    $0xc500,%edx
f010632c:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106331:	e8 18 fe ff ff       	call   f010614e <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106336:	ba 00 85 00 00       	mov    $0x8500,%edx
f010633b:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106340:	e8 09 fe ff ff       	call   f010614e <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106345:	c1 eb 0c             	shr    $0xc,%ebx
f0106348:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f010634b:	89 f2                	mov    %esi,%edx
f010634d:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106352:	e8 f7 fd ff ff       	call   f010614e <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106357:	89 da                	mov    %ebx,%edx
f0106359:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010635e:	e8 eb fd ff ff       	call   f010614e <lapicw>
		lapicw(ICRHI, apicid << 24);
f0106363:	89 f2                	mov    %esi,%edx
f0106365:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010636a:	e8 df fd ff ff       	call   f010614e <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010636f:	89 da                	mov    %ebx,%edx
f0106371:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106376:	e8 d3 fd ff ff       	call   f010614e <lapicw>
		microdelay(200);
	}
}
f010637b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010637e:	5b                   	pop    %ebx
f010637f:	5e                   	pop    %esi
f0106380:	5d                   	pop    %ebp
f0106381:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106382:	68 67 04 00 00       	push   $0x467
f0106387:	68 04 68 10 f0       	push   $0xf0106804
f010638c:	68 98 00 00 00       	push   $0x98
f0106391:	68 14 85 10 f0       	push   $0xf0108514
f0106396:	e8 a5 9c ff ff       	call   f0100040 <_panic>

f010639b <lapic_ipi>:

void
lapic_ipi(int vector)
{
f010639b:	f3 0f 1e fb          	endbr32 
f010639f:	55                   	push   %ebp
f01063a0:	89 e5                	mov    %esp,%ebp
f01063a2:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f01063a5:	8b 55 08             	mov    0x8(%ebp),%edx
f01063a8:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f01063ae:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01063b3:	e8 96 fd ff ff       	call   f010614e <lapicw>
	while (lapic[ICRLO] & DELIVS)
f01063b8:	8b 15 04 90 25 f0    	mov    0xf0259004,%edx
f01063be:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f01063c4:	f6 c4 10             	test   $0x10,%ah
f01063c7:	75 f5                	jne    f01063be <lapic_ipi+0x23>
		;
}
f01063c9:	c9                   	leave  
f01063ca:	c3                   	ret    

f01063cb <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f01063cb:	f3 0f 1e fb          	endbr32 
f01063cf:	55                   	push   %ebp
f01063d0:	89 e5                	mov    %esp,%ebp
f01063d2:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f01063d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f01063db:	8b 55 0c             	mov    0xc(%ebp),%edx
f01063de:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f01063e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f01063e8:	5d                   	pop    %ebp
f01063e9:	c3                   	ret    

f01063ea <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f01063ea:	f3 0f 1e fb          	endbr32 
f01063ee:	55                   	push   %ebp
f01063ef:	89 e5                	mov    %esp,%ebp
f01063f1:	56                   	push   %esi
f01063f2:	53                   	push   %ebx
f01063f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f01063f6:	83 3b 00             	cmpl   $0x0,(%ebx)
f01063f9:	75 07                	jne    f0106402 <spin_lock+0x18>
	asm volatile("lock; xchgl %0, %1"
f01063fb:	ba 01 00 00 00       	mov    $0x1,%edx
f0106400:	eb 34                	jmp    f0106436 <spin_lock+0x4c>
f0106402:	8b 73 08             	mov    0x8(%ebx),%esi
f0106405:	e8 58 fd ff ff       	call   f0106162 <cpunum>
f010640a:	6b c0 74             	imul   $0x74,%eax,%eax
f010640d:	05 20 80 21 f0       	add    $0xf0218020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0106412:	39 c6                	cmp    %eax,%esi
f0106414:	75 e5                	jne    f01063fb <spin_lock+0x11>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106416:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106419:	e8 44 fd ff ff       	call   f0106162 <cpunum>
f010641e:	83 ec 0c             	sub    $0xc,%esp
f0106421:	53                   	push   %ebx
f0106422:	50                   	push   %eax
f0106423:	68 24 85 10 f0       	push   $0xf0108524
f0106428:	6a 41                	push   $0x41
f010642a:	68 86 85 10 f0       	push   $0xf0108586
f010642f:	e8 0c 9c ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0106434:	f3 90                	pause  
f0106436:	89 d0                	mov    %edx,%eax
f0106438:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f010643b:	85 c0                	test   %eax,%eax
f010643d:	75 f5                	jne    f0106434 <spin_lock+0x4a>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f010643f:	e8 1e fd ff ff       	call   f0106162 <cpunum>
f0106444:	6b c0 74             	imul   $0x74,%eax,%eax
f0106447:	05 20 80 21 f0       	add    $0xf0218020,%eax
f010644c:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f010644f:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0106451:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106456:	83 f8 09             	cmp    $0x9,%eax
f0106459:	7f 21                	jg     f010647c <spin_lock+0x92>
f010645b:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106461:	76 19                	jbe    f010647c <spin_lock+0x92>
		pcs[i] = ebp[1];          // saved %eip
f0106463:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106466:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f010646a:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f010646c:	83 c0 01             	add    $0x1,%eax
f010646f:	eb e5                	jmp    f0106456 <spin_lock+0x6c>
		pcs[i] = 0;
f0106471:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0106478:	00 
	for (; i < 10; i++)
f0106479:	83 c0 01             	add    $0x1,%eax
f010647c:	83 f8 09             	cmp    $0x9,%eax
f010647f:	7e f0                	jle    f0106471 <spin_lock+0x87>
	get_caller_pcs(lk->pcs);
#endif
}
f0106481:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106484:	5b                   	pop    %ebx
f0106485:	5e                   	pop    %esi
f0106486:	5d                   	pop    %ebp
f0106487:	c3                   	ret    

f0106488 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106488:	f3 0f 1e fb          	endbr32 
f010648c:	55                   	push   %ebp
f010648d:	89 e5                	mov    %esp,%ebp
f010648f:	57                   	push   %edi
f0106490:	56                   	push   %esi
f0106491:	53                   	push   %ebx
f0106492:	83 ec 4c             	sub    $0x4c,%esp
f0106495:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106498:	83 3e 00             	cmpl   $0x0,(%esi)
f010649b:	75 35                	jne    f01064d2 <spin_unlock+0x4a>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f010649d:	83 ec 04             	sub    $0x4,%esp
f01064a0:	6a 28                	push   $0x28
f01064a2:	8d 46 0c             	lea    0xc(%esi),%eax
f01064a5:	50                   	push   %eax
f01064a6:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f01064a9:	53                   	push   %ebx
f01064aa:	e8 df f6 ff ff       	call   f0105b8e <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f01064af:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f01064b2:	0f b6 38             	movzbl (%eax),%edi
f01064b5:	8b 76 04             	mov    0x4(%esi),%esi
f01064b8:	e8 a5 fc ff ff       	call   f0106162 <cpunum>
f01064bd:	57                   	push   %edi
f01064be:	56                   	push   %esi
f01064bf:	50                   	push   %eax
f01064c0:	68 50 85 10 f0       	push   $0xf0108550
f01064c5:	e8 3d d5 ff ff       	call   f0103a07 <cprintf>
f01064ca:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01064cd:	8d 7d a8             	lea    -0x58(%ebp),%edi
f01064d0:	eb 4e                	jmp    f0106520 <spin_unlock+0x98>
	return lock->locked && lock->cpu == thiscpu;
f01064d2:	8b 5e 08             	mov    0x8(%esi),%ebx
f01064d5:	e8 88 fc ff ff       	call   f0106162 <cpunum>
f01064da:	6b c0 74             	imul   $0x74,%eax,%eax
f01064dd:	05 20 80 21 f0       	add    $0xf0218020,%eax
	if (!holding(lk)) {
f01064e2:	39 c3                	cmp    %eax,%ebx
f01064e4:	75 b7                	jne    f010649d <spin_unlock+0x15>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f01064e6:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f01064ed:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f01064f4:	b8 00 00 00 00       	mov    $0x0,%eax
f01064f9:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f01064fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01064ff:	5b                   	pop    %ebx
f0106500:	5e                   	pop    %esi
f0106501:	5f                   	pop    %edi
f0106502:	5d                   	pop    %ebp
f0106503:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f0106504:	83 ec 08             	sub    $0x8,%esp
f0106507:	ff 36                	pushl  (%esi)
f0106509:	68 ad 85 10 f0       	push   $0xf01085ad
f010650e:	e8 f4 d4 ff ff       	call   f0103a07 <cprintf>
f0106513:	83 c4 10             	add    $0x10,%esp
f0106516:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106519:	8d 45 e8             	lea    -0x18(%ebp),%eax
f010651c:	39 c3                	cmp    %eax,%ebx
f010651e:	74 40                	je     f0106560 <spin_unlock+0xd8>
f0106520:	89 de                	mov    %ebx,%esi
f0106522:	8b 03                	mov    (%ebx),%eax
f0106524:	85 c0                	test   %eax,%eax
f0106526:	74 38                	je     f0106560 <spin_unlock+0xd8>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106528:	83 ec 08             	sub    $0x8,%esp
f010652b:	57                   	push   %edi
f010652c:	50                   	push   %eax
f010652d:	e8 bf ea ff ff       	call   f0104ff1 <debuginfo_eip>
f0106532:	83 c4 10             	add    $0x10,%esp
f0106535:	85 c0                	test   %eax,%eax
f0106537:	78 cb                	js     f0106504 <spin_unlock+0x7c>
					pcs[i] - info.eip_fn_addr);
f0106539:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f010653b:	83 ec 04             	sub    $0x4,%esp
f010653e:	89 c2                	mov    %eax,%edx
f0106540:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106543:	52                   	push   %edx
f0106544:	ff 75 b0             	pushl  -0x50(%ebp)
f0106547:	ff 75 b4             	pushl  -0x4c(%ebp)
f010654a:	ff 75 ac             	pushl  -0x54(%ebp)
f010654d:	ff 75 a8             	pushl  -0x58(%ebp)
f0106550:	50                   	push   %eax
f0106551:	68 96 85 10 f0       	push   $0xf0108596
f0106556:	e8 ac d4 ff ff       	call   f0103a07 <cprintf>
f010655b:	83 c4 20             	add    $0x20,%esp
f010655e:	eb b6                	jmp    f0106516 <spin_unlock+0x8e>
		panic("spin_unlock");
f0106560:	83 ec 04             	sub    $0x4,%esp
f0106563:	68 b5 85 10 f0       	push   $0xf01085b5
f0106568:	6a 67                	push   $0x67
f010656a:	68 86 85 10 f0       	push   $0xf0108586
f010656f:	e8 cc 9a ff ff       	call   f0100040 <_panic>
f0106574:	66 90                	xchg   %ax,%ax
f0106576:	66 90                	xchg   %ax,%ax
f0106578:	66 90                	xchg   %ax,%ax
f010657a:	66 90                	xchg   %ax,%ax
f010657c:	66 90                	xchg   %ax,%ax
f010657e:	66 90                	xchg   %ax,%ax

f0106580 <__udivdi3>:
f0106580:	f3 0f 1e fb          	endbr32 
f0106584:	55                   	push   %ebp
f0106585:	57                   	push   %edi
f0106586:	56                   	push   %esi
f0106587:	53                   	push   %ebx
f0106588:	83 ec 1c             	sub    $0x1c,%esp
f010658b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010658f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0106593:	8b 74 24 34          	mov    0x34(%esp),%esi
f0106597:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f010659b:	85 d2                	test   %edx,%edx
f010659d:	75 19                	jne    f01065b8 <__udivdi3+0x38>
f010659f:	39 f3                	cmp    %esi,%ebx
f01065a1:	76 4d                	jbe    f01065f0 <__udivdi3+0x70>
f01065a3:	31 ff                	xor    %edi,%edi
f01065a5:	89 e8                	mov    %ebp,%eax
f01065a7:	89 f2                	mov    %esi,%edx
f01065a9:	f7 f3                	div    %ebx
f01065ab:	89 fa                	mov    %edi,%edx
f01065ad:	83 c4 1c             	add    $0x1c,%esp
f01065b0:	5b                   	pop    %ebx
f01065b1:	5e                   	pop    %esi
f01065b2:	5f                   	pop    %edi
f01065b3:	5d                   	pop    %ebp
f01065b4:	c3                   	ret    
f01065b5:	8d 76 00             	lea    0x0(%esi),%esi
f01065b8:	39 f2                	cmp    %esi,%edx
f01065ba:	76 14                	jbe    f01065d0 <__udivdi3+0x50>
f01065bc:	31 ff                	xor    %edi,%edi
f01065be:	31 c0                	xor    %eax,%eax
f01065c0:	89 fa                	mov    %edi,%edx
f01065c2:	83 c4 1c             	add    $0x1c,%esp
f01065c5:	5b                   	pop    %ebx
f01065c6:	5e                   	pop    %esi
f01065c7:	5f                   	pop    %edi
f01065c8:	5d                   	pop    %ebp
f01065c9:	c3                   	ret    
f01065ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01065d0:	0f bd fa             	bsr    %edx,%edi
f01065d3:	83 f7 1f             	xor    $0x1f,%edi
f01065d6:	75 48                	jne    f0106620 <__udivdi3+0xa0>
f01065d8:	39 f2                	cmp    %esi,%edx
f01065da:	72 06                	jb     f01065e2 <__udivdi3+0x62>
f01065dc:	31 c0                	xor    %eax,%eax
f01065de:	39 eb                	cmp    %ebp,%ebx
f01065e0:	77 de                	ja     f01065c0 <__udivdi3+0x40>
f01065e2:	b8 01 00 00 00       	mov    $0x1,%eax
f01065e7:	eb d7                	jmp    f01065c0 <__udivdi3+0x40>
f01065e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01065f0:	89 d9                	mov    %ebx,%ecx
f01065f2:	85 db                	test   %ebx,%ebx
f01065f4:	75 0b                	jne    f0106601 <__udivdi3+0x81>
f01065f6:	b8 01 00 00 00       	mov    $0x1,%eax
f01065fb:	31 d2                	xor    %edx,%edx
f01065fd:	f7 f3                	div    %ebx
f01065ff:	89 c1                	mov    %eax,%ecx
f0106601:	31 d2                	xor    %edx,%edx
f0106603:	89 f0                	mov    %esi,%eax
f0106605:	f7 f1                	div    %ecx
f0106607:	89 c6                	mov    %eax,%esi
f0106609:	89 e8                	mov    %ebp,%eax
f010660b:	89 f7                	mov    %esi,%edi
f010660d:	f7 f1                	div    %ecx
f010660f:	89 fa                	mov    %edi,%edx
f0106611:	83 c4 1c             	add    $0x1c,%esp
f0106614:	5b                   	pop    %ebx
f0106615:	5e                   	pop    %esi
f0106616:	5f                   	pop    %edi
f0106617:	5d                   	pop    %ebp
f0106618:	c3                   	ret    
f0106619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106620:	89 f9                	mov    %edi,%ecx
f0106622:	b8 20 00 00 00       	mov    $0x20,%eax
f0106627:	29 f8                	sub    %edi,%eax
f0106629:	d3 e2                	shl    %cl,%edx
f010662b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010662f:	89 c1                	mov    %eax,%ecx
f0106631:	89 da                	mov    %ebx,%edx
f0106633:	d3 ea                	shr    %cl,%edx
f0106635:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106639:	09 d1                	or     %edx,%ecx
f010663b:	89 f2                	mov    %esi,%edx
f010663d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106641:	89 f9                	mov    %edi,%ecx
f0106643:	d3 e3                	shl    %cl,%ebx
f0106645:	89 c1                	mov    %eax,%ecx
f0106647:	d3 ea                	shr    %cl,%edx
f0106649:	89 f9                	mov    %edi,%ecx
f010664b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010664f:	89 eb                	mov    %ebp,%ebx
f0106651:	d3 e6                	shl    %cl,%esi
f0106653:	89 c1                	mov    %eax,%ecx
f0106655:	d3 eb                	shr    %cl,%ebx
f0106657:	09 de                	or     %ebx,%esi
f0106659:	89 f0                	mov    %esi,%eax
f010665b:	f7 74 24 08          	divl   0x8(%esp)
f010665f:	89 d6                	mov    %edx,%esi
f0106661:	89 c3                	mov    %eax,%ebx
f0106663:	f7 64 24 0c          	mull   0xc(%esp)
f0106667:	39 d6                	cmp    %edx,%esi
f0106669:	72 15                	jb     f0106680 <__udivdi3+0x100>
f010666b:	89 f9                	mov    %edi,%ecx
f010666d:	d3 e5                	shl    %cl,%ebp
f010666f:	39 c5                	cmp    %eax,%ebp
f0106671:	73 04                	jae    f0106677 <__udivdi3+0xf7>
f0106673:	39 d6                	cmp    %edx,%esi
f0106675:	74 09                	je     f0106680 <__udivdi3+0x100>
f0106677:	89 d8                	mov    %ebx,%eax
f0106679:	31 ff                	xor    %edi,%edi
f010667b:	e9 40 ff ff ff       	jmp    f01065c0 <__udivdi3+0x40>
f0106680:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0106683:	31 ff                	xor    %edi,%edi
f0106685:	e9 36 ff ff ff       	jmp    f01065c0 <__udivdi3+0x40>
f010668a:	66 90                	xchg   %ax,%ax
f010668c:	66 90                	xchg   %ax,%ax
f010668e:	66 90                	xchg   %ax,%ax

f0106690 <__umoddi3>:
f0106690:	f3 0f 1e fb          	endbr32 
f0106694:	55                   	push   %ebp
f0106695:	57                   	push   %edi
f0106696:	56                   	push   %esi
f0106697:	53                   	push   %ebx
f0106698:	83 ec 1c             	sub    $0x1c,%esp
f010669b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f010669f:	8b 74 24 30          	mov    0x30(%esp),%esi
f01066a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01066a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01066ab:	85 c0                	test   %eax,%eax
f01066ad:	75 19                	jne    f01066c8 <__umoddi3+0x38>
f01066af:	39 df                	cmp    %ebx,%edi
f01066b1:	76 5d                	jbe    f0106710 <__umoddi3+0x80>
f01066b3:	89 f0                	mov    %esi,%eax
f01066b5:	89 da                	mov    %ebx,%edx
f01066b7:	f7 f7                	div    %edi
f01066b9:	89 d0                	mov    %edx,%eax
f01066bb:	31 d2                	xor    %edx,%edx
f01066bd:	83 c4 1c             	add    $0x1c,%esp
f01066c0:	5b                   	pop    %ebx
f01066c1:	5e                   	pop    %esi
f01066c2:	5f                   	pop    %edi
f01066c3:	5d                   	pop    %ebp
f01066c4:	c3                   	ret    
f01066c5:	8d 76 00             	lea    0x0(%esi),%esi
f01066c8:	89 f2                	mov    %esi,%edx
f01066ca:	39 d8                	cmp    %ebx,%eax
f01066cc:	76 12                	jbe    f01066e0 <__umoddi3+0x50>
f01066ce:	89 f0                	mov    %esi,%eax
f01066d0:	89 da                	mov    %ebx,%edx
f01066d2:	83 c4 1c             	add    $0x1c,%esp
f01066d5:	5b                   	pop    %ebx
f01066d6:	5e                   	pop    %esi
f01066d7:	5f                   	pop    %edi
f01066d8:	5d                   	pop    %ebp
f01066d9:	c3                   	ret    
f01066da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01066e0:	0f bd e8             	bsr    %eax,%ebp
f01066e3:	83 f5 1f             	xor    $0x1f,%ebp
f01066e6:	75 50                	jne    f0106738 <__umoddi3+0xa8>
f01066e8:	39 d8                	cmp    %ebx,%eax
f01066ea:	0f 82 e0 00 00 00    	jb     f01067d0 <__umoddi3+0x140>
f01066f0:	89 d9                	mov    %ebx,%ecx
f01066f2:	39 f7                	cmp    %esi,%edi
f01066f4:	0f 86 d6 00 00 00    	jbe    f01067d0 <__umoddi3+0x140>
f01066fa:	89 d0                	mov    %edx,%eax
f01066fc:	89 ca                	mov    %ecx,%edx
f01066fe:	83 c4 1c             	add    $0x1c,%esp
f0106701:	5b                   	pop    %ebx
f0106702:	5e                   	pop    %esi
f0106703:	5f                   	pop    %edi
f0106704:	5d                   	pop    %ebp
f0106705:	c3                   	ret    
f0106706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010670d:	8d 76 00             	lea    0x0(%esi),%esi
f0106710:	89 fd                	mov    %edi,%ebp
f0106712:	85 ff                	test   %edi,%edi
f0106714:	75 0b                	jne    f0106721 <__umoddi3+0x91>
f0106716:	b8 01 00 00 00       	mov    $0x1,%eax
f010671b:	31 d2                	xor    %edx,%edx
f010671d:	f7 f7                	div    %edi
f010671f:	89 c5                	mov    %eax,%ebp
f0106721:	89 d8                	mov    %ebx,%eax
f0106723:	31 d2                	xor    %edx,%edx
f0106725:	f7 f5                	div    %ebp
f0106727:	89 f0                	mov    %esi,%eax
f0106729:	f7 f5                	div    %ebp
f010672b:	89 d0                	mov    %edx,%eax
f010672d:	31 d2                	xor    %edx,%edx
f010672f:	eb 8c                	jmp    f01066bd <__umoddi3+0x2d>
f0106731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106738:	89 e9                	mov    %ebp,%ecx
f010673a:	ba 20 00 00 00       	mov    $0x20,%edx
f010673f:	29 ea                	sub    %ebp,%edx
f0106741:	d3 e0                	shl    %cl,%eax
f0106743:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106747:	89 d1                	mov    %edx,%ecx
f0106749:	89 f8                	mov    %edi,%eax
f010674b:	d3 e8                	shr    %cl,%eax
f010674d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106751:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106755:	8b 54 24 04          	mov    0x4(%esp),%edx
f0106759:	09 c1                	or     %eax,%ecx
f010675b:	89 d8                	mov    %ebx,%eax
f010675d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106761:	89 e9                	mov    %ebp,%ecx
f0106763:	d3 e7                	shl    %cl,%edi
f0106765:	89 d1                	mov    %edx,%ecx
f0106767:	d3 e8                	shr    %cl,%eax
f0106769:	89 e9                	mov    %ebp,%ecx
f010676b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010676f:	d3 e3                	shl    %cl,%ebx
f0106771:	89 c7                	mov    %eax,%edi
f0106773:	89 d1                	mov    %edx,%ecx
f0106775:	89 f0                	mov    %esi,%eax
f0106777:	d3 e8                	shr    %cl,%eax
f0106779:	89 e9                	mov    %ebp,%ecx
f010677b:	89 fa                	mov    %edi,%edx
f010677d:	d3 e6                	shl    %cl,%esi
f010677f:	09 d8                	or     %ebx,%eax
f0106781:	f7 74 24 08          	divl   0x8(%esp)
f0106785:	89 d1                	mov    %edx,%ecx
f0106787:	89 f3                	mov    %esi,%ebx
f0106789:	f7 64 24 0c          	mull   0xc(%esp)
f010678d:	89 c6                	mov    %eax,%esi
f010678f:	89 d7                	mov    %edx,%edi
f0106791:	39 d1                	cmp    %edx,%ecx
f0106793:	72 06                	jb     f010679b <__umoddi3+0x10b>
f0106795:	75 10                	jne    f01067a7 <__umoddi3+0x117>
f0106797:	39 c3                	cmp    %eax,%ebx
f0106799:	73 0c                	jae    f01067a7 <__umoddi3+0x117>
f010679b:	2b 44 24 0c          	sub    0xc(%esp),%eax
f010679f:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01067a3:	89 d7                	mov    %edx,%edi
f01067a5:	89 c6                	mov    %eax,%esi
f01067a7:	89 ca                	mov    %ecx,%edx
f01067a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01067ae:	29 f3                	sub    %esi,%ebx
f01067b0:	19 fa                	sbb    %edi,%edx
f01067b2:	89 d0                	mov    %edx,%eax
f01067b4:	d3 e0                	shl    %cl,%eax
f01067b6:	89 e9                	mov    %ebp,%ecx
f01067b8:	d3 eb                	shr    %cl,%ebx
f01067ba:	d3 ea                	shr    %cl,%edx
f01067bc:	09 d8                	or     %ebx,%eax
f01067be:	83 c4 1c             	add    $0x1c,%esp
f01067c1:	5b                   	pop    %ebx
f01067c2:	5e                   	pop    %esi
f01067c3:	5f                   	pop    %edi
f01067c4:	5d                   	pop    %ebp
f01067c5:	c3                   	ret    
f01067c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01067cd:	8d 76 00             	lea    0x0(%esi),%esi
f01067d0:	29 fe                	sub    %edi,%esi
f01067d2:	19 c3                	sbb    %eax,%ebx
f01067d4:	89 f2                	mov    %esi,%edx
f01067d6:	89 d9                	mov    %ebx,%ecx
f01067d8:	e9 1d ff ff ff       	jmp    f01066fa <__umoddi3+0x6a>
