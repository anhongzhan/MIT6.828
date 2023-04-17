
obj/user/yield.debug:     file format elf32-i386


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
  80003e:	a1 04 40 80 00       	mov    0x804004,%eax
  800043:	8b 40 48             	mov    0x48(%eax),%eax
  800046:	50                   	push   %eax
  800047:	68 60 1f 80 00       	push   $0x801f60
  80004c:	e8 52 01 00 00       	call   8001a3 <cprintf>
  800051:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800054:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800059:	e8 6e 0b 00 00       	call   800bcc <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005e:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  800063:	8b 40 48             	mov    0x48(%eax),%eax
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	53                   	push   %ebx
  80006a:	50                   	push   %eax
  80006b:	68 80 1f 80 00       	push   $0x801f80
  800070:	e8 2e 01 00 00       	call   8001a3 <cprintf>
	for (i = 0; i < 5; i++) {
  800075:	83 c3 01             	add    $0x1,%ebx
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	83 fb 05             	cmp    $0x5,%ebx
  80007e:	75 d9                	jne    800059 <umain+0x26>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800080:	a1 04 40 80 00       	mov    0x804004,%eax
  800085:	8b 40 48             	mov    0x48(%eax),%eax
  800088:	83 ec 08             	sub    $0x8,%esp
  80008b:	50                   	push   %eax
  80008c:	68 ac 1f 80 00       	push   $0x801fac
  800091:	e8 0d 01 00 00       	call   8001a3 <cprintf>
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
  8000ad:	e8 f7 0a 00 00       	call   800ba9 <sys_getenvid>
  8000b2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000bf:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c4:	85 db                	test   %ebx,%ebx
  8000c6:	7e 07                	jle    8000cf <libmain+0x31>
		binaryname = argv[0];
  8000c8:	8b 06                	mov    (%esi),%eax
  8000ca:	a3 00 30 80 00       	mov    %eax,0x803000

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
  8000ef:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000f2:	e8 f8 0e 00 00       	call   800fef <close_all>
	sys_env_destroy(0);
  8000f7:	83 ec 0c             	sub    $0xc,%esp
  8000fa:	6a 00                	push   $0x0
  8000fc:	e8 63 0a 00 00       	call   800b64 <sys_env_destroy>
}
  800101:	83 c4 10             	add    $0x10,%esp
  800104:	c9                   	leave  
  800105:	c3                   	ret    

00800106 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800106:	f3 0f 1e fb          	endbr32 
  80010a:	55                   	push   %ebp
  80010b:	89 e5                	mov    %esp,%ebp
  80010d:	53                   	push   %ebx
  80010e:	83 ec 04             	sub    $0x4,%esp
  800111:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800114:	8b 13                	mov    (%ebx),%edx
  800116:	8d 42 01             	lea    0x1(%edx),%eax
  800119:	89 03                	mov    %eax,(%ebx)
  80011b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800122:	3d ff 00 00 00       	cmp    $0xff,%eax
  800127:	74 09                	je     800132 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800129:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80012d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800130:	c9                   	leave  
  800131:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800132:	83 ec 08             	sub    $0x8,%esp
  800135:	68 ff 00 00 00       	push   $0xff
  80013a:	8d 43 08             	lea    0x8(%ebx),%eax
  80013d:	50                   	push   %eax
  80013e:	e8 dc 09 00 00       	call   800b1f <sys_cputs>
		b->idx = 0;
  800143:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	eb db                	jmp    800129 <putch+0x23>

0080014e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014e:	f3 0f 1e fb          	endbr32 
  800152:	55                   	push   %ebp
  800153:	89 e5                	mov    %esp,%ebp
  800155:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80015b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800162:	00 00 00 
	b.cnt = 0;
  800165:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80016c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80016f:	ff 75 0c             	pushl  0xc(%ebp)
  800172:	ff 75 08             	pushl  0x8(%ebp)
  800175:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80017b:	50                   	push   %eax
  80017c:	68 06 01 80 00       	push   $0x800106
  800181:	e8 20 01 00 00       	call   8002a6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800186:	83 c4 08             	add    $0x8,%esp
  800189:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80018f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800195:	50                   	push   %eax
  800196:	e8 84 09 00 00       	call   800b1f <sys_cputs>

	return b.cnt;
}
  80019b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a3:	f3 0f 1e fb          	endbr32 
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ad:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b0:	50                   	push   %eax
  8001b1:	ff 75 08             	pushl  0x8(%ebp)
  8001b4:	e8 95 ff ff ff       	call   80014e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	57                   	push   %edi
  8001bf:	56                   	push   %esi
  8001c0:	53                   	push   %ebx
  8001c1:	83 ec 1c             	sub    $0x1c,%esp
  8001c4:	89 c7                	mov    %eax,%edi
  8001c6:	89 d6                	mov    %edx,%esi
  8001c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ce:	89 d1                	mov    %edx,%ecx
  8001d0:	89 c2                	mov    %eax,%edx
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001db:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001e8:	39 c2                	cmp    %eax,%edx
  8001ea:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001ed:	72 3e                	jb     80022d <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	ff 75 18             	pushl  0x18(%ebp)
  8001f5:	83 eb 01             	sub    $0x1,%ebx
  8001f8:	53                   	push   %ebx
  8001f9:	50                   	push   %eax
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800200:	ff 75 e0             	pushl  -0x20(%ebp)
  800203:	ff 75 dc             	pushl  -0x24(%ebp)
  800206:	ff 75 d8             	pushl  -0x28(%ebp)
  800209:	e8 e2 1a 00 00       	call   801cf0 <__udivdi3>
  80020e:	83 c4 18             	add    $0x18,%esp
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	89 f2                	mov    %esi,%edx
  800215:	89 f8                	mov    %edi,%eax
  800217:	e8 9f ff ff ff       	call   8001bb <printnum>
  80021c:	83 c4 20             	add    $0x20,%esp
  80021f:	eb 13                	jmp    800234 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800221:	83 ec 08             	sub    $0x8,%esp
  800224:	56                   	push   %esi
  800225:	ff 75 18             	pushl  0x18(%ebp)
  800228:	ff d7                	call   *%edi
  80022a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80022d:	83 eb 01             	sub    $0x1,%ebx
  800230:	85 db                	test   %ebx,%ebx
  800232:	7f ed                	jg     800221 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	56                   	push   %esi
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023e:	ff 75 e0             	pushl  -0x20(%ebp)
  800241:	ff 75 dc             	pushl  -0x24(%ebp)
  800244:	ff 75 d8             	pushl  -0x28(%ebp)
  800247:	e8 b4 1b 00 00       	call   801e00 <__umoddi3>
  80024c:	83 c4 14             	add    $0x14,%esp
  80024f:	0f be 80 d5 1f 80 00 	movsbl 0x801fd5(%eax),%eax
  800256:	50                   	push   %eax
  800257:	ff d7                	call   *%edi
}
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025f:	5b                   	pop    %ebx
  800260:	5e                   	pop    %esi
  800261:	5f                   	pop    %edi
  800262:	5d                   	pop    %ebp
  800263:	c3                   	ret    

00800264 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800264:	f3 0f 1e fb          	endbr32 
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80026e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800272:	8b 10                	mov    (%eax),%edx
  800274:	3b 50 04             	cmp    0x4(%eax),%edx
  800277:	73 0a                	jae    800283 <sprintputch+0x1f>
		*b->buf++ = ch;
  800279:	8d 4a 01             	lea    0x1(%edx),%ecx
  80027c:	89 08                	mov    %ecx,(%eax)
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	88 02                	mov    %al,(%edx)
}
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    

00800285 <printfmt>:
{
  800285:	f3 0f 1e fb          	endbr32 
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80028f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800292:	50                   	push   %eax
  800293:	ff 75 10             	pushl  0x10(%ebp)
  800296:	ff 75 0c             	pushl  0xc(%ebp)
  800299:	ff 75 08             	pushl  0x8(%ebp)
  80029c:	e8 05 00 00 00       	call   8002a6 <vprintfmt>
}
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <vprintfmt>:
{
  8002a6:	f3 0f 1e fb          	endbr32 
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	57                   	push   %edi
  8002ae:	56                   	push   %esi
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 3c             	sub    $0x3c,%esp
  8002b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002bc:	e9 8e 03 00 00       	jmp    80064f <vprintfmt+0x3a9>
		padc = ' ';
  8002c1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002c5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002cc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002da:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002df:	8d 47 01             	lea    0x1(%edi),%eax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e5:	0f b6 17             	movzbl (%edi),%edx
  8002e8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002eb:	3c 55                	cmp    $0x55,%al
  8002ed:	0f 87 df 03 00 00    	ja     8006d2 <vprintfmt+0x42c>
  8002f3:	0f b6 c0             	movzbl %al,%eax
  8002f6:	3e ff 24 85 20 21 80 	notrack jmp *0x802120(,%eax,4)
  8002fd:	00 
  8002fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800301:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800305:	eb d8                	jmp    8002df <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800307:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80030a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80030e:	eb cf                	jmp    8002df <vprintfmt+0x39>
  800310:	0f b6 d2             	movzbl %dl,%edx
  800313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80031e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800321:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800325:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800328:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80032b:	83 f9 09             	cmp    $0x9,%ecx
  80032e:	77 55                	ja     800385 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800330:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800333:	eb e9                	jmp    80031e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800335:	8b 45 14             	mov    0x14(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033d:	8b 45 14             	mov    0x14(%ebp),%eax
  800340:	8d 40 04             	lea    0x4(%eax),%eax
  800343:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800346:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800349:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80034d:	79 90                	jns    8002df <vprintfmt+0x39>
				width = precision, precision = -1;
  80034f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800352:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800355:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80035c:	eb 81                	jmp    8002df <vprintfmt+0x39>
  80035e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800361:	85 c0                	test   %eax,%eax
  800363:	ba 00 00 00 00       	mov    $0x0,%edx
  800368:	0f 49 d0             	cmovns %eax,%edx
  80036b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800371:	e9 69 ff ff ff       	jmp    8002df <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800379:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800380:	e9 5a ff ff ff       	jmp    8002df <vprintfmt+0x39>
  800385:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800388:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038b:	eb bc                	jmp    800349 <vprintfmt+0xa3>
			lflag++;
  80038d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800393:	e9 47 ff ff ff       	jmp    8002df <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800398:	8b 45 14             	mov    0x14(%ebp),%eax
  80039b:	8d 78 04             	lea    0x4(%eax),%edi
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	53                   	push   %ebx
  8003a2:	ff 30                	pushl  (%eax)
  8003a4:	ff d6                	call   *%esi
			break;
  8003a6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ac:	e9 9b 02 00 00       	jmp    80064c <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b4:	8d 78 04             	lea    0x4(%eax),%edi
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	99                   	cltd   
  8003ba:	31 d0                	xor    %edx,%eax
  8003bc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003be:	83 f8 0f             	cmp    $0xf,%eax
  8003c1:	7f 23                	jg     8003e6 <vprintfmt+0x140>
  8003c3:	8b 14 85 80 22 80 00 	mov    0x802280(,%eax,4),%edx
  8003ca:	85 d2                	test   %edx,%edx
  8003cc:	74 18                	je     8003e6 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003ce:	52                   	push   %edx
  8003cf:	68 b1 23 80 00       	push   $0x8023b1
  8003d4:	53                   	push   %ebx
  8003d5:	56                   	push   %esi
  8003d6:	e8 aa fe ff ff       	call   800285 <printfmt>
  8003db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003de:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e1:	e9 66 02 00 00       	jmp    80064c <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003e6:	50                   	push   %eax
  8003e7:	68 ed 1f 80 00       	push   $0x801fed
  8003ec:	53                   	push   %ebx
  8003ed:	56                   	push   %esi
  8003ee:	e8 92 fe ff ff       	call   800285 <printfmt>
  8003f3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f9:	e9 4e 02 00 00       	jmp    80064c <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	83 c0 04             	add    $0x4,%eax
  800404:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800407:	8b 45 14             	mov    0x14(%ebp),%eax
  80040a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80040c:	85 d2                	test   %edx,%edx
  80040e:	b8 e6 1f 80 00       	mov    $0x801fe6,%eax
  800413:	0f 45 c2             	cmovne %edx,%eax
  800416:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800419:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041d:	7e 06                	jle    800425 <vprintfmt+0x17f>
  80041f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800423:	75 0d                	jne    800432 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800425:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800428:	89 c7                	mov    %eax,%edi
  80042a:	03 45 e0             	add    -0x20(%ebp),%eax
  80042d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800430:	eb 55                	jmp    800487 <vprintfmt+0x1e1>
  800432:	83 ec 08             	sub    $0x8,%esp
  800435:	ff 75 d8             	pushl  -0x28(%ebp)
  800438:	ff 75 cc             	pushl  -0x34(%ebp)
  80043b:	e8 46 03 00 00       	call   800786 <strnlen>
  800440:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800443:	29 c2                	sub    %eax,%edx
  800445:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80044d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800451:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800454:	85 ff                	test   %edi,%edi
  800456:	7e 11                	jle    800469 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	53                   	push   %ebx
  80045c:	ff 75 e0             	pushl  -0x20(%ebp)
  80045f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800461:	83 ef 01             	sub    $0x1,%edi
  800464:	83 c4 10             	add    $0x10,%esp
  800467:	eb eb                	jmp    800454 <vprintfmt+0x1ae>
  800469:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80046c:	85 d2                	test   %edx,%edx
  80046e:	b8 00 00 00 00       	mov    $0x0,%eax
  800473:	0f 49 c2             	cmovns %edx,%eax
  800476:	29 c2                	sub    %eax,%edx
  800478:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80047b:	eb a8                	jmp    800425 <vprintfmt+0x17f>
					putch(ch, putdat);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	53                   	push   %ebx
  800481:	52                   	push   %edx
  800482:	ff d6                	call   *%esi
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80048c:	83 c7 01             	add    $0x1,%edi
  80048f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800493:	0f be d0             	movsbl %al,%edx
  800496:	85 d2                	test   %edx,%edx
  800498:	74 4b                	je     8004e5 <vprintfmt+0x23f>
  80049a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80049e:	78 06                	js     8004a6 <vprintfmt+0x200>
  8004a0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004a4:	78 1e                	js     8004c4 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004aa:	74 d1                	je     80047d <vprintfmt+0x1d7>
  8004ac:	0f be c0             	movsbl %al,%eax
  8004af:	83 e8 20             	sub    $0x20,%eax
  8004b2:	83 f8 5e             	cmp    $0x5e,%eax
  8004b5:	76 c6                	jbe    80047d <vprintfmt+0x1d7>
					putch('?', putdat);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	53                   	push   %ebx
  8004bb:	6a 3f                	push   $0x3f
  8004bd:	ff d6                	call   *%esi
  8004bf:	83 c4 10             	add    $0x10,%esp
  8004c2:	eb c3                	jmp    800487 <vprintfmt+0x1e1>
  8004c4:	89 cf                	mov    %ecx,%edi
  8004c6:	eb 0e                	jmp    8004d6 <vprintfmt+0x230>
				putch(' ', putdat);
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	53                   	push   %ebx
  8004cc:	6a 20                	push   $0x20
  8004ce:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d0:	83 ef 01             	sub    $0x1,%edi
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	85 ff                	test   %edi,%edi
  8004d8:	7f ee                	jg     8004c8 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e0:	e9 67 01 00 00       	jmp    80064c <vprintfmt+0x3a6>
  8004e5:	89 cf                	mov    %ecx,%edi
  8004e7:	eb ed                	jmp    8004d6 <vprintfmt+0x230>
	if (lflag >= 2)
  8004e9:	83 f9 01             	cmp    $0x1,%ecx
  8004ec:	7f 1b                	jg     800509 <vprintfmt+0x263>
	else if (lflag)
  8004ee:	85 c9                	test   %ecx,%ecx
  8004f0:	74 63                	je     800555 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fa:	99                   	cltd   
  8004fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800501:	8d 40 04             	lea    0x4(%eax),%eax
  800504:	89 45 14             	mov    %eax,0x14(%ebp)
  800507:	eb 17                	jmp    800520 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8b 50 04             	mov    0x4(%eax),%edx
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800514:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8d 40 08             	lea    0x8(%eax),%eax
  80051d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800520:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800523:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800526:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80052b:	85 c9                	test   %ecx,%ecx
  80052d:	0f 89 ff 00 00 00    	jns    800632 <vprintfmt+0x38c>
				putch('-', putdat);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	6a 2d                	push   $0x2d
  800539:	ff d6                	call   *%esi
				num = -(long long) num;
  80053b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800541:	f7 da                	neg    %edx
  800543:	83 d1 00             	adc    $0x0,%ecx
  800546:	f7 d9                	neg    %ecx
  800548:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800550:	e9 dd 00 00 00       	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055d:	99                   	cltd   
  80055e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8d 40 04             	lea    0x4(%eax),%eax
  800567:	89 45 14             	mov    %eax,0x14(%ebp)
  80056a:	eb b4                	jmp    800520 <vprintfmt+0x27a>
	if (lflag >= 2)
  80056c:	83 f9 01             	cmp    $0x1,%ecx
  80056f:	7f 1e                	jg     80058f <vprintfmt+0x2e9>
	else if (lflag)
  800571:	85 c9                	test   %ecx,%ecx
  800573:	74 32                	je     8005a7 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8b 10                	mov    (%eax),%edx
  80057a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800585:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80058a:	e9 a3 00 00 00       	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8b 10                	mov    (%eax),%edx
  800594:	8b 48 04             	mov    0x4(%eax),%ecx
  800597:	8d 40 08             	lea    0x8(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005a2:	e9 8b 00 00 00       	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 10                	mov    (%eax),%edx
  8005ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b1:	8d 40 04             	lea    0x4(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005bc:	eb 74                	jmp    800632 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005be:	83 f9 01             	cmp    $0x1,%ecx
  8005c1:	7f 1b                	jg     8005de <vprintfmt+0x338>
	else if (lflag)
  8005c3:	85 c9                	test   %ecx,%ecx
  8005c5:	74 2c                	je     8005f3 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8b 10                	mov    (%eax),%edx
  8005cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d1:	8d 40 04             	lea    0x4(%eax),%eax
  8005d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005dc:	eb 54                	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e6:	8d 40 08             	lea    0x8(%eax),%eax
  8005e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ec:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005f1:	eb 3f                	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 10                	mov    (%eax),%edx
  8005f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800603:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800608:	eb 28                	jmp    800632 <vprintfmt+0x38c>
			putch('0', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	53                   	push   %ebx
  80060e:	6a 30                	push   $0x30
  800610:	ff d6                	call   *%esi
			putch('x', putdat);
  800612:	83 c4 08             	add    $0x8,%esp
  800615:	53                   	push   %ebx
  800616:	6a 78                	push   $0x78
  800618:	ff d6                	call   *%esi
			num = (unsigned long long)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 10                	mov    (%eax),%edx
  80061f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800624:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80062d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800632:	83 ec 0c             	sub    $0xc,%esp
  800635:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800639:	57                   	push   %edi
  80063a:	ff 75 e0             	pushl  -0x20(%ebp)
  80063d:	50                   	push   %eax
  80063e:	51                   	push   %ecx
  80063f:	52                   	push   %edx
  800640:	89 da                	mov    %ebx,%edx
  800642:	89 f0                	mov    %esi,%eax
  800644:	e8 72 fb ff ff       	call   8001bb <printnum>
			break;
  800649:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80064c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064f:	83 c7 01             	add    $0x1,%edi
  800652:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800656:	83 f8 25             	cmp    $0x25,%eax
  800659:	0f 84 62 fc ff ff    	je     8002c1 <vprintfmt+0x1b>
			if (ch == '\0')
  80065f:	85 c0                	test   %eax,%eax
  800661:	0f 84 8b 00 00 00    	je     8006f2 <vprintfmt+0x44c>
			putch(ch, putdat);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	53                   	push   %ebx
  80066b:	50                   	push   %eax
  80066c:	ff d6                	call   *%esi
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	eb dc                	jmp    80064f <vprintfmt+0x3a9>
	if (lflag >= 2)
  800673:	83 f9 01             	cmp    $0x1,%ecx
  800676:	7f 1b                	jg     800693 <vprintfmt+0x3ed>
	else if (lflag)
  800678:	85 c9                	test   %ecx,%ecx
  80067a:	74 2c                	je     8006a8 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 10                	mov    (%eax),%edx
  800681:	b9 00 00 00 00       	mov    $0x0,%ecx
  800686:	8d 40 04             	lea    0x4(%eax),%eax
  800689:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800691:	eb 9f                	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 10                	mov    (%eax),%edx
  800698:	8b 48 04             	mov    0x4(%eax),%ecx
  80069b:	8d 40 08             	lea    0x8(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006a6:	eb 8a                	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 10                	mov    (%eax),%edx
  8006ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006bd:	e9 70 ff ff ff       	jmp    800632 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	53                   	push   %ebx
  8006c6:	6a 25                	push   $0x25
  8006c8:	ff d6                	call   *%esi
			break;
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	e9 7a ff ff ff       	jmp    80064c <vprintfmt+0x3a6>
			putch('%', putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	6a 25                	push   $0x25
  8006d8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006da:	83 c4 10             	add    $0x10,%esp
  8006dd:	89 f8                	mov    %edi,%eax
  8006df:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006e3:	74 05                	je     8006ea <vprintfmt+0x444>
  8006e5:	83 e8 01             	sub    $0x1,%eax
  8006e8:	eb f5                	jmp    8006df <vprintfmt+0x439>
  8006ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ed:	e9 5a ff ff ff       	jmp    80064c <vprintfmt+0x3a6>
}
  8006f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f5:	5b                   	pop    %ebx
  8006f6:	5e                   	pop    %esi
  8006f7:	5f                   	pop    %edi
  8006f8:	5d                   	pop    %ebp
  8006f9:	c3                   	ret    

008006fa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006fa:	f3 0f 1e fb          	endbr32 
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	83 ec 18             	sub    $0x18,%esp
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80070a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80070d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800711:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800714:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80071b:	85 c0                	test   %eax,%eax
  80071d:	74 26                	je     800745 <vsnprintf+0x4b>
  80071f:	85 d2                	test   %edx,%edx
  800721:	7e 22                	jle    800745 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800723:	ff 75 14             	pushl  0x14(%ebp)
  800726:	ff 75 10             	pushl  0x10(%ebp)
  800729:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80072c:	50                   	push   %eax
  80072d:	68 64 02 80 00       	push   $0x800264
  800732:	e8 6f fb ff ff       	call   8002a6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800737:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80073a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80073d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800740:	83 c4 10             	add    $0x10,%esp
}
  800743:	c9                   	leave  
  800744:	c3                   	ret    
		return -E_INVAL;
  800745:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80074a:	eb f7                	jmp    800743 <vsnprintf+0x49>

0080074c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80074c:	f3 0f 1e fb          	endbr32 
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800756:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800759:	50                   	push   %eax
  80075a:	ff 75 10             	pushl  0x10(%ebp)
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	ff 75 08             	pushl  0x8(%ebp)
  800763:	e8 92 ff ff ff       	call   8006fa <vsnprintf>
	va_end(ap);

	return rc;
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80076a:	f3 0f 1e fb          	endbr32 
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
  800771:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800774:	b8 00 00 00 00       	mov    $0x0,%eax
  800779:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80077d:	74 05                	je     800784 <strlen+0x1a>
		n++;
  80077f:	83 c0 01             	add    $0x1,%eax
  800782:	eb f5                	jmp    800779 <strlen+0xf>
	return n;
}
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800786:	f3 0f 1e fb          	endbr32 
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800790:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800793:	b8 00 00 00 00       	mov    $0x0,%eax
  800798:	39 d0                	cmp    %edx,%eax
  80079a:	74 0d                	je     8007a9 <strnlen+0x23>
  80079c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007a0:	74 05                	je     8007a7 <strnlen+0x21>
		n++;
  8007a2:	83 c0 01             	add    $0x1,%eax
  8007a5:	eb f1                	jmp    800798 <strnlen+0x12>
  8007a7:	89 c2                	mov    %eax,%edx
	return n;
}
  8007a9:	89 d0                	mov    %edx,%eax
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007ad:	f3 0f 1e fb          	endbr32 
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
  8007b4:	53                   	push   %ebx
  8007b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007c7:	83 c0 01             	add    $0x1,%eax
  8007ca:	84 d2                	test   %dl,%dl
  8007cc:	75 f2                	jne    8007c0 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007ce:	89 c8                	mov    %ecx,%eax
  8007d0:	5b                   	pop    %ebx
  8007d1:	5d                   	pop    %ebp
  8007d2:	c3                   	ret    

008007d3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007d3:	f3 0f 1e fb          	endbr32 
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	53                   	push   %ebx
  8007db:	83 ec 10             	sub    $0x10,%esp
  8007de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e1:	53                   	push   %ebx
  8007e2:	e8 83 ff ff ff       	call   80076a <strlen>
  8007e7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	01 d8                	add    %ebx,%eax
  8007ef:	50                   	push   %eax
  8007f0:	e8 b8 ff ff ff       	call   8007ad <strcpy>
	return dst;
}
  8007f5:	89 d8                	mov    %ebx,%eax
  8007f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007fa:	c9                   	leave  
  8007fb:	c3                   	ret    

008007fc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007fc:	f3 0f 1e fb          	endbr32 
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	56                   	push   %esi
  800804:	53                   	push   %ebx
  800805:	8b 75 08             	mov    0x8(%ebp),%esi
  800808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080b:	89 f3                	mov    %esi,%ebx
  80080d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800810:	89 f0                	mov    %esi,%eax
  800812:	39 d8                	cmp    %ebx,%eax
  800814:	74 11                	je     800827 <strncpy+0x2b>
		*dst++ = *src;
  800816:	83 c0 01             	add    $0x1,%eax
  800819:	0f b6 0a             	movzbl (%edx),%ecx
  80081c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80081f:	80 f9 01             	cmp    $0x1,%cl
  800822:	83 da ff             	sbb    $0xffffffff,%edx
  800825:	eb eb                	jmp    800812 <strncpy+0x16>
	}
	return ret;
}
  800827:	89 f0                	mov    %esi,%eax
  800829:	5b                   	pop    %ebx
  80082a:	5e                   	pop    %esi
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80082d:	f3 0f 1e fb          	endbr32 
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	56                   	push   %esi
  800835:	53                   	push   %ebx
  800836:	8b 75 08             	mov    0x8(%ebp),%esi
  800839:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083c:	8b 55 10             	mov    0x10(%ebp),%edx
  80083f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800841:	85 d2                	test   %edx,%edx
  800843:	74 21                	je     800866 <strlcpy+0x39>
  800845:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800849:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80084b:	39 c2                	cmp    %eax,%edx
  80084d:	74 14                	je     800863 <strlcpy+0x36>
  80084f:	0f b6 19             	movzbl (%ecx),%ebx
  800852:	84 db                	test   %bl,%bl
  800854:	74 0b                	je     800861 <strlcpy+0x34>
			*dst++ = *src++;
  800856:	83 c1 01             	add    $0x1,%ecx
  800859:	83 c2 01             	add    $0x1,%edx
  80085c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80085f:	eb ea                	jmp    80084b <strlcpy+0x1e>
  800861:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800863:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800866:	29 f0                	sub    %esi,%eax
}
  800868:	5b                   	pop    %ebx
  800869:	5e                   	pop    %esi
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    

0080086c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80086c:	f3 0f 1e fb          	endbr32 
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800876:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800879:	0f b6 01             	movzbl (%ecx),%eax
  80087c:	84 c0                	test   %al,%al
  80087e:	74 0c                	je     80088c <strcmp+0x20>
  800880:	3a 02                	cmp    (%edx),%al
  800882:	75 08                	jne    80088c <strcmp+0x20>
		p++, q++;
  800884:	83 c1 01             	add    $0x1,%ecx
  800887:	83 c2 01             	add    $0x1,%edx
  80088a:	eb ed                	jmp    800879 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80088c:	0f b6 c0             	movzbl %al,%eax
  80088f:	0f b6 12             	movzbl (%edx),%edx
  800892:	29 d0                	sub    %edx,%eax
}
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800896:	f3 0f 1e fb          	endbr32 
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	53                   	push   %ebx
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	89 c3                	mov    %eax,%ebx
  8008a6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008a9:	eb 06                	jmp    8008b1 <strncmp+0x1b>
		n--, p++, q++;
  8008ab:	83 c0 01             	add    $0x1,%eax
  8008ae:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008b1:	39 d8                	cmp    %ebx,%eax
  8008b3:	74 16                	je     8008cb <strncmp+0x35>
  8008b5:	0f b6 08             	movzbl (%eax),%ecx
  8008b8:	84 c9                	test   %cl,%cl
  8008ba:	74 04                	je     8008c0 <strncmp+0x2a>
  8008bc:	3a 0a                	cmp    (%edx),%cl
  8008be:	74 eb                	je     8008ab <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c0:	0f b6 00             	movzbl (%eax),%eax
  8008c3:	0f b6 12             	movzbl (%edx),%edx
  8008c6:	29 d0                	sub    %edx,%eax
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    
		return 0;
  8008cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d0:	eb f6                	jmp    8008c8 <strncmp+0x32>

008008d2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d2:	f3 0f 1e fb          	endbr32 
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e0:	0f b6 10             	movzbl (%eax),%edx
  8008e3:	84 d2                	test   %dl,%dl
  8008e5:	74 09                	je     8008f0 <strchr+0x1e>
		if (*s == c)
  8008e7:	38 ca                	cmp    %cl,%dl
  8008e9:	74 0a                	je     8008f5 <strchr+0x23>
	for (; *s; s++)
  8008eb:	83 c0 01             	add    $0x1,%eax
  8008ee:	eb f0                	jmp    8008e0 <strchr+0xe>
			return (char *) s;
	return 0;
  8008f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008f7:	f3 0f 1e fb          	endbr32 
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800905:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800908:	38 ca                	cmp    %cl,%dl
  80090a:	74 09                	je     800915 <strfind+0x1e>
  80090c:	84 d2                	test   %dl,%dl
  80090e:	74 05                	je     800915 <strfind+0x1e>
	for (; *s; s++)
  800910:	83 c0 01             	add    $0x1,%eax
  800913:	eb f0                	jmp    800905 <strfind+0xe>
			break;
	return (char *) s;
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800917:	f3 0f 1e fb          	endbr32 
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	57                   	push   %edi
  80091f:	56                   	push   %esi
  800920:	53                   	push   %ebx
  800921:	8b 7d 08             	mov    0x8(%ebp),%edi
  800924:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800927:	85 c9                	test   %ecx,%ecx
  800929:	74 31                	je     80095c <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80092b:	89 f8                	mov    %edi,%eax
  80092d:	09 c8                	or     %ecx,%eax
  80092f:	a8 03                	test   $0x3,%al
  800931:	75 23                	jne    800956 <memset+0x3f>
		c &= 0xFF;
  800933:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800937:	89 d3                	mov    %edx,%ebx
  800939:	c1 e3 08             	shl    $0x8,%ebx
  80093c:	89 d0                	mov    %edx,%eax
  80093e:	c1 e0 18             	shl    $0x18,%eax
  800941:	89 d6                	mov    %edx,%esi
  800943:	c1 e6 10             	shl    $0x10,%esi
  800946:	09 f0                	or     %esi,%eax
  800948:	09 c2                	or     %eax,%edx
  80094a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80094c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80094f:	89 d0                	mov    %edx,%eax
  800951:	fc                   	cld    
  800952:	f3 ab                	rep stos %eax,%es:(%edi)
  800954:	eb 06                	jmp    80095c <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800956:	8b 45 0c             	mov    0xc(%ebp),%eax
  800959:	fc                   	cld    
  80095a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095c:	89 f8                	mov    %edi,%eax
  80095e:	5b                   	pop    %ebx
  80095f:	5e                   	pop    %esi
  800960:	5f                   	pop    %edi
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800963:	f3 0f 1e fb          	endbr32 
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	57                   	push   %edi
  80096b:	56                   	push   %esi
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800972:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800975:	39 c6                	cmp    %eax,%esi
  800977:	73 32                	jae    8009ab <memmove+0x48>
  800979:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80097c:	39 c2                	cmp    %eax,%edx
  80097e:	76 2b                	jbe    8009ab <memmove+0x48>
		s += n;
		d += n;
  800980:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800983:	89 fe                	mov    %edi,%esi
  800985:	09 ce                	or     %ecx,%esi
  800987:	09 d6                	or     %edx,%esi
  800989:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80098f:	75 0e                	jne    80099f <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800991:	83 ef 04             	sub    $0x4,%edi
  800994:	8d 72 fc             	lea    -0x4(%edx),%esi
  800997:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80099a:	fd                   	std    
  80099b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099d:	eb 09                	jmp    8009a8 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80099f:	83 ef 01             	sub    $0x1,%edi
  8009a2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009a5:	fd                   	std    
  8009a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a8:	fc                   	cld    
  8009a9:	eb 1a                	jmp    8009c5 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ab:	89 c2                	mov    %eax,%edx
  8009ad:	09 ca                	or     %ecx,%edx
  8009af:	09 f2                	or     %esi,%edx
  8009b1:	f6 c2 03             	test   $0x3,%dl
  8009b4:	75 0a                	jne    8009c0 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009b9:	89 c7                	mov    %eax,%edi
  8009bb:	fc                   	cld    
  8009bc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009be:	eb 05                	jmp    8009c5 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009c0:	89 c7                	mov    %eax,%edi
  8009c2:	fc                   	cld    
  8009c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c5:	5e                   	pop    %esi
  8009c6:	5f                   	pop    %edi
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009c9:	f3 0f 1e fb          	endbr32 
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009d3:	ff 75 10             	pushl  0x10(%ebp)
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 82 ff ff ff       	call   800963 <memmove>
}
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009e3:	f3 0f 1e fb          	endbr32 
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	56                   	push   %esi
  8009eb:	53                   	push   %ebx
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f2:	89 c6                	mov    %eax,%esi
  8009f4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009f7:	39 f0                	cmp    %esi,%eax
  8009f9:	74 1c                	je     800a17 <memcmp+0x34>
		if (*s1 != *s2)
  8009fb:	0f b6 08             	movzbl (%eax),%ecx
  8009fe:	0f b6 1a             	movzbl (%edx),%ebx
  800a01:	38 d9                	cmp    %bl,%cl
  800a03:	75 08                	jne    800a0d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a05:	83 c0 01             	add    $0x1,%eax
  800a08:	83 c2 01             	add    $0x1,%edx
  800a0b:	eb ea                	jmp    8009f7 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a0d:	0f b6 c1             	movzbl %cl,%eax
  800a10:	0f b6 db             	movzbl %bl,%ebx
  800a13:	29 d8                	sub    %ebx,%eax
  800a15:	eb 05                	jmp    800a1c <memcmp+0x39>
	}

	return 0;
  800a17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1c:	5b                   	pop    %ebx
  800a1d:	5e                   	pop    %esi
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a20:	f3 0f 1e fb          	endbr32 
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2d:	89 c2                	mov    %eax,%edx
  800a2f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a32:	39 d0                	cmp    %edx,%eax
  800a34:	73 09                	jae    800a3f <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a36:	38 08                	cmp    %cl,(%eax)
  800a38:	74 05                	je     800a3f <memfind+0x1f>
	for (; s < ends; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	eb f3                	jmp    800a32 <memfind+0x12>
			break;
	return (void *) s;
}
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a41:	f3 0f 1e fb          	endbr32 
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	57                   	push   %edi
  800a49:	56                   	push   %esi
  800a4a:	53                   	push   %ebx
  800a4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a51:	eb 03                	jmp    800a56 <strtol+0x15>
		s++;
  800a53:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a56:	0f b6 01             	movzbl (%ecx),%eax
  800a59:	3c 20                	cmp    $0x20,%al
  800a5b:	74 f6                	je     800a53 <strtol+0x12>
  800a5d:	3c 09                	cmp    $0x9,%al
  800a5f:	74 f2                	je     800a53 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a61:	3c 2b                	cmp    $0x2b,%al
  800a63:	74 2a                	je     800a8f <strtol+0x4e>
	int neg = 0;
  800a65:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a6a:	3c 2d                	cmp    $0x2d,%al
  800a6c:	74 2b                	je     800a99 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a6e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a74:	75 0f                	jne    800a85 <strtol+0x44>
  800a76:	80 39 30             	cmpb   $0x30,(%ecx)
  800a79:	74 28                	je     800aa3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a7b:	85 db                	test   %ebx,%ebx
  800a7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a82:	0f 44 d8             	cmove  %eax,%ebx
  800a85:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a8d:	eb 46                	jmp    800ad5 <strtol+0x94>
		s++;
  800a8f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a92:	bf 00 00 00 00       	mov    $0x0,%edi
  800a97:	eb d5                	jmp    800a6e <strtol+0x2d>
		s++, neg = 1;
  800a99:	83 c1 01             	add    $0x1,%ecx
  800a9c:	bf 01 00 00 00       	mov    $0x1,%edi
  800aa1:	eb cb                	jmp    800a6e <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aa3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aa7:	74 0e                	je     800ab7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aa9:	85 db                	test   %ebx,%ebx
  800aab:	75 d8                	jne    800a85 <strtol+0x44>
		s++, base = 8;
  800aad:	83 c1 01             	add    $0x1,%ecx
  800ab0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ab5:	eb ce                	jmp    800a85 <strtol+0x44>
		s += 2, base = 16;
  800ab7:	83 c1 02             	add    $0x2,%ecx
  800aba:	bb 10 00 00 00       	mov    $0x10,%ebx
  800abf:	eb c4                	jmp    800a85 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ac1:	0f be d2             	movsbl %dl,%edx
  800ac4:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ac7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aca:	7d 3a                	jge    800b06 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800acc:	83 c1 01             	add    $0x1,%ecx
  800acf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ad3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad5:	0f b6 11             	movzbl (%ecx),%edx
  800ad8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800adb:	89 f3                	mov    %esi,%ebx
  800add:	80 fb 09             	cmp    $0x9,%bl
  800ae0:	76 df                	jbe    800ac1 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ae2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ae5:	89 f3                	mov    %esi,%ebx
  800ae7:	80 fb 19             	cmp    $0x19,%bl
  800aea:	77 08                	ja     800af4 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aec:	0f be d2             	movsbl %dl,%edx
  800aef:	83 ea 57             	sub    $0x57,%edx
  800af2:	eb d3                	jmp    800ac7 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800af4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800af7:	89 f3                	mov    %esi,%ebx
  800af9:	80 fb 19             	cmp    $0x19,%bl
  800afc:	77 08                	ja     800b06 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800afe:	0f be d2             	movsbl %dl,%edx
  800b01:	83 ea 37             	sub    $0x37,%edx
  800b04:	eb c1                	jmp    800ac7 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0a:	74 05                	je     800b11 <strtol+0xd0>
		*endptr = (char *) s;
  800b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b0f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b11:	89 c2                	mov    %eax,%edx
  800b13:	f7 da                	neg    %edx
  800b15:	85 ff                	test   %edi,%edi
  800b17:	0f 45 c2             	cmovne %edx,%eax
}
  800b1a:	5b                   	pop    %ebx
  800b1b:	5e                   	pop    %esi
  800b1c:	5f                   	pop    %edi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b1f:	f3 0f 1e fb          	endbr32 
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b29:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b34:	89 c3                	mov    %eax,%ebx
  800b36:	89 c7                	mov    %eax,%edi
  800b38:	89 c6                	mov    %eax,%esi
  800b3a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5f                   	pop    %edi
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b41:	f3 0f 1e fb          	endbr32 
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	57                   	push   %edi
  800b49:	56                   	push   %esi
  800b4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b50:	b8 01 00 00 00       	mov    $0x1,%eax
  800b55:	89 d1                	mov    %edx,%ecx
  800b57:	89 d3                	mov    %edx,%ebx
  800b59:	89 d7                	mov    %edx,%edi
  800b5b:	89 d6                	mov    %edx,%esi
  800b5d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b5f:	5b                   	pop    %ebx
  800b60:	5e                   	pop    %esi
  800b61:	5f                   	pop    %edi
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    

00800b64 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b64:	f3 0f 1e fb          	endbr32 
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	57                   	push   %edi
  800b6c:	56                   	push   %esi
  800b6d:	53                   	push   %ebx
  800b6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b71:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b76:	8b 55 08             	mov    0x8(%ebp),%edx
  800b79:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7e:	89 cb                	mov    %ecx,%ebx
  800b80:	89 cf                	mov    %ecx,%edi
  800b82:	89 ce                	mov    %ecx,%esi
  800b84:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b86:	85 c0                	test   %eax,%eax
  800b88:	7f 08                	jg     800b92 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b92:	83 ec 0c             	sub    $0xc,%esp
  800b95:	50                   	push   %eax
  800b96:	6a 03                	push   $0x3
  800b98:	68 df 22 80 00       	push   $0x8022df
  800b9d:	6a 23                	push   $0x23
  800b9f:	68 fc 22 80 00       	push   $0x8022fc
  800ba4:	e8 9c 0f 00 00       	call   801b45 <_panic>

00800ba9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ba9:	f3 0f 1e fb          	endbr32 
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	57                   	push   %edi
  800bb1:	56                   	push   %esi
  800bb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb8:	b8 02 00 00 00       	mov    $0x2,%eax
  800bbd:	89 d1                	mov    %edx,%ecx
  800bbf:	89 d3                	mov    %edx,%ebx
  800bc1:	89 d7                	mov    %edx,%edi
  800bc3:	89 d6                	mov    %edx,%esi
  800bc5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <sys_yield>:

void
sys_yield(void)
{
  800bcc:	f3 0f 1e fb          	endbr32 
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	57                   	push   %edi
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800be0:	89 d1                	mov    %edx,%ecx
  800be2:	89 d3                	mov    %edx,%ebx
  800be4:	89 d7                	mov    %edx,%edi
  800be6:	89 d6                	mov    %edx,%esi
  800be8:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bea:	5b                   	pop    %ebx
  800beb:	5e                   	pop    %esi
  800bec:	5f                   	pop    %edi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bef:	f3 0f 1e fb          	endbr32 
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfc:	be 00 00 00 00       	mov    $0x0,%esi
  800c01:	8b 55 08             	mov    0x8(%ebp),%edx
  800c04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c07:	b8 04 00 00 00       	mov    $0x4,%eax
  800c0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c0f:	89 f7                	mov    %esi,%edi
  800c11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c13:	85 c0                	test   %eax,%eax
  800c15:	7f 08                	jg     800c1f <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1f:	83 ec 0c             	sub    $0xc,%esp
  800c22:	50                   	push   %eax
  800c23:	6a 04                	push   $0x4
  800c25:	68 df 22 80 00       	push   $0x8022df
  800c2a:	6a 23                	push   $0x23
  800c2c:	68 fc 22 80 00       	push   $0x8022fc
  800c31:	e8 0f 0f 00 00       	call   801b45 <_panic>

00800c36 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c36:	f3 0f 1e fb          	endbr32 
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	57                   	push   %edi
  800c3e:	56                   	push   %esi
  800c3f:	53                   	push   %ebx
  800c40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c43:	8b 55 08             	mov    0x8(%ebp),%edx
  800c46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c49:	b8 05 00 00 00       	mov    $0x5,%eax
  800c4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c51:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c54:	8b 75 18             	mov    0x18(%ebp),%esi
  800c57:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c59:	85 c0                	test   %eax,%eax
  800c5b:	7f 08                	jg     800c65 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c65:	83 ec 0c             	sub    $0xc,%esp
  800c68:	50                   	push   %eax
  800c69:	6a 05                	push   $0x5
  800c6b:	68 df 22 80 00       	push   $0x8022df
  800c70:	6a 23                	push   $0x23
  800c72:	68 fc 22 80 00       	push   $0x8022fc
  800c77:	e8 c9 0e 00 00       	call   801b45 <_panic>

00800c7c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c7c:	f3 0f 1e fb          	endbr32 
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	53                   	push   %ebx
  800c86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c94:	b8 06 00 00 00       	mov    $0x6,%eax
  800c99:	89 df                	mov    %ebx,%edi
  800c9b:	89 de                	mov    %ebx,%esi
  800c9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	7f 08                	jg     800cab <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cab:	83 ec 0c             	sub    $0xc,%esp
  800cae:	50                   	push   %eax
  800caf:	6a 06                	push   $0x6
  800cb1:	68 df 22 80 00       	push   $0x8022df
  800cb6:	6a 23                	push   $0x23
  800cb8:	68 fc 22 80 00       	push   $0x8022fc
  800cbd:	e8 83 0e 00 00       	call   801b45 <_panic>

00800cc2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc2:	f3 0f 1e fb          	endbr32 
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
  800ccc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cda:	b8 08 00 00 00       	mov    $0x8,%eax
  800cdf:	89 df                	mov    %ebx,%edi
  800ce1:	89 de                	mov    %ebx,%esi
  800ce3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	7f 08                	jg     800cf1 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf1:	83 ec 0c             	sub    $0xc,%esp
  800cf4:	50                   	push   %eax
  800cf5:	6a 08                	push   $0x8
  800cf7:	68 df 22 80 00       	push   $0x8022df
  800cfc:	6a 23                	push   $0x23
  800cfe:	68 fc 22 80 00       	push   $0x8022fc
  800d03:	e8 3d 0e 00 00       	call   801b45 <_panic>

00800d08 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d08:	f3 0f 1e fb          	endbr32 
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	57                   	push   %edi
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
  800d12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d20:	b8 09 00 00 00       	mov    $0x9,%eax
  800d25:	89 df                	mov    %ebx,%edi
  800d27:	89 de                	mov    %ebx,%esi
  800d29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	7f 08                	jg     800d37 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d37:	83 ec 0c             	sub    $0xc,%esp
  800d3a:	50                   	push   %eax
  800d3b:	6a 09                	push   $0x9
  800d3d:	68 df 22 80 00       	push   $0x8022df
  800d42:	6a 23                	push   $0x23
  800d44:	68 fc 22 80 00       	push   $0x8022fc
  800d49:	e8 f7 0d 00 00       	call   801b45 <_panic>

00800d4e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d4e:	f3 0f 1e fb          	endbr32 
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d60:	8b 55 08             	mov    0x8(%ebp),%edx
  800d63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d66:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d6b:	89 df                	mov    %ebx,%edi
  800d6d:	89 de                	mov    %ebx,%esi
  800d6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d71:	85 c0                	test   %eax,%eax
  800d73:	7f 08                	jg     800d7d <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7d:	83 ec 0c             	sub    $0xc,%esp
  800d80:	50                   	push   %eax
  800d81:	6a 0a                	push   $0xa
  800d83:	68 df 22 80 00       	push   $0x8022df
  800d88:	6a 23                	push   $0x23
  800d8a:	68 fc 22 80 00       	push   $0x8022fc
  800d8f:	e8 b1 0d 00 00       	call   801b45 <_panic>

00800d94 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d94:	f3 0f 1e fb          	endbr32 
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da9:	be 00 00 00 00       	mov    $0x0,%esi
  800dae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dbb:	f3 0f 1e fb          	endbr32 
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	57                   	push   %edi
  800dc3:	56                   	push   %esi
  800dc4:	53                   	push   %ebx
  800dc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dd5:	89 cb                	mov    %ecx,%ebx
  800dd7:	89 cf                	mov    %ecx,%edi
  800dd9:	89 ce                	mov    %ecx,%esi
  800ddb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddd:	85 c0                	test   %eax,%eax
  800ddf:	7f 08                	jg     800de9 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de9:	83 ec 0c             	sub    $0xc,%esp
  800dec:	50                   	push   %eax
  800ded:	6a 0d                	push   $0xd
  800def:	68 df 22 80 00       	push   $0x8022df
  800df4:	6a 23                	push   $0x23
  800df6:	68 fc 22 80 00       	push   $0x8022fc
  800dfb:	e8 45 0d 00 00       	call   801b45 <_panic>

00800e00 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e00:	f3 0f 1e fb          	endbr32 
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	05 00 00 00 30       	add    $0x30000000,%eax
  800e0f:	c1 e8 0c             	shr    $0xc,%eax
}
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e14:	f3 0f 1e fb          	endbr32 
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e28:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e2f:	f3 0f 1e fb          	endbr32 
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e3b:	89 c2                	mov    %eax,%edx
  800e3d:	c1 ea 16             	shr    $0x16,%edx
  800e40:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e47:	f6 c2 01             	test   $0x1,%dl
  800e4a:	74 2d                	je     800e79 <fd_alloc+0x4a>
  800e4c:	89 c2                	mov    %eax,%edx
  800e4e:	c1 ea 0c             	shr    $0xc,%edx
  800e51:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e58:	f6 c2 01             	test   $0x1,%dl
  800e5b:	74 1c                	je     800e79 <fd_alloc+0x4a>
  800e5d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e62:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e67:	75 d2                	jne    800e3b <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e72:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e77:	eb 0a                	jmp    800e83 <fd_alloc+0x54>
			*fd_store = fd;
  800e79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e7c:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    

00800e85 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e85:	f3 0f 1e fb          	endbr32 
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e8f:	83 f8 1f             	cmp    $0x1f,%eax
  800e92:	77 30                	ja     800ec4 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e94:	c1 e0 0c             	shl    $0xc,%eax
  800e97:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e9c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800ea2:	f6 c2 01             	test   $0x1,%dl
  800ea5:	74 24                	je     800ecb <fd_lookup+0x46>
  800ea7:	89 c2                	mov    %eax,%edx
  800ea9:	c1 ea 0c             	shr    $0xc,%edx
  800eac:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eb3:	f6 c2 01             	test   $0x1,%dl
  800eb6:	74 1a                	je     800ed2 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebb:	89 02                	mov    %eax,(%edx)
	return 0;
  800ebd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    
		return -E_INVAL;
  800ec4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec9:	eb f7                	jmp    800ec2 <fd_lookup+0x3d>
		return -E_INVAL;
  800ecb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed0:	eb f0                	jmp    800ec2 <fd_lookup+0x3d>
  800ed2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed7:	eb e9                	jmp    800ec2 <fd_lookup+0x3d>

00800ed9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ed9:	f3 0f 1e fb          	endbr32 
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee6:	ba 88 23 80 00       	mov    $0x802388,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800eeb:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ef0:	39 08                	cmp    %ecx,(%eax)
  800ef2:	74 33                	je     800f27 <dev_lookup+0x4e>
  800ef4:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ef7:	8b 02                	mov    (%edx),%eax
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	75 f3                	jne    800ef0 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800efd:	a1 04 40 80 00       	mov    0x804004,%eax
  800f02:	8b 40 48             	mov    0x48(%eax),%eax
  800f05:	83 ec 04             	sub    $0x4,%esp
  800f08:	51                   	push   %ecx
  800f09:	50                   	push   %eax
  800f0a:	68 0c 23 80 00       	push   $0x80230c
  800f0f:	e8 8f f2 ff ff       	call   8001a3 <cprintf>
	*dev = 0;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f1d:	83 c4 10             	add    $0x10,%esp
  800f20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    
			*dev = devtab[i];
  800f27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2a:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f31:	eb f2                	jmp    800f25 <dev_lookup+0x4c>

00800f33 <fd_close>:
{
  800f33:	f3 0f 1e fb          	endbr32 
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
  800f3d:	83 ec 24             	sub    $0x24,%esp
  800f40:	8b 75 08             	mov    0x8(%ebp),%esi
  800f43:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f46:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f49:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f4a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f50:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f53:	50                   	push   %eax
  800f54:	e8 2c ff ff ff       	call   800e85 <fd_lookup>
  800f59:	89 c3                	mov    %eax,%ebx
  800f5b:	83 c4 10             	add    $0x10,%esp
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	78 05                	js     800f67 <fd_close+0x34>
	    || fd != fd2)
  800f62:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f65:	74 16                	je     800f7d <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f67:	89 f8                	mov    %edi,%eax
  800f69:	84 c0                	test   %al,%al
  800f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f70:	0f 44 d8             	cmove  %eax,%ebx
}
  800f73:	89 d8                	mov    %ebx,%eax
  800f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f78:	5b                   	pop    %ebx
  800f79:	5e                   	pop    %esi
  800f7a:	5f                   	pop    %edi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f7d:	83 ec 08             	sub    $0x8,%esp
  800f80:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f83:	50                   	push   %eax
  800f84:	ff 36                	pushl  (%esi)
  800f86:	e8 4e ff ff ff       	call   800ed9 <dev_lookup>
  800f8b:	89 c3                	mov    %eax,%ebx
  800f8d:	83 c4 10             	add    $0x10,%esp
  800f90:	85 c0                	test   %eax,%eax
  800f92:	78 1a                	js     800fae <fd_close+0x7b>
		if (dev->dev_close)
  800f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f97:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f9a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	74 0b                	je     800fae <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800fa3:	83 ec 0c             	sub    $0xc,%esp
  800fa6:	56                   	push   %esi
  800fa7:	ff d0                	call   *%eax
  800fa9:	89 c3                	mov    %eax,%ebx
  800fab:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fae:	83 ec 08             	sub    $0x8,%esp
  800fb1:	56                   	push   %esi
  800fb2:	6a 00                	push   $0x0
  800fb4:	e8 c3 fc ff ff       	call   800c7c <sys_page_unmap>
	return r;
  800fb9:	83 c4 10             	add    $0x10,%esp
  800fbc:	eb b5                	jmp    800f73 <fd_close+0x40>

00800fbe <close>:

int
close(int fdnum)
{
  800fbe:	f3 0f 1e fb          	endbr32 
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fcb:	50                   	push   %eax
  800fcc:	ff 75 08             	pushl  0x8(%ebp)
  800fcf:	e8 b1 fe ff ff       	call   800e85 <fd_lookup>
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	79 02                	jns    800fdd <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    
		return fd_close(fd, 1);
  800fdd:	83 ec 08             	sub    $0x8,%esp
  800fe0:	6a 01                	push   $0x1
  800fe2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe5:	e8 49 ff ff ff       	call   800f33 <fd_close>
  800fea:	83 c4 10             	add    $0x10,%esp
  800fed:	eb ec                	jmp    800fdb <close+0x1d>

00800fef <close_all>:

void
close_all(void)
{
  800fef:	f3 0f 1e fb          	endbr32 
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	53                   	push   %ebx
  800ff7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800ffa:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fff:	83 ec 0c             	sub    $0xc,%esp
  801002:	53                   	push   %ebx
  801003:	e8 b6 ff ff ff       	call   800fbe <close>
	for (i = 0; i < MAXFD; i++)
  801008:	83 c3 01             	add    $0x1,%ebx
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	83 fb 20             	cmp    $0x20,%ebx
  801011:	75 ec                	jne    800fff <close_all+0x10>
}
  801013:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801018:	f3 0f 1e fb          	endbr32 
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	57                   	push   %edi
  801020:	56                   	push   %esi
  801021:	53                   	push   %ebx
  801022:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801025:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801028:	50                   	push   %eax
  801029:	ff 75 08             	pushl  0x8(%ebp)
  80102c:	e8 54 fe ff ff       	call   800e85 <fd_lookup>
  801031:	89 c3                	mov    %eax,%ebx
  801033:	83 c4 10             	add    $0x10,%esp
  801036:	85 c0                	test   %eax,%eax
  801038:	0f 88 81 00 00 00    	js     8010bf <dup+0xa7>
		return r;
	close(newfdnum);
  80103e:	83 ec 0c             	sub    $0xc,%esp
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	e8 75 ff ff ff       	call   800fbe <close>

	newfd = INDEX2FD(newfdnum);
  801049:	8b 75 0c             	mov    0xc(%ebp),%esi
  80104c:	c1 e6 0c             	shl    $0xc,%esi
  80104f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801055:	83 c4 04             	add    $0x4,%esp
  801058:	ff 75 e4             	pushl  -0x1c(%ebp)
  80105b:	e8 b4 fd ff ff       	call   800e14 <fd2data>
  801060:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801062:	89 34 24             	mov    %esi,(%esp)
  801065:	e8 aa fd ff ff       	call   800e14 <fd2data>
  80106a:	83 c4 10             	add    $0x10,%esp
  80106d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80106f:	89 d8                	mov    %ebx,%eax
  801071:	c1 e8 16             	shr    $0x16,%eax
  801074:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80107b:	a8 01                	test   $0x1,%al
  80107d:	74 11                	je     801090 <dup+0x78>
  80107f:	89 d8                	mov    %ebx,%eax
  801081:	c1 e8 0c             	shr    $0xc,%eax
  801084:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80108b:	f6 c2 01             	test   $0x1,%dl
  80108e:	75 39                	jne    8010c9 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801090:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801093:	89 d0                	mov    %edx,%eax
  801095:	c1 e8 0c             	shr    $0xc,%eax
  801098:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80109f:	83 ec 0c             	sub    $0xc,%esp
  8010a2:	25 07 0e 00 00       	and    $0xe07,%eax
  8010a7:	50                   	push   %eax
  8010a8:	56                   	push   %esi
  8010a9:	6a 00                	push   $0x0
  8010ab:	52                   	push   %edx
  8010ac:	6a 00                	push   $0x0
  8010ae:	e8 83 fb ff ff       	call   800c36 <sys_page_map>
  8010b3:	89 c3                	mov    %eax,%ebx
  8010b5:	83 c4 20             	add    $0x20,%esp
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	78 31                	js     8010ed <dup+0xd5>
		goto err;

	return newfdnum;
  8010bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010bf:	89 d8                	mov    %ebx,%eax
  8010c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c4:	5b                   	pop    %ebx
  8010c5:	5e                   	pop    %esi
  8010c6:	5f                   	pop    %edi
  8010c7:	5d                   	pop    %ebp
  8010c8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010c9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010d0:	83 ec 0c             	sub    $0xc,%esp
  8010d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8010d8:	50                   	push   %eax
  8010d9:	57                   	push   %edi
  8010da:	6a 00                	push   $0x0
  8010dc:	53                   	push   %ebx
  8010dd:	6a 00                	push   $0x0
  8010df:	e8 52 fb ff ff       	call   800c36 <sys_page_map>
  8010e4:	89 c3                	mov    %eax,%ebx
  8010e6:	83 c4 20             	add    $0x20,%esp
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	79 a3                	jns    801090 <dup+0x78>
	sys_page_unmap(0, newfd);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	56                   	push   %esi
  8010f1:	6a 00                	push   $0x0
  8010f3:	e8 84 fb ff ff       	call   800c7c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010f8:	83 c4 08             	add    $0x8,%esp
  8010fb:	57                   	push   %edi
  8010fc:	6a 00                	push   $0x0
  8010fe:	e8 79 fb ff ff       	call   800c7c <sys_page_unmap>
	return r;
  801103:	83 c4 10             	add    $0x10,%esp
  801106:	eb b7                	jmp    8010bf <dup+0xa7>

00801108 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801108:	f3 0f 1e fb          	endbr32 
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	53                   	push   %ebx
  801110:	83 ec 1c             	sub    $0x1c,%esp
  801113:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801116:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801119:	50                   	push   %eax
  80111a:	53                   	push   %ebx
  80111b:	e8 65 fd ff ff       	call   800e85 <fd_lookup>
  801120:	83 c4 10             	add    $0x10,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	78 3f                	js     801166 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80112d:	50                   	push   %eax
  80112e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801131:	ff 30                	pushl  (%eax)
  801133:	e8 a1 fd ff ff       	call   800ed9 <dev_lookup>
  801138:	83 c4 10             	add    $0x10,%esp
  80113b:	85 c0                	test   %eax,%eax
  80113d:	78 27                	js     801166 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80113f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801142:	8b 42 08             	mov    0x8(%edx),%eax
  801145:	83 e0 03             	and    $0x3,%eax
  801148:	83 f8 01             	cmp    $0x1,%eax
  80114b:	74 1e                	je     80116b <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80114d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801150:	8b 40 08             	mov    0x8(%eax),%eax
  801153:	85 c0                	test   %eax,%eax
  801155:	74 35                	je     80118c <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801157:	83 ec 04             	sub    $0x4,%esp
  80115a:	ff 75 10             	pushl  0x10(%ebp)
  80115d:	ff 75 0c             	pushl  0xc(%ebp)
  801160:	52                   	push   %edx
  801161:	ff d0                	call   *%eax
  801163:	83 c4 10             	add    $0x10,%esp
}
  801166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801169:	c9                   	leave  
  80116a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80116b:	a1 04 40 80 00       	mov    0x804004,%eax
  801170:	8b 40 48             	mov    0x48(%eax),%eax
  801173:	83 ec 04             	sub    $0x4,%esp
  801176:	53                   	push   %ebx
  801177:	50                   	push   %eax
  801178:	68 4d 23 80 00       	push   $0x80234d
  80117d:	e8 21 f0 ff ff       	call   8001a3 <cprintf>
		return -E_INVAL;
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118a:	eb da                	jmp    801166 <read+0x5e>
		return -E_NOT_SUPP;
  80118c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801191:	eb d3                	jmp    801166 <read+0x5e>

00801193 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801193:	f3 0f 1e fb          	endbr32 
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	57                   	push   %edi
  80119b:	56                   	push   %esi
  80119c:	53                   	push   %ebx
  80119d:	83 ec 0c             	sub    $0xc,%esp
  8011a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011a3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ab:	eb 02                	jmp    8011af <readn+0x1c>
  8011ad:	01 c3                	add    %eax,%ebx
  8011af:	39 f3                	cmp    %esi,%ebx
  8011b1:	73 21                	jae    8011d4 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011b3:	83 ec 04             	sub    $0x4,%esp
  8011b6:	89 f0                	mov    %esi,%eax
  8011b8:	29 d8                	sub    %ebx,%eax
  8011ba:	50                   	push   %eax
  8011bb:	89 d8                	mov    %ebx,%eax
  8011bd:	03 45 0c             	add    0xc(%ebp),%eax
  8011c0:	50                   	push   %eax
  8011c1:	57                   	push   %edi
  8011c2:	e8 41 ff ff ff       	call   801108 <read>
		if (m < 0)
  8011c7:	83 c4 10             	add    $0x10,%esp
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	78 04                	js     8011d2 <readn+0x3f>
			return m;
		if (m == 0)
  8011ce:	75 dd                	jne    8011ad <readn+0x1a>
  8011d0:	eb 02                	jmp    8011d4 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011d2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011d4:	89 d8                	mov    %ebx,%eax
  8011d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d9:	5b                   	pop    %ebx
  8011da:	5e                   	pop    %esi
  8011db:	5f                   	pop    %edi
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    

008011de <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011de:	f3 0f 1e fb          	endbr32 
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	53                   	push   %ebx
  8011e6:	83 ec 1c             	sub    $0x1c,%esp
  8011e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011ef:	50                   	push   %eax
  8011f0:	53                   	push   %ebx
  8011f1:	e8 8f fc ff ff       	call   800e85 <fd_lookup>
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	78 3a                	js     801237 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011fd:	83 ec 08             	sub    $0x8,%esp
  801200:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801203:	50                   	push   %eax
  801204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801207:	ff 30                	pushl  (%eax)
  801209:	e8 cb fc ff ff       	call   800ed9 <dev_lookup>
  80120e:	83 c4 10             	add    $0x10,%esp
  801211:	85 c0                	test   %eax,%eax
  801213:	78 22                	js     801237 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801218:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80121c:	74 1e                	je     80123c <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80121e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801221:	8b 52 0c             	mov    0xc(%edx),%edx
  801224:	85 d2                	test   %edx,%edx
  801226:	74 35                	je     80125d <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801228:	83 ec 04             	sub    $0x4,%esp
  80122b:	ff 75 10             	pushl  0x10(%ebp)
  80122e:	ff 75 0c             	pushl  0xc(%ebp)
  801231:	50                   	push   %eax
  801232:	ff d2                	call   *%edx
  801234:	83 c4 10             	add    $0x10,%esp
}
  801237:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80123c:	a1 04 40 80 00       	mov    0x804004,%eax
  801241:	8b 40 48             	mov    0x48(%eax),%eax
  801244:	83 ec 04             	sub    $0x4,%esp
  801247:	53                   	push   %ebx
  801248:	50                   	push   %eax
  801249:	68 69 23 80 00       	push   $0x802369
  80124e:	e8 50 ef ff ff       	call   8001a3 <cprintf>
		return -E_INVAL;
  801253:	83 c4 10             	add    $0x10,%esp
  801256:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125b:	eb da                	jmp    801237 <write+0x59>
		return -E_NOT_SUPP;
  80125d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801262:	eb d3                	jmp    801237 <write+0x59>

00801264 <seek>:

int
seek(int fdnum, off_t offset)
{
  801264:	f3 0f 1e fb          	endbr32 
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80126e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801271:	50                   	push   %eax
  801272:	ff 75 08             	pushl  0x8(%ebp)
  801275:	e8 0b fc ff ff       	call   800e85 <fd_lookup>
  80127a:	83 c4 10             	add    $0x10,%esp
  80127d:	85 c0                	test   %eax,%eax
  80127f:	78 0e                	js     80128f <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801281:	8b 55 0c             	mov    0xc(%ebp),%edx
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801287:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80128a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801291:	f3 0f 1e fb          	endbr32 
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	53                   	push   %ebx
  801299:	83 ec 1c             	sub    $0x1c,%esp
  80129c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80129f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a2:	50                   	push   %eax
  8012a3:	53                   	push   %ebx
  8012a4:	e8 dc fb ff ff       	call   800e85 <fd_lookup>
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	78 37                	js     8012e7 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b6:	50                   	push   %eax
  8012b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ba:	ff 30                	pushl  (%eax)
  8012bc:	e8 18 fc ff ff       	call   800ed9 <dev_lookup>
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	78 1f                	js     8012e7 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012cf:	74 1b                	je     8012ec <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d4:	8b 52 18             	mov    0x18(%edx),%edx
  8012d7:	85 d2                	test   %edx,%edx
  8012d9:	74 32                	je     80130d <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012db:	83 ec 08             	sub    $0x8,%esp
  8012de:	ff 75 0c             	pushl  0xc(%ebp)
  8012e1:	50                   	push   %eax
  8012e2:	ff d2                	call   *%edx
  8012e4:	83 c4 10             	add    $0x10,%esp
}
  8012e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012ec:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012f1:	8b 40 48             	mov    0x48(%eax),%eax
  8012f4:	83 ec 04             	sub    $0x4,%esp
  8012f7:	53                   	push   %ebx
  8012f8:	50                   	push   %eax
  8012f9:	68 2c 23 80 00       	push   $0x80232c
  8012fe:	e8 a0 ee ff ff       	call   8001a3 <cprintf>
		return -E_INVAL;
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130b:	eb da                	jmp    8012e7 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80130d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801312:	eb d3                	jmp    8012e7 <ftruncate+0x56>

00801314 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801314:	f3 0f 1e fb          	endbr32 
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	53                   	push   %ebx
  80131c:	83 ec 1c             	sub    $0x1c,%esp
  80131f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801322:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801325:	50                   	push   %eax
  801326:	ff 75 08             	pushl  0x8(%ebp)
  801329:	e8 57 fb ff ff       	call   800e85 <fd_lookup>
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	78 4b                	js     801380 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133b:	50                   	push   %eax
  80133c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133f:	ff 30                	pushl  (%eax)
  801341:	e8 93 fb ff ff       	call   800ed9 <dev_lookup>
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	85 c0                	test   %eax,%eax
  80134b:	78 33                	js     801380 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80134d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801350:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801354:	74 2f                	je     801385 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801356:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801359:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801360:	00 00 00 
	stat->st_isdir = 0;
  801363:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80136a:	00 00 00 
	stat->st_dev = dev;
  80136d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801373:	83 ec 08             	sub    $0x8,%esp
  801376:	53                   	push   %ebx
  801377:	ff 75 f0             	pushl  -0x10(%ebp)
  80137a:	ff 50 14             	call   *0x14(%eax)
  80137d:	83 c4 10             	add    $0x10,%esp
}
  801380:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801383:	c9                   	leave  
  801384:	c3                   	ret    
		return -E_NOT_SUPP;
  801385:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80138a:	eb f4                	jmp    801380 <fstat+0x6c>

0080138c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80138c:	f3 0f 1e fb          	endbr32 
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	56                   	push   %esi
  801394:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801395:	83 ec 08             	sub    $0x8,%esp
  801398:	6a 00                	push   $0x0
  80139a:	ff 75 08             	pushl  0x8(%ebp)
  80139d:	e8 fb 01 00 00       	call   80159d <open>
  8013a2:	89 c3                	mov    %eax,%ebx
  8013a4:	83 c4 10             	add    $0x10,%esp
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	78 1b                	js     8013c6 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	50                   	push   %eax
  8013b2:	e8 5d ff ff ff       	call   801314 <fstat>
  8013b7:	89 c6                	mov    %eax,%esi
	close(fd);
  8013b9:	89 1c 24             	mov    %ebx,(%esp)
  8013bc:	e8 fd fb ff ff       	call   800fbe <close>
	return r;
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	89 f3                	mov    %esi,%ebx
}
  8013c6:	89 d8                	mov    %ebx,%eax
  8013c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013cb:	5b                   	pop    %ebx
  8013cc:	5e                   	pop    %esi
  8013cd:	5d                   	pop    %ebp
  8013ce:	c3                   	ret    

008013cf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	56                   	push   %esi
  8013d3:	53                   	push   %ebx
  8013d4:	89 c6                	mov    %eax,%esi
  8013d6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013d8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013df:	74 27                	je     801408 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013e1:	6a 07                	push   $0x7
  8013e3:	68 00 50 80 00       	push   $0x805000
  8013e8:	56                   	push   %esi
  8013e9:	ff 35 00 40 80 00    	pushl  0x804000
  8013ef:	e8 20 08 00 00       	call   801c14 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013f4:	83 c4 0c             	add    $0xc,%esp
  8013f7:	6a 00                	push   $0x0
  8013f9:	53                   	push   %ebx
  8013fa:	6a 00                	push   $0x0
  8013fc:	e8 8e 07 00 00       	call   801b8f <ipc_recv>
}
  801401:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801404:	5b                   	pop    %ebx
  801405:	5e                   	pop    %esi
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801408:	83 ec 0c             	sub    $0xc,%esp
  80140b:	6a 01                	push   $0x1
  80140d:	e8 5a 08 00 00       	call   801c6c <ipc_find_env>
  801412:	a3 00 40 80 00       	mov    %eax,0x804000
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	eb c5                	jmp    8013e1 <fsipc+0x12>

0080141c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80141c:	f3 0f 1e fb          	endbr32 
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8b 40 0c             	mov    0xc(%eax),%eax
  80142c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801439:	ba 00 00 00 00       	mov    $0x0,%edx
  80143e:	b8 02 00 00 00       	mov    $0x2,%eax
  801443:	e8 87 ff ff ff       	call   8013cf <fsipc>
}
  801448:	c9                   	leave  
  801449:	c3                   	ret    

0080144a <devfile_flush>:
{
  80144a:	f3 0f 1e fb          	endbr32 
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8b 40 0c             	mov    0xc(%eax),%eax
  80145a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80145f:	ba 00 00 00 00       	mov    $0x0,%edx
  801464:	b8 06 00 00 00       	mov    $0x6,%eax
  801469:	e8 61 ff ff ff       	call   8013cf <fsipc>
}
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <devfile_stat>:
{
  801470:	f3 0f 1e fb          	endbr32 
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	53                   	push   %ebx
  801478:	83 ec 04             	sub    $0x4,%esp
  80147b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8b 40 0c             	mov    0xc(%eax),%eax
  801484:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801489:	ba 00 00 00 00       	mov    $0x0,%edx
  80148e:	b8 05 00 00 00       	mov    $0x5,%eax
  801493:	e8 37 ff ff ff       	call   8013cf <fsipc>
  801498:	85 c0                	test   %eax,%eax
  80149a:	78 2c                	js     8014c8 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80149c:	83 ec 08             	sub    $0x8,%esp
  80149f:	68 00 50 80 00       	push   $0x805000
  8014a4:	53                   	push   %ebx
  8014a5:	e8 03 f3 ff ff       	call   8007ad <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014aa:	a1 80 50 80 00       	mov    0x805080,%eax
  8014af:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014b5:	a1 84 50 80 00       	mov    0x805084,%eax
  8014ba:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <devfile_write>:
{
  8014cd:	f3 0f 1e fb          	endbr32 
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 0c             	sub    $0xc,%esp
  8014d7:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014da:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dd:	8b 52 0c             	mov    0xc(%edx),%edx
  8014e0:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8014e6:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014eb:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8014f0:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8014f3:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014f8:	50                   	push   %eax
  8014f9:	ff 75 0c             	pushl  0xc(%ebp)
  8014fc:	68 08 50 80 00       	push   $0x805008
  801501:	e8 5d f4 ff ff       	call   800963 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801506:	ba 00 00 00 00       	mov    $0x0,%edx
  80150b:	b8 04 00 00 00       	mov    $0x4,%eax
  801510:	e8 ba fe ff ff       	call   8013cf <fsipc>
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <devfile_read>:
{
  801517:	f3 0f 1e fb          	endbr32 
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	56                   	push   %esi
  80151f:	53                   	push   %ebx
  801520:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8b 40 0c             	mov    0xc(%eax),%eax
  801529:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80152e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801534:	ba 00 00 00 00       	mov    $0x0,%edx
  801539:	b8 03 00 00 00       	mov    $0x3,%eax
  80153e:	e8 8c fe ff ff       	call   8013cf <fsipc>
  801543:	89 c3                	mov    %eax,%ebx
  801545:	85 c0                	test   %eax,%eax
  801547:	78 1f                	js     801568 <devfile_read+0x51>
	assert(r <= n);
  801549:	39 f0                	cmp    %esi,%eax
  80154b:	77 24                	ja     801571 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80154d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801552:	7f 33                	jg     801587 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801554:	83 ec 04             	sub    $0x4,%esp
  801557:	50                   	push   %eax
  801558:	68 00 50 80 00       	push   $0x805000
  80155d:	ff 75 0c             	pushl  0xc(%ebp)
  801560:	e8 fe f3 ff ff       	call   800963 <memmove>
	return r;
  801565:	83 c4 10             	add    $0x10,%esp
}
  801568:	89 d8                	mov    %ebx,%eax
  80156a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80156d:	5b                   	pop    %ebx
  80156e:	5e                   	pop    %esi
  80156f:	5d                   	pop    %ebp
  801570:	c3                   	ret    
	assert(r <= n);
  801571:	68 98 23 80 00       	push   $0x802398
  801576:	68 9f 23 80 00       	push   $0x80239f
  80157b:	6a 7c                	push   $0x7c
  80157d:	68 b4 23 80 00       	push   $0x8023b4
  801582:	e8 be 05 00 00       	call   801b45 <_panic>
	assert(r <= PGSIZE);
  801587:	68 bf 23 80 00       	push   $0x8023bf
  80158c:	68 9f 23 80 00       	push   $0x80239f
  801591:	6a 7d                	push   $0x7d
  801593:	68 b4 23 80 00       	push   $0x8023b4
  801598:	e8 a8 05 00 00       	call   801b45 <_panic>

0080159d <open>:
{
  80159d:	f3 0f 1e fb          	endbr32 
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	56                   	push   %esi
  8015a5:	53                   	push   %ebx
  8015a6:	83 ec 1c             	sub    $0x1c,%esp
  8015a9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015ac:	56                   	push   %esi
  8015ad:	e8 b8 f1 ff ff       	call   80076a <strlen>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015ba:	7f 6c                	jg     801628 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8015bc:	83 ec 0c             	sub    $0xc,%esp
  8015bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c2:	50                   	push   %eax
  8015c3:	e8 67 f8 ff ff       	call   800e2f <fd_alloc>
  8015c8:	89 c3                	mov    %eax,%ebx
  8015ca:	83 c4 10             	add    $0x10,%esp
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 3c                	js     80160d <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8015d1:	83 ec 08             	sub    $0x8,%esp
  8015d4:	56                   	push   %esi
  8015d5:	68 00 50 80 00       	push   $0x805000
  8015da:	e8 ce f1 ff ff       	call   8007ad <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8015ef:	e8 db fd ff ff       	call   8013cf <fsipc>
  8015f4:	89 c3                	mov    %eax,%ebx
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	78 19                	js     801616 <open+0x79>
	return fd2num(fd);
  8015fd:	83 ec 0c             	sub    $0xc,%esp
  801600:	ff 75 f4             	pushl  -0xc(%ebp)
  801603:	e8 f8 f7 ff ff       	call   800e00 <fd2num>
  801608:	89 c3                	mov    %eax,%ebx
  80160a:	83 c4 10             	add    $0x10,%esp
}
  80160d:	89 d8                	mov    %ebx,%eax
  80160f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801612:	5b                   	pop    %ebx
  801613:	5e                   	pop    %esi
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    
		fd_close(fd, 0);
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	6a 00                	push   $0x0
  80161b:	ff 75 f4             	pushl  -0xc(%ebp)
  80161e:	e8 10 f9 ff ff       	call   800f33 <fd_close>
		return r;
  801623:	83 c4 10             	add    $0x10,%esp
  801626:	eb e5                	jmp    80160d <open+0x70>
		return -E_BAD_PATH;
  801628:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80162d:	eb de                	jmp    80160d <open+0x70>

0080162f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80162f:	f3 0f 1e fb          	endbr32 
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801639:	ba 00 00 00 00       	mov    $0x0,%edx
  80163e:	b8 08 00 00 00       	mov    $0x8,%eax
  801643:	e8 87 fd ff ff       	call   8013cf <fsipc>
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80164a:	f3 0f 1e fb          	endbr32 
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	56                   	push   %esi
  801652:	53                   	push   %ebx
  801653:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 b3 f7 ff ff       	call   800e14 <fd2data>
  801661:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801663:	83 c4 08             	add    $0x8,%esp
  801666:	68 cb 23 80 00       	push   $0x8023cb
  80166b:	53                   	push   %ebx
  80166c:	e8 3c f1 ff ff       	call   8007ad <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801671:	8b 46 04             	mov    0x4(%esi),%eax
  801674:	2b 06                	sub    (%esi),%eax
  801676:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80167c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801683:	00 00 00 
	stat->st_dev = &devpipe;
  801686:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80168d:	30 80 00 
	return 0;
}
  801690:	b8 00 00 00 00       	mov    $0x0,%eax
  801695:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801698:	5b                   	pop    %ebx
  801699:	5e                   	pop    %esi
  80169a:	5d                   	pop    %ebp
  80169b:	c3                   	ret    

0080169c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80169c:	f3 0f 1e fb          	endbr32 
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	53                   	push   %ebx
  8016a4:	83 ec 0c             	sub    $0xc,%esp
  8016a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016aa:	53                   	push   %ebx
  8016ab:	6a 00                	push   $0x0
  8016ad:	e8 ca f5 ff ff       	call   800c7c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8016b2:	89 1c 24             	mov    %ebx,(%esp)
  8016b5:	e8 5a f7 ff ff       	call   800e14 <fd2data>
  8016ba:	83 c4 08             	add    $0x8,%esp
  8016bd:	50                   	push   %eax
  8016be:	6a 00                	push   $0x0
  8016c0:	e8 b7 f5 ff ff       	call   800c7c <sys_page_unmap>
}
  8016c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <_pipeisclosed>:
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	57                   	push   %edi
  8016ce:	56                   	push   %esi
  8016cf:	53                   	push   %ebx
  8016d0:	83 ec 1c             	sub    $0x1c,%esp
  8016d3:	89 c7                	mov    %eax,%edi
  8016d5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016d7:	a1 04 40 80 00       	mov    0x804004,%eax
  8016dc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016df:	83 ec 0c             	sub    $0xc,%esp
  8016e2:	57                   	push   %edi
  8016e3:	e8 c1 05 00 00       	call   801ca9 <pageref>
  8016e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016eb:	89 34 24             	mov    %esi,(%esp)
  8016ee:	e8 b6 05 00 00       	call   801ca9 <pageref>
		nn = thisenv->env_runs;
  8016f3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8016f9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	39 cb                	cmp    %ecx,%ebx
  801701:	74 1b                	je     80171e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801703:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801706:	75 cf                	jne    8016d7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801708:	8b 42 58             	mov    0x58(%edx),%eax
  80170b:	6a 01                	push   $0x1
  80170d:	50                   	push   %eax
  80170e:	53                   	push   %ebx
  80170f:	68 d2 23 80 00       	push   $0x8023d2
  801714:	e8 8a ea ff ff       	call   8001a3 <cprintf>
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	eb b9                	jmp    8016d7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80171e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801721:	0f 94 c0             	sete   %al
  801724:	0f b6 c0             	movzbl %al,%eax
}
  801727:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80172a:	5b                   	pop    %ebx
  80172b:	5e                   	pop    %esi
  80172c:	5f                   	pop    %edi
  80172d:	5d                   	pop    %ebp
  80172e:	c3                   	ret    

0080172f <devpipe_write>:
{
  80172f:	f3 0f 1e fb          	endbr32 
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	57                   	push   %edi
  801737:	56                   	push   %esi
  801738:	53                   	push   %ebx
  801739:	83 ec 28             	sub    $0x28,%esp
  80173c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80173f:	56                   	push   %esi
  801740:	e8 cf f6 ff ff       	call   800e14 <fd2data>
  801745:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801747:	83 c4 10             	add    $0x10,%esp
  80174a:	bf 00 00 00 00       	mov    $0x0,%edi
  80174f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801752:	74 4f                	je     8017a3 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801754:	8b 43 04             	mov    0x4(%ebx),%eax
  801757:	8b 0b                	mov    (%ebx),%ecx
  801759:	8d 51 20             	lea    0x20(%ecx),%edx
  80175c:	39 d0                	cmp    %edx,%eax
  80175e:	72 14                	jb     801774 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801760:	89 da                	mov    %ebx,%edx
  801762:	89 f0                	mov    %esi,%eax
  801764:	e8 61 ff ff ff       	call   8016ca <_pipeisclosed>
  801769:	85 c0                	test   %eax,%eax
  80176b:	75 3b                	jne    8017a8 <devpipe_write+0x79>
			sys_yield();
  80176d:	e8 5a f4 ff ff       	call   800bcc <sys_yield>
  801772:	eb e0                	jmp    801754 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801774:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801777:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80177b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80177e:	89 c2                	mov    %eax,%edx
  801780:	c1 fa 1f             	sar    $0x1f,%edx
  801783:	89 d1                	mov    %edx,%ecx
  801785:	c1 e9 1b             	shr    $0x1b,%ecx
  801788:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80178b:	83 e2 1f             	and    $0x1f,%edx
  80178e:	29 ca                	sub    %ecx,%edx
  801790:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801794:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801798:	83 c0 01             	add    $0x1,%eax
  80179b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80179e:	83 c7 01             	add    $0x1,%edi
  8017a1:	eb ac                	jmp    80174f <devpipe_write+0x20>
	return i;
  8017a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a6:	eb 05                	jmp    8017ad <devpipe_write+0x7e>
				return 0;
  8017a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b0:	5b                   	pop    %ebx
  8017b1:	5e                   	pop    %esi
  8017b2:	5f                   	pop    %edi
  8017b3:	5d                   	pop    %ebp
  8017b4:	c3                   	ret    

008017b5 <devpipe_read>:
{
  8017b5:	f3 0f 1e fb          	endbr32 
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	57                   	push   %edi
  8017bd:	56                   	push   %esi
  8017be:	53                   	push   %ebx
  8017bf:	83 ec 18             	sub    $0x18,%esp
  8017c2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8017c5:	57                   	push   %edi
  8017c6:	e8 49 f6 ff ff       	call   800e14 <fd2data>
  8017cb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	be 00 00 00 00       	mov    $0x0,%esi
  8017d5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017d8:	75 14                	jne    8017ee <devpipe_read+0x39>
	return i;
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	eb 02                	jmp    8017e1 <devpipe_read+0x2c>
				return i;
  8017df:	89 f0                	mov    %esi,%eax
}
  8017e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e4:	5b                   	pop    %ebx
  8017e5:	5e                   	pop    %esi
  8017e6:	5f                   	pop    %edi
  8017e7:	5d                   	pop    %ebp
  8017e8:	c3                   	ret    
			sys_yield();
  8017e9:	e8 de f3 ff ff       	call   800bcc <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8017ee:	8b 03                	mov    (%ebx),%eax
  8017f0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017f3:	75 18                	jne    80180d <devpipe_read+0x58>
			if (i > 0)
  8017f5:	85 f6                	test   %esi,%esi
  8017f7:	75 e6                	jne    8017df <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8017f9:	89 da                	mov    %ebx,%edx
  8017fb:	89 f8                	mov    %edi,%eax
  8017fd:	e8 c8 fe ff ff       	call   8016ca <_pipeisclosed>
  801802:	85 c0                	test   %eax,%eax
  801804:	74 e3                	je     8017e9 <devpipe_read+0x34>
				return 0;
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	eb d4                	jmp    8017e1 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80180d:	99                   	cltd   
  80180e:	c1 ea 1b             	shr    $0x1b,%edx
  801811:	01 d0                	add    %edx,%eax
  801813:	83 e0 1f             	and    $0x1f,%eax
  801816:	29 d0                	sub    %edx,%eax
  801818:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80181d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801820:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801823:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801826:	83 c6 01             	add    $0x1,%esi
  801829:	eb aa                	jmp    8017d5 <devpipe_read+0x20>

0080182b <pipe>:
{
  80182b:	f3 0f 1e fb          	endbr32 
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	56                   	push   %esi
  801833:	53                   	push   %ebx
  801834:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801837:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183a:	50                   	push   %eax
  80183b:	e8 ef f5 ff ff       	call   800e2f <fd_alloc>
  801840:	89 c3                	mov    %eax,%ebx
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	85 c0                	test   %eax,%eax
  801847:	0f 88 23 01 00 00    	js     801970 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80184d:	83 ec 04             	sub    $0x4,%esp
  801850:	68 07 04 00 00       	push   $0x407
  801855:	ff 75 f4             	pushl  -0xc(%ebp)
  801858:	6a 00                	push   $0x0
  80185a:	e8 90 f3 ff ff       	call   800bef <sys_page_alloc>
  80185f:	89 c3                	mov    %eax,%ebx
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	85 c0                	test   %eax,%eax
  801866:	0f 88 04 01 00 00    	js     801970 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80186c:	83 ec 0c             	sub    $0xc,%esp
  80186f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801872:	50                   	push   %eax
  801873:	e8 b7 f5 ff ff       	call   800e2f <fd_alloc>
  801878:	89 c3                	mov    %eax,%ebx
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	85 c0                	test   %eax,%eax
  80187f:	0f 88 db 00 00 00    	js     801960 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	68 07 04 00 00       	push   $0x407
  80188d:	ff 75 f0             	pushl  -0x10(%ebp)
  801890:	6a 00                	push   $0x0
  801892:	e8 58 f3 ff ff       	call   800bef <sys_page_alloc>
  801897:	89 c3                	mov    %eax,%ebx
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	85 c0                	test   %eax,%eax
  80189e:	0f 88 bc 00 00 00    	js     801960 <pipe+0x135>
	va = fd2data(fd0);
  8018a4:	83 ec 0c             	sub    $0xc,%esp
  8018a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018aa:	e8 65 f5 ff ff       	call   800e14 <fd2data>
  8018af:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018b1:	83 c4 0c             	add    $0xc,%esp
  8018b4:	68 07 04 00 00       	push   $0x407
  8018b9:	50                   	push   %eax
  8018ba:	6a 00                	push   $0x0
  8018bc:	e8 2e f3 ff ff       	call   800bef <sys_page_alloc>
  8018c1:	89 c3                	mov    %eax,%ebx
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	0f 88 82 00 00 00    	js     801950 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018ce:	83 ec 0c             	sub    $0xc,%esp
  8018d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d4:	e8 3b f5 ff ff       	call   800e14 <fd2data>
  8018d9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018e0:	50                   	push   %eax
  8018e1:	6a 00                	push   $0x0
  8018e3:	56                   	push   %esi
  8018e4:	6a 00                	push   $0x0
  8018e6:	e8 4b f3 ff ff       	call   800c36 <sys_page_map>
  8018eb:	89 c3                	mov    %eax,%ebx
  8018ed:	83 c4 20             	add    $0x20,%esp
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	78 4e                	js     801942 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8018f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8018f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8018fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801901:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801908:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80190b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80190d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801910:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801917:	83 ec 0c             	sub    $0xc,%esp
  80191a:	ff 75 f4             	pushl  -0xc(%ebp)
  80191d:	e8 de f4 ff ff       	call   800e00 <fd2num>
  801922:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801925:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801927:	83 c4 04             	add    $0x4,%esp
  80192a:	ff 75 f0             	pushl  -0x10(%ebp)
  80192d:	e8 ce f4 ff ff       	call   800e00 <fd2num>
  801932:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801935:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801938:	83 c4 10             	add    $0x10,%esp
  80193b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801940:	eb 2e                	jmp    801970 <pipe+0x145>
	sys_page_unmap(0, va);
  801942:	83 ec 08             	sub    $0x8,%esp
  801945:	56                   	push   %esi
  801946:	6a 00                	push   $0x0
  801948:	e8 2f f3 ff ff       	call   800c7c <sys_page_unmap>
  80194d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801950:	83 ec 08             	sub    $0x8,%esp
  801953:	ff 75 f0             	pushl  -0x10(%ebp)
  801956:	6a 00                	push   $0x0
  801958:	e8 1f f3 ff ff       	call   800c7c <sys_page_unmap>
  80195d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801960:	83 ec 08             	sub    $0x8,%esp
  801963:	ff 75 f4             	pushl  -0xc(%ebp)
  801966:	6a 00                	push   $0x0
  801968:	e8 0f f3 ff ff       	call   800c7c <sys_page_unmap>
  80196d:	83 c4 10             	add    $0x10,%esp
}
  801970:	89 d8                	mov    %ebx,%eax
  801972:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801975:	5b                   	pop    %ebx
  801976:	5e                   	pop    %esi
  801977:	5d                   	pop    %ebp
  801978:	c3                   	ret    

00801979 <pipeisclosed>:
{
  801979:	f3 0f 1e fb          	endbr32 
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801983:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801986:	50                   	push   %eax
  801987:	ff 75 08             	pushl  0x8(%ebp)
  80198a:	e8 f6 f4 ff ff       	call   800e85 <fd_lookup>
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	85 c0                	test   %eax,%eax
  801994:	78 18                	js     8019ae <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801996:	83 ec 0c             	sub    $0xc,%esp
  801999:	ff 75 f4             	pushl  -0xc(%ebp)
  80199c:	e8 73 f4 ff ff       	call   800e14 <fd2data>
  8019a1:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8019a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a6:	e8 1f fd ff ff       	call   8016ca <_pipeisclosed>
  8019ab:	83 c4 10             	add    $0x10,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8019b0:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8019b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b9:	c3                   	ret    

008019ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8019ba:	f3 0f 1e fb          	endbr32 
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8019c4:	68 ea 23 80 00       	push   $0x8023ea
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	e8 dc ed ff ff       	call   8007ad <strcpy>
	return 0;
}
  8019d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <devcons_write>:
{
  8019d8:	f3 0f 1e fb          	endbr32 
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	57                   	push   %edi
  8019e0:	56                   	push   %esi
  8019e1:	53                   	push   %ebx
  8019e2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8019e8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8019ed:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8019f3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019f6:	73 31                	jae    801a29 <devcons_write+0x51>
		m = n - tot;
  8019f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019fb:	29 f3                	sub    %esi,%ebx
  8019fd:	83 fb 7f             	cmp    $0x7f,%ebx
  801a00:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a05:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	53                   	push   %ebx
  801a0c:	89 f0                	mov    %esi,%eax
  801a0e:	03 45 0c             	add    0xc(%ebp),%eax
  801a11:	50                   	push   %eax
  801a12:	57                   	push   %edi
  801a13:	e8 4b ef ff ff       	call   800963 <memmove>
		sys_cputs(buf, m);
  801a18:	83 c4 08             	add    $0x8,%esp
  801a1b:	53                   	push   %ebx
  801a1c:	57                   	push   %edi
  801a1d:	e8 fd f0 ff ff       	call   800b1f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801a22:	01 de                	add    %ebx,%esi
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	eb ca                	jmp    8019f3 <devcons_write+0x1b>
}
  801a29:	89 f0                	mov    %esi,%eax
  801a2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a2e:	5b                   	pop    %ebx
  801a2f:	5e                   	pop    %esi
  801a30:	5f                   	pop    %edi
  801a31:	5d                   	pop    %ebp
  801a32:	c3                   	ret    

00801a33 <devcons_read>:
{
  801a33:	f3 0f 1e fb          	endbr32 
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 08             	sub    $0x8,%esp
  801a3d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801a42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a46:	74 21                	je     801a69 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801a48:	e8 f4 f0 ff ff       	call   800b41 <sys_cgetc>
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	75 07                	jne    801a58 <devcons_read+0x25>
		sys_yield();
  801a51:	e8 76 f1 ff ff       	call   800bcc <sys_yield>
  801a56:	eb f0                	jmp    801a48 <devcons_read+0x15>
	if (c < 0)
  801a58:	78 0f                	js     801a69 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801a5a:	83 f8 04             	cmp    $0x4,%eax
  801a5d:	74 0c                	je     801a6b <devcons_read+0x38>
	*(char*)vbuf = c;
  801a5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a62:	88 02                	mov    %al,(%edx)
	return 1;
  801a64:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    
		return 0;
  801a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a70:	eb f7                	jmp    801a69 <devcons_read+0x36>

00801a72 <cputchar>:
{
  801a72:	f3 0f 1e fb          	endbr32 
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a82:	6a 01                	push   $0x1
  801a84:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a87:	50                   	push   %eax
  801a88:	e8 92 f0 ff ff       	call   800b1f <sys_cputs>
}
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <getchar>:
{
  801a92:	f3 0f 1e fb          	endbr32 
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a9c:	6a 01                	push   $0x1
  801a9e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801aa1:	50                   	push   %eax
  801aa2:	6a 00                	push   $0x0
  801aa4:	e8 5f f6 ff ff       	call   801108 <read>
	if (r < 0)
  801aa9:	83 c4 10             	add    $0x10,%esp
  801aac:	85 c0                	test   %eax,%eax
  801aae:	78 06                	js     801ab6 <getchar+0x24>
	if (r < 1)
  801ab0:	74 06                	je     801ab8 <getchar+0x26>
	return c;
  801ab2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    
		return -E_EOF;
  801ab8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801abd:	eb f7                	jmp    801ab6 <getchar+0x24>

00801abf <iscons>:
{
  801abf:	f3 0f 1e fb          	endbr32 
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ac9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acc:	50                   	push   %eax
  801acd:	ff 75 08             	pushl  0x8(%ebp)
  801ad0:	e8 b0 f3 ff ff       	call   800e85 <fd_lookup>
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	78 11                	js     801aed <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adf:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ae5:	39 10                	cmp    %edx,(%eax)
  801ae7:	0f 94 c0             	sete   %al
  801aea:	0f b6 c0             	movzbl %al,%eax
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <opencons>:
{
  801aef:	f3 0f 1e fb          	endbr32 
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801af9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801afc:	50                   	push   %eax
  801afd:	e8 2d f3 ff ff       	call   800e2f <fd_alloc>
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 3a                	js     801b43 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b09:	83 ec 04             	sub    $0x4,%esp
  801b0c:	68 07 04 00 00       	push   $0x407
  801b11:	ff 75 f4             	pushl  -0xc(%ebp)
  801b14:	6a 00                	push   $0x0
  801b16:	e8 d4 f0 ff ff       	call   800bef <sys_page_alloc>
  801b1b:	83 c4 10             	add    $0x10,%esp
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	78 21                	js     801b43 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b25:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b2b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b30:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b37:	83 ec 0c             	sub    $0xc,%esp
  801b3a:	50                   	push   %eax
  801b3b:	e8 c0 f2 ff ff       	call   800e00 <fd2num>
  801b40:	83 c4 10             	add    $0x10,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b45:	f3 0f 1e fb          	endbr32 
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	56                   	push   %esi
  801b4d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b4e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b51:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801b57:	e8 4d f0 ff ff       	call   800ba9 <sys_getenvid>
  801b5c:	83 ec 0c             	sub    $0xc,%esp
  801b5f:	ff 75 0c             	pushl  0xc(%ebp)
  801b62:	ff 75 08             	pushl  0x8(%ebp)
  801b65:	56                   	push   %esi
  801b66:	50                   	push   %eax
  801b67:	68 f8 23 80 00       	push   $0x8023f8
  801b6c:	e8 32 e6 ff ff       	call   8001a3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b71:	83 c4 18             	add    $0x18,%esp
  801b74:	53                   	push   %ebx
  801b75:	ff 75 10             	pushl  0x10(%ebp)
  801b78:	e8 d1 e5 ff ff       	call   80014e <vcprintf>
	cprintf("\n");
  801b7d:	c7 04 24 34 24 80 00 	movl   $0x802434,(%esp)
  801b84:	e8 1a e6 ff ff       	call   8001a3 <cprintf>
  801b89:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b8c:	cc                   	int3   
  801b8d:	eb fd                	jmp    801b8c <_panic+0x47>

00801b8f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b8f:	f3 0f 1e fb          	endbr32 
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	56                   	push   %esi
  801b97:	53                   	push   %ebx
  801b98:	8b 75 08             	mov    0x8(%ebp),%esi
  801b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	74 3d                	je     801be2 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801ba5:	83 ec 0c             	sub    $0xc,%esp
  801ba8:	50                   	push   %eax
  801ba9:	e8 0d f2 ff ff       	call   800dbb <sys_ipc_recv>
  801bae:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801bb1:	85 f6                	test   %esi,%esi
  801bb3:	74 0b                	je     801bc0 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801bb5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bbb:	8b 52 74             	mov    0x74(%edx),%edx
  801bbe:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801bc0:	85 db                	test   %ebx,%ebx
  801bc2:	74 0b                	je     801bcf <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801bc4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bca:	8b 52 78             	mov    0x78(%edx),%edx
  801bcd:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	78 21                	js     801bf4 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801bd3:	a1 04 40 80 00       	mov    0x804004,%eax
  801bd8:	8b 40 70             	mov    0x70(%eax),%eax
}
  801bdb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bde:	5b                   	pop    %ebx
  801bdf:	5e                   	pop    %esi
  801be0:	5d                   	pop    %ebp
  801be1:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	68 00 00 c0 ee       	push   $0xeec00000
  801bea:	e8 cc f1 ff ff       	call   800dbb <sys_ipc_recv>
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	eb bd                	jmp    801bb1 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801bf4:	85 f6                	test   %esi,%esi
  801bf6:	74 10                	je     801c08 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801bf8:	85 db                	test   %ebx,%ebx
  801bfa:	75 df                	jne    801bdb <ipc_recv+0x4c>
  801bfc:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801c03:	00 00 00 
  801c06:	eb d3                	jmp    801bdb <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801c08:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801c0f:	00 00 00 
  801c12:	eb e4                	jmp    801bf8 <ipc_recv+0x69>

00801c14 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c14:	f3 0f 1e fb          	endbr32 
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	57                   	push   %edi
  801c1c:	56                   	push   %esi
  801c1d:	53                   	push   %ebx
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c24:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801c2a:	85 db                	test   %ebx,%ebx
  801c2c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c31:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801c34:	ff 75 14             	pushl  0x14(%ebp)
  801c37:	53                   	push   %ebx
  801c38:	56                   	push   %esi
  801c39:	57                   	push   %edi
  801c3a:	e8 55 f1 ff ff       	call   800d94 <sys_ipc_try_send>
  801c3f:	83 c4 10             	add    $0x10,%esp
  801c42:	85 c0                	test   %eax,%eax
  801c44:	79 1e                	jns    801c64 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801c46:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c49:	75 07                	jne    801c52 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801c4b:	e8 7c ef ff ff       	call   800bcc <sys_yield>
  801c50:	eb e2                	jmp    801c34 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801c52:	50                   	push   %eax
  801c53:	68 1b 24 80 00       	push   $0x80241b
  801c58:	6a 59                	push   $0x59
  801c5a:	68 36 24 80 00       	push   $0x802436
  801c5f:	e8 e1 fe ff ff       	call   801b45 <_panic>
	}
}
  801c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c67:	5b                   	pop    %ebx
  801c68:	5e                   	pop    %esi
  801c69:	5f                   	pop    %edi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    

00801c6c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c6c:	f3 0f 1e fb          	endbr32 
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c76:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c7b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c7e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c84:	8b 52 50             	mov    0x50(%edx),%edx
  801c87:	39 ca                	cmp    %ecx,%edx
  801c89:	74 11                	je     801c9c <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c8b:	83 c0 01             	add    $0x1,%eax
  801c8e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c93:	75 e6                	jne    801c7b <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c95:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9a:	eb 0b                	jmp    801ca7 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c9c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c9f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ca4:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    

00801ca9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ca9:	f3 0f 1e fb          	endbr32 
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cb3:	89 c2                	mov    %eax,%edx
  801cb5:	c1 ea 16             	shr    $0x16,%edx
  801cb8:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801cbf:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801cc4:	f6 c1 01             	test   $0x1,%cl
  801cc7:	74 1c                	je     801ce5 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801cc9:	c1 e8 0c             	shr    $0xc,%eax
  801ccc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801cd3:	a8 01                	test   $0x1,%al
  801cd5:	74 0e                	je     801ce5 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801cd7:	c1 e8 0c             	shr    $0xc,%eax
  801cda:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801ce1:	ef 
  801ce2:	0f b7 d2             	movzwl %dx,%edx
}
  801ce5:	89 d0                	mov    %edx,%eax
  801ce7:	5d                   	pop    %ebp
  801ce8:	c3                   	ret    
  801ce9:	66 90                	xchg   %ax,%ax
  801ceb:	66 90                	xchg   %ax,%ax
  801ced:	66 90                	xchg   %ax,%ax
  801cef:	90                   	nop

00801cf0 <__udivdi3>:
  801cf0:	f3 0f 1e fb          	endbr32 
  801cf4:	55                   	push   %ebp
  801cf5:	57                   	push   %edi
  801cf6:	56                   	push   %esi
  801cf7:	53                   	push   %ebx
  801cf8:	83 ec 1c             	sub    $0x1c,%esp
  801cfb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801cff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d03:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d07:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d0b:	85 d2                	test   %edx,%edx
  801d0d:	75 19                	jne    801d28 <__udivdi3+0x38>
  801d0f:	39 f3                	cmp    %esi,%ebx
  801d11:	76 4d                	jbe    801d60 <__udivdi3+0x70>
  801d13:	31 ff                	xor    %edi,%edi
  801d15:	89 e8                	mov    %ebp,%eax
  801d17:	89 f2                	mov    %esi,%edx
  801d19:	f7 f3                	div    %ebx
  801d1b:	89 fa                	mov    %edi,%edx
  801d1d:	83 c4 1c             	add    $0x1c,%esp
  801d20:	5b                   	pop    %ebx
  801d21:	5e                   	pop    %esi
  801d22:	5f                   	pop    %edi
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    
  801d25:	8d 76 00             	lea    0x0(%esi),%esi
  801d28:	39 f2                	cmp    %esi,%edx
  801d2a:	76 14                	jbe    801d40 <__udivdi3+0x50>
  801d2c:	31 ff                	xor    %edi,%edi
  801d2e:	31 c0                	xor    %eax,%eax
  801d30:	89 fa                	mov    %edi,%edx
  801d32:	83 c4 1c             	add    $0x1c,%esp
  801d35:	5b                   	pop    %ebx
  801d36:	5e                   	pop    %esi
  801d37:	5f                   	pop    %edi
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    
  801d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d40:	0f bd fa             	bsr    %edx,%edi
  801d43:	83 f7 1f             	xor    $0x1f,%edi
  801d46:	75 48                	jne    801d90 <__udivdi3+0xa0>
  801d48:	39 f2                	cmp    %esi,%edx
  801d4a:	72 06                	jb     801d52 <__udivdi3+0x62>
  801d4c:	31 c0                	xor    %eax,%eax
  801d4e:	39 eb                	cmp    %ebp,%ebx
  801d50:	77 de                	ja     801d30 <__udivdi3+0x40>
  801d52:	b8 01 00 00 00       	mov    $0x1,%eax
  801d57:	eb d7                	jmp    801d30 <__udivdi3+0x40>
  801d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d60:	89 d9                	mov    %ebx,%ecx
  801d62:	85 db                	test   %ebx,%ebx
  801d64:	75 0b                	jne    801d71 <__udivdi3+0x81>
  801d66:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6b:	31 d2                	xor    %edx,%edx
  801d6d:	f7 f3                	div    %ebx
  801d6f:	89 c1                	mov    %eax,%ecx
  801d71:	31 d2                	xor    %edx,%edx
  801d73:	89 f0                	mov    %esi,%eax
  801d75:	f7 f1                	div    %ecx
  801d77:	89 c6                	mov    %eax,%esi
  801d79:	89 e8                	mov    %ebp,%eax
  801d7b:	89 f7                	mov    %esi,%edi
  801d7d:	f7 f1                	div    %ecx
  801d7f:	89 fa                	mov    %edi,%edx
  801d81:	83 c4 1c             	add    $0x1c,%esp
  801d84:	5b                   	pop    %ebx
  801d85:	5e                   	pop    %esi
  801d86:	5f                   	pop    %edi
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    
  801d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d90:	89 f9                	mov    %edi,%ecx
  801d92:	b8 20 00 00 00       	mov    $0x20,%eax
  801d97:	29 f8                	sub    %edi,%eax
  801d99:	d3 e2                	shl    %cl,%edx
  801d9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d9f:	89 c1                	mov    %eax,%ecx
  801da1:	89 da                	mov    %ebx,%edx
  801da3:	d3 ea                	shr    %cl,%edx
  801da5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801da9:	09 d1                	or     %edx,%ecx
  801dab:	89 f2                	mov    %esi,%edx
  801dad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801db1:	89 f9                	mov    %edi,%ecx
  801db3:	d3 e3                	shl    %cl,%ebx
  801db5:	89 c1                	mov    %eax,%ecx
  801db7:	d3 ea                	shr    %cl,%edx
  801db9:	89 f9                	mov    %edi,%ecx
  801dbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801dbf:	89 eb                	mov    %ebp,%ebx
  801dc1:	d3 e6                	shl    %cl,%esi
  801dc3:	89 c1                	mov    %eax,%ecx
  801dc5:	d3 eb                	shr    %cl,%ebx
  801dc7:	09 de                	or     %ebx,%esi
  801dc9:	89 f0                	mov    %esi,%eax
  801dcb:	f7 74 24 08          	divl   0x8(%esp)
  801dcf:	89 d6                	mov    %edx,%esi
  801dd1:	89 c3                	mov    %eax,%ebx
  801dd3:	f7 64 24 0c          	mull   0xc(%esp)
  801dd7:	39 d6                	cmp    %edx,%esi
  801dd9:	72 15                	jb     801df0 <__udivdi3+0x100>
  801ddb:	89 f9                	mov    %edi,%ecx
  801ddd:	d3 e5                	shl    %cl,%ebp
  801ddf:	39 c5                	cmp    %eax,%ebp
  801de1:	73 04                	jae    801de7 <__udivdi3+0xf7>
  801de3:	39 d6                	cmp    %edx,%esi
  801de5:	74 09                	je     801df0 <__udivdi3+0x100>
  801de7:	89 d8                	mov    %ebx,%eax
  801de9:	31 ff                	xor    %edi,%edi
  801deb:	e9 40 ff ff ff       	jmp    801d30 <__udivdi3+0x40>
  801df0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801df3:	31 ff                	xor    %edi,%edi
  801df5:	e9 36 ff ff ff       	jmp    801d30 <__udivdi3+0x40>
  801dfa:	66 90                	xchg   %ax,%ax
  801dfc:	66 90                	xchg   %ax,%ax
  801dfe:	66 90                	xchg   %ax,%ax

00801e00 <__umoddi3>:
  801e00:	f3 0f 1e fb          	endbr32 
  801e04:	55                   	push   %ebp
  801e05:	57                   	push   %edi
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	83 ec 1c             	sub    $0x1c,%esp
  801e0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e13:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	75 19                	jne    801e38 <__umoddi3+0x38>
  801e1f:	39 df                	cmp    %ebx,%edi
  801e21:	76 5d                	jbe    801e80 <__umoddi3+0x80>
  801e23:	89 f0                	mov    %esi,%eax
  801e25:	89 da                	mov    %ebx,%edx
  801e27:	f7 f7                	div    %edi
  801e29:	89 d0                	mov    %edx,%eax
  801e2b:	31 d2                	xor    %edx,%edx
  801e2d:	83 c4 1c             	add    $0x1c,%esp
  801e30:	5b                   	pop    %ebx
  801e31:	5e                   	pop    %esi
  801e32:	5f                   	pop    %edi
  801e33:	5d                   	pop    %ebp
  801e34:	c3                   	ret    
  801e35:	8d 76 00             	lea    0x0(%esi),%esi
  801e38:	89 f2                	mov    %esi,%edx
  801e3a:	39 d8                	cmp    %ebx,%eax
  801e3c:	76 12                	jbe    801e50 <__umoddi3+0x50>
  801e3e:	89 f0                	mov    %esi,%eax
  801e40:	89 da                	mov    %ebx,%edx
  801e42:	83 c4 1c             	add    $0x1c,%esp
  801e45:	5b                   	pop    %ebx
  801e46:	5e                   	pop    %esi
  801e47:	5f                   	pop    %edi
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    
  801e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e50:	0f bd e8             	bsr    %eax,%ebp
  801e53:	83 f5 1f             	xor    $0x1f,%ebp
  801e56:	75 50                	jne    801ea8 <__umoddi3+0xa8>
  801e58:	39 d8                	cmp    %ebx,%eax
  801e5a:	0f 82 e0 00 00 00    	jb     801f40 <__umoddi3+0x140>
  801e60:	89 d9                	mov    %ebx,%ecx
  801e62:	39 f7                	cmp    %esi,%edi
  801e64:	0f 86 d6 00 00 00    	jbe    801f40 <__umoddi3+0x140>
  801e6a:	89 d0                	mov    %edx,%eax
  801e6c:	89 ca                	mov    %ecx,%edx
  801e6e:	83 c4 1c             	add    $0x1c,%esp
  801e71:	5b                   	pop    %ebx
  801e72:	5e                   	pop    %esi
  801e73:	5f                   	pop    %edi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    
  801e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e7d:	8d 76 00             	lea    0x0(%esi),%esi
  801e80:	89 fd                	mov    %edi,%ebp
  801e82:	85 ff                	test   %edi,%edi
  801e84:	75 0b                	jne    801e91 <__umoddi3+0x91>
  801e86:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8b:	31 d2                	xor    %edx,%edx
  801e8d:	f7 f7                	div    %edi
  801e8f:	89 c5                	mov    %eax,%ebp
  801e91:	89 d8                	mov    %ebx,%eax
  801e93:	31 d2                	xor    %edx,%edx
  801e95:	f7 f5                	div    %ebp
  801e97:	89 f0                	mov    %esi,%eax
  801e99:	f7 f5                	div    %ebp
  801e9b:	89 d0                	mov    %edx,%eax
  801e9d:	31 d2                	xor    %edx,%edx
  801e9f:	eb 8c                	jmp    801e2d <__umoddi3+0x2d>
  801ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ea8:	89 e9                	mov    %ebp,%ecx
  801eaa:	ba 20 00 00 00       	mov    $0x20,%edx
  801eaf:	29 ea                	sub    %ebp,%edx
  801eb1:	d3 e0                	shl    %cl,%eax
  801eb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eb7:	89 d1                	mov    %edx,%ecx
  801eb9:	89 f8                	mov    %edi,%eax
  801ebb:	d3 e8                	shr    %cl,%eax
  801ebd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ec1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ec5:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ec9:	09 c1                	or     %eax,%ecx
  801ecb:	89 d8                	mov    %ebx,%eax
  801ecd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ed1:	89 e9                	mov    %ebp,%ecx
  801ed3:	d3 e7                	shl    %cl,%edi
  801ed5:	89 d1                	mov    %edx,%ecx
  801ed7:	d3 e8                	shr    %cl,%eax
  801ed9:	89 e9                	mov    %ebp,%ecx
  801edb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801edf:	d3 e3                	shl    %cl,%ebx
  801ee1:	89 c7                	mov    %eax,%edi
  801ee3:	89 d1                	mov    %edx,%ecx
  801ee5:	89 f0                	mov    %esi,%eax
  801ee7:	d3 e8                	shr    %cl,%eax
  801ee9:	89 e9                	mov    %ebp,%ecx
  801eeb:	89 fa                	mov    %edi,%edx
  801eed:	d3 e6                	shl    %cl,%esi
  801eef:	09 d8                	or     %ebx,%eax
  801ef1:	f7 74 24 08          	divl   0x8(%esp)
  801ef5:	89 d1                	mov    %edx,%ecx
  801ef7:	89 f3                	mov    %esi,%ebx
  801ef9:	f7 64 24 0c          	mull   0xc(%esp)
  801efd:	89 c6                	mov    %eax,%esi
  801eff:	89 d7                	mov    %edx,%edi
  801f01:	39 d1                	cmp    %edx,%ecx
  801f03:	72 06                	jb     801f0b <__umoddi3+0x10b>
  801f05:	75 10                	jne    801f17 <__umoddi3+0x117>
  801f07:	39 c3                	cmp    %eax,%ebx
  801f09:	73 0c                	jae    801f17 <__umoddi3+0x117>
  801f0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801f0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801f13:	89 d7                	mov    %edx,%edi
  801f15:	89 c6                	mov    %eax,%esi
  801f17:	89 ca                	mov    %ecx,%edx
  801f19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f1e:	29 f3                	sub    %esi,%ebx
  801f20:	19 fa                	sbb    %edi,%edx
  801f22:	89 d0                	mov    %edx,%eax
  801f24:	d3 e0                	shl    %cl,%eax
  801f26:	89 e9                	mov    %ebp,%ecx
  801f28:	d3 eb                	shr    %cl,%ebx
  801f2a:	d3 ea                	shr    %cl,%edx
  801f2c:	09 d8                	or     %ebx,%eax
  801f2e:	83 c4 1c             	add    $0x1c,%esp
  801f31:	5b                   	pop    %ebx
  801f32:	5e                   	pop    %esi
  801f33:	5f                   	pop    %edi
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    
  801f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f3d:	8d 76 00             	lea    0x0(%esi),%esi
  801f40:	29 fe                	sub    %edi,%esi
  801f42:	19 c3                	sbb    %eax,%ebx
  801f44:	89 f2                	mov    %esi,%edx
  801f46:	89 d9                	mov    %ebx,%ecx
  801f48:	e9 1d ff ff ff       	jmp    801e6a <__umoddi3+0x6a>
