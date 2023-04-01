
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
f0100015:	b8 00 e0 18 00       	mov    $0x18e000,%eax
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
f0100034:	bc 00 b0 11 f0       	mov    $0xf011b000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 02 00 00 00       	call   f0100040 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <i386_init>:
#include <kern/trap.h>


void
i386_init(void)
{
f0100040:	f3 0f 1e fb          	endbr32 
f0100044:	55                   	push   %ebp
f0100045:	89 e5                	mov    %esp,%ebp
f0100047:	53                   	push   %ebx
f0100048:	83 ec 08             	sub    $0x8,%esp
f010004b:	e8 23 01 00 00       	call   f0100173 <__x86.get_pc_thunk.bx>
f0100050:	81 c3 cc cf 08 00    	add    $0x8cfcc,%ebx
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f0100056:	c7 c0 10 00 19 f0    	mov    $0xf0190010,%eax
f010005c:	c7 c2 00 f1 18 f0    	mov    $0xf018f100,%edx
f0100062:	29 d0                	sub    %edx,%eax
f0100064:	50                   	push   %eax
f0100065:	6a 00                	push   $0x0
f0100067:	52                   	push   %edx
f0100068:	e8 1b 51 00 00       	call   f0105188 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f010006d:	e8 5c 05 00 00       	call   f01005ce <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f0100072:	83 c4 08             	add    $0x8,%esp
f0100075:	68 ac 1a 00 00       	push   $0x1aac
f010007a:	8d 83 e4 85 f7 ff    	lea    -0x87a1c(%ebx),%eax
f0100080:	50                   	push   %eax
f0100081:	e8 3e 3a 00 00       	call   f0103ac4 <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f0100086:	e8 23 14 00 00       	call   f01014ae <mem_init>

	// Lab 3 user environment initialization functions
	env_init();
f010008b:	e8 0c 33 00 00       	call   f010339c <env_init>
	trap_init();
f0100090:	e8 ea 3a 00 00       	call   f0103b7f <trap_init>

#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
f0100095:	83 c4 08             	add    $0x8,%esp
f0100098:	6a 00                	push   $0x0
f010009a:	ff b3 f8 ff ff ff    	pushl  -0x8(%ebx)
f01000a0:	e8 dd 34 00 00       	call   f0103582 <env_create>
	// Touch all you want.
	ENV_CREATE(user_hello, ENV_TYPE_USER);
#endif // TEST*

	// We only have one user environment for now, so just run it.
	env_run(&envs[0]);
f01000a5:	83 c4 04             	add    $0x4,%esp
f01000a8:	c7 c0 4c f3 18 f0    	mov    $0xf018f34c,%eax
f01000ae:	ff 30                	pushl  (%eax)
f01000b0:	e8 ff 38 00 00       	call   f01039b4 <env_run>

f01000b5 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f01000b5:	f3 0f 1e fb          	endbr32 
f01000b9:	55                   	push   %ebp
f01000ba:	89 e5                	mov    %esp,%ebp
f01000bc:	57                   	push   %edi
f01000bd:	56                   	push   %esi
f01000be:	53                   	push   %ebx
f01000bf:	83 ec 0c             	sub    $0xc,%esp
f01000c2:	e8 ac 00 00 00       	call   f0100173 <__x86.get_pc_thunk.bx>
f01000c7:	81 c3 55 cf 08 00    	add    $0x8cf55,%ebx
f01000cd:	8b 7d 10             	mov    0x10(%ebp),%edi
	va_list ap;

	if (panicstr)
f01000d0:	c7 c0 00 00 19 f0    	mov    $0xf0190000,%eax
f01000d6:	83 38 00             	cmpl   $0x0,(%eax)
f01000d9:	74 0f                	je     f01000ea <_panic+0x35>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000db:	83 ec 0c             	sub    $0xc,%esp
f01000de:	6a 00                	push   $0x0
f01000e0:	e8 5f 08 00 00       	call   f0100944 <monitor>
f01000e5:	83 c4 10             	add    $0x10,%esp
f01000e8:	eb f1                	jmp    f01000db <_panic+0x26>
	panicstr = fmt;
f01000ea:	89 38                	mov    %edi,(%eax)
	asm volatile("cli; cld");
f01000ec:	fa                   	cli    
f01000ed:	fc                   	cld    
	va_start(ap, fmt);
f01000ee:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel panic at %s:%d: ", file, line);
f01000f1:	83 ec 04             	sub    $0x4,%esp
f01000f4:	ff 75 0c             	pushl  0xc(%ebp)
f01000f7:	ff 75 08             	pushl  0x8(%ebp)
f01000fa:	8d 83 ff 85 f7 ff    	lea    -0x87a01(%ebx),%eax
f0100100:	50                   	push   %eax
f0100101:	e8 be 39 00 00       	call   f0103ac4 <cprintf>
	vcprintf(fmt, ap);
f0100106:	83 c4 08             	add    $0x8,%esp
f0100109:	56                   	push   %esi
f010010a:	57                   	push   %edi
f010010b:	e8 79 39 00 00       	call   f0103a89 <vcprintf>
	cprintf("\n");
f0100110:	8d 83 78 8d f7 ff    	lea    -0x87288(%ebx),%eax
f0100116:	89 04 24             	mov    %eax,(%esp)
f0100119:	e8 a6 39 00 00       	call   f0103ac4 <cprintf>
f010011e:	83 c4 10             	add    $0x10,%esp
f0100121:	eb b8                	jmp    f01000db <_panic+0x26>

f0100123 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100123:	f3 0f 1e fb          	endbr32 
f0100127:	55                   	push   %ebp
f0100128:	89 e5                	mov    %esp,%ebp
f010012a:	56                   	push   %esi
f010012b:	53                   	push   %ebx
f010012c:	e8 42 00 00 00       	call   f0100173 <__x86.get_pc_thunk.bx>
f0100131:	81 c3 eb ce 08 00    	add    $0x8ceeb,%ebx
	va_list ap;

	va_start(ap, fmt);
f0100137:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel warning at %s:%d: ", file, line);
f010013a:	83 ec 04             	sub    $0x4,%esp
f010013d:	ff 75 0c             	pushl  0xc(%ebp)
f0100140:	ff 75 08             	pushl  0x8(%ebp)
f0100143:	8d 83 17 86 f7 ff    	lea    -0x879e9(%ebx),%eax
f0100149:	50                   	push   %eax
f010014a:	e8 75 39 00 00       	call   f0103ac4 <cprintf>
	vcprintf(fmt, ap);
f010014f:	83 c4 08             	add    $0x8,%esp
f0100152:	56                   	push   %esi
f0100153:	ff 75 10             	pushl  0x10(%ebp)
f0100156:	e8 2e 39 00 00       	call   f0103a89 <vcprintf>
	cprintf("\n");
f010015b:	8d 83 78 8d f7 ff    	lea    -0x87288(%ebx),%eax
f0100161:	89 04 24             	mov    %eax,(%esp)
f0100164:	e8 5b 39 00 00       	call   f0103ac4 <cprintf>
	va_end(ap);
}
f0100169:	83 c4 10             	add    $0x10,%esp
f010016c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010016f:	5b                   	pop    %ebx
f0100170:	5e                   	pop    %esi
f0100171:	5d                   	pop    %ebp
f0100172:	c3                   	ret    

f0100173 <__x86.get_pc_thunk.bx>:
f0100173:	8b 1c 24             	mov    (%esp),%ebx
f0100176:	c3                   	ret    

f0100177 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100177:	f3 0f 1e fb          	endbr32 

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010017b:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100180:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100181:	a8 01                	test   $0x1,%al
f0100183:	74 0a                	je     f010018f <serial_proc_data+0x18>
f0100185:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010018a:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f010018b:	0f b6 c0             	movzbl %al,%eax
f010018e:	c3                   	ret    
		return -1;
f010018f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100194:	c3                   	ret    

f0100195 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100195:	55                   	push   %ebp
f0100196:	89 e5                	mov    %esp,%ebp
f0100198:	57                   	push   %edi
f0100199:	56                   	push   %esi
f010019a:	53                   	push   %ebx
f010019b:	83 ec 1c             	sub    $0x1c,%esp
f010019e:	e8 88 05 00 00       	call   f010072b <__x86.get_pc_thunk.si>
f01001a3:	81 c6 79 ce 08 00    	add    $0x8ce79,%esi
f01001a9:	89 c7                	mov    %eax,%edi
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
f01001ab:	8d 1d 04 21 00 00    	lea    0x2104,%ebx
f01001b1:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f01001b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01001b7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	while ((c = (*proc)()) != -1) {
f01001ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01001bd:	ff d0                	call   *%eax
f01001bf:	83 f8 ff             	cmp    $0xffffffff,%eax
f01001c2:	74 2b                	je     f01001ef <cons_intr+0x5a>
		if (c == 0)
f01001c4:	85 c0                	test   %eax,%eax
f01001c6:	74 f2                	je     f01001ba <cons_intr+0x25>
		cons.buf[cons.wpos++] = c;
f01001c8:	8b 8c 1e 04 02 00 00 	mov    0x204(%esi,%ebx,1),%ecx
f01001cf:	8d 51 01             	lea    0x1(%ecx),%edx
f01001d2:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01001d5:	88 04 0f             	mov    %al,(%edi,%ecx,1)
		if (cons.wpos == CONSBUFSIZE)
f01001d8:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01001de:	b8 00 00 00 00       	mov    $0x0,%eax
f01001e3:	0f 44 d0             	cmove  %eax,%edx
f01001e6:	89 94 1e 04 02 00 00 	mov    %edx,0x204(%esi,%ebx,1)
f01001ed:	eb cb                	jmp    f01001ba <cons_intr+0x25>
	}
}
f01001ef:	83 c4 1c             	add    $0x1c,%esp
f01001f2:	5b                   	pop    %ebx
f01001f3:	5e                   	pop    %esi
f01001f4:	5f                   	pop    %edi
f01001f5:	5d                   	pop    %ebp
f01001f6:	c3                   	ret    

f01001f7 <kbd_proc_data>:
{
f01001f7:	f3 0f 1e fb          	endbr32 
f01001fb:	55                   	push   %ebp
f01001fc:	89 e5                	mov    %esp,%ebp
f01001fe:	56                   	push   %esi
f01001ff:	53                   	push   %ebx
f0100200:	e8 6e ff ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0100205:	81 c3 17 ce 08 00    	add    $0x8ce17,%ebx
f010020b:	ba 64 00 00 00       	mov    $0x64,%edx
f0100210:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f0100211:	a8 01                	test   $0x1,%al
f0100213:	0f 84 fb 00 00 00    	je     f0100314 <kbd_proc_data+0x11d>
	if (stat & KBS_TERR)
f0100219:	a8 20                	test   $0x20,%al
f010021b:	0f 85 fa 00 00 00    	jne    f010031b <kbd_proc_data+0x124>
f0100221:	ba 60 00 00 00       	mov    $0x60,%edx
f0100226:	ec                   	in     (%dx),%al
f0100227:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100229:	3c e0                	cmp    $0xe0,%al
f010022b:	74 64                	je     f0100291 <kbd_proc_data+0x9a>
	} else if (data & 0x80) {
f010022d:	84 c0                	test   %al,%al
f010022f:	78 75                	js     f01002a6 <kbd_proc_data+0xaf>
	} else if (shift & E0ESC) {
f0100231:	8b 8b e4 20 00 00    	mov    0x20e4(%ebx),%ecx
f0100237:	f6 c1 40             	test   $0x40,%cl
f010023a:	74 0e                	je     f010024a <kbd_proc_data+0x53>
		data |= 0x80;
f010023c:	83 c8 80             	or     $0xffffff80,%eax
f010023f:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100241:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100244:	89 8b e4 20 00 00    	mov    %ecx,0x20e4(%ebx)
	shift |= shiftcode[data];
f010024a:	0f b6 d2             	movzbl %dl,%edx
f010024d:	0f b6 84 13 64 87 f7 	movzbl -0x8789c(%ebx,%edx,1),%eax
f0100254:	ff 
f0100255:	0b 83 e4 20 00 00    	or     0x20e4(%ebx),%eax
	shift ^= togglecode[data];
f010025b:	0f b6 8c 13 64 86 f7 	movzbl -0x8799c(%ebx,%edx,1),%ecx
f0100262:	ff 
f0100263:	31 c8                	xor    %ecx,%eax
f0100265:	89 83 e4 20 00 00    	mov    %eax,0x20e4(%ebx)
	c = charcode[shift & (CTL | SHIFT)][data];
f010026b:	89 c1                	mov    %eax,%ecx
f010026d:	83 e1 03             	and    $0x3,%ecx
f0100270:	8b 8c 8b 04 20 00 00 	mov    0x2004(%ebx,%ecx,4),%ecx
f0100277:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f010027b:	0f b6 f2             	movzbl %dl,%esi
	if (shift & CAPSLOCK) {
f010027e:	a8 08                	test   $0x8,%al
f0100280:	74 65                	je     f01002e7 <kbd_proc_data+0xf0>
		if ('a' <= c && c <= 'z')
f0100282:	89 f2                	mov    %esi,%edx
f0100284:	8d 4e 9f             	lea    -0x61(%esi),%ecx
f0100287:	83 f9 19             	cmp    $0x19,%ecx
f010028a:	77 4f                	ja     f01002db <kbd_proc_data+0xe4>
			c += 'A' - 'a';
f010028c:	83 ee 20             	sub    $0x20,%esi
f010028f:	eb 0c                	jmp    f010029d <kbd_proc_data+0xa6>
		shift |= E0ESC;
f0100291:	83 8b e4 20 00 00 40 	orl    $0x40,0x20e4(%ebx)
		return 0;
f0100298:	be 00 00 00 00       	mov    $0x0,%esi
}
f010029d:	89 f0                	mov    %esi,%eax
f010029f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01002a2:	5b                   	pop    %ebx
f01002a3:	5e                   	pop    %esi
f01002a4:	5d                   	pop    %ebp
f01002a5:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f01002a6:	8b 8b e4 20 00 00    	mov    0x20e4(%ebx),%ecx
f01002ac:	89 ce                	mov    %ecx,%esi
f01002ae:	83 e6 40             	and    $0x40,%esi
f01002b1:	83 e0 7f             	and    $0x7f,%eax
f01002b4:	85 f6                	test   %esi,%esi
f01002b6:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01002b9:	0f b6 d2             	movzbl %dl,%edx
f01002bc:	0f b6 84 13 64 87 f7 	movzbl -0x8789c(%ebx,%edx,1),%eax
f01002c3:	ff 
f01002c4:	83 c8 40             	or     $0x40,%eax
f01002c7:	0f b6 c0             	movzbl %al,%eax
f01002ca:	f7 d0                	not    %eax
f01002cc:	21 c8                	and    %ecx,%eax
f01002ce:	89 83 e4 20 00 00    	mov    %eax,0x20e4(%ebx)
		return 0;
f01002d4:	be 00 00 00 00       	mov    $0x0,%esi
f01002d9:	eb c2                	jmp    f010029d <kbd_proc_data+0xa6>
		else if ('A' <= c && c <= 'Z')
f01002db:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01002de:	8d 4e 20             	lea    0x20(%esi),%ecx
f01002e1:	83 fa 1a             	cmp    $0x1a,%edx
f01002e4:	0f 42 f1             	cmovb  %ecx,%esi
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01002e7:	f7 d0                	not    %eax
f01002e9:	a8 06                	test   $0x6,%al
f01002eb:	75 b0                	jne    f010029d <kbd_proc_data+0xa6>
f01002ed:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
f01002f3:	75 a8                	jne    f010029d <kbd_proc_data+0xa6>
		cprintf("Rebooting!\n");
f01002f5:	83 ec 0c             	sub    $0xc,%esp
f01002f8:	8d 83 31 86 f7 ff    	lea    -0x879cf(%ebx),%eax
f01002fe:	50                   	push   %eax
f01002ff:	e8 c0 37 00 00       	call   f0103ac4 <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100304:	b8 03 00 00 00       	mov    $0x3,%eax
f0100309:	ba 92 00 00 00       	mov    $0x92,%edx
f010030e:	ee                   	out    %al,(%dx)
}
f010030f:	83 c4 10             	add    $0x10,%esp
f0100312:	eb 89                	jmp    f010029d <kbd_proc_data+0xa6>
		return -1;
f0100314:	be ff ff ff ff       	mov    $0xffffffff,%esi
f0100319:	eb 82                	jmp    f010029d <kbd_proc_data+0xa6>
		return -1;
f010031b:	be ff ff ff ff       	mov    $0xffffffff,%esi
f0100320:	e9 78 ff ff ff       	jmp    f010029d <kbd_proc_data+0xa6>

f0100325 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100325:	55                   	push   %ebp
f0100326:	89 e5                	mov    %esp,%ebp
f0100328:	57                   	push   %edi
f0100329:	56                   	push   %esi
f010032a:	53                   	push   %ebx
f010032b:	83 ec 1c             	sub    $0x1c,%esp
f010032e:	e8 40 fe ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0100333:	81 c3 e9 cc 08 00    	add    $0x8cce9,%ebx
f0100339:	89 c7                	mov    %eax,%edi
	for (i = 0;
f010033b:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100340:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100345:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010034a:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f010034b:	a8 20                	test   $0x20,%al
f010034d:	75 13                	jne    f0100362 <cons_putc+0x3d>
f010034f:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100355:	7f 0b                	jg     f0100362 <cons_putc+0x3d>
f0100357:	89 ca                	mov    %ecx,%edx
f0100359:	ec                   	in     (%dx),%al
f010035a:	ec                   	in     (%dx),%al
f010035b:	ec                   	in     (%dx),%al
f010035c:	ec                   	in     (%dx),%al
	     i++)
f010035d:	83 c6 01             	add    $0x1,%esi
f0100360:	eb e3                	jmp    f0100345 <cons_putc+0x20>
	outb(COM1 + COM_TX, c);
f0100362:	89 f8                	mov    %edi,%eax
f0100364:	88 45 e7             	mov    %al,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100367:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010036c:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010036d:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100372:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100377:	ba 79 03 00 00       	mov    $0x379,%edx
f010037c:	ec                   	in     (%dx),%al
f010037d:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100383:	7f 0f                	jg     f0100394 <cons_putc+0x6f>
f0100385:	84 c0                	test   %al,%al
f0100387:	78 0b                	js     f0100394 <cons_putc+0x6f>
f0100389:	89 ca                	mov    %ecx,%edx
f010038b:	ec                   	in     (%dx),%al
f010038c:	ec                   	in     (%dx),%al
f010038d:	ec                   	in     (%dx),%al
f010038e:	ec                   	in     (%dx),%al
f010038f:	83 c6 01             	add    $0x1,%esi
f0100392:	eb e3                	jmp    f0100377 <cons_putc+0x52>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100394:	ba 78 03 00 00       	mov    $0x378,%edx
f0100399:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f010039d:	ee                   	out    %al,(%dx)
f010039e:	ba 7a 03 00 00       	mov    $0x37a,%edx
f01003a3:	b8 0d 00 00 00       	mov    $0xd,%eax
f01003a8:	ee                   	out    %al,(%dx)
f01003a9:	b8 08 00 00 00       	mov    $0x8,%eax
f01003ae:	ee                   	out    %al,(%dx)
		c |= 0x0700;
f01003af:	89 f8                	mov    %edi,%eax
f01003b1:	80 cc 07             	or     $0x7,%ah
f01003b4:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f01003ba:	0f 44 f8             	cmove  %eax,%edi
	switch (c & 0xff) {
f01003bd:	89 f8                	mov    %edi,%eax
f01003bf:	0f b6 c0             	movzbl %al,%eax
f01003c2:	89 f9                	mov    %edi,%ecx
f01003c4:	80 f9 0a             	cmp    $0xa,%cl
f01003c7:	0f 84 e2 00 00 00    	je     f01004af <cons_putc+0x18a>
f01003cd:	83 f8 0a             	cmp    $0xa,%eax
f01003d0:	7f 46                	jg     f0100418 <cons_putc+0xf3>
f01003d2:	83 f8 08             	cmp    $0x8,%eax
f01003d5:	0f 84 a8 00 00 00    	je     f0100483 <cons_putc+0x15e>
f01003db:	83 f8 09             	cmp    $0x9,%eax
f01003de:	0f 85 d8 00 00 00    	jne    f01004bc <cons_putc+0x197>
		cons_putc(' ');
f01003e4:	b8 20 00 00 00       	mov    $0x20,%eax
f01003e9:	e8 37 ff ff ff       	call   f0100325 <cons_putc>
		cons_putc(' ');
f01003ee:	b8 20 00 00 00       	mov    $0x20,%eax
f01003f3:	e8 2d ff ff ff       	call   f0100325 <cons_putc>
		cons_putc(' ');
f01003f8:	b8 20 00 00 00       	mov    $0x20,%eax
f01003fd:	e8 23 ff ff ff       	call   f0100325 <cons_putc>
		cons_putc(' ');
f0100402:	b8 20 00 00 00       	mov    $0x20,%eax
f0100407:	e8 19 ff ff ff       	call   f0100325 <cons_putc>
		cons_putc(' ');
f010040c:	b8 20 00 00 00       	mov    $0x20,%eax
f0100411:	e8 0f ff ff ff       	call   f0100325 <cons_putc>
		break;
f0100416:	eb 26                	jmp    f010043e <cons_putc+0x119>
	switch (c & 0xff) {
f0100418:	83 f8 0d             	cmp    $0xd,%eax
f010041b:	0f 85 9b 00 00 00    	jne    f01004bc <cons_putc+0x197>
		crt_pos -= (crt_pos % CRT_COLS);
f0100421:	0f b7 83 0c 23 00 00 	movzwl 0x230c(%ebx),%eax
f0100428:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010042e:	c1 e8 16             	shr    $0x16,%eax
f0100431:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100434:	c1 e0 04             	shl    $0x4,%eax
f0100437:	66 89 83 0c 23 00 00 	mov    %ax,0x230c(%ebx)
	if (crt_pos >= CRT_SIZE) {
f010043e:	66 81 bb 0c 23 00 00 	cmpw   $0x7cf,0x230c(%ebx)
f0100445:	cf 07 
f0100447:	0f 87 92 00 00 00    	ja     f01004df <cons_putc+0x1ba>
	outb(addr_6845, 14);
f010044d:	8b 8b 14 23 00 00    	mov    0x2314(%ebx),%ecx
f0100453:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100458:	89 ca                	mov    %ecx,%edx
f010045a:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010045b:	0f b7 9b 0c 23 00 00 	movzwl 0x230c(%ebx),%ebx
f0100462:	8d 71 01             	lea    0x1(%ecx),%esi
f0100465:	89 d8                	mov    %ebx,%eax
f0100467:	66 c1 e8 08          	shr    $0x8,%ax
f010046b:	89 f2                	mov    %esi,%edx
f010046d:	ee                   	out    %al,(%dx)
f010046e:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100473:	89 ca                	mov    %ecx,%edx
f0100475:	ee                   	out    %al,(%dx)
f0100476:	89 d8                	mov    %ebx,%eax
f0100478:	89 f2                	mov    %esi,%edx
f010047a:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010047b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010047e:	5b                   	pop    %ebx
f010047f:	5e                   	pop    %esi
f0100480:	5f                   	pop    %edi
f0100481:	5d                   	pop    %ebp
f0100482:	c3                   	ret    
		if (crt_pos > 0) {
f0100483:	0f b7 83 0c 23 00 00 	movzwl 0x230c(%ebx),%eax
f010048a:	66 85 c0             	test   %ax,%ax
f010048d:	74 be                	je     f010044d <cons_putc+0x128>
			crt_pos--;
f010048f:	83 e8 01             	sub    $0x1,%eax
f0100492:	66 89 83 0c 23 00 00 	mov    %ax,0x230c(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100499:	0f b7 c0             	movzwl %ax,%eax
f010049c:	89 fa                	mov    %edi,%edx
f010049e:	b2 00                	mov    $0x0,%dl
f01004a0:	83 ca 20             	or     $0x20,%edx
f01004a3:	8b 8b 10 23 00 00    	mov    0x2310(%ebx),%ecx
f01004a9:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
f01004ad:	eb 8f                	jmp    f010043e <cons_putc+0x119>
		crt_pos += CRT_COLS;
f01004af:	66 83 83 0c 23 00 00 	addw   $0x50,0x230c(%ebx)
f01004b6:	50 
f01004b7:	e9 65 ff ff ff       	jmp    f0100421 <cons_putc+0xfc>
		crt_buf[crt_pos++] = c;		/* write the character */
f01004bc:	0f b7 83 0c 23 00 00 	movzwl 0x230c(%ebx),%eax
f01004c3:	8d 50 01             	lea    0x1(%eax),%edx
f01004c6:	66 89 93 0c 23 00 00 	mov    %dx,0x230c(%ebx)
f01004cd:	0f b7 c0             	movzwl %ax,%eax
f01004d0:	8b 93 10 23 00 00    	mov    0x2310(%ebx),%edx
f01004d6:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
f01004da:	e9 5f ff ff ff       	jmp    f010043e <cons_putc+0x119>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01004df:	8b 83 10 23 00 00    	mov    0x2310(%ebx),%eax
f01004e5:	83 ec 04             	sub    $0x4,%esp
f01004e8:	68 00 0f 00 00       	push   $0xf00
f01004ed:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01004f3:	52                   	push   %edx
f01004f4:	50                   	push   %eax
f01004f5:	e8 da 4c 00 00       	call   f01051d4 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01004fa:	8b 93 10 23 00 00    	mov    0x2310(%ebx),%edx
f0100500:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100506:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f010050c:	83 c4 10             	add    $0x10,%esp
f010050f:	66 c7 00 20 07       	movw   $0x720,(%eax)
f0100514:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100517:	39 d0                	cmp    %edx,%eax
f0100519:	75 f4                	jne    f010050f <cons_putc+0x1ea>
		crt_pos -= CRT_COLS;
f010051b:	66 83 ab 0c 23 00 00 	subw   $0x50,0x230c(%ebx)
f0100522:	50 
f0100523:	e9 25 ff ff ff       	jmp    f010044d <cons_putc+0x128>

f0100528 <serial_intr>:
{
f0100528:	f3 0f 1e fb          	endbr32 
f010052c:	e8 f6 01 00 00       	call   f0100727 <__x86.get_pc_thunk.ax>
f0100531:	05 eb ca 08 00       	add    $0x8caeb,%eax
	if (serial_exists)
f0100536:	80 b8 18 23 00 00 00 	cmpb   $0x0,0x2318(%eax)
f010053d:	75 01                	jne    f0100540 <serial_intr+0x18>
f010053f:	c3                   	ret    
{
f0100540:	55                   	push   %ebp
f0100541:	89 e5                	mov    %esp,%ebp
f0100543:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100546:	8d 80 5b 31 f7 ff    	lea    -0x8cea5(%eax),%eax
f010054c:	e8 44 fc ff ff       	call   f0100195 <cons_intr>
}
f0100551:	c9                   	leave  
f0100552:	c3                   	ret    

f0100553 <kbd_intr>:
{
f0100553:	f3 0f 1e fb          	endbr32 
f0100557:	55                   	push   %ebp
f0100558:	89 e5                	mov    %esp,%ebp
f010055a:	83 ec 08             	sub    $0x8,%esp
f010055d:	e8 c5 01 00 00       	call   f0100727 <__x86.get_pc_thunk.ax>
f0100562:	05 ba ca 08 00       	add    $0x8caba,%eax
	cons_intr(kbd_proc_data);
f0100567:	8d 80 db 31 f7 ff    	lea    -0x8ce25(%eax),%eax
f010056d:	e8 23 fc ff ff       	call   f0100195 <cons_intr>
}
f0100572:	c9                   	leave  
f0100573:	c3                   	ret    

f0100574 <cons_getc>:
{
f0100574:	f3 0f 1e fb          	endbr32 
f0100578:	55                   	push   %ebp
f0100579:	89 e5                	mov    %esp,%ebp
f010057b:	53                   	push   %ebx
f010057c:	83 ec 04             	sub    $0x4,%esp
f010057f:	e8 ef fb ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0100584:	81 c3 98 ca 08 00    	add    $0x8ca98,%ebx
	serial_intr();
f010058a:	e8 99 ff ff ff       	call   f0100528 <serial_intr>
	kbd_intr();
f010058f:	e8 bf ff ff ff       	call   f0100553 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100594:	8b 83 04 23 00 00    	mov    0x2304(%ebx),%eax
	return 0;
f010059a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f010059f:	3b 83 08 23 00 00    	cmp    0x2308(%ebx),%eax
f01005a5:	74 1f                	je     f01005c6 <cons_getc+0x52>
		c = cons.buf[cons.rpos++];
f01005a7:	8d 48 01             	lea    0x1(%eax),%ecx
f01005aa:	0f b6 94 03 04 21 00 	movzbl 0x2104(%ebx,%eax,1),%edx
f01005b1:	00 
			cons.rpos = 0;
f01005b2:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f01005b8:	b8 00 00 00 00       	mov    $0x0,%eax
f01005bd:	0f 44 c8             	cmove  %eax,%ecx
f01005c0:	89 8b 04 23 00 00    	mov    %ecx,0x2304(%ebx)
}
f01005c6:	89 d0                	mov    %edx,%eax
f01005c8:	83 c4 04             	add    $0x4,%esp
f01005cb:	5b                   	pop    %ebx
f01005cc:	5d                   	pop    %ebp
f01005cd:	c3                   	ret    

f01005ce <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f01005ce:	f3 0f 1e fb          	endbr32 
f01005d2:	55                   	push   %ebp
f01005d3:	89 e5                	mov    %esp,%ebp
f01005d5:	57                   	push   %edi
f01005d6:	56                   	push   %esi
f01005d7:	53                   	push   %ebx
f01005d8:	83 ec 1c             	sub    $0x1c,%esp
f01005db:	e8 93 fb ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f01005e0:	81 c3 3c ca 08 00    	add    $0x8ca3c,%ebx
	was = *cp;
f01005e6:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01005ed:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01005f4:	5a a5 
	if (*cp != 0xA55A) {
f01005f6:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01005fd:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100601:	0f 84 bc 00 00 00    	je     f01006c3 <cons_init+0xf5>
		addr_6845 = MONO_BASE;
f0100607:	c7 83 14 23 00 00 b4 	movl   $0x3b4,0x2314(%ebx)
f010060e:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f0100611:	c7 45 e4 00 00 0b f0 	movl   $0xf00b0000,-0x1c(%ebp)
	outb(addr_6845, 14);
f0100618:	8b bb 14 23 00 00    	mov    0x2314(%ebx),%edi
f010061e:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100623:	89 fa                	mov    %edi,%edx
f0100625:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100626:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100629:	89 ca                	mov    %ecx,%edx
f010062b:	ec                   	in     (%dx),%al
f010062c:	0f b6 f0             	movzbl %al,%esi
f010062f:	c1 e6 08             	shl    $0x8,%esi
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100632:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100637:	89 fa                	mov    %edi,%edx
f0100639:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010063a:	89 ca                	mov    %ecx,%edx
f010063c:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f010063d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100640:	89 bb 10 23 00 00    	mov    %edi,0x2310(%ebx)
	pos |= inb(addr_6845 + 1);
f0100646:	0f b6 c0             	movzbl %al,%eax
f0100649:	09 c6                	or     %eax,%esi
	crt_pos = pos;
f010064b:	66 89 b3 0c 23 00 00 	mov    %si,0x230c(%ebx)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100652:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100657:	89 c8                	mov    %ecx,%eax
f0100659:	ba fa 03 00 00       	mov    $0x3fa,%edx
f010065e:	ee                   	out    %al,(%dx)
f010065f:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100664:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100669:	89 fa                	mov    %edi,%edx
f010066b:	ee                   	out    %al,(%dx)
f010066c:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100671:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100676:	ee                   	out    %al,(%dx)
f0100677:	be f9 03 00 00       	mov    $0x3f9,%esi
f010067c:	89 c8                	mov    %ecx,%eax
f010067e:	89 f2                	mov    %esi,%edx
f0100680:	ee                   	out    %al,(%dx)
f0100681:	b8 03 00 00 00       	mov    $0x3,%eax
f0100686:	89 fa                	mov    %edi,%edx
f0100688:	ee                   	out    %al,(%dx)
f0100689:	ba fc 03 00 00       	mov    $0x3fc,%edx
f010068e:	89 c8                	mov    %ecx,%eax
f0100690:	ee                   	out    %al,(%dx)
f0100691:	b8 01 00 00 00       	mov    $0x1,%eax
f0100696:	89 f2                	mov    %esi,%edx
f0100698:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100699:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010069e:	ec                   	in     (%dx),%al
f010069f:	89 c1                	mov    %eax,%ecx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01006a1:	3c ff                	cmp    $0xff,%al
f01006a3:	0f 95 83 18 23 00 00 	setne  0x2318(%ebx)
f01006aa:	ba fa 03 00 00       	mov    $0x3fa,%edx
f01006af:	ec                   	in     (%dx),%al
f01006b0:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006b5:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f01006b6:	80 f9 ff             	cmp    $0xff,%cl
f01006b9:	74 25                	je     f01006e0 <cons_init+0x112>
		cprintf("Serial port does not exist!\n");
}
f01006bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01006be:	5b                   	pop    %ebx
f01006bf:	5e                   	pop    %esi
f01006c0:	5f                   	pop    %edi
f01006c1:	5d                   	pop    %ebp
f01006c2:	c3                   	ret    
		*cp = was;
f01006c3:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01006ca:	c7 83 14 23 00 00 d4 	movl   $0x3d4,0x2314(%ebx)
f01006d1:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01006d4:	c7 45 e4 00 80 0b f0 	movl   $0xf00b8000,-0x1c(%ebp)
f01006db:	e9 38 ff ff ff       	jmp    f0100618 <cons_init+0x4a>
		cprintf("Serial port does not exist!\n");
f01006e0:	83 ec 0c             	sub    $0xc,%esp
f01006e3:	8d 83 3d 86 f7 ff    	lea    -0x879c3(%ebx),%eax
f01006e9:	50                   	push   %eax
f01006ea:	e8 d5 33 00 00       	call   f0103ac4 <cprintf>
f01006ef:	83 c4 10             	add    $0x10,%esp
}
f01006f2:	eb c7                	jmp    f01006bb <cons_init+0xed>

f01006f4 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01006f4:	f3 0f 1e fb          	endbr32 
f01006f8:	55                   	push   %ebp
f01006f9:	89 e5                	mov    %esp,%ebp
f01006fb:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01006fe:	8b 45 08             	mov    0x8(%ebp),%eax
f0100701:	e8 1f fc ff ff       	call   f0100325 <cons_putc>
}
f0100706:	c9                   	leave  
f0100707:	c3                   	ret    

f0100708 <getchar>:

int
getchar(void)
{
f0100708:	f3 0f 1e fb          	endbr32 
f010070c:	55                   	push   %ebp
f010070d:	89 e5                	mov    %esp,%ebp
f010070f:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100712:	e8 5d fe ff ff       	call   f0100574 <cons_getc>
f0100717:	85 c0                	test   %eax,%eax
f0100719:	74 f7                	je     f0100712 <getchar+0xa>
		/* do nothing */;
	return c;
}
f010071b:	c9                   	leave  
f010071c:	c3                   	ret    

f010071d <iscons>:

int
iscons(int fdnum)
{
f010071d:	f3 0f 1e fb          	endbr32 
	// used by readline
	return 1;
}
f0100721:	b8 01 00 00 00       	mov    $0x1,%eax
f0100726:	c3                   	ret    

f0100727 <__x86.get_pc_thunk.ax>:
f0100727:	8b 04 24             	mov    (%esp),%eax
f010072a:	c3                   	ret    

f010072b <__x86.get_pc_thunk.si>:
f010072b:	8b 34 24             	mov    (%esp),%esi
f010072e:	c3                   	ret    

f010072f <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f010072f:	f3 0f 1e fb          	endbr32 
f0100733:	55                   	push   %ebp
f0100734:	89 e5                	mov    %esp,%ebp
f0100736:	56                   	push   %esi
f0100737:	53                   	push   %ebx
f0100738:	e8 36 fa ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f010073d:	81 c3 df c8 08 00    	add    $0x8c8df,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100743:	83 ec 04             	sub    $0x4,%esp
f0100746:	8d 83 64 88 f7 ff    	lea    -0x8779c(%ebx),%eax
f010074c:	50                   	push   %eax
f010074d:	8d 83 82 88 f7 ff    	lea    -0x8777e(%ebx),%eax
f0100753:	50                   	push   %eax
f0100754:	8d b3 87 88 f7 ff    	lea    -0x87779(%ebx),%esi
f010075a:	56                   	push   %esi
f010075b:	e8 64 33 00 00       	call   f0103ac4 <cprintf>
f0100760:	83 c4 0c             	add    $0xc,%esp
f0100763:	8d 83 38 89 f7 ff    	lea    -0x876c8(%ebx),%eax
f0100769:	50                   	push   %eax
f010076a:	8d 83 90 88 f7 ff    	lea    -0x87770(%ebx),%eax
f0100770:	50                   	push   %eax
f0100771:	56                   	push   %esi
f0100772:	e8 4d 33 00 00       	call   f0103ac4 <cprintf>
f0100777:	83 c4 0c             	add    $0xc,%esp
f010077a:	8d 83 60 89 f7 ff    	lea    -0x876a0(%ebx),%eax
f0100780:	50                   	push   %eax
f0100781:	8d 83 99 88 f7 ff    	lea    -0x87767(%ebx),%eax
f0100787:	50                   	push   %eax
f0100788:	56                   	push   %esi
f0100789:	e8 36 33 00 00       	call   f0103ac4 <cprintf>
	return 0;
}
f010078e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100793:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100796:	5b                   	pop    %ebx
f0100797:	5e                   	pop    %esi
f0100798:	5d                   	pop    %ebp
f0100799:	c3                   	ret    

f010079a <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f010079a:	f3 0f 1e fb          	endbr32 
f010079e:	55                   	push   %ebp
f010079f:	89 e5                	mov    %esp,%ebp
f01007a1:	57                   	push   %edi
f01007a2:	56                   	push   %esi
f01007a3:	53                   	push   %ebx
f01007a4:	83 ec 18             	sub    $0x18,%esp
f01007a7:	e8 c7 f9 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f01007ac:	81 c3 70 c8 08 00    	add    $0x8c870,%ebx
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01007b2:	8d 83 a3 88 f7 ff    	lea    -0x8775d(%ebx),%eax
f01007b8:	50                   	push   %eax
f01007b9:	e8 06 33 00 00       	call   f0103ac4 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01007be:	83 c4 08             	add    $0x8,%esp
f01007c1:	ff b3 fc ff ff ff    	pushl  -0x4(%ebx)
f01007c7:	8d 83 88 89 f7 ff    	lea    -0x87678(%ebx),%eax
f01007cd:	50                   	push   %eax
f01007ce:	e8 f1 32 00 00       	call   f0103ac4 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01007d3:	83 c4 0c             	add    $0xc,%esp
f01007d6:	c7 c7 0c 00 10 f0    	mov    $0xf010000c,%edi
f01007dc:	8d 87 00 00 00 10    	lea    0x10000000(%edi),%eax
f01007e2:	50                   	push   %eax
f01007e3:	57                   	push   %edi
f01007e4:	8d 83 b0 89 f7 ff    	lea    -0x87650(%ebx),%eax
f01007ea:	50                   	push   %eax
f01007eb:	e8 d4 32 00 00       	call   f0103ac4 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01007f0:	83 c4 0c             	add    $0xc,%esp
f01007f3:	c7 c0 ed 55 10 f0    	mov    $0xf01055ed,%eax
f01007f9:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01007ff:	52                   	push   %edx
f0100800:	50                   	push   %eax
f0100801:	8d 83 d4 89 f7 ff    	lea    -0x8762c(%ebx),%eax
f0100807:	50                   	push   %eax
f0100808:	e8 b7 32 00 00       	call   f0103ac4 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010080d:	83 c4 0c             	add    $0xc,%esp
f0100810:	c7 c0 00 f1 18 f0    	mov    $0xf018f100,%eax
f0100816:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010081c:	52                   	push   %edx
f010081d:	50                   	push   %eax
f010081e:	8d 83 f8 89 f7 ff    	lea    -0x87608(%ebx),%eax
f0100824:	50                   	push   %eax
f0100825:	e8 9a 32 00 00       	call   f0103ac4 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010082a:	83 c4 0c             	add    $0xc,%esp
f010082d:	c7 c6 10 00 19 f0    	mov    $0xf0190010,%esi
f0100833:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f0100839:	50                   	push   %eax
f010083a:	56                   	push   %esi
f010083b:	8d 83 1c 8a f7 ff    	lea    -0x875e4(%ebx),%eax
f0100841:	50                   	push   %eax
f0100842:	e8 7d 32 00 00       	call   f0103ac4 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100847:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f010084a:	29 fe                	sub    %edi,%esi
f010084c:	81 c6 ff 03 00 00    	add    $0x3ff,%esi
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100852:	c1 fe 0a             	sar    $0xa,%esi
f0100855:	56                   	push   %esi
f0100856:	8d 83 40 8a f7 ff    	lea    -0x875c0(%ebx),%eax
f010085c:	50                   	push   %eax
f010085d:	e8 62 32 00 00       	call   f0103ac4 <cprintf>
	return 0;
}
f0100862:	b8 00 00 00 00       	mov    $0x0,%eax
f0100867:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010086a:	5b                   	pop    %ebx
f010086b:	5e                   	pop    %esi
f010086c:	5f                   	pop    %edi
f010086d:	5d                   	pop    %ebp
f010086e:	c3                   	ret    

f010086f <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f010086f:	f3 0f 1e fb          	endbr32 
f0100873:	55                   	push   %ebp
f0100874:	89 e5                	mov    %esp,%ebp
f0100876:	57                   	push   %edi
f0100877:	56                   	push   %esi
f0100878:	53                   	push   %ebx
f0100879:	83 ec 48             	sub    $0x48,%esp
f010087c:	e8 f2 f8 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0100881:	81 c3 9b c7 08 00    	add    $0x8c79b,%ebx

static inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100887:	89 e8                	mov    %ebp,%eax
	// Your code here.
	uint32_t* ebp = (uint32_t*) read_ebp();
f0100889:	89 c7                	mov    %eax,%edi
	cprintf("Stack backtrace:\n");
f010088b:	8d 83 bc 88 f7 ff    	lea    -0x87744(%ebx),%eax
f0100891:	50                   	push   %eax
f0100892:	e8 2d 32 00 00       	call   f0103ac4 <cprintf>
	while (ebp) {
f0100897:	83 c4 10             	add    $0x10,%esp
		uint32_t eip = ebp[1];
		cprintf("ebp %x  eip %x  args", ebp, eip);
f010089a:	8d 83 ce 88 f7 ff    	lea    -0x87732(%ebx),%eax
f01008a0:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int i;
		for (i = 2; i <= 6; ++i)
			cprintf(" %08.x", ebp[i]);
f01008a3:	8d 83 e3 88 f7 ff    	lea    -0x8771d(%ebx),%eax
f01008a9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	while (ebp) {
f01008ac:	eb 48                	jmp    f01008f6 <mon_backtrace+0x87>
f01008ae:	8b 7d bc             	mov    -0x44(%ebp),%edi
		cprintf("\n");
f01008b1:	83 ec 0c             	sub    $0xc,%esp
f01008b4:	8d 83 78 8d f7 ff    	lea    -0x87288(%ebx),%eax
f01008ba:	50                   	push   %eax
f01008bb:	e8 04 32 00 00       	call   f0103ac4 <cprintf>
		struct Eipdebuginfo info;
		debuginfo_eip(eip, &info);
f01008c0:	83 c4 08             	add    $0x8,%esp
f01008c3:	8d 45 d0             	lea    -0x30(%ebp),%eax
f01008c6:	50                   	push   %eax
f01008c7:	8b 75 c0             	mov    -0x40(%ebp),%esi
f01008ca:	56                   	push   %esi
f01008cb:	e8 cb 3c 00 00       	call   f010459b <debuginfo_eip>
		cprintf("\t%s:%d: %.*s+%d\n", 
f01008d0:	83 c4 08             	add    $0x8,%esp
f01008d3:	89 f0                	mov    %esi,%eax
f01008d5:	2b 45 e0             	sub    -0x20(%ebp),%eax
f01008d8:	50                   	push   %eax
f01008d9:	ff 75 d8             	pushl  -0x28(%ebp)
f01008dc:	ff 75 dc             	pushl  -0x24(%ebp)
f01008df:	ff 75 d4             	pushl  -0x2c(%ebp)
f01008e2:	ff 75 d0             	pushl  -0x30(%ebp)
f01008e5:	8d 83 ea 88 f7 ff    	lea    -0x87716(%ebx),%eax
f01008eb:	50                   	push   %eax
f01008ec:	e8 d3 31 00 00       	call   f0103ac4 <cprintf>
			info.eip_file, info.eip_line,
			info.eip_fn_namelen, info.eip_fn_name,
			eip-info.eip_fn_addr);
		ebp = (uint32_t*) *ebp;
f01008f1:	8b 3f                	mov    (%edi),%edi
f01008f3:	83 c4 20             	add    $0x20,%esp
	while (ebp) {
f01008f6:	85 ff                	test   %edi,%edi
f01008f8:	74 3d                	je     f0100937 <mon_backtrace+0xc8>
		uint32_t eip = ebp[1];
f01008fa:	8b 47 04             	mov    0x4(%edi),%eax
f01008fd:	89 45 c0             	mov    %eax,-0x40(%ebp)
		cprintf("ebp %x  eip %x  args", ebp, eip);
f0100900:	83 ec 04             	sub    $0x4,%esp
f0100903:	50                   	push   %eax
f0100904:	57                   	push   %edi
f0100905:	ff 75 b8             	pushl  -0x48(%ebp)
f0100908:	e8 b7 31 00 00       	call   f0103ac4 <cprintf>
f010090d:	8d 77 08             	lea    0x8(%edi),%esi
f0100910:	8d 47 1c             	lea    0x1c(%edi),%eax
f0100913:	83 c4 10             	add    $0x10,%esp
f0100916:	89 7d bc             	mov    %edi,-0x44(%ebp)
f0100919:	89 c7                	mov    %eax,%edi
			cprintf(" %08.x", ebp[i]);
f010091b:	83 ec 08             	sub    $0x8,%esp
f010091e:	ff 36                	pushl  (%esi)
f0100920:	ff 75 c4             	pushl  -0x3c(%ebp)
f0100923:	e8 9c 31 00 00       	call   f0103ac4 <cprintf>
f0100928:	83 c6 04             	add    $0x4,%esi
		for (i = 2; i <= 6; ++i)
f010092b:	83 c4 10             	add    $0x10,%esp
f010092e:	39 fe                	cmp    %edi,%esi
f0100930:	75 e9                	jne    f010091b <mon_backtrace+0xac>
f0100932:	e9 77 ff ff ff       	jmp    f01008ae <mon_backtrace+0x3f>
	}
	return 0;
}
f0100937:	b8 00 00 00 00       	mov    $0x0,%eax
f010093c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010093f:	5b                   	pop    %ebx
f0100940:	5e                   	pop    %esi
f0100941:	5f                   	pop    %edi
f0100942:	5d                   	pop    %ebp
f0100943:	c3                   	ret    

f0100944 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100944:	f3 0f 1e fb          	endbr32 
f0100948:	55                   	push   %ebp
f0100949:	89 e5                	mov    %esp,%ebp
f010094b:	57                   	push   %edi
f010094c:	56                   	push   %esi
f010094d:	53                   	push   %ebx
f010094e:	83 ec 68             	sub    $0x68,%esp
f0100951:	e8 1d f8 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0100956:	81 c3 c6 c6 08 00    	add    $0x8c6c6,%ebx
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f010095c:	8d 83 6c 8a f7 ff    	lea    -0x87594(%ebx),%eax
f0100962:	50                   	push   %eax
f0100963:	e8 5c 31 00 00       	call   f0103ac4 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100968:	8d 83 90 8a f7 ff    	lea    -0x87570(%ebx),%eax
f010096e:	89 04 24             	mov    %eax,(%esp)
f0100971:	e8 4e 31 00 00       	call   f0103ac4 <cprintf>

	if (tf != NULL)
f0100976:	83 c4 10             	add    $0x10,%esp
f0100979:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f010097d:	74 0e                	je     f010098d <monitor+0x49>
		print_trapframe(tf);
f010097f:	83 ec 0c             	sub    $0xc,%esp
f0100982:	ff 75 08             	pushl  0x8(%ebp)
f0100985:	e8 27 36 00 00       	call   f0103fb1 <print_trapframe>
f010098a:	83 c4 10             	add    $0x10,%esp
		while (*buf && strchr(WHITESPACE, *buf))
f010098d:	8d 83 ff 88 f7 ff    	lea    -0x87701(%ebx),%eax
f0100993:	89 45 a0             	mov    %eax,-0x60(%ebp)
f0100996:	e9 d1 00 00 00       	jmp    f0100a6c <monitor+0x128>
f010099b:	83 ec 08             	sub    $0x8,%esp
f010099e:	0f be c0             	movsbl %al,%eax
f01009a1:	50                   	push   %eax
f01009a2:	ff 75 a0             	pushl  -0x60(%ebp)
f01009a5:	e8 99 47 00 00       	call   f0105143 <strchr>
f01009aa:	83 c4 10             	add    $0x10,%esp
f01009ad:	85 c0                	test   %eax,%eax
f01009af:	74 6d                	je     f0100a1e <monitor+0xda>
			*buf++ = 0;
f01009b1:	c6 06 00             	movb   $0x0,(%esi)
f01009b4:	89 7d a4             	mov    %edi,-0x5c(%ebp)
f01009b7:	8d 76 01             	lea    0x1(%esi),%esi
f01009ba:	8b 7d a4             	mov    -0x5c(%ebp),%edi
		while (*buf && strchr(WHITESPACE, *buf))
f01009bd:	0f b6 06             	movzbl (%esi),%eax
f01009c0:	84 c0                	test   %al,%al
f01009c2:	75 d7                	jne    f010099b <monitor+0x57>
	argv[argc] = 0;
f01009c4:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
f01009cb:	00 
	if (argc == 0)
f01009cc:	85 ff                	test   %edi,%edi
f01009ce:	0f 84 98 00 00 00    	je     f0100a6c <monitor+0x128>
f01009d4:	8d b3 24 20 00 00    	lea    0x2024(%ebx),%esi
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009da:	b8 00 00 00 00       	mov    $0x0,%eax
f01009df:	89 7d a4             	mov    %edi,-0x5c(%ebp)
f01009e2:	89 c7                	mov    %eax,%edi
		if (strcmp(argv[0], commands[i].name) == 0)
f01009e4:	83 ec 08             	sub    $0x8,%esp
f01009e7:	ff 36                	pushl  (%esi)
f01009e9:	ff 75 a8             	pushl  -0x58(%ebp)
f01009ec:	e8 ec 46 00 00       	call   f01050dd <strcmp>
f01009f1:	83 c4 10             	add    $0x10,%esp
f01009f4:	85 c0                	test   %eax,%eax
f01009f6:	0f 84 99 00 00 00    	je     f0100a95 <monitor+0x151>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009fc:	83 c7 01             	add    $0x1,%edi
f01009ff:	83 c6 0c             	add    $0xc,%esi
f0100a02:	83 ff 03             	cmp    $0x3,%edi
f0100a05:	75 dd                	jne    f01009e4 <monitor+0xa0>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a07:	83 ec 08             	sub    $0x8,%esp
f0100a0a:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a0d:	8d 83 21 89 f7 ff    	lea    -0x876df(%ebx),%eax
f0100a13:	50                   	push   %eax
f0100a14:	e8 ab 30 00 00       	call   f0103ac4 <cprintf>
	return 0;
f0100a19:	83 c4 10             	add    $0x10,%esp
f0100a1c:	eb 4e                	jmp    f0100a6c <monitor+0x128>
		if (*buf == 0)
f0100a1e:	80 3e 00             	cmpb   $0x0,(%esi)
f0100a21:	74 a1                	je     f01009c4 <monitor+0x80>
		if (argc == MAXARGS-1) {
f0100a23:	83 ff 0f             	cmp    $0xf,%edi
f0100a26:	74 30                	je     f0100a58 <monitor+0x114>
		argv[argc++] = buf;
f0100a28:	8d 47 01             	lea    0x1(%edi),%eax
f0100a2b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0100a2e:	89 74 bd a8          	mov    %esi,-0x58(%ebp,%edi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a32:	0f b6 06             	movzbl (%esi),%eax
f0100a35:	84 c0                	test   %al,%al
f0100a37:	74 81                	je     f01009ba <monitor+0x76>
f0100a39:	83 ec 08             	sub    $0x8,%esp
f0100a3c:	0f be c0             	movsbl %al,%eax
f0100a3f:	50                   	push   %eax
f0100a40:	ff 75 a0             	pushl  -0x60(%ebp)
f0100a43:	e8 fb 46 00 00       	call   f0105143 <strchr>
f0100a48:	83 c4 10             	add    $0x10,%esp
f0100a4b:	85 c0                	test   %eax,%eax
f0100a4d:	0f 85 67 ff ff ff    	jne    f01009ba <monitor+0x76>
			buf++;
f0100a53:	83 c6 01             	add    $0x1,%esi
f0100a56:	eb da                	jmp    f0100a32 <monitor+0xee>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a58:	83 ec 08             	sub    $0x8,%esp
f0100a5b:	6a 10                	push   $0x10
f0100a5d:	8d 83 04 89 f7 ff    	lea    -0x876fc(%ebx),%eax
f0100a63:	50                   	push   %eax
f0100a64:	e8 5b 30 00 00       	call   f0103ac4 <cprintf>
			return 0;
f0100a69:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100a6c:	8d bb fb 88 f7 ff    	lea    -0x87705(%ebx),%edi
f0100a72:	83 ec 0c             	sub    $0xc,%esp
f0100a75:	57                   	push   %edi
f0100a76:	e8 57 44 00 00       	call   f0104ed2 <readline>
		if (buf != NULL)
f0100a7b:	83 c4 10             	add    $0x10,%esp
f0100a7e:	85 c0                	test   %eax,%eax
f0100a80:	74 f0                	je     f0100a72 <monitor+0x12e>
f0100a82:	89 c6                	mov    %eax,%esi
	argv[argc] = 0;
f0100a84:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100a8b:	bf 00 00 00 00       	mov    $0x0,%edi
f0100a90:	e9 28 ff ff ff       	jmp    f01009bd <monitor+0x79>
f0100a95:	89 f8                	mov    %edi,%eax
f0100a97:	8b 7d a4             	mov    -0x5c(%ebp),%edi
			return commands[i].func(argc, argv, tf);
f0100a9a:	83 ec 04             	sub    $0x4,%esp
f0100a9d:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100aa0:	ff 75 08             	pushl  0x8(%ebp)
f0100aa3:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100aa6:	52                   	push   %edx
f0100aa7:	57                   	push   %edi
f0100aa8:	ff 94 83 2c 20 00 00 	call   *0x202c(%ebx,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100aaf:	83 c4 10             	add    $0x10,%esp
f0100ab2:	85 c0                	test   %eax,%eax
f0100ab4:	79 b6                	jns    f0100a6c <monitor+0x128>
				break;
	}
f0100ab6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100ab9:	5b                   	pop    %ebx
f0100aba:	5e                   	pop    %esi
f0100abb:	5f                   	pop    %edi
f0100abc:	5d                   	pop    %ebp
f0100abd:	c3                   	ret    

f0100abe <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100abe:	55                   	push   %ebp
f0100abf:	89 e5                	mov    %esp,%ebp
f0100ac1:	57                   	push   %edi
f0100ac2:	56                   	push   %esi
f0100ac3:	53                   	push   %ebx
f0100ac4:	83 ec 0c             	sub    $0xc,%esp
f0100ac7:	e8 a7 f6 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0100acc:	81 c3 50 c5 08 00    	add    $0x8c550,%ebx
f0100ad2:	89 c6                	mov    %eax,%esi
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100ad4:	83 bb 1c 23 00 00 00 	cmpl   $0x0,0x231c(%ebx)
f0100adb:	74 22                	je     f0100aff <boot_alloc+0x41>
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = nextfree;
f0100add:	8b 93 1c 23 00 00    	mov    0x231c(%ebx),%edx
	nextfree = ROUNDUP(result + n, PGSIZE);
f0100ae3:	8d 84 32 ff 0f 00 00 	lea    0xfff(%edx,%esi,1),%eax
f0100aea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100aef:	89 83 1c 23 00 00    	mov    %eax,0x231c(%ebx)

	// If we're out of memory, boot_alloc should panic.
	// 这部分目前没有思路

	return result;
}
f0100af5:	89 d0                	mov    %edx,%eax
f0100af7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100afa:	5b                   	pop    %ebx
f0100afb:	5e                   	pop    %esi
f0100afc:	5f                   	pop    %edi
f0100afd:	5d                   	pop    %ebp
f0100afe:	c3                   	ret    
		cprintf(".bss end is %08x\n", end);
f0100aff:	83 ec 08             	sub    $0x8,%esp
f0100b02:	c7 c7 10 00 19 f0    	mov    $0xf0190010,%edi
f0100b08:	57                   	push   %edi
f0100b09:	8d 83 b5 8a f7 ff    	lea    -0x8754b(%ebx),%eax
f0100b0f:	50                   	push   %eax
f0100b10:	e8 af 2f 00 00       	call   f0103ac4 <cprintf>
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100b15:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
f0100b1b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
f0100b21:	89 bb 1c 23 00 00    	mov    %edi,0x231c(%ebx)
f0100b27:	83 c4 10             	add    $0x10,%esp
f0100b2a:	eb b1                	jmp    f0100add <boot_alloc+0x1f>

f0100b2c <nvram_read>:
{
f0100b2c:	55                   	push   %ebp
f0100b2d:	89 e5                	mov    %esp,%ebp
f0100b2f:	57                   	push   %edi
f0100b30:	56                   	push   %esi
f0100b31:	53                   	push   %ebx
f0100b32:	83 ec 18             	sub    $0x18,%esp
f0100b35:	e8 39 f6 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0100b3a:	81 c3 e2 c4 08 00    	add    $0x8c4e2,%ebx
f0100b40:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100b42:	50                   	push   %eax
f0100b43:	e8 e5 2e 00 00       	call   f0103a2d <mc146818_read>
f0100b48:	89 c7                	mov    %eax,%edi
f0100b4a:	83 c6 01             	add    $0x1,%esi
f0100b4d:	89 34 24             	mov    %esi,(%esp)
f0100b50:	e8 d8 2e 00 00       	call   f0103a2d <mc146818_read>
f0100b55:	c1 e0 08             	shl    $0x8,%eax
f0100b58:	09 f8                	or     %edi,%eax
}
f0100b5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100b5d:	5b                   	pop    %ebx
f0100b5e:	5e                   	pop    %esi
f0100b5f:	5f                   	pop    %edi
f0100b60:	5d                   	pop    %ebp
f0100b61:	c3                   	ret    

f0100b62 <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100b62:	55                   	push   %ebp
f0100b63:	89 e5                	mov    %esp,%ebp
f0100b65:	56                   	push   %esi
f0100b66:	53                   	push   %ebx
f0100b67:	e8 e4 26 00 00       	call   f0103250 <__x86.get_pc_thunk.cx>
f0100b6c:	81 c1 b0 c4 08 00    	add    $0x8c4b0,%ecx
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100b72:	89 d3                	mov    %edx,%ebx
f0100b74:	c1 eb 16             	shr    $0x16,%ebx
	if (!(*pgdir & PTE_P))
f0100b77:	8b 04 98             	mov    (%eax,%ebx,4),%eax
f0100b7a:	a8 01                	test   $0x1,%al
f0100b7c:	74 59                	je     f0100bd7 <check_va2pa+0x75>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100b7e:	89 c3                	mov    %eax,%ebx
f0100b80:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100b86:	c1 e8 0c             	shr    $0xc,%eax
f0100b89:	c7 c6 04 00 19 f0    	mov    $0xf0190004,%esi
f0100b8f:	3b 06                	cmp    (%esi),%eax
f0100b91:	73 29                	jae    f0100bbc <check_va2pa+0x5a>
	if (!(p[PTX(va)] & PTE_P))
f0100b93:	c1 ea 0c             	shr    $0xc,%edx
f0100b96:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100b9c:	8b 94 93 00 00 00 f0 	mov    -0x10000000(%ebx,%edx,4),%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100ba3:	89 d0                	mov    %edx,%eax
f0100ba5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100baa:	f6 c2 01             	test   $0x1,%dl
f0100bad:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100bb2:	0f 44 c2             	cmove  %edx,%eax
}
f0100bb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100bb8:	5b                   	pop    %ebx
f0100bb9:	5e                   	pop    %esi
f0100bba:	5d                   	pop    %ebp
f0100bbb:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100bbc:	53                   	push   %ebx
f0100bbd:	8d 81 ac 8d f7 ff    	lea    -0x87254(%ecx),%eax
f0100bc3:	50                   	push   %eax
f0100bc4:	68 88 03 00 00       	push   $0x388
f0100bc9:	8d 81 c7 8a f7 ff    	lea    -0x87539(%ecx),%eax
f0100bcf:	50                   	push   %eax
f0100bd0:	89 cb                	mov    %ecx,%ebx
f0100bd2:	e8 de f4 ff ff       	call   f01000b5 <_panic>
		return ~0;
f0100bd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100bdc:	eb d7                	jmp    f0100bb5 <check_va2pa+0x53>

f0100bde <check_page_free_list>:
{
f0100bde:	55                   	push   %ebp
f0100bdf:	89 e5                	mov    %esp,%ebp
f0100be1:	57                   	push   %edi
f0100be2:	56                   	push   %esi
f0100be3:	53                   	push   %ebx
f0100be4:	83 ec 2c             	sub    $0x2c,%esp
f0100be7:	e8 3f fb ff ff       	call   f010072b <__x86.get_pc_thunk.si>
f0100bec:	81 c6 30 c4 08 00    	add    $0x8c430,%esi
f0100bf2:	89 75 c8             	mov    %esi,-0x38(%ebp)
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100bf5:	84 c0                	test   %al,%al
f0100bf7:	0f 85 ec 02 00 00    	jne    f0100ee9 <check_page_free_list+0x30b>
	if (!page_free_list)
f0100bfd:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0100c00:	83 b8 24 23 00 00 00 	cmpl   $0x0,0x2324(%eax)
f0100c07:	74 21                	je     f0100c2a <check_page_free_list+0x4c>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100c09:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100c10:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0100c13:	8b b0 24 23 00 00    	mov    0x2324(%eax),%esi
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100c19:	c7 c7 0c 00 19 f0    	mov    $0xf019000c,%edi
	if (PGNUM(pa) >= npages)
f0100c1f:	c7 c0 04 00 19 f0    	mov    $0xf0190004,%eax
f0100c25:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100c28:	eb 39                	jmp    f0100c63 <check_page_free_list+0x85>
		panic("'page_free_list' is a null pointer!");
f0100c2a:	83 ec 04             	sub    $0x4,%esp
f0100c2d:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100c30:	8d 83 d0 8d f7 ff    	lea    -0x87230(%ebx),%eax
f0100c36:	50                   	push   %eax
f0100c37:	68 c4 02 00 00       	push   $0x2c4
f0100c3c:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0100c42:	50                   	push   %eax
f0100c43:	e8 6d f4 ff ff       	call   f01000b5 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100c48:	50                   	push   %eax
f0100c49:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100c4c:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f0100c52:	50                   	push   %eax
f0100c53:	6a 56                	push   $0x56
f0100c55:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f0100c5b:	50                   	push   %eax
f0100c5c:	e8 54 f4 ff ff       	call   f01000b5 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100c61:	8b 36                	mov    (%esi),%esi
f0100c63:	85 f6                	test   %esi,%esi
f0100c65:	74 40                	je     f0100ca7 <check_page_free_list+0xc9>
	return (pp - pages) << PGSHIFT;
f0100c67:	89 f0                	mov    %esi,%eax
f0100c69:	2b 07                	sub    (%edi),%eax
f0100c6b:	c1 f8 03             	sar    $0x3,%eax
f0100c6e:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100c71:	89 c2                	mov    %eax,%edx
f0100c73:	c1 ea 16             	shr    $0x16,%edx
f0100c76:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
f0100c79:	73 e6                	jae    f0100c61 <check_page_free_list+0x83>
	if (PGNUM(pa) >= npages)
f0100c7b:	89 c2                	mov    %eax,%edx
f0100c7d:	c1 ea 0c             	shr    $0xc,%edx
f0100c80:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100c83:	3b 11                	cmp    (%ecx),%edx
f0100c85:	73 c1                	jae    f0100c48 <check_page_free_list+0x6a>
			memset(page2kva(pp), 0x97, 128);
f0100c87:	83 ec 04             	sub    $0x4,%esp
f0100c8a:	68 80 00 00 00       	push   $0x80
f0100c8f:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100c94:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100c99:	50                   	push   %eax
f0100c9a:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100c9d:	e8 e6 44 00 00       	call   f0105188 <memset>
f0100ca2:	83 c4 10             	add    $0x10,%esp
f0100ca5:	eb ba                	jmp    f0100c61 <check_page_free_list+0x83>
	first_free_page = (char *) boot_alloc(0);
f0100ca7:	b8 00 00 00 00       	mov    $0x0,%eax
f0100cac:	e8 0d fe ff ff       	call   f0100abe <boot_alloc>
f0100cb1:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100cb4:	8b 7d c8             	mov    -0x38(%ebp),%edi
f0100cb7:	8b 97 24 23 00 00    	mov    0x2324(%edi),%edx
		assert(pp >= pages);
f0100cbd:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0100cc3:	8b 08                	mov    (%eax),%ecx
		assert(pp < pages + npages);
f0100cc5:	c7 c0 04 00 19 f0    	mov    $0xf0190004,%eax
f0100ccb:	8b 00                	mov    (%eax),%eax
f0100ccd:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100cd0:	8d 3c c1             	lea    (%ecx,%eax,8),%edi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100cd3:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100cd8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100cdb:	e9 08 01 00 00       	jmp    f0100de8 <check_page_free_list+0x20a>
		assert(pp >= pages);
f0100ce0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100ce3:	8d 83 e1 8a f7 ff    	lea    -0x8751f(%ebx),%eax
f0100ce9:	50                   	push   %eax
f0100cea:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0100cf0:	50                   	push   %eax
f0100cf1:	68 de 02 00 00       	push   $0x2de
f0100cf6:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0100cfc:	50                   	push   %eax
f0100cfd:	e8 b3 f3 ff ff       	call   f01000b5 <_panic>
		assert(pp < pages + npages);
f0100d02:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100d05:	8d 83 02 8b f7 ff    	lea    -0x874fe(%ebx),%eax
f0100d0b:	50                   	push   %eax
f0100d0c:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0100d12:	50                   	push   %eax
f0100d13:	68 df 02 00 00       	push   $0x2df
f0100d18:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0100d1e:	50                   	push   %eax
f0100d1f:	e8 91 f3 ff ff       	call   f01000b5 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d24:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100d27:	8d 83 f4 8d f7 ff    	lea    -0x8720c(%ebx),%eax
f0100d2d:	50                   	push   %eax
f0100d2e:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0100d34:	50                   	push   %eax
f0100d35:	68 e0 02 00 00       	push   $0x2e0
f0100d3a:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0100d40:	50                   	push   %eax
f0100d41:	e8 6f f3 ff ff       	call   f01000b5 <_panic>
		assert(page2pa(pp) != 0);
f0100d46:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100d49:	8d 83 16 8b f7 ff    	lea    -0x874ea(%ebx),%eax
f0100d4f:	50                   	push   %eax
f0100d50:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0100d56:	50                   	push   %eax
f0100d57:	68 e3 02 00 00       	push   $0x2e3
f0100d5c:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0100d62:	50                   	push   %eax
f0100d63:	e8 4d f3 ff ff       	call   f01000b5 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d68:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100d6b:	8d 83 27 8b f7 ff    	lea    -0x874d9(%ebx),%eax
f0100d71:	50                   	push   %eax
f0100d72:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0100d78:	50                   	push   %eax
f0100d79:	68 e4 02 00 00       	push   $0x2e4
f0100d7e:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0100d84:	50                   	push   %eax
f0100d85:	e8 2b f3 ff ff       	call   f01000b5 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d8a:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100d8d:	8d 83 28 8e f7 ff    	lea    -0x871d8(%ebx),%eax
f0100d93:	50                   	push   %eax
f0100d94:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0100d9a:	50                   	push   %eax
f0100d9b:	68 e5 02 00 00       	push   $0x2e5
f0100da0:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0100da6:	50                   	push   %eax
f0100da7:	e8 09 f3 ff ff       	call   f01000b5 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100dac:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100daf:	8d 83 40 8b f7 ff    	lea    -0x874c0(%ebx),%eax
f0100db5:	50                   	push   %eax
f0100db6:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0100dbc:	50                   	push   %eax
f0100dbd:	68 e6 02 00 00       	push   $0x2e6
f0100dc2:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0100dc8:	50                   	push   %eax
f0100dc9:	e8 e7 f2 ff ff       	call   f01000b5 <_panic>
	if (PGNUM(pa) >= npages)
f0100dce:	89 c3                	mov    %eax,%ebx
f0100dd0:	c1 eb 0c             	shr    $0xc,%ebx
f0100dd3:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0100dd6:	76 6d                	jbe    f0100e45 <check_page_free_list+0x267>
	return (void *)(pa + KERNBASE);
f0100dd8:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100ddd:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0100de0:	77 7c                	ja     f0100e5e <check_page_free_list+0x280>
			++nfree_extmem;
f0100de2:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100de6:	8b 12                	mov    (%edx),%edx
f0100de8:	85 d2                	test   %edx,%edx
f0100dea:	0f 84 90 00 00 00    	je     f0100e80 <check_page_free_list+0x2a2>
		assert(pp >= pages);
f0100df0:	39 d1                	cmp    %edx,%ecx
f0100df2:	0f 87 e8 fe ff ff    	ja     f0100ce0 <check_page_free_list+0x102>
		assert(pp < pages + npages);
f0100df8:	39 d7                	cmp    %edx,%edi
f0100dfa:	0f 86 02 ff ff ff    	jbe    f0100d02 <check_page_free_list+0x124>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100e00:	89 d0                	mov    %edx,%eax
f0100e02:	29 c8                	sub    %ecx,%eax
f0100e04:	a8 07                	test   $0x7,%al
f0100e06:	0f 85 18 ff ff ff    	jne    f0100d24 <check_page_free_list+0x146>
	return (pp - pages) << PGSHIFT;
f0100e0c:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100e0f:	c1 e0 0c             	shl    $0xc,%eax
f0100e12:	0f 84 2e ff ff ff    	je     f0100d46 <check_page_free_list+0x168>
		assert(page2pa(pp) != IOPHYSMEM);
f0100e18:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100e1d:	0f 84 45 ff ff ff    	je     f0100d68 <check_page_free_list+0x18a>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100e23:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100e28:	0f 84 5c ff ff ff    	je     f0100d8a <check_page_free_list+0x1ac>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100e2e:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100e33:	0f 84 73 ff ff ff    	je     f0100dac <check_page_free_list+0x1ce>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100e39:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100e3e:	77 8e                	ja     f0100dce <check_page_free_list+0x1f0>
			++nfree_basemem;
f0100e40:	83 c6 01             	add    $0x1,%esi
f0100e43:	eb a1                	jmp    f0100de6 <check_page_free_list+0x208>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100e45:	50                   	push   %eax
f0100e46:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100e49:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f0100e4f:	50                   	push   %eax
f0100e50:	6a 56                	push   $0x56
f0100e52:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f0100e58:	50                   	push   %eax
f0100e59:	e8 57 f2 ff ff       	call   f01000b5 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100e5e:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100e61:	8d 83 4c 8e f7 ff    	lea    -0x871b4(%ebx),%eax
f0100e67:	50                   	push   %eax
f0100e68:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0100e6e:	50                   	push   %eax
f0100e6f:	68 e7 02 00 00       	push   $0x2e7
f0100e74:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0100e7a:	50                   	push   %eax
f0100e7b:	e8 35 f2 ff ff       	call   f01000b5 <_panic>
f0100e80:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f0100e83:	85 f6                	test   %esi,%esi
f0100e85:	7e 1e                	jle    f0100ea5 <check_page_free_list+0x2c7>
	assert(nfree_extmem > 0);
f0100e87:	85 db                	test   %ebx,%ebx
f0100e89:	7e 3c                	jle    f0100ec7 <check_page_free_list+0x2e9>
	cprintf("check_page_free_list() succeeded!\n");
f0100e8b:	83 ec 0c             	sub    $0xc,%esp
f0100e8e:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100e91:	8d 83 94 8e f7 ff    	lea    -0x8716c(%ebx),%eax
f0100e97:	50                   	push   %eax
f0100e98:	e8 27 2c 00 00       	call   f0103ac4 <cprintf>
}
f0100e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100ea0:	5b                   	pop    %ebx
f0100ea1:	5e                   	pop    %esi
f0100ea2:	5f                   	pop    %edi
f0100ea3:	5d                   	pop    %ebp
f0100ea4:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100ea5:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100ea8:	8d 83 5a 8b f7 ff    	lea    -0x874a6(%ebx),%eax
f0100eae:	50                   	push   %eax
f0100eaf:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0100eb5:	50                   	push   %eax
f0100eb6:	68 ef 02 00 00       	push   $0x2ef
f0100ebb:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0100ec1:	50                   	push   %eax
f0100ec2:	e8 ee f1 ff ff       	call   f01000b5 <_panic>
	assert(nfree_extmem > 0);
f0100ec7:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100eca:	8d 83 6c 8b f7 ff    	lea    -0x87494(%ebx),%eax
f0100ed0:	50                   	push   %eax
f0100ed1:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0100ed7:	50                   	push   %eax
f0100ed8:	68 f0 02 00 00       	push   $0x2f0
f0100edd:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0100ee3:	50                   	push   %eax
f0100ee4:	e8 cc f1 ff ff       	call   f01000b5 <_panic>
	if (!page_free_list)
f0100ee9:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0100eec:	8b 80 24 23 00 00    	mov    0x2324(%eax),%eax
f0100ef2:	85 c0                	test   %eax,%eax
f0100ef4:	0f 84 30 fd ff ff    	je     f0100c2a <check_page_free_list+0x4c>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100efa:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100efd:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100f00:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100f03:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	return (pp - pages) << PGSHIFT;
f0100f06:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0100f09:	c7 c3 0c 00 19 f0    	mov    $0xf019000c,%ebx
f0100f0f:	89 c2                	mov    %eax,%edx
f0100f11:	2b 13                	sub    (%ebx),%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100f13:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100f19:	0f 95 c2             	setne  %dl
f0100f1c:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100f1f:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100f23:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100f25:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f29:	8b 00                	mov    (%eax),%eax
f0100f2b:	85 c0                	test   %eax,%eax
f0100f2d:	75 e0                	jne    f0100f0f <check_page_free_list+0x331>
		*tp[1] = 0;
f0100f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100f32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100f38:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100f3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100f3e:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100f40:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100f43:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0100f46:	89 86 24 23 00 00    	mov    %eax,0x2324(%esi)
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100f4c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
f0100f53:	e9 b8 fc ff ff       	jmp    f0100c10 <check_page_free_list+0x32>

f0100f58 <page_init>:
{
f0100f58:	f3 0f 1e fb          	endbr32 
f0100f5c:	55                   	push   %ebp
f0100f5d:	89 e5                	mov    %esp,%ebp
f0100f5f:	57                   	push   %edi
f0100f60:	56                   	push   %esi
f0100f61:	53                   	push   %ebx
f0100f62:	83 ec 1c             	sub    $0x1c,%esp
f0100f65:	e8 ea 22 00 00       	call   f0103254 <__x86.get_pc_thunk.di>
f0100f6a:	81 c7 b2 c0 08 00    	add    $0x8c0b2,%edi
f0100f70:	89 fe                	mov    %edi,%esi
f0100f72:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	pages[0].pp_ref = 1;
f0100f75:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0100f7b:	8b 00                	mov    (%eax),%eax
f0100f7d:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	pages[0].pp_link = NULL;
f0100f83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 1; i < npages_basemem; i++) {
f0100f89:	8b bf 28 23 00 00    	mov    0x2328(%edi),%edi
f0100f8f:	8b 9e 24 23 00 00    	mov    0x2324(%esi),%ebx
f0100f95:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f9a:	b8 01 00 00 00       	mov    $0x1,%eax
		pages[i].pp_ref = 0;
f0100f9f:	c7 c6 0c 00 19 f0    	mov    $0xf019000c,%esi
	for (i = 1; i < npages_basemem; i++) {
f0100fa5:	eb 1f                	jmp    f0100fc6 <page_init+0x6e>
f0100fa7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100fae:	89 d1                	mov    %edx,%ecx
f0100fb0:	03 0e                	add    (%esi),%ecx
f0100fb2:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100fb8:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0100fba:	89 d3                	mov    %edx,%ebx
f0100fbc:	03 1e                	add    (%esi),%ebx
	for (i = 1; i < npages_basemem; i++) {
f0100fbe:	83 c0 01             	add    $0x1,%eax
f0100fc1:	ba 01 00 00 00       	mov    $0x1,%edx
f0100fc6:	39 c7                	cmp    %eax,%edi
f0100fc8:	77 dd                	ja     f0100fa7 <page_init+0x4f>
f0100fca:	84 d2                	test   %dl,%dl
f0100fcc:	74 09                	je     f0100fd7 <page_init+0x7f>
f0100fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100fd1:	89 98 24 23 00 00    	mov    %ebx,0x2324(%eax)
f0100fd7:	b8 00 05 00 00       	mov    $0x500,%eax
		pages[i].pp_ref = 1;
f0100fdc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100fdf:	c7 c1 0c 00 19 f0    	mov    $0xf019000c,%ecx
f0100fe5:	89 c2                	mov    %eax,%edx
f0100fe7:	03 11                	add    (%ecx),%edx
f0100fe9:	66 c7 42 04 01 00    	movw   $0x1,0x4(%edx)
		pages[i].pp_link = NULL;
f0100fef:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
f0100ff5:	83 c0 08             	add    $0x8,%eax
	for(i = io; i < ex; i++){
f0100ff8:	3d 00 08 00 00       	cmp    $0x800,%eax
f0100ffd:	75 e6                	jne    f0100fe5 <page_init+0x8d>
	size_t fisrt_page = PADDR(boot_alloc(0)) / PGSIZE;
f0100fff:	b8 00 00 00 00       	mov    $0x0,%eax
f0101004:	e8 b5 fa ff ff       	call   f0100abe <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0101009:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010100e:	76 18                	jbe    f0101028 <page_init+0xd0>
	return (physaddr_t)kva - KERNBASE;
f0101010:	05 00 00 00 10       	add    $0x10000000,%eax
f0101015:	c1 e8 0c             	shr    $0xc,%eax
	for(i = ex; i < fisrt_page; i++){
f0101018:	ba 00 01 00 00       	mov    $0x100,%edx
		pages[i].pp_ref = 1;
f010101d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0101020:	c7 c3 0c 00 19 f0    	mov    $0xf019000c,%ebx
	for(i = ex; i < fisrt_page; i++){
f0101026:	eb 30                	jmp    f0101058 <page_init+0x100>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101028:	50                   	push   %eax
f0101029:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010102c:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f0101032:	50                   	push   %eax
f0101033:	68 3e 01 00 00       	push   $0x13e
f0101038:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010103e:	50                   	push   %eax
f010103f:	e8 71 f0 ff ff       	call   f01000b5 <_panic>
		pages[i].pp_ref = 1;
f0101044:	8b 0b                	mov    (%ebx),%ecx
f0101046:	8d 0c d1             	lea    (%ecx,%edx,8),%ecx
f0101049:	66 c7 41 04 01 00    	movw   $0x1,0x4(%ecx)
		pages[i].pp_link = NULL;
f010104f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	for(i = ex; i < fisrt_page; i++){
f0101055:	83 c2 01             	add    $0x1,%edx
f0101058:	39 c2                	cmp    %eax,%edx
f010105a:	72 e8                	jb     f0101044 <page_init+0xec>
f010105c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010105f:	8b 9e 24 23 00 00    	mov    0x2324(%esi),%ebx
f0101065:	ba 00 00 00 00       	mov    $0x0,%edx
	for(i = fisrt_page; i < npages; i++){
f010106a:	c7 c7 04 00 19 f0    	mov    $0xf0190004,%edi
		pages[i].pp_ref = 0;
f0101070:	c7 c6 0c 00 19 f0    	mov    $0xf019000c,%esi
f0101076:	eb 1f                	jmp    f0101097 <page_init+0x13f>
f0101078:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f010107f:	89 d1                	mov    %edx,%ecx
f0101081:	03 0e                	add    (%esi),%ecx
f0101083:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0101089:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f010108b:	89 d3                	mov    %edx,%ebx
f010108d:	03 1e                	add    (%esi),%ebx
	for(i = fisrt_page; i < npages; i++){
f010108f:	83 c0 01             	add    $0x1,%eax
f0101092:	ba 01 00 00 00       	mov    $0x1,%edx
f0101097:	39 07                	cmp    %eax,(%edi)
f0101099:	77 dd                	ja     f0101078 <page_init+0x120>
f010109b:	84 d2                	test   %dl,%dl
f010109d:	74 09                	je     f01010a8 <page_init+0x150>
f010109f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01010a2:	89 98 24 23 00 00    	mov    %ebx,0x2324(%eax)
}
f01010a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01010ab:	5b                   	pop    %ebx
f01010ac:	5e                   	pop    %esi
f01010ad:	5f                   	pop    %edi
f01010ae:	5d                   	pop    %ebp
f01010af:	c3                   	ret    

f01010b0 <page_alloc>:
{
f01010b0:	f3 0f 1e fb          	endbr32 
f01010b4:	55                   	push   %ebp
f01010b5:	89 e5                	mov    %esp,%ebp
f01010b7:	56                   	push   %esi
f01010b8:	53                   	push   %ebx
f01010b9:	e8 b5 f0 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f01010be:	81 c3 5e bf 08 00    	add    $0x8bf5e,%ebx
	if(!page_free_list) {
f01010c4:	8b b3 24 23 00 00    	mov    0x2324(%ebx),%esi
f01010ca:	85 f6                	test   %esi,%esi
f01010cc:	74 1d                	je     f01010eb <page_alloc+0x3b>
	page_free_list = page_free_list->pp_link;
f01010ce:	8b 06                	mov    (%esi),%eax
f01010d0:	89 83 24 23 00 00    	mov    %eax,0x2324(%ebx)
	pp->pp_link = NULL;
f01010d6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	if(alloc_flags && ALLOC_ZERO){
f01010dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f01010e0:	75 1d                	jne    f01010ff <page_alloc+0x4f>
}
f01010e2:	89 f0                	mov    %esi,%eax
f01010e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01010e7:	5b                   	pop    %ebx
f01010e8:	5e                   	pop    %esi
f01010e9:	5d                   	pop    %ebp
f01010ea:	c3                   	ret    
		cprintf("page_alloc: out of free memory\n");
f01010eb:	83 ec 0c             	sub    $0xc,%esp
f01010ee:	8d 83 dc 8e f7 ff    	lea    -0x87124(%ebx),%eax
f01010f4:	50                   	push   %eax
f01010f5:	e8 ca 29 00 00       	call   f0103ac4 <cprintf>
		return NULL;
f01010fa:	83 c4 10             	add    $0x10,%esp
f01010fd:	eb e3                	jmp    f01010e2 <page_alloc+0x32>
	return (pp - pages) << PGSHIFT;
f01010ff:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0101105:	89 f1                	mov    %esi,%ecx
f0101107:	2b 08                	sub    (%eax),%ecx
f0101109:	89 c8                	mov    %ecx,%eax
f010110b:	c1 f8 03             	sar    $0x3,%eax
f010110e:	89 c2                	mov    %eax,%edx
f0101110:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101113:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101118:	c7 c1 04 00 19 f0    	mov    $0xf0190004,%ecx
f010111e:	3b 01                	cmp    (%ecx),%eax
f0101120:	73 1b                	jae    f010113d <page_alloc+0x8d>
		memset(page2kva(pp), '\0', PGSIZE);
f0101122:	83 ec 04             	sub    $0x4,%esp
f0101125:	68 00 10 00 00       	push   $0x1000
f010112a:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f010112c:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101132:	52                   	push   %edx
f0101133:	e8 50 40 00 00       	call   f0105188 <memset>
f0101138:	83 c4 10             	add    $0x10,%esp
f010113b:	eb a5                	jmp    f01010e2 <page_alloc+0x32>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010113d:	52                   	push   %edx
f010113e:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f0101144:	50                   	push   %eax
f0101145:	6a 56                	push   $0x56
f0101147:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f010114d:	50                   	push   %eax
f010114e:	e8 62 ef ff ff       	call   f01000b5 <_panic>

f0101153 <page_free>:
{
f0101153:	f3 0f 1e fb          	endbr32 
f0101157:	55                   	push   %ebp
f0101158:	89 e5                	mov    %esp,%ebp
f010115a:	53                   	push   %ebx
f010115b:	83 ec 04             	sub    $0x4,%esp
f010115e:	e8 10 f0 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0101163:	81 c3 b9 be 08 00    	add    $0x8beb9,%ebx
f0101169:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0){
f010116c:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101171:	75 18                	jne    f010118b <page_free+0x38>
	}else if(pp->pp_link != NULL){
f0101173:	83 38 00             	cmpl   $0x0,(%eax)
f0101176:	75 2e                	jne    f01011a6 <page_free+0x53>
		pp->pp_link = page_free_list;
f0101178:	8b 8b 24 23 00 00    	mov    0x2324(%ebx),%ecx
f010117e:	89 08                	mov    %ecx,(%eax)
		page_free_list = pp;
f0101180:	89 83 24 23 00 00    	mov    %eax,0x2324(%ebx)
}
f0101186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101189:	c9                   	leave  
f010118a:	c3                   	ret    
		panic("page_free: pp->pp_ref is nonzero\n");
f010118b:	83 ec 04             	sub    $0x4,%esp
f010118e:	8d 83 fc 8e f7 ff    	lea    -0x87104(%ebx),%eax
f0101194:	50                   	push   %eax
f0101195:	68 76 01 00 00       	push   $0x176
f010119a:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01011a0:	50                   	push   %eax
f01011a1:	e8 0f ef ff ff       	call   f01000b5 <_panic>
		panic("page_free: pp->pp_link is NULL\n");
f01011a6:	83 ec 04             	sub    $0x4,%esp
f01011a9:	8d 83 20 8f f7 ff    	lea    -0x870e0(%ebx),%eax
f01011af:	50                   	push   %eax
f01011b0:	68 78 01 00 00       	push   $0x178
f01011b5:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01011bb:	50                   	push   %eax
f01011bc:	e8 f4 ee ff ff       	call   f01000b5 <_panic>

f01011c1 <page_decref>:
{
f01011c1:	f3 0f 1e fb          	endbr32 
f01011c5:	55                   	push   %ebp
f01011c6:	89 e5                	mov    %esp,%ebp
f01011c8:	83 ec 08             	sub    $0x8,%esp
f01011cb:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f01011ce:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01011d2:	83 e8 01             	sub    $0x1,%eax
f01011d5:	66 89 42 04          	mov    %ax,0x4(%edx)
f01011d9:	66 85 c0             	test   %ax,%ax
f01011dc:	74 02                	je     f01011e0 <page_decref+0x1f>
}
f01011de:	c9                   	leave  
f01011df:	c3                   	ret    
		page_free(pp);
f01011e0:	83 ec 0c             	sub    $0xc,%esp
f01011e3:	52                   	push   %edx
f01011e4:	e8 6a ff ff ff       	call   f0101153 <page_free>
f01011e9:	83 c4 10             	add    $0x10,%esp
}
f01011ec:	eb f0                	jmp    f01011de <page_decref+0x1d>

f01011ee <pgdir_walk>:
{
f01011ee:	f3 0f 1e fb          	endbr32 
f01011f2:	55                   	push   %ebp
f01011f3:	89 e5                	mov    %esp,%ebp
f01011f5:	57                   	push   %edi
f01011f6:	56                   	push   %esi
f01011f7:	53                   	push   %ebx
f01011f8:	83 ec 0c             	sub    $0xc,%esp
f01011fb:	e8 2b f5 ff ff       	call   f010072b <__x86.get_pc_thunk.si>
f0101200:	81 c6 1c be 08 00    	add    $0x8be1c,%esi
f0101206:	8b 45 0c             	mov    0xc(%ebp),%eax
	uint32_t ptx = PTX(va);		//页表项索引
f0101209:	89 c3                	mov    %eax,%ebx
f010120b:	c1 eb 0c             	shr    $0xc,%ebx
f010120e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	uint32_t pdx = PDX(va);		//页目录项索引
f0101214:	c1 e8 16             	shr    $0x16,%eax
	pde = &pgdir[pdx];			//获取页目录项
f0101217:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
f010121e:	03 7d 08             	add    0x8(%ebp),%edi
	if((*pde) & PTE_P){
f0101221:	8b 07                	mov    (%edi),%eax
f0101223:	a8 01                	test   $0x1,%al
f0101225:	74 41                	je     f0101268 <pgdir_walk+0x7a>
		pte = (KADDR(PTE_ADDR(*pde)));
f0101227:	89 c2                	mov    %eax,%edx
f0101229:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f010122f:	c1 e8 0c             	shr    $0xc,%eax
f0101232:	c7 c1 04 00 19 f0    	mov    $0xf0190004,%ecx
f0101238:	39 01                	cmp    %eax,(%ecx)
f010123a:	76 11                	jbe    f010124d <pgdir_walk+0x5f>
	return (void *)(pa + KERNBASE);
f010123c:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	return (pte_t*)&pte[ptx];
f0101242:	8d 04 98             	lea    (%eax,%ebx,4),%eax
}
f0101245:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101248:	5b                   	pop    %ebx
f0101249:	5e                   	pop    %esi
f010124a:	5f                   	pop    %edi
f010124b:	5d                   	pop    %ebp
f010124c:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010124d:	52                   	push   %edx
f010124e:	8d 86 ac 8d f7 ff    	lea    -0x87254(%esi),%eax
f0101254:	50                   	push   %eax
f0101255:	68 b2 01 00 00       	push   $0x1b2
f010125a:	8d 86 c7 8a f7 ff    	lea    -0x87539(%esi),%eax
f0101260:	50                   	push   %eax
f0101261:	89 f3                	mov    %esi,%ebx
f0101263:	e8 4d ee ff ff       	call   f01000b5 <_panic>
		if(!create){
f0101268:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010126c:	74 7f                	je     f01012ed <pgdir_walk+0xff>
		if(!(pp = page_alloc(ALLOC_ZERO))){
f010126e:	83 ec 0c             	sub    $0xc,%esp
f0101271:	6a 01                	push   $0x1
f0101273:	e8 38 fe ff ff       	call   f01010b0 <page_alloc>
f0101278:	83 c4 10             	add    $0x10,%esp
f010127b:	85 c0                	test   %eax,%eax
f010127d:	74 c6                	je     f0101245 <pgdir_walk+0x57>
		pp->pp_ref++;
f010127f:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101284:	c7 c2 0c 00 19 f0    	mov    $0xf019000c,%edx
f010128a:	2b 02                	sub    (%edx),%eax
f010128c:	c1 f8 03             	sar    $0x3,%eax
f010128f:	89 c2                	mov    %eax,%edx
f0101291:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101294:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101299:	c7 c1 04 00 19 f0    	mov    $0xf0190004,%ecx
f010129f:	3b 01                	cmp    (%ecx),%eax
f01012a1:	73 17                	jae    f01012ba <pgdir_walk+0xcc>
	return (void *)(pa + KERNBASE);
f01012a3:	8d 8a 00 00 00 f0    	lea    -0x10000000(%edx),%ecx
f01012a9:	89 c8                	mov    %ecx,%eax
	if ((uint32_t)kva < KERNBASE)
f01012ab:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f01012b1:	76 1f                	jbe    f01012d2 <pgdir_walk+0xe4>
		*pde = PADDR(pte) | PTE_P | PTE_W | PTE_U;
f01012b3:	83 ca 07             	or     $0x7,%edx
f01012b6:	89 17                	mov    %edx,(%edi)
f01012b8:	eb 88                	jmp    f0101242 <pgdir_walk+0x54>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01012ba:	52                   	push   %edx
f01012bb:	8d 86 ac 8d f7 ff    	lea    -0x87254(%esi),%eax
f01012c1:	50                   	push   %eax
f01012c2:	6a 56                	push   $0x56
f01012c4:	8d 86 d3 8a f7 ff    	lea    -0x8752d(%esi),%eax
f01012ca:	50                   	push   %eax
f01012cb:	89 f3                	mov    %esi,%ebx
f01012cd:	e8 e3 ed ff ff       	call   f01000b5 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01012d2:	51                   	push   %ecx
f01012d3:	8d 86 b8 8e f7 ff    	lea    -0x87148(%esi),%eax
f01012d9:	50                   	push   %eax
f01012da:	68 c3 01 00 00       	push   $0x1c3
f01012df:	8d 86 c7 8a f7 ff    	lea    -0x87539(%esi),%eax
f01012e5:	50                   	push   %eax
f01012e6:	89 f3                	mov    %esi,%ebx
f01012e8:	e8 c8 ed ff ff       	call   f01000b5 <_panic>
			return NULL;
f01012ed:	b8 00 00 00 00       	mov    $0x0,%eax
f01012f2:	e9 4e ff ff ff       	jmp    f0101245 <pgdir_walk+0x57>

f01012f7 <boot_map_region>:
{
f01012f7:	55                   	push   %ebp
f01012f8:	89 e5                	mov    %esp,%ebp
f01012fa:	57                   	push   %edi
f01012fb:	56                   	push   %esi
f01012fc:	53                   	push   %ebx
f01012fd:	83 ec 1c             	sub    $0x1c,%esp
f0101300:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101303:	8b 45 08             	mov    0x8(%ebp),%eax
	size_t pgs = (size + PGSIZE - 1) / PGSIZE;
f0101306:	8d b1 ff 0f 00 00    	lea    0xfff(%ecx),%esi
f010130c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f0101312:	01 c6                	add    %eax,%esi
	for(size_t i = 0; i < pgs; i++){
f0101314:	89 c3                	mov    %eax,%ebx
		pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
f0101316:	89 d7                	mov    %edx,%edi
f0101318:	29 c7                	sub    %eax,%edi
	for(size_t i = 0; i < pgs; i++){
f010131a:	39 f3                	cmp    %esi,%ebx
f010131c:	74 28                	je     f0101346 <boot_map_region+0x4f>
		pte_t* pte = pgdir_walk(pgdir, (void*)va, true);
f010131e:	83 ec 04             	sub    $0x4,%esp
f0101321:	6a 01                	push   $0x1
f0101323:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
f0101326:	50                   	push   %eax
f0101327:	ff 75 e4             	pushl  -0x1c(%ebp)
f010132a:	e8 bf fe ff ff       	call   f01011ee <pgdir_walk>
f010132f:	89 c2                	mov    %eax,%edx
		*pte = pa | PTE_P | perm;
f0101331:	89 d8                	mov    %ebx,%eax
f0101333:	0b 45 0c             	or     0xc(%ebp),%eax
f0101336:	83 c8 01             	or     $0x1,%eax
f0101339:	89 02                	mov    %eax,(%edx)
		pa += PGSIZE;
f010133b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101341:	83 c4 10             	add    $0x10,%esp
f0101344:	eb d4                	jmp    f010131a <boot_map_region+0x23>
}
f0101346:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101349:	5b                   	pop    %ebx
f010134a:	5e                   	pop    %esi
f010134b:	5f                   	pop    %edi
f010134c:	5d                   	pop    %ebp
f010134d:	c3                   	ret    

f010134e <page_lookup>:
{
f010134e:	f3 0f 1e fb          	endbr32 
f0101352:	55                   	push   %ebp
f0101353:	89 e5                	mov    %esp,%ebp
f0101355:	56                   	push   %esi
f0101356:	53                   	push   %ebx
f0101357:	e8 17 ee ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f010135c:	81 c3 c0 bc 08 00    	add    $0x8bcc0,%ebx
f0101362:	8b 75 10             	mov    0x10(%ebp),%esi
	pte_t* pte = pgdir_walk(pgdir, va, false);
f0101365:	83 ec 04             	sub    $0x4,%esp
f0101368:	6a 00                	push   $0x0
f010136a:	ff 75 0c             	pushl  0xc(%ebp)
f010136d:	ff 75 08             	pushl  0x8(%ebp)
f0101370:	e8 79 fe ff ff       	call   f01011ee <pgdir_walk>
	if(!pte || !((*pte) & PTE_P)){
f0101375:	83 c4 10             	add    $0x10,%esp
f0101378:	85 c0                	test   %eax,%eax
f010137a:	74 25                	je     f01013a1 <page_lookup+0x53>
f010137c:	f6 00 01             	testb  $0x1,(%eax)
f010137f:	74 3f                	je     f01013c0 <page_lookup+0x72>
	if(pte_store != NULL){
f0101381:	85 f6                	test   %esi,%esi
f0101383:	74 02                	je     f0101387 <page_lookup+0x39>
		*pte_store = pte;
f0101385:	89 06                	mov    %eax,(%esi)
f0101387:	8b 00                	mov    (%eax),%eax
f0101389:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010138c:	c7 c2 04 00 19 f0    	mov    $0xf0190004,%edx
f0101392:	39 02                	cmp    %eax,(%edx)
f0101394:	76 12                	jbe    f01013a8 <page_lookup+0x5a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101396:	c7 c2 0c 00 19 f0    	mov    $0xf019000c,%edx
f010139c:	8b 12                	mov    (%edx),%edx
f010139e:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f01013a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01013a4:	5b                   	pop    %ebx
f01013a5:	5e                   	pop    %esi
f01013a6:	5d                   	pop    %ebp
f01013a7:	c3                   	ret    
		panic("pa2page called with invalid pa");
f01013a8:	83 ec 04             	sub    $0x4,%esp
f01013ab:	8d 83 40 8f f7 ff    	lea    -0x870c0(%ebx),%eax
f01013b1:	50                   	push   %eax
f01013b2:	6a 4f                	push   $0x4f
f01013b4:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f01013ba:	50                   	push   %eax
f01013bb:	e8 f5 ec ff ff       	call   f01000b5 <_panic>
		return NULL;
f01013c0:	b8 00 00 00 00       	mov    $0x0,%eax
f01013c5:	eb da                	jmp    f01013a1 <page_lookup+0x53>

f01013c7 <page_remove>:
{
f01013c7:	f3 0f 1e fb          	endbr32 
f01013cb:	55                   	push   %ebp
f01013cc:	89 e5                	mov    %esp,%ebp
f01013ce:	53                   	push   %ebx
f01013cf:	83 ec 18             	sub    $0x18,%esp
f01013d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct PageInfo* pp = page_lookup(pgdir, va, &pte);
f01013d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01013d8:	50                   	push   %eax
f01013d9:	53                   	push   %ebx
f01013da:	ff 75 08             	pushl  0x8(%ebp)
f01013dd:	e8 6c ff ff ff       	call   f010134e <page_lookup>
	if(pp){
f01013e2:	83 c4 10             	add    $0x10,%esp
f01013e5:	85 c0                	test   %eax,%eax
f01013e7:	74 18                	je     f0101401 <page_remove+0x3a>
		page_decref(pp);
f01013e9:	83 ec 0c             	sub    $0xc,%esp
f01013ec:	50                   	push   %eax
f01013ed:	e8 cf fd ff ff       	call   f01011c1 <page_decref>
		*pte = 0;
f01013f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01013f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01013fb:	0f 01 3b             	invlpg (%ebx)
}
f01013fe:	83 c4 10             	add    $0x10,%esp
}
f0101401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101404:	c9                   	leave  
f0101405:	c3                   	ret    

f0101406 <page_insert>:
{
f0101406:	f3 0f 1e fb          	endbr32 
f010140a:	55                   	push   %ebp
f010140b:	89 e5                	mov    %esp,%ebp
f010140d:	57                   	push   %edi
f010140e:	56                   	push   %esi
f010140f:	53                   	push   %ebx
f0101410:	83 ec 10             	sub    $0x10,%esp
f0101413:	e8 3c 1e 00 00       	call   f0103254 <__x86.get_pc_thunk.di>
f0101418:	81 c7 04 bc 08 00    	add    $0x8bc04,%edi
f010141e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t* pte = pgdir_walk(pgdir, va, true);
f0101421:	6a 01                	push   $0x1
f0101423:	ff 75 10             	pushl  0x10(%ebp)
f0101426:	ff 75 08             	pushl  0x8(%ebp)
f0101429:	e8 c0 fd ff ff       	call   f01011ee <pgdir_walk>
	if(!pte){
f010142e:	83 c4 10             	add    $0x10,%esp
f0101431:	85 c0                	test   %eax,%eax
f0101433:	74 72                	je     f01014a7 <page_insert+0xa1>
f0101435:	89 c6                	mov    %eax,%esi
	if((*pte) & PTE_P){
f0101437:	8b 00                	mov    (%eax),%eax
f0101439:	a8 01                	test   $0x1,%al
f010143b:	74 20                	je     f010145d <page_insert+0x57>
		if(PTE_ADDR(*pte) == page2pa(pp)){
f010143d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	return (pp - pages) << PGSHIFT;
f0101442:	c7 c2 0c 00 19 f0    	mov    $0xf019000c,%edx
f0101448:	89 d9                	mov    %ebx,%ecx
f010144a:	2b 0a                	sub    (%edx),%ecx
f010144c:	89 ca                	mov    %ecx,%edx
f010144e:	c1 fa 03             	sar    $0x3,%edx
f0101451:	c1 e2 0c             	shl    $0xc,%edx
f0101454:	39 d0                	cmp    %edx,%eax
f0101456:	75 3c                	jne    f0101494 <page_insert+0x8e>
			pp->pp_ref--;
f0101458:	66 83 6b 04 01       	subw   $0x1,0x4(%ebx)
	pp->pp_ref++;
f010145d:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
f0101462:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0101468:	2b 18                	sub    (%eax),%ebx
f010146a:	c1 fb 03             	sar    $0x3,%ebx
f010146d:	c1 e3 0c             	shl    $0xc,%ebx
	*pte = page2pa(pp) | perm | PTE_P;
f0101470:	0b 5d 14             	or     0x14(%ebp),%ebx
f0101473:	83 cb 01             	or     $0x1,%ebx
f0101476:	89 1e                	mov    %ebx,(%esi)
	pgdir[PDX(va)] |= perm;
f0101478:	8b 45 10             	mov    0x10(%ebp),%eax
f010147b:	c1 e8 16             	shr    $0x16,%eax
f010147e:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101481:	8b 7d 14             	mov    0x14(%ebp),%edi
f0101484:	09 3c 81             	or     %edi,(%ecx,%eax,4)
	return 0;
f0101487:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010148c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010148f:	5b                   	pop    %ebx
f0101490:	5e                   	pop    %esi
f0101491:	5f                   	pop    %edi
f0101492:	5d                   	pop    %ebp
f0101493:	c3                   	ret    
			page_remove(pgdir, va);
f0101494:	83 ec 08             	sub    $0x8,%esp
f0101497:	ff 75 10             	pushl  0x10(%ebp)
f010149a:	ff 75 08             	pushl  0x8(%ebp)
f010149d:	e8 25 ff ff ff       	call   f01013c7 <page_remove>
f01014a2:	83 c4 10             	add    $0x10,%esp
f01014a5:	eb b6                	jmp    f010145d <page_insert+0x57>
		return -E_NO_MEM;
f01014a7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01014ac:	eb de                	jmp    f010148c <page_insert+0x86>

f01014ae <mem_init>:
{
f01014ae:	f3 0f 1e fb          	endbr32 
f01014b2:	55                   	push   %ebp
f01014b3:	89 e5                	mov    %esp,%ebp
f01014b5:	57                   	push   %edi
f01014b6:	56                   	push   %esi
f01014b7:	53                   	push   %ebx
f01014b8:	83 ec 3c             	sub    $0x3c,%esp
f01014bb:	e8 b3 ec ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f01014c0:	81 c3 5c bb 08 00    	add    $0x8bb5c,%ebx
	basemem = nvram_read(NVRAM_BASELO);
f01014c6:	b8 15 00 00 00       	mov    $0x15,%eax
f01014cb:	e8 5c f6 ff ff       	call   f0100b2c <nvram_read>
f01014d0:	89 c6                	mov    %eax,%esi
	extmem = nvram_read(NVRAM_EXTLO);
f01014d2:	b8 17 00 00 00       	mov    $0x17,%eax
f01014d7:	e8 50 f6 ff ff       	call   f0100b2c <nvram_read>
f01014dc:	89 c7                	mov    %eax,%edi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f01014de:	b8 34 00 00 00       	mov    $0x34,%eax
f01014e3:	e8 44 f6 ff ff       	call   f0100b2c <nvram_read>
	if (ext16mem)
f01014e8:	c1 e0 06             	shl    $0x6,%eax
f01014eb:	0f 84 ec 00 00 00    	je     f01015dd <mem_init+0x12f>
		totalmem = 16 * 1024 + ext16mem;
f01014f1:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f01014f6:	89 c1                	mov    %eax,%ecx
f01014f8:	c1 e9 02             	shr    $0x2,%ecx
f01014fb:	c7 c2 04 00 19 f0    	mov    $0xf0190004,%edx
f0101501:	89 0a                	mov    %ecx,(%edx)
	npages_basemem = basemem / (PGSIZE / 1024);
f0101503:	89 f2                	mov    %esi,%edx
f0101505:	c1 ea 02             	shr    $0x2,%edx
f0101508:	89 93 28 23 00 00    	mov    %edx,0x2328(%ebx)
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010150e:	89 c2                	mov    %eax,%edx
f0101510:	29 f2                	sub    %esi,%edx
f0101512:	52                   	push   %edx
f0101513:	56                   	push   %esi
f0101514:	50                   	push   %eax
f0101515:	8d 83 60 8f f7 ff    	lea    -0x870a0(%ebx),%eax
f010151b:	50                   	push   %eax
f010151c:	e8 a3 25 00 00       	call   f0103ac4 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101521:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101526:	e8 93 f5 ff ff       	call   f0100abe <boot_alloc>
f010152b:	c7 c6 08 00 19 f0    	mov    $0xf0190008,%esi
f0101531:	89 06                	mov    %eax,(%esi)
	memset(kern_pgdir, 0, PGSIZE);
f0101533:	83 c4 0c             	add    $0xc,%esp
f0101536:	68 00 10 00 00       	push   $0x1000
f010153b:	6a 00                	push   $0x0
f010153d:	50                   	push   %eax
f010153e:	e8 45 3c 00 00       	call   f0105188 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101543:	8b 06                	mov    (%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0101545:	83 c4 10             	add    $0x10,%esp
f0101548:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010154d:	0f 86 9a 00 00 00    	jbe    f01015ed <mem_init+0x13f>
	return (physaddr_t)kva - KERNBASE;
f0101553:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101559:	83 ca 05             	or     $0x5,%edx
f010155c:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);
f0101562:	c7 c7 04 00 19 f0    	mov    $0xf0190004,%edi
f0101568:	8b 07                	mov    (%edi),%eax
f010156a:	c1 e0 03             	shl    $0x3,%eax
f010156d:	e8 4c f5 ff ff       	call   f0100abe <boot_alloc>
f0101572:	c7 c6 0c 00 19 f0    	mov    $0xf019000c,%esi
f0101578:	89 06                	mov    %eax,(%esi)
	memset(pages, 0, sizeof(struct PageInfo) * npages);
f010157a:	83 ec 04             	sub    $0x4,%esp
f010157d:	8b 17                	mov    (%edi),%edx
f010157f:	c1 e2 03             	shl    $0x3,%edx
f0101582:	52                   	push   %edx
f0101583:	6a 00                	push   $0x0
f0101585:	50                   	push   %eax
f0101586:	e8 fd 3b 00 00       	call   f0105188 <memset>
	envs = (struct Env*)boot_alloc(sizeof(struct Env) * NENV);
f010158b:	b8 00 80 01 00       	mov    $0x18000,%eax
f0101590:	e8 29 f5 ff ff       	call   f0100abe <boot_alloc>
f0101595:	c7 c2 4c f3 18 f0    	mov    $0xf018f34c,%edx
f010159b:	89 02                	mov    %eax,(%edx)
	memset(envs, 0, sizeof(struct Env) * NENV);
f010159d:	83 c4 0c             	add    $0xc,%esp
f01015a0:	68 00 80 01 00       	push   $0x18000
f01015a5:	6a 00                	push   $0x0
f01015a7:	50                   	push   %eax
f01015a8:	e8 db 3b 00 00       	call   f0105188 <memset>
	page_init();
f01015ad:	e8 a6 f9 ff ff       	call   f0100f58 <page_init>
	check_page_free_list(1);
f01015b2:	b8 01 00 00 00       	mov    $0x1,%eax
f01015b7:	e8 22 f6 ff ff       	call   f0100bde <check_page_free_list>
	if (!pages)
f01015bc:	83 c4 10             	add    $0x10,%esp
f01015bf:	83 3e 00             	cmpl   $0x0,(%esi)
f01015c2:	74 42                	je     f0101606 <mem_init+0x158>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01015c4:	8b 83 24 23 00 00    	mov    0x2324(%ebx),%eax
f01015ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
f01015d1:	85 c0                	test   %eax,%eax
f01015d3:	74 4c                	je     f0101621 <mem_init+0x173>
		++nfree;
f01015d5:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01015d9:	8b 00                	mov    (%eax),%eax
f01015db:	eb f4                	jmp    f01015d1 <mem_init+0x123>
		totalmem = 1 * 1024 + extmem;
f01015dd:	8d 87 00 04 00 00    	lea    0x400(%edi),%eax
f01015e3:	85 ff                	test   %edi,%edi
f01015e5:	0f 44 c6             	cmove  %esi,%eax
f01015e8:	e9 09 ff ff ff       	jmp    f01014f6 <mem_init+0x48>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01015ed:	50                   	push   %eax
f01015ee:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f01015f4:	50                   	push   %eax
f01015f5:	68 95 00 00 00       	push   $0x95
f01015fa:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0101600:	50                   	push   %eax
f0101601:	e8 af ea ff ff       	call   f01000b5 <_panic>
		panic("'pages' is a null pointer!");
f0101606:	83 ec 04             	sub    $0x4,%esp
f0101609:	8d 83 7d 8b f7 ff    	lea    -0x87483(%ebx),%eax
f010160f:	50                   	push   %eax
f0101610:	68 03 03 00 00       	push   $0x303
f0101615:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010161b:	50                   	push   %eax
f010161c:	e8 94 ea ff ff       	call   f01000b5 <_panic>
	assert((pp0 = page_alloc(0)));
f0101621:	83 ec 0c             	sub    $0xc,%esp
f0101624:	6a 00                	push   $0x0
f0101626:	e8 85 fa ff ff       	call   f01010b0 <page_alloc>
f010162b:	89 c6                	mov    %eax,%esi
f010162d:	83 c4 10             	add    $0x10,%esp
f0101630:	85 c0                	test   %eax,%eax
f0101632:	0f 84 31 02 00 00    	je     f0101869 <mem_init+0x3bb>
	assert((pp1 = page_alloc(0)));
f0101638:	83 ec 0c             	sub    $0xc,%esp
f010163b:	6a 00                	push   $0x0
f010163d:	e8 6e fa ff ff       	call   f01010b0 <page_alloc>
f0101642:	89 c7                	mov    %eax,%edi
f0101644:	83 c4 10             	add    $0x10,%esp
f0101647:	85 c0                	test   %eax,%eax
f0101649:	0f 84 39 02 00 00    	je     f0101888 <mem_init+0x3da>
	assert((pp2 = page_alloc(0)));
f010164f:	83 ec 0c             	sub    $0xc,%esp
f0101652:	6a 00                	push   $0x0
f0101654:	e8 57 fa ff ff       	call   f01010b0 <page_alloc>
f0101659:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010165c:	83 c4 10             	add    $0x10,%esp
f010165f:	85 c0                	test   %eax,%eax
f0101661:	0f 84 40 02 00 00    	je     f01018a7 <mem_init+0x3f9>
	assert(pp1 && pp1 != pp0);
f0101667:	39 fe                	cmp    %edi,%esi
f0101669:	0f 84 57 02 00 00    	je     f01018c6 <mem_init+0x418>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010166f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101672:	39 c7                	cmp    %eax,%edi
f0101674:	0f 84 6b 02 00 00    	je     f01018e5 <mem_init+0x437>
f010167a:	39 c6                	cmp    %eax,%esi
f010167c:	0f 84 63 02 00 00    	je     f01018e5 <mem_init+0x437>
	return (pp - pages) << PGSHIFT;
f0101682:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0101688:	8b 08                	mov    (%eax),%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f010168a:	c7 c0 04 00 19 f0    	mov    $0xf0190004,%eax
f0101690:	8b 10                	mov    (%eax),%edx
f0101692:	c1 e2 0c             	shl    $0xc,%edx
f0101695:	89 f0                	mov    %esi,%eax
f0101697:	29 c8                	sub    %ecx,%eax
f0101699:	c1 f8 03             	sar    $0x3,%eax
f010169c:	c1 e0 0c             	shl    $0xc,%eax
f010169f:	39 d0                	cmp    %edx,%eax
f01016a1:	0f 83 5d 02 00 00    	jae    f0101904 <mem_init+0x456>
f01016a7:	89 f8                	mov    %edi,%eax
f01016a9:	29 c8                	sub    %ecx,%eax
f01016ab:	c1 f8 03             	sar    $0x3,%eax
f01016ae:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f01016b1:	39 c2                	cmp    %eax,%edx
f01016b3:	0f 86 6a 02 00 00    	jbe    f0101923 <mem_init+0x475>
f01016b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01016bc:	29 c8                	sub    %ecx,%eax
f01016be:	c1 f8 03             	sar    $0x3,%eax
f01016c1:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f01016c4:	39 c2                	cmp    %eax,%edx
f01016c6:	0f 86 76 02 00 00    	jbe    f0101942 <mem_init+0x494>
	fl = page_free_list;
f01016cc:	8b 83 24 23 00 00    	mov    0x2324(%ebx),%eax
f01016d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f01016d5:	c7 83 24 23 00 00 00 	movl   $0x0,0x2324(%ebx)
f01016dc:	00 00 00 
	assert(!page_alloc(0));
f01016df:	83 ec 0c             	sub    $0xc,%esp
f01016e2:	6a 00                	push   $0x0
f01016e4:	e8 c7 f9 ff ff       	call   f01010b0 <page_alloc>
f01016e9:	83 c4 10             	add    $0x10,%esp
f01016ec:	85 c0                	test   %eax,%eax
f01016ee:	0f 85 6d 02 00 00    	jne    f0101961 <mem_init+0x4b3>
	page_free(pp0);
f01016f4:	83 ec 0c             	sub    $0xc,%esp
f01016f7:	56                   	push   %esi
f01016f8:	e8 56 fa ff ff       	call   f0101153 <page_free>
	page_free(pp1);
f01016fd:	89 3c 24             	mov    %edi,(%esp)
f0101700:	e8 4e fa ff ff       	call   f0101153 <page_free>
	page_free(pp2);
f0101705:	83 c4 04             	add    $0x4,%esp
f0101708:	ff 75 d4             	pushl  -0x2c(%ebp)
f010170b:	e8 43 fa ff ff       	call   f0101153 <page_free>
	assert((pp0 = page_alloc(0)));
f0101710:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101717:	e8 94 f9 ff ff       	call   f01010b0 <page_alloc>
f010171c:	89 c6                	mov    %eax,%esi
f010171e:	83 c4 10             	add    $0x10,%esp
f0101721:	85 c0                	test   %eax,%eax
f0101723:	0f 84 57 02 00 00    	je     f0101980 <mem_init+0x4d2>
	assert((pp1 = page_alloc(0)));
f0101729:	83 ec 0c             	sub    $0xc,%esp
f010172c:	6a 00                	push   $0x0
f010172e:	e8 7d f9 ff ff       	call   f01010b0 <page_alloc>
f0101733:	89 c7                	mov    %eax,%edi
f0101735:	83 c4 10             	add    $0x10,%esp
f0101738:	85 c0                	test   %eax,%eax
f010173a:	0f 84 5f 02 00 00    	je     f010199f <mem_init+0x4f1>
	assert((pp2 = page_alloc(0)));
f0101740:	83 ec 0c             	sub    $0xc,%esp
f0101743:	6a 00                	push   $0x0
f0101745:	e8 66 f9 ff ff       	call   f01010b0 <page_alloc>
f010174a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010174d:	83 c4 10             	add    $0x10,%esp
f0101750:	85 c0                	test   %eax,%eax
f0101752:	0f 84 66 02 00 00    	je     f01019be <mem_init+0x510>
	assert(pp1 && pp1 != pp0);
f0101758:	39 fe                	cmp    %edi,%esi
f010175a:	0f 84 7d 02 00 00    	je     f01019dd <mem_init+0x52f>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101760:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101763:	39 c7                	cmp    %eax,%edi
f0101765:	0f 84 91 02 00 00    	je     f01019fc <mem_init+0x54e>
f010176b:	39 c6                	cmp    %eax,%esi
f010176d:	0f 84 89 02 00 00    	je     f01019fc <mem_init+0x54e>
	assert(!page_alloc(0));
f0101773:	83 ec 0c             	sub    $0xc,%esp
f0101776:	6a 00                	push   $0x0
f0101778:	e8 33 f9 ff ff       	call   f01010b0 <page_alloc>
f010177d:	83 c4 10             	add    $0x10,%esp
f0101780:	85 c0                	test   %eax,%eax
f0101782:	0f 85 93 02 00 00    	jne    f0101a1b <mem_init+0x56d>
f0101788:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f010178e:	89 f1                	mov    %esi,%ecx
f0101790:	2b 08                	sub    (%eax),%ecx
f0101792:	89 c8                	mov    %ecx,%eax
f0101794:	c1 f8 03             	sar    $0x3,%eax
f0101797:	89 c2                	mov    %eax,%edx
f0101799:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010179c:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01017a1:	c7 c1 04 00 19 f0    	mov    $0xf0190004,%ecx
f01017a7:	3b 01                	cmp    (%ecx),%eax
f01017a9:	0f 83 8b 02 00 00    	jae    f0101a3a <mem_init+0x58c>
	memset(page2kva(pp0), 1, PGSIZE);
f01017af:	83 ec 04             	sub    $0x4,%esp
f01017b2:	68 00 10 00 00       	push   $0x1000
f01017b7:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01017b9:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f01017bf:	52                   	push   %edx
f01017c0:	e8 c3 39 00 00       	call   f0105188 <memset>
	page_free(pp0);
f01017c5:	89 34 24             	mov    %esi,(%esp)
f01017c8:	e8 86 f9 ff ff       	call   f0101153 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01017cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01017d4:	e8 d7 f8 ff ff       	call   f01010b0 <page_alloc>
f01017d9:	83 c4 10             	add    $0x10,%esp
f01017dc:	85 c0                	test   %eax,%eax
f01017de:	0f 84 6c 02 00 00    	je     f0101a50 <mem_init+0x5a2>
	assert(pp && pp0 == pp);
f01017e4:	39 c6                	cmp    %eax,%esi
f01017e6:	0f 85 83 02 00 00    	jne    f0101a6f <mem_init+0x5c1>
	return (pp - pages) << PGSHIFT;
f01017ec:	c7 c2 0c 00 19 f0    	mov    $0xf019000c,%edx
f01017f2:	2b 02                	sub    (%edx),%eax
f01017f4:	c1 f8 03             	sar    $0x3,%eax
f01017f7:	89 c2                	mov    %eax,%edx
f01017f9:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01017fc:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101801:	c7 c1 04 00 19 f0    	mov    $0xf0190004,%ecx
f0101807:	3b 01                	cmp    (%ecx),%eax
f0101809:	0f 83 7f 02 00 00    	jae    f0101a8e <mem_init+0x5e0>
	return (void *)(pa + KERNBASE);
f010180f:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101815:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f010181b:	80 38 00             	cmpb   $0x0,(%eax)
f010181e:	0f 85 80 02 00 00    	jne    f0101aa4 <mem_init+0x5f6>
f0101824:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f0101827:	39 d0                	cmp    %edx,%eax
f0101829:	75 f0                	jne    f010181b <mem_init+0x36d>
	page_free_list = fl;
f010182b:	8b 45 cc             	mov    -0x34(%ebp),%eax
f010182e:	89 83 24 23 00 00    	mov    %eax,0x2324(%ebx)
	page_free(pp0);
f0101834:	83 ec 0c             	sub    $0xc,%esp
f0101837:	56                   	push   %esi
f0101838:	e8 16 f9 ff ff       	call   f0101153 <page_free>
	page_free(pp1);
f010183d:	89 3c 24             	mov    %edi,(%esp)
f0101840:	e8 0e f9 ff ff       	call   f0101153 <page_free>
	page_free(pp2);
f0101845:	83 c4 04             	add    $0x4,%esp
f0101848:	ff 75 d4             	pushl  -0x2c(%ebp)
f010184b:	e8 03 f9 ff ff       	call   f0101153 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101850:	8b 83 24 23 00 00    	mov    0x2324(%ebx),%eax
f0101856:	83 c4 10             	add    $0x10,%esp
f0101859:	85 c0                	test   %eax,%eax
f010185b:	0f 84 62 02 00 00    	je     f0101ac3 <mem_init+0x615>
		--nfree;
f0101861:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101865:	8b 00                	mov    (%eax),%eax
f0101867:	eb f0                	jmp    f0101859 <mem_init+0x3ab>
	assert((pp0 = page_alloc(0)));
f0101869:	8d 83 98 8b f7 ff    	lea    -0x87468(%ebx),%eax
f010186f:	50                   	push   %eax
f0101870:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0101876:	50                   	push   %eax
f0101877:	68 0b 03 00 00       	push   $0x30b
f010187c:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0101882:	50                   	push   %eax
f0101883:	e8 2d e8 ff ff       	call   f01000b5 <_panic>
	assert((pp1 = page_alloc(0)));
f0101888:	8d 83 ae 8b f7 ff    	lea    -0x87452(%ebx),%eax
f010188e:	50                   	push   %eax
f010188f:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0101895:	50                   	push   %eax
f0101896:	68 0c 03 00 00       	push   $0x30c
f010189b:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01018a1:	50                   	push   %eax
f01018a2:	e8 0e e8 ff ff       	call   f01000b5 <_panic>
	assert((pp2 = page_alloc(0)));
f01018a7:	8d 83 c4 8b f7 ff    	lea    -0x8743c(%ebx),%eax
f01018ad:	50                   	push   %eax
f01018ae:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01018b4:	50                   	push   %eax
f01018b5:	68 0d 03 00 00       	push   $0x30d
f01018ba:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01018c0:	50                   	push   %eax
f01018c1:	e8 ef e7 ff ff       	call   f01000b5 <_panic>
	assert(pp1 && pp1 != pp0);
f01018c6:	8d 83 da 8b f7 ff    	lea    -0x87426(%ebx),%eax
f01018cc:	50                   	push   %eax
f01018cd:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01018d3:	50                   	push   %eax
f01018d4:	68 10 03 00 00       	push   $0x310
f01018d9:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01018df:	50                   	push   %eax
f01018e0:	e8 d0 e7 ff ff       	call   f01000b5 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018e5:	8d 83 9c 8f f7 ff    	lea    -0x87064(%ebx),%eax
f01018eb:	50                   	push   %eax
f01018ec:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01018f2:	50                   	push   %eax
f01018f3:	68 11 03 00 00       	push   $0x311
f01018f8:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01018fe:	50                   	push   %eax
f01018ff:	e8 b1 e7 ff ff       	call   f01000b5 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101904:	8d 83 ec 8b f7 ff    	lea    -0x87414(%ebx),%eax
f010190a:	50                   	push   %eax
f010190b:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0101911:	50                   	push   %eax
f0101912:	68 12 03 00 00       	push   $0x312
f0101917:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010191d:	50                   	push   %eax
f010191e:	e8 92 e7 ff ff       	call   f01000b5 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101923:	8d 83 09 8c f7 ff    	lea    -0x873f7(%ebx),%eax
f0101929:	50                   	push   %eax
f010192a:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0101930:	50                   	push   %eax
f0101931:	68 13 03 00 00       	push   $0x313
f0101936:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010193c:	50                   	push   %eax
f010193d:	e8 73 e7 ff ff       	call   f01000b5 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101942:	8d 83 26 8c f7 ff    	lea    -0x873da(%ebx),%eax
f0101948:	50                   	push   %eax
f0101949:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010194f:	50                   	push   %eax
f0101950:	68 14 03 00 00       	push   $0x314
f0101955:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010195b:	50                   	push   %eax
f010195c:	e8 54 e7 ff ff       	call   f01000b5 <_panic>
	assert(!page_alloc(0));
f0101961:	8d 83 43 8c f7 ff    	lea    -0x873bd(%ebx),%eax
f0101967:	50                   	push   %eax
f0101968:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010196e:	50                   	push   %eax
f010196f:	68 1b 03 00 00       	push   $0x31b
f0101974:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010197a:	50                   	push   %eax
f010197b:	e8 35 e7 ff ff       	call   f01000b5 <_panic>
	assert((pp0 = page_alloc(0)));
f0101980:	8d 83 98 8b f7 ff    	lea    -0x87468(%ebx),%eax
f0101986:	50                   	push   %eax
f0101987:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010198d:	50                   	push   %eax
f010198e:	68 22 03 00 00       	push   $0x322
f0101993:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0101999:	50                   	push   %eax
f010199a:	e8 16 e7 ff ff       	call   f01000b5 <_panic>
	assert((pp1 = page_alloc(0)));
f010199f:	8d 83 ae 8b f7 ff    	lea    -0x87452(%ebx),%eax
f01019a5:	50                   	push   %eax
f01019a6:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01019ac:	50                   	push   %eax
f01019ad:	68 23 03 00 00       	push   $0x323
f01019b2:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01019b8:	50                   	push   %eax
f01019b9:	e8 f7 e6 ff ff       	call   f01000b5 <_panic>
	assert((pp2 = page_alloc(0)));
f01019be:	8d 83 c4 8b f7 ff    	lea    -0x8743c(%ebx),%eax
f01019c4:	50                   	push   %eax
f01019c5:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01019cb:	50                   	push   %eax
f01019cc:	68 24 03 00 00       	push   $0x324
f01019d1:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01019d7:	50                   	push   %eax
f01019d8:	e8 d8 e6 ff ff       	call   f01000b5 <_panic>
	assert(pp1 && pp1 != pp0);
f01019dd:	8d 83 da 8b f7 ff    	lea    -0x87426(%ebx),%eax
f01019e3:	50                   	push   %eax
f01019e4:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01019ea:	50                   	push   %eax
f01019eb:	68 26 03 00 00       	push   $0x326
f01019f0:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01019f6:	50                   	push   %eax
f01019f7:	e8 b9 e6 ff ff       	call   f01000b5 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019fc:	8d 83 9c 8f f7 ff    	lea    -0x87064(%ebx),%eax
f0101a02:	50                   	push   %eax
f0101a03:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0101a09:	50                   	push   %eax
f0101a0a:	68 27 03 00 00       	push   $0x327
f0101a0f:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0101a15:	50                   	push   %eax
f0101a16:	e8 9a e6 ff ff       	call   f01000b5 <_panic>
	assert(!page_alloc(0));
f0101a1b:	8d 83 43 8c f7 ff    	lea    -0x873bd(%ebx),%eax
f0101a21:	50                   	push   %eax
f0101a22:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0101a28:	50                   	push   %eax
f0101a29:	68 28 03 00 00       	push   $0x328
f0101a2e:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0101a34:	50                   	push   %eax
f0101a35:	e8 7b e6 ff ff       	call   f01000b5 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101a3a:	52                   	push   %edx
f0101a3b:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f0101a41:	50                   	push   %eax
f0101a42:	6a 56                	push   $0x56
f0101a44:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f0101a4a:	50                   	push   %eax
f0101a4b:	e8 65 e6 ff ff       	call   f01000b5 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101a50:	8d 83 52 8c f7 ff    	lea    -0x873ae(%ebx),%eax
f0101a56:	50                   	push   %eax
f0101a57:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0101a5d:	50                   	push   %eax
f0101a5e:	68 2d 03 00 00       	push   $0x32d
f0101a63:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0101a69:	50                   	push   %eax
f0101a6a:	e8 46 e6 ff ff       	call   f01000b5 <_panic>
	assert(pp && pp0 == pp);
f0101a6f:	8d 83 70 8c f7 ff    	lea    -0x87390(%ebx),%eax
f0101a75:	50                   	push   %eax
f0101a76:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0101a7c:	50                   	push   %eax
f0101a7d:	68 2e 03 00 00       	push   $0x32e
f0101a82:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0101a88:	50                   	push   %eax
f0101a89:	e8 27 e6 ff ff       	call   f01000b5 <_panic>
f0101a8e:	52                   	push   %edx
f0101a8f:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f0101a95:	50                   	push   %eax
f0101a96:	6a 56                	push   $0x56
f0101a98:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f0101a9e:	50                   	push   %eax
f0101a9f:	e8 11 e6 ff ff       	call   f01000b5 <_panic>
		assert(c[i] == 0);
f0101aa4:	8d 83 80 8c f7 ff    	lea    -0x87380(%ebx),%eax
f0101aaa:	50                   	push   %eax
f0101aab:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0101ab1:	50                   	push   %eax
f0101ab2:	68 31 03 00 00       	push   $0x331
f0101ab7:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0101abd:	50                   	push   %eax
f0101abe:	e8 f2 e5 ff ff       	call   f01000b5 <_panic>
	assert(nfree == 0);
f0101ac3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0101ac7:	0f 85 7f 08 00 00    	jne    f010234c <mem_init+0xe9e>
	cprintf("check_page_alloc() succeeded!\n");
f0101acd:	83 ec 0c             	sub    $0xc,%esp
f0101ad0:	8d 83 bc 8f f7 ff    	lea    -0x87044(%ebx),%eax
f0101ad6:	50                   	push   %eax
f0101ad7:	e8 e8 1f 00 00       	call   f0103ac4 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101adc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101ae3:	e8 c8 f5 ff ff       	call   f01010b0 <page_alloc>
f0101ae8:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101aeb:	83 c4 10             	add    $0x10,%esp
f0101aee:	85 c0                	test   %eax,%eax
f0101af0:	0f 84 75 08 00 00    	je     f010236b <mem_init+0xebd>
	assert((pp1 = page_alloc(0)));
f0101af6:	83 ec 0c             	sub    $0xc,%esp
f0101af9:	6a 00                	push   $0x0
f0101afb:	e8 b0 f5 ff ff       	call   f01010b0 <page_alloc>
f0101b00:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101b03:	83 c4 10             	add    $0x10,%esp
f0101b06:	85 c0                	test   %eax,%eax
f0101b08:	0f 84 7c 08 00 00    	je     f010238a <mem_init+0xedc>
	assert((pp2 = page_alloc(0)));
f0101b0e:	83 ec 0c             	sub    $0xc,%esp
f0101b11:	6a 00                	push   $0x0
f0101b13:	e8 98 f5 ff ff       	call   f01010b0 <page_alloc>
f0101b18:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101b1b:	83 c4 10             	add    $0x10,%esp
f0101b1e:	85 c0                	test   %eax,%eax
f0101b20:	0f 84 83 08 00 00    	je     f01023a9 <mem_init+0xefb>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101b26:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0101b29:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0101b2c:	0f 84 96 08 00 00    	je     f01023c8 <mem_init+0xf1a>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b32:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101b35:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101b38:	0f 84 a9 08 00 00    	je     f01023e7 <mem_init+0xf39>
f0101b3e:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0101b41:	0f 84 a0 08 00 00    	je     f01023e7 <mem_init+0xf39>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101b47:	8b 83 24 23 00 00    	mov    0x2324(%ebx),%eax
f0101b4d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	page_free_list = 0;
f0101b50:	c7 83 24 23 00 00 00 	movl   $0x0,0x2324(%ebx)
f0101b57:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101b5a:	83 ec 0c             	sub    $0xc,%esp
f0101b5d:	6a 00                	push   $0x0
f0101b5f:	e8 4c f5 ff ff       	call   f01010b0 <page_alloc>
f0101b64:	83 c4 10             	add    $0x10,%esp
f0101b67:	85 c0                	test   %eax,%eax
f0101b69:	0f 85 97 08 00 00    	jne    f0102406 <mem_init+0xf58>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101b6f:	83 ec 04             	sub    $0x4,%esp
f0101b72:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101b75:	50                   	push   %eax
f0101b76:	6a 00                	push   $0x0
f0101b78:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101b7e:	ff 30                	pushl  (%eax)
f0101b80:	e8 c9 f7 ff ff       	call   f010134e <page_lookup>
f0101b85:	83 c4 10             	add    $0x10,%esp
f0101b88:	85 c0                	test   %eax,%eax
f0101b8a:	0f 85 95 08 00 00    	jne    f0102425 <mem_init+0xf77>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101b90:	6a 02                	push   $0x2
f0101b92:	6a 00                	push   $0x0
f0101b94:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101b97:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101b9d:	ff 30                	pushl  (%eax)
f0101b9f:	e8 62 f8 ff ff       	call   f0101406 <page_insert>
f0101ba4:	83 c4 10             	add    $0x10,%esp
f0101ba7:	85 c0                	test   %eax,%eax
f0101ba9:	0f 89 95 08 00 00    	jns    f0102444 <mem_init+0xf96>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101baf:	83 ec 0c             	sub    $0xc,%esp
f0101bb2:	ff 75 cc             	pushl  -0x34(%ebp)
f0101bb5:	e8 99 f5 ff ff       	call   f0101153 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101bba:	6a 02                	push   $0x2
f0101bbc:	6a 00                	push   $0x0
f0101bbe:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101bc1:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101bc7:	ff 30                	pushl  (%eax)
f0101bc9:	e8 38 f8 ff ff       	call   f0101406 <page_insert>
f0101bce:	83 c4 20             	add    $0x20,%esp
f0101bd1:	85 c0                	test   %eax,%eax
f0101bd3:	0f 85 8a 08 00 00    	jne    f0102463 <mem_init+0xfb5>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101bd9:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101bdf:	8b 30                	mov    (%eax),%esi
	return (pp - pages) << PGSHIFT;
f0101be1:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0101be7:	8b 38                	mov    (%eax),%edi
f0101be9:	8b 16                	mov    (%esi),%edx
f0101beb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101bf1:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101bf4:	29 f8                	sub    %edi,%eax
f0101bf6:	c1 f8 03             	sar    $0x3,%eax
f0101bf9:	c1 e0 0c             	shl    $0xc,%eax
f0101bfc:	39 c2                	cmp    %eax,%edx
f0101bfe:	0f 85 7e 08 00 00    	jne    f0102482 <mem_init+0xfd4>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101c04:	ba 00 00 00 00       	mov    $0x0,%edx
f0101c09:	89 f0                	mov    %esi,%eax
f0101c0b:	e8 52 ef ff ff       	call   f0100b62 <check_va2pa>
f0101c10:	89 c2                	mov    %eax,%edx
f0101c12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c15:	29 f8                	sub    %edi,%eax
f0101c17:	c1 f8 03             	sar    $0x3,%eax
f0101c1a:	c1 e0 0c             	shl    $0xc,%eax
f0101c1d:	39 c2                	cmp    %eax,%edx
f0101c1f:	0f 85 7c 08 00 00    	jne    f01024a1 <mem_init+0xff3>
	assert(pp1->pp_ref == 1);
f0101c25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c28:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101c2d:	0f 85 8d 08 00 00    	jne    f01024c0 <mem_init+0x1012>
	assert(pp0->pp_ref == 1);
f0101c33:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101c36:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101c3b:	0f 85 9e 08 00 00    	jne    f01024df <mem_init+0x1031>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101c41:	6a 02                	push   $0x2
f0101c43:	68 00 10 00 00       	push   $0x1000
f0101c48:	ff 75 d0             	pushl  -0x30(%ebp)
f0101c4b:	56                   	push   %esi
f0101c4c:	e8 b5 f7 ff ff       	call   f0101406 <page_insert>
f0101c51:	83 c4 10             	add    $0x10,%esp
f0101c54:	85 c0                	test   %eax,%eax
f0101c56:	0f 85 a2 08 00 00    	jne    f01024fe <mem_init+0x1050>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101c5c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c61:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101c67:	8b 00                	mov    (%eax),%eax
f0101c69:	e8 f4 ee ff ff       	call   f0100b62 <check_va2pa>
f0101c6e:	89 c2                	mov    %eax,%edx
f0101c70:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0101c76:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101c79:	2b 08                	sub    (%eax),%ecx
f0101c7b:	89 c8                	mov    %ecx,%eax
f0101c7d:	c1 f8 03             	sar    $0x3,%eax
f0101c80:	c1 e0 0c             	shl    $0xc,%eax
f0101c83:	39 c2                	cmp    %eax,%edx
f0101c85:	0f 85 92 08 00 00    	jne    f010251d <mem_init+0x106f>
	assert(pp2->pp_ref == 1);
f0101c8b:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101c8e:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101c93:	0f 85 a3 08 00 00    	jne    f010253c <mem_init+0x108e>

	// should be no free memory
	assert(!page_alloc(0));
f0101c99:	83 ec 0c             	sub    $0xc,%esp
f0101c9c:	6a 00                	push   $0x0
f0101c9e:	e8 0d f4 ff ff       	call   f01010b0 <page_alloc>
f0101ca3:	83 c4 10             	add    $0x10,%esp
f0101ca6:	85 c0                	test   %eax,%eax
f0101ca8:	0f 85 ad 08 00 00    	jne    f010255b <mem_init+0x10ad>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101cae:	6a 02                	push   $0x2
f0101cb0:	68 00 10 00 00       	push   $0x1000
f0101cb5:	ff 75 d0             	pushl  -0x30(%ebp)
f0101cb8:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101cbe:	ff 30                	pushl  (%eax)
f0101cc0:	e8 41 f7 ff ff       	call   f0101406 <page_insert>
f0101cc5:	83 c4 10             	add    $0x10,%esp
f0101cc8:	85 c0                	test   %eax,%eax
f0101cca:	0f 85 aa 08 00 00    	jne    f010257a <mem_init+0x10cc>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101cd0:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101cd5:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101cdb:	8b 00                	mov    (%eax),%eax
f0101cdd:	e8 80 ee ff ff       	call   f0100b62 <check_va2pa>
f0101ce2:	89 c2                	mov    %eax,%edx
f0101ce4:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0101cea:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101ced:	2b 08                	sub    (%eax),%ecx
f0101cef:	89 c8                	mov    %ecx,%eax
f0101cf1:	c1 f8 03             	sar    $0x3,%eax
f0101cf4:	c1 e0 0c             	shl    $0xc,%eax
f0101cf7:	39 c2                	cmp    %eax,%edx
f0101cf9:	0f 85 9a 08 00 00    	jne    f0102599 <mem_init+0x10eb>
	assert(pp2->pp_ref == 1);
f0101cff:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101d02:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101d07:	0f 85 ab 08 00 00    	jne    f01025b8 <mem_init+0x110a>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101d0d:	83 ec 0c             	sub    $0xc,%esp
f0101d10:	6a 00                	push   $0x0
f0101d12:	e8 99 f3 ff ff       	call   f01010b0 <page_alloc>
f0101d17:	83 c4 10             	add    $0x10,%esp
f0101d1a:	85 c0                	test   %eax,%eax
f0101d1c:	0f 85 b5 08 00 00    	jne    f01025d7 <mem_init+0x1129>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101d22:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101d28:	8b 08                	mov    (%eax),%ecx
f0101d2a:	8b 01                	mov    (%ecx),%eax
f0101d2c:	89 c2                	mov    %eax,%edx
f0101d2e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101d34:	c1 e8 0c             	shr    $0xc,%eax
f0101d37:	c7 c6 04 00 19 f0    	mov    $0xf0190004,%esi
f0101d3d:	3b 06                	cmp    (%esi),%eax
f0101d3f:	0f 83 b1 08 00 00    	jae    f01025f6 <mem_init+0x1148>
	return (void *)(pa + KERNBASE);
f0101d45:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101d4b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101d4e:	83 ec 04             	sub    $0x4,%esp
f0101d51:	6a 00                	push   $0x0
f0101d53:	68 00 10 00 00       	push   $0x1000
f0101d58:	51                   	push   %ecx
f0101d59:	e8 90 f4 ff ff       	call   f01011ee <pgdir_walk>
f0101d5e:	89 c2                	mov    %eax,%edx
f0101d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101d63:	83 c0 04             	add    $0x4,%eax
f0101d66:	83 c4 10             	add    $0x10,%esp
f0101d69:	39 d0                	cmp    %edx,%eax
f0101d6b:	0f 85 9e 08 00 00    	jne    f010260f <mem_init+0x1161>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101d71:	6a 06                	push   $0x6
f0101d73:	68 00 10 00 00       	push   $0x1000
f0101d78:	ff 75 d0             	pushl  -0x30(%ebp)
f0101d7b:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101d81:	ff 30                	pushl  (%eax)
f0101d83:	e8 7e f6 ff ff       	call   f0101406 <page_insert>
f0101d88:	83 c4 10             	add    $0x10,%esp
f0101d8b:	85 c0                	test   %eax,%eax
f0101d8d:	0f 85 9b 08 00 00    	jne    f010262e <mem_init+0x1180>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101d93:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101d99:	8b 30                	mov    (%eax),%esi
f0101d9b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101da0:	89 f0                	mov    %esi,%eax
f0101da2:	e8 bb ed ff ff       	call   f0100b62 <check_va2pa>
f0101da7:	89 c2                	mov    %eax,%edx
	return (pp - pages) << PGSHIFT;
f0101da9:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0101daf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101db2:	2b 08                	sub    (%eax),%ecx
f0101db4:	89 c8                	mov    %ecx,%eax
f0101db6:	c1 f8 03             	sar    $0x3,%eax
f0101db9:	c1 e0 0c             	shl    $0xc,%eax
f0101dbc:	39 c2                	cmp    %eax,%edx
f0101dbe:	0f 85 89 08 00 00    	jne    f010264d <mem_init+0x119f>
	assert(pp2->pp_ref == 1);
f0101dc4:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101dc7:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101dcc:	0f 85 9a 08 00 00    	jne    f010266c <mem_init+0x11be>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101dd2:	83 ec 04             	sub    $0x4,%esp
f0101dd5:	6a 00                	push   $0x0
f0101dd7:	68 00 10 00 00       	push   $0x1000
f0101ddc:	56                   	push   %esi
f0101ddd:	e8 0c f4 ff ff       	call   f01011ee <pgdir_walk>
f0101de2:	83 c4 10             	add    $0x10,%esp
f0101de5:	f6 00 04             	testb  $0x4,(%eax)
f0101de8:	0f 84 9d 08 00 00    	je     f010268b <mem_init+0x11dd>
	assert(kern_pgdir[0] & PTE_U);
f0101dee:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101df4:	8b 00                	mov    (%eax),%eax
f0101df6:	f6 00 04             	testb  $0x4,(%eax)
f0101df9:	0f 84 ab 08 00 00    	je     f01026aa <mem_init+0x11fc>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101dff:	6a 02                	push   $0x2
f0101e01:	68 00 10 00 00       	push   $0x1000
f0101e06:	ff 75 d0             	pushl  -0x30(%ebp)
f0101e09:	50                   	push   %eax
f0101e0a:	e8 f7 f5 ff ff       	call   f0101406 <page_insert>
f0101e0f:	83 c4 10             	add    $0x10,%esp
f0101e12:	85 c0                	test   %eax,%eax
f0101e14:	0f 85 af 08 00 00    	jne    f01026c9 <mem_init+0x121b>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101e1a:	83 ec 04             	sub    $0x4,%esp
f0101e1d:	6a 00                	push   $0x0
f0101e1f:	68 00 10 00 00       	push   $0x1000
f0101e24:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101e2a:	ff 30                	pushl  (%eax)
f0101e2c:	e8 bd f3 ff ff       	call   f01011ee <pgdir_walk>
f0101e31:	83 c4 10             	add    $0x10,%esp
f0101e34:	f6 00 02             	testb  $0x2,(%eax)
f0101e37:	0f 84 ab 08 00 00    	je     f01026e8 <mem_init+0x123a>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101e3d:	83 ec 04             	sub    $0x4,%esp
f0101e40:	6a 00                	push   $0x0
f0101e42:	68 00 10 00 00       	push   $0x1000
f0101e47:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101e4d:	ff 30                	pushl  (%eax)
f0101e4f:	e8 9a f3 ff ff       	call   f01011ee <pgdir_walk>
f0101e54:	83 c4 10             	add    $0x10,%esp
f0101e57:	f6 00 04             	testb  $0x4,(%eax)
f0101e5a:	0f 85 a7 08 00 00    	jne    f0102707 <mem_init+0x1259>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101e60:	6a 02                	push   $0x2
f0101e62:	68 00 00 40 00       	push   $0x400000
f0101e67:	ff 75 cc             	pushl  -0x34(%ebp)
f0101e6a:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101e70:	ff 30                	pushl  (%eax)
f0101e72:	e8 8f f5 ff ff       	call   f0101406 <page_insert>
f0101e77:	83 c4 10             	add    $0x10,%esp
f0101e7a:	85 c0                	test   %eax,%eax
f0101e7c:	0f 89 a4 08 00 00    	jns    f0102726 <mem_init+0x1278>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101e82:	6a 02                	push   $0x2
f0101e84:	68 00 10 00 00       	push   $0x1000
f0101e89:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101e8c:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101e92:	ff 30                	pushl  (%eax)
f0101e94:	e8 6d f5 ff ff       	call   f0101406 <page_insert>
f0101e99:	83 c4 10             	add    $0x10,%esp
f0101e9c:	85 c0                	test   %eax,%eax
f0101e9e:	0f 85 a1 08 00 00    	jne    f0102745 <mem_init+0x1297>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101ea4:	83 ec 04             	sub    $0x4,%esp
f0101ea7:	6a 00                	push   $0x0
f0101ea9:	68 00 10 00 00       	push   $0x1000
f0101eae:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101eb4:	ff 30                	pushl  (%eax)
f0101eb6:	e8 33 f3 ff ff       	call   f01011ee <pgdir_walk>
f0101ebb:	83 c4 10             	add    $0x10,%esp
f0101ebe:	f6 00 04             	testb  $0x4,(%eax)
f0101ec1:	0f 85 9d 08 00 00    	jne    f0102764 <mem_init+0x12b6>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101ec7:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0101ecd:	8b 38                	mov    (%eax),%edi
f0101ecf:	ba 00 00 00 00       	mov    $0x0,%edx
f0101ed4:	89 f8                	mov    %edi,%eax
f0101ed6:	e8 87 ec ff ff       	call   f0100b62 <check_va2pa>
f0101edb:	c7 c2 0c 00 19 f0    	mov    $0xf019000c,%edx
f0101ee1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0101ee4:	2b 32                	sub    (%edx),%esi
f0101ee6:	c1 fe 03             	sar    $0x3,%esi
f0101ee9:	c1 e6 0c             	shl    $0xc,%esi
f0101eec:	39 f0                	cmp    %esi,%eax
f0101eee:	0f 85 8f 08 00 00    	jne    f0102783 <mem_init+0x12d5>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101ef4:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101ef9:	89 f8                	mov    %edi,%eax
f0101efb:	e8 62 ec ff ff       	call   f0100b62 <check_va2pa>
f0101f00:	39 c6                	cmp    %eax,%esi
f0101f02:	0f 85 9a 08 00 00    	jne    f01027a2 <mem_init+0x12f4>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101f08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f0b:	66 83 78 04 02       	cmpw   $0x2,0x4(%eax)
f0101f10:	0f 85 ab 08 00 00    	jne    f01027c1 <mem_init+0x1313>
	assert(pp2->pp_ref == 0);
f0101f16:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101f19:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101f1e:	0f 85 bc 08 00 00    	jne    f01027e0 <mem_init+0x1332>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101f24:	83 ec 0c             	sub    $0xc,%esp
f0101f27:	6a 00                	push   $0x0
f0101f29:	e8 82 f1 ff ff       	call   f01010b0 <page_alloc>
f0101f2e:	83 c4 10             	add    $0x10,%esp
f0101f31:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101f34:	0f 85 c5 08 00 00    	jne    f01027ff <mem_init+0x1351>
f0101f3a:	85 c0                	test   %eax,%eax
f0101f3c:	0f 84 bd 08 00 00    	je     f01027ff <mem_init+0x1351>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101f42:	83 ec 08             	sub    $0x8,%esp
f0101f45:	6a 00                	push   $0x0
f0101f47:	c7 c6 08 00 19 f0    	mov    $0xf0190008,%esi
f0101f4d:	ff 36                	pushl  (%esi)
f0101f4f:	e8 73 f4 ff ff       	call   f01013c7 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101f54:	8b 36                	mov    (%esi),%esi
f0101f56:	ba 00 00 00 00       	mov    $0x0,%edx
f0101f5b:	89 f0                	mov    %esi,%eax
f0101f5d:	e8 00 ec ff ff       	call   f0100b62 <check_va2pa>
f0101f62:	83 c4 10             	add    $0x10,%esp
f0101f65:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101f68:	0f 85 b0 08 00 00    	jne    f010281e <mem_init+0x1370>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101f6e:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f73:	89 f0                	mov    %esi,%eax
f0101f75:	e8 e8 eb ff ff       	call   f0100b62 <check_va2pa>
f0101f7a:	89 c2                	mov    %eax,%edx
f0101f7c:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0101f82:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101f85:	2b 08                	sub    (%eax),%ecx
f0101f87:	89 c8                	mov    %ecx,%eax
f0101f89:	c1 f8 03             	sar    $0x3,%eax
f0101f8c:	c1 e0 0c             	shl    $0xc,%eax
f0101f8f:	39 c2                	cmp    %eax,%edx
f0101f91:	0f 85 a6 08 00 00    	jne    f010283d <mem_init+0x138f>
	assert(pp1->pp_ref == 1);
f0101f97:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f9a:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101f9f:	0f 85 b7 08 00 00    	jne    f010285c <mem_init+0x13ae>
	assert(pp2->pp_ref == 0);
f0101fa5:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101fa8:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101fad:	0f 85 c8 08 00 00    	jne    f010287b <mem_init+0x13cd>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101fb3:	6a 00                	push   $0x0
f0101fb5:	68 00 10 00 00       	push   $0x1000
f0101fba:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101fbd:	56                   	push   %esi
f0101fbe:	e8 43 f4 ff ff       	call   f0101406 <page_insert>
f0101fc3:	83 c4 10             	add    $0x10,%esp
f0101fc6:	85 c0                	test   %eax,%eax
f0101fc8:	0f 85 cc 08 00 00    	jne    f010289a <mem_init+0x13ec>
	assert(pp1->pp_ref);
f0101fce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fd1:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101fd6:	0f 84 dd 08 00 00    	je     f01028b9 <mem_init+0x140b>
	assert(pp1->pp_link == NULL);
f0101fdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fdf:	83 38 00             	cmpl   $0x0,(%eax)
f0101fe2:	0f 85 f0 08 00 00    	jne    f01028d8 <mem_init+0x142a>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101fe8:	83 ec 08             	sub    $0x8,%esp
f0101feb:	68 00 10 00 00       	push   $0x1000
f0101ff0:	c7 c6 08 00 19 f0    	mov    $0xf0190008,%esi
f0101ff6:	ff 36                	pushl  (%esi)
f0101ff8:	e8 ca f3 ff ff       	call   f01013c7 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101ffd:	8b 36                	mov    (%esi),%esi
f0101fff:	ba 00 00 00 00       	mov    $0x0,%edx
f0102004:	89 f0                	mov    %esi,%eax
f0102006:	e8 57 eb ff ff       	call   f0100b62 <check_va2pa>
f010200b:	83 c4 10             	add    $0x10,%esp
f010200e:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102011:	0f 85 e0 08 00 00    	jne    f01028f7 <mem_init+0x1449>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102017:	ba 00 10 00 00       	mov    $0x1000,%edx
f010201c:	89 f0                	mov    %esi,%eax
f010201e:	e8 3f eb ff ff       	call   f0100b62 <check_va2pa>
f0102023:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102026:	0f 85 ea 08 00 00    	jne    f0102916 <mem_init+0x1468>
	assert(pp1->pp_ref == 0);
f010202c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010202f:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0102034:	0f 85 fb 08 00 00    	jne    f0102935 <mem_init+0x1487>
	assert(pp2->pp_ref == 0);
f010203a:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010203d:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0102042:	0f 85 0c 09 00 00    	jne    f0102954 <mem_init+0x14a6>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0102048:	83 ec 0c             	sub    $0xc,%esp
f010204b:	6a 00                	push   $0x0
f010204d:	e8 5e f0 ff ff       	call   f01010b0 <page_alloc>
f0102052:	83 c4 10             	add    $0x10,%esp
f0102055:	85 c0                	test   %eax,%eax
f0102057:	0f 84 16 09 00 00    	je     f0102973 <mem_init+0x14c5>
f010205d:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0102060:	0f 85 0d 09 00 00    	jne    f0102973 <mem_init+0x14c5>

	// should be no free memory
	assert(!page_alloc(0));
f0102066:	83 ec 0c             	sub    $0xc,%esp
f0102069:	6a 00                	push   $0x0
f010206b:	e8 40 f0 ff ff       	call   f01010b0 <page_alloc>
f0102070:	83 c4 10             	add    $0x10,%esp
f0102073:	85 c0                	test   %eax,%eax
f0102075:	0f 85 17 09 00 00    	jne    f0102992 <mem_init+0x14e4>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010207b:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0102081:	8b 08                	mov    (%eax),%ecx
f0102083:	8b 11                	mov    (%ecx),%edx
f0102085:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010208b:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0102091:	8b 7d cc             	mov    -0x34(%ebp),%edi
f0102094:	2b 38                	sub    (%eax),%edi
f0102096:	89 f8                	mov    %edi,%eax
f0102098:	c1 f8 03             	sar    $0x3,%eax
f010209b:	c1 e0 0c             	shl    $0xc,%eax
f010209e:	39 c2                	cmp    %eax,%edx
f01020a0:	0f 85 0b 09 00 00    	jne    f01029b1 <mem_init+0x1503>
	kern_pgdir[0] = 0;
f01020a6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f01020ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01020af:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f01020b4:	0f 85 16 09 00 00    	jne    f01029d0 <mem_init+0x1522>
	pp0->pp_ref = 0;
f01020ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01020bd:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f01020c3:	83 ec 0c             	sub    $0xc,%esp
f01020c6:	50                   	push   %eax
f01020c7:	e8 87 f0 ff ff       	call   f0101153 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f01020cc:	83 c4 0c             	add    $0xc,%esp
f01020cf:	6a 01                	push   $0x1
f01020d1:	68 00 10 40 00       	push   $0x401000
f01020d6:	c7 c6 08 00 19 f0    	mov    $0xf0190008,%esi
f01020dc:	ff 36                	pushl  (%esi)
f01020de:	e8 0b f1 ff ff       	call   f01011ee <pgdir_walk>
f01020e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f01020e6:	8b 3e                	mov    (%esi),%edi
f01020e8:	8b 57 04             	mov    0x4(%edi),%edx
f01020eb:	89 d1                	mov    %edx,%ecx
f01020ed:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
	if (PGNUM(pa) >= npages)
f01020f3:	c7 c6 04 00 19 f0    	mov    $0xf0190004,%esi
f01020f9:	8b 36                	mov    (%esi),%esi
f01020fb:	c1 ea 0c             	shr    $0xc,%edx
f01020fe:	83 c4 10             	add    $0x10,%esp
f0102101:	39 f2                	cmp    %esi,%edx
f0102103:	0f 83 e6 08 00 00    	jae    f01029ef <mem_init+0x1541>
	assert(ptep == ptep1 + PTX(va));
f0102109:	81 e9 fc ff ff 0f    	sub    $0xffffffc,%ecx
f010210f:	39 c8                	cmp    %ecx,%eax
f0102111:	0f 85 f1 08 00 00    	jne    f0102a08 <mem_init+0x155a>
	kern_pgdir[PDX(va)] = 0;
f0102117:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
	pp0->pp_ref = 0;
f010211e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102121:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
	return (pp - pages) << PGSHIFT;
f0102127:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f010212d:	2b 08                	sub    (%eax),%ecx
f010212f:	89 c8                	mov    %ecx,%eax
f0102131:	c1 f8 03             	sar    $0x3,%eax
f0102134:	89 c2                	mov    %eax,%edx
f0102136:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102139:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010213e:	39 c6                	cmp    %eax,%esi
f0102140:	0f 86 e1 08 00 00    	jbe    f0102a27 <mem_init+0x1579>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102146:	83 ec 04             	sub    $0x4,%esp
f0102149:	68 00 10 00 00       	push   $0x1000
f010214e:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0102153:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102159:	52                   	push   %edx
f010215a:	e8 29 30 00 00       	call   f0105188 <memset>
	page_free(pp0);
f010215f:	8b 7d cc             	mov    -0x34(%ebp),%edi
f0102162:	89 3c 24             	mov    %edi,(%esp)
f0102165:	e8 e9 ef ff ff       	call   f0101153 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f010216a:	83 c4 0c             	add    $0xc,%esp
f010216d:	6a 01                	push   $0x1
f010216f:	6a 00                	push   $0x0
f0102171:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0102177:	ff 30                	pushl  (%eax)
f0102179:	e8 70 f0 ff ff       	call   f01011ee <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f010217e:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0102184:	2b 38                	sub    (%eax),%edi
f0102186:	89 f8                	mov    %edi,%eax
f0102188:	c1 f8 03             	sar    $0x3,%eax
f010218b:	89 c2                	mov    %eax,%edx
f010218d:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102190:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102195:	83 c4 10             	add    $0x10,%esp
f0102198:	c7 c1 04 00 19 f0    	mov    $0xf0190004,%ecx
f010219e:	3b 01                	cmp    (%ecx),%eax
f01021a0:	0f 83 97 08 00 00    	jae    f0102a3d <mem_init+0x158f>
	return (void *)(pa + KERNBASE);
f01021a6:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f01021ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01021af:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f01021b5:	8b 38                	mov    (%eax),%edi
f01021b7:	83 e7 01             	and    $0x1,%edi
f01021ba:	0f 85 93 08 00 00    	jne    f0102a53 <mem_init+0x15a5>
f01021c0:	83 c0 04             	add    $0x4,%eax
	for(i=0; i<NPTENTRIES; i++)
f01021c3:	39 d0                	cmp    %edx,%eax
f01021c5:	75 ee                	jne    f01021b5 <mem_init+0xd07>
	kern_pgdir[0] = 0;
f01021c7:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f01021cd:	8b 00                	mov    (%eax),%eax
f01021cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f01021d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01021d8:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f01021de:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01021e1:	89 8b 24 23 00 00    	mov    %ecx,0x2324(%ebx)

	// free the pages we took
	page_free(pp0);
f01021e7:	83 ec 0c             	sub    $0xc,%esp
f01021ea:	50                   	push   %eax
f01021eb:	e8 63 ef ff ff       	call   f0101153 <page_free>
	page_free(pp1);
f01021f0:	83 c4 04             	add    $0x4,%esp
f01021f3:	ff 75 d4             	pushl  -0x2c(%ebp)
f01021f6:	e8 58 ef ff ff       	call   f0101153 <page_free>
	page_free(pp2);
f01021fb:	83 c4 04             	add    $0x4,%esp
f01021fe:	ff 75 d0             	pushl  -0x30(%ebp)
f0102201:	e8 4d ef ff ff       	call   f0101153 <page_free>

	cprintf("check_page() succeeded!\n");
f0102206:	8d 83 61 8d f7 ff    	lea    -0x8729f(%ebx),%eax
f010220c:	89 04 24             	mov    %eax,(%esp)
f010220f:	e8 b0 18 00 00       	call   f0103ac4 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f0102214:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f010221a:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f010221c:	83 c4 10             	add    $0x10,%esp
f010221f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102224:	0f 86 48 08 00 00    	jbe    f0102a72 <mem_init+0x15c4>
f010222a:	83 ec 08             	sub    $0x8,%esp
f010222d:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f010222f:	05 00 00 00 10       	add    $0x10000000,%eax
f0102234:	50                   	push   %eax
f0102235:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010223a:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f010223f:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0102245:	8b 00                	mov    (%eax),%eax
f0102247:	e8 ab f0 ff ff       	call   f01012f7 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f010224c:	c7 c0 4c f3 18 f0    	mov    $0xf018f34c,%eax
f0102252:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0102254:	83 c4 10             	add    $0x10,%esp
f0102257:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010225c:	0f 86 29 08 00 00    	jbe    f0102a8b <mem_init+0x15dd>
f0102262:	83 ec 08             	sub    $0x8,%esp
f0102265:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102267:	05 00 00 00 10       	add    $0x10000000,%eax
f010226c:	50                   	push   %eax
f010226d:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102272:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102277:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f010227d:	8b 00                	mov    (%eax),%eax
f010227f:	e8 73 f0 ff ff       	call   f01012f7 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102284:	c7 c0 00 30 11 f0    	mov    $0xf0113000,%eax
f010228a:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010228d:	83 c4 10             	add    $0x10,%esp
f0102290:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102295:	0f 86 09 08 00 00    	jbe    f0102aa4 <mem_init+0x15f6>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f010229b:	c7 c6 08 00 19 f0    	mov    $0xf0190008,%esi
f01022a1:	83 ec 08             	sub    $0x8,%esp
f01022a4:	6a 02                	push   $0x2
	return (physaddr_t)kva - KERNBASE;
f01022a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01022a9:	05 00 00 00 10       	add    $0x10000000,%eax
f01022ae:	50                   	push   %eax
f01022af:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01022b4:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01022b9:	8b 06                	mov    (%esi),%eax
f01022bb:	e8 37 f0 ff ff       	call   f01012f7 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0xffffffff - KERNBASE, 0, PTE_W);
f01022c0:	83 c4 08             	add    $0x8,%esp
f01022c3:	6a 02                	push   $0x2
f01022c5:	6a 00                	push   $0x0
f01022c7:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f01022cc:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01022d1:	8b 06                	mov    (%esi),%eax
f01022d3:	e8 1f f0 ff ff       	call   f01012f7 <boot_map_region>
	pgdir = kern_pgdir;
f01022d8:	8b 06                	mov    (%esi),%eax
f01022da:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01022dd:	c7 c0 04 00 19 f0    	mov    $0xf0190004,%eax
f01022e3:	8b 00                	mov    (%eax),%eax
f01022e5:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01022e8:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01022ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01022f4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01022f7:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f01022fd:	8b 00                	mov    (%eax),%eax
f01022ff:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102302:	89 45 c8             	mov    %eax,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f0102305:	05 00 00 00 10       	add    $0x10000000,%eax
f010230a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f010230d:	83 c4 10             	add    $0x10,%esp
f0102310:	89 fe                	mov    %edi,%esi
f0102312:	39 75 cc             	cmp    %esi,-0x34(%ebp)
f0102315:	0f 86 dc 07 00 00    	jbe    f0102af7 <mem_init+0x1649>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010231b:	8d 96 00 00 00 ef    	lea    -0x11000000(%esi),%edx
f0102321:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102324:	e8 39 e8 ff ff       	call   f0100b62 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102329:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f0102330:	0f 86 87 07 00 00    	jbe    f0102abd <mem_init+0x160f>
f0102336:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0102339:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010233c:	39 d0                	cmp    %edx,%eax
f010233e:	0f 85 94 07 00 00    	jne    f0102ad8 <mem_init+0x162a>
	for (i = 0; i < n; i += PGSIZE)
f0102344:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010234a:	eb c6                	jmp    f0102312 <mem_init+0xe64>
	assert(nfree == 0);
f010234c:	8d 83 8a 8c f7 ff    	lea    -0x87376(%ebx),%eax
f0102352:	50                   	push   %eax
f0102353:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102359:	50                   	push   %eax
f010235a:	68 3e 03 00 00       	push   $0x33e
f010235f:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102365:	50                   	push   %eax
f0102366:	e8 4a dd ff ff       	call   f01000b5 <_panic>
	assert((pp0 = page_alloc(0)));
f010236b:	8d 83 98 8b f7 ff    	lea    -0x87468(%ebx),%eax
f0102371:	50                   	push   %eax
f0102372:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102378:	50                   	push   %eax
f0102379:	68 9c 03 00 00       	push   $0x39c
f010237e:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102384:	50                   	push   %eax
f0102385:	e8 2b dd ff ff       	call   f01000b5 <_panic>
	assert((pp1 = page_alloc(0)));
f010238a:	8d 83 ae 8b f7 ff    	lea    -0x87452(%ebx),%eax
f0102390:	50                   	push   %eax
f0102391:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102397:	50                   	push   %eax
f0102398:	68 9d 03 00 00       	push   $0x39d
f010239d:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01023a3:	50                   	push   %eax
f01023a4:	e8 0c dd ff ff       	call   f01000b5 <_panic>
	assert((pp2 = page_alloc(0)));
f01023a9:	8d 83 c4 8b f7 ff    	lea    -0x8743c(%ebx),%eax
f01023af:	50                   	push   %eax
f01023b0:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01023b6:	50                   	push   %eax
f01023b7:	68 9e 03 00 00       	push   $0x39e
f01023bc:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01023c2:	50                   	push   %eax
f01023c3:	e8 ed dc ff ff       	call   f01000b5 <_panic>
	assert(pp1 && pp1 != pp0);
f01023c8:	8d 83 da 8b f7 ff    	lea    -0x87426(%ebx),%eax
f01023ce:	50                   	push   %eax
f01023cf:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01023d5:	50                   	push   %eax
f01023d6:	68 a1 03 00 00       	push   $0x3a1
f01023db:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01023e1:	50                   	push   %eax
f01023e2:	e8 ce dc ff ff       	call   f01000b5 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01023e7:	8d 83 9c 8f f7 ff    	lea    -0x87064(%ebx),%eax
f01023ed:	50                   	push   %eax
f01023ee:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01023f4:	50                   	push   %eax
f01023f5:	68 a2 03 00 00       	push   $0x3a2
f01023fa:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102400:	50                   	push   %eax
f0102401:	e8 af dc ff ff       	call   f01000b5 <_panic>
	assert(!page_alloc(0));
f0102406:	8d 83 43 8c f7 ff    	lea    -0x873bd(%ebx),%eax
f010240c:	50                   	push   %eax
f010240d:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102413:	50                   	push   %eax
f0102414:	68 a9 03 00 00       	push   $0x3a9
f0102419:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010241f:	50                   	push   %eax
f0102420:	e8 90 dc ff ff       	call   f01000b5 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102425:	8d 83 dc 8f f7 ff    	lea    -0x87024(%ebx),%eax
f010242b:	50                   	push   %eax
f010242c:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102432:	50                   	push   %eax
f0102433:	68 ac 03 00 00       	push   $0x3ac
f0102438:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010243e:	50                   	push   %eax
f010243f:	e8 71 dc ff ff       	call   f01000b5 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102444:	8d 83 14 90 f7 ff    	lea    -0x86fec(%ebx),%eax
f010244a:	50                   	push   %eax
f010244b:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102451:	50                   	push   %eax
f0102452:	68 af 03 00 00       	push   $0x3af
f0102457:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010245d:	50                   	push   %eax
f010245e:	e8 52 dc ff ff       	call   f01000b5 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102463:	8d 83 44 90 f7 ff    	lea    -0x86fbc(%ebx),%eax
f0102469:	50                   	push   %eax
f010246a:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102470:	50                   	push   %eax
f0102471:	68 b3 03 00 00       	push   $0x3b3
f0102476:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010247c:	50                   	push   %eax
f010247d:	e8 33 dc ff ff       	call   f01000b5 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102482:	8d 83 74 90 f7 ff    	lea    -0x86f8c(%ebx),%eax
f0102488:	50                   	push   %eax
f0102489:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010248f:	50                   	push   %eax
f0102490:	68 b4 03 00 00       	push   $0x3b4
f0102495:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010249b:	50                   	push   %eax
f010249c:	e8 14 dc ff ff       	call   f01000b5 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01024a1:	8d 83 9c 90 f7 ff    	lea    -0x86f64(%ebx),%eax
f01024a7:	50                   	push   %eax
f01024a8:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01024ae:	50                   	push   %eax
f01024af:	68 b5 03 00 00       	push   $0x3b5
f01024b4:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01024ba:	50                   	push   %eax
f01024bb:	e8 f5 db ff ff       	call   f01000b5 <_panic>
	assert(pp1->pp_ref == 1);
f01024c0:	8d 83 95 8c f7 ff    	lea    -0x8736b(%ebx),%eax
f01024c6:	50                   	push   %eax
f01024c7:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01024cd:	50                   	push   %eax
f01024ce:	68 b6 03 00 00       	push   $0x3b6
f01024d3:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01024d9:	50                   	push   %eax
f01024da:	e8 d6 db ff ff       	call   f01000b5 <_panic>
	assert(pp0->pp_ref == 1);
f01024df:	8d 83 a6 8c f7 ff    	lea    -0x8735a(%ebx),%eax
f01024e5:	50                   	push   %eax
f01024e6:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01024ec:	50                   	push   %eax
f01024ed:	68 b7 03 00 00       	push   $0x3b7
f01024f2:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01024f8:	50                   	push   %eax
f01024f9:	e8 b7 db ff ff       	call   f01000b5 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01024fe:	8d 83 cc 90 f7 ff    	lea    -0x86f34(%ebx),%eax
f0102504:	50                   	push   %eax
f0102505:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010250b:	50                   	push   %eax
f010250c:	68 ba 03 00 00       	push   $0x3ba
f0102511:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102517:	50                   	push   %eax
f0102518:	e8 98 db ff ff       	call   f01000b5 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010251d:	8d 83 08 91 f7 ff    	lea    -0x86ef8(%ebx),%eax
f0102523:	50                   	push   %eax
f0102524:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010252a:	50                   	push   %eax
f010252b:	68 bb 03 00 00       	push   $0x3bb
f0102530:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102536:	50                   	push   %eax
f0102537:	e8 79 db ff ff       	call   f01000b5 <_panic>
	assert(pp2->pp_ref == 1);
f010253c:	8d 83 b7 8c f7 ff    	lea    -0x87349(%ebx),%eax
f0102542:	50                   	push   %eax
f0102543:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102549:	50                   	push   %eax
f010254a:	68 bc 03 00 00       	push   $0x3bc
f010254f:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102555:	50                   	push   %eax
f0102556:	e8 5a db ff ff       	call   f01000b5 <_panic>
	assert(!page_alloc(0));
f010255b:	8d 83 43 8c f7 ff    	lea    -0x873bd(%ebx),%eax
f0102561:	50                   	push   %eax
f0102562:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102568:	50                   	push   %eax
f0102569:	68 bf 03 00 00       	push   $0x3bf
f010256e:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102574:	50                   	push   %eax
f0102575:	e8 3b db ff ff       	call   f01000b5 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010257a:	8d 83 cc 90 f7 ff    	lea    -0x86f34(%ebx),%eax
f0102580:	50                   	push   %eax
f0102581:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102587:	50                   	push   %eax
f0102588:	68 c2 03 00 00       	push   $0x3c2
f010258d:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102593:	50                   	push   %eax
f0102594:	e8 1c db ff ff       	call   f01000b5 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102599:	8d 83 08 91 f7 ff    	lea    -0x86ef8(%ebx),%eax
f010259f:	50                   	push   %eax
f01025a0:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01025a6:	50                   	push   %eax
f01025a7:	68 c3 03 00 00       	push   $0x3c3
f01025ac:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01025b2:	50                   	push   %eax
f01025b3:	e8 fd da ff ff       	call   f01000b5 <_panic>
	assert(pp2->pp_ref == 1);
f01025b8:	8d 83 b7 8c f7 ff    	lea    -0x87349(%ebx),%eax
f01025be:	50                   	push   %eax
f01025bf:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01025c5:	50                   	push   %eax
f01025c6:	68 c4 03 00 00       	push   $0x3c4
f01025cb:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01025d1:	50                   	push   %eax
f01025d2:	e8 de da ff ff       	call   f01000b5 <_panic>
	assert(!page_alloc(0));
f01025d7:	8d 83 43 8c f7 ff    	lea    -0x873bd(%ebx),%eax
f01025dd:	50                   	push   %eax
f01025de:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01025e4:	50                   	push   %eax
f01025e5:	68 c8 03 00 00       	push   $0x3c8
f01025ea:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01025f0:	50                   	push   %eax
f01025f1:	e8 bf da ff ff       	call   f01000b5 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01025f6:	52                   	push   %edx
f01025f7:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f01025fd:	50                   	push   %eax
f01025fe:	68 cb 03 00 00       	push   $0x3cb
f0102603:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102609:	50                   	push   %eax
f010260a:	e8 a6 da ff ff       	call   f01000b5 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f010260f:	8d 83 38 91 f7 ff    	lea    -0x86ec8(%ebx),%eax
f0102615:	50                   	push   %eax
f0102616:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010261c:	50                   	push   %eax
f010261d:	68 cc 03 00 00       	push   $0x3cc
f0102622:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102628:	50                   	push   %eax
f0102629:	e8 87 da ff ff       	call   f01000b5 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f010262e:	8d 83 78 91 f7 ff    	lea    -0x86e88(%ebx),%eax
f0102634:	50                   	push   %eax
f0102635:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010263b:	50                   	push   %eax
f010263c:	68 cf 03 00 00       	push   $0x3cf
f0102641:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102647:	50                   	push   %eax
f0102648:	e8 68 da ff ff       	call   f01000b5 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010264d:	8d 83 08 91 f7 ff    	lea    -0x86ef8(%ebx),%eax
f0102653:	50                   	push   %eax
f0102654:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010265a:	50                   	push   %eax
f010265b:	68 d0 03 00 00       	push   $0x3d0
f0102660:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102666:	50                   	push   %eax
f0102667:	e8 49 da ff ff       	call   f01000b5 <_panic>
	assert(pp2->pp_ref == 1);
f010266c:	8d 83 b7 8c f7 ff    	lea    -0x87349(%ebx),%eax
f0102672:	50                   	push   %eax
f0102673:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102679:	50                   	push   %eax
f010267a:	68 d1 03 00 00       	push   $0x3d1
f010267f:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102685:	50                   	push   %eax
f0102686:	e8 2a da ff ff       	call   f01000b5 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010268b:	8d 83 b8 91 f7 ff    	lea    -0x86e48(%ebx),%eax
f0102691:	50                   	push   %eax
f0102692:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102698:	50                   	push   %eax
f0102699:	68 d2 03 00 00       	push   $0x3d2
f010269e:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01026a4:	50                   	push   %eax
f01026a5:	e8 0b da ff ff       	call   f01000b5 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01026aa:	8d 83 c8 8c f7 ff    	lea    -0x87338(%ebx),%eax
f01026b0:	50                   	push   %eax
f01026b1:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01026b7:	50                   	push   %eax
f01026b8:	68 d3 03 00 00       	push   $0x3d3
f01026bd:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01026c3:	50                   	push   %eax
f01026c4:	e8 ec d9 ff ff       	call   f01000b5 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01026c9:	8d 83 cc 90 f7 ff    	lea    -0x86f34(%ebx),%eax
f01026cf:	50                   	push   %eax
f01026d0:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01026d6:	50                   	push   %eax
f01026d7:	68 d6 03 00 00       	push   $0x3d6
f01026dc:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01026e2:	50                   	push   %eax
f01026e3:	e8 cd d9 ff ff       	call   f01000b5 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01026e8:	8d 83 ec 91 f7 ff    	lea    -0x86e14(%ebx),%eax
f01026ee:	50                   	push   %eax
f01026ef:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01026f5:	50                   	push   %eax
f01026f6:	68 d7 03 00 00       	push   $0x3d7
f01026fb:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102701:	50                   	push   %eax
f0102702:	e8 ae d9 ff ff       	call   f01000b5 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102707:	8d 83 20 92 f7 ff    	lea    -0x86de0(%ebx),%eax
f010270d:	50                   	push   %eax
f010270e:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102714:	50                   	push   %eax
f0102715:	68 d8 03 00 00       	push   $0x3d8
f010271a:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102720:	50                   	push   %eax
f0102721:	e8 8f d9 ff ff       	call   f01000b5 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102726:	8d 83 58 92 f7 ff    	lea    -0x86da8(%ebx),%eax
f010272c:	50                   	push   %eax
f010272d:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102733:	50                   	push   %eax
f0102734:	68 db 03 00 00       	push   $0x3db
f0102739:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010273f:	50                   	push   %eax
f0102740:	e8 70 d9 ff ff       	call   f01000b5 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102745:	8d 83 90 92 f7 ff    	lea    -0x86d70(%ebx),%eax
f010274b:	50                   	push   %eax
f010274c:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102752:	50                   	push   %eax
f0102753:	68 de 03 00 00       	push   $0x3de
f0102758:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010275e:	50                   	push   %eax
f010275f:	e8 51 d9 ff ff       	call   f01000b5 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102764:	8d 83 20 92 f7 ff    	lea    -0x86de0(%ebx),%eax
f010276a:	50                   	push   %eax
f010276b:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102771:	50                   	push   %eax
f0102772:	68 df 03 00 00       	push   $0x3df
f0102777:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010277d:	50                   	push   %eax
f010277e:	e8 32 d9 ff ff       	call   f01000b5 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102783:	8d 83 cc 92 f7 ff    	lea    -0x86d34(%ebx),%eax
f0102789:	50                   	push   %eax
f010278a:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102790:	50                   	push   %eax
f0102791:	68 e2 03 00 00       	push   $0x3e2
f0102796:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010279c:	50                   	push   %eax
f010279d:	e8 13 d9 ff ff       	call   f01000b5 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01027a2:	8d 83 f8 92 f7 ff    	lea    -0x86d08(%ebx),%eax
f01027a8:	50                   	push   %eax
f01027a9:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01027af:	50                   	push   %eax
f01027b0:	68 e3 03 00 00       	push   $0x3e3
f01027b5:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01027bb:	50                   	push   %eax
f01027bc:	e8 f4 d8 ff ff       	call   f01000b5 <_panic>
	assert(pp1->pp_ref == 2);
f01027c1:	8d 83 de 8c f7 ff    	lea    -0x87322(%ebx),%eax
f01027c7:	50                   	push   %eax
f01027c8:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01027ce:	50                   	push   %eax
f01027cf:	68 e5 03 00 00       	push   $0x3e5
f01027d4:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01027da:	50                   	push   %eax
f01027db:	e8 d5 d8 ff ff       	call   f01000b5 <_panic>
	assert(pp2->pp_ref == 0);
f01027e0:	8d 83 ef 8c f7 ff    	lea    -0x87311(%ebx),%eax
f01027e6:	50                   	push   %eax
f01027e7:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01027ed:	50                   	push   %eax
f01027ee:	68 e6 03 00 00       	push   $0x3e6
f01027f3:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01027f9:	50                   	push   %eax
f01027fa:	e8 b6 d8 ff ff       	call   f01000b5 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01027ff:	8d 83 28 93 f7 ff    	lea    -0x86cd8(%ebx),%eax
f0102805:	50                   	push   %eax
f0102806:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010280c:	50                   	push   %eax
f010280d:	68 e9 03 00 00       	push   $0x3e9
f0102812:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102818:	50                   	push   %eax
f0102819:	e8 97 d8 ff ff       	call   f01000b5 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010281e:	8d 83 4c 93 f7 ff    	lea    -0x86cb4(%ebx),%eax
f0102824:	50                   	push   %eax
f0102825:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010282b:	50                   	push   %eax
f010282c:	68 ed 03 00 00       	push   $0x3ed
f0102831:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102837:	50                   	push   %eax
f0102838:	e8 78 d8 ff ff       	call   f01000b5 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010283d:	8d 83 f8 92 f7 ff    	lea    -0x86d08(%ebx),%eax
f0102843:	50                   	push   %eax
f0102844:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010284a:	50                   	push   %eax
f010284b:	68 ee 03 00 00       	push   $0x3ee
f0102850:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102856:	50                   	push   %eax
f0102857:	e8 59 d8 ff ff       	call   f01000b5 <_panic>
	assert(pp1->pp_ref == 1);
f010285c:	8d 83 95 8c f7 ff    	lea    -0x8736b(%ebx),%eax
f0102862:	50                   	push   %eax
f0102863:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102869:	50                   	push   %eax
f010286a:	68 ef 03 00 00       	push   $0x3ef
f010286f:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102875:	50                   	push   %eax
f0102876:	e8 3a d8 ff ff       	call   f01000b5 <_panic>
	assert(pp2->pp_ref == 0);
f010287b:	8d 83 ef 8c f7 ff    	lea    -0x87311(%ebx),%eax
f0102881:	50                   	push   %eax
f0102882:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102888:	50                   	push   %eax
f0102889:	68 f0 03 00 00       	push   $0x3f0
f010288e:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102894:	50                   	push   %eax
f0102895:	e8 1b d8 ff ff       	call   f01000b5 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f010289a:	8d 83 70 93 f7 ff    	lea    -0x86c90(%ebx),%eax
f01028a0:	50                   	push   %eax
f01028a1:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01028a7:	50                   	push   %eax
f01028a8:	68 f3 03 00 00       	push   $0x3f3
f01028ad:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01028b3:	50                   	push   %eax
f01028b4:	e8 fc d7 ff ff       	call   f01000b5 <_panic>
	assert(pp1->pp_ref);
f01028b9:	8d 83 00 8d f7 ff    	lea    -0x87300(%ebx),%eax
f01028bf:	50                   	push   %eax
f01028c0:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01028c6:	50                   	push   %eax
f01028c7:	68 f4 03 00 00       	push   $0x3f4
f01028cc:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01028d2:	50                   	push   %eax
f01028d3:	e8 dd d7 ff ff       	call   f01000b5 <_panic>
	assert(pp1->pp_link == NULL);
f01028d8:	8d 83 0c 8d f7 ff    	lea    -0x872f4(%ebx),%eax
f01028de:	50                   	push   %eax
f01028df:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01028e5:	50                   	push   %eax
f01028e6:	68 f5 03 00 00       	push   $0x3f5
f01028eb:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01028f1:	50                   	push   %eax
f01028f2:	e8 be d7 ff ff       	call   f01000b5 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01028f7:	8d 83 4c 93 f7 ff    	lea    -0x86cb4(%ebx),%eax
f01028fd:	50                   	push   %eax
f01028fe:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102904:	50                   	push   %eax
f0102905:	68 f9 03 00 00       	push   $0x3f9
f010290a:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102910:	50                   	push   %eax
f0102911:	e8 9f d7 ff ff       	call   f01000b5 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102916:	8d 83 a8 93 f7 ff    	lea    -0x86c58(%ebx),%eax
f010291c:	50                   	push   %eax
f010291d:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102923:	50                   	push   %eax
f0102924:	68 fa 03 00 00       	push   $0x3fa
f0102929:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010292f:	50                   	push   %eax
f0102930:	e8 80 d7 ff ff       	call   f01000b5 <_panic>
	assert(pp1->pp_ref == 0);
f0102935:	8d 83 21 8d f7 ff    	lea    -0x872df(%ebx),%eax
f010293b:	50                   	push   %eax
f010293c:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102942:	50                   	push   %eax
f0102943:	68 fb 03 00 00       	push   $0x3fb
f0102948:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010294e:	50                   	push   %eax
f010294f:	e8 61 d7 ff ff       	call   f01000b5 <_panic>
	assert(pp2->pp_ref == 0);
f0102954:	8d 83 ef 8c f7 ff    	lea    -0x87311(%ebx),%eax
f010295a:	50                   	push   %eax
f010295b:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102961:	50                   	push   %eax
f0102962:	68 fc 03 00 00       	push   $0x3fc
f0102967:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010296d:	50                   	push   %eax
f010296e:	e8 42 d7 ff ff       	call   f01000b5 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102973:	8d 83 d0 93 f7 ff    	lea    -0x86c30(%ebx),%eax
f0102979:	50                   	push   %eax
f010297a:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102980:	50                   	push   %eax
f0102981:	68 ff 03 00 00       	push   $0x3ff
f0102986:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010298c:	50                   	push   %eax
f010298d:	e8 23 d7 ff ff       	call   f01000b5 <_panic>
	assert(!page_alloc(0));
f0102992:	8d 83 43 8c f7 ff    	lea    -0x873bd(%ebx),%eax
f0102998:	50                   	push   %eax
f0102999:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010299f:	50                   	push   %eax
f01029a0:	68 02 04 00 00       	push   $0x402
f01029a5:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01029ab:	50                   	push   %eax
f01029ac:	e8 04 d7 ff ff       	call   f01000b5 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01029b1:	8d 83 74 90 f7 ff    	lea    -0x86f8c(%ebx),%eax
f01029b7:	50                   	push   %eax
f01029b8:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01029be:	50                   	push   %eax
f01029bf:	68 05 04 00 00       	push   $0x405
f01029c4:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01029ca:	50                   	push   %eax
f01029cb:	e8 e5 d6 ff ff       	call   f01000b5 <_panic>
	assert(pp0->pp_ref == 1);
f01029d0:	8d 83 a6 8c f7 ff    	lea    -0x8735a(%ebx),%eax
f01029d6:	50                   	push   %eax
f01029d7:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01029dd:	50                   	push   %eax
f01029de:	68 07 04 00 00       	push   $0x407
f01029e3:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01029e9:	50                   	push   %eax
f01029ea:	e8 c6 d6 ff ff       	call   f01000b5 <_panic>
f01029ef:	51                   	push   %ecx
f01029f0:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f01029f6:	50                   	push   %eax
f01029f7:	68 0e 04 00 00       	push   $0x40e
f01029fc:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102a02:	50                   	push   %eax
f0102a03:	e8 ad d6 ff ff       	call   f01000b5 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102a08:	8d 83 32 8d f7 ff    	lea    -0x872ce(%ebx),%eax
f0102a0e:	50                   	push   %eax
f0102a0f:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102a15:	50                   	push   %eax
f0102a16:	68 0f 04 00 00       	push   $0x40f
f0102a1b:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102a21:	50                   	push   %eax
f0102a22:	e8 8e d6 ff ff       	call   f01000b5 <_panic>
f0102a27:	52                   	push   %edx
f0102a28:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f0102a2e:	50                   	push   %eax
f0102a2f:	6a 56                	push   $0x56
f0102a31:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f0102a37:	50                   	push   %eax
f0102a38:	e8 78 d6 ff ff       	call   f01000b5 <_panic>
f0102a3d:	52                   	push   %edx
f0102a3e:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f0102a44:	50                   	push   %eax
f0102a45:	6a 56                	push   $0x56
f0102a47:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f0102a4d:	50                   	push   %eax
f0102a4e:	e8 62 d6 ff ff       	call   f01000b5 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102a53:	8d 83 4a 8d f7 ff    	lea    -0x872b6(%ebx),%eax
f0102a59:	50                   	push   %eax
f0102a5a:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102a60:	50                   	push   %eax
f0102a61:	68 19 04 00 00       	push   $0x419
f0102a66:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102a6c:	50                   	push   %eax
f0102a6d:	e8 43 d6 ff ff       	call   f01000b5 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102a72:	50                   	push   %eax
f0102a73:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f0102a79:	50                   	push   %eax
f0102a7a:	68 c6 00 00 00       	push   $0xc6
f0102a7f:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102a85:	50                   	push   %eax
f0102a86:	e8 2a d6 ff ff       	call   f01000b5 <_panic>
f0102a8b:	50                   	push   %eax
f0102a8c:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f0102a92:	50                   	push   %eax
f0102a93:	68 d1 00 00 00       	push   $0xd1
f0102a98:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102a9e:	50                   	push   %eax
f0102a9f:	e8 11 d6 ff ff       	call   f01000b5 <_panic>
f0102aa4:	50                   	push   %eax
f0102aa5:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f0102aab:	50                   	push   %eax
f0102aac:	68 de 00 00 00       	push   $0xde
f0102ab1:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102ab7:	50                   	push   %eax
f0102ab8:	e8 f8 d5 ff ff       	call   f01000b5 <_panic>
f0102abd:	ff 75 bc             	pushl  -0x44(%ebp)
f0102ac0:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f0102ac6:	50                   	push   %eax
f0102ac7:	68 56 03 00 00       	push   $0x356
f0102acc:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102ad2:	50                   	push   %eax
f0102ad3:	e8 dd d5 ff ff       	call   f01000b5 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102ad8:	8d 83 f4 93 f7 ff    	lea    -0x86c0c(%ebx),%eax
f0102ade:	50                   	push   %eax
f0102adf:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102ae5:	50                   	push   %eax
f0102ae6:	68 56 03 00 00       	push   $0x356
f0102aeb:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102af1:	50                   	push   %eax
f0102af2:	e8 be d5 ff ff       	call   f01000b5 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102af7:	c7 c0 4c f3 18 f0    	mov    $0xf018f34c,%eax
f0102afd:	8b 00                	mov    (%eax),%eax
f0102aff:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102b02:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102b05:	be 00 00 c0 ee       	mov    $0xeec00000,%esi
f0102b0a:	05 00 00 40 21       	add    $0x21400000,%eax
f0102b0f:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0102b12:	89 f2                	mov    %esi,%edx
f0102b14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b17:	e8 46 e0 ff ff       	call   f0100b62 <check_va2pa>
f0102b1c:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102b23:	76 42                	jbe    f0102b67 <mem_init+0x16b9>
f0102b25:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0102b28:	8d 14 31             	lea    (%ecx,%esi,1),%edx
f0102b2b:	39 d0                	cmp    %edx,%eax
f0102b2d:	75 53                	jne    f0102b82 <mem_init+0x16d4>
f0102b2f:	81 c6 00 10 00 00    	add    $0x1000,%esi
	for (i = 0; i < n; i += PGSIZE)
f0102b35:	81 fe 00 80 c1 ee    	cmp    $0xeec18000,%esi
f0102b3b:	75 d5                	jne    f0102b12 <mem_init+0x1664>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102b3d:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0102b40:	c1 e0 0c             	shl    $0xc,%eax
f0102b43:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102b46:	89 fe                	mov    %edi,%esi
f0102b48:	3b 75 cc             	cmp    -0x34(%ebp),%esi
f0102b4b:	73 73                	jae    f0102bc0 <mem_init+0x1712>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102b4d:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
f0102b53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b56:	e8 07 e0 ff ff       	call   f0100b62 <check_va2pa>
f0102b5b:	39 c6                	cmp    %eax,%esi
f0102b5d:	75 42                	jne    f0102ba1 <mem_init+0x16f3>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102b5f:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0102b65:	eb e1                	jmp    f0102b48 <mem_init+0x169a>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102b67:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102b6a:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f0102b70:	50                   	push   %eax
f0102b71:	68 5b 03 00 00       	push   $0x35b
f0102b76:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102b7c:	50                   	push   %eax
f0102b7d:	e8 33 d5 ff ff       	call   f01000b5 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102b82:	8d 83 28 94 f7 ff    	lea    -0x86bd8(%ebx),%eax
f0102b88:	50                   	push   %eax
f0102b89:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102b8f:	50                   	push   %eax
f0102b90:	68 5b 03 00 00       	push   $0x35b
f0102b95:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102b9b:	50                   	push   %eax
f0102b9c:	e8 14 d5 ff ff       	call   f01000b5 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102ba1:	8d 83 5c 94 f7 ff    	lea    -0x86ba4(%ebx),%eax
f0102ba7:	50                   	push   %eax
f0102ba8:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102bae:	50                   	push   %eax
f0102baf:	68 5f 03 00 00       	push   $0x35f
f0102bb4:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102bba:	50                   	push   %eax
f0102bbb:	e8 f5 d4 ff ff       	call   f01000b5 <_panic>
f0102bc0:	be 00 80 ff ef       	mov    $0xefff8000,%esi
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0102bc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102bc8:	05 00 80 00 20       	add    $0x20008000,%eax
f0102bcd:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102bd0:	89 f2                	mov    %esi,%edx
f0102bd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102bd5:	e8 88 df ff ff       	call   f0100b62 <check_va2pa>
f0102bda:	89 c2                	mov    %eax,%edx
f0102bdc:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102bdf:	01 f0                	add    %esi,%eax
f0102be1:	39 c2                	cmp    %eax,%edx
f0102be3:	75 25                	jne    f0102c0a <mem_init+0x175c>
f0102be5:	81 c6 00 10 00 00    	add    $0x1000,%esi
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102beb:	81 fe 00 00 00 f0    	cmp    $0xf0000000,%esi
f0102bf1:	75 dd                	jne    f0102bd0 <mem_init+0x1722>
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0102bf3:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f0102bf8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102bfb:	e8 62 df ff ff       	call   f0100b62 <check_va2pa>
f0102c00:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102c03:	75 24                	jne    f0102c29 <mem_init+0x177b>
f0102c05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102c08:	eb 6b                	jmp    f0102c75 <mem_init+0x17c7>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0102c0a:	8d 83 84 94 f7 ff    	lea    -0x86b7c(%ebx),%eax
f0102c10:	50                   	push   %eax
f0102c11:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102c17:	50                   	push   %eax
f0102c18:	68 63 03 00 00       	push   $0x363
f0102c1d:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102c23:	50                   	push   %eax
f0102c24:	e8 8c d4 ff ff       	call   f01000b5 <_panic>
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0102c29:	8d 83 cc 94 f7 ff    	lea    -0x86b34(%ebx),%eax
f0102c2f:	50                   	push   %eax
f0102c30:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102c36:	50                   	push   %eax
f0102c37:	68 64 03 00 00       	push   $0x364
f0102c3c:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102c42:	50                   	push   %eax
f0102c43:	e8 6d d4 ff ff       	call   f01000b5 <_panic>
		switch (i) {
f0102c48:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102c4e:	75 25                	jne    f0102c75 <mem_init+0x17c7>
			assert(pgdir[i] & PTE_P);
f0102c50:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102c54:	74 4c                	je     f0102ca2 <mem_init+0x17f4>
	for (i = 0; i < NPDENTRIES; i++) {
f0102c56:	83 c7 01             	add    $0x1,%edi
f0102c59:	81 ff ff 03 00 00    	cmp    $0x3ff,%edi
f0102c5f:	0f 87 a7 00 00 00    	ja     f0102d0c <mem_init+0x185e>
		switch (i) {
f0102c65:	81 ff bd 03 00 00    	cmp    $0x3bd,%edi
f0102c6b:	77 db                	ja     f0102c48 <mem_init+0x179a>
f0102c6d:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
f0102c73:	77 db                	ja     f0102c50 <mem_init+0x17a2>
			if (i >= PDX(KERNBASE)) {
f0102c75:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102c7b:	77 44                	ja     f0102cc1 <mem_init+0x1813>
				assert(pgdir[i] == 0);
f0102c7d:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102c81:	74 d3                	je     f0102c56 <mem_init+0x17a8>
f0102c83:	8d 83 9c 8d f7 ff    	lea    -0x87264(%ebx),%eax
f0102c89:	50                   	push   %eax
f0102c8a:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102c90:	50                   	push   %eax
f0102c91:	68 74 03 00 00       	push   $0x374
f0102c96:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102c9c:	50                   	push   %eax
f0102c9d:	e8 13 d4 ff ff       	call   f01000b5 <_panic>
			assert(pgdir[i] & PTE_P);
f0102ca2:	8d 83 7a 8d f7 ff    	lea    -0x87286(%ebx),%eax
f0102ca8:	50                   	push   %eax
f0102ca9:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102caf:	50                   	push   %eax
f0102cb0:	68 6d 03 00 00       	push   $0x36d
f0102cb5:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102cbb:	50                   	push   %eax
f0102cbc:	e8 f4 d3 ff ff       	call   f01000b5 <_panic>
				assert(pgdir[i] & PTE_P);
f0102cc1:	8b 14 b8             	mov    (%eax,%edi,4),%edx
f0102cc4:	f6 c2 01             	test   $0x1,%dl
f0102cc7:	74 24                	je     f0102ced <mem_init+0x183f>
				assert(pgdir[i] & PTE_W);
f0102cc9:	f6 c2 02             	test   $0x2,%dl
f0102ccc:	75 88                	jne    f0102c56 <mem_init+0x17a8>
f0102cce:	8d 83 8b 8d f7 ff    	lea    -0x87275(%ebx),%eax
f0102cd4:	50                   	push   %eax
f0102cd5:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102cdb:	50                   	push   %eax
f0102cdc:	68 72 03 00 00       	push   $0x372
f0102ce1:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102ce7:	50                   	push   %eax
f0102ce8:	e8 c8 d3 ff ff       	call   f01000b5 <_panic>
				assert(pgdir[i] & PTE_P);
f0102ced:	8d 83 7a 8d f7 ff    	lea    -0x87286(%ebx),%eax
f0102cf3:	50                   	push   %eax
f0102cf4:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102cfa:	50                   	push   %eax
f0102cfb:	68 71 03 00 00       	push   $0x371
f0102d00:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102d06:	50                   	push   %eax
f0102d07:	e8 a9 d3 ff ff       	call   f01000b5 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102d0c:	83 ec 0c             	sub    $0xc,%esp
f0102d0f:	8d 83 fc 94 f7 ff    	lea    -0x86b04(%ebx),%eax
f0102d15:	50                   	push   %eax
f0102d16:	e8 a9 0d 00 00       	call   f0103ac4 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102d1b:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0102d21:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0102d23:	83 c4 10             	add    $0x10,%esp
f0102d26:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102d2b:	0f 86 30 02 00 00    	jbe    f0102f61 <mem_init+0x1ab3>
	return (physaddr_t)kva - KERNBASE;
f0102d31:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102d36:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102d39:	b8 00 00 00 00       	mov    $0x0,%eax
f0102d3e:	e8 9b de ff ff       	call   f0100bde <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102d43:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102d46:	83 e0 f3             	and    $0xfffffff3,%eax
f0102d49:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102d4e:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102d51:	83 ec 0c             	sub    $0xc,%esp
f0102d54:	6a 00                	push   $0x0
f0102d56:	e8 55 e3 ff ff       	call   f01010b0 <page_alloc>
f0102d5b:	89 c6                	mov    %eax,%esi
f0102d5d:	83 c4 10             	add    $0x10,%esp
f0102d60:	85 c0                	test   %eax,%eax
f0102d62:	0f 84 12 02 00 00    	je     f0102f7a <mem_init+0x1acc>
	assert((pp1 = page_alloc(0)));
f0102d68:	83 ec 0c             	sub    $0xc,%esp
f0102d6b:	6a 00                	push   $0x0
f0102d6d:	e8 3e e3 ff ff       	call   f01010b0 <page_alloc>
f0102d72:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102d75:	83 c4 10             	add    $0x10,%esp
f0102d78:	85 c0                	test   %eax,%eax
f0102d7a:	0f 84 19 02 00 00    	je     f0102f99 <mem_init+0x1aeb>
	assert((pp2 = page_alloc(0)));
f0102d80:	83 ec 0c             	sub    $0xc,%esp
f0102d83:	6a 00                	push   $0x0
f0102d85:	e8 26 e3 ff ff       	call   f01010b0 <page_alloc>
f0102d8a:	89 c7                	mov    %eax,%edi
f0102d8c:	83 c4 10             	add    $0x10,%esp
f0102d8f:	85 c0                	test   %eax,%eax
f0102d91:	0f 84 21 02 00 00    	je     f0102fb8 <mem_init+0x1b0a>
	page_free(pp0);
f0102d97:	83 ec 0c             	sub    $0xc,%esp
f0102d9a:	56                   	push   %esi
f0102d9b:	e8 b3 e3 ff ff       	call   f0101153 <page_free>
	return (pp - pages) << PGSHIFT;
f0102da0:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0102da6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102da9:	2b 08                	sub    (%eax),%ecx
f0102dab:	89 c8                	mov    %ecx,%eax
f0102dad:	c1 f8 03             	sar    $0x3,%eax
f0102db0:	89 c2                	mov    %eax,%edx
f0102db2:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102db5:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102dba:	83 c4 10             	add    $0x10,%esp
f0102dbd:	c7 c1 04 00 19 f0    	mov    $0xf0190004,%ecx
f0102dc3:	3b 01                	cmp    (%ecx),%eax
f0102dc5:	0f 83 0c 02 00 00    	jae    f0102fd7 <mem_init+0x1b29>
	memset(page2kva(pp1), 1, PGSIZE);
f0102dcb:	83 ec 04             	sub    $0x4,%esp
f0102dce:	68 00 10 00 00       	push   $0x1000
f0102dd3:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102dd5:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102ddb:	52                   	push   %edx
f0102ddc:	e8 a7 23 00 00       	call   f0105188 <memset>
	return (pp - pages) << PGSHIFT;
f0102de1:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0102de7:	89 f9                	mov    %edi,%ecx
f0102de9:	2b 08                	sub    (%eax),%ecx
f0102deb:	89 c8                	mov    %ecx,%eax
f0102ded:	c1 f8 03             	sar    $0x3,%eax
f0102df0:	89 c2                	mov    %eax,%edx
f0102df2:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102df5:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102dfa:	83 c4 10             	add    $0x10,%esp
f0102dfd:	c7 c1 04 00 19 f0    	mov    $0xf0190004,%ecx
f0102e03:	3b 01                	cmp    (%ecx),%eax
f0102e05:	0f 83 e2 01 00 00    	jae    f0102fed <mem_init+0x1b3f>
	memset(page2kva(pp2), 2, PGSIZE);
f0102e0b:	83 ec 04             	sub    $0x4,%esp
f0102e0e:	68 00 10 00 00       	push   $0x1000
f0102e13:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102e15:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102e1b:	52                   	push   %edx
f0102e1c:	e8 67 23 00 00       	call   f0105188 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102e21:	6a 02                	push   $0x2
f0102e23:	68 00 10 00 00       	push   $0x1000
f0102e28:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102e2b:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0102e31:	ff 30                	pushl  (%eax)
f0102e33:	e8 ce e5 ff ff       	call   f0101406 <page_insert>
	assert(pp1->pp_ref == 1);
f0102e38:	83 c4 20             	add    $0x20,%esp
f0102e3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102e3e:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102e43:	0f 85 ba 01 00 00    	jne    f0103003 <mem_init+0x1b55>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102e49:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102e50:	01 01 01 
f0102e53:	0f 85 c9 01 00 00    	jne    f0103022 <mem_init+0x1b74>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102e59:	6a 02                	push   $0x2
f0102e5b:	68 00 10 00 00       	push   $0x1000
f0102e60:	57                   	push   %edi
f0102e61:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0102e67:	ff 30                	pushl  (%eax)
f0102e69:	e8 98 e5 ff ff       	call   f0101406 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102e6e:	83 c4 10             	add    $0x10,%esp
f0102e71:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102e78:	02 02 02 
f0102e7b:	0f 85 c0 01 00 00    	jne    f0103041 <mem_init+0x1b93>
	assert(pp2->pp_ref == 1);
f0102e81:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102e86:	0f 85 d4 01 00 00    	jne    f0103060 <mem_init+0x1bb2>
	assert(pp1->pp_ref == 0);
f0102e8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102e8f:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0102e94:	0f 85 e5 01 00 00    	jne    f010307f <mem_init+0x1bd1>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102e9a:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102ea1:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102ea4:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0102eaa:	89 f9                	mov    %edi,%ecx
f0102eac:	2b 08                	sub    (%eax),%ecx
f0102eae:	89 c8                	mov    %ecx,%eax
f0102eb0:	c1 f8 03             	sar    $0x3,%eax
f0102eb3:	89 c2                	mov    %eax,%edx
f0102eb5:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102eb8:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102ebd:	c7 c1 04 00 19 f0    	mov    $0xf0190004,%ecx
f0102ec3:	3b 01                	cmp    (%ecx),%eax
f0102ec5:	0f 83 d3 01 00 00    	jae    f010309e <mem_init+0x1bf0>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102ecb:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f0102ed2:	03 03 03 
f0102ed5:	0f 85 d9 01 00 00    	jne    f01030b4 <mem_init+0x1c06>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102edb:	83 ec 08             	sub    $0x8,%esp
f0102ede:	68 00 10 00 00       	push   $0x1000
f0102ee3:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0102ee9:	ff 30                	pushl  (%eax)
f0102eeb:	e8 d7 e4 ff ff       	call   f01013c7 <page_remove>
	assert(pp2->pp_ref == 0);
f0102ef0:	83 c4 10             	add    $0x10,%esp
f0102ef3:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102ef8:	0f 85 d5 01 00 00    	jne    f01030d3 <mem_init+0x1c25>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102efe:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0102f04:	8b 08                	mov    (%eax),%ecx
f0102f06:	8b 11                	mov    (%ecx),%edx
f0102f08:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102f0e:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0102f14:	89 f7                	mov    %esi,%edi
f0102f16:	2b 38                	sub    (%eax),%edi
f0102f18:	89 f8                	mov    %edi,%eax
f0102f1a:	c1 f8 03             	sar    $0x3,%eax
f0102f1d:	c1 e0 0c             	shl    $0xc,%eax
f0102f20:	39 c2                	cmp    %eax,%edx
f0102f22:	0f 85 ca 01 00 00    	jne    f01030f2 <mem_init+0x1c44>
	kern_pgdir[0] = 0;
f0102f28:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102f2e:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102f33:	0f 85 d8 01 00 00    	jne    f0103111 <mem_init+0x1c63>
	pp0->pp_ref = 0;
f0102f39:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0102f3f:	83 ec 0c             	sub    $0xc,%esp
f0102f42:	56                   	push   %esi
f0102f43:	e8 0b e2 ff ff       	call   f0101153 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102f48:	8d 83 90 95 f7 ff    	lea    -0x86a70(%ebx),%eax
f0102f4e:	89 04 24             	mov    %eax,(%esp)
f0102f51:	e8 6e 0b 00 00       	call   f0103ac4 <cprintf>
}
f0102f56:	83 c4 10             	add    $0x10,%esp
f0102f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102f5c:	5b                   	pop    %ebx
f0102f5d:	5e                   	pop    %esi
f0102f5e:	5f                   	pop    %edi
f0102f5f:	5d                   	pop    %ebp
f0102f60:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f61:	50                   	push   %eax
f0102f62:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f0102f68:	50                   	push   %eax
f0102f69:	68 f4 00 00 00       	push   $0xf4
f0102f6e:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102f74:	50                   	push   %eax
f0102f75:	e8 3b d1 ff ff       	call   f01000b5 <_panic>
	assert((pp0 = page_alloc(0)));
f0102f7a:	8d 83 98 8b f7 ff    	lea    -0x87468(%ebx),%eax
f0102f80:	50                   	push   %eax
f0102f81:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102f87:	50                   	push   %eax
f0102f88:	68 34 04 00 00       	push   $0x434
f0102f8d:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102f93:	50                   	push   %eax
f0102f94:	e8 1c d1 ff ff       	call   f01000b5 <_panic>
	assert((pp1 = page_alloc(0)));
f0102f99:	8d 83 ae 8b f7 ff    	lea    -0x87452(%ebx),%eax
f0102f9f:	50                   	push   %eax
f0102fa0:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102fa6:	50                   	push   %eax
f0102fa7:	68 35 04 00 00       	push   $0x435
f0102fac:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102fb2:	50                   	push   %eax
f0102fb3:	e8 fd d0 ff ff       	call   f01000b5 <_panic>
	assert((pp2 = page_alloc(0)));
f0102fb8:	8d 83 c4 8b f7 ff    	lea    -0x8743c(%ebx),%eax
f0102fbe:	50                   	push   %eax
f0102fbf:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0102fc5:	50                   	push   %eax
f0102fc6:	68 36 04 00 00       	push   $0x436
f0102fcb:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0102fd1:	50                   	push   %eax
f0102fd2:	e8 de d0 ff ff       	call   f01000b5 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102fd7:	52                   	push   %edx
f0102fd8:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f0102fde:	50                   	push   %eax
f0102fdf:	6a 56                	push   $0x56
f0102fe1:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f0102fe7:	50                   	push   %eax
f0102fe8:	e8 c8 d0 ff ff       	call   f01000b5 <_panic>
f0102fed:	52                   	push   %edx
f0102fee:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f0102ff4:	50                   	push   %eax
f0102ff5:	6a 56                	push   $0x56
f0102ff7:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f0102ffd:	50                   	push   %eax
f0102ffe:	e8 b2 d0 ff ff       	call   f01000b5 <_panic>
	assert(pp1->pp_ref == 1);
f0103003:	8d 83 95 8c f7 ff    	lea    -0x8736b(%ebx),%eax
f0103009:	50                   	push   %eax
f010300a:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f0103010:	50                   	push   %eax
f0103011:	68 3b 04 00 00       	push   $0x43b
f0103016:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010301c:	50                   	push   %eax
f010301d:	e8 93 d0 ff ff       	call   f01000b5 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0103022:	8d 83 1c 95 f7 ff    	lea    -0x86ae4(%ebx),%eax
f0103028:	50                   	push   %eax
f0103029:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010302f:	50                   	push   %eax
f0103030:	68 3c 04 00 00       	push   $0x43c
f0103035:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010303b:	50                   	push   %eax
f010303c:	e8 74 d0 ff ff       	call   f01000b5 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103041:	8d 83 40 95 f7 ff    	lea    -0x86ac0(%ebx),%eax
f0103047:	50                   	push   %eax
f0103048:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010304e:	50                   	push   %eax
f010304f:	68 3e 04 00 00       	push   $0x43e
f0103054:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010305a:	50                   	push   %eax
f010305b:	e8 55 d0 ff ff       	call   f01000b5 <_panic>
	assert(pp2->pp_ref == 1);
f0103060:	8d 83 b7 8c f7 ff    	lea    -0x87349(%ebx),%eax
f0103066:	50                   	push   %eax
f0103067:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010306d:	50                   	push   %eax
f010306e:	68 3f 04 00 00       	push   $0x43f
f0103073:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0103079:	50                   	push   %eax
f010307a:	e8 36 d0 ff ff       	call   f01000b5 <_panic>
	assert(pp1->pp_ref == 0);
f010307f:	8d 83 21 8d f7 ff    	lea    -0x872df(%ebx),%eax
f0103085:	50                   	push   %eax
f0103086:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010308c:	50                   	push   %eax
f010308d:	68 40 04 00 00       	push   $0x440
f0103092:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f0103098:	50                   	push   %eax
f0103099:	e8 17 d0 ff ff       	call   f01000b5 <_panic>
f010309e:	52                   	push   %edx
f010309f:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f01030a5:	50                   	push   %eax
f01030a6:	6a 56                	push   $0x56
f01030a8:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f01030ae:	50                   	push   %eax
f01030af:	e8 01 d0 ff ff       	call   f01000b5 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01030b4:	8d 83 64 95 f7 ff    	lea    -0x86a9c(%ebx),%eax
f01030ba:	50                   	push   %eax
f01030bb:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01030c1:	50                   	push   %eax
f01030c2:	68 42 04 00 00       	push   $0x442
f01030c7:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01030cd:	50                   	push   %eax
f01030ce:	e8 e2 cf ff ff       	call   f01000b5 <_panic>
	assert(pp2->pp_ref == 0);
f01030d3:	8d 83 ef 8c f7 ff    	lea    -0x87311(%ebx),%eax
f01030d9:	50                   	push   %eax
f01030da:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01030e0:	50                   	push   %eax
f01030e1:	68 44 04 00 00       	push   $0x444
f01030e6:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f01030ec:	50                   	push   %eax
f01030ed:	e8 c3 cf ff ff       	call   f01000b5 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01030f2:	8d 83 74 90 f7 ff    	lea    -0x86f8c(%ebx),%eax
f01030f8:	50                   	push   %eax
f01030f9:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01030ff:	50                   	push   %eax
f0103100:	68 47 04 00 00       	push   $0x447
f0103105:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010310b:	50                   	push   %eax
f010310c:	e8 a4 cf ff ff       	call   f01000b5 <_panic>
	assert(pp0->pp_ref == 1);
f0103111:	8d 83 a6 8c f7 ff    	lea    -0x8735a(%ebx),%eax
f0103117:	50                   	push   %eax
f0103118:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f010311e:	50                   	push   %eax
f010311f:	68 49 04 00 00       	push   $0x449
f0103124:	8d 83 c7 8a f7 ff    	lea    -0x87539(%ebx),%eax
f010312a:	50                   	push   %eax
f010312b:	e8 85 cf ff ff       	call   f01000b5 <_panic>

f0103130 <tlb_invalidate>:
{
f0103130:	f3 0f 1e fb          	endbr32 
f0103134:	55                   	push   %ebp
f0103135:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0103137:	8b 45 0c             	mov    0xc(%ebp),%eax
f010313a:	0f 01 38             	invlpg (%eax)
}
f010313d:	5d                   	pop    %ebp
f010313e:	c3                   	ret    

f010313f <user_mem_check>:
{
f010313f:	f3 0f 1e fb          	endbr32 
f0103143:	55                   	push   %ebp
f0103144:	89 e5                	mov    %esp,%ebp
f0103146:	57                   	push   %edi
f0103147:	56                   	push   %esi
f0103148:	53                   	push   %ebx
f0103149:	83 ec 1c             	sub    $0x1c,%esp
f010314c:	e8 d6 d5 ff ff       	call   f0100727 <__x86.get_pc_thunk.ax>
f0103151:	05 cb 9e 08 00       	add    $0x89ecb,%eax
f0103156:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    vstart = ROUNDDOWN((uintptr_t)va, PGSIZE);
f0103159:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010315c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    vend = ROUNDUP((uintptr_t)va + len, PGSIZE);
f0103162:	8b 45 10             	mov    0x10(%ebp),%eax
f0103165:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103168:	8d bc 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edi
f010316f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if (vend > ULIM) {
f0103175:	81 ff 00 00 80 ef    	cmp    $0xef800000,%edi
f010317b:	77 08                	ja     f0103185 <user_mem_check+0x46>
        if (!pte || (*pte & (perm | PTE_P)) != (perm | PTE_P)) {
f010317d:	8b 75 14             	mov    0x14(%ebp),%esi
f0103180:	83 ce 01             	or     $0x1,%esi
f0103183:	eb 26                	jmp    f01031ab <user_mem_check+0x6c>
        user_mem_check_addr = MAX(ULIM, (uintptr_t)va);
f0103185:	81 7d 0c 00 00 80 ef 	cmpl   $0xef800000,0xc(%ebp)
f010318c:	b8 00 00 80 ef       	mov    $0xef800000,%eax
f0103191:	0f 43 45 0c          	cmovae 0xc(%ebp),%eax
f0103195:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0103198:	89 81 20 23 00 00    	mov    %eax,0x2320(%ecx)
        return -E_FAULT;
f010319e:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f01031a3:	eb 3f                	jmp    f01031e4 <user_mem_check+0xa5>
    for (; vstart < vend; vstart += PGSIZE) {
f01031a5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01031ab:	39 fb                	cmp    %edi,%ebx
f01031ad:	73 3d                	jae    f01031ec <user_mem_check+0xad>
        pte = pgdir_walk(env->env_pgdir, (void*)vstart, 0);
f01031af:	83 ec 04             	sub    $0x4,%esp
f01031b2:	6a 00                	push   $0x0
f01031b4:	53                   	push   %ebx
f01031b5:	8b 45 08             	mov    0x8(%ebp),%eax
f01031b8:	ff 70 5c             	pushl  0x5c(%eax)
f01031bb:	e8 2e e0 ff ff       	call   f01011ee <pgdir_walk>
        if (!pte || (*pte & (perm | PTE_P)) != (perm | PTE_P)) {
f01031c0:	83 c4 10             	add    $0x10,%esp
f01031c3:	85 c0                	test   %eax,%eax
f01031c5:	74 08                	je     f01031cf <user_mem_check+0x90>
f01031c7:	89 f2                	mov    %esi,%edx
f01031c9:	23 10                	and    (%eax),%edx
f01031cb:	39 d6                	cmp    %edx,%esi
f01031cd:	74 d6                	je     f01031a5 <user_mem_check+0x66>
            user_mem_check_addr = MAX(vstart, (uintptr_t)va);
f01031cf:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f01031d2:	0f 42 5d 0c          	cmovb  0xc(%ebp),%ebx
f01031d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01031d9:	89 98 20 23 00 00    	mov    %ebx,0x2320(%eax)
            return -E_FAULT;
f01031df:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f01031e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01031e7:	5b                   	pop    %ebx
f01031e8:	5e                   	pop    %esi
f01031e9:	5f                   	pop    %edi
f01031ea:	5d                   	pop    %ebp
f01031eb:	c3                   	ret    
    return 0;
f01031ec:	b8 00 00 00 00       	mov    $0x0,%eax
f01031f1:	eb f1                	jmp    f01031e4 <user_mem_check+0xa5>

f01031f3 <user_mem_assert>:
{
f01031f3:	f3 0f 1e fb          	endbr32 
f01031f7:	55                   	push   %ebp
f01031f8:	89 e5                	mov    %esp,%ebp
f01031fa:	56                   	push   %esi
f01031fb:	53                   	push   %ebx
f01031fc:	e8 72 cf ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0103201:	81 c3 1b 9e 08 00    	add    $0x89e1b,%ebx
f0103207:	8b 75 08             	mov    0x8(%ebp),%esi
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f010320a:	8b 45 14             	mov    0x14(%ebp),%eax
f010320d:	83 c8 04             	or     $0x4,%eax
f0103210:	50                   	push   %eax
f0103211:	ff 75 10             	pushl  0x10(%ebp)
f0103214:	ff 75 0c             	pushl  0xc(%ebp)
f0103217:	56                   	push   %esi
f0103218:	e8 22 ff ff ff       	call   f010313f <user_mem_check>
f010321d:	83 c4 10             	add    $0x10,%esp
f0103220:	85 c0                	test   %eax,%eax
f0103222:	78 07                	js     f010322b <user_mem_assert+0x38>
}
f0103224:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103227:	5b                   	pop    %ebx
f0103228:	5e                   	pop    %esi
f0103229:	5d                   	pop    %ebp
f010322a:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f010322b:	83 ec 04             	sub    $0x4,%esp
f010322e:	ff b3 20 23 00 00    	pushl  0x2320(%ebx)
f0103234:	ff 76 48             	pushl  0x48(%esi)
f0103237:	8d 83 bc 95 f7 ff    	lea    -0x86a44(%ebx),%eax
f010323d:	50                   	push   %eax
f010323e:	e8 81 08 00 00       	call   f0103ac4 <cprintf>
		env_destroy(env);	// may not return
f0103243:	89 34 24             	mov    %esi,(%esp)
f0103246:	e8 f3 06 00 00       	call   f010393e <env_destroy>
f010324b:	83 c4 10             	add    $0x10,%esp
}
f010324e:	eb d4                	jmp    f0103224 <user_mem_assert+0x31>

f0103250 <__x86.get_pc_thunk.cx>:
f0103250:	8b 0c 24             	mov    (%esp),%ecx
f0103253:	c3                   	ret    

f0103254 <__x86.get_pc_thunk.di>:
f0103254:	8b 3c 24             	mov    (%esp),%edi
f0103257:	c3                   	ret    

f0103258 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0103258:	55                   	push   %ebp
f0103259:	89 e5                	mov    %esp,%ebp
f010325b:	57                   	push   %edi
f010325c:	56                   	push   %esi
f010325d:	53                   	push   %ebx
f010325e:	83 ec 1c             	sub    $0x1c,%esp
f0103261:	e8 0d cf ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0103266:	81 c3 b6 9d 08 00    	add    $0x89db6,%ebx
f010326c:	89 c7                	mov    %eax,%edi
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	// ROUNDDOWN/ROUNDUP在inc/types.h中
	void* begin = ROUNDDOWN(va, PGSIZE);
f010326e:	89 d6                	mov    %edx,%esi
f0103270:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	void* end = ROUNDUP(va + len, PGSIZE);
f0103276:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f010327d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103282:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	while(begin < end){
f0103285:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
f0103288:	73 43                	jae    f01032cd <region_alloc+0x75>
		struct PageInfo* pp = page_alloc(0);
f010328a:	83 ec 0c             	sub    $0xc,%esp
f010328d:	6a 00                	push   $0x0
f010328f:	e8 1c de ff ff       	call   f01010b0 <page_alloc>
		if(!pp){
f0103294:	83 c4 10             	add    $0x10,%esp
f0103297:	85 c0                	test   %eax,%eax
f0103299:	74 17                	je     f01032b2 <region_alloc+0x5a>
			panic("region_alloc failed\n");
		}
		page_insert(e->env_pgdir, pp, begin, PTE_W | PTE_U);
f010329b:	6a 06                	push   $0x6
f010329d:	56                   	push   %esi
f010329e:	50                   	push   %eax
f010329f:	ff 77 5c             	pushl  0x5c(%edi)
f01032a2:	e8 5f e1 ff ff       	call   f0101406 <page_insert>
		begin += PGSIZE;
f01032a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01032ad:	83 c4 10             	add    $0x10,%esp
f01032b0:	eb d3                	jmp    f0103285 <region_alloc+0x2d>
			panic("region_alloc failed\n");
f01032b2:	83 ec 04             	sub    $0x4,%esp
f01032b5:	8d 83 f1 95 f7 ff    	lea    -0x86a0f(%ebx),%eax
f01032bb:	50                   	push   %eax
f01032bc:	68 1f 01 00 00       	push   $0x11f
f01032c1:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f01032c7:	50                   	push   %eax
f01032c8:	e8 e8 cd ff ff       	call   f01000b5 <_panic>
	}
}
f01032cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01032d0:	5b                   	pop    %ebx
f01032d1:	5e                   	pop    %esi
f01032d2:	5f                   	pop    %edi
f01032d3:	5d                   	pop    %ebp
f01032d4:	c3                   	ret    

f01032d5 <envid2env>:
{
f01032d5:	f3 0f 1e fb          	endbr32 
f01032d9:	55                   	push   %ebp
f01032da:	89 e5                	mov    %esp,%ebp
f01032dc:	53                   	push   %ebx
f01032dd:	e8 6e ff ff ff       	call   f0103250 <__x86.get_pc_thunk.cx>
f01032e2:	81 c1 3a 9d 08 00    	add    $0x89d3a,%ecx
f01032e8:	8b 45 08             	mov    0x8(%ebp),%eax
f01032eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	if (envid == 0) {
f01032ee:	85 c0                	test   %eax,%eax
f01032f0:	74 42                	je     f0103334 <envid2env+0x5f>
	e = &envs[ENVX(envid)];
f01032f2:	89 c2                	mov    %eax,%edx
f01032f4:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f01032fa:	8d 14 52             	lea    (%edx,%edx,2),%edx
f01032fd:	c1 e2 05             	shl    $0x5,%edx
f0103300:	03 91 30 23 00 00    	add    0x2330(%ecx),%edx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103306:	83 7a 54 00          	cmpl   $0x0,0x54(%edx)
f010330a:	74 35                	je     f0103341 <envid2env+0x6c>
f010330c:	39 42 48             	cmp    %eax,0x48(%edx)
f010330f:	75 30                	jne    f0103341 <envid2env+0x6c>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103311:	84 db                	test   %bl,%bl
f0103313:	74 12                	je     f0103327 <envid2env+0x52>
f0103315:	8b 81 2c 23 00 00    	mov    0x232c(%ecx),%eax
f010331b:	39 d0                	cmp    %edx,%eax
f010331d:	74 08                	je     f0103327 <envid2env+0x52>
f010331f:	8b 40 48             	mov    0x48(%eax),%eax
f0103322:	39 42 4c             	cmp    %eax,0x4c(%edx)
f0103325:	75 2a                	jne    f0103351 <envid2env+0x7c>
	*env_store = e;
f0103327:	8b 45 0c             	mov    0xc(%ebp),%eax
f010332a:	89 10                	mov    %edx,(%eax)
	return 0;
f010332c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103331:	5b                   	pop    %ebx
f0103332:	5d                   	pop    %ebp
f0103333:	c3                   	ret    
		*env_store = curenv;
f0103334:	8b 91 2c 23 00 00    	mov    0x232c(%ecx),%edx
f010333a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010333d:	89 13                	mov    %edx,(%ebx)
		return 0;
f010333f:	eb f0                	jmp    f0103331 <envid2env+0x5c>
		*env_store = 0;
f0103341:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103344:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f010334a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010334f:	eb e0                	jmp    f0103331 <envid2env+0x5c>
		*env_store = 0;
f0103351:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f010335a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010335f:	eb d0                	jmp    f0103331 <envid2env+0x5c>

f0103361 <env_init_percpu>:
{
f0103361:	f3 0f 1e fb          	endbr32 
f0103365:	e8 bd d3 ff ff       	call   f0100727 <__x86.get_pc_thunk.ax>
f010336a:	05 b2 9c 08 00       	add    $0x89cb2,%eax
	asm volatile("lgdt (%0)" : : "r" (p));
f010336f:	8d 80 e4 1f 00 00    	lea    0x1fe4(%eax),%eax
f0103375:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f0103378:	b8 23 00 00 00       	mov    $0x23,%eax
f010337d:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f010337f:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f0103381:	b8 10 00 00 00       	mov    $0x10,%eax
f0103386:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f0103388:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f010338a:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f010338c:	ea 93 33 10 f0 08 00 	ljmp   $0x8,$0xf0103393
	asm volatile("lldt %0" : : "r" (sel));
f0103393:	b8 00 00 00 00       	mov    $0x0,%eax
f0103398:	0f 00 d0             	lldt   %ax
}
f010339b:	c3                   	ret    

f010339c <env_init>:
{
f010339c:	f3 0f 1e fb          	endbr32 
f01033a0:	55                   	push   %ebp
f01033a1:	89 e5                	mov    %esp,%ebp
f01033a3:	57                   	push   %edi
f01033a4:	56                   	push   %esi
f01033a5:	53                   	push   %ebx
f01033a6:	83 ec 0c             	sub    $0xc,%esp
f01033a9:	e8 a6 fe ff ff       	call   f0103254 <__x86.get_pc_thunk.di>
f01033ae:	81 c7 6e 9c 08 00    	add    $0x89c6e,%edi
		envs[i].env_id = 0;
f01033b4:	8b b7 30 23 00 00    	mov    0x2330(%edi),%esi
f01033ba:	8d 86 a0 7f 01 00    	lea    0x17fa0(%esi),%eax
f01033c0:	89 f3                	mov    %esi,%ebx
f01033c2:	ba 00 00 00 00       	mov    $0x0,%edx
f01033c7:	89 d1                	mov    %edx,%ecx
f01033c9:	89 c2                	mov    %eax,%edx
f01033cb:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_link = env_free_list;
f01033d2:	89 48 44             	mov    %ecx,0x44(%eax)
f01033d5:	83 e8 60             	sub    $0x60,%eax
	for(i = NENV - 1; i >= 0; i--){
f01033d8:	39 da                	cmp    %ebx,%edx
f01033da:	75 eb                	jne    f01033c7 <env_init+0x2b>
f01033dc:	89 b7 34 23 00 00    	mov    %esi,0x2334(%edi)
	env_init_percpu();
f01033e2:	e8 7a ff ff ff       	call   f0103361 <env_init_percpu>
}
f01033e7:	83 c4 0c             	add    $0xc,%esp
f01033ea:	5b                   	pop    %ebx
f01033eb:	5e                   	pop    %esi
f01033ec:	5f                   	pop    %edi
f01033ed:	5d                   	pop    %ebp
f01033ee:	c3                   	ret    

f01033ef <env_alloc>:
{
f01033ef:	f3 0f 1e fb          	endbr32 
f01033f3:	55                   	push   %ebp
f01033f4:	89 e5                	mov    %esp,%ebp
f01033f6:	56                   	push   %esi
f01033f7:	53                   	push   %ebx
f01033f8:	e8 76 cd ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f01033fd:	81 c3 1f 9c 08 00    	add    $0x89c1f,%ebx
	if (!(e = env_free_list))
f0103403:	8b b3 34 23 00 00    	mov    0x2334(%ebx),%esi
f0103409:	85 f6                	test   %esi,%esi
f010340b:	0f 84 63 01 00 00    	je     f0103574 <env_alloc+0x185>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103411:	83 ec 0c             	sub    $0xc,%esp
f0103414:	6a 01                	push   $0x1
f0103416:	e8 95 dc ff ff       	call   f01010b0 <page_alloc>
f010341b:	83 c4 10             	add    $0x10,%esp
f010341e:	85 c0                	test   %eax,%eax
f0103420:	0f 84 55 01 00 00    	je     f010357b <env_alloc+0x18c>
	p->pp_ref++;
f0103426:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010342b:	c7 c2 0c 00 19 f0    	mov    $0xf019000c,%edx
f0103431:	2b 02                	sub    (%edx),%eax
f0103433:	c1 f8 03             	sar    $0x3,%eax
f0103436:	89 c2                	mov    %eax,%edx
f0103438:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010343b:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0103440:	c7 c1 04 00 19 f0    	mov    $0xf0190004,%ecx
f0103446:	3b 01                	cmp    (%ecx),%eax
f0103448:	0f 83 f7 00 00 00    	jae    f0103545 <env_alloc+0x156>
	return (void *)(pa + KERNBASE);
f010344e:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	e->env_pgdir = (pde_t *)page2kva(p);
f0103454:	89 46 5c             	mov    %eax,0x5c(%esi)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f0103457:	83 ec 04             	sub    $0x4,%esp
f010345a:	68 00 10 00 00       	push   $0x1000
f010345f:	c7 c2 08 00 19 f0    	mov    $0xf0190008,%edx
f0103465:	ff 32                	pushl  (%edx)
f0103467:	50                   	push   %eax
f0103468:	e8 cd 1d 00 00       	call   f010523a <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f010346d:	8b 46 5c             	mov    0x5c(%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103470:	83 c4 10             	add    $0x10,%esp
f0103473:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103478:	0f 86 dd 00 00 00    	jbe    f010355b <env_alloc+0x16c>
	return (physaddr_t)kva - KERNBASE;
f010347e:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103484:	83 ca 05             	or     $0x5,%edx
f0103487:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f010348d:	8b 46 48             	mov    0x48(%esi),%eax
f0103490:	05 00 10 00 00       	add    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
f0103495:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f010349a:	ba 00 10 00 00       	mov    $0x1000,%edx
f010349f:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01034a2:	89 f2                	mov    %esi,%edx
f01034a4:	2b 93 30 23 00 00    	sub    0x2330(%ebx),%edx
f01034aa:	c1 fa 05             	sar    $0x5,%edx
f01034ad:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f01034b3:	09 d0                	or     %edx,%eax
f01034b5:	89 46 48             	mov    %eax,0x48(%esi)
	e->env_parent_id = parent_id;
f01034b8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01034bb:	89 46 4c             	mov    %eax,0x4c(%esi)
	e->env_type = ENV_TYPE_USER;
f01034be:	c7 46 50 00 00 00 00 	movl   $0x0,0x50(%esi)
	e->env_status = ENV_RUNNABLE;
f01034c5:	c7 46 54 02 00 00 00 	movl   $0x2,0x54(%esi)
	e->env_runs = 0;
f01034cc:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01034d3:	83 ec 04             	sub    $0x4,%esp
f01034d6:	6a 44                	push   $0x44
f01034d8:	6a 00                	push   $0x0
f01034da:	56                   	push   %esi
f01034db:	e8 a8 1c 00 00       	call   f0105188 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f01034e0:	66 c7 46 24 23 00    	movw   $0x23,0x24(%esi)
	e->env_tf.tf_es = GD_UD | 3;
f01034e6:	66 c7 46 20 23 00    	movw   $0x23,0x20(%esi)
	e->env_tf.tf_ss = GD_UD | 3;
f01034ec:	66 c7 46 40 23 00    	movw   $0x23,0x40(%esi)
	e->env_tf.tf_esp = USTACKTOP;
f01034f2:	c7 46 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%esi)
	e->env_tf.tf_cs = GD_UT | 3;
f01034f9:	66 c7 46 34 1b 00    	movw   $0x1b,0x34(%esi)
	env_free_list = e->env_link;
f01034ff:	8b 46 44             	mov    0x44(%esi),%eax
f0103502:	89 83 34 23 00 00    	mov    %eax,0x2334(%ebx)
	*newenv_store = e;
f0103508:	8b 45 08             	mov    0x8(%ebp),%eax
f010350b:	89 30                	mov    %esi,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010350d:	8b 4e 48             	mov    0x48(%esi),%ecx
f0103510:	8b 83 2c 23 00 00    	mov    0x232c(%ebx),%eax
f0103516:	83 c4 10             	add    $0x10,%esp
f0103519:	ba 00 00 00 00       	mov    $0x0,%edx
f010351e:	85 c0                	test   %eax,%eax
f0103520:	74 03                	je     f0103525 <env_alloc+0x136>
f0103522:	8b 50 48             	mov    0x48(%eax),%edx
f0103525:	83 ec 04             	sub    $0x4,%esp
f0103528:	51                   	push   %ecx
f0103529:	52                   	push   %edx
f010352a:	8d 83 11 96 f7 ff    	lea    -0x869ef(%ebx),%eax
f0103530:	50                   	push   %eax
f0103531:	e8 8e 05 00 00       	call   f0103ac4 <cprintf>
	return 0;
f0103536:	83 c4 10             	add    $0x10,%esp
f0103539:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010353e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103541:	5b                   	pop    %ebx
f0103542:	5e                   	pop    %esi
f0103543:	5d                   	pop    %ebp
f0103544:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103545:	52                   	push   %edx
f0103546:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f010354c:	50                   	push   %eax
f010354d:	6a 56                	push   $0x56
f010354f:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f0103555:	50                   	push   %eax
f0103556:	e8 5a cb ff ff       	call   f01000b5 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010355b:	50                   	push   %eax
f010355c:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f0103562:	50                   	push   %eax
f0103563:	68 c4 00 00 00       	push   $0xc4
f0103568:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f010356e:	50                   	push   %eax
f010356f:	e8 41 cb ff ff       	call   f01000b5 <_panic>
		return -E_NO_FREE_ENV;
f0103574:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103579:	eb c3                	jmp    f010353e <env_alloc+0x14f>
		return -E_NO_MEM;
f010357b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103580:	eb bc                	jmp    f010353e <env_alloc+0x14f>

f0103582 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103582:	f3 0f 1e fb          	endbr32 
f0103586:	55                   	push   %ebp
f0103587:	89 e5                	mov    %esp,%ebp
f0103589:	57                   	push   %edi
f010358a:	56                   	push   %esi
f010358b:	53                   	push   %ebx
f010358c:	83 ec 34             	sub    $0x34,%esp
f010358f:	e8 df cb ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0103594:	81 c3 88 9a 08 00    	add    $0x89a88,%ebx
	// LAB 3: Your code here.

	// Allocates a new env with env_alloc
	struct Env* env;
	int r;
	if(env_alloc(&env, 0)){
f010359a:	6a 00                	push   $0x0
f010359c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010359f:	50                   	push   %eax
f01035a0:	e8 4a fe ff ff       	call   f01033ef <env_alloc>
f01035a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01035a8:	83 c4 10             	add    $0x10,%esp
f01035ab:	85 c0                	test   %eax,%eax
f01035ad:	75 44                	jne    f01035f3 <env_create+0x71>
		panic("env_create failed: create env failed\n");
	}

	// loads the named elf binary into it with load_icode
	load_icode(env, binary);
f01035af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01035b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(header->e_magic != ELF_MAGIC)
f01035b5:	8b 45 08             	mov    0x8(%ebp),%eax
f01035b8:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
f01035be:	75 4e                	jne    f010360e <env_create+0x8c>
	if(header->e_entry == 0)
f01035c0:	8b 45 08             	mov    0x8(%ebp),%eax
f01035c3:	83 78 18 00          	cmpl   $0x0,0x18(%eax)
f01035c7:	74 60                	je     f0103629 <env_create+0xa7>
	struct Proghdr* ph = (struct Proghdr*)((uint8_t*)header + header->e_phoff);
f01035c9:	8b 45 08             	mov    0x8(%ebp),%eax
f01035cc:	8b 70 1c             	mov    0x1c(%eax),%esi
	int phnum = header->e_phnum;
f01035cf:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f01035d3:	89 45 cc             	mov    %eax,-0x34(%ebp)
	lcr3(PADDR(e->env_pgdir));
f01035d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01035d9:	8b 40 5c             	mov    0x5c(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01035dc:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035e1:	76 61                	jbe    f0103644 <env_create+0xc2>
	return (physaddr_t)kva - KERNBASE;
f01035e3:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01035e8:	0f 22 d8             	mov    %eax,%cr3
f01035eb:	03 75 08             	add    0x8(%ebp),%esi
	for(i = 0; i < phnum; i++){
f01035ee:	e9 a4 00 00 00       	jmp    f0103697 <env_create+0x115>
		panic("env_create failed: create env failed\n");
f01035f3:	83 ec 04             	sub    $0x4,%esp
f01035f6:	8d 83 48 96 f7 ff    	lea    -0x869b8(%ebx),%eax
f01035fc:	50                   	push   %eax
f01035fd:	68 b2 01 00 00       	push   $0x1b2
f0103602:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f0103608:	50                   	push   %eax
f0103609:	e8 a7 ca ff ff       	call   f01000b5 <_panic>
		panic("load_icode failed: the binary is not elf\n");
f010360e:	83 ec 04             	sub    $0x4,%esp
f0103611:	8d 83 70 96 f7 ff    	lea    -0x86990(%ebx),%eax
f0103617:	50                   	push   %eax
f0103618:	68 5e 01 00 00       	push   $0x15e
f010361d:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f0103623:	50                   	push   %eax
f0103624:	e8 8c ca ff ff       	call   f01000b5 <_panic>
		panic("load_icode failed: the elf can't be executed\n");
f0103629:	83 ec 04             	sub    $0x4,%esp
f010362c:	8d 83 9c 96 f7 ff    	lea    -0x86964(%ebx),%eax
f0103632:	50                   	push   %eax
f0103633:	68 60 01 00 00       	push   $0x160
f0103638:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f010363e:	50                   	push   %eax
f010363f:	e8 71 ca ff ff       	call   f01000b5 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103644:	50                   	push   %eax
f0103645:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f010364b:	50                   	push   %eax
f010364c:	68 72 01 00 00       	push   $0x172
f0103651:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f0103657:	50                   	push   %eax
f0103658:	e8 58 ca ff ff       	call   f01000b5 <_panic>
			region_alloc(e, (void*)ph[i].p_va, ph[i].p_memsz);
f010365d:	8b 56 08             	mov    0x8(%esi),%edx
f0103660:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103663:	e8 f0 fb ff ff       	call   f0103258 <region_alloc>
			memset((void*)ph[i].p_va, 0, ph[i].p_memsz);
f0103668:	83 ec 04             	sub    $0x4,%esp
f010366b:	ff 76 14             	pushl  0x14(%esi)
f010366e:	6a 00                	push   $0x0
f0103670:	ff 76 08             	pushl  0x8(%esi)
f0103673:	e8 10 1b 00 00       	call   f0105188 <memset>
			memcpy((void*)ph[i].p_va, binary + ph[i].p_offset, ph[i].p_filesz);
f0103678:	83 c4 0c             	add    $0xc,%esp
f010367b:	ff 76 10             	pushl  0x10(%esi)
f010367e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103681:	03 46 04             	add    0x4(%esi),%eax
f0103684:	50                   	push   %eax
f0103685:	ff 76 08             	pushl  0x8(%esi)
f0103688:	e8 ad 1b 00 00       	call   f010523a <memcpy>
f010368d:	83 c4 10             	add    $0x10,%esp
	for(i = 0; i < phnum; i++){
f0103690:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
f0103694:	83 c6 20             	add    $0x20,%esi
f0103697:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f010369a:	39 4d cc             	cmp    %ecx,-0x34(%ebp)
f010369d:	74 28                	je     f01036c7 <env_create+0x145>
		if(ph[i].p_type == ELF_PROG_LOAD){
f010369f:	83 3e 01             	cmpl   $0x1,(%esi)
f01036a2:	75 ec                	jne    f0103690 <env_create+0x10e>
			if(ph[i].p_memsz < ph[i].p_filesz){
f01036a4:	8b 4e 14             	mov    0x14(%esi),%ecx
f01036a7:	3b 4e 10             	cmp    0x10(%esi),%ecx
f01036aa:	73 b1                	jae    f010365d <env_create+0xdb>
				panic("load_icode failed: p_memsz < p_filesz.\n");
f01036ac:	83 ec 04             	sub    $0x4,%esp
f01036af:	8d 83 cc 96 f7 ff    	lea    -0x86934(%ebx),%eax
f01036b5:	50                   	push   %eax
f01036b6:	68 7c 01 00 00       	push   $0x17c
f01036bb:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f01036c1:	50                   	push   %eax
f01036c2:	e8 ee c9 ff ff       	call   f01000b5 <_panic>
	e->env_tf.tf_eip = header->e_entry;
f01036c7:	8b 45 08             	mov    0x8(%ebp),%eax
f01036ca:	8b 40 18             	mov    0x18(%eax),%eax
f01036cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01036d0:	89 42 30             	mov    %eax,0x30(%edx)
	lcr3(PADDR(kern_pgdir));
f01036d3:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f01036d9:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01036db:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01036e0:	76 2b                	jbe    f010370d <env_create+0x18b>
	return (physaddr_t)kva - KERNBASE;
f01036e2:	05 00 00 00 10       	add    $0x10000000,%eax
f01036e7:	0f 22 d8             	mov    %eax,%cr3
	region_alloc(e, (void*)(USTACKTOP - PGSIZE), PGSIZE);
f01036ea:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01036ef:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f01036f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01036f7:	e8 5c fb ff ff       	call   f0103258 <region_alloc>

	// sets its env_type.
	env->env_type = type;
f01036fc:	8b 55 0c             	mov    0xc(%ebp),%edx
f01036ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103702:	89 50 50             	mov    %edx,0x50(%eax)
}
f0103705:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103708:	5b                   	pop    %ebx
f0103709:	5e                   	pop    %esi
f010370a:	5f                   	pop    %edi
f010370b:	5d                   	pop    %ebp
f010370c:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010370d:	50                   	push   %eax
f010370e:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f0103714:	50                   	push   %eax
f0103715:	68 98 01 00 00       	push   $0x198
f010371a:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f0103720:	50                   	push   %eax
f0103721:	e8 8f c9 ff ff       	call   f01000b5 <_panic>

f0103726 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103726:	f3 0f 1e fb          	endbr32 
f010372a:	55                   	push   %ebp
f010372b:	89 e5                	mov    %esp,%ebp
f010372d:	57                   	push   %edi
f010372e:	56                   	push   %esi
f010372f:	53                   	push   %ebx
f0103730:	83 ec 2c             	sub    $0x2c,%esp
f0103733:	e8 3b ca ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0103738:	81 c3 e4 98 08 00    	add    $0x898e4,%ebx
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f010373e:	8b 93 2c 23 00 00    	mov    0x232c(%ebx),%edx
f0103744:	3b 55 08             	cmp    0x8(%ebp),%edx
f0103747:	74 47                	je     f0103790 <env_free+0x6a>
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103749:	8b 45 08             	mov    0x8(%ebp),%eax
f010374c:	8b 48 48             	mov    0x48(%eax),%ecx
f010374f:	b8 00 00 00 00       	mov    $0x0,%eax
f0103754:	85 d2                	test   %edx,%edx
f0103756:	74 03                	je     f010375b <env_free+0x35>
f0103758:	8b 42 48             	mov    0x48(%edx),%eax
f010375b:	83 ec 04             	sub    $0x4,%esp
f010375e:	51                   	push   %ecx
f010375f:	50                   	push   %eax
f0103760:	8d 83 26 96 f7 ff    	lea    -0x869da(%ebx),%eax
f0103766:	50                   	push   %eax
f0103767:	e8 58 03 00 00       	call   f0103ac4 <cprintf>
f010376c:	83 c4 10             	add    $0x10,%esp
f010376f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	if (PGNUM(pa) >= npages)
f0103776:	c7 c0 04 00 19 f0    	mov    $0xf0190004,%eax
f010377c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (PGNUM(pa) >= npages)
f010377f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	return &pages[PGNUM(pa)];
f0103782:	c7 c0 0c 00 19 f0    	mov    $0xf019000c,%eax
f0103788:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010378b:	e9 bf 00 00 00       	jmp    f010384f <env_free+0x129>
		lcr3(PADDR(kern_pgdir));
f0103790:	c7 c0 08 00 19 f0    	mov    $0xf0190008,%eax
f0103796:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103798:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010379d:	76 10                	jbe    f01037af <env_free+0x89>
	return (physaddr_t)kva - KERNBASE;
f010379f:	05 00 00 00 10       	add    $0x10000000,%eax
f01037a4:	0f 22 d8             	mov    %eax,%cr3
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01037a7:	8b 45 08             	mov    0x8(%ebp),%eax
f01037aa:	8b 48 48             	mov    0x48(%eax),%ecx
f01037ad:	eb a9                	jmp    f0103758 <env_free+0x32>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01037af:	50                   	push   %eax
f01037b0:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f01037b6:	50                   	push   %eax
f01037b7:	68 ca 01 00 00       	push   $0x1ca
f01037bc:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f01037c2:	50                   	push   %eax
f01037c3:	e8 ed c8 ff ff       	call   f01000b5 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01037c8:	57                   	push   %edi
f01037c9:	8d 83 ac 8d f7 ff    	lea    -0x87254(%ebx),%eax
f01037cf:	50                   	push   %eax
f01037d0:	68 d9 01 00 00       	push   $0x1d9
f01037d5:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f01037db:	50                   	push   %eax
f01037dc:	e8 d4 c8 ff ff       	call   f01000b5 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01037e1:	83 ec 08             	sub    $0x8,%esp
f01037e4:	89 f0                	mov    %esi,%eax
f01037e6:	c1 e0 0c             	shl    $0xc,%eax
f01037e9:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01037ec:	50                   	push   %eax
f01037ed:	8b 45 08             	mov    0x8(%ebp),%eax
f01037f0:	ff 70 5c             	pushl  0x5c(%eax)
f01037f3:	e8 cf db ff ff       	call   f01013c7 <page_remove>
f01037f8:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01037fb:	83 c6 01             	add    $0x1,%esi
f01037fe:	83 c7 04             	add    $0x4,%edi
f0103801:	81 fe 00 04 00 00    	cmp    $0x400,%esi
f0103807:	74 07                	je     f0103810 <env_free+0xea>
			if (pt[pteno] & PTE_P)
f0103809:	f6 07 01             	testb  $0x1,(%edi)
f010380c:	74 ed                	je     f01037fb <env_free+0xd5>
f010380e:	eb d1                	jmp    f01037e1 <env_free+0xbb>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103810:	8b 45 08             	mov    0x8(%ebp),%eax
f0103813:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103816:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103819:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103820:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103823:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103826:	3b 10                	cmp    (%eax),%edx
f0103828:	73 67                	jae    f0103891 <env_free+0x16b>
		page_decref(pa2page(pa));
f010382a:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010382d:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0103830:	8b 00                	mov    (%eax),%eax
f0103832:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103835:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103838:	50                   	push   %eax
f0103839:	e8 83 d9 ff ff       	call   f01011c1 <page_decref>
f010383e:	83 c4 10             	add    $0x10,%esp
f0103841:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103845:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103848:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f010384d:	74 5a                	je     f01038a9 <env_free+0x183>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f010384f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103852:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103855:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103858:	8b 04 10             	mov    (%eax,%edx,1),%eax
f010385b:	a8 01                	test   $0x1,%al
f010385d:	74 e2                	je     f0103841 <env_free+0x11b>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f010385f:	89 c7                	mov    %eax,%edi
f0103861:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	if (PGNUM(pa) >= npages)
f0103867:	c1 e8 0c             	shr    $0xc,%eax
f010386a:	89 45 dc             	mov    %eax,-0x24(%ebp)
f010386d:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103870:	39 02                	cmp    %eax,(%edx)
f0103872:	0f 86 50 ff ff ff    	jbe    f01037c8 <env_free+0xa2>
	return (void *)(pa + KERNBASE);
f0103878:	81 ef 00 00 00 10    	sub    $0x10000000,%edi
f010387e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103881:	c1 e0 14             	shl    $0x14,%eax
f0103884:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103887:	be 00 00 00 00       	mov    $0x0,%esi
f010388c:	e9 78 ff ff ff       	jmp    f0103809 <env_free+0xe3>
		panic("pa2page called with invalid pa");
f0103891:	83 ec 04             	sub    $0x4,%esp
f0103894:	8d 83 40 8f f7 ff    	lea    -0x870c0(%ebx),%eax
f010389a:	50                   	push   %eax
f010389b:	6a 4f                	push   $0x4f
f010389d:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f01038a3:	50                   	push   %eax
f01038a4:	e8 0c c8 ff ff       	call   f01000b5 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01038a9:	8b 45 08             	mov    0x8(%ebp),%eax
f01038ac:	8b 40 5c             	mov    0x5c(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01038af:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01038b4:	76 57                	jbe    f010390d <env_free+0x1e7>
	e->env_pgdir = 0;
f01038b6:	8b 55 08             	mov    0x8(%ebp),%edx
f01038b9:	c7 42 5c 00 00 00 00 	movl   $0x0,0x5c(%edx)
	return (physaddr_t)kva - KERNBASE;
f01038c0:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01038c5:	c1 e8 0c             	shr    $0xc,%eax
f01038c8:	c7 c2 04 00 19 f0    	mov    $0xf0190004,%edx
f01038ce:	3b 02                	cmp    (%edx),%eax
f01038d0:	73 54                	jae    f0103926 <env_free+0x200>
	page_decref(pa2page(pa));
f01038d2:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01038d5:	c7 c2 0c 00 19 f0    	mov    $0xf019000c,%edx
f01038db:	8b 12                	mov    (%edx),%edx
f01038dd:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01038e0:	50                   	push   %eax
f01038e1:	e8 db d8 ff ff       	call   f01011c1 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01038e6:	8b 45 08             	mov    0x8(%ebp),%eax
f01038e9:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	e->env_link = env_free_list;
f01038f0:	8b 83 34 23 00 00    	mov    0x2334(%ebx),%eax
f01038f6:	8b 55 08             	mov    0x8(%ebp),%edx
f01038f9:	89 42 44             	mov    %eax,0x44(%edx)
	env_free_list = e;
f01038fc:	89 93 34 23 00 00    	mov    %edx,0x2334(%ebx)
}
f0103902:	83 c4 10             	add    $0x10,%esp
f0103905:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103908:	5b                   	pop    %ebx
f0103909:	5e                   	pop    %esi
f010390a:	5f                   	pop    %edi
f010390b:	5d                   	pop    %ebp
f010390c:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010390d:	50                   	push   %eax
f010390e:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f0103914:	50                   	push   %eax
f0103915:	68 e7 01 00 00       	push   $0x1e7
f010391a:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f0103920:	50                   	push   %eax
f0103921:	e8 8f c7 ff ff       	call   f01000b5 <_panic>
		panic("pa2page called with invalid pa");
f0103926:	83 ec 04             	sub    $0x4,%esp
f0103929:	8d 83 40 8f f7 ff    	lea    -0x870c0(%ebx),%eax
f010392f:	50                   	push   %eax
f0103930:	6a 4f                	push   $0x4f
f0103932:	8d 83 d3 8a f7 ff    	lea    -0x8752d(%ebx),%eax
f0103938:	50                   	push   %eax
f0103939:	e8 77 c7 ff ff       	call   f01000b5 <_panic>

f010393e <env_destroy>:
//
// Frees environment e.
//
void
env_destroy(struct Env *e)
{
f010393e:	f3 0f 1e fb          	endbr32 
f0103942:	55                   	push   %ebp
f0103943:	89 e5                	mov    %esp,%ebp
f0103945:	53                   	push   %ebx
f0103946:	83 ec 10             	sub    $0x10,%esp
f0103949:	e8 25 c8 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f010394e:	81 c3 ce 96 08 00    	add    $0x896ce,%ebx
	env_free(e);
f0103954:	ff 75 08             	pushl  0x8(%ebp)
f0103957:	e8 ca fd ff ff       	call   f0103726 <env_free>

	cprintf("Destroyed the only environment - nothing more to do!\n");
f010395c:	8d 83 f4 96 f7 ff    	lea    -0x8690c(%ebx),%eax
f0103962:	89 04 24             	mov    %eax,(%esp)
f0103965:	e8 5a 01 00 00       	call   f0103ac4 <cprintf>
f010396a:	83 c4 10             	add    $0x10,%esp
	while (1)
		monitor(NULL);
f010396d:	83 ec 0c             	sub    $0xc,%esp
f0103970:	6a 00                	push   $0x0
f0103972:	e8 cd cf ff ff       	call   f0100944 <monitor>
f0103977:	83 c4 10             	add    $0x10,%esp
f010397a:	eb f1                	jmp    f010396d <env_destroy+0x2f>

f010397c <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f010397c:	f3 0f 1e fb          	endbr32 
f0103980:	55                   	push   %ebp
f0103981:	89 e5                	mov    %esp,%ebp
f0103983:	53                   	push   %ebx
f0103984:	83 ec 08             	sub    $0x8,%esp
f0103987:	e8 e7 c7 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f010398c:	81 c3 90 96 08 00    	add    $0x89690,%ebx
	asm volatile(
f0103992:	8b 65 08             	mov    0x8(%ebp),%esp
f0103995:	61                   	popa   
f0103996:	07                   	pop    %es
f0103997:	1f                   	pop    %ds
f0103998:	83 c4 08             	add    $0x8,%esp
f010399b:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f010399c:	8d 83 3c 96 f7 ff    	lea    -0x869c4(%ebx),%eax
f01039a2:	50                   	push   %eax
f01039a3:	68 10 02 00 00       	push   $0x210
f01039a8:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f01039ae:	50                   	push   %eax
f01039af:	e8 01 c7 ff ff       	call   f01000b5 <_panic>

f01039b4 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01039b4:	f3 0f 1e fb          	endbr32 
f01039b8:	55                   	push   %ebp
f01039b9:	89 e5                	mov    %esp,%ebp
f01039bb:	53                   	push   %ebx
f01039bc:	83 ec 04             	sub    $0x4,%esp
f01039bf:	e8 af c7 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f01039c4:	81 c3 58 96 08 00    	add    $0x89658,%ebx
f01039ca:	8b 45 08             	mov    0x8(%ebp),%eax
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != NULL && curenv->env_status == ENV_RUNNING){
f01039cd:	8b 93 2c 23 00 00    	mov    0x232c(%ebx),%edx
f01039d3:	85 d2                	test   %edx,%edx
f01039d5:	74 06                	je     f01039dd <env_run+0x29>
f01039d7:	83 7a 54 03          	cmpl   $0x3,0x54(%edx)
f01039db:	74 2e                	je     f0103a0b <env_run+0x57>
		//但是查看了好多人的实现都没有
		//暂时存疑
		//curenv->env_runs--;
	}

	curenv = e;
f01039dd:	89 83 2c 23 00 00    	mov    %eax,0x232c(%ebx)
	e->env_status = ENV_RUNNING;
f01039e3:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
	e->env_runs++;
f01039ea:	83 40 58 01          	addl   $0x1,0x58(%eax)
	lcr3(PADDR(e->env_pgdir));
f01039ee:	8b 50 5c             	mov    0x5c(%eax),%edx
	if ((uint32_t)kva < KERNBASE)
f01039f1:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01039f7:	76 1b                	jbe    f0103a14 <env_run+0x60>
	return (physaddr_t)kva - KERNBASE;
f01039f9:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f01039ff:	0f 22 da             	mov    %edx,%cr3
	env_pop_tf(&e->env_tf);
f0103a02:	83 ec 0c             	sub    $0xc,%esp
f0103a05:	50                   	push   %eax
f0103a06:	e8 71 ff ff ff       	call   f010397c <env_pop_tf>
		curenv->env_status = ENV_RUNNABLE;
f0103a0b:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
f0103a12:	eb c9                	jmp    f01039dd <env_run+0x29>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103a14:	52                   	push   %edx
f0103a15:	8d 83 b8 8e f7 ff    	lea    -0x87148(%ebx),%eax
f0103a1b:	50                   	push   %eax
f0103a1c:	68 39 02 00 00       	push   $0x239
f0103a21:	8d 83 06 96 f7 ff    	lea    -0x869fa(%ebx),%eax
f0103a27:	50                   	push   %eax
f0103a28:	e8 88 c6 ff ff       	call   f01000b5 <_panic>

f0103a2d <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103a2d:	f3 0f 1e fb          	endbr32 
f0103a31:	55                   	push   %ebp
f0103a32:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103a34:	8b 45 08             	mov    0x8(%ebp),%eax
f0103a37:	ba 70 00 00 00       	mov    $0x70,%edx
f0103a3c:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103a3d:	ba 71 00 00 00       	mov    $0x71,%edx
f0103a42:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103a43:	0f b6 c0             	movzbl %al,%eax
}
f0103a46:	5d                   	pop    %ebp
f0103a47:	c3                   	ret    

f0103a48 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103a48:	f3 0f 1e fb          	endbr32 
f0103a4c:	55                   	push   %ebp
f0103a4d:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103a4f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103a52:	ba 70 00 00 00       	mov    $0x70,%edx
f0103a57:	ee                   	out    %al,(%dx)
f0103a58:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103a5b:	ba 71 00 00 00       	mov    $0x71,%edx
f0103a60:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103a61:	5d                   	pop    %ebp
f0103a62:	c3                   	ret    

f0103a63 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103a63:	f3 0f 1e fb          	endbr32 
f0103a67:	55                   	push   %ebp
f0103a68:	89 e5                	mov    %esp,%ebp
f0103a6a:	53                   	push   %ebx
f0103a6b:	83 ec 10             	sub    $0x10,%esp
f0103a6e:	e8 00 c7 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0103a73:	81 c3 a9 95 08 00    	add    $0x895a9,%ebx
	cputchar(ch);
f0103a79:	ff 75 08             	pushl  0x8(%ebp)
f0103a7c:	e8 73 cc ff ff       	call   f01006f4 <cputchar>
	*cnt++;
}
f0103a81:	83 c4 10             	add    $0x10,%esp
f0103a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103a87:	c9                   	leave  
f0103a88:	c3                   	ret    

f0103a89 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103a89:	f3 0f 1e fb          	endbr32 
f0103a8d:	55                   	push   %ebp
f0103a8e:	89 e5                	mov    %esp,%ebp
f0103a90:	53                   	push   %ebx
f0103a91:	83 ec 14             	sub    $0x14,%esp
f0103a94:	e8 da c6 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0103a99:	81 c3 83 95 08 00    	add    $0x89583,%ebx
	int cnt = 0;
f0103a9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103aa6:	ff 75 0c             	pushl  0xc(%ebp)
f0103aa9:	ff 75 08             	pushl  0x8(%ebp)
f0103aac:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103aaf:	50                   	push   %eax
f0103ab0:	8d 83 47 6a f7 ff    	lea    -0x895b9(%ebx),%eax
f0103ab6:	50                   	push   %eax
f0103ab7:	e8 e0 0e 00 00       	call   f010499c <vprintfmt>
	return cnt;
}
f0103abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103abf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103ac2:	c9                   	leave  
f0103ac3:	c3                   	ret    

f0103ac4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103ac4:	f3 0f 1e fb          	endbr32 
f0103ac8:	55                   	push   %ebp
f0103ac9:	89 e5                	mov    %esp,%ebp
f0103acb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103ace:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103ad1:	50                   	push   %eax
f0103ad2:	ff 75 08             	pushl  0x8(%ebp)
f0103ad5:	e8 af ff ff ff       	call   f0103a89 <vcprintf>
	va_end(ap);

	return cnt;
}
f0103ada:	c9                   	leave  
f0103adb:	c3                   	ret    

f0103adc <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103adc:	f3 0f 1e fb          	endbr32 
f0103ae0:	55                   	push   %ebp
f0103ae1:	89 e5                	mov    %esp,%ebp
f0103ae3:	57                   	push   %edi
f0103ae4:	56                   	push   %esi
f0103ae5:	53                   	push   %ebx
f0103ae6:	83 ec 04             	sub    $0x4,%esp
f0103ae9:	e8 85 c6 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0103aee:	81 c3 2e 95 08 00    	add    $0x8952e,%ebx
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
f0103af4:	c7 83 68 2b 00 00 00 	movl   $0xf0000000,0x2b68(%ebx)
f0103afb:	00 00 f0 
	ts.ts_ss0 = GD_KD;
f0103afe:	66 c7 83 6c 2b 00 00 	movw   $0x10,0x2b6c(%ebx)
f0103b05:	10 00 
	ts.ts_iomb = sizeof(struct Taskstate);
f0103b07:	66 c7 83 ca 2b 00 00 	movw   $0x68,0x2bca(%ebx)
f0103b0e:	68 00 

	// Initialize the TSS slot of the gdt.
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
f0103b10:	c7 c0 00 c3 11 f0    	mov    $0xf011c300,%eax
f0103b16:	66 c7 40 28 67 00    	movw   $0x67,0x28(%eax)
f0103b1c:	8d b3 64 2b 00 00    	lea    0x2b64(%ebx),%esi
f0103b22:	66 89 70 2a          	mov    %si,0x2a(%eax)
f0103b26:	89 f2                	mov    %esi,%edx
f0103b28:	c1 ea 10             	shr    $0x10,%edx
f0103b2b:	88 50 2c             	mov    %dl,0x2c(%eax)
f0103b2e:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
f0103b32:	83 e2 f0             	and    $0xfffffff0,%edx
f0103b35:	83 ca 09             	or     $0x9,%edx
f0103b38:	83 e2 9f             	and    $0xffffff9f,%edx
f0103b3b:	83 ca 80             	or     $0xffffff80,%edx
f0103b3e:	88 55 f3             	mov    %dl,-0xd(%ebp)
f0103b41:	88 50 2d             	mov    %dl,0x2d(%eax)
f0103b44:	0f b6 48 2e          	movzbl 0x2e(%eax),%ecx
f0103b48:	83 e1 c0             	and    $0xffffffc0,%ecx
f0103b4b:	83 c9 40             	or     $0x40,%ecx
f0103b4e:	83 e1 7f             	and    $0x7f,%ecx
f0103b51:	88 48 2e             	mov    %cl,0x2e(%eax)
f0103b54:	c1 ee 18             	shr    $0x18,%esi
f0103b57:	89 f1                	mov    %esi,%ecx
f0103b59:	88 48 2f             	mov    %cl,0x2f(%eax)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;
f0103b5c:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
f0103b60:	83 e2 ef             	and    $0xffffffef,%edx
f0103b63:	88 50 2d             	mov    %dl,0x2d(%eax)
	asm volatile("ltr %0" : : "r" (sel));
f0103b66:	b8 28 00 00 00       	mov    $0x28,%eax
f0103b6b:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
f0103b6e:	8d 83 ec 1f 00 00    	lea    0x1fec(%ebx),%eax
f0103b74:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0);

	// Load the IDT
	lidt(&idt_pd);
}
f0103b77:	83 c4 04             	add    $0x4,%esp
f0103b7a:	5b                   	pop    %ebx
f0103b7b:	5e                   	pop    %esi
f0103b7c:	5f                   	pop    %edi
f0103b7d:	5d                   	pop    %ebp
f0103b7e:	c3                   	ret    

f0103b7f <trap_init>:
{
f0103b7f:	f3 0f 1e fb          	endbr32 
f0103b83:	55                   	push   %ebp
f0103b84:	89 e5                	mov    %esp,%ebp
f0103b86:	e8 9c cb ff ff       	call   f0100727 <__x86.get_pc_thunk.ax>
f0103b8b:	05 91 94 08 00       	add    $0x89491,%eax
	SETGATE(idt[T_DIVIDE], 0, GD_KT, divide_handler, 0);
f0103b90:	c7 c2 44 43 10 f0    	mov    $0xf0104344,%edx
f0103b96:	66 89 90 44 23 00 00 	mov    %dx,0x2344(%eax)
f0103b9d:	66 c7 80 46 23 00 00 	movw   $0x8,0x2346(%eax)
f0103ba4:	08 00 
f0103ba6:	c6 80 48 23 00 00 00 	movb   $0x0,0x2348(%eax)
f0103bad:	c6 80 49 23 00 00 8e 	movb   $0x8e,0x2349(%eax)
f0103bb4:	c1 ea 10             	shr    $0x10,%edx
f0103bb7:	66 89 90 4a 23 00 00 	mov    %dx,0x234a(%eax)
	SETGATE(idt[T_DEBUG], 0, GD_KT, debug_handler, 0);
f0103bbe:	c7 c2 4a 43 10 f0    	mov    $0xf010434a,%edx
f0103bc4:	66 89 90 4c 23 00 00 	mov    %dx,0x234c(%eax)
f0103bcb:	66 c7 80 4e 23 00 00 	movw   $0x8,0x234e(%eax)
f0103bd2:	08 00 
f0103bd4:	c6 80 50 23 00 00 00 	movb   $0x0,0x2350(%eax)
f0103bdb:	c6 80 51 23 00 00 8e 	movb   $0x8e,0x2351(%eax)
f0103be2:	c1 ea 10             	shr    $0x10,%edx
f0103be5:	66 89 90 52 23 00 00 	mov    %dx,0x2352(%eax)
	SETGATE(idt[T_NMI], 0, GD_KT, nmi_handler, 0);
f0103bec:	c7 c2 50 43 10 f0    	mov    $0xf0104350,%edx
f0103bf2:	66 89 90 54 23 00 00 	mov    %dx,0x2354(%eax)
f0103bf9:	66 c7 80 56 23 00 00 	movw   $0x8,0x2356(%eax)
f0103c00:	08 00 
f0103c02:	c6 80 58 23 00 00 00 	movb   $0x0,0x2358(%eax)
f0103c09:	c6 80 59 23 00 00 8e 	movb   $0x8e,0x2359(%eax)
f0103c10:	c1 ea 10             	shr    $0x10,%edx
f0103c13:	66 89 90 5a 23 00 00 	mov    %dx,0x235a(%eax)
	SETGATE(idt[T_BRKPT], 0, GD_KT, brkpt_handler, 3);
f0103c1a:	c7 c2 56 43 10 f0    	mov    $0xf0104356,%edx
f0103c20:	66 89 90 5c 23 00 00 	mov    %dx,0x235c(%eax)
f0103c27:	66 c7 80 5e 23 00 00 	movw   $0x8,0x235e(%eax)
f0103c2e:	08 00 
f0103c30:	c6 80 60 23 00 00 00 	movb   $0x0,0x2360(%eax)
f0103c37:	c6 80 61 23 00 00 ee 	movb   $0xee,0x2361(%eax)
f0103c3e:	c1 ea 10             	shr    $0x10,%edx
f0103c41:	66 89 90 62 23 00 00 	mov    %dx,0x2362(%eax)
	SETGATE(idt[T_OFLOW], 0, GD_KT, oflow_handler, 0);
f0103c48:	c7 c2 5c 43 10 f0    	mov    $0xf010435c,%edx
f0103c4e:	66 89 90 64 23 00 00 	mov    %dx,0x2364(%eax)
f0103c55:	66 c7 80 66 23 00 00 	movw   $0x8,0x2366(%eax)
f0103c5c:	08 00 
f0103c5e:	c6 80 68 23 00 00 00 	movb   $0x0,0x2368(%eax)
f0103c65:	c6 80 69 23 00 00 8e 	movb   $0x8e,0x2369(%eax)
f0103c6c:	c1 ea 10             	shr    $0x10,%edx
f0103c6f:	66 89 90 6a 23 00 00 	mov    %dx,0x236a(%eax)
	SETGATE(idt[T_BOUND], 0, GD_KT, bound_handler, 0);
f0103c76:	c7 c2 62 43 10 f0    	mov    $0xf0104362,%edx
f0103c7c:	66 89 90 6c 23 00 00 	mov    %dx,0x236c(%eax)
f0103c83:	66 c7 80 6e 23 00 00 	movw   $0x8,0x236e(%eax)
f0103c8a:	08 00 
f0103c8c:	c6 80 70 23 00 00 00 	movb   $0x0,0x2370(%eax)
f0103c93:	c6 80 71 23 00 00 8e 	movb   $0x8e,0x2371(%eax)
f0103c9a:	c1 ea 10             	shr    $0x10,%edx
f0103c9d:	66 89 90 72 23 00 00 	mov    %dx,0x2372(%eax)
	SETGATE(idt[T_ILLOP], 0, GD_KT, illop_handler, 0);
f0103ca4:	c7 c2 68 43 10 f0    	mov    $0xf0104368,%edx
f0103caa:	66 89 90 74 23 00 00 	mov    %dx,0x2374(%eax)
f0103cb1:	66 c7 80 76 23 00 00 	movw   $0x8,0x2376(%eax)
f0103cb8:	08 00 
f0103cba:	c6 80 78 23 00 00 00 	movb   $0x0,0x2378(%eax)
f0103cc1:	c6 80 79 23 00 00 8e 	movb   $0x8e,0x2379(%eax)
f0103cc8:	c1 ea 10             	shr    $0x10,%edx
f0103ccb:	66 89 90 7a 23 00 00 	mov    %dx,0x237a(%eax)
	SETGATE(idt[T_DEVICE], 0, GD_KT, device_handler, 0);
f0103cd2:	c7 c2 6e 43 10 f0    	mov    $0xf010436e,%edx
f0103cd8:	66 89 90 7c 23 00 00 	mov    %dx,0x237c(%eax)
f0103cdf:	66 c7 80 7e 23 00 00 	movw   $0x8,0x237e(%eax)
f0103ce6:	08 00 
f0103ce8:	c6 80 80 23 00 00 00 	movb   $0x0,0x2380(%eax)
f0103cef:	c6 80 81 23 00 00 8e 	movb   $0x8e,0x2381(%eax)
f0103cf6:	c1 ea 10             	shr    $0x10,%edx
f0103cf9:	66 89 90 82 23 00 00 	mov    %dx,0x2382(%eax)
	SETGATE(idt[T_DBLFLT], 0, GD_KT, dblflt_handler, 0);
f0103d00:	c7 c2 74 43 10 f0    	mov    $0xf0104374,%edx
f0103d06:	66 89 90 84 23 00 00 	mov    %dx,0x2384(%eax)
f0103d0d:	66 c7 80 86 23 00 00 	movw   $0x8,0x2386(%eax)
f0103d14:	08 00 
f0103d16:	c6 80 88 23 00 00 00 	movb   $0x0,0x2388(%eax)
f0103d1d:	c6 80 89 23 00 00 8e 	movb   $0x8e,0x2389(%eax)
f0103d24:	c1 ea 10             	shr    $0x10,%edx
f0103d27:	66 89 90 8a 23 00 00 	mov    %dx,0x238a(%eax)
	SETGATE(idt[T_TSS], 0, GD_KT, tss_handler, 0);
f0103d2e:	c7 c2 78 43 10 f0    	mov    $0xf0104378,%edx
f0103d34:	66 89 90 94 23 00 00 	mov    %dx,0x2394(%eax)
f0103d3b:	66 c7 80 96 23 00 00 	movw   $0x8,0x2396(%eax)
f0103d42:	08 00 
f0103d44:	c6 80 98 23 00 00 00 	movb   $0x0,0x2398(%eax)
f0103d4b:	c6 80 99 23 00 00 8e 	movb   $0x8e,0x2399(%eax)
f0103d52:	c1 ea 10             	shr    $0x10,%edx
f0103d55:	66 89 90 9a 23 00 00 	mov    %dx,0x239a(%eax)
	SETGATE(idt[T_SEGNP], 0, GD_KT, segnp_handler, 0);
f0103d5c:	c7 c2 7c 43 10 f0    	mov    $0xf010437c,%edx
f0103d62:	66 89 90 9c 23 00 00 	mov    %dx,0x239c(%eax)
f0103d69:	66 c7 80 9e 23 00 00 	movw   $0x8,0x239e(%eax)
f0103d70:	08 00 
f0103d72:	c6 80 a0 23 00 00 00 	movb   $0x0,0x23a0(%eax)
f0103d79:	c6 80 a1 23 00 00 8e 	movb   $0x8e,0x23a1(%eax)
f0103d80:	c1 ea 10             	shr    $0x10,%edx
f0103d83:	66 89 90 a2 23 00 00 	mov    %dx,0x23a2(%eax)
	SETGATE(idt[T_STACK], 0, GD_KT, stack_handler, 0);
f0103d8a:	c7 c2 80 43 10 f0    	mov    $0xf0104380,%edx
f0103d90:	66 89 90 a4 23 00 00 	mov    %dx,0x23a4(%eax)
f0103d97:	66 c7 80 a6 23 00 00 	movw   $0x8,0x23a6(%eax)
f0103d9e:	08 00 
f0103da0:	c6 80 a8 23 00 00 00 	movb   $0x0,0x23a8(%eax)
f0103da7:	c6 80 a9 23 00 00 8e 	movb   $0x8e,0x23a9(%eax)
f0103dae:	c1 ea 10             	shr    $0x10,%edx
f0103db1:	66 89 90 aa 23 00 00 	mov    %dx,0x23aa(%eax)
	SETGATE(idt[T_GPFLT], 0, GD_KT, gpflt_handler, 0);
f0103db8:	c7 c2 84 43 10 f0    	mov    $0xf0104384,%edx
f0103dbe:	66 89 90 ac 23 00 00 	mov    %dx,0x23ac(%eax)
f0103dc5:	66 c7 80 ae 23 00 00 	movw   $0x8,0x23ae(%eax)
f0103dcc:	08 00 
f0103dce:	c6 80 b0 23 00 00 00 	movb   $0x0,0x23b0(%eax)
f0103dd5:	c6 80 b1 23 00 00 8e 	movb   $0x8e,0x23b1(%eax)
f0103ddc:	c1 ea 10             	shr    $0x10,%edx
f0103ddf:	66 89 90 b2 23 00 00 	mov    %dx,0x23b2(%eax)
	SETGATE(idt[T_PGFLT], 0, GD_KT, pgflt_handler, 0);
f0103de6:	c7 c2 88 43 10 f0    	mov    $0xf0104388,%edx
f0103dec:	66 89 90 b4 23 00 00 	mov    %dx,0x23b4(%eax)
f0103df3:	66 c7 80 b6 23 00 00 	movw   $0x8,0x23b6(%eax)
f0103dfa:	08 00 
f0103dfc:	c6 80 b8 23 00 00 00 	movb   $0x0,0x23b8(%eax)
f0103e03:	c6 80 b9 23 00 00 8e 	movb   $0x8e,0x23b9(%eax)
f0103e0a:	c1 ea 10             	shr    $0x10,%edx
f0103e0d:	66 89 90 ba 23 00 00 	mov    %dx,0x23ba(%eax)
	SETGATE(idt[T_FPERR], 0, GD_KT, fperr_handler, 0);
f0103e14:	c7 c2 8c 43 10 f0    	mov    $0xf010438c,%edx
f0103e1a:	66 89 90 c4 23 00 00 	mov    %dx,0x23c4(%eax)
f0103e21:	66 c7 80 c6 23 00 00 	movw   $0x8,0x23c6(%eax)
f0103e28:	08 00 
f0103e2a:	c6 80 c8 23 00 00 00 	movb   $0x0,0x23c8(%eax)
f0103e31:	c6 80 c9 23 00 00 8e 	movb   $0x8e,0x23c9(%eax)
f0103e38:	c1 ea 10             	shr    $0x10,%edx
f0103e3b:	66 89 90 ca 23 00 00 	mov    %dx,0x23ca(%eax)
	SETGATE(idt[T_ALIGN], 0, GD_KT, align_handler, 0);
f0103e42:	c7 c2 92 43 10 f0    	mov    $0xf0104392,%edx
f0103e48:	66 89 90 cc 23 00 00 	mov    %dx,0x23cc(%eax)
f0103e4f:	66 c7 80 ce 23 00 00 	movw   $0x8,0x23ce(%eax)
f0103e56:	08 00 
f0103e58:	c6 80 d0 23 00 00 00 	movb   $0x0,0x23d0(%eax)
f0103e5f:	c6 80 d1 23 00 00 8e 	movb   $0x8e,0x23d1(%eax)
f0103e66:	c1 ea 10             	shr    $0x10,%edx
f0103e69:	66 89 90 d2 23 00 00 	mov    %dx,0x23d2(%eax)
	SETGATE(idt[T_MCHK], 0, GD_KT, mchk_handler, 0);
f0103e70:	c7 c2 96 43 10 f0    	mov    $0xf0104396,%edx
f0103e76:	66 89 90 d4 23 00 00 	mov    %dx,0x23d4(%eax)
f0103e7d:	66 c7 80 d6 23 00 00 	movw   $0x8,0x23d6(%eax)
f0103e84:	08 00 
f0103e86:	c6 80 d8 23 00 00 00 	movb   $0x0,0x23d8(%eax)
f0103e8d:	c6 80 d9 23 00 00 8e 	movb   $0x8e,0x23d9(%eax)
f0103e94:	c1 ea 10             	shr    $0x10,%edx
f0103e97:	66 89 90 da 23 00 00 	mov    %dx,0x23da(%eax)
	SETGATE(idt[T_SIMDERR], 0, GD_KT, simderr_handler, 0);
f0103e9e:	c7 c2 9c 43 10 f0    	mov    $0xf010439c,%edx
f0103ea4:	66 89 90 dc 23 00 00 	mov    %dx,0x23dc(%eax)
f0103eab:	66 c7 80 de 23 00 00 	movw   $0x8,0x23de(%eax)
f0103eb2:	08 00 
f0103eb4:	c6 80 e0 23 00 00 00 	movb   $0x0,0x23e0(%eax)
f0103ebb:	c6 80 e1 23 00 00 8e 	movb   $0x8e,0x23e1(%eax)
f0103ec2:	c1 ea 10             	shr    $0x10,%edx
f0103ec5:	66 89 90 e2 23 00 00 	mov    %dx,0x23e2(%eax)
	SETGATE(idt[T_SYSCALL], 0, GD_KT, syscall_handler, 3);
f0103ecc:	c7 c2 a2 43 10 f0    	mov    $0xf01043a2,%edx
f0103ed2:	66 89 90 c4 24 00 00 	mov    %dx,0x24c4(%eax)
f0103ed9:	66 c7 80 c6 24 00 00 	movw   $0x8,0x24c6(%eax)
f0103ee0:	08 00 
f0103ee2:	c6 80 c8 24 00 00 00 	movb   $0x0,0x24c8(%eax)
f0103ee9:	c6 80 c9 24 00 00 ee 	movb   $0xee,0x24c9(%eax)
f0103ef0:	c1 ea 10             	shr    $0x10,%edx
f0103ef3:	66 89 90 ca 24 00 00 	mov    %dx,0x24ca(%eax)
	trap_init_percpu();
f0103efa:	e8 dd fb ff ff       	call   f0103adc <trap_init_percpu>
}
f0103eff:	5d                   	pop    %ebp
f0103f00:	c3                   	ret    

f0103f01 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103f01:	f3 0f 1e fb          	endbr32 
f0103f05:	55                   	push   %ebp
f0103f06:	89 e5                	mov    %esp,%ebp
f0103f08:	56                   	push   %esi
f0103f09:	53                   	push   %ebx
f0103f0a:	e8 64 c2 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0103f0f:	81 c3 0d 91 08 00    	add    $0x8910d,%ebx
f0103f15:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103f18:	83 ec 08             	sub    $0x8,%esp
f0103f1b:	ff 36                	pushl  (%esi)
f0103f1d:	8d 83 2a 97 f7 ff    	lea    -0x868d6(%ebx),%eax
f0103f23:	50                   	push   %eax
f0103f24:	e8 9b fb ff ff       	call   f0103ac4 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103f29:	83 c4 08             	add    $0x8,%esp
f0103f2c:	ff 76 04             	pushl  0x4(%esi)
f0103f2f:	8d 83 39 97 f7 ff    	lea    -0x868c7(%ebx),%eax
f0103f35:	50                   	push   %eax
f0103f36:	e8 89 fb ff ff       	call   f0103ac4 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103f3b:	83 c4 08             	add    $0x8,%esp
f0103f3e:	ff 76 08             	pushl  0x8(%esi)
f0103f41:	8d 83 48 97 f7 ff    	lea    -0x868b8(%ebx),%eax
f0103f47:	50                   	push   %eax
f0103f48:	e8 77 fb ff ff       	call   f0103ac4 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103f4d:	83 c4 08             	add    $0x8,%esp
f0103f50:	ff 76 0c             	pushl  0xc(%esi)
f0103f53:	8d 83 57 97 f7 ff    	lea    -0x868a9(%ebx),%eax
f0103f59:	50                   	push   %eax
f0103f5a:	e8 65 fb ff ff       	call   f0103ac4 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103f5f:	83 c4 08             	add    $0x8,%esp
f0103f62:	ff 76 10             	pushl  0x10(%esi)
f0103f65:	8d 83 66 97 f7 ff    	lea    -0x8689a(%ebx),%eax
f0103f6b:	50                   	push   %eax
f0103f6c:	e8 53 fb ff ff       	call   f0103ac4 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103f71:	83 c4 08             	add    $0x8,%esp
f0103f74:	ff 76 14             	pushl  0x14(%esi)
f0103f77:	8d 83 75 97 f7 ff    	lea    -0x8688b(%ebx),%eax
f0103f7d:	50                   	push   %eax
f0103f7e:	e8 41 fb ff ff       	call   f0103ac4 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103f83:	83 c4 08             	add    $0x8,%esp
f0103f86:	ff 76 18             	pushl  0x18(%esi)
f0103f89:	8d 83 84 97 f7 ff    	lea    -0x8687c(%ebx),%eax
f0103f8f:	50                   	push   %eax
f0103f90:	e8 2f fb ff ff       	call   f0103ac4 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103f95:	83 c4 08             	add    $0x8,%esp
f0103f98:	ff 76 1c             	pushl  0x1c(%esi)
f0103f9b:	8d 83 93 97 f7 ff    	lea    -0x8686d(%ebx),%eax
f0103fa1:	50                   	push   %eax
f0103fa2:	e8 1d fb ff ff       	call   f0103ac4 <cprintf>
}
f0103fa7:	83 c4 10             	add    $0x10,%esp
f0103faa:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103fad:	5b                   	pop    %ebx
f0103fae:	5e                   	pop    %esi
f0103faf:	5d                   	pop    %ebp
f0103fb0:	c3                   	ret    

f0103fb1 <print_trapframe>:
{
f0103fb1:	f3 0f 1e fb          	endbr32 
f0103fb5:	55                   	push   %ebp
f0103fb6:	89 e5                	mov    %esp,%ebp
f0103fb8:	57                   	push   %edi
f0103fb9:	56                   	push   %esi
f0103fba:	53                   	push   %ebx
f0103fbb:	83 ec 14             	sub    $0x14,%esp
f0103fbe:	e8 b0 c1 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0103fc3:	81 c3 59 90 08 00    	add    $0x89059,%ebx
f0103fc9:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("TRAP frame at %p\n", tf);
f0103fcc:	56                   	push   %esi
f0103fcd:	8d 83 c9 98 f7 ff    	lea    -0x86737(%ebx),%eax
f0103fd3:	50                   	push   %eax
f0103fd4:	e8 eb fa ff ff       	call   f0103ac4 <cprintf>
	print_regs(&tf->tf_regs);
f0103fd9:	89 34 24             	mov    %esi,(%esp)
f0103fdc:	e8 20 ff ff ff       	call   f0103f01 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103fe1:	83 c4 08             	add    $0x8,%esp
f0103fe4:	0f b7 46 20          	movzwl 0x20(%esi),%eax
f0103fe8:	50                   	push   %eax
f0103fe9:	8d 83 e4 97 f7 ff    	lea    -0x8681c(%ebx),%eax
f0103fef:	50                   	push   %eax
f0103ff0:	e8 cf fa ff ff       	call   f0103ac4 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103ff5:	83 c4 08             	add    $0x8,%esp
f0103ff8:	0f b7 46 24          	movzwl 0x24(%esi),%eax
f0103ffc:	50                   	push   %eax
f0103ffd:	8d 83 f7 97 f7 ff    	lea    -0x86809(%ebx),%eax
f0104003:	50                   	push   %eax
f0104004:	e8 bb fa ff ff       	call   f0103ac4 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104009:	8b 56 28             	mov    0x28(%esi),%edx
	if (trapno < ARRAY_SIZE(excnames))
f010400c:	83 c4 10             	add    $0x10,%esp
f010400f:	83 fa 13             	cmp    $0x13,%edx
f0104012:	0f 86 e9 00 00 00    	jbe    f0104101 <print_trapframe+0x150>
		return "System call";
f0104018:	83 fa 30             	cmp    $0x30,%edx
f010401b:	8d 83 a2 97 f7 ff    	lea    -0x8685e(%ebx),%eax
f0104021:	8d 8b b1 97 f7 ff    	lea    -0x8684f(%ebx),%ecx
f0104027:	0f 44 c1             	cmove  %ecx,%eax
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f010402a:	83 ec 04             	sub    $0x4,%esp
f010402d:	50                   	push   %eax
f010402e:	52                   	push   %edx
f010402f:	8d 83 0a 98 f7 ff    	lea    -0x867f6(%ebx),%eax
f0104035:	50                   	push   %eax
f0104036:	e8 89 fa ff ff       	call   f0103ac4 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010403b:	83 c4 10             	add    $0x10,%esp
f010403e:	39 b3 44 2b 00 00    	cmp    %esi,0x2b44(%ebx)
f0104044:	0f 84 c3 00 00 00    	je     f010410d <print_trapframe+0x15c>
	cprintf("  err  0x%08x", tf->tf_err);
f010404a:	83 ec 08             	sub    $0x8,%esp
f010404d:	ff 76 2c             	pushl  0x2c(%esi)
f0104050:	8d 83 2b 98 f7 ff    	lea    -0x867d5(%ebx),%eax
f0104056:	50                   	push   %eax
f0104057:	e8 68 fa ff ff       	call   f0103ac4 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f010405c:	83 c4 10             	add    $0x10,%esp
f010405f:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
f0104063:	0f 85 c9 00 00 00    	jne    f0104132 <print_trapframe+0x181>
			tf->tf_err & 1 ? "protection" : "not-present");
f0104069:	8b 46 2c             	mov    0x2c(%esi),%eax
		cprintf(" [%s, %s, %s]\n",
f010406c:	89 c2                	mov    %eax,%edx
f010406e:	83 e2 01             	and    $0x1,%edx
f0104071:	8d 8b bd 97 f7 ff    	lea    -0x86843(%ebx),%ecx
f0104077:	8d 93 c8 97 f7 ff    	lea    -0x86838(%ebx),%edx
f010407d:	0f 44 ca             	cmove  %edx,%ecx
f0104080:	89 c2                	mov    %eax,%edx
f0104082:	83 e2 02             	and    $0x2,%edx
f0104085:	8d 93 d4 97 f7 ff    	lea    -0x8682c(%ebx),%edx
f010408b:	8d bb da 97 f7 ff    	lea    -0x86826(%ebx),%edi
f0104091:	0f 44 d7             	cmove  %edi,%edx
f0104094:	83 e0 04             	and    $0x4,%eax
f0104097:	8d 83 df 97 f7 ff    	lea    -0x86821(%ebx),%eax
f010409d:	8d bb f4 98 f7 ff    	lea    -0x8670c(%ebx),%edi
f01040a3:	0f 44 c7             	cmove  %edi,%eax
f01040a6:	51                   	push   %ecx
f01040a7:	52                   	push   %edx
f01040a8:	50                   	push   %eax
f01040a9:	8d 83 39 98 f7 ff    	lea    -0x867c7(%ebx),%eax
f01040af:	50                   	push   %eax
f01040b0:	e8 0f fa ff ff       	call   f0103ac4 <cprintf>
f01040b5:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f01040b8:	83 ec 08             	sub    $0x8,%esp
f01040bb:	ff 76 30             	pushl  0x30(%esi)
f01040be:	8d 83 48 98 f7 ff    	lea    -0x867b8(%ebx),%eax
f01040c4:	50                   	push   %eax
f01040c5:	e8 fa f9 ff ff       	call   f0103ac4 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f01040ca:	83 c4 08             	add    $0x8,%esp
f01040cd:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f01040d1:	50                   	push   %eax
f01040d2:	8d 83 57 98 f7 ff    	lea    -0x867a9(%ebx),%eax
f01040d8:	50                   	push   %eax
f01040d9:	e8 e6 f9 ff ff       	call   f0103ac4 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f01040de:	83 c4 08             	add    $0x8,%esp
f01040e1:	ff 76 38             	pushl  0x38(%esi)
f01040e4:	8d 83 6a 98 f7 ff    	lea    -0x86796(%ebx),%eax
f01040ea:	50                   	push   %eax
f01040eb:	e8 d4 f9 ff ff       	call   f0103ac4 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f01040f0:	83 c4 10             	add    $0x10,%esp
f01040f3:	f6 46 34 03          	testb  $0x3,0x34(%esi)
f01040f7:	75 50                	jne    f0104149 <print_trapframe+0x198>
}
f01040f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01040fc:	5b                   	pop    %ebx
f01040fd:	5e                   	pop    %esi
f01040fe:	5f                   	pop    %edi
f01040ff:	5d                   	pop    %ebp
f0104100:	c3                   	ret    
		return excnames[trapno];
f0104101:	8b 84 93 64 20 00 00 	mov    0x2064(%ebx,%edx,4),%eax
f0104108:	e9 1d ff ff ff       	jmp    f010402a <print_trapframe+0x79>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010410d:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
f0104111:	0f 85 33 ff ff ff    	jne    f010404a <print_trapframe+0x99>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104117:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f010411a:	83 ec 08             	sub    $0x8,%esp
f010411d:	50                   	push   %eax
f010411e:	8d 83 1c 98 f7 ff    	lea    -0x867e4(%ebx),%eax
f0104124:	50                   	push   %eax
f0104125:	e8 9a f9 ff ff       	call   f0103ac4 <cprintf>
f010412a:	83 c4 10             	add    $0x10,%esp
f010412d:	e9 18 ff ff ff       	jmp    f010404a <print_trapframe+0x99>
		cprintf("\n");
f0104132:	83 ec 0c             	sub    $0xc,%esp
f0104135:	8d 83 78 8d f7 ff    	lea    -0x87288(%ebx),%eax
f010413b:	50                   	push   %eax
f010413c:	e8 83 f9 ff ff       	call   f0103ac4 <cprintf>
f0104141:	83 c4 10             	add    $0x10,%esp
f0104144:	e9 6f ff ff ff       	jmp    f01040b8 <print_trapframe+0x107>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104149:	83 ec 08             	sub    $0x8,%esp
f010414c:	ff 76 3c             	pushl  0x3c(%esi)
f010414f:	8d 83 79 98 f7 ff    	lea    -0x86787(%ebx),%eax
f0104155:	50                   	push   %eax
f0104156:	e8 69 f9 ff ff       	call   f0103ac4 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f010415b:	83 c4 08             	add    $0x8,%esp
f010415e:	0f b7 46 40          	movzwl 0x40(%esi),%eax
f0104162:	50                   	push   %eax
f0104163:	8d 83 88 98 f7 ff    	lea    -0x86778(%ebx),%eax
f0104169:	50                   	push   %eax
f010416a:	e8 55 f9 ff ff       	call   f0103ac4 <cprintf>
f010416f:	83 c4 10             	add    $0x10,%esp
}
f0104172:	eb 85                	jmp    f01040f9 <print_trapframe+0x148>

f0104174 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104174:	f3 0f 1e fb          	endbr32 
f0104178:	55                   	push   %ebp
f0104179:	89 e5                	mov    %esp,%ebp
f010417b:	57                   	push   %edi
f010417c:	56                   	push   %esi
f010417d:	53                   	push   %ebx
f010417e:	83 ec 0c             	sub    $0xc,%esp
f0104181:	e8 ed bf ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0104186:	81 c3 96 8e 08 00    	add    $0x88e96,%ebx
f010418c:	8b 7d 08             	mov    0x8(%ebp),%edi
f010418f:	0f 20 d0             	mov    %cr2,%eax

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104192:	ff 77 30             	pushl  0x30(%edi)
f0104195:	50                   	push   %eax
f0104196:	c7 c6 48 f3 18 f0    	mov    $0xf018f348,%esi
f010419c:	8b 06                	mov    (%esi),%eax
f010419e:	ff 70 48             	pushl  0x48(%eax)
f01041a1:	8d 83 40 9a f7 ff    	lea    -0x865c0(%ebx),%eax
f01041a7:	50                   	push   %eax
f01041a8:	e8 17 f9 ff ff       	call   f0103ac4 <cprintf>
		curenv->env_id, fault_va, tf->tf_eip);
	print_trapframe(tf);
f01041ad:	89 3c 24             	mov    %edi,(%esp)
f01041b0:	e8 fc fd ff ff       	call   f0103fb1 <print_trapframe>
	env_destroy(curenv);
f01041b5:	83 c4 04             	add    $0x4,%esp
f01041b8:	ff 36                	pushl  (%esi)
f01041ba:	e8 7f f7 ff ff       	call   f010393e <env_destroy>
}
f01041bf:	83 c4 10             	add    $0x10,%esp
f01041c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01041c5:	5b                   	pop    %ebx
f01041c6:	5e                   	pop    %esi
f01041c7:	5f                   	pop    %edi
f01041c8:	5d                   	pop    %ebp
f01041c9:	c3                   	ret    

f01041ca <trap>:
{
f01041ca:	f3 0f 1e fb          	endbr32 
f01041ce:	55                   	push   %ebp
f01041cf:	89 e5                	mov    %esp,%ebp
f01041d1:	57                   	push   %edi
f01041d2:	56                   	push   %esi
f01041d3:	53                   	push   %ebx
f01041d4:	83 ec 0c             	sub    $0xc,%esp
f01041d7:	e8 97 bf ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f01041dc:	81 c3 40 8e 08 00    	add    $0x88e40,%ebx
f01041e2:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f01041e5:	fc                   	cld    
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f01041e6:	9c                   	pushf  
f01041e7:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f01041e8:	f6 c4 02             	test   $0x2,%ah
f01041eb:	74 1f                	je     f010420c <trap+0x42>
f01041ed:	8d 83 9b 98 f7 ff    	lea    -0x86765(%ebx),%eax
f01041f3:	50                   	push   %eax
f01041f4:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01041fa:	50                   	push   %eax
f01041fb:	68 df 00 00 00       	push   $0xdf
f0104200:	8d 83 b4 98 f7 ff    	lea    -0x8674c(%ebx),%eax
f0104206:	50                   	push   %eax
f0104207:	e8 a9 be ff ff       	call   f01000b5 <_panic>
	cprintf("Incoming TRAP frame at %p\n", tf);
f010420c:	83 ec 08             	sub    $0x8,%esp
f010420f:	56                   	push   %esi
f0104210:	8d 83 c0 98 f7 ff    	lea    -0x86740(%ebx),%eax
f0104216:	50                   	push   %eax
f0104217:	e8 a8 f8 ff ff       	call   f0103ac4 <cprintf>
	if ((tf->tf_cs & 3) == 3) {
f010421c:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104220:	83 e0 03             	and    $0x3,%eax
f0104223:	83 c4 10             	add    $0x10,%esp
f0104226:	66 83 f8 03          	cmp    $0x3,%ax
f010422a:	75 1d                	jne    f0104249 <trap+0x7f>
		assert(curenv);
f010422c:	c7 c0 48 f3 18 f0    	mov    $0xf018f348,%eax
f0104232:	8b 00                	mov    (%eax),%eax
f0104234:	85 c0                	test   %eax,%eax
f0104236:	74 5d                	je     f0104295 <trap+0xcb>
		curenv->env_tf = *tf;
f0104238:	b9 11 00 00 00       	mov    $0x11,%ecx
f010423d:	89 c7                	mov    %eax,%edi
f010423f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104241:	c7 c0 48 f3 18 f0    	mov    $0xf018f348,%eax
f0104247:	8b 30                	mov    (%eax),%esi
	last_tf = tf;
f0104249:	89 b3 44 2b 00 00    	mov    %esi,0x2b44(%ebx)
	switch(tf->tf_trapno)
f010424f:	8b 46 28             	mov    0x28(%esi),%eax
f0104252:	83 f8 0e             	cmp    $0xe,%eax
f0104255:	74 5d                	je     f01042b4 <trap+0xea>
f0104257:	83 f8 30             	cmp    $0x30,%eax
f010425a:	0f 84 9f 00 00 00    	je     f01042ff <trap+0x135>
f0104260:	83 f8 03             	cmp    $0x3,%eax
f0104263:	0f 84 88 00 00 00    	je     f01042f1 <trap+0x127>
	print_trapframe(tf);
f0104269:	83 ec 0c             	sub    $0xc,%esp
f010426c:	56                   	push   %esi
f010426d:	e8 3f fd ff ff       	call   f0103fb1 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0104272:	83 c4 10             	add    $0x10,%esp
f0104275:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f010427a:	0f 84 a0 00 00 00    	je     f0104320 <trap+0x156>
		env_destroy(curenv);
f0104280:	83 ec 0c             	sub    $0xc,%esp
f0104283:	c7 c0 48 f3 18 f0    	mov    $0xf018f348,%eax
f0104289:	ff 30                	pushl  (%eax)
f010428b:	e8 ae f6 ff ff       	call   f010393e <env_destroy>
		return;
f0104290:	83 c4 10             	add    $0x10,%esp
f0104293:	eb 2b                	jmp    f01042c0 <trap+0xf6>
		assert(curenv);
f0104295:	8d 83 db 98 f7 ff    	lea    -0x86725(%ebx),%eax
f010429b:	50                   	push   %eax
f010429c:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01042a2:	50                   	push   %eax
f01042a3:	68 e5 00 00 00       	push   $0xe5
f01042a8:	8d 83 b4 98 f7 ff    	lea    -0x8674c(%ebx),%eax
f01042ae:	50                   	push   %eax
f01042af:	e8 01 be ff ff       	call   f01000b5 <_panic>
			page_fault_handler(tf);
f01042b4:	83 ec 0c             	sub    $0xc,%esp
f01042b7:	56                   	push   %esi
f01042b8:	e8 b7 fe ff ff       	call   f0104174 <page_fault_handler>
			return ;
f01042bd:	83 c4 10             	add    $0x10,%esp
	assert(curenv && curenv->env_status == ENV_RUNNING);
f01042c0:	c7 c0 48 f3 18 f0    	mov    $0xf018f348,%eax
f01042c6:	8b 00                	mov    (%eax),%eax
f01042c8:	85 c0                	test   %eax,%eax
f01042ca:	74 06                	je     f01042d2 <trap+0x108>
f01042cc:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01042d0:	74 69                	je     f010433b <trap+0x171>
f01042d2:	8d 83 64 9a f7 ff    	lea    -0x8659c(%ebx),%eax
f01042d8:	50                   	push   %eax
f01042d9:	8d 83 ed 8a f7 ff    	lea    -0x87513(%ebx),%eax
f01042df:	50                   	push   %eax
f01042e0:	68 f7 00 00 00       	push   $0xf7
f01042e5:	8d 83 b4 98 f7 ff    	lea    -0x8674c(%ebx),%eax
f01042eb:	50                   	push   %eax
f01042ec:	e8 c4 bd ff ff       	call   f01000b5 <_panic>
			monitor(tf);
f01042f1:	83 ec 0c             	sub    $0xc,%esp
f01042f4:	56                   	push   %esi
f01042f5:	e8 4a c6 ff ff       	call   f0100944 <monitor>
			return ;
f01042fa:	83 c4 10             	add    $0x10,%esp
f01042fd:	eb c1                	jmp    f01042c0 <trap+0xf6>
			p->reg_eax = syscall(p->reg_eax, p->reg_edx, p->reg_ecx, p->reg_ebx, p->reg_edi, p->reg_esi);
f01042ff:	83 ec 08             	sub    $0x8,%esp
f0104302:	ff 76 04             	pushl  0x4(%esi)
f0104305:	ff 36                	pushl  (%esi)
f0104307:	ff 76 10             	pushl  0x10(%esi)
f010430a:	ff 76 18             	pushl  0x18(%esi)
f010430d:	ff 76 14             	pushl  0x14(%esi)
f0104310:	ff 76 1c             	pushl  0x1c(%esi)
f0104313:	e8 a1 00 00 00       	call   f01043b9 <syscall>
f0104318:	89 46 1c             	mov    %eax,0x1c(%esi)
			return ;
f010431b:	83 c4 20             	add    $0x20,%esp
f010431e:	eb a0                	jmp    f01042c0 <trap+0xf6>
		panic("unhandled trap in kernel");
f0104320:	83 ec 04             	sub    $0x4,%esp
f0104323:	8d 83 e2 98 f7 ff    	lea    -0x8671e(%ebx),%eax
f0104329:	50                   	push   %eax
f010432a:	68 ce 00 00 00       	push   $0xce
f010432f:	8d 83 b4 98 f7 ff    	lea    -0x8674c(%ebx),%eax
f0104335:	50                   	push   %eax
f0104336:	e8 7a bd ff ff       	call   f01000b5 <_panic>
	env_run(curenv);
f010433b:	83 ec 0c             	sub    $0xc,%esp
f010433e:	50                   	push   %eax
f010433f:	e8 70 f6 ff ff       	call   f01039b4 <env_run>

f0104344 <divide_handler>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(divide_handler,T_DIVIDE)
f0104344:	6a 00                	push   $0x0
f0104346:	6a 00                	push   $0x0
f0104348:	eb 5e                	jmp    f01043a8 <_alltraps>

f010434a <debug_handler>:
TRAPHANDLER_NOEC(debug_handler,T_DEBUG)
f010434a:	6a 00                	push   $0x0
f010434c:	6a 01                	push   $0x1
f010434e:	eb 58                	jmp    f01043a8 <_alltraps>

f0104350 <nmi_handler>:
TRAPHANDLER_NOEC(nmi_handler,T_NMI)
f0104350:	6a 00                	push   $0x0
f0104352:	6a 02                	push   $0x2
f0104354:	eb 52                	jmp    f01043a8 <_alltraps>

f0104356 <brkpt_handler>:
TRAPHANDLER_NOEC(brkpt_handler,T_BRKPT)
f0104356:	6a 00                	push   $0x0
f0104358:	6a 03                	push   $0x3
f010435a:	eb 4c                	jmp    f01043a8 <_alltraps>

f010435c <oflow_handler>:
TRAPHANDLER_NOEC(oflow_handler,T_OFLOW)
f010435c:	6a 00                	push   $0x0
f010435e:	6a 04                	push   $0x4
f0104360:	eb 46                	jmp    f01043a8 <_alltraps>

f0104362 <bound_handler>:
TRAPHANDLER_NOEC(bound_handler,T_BOUND)
f0104362:	6a 00                	push   $0x0
f0104364:	6a 05                	push   $0x5
f0104366:	eb 40                	jmp    f01043a8 <_alltraps>

f0104368 <illop_handler>:
TRAPHANDLER_NOEC(illop_handler,T_ILLOP)
f0104368:	6a 00                	push   $0x0
f010436a:	6a 06                	push   $0x6
f010436c:	eb 3a                	jmp    f01043a8 <_alltraps>

f010436e <device_handler>:
TRAPHANDLER_NOEC(device_handler,T_DEVICE)
f010436e:	6a 00                	push   $0x0
f0104370:	6a 07                	push   $0x7
f0104372:	eb 34                	jmp    f01043a8 <_alltraps>

f0104374 <dblflt_handler>:
TRAPHANDLER(dblflt_handler,T_DBLFLT)
f0104374:	6a 08                	push   $0x8
f0104376:	eb 30                	jmp    f01043a8 <_alltraps>

f0104378 <tss_handler>:
TRAPHANDLER(tss_handler,T_TSS)
f0104378:	6a 0a                	push   $0xa
f010437a:	eb 2c                	jmp    f01043a8 <_alltraps>

f010437c <segnp_handler>:
TRAPHANDLER(segnp_handler,T_SEGNP)
f010437c:	6a 0b                	push   $0xb
f010437e:	eb 28                	jmp    f01043a8 <_alltraps>

f0104380 <stack_handler>:
TRAPHANDLER(stack_handler,T_STACK)
f0104380:	6a 0c                	push   $0xc
f0104382:	eb 24                	jmp    f01043a8 <_alltraps>

f0104384 <gpflt_handler>:
TRAPHANDLER(gpflt_handler,T_GPFLT)
f0104384:	6a 0d                	push   $0xd
f0104386:	eb 20                	jmp    f01043a8 <_alltraps>

f0104388 <pgflt_handler>:
TRAPHANDLER(pgflt_handler,T_PGFLT)
f0104388:	6a 0e                	push   $0xe
f010438a:	eb 1c                	jmp    f01043a8 <_alltraps>

f010438c <fperr_handler>:
TRAPHANDLER_NOEC(fperr_handler,T_FPERR)
f010438c:	6a 00                	push   $0x0
f010438e:	6a 10                	push   $0x10
f0104390:	eb 16                	jmp    f01043a8 <_alltraps>

f0104392 <align_handler>:
TRAPHANDLER(align_handler,T_ALIGN)
f0104392:	6a 11                	push   $0x11
f0104394:	eb 12                	jmp    f01043a8 <_alltraps>

f0104396 <mchk_handler>:
TRAPHANDLER_NOEC(mchk_handler,T_MCHK)
f0104396:	6a 00                	push   $0x0
f0104398:	6a 12                	push   $0x12
f010439a:	eb 0c                	jmp    f01043a8 <_alltraps>

f010439c <simderr_handler>:
TRAPHANDLER_NOEC(simderr_handler,T_SIMDERR)
f010439c:	6a 00                	push   $0x0
f010439e:	6a 13                	push   $0x13
f01043a0:	eb 06                	jmp    f01043a8 <_alltraps>

f01043a2 <syscall_handler>:
TRAPHANDLER_NOEC(syscall_handler,T_SYSCALL)
f01043a2:	6a 00                	push   $0x0
f01043a4:	6a 30                	push   $0x30
f01043a6:	eb 00                	jmp    f01043a8 <_alltraps>

f01043a8 <_alltraps>:

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl	%es
f01043a8:	06                   	push   %es
	pushl	%ds
f01043a9:	1e                   	push   %ds
	pushal
f01043aa:	60                   	pusha  
	movw	$(GD_KD), %ax
f01043ab:	66 b8 10 00          	mov    $0x10,%ax
	movw 	%ax, %ds
f01043af:	8e d8                	mov    %eax,%ds
	movw 	%ax, %es
f01043b1:	8e c0                	mov    %eax,%es
	pushl	%esp
f01043b3:	54                   	push   %esp
f01043b4:	e8 11 fe ff ff       	call   f01041ca <trap>

f01043b9 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01043b9:	f3 0f 1e fb          	endbr32 
f01043bd:	55                   	push   %ebp
f01043be:	89 e5                	mov    %esp,%ebp
f01043c0:	53                   	push   %ebx
f01043c1:	83 ec 14             	sub    $0x14,%esp
f01043c4:	e8 aa bd ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f01043c9:	81 c3 53 8c 08 00    	add    $0x88c53,%ebx
f01043cf:	8b 45 08             	mov    0x8(%ebp),%eax
	// Return any appropriate return value.
	// LAB 3: Your code here.

	//panic("syscall not implemented");

	switch (syscallno) {
f01043d2:	83 f8 02             	cmp    $0x2,%eax
f01043d5:	0f 84 a7 00 00 00    	je     f0104482 <syscall+0xc9>
f01043db:	83 f8 02             	cmp    $0x2,%eax
f01043de:	77 0b                	ja     f01043eb <syscall+0x32>
f01043e0:	85 c0                	test   %eax,%eax
f01043e2:	74 6a                	je     f010444e <syscall+0x95>
	return cons_getc();
f01043e4:	e8 8b c1 ff ff       	call   f0100574 <cons_getc>
	case SYS_cputs:
		sys_cputs((const char*)a1, (size_t)a2);
		return 0;
	case SYS_cgetc:
		return sys_cgetc();
f01043e9:	eb 5e                	jmp    f0104449 <syscall+0x90>
	switch (syscallno) {
f01043eb:	83 f8 03             	cmp    $0x3,%eax
f01043ee:	75 54                	jne    f0104444 <syscall+0x8b>
	if ((r = envid2env(envid, &e, 1)) < 0)
f01043f0:	83 ec 04             	sub    $0x4,%esp
f01043f3:	6a 01                	push   $0x1
f01043f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01043f8:	50                   	push   %eax
f01043f9:	ff 75 0c             	pushl  0xc(%ebp)
f01043fc:	e8 d4 ee ff ff       	call   f01032d5 <envid2env>
f0104401:	83 c4 10             	add    $0x10,%esp
f0104404:	85 c0                	test   %eax,%eax
f0104406:	78 41                	js     f0104449 <syscall+0x90>
	if (e == curenv)
f0104408:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010440b:	c7 c0 48 f3 18 f0    	mov    $0xf018f348,%eax
f0104411:	8b 00                	mov    (%eax),%eax
f0104413:	39 c2                	cmp    %eax,%edx
f0104415:	74 78                	je     f010448f <syscall+0xd6>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0104417:	83 ec 04             	sub    $0x4,%esp
f010441a:	ff 72 48             	pushl  0x48(%edx)
f010441d:	ff 70 48             	pushl  0x48(%eax)
f0104420:	8d 83 b0 9a f7 ff    	lea    -0x86550(%ebx),%eax
f0104426:	50                   	push   %eax
f0104427:	e8 98 f6 ff ff       	call   f0103ac4 <cprintf>
f010442c:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f010442f:	83 ec 0c             	sub    $0xc,%esp
f0104432:	ff 75 f4             	pushl  -0xc(%ebp)
f0104435:	e8 04 f5 ff ff       	call   f010393e <env_destroy>
	return 0;
f010443a:	83 c4 10             	add    $0x10,%esp
f010443d:	b8 00 00 00 00       	mov    $0x0,%eax
	case SYS_getenvid:
		return (envid_t)sys_getenvid();
	case SYS_env_destroy:
		return sys_env_destroy((envid_t)a1);
f0104442:	eb 05                	jmp    f0104449 <syscall+0x90>
	switch (syscallno) {
f0104444:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	default:
		return -E_INVAL;
	}
}
f0104449:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010444c:	c9                   	leave  
f010444d:	c3                   	ret    
	user_mem_assert(curenv, s, len, PTE_U);
f010444e:	6a 04                	push   $0x4
f0104450:	ff 75 10             	pushl  0x10(%ebp)
f0104453:	ff 75 0c             	pushl  0xc(%ebp)
f0104456:	c7 c0 48 f3 18 f0    	mov    $0xf018f348,%eax
f010445c:	ff 30                	pushl  (%eax)
f010445e:	e8 90 ed ff ff       	call   f01031f3 <user_mem_assert>
	cprintf("%.*s", len, s);
f0104463:	83 c4 0c             	add    $0xc,%esp
f0104466:	ff 75 0c             	pushl  0xc(%ebp)
f0104469:	ff 75 10             	pushl  0x10(%ebp)
f010446c:	8d 83 90 9a f7 ff    	lea    -0x86570(%ebx),%eax
f0104472:	50                   	push   %eax
f0104473:	e8 4c f6 ff ff       	call   f0103ac4 <cprintf>
}
f0104478:	83 c4 10             	add    $0x10,%esp
		return 0;
f010447b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104480:	eb c7                	jmp    f0104449 <syscall+0x90>
	return curenv->env_id;
f0104482:	c7 c0 48 f3 18 f0    	mov    $0xf018f348,%eax
f0104488:	8b 00                	mov    (%eax),%eax
f010448a:	8b 40 48             	mov    0x48(%eax),%eax
		return (envid_t)sys_getenvid();
f010448d:	eb ba                	jmp    f0104449 <syscall+0x90>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f010448f:	83 ec 08             	sub    $0x8,%esp
f0104492:	ff 70 48             	pushl  0x48(%eax)
f0104495:	8d 83 95 9a f7 ff    	lea    -0x8656b(%ebx),%eax
f010449b:	50                   	push   %eax
f010449c:	e8 23 f6 ff ff       	call   f0103ac4 <cprintf>
f01044a1:	83 c4 10             	add    $0x10,%esp
f01044a4:	eb 89                	jmp    f010442f <syscall+0x76>

f01044a6 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f01044a6:	55                   	push   %ebp
f01044a7:	89 e5                	mov    %esp,%ebp
f01044a9:	57                   	push   %edi
f01044aa:	56                   	push   %esi
f01044ab:	53                   	push   %ebx
f01044ac:	83 ec 14             	sub    $0x14,%esp
f01044af:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01044b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01044b5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01044b8:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f01044bb:	8b 1a                	mov    (%edx),%ebx
f01044bd:	8b 01                	mov    (%ecx),%eax
f01044bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01044c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f01044c9:	eb 23                	jmp    f01044ee <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f01044cb:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f01044ce:	eb 1e                	jmp    f01044ee <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f01044d0:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01044d3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01044d6:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01044da:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01044dd:	73 46                	jae    f0104525 <stab_binsearch+0x7f>
			*region_left = m;
f01044df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01044e2:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f01044e4:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f01044e7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f01044ee:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f01044f1:	7f 5f                	jg     f0104552 <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f01044f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01044f6:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f01044f9:	89 d0                	mov    %edx,%eax
f01044fb:	c1 e8 1f             	shr    $0x1f,%eax
f01044fe:	01 d0                	add    %edx,%eax
f0104500:	89 c7                	mov    %eax,%edi
f0104502:	d1 ff                	sar    %edi
f0104504:	83 e0 fe             	and    $0xfffffffe,%eax
f0104507:	01 f8                	add    %edi,%eax
f0104509:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010450c:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104510:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0104512:	39 c3                	cmp    %eax,%ebx
f0104514:	7f b5                	jg     f01044cb <stab_binsearch+0x25>
f0104516:	0f b6 0a             	movzbl (%edx),%ecx
f0104519:	83 ea 0c             	sub    $0xc,%edx
f010451c:	39 f1                	cmp    %esi,%ecx
f010451e:	74 b0                	je     f01044d0 <stab_binsearch+0x2a>
			m--;
f0104520:	83 e8 01             	sub    $0x1,%eax
f0104523:	eb ed                	jmp    f0104512 <stab_binsearch+0x6c>
		} else if (stabs[m].n_value > addr) {
f0104525:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104528:	76 14                	jbe    f010453e <stab_binsearch+0x98>
			*region_right = m - 1;
f010452a:	83 e8 01             	sub    $0x1,%eax
f010452d:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104530:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104533:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0104535:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f010453c:	eb b0                	jmp    f01044ee <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f010453e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104541:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0104543:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104547:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0104549:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104550:	eb 9c                	jmp    f01044ee <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0104552:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104556:	75 15                	jne    f010456d <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0104558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010455b:	8b 00                	mov    (%eax),%eax
f010455d:	83 e8 01             	sub    $0x1,%eax
f0104560:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104563:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0104565:	83 c4 14             	add    $0x14,%esp
f0104568:	5b                   	pop    %ebx
f0104569:	5e                   	pop    %esi
f010456a:	5f                   	pop    %edi
f010456b:	5d                   	pop    %ebp
f010456c:	c3                   	ret    
		for (l = *region_right;
f010456d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104570:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104572:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104575:	8b 0f                	mov    (%edi),%ecx
f0104577:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010457a:	8b 7d ec             	mov    -0x14(%ebp),%edi
f010457d:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0104581:	eb 03                	jmp    f0104586 <stab_binsearch+0xe0>
		     l--)
f0104583:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104586:	39 c1                	cmp    %eax,%ecx
f0104588:	7d 0a                	jge    f0104594 <stab_binsearch+0xee>
		     l > *region_left && stabs[l].n_type != type;
f010458a:	0f b6 1a             	movzbl (%edx),%ebx
f010458d:	83 ea 0c             	sub    $0xc,%edx
f0104590:	39 f3                	cmp    %esi,%ebx
f0104592:	75 ef                	jne    f0104583 <stab_binsearch+0xdd>
		*region_left = l;
f0104594:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104597:	89 07                	mov    %eax,(%edi)
}
f0104599:	eb ca                	jmp    f0104565 <stab_binsearch+0xbf>

f010459b <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f010459b:	f3 0f 1e fb          	endbr32 
f010459f:	55                   	push   %ebp
f01045a0:	89 e5                	mov    %esp,%ebp
f01045a2:	57                   	push   %edi
f01045a3:	56                   	push   %esi
f01045a4:	53                   	push   %ebx
f01045a5:	83 ec 4c             	sub    $0x4c,%esp
f01045a8:	e8 c6 bb ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f01045ad:	81 c3 6f 8a 08 00    	add    $0x88a6f,%ebx
f01045b3:	8b 75 0c             	mov    0xc(%ebp),%esi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f01045b6:	8d 83 c8 9a f7 ff    	lea    -0x86538(%ebx),%eax
f01045bc:	89 06                	mov    %eax,(%esi)
	info->eip_line = 0;
f01045be:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
	info->eip_fn_name = "<unknown>";
f01045c5:	89 46 08             	mov    %eax,0x8(%esi)
	info->eip_fn_namelen = 9;
f01045c8:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
	info->eip_fn_addr = addr;
f01045cf:	8b 45 08             	mov    0x8(%ebp),%eax
f01045d2:	89 46 10             	mov    %eax,0x10(%esi)
	info->eip_fn_narg = 0;
f01045d5:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f01045dc:	3d ff ff 7f ef       	cmp    $0xef7fffff,%eax
f01045e1:	0f 87 9a 00 00 00    	ja     f0104681 <debuginfo_eip+0xe6>
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if(curenv && user_mem_check(curenv, (void*)usd, sizeof(struct UserStabData), PTE_U) < 0){
f01045e7:	c7 c0 48 f3 18 f0    	mov    $0xf018f348,%eax
f01045ed:	8b 00                	mov    (%eax),%eax
f01045ef:	85 c0                	test   %eax,%eax
f01045f1:	0f 84 80 02 00 00    	je     f0104877 <debuginfo_eip+0x2dc>
f01045f7:	6a 04                	push   $0x4
f01045f9:	6a 10                	push   $0x10
f01045fb:	68 00 00 20 00       	push   $0x200000
f0104600:	50                   	push   %eax
f0104601:	e8 39 eb ff ff       	call   f010313f <user_mem_check>
f0104606:	83 c4 10             	add    $0x10,%esp
f0104609:	85 c0                	test   %eax,%eax
f010460b:	0f 88 34 02 00 00    	js     f0104845 <debuginfo_eip+0x2aa>
			return -1;
		}

		stabs = usd->stabs;
f0104611:	8b 3d 00 00 20 00    	mov    0x200000,%edi
f0104617:	89 7d b8             	mov    %edi,-0x48(%ebp)
		stab_end = usd->stab_end;
f010461a:	8b 0d 04 00 20 00    	mov    0x200004,%ecx
f0104620:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
		stabstr = usd->stabstr;
f0104623:	a1 08 00 20 00       	mov    0x200008,%eax
f0104628:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f010462b:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0104631:	89 55 bc             	mov    %edx,-0x44(%ebp)

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (curenv && (
f0104634:	c7 c0 48 f3 18 f0    	mov    $0xf018f348,%eax
f010463a:	8b 00                	mov    (%eax),%eax
f010463c:	85 c0                	test   %eax,%eax
f010463e:	74 65                	je     f01046a5 <debuginfo_eip+0x10a>
                user_mem_check(curenv, (void*)stabs, 
f0104640:	6a 04                	push   $0x4
f0104642:	29 f9                	sub    %edi,%ecx
f0104644:	51                   	push   %ecx
f0104645:	57                   	push   %edi
f0104646:	50                   	push   %eax
f0104647:	e8 f3 ea ff ff       	call   f010313f <user_mem_check>
		if (curenv && (
f010464c:	83 c4 10             	add    $0x10,%esp
f010464f:	85 c0                	test   %eax,%eax
f0104651:	0f 88 f5 01 00 00    	js     f010484c <debuginfo_eip+0x2b1>
                               (uintptr_t)stab_end - (uintptr_t)stabs, PTE_U) < 0 || 
                user_mem_check(curenv, (void*)stabstr, 
f0104657:	6a 04                	push   $0x4
f0104659:	8b 45 bc             	mov    -0x44(%ebp),%eax
f010465c:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f010465f:	29 f8                	sub    %edi,%eax
f0104661:	50                   	push   %eax
f0104662:	57                   	push   %edi
f0104663:	c7 c0 48 f3 18 f0    	mov    $0xf018f348,%eax
f0104669:	ff 30                	pushl  (%eax)
f010466b:	e8 cf ea ff ff       	call   f010313f <user_mem_check>
                               (uintptr_t)stab_end - (uintptr_t)stabs, PTE_U) < 0 || 
f0104670:	83 c4 10             	add    $0x10,%esp
f0104673:	85 c0                	test   %eax,%eax
f0104675:	79 2e                	jns    f01046a5 <debuginfo_eip+0x10a>
                               (uintptr_t)stabstr_end - (uintptr_t)stabstr, PTE_U) < 0))
        	return -1;
f0104677:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f010467c:	e9 ec 01 00 00       	jmp    f010486d <debuginfo_eip+0x2d2>
		stabstr_end = __STABSTR_END__;
f0104681:	c7 c0 a5 2f 11 f0    	mov    $0xf0112fa5,%eax
f0104687:	89 45 bc             	mov    %eax,-0x44(%ebp)
		stabstr = __STABSTR_BEGIN__;
f010468a:	c7 c0 d9 04 11 f0    	mov    $0xf01104d9,%eax
f0104690:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0104693:	c7 c0 d8 04 11 f0    	mov    $0xf01104d8,%eax
f0104699:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		stabs = __STAB_BEGIN__;
f010469c:	c7 c0 e0 6c 10 f0    	mov    $0xf0106ce0,%eax
f01046a2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01046a5:	8b 7d bc             	mov    -0x44(%ebp),%edi
f01046a8:	39 7d b4             	cmp    %edi,-0x4c(%ebp)
f01046ab:	0f 83 a2 01 00 00    	jae    f0104853 <debuginfo_eip+0x2b8>
f01046b1:	80 7f ff 00          	cmpb   $0x0,-0x1(%edi)
f01046b5:	0f 85 9f 01 00 00    	jne    f010485a <debuginfo_eip+0x2bf>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01046bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01046c2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f01046c5:	8b 7d b8             	mov    -0x48(%ebp),%edi
f01046c8:	29 f8                	sub    %edi,%eax
f01046ca:	c1 f8 02             	sar    $0x2,%eax
f01046cd:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f01046d3:	83 e8 01             	sub    $0x1,%eax
f01046d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01046d9:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f01046dc:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01046df:	83 ec 08             	sub    $0x8,%esp
f01046e2:	ff 75 08             	pushl  0x8(%ebp)
f01046e5:	6a 64                	push   $0x64
f01046e7:	89 f8                	mov    %edi,%eax
f01046e9:	e8 b8 fd ff ff       	call   f01044a6 <stab_binsearch>
	if (lfile == 0)
f01046ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01046f1:	83 c4 10             	add    $0x10,%esp
f01046f4:	85 c0                	test   %eax,%eax
f01046f6:	0f 84 65 01 00 00    	je     f0104861 <debuginfo_eip+0x2c6>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f01046fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f01046ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104702:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104705:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0104708:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010470b:	83 ec 08             	sub    $0x8,%esp
f010470e:	ff 75 08             	pushl  0x8(%ebp)
f0104711:	6a 24                	push   $0x24
f0104713:	89 f8                	mov    %edi,%eax
f0104715:	e8 8c fd ff ff       	call   f01044a6 <stab_binsearch>

	if (lfun <= rfun) {
f010471a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010471d:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104720:	83 c4 10             	add    $0x10,%esp
f0104723:	39 d0                	cmp    %edx,%eax
f0104725:	7f 76                	jg     f010479d <debuginfo_eip+0x202>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104727:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f010472a:	8d 0c 8f             	lea    (%edi,%ecx,4),%ecx
f010472d:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0104730:	8b 09                	mov    (%ecx),%ecx
f0104732:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104735:	2b 7d b4             	sub    -0x4c(%ebp),%edi
f0104738:	39 f9                	cmp    %edi,%ecx
f010473a:	73 06                	jae    f0104742 <debuginfo_eip+0x1a7>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f010473c:	03 4d b4             	add    -0x4c(%ebp),%ecx
f010473f:	89 4e 08             	mov    %ecx,0x8(%esi)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104742:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0104745:	8b 4f 08             	mov    0x8(%edi),%ecx
f0104748:	89 4e 10             	mov    %ecx,0x10(%esi)
		addr -= info->eip_fn_addr;
f010474b:	29 4d 08             	sub    %ecx,0x8(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
f010474e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0104751:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104754:	83 ec 08             	sub    $0x8,%esp
f0104757:	6a 3a                	push   $0x3a
f0104759:	ff 76 08             	pushl  0x8(%esi)
f010475c:	e8 07 0a 00 00       	call   f0105168 <strfind>
f0104761:	2b 46 08             	sub    0x8(%esi),%eax
f0104764:	89 46 0c             	mov    %eax,0xc(%esi)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0104767:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f010476a:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f010476d:	83 c4 08             	add    $0x8,%esp
f0104770:	ff 75 08             	pushl  0x8(%ebp)
f0104773:	6a 44                	push   $0x44
f0104775:	8b 5d b8             	mov    -0x48(%ebp),%ebx
f0104778:	89 d8                	mov    %ebx,%eax
f010477a:	e8 27 fd ff ff       	call   f01044a6 <stab_binsearch>
	info->eip_line = stabs[lline].n_desc;
f010477f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104782:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104785:	0f b7 4c 93 06       	movzwl 0x6(%ebx,%edx,4),%ecx
f010478a:	89 4e 04             	mov    %ecx,0x4(%esi)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f010478d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104790:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx
f0104794:	83 c4 10             	add    $0x10,%esp
f0104797:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f010479b:	eb 1e                	jmp    f01047bb <debuginfo_eip+0x220>
		info->eip_fn_addr = addr;
f010479d:	8b 45 08             	mov    0x8(%ebp),%eax
f01047a0:	89 46 10             	mov    %eax,0x10(%esi)
		lline = lfile;
f01047a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01047a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f01047a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01047ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01047af:	eb a3                	jmp    f0104754 <debuginfo_eip+0x1b9>
f01047b1:	83 e8 01             	sub    $0x1,%eax
f01047b4:	83 ea 0c             	sub    $0xc,%edx
	while (lline >= lfile
f01047b7:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f01047bb:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01047be:	39 c7                	cmp    %eax,%edi
f01047c0:	7f 43                	jg     f0104805 <debuginfo_eip+0x26a>
	       && stabs[lline].n_type != N_SOL
f01047c2:	0f b6 0a             	movzbl (%edx),%ecx
f01047c5:	80 f9 84             	cmp    $0x84,%cl
f01047c8:	74 19                	je     f01047e3 <debuginfo_eip+0x248>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01047ca:	80 f9 64             	cmp    $0x64,%cl
f01047cd:	75 e2                	jne    f01047b1 <debuginfo_eip+0x216>
f01047cf:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f01047d3:	74 dc                	je     f01047b1 <debuginfo_eip+0x216>
f01047d5:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01047d9:	74 11                	je     f01047ec <debuginfo_eip+0x251>
f01047db:	8b 7d c0             	mov    -0x40(%ebp),%edi
f01047de:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01047e1:	eb 09                	jmp    f01047ec <debuginfo_eip+0x251>
f01047e3:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01047e7:	74 03                	je     f01047ec <debuginfo_eip+0x251>
f01047e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01047ec:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01047ef:	8b 7d b8             	mov    -0x48(%ebp),%edi
f01047f2:	8b 04 87             	mov    (%edi,%eax,4),%eax
f01047f5:	8b 55 bc             	mov    -0x44(%ebp),%edx
f01047f8:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f01047fb:	29 fa                	sub    %edi,%edx
f01047fd:	39 d0                	cmp    %edx,%eax
f01047ff:	73 04                	jae    f0104805 <debuginfo_eip+0x26a>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0104801:	01 f8                	add    %edi,%eax
f0104803:	89 06                	mov    %eax,(%esi)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0104805:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104808:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f010480b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (lfun < rfun)
f0104810:	39 d8                	cmp    %ebx,%eax
f0104812:	7d 59                	jge    f010486d <debuginfo_eip+0x2d2>
		for (lline = lfun + 1;
f0104814:	8d 50 01             	lea    0x1(%eax),%edx
f0104817:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f010481a:	89 d0                	mov    %edx,%eax
f010481c:	8d 14 52             	lea    (%edx,%edx,2),%edx
f010481f:	8b 7d b8             	mov    -0x48(%ebp),%edi
f0104822:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0104826:	eb 04                	jmp    f010482c <debuginfo_eip+0x291>
			info->eip_fn_narg++;
f0104828:	83 46 14 01          	addl   $0x1,0x14(%esi)
		for (lline = lfun + 1;
f010482c:	39 c3                	cmp    %eax,%ebx
f010482e:	7e 38                	jle    f0104868 <debuginfo_eip+0x2cd>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0104830:	0f b6 0a             	movzbl (%edx),%ecx
f0104833:	83 c0 01             	add    $0x1,%eax
f0104836:	83 c2 0c             	add    $0xc,%edx
f0104839:	80 f9 a0             	cmp    $0xa0,%cl
f010483c:	74 ea                	je     f0104828 <debuginfo_eip+0x28d>
	return 0;
f010483e:	ba 00 00 00 00       	mov    $0x0,%edx
f0104843:	eb 28                	jmp    f010486d <debuginfo_eip+0x2d2>
			return -1;
f0104845:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f010484a:	eb 21                	jmp    f010486d <debuginfo_eip+0x2d2>
        	return -1;
f010484c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104851:	eb 1a                	jmp    f010486d <debuginfo_eip+0x2d2>
		return -1;
f0104853:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104858:	eb 13                	jmp    f010486d <debuginfo_eip+0x2d2>
f010485a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f010485f:	eb 0c                	jmp    f010486d <debuginfo_eip+0x2d2>
		return -1;
f0104861:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104866:	eb 05                	jmp    f010486d <debuginfo_eip+0x2d2>
	return 0;
f0104868:	ba 00 00 00 00       	mov    $0x0,%edx
}
f010486d:	89 d0                	mov    %edx,%eax
f010486f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104872:	5b                   	pop    %ebx
f0104873:	5e                   	pop    %esi
f0104874:	5f                   	pop    %edi
f0104875:	5d                   	pop    %ebp
f0104876:	c3                   	ret    
		stabs = usd->stabs;
f0104877:	a1 00 00 20 00       	mov    0x200000,%eax
f010487c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		stab_end = usd->stab_end;
f010487f:	a1 04 00 20 00       	mov    0x200004,%eax
f0104884:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		stabstr = usd->stabstr;
f0104887:	a1 08 00 20 00       	mov    0x200008,%eax
f010488c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f010488f:	a1 0c 00 20 00       	mov    0x20000c,%eax
f0104894:	89 45 bc             	mov    %eax,-0x44(%ebp)
f0104897:	e9 09 fe ff ff       	jmp    f01046a5 <debuginfo_eip+0x10a>

f010489c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f010489c:	55                   	push   %ebp
f010489d:	89 e5                	mov    %esp,%ebp
f010489f:	57                   	push   %edi
f01048a0:	56                   	push   %esi
f01048a1:	53                   	push   %ebx
f01048a2:	83 ec 2c             	sub    $0x2c,%esp
f01048a5:	e8 a6 e9 ff ff       	call   f0103250 <__x86.get_pc_thunk.cx>
f01048aa:	81 c1 72 87 08 00    	add    $0x88772,%ecx
f01048b0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01048b3:	89 c7                	mov    %eax,%edi
f01048b5:	89 d6                	mov    %edx,%esi
f01048b7:	8b 45 08             	mov    0x8(%ebp),%eax
f01048ba:	8b 55 0c             	mov    0xc(%ebp),%edx
f01048bd:	89 d1                	mov    %edx,%ecx
f01048bf:	89 c2                	mov    %eax,%edx
f01048c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01048c4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f01048c7:	8b 45 10             	mov    0x10(%ebp),%eax
f01048ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f01048cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01048d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01048d7:	39 c2                	cmp    %eax,%edx
f01048d9:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f01048dc:	72 41                	jb     f010491f <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f01048de:	83 ec 0c             	sub    $0xc,%esp
f01048e1:	ff 75 18             	pushl  0x18(%ebp)
f01048e4:	83 eb 01             	sub    $0x1,%ebx
f01048e7:	53                   	push   %ebx
f01048e8:	50                   	push   %eax
f01048e9:	83 ec 08             	sub    $0x8,%esp
f01048ec:	ff 75 e4             	pushl  -0x1c(%ebp)
f01048ef:	ff 75 e0             	pushl  -0x20(%ebp)
f01048f2:	ff 75 d4             	pushl  -0x2c(%ebp)
f01048f5:	ff 75 d0             	pushl  -0x30(%ebp)
f01048f8:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f01048fb:	e8 90 0a 00 00       	call   f0105390 <__udivdi3>
f0104900:	83 c4 18             	add    $0x18,%esp
f0104903:	52                   	push   %edx
f0104904:	50                   	push   %eax
f0104905:	89 f2                	mov    %esi,%edx
f0104907:	89 f8                	mov    %edi,%eax
f0104909:	e8 8e ff ff ff       	call   f010489c <printnum>
f010490e:	83 c4 20             	add    $0x20,%esp
f0104911:	eb 13                	jmp    f0104926 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104913:	83 ec 08             	sub    $0x8,%esp
f0104916:	56                   	push   %esi
f0104917:	ff 75 18             	pushl  0x18(%ebp)
f010491a:	ff d7                	call   *%edi
f010491c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f010491f:	83 eb 01             	sub    $0x1,%ebx
f0104922:	85 db                	test   %ebx,%ebx
f0104924:	7f ed                	jg     f0104913 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0104926:	83 ec 08             	sub    $0x8,%esp
f0104929:	56                   	push   %esi
f010492a:	83 ec 04             	sub    $0x4,%esp
f010492d:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104930:	ff 75 e0             	pushl  -0x20(%ebp)
f0104933:	ff 75 d4             	pushl  -0x2c(%ebp)
f0104936:	ff 75 d0             	pushl  -0x30(%ebp)
f0104939:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f010493c:	e8 5f 0b 00 00       	call   f01054a0 <__umoddi3>
f0104941:	83 c4 14             	add    $0x14,%esp
f0104944:	0f be 84 03 d2 9a f7 	movsbl -0x8652e(%ebx,%eax,1),%eax
f010494b:	ff 
f010494c:	50                   	push   %eax
f010494d:	ff d7                	call   *%edi
}
f010494f:	83 c4 10             	add    $0x10,%esp
f0104952:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104955:	5b                   	pop    %ebx
f0104956:	5e                   	pop    %esi
f0104957:	5f                   	pop    %edi
f0104958:	5d                   	pop    %ebp
f0104959:	c3                   	ret    

f010495a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f010495a:	f3 0f 1e fb          	endbr32 
f010495e:	55                   	push   %ebp
f010495f:	89 e5                	mov    %esp,%ebp
f0104961:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0104964:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0104968:	8b 10                	mov    (%eax),%edx
f010496a:	3b 50 04             	cmp    0x4(%eax),%edx
f010496d:	73 0a                	jae    f0104979 <sprintputch+0x1f>
		*b->buf++ = ch;
f010496f:	8d 4a 01             	lea    0x1(%edx),%ecx
f0104972:	89 08                	mov    %ecx,(%eax)
f0104974:	8b 45 08             	mov    0x8(%ebp),%eax
f0104977:	88 02                	mov    %al,(%edx)
}
f0104979:	5d                   	pop    %ebp
f010497a:	c3                   	ret    

f010497b <printfmt>:
{
f010497b:	f3 0f 1e fb          	endbr32 
f010497f:	55                   	push   %ebp
f0104980:	89 e5                	mov    %esp,%ebp
f0104982:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0104985:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0104988:	50                   	push   %eax
f0104989:	ff 75 10             	pushl  0x10(%ebp)
f010498c:	ff 75 0c             	pushl  0xc(%ebp)
f010498f:	ff 75 08             	pushl  0x8(%ebp)
f0104992:	e8 05 00 00 00       	call   f010499c <vprintfmt>
}
f0104997:	83 c4 10             	add    $0x10,%esp
f010499a:	c9                   	leave  
f010499b:	c3                   	ret    

f010499c <vprintfmt>:
{
f010499c:	f3 0f 1e fb          	endbr32 
f01049a0:	55                   	push   %ebp
f01049a1:	89 e5                	mov    %esp,%ebp
f01049a3:	57                   	push   %edi
f01049a4:	56                   	push   %esi
f01049a5:	53                   	push   %ebx
f01049a6:	83 ec 3c             	sub    $0x3c,%esp
f01049a9:	e8 79 bd ff ff       	call   f0100727 <__x86.get_pc_thunk.ax>
f01049ae:	05 6e 86 08 00       	add    $0x8866e,%eax
f01049b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01049b6:	8b 75 08             	mov    0x8(%ebp),%esi
f01049b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01049bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01049bf:	8d 80 b4 20 00 00    	lea    0x20b4(%eax),%eax
f01049c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f01049c8:	e9 cd 03 00 00       	jmp    f0104d9a <.L25+0x48>
		padc = ' ';
f01049cd:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
f01049d1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f01049d8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f01049df:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
f01049e6:	b9 00 00 00 00       	mov    $0x0,%ecx
f01049eb:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f01049ee:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01049f1:	8d 43 01             	lea    0x1(%ebx),%eax
f01049f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01049f7:	0f b6 13             	movzbl (%ebx),%edx
f01049fa:	8d 42 dd             	lea    -0x23(%edx),%eax
f01049fd:	3c 55                	cmp    $0x55,%al
f01049ff:	0f 87 21 04 00 00    	ja     f0104e26 <.L20>
f0104a05:	0f b6 c0             	movzbl %al,%eax
f0104a08:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0104a0b:	89 ce                	mov    %ecx,%esi
f0104a0d:	03 b4 81 5c 9b f7 ff 	add    -0x864a4(%ecx,%eax,4),%esi
f0104a14:	3e ff e6             	notrack jmp *%esi

f0104a17 <.L68>:
f0104a17:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
f0104a1a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0104a1e:	eb d1                	jmp    f01049f1 <vprintfmt+0x55>

f0104a20 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
f0104a20:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104a23:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f0104a27:	eb c8                	jmp    f01049f1 <vprintfmt+0x55>

f0104a29 <.L31>:
f0104a29:	0f b6 d2             	movzbl %dl,%edx
f0104a2c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
f0104a2f:	b8 00 00 00 00       	mov    $0x0,%eax
f0104a34:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
f0104a37:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0104a3a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0104a3e:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
f0104a41:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0104a44:	83 f9 09             	cmp    $0x9,%ecx
f0104a47:	77 58                	ja     f0104aa1 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
f0104a49:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
f0104a4c:	eb e9                	jmp    f0104a37 <.L31+0xe>

f0104a4e <.L34>:
			precision = va_arg(ap, int);
f0104a4e:	8b 45 14             	mov    0x14(%ebp),%eax
f0104a51:	8b 00                	mov    (%eax),%eax
f0104a53:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104a56:	8b 45 14             	mov    0x14(%ebp),%eax
f0104a59:	8d 40 04             	lea    0x4(%eax),%eax
f0104a5c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104a5f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
f0104a62:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0104a66:	79 89                	jns    f01049f1 <vprintfmt+0x55>
				width = precision, precision = -1;
f0104a68:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0104a6b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0104a6e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0104a75:	e9 77 ff ff ff       	jmp    f01049f1 <vprintfmt+0x55>

f0104a7a <.L33>:
f0104a7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104a7d:	85 c0                	test   %eax,%eax
f0104a7f:	ba 00 00 00 00       	mov    $0x0,%edx
f0104a84:	0f 49 d0             	cmovns %eax,%edx
f0104a87:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104a8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f0104a8d:	e9 5f ff ff ff       	jmp    f01049f1 <vprintfmt+0x55>

f0104a92 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
f0104a92:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
f0104a95:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f0104a9c:	e9 50 ff ff ff       	jmp    f01049f1 <vprintfmt+0x55>
f0104aa1:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104aa4:	89 75 08             	mov    %esi,0x8(%ebp)
f0104aa7:	eb b9                	jmp    f0104a62 <.L34+0x14>

f0104aa9 <.L27>:
			lflag++;
f0104aa9:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104aad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
f0104ab0:	e9 3c ff ff ff       	jmp    f01049f1 <vprintfmt+0x55>

f0104ab5 <.L30>:
f0104ab5:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
f0104ab8:	8b 45 14             	mov    0x14(%ebp),%eax
f0104abb:	8d 58 04             	lea    0x4(%eax),%ebx
f0104abe:	83 ec 08             	sub    $0x8,%esp
f0104ac1:	57                   	push   %edi
f0104ac2:	ff 30                	pushl  (%eax)
f0104ac4:	ff d6                	call   *%esi
			break;
f0104ac6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0104ac9:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
f0104acc:	e9 c6 02 00 00       	jmp    f0104d97 <.L25+0x45>

f0104ad1 <.L28>:
f0104ad1:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
f0104ad4:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ad7:	8d 58 04             	lea    0x4(%eax),%ebx
f0104ada:	8b 00                	mov    (%eax),%eax
f0104adc:	99                   	cltd   
f0104add:	31 d0                	xor    %edx,%eax
f0104adf:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0104ae1:	83 f8 06             	cmp    $0x6,%eax
f0104ae4:	7f 27                	jg     f0104b0d <.L28+0x3c>
f0104ae6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0104ae9:	8b 14 82             	mov    (%edx,%eax,4),%edx
f0104aec:	85 d2                	test   %edx,%edx
f0104aee:	74 1d                	je     f0104b0d <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
f0104af0:	52                   	push   %edx
f0104af1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104af4:	8d 80 ff 8a f7 ff    	lea    -0x87501(%eax),%eax
f0104afa:	50                   	push   %eax
f0104afb:	57                   	push   %edi
f0104afc:	56                   	push   %esi
f0104afd:	e8 79 fe ff ff       	call   f010497b <printfmt>
f0104b02:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104b05:	89 5d 14             	mov    %ebx,0x14(%ebp)
f0104b08:	e9 8a 02 00 00       	jmp    f0104d97 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
f0104b0d:	50                   	push   %eax
f0104b0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104b11:	8d 80 ea 9a f7 ff    	lea    -0x86516(%eax),%eax
f0104b17:	50                   	push   %eax
f0104b18:	57                   	push   %edi
f0104b19:	56                   	push   %esi
f0104b1a:	e8 5c fe ff ff       	call   f010497b <printfmt>
f0104b1f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104b22:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0104b25:	e9 6d 02 00 00       	jmp    f0104d97 <.L25+0x45>

f0104b2a <.L24>:
f0104b2a:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
f0104b2d:	8b 45 14             	mov    0x14(%ebp),%eax
f0104b30:	83 c0 04             	add    $0x4,%eax
f0104b33:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0104b36:	8b 45 14             	mov    0x14(%ebp),%eax
f0104b39:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f0104b3b:	85 d2                	test   %edx,%edx
f0104b3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104b40:	8d 80 e3 9a f7 ff    	lea    -0x8651d(%eax),%eax
f0104b46:	0f 45 c2             	cmovne %edx,%eax
f0104b49:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f0104b4c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0104b50:	7e 06                	jle    f0104b58 <.L24+0x2e>
f0104b52:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f0104b56:	75 0d                	jne    f0104b65 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
f0104b58:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0104b5b:	89 c3                	mov    %eax,%ebx
f0104b5d:	03 45 d4             	add    -0x2c(%ebp),%eax
f0104b60:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0104b63:	eb 58                	jmp    f0104bbd <.L24+0x93>
f0104b65:	83 ec 08             	sub    $0x8,%esp
f0104b68:	ff 75 d8             	pushl  -0x28(%ebp)
f0104b6b:	ff 75 c8             	pushl  -0x38(%ebp)
f0104b6e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104b71:	e8 81 04 00 00       	call   f0104ff7 <strnlen>
f0104b76:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104b79:	29 c2                	sub    %eax,%edx
f0104b7b:	89 55 bc             	mov    %edx,-0x44(%ebp)
f0104b7e:	83 c4 10             	add    $0x10,%esp
f0104b81:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
f0104b83:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0104b87:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0104b8a:	85 db                	test   %ebx,%ebx
f0104b8c:	7e 11                	jle    f0104b9f <.L24+0x75>
					putch(padc, putdat);
f0104b8e:	83 ec 08             	sub    $0x8,%esp
f0104b91:	57                   	push   %edi
f0104b92:	ff 75 d4             	pushl  -0x2c(%ebp)
f0104b95:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0104b97:	83 eb 01             	sub    $0x1,%ebx
f0104b9a:	83 c4 10             	add    $0x10,%esp
f0104b9d:	eb eb                	jmp    f0104b8a <.L24+0x60>
f0104b9f:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0104ba2:	85 d2                	test   %edx,%edx
f0104ba4:	b8 00 00 00 00       	mov    $0x0,%eax
f0104ba9:	0f 49 c2             	cmovns %edx,%eax
f0104bac:	29 c2                	sub    %eax,%edx
f0104bae:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0104bb1:	eb a5                	jmp    f0104b58 <.L24+0x2e>
					putch(ch, putdat);
f0104bb3:	83 ec 08             	sub    $0x8,%esp
f0104bb6:	57                   	push   %edi
f0104bb7:	52                   	push   %edx
f0104bb8:	ff d6                	call   *%esi
f0104bba:	83 c4 10             	add    $0x10,%esp
f0104bbd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0104bc0:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0104bc2:	83 c3 01             	add    $0x1,%ebx
f0104bc5:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f0104bc9:	0f be d0             	movsbl %al,%edx
f0104bcc:	85 d2                	test   %edx,%edx
f0104bce:	74 4b                	je     f0104c1b <.L24+0xf1>
f0104bd0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0104bd4:	78 06                	js     f0104bdc <.L24+0xb2>
f0104bd6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0104bda:	78 1e                	js     f0104bfa <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
f0104bdc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0104be0:	74 d1                	je     f0104bb3 <.L24+0x89>
f0104be2:	0f be c0             	movsbl %al,%eax
f0104be5:	83 e8 20             	sub    $0x20,%eax
f0104be8:	83 f8 5e             	cmp    $0x5e,%eax
f0104beb:	76 c6                	jbe    f0104bb3 <.L24+0x89>
					putch('?', putdat);
f0104bed:	83 ec 08             	sub    $0x8,%esp
f0104bf0:	57                   	push   %edi
f0104bf1:	6a 3f                	push   $0x3f
f0104bf3:	ff d6                	call   *%esi
f0104bf5:	83 c4 10             	add    $0x10,%esp
f0104bf8:	eb c3                	jmp    f0104bbd <.L24+0x93>
f0104bfa:	89 cb                	mov    %ecx,%ebx
f0104bfc:	eb 0e                	jmp    f0104c0c <.L24+0xe2>
				putch(' ', putdat);
f0104bfe:	83 ec 08             	sub    $0x8,%esp
f0104c01:	57                   	push   %edi
f0104c02:	6a 20                	push   $0x20
f0104c04:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0104c06:	83 eb 01             	sub    $0x1,%ebx
f0104c09:	83 c4 10             	add    $0x10,%esp
f0104c0c:	85 db                	test   %ebx,%ebx
f0104c0e:	7f ee                	jg     f0104bfe <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
f0104c10:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0104c13:	89 45 14             	mov    %eax,0x14(%ebp)
f0104c16:	e9 7c 01 00 00       	jmp    f0104d97 <.L25+0x45>
f0104c1b:	89 cb                	mov    %ecx,%ebx
f0104c1d:	eb ed                	jmp    f0104c0c <.L24+0xe2>

f0104c1f <.L29>:
f0104c1f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0104c22:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f0104c25:	83 f9 01             	cmp    $0x1,%ecx
f0104c28:	7f 1b                	jg     f0104c45 <.L29+0x26>
	else if (lflag)
f0104c2a:	85 c9                	test   %ecx,%ecx
f0104c2c:	74 63                	je     f0104c91 <.L29+0x72>
		return va_arg(*ap, long);
f0104c2e:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c31:	8b 00                	mov    (%eax),%eax
f0104c33:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104c36:	99                   	cltd   
f0104c37:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104c3a:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c3d:	8d 40 04             	lea    0x4(%eax),%eax
f0104c40:	89 45 14             	mov    %eax,0x14(%ebp)
f0104c43:	eb 17                	jmp    f0104c5c <.L29+0x3d>
		return va_arg(*ap, long long);
f0104c45:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c48:	8b 50 04             	mov    0x4(%eax),%edx
f0104c4b:	8b 00                	mov    (%eax),%eax
f0104c4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104c50:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104c53:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c56:	8d 40 08             	lea    0x8(%eax),%eax
f0104c59:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f0104c5c:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104c5f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f0104c62:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f0104c67:	85 c9                	test   %ecx,%ecx
f0104c69:	0f 89 0e 01 00 00    	jns    f0104d7d <.L25+0x2b>
				putch('-', putdat);
f0104c6f:	83 ec 08             	sub    $0x8,%esp
f0104c72:	57                   	push   %edi
f0104c73:	6a 2d                	push   $0x2d
f0104c75:	ff d6                	call   *%esi
				num = -(long long) num;
f0104c77:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104c7a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0104c7d:	f7 da                	neg    %edx
f0104c7f:	83 d1 00             	adc    $0x0,%ecx
f0104c82:	f7 d9                	neg    %ecx
f0104c84:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0104c87:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104c8c:	e9 ec 00 00 00       	jmp    f0104d7d <.L25+0x2b>
		return va_arg(*ap, int);
f0104c91:	8b 45 14             	mov    0x14(%ebp),%eax
f0104c94:	8b 00                	mov    (%eax),%eax
f0104c96:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104c99:	99                   	cltd   
f0104c9a:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104c9d:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ca0:	8d 40 04             	lea    0x4(%eax),%eax
f0104ca3:	89 45 14             	mov    %eax,0x14(%ebp)
f0104ca6:	eb b4                	jmp    f0104c5c <.L29+0x3d>

f0104ca8 <.L23>:
f0104ca8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0104cab:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f0104cae:	83 f9 01             	cmp    $0x1,%ecx
f0104cb1:	7f 1e                	jg     f0104cd1 <.L23+0x29>
	else if (lflag)
f0104cb3:	85 c9                	test   %ecx,%ecx
f0104cb5:	74 32                	je     f0104ce9 <.L23+0x41>
		return va_arg(*ap, unsigned long);
f0104cb7:	8b 45 14             	mov    0x14(%ebp),%eax
f0104cba:	8b 10                	mov    (%eax),%edx
f0104cbc:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104cc1:	8d 40 04             	lea    0x4(%eax),%eax
f0104cc4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104cc7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
f0104ccc:	e9 ac 00 00 00       	jmp    f0104d7d <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f0104cd1:	8b 45 14             	mov    0x14(%ebp),%eax
f0104cd4:	8b 10                	mov    (%eax),%edx
f0104cd6:	8b 48 04             	mov    0x4(%eax),%ecx
f0104cd9:	8d 40 08             	lea    0x8(%eax),%eax
f0104cdc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104cdf:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
f0104ce4:	e9 94 00 00 00       	jmp    f0104d7d <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f0104ce9:	8b 45 14             	mov    0x14(%ebp),%eax
f0104cec:	8b 10                	mov    (%eax),%edx
f0104cee:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104cf3:	8d 40 04             	lea    0x4(%eax),%eax
f0104cf6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104cf9:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
f0104cfe:	eb 7d                	jmp    f0104d7d <.L25+0x2b>

f0104d00 <.L26>:
f0104d00:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0104d03:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f0104d06:	83 f9 01             	cmp    $0x1,%ecx
f0104d09:	7f 1b                	jg     f0104d26 <.L26+0x26>
	else if (lflag)
f0104d0b:	85 c9                	test   %ecx,%ecx
f0104d0d:	74 2c                	je     f0104d3b <.L26+0x3b>
		return va_arg(*ap, unsigned long);
f0104d0f:	8b 45 14             	mov    0x14(%ebp),%eax
f0104d12:	8b 10                	mov    (%eax),%edx
f0104d14:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104d19:	8d 40 04             	lea    0x4(%eax),%eax
f0104d1c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0104d1f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
f0104d24:	eb 57                	jmp    f0104d7d <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f0104d26:	8b 45 14             	mov    0x14(%ebp),%eax
f0104d29:	8b 10                	mov    (%eax),%edx
f0104d2b:	8b 48 04             	mov    0x4(%eax),%ecx
f0104d2e:	8d 40 08             	lea    0x8(%eax),%eax
f0104d31:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0104d34:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
f0104d39:	eb 42                	jmp    f0104d7d <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f0104d3b:	8b 45 14             	mov    0x14(%ebp),%eax
f0104d3e:	8b 10                	mov    (%eax),%edx
f0104d40:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104d45:	8d 40 04             	lea    0x4(%eax),%eax
f0104d48:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0104d4b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
f0104d50:	eb 2b                	jmp    f0104d7d <.L25+0x2b>

f0104d52 <.L25>:
f0104d52:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
f0104d55:	83 ec 08             	sub    $0x8,%esp
f0104d58:	57                   	push   %edi
f0104d59:	6a 30                	push   $0x30
f0104d5b:	ff d6                	call   *%esi
			putch('x', putdat);
f0104d5d:	83 c4 08             	add    $0x8,%esp
f0104d60:	57                   	push   %edi
f0104d61:	6a 78                	push   $0x78
f0104d63:	ff d6                	call   *%esi
			num = (unsigned long long)
f0104d65:	8b 45 14             	mov    0x14(%ebp),%eax
f0104d68:	8b 10                	mov    (%eax),%edx
f0104d6a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f0104d6f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0104d72:	8d 40 04             	lea    0x4(%eax),%eax
f0104d75:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104d78:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f0104d7d:	83 ec 0c             	sub    $0xc,%esp
f0104d80:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
f0104d84:	53                   	push   %ebx
f0104d85:	ff 75 d4             	pushl  -0x2c(%ebp)
f0104d88:	50                   	push   %eax
f0104d89:	51                   	push   %ecx
f0104d8a:	52                   	push   %edx
f0104d8b:	89 fa                	mov    %edi,%edx
f0104d8d:	89 f0                	mov    %esi,%eax
f0104d8f:	e8 08 fb ff ff       	call   f010489c <printnum>
			break;
f0104d94:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f0104d97:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0104d9a:	83 c3 01             	add    $0x1,%ebx
f0104d9d:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
f0104da1:	83 f8 25             	cmp    $0x25,%eax
f0104da4:	0f 84 23 fc ff ff    	je     f01049cd <vprintfmt+0x31>
			if (ch == '\0')
f0104daa:	85 c0                	test   %eax,%eax
f0104dac:	0f 84 97 00 00 00    	je     f0104e49 <.L20+0x23>
			putch(ch, putdat);
f0104db2:	83 ec 08             	sub    $0x8,%esp
f0104db5:	57                   	push   %edi
f0104db6:	50                   	push   %eax
f0104db7:	ff d6                	call   *%esi
f0104db9:	83 c4 10             	add    $0x10,%esp
f0104dbc:	eb dc                	jmp    f0104d9a <.L25+0x48>

f0104dbe <.L21>:
f0104dbe:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0104dc1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
f0104dc4:	83 f9 01             	cmp    $0x1,%ecx
f0104dc7:	7f 1b                	jg     f0104de4 <.L21+0x26>
	else if (lflag)
f0104dc9:	85 c9                	test   %ecx,%ecx
f0104dcb:	74 2c                	je     f0104df9 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
f0104dcd:	8b 45 14             	mov    0x14(%ebp),%eax
f0104dd0:	8b 10                	mov    (%eax),%edx
f0104dd2:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104dd7:	8d 40 04             	lea    0x4(%eax),%eax
f0104dda:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104ddd:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
f0104de2:	eb 99                	jmp    f0104d7d <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
f0104de4:	8b 45 14             	mov    0x14(%ebp),%eax
f0104de7:	8b 10                	mov    (%eax),%edx
f0104de9:	8b 48 04             	mov    0x4(%eax),%ecx
f0104dec:	8d 40 08             	lea    0x8(%eax),%eax
f0104def:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104df2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
f0104df7:	eb 84                	jmp    f0104d7d <.L25+0x2b>
		return va_arg(*ap, unsigned int);
f0104df9:	8b 45 14             	mov    0x14(%ebp),%eax
f0104dfc:	8b 10                	mov    (%eax),%edx
f0104dfe:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104e03:	8d 40 04             	lea    0x4(%eax),%eax
f0104e06:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104e09:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
f0104e0e:	e9 6a ff ff ff       	jmp    f0104d7d <.L25+0x2b>

f0104e13 <.L35>:
f0104e13:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
f0104e16:	83 ec 08             	sub    $0x8,%esp
f0104e19:	57                   	push   %edi
f0104e1a:	6a 25                	push   $0x25
f0104e1c:	ff d6                	call   *%esi
			break;
f0104e1e:	83 c4 10             	add    $0x10,%esp
f0104e21:	e9 71 ff ff ff       	jmp    f0104d97 <.L25+0x45>

f0104e26 <.L20>:
f0104e26:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
f0104e29:	83 ec 08             	sub    $0x8,%esp
f0104e2c:	57                   	push   %edi
f0104e2d:	6a 25                	push   $0x25
f0104e2f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0104e31:	83 c4 10             	add    $0x10,%esp
f0104e34:	89 d8                	mov    %ebx,%eax
f0104e36:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0104e3a:	74 05                	je     f0104e41 <.L20+0x1b>
f0104e3c:	83 e8 01             	sub    $0x1,%eax
f0104e3f:	eb f5                	jmp    f0104e36 <.L20+0x10>
f0104e41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104e44:	e9 4e ff ff ff       	jmp    f0104d97 <.L25+0x45>
}
f0104e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104e4c:	5b                   	pop    %ebx
f0104e4d:	5e                   	pop    %esi
f0104e4e:	5f                   	pop    %edi
f0104e4f:	5d                   	pop    %ebp
f0104e50:	c3                   	ret    

f0104e51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0104e51:	f3 0f 1e fb          	endbr32 
f0104e55:	55                   	push   %ebp
f0104e56:	89 e5                	mov    %esp,%ebp
f0104e58:	53                   	push   %ebx
f0104e59:	83 ec 14             	sub    $0x14,%esp
f0104e5c:	e8 12 b3 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0104e61:	81 c3 bb 81 08 00    	add    $0x881bb,%ebx
f0104e67:	8b 45 08             	mov    0x8(%ebp),%eax
f0104e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0104e6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104e70:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0104e74:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0104e77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0104e7e:	85 c0                	test   %eax,%eax
f0104e80:	74 2b                	je     f0104ead <vsnprintf+0x5c>
f0104e82:	85 d2                	test   %edx,%edx
f0104e84:	7e 27                	jle    f0104ead <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0104e86:	ff 75 14             	pushl  0x14(%ebp)
f0104e89:	ff 75 10             	pushl  0x10(%ebp)
f0104e8c:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0104e8f:	50                   	push   %eax
f0104e90:	8d 83 3e 79 f7 ff    	lea    -0x886c2(%ebx),%eax
f0104e96:	50                   	push   %eax
f0104e97:	e8 00 fb ff ff       	call   f010499c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0104e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104e9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0104ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104ea5:	83 c4 10             	add    $0x10,%esp
}
f0104ea8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104eab:	c9                   	leave  
f0104eac:	c3                   	ret    
		return -E_INVAL;
f0104ead:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104eb2:	eb f4                	jmp    f0104ea8 <vsnprintf+0x57>

f0104eb4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0104eb4:	f3 0f 1e fb          	endbr32 
f0104eb8:	55                   	push   %ebp
f0104eb9:	89 e5                	mov    %esp,%ebp
f0104ebb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0104ebe:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0104ec1:	50                   	push   %eax
f0104ec2:	ff 75 10             	pushl  0x10(%ebp)
f0104ec5:	ff 75 0c             	pushl  0xc(%ebp)
f0104ec8:	ff 75 08             	pushl  0x8(%ebp)
f0104ecb:	e8 81 ff ff ff       	call   f0104e51 <vsnprintf>
	va_end(ap);

	return rc;
}
f0104ed0:	c9                   	leave  
f0104ed1:	c3                   	ret    

f0104ed2 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0104ed2:	f3 0f 1e fb          	endbr32 
f0104ed6:	55                   	push   %ebp
f0104ed7:	89 e5                	mov    %esp,%ebp
f0104ed9:	57                   	push   %edi
f0104eda:	56                   	push   %esi
f0104edb:	53                   	push   %ebx
f0104edc:	83 ec 1c             	sub    $0x1c,%esp
f0104edf:	e8 8f b2 ff ff       	call   f0100173 <__x86.get_pc_thunk.bx>
f0104ee4:	81 c3 38 81 08 00    	add    $0x88138,%ebx
f0104eea:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0104eed:	85 c0                	test   %eax,%eax
f0104eef:	74 13                	je     f0104f04 <readline+0x32>
		cprintf("%s", prompt);
f0104ef1:	83 ec 08             	sub    $0x8,%esp
f0104ef4:	50                   	push   %eax
f0104ef5:	8d 83 ff 8a f7 ff    	lea    -0x87501(%ebx),%eax
f0104efb:	50                   	push   %eax
f0104efc:	e8 c3 eb ff ff       	call   f0103ac4 <cprintf>
f0104f01:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f0104f04:	83 ec 0c             	sub    $0xc,%esp
f0104f07:	6a 00                	push   $0x0
f0104f09:	e8 0f b8 ff ff       	call   f010071d <iscons>
f0104f0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104f11:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0104f14:	bf 00 00 00 00       	mov    $0x0,%edi
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
			if (echoing)
				cputchar(c);
			buf[i++] = c;
f0104f19:	8d 83 e4 2b 00 00    	lea    0x2be4(%ebx),%eax
f0104f1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104f22:	eb 51                	jmp    f0104f75 <readline+0xa3>
			cprintf("read error: %e\n", c);
f0104f24:	83 ec 08             	sub    $0x8,%esp
f0104f27:	50                   	push   %eax
f0104f28:	8d 83 b4 9c f7 ff    	lea    -0x8634c(%ebx),%eax
f0104f2e:	50                   	push   %eax
f0104f2f:	e8 90 eb ff ff       	call   f0103ac4 <cprintf>
			return NULL;
f0104f34:	83 c4 10             	add    $0x10,%esp
f0104f37:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0104f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104f3f:	5b                   	pop    %ebx
f0104f40:	5e                   	pop    %esi
f0104f41:	5f                   	pop    %edi
f0104f42:	5d                   	pop    %ebp
f0104f43:	c3                   	ret    
			if (echoing)
f0104f44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104f48:	75 05                	jne    f0104f4f <readline+0x7d>
			i--;
f0104f4a:	83 ef 01             	sub    $0x1,%edi
f0104f4d:	eb 26                	jmp    f0104f75 <readline+0xa3>
				cputchar('\b');
f0104f4f:	83 ec 0c             	sub    $0xc,%esp
f0104f52:	6a 08                	push   $0x8
f0104f54:	e8 9b b7 ff ff       	call   f01006f4 <cputchar>
f0104f59:	83 c4 10             	add    $0x10,%esp
f0104f5c:	eb ec                	jmp    f0104f4a <readline+0x78>
				cputchar(c);
f0104f5e:	83 ec 0c             	sub    $0xc,%esp
f0104f61:	56                   	push   %esi
f0104f62:	e8 8d b7 ff ff       	call   f01006f4 <cputchar>
f0104f67:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f0104f6a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0104f6d:	89 f0                	mov    %esi,%eax
f0104f6f:	88 04 39             	mov    %al,(%ecx,%edi,1)
f0104f72:	8d 7f 01             	lea    0x1(%edi),%edi
		c = getchar();
f0104f75:	e8 8e b7 ff ff       	call   f0100708 <getchar>
f0104f7a:	89 c6                	mov    %eax,%esi
		if (c < 0) {
f0104f7c:	85 c0                	test   %eax,%eax
f0104f7e:	78 a4                	js     f0104f24 <readline+0x52>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0104f80:	83 f8 08             	cmp    $0x8,%eax
f0104f83:	0f 94 c2             	sete   %dl
f0104f86:	83 f8 7f             	cmp    $0x7f,%eax
f0104f89:	0f 94 c0             	sete   %al
f0104f8c:	08 c2                	or     %al,%dl
f0104f8e:	74 04                	je     f0104f94 <readline+0xc2>
f0104f90:	85 ff                	test   %edi,%edi
f0104f92:	7f b0                	jg     f0104f44 <readline+0x72>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0104f94:	83 fe 1f             	cmp    $0x1f,%esi
f0104f97:	7e 10                	jle    f0104fa9 <readline+0xd7>
f0104f99:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
f0104f9f:	7f 08                	jg     f0104fa9 <readline+0xd7>
			if (echoing)
f0104fa1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104fa5:	74 c3                	je     f0104f6a <readline+0x98>
f0104fa7:	eb b5                	jmp    f0104f5e <readline+0x8c>
		} else if (c == '\n' || c == '\r') {
f0104fa9:	83 fe 0a             	cmp    $0xa,%esi
f0104fac:	74 05                	je     f0104fb3 <readline+0xe1>
f0104fae:	83 fe 0d             	cmp    $0xd,%esi
f0104fb1:	75 c2                	jne    f0104f75 <readline+0xa3>
			if (echoing)
f0104fb3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104fb7:	75 13                	jne    f0104fcc <readline+0xfa>
			buf[i] = 0;
f0104fb9:	c6 84 3b e4 2b 00 00 	movb   $0x0,0x2be4(%ebx,%edi,1)
f0104fc0:	00 
			return buf;
f0104fc1:	8d 83 e4 2b 00 00    	lea    0x2be4(%ebx),%eax
f0104fc7:	e9 70 ff ff ff       	jmp    f0104f3c <readline+0x6a>
				cputchar('\n');
f0104fcc:	83 ec 0c             	sub    $0xc,%esp
f0104fcf:	6a 0a                	push   $0xa
f0104fd1:	e8 1e b7 ff ff       	call   f01006f4 <cputchar>
f0104fd6:	83 c4 10             	add    $0x10,%esp
f0104fd9:	eb de                	jmp    f0104fb9 <readline+0xe7>

f0104fdb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0104fdb:	f3 0f 1e fb          	endbr32 
f0104fdf:	55                   	push   %ebp
f0104fe0:	89 e5                	mov    %esp,%ebp
f0104fe2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0104fe5:	b8 00 00 00 00       	mov    $0x0,%eax
f0104fea:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0104fee:	74 05                	je     f0104ff5 <strlen+0x1a>
		n++;
f0104ff0:	83 c0 01             	add    $0x1,%eax
f0104ff3:	eb f5                	jmp    f0104fea <strlen+0xf>
	return n;
}
f0104ff5:	5d                   	pop    %ebp
f0104ff6:	c3                   	ret    

f0104ff7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0104ff7:	f3 0f 1e fb          	endbr32 
f0104ffb:	55                   	push   %ebp
f0104ffc:	89 e5                	mov    %esp,%ebp
f0104ffe:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105001:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105004:	b8 00 00 00 00       	mov    $0x0,%eax
f0105009:	39 d0                	cmp    %edx,%eax
f010500b:	74 0d                	je     f010501a <strnlen+0x23>
f010500d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0105011:	74 05                	je     f0105018 <strnlen+0x21>
		n++;
f0105013:	83 c0 01             	add    $0x1,%eax
f0105016:	eb f1                	jmp    f0105009 <strnlen+0x12>
f0105018:	89 c2                	mov    %eax,%edx
	return n;
}
f010501a:	89 d0                	mov    %edx,%eax
f010501c:	5d                   	pop    %ebp
f010501d:	c3                   	ret    

f010501e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010501e:	f3 0f 1e fb          	endbr32 
f0105022:	55                   	push   %ebp
f0105023:	89 e5                	mov    %esp,%ebp
f0105025:	53                   	push   %ebx
f0105026:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105029:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010502c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105031:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f0105035:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f0105038:	83 c0 01             	add    $0x1,%eax
f010503b:	84 d2                	test   %dl,%dl
f010503d:	75 f2                	jne    f0105031 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
f010503f:	89 c8                	mov    %ecx,%eax
f0105041:	5b                   	pop    %ebx
f0105042:	5d                   	pop    %ebp
f0105043:	c3                   	ret    

f0105044 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105044:	f3 0f 1e fb          	endbr32 
f0105048:	55                   	push   %ebp
f0105049:	89 e5                	mov    %esp,%ebp
f010504b:	53                   	push   %ebx
f010504c:	83 ec 10             	sub    $0x10,%esp
f010504f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105052:	53                   	push   %ebx
f0105053:	e8 83 ff ff ff       	call   f0104fdb <strlen>
f0105058:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f010505b:	ff 75 0c             	pushl  0xc(%ebp)
f010505e:	01 d8                	add    %ebx,%eax
f0105060:	50                   	push   %eax
f0105061:	e8 b8 ff ff ff       	call   f010501e <strcpy>
	return dst;
}
f0105066:	89 d8                	mov    %ebx,%eax
f0105068:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010506b:	c9                   	leave  
f010506c:	c3                   	ret    

f010506d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f010506d:	f3 0f 1e fb          	endbr32 
f0105071:	55                   	push   %ebp
f0105072:	89 e5                	mov    %esp,%ebp
f0105074:	56                   	push   %esi
f0105075:	53                   	push   %ebx
f0105076:	8b 75 08             	mov    0x8(%ebp),%esi
f0105079:	8b 55 0c             	mov    0xc(%ebp),%edx
f010507c:	89 f3                	mov    %esi,%ebx
f010507e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105081:	89 f0                	mov    %esi,%eax
f0105083:	39 d8                	cmp    %ebx,%eax
f0105085:	74 11                	je     f0105098 <strncpy+0x2b>
		*dst++ = *src;
f0105087:	83 c0 01             	add    $0x1,%eax
f010508a:	0f b6 0a             	movzbl (%edx),%ecx
f010508d:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0105090:	80 f9 01             	cmp    $0x1,%cl
f0105093:	83 da ff             	sbb    $0xffffffff,%edx
f0105096:	eb eb                	jmp    f0105083 <strncpy+0x16>
	}
	return ret;
}
f0105098:	89 f0                	mov    %esi,%eax
f010509a:	5b                   	pop    %ebx
f010509b:	5e                   	pop    %esi
f010509c:	5d                   	pop    %ebp
f010509d:	c3                   	ret    

f010509e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f010509e:	f3 0f 1e fb          	endbr32 
f01050a2:	55                   	push   %ebp
f01050a3:	89 e5                	mov    %esp,%ebp
f01050a5:	56                   	push   %esi
f01050a6:	53                   	push   %ebx
f01050a7:	8b 75 08             	mov    0x8(%ebp),%esi
f01050aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01050ad:	8b 55 10             	mov    0x10(%ebp),%edx
f01050b0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01050b2:	85 d2                	test   %edx,%edx
f01050b4:	74 21                	je     f01050d7 <strlcpy+0x39>
f01050b6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01050ba:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01050bc:	39 c2                	cmp    %eax,%edx
f01050be:	74 14                	je     f01050d4 <strlcpy+0x36>
f01050c0:	0f b6 19             	movzbl (%ecx),%ebx
f01050c3:	84 db                	test   %bl,%bl
f01050c5:	74 0b                	je     f01050d2 <strlcpy+0x34>
			*dst++ = *src++;
f01050c7:	83 c1 01             	add    $0x1,%ecx
f01050ca:	83 c2 01             	add    $0x1,%edx
f01050cd:	88 5a ff             	mov    %bl,-0x1(%edx)
f01050d0:	eb ea                	jmp    f01050bc <strlcpy+0x1e>
f01050d2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f01050d4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01050d7:	29 f0                	sub    %esi,%eax
}
f01050d9:	5b                   	pop    %ebx
f01050da:	5e                   	pop    %esi
f01050db:	5d                   	pop    %ebp
f01050dc:	c3                   	ret    

f01050dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01050dd:	f3 0f 1e fb          	endbr32 
f01050e1:	55                   	push   %ebp
f01050e2:	89 e5                	mov    %esp,%ebp
f01050e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01050e7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01050ea:	0f b6 01             	movzbl (%ecx),%eax
f01050ed:	84 c0                	test   %al,%al
f01050ef:	74 0c                	je     f01050fd <strcmp+0x20>
f01050f1:	3a 02                	cmp    (%edx),%al
f01050f3:	75 08                	jne    f01050fd <strcmp+0x20>
		p++, q++;
f01050f5:	83 c1 01             	add    $0x1,%ecx
f01050f8:	83 c2 01             	add    $0x1,%edx
f01050fb:	eb ed                	jmp    f01050ea <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f01050fd:	0f b6 c0             	movzbl %al,%eax
f0105100:	0f b6 12             	movzbl (%edx),%edx
f0105103:	29 d0                	sub    %edx,%eax
}
f0105105:	5d                   	pop    %ebp
f0105106:	c3                   	ret    

f0105107 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0105107:	f3 0f 1e fb          	endbr32 
f010510b:	55                   	push   %ebp
f010510c:	89 e5                	mov    %esp,%ebp
f010510e:	53                   	push   %ebx
f010510f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105112:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105115:	89 c3                	mov    %eax,%ebx
f0105117:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010511a:	eb 06                	jmp    f0105122 <strncmp+0x1b>
		n--, p++, q++;
f010511c:	83 c0 01             	add    $0x1,%eax
f010511f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105122:	39 d8                	cmp    %ebx,%eax
f0105124:	74 16                	je     f010513c <strncmp+0x35>
f0105126:	0f b6 08             	movzbl (%eax),%ecx
f0105129:	84 c9                	test   %cl,%cl
f010512b:	74 04                	je     f0105131 <strncmp+0x2a>
f010512d:	3a 0a                	cmp    (%edx),%cl
f010512f:	74 eb                	je     f010511c <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105131:	0f b6 00             	movzbl (%eax),%eax
f0105134:	0f b6 12             	movzbl (%edx),%edx
f0105137:	29 d0                	sub    %edx,%eax
}
f0105139:	5b                   	pop    %ebx
f010513a:	5d                   	pop    %ebp
f010513b:	c3                   	ret    
		return 0;
f010513c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105141:	eb f6                	jmp    f0105139 <strncmp+0x32>

f0105143 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105143:	f3 0f 1e fb          	endbr32 
f0105147:	55                   	push   %ebp
f0105148:	89 e5                	mov    %esp,%ebp
f010514a:	8b 45 08             	mov    0x8(%ebp),%eax
f010514d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105151:	0f b6 10             	movzbl (%eax),%edx
f0105154:	84 d2                	test   %dl,%dl
f0105156:	74 09                	je     f0105161 <strchr+0x1e>
		if (*s == c)
f0105158:	38 ca                	cmp    %cl,%dl
f010515a:	74 0a                	je     f0105166 <strchr+0x23>
	for (; *s; s++)
f010515c:	83 c0 01             	add    $0x1,%eax
f010515f:	eb f0                	jmp    f0105151 <strchr+0xe>
			return (char *) s;
	return 0;
f0105161:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105166:	5d                   	pop    %ebp
f0105167:	c3                   	ret    

f0105168 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105168:	f3 0f 1e fb          	endbr32 
f010516c:	55                   	push   %ebp
f010516d:	89 e5                	mov    %esp,%ebp
f010516f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105172:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105176:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0105179:	38 ca                	cmp    %cl,%dl
f010517b:	74 09                	je     f0105186 <strfind+0x1e>
f010517d:	84 d2                	test   %dl,%dl
f010517f:	74 05                	je     f0105186 <strfind+0x1e>
	for (; *s; s++)
f0105181:	83 c0 01             	add    $0x1,%eax
f0105184:	eb f0                	jmp    f0105176 <strfind+0xe>
			break;
	return (char *) s;
}
f0105186:	5d                   	pop    %ebp
f0105187:	c3                   	ret    

f0105188 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105188:	f3 0f 1e fb          	endbr32 
f010518c:	55                   	push   %ebp
f010518d:	89 e5                	mov    %esp,%ebp
f010518f:	57                   	push   %edi
f0105190:	56                   	push   %esi
f0105191:	53                   	push   %ebx
f0105192:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105195:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0105198:	85 c9                	test   %ecx,%ecx
f010519a:	74 31                	je     f01051cd <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f010519c:	89 f8                	mov    %edi,%eax
f010519e:	09 c8                	or     %ecx,%eax
f01051a0:	a8 03                	test   $0x3,%al
f01051a2:	75 23                	jne    f01051c7 <memset+0x3f>
		c &= 0xFF;
f01051a4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01051a8:	89 d3                	mov    %edx,%ebx
f01051aa:	c1 e3 08             	shl    $0x8,%ebx
f01051ad:	89 d0                	mov    %edx,%eax
f01051af:	c1 e0 18             	shl    $0x18,%eax
f01051b2:	89 d6                	mov    %edx,%esi
f01051b4:	c1 e6 10             	shl    $0x10,%esi
f01051b7:	09 f0                	or     %esi,%eax
f01051b9:	09 c2                	or     %eax,%edx
f01051bb:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01051bd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01051c0:	89 d0                	mov    %edx,%eax
f01051c2:	fc                   	cld    
f01051c3:	f3 ab                	rep stos %eax,%es:(%edi)
f01051c5:	eb 06                	jmp    f01051cd <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01051c7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01051ca:	fc                   	cld    
f01051cb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01051cd:	89 f8                	mov    %edi,%eax
f01051cf:	5b                   	pop    %ebx
f01051d0:	5e                   	pop    %esi
f01051d1:	5f                   	pop    %edi
f01051d2:	5d                   	pop    %ebp
f01051d3:	c3                   	ret    

f01051d4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01051d4:	f3 0f 1e fb          	endbr32 
f01051d8:	55                   	push   %ebp
f01051d9:	89 e5                	mov    %esp,%ebp
f01051db:	57                   	push   %edi
f01051dc:	56                   	push   %esi
f01051dd:	8b 45 08             	mov    0x8(%ebp),%eax
f01051e0:	8b 75 0c             	mov    0xc(%ebp),%esi
f01051e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f01051e6:	39 c6                	cmp    %eax,%esi
f01051e8:	73 32                	jae    f010521c <memmove+0x48>
f01051ea:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01051ed:	39 c2                	cmp    %eax,%edx
f01051ef:	76 2b                	jbe    f010521c <memmove+0x48>
		s += n;
		d += n;
f01051f1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01051f4:	89 fe                	mov    %edi,%esi
f01051f6:	09 ce                	or     %ecx,%esi
f01051f8:	09 d6                	or     %edx,%esi
f01051fa:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105200:	75 0e                	jne    f0105210 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105202:	83 ef 04             	sub    $0x4,%edi
f0105205:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105208:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f010520b:	fd                   	std    
f010520c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010520e:	eb 09                	jmp    f0105219 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105210:	83 ef 01             	sub    $0x1,%edi
f0105213:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105216:	fd                   	std    
f0105217:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105219:	fc                   	cld    
f010521a:	eb 1a                	jmp    f0105236 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010521c:	89 c2                	mov    %eax,%edx
f010521e:	09 ca                	or     %ecx,%edx
f0105220:	09 f2                	or     %esi,%edx
f0105222:	f6 c2 03             	test   $0x3,%dl
f0105225:	75 0a                	jne    f0105231 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0105227:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f010522a:	89 c7                	mov    %eax,%edi
f010522c:	fc                   	cld    
f010522d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010522f:	eb 05                	jmp    f0105236 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
f0105231:	89 c7                	mov    %eax,%edi
f0105233:	fc                   	cld    
f0105234:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105236:	5e                   	pop    %esi
f0105237:	5f                   	pop    %edi
f0105238:	5d                   	pop    %ebp
f0105239:	c3                   	ret    

f010523a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010523a:	f3 0f 1e fb          	endbr32 
f010523e:	55                   	push   %ebp
f010523f:	89 e5                	mov    %esp,%ebp
f0105241:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0105244:	ff 75 10             	pushl  0x10(%ebp)
f0105247:	ff 75 0c             	pushl  0xc(%ebp)
f010524a:	ff 75 08             	pushl  0x8(%ebp)
f010524d:	e8 82 ff ff ff       	call   f01051d4 <memmove>
}
f0105252:	c9                   	leave  
f0105253:	c3                   	ret    

f0105254 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105254:	f3 0f 1e fb          	endbr32 
f0105258:	55                   	push   %ebp
f0105259:	89 e5                	mov    %esp,%ebp
f010525b:	56                   	push   %esi
f010525c:	53                   	push   %ebx
f010525d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105260:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105263:	89 c6                	mov    %eax,%esi
f0105265:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105268:	39 f0                	cmp    %esi,%eax
f010526a:	74 1c                	je     f0105288 <memcmp+0x34>
		if (*s1 != *s2)
f010526c:	0f b6 08             	movzbl (%eax),%ecx
f010526f:	0f b6 1a             	movzbl (%edx),%ebx
f0105272:	38 d9                	cmp    %bl,%cl
f0105274:	75 08                	jne    f010527e <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0105276:	83 c0 01             	add    $0x1,%eax
f0105279:	83 c2 01             	add    $0x1,%edx
f010527c:	eb ea                	jmp    f0105268 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
f010527e:	0f b6 c1             	movzbl %cl,%eax
f0105281:	0f b6 db             	movzbl %bl,%ebx
f0105284:	29 d8                	sub    %ebx,%eax
f0105286:	eb 05                	jmp    f010528d <memcmp+0x39>
	}

	return 0;
f0105288:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010528d:	5b                   	pop    %ebx
f010528e:	5e                   	pop    %esi
f010528f:	5d                   	pop    %ebp
f0105290:	c3                   	ret    

f0105291 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0105291:	f3 0f 1e fb          	endbr32 
f0105295:	55                   	push   %ebp
f0105296:	89 e5                	mov    %esp,%ebp
f0105298:	8b 45 08             	mov    0x8(%ebp),%eax
f010529b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f010529e:	89 c2                	mov    %eax,%edx
f01052a0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01052a3:	39 d0                	cmp    %edx,%eax
f01052a5:	73 09                	jae    f01052b0 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
f01052a7:	38 08                	cmp    %cl,(%eax)
f01052a9:	74 05                	je     f01052b0 <memfind+0x1f>
	for (; s < ends; s++)
f01052ab:	83 c0 01             	add    $0x1,%eax
f01052ae:	eb f3                	jmp    f01052a3 <memfind+0x12>
			break;
	return (void *) s;
}
f01052b0:	5d                   	pop    %ebp
f01052b1:	c3                   	ret    

f01052b2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01052b2:	f3 0f 1e fb          	endbr32 
f01052b6:	55                   	push   %ebp
f01052b7:	89 e5                	mov    %esp,%ebp
f01052b9:	57                   	push   %edi
f01052ba:	56                   	push   %esi
f01052bb:	53                   	push   %ebx
f01052bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01052bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01052c2:	eb 03                	jmp    f01052c7 <strtol+0x15>
		s++;
f01052c4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01052c7:	0f b6 01             	movzbl (%ecx),%eax
f01052ca:	3c 20                	cmp    $0x20,%al
f01052cc:	74 f6                	je     f01052c4 <strtol+0x12>
f01052ce:	3c 09                	cmp    $0x9,%al
f01052d0:	74 f2                	je     f01052c4 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
f01052d2:	3c 2b                	cmp    $0x2b,%al
f01052d4:	74 2a                	je     f0105300 <strtol+0x4e>
	int neg = 0;
f01052d6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01052db:	3c 2d                	cmp    $0x2d,%al
f01052dd:	74 2b                	je     f010530a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01052df:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01052e5:	75 0f                	jne    f01052f6 <strtol+0x44>
f01052e7:	80 39 30             	cmpb   $0x30,(%ecx)
f01052ea:	74 28                	je     f0105314 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01052ec:	85 db                	test   %ebx,%ebx
f01052ee:	b8 0a 00 00 00       	mov    $0xa,%eax
f01052f3:	0f 44 d8             	cmove  %eax,%ebx
f01052f6:	b8 00 00 00 00       	mov    $0x0,%eax
f01052fb:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01052fe:	eb 46                	jmp    f0105346 <strtol+0x94>
		s++;
f0105300:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105303:	bf 00 00 00 00       	mov    $0x0,%edi
f0105308:	eb d5                	jmp    f01052df <strtol+0x2d>
		s++, neg = 1;
f010530a:	83 c1 01             	add    $0x1,%ecx
f010530d:	bf 01 00 00 00       	mov    $0x1,%edi
f0105312:	eb cb                	jmp    f01052df <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105314:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105318:	74 0e                	je     f0105328 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f010531a:	85 db                	test   %ebx,%ebx
f010531c:	75 d8                	jne    f01052f6 <strtol+0x44>
		s++, base = 8;
f010531e:	83 c1 01             	add    $0x1,%ecx
f0105321:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105326:	eb ce                	jmp    f01052f6 <strtol+0x44>
		s += 2, base = 16;
f0105328:	83 c1 02             	add    $0x2,%ecx
f010532b:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105330:	eb c4                	jmp    f01052f6 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0105332:	0f be d2             	movsbl %dl,%edx
f0105335:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105338:	3b 55 10             	cmp    0x10(%ebp),%edx
f010533b:	7d 3a                	jge    f0105377 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f010533d:	83 c1 01             	add    $0x1,%ecx
f0105340:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105344:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105346:	0f b6 11             	movzbl (%ecx),%edx
f0105349:	8d 72 d0             	lea    -0x30(%edx),%esi
f010534c:	89 f3                	mov    %esi,%ebx
f010534e:	80 fb 09             	cmp    $0x9,%bl
f0105351:	76 df                	jbe    f0105332 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
f0105353:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105356:	89 f3                	mov    %esi,%ebx
f0105358:	80 fb 19             	cmp    $0x19,%bl
f010535b:	77 08                	ja     f0105365 <strtol+0xb3>
			dig = *s - 'a' + 10;
f010535d:	0f be d2             	movsbl %dl,%edx
f0105360:	83 ea 57             	sub    $0x57,%edx
f0105363:	eb d3                	jmp    f0105338 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
f0105365:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105368:	89 f3                	mov    %esi,%ebx
f010536a:	80 fb 19             	cmp    $0x19,%bl
f010536d:	77 08                	ja     f0105377 <strtol+0xc5>
			dig = *s - 'A' + 10;
f010536f:	0f be d2             	movsbl %dl,%edx
f0105372:	83 ea 37             	sub    $0x37,%edx
f0105375:	eb c1                	jmp    f0105338 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105377:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f010537b:	74 05                	je     f0105382 <strtol+0xd0>
		*endptr = (char *) s;
f010537d:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105380:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0105382:	89 c2                	mov    %eax,%edx
f0105384:	f7 da                	neg    %edx
f0105386:	85 ff                	test   %edi,%edi
f0105388:	0f 45 c2             	cmovne %edx,%eax
}
f010538b:	5b                   	pop    %ebx
f010538c:	5e                   	pop    %esi
f010538d:	5f                   	pop    %edi
f010538e:	5d                   	pop    %ebp
f010538f:	c3                   	ret    

f0105390 <__udivdi3>:
f0105390:	f3 0f 1e fb          	endbr32 
f0105394:	55                   	push   %ebp
f0105395:	57                   	push   %edi
f0105396:	56                   	push   %esi
f0105397:	53                   	push   %ebx
f0105398:	83 ec 1c             	sub    $0x1c,%esp
f010539b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010539f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01053a3:	8b 74 24 34          	mov    0x34(%esp),%esi
f01053a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01053ab:	85 d2                	test   %edx,%edx
f01053ad:	75 19                	jne    f01053c8 <__udivdi3+0x38>
f01053af:	39 f3                	cmp    %esi,%ebx
f01053b1:	76 4d                	jbe    f0105400 <__udivdi3+0x70>
f01053b3:	31 ff                	xor    %edi,%edi
f01053b5:	89 e8                	mov    %ebp,%eax
f01053b7:	89 f2                	mov    %esi,%edx
f01053b9:	f7 f3                	div    %ebx
f01053bb:	89 fa                	mov    %edi,%edx
f01053bd:	83 c4 1c             	add    $0x1c,%esp
f01053c0:	5b                   	pop    %ebx
f01053c1:	5e                   	pop    %esi
f01053c2:	5f                   	pop    %edi
f01053c3:	5d                   	pop    %ebp
f01053c4:	c3                   	ret    
f01053c5:	8d 76 00             	lea    0x0(%esi),%esi
f01053c8:	39 f2                	cmp    %esi,%edx
f01053ca:	76 14                	jbe    f01053e0 <__udivdi3+0x50>
f01053cc:	31 ff                	xor    %edi,%edi
f01053ce:	31 c0                	xor    %eax,%eax
f01053d0:	89 fa                	mov    %edi,%edx
f01053d2:	83 c4 1c             	add    $0x1c,%esp
f01053d5:	5b                   	pop    %ebx
f01053d6:	5e                   	pop    %esi
f01053d7:	5f                   	pop    %edi
f01053d8:	5d                   	pop    %ebp
f01053d9:	c3                   	ret    
f01053da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01053e0:	0f bd fa             	bsr    %edx,%edi
f01053e3:	83 f7 1f             	xor    $0x1f,%edi
f01053e6:	75 48                	jne    f0105430 <__udivdi3+0xa0>
f01053e8:	39 f2                	cmp    %esi,%edx
f01053ea:	72 06                	jb     f01053f2 <__udivdi3+0x62>
f01053ec:	31 c0                	xor    %eax,%eax
f01053ee:	39 eb                	cmp    %ebp,%ebx
f01053f0:	77 de                	ja     f01053d0 <__udivdi3+0x40>
f01053f2:	b8 01 00 00 00       	mov    $0x1,%eax
f01053f7:	eb d7                	jmp    f01053d0 <__udivdi3+0x40>
f01053f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105400:	89 d9                	mov    %ebx,%ecx
f0105402:	85 db                	test   %ebx,%ebx
f0105404:	75 0b                	jne    f0105411 <__udivdi3+0x81>
f0105406:	b8 01 00 00 00       	mov    $0x1,%eax
f010540b:	31 d2                	xor    %edx,%edx
f010540d:	f7 f3                	div    %ebx
f010540f:	89 c1                	mov    %eax,%ecx
f0105411:	31 d2                	xor    %edx,%edx
f0105413:	89 f0                	mov    %esi,%eax
f0105415:	f7 f1                	div    %ecx
f0105417:	89 c6                	mov    %eax,%esi
f0105419:	89 e8                	mov    %ebp,%eax
f010541b:	89 f7                	mov    %esi,%edi
f010541d:	f7 f1                	div    %ecx
f010541f:	89 fa                	mov    %edi,%edx
f0105421:	83 c4 1c             	add    $0x1c,%esp
f0105424:	5b                   	pop    %ebx
f0105425:	5e                   	pop    %esi
f0105426:	5f                   	pop    %edi
f0105427:	5d                   	pop    %ebp
f0105428:	c3                   	ret    
f0105429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105430:	89 f9                	mov    %edi,%ecx
f0105432:	b8 20 00 00 00       	mov    $0x20,%eax
f0105437:	29 f8                	sub    %edi,%eax
f0105439:	d3 e2                	shl    %cl,%edx
f010543b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010543f:	89 c1                	mov    %eax,%ecx
f0105441:	89 da                	mov    %ebx,%edx
f0105443:	d3 ea                	shr    %cl,%edx
f0105445:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0105449:	09 d1                	or     %edx,%ecx
f010544b:	89 f2                	mov    %esi,%edx
f010544d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105451:	89 f9                	mov    %edi,%ecx
f0105453:	d3 e3                	shl    %cl,%ebx
f0105455:	89 c1                	mov    %eax,%ecx
f0105457:	d3 ea                	shr    %cl,%edx
f0105459:	89 f9                	mov    %edi,%ecx
f010545b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010545f:	89 eb                	mov    %ebp,%ebx
f0105461:	d3 e6                	shl    %cl,%esi
f0105463:	89 c1                	mov    %eax,%ecx
f0105465:	d3 eb                	shr    %cl,%ebx
f0105467:	09 de                	or     %ebx,%esi
f0105469:	89 f0                	mov    %esi,%eax
f010546b:	f7 74 24 08          	divl   0x8(%esp)
f010546f:	89 d6                	mov    %edx,%esi
f0105471:	89 c3                	mov    %eax,%ebx
f0105473:	f7 64 24 0c          	mull   0xc(%esp)
f0105477:	39 d6                	cmp    %edx,%esi
f0105479:	72 15                	jb     f0105490 <__udivdi3+0x100>
f010547b:	89 f9                	mov    %edi,%ecx
f010547d:	d3 e5                	shl    %cl,%ebp
f010547f:	39 c5                	cmp    %eax,%ebp
f0105481:	73 04                	jae    f0105487 <__udivdi3+0xf7>
f0105483:	39 d6                	cmp    %edx,%esi
f0105485:	74 09                	je     f0105490 <__udivdi3+0x100>
f0105487:	89 d8                	mov    %ebx,%eax
f0105489:	31 ff                	xor    %edi,%edi
f010548b:	e9 40 ff ff ff       	jmp    f01053d0 <__udivdi3+0x40>
f0105490:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0105493:	31 ff                	xor    %edi,%edi
f0105495:	e9 36 ff ff ff       	jmp    f01053d0 <__udivdi3+0x40>
f010549a:	66 90                	xchg   %ax,%ax
f010549c:	66 90                	xchg   %ax,%ax
f010549e:	66 90                	xchg   %ax,%ax

f01054a0 <__umoddi3>:
f01054a0:	f3 0f 1e fb          	endbr32 
f01054a4:	55                   	push   %ebp
f01054a5:	57                   	push   %edi
f01054a6:	56                   	push   %esi
f01054a7:	53                   	push   %ebx
f01054a8:	83 ec 1c             	sub    $0x1c,%esp
f01054ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01054af:	8b 74 24 30          	mov    0x30(%esp),%esi
f01054b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01054b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01054bb:	85 c0                	test   %eax,%eax
f01054bd:	75 19                	jne    f01054d8 <__umoddi3+0x38>
f01054bf:	39 df                	cmp    %ebx,%edi
f01054c1:	76 5d                	jbe    f0105520 <__umoddi3+0x80>
f01054c3:	89 f0                	mov    %esi,%eax
f01054c5:	89 da                	mov    %ebx,%edx
f01054c7:	f7 f7                	div    %edi
f01054c9:	89 d0                	mov    %edx,%eax
f01054cb:	31 d2                	xor    %edx,%edx
f01054cd:	83 c4 1c             	add    $0x1c,%esp
f01054d0:	5b                   	pop    %ebx
f01054d1:	5e                   	pop    %esi
f01054d2:	5f                   	pop    %edi
f01054d3:	5d                   	pop    %ebp
f01054d4:	c3                   	ret    
f01054d5:	8d 76 00             	lea    0x0(%esi),%esi
f01054d8:	89 f2                	mov    %esi,%edx
f01054da:	39 d8                	cmp    %ebx,%eax
f01054dc:	76 12                	jbe    f01054f0 <__umoddi3+0x50>
f01054de:	89 f0                	mov    %esi,%eax
f01054e0:	89 da                	mov    %ebx,%edx
f01054e2:	83 c4 1c             	add    $0x1c,%esp
f01054e5:	5b                   	pop    %ebx
f01054e6:	5e                   	pop    %esi
f01054e7:	5f                   	pop    %edi
f01054e8:	5d                   	pop    %ebp
f01054e9:	c3                   	ret    
f01054ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01054f0:	0f bd e8             	bsr    %eax,%ebp
f01054f3:	83 f5 1f             	xor    $0x1f,%ebp
f01054f6:	75 50                	jne    f0105548 <__umoddi3+0xa8>
f01054f8:	39 d8                	cmp    %ebx,%eax
f01054fa:	0f 82 e0 00 00 00    	jb     f01055e0 <__umoddi3+0x140>
f0105500:	89 d9                	mov    %ebx,%ecx
f0105502:	39 f7                	cmp    %esi,%edi
f0105504:	0f 86 d6 00 00 00    	jbe    f01055e0 <__umoddi3+0x140>
f010550a:	89 d0                	mov    %edx,%eax
f010550c:	89 ca                	mov    %ecx,%edx
f010550e:	83 c4 1c             	add    $0x1c,%esp
f0105511:	5b                   	pop    %ebx
f0105512:	5e                   	pop    %esi
f0105513:	5f                   	pop    %edi
f0105514:	5d                   	pop    %ebp
f0105515:	c3                   	ret    
f0105516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010551d:	8d 76 00             	lea    0x0(%esi),%esi
f0105520:	89 fd                	mov    %edi,%ebp
f0105522:	85 ff                	test   %edi,%edi
f0105524:	75 0b                	jne    f0105531 <__umoddi3+0x91>
f0105526:	b8 01 00 00 00       	mov    $0x1,%eax
f010552b:	31 d2                	xor    %edx,%edx
f010552d:	f7 f7                	div    %edi
f010552f:	89 c5                	mov    %eax,%ebp
f0105531:	89 d8                	mov    %ebx,%eax
f0105533:	31 d2                	xor    %edx,%edx
f0105535:	f7 f5                	div    %ebp
f0105537:	89 f0                	mov    %esi,%eax
f0105539:	f7 f5                	div    %ebp
f010553b:	89 d0                	mov    %edx,%eax
f010553d:	31 d2                	xor    %edx,%edx
f010553f:	eb 8c                	jmp    f01054cd <__umoddi3+0x2d>
f0105541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105548:	89 e9                	mov    %ebp,%ecx
f010554a:	ba 20 00 00 00       	mov    $0x20,%edx
f010554f:	29 ea                	sub    %ebp,%edx
f0105551:	d3 e0                	shl    %cl,%eax
f0105553:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105557:	89 d1                	mov    %edx,%ecx
f0105559:	89 f8                	mov    %edi,%eax
f010555b:	d3 e8                	shr    %cl,%eax
f010555d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0105561:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105565:	8b 54 24 04          	mov    0x4(%esp),%edx
f0105569:	09 c1                	or     %eax,%ecx
f010556b:	89 d8                	mov    %ebx,%eax
f010556d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105571:	89 e9                	mov    %ebp,%ecx
f0105573:	d3 e7                	shl    %cl,%edi
f0105575:	89 d1                	mov    %edx,%ecx
f0105577:	d3 e8                	shr    %cl,%eax
f0105579:	89 e9                	mov    %ebp,%ecx
f010557b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010557f:	d3 e3                	shl    %cl,%ebx
f0105581:	89 c7                	mov    %eax,%edi
f0105583:	89 d1                	mov    %edx,%ecx
f0105585:	89 f0                	mov    %esi,%eax
f0105587:	d3 e8                	shr    %cl,%eax
f0105589:	89 e9                	mov    %ebp,%ecx
f010558b:	89 fa                	mov    %edi,%edx
f010558d:	d3 e6                	shl    %cl,%esi
f010558f:	09 d8                	or     %ebx,%eax
f0105591:	f7 74 24 08          	divl   0x8(%esp)
f0105595:	89 d1                	mov    %edx,%ecx
f0105597:	89 f3                	mov    %esi,%ebx
f0105599:	f7 64 24 0c          	mull   0xc(%esp)
f010559d:	89 c6                	mov    %eax,%esi
f010559f:	89 d7                	mov    %edx,%edi
f01055a1:	39 d1                	cmp    %edx,%ecx
f01055a3:	72 06                	jb     f01055ab <__umoddi3+0x10b>
f01055a5:	75 10                	jne    f01055b7 <__umoddi3+0x117>
f01055a7:	39 c3                	cmp    %eax,%ebx
f01055a9:	73 0c                	jae    f01055b7 <__umoddi3+0x117>
f01055ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
f01055af:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01055b3:	89 d7                	mov    %edx,%edi
f01055b5:	89 c6                	mov    %eax,%esi
f01055b7:	89 ca                	mov    %ecx,%edx
f01055b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01055be:	29 f3                	sub    %esi,%ebx
f01055c0:	19 fa                	sbb    %edi,%edx
f01055c2:	89 d0                	mov    %edx,%eax
f01055c4:	d3 e0                	shl    %cl,%eax
f01055c6:	89 e9                	mov    %ebp,%ecx
f01055c8:	d3 eb                	shr    %cl,%ebx
f01055ca:	d3 ea                	shr    %cl,%edx
f01055cc:	09 d8                	or     %ebx,%eax
f01055ce:	83 c4 1c             	add    $0x1c,%esp
f01055d1:	5b                   	pop    %ebx
f01055d2:	5e                   	pop    %esi
f01055d3:	5f                   	pop    %edi
f01055d4:	5d                   	pop    %ebp
f01055d5:	c3                   	ret    
f01055d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01055dd:	8d 76 00             	lea    0x0(%esi),%esi
f01055e0:	29 fe                	sub    %edi,%esi
f01055e2:	19 c3                	sbb    %eax,%ebx
f01055e4:	89 f2                	mov    %esi,%edx
f01055e6:	89 d9                	mov    %ebx,%ecx
f01055e8:	e9 1d ff ff ff       	jmp    f010550a <__umoddi3+0x6a>
