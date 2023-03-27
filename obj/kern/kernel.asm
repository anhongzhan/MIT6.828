
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
f0100015:	b8 00 90 11 00       	mov    $0x119000,%eax
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
f0100034:	bc 00 70 11 f0       	mov    $0xf0117000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 02 00 00 00       	call   f0100040 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <i386_init>:
#include <kern/kclock.h>


void
i386_init(void)
{
f0100040:	f3 0f 1e fb          	endbr32 
f0100044:	55                   	push   %ebp
f0100045:	89 e5                	mov    %esp,%ebp
f0100047:	53                   	push   %ebx
f0100048:	83 ec 08             	sub    $0x8,%esp
f010004b:	e8 0b 01 00 00       	call   f010015b <__x86.get_pc_thunk.bx>
f0100050:	81 c3 b8 82 01 00    	add    $0x182b8,%ebx
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f0100056:	c7 c2 60 a0 11 f0    	mov    $0xf011a060,%edx
f010005c:	c7 c0 c0 a6 11 f0    	mov    $0xf011a6c0,%eax
f0100062:	29 d0                	sub    %edx,%eax
f0100064:	50                   	push   %eax
f0100065:	6a 00                	push   $0x0
f0100067:	52                   	push   %edx
f0100068:	e8 71 3c 00 00       	call   f0103cde <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f010006d:	e8 44 05 00 00       	call   f01005b6 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f0100072:	83 c4 08             	add    $0x8,%esp
f0100075:	68 ac 1a 00 00       	push   $0x1aac
f010007a:	8d 83 58 be fe ff    	lea    -0x141a8(%ebx),%eax
f0100080:	50                   	push   %eax
f0100081:	e8 13 30 00 00       	call   f0103099 <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f0100086:	e8 d2 13 00 00       	call   f010145d <mem_init>
f010008b:	83 c4 10             	add    $0x10,%esp

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f010008e:	83 ec 0c             	sub    $0xc,%esp
f0100091:	6a 00                	push   $0x0
f0100093:	e8 94 08 00 00       	call   f010092c <monitor>
f0100098:	83 c4 10             	add    $0x10,%esp
f010009b:	eb f1                	jmp    f010008e <i386_init+0x4e>

f010009d <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f010009d:	f3 0f 1e fb          	endbr32 
f01000a1:	55                   	push   %ebp
f01000a2:	89 e5                	mov    %esp,%ebp
f01000a4:	57                   	push   %edi
f01000a5:	56                   	push   %esi
f01000a6:	53                   	push   %ebx
f01000a7:	83 ec 0c             	sub    $0xc,%esp
f01000aa:	e8 ac 00 00 00       	call   f010015b <__x86.get_pc_thunk.bx>
f01000af:	81 c3 59 82 01 00    	add    $0x18259,%ebx
f01000b5:	8b 7d 10             	mov    0x10(%ebp),%edi
	va_list ap;

	if (panicstr)
f01000b8:	c7 c0 c4 a6 11 f0    	mov    $0xf011a6c4,%eax
f01000be:	83 38 00             	cmpl   $0x0,(%eax)
f01000c1:	74 0f                	je     f01000d2 <_panic+0x35>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000c3:	83 ec 0c             	sub    $0xc,%esp
f01000c6:	6a 00                	push   $0x0
f01000c8:	e8 5f 08 00 00       	call   f010092c <monitor>
f01000cd:	83 c4 10             	add    $0x10,%esp
f01000d0:	eb f1                	jmp    f01000c3 <_panic+0x26>
	panicstr = fmt;
f01000d2:	89 38                	mov    %edi,(%eax)
	asm volatile("cli; cld");
f01000d4:	fa                   	cli    
f01000d5:	fc                   	cld    
	va_start(ap, fmt);
f01000d6:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel panic at %s:%d: ", file, line);
f01000d9:	83 ec 04             	sub    $0x4,%esp
f01000dc:	ff 75 0c             	pushl  0xc(%ebp)
f01000df:	ff 75 08             	pushl  0x8(%ebp)
f01000e2:	8d 83 73 be fe ff    	lea    -0x1418d(%ebx),%eax
f01000e8:	50                   	push   %eax
f01000e9:	e8 ab 2f 00 00       	call   f0103099 <cprintf>
	vcprintf(fmt, ap);
f01000ee:	83 c4 08             	add    $0x8,%esp
f01000f1:	56                   	push   %esi
f01000f2:	57                   	push   %edi
f01000f3:	e8 66 2f 00 00       	call   f010305e <vcprintf>
	cprintf("\n");
f01000f8:	8d 83 b6 cd fe ff    	lea    -0x1324a(%ebx),%eax
f01000fe:	89 04 24             	mov    %eax,(%esp)
f0100101:	e8 93 2f 00 00       	call   f0103099 <cprintf>
f0100106:	83 c4 10             	add    $0x10,%esp
f0100109:	eb b8                	jmp    f01000c3 <_panic+0x26>

f010010b <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010010b:	f3 0f 1e fb          	endbr32 
f010010f:	55                   	push   %ebp
f0100110:	89 e5                	mov    %esp,%ebp
f0100112:	56                   	push   %esi
f0100113:	53                   	push   %ebx
f0100114:	e8 42 00 00 00       	call   f010015b <__x86.get_pc_thunk.bx>
f0100119:	81 c3 ef 81 01 00    	add    $0x181ef,%ebx
	va_list ap;

	va_start(ap, fmt);
f010011f:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel warning at %s:%d: ", file, line);
f0100122:	83 ec 04             	sub    $0x4,%esp
f0100125:	ff 75 0c             	pushl  0xc(%ebp)
f0100128:	ff 75 08             	pushl  0x8(%ebp)
f010012b:	8d 83 8b be fe ff    	lea    -0x14175(%ebx),%eax
f0100131:	50                   	push   %eax
f0100132:	e8 62 2f 00 00       	call   f0103099 <cprintf>
	vcprintf(fmt, ap);
f0100137:	83 c4 08             	add    $0x8,%esp
f010013a:	56                   	push   %esi
f010013b:	ff 75 10             	pushl  0x10(%ebp)
f010013e:	e8 1b 2f 00 00       	call   f010305e <vcprintf>
	cprintf("\n");
f0100143:	8d 83 b6 cd fe ff    	lea    -0x1324a(%ebx),%eax
f0100149:	89 04 24             	mov    %eax,(%esp)
f010014c:	e8 48 2f 00 00       	call   f0103099 <cprintf>
	va_end(ap);
}
f0100151:	83 c4 10             	add    $0x10,%esp
f0100154:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100157:	5b                   	pop    %ebx
f0100158:	5e                   	pop    %esi
f0100159:	5d                   	pop    %ebp
f010015a:	c3                   	ret    

f010015b <__x86.get_pc_thunk.bx>:
f010015b:	8b 1c 24             	mov    (%esp),%ebx
f010015e:	c3                   	ret    

f010015f <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f010015f:	f3 0f 1e fb          	endbr32 

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100163:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100168:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100169:	a8 01                	test   $0x1,%al
f010016b:	74 0a                	je     f0100177 <serial_proc_data+0x18>
f010016d:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100172:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100173:	0f b6 c0             	movzbl %al,%eax
f0100176:	c3                   	ret    
		return -1;
f0100177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f010017c:	c3                   	ret    

f010017d <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010017d:	55                   	push   %ebp
f010017e:	89 e5                	mov    %esp,%ebp
f0100180:	57                   	push   %edi
f0100181:	56                   	push   %esi
f0100182:	53                   	push   %ebx
f0100183:	83 ec 1c             	sub    $0x1c,%esp
f0100186:	e8 88 05 00 00       	call   f0100713 <__x86.get_pc_thunk.si>
f010018b:	81 c6 7d 81 01 00    	add    $0x1817d,%esi
f0100191:	89 c7                	mov    %eax,%edi
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
f0100193:	8d 1d 78 1d 00 00    	lea    0x1d78,%ebx
f0100199:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f010019c:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010019f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	while ((c = (*proc)()) != -1) {
f01001a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01001a5:	ff d0                	call   *%eax
f01001a7:	83 f8 ff             	cmp    $0xffffffff,%eax
f01001aa:	74 2b                	je     f01001d7 <cons_intr+0x5a>
		if (c == 0)
f01001ac:	85 c0                	test   %eax,%eax
f01001ae:	74 f2                	je     f01001a2 <cons_intr+0x25>
		cons.buf[cons.wpos++] = c;
f01001b0:	8b 8c 1e 04 02 00 00 	mov    0x204(%esi,%ebx,1),%ecx
f01001b7:	8d 51 01             	lea    0x1(%ecx),%edx
f01001ba:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01001bd:	88 04 0f             	mov    %al,(%edi,%ecx,1)
		if (cons.wpos == CONSBUFSIZE)
f01001c0:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01001c6:	b8 00 00 00 00       	mov    $0x0,%eax
f01001cb:	0f 44 d0             	cmove  %eax,%edx
f01001ce:	89 94 1e 04 02 00 00 	mov    %edx,0x204(%esi,%ebx,1)
f01001d5:	eb cb                	jmp    f01001a2 <cons_intr+0x25>
	}
}
f01001d7:	83 c4 1c             	add    $0x1c,%esp
f01001da:	5b                   	pop    %ebx
f01001db:	5e                   	pop    %esi
f01001dc:	5f                   	pop    %edi
f01001dd:	5d                   	pop    %ebp
f01001de:	c3                   	ret    

f01001df <kbd_proc_data>:
{
f01001df:	f3 0f 1e fb          	endbr32 
f01001e3:	55                   	push   %ebp
f01001e4:	89 e5                	mov    %esp,%ebp
f01001e6:	56                   	push   %esi
f01001e7:	53                   	push   %ebx
f01001e8:	e8 6e ff ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f01001ed:	81 c3 1b 81 01 00    	add    $0x1811b,%ebx
f01001f3:	ba 64 00 00 00       	mov    $0x64,%edx
f01001f8:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01001f9:	a8 01                	test   $0x1,%al
f01001fb:	0f 84 fb 00 00 00    	je     f01002fc <kbd_proc_data+0x11d>
	if (stat & KBS_TERR)
f0100201:	a8 20                	test   $0x20,%al
f0100203:	0f 85 fa 00 00 00    	jne    f0100303 <kbd_proc_data+0x124>
f0100209:	ba 60 00 00 00       	mov    $0x60,%edx
f010020e:	ec                   	in     (%dx),%al
f010020f:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100211:	3c e0                	cmp    $0xe0,%al
f0100213:	74 64                	je     f0100279 <kbd_proc_data+0x9a>
	} else if (data & 0x80) {
f0100215:	84 c0                	test   %al,%al
f0100217:	78 75                	js     f010028e <kbd_proc_data+0xaf>
	} else if (shift & E0ESC) {
f0100219:	8b 8b 58 1d 00 00    	mov    0x1d58(%ebx),%ecx
f010021f:	f6 c1 40             	test   $0x40,%cl
f0100222:	74 0e                	je     f0100232 <kbd_proc_data+0x53>
		data |= 0x80;
f0100224:	83 c8 80             	or     $0xffffff80,%eax
f0100227:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100229:	83 e1 bf             	and    $0xffffffbf,%ecx
f010022c:	89 8b 58 1d 00 00    	mov    %ecx,0x1d58(%ebx)
	shift |= shiftcode[data];
f0100232:	0f b6 d2             	movzbl %dl,%edx
f0100235:	0f b6 84 13 d8 bf fe 	movzbl -0x14028(%ebx,%edx,1),%eax
f010023c:	ff 
f010023d:	0b 83 58 1d 00 00    	or     0x1d58(%ebx),%eax
	shift ^= togglecode[data];
f0100243:	0f b6 8c 13 d8 be fe 	movzbl -0x14128(%ebx,%edx,1),%ecx
f010024a:	ff 
f010024b:	31 c8                	xor    %ecx,%eax
f010024d:	89 83 58 1d 00 00    	mov    %eax,0x1d58(%ebx)
	c = charcode[shift & (CTL | SHIFT)][data];
f0100253:	89 c1                	mov    %eax,%ecx
f0100255:	83 e1 03             	and    $0x3,%ecx
f0100258:	8b 8c 8b f8 1c 00 00 	mov    0x1cf8(%ebx,%ecx,4),%ecx
f010025f:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100263:	0f b6 f2             	movzbl %dl,%esi
	if (shift & CAPSLOCK) {
f0100266:	a8 08                	test   $0x8,%al
f0100268:	74 65                	je     f01002cf <kbd_proc_data+0xf0>
		if ('a' <= c && c <= 'z')
f010026a:	89 f2                	mov    %esi,%edx
f010026c:	8d 4e 9f             	lea    -0x61(%esi),%ecx
f010026f:	83 f9 19             	cmp    $0x19,%ecx
f0100272:	77 4f                	ja     f01002c3 <kbd_proc_data+0xe4>
			c += 'A' - 'a';
f0100274:	83 ee 20             	sub    $0x20,%esi
f0100277:	eb 0c                	jmp    f0100285 <kbd_proc_data+0xa6>
		shift |= E0ESC;
f0100279:	83 8b 58 1d 00 00 40 	orl    $0x40,0x1d58(%ebx)
		return 0;
f0100280:	be 00 00 00 00       	mov    $0x0,%esi
}
f0100285:	89 f0                	mov    %esi,%eax
f0100287:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010028a:	5b                   	pop    %ebx
f010028b:	5e                   	pop    %esi
f010028c:	5d                   	pop    %ebp
f010028d:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010028e:	8b 8b 58 1d 00 00    	mov    0x1d58(%ebx),%ecx
f0100294:	89 ce                	mov    %ecx,%esi
f0100296:	83 e6 40             	and    $0x40,%esi
f0100299:	83 e0 7f             	and    $0x7f,%eax
f010029c:	85 f6                	test   %esi,%esi
f010029e:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01002a1:	0f b6 d2             	movzbl %dl,%edx
f01002a4:	0f b6 84 13 d8 bf fe 	movzbl -0x14028(%ebx,%edx,1),%eax
f01002ab:	ff 
f01002ac:	83 c8 40             	or     $0x40,%eax
f01002af:	0f b6 c0             	movzbl %al,%eax
f01002b2:	f7 d0                	not    %eax
f01002b4:	21 c8                	and    %ecx,%eax
f01002b6:	89 83 58 1d 00 00    	mov    %eax,0x1d58(%ebx)
		return 0;
f01002bc:	be 00 00 00 00       	mov    $0x0,%esi
f01002c1:	eb c2                	jmp    f0100285 <kbd_proc_data+0xa6>
		else if ('A' <= c && c <= 'Z')
f01002c3:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01002c6:	8d 4e 20             	lea    0x20(%esi),%ecx
f01002c9:	83 fa 1a             	cmp    $0x1a,%edx
f01002cc:	0f 42 f1             	cmovb  %ecx,%esi
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01002cf:	f7 d0                	not    %eax
f01002d1:	a8 06                	test   $0x6,%al
f01002d3:	75 b0                	jne    f0100285 <kbd_proc_data+0xa6>
f01002d5:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
f01002db:	75 a8                	jne    f0100285 <kbd_proc_data+0xa6>
		cprintf("Rebooting!\n");
f01002dd:	83 ec 0c             	sub    $0xc,%esp
f01002e0:	8d 83 a5 be fe ff    	lea    -0x1415b(%ebx),%eax
f01002e6:	50                   	push   %eax
f01002e7:	e8 ad 2d 00 00       	call   f0103099 <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002ec:	b8 03 00 00 00       	mov    $0x3,%eax
f01002f1:	ba 92 00 00 00       	mov    $0x92,%edx
f01002f6:	ee                   	out    %al,(%dx)
}
f01002f7:	83 c4 10             	add    $0x10,%esp
f01002fa:	eb 89                	jmp    f0100285 <kbd_proc_data+0xa6>
		return -1;
f01002fc:	be ff ff ff ff       	mov    $0xffffffff,%esi
f0100301:	eb 82                	jmp    f0100285 <kbd_proc_data+0xa6>
		return -1;
f0100303:	be ff ff ff ff       	mov    $0xffffffff,%esi
f0100308:	e9 78 ff ff ff       	jmp    f0100285 <kbd_proc_data+0xa6>

f010030d <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f010030d:	55                   	push   %ebp
f010030e:	89 e5                	mov    %esp,%ebp
f0100310:	57                   	push   %edi
f0100311:	56                   	push   %esi
f0100312:	53                   	push   %ebx
f0100313:	83 ec 1c             	sub    $0x1c,%esp
f0100316:	e8 40 fe ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f010031b:	81 c3 ed 7f 01 00    	add    $0x17fed,%ebx
f0100321:	89 c7                	mov    %eax,%edi
	for (i = 0;
f0100323:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100328:	b9 84 00 00 00       	mov    $0x84,%ecx
f010032d:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100332:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100333:	a8 20                	test   $0x20,%al
f0100335:	75 13                	jne    f010034a <cons_putc+0x3d>
f0100337:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010033d:	7f 0b                	jg     f010034a <cons_putc+0x3d>
f010033f:	89 ca                	mov    %ecx,%edx
f0100341:	ec                   	in     (%dx),%al
f0100342:	ec                   	in     (%dx),%al
f0100343:	ec                   	in     (%dx),%al
f0100344:	ec                   	in     (%dx),%al
	     i++)
f0100345:	83 c6 01             	add    $0x1,%esi
f0100348:	eb e3                	jmp    f010032d <cons_putc+0x20>
	outb(COM1 + COM_TX, c);
f010034a:	89 f8                	mov    %edi,%eax
f010034c:	88 45 e7             	mov    %al,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010034f:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100354:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100355:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010035a:	b9 84 00 00 00       	mov    $0x84,%ecx
f010035f:	ba 79 03 00 00       	mov    $0x379,%edx
f0100364:	ec                   	in     (%dx),%al
f0100365:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010036b:	7f 0f                	jg     f010037c <cons_putc+0x6f>
f010036d:	84 c0                	test   %al,%al
f010036f:	78 0b                	js     f010037c <cons_putc+0x6f>
f0100371:	89 ca                	mov    %ecx,%edx
f0100373:	ec                   	in     (%dx),%al
f0100374:	ec                   	in     (%dx),%al
f0100375:	ec                   	in     (%dx),%al
f0100376:	ec                   	in     (%dx),%al
f0100377:	83 c6 01             	add    $0x1,%esi
f010037a:	eb e3                	jmp    f010035f <cons_putc+0x52>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010037c:	ba 78 03 00 00       	mov    $0x378,%edx
f0100381:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100385:	ee                   	out    %al,(%dx)
f0100386:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010038b:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100390:	ee                   	out    %al,(%dx)
f0100391:	b8 08 00 00 00       	mov    $0x8,%eax
f0100396:	ee                   	out    %al,(%dx)
		c |= 0x0700;
f0100397:	89 f8                	mov    %edi,%eax
f0100399:	80 cc 07             	or     $0x7,%ah
f010039c:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f01003a2:	0f 44 f8             	cmove  %eax,%edi
	switch (c & 0xff) {
f01003a5:	89 f8                	mov    %edi,%eax
f01003a7:	0f b6 c0             	movzbl %al,%eax
f01003aa:	89 f9                	mov    %edi,%ecx
f01003ac:	80 f9 0a             	cmp    $0xa,%cl
f01003af:	0f 84 e2 00 00 00    	je     f0100497 <cons_putc+0x18a>
f01003b5:	83 f8 0a             	cmp    $0xa,%eax
f01003b8:	7f 46                	jg     f0100400 <cons_putc+0xf3>
f01003ba:	83 f8 08             	cmp    $0x8,%eax
f01003bd:	0f 84 a8 00 00 00    	je     f010046b <cons_putc+0x15e>
f01003c3:	83 f8 09             	cmp    $0x9,%eax
f01003c6:	0f 85 d8 00 00 00    	jne    f01004a4 <cons_putc+0x197>
		cons_putc(' ');
f01003cc:	b8 20 00 00 00       	mov    $0x20,%eax
f01003d1:	e8 37 ff ff ff       	call   f010030d <cons_putc>
		cons_putc(' ');
f01003d6:	b8 20 00 00 00       	mov    $0x20,%eax
f01003db:	e8 2d ff ff ff       	call   f010030d <cons_putc>
		cons_putc(' ');
f01003e0:	b8 20 00 00 00       	mov    $0x20,%eax
f01003e5:	e8 23 ff ff ff       	call   f010030d <cons_putc>
		cons_putc(' ');
f01003ea:	b8 20 00 00 00       	mov    $0x20,%eax
f01003ef:	e8 19 ff ff ff       	call   f010030d <cons_putc>
		cons_putc(' ');
f01003f4:	b8 20 00 00 00       	mov    $0x20,%eax
f01003f9:	e8 0f ff ff ff       	call   f010030d <cons_putc>
		break;
f01003fe:	eb 26                	jmp    f0100426 <cons_putc+0x119>
	switch (c & 0xff) {
f0100400:	83 f8 0d             	cmp    $0xd,%eax
f0100403:	0f 85 9b 00 00 00    	jne    f01004a4 <cons_putc+0x197>
		crt_pos -= (crt_pos % CRT_COLS);
f0100409:	0f b7 83 80 1f 00 00 	movzwl 0x1f80(%ebx),%eax
f0100410:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100416:	c1 e8 16             	shr    $0x16,%eax
f0100419:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010041c:	c1 e0 04             	shl    $0x4,%eax
f010041f:	66 89 83 80 1f 00 00 	mov    %ax,0x1f80(%ebx)
	if (crt_pos >= CRT_SIZE) {
f0100426:	66 81 bb 80 1f 00 00 	cmpw   $0x7cf,0x1f80(%ebx)
f010042d:	cf 07 
f010042f:	0f 87 92 00 00 00    	ja     f01004c7 <cons_putc+0x1ba>
	outb(addr_6845, 14);
f0100435:	8b 8b 88 1f 00 00    	mov    0x1f88(%ebx),%ecx
f010043b:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100440:	89 ca                	mov    %ecx,%edx
f0100442:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100443:	0f b7 9b 80 1f 00 00 	movzwl 0x1f80(%ebx),%ebx
f010044a:	8d 71 01             	lea    0x1(%ecx),%esi
f010044d:	89 d8                	mov    %ebx,%eax
f010044f:	66 c1 e8 08          	shr    $0x8,%ax
f0100453:	89 f2                	mov    %esi,%edx
f0100455:	ee                   	out    %al,(%dx)
f0100456:	b8 0f 00 00 00       	mov    $0xf,%eax
f010045b:	89 ca                	mov    %ecx,%edx
f010045d:	ee                   	out    %al,(%dx)
f010045e:	89 d8                	mov    %ebx,%eax
f0100460:	89 f2                	mov    %esi,%edx
f0100462:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100463:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100466:	5b                   	pop    %ebx
f0100467:	5e                   	pop    %esi
f0100468:	5f                   	pop    %edi
f0100469:	5d                   	pop    %ebp
f010046a:	c3                   	ret    
		if (crt_pos > 0) {
f010046b:	0f b7 83 80 1f 00 00 	movzwl 0x1f80(%ebx),%eax
f0100472:	66 85 c0             	test   %ax,%ax
f0100475:	74 be                	je     f0100435 <cons_putc+0x128>
			crt_pos--;
f0100477:	83 e8 01             	sub    $0x1,%eax
f010047a:	66 89 83 80 1f 00 00 	mov    %ax,0x1f80(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100481:	0f b7 c0             	movzwl %ax,%eax
f0100484:	89 fa                	mov    %edi,%edx
f0100486:	b2 00                	mov    $0x0,%dl
f0100488:	83 ca 20             	or     $0x20,%edx
f010048b:	8b 8b 84 1f 00 00    	mov    0x1f84(%ebx),%ecx
f0100491:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
f0100495:	eb 8f                	jmp    f0100426 <cons_putc+0x119>
		crt_pos += CRT_COLS;
f0100497:	66 83 83 80 1f 00 00 	addw   $0x50,0x1f80(%ebx)
f010049e:	50 
f010049f:	e9 65 ff ff ff       	jmp    f0100409 <cons_putc+0xfc>
		crt_buf[crt_pos++] = c;		/* write the character */
f01004a4:	0f b7 83 80 1f 00 00 	movzwl 0x1f80(%ebx),%eax
f01004ab:	8d 50 01             	lea    0x1(%eax),%edx
f01004ae:	66 89 93 80 1f 00 00 	mov    %dx,0x1f80(%ebx)
f01004b5:	0f b7 c0             	movzwl %ax,%eax
f01004b8:	8b 93 84 1f 00 00    	mov    0x1f84(%ebx),%edx
f01004be:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
f01004c2:	e9 5f ff ff ff       	jmp    f0100426 <cons_putc+0x119>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01004c7:	8b 83 84 1f 00 00    	mov    0x1f84(%ebx),%eax
f01004cd:	83 ec 04             	sub    $0x4,%esp
f01004d0:	68 00 0f 00 00       	push   $0xf00
f01004d5:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01004db:	52                   	push   %edx
f01004dc:	50                   	push   %eax
f01004dd:	e8 48 38 00 00       	call   f0103d2a <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01004e2:	8b 93 84 1f 00 00    	mov    0x1f84(%ebx),%edx
f01004e8:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01004ee:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01004f4:	83 c4 10             	add    $0x10,%esp
f01004f7:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01004fc:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01004ff:	39 d0                	cmp    %edx,%eax
f0100501:	75 f4                	jne    f01004f7 <cons_putc+0x1ea>
		crt_pos -= CRT_COLS;
f0100503:	66 83 ab 80 1f 00 00 	subw   $0x50,0x1f80(%ebx)
f010050a:	50 
f010050b:	e9 25 ff ff ff       	jmp    f0100435 <cons_putc+0x128>

f0100510 <serial_intr>:
{
f0100510:	f3 0f 1e fb          	endbr32 
f0100514:	e8 f6 01 00 00       	call   f010070f <__x86.get_pc_thunk.ax>
f0100519:	05 ef 7d 01 00       	add    $0x17def,%eax
	if (serial_exists)
f010051e:	80 b8 8c 1f 00 00 00 	cmpb   $0x0,0x1f8c(%eax)
f0100525:	75 01                	jne    f0100528 <serial_intr+0x18>
f0100527:	c3                   	ret    
{
f0100528:	55                   	push   %ebp
f0100529:	89 e5                	mov    %esp,%ebp
f010052b:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010052e:	8d 80 57 7e fe ff    	lea    -0x181a9(%eax),%eax
f0100534:	e8 44 fc ff ff       	call   f010017d <cons_intr>
}
f0100539:	c9                   	leave  
f010053a:	c3                   	ret    

f010053b <kbd_intr>:
{
f010053b:	f3 0f 1e fb          	endbr32 
f010053f:	55                   	push   %ebp
f0100540:	89 e5                	mov    %esp,%ebp
f0100542:	83 ec 08             	sub    $0x8,%esp
f0100545:	e8 c5 01 00 00       	call   f010070f <__x86.get_pc_thunk.ax>
f010054a:	05 be 7d 01 00       	add    $0x17dbe,%eax
	cons_intr(kbd_proc_data);
f010054f:	8d 80 d7 7e fe ff    	lea    -0x18129(%eax),%eax
f0100555:	e8 23 fc ff ff       	call   f010017d <cons_intr>
}
f010055a:	c9                   	leave  
f010055b:	c3                   	ret    

f010055c <cons_getc>:
{
f010055c:	f3 0f 1e fb          	endbr32 
f0100560:	55                   	push   %ebp
f0100561:	89 e5                	mov    %esp,%ebp
f0100563:	53                   	push   %ebx
f0100564:	83 ec 04             	sub    $0x4,%esp
f0100567:	e8 ef fb ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f010056c:	81 c3 9c 7d 01 00    	add    $0x17d9c,%ebx
	serial_intr();
f0100572:	e8 99 ff ff ff       	call   f0100510 <serial_intr>
	kbd_intr();
f0100577:	e8 bf ff ff ff       	call   f010053b <kbd_intr>
	if (cons.rpos != cons.wpos) {
f010057c:	8b 83 78 1f 00 00    	mov    0x1f78(%ebx),%eax
	return 0;
f0100582:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f0100587:	3b 83 7c 1f 00 00    	cmp    0x1f7c(%ebx),%eax
f010058d:	74 1f                	je     f01005ae <cons_getc+0x52>
		c = cons.buf[cons.rpos++];
f010058f:	8d 48 01             	lea    0x1(%eax),%ecx
f0100592:	0f b6 94 03 78 1d 00 	movzbl 0x1d78(%ebx,%eax,1),%edx
f0100599:	00 
			cons.rpos = 0;
f010059a:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f01005a0:	b8 00 00 00 00       	mov    $0x0,%eax
f01005a5:	0f 44 c8             	cmove  %eax,%ecx
f01005a8:	89 8b 78 1f 00 00    	mov    %ecx,0x1f78(%ebx)
}
f01005ae:	89 d0                	mov    %edx,%eax
f01005b0:	83 c4 04             	add    $0x4,%esp
f01005b3:	5b                   	pop    %ebx
f01005b4:	5d                   	pop    %ebp
f01005b5:	c3                   	ret    

f01005b6 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f01005b6:	f3 0f 1e fb          	endbr32 
f01005ba:	55                   	push   %ebp
f01005bb:	89 e5                	mov    %esp,%ebp
f01005bd:	57                   	push   %edi
f01005be:	56                   	push   %esi
f01005bf:	53                   	push   %ebx
f01005c0:	83 ec 1c             	sub    $0x1c,%esp
f01005c3:	e8 93 fb ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f01005c8:	81 c3 40 7d 01 00    	add    $0x17d40,%ebx
	was = *cp;
f01005ce:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01005d5:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01005dc:	5a a5 
	if (*cp != 0xA55A) {
f01005de:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01005e5:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01005e9:	0f 84 bc 00 00 00    	je     f01006ab <cons_init+0xf5>
		addr_6845 = MONO_BASE;
f01005ef:	c7 83 88 1f 00 00 b4 	movl   $0x3b4,0x1f88(%ebx)
f01005f6:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01005f9:	c7 45 e4 00 00 0b f0 	movl   $0xf00b0000,-0x1c(%ebp)
	outb(addr_6845, 14);
f0100600:	8b bb 88 1f 00 00    	mov    0x1f88(%ebx),%edi
f0100606:	b8 0e 00 00 00       	mov    $0xe,%eax
f010060b:	89 fa                	mov    %edi,%edx
f010060d:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010060e:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100611:	89 ca                	mov    %ecx,%edx
f0100613:	ec                   	in     (%dx),%al
f0100614:	0f b6 f0             	movzbl %al,%esi
f0100617:	c1 e6 08             	shl    $0x8,%esi
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010061a:	b8 0f 00 00 00       	mov    $0xf,%eax
f010061f:	89 fa                	mov    %edi,%edx
f0100621:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100622:	89 ca                	mov    %ecx,%edx
f0100624:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f0100625:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100628:	89 bb 84 1f 00 00    	mov    %edi,0x1f84(%ebx)
	pos |= inb(addr_6845 + 1);
f010062e:	0f b6 c0             	movzbl %al,%eax
f0100631:	09 c6                	or     %eax,%esi
	crt_pos = pos;
f0100633:	66 89 b3 80 1f 00 00 	mov    %si,0x1f80(%ebx)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010063a:	b9 00 00 00 00       	mov    $0x0,%ecx
f010063f:	89 c8                	mov    %ecx,%eax
f0100641:	ba fa 03 00 00       	mov    $0x3fa,%edx
f0100646:	ee                   	out    %al,(%dx)
f0100647:	bf fb 03 00 00       	mov    $0x3fb,%edi
f010064c:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100651:	89 fa                	mov    %edi,%edx
f0100653:	ee                   	out    %al,(%dx)
f0100654:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100659:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010065e:	ee                   	out    %al,(%dx)
f010065f:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100664:	89 c8                	mov    %ecx,%eax
f0100666:	89 f2                	mov    %esi,%edx
f0100668:	ee                   	out    %al,(%dx)
f0100669:	b8 03 00 00 00       	mov    $0x3,%eax
f010066e:	89 fa                	mov    %edi,%edx
f0100670:	ee                   	out    %al,(%dx)
f0100671:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100676:	89 c8                	mov    %ecx,%eax
f0100678:	ee                   	out    %al,(%dx)
f0100679:	b8 01 00 00 00       	mov    $0x1,%eax
f010067e:	89 f2                	mov    %esi,%edx
f0100680:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100681:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100686:	ec                   	in     (%dx),%al
f0100687:	89 c1                	mov    %eax,%ecx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100689:	3c ff                	cmp    $0xff,%al
f010068b:	0f 95 83 8c 1f 00 00 	setne  0x1f8c(%ebx)
f0100692:	ba fa 03 00 00       	mov    $0x3fa,%edx
f0100697:	ec                   	in     (%dx),%al
f0100698:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010069d:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f010069e:	80 f9 ff             	cmp    $0xff,%cl
f01006a1:	74 25                	je     f01006c8 <cons_init+0x112>
		cprintf("Serial port does not exist!\n");
}
f01006a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01006a6:	5b                   	pop    %ebx
f01006a7:	5e                   	pop    %esi
f01006a8:	5f                   	pop    %edi
f01006a9:	5d                   	pop    %ebp
f01006aa:	c3                   	ret    
		*cp = was;
f01006ab:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01006b2:	c7 83 88 1f 00 00 d4 	movl   $0x3d4,0x1f88(%ebx)
f01006b9:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01006bc:	c7 45 e4 00 80 0b f0 	movl   $0xf00b8000,-0x1c(%ebp)
f01006c3:	e9 38 ff ff ff       	jmp    f0100600 <cons_init+0x4a>
		cprintf("Serial port does not exist!\n");
f01006c8:	83 ec 0c             	sub    $0xc,%esp
f01006cb:	8d 83 b1 be fe ff    	lea    -0x1414f(%ebx),%eax
f01006d1:	50                   	push   %eax
f01006d2:	e8 c2 29 00 00       	call   f0103099 <cprintf>
f01006d7:	83 c4 10             	add    $0x10,%esp
}
f01006da:	eb c7                	jmp    f01006a3 <cons_init+0xed>

f01006dc <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01006dc:	f3 0f 1e fb          	endbr32 
f01006e0:	55                   	push   %ebp
f01006e1:	89 e5                	mov    %esp,%ebp
f01006e3:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01006e6:	8b 45 08             	mov    0x8(%ebp),%eax
f01006e9:	e8 1f fc ff ff       	call   f010030d <cons_putc>
}
f01006ee:	c9                   	leave  
f01006ef:	c3                   	ret    

f01006f0 <getchar>:

int
getchar(void)
{
f01006f0:	f3 0f 1e fb          	endbr32 
f01006f4:	55                   	push   %ebp
f01006f5:	89 e5                	mov    %esp,%ebp
f01006f7:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01006fa:	e8 5d fe ff ff       	call   f010055c <cons_getc>
f01006ff:	85 c0                	test   %eax,%eax
f0100701:	74 f7                	je     f01006fa <getchar+0xa>
		/* do nothing */;
	return c;
}
f0100703:	c9                   	leave  
f0100704:	c3                   	ret    

f0100705 <iscons>:

int
iscons(int fdnum)
{
f0100705:	f3 0f 1e fb          	endbr32 
	// used by readline
	return 1;
}
f0100709:	b8 01 00 00 00       	mov    $0x1,%eax
f010070e:	c3                   	ret    

f010070f <__x86.get_pc_thunk.ax>:
f010070f:	8b 04 24             	mov    (%esp),%eax
f0100712:	c3                   	ret    

f0100713 <__x86.get_pc_thunk.si>:
f0100713:	8b 34 24             	mov    (%esp),%esi
f0100716:	c3                   	ret    

f0100717 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100717:	f3 0f 1e fb          	endbr32 
f010071b:	55                   	push   %ebp
f010071c:	89 e5                	mov    %esp,%ebp
f010071e:	56                   	push   %esi
f010071f:	53                   	push   %ebx
f0100720:	e8 36 fa ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f0100725:	81 c3 e3 7b 01 00    	add    $0x17be3,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010072b:	83 ec 04             	sub    $0x4,%esp
f010072e:	8d 83 d8 c0 fe ff    	lea    -0x13f28(%ebx),%eax
f0100734:	50                   	push   %eax
f0100735:	8d 83 f6 c0 fe ff    	lea    -0x13f0a(%ebx),%eax
f010073b:	50                   	push   %eax
f010073c:	8d b3 fb c0 fe ff    	lea    -0x13f05(%ebx),%esi
f0100742:	56                   	push   %esi
f0100743:	e8 51 29 00 00       	call   f0103099 <cprintf>
f0100748:	83 c4 0c             	add    $0xc,%esp
f010074b:	8d 83 ac c1 fe ff    	lea    -0x13e54(%ebx),%eax
f0100751:	50                   	push   %eax
f0100752:	8d 83 04 c1 fe ff    	lea    -0x13efc(%ebx),%eax
f0100758:	50                   	push   %eax
f0100759:	56                   	push   %esi
f010075a:	e8 3a 29 00 00       	call   f0103099 <cprintf>
f010075f:	83 c4 0c             	add    $0xc,%esp
f0100762:	8d 83 d4 c1 fe ff    	lea    -0x13e2c(%ebx),%eax
f0100768:	50                   	push   %eax
f0100769:	8d 83 0d c1 fe ff    	lea    -0x13ef3(%ebx),%eax
f010076f:	50                   	push   %eax
f0100770:	56                   	push   %esi
f0100771:	e8 23 29 00 00       	call   f0103099 <cprintf>
	return 0;
}
f0100776:	b8 00 00 00 00       	mov    $0x0,%eax
f010077b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010077e:	5b                   	pop    %ebx
f010077f:	5e                   	pop    %esi
f0100780:	5d                   	pop    %ebp
f0100781:	c3                   	ret    

f0100782 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100782:	f3 0f 1e fb          	endbr32 
f0100786:	55                   	push   %ebp
f0100787:	89 e5                	mov    %esp,%ebp
f0100789:	57                   	push   %edi
f010078a:	56                   	push   %esi
f010078b:	53                   	push   %ebx
f010078c:	83 ec 18             	sub    $0x18,%esp
f010078f:	e8 c7 f9 ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f0100794:	81 c3 74 7b 01 00    	add    $0x17b74,%ebx
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010079a:	8d 83 17 c1 fe ff    	lea    -0x13ee9(%ebx),%eax
f01007a0:	50                   	push   %eax
f01007a1:	e8 f3 28 00 00       	call   f0103099 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01007a6:	83 c4 08             	add    $0x8,%esp
f01007a9:	ff b3 f8 ff ff ff    	pushl  -0x8(%ebx)
f01007af:	8d 83 fc c1 fe ff    	lea    -0x13e04(%ebx),%eax
f01007b5:	50                   	push   %eax
f01007b6:	e8 de 28 00 00       	call   f0103099 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01007bb:	83 c4 0c             	add    $0xc,%esp
f01007be:	c7 c7 0c 00 10 f0    	mov    $0xf010000c,%edi
f01007c4:	8d 87 00 00 00 10    	lea    0x10000000(%edi),%eax
f01007ca:	50                   	push   %eax
f01007cb:	57                   	push   %edi
f01007cc:	8d 83 24 c2 fe ff    	lea    -0x13ddc(%ebx),%eax
f01007d2:	50                   	push   %eax
f01007d3:	e8 c1 28 00 00       	call   f0103099 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01007d8:	83 c4 0c             	add    $0xc,%esp
f01007db:	c7 c0 4d 41 10 f0    	mov    $0xf010414d,%eax
f01007e1:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01007e7:	52                   	push   %edx
f01007e8:	50                   	push   %eax
f01007e9:	8d 83 48 c2 fe ff    	lea    -0x13db8(%ebx),%eax
f01007ef:	50                   	push   %eax
f01007f0:	e8 a4 28 00 00       	call   f0103099 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01007f5:	83 c4 0c             	add    $0xc,%esp
f01007f8:	c7 c0 60 a0 11 f0    	mov    $0xf011a060,%eax
f01007fe:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0100804:	52                   	push   %edx
f0100805:	50                   	push   %eax
f0100806:	8d 83 6c c2 fe ff    	lea    -0x13d94(%ebx),%eax
f010080c:	50                   	push   %eax
f010080d:	e8 87 28 00 00       	call   f0103099 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100812:	83 c4 0c             	add    $0xc,%esp
f0100815:	c7 c6 c0 a6 11 f0    	mov    $0xf011a6c0,%esi
f010081b:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f0100821:	50                   	push   %eax
f0100822:	56                   	push   %esi
f0100823:	8d 83 90 c2 fe ff    	lea    -0x13d70(%ebx),%eax
f0100829:	50                   	push   %eax
f010082a:	e8 6a 28 00 00       	call   f0103099 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f010082f:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100832:	29 fe                	sub    %edi,%esi
f0100834:	81 c6 ff 03 00 00    	add    $0x3ff,%esi
	cprintf("Kernel executable memory footprint: %dKB\n",
f010083a:	c1 fe 0a             	sar    $0xa,%esi
f010083d:	56                   	push   %esi
f010083e:	8d 83 b4 c2 fe ff    	lea    -0x13d4c(%ebx),%eax
f0100844:	50                   	push   %eax
f0100845:	e8 4f 28 00 00       	call   f0103099 <cprintf>
	return 0;
}
f010084a:	b8 00 00 00 00       	mov    $0x0,%eax
f010084f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100852:	5b                   	pop    %ebx
f0100853:	5e                   	pop    %esi
f0100854:	5f                   	pop    %edi
f0100855:	5d                   	pop    %ebp
f0100856:	c3                   	ret    

f0100857 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100857:	f3 0f 1e fb          	endbr32 
f010085b:	55                   	push   %ebp
f010085c:	89 e5                	mov    %esp,%ebp
f010085e:	57                   	push   %edi
f010085f:	56                   	push   %esi
f0100860:	53                   	push   %ebx
f0100861:	83 ec 48             	sub    $0x48,%esp
f0100864:	e8 f2 f8 ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f0100869:	81 c3 9f 7a 01 00    	add    $0x17a9f,%ebx

static inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f010086f:	89 e8                	mov    %ebp,%eax
	// Your code here.
	uint32_t* ebp = (uint32_t*) read_ebp();
f0100871:	89 c7                	mov    %eax,%edi
	cprintf("Stack backtrace:\n");
f0100873:	8d 83 30 c1 fe ff    	lea    -0x13ed0(%ebx),%eax
f0100879:	50                   	push   %eax
f010087a:	e8 1a 28 00 00       	call   f0103099 <cprintf>
	while (ebp) {
f010087f:	83 c4 10             	add    $0x10,%esp
		uint32_t eip = ebp[1];
		cprintf("ebp %x  eip %x  args", ebp, eip);
f0100882:	8d 83 42 c1 fe ff    	lea    -0x13ebe(%ebx),%eax
f0100888:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int i;
		for (i = 2; i <= 6; ++i)
			cprintf(" %08.x", ebp[i]);
f010088b:	8d 83 57 c1 fe ff    	lea    -0x13ea9(%ebx),%eax
f0100891:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	while (ebp) {
f0100894:	eb 48                	jmp    f01008de <mon_backtrace+0x87>
f0100896:	8b 7d bc             	mov    -0x44(%ebp),%edi
		cprintf("\n");
f0100899:	83 ec 0c             	sub    $0xc,%esp
f010089c:	8d 83 b6 cd fe ff    	lea    -0x1324a(%ebx),%eax
f01008a2:	50                   	push   %eax
f01008a3:	e8 f1 27 00 00       	call   f0103099 <cprintf>
		struct Eipdebuginfo info;
		debuginfo_eip(eip, &info);
f01008a8:	83 c4 08             	add    $0x8,%esp
f01008ab:	8d 45 d0             	lea    -0x30(%ebp),%eax
f01008ae:	50                   	push   %eax
f01008af:	8b 75 c0             	mov    -0x40(%ebp),%esi
f01008b2:	56                   	push   %esi
f01008b3:	e8 ee 28 00 00       	call   f01031a6 <debuginfo_eip>
		cprintf("\t%s:%d: %.*s+%d\n", 
f01008b8:	83 c4 08             	add    $0x8,%esp
f01008bb:	89 f0                	mov    %esi,%eax
f01008bd:	2b 45 e0             	sub    -0x20(%ebp),%eax
f01008c0:	50                   	push   %eax
f01008c1:	ff 75 d8             	pushl  -0x28(%ebp)
f01008c4:	ff 75 dc             	pushl  -0x24(%ebp)
f01008c7:	ff 75 d4             	pushl  -0x2c(%ebp)
f01008ca:	ff 75 d0             	pushl  -0x30(%ebp)
f01008cd:	8d 83 5e c1 fe ff    	lea    -0x13ea2(%ebx),%eax
f01008d3:	50                   	push   %eax
f01008d4:	e8 c0 27 00 00       	call   f0103099 <cprintf>
			info.eip_file, info.eip_line,
			info.eip_fn_namelen, info.eip_fn_name,
			eip-info.eip_fn_addr);
		ebp = (uint32_t*) *ebp;
f01008d9:	8b 3f                	mov    (%edi),%edi
f01008db:	83 c4 20             	add    $0x20,%esp
	while (ebp) {
f01008de:	85 ff                	test   %edi,%edi
f01008e0:	74 3d                	je     f010091f <mon_backtrace+0xc8>
		uint32_t eip = ebp[1];
f01008e2:	8b 47 04             	mov    0x4(%edi),%eax
f01008e5:	89 45 c0             	mov    %eax,-0x40(%ebp)
		cprintf("ebp %x  eip %x  args", ebp, eip);
f01008e8:	83 ec 04             	sub    $0x4,%esp
f01008eb:	50                   	push   %eax
f01008ec:	57                   	push   %edi
f01008ed:	ff 75 b8             	pushl  -0x48(%ebp)
f01008f0:	e8 a4 27 00 00       	call   f0103099 <cprintf>
f01008f5:	8d 77 08             	lea    0x8(%edi),%esi
f01008f8:	8d 47 1c             	lea    0x1c(%edi),%eax
f01008fb:	83 c4 10             	add    $0x10,%esp
f01008fe:	89 7d bc             	mov    %edi,-0x44(%ebp)
f0100901:	89 c7                	mov    %eax,%edi
			cprintf(" %08.x", ebp[i]);
f0100903:	83 ec 08             	sub    $0x8,%esp
f0100906:	ff 36                	pushl  (%esi)
f0100908:	ff 75 c4             	pushl  -0x3c(%ebp)
f010090b:	e8 89 27 00 00       	call   f0103099 <cprintf>
f0100910:	83 c6 04             	add    $0x4,%esi
		for (i = 2; i <= 6; ++i)
f0100913:	83 c4 10             	add    $0x10,%esp
f0100916:	39 fe                	cmp    %edi,%esi
f0100918:	75 e9                	jne    f0100903 <mon_backtrace+0xac>
f010091a:	e9 77 ff ff ff       	jmp    f0100896 <mon_backtrace+0x3f>
	}
	return 0;
}
f010091f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100924:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100927:	5b                   	pop    %ebx
f0100928:	5e                   	pop    %esi
f0100929:	5f                   	pop    %edi
f010092a:	5d                   	pop    %ebp
f010092b:	c3                   	ret    

f010092c <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f010092c:	f3 0f 1e fb          	endbr32 
f0100930:	55                   	push   %ebp
f0100931:	89 e5                	mov    %esp,%ebp
f0100933:	57                   	push   %edi
f0100934:	56                   	push   %esi
f0100935:	53                   	push   %ebx
f0100936:	83 ec 68             	sub    $0x68,%esp
f0100939:	e8 1d f8 ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f010093e:	81 c3 ca 79 01 00    	add    $0x179ca,%ebx
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100944:	8d 83 e0 c2 fe ff    	lea    -0x13d20(%ebx),%eax
f010094a:	50                   	push   %eax
f010094b:	e8 49 27 00 00       	call   f0103099 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100950:	8d 83 04 c3 fe ff    	lea    -0x13cfc(%ebx),%eax
f0100956:	89 04 24             	mov    %eax,(%esp)
f0100959:	e8 3b 27 00 00       	call   f0103099 <cprintf>
f010095e:	83 c4 10             	add    $0x10,%esp
		while (*buf && strchr(WHITESPACE, *buf))
f0100961:	8d 83 73 c1 fe ff    	lea    -0x13e8d(%ebx),%eax
f0100967:	89 45 a0             	mov    %eax,-0x60(%ebp)
f010096a:	e9 d1 00 00 00       	jmp    f0100a40 <monitor+0x114>
f010096f:	83 ec 08             	sub    $0x8,%esp
f0100972:	0f be c0             	movsbl %al,%eax
f0100975:	50                   	push   %eax
f0100976:	ff 75 a0             	pushl  -0x60(%ebp)
f0100979:	e8 1b 33 00 00       	call   f0103c99 <strchr>
f010097e:	83 c4 10             	add    $0x10,%esp
f0100981:	85 c0                	test   %eax,%eax
f0100983:	74 6d                	je     f01009f2 <monitor+0xc6>
			*buf++ = 0;
f0100985:	c6 06 00             	movb   $0x0,(%esi)
f0100988:	89 7d a4             	mov    %edi,-0x5c(%ebp)
f010098b:	8d 76 01             	lea    0x1(%esi),%esi
f010098e:	8b 7d a4             	mov    -0x5c(%ebp),%edi
		while (*buf && strchr(WHITESPACE, *buf))
f0100991:	0f b6 06             	movzbl (%esi),%eax
f0100994:	84 c0                	test   %al,%al
f0100996:	75 d7                	jne    f010096f <monitor+0x43>
	argv[argc] = 0;
f0100998:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
f010099f:	00 
	if (argc == 0)
f01009a0:	85 ff                	test   %edi,%edi
f01009a2:	0f 84 98 00 00 00    	je     f0100a40 <monitor+0x114>
f01009a8:	8d b3 18 1d 00 00    	lea    0x1d18(%ebx),%esi
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009ae:	b8 00 00 00 00       	mov    $0x0,%eax
f01009b3:	89 7d a4             	mov    %edi,-0x5c(%ebp)
f01009b6:	89 c7                	mov    %eax,%edi
		if (strcmp(argv[0], commands[i].name) == 0)
f01009b8:	83 ec 08             	sub    $0x8,%esp
f01009bb:	ff 36                	pushl  (%esi)
f01009bd:	ff 75 a8             	pushl  -0x58(%ebp)
f01009c0:	e8 6e 32 00 00       	call   f0103c33 <strcmp>
f01009c5:	83 c4 10             	add    $0x10,%esp
f01009c8:	85 c0                	test   %eax,%eax
f01009ca:	0f 84 99 00 00 00    	je     f0100a69 <monitor+0x13d>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009d0:	83 c7 01             	add    $0x1,%edi
f01009d3:	83 c6 0c             	add    $0xc,%esi
f01009d6:	83 ff 03             	cmp    $0x3,%edi
f01009d9:	75 dd                	jne    f01009b8 <monitor+0x8c>
	cprintf("Unknown command '%s'\n", argv[0]);
f01009db:	83 ec 08             	sub    $0x8,%esp
f01009de:	ff 75 a8             	pushl  -0x58(%ebp)
f01009e1:	8d 83 95 c1 fe ff    	lea    -0x13e6b(%ebx),%eax
f01009e7:	50                   	push   %eax
f01009e8:	e8 ac 26 00 00       	call   f0103099 <cprintf>
	return 0;
f01009ed:	83 c4 10             	add    $0x10,%esp
f01009f0:	eb 4e                	jmp    f0100a40 <monitor+0x114>
		if (*buf == 0)
f01009f2:	80 3e 00             	cmpb   $0x0,(%esi)
f01009f5:	74 a1                	je     f0100998 <monitor+0x6c>
		if (argc == MAXARGS-1) {
f01009f7:	83 ff 0f             	cmp    $0xf,%edi
f01009fa:	74 30                	je     f0100a2c <monitor+0x100>
		argv[argc++] = buf;
f01009fc:	8d 47 01             	lea    0x1(%edi),%eax
f01009ff:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0100a02:	89 74 bd a8          	mov    %esi,-0x58(%ebp,%edi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a06:	0f b6 06             	movzbl (%esi),%eax
f0100a09:	84 c0                	test   %al,%al
f0100a0b:	74 81                	je     f010098e <monitor+0x62>
f0100a0d:	83 ec 08             	sub    $0x8,%esp
f0100a10:	0f be c0             	movsbl %al,%eax
f0100a13:	50                   	push   %eax
f0100a14:	ff 75 a0             	pushl  -0x60(%ebp)
f0100a17:	e8 7d 32 00 00       	call   f0103c99 <strchr>
f0100a1c:	83 c4 10             	add    $0x10,%esp
f0100a1f:	85 c0                	test   %eax,%eax
f0100a21:	0f 85 67 ff ff ff    	jne    f010098e <monitor+0x62>
			buf++;
f0100a27:	83 c6 01             	add    $0x1,%esi
f0100a2a:	eb da                	jmp    f0100a06 <monitor+0xda>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a2c:	83 ec 08             	sub    $0x8,%esp
f0100a2f:	6a 10                	push   $0x10
f0100a31:	8d 83 78 c1 fe ff    	lea    -0x13e88(%ebx),%eax
f0100a37:	50                   	push   %eax
f0100a38:	e8 5c 26 00 00       	call   f0103099 <cprintf>
			return 0;
f0100a3d:	83 c4 10             	add    $0x10,%esp


	while (1) {
		buf = readline("K> ");
f0100a40:	8d bb 6f c1 fe ff    	lea    -0x13e91(%ebx),%edi
f0100a46:	83 ec 0c             	sub    $0xc,%esp
f0100a49:	57                   	push   %edi
f0100a4a:	e8 d9 2f 00 00       	call   f0103a28 <readline>
		if (buf != NULL)
f0100a4f:	83 c4 10             	add    $0x10,%esp
f0100a52:	85 c0                	test   %eax,%eax
f0100a54:	74 f0                	je     f0100a46 <monitor+0x11a>
f0100a56:	89 c6                	mov    %eax,%esi
	argv[argc] = 0;
f0100a58:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100a5f:	bf 00 00 00 00       	mov    $0x0,%edi
f0100a64:	e9 28 ff ff ff       	jmp    f0100991 <monitor+0x65>
f0100a69:	89 f8                	mov    %edi,%eax
f0100a6b:	8b 7d a4             	mov    -0x5c(%ebp),%edi
			return commands[i].func(argc, argv, tf);
f0100a6e:	83 ec 04             	sub    $0x4,%esp
f0100a71:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100a74:	ff 75 08             	pushl  0x8(%ebp)
f0100a77:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100a7a:	52                   	push   %edx
f0100a7b:	57                   	push   %edi
f0100a7c:	ff 94 83 20 1d 00 00 	call   *0x1d20(%ebx,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100a83:	83 c4 10             	add    $0x10,%esp
f0100a86:	85 c0                	test   %eax,%eax
f0100a88:	79 b6                	jns    f0100a40 <monitor+0x114>
				break;
	}
}
f0100a8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a8d:	5b                   	pop    %ebx
f0100a8e:	5e                   	pop    %esi
f0100a8f:	5f                   	pop    %edi
f0100a90:	5d                   	pop    %ebp
f0100a91:	c3                   	ret    

f0100a92 <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100a92:	e8 5f 25 00 00       	call   f0102ff6 <__x86.get_pc_thunk.dx>
f0100a97:	81 c2 71 78 01 00    	add    $0x17871,%edx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100a9d:	83 ba 90 1f 00 00 00 	cmpl   $0x0,0x1f90(%edx)
f0100aa4:	74 1b                	je     f0100ac1 <boot_alloc+0x2f>
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = nextfree;
f0100aa6:	8b 8a 90 1f 00 00    	mov    0x1f90(%edx),%ecx
	nextfree = ROUNDUP(result + n, PGSIZE);
f0100aac:	8d 84 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%eax
f0100ab3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ab8:	89 82 90 1f 00 00    	mov    %eax,0x1f90(%edx)

	// If we're out of memory, boot_alloc should panic.
	// 这部分目前没有思路

	return result;
}
f0100abe:	89 c8                	mov    %ecx,%eax
f0100ac0:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100ac1:	c7 c1 c0 a6 11 f0    	mov    $0xf011a6c0,%ecx
f0100ac7:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
f0100acd:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0100ad3:	89 8a 90 1f 00 00    	mov    %ecx,0x1f90(%edx)
f0100ad9:	eb cb                	jmp    f0100aa6 <boot_alloc+0x14>

f0100adb <nvram_read>:
{
f0100adb:	55                   	push   %ebp
f0100adc:	89 e5                	mov    %esp,%ebp
f0100ade:	57                   	push   %edi
f0100adf:	56                   	push   %esi
f0100ae0:	53                   	push   %ebx
f0100ae1:	83 ec 18             	sub    $0x18,%esp
f0100ae4:	e8 72 f6 ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f0100ae9:	81 c3 1f 78 01 00    	add    $0x1781f,%ebx
f0100aef:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100af1:	50                   	push   %eax
f0100af2:	e8 0b 25 00 00       	call   f0103002 <mc146818_read>
f0100af7:	89 c7                	mov    %eax,%edi
f0100af9:	83 c6 01             	add    $0x1,%esi
f0100afc:	89 34 24             	mov    %esi,(%esp)
f0100aff:	e8 fe 24 00 00       	call   f0103002 <mc146818_read>
f0100b04:	c1 e0 08             	shl    $0x8,%eax
f0100b07:	09 f8                	or     %edi,%eax
}
f0100b09:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100b0c:	5b                   	pop    %ebx
f0100b0d:	5e                   	pop    %esi
f0100b0e:	5f                   	pop    %edi
f0100b0f:	5d                   	pop    %ebp
f0100b10:	c3                   	ret    

f0100b11 <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100b11:	55                   	push   %ebp
f0100b12:	89 e5                	mov    %esp,%ebp
f0100b14:	56                   	push   %esi
f0100b15:	53                   	push   %ebx
f0100b16:	e8 df 24 00 00       	call   f0102ffa <__x86.get_pc_thunk.cx>
f0100b1b:	81 c1 ed 77 01 00    	add    $0x177ed,%ecx
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100b21:	89 d3                	mov    %edx,%ebx
f0100b23:	c1 eb 16             	shr    $0x16,%ebx
	if (!(*pgdir & PTE_P))
f0100b26:	8b 04 98             	mov    (%eax,%ebx,4),%eax
f0100b29:	a8 01                	test   $0x1,%al
f0100b2b:	74 59                	je     f0100b86 <check_va2pa+0x75>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100b2d:	89 c3                	mov    %eax,%ebx
f0100b2f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100b35:	c1 e8 0c             	shr    $0xc,%eax
f0100b38:	c7 c6 c8 a6 11 f0    	mov    $0xf011a6c8,%esi
f0100b3e:	3b 06                	cmp    (%esi),%eax
f0100b40:	73 29                	jae    f0100b6b <check_va2pa+0x5a>
	if (!(p[PTX(va)] & PTE_P))
f0100b42:	c1 ea 0c             	shr    $0xc,%edx
f0100b45:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100b4b:	8b 94 93 00 00 00 f0 	mov    -0x10000000(%ebx,%edx,4),%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100b52:	89 d0                	mov    %edx,%eax
f0100b54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b59:	f6 c2 01             	test   $0x1,%dl
f0100b5c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100b61:	0f 44 c2             	cmove  %edx,%eax
}
f0100b64:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100b67:	5b                   	pop    %ebx
f0100b68:	5e                   	pop    %esi
f0100b69:	5d                   	pop    %ebp
f0100b6a:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b6b:	53                   	push   %ebx
f0100b6c:	8d 81 2c c3 fe ff    	lea    -0x13cd4(%ecx),%eax
f0100b72:	50                   	push   %eax
f0100b73:	68 31 03 00 00       	push   $0x331
f0100b78:	8d 81 05 cb fe ff    	lea    -0x134fb(%ecx),%eax
f0100b7e:	50                   	push   %eax
f0100b7f:	89 cb                	mov    %ecx,%ebx
f0100b81:	e8 17 f5 ff ff       	call   f010009d <_panic>
		return ~0;
f0100b86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100b8b:	eb d7                	jmp    f0100b64 <check_va2pa+0x53>

f0100b8d <check_page_free_list>:
{
f0100b8d:	55                   	push   %ebp
f0100b8e:	89 e5                	mov    %esp,%ebp
f0100b90:	57                   	push   %edi
f0100b91:	56                   	push   %esi
f0100b92:	53                   	push   %ebx
f0100b93:	83 ec 2c             	sub    $0x2c,%esp
f0100b96:	e8 78 fb ff ff       	call   f0100713 <__x86.get_pc_thunk.si>
f0100b9b:	81 c6 6d 77 01 00    	add    $0x1776d,%esi
f0100ba1:	89 75 c8             	mov    %esi,-0x38(%ebp)
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ba4:	84 c0                	test   %al,%al
f0100ba6:	0f 85 ec 02 00 00    	jne    f0100e98 <check_page_free_list+0x30b>
	if (!page_free_list)
f0100bac:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0100baf:	83 b8 94 1f 00 00 00 	cmpl   $0x0,0x1f94(%eax)
f0100bb6:	74 21                	je     f0100bd9 <check_page_free_list+0x4c>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100bb8:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100bbf:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0100bc2:	8b b0 94 1f 00 00    	mov    0x1f94(%eax),%esi
void	tlb_invalidate(pde_t *pgdir, void *va);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100bc8:	c7 c7 d0 a6 11 f0    	mov    $0xf011a6d0,%edi
	if (PGNUM(pa) >= npages)
f0100bce:	c7 c0 c8 a6 11 f0    	mov    $0xf011a6c8,%eax
f0100bd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100bd7:	eb 39                	jmp    f0100c12 <check_page_free_list+0x85>
		panic("'page_free_list' is a null pointer!");
f0100bd9:	83 ec 04             	sub    $0x4,%esp
f0100bdc:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100bdf:	8d 83 50 c3 fe ff    	lea    -0x13cb0(%ebx),%eax
f0100be5:	50                   	push   %eax
f0100be6:	68 72 02 00 00       	push   $0x272
f0100beb:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100bf1:	50                   	push   %eax
f0100bf2:	e8 a6 f4 ff ff       	call   f010009d <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100bf7:	50                   	push   %eax
f0100bf8:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100bfb:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f0100c01:	50                   	push   %eax
f0100c02:	6a 52                	push   $0x52
f0100c04:	8d 83 11 cb fe ff    	lea    -0x134ef(%ebx),%eax
f0100c0a:	50                   	push   %eax
f0100c0b:	e8 8d f4 ff ff       	call   f010009d <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100c10:	8b 36                	mov    (%esi),%esi
f0100c12:	85 f6                	test   %esi,%esi
f0100c14:	74 40                	je     f0100c56 <check_page_free_list+0xc9>
	return (pp - pages) << PGSHIFT;
f0100c16:	89 f0                	mov    %esi,%eax
f0100c18:	2b 07                	sub    (%edi),%eax
f0100c1a:	c1 f8 03             	sar    $0x3,%eax
f0100c1d:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100c20:	89 c2                	mov    %eax,%edx
f0100c22:	c1 ea 16             	shr    $0x16,%edx
f0100c25:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
f0100c28:	73 e6                	jae    f0100c10 <check_page_free_list+0x83>
	if (PGNUM(pa) >= npages)
f0100c2a:	89 c2                	mov    %eax,%edx
f0100c2c:	c1 ea 0c             	shr    $0xc,%edx
f0100c2f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100c32:	3b 11                	cmp    (%ecx),%edx
f0100c34:	73 c1                	jae    f0100bf7 <check_page_free_list+0x6a>
			memset(page2kva(pp), 0x97, 128);
f0100c36:	83 ec 04             	sub    $0x4,%esp
f0100c39:	68 80 00 00 00       	push   $0x80
f0100c3e:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100c43:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100c48:	50                   	push   %eax
f0100c49:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100c4c:	e8 8d 30 00 00       	call   f0103cde <memset>
f0100c51:	83 c4 10             	add    $0x10,%esp
f0100c54:	eb ba                	jmp    f0100c10 <check_page_free_list+0x83>
	first_free_page = (char *) boot_alloc(0);
f0100c56:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c5b:	e8 32 fe ff ff       	call   f0100a92 <boot_alloc>
f0100c60:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c63:	8b 7d c8             	mov    -0x38(%ebp),%edi
f0100c66:	8b 97 94 1f 00 00    	mov    0x1f94(%edi),%edx
		assert(pp >= pages);
f0100c6c:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0100c72:	8b 08                	mov    (%eax),%ecx
		assert(pp < pages + npages);
f0100c74:	c7 c0 c8 a6 11 f0    	mov    $0xf011a6c8,%eax
f0100c7a:	8b 00                	mov    (%eax),%eax
f0100c7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100c7f:	8d 3c c1             	lea    (%ecx,%eax,8),%edi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100c82:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100c87:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c8a:	e9 08 01 00 00       	jmp    f0100d97 <check_page_free_list+0x20a>
		assert(pp >= pages);
f0100c8f:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100c92:	8d 83 1f cb fe ff    	lea    -0x134e1(%ebx),%eax
f0100c98:	50                   	push   %eax
f0100c99:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0100c9f:	50                   	push   %eax
f0100ca0:	68 8c 02 00 00       	push   $0x28c
f0100ca5:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100cab:	50                   	push   %eax
f0100cac:	e8 ec f3 ff ff       	call   f010009d <_panic>
		assert(pp < pages + npages);
f0100cb1:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100cb4:	8d 83 40 cb fe ff    	lea    -0x134c0(%ebx),%eax
f0100cba:	50                   	push   %eax
f0100cbb:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0100cc1:	50                   	push   %eax
f0100cc2:	68 8d 02 00 00       	push   $0x28d
f0100cc7:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100ccd:	50                   	push   %eax
f0100cce:	e8 ca f3 ff ff       	call   f010009d <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100cd3:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100cd6:	8d 83 74 c3 fe ff    	lea    -0x13c8c(%ebx),%eax
f0100cdc:	50                   	push   %eax
f0100cdd:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0100ce3:	50                   	push   %eax
f0100ce4:	68 8e 02 00 00       	push   $0x28e
f0100ce9:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100cef:	50                   	push   %eax
f0100cf0:	e8 a8 f3 ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) != 0);
f0100cf5:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100cf8:	8d 83 54 cb fe ff    	lea    -0x134ac(%ebx),%eax
f0100cfe:	50                   	push   %eax
f0100cff:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0100d05:	50                   	push   %eax
f0100d06:	68 91 02 00 00       	push   $0x291
f0100d0b:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100d11:	50                   	push   %eax
f0100d12:	e8 86 f3 ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d17:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100d1a:	8d 83 65 cb fe ff    	lea    -0x1349b(%ebx),%eax
f0100d20:	50                   	push   %eax
f0100d21:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0100d27:	50                   	push   %eax
f0100d28:	68 92 02 00 00       	push   $0x292
f0100d2d:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100d33:	50                   	push   %eax
f0100d34:	e8 64 f3 ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d39:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100d3c:	8d 83 a8 c3 fe ff    	lea    -0x13c58(%ebx),%eax
f0100d42:	50                   	push   %eax
f0100d43:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0100d49:	50                   	push   %eax
f0100d4a:	68 93 02 00 00       	push   $0x293
f0100d4f:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100d55:	50                   	push   %eax
f0100d56:	e8 42 f3 ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d5b:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100d5e:	8d 83 7e cb fe ff    	lea    -0x13482(%ebx),%eax
f0100d64:	50                   	push   %eax
f0100d65:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0100d6b:	50                   	push   %eax
f0100d6c:	68 94 02 00 00       	push   $0x294
f0100d71:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100d77:	50                   	push   %eax
f0100d78:	e8 20 f3 ff ff       	call   f010009d <_panic>
	if (PGNUM(pa) >= npages)
f0100d7d:	89 c3                	mov    %eax,%ebx
f0100d7f:	c1 eb 0c             	shr    $0xc,%ebx
f0100d82:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0100d85:	76 6d                	jbe    f0100df4 <check_page_free_list+0x267>
	return (void *)(pa + KERNBASE);
f0100d87:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d8c:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0100d8f:	77 7c                	ja     f0100e0d <check_page_free_list+0x280>
			++nfree_extmem;
f0100d91:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d95:	8b 12                	mov    (%edx),%edx
f0100d97:	85 d2                	test   %edx,%edx
f0100d99:	0f 84 90 00 00 00    	je     f0100e2f <check_page_free_list+0x2a2>
		assert(pp >= pages);
f0100d9f:	39 d1                	cmp    %edx,%ecx
f0100da1:	0f 87 e8 fe ff ff    	ja     f0100c8f <check_page_free_list+0x102>
		assert(pp < pages + npages);
f0100da7:	39 d7                	cmp    %edx,%edi
f0100da9:	0f 86 02 ff ff ff    	jbe    f0100cb1 <check_page_free_list+0x124>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100daf:	89 d0                	mov    %edx,%eax
f0100db1:	29 c8                	sub    %ecx,%eax
f0100db3:	a8 07                	test   $0x7,%al
f0100db5:	0f 85 18 ff ff ff    	jne    f0100cd3 <check_page_free_list+0x146>
	return (pp - pages) << PGSHIFT;
f0100dbb:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100dbe:	c1 e0 0c             	shl    $0xc,%eax
f0100dc1:	0f 84 2e ff ff ff    	je     f0100cf5 <check_page_free_list+0x168>
		assert(page2pa(pp) != IOPHYSMEM);
f0100dc7:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100dcc:	0f 84 45 ff ff ff    	je     f0100d17 <check_page_free_list+0x18a>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100dd2:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100dd7:	0f 84 5c ff ff ff    	je     f0100d39 <check_page_free_list+0x1ac>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100ddd:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100de2:	0f 84 73 ff ff ff    	je     f0100d5b <check_page_free_list+0x1ce>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100de8:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100ded:	77 8e                	ja     f0100d7d <check_page_free_list+0x1f0>
			++nfree_basemem;
f0100def:	83 c6 01             	add    $0x1,%esi
f0100df2:	eb a1                	jmp    f0100d95 <check_page_free_list+0x208>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100df4:	50                   	push   %eax
f0100df5:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100df8:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f0100dfe:	50                   	push   %eax
f0100dff:	6a 52                	push   $0x52
f0100e01:	8d 83 11 cb fe ff    	lea    -0x134ef(%ebx),%eax
f0100e07:	50                   	push   %eax
f0100e08:	e8 90 f2 ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100e0d:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100e10:	8d 83 cc c3 fe ff    	lea    -0x13c34(%ebx),%eax
f0100e16:	50                   	push   %eax
f0100e17:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0100e1d:	50                   	push   %eax
f0100e1e:	68 95 02 00 00       	push   $0x295
f0100e23:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100e29:	50                   	push   %eax
f0100e2a:	e8 6e f2 ff ff       	call   f010009d <_panic>
f0100e2f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f0100e32:	85 f6                	test   %esi,%esi
f0100e34:	7e 1e                	jle    f0100e54 <check_page_free_list+0x2c7>
	assert(nfree_extmem > 0);
f0100e36:	85 db                	test   %ebx,%ebx
f0100e38:	7e 3c                	jle    f0100e76 <check_page_free_list+0x2e9>
	cprintf("check_page_free_list() succeeded!\n");
f0100e3a:	83 ec 0c             	sub    $0xc,%esp
f0100e3d:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100e40:	8d 83 14 c4 fe ff    	lea    -0x13bec(%ebx),%eax
f0100e46:	50                   	push   %eax
f0100e47:	e8 4d 22 00 00       	call   f0103099 <cprintf>
}
f0100e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e4f:	5b                   	pop    %ebx
f0100e50:	5e                   	pop    %esi
f0100e51:	5f                   	pop    %edi
f0100e52:	5d                   	pop    %ebp
f0100e53:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100e54:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100e57:	8d 83 98 cb fe ff    	lea    -0x13468(%ebx),%eax
f0100e5d:	50                   	push   %eax
f0100e5e:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0100e64:	50                   	push   %eax
f0100e65:	68 9d 02 00 00       	push   $0x29d
f0100e6a:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100e70:	50                   	push   %eax
f0100e71:	e8 27 f2 ff ff       	call   f010009d <_panic>
	assert(nfree_extmem > 0);
f0100e76:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100e79:	8d 83 aa cb fe ff    	lea    -0x13456(%ebx),%eax
f0100e7f:	50                   	push   %eax
f0100e80:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0100e86:	50                   	push   %eax
f0100e87:	68 9e 02 00 00       	push   $0x29e
f0100e8c:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100e92:	50                   	push   %eax
f0100e93:	e8 05 f2 ff ff       	call   f010009d <_panic>
	if (!page_free_list)
f0100e98:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0100e9b:	8b 80 94 1f 00 00    	mov    0x1f94(%eax),%eax
f0100ea1:	85 c0                	test   %eax,%eax
f0100ea3:	0f 84 30 fd ff ff    	je     f0100bd9 <check_page_free_list+0x4c>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100ea9:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100eac:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100eaf:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100eb2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	return (pp - pages) << PGSHIFT;
f0100eb5:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0100eb8:	c7 c3 d0 a6 11 f0    	mov    $0xf011a6d0,%ebx
f0100ebe:	89 c2                	mov    %eax,%edx
f0100ec0:	2b 13                	sub    (%ebx),%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100ec2:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100ec8:	0f 95 c2             	setne  %dl
f0100ecb:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100ece:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100ed2:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100ed4:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100ed8:	8b 00                	mov    (%eax),%eax
f0100eda:	85 c0                	test   %eax,%eax
f0100edc:	75 e0                	jne    f0100ebe <check_page_free_list+0x331>
		*tp[1] = 0;
f0100ede:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100ee1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100ee7:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100eea:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100eed:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100eef:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100ef2:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0100ef5:	89 86 94 1f 00 00    	mov    %eax,0x1f94(%esi)
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100efb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
f0100f02:	e9 b8 fc ff ff       	jmp    f0100bbf <check_page_free_list+0x32>

f0100f07 <page_init>:
{
f0100f07:	f3 0f 1e fb          	endbr32 
f0100f0b:	55                   	push   %ebp
f0100f0c:	89 e5                	mov    %esp,%ebp
f0100f0e:	57                   	push   %edi
f0100f0f:	56                   	push   %esi
f0100f10:	53                   	push   %ebx
f0100f11:	83 ec 1c             	sub    $0x1c,%esp
f0100f14:	e8 e5 20 00 00       	call   f0102ffe <__x86.get_pc_thunk.di>
f0100f19:	81 c7 ef 73 01 00    	add    $0x173ef,%edi
f0100f1f:	89 fe                	mov    %edi,%esi
f0100f21:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	pages[0].pp_ref = 1;
f0100f24:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0100f2a:	8b 00                	mov    (%eax),%eax
f0100f2c:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	pages[0].pp_link = NULL;
f0100f32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 1; i < npages_basemem; i++) {
f0100f38:	8b bf 98 1f 00 00    	mov    0x1f98(%edi),%edi
f0100f3e:	8b 9e 94 1f 00 00    	mov    0x1f94(%esi),%ebx
f0100f44:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f49:	b8 01 00 00 00       	mov    $0x1,%eax
		pages[i].pp_ref = 0;
f0100f4e:	c7 c6 d0 a6 11 f0    	mov    $0xf011a6d0,%esi
	for (i = 1; i < npages_basemem; i++) {
f0100f54:	eb 1f                	jmp    f0100f75 <page_init+0x6e>
f0100f56:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100f5d:	89 d1                	mov    %edx,%ecx
f0100f5f:	03 0e                	add    (%esi),%ecx
f0100f61:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100f67:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0100f69:	89 d3                	mov    %edx,%ebx
f0100f6b:	03 1e                	add    (%esi),%ebx
	for (i = 1; i < npages_basemem; i++) {
f0100f6d:	83 c0 01             	add    $0x1,%eax
f0100f70:	ba 01 00 00 00       	mov    $0x1,%edx
f0100f75:	39 c7                	cmp    %eax,%edi
f0100f77:	77 dd                	ja     f0100f56 <page_init+0x4f>
f0100f79:	84 d2                	test   %dl,%dl
f0100f7b:	74 09                	je     f0100f86 <page_init+0x7f>
f0100f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100f80:	89 98 94 1f 00 00    	mov    %ebx,0x1f94(%eax)
f0100f86:	b8 00 05 00 00       	mov    $0x500,%eax
		pages[i].pp_ref = 1;
f0100f8b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100f8e:	c7 c1 d0 a6 11 f0    	mov    $0xf011a6d0,%ecx
f0100f94:	89 c2                	mov    %eax,%edx
f0100f96:	03 11                	add    (%ecx),%edx
f0100f98:	66 c7 42 04 01 00    	movw   $0x1,0x4(%edx)
		pages[i].pp_link = NULL;
f0100f9e:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
f0100fa4:	83 c0 08             	add    $0x8,%eax
	for(i = io; i < ex; i++){
f0100fa7:	3d 00 08 00 00       	cmp    $0x800,%eax
f0100fac:	75 e6                	jne    f0100f94 <page_init+0x8d>
	size_t fisrt_page = PADDR(boot_alloc(0)) / PGSIZE;
f0100fae:	b8 00 00 00 00       	mov    $0x0,%eax
f0100fb3:	e8 da fa ff ff       	call   f0100a92 <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100fb8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100fbd:	76 18                	jbe    f0100fd7 <page_init+0xd0>
	return (physaddr_t)kva - KERNBASE;
f0100fbf:	05 00 00 00 10       	add    $0x10000000,%eax
f0100fc4:	c1 e8 0c             	shr    $0xc,%eax
	for(i = ex; i < fisrt_page; i++){
f0100fc7:	ba 00 01 00 00       	mov    $0x100,%edx
		pages[i].pp_ref = 1;
f0100fcc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100fcf:	c7 c3 d0 a6 11 f0    	mov    $0xf011a6d0,%ebx
	for(i = ex; i < fisrt_page; i++){
f0100fd5:	eb 30                	jmp    f0101007 <page_init+0x100>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100fd7:	50                   	push   %eax
f0100fd8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0100fdb:	8d 83 38 c4 fe ff    	lea    -0x13bc8(%ebx),%eax
f0100fe1:	50                   	push   %eax
f0100fe2:	68 2a 01 00 00       	push   $0x12a
f0100fe7:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0100fed:	50                   	push   %eax
f0100fee:	e8 aa f0 ff ff       	call   f010009d <_panic>
		pages[i].pp_ref = 1;
f0100ff3:	8b 0b                	mov    (%ebx),%ecx
f0100ff5:	8d 0c d1             	lea    (%ecx,%edx,8),%ecx
f0100ff8:	66 c7 41 04 01 00    	movw   $0x1,0x4(%ecx)
		pages[i].pp_link = NULL;
f0100ffe:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	for(i = ex; i < fisrt_page; i++){
f0101004:	83 c2 01             	add    $0x1,%edx
f0101007:	39 c2                	cmp    %eax,%edx
f0101009:	72 e8                	jb     f0100ff3 <page_init+0xec>
f010100b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010100e:	8b 9e 94 1f 00 00    	mov    0x1f94(%esi),%ebx
f0101014:	ba 00 00 00 00       	mov    $0x0,%edx
	for(i = fisrt_page; i < npages; i++){
f0101019:	c7 c7 c8 a6 11 f0    	mov    $0xf011a6c8,%edi
		pages[i].pp_ref = 0;
f010101f:	c7 c6 d0 a6 11 f0    	mov    $0xf011a6d0,%esi
f0101025:	eb 1f                	jmp    f0101046 <page_init+0x13f>
f0101027:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f010102e:	89 d1                	mov    %edx,%ecx
f0101030:	03 0e                	add    (%esi),%ecx
f0101032:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0101038:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f010103a:	89 d3                	mov    %edx,%ebx
f010103c:	03 1e                	add    (%esi),%ebx
	for(i = fisrt_page; i < npages; i++){
f010103e:	83 c0 01             	add    $0x1,%eax
f0101041:	ba 01 00 00 00       	mov    $0x1,%edx
f0101046:	39 07                	cmp    %eax,(%edi)
f0101048:	77 dd                	ja     f0101027 <page_init+0x120>
f010104a:	84 d2                	test   %dl,%dl
f010104c:	74 09                	je     f0101057 <page_init+0x150>
f010104e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101051:	89 98 94 1f 00 00    	mov    %ebx,0x1f94(%eax)
}
f0101057:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010105a:	5b                   	pop    %ebx
f010105b:	5e                   	pop    %esi
f010105c:	5f                   	pop    %edi
f010105d:	5d                   	pop    %ebp
f010105e:	c3                   	ret    

f010105f <page_alloc>:
{
f010105f:	f3 0f 1e fb          	endbr32 
f0101063:	55                   	push   %ebp
f0101064:	89 e5                	mov    %esp,%ebp
f0101066:	56                   	push   %esi
f0101067:	53                   	push   %ebx
f0101068:	e8 ee f0 ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f010106d:	81 c3 9b 72 01 00    	add    $0x1729b,%ebx
	if(!page_free_list) {
f0101073:	8b b3 94 1f 00 00    	mov    0x1f94(%ebx),%esi
f0101079:	85 f6                	test   %esi,%esi
f010107b:	74 1d                	je     f010109a <page_alloc+0x3b>
	page_free_list = page_free_list->pp_link;
f010107d:	8b 06                	mov    (%esi),%eax
f010107f:	89 83 94 1f 00 00    	mov    %eax,0x1f94(%ebx)
	pp->pp_link = NULL;
f0101085:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	if(alloc_flags && ALLOC_ZERO){
f010108b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f010108f:	75 1d                	jne    f01010ae <page_alloc+0x4f>
}
f0101091:	89 f0                	mov    %esi,%eax
f0101093:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101096:	5b                   	pop    %ebx
f0101097:	5e                   	pop    %esi
f0101098:	5d                   	pop    %ebp
f0101099:	c3                   	ret    
		cprintf("page_alloc: out of free memory\n");
f010109a:	83 ec 0c             	sub    $0xc,%esp
f010109d:	8d 83 5c c4 fe ff    	lea    -0x13ba4(%ebx),%eax
f01010a3:	50                   	push   %eax
f01010a4:	e8 f0 1f 00 00       	call   f0103099 <cprintf>
		return NULL;
f01010a9:	83 c4 10             	add    $0x10,%esp
f01010ac:	eb e3                	jmp    f0101091 <page_alloc+0x32>
	return (pp - pages) << PGSHIFT;
f01010ae:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f01010b4:	89 f1                	mov    %esi,%ecx
f01010b6:	2b 08                	sub    (%eax),%ecx
f01010b8:	89 c8                	mov    %ecx,%eax
f01010ba:	c1 f8 03             	sar    $0x3,%eax
f01010bd:	89 c2                	mov    %eax,%edx
f01010bf:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01010c2:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01010c7:	c7 c1 c8 a6 11 f0    	mov    $0xf011a6c8,%ecx
f01010cd:	3b 01                	cmp    (%ecx),%eax
f01010cf:	73 1b                	jae    f01010ec <page_alloc+0x8d>
		memset(page2kva(pp), '\0', PGSIZE);
f01010d1:	83 ec 04             	sub    $0x4,%esp
f01010d4:	68 00 10 00 00       	push   $0x1000
f01010d9:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01010db:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f01010e1:	52                   	push   %edx
f01010e2:	e8 f7 2b 00 00       	call   f0103cde <memset>
f01010e7:	83 c4 10             	add    $0x10,%esp
f01010ea:	eb a5                	jmp    f0101091 <page_alloc+0x32>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01010ec:	52                   	push   %edx
f01010ed:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f01010f3:	50                   	push   %eax
f01010f4:	6a 52                	push   $0x52
f01010f6:	8d 83 11 cb fe ff    	lea    -0x134ef(%ebx),%eax
f01010fc:	50                   	push   %eax
f01010fd:	e8 9b ef ff ff       	call   f010009d <_panic>

f0101102 <page_free>:
{
f0101102:	f3 0f 1e fb          	endbr32 
f0101106:	55                   	push   %ebp
f0101107:	89 e5                	mov    %esp,%ebp
f0101109:	53                   	push   %ebx
f010110a:	83 ec 04             	sub    $0x4,%esp
f010110d:	e8 49 f0 ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f0101112:	81 c3 f6 71 01 00    	add    $0x171f6,%ebx
f0101118:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0){
f010111b:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101120:	75 18                	jne    f010113a <page_free+0x38>
	}else if(pp->pp_link != NULL){
f0101122:	83 38 00             	cmpl   $0x0,(%eax)
f0101125:	75 2e                	jne    f0101155 <page_free+0x53>
		pp->pp_link = page_free_list;
f0101127:	8b 8b 94 1f 00 00    	mov    0x1f94(%ebx),%ecx
f010112d:	89 08                	mov    %ecx,(%eax)
		page_free_list = pp;
f010112f:	89 83 94 1f 00 00    	mov    %eax,0x1f94(%ebx)
}
f0101135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101138:	c9                   	leave  
f0101139:	c3                   	ret    
		panic("page_free: pp->pp_ref is nonzero\n");
f010113a:	83 ec 04             	sub    $0x4,%esp
f010113d:	8d 83 7c c4 fe ff    	lea    -0x13b84(%ebx),%eax
f0101143:	50                   	push   %eax
f0101144:	68 62 01 00 00       	push   $0x162
f0101149:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010114f:	50                   	push   %eax
f0101150:	e8 48 ef ff ff       	call   f010009d <_panic>
		panic("page_free: pp->pp_link is NULL\n");
f0101155:	83 ec 04             	sub    $0x4,%esp
f0101158:	8d 83 a0 c4 fe ff    	lea    -0x13b60(%ebx),%eax
f010115e:	50                   	push   %eax
f010115f:	68 64 01 00 00       	push   $0x164
f0101164:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010116a:	50                   	push   %eax
f010116b:	e8 2d ef ff ff       	call   f010009d <_panic>

f0101170 <page_decref>:
{
f0101170:	f3 0f 1e fb          	endbr32 
f0101174:	55                   	push   %ebp
f0101175:	89 e5                	mov    %esp,%ebp
f0101177:	83 ec 08             	sub    $0x8,%esp
f010117a:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f010117d:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f0101181:	83 e8 01             	sub    $0x1,%eax
f0101184:	66 89 42 04          	mov    %ax,0x4(%edx)
f0101188:	66 85 c0             	test   %ax,%ax
f010118b:	74 02                	je     f010118f <page_decref+0x1f>
}
f010118d:	c9                   	leave  
f010118e:	c3                   	ret    
		page_free(pp);
f010118f:	83 ec 0c             	sub    $0xc,%esp
f0101192:	52                   	push   %edx
f0101193:	e8 6a ff ff ff       	call   f0101102 <page_free>
f0101198:	83 c4 10             	add    $0x10,%esp
}
f010119b:	eb f0                	jmp    f010118d <page_decref+0x1d>

f010119d <pgdir_walk>:
{
f010119d:	f3 0f 1e fb          	endbr32 
f01011a1:	55                   	push   %ebp
f01011a2:	89 e5                	mov    %esp,%ebp
f01011a4:	57                   	push   %edi
f01011a5:	56                   	push   %esi
f01011a6:	53                   	push   %ebx
f01011a7:	83 ec 0c             	sub    $0xc,%esp
f01011aa:	e8 64 f5 ff ff       	call   f0100713 <__x86.get_pc_thunk.si>
f01011af:	81 c6 59 71 01 00    	add    $0x17159,%esi
f01011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
	uint32_t ptx = PTX(va);		//页表项索引
f01011b8:	89 c3                	mov    %eax,%ebx
f01011ba:	c1 eb 0c             	shr    $0xc,%ebx
f01011bd:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	uint32_t pdx = PDX(va);		//页目录项索引
f01011c3:	c1 e8 16             	shr    $0x16,%eax
	pde = &pgdir[pdx];			//获取页目录项
f01011c6:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
f01011cd:	03 7d 08             	add    0x8(%ebp),%edi
	if((*pde) & PTE_P){
f01011d0:	8b 07                	mov    (%edi),%eax
f01011d2:	a8 01                	test   $0x1,%al
f01011d4:	74 41                	je     f0101217 <pgdir_walk+0x7a>
		pte = (KADDR(PTE_ADDR(*pde)));
f01011d6:	89 c2                	mov    %eax,%edx
f01011d8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f01011de:	c1 e8 0c             	shr    $0xc,%eax
f01011e1:	c7 c1 c8 a6 11 f0    	mov    $0xf011a6c8,%ecx
f01011e7:	39 01                	cmp    %eax,(%ecx)
f01011e9:	76 11                	jbe    f01011fc <pgdir_walk+0x5f>
	return (void *)(pa + KERNBASE);
f01011eb:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	return (pte_t*)&pte[ptx];
f01011f1:	8d 04 98             	lea    (%eax,%ebx,4),%eax
}
f01011f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011f7:	5b                   	pop    %ebx
f01011f8:	5e                   	pop    %esi
f01011f9:	5f                   	pop    %edi
f01011fa:	5d                   	pop    %ebp
f01011fb:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01011fc:	52                   	push   %edx
f01011fd:	8d 86 2c c3 fe ff    	lea    -0x13cd4(%esi),%eax
f0101203:	50                   	push   %eax
f0101204:	68 9e 01 00 00       	push   $0x19e
f0101209:	8d 86 05 cb fe ff    	lea    -0x134fb(%esi),%eax
f010120f:	50                   	push   %eax
f0101210:	89 f3                	mov    %esi,%ebx
f0101212:	e8 86 ee ff ff       	call   f010009d <_panic>
		if(!create){
f0101217:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010121b:	74 7f                	je     f010129c <pgdir_walk+0xff>
		if(!(pp = page_alloc(ALLOC_ZERO))){
f010121d:	83 ec 0c             	sub    $0xc,%esp
f0101220:	6a 01                	push   $0x1
f0101222:	e8 38 fe ff ff       	call   f010105f <page_alloc>
f0101227:	83 c4 10             	add    $0x10,%esp
f010122a:	85 c0                	test   %eax,%eax
f010122c:	74 c6                	je     f01011f4 <pgdir_walk+0x57>
		pp->pp_ref++;
f010122e:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101233:	c7 c2 d0 a6 11 f0    	mov    $0xf011a6d0,%edx
f0101239:	2b 02                	sub    (%edx),%eax
f010123b:	c1 f8 03             	sar    $0x3,%eax
f010123e:	89 c2                	mov    %eax,%edx
f0101240:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101243:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101248:	c7 c1 c8 a6 11 f0    	mov    $0xf011a6c8,%ecx
f010124e:	3b 01                	cmp    (%ecx),%eax
f0101250:	73 17                	jae    f0101269 <pgdir_walk+0xcc>
	return (void *)(pa + KERNBASE);
f0101252:	8d 8a 00 00 00 f0    	lea    -0x10000000(%edx),%ecx
f0101258:	89 c8                	mov    %ecx,%eax
	if ((uint32_t)kva < KERNBASE)
f010125a:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0101260:	76 1f                	jbe    f0101281 <pgdir_walk+0xe4>
		*pde = PADDR(pte) | PTE_P | PTE_W | PTE_U;
f0101262:	83 ca 07             	or     $0x7,%edx
f0101265:	89 17                	mov    %edx,(%edi)
f0101267:	eb 88                	jmp    f01011f1 <pgdir_walk+0x54>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101269:	52                   	push   %edx
f010126a:	8d 86 2c c3 fe ff    	lea    -0x13cd4(%esi),%eax
f0101270:	50                   	push   %eax
f0101271:	6a 52                	push   $0x52
f0101273:	8d 86 11 cb fe ff    	lea    -0x134ef(%esi),%eax
f0101279:	50                   	push   %eax
f010127a:	89 f3                	mov    %esi,%ebx
f010127c:	e8 1c ee ff ff       	call   f010009d <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101281:	51                   	push   %ecx
f0101282:	8d 86 38 c4 fe ff    	lea    -0x13bc8(%esi),%eax
f0101288:	50                   	push   %eax
f0101289:	68 af 01 00 00       	push   $0x1af
f010128e:	8d 86 05 cb fe ff    	lea    -0x134fb(%esi),%eax
f0101294:	50                   	push   %eax
f0101295:	89 f3                	mov    %esi,%ebx
f0101297:	e8 01 ee ff ff       	call   f010009d <_panic>
			return NULL;
f010129c:	b8 00 00 00 00       	mov    $0x0,%eax
f01012a1:	e9 4e ff ff ff       	jmp    f01011f4 <pgdir_walk+0x57>

f01012a6 <boot_map_region>:
{
f01012a6:	55                   	push   %ebp
f01012a7:	89 e5                	mov    %esp,%ebp
f01012a9:	57                   	push   %edi
f01012aa:	56                   	push   %esi
f01012ab:	53                   	push   %ebx
f01012ac:	83 ec 1c             	sub    $0x1c,%esp
f01012af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01012b2:	8b 45 08             	mov    0x8(%ebp),%eax
	size_t pgs = (size + PGSIZE - 1) / PGSIZE;
f01012b5:	8d b1 ff 0f 00 00    	lea    0xfff(%ecx),%esi
f01012bb:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f01012c1:	01 c6                	add    %eax,%esi
	for(size_t i = 0; i < pgs; i++){
f01012c3:	89 c3                	mov    %eax,%ebx
		pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
f01012c5:	89 d7                	mov    %edx,%edi
f01012c7:	29 c7                	sub    %eax,%edi
	for(size_t i = 0; i < pgs; i++){
f01012c9:	39 f3                	cmp    %esi,%ebx
f01012cb:	74 28                	je     f01012f5 <boot_map_region+0x4f>
		pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
f01012cd:	83 ec 04             	sub    $0x4,%esp
f01012d0:	6a 01                	push   $0x1
f01012d2:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
f01012d5:	50                   	push   %eax
f01012d6:	ff 75 e4             	pushl  -0x1c(%ebp)
f01012d9:	e8 bf fe ff ff       	call   f010119d <pgdir_walk>
f01012de:	89 c2                	mov    %eax,%edx
		*pte = pa | PTE_P | perm;
f01012e0:	89 d8                	mov    %ebx,%eax
f01012e2:	0b 45 0c             	or     0xc(%ebp),%eax
f01012e5:	83 c8 01             	or     $0x1,%eax
f01012e8:	89 02                	mov    %eax,(%edx)
		pa += PGSIZE;
f01012ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01012f0:	83 c4 10             	add    $0x10,%esp
f01012f3:	eb d4                	jmp    f01012c9 <boot_map_region+0x23>
}
f01012f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01012f8:	5b                   	pop    %ebx
f01012f9:	5e                   	pop    %esi
f01012fa:	5f                   	pop    %edi
f01012fb:	5d                   	pop    %ebp
f01012fc:	c3                   	ret    

f01012fd <page_lookup>:
{
f01012fd:	f3 0f 1e fb          	endbr32 
f0101301:	55                   	push   %ebp
f0101302:	89 e5                	mov    %esp,%ebp
f0101304:	56                   	push   %esi
f0101305:	53                   	push   %ebx
f0101306:	e8 50 ee ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f010130b:	81 c3 fd 6f 01 00    	add    $0x16ffd,%ebx
f0101311:	8b 75 10             	mov    0x10(%ebp),%esi
	pte_t* pte = pgdir_walk(pgdir, va, false);
f0101314:	83 ec 04             	sub    $0x4,%esp
f0101317:	6a 00                	push   $0x0
f0101319:	ff 75 0c             	pushl  0xc(%ebp)
f010131c:	ff 75 08             	pushl  0x8(%ebp)
f010131f:	e8 79 fe ff ff       	call   f010119d <pgdir_walk>
	if(!pte || !((*pte) & PTE_P)){
f0101324:	83 c4 10             	add    $0x10,%esp
f0101327:	85 c0                	test   %eax,%eax
f0101329:	74 25                	je     f0101350 <page_lookup+0x53>
f010132b:	f6 00 01             	testb  $0x1,(%eax)
f010132e:	74 3f                	je     f010136f <page_lookup+0x72>
	if(pte_store != NULL){
f0101330:	85 f6                	test   %esi,%esi
f0101332:	74 02                	je     f0101336 <page_lookup+0x39>
		*pte_store = pte;
f0101334:	89 06                	mov    %eax,(%esi)
f0101336:	8b 00                	mov    (%eax),%eax
f0101338:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010133b:	c7 c2 c8 a6 11 f0    	mov    $0xf011a6c8,%edx
f0101341:	39 02                	cmp    %eax,(%edx)
f0101343:	76 12                	jbe    f0101357 <page_lookup+0x5a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101345:	c7 c2 d0 a6 11 f0    	mov    $0xf011a6d0,%edx
f010134b:	8b 12                	mov    (%edx),%edx
f010134d:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101350:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101353:	5b                   	pop    %ebx
f0101354:	5e                   	pop    %esi
f0101355:	5d                   	pop    %ebp
f0101356:	c3                   	ret    
		panic("pa2page called with invalid pa");
f0101357:	83 ec 04             	sub    $0x4,%esp
f010135a:	8d 83 c0 c4 fe ff    	lea    -0x13b40(%ebx),%eax
f0101360:	50                   	push   %eax
f0101361:	6a 4b                	push   $0x4b
f0101363:	8d 83 11 cb fe ff    	lea    -0x134ef(%ebx),%eax
f0101369:	50                   	push   %eax
f010136a:	e8 2e ed ff ff       	call   f010009d <_panic>
		return NULL;
f010136f:	b8 00 00 00 00       	mov    $0x0,%eax
f0101374:	eb da                	jmp    f0101350 <page_lookup+0x53>

f0101376 <page_remove>:
{
f0101376:	f3 0f 1e fb          	endbr32 
f010137a:	55                   	push   %ebp
f010137b:	89 e5                	mov    %esp,%ebp
f010137d:	53                   	push   %ebx
f010137e:	83 ec 18             	sub    $0x18,%esp
f0101381:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct PageInfo* pp = page_lookup(pgdir, va, &pte);
f0101384:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101387:	50                   	push   %eax
f0101388:	53                   	push   %ebx
f0101389:	ff 75 08             	pushl  0x8(%ebp)
f010138c:	e8 6c ff ff ff       	call   f01012fd <page_lookup>
	if(pp){
f0101391:	83 c4 10             	add    $0x10,%esp
f0101394:	85 c0                	test   %eax,%eax
f0101396:	74 18                	je     f01013b0 <page_remove+0x3a>
		page_decref(pp);
f0101398:	83 ec 0c             	sub    $0xc,%esp
f010139b:	50                   	push   %eax
f010139c:	e8 cf fd ff ff       	call   f0101170 <page_decref>
		*pte = 0;
f01013a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01013a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01013aa:	0f 01 3b             	invlpg (%ebx)
}
f01013ad:	83 c4 10             	add    $0x10,%esp
}
f01013b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01013b3:	c9                   	leave  
f01013b4:	c3                   	ret    

f01013b5 <page_insert>:
{
f01013b5:	f3 0f 1e fb          	endbr32 
f01013b9:	55                   	push   %ebp
f01013ba:	89 e5                	mov    %esp,%ebp
f01013bc:	57                   	push   %edi
f01013bd:	56                   	push   %esi
f01013be:	53                   	push   %ebx
f01013bf:	83 ec 10             	sub    $0x10,%esp
f01013c2:	e8 37 1c 00 00       	call   f0102ffe <__x86.get_pc_thunk.di>
f01013c7:	81 c7 41 6f 01 00    	add    $0x16f41,%edi
f01013cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t* pte = pgdir_walk(pgdir, va, true);
f01013d0:	6a 01                	push   $0x1
f01013d2:	ff 75 10             	pushl  0x10(%ebp)
f01013d5:	ff 75 08             	pushl  0x8(%ebp)
f01013d8:	e8 c0 fd ff ff       	call   f010119d <pgdir_walk>
	if(!pte){
f01013dd:	83 c4 10             	add    $0x10,%esp
f01013e0:	85 c0                	test   %eax,%eax
f01013e2:	74 72                	je     f0101456 <page_insert+0xa1>
f01013e4:	89 c6                	mov    %eax,%esi
	if((*pte) & PTE_P){
f01013e6:	8b 00                	mov    (%eax),%eax
f01013e8:	a8 01                	test   $0x1,%al
f01013ea:	74 20                	je     f010140c <page_insert+0x57>
		if(PTE_ADDR(*pte) == page2pa(pp)){
f01013ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	return (pp - pages) << PGSHIFT;
f01013f1:	c7 c2 d0 a6 11 f0    	mov    $0xf011a6d0,%edx
f01013f7:	89 d9                	mov    %ebx,%ecx
f01013f9:	2b 0a                	sub    (%edx),%ecx
f01013fb:	89 ca                	mov    %ecx,%edx
f01013fd:	c1 fa 03             	sar    $0x3,%edx
f0101400:	c1 e2 0c             	shl    $0xc,%edx
f0101403:	39 d0                	cmp    %edx,%eax
f0101405:	75 3c                	jne    f0101443 <page_insert+0x8e>
			pp->pp_ref--;
f0101407:	66 83 6b 04 01       	subw   $0x1,0x4(%ebx)
	pp->pp_ref++;
f010140c:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
f0101411:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0101417:	2b 18                	sub    (%eax),%ebx
f0101419:	c1 fb 03             	sar    $0x3,%ebx
f010141c:	c1 e3 0c             	shl    $0xc,%ebx
	*pte = page2pa(pp) | perm | PTE_P;
f010141f:	0b 5d 14             	or     0x14(%ebp),%ebx
f0101422:	83 cb 01             	or     $0x1,%ebx
f0101425:	89 1e                	mov    %ebx,(%esi)
	pgdir[PDX(va)] |= perm;
f0101427:	8b 45 10             	mov    0x10(%ebp),%eax
f010142a:	c1 e8 16             	shr    $0x16,%eax
f010142d:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101430:	8b 7d 14             	mov    0x14(%ebp),%edi
f0101433:	09 3c 81             	or     %edi,(%ecx,%eax,4)
	return 0;
f0101436:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010143b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010143e:	5b                   	pop    %ebx
f010143f:	5e                   	pop    %esi
f0101440:	5f                   	pop    %edi
f0101441:	5d                   	pop    %ebp
f0101442:	c3                   	ret    
			page_remove(pgdir, va);
f0101443:	83 ec 08             	sub    $0x8,%esp
f0101446:	ff 75 10             	pushl  0x10(%ebp)
f0101449:	ff 75 08             	pushl  0x8(%ebp)
f010144c:	e8 25 ff ff ff       	call   f0101376 <page_remove>
f0101451:	83 c4 10             	add    $0x10,%esp
f0101454:	eb b6                	jmp    f010140c <page_insert+0x57>
		return -E_NO_MEM;
f0101456:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010145b:	eb de                	jmp    f010143b <page_insert+0x86>

f010145d <mem_init>:
{
f010145d:	f3 0f 1e fb          	endbr32 
f0101461:	55                   	push   %ebp
f0101462:	89 e5                	mov    %esp,%ebp
f0101464:	57                   	push   %edi
f0101465:	56                   	push   %esi
f0101466:	53                   	push   %ebx
f0101467:	83 ec 3c             	sub    $0x3c,%esp
f010146a:	e8 ec ec ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f010146f:	81 c3 99 6e 01 00    	add    $0x16e99,%ebx
	basemem = nvram_read(NVRAM_BASELO);
f0101475:	b8 15 00 00 00       	mov    $0x15,%eax
f010147a:	e8 5c f6 ff ff       	call   f0100adb <nvram_read>
f010147f:	89 c6                	mov    %eax,%esi
	extmem = nvram_read(NVRAM_EXTLO);
f0101481:	b8 17 00 00 00       	mov    $0x17,%eax
f0101486:	e8 50 f6 ff ff       	call   f0100adb <nvram_read>
f010148b:	89 c7                	mov    %eax,%edi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f010148d:	b8 34 00 00 00       	mov    $0x34,%eax
f0101492:	e8 44 f6 ff ff       	call   f0100adb <nvram_read>
	if (ext16mem)
f0101497:	c1 e0 06             	shl    $0x6,%eax
f010149a:	0f 84 c6 00 00 00    	je     f0101566 <mem_init+0x109>
		totalmem = 16 * 1024 + ext16mem;
f01014a0:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f01014a5:	89 c1                	mov    %eax,%ecx
f01014a7:	c1 e9 02             	shr    $0x2,%ecx
f01014aa:	c7 c2 c8 a6 11 f0    	mov    $0xf011a6c8,%edx
f01014b0:	89 0a                	mov    %ecx,(%edx)
	npages_basemem = basemem / (PGSIZE / 1024);
f01014b2:	89 f2                	mov    %esi,%edx
f01014b4:	c1 ea 02             	shr    $0x2,%edx
f01014b7:	89 93 98 1f 00 00    	mov    %edx,0x1f98(%ebx)
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01014bd:	89 c2                	mov    %eax,%edx
f01014bf:	29 f2                	sub    %esi,%edx
f01014c1:	52                   	push   %edx
f01014c2:	56                   	push   %esi
f01014c3:	50                   	push   %eax
f01014c4:	8d 83 e0 c4 fe ff    	lea    -0x13b20(%ebx),%eax
f01014ca:	50                   	push   %eax
f01014cb:	e8 c9 1b 00 00       	call   f0103099 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01014d0:	b8 00 10 00 00       	mov    $0x1000,%eax
f01014d5:	e8 b8 f5 ff ff       	call   f0100a92 <boot_alloc>
f01014da:	c7 c6 cc a6 11 f0    	mov    $0xf011a6cc,%esi
f01014e0:	89 06                	mov    %eax,(%esi)
	memset(kern_pgdir, 0, PGSIZE);
f01014e2:	83 c4 0c             	add    $0xc,%esp
f01014e5:	68 00 10 00 00       	push   $0x1000
f01014ea:	6a 00                	push   $0x0
f01014ec:	50                   	push   %eax
f01014ed:	e8 ec 27 00 00       	call   f0103cde <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01014f2:	8b 06                	mov    (%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f01014f4:	83 c4 10             	add    $0x10,%esp
f01014f7:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01014fc:	76 78                	jbe    f0101576 <mem_init+0x119>
	return (physaddr_t)kva - KERNBASE;
f01014fe:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101504:	83 ca 05             	or     $0x5,%edx
f0101507:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);
f010150d:	c7 c7 c8 a6 11 f0    	mov    $0xf011a6c8,%edi
f0101513:	8b 07                	mov    (%edi),%eax
f0101515:	c1 e0 03             	shl    $0x3,%eax
f0101518:	e8 75 f5 ff ff       	call   f0100a92 <boot_alloc>
f010151d:	c7 c6 d0 a6 11 f0    	mov    $0xf011a6d0,%esi
f0101523:	89 06                	mov    %eax,(%esi)
	memset(pages, 0, sizeof(struct PageInfo) * npages);
f0101525:	83 ec 04             	sub    $0x4,%esp
f0101528:	8b 17                	mov    (%edi),%edx
f010152a:	c1 e2 03             	shl    $0x3,%edx
f010152d:	52                   	push   %edx
f010152e:	6a 00                	push   $0x0
f0101530:	50                   	push   %eax
f0101531:	e8 a8 27 00 00       	call   f0103cde <memset>
	page_init();
f0101536:	e8 cc f9 ff ff       	call   f0100f07 <page_init>
	check_page_free_list(1);
f010153b:	b8 01 00 00 00       	mov    $0x1,%eax
f0101540:	e8 48 f6 ff ff       	call   f0100b8d <check_page_free_list>
	if (!pages)
f0101545:	83 c4 10             	add    $0x10,%esp
f0101548:	83 3e 00             	cmpl   $0x0,(%esi)
f010154b:	74 42                	je     f010158f <mem_init+0x132>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010154d:	8b 83 94 1f 00 00    	mov    0x1f94(%ebx),%eax
f0101553:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
f010155a:	85 c0                	test   %eax,%eax
f010155c:	74 4c                	je     f01015aa <mem_init+0x14d>
		++nfree;
f010155e:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101562:	8b 00                	mov    (%eax),%eax
f0101564:	eb f4                	jmp    f010155a <mem_init+0xfd>
		totalmem = 1 * 1024 + extmem;
f0101566:	8d 87 00 04 00 00    	lea    0x400(%edi),%eax
f010156c:	85 ff                	test   %edi,%edi
f010156e:	0f 44 c6             	cmove  %esi,%eax
f0101571:	e9 2f ff ff ff       	jmp    f01014a5 <mem_init+0x48>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101576:	50                   	push   %eax
f0101577:	8d 83 38 c4 fe ff    	lea    -0x13bc8(%ebx),%eax
f010157d:	50                   	push   %eax
f010157e:	68 93 00 00 00       	push   $0x93
f0101583:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0101589:	50                   	push   %eax
f010158a:	e8 0e eb ff ff       	call   f010009d <_panic>
		panic("'pages' is a null pointer!");
f010158f:	83 ec 04             	sub    $0x4,%esp
f0101592:	8d 83 bb cb fe ff    	lea    -0x13445(%ebx),%eax
f0101598:	50                   	push   %eax
f0101599:	68 b1 02 00 00       	push   $0x2b1
f010159e:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01015a4:	50                   	push   %eax
f01015a5:	e8 f3 ea ff ff       	call   f010009d <_panic>
	assert((pp0 = page_alloc(0)));
f01015aa:	83 ec 0c             	sub    $0xc,%esp
f01015ad:	6a 00                	push   $0x0
f01015af:	e8 ab fa ff ff       	call   f010105f <page_alloc>
f01015b4:	89 c6                	mov    %eax,%esi
f01015b6:	83 c4 10             	add    $0x10,%esp
f01015b9:	85 c0                	test   %eax,%eax
f01015bb:	0f 84 31 02 00 00    	je     f01017f2 <mem_init+0x395>
	assert((pp1 = page_alloc(0)));
f01015c1:	83 ec 0c             	sub    $0xc,%esp
f01015c4:	6a 00                	push   $0x0
f01015c6:	e8 94 fa ff ff       	call   f010105f <page_alloc>
f01015cb:	89 c7                	mov    %eax,%edi
f01015cd:	83 c4 10             	add    $0x10,%esp
f01015d0:	85 c0                	test   %eax,%eax
f01015d2:	0f 84 39 02 00 00    	je     f0101811 <mem_init+0x3b4>
	assert((pp2 = page_alloc(0)));
f01015d8:	83 ec 0c             	sub    $0xc,%esp
f01015db:	6a 00                	push   $0x0
f01015dd:	e8 7d fa ff ff       	call   f010105f <page_alloc>
f01015e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01015e5:	83 c4 10             	add    $0x10,%esp
f01015e8:	85 c0                	test   %eax,%eax
f01015ea:	0f 84 40 02 00 00    	je     f0101830 <mem_init+0x3d3>
	assert(pp1 && pp1 != pp0);
f01015f0:	39 fe                	cmp    %edi,%esi
f01015f2:	0f 84 57 02 00 00    	je     f010184f <mem_init+0x3f2>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01015f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01015fb:	39 c7                	cmp    %eax,%edi
f01015fd:	0f 84 6b 02 00 00    	je     f010186e <mem_init+0x411>
f0101603:	39 c6                	cmp    %eax,%esi
f0101605:	0f 84 63 02 00 00    	je     f010186e <mem_init+0x411>
	return (pp - pages) << PGSHIFT;
f010160b:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0101611:	8b 08                	mov    (%eax),%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101613:	c7 c0 c8 a6 11 f0    	mov    $0xf011a6c8,%eax
f0101619:	8b 10                	mov    (%eax),%edx
f010161b:	c1 e2 0c             	shl    $0xc,%edx
f010161e:	89 f0                	mov    %esi,%eax
f0101620:	29 c8                	sub    %ecx,%eax
f0101622:	c1 f8 03             	sar    $0x3,%eax
f0101625:	c1 e0 0c             	shl    $0xc,%eax
f0101628:	39 d0                	cmp    %edx,%eax
f010162a:	0f 83 5d 02 00 00    	jae    f010188d <mem_init+0x430>
f0101630:	89 f8                	mov    %edi,%eax
f0101632:	29 c8                	sub    %ecx,%eax
f0101634:	c1 f8 03             	sar    $0x3,%eax
f0101637:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f010163a:	39 c2                	cmp    %eax,%edx
f010163c:	0f 86 6a 02 00 00    	jbe    f01018ac <mem_init+0x44f>
f0101642:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101645:	29 c8                	sub    %ecx,%eax
f0101647:	c1 f8 03             	sar    $0x3,%eax
f010164a:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f010164d:	39 c2                	cmp    %eax,%edx
f010164f:	0f 86 76 02 00 00    	jbe    f01018cb <mem_init+0x46e>
	fl = page_free_list;
f0101655:	8b 83 94 1f 00 00    	mov    0x1f94(%ebx),%eax
f010165b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f010165e:	c7 83 94 1f 00 00 00 	movl   $0x0,0x1f94(%ebx)
f0101665:	00 00 00 
	assert(!page_alloc(0));
f0101668:	83 ec 0c             	sub    $0xc,%esp
f010166b:	6a 00                	push   $0x0
f010166d:	e8 ed f9 ff ff       	call   f010105f <page_alloc>
f0101672:	83 c4 10             	add    $0x10,%esp
f0101675:	85 c0                	test   %eax,%eax
f0101677:	0f 85 6d 02 00 00    	jne    f01018ea <mem_init+0x48d>
	page_free(pp0);
f010167d:	83 ec 0c             	sub    $0xc,%esp
f0101680:	56                   	push   %esi
f0101681:	e8 7c fa ff ff       	call   f0101102 <page_free>
	page_free(pp1);
f0101686:	89 3c 24             	mov    %edi,(%esp)
f0101689:	e8 74 fa ff ff       	call   f0101102 <page_free>
	page_free(pp2);
f010168e:	83 c4 04             	add    $0x4,%esp
f0101691:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101694:	e8 69 fa ff ff       	call   f0101102 <page_free>
	assert((pp0 = page_alloc(0)));
f0101699:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01016a0:	e8 ba f9 ff ff       	call   f010105f <page_alloc>
f01016a5:	89 c6                	mov    %eax,%esi
f01016a7:	83 c4 10             	add    $0x10,%esp
f01016aa:	85 c0                	test   %eax,%eax
f01016ac:	0f 84 57 02 00 00    	je     f0101909 <mem_init+0x4ac>
	assert((pp1 = page_alloc(0)));
f01016b2:	83 ec 0c             	sub    $0xc,%esp
f01016b5:	6a 00                	push   $0x0
f01016b7:	e8 a3 f9 ff ff       	call   f010105f <page_alloc>
f01016bc:	89 c7                	mov    %eax,%edi
f01016be:	83 c4 10             	add    $0x10,%esp
f01016c1:	85 c0                	test   %eax,%eax
f01016c3:	0f 84 5f 02 00 00    	je     f0101928 <mem_init+0x4cb>
	assert((pp2 = page_alloc(0)));
f01016c9:	83 ec 0c             	sub    $0xc,%esp
f01016cc:	6a 00                	push   $0x0
f01016ce:	e8 8c f9 ff ff       	call   f010105f <page_alloc>
f01016d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01016d6:	83 c4 10             	add    $0x10,%esp
f01016d9:	85 c0                	test   %eax,%eax
f01016db:	0f 84 66 02 00 00    	je     f0101947 <mem_init+0x4ea>
	assert(pp1 && pp1 != pp0);
f01016e1:	39 fe                	cmp    %edi,%esi
f01016e3:	0f 84 7d 02 00 00    	je     f0101966 <mem_init+0x509>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01016e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01016ec:	39 c7                	cmp    %eax,%edi
f01016ee:	0f 84 91 02 00 00    	je     f0101985 <mem_init+0x528>
f01016f4:	39 c6                	cmp    %eax,%esi
f01016f6:	0f 84 89 02 00 00    	je     f0101985 <mem_init+0x528>
	assert(!page_alloc(0));
f01016fc:	83 ec 0c             	sub    $0xc,%esp
f01016ff:	6a 00                	push   $0x0
f0101701:	e8 59 f9 ff ff       	call   f010105f <page_alloc>
f0101706:	83 c4 10             	add    $0x10,%esp
f0101709:	85 c0                	test   %eax,%eax
f010170b:	0f 85 93 02 00 00    	jne    f01019a4 <mem_init+0x547>
f0101711:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0101717:	89 f1                	mov    %esi,%ecx
f0101719:	2b 08                	sub    (%eax),%ecx
f010171b:	89 c8                	mov    %ecx,%eax
f010171d:	c1 f8 03             	sar    $0x3,%eax
f0101720:	89 c2                	mov    %eax,%edx
f0101722:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101725:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010172a:	c7 c1 c8 a6 11 f0    	mov    $0xf011a6c8,%ecx
f0101730:	3b 01                	cmp    (%ecx),%eax
f0101732:	0f 83 8b 02 00 00    	jae    f01019c3 <mem_init+0x566>
	memset(page2kva(pp0), 1, PGSIZE);
f0101738:	83 ec 04             	sub    $0x4,%esp
f010173b:	68 00 10 00 00       	push   $0x1000
f0101740:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101742:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101748:	52                   	push   %edx
f0101749:	e8 90 25 00 00       	call   f0103cde <memset>
	page_free(pp0);
f010174e:	89 34 24             	mov    %esi,(%esp)
f0101751:	e8 ac f9 ff ff       	call   f0101102 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101756:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010175d:	e8 fd f8 ff ff       	call   f010105f <page_alloc>
f0101762:	83 c4 10             	add    $0x10,%esp
f0101765:	85 c0                	test   %eax,%eax
f0101767:	0f 84 6c 02 00 00    	je     f01019d9 <mem_init+0x57c>
	assert(pp && pp0 == pp);
f010176d:	39 c6                	cmp    %eax,%esi
f010176f:	0f 85 83 02 00 00    	jne    f01019f8 <mem_init+0x59b>
	return (pp - pages) << PGSHIFT;
f0101775:	c7 c2 d0 a6 11 f0    	mov    $0xf011a6d0,%edx
f010177b:	2b 02                	sub    (%edx),%eax
f010177d:	c1 f8 03             	sar    $0x3,%eax
f0101780:	89 c2                	mov    %eax,%edx
f0101782:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101785:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010178a:	c7 c1 c8 a6 11 f0    	mov    $0xf011a6c8,%ecx
f0101790:	3b 01                	cmp    (%ecx),%eax
f0101792:	0f 83 7f 02 00 00    	jae    f0101a17 <mem_init+0x5ba>
	return (void *)(pa + KERNBASE);
f0101798:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f010179e:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f01017a4:	80 38 00             	cmpb   $0x0,(%eax)
f01017a7:	0f 85 80 02 00 00    	jne    f0101a2d <mem_init+0x5d0>
f01017ad:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f01017b0:	39 d0                	cmp    %edx,%eax
f01017b2:	75 f0                	jne    f01017a4 <mem_init+0x347>
	page_free_list = fl;
f01017b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01017b7:	89 83 94 1f 00 00    	mov    %eax,0x1f94(%ebx)
	page_free(pp0);
f01017bd:	83 ec 0c             	sub    $0xc,%esp
f01017c0:	56                   	push   %esi
f01017c1:	e8 3c f9 ff ff       	call   f0101102 <page_free>
	page_free(pp1);
f01017c6:	89 3c 24             	mov    %edi,(%esp)
f01017c9:	e8 34 f9 ff ff       	call   f0101102 <page_free>
	page_free(pp2);
f01017ce:	83 c4 04             	add    $0x4,%esp
f01017d1:	ff 75 d4             	pushl  -0x2c(%ebp)
f01017d4:	e8 29 f9 ff ff       	call   f0101102 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01017d9:	8b 83 94 1f 00 00    	mov    0x1f94(%ebx),%eax
f01017df:	83 c4 10             	add    $0x10,%esp
f01017e2:	85 c0                	test   %eax,%eax
f01017e4:	0f 84 62 02 00 00    	je     f0101a4c <mem_init+0x5ef>
		--nfree;
f01017ea:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01017ee:	8b 00                	mov    (%eax),%eax
f01017f0:	eb f0                	jmp    f01017e2 <mem_init+0x385>
	assert((pp0 = page_alloc(0)));
f01017f2:	8d 83 d6 cb fe ff    	lea    -0x1342a(%ebx),%eax
f01017f8:	50                   	push   %eax
f01017f9:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01017ff:	50                   	push   %eax
f0101800:	68 b9 02 00 00       	push   $0x2b9
f0101805:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010180b:	50                   	push   %eax
f010180c:	e8 8c e8 ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f0101811:	8d 83 ec cb fe ff    	lea    -0x13414(%ebx),%eax
f0101817:	50                   	push   %eax
f0101818:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010181e:	50                   	push   %eax
f010181f:	68 ba 02 00 00       	push   $0x2ba
f0101824:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010182a:	50                   	push   %eax
f010182b:	e8 6d e8 ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f0101830:	8d 83 02 cc fe ff    	lea    -0x133fe(%ebx),%eax
f0101836:	50                   	push   %eax
f0101837:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010183d:	50                   	push   %eax
f010183e:	68 bb 02 00 00       	push   $0x2bb
f0101843:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0101849:	50                   	push   %eax
f010184a:	e8 4e e8 ff ff       	call   f010009d <_panic>
	assert(pp1 && pp1 != pp0);
f010184f:	8d 83 18 cc fe ff    	lea    -0x133e8(%ebx),%eax
f0101855:	50                   	push   %eax
f0101856:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010185c:	50                   	push   %eax
f010185d:	68 be 02 00 00       	push   $0x2be
f0101862:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0101868:	50                   	push   %eax
f0101869:	e8 2f e8 ff ff       	call   f010009d <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010186e:	8d 83 1c c5 fe ff    	lea    -0x13ae4(%ebx),%eax
f0101874:	50                   	push   %eax
f0101875:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010187b:	50                   	push   %eax
f010187c:	68 bf 02 00 00       	push   $0x2bf
f0101881:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0101887:	50                   	push   %eax
f0101888:	e8 10 e8 ff ff       	call   f010009d <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f010188d:	8d 83 2a cc fe ff    	lea    -0x133d6(%ebx),%eax
f0101893:	50                   	push   %eax
f0101894:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010189a:	50                   	push   %eax
f010189b:	68 c0 02 00 00       	push   $0x2c0
f01018a0:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01018a6:	50                   	push   %eax
f01018a7:	e8 f1 e7 ff ff       	call   f010009d <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f01018ac:	8d 83 47 cc fe ff    	lea    -0x133b9(%ebx),%eax
f01018b2:	50                   	push   %eax
f01018b3:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01018b9:	50                   	push   %eax
f01018ba:	68 c1 02 00 00       	push   $0x2c1
f01018bf:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01018c5:	50                   	push   %eax
f01018c6:	e8 d2 e7 ff ff       	call   f010009d <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f01018cb:	8d 83 64 cc fe ff    	lea    -0x1339c(%ebx),%eax
f01018d1:	50                   	push   %eax
f01018d2:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01018d8:	50                   	push   %eax
f01018d9:	68 c2 02 00 00       	push   $0x2c2
f01018de:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01018e4:	50                   	push   %eax
f01018e5:	e8 b3 e7 ff ff       	call   f010009d <_panic>
	assert(!page_alloc(0));
f01018ea:	8d 83 81 cc fe ff    	lea    -0x1337f(%ebx),%eax
f01018f0:	50                   	push   %eax
f01018f1:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01018f7:	50                   	push   %eax
f01018f8:	68 c9 02 00 00       	push   $0x2c9
f01018fd:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0101903:	50                   	push   %eax
f0101904:	e8 94 e7 ff ff       	call   f010009d <_panic>
	assert((pp0 = page_alloc(0)));
f0101909:	8d 83 d6 cb fe ff    	lea    -0x1342a(%ebx),%eax
f010190f:	50                   	push   %eax
f0101910:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0101916:	50                   	push   %eax
f0101917:	68 d0 02 00 00       	push   $0x2d0
f010191c:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0101922:	50                   	push   %eax
f0101923:	e8 75 e7 ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f0101928:	8d 83 ec cb fe ff    	lea    -0x13414(%ebx),%eax
f010192e:	50                   	push   %eax
f010192f:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0101935:	50                   	push   %eax
f0101936:	68 d1 02 00 00       	push   $0x2d1
f010193b:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0101941:	50                   	push   %eax
f0101942:	e8 56 e7 ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f0101947:	8d 83 02 cc fe ff    	lea    -0x133fe(%ebx),%eax
f010194d:	50                   	push   %eax
f010194e:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0101954:	50                   	push   %eax
f0101955:	68 d2 02 00 00       	push   $0x2d2
f010195a:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0101960:	50                   	push   %eax
f0101961:	e8 37 e7 ff ff       	call   f010009d <_panic>
	assert(pp1 && pp1 != pp0);
f0101966:	8d 83 18 cc fe ff    	lea    -0x133e8(%ebx),%eax
f010196c:	50                   	push   %eax
f010196d:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0101973:	50                   	push   %eax
f0101974:	68 d4 02 00 00       	push   $0x2d4
f0101979:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010197f:	50                   	push   %eax
f0101980:	e8 18 e7 ff ff       	call   f010009d <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101985:	8d 83 1c c5 fe ff    	lea    -0x13ae4(%ebx),%eax
f010198b:	50                   	push   %eax
f010198c:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0101992:	50                   	push   %eax
f0101993:	68 d5 02 00 00       	push   $0x2d5
f0101998:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010199e:	50                   	push   %eax
f010199f:	e8 f9 e6 ff ff       	call   f010009d <_panic>
	assert(!page_alloc(0));
f01019a4:	8d 83 81 cc fe ff    	lea    -0x1337f(%ebx),%eax
f01019aa:	50                   	push   %eax
f01019ab:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01019b1:	50                   	push   %eax
f01019b2:	68 d6 02 00 00       	push   $0x2d6
f01019b7:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01019bd:	50                   	push   %eax
f01019be:	e8 da e6 ff ff       	call   f010009d <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01019c3:	52                   	push   %edx
f01019c4:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f01019ca:	50                   	push   %eax
f01019cb:	6a 52                	push   $0x52
f01019cd:	8d 83 11 cb fe ff    	lea    -0x134ef(%ebx),%eax
f01019d3:	50                   	push   %eax
f01019d4:	e8 c4 e6 ff ff       	call   f010009d <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01019d9:	8d 83 90 cc fe ff    	lea    -0x13370(%ebx),%eax
f01019df:	50                   	push   %eax
f01019e0:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01019e6:	50                   	push   %eax
f01019e7:	68 db 02 00 00       	push   $0x2db
f01019ec:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01019f2:	50                   	push   %eax
f01019f3:	e8 a5 e6 ff ff       	call   f010009d <_panic>
	assert(pp && pp0 == pp);
f01019f8:	8d 83 ae cc fe ff    	lea    -0x13352(%ebx),%eax
f01019fe:	50                   	push   %eax
f01019ff:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0101a05:	50                   	push   %eax
f0101a06:	68 dc 02 00 00       	push   $0x2dc
f0101a0b:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0101a11:	50                   	push   %eax
f0101a12:	e8 86 e6 ff ff       	call   f010009d <_panic>
f0101a17:	52                   	push   %edx
f0101a18:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f0101a1e:	50                   	push   %eax
f0101a1f:	6a 52                	push   $0x52
f0101a21:	8d 83 11 cb fe ff    	lea    -0x134ef(%ebx),%eax
f0101a27:	50                   	push   %eax
f0101a28:	e8 70 e6 ff ff       	call   f010009d <_panic>
		assert(c[i] == 0);
f0101a2d:	8d 83 be cc fe ff    	lea    -0x13342(%ebx),%eax
f0101a33:	50                   	push   %eax
f0101a34:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0101a3a:	50                   	push   %eax
f0101a3b:	68 df 02 00 00       	push   $0x2df
f0101a40:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0101a46:	50                   	push   %eax
f0101a47:	e8 51 e6 ff ff       	call   f010009d <_panic>
	assert(nfree == 0);
f0101a4c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0101a50:	0f 85 47 08 00 00    	jne    f010229d <mem_init+0xe40>
	cprintf("check_page_alloc() succeeded!\n");
f0101a56:	83 ec 0c             	sub    $0xc,%esp
f0101a59:	8d 83 3c c5 fe ff    	lea    -0x13ac4(%ebx),%eax
f0101a5f:	50                   	push   %eax
f0101a60:	e8 34 16 00 00       	call   f0103099 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101a65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a6c:	e8 ee f5 ff ff       	call   f010105f <page_alloc>
f0101a71:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101a74:	83 c4 10             	add    $0x10,%esp
f0101a77:	85 c0                	test   %eax,%eax
f0101a79:	0f 84 3d 08 00 00    	je     f01022bc <mem_init+0xe5f>
	assert((pp1 = page_alloc(0)));
f0101a7f:	83 ec 0c             	sub    $0xc,%esp
f0101a82:	6a 00                	push   $0x0
f0101a84:	e8 d6 f5 ff ff       	call   f010105f <page_alloc>
f0101a89:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101a8c:	83 c4 10             	add    $0x10,%esp
f0101a8f:	85 c0                	test   %eax,%eax
f0101a91:	0f 84 44 08 00 00    	je     f01022db <mem_init+0xe7e>
	assert((pp2 = page_alloc(0)));
f0101a97:	83 ec 0c             	sub    $0xc,%esp
f0101a9a:	6a 00                	push   $0x0
f0101a9c:	e8 be f5 ff ff       	call   f010105f <page_alloc>
f0101aa1:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101aa4:	83 c4 10             	add    $0x10,%esp
f0101aa7:	85 c0                	test   %eax,%eax
f0101aa9:	0f 84 4b 08 00 00    	je     f01022fa <mem_init+0xe9d>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101aaf:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0101ab2:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0101ab5:	0f 84 5e 08 00 00    	je     f0102319 <mem_init+0xebc>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101abb:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101abe:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101ac1:	0f 84 71 08 00 00    	je     f0102338 <mem_init+0xedb>
f0101ac7:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0101aca:	0f 84 68 08 00 00    	je     f0102338 <mem_init+0xedb>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101ad0:	8b 83 94 1f 00 00    	mov    0x1f94(%ebx),%eax
f0101ad6:	89 45 c8             	mov    %eax,-0x38(%ebp)
	page_free_list = 0;
f0101ad9:	c7 83 94 1f 00 00 00 	movl   $0x0,0x1f94(%ebx)
f0101ae0:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101ae3:	83 ec 0c             	sub    $0xc,%esp
f0101ae6:	6a 00                	push   $0x0
f0101ae8:	e8 72 f5 ff ff       	call   f010105f <page_alloc>
f0101aed:	83 c4 10             	add    $0x10,%esp
f0101af0:	85 c0                	test   %eax,%eax
f0101af2:	0f 85 5f 08 00 00    	jne    f0102357 <mem_init+0xefa>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101af8:	83 ec 04             	sub    $0x4,%esp
f0101afb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101afe:	50                   	push   %eax
f0101aff:	6a 00                	push   $0x0
f0101b01:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101b07:	ff 30                	pushl  (%eax)
f0101b09:	e8 ef f7 ff ff       	call   f01012fd <page_lookup>
f0101b0e:	83 c4 10             	add    $0x10,%esp
f0101b11:	85 c0                	test   %eax,%eax
f0101b13:	0f 85 5d 08 00 00    	jne    f0102376 <mem_init+0xf19>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101b19:	6a 02                	push   $0x2
f0101b1b:	6a 00                	push   $0x0
f0101b1d:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101b20:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101b26:	ff 30                	pushl  (%eax)
f0101b28:	e8 88 f8 ff ff       	call   f01013b5 <page_insert>
f0101b2d:	83 c4 10             	add    $0x10,%esp
f0101b30:	85 c0                	test   %eax,%eax
f0101b32:	0f 89 5d 08 00 00    	jns    f0102395 <mem_init+0xf38>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101b38:	83 ec 0c             	sub    $0xc,%esp
f0101b3b:	ff 75 cc             	pushl  -0x34(%ebp)
f0101b3e:	e8 bf f5 ff ff       	call   f0101102 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101b43:	6a 02                	push   $0x2
f0101b45:	6a 00                	push   $0x0
f0101b47:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101b4a:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101b50:	ff 30                	pushl  (%eax)
f0101b52:	e8 5e f8 ff ff       	call   f01013b5 <page_insert>
f0101b57:	83 c4 20             	add    $0x20,%esp
f0101b5a:	85 c0                	test   %eax,%eax
f0101b5c:	0f 85 52 08 00 00    	jne    f01023b4 <mem_init+0xf57>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101b62:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101b68:	8b 30                	mov    (%eax),%esi
	return (pp - pages) << PGSHIFT;
f0101b6a:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0101b70:	8b 38                	mov    (%eax),%edi
f0101b72:	8b 16                	mov    (%esi),%edx
f0101b74:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101b7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101b7d:	29 f8                	sub    %edi,%eax
f0101b7f:	c1 f8 03             	sar    $0x3,%eax
f0101b82:	c1 e0 0c             	shl    $0xc,%eax
f0101b85:	39 c2                	cmp    %eax,%edx
f0101b87:	0f 85 46 08 00 00    	jne    f01023d3 <mem_init+0xf76>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101b8d:	ba 00 00 00 00       	mov    $0x0,%edx
f0101b92:	89 f0                	mov    %esi,%eax
f0101b94:	e8 78 ef ff ff       	call   f0100b11 <check_va2pa>
f0101b99:	89 c2                	mov    %eax,%edx
f0101b9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101b9e:	29 f8                	sub    %edi,%eax
f0101ba0:	c1 f8 03             	sar    $0x3,%eax
f0101ba3:	c1 e0 0c             	shl    $0xc,%eax
f0101ba6:	39 c2                	cmp    %eax,%edx
f0101ba8:	0f 85 44 08 00 00    	jne    f01023f2 <mem_init+0xf95>
	assert(pp1->pp_ref == 1);
f0101bae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101bb1:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101bb6:	0f 85 55 08 00 00    	jne    f0102411 <mem_init+0xfb4>
	assert(pp0->pp_ref == 1);
f0101bbc:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101bbf:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101bc4:	0f 85 66 08 00 00    	jne    f0102430 <mem_init+0xfd3>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101bca:	6a 02                	push   $0x2
f0101bcc:	68 00 10 00 00       	push   $0x1000
f0101bd1:	ff 75 d0             	pushl  -0x30(%ebp)
f0101bd4:	56                   	push   %esi
f0101bd5:	e8 db f7 ff ff       	call   f01013b5 <page_insert>
f0101bda:	83 c4 10             	add    $0x10,%esp
f0101bdd:	85 c0                	test   %eax,%eax
f0101bdf:	0f 85 6a 08 00 00    	jne    f010244f <mem_init+0xff2>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101be5:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101bea:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101bf0:	8b 00                	mov    (%eax),%eax
f0101bf2:	e8 1a ef ff ff       	call   f0100b11 <check_va2pa>
f0101bf7:	89 c2                	mov    %eax,%edx
f0101bf9:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0101bff:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101c02:	2b 08                	sub    (%eax),%ecx
f0101c04:	89 c8                	mov    %ecx,%eax
f0101c06:	c1 f8 03             	sar    $0x3,%eax
f0101c09:	c1 e0 0c             	shl    $0xc,%eax
f0101c0c:	39 c2                	cmp    %eax,%edx
f0101c0e:	0f 85 5a 08 00 00    	jne    f010246e <mem_init+0x1011>
	assert(pp2->pp_ref == 1);
f0101c14:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101c17:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101c1c:	0f 85 6b 08 00 00    	jne    f010248d <mem_init+0x1030>

	// should be no free memory
	assert(!page_alloc(0));
f0101c22:	83 ec 0c             	sub    $0xc,%esp
f0101c25:	6a 00                	push   $0x0
f0101c27:	e8 33 f4 ff ff       	call   f010105f <page_alloc>
f0101c2c:	83 c4 10             	add    $0x10,%esp
f0101c2f:	85 c0                	test   %eax,%eax
f0101c31:	0f 85 75 08 00 00    	jne    f01024ac <mem_init+0x104f>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101c37:	6a 02                	push   $0x2
f0101c39:	68 00 10 00 00       	push   $0x1000
f0101c3e:	ff 75 d0             	pushl  -0x30(%ebp)
f0101c41:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101c47:	ff 30                	pushl  (%eax)
f0101c49:	e8 67 f7 ff ff       	call   f01013b5 <page_insert>
f0101c4e:	83 c4 10             	add    $0x10,%esp
f0101c51:	85 c0                	test   %eax,%eax
f0101c53:	0f 85 72 08 00 00    	jne    f01024cb <mem_init+0x106e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101c59:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c5e:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101c64:	8b 00                	mov    (%eax),%eax
f0101c66:	e8 a6 ee ff ff       	call   f0100b11 <check_va2pa>
f0101c6b:	89 c2                	mov    %eax,%edx
f0101c6d:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0101c73:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101c76:	2b 08                	sub    (%eax),%ecx
f0101c78:	89 c8                	mov    %ecx,%eax
f0101c7a:	c1 f8 03             	sar    $0x3,%eax
f0101c7d:	c1 e0 0c             	shl    $0xc,%eax
f0101c80:	39 c2                	cmp    %eax,%edx
f0101c82:	0f 85 62 08 00 00    	jne    f01024ea <mem_init+0x108d>
	assert(pp2->pp_ref == 1);
f0101c88:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101c8b:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101c90:	0f 85 73 08 00 00    	jne    f0102509 <mem_init+0x10ac>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101c96:	83 ec 0c             	sub    $0xc,%esp
f0101c99:	6a 00                	push   $0x0
f0101c9b:	e8 bf f3 ff ff       	call   f010105f <page_alloc>
f0101ca0:	83 c4 10             	add    $0x10,%esp
f0101ca3:	85 c0                	test   %eax,%eax
f0101ca5:	0f 85 7d 08 00 00    	jne    f0102528 <mem_init+0x10cb>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101cab:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101cb1:	8b 08                	mov    (%eax),%ecx
f0101cb3:	8b 01                	mov    (%ecx),%eax
f0101cb5:	89 c2                	mov    %eax,%edx
f0101cb7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101cbd:	c1 e8 0c             	shr    $0xc,%eax
f0101cc0:	c7 c6 c8 a6 11 f0    	mov    $0xf011a6c8,%esi
f0101cc6:	3b 06                	cmp    (%esi),%eax
f0101cc8:	0f 83 79 08 00 00    	jae    f0102547 <mem_init+0x10ea>
	return (void *)(pa + KERNBASE);
f0101cce:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101cd4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101cd7:	83 ec 04             	sub    $0x4,%esp
f0101cda:	6a 00                	push   $0x0
f0101cdc:	68 00 10 00 00       	push   $0x1000
f0101ce1:	51                   	push   %ecx
f0101ce2:	e8 b6 f4 ff ff       	call   f010119d <pgdir_walk>
f0101ce7:	89 c2                	mov    %eax,%edx
f0101ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101cec:	83 c0 04             	add    $0x4,%eax
f0101cef:	83 c4 10             	add    $0x10,%esp
f0101cf2:	39 d0                	cmp    %edx,%eax
f0101cf4:	0f 85 66 08 00 00    	jne    f0102560 <mem_init+0x1103>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101cfa:	6a 06                	push   $0x6
f0101cfc:	68 00 10 00 00       	push   $0x1000
f0101d01:	ff 75 d0             	pushl  -0x30(%ebp)
f0101d04:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101d0a:	ff 30                	pushl  (%eax)
f0101d0c:	e8 a4 f6 ff ff       	call   f01013b5 <page_insert>
f0101d11:	83 c4 10             	add    $0x10,%esp
f0101d14:	85 c0                	test   %eax,%eax
f0101d16:	0f 85 63 08 00 00    	jne    f010257f <mem_init+0x1122>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101d1c:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101d22:	8b 30                	mov    (%eax),%esi
f0101d24:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d29:	89 f0                	mov    %esi,%eax
f0101d2b:	e8 e1 ed ff ff       	call   f0100b11 <check_va2pa>
f0101d30:	89 c2                	mov    %eax,%edx
	return (pp - pages) << PGSHIFT;
f0101d32:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0101d38:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101d3b:	2b 08                	sub    (%eax),%ecx
f0101d3d:	89 c8                	mov    %ecx,%eax
f0101d3f:	c1 f8 03             	sar    $0x3,%eax
f0101d42:	c1 e0 0c             	shl    $0xc,%eax
f0101d45:	39 c2                	cmp    %eax,%edx
f0101d47:	0f 85 51 08 00 00    	jne    f010259e <mem_init+0x1141>
	assert(pp2->pp_ref == 1);
f0101d4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101d50:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101d55:	0f 85 62 08 00 00    	jne    f01025bd <mem_init+0x1160>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101d5b:	83 ec 04             	sub    $0x4,%esp
f0101d5e:	6a 00                	push   $0x0
f0101d60:	68 00 10 00 00       	push   $0x1000
f0101d65:	56                   	push   %esi
f0101d66:	e8 32 f4 ff ff       	call   f010119d <pgdir_walk>
f0101d6b:	83 c4 10             	add    $0x10,%esp
f0101d6e:	f6 00 04             	testb  $0x4,(%eax)
f0101d71:	0f 84 65 08 00 00    	je     f01025dc <mem_init+0x117f>
	assert(kern_pgdir[0] & PTE_U);
f0101d77:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101d7d:	8b 00                	mov    (%eax),%eax
f0101d7f:	f6 00 04             	testb  $0x4,(%eax)
f0101d82:	0f 84 73 08 00 00    	je     f01025fb <mem_init+0x119e>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101d88:	6a 02                	push   $0x2
f0101d8a:	68 00 10 00 00       	push   $0x1000
f0101d8f:	ff 75 d0             	pushl  -0x30(%ebp)
f0101d92:	50                   	push   %eax
f0101d93:	e8 1d f6 ff ff       	call   f01013b5 <page_insert>
f0101d98:	83 c4 10             	add    $0x10,%esp
f0101d9b:	85 c0                	test   %eax,%eax
f0101d9d:	0f 85 77 08 00 00    	jne    f010261a <mem_init+0x11bd>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101da3:	83 ec 04             	sub    $0x4,%esp
f0101da6:	6a 00                	push   $0x0
f0101da8:	68 00 10 00 00       	push   $0x1000
f0101dad:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101db3:	ff 30                	pushl  (%eax)
f0101db5:	e8 e3 f3 ff ff       	call   f010119d <pgdir_walk>
f0101dba:	83 c4 10             	add    $0x10,%esp
f0101dbd:	f6 00 02             	testb  $0x2,(%eax)
f0101dc0:	0f 84 73 08 00 00    	je     f0102639 <mem_init+0x11dc>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101dc6:	83 ec 04             	sub    $0x4,%esp
f0101dc9:	6a 00                	push   $0x0
f0101dcb:	68 00 10 00 00       	push   $0x1000
f0101dd0:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101dd6:	ff 30                	pushl  (%eax)
f0101dd8:	e8 c0 f3 ff ff       	call   f010119d <pgdir_walk>
f0101ddd:	83 c4 10             	add    $0x10,%esp
f0101de0:	f6 00 04             	testb  $0x4,(%eax)
f0101de3:	0f 85 6f 08 00 00    	jne    f0102658 <mem_init+0x11fb>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101de9:	6a 02                	push   $0x2
f0101deb:	68 00 00 40 00       	push   $0x400000
f0101df0:	ff 75 cc             	pushl  -0x34(%ebp)
f0101df3:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101df9:	ff 30                	pushl  (%eax)
f0101dfb:	e8 b5 f5 ff ff       	call   f01013b5 <page_insert>
f0101e00:	83 c4 10             	add    $0x10,%esp
f0101e03:	85 c0                	test   %eax,%eax
f0101e05:	0f 89 6c 08 00 00    	jns    f0102677 <mem_init+0x121a>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101e0b:	6a 02                	push   $0x2
f0101e0d:	68 00 10 00 00       	push   $0x1000
f0101e12:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101e15:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101e1b:	ff 30                	pushl  (%eax)
f0101e1d:	e8 93 f5 ff ff       	call   f01013b5 <page_insert>
f0101e22:	83 c4 10             	add    $0x10,%esp
f0101e25:	85 c0                	test   %eax,%eax
f0101e27:	0f 85 69 08 00 00    	jne    f0102696 <mem_init+0x1239>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101e2d:	83 ec 04             	sub    $0x4,%esp
f0101e30:	6a 00                	push   $0x0
f0101e32:	68 00 10 00 00       	push   $0x1000
f0101e37:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101e3d:	ff 30                	pushl  (%eax)
f0101e3f:	e8 59 f3 ff ff       	call   f010119d <pgdir_walk>
f0101e44:	83 c4 10             	add    $0x10,%esp
f0101e47:	f6 00 04             	testb  $0x4,(%eax)
f0101e4a:	0f 85 65 08 00 00    	jne    f01026b5 <mem_init+0x1258>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101e50:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0101e56:	8b 38                	mov    (%eax),%edi
f0101e58:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e5d:	89 f8                	mov    %edi,%eax
f0101e5f:	e8 ad ec ff ff       	call   f0100b11 <check_va2pa>
f0101e64:	c7 c2 d0 a6 11 f0    	mov    $0xf011a6d0,%edx
f0101e6a:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0101e6d:	2b 32                	sub    (%edx),%esi
f0101e6f:	c1 fe 03             	sar    $0x3,%esi
f0101e72:	c1 e6 0c             	shl    $0xc,%esi
f0101e75:	39 f0                	cmp    %esi,%eax
f0101e77:	0f 85 57 08 00 00    	jne    f01026d4 <mem_init+0x1277>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101e7d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e82:	89 f8                	mov    %edi,%eax
f0101e84:	e8 88 ec ff ff       	call   f0100b11 <check_va2pa>
f0101e89:	39 c6                	cmp    %eax,%esi
f0101e8b:	0f 85 62 08 00 00    	jne    f01026f3 <mem_init+0x1296>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101e91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e94:	66 83 78 04 02       	cmpw   $0x2,0x4(%eax)
f0101e99:	0f 85 73 08 00 00    	jne    f0102712 <mem_init+0x12b5>
	assert(pp2->pp_ref == 0);
f0101e9f:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101ea2:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101ea7:	0f 85 84 08 00 00    	jne    f0102731 <mem_init+0x12d4>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101ead:	83 ec 0c             	sub    $0xc,%esp
f0101eb0:	6a 00                	push   $0x0
f0101eb2:	e8 a8 f1 ff ff       	call   f010105f <page_alloc>
f0101eb7:	83 c4 10             	add    $0x10,%esp
f0101eba:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101ebd:	0f 85 8d 08 00 00    	jne    f0102750 <mem_init+0x12f3>
f0101ec3:	85 c0                	test   %eax,%eax
f0101ec5:	0f 84 85 08 00 00    	je     f0102750 <mem_init+0x12f3>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101ecb:	83 ec 08             	sub    $0x8,%esp
f0101ece:	6a 00                	push   $0x0
f0101ed0:	c7 c6 cc a6 11 f0    	mov    $0xf011a6cc,%esi
f0101ed6:	ff 36                	pushl  (%esi)
f0101ed8:	e8 99 f4 ff ff       	call   f0101376 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101edd:	8b 36                	mov    (%esi),%esi
f0101edf:	ba 00 00 00 00       	mov    $0x0,%edx
f0101ee4:	89 f0                	mov    %esi,%eax
f0101ee6:	e8 26 ec ff ff       	call   f0100b11 <check_va2pa>
f0101eeb:	83 c4 10             	add    $0x10,%esp
f0101eee:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101ef1:	0f 85 78 08 00 00    	jne    f010276f <mem_init+0x1312>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101ef7:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101efc:	89 f0                	mov    %esi,%eax
f0101efe:	e8 0e ec ff ff       	call   f0100b11 <check_va2pa>
f0101f03:	89 c2                	mov    %eax,%edx
f0101f05:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0101f0b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101f0e:	2b 08                	sub    (%eax),%ecx
f0101f10:	89 c8                	mov    %ecx,%eax
f0101f12:	c1 f8 03             	sar    $0x3,%eax
f0101f15:	c1 e0 0c             	shl    $0xc,%eax
f0101f18:	39 c2                	cmp    %eax,%edx
f0101f1a:	0f 85 6e 08 00 00    	jne    f010278e <mem_init+0x1331>
	assert(pp1->pp_ref == 1);
f0101f20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f23:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101f28:	0f 85 7f 08 00 00    	jne    f01027ad <mem_init+0x1350>
	assert(pp2->pp_ref == 0);
f0101f2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101f31:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101f36:	0f 85 90 08 00 00    	jne    f01027cc <mem_init+0x136f>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101f3c:	6a 00                	push   $0x0
f0101f3e:	68 00 10 00 00       	push   $0x1000
f0101f43:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101f46:	56                   	push   %esi
f0101f47:	e8 69 f4 ff ff       	call   f01013b5 <page_insert>
f0101f4c:	83 c4 10             	add    $0x10,%esp
f0101f4f:	85 c0                	test   %eax,%eax
f0101f51:	0f 85 94 08 00 00    	jne    f01027eb <mem_init+0x138e>
	assert(pp1->pp_ref);
f0101f57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f5a:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101f5f:	0f 84 a5 08 00 00    	je     f010280a <mem_init+0x13ad>
	assert(pp1->pp_link == NULL);
f0101f65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f68:	83 38 00             	cmpl   $0x0,(%eax)
f0101f6b:	0f 85 b8 08 00 00    	jne    f0102829 <mem_init+0x13cc>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101f71:	83 ec 08             	sub    $0x8,%esp
f0101f74:	68 00 10 00 00       	push   $0x1000
f0101f79:	c7 c6 cc a6 11 f0    	mov    $0xf011a6cc,%esi
f0101f7f:	ff 36                	pushl  (%esi)
f0101f81:	e8 f0 f3 ff ff       	call   f0101376 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101f86:	8b 36                	mov    (%esi),%esi
f0101f88:	ba 00 00 00 00       	mov    $0x0,%edx
f0101f8d:	89 f0                	mov    %esi,%eax
f0101f8f:	e8 7d eb ff ff       	call   f0100b11 <check_va2pa>
f0101f94:	83 c4 10             	add    $0x10,%esp
f0101f97:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101f9a:	0f 85 a8 08 00 00    	jne    f0102848 <mem_init+0x13eb>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101fa0:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101fa5:	89 f0                	mov    %esi,%eax
f0101fa7:	e8 65 eb ff ff       	call   f0100b11 <check_va2pa>
f0101fac:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101faf:	0f 85 b2 08 00 00    	jne    f0102867 <mem_init+0x140a>
	assert(pp1->pp_ref == 0);
f0101fb5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fb8:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101fbd:	0f 85 c3 08 00 00    	jne    f0102886 <mem_init+0x1429>
	assert(pp2->pp_ref == 0);
f0101fc3:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101fc6:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101fcb:	0f 85 d4 08 00 00    	jne    f01028a5 <mem_init+0x1448>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101fd1:	83 ec 0c             	sub    $0xc,%esp
f0101fd4:	6a 00                	push   $0x0
f0101fd6:	e8 84 f0 ff ff       	call   f010105f <page_alloc>
f0101fdb:	83 c4 10             	add    $0x10,%esp
f0101fde:	85 c0                	test   %eax,%eax
f0101fe0:	0f 84 de 08 00 00    	je     f01028c4 <mem_init+0x1467>
f0101fe6:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101fe9:	0f 85 d5 08 00 00    	jne    f01028c4 <mem_init+0x1467>

	// should be no free memory
	assert(!page_alloc(0));
f0101fef:	83 ec 0c             	sub    $0xc,%esp
f0101ff2:	6a 00                	push   $0x0
f0101ff4:	e8 66 f0 ff ff       	call   f010105f <page_alloc>
f0101ff9:	83 c4 10             	add    $0x10,%esp
f0101ffc:	85 c0                	test   %eax,%eax
f0101ffe:	0f 85 df 08 00 00    	jne    f01028e3 <mem_init+0x1486>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102004:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f010200a:	8b 08                	mov    (%eax),%ecx
f010200c:	8b 11                	mov    (%ecx),%edx
f010200e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102014:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f010201a:	8b 7d cc             	mov    -0x34(%ebp),%edi
f010201d:	2b 38                	sub    (%eax),%edi
f010201f:	89 f8                	mov    %edi,%eax
f0102021:	c1 f8 03             	sar    $0x3,%eax
f0102024:	c1 e0 0c             	shl    $0xc,%eax
f0102027:	39 c2                	cmp    %eax,%edx
f0102029:	0f 85 d3 08 00 00    	jne    f0102902 <mem_init+0x14a5>
	kern_pgdir[0] = 0;
f010202f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102035:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102038:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f010203d:	0f 85 de 08 00 00    	jne    f0102921 <mem_init+0x14c4>
	pp0->pp_ref = 0;
f0102043:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102046:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f010204c:	83 ec 0c             	sub    $0xc,%esp
f010204f:	50                   	push   %eax
f0102050:	e8 ad f0 ff ff       	call   f0101102 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102055:	83 c4 0c             	add    $0xc,%esp
f0102058:	6a 01                	push   $0x1
f010205a:	68 00 10 40 00       	push   $0x401000
f010205f:	c7 c6 cc a6 11 f0    	mov    $0xf011a6cc,%esi
f0102065:	ff 36                	pushl  (%esi)
f0102067:	e8 31 f1 ff ff       	call   f010119d <pgdir_walk>
f010206c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f010206f:	8b 3e                	mov    (%esi),%edi
f0102071:	8b 57 04             	mov    0x4(%edi),%edx
f0102074:	89 d1                	mov    %edx,%ecx
f0102076:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
	if (PGNUM(pa) >= npages)
f010207c:	c7 c6 c8 a6 11 f0    	mov    $0xf011a6c8,%esi
f0102082:	8b 36                	mov    (%esi),%esi
f0102084:	c1 ea 0c             	shr    $0xc,%edx
f0102087:	83 c4 10             	add    $0x10,%esp
f010208a:	39 f2                	cmp    %esi,%edx
f010208c:	0f 83 ae 08 00 00    	jae    f0102940 <mem_init+0x14e3>
	assert(ptep == ptep1 + PTX(va));
f0102092:	81 e9 fc ff ff 0f    	sub    $0xffffffc,%ecx
f0102098:	39 c8                	cmp    %ecx,%eax
f010209a:	0f 85 b9 08 00 00    	jne    f0102959 <mem_init+0x14fc>
	kern_pgdir[PDX(va)] = 0;
f01020a0:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
	pp0->pp_ref = 0;
f01020a7:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f01020aa:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
	return (pp - pages) << PGSHIFT;
f01020b0:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f01020b6:	2b 08                	sub    (%eax),%ecx
f01020b8:	89 c8                	mov    %ecx,%eax
f01020ba:	c1 f8 03             	sar    $0x3,%eax
f01020bd:	89 c2                	mov    %eax,%edx
f01020bf:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01020c2:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01020c7:	39 c6                	cmp    %eax,%esi
f01020c9:	0f 86 a9 08 00 00    	jbe    f0102978 <mem_init+0x151b>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f01020cf:	83 ec 04             	sub    $0x4,%esp
f01020d2:	68 00 10 00 00       	push   $0x1000
f01020d7:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f01020dc:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f01020e2:	52                   	push   %edx
f01020e3:	e8 f6 1b 00 00       	call   f0103cde <memset>
	page_free(pp0);
f01020e8:	8b 7d cc             	mov    -0x34(%ebp),%edi
f01020eb:	89 3c 24             	mov    %edi,(%esp)
f01020ee:	e8 0f f0 ff ff       	call   f0101102 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01020f3:	83 c4 0c             	add    $0xc,%esp
f01020f6:	6a 01                	push   $0x1
f01020f8:	6a 00                	push   $0x0
f01020fa:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0102100:	ff 30                	pushl  (%eax)
f0102102:	e8 96 f0 ff ff       	call   f010119d <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0102107:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f010210d:	2b 38                	sub    (%eax),%edi
f010210f:	89 f8                	mov    %edi,%eax
f0102111:	c1 f8 03             	sar    $0x3,%eax
f0102114:	89 c2                	mov    %eax,%edx
f0102116:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102119:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010211e:	83 c4 10             	add    $0x10,%esp
f0102121:	c7 c1 c8 a6 11 f0    	mov    $0xf011a6c8,%ecx
f0102127:	3b 01                	cmp    (%ecx),%eax
f0102129:	0f 83 5f 08 00 00    	jae    f010298e <mem_init+0x1531>
	return (void *)(pa + KERNBASE);
f010212f:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0102135:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102138:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f010213e:	8b 38                	mov    (%eax),%edi
f0102140:	83 e7 01             	and    $0x1,%edi
f0102143:	0f 85 5b 08 00 00    	jne    f01029a4 <mem_init+0x1547>
f0102149:	83 c0 04             	add    $0x4,%eax
	for(i=0; i<NPTENTRIES; i++)
f010214c:	39 d0                	cmp    %edx,%eax
f010214e:	75 ee                	jne    f010213e <mem_init+0xce1>
	kern_pgdir[0] = 0;
f0102150:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0102156:	8b 00                	mov    (%eax),%eax
f0102158:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f010215e:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102161:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102167:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010216a:	89 8b 94 1f 00 00    	mov    %ecx,0x1f94(%ebx)

	// free the pages we took
	page_free(pp0);
f0102170:	83 ec 0c             	sub    $0xc,%esp
f0102173:	50                   	push   %eax
f0102174:	e8 89 ef ff ff       	call   f0101102 <page_free>
	page_free(pp1);
f0102179:	83 c4 04             	add    $0x4,%esp
f010217c:	ff 75 d4             	pushl  -0x2c(%ebp)
f010217f:	e8 7e ef ff ff       	call   f0101102 <page_free>
	page_free(pp2);
f0102184:	83 c4 04             	add    $0x4,%esp
f0102187:	ff 75 d0             	pushl  -0x30(%ebp)
f010218a:	e8 73 ef ff ff       	call   f0101102 <page_free>

	cprintf("check_page() succeeded!\n");
f010218f:	8d 83 9f cd fe ff    	lea    -0x13261(%ebx),%eax
f0102195:	89 04 24             	mov    %eax,(%esp)
f0102198:	e8 fc 0e 00 00       	call   f0103099 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f010219d:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f01021a3:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01021a5:	83 c4 10             	add    $0x10,%esp
f01021a8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021ad:	0f 86 10 08 00 00    	jbe    f01029c3 <mem_init+0x1566>
f01021b3:	83 ec 08             	sub    $0x8,%esp
f01021b6:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01021b8:	05 00 00 00 10       	add    $0x10000000,%eax
f01021bd:	50                   	push   %eax
f01021be:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01021c3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01021c8:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f01021ce:	8b 00                	mov    (%eax),%eax
f01021d0:	e8 d1 f0 ff ff       	call   f01012a6 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f01021d5:	c7 c0 00 f0 10 f0    	mov    $0xf010f000,%eax
f01021db:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01021de:	83 c4 10             	add    $0x10,%esp
f01021e1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021e6:	0f 86 f0 07 00 00    	jbe    f01029dc <mem_init+0x157f>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f01021ec:	c7 c6 cc a6 11 f0    	mov    $0xf011a6cc,%esi
f01021f2:	83 ec 08             	sub    $0x8,%esp
f01021f5:	6a 02                	push   $0x2
	return (physaddr_t)kva - KERNBASE;
f01021f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01021fa:	05 00 00 00 10       	add    $0x10000000,%eax
f01021ff:	50                   	push   %eax
f0102200:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102205:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f010220a:	8b 06                	mov    (%esi),%eax
f010220c:	e8 95 f0 ff ff       	call   f01012a6 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0xffffffff - KERNBASE, 0, PTE_W);
f0102211:	83 c4 08             	add    $0x8,%esp
f0102214:	6a 02                	push   $0x2
f0102216:	6a 00                	push   $0x0
f0102218:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f010221d:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102222:	8b 06                	mov    (%esi),%eax
f0102224:	e8 7d f0 ff ff       	call   f01012a6 <boot_map_region>
	pgdir = kern_pgdir;
f0102229:	8b 06                	mov    (%esi),%eax
f010222b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f010222e:	c7 c0 c8 a6 11 f0    	mov    $0xf011a6c8,%eax
f0102234:	8b 00                	mov    (%eax),%eax
f0102236:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0102239:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102240:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102245:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102248:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f010224e:	8b 00                	mov    (%eax),%eax
f0102250:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102253:	89 45 c8             	mov    %eax,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f0102256:	05 00 00 00 10       	add    $0x10000000,%eax
f010225b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f010225e:	83 c4 10             	add    $0x10,%esp
f0102261:	89 fe                	mov    %edi,%esi
f0102263:	39 75 cc             	cmp    %esi,-0x34(%ebp)
f0102266:	0f 86 c3 07 00 00    	jbe    f0102a2f <mem_init+0x15d2>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010226c:	8d 96 00 00 00 ef    	lea    -0x11000000(%esi),%edx
f0102272:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102275:	e8 97 e8 ff ff       	call   f0100b11 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f010227a:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f0102281:	0f 86 6e 07 00 00    	jbe    f01029f5 <mem_init+0x1598>
f0102287:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f010228a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010228d:	39 d0                	cmp    %edx,%eax
f010228f:	0f 85 7b 07 00 00    	jne    f0102a10 <mem_init+0x15b3>
	for (i = 0; i < n; i += PGSIZE)
f0102295:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010229b:	eb c6                	jmp    f0102263 <mem_init+0xe06>
	assert(nfree == 0);
f010229d:	8d 83 c8 cc fe ff    	lea    -0x13338(%ebx),%eax
f01022a3:	50                   	push   %eax
f01022a4:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01022aa:	50                   	push   %eax
f01022ab:	68 ec 02 00 00       	push   $0x2ec
f01022b0:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01022b6:	50                   	push   %eax
f01022b7:	e8 e1 dd ff ff       	call   f010009d <_panic>
	assert((pp0 = page_alloc(0)));
f01022bc:	8d 83 d6 cb fe ff    	lea    -0x1342a(%ebx),%eax
f01022c2:	50                   	push   %eax
f01022c3:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01022c9:	50                   	push   %eax
f01022ca:	68 45 03 00 00       	push   $0x345
f01022cf:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01022d5:	50                   	push   %eax
f01022d6:	e8 c2 dd ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f01022db:	8d 83 ec cb fe ff    	lea    -0x13414(%ebx),%eax
f01022e1:	50                   	push   %eax
f01022e2:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01022e8:	50                   	push   %eax
f01022e9:	68 46 03 00 00       	push   $0x346
f01022ee:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01022f4:	50                   	push   %eax
f01022f5:	e8 a3 dd ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f01022fa:	8d 83 02 cc fe ff    	lea    -0x133fe(%ebx),%eax
f0102300:	50                   	push   %eax
f0102301:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102307:	50                   	push   %eax
f0102308:	68 47 03 00 00       	push   $0x347
f010230d:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102313:	50                   	push   %eax
f0102314:	e8 84 dd ff ff       	call   f010009d <_panic>
	assert(pp1 && pp1 != pp0);
f0102319:	8d 83 18 cc fe ff    	lea    -0x133e8(%ebx),%eax
f010231f:	50                   	push   %eax
f0102320:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102326:	50                   	push   %eax
f0102327:	68 4a 03 00 00       	push   $0x34a
f010232c:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102332:	50                   	push   %eax
f0102333:	e8 65 dd ff ff       	call   f010009d <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102338:	8d 83 1c c5 fe ff    	lea    -0x13ae4(%ebx),%eax
f010233e:	50                   	push   %eax
f010233f:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102345:	50                   	push   %eax
f0102346:	68 4b 03 00 00       	push   $0x34b
f010234b:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102351:	50                   	push   %eax
f0102352:	e8 46 dd ff ff       	call   f010009d <_panic>
	assert(!page_alloc(0));
f0102357:	8d 83 81 cc fe ff    	lea    -0x1337f(%ebx),%eax
f010235d:	50                   	push   %eax
f010235e:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102364:	50                   	push   %eax
f0102365:	68 52 03 00 00       	push   $0x352
f010236a:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102370:	50                   	push   %eax
f0102371:	e8 27 dd ff ff       	call   f010009d <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102376:	8d 83 5c c5 fe ff    	lea    -0x13aa4(%ebx),%eax
f010237c:	50                   	push   %eax
f010237d:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102383:	50                   	push   %eax
f0102384:	68 55 03 00 00       	push   $0x355
f0102389:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010238f:	50                   	push   %eax
f0102390:	e8 08 dd ff ff       	call   f010009d <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102395:	8d 83 94 c5 fe ff    	lea    -0x13a6c(%ebx),%eax
f010239b:	50                   	push   %eax
f010239c:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01023a2:	50                   	push   %eax
f01023a3:	68 58 03 00 00       	push   $0x358
f01023a8:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01023ae:	50                   	push   %eax
f01023af:	e8 e9 dc ff ff       	call   f010009d <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01023b4:	8d 83 c4 c5 fe ff    	lea    -0x13a3c(%ebx),%eax
f01023ba:	50                   	push   %eax
f01023bb:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01023c1:	50                   	push   %eax
f01023c2:	68 5c 03 00 00       	push   $0x35c
f01023c7:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01023cd:	50                   	push   %eax
f01023ce:	e8 ca dc ff ff       	call   f010009d <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01023d3:	8d 83 f4 c5 fe ff    	lea    -0x13a0c(%ebx),%eax
f01023d9:	50                   	push   %eax
f01023da:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01023e0:	50                   	push   %eax
f01023e1:	68 5d 03 00 00       	push   $0x35d
f01023e6:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01023ec:	50                   	push   %eax
f01023ed:	e8 ab dc ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01023f2:	8d 83 1c c6 fe ff    	lea    -0x139e4(%ebx),%eax
f01023f8:	50                   	push   %eax
f01023f9:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01023ff:	50                   	push   %eax
f0102400:	68 5e 03 00 00       	push   $0x35e
f0102405:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010240b:	50                   	push   %eax
f010240c:	e8 8c dc ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 1);
f0102411:	8d 83 d3 cc fe ff    	lea    -0x1332d(%ebx),%eax
f0102417:	50                   	push   %eax
f0102418:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010241e:	50                   	push   %eax
f010241f:	68 5f 03 00 00       	push   $0x35f
f0102424:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010242a:	50                   	push   %eax
f010242b:	e8 6d dc ff ff       	call   f010009d <_panic>
	assert(pp0->pp_ref == 1);
f0102430:	8d 83 e4 cc fe ff    	lea    -0x1331c(%ebx),%eax
f0102436:	50                   	push   %eax
f0102437:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010243d:	50                   	push   %eax
f010243e:	68 60 03 00 00       	push   $0x360
f0102443:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102449:	50                   	push   %eax
f010244a:	e8 4e dc ff ff       	call   f010009d <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010244f:	8d 83 4c c6 fe ff    	lea    -0x139b4(%ebx),%eax
f0102455:	50                   	push   %eax
f0102456:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010245c:	50                   	push   %eax
f010245d:	68 63 03 00 00       	push   $0x363
f0102462:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102468:	50                   	push   %eax
f0102469:	e8 2f dc ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010246e:	8d 83 88 c6 fe ff    	lea    -0x13978(%ebx),%eax
f0102474:	50                   	push   %eax
f0102475:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010247b:	50                   	push   %eax
f010247c:	68 64 03 00 00       	push   $0x364
f0102481:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102487:	50                   	push   %eax
f0102488:	e8 10 dc ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f010248d:	8d 83 f5 cc fe ff    	lea    -0x1330b(%ebx),%eax
f0102493:	50                   	push   %eax
f0102494:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010249a:	50                   	push   %eax
f010249b:	68 65 03 00 00       	push   $0x365
f01024a0:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01024a6:	50                   	push   %eax
f01024a7:	e8 f1 db ff ff       	call   f010009d <_panic>
	assert(!page_alloc(0));
f01024ac:	8d 83 81 cc fe ff    	lea    -0x1337f(%ebx),%eax
f01024b2:	50                   	push   %eax
f01024b3:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01024b9:	50                   	push   %eax
f01024ba:	68 68 03 00 00       	push   $0x368
f01024bf:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01024c5:	50                   	push   %eax
f01024c6:	e8 d2 db ff ff       	call   f010009d <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01024cb:	8d 83 4c c6 fe ff    	lea    -0x139b4(%ebx),%eax
f01024d1:	50                   	push   %eax
f01024d2:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01024d8:	50                   	push   %eax
f01024d9:	68 6b 03 00 00       	push   $0x36b
f01024de:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01024e4:	50                   	push   %eax
f01024e5:	e8 b3 db ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01024ea:	8d 83 88 c6 fe ff    	lea    -0x13978(%ebx),%eax
f01024f0:	50                   	push   %eax
f01024f1:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01024f7:	50                   	push   %eax
f01024f8:	68 6c 03 00 00       	push   $0x36c
f01024fd:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102503:	50                   	push   %eax
f0102504:	e8 94 db ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f0102509:	8d 83 f5 cc fe ff    	lea    -0x1330b(%ebx),%eax
f010250f:	50                   	push   %eax
f0102510:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102516:	50                   	push   %eax
f0102517:	68 6d 03 00 00       	push   $0x36d
f010251c:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102522:	50                   	push   %eax
f0102523:	e8 75 db ff ff       	call   f010009d <_panic>
	assert(!page_alloc(0));
f0102528:	8d 83 81 cc fe ff    	lea    -0x1337f(%ebx),%eax
f010252e:	50                   	push   %eax
f010252f:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102535:	50                   	push   %eax
f0102536:	68 71 03 00 00       	push   $0x371
f010253b:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102541:	50                   	push   %eax
f0102542:	e8 56 db ff ff       	call   f010009d <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102547:	52                   	push   %edx
f0102548:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f010254e:	50                   	push   %eax
f010254f:	68 74 03 00 00       	push   $0x374
f0102554:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010255a:	50                   	push   %eax
f010255b:	e8 3d db ff ff       	call   f010009d <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102560:	8d 83 b8 c6 fe ff    	lea    -0x13948(%ebx),%eax
f0102566:	50                   	push   %eax
f0102567:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010256d:	50                   	push   %eax
f010256e:	68 75 03 00 00       	push   $0x375
f0102573:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102579:	50                   	push   %eax
f010257a:	e8 1e db ff ff       	call   f010009d <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f010257f:	8d 83 f8 c6 fe ff    	lea    -0x13908(%ebx),%eax
f0102585:	50                   	push   %eax
f0102586:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010258c:	50                   	push   %eax
f010258d:	68 78 03 00 00       	push   $0x378
f0102592:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102598:	50                   	push   %eax
f0102599:	e8 ff da ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010259e:	8d 83 88 c6 fe ff    	lea    -0x13978(%ebx),%eax
f01025a4:	50                   	push   %eax
f01025a5:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01025ab:	50                   	push   %eax
f01025ac:	68 79 03 00 00       	push   $0x379
f01025b1:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01025b7:	50                   	push   %eax
f01025b8:	e8 e0 da ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f01025bd:	8d 83 f5 cc fe ff    	lea    -0x1330b(%ebx),%eax
f01025c3:	50                   	push   %eax
f01025c4:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01025ca:	50                   	push   %eax
f01025cb:	68 7a 03 00 00       	push   $0x37a
f01025d0:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01025d6:	50                   	push   %eax
f01025d7:	e8 c1 da ff ff       	call   f010009d <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01025dc:	8d 83 38 c7 fe ff    	lea    -0x138c8(%ebx),%eax
f01025e2:	50                   	push   %eax
f01025e3:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01025e9:	50                   	push   %eax
f01025ea:	68 7b 03 00 00       	push   $0x37b
f01025ef:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01025f5:	50                   	push   %eax
f01025f6:	e8 a2 da ff ff       	call   f010009d <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01025fb:	8d 83 06 cd fe ff    	lea    -0x132fa(%ebx),%eax
f0102601:	50                   	push   %eax
f0102602:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102608:	50                   	push   %eax
f0102609:	68 7c 03 00 00       	push   $0x37c
f010260e:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102614:	50                   	push   %eax
f0102615:	e8 83 da ff ff       	call   f010009d <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010261a:	8d 83 4c c6 fe ff    	lea    -0x139b4(%ebx),%eax
f0102620:	50                   	push   %eax
f0102621:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102627:	50                   	push   %eax
f0102628:	68 7f 03 00 00       	push   $0x37f
f010262d:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102633:	50                   	push   %eax
f0102634:	e8 64 da ff ff       	call   f010009d <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102639:	8d 83 6c c7 fe ff    	lea    -0x13894(%ebx),%eax
f010263f:	50                   	push   %eax
f0102640:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102646:	50                   	push   %eax
f0102647:	68 80 03 00 00       	push   $0x380
f010264c:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102652:	50                   	push   %eax
f0102653:	e8 45 da ff ff       	call   f010009d <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102658:	8d 83 a0 c7 fe ff    	lea    -0x13860(%ebx),%eax
f010265e:	50                   	push   %eax
f010265f:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102665:	50                   	push   %eax
f0102666:	68 81 03 00 00       	push   $0x381
f010266b:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102671:	50                   	push   %eax
f0102672:	e8 26 da ff ff       	call   f010009d <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102677:	8d 83 d8 c7 fe ff    	lea    -0x13828(%ebx),%eax
f010267d:	50                   	push   %eax
f010267e:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102684:	50                   	push   %eax
f0102685:	68 84 03 00 00       	push   $0x384
f010268a:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102690:	50                   	push   %eax
f0102691:	e8 07 da ff ff       	call   f010009d <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102696:	8d 83 10 c8 fe ff    	lea    -0x137f0(%ebx),%eax
f010269c:	50                   	push   %eax
f010269d:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01026a3:	50                   	push   %eax
f01026a4:	68 87 03 00 00       	push   $0x387
f01026a9:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01026af:	50                   	push   %eax
f01026b0:	e8 e8 d9 ff ff       	call   f010009d <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01026b5:	8d 83 a0 c7 fe ff    	lea    -0x13860(%ebx),%eax
f01026bb:	50                   	push   %eax
f01026bc:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01026c2:	50                   	push   %eax
f01026c3:	68 88 03 00 00       	push   $0x388
f01026c8:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01026ce:	50                   	push   %eax
f01026cf:	e8 c9 d9 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01026d4:	8d 83 4c c8 fe ff    	lea    -0x137b4(%ebx),%eax
f01026da:	50                   	push   %eax
f01026db:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01026e1:	50                   	push   %eax
f01026e2:	68 8b 03 00 00       	push   $0x38b
f01026e7:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01026ed:	50                   	push   %eax
f01026ee:	e8 aa d9 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01026f3:	8d 83 78 c8 fe ff    	lea    -0x13788(%ebx),%eax
f01026f9:	50                   	push   %eax
f01026fa:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102700:	50                   	push   %eax
f0102701:	68 8c 03 00 00       	push   $0x38c
f0102706:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010270c:	50                   	push   %eax
f010270d:	e8 8b d9 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 2);
f0102712:	8d 83 1c cd fe ff    	lea    -0x132e4(%ebx),%eax
f0102718:	50                   	push   %eax
f0102719:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010271f:	50                   	push   %eax
f0102720:	68 8e 03 00 00       	push   $0x38e
f0102725:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010272b:	50                   	push   %eax
f010272c:	e8 6c d9 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 0);
f0102731:	8d 83 2d cd fe ff    	lea    -0x132d3(%ebx),%eax
f0102737:	50                   	push   %eax
f0102738:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010273e:	50                   	push   %eax
f010273f:	68 8f 03 00 00       	push   $0x38f
f0102744:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010274a:	50                   	push   %eax
f010274b:	e8 4d d9 ff ff       	call   f010009d <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102750:	8d 83 a8 c8 fe ff    	lea    -0x13758(%ebx),%eax
f0102756:	50                   	push   %eax
f0102757:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010275d:	50                   	push   %eax
f010275e:	68 92 03 00 00       	push   $0x392
f0102763:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102769:	50                   	push   %eax
f010276a:	e8 2e d9 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010276f:	8d 83 cc c8 fe ff    	lea    -0x13734(%ebx),%eax
f0102775:	50                   	push   %eax
f0102776:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010277c:	50                   	push   %eax
f010277d:	68 96 03 00 00       	push   $0x396
f0102782:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102788:	50                   	push   %eax
f0102789:	e8 0f d9 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010278e:	8d 83 78 c8 fe ff    	lea    -0x13788(%ebx),%eax
f0102794:	50                   	push   %eax
f0102795:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010279b:	50                   	push   %eax
f010279c:	68 97 03 00 00       	push   $0x397
f01027a1:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01027a7:	50                   	push   %eax
f01027a8:	e8 f0 d8 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 1);
f01027ad:	8d 83 d3 cc fe ff    	lea    -0x1332d(%ebx),%eax
f01027b3:	50                   	push   %eax
f01027b4:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01027ba:	50                   	push   %eax
f01027bb:	68 98 03 00 00       	push   $0x398
f01027c0:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01027c6:	50                   	push   %eax
f01027c7:	e8 d1 d8 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 0);
f01027cc:	8d 83 2d cd fe ff    	lea    -0x132d3(%ebx),%eax
f01027d2:	50                   	push   %eax
f01027d3:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01027d9:	50                   	push   %eax
f01027da:	68 99 03 00 00       	push   $0x399
f01027df:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01027e5:	50                   	push   %eax
f01027e6:	e8 b2 d8 ff ff       	call   f010009d <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01027eb:	8d 83 f0 c8 fe ff    	lea    -0x13710(%ebx),%eax
f01027f1:	50                   	push   %eax
f01027f2:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01027f8:	50                   	push   %eax
f01027f9:	68 9c 03 00 00       	push   $0x39c
f01027fe:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102804:	50                   	push   %eax
f0102805:	e8 93 d8 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref);
f010280a:	8d 83 3e cd fe ff    	lea    -0x132c2(%ebx),%eax
f0102810:	50                   	push   %eax
f0102811:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102817:	50                   	push   %eax
f0102818:	68 9d 03 00 00       	push   $0x39d
f010281d:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102823:	50                   	push   %eax
f0102824:	e8 74 d8 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_link == NULL);
f0102829:	8d 83 4a cd fe ff    	lea    -0x132b6(%ebx),%eax
f010282f:	50                   	push   %eax
f0102830:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102836:	50                   	push   %eax
f0102837:	68 9e 03 00 00       	push   $0x39e
f010283c:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102842:	50                   	push   %eax
f0102843:	e8 55 d8 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102848:	8d 83 cc c8 fe ff    	lea    -0x13734(%ebx),%eax
f010284e:	50                   	push   %eax
f010284f:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102855:	50                   	push   %eax
f0102856:	68 a2 03 00 00       	push   $0x3a2
f010285b:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102861:	50                   	push   %eax
f0102862:	e8 36 d8 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102867:	8d 83 28 c9 fe ff    	lea    -0x136d8(%ebx),%eax
f010286d:	50                   	push   %eax
f010286e:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102874:	50                   	push   %eax
f0102875:	68 a3 03 00 00       	push   $0x3a3
f010287a:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102880:	50                   	push   %eax
f0102881:	e8 17 d8 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 0);
f0102886:	8d 83 5f cd fe ff    	lea    -0x132a1(%ebx),%eax
f010288c:	50                   	push   %eax
f010288d:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102893:	50                   	push   %eax
f0102894:	68 a4 03 00 00       	push   $0x3a4
f0102899:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010289f:	50                   	push   %eax
f01028a0:	e8 f8 d7 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 0);
f01028a5:	8d 83 2d cd fe ff    	lea    -0x132d3(%ebx),%eax
f01028ab:	50                   	push   %eax
f01028ac:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01028b2:	50                   	push   %eax
f01028b3:	68 a5 03 00 00       	push   $0x3a5
f01028b8:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01028be:	50                   	push   %eax
f01028bf:	e8 d9 d7 ff ff       	call   f010009d <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f01028c4:	8d 83 50 c9 fe ff    	lea    -0x136b0(%ebx),%eax
f01028ca:	50                   	push   %eax
f01028cb:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01028d1:	50                   	push   %eax
f01028d2:	68 a8 03 00 00       	push   $0x3a8
f01028d7:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01028dd:	50                   	push   %eax
f01028de:	e8 ba d7 ff ff       	call   f010009d <_panic>
	assert(!page_alloc(0));
f01028e3:	8d 83 81 cc fe ff    	lea    -0x1337f(%ebx),%eax
f01028e9:	50                   	push   %eax
f01028ea:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01028f0:	50                   	push   %eax
f01028f1:	68 ab 03 00 00       	push   $0x3ab
f01028f6:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01028fc:	50                   	push   %eax
f01028fd:	e8 9b d7 ff ff       	call   f010009d <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102902:	8d 83 f4 c5 fe ff    	lea    -0x13a0c(%ebx),%eax
f0102908:	50                   	push   %eax
f0102909:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010290f:	50                   	push   %eax
f0102910:	68 ae 03 00 00       	push   $0x3ae
f0102915:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010291b:	50                   	push   %eax
f010291c:	e8 7c d7 ff ff       	call   f010009d <_panic>
	assert(pp0->pp_ref == 1);
f0102921:	8d 83 e4 cc fe ff    	lea    -0x1331c(%ebx),%eax
f0102927:	50                   	push   %eax
f0102928:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f010292e:	50                   	push   %eax
f010292f:	68 b0 03 00 00       	push   $0x3b0
f0102934:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f010293a:	50                   	push   %eax
f010293b:	e8 5d d7 ff ff       	call   f010009d <_panic>
f0102940:	51                   	push   %ecx
f0102941:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f0102947:	50                   	push   %eax
f0102948:	68 b7 03 00 00       	push   $0x3b7
f010294d:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102953:	50                   	push   %eax
f0102954:	e8 44 d7 ff ff       	call   f010009d <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102959:	8d 83 70 cd fe ff    	lea    -0x13290(%ebx),%eax
f010295f:	50                   	push   %eax
f0102960:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102966:	50                   	push   %eax
f0102967:	68 b8 03 00 00       	push   $0x3b8
f010296c:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102972:	50                   	push   %eax
f0102973:	e8 25 d7 ff ff       	call   f010009d <_panic>
f0102978:	52                   	push   %edx
f0102979:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f010297f:	50                   	push   %eax
f0102980:	6a 52                	push   $0x52
f0102982:	8d 83 11 cb fe ff    	lea    -0x134ef(%ebx),%eax
f0102988:	50                   	push   %eax
f0102989:	e8 0f d7 ff ff       	call   f010009d <_panic>
f010298e:	52                   	push   %edx
f010298f:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f0102995:	50                   	push   %eax
f0102996:	6a 52                	push   $0x52
f0102998:	8d 83 11 cb fe ff    	lea    -0x134ef(%ebx),%eax
f010299e:	50                   	push   %eax
f010299f:	e8 f9 d6 ff ff       	call   f010009d <_panic>
		assert((ptep[i] & PTE_P) == 0);
f01029a4:	8d 83 88 cd fe ff    	lea    -0x13278(%ebx),%eax
f01029aa:	50                   	push   %eax
f01029ab:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f01029b1:	50                   	push   %eax
f01029b2:	68 c2 03 00 00       	push   $0x3c2
f01029b7:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01029bd:	50                   	push   %eax
f01029be:	e8 da d6 ff ff       	call   f010009d <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01029c3:	50                   	push   %eax
f01029c4:	8d 83 38 c4 fe ff    	lea    -0x13bc8(%ebx),%eax
f01029ca:	50                   	push   %eax
f01029cb:	68 bd 00 00 00       	push   $0xbd
f01029d0:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01029d6:	50                   	push   %eax
f01029d7:	e8 c1 d6 ff ff       	call   f010009d <_panic>
f01029dc:	50                   	push   %eax
f01029dd:	8d 83 38 c4 fe ff    	lea    -0x13bc8(%ebx),%eax
f01029e3:	50                   	push   %eax
f01029e4:	68 ca 00 00 00       	push   $0xca
f01029e9:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f01029ef:	50                   	push   %eax
f01029f0:	e8 a8 d6 ff ff       	call   f010009d <_panic>
f01029f5:	ff 75 bc             	pushl  -0x44(%ebp)
f01029f8:	8d 83 38 c4 fe ff    	lea    -0x13bc8(%ebx),%eax
f01029fe:	50                   	push   %eax
f01029ff:	68 04 03 00 00       	push   $0x304
f0102a04:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102a0a:	50                   	push   %eax
f0102a0b:	e8 8d d6 ff ff       	call   f010009d <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102a10:	8d 83 74 c9 fe ff    	lea    -0x1368c(%ebx),%eax
f0102a16:	50                   	push   %eax
f0102a17:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102a1d:	50                   	push   %eax
f0102a1e:	68 04 03 00 00       	push   $0x304
f0102a23:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102a29:	50                   	push   %eax
f0102a2a:	e8 6e d6 ff ff       	call   f010009d <_panic>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102a2f:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0102a32:	c1 e0 0c             	shl    $0xc,%eax
f0102a35:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102a38:	89 fe                	mov    %edi,%esi
f0102a3a:	3b 75 cc             	cmp    -0x34(%ebp),%esi
f0102a3d:	73 39                	jae    f0102a78 <mem_init+0x161b>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102a3f:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
f0102a45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a48:	e8 c4 e0 ff ff       	call   f0100b11 <check_va2pa>
f0102a4d:	39 c6                	cmp    %eax,%esi
f0102a4f:	75 08                	jne    f0102a59 <mem_init+0x15fc>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102a51:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0102a57:	eb e1                	jmp    f0102a3a <mem_init+0x15dd>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102a59:	8d 83 a8 c9 fe ff    	lea    -0x13658(%ebx),%eax
f0102a5f:	50                   	push   %eax
f0102a60:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102a66:	50                   	push   %eax
f0102a67:	68 09 03 00 00       	push   $0x309
f0102a6c:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102a72:	50                   	push   %eax
f0102a73:	e8 25 d6 ff ff       	call   f010009d <_panic>
f0102a78:	be 00 80 ff ef       	mov    $0xefff8000,%esi
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0102a7d:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102a80:	05 00 80 00 20       	add    $0x20008000,%eax
f0102a85:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102a88:	89 f2                	mov    %esi,%edx
f0102a8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a8d:	e8 7f e0 ff ff       	call   f0100b11 <check_va2pa>
f0102a92:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0102a95:	8d 14 31             	lea    (%ecx,%esi,1),%edx
f0102a98:	39 c2                	cmp    %eax,%edx
f0102a9a:	75 25                	jne    f0102ac1 <mem_init+0x1664>
f0102a9c:	81 c6 00 10 00 00    	add    $0x1000,%esi
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102aa2:	81 fe 00 00 00 f0    	cmp    $0xf0000000,%esi
f0102aa8:	75 de                	jne    f0102a88 <mem_init+0x162b>
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0102aaa:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f0102aaf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102ab2:	e8 5a e0 ff ff       	call   f0100b11 <check_va2pa>
f0102ab7:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102aba:	75 24                	jne    f0102ae0 <mem_init+0x1683>
f0102abc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102abf:	eb 6b                	jmp    f0102b2c <mem_init+0x16cf>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0102ac1:	8d 83 d0 c9 fe ff    	lea    -0x13630(%ebx),%eax
f0102ac7:	50                   	push   %eax
f0102ac8:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102ace:	50                   	push   %eax
f0102acf:	68 0d 03 00 00       	push   $0x30d
f0102ad4:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102ada:	50                   	push   %eax
f0102adb:	e8 bd d5 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0102ae0:	8d 83 18 ca fe ff    	lea    -0x135e8(%ebx),%eax
f0102ae6:	50                   	push   %eax
f0102ae7:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102aed:	50                   	push   %eax
f0102aee:	68 0e 03 00 00       	push   $0x30e
f0102af3:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102af9:	50                   	push   %eax
f0102afa:	e8 9e d5 ff ff       	call   f010009d <_panic>
		switch (i) {
f0102aff:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102b05:	75 25                	jne    f0102b2c <mem_init+0x16cf>
			assert(pgdir[i] & PTE_P);
f0102b07:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102b0b:	74 4c                	je     f0102b59 <mem_init+0x16fc>
	for (i = 0; i < NPDENTRIES; i++) {
f0102b0d:	83 c7 01             	add    $0x1,%edi
f0102b10:	81 ff ff 03 00 00    	cmp    $0x3ff,%edi
f0102b16:	0f 87 a7 00 00 00    	ja     f0102bc3 <mem_init+0x1766>
		switch (i) {
f0102b1c:	81 ff bd 03 00 00    	cmp    $0x3bd,%edi
f0102b22:	77 db                	ja     f0102aff <mem_init+0x16a2>
f0102b24:	81 ff bb 03 00 00    	cmp    $0x3bb,%edi
f0102b2a:	77 db                	ja     f0102b07 <mem_init+0x16aa>
			if (i >= PDX(KERNBASE)) {
f0102b2c:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102b32:	77 44                	ja     f0102b78 <mem_init+0x171b>
				assert(pgdir[i] == 0);
f0102b34:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102b38:	74 d3                	je     f0102b0d <mem_init+0x16b0>
f0102b3a:	8d 83 da cd fe ff    	lea    -0x13226(%ebx),%eax
f0102b40:	50                   	push   %eax
f0102b41:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102b47:	50                   	push   %eax
f0102b48:	68 1d 03 00 00       	push   $0x31d
f0102b4d:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102b53:	50                   	push   %eax
f0102b54:	e8 44 d5 ff ff       	call   f010009d <_panic>
			assert(pgdir[i] & PTE_P);
f0102b59:	8d 83 b8 cd fe ff    	lea    -0x13248(%ebx),%eax
f0102b5f:	50                   	push   %eax
f0102b60:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102b66:	50                   	push   %eax
f0102b67:	68 16 03 00 00       	push   $0x316
f0102b6c:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102b72:	50                   	push   %eax
f0102b73:	e8 25 d5 ff ff       	call   f010009d <_panic>
				assert(pgdir[i] & PTE_P);
f0102b78:	8b 14 b8             	mov    (%eax,%edi,4),%edx
f0102b7b:	f6 c2 01             	test   $0x1,%dl
f0102b7e:	74 24                	je     f0102ba4 <mem_init+0x1747>
				assert(pgdir[i] & PTE_W);
f0102b80:	f6 c2 02             	test   $0x2,%dl
f0102b83:	75 88                	jne    f0102b0d <mem_init+0x16b0>
f0102b85:	8d 83 c9 cd fe ff    	lea    -0x13237(%ebx),%eax
f0102b8b:	50                   	push   %eax
f0102b8c:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102b92:	50                   	push   %eax
f0102b93:	68 1b 03 00 00       	push   $0x31b
f0102b98:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102b9e:	50                   	push   %eax
f0102b9f:	e8 f9 d4 ff ff       	call   f010009d <_panic>
				assert(pgdir[i] & PTE_P);
f0102ba4:	8d 83 b8 cd fe ff    	lea    -0x13248(%ebx),%eax
f0102baa:	50                   	push   %eax
f0102bab:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102bb1:	50                   	push   %eax
f0102bb2:	68 1a 03 00 00       	push   $0x31a
f0102bb7:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102bbd:	50                   	push   %eax
f0102bbe:	e8 da d4 ff ff       	call   f010009d <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102bc3:	83 ec 0c             	sub    $0xc,%esp
f0102bc6:	8d 83 48 ca fe ff    	lea    -0x135b8(%ebx),%eax
f0102bcc:	50                   	push   %eax
f0102bcd:	e8 c7 04 00 00       	call   f0103099 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102bd2:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0102bd8:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0102bda:	83 c4 10             	add    $0x10,%esp
f0102bdd:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102be2:	0f 86 30 02 00 00    	jbe    f0102e18 <mem_init+0x19bb>
	return (physaddr_t)kva - KERNBASE;
f0102be8:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102bed:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102bf0:	b8 00 00 00 00       	mov    $0x0,%eax
f0102bf5:	e8 93 df ff ff       	call   f0100b8d <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102bfa:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102bfd:	83 e0 f3             	and    $0xfffffff3,%eax
f0102c00:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102c05:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102c08:	83 ec 0c             	sub    $0xc,%esp
f0102c0b:	6a 00                	push   $0x0
f0102c0d:	e8 4d e4 ff ff       	call   f010105f <page_alloc>
f0102c12:	89 c7                	mov    %eax,%edi
f0102c14:	83 c4 10             	add    $0x10,%esp
f0102c17:	85 c0                	test   %eax,%eax
f0102c19:	0f 84 12 02 00 00    	je     f0102e31 <mem_init+0x19d4>
	assert((pp1 = page_alloc(0)));
f0102c1f:	83 ec 0c             	sub    $0xc,%esp
f0102c22:	6a 00                	push   $0x0
f0102c24:	e8 36 e4 ff ff       	call   f010105f <page_alloc>
f0102c29:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102c2c:	83 c4 10             	add    $0x10,%esp
f0102c2f:	85 c0                	test   %eax,%eax
f0102c31:	0f 84 19 02 00 00    	je     f0102e50 <mem_init+0x19f3>
	assert((pp2 = page_alloc(0)));
f0102c37:	83 ec 0c             	sub    $0xc,%esp
f0102c3a:	6a 00                	push   $0x0
f0102c3c:	e8 1e e4 ff ff       	call   f010105f <page_alloc>
f0102c41:	89 c6                	mov    %eax,%esi
f0102c43:	83 c4 10             	add    $0x10,%esp
f0102c46:	85 c0                	test   %eax,%eax
f0102c48:	0f 84 21 02 00 00    	je     f0102e6f <mem_init+0x1a12>
	page_free(pp0);
f0102c4e:	83 ec 0c             	sub    $0xc,%esp
f0102c51:	57                   	push   %edi
f0102c52:	e8 ab e4 ff ff       	call   f0101102 <page_free>
	return (pp - pages) << PGSHIFT;
f0102c57:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0102c5d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102c60:	2b 08                	sub    (%eax),%ecx
f0102c62:	89 c8                	mov    %ecx,%eax
f0102c64:	c1 f8 03             	sar    $0x3,%eax
f0102c67:	89 c2                	mov    %eax,%edx
f0102c69:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102c6c:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102c71:	83 c4 10             	add    $0x10,%esp
f0102c74:	c7 c1 c8 a6 11 f0    	mov    $0xf011a6c8,%ecx
f0102c7a:	3b 01                	cmp    (%ecx),%eax
f0102c7c:	0f 83 0c 02 00 00    	jae    f0102e8e <mem_init+0x1a31>
	memset(page2kva(pp1), 1, PGSIZE);
f0102c82:	83 ec 04             	sub    $0x4,%esp
f0102c85:	68 00 10 00 00       	push   $0x1000
f0102c8a:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102c8c:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102c92:	52                   	push   %edx
f0102c93:	e8 46 10 00 00       	call   f0103cde <memset>
	return (pp - pages) << PGSHIFT;
f0102c98:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0102c9e:	89 f1                	mov    %esi,%ecx
f0102ca0:	2b 08                	sub    (%eax),%ecx
f0102ca2:	89 c8                	mov    %ecx,%eax
f0102ca4:	c1 f8 03             	sar    $0x3,%eax
f0102ca7:	89 c2                	mov    %eax,%edx
f0102ca9:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102cac:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102cb1:	83 c4 10             	add    $0x10,%esp
f0102cb4:	c7 c1 c8 a6 11 f0    	mov    $0xf011a6c8,%ecx
f0102cba:	3b 01                	cmp    (%ecx),%eax
f0102cbc:	0f 83 e2 01 00 00    	jae    f0102ea4 <mem_init+0x1a47>
	memset(page2kva(pp2), 2, PGSIZE);
f0102cc2:	83 ec 04             	sub    $0x4,%esp
f0102cc5:	68 00 10 00 00       	push   $0x1000
f0102cca:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102ccc:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102cd2:	52                   	push   %edx
f0102cd3:	e8 06 10 00 00       	call   f0103cde <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102cd8:	6a 02                	push   $0x2
f0102cda:	68 00 10 00 00       	push   $0x1000
f0102cdf:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102ce2:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0102ce8:	ff 30                	pushl  (%eax)
f0102cea:	e8 c6 e6 ff ff       	call   f01013b5 <page_insert>
	assert(pp1->pp_ref == 1);
f0102cef:	83 c4 20             	add    $0x20,%esp
f0102cf2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102cf5:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102cfa:	0f 85 ba 01 00 00    	jne    f0102eba <mem_init+0x1a5d>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102d00:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102d07:	01 01 01 
f0102d0a:	0f 85 c9 01 00 00    	jne    f0102ed9 <mem_init+0x1a7c>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102d10:	6a 02                	push   $0x2
f0102d12:	68 00 10 00 00       	push   $0x1000
f0102d17:	56                   	push   %esi
f0102d18:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0102d1e:	ff 30                	pushl  (%eax)
f0102d20:	e8 90 e6 ff ff       	call   f01013b5 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102d25:	83 c4 10             	add    $0x10,%esp
f0102d28:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102d2f:	02 02 02 
f0102d32:	0f 85 c0 01 00 00    	jne    f0102ef8 <mem_init+0x1a9b>
	assert(pp2->pp_ref == 1);
f0102d38:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102d3d:	0f 85 d4 01 00 00    	jne    f0102f17 <mem_init+0x1aba>
	assert(pp1->pp_ref == 0);
f0102d43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d46:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0102d4b:	0f 85 e5 01 00 00    	jne    f0102f36 <mem_init+0x1ad9>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102d51:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102d58:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102d5b:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0102d61:	89 f1                	mov    %esi,%ecx
f0102d63:	2b 08                	sub    (%eax),%ecx
f0102d65:	89 c8                	mov    %ecx,%eax
f0102d67:	c1 f8 03             	sar    $0x3,%eax
f0102d6a:	89 c2                	mov    %eax,%edx
f0102d6c:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102d6f:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102d74:	c7 c1 c8 a6 11 f0    	mov    $0xf011a6c8,%ecx
f0102d7a:	3b 01                	cmp    (%ecx),%eax
f0102d7c:	0f 83 d3 01 00 00    	jae    f0102f55 <mem_init+0x1af8>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102d82:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f0102d89:	03 03 03 
f0102d8c:	0f 85 d9 01 00 00    	jne    f0102f6b <mem_init+0x1b0e>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102d92:	83 ec 08             	sub    $0x8,%esp
f0102d95:	68 00 10 00 00       	push   $0x1000
f0102d9a:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0102da0:	ff 30                	pushl  (%eax)
f0102da2:	e8 cf e5 ff ff       	call   f0101376 <page_remove>
	assert(pp2->pp_ref == 0);
f0102da7:	83 c4 10             	add    $0x10,%esp
f0102daa:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102daf:	0f 85 d5 01 00 00    	jne    f0102f8a <mem_init+0x1b2d>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102db5:	c7 c0 cc a6 11 f0    	mov    $0xf011a6cc,%eax
f0102dbb:	8b 08                	mov    (%eax),%ecx
f0102dbd:	8b 11                	mov    (%ecx),%edx
f0102dbf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102dc5:	c7 c0 d0 a6 11 f0    	mov    $0xf011a6d0,%eax
f0102dcb:	89 fe                	mov    %edi,%esi
f0102dcd:	2b 30                	sub    (%eax),%esi
f0102dcf:	89 f0                	mov    %esi,%eax
f0102dd1:	c1 f8 03             	sar    $0x3,%eax
f0102dd4:	c1 e0 0c             	shl    $0xc,%eax
f0102dd7:	39 c2                	cmp    %eax,%edx
f0102dd9:	0f 85 ca 01 00 00    	jne    f0102fa9 <mem_init+0x1b4c>
	kern_pgdir[0] = 0;
f0102ddf:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102de5:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102dea:	0f 85 d8 01 00 00    	jne    f0102fc8 <mem_init+0x1b6b>
	pp0->pp_ref = 0;
f0102df0:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)

	// free the pages we took
	page_free(pp0);
f0102df6:	83 ec 0c             	sub    $0xc,%esp
f0102df9:	57                   	push   %edi
f0102dfa:	e8 03 e3 ff ff       	call   f0101102 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102dff:	8d 83 dc ca fe ff    	lea    -0x13524(%ebx),%eax
f0102e05:	89 04 24             	mov    %eax,(%esp)
f0102e08:	e8 8c 02 00 00       	call   f0103099 <cprintf>
}
f0102e0d:	83 c4 10             	add    $0x10,%esp
f0102e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102e13:	5b                   	pop    %ebx
f0102e14:	5e                   	pop    %esi
f0102e15:	5f                   	pop    %edi
f0102e16:	5d                   	pop    %ebp
f0102e17:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102e18:	50                   	push   %eax
f0102e19:	8d 83 38 c4 fe ff    	lea    -0x13bc8(%ebx),%eax
f0102e1f:	50                   	push   %eax
f0102e20:	68 e0 00 00 00       	push   $0xe0
f0102e25:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102e2b:	50                   	push   %eax
f0102e2c:	e8 6c d2 ff ff       	call   f010009d <_panic>
	assert((pp0 = page_alloc(0)));
f0102e31:	8d 83 d6 cb fe ff    	lea    -0x1342a(%ebx),%eax
f0102e37:	50                   	push   %eax
f0102e38:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102e3e:	50                   	push   %eax
f0102e3f:	68 dd 03 00 00       	push   $0x3dd
f0102e44:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102e4a:	50                   	push   %eax
f0102e4b:	e8 4d d2 ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f0102e50:	8d 83 ec cb fe ff    	lea    -0x13414(%ebx),%eax
f0102e56:	50                   	push   %eax
f0102e57:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102e5d:	50                   	push   %eax
f0102e5e:	68 de 03 00 00       	push   $0x3de
f0102e63:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102e69:	50                   	push   %eax
f0102e6a:	e8 2e d2 ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f0102e6f:	8d 83 02 cc fe ff    	lea    -0x133fe(%ebx),%eax
f0102e75:	50                   	push   %eax
f0102e76:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102e7c:	50                   	push   %eax
f0102e7d:	68 df 03 00 00       	push   $0x3df
f0102e82:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102e88:	50                   	push   %eax
f0102e89:	e8 0f d2 ff ff       	call   f010009d <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102e8e:	52                   	push   %edx
f0102e8f:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f0102e95:	50                   	push   %eax
f0102e96:	6a 52                	push   $0x52
f0102e98:	8d 83 11 cb fe ff    	lea    -0x134ef(%ebx),%eax
f0102e9e:	50                   	push   %eax
f0102e9f:	e8 f9 d1 ff ff       	call   f010009d <_panic>
f0102ea4:	52                   	push   %edx
f0102ea5:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f0102eab:	50                   	push   %eax
f0102eac:	6a 52                	push   $0x52
f0102eae:	8d 83 11 cb fe ff    	lea    -0x134ef(%ebx),%eax
f0102eb4:	50                   	push   %eax
f0102eb5:	e8 e3 d1 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 1);
f0102eba:	8d 83 d3 cc fe ff    	lea    -0x1332d(%ebx),%eax
f0102ec0:	50                   	push   %eax
f0102ec1:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102ec7:	50                   	push   %eax
f0102ec8:	68 e4 03 00 00       	push   $0x3e4
f0102ecd:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102ed3:	50                   	push   %eax
f0102ed4:	e8 c4 d1 ff ff       	call   f010009d <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102ed9:	8d 83 68 ca fe ff    	lea    -0x13598(%ebx),%eax
f0102edf:	50                   	push   %eax
f0102ee0:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102ee6:	50                   	push   %eax
f0102ee7:	68 e5 03 00 00       	push   $0x3e5
f0102eec:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102ef2:	50                   	push   %eax
f0102ef3:	e8 a5 d1 ff ff       	call   f010009d <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102ef8:	8d 83 8c ca fe ff    	lea    -0x13574(%ebx),%eax
f0102efe:	50                   	push   %eax
f0102eff:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102f05:	50                   	push   %eax
f0102f06:	68 e7 03 00 00       	push   $0x3e7
f0102f0b:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102f11:	50                   	push   %eax
f0102f12:	e8 86 d1 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f0102f17:	8d 83 f5 cc fe ff    	lea    -0x1330b(%ebx),%eax
f0102f1d:	50                   	push   %eax
f0102f1e:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102f24:	50                   	push   %eax
f0102f25:	68 e8 03 00 00       	push   $0x3e8
f0102f2a:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102f30:	50                   	push   %eax
f0102f31:	e8 67 d1 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 0);
f0102f36:	8d 83 5f cd fe ff    	lea    -0x132a1(%ebx),%eax
f0102f3c:	50                   	push   %eax
f0102f3d:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102f43:	50                   	push   %eax
f0102f44:	68 e9 03 00 00       	push   $0x3e9
f0102f49:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102f4f:	50                   	push   %eax
f0102f50:	e8 48 d1 ff ff       	call   f010009d <_panic>
f0102f55:	52                   	push   %edx
f0102f56:	8d 83 2c c3 fe ff    	lea    -0x13cd4(%ebx),%eax
f0102f5c:	50                   	push   %eax
f0102f5d:	6a 52                	push   $0x52
f0102f5f:	8d 83 11 cb fe ff    	lea    -0x134ef(%ebx),%eax
f0102f65:	50                   	push   %eax
f0102f66:	e8 32 d1 ff ff       	call   f010009d <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102f6b:	8d 83 b0 ca fe ff    	lea    -0x13550(%ebx),%eax
f0102f71:	50                   	push   %eax
f0102f72:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102f78:	50                   	push   %eax
f0102f79:	68 eb 03 00 00       	push   $0x3eb
f0102f7e:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102f84:	50                   	push   %eax
f0102f85:	e8 13 d1 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 0);
f0102f8a:	8d 83 2d cd fe ff    	lea    -0x132d3(%ebx),%eax
f0102f90:	50                   	push   %eax
f0102f91:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102f97:	50                   	push   %eax
f0102f98:	68 ed 03 00 00       	push   $0x3ed
f0102f9d:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102fa3:	50                   	push   %eax
f0102fa4:	e8 f4 d0 ff ff       	call   f010009d <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102fa9:	8d 83 f4 c5 fe ff    	lea    -0x13a0c(%ebx),%eax
f0102faf:	50                   	push   %eax
f0102fb0:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102fb6:	50                   	push   %eax
f0102fb7:	68 f0 03 00 00       	push   $0x3f0
f0102fbc:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102fc2:	50                   	push   %eax
f0102fc3:	e8 d5 d0 ff ff       	call   f010009d <_panic>
	assert(pp0->pp_ref == 1);
f0102fc8:	8d 83 e4 cc fe ff    	lea    -0x1331c(%ebx),%eax
f0102fce:	50                   	push   %eax
f0102fcf:	8d 83 2b cb fe ff    	lea    -0x134d5(%ebx),%eax
f0102fd5:	50                   	push   %eax
f0102fd6:	68 f2 03 00 00       	push   $0x3f2
f0102fdb:	8d 83 05 cb fe ff    	lea    -0x134fb(%ebx),%eax
f0102fe1:	50                   	push   %eax
f0102fe2:	e8 b6 d0 ff ff       	call   f010009d <_panic>

f0102fe7 <tlb_invalidate>:
{
f0102fe7:	f3 0f 1e fb          	endbr32 
f0102feb:	55                   	push   %ebp
f0102fec:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0102fee:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102ff1:	0f 01 38             	invlpg (%eax)
}
f0102ff4:	5d                   	pop    %ebp
f0102ff5:	c3                   	ret    

f0102ff6 <__x86.get_pc_thunk.dx>:
f0102ff6:	8b 14 24             	mov    (%esp),%edx
f0102ff9:	c3                   	ret    

f0102ffa <__x86.get_pc_thunk.cx>:
f0102ffa:	8b 0c 24             	mov    (%esp),%ecx
f0102ffd:	c3                   	ret    

f0102ffe <__x86.get_pc_thunk.di>:
f0102ffe:	8b 3c 24             	mov    (%esp),%edi
f0103001:	c3                   	ret    

f0103002 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103002:	f3 0f 1e fb          	endbr32 
f0103006:	55                   	push   %ebp
f0103007:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103009:	8b 45 08             	mov    0x8(%ebp),%eax
f010300c:	ba 70 00 00 00       	mov    $0x70,%edx
f0103011:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103012:	ba 71 00 00 00       	mov    $0x71,%edx
f0103017:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103018:	0f b6 c0             	movzbl %al,%eax
}
f010301b:	5d                   	pop    %ebp
f010301c:	c3                   	ret    

f010301d <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f010301d:	f3 0f 1e fb          	endbr32 
f0103021:	55                   	push   %ebp
f0103022:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103024:	8b 45 08             	mov    0x8(%ebp),%eax
f0103027:	ba 70 00 00 00       	mov    $0x70,%edx
f010302c:	ee                   	out    %al,(%dx)
f010302d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103030:	ba 71 00 00 00       	mov    $0x71,%edx
f0103035:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103036:	5d                   	pop    %ebp
f0103037:	c3                   	ret    

f0103038 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103038:	f3 0f 1e fb          	endbr32 
f010303c:	55                   	push   %ebp
f010303d:	89 e5                	mov    %esp,%ebp
f010303f:	53                   	push   %ebx
f0103040:	83 ec 10             	sub    $0x10,%esp
f0103043:	e8 13 d1 ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f0103048:	81 c3 c0 52 01 00    	add    $0x152c0,%ebx
	cputchar(ch);
f010304e:	ff 75 08             	pushl  0x8(%ebp)
f0103051:	e8 86 d6 ff ff       	call   f01006dc <cputchar>
	*cnt++;
}
f0103056:	83 c4 10             	add    $0x10,%esp
f0103059:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010305c:	c9                   	leave  
f010305d:	c3                   	ret    

f010305e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010305e:	f3 0f 1e fb          	endbr32 
f0103062:	55                   	push   %ebp
f0103063:	89 e5                	mov    %esp,%ebp
f0103065:	53                   	push   %ebx
f0103066:	83 ec 14             	sub    $0x14,%esp
f0103069:	e8 ed d0 ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f010306e:	81 c3 9a 52 01 00    	add    $0x1529a,%ebx
	int cnt = 0;
f0103074:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f010307b:	ff 75 0c             	pushl  0xc(%ebp)
f010307e:	ff 75 08             	pushl  0x8(%ebp)
f0103081:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103084:	50                   	push   %eax
f0103085:	8d 83 30 ad fe ff    	lea    -0x152d0(%ebx),%eax
f010308b:	50                   	push   %eax
f010308c:	e8 61 04 00 00       	call   f01034f2 <vprintfmt>
	return cnt;
}
f0103091:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103094:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103097:	c9                   	leave  
f0103098:	c3                   	ret    

f0103099 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103099:	f3 0f 1e fb          	endbr32 
f010309d:	55                   	push   %ebp
f010309e:	89 e5                	mov    %esp,%ebp
f01030a0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01030a3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f01030a6:	50                   	push   %eax
f01030a7:	ff 75 08             	pushl  0x8(%ebp)
f01030aa:	e8 af ff ff ff       	call   f010305e <vcprintf>
	va_end(ap);

	return cnt;
}
f01030af:	c9                   	leave  
f01030b0:	c3                   	ret    

f01030b1 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f01030b1:	55                   	push   %ebp
f01030b2:	89 e5                	mov    %esp,%ebp
f01030b4:	57                   	push   %edi
f01030b5:	56                   	push   %esi
f01030b6:	53                   	push   %ebx
f01030b7:	83 ec 14             	sub    $0x14,%esp
f01030ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01030bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01030c0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01030c3:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f01030c6:	8b 1a                	mov    (%edx),%ebx
f01030c8:	8b 01                	mov    (%ecx),%eax
f01030ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01030cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f01030d4:	eb 23                	jmp    f01030f9 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f01030d6:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f01030d9:	eb 1e                	jmp    f01030f9 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f01030db:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01030de:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01030e1:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01030e5:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01030e8:	73 46                	jae    f0103130 <stab_binsearch+0x7f>
			*region_left = m;
f01030ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01030ed:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f01030ef:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f01030f2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f01030f9:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f01030fc:	7f 5f                	jg     f010315d <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f01030fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103101:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0103104:	89 d0                	mov    %edx,%eax
f0103106:	c1 e8 1f             	shr    $0x1f,%eax
f0103109:	01 d0                	add    %edx,%eax
f010310b:	89 c7                	mov    %eax,%edi
f010310d:	d1 ff                	sar    %edi
f010310f:	83 e0 fe             	and    $0xfffffffe,%eax
f0103112:	01 f8                	add    %edi,%eax
f0103114:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0103117:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f010311b:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f010311d:	39 c3                	cmp    %eax,%ebx
f010311f:	7f b5                	jg     f01030d6 <stab_binsearch+0x25>
f0103121:	0f b6 0a             	movzbl (%edx),%ecx
f0103124:	83 ea 0c             	sub    $0xc,%edx
f0103127:	39 f1                	cmp    %esi,%ecx
f0103129:	74 b0                	je     f01030db <stab_binsearch+0x2a>
			m--;
f010312b:	83 e8 01             	sub    $0x1,%eax
f010312e:	eb ed                	jmp    f010311d <stab_binsearch+0x6c>
		} else if (stabs[m].n_value > addr) {
f0103130:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0103133:	76 14                	jbe    f0103149 <stab_binsearch+0x98>
			*region_right = m - 1;
f0103135:	83 e8 01             	sub    $0x1,%eax
f0103138:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010313b:	8b 7d e0             	mov    -0x20(%ebp),%edi
f010313e:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0103140:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0103147:	eb b0                	jmp    f01030f9 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0103149:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010314c:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f010314e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0103152:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0103154:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f010315b:	eb 9c                	jmp    f01030f9 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f010315d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0103161:	75 15                	jne    f0103178 <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0103163:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103166:	8b 00                	mov    (%eax),%eax
f0103168:	83 e8 01             	sub    $0x1,%eax
f010316b:	8b 7d e0             	mov    -0x20(%ebp),%edi
f010316e:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0103170:	83 c4 14             	add    $0x14,%esp
f0103173:	5b                   	pop    %ebx
f0103174:	5e                   	pop    %esi
f0103175:	5f                   	pop    %edi
f0103176:	5d                   	pop    %ebp
f0103177:	c3                   	ret    
		for (l = *region_right;
f0103178:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010317b:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f010317d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103180:	8b 0f                	mov    (%edi),%ecx
f0103182:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0103185:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0103188:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f010318c:	eb 03                	jmp    f0103191 <stab_binsearch+0xe0>
		     l--)
f010318e:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0103191:	39 c1                	cmp    %eax,%ecx
f0103193:	7d 0a                	jge    f010319f <stab_binsearch+0xee>
		     l > *region_left && stabs[l].n_type != type;
f0103195:	0f b6 1a             	movzbl (%edx),%ebx
f0103198:	83 ea 0c             	sub    $0xc,%edx
f010319b:	39 f3                	cmp    %esi,%ebx
f010319d:	75 ef                	jne    f010318e <stab_binsearch+0xdd>
		*region_left = l;
f010319f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01031a2:	89 07                	mov    %eax,(%edi)
}
f01031a4:	eb ca                	jmp    f0103170 <stab_binsearch+0xbf>

f01031a6 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f01031a6:	f3 0f 1e fb          	endbr32 
f01031aa:	55                   	push   %ebp
f01031ab:	89 e5                	mov    %esp,%ebp
f01031ad:	57                   	push   %edi
f01031ae:	56                   	push   %esi
f01031af:	53                   	push   %ebx
f01031b0:	83 ec 3c             	sub    $0x3c,%esp
f01031b3:	e8 a3 cf ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f01031b8:	81 c3 50 51 01 00    	add    $0x15150,%ebx
f01031be:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
f01031c1:	8b 7d 08             	mov    0x8(%ebp),%edi
f01031c4:	8b 75 0c             	mov    0xc(%ebp),%esi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f01031c7:	8d 83 e8 cd fe ff    	lea    -0x13218(%ebx),%eax
f01031cd:	89 06                	mov    %eax,(%esi)
	info->eip_line = 0;
f01031cf:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
	info->eip_fn_name = "<unknown>";
f01031d6:	89 46 08             	mov    %eax,0x8(%esi)
	info->eip_fn_namelen = 9;
f01031d9:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
	info->eip_fn_addr = addr;
f01031e0:	89 7e 10             	mov    %edi,0x10(%esi)
	info->eip_fn_narg = 0;
f01031e3:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f01031ea:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f01031f0:	0f 86 29 01 00 00    	jbe    f010331f <debuginfo_eip+0x179>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01031f6:	c7 c0 dd c6 10 f0    	mov    $0xf010c6dd,%eax
f01031fc:	39 83 fc ff ff ff    	cmp    %eax,-0x4(%ebx)
f0103202:	0f 86 c8 01 00 00    	jbe    f01033d0 <debuginfo_eip+0x22a>
f0103208:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f010320b:	c7 c0 32 e5 10 f0    	mov    $0xf010e532,%eax
f0103211:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f0103215:	0f 85 bc 01 00 00    	jne    f01033d7 <debuginfo_eip+0x231>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f010321b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0103222:	c7 c0 08 53 10 f0    	mov    $0xf0105308,%eax
f0103228:	c7 c2 dc c6 10 f0    	mov    $0xf010c6dc,%edx
f010322e:	29 c2                	sub    %eax,%edx
f0103230:	c1 fa 02             	sar    $0x2,%edx
f0103233:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0103239:	83 ea 01             	sub    $0x1,%edx
f010323c:	89 55 e0             	mov    %edx,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f010323f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0103242:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0103245:	83 ec 08             	sub    $0x8,%esp
f0103248:	57                   	push   %edi
f0103249:	6a 64                	push   $0x64
f010324b:	e8 61 fe ff ff       	call   f01030b1 <stab_binsearch>
	if (lfile == 0)
f0103250:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103253:	83 c4 10             	add    $0x10,%esp
f0103256:	85 c0                	test   %eax,%eax
f0103258:	0f 84 80 01 00 00    	je     f01033de <debuginfo_eip+0x238>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f010325e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0103261:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103264:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0103267:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f010326a:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010326d:	83 ec 08             	sub    $0x8,%esp
f0103270:	57                   	push   %edi
f0103271:	6a 24                	push   $0x24
f0103273:	c7 c0 08 53 10 f0    	mov    $0xf0105308,%eax
f0103279:	e8 33 fe ff ff       	call   f01030b1 <stab_binsearch>

	if (lfun <= rfun) {
f010327e:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103281:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0103284:	89 4d c0             	mov    %ecx,-0x40(%ebp)
f0103287:	83 c4 10             	add    $0x10,%esp
f010328a:	39 c8                	cmp    %ecx,%eax
f010328c:	0f 8f a8 00 00 00    	jg     f010333a <debuginfo_eip+0x194>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0103292:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0103295:	c7 c1 08 53 10 f0    	mov    $0xf0105308,%ecx
f010329b:	8d 0c 91             	lea    (%ecx,%edx,4),%ecx
f010329e:	8b 11                	mov    (%ecx),%edx
f01032a0:	89 55 bc             	mov    %edx,-0x44(%ebp)
f01032a3:	c7 c2 32 e5 10 f0    	mov    $0xf010e532,%edx
f01032a9:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
f01032ac:	81 ea dd c6 10 f0    	sub    $0xf010c6dd,%edx
f01032b2:	8b 5d bc             	mov    -0x44(%ebp),%ebx
f01032b5:	39 d3                	cmp    %edx,%ebx
f01032b7:	73 0c                	jae    f01032c5 <debuginfo_eip+0x11f>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f01032b9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f01032bc:	81 c3 dd c6 10 f0    	add    $0xf010c6dd,%ebx
f01032c2:	89 5e 08             	mov    %ebx,0x8(%esi)
		info->eip_fn_addr = stabs[lfun].n_value;
f01032c5:	8b 51 08             	mov    0x8(%ecx),%edx
f01032c8:	89 56 10             	mov    %edx,0x10(%esi)
		addr -= info->eip_fn_addr;
f01032cb:	29 d7                	sub    %edx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f01032cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f01032d0:	8b 45 c0             	mov    -0x40(%ebp),%eax
f01032d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f01032d6:	83 ec 08             	sub    $0x8,%esp
f01032d9:	6a 3a                	push   $0x3a
f01032db:	ff 76 08             	pushl  0x8(%esi)
f01032de:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f01032e1:	e8 d8 09 00 00       	call   f0103cbe <strfind>
f01032e6:	2b 46 08             	sub    0x8(%esi),%eax
f01032e9:	89 46 0c             	mov    %eax,0xc(%esi)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f01032ec:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f01032ef:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f01032f2:	83 c4 08             	add    $0x8,%esp
f01032f5:	57                   	push   %edi
f01032f6:	6a 44                	push   $0x44
f01032f8:	c7 c3 08 53 10 f0    	mov    $0xf0105308,%ebx
f01032fe:	89 d8                	mov    %ebx,%eax
f0103300:	e8 ac fd ff ff       	call   f01030b1 <stab_binsearch>
	info->eip_line = stabs[lline].n_desc;
f0103305:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0103308:	8d 04 52             	lea    (%edx,%edx,2),%eax
f010330b:	0f b7 4c 83 06       	movzwl 0x6(%ebx,%eax,4),%ecx
f0103310:	89 4e 04             	mov    %ecx,0x4(%esi)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0103313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103316:	8d 44 83 04          	lea    0x4(%ebx,%eax,4),%eax
f010331a:	83 c4 10             	add    $0x10,%esp
f010331d:	eb 32                	jmp    f0103351 <debuginfo_eip+0x1ab>
  	        panic("User address");
f010331f:	83 ec 04             	sub    $0x4,%esp
f0103322:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0103325:	8d 83 f2 cd fe ff    	lea    -0x1320e(%ebx),%eax
f010332b:	50                   	push   %eax
f010332c:	6a 7f                	push   $0x7f
f010332e:	8d 83 ff cd fe ff    	lea    -0x13201(%ebx),%eax
f0103334:	50                   	push   %eax
f0103335:	e8 63 cd ff ff       	call   f010009d <_panic>
		info->eip_fn_addr = addr;
f010333a:	89 7e 10             	mov    %edi,0x10(%esi)
		lline = lfile;
f010333d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103340:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0103343:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103346:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103349:	eb 8b                	jmp    f01032d6 <debuginfo_eip+0x130>
f010334b:	83 ea 01             	sub    $0x1,%edx
f010334e:	83 e8 0c             	sub    $0xc,%eax
	while (lline >= lfile
f0103351:	39 d7                	cmp    %edx,%edi
f0103353:	7f 3a                	jg     f010338f <debuginfo_eip+0x1e9>
	       && stabs[lline].n_type != N_SOL
f0103355:	0f b6 08             	movzbl (%eax),%ecx
f0103358:	80 f9 84             	cmp    $0x84,%cl
f010335b:	74 0b                	je     f0103368 <debuginfo_eip+0x1c2>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f010335d:	80 f9 64             	cmp    $0x64,%cl
f0103360:	75 e9                	jne    f010334b <debuginfo_eip+0x1a5>
f0103362:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f0103366:	74 e3                	je     f010334b <debuginfo_eip+0x1a5>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0103368:	8d 14 52             	lea    (%edx,%edx,2),%edx
f010336b:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f010336e:	c7 c0 08 53 10 f0    	mov    $0xf0105308,%eax
f0103374:	8b 14 90             	mov    (%eax,%edx,4),%edx
f0103377:	c7 c0 32 e5 10 f0    	mov    $0xf010e532,%eax
f010337d:	81 e8 dd c6 10 f0    	sub    $0xf010c6dd,%eax
f0103383:	39 c2                	cmp    %eax,%edx
f0103385:	73 08                	jae    f010338f <debuginfo_eip+0x1e9>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0103387:	81 c2 dd c6 10 f0    	add    $0xf010c6dd,%edx
f010338d:	89 16                	mov    %edx,(%esi)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f010338f:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103392:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0103395:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f010339a:	39 da                	cmp    %ebx,%edx
f010339c:	7d 4c                	jge    f01033ea <debuginfo_eip+0x244>
		for (lline = lfun + 1;
f010339e:	8d 42 01             	lea    0x1(%edx),%eax
f01033a1:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f01033a4:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f01033a7:	c7 c2 08 53 10 f0    	mov    $0xf0105308,%edx
f01033ad:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx
f01033b1:	eb 04                	jmp    f01033b7 <debuginfo_eip+0x211>
			info->eip_fn_narg++;
f01033b3:	83 46 14 01          	addl   $0x1,0x14(%esi)
		for (lline = lfun + 1;
f01033b7:	39 c3                	cmp    %eax,%ebx
f01033b9:	7e 2a                	jle    f01033e5 <debuginfo_eip+0x23f>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01033bb:	0f b6 0a             	movzbl (%edx),%ecx
f01033be:	83 c0 01             	add    $0x1,%eax
f01033c1:	83 c2 0c             	add    $0xc,%edx
f01033c4:	80 f9 a0             	cmp    $0xa0,%cl
f01033c7:	74 ea                	je     f01033b3 <debuginfo_eip+0x20d>
	return 0;
f01033c9:	b8 00 00 00 00       	mov    $0x0,%eax
f01033ce:	eb 1a                	jmp    f01033ea <debuginfo_eip+0x244>
		return -1;
f01033d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01033d5:	eb 13                	jmp    f01033ea <debuginfo_eip+0x244>
f01033d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01033dc:	eb 0c                	jmp    f01033ea <debuginfo_eip+0x244>
		return -1;
f01033de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01033e3:	eb 05                	jmp    f01033ea <debuginfo_eip+0x244>
	return 0;
f01033e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01033ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01033ed:	5b                   	pop    %ebx
f01033ee:	5e                   	pop    %esi
f01033ef:	5f                   	pop    %edi
f01033f0:	5d                   	pop    %ebp
f01033f1:	c3                   	ret    

f01033f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f01033f2:	55                   	push   %ebp
f01033f3:	89 e5                	mov    %esp,%ebp
f01033f5:	57                   	push   %edi
f01033f6:	56                   	push   %esi
f01033f7:	53                   	push   %ebx
f01033f8:	83 ec 2c             	sub    $0x2c,%esp
f01033fb:	e8 fa fb ff ff       	call   f0102ffa <__x86.get_pc_thunk.cx>
f0103400:	81 c1 08 4f 01 00    	add    $0x14f08,%ecx
f0103406:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0103409:	89 c7                	mov    %eax,%edi
f010340b:	89 d6                	mov    %edx,%esi
f010340d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103410:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103413:	89 d1                	mov    %edx,%ecx
f0103415:	89 c2                	mov    %eax,%edx
f0103417:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010341a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f010341d:	8b 45 10             	mov    0x10(%ebp),%eax
f0103420:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0103423:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103426:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f010342d:	39 c2                	cmp    %eax,%edx
f010342f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0103432:	72 41                	jb     f0103475 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0103434:	83 ec 0c             	sub    $0xc,%esp
f0103437:	ff 75 18             	pushl  0x18(%ebp)
f010343a:	83 eb 01             	sub    $0x1,%ebx
f010343d:	53                   	push   %ebx
f010343e:	50                   	push   %eax
f010343f:	83 ec 08             	sub    $0x8,%esp
f0103442:	ff 75 e4             	pushl  -0x1c(%ebp)
f0103445:	ff 75 e0             	pushl  -0x20(%ebp)
f0103448:	ff 75 d4             	pushl  -0x2c(%ebp)
f010344b:	ff 75 d0             	pushl  -0x30(%ebp)
f010344e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0103451:	e8 9a 0a 00 00       	call   f0103ef0 <__udivdi3>
f0103456:	83 c4 18             	add    $0x18,%esp
f0103459:	52                   	push   %edx
f010345a:	50                   	push   %eax
f010345b:	89 f2                	mov    %esi,%edx
f010345d:	89 f8                	mov    %edi,%eax
f010345f:	e8 8e ff ff ff       	call   f01033f2 <printnum>
f0103464:	83 c4 20             	add    $0x20,%esp
f0103467:	eb 13                	jmp    f010347c <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0103469:	83 ec 08             	sub    $0x8,%esp
f010346c:	56                   	push   %esi
f010346d:	ff 75 18             	pushl  0x18(%ebp)
f0103470:	ff d7                	call   *%edi
f0103472:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0103475:	83 eb 01             	sub    $0x1,%ebx
f0103478:	85 db                	test   %ebx,%ebx
f010347a:	7f ed                	jg     f0103469 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f010347c:	83 ec 08             	sub    $0x8,%esp
f010347f:	56                   	push   %esi
f0103480:	83 ec 04             	sub    $0x4,%esp
f0103483:	ff 75 e4             	pushl  -0x1c(%ebp)
f0103486:	ff 75 e0             	pushl  -0x20(%ebp)
f0103489:	ff 75 d4             	pushl  -0x2c(%ebp)
f010348c:	ff 75 d0             	pushl  -0x30(%ebp)
f010348f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0103492:	e8 69 0b 00 00       	call   f0104000 <__umoddi3>
f0103497:	83 c4 14             	add    $0x14,%esp
f010349a:	0f be 84 03 0d ce fe 	movsbl -0x131f3(%ebx,%eax,1),%eax
f01034a1:	ff 
f01034a2:	50                   	push   %eax
f01034a3:	ff d7                	call   *%edi
}
f01034a5:	83 c4 10             	add    $0x10,%esp
f01034a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01034ab:	5b                   	pop    %ebx
f01034ac:	5e                   	pop    %esi
f01034ad:	5f                   	pop    %edi
f01034ae:	5d                   	pop    %ebp
f01034af:	c3                   	ret    

f01034b0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01034b0:	f3 0f 1e fb          	endbr32 
f01034b4:	55                   	push   %ebp
f01034b5:	89 e5                	mov    %esp,%ebp
f01034b7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01034ba:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f01034be:	8b 10                	mov    (%eax),%edx
f01034c0:	3b 50 04             	cmp    0x4(%eax),%edx
f01034c3:	73 0a                	jae    f01034cf <sprintputch+0x1f>
		*b->buf++ = ch;
f01034c5:	8d 4a 01             	lea    0x1(%edx),%ecx
f01034c8:	89 08                	mov    %ecx,(%eax)
f01034ca:	8b 45 08             	mov    0x8(%ebp),%eax
f01034cd:	88 02                	mov    %al,(%edx)
}
f01034cf:	5d                   	pop    %ebp
f01034d0:	c3                   	ret    

f01034d1 <printfmt>:
{
f01034d1:	f3 0f 1e fb          	endbr32 
f01034d5:	55                   	push   %ebp
f01034d6:	89 e5                	mov    %esp,%ebp
f01034d8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f01034db:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f01034de:	50                   	push   %eax
f01034df:	ff 75 10             	pushl  0x10(%ebp)
f01034e2:	ff 75 0c             	pushl  0xc(%ebp)
f01034e5:	ff 75 08             	pushl  0x8(%ebp)
f01034e8:	e8 05 00 00 00       	call   f01034f2 <vprintfmt>
}
f01034ed:	83 c4 10             	add    $0x10,%esp
f01034f0:	c9                   	leave  
f01034f1:	c3                   	ret    

f01034f2 <vprintfmt>:
{
f01034f2:	f3 0f 1e fb          	endbr32 
f01034f6:	55                   	push   %ebp
f01034f7:	89 e5                	mov    %esp,%ebp
f01034f9:	57                   	push   %edi
f01034fa:	56                   	push   %esi
f01034fb:	53                   	push   %ebx
f01034fc:	83 ec 3c             	sub    $0x3c,%esp
f01034ff:	e8 0b d2 ff ff       	call   f010070f <__x86.get_pc_thunk.ax>
f0103504:	05 04 4e 01 00       	add    $0x14e04,%eax
f0103509:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010350c:	8b 75 08             	mov    0x8(%ebp),%esi
f010350f:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0103512:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0103515:	8d 80 3c 1d 00 00    	lea    0x1d3c(%eax),%eax
f010351b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f010351e:	e9 cd 03 00 00       	jmp    f01038f0 <.L25+0x48>
		padc = ' ';
f0103523:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
f0103527:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f010352e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0103535:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
f010353c:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103541:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f0103544:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0103547:	8d 43 01             	lea    0x1(%ebx),%eax
f010354a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010354d:	0f b6 13             	movzbl (%ebx),%edx
f0103550:	8d 42 dd             	lea    -0x23(%edx),%eax
f0103553:	3c 55                	cmp    $0x55,%al
f0103555:	0f 87 21 04 00 00    	ja     f010397c <.L20>
f010355b:	0f b6 c0             	movzbl %al,%eax
f010355e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103561:	89 ce                	mov    %ecx,%esi
f0103563:	03 b4 81 98 ce fe ff 	add    -0x13168(%ecx,%eax,4),%esi
f010356a:	3e ff e6             	notrack jmp *%esi

f010356d <.L68>:
f010356d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
f0103570:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0103574:	eb d1                	jmp    f0103547 <vprintfmt+0x55>

f0103576 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
f0103576:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0103579:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f010357d:	eb c8                	jmp    f0103547 <vprintfmt+0x55>

f010357f <.L31>:
f010357f:	0f b6 d2             	movzbl %dl,%edx
f0103582:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
f0103585:	b8 00 00 00 00       	mov    $0x0,%eax
f010358a:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
f010358d:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0103590:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0103594:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
f0103597:	8d 4a d0             	lea    -0x30(%edx),%ecx
f010359a:	83 f9 09             	cmp    $0x9,%ecx
f010359d:	77 58                	ja     f01035f7 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
f010359f:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
f01035a2:	eb e9                	jmp    f010358d <.L31+0xe>

f01035a4 <.L34>:
			precision = va_arg(ap, int);
f01035a4:	8b 45 14             	mov    0x14(%ebp),%eax
f01035a7:	8b 00                	mov    (%eax),%eax
f01035a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01035ac:	8b 45 14             	mov    0x14(%ebp),%eax
f01035af:	8d 40 04             	lea    0x4(%eax),%eax
f01035b2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01035b5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
f01035b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01035bc:	79 89                	jns    f0103547 <vprintfmt+0x55>
				width = precision, precision = -1;
f01035be:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01035c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01035c4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f01035cb:	e9 77 ff ff ff       	jmp    f0103547 <vprintfmt+0x55>

f01035d0 <.L33>:
f01035d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01035d3:	85 c0                	test   %eax,%eax
f01035d5:	ba 00 00 00 00       	mov    $0x0,%edx
f01035da:	0f 49 d0             	cmovns %eax,%edx
f01035dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01035e0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f01035e3:	e9 5f ff ff ff       	jmp    f0103547 <vprintfmt+0x55>

f01035e8 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
f01035e8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
f01035eb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f01035f2:	e9 50 ff ff ff       	jmp    f0103547 <vprintfmt+0x55>
f01035f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01035fa:	89 75 08             	mov    %esi,0x8(%ebp)
f01035fd:	eb b9                	jmp    f01035b8 <.L34+0x14>

f01035ff <.L27>:
			lflag++;
f01035ff:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0103603:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f0103606:	e9 3c ff ff ff       	jmp    f0103547 <vprintfmt+0x55>

f010360b <.L30>:
f010360b:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
f010360e:	8b 45 14             	mov    0x14(%ebp),%eax
f0103611:	8d 58 04             	lea    0x4(%eax),%ebx
f0103614:	83 ec 08             	sub    $0x8,%esp
f0103617:	57                   	push   %edi
f0103618:	ff 30                	pushl  (%eax)
f010361a:	ff d6                	call   *%esi
			break;
f010361c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f010361f:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
f0103622:	e9 c6 02 00 00       	jmp    f01038ed <.L25+0x45>

f0103627 <.L28>:
f0103627:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
f010362a:	8b 45 14             	mov    0x14(%ebp),%eax
f010362d:	8d 58 04             	lea    0x4(%eax),%ebx
f0103630:	8b 00                	mov    (%eax),%eax
f0103632:	99                   	cltd   
f0103633:	31 d0                	xor    %edx,%eax
f0103635:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0103637:	83 f8 06             	cmp    $0x6,%eax
f010363a:	7f 27                	jg     f0103663 <.L28+0x3c>
f010363c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010363f:	8b 14 82             	mov    (%edx,%eax,4),%edx
f0103642:	85 d2                	test   %edx,%edx
f0103644:	74 1d                	je     f0103663 <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
f0103646:	52                   	push   %edx
f0103647:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010364a:	8d 80 3d cb fe ff    	lea    -0x134c3(%eax),%eax
f0103650:	50                   	push   %eax
f0103651:	57                   	push   %edi
f0103652:	56                   	push   %esi
f0103653:	e8 79 fe ff ff       	call   f01034d1 <printfmt>
f0103658:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010365b:	89 5d 14             	mov    %ebx,0x14(%ebp)
f010365e:	e9 8a 02 00 00       	jmp    f01038ed <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
f0103663:	50                   	push   %eax
f0103664:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103667:	8d 80 25 ce fe ff    	lea    -0x131db(%eax),%eax
f010366d:	50                   	push   %eax
f010366e:	57                   	push   %edi
f010366f:	56                   	push   %esi
f0103670:	e8 5c fe ff ff       	call   f01034d1 <printfmt>
f0103675:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0103678:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f010367b:	e9 6d 02 00 00       	jmp    f01038ed <.L25+0x45>

f0103680 <.L24>:
f0103680:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
f0103683:	8b 45 14             	mov    0x14(%ebp),%eax
f0103686:	83 c0 04             	add    $0x4,%eax
f0103689:	89 45 c0             	mov    %eax,-0x40(%ebp)
f010368c:	8b 45 14             	mov    0x14(%ebp),%eax
f010368f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f0103691:	85 d2                	test   %edx,%edx
f0103693:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103696:	8d 80 1e ce fe ff    	lea    -0x131e2(%eax),%eax
f010369c:	0f 45 c2             	cmovne %edx,%eax
f010369f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f01036a2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01036a6:	7e 06                	jle    f01036ae <.L24+0x2e>
f01036a8:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f01036ac:	75 0d                	jne    f01036bb <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
f01036ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01036b1:	89 c3                	mov    %eax,%ebx
f01036b3:	03 45 d4             	add    -0x2c(%ebp),%eax
f01036b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01036b9:	eb 58                	jmp    f0103713 <.L24+0x93>
f01036bb:	83 ec 08             	sub    $0x8,%esp
f01036be:	ff 75 d8             	pushl  -0x28(%ebp)
f01036c1:	ff 75 c8             	pushl  -0x38(%ebp)
f01036c4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f01036c7:	e8 81 04 00 00       	call   f0103b4d <strnlen>
f01036cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01036cf:	29 c2                	sub    %eax,%edx
f01036d1:	89 55 bc             	mov    %edx,-0x44(%ebp)
f01036d4:	83 c4 10             	add    $0x10,%esp
f01036d7:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
f01036d9:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f01036dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f01036e0:	85 db                	test   %ebx,%ebx
f01036e2:	7e 11                	jle    f01036f5 <.L24+0x75>
					putch(padc, putdat);
f01036e4:	83 ec 08             	sub    $0x8,%esp
f01036e7:	57                   	push   %edi
f01036e8:	ff 75 d4             	pushl  -0x2c(%ebp)
f01036eb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f01036ed:	83 eb 01             	sub    $0x1,%ebx
f01036f0:	83 c4 10             	add    $0x10,%esp
f01036f3:	eb eb                	jmp    f01036e0 <.L24+0x60>
f01036f5:	8b 55 bc             	mov    -0x44(%ebp),%edx
f01036f8:	85 d2                	test   %edx,%edx
f01036fa:	b8 00 00 00 00       	mov    $0x0,%eax
f01036ff:	0f 49 c2             	cmovns %edx,%eax
f0103702:	29 c2                	sub    %eax,%edx
f0103704:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0103707:	eb a5                	jmp    f01036ae <.L24+0x2e>
					putch(ch, putdat);
f0103709:	83 ec 08             	sub    $0x8,%esp
f010370c:	57                   	push   %edi
f010370d:	52                   	push   %edx
f010370e:	ff d6                	call   *%esi
f0103710:	83 c4 10             	add    $0x10,%esp
f0103713:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103716:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0103718:	83 c3 01             	add    $0x1,%ebx
f010371b:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f010371f:	0f be d0             	movsbl %al,%edx
f0103722:	85 d2                	test   %edx,%edx
f0103724:	74 4b                	je     f0103771 <.L24+0xf1>
f0103726:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f010372a:	78 06                	js     f0103732 <.L24+0xb2>
f010372c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0103730:	78 1e                	js     f0103750 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
f0103732:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0103736:	74 d1                	je     f0103709 <.L24+0x89>
f0103738:	0f be c0             	movsbl %al,%eax
f010373b:	83 e8 20             	sub    $0x20,%eax
f010373e:	83 f8 5e             	cmp    $0x5e,%eax
f0103741:	76 c6                	jbe    f0103709 <.L24+0x89>
					putch('?', putdat);
f0103743:	83 ec 08             	sub    $0x8,%esp
f0103746:	57                   	push   %edi
f0103747:	6a 3f                	push   $0x3f
f0103749:	ff d6                	call   *%esi
f010374b:	83 c4 10             	add    $0x10,%esp
f010374e:	eb c3                	jmp    f0103713 <.L24+0x93>
f0103750:	89 cb                	mov    %ecx,%ebx
f0103752:	eb 0e                	jmp    f0103762 <.L24+0xe2>
				putch(' ', putdat);
f0103754:	83 ec 08             	sub    $0x8,%esp
f0103757:	57                   	push   %edi
f0103758:	6a 20                	push   $0x20
f010375a:	ff d6                	call   *%esi
			for (; width > 0; width--)
f010375c:	83 eb 01             	sub    $0x1,%ebx
f010375f:	83 c4 10             	add    $0x10,%esp
f0103762:	85 db                	test   %ebx,%ebx
f0103764:	7f ee                	jg     f0103754 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
f0103766:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0103769:	89 45 14             	mov    %eax,0x14(%ebp)
f010376c:	e9 7c 01 00 00       	jmp    f01038ed <.L25+0x45>
f0103771:	89 cb                	mov    %ecx,%ebx
f0103773:	eb ed                	jmp    f0103762 <.L24+0xe2>

f0103775 <.L29>:
f0103775:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0103778:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f010377b:	83 f9 01             	cmp    $0x1,%ecx
f010377e:	7f 1b                	jg     f010379b <.L29+0x26>
	else if (lflag)
f0103780:	85 c9                	test   %ecx,%ecx
f0103782:	74 63                	je     f01037e7 <.L29+0x72>
		return va_arg(*ap, long);
f0103784:	8b 45 14             	mov    0x14(%ebp),%eax
f0103787:	8b 00                	mov    (%eax),%eax
f0103789:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010378c:	99                   	cltd   
f010378d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0103790:	8b 45 14             	mov    0x14(%ebp),%eax
f0103793:	8d 40 04             	lea    0x4(%eax),%eax
f0103796:	89 45 14             	mov    %eax,0x14(%ebp)
f0103799:	eb 17                	jmp    f01037b2 <.L29+0x3d>
		return va_arg(*ap, long long);
f010379b:	8b 45 14             	mov    0x14(%ebp),%eax
f010379e:	8b 50 04             	mov    0x4(%eax),%edx
f01037a1:	8b 00                	mov    (%eax),%eax
f01037a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01037a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01037a9:	8b 45 14             	mov    0x14(%ebp),%eax
f01037ac:	8d 40 08             	lea    0x8(%eax),%eax
f01037af:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01037b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01037b5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f01037b8:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f01037bd:	85 c9                	test   %ecx,%ecx
f01037bf:	0f 89 0e 01 00 00    	jns    f01038d3 <.L25+0x2b>
				putch('-', putdat);
f01037c5:	83 ec 08             	sub    $0x8,%esp
f01037c8:	57                   	push   %edi
f01037c9:	6a 2d                	push   $0x2d
f01037cb:	ff d6                	call   *%esi
				num = -(long long) num;
f01037cd:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01037d0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01037d3:	f7 da                	neg    %edx
f01037d5:	83 d1 00             	adc    $0x0,%ecx
f01037d8:	f7 d9                	neg    %ecx
f01037da:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01037dd:	b8 0a 00 00 00       	mov    $0xa,%eax
f01037e2:	e9 ec 00 00 00       	jmp    f01038d3 <.L25+0x2b>
		return va_arg(*ap, int);
f01037e7:	8b 45 14             	mov    0x14(%ebp),%eax
f01037ea:	8b 00                	mov    (%eax),%eax
f01037ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01037ef:	99                   	cltd   
f01037f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01037f3:	8b 45 14             	mov    0x14(%ebp),%eax
f01037f6:	8d 40 04             	lea    0x4(%eax),%eax
f01037f9:	89 45 14             	mov    %eax,0x14(%ebp)
f01037fc:	eb b4                	jmp    f01037b2 <.L29+0x3d>

f01037fe <.L23>:
f01037fe:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0103801:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f0103804:	83 f9 01             	cmp    $0x1,%ecx
f0103807:	7f 1e                	jg     f0103827 <.L23+0x29>
	else if (lflag)
f0103809:	85 c9                	test   %ecx,%ecx
f010380b:	74 32                	je     f010383f <.L23+0x41>
		return va_arg(*ap, unsigned long);
f010380d:	8b 45 14             	mov    0x14(%ebp),%eax
f0103810:	8b 10                	mov    (%eax),%edx
f0103812:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103817:	8d 40 04             	lea    0x4(%eax),%eax
f010381a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010381d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
f0103822:	e9 ac 00 00 00       	jmp    f01038d3 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f0103827:	8b 45 14             	mov    0x14(%ebp),%eax
f010382a:	8b 10                	mov    (%eax),%edx
f010382c:	8b 48 04             	mov    0x4(%eax),%ecx
f010382f:	8d 40 08             	lea    0x8(%eax),%eax
f0103832:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0103835:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
f010383a:	e9 94 00 00 00       	jmp    f01038d3 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f010383f:	8b 45 14             	mov    0x14(%ebp),%eax
f0103842:	8b 10                	mov    (%eax),%edx
f0103844:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103849:	8d 40 04             	lea    0x4(%eax),%eax
f010384c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010384f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
f0103854:	eb 7d                	jmp    f01038d3 <.L25+0x2b>

f0103856 <.L26>:
f0103856:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0103859:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f010385c:	83 f9 01             	cmp    $0x1,%ecx
f010385f:	7f 1b                	jg     f010387c <.L26+0x26>
	else if (lflag)
f0103861:	85 c9                	test   %ecx,%ecx
f0103863:	74 2c                	je     f0103891 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
f0103865:	8b 45 14             	mov    0x14(%ebp),%eax
f0103868:	8b 10                	mov    (%eax),%edx
f010386a:	b9 00 00 00 00       	mov    $0x0,%ecx
f010386f:	8d 40 04             	lea    0x4(%eax),%eax
f0103872:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0103875:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
f010387a:	eb 57                	jmp    f01038d3 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f010387c:	8b 45 14             	mov    0x14(%ebp),%eax
f010387f:	8b 10                	mov    (%eax),%edx
f0103881:	8b 48 04             	mov    0x4(%eax),%ecx
f0103884:	8d 40 08             	lea    0x8(%eax),%eax
f0103887:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010388a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
f010388f:	eb 42                	jmp    f01038d3 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f0103891:	8b 45 14             	mov    0x14(%ebp),%eax
f0103894:	8b 10                	mov    (%eax),%edx
f0103896:	b9 00 00 00 00       	mov    $0x0,%ecx
f010389b:	8d 40 04             	lea    0x4(%eax),%eax
f010389e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01038a1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
f01038a6:	eb 2b                	jmp    f01038d3 <.L25+0x2b>

f01038a8 <.L25>:
f01038a8:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
f01038ab:	83 ec 08             	sub    $0x8,%esp
f01038ae:	57                   	push   %edi
f01038af:	6a 30                	push   $0x30
f01038b1:	ff d6                	call   *%esi
			putch('x', putdat);
f01038b3:	83 c4 08             	add    $0x8,%esp
f01038b6:	57                   	push   %edi
f01038b7:	6a 78                	push   $0x78
f01038b9:	ff d6                	call   *%esi
			num = (unsigned long long)
f01038bb:	8b 45 14             	mov    0x14(%ebp),%eax
f01038be:	8b 10                	mov    (%eax),%edx
f01038c0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f01038c5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01038c8:	8d 40 04             	lea    0x4(%eax),%eax
f01038cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01038ce:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01038d3:	83 ec 0c             	sub    $0xc,%esp
f01038d6:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
f01038da:	53                   	push   %ebx
f01038db:	ff 75 d4             	pushl  -0x2c(%ebp)
f01038de:	50                   	push   %eax
f01038df:	51                   	push   %ecx
f01038e0:	52                   	push   %edx
f01038e1:	89 fa                	mov    %edi,%edx
f01038e3:	89 f0                	mov    %esi,%eax
f01038e5:	e8 08 fb ff ff       	call   f01033f2 <printnum>
			break;
f01038ea:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f01038ed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01038f0:	83 c3 01             	add    $0x1,%ebx
f01038f3:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f01038f7:	83 f8 25             	cmp    $0x25,%eax
f01038fa:	0f 84 23 fc ff ff    	je     f0103523 <vprintfmt+0x31>
			if (ch == '\0')
f0103900:	85 c0                	test   %eax,%eax
f0103902:	0f 84 97 00 00 00    	je     f010399f <.L20+0x23>
			putch(ch, putdat);
f0103908:	83 ec 08             	sub    $0x8,%esp
f010390b:	57                   	push   %edi
f010390c:	50                   	push   %eax
f010390d:	ff d6                	call   *%esi
f010390f:	83 c4 10             	add    $0x10,%esp
f0103912:	eb dc                	jmp    f01038f0 <.L25+0x48>

f0103914 <.L21>:
f0103914:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0103917:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f010391a:	83 f9 01             	cmp    $0x1,%ecx
f010391d:	7f 1b                	jg     f010393a <.L21+0x26>
	else if (lflag)
f010391f:	85 c9                	test   %ecx,%ecx
f0103921:	74 2c                	je     f010394f <.L21+0x3b>
		return va_arg(*ap, unsigned long);
f0103923:	8b 45 14             	mov    0x14(%ebp),%eax
f0103926:	8b 10                	mov    (%eax),%edx
f0103928:	b9 00 00 00 00       	mov    $0x0,%ecx
f010392d:	8d 40 04             	lea    0x4(%eax),%eax
f0103930:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0103933:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
f0103938:	eb 99                	jmp    f01038d3 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f010393a:	8b 45 14             	mov    0x14(%ebp),%eax
f010393d:	8b 10                	mov    (%eax),%edx
f010393f:	8b 48 04             	mov    0x4(%eax),%ecx
f0103942:	8d 40 08             	lea    0x8(%eax),%eax
f0103945:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0103948:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
f010394d:	eb 84                	jmp    f01038d3 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f010394f:	8b 45 14             	mov    0x14(%ebp),%eax
f0103952:	8b 10                	mov    (%eax),%edx
f0103954:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103959:	8d 40 04             	lea    0x4(%eax),%eax
f010395c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010395f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
f0103964:	e9 6a ff ff ff       	jmp    f01038d3 <.L25+0x2b>

f0103969 <.L35>:
f0103969:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
f010396c:	83 ec 08             	sub    $0x8,%esp
f010396f:	57                   	push   %edi
f0103970:	6a 25                	push   $0x25
f0103972:	ff d6                	call   *%esi
			break;
f0103974:	83 c4 10             	add    $0x10,%esp
f0103977:	e9 71 ff ff ff       	jmp    f01038ed <.L25+0x45>

f010397c <.L20>:
f010397c:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
f010397f:	83 ec 08             	sub    $0x8,%esp
f0103982:	57                   	push   %edi
f0103983:	6a 25                	push   $0x25
f0103985:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0103987:	83 c4 10             	add    $0x10,%esp
f010398a:	89 d8                	mov    %ebx,%eax
f010398c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0103990:	74 05                	je     f0103997 <.L20+0x1b>
f0103992:	83 e8 01             	sub    $0x1,%eax
f0103995:	eb f5                	jmp    f010398c <.L20+0x10>
f0103997:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010399a:	e9 4e ff ff ff       	jmp    f01038ed <.L25+0x45>
}
f010399f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01039a2:	5b                   	pop    %ebx
f01039a3:	5e                   	pop    %esi
f01039a4:	5f                   	pop    %edi
f01039a5:	5d                   	pop    %ebp
f01039a6:	c3                   	ret    

f01039a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01039a7:	f3 0f 1e fb          	endbr32 
f01039ab:	55                   	push   %ebp
f01039ac:	89 e5                	mov    %esp,%ebp
f01039ae:	53                   	push   %ebx
f01039af:	83 ec 14             	sub    $0x14,%esp
f01039b2:	e8 a4 c7 ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f01039b7:	81 c3 51 49 01 00    	add    $0x14951,%ebx
f01039bd:	8b 45 08             	mov    0x8(%ebp),%eax
f01039c0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01039c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01039c6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01039ca:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01039cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01039d4:	85 c0                	test   %eax,%eax
f01039d6:	74 2b                	je     f0103a03 <vsnprintf+0x5c>
f01039d8:	85 d2                	test   %edx,%edx
f01039da:	7e 27                	jle    f0103a03 <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01039dc:	ff 75 14             	pushl  0x14(%ebp)
f01039df:	ff 75 10             	pushl  0x10(%ebp)
f01039e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01039e5:	50                   	push   %eax
f01039e6:	8d 83 a8 b1 fe ff    	lea    -0x14e58(%ebx),%eax
f01039ec:	50                   	push   %eax
f01039ed:	e8 00 fb ff ff       	call   f01034f2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01039f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01039f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01039f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01039fb:	83 c4 10             	add    $0x10,%esp
}
f01039fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103a01:	c9                   	leave  
f0103a02:	c3                   	ret    
		return -E_INVAL;
f0103a03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0103a08:	eb f4                	jmp    f01039fe <vsnprintf+0x57>

f0103a0a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0103a0a:	f3 0f 1e fb          	endbr32 
f0103a0e:	55                   	push   %ebp
f0103a0f:	89 e5                	mov    %esp,%ebp
f0103a11:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0103a14:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0103a17:	50                   	push   %eax
f0103a18:	ff 75 10             	pushl  0x10(%ebp)
f0103a1b:	ff 75 0c             	pushl  0xc(%ebp)
f0103a1e:	ff 75 08             	pushl  0x8(%ebp)
f0103a21:	e8 81 ff ff ff       	call   f01039a7 <vsnprintf>
	va_end(ap);

	return rc;
}
f0103a26:	c9                   	leave  
f0103a27:	c3                   	ret    

f0103a28 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0103a28:	f3 0f 1e fb          	endbr32 
f0103a2c:	55                   	push   %ebp
f0103a2d:	89 e5                	mov    %esp,%ebp
f0103a2f:	57                   	push   %edi
f0103a30:	56                   	push   %esi
f0103a31:	53                   	push   %ebx
f0103a32:	83 ec 1c             	sub    $0x1c,%esp
f0103a35:	e8 21 c7 ff ff       	call   f010015b <__x86.get_pc_thunk.bx>
f0103a3a:	81 c3 ce 48 01 00    	add    $0x148ce,%ebx
f0103a40:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0103a43:	85 c0                	test   %eax,%eax
f0103a45:	74 13                	je     f0103a5a <readline+0x32>
		cprintf("%s", prompt);
f0103a47:	83 ec 08             	sub    $0x8,%esp
f0103a4a:	50                   	push   %eax
f0103a4b:	8d 83 3d cb fe ff    	lea    -0x134c3(%ebx),%eax
f0103a51:	50                   	push   %eax
f0103a52:	e8 42 f6 ff ff       	call   f0103099 <cprintf>
f0103a57:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f0103a5a:	83 ec 0c             	sub    $0xc,%esp
f0103a5d:	6a 00                	push   $0x0
f0103a5f:	e8 a1 cc ff ff       	call   f0100705 <iscons>
f0103a64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103a67:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0103a6a:	bf 00 00 00 00       	mov    $0x0,%edi
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
			if (echoing)
				cputchar(c);
			buf[i++] = c;
f0103a6f:	8d 83 b8 1f 00 00    	lea    0x1fb8(%ebx),%eax
f0103a75:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103a78:	eb 51                	jmp    f0103acb <readline+0xa3>
			cprintf("read error: %e\n", c);
f0103a7a:	83 ec 08             	sub    $0x8,%esp
f0103a7d:	50                   	push   %eax
f0103a7e:	8d 83 f0 cf fe ff    	lea    -0x13010(%ebx),%eax
f0103a84:	50                   	push   %eax
f0103a85:	e8 0f f6 ff ff       	call   f0103099 <cprintf>
			return NULL;
f0103a8a:	83 c4 10             	add    $0x10,%esp
f0103a8d:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0103a92:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103a95:	5b                   	pop    %ebx
f0103a96:	5e                   	pop    %esi
f0103a97:	5f                   	pop    %edi
f0103a98:	5d                   	pop    %ebp
f0103a99:	c3                   	ret    
			if (echoing)
f0103a9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0103a9e:	75 05                	jne    f0103aa5 <readline+0x7d>
			i--;
f0103aa0:	83 ef 01             	sub    $0x1,%edi
f0103aa3:	eb 26                	jmp    f0103acb <readline+0xa3>
				cputchar('\b');
f0103aa5:	83 ec 0c             	sub    $0xc,%esp
f0103aa8:	6a 08                	push   $0x8
f0103aaa:	e8 2d cc ff ff       	call   f01006dc <cputchar>
f0103aaf:	83 c4 10             	add    $0x10,%esp
f0103ab2:	eb ec                	jmp    f0103aa0 <readline+0x78>
				cputchar(c);
f0103ab4:	83 ec 0c             	sub    $0xc,%esp
f0103ab7:	56                   	push   %esi
f0103ab8:	e8 1f cc ff ff       	call   f01006dc <cputchar>
f0103abd:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f0103ac0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103ac3:	89 f0                	mov    %esi,%eax
f0103ac5:	88 04 39             	mov    %al,(%ecx,%edi,1)
f0103ac8:	8d 7f 01             	lea    0x1(%edi),%edi
		c = getchar();
f0103acb:	e8 20 cc ff ff       	call   f01006f0 <getchar>
f0103ad0:	89 c6                	mov    %eax,%esi
		if (c < 0) {
f0103ad2:	85 c0                	test   %eax,%eax
f0103ad4:	78 a4                	js     f0103a7a <readline+0x52>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0103ad6:	83 f8 08             	cmp    $0x8,%eax
f0103ad9:	0f 94 c2             	sete   %dl
f0103adc:	83 f8 7f             	cmp    $0x7f,%eax
f0103adf:	0f 94 c0             	sete   %al
f0103ae2:	08 c2                	or     %al,%dl
f0103ae4:	74 04                	je     f0103aea <readline+0xc2>
f0103ae6:	85 ff                	test   %edi,%edi
f0103ae8:	7f b0                	jg     f0103a9a <readline+0x72>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0103aea:	83 fe 1f             	cmp    $0x1f,%esi
f0103aed:	7e 10                	jle    f0103aff <readline+0xd7>
f0103aef:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
f0103af5:	7f 08                	jg     f0103aff <readline+0xd7>
			if (echoing)
f0103af7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0103afb:	74 c3                	je     f0103ac0 <readline+0x98>
f0103afd:	eb b5                	jmp    f0103ab4 <readline+0x8c>
		} else if (c == '\n' || c == '\r') {
f0103aff:	83 fe 0a             	cmp    $0xa,%esi
f0103b02:	74 05                	je     f0103b09 <readline+0xe1>
f0103b04:	83 fe 0d             	cmp    $0xd,%esi
f0103b07:	75 c2                	jne    f0103acb <readline+0xa3>
			if (echoing)
f0103b09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0103b0d:	75 13                	jne    f0103b22 <readline+0xfa>
			buf[i] = 0;
f0103b0f:	c6 84 3b b8 1f 00 00 	movb   $0x0,0x1fb8(%ebx,%edi,1)
f0103b16:	00 
			return buf;
f0103b17:	8d 83 b8 1f 00 00    	lea    0x1fb8(%ebx),%eax
f0103b1d:	e9 70 ff ff ff       	jmp    f0103a92 <readline+0x6a>
				cputchar('\n');
f0103b22:	83 ec 0c             	sub    $0xc,%esp
f0103b25:	6a 0a                	push   $0xa
f0103b27:	e8 b0 cb ff ff       	call   f01006dc <cputchar>
f0103b2c:	83 c4 10             	add    $0x10,%esp
f0103b2f:	eb de                	jmp    f0103b0f <readline+0xe7>

f0103b31 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0103b31:	f3 0f 1e fb          	endbr32 
f0103b35:	55                   	push   %ebp
f0103b36:	89 e5                	mov    %esp,%ebp
f0103b38:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0103b3b:	b8 00 00 00 00       	mov    $0x0,%eax
f0103b40:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0103b44:	74 05                	je     f0103b4b <strlen+0x1a>
		n++;
f0103b46:	83 c0 01             	add    $0x1,%eax
f0103b49:	eb f5                	jmp    f0103b40 <strlen+0xf>
	return n;
}
f0103b4b:	5d                   	pop    %ebp
f0103b4c:	c3                   	ret    

f0103b4d <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0103b4d:	f3 0f 1e fb          	endbr32 
f0103b51:	55                   	push   %ebp
f0103b52:	89 e5                	mov    %esp,%ebp
f0103b54:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103b57:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0103b5a:	b8 00 00 00 00       	mov    $0x0,%eax
f0103b5f:	39 d0                	cmp    %edx,%eax
f0103b61:	74 0d                	je     f0103b70 <strnlen+0x23>
f0103b63:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0103b67:	74 05                	je     f0103b6e <strnlen+0x21>
		n++;
f0103b69:	83 c0 01             	add    $0x1,%eax
f0103b6c:	eb f1                	jmp    f0103b5f <strnlen+0x12>
f0103b6e:	89 c2                	mov    %eax,%edx
	return n;
}
f0103b70:	89 d0                	mov    %edx,%eax
f0103b72:	5d                   	pop    %ebp
f0103b73:	c3                   	ret    

f0103b74 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0103b74:	f3 0f 1e fb          	endbr32 
f0103b78:	55                   	push   %ebp
f0103b79:	89 e5                	mov    %esp,%ebp
f0103b7b:	53                   	push   %ebx
f0103b7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103b7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0103b82:	b8 00 00 00 00       	mov    $0x0,%eax
f0103b87:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f0103b8b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f0103b8e:	83 c0 01             	add    $0x1,%eax
f0103b91:	84 d2                	test   %dl,%dl
f0103b93:	75 f2                	jne    f0103b87 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
f0103b95:	89 c8                	mov    %ecx,%eax
f0103b97:	5b                   	pop    %ebx
f0103b98:	5d                   	pop    %ebp
f0103b99:	c3                   	ret    

f0103b9a <strcat>:

char *
strcat(char *dst, const char *src)
{
f0103b9a:	f3 0f 1e fb          	endbr32 
f0103b9e:	55                   	push   %ebp
f0103b9f:	89 e5                	mov    %esp,%ebp
f0103ba1:	53                   	push   %ebx
f0103ba2:	83 ec 10             	sub    $0x10,%esp
f0103ba5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0103ba8:	53                   	push   %ebx
f0103ba9:	e8 83 ff ff ff       	call   f0103b31 <strlen>
f0103bae:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0103bb1:	ff 75 0c             	pushl  0xc(%ebp)
f0103bb4:	01 d8                	add    %ebx,%eax
f0103bb6:	50                   	push   %eax
f0103bb7:	e8 b8 ff ff ff       	call   f0103b74 <strcpy>
	return dst;
}
f0103bbc:	89 d8                	mov    %ebx,%eax
f0103bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103bc1:	c9                   	leave  
f0103bc2:	c3                   	ret    

f0103bc3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0103bc3:	f3 0f 1e fb          	endbr32 
f0103bc7:	55                   	push   %ebp
f0103bc8:	89 e5                	mov    %esp,%ebp
f0103bca:	56                   	push   %esi
f0103bcb:	53                   	push   %ebx
f0103bcc:	8b 75 08             	mov    0x8(%ebp),%esi
f0103bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103bd2:	89 f3                	mov    %esi,%ebx
f0103bd4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0103bd7:	89 f0                	mov    %esi,%eax
f0103bd9:	39 d8                	cmp    %ebx,%eax
f0103bdb:	74 11                	je     f0103bee <strncpy+0x2b>
		*dst++ = *src;
f0103bdd:	83 c0 01             	add    $0x1,%eax
f0103be0:	0f b6 0a             	movzbl (%edx),%ecx
f0103be3:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0103be6:	80 f9 01             	cmp    $0x1,%cl
f0103be9:	83 da ff             	sbb    $0xffffffff,%edx
f0103bec:	eb eb                	jmp    f0103bd9 <strncpy+0x16>
	}
	return ret;
}
f0103bee:	89 f0                	mov    %esi,%eax
f0103bf0:	5b                   	pop    %ebx
f0103bf1:	5e                   	pop    %esi
f0103bf2:	5d                   	pop    %ebp
f0103bf3:	c3                   	ret    

f0103bf4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0103bf4:	f3 0f 1e fb          	endbr32 
f0103bf8:	55                   	push   %ebp
f0103bf9:	89 e5                	mov    %esp,%ebp
f0103bfb:	56                   	push   %esi
f0103bfc:	53                   	push   %ebx
f0103bfd:	8b 75 08             	mov    0x8(%ebp),%esi
f0103c00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103c03:	8b 55 10             	mov    0x10(%ebp),%edx
f0103c06:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0103c08:	85 d2                	test   %edx,%edx
f0103c0a:	74 21                	je     f0103c2d <strlcpy+0x39>
f0103c0c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f0103c10:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f0103c12:	39 c2                	cmp    %eax,%edx
f0103c14:	74 14                	je     f0103c2a <strlcpy+0x36>
f0103c16:	0f b6 19             	movzbl (%ecx),%ebx
f0103c19:	84 db                	test   %bl,%bl
f0103c1b:	74 0b                	je     f0103c28 <strlcpy+0x34>
			*dst++ = *src++;
f0103c1d:	83 c1 01             	add    $0x1,%ecx
f0103c20:	83 c2 01             	add    $0x1,%edx
f0103c23:	88 5a ff             	mov    %bl,-0x1(%edx)
f0103c26:	eb ea                	jmp    f0103c12 <strlcpy+0x1e>
f0103c28:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0103c2a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0103c2d:	29 f0                	sub    %esi,%eax
}
f0103c2f:	5b                   	pop    %ebx
f0103c30:	5e                   	pop    %esi
f0103c31:	5d                   	pop    %ebp
f0103c32:	c3                   	ret    

f0103c33 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0103c33:	f3 0f 1e fb          	endbr32 
f0103c37:	55                   	push   %ebp
f0103c38:	89 e5                	mov    %esp,%ebp
f0103c3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0103c40:	0f b6 01             	movzbl (%ecx),%eax
f0103c43:	84 c0                	test   %al,%al
f0103c45:	74 0c                	je     f0103c53 <strcmp+0x20>
f0103c47:	3a 02                	cmp    (%edx),%al
f0103c49:	75 08                	jne    f0103c53 <strcmp+0x20>
		p++, q++;
f0103c4b:	83 c1 01             	add    $0x1,%ecx
f0103c4e:	83 c2 01             	add    $0x1,%edx
f0103c51:	eb ed                	jmp    f0103c40 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0103c53:	0f b6 c0             	movzbl %al,%eax
f0103c56:	0f b6 12             	movzbl (%edx),%edx
f0103c59:	29 d0                	sub    %edx,%eax
}
f0103c5b:	5d                   	pop    %ebp
f0103c5c:	c3                   	ret    

f0103c5d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0103c5d:	f3 0f 1e fb          	endbr32 
f0103c61:	55                   	push   %ebp
f0103c62:	89 e5                	mov    %esp,%ebp
f0103c64:	53                   	push   %ebx
f0103c65:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c68:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103c6b:	89 c3                	mov    %eax,%ebx
f0103c6d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0103c70:	eb 06                	jmp    f0103c78 <strncmp+0x1b>
		n--, p++, q++;
f0103c72:	83 c0 01             	add    $0x1,%eax
f0103c75:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0103c78:	39 d8                	cmp    %ebx,%eax
f0103c7a:	74 16                	je     f0103c92 <strncmp+0x35>
f0103c7c:	0f b6 08             	movzbl (%eax),%ecx
f0103c7f:	84 c9                	test   %cl,%cl
f0103c81:	74 04                	je     f0103c87 <strncmp+0x2a>
f0103c83:	3a 0a                	cmp    (%edx),%cl
f0103c85:	74 eb                	je     f0103c72 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0103c87:	0f b6 00             	movzbl (%eax),%eax
f0103c8a:	0f b6 12             	movzbl (%edx),%edx
f0103c8d:	29 d0                	sub    %edx,%eax
}
f0103c8f:	5b                   	pop    %ebx
f0103c90:	5d                   	pop    %ebp
f0103c91:	c3                   	ret    
		return 0;
f0103c92:	b8 00 00 00 00       	mov    $0x0,%eax
f0103c97:	eb f6                	jmp    f0103c8f <strncmp+0x32>

f0103c99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0103c99:	f3 0f 1e fb          	endbr32 
f0103c9d:	55                   	push   %ebp
f0103c9e:	89 e5                	mov    %esp,%ebp
f0103ca0:	8b 45 08             	mov    0x8(%ebp),%eax
f0103ca3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0103ca7:	0f b6 10             	movzbl (%eax),%edx
f0103caa:	84 d2                	test   %dl,%dl
f0103cac:	74 09                	je     f0103cb7 <strchr+0x1e>
		if (*s == c)
f0103cae:	38 ca                	cmp    %cl,%dl
f0103cb0:	74 0a                	je     f0103cbc <strchr+0x23>
	for (; *s; s++)
f0103cb2:	83 c0 01             	add    $0x1,%eax
f0103cb5:	eb f0                	jmp    f0103ca7 <strchr+0xe>
			return (char *) s;
	return 0;
f0103cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103cbc:	5d                   	pop    %ebp
f0103cbd:	c3                   	ret    

f0103cbe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0103cbe:	f3 0f 1e fb          	endbr32 
f0103cc2:	55                   	push   %ebp
f0103cc3:	89 e5                	mov    %esp,%ebp
f0103cc5:	8b 45 08             	mov    0x8(%ebp),%eax
f0103cc8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0103ccc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0103ccf:	38 ca                	cmp    %cl,%dl
f0103cd1:	74 09                	je     f0103cdc <strfind+0x1e>
f0103cd3:	84 d2                	test   %dl,%dl
f0103cd5:	74 05                	je     f0103cdc <strfind+0x1e>
	for (; *s; s++)
f0103cd7:	83 c0 01             	add    $0x1,%eax
f0103cda:	eb f0                	jmp    f0103ccc <strfind+0xe>
			break;
	return (char *) s;
}
f0103cdc:	5d                   	pop    %ebp
f0103cdd:	c3                   	ret    

f0103cde <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0103cde:	f3 0f 1e fb          	endbr32 
f0103ce2:	55                   	push   %ebp
f0103ce3:	89 e5                	mov    %esp,%ebp
f0103ce5:	57                   	push   %edi
f0103ce6:	56                   	push   %esi
f0103ce7:	53                   	push   %ebx
f0103ce8:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103ceb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0103cee:	85 c9                	test   %ecx,%ecx
f0103cf0:	74 31                	je     f0103d23 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0103cf2:	89 f8                	mov    %edi,%eax
f0103cf4:	09 c8                	or     %ecx,%eax
f0103cf6:	a8 03                	test   $0x3,%al
f0103cf8:	75 23                	jne    f0103d1d <memset+0x3f>
		c &= 0xFF;
f0103cfa:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0103cfe:	89 d3                	mov    %edx,%ebx
f0103d00:	c1 e3 08             	shl    $0x8,%ebx
f0103d03:	89 d0                	mov    %edx,%eax
f0103d05:	c1 e0 18             	shl    $0x18,%eax
f0103d08:	89 d6                	mov    %edx,%esi
f0103d0a:	c1 e6 10             	shl    $0x10,%esi
f0103d0d:	09 f0                	or     %esi,%eax
f0103d0f:	09 c2                	or     %eax,%edx
f0103d11:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0103d13:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0103d16:	89 d0                	mov    %edx,%eax
f0103d18:	fc                   	cld    
f0103d19:	f3 ab                	rep stos %eax,%es:(%edi)
f0103d1b:	eb 06                	jmp    f0103d23 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0103d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103d20:	fc                   	cld    
f0103d21:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0103d23:	89 f8                	mov    %edi,%eax
f0103d25:	5b                   	pop    %ebx
f0103d26:	5e                   	pop    %esi
f0103d27:	5f                   	pop    %edi
f0103d28:	5d                   	pop    %ebp
f0103d29:	c3                   	ret    

f0103d2a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0103d2a:	f3 0f 1e fb          	endbr32 
f0103d2e:	55                   	push   %ebp
f0103d2f:	89 e5                	mov    %esp,%ebp
f0103d31:	57                   	push   %edi
f0103d32:	56                   	push   %esi
f0103d33:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d36:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103d39:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0103d3c:	39 c6                	cmp    %eax,%esi
f0103d3e:	73 32                	jae    f0103d72 <memmove+0x48>
f0103d40:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0103d43:	39 c2                	cmp    %eax,%edx
f0103d45:	76 2b                	jbe    f0103d72 <memmove+0x48>
		s += n;
		d += n;
f0103d47:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0103d4a:	89 fe                	mov    %edi,%esi
f0103d4c:	09 ce                	or     %ecx,%esi
f0103d4e:	09 d6                	or     %edx,%esi
f0103d50:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0103d56:	75 0e                	jne    f0103d66 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0103d58:	83 ef 04             	sub    $0x4,%edi
f0103d5b:	8d 72 fc             	lea    -0x4(%edx),%esi
f0103d5e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0103d61:	fd                   	std    
f0103d62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0103d64:	eb 09                	jmp    f0103d6f <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0103d66:	83 ef 01             	sub    $0x1,%edi
f0103d69:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0103d6c:	fd                   	std    
f0103d6d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0103d6f:	fc                   	cld    
f0103d70:	eb 1a                	jmp    f0103d8c <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0103d72:	89 c2                	mov    %eax,%edx
f0103d74:	09 ca                	or     %ecx,%edx
f0103d76:	09 f2                	or     %esi,%edx
f0103d78:	f6 c2 03             	test   $0x3,%dl
f0103d7b:	75 0a                	jne    f0103d87 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0103d7d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0103d80:	89 c7                	mov    %eax,%edi
f0103d82:	fc                   	cld    
f0103d83:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0103d85:	eb 05                	jmp    f0103d8c <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
f0103d87:	89 c7                	mov    %eax,%edi
f0103d89:	fc                   	cld    
f0103d8a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0103d8c:	5e                   	pop    %esi
f0103d8d:	5f                   	pop    %edi
f0103d8e:	5d                   	pop    %ebp
f0103d8f:	c3                   	ret    

f0103d90 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0103d90:	f3 0f 1e fb          	endbr32 
f0103d94:	55                   	push   %ebp
f0103d95:	89 e5                	mov    %esp,%ebp
f0103d97:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0103d9a:	ff 75 10             	pushl  0x10(%ebp)
f0103d9d:	ff 75 0c             	pushl  0xc(%ebp)
f0103da0:	ff 75 08             	pushl  0x8(%ebp)
f0103da3:	e8 82 ff ff ff       	call   f0103d2a <memmove>
}
f0103da8:	c9                   	leave  
f0103da9:	c3                   	ret    

f0103daa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0103daa:	f3 0f 1e fb          	endbr32 
f0103dae:	55                   	push   %ebp
f0103daf:	89 e5                	mov    %esp,%ebp
f0103db1:	56                   	push   %esi
f0103db2:	53                   	push   %ebx
f0103db3:	8b 45 08             	mov    0x8(%ebp),%eax
f0103db6:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103db9:	89 c6                	mov    %eax,%esi
f0103dbb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0103dbe:	39 f0                	cmp    %esi,%eax
f0103dc0:	74 1c                	je     f0103dde <memcmp+0x34>
		if (*s1 != *s2)
f0103dc2:	0f b6 08             	movzbl (%eax),%ecx
f0103dc5:	0f b6 1a             	movzbl (%edx),%ebx
f0103dc8:	38 d9                	cmp    %bl,%cl
f0103dca:	75 08                	jne    f0103dd4 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0103dcc:	83 c0 01             	add    $0x1,%eax
f0103dcf:	83 c2 01             	add    $0x1,%edx
f0103dd2:	eb ea                	jmp    f0103dbe <memcmp+0x14>
			return (int) *s1 - (int) *s2;
f0103dd4:	0f b6 c1             	movzbl %cl,%eax
f0103dd7:	0f b6 db             	movzbl %bl,%ebx
f0103dda:	29 d8                	sub    %ebx,%eax
f0103ddc:	eb 05                	jmp    f0103de3 <memcmp+0x39>
	}

	return 0;
f0103dde:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103de3:	5b                   	pop    %ebx
f0103de4:	5e                   	pop    %esi
f0103de5:	5d                   	pop    %ebp
f0103de6:	c3                   	ret    

f0103de7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0103de7:	f3 0f 1e fb          	endbr32 
f0103deb:	55                   	push   %ebp
f0103dec:	89 e5                	mov    %esp,%ebp
f0103dee:	8b 45 08             	mov    0x8(%ebp),%eax
f0103df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0103df4:	89 c2                	mov    %eax,%edx
f0103df6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0103df9:	39 d0                	cmp    %edx,%eax
f0103dfb:	73 09                	jae    f0103e06 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
f0103dfd:	38 08                	cmp    %cl,(%eax)
f0103dff:	74 05                	je     f0103e06 <memfind+0x1f>
	for (; s < ends; s++)
f0103e01:	83 c0 01             	add    $0x1,%eax
f0103e04:	eb f3                	jmp    f0103df9 <memfind+0x12>
			break;
	return (void *) s;
}
f0103e06:	5d                   	pop    %ebp
f0103e07:	c3                   	ret    

f0103e08 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0103e08:	f3 0f 1e fb          	endbr32 
f0103e0c:	55                   	push   %ebp
f0103e0d:	89 e5                	mov    %esp,%ebp
f0103e0f:	57                   	push   %edi
f0103e10:	56                   	push   %esi
f0103e11:	53                   	push   %ebx
f0103e12:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103e15:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0103e18:	eb 03                	jmp    f0103e1d <strtol+0x15>
		s++;
f0103e1a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0103e1d:	0f b6 01             	movzbl (%ecx),%eax
f0103e20:	3c 20                	cmp    $0x20,%al
f0103e22:	74 f6                	je     f0103e1a <strtol+0x12>
f0103e24:	3c 09                	cmp    $0x9,%al
f0103e26:	74 f2                	je     f0103e1a <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
f0103e28:	3c 2b                	cmp    $0x2b,%al
f0103e2a:	74 2a                	je     f0103e56 <strtol+0x4e>
	int neg = 0;
f0103e2c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0103e31:	3c 2d                	cmp    $0x2d,%al
f0103e33:	74 2b                	je     f0103e60 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0103e35:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0103e3b:	75 0f                	jne    f0103e4c <strtol+0x44>
f0103e3d:	80 39 30             	cmpb   $0x30,(%ecx)
f0103e40:	74 28                	je     f0103e6a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0103e42:	85 db                	test   %ebx,%ebx
f0103e44:	b8 0a 00 00 00       	mov    $0xa,%eax
f0103e49:	0f 44 d8             	cmove  %eax,%ebx
f0103e4c:	b8 00 00 00 00       	mov    $0x0,%eax
f0103e51:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0103e54:	eb 46                	jmp    f0103e9c <strtol+0x94>
		s++;
f0103e56:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0103e59:	bf 00 00 00 00       	mov    $0x0,%edi
f0103e5e:	eb d5                	jmp    f0103e35 <strtol+0x2d>
		s++, neg = 1;
f0103e60:	83 c1 01             	add    $0x1,%ecx
f0103e63:	bf 01 00 00 00       	mov    $0x1,%edi
f0103e68:	eb cb                	jmp    f0103e35 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0103e6a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0103e6e:	74 0e                	je     f0103e7e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0103e70:	85 db                	test   %ebx,%ebx
f0103e72:	75 d8                	jne    f0103e4c <strtol+0x44>
		s++, base = 8;
f0103e74:	83 c1 01             	add    $0x1,%ecx
f0103e77:	bb 08 00 00 00       	mov    $0x8,%ebx
f0103e7c:	eb ce                	jmp    f0103e4c <strtol+0x44>
		s += 2, base = 16;
f0103e7e:	83 c1 02             	add    $0x2,%ecx
f0103e81:	bb 10 00 00 00       	mov    $0x10,%ebx
f0103e86:	eb c4                	jmp    f0103e4c <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0103e88:	0f be d2             	movsbl %dl,%edx
f0103e8b:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0103e8e:	3b 55 10             	cmp    0x10(%ebp),%edx
f0103e91:	7d 3a                	jge    f0103ecd <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0103e93:	83 c1 01             	add    $0x1,%ecx
f0103e96:	0f af 45 10          	imul   0x10(%ebp),%eax
f0103e9a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0103e9c:	0f b6 11             	movzbl (%ecx),%edx
f0103e9f:	8d 72 d0             	lea    -0x30(%edx),%esi
f0103ea2:	89 f3                	mov    %esi,%ebx
f0103ea4:	80 fb 09             	cmp    $0x9,%bl
f0103ea7:	76 df                	jbe    f0103e88 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
f0103ea9:	8d 72 9f             	lea    -0x61(%edx),%esi
f0103eac:	89 f3                	mov    %esi,%ebx
f0103eae:	80 fb 19             	cmp    $0x19,%bl
f0103eb1:	77 08                	ja     f0103ebb <strtol+0xb3>
			dig = *s - 'a' + 10;
f0103eb3:	0f be d2             	movsbl %dl,%edx
f0103eb6:	83 ea 57             	sub    $0x57,%edx
f0103eb9:	eb d3                	jmp    f0103e8e <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
f0103ebb:	8d 72 bf             	lea    -0x41(%edx),%esi
f0103ebe:	89 f3                	mov    %esi,%ebx
f0103ec0:	80 fb 19             	cmp    $0x19,%bl
f0103ec3:	77 08                	ja     f0103ecd <strtol+0xc5>
			dig = *s - 'A' + 10;
f0103ec5:	0f be d2             	movsbl %dl,%edx
f0103ec8:	83 ea 37             	sub    $0x37,%edx
f0103ecb:	eb c1                	jmp    f0103e8e <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
f0103ecd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0103ed1:	74 05                	je     f0103ed8 <strtol+0xd0>
		*endptr = (char *) s;
f0103ed3:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103ed6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0103ed8:	89 c2                	mov    %eax,%edx
f0103eda:	f7 da                	neg    %edx
f0103edc:	85 ff                	test   %edi,%edi
f0103ede:	0f 45 c2             	cmovne %edx,%eax
}
f0103ee1:	5b                   	pop    %ebx
f0103ee2:	5e                   	pop    %esi
f0103ee3:	5f                   	pop    %edi
f0103ee4:	5d                   	pop    %ebp
f0103ee5:	c3                   	ret    
f0103ee6:	66 90                	xchg   %ax,%ax
f0103ee8:	66 90                	xchg   %ax,%ax
f0103eea:	66 90                	xchg   %ax,%ax
f0103eec:	66 90                	xchg   %ax,%ax
f0103eee:	66 90                	xchg   %ax,%ax

f0103ef0 <__udivdi3>:
f0103ef0:	f3 0f 1e fb          	endbr32 
f0103ef4:	55                   	push   %ebp
f0103ef5:	57                   	push   %edi
f0103ef6:	56                   	push   %esi
f0103ef7:	53                   	push   %ebx
f0103ef8:	83 ec 1c             	sub    $0x1c,%esp
f0103efb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0103eff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0103f03:	8b 74 24 34          	mov    0x34(%esp),%esi
f0103f07:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0103f0b:	85 d2                	test   %edx,%edx
f0103f0d:	75 19                	jne    f0103f28 <__udivdi3+0x38>
f0103f0f:	39 f3                	cmp    %esi,%ebx
f0103f11:	76 4d                	jbe    f0103f60 <__udivdi3+0x70>
f0103f13:	31 ff                	xor    %edi,%edi
f0103f15:	89 e8                	mov    %ebp,%eax
f0103f17:	89 f2                	mov    %esi,%edx
f0103f19:	f7 f3                	div    %ebx
f0103f1b:	89 fa                	mov    %edi,%edx
f0103f1d:	83 c4 1c             	add    $0x1c,%esp
f0103f20:	5b                   	pop    %ebx
f0103f21:	5e                   	pop    %esi
f0103f22:	5f                   	pop    %edi
f0103f23:	5d                   	pop    %ebp
f0103f24:	c3                   	ret    
f0103f25:	8d 76 00             	lea    0x0(%esi),%esi
f0103f28:	39 f2                	cmp    %esi,%edx
f0103f2a:	76 14                	jbe    f0103f40 <__udivdi3+0x50>
f0103f2c:	31 ff                	xor    %edi,%edi
f0103f2e:	31 c0                	xor    %eax,%eax
f0103f30:	89 fa                	mov    %edi,%edx
f0103f32:	83 c4 1c             	add    $0x1c,%esp
f0103f35:	5b                   	pop    %ebx
f0103f36:	5e                   	pop    %esi
f0103f37:	5f                   	pop    %edi
f0103f38:	5d                   	pop    %ebp
f0103f39:	c3                   	ret    
f0103f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0103f40:	0f bd fa             	bsr    %edx,%edi
f0103f43:	83 f7 1f             	xor    $0x1f,%edi
f0103f46:	75 48                	jne    f0103f90 <__udivdi3+0xa0>
f0103f48:	39 f2                	cmp    %esi,%edx
f0103f4a:	72 06                	jb     f0103f52 <__udivdi3+0x62>
f0103f4c:	31 c0                	xor    %eax,%eax
f0103f4e:	39 eb                	cmp    %ebp,%ebx
f0103f50:	77 de                	ja     f0103f30 <__udivdi3+0x40>
f0103f52:	b8 01 00 00 00       	mov    $0x1,%eax
f0103f57:	eb d7                	jmp    f0103f30 <__udivdi3+0x40>
f0103f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0103f60:	89 d9                	mov    %ebx,%ecx
f0103f62:	85 db                	test   %ebx,%ebx
f0103f64:	75 0b                	jne    f0103f71 <__udivdi3+0x81>
f0103f66:	b8 01 00 00 00       	mov    $0x1,%eax
f0103f6b:	31 d2                	xor    %edx,%edx
f0103f6d:	f7 f3                	div    %ebx
f0103f6f:	89 c1                	mov    %eax,%ecx
f0103f71:	31 d2                	xor    %edx,%edx
f0103f73:	89 f0                	mov    %esi,%eax
f0103f75:	f7 f1                	div    %ecx
f0103f77:	89 c6                	mov    %eax,%esi
f0103f79:	89 e8                	mov    %ebp,%eax
f0103f7b:	89 f7                	mov    %esi,%edi
f0103f7d:	f7 f1                	div    %ecx
f0103f7f:	89 fa                	mov    %edi,%edx
f0103f81:	83 c4 1c             	add    $0x1c,%esp
f0103f84:	5b                   	pop    %ebx
f0103f85:	5e                   	pop    %esi
f0103f86:	5f                   	pop    %edi
f0103f87:	5d                   	pop    %ebp
f0103f88:	c3                   	ret    
f0103f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0103f90:	89 f9                	mov    %edi,%ecx
f0103f92:	b8 20 00 00 00       	mov    $0x20,%eax
f0103f97:	29 f8                	sub    %edi,%eax
f0103f99:	d3 e2                	shl    %cl,%edx
f0103f9b:	89 54 24 08          	mov    %edx,0x8(%esp)
f0103f9f:	89 c1                	mov    %eax,%ecx
f0103fa1:	89 da                	mov    %ebx,%edx
f0103fa3:	d3 ea                	shr    %cl,%edx
f0103fa5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0103fa9:	09 d1                	or     %edx,%ecx
f0103fab:	89 f2                	mov    %esi,%edx
f0103fad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0103fb1:	89 f9                	mov    %edi,%ecx
f0103fb3:	d3 e3                	shl    %cl,%ebx
f0103fb5:	89 c1                	mov    %eax,%ecx
f0103fb7:	d3 ea                	shr    %cl,%edx
f0103fb9:	89 f9                	mov    %edi,%ecx
f0103fbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0103fbf:	89 eb                	mov    %ebp,%ebx
f0103fc1:	d3 e6                	shl    %cl,%esi
f0103fc3:	89 c1                	mov    %eax,%ecx
f0103fc5:	d3 eb                	shr    %cl,%ebx
f0103fc7:	09 de                	or     %ebx,%esi
f0103fc9:	89 f0                	mov    %esi,%eax
f0103fcb:	f7 74 24 08          	divl   0x8(%esp)
f0103fcf:	89 d6                	mov    %edx,%esi
f0103fd1:	89 c3                	mov    %eax,%ebx
f0103fd3:	f7 64 24 0c          	mull   0xc(%esp)
f0103fd7:	39 d6                	cmp    %edx,%esi
f0103fd9:	72 15                	jb     f0103ff0 <__udivdi3+0x100>
f0103fdb:	89 f9                	mov    %edi,%ecx
f0103fdd:	d3 e5                	shl    %cl,%ebp
f0103fdf:	39 c5                	cmp    %eax,%ebp
f0103fe1:	73 04                	jae    f0103fe7 <__udivdi3+0xf7>
f0103fe3:	39 d6                	cmp    %edx,%esi
f0103fe5:	74 09                	je     f0103ff0 <__udivdi3+0x100>
f0103fe7:	89 d8                	mov    %ebx,%eax
f0103fe9:	31 ff                	xor    %edi,%edi
f0103feb:	e9 40 ff ff ff       	jmp    f0103f30 <__udivdi3+0x40>
f0103ff0:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0103ff3:	31 ff                	xor    %edi,%edi
f0103ff5:	e9 36 ff ff ff       	jmp    f0103f30 <__udivdi3+0x40>
f0103ffa:	66 90                	xchg   %ax,%ax
f0103ffc:	66 90                	xchg   %ax,%ax
f0103ffe:	66 90                	xchg   %ax,%ax

f0104000 <__umoddi3>:
f0104000:	f3 0f 1e fb          	endbr32 
f0104004:	55                   	push   %ebp
f0104005:	57                   	push   %edi
f0104006:	56                   	push   %esi
f0104007:	53                   	push   %ebx
f0104008:	83 ec 1c             	sub    $0x1c,%esp
f010400b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f010400f:	8b 74 24 30          	mov    0x30(%esp),%esi
f0104013:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0104017:	8b 7c 24 38          	mov    0x38(%esp),%edi
f010401b:	85 c0                	test   %eax,%eax
f010401d:	75 19                	jne    f0104038 <__umoddi3+0x38>
f010401f:	39 df                	cmp    %ebx,%edi
f0104021:	76 5d                	jbe    f0104080 <__umoddi3+0x80>
f0104023:	89 f0                	mov    %esi,%eax
f0104025:	89 da                	mov    %ebx,%edx
f0104027:	f7 f7                	div    %edi
f0104029:	89 d0                	mov    %edx,%eax
f010402b:	31 d2                	xor    %edx,%edx
f010402d:	83 c4 1c             	add    $0x1c,%esp
f0104030:	5b                   	pop    %ebx
f0104031:	5e                   	pop    %esi
f0104032:	5f                   	pop    %edi
f0104033:	5d                   	pop    %ebp
f0104034:	c3                   	ret    
f0104035:	8d 76 00             	lea    0x0(%esi),%esi
f0104038:	89 f2                	mov    %esi,%edx
f010403a:	39 d8                	cmp    %ebx,%eax
f010403c:	76 12                	jbe    f0104050 <__umoddi3+0x50>
f010403e:	89 f0                	mov    %esi,%eax
f0104040:	89 da                	mov    %ebx,%edx
f0104042:	83 c4 1c             	add    $0x1c,%esp
f0104045:	5b                   	pop    %ebx
f0104046:	5e                   	pop    %esi
f0104047:	5f                   	pop    %edi
f0104048:	5d                   	pop    %ebp
f0104049:	c3                   	ret    
f010404a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0104050:	0f bd e8             	bsr    %eax,%ebp
f0104053:	83 f5 1f             	xor    $0x1f,%ebp
f0104056:	75 50                	jne    f01040a8 <__umoddi3+0xa8>
f0104058:	39 d8                	cmp    %ebx,%eax
f010405a:	0f 82 e0 00 00 00    	jb     f0104140 <__umoddi3+0x140>
f0104060:	89 d9                	mov    %ebx,%ecx
f0104062:	39 f7                	cmp    %esi,%edi
f0104064:	0f 86 d6 00 00 00    	jbe    f0104140 <__umoddi3+0x140>
f010406a:	89 d0                	mov    %edx,%eax
f010406c:	89 ca                	mov    %ecx,%edx
f010406e:	83 c4 1c             	add    $0x1c,%esp
f0104071:	5b                   	pop    %ebx
f0104072:	5e                   	pop    %esi
f0104073:	5f                   	pop    %edi
f0104074:	5d                   	pop    %ebp
f0104075:	c3                   	ret    
f0104076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010407d:	8d 76 00             	lea    0x0(%esi),%esi
f0104080:	89 fd                	mov    %edi,%ebp
f0104082:	85 ff                	test   %edi,%edi
f0104084:	75 0b                	jne    f0104091 <__umoddi3+0x91>
f0104086:	b8 01 00 00 00       	mov    $0x1,%eax
f010408b:	31 d2                	xor    %edx,%edx
f010408d:	f7 f7                	div    %edi
f010408f:	89 c5                	mov    %eax,%ebp
f0104091:	89 d8                	mov    %ebx,%eax
f0104093:	31 d2                	xor    %edx,%edx
f0104095:	f7 f5                	div    %ebp
f0104097:	89 f0                	mov    %esi,%eax
f0104099:	f7 f5                	div    %ebp
f010409b:	89 d0                	mov    %edx,%eax
f010409d:	31 d2                	xor    %edx,%edx
f010409f:	eb 8c                	jmp    f010402d <__umoddi3+0x2d>
f01040a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01040a8:	89 e9                	mov    %ebp,%ecx
f01040aa:	ba 20 00 00 00       	mov    $0x20,%edx
f01040af:	29 ea                	sub    %ebp,%edx
f01040b1:	d3 e0                	shl    %cl,%eax
f01040b3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01040b7:	89 d1                	mov    %edx,%ecx
f01040b9:	89 f8                	mov    %edi,%eax
f01040bb:	d3 e8                	shr    %cl,%eax
f01040bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f01040c1:	89 54 24 04          	mov    %edx,0x4(%esp)
f01040c5:	8b 54 24 04          	mov    0x4(%esp),%edx
f01040c9:	09 c1                	or     %eax,%ecx
f01040cb:	89 d8                	mov    %ebx,%eax
f01040cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01040d1:	89 e9                	mov    %ebp,%ecx
f01040d3:	d3 e7                	shl    %cl,%edi
f01040d5:	89 d1                	mov    %edx,%ecx
f01040d7:	d3 e8                	shr    %cl,%eax
f01040d9:	89 e9                	mov    %ebp,%ecx
f01040db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01040df:	d3 e3                	shl    %cl,%ebx
f01040e1:	89 c7                	mov    %eax,%edi
f01040e3:	89 d1                	mov    %edx,%ecx
f01040e5:	89 f0                	mov    %esi,%eax
f01040e7:	d3 e8                	shr    %cl,%eax
f01040e9:	89 e9                	mov    %ebp,%ecx
f01040eb:	89 fa                	mov    %edi,%edx
f01040ed:	d3 e6                	shl    %cl,%esi
f01040ef:	09 d8                	or     %ebx,%eax
f01040f1:	f7 74 24 08          	divl   0x8(%esp)
f01040f5:	89 d1                	mov    %edx,%ecx
f01040f7:	89 f3                	mov    %esi,%ebx
f01040f9:	f7 64 24 0c          	mull   0xc(%esp)
f01040fd:	89 c6                	mov    %eax,%esi
f01040ff:	89 d7                	mov    %edx,%edi
f0104101:	39 d1                	cmp    %edx,%ecx
f0104103:	72 06                	jb     f010410b <__umoddi3+0x10b>
f0104105:	75 10                	jne    f0104117 <__umoddi3+0x117>
f0104107:	39 c3                	cmp    %eax,%ebx
f0104109:	73 0c                	jae    f0104117 <__umoddi3+0x117>
f010410b:	2b 44 24 0c          	sub    0xc(%esp),%eax
f010410f:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0104113:	89 d7                	mov    %edx,%edi
f0104115:	89 c6                	mov    %eax,%esi
f0104117:	89 ca                	mov    %ecx,%edx
f0104119:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f010411e:	29 f3                	sub    %esi,%ebx
f0104120:	19 fa                	sbb    %edi,%edx
f0104122:	89 d0                	mov    %edx,%eax
f0104124:	d3 e0                	shl    %cl,%eax
f0104126:	89 e9                	mov    %ebp,%ecx
f0104128:	d3 eb                	shr    %cl,%ebx
f010412a:	d3 ea                	shr    %cl,%edx
f010412c:	09 d8                	or     %ebx,%eax
f010412e:	83 c4 1c             	add    $0x1c,%esp
f0104131:	5b                   	pop    %ebx
f0104132:	5e                   	pop    %esi
f0104133:	5f                   	pop    %edi
f0104134:	5d                   	pop    %ebp
f0104135:	c3                   	ret    
f0104136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010413d:	8d 76 00             	lea    0x0(%esi),%esi
f0104140:	29 fe                	sub    %edi,%esi
f0104142:	19 c3                	sbb    %eax,%ebx
f0104144:	89 f2                	mov    %esi,%edx
f0104146:	89 d9                	mov    %ebx,%ecx
f0104148:	e9 1d ff ff ff       	jmp    f010406a <__umoddi3+0x6a>
