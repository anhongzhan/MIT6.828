
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
  80003e:	a1 08 40 80 00       	mov    0x804008,%eax
  800043:	8b 40 48             	mov    0x48(%eax),%eax
  800046:	50                   	push   %eax
  800047:	68 c0 24 80 00       	push   $0x8024c0
  80004c:	e8 52 01 00 00       	call   8001a3 <cprintf>
  800051:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800054:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800059:	e8 6e 0b 00 00       	call   800bcc <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005e:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  800063:	8b 40 48             	mov    0x48(%eax),%eax
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	53                   	push   %ebx
  80006a:	50                   	push   %eax
  80006b:	68 e0 24 80 00       	push   $0x8024e0
  800070:	e8 2e 01 00 00       	call   8001a3 <cprintf>
	for (i = 0; i < 5; i++) {
  800075:	83 c3 01             	add    $0x1,%ebx
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	83 fb 05             	cmp    $0x5,%ebx
  80007e:	75 d9                	jne    800059 <umain+0x26>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800080:	a1 08 40 80 00       	mov    0x804008,%eax
  800085:	8b 40 48             	mov    0x48(%eax),%eax
  800088:	83 ec 08             	sub    $0x8,%esp
  80008b:	50                   	push   %eax
  80008c:	68 0c 25 80 00       	push   $0x80250c
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
  8000bf:	a3 08 40 80 00       	mov    %eax,0x804008

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
  8000f2:	e8 ac 0f 00 00       	call   8010a3 <close_all>
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
  800209:	e8 52 20 00 00       	call   802260 <__udivdi3>
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
  800247:	e8 24 21 00 00       	call   802370 <__umoddi3>
  80024c:	83 c4 14             	add    $0x14,%esp
  80024f:	0f be 80 35 25 80 00 	movsbl 0x802535(%eax),%eax
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
  8002f6:	3e ff 24 85 80 26 80 	notrack jmp *0x802680(,%eax,4)
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
  8003c3:	8b 14 85 e0 27 80 00 	mov    0x8027e0(,%eax,4),%edx
  8003ca:	85 d2                	test   %edx,%edx
  8003cc:	74 18                	je     8003e6 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003ce:	52                   	push   %edx
  8003cf:	68 15 29 80 00       	push   $0x802915
  8003d4:	53                   	push   %ebx
  8003d5:	56                   	push   %esi
  8003d6:	e8 aa fe ff ff       	call   800285 <printfmt>
  8003db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003de:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e1:	e9 66 02 00 00       	jmp    80064c <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003e6:	50                   	push   %eax
  8003e7:	68 4d 25 80 00       	push   $0x80254d
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
  80040e:	b8 46 25 80 00       	mov    $0x802546,%eax
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
  800b98:	68 3f 28 80 00       	push   $0x80283f
  800b9d:	6a 23                	push   $0x23
  800b9f:	68 5c 28 80 00       	push   $0x80285c
  800ba4:	e8 08 15 00 00       	call   8020b1 <_panic>

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
  800c25:	68 3f 28 80 00       	push   $0x80283f
  800c2a:	6a 23                	push   $0x23
  800c2c:	68 5c 28 80 00       	push   $0x80285c
  800c31:	e8 7b 14 00 00       	call   8020b1 <_panic>

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
  800c6b:	68 3f 28 80 00       	push   $0x80283f
  800c70:	6a 23                	push   $0x23
  800c72:	68 5c 28 80 00       	push   $0x80285c
  800c77:	e8 35 14 00 00       	call   8020b1 <_panic>

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
  800cb1:	68 3f 28 80 00       	push   $0x80283f
  800cb6:	6a 23                	push   $0x23
  800cb8:	68 5c 28 80 00       	push   $0x80285c
  800cbd:	e8 ef 13 00 00       	call   8020b1 <_panic>

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
  800cf7:	68 3f 28 80 00       	push   $0x80283f
  800cfc:	6a 23                	push   $0x23
  800cfe:	68 5c 28 80 00       	push   $0x80285c
  800d03:	e8 a9 13 00 00       	call   8020b1 <_panic>

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
  800d3d:	68 3f 28 80 00       	push   $0x80283f
  800d42:	6a 23                	push   $0x23
  800d44:	68 5c 28 80 00       	push   $0x80285c
  800d49:	e8 63 13 00 00       	call   8020b1 <_panic>

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
  800d83:	68 3f 28 80 00       	push   $0x80283f
  800d88:	6a 23                	push   $0x23
  800d8a:	68 5c 28 80 00       	push   $0x80285c
  800d8f:	e8 1d 13 00 00       	call   8020b1 <_panic>

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
  800def:	68 3f 28 80 00       	push   $0x80283f
  800df4:	6a 23                	push   $0x23
  800df6:	68 5c 28 80 00       	push   $0x80285c
  800dfb:	e8 b1 12 00 00       	call   8020b1 <_panic>

00800e00 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e00:	f3 0f 1e fb          	endbr32 
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e14:	89 d1                	mov    %edx,%ecx
  800e16:	89 d3                	mov    %edx,%ebx
  800e18:	89 d7                	mov    %edx,%edi
  800e1a:	89 d6                	mov    %edx,%esi
  800e1c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800e23:	f3 0f 1e fb          	endbr32 
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
  800e2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e35:	8b 55 08             	mov    0x8(%ebp),%edx
  800e38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e40:	89 df                	mov    %ebx,%edi
  800e42:	89 de                	mov    %ebx,%esi
  800e44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	7f 08                	jg     800e52 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	83 ec 0c             	sub    $0xc,%esp
  800e55:	50                   	push   %eax
  800e56:	6a 0f                	push   $0xf
  800e58:	68 3f 28 80 00       	push   $0x80283f
  800e5d:	6a 23                	push   $0x23
  800e5f:	68 5c 28 80 00       	push   $0x80285c
  800e64:	e8 48 12 00 00       	call   8020b1 <_panic>

00800e69 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800e69:	f3 0f 1e fb          	endbr32 
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	57                   	push   %edi
  800e71:	56                   	push   %esi
  800e72:	53                   	push   %ebx
  800e73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e81:	b8 10 00 00 00       	mov    $0x10,%eax
  800e86:	89 df                	mov    %ebx,%edi
  800e88:	89 de                	mov    %ebx,%esi
  800e8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8c:	85 c0                	test   %eax,%eax
  800e8e:	7f 08                	jg     800e98 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e93:	5b                   	pop    %ebx
  800e94:	5e                   	pop    %esi
  800e95:	5f                   	pop    %edi
  800e96:	5d                   	pop    %ebp
  800e97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e98:	83 ec 0c             	sub    $0xc,%esp
  800e9b:	50                   	push   %eax
  800e9c:	6a 10                	push   $0x10
  800e9e:	68 3f 28 80 00       	push   $0x80283f
  800ea3:	6a 23                	push   $0x23
  800ea5:	68 5c 28 80 00       	push   $0x80285c
  800eaa:	e8 02 12 00 00       	call   8020b1 <_panic>

00800eaf <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800eaf:	f3 0f 1e fb          	endbr32 
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	05 00 00 00 30       	add    $0x30000000,%eax
  800ebe:	c1 e8 0c             	shr    $0xc,%eax
}
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ec3:	f3 0f 1e fb          	endbr32 
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ed2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ed7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800edc:	5d                   	pop    %ebp
  800edd:	c3                   	ret    

00800ede <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ede:	f3 0f 1e fb          	endbr32 
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800eea:	89 c2                	mov    %eax,%edx
  800eec:	c1 ea 16             	shr    $0x16,%edx
  800eef:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ef6:	f6 c2 01             	test   $0x1,%dl
  800ef9:	74 2d                	je     800f28 <fd_alloc+0x4a>
  800efb:	89 c2                	mov    %eax,%edx
  800efd:	c1 ea 0c             	shr    $0xc,%edx
  800f00:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f07:	f6 c2 01             	test   $0x1,%dl
  800f0a:	74 1c                	je     800f28 <fd_alloc+0x4a>
  800f0c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f11:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f16:	75 d2                	jne    800eea <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f21:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f26:	eb 0a                	jmp    800f32 <fd_alloc+0x54>
			*fd_store = fd;
  800f28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2b:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    

00800f34 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f34:	f3 0f 1e fb          	endbr32 
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f3e:	83 f8 1f             	cmp    $0x1f,%eax
  800f41:	77 30                	ja     800f73 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f43:	c1 e0 0c             	shl    $0xc,%eax
  800f46:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f4b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f51:	f6 c2 01             	test   $0x1,%dl
  800f54:	74 24                	je     800f7a <fd_lookup+0x46>
  800f56:	89 c2                	mov    %eax,%edx
  800f58:	c1 ea 0c             	shr    $0xc,%edx
  800f5b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f62:	f6 c2 01             	test   $0x1,%dl
  800f65:	74 1a                	je     800f81 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6a:	89 02                	mov    %eax,(%edx)
	return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    
		return -E_INVAL;
  800f73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f78:	eb f7                	jmp    800f71 <fd_lookup+0x3d>
		return -E_INVAL;
  800f7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7f:	eb f0                	jmp    800f71 <fd_lookup+0x3d>
  800f81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f86:	eb e9                	jmp    800f71 <fd_lookup+0x3d>

00800f88 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f88:	f3 0f 1e fb          	endbr32 
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f95:	ba 00 00 00 00       	mov    $0x0,%edx
  800f9a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f9f:	39 08                	cmp    %ecx,(%eax)
  800fa1:	74 38                	je     800fdb <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800fa3:	83 c2 01             	add    $0x1,%edx
  800fa6:	8b 04 95 e8 28 80 00 	mov    0x8028e8(,%edx,4),%eax
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 ee                	jne    800f9f <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fb1:	a1 08 40 80 00       	mov    0x804008,%eax
  800fb6:	8b 40 48             	mov    0x48(%eax),%eax
  800fb9:	83 ec 04             	sub    $0x4,%esp
  800fbc:	51                   	push   %ecx
  800fbd:	50                   	push   %eax
  800fbe:	68 6c 28 80 00       	push   $0x80286c
  800fc3:	e8 db f1 ff ff       	call   8001a3 <cprintf>
	*dev = 0;
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    
			*dev = devtab[i];
  800fdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fde:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe5:	eb f2                	jmp    800fd9 <dev_lookup+0x51>

00800fe7 <fd_close>:
{
  800fe7:	f3 0f 1e fb          	endbr32 
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
  800ff1:	83 ec 24             	sub    $0x24,%esp
  800ff4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ff7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ffa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ffd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ffe:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801004:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801007:	50                   	push   %eax
  801008:	e8 27 ff ff ff       	call   800f34 <fd_lookup>
  80100d:	89 c3                	mov    %eax,%ebx
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	85 c0                	test   %eax,%eax
  801014:	78 05                	js     80101b <fd_close+0x34>
	    || fd != fd2)
  801016:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801019:	74 16                	je     801031 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80101b:	89 f8                	mov    %edi,%eax
  80101d:	84 c0                	test   %al,%al
  80101f:	b8 00 00 00 00       	mov    $0x0,%eax
  801024:	0f 44 d8             	cmove  %eax,%ebx
}
  801027:	89 d8                	mov    %ebx,%eax
  801029:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801037:	50                   	push   %eax
  801038:	ff 36                	pushl  (%esi)
  80103a:	e8 49 ff ff ff       	call   800f88 <dev_lookup>
  80103f:	89 c3                	mov    %eax,%ebx
  801041:	83 c4 10             	add    $0x10,%esp
  801044:	85 c0                	test   %eax,%eax
  801046:	78 1a                	js     801062 <fd_close+0x7b>
		if (dev->dev_close)
  801048:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80104b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80104e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801053:	85 c0                	test   %eax,%eax
  801055:	74 0b                	je     801062 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801057:	83 ec 0c             	sub    $0xc,%esp
  80105a:	56                   	push   %esi
  80105b:	ff d0                	call   *%eax
  80105d:	89 c3                	mov    %eax,%ebx
  80105f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	56                   	push   %esi
  801066:	6a 00                	push   $0x0
  801068:	e8 0f fc ff ff       	call   800c7c <sys_page_unmap>
	return r;
  80106d:	83 c4 10             	add    $0x10,%esp
  801070:	eb b5                	jmp    801027 <fd_close+0x40>

00801072 <close>:

int
close(int fdnum)
{
  801072:	f3 0f 1e fb          	endbr32 
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80107c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80107f:	50                   	push   %eax
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 ac fe ff ff       	call   800f34 <fd_lookup>
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	85 c0                	test   %eax,%eax
  80108d:	79 02                	jns    801091 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80108f:	c9                   	leave  
  801090:	c3                   	ret    
		return fd_close(fd, 1);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	6a 01                	push   $0x1
  801096:	ff 75 f4             	pushl  -0xc(%ebp)
  801099:	e8 49 ff ff ff       	call   800fe7 <fd_close>
  80109e:	83 c4 10             	add    $0x10,%esp
  8010a1:	eb ec                	jmp    80108f <close+0x1d>

008010a3 <close_all>:

void
close_all(void)
{
  8010a3:	f3 0f 1e fb          	endbr32 
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	53                   	push   %ebx
  8010ab:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010ae:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	53                   	push   %ebx
  8010b7:	e8 b6 ff ff ff       	call   801072 <close>
	for (i = 0; i < MAXFD; i++)
  8010bc:	83 c3 01             	add    $0x1,%ebx
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	83 fb 20             	cmp    $0x20,%ebx
  8010c5:	75 ec                	jne    8010b3 <close_all+0x10>
}
  8010c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ca:	c9                   	leave  
  8010cb:	c3                   	ret    

008010cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010cc:	f3 0f 1e fb          	endbr32 
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	57                   	push   %edi
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	ff 75 08             	pushl  0x8(%ebp)
  8010e0:	e8 4f fe ff ff       	call   800f34 <fd_lookup>
  8010e5:	89 c3                	mov    %eax,%ebx
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	0f 88 81 00 00 00    	js     801173 <dup+0xa7>
		return r;
	close(newfdnum);
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	ff 75 0c             	pushl  0xc(%ebp)
  8010f8:	e8 75 ff ff ff       	call   801072 <close>

	newfd = INDEX2FD(newfdnum);
  8010fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  801100:	c1 e6 0c             	shl    $0xc,%esi
  801103:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801109:	83 c4 04             	add    $0x4,%esp
  80110c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110f:	e8 af fd ff ff       	call   800ec3 <fd2data>
  801114:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801116:	89 34 24             	mov    %esi,(%esp)
  801119:	e8 a5 fd ff ff       	call   800ec3 <fd2data>
  80111e:	83 c4 10             	add    $0x10,%esp
  801121:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801123:	89 d8                	mov    %ebx,%eax
  801125:	c1 e8 16             	shr    $0x16,%eax
  801128:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80112f:	a8 01                	test   $0x1,%al
  801131:	74 11                	je     801144 <dup+0x78>
  801133:	89 d8                	mov    %ebx,%eax
  801135:	c1 e8 0c             	shr    $0xc,%eax
  801138:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80113f:	f6 c2 01             	test   $0x1,%dl
  801142:	75 39                	jne    80117d <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801144:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801147:	89 d0                	mov    %edx,%eax
  801149:	c1 e8 0c             	shr    $0xc,%eax
  80114c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	25 07 0e 00 00       	and    $0xe07,%eax
  80115b:	50                   	push   %eax
  80115c:	56                   	push   %esi
  80115d:	6a 00                	push   $0x0
  80115f:	52                   	push   %edx
  801160:	6a 00                	push   $0x0
  801162:	e8 cf fa ff ff       	call   800c36 <sys_page_map>
  801167:	89 c3                	mov    %eax,%ebx
  801169:	83 c4 20             	add    $0x20,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	78 31                	js     8011a1 <dup+0xd5>
		goto err;

	return newfdnum;
  801170:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801173:	89 d8                	mov    %ebx,%eax
  801175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801178:	5b                   	pop    %ebx
  801179:	5e                   	pop    %esi
  80117a:	5f                   	pop    %edi
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80117d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801184:	83 ec 0c             	sub    $0xc,%esp
  801187:	25 07 0e 00 00       	and    $0xe07,%eax
  80118c:	50                   	push   %eax
  80118d:	57                   	push   %edi
  80118e:	6a 00                	push   $0x0
  801190:	53                   	push   %ebx
  801191:	6a 00                	push   $0x0
  801193:	e8 9e fa ff ff       	call   800c36 <sys_page_map>
  801198:	89 c3                	mov    %eax,%ebx
  80119a:	83 c4 20             	add    $0x20,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	79 a3                	jns    801144 <dup+0x78>
	sys_page_unmap(0, newfd);
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	56                   	push   %esi
  8011a5:	6a 00                	push   $0x0
  8011a7:	e8 d0 fa ff ff       	call   800c7c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011ac:	83 c4 08             	add    $0x8,%esp
  8011af:	57                   	push   %edi
  8011b0:	6a 00                	push   $0x0
  8011b2:	e8 c5 fa ff ff       	call   800c7c <sys_page_unmap>
	return r;
  8011b7:	83 c4 10             	add    $0x10,%esp
  8011ba:	eb b7                	jmp    801173 <dup+0xa7>

008011bc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011bc:	f3 0f 1e fb          	endbr32 
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	53                   	push   %ebx
  8011c4:	83 ec 1c             	sub    $0x1c,%esp
  8011c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011cd:	50                   	push   %eax
  8011ce:	53                   	push   %ebx
  8011cf:	e8 60 fd ff ff       	call   800f34 <fd_lookup>
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	78 3f                	js     80121a <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e1:	50                   	push   %eax
  8011e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e5:	ff 30                	pushl  (%eax)
  8011e7:	e8 9c fd ff ff       	call   800f88 <dev_lookup>
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	78 27                	js     80121a <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011f6:	8b 42 08             	mov    0x8(%edx),%eax
  8011f9:	83 e0 03             	and    $0x3,%eax
  8011fc:	83 f8 01             	cmp    $0x1,%eax
  8011ff:	74 1e                	je     80121f <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801204:	8b 40 08             	mov    0x8(%eax),%eax
  801207:	85 c0                	test   %eax,%eax
  801209:	74 35                	je     801240 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	ff 75 10             	pushl  0x10(%ebp)
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	52                   	push   %edx
  801215:	ff d0                	call   *%eax
  801217:	83 c4 10             	add    $0x10,%esp
}
  80121a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80121f:	a1 08 40 80 00       	mov    0x804008,%eax
  801224:	8b 40 48             	mov    0x48(%eax),%eax
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	53                   	push   %ebx
  80122b:	50                   	push   %eax
  80122c:	68 ad 28 80 00       	push   $0x8028ad
  801231:	e8 6d ef ff ff       	call   8001a3 <cprintf>
		return -E_INVAL;
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123e:	eb da                	jmp    80121a <read+0x5e>
		return -E_NOT_SUPP;
  801240:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801245:	eb d3                	jmp    80121a <read+0x5e>

00801247 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801247:	f3 0f 1e fb          	endbr32 
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	57                   	push   %edi
  80124f:	56                   	push   %esi
  801250:	53                   	push   %ebx
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	8b 7d 08             	mov    0x8(%ebp),%edi
  801257:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80125a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80125f:	eb 02                	jmp    801263 <readn+0x1c>
  801261:	01 c3                	add    %eax,%ebx
  801263:	39 f3                	cmp    %esi,%ebx
  801265:	73 21                	jae    801288 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	89 f0                	mov    %esi,%eax
  80126c:	29 d8                	sub    %ebx,%eax
  80126e:	50                   	push   %eax
  80126f:	89 d8                	mov    %ebx,%eax
  801271:	03 45 0c             	add    0xc(%ebp),%eax
  801274:	50                   	push   %eax
  801275:	57                   	push   %edi
  801276:	e8 41 ff ff ff       	call   8011bc <read>
		if (m < 0)
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 04                	js     801286 <readn+0x3f>
			return m;
		if (m == 0)
  801282:	75 dd                	jne    801261 <readn+0x1a>
  801284:	eb 02                	jmp    801288 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801286:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801288:	89 d8                	mov    %ebx,%eax
  80128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128d:	5b                   	pop    %ebx
  80128e:	5e                   	pop    %esi
  80128f:	5f                   	pop    %edi
  801290:	5d                   	pop    %ebp
  801291:	c3                   	ret    

00801292 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801292:	f3 0f 1e fb          	endbr32 
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	53                   	push   %ebx
  80129a:	83 ec 1c             	sub    $0x1c,%esp
  80129d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	53                   	push   %ebx
  8012a5:	e8 8a fc ff ff       	call   800f34 <fd_lookup>
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	78 3a                	js     8012eb <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b1:	83 ec 08             	sub    $0x8,%esp
  8012b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b7:	50                   	push   %eax
  8012b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bb:	ff 30                	pushl  (%eax)
  8012bd:	e8 c6 fc ff ff       	call   800f88 <dev_lookup>
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	78 22                	js     8012eb <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012d0:	74 1e                	je     8012f0 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d5:	8b 52 0c             	mov    0xc(%edx),%edx
  8012d8:	85 d2                	test   %edx,%edx
  8012da:	74 35                	je     801311 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012dc:	83 ec 04             	sub    $0x4,%esp
  8012df:	ff 75 10             	pushl  0x10(%ebp)
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	50                   	push   %eax
  8012e6:	ff d2                	call   *%edx
  8012e8:	83 c4 10             	add    $0x10,%esp
}
  8012eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f0:	a1 08 40 80 00       	mov    0x804008,%eax
  8012f5:	8b 40 48             	mov    0x48(%eax),%eax
  8012f8:	83 ec 04             	sub    $0x4,%esp
  8012fb:	53                   	push   %ebx
  8012fc:	50                   	push   %eax
  8012fd:	68 c9 28 80 00       	push   $0x8028c9
  801302:	e8 9c ee ff ff       	call   8001a3 <cprintf>
		return -E_INVAL;
  801307:	83 c4 10             	add    $0x10,%esp
  80130a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130f:	eb da                	jmp    8012eb <write+0x59>
		return -E_NOT_SUPP;
  801311:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801316:	eb d3                	jmp    8012eb <write+0x59>

00801318 <seek>:

int
seek(int fdnum, off_t offset)
{
  801318:	f3 0f 1e fb          	endbr32 
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801322:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801325:	50                   	push   %eax
  801326:	ff 75 08             	pushl  0x8(%ebp)
  801329:	e8 06 fc ff ff       	call   800f34 <fd_lookup>
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	78 0e                	js     801343 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801335:	8b 55 0c             	mov    0xc(%ebp),%edx
  801338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80133e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801345:	f3 0f 1e fb          	endbr32 
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	53                   	push   %ebx
  80134d:	83 ec 1c             	sub    $0x1c,%esp
  801350:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801353:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801356:	50                   	push   %eax
  801357:	53                   	push   %ebx
  801358:	e8 d7 fb ff ff       	call   800f34 <fd_lookup>
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	85 c0                	test   %eax,%eax
  801362:	78 37                	js     80139b <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801364:	83 ec 08             	sub    $0x8,%esp
  801367:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136a:	50                   	push   %eax
  80136b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136e:	ff 30                	pushl  (%eax)
  801370:	e8 13 fc ff ff       	call   800f88 <dev_lookup>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 1f                	js     80139b <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80137c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801383:	74 1b                	je     8013a0 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801388:	8b 52 18             	mov    0x18(%edx),%edx
  80138b:	85 d2                	test   %edx,%edx
  80138d:	74 32                	je     8013c1 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80138f:	83 ec 08             	sub    $0x8,%esp
  801392:	ff 75 0c             	pushl  0xc(%ebp)
  801395:	50                   	push   %eax
  801396:	ff d2                	call   *%edx
  801398:	83 c4 10             	add    $0x10,%esp
}
  80139b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013a0:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013a5:	8b 40 48             	mov    0x48(%eax),%eax
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	53                   	push   %ebx
  8013ac:	50                   	push   %eax
  8013ad:	68 8c 28 80 00       	push   $0x80288c
  8013b2:	e8 ec ed ff ff       	call   8001a3 <cprintf>
		return -E_INVAL;
  8013b7:	83 c4 10             	add    $0x10,%esp
  8013ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bf:	eb da                	jmp    80139b <ftruncate+0x56>
		return -E_NOT_SUPP;
  8013c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c6:	eb d3                	jmp    80139b <ftruncate+0x56>

008013c8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013c8:	f3 0f 1e fb          	endbr32 
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	53                   	push   %ebx
  8013d0:	83 ec 1c             	sub    $0x1c,%esp
  8013d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	e8 52 fb ff ff       	call   800f34 <fd_lookup>
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	78 4b                	js     801434 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e9:	83 ec 08             	sub    $0x8,%esp
  8013ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ef:	50                   	push   %eax
  8013f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f3:	ff 30                	pushl  (%eax)
  8013f5:	e8 8e fb ff ff       	call   800f88 <dev_lookup>
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 33                	js     801434 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801404:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801408:	74 2f                	je     801439 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80140a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80140d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801414:	00 00 00 
	stat->st_isdir = 0;
  801417:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80141e:	00 00 00 
	stat->st_dev = dev;
  801421:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801427:	83 ec 08             	sub    $0x8,%esp
  80142a:	53                   	push   %ebx
  80142b:	ff 75 f0             	pushl  -0x10(%ebp)
  80142e:	ff 50 14             	call   *0x14(%eax)
  801431:	83 c4 10             	add    $0x10,%esp
}
  801434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801437:	c9                   	leave  
  801438:	c3                   	ret    
		return -E_NOT_SUPP;
  801439:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80143e:	eb f4                	jmp    801434 <fstat+0x6c>

00801440 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801440:	f3 0f 1e fb          	endbr32 
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	56                   	push   %esi
  801448:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801449:	83 ec 08             	sub    $0x8,%esp
  80144c:	6a 00                	push   $0x0
  80144e:	ff 75 08             	pushl  0x8(%ebp)
  801451:	e8 fb 01 00 00       	call   801651 <open>
  801456:	89 c3                	mov    %eax,%ebx
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	85 c0                	test   %eax,%eax
  80145d:	78 1b                	js     80147a <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80145f:	83 ec 08             	sub    $0x8,%esp
  801462:	ff 75 0c             	pushl  0xc(%ebp)
  801465:	50                   	push   %eax
  801466:	e8 5d ff ff ff       	call   8013c8 <fstat>
  80146b:	89 c6                	mov    %eax,%esi
	close(fd);
  80146d:	89 1c 24             	mov    %ebx,(%esp)
  801470:	e8 fd fb ff ff       	call   801072 <close>
	return r;
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	89 f3                	mov    %esi,%ebx
}
  80147a:	89 d8                	mov    %ebx,%eax
  80147c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80147f:	5b                   	pop    %ebx
  801480:	5e                   	pop    %esi
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    

00801483 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	56                   	push   %esi
  801487:	53                   	push   %ebx
  801488:	89 c6                	mov    %eax,%esi
  80148a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80148c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801493:	74 27                	je     8014bc <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801495:	6a 07                	push   $0x7
  801497:	68 00 50 80 00       	push   $0x805000
  80149c:	56                   	push   %esi
  80149d:	ff 35 00 40 80 00    	pushl  0x804000
  8014a3:	e8 d8 0c 00 00       	call   802180 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014a8:	83 c4 0c             	add    $0xc,%esp
  8014ab:	6a 00                	push   $0x0
  8014ad:	53                   	push   %ebx
  8014ae:	6a 00                	push   $0x0
  8014b0:	e8 46 0c 00 00       	call   8020fb <ipc_recv>
}
  8014b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b8:	5b                   	pop    %ebx
  8014b9:	5e                   	pop    %esi
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	6a 01                	push   $0x1
  8014c1:	e8 12 0d 00 00       	call   8021d8 <ipc_find_env>
  8014c6:	a3 00 40 80 00       	mov    %eax,0x804000
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	eb c5                	jmp    801495 <fsipc+0x12>

008014d0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014d0:	f3 0f 1e fb          	endbr32 
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8014e0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f2:	b8 02 00 00 00       	mov    $0x2,%eax
  8014f7:	e8 87 ff ff ff       	call   801483 <fsipc>
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <devfile_flush>:
{
  8014fe:	f3 0f 1e fb          	endbr32 
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	8b 40 0c             	mov    0xc(%eax),%eax
  80150e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801513:	ba 00 00 00 00       	mov    $0x0,%edx
  801518:	b8 06 00 00 00       	mov    $0x6,%eax
  80151d:	e8 61 ff ff ff       	call   801483 <fsipc>
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <devfile_stat>:
{
  801524:	f3 0f 1e fb          	endbr32 
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	53                   	push   %ebx
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8b 40 0c             	mov    0xc(%eax),%eax
  801538:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80153d:	ba 00 00 00 00       	mov    $0x0,%edx
  801542:	b8 05 00 00 00       	mov    $0x5,%eax
  801547:	e8 37 ff ff ff       	call   801483 <fsipc>
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 2c                	js     80157c <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	68 00 50 80 00       	push   $0x805000
  801558:	53                   	push   %ebx
  801559:	e8 4f f2 ff ff       	call   8007ad <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80155e:	a1 80 50 80 00       	mov    0x805080,%eax
  801563:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801569:	a1 84 50 80 00       	mov    0x805084,%eax
  80156e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801574:	83 c4 10             	add    $0x10,%esp
  801577:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <devfile_write>:
{
  801581:	f3 0f 1e fb          	endbr32 
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 0c             	sub    $0xc,%esp
  80158b:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80158e:	8b 55 08             	mov    0x8(%ebp),%edx
  801591:	8b 52 0c             	mov    0xc(%edx),%edx
  801594:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80159a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80159f:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8015a4:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8015a7:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8015ac:	50                   	push   %eax
  8015ad:	ff 75 0c             	pushl  0xc(%ebp)
  8015b0:	68 08 50 80 00       	push   $0x805008
  8015b5:	e8 a9 f3 ff ff       	call   800963 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8015ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bf:	b8 04 00 00 00       	mov    $0x4,%eax
  8015c4:	e8 ba fe ff ff       	call   801483 <fsipc>
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <devfile_read>:
{
  8015cb:	f3 0f 1e fb          	endbr32 
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	56                   	push   %esi
  8015d3:	53                   	push   %ebx
  8015d4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	8b 40 0c             	mov    0xc(%eax),%eax
  8015dd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015e2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8015f2:	e8 8c fe ff ff       	call   801483 <fsipc>
  8015f7:	89 c3                	mov    %eax,%ebx
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	78 1f                	js     80161c <devfile_read+0x51>
	assert(r <= n);
  8015fd:	39 f0                	cmp    %esi,%eax
  8015ff:	77 24                	ja     801625 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801601:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801606:	7f 33                	jg     80163b <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	50                   	push   %eax
  80160c:	68 00 50 80 00       	push   $0x805000
  801611:	ff 75 0c             	pushl  0xc(%ebp)
  801614:	e8 4a f3 ff ff       	call   800963 <memmove>
	return r;
  801619:	83 c4 10             	add    $0x10,%esp
}
  80161c:	89 d8                	mov    %ebx,%eax
  80161e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801621:	5b                   	pop    %ebx
  801622:	5e                   	pop    %esi
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    
	assert(r <= n);
  801625:	68 fc 28 80 00       	push   $0x8028fc
  80162a:	68 03 29 80 00       	push   $0x802903
  80162f:	6a 7c                	push   $0x7c
  801631:	68 18 29 80 00       	push   $0x802918
  801636:	e8 76 0a 00 00       	call   8020b1 <_panic>
	assert(r <= PGSIZE);
  80163b:	68 23 29 80 00       	push   $0x802923
  801640:	68 03 29 80 00       	push   $0x802903
  801645:	6a 7d                	push   $0x7d
  801647:	68 18 29 80 00       	push   $0x802918
  80164c:	e8 60 0a 00 00       	call   8020b1 <_panic>

00801651 <open>:
{
  801651:	f3 0f 1e fb          	endbr32 
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	56                   	push   %esi
  801659:	53                   	push   %ebx
  80165a:	83 ec 1c             	sub    $0x1c,%esp
  80165d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801660:	56                   	push   %esi
  801661:	e8 04 f1 ff ff       	call   80076a <strlen>
  801666:	83 c4 10             	add    $0x10,%esp
  801669:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80166e:	7f 6c                	jg     8016dc <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801676:	50                   	push   %eax
  801677:	e8 62 f8 ff ff       	call   800ede <fd_alloc>
  80167c:	89 c3                	mov    %eax,%ebx
  80167e:	83 c4 10             	add    $0x10,%esp
  801681:	85 c0                	test   %eax,%eax
  801683:	78 3c                	js     8016c1 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	56                   	push   %esi
  801689:	68 00 50 80 00       	push   $0x805000
  80168e:	e8 1a f1 ff ff       	call   8007ad <strcpy>
	fsipcbuf.open.req_omode = mode;
  801693:	8b 45 0c             	mov    0xc(%ebp),%eax
  801696:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80169b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169e:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a3:	e8 db fd ff ff       	call   801483 <fsipc>
  8016a8:	89 c3                	mov    %eax,%ebx
  8016aa:	83 c4 10             	add    $0x10,%esp
  8016ad:	85 c0                	test   %eax,%eax
  8016af:	78 19                	js     8016ca <open+0x79>
	return fd2num(fd);
  8016b1:	83 ec 0c             	sub    $0xc,%esp
  8016b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8016b7:	e8 f3 f7 ff ff       	call   800eaf <fd2num>
  8016bc:	89 c3                	mov    %eax,%ebx
  8016be:	83 c4 10             	add    $0x10,%esp
}
  8016c1:	89 d8                	mov    %ebx,%eax
  8016c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c6:	5b                   	pop    %ebx
  8016c7:	5e                   	pop    %esi
  8016c8:	5d                   	pop    %ebp
  8016c9:	c3                   	ret    
		fd_close(fd, 0);
  8016ca:	83 ec 08             	sub    $0x8,%esp
  8016cd:	6a 00                	push   $0x0
  8016cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d2:	e8 10 f9 ff ff       	call   800fe7 <fd_close>
		return r;
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	eb e5                	jmp    8016c1 <open+0x70>
		return -E_BAD_PATH;
  8016dc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016e1:	eb de                	jmp    8016c1 <open+0x70>

008016e3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016e3:	f3 0f 1e fb          	endbr32 
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8016f7:	e8 87 fd ff ff       	call   801483 <fsipc>
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8016fe:	f3 0f 1e fb          	endbr32 
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801708:	68 2f 29 80 00       	push   $0x80292f
  80170d:	ff 75 0c             	pushl  0xc(%ebp)
  801710:	e8 98 f0 ff ff       	call   8007ad <strcpy>
	return 0;
}
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <devsock_close>:
{
  80171c:	f3 0f 1e fb          	endbr32 
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	53                   	push   %ebx
  801724:	83 ec 10             	sub    $0x10,%esp
  801727:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80172a:	53                   	push   %ebx
  80172b:	e8 e5 0a 00 00       	call   802215 <pageref>
  801730:	89 c2                	mov    %eax,%edx
  801732:	83 c4 10             	add    $0x10,%esp
		return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  80173a:	83 fa 01             	cmp    $0x1,%edx
  80173d:	74 05                	je     801744 <devsock_close+0x28>
}
  80173f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801742:	c9                   	leave  
  801743:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801744:	83 ec 0c             	sub    $0xc,%esp
  801747:	ff 73 0c             	pushl  0xc(%ebx)
  80174a:	e8 e3 02 00 00       	call   801a32 <nsipc_close>
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	eb eb                	jmp    80173f <devsock_close+0x23>

00801754 <devsock_write>:
{
  801754:	f3 0f 1e fb          	endbr32 
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80175e:	6a 00                	push   $0x0
  801760:	ff 75 10             	pushl  0x10(%ebp)
  801763:	ff 75 0c             	pushl  0xc(%ebp)
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	ff 70 0c             	pushl  0xc(%eax)
  80176c:	e8 b5 03 00 00       	call   801b26 <nsipc_send>
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <devsock_read>:
{
  801773:	f3 0f 1e fb          	endbr32 
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	ff 75 10             	pushl  0x10(%ebp)
  801782:	ff 75 0c             	pushl  0xc(%ebp)
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	ff 70 0c             	pushl  0xc(%eax)
  80178b:	e8 1f 03 00 00       	call   801aaf <nsipc_recv>
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <fd2sockid>:
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801798:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80179b:	52                   	push   %edx
  80179c:	50                   	push   %eax
  80179d:	e8 92 f7 ff ff       	call   800f34 <fd_lookup>
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 10                	js     8017b9 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8017a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ac:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8017b2:	39 08                	cmp    %ecx,(%eax)
  8017b4:	75 05                	jne    8017bb <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8017b6:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    
		return -E_NOT_SUPP;
  8017bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c0:	eb f7                	jmp    8017b9 <fd2sockid+0x27>

008017c2 <alloc_sockfd>:
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	56                   	push   %esi
  8017c6:	53                   	push   %ebx
  8017c7:	83 ec 1c             	sub    $0x1c,%esp
  8017ca:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8017cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017cf:	50                   	push   %eax
  8017d0:	e8 09 f7 ff ff       	call   800ede <fd_alloc>
  8017d5:	89 c3                	mov    %eax,%ebx
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	78 43                	js     801821 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8017de:	83 ec 04             	sub    $0x4,%esp
  8017e1:	68 07 04 00 00       	push   $0x407
  8017e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e9:	6a 00                	push   $0x0
  8017eb:	e8 ff f3 ff ff       	call   800bef <sys_page_alloc>
  8017f0:	89 c3                	mov    %eax,%ebx
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 28                	js     801821 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8017f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fc:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801802:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801807:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80180e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801811:	83 ec 0c             	sub    $0xc,%esp
  801814:	50                   	push   %eax
  801815:	e8 95 f6 ff ff       	call   800eaf <fd2num>
  80181a:	89 c3                	mov    %eax,%ebx
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	eb 0c                	jmp    80182d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801821:	83 ec 0c             	sub    $0xc,%esp
  801824:	56                   	push   %esi
  801825:	e8 08 02 00 00       	call   801a32 <nsipc_close>
		return r;
  80182a:	83 c4 10             	add    $0x10,%esp
}
  80182d:	89 d8                	mov    %ebx,%eax
  80182f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801832:	5b                   	pop    %ebx
  801833:	5e                   	pop    %esi
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    

00801836 <accept>:
{
  801836:	f3 0f 1e fb          	endbr32 
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	e8 4a ff ff ff       	call   801792 <fd2sockid>
  801848:	85 c0                	test   %eax,%eax
  80184a:	78 1b                	js     801867 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	ff 75 10             	pushl  0x10(%ebp)
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	50                   	push   %eax
  801856:	e8 22 01 00 00       	call   80197d <nsipc_accept>
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	85 c0                	test   %eax,%eax
  801860:	78 05                	js     801867 <accept+0x31>
	return alloc_sockfd(r);
  801862:	e8 5b ff ff ff       	call   8017c2 <alloc_sockfd>
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <bind>:
{
  801869:	f3 0f 1e fb          	endbr32 
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	e8 17 ff ff ff       	call   801792 <fd2sockid>
  80187b:	85 c0                	test   %eax,%eax
  80187d:	78 12                	js     801891 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  80187f:	83 ec 04             	sub    $0x4,%esp
  801882:	ff 75 10             	pushl  0x10(%ebp)
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	50                   	push   %eax
  801889:	e8 45 01 00 00       	call   8019d3 <nsipc_bind>
  80188e:	83 c4 10             	add    $0x10,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <shutdown>:
{
  801893:	f3 0f 1e fb          	endbr32 
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	e8 ed fe ff ff       	call   801792 <fd2sockid>
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 0f                	js     8018b8 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8018a9:	83 ec 08             	sub    $0x8,%esp
  8018ac:	ff 75 0c             	pushl  0xc(%ebp)
  8018af:	50                   	push   %eax
  8018b0:	e8 57 01 00 00       	call   801a0c <nsipc_shutdown>
  8018b5:	83 c4 10             	add    $0x10,%esp
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <connect>:
{
  8018ba:	f3 0f 1e fb          	endbr32 
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	e8 c6 fe ff ff       	call   801792 <fd2sockid>
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	78 12                	js     8018e2 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	ff 75 10             	pushl  0x10(%ebp)
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	50                   	push   %eax
  8018da:	e8 71 01 00 00       	call   801a50 <nsipc_connect>
  8018df:	83 c4 10             	add    $0x10,%esp
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <listen>:
{
  8018e4:	f3 0f 1e fb          	endbr32 
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	e8 9c fe ff ff       	call   801792 <fd2sockid>
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	78 0f                	js     801909 <listen+0x25>
	return nsipc_listen(r, backlog);
  8018fa:	83 ec 08             	sub    $0x8,%esp
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	50                   	push   %eax
  801901:	e8 83 01 00 00       	call   801a89 <nsipc_listen>
  801906:	83 c4 10             	add    $0x10,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <socket>:

int
socket(int domain, int type, int protocol)
{
  80190b:	f3 0f 1e fb          	endbr32 
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801915:	ff 75 10             	pushl  0x10(%ebp)
  801918:	ff 75 0c             	pushl  0xc(%ebp)
  80191b:	ff 75 08             	pushl  0x8(%ebp)
  80191e:	e8 65 02 00 00       	call   801b88 <nsipc_socket>
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	85 c0                	test   %eax,%eax
  801928:	78 05                	js     80192f <socket+0x24>
		return r;
	return alloc_sockfd(r);
  80192a:	e8 93 fe ff ff       	call   8017c2 <alloc_sockfd>
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	53                   	push   %ebx
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80193a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801941:	74 26                	je     801969 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801943:	6a 07                	push   $0x7
  801945:	68 00 60 80 00       	push   $0x806000
  80194a:	53                   	push   %ebx
  80194b:	ff 35 04 40 80 00    	pushl  0x804004
  801951:	e8 2a 08 00 00       	call   802180 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801956:	83 c4 0c             	add    $0xc,%esp
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	e8 97 07 00 00       	call   8020fb <ipc_recv>
}
  801964:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801967:	c9                   	leave  
  801968:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	6a 02                	push   $0x2
  80196e:	e8 65 08 00 00       	call   8021d8 <ipc_find_env>
  801973:	a3 04 40 80 00       	mov    %eax,0x804004
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	eb c6                	jmp    801943 <nsipc+0x12>

0080197d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80197d:	f3 0f 1e fb          	endbr32 
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	56                   	push   %esi
  801985:	53                   	push   %ebx
  801986:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801991:	8b 06                	mov    (%esi),%eax
  801993:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801998:	b8 01 00 00 00       	mov    $0x1,%eax
  80199d:	e8 8f ff ff ff       	call   801931 <nsipc>
  8019a2:	89 c3                	mov    %eax,%ebx
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	79 09                	jns    8019b1 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8019a8:	89 d8                	mov    %ebx,%eax
  8019aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ad:	5b                   	pop    %ebx
  8019ae:	5e                   	pop    %esi
  8019af:	5d                   	pop    %ebp
  8019b0:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	ff 35 10 60 80 00    	pushl  0x806010
  8019ba:	68 00 60 80 00       	push   $0x806000
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	e8 9c ef ff ff       	call   800963 <memmove>
		*addrlen = ret->ret_addrlen;
  8019c7:	a1 10 60 80 00       	mov    0x806010,%eax
  8019cc:	89 06                	mov    %eax,(%esi)
  8019ce:	83 c4 10             	add    $0x10,%esp
	return r;
  8019d1:	eb d5                	jmp    8019a8 <nsipc_accept+0x2b>

008019d3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019d3:	f3 0f 1e fb          	endbr32 
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	53                   	push   %ebx
  8019db:	83 ec 08             	sub    $0x8,%esp
  8019de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8019e9:	53                   	push   %ebx
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	68 04 60 80 00       	push   $0x806004
  8019f2:	e8 6c ef ff ff       	call   800963 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8019f7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8019fd:	b8 02 00 00 00       	mov    $0x2,%eax
  801a02:	e8 2a ff ff ff       	call   801931 <nsipc>
}
  801a07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a0c:	f3 0f 1e fb          	endbr32 
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a21:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801a26:	b8 03 00 00 00       	mov    $0x3,%eax
  801a2b:	e8 01 ff ff ff       	call   801931 <nsipc>
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <nsipc_close>:

int
nsipc_close(int s)
{
  801a32:	f3 0f 1e fb          	endbr32 
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801a44:	b8 04 00 00 00       	mov    $0x4,%eax
  801a49:	e8 e3 fe ff ff       	call   801931 <nsipc>
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a50:	f3 0f 1e fb          	endbr32 
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	53                   	push   %ebx
  801a58:	83 ec 08             	sub    $0x8,%esp
  801a5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801a66:	53                   	push   %ebx
  801a67:	ff 75 0c             	pushl  0xc(%ebp)
  801a6a:	68 04 60 80 00       	push   $0x806004
  801a6f:	e8 ef ee ff ff       	call   800963 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801a74:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801a7a:	b8 05 00 00 00       	mov    $0x5,%eax
  801a7f:	e8 ad fe ff ff       	call   801931 <nsipc>
}
  801a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801a89:	f3 0f 1e fb          	endbr32 
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801aa3:	b8 06 00 00 00       	mov    $0x6,%eax
  801aa8:	e8 84 fe ff ff       	call   801931 <nsipc>
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801aaf:	f3 0f 1e fb          	endbr32 
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	56                   	push   %esi
  801ab7:	53                   	push   %ebx
  801ab8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ac3:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ac9:	8b 45 14             	mov    0x14(%ebp),%eax
  801acc:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ad1:	b8 07 00 00 00       	mov    $0x7,%eax
  801ad6:	e8 56 fe ff ff       	call   801931 <nsipc>
  801adb:	89 c3                	mov    %eax,%ebx
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 26                	js     801b07 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801ae1:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801ae7:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801aec:	0f 4e c6             	cmovle %esi,%eax
  801aef:	39 c3                	cmp    %eax,%ebx
  801af1:	7f 1d                	jg     801b10 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	53                   	push   %ebx
  801af7:	68 00 60 80 00       	push   $0x806000
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	e8 5f ee ff ff       	call   800963 <memmove>
  801b04:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b07:	89 d8                	mov    %ebx,%eax
  801b09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b10:	68 3b 29 80 00       	push   $0x80293b
  801b15:	68 03 29 80 00       	push   $0x802903
  801b1a:	6a 62                	push   $0x62
  801b1c:	68 50 29 80 00       	push   $0x802950
  801b21:	e8 8b 05 00 00       	call   8020b1 <_panic>

00801b26 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801b26:	f3 0f 1e fb          	endbr32 
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	53                   	push   %ebx
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801b3c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801b42:	7f 2e                	jg     801b72 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801b44:	83 ec 04             	sub    $0x4,%esp
  801b47:	53                   	push   %ebx
  801b48:	ff 75 0c             	pushl  0xc(%ebp)
  801b4b:	68 0c 60 80 00       	push   $0x80600c
  801b50:	e8 0e ee ff ff       	call   800963 <memmove>
	nsipcbuf.send.req_size = size;
  801b55:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801b63:	b8 08 00 00 00       	mov    $0x8,%eax
  801b68:	e8 c4 fd ff ff       	call   801931 <nsipc>
}
  801b6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    
	assert(size < 1600);
  801b72:	68 5c 29 80 00       	push   $0x80295c
  801b77:	68 03 29 80 00       	push   $0x802903
  801b7c:	6a 6d                	push   $0x6d
  801b7e:	68 50 29 80 00       	push   $0x802950
  801b83:	e8 29 05 00 00       	call   8020b1 <_panic>

00801b88 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801b88:	f3 0f 1e fb          	endbr32 
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9d:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801baa:	b8 09 00 00 00       	mov    $0x9,%eax
  801baf:	e8 7d fd ff ff       	call   801931 <nsipc>
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bb6:	f3 0f 1e fb          	endbr32 
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	56                   	push   %esi
  801bbe:	53                   	push   %ebx
  801bbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bc2:	83 ec 0c             	sub    $0xc,%esp
  801bc5:	ff 75 08             	pushl  0x8(%ebp)
  801bc8:	e8 f6 f2 ff ff       	call   800ec3 <fd2data>
  801bcd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bcf:	83 c4 08             	add    $0x8,%esp
  801bd2:	68 68 29 80 00       	push   $0x802968
  801bd7:	53                   	push   %ebx
  801bd8:	e8 d0 eb ff ff       	call   8007ad <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bdd:	8b 46 04             	mov    0x4(%esi),%eax
  801be0:	2b 06                	sub    (%esi),%eax
  801be2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801be8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bef:	00 00 00 
	stat->st_dev = &devpipe;
  801bf2:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801bf9:	30 80 00 
	return 0;
}
  801bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801c01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c04:	5b                   	pop    %ebx
  801c05:	5e                   	pop    %esi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    

00801c08 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c08:	f3 0f 1e fb          	endbr32 
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	53                   	push   %ebx
  801c10:	83 ec 0c             	sub    $0xc,%esp
  801c13:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c16:	53                   	push   %ebx
  801c17:	6a 00                	push   $0x0
  801c19:	e8 5e f0 ff ff       	call   800c7c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c1e:	89 1c 24             	mov    %ebx,(%esp)
  801c21:	e8 9d f2 ff ff       	call   800ec3 <fd2data>
  801c26:	83 c4 08             	add    $0x8,%esp
  801c29:	50                   	push   %eax
  801c2a:	6a 00                	push   $0x0
  801c2c:	e8 4b f0 ff ff       	call   800c7c <sys_page_unmap>
}
  801c31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <_pipeisclosed>:
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	57                   	push   %edi
  801c3a:	56                   	push   %esi
  801c3b:	53                   	push   %ebx
  801c3c:	83 ec 1c             	sub    $0x1c,%esp
  801c3f:	89 c7                	mov    %eax,%edi
  801c41:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c43:	a1 08 40 80 00       	mov    0x804008,%eax
  801c48:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c4b:	83 ec 0c             	sub    $0xc,%esp
  801c4e:	57                   	push   %edi
  801c4f:	e8 c1 05 00 00       	call   802215 <pageref>
  801c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c57:	89 34 24             	mov    %esi,(%esp)
  801c5a:	e8 b6 05 00 00       	call   802215 <pageref>
		nn = thisenv->env_runs;
  801c5f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c65:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	39 cb                	cmp    %ecx,%ebx
  801c6d:	74 1b                	je     801c8a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c6f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c72:	75 cf                	jne    801c43 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c74:	8b 42 58             	mov    0x58(%edx),%eax
  801c77:	6a 01                	push   $0x1
  801c79:	50                   	push   %eax
  801c7a:	53                   	push   %ebx
  801c7b:	68 6f 29 80 00       	push   $0x80296f
  801c80:	e8 1e e5 ff ff       	call   8001a3 <cprintf>
  801c85:	83 c4 10             	add    $0x10,%esp
  801c88:	eb b9                	jmp    801c43 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c8a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c8d:	0f 94 c0             	sete   %al
  801c90:	0f b6 c0             	movzbl %al,%eax
}
  801c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5e                   	pop    %esi
  801c98:	5f                   	pop    %edi
  801c99:	5d                   	pop    %ebp
  801c9a:	c3                   	ret    

00801c9b <devpipe_write>:
{
  801c9b:	f3 0f 1e fb          	endbr32 
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	57                   	push   %edi
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
  801ca5:	83 ec 28             	sub    $0x28,%esp
  801ca8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cab:	56                   	push   %esi
  801cac:	e8 12 f2 ff ff       	call   800ec3 <fd2data>
  801cb1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cb3:	83 c4 10             	add    $0x10,%esp
  801cb6:	bf 00 00 00 00       	mov    $0x0,%edi
  801cbb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cbe:	74 4f                	je     801d0f <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cc0:	8b 43 04             	mov    0x4(%ebx),%eax
  801cc3:	8b 0b                	mov    (%ebx),%ecx
  801cc5:	8d 51 20             	lea    0x20(%ecx),%edx
  801cc8:	39 d0                	cmp    %edx,%eax
  801cca:	72 14                	jb     801ce0 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801ccc:	89 da                	mov    %ebx,%edx
  801cce:	89 f0                	mov    %esi,%eax
  801cd0:	e8 61 ff ff ff       	call   801c36 <_pipeisclosed>
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	75 3b                	jne    801d14 <devpipe_write+0x79>
			sys_yield();
  801cd9:	e8 ee ee ff ff       	call   800bcc <sys_yield>
  801cde:	eb e0                	jmp    801cc0 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ce3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ce7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cea:	89 c2                	mov    %eax,%edx
  801cec:	c1 fa 1f             	sar    $0x1f,%edx
  801cef:	89 d1                	mov    %edx,%ecx
  801cf1:	c1 e9 1b             	shr    $0x1b,%ecx
  801cf4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cf7:	83 e2 1f             	and    $0x1f,%edx
  801cfa:	29 ca                	sub    %ecx,%edx
  801cfc:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d00:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d04:	83 c0 01             	add    $0x1,%eax
  801d07:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d0a:	83 c7 01             	add    $0x1,%edi
  801d0d:	eb ac                	jmp    801cbb <devpipe_write+0x20>
	return i;
  801d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d12:	eb 05                	jmp    801d19 <devpipe_write+0x7e>
				return 0;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d1c:	5b                   	pop    %ebx
  801d1d:	5e                   	pop    %esi
  801d1e:	5f                   	pop    %edi
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    

00801d21 <devpipe_read>:
{
  801d21:	f3 0f 1e fb          	endbr32 
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	57                   	push   %edi
  801d29:	56                   	push   %esi
  801d2a:	53                   	push   %ebx
  801d2b:	83 ec 18             	sub    $0x18,%esp
  801d2e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d31:	57                   	push   %edi
  801d32:	e8 8c f1 ff ff       	call   800ec3 <fd2data>
  801d37:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	be 00 00 00 00       	mov    $0x0,%esi
  801d41:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d44:	75 14                	jne    801d5a <devpipe_read+0x39>
	return i;
  801d46:	8b 45 10             	mov    0x10(%ebp),%eax
  801d49:	eb 02                	jmp    801d4d <devpipe_read+0x2c>
				return i;
  801d4b:	89 f0                	mov    %esi,%eax
}
  801d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d50:	5b                   	pop    %ebx
  801d51:	5e                   	pop    %esi
  801d52:	5f                   	pop    %edi
  801d53:	5d                   	pop    %ebp
  801d54:	c3                   	ret    
			sys_yield();
  801d55:	e8 72 ee ff ff       	call   800bcc <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d5a:	8b 03                	mov    (%ebx),%eax
  801d5c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d5f:	75 18                	jne    801d79 <devpipe_read+0x58>
			if (i > 0)
  801d61:	85 f6                	test   %esi,%esi
  801d63:	75 e6                	jne    801d4b <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d65:	89 da                	mov    %ebx,%edx
  801d67:	89 f8                	mov    %edi,%eax
  801d69:	e8 c8 fe ff ff       	call   801c36 <_pipeisclosed>
  801d6e:	85 c0                	test   %eax,%eax
  801d70:	74 e3                	je     801d55 <devpipe_read+0x34>
				return 0;
  801d72:	b8 00 00 00 00       	mov    $0x0,%eax
  801d77:	eb d4                	jmp    801d4d <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d79:	99                   	cltd   
  801d7a:	c1 ea 1b             	shr    $0x1b,%edx
  801d7d:	01 d0                	add    %edx,%eax
  801d7f:	83 e0 1f             	and    $0x1f,%eax
  801d82:	29 d0                	sub    %edx,%eax
  801d84:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d8c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d8f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d92:	83 c6 01             	add    $0x1,%esi
  801d95:	eb aa                	jmp    801d41 <devpipe_read+0x20>

00801d97 <pipe>:
{
  801d97:	f3 0f 1e fb          	endbr32 
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	56                   	push   %esi
  801d9f:	53                   	push   %ebx
  801da0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801da3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da6:	50                   	push   %eax
  801da7:	e8 32 f1 ff ff       	call   800ede <fd_alloc>
  801dac:	89 c3                	mov    %eax,%ebx
  801dae:	83 c4 10             	add    $0x10,%esp
  801db1:	85 c0                	test   %eax,%eax
  801db3:	0f 88 23 01 00 00    	js     801edc <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	68 07 04 00 00       	push   $0x407
  801dc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc4:	6a 00                	push   $0x0
  801dc6:	e8 24 ee ff ff       	call   800bef <sys_page_alloc>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	0f 88 04 01 00 00    	js     801edc <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dde:	50                   	push   %eax
  801ddf:	e8 fa f0 ff ff       	call   800ede <fd_alloc>
  801de4:	89 c3                	mov    %eax,%ebx
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	85 c0                	test   %eax,%eax
  801deb:	0f 88 db 00 00 00    	js     801ecc <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	68 07 04 00 00       	push   $0x407
  801df9:	ff 75 f0             	pushl  -0x10(%ebp)
  801dfc:	6a 00                	push   $0x0
  801dfe:	e8 ec ed ff ff       	call   800bef <sys_page_alloc>
  801e03:	89 c3                	mov    %eax,%ebx
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	0f 88 bc 00 00 00    	js     801ecc <pipe+0x135>
	va = fd2data(fd0);
  801e10:	83 ec 0c             	sub    $0xc,%esp
  801e13:	ff 75 f4             	pushl  -0xc(%ebp)
  801e16:	e8 a8 f0 ff ff       	call   800ec3 <fd2data>
  801e1b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e1d:	83 c4 0c             	add    $0xc,%esp
  801e20:	68 07 04 00 00       	push   $0x407
  801e25:	50                   	push   %eax
  801e26:	6a 00                	push   $0x0
  801e28:	e8 c2 ed ff ff       	call   800bef <sys_page_alloc>
  801e2d:	89 c3                	mov    %eax,%ebx
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	85 c0                	test   %eax,%eax
  801e34:	0f 88 82 00 00 00    	js     801ebc <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3a:	83 ec 0c             	sub    $0xc,%esp
  801e3d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e40:	e8 7e f0 ff ff       	call   800ec3 <fd2data>
  801e45:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e4c:	50                   	push   %eax
  801e4d:	6a 00                	push   $0x0
  801e4f:	56                   	push   %esi
  801e50:	6a 00                	push   $0x0
  801e52:	e8 df ed ff ff       	call   800c36 <sys_page_map>
  801e57:	89 c3                	mov    %eax,%ebx
  801e59:	83 c4 20             	add    $0x20,%esp
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	78 4e                	js     801eae <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e60:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e68:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e77:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e83:	83 ec 0c             	sub    $0xc,%esp
  801e86:	ff 75 f4             	pushl  -0xc(%ebp)
  801e89:	e8 21 f0 ff ff       	call   800eaf <fd2num>
  801e8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e91:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e93:	83 c4 04             	add    $0x4,%esp
  801e96:	ff 75 f0             	pushl  -0x10(%ebp)
  801e99:	e8 11 f0 ff ff       	call   800eaf <fd2num>
  801e9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ea4:	83 c4 10             	add    $0x10,%esp
  801ea7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eac:	eb 2e                	jmp    801edc <pipe+0x145>
	sys_page_unmap(0, va);
  801eae:	83 ec 08             	sub    $0x8,%esp
  801eb1:	56                   	push   %esi
  801eb2:	6a 00                	push   $0x0
  801eb4:	e8 c3 ed ff ff       	call   800c7c <sys_page_unmap>
  801eb9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ebc:	83 ec 08             	sub    $0x8,%esp
  801ebf:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec2:	6a 00                	push   $0x0
  801ec4:	e8 b3 ed ff ff       	call   800c7c <sys_page_unmap>
  801ec9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ecc:	83 ec 08             	sub    $0x8,%esp
  801ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed2:	6a 00                	push   $0x0
  801ed4:	e8 a3 ed ff ff       	call   800c7c <sys_page_unmap>
  801ed9:	83 c4 10             	add    $0x10,%esp
}
  801edc:	89 d8                	mov    %ebx,%eax
  801ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5e                   	pop    %esi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    

00801ee5 <pipeisclosed>:
{
  801ee5:	f3 0f 1e fb          	endbr32 
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef2:	50                   	push   %eax
  801ef3:	ff 75 08             	pushl  0x8(%ebp)
  801ef6:	e8 39 f0 ff ff       	call   800f34 <fd_lookup>
  801efb:	83 c4 10             	add    $0x10,%esp
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 18                	js     801f1a <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f02:	83 ec 0c             	sub    $0xc,%esp
  801f05:	ff 75 f4             	pushl  -0xc(%ebp)
  801f08:	e8 b6 ef ff ff       	call   800ec3 <fd2data>
  801f0d:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	e8 1f fd ff ff       	call   801c36 <_pipeisclosed>
  801f17:	83 c4 10             	add    $0x10,%esp
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f1c:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
  801f25:	c3                   	ret    

00801f26 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f26:	f3 0f 1e fb          	endbr32 
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f30:	68 87 29 80 00       	push   $0x802987
  801f35:	ff 75 0c             	pushl  0xc(%ebp)
  801f38:	e8 70 e8 ff ff       	call   8007ad <strcpy>
	return 0;
}
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <devcons_write>:
{
  801f44:	f3 0f 1e fb          	endbr32 
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	57                   	push   %edi
  801f4c:	56                   	push   %esi
  801f4d:	53                   	push   %ebx
  801f4e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f54:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f59:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f5f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f62:	73 31                	jae    801f95 <devcons_write+0x51>
		m = n - tot;
  801f64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f67:	29 f3                	sub    %esi,%ebx
  801f69:	83 fb 7f             	cmp    $0x7f,%ebx
  801f6c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f71:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	53                   	push   %ebx
  801f78:	89 f0                	mov    %esi,%eax
  801f7a:	03 45 0c             	add    0xc(%ebp),%eax
  801f7d:	50                   	push   %eax
  801f7e:	57                   	push   %edi
  801f7f:	e8 df e9 ff ff       	call   800963 <memmove>
		sys_cputs(buf, m);
  801f84:	83 c4 08             	add    $0x8,%esp
  801f87:	53                   	push   %ebx
  801f88:	57                   	push   %edi
  801f89:	e8 91 eb ff ff       	call   800b1f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f8e:	01 de                	add    %ebx,%esi
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	eb ca                	jmp    801f5f <devcons_write+0x1b>
}
  801f95:	89 f0                	mov    %esi,%eax
  801f97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f9a:	5b                   	pop    %ebx
  801f9b:	5e                   	pop    %esi
  801f9c:	5f                   	pop    %edi
  801f9d:	5d                   	pop    %ebp
  801f9e:	c3                   	ret    

00801f9f <devcons_read>:
{
  801f9f:	f3 0f 1e fb          	endbr32 
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 08             	sub    $0x8,%esp
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fb2:	74 21                	je     801fd5 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801fb4:	e8 88 eb ff ff       	call   800b41 <sys_cgetc>
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	75 07                	jne    801fc4 <devcons_read+0x25>
		sys_yield();
  801fbd:	e8 0a ec ff ff       	call   800bcc <sys_yield>
  801fc2:	eb f0                	jmp    801fb4 <devcons_read+0x15>
	if (c < 0)
  801fc4:	78 0f                	js     801fd5 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801fc6:	83 f8 04             	cmp    $0x4,%eax
  801fc9:	74 0c                	je     801fd7 <devcons_read+0x38>
	*(char*)vbuf = c;
  801fcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fce:	88 02                	mov    %al,(%edx)
	return 1;
  801fd0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    
		return 0;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdc:	eb f7                	jmp    801fd5 <devcons_read+0x36>

00801fde <cputchar>:
{
  801fde:	f3 0f 1e fb          	endbr32 
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fee:	6a 01                	push   $0x1
  801ff0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ff3:	50                   	push   %eax
  801ff4:	e8 26 eb ff ff       	call   800b1f <sys_cputs>
}
  801ff9:	83 c4 10             	add    $0x10,%esp
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <getchar>:
{
  801ffe:	f3 0f 1e fb          	endbr32 
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802008:	6a 01                	push   $0x1
  80200a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80200d:	50                   	push   %eax
  80200e:	6a 00                	push   $0x0
  802010:	e8 a7 f1 ff ff       	call   8011bc <read>
	if (r < 0)
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	85 c0                	test   %eax,%eax
  80201a:	78 06                	js     802022 <getchar+0x24>
	if (r < 1)
  80201c:	74 06                	je     802024 <getchar+0x26>
	return c;
  80201e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    
		return -E_EOF;
  802024:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802029:	eb f7                	jmp    802022 <getchar+0x24>

0080202b <iscons>:
{
  80202b:	f3 0f 1e fb          	endbr32 
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802035:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802038:	50                   	push   %eax
  802039:	ff 75 08             	pushl  0x8(%ebp)
  80203c:	e8 f3 ee ff ff       	call   800f34 <fd_lookup>
  802041:	83 c4 10             	add    $0x10,%esp
  802044:	85 c0                	test   %eax,%eax
  802046:	78 11                	js     802059 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802051:	39 10                	cmp    %edx,(%eax)
  802053:	0f 94 c0             	sete   %al
  802056:	0f b6 c0             	movzbl %al,%eax
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <opencons>:
{
  80205b:	f3 0f 1e fb          	endbr32 
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802065:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802068:	50                   	push   %eax
  802069:	e8 70 ee ff ff       	call   800ede <fd_alloc>
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	85 c0                	test   %eax,%eax
  802073:	78 3a                	js     8020af <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802075:	83 ec 04             	sub    $0x4,%esp
  802078:	68 07 04 00 00       	push   $0x407
  80207d:	ff 75 f4             	pushl  -0xc(%ebp)
  802080:	6a 00                	push   $0x0
  802082:	e8 68 eb ff ff       	call   800bef <sys_page_alloc>
  802087:	83 c4 10             	add    $0x10,%esp
  80208a:	85 c0                	test   %eax,%eax
  80208c:	78 21                	js     8020af <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802097:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020a3:	83 ec 0c             	sub    $0xc,%esp
  8020a6:	50                   	push   %eax
  8020a7:	e8 03 ee ff ff       	call   800eaf <fd2num>
  8020ac:	83 c4 10             	add    $0x10,%esp
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020b1:	f3 0f 1e fb          	endbr32 
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	56                   	push   %esi
  8020b9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8020ba:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8020bd:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8020c3:	e8 e1 ea ff ff       	call   800ba9 <sys_getenvid>
  8020c8:	83 ec 0c             	sub    $0xc,%esp
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	ff 75 08             	pushl  0x8(%ebp)
  8020d1:	56                   	push   %esi
  8020d2:	50                   	push   %eax
  8020d3:	68 94 29 80 00       	push   $0x802994
  8020d8:	e8 c6 e0 ff ff       	call   8001a3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8020dd:	83 c4 18             	add    $0x18,%esp
  8020e0:	53                   	push   %ebx
  8020e1:	ff 75 10             	pushl  0x10(%ebp)
  8020e4:	e8 65 e0 ff ff       	call   80014e <vcprintf>
	cprintf("\n");
  8020e9:	c7 04 24 d0 29 80 00 	movl   $0x8029d0,(%esp)
  8020f0:	e8 ae e0 ff ff       	call   8001a3 <cprintf>
  8020f5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020f8:	cc                   	int3   
  8020f9:	eb fd                	jmp    8020f8 <_panic+0x47>

008020fb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020fb:	f3 0f 1e fb          	endbr32 
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	56                   	push   %esi
  802103:	53                   	push   %ebx
  802104:	8b 75 08             	mov    0x8(%ebp),%esi
  802107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80210d:	85 c0                	test   %eax,%eax
  80210f:	74 3d                	je     80214e <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802111:	83 ec 0c             	sub    $0xc,%esp
  802114:	50                   	push   %eax
  802115:	e8 a1 ec ff ff       	call   800dbb <sys_ipc_recv>
  80211a:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80211d:	85 f6                	test   %esi,%esi
  80211f:	74 0b                	je     80212c <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802121:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802127:	8b 52 74             	mov    0x74(%edx),%edx
  80212a:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80212c:	85 db                	test   %ebx,%ebx
  80212e:	74 0b                	je     80213b <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802130:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802136:	8b 52 78             	mov    0x78(%edx),%edx
  802139:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80213b:	85 c0                	test   %eax,%eax
  80213d:	78 21                	js     802160 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80213f:	a1 08 40 80 00       	mov    0x804008,%eax
  802144:	8b 40 70             	mov    0x70(%eax),%eax
}
  802147:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80214a:	5b                   	pop    %ebx
  80214b:	5e                   	pop    %esi
  80214c:	5d                   	pop    %ebp
  80214d:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80214e:	83 ec 0c             	sub    $0xc,%esp
  802151:	68 00 00 c0 ee       	push   $0xeec00000
  802156:	e8 60 ec ff ff       	call   800dbb <sys_ipc_recv>
  80215b:	83 c4 10             	add    $0x10,%esp
  80215e:	eb bd                	jmp    80211d <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802160:	85 f6                	test   %esi,%esi
  802162:	74 10                	je     802174 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802164:	85 db                	test   %ebx,%ebx
  802166:	75 df                	jne    802147 <ipc_recv+0x4c>
  802168:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80216f:	00 00 00 
  802172:	eb d3                	jmp    802147 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802174:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80217b:	00 00 00 
  80217e:	eb e4                	jmp    802164 <ipc_recv+0x69>

00802180 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802180:	f3 0f 1e fb          	endbr32 
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	57                   	push   %edi
  802188:	56                   	push   %esi
  802189:	53                   	push   %ebx
  80218a:	83 ec 0c             	sub    $0xc,%esp
  80218d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802190:	8b 75 0c             	mov    0xc(%ebp),%esi
  802193:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802196:	85 db                	test   %ebx,%ebx
  802198:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80219d:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8021a0:	ff 75 14             	pushl  0x14(%ebp)
  8021a3:	53                   	push   %ebx
  8021a4:	56                   	push   %esi
  8021a5:	57                   	push   %edi
  8021a6:	e8 e9 eb ff ff       	call   800d94 <sys_ipc_try_send>
  8021ab:	83 c4 10             	add    $0x10,%esp
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	79 1e                	jns    8021d0 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8021b2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021b5:	75 07                	jne    8021be <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8021b7:	e8 10 ea ff ff       	call   800bcc <sys_yield>
  8021bc:	eb e2                	jmp    8021a0 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8021be:	50                   	push   %eax
  8021bf:	68 b7 29 80 00       	push   $0x8029b7
  8021c4:	6a 59                	push   $0x59
  8021c6:	68 d2 29 80 00       	push   $0x8029d2
  8021cb:	e8 e1 fe ff ff       	call   8020b1 <_panic>
	}
}
  8021d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021d3:	5b                   	pop    %ebx
  8021d4:	5e                   	pop    %esi
  8021d5:	5f                   	pop    %edi
  8021d6:	5d                   	pop    %ebp
  8021d7:	c3                   	ret    

008021d8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021d8:	f3 0f 1e fb          	endbr32 
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021e2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021e7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021ea:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021f0:	8b 52 50             	mov    0x50(%edx),%edx
  8021f3:	39 ca                	cmp    %ecx,%edx
  8021f5:	74 11                	je     802208 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021f7:	83 c0 01             	add    $0x1,%eax
  8021fa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021ff:	75 e6                	jne    8021e7 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802201:	b8 00 00 00 00       	mov    $0x0,%eax
  802206:	eb 0b                	jmp    802213 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802208:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80220b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802210:	8b 40 48             	mov    0x48(%eax),%eax
}
  802213:	5d                   	pop    %ebp
  802214:	c3                   	ret    

00802215 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802215:	f3 0f 1e fb          	endbr32 
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80221f:	89 c2                	mov    %eax,%edx
  802221:	c1 ea 16             	shr    $0x16,%edx
  802224:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80222b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802230:	f6 c1 01             	test   $0x1,%cl
  802233:	74 1c                	je     802251 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802235:	c1 e8 0c             	shr    $0xc,%eax
  802238:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80223f:	a8 01                	test   $0x1,%al
  802241:	74 0e                	je     802251 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802243:	c1 e8 0c             	shr    $0xc,%eax
  802246:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80224d:	ef 
  80224e:	0f b7 d2             	movzwl %dx,%edx
}
  802251:	89 d0                	mov    %edx,%eax
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	66 90                	xchg   %ax,%ax
  802257:	66 90                	xchg   %ax,%ax
  802259:	66 90                	xchg   %ax,%ax
  80225b:	66 90                	xchg   %ax,%ax
  80225d:	66 90                	xchg   %ax,%ax
  80225f:	90                   	nop

00802260 <__udivdi3>:
  802260:	f3 0f 1e fb          	endbr32 
  802264:	55                   	push   %ebp
  802265:	57                   	push   %edi
  802266:	56                   	push   %esi
  802267:	53                   	push   %ebx
  802268:	83 ec 1c             	sub    $0x1c,%esp
  80226b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80226f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802273:	8b 74 24 34          	mov    0x34(%esp),%esi
  802277:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80227b:	85 d2                	test   %edx,%edx
  80227d:	75 19                	jne    802298 <__udivdi3+0x38>
  80227f:	39 f3                	cmp    %esi,%ebx
  802281:	76 4d                	jbe    8022d0 <__udivdi3+0x70>
  802283:	31 ff                	xor    %edi,%edi
  802285:	89 e8                	mov    %ebp,%eax
  802287:	89 f2                	mov    %esi,%edx
  802289:	f7 f3                	div    %ebx
  80228b:	89 fa                	mov    %edi,%edx
  80228d:	83 c4 1c             	add    $0x1c,%esp
  802290:	5b                   	pop    %ebx
  802291:	5e                   	pop    %esi
  802292:	5f                   	pop    %edi
  802293:	5d                   	pop    %ebp
  802294:	c3                   	ret    
  802295:	8d 76 00             	lea    0x0(%esi),%esi
  802298:	39 f2                	cmp    %esi,%edx
  80229a:	76 14                	jbe    8022b0 <__udivdi3+0x50>
  80229c:	31 ff                	xor    %edi,%edi
  80229e:	31 c0                	xor    %eax,%eax
  8022a0:	89 fa                	mov    %edi,%edx
  8022a2:	83 c4 1c             	add    $0x1c,%esp
  8022a5:	5b                   	pop    %ebx
  8022a6:	5e                   	pop    %esi
  8022a7:	5f                   	pop    %edi
  8022a8:	5d                   	pop    %ebp
  8022a9:	c3                   	ret    
  8022aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022b0:	0f bd fa             	bsr    %edx,%edi
  8022b3:	83 f7 1f             	xor    $0x1f,%edi
  8022b6:	75 48                	jne    802300 <__udivdi3+0xa0>
  8022b8:	39 f2                	cmp    %esi,%edx
  8022ba:	72 06                	jb     8022c2 <__udivdi3+0x62>
  8022bc:	31 c0                	xor    %eax,%eax
  8022be:	39 eb                	cmp    %ebp,%ebx
  8022c0:	77 de                	ja     8022a0 <__udivdi3+0x40>
  8022c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c7:	eb d7                	jmp    8022a0 <__udivdi3+0x40>
  8022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	89 d9                	mov    %ebx,%ecx
  8022d2:	85 db                	test   %ebx,%ebx
  8022d4:	75 0b                	jne    8022e1 <__udivdi3+0x81>
  8022d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	f7 f3                	div    %ebx
  8022df:	89 c1                	mov    %eax,%ecx
  8022e1:	31 d2                	xor    %edx,%edx
  8022e3:	89 f0                	mov    %esi,%eax
  8022e5:	f7 f1                	div    %ecx
  8022e7:	89 c6                	mov    %eax,%esi
  8022e9:	89 e8                	mov    %ebp,%eax
  8022eb:	89 f7                	mov    %esi,%edi
  8022ed:	f7 f1                	div    %ecx
  8022ef:	89 fa                	mov    %edi,%edx
  8022f1:	83 c4 1c             	add    $0x1c,%esp
  8022f4:	5b                   	pop    %ebx
  8022f5:	5e                   	pop    %esi
  8022f6:	5f                   	pop    %edi
  8022f7:	5d                   	pop    %ebp
  8022f8:	c3                   	ret    
  8022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802300:	89 f9                	mov    %edi,%ecx
  802302:	b8 20 00 00 00       	mov    $0x20,%eax
  802307:	29 f8                	sub    %edi,%eax
  802309:	d3 e2                	shl    %cl,%edx
  80230b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80230f:	89 c1                	mov    %eax,%ecx
  802311:	89 da                	mov    %ebx,%edx
  802313:	d3 ea                	shr    %cl,%edx
  802315:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802319:	09 d1                	or     %edx,%ecx
  80231b:	89 f2                	mov    %esi,%edx
  80231d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802321:	89 f9                	mov    %edi,%ecx
  802323:	d3 e3                	shl    %cl,%ebx
  802325:	89 c1                	mov    %eax,%ecx
  802327:	d3 ea                	shr    %cl,%edx
  802329:	89 f9                	mov    %edi,%ecx
  80232b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80232f:	89 eb                	mov    %ebp,%ebx
  802331:	d3 e6                	shl    %cl,%esi
  802333:	89 c1                	mov    %eax,%ecx
  802335:	d3 eb                	shr    %cl,%ebx
  802337:	09 de                	or     %ebx,%esi
  802339:	89 f0                	mov    %esi,%eax
  80233b:	f7 74 24 08          	divl   0x8(%esp)
  80233f:	89 d6                	mov    %edx,%esi
  802341:	89 c3                	mov    %eax,%ebx
  802343:	f7 64 24 0c          	mull   0xc(%esp)
  802347:	39 d6                	cmp    %edx,%esi
  802349:	72 15                	jb     802360 <__udivdi3+0x100>
  80234b:	89 f9                	mov    %edi,%ecx
  80234d:	d3 e5                	shl    %cl,%ebp
  80234f:	39 c5                	cmp    %eax,%ebp
  802351:	73 04                	jae    802357 <__udivdi3+0xf7>
  802353:	39 d6                	cmp    %edx,%esi
  802355:	74 09                	je     802360 <__udivdi3+0x100>
  802357:	89 d8                	mov    %ebx,%eax
  802359:	31 ff                	xor    %edi,%edi
  80235b:	e9 40 ff ff ff       	jmp    8022a0 <__udivdi3+0x40>
  802360:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802363:	31 ff                	xor    %edi,%edi
  802365:	e9 36 ff ff ff       	jmp    8022a0 <__udivdi3+0x40>
  80236a:	66 90                	xchg   %ax,%ax
  80236c:	66 90                	xchg   %ax,%ax
  80236e:	66 90                	xchg   %ax,%ax

00802370 <__umoddi3>:
  802370:	f3 0f 1e fb          	endbr32 
  802374:	55                   	push   %ebp
  802375:	57                   	push   %edi
  802376:	56                   	push   %esi
  802377:	53                   	push   %ebx
  802378:	83 ec 1c             	sub    $0x1c,%esp
  80237b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80237f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802383:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802387:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80238b:	85 c0                	test   %eax,%eax
  80238d:	75 19                	jne    8023a8 <__umoddi3+0x38>
  80238f:	39 df                	cmp    %ebx,%edi
  802391:	76 5d                	jbe    8023f0 <__umoddi3+0x80>
  802393:	89 f0                	mov    %esi,%eax
  802395:	89 da                	mov    %ebx,%edx
  802397:	f7 f7                	div    %edi
  802399:	89 d0                	mov    %edx,%eax
  80239b:	31 d2                	xor    %edx,%edx
  80239d:	83 c4 1c             	add    $0x1c,%esp
  8023a0:	5b                   	pop    %ebx
  8023a1:	5e                   	pop    %esi
  8023a2:	5f                   	pop    %edi
  8023a3:	5d                   	pop    %ebp
  8023a4:	c3                   	ret    
  8023a5:	8d 76 00             	lea    0x0(%esi),%esi
  8023a8:	89 f2                	mov    %esi,%edx
  8023aa:	39 d8                	cmp    %ebx,%eax
  8023ac:	76 12                	jbe    8023c0 <__umoddi3+0x50>
  8023ae:	89 f0                	mov    %esi,%eax
  8023b0:	89 da                	mov    %ebx,%edx
  8023b2:	83 c4 1c             	add    $0x1c,%esp
  8023b5:	5b                   	pop    %ebx
  8023b6:	5e                   	pop    %esi
  8023b7:	5f                   	pop    %edi
  8023b8:	5d                   	pop    %ebp
  8023b9:	c3                   	ret    
  8023ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023c0:	0f bd e8             	bsr    %eax,%ebp
  8023c3:	83 f5 1f             	xor    $0x1f,%ebp
  8023c6:	75 50                	jne    802418 <__umoddi3+0xa8>
  8023c8:	39 d8                	cmp    %ebx,%eax
  8023ca:	0f 82 e0 00 00 00    	jb     8024b0 <__umoddi3+0x140>
  8023d0:	89 d9                	mov    %ebx,%ecx
  8023d2:	39 f7                	cmp    %esi,%edi
  8023d4:	0f 86 d6 00 00 00    	jbe    8024b0 <__umoddi3+0x140>
  8023da:	89 d0                	mov    %edx,%eax
  8023dc:	89 ca                	mov    %ecx,%edx
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	89 fd                	mov    %edi,%ebp
  8023f2:	85 ff                	test   %edi,%edi
  8023f4:	75 0b                	jne    802401 <__umoddi3+0x91>
  8023f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fb:	31 d2                	xor    %edx,%edx
  8023fd:	f7 f7                	div    %edi
  8023ff:	89 c5                	mov    %eax,%ebp
  802401:	89 d8                	mov    %ebx,%eax
  802403:	31 d2                	xor    %edx,%edx
  802405:	f7 f5                	div    %ebp
  802407:	89 f0                	mov    %esi,%eax
  802409:	f7 f5                	div    %ebp
  80240b:	89 d0                	mov    %edx,%eax
  80240d:	31 d2                	xor    %edx,%edx
  80240f:	eb 8c                	jmp    80239d <__umoddi3+0x2d>
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	89 e9                	mov    %ebp,%ecx
  80241a:	ba 20 00 00 00       	mov    $0x20,%edx
  80241f:	29 ea                	sub    %ebp,%edx
  802421:	d3 e0                	shl    %cl,%eax
  802423:	89 44 24 08          	mov    %eax,0x8(%esp)
  802427:	89 d1                	mov    %edx,%ecx
  802429:	89 f8                	mov    %edi,%eax
  80242b:	d3 e8                	shr    %cl,%eax
  80242d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802431:	89 54 24 04          	mov    %edx,0x4(%esp)
  802435:	8b 54 24 04          	mov    0x4(%esp),%edx
  802439:	09 c1                	or     %eax,%ecx
  80243b:	89 d8                	mov    %ebx,%eax
  80243d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802441:	89 e9                	mov    %ebp,%ecx
  802443:	d3 e7                	shl    %cl,%edi
  802445:	89 d1                	mov    %edx,%ecx
  802447:	d3 e8                	shr    %cl,%eax
  802449:	89 e9                	mov    %ebp,%ecx
  80244b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80244f:	d3 e3                	shl    %cl,%ebx
  802451:	89 c7                	mov    %eax,%edi
  802453:	89 d1                	mov    %edx,%ecx
  802455:	89 f0                	mov    %esi,%eax
  802457:	d3 e8                	shr    %cl,%eax
  802459:	89 e9                	mov    %ebp,%ecx
  80245b:	89 fa                	mov    %edi,%edx
  80245d:	d3 e6                	shl    %cl,%esi
  80245f:	09 d8                	or     %ebx,%eax
  802461:	f7 74 24 08          	divl   0x8(%esp)
  802465:	89 d1                	mov    %edx,%ecx
  802467:	89 f3                	mov    %esi,%ebx
  802469:	f7 64 24 0c          	mull   0xc(%esp)
  80246d:	89 c6                	mov    %eax,%esi
  80246f:	89 d7                	mov    %edx,%edi
  802471:	39 d1                	cmp    %edx,%ecx
  802473:	72 06                	jb     80247b <__umoddi3+0x10b>
  802475:	75 10                	jne    802487 <__umoddi3+0x117>
  802477:	39 c3                	cmp    %eax,%ebx
  802479:	73 0c                	jae    802487 <__umoddi3+0x117>
  80247b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80247f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802483:	89 d7                	mov    %edx,%edi
  802485:	89 c6                	mov    %eax,%esi
  802487:	89 ca                	mov    %ecx,%edx
  802489:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80248e:	29 f3                	sub    %esi,%ebx
  802490:	19 fa                	sbb    %edi,%edx
  802492:	89 d0                	mov    %edx,%eax
  802494:	d3 e0                	shl    %cl,%eax
  802496:	89 e9                	mov    %ebp,%ecx
  802498:	d3 eb                	shr    %cl,%ebx
  80249a:	d3 ea                	shr    %cl,%edx
  80249c:	09 d8                	or     %ebx,%eax
  80249e:	83 c4 1c             	add    $0x1c,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    
  8024a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ad:	8d 76 00             	lea    0x0(%esi),%esi
  8024b0:	29 fe                	sub    %edi,%esi
  8024b2:	19 c3                	sbb    %eax,%ebx
  8024b4:	89 f2                	mov    %esi,%edx
  8024b6:	89 d9                	mov    %ebx,%ecx
  8024b8:	e9 1d ff ff ff       	jmp    8023da <__umoddi3+0x6a>
