
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
  800052:	68 2e 1f 80 00       	push   $0x801f2e
  800057:	e8 1c 01 00 00       	call   800178 <cprintf>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    
		cprintf("eflags wrong\n");
  800061:	83 ec 0c             	sub    $0xc,%esp
  800064:	68 20 1f 80 00       	push   $0x801f20
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
  800094:	a3 04 40 80 00       	mov    %eax,0x804004

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
  8000c7:	e8 f8 0e 00 00       	call   800fc4 <close_all>
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
  8001de:	e8 dd 1a 00 00       	call   801cc0 <__udivdi3>
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
  80021c:	e8 af 1b 00 00       	call   801dd0 <__umoddi3>
  800221:	83 c4 14             	add    $0x14,%esp
  800224:	0f be 80 52 1f 80 00 	movsbl 0x801f52(%eax),%eax
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
  8002cb:	3e ff 24 85 a0 20 80 	notrack jmp *0x8020a0(,%eax,4)
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
  800398:	8b 14 85 00 22 80 00 	mov    0x802200(,%eax,4),%edx
  80039f:	85 d2                	test   %edx,%edx
  8003a1:	74 18                	je     8003bb <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003a3:	52                   	push   %edx
  8003a4:	68 31 23 80 00       	push   $0x802331
  8003a9:	53                   	push   %ebx
  8003aa:	56                   	push   %esi
  8003ab:	e8 aa fe ff ff       	call   80025a <printfmt>
  8003b0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003b6:	e9 66 02 00 00       	jmp    800621 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003bb:	50                   	push   %eax
  8003bc:	68 6a 1f 80 00       	push   $0x801f6a
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
  8003e3:	b8 63 1f 80 00       	mov    $0x801f63,%eax
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
  800b6d:	68 5f 22 80 00       	push   $0x80225f
  800b72:	6a 23                	push   $0x23
  800b74:	68 7c 22 80 00       	push   $0x80227c
  800b79:	e8 9c 0f 00 00       	call   801b1a <_panic>

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
  800bfa:	68 5f 22 80 00       	push   $0x80225f
  800bff:	6a 23                	push   $0x23
  800c01:	68 7c 22 80 00       	push   $0x80227c
  800c06:	e8 0f 0f 00 00       	call   801b1a <_panic>

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
  800c40:	68 5f 22 80 00       	push   $0x80225f
  800c45:	6a 23                	push   $0x23
  800c47:	68 7c 22 80 00       	push   $0x80227c
  800c4c:	e8 c9 0e 00 00       	call   801b1a <_panic>

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
  800c86:	68 5f 22 80 00       	push   $0x80225f
  800c8b:	6a 23                	push   $0x23
  800c8d:	68 7c 22 80 00       	push   $0x80227c
  800c92:	e8 83 0e 00 00       	call   801b1a <_panic>

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
  800ccc:	68 5f 22 80 00       	push   $0x80225f
  800cd1:	6a 23                	push   $0x23
  800cd3:	68 7c 22 80 00       	push   $0x80227c
  800cd8:	e8 3d 0e 00 00       	call   801b1a <_panic>

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
  800d12:	68 5f 22 80 00       	push   $0x80225f
  800d17:	6a 23                	push   $0x23
  800d19:	68 7c 22 80 00       	push   $0x80227c
  800d1e:	e8 f7 0d 00 00       	call   801b1a <_panic>

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
  800d58:	68 5f 22 80 00       	push   $0x80225f
  800d5d:	6a 23                	push   $0x23
  800d5f:	68 7c 22 80 00       	push   $0x80227c
  800d64:	e8 b1 0d 00 00       	call   801b1a <_panic>

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
  800dc4:	68 5f 22 80 00       	push   $0x80225f
  800dc9:	6a 23                	push   $0x23
  800dcb:	68 7c 22 80 00       	push   $0x80227c
  800dd0:	e8 45 0d 00 00       	call   801b1a <_panic>

00800dd5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800dd5:	f3 0f 1e fb          	endbr32 
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	05 00 00 00 30       	add    $0x30000000,%eax
  800de4:	c1 e8 0c             	shr    $0xc,%eax
}
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800de9:	f3 0f 1e fb          	endbr32 
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800df8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dfd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e04:	f3 0f 1e fb          	endbr32 
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e10:	89 c2                	mov    %eax,%edx
  800e12:	c1 ea 16             	shr    $0x16,%edx
  800e15:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e1c:	f6 c2 01             	test   $0x1,%dl
  800e1f:	74 2d                	je     800e4e <fd_alloc+0x4a>
  800e21:	89 c2                	mov    %eax,%edx
  800e23:	c1 ea 0c             	shr    $0xc,%edx
  800e26:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e2d:	f6 c2 01             	test   $0x1,%dl
  800e30:	74 1c                	je     800e4e <fd_alloc+0x4a>
  800e32:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e37:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e3c:	75 d2                	jne    800e10 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e47:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e4c:	eb 0a                	jmp    800e58 <fd_alloc+0x54>
			*fd_store = fd;
  800e4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e51:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    

00800e5a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e5a:	f3 0f 1e fb          	endbr32 
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e64:	83 f8 1f             	cmp    $0x1f,%eax
  800e67:	77 30                	ja     800e99 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e69:	c1 e0 0c             	shl    $0xc,%eax
  800e6c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e71:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e77:	f6 c2 01             	test   $0x1,%dl
  800e7a:	74 24                	je     800ea0 <fd_lookup+0x46>
  800e7c:	89 c2                	mov    %eax,%edx
  800e7e:	c1 ea 0c             	shr    $0xc,%edx
  800e81:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e88:	f6 c2 01             	test   $0x1,%dl
  800e8b:	74 1a                	je     800ea7 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e90:	89 02                	mov    %eax,(%edx)
	return 0;
  800e92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    
		return -E_INVAL;
  800e99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e9e:	eb f7                	jmp    800e97 <fd_lookup+0x3d>
		return -E_INVAL;
  800ea0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea5:	eb f0                	jmp    800e97 <fd_lookup+0x3d>
  800ea7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eac:	eb e9                	jmp    800e97 <fd_lookup+0x3d>

00800eae <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800eae:	f3 0f 1e fb          	endbr32 
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ebb:	ba 08 23 80 00       	mov    $0x802308,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ec0:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ec5:	39 08                	cmp    %ecx,(%eax)
  800ec7:	74 33                	je     800efc <dev_lookup+0x4e>
  800ec9:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ecc:	8b 02                	mov    (%edx),%eax
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	75 f3                	jne    800ec5 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ed2:	a1 04 40 80 00       	mov    0x804004,%eax
  800ed7:	8b 40 48             	mov    0x48(%eax),%eax
  800eda:	83 ec 04             	sub    $0x4,%esp
  800edd:	51                   	push   %ecx
  800ede:	50                   	push   %eax
  800edf:	68 8c 22 80 00       	push   $0x80228c
  800ee4:	e8 8f f2 ff ff       	call   800178 <cprintf>
	*dev = 0;
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ef2:	83 c4 10             	add    $0x10,%esp
  800ef5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    
			*dev = devtab[i];
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f01:	b8 00 00 00 00       	mov    $0x0,%eax
  800f06:	eb f2                	jmp    800efa <dev_lookup+0x4c>

00800f08 <fd_close>:
{
  800f08:	f3 0f 1e fb          	endbr32 
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	57                   	push   %edi
  800f10:	56                   	push   %esi
  800f11:	53                   	push   %ebx
  800f12:	83 ec 24             	sub    $0x24,%esp
  800f15:	8b 75 08             	mov    0x8(%ebp),%esi
  800f18:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f1b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f1e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f1f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f25:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f28:	50                   	push   %eax
  800f29:	e8 2c ff ff ff       	call   800e5a <fd_lookup>
  800f2e:	89 c3                	mov    %eax,%ebx
  800f30:	83 c4 10             	add    $0x10,%esp
  800f33:	85 c0                	test   %eax,%eax
  800f35:	78 05                	js     800f3c <fd_close+0x34>
	    || fd != fd2)
  800f37:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f3a:	74 16                	je     800f52 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f3c:	89 f8                	mov    %edi,%eax
  800f3e:	84 c0                	test   %al,%al
  800f40:	b8 00 00 00 00       	mov    $0x0,%eax
  800f45:	0f 44 d8             	cmove  %eax,%ebx
}
  800f48:	89 d8                	mov    %ebx,%eax
  800f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4d:	5b                   	pop    %ebx
  800f4e:	5e                   	pop    %esi
  800f4f:	5f                   	pop    %edi
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f58:	50                   	push   %eax
  800f59:	ff 36                	pushl  (%esi)
  800f5b:	e8 4e ff ff ff       	call   800eae <dev_lookup>
  800f60:	89 c3                	mov    %eax,%ebx
  800f62:	83 c4 10             	add    $0x10,%esp
  800f65:	85 c0                	test   %eax,%eax
  800f67:	78 1a                	js     800f83 <fd_close+0x7b>
		if (dev->dev_close)
  800f69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f6c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f6f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f74:	85 c0                	test   %eax,%eax
  800f76:	74 0b                	je     800f83 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f78:	83 ec 0c             	sub    $0xc,%esp
  800f7b:	56                   	push   %esi
  800f7c:	ff d0                	call   *%eax
  800f7e:	89 c3                	mov    %eax,%ebx
  800f80:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f83:	83 ec 08             	sub    $0x8,%esp
  800f86:	56                   	push   %esi
  800f87:	6a 00                	push   $0x0
  800f89:	e8 c3 fc ff ff       	call   800c51 <sys_page_unmap>
	return r;
  800f8e:	83 c4 10             	add    $0x10,%esp
  800f91:	eb b5                	jmp    800f48 <fd_close+0x40>

00800f93 <close>:

int
close(int fdnum)
{
  800f93:	f3 0f 1e fb          	endbr32 
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fa0:	50                   	push   %eax
  800fa1:	ff 75 08             	pushl  0x8(%ebp)
  800fa4:	e8 b1 fe ff ff       	call   800e5a <fd_lookup>
  800fa9:	83 c4 10             	add    $0x10,%esp
  800fac:	85 c0                	test   %eax,%eax
  800fae:	79 02                	jns    800fb2 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800fb0:	c9                   	leave  
  800fb1:	c3                   	ret    
		return fd_close(fd, 1);
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	6a 01                	push   $0x1
  800fb7:	ff 75 f4             	pushl  -0xc(%ebp)
  800fba:	e8 49 ff ff ff       	call   800f08 <fd_close>
  800fbf:	83 c4 10             	add    $0x10,%esp
  800fc2:	eb ec                	jmp    800fb0 <close+0x1d>

00800fc4 <close_all>:

void
close_all(void)
{
  800fc4:	f3 0f 1e fb          	endbr32 
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	53                   	push   %ebx
  800fcc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fcf:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fd4:	83 ec 0c             	sub    $0xc,%esp
  800fd7:	53                   	push   %ebx
  800fd8:	e8 b6 ff ff ff       	call   800f93 <close>
	for (i = 0; i < MAXFD; i++)
  800fdd:	83 c3 01             	add    $0x1,%ebx
  800fe0:	83 c4 10             	add    $0x10,%esp
  800fe3:	83 fb 20             	cmp    $0x20,%ebx
  800fe6:	75 ec                	jne    800fd4 <close_all+0x10>
}
  800fe8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fed:	f3 0f 1e fb          	endbr32 
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	57                   	push   %edi
  800ff5:	56                   	push   %esi
  800ff6:	53                   	push   %ebx
  800ff7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800ffa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ffd:	50                   	push   %eax
  800ffe:	ff 75 08             	pushl  0x8(%ebp)
  801001:	e8 54 fe ff ff       	call   800e5a <fd_lookup>
  801006:	89 c3                	mov    %eax,%ebx
  801008:	83 c4 10             	add    $0x10,%esp
  80100b:	85 c0                	test   %eax,%eax
  80100d:	0f 88 81 00 00 00    	js     801094 <dup+0xa7>
		return r;
	close(newfdnum);
  801013:	83 ec 0c             	sub    $0xc,%esp
  801016:	ff 75 0c             	pushl  0xc(%ebp)
  801019:	e8 75 ff ff ff       	call   800f93 <close>

	newfd = INDEX2FD(newfdnum);
  80101e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801021:	c1 e6 0c             	shl    $0xc,%esi
  801024:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80102a:	83 c4 04             	add    $0x4,%esp
  80102d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801030:	e8 b4 fd ff ff       	call   800de9 <fd2data>
  801035:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801037:	89 34 24             	mov    %esi,(%esp)
  80103a:	e8 aa fd ff ff       	call   800de9 <fd2data>
  80103f:	83 c4 10             	add    $0x10,%esp
  801042:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801044:	89 d8                	mov    %ebx,%eax
  801046:	c1 e8 16             	shr    $0x16,%eax
  801049:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801050:	a8 01                	test   $0x1,%al
  801052:	74 11                	je     801065 <dup+0x78>
  801054:	89 d8                	mov    %ebx,%eax
  801056:	c1 e8 0c             	shr    $0xc,%eax
  801059:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801060:	f6 c2 01             	test   $0x1,%dl
  801063:	75 39                	jne    80109e <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801065:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801068:	89 d0                	mov    %edx,%eax
  80106a:	c1 e8 0c             	shr    $0xc,%eax
  80106d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	25 07 0e 00 00       	and    $0xe07,%eax
  80107c:	50                   	push   %eax
  80107d:	56                   	push   %esi
  80107e:	6a 00                	push   $0x0
  801080:	52                   	push   %edx
  801081:	6a 00                	push   $0x0
  801083:	e8 83 fb ff ff       	call   800c0b <sys_page_map>
  801088:	89 c3                	mov    %eax,%ebx
  80108a:	83 c4 20             	add    $0x20,%esp
  80108d:	85 c0                	test   %eax,%eax
  80108f:	78 31                	js     8010c2 <dup+0xd5>
		goto err;

	return newfdnum;
  801091:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801094:	89 d8                	mov    %ebx,%eax
  801096:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801099:	5b                   	pop    %ebx
  80109a:	5e                   	pop    %esi
  80109b:	5f                   	pop    %edi
  80109c:	5d                   	pop    %ebp
  80109d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80109e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a5:	83 ec 0c             	sub    $0xc,%esp
  8010a8:	25 07 0e 00 00       	and    $0xe07,%eax
  8010ad:	50                   	push   %eax
  8010ae:	57                   	push   %edi
  8010af:	6a 00                	push   $0x0
  8010b1:	53                   	push   %ebx
  8010b2:	6a 00                	push   $0x0
  8010b4:	e8 52 fb ff ff       	call   800c0b <sys_page_map>
  8010b9:	89 c3                	mov    %eax,%ebx
  8010bb:	83 c4 20             	add    $0x20,%esp
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	79 a3                	jns    801065 <dup+0x78>
	sys_page_unmap(0, newfd);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	56                   	push   %esi
  8010c6:	6a 00                	push   $0x0
  8010c8:	e8 84 fb ff ff       	call   800c51 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010cd:	83 c4 08             	add    $0x8,%esp
  8010d0:	57                   	push   %edi
  8010d1:	6a 00                	push   $0x0
  8010d3:	e8 79 fb ff ff       	call   800c51 <sys_page_unmap>
	return r;
  8010d8:	83 c4 10             	add    $0x10,%esp
  8010db:	eb b7                	jmp    801094 <dup+0xa7>

008010dd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010dd:	f3 0f 1e fb          	endbr32 
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	53                   	push   %ebx
  8010e5:	83 ec 1c             	sub    $0x1c,%esp
  8010e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010ee:	50                   	push   %eax
  8010ef:	53                   	push   %ebx
  8010f0:	e8 65 fd ff ff       	call   800e5a <fd_lookup>
  8010f5:	83 c4 10             	add    $0x10,%esp
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	78 3f                	js     80113b <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010fc:	83 ec 08             	sub    $0x8,%esp
  8010ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801102:	50                   	push   %eax
  801103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801106:	ff 30                	pushl  (%eax)
  801108:	e8 a1 fd ff ff       	call   800eae <dev_lookup>
  80110d:	83 c4 10             	add    $0x10,%esp
  801110:	85 c0                	test   %eax,%eax
  801112:	78 27                	js     80113b <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801114:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801117:	8b 42 08             	mov    0x8(%edx),%eax
  80111a:	83 e0 03             	and    $0x3,%eax
  80111d:	83 f8 01             	cmp    $0x1,%eax
  801120:	74 1e                	je     801140 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801125:	8b 40 08             	mov    0x8(%eax),%eax
  801128:	85 c0                	test   %eax,%eax
  80112a:	74 35                	je     801161 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	ff 75 10             	pushl  0x10(%ebp)
  801132:	ff 75 0c             	pushl  0xc(%ebp)
  801135:	52                   	push   %edx
  801136:	ff d0                	call   *%eax
  801138:	83 c4 10             	add    $0x10,%esp
}
  80113b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801140:	a1 04 40 80 00       	mov    0x804004,%eax
  801145:	8b 40 48             	mov    0x48(%eax),%eax
  801148:	83 ec 04             	sub    $0x4,%esp
  80114b:	53                   	push   %ebx
  80114c:	50                   	push   %eax
  80114d:	68 cd 22 80 00       	push   $0x8022cd
  801152:	e8 21 f0 ff ff       	call   800178 <cprintf>
		return -E_INVAL;
  801157:	83 c4 10             	add    $0x10,%esp
  80115a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115f:	eb da                	jmp    80113b <read+0x5e>
		return -E_NOT_SUPP;
  801161:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801166:	eb d3                	jmp    80113b <read+0x5e>

00801168 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801168:	f3 0f 1e fb          	endbr32 
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	57                   	push   %edi
  801170:	56                   	push   %esi
  801171:	53                   	push   %ebx
  801172:	83 ec 0c             	sub    $0xc,%esp
  801175:	8b 7d 08             	mov    0x8(%ebp),%edi
  801178:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80117b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801180:	eb 02                	jmp    801184 <readn+0x1c>
  801182:	01 c3                	add    %eax,%ebx
  801184:	39 f3                	cmp    %esi,%ebx
  801186:	73 21                	jae    8011a9 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801188:	83 ec 04             	sub    $0x4,%esp
  80118b:	89 f0                	mov    %esi,%eax
  80118d:	29 d8                	sub    %ebx,%eax
  80118f:	50                   	push   %eax
  801190:	89 d8                	mov    %ebx,%eax
  801192:	03 45 0c             	add    0xc(%ebp),%eax
  801195:	50                   	push   %eax
  801196:	57                   	push   %edi
  801197:	e8 41 ff ff ff       	call   8010dd <read>
		if (m < 0)
  80119c:	83 c4 10             	add    $0x10,%esp
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	78 04                	js     8011a7 <readn+0x3f>
			return m;
		if (m == 0)
  8011a3:	75 dd                	jne    801182 <readn+0x1a>
  8011a5:	eb 02                	jmp    8011a9 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011a7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011a9:	89 d8                	mov    %ebx,%eax
  8011ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ae:	5b                   	pop    %ebx
  8011af:	5e                   	pop    %esi
  8011b0:	5f                   	pop    %edi
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    

008011b3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011b3:	f3 0f 1e fb          	endbr32 
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 1c             	sub    $0x1c,%esp
  8011be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011c4:	50                   	push   %eax
  8011c5:	53                   	push   %ebx
  8011c6:	e8 8f fc ff ff       	call   800e5a <fd_lookup>
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	78 3a                	js     80120c <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011d2:	83 ec 08             	sub    $0x8,%esp
  8011d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d8:	50                   	push   %eax
  8011d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011dc:	ff 30                	pushl  (%eax)
  8011de:	e8 cb fc ff ff       	call   800eae <dev_lookup>
  8011e3:	83 c4 10             	add    $0x10,%esp
  8011e6:	85 c0                	test   %eax,%eax
  8011e8:	78 22                	js     80120c <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011f1:	74 1e                	je     801211 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f6:	8b 52 0c             	mov    0xc(%edx),%edx
  8011f9:	85 d2                	test   %edx,%edx
  8011fb:	74 35                	je     801232 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011fd:	83 ec 04             	sub    $0x4,%esp
  801200:	ff 75 10             	pushl  0x10(%ebp)
  801203:	ff 75 0c             	pushl  0xc(%ebp)
  801206:	50                   	push   %eax
  801207:	ff d2                	call   *%edx
  801209:	83 c4 10             	add    $0x10,%esp
}
  80120c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80120f:	c9                   	leave  
  801210:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801211:	a1 04 40 80 00       	mov    0x804004,%eax
  801216:	8b 40 48             	mov    0x48(%eax),%eax
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	53                   	push   %ebx
  80121d:	50                   	push   %eax
  80121e:	68 e9 22 80 00       	push   $0x8022e9
  801223:	e8 50 ef ff ff       	call   800178 <cprintf>
		return -E_INVAL;
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801230:	eb da                	jmp    80120c <write+0x59>
		return -E_NOT_SUPP;
  801232:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801237:	eb d3                	jmp    80120c <write+0x59>

00801239 <seek>:

int
seek(int fdnum, off_t offset)
{
  801239:	f3 0f 1e fb          	endbr32 
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801243:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801246:	50                   	push   %eax
  801247:	ff 75 08             	pushl  0x8(%ebp)
  80124a:	e8 0b fc ff ff       	call   800e5a <fd_lookup>
  80124f:	83 c4 10             	add    $0x10,%esp
  801252:	85 c0                	test   %eax,%eax
  801254:	78 0e                	js     801264 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801256:	8b 55 0c             	mov    0xc(%ebp),%edx
  801259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801266:	f3 0f 1e fb          	endbr32 
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	53                   	push   %ebx
  80126e:	83 ec 1c             	sub    $0x1c,%esp
  801271:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801274:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801277:	50                   	push   %eax
  801278:	53                   	push   %ebx
  801279:	e8 dc fb ff ff       	call   800e5a <fd_lookup>
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	78 37                	js     8012bc <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128b:	50                   	push   %eax
  80128c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128f:	ff 30                	pushl  (%eax)
  801291:	e8 18 fc ff ff       	call   800eae <dev_lookup>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	78 1f                	js     8012bc <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80129d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012a4:	74 1b                	je     8012c1 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a9:	8b 52 18             	mov    0x18(%edx),%edx
  8012ac:	85 d2                	test   %edx,%edx
  8012ae:	74 32                	je     8012e2 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	ff 75 0c             	pushl  0xc(%ebp)
  8012b6:	50                   	push   %eax
  8012b7:	ff d2                	call   *%edx
  8012b9:	83 c4 10             	add    $0x10,%esp
}
  8012bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012c1:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012c6:	8b 40 48             	mov    0x48(%eax),%eax
  8012c9:	83 ec 04             	sub    $0x4,%esp
  8012cc:	53                   	push   %ebx
  8012cd:	50                   	push   %eax
  8012ce:	68 ac 22 80 00       	push   $0x8022ac
  8012d3:	e8 a0 ee ff ff       	call   800178 <cprintf>
		return -E_INVAL;
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e0:	eb da                	jmp    8012bc <ftruncate+0x56>
		return -E_NOT_SUPP;
  8012e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012e7:	eb d3                	jmp    8012bc <ftruncate+0x56>

008012e9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012e9:	f3 0f 1e fb          	endbr32 
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	53                   	push   %ebx
  8012f1:	83 ec 1c             	sub    $0x1c,%esp
  8012f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012fa:	50                   	push   %eax
  8012fb:	ff 75 08             	pushl  0x8(%ebp)
  8012fe:	e8 57 fb ff ff       	call   800e5a <fd_lookup>
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	85 c0                	test   %eax,%eax
  801308:	78 4b                	js     801355 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801310:	50                   	push   %eax
  801311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801314:	ff 30                	pushl  (%eax)
  801316:	e8 93 fb ff ff       	call   800eae <dev_lookup>
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	85 c0                	test   %eax,%eax
  801320:	78 33                	js     801355 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801325:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801329:	74 2f                	je     80135a <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80132b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80132e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801335:	00 00 00 
	stat->st_isdir = 0;
  801338:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80133f:	00 00 00 
	stat->st_dev = dev;
  801342:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801348:	83 ec 08             	sub    $0x8,%esp
  80134b:	53                   	push   %ebx
  80134c:	ff 75 f0             	pushl  -0x10(%ebp)
  80134f:	ff 50 14             	call   *0x14(%eax)
  801352:	83 c4 10             	add    $0x10,%esp
}
  801355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801358:	c9                   	leave  
  801359:	c3                   	ret    
		return -E_NOT_SUPP;
  80135a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80135f:	eb f4                	jmp    801355 <fstat+0x6c>

00801361 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801361:	f3 0f 1e fb          	endbr32 
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	56                   	push   %esi
  801369:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80136a:	83 ec 08             	sub    $0x8,%esp
  80136d:	6a 00                	push   $0x0
  80136f:	ff 75 08             	pushl  0x8(%ebp)
  801372:	e8 fb 01 00 00       	call   801572 <open>
  801377:	89 c3                	mov    %eax,%ebx
  801379:	83 c4 10             	add    $0x10,%esp
  80137c:	85 c0                	test   %eax,%eax
  80137e:	78 1b                	js     80139b <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801380:	83 ec 08             	sub    $0x8,%esp
  801383:	ff 75 0c             	pushl  0xc(%ebp)
  801386:	50                   	push   %eax
  801387:	e8 5d ff ff ff       	call   8012e9 <fstat>
  80138c:	89 c6                	mov    %eax,%esi
	close(fd);
  80138e:	89 1c 24             	mov    %ebx,(%esp)
  801391:	e8 fd fb ff ff       	call   800f93 <close>
	return r;
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	89 f3                	mov    %esi,%ebx
}
  80139b:	89 d8                	mov    %ebx,%eax
  80139d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a0:	5b                   	pop    %ebx
  8013a1:	5e                   	pop    %esi
  8013a2:	5d                   	pop    %ebp
  8013a3:	c3                   	ret    

008013a4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	56                   	push   %esi
  8013a8:	53                   	push   %ebx
  8013a9:	89 c6                	mov    %eax,%esi
  8013ab:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013ad:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013b4:	74 27                	je     8013dd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013b6:	6a 07                	push   $0x7
  8013b8:	68 00 50 80 00       	push   $0x805000
  8013bd:	56                   	push   %esi
  8013be:	ff 35 00 40 80 00    	pushl  0x804000
  8013c4:	e8 20 08 00 00       	call   801be9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013c9:	83 c4 0c             	add    $0xc,%esp
  8013cc:	6a 00                	push   $0x0
  8013ce:	53                   	push   %ebx
  8013cf:	6a 00                	push   $0x0
  8013d1:	e8 8e 07 00 00       	call   801b64 <ipc_recv>
}
  8013d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d9:	5b                   	pop    %ebx
  8013da:	5e                   	pop    %esi
  8013db:	5d                   	pop    %ebp
  8013dc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013dd:	83 ec 0c             	sub    $0xc,%esp
  8013e0:	6a 01                	push   $0x1
  8013e2:	e8 5a 08 00 00       	call   801c41 <ipc_find_env>
  8013e7:	a3 00 40 80 00       	mov    %eax,0x804000
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	eb c5                	jmp    8013b6 <fsipc+0x12>

008013f1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013f1:	f3 0f 1e fb          	endbr32 
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801401:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801406:	8b 45 0c             	mov    0xc(%ebp),%eax
  801409:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80140e:	ba 00 00 00 00       	mov    $0x0,%edx
  801413:	b8 02 00 00 00       	mov    $0x2,%eax
  801418:	e8 87 ff ff ff       	call   8013a4 <fsipc>
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <devfile_flush>:
{
  80141f:	f3 0f 1e fb          	endbr32 
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8b 40 0c             	mov    0xc(%eax),%eax
  80142f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801434:	ba 00 00 00 00       	mov    $0x0,%edx
  801439:	b8 06 00 00 00       	mov    $0x6,%eax
  80143e:	e8 61 ff ff ff       	call   8013a4 <fsipc>
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <devfile_stat>:
{
  801445:	f3 0f 1e fb          	endbr32 
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	53                   	push   %ebx
  80144d:	83 ec 04             	sub    $0x4,%esp
  801450:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8b 40 0c             	mov    0xc(%eax),%eax
  801459:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80145e:	ba 00 00 00 00       	mov    $0x0,%edx
  801463:	b8 05 00 00 00       	mov    $0x5,%eax
  801468:	e8 37 ff ff ff       	call   8013a4 <fsipc>
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 2c                	js     80149d <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801471:	83 ec 08             	sub    $0x8,%esp
  801474:	68 00 50 80 00       	push   $0x805000
  801479:	53                   	push   %ebx
  80147a:	e8 03 f3 ff ff       	call   800782 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80147f:	a1 80 50 80 00       	mov    0x805080,%eax
  801484:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80148a:	a1 84 50 80 00       	mov    0x805084,%eax
  80148f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <devfile_write>:
{
  8014a2:	f3 0f 1e fb          	endbr32 
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014af:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b2:	8b 52 0c             	mov    0xc(%edx),%edx
  8014b5:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8014bb:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014c0:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8014c5:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8014c8:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014cd:	50                   	push   %eax
  8014ce:	ff 75 0c             	pushl  0xc(%ebp)
  8014d1:	68 08 50 80 00       	push   $0x805008
  8014d6:	e8 5d f4 ff ff       	call   800938 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8014db:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e0:	b8 04 00 00 00       	mov    $0x4,%eax
  8014e5:	e8 ba fe ff ff       	call   8013a4 <fsipc>
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <devfile_read>:
{
  8014ec:	f3 0f 1e fb          	endbr32 
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	56                   	push   %esi
  8014f4:	53                   	push   %ebx
  8014f5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8014fe:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801503:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801509:	ba 00 00 00 00       	mov    $0x0,%edx
  80150e:	b8 03 00 00 00       	mov    $0x3,%eax
  801513:	e8 8c fe ff ff       	call   8013a4 <fsipc>
  801518:	89 c3                	mov    %eax,%ebx
  80151a:	85 c0                	test   %eax,%eax
  80151c:	78 1f                	js     80153d <devfile_read+0x51>
	assert(r <= n);
  80151e:	39 f0                	cmp    %esi,%eax
  801520:	77 24                	ja     801546 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801522:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801527:	7f 33                	jg     80155c <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801529:	83 ec 04             	sub    $0x4,%esp
  80152c:	50                   	push   %eax
  80152d:	68 00 50 80 00       	push   $0x805000
  801532:	ff 75 0c             	pushl  0xc(%ebp)
  801535:	e8 fe f3 ff ff       	call   800938 <memmove>
	return r;
  80153a:	83 c4 10             	add    $0x10,%esp
}
  80153d:	89 d8                	mov    %ebx,%eax
  80153f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801542:	5b                   	pop    %ebx
  801543:	5e                   	pop    %esi
  801544:	5d                   	pop    %ebp
  801545:	c3                   	ret    
	assert(r <= n);
  801546:	68 18 23 80 00       	push   $0x802318
  80154b:	68 1f 23 80 00       	push   $0x80231f
  801550:	6a 7c                	push   $0x7c
  801552:	68 34 23 80 00       	push   $0x802334
  801557:	e8 be 05 00 00       	call   801b1a <_panic>
	assert(r <= PGSIZE);
  80155c:	68 3f 23 80 00       	push   $0x80233f
  801561:	68 1f 23 80 00       	push   $0x80231f
  801566:	6a 7d                	push   $0x7d
  801568:	68 34 23 80 00       	push   $0x802334
  80156d:	e8 a8 05 00 00       	call   801b1a <_panic>

00801572 <open>:
{
  801572:	f3 0f 1e fb          	endbr32 
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	56                   	push   %esi
  80157a:	53                   	push   %ebx
  80157b:	83 ec 1c             	sub    $0x1c,%esp
  80157e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801581:	56                   	push   %esi
  801582:	e8 b8 f1 ff ff       	call   80073f <strlen>
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80158f:	7f 6c                	jg     8015fd <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801591:	83 ec 0c             	sub    $0xc,%esp
  801594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801597:	50                   	push   %eax
  801598:	e8 67 f8 ff ff       	call   800e04 <fd_alloc>
  80159d:	89 c3                	mov    %eax,%ebx
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	78 3c                	js     8015e2 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	56                   	push   %esi
  8015aa:	68 00 50 80 00       	push   $0x805000
  8015af:	e8 ce f1 ff ff       	call   800782 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8015c4:	e8 db fd ff ff       	call   8013a4 <fsipc>
  8015c9:	89 c3                	mov    %eax,%ebx
  8015cb:	83 c4 10             	add    $0x10,%esp
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	78 19                	js     8015eb <open+0x79>
	return fd2num(fd);
  8015d2:	83 ec 0c             	sub    $0xc,%esp
  8015d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d8:	e8 f8 f7 ff ff       	call   800dd5 <fd2num>
  8015dd:	89 c3                	mov    %eax,%ebx
  8015df:	83 c4 10             	add    $0x10,%esp
}
  8015e2:	89 d8                	mov    %ebx,%eax
  8015e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e7:	5b                   	pop    %ebx
  8015e8:	5e                   	pop    %esi
  8015e9:	5d                   	pop    %ebp
  8015ea:	c3                   	ret    
		fd_close(fd, 0);
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	6a 00                	push   $0x0
  8015f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f3:	e8 10 f9 ff ff       	call   800f08 <fd_close>
		return r;
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb e5                	jmp    8015e2 <open+0x70>
		return -E_BAD_PATH;
  8015fd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801602:	eb de                	jmp    8015e2 <open+0x70>

00801604 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801604:	f3 0f 1e fb          	endbr32 
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80160e:	ba 00 00 00 00       	mov    $0x0,%edx
  801613:	b8 08 00 00 00       	mov    $0x8,%eax
  801618:	e8 87 fd ff ff       	call   8013a4 <fsipc>
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80161f:	f3 0f 1e fb          	endbr32 
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	56                   	push   %esi
  801627:	53                   	push   %ebx
  801628:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80162b:	83 ec 0c             	sub    $0xc,%esp
  80162e:	ff 75 08             	pushl  0x8(%ebp)
  801631:	e8 b3 f7 ff ff       	call   800de9 <fd2data>
  801636:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801638:	83 c4 08             	add    $0x8,%esp
  80163b:	68 4b 23 80 00       	push   $0x80234b
  801640:	53                   	push   %ebx
  801641:	e8 3c f1 ff ff       	call   800782 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801646:	8b 46 04             	mov    0x4(%esi),%eax
  801649:	2b 06                	sub    (%esi),%eax
  80164b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801651:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801658:	00 00 00 
	stat->st_dev = &devpipe;
  80165b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801662:	30 80 00 
	return 0;
}
  801665:	b8 00 00 00 00       	mov    $0x0,%eax
  80166a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166d:	5b                   	pop    %ebx
  80166e:	5e                   	pop    %esi
  80166f:	5d                   	pop    %ebp
  801670:	c3                   	ret    

00801671 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801671:	f3 0f 1e fb          	endbr32 
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	53                   	push   %ebx
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80167f:	53                   	push   %ebx
  801680:	6a 00                	push   $0x0
  801682:	e8 ca f5 ff ff       	call   800c51 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801687:	89 1c 24             	mov    %ebx,(%esp)
  80168a:	e8 5a f7 ff ff       	call   800de9 <fd2data>
  80168f:	83 c4 08             	add    $0x8,%esp
  801692:	50                   	push   %eax
  801693:	6a 00                	push   $0x0
  801695:	e8 b7 f5 ff ff       	call   800c51 <sys_page_unmap>
}
  80169a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <_pipeisclosed>:
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	57                   	push   %edi
  8016a3:	56                   	push   %esi
  8016a4:	53                   	push   %ebx
  8016a5:	83 ec 1c             	sub    $0x1c,%esp
  8016a8:	89 c7                	mov    %eax,%edi
  8016aa:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016ac:	a1 04 40 80 00       	mov    0x804004,%eax
  8016b1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016b4:	83 ec 0c             	sub    $0xc,%esp
  8016b7:	57                   	push   %edi
  8016b8:	e8 c1 05 00 00       	call   801c7e <pageref>
  8016bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016c0:	89 34 24             	mov    %esi,(%esp)
  8016c3:	e8 b6 05 00 00       	call   801c7e <pageref>
		nn = thisenv->env_runs;
  8016c8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8016ce:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016d1:	83 c4 10             	add    $0x10,%esp
  8016d4:	39 cb                	cmp    %ecx,%ebx
  8016d6:	74 1b                	je     8016f3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016d8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016db:	75 cf                	jne    8016ac <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016dd:	8b 42 58             	mov    0x58(%edx),%eax
  8016e0:	6a 01                	push   $0x1
  8016e2:	50                   	push   %eax
  8016e3:	53                   	push   %ebx
  8016e4:	68 52 23 80 00       	push   $0x802352
  8016e9:	e8 8a ea ff ff       	call   800178 <cprintf>
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	eb b9                	jmp    8016ac <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016f3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016f6:	0f 94 c0             	sete   %al
  8016f9:	0f b6 c0             	movzbl %al,%eax
}
  8016fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ff:	5b                   	pop    %ebx
  801700:	5e                   	pop    %esi
  801701:	5f                   	pop    %edi
  801702:	5d                   	pop    %ebp
  801703:	c3                   	ret    

00801704 <devpipe_write>:
{
  801704:	f3 0f 1e fb          	endbr32 
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	57                   	push   %edi
  80170c:	56                   	push   %esi
  80170d:	53                   	push   %ebx
  80170e:	83 ec 28             	sub    $0x28,%esp
  801711:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801714:	56                   	push   %esi
  801715:	e8 cf f6 ff ff       	call   800de9 <fd2data>
  80171a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	bf 00 00 00 00       	mov    $0x0,%edi
  801724:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801727:	74 4f                	je     801778 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801729:	8b 43 04             	mov    0x4(%ebx),%eax
  80172c:	8b 0b                	mov    (%ebx),%ecx
  80172e:	8d 51 20             	lea    0x20(%ecx),%edx
  801731:	39 d0                	cmp    %edx,%eax
  801733:	72 14                	jb     801749 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801735:	89 da                	mov    %ebx,%edx
  801737:	89 f0                	mov    %esi,%eax
  801739:	e8 61 ff ff ff       	call   80169f <_pipeisclosed>
  80173e:	85 c0                	test   %eax,%eax
  801740:	75 3b                	jne    80177d <devpipe_write+0x79>
			sys_yield();
  801742:	e8 5a f4 ff ff       	call   800ba1 <sys_yield>
  801747:	eb e0                	jmp    801729 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801749:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801750:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801753:	89 c2                	mov    %eax,%edx
  801755:	c1 fa 1f             	sar    $0x1f,%edx
  801758:	89 d1                	mov    %edx,%ecx
  80175a:	c1 e9 1b             	shr    $0x1b,%ecx
  80175d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801760:	83 e2 1f             	and    $0x1f,%edx
  801763:	29 ca                	sub    %ecx,%edx
  801765:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801769:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80176d:	83 c0 01             	add    $0x1,%eax
  801770:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801773:	83 c7 01             	add    $0x1,%edi
  801776:	eb ac                	jmp    801724 <devpipe_write+0x20>
	return i;
  801778:	8b 45 10             	mov    0x10(%ebp),%eax
  80177b:	eb 05                	jmp    801782 <devpipe_write+0x7e>
				return 0;
  80177d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801782:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801785:	5b                   	pop    %ebx
  801786:	5e                   	pop    %esi
  801787:	5f                   	pop    %edi
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    

0080178a <devpipe_read>:
{
  80178a:	f3 0f 1e fb          	endbr32 
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	57                   	push   %edi
  801792:	56                   	push   %esi
  801793:	53                   	push   %ebx
  801794:	83 ec 18             	sub    $0x18,%esp
  801797:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80179a:	57                   	push   %edi
  80179b:	e8 49 f6 ff ff       	call   800de9 <fd2data>
  8017a0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	be 00 00 00 00       	mov    $0x0,%esi
  8017aa:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017ad:	75 14                	jne    8017c3 <devpipe_read+0x39>
	return i;
  8017af:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b2:	eb 02                	jmp    8017b6 <devpipe_read+0x2c>
				return i;
  8017b4:	89 f0                	mov    %esi,%eax
}
  8017b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5e                   	pop    %esi
  8017bb:	5f                   	pop    %edi
  8017bc:	5d                   	pop    %ebp
  8017bd:	c3                   	ret    
			sys_yield();
  8017be:	e8 de f3 ff ff       	call   800ba1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8017c3:	8b 03                	mov    (%ebx),%eax
  8017c5:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017c8:	75 18                	jne    8017e2 <devpipe_read+0x58>
			if (i > 0)
  8017ca:	85 f6                	test   %esi,%esi
  8017cc:	75 e6                	jne    8017b4 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8017ce:	89 da                	mov    %ebx,%edx
  8017d0:	89 f8                	mov    %edi,%eax
  8017d2:	e8 c8 fe ff ff       	call   80169f <_pipeisclosed>
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	74 e3                	je     8017be <devpipe_read+0x34>
				return 0;
  8017db:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e0:	eb d4                	jmp    8017b6 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017e2:	99                   	cltd   
  8017e3:	c1 ea 1b             	shr    $0x1b,%edx
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	83 e0 1f             	and    $0x1f,%eax
  8017eb:	29 d0                	sub    %edx,%eax
  8017ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017f8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017fb:	83 c6 01             	add    $0x1,%esi
  8017fe:	eb aa                	jmp    8017aa <devpipe_read+0x20>

00801800 <pipe>:
{
  801800:	f3 0f 1e fb          	endbr32 
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	56                   	push   %esi
  801808:	53                   	push   %ebx
  801809:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80180c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180f:	50                   	push   %eax
  801810:	e8 ef f5 ff ff       	call   800e04 <fd_alloc>
  801815:	89 c3                	mov    %eax,%ebx
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	85 c0                	test   %eax,%eax
  80181c:	0f 88 23 01 00 00    	js     801945 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 07 04 00 00       	push   $0x407
  80182a:	ff 75 f4             	pushl  -0xc(%ebp)
  80182d:	6a 00                	push   $0x0
  80182f:	e8 90 f3 ff ff       	call   800bc4 <sys_page_alloc>
  801834:	89 c3                	mov    %eax,%ebx
  801836:	83 c4 10             	add    $0x10,%esp
  801839:	85 c0                	test   %eax,%eax
  80183b:	0f 88 04 01 00 00    	js     801945 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801841:	83 ec 0c             	sub    $0xc,%esp
  801844:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801847:	50                   	push   %eax
  801848:	e8 b7 f5 ff ff       	call   800e04 <fd_alloc>
  80184d:	89 c3                	mov    %eax,%ebx
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	85 c0                	test   %eax,%eax
  801854:	0f 88 db 00 00 00    	js     801935 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80185a:	83 ec 04             	sub    $0x4,%esp
  80185d:	68 07 04 00 00       	push   $0x407
  801862:	ff 75 f0             	pushl  -0x10(%ebp)
  801865:	6a 00                	push   $0x0
  801867:	e8 58 f3 ff ff       	call   800bc4 <sys_page_alloc>
  80186c:	89 c3                	mov    %eax,%ebx
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	85 c0                	test   %eax,%eax
  801873:	0f 88 bc 00 00 00    	js     801935 <pipe+0x135>
	va = fd2data(fd0);
  801879:	83 ec 0c             	sub    $0xc,%esp
  80187c:	ff 75 f4             	pushl  -0xc(%ebp)
  80187f:	e8 65 f5 ff ff       	call   800de9 <fd2data>
  801884:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801886:	83 c4 0c             	add    $0xc,%esp
  801889:	68 07 04 00 00       	push   $0x407
  80188e:	50                   	push   %eax
  80188f:	6a 00                	push   $0x0
  801891:	e8 2e f3 ff ff       	call   800bc4 <sys_page_alloc>
  801896:	89 c3                	mov    %eax,%ebx
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	85 c0                	test   %eax,%eax
  80189d:	0f 88 82 00 00 00    	js     801925 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018a3:	83 ec 0c             	sub    $0xc,%esp
  8018a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a9:	e8 3b f5 ff ff       	call   800de9 <fd2data>
  8018ae:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018b5:	50                   	push   %eax
  8018b6:	6a 00                	push   $0x0
  8018b8:	56                   	push   %esi
  8018b9:	6a 00                	push   $0x0
  8018bb:	e8 4b f3 ff ff       	call   800c0b <sys_page_map>
  8018c0:	89 c3                	mov    %eax,%ebx
  8018c2:	83 c4 20             	add    $0x20,%esp
  8018c5:	85 c0                	test   %eax,%eax
  8018c7:	78 4e                	js     801917 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8018c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8018ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8018d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8018dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018e0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8018e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018ec:	83 ec 0c             	sub    $0xc,%esp
  8018ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f2:	e8 de f4 ff ff       	call   800dd5 <fd2num>
  8018f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fa:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018fc:	83 c4 04             	add    $0x4,%esp
  8018ff:	ff 75 f0             	pushl  -0x10(%ebp)
  801902:	e8 ce f4 ff ff       	call   800dd5 <fd2num>
  801907:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	bb 00 00 00 00       	mov    $0x0,%ebx
  801915:	eb 2e                	jmp    801945 <pipe+0x145>
	sys_page_unmap(0, va);
  801917:	83 ec 08             	sub    $0x8,%esp
  80191a:	56                   	push   %esi
  80191b:	6a 00                	push   $0x0
  80191d:	e8 2f f3 ff ff       	call   800c51 <sys_page_unmap>
  801922:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801925:	83 ec 08             	sub    $0x8,%esp
  801928:	ff 75 f0             	pushl  -0x10(%ebp)
  80192b:	6a 00                	push   $0x0
  80192d:	e8 1f f3 ff ff       	call   800c51 <sys_page_unmap>
  801932:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	ff 75 f4             	pushl  -0xc(%ebp)
  80193b:	6a 00                	push   $0x0
  80193d:	e8 0f f3 ff ff       	call   800c51 <sys_page_unmap>
  801942:	83 c4 10             	add    $0x10,%esp
}
  801945:	89 d8                	mov    %ebx,%eax
  801947:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194a:	5b                   	pop    %ebx
  80194b:	5e                   	pop    %esi
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    

0080194e <pipeisclosed>:
{
  80194e:	f3 0f 1e fb          	endbr32 
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801958:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195b:	50                   	push   %eax
  80195c:	ff 75 08             	pushl  0x8(%ebp)
  80195f:	e8 f6 f4 ff ff       	call   800e5a <fd_lookup>
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	85 c0                	test   %eax,%eax
  801969:	78 18                	js     801983 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80196b:	83 ec 0c             	sub    $0xc,%esp
  80196e:	ff 75 f4             	pushl  -0xc(%ebp)
  801971:	e8 73 f4 ff ff       	call   800de9 <fd2data>
  801976:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197b:	e8 1f fd ff ff       	call   80169f <_pipeisclosed>
  801980:	83 c4 10             	add    $0x10,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801985:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801989:	b8 00 00 00 00       	mov    $0x0,%eax
  80198e:	c3                   	ret    

0080198f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80198f:	f3 0f 1e fb          	endbr32 
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801999:	68 6a 23 80 00       	push   $0x80236a
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	e8 dc ed ff ff       	call   800782 <strcpy>
	return 0;
}
  8019a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <devcons_write>:
{
  8019ad:	f3 0f 1e fb          	endbr32 
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	57                   	push   %edi
  8019b5:	56                   	push   %esi
  8019b6:	53                   	push   %ebx
  8019b7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8019bd:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8019c2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8019c8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019cb:	73 31                	jae    8019fe <devcons_write+0x51>
		m = n - tot;
  8019cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019d0:	29 f3                	sub    %esi,%ebx
  8019d2:	83 fb 7f             	cmp    $0x7f,%ebx
  8019d5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8019da:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8019dd:	83 ec 04             	sub    $0x4,%esp
  8019e0:	53                   	push   %ebx
  8019e1:	89 f0                	mov    %esi,%eax
  8019e3:	03 45 0c             	add    0xc(%ebp),%eax
  8019e6:	50                   	push   %eax
  8019e7:	57                   	push   %edi
  8019e8:	e8 4b ef ff ff       	call   800938 <memmove>
		sys_cputs(buf, m);
  8019ed:	83 c4 08             	add    $0x8,%esp
  8019f0:	53                   	push   %ebx
  8019f1:	57                   	push   %edi
  8019f2:	e8 fd f0 ff ff       	call   800af4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8019f7:	01 de                	add    %ebx,%esi
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	eb ca                	jmp    8019c8 <devcons_write+0x1b>
}
  8019fe:	89 f0                	mov    %esi,%eax
  801a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5f                   	pop    %edi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    

00801a08 <devcons_read>:
{
  801a08:	f3 0f 1e fb          	endbr32 
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801a17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a1b:	74 21                	je     801a3e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801a1d:	e8 f4 f0 ff ff       	call   800b16 <sys_cgetc>
  801a22:	85 c0                	test   %eax,%eax
  801a24:	75 07                	jne    801a2d <devcons_read+0x25>
		sys_yield();
  801a26:	e8 76 f1 ff ff       	call   800ba1 <sys_yield>
  801a2b:	eb f0                	jmp    801a1d <devcons_read+0x15>
	if (c < 0)
  801a2d:	78 0f                	js     801a3e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801a2f:	83 f8 04             	cmp    $0x4,%eax
  801a32:	74 0c                	je     801a40 <devcons_read+0x38>
	*(char*)vbuf = c;
  801a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a37:	88 02                	mov    %al,(%edx)
	return 1;
  801a39:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    
		return 0;
  801a40:	b8 00 00 00 00       	mov    $0x0,%eax
  801a45:	eb f7                	jmp    801a3e <devcons_read+0x36>

00801a47 <cputchar>:
{
  801a47:	f3 0f 1e fb          	endbr32 
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a57:	6a 01                	push   $0x1
  801a59:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a5c:	50                   	push   %eax
  801a5d:	e8 92 f0 ff ff       	call   800af4 <sys_cputs>
}
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <getchar>:
{
  801a67:	f3 0f 1e fb          	endbr32 
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a71:	6a 01                	push   $0x1
  801a73:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a76:	50                   	push   %eax
  801a77:	6a 00                	push   $0x0
  801a79:	e8 5f f6 ff ff       	call   8010dd <read>
	if (r < 0)
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	85 c0                	test   %eax,%eax
  801a83:	78 06                	js     801a8b <getchar+0x24>
	if (r < 1)
  801a85:	74 06                	je     801a8d <getchar+0x26>
	return c;
  801a87:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    
		return -E_EOF;
  801a8d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a92:	eb f7                	jmp    801a8b <getchar+0x24>

00801a94 <iscons>:
{
  801a94:	f3 0f 1e fb          	endbr32 
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa1:	50                   	push   %eax
  801aa2:	ff 75 08             	pushl  0x8(%ebp)
  801aa5:	e8 b0 f3 ff ff       	call   800e5a <fd_lookup>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 11                	js     801ac2 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801aba:	39 10                	cmp    %edx,(%eax)
  801abc:	0f 94 c0             	sete   %al
  801abf:	0f b6 c0             	movzbl %al,%eax
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <opencons>:
{
  801ac4:	f3 0f 1e fb          	endbr32 
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801ace:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad1:	50                   	push   %eax
  801ad2:	e8 2d f3 ff ff       	call   800e04 <fd_alloc>
  801ad7:	83 c4 10             	add    $0x10,%esp
  801ada:	85 c0                	test   %eax,%eax
  801adc:	78 3a                	js     801b18 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	68 07 04 00 00       	push   $0x407
  801ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae9:	6a 00                	push   $0x0
  801aeb:	e8 d4 f0 ff ff       	call   800bc4 <sys_page_alloc>
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	85 c0                	test   %eax,%eax
  801af5:	78 21                	js     801b18 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afa:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b00:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b0c:	83 ec 0c             	sub    $0xc,%esp
  801b0f:	50                   	push   %eax
  801b10:	e8 c0 f2 ff ff       	call   800dd5 <fd2num>
  801b15:	83 c4 10             	add    $0x10,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b1a:	f3 0f 1e fb          	endbr32 
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	56                   	push   %esi
  801b22:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b23:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b26:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801b2c:	e8 4d f0 ff ff       	call   800b7e <sys_getenvid>
  801b31:	83 ec 0c             	sub    $0xc,%esp
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	56                   	push   %esi
  801b3b:	50                   	push   %eax
  801b3c:	68 78 23 80 00       	push   $0x802378
  801b41:	e8 32 e6 ff ff       	call   800178 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b46:	83 c4 18             	add    $0x18,%esp
  801b49:	53                   	push   %ebx
  801b4a:	ff 75 10             	pushl  0x10(%ebp)
  801b4d:	e8 d1 e5 ff ff       	call   800123 <vcprintf>
	cprintf("\n");
  801b52:	c7 04 24 b4 23 80 00 	movl   $0x8023b4,(%esp)
  801b59:	e8 1a e6 ff ff       	call   800178 <cprintf>
  801b5e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b61:	cc                   	int3   
  801b62:	eb fd                	jmp    801b61 <_panic+0x47>

00801b64 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b64:	f3 0f 1e fb          	endbr32 
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	56                   	push   %esi
  801b6c:	53                   	push   %ebx
  801b6d:	8b 75 08             	mov    0x8(%ebp),%esi
  801b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b76:	85 c0                	test   %eax,%eax
  801b78:	74 3d                	je     801bb7 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b7a:	83 ec 0c             	sub    $0xc,%esp
  801b7d:	50                   	push   %eax
  801b7e:	e8 0d f2 ff ff       	call   800d90 <sys_ipc_recv>
  801b83:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b86:	85 f6                	test   %esi,%esi
  801b88:	74 0b                	je     801b95 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b8a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b90:	8b 52 74             	mov    0x74(%edx),%edx
  801b93:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b95:	85 db                	test   %ebx,%ebx
  801b97:	74 0b                	je     801ba4 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b99:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b9f:	8b 52 78             	mov    0x78(%edx),%edx
  801ba2:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	78 21                	js     801bc9 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801ba8:	a1 04 40 80 00       	mov    0x804004,%eax
  801bad:	8b 40 70             	mov    0x70(%eax),%eax
}
  801bb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5e                   	pop    %esi
  801bb5:	5d                   	pop    %ebp
  801bb6:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801bb7:	83 ec 0c             	sub    $0xc,%esp
  801bba:	68 00 00 c0 ee       	push   $0xeec00000
  801bbf:	e8 cc f1 ff ff       	call   800d90 <sys_ipc_recv>
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	eb bd                	jmp    801b86 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801bc9:	85 f6                	test   %esi,%esi
  801bcb:	74 10                	je     801bdd <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801bcd:	85 db                	test   %ebx,%ebx
  801bcf:	75 df                	jne    801bb0 <ipc_recv+0x4c>
  801bd1:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bd8:	00 00 00 
  801bdb:	eb d3                	jmp    801bb0 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801bdd:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801be4:	00 00 00 
  801be7:	eb e4                	jmp    801bcd <ipc_recv+0x69>

00801be9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801be9:	f3 0f 1e fb          	endbr32 
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	57                   	push   %edi
  801bf1:	56                   	push   %esi
  801bf2:	53                   	push   %ebx
  801bf3:	83 ec 0c             	sub    $0xc,%esp
  801bf6:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bf9:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bff:	85 db                	test   %ebx,%ebx
  801c01:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c06:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801c09:	ff 75 14             	pushl  0x14(%ebp)
  801c0c:	53                   	push   %ebx
  801c0d:	56                   	push   %esi
  801c0e:	57                   	push   %edi
  801c0f:	e8 55 f1 ff ff       	call   800d69 <sys_ipc_try_send>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	85 c0                	test   %eax,%eax
  801c19:	79 1e                	jns    801c39 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801c1b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c1e:	75 07                	jne    801c27 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801c20:	e8 7c ef ff ff       	call   800ba1 <sys_yield>
  801c25:	eb e2                	jmp    801c09 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801c27:	50                   	push   %eax
  801c28:	68 9b 23 80 00       	push   $0x80239b
  801c2d:	6a 59                	push   $0x59
  801c2f:	68 b6 23 80 00       	push   $0x8023b6
  801c34:	e8 e1 fe ff ff       	call   801b1a <_panic>
	}
}
  801c39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3c:	5b                   	pop    %ebx
  801c3d:	5e                   	pop    %esi
  801c3e:	5f                   	pop    %edi
  801c3f:	5d                   	pop    %ebp
  801c40:	c3                   	ret    

00801c41 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c41:	f3 0f 1e fb          	endbr32 
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c50:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c53:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c59:	8b 52 50             	mov    0x50(%edx),%edx
  801c5c:	39 ca                	cmp    %ecx,%edx
  801c5e:	74 11                	je     801c71 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c60:	83 c0 01             	add    $0x1,%eax
  801c63:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c68:	75 e6                	jne    801c50 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6f:	eb 0b                	jmp    801c7c <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c71:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c74:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c79:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c7c:	5d                   	pop    %ebp
  801c7d:	c3                   	ret    

00801c7e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c7e:	f3 0f 1e fb          	endbr32 
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c88:	89 c2                	mov    %eax,%edx
  801c8a:	c1 ea 16             	shr    $0x16,%edx
  801c8d:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c94:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c99:	f6 c1 01             	test   $0x1,%cl
  801c9c:	74 1c                	je     801cba <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c9e:	c1 e8 0c             	shr    $0xc,%eax
  801ca1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801ca8:	a8 01                	test   $0x1,%al
  801caa:	74 0e                	je     801cba <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801cac:	c1 e8 0c             	shr    $0xc,%eax
  801caf:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801cb6:	ef 
  801cb7:	0f b7 d2             	movzwl %dx,%edx
}
  801cba:	89 d0                	mov    %edx,%eax
  801cbc:	5d                   	pop    %ebp
  801cbd:	c3                   	ret    
  801cbe:	66 90                	xchg   %ax,%ax

00801cc0 <__udivdi3>:
  801cc0:	f3 0f 1e fb          	endbr32 
  801cc4:	55                   	push   %ebp
  801cc5:	57                   	push   %edi
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 1c             	sub    $0x1c,%esp
  801ccb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801ccf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801cd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cd7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801cdb:	85 d2                	test   %edx,%edx
  801cdd:	75 19                	jne    801cf8 <__udivdi3+0x38>
  801cdf:	39 f3                	cmp    %esi,%ebx
  801ce1:	76 4d                	jbe    801d30 <__udivdi3+0x70>
  801ce3:	31 ff                	xor    %edi,%edi
  801ce5:	89 e8                	mov    %ebp,%eax
  801ce7:	89 f2                	mov    %esi,%edx
  801ce9:	f7 f3                	div    %ebx
  801ceb:	89 fa                	mov    %edi,%edx
  801ced:	83 c4 1c             	add    $0x1c,%esp
  801cf0:	5b                   	pop    %ebx
  801cf1:	5e                   	pop    %esi
  801cf2:	5f                   	pop    %edi
  801cf3:	5d                   	pop    %ebp
  801cf4:	c3                   	ret    
  801cf5:	8d 76 00             	lea    0x0(%esi),%esi
  801cf8:	39 f2                	cmp    %esi,%edx
  801cfa:	76 14                	jbe    801d10 <__udivdi3+0x50>
  801cfc:	31 ff                	xor    %edi,%edi
  801cfe:	31 c0                	xor    %eax,%eax
  801d00:	89 fa                	mov    %edi,%edx
  801d02:	83 c4 1c             	add    $0x1c,%esp
  801d05:	5b                   	pop    %ebx
  801d06:	5e                   	pop    %esi
  801d07:	5f                   	pop    %edi
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    
  801d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d10:	0f bd fa             	bsr    %edx,%edi
  801d13:	83 f7 1f             	xor    $0x1f,%edi
  801d16:	75 48                	jne    801d60 <__udivdi3+0xa0>
  801d18:	39 f2                	cmp    %esi,%edx
  801d1a:	72 06                	jb     801d22 <__udivdi3+0x62>
  801d1c:	31 c0                	xor    %eax,%eax
  801d1e:	39 eb                	cmp    %ebp,%ebx
  801d20:	77 de                	ja     801d00 <__udivdi3+0x40>
  801d22:	b8 01 00 00 00       	mov    $0x1,%eax
  801d27:	eb d7                	jmp    801d00 <__udivdi3+0x40>
  801d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d30:	89 d9                	mov    %ebx,%ecx
  801d32:	85 db                	test   %ebx,%ebx
  801d34:	75 0b                	jne    801d41 <__udivdi3+0x81>
  801d36:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3b:	31 d2                	xor    %edx,%edx
  801d3d:	f7 f3                	div    %ebx
  801d3f:	89 c1                	mov    %eax,%ecx
  801d41:	31 d2                	xor    %edx,%edx
  801d43:	89 f0                	mov    %esi,%eax
  801d45:	f7 f1                	div    %ecx
  801d47:	89 c6                	mov    %eax,%esi
  801d49:	89 e8                	mov    %ebp,%eax
  801d4b:	89 f7                	mov    %esi,%edi
  801d4d:	f7 f1                	div    %ecx
  801d4f:	89 fa                	mov    %edi,%edx
  801d51:	83 c4 1c             	add    $0x1c,%esp
  801d54:	5b                   	pop    %ebx
  801d55:	5e                   	pop    %esi
  801d56:	5f                   	pop    %edi
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    
  801d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d60:	89 f9                	mov    %edi,%ecx
  801d62:	b8 20 00 00 00       	mov    $0x20,%eax
  801d67:	29 f8                	sub    %edi,%eax
  801d69:	d3 e2                	shl    %cl,%edx
  801d6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d6f:	89 c1                	mov    %eax,%ecx
  801d71:	89 da                	mov    %ebx,%edx
  801d73:	d3 ea                	shr    %cl,%edx
  801d75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d79:	09 d1                	or     %edx,%ecx
  801d7b:	89 f2                	mov    %esi,%edx
  801d7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d81:	89 f9                	mov    %edi,%ecx
  801d83:	d3 e3                	shl    %cl,%ebx
  801d85:	89 c1                	mov    %eax,%ecx
  801d87:	d3 ea                	shr    %cl,%edx
  801d89:	89 f9                	mov    %edi,%ecx
  801d8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d8f:	89 eb                	mov    %ebp,%ebx
  801d91:	d3 e6                	shl    %cl,%esi
  801d93:	89 c1                	mov    %eax,%ecx
  801d95:	d3 eb                	shr    %cl,%ebx
  801d97:	09 de                	or     %ebx,%esi
  801d99:	89 f0                	mov    %esi,%eax
  801d9b:	f7 74 24 08          	divl   0x8(%esp)
  801d9f:	89 d6                	mov    %edx,%esi
  801da1:	89 c3                	mov    %eax,%ebx
  801da3:	f7 64 24 0c          	mull   0xc(%esp)
  801da7:	39 d6                	cmp    %edx,%esi
  801da9:	72 15                	jb     801dc0 <__udivdi3+0x100>
  801dab:	89 f9                	mov    %edi,%ecx
  801dad:	d3 e5                	shl    %cl,%ebp
  801daf:	39 c5                	cmp    %eax,%ebp
  801db1:	73 04                	jae    801db7 <__udivdi3+0xf7>
  801db3:	39 d6                	cmp    %edx,%esi
  801db5:	74 09                	je     801dc0 <__udivdi3+0x100>
  801db7:	89 d8                	mov    %ebx,%eax
  801db9:	31 ff                	xor    %edi,%edi
  801dbb:	e9 40 ff ff ff       	jmp    801d00 <__udivdi3+0x40>
  801dc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dc3:	31 ff                	xor    %edi,%edi
  801dc5:	e9 36 ff ff ff       	jmp    801d00 <__udivdi3+0x40>
  801dca:	66 90                	xchg   %ax,%ax
  801dcc:	66 90                	xchg   %ax,%ax
  801dce:	66 90                	xchg   %ax,%ax

00801dd0 <__umoddi3>:
  801dd0:	f3 0f 1e fb          	endbr32 
  801dd4:	55                   	push   %ebp
  801dd5:	57                   	push   %edi
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 1c             	sub    $0x1c,%esp
  801ddb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ddf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801de3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801de7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801deb:	85 c0                	test   %eax,%eax
  801ded:	75 19                	jne    801e08 <__umoddi3+0x38>
  801def:	39 df                	cmp    %ebx,%edi
  801df1:	76 5d                	jbe    801e50 <__umoddi3+0x80>
  801df3:	89 f0                	mov    %esi,%eax
  801df5:	89 da                	mov    %ebx,%edx
  801df7:	f7 f7                	div    %edi
  801df9:	89 d0                	mov    %edx,%eax
  801dfb:	31 d2                	xor    %edx,%edx
  801dfd:	83 c4 1c             	add    $0x1c,%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5f                   	pop    %edi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    
  801e05:	8d 76 00             	lea    0x0(%esi),%esi
  801e08:	89 f2                	mov    %esi,%edx
  801e0a:	39 d8                	cmp    %ebx,%eax
  801e0c:	76 12                	jbe    801e20 <__umoddi3+0x50>
  801e0e:	89 f0                	mov    %esi,%eax
  801e10:	89 da                	mov    %ebx,%edx
  801e12:	83 c4 1c             	add    $0x1c,%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5f                   	pop    %edi
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    
  801e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e20:	0f bd e8             	bsr    %eax,%ebp
  801e23:	83 f5 1f             	xor    $0x1f,%ebp
  801e26:	75 50                	jne    801e78 <__umoddi3+0xa8>
  801e28:	39 d8                	cmp    %ebx,%eax
  801e2a:	0f 82 e0 00 00 00    	jb     801f10 <__umoddi3+0x140>
  801e30:	89 d9                	mov    %ebx,%ecx
  801e32:	39 f7                	cmp    %esi,%edi
  801e34:	0f 86 d6 00 00 00    	jbe    801f10 <__umoddi3+0x140>
  801e3a:	89 d0                	mov    %edx,%eax
  801e3c:	89 ca                	mov    %ecx,%edx
  801e3e:	83 c4 1c             	add    $0x1c,%esp
  801e41:	5b                   	pop    %ebx
  801e42:	5e                   	pop    %esi
  801e43:	5f                   	pop    %edi
  801e44:	5d                   	pop    %ebp
  801e45:	c3                   	ret    
  801e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e4d:	8d 76 00             	lea    0x0(%esi),%esi
  801e50:	89 fd                	mov    %edi,%ebp
  801e52:	85 ff                	test   %edi,%edi
  801e54:	75 0b                	jne    801e61 <__umoddi3+0x91>
  801e56:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5b:	31 d2                	xor    %edx,%edx
  801e5d:	f7 f7                	div    %edi
  801e5f:	89 c5                	mov    %eax,%ebp
  801e61:	89 d8                	mov    %ebx,%eax
  801e63:	31 d2                	xor    %edx,%edx
  801e65:	f7 f5                	div    %ebp
  801e67:	89 f0                	mov    %esi,%eax
  801e69:	f7 f5                	div    %ebp
  801e6b:	89 d0                	mov    %edx,%eax
  801e6d:	31 d2                	xor    %edx,%edx
  801e6f:	eb 8c                	jmp    801dfd <__umoddi3+0x2d>
  801e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e78:	89 e9                	mov    %ebp,%ecx
  801e7a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e7f:	29 ea                	sub    %ebp,%edx
  801e81:	d3 e0                	shl    %cl,%eax
  801e83:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e87:	89 d1                	mov    %edx,%ecx
  801e89:	89 f8                	mov    %edi,%eax
  801e8b:	d3 e8                	shr    %cl,%eax
  801e8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e91:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e95:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e99:	09 c1                	or     %eax,%ecx
  801e9b:	89 d8                	mov    %ebx,%eax
  801e9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ea1:	89 e9                	mov    %ebp,%ecx
  801ea3:	d3 e7                	shl    %cl,%edi
  801ea5:	89 d1                	mov    %edx,%ecx
  801ea7:	d3 e8                	shr    %cl,%eax
  801ea9:	89 e9                	mov    %ebp,%ecx
  801eab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801eaf:	d3 e3                	shl    %cl,%ebx
  801eb1:	89 c7                	mov    %eax,%edi
  801eb3:	89 d1                	mov    %edx,%ecx
  801eb5:	89 f0                	mov    %esi,%eax
  801eb7:	d3 e8                	shr    %cl,%eax
  801eb9:	89 e9                	mov    %ebp,%ecx
  801ebb:	89 fa                	mov    %edi,%edx
  801ebd:	d3 e6                	shl    %cl,%esi
  801ebf:	09 d8                	or     %ebx,%eax
  801ec1:	f7 74 24 08          	divl   0x8(%esp)
  801ec5:	89 d1                	mov    %edx,%ecx
  801ec7:	89 f3                	mov    %esi,%ebx
  801ec9:	f7 64 24 0c          	mull   0xc(%esp)
  801ecd:	89 c6                	mov    %eax,%esi
  801ecf:	89 d7                	mov    %edx,%edi
  801ed1:	39 d1                	cmp    %edx,%ecx
  801ed3:	72 06                	jb     801edb <__umoddi3+0x10b>
  801ed5:	75 10                	jne    801ee7 <__umoddi3+0x117>
  801ed7:	39 c3                	cmp    %eax,%ebx
  801ed9:	73 0c                	jae    801ee7 <__umoddi3+0x117>
  801edb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801edf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801ee3:	89 d7                	mov    %edx,%edi
  801ee5:	89 c6                	mov    %eax,%esi
  801ee7:	89 ca                	mov    %ecx,%edx
  801ee9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801eee:	29 f3                	sub    %esi,%ebx
  801ef0:	19 fa                	sbb    %edi,%edx
  801ef2:	89 d0                	mov    %edx,%eax
  801ef4:	d3 e0                	shl    %cl,%eax
  801ef6:	89 e9                	mov    %ebp,%ecx
  801ef8:	d3 eb                	shr    %cl,%ebx
  801efa:	d3 ea                	shr    %cl,%edx
  801efc:	09 d8                	or     %ebx,%eax
  801efe:	83 c4 1c             	add    $0x1c,%esp
  801f01:	5b                   	pop    %ebx
  801f02:	5e                   	pop    %esi
  801f03:	5f                   	pop    %edi
  801f04:	5d                   	pop    %ebp
  801f05:	c3                   	ret    
  801f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f0d:	8d 76 00             	lea    0x0(%esi),%esi
  801f10:	29 fe                	sub    %edi,%esi
  801f12:	19 c3                	sbb    %eax,%ebx
  801f14:	89 f2                	mov    %esi,%edx
  801f16:	89 d9                	mov    %ebx,%ecx
  801f18:	e9 1d ff ff ff       	jmp    801e3a <__umoddi3+0x6a>
