
obj/user/yield:     file format elf32-i386


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
  80002c:	e8 6d 00 00 00       	call   80009e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003e:	a1 04 20 80 00       	mov    0x802004,%eax
  800043:	8b 40 48             	mov    0x48(%eax),%eax
  800046:	50                   	push   %eax
  800047:	68 60 10 80 00       	push   $0x801060
  80004c:	e8 4a 01 00 00       	call   80019b <cprintf>
  800051:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800054:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800059:	e8 66 0b 00 00       	call   800bc4 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005e:	a1 04 20 80 00       	mov    0x802004,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  800063:	8b 40 48             	mov    0x48(%eax),%eax
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	53                   	push   %ebx
  80006a:	50                   	push   %eax
  80006b:	68 80 10 80 00       	push   $0x801080
  800070:	e8 26 01 00 00       	call   80019b <cprintf>
	for (i = 0; i < 5; i++) {
  800075:	83 c3 01             	add    $0x1,%ebx
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	83 fb 05             	cmp    $0x5,%ebx
  80007e:	75 d9                	jne    800059 <umain+0x26>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800080:	a1 04 20 80 00       	mov    0x802004,%eax
  800085:	8b 40 48             	mov    0x48(%eax),%eax
  800088:	83 ec 08             	sub    $0x8,%esp
  80008b:	50                   	push   %eax
  80008c:	68 ac 10 80 00       	push   $0x8010ac
  800091:	e8 05 01 00 00       	call   80019b <cprintf>
}
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009e:	f3 0f 1e fb          	endbr32 
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	56                   	push   %esi
  8000a6:	53                   	push   %ebx
  8000a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000aa:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ad:	e8 ef 0a 00 00       	call   800ba1 <sys_getenvid>
  8000b2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000bf:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c4:	85 db                	test   %ebx,%ebx
  8000c6:	7e 07                	jle    8000cf <libmain+0x31>
		binaryname = argv[0];
  8000c8:	8b 06                	mov    (%esi),%eax
  8000ca:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	56                   	push   %esi
  8000d3:	53                   	push   %ebx
  8000d4:	e8 5a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d9:	e8 0a 00 00 00       	call   8000e8 <exit>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5d                   	pop    %ebp
  8000e7:	c3                   	ret    

008000e8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e8:	f3 0f 1e fb          	endbr32 
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000f2:	6a 00                	push   $0x0
  8000f4:	e8 63 0a 00 00       	call   800b5c <sys_env_destroy>
}
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	c9                   	leave  
  8000fd:	c3                   	ret    

008000fe <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fe:	f3 0f 1e fb          	endbr32 
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	53                   	push   %ebx
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010c:	8b 13                	mov    (%ebx),%edx
  80010e:	8d 42 01             	lea    0x1(%edx),%eax
  800111:	89 03                	mov    %eax,(%ebx)
  800113:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800116:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80011a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011f:	74 09                	je     80012a <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800121:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800125:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800128:	c9                   	leave  
  800129:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 ff 00 00 00       	push   $0xff
  800132:	8d 43 08             	lea    0x8(%ebx),%eax
  800135:	50                   	push   %eax
  800136:	e8 dc 09 00 00       	call   800b17 <sys_cputs>
		b->idx = 0;
  80013b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800141:	83 c4 10             	add    $0x10,%esp
  800144:	eb db                	jmp    800121 <putch+0x23>

00800146 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800146:	f3 0f 1e fb          	endbr32 
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800153:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80015a:	00 00 00 
	b.cnt = 0;
  80015d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800164:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800167:	ff 75 0c             	pushl  0xc(%ebp)
  80016a:	ff 75 08             	pushl  0x8(%ebp)
  80016d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800173:	50                   	push   %eax
  800174:	68 fe 00 80 00       	push   $0x8000fe
  800179:	e8 20 01 00 00       	call   80029e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80017e:	83 c4 08             	add    $0x8,%esp
  800181:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800187:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80018d:	50                   	push   %eax
  80018e:	e8 84 09 00 00       	call   800b17 <sys_cputs>

	return b.cnt;
}
  800193:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800199:	c9                   	leave  
  80019a:	c3                   	ret    

0080019b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80019b:	f3 0f 1e fb          	endbr32 
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a8:	50                   	push   %eax
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 95 ff ff ff       	call   800146 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	57                   	push   %edi
  8001b7:	56                   	push   %esi
  8001b8:	53                   	push   %ebx
  8001b9:	83 ec 1c             	sub    $0x1c,%esp
  8001bc:	89 c7                	mov    %eax,%edi
  8001be:	89 d6                	mov    %edx,%esi
  8001c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c6:	89 d1                	mov    %edx,%ecx
  8001c8:	89 c2                	mov    %eax,%edx
  8001ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8001d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001e0:	39 c2                	cmp    %eax,%edx
  8001e2:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001e5:	72 3e                	jb     800225 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 18             	pushl  0x18(%ebp)
  8001ed:	83 eb 01             	sub    $0x1,%ebx
  8001f0:	53                   	push   %ebx
  8001f1:	50                   	push   %eax
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fb:	ff 75 dc             	pushl  -0x24(%ebp)
  8001fe:	ff 75 d8             	pushl  -0x28(%ebp)
  800201:	e8 fa 0b 00 00       	call   800e00 <__udivdi3>
  800206:	83 c4 18             	add    $0x18,%esp
  800209:	52                   	push   %edx
  80020a:	50                   	push   %eax
  80020b:	89 f2                	mov    %esi,%edx
  80020d:	89 f8                	mov    %edi,%eax
  80020f:	e8 9f ff ff ff       	call   8001b3 <printnum>
  800214:	83 c4 20             	add    $0x20,%esp
  800217:	eb 13                	jmp    80022c <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	56                   	push   %esi
  80021d:	ff 75 18             	pushl  0x18(%ebp)
  800220:	ff d7                	call   *%edi
  800222:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800225:	83 eb 01             	sub    $0x1,%ebx
  800228:	85 db                	test   %ebx,%ebx
  80022a:	7f ed                	jg     800219 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	56                   	push   %esi
  800230:	83 ec 04             	sub    $0x4,%esp
  800233:	ff 75 e4             	pushl  -0x1c(%ebp)
  800236:	ff 75 e0             	pushl  -0x20(%ebp)
  800239:	ff 75 dc             	pushl  -0x24(%ebp)
  80023c:	ff 75 d8             	pushl  -0x28(%ebp)
  80023f:	e8 cc 0c 00 00       	call   800f10 <__umoddi3>
  800244:	83 c4 14             	add    $0x14,%esp
  800247:	0f be 80 d5 10 80 00 	movsbl 0x8010d5(%eax),%eax
  80024e:	50                   	push   %eax
  80024f:	ff d7                	call   *%edi
}
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800257:	5b                   	pop    %ebx
  800258:	5e                   	pop    %esi
  800259:	5f                   	pop    %edi
  80025a:	5d                   	pop    %ebp
  80025b:	c3                   	ret    

0080025c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80025c:	f3 0f 1e fb          	endbr32 
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800266:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80026a:	8b 10                	mov    (%eax),%edx
  80026c:	3b 50 04             	cmp    0x4(%eax),%edx
  80026f:	73 0a                	jae    80027b <sprintputch+0x1f>
		*b->buf++ = ch;
  800271:	8d 4a 01             	lea    0x1(%edx),%ecx
  800274:	89 08                	mov    %ecx,(%eax)
  800276:	8b 45 08             	mov    0x8(%ebp),%eax
  800279:	88 02                	mov    %al,(%edx)
}
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    

0080027d <printfmt>:
{
  80027d:	f3 0f 1e fb          	endbr32 
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800287:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80028a:	50                   	push   %eax
  80028b:	ff 75 10             	pushl  0x10(%ebp)
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	e8 05 00 00 00       	call   80029e <vprintfmt>
}
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	c9                   	leave  
  80029d:	c3                   	ret    

0080029e <vprintfmt>:
{
  80029e:	f3 0f 1e fb          	endbr32 
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	57                   	push   %edi
  8002a6:	56                   	push   %esi
  8002a7:	53                   	push   %ebx
  8002a8:	83 ec 3c             	sub    $0x3c,%esp
  8002ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b4:	e9 8e 03 00 00       	jmp    800647 <vprintfmt+0x3a9>
		padc = ' ';
  8002b9:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002bd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002c4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002cb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002d2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002d7:	8d 47 01             	lea    0x1(%edi),%eax
  8002da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002dd:	0f b6 17             	movzbl (%edi),%edx
  8002e0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002e3:	3c 55                	cmp    $0x55,%al
  8002e5:	0f 87 df 03 00 00    	ja     8006ca <vprintfmt+0x42c>
  8002eb:	0f b6 c0             	movzbl %al,%eax
  8002ee:	3e ff 24 85 a0 11 80 	notrack jmp *0x8011a0(,%eax,4)
  8002f5:	00 
  8002f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002f9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002fd:	eb d8                	jmp    8002d7 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800302:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800306:	eb cf                	jmp    8002d7 <vprintfmt+0x39>
  800308:	0f b6 d2             	movzbl %dl,%edx
  80030b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80030e:	b8 00 00 00 00       	mov    $0x0,%eax
  800313:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800316:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800319:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80031d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800320:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800323:	83 f9 09             	cmp    $0x9,%ecx
  800326:	77 55                	ja     80037d <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800328:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80032b:	eb e9                	jmp    800316 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80032d:	8b 45 14             	mov    0x14(%ebp),%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800335:	8b 45 14             	mov    0x14(%ebp),%eax
  800338:	8d 40 04             	lea    0x4(%eax),%eax
  80033b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80033e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800341:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800345:	79 90                	jns    8002d7 <vprintfmt+0x39>
				width = precision, precision = -1;
  800347:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80034a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80034d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800354:	eb 81                	jmp    8002d7 <vprintfmt+0x39>
  800356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800359:	85 c0                	test   %eax,%eax
  80035b:	ba 00 00 00 00       	mov    $0x0,%edx
  800360:	0f 49 d0             	cmovns %eax,%edx
  800363:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800366:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800369:	e9 69 ff ff ff       	jmp    8002d7 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80036e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800371:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800378:	e9 5a ff ff ff       	jmp    8002d7 <vprintfmt+0x39>
  80037d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800380:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800383:	eb bc                	jmp    800341 <vprintfmt+0xa3>
			lflag++;
  800385:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80038b:	e9 47 ff ff ff       	jmp    8002d7 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800390:	8b 45 14             	mov    0x14(%ebp),%eax
  800393:	8d 78 04             	lea    0x4(%eax),%edi
  800396:	83 ec 08             	sub    $0x8,%esp
  800399:	53                   	push   %ebx
  80039a:	ff 30                	pushl  (%eax)
  80039c:	ff d6                	call   *%esi
			break;
  80039e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003a4:	e9 9b 02 00 00       	jmp    800644 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ac:	8d 78 04             	lea    0x4(%eax),%edi
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	99                   	cltd   
  8003b2:	31 d0                	xor    %edx,%eax
  8003b4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003b6:	83 f8 08             	cmp    $0x8,%eax
  8003b9:	7f 23                	jg     8003de <vprintfmt+0x140>
  8003bb:	8b 14 85 00 13 80 00 	mov    0x801300(,%eax,4),%edx
  8003c2:	85 d2                	test   %edx,%edx
  8003c4:	74 18                	je     8003de <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003c6:	52                   	push   %edx
  8003c7:	68 f6 10 80 00       	push   $0x8010f6
  8003cc:	53                   	push   %ebx
  8003cd:	56                   	push   %esi
  8003ce:	e8 aa fe ff ff       	call   80027d <printfmt>
  8003d3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003d9:	e9 66 02 00 00       	jmp    800644 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003de:	50                   	push   %eax
  8003df:	68 ed 10 80 00       	push   $0x8010ed
  8003e4:	53                   	push   %ebx
  8003e5:	56                   	push   %esi
  8003e6:	e8 92 fe ff ff       	call   80027d <printfmt>
  8003eb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ee:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f1:	e9 4e 02 00 00       	jmp    800644 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f9:	83 c0 04             	add    $0x4,%eax
  8003fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800402:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800404:	85 d2                	test   %edx,%edx
  800406:	b8 e6 10 80 00       	mov    $0x8010e6,%eax
  80040b:	0f 45 c2             	cmovne %edx,%eax
  80040e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800411:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800415:	7e 06                	jle    80041d <vprintfmt+0x17f>
  800417:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80041b:	75 0d                	jne    80042a <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80041d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800420:	89 c7                	mov    %eax,%edi
  800422:	03 45 e0             	add    -0x20(%ebp),%eax
  800425:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800428:	eb 55                	jmp    80047f <vprintfmt+0x1e1>
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	ff 75 d8             	pushl  -0x28(%ebp)
  800430:	ff 75 cc             	pushl  -0x34(%ebp)
  800433:	e8 46 03 00 00       	call   80077e <strnlen>
  800438:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80043b:	29 c2                	sub    %eax,%edx
  80043d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800445:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800449:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80044c:	85 ff                	test   %edi,%edi
  80044e:	7e 11                	jle    800461 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	53                   	push   %ebx
  800454:	ff 75 e0             	pushl  -0x20(%ebp)
  800457:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800459:	83 ef 01             	sub    $0x1,%edi
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	eb eb                	jmp    80044c <vprintfmt+0x1ae>
  800461:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800464:	85 d2                	test   %edx,%edx
  800466:	b8 00 00 00 00       	mov    $0x0,%eax
  80046b:	0f 49 c2             	cmovns %edx,%eax
  80046e:	29 c2                	sub    %eax,%edx
  800470:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800473:	eb a8                	jmp    80041d <vprintfmt+0x17f>
					putch(ch, putdat);
  800475:	83 ec 08             	sub    $0x8,%esp
  800478:	53                   	push   %ebx
  800479:	52                   	push   %edx
  80047a:	ff d6                	call   *%esi
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800482:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800484:	83 c7 01             	add    $0x1,%edi
  800487:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80048b:	0f be d0             	movsbl %al,%edx
  80048e:	85 d2                	test   %edx,%edx
  800490:	74 4b                	je     8004dd <vprintfmt+0x23f>
  800492:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800496:	78 06                	js     80049e <vprintfmt+0x200>
  800498:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80049c:	78 1e                	js     8004bc <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80049e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004a2:	74 d1                	je     800475 <vprintfmt+0x1d7>
  8004a4:	0f be c0             	movsbl %al,%eax
  8004a7:	83 e8 20             	sub    $0x20,%eax
  8004aa:	83 f8 5e             	cmp    $0x5e,%eax
  8004ad:	76 c6                	jbe    800475 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	53                   	push   %ebx
  8004b3:	6a 3f                	push   $0x3f
  8004b5:	ff d6                	call   *%esi
  8004b7:	83 c4 10             	add    $0x10,%esp
  8004ba:	eb c3                	jmp    80047f <vprintfmt+0x1e1>
  8004bc:	89 cf                	mov    %ecx,%edi
  8004be:	eb 0e                	jmp    8004ce <vprintfmt+0x230>
				putch(' ', putdat);
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	53                   	push   %ebx
  8004c4:	6a 20                	push   $0x20
  8004c6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004c8:	83 ef 01             	sub    $0x1,%edi
  8004cb:	83 c4 10             	add    $0x10,%esp
  8004ce:	85 ff                	test   %edi,%edi
  8004d0:	7f ee                	jg     8004c0 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004d8:	e9 67 01 00 00       	jmp    800644 <vprintfmt+0x3a6>
  8004dd:	89 cf                	mov    %ecx,%edi
  8004df:	eb ed                	jmp    8004ce <vprintfmt+0x230>
	if (lflag >= 2)
  8004e1:	83 f9 01             	cmp    $0x1,%ecx
  8004e4:	7f 1b                	jg     800501 <vprintfmt+0x263>
	else if (lflag)
  8004e6:	85 c9                	test   %ecx,%ecx
  8004e8:	74 63                	je     80054d <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f2:	99                   	cltd   
  8004f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f9:	8d 40 04             	lea    0x4(%eax),%eax
  8004fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ff:	eb 17                	jmp    800518 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8b 50 04             	mov    0x4(%eax),%edx
  800507:	8b 00                	mov    (%eax),%eax
  800509:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8d 40 08             	lea    0x8(%eax),%eax
  800515:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800518:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80051b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80051e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800523:	85 c9                	test   %ecx,%ecx
  800525:	0f 89 ff 00 00 00    	jns    80062a <vprintfmt+0x38c>
				putch('-', putdat);
  80052b:	83 ec 08             	sub    $0x8,%esp
  80052e:	53                   	push   %ebx
  80052f:	6a 2d                	push   $0x2d
  800531:	ff d6                	call   *%esi
				num = -(long long) num;
  800533:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800536:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800539:	f7 da                	neg    %edx
  80053b:	83 d1 00             	adc    $0x0,%ecx
  80053e:	f7 d9                	neg    %ecx
  800540:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800543:	b8 0a 00 00 00       	mov    $0xa,%eax
  800548:	e9 dd 00 00 00       	jmp    80062a <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800555:	99                   	cltd   
  800556:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8d 40 04             	lea    0x4(%eax),%eax
  80055f:	89 45 14             	mov    %eax,0x14(%ebp)
  800562:	eb b4                	jmp    800518 <vprintfmt+0x27a>
	if (lflag >= 2)
  800564:	83 f9 01             	cmp    $0x1,%ecx
  800567:	7f 1e                	jg     800587 <vprintfmt+0x2e9>
	else if (lflag)
  800569:	85 c9                	test   %ecx,%ecx
  80056b:	74 32                	je     80059f <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8b 10                	mov    (%eax),%edx
  800572:	b9 00 00 00 00       	mov    $0x0,%ecx
  800577:	8d 40 04             	lea    0x4(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800582:	e9 a3 00 00 00       	jmp    80062a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 10                	mov    (%eax),%edx
  80058c:	8b 48 04             	mov    0x4(%eax),%ecx
  80058f:	8d 40 08             	lea    0x8(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800595:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80059a:	e9 8b 00 00 00       	jmp    80062a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8b 10                	mov    (%eax),%edx
  8005a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a9:	8d 40 04             	lea    0x4(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005af:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005b4:	eb 74                	jmp    80062a <vprintfmt+0x38c>
	if (lflag >= 2)
  8005b6:	83 f9 01             	cmp    $0x1,%ecx
  8005b9:	7f 1b                	jg     8005d6 <vprintfmt+0x338>
	else if (lflag)
  8005bb:	85 c9                	test   %ecx,%ecx
  8005bd:	74 2c                	je     8005eb <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8b 10                	mov    (%eax),%edx
  8005c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c9:	8d 40 04             	lea    0x4(%eax),%eax
  8005cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005cf:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005d4:	eb 54                	jmp    80062a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8b 10                	mov    (%eax),%edx
  8005db:	8b 48 04             	mov    0x4(%eax),%ecx
  8005de:	8d 40 08             	lea    0x8(%eax),%eax
  8005e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005e4:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005e9:	eb 3f                	jmp    80062a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8b 10                	mov    (%eax),%edx
  8005f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f5:	8d 40 04             	lea    0x4(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005fb:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800600:	eb 28                	jmp    80062a <vprintfmt+0x38c>
			putch('0', putdat);
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	53                   	push   %ebx
  800606:	6a 30                	push   $0x30
  800608:	ff d6                	call   *%esi
			putch('x', putdat);
  80060a:	83 c4 08             	add    $0x8,%esp
  80060d:	53                   	push   %ebx
  80060e:	6a 78                	push   $0x78
  800610:	ff d6                	call   *%esi
			num = (unsigned long long)
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80061c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80061f:	8d 40 04             	lea    0x4(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800625:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800631:	57                   	push   %edi
  800632:	ff 75 e0             	pushl  -0x20(%ebp)
  800635:	50                   	push   %eax
  800636:	51                   	push   %ecx
  800637:	52                   	push   %edx
  800638:	89 da                	mov    %ebx,%edx
  80063a:	89 f0                	mov    %esi,%eax
  80063c:	e8 72 fb ff ff       	call   8001b3 <printnum>
			break;
  800641:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800644:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800647:	83 c7 01             	add    $0x1,%edi
  80064a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80064e:	83 f8 25             	cmp    $0x25,%eax
  800651:	0f 84 62 fc ff ff    	je     8002b9 <vprintfmt+0x1b>
			if (ch == '\0')
  800657:	85 c0                	test   %eax,%eax
  800659:	0f 84 8b 00 00 00    	je     8006ea <vprintfmt+0x44c>
			putch(ch, putdat);
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	53                   	push   %ebx
  800663:	50                   	push   %eax
  800664:	ff d6                	call   *%esi
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	eb dc                	jmp    800647 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80066b:	83 f9 01             	cmp    $0x1,%ecx
  80066e:	7f 1b                	jg     80068b <vprintfmt+0x3ed>
	else if (lflag)
  800670:	85 c9                	test   %ecx,%ecx
  800672:	74 2c                	je     8006a0 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8b 10                	mov    (%eax),%edx
  800679:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067e:	8d 40 04             	lea    0x4(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800684:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800689:	eb 9f                	jmp    80062a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 10                	mov    (%eax),%edx
  800690:	8b 48 04             	mov    0x4(%eax),%ecx
  800693:	8d 40 08             	lea    0x8(%eax),%eax
  800696:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800699:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80069e:	eb 8a                	jmp    80062a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8b 10                	mov    (%eax),%edx
  8006a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b0:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006b5:	e9 70 ff ff ff       	jmp    80062a <vprintfmt+0x38c>
			putch(ch, putdat);
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	53                   	push   %ebx
  8006be:	6a 25                	push   $0x25
  8006c0:	ff d6                	call   *%esi
			break;
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	e9 7a ff ff ff       	jmp    800644 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	53                   	push   %ebx
  8006ce:	6a 25                	push   $0x25
  8006d0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	89 f8                	mov    %edi,%eax
  8006d7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006db:	74 05                	je     8006e2 <vprintfmt+0x444>
  8006dd:	83 e8 01             	sub    $0x1,%eax
  8006e0:	eb f5                	jmp    8006d7 <vprintfmt+0x439>
  8006e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e5:	e9 5a ff ff ff       	jmp    800644 <vprintfmt+0x3a6>
}
  8006ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006ed:	5b                   	pop    %ebx
  8006ee:	5e                   	pop    %esi
  8006ef:	5f                   	pop    %edi
  8006f0:	5d                   	pop    %ebp
  8006f1:	c3                   	ret    

008006f2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f2:	f3 0f 1e fb          	endbr32 
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	83 ec 18             	sub    $0x18,%esp
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800702:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800705:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800709:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80070c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800713:	85 c0                	test   %eax,%eax
  800715:	74 26                	je     80073d <vsnprintf+0x4b>
  800717:	85 d2                	test   %edx,%edx
  800719:	7e 22                	jle    80073d <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80071b:	ff 75 14             	pushl  0x14(%ebp)
  80071e:	ff 75 10             	pushl  0x10(%ebp)
  800721:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800724:	50                   	push   %eax
  800725:	68 5c 02 80 00       	push   $0x80025c
  80072a:	e8 6f fb ff ff       	call   80029e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80072f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800732:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800738:	83 c4 10             	add    $0x10,%esp
}
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    
		return -E_INVAL;
  80073d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800742:	eb f7                	jmp    80073b <vsnprintf+0x49>

00800744 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800744:	f3 0f 1e fb          	endbr32 
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80074e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800751:	50                   	push   %eax
  800752:	ff 75 10             	pushl  0x10(%ebp)
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	ff 75 08             	pushl  0x8(%ebp)
  80075b:	e8 92 ff ff ff       	call   8006f2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800760:	c9                   	leave  
  800761:	c3                   	ret    

00800762 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800762:	f3 0f 1e fb          	endbr32 
  800766:	55                   	push   %ebp
  800767:	89 e5                	mov    %esp,%ebp
  800769:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80076c:	b8 00 00 00 00       	mov    $0x0,%eax
  800771:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800775:	74 05                	je     80077c <strlen+0x1a>
		n++;
  800777:	83 c0 01             	add    $0x1,%eax
  80077a:	eb f5                	jmp    800771 <strlen+0xf>
	return n;
}
  80077c:	5d                   	pop    %ebp
  80077d:	c3                   	ret    

0080077e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80077e:	f3 0f 1e fb          	endbr32 
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
  800785:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800788:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078b:	b8 00 00 00 00       	mov    $0x0,%eax
  800790:	39 d0                	cmp    %edx,%eax
  800792:	74 0d                	je     8007a1 <strnlen+0x23>
  800794:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800798:	74 05                	je     80079f <strnlen+0x21>
		n++;
  80079a:	83 c0 01             	add    $0x1,%eax
  80079d:	eb f1                	jmp    800790 <strnlen+0x12>
  80079f:	89 c2                	mov    %eax,%edx
	return n;
}
  8007a1:	89 d0                	mov    %edx,%eax
  8007a3:	5d                   	pop    %ebp
  8007a4:	c3                   	ret    

008007a5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007a5:	f3 0f 1e fb          	endbr32 
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	53                   	push   %ebx
  8007ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b8:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007bc:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007bf:	83 c0 01             	add    $0x1,%eax
  8007c2:	84 d2                	test   %dl,%dl
  8007c4:	75 f2                	jne    8007b8 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007c6:	89 c8                	mov    %ecx,%eax
  8007c8:	5b                   	pop    %ebx
  8007c9:	5d                   	pop    %ebp
  8007ca:	c3                   	ret    

008007cb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007cb:	f3 0f 1e fb          	endbr32 
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	53                   	push   %ebx
  8007d3:	83 ec 10             	sub    $0x10,%esp
  8007d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007d9:	53                   	push   %ebx
  8007da:	e8 83 ff ff ff       	call   800762 <strlen>
  8007df:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007e2:	ff 75 0c             	pushl  0xc(%ebp)
  8007e5:	01 d8                	add    %ebx,%eax
  8007e7:	50                   	push   %eax
  8007e8:	e8 b8 ff ff ff       	call   8007a5 <strcpy>
	return dst;
}
  8007ed:	89 d8                	mov    %ebx,%eax
  8007ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f2:	c9                   	leave  
  8007f3:	c3                   	ret    

008007f4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007f4:	f3 0f 1e fb          	endbr32 
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	56                   	push   %esi
  8007fc:	53                   	push   %ebx
  8007fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800800:	8b 55 0c             	mov    0xc(%ebp),%edx
  800803:	89 f3                	mov    %esi,%ebx
  800805:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800808:	89 f0                	mov    %esi,%eax
  80080a:	39 d8                	cmp    %ebx,%eax
  80080c:	74 11                	je     80081f <strncpy+0x2b>
		*dst++ = *src;
  80080e:	83 c0 01             	add    $0x1,%eax
  800811:	0f b6 0a             	movzbl (%edx),%ecx
  800814:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800817:	80 f9 01             	cmp    $0x1,%cl
  80081a:	83 da ff             	sbb    $0xffffffff,%edx
  80081d:	eb eb                	jmp    80080a <strncpy+0x16>
	}
	return ret;
}
  80081f:	89 f0                	mov    %esi,%eax
  800821:	5b                   	pop    %ebx
  800822:	5e                   	pop    %esi
  800823:	5d                   	pop    %ebp
  800824:	c3                   	ret    

00800825 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800825:	f3 0f 1e fb          	endbr32 
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	56                   	push   %esi
  80082d:	53                   	push   %ebx
  80082e:	8b 75 08             	mov    0x8(%ebp),%esi
  800831:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800834:	8b 55 10             	mov    0x10(%ebp),%edx
  800837:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800839:	85 d2                	test   %edx,%edx
  80083b:	74 21                	je     80085e <strlcpy+0x39>
  80083d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800841:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800843:	39 c2                	cmp    %eax,%edx
  800845:	74 14                	je     80085b <strlcpy+0x36>
  800847:	0f b6 19             	movzbl (%ecx),%ebx
  80084a:	84 db                	test   %bl,%bl
  80084c:	74 0b                	je     800859 <strlcpy+0x34>
			*dst++ = *src++;
  80084e:	83 c1 01             	add    $0x1,%ecx
  800851:	83 c2 01             	add    $0x1,%edx
  800854:	88 5a ff             	mov    %bl,-0x1(%edx)
  800857:	eb ea                	jmp    800843 <strlcpy+0x1e>
  800859:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80085b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80085e:	29 f0                	sub    %esi,%eax
}
  800860:	5b                   	pop    %ebx
  800861:	5e                   	pop    %esi
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800864:	f3 0f 1e fb          	endbr32 
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800871:	0f b6 01             	movzbl (%ecx),%eax
  800874:	84 c0                	test   %al,%al
  800876:	74 0c                	je     800884 <strcmp+0x20>
  800878:	3a 02                	cmp    (%edx),%al
  80087a:	75 08                	jne    800884 <strcmp+0x20>
		p++, q++;
  80087c:	83 c1 01             	add    $0x1,%ecx
  80087f:	83 c2 01             	add    $0x1,%edx
  800882:	eb ed                	jmp    800871 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800884:	0f b6 c0             	movzbl %al,%eax
  800887:	0f b6 12             	movzbl (%edx),%edx
  80088a:	29 d0                	sub    %edx,%eax
}
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80088e:	f3 0f 1e fb          	endbr32 
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	53                   	push   %ebx
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089c:	89 c3                	mov    %eax,%ebx
  80089e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008a1:	eb 06                	jmp    8008a9 <strncmp+0x1b>
		n--, p++, q++;
  8008a3:	83 c0 01             	add    $0x1,%eax
  8008a6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008a9:	39 d8                	cmp    %ebx,%eax
  8008ab:	74 16                	je     8008c3 <strncmp+0x35>
  8008ad:	0f b6 08             	movzbl (%eax),%ecx
  8008b0:	84 c9                	test   %cl,%cl
  8008b2:	74 04                	je     8008b8 <strncmp+0x2a>
  8008b4:	3a 0a                	cmp    (%edx),%cl
  8008b6:	74 eb                	je     8008a3 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b8:	0f b6 00             	movzbl (%eax),%eax
  8008bb:	0f b6 12             	movzbl (%edx),%edx
  8008be:	29 d0                	sub    %edx,%eax
}
  8008c0:	5b                   	pop    %ebx
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    
		return 0;
  8008c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c8:	eb f6                	jmp    8008c0 <strncmp+0x32>

008008ca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ca:	f3 0f 1e fb          	endbr32 
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d8:	0f b6 10             	movzbl (%eax),%edx
  8008db:	84 d2                	test   %dl,%dl
  8008dd:	74 09                	je     8008e8 <strchr+0x1e>
		if (*s == c)
  8008df:	38 ca                	cmp    %cl,%dl
  8008e1:	74 0a                	je     8008ed <strchr+0x23>
	for (; *s; s++)
  8008e3:	83 c0 01             	add    $0x1,%eax
  8008e6:	eb f0                	jmp    8008d8 <strchr+0xe>
			return (char *) s;
	return 0;
  8008e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ef:	f3 0f 1e fb          	endbr32 
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800900:	38 ca                	cmp    %cl,%dl
  800902:	74 09                	je     80090d <strfind+0x1e>
  800904:	84 d2                	test   %dl,%dl
  800906:	74 05                	je     80090d <strfind+0x1e>
	for (; *s; s++)
  800908:	83 c0 01             	add    $0x1,%eax
  80090b:	eb f0                	jmp    8008fd <strfind+0xe>
			break;
	return (char *) s;
}
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80090f:	f3 0f 1e fb          	endbr32 
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	57                   	push   %edi
  800917:	56                   	push   %esi
  800918:	53                   	push   %ebx
  800919:	8b 7d 08             	mov    0x8(%ebp),%edi
  80091c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80091f:	85 c9                	test   %ecx,%ecx
  800921:	74 31                	je     800954 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800923:	89 f8                	mov    %edi,%eax
  800925:	09 c8                	or     %ecx,%eax
  800927:	a8 03                	test   $0x3,%al
  800929:	75 23                	jne    80094e <memset+0x3f>
		c &= 0xFF;
  80092b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80092f:	89 d3                	mov    %edx,%ebx
  800931:	c1 e3 08             	shl    $0x8,%ebx
  800934:	89 d0                	mov    %edx,%eax
  800936:	c1 e0 18             	shl    $0x18,%eax
  800939:	89 d6                	mov    %edx,%esi
  80093b:	c1 e6 10             	shl    $0x10,%esi
  80093e:	09 f0                	or     %esi,%eax
  800940:	09 c2                	or     %eax,%edx
  800942:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800944:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800947:	89 d0                	mov    %edx,%eax
  800949:	fc                   	cld    
  80094a:	f3 ab                	rep stos %eax,%es:(%edi)
  80094c:	eb 06                	jmp    800954 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	fc                   	cld    
  800952:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800954:	89 f8                	mov    %edi,%eax
  800956:	5b                   	pop    %ebx
  800957:	5e                   	pop    %esi
  800958:	5f                   	pop    %edi
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80095b:	f3 0f 1e fb          	endbr32 
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	57                   	push   %edi
  800963:	56                   	push   %esi
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	8b 75 0c             	mov    0xc(%ebp),%esi
  80096a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80096d:	39 c6                	cmp    %eax,%esi
  80096f:	73 32                	jae    8009a3 <memmove+0x48>
  800971:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800974:	39 c2                	cmp    %eax,%edx
  800976:	76 2b                	jbe    8009a3 <memmove+0x48>
		s += n;
		d += n;
  800978:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097b:	89 fe                	mov    %edi,%esi
  80097d:	09 ce                	or     %ecx,%esi
  80097f:	09 d6                	or     %edx,%esi
  800981:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800987:	75 0e                	jne    800997 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800989:	83 ef 04             	sub    $0x4,%edi
  80098c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80098f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800992:	fd                   	std    
  800993:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800995:	eb 09                	jmp    8009a0 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800997:	83 ef 01             	sub    $0x1,%edi
  80099a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80099d:	fd                   	std    
  80099e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a0:	fc                   	cld    
  8009a1:	eb 1a                	jmp    8009bd <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a3:	89 c2                	mov    %eax,%edx
  8009a5:	09 ca                	or     %ecx,%edx
  8009a7:	09 f2                	or     %esi,%edx
  8009a9:	f6 c2 03             	test   $0x3,%dl
  8009ac:	75 0a                	jne    8009b8 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009ae:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009b1:	89 c7                	mov    %eax,%edi
  8009b3:	fc                   	cld    
  8009b4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b6:	eb 05                	jmp    8009bd <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009b8:	89 c7                	mov    %eax,%edi
  8009ba:	fc                   	cld    
  8009bb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009bd:	5e                   	pop    %esi
  8009be:	5f                   	pop    %edi
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009c1:	f3 0f 1e fb          	endbr32 
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009cb:	ff 75 10             	pushl  0x10(%ebp)
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	ff 75 08             	pushl  0x8(%ebp)
  8009d4:	e8 82 ff ff ff       	call   80095b <memmove>
}
  8009d9:	c9                   	leave  
  8009da:	c3                   	ret    

008009db <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009db:	f3 0f 1e fb          	endbr32 
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	56                   	push   %esi
  8009e3:	53                   	push   %ebx
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ea:	89 c6                	mov    %eax,%esi
  8009ec:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ef:	39 f0                	cmp    %esi,%eax
  8009f1:	74 1c                	je     800a0f <memcmp+0x34>
		if (*s1 != *s2)
  8009f3:	0f b6 08             	movzbl (%eax),%ecx
  8009f6:	0f b6 1a             	movzbl (%edx),%ebx
  8009f9:	38 d9                	cmp    %bl,%cl
  8009fb:	75 08                	jne    800a05 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009fd:	83 c0 01             	add    $0x1,%eax
  800a00:	83 c2 01             	add    $0x1,%edx
  800a03:	eb ea                	jmp    8009ef <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a05:	0f b6 c1             	movzbl %cl,%eax
  800a08:	0f b6 db             	movzbl %bl,%ebx
  800a0b:	29 d8                	sub    %ebx,%eax
  800a0d:	eb 05                	jmp    800a14 <memcmp+0x39>
	}

	return 0;
  800a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a14:	5b                   	pop    %ebx
  800a15:	5e                   	pop    %esi
  800a16:	5d                   	pop    %ebp
  800a17:	c3                   	ret    

00800a18 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a18:	f3 0f 1e fb          	endbr32 
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a25:	89 c2                	mov    %eax,%edx
  800a27:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a2a:	39 d0                	cmp    %edx,%eax
  800a2c:	73 09                	jae    800a37 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a2e:	38 08                	cmp    %cl,(%eax)
  800a30:	74 05                	je     800a37 <memfind+0x1f>
	for (; s < ends; s++)
  800a32:	83 c0 01             	add    $0x1,%eax
  800a35:	eb f3                	jmp    800a2a <memfind+0x12>
			break;
	return (void *) s;
}
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a39:	f3 0f 1e fb          	endbr32 
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	57                   	push   %edi
  800a41:	56                   	push   %esi
  800a42:	53                   	push   %ebx
  800a43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a49:	eb 03                	jmp    800a4e <strtol+0x15>
		s++;
  800a4b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a4e:	0f b6 01             	movzbl (%ecx),%eax
  800a51:	3c 20                	cmp    $0x20,%al
  800a53:	74 f6                	je     800a4b <strtol+0x12>
  800a55:	3c 09                	cmp    $0x9,%al
  800a57:	74 f2                	je     800a4b <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a59:	3c 2b                	cmp    $0x2b,%al
  800a5b:	74 2a                	je     800a87 <strtol+0x4e>
	int neg = 0;
  800a5d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a62:	3c 2d                	cmp    $0x2d,%al
  800a64:	74 2b                	je     800a91 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a66:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a6c:	75 0f                	jne    800a7d <strtol+0x44>
  800a6e:	80 39 30             	cmpb   $0x30,(%ecx)
  800a71:	74 28                	je     800a9b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a73:	85 db                	test   %ebx,%ebx
  800a75:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a7a:	0f 44 d8             	cmove  %eax,%ebx
  800a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a82:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a85:	eb 46                	jmp    800acd <strtol+0x94>
		s++;
  800a87:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8f:	eb d5                	jmp    800a66 <strtol+0x2d>
		s++, neg = 1;
  800a91:	83 c1 01             	add    $0x1,%ecx
  800a94:	bf 01 00 00 00       	mov    $0x1,%edi
  800a99:	eb cb                	jmp    800a66 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a9f:	74 0e                	je     800aaf <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aa1:	85 db                	test   %ebx,%ebx
  800aa3:	75 d8                	jne    800a7d <strtol+0x44>
		s++, base = 8;
  800aa5:	83 c1 01             	add    $0x1,%ecx
  800aa8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aad:	eb ce                	jmp    800a7d <strtol+0x44>
		s += 2, base = 16;
  800aaf:	83 c1 02             	add    $0x2,%ecx
  800ab2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ab7:	eb c4                	jmp    800a7d <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ab9:	0f be d2             	movsbl %dl,%edx
  800abc:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800abf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ac2:	7d 3a                	jge    800afe <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ac4:	83 c1 01             	add    $0x1,%ecx
  800ac7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800acb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800acd:	0f b6 11             	movzbl (%ecx),%edx
  800ad0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ad3:	89 f3                	mov    %esi,%ebx
  800ad5:	80 fb 09             	cmp    $0x9,%bl
  800ad8:	76 df                	jbe    800ab9 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ada:	8d 72 9f             	lea    -0x61(%edx),%esi
  800add:	89 f3                	mov    %esi,%ebx
  800adf:	80 fb 19             	cmp    $0x19,%bl
  800ae2:	77 08                	ja     800aec <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ae4:	0f be d2             	movsbl %dl,%edx
  800ae7:	83 ea 57             	sub    $0x57,%edx
  800aea:	eb d3                	jmp    800abf <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800aec:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aef:	89 f3                	mov    %esi,%ebx
  800af1:	80 fb 19             	cmp    $0x19,%bl
  800af4:	77 08                	ja     800afe <strtol+0xc5>
			dig = *s - 'A' + 10;
  800af6:	0f be d2             	movsbl %dl,%edx
  800af9:	83 ea 37             	sub    $0x37,%edx
  800afc:	eb c1                	jmp    800abf <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800afe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b02:	74 05                	je     800b09 <strtol+0xd0>
		*endptr = (char *) s;
  800b04:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b07:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b09:	89 c2                	mov    %eax,%edx
  800b0b:	f7 da                	neg    %edx
  800b0d:	85 ff                	test   %edi,%edi
  800b0f:	0f 45 c2             	cmovne %edx,%eax
}
  800b12:	5b                   	pop    %ebx
  800b13:	5e                   	pop    %esi
  800b14:	5f                   	pop    %edi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b17:	f3 0f 1e fb          	endbr32 
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	57                   	push   %edi
  800b1f:	56                   	push   %esi
  800b20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b21:	b8 00 00 00 00       	mov    $0x0,%eax
  800b26:	8b 55 08             	mov    0x8(%ebp),%edx
  800b29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b2c:	89 c3                	mov    %eax,%ebx
  800b2e:	89 c7                	mov    %eax,%edi
  800b30:	89 c6                	mov    %eax,%esi
  800b32:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5f                   	pop    %edi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b39:	f3 0f 1e fb          	endbr32 
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	57                   	push   %edi
  800b41:	56                   	push   %esi
  800b42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b43:	ba 00 00 00 00       	mov    $0x0,%edx
  800b48:	b8 01 00 00 00       	mov    $0x1,%eax
  800b4d:	89 d1                	mov    %edx,%ecx
  800b4f:	89 d3                	mov    %edx,%ebx
  800b51:	89 d7                	mov    %edx,%edi
  800b53:	89 d6                	mov    %edx,%esi
  800b55:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b5c:	f3 0f 1e fb          	endbr32 
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	57                   	push   %edi
  800b64:	56                   	push   %esi
  800b65:	53                   	push   %ebx
  800b66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b69:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b71:	b8 03 00 00 00       	mov    $0x3,%eax
  800b76:	89 cb                	mov    %ecx,%ebx
  800b78:	89 cf                	mov    %ecx,%edi
  800b7a:	89 ce                	mov    %ecx,%esi
  800b7c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b7e:	85 c0                	test   %eax,%eax
  800b80:	7f 08                	jg     800b8a <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b85:	5b                   	pop    %ebx
  800b86:	5e                   	pop    %esi
  800b87:	5f                   	pop    %edi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b8a:	83 ec 0c             	sub    $0xc,%esp
  800b8d:	50                   	push   %eax
  800b8e:	6a 03                	push   $0x3
  800b90:	68 24 13 80 00       	push   $0x801324
  800b95:	6a 23                	push   $0x23
  800b97:	68 41 13 80 00       	push   $0x801341
  800b9c:	e8 11 02 00 00       	call   800db2 <_panic>

00800ba1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ba1:	f3 0f 1e fb          	endbr32 
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb0:	b8 02 00 00 00       	mov    $0x2,%eax
  800bb5:	89 d1                	mov    %edx,%ecx
  800bb7:	89 d3                	mov    %edx,%ebx
  800bb9:	89 d7                	mov    %edx,%edi
  800bbb:	89 d6                	mov    %edx,%esi
  800bbd:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <sys_yield>:

void
sys_yield(void)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bce:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd8:	89 d1                	mov    %edx,%ecx
  800bda:	89 d3                	mov    %edx,%ebx
  800bdc:	89 d7                	mov    %edx,%edi
  800bde:	89 d6                	mov    %edx,%esi
  800be0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be7:	f3 0f 1e fb          	endbr32 
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	57                   	push   %edi
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
  800bf1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf4:	be 00 00 00 00       	mov    $0x0,%esi
  800bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bff:	b8 04 00 00 00       	mov    $0x4,%eax
  800c04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c07:	89 f7                	mov    %esi,%edi
  800c09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0b:	85 c0                	test   %eax,%eax
  800c0d:	7f 08                	jg     800c17 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c17:	83 ec 0c             	sub    $0xc,%esp
  800c1a:	50                   	push   %eax
  800c1b:	6a 04                	push   $0x4
  800c1d:	68 24 13 80 00       	push   $0x801324
  800c22:	6a 23                	push   $0x23
  800c24:	68 41 13 80 00       	push   $0x801341
  800c29:	e8 84 01 00 00       	call   800db2 <_panic>

00800c2e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c2e:	f3 0f 1e fb          	endbr32 
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
  800c38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c41:	b8 05 00 00 00       	mov    $0x5,%eax
  800c46:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c49:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c4c:	8b 75 18             	mov    0x18(%ebp),%esi
  800c4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c51:	85 c0                	test   %eax,%eax
  800c53:	7f 08                	jg     800c5d <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c58:	5b                   	pop    %ebx
  800c59:	5e                   	pop    %esi
  800c5a:	5f                   	pop    %edi
  800c5b:	5d                   	pop    %ebp
  800c5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5d:	83 ec 0c             	sub    $0xc,%esp
  800c60:	50                   	push   %eax
  800c61:	6a 05                	push   $0x5
  800c63:	68 24 13 80 00       	push   $0x801324
  800c68:	6a 23                	push   $0x23
  800c6a:	68 41 13 80 00       	push   $0x801341
  800c6f:	e8 3e 01 00 00       	call   800db2 <_panic>

00800c74 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c74:	f3 0f 1e fb          	endbr32 
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	57                   	push   %edi
  800c7c:	56                   	push   %esi
  800c7d:	53                   	push   %ebx
  800c7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c86:	8b 55 08             	mov    0x8(%ebp),%edx
  800c89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8c:	b8 06 00 00 00       	mov    $0x6,%eax
  800c91:	89 df                	mov    %ebx,%edi
  800c93:	89 de                	mov    %ebx,%esi
  800c95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	7f 08                	jg     800ca3 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5f                   	pop    %edi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca3:	83 ec 0c             	sub    $0xc,%esp
  800ca6:	50                   	push   %eax
  800ca7:	6a 06                	push   $0x6
  800ca9:	68 24 13 80 00       	push   $0x801324
  800cae:	6a 23                	push   $0x23
  800cb0:	68 41 13 80 00       	push   $0x801341
  800cb5:	e8 f8 00 00 00       	call   800db2 <_panic>

00800cba <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cba:	f3 0f 1e fb          	endbr32 
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	57                   	push   %edi
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
  800cc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd2:	b8 08 00 00 00       	mov    $0x8,%eax
  800cd7:	89 df                	mov    %ebx,%edi
  800cd9:	89 de                	mov    %ebx,%esi
  800cdb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdd:	85 c0                	test   %eax,%eax
  800cdf:	7f 08                	jg     800ce9 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce4:	5b                   	pop    %ebx
  800ce5:	5e                   	pop    %esi
  800ce6:	5f                   	pop    %edi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce9:	83 ec 0c             	sub    $0xc,%esp
  800cec:	50                   	push   %eax
  800ced:	6a 08                	push   $0x8
  800cef:	68 24 13 80 00       	push   $0x801324
  800cf4:	6a 23                	push   $0x23
  800cf6:	68 41 13 80 00       	push   $0x801341
  800cfb:	e8 b2 00 00 00       	call   800db2 <_panic>

00800d00 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d00:	f3 0f 1e fb          	endbr32 
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d12:	8b 55 08             	mov    0x8(%ebp),%edx
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	b8 09 00 00 00       	mov    $0x9,%eax
  800d1d:	89 df                	mov    %ebx,%edi
  800d1f:	89 de                	mov    %ebx,%esi
  800d21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7f 08                	jg     800d2f <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	50                   	push   %eax
  800d33:	6a 09                	push   $0x9
  800d35:	68 24 13 80 00       	push   $0x801324
  800d3a:	6a 23                	push   $0x23
  800d3c:	68 41 13 80 00       	push   $0x801341
  800d41:	e8 6c 00 00 00       	call   800db2 <_panic>

00800d46 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d46:	f3 0f 1e fb          	endbr32 
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d50:	8b 55 08             	mov    0x8(%ebp),%edx
  800d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d56:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d5b:	be 00 00 00 00       	mov    $0x0,%esi
  800d60:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d63:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d66:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5f                   	pop    %edi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d6d:	f3 0f 1e fb          	endbr32 
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	57                   	push   %edi
  800d75:	56                   	push   %esi
  800d76:	53                   	push   %ebx
  800d77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d87:	89 cb                	mov    %ecx,%ebx
  800d89:	89 cf                	mov    %ecx,%edi
  800d8b:	89 ce                	mov    %ecx,%esi
  800d8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	50                   	push   %eax
  800d9f:	6a 0c                	push   $0xc
  800da1:	68 24 13 80 00       	push   $0x801324
  800da6:	6a 23                	push   $0x23
  800da8:	68 41 13 80 00       	push   $0x801341
  800dad:	e8 00 00 00 00       	call   800db2 <_panic>

00800db2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800db2:	f3 0f 1e fb          	endbr32 
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800dbb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800dbe:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800dc4:	e8 d8 fd ff ff       	call   800ba1 <sys_getenvid>
  800dc9:	83 ec 0c             	sub    $0xc,%esp
  800dcc:	ff 75 0c             	pushl  0xc(%ebp)
  800dcf:	ff 75 08             	pushl  0x8(%ebp)
  800dd2:	56                   	push   %esi
  800dd3:	50                   	push   %eax
  800dd4:	68 50 13 80 00       	push   $0x801350
  800dd9:	e8 bd f3 ff ff       	call   80019b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800dde:	83 c4 18             	add    $0x18,%esp
  800de1:	53                   	push   %ebx
  800de2:	ff 75 10             	pushl  0x10(%ebp)
  800de5:	e8 5c f3 ff ff       	call   800146 <vcprintf>
	cprintf("\n");
  800dea:	c7 04 24 73 13 80 00 	movl   $0x801373,(%esp)
  800df1:	e8 a5 f3 ff ff       	call   80019b <cprintf>
  800df6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800df9:	cc                   	int3   
  800dfa:	eb fd                	jmp    800df9 <_panic+0x47>
  800dfc:	66 90                	xchg   %ax,%ax
  800dfe:	66 90                	xchg   %ax,%ax

00800e00 <__udivdi3>:
  800e00:	f3 0f 1e fb          	endbr32 
  800e04:	55                   	push   %ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
  800e08:	83 ec 1c             	sub    $0x1c,%esp
  800e0b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e0f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e13:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e17:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e1b:	85 d2                	test   %edx,%edx
  800e1d:	75 19                	jne    800e38 <__udivdi3+0x38>
  800e1f:	39 f3                	cmp    %esi,%ebx
  800e21:	76 4d                	jbe    800e70 <__udivdi3+0x70>
  800e23:	31 ff                	xor    %edi,%edi
  800e25:	89 e8                	mov    %ebp,%eax
  800e27:	89 f2                	mov    %esi,%edx
  800e29:	f7 f3                	div    %ebx
  800e2b:	89 fa                	mov    %edi,%edx
  800e2d:	83 c4 1c             	add    $0x1c,%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    
  800e35:	8d 76 00             	lea    0x0(%esi),%esi
  800e38:	39 f2                	cmp    %esi,%edx
  800e3a:	76 14                	jbe    800e50 <__udivdi3+0x50>
  800e3c:	31 ff                	xor    %edi,%edi
  800e3e:	31 c0                	xor    %eax,%eax
  800e40:	89 fa                	mov    %edi,%edx
  800e42:	83 c4 1c             	add    $0x1c,%esp
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
  800e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e50:	0f bd fa             	bsr    %edx,%edi
  800e53:	83 f7 1f             	xor    $0x1f,%edi
  800e56:	75 48                	jne    800ea0 <__udivdi3+0xa0>
  800e58:	39 f2                	cmp    %esi,%edx
  800e5a:	72 06                	jb     800e62 <__udivdi3+0x62>
  800e5c:	31 c0                	xor    %eax,%eax
  800e5e:	39 eb                	cmp    %ebp,%ebx
  800e60:	77 de                	ja     800e40 <__udivdi3+0x40>
  800e62:	b8 01 00 00 00       	mov    $0x1,%eax
  800e67:	eb d7                	jmp    800e40 <__udivdi3+0x40>
  800e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e70:	89 d9                	mov    %ebx,%ecx
  800e72:	85 db                	test   %ebx,%ebx
  800e74:	75 0b                	jne    800e81 <__udivdi3+0x81>
  800e76:	b8 01 00 00 00       	mov    $0x1,%eax
  800e7b:	31 d2                	xor    %edx,%edx
  800e7d:	f7 f3                	div    %ebx
  800e7f:	89 c1                	mov    %eax,%ecx
  800e81:	31 d2                	xor    %edx,%edx
  800e83:	89 f0                	mov    %esi,%eax
  800e85:	f7 f1                	div    %ecx
  800e87:	89 c6                	mov    %eax,%esi
  800e89:	89 e8                	mov    %ebp,%eax
  800e8b:	89 f7                	mov    %esi,%edi
  800e8d:	f7 f1                	div    %ecx
  800e8f:	89 fa                	mov    %edi,%edx
  800e91:	83 c4 1c             	add    $0x1c,%esp
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    
  800e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ea0:	89 f9                	mov    %edi,%ecx
  800ea2:	b8 20 00 00 00       	mov    $0x20,%eax
  800ea7:	29 f8                	sub    %edi,%eax
  800ea9:	d3 e2                	shl    %cl,%edx
  800eab:	89 54 24 08          	mov    %edx,0x8(%esp)
  800eaf:	89 c1                	mov    %eax,%ecx
  800eb1:	89 da                	mov    %ebx,%edx
  800eb3:	d3 ea                	shr    %cl,%edx
  800eb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800eb9:	09 d1                	or     %edx,%ecx
  800ebb:	89 f2                	mov    %esi,%edx
  800ebd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ec1:	89 f9                	mov    %edi,%ecx
  800ec3:	d3 e3                	shl    %cl,%ebx
  800ec5:	89 c1                	mov    %eax,%ecx
  800ec7:	d3 ea                	shr    %cl,%edx
  800ec9:	89 f9                	mov    %edi,%ecx
  800ecb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800ecf:	89 eb                	mov    %ebp,%ebx
  800ed1:	d3 e6                	shl    %cl,%esi
  800ed3:	89 c1                	mov    %eax,%ecx
  800ed5:	d3 eb                	shr    %cl,%ebx
  800ed7:	09 de                	or     %ebx,%esi
  800ed9:	89 f0                	mov    %esi,%eax
  800edb:	f7 74 24 08          	divl   0x8(%esp)
  800edf:	89 d6                	mov    %edx,%esi
  800ee1:	89 c3                	mov    %eax,%ebx
  800ee3:	f7 64 24 0c          	mull   0xc(%esp)
  800ee7:	39 d6                	cmp    %edx,%esi
  800ee9:	72 15                	jb     800f00 <__udivdi3+0x100>
  800eeb:	89 f9                	mov    %edi,%ecx
  800eed:	d3 e5                	shl    %cl,%ebp
  800eef:	39 c5                	cmp    %eax,%ebp
  800ef1:	73 04                	jae    800ef7 <__udivdi3+0xf7>
  800ef3:	39 d6                	cmp    %edx,%esi
  800ef5:	74 09                	je     800f00 <__udivdi3+0x100>
  800ef7:	89 d8                	mov    %ebx,%eax
  800ef9:	31 ff                	xor    %edi,%edi
  800efb:	e9 40 ff ff ff       	jmp    800e40 <__udivdi3+0x40>
  800f00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f03:	31 ff                	xor    %edi,%edi
  800f05:	e9 36 ff ff ff       	jmp    800e40 <__udivdi3+0x40>
  800f0a:	66 90                	xchg   %ax,%ax
  800f0c:	66 90                	xchg   %ax,%ax
  800f0e:	66 90                	xchg   %ax,%ax

00800f10 <__umoddi3>:
  800f10:	f3 0f 1e fb          	endbr32 
  800f14:	55                   	push   %ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
  800f18:	83 ec 1c             	sub    $0x1c,%esp
  800f1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800f1f:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f23:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	75 19                	jne    800f48 <__umoddi3+0x38>
  800f2f:	39 df                	cmp    %ebx,%edi
  800f31:	76 5d                	jbe    800f90 <__umoddi3+0x80>
  800f33:	89 f0                	mov    %esi,%eax
  800f35:	89 da                	mov    %ebx,%edx
  800f37:	f7 f7                	div    %edi
  800f39:	89 d0                	mov    %edx,%eax
  800f3b:	31 d2                	xor    %edx,%edx
  800f3d:	83 c4 1c             	add    $0x1c,%esp
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    
  800f45:	8d 76 00             	lea    0x0(%esi),%esi
  800f48:	89 f2                	mov    %esi,%edx
  800f4a:	39 d8                	cmp    %ebx,%eax
  800f4c:	76 12                	jbe    800f60 <__umoddi3+0x50>
  800f4e:	89 f0                	mov    %esi,%eax
  800f50:	89 da                	mov    %ebx,%edx
  800f52:	83 c4 1c             	add    $0x1c,%esp
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5f                   	pop    %edi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    
  800f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f60:	0f bd e8             	bsr    %eax,%ebp
  800f63:	83 f5 1f             	xor    $0x1f,%ebp
  800f66:	75 50                	jne    800fb8 <__umoddi3+0xa8>
  800f68:	39 d8                	cmp    %ebx,%eax
  800f6a:	0f 82 e0 00 00 00    	jb     801050 <__umoddi3+0x140>
  800f70:	89 d9                	mov    %ebx,%ecx
  800f72:	39 f7                	cmp    %esi,%edi
  800f74:	0f 86 d6 00 00 00    	jbe    801050 <__umoddi3+0x140>
  800f7a:	89 d0                	mov    %edx,%eax
  800f7c:	89 ca                	mov    %ecx,%edx
  800f7e:	83 c4 1c             	add    $0x1c,%esp
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    
  800f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f8d:	8d 76 00             	lea    0x0(%esi),%esi
  800f90:	89 fd                	mov    %edi,%ebp
  800f92:	85 ff                	test   %edi,%edi
  800f94:	75 0b                	jne    800fa1 <__umoddi3+0x91>
  800f96:	b8 01 00 00 00       	mov    $0x1,%eax
  800f9b:	31 d2                	xor    %edx,%edx
  800f9d:	f7 f7                	div    %edi
  800f9f:	89 c5                	mov    %eax,%ebp
  800fa1:	89 d8                	mov    %ebx,%eax
  800fa3:	31 d2                	xor    %edx,%edx
  800fa5:	f7 f5                	div    %ebp
  800fa7:	89 f0                	mov    %esi,%eax
  800fa9:	f7 f5                	div    %ebp
  800fab:	89 d0                	mov    %edx,%eax
  800fad:	31 d2                	xor    %edx,%edx
  800faf:	eb 8c                	jmp    800f3d <__umoddi3+0x2d>
  800fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fb8:	89 e9                	mov    %ebp,%ecx
  800fba:	ba 20 00 00 00       	mov    $0x20,%edx
  800fbf:	29 ea                	sub    %ebp,%edx
  800fc1:	d3 e0                	shl    %cl,%eax
  800fc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fc7:	89 d1                	mov    %edx,%ecx
  800fc9:	89 f8                	mov    %edi,%eax
  800fcb:	d3 e8                	shr    %cl,%eax
  800fcd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fd1:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fd5:	8b 54 24 04          	mov    0x4(%esp),%edx
  800fd9:	09 c1                	or     %eax,%ecx
  800fdb:	89 d8                	mov    %ebx,%eax
  800fdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fe1:	89 e9                	mov    %ebp,%ecx
  800fe3:	d3 e7                	shl    %cl,%edi
  800fe5:	89 d1                	mov    %edx,%ecx
  800fe7:	d3 e8                	shr    %cl,%eax
  800fe9:	89 e9                	mov    %ebp,%ecx
  800feb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800fef:	d3 e3                	shl    %cl,%ebx
  800ff1:	89 c7                	mov    %eax,%edi
  800ff3:	89 d1                	mov    %edx,%ecx
  800ff5:	89 f0                	mov    %esi,%eax
  800ff7:	d3 e8                	shr    %cl,%eax
  800ff9:	89 e9                	mov    %ebp,%ecx
  800ffb:	89 fa                	mov    %edi,%edx
  800ffd:	d3 e6                	shl    %cl,%esi
  800fff:	09 d8                	or     %ebx,%eax
  801001:	f7 74 24 08          	divl   0x8(%esp)
  801005:	89 d1                	mov    %edx,%ecx
  801007:	89 f3                	mov    %esi,%ebx
  801009:	f7 64 24 0c          	mull   0xc(%esp)
  80100d:	89 c6                	mov    %eax,%esi
  80100f:	89 d7                	mov    %edx,%edi
  801011:	39 d1                	cmp    %edx,%ecx
  801013:	72 06                	jb     80101b <__umoddi3+0x10b>
  801015:	75 10                	jne    801027 <__umoddi3+0x117>
  801017:	39 c3                	cmp    %eax,%ebx
  801019:	73 0c                	jae    801027 <__umoddi3+0x117>
  80101b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80101f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801023:	89 d7                	mov    %edx,%edi
  801025:	89 c6                	mov    %eax,%esi
  801027:	89 ca                	mov    %ecx,%edx
  801029:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80102e:	29 f3                	sub    %esi,%ebx
  801030:	19 fa                	sbb    %edi,%edx
  801032:	89 d0                	mov    %edx,%eax
  801034:	d3 e0                	shl    %cl,%eax
  801036:	89 e9                	mov    %ebp,%ecx
  801038:	d3 eb                	shr    %cl,%ebx
  80103a:	d3 ea                	shr    %cl,%edx
  80103c:	09 d8                	or     %ebx,%eax
  80103e:	83 c4 1c             	add    $0x1c,%esp
  801041:	5b                   	pop    %ebx
  801042:	5e                   	pop    %esi
  801043:	5f                   	pop    %edi
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    
  801046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80104d:	8d 76 00             	lea    0x0(%esi),%esi
  801050:	29 fe                	sub    %edi,%esi
  801052:	19 c3                	sbb    %eax,%ebx
  801054:	89 f2                	mov    %esi,%edx
  801056:	89 d9                	mov    %ebx,%ecx
  801058:	e9 1d ff ff ff       	jmp    800f7a <__umoddi3+0x6a>
