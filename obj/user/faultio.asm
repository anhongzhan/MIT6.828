
obj/user/faultio.debug:     file format elf32-i386


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
  80002c:	e8 42 00 00 00       	call   800073 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 08             	sub    $0x8,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  80003d:	9c                   	pushf  
  80003e:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003f:	f6 c4 30             	test   $0x30,%ah
  800042:	75 1d                	jne    800061 <umain+0x2e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800044:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800049:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80004e:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	68 ae 24 80 00       	push   $0x8024ae
  800057:	e8 1c 01 00 00       	call   800178 <cprintf>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    
		cprintf("eflags wrong\n");
  800061:	83 ec 0c             	sub    $0xc,%esp
  800064:	68 a0 24 80 00       	push   $0x8024a0
  800069:	e8 0a 01 00 00       	call   800178 <cprintf>
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	eb d1                	jmp    800044 <umain+0x11>

00800073 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800073:	f3 0f 1e fb          	endbr32 
  800077:	55                   	push   %ebp
  800078:	89 e5                	mov    %esp,%ebp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800082:	e8 f7 0a 00 00       	call   800b7e <sys_getenvid>
  800087:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80008f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800094:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800099:	85 db                	test   %ebx,%ebx
  80009b:	7e 07                	jle    8000a4 <libmain+0x31>
		binaryname = argv[0];
  80009d:	8b 06                	mov    (%esi),%eax
  80009f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000a4:	83 ec 08             	sub    $0x8,%esp
  8000a7:	56                   	push   %esi
  8000a8:	53                   	push   %ebx
  8000a9:	e8 85 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ae:	e8 0a 00 00 00       	call   8000bd <exit>
}
  8000b3:	83 c4 10             	add    $0x10,%esp
  8000b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b9:	5b                   	pop    %ebx
  8000ba:	5e                   	pop    %esi
  8000bb:	5d                   	pop    %ebp
  8000bc:	c3                   	ret    

008000bd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000bd:	f3 0f 1e fb          	endbr32 
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000c7:	e8 ac 0f 00 00       	call   801078 <close_all>
	sys_env_destroy(0);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	6a 00                	push   $0x0
  8000d1:	e8 63 0a 00 00       	call   800b39 <sys_env_destroy>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000db:	f3 0f 1e fb          	endbr32 
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	53                   	push   %ebx
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000e9:	8b 13                	mov    (%ebx),%edx
  8000eb:	8d 42 01             	lea    0x1(%edx),%eax
  8000ee:	89 03                	mov    %eax,(%ebx)
  8000f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000fc:	74 09                	je     800107 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000fe:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800102:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800105:	c9                   	leave  
  800106:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	68 ff 00 00 00       	push   $0xff
  80010f:	8d 43 08             	lea    0x8(%ebx),%eax
  800112:	50                   	push   %eax
  800113:	e8 dc 09 00 00       	call   800af4 <sys_cputs>
		b->idx = 0;
  800118:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	eb db                	jmp    8000fe <putch+0x23>

00800123 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800123:	f3 0f 1e fb          	endbr32 
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800130:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800137:	00 00 00 
	b.cnt = 0;
  80013a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800141:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800144:	ff 75 0c             	pushl  0xc(%ebp)
  800147:	ff 75 08             	pushl  0x8(%ebp)
  80014a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800150:	50                   	push   %eax
  800151:	68 db 00 80 00       	push   $0x8000db
  800156:	e8 20 01 00 00       	call   80027b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80015b:	83 c4 08             	add    $0x8,%esp
  80015e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800164:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80016a:	50                   	push   %eax
  80016b:	e8 84 09 00 00       	call   800af4 <sys_cputs>

	return b.cnt;
}
  800170:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800176:	c9                   	leave  
  800177:	c3                   	ret    

00800178 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800178:	f3 0f 1e fb          	endbr32 
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800182:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800185:	50                   	push   %eax
  800186:	ff 75 08             	pushl  0x8(%ebp)
  800189:	e8 95 ff ff ff       	call   800123 <vcprintf>
	va_end(ap);

	return cnt;
}
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	57                   	push   %edi
  800194:	56                   	push   %esi
  800195:	53                   	push   %ebx
  800196:	83 ec 1c             	sub    $0x1c,%esp
  800199:	89 c7                	mov    %eax,%edi
  80019b:	89 d6                	mov    %edx,%esi
  80019d:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a3:	89 d1                	mov    %edx,%ecx
  8001a5:	89 c2                	mov    %eax,%edx
  8001a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001c2:	72 3e                	jb     800202 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	ff 75 18             	pushl  0x18(%ebp)
  8001ca:	83 eb 01             	sub    $0x1,%ebx
  8001cd:	53                   	push   %ebx
  8001ce:	50                   	push   %eax
  8001cf:	83 ec 08             	sub    $0x8,%esp
  8001d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d8:	ff 75 dc             	pushl  -0x24(%ebp)
  8001db:	ff 75 d8             	pushl  -0x28(%ebp)
  8001de:	e8 4d 20 00 00       	call   802230 <__udivdi3>
  8001e3:	83 c4 18             	add    $0x18,%esp
  8001e6:	52                   	push   %edx
  8001e7:	50                   	push   %eax
  8001e8:	89 f2                	mov    %esi,%edx
  8001ea:	89 f8                	mov    %edi,%eax
  8001ec:	e8 9f ff ff ff       	call   800190 <printnum>
  8001f1:	83 c4 20             	add    $0x20,%esp
  8001f4:	eb 13                	jmp    800209 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	56                   	push   %esi
  8001fa:	ff 75 18             	pushl  0x18(%ebp)
  8001fd:	ff d7                	call   *%edi
  8001ff:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800202:	83 eb 01             	sub    $0x1,%ebx
  800205:	85 db                	test   %ebx,%ebx
  800207:	7f ed                	jg     8001f6 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	56                   	push   %esi
  80020d:	83 ec 04             	sub    $0x4,%esp
  800210:	ff 75 e4             	pushl  -0x1c(%ebp)
  800213:	ff 75 e0             	pushl  -0x20(%ebp)
  800216:	ff 75 dc             	pushl  -0x24(%ebp)
  800219:	ff 75 d8             	pushl  -0x28(%ebp)
  80021c:	e8 1f 21 00 00       	call   802340 <__umoddi3>
  800221:	83 c4 14             	add    $0x14,%esp
  800224:	0f be 80 d2 24 80 00 	movsbl 0x8024d2(%eax),%eax
  80022b:	50                   	push   %eax
  80022c:	ff d7                	call   *%edi
}
  80022e:	83 c4 10             	add    $0x10,%esp
  800231:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800234:	5b                   	pop    %ebx
  800235:	5e                   	pop    %esi
  800236:	5f                   	pop    %edi
  800237:	5d                   	pop    %ebp
  800238:	c3                   	ret    

00800239 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800239:	f3 0f 1e fb          	endbr32 
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800243:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800247:	8b 10                	mov    (%eax),%edx
  800249:	3b 50 04             	cmp    0x4(%eax),%edx
  80024c:	73 0a                	jae    800258 <sprintputch+0x1f>
		*b->buf++ = ch;
  80024e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800251:	89 08                	mov    %ecx,(%eax)
  800253:	8b 45 08             	mov    0x8(%ebp),%eax
  800256:	88 02                	mov    %al,(%edx)
}
  800258:	5d                   	pop    %ebp
  800259:	c3                   	ret    

0080025a <printfmt>:
{
  80025a:	f3 0f 1e fb          	endbr32 
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800264:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800267:	50                   	push   %eax
  800268:	ff 75 10             	pushl  0x10(%ebp)
  80026b:	ff 75 0c             	pushl  0xc(%ebp)
  80026e:	ff 75 08             	pushl  0x8(%ebp)
  800271:	e8 05 00 00 00       	call   80027b <vprintfmt>
}
  800276:	83 c4 10             	add    $0x10,%esp
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <vprintfmt>:
{
  80027b:	f3 0f 1e fb          	endbr32 
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	57                   	push   %edi
  800283:	56                   	push   %esi
  800284:	53                   	push   %ebx
  800285:	83 ec 3c             	sub    $0x3c,%esp
  800288:	8b 75 08             	mov    0x8(%ebp),%esi
  80028b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80028e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800291:	e9 8e 03 00 00       	jmp    800624 <vprintfmt+0x3a9>
		padc = ' ';
  800296:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80029a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002a1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002a8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002af:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002b4:	8d 47 01             	lea    0x1(%edi),%eax
  8002b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ba:	0f b6 17             	movzbl (%edi),%edx
  8002bd:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002c0:	3c 55                	cmp    $0x55,%al
  8002c2:	0f 87 df 03 00 00    	ja     8006a7 <vprintfmt+0x42c>
  8002c8:	0f b6 c0             	movzbl %al,%eax
  8002cb:	3e ff 24 85 20 26 80 	notrack jmp *0x802620(,%eax,4)
  8002d2:	00 
  8002d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002d6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002da:	eb d8                	jmp    8002b4 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002df:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002e3:	eb cf                	jmp    8002b4 <vprintfmt+0x39>
  8002e5:	0f b6 d2             	movzbl %dl,%edx
  8002e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002f3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002f6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002fa:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002fd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800300:	83 f9 09             	cmp    $0x9,%ecx
  800303:	77 55                	ja     80035a <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800305:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800308:	eb e9                	jmp    8002f3 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80030a:	8b 45 14             	mov    0x14(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800312:	8b 45 14             	mov    0x14(%ebp),%eax
  800315:	8d 40 04             	lea    0x4(%eax),%eax
  800318:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80031b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80031e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800322:	79 90                	jns    8002b4 <vprintfmt+0x39>
				width = precision, precision = -1;
  800324:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800327:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80032a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800331:	eb 81                	jmp    8002b4 <vprintfmt+0x39>
  800333:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	ba 00 00 00 00       	mov    $0x0,%edx
  80033d:	0f 49 d0             	cmovns %eax,%edx
  800340:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800343:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800346:	e9 69 ff ff ff       	jmp    8002b4 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80034b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80034e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800355:	e9 5a ff ff ff       	jmp    8002b4 <vprintfmt+0x39>
  80035a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80035d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800360:	eb bc                	jmp    80031e <vprintfmt+0xa3>
			lflag++;
  800362:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800368:	e9 47 ff ff ff       	jmp    8002b4 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80036d:	8b 45 14             	mov    0x14(%ebp),%eax
  800370:	8d 78 04             	lea    0x4(%eax),%edi
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	53                   	push   %ebx
  800377:	ff 30                	pushl  (%eax)
  800379:	ff d6                	call   *%esi
			break;
  80037b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80037e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800381:	e9 9b 02 00 00       	jmp    800621 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8d 78 04             	lea    0x4(%eax),%edi
  80038c:	8b 00                	mov    (%eax),%eax
  80038e:	99                   	cltd   
  80038f:	31 d0                	xor    %edx,%eax
  800391:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800393:	83 f8 0f             	cmp    $0xf,%eax
  800396:	7f 23                	jg     8003bb <vprintfmt+0x140>
  800398:	8b 14 85 80 27 80 00 	mov    0x802780(,%eax,4),%edx
  80039f:	85 d2                	test   %edx,%edx
  8003a1:	74 18                	je     8003bb <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003a3:	52                   	push   %edx
  8003a4:	68 b5 28 80 00       	push   $0x8028b5
  8003a9:	53                   	push   %ebx
  8003aa:	56                   	push   %esi
  8003ab:	e8 aa fe ff ff       	call   80025a <printfmt>
  8003b0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003b6:	e9 66 02 00 00       	jmp    800621 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003bb:	50                   	push   %eax
  8003bc:	68 ea 24 80 00       	push   $0x8024ea
  8003c1:	53                   	push   %ebx
  8003c2:	56                   	push   %esi
  8003c3:	e8 92 fe ff ff       	call   80025a <printfmt>
  8003c8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003cb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003ce:	e9 4e 02 00 00       	jmp    800621 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d6:	83 c0 04             	add    $0x4,%eax
  8003d9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003df:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003e1:	85 d2                	test   %edx,%edx
  8003e3:	b8 e3 24 80 00       	mov    $0x8024e3,%eax
  8003e8:	0f 45 c2             	cmovne %edx,%eax
  8003eb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f2:	7e 06                	jle    8003fa <vprintfmt+0x17f>
  8003f4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003f8:	75 0d                	jne    800407 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003fd:	89 c7                	mov    %eax,%edi
  8003ff:	03 45 e0             	add    -0x20(%ebp),%eax
  800402:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800405:	eb 55                	jmp    80045c <vprintfmt+0x1e1>
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	ff 75 d8             	pushl  -0x28(%ebp)
  80040d:	ff 75 cc             	pushl  -0x34(%ebp)
  800410:	e8 46 03 00 00       	call   80075b <strnlen>
  800415:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800418:	29 c2                	sub    %eax,%edx
  80041a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800422:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800426:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800429:	85 ff                	test   %edi,%edi
  80042b:	7e 11                	jle    80043e <vprintfmt+0x1c3>
					putch(padc, putdat);
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	53                   	push   %ebx
  800431:	ff 75 e0             	pushl  -0x20(%ebp)
  800434:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800436:	83 ef 01             	sub    $0x1,%edi
  800439:	83 c4 10             	add    $0x10,%esp
  80043c:	eb eb                	jmp    800429 <vprintfmt+0x1ae>
  80043e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800441:	85 d2                	test   %edx,%edx
  800443:	b8 00 00 00 00       	mov    $0x0,%eax
  800448:	0f 49 c2             	cmovns %edx,%eax
  80044b:	29 c2                	sub    %eax,%edx
  80044d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800450:	eb a8                	jmp    8003fa <vprintfmt+0x17f>
					putch(ch, putdat);
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	53                   	push   %ebx
  800456:	52                   	push   %edx
  800457:	ff d6                	call   *%esi
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80045f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800461:	83 c7 01             	add    $0x1,%edi
  800464:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800468:	0f be d0             	movsbl %al,%edx
  80046b:	85 d2                	test   %edx,%edx
  80046d:	74 4b                	je     8004ba <vprintfmt+0x23f>
  80046f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800473:	78 06                	js     80047b <vprintfmt+0x200>
  800475:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800479:	78 1e                	js     800499 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80047b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80047f:	74 d1                	je     800452 <vprintfmt+0x1d7>
  800481:	0f be c0             	movsbl %al,%eax
  800484:	83 e8 20             	sub    $0x20,%eax
  800487:	83 f8 5e             	cmp    $0x5e,%eax
  80048a:	76 c6                	jbe    800452 <vprintfmt+0x1d7>
					putch('?', putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	53                   	push   %ebx
  800490:	6a 3f                	push   $0x3f
  800492:	ff d6                	call   *%esi
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	eb c3                	jmp    80045c <vprintfmt+0x1e1>
  800499:	89 cf                	mov    %ecx,%edi
  80049b:	eb 0e                	jmp    8004ab <vprintfmt+0x230>
				putch(' ', putdat);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	53                   	push   %ebx
  8004a1:	6a 20                	push   $0x20
  8004a3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004a5:	83 ef 01             	sub    $0x1,%edi
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	85 ff                	test   %edi,%edi
  8004ad:	7f ee                	jg     80049d <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b5:	e9 67 01 00 00       	jmp    800621 <vprintfmt+0x3a6>
  8004ba:	89 cf                	mov    %ecx,%edi
  8004bc:	eb ed                	jmp    8004ab <vprintfmt+0x230>
	if (lflag >= 2)
  8004be:	83 f9 01             	cmp    $0x1,%ecx
  8004c1:	7f 1b                	jg     8004de <vprintfmt+0x263>
	else if (lflag)
  8004c3:	85 c9                	test   %ecx,%ecx
  8004c5:	74 63                	je     80052a <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004cf:	99                   	cltd   
  8004d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8d 40 04             	lea    0x4(%eax),%eax
  8004d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004dc:	eb 17                	jmp    8004f5 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004de:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ef:	8d 40 08             	lea    0x8(%eax),%eax
  8004f2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004fb:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800500:	85 c9                	test   %ecx,%ecx
  800502:	0f 89 ff 00 00 00    	jns    800607 <vprintfmt+0x38c>
				putch('-', putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	53                   	push   %ebx
  80050c:	6a 2d                	push   $0x2d
  80050e:	ff d6                	call   *%esi
				num = -(long long) num;
  800510:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800513:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800516:	f7 da                	neg    %edx
  800518:	83 d1 00             	adc    $0x0,%ecx
  80051b:	f7 d9                	neg    %ecx
  80051d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800520:	b8 0a 00 00 00       	mov    $0xa,%eax
  800525:	e9 dd 00 00 00       	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800532:	99                   	cltd   
  800533:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800536:	8b 45 14             	mov    0x14(%ebp),%eax
  800539:	8d 40 04             	lea    0x4(%eax),%eax
  80053c:	89 45 14             	mov    %eax,0x14(%ebp)
  80053f:	eb b4                	jmp    8004f5 <vprintfmt+0x27a>
	if (lflag >= 2)
  800541:	83 f9 01             	cmp    $0x1,%ecx
  800544:	7f 1e                	jg     800564 <vprintfmt+0x2e9>
	else if (lflag)
  800546:	85 c9                	test   %ecx,%ecx
  800548:	74 32                	je     80057c <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8b 10                	mov    (%eax),%edx
  80054f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800554:	8d 40 04             	lea    0x4(%eax),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80055a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80055f:	e9 a3 00 00 00       	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8b 10                	mov    (%eax),%edx
  800569:	8b 48 04             	mov    0x4(%eax),%ecx
  80056c:	8d 40 08             	lea    0x8(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800572:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800577:	e9 8b 00 00 00       	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 10                	mov    (%eax),%edx
  800581:	b9 00 00 00 00       	mov    $0x0,%ecx
  800586:	8d 40 04             	lea    0x4(%eax),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800591:	eb 74                	jmp    800607 <vprintfmt+0x38c>
	if (lflag >= 2)
  800593:	83 f9 01             	cmp    $0x1,%ecx
  800596:	7f 1b                	jg     8005b3 <vprintfmt+0x338>
	else if (lflag)
  800598:	85 c9                	test   %ecx,%ecx
  80059a:	74 2c                	je     8005c8 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 10                	mov    (%eax),%edx
  8005a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ac:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005b1:	eb 54                	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8b 10                	mov    (%eax),%edx
  8005b8:	8b 48 04             	mov    0x4(%eax),%ecx
  8005bb:	8d 40 08             	lea    0x8(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005c6:	eb 3f                	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d2:	8d 40 04             	lea    0x4(%eax),%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005dd:	eb 28                	jmp    800607 <vprintfmt+0x38c>
			putch('0', putdat);
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	53                   	push   %ebx
  8005e3:	6a 30                	push   $0x30
  8005e5:	ff d6                	call   *%esi
			putch('x', putdat);
  8005e7:	83 c4 08             	add    $0x8,%esp
  8005ea:	53                   	push   %ebx
  8005eb:	6a 78                	push   $0x78
  8005ed:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 10                	mov    (%eax),%edx
  8005f4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005f9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005fc:	8d 40 04             	lea    0x4(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800602:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800607:	83 ec 0c             	sub    $0xc,%esp
  80060a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80060e:	57                   	push   %edi
  80060f:	ff 75 e0             	pushl  -0x20(%ebp)
  800612:	50                   	push   %eax
  800613:	51                   	push   %ecx
  800614:	52                   	push   %edx
  800615:	89 da                	mov    %ebx,%edx
  800617:	89 f0                	mov    %esi,%eax
  800619:	e8 72 fb ff ff       	call   800190 <printnum>
			break;
  80061e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800621:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800624:	83 c7 01             	add    $0x1,%edi
  800627:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80062b:	83 f8 25             	cmp    $0x25,%eax
  80062e:	0f 84 62 fc ff ff    	je     800296 <vprintfmt+0x1b>
			if (ch == '\0')
  800634:	85 c0                	test   %eax,%eax
  800636:	0f 84 8b 00 00 00    	je     8006c7 <vprintfmt+0x44c>
			putch(ch, putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	53                   	push   %ebx
  800640:	50                   	push   %eax
  800641:	ff d6                	call   *%esi
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	eb dc                	jmp    800624 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800648:	83 f9 01             	cmp    $0x1,%ecx
  80064b:	7f 1b                	jg     800668 <vprintfmt+0x3ed>
	else if (lflag)
  80064d:	85 c9                	test   %ecx,%ecx
  80064f:	74 2c                	je     80067d <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 10                	mov    (%eax),%edx
  800656:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065b:	8d 40 04             	lea    0x4(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800661:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800666:	eb 9f                	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 10                	mov    (%eax),%edx
  80066d:	8b 48 04             	mov    0x4(%eax),%ecx
  800670:	8d 40 08             	lea    0x8(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800676:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80067b:	eb 8a                	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 10                	mov    (%eax),%edx
  800682:	b9 00 00 00 00       	mov    $0x0,%ecx
  800687:	8d 40 04             	lea    0x4(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800692:	e9 70 ff ff ff       	jmp    800607 <vprintfmt+0x38c>
			putch(ch, putdat);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	53                   	push   %ebx
  80069b:	6a 25                	push   $0x25
  80069d:	ff d6                	call   *%esi
			break;
  80069f:	83 c4 10             	add    $0x10,%esp
  8006a2:	e9 7a ff ff ff       	jmp    800621 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	53                   	push   %ebx
  8006ab:	6a 25                	push   $0x25
  8006ad:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	89 f8                	mov    %edi,%eax
  8006b4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006b8:	74 05                	je     8006bf <vprintfmt+0x444>
  8006ba:	83 e8 01             	sub    $0x1,%eax
  8006bd:	eb f5                	jmp    8006b4 <vprintfmt+0x439>
  8006bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006c2:	e9 5a ff ff ff       	jmp    800621 <vprintfmt+0x3a6>
}
  8006c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006ca:	5b                   	pop    %ebx
  8006cb:	5e                   	pop    %esi
  8006cc:	5f                   	pop    %edi
  8006cd:	5d                   	pop    %ebp
  8006ce:	c3                   	ret    

008006cf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006cf:	f3 0f 1e fb          	endbr32 
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 18             	sub    $0x18,%esp
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006e2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006e6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006f0:	85 c0                	test   %eax,%eax
  8006f2:	74 26                	je     80071a <vsnprintf+0x4b>
  8006f4:	85 d2                	test   %edx,%edx
  8006f6:	7e 22                	jle    80071a <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006f8:	ff 75 14             	pushl  0x14(%ebp)
  8006fb:	ff 75 10             	pushl  0x10(%ebp)
  8006fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800701:	50                   	push   %eax
  800702:	68 39 02 80 00       	push   $0x800239
  800707:	e8 6f fb ff ff       	call   80027b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80070c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80070f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800715:	83 c4 10             	add    $0x10,%esp
}
  800718:	c9                   	leave  
  800719:	c3                   	ret    
		return -E_INVAL;
  80071a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80071f:	eb f7                	jmp    800718 <vsnprintf+0x49>

00800721 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800721:	f3 0f 1e fb          	endbr32 
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80072b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80072e:	50                   	push   %eax
  80072f:	ff 75 10             	pushl  0x10(%ebp)
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	ff 75 08             	pushl  0x8(%ebp)
  800738:	e8 92 ff ff ff       	call   8006cf <vsnprintf>
	va_end(ap);

	return rc;
}
  80073d:	c9                   	leave  
  80073e:	c3                   	ret    

0080073f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80073f:	f3 0f 1e fb          	endbr32 
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800749:	b8 00 00 00 00       	mov    $0x0,%eax
  80074e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800752:	74 05                	je     800759 <strlen+0x1a>
		n++;
  800754:	83 c0 01             	add    $0x1,%eax
  800757:	eb f5                	jmp    80074e <strlen+0xf>
	return n;
}
  800759:	5d                   	pop    %ebp
  80075a:	c3                   	ret    

0080075b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80075b:	f3 0f 1e fb          	endbr32 
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800765:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800768:	b8 00 00 00 00       	mov    $0x0,%eax
  80076d:	39 d0                	cmp    %edx,%eax
  80076f:	74 0d                	je     80077e <strnlen+0x23>
  800771:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800775:	74 05                	je     80077c <strnlen+0x21>
		n++;
  800777:	83 c0 01             	add    $0x1,%eax
  80077a:	eb f1                	jmp    80076d <strnlen+0x12>
  80077c:	89 c2                	mov    %eax,%edx
	return n;
}
  80077e:	89 d0                	mov    %edx,%eax
  800780:	5d                   	pop    %ebp
  800781:	c3                   	ret    

00800782 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800782:	f3 0f 1e fb          	endbr32 
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	53                   	push   %ebx
  80078a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80078d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800790:	b8 00 00 00 00       	mov    $0x0,%eax
  800795:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800799:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80079c:	83 c0 01             	add    $0x1,%eax
  80079f:	84 d2                	test   %dl,%dl
  8007a1:	75 f2                	jne    800795 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007a3:	89 c8                	mov    %ecx,%eax
  8007a5:	5b                   	pop    %ebx
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007a8:	f3 0f 1e fb          	endbr32 
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	53                   	push   %ebx
  8007b0:	83 ec 10             	sub    $0x10,%esp
  8007b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007b6:	53                   	push   %ebx
  8007b7:	e8 83 ff ff ff       	call   80073f <strlen>
  8007bc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007bf:	ff 75 0c             	pushl  0xc(%ebp)
  8007c2:	01 d8                	add    %ebx,%eax
  8007c4:	50                   	push   %eax
  8007c5:	e8 b8 ff ff ff       	call   800782 <strcpy>
	return dst;
}
  8007ca:	89 d8                	mov    %ebx,%eax
  8007cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    

008007d1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d1:	f3 0f 1e fb          	endbr32 
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	56                   	push   %esi
  8007d9:	53                   	push   %ebx
  8007da:	8b 75 08             	mov    0x8(%ebp),%esi
  8007dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e0:	89 f3                	mov    %esi,%ebx
  8007e2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e5:	89 f0                	mov    %esi,%eax
  8007e7:	39 d8                	cmp    %ebx,%eax
  8007e9:	74 11                	je     8007fc <strncpy+0x2b>
		*dst++ = *src;
  8007eb:	83 c0 01             	add    $0x1,%eax
  8007ee:	0f b6 0a             	movzbl (%edx),%ecx
  8007f1:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007f4:	80 f9 01             	cmp    $0x1,%cl
  8007f7:	83 da ff             	sbb    $0xffffffff,%edx
  8007fa:	eb eb                	jmp    8007e7 <strncpy+0x16>
	}
	return ret;
}
  8007fc:	89 f0                	mov    %esi,%eax
  8007fe:	5b                   	pop    %ebx
  8007ff:	5e                   	pop    %esi
  800800:	5d                   	pop    %ebp
  800801:	c3                   	ret    

00800802 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800802:	f3 0f 1e fb          	endbr32 
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	56                   	push   %esi
  80080a:	53                   	push   %ebx
  80080b:	8b 75 08             	mov    0x8(%ebp),%esi
  80080e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800811:	8b 55 10             	mov    0x10(%ebp),%edx
  800814:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800816:	85 d2                	test   %edx,%edx
  800818:	74 21                	je     80083b <strlcpy+0x39>
  80081a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80081e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800820:	39 c2                	cmp    %eax,%edx
  800822:	74 14                	je     800838 <strlcpy+0x36>
  800824:	0f b6 19             	movzbl (%ecx),%ebx
  800827:	84 db                	test   %bl,%bl
  800829:	74 0b                	je     800836 <strlcpy+0x34>
			*dst++ = *src++;
  80082b:	83 c1 01             	add    $0x1,%ecx
  80082e:	83 c2 01             	add    $0x1,%edx
  800831:	88 5a ff             	mov    %bl,-0x1(%edx)
  800834:	eb ea                	jmp    800820 <strlcpy+0x1e>
  800836:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800838:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80083b:	29 f0                	sub    %esi,%eax
}
  80083d:	5b                   	pop    %ebx
  80083e:	5e                   	pop    %esi
  80083f:	5d                   	pop    %ebp
  800840:	c3                   	ret    

00800841 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800841:	f3 0f 1e fb          	endbr32 
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80084e:	0f b6 01             	movzbl (%ecx),%eax
  800851:	84 c0                	test   %al,%al
  800853:	74 0c                	je     800861 <strcmp+0x20>
  800855:	3a 02                	cmp    (%edx),%al
  800857:	75 08                	jne    800861 <strcmp+0x20>
		p++, q++;
  800859:	83 c1 01             	add    $0x1,%ecx
  80085c:	83 c2 01             	add    $0x1,%edx
  80085f:	eb ed                	jmp    80084e <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800861:	0f b6 c0             	movzbl %al,%eax
  800864:	0f b6 12             	movzbl (%edx),%edx
  800867:	29 d0                	sub    %edx,%eax
}
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80086b:	f3 0f 1e fb          	endbr32 
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	53                   	push   %ebx
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 55 0c             	mov    0xc(%ebp),%edx
  800879:	89 c3                	mov    %eax,%ebx
  80087b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80087e:	eb 06                	jmp    800886 <strncmp+0x1b>
		n--, p++, q++;
  800880:	83 c0 01             	add    $0x1,%eax
  800883:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800886:	39 d8                	cmp    %ebx,%eax
  800888:	74 16                	je     8008a0 <strncmp+0x35>
  80088a:	0f b6 08             	movzbl (%eax),%ecx
  80088d:	84 c9                	test   %cl,%cl
  80088f:	74 04                	je     800895 <strncmp+0x2a>
  800891:	3a 0a                	cmp    (%edx),%cl
  800893:	74 eb                	je     800880 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800895:	0f b6 00             	movzbl (%eax),%eax
  800898:	0f b6 12             	movzbl (%edx),%edx
  80089b:	29 d0                	sub    %edx,%eax
}
  80089d:	5b                   	pop    %ebx
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    
		return 0;
  8008a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a5:	eb f6                	jmp    80089d <strncmp+0x32>

008008a7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008a7:	f3 0f 1e fb          	endbr32 
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b5:	0f b6 10             	movzbl (%eax),%edx
  8008b8:	84 d2                	test   %dl,%dl
  8008ba:	74 09                	je     8008c5 <strchr+0x1e>
		if (*s == c)
  8008bc:	38 ca                	cmp    %cl,%dl
  8008be:	74 0a                	je     8008ca <strchr+0x23>
	for (; *s; s++)
  8008c0:	83 c0 01             	add    $0x1,%eax
  8008c3:	eb f0                	jmp    8008b5 <strchr+0xe>
			return (char *) s;
	return 0;
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008cc:	f3 0f 1e fb          	endbr32 
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008da:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008dd:	38 ca                	cmp    %cl,%dl
  8008df:	74 09                	je     8008ea <strfind+0x1e>
  8008e1:	84 d2                	test   %dl,%dl
  8008e3:	74 05                	je     8008ea <strfind+0x1e>
	for (; *s; s++)
  8008e5:	83 c0 01             	add    $0x1,%eax
  8008e8:	eb f0                	jmp    8008da <strfind+0xe>
			break;
	return (char *) s;
}
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008ec:	f3 0f 1e fb          	endbr32 
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	57                   	push   %edi
  8008f4:	56                   	push   %esi
  8008f5:	53                   	push   %ebx
  8008f6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008fc:	85 c9                	test   %ecx,%ecx
  8008fe:	74 31                	je     800931 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800900:	89 f8                	mov    %edi,%eax
  800902:	09 c8                	or     %ecx,%eax
  800904:	a8 03                	test   $0x3,%al
  800906:	75 23                	jne    80092b <memset+0x3f>
		c &= 0xFF;
  800908:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80090c:	89 d3                	mov    %edx,%ebx
  80090e:	c1 e3 08             	shl    $0x8,%ebx
  800911:	89 d0                	mov    %edx,%eax
  800913:	c1 e0 18             	shl    $0x18,%eax
  800916:	89 d6                	mov    %edx,%esi
  800918:	c1 e6 10             	shl    $0x10,%esi
  80091b:	09 f0                	or     %esi,%eax
  80091d:	09 c2                	or     %eax,%edx
  80091f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800921:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800924:	89 d0                	mov    %edx,%eax
  800926:	fc                   	cld    
  800927:	f3 ab                	rep stos %eax,%es:(%edi)
  800929:	eb 06                	jmp    800931 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80092b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092e:	fc                   	cld    
  80092f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800931:	89 f8                	mov    %edi,%eax
  800933:	5b                   	pop    %ebx
  800934:	5e                   	pop    %esi
  800935:	5f                   	pop    %edi
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800938:	f3 0f 1e fb          	endbr32 
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	57                   	push   %edi
  800940:	56                   	push   %esi
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 75 0c             	mov    0xc(%ebp),%esi
  800947:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80094a:	39 c6                	cmp    %eax,%esi
  80094c:	73 32                	jae    800980 <memmove+0x48>
  80094e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800951:	39 c2                	cmp    %eax,%edx
  800953:	76 2b                	jbe    800980 <memmove+0x48>
		s += n;
		d += n;
  800955:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800958:	89 fe                	mov    %edi,%esi
  80095a:	09 ce                	or     %ecx,%esi
  80095c:	09 d6                	or     %edx,%esi
  80095e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800964:	75 0e                	jne    800974 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800966:	83 ef 04             	sub    $0x4,%edi
  800969:	8d 72 fc             	lea    -0x4(%edx),%esi
  80096c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80096f:	fd                   	std    
  800970:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800972:	eb 09                	jmp    80097d <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800974:	83 ef 01             	sub    $0x1,%edi
  800977:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80097a:	fd                   	std    
  80097b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80097d:	fc                   	cld    
  80097e:	eb 1a                	jmp    80099a <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800980:	89 c2                	mov    %eax,%edx
  800982:	09 ca                	or     %ecx,%edx
  800984:	09 f2                	or     %esi,%edx
  800986:	f6 c2 03             	test   $0x3,%dl
  800989:	75 0a                	jne    800995 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80098b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80098e:	89 c7                	mov    %eax,%edi
  800990:	fc                   	cld    
  800991:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800993:	eb 05                	jmp    80099a <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800995:	89 c7                	mov    %eax,%edi
  800997:	fc                   	cld    
  800998:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80099a:	5e                   	pop    %esi
  80099b:	5f                   	pop    %edi
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80099e:	f3 0f 1e fb          	endbr32 
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009a8:	ff 75 10             	pushl  0x10(%ebp)
  8009ab:	ff 75 0c             	pushl  0xc(%ebp)
  8009ae:	ff 75 08             	pushl  0x8(%ebp)
  8009b1:	e8 82 ff ff ff       	call   800938 <memmove>
}
  8009b6:	c9                   	leave  
  8009b7:	c3                   	ret    

008009b8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009b8:	f3 0f 1e fb          	endbr32 
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	56                   	push   %esi
  8009c0:	53                   	push   %ebx
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c7:	89 c6                	mov    %eax,%esi
  8009c9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009cc:	39 f0                	cmp    %esi,%eax
  8009ce:	74 1c                	je     8009ec <memcmp+0x34>
		if (*s1 != *s2)
  8009d0:	0f b6 08             	movzbl (%eax),%ecx
  8009d3:	0f b6 1a             	movzbl (%edx),%ebx
  8009d6:	38 d9                	cmp    %bl,%cl
  8009d8:	75 08                	jne    8009e2 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009da:	83 c0 01             	add    $0x1,%eax
  8009dd:	83 c2 01             	add    $0x1,%edx
  8009e0:	eb ea                	jmp    8009cc <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009e2:	0f b6 c1             	movzbl %cl,%eax
  8009e5:	0f b6 db             	movzbl %bl,%ebx
  8009e8:	29 d8                	sub    %ebx,%eax
  8009ea:	eb 05                	jmp    8009f1 <memcmp+0x39>
	}

	return 0;
  8009ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f1:	5b                   	pop    %ebx
  8009f2:	5e                   	pop    %esi
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009f5:	f3 0f 1e fb          	endbr32 
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a02:	89 c2                	mov    %eax,%edx
  800a04:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a07:	39 d0                	cmp    %edx,%eax
  800a09:	73 09                	jae    800a14 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a0b:	38 08                	cmp    %cl,(%eax)
  800a0d:	74 05                	je     800a14 <memfind+0x1f>
	for (; s < ends; s++)
  800a0f:	83 c0 01             	add    $0x1,%eax
  800a12:	eb f3                	jmp    800a07 <memfind+0x12>
			break;
	return (void *) s;
}
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a16:	f3 0f 1e fb          	endbr32 
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	57                   	push   %edi
  800a1e:	56                   	push   %esi
  800a1f:	53                   	push   %ebx
  800a20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a26:	eb 03                	jmp    800a2b <strtol+0x15>
		s++;
  800a28:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a2b:	0f b6 01             	movzbl (%ecx),%eax
  800a2e:	3c 20                	cmp    $0x20,%al
  800a30:	74 f6                	je     800a28 <strtol+0x12>
  800a32:	3c 09                	cmp    $0x9,%al
  800a34:	74 f2                	je     800a28 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a36:	3c 2b                	cmp    $0x2b,%al
  800a38:	74 2a                	je     800a64 <strtol+0x4e>
	int neg = 0;
  800a3a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a3f:	3c 2d                	cmp    $0x2d,%al
  800a41:	74 2b                	je     800a6e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a43:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a49:	75 0f                	jne    800a5a <strtol+0x44>
  800a4b:	80 39 30             	cmpb   $0x30,(%ecx)
  800a4e:	74 28                	je     800a78 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a50:	85 db                	test   %ebx,%ebx
  800a52:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a57:	0f 44 d8             	cmove  %eax,%ebx
  800a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a62:	eb 46                	jmp    800aaa <strtol+0x94>
		s++;
  800a64:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a67:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6c:	eb d5                	jmp    800a43 <strtol+0x2d>
		s++, neg = 1;
  800a6e:	83 c1 01             	add    $0x1,%ecx
  800a71:	bf 01 00 00 00       	mov    $0x1,%edi
  800a76:	eb cb                	jmp    800a43 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a78:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a7c:	74 0e                	je     800a8c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a7e:	85 db                	test   %ebx,%ebx
  800a80:	75 d8                	jne    800a5a <strtol+0x44>
		s++, base = 8;
  800a82:	83 c1 01             	add    $0x1,%ecx
  800a85:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a8a:	eb ce                	jmp    800a5a <strtol+0x44>
		s += 2, base = 16;
  800a8c:	83 c1 02             	add    $0x2,%ecx
  800a8f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a94:	eb c4                	jmp    800a5a <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a96:	0f be d2             	movsbl %dl,%edx
  800a99:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a9c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a9f:	7d 3a                	jge    800adb <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800aa1:	83 c1 01             	add    $0x1,%ecx
  800aa4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aa8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aaa:	0f b6 11             	movzbl (%ecx),%edx
  800aad:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ab0:	89 f3                	mov    %esi,%ebx
  800ab2:	80 fb 09             	cmp    $0x9,%bl
  800ab5:	76 df                	jbe    800a96 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ab7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aba:	89 f3                	mov    %esi,%ebx
  800abc:	80 fb 19             	cmp    $0x19,%bl
  800abf:	77 08                	ja     800ac9 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ac1:	0f be d2             	movsbl %dl,%edx
  800ac4:	83 ea 57             	sub    $0x57,%edx
  800ac7:	eb d3                	jmp    800a9c <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ac9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800acc:	89 f3                	mov    %esi,%ebx
  800ace:	80 fb 19             	cmp    $0x19,%bl
  800ad1:	77 08                	ja     800adb <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ad3:	0f be d2             	movsbl %dl,%edx
  800ad6:	83 ea 37             	sub    $0x37,%edx
  800ad9:	eb c1                	jmp    800a9c <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800adb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800adf:	74 05                	je     800ae6 <strtol+0xd0>
		*endptr = (char *) s;
  800ae1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ae6:	89 c2                	mov    %eax,%edx
  800ae8:	f7 da                	neg    %edx
  800aea:	85 ff                	test   %edi,%edi
  800aec:	0f 45 c2             	cmovne %edx,%eax
}
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800af4:	f3 0f 1e fb          	endbr32 
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	57                   	push   %edi
  800afc:	56                   	push   %esi
  800afd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800afe:	b8 00 00 00 00       	mov    $0x0,%eax
  800b03:	8b 55 08             	mov    0x8(%ebp),%edx
  800b06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b09:	89 c3                	mov    %eax,%ebx
  800b0b:	89 c7                	mov    %eax,%edi
  800b0d:	89 c6                	mov    %eax,%esi
  800b0f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b16:	f3 0f 1e fb          	endbr32 
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	57                   	push   %edi
  800b1e:	56                   	push   %esi
  800b1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b20:	ba 00 00 00 00       	mov    $0x0,%edx
  800b25:	b8 01 00 00 00       	mov    $0x1,%eax
  800b2a:	89 d1                	mov    %edx,%ecx
  800b2c:	89 d3                	mov    %edx,%ebx
  800b2e:	89 d7                	mov    %edx,%edi
  800b30:	89 d6                	mov    %edx,%esi
  800b32:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5f                   	pop    %edi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b39:	f3 0f 1e fb          	endbr32 
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	57                   	push   %edi
  800b41:	56                   	push   %esi
  800b42:	53                   	push   %ebx
  800b43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4e:	b8 03 00 00 00       	mov    $0x3,%eax
  800b53:	89 cb                	mov    %ecx,%ebx
  800b55:	89 cf                	mov    %ecx,%edi
  800b57:	89 ce                	mov    %ecx,%esi
  800b59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b5b:	85 c0                	test   %eax,%eax
  800b5d:	7f 08                	jg     800b67 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5f                   	pop    %edi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b67:	83 ec 0c             	sub    $0xc,%esp
  800b6a:	50                   	push   %eax
  800b6b:	6a 03                	push   $0x3
  800b6d:	68 df 27 80 00       	push   $0x8027df
  800b72:	6a 23                	push   $0x23
  800b74:	68 fc 27 80 00       	push   $0x8027fc
  800b79:	e8 08 15 00 00       	call   802086 <_panic>

00800b7e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b7e:	f3 0f 1e fb          	endbr32 
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	57                   	push   %edi
  800b86:	56                   	push   %esi
  800b87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b88:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8d:	b8 02 00 00 00       	mov    $0x2,%eax
  800b92:	89 d1                	mov    %edx,%ecx
  800b94:	89 d3                	mov    %edx,%ebx
  800b96:	89 d7                	mov    %edx,%edi
  800b98:	89 d6                	mov    %edx,%esi
  800b9a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5f                   	pop    %edi
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <sys_yield>:

void
sys_yield(void)
{
  800ba1:	f3 0f 1e fb          	endbr32 
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bb5:	89 d1                	mov    %edx,%ecx
  800bb7:	89 d3                	mov    %edx,%ebx
  800bb9:	89 d7                	mov    %edx,%edi
  800bbb:	89 d6                	mov    %edx,%esi
  800bbd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
  800bce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd1:	be 00 00 00 00       	mov    $0x0,%esi
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdc:	b8 04 00 00 00       	mov    $0x4,%eax
  800be1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800be4:	89 f7                	mov    %esi,%edi
  800be6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be8:	85 c0                	test   %eax,%eax
  800bea:	7f 08                	jg     800bf4 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf4:	83 ec 0c             	sub    $0xc,%esp
  800bf7:	50                   	push   %eax
  800bf8:	6a 04                	push   $0x4
  800bfa:	68 df 27 80 00       	push   $0x8027df
  800bff:	6a 23                	push   $0x23
  800c01:	68 fc 27 80 00       	push   $0x8027fc
  800c06:	e8 7b 14 00 00       	call   802086 <_panic>

00800c0b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c0b:	f3 0f 1e fb          	endbr32 
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	57                   	push   %edi
  800c13:	56                   	push   %esi
  800c14:	53                   	push   %ebx
  800c15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c18:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1e:	b8 05 00 00 00       	mov    $0x5,%eax
  800c23:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c26:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c29:	8b 75 18             	mov    0x18(%ebp),%esi
  800c2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	7f 08                	jg     800c3a <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	50                   	push   %eax
  800c3e:	6a 05                	push   $0x5
  800c40:	68 df 27 80 00       	push   $0x8027df
  800c45:	6a 23                	push   $0x23
  800c47:	68 fc 27 80 00       	push   $0x8027fc
  800c4c:	e8 35 14 00 00       	call   802086 <_panic>

00800c51 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c51:	f3 0f 1e fb          	endbr32 
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c63:	8b 55 08             	mov    0x8(%ebp),%edx
  800c66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c69:	b8 06 00 00 00       	mov    $0x6,%eax
  800c6e:	89 df                	mov    %ebx,%edi
  800c70:	89 de                	mov    %ebx,%esi
  800c72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c74:	85 c0                	test   %eax,%eax
  800c76:	7f 08                	jg     800c80 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c80:	83 ec 0c             	sub    $0xc,%esp
  800c83:	50                   	push   %eax
  800c84:	6a 06                	push   $0x6
  800c86:	68 df 27 80 00       	push   $0x8027df
  800c8b:	6a 23                	push   $0x23
  800c8d:	68 fc 27 80 00       	push   $0x8027fc
  800c92:	e8 ef 13 00 00       	call   802086 <_panic>

00800c97 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c97:	f3 0f 1e fb          	endbr32 
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb4:	89 df                	mov    %ebx,%edi
  800cb6:	89 de                	mov    %ebx,%esi
  800cb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7f 08                	jg     800cc6 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	50                   	push   %eax
  800cca:	6a 08                	push   $0x8
  800ccc:	68 df 27 80 00       	push   $0x8027df
  800cd1:	6a 23                	push   $0x23
  800cd3:	68 fc 27 80 00       	push   $0x8027fc
  800cd8:	e8 a9 13 00 00       	call   802086 <_panic>

00800cdd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cdd:	f3 0f 1e fb          	endbr32 
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
  800ce7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cef:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf5:	b8 09 00 00 00       	mov    $0x9,%eax
  800cfa:	89 df                	mov    %ebx,%edi
  800cfc:	89 de                	mov    %ebx,%esi
  800cfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7f 08                	jg     800d0c <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	50                   	push   %eax
  800d10:	6a 09                	push   $0x9
  800d12:	68 df 27 80 00       	push   $0x8027df
  800d17:	6a 23                	push   $0x23
  800d19:	68 fc 27 80 00       	push   $0x8027fc
  800d1e:	e8 63 13 00 00       	call   802086 <_panic>

00800d23 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d23:	f3 0f 1e fb          	endbr32 
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d40:	89 df                	mov    %ebx,%edi
  800d42:	89 de                	mov    %ebx,%esi
  800d44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d46:	85 c0                	test   %eax,%eax
  800d48:	7f 08                	jg     800d52 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	50                   	push   %eax
  800d56:	6a 0a                	push   $0xa
  800d58:	68 df 27 80 00       	push   $0x8027df
  800d5d:	6a 23                	push   $0x23
  800d5f:	68 fc 27 80 00       	push   $0x8027fc
  800d64:	e8 1d 13 00 00       	call   802086 <_panic>

00800d69 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d69:	f3 0f 1e fb          	endbr32 
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d73:	8b 55 08             	mov    0x8(%ebp),%edx
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d7e:	be 00 00 00 00       	mov    $0x0,%esi
  800d83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d86:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d89:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5f                   	pop    %edi
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d90:	f3 0f 1e fb          	endbr32 
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
  800d9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da2:	8b 55 08             	mov    0x8(%ebp),%edx
  800da5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800daa:	89 cb                	mov    %ecx,%ebx
  800dac:	89 cf                	mov    %ecx,%edi
  800dae:	89 ce                	mov    %ecx,%esi
  800db0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	7f 08                	jg     800dbe <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbe:	83 ec 0c             	sub    $0xc,%esp
  800dc1:	50                   	push   %eax
  800dc2:	6a 0d                	push   $0xd
  800dc4:	68 df 27 80 00       	push   $0x8027df
  800dc9:	6a 23                	push   $0x23
  800dcb:	68 fc 27 80 00       	push   $0x8027fc
  800dd0:	e8 b1 12 00 00       	call   802086 <_panic>

00800dd5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dd5:	f3 0f 1e fb          	endbr32 
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  800de4:	b8 0e 00 00 00       	mov    $0xe,%eax
  800de9:	89 d1                	mov    %edx,%ecx
  800deb:	89 d3                	mov    %edx,%ebx
  800ded:	89 d7                	mov    %edx,%edi
  800def:	89 d6                	mov    %edx,%esi
  800df1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800df8:	f3 0f 1e fb          	endbr32 
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e15:	89 df                	mov    %ebx,%edi
  800e17:	89 de                	mov    %ebx,%esi
  800e19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7f 08                	jg     800e27 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e27:	83 ec 0c             	sub    $0xc,%esp
  800e2a:	50                   	push   %eax
  800e2b:	6a 0f                	push   $0xf
  800e2d:	68 df 27 80 00       	push   $0x8027df
  800e32:	6a 23                	push   $0x23
  800e34:	68 fc 27 80 00       	push   $0x8027fc
  800e39:	e8 48 12 00 00       	call   802086 <_panic>

00800e3e <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800e3e:	f3 0f 1e fb          	endbr32 
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e56:	b8 10 00 00 00       	mov    $0x10,%eax
  800e5b:	89 df                	mov    %ebx,%edi
  800e5d:	89 de                	mov    %ebx,%esi
  800e5f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e61:	85 c0                	test   %eax,%eax
  800e63:	7f 08                	jg     800e6d <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e68:	5b                   	pop    %ebx
  800e69:	5e                   	pop    %esi
  800e6a:	5f                   	pop    %edi
  800e6b:	5d                   	pop    %ebp
  800e6c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6d:	83 ec 0c             	sub    $0xc,%esp
  800e70:	50                   	push   %eax
  800e71:	6a 10                	push   $0x10
  800e73:	68 df 27 80 00       	push   $0x8027df
  800e78:	6a 23                	push   $0x23
  800e7a:	68 fc 27 80 00       	push   $0x8027fc
  800e7f:	e8 02 12 00 00       	call   802086 <_panic>

00800e84 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e84:	f3 0f 1e fb          	endbr32 
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	05 00 00 00 30       	add    $0x30000000,%eax
  800e93:	c1 e8 0c             	shr    $0xc,%eax
}
  800e96:	5d                   	pop    %ebp
  800e97:	c3                   	ret    

00800e98 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e98:	f3 0f 1e fb          	endbr32 
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ea7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eac:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800eb3:	f3 0f 1e fb          	endbr32 
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ebf:	89 c2                	mov    %eax,%edx
  800ec1:	c1 ea 16             	shr    $0x16,%edx
  800ec4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ecb:	f6 c2 01             	test   $0x1,%dl
  800ece:	74 2d                	je     800efd <fd_alloc+0x4a>
  800ed0:	89 c2                	mov    %eax,%edx
  800ed2:	c1 ea 0c             	shr    $0xc,%edx
  800ed5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800edc:	f6 c2 01             	test   $0x1,%dl
  800edf:	74 1c                	je     800efd <fd_alloc+0x4a>
  800ee1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ee6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800eeb:	75 d2                	jne    800ebf <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ef6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800efb:	eb 0a                	jmp    800f07 <fd_alloc+0x54>
			*fd_store = fd;
  800efd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f00:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f09:	f3 0f 1e fb          	endbr32 
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f13:	83 f8 1f             	cmp    $0x1f,%eax
  800f16:	77 30                	ja     800f48 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f18:	c1 e0 0c             	shl    $0xc,%eax
  800f1b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f20:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f26:	f6 c2 01             	test   $0x1,%dl
  800f29:	74 24                	je     800f4f <fd_lookup+0x46>
  800f2b:	89 c2                	mov    %eax,%edx
  800f2d:	c1 ea 0c             	shr    $0xc,%edx
  800f30:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f37:	f6 c2 01             	test   $0x1,%dl
  800f3a:	74 1a                	je     800f56 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3f:	89 02                	mov    %eax,(%edx)
	return 0;
  800f41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f46:	5d                   	pop    %ebp
  800f47:	c3                   	ret    
		return -E_INVAL;
  800f48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f4d:	eb f7                	jmp    800f46 <fd_lookup+0x3d>
		return -E_INVAL;
  800f4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f54:	eb f0                	jmp    800f46 <fd_lookup+0x3d>
  800f56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5b:	eb e9                	jmp    800f46 <fd_lookup+0x3d>

00800f5d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f5d:	f3 0f 1e fb          	endbr32 
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 08             	sub    $0x8,%esp
  800f67:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f6f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f74:	39 08                	cmp    %ecx,(%eax)
  800f76:	74 38                	je     800fb0 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800f78:	83 c2 01             	add    $0x1,%edx
  800f7b:	8b 04 95 88 28 80 00 	mov    0x802888(,%edx,4),%eax
  800f82:	85 c0                	test   %eax,%eax
  800f84:	75 ee                	jne    800f74 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f86:	a1 08 40 80 00       	mov    0x804008,%eax
  800f8b:	8b 40 48             	mov    0x48(%eax),%eax
  800f8e:	83 ec 04             	sub    $0x4,%esp
  800f91:	51                   	push   %ecx
  800f92:	50                   	push   %eax
  800f93:	68 0c 28 80 00       	push   $0x80280c
  800f98:	e8 db f1 ff ff       	call   800178 <cprintf>
	*dev = 0;
  800f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fa6:	83 c4 10             	add    $0x10,%esp
  800fa9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fae:	c9                   	leave  
  800faf:	c3                   	ret    
			*dev = devtab[i];
  800fb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fba:	eb f2                	jmp    800fae <dev_lookup+0x51>

00800fbc <fd_close>:
{
  800fbc:	f3 0f 1e fb          	endbr32 
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
  800fc6:	83 ec 24             	sub    $0x24,%esp
  800fc9:	8b 75 08             	mov    0x8(%ebp),%esi
  800fcc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fcf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fd2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fd9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fdc:	50                   	push   %eax
  800fdd:	e8 27 ff ff ff       	call   800f09 <fd_lookup>
  800fe2:	89 c3                	mov    %eax,%ebx
  800fe4:	83 c4 10             	add    $0x10,%esp
  800fe7:	85 c0                	test   %eax,%eax
  800fe9:	78 05                	js     800ff0 <fd_close+0x34>
	    || fd != fd2)
  800feb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fee:	74 16                	je     801006 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800ff0:	89 f8                	mov    %edi,%eax
  800ff2:	84 c0                	test   %al,%al
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff9:	0f 44 d8             	cmove  %eax,%ebx
}
  800ffc:	89 d8                	mov    %ebx,%eax
  800ffe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80100c:	50                   	push   %eax
  80100d:	ff 36                	pushl  (%esi)
  80100f:	e8 49 ff ff ff       	call   800f5d <dev_lookup>
  801014:	89 c3                	mov    %eax,%ebx
  801016:	83 c4 10             	add    $0x10,%esp
  801019:	85 c0                	test   %eax,%eax
  80101b:	78 1a                	js     801037 <fd_close+0x7b>
		if (dev->dev_close)
  80101d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801020:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801023:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801028:	85 c0                	test   %eax,%eax
  80102a:	74 0b                	je     801037 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80102c:	83 ec 0c             	sub    $0xc,%esp
  80102f:	56                   	push   %esi
  801030:	ff d0                	call   *%eax
  801032:	89 c3                	mov    %eax,%ebx
  801034:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	56                   	push   %esi
  80103b:	6a 00                	push   $0x0
  80103d:	e8 0f fc ff ff       	call   800c51 <sys_page_unmap>
	return r;
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	eb b5                	jmp    800ffc <fd_close+0x40>

00801047 <close>:

int
close(int fdnum)
{
  801047:	f3 0f 1e fb          	endbr32 
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801051:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801054:	50                   	push   %eax
  801055:	ff 75 08             	pushl  0x8(%ebp)
  801058:	e8 ac fe ff ff       	call   800f09 <fd_lookup>
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	85 c0                	test   %eax,%eax
  801062:	79 02                	jns    801066 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    
		return fd_close(fd, 1);
  801066:	83 ec 08             	sub    $0x8,%esp
  801069:	6a 01                	push   $0x1
  80106b:	ff 75 f4             	pushl  -0xc(%ebp)
  80106e:	e8 49 ff ff ff       	call   800fbc <fd_close>
  801073:	83 c4 10             	add    $0x10,%esp
  801076:	eb ec                	jmp    801064 <close+0x1d>

00801078 <close_all>:

void
close_all(void)
{
  801078:	f3 0f 1e fb          	endbr32 
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	53                   	push   %ebx
  801080:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801083:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801088:	83 ec 0c             	sub    $0xc,%esp
  80108b:	53                   	push   %ebx
  80108c:	e8 b6 ff ff ff       	call   801047 <close>
	for (i = 0; i < MAXFD; i++)
  801091:	83 c3 01             	add    $0x1,%ebx
  801094:	83 c4 10             	add    $0x10,%esp
  801097:	83 fb 20             	cmp    $0x20,%ebx
  80109a:	75 ec                	jne    801088 <close_all+0x10>
}
  80109c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010a1:	f3 0f 1e fb          	endbr32 
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	57                   	push   %edi
  8010a9:	56                   	push   %esi
  8010aa:	53                   	push   %ebx
  8010ab:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010b1:	50                   	push   %eax
  8010b2:	ff 75 08             	pushl  0x8(%ebp)
  8010b5:	e8 4f fe ff ff       	call   800f09 <fd_lookup>
  8010ba:	89 c3                	mov    %eax,%ebx
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	0f 88 81 00 00 00    	js     801148 <dup+0xa7>
		return r;
	close(newfdnum);
  8010c7:	83 ec 0c             	sub    $0xc,%esp
  8010ca:	ff 75 0c             	pushl  0xc(%ebp)
  8010cd:	e8 75 ff ff ff       	call   801047 <close>

	newfd = INDEX2FD(newfdnum);
  8010d2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010d5:	c1 e6 0c             	shl    $0xc,%esi
  8010d8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010de:	83 c4 04             	add    $0x4,%esp
  8010e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010e4:	e8 af fd ff ff       	call   800e98 <fd2data>
  8010e9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010eb:	89 34 24             	mov    %esi,(%esp)
  8010ee:	e8 a5 fd ff ff       	call   800e98 <fd2data>
  8010f3:	83 c4 10             	add    $0x10,%esp
  8010f6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010f8:	89 d8                	mov    %ebx,%eax
  8010fa:	c1 e8 16             	shr    $0x16,%eax
  8010fd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801104:	a8 01                	test   $0x1,%al
  801106:	74 11                	je     801119 <dup+0x78>
  801108:	89 d8                	mov    %ebx,%eax
  80110a:	c1 e8 0c             	shr    $0xc,%eax
  80110d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801114:	f6 c2 01             	test   $0x1,%dl
  801117:	75 39                	jne    801152 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801119:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80111c:	89 d0                	mov    %edx,%eax
  80111e:	c1 e8 0c             	shr    $0xc,%eax
  801121:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801128:	83 ec 0c             	sub    $0xc,%esp
  80112b:	25 07 0e 00 00       	and    $0xe07,%eax
  801130:	50                   	push   %eax
  801131:	56                   	push   %esi
  801132:	6a 00                	push   $0x0
  801134:	52                   	push   %edx
  801135:	6a 00                	push   $0x0
  801137:	e8 cf fa ff ff       	call   800c0b <sys_page_map>
  80113c:	89 c3                	mov    %eax,%ebx
  80113e:	83 c4 20             	add    $0x20,%esp
  801141:	85 c0                	test   %eax,%eax
  801143:	78 31                	js     801176 <dup+0xd5>
		goto err;

	return newfdnum;
  801145:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801148:	89 d8                	mov    %ebx,%eax
  80114a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114d:	5b                   	pop    %ebx
  80114e:	5e                   	pop    %esi
  80114f:	5f                   	pop    %edi
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801152:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801159:	83 ec 0c             	sub    $0xc,%esp
  80115c:	25 07 0e 00 00       	and    $0xe07,%eax
  801161:	50                   	push   %eax
  801162:	57                   	push   %edi
  801163:	6a 00                	push   $0x0
  801165:	53                   	push   %ebx
  801166:	6a 00                	push   $0x0
  801168:	e8 9e fa ff ff       	call   800c0b <sys_page_map>
  80116d:	89 c3                	mov    %eax,%ebx
  80116f:	83 c4 20             	add    $0x20,%esp
  801172:	85 c0                	test   %eax,%eax
  801174:	79 a3                	jns    801119 <dup+0x78>
	sys_page_unmap(0, newfd);
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	56                   	push   %esi
  80117a:	6a 00                	push   $0x0
  80117c:	e8 d0 fa ff ff       	call   800c51 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801181:	83 c4 08             	add    $0x8,%esp
  801184:	57                   	push   %edi
  801185:	6a 00                	push   $0x0
  801187:	e8 c5 fa ff ff       	call   800c51 <sys_page_unmap>
	return r;
  80118c:	83 c4 10             	add    $0x10,%esp
  80118f:	eb b7                	jmp    801148 <dup+0xa7>

00801191 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801191:	f3 0f 1e fb          	endbr32 
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	53                   	push   %ebx
  801199:	83 ec 1c             	sub    $0x1c,%esp
  80119c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80119f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a2:	50                   	push   %eax
  8011a3:	53                   	push   %ebx
  8011a4:	e8 60 fd ff ff       	call   800f09 <fd_lookup>
  8011a9:	83 c4 10             	add    $0x10,%esp
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	78 3f                	js     8011ef <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011b0:	83 ec 08             	sub    $0x8,%esp
  8011b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b6:	50                   	push   %eax
  8011b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ba:	ff 30                	pushl  (%eax)
  8011bc:	e8 9c fd ff ff       	call   800f5d <dev_lookup>
  8011c1:	83 c4 10             	add    $0x10,%esp
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	78 27                	js     8011ef <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011cb:	8b 42 08             	mov    0x8(%edx),%eax
  8011ce:	83 e0 03             	and    $0x3,%eax
  8011d1:	83 f8 01             	cmp    $0x1,%eax
  8011d4:	74 1e                	je     8011f4 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d9:	8b 40 08             	mov    0x8(%eax),%eax
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	74 35                	je     801215 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011e0:	83 ec 04             	sub    $0x4,%esp
  8011e3:	ff 75 10             	pushl  0x10(%ebp)
  8011e6:	ff 75 0c             	pushl  0xc(%ebp)
  8011e9:	52                   	push   %edx
  8011ea:	ff d0                	call   *%eax
  8011ec:	83 c4 10             	add    $0x10,%esp
}
  8011ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011f4:	a1 08 40 80 00       	mov    0x804008,%eax
  8011f9:	8b 40 48             	mov    0x48(%eax),%eax
  8011fc:	83 ec 04             	sub    $0x4,%esp
  8011ff:	53                   	push   %ebx
  801200:	50                   	push   %eax
  801201:	68 4d 28 80 00       	push   $0x80284d
  801206:	e8 6d ef ff ff       	call   800178 <cprintf>
		return -E_INVAL;
  80120b:	83 c4 10             	add    $0x10,%esp
  80120e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801213:	eb da                	jmp    8011ef <read+0x5e>
		return -E_NOT_SUPP;
  801215:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80121a:	eb d3                	jmp    8011ef <read+0x5e>

0080121c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80121c:	f3 0f 1e fb          	endbr32 
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	57                   	push   %edi
  801224:	56                   	push   %esi
  801225:	53                   	push   %ebx
  801226:	83 ec 0c             	sub    $0xc,%esp
  801229:	8b 7d 08             	mov    0x8(%ebp),%edi
  80122c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80122f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801234:	eb 02                	jmp    801238 <readn+0x1c>
  801236:	01 c3                	add    %eax,%ebx
  801238:	39 f3                	cmp    %esi,%ebx
  80123a:	73 21                	jae    80125d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80123c:	83 ec 04             	sub    $0x4,%esp
  80123f:	89 f0                	mov    %esi,%eax
  801241:	29 d8                	sub    %ebx,%eax
  801243:	50                   	push   %eax
  801244:	89 d8                	mov    %ebx,%eax
  801246:	03 45 0c             	add    0xc(%ebp),%eax
  801249:	50                   	push   %eax
  80124a:	57                   	push   %edi
  80124b:	e8 41 ff ff ff       	call   801191 <read>
		if (m < 0)
  801250:	83 c4 10             	add    $0x10,%esp
  801253:	85 c0                	test   %eax,%eax
  801255:	78 04                	js     80125b <readn+0x3f>
			return m;
		if (m == 0)
  801257:	75 dd                	jne    801236 <readn+0x1a>
  801259:	eb 02                	jmp    80125d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80125b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80125d:	89 d8                	mov    %ebx,%eax
  80125f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801262:	5b                   	pop    %ebx
  801263:	5e                   	pop    %esi
  801264:	5f                   	pop    %edi
  801265:	5d                   	pop    %ebp
  801266:	c3                   	ret    

00801267 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801267:	f3 0f 1e fb          	endbr32 
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	53                   	push   %ebx
  80126f:	83 ec 1c             	sub    $0x1c,%esp
  801272:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801275:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801278:	50                   	push   %eax
  801279:	53                   	push   %ebx
  80127a:	e8 8a fc ff ff       	call   800f09 <fd_lookup>
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	78 3a                	js     8012c0 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801286:	83 ec 08             	sub    $0x8,%esp
  801289:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128c:	50                   	push   %eax
  80128d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801290:	ff 30                	pushl  (%eax)
  801292:	e8 c6 fc ff ff       	call   800f5d <dev_lookup>
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	85 c0                	test   %eax,%eax
  80129c:	78 22                	js     8012c0 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80129e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012a5:	74 1e                	je     8012c5 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012aa:	8b 52 0c             	mov    0xc(%edx),%edx
  8012ad:	85 d2                	test   %edx,%edx
  8012af:	74 35                	je     8012e6 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012b1:	83 ec 04             	sub    $0x4,%esp
  8012b4:	ff 75 10             	pushl  0x10(%ebp)
  8012b7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ba:	50                   	push   %eax
  8012bb:	ff d2                	call   *%edx
  8012bd:	83 c4 10             	add    $0x10,%esp
}
  8012c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8012ca:	8b 40 48             	mov    0x48(%eax),%eax
  8012cd:	83 ec 04             	sub    $0x4,%esp
  8012d0:	53                   	push   %ebx
  8012d1:	50                   	push   %eax
  8012d2:	68 69 28 80 00       	push   $0x802869
  8012d7:	e8 9c ee ff ff       	call   800178 <cprintf>
		return -E_INVAL;
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e4:	eb da                	jmp    8012c0 <write+0x59>
		return -E_NOT_SUPP;
  8012e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012eb:	eb d3                	jmp    8012c0 <write+0x59>

008012ed <seek>:

int
seek(int fdnum, off_t offset)
{
  8012ed:	f3 0f 1e fb          	endbr32 
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012fa:	50                   	push   %eax
  8012fb:	ff 75 08             	pushl  0x8(%ebp)
  8012fe:	e8 06 fc ff ff       	call   800f09 <fd_lookup>
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	85 c0                	test   %eax,%eax
  801308:	78 0e                	js     801318 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80130a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801310:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801313:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80131a:	f3 0f 1e fb          	endbr32 
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	53                   	push   %ebx
  801322:	83 ec 1c             	sub    $0x1c,%esp
  801325:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801328:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132b:	50                   	push   %eax
  80132c:	53                   	push   %ebx
  80132d:	e8 d7 fb ff ff       	call   800f09 <fd_lookup>
  801332:	83 c4 10             	add    $0x10,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	78 37                	js     801370 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801339:	83 ec 08             	sub    $0x8,%esp
  80133c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133f:	50                   	push   %eax
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	ff 30                	pushl  (%eax)
  801345:	e8 13 fc ff ff       	call   800f5d <dev_lookup>
  80134a:	83 c4 10             	add    $0x10,%esp
  80134d:	85 c0                	test   %eax,%eax
  80134f:	78 1f                	js     801370 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801354:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801358:	74 1b                	je     801375 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80135a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135d:	8b 52 18             	mov    0x18(%edx),%edx
  801360:	85 d2                	test   %edx,%edx
  801362:	74 32                	je     801396 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801364:	83 ec 08             	sub    $0x8,%esp
  801367:	ff 75 0c             	pushl  0xc(%ebp)
  80136a:	50                   	push   %eax
  80136b:	ff d2                	call   *%edx
  80136d:	83 c4 10             	add    $0x10,%esp
}
  801370:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801373:	c9                   	leave  
  801374:	c3                   	ret    
			thisenv->env_id, fdnum);
  801375:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80137a:	8b 40 48             	mov    0x48(%eax),%eax
  80137d:	83 ec 04             	sub    $0x4,%esp
  801380:	53                   	push   %ebx
  801381:	50                   	push   %eax
  801382:	68 2c 28 80 00       	push   $0x80282c
  801387:	e8 ec ed ff ff       	call   800178 <cprintf>
		return -E_INVAL;
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801394:	eb da                	jmp    801370 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801396:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139b:	eb d3                	jmp    801370 <ftruncate+0x56>

0080139d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80139d:	f3 0f 1e fb          	endbr32 
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	53                   	push   %ebx
  8013a5:	83 ec 1c             	sub    $0x1c,%esp
  8013a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ae:	50                   	push   %eax
  8013af:	ff 75 08             	pushl  0x8(%ebp)
  8013b2:	e8 52 fb ff ff       	call   800f09 <fd_lookup>
  8013b7:	83 c4 10             	add    $0x10,%esp
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	78 4b                	js     801409 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013be:	83 ec 08             	sub    $0x8,%esp
  8013c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c4:	50                   	push   %eax
  8013c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c8:	ff 30                	pushl  (%eax)
  8013ca:	e8 8e fb ff ff       	call   800f5d <dev_lookup>
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	78 33                	js     801409 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8013d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013dd:	74 2f                	je     80140e <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013df:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013e2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013e9:	00 00 00 
	stat->st_isdir = 0;
  8013ec:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013f3:	00 00 00 
	stat->st_dev = dev;
  8013f6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013fc:	83 ec 08             	sub    $0x8,%esp
  8013ff:	53                   	push   %ebx
  801400:	ff 75 f0             	pushl  -0x10(%ebp)
  801403:	ff 50 14             	call   *0x14(%eax)
  801406:	83 c4 10             	add    $0x10,%esp
}
  801409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    
		return -E_NOT_SUPP;
  80140e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801413:	eb f4                	jmp    801409 <fstat+0x6c>

00801415 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801415:	f3 0f 1e fb          	endbr32 
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	56                   	push   %esi
  80141d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80141e:	83 ec 08             	sub    $0x8,%esp
  801421:	6a 00                	push   $0x0
  801423:	ff 75 08             	pushl  0x8(%ebp)
  801426:	e8 fb 01 00 00       	call   801626 <open>
  80142b:	89 c3                	mov    %eax,%ebx
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 1b                	js     80144f <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801434:	83 ec 08             	sub    $0x8,%esp
  801437:	ff 75 0c             	pushl  0xc(%ebp)
  80143a:	50                   	push   %eax
  80143b:	e8 5d ff ff ff       	call   80139d <fstat>
  801440:	89 c6                	mov    %eax,%esi
	close(fd);
  801442:	89 1c 24             	mov    %ebx,(%esp)
  801445:	e8 fd fb ff ff       	call   801047 <close>
	return r;
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	89 f3                	mov    %esi,%ebx
}
  80144f:	89 d8                	mov    %ebx,%eax
  801451:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801454:	5b                   	pop    %ebx
  801455:	5e                   	pop    %esi
  801456:	5d                   	pop    %ebp
  801457:	c3                   	ret    

00801458 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	56                   	push   %esi
  80145c:	53                   	push   %ebx
  80145d:	89 c6                	mov    %eax,%esi
  80145f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801461:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801468:	74 27                	je     801491 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80146a:	6a 07                	push   $0x7
  80146c:	68 00 50 80 00       	push   $0x805000
  801471:	56                   	push   %esi
  801472:	ff 35 00 40 80 00    	pushl  0x804000
  801478:	e8 d8 0c 00 00       	call   802155 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80147d:	83 c4 0c             	add    $0xc,%esp
  801480:	6a 00                	push   $0x0
  801482:	53                   	push   %ebx
  801483:	6a 00                	push   $0x0
  801485:	e8 46 0c 00 00       	call   8020d0 <ipc_recv>
}
  80148a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80148d:	5b                   	pop    %ebx
  80148e:	5e                   	pop    %esi
  80148f:	5d                   	pop    %ebp
  801490:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801491:	83 ec 0c             	sub    $0xc,%esp
  801494:	6a 01                	push   $0x1
  801496:	e8 12 0d 00 00       	call   8021ad <ipc_find_env>
  80149b:	a3 00 40 80 00       	mov    %eax,0x804000
  8014a0:	83 c4 10             	add    $0x10,%esp
  8014a3:	eb c5                	jmp    80146a <fsipc+0x12>

008014a5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014a5:	f3 0f 1e fb          	endbr32 
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8014b5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8014cc:	e8 87 ff ff ff       	call   801458 <fsipc>
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <devfile_flush>:
{
  8014d3:	f3 0f 1e fb          	endbr32 
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8014e3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ed:	b8 06 00 00 00       	mov    $0x6,%eax
  8014f2:	e8 61 ff ff ff       	call   801458 <fsipc>
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <devfile_stat>:
{
  8014f9:	f3 0f 1e fb          	endbr32 
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	53                   	push   %ebx
  801501:	83 ec 04             	sub    $0x4,%esp
  801504:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8b 40 0c             	mov    0xc(%eax),%eax
  80150d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801512:	ba 00 00 00 00       	mov    $0x0,%edx
  801517:	b8 05 00 00 00       	mov    $0x5,%eax
  80151c:	e8 37 ff ff ff       	call   801458 <fsipc>
  801521:	85 c0                	test   %eax,%eax
  801523:	78 2c                	js     801551 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801525:	83 ec 08             	sub    $0x8,%esp
  801528:	68 00 50 80 00       	push   $0x805000
  80152d:	53                   	push   %ebx
  80152e:	e8 4f f2 ff ff       	call   800782 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801533:	a1 80 50 80 00       	mov    0x805080,%eax
  801538:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80153e:	a1 84 50 80 00       	mov    0x805084,%eax
  801543:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801551:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <devfile_write>:
{
  801556:	f3 0f 1e fb          	endbr32 
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
  80155d:	83 ec 0c             	sub    $0xc,%esp
  801560:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801563:	8b 55 08             	mov    0x8(%ebp),%edx
  801566:	8b 52 0c             	mov    0xc(%edx),%edx
  801569:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80156f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801574:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801579:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80157c:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801581:	50                   	push   %eax
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	68 08 50 80 00       	push   $0x805008
  80158a:	e8 a9 f3 ff ff       	call   800938 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80158f:	ba 00 00 00 00       	mov    $0x0,%edx
  801594:	b8 04 00 00 00       	mov    $0x4,%eax
  801599:	e8 ba fe ff ff       	call   801458 <fsipc>
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <devfile_read>:
{
  8015a0:	f3 0f 1e fb          	endbr32 
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	56                   	push   %esi
  8015a8:	53                   	push   %ebx
  8015a9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015b7:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c2:	b8 03 00 00 00       	mov    $0x3,%eax
  8015c7:	e8 8c fe ff ff       	call   801458 <fsipc>
  8015cc:	89 c3                	mov    %eax,%ebx
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	78 1f                	js     8015f1 <devfile_read+0x51>
	assert(r <= n);
  8015d2:	39 f0                	cmp    %esi,%eax
  8015d4:	77 24                	ja     8015fa <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8015d6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015db:	7f 33                	jg     801610 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015dd:	83 ec 04             	sub    $0x4,%esp
  8015e0:	50                   	push   %eax
  8015e1:	68 00 50 80 00       	push   $0x805000
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	e8 4a f3 ff ff       	call   800938 <memmove>
	return r;
  8015ee:	83 c4 10             	add    $0x10,%esp
}
  8015f1:	89 d8                	mov    %ebx,%eax
  8015f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f6:	5b                   	pop    %ebx
  8015f7:	5e                   	pop    %esi
  8015f8:	5d                   	pop    %ebp
  8015f9:	c3                   	ret    
	assert(r <= n);
  8015fa:	68 9c 28 80 00       	push   $0x80289c
  8015ff:	68 a3 28 80 00       	push   $0x8028a3
  801604:	6a 7c                	push   $0x7c
  801606:	68 b8 28 80 00       	push   $0x8028b8
  80160b:	e8 76 0a 00 00       	call   802086 <_panic>
	assert(r <= PGSIZE);
  801610:	68 c3 28 80 00       	push   $0x8028c3
  801615:	68 a3 28 80 00       	push   $0x8028a3
  80161a:	6a 7d                	push   $0x7d
  80161c:	68 b8 28 80 00       	push   $0x8028b8
  801621:	e8 60 0a 00 00       	call   802086 <_panic>

00801626 <open>:
{
  801626:	f3 0f 1e fb          	endbr32 
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	56                   	push   %esi
  80162e:	53                   	push   %ebx
  80162f:	83 ec 1c             	sub    $0x1c,%esp
  801632:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801635:	56                   	push   %esi
  801636:	e8 04 f1 ff ff       	call   80073f <strlen>
  80163b:	83 c4 10             	add    $0x10,%esp
  80163e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801643:	7f 6c                	jg     8016b1 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801645:	83 ec 0c             	sub    $0xc,%esp
  801648:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164b:	50                   	push   %eax
  80164c:	e8 62 f8 ff ff       	call   800eb3 <fd_alloc>
  801651:	89 c3                	mov    %eax,%ebx
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	85 c0                	test   %eax,%eax
  801658:	78 3c                	js     801696 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80165a:	83 ec 08             	sub    $0x8,%esp
  80165d:	56                   	push   %esi
  80165e:	68 00 50 80 00       	push   $0x805000
  801663:	e8 1a f1 ff ff       	call   800782 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801668:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801670:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801673:	b8 01 00 00 00       	mov    $0x1,%eax
  801678:	e8 db fd ff ff       	call   801458 <fsipc>
  80167d:	89 c3                	mov    %eax,%ebx
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	85 c0                	test   %eax,%eax
  801684:	78 19                	js     80169f <open+0x79>
	return fd2num(fd);
  801686:	83 ec 0c             	sub    $0xc,%esp
  801689:	ff 75 f4             	pushl  -0xc(%ebp)
  80168c:	e8 f3 f7 ff ff       	call   800e84 <fd2num>
  801691:	89 c3                	mov    %eax,%ebx
  801693:	83 c4 10             	add    $0x10,%esp
}
  801696:	89 d8                	mov    %ebx,%eax
  801698:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169b:	5b                   	pop    %ebx
  80169c:	5e                   	pop    %esi
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    
		fd_close(fd, 0);
  80169f:	83 ec 08             	sub    $0x8,%esp
  8016a2:	6a 00                	push   $0x0
  8016a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a7:	e8 10 f9 ff ff       	call   800fbc <fd_close>
		return r;
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	eb e5                	jmp    801696 <open+0x70>
		return -E_BAD_PATH;
  8016b1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016b6:	eb de                	jmp    801696 <open+0x70>

008016b8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016b8:	f3 0f 1e fb          	endbr32 
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c7:	b8 08 00 00 00       	mov    $0x8,%eax
  8016cc:	e8 87 fd ff ff       	call   801458 <fsipc>
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8016d3:	f3 0f 1e fb          	endbr32 
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8016dd:	68 cf 28 80 00       	push   $0x8028cf
  8016e2:	ff 75 0c             	pushl  0xc(%ebp)
  8016e5:	e8 98 f0 ff ff       	call   800782 <strcpy>
	return 0;
}
  8016ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <devsock_close>:
{
  8016f1:	f3 0f 1e fb          	endbr32 
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	53                   	push   %ebx
  8016f9:	83 ec 10             	sub    $0x10,%esp
  8016fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8016ff:	53                   	push   %ebx
  801700:	e8 e5 0a 00 00       	call   8021ea <pageref>
  801705:	89 c2                	mov    %eax,%edx
  801707:	83 c4 10             	add    $0x10,%esp
		return 0;
  80170a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  80170f:	83 fa 01             	cmp    $0x1,%edx
  801712:	74 05                	je     801719 <devsock_close+0x28>
}
  801714:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801717:	c9                   	leave  
  801718:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801719:	83 ec 0c             	sub    $0xc,%esp
  80171c:	ff 73 0c             	pushl  0xc(%ebx)
  80171f:	e8 e3 02 00 00       	call   801a07 <nsipc_close>
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	eb eb                	jmp    801714 <devsock_close+0x23>

00801729 <devsock_write>:
{
  801729:	f3 0f 1e fb          	endbr32 
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801733:	6a 00                	push   $0x0
  801735:	ff 75 10             	pushl  0x10(%ebp)
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	ff 70 0c             	pushl  0xc(%eax)
  801741:	e8 b5 03 00 00       	call   801afb <nsipc_send>
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <devsock_read>:
{
  801748:	f3 0f 1e fb          	endbr32 
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801752:	6a 00                	push   $0x0
  801754:	ff 75 10             	pushl  0x10(%ebp)
  801757:	ff 75 0c             	pushl  0xc(%ebp)
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	ff 70 0c             	pushl  0xc(%eax)
  801760:	e8 1f 03 00 00       	call   801a84 <nsipc_recv>
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <fd2sockid>:
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80176d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801770:	52                   	push   %edx
  801771:	50                   	push   %eax
  801772:	e8 92 f7 ff ff       	call   800f09 <fd_lookup>
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 10                	js     80178e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80177e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801781:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801787:	39 08                	cmp    %ecx,(%eax)
  801789:	75 05                	jne    801790 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80178b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    
		return -E_NOT_SUPP;
  801790:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801795:	eb f7                	jmp    80178e <fd2sockid+0x27>

00801797 <alloc_sockfd>:
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	56                   	push   %esi
  80179b:	53                   	push   %ebx
  80179c:	83 ec 1c             	sub    $0x1c,%esp
  80179f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8017a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a4:	50                   	push   %eax
  8017a5:	e8 09 f7 ff ff       	call   800eb3 <fd_alloc>
  8017aa:	89 c3                	mov    %eax,%ebx
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	78 43                	js     8017f6 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	68 07 04 00 00       	push   $0x407
  8017bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017be:	6a 00                	push   $0x0
  8017c0:	e8 ff f3 ff ff       	call   800bc4 <sys_page_alloc>
  8017c5:	89 c3                	mov    %eax,%ebx
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	78 28                	js     8017f6 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8017ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017d7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8017d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017dc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8017e3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8017e6:	83 ec 0c             	sub    $0xc,%esp
  8017e9:	50                   	push   %eax
  8017ea:	e8 95 f6 ff ff       	call   800e84 <fd2num>
  8017ef:	89 c3                	mov    %eax,%ebx
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	eb 0c                	jmp    801802 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8017f6:	83 ec 0c             	sub    $0xc,%esp
  8017f9:	56                   	push   %esi
  8017fa:	e8 08 02 00 00       	call   801a07 <nsipc_close>
		return r;
  8017ff:	83 c4 10             	add    $0x10,%esp
}
  801802:	89 d8                	mov    %ebx,%eax
  801804:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801807:	5b                   	pop    %ebx
  801808:	5e                   	pop    %esi
  801809:	5d                   	pop    %ebp
  80180a:	c3                   	ret    

0080180b <accept>:
{
  80180b:	f3 0f 1e fb          	endbr32 
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	e8 4a ff ff ff       	call   801767 <fd2sockid>
  80181d:	85 c0                	test   %eax,%eax
  80181f:	78 1b                	js     80183c <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	ff 75 10             	pushl  0x10(%ebp)
  801827:	ff 75 0c             	pushl  0xc(%ebp)
  80182a:	50                   	push   %eax
  80182b:	e8 22 01 00 00       	call   801952 <nsipc_accept>
  801830:	83 c4 10             	add    $0x10,%esp
  801833:	85 c0                	test   %eax,%eax
  801835:	78 05                	js     80183c <accept+0x31>
	return alloc_sockfd(r);
  801837:	e8 5b ff ff ff       	call   801797 <alloc_sockfd>
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <bind>:
{
  80183e:	f3 0f 1e fb          	endbr32 
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	e8 17 ff ff ff       	call   801767 <fd2sockid>
  801850:	85 c0                	test   %eax,%eax
  801852:	78 12                	js     801866 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801854:	83 ec 04             	sub    $0x4,%esp
  801857:	ff 75 10             	pushl  0x10(%ebp)
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	e8 45 01 00 00       	call   8019a8 <nsipc_bind>
  801863:	83 c4 10             	add    $0x10,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <shutdown>:
{
  801868:	f3 0f 1e fb          	endbr32 
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	e8 ed fe ff ff       	call   801767 <fd2sockid>
  80187a:	85 c0                	test   %eax,%eax
  80187c:	78 0f                	js     80188d <shutdown+0x25>
	return nsipc_shutdown(r, how);
  80187e:	83 ec 08             	sub    $0x8,%esp
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	50                   	push   %eax
  801885:	e8 57 01 00 00       	call   8019e1 <nsipc_shutdown>
  80188a:	83 c4 10             	add    $0x10,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <connect>:
{
  80188f:	f3 0f 1e fb          	endbr32 
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	e8 c6 fe ff ff       	call   801767 <fd2sockid>
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	78 12                	js     8018b7 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8018a5:	83 ec 04             	sub    $0x4,%esp
  8018a8:	ff 75 10             	pushl  0x10(%ebp)
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	50                   	push   %eax
  8018af:	e8 71 01 00 00       	call   801a25 <nsipc_connect>
  8018b4:	83 c4 10             	add    $0x10,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <listen>:
{
  8018b9:	f3 0f 1e fb          	endbr32 
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	e8 9c fe ff ff       	call   801767 <fd2sockid>
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 0f                	js     8018de <listen+0x25>
	return nsipc_listen(r, backlog);
  8018cf:	83 ec 08             	sub    $0x8,%esp
  8018d2:	ff 75 0c             	pushl  0xc(%ebp)
  8018d5:	50                   	push   %eax
  8018d6:	e8 83 01 00 00       	call   801a5e <nsipc_listen>
  8018db:	83 c4 10             	add    $0x10,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <socket>:

int
socket(int domain, int type, int protocol)
{
  8018e0:	f3 0f 1e fb          	endbr32 
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8018ea:	ff 75 10             	pushl  0x10(%ebp)
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	e8 65 02 00 00       	call   801b5d <nsipc_socket>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	78 05                	js     801904 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8018ff:	e8 93 fe ff ff       	call   801797 <alloc_sockfd>
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	53                   	push   %ebx
  80190a:	83 ec 04             	sub    $0x4,%esp
  80190d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80190f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801916:	74 26                	je     80193e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801918:	6a 07                	push   $0x7
  80191a:	68 00 60 80 00       	push   $0x806000
  80191f:	53                   	push   %ebx
  801920:	ff 35 04 40 80 00    	pushl  0x804004
  801926:	e8 2a 08 00 00       	call   802155 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80192b:	83 c4 0c             	add    $0xc,%esp
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	e8 97 07 00 00       	call   8020d0 <ipc_recv>
}
  801939:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80193e:	83 ec 0c             	sub    $0xc,%esp
  801941:	6a 02                	push   $0x2
  801943:	e8 65 08 00 00       	call   8021ad <ipc_find_env>
  801948:	a3 04 40 80 00       	mov    %eax,0x804004
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	eb c6                	jmp    801918 <nsipc+0x12>

00801952 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801952:	f3 0f 1e fb          	endbr32 
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	56                   	push   %esi
  80195a:	53                   	push   %ebx
  80195b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801966:	8b 06                	mov    (%esi),%eax
  801968:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80196d:	b8 01 00 00 00       	mov    $0x1,%eax
  801972:	e8 8f ff ff ff       	call   801906 <nsipc>
  801977:	89 c3                	mov    %eax,%ebx
  801979:	85 c0                	test   %eax,%eax
  80197b:	79 09                	jns    801986 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80197d:	89 d8                	mov    %ebx,%eax
  80197f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801982:	5b                   	pop    %ebx
  801983:	5e                   	pop    %esi
  801984:	5d                   	pop    %ebp
  801985:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	ff 35 10 60 80 00    	pushl  0x806010
  80198f:	68 00 60 80 00       	push   $0x806000
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	e8 9c ef ff ff       	call   800938 <memmove>
		*addrlen = ret->ret_addrlen;
  80199c:	a1 10 60 80 00       	mov    0x806010,%eax
  8019a1:	89 06                	mov    %eax,(%esi)
  8019a3:	83 c4 10             	add    $0x10,%esp
	return r;
  8019a6:	eb d5                	jmp    80197d <nsipc_accept+0x2b>

008019a8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019a8:	f3 0f 1e fb          	endbr32 
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	53                   	push   %ebx
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8019be:	53                   	push   %ebx
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	68 04 60 80 00       	push   $0x806004
  8019c7:	e8 6c ef ff ff       	call   800938 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8019cc:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8019d2:	b8 02 00 00 00       	mov    $0x2,%eax
  8019d7:	e8 2a ff ff ff       	call   801906 <nsipc>
}
  8019dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8019e1:	f3 0f 1e fb          	endbr32 
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8019f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8019fb:	b8 03 00 00 00       	mov    $0x3,%eax
  801a00:	e8 01 ff ff ff       	call   801906 <nsipc>
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <nsipc_close>:

int
nsipc_close(int s)
{
  801a07:	f3 0f 1e fb          	endbr32 
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801a19:	b8 04 00 00 00       	mov    $0x4,%eax
  801a1e:	e8 e3 fe ff ff       	call   801906 <nsipc>
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a25:	f3 0f 1e fb          	endbr32 
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	53                   	push   %ebx
  801a2d:	83 ec 08             	sub    $0x8,%esp
  801a30:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801a3b:	53                   	push   %ebx
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	68 04 60 80 00       	push   $0x806004
  801a44:	e8 ef ee ff ff       	call   800938 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801a49:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801a4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a54:	e8 ad fe ff ff       	call   801906 <nsipc>
}
  801a59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801a5e:	f3 0f 1e fb          	endbr32 
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a73:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801a78:	b8 06 00 00 00       	mov    $0x6,%eax
  801a7d:	e8 84 fe ff ff       	call   801906 <nsipc>
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a84:	f3 0f 1e fb          	endbr32 
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	56                   	push   %esi
  801a8c:	53                   	push   %ebx
  801a8d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801a98:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa1:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801aa6:	b8 07 00 00 00       	mov    $0x7,%eax
  801aab:	e8 56 fe ff ff       	call   801906 <nsipc>
  801ab0:	89 c3                	mov    %eax,%ebx
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	78 26                	js     801adc <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801ab6:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801abc:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801ac1:	0f 4e c6             	cmovle %esi,%eax
  801ac4:	39 c3                	cmp    %eax,%ebx
  801ac6:	7f 1d                	jg     801ae5 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	53                   	push   %ebx
  801acc:	68 00 60 80 00       	push   $0x806000
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	e8 5f ee ff ff       	call   800938 <memmove>
  801ad9:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801adc:	89 d8                	mov    %ebx,%eax
  801ade:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae1:	5b                   	pop    %ebx
  801ae2:	5e                   	pop    %esi
  801ae3:	5d                   	pop    %ebp
  801ae4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ae5:	68 db 28 80 00       	push   $0x8028db
  801aea:	68 a3 28 80 00       	push   $0x8028a3
  801aef:	6a 62                	push   $0x62
  801af1:	68 f0 28 80 00       	push   $0x8028f0
  801af6:	e8 8b 05 00 00       	call   802086 <_panic>

00801afb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801afb:	f3 0f 1e fb          	endbr32 
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	53                   	push   %ebx
  801b03:	83 ec 04             	sub    $0x4,%esp
  801b06:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801b11:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801b17:	7f 2e                	jg     801b47 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	53                   	push   %ebx
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	68 0c 60 80 00       	push   $0x80600c
  801b25:	e8 0e ee ff ff       	call   800938 <memmove>
	nsipcbuf.send.req_size = size;
  801b2a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801b30:	8b 45 14             	mov    0x14(%ebp),%eax
  801b33:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801b38:	b8 08 00 00 00       	mov    $0x8,%eax
  801b3d:	e8 c4 fd ff ff       	call   801906 <nsipc>
}
  801b42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    
	assert(size < 1600);
  801b47:	68 fc 28 80 00       	push   $0x8028fc
  801b4c:	68 a3 28 80 00       	push   $0x8028a3
  801b51:	6a 6d                	push   $0x6d
  801b53:	68 f0 28 80 00       	push   $0x8028f0
  801b58:	e8 29 05 00 00       	call   802086 <_panic>

00801b5d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801b5d:	f3 0f 1e fb          	endbr32 
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b72:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801b77:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801b7f:	b8 09 00 00 00       	mov    $0x9,%eax
  801b84:	e8 7d fd ff ff       	call   801906 <nsipc>
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b8b:	f3 0f 1e fb          	endbr32 
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b97:	83 ec 0c             	sub    $0xc,%esp
  801b9a:	ff 75 08             	pushl  0x8(%ebp)
  801b9d:	e8 f6 f2 ff ff       	call   800e98 <fd2data>
  801ba2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ba4:	83 c4 08             	add    $0x8,%esp
  801ba7:	68 08 29 80 00       	push   $0x802908
  801bac:	53                   	push   %ebx
  801bad:	e8 d0 eb ff ff       	call   800782 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bb2:	8b 46 04             	mov    0x4(%esi),%eax
  801bb5:	2b 06                	sub    (%esi),%eax
  801bb7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bbd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bc4:	00 00 00 
	stat->st_dev = &devpipe;
  801bc7:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801bce:	30 80 00 
	return 0;
}
  801bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd9:	5b                   	pop    %ebx
  801bda:	5e                   	pop    %esi
  801bdb:	5d                   	pop    %ebp
  801bdc:	c3                   	ret    

00801bdd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bdd:	f3 0f 1e fb          	endbr32 
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	53                   	push   %ebx
  801be5:	83 ec 0c             	sub    $0xc,%esp
  801be8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801beb:	53                   	push   %ebx
  801bec:	6a 00                	push   $0x0
  801bee:	e8 5e f0 ff ff       	call   800c51 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bf3:	89 1c 24             	mov    %ebx,(%esp)
  801bf6:	e8 9d f2 ff ff       	call   800e98 <fd2data>
  801bfb:	83 c4 08             	add    $0x8,%esp
  801bfe:	50                   	push   %eax
  801bff:	6a 00                	push   $0x0
  801c01:	e8 4b f0 ff ff       	call   800c51 <sys_page_unmap>
}
  801c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <_pipeisclosed>:
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	57                   	push   %edi
  801c0f:	56                   	push   %esi
  801c10:	53                   	push   %ebx
  801c11:	83 ec 1c             	sub    $0x1c,%esp
  801c14:	89 c7                	mov    %eax,%edi
  801c16:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c18:	a1 08 40 80 00       	mov    0x804008,%eax
  801c1d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c20:	83 ec 0c             	sub    $0xc,%esp
  801c23:	57                   	push   %edi
  801c24:	e8 c1 05 00 00       	call   8021ea <pageref>
  801c29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c2c:	89 34 24             	mov    %esi,(%esp)
  801c2f:	e8 b6 05 00 00       	call   8021ea <pageref>
		nn = thisenv->env_runs;
  801c34:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c3a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c3d:	83 c4 10             	add    $0x10,%esp
  801c40:	39 cb                	cmp    %ecx,%ebx
  801c42:	74 1b                	je     801c5f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c44:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c47:	75 cf                	jne    801c18 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c49:	8b 42 58             	mov    0x58(%edx),%eax
  801c4c:	6a 01                	push   $0x1
  801c4e:	50                   	push   %eax
  801c4f:	53                   	push   %ebx
  801c50:	68 0f 29 80 00       	push   $0x80290f
  801c55:	e8 1e e5 ff ff       	call   800178 <cprintf>
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	eb b9                	jmp    801c18 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c5f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c62:	0f 94 c0             	sete   %al
  801c65:	0f b6 c0             	movzbl %al,%eax
}
  801c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5f                   	pop    %edi
  801c6e:	5d                   	pop    %ebp
  801c6f:	c3                   	ret    

00801c70 <devpipe_write>:
{
  801c70:	f3 0f 1e fb          	endbr32 
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	57                   	push   %edi
  801c78:	56                   	push   %esi
  801c79:	53                   	push   %ebx
  801c7a:	83 ec 28             	sub    $0x28,%esp
  801c7d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c80:	56                   	push   %esi
  801c81:	e8 12 f2 ff ff       	call   800e98 <fd2data>
  801c86:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	bf 00 00 00 00       	mov    $0x0,%edi
  801c90:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c93:	74 4f                	je     801ce4 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c95:	8b 43 04             	mov    0x4(%ebx),%eax
  801c98:	8b 0b                	mov    (%ebx),%ecx
  801c9a:	8d 51 20             	lea    0x20(%ecx),%edx
  801c9d:	39 d0                	cmp    %edx,%eax
  801c9f:	72 14                	jb     801cb5 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801ca1:	89 da                	mov    %ebx,%edx
  801ca3:	89 f0                	mov    %esi,%eax
  801ca5:	e8 61 ff ff ff       	call   801c0b <_pipeisclosed>
  801caa:	85 c0                	test   %eax,%eax
  801cac:	75 3b                	jne    801ce9 <devpipe_write+0x79>
			sys_yield();
  801cae:	e8 ee ee ff ff       	call   800ba1 <sys_yield>
  801cb3:	eb e0                	jmp    801c95 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cbc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cbf:	89 c2                	mov    %eax,%edx
  801cc1:	c1 fa 1f             	sar    $0x1f,%edx
  801cc4:	89 d1                	mov    %edx,%ecx
  801cc6:	c1 e9 1b             	shr    $0x1b,%ecx
  801cc9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ccc:	83 e2 1f             	and    $0x1f,%edx
  801ccf:	29 ca                	sub    %ecx,%edx
  801cd1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cd5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cd9:	83 c0 01             	add    $0x1,%eax
  801cdc:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cdf:	83 c7 01             	add    $0x1,%edi
  801ce2:	eb ac                	jmp    801c90 <devpipe_write+0x20>
	return i;
  801ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce7:	eb 05                	jmp    801cee <devpipe_write+0x7e>
				return 0;
  801ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf1:	5b                   	pop    %ebx
  801cf2:	5e                   	pop    %esi
  801cf3:	5f                   	pop    %edi
  801cf4:	5d                   	pop    %ebp
  801cf5:	c3                   	ret    

00801cf6 <devpipe_read>:
{
  801cf6:	f3 0f 1e fb          	endbr32 
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	57                   	push   %edi
  801cfe:	56                   	push   %esi
  801cff:	53                   	push   %ebx
  801d00:	83 ec 18             	sub    $0x18,%esp
  801d03:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d06:	57                   	push   %edi
  801d07:	e8 8c f1 ff ff       	call   800e98 <fd2data>
  801d0c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	be 00 00 00 00       	mov    $0x0,%esi
  801d16:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d19:	75 14                	jne    801d2f <devpipe_read+0x39>
	return i;
  801d1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1e:	eb 02                	jmp    801d22 <devpipe_read+0x2c>
				return i;
  801d20:	89 f0                	mov    %esi,%eax
}
  801d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5f                   	pop    %edi
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    
			sys_yield();
  801d2a:	e8 72 ee ff ff       	call   800ba1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d2f:	8b 03                	mov    (%ebx),%eax
  801d31:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d34:	75 18                	jne    801d4e <devpipe_read+0x58>
			if (i > 0)
  801d36:	85 f6                	test   %esi,%esi
  801d38:	75 e6                	jne    801d20 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d3a:	89 da                	mov    %ebx,%edx
  801d3c:	89 f8                	mov    %edi,%eax
  801d3e:	e8 c8 fe ff ff       	call   801c0b <_pipeisclosed>
  801d43:	85 c0                	test   %eax,%eax
  801d45:	74 e3                	je     801d2a <devpipe_read+0x34>
				return 0;
  801d47:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4c:	eb d4                	jmp    801d22 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d4e:	99                   	cltd   
  801d4f:	c1 ea 1b             	shr    $0x1b,%edx
  801d52:	01 d0                	add    %edx,%eax
  801d54:	83 e0 1f             	and    $0x1f,%eax
  801d57:	29 d0                	sub    %edx,%eax
  801d59:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d61:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d64:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d67:	83 c6 01             	add    $0x1,%esi
  801d6a:	eb aa                	jmp    801d16 <devpipe_read+0x20>

00801d6c <pipe>:
{
  801d6c:	f3 0f 1e fb          	endbr32 
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	56                   	push   %esi
  801d74:	53                   	push   %ebx
  801d75:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d7b:	50                   	push   %eax
  801d7c:	e8 32 f1 ff ff       	call   800eb3 <fd_alloc>
  801d81:	89 c3                	mov    %eax,%ebx
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	85 c0                	test   %eax,%eax
  801d88:	0f 88 23 01 00 00    	js     801eb1 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d8e:	83 ec 04             	sub    $0x4,%esp
  801d91:	68 07 04 00 00       	push   $0x407
  801d96:	ff 75 f4             	pushl  -0xc(%ebp)
  801d99:	6a 00                	push   $0x0
  801d9b:	e8 24 ee ff ff       	call   800bc4 <sys_page_alloc>
  801da0:	89 c3                	mov    %eax,%ebx
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	85 c0                	test   %eax,%eax
  801da7:	0f 88 04 01 00 00    	js     801eb1 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801db3:	50                   	push   %eax
  801db4:	e8 fa f0 ff ff       	call   800eb3 <fd_alloc>
  801db9:	89 c3                	mov    %eax,%ebx
  801dbb:	83 c4 10             	add    $0x10,%esp
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	0f 88 db 00 00 00    	js     801ea1 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dc6:	83 ec 04             	sub    $0x4,%esp
  801dc9:	68 07 04 00 00       	push   $0x407
  801dce:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd1:	6a 00                	push   $0x0
  801dd3:	e8 ec ed ff ff       	call   800bc4 <sys_page_alloc>
  801dd8:	89 c3                	mov    %eax,%ebx
  801dda:	83 c4 10             	add    $0x10,%esp
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	0f 88 bc 00 00 00    	js     801ea1 <pipe+0x135>
	va = fd2data(fd0);
  801de5:	83 ec 0c             	sub    $0xc,%esp
  801de8:	ff 75 f4             	pushl  -0xc(%ebp)
  801deb:	e8 a8 f0 ff ff       	call   800e98 <fd2data>
  801df0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df2:	83 c4 0c             	add    $0xc,%esp
  801df5:	68 07 04 00 00       	push   $0x407
  801dfa:	50                   	push   %eax
  801dfb:	6a 00                	push   $0x0
  801dfd:	e8 c2 ed ff ff       	call   800bc4 <sys_page_alloc>
  801e02:	89 c3                	mov    %eax,%ebx
  801e04:	83 c4 10             	add    $0x10,%esp
  801e07:	85 c0                	test   %eax,%eax
  801e09:	0f 88 82 00 00 00    	js     801e91 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e0f:	83 ec 0c             	sub    $0xc,%esp
  801e12:	ff 75 f0             	pushl  -0x10(%ebp)
  801e15:	e8 7e f0 ff ff       	call   800e98 <fd2data>
  801e1a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e21:	50                   	push   %eax
  801e22:	6a 00                	push   $0x0
  801e24:	56                   	push   %esi
  801e25:	6a 00                	push   $0x0
  801e27:	e8 df ed ff ff       	call   800c0b <sys_page_map>
  801e2c:	89 c3                	mov    %eax,%ebx
  801e2e:	83 c4 20             	add    $0x20,%esp
  801e31:	85 c0                	test   %eax,%eax
  801e33:	78 4e                	js     801e83 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e35:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e42:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e4c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e51:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e58:	83 ec 0c             	sub    $0xc,%esp
  801e5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5e:	e8 21 f0 ff ff       	call   800e84 <fd2num>
  801e63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e66:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e68:	83 c4 04             	add    $0x4,%esp
  801e6b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e6e:	e8 11 f0 ff ff       	call   800e84 <fd2num>
  801e73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e76:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e79:	83 c4 10             	add    $0x10,%esp
  801e7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e81:	eb 2e                	jmp    801eb1 <pipe+0x145>
	sys_page_unmap(0, va);
  801e83:	83 ec 08             	sub    $0x8,%esp
  801e86:	56                   	push   %esi
  801e87:	6a 00                	push   $0x0
  801e89:	e8 c3 ed ff ff       	call   800c51 <sys_page_unmap>
  801e8e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e91:	83 ec 08             	sub    $0x8,%esp
  801e94:	ff 75 f0             	pushl  -0x10(%ebp)
  801e97:	6a 00                	push   $0x0
  801e99:	e8 b3 ed ff ff       	call   800c51 <sys_page_unmap>
  801e9e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ea1:	83 ec 08             	sub    $0x8,%esp
  801ea4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 a3 ed ff ff       	call   800c51 <sys_page_unmap>
  801eae:	83 c4 10             	add    $0x10,%esp
}
  801eb1:	89 d8                	mov    %ebx,%eax
  801eb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eb6:	5b                   	pop    %ebx
  801eb7:	5e                   	pop    %esi
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    

00801eba <pipeisclosed>:
{
  801eba:	f3 0f 1e fb          	endbr32 
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ec4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec7:	50                   	push   %eax
  801ec8:	ff 75 08             	pushl  0x8(%ebp)
  801ecb:	e8 39 f0 ff ff       	call   800f09 <fd_lookup>
  801ed0:	83 c4 10             	add    $0x10,%esp
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	78 18                	js     801eef <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801ed7:	83 ec 0c             	sub    $0xc,%esp
  801eda:	ff 75 f4             	pushl  -0xc(%ebp)
  801edd:	e8 b6 ef ff ff       	call   800e98 <fd2data>
  801ee2:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee7:	e8 1f fd ff ff       	call   801c0b <_pipeisclosed>
  801eec:	83 c4 10             	add    $0x10,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ef1:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  801efa:	c3                   	ret    

00801efb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801efb:	f3 0f 1e fb          	endbr32 
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f05:	68 27 29 80 00       	push   $0x802927
  801f0a:	ff 75 0c             	pushl  0xc(%ebp)
  801f0d:	e8 70 e8 ff ff       	call   800782 <strcpy>
	return 0;
}
  801f12:	b8 00 00 00 00       	mov    $0x0,%eax
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <devcons_write>:
{
  801f19:	f3 0f 1e fb          	endbr32 
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	57                   	push   %edi
  801f21:	56                   	push   %esi
  801f22:	53                   	push   %ebx
  801f23:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f29:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f2e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f34:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f37:	73 31                	jae    801f6a <devcons_write+0x51>
		m = n - tot;
  801f39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f3c:	29 f3                	sub    %esi,%ebx
  801f3e:	83 fb 7f             	cmp    $0x7f,%ebx
  801f41:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f46:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f49:	83 ec 04             	sub    $0x4,%esp
  801f4c:	53                   	push   %ebx
  801f4d:	89 f0                	mov    %esi,%eax
  801f4f:	03 45 0c             	add    0xc(%ebp),%eax
  801f52:	50                   	push   %eax
  801f53:	57                   	push   %edi
  801f54:	e8 df e9 ff ff       	call   800938 <memmove>
		sys_cputs(buf, m);
  801f59:	83 c4 08             	add    $0x8,%esp
  801f5c:	53                   	push   %ebx
  801f5d:	57                   	push   %edi
  801f5e:	e8 91 eb ff ff       	call   800af4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f63:	01 de                	add    %ebx,%esi
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	eb ca                	jmp    801f34 <devcons_write+0x1b>
}
  801f6a:	89 f0                	mov    %esi,%eax
  801f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5e                   	pop    %esi
  801f71:	5f                   	pop    %edi
  801f72:	5d                   	pop    %ebp
  801f73:	c3                   	ret    

00801f74 <devcons_read>:
{
  801f74:	f3 0f 1e fb          	endbr32 
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 08             	sub    $0x8,%esp
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f87:	74 21                	je     801faa <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f89:	e8 88 eb ff ff       	call   800b16 <sys_cgetc>
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	75 07                	jne    801f99 <devcons_read+0x25>
		sys_yield();
  801f92:	e8 0a ec ff ff       	call   800ba1 <sys_yield>
  801f97:	eb f0                	jmp    801f89 <devcons_read+0x15>
	if (c < 0)
  801f99:	78 0f                	js     801faa <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f9b:	83 f8 04             	cmp    $0x4,%eax
  801f9e:	74 0c                	je     801fac <devcons_read+0x38>
	*(char*)vbuf = c;
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	88 02                	mov    %al,(%edx)
	return 1;
  801fa5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    
		return 0;
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	eb f7                	jmp    801faa <devcons_read+0x36>

00801fb3 <cputchar>:
{
  801fb3:	f3 0f 1e fb          	endbr32 
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fc3:	6a 01                	push   $0x1
  801fc5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fc8:	50                   	push   %eax
  801fc9:	e8 26 eb ff ff       	call   800af4 <sys_cputs>
}
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <getchar>:
{
  801fd3:	f3 0f 1e fb          	endbr32 
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fdd:	6a 01                	push   $0x1
  801fdf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fe2:	50                   	push   %eax
  801fe3:	6a 00                	push   $0x0
  801fe5:	e8 a7 f1 ff ff       	call   801191 <read>
	if (r < 0)
  801fea:	83 c4 10             	add    $0x10,%esp
  801fed:	85 c0                	test   %eax,%eax
  801fef:	78 06                	js     801ff7 <getchar+0x24>
	if (r < 1)
  801ff1:	74 06                	je     801ff9 <getchar+0x26>
	return c;
  801ff3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    
		return -E_EOF;
  801ff9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ffe:	eb f7                	jmp    801ff7 <getchar+0x24>

00802000 <iscons>:
{
  802000:	f3 0f 1e fb          	endbr32 
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80200a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80200d:	50                   	push   %eax
  80200e:	ff 75 08             	pushl  0x8(%ebp)
  802011:	e8 f3 ee ff ff       	call   800f09 <fd_lookup>
  802016:	83 c4 10             	add    $0x10,%esp
  802019:	85 c0                	test   %eax,%eax
  80201b:	78 11                	js     80202e <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802020:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802026:	39 10                	cmp    %edx,(%eax)
  802028:	0f 94 c0             	sete   %al
  80202b:	0f b6 c0             	movzbl %al,%eax
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <opencons>:
{
  802030:	f3 0f 1e fb          	endbr32 
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80203a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80203d:	50                   	push   %eax
  80203e:	e8 70 ee ff ff       	call   800eb3 <fd_alloc>
  802043:	83 c4 10             	add    $0x10,%esp
  802046:	85 c0                	test   %eax,%eax
  802048:	78 3a                	js     802084 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80204a:	83 ec 04             	sub    $0x4,%esp
  80204d:	68 07 04 00 00       	push   $0x407
  802052:	ff 75 f4             	pushl  -0xc(%ebp)
  802055:	6a 00                	push   $0x0
  802057:	e8 68 eb ff ff       	call   800bc4 <sys_page_alloc>
  80205c:	83 c4 10             	add    $0x10,%esp
  80205f:	85 c0                	test   %eax,%eax
  802061:	78 21                	js     802084 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80206c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802078:	83 ec 0c             	sub    $0xc,%esp
  80207b:	50                   	push   %eax
  80207c:	e8 03 ee ff ff       	call   800e84 <fd2num>
  802081:	83 c4 10             	add    $0x10,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802086:	f3 0f 1e fb          	endbr32 
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	56                   	push   %esi
  80208e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80208f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802092:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802098:	e8 e1 ea ff ff       	call   800b7e <sys_getenvid>
  80209d:	83 ec 0c             	sub    $0xc,%esp
  8020a0:	ff 75 0c             	pushl  0xc(%ebp)
  8020a3:	ff 75 08             	pushl  0x8(%ebp)
  8020a6:	56                   	push   %esi
  8020a7:	50                   	push   %eax
  8020a8:	68 34 29 80 00       	push   $0x802934
  8020ad:	e8 c6 e0 ff ff       	call   800178 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8020b2:	83 c4 18             	add    $0x18,%esp
  8020b5:	53                   	push   %ebx
  8020b6:	ff 75 10             	pushl  0x10(%ebp)
  8020b9:	e8 65 e0 ff ff       	call   800123 <vcprintf>
	cprintf("\n");
  8020be:	c7 04 24 70 29 80 00 	movl   $0x802970,(%esp)
  8020c5:	e8 ae e0 ff ff       	call   800178 <cprintf>
  8020ca:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020cd:	cc                   	int3   
  8020ce:	eb fd                	jmp    8020cd <_panic+0x47>

008020d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020d0:	f3 0f 1e fb          	endbr32 
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	56                   	push   %esi
  8020d8:	53                   	push   %ebx
  8020d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8020dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020df:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	74 3d                	je     802123 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020e6:	83 ec 0c             	sub    $0xc,%esp
  8020e9:	50                   	push   %eax
  8020ea:	e8 a1 ec ff ff       	call   800d90 <sys_ipc_recv>
  8020ef:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020f2:	85 f6                	test   %esi,%esi
  8020f4:	74 0b                	je     802101 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020f6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020fc:	8b 52 74             	mov    0x74(%edx),%edx
  8020ff:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802101:	85 db                	test   %ebx,%ebx
  802103:	74 0b                	je     802110 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802105:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80210b:	8b 52 78             	mov    0x78(%edx),%edx
  80210e:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802110:	85 c0                	test   %eax,%eax
  802112:	78 21                	js     802135 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802114:	a1 08 40 80 00       	mov    0x804008,%eax
  802119:	8b 40 70             	mov    0x70(%eax),%eax
}
  80211c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80211f:	5b                   	pop    %ebx
  802120:	5e                   	pop    %esi
  802121:	5d                   	pop    %ebp
  802122:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	68 00 00 c0 ee       	push   $0xeec00000
  80212b:	e8 60 ec ff ff       	call   800d90 <sys_ipc_recv>
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	eb bd                	jmp    8020f2 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802135:	85 f6                	test   %esi,%esi
  802137:	74 10                	je     802149 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802139:	85 db                	test   %ebx,%ebx
  80213b:	75 df                	jne    80211c <ipc_recv+0x4c>
  80213d:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802144:	00 00 00 
  802147:	eb d3                	jmp    80211c <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802149:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802150:	00 00 00 
  802153:	eb e4                	jmp    802139 <ipc_recv+0x69>

00802155 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802155:	f3 0f 1e fb          	endbr32 
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	57                   	push   %edi
  80215d:	56                   	push   %esi
  80215e:	53                   	push   %ebx
  80215f:	83 ec 0c             	sub    $0xc,%esp
  802162:	8b 7d 08             	mov    0x8(%ebp),%edi
  802165:	8b 75 0c             	mov    0xc(%ebp),%esi
  802168:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80216b:	85 db                	test   %ebx,%ebx
  80216d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802172:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802175:	ff 75 14             	pushl  0x14(%ebp)
  802178:	53                   	push   %ebx
  802179:	56                   	push   %esi
  80217a:	57                   	push   %edi
  80217b:	e8 e9 eb ff ff       	call   800d69 <sys_ipc_try_send>
  802180:	83 c4 10             	add    $0x10,%esp
  802183:	85 c0                	test   %eax,%eax
  802185:	79 1e                	jns    8021a5 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802187:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80218a:	75 07                	jne    802193 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80218c:	e8 10 ea ff ff       	call   800ba1 <sys_yield>
  802191:	eb e2                	jmp    802175 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802193:	50                   	push   %eax
  802194:	68 57 29 80 00       	push   $0x802957
  802199:	6a 59                	push   $0x59
  80219b:	68 72 29 80 00       	push   $0x802972
  8021a0:	e8 e1 fe ff ff       	call   802086 <_panic>
	}
}
  8021a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021a8:	5b                   	pop    %ebx
  8021a9:	5e                   	pop    %esi
  8021aa:	5f                   	pop    %edi
  8021ab:	5d                   	pop    %ebp
  8021ac:	c3                   	ret    

008021ad <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021ad:	f3 0f 1e fb          	endbr32 
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021b7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021bc:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021bf:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021c5:	8b 52 50             	mov    0x50(%edx),%edx
  8021c8:	39 ca                	cmp    %ecx,%edx
  8021ca:	74 11                	je     8021dd <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021cc:	83 c0 01             	add    $0x1,%eax
  8021cf:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021d4:	75 e6                	jne    8021bc <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021db:	eb 0b                	jmp    8021e8 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021e5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021e8:	5d                   	pop    %ebp
  8021e9:	c3                   	ret    

008021ea <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021ea:	f3 0f 1e fb          	endbr32 
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021f4:	89 c2                	mov    %eax,%edx
  8021f6:	c1 ea 16             	shr    $0x16,%edx
  8021f9:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802200:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802205:	f6 c1 01             	test   $0x1,%cl
  802208:	74 1c                	je     802226 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80220a:	c1 e8 0c             	shr    $0xc,%eax
  80220d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802214:	a8 01                	test   $0x1,%al
  802216:	74 0e                	je     802226 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802218:	c1 e8 0c             	shr    $0xc,%eax
  80221b:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802222:	ef 
  802223:	0f b7 d2             	movzwl %dx,%edx
}
  802226:	89 d0                	mov    %edx,%eax
  802228:	5d                   	pop    %ebp
  802229:	c3                   	ret    
  80222a:	66 90                	xchg   %ax,%ax
  80222c:	66 90                	xchg   %ax,%ax
  80222e:	66 90                	xchg   %ax,%ax

00802230 <__udivdi3>:
  802230:	f3 0f 1e fb          	endbr32 
  802234:	55                   	push   %ebp
  802235:	57                   	push   %edi
  802236:	56                   	push   %esi
  802237:	53                   	push   %ebx
  802238:	83 ec 1c             	sub    $0x1c,%esp
  80223b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80223f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802243:	8b 74 24 34          	mov    0x34(%esp),%esi
  802247:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80224b:	85 d2                	test   %edx,%edx
  80224d:	75 19                	jne    802268 <__udivdi3+0x38>
  80224f:	39 f3                	cmp    %esi,%ebx
  802251:	76 4d                	jbe    8022a0 <__udivdi3+0x70>
  802253:	31 ff                	xor    %edi,%edi
  802255:	89 e8                	mov    %ebp,%eax
  802257:	89 f2                	mov    %esi,%edx
  802259:	f7 f3                	div    %ebx
  80225b:	89 fa                	mov    %edi,%edx
  80225d:	83 c4 1c             	add    $0x1c,%esp
  802260:	5b                   	pop    %ebx
  802261:	5e                   	pop    %esi
  802262:	5f                   	pop    %edi
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    
  802265:	8d 76 00             	lea    0x0(%esi),%esi
  802268:	39 f2                	cmp    %esi,%edx
  80226a:	76 14                	jbe    802280 <__udivdi3+0x50>
  80226c:	31 ff                	xor    %edi,%edi
  80226e:	31 c0                	xor    %eax,%eax
  802270:	89 fa                	mov    %edi,%edx
  802272:	83 c4 1c             	add    $0x1c,%esp
  802275:	5b                   	pop    %ebx
  802276:	5e                   	pop    %esi
  802277:	5f                   	pop    %edi
  802278:	5d                   	pop    %ebp
  802279:	c3                   	ret    
  80227a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802280:	0f bd fa             	bsr    %edx,%edi
  802283:	83 f7 1f             	xor    $0x1f,%edi
  802286:	75 48                	jne    8022d0 <__udivdi3+0xa0>
  802288:	39 f2                	cmp    %esi,%edx
  80228a:	72 06                	jb     802292 <__udivdi3+0x62>
  80228c:	31 c0                	xor    %eax,%eax
  80228e:	39 eb                	cmp    %ebp,%ebx
  802290:	77 de                	ja     802270 <__udivdi3+0x40>
  802292:	b8 01 00 00 00       	mov    $0x1,%eax
  802297:	eb d7                	jmp    802270 <__udivdi3+0x40>
  802299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	89 d9                	mov    %ebx,%ecx
  8022a2:	85 db                	test   %ebx,%ebx
  8022a4:	75 0b                	jne    8022b1 <__udivdi3+0x81>
  8022a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ab:	31 d2                	xor    %edx,%edx
  8022ad:	f7 f3                	div    %ebx
  8022af:	89 c1                	mov    %eax,%ecx
  8022b1:	31 d2                	xor    %edx,%edx
  8022b3:	89 f0                	mov    %esi,%eax
  8022b5:	f7 f1                	div    %ecx
  8022b7:	89 c6                	mov    %eax,%esi
  8022b9:	89 e8                	mov    %ebp,%eax
  8022bb:	89 f7                	mov    %esi,%edi
  8022bd:	f7 f1                	div    %ecx
  8022bf:	89 fa                	mov    %edi,%edx
  8022c1:	83 c4 1c             	add    $0x1c,%esp
  8022c4:	5b                   	pop    %ebx
  8022c5:	5e                   	pop    %esi
  8022c6:	5f                   	pop    %edi
  8022c7:	5d                   	pop    %ebp
  8022c8:	c3                   	ret    
  8022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	89 f9                	mov    %edi,%ecx
  8022d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022d7:	29 f8                	sub    %edi,%eax
  8022d9:	d3 e2                	shl    %cl,%edx
  8022db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022df:	89 c1                	mov    %eax,%ecx
  8022e1:	89 da                	mov    %ebx,%edx
  8022e3:	d3 ea                	shr    %cl,%edx
  8022e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022e9:	09 d1                	or     %edx,%ecx
  8022eb:	89 f2                	mov    %esi,%edx
  8022ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022f1:	89 f9                	mov    %edi,%ecx
  8022f3:	d3 e3                	shl    %cl,%ebx
  8022f5:	89 c1                	mov    %eax,%ecx
  8022f7:	d3 ea                	shr    %cl,%edx
  8022f9:	89 f9                	mov    %edi,%ecx
  8022fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022ff:	89 eb                	mov    %ebp,%ebx
  802301:	d3 e6                	shl    %cl,%esi
  802303:	89 c1                	mov    %eax,%ecx
  802305:	d3 eb                	shr    %cl,%ebx
  802307:	09 de                	or     %ebx,%esi
  802309:	89 f0                	mov    %esi,%eax
  80230b:	f7 74 24 08          	divl   0x8(%esp)
  80230f:	89 d6                	mov    %edx,%esi
  802311:	89 c3                	mov    %eax,%ebx
  802313:	f7 64 24 0c          	mull   0xc(%esp)
  802317:	39 d6                	cmp    %edx,%esi
  802319:	72 15                	jb     802330 <__udivdi3+0x100>
  80231b:	89 f9                	mov    %edi,%ecx
  80231d:	d3 e5                	shl    %cl,%ebp
  80231f:	39 c5                	cmp    %eax,%ebp
  802321:	73 04                	jae    802327 <__udivdi3+0xf7>
  802323:	39 d6                	cmp    %edx,%esi
  802325:	74 09                	je     802330 <__udivdi3+0x100>
  802327:	89 d8                	mov    %ebx,%eax
  802329:	31 ff                	xor    %edi,%edi
  80232b:	e9 40 ff ff ff       	jmp    802270 <__udivdi3+0x40>
  802330:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802333:	31 ff                	xor    %edi,%edi
  802335:	e9 36 ff ff ff       	jmp    802270 <__udivdi3+0x40>
  80233a:	66 90                	xchg   %ax,%ax
  80233c:	66 90                	xchg   %ax,%ax
  80233e:	66 90                	xchg   %ax,%ax

00802340 <__umoddi3>:
  802340:	f3 0f 1e fb          	endbr32 
  802344:	55                   	push   %ebp
  802345:	57                   	push   %edi
  802346:	56                   	push   %esi
  802347:	53                   	push   %ebx
  802348:	83 ec 1c             	sub    $0x1c,%esp
  80234b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80234f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802353:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802357:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80235b:	85 c0                	test   %eax,%eax
  80235d:	75 19                	jne    802378 <__umoddi3+0x38>
  80235f:	39 df                	cmp    %ebx,%edi
  802361:	76 5d                	jbe    8023c0 <__umoddi3+0x80>
  802363:	89 f0                	mov    %esi,%eax
  802365:	89 da                	mov    %ebx,%edx
  802367:	f7 f7                	div    %edi
  802369:	89 d0                	mov    %edx,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	83 c4 1c             	add    $0x1c,%esp
  802370:	5b                   	pop    %ebx
  802371:	5e                   	pop    %esi
  802372:	5f                   	pop    %edi
  802373:	5d                   	pop    %ebp
  802374:	c3                   	ret    
  802375:	8d 76 00             	lea    0x0(%esi),%esi
  802378:	89 f2                	mov    %esi,%edx
  80237a:	39 d8                	cmp    %ebx,%eax
  80237c:	76 12                	jbe    802390 <__umoddi3+0x50>
  80237e:	89 f0                	mov    %esi,%eax
  802380:	89 da                	mov    %ebx,%edx
  802382:	83 c4 1c             	add    $0x1c,%esp
  802385:	5b                   	pop    %ebx
  802386:	5e                   	pop    %esi
  802387:	5f                   	pop    %edi
  802388:	5d                   	pop    %ebp
  802389:	c3                   	ret    
  80238a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802390:	0f bd e8             	bsr    %eax,%ebp
  802393:	83 f5 1f             	xor    $0x1f,%ebp
  802396:	75 50                	jne    8023e8 <__umoddi3+0xa8>
  802398:	39 d8                	cmp    %ebx,%eax
  80239a:	0f 82 e0 00 00 00    	jb     802480 <__umoddi3+0x140>
  8023a0:	89 d9                	mov    %ebx,%ecx
  8023a2:	39 f7                	cmp    %esi,%edi
  8023a4:	0f 86 d6 00 00 00    	jbe    802480 <__umoddi3+0x140>
  8023aa:	89 d0                	mov    %edx,%eax
  8023ac:	89 ca                	mov    %ecx,%edx
  8023ae:	83 c4 1c             	add    $0x1c,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5f                   	pop    %edi
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    
  8023b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	89 fd                	mov    %edi,%ebp
  8023c2:	85 ff                	test   %edi,%edi
  8023c4:	75 0b                	jne    8023d1 <__umoddi3+0x91>
  8023c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023cb:	31 d2                	xor    %edx,%edx
  8023cd:	f7 f7                	div    %edi
  8023cf:	89 c5                	mov    %eax,%ebp
  8023d1:	89 d8                	mov    %ebx,%eax
  8023d3:	31 d2                	xor    %edx,%edx
  8023d5:	f7 f5                	div    %ebp
  8023d7:	89 f0                	mov    %esi,%eax
  8023d9:	f7 f5                	div    %ebp
  8023db:	89 d0                	mov    %edx,%eax
  8023dd:	31 d2                	xor    %edx,%edx
  8023df:	eb 8c                	jmp    80236d <__umoddi3+0x2d>
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	89 e9                	mov    %ebp,%ecx
  8023ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8023ef:	29 ea                	sub    %ebp,%edx
  8023f1:	d3 e0                	shl    %cl,%eax
  8023f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023f7:	89 d1                	mov    %edx,%ecx
  8023f9:	89 f8                	mov    %edi,%eax
  8023fb:	d3 e8                	shr    %cl,%eax
  8023fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802401:	89 54 24 04          	mov    %edx,0x4(%esp)
  802405:	8b 54 24 04          	mov    0x4(%esp),%edx
  802409:	09 c1                	or     %eax,%ecx
  80240b:	89 d8                	mov    %ebx,%eax
  80240d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802411:	89 e9                	mov    %ebp,%ecx
  802413:	d3 e7                	shl    %cl,%edi
  802415:	89 d1                	mov    %edx,%ecx
  802417:	d3 e8                	shr    %cl,%eax
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80241f:	d3 e3                	shl    %cl,%ebx
  802421:	89 c7                	mov    %eax,%edi
  802423:	89 d1                	mov    %edx,%ecx
  802425:	89 f0                	mov    %esi,%eax
  802427:	d3 e8                	shr    %cl,%eax
  802429:	89 e9                	mov    %ebp,%ecx
  80242b:	89 fa                	mov    %edi,%edx
  80242d:	d3 e6                	shl    %cl,%esi
  80242f:	09 d8                	or     %ebx,%eax
  802431:	f7 74 24 08          	divl   0x8(%esp)
  802435:	89 d1                	mov    %edx,%ecx
  802437:	89 f3                	mov    %esi,%ebx
  802439:	f7 64 24 0c          	mull   0xc(%esp)
  80243d:	89 c6                	mov    %eax,%esi
  80243f:	89 d7                	mov    %edx,%edi
  802441:	39 d1                	cmp    %edx,%ecx
  802443:	72 06                	jb     80244b <__umoddi3+0x10b>
  802445:	75 10                	jne    802457 <__umoddi3+0x117>
  802447:	39 c3                	cmp    %eax,%ebx
  802449:	73 0c                	jae    802457 <__umoddi3+0x117>
  80244b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80244f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802453:	89 d7                	mov    %edx,%edi
  802455:	89 c6                	mov    %eax,%esi
  802457:	89 ca                	mov    %ecx,%edx
  802459:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80245e:	29 f3                	sub    %esi,%ebx
  802460:	19 fa                	sbb    %edi,%edx
  802462:	89 d0                	mov    %edx,%eax
  802464:	d3 e0                	shl    %cl,%eax
  802466:	89 e9                	mov    %ebp,%ecx
  802468:	d3 eb                	shr    %cl,%ebx
  80246a:	d3 ea                	shr    %cl,%edx
  80246c:	09 d8                	or     %ebx,%eax
  80246e:	83 c4 1c             	add    $0x1c,%esp
  802471:	5b                   	pop    %ebx
  802472:	5e                   	pop    %esi
  802473:	5f                   	pop    %edi
  802474:	5d                   	pop    %ebp
  802475:	c3                   	ret    
  802476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80247d:	8d 76 00             	lea    0x0(%esi),%esi
  802480:	29 fe                	sub    %edi,%esi
  802482:	19 c3                	sbb    %eax,%ebx
  802484:	89 f2                	mov    %esi,%edx
  802486:	89 d9                	mov    %ebx,%ecx
  802488:	e9 1d ff ff ff       	jmp    8023aa <__umoddi3+0x6a>
