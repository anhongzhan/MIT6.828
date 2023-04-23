
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 33 00 00 00       	call   800064 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  80003d:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800044:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800047:	b8 01 00 00 00       	mov    $0x1,%eax
  80004c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800051:	99                   	cltd   
  800052:	f7 f9                	idiv   %ecx
  800054:	50                   	push   %eax
  800055:	68 80 24 80 00       	push   $0x802480
  80005a:	e8 0a 01 00 00       	call   800169 <cprintf>
}
  80005f:	83 c4 10             	add    $0x10,%esp
  800062:	c9                   	leave  
  800063:	c3                   	ret    

00800064 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800064:	f3 0f 1e fb          	endbr32 
  800068:	55                   	push   %ebp
  800069:	89 e5                	mov    %esp,%ebp
  80006b:	56                   	push   %esi
  80006c:	53                   	push   %ebx
  80006d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800070:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800073:	e8 f7 0a 00 00       	call   800b6f <sys_getenvid>
  800078:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800080:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800085:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008a:	85 db                	test   %ebx,%ebx
  80008c:	7e 07                	jle    800095 <libmain+0x31>
		binaryname = argv[0];
  80008e:	8b 06                	mov    (%esi),%eax
  800090:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800095:	83 ec 08             	sub    $0x8,%esp
  800098:	56                   	push   %esi
  800099:	53                   	push   %ebx
  80009a:	e8 94 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009f:	e8 0a 00 00 00       	call   8000ae <exit>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000aa:	5b                   	pop    %ebx
  8000ab:	5e                   	pop    %esi
  8000ac:	5d                   	pop    %ebp
  8000ad:	c3                   	ret    

008000ae <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ae:	f3 0f 1e fb          	endbr32 
  8000b2:	55                   	push   %ebp
  8000b3:	89 e5                	mov    %esp,%ebp
  8000b5:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b8:	e8 ac 0f 00 00       	call   801069 <close_all>
	sys_env_destroy(0);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	e8 63 0a 00 00       	call   800b2a <sys_env_destroy>
}
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	c9                   	leave  
  8000cb:	c3                   	ret    

008000cc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000cc:	f3 0f 1e fb          	endbr32 
  8000d0:	55                   	push   %ebp
  8000d1:	89 e5                	mov    %esp,%ebp
  8000d3:	53                   	push   %ebx
  8000d4:	83 ec 04             	sub    $0x4,%esp
  8000d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000da:	8b 13                	mov    (%ebx),%edx
  8000dc:	8d 42 01             	lea    0x1(%edx),%eax
  8000df:	89 03                	mov    %eax,(%ebx)
  8000e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000e4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000ed:	74 09                	je     8000f8 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ef:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f6:	c9                   	leave  
  8000f7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f8:	83 ec 08             	sub    $0x8,%esp
  8000fb:	68 ff 00 00 00       	push   $0xff
  800100:	8d 43 08             	lea    0x8(%ebx),%eax
  800103:	50                   	push   %eax
  800104:	e8 dc 09 00 00       	call   800ae5 <sys_cputs>
		b->idx = 0;
  800109:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	eb db                	jmp    8000ef <putch+0x23>

00800114 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800114:	f3 0f 1e fb          	endbr32 
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800121:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800128:	00 00 00 
	b.cnt = 0;
  80012b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800132:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800135:	ff 75 0c             	pushl  0xc(%ebp)
  800138:	ff 75 08             	pushl  0x8(%ebp)
  80013b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800141:	50                   	push   %eax
  800142:	68 cc 00 80 00       	push   $0x8000cc
  800147:	e8 20 01 00 00       	call   80026c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80014c:	83 c4 08             	add    $0x8,%esp
  80014f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800155:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80015b:	50                   	push   %eax
  80015c:	e8 84 09 00 00       	call   800ae5 <sys_cputs>

	return b.cnt;
}
  800161:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800167:	c9                   	leave  
  800168:	c3                   	ret    

00800169 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800169:	f3 0f 1e fb          	endbr32 
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800173:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800176:	50                   	push   %eax
  800177:	ff 75 08             	pushl  0x8(%ebp)
  80017a:	e8 95 ff ff ff       	call   800114 <vcprintf>
	va_end(ap);

	return cnt;
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	57                   	push   %edi
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	83 ec 1c             	sub    $0x1c,%esp
  80018a:	89 c7                	mov    %eax,%edi
  80018c:	89 d6                	mov    %edx,%esi
  80018e:	8b 45 08             	mov    0x8(%ebp),%eax
  800191:	8b 55 0c             	mov    0xc(%ebp),%edx
  800194:	89 d1                	mov    %edx,%ecx
  800196:	89 c2                	mov    %eax,%edx
  800198:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80019e:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ae:	39 c2                	cmp    %eax,%edx
  8001b0:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001b3:	72 3e                	jb     8001f3 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	ff 75 18             	pushl  0x18(%ebp)
  8001bb:	83 eb 01             	sub    $0x1,%ebx
  8001be:	53                   	push   %ebx
  8001bf:	50                   	push   %eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c9:	ff 75 dc             	pushl  -0x24(%ebp)
  8001cc:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cf:	e8 4c 20 00 00       	call   802220 <__udivdi3>
  8001d4:	83 c4 18             	add    $0x18,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	89 f2                	mov    %esi,%edx
  8001db:	89 f8                	mov    %edi,%eax
  8001dd:	e8 9f ff ff ff       	call   800181 <printnum>
  8001e2:	83 c4 20             	add    $0x20,%esp
  8001e5:	eb 13                	jmp    8001fa <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	56                   	push   %esi
  8001eb:	ff 75 18             	pushl  0x18(%ebp)
  8001ee:	ff d7                	call   *%edi
  8001f0:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001f3:	83 eb 01             	sub    $0x1,%ebx
  8001f6:	85 db                	test   %ebx,%ebx
  8001f8:	7f ed                	jg     8001e7 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	56                   	push   %esi
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	ff 75 e4             	pushl  -0x1c(%ebp)
  800204:	ff 75 e0             	pushl  -0x20(%ebp)
  800207:	ff 75 dc             	pushl  -0x24(%ebp)
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	e8 1e 21 00 00       	call   802330 <__umoddi3>
  800212:	83 c4 14             	add    $0x14,%esp
  800215:	0f be 80 98 24 80 00 	movsbl 0x802498(%eax),%eax
  80021c:	50                   	push   %eax
  80021d:	ff d7                	call   *%edi
}
  80021f:	83 c4 10             	add    $0x10,%esp
  800222:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800225:	5b                   	pop    %ebx
  800226:	5e                   	pop    %esi
  800227:	5f                   	pop    %edi
  800228:	5d                   	pop    %ebp
  800229:	c3                   	ret    

0080022a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80022a:	f3 0f 1e fb          	endbr32 
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800234:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800238:	8b 10                	mov    (%eax),%edx
  80023a:	3b 50 04             	cmp    0x4(%eax),%edx
  80023d:	73 0a                	jae    800249 <sprintputch+0x1f>
		*b->buf++ = ch;
  80023f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800242:	89 08                	mov    %ecx,(%eax)
  800244:	8b 45 08             	mov    0x8(%ebp),%eax
  800247:	88 02                	mov    %al,(%edx)
}
  800249:	5d                   	pop    %ebp
  80024a:	c3                   	ret    

0080024b <printfmt>:
{
  80024b:	f3 0f 1e fb          	endbr32 
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800255:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800258:	50                   	push   %eax
  800259:	ff 75 10             	pushl  0x10(%ebp)
  80025c:	ff 75 0c             	pushl  0xc(%ebp)
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	e8 05 00 00 00       	call   80026c <vprintfmt>
}
  800267:	83 c4 10             	add    $0x10,%esp
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <vprintfmt>:
{
  80026c:	f3 0f 1e fb          	endbr32 
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	57                   	push   %edi
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
  800276:	83 ec 3c             	sub    $0x3c,%esp
  800279:	8b 75 08             	mov    0x8(%ebp),%esi
  80027c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80027f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800282:	e9 8e 03 00 00       	jmp    800615 <vprintfmt+0x3a9>
		padc = ' ';
  800287:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80028b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800292:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800299:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002a0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a5:	8d 47 01             	lea    0x1(%edi),%eax
  8002a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ab:	0f b6 17             	movzbl (%edi),%edx
  8002ae:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002b1:	3c 55                	cmp    $0x55,%al
  8002b3:	0f 87 df 03 00 00    	ja     800698 <vprintfmt+0x42c>
  8002b9:	0f b6 c0             	movzbl %al,%eax
  8002bc:	3e ff 24 85 e0 25 80 	notrack jmp *0x8025e0(,%eax,4)
  8002c3:	00 
  8002c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002c7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002cb:	eb d8                	jmp    8002a5 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002d0:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002d4:	eb cf                	jmp    8002a5 <vprintfmt+0x39>
  8002d6:	0f b6 d2             	movzbl %dl,%edx
  8002d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002e4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002eb:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002ee:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002f1:	83 f9 09             	cmp    $0x9,%ecx
  8002f4:	77 55                	ja     80034b <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8002f6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002f9:	eb e9                	jmp    8002e4 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8002fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fe:	8b 00                	mov    (%eax),%eax
  800300:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800303:	8b 45 14             	mov    0x14(%ebp),%eax
  800306:	8d 40 04             	lea    0x4(%eax),%eax
  800309:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80030f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800313:	79 90                	jns    8002a5 <vprintfmt+0x39>
				width = precision, precision = -1;
  800315:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800318:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800322:	eb 81                	jmp    8002a5 <vprintfmt+0x39>
  800324:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800327:	85 c0                	test   %eax,%eax
  800329:	ba 00 00 00 00       	mov    $0x0,%edx
  80032e:	0f 49 d0             	cmovns %eax,%edx
  800331:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800334:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800337:	e9 69 ff ff ff       	jmp    8002a5 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80033c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80033f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800346:	e9 5a ff ff ff       	jmp    8002a5 <vprintfmt+0x39>
  80034b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80034e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800351:	eb bc                	jmp    80030f <vprintfmt+0xa3>
			lflag++;
  800353:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800359:	e9 47 ff ff ff       	jmp    8002a5 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80035e:	8b 45 14             	mov    0x14(%ebp),%eax
  800361:	8d 78 04             	lea    0x4(%eax),%edi
  800364:	83 ec 08             	sub    $0x8,%esp
  800367:	53                   	push   %ebx
  800368:	ff 30                	pushl  (%eax)
  80036a:	ff d6                	call   *%esi
			break;
  80036c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80036f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800372:	e9 9b 02 00 00       	jmp    800612 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	8d 78 04             	lea    0x4(%eax),%edi
  80037d:	8b 00                	mov    (%eax),%eax
  80037f:	99                   	cltd   
  800380:	31 d0                	xor    %edx,%eax
  800382:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800384:	83 f8 0f             	cmp    $0xf,%eax
  800387:	7f 23                	jg     8003ac <vprintfmt+0x140>
  800389:	8b 14 85 40 27 80 00 	mov    0x802740(,%eax,4),%edx
  800390:	85 d2                	test   %edx,%edx
  800392:	74 18                	je     8003ac <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800394:	52                   	push   %edx
  800395:	68 75 28 80 00       	push   $0x802875
  80039a:	53                   	push   %ebx
  80039b:	56                   	push   %esi
  80039c:	e8 aa fe ff ff       	call   80024b <printfmt>
  8003a1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a7:	e9 66 02 00 00       	jmp    800612 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003ac:	50                   	push   %eax
  8003ad:	68 b0 24 80 00       	push   $0x8024b0
  8003b2:	53                   	push   %ebx
  8003b3:	56                   	push   %esi
  8003b4:	e8 92 fe ff ff       	call   80024b <printfmt>
  8003b9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003bf:	e9 4e 02 00 00       	jmp    800612 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c7:	83 c0 04             	add    $0x4,%eax
  8003ca:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d0:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003d2:	85 d2                	test   %edx,%edx
  8003d4:	b8 a9 24 80 00       	mov    $0x8024a9,%eax
  8003d9:	0f 45 c2             	cmovne %edx,%eax
  8003dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e3:	7e 06                	jle    8003eb <vprintfmt+0x17f>
  8003e5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003e9:	75 0d                	jne    8003f8 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ee:	89 c7                	mov    %eax,%edi
  8003f0:	03 45 e0             	add    -0x20(%ebp),%eax
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f6:	eb 55                	jmp    80044d <vprintfmt+0x1e1>
  8003f8:	83 ec 08             	sub    $0x8,%esp
  8003fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8003fe:	ff 75 cc             	pushl  -0x34(%ebp)
  800401:	e8 46 03 00 00       	call   80074c <strnlen>
  800406:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800409:	29 c2                	sub    %eax,%edx
  80040b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80040e:	83 c4 10             	add    $0x10,%esp
  800411:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800413:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800417:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80041a:	85 ff                	test   %edi,%edi
  80041c:	7e 11                	jle    80042f <vprintfmt+0x1c3>
					putch(padc, putdat);
  80041e:	83 ec 08             	sub    $0x8,%esp
  800421:	53                   	push   %ebx
  800422:	ff 75 e0             	pushl  -0x20(%ebp)
  800425:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800427:	83 ef 01             	sub    $0x1,%edi
  80042a:	83 c4 10             	add    $0x10,%esp
  80042d:	eb eb                	jmp    80041a <vprintfmt+0x1ae>
  80042f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800432:	85 d2                	test   %edx,%edx
  800434:	b8 00 00 00 00       	mov    $0x0,%eax
  800439:	0f 49 c2             	cmovns %edx,%eax
  80043c:	29 c2                	sub    %eax,%edx
  80043e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800441:	eb a8                	jmp    8003eb <vprintfmt+0x17f>
					putch(ch, putdat);
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	53                   	push   %ebx
  800447:	52                   	push   %edx
  800448:	ff d6                	call   *%esi
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800450:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800452:	83 c7 01             	add    $0x1,%edi
  800455:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800459:	0f be d0             	movsbl %al,%edx
  80045c:	85 d2                	test   %edx,%edx
  80045e:	74 4b                	je     8004ab <vprintfmt+0x23f>
  800460:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800464:	78 06                	js     80046c <vprintfmt+0x200>
  800466:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80046a:	78 1e                	js     80048a <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80046c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800470:	74 d1                	je     800443 <vprintfmt+0x1d7>
  800472:	0f be c0             	movsbl %al,%eax
  800475:	83 e8 20             	sub    $0x20,%eax
  800478:	83 f8 5e             	cmp    $0x5e,%eax
  80047b:	76 c6                	jbe    800443 <vprintfmt+0x1d7>
					putch('?', putdat);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	53                   	push   %ebx
  800481:	6a 3f                	push   $0x3f
  800483:	ff d6                	call   *%esi
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	eb c3                	jmp    80044d <vprintfmt+0x1e1>
  80048a:	89 cf                	mov    %ecx,%edi
  80048c:	eb 0e                	jmp    80049c <vprintfmt+0x230>
				putch(' ', putdat);
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	53                   	push   %ebx
  800492:	6a 20                	push   $0x20
  800494:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800496:	83 ef 01             	sub    $0x1,%edi
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	85 ff                	test   %edi,%edi
  80049e:	7f ee                	jg     80048e <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a6:	e9 67 01 00 00       	jmp    800612 <vprintfmt+0x3a6>
  8004ab:	89 cf                	mov    %ecx,%edi
  8004ad:	eb ed                	jmp    80049c <vprintfmt+0x230>
	if (lflag >= 2)
  8004af:	83 f9 01             	cmp    $0x1,%ecx
  8004b2:	7f 1b                	jg     8004cf <vprintfmt+0x263>
	else if (lflag)
  8004b4:	85 c9                	test   %ecx,%ecx
  8004b6:	74 63                	je     80051b <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c0:	99                   	cltd   
  8004c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 40 04             	lea    0x4(%eax),%eax
  8004ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cd:	eb 17                	jmp    8004e6 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	8b 50 04             	mov    0x4(%eax),%edx
  8004d5:	8b 00                	mov    (%eax),%eax
  8004d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	8d 40 08             	lea    0x8(%eax),%eax
  8004e3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004ec:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8004f1:	85 c9                	test   %ecx,%ecx
  8004f3:	0f 89 ff 00 00 00    	jns    8005f8 <vprintfmt+0x38c>
				putch('-', putdat);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	53                   	push   %ebx
  8004fd:	6a 2d                	push   $0x2d
  8004ff:	ff d6                	call   *%esi
				num = -(long long) num;
  800501:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800504:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800507:	f7 da                	neg    %edx
  800509:	83 d1 00             	adc    $0x0,%ecx
  80050c:	f7 d9                	neg    %ecx
  80050e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800511:	b8 0a 00 00 00       	mov    $0xa,%eax
  800516:	e9 dd 00 00 00       	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800523:	99                   	cltd   
  800524:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800527:	8b 45 14             	mov    0x14(%ebp),%eax
  80052a:	8d 40 04             	lea    0x4(%eax),%eax
  80052d:	89 45 14             	mov    %eax,0x14(%ebp)
  800530:	eb b4                	jmp    8004e6 <vprintfmt+0x27a>
	if (lflag >= 2)
  800532:	83 f9 01             	cmp    $0x1,%ecx
  800535:	7f 1e                	jg     800555 <vprintfmt+0x2e9>
	else if (lflag)
  800537:	85 c9                	test   %ecx,%ecx
  800539:	74 32                	je     80056d <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8b 10                	mov    (%eax),%edx
  800540:	b9 00 00 00 00       	mov    $0x0,%ecx
  800545:	8d 40 04             	lea    0x4(%eax),%eax
  800548:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80054b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800550:	e9 a3 00 00 00       	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8b 10                	mov    (%eax),%edx
  80055a:	8b 48 04             	mov    0x4(%eax),%ecx
  80055d:	8d 40 08             	lea    0x8(%eax),%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800563:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800568:	e9 8b 00 00 00       	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8b 10                	mov    (%eax),%edx
  800572:	b9 00 00 00 00       	mov    $0x0,%ecx
  800577:	8d 40 04             	lea    0x4(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800582:	eb 74                	jmp    8005f8 <vprintfmt+0x38c>
	if (lflag >= 2)
  800584:	83 f9 01             	cmp    $0x1,%ecx
  800587:	7f 1b                	jg     8005a4 <vprintfmt+0x338>
	else if (lflag)
  800589:	85 c9                	test   %ecx,%ecx
  80058b:	74 2c                	je     8005b9 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8b 10                	mov    (%eax),%edx
  800592:	b9 00 00 00 00       	mov    $0x0,%ecx
  800597:	8d 40 04             	lea    0x4(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80059d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005a2:	eb 54                	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 10                	mov    (%eax),%edx
  8005a9:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ac:	8d 40 08             	lea    0x8(%eax),%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b2:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005b7:	eb 3f                	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8b 10                	mov    (%eax),%edx
  8005be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c3:	8d 40 04             	lea    0x4(%eax),%eax
  8005c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c9:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005ce:	eb 28                	jmp    8005f8 <vprintfmt+0x38c>
			putch('0', putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	53                   	push   %ebx
  8005d4:	6a 30                	push   $0x30
  8005d6:	ff d6                	call   *%esi
			putch('x', putdat);
  8005d8:	83 c4 08             	add    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	6a 78                	push   $0x78
  8005de:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ea:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005ed:	8d 40 04             	lea    0x4(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005f3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005f8:	83 ec 0c             	sub    $0xc,%esp
  8005fb:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005ff:	57                   	push   %edi
  800600:	ff 75 e0             	pushl  -0x20(%ebp)
  800603:	50                   	push   %eax
  800604:	51                   	push   %ecx
  800605:	52                   	push   %edx
  800606:	89 da                	mov    %ebx,%edx
  800608:	89 f0                	mov    %esi,%eax
  80060a:	e8 72 fb ff ff       	call   800181 <printnum>
			break;
  80060f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800615:	83 c7 01             	add    $0x1,%edi
  800618:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061c:	83 f8 25             	cmp    $0x25,%eax
  80061f:	0f 84 62 fc ff ff    	je     800287 <vprintfmt+0x1b>
			if (ch == '\0')
  800625:	85 c0                	test   %eax,%eax
  800627:	0f 84 8b 00 00 00    	je     8006b8 <vprintfmt+0x44c>
			putch(ch, putdat);
  80062d:	83 ec 08             	sub    $0x8,%esp
  800630:	53                   	push   %ebx
  800631:	50                   	push   %eax
  800632:	ff d6                	call   *%esi
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	eb dc                	jmp    800615 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800639:	83 f9 01             	cmp    $0x1,%ecx
  80063c:	7f 1b                	jg     800659 <vprintfmt+0x3ed>
	else if (lflag)
  80063e:	85 c9                	test   %ecx,%ecx
  800640:	74 2c                	je     80066e <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 10                	mov    (%eax),%edx
  800647:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800652:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800657:	eb 9f                	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 10                	mov    (%eax),%edx
  80065e:	8b 48 04             	mov    0x4(%eax),%ecx
  800661:	8d 40 08             	lea    0x8(%eax),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800667:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80066c:	eb 8a                	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 10                	mov    (%eax),%edx
  800673:	b9 00 00 00 00       	mov    $0x0,%ecx
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800683:	e9 70 ff ff ff       	jmp    8005f8 <vprintfmt+0x38c>
			putch(ch, putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 25                	push   $0x25
  80068e:	ff d6                	call   *%esi
			break;
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	e9 7a ff ff ff       	jmp    800612 <vprintfmt+0x3a6>
			putch('%', putdat);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	53                   	push   %ebx
  80069c:	6a 25                	push   $0x25
  80069e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	89 f8                	mov    %edi,%eax
  8006a5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006a9:	74 05                	je     8006b0 <vprintfmt+0x444>
  8006ab:	83 e8 01             	sub    $0x1,%eax
  8006ae:	eb f5                	jmp    8006a5 <vprintfmt+0x439>
  8006b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b3:	e9 5a ff ff ff       	jmp    800612 <vprintfmt+0x3a6>
}
  8006b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006bb:	5b                   	pop    %ebx
  8006bc:	5e                   	pop    %esi
  8006bd:	5f                   	pop    %edi
  8006be:	5d                   	pop    %ebp
  8006bf:	c3                   	ret    

008006c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c0:	f3 0f 1e fb          	endbr32 
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
  8006c7:	83 ec 18             	sub    $0x18,%esp
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006d3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006e1:	85 c0                	test   %eax,%eax
  8006e3:	74 26                	je     80070b <vsnprintf+0x4b>
  8006e5:	85 d2                	test   %edx,%edx
  8006e7:	7e 22                	jle    80070b <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e9:	ff 75 14             	pushl  0x14(%ebp)
  8006ec:	ff 75 10             	pushl  0x10(%ebp)
  8006ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f2:	50                   	push   %eax
  8006f3:	68 2a 02 80 00       	push   $0x80022a
  8006f8:	e8 6f fb ff ff       	call   80026c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800700:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800706:	83 c4 10             	add    $0x10,%esp
}
  800709:	c9                   	leave  
  80070a:	c3                   	ret    
		return -E_INVAL;
  80070b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800710:	eb f7                	jmp    800709 <vsnprintf+0x49>

00800712 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800712:	f3 0f 1e fb          	endbr32 
  800716:	55                   	push   %ebp
  800717:	89 e5                	mov    %esp,%ebp
  800719:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80071c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80071f:	50                   	push   %eax
  800720:	ff 75 10             	pushl  0x10(%ebp)
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	ff 75 08             	pushl  0x8(%ebp)
  800729:	e8 92 ff ff ff       	call   8006c0 <vsnprintf>
	va_end(ap);

	return rc;
}
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800730:	f3 0f 1e fb          	endbr32 
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
  800737:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80073a:	b8 00 00 00 00       	mov    $0x0,%eax
  80073f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800743:	74 05                	je     80074a <strlen+0x1a>
		n++;
  800745:	83 c0 01             	add    $0x1,%eax
  800748:	eb f5                	jmp    80073f <strlen+0xf>
	return n;
}
  80074a:	5d                   	pop    %ebp
  80074b:	c3                   	ret    

0080074c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80074c:	f3 0f 1e fb          	endbr32 
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800756:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800759:	b8 00 00 00 00       	mov    $0x0,%eax
  80075e:	39 d0                	cmp    %edx,%eax
  800760:	74 0d                	je     80076f <strnlen+0x23>
  800762:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800766:	74 05                	je     80076d <strnlen+0x21>
		n++;
  800768:	83 c0 01             	add    $0x1,%eax
  80076b:	eb f1                	jmp    80075e <strnlen+0x12>
  80076d:	89 c2                	mov    %eax,%edx
	return n;
}
  80076f:	89 d0                	mov    %edx,%eax
  800771:	5d                   	pop    %ebp
  800772:	c3                   	ret    

00800773 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800773:	f3 0f 1e fb          	endbr32 
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	53                   	push   %ebx
  80077b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80077e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800781:	b8 00 00 00 00       	mov    $0x0,%eax
  800786:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80078a:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80078d:	83 c0 01             	add    $0x1,%eax
  800790:	84 d2                	test   %dl,%dl
  800792:	75 f2                	jne    800786 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800794:	89 c8                	mov    %ecx,%eax
  800796:	5b                   	pop    %ebx
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800799:	f3 0f 1e fb          	endbr32 
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	53                   	push   %ebx
  8007a1:	83 ec 10             	sub    $0x10,%esp
  8007a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a7:	53                   	push   %ebx
  8007a8:	e8 83 ff ff ff       	call   800730 <strlen>
  8007ad:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	01 d8                	add    %ebx,%eax
  8007b5:	50                   	push   %eax
  8007b6:	e8 b8 ff ff ff       	call   800773 <strcpy>
	return dst;
}
  8007bb:	89 d8                	mov    %ebx,%eax
  8007bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007c2:	f3 0f 1e fb          	endbr32 
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	56                   	push   %esi
  8007ca:	53                   	push   %ebx
  8007cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d1:	89 f3                	mov    %esi,%ebx
  8007d3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007d6:	89 f0                	mov    %esi,%eax
  8007d8:	39 d8                	cmp    %ebx,%eax
  8007da:	74 11                	je     8007ed <strncpy+0x2b>
		*dst++ = *src;
  8007dc:	83 c0 01             	add    $0x1,%eax
  8007df:	0f b6 0a             	movzbl (%edx),%ecx
  8007e2:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007e5:	80 f9 01             	cmp    $0x1,%cl
  8007e8:	83 da ff             	sbb    $0xffffffff,%edx
  8007eb:	eb eb                	jmp    8007d8 <strncpy+0x16>
	}
	return ret;
}
  8007ed:	89 f0                	mov    %esi,%eax
  8007ef:	5b                   	pop    %ebx
  8007f0:	5e                   	pop    %esi
  8007f1:	5d                   	pop    %ebp
  8007f2:	c3                   	ret    

008007f3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007f3:	f3 0f 1e fb          	endbr32 
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	56                   	push   %esi
  8007fb:	53                   	push   %ebx
  8007fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800802:	8b 55 10             	mov    0x10(%ebp),%edx
  800805:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800807:	85 d2                	test   %edx,%edx
  800809:	74 21                	je     80082c <strlcpy+0x39>
  80080b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80080f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800811:	39 c2                	cmp    %eax,%edx
  800813:	74 14                	je     800829 <strlcpy+0x36>
  800815:	0f b6 19             	movzbl (%ecx),%ebx
  800818:	84 db                	test   %bl,%bl
  80081a:	74 0b                	je     800827 <strlcpy+0x34>
			*dst++ = *src++;
  80081c:	83 c1 01             	add    $0x1,%ecx
  80081f:	83 c2 01             	add    $0x1,%edx
  800822:	88 5a ff             	mov    %bl,-0x1(%edx)
  800825:	eb ea                	jmp    800811 <strlcpy+0x1e>
  800827:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800829:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80082c:	29 f0                	sub    %esi,%eax
}
  80082e:	5b                   	pop    %ebx
  80082f:	5e                   	pop    %esi
  800830:	5d                   	pop    %ebp
  800831:	c3                   	ret    

00800832 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800832:	f3 0f 1e fb          	endbr32 
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80083f:	0f b6 01             	movzbl (%ecx),%eax
  800842:	84 c0                	test   %al,%al
  800844:	74 0c                	je     800852 <strcmp+0x20>
  800846:	3a 02                	cmp    (%edx),%al
  800848:	75 08                	jne    800852 <strcmp+0x20>
		p++, q++;
  80084a:	83 c1 01             	add    $0x1,%ecx
  80084d:	83 c2 01             	add    $0x1,%edx
  800850:	eb ed                	jmp    80083f <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800852:	0f b6 c0             	movzbl %al,%eax
  800855:	0f b6 12             	movzbl (%edx),%edx
  800858:	29 d0                	sub    %edx,%eax
}
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    

0080085c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80085c:	f3 0f 1e fb          	endbr32 
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	53                   	push   %ebx
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086a:	89 c3                	mov    %eax,%ebx
  80086c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80086f:	eb 06                	jmp    800877 <strncmp+0x1b>
		n--, p++, q++;
  800871:	83 c0 01             	add    $0x1,%eax
  800874:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800877:	39 d8                	cmp    %ebx,%eax
  800879:	74 16                	je     800891 <strncmp+0x35>
  80087b:	0f b6 08             	movzbl (%eax),%ecx
  80087e:	84 c9                	test   %cl,%cl
  800880:	74 04                	je     800886 <strncmp+0x2a>
  800882:	3a 0a                	cmp    (%edx),%cl
  800884:	74 eb                	je     800871 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800886:	0f b6 00             	movzbl (%eax),%eax
  800889:	0f b6 12             	movzbl (%edx),%edx
  80088c:	29 d0                	sub    %edx,%eax
}
  80088e:	5b                   	pop    %ebx
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    
		return 0;
  800891:	b8 00 00 00 00       	mov    $0x0,%eax
  800896:	eb f6                	jmp    80088e <strncmp+0x32>

00800898 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800898:	f3 0f 1e fb          	endbr32 
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a6:	0f b6 10             	movzbl (%eax),%edx
  8008a9:	84 d2                	test   %dl,%dl
  8008ab:	74 09                	je     8008b6 <strchr+0x1e>
		if (*s == c)
  8008ad:	38 ca                	cmp    %cl,%dl
  8008af:	74 0a                	je     8008bb <strchr+0x23>
	for (; *s; s++)
  8008b1:	83 c0 01             	add    $0x1,%eax
  8008b4:	eb f0                	jmp    8008a6 <strchr+0xe>
			return (char *) s;
	return 0;
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008bd:	f3 0f 1e fb          	endbr32 
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008cb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008ce:	38 ca                	cmp    %cl,%dl
  8008d0:	74 09                	je     8008db <strfind+0x1e>
  8008d2:	84 d2                	test   %dl,%dl
  8008d4:	74 05                	je     8008db <strfind+0x1e>
	for (; *s; s++)
  8008d6:	83 c0 01             	add    $0x1,%eax
  8008d9:	eb f0                	jmp    8008cb <strfind+0xe>
			break;
	return (char *) s;
}
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008dd:	f3 0f 1e fb          	endbr32 
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	57                   	push   %edi
  8008e5:	56                   	push   %esi
  8008e6:	53                   	push   %ebx
  8008e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008ed:	85 c9                	test   %ecx,%ecx
  8008ef:	74 31                	je     800922 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008f1:	89 f8                	mov    %edi,%eax
  8008f3:	09 c8                	or     %ecx,%eax
  8008f5:	a8 03                	test   $0x3,%al
  8008f7:	75 23                	jne    80091c <memset+0x3f>
		c &= 0xFF;
  8008f9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008fd:	89 d3                	mov    %edx,%ebx
  8008ff:	c1 e3 08             	shl    $0x8,%ebx
  800902:	89 d0                	mov    %edx,%eax
  800904:	c1 e0 18             	shl    $0x18,%eax
  800907:	89 d6                	mov    %edx,%esi
  800909:	c1 e6 10             	shl    $0x10,%esi
  80090c:	09 f0                	or     %esi,%eax
  80090e:	09 c2                	or     %eax,%edx
  800910:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800912:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800915:	89 d0                	mov    %edx,%eax
  800917:	fc                   	cld    
  800918:	f3 ab                	rep stos %eax,%es:(%edi)
  80091a:	eb 06                	jmp    800922 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091f:	fc                   	cld    
  800920:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800922:	89 f8                	mov    %edi,%eax
  800924:	5b                   	pop    %ebx
  800925:	5e                   	pop    %esi
  800926:	5f                   	pop    %edi
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800929:	f3 0f 1e fb          	endbr32 
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	57                   	push   %edi
  800931:	56                   	push   %esi
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	8b 75 0c             	mov    0xc(%ebp),%esi
  800938:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80093b:	39 c6                	cmp    %eax,%esi
  80093d:	73 32                	jae    800971 <memmove+0x48>
  80093f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800942:	39 c2                	cmp    %eax,%edx
  800944:	76 2b                	jbe    800971 <memmove+0x48>
		s += n;
		d += n;
  800946:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800949:	89 fe                	mov    %edi,%esi
  80094b:	09 ce                	or     %ecx,%esi
  80094d:	09 d6                	or     %edx,%esi
  80094f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800955:	75 0e                	jne    800965 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800957:	83 ef 04             	sub    $0x4,%edi
  80095a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80095d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800960:	fd                   	std    
  800961:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800963:	eb 09                	jmp    80096e <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800965:	83 ef 01             	sub    $0x1,%edi
  800968:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80096b:	fd                   	std    
  80096c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80096e:	fc                   	cld    
  80096f:	eb 1a                	jmp    80098b <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800971:	89 c2                	mov    %eax,%edx
  800973:	09 ca                	or     %ecx,%edx
  800975:	09 f2                	or     %esi,%edx
  800977:	f6 c2 03             	test   $0x3,%dl
  80097a:	75 0a                	jne    800986 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80097c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80097f:	89 c7                	mov    %eax,%edi
  800981:	fc                   	cld    
  800982:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800984:	eb 05                	jmp    80098b <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800986:	89 c7                	mov    %eax,%edi
  800988:	fc                   	cld    
  800989:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80098b:	5e                   	pop    %esi
  80098c:	5f                   	pop    %edi
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80098f:	f3 0f 1e fb          	endbr32 
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800999:	ff 75 10             	pushl  0x10(%ebp)
  80099c:	ff 75 0c             	pushl  0xc(%ebp)
  80099f:	ff 75 08             	pushl  0x8(%ebp)
  8009a2:	e8 82 ff ff ff       	call   800929 <memmove>
}
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    

008009a9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009a9:	f3 0f 1e fb          	endbr32 
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	56                   	push   %esi
  8009b1:	53                   	push   %ebx
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	89 c6                	mov    %eax,%esi
  8009ba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009bd:	39 f0                	cmp    %esi,%eax
  8009bf:	74 1c                	je     8009dd <memcmp+0x34>
		if (*s1 != *s2)
  8009c1:	0f b6 08             	movzbl (%eax),%ecx
  8009c4:	0f b6 1a             	movzbl (%edx),%ebx
  8009c7:	38 d9                	cmp    %bl,%cl
  8009c9:	75 08                	jne    8009d3 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009cb:	83 c0 01             	add    $0x1,%eax
  8009ce:	83 c2 01             	add    $0x1,%edx
  8009d1:	eb ea                	jmp    8009bd <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009d3:	0f b6 c1             	movzbl %cl,%eax
  8009d6:	0f b6 db             	movzbl %bl,%ebx
  8009d9:	29 d8                	sub    %ebx,%eax
  8009db:	eb 05                	jmp    8009e2 <memcmp+0x39>
	}

	return 0;
  8009dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e2:	5b                   	pop    %ebx
  8009e3:	5e                   	pop    %esi
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009e6:	f3 0f 1e fb          	endbr32 
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009f3:	89 c2                	mov    %eax,%edx
  8009f5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009f8:	39 d0                	cmp    %edx,%eax
  8009fa:	73 09                	jae    800a05 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009fc:	38 08                	cmp    %cl,(%eax)
  8009fe:	74 05                	je     800a05 <memfind+0x1f>
	for (; s < ends; s++)
  800a00:	83 c0 01             	add    $0x1,%eax
  800a03:	eb f3                	jmp    8009f8 <memfind+0x12>
			break;
	return (void *) s;
}
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a07:	f3 0f 1e fb          	endbr32 
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	57                   	push   %edi
  800a0f:	56                   	push   %esi
  800a10:	53                   	push   %ebx
  800a11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a17:	eb 03                	jmp    800a1c <strtol+0x15>
		s++;
  800a19:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a1c:	0f b6 01             	movzbl (%ecx),%eax
  800a1f:	3c 20                	cmp    $0x20,%al
  800a21:	74 f6                	je     800a19 <strtol+0x12>
  800a23:	3c 09                	cmp    $0x9,%al
  800a25:	74 f2                	je     800a19 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a27:	3c 2b                	cmp    $0x2b,%al
  800a29:	74 2a                	je     800a55 <strtol+0x4e>
	int neg = 0;
  800a2b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a30:	3c 2d                	cmp    $0x2d,%al
  800a32:	74 2b                	je     800a5f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a34:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a3a:	75 0f                	jne    800a4b <strtol+0x44>
  800a3c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a3f:	74 28                	je     800a69 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a48:	0f 44 d8             	cmove  %eax,%ebx
  800a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a50:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a53:	eb 46                	jmp    800a9b <strtol+0x94>
		s++;
  800a55:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a58:	bf 00 00 00 00       	mov    $0x0,%edi
  800a5d:	eb d5                	jmp    800a34 <strtol+0x2d>
		s++, neg = 1;
  800a5f:	83 c1 01             	add    $0x1,%ecx
  800a62:	bf 01 00 00 00       	mov    $0x1,%edi
  800a67:	eb cb                	jmp    800a34 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a69:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a6d:	74 0e                	je     800a7d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a6f:	85 db                	test   %ebx,%ebx
  800a71:	75 d8                	jne    800a4b <strtol+0x44>
		s++, base = 8;
  800a73:	83 c1 01             	add    $0x1,%ecx
  800a76:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a7b:	eb ce                	jmp    800a4b <strtol+0x44>
		s += 2, base = 16;
  800a7d:	83 c1 02             	add    $0x2,%ecx
  800a80:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a85:	eb c4                	jmp    800a4b <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a87:	0f be d2             	movsbl %dl,%edx
  800a8a:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a8d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a90:	7d 3a                	jge    800acc <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a92:	83 c1 01             	add    $0x1,%ecx
  800a95:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a99:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a9b:	0f b6 11             	movzbl (%ecx),%edx
  800a9e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aa1:	89 f3                	mov    %esi,%ebx
  800aa3:	80 fb 09             	cmp    $0x9,%bl
  800aa6:	76 df                	jbe    800a87 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800aa8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aab:	89 f3                	mov    %esi,%ebx
  800aad:	80 fb 19             	cmp    $0x19,%bl
  800ab0:	77 08                	ja     800aba <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ab2:	0f be d2             	movsbl %dl,%edx
  800ab5:	83 ea 57             	sub    $0x57,%edx
  800ab8:	eb d3                	jmp    800a8d <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800aba:	8d 72 bf             	lea    -0x41(%edx),%esi
  800abd:	89 f3                	mov    %esi,%ebx
  800abf:	80 fb 19             	cmp    $0x19,%bl
  800ac2:	77 08                	ja     800acc <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ac4:	0f be d2             	movsbl %dl,%edx
  800ac7:	83 ea 37             	sub    $0x37,%edx
  800aca:	eb c1                	jmp    800a8d <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800acc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad0:	74 05                	je     800ad7 <strtol+0xd0>
		*endptr = (char *) s;
  800ad2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ad7:	89 c2                	mov    %eax,%edx
  800ad9:	f7 da                	neg    %edx
  800adb:	85 ff                	test   %edi,%edi
  800add:	0f 45 c2             	cmovne %edx,%eax
}
  800ae0:	5b                   	pop    %ebx
  800ae1:	5e                   	pop    %esi
  800ae2:	5f                   	pop    %edi
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ae5:	f3 0f 1e fb          	endbr32 
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	57                   	push   %edi
  800aed:	56                   	push   %esi
  800aee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aef:	b8 00 00 00 00       	mov    $0x0,%eax
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800afa:	89 c3                	mov    %eax,%ebx
  800afc:	89 c7                	mov    %eax,%edi
  800afe:	89 c6                	mov    %eax,%esi
  800b00:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b02:	5b                   	pop    %ebx
  800b03:	5e                   	pop    %esi
  800b04:	5f                   	pop    %edi
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b07:	f3 0f 1e fb          	endbr32 
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	57                   	push   %edi
  800b0f:	56                   	push   %esi
  800b10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b11:	ba 00 00 00 00       	mov    $0x0,%edx
  800b16:	b8 01 00 00 00       	mov    $0x1,%eax
  800b1b:	89 d1                	mov    %edx,%ecx
  800b1d:	89 d3                	mov    %edx,%ebx
  800b1f:	89 d7                	mov    %edx,%edi
  800b21:	89 d6                	mov    %edx,%esi
  800b23:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b25:	5b                   	pop    %ebx
  800b26:	5e                   	pop    %esi
  800b27:	5f                   	pop    %edi
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b2a:	f3 0f 1e fb          	endbr32 
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	57                   	push   %edi
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b37:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b44:	89 cb                	mov    %ecx,%ebx
  800b46:	89 cf                	mov    %ecx,%edi
  800b48:	89 ce                	mov    %ecx,%esi
  800b4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b4c:	85 c0                	test   %eax,%eax
  800b4e:	7f 08                	jg     800b58 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b53:	5b                   	pop    %ebx
  800b54:	5e                   	pop    %esi
  800b55:	5f                   	pop    %edi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	50                   	push   %eax
  800b5c:	6a 03                	push   $0x3
  800b5e:	68 9f 27 80 00       	push   $0x80279f
  800b63:	6a 23                	push   $0x23
  800b65:	68 bc 27 80 00       	push   $0x8027bc
  800b6a:	e8 08 15 00 00       	call   802077 <_panic>

00800b6f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b6f:	f3 0f 1e fb          	endbr32 
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	57                   	push   %edi
  800b77:	56                   	push   %esi
  800b78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b79:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7e:	b8 02 00 00 00       	mov    $0x2,%eax
  800b83:	89 d1                	mov    %edx,%ecx
  800b85:	89 d3                	mov    %edx,%ebx
  800b87:	89 d7                	mov    %edx,%edi
  800b89:	89 d6                	mov    %edx,%esi
  800b8b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <sys_yield>:

void
sys_yield(void)
{
  800b92:	f3 0f 1e fb          	endbr32 
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	57                   	push   %edi
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ba6:	89 d1                	mov    %edx,%ecx
  800ba8:	89 d3                	mov    %edx,%ebx
  800baa:	89 d7                	mov    %edx,%edi
  800bac:	89 d6                	mov    %edx,%esi
  800bae:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb5:	f3 0f 1e fb          	endbr32 
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	57                   	push   %edi
  800bbd:	56                   	push   %esi
  800bbe:	53                   	push   %ebx
  800bbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc2:	be 00 00 00 00       	mov    $0x0,%esi
  800bc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcd:	b8 04 00 00 00       	mov    $0x4,%eax
  800bd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bd5:	89 f7                	mov    %esi,%edi
  800bd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd9:	85 c0                	test   %eax,%eax
  800bdb:	7f 08                	jg     800be5 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be5:	83 ec 0c             	sub    $0xc,%esp
  800be8:	50                   	push   %eax
  800be9:	6a 04                	push   $0x4
  800beb:	68 9f 27 80 00       	push   $0x80279f
  800bf0:	6a 23                	push   $0x23
  800bf2:	68 bc 27 80 00       	push   $0x8027bc
  800bf7:	e8 7b 14 00 00       	call   802077 <_panic>

00800bfc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bfc:	f3 0f 1e fb          	endbr32 
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	57                   	push   %edi
  800c04:	56                   	push   %esi
  800c05:	53                   	push   %ebx
  800c06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c09:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c14:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c17:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c1a:	8b 75 18             	mov    0x18(%ebp),%esi
  800c1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	7f 08                	jg     800c2b <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c26:	5b                   	pop    %ebx
  800c27:	5e                   	pop    %esi
  800c28:	5f                   	pop    %edi
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2b:	83 ec 0c             	sub    $0xc,%esp
  800c2e:	50                   	push   %eax
  800c2f:	6a 05                	push   $0x5
  800c31:	68 9f 27 80 00       	push   $0x80279f
  800c36:	6a 23                	push   $0x23
  800c38:	68 bc 27 80 00       	push   $0x8027bc
  800c3d:	e8 35 14 00 00       	call   802077 <_panic>

00800c42 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c42:	f3 0f 1e fb          	endbr32 
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	57                   	push   %edi
  800c4a:	56                   	push   %esi
  800c4b:	53                   	push   %ebx
  800c4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c54:	8b 55 08             	mov    0x8(%ebp),%edx
  800c57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5a:	b8 06 00 00 00       	mov    $0x6,%eax
  800c5f:	89 df                	mov    %ebx,%edi
  800c61:	89 de                	mov    %ebx,%esi
  800c63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c65:	85 c0                	test   %eax,%eax
  800c67:	7f 08                	jg     800c71 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6c:	5b                   	pop    %ebx
  800c6d:	5e                   	pop    %esi
  800c6e:	5f                   	pop    %edi
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c71:	83 ec 0c             	sub    $0xc,%esp
  800c74:	50                   	push   %eax
  800c75:	6a 06                	push   $0x6
  800c77:	68 9f 27 80 00       	push   $0x80279f
  800c7c:	6a 23                	push   $0x23
  800c7e:	68 bc 27 80 00       	push   $0x8027bc
  800c83:	e8 ef 13 00 00       	call   802077 <_panic>

00800c88 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c88:	f3 0f 1e fb          	endbr32 
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
  800c92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca0:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca5:	89 df                	mov    %ebx,%edi
  800ca7:	89 de                	mov    %ebx,%esi
  800ca9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cab:	85 c0                	test   %eax,%eax
  800cad:	7f 08                	jg     800cb7 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb2:	5b                   	pop    %ebx
  800cb3:	5e                   	pop    %esi
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb7:	83 ec 0c             	sub    $0xc,%esp
  800cba:	50                   	push   %eax
  800cbb:	6a 08                	push   $0x8
  800cbd:	68 9f 27 80 00       	push   $0x80279f
  800cc2:	6a 23                	push   $0x23
  800cc4:	68 bc 27 80 00       	push   $0x8027bc
  800cc9:	e8 a9 13 00 00       	call   802077 <_panic>

00800cce <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cce:	f3 0f 1e fb          	endbr32 
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	57                   	push   %edi
  800cd6:	56                   	push   %esi
  800cd7:	53                   	push   %ebx
  800cd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce6:	b8 09 00 00 00       	mov    $0x9,%eax
  800ceb:	89 df                	mov    %ebx,%edi
  800ced:	89 de                	mov    %ebx,%esi
  800cef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	7f 08                	jg     800cfd <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf8:	5b                   	pop    %ebx
  800cf9:	5e                   	pop    %esi
  800cfa:	5f                   	pop    %edi
  800cfb:	5d                   	pop    %ebp
  800cfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfd:	83 ec 0c             	sub    $0xc,%esp
  800d00:	50                   	push   %eax
  800d01:	6a 09                	push   $0x9
  800d03:	68 9f 27 80 00       	push   $0x80279f
  800d08:	6a 23                	push   $0x23
  800d0a:	68 bc 27 80 00       	push   $0x8027bc
  800d0f:	e8 63 13 00 00       	call   802077 <_panic>

00800d14 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d14:	f3 0f 1e fb          	endbr32 
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	57                   	push   %edi
  800d1c:	56                   	push   %esi
  800d1d:	53                   	push   %ebx
  800d1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d21:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d31:	89 df                	mov    %ebx,%edi
  800d33:	89 de                	mov    %ebx,%esi
  800d35:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d37:	85 c0                	test   %eax,%eax
  800d39:	7f 08                	jg     800d43 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d43:	83 ec 0c             	sub    $0xc,%esp
  800d46:	50                   	push   %eax
  800d47:	6a 0a                	push   $0xa
  800d49:	68 9f 27 80 00       	push   $0x80279f
  800d4e:	6a 23                	push   $0x23
  800d50:	68 bc 27 80 00       	push   $0x8027bc
  800d55:	e8 1d 13 00 00       	call   802077 <_panic>

00800d5a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d5a:	f3 0f 1e fb          	endbr32 
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	57                   	push   %edi
  800d62:	56                   	push   %esi
  800d63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d6f:	be 00 00 00 00       	mov    $0x0,%esi
  800d74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d81:	f3 0f 1e fb          	endbr32 
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d9b:	89 cb                	mov    %ecx,%ebx
  800d9d:	89 cf                	mov    %ecx,%edi
  800d9f:	89 ce                	mov    %ecx,%esi
  800da1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	7f 08                	jg     800daf <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800daa:	5b                   	pop    %ebx
  800dab:	5e                   	pop    %esi
  800dac:	5f                   	pop    %edi
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	50                   	push   %eax
  800db3:	6a 0d                	push   $0xd
  800db5:	68 9f 27 80 00       	push   $0x80279f
  800dba:	6a 23                	push   $0x23
  800dbc:	68 bc 27 80 00       	push   $0x8027bc
  800dc1:	e8 b1 12 00 00       	call   802077 <_panic>

00800dc6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dc6:	f3 0f 1e fb          	endbr32 
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dda:	89 d1                	mov    %edx,%ecx
  800ddc:	89 d3                	mov    %edx,%ebx
  800dde:	89 d7                	mov    %edx,%edi
  800de0:	89 d6                	mov    %edx,%esi
  800de2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800de9:	f3 0f 1e fb          	endbr32 
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e01:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e06:	89 df                	mov    %ebx,%edi
  800e08:	89 de                	mov    %ebx,%esi
  800e0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7f 08                	jg     800e18 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e18:	83 ec 0c             	sub    $0xc,%esp
  800e1b:	50                   	push   %eax
  800e1c:	6a 0f                	push   $0xf
  800e1e:	68 9f 27 80 00       	push   $0x80279f
  800e23:	6a 23                	push   $0x23
  800e25:	68 bc 27 80 00       	push   $0x8027bc
  800e2a:	e8 48 12 00 00       	call   802077 <_panic>

00800e2f <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800e2f:	f3 0f 1e fb          	endbr32 
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	8b 55 08             	mov    0x8(%ebp),%edx
  800e44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e47:	b8 10 00 00 00       	mov    $0x10,%eax
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7f 08                	jg     800e5e <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	50                   	push   %eax
  800e62:	6a 10                	push   $0x10
  800e64:	68 9f 27 80 00       	push   $0x80279f
  800e69:	6a 23                	push   $0x23
  800e6b:	68 bc 27 80 00       	push   $0x8027bc
  800e70:	e8 02 12 00 00       	call   802077 <_panic>

00800e75 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e75:	f3 0f 1e fb          	endbr32 
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	05 00 00 00 30       	add    $0x30000000,%eax
  800e84:	c1 e8 0c             	shr    $0xc,%eax
}
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    

00800e89 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e89:	f3 0f 1e fb          	endbr32 
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e9d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ea4:	f3 0f 1e fb          	endbr32 
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800eb0:	89 c2                	mov    %eax,%edx
  800eb2:	c1 ea 16             	shr    $0x16,%edx
  800eb5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ebc:	f6 c2 01             	test   $0x1,%dl
  800ebf:	74 2d                	je     800eee <fd_alloc+0x4a>
  800ec1:	89 c2                	mov    %eax,%edx
  800ec3:	c1 ea 0c             	shr    $0xc,%edx
  800ec6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ecd:	f6 c2 01             	test   $0x1,%dl
  800ed0:	74 1c                	je     800eee <fd_alloc+0x4a>
  800ed2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ed7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800edc:	75 d2                	jne    800eb0 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ee7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800eec:	eb 0a                	jmp    800ef8 <fd_alloc+0x54>
			*fd_store = fd;
  800eee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef1:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ef3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    

00800efa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800efa:	f3 0f 1e fb          	endbr32 
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f04:	83 f8 1f             	cmp    $0x1f,%eax
  800f07:	77 30                	ja     800f39 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f09:	c1 e0 0c             	shl    $0xc,%eax
  800f0c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f11:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f17:	f6 c2 01             	test   $0x1,%dl
  800f1a:	74 24                	je     800f40 <fd_lookup+0x46>
  800f1c:	89 c2                	mov    %eax,%edx
  800f1e:	c1 ea 0c             	shr    $0xc,%edx
  800f21:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f28:	f6 c2 01             	test   $0x1,%dl
  800f2b:	74 1a                	je     800f47 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f30:	89 02                	mov    %eax,(%edx)
	return 0;
  800f32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    
		return -E_INVAL;
  800f39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f3e:	eb f7                	jmp    800f37 <fd_lookup+0x3d>
		return -E_INVAL;
  800f40:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f45:	eb f0                	jmp    800f37 <fd_lookup+0x3d>
  800f47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f4c:	eb e9                	jmp    800f37 <fd_lookup+0x3d>

00800f4e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f4e:	f3 0f 1e fb          	endbr32 
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f60:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f65:	39 08                	cmp    %ecx,(%eax)
  800f67:	74 38                	je     800fa1 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800f69:	83 c2 01             	add    $0x1,%edx
  800f6c:	8b 04 95 48 28 80 00 	mov    0x802848(,%edx,4),%eax
  800f73:	85 c0                	test   %eax,%eax
  800f75:	75 ee                	jne    800f65 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f77:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800f7c:	8b 40 48             	mov    0x48(%eax),%eax
  800f7f:	83 ec 04             	sub    $0x4,%esp
  800f82:	51                   	push   %ecx
  800f83:	50                   	push   %eax
  800f84:	68 cc 27 80 00       	push   $0x8027cc
  800f89:	e8 db f1 ff ff       	call   800169 <cprintf>
	*dev = 0;
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f97:	83 c4 10             	add    $0x10,%esp
  800f9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    
			*dev = devtab[i];
  800fa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fab:	eb f2                	jmp    800f9f <dev_lookup+0x51>

00800fad <fd_close>:
{
  800fad:	f3 0f 1e fb          	endbr32 
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	57                   	push   %edi
  800fb5:	56                   	push   %esi
  800fb6:	53                   	push   %ebx
  800fb7:	83 ec 24             	sub    $0x24,%esp
  800fba:	8b 75 08             	mov    0x8(%ebp),%esi
  800fbd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fc0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fc3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fca:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fcd:	50                   	push   %eax
  800fce:	e8 27 ff ff ff       	call   800efa <fd_lookup>
  800fd3:	89 c3                	mov    %eax,%ebx
  800fd5:	83 c4 10             	add    $0x10,%esp
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	78 05                	js     800fe1 <fd_close+0x34>
	    || fd != fd2)
  800fdc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fdf:	74 16                	je     800ff7 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800fe1:	89 f8                	mov    %edi,%eax
  800fe3:	84 c0                	test   %al,%al
  800fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fea:	0f 44 d8             	cmove  %eax,%ebx
}
  800fed:	89 d8                	mov    %ebx,%eax
  800fef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff2:	5b                   	pop    %ebx
  800ff3:	5e                   	pop    %esi
  800ff4:	5f                   	pop    %edi
  800ff5:	5d                   	pop    %ebp
  800ff6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ffd:	50                   	push   %eax
  800ffe:	ff 36                	pushl  (%esi)
  801000:	e8 49 ff ff ff       	call   800f4e <dev_lookup>
  801005:	89 c3                	mov    %eax,%ebx
  801007:	83 c4 10             	add    $0x10,%esp
  80100a:	85 c0                	test   %eax,%eax
  80100c:	78 1a                	js     801028 <fd_close+0x7b>
		if (dev->dev_close)
  80100e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801011:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801014:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801019:	85 c0                	test   %eax,%eax
  80101b:	74 0b                	je     801028 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80101d:	83 ec 0c             	sub    $0xc,%esp
  801020:	56                   	push   %esi
  801021:	ff d0                	call   *%eax
  801023:	89 c3                	mov    %eax,%ebx
  801025:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801028:	83 ec 08             	sub    $0x8,%esp
  80102b:	56                   	push   %esi
  80102c:	6a 00                	push   $0x0
  80102e:	e8 0f fc ff ff       	call   800c42 <sys_page_unmap>
	return r;
  801033:	83 c4 10             	add    $0x10,%esp
  801036:	eb b5                	jmp    800fed <fd_close+0x40>

00801038 <close>:

int
close(int fdnum)
{
  801038:	f3 0f 1e fb          	endbr32 
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801042:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801045:	50                   	push   %eax
  801046:	ff 75 08             	pushl  0x8(%ebp)
  801049:	e8 ac fe ff ff       	call   800efa <fd_lookup>
  80104e:	83 c4 10             	add    $0x10,%esp
  801051:	85 c0                	test   %eax,%eax
  801053:	79 02                	jns    801057 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    
		return fd_close(fd, 1);
  801057:	83 ec 08             	sub    $0x8,%esp
  80105a:	6a 01                	push   $0x1
  80105c:	ff 75 f4             	pushl  -0xc(%ebp)
  80105f:	e8 49 ff ff ff       	call   800fad <fd_close>
  801064:	83 c4 10             	add    $0x10,%esp
  801067:	eb ec                	jmp    801055 <close+0x1d>

00801069 <close_all>:

void
close_all(void)
{
  801069:	f3 0f 1e fb          	endbr32 
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	53                   	push   %ebx
  801071:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801074:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	53                   	push   %ebx
  80107d:	e8 b6 ff ff ff       	call   801038 <close>
	for (i = 0; i < MAXFD; i++)
  801082:	83 c3 01             	add    $0x1,%ebx
  801085:	83 c4 10             	add    $0x10,%esp
  801088:	83 fb 20             	cmp    $0x20,%ebx
  80108b:	75 ec                	jne    801079 <close_all+0x10>
}
  80108d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801092:	f3 0f 1e fb          	endbr32 
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	57                   	push   %edi
  80109a:	56                   	push   %esi
  80109b:	53                   	push   %ebx
  80109c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80109f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010a2:	50                   	push   %eax
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 4f fe ff ff       	call   800efa <fd_lookup>
  8010ab:	89 c3                	mov    %eax,%ebx
  8010ad:	83 c4 10             	add    $0x10,%esp
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	0f 88 81 00 00 00    	js     801139 <dup+0xa7>
		return r;
	close(newfdnum);
  8010b8:	83 ec 0c             	sub    $0xc,%esp
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	e8 75 ff ff ff       	call   801038 <close>

	newfd = INDEX2FD(newfdnum);
  8010c3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010c6:	c1 e6 0c             	shl    $0xc,%esi
  8010c9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010cf:	83 c4 04             	add    $0x4,%esp
  8010d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d5:	e8 af fd ff ff       	call   800e89 <fd2data>
  8010da:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010dc:	89 34 24             	mov    %esi,(%esp)
  8010df:	e8 a5 fd ff ff       	call   800e89 <fd2data>
  8010e4:	83 c4 10             	add    $0x10,%esp
  8010e7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	c1 e8 16             	shr    $0x16,%eax
  8010ee:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010f5:	a8 01                	test   $0x1,%al
  8010f7:	74 11                	je     80110a <dup+0x78>
  8010f9:	89 d8                	mov    %ebx,%eax
  8010fb:	c1 e8 0c             	shr    $0xc,%eax
  8010fe:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801105:	f6 c2 01             	test   $0x1,%dl
  801108:	75 39                	jne    801143 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80110a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80110d:	89 d0                	mov    %edx,%eax
  80110f:	c1 e8 0c             	shr    $0xc,%eax
  801112:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	25 07 0e 00 00       	and    $0xe07,%eax
  801121:	50                   	push   %eax
  801122:	56                   	push   %esi
  801123:	6a 00                	push   $0x0
  801125:	52                   	push   %edx
  801126:	6a 00                	push   $0x0
  801128:	e8 cf fa ff ff       	call   800bfc <sys_page_map>
  80112d:	89 c3                	mov    %eax,%ebx
  80112f:	83 c4 20             	add    $0x20,%esp
  801132:	85 c0                	test   %eax,%eax
  801134:	78 31                	js     801167 <dup+0xd5>
		goto err;

	return newfdnum;
  801136:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801139:	89 d8                	mov    %ebx,%eax
  80113b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113e:	5b                   	pop    %ebx
  80113f:	5e                   	pop    %esi
  801140:	5f                   	pop    %edi
  801141:	5d                   	pop    %ebp
  801142:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801143:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80114a:	83 ec 0c             	sub    $0xc,%esp
  80114d:	25 07 0e 00 00       	and    $0xe07,%eax
  801152:	50                   	push   %eax
  801153:	57                   	push   %edi
  801154:	6a 00                	push   $0x0
  801156:	53                   	push   %ebx
  801157:	6a 00                	push   $0x0
  801159:	e8 9e fa ff ff       	call   800bfc <sys_page_map>
  80115e:	89 c3                	mov    %eax,%ebx
  801160:	83 c4 20             	add    $0x20,%esp
  801163:	85 c0                	test   %eax,%eax
  801165:	79 a3                	jns    80110a <dup+0x78>
	sys_page_unmap(0, newfd);
  801167:	83 ec 08             	sub    $0x8,%esp
  80116a:	56                   	push   %esi
  80116b:	6a 00                	push   $0x0
  80116d:	e8 d0 fa ff ff       	call   800c42 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801172:	83 c4 08             	add    $0x8,%esp
  801175:	57                   	push   %edi
  801176:	6a 00                	push   $0x0
  801178:	e8 c5 fa ff ff       	call   800c42 <sys_page_unmap>
	return r;
  80117d:	83 c4 10             	add    $0x10,%esp
  801180:	eb b7                	jmp    801139 <dup+0xa7>

00801182 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801182:	f3 0f 1e fb          	endbr32 
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	53                   	push   %ebx
  80118a:	83 ec 1c             	sub    $0x1c,%esp
  80118d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801190:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801193:	50                   	push   %eax
  801194:	53                   	push   %ebx
  801195:	e8 60 fd ff ff       	call   800efa <fd_lookup>
  80119a:	83 c4 10             	add    $0x10,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	78 3f                	js     8011e0 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a7:	50                   	push   %eax
  8011a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ab:	ff 30                	pushl  (%eax)
  8011ad:	e8 9c fd ff ff       	call   800f4e <dev_lookup>
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	78 27                	js     8011e0 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011bc:	8b 42 08             	mov    0x8(%edx),%eax
  8011bf:	83 e0 03             	and    $0x3,%eax
  8011c2:	83 f8 01             	cmp    $0x1,%eax
  8011c5:	74 1e                	je     8011e5 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ca:	8b 40 08             	mov    0x8(%eax),%eax
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	74 35                	je     801206 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011d1:	83 ec 04             	sub    $0x4,%esp
  8011d4:	ff 75 10             	pushl  0x10(%ebp)
  8011d7:	ff 75 0c             	pushl  0xc(%ebp)
  8011da:	52                   	push   %edx
  8011db:	ff d0                	call   *%eax
  8011dd:	83 c4 10             	add    $0x10,%esp
}
  8011e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011e5:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011ea:	8b 40 48             	mov    0x48(%eax),%eax
  8011ed:	83 ec 04             	sub    $0x4,%esp
  8011f0:	53                   	push   %ebx
  8011f1:	50                   	push   %eax
  8011f2:	68 0d 28 80 00       	push   $0x80280d
  8011f7:	e8 6d ef ff ff       	call   800169 <cprintf>
		return -E_INVAL;
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801204:	eb da                	jmp    8011e0 <read+0x5e>
		return -E_NOT_SUPP;
  801206:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80120b:	eb d3                	jmp    8011e0 <read+0x5e>

0080120d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80120d:	f3 0f 1e fb          	endbr32 
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	57                   	push   %edi
  801215:	56                   	push   %esi
  801216:	53                   	push   %ebx
  801217:	83 ec 0c             	sub    $0xc,%esp
  80121a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80121d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801220:	bb 00 00 00 00       	mov    $0x0,%ebx
  801225:	eb 02                	jmp    801229 <readn+0x1c>
  801227:	01 c3                	add    %eax,%ebx
  801229:	39 f3                	cmp    %esi,%ebx
  80122b:	73 21                	jae    80124e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80122d:	83 ec 04             	sub    $0x4,%esp
  801230:	89 f0                	mov    %esi,%eax
  801232:	29 d8                	sub    %ebx,%eax
  801234:	50                   	push   %eax
  801235:	89 d8                	mov    %ebx,%eax
  801237:	03 45 0c             	add    0xc(%ebp),%eax
  80123a:	50                   	push   %eax
  80123b:	57                   	push   %edi
  80123c:	e8 41 ff ff ff       	call   801182 <read>
		if (m < 0)
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	85 c0                	test   %eax,%eax
  801246:	78 04                	js     80124c <readn+0x3f>
			return m;
		if (m == 0)
  801248:	75 dd                	jne    801227 <readn+0x1a>
  80124a:	eb 02                	jmp    80124e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80124c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80124e:	89 d8                	mov    %ebx,%eax
  801250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801253:	5b                   	pop    %ebx
  801254:	5e                   	pop    %esi
  801255:	5f                   	pop    %edi
  801256:	5d                   	pop    %ebp
  801257:	c3                   	ret    

00801258 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801258:	f3 0f 1e fb          	endbr32 
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	53                   	push   %ebx
  801260:	83 ec 1c             	sub    $0x1c,%esp
  801263:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801266:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801269:	50                   	push   %eax
  80126a:	53                   	push   %ebx
  80126b:	e8 8a fc ff ff       	call   800efa <fd_lookup>
  801270:	83 c4 10             	add    $0x10,%esp
  801273:	85 c0                	test   %eax,%eax
  801275:	78 3a                	js     8012b1 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801277:	83 ec 08             	sub    $0x8,%esp
  80127a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127d:	50                   	push   %eax
  80127e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801281:	ff 30                	pushl  (%eax)
  801283:	e8 c6 fc ff ff       	call   800f4e <dev_lookup>
  801288:	83 c4 10             	add    $0x10,%esp
  80128b:	85 c0                	test   %eax,%eax
  80128d:	78 22                	js     8012b1 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80128f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801292:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801296:	74 1e                	je     8012b6 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801298:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129b:	8b 52 0c             	mov    0xc(%edx),%edx
  80129e:	85 d2                	test   %edx,%edx
  8012a0:	74 35                	je     8012d7 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012a2:	83 ec 04             	sub    $0x4,%esp
  8012a5:	ff 75 10             	pushl  0x10(%ebp)
  8012a8:	ff 75 0c             	pushl  0xc(%ebp)
  8012ab:	50                   	push   %eax
  8012ac:	ff d2                	call   *%edx
  8012ae:	83 c4 10             	add    $0x10,%esp
}
  8012b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012b6:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012bb:	8b 40 48             	mov    0x48(%eax),%eax
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	53                   	push   %ebx
  8012c2:	50                   	push   %eax
  8012c3:	68 29 28 80 00       	push   $0x802829
  8012c8:	e8 9c ee ff ff       	call   800169 <cprintf>
		return -E_INVAL;
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d5:	eb da                	jmp    8012b1 <write+0x59>
		return -E_NOT_SUPP;
  8012d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012dc:	eb d3                	jmp    8012b1 <write+0x59>

008012de <seek>:

int
seek(int fdnum, off_t offset)
{
  8012de:	f3 0f 1e fb          	endbr32 
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012eb:	50                   	push   %eax
  8012ec:	ff 75 08             	pushl  0x8(%ebp)
  8012ef:	e8 06 fc ff ff       	call   800efa <fd_lookup>
  8012f4:	83 c4 10             	add    $0x10,%esp
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	78 0e                	js     801309 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8012fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801301:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80130b:	f3 0f 1e fb          	endbr32 
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	53                   	push   %ebx
  801313:	83 ec 1c             	sub    $0x1c,%esp
  801316:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801319:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131c:	50                   	push   %eax
  80131d:	53                   	push   %ebx
  80131e:	e8 d7 fb ff ff       	call   800efa <fd_lookup>
  801323:	83 c4 10             	add    $0x10,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	78 37                	js     801361 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80132a:	83 ec 08             	sub    $0x8,%esp
  80132d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801330:	50                   	push   %eax
  801331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801334:	ff 30                	pushl  (%eax)
  801336:	e8 13 fc ff ff       	call   800f4e <dev_lookup>
  80133b:	83 c4 10             	add    $0x10,%esp
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 1f                	js     801361 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801345:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801349:	74 1b                	je     801366 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80134b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134e:	8b 52 18             	mov    0x18(%edx),%edx
  801351:	85 d2                	test   %edx,%edx
  801353:	74 32                	je     801387 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801355:	83 ec 08             	sub    $0x8,%esp
  801358:	ff 75 0c             	pushl  0xc(%ebp)
  80135b:	50                   	push   %eax
  80135c:	ff d2                	call   *%edx
  80135e:	83 c4 10             	add    $0x10,%esp
}
  801361:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801364:	c9                   	leave  
  801365:	c3                   	ret    
			thisenv->env_id, fdnum);
  801366:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80136b:	8b 40 48             	mov    0x48(%eax),%eax
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	53                   	push   %ebx
  801372:	50                   	push   %eax
  801373:	68 ec 27 80 00       	push   $0x8027ec
  801378:	e8 ec ed ff ff       	call   800169 <cprintf>
		return -E_INVAL;
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801385:	eb da                	jmp    801361 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801387:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80138c:	eb d3                	jmp    801361 <ftruncate+0x56>

0080138e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80138e:	f3 0f 1e fb          	endbr32 
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	53                   	push   %ebx
  801396:	83 ec 1c             	sub    $0x1c,%esp
  801399:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139f:	50                   	push   %eax
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 52 fb ff ff       	call   800efa <fd_lookup>
  8013a8:	83 c4 10             	add    $0x10,%esp
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	78 4b                	js     8013fa <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013af:	83 ec 08             	sub    $0x8,%esp
  8013b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b5:	50                   	push   %eax
  8013b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b9:	ff 30                	pushl  (%eax)
  8013bb:	e8 8e fb ff ff       	call   800f4e <dev_lookup>
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	78 33                	js     8013fa <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8013c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ca:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013ce:	74 2f                	je     8013ff <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013d0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013d3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013da:	00 00 00 
	stat->st_isdir = 0;
  8013dd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013e4:	00 00 00 
	stat->st_dev = dev;
  8013e7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013ed:	83 ec 08             	sub    $0x8,%esp
  8013f0:	53                   	push   %ebx
  8013f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8013f4:	ff 50 14             	call   *0x14(%eax)
  8013f7:	83 c4 10             	add    $0x10,%esp
}
  8013fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    
		return -E_NOT_SUPP;
  8013ff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801404:	eb f4                	jmp    8013fa <fstat+0x6c>

00801406 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801406:	f3 0f 1e fb          	endbr32 
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	56                   	push   %esi
  80140e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80140f:	83 ec 08             	sub    $0x8,%esp
  801412:	6a 00                	push   $0x0
  801414:	ff 75 08             	pushl  0x8(%ebp)
  801417:	e8 fb 01 00 00       	call   801617 <open>
  80141c:	89 c3                	mov    %eax,%ebx
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 1b                	js     801440 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 0c             	pushl  0xc(%ebp)
  80142b:	50                   	push   %eax
  80142c:	e8 5d ff ff ff       	call   80138e <fstat>
  801431:	89 c6                	mov    %eax,%esi
	close(fd);
  801433:	89 1c 24             	mov    %ebx,(%esp)
  801436:	e8 fd fb ff ff       	call   801038 <close>
	return r;
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	89 f3                	mov    %esi,%ebx
}
  801440:	89 d8                	mov    %ebx,%eax
  801442:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801445:	5b                   	pop    %ebx
  801446:	5e                   	pop    %esi
  801447:	5d                   	pop    %ebp
  801448:	c3                   	ret    

00801449 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	56                   	push   %esi
  80144d:	53                   	push   %ebx
  80144e:	89 c6                	mov    %eax,%esi
  801450:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801452:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801459:	74 27                	je     801482 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80145b:	6a 07                	push   $0x7
  80145d:	68 00 50 80 00       	push   $0x805000
  801462:	56                   	push   %esi
  801463:	ff 35 00 40 80 00    	pushl  0x804000
  801469:	e8 d8 0c 00 00       	call   802146 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80146e:	83 c4 0c             	add    $0xc,%esp
  801471:	6a 00                	push   $0x0
  801473:	53                   	push   %ebx
  801474:	6a 00                	push   $0x0
  801476:	e8 46 0c 00 00       	call   8020c1 <ipc_recv>
}
  80147b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80147e:	5b                   	pop    %ebx
  80147f:	5e                   	pop    %esi
  801480:	5d                   	pop    %ebp
  801481:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801482:	83 ec 0c             	sub    $0xc,%esp
  801485:	6a 01                	push   $0x1
  801487:	e8 12 0d 00 00       	call   80219e <ipc_find_env>
  80148c:	a3 00 40 80 00       	mov    %eax,0x804000
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	eb c5                	jmp    80145b <fsipc+0x12>

00801496 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801496:	f3 0f 1e fb          	endbr32 
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ae:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b8:	b8 02 00 00 00       	mov    $0x2,%eax
  8014bd:	e8 87 ff ff ff       	call   801449 <fsipc>
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <devfile_flush>:
{
  8014c4:	f3 0f 1e fb          	endbr32 
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8014d4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014de:	b8 06 00 00 00       	mov    $0x6,%eax
  8014e3:	e8 61 ff ff ff       	call   801449 <fsipc>
}
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <devfile_stat>:
{
  8014ea:	f3 0f 1e fb          	endbr32 
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	53                   	push   %ebx
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8014fe:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801503:	ba 00 00 00 00       	mov    $0x0,%edx
  801508:	b8 05 00 00 00       	mov    $0x5,%eax
  80150d:	e8 37 ff ff ff       	call   801449 <fsipc>
  801512:	85 c0                	test   %eax,%eax
  801514:	78 2c                	js     801542 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	68 00 50 80 00       	push   $0x805000
  80151e:	53                   	push   %ebx
  80151f:	e8 4f f2 ff ff       	call   800773 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801524:	a1 80 50 80 00       	mov    0x805080,%eax
  801529:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80152f:	a1 84 50 80 00       	mov    0x805084,%eax
  801534:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <devfile_write>:
{
  801547:	f3 0f 1e fb          	endbr32 
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 0c             	sub    $0xc,%esp
  801551:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801554:	8b 55 08             	mov    0x8(%ebp),%edx
  801557:	8b 52 0c             	mov    0xc(%edx),%edx
  80155a:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801560:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801565:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80156a:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80156d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801572:	50                   	push   %eax
  801573:	ff 75 0c             	pushl  0xc(%ebp)
  801576:	68 08 50 80 00       	push   $0x805008
  80157b:	e8 a9 f3 ff ff       	call   800929 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801580:	ba 00 00 00 00       	mov    $0x0,%edx
  801585:	b8 04 00 00 00       	mov    $0x4,%eax
  80158a:	e8 ba fe ff ff       	call   801449 <fsipc>
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <devfile_read>:
{
  801591:	f3 0f 1e fb          	endbr32 
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	56                   	push   %esi
  801599:	53                   	push   %ebx
  80159a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015a8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8015b8:	e8 8c fe ff ff       	call   801449 <fsipc>
  8015bd:	89 c3                	mov    %eax,%ebx
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	78 1f                	js     8015e2 <devfile_read+0x51>
	assert(r <= n);
  8015c3:	39 f0                	cmp    %esi,%eax
  8015c5:	77 24                	ja     8015eb <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8015c7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015cc:	7f 33                	jg     801601 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015ce:	83 ec 04             	sub    $0x4,%esp
  8015d1:	50                   	push   %eax
  8015d2:	68 00 50 80 00       	push   $0x805000
  8015d7:	ff 75 0c             	pushl  0xc(%ebp)
  8015da:	e8 4a f3 ff ff       	call   800929 <memmove>
	return r;
  8015df:	83 c4 10             	add    $0x10,%esp
}
  8015e2:	89 d8                	mov    %ebx,%eax
  8015e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e7:	5b                   	pop    %ebx
  8015e8:	5e                   	pop    %esi
  8015e9:	5d                   	pop    %ebp
  8015ea:	c3                   	ret    
	assert(r <= n);
  8015eb:	68 5c 28 80 00       	push   $0x80285c
  8015f0:	68 63 28 80 00       	push   $0x802863
  8015f5:	6a 7c                	push   $0x7c
  8015f7:	68 78 28 80 00       	push   $0x802878
  8015fc:	e8 76 0a 00 00       	call   802077 <_panic>
	assert(r <= PGSIZE);
  801601:	68 83 28 80 00       	push   $0x802883
  801606:	68 63 28 80 00       	push   $0x802863
  80160b:	6a 7d                	push   $0x7d
  80160d:	68 78 28 80 00       	push   $0x802878
  801612:	e8 60 0a 00 00       	call   802077 <_panic>

00801617 <open>:
{
  801617:	f3 0f 1e fb          	endbr32 
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	56                   	push   %esi
  80161f:	53                   	push   %ebx
  801620:	83 ec 1c             	sub    $0x1c,%esp
  801623:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801626:	56                   	push   %esi
  801627:	e8 04 f1 ff ff       	call   800730 <strlen>
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801634:	7f 6c                	jg     8016a2 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801636:	83 ec 0c             	sub    $0xc,%esp
  801639:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163c:	50                   	push   %eax
  80163d:	e8 62 f8 ff ff       	call   800ea4 <fd_alloc>
  801642:	89 c3                	mov    %eax,%ebx
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	85 c0                	test   %eax,%eax
  801649:	78 3c                	js     801687 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80164b:	83 ec 08             	sub    $0x8,%esp
  80164e:	56                   	push   %esi
  80164f:	68 00 50 80 00       	push   $0x805000
  801654:	e8 1a f1 ff ff       	call   800773 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801659:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801661:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801664:	b8 01 00 00 00       	mov    $0x1,%eax
  801669:	e8 db fd ff ff       	call   801449 <fsipc>
  80166e:	89 c3                	mov    %eax,%ebx
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	85 c0                	test   %eax,%eax
  801675:	78 19                	js     801690 <open+0x79>
	return fd2num(fd);
  801677:	83 ec 0c             	sub    $0xc,%esp
  80167a:	ff 75 f4             	pushl  -0xc(%ebp)
  80167d:	e8 f3 f7 ff ff       	call   800e75 <fd2num>
  801682:	89 c3                	mov    %eax,%ebx
  801684:	83 c4 10             	add    $0x10,%esp
}
  801687:	89 d8                	mov    %ebx,%eax
  801689:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80168c:	5b                   	pop    %ebx
  80168d:	5e                   	pop    %esi
  80168e:	5d                   	pop    %ebp
  80168f:	c3                   	ret    
		fd_close(fd, 0);
  801690:	83 ec 08             	sub    $0x8,%esp
  801693:	6a 00                	push   $0x0
  801695:	ff 75 f4             	pushl  -0xc(%ebp)
  801698:	e8 10 f9 ff ff       	call   800fad <fd_close>
		return r;
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	eb e5                	jmp    801687 <open+0x70>
		return -E_BAD_PATH;
  8016a2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016a7:	eb de                	jmp    801687 <open+0x70>

008016a9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016a9:	f3 0f 1e fb          	endbr32 
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8016bd:	e8 87 fd ff ff       	call   801449 <fsipc>
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8016c4:	f3 0f 1e fb          	endbr32 
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8016ce:	68 8f 28 80 00       	push   $0x80288f
  8016d3:	ff 75 0c             	pushl  0xc(%ebp)
  8016d6:	e8 98 f0 ff ff       	call   800773 <strcpy>
	return 0;
}
  8016db:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <devsock_close>:
{
  8016e2:	f3 0f 1e fb          	endbr32 
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	53                   	push   %ebx
  8016ea:	83 ec 10             	sub    $0x10,%esp
  8016ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8016f0:	53                   	push   %ebx
  8016f1:	e8 e5 0a 00 00       	call   8021db <pageref>
  8016f6:	89 c2                	mov    %eax,%edx
  8016f8:	83 c4 10             	add    $0x10,%esp
		return 0;
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801700:	83 fa 01             	cmp    $0x1,%edx
  801703:	74 05                	je     80170a <devsock_close+0x28>
}
  801705:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801708:	c9                   	leave  
  801709:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80170a:	83 ec 0c             	sub    $0xc,%esp
  80170d:	ff 73 0c             	pushl  0xc(%ebx)
  801710:	e8 e3 02 00 00       	call   8019f8 <nsipc_close>
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	eb eb                	jmp    801705 <devsock_close+0x23>

0080171a <devsock_write>:
{
  80171a:	f3 0f 1e fb          	endbr32 
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801724:	6a 00                	push   $0x0
  801726:	ff 75 10             	pushl  0x10(%ebp)
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	ff 70 0c             	pushl  0xc(%eax)
  801732:	e8 b5 03 00 00       	call   801aec <nsipc_send>
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <devsock_read>:
{
  801739:	f3 0f 1e fb          	endbr32 
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801743:	6a 00                	push   $0x0
  801745:	ff 75 10             	pushl  0x10(%ebp)
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	ff 70 0c             	pushl  0xc(%eax)
  801751:	e8 1f 03 00 00       	call   801a75 <nsipc_recv>
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <fd2sockid>:
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80175e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801761:	52                   	push   %edx
  801762:	50                   	push   %eax
  801763:	e8 92 f7 ff ff       	call   800efa <fd_lookup>
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	85 c0                	test   %eax,%eax
  80176d:	78 10                	js     80177f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80176f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801772:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801778:	39 08                	cmp    %ecx,(%eax)
  80177a:	75 05                	jne    801781 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80177c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    
		return -E_NOT_SUPP;
  801781:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801786:	eb f7                	jmp    80177f <fd2sockid+0x27>

00801788 <alloc_sockfd>:
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	56                   	push   %esi
  80178c:	53                   	push   %ebx
  80178d:	83 ec 1c             	sub    $0x1c,%esp
  801790:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801792:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801795:	50                   	push   %eax
  801796:	e8 09 f7 ff ff       	call   800ea4 <fd_alloc>
  80179b:	89 c3                	mov    %eax,%ebx
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	78 43                	js     8017e7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8017a4:	83 ec 04             	sub    $0x4,%esp
  8017a7:	68 07 04 00 00       	push   $0x407
  8017ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8017af:	6a 00                	push   $0x0
  8017b1:	e8 ff f3 ff ff       	call   800bb5 <sys_page_alloc>
  8017b6:	89 c3                	mov    %eax,%ebx
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	78 28                	js     8017e7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8017bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017c8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8017d4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8017d7:	83 ec 0c             	sub    $0xc,%esp
  8017da:	50                   	push   %eax
  8017db:	e8 95 f6 ff ff       	call   800e75 <fd2num>
  8017e0:	89 c3                	mov    %eax,%ebx
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	eb 0c                	jmp    8017f3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8017e7:	83 ec 0c             	sub    $0xc,%esp
  8017ea:	56                   	push   %esi
  8017eb:	e8 08 02 00 00       	call   8019f8 <nsipc_close>
		return r;
  8017f0:	83 c4 10             	add    $0x10,%esp
}
  8017f3:	89 d8                	mov    %ebx,%eax
  8017f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f8:	5b                   	pop    %ebx
  8017f9:	5e                   	pop    %esi
  8017fa:	5d                   	pop    %ebp
  8017fb:	c3                   	ret    

008017fc <accept>:
{
  8017fc:	f3 0f 1e fb          	endbr32 
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	e8 4a ff ff ff       	call   801758 <fd2sockid>
  80180e:	85 c0                	test   %eax,%eax
  801810:	78 1b                	js     80182d <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801812:	83 ec 04             	sub    $0x4,%esp
  801815:	ff 75 10             	pushl  0x10(%ebp)
  801818:	ff 75 0c             	pushl  0xc(%ebp)
  80181b:	50                   	push   %eax
  80181c:	e8 22 01 00 00       	call   801943 <nsipc_accept>
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	85 c0                	test   %eax,%eax
  801826:	78 05                	js     80182d <accept+0x31>
	return alloc_sockfd(r);
  801828:	e8 5b ff ff ff       	call   801788 <alloc_sockfd>
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <bind>:
{
  80182f:	f3 0f 1e fb          	endbr32 
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	e8 17 ff ff ff       	call   801758 <fd2sockid>
  801841:	85 c0                	test   %eax,%eax
  801843:	78 12                	js     801857 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	ff 75 10             	pushl  0x10(%ebp)
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	50                   	push   %eax
  80184f:	e8 45 01 00 00       	call   801999 <nsipc_bind>
  801854:	83 c4 10             	add    $0x10,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <shutdown>:
{
  801859:	f3 0f 1e fb          	endbr32 
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	e8 ed fe ff ff       	call   801758 <fd2sockid>
  80186b:	85 c0                	test   %eax,%eax
  80186d:	78 0f                	js     80187e <shutdown+0x25>
	return nsipc_shutdown(r, how);
  80186f:	83 ec 08             	sub    $0x8,%esp
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	50                   	push   %eax
  801876:	e8 57 01 00 00       	call   8019d2 <nsipc_shutdown>
  80187b:	83 c4 10             	add    $0x10,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <connect>:
{
  801880:	f3 0f 1e fb          	endbr32 
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	e8 c6 fe ff ff       	call   801758 <fd2sockid>
  801892:	85 c0                	test   %eax,%eax
  801894:	78 12                	js     8018a8 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801896:	83 ec 04             	sub    $0x4,%esp
  801899:	ff 75 10             	pushl  0x10(%ebp)
  80189c:	ff 75 0c             	pushl  0xc(%ebp)
  80189f:	50                   	push   %eax
  8018a0:	e8 71 01 00 00       	call   801a16 <nsipc_connect>
  8018a5:	83 c4 10             	add    $0x10,%esp
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <listen>:
{
  8018aa:	f3 0f 1e fb          	endbr32 
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	e8 9c fe ff ff       	call   801758 <fd2sockid>
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	78 0f                	js     8018cf <listen+0x25>
	return nsipc_listen(r, backlog);
  8018c0:	83 ec 08             	sub    $0x8,%esp
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	50                   	push   %eax
  8018c7:	e8 83 01 00 00       	call   801a4f <nsipc_listen>
  8018cc:	83 c4 10             	add    $0x10,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8018d1:	f3 0f 1e fb          	endbr32 
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8018db:	ff 75 10             	pushl  0x10(%ebp)
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	ff 75 08             	pushl  0x8(%ebp)
  8018e4:	e8 65 02 00 00       	call   801b4e <nsipc_socket>
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 05                	js     8018f5 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8018f0:	e8 93 fe ff ff       	call   801788 <alloc_sockfd>
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	53                   	push   %ebx
  8018fb:	83 ec 04             	sub    $0x4,%esp
  8018fe:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801900:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801907:	74 26                	je     80192f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801909:	6a 07                	push   $0x7
  80190b:	68 00 60 80 00       	push   $0x806000
  801910:	53                   	push   %ebx
  801911:	ff 35 04 40 80 00    	pushl  0x804004
  801917:	e8 2a 08 00 00       	call   802146 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80191c:	83 c4 0c             	add    $0xc,%esp
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	e8 97 07 00 00       	call   8020c1 <ipc_recv>
}
  80192a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80192f:	83 ec 0c             	sub    $0xc,%esp
  801932:	6a 02                	push   $0x2
  801934:	e8 65 08 00 00       	call   80219e <ipc_find_env>
  801939:	a3 04 40 80 00       	mov    %eax,0x804004
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	eb c6                	jmp    801909 <nsipc+0x12>

00801943 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801943:	f3 0f 1e fb          	endbr32 
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	56                   	push   %esi
  80194b:	53                   	push   %ebx
  80194c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801957:	8b 06                	mov    (%esi),%eax
  801959:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80195e:	b8 01 00 00 00       	mov    $0x1,%eax
  801963:	e8 8f ff ff ff       	call   8018f7 <nsipc>
  801968:	89 c3                	mov    %eax,%ebx
  80196a:	85 c0                	test   %eax,%eax
  80196c:	79 09                	jns    801977 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80196e:	89 d8                	mov    %ebx,%eax
  801970:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801973:	5b                   	pop    %ebx
  801974:	5e                   	pop    %esi
  801975:	5d                   	pop    %ebp
  801976:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801977:	83 ec 04             	sub    $0x4,%esp
  80197a:	ff 35 10 60 80 00    	pushl  0x806010
  801980:	68 00 60 80 00       	push   $0x806000
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	e8 9c ef ff ff       	call   800929 <memmove>
		*addrlen = ret->ret_addrlen;
  80198d:	a1 10 60 80 00       	mov    0x806010,%eax
  801992:	89 06                	mov    %eax,(%esi)
  801994:	83 c4 10             	add    $0x10,%esp
	return r;
  801997:	eb d5                	jmp    80196e <nsipc_accept+0x2b>

00801999 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801999:	f3 0f 1e fb          	endbr32 
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	53                   	push   %ebx
  8019a1:	83 ec 08             	sub    $0x8,%esp
  8019a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8019af:	53                   	push   %ebx
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	68 04 60 80 00       	push   $0x806004
  8019b8:	e8 6c ef ff ff       	call   800929 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8019bd:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8019c3:	b8 02 00 00 00       	mov    $0x2,%eax
  8019c8:	e8 2a ff ff ff       	call   8018f7 <nsipc>
}
  8019cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8019d2:	f3 0f 1e fb          	endbr32 
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8019e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8019ec:	b8 03 00 00 00       	mov    $0x3,%eax
  8019f1:	e8 01 ff ff ff       	call   8018f7 <nsipc>
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <nsipc_close>:

int
nsipc_close(int s)
{
  8019f8:	f3 0f 1e fb          	endbr32 
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801a0a:	b8 04 00 00 00       	mov    $0x4,%eax
  801a0f:	e8 e3 fe ff ff       	call   8018f7 <nsipc>
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a16:	f3 0f 1e fb          	endbr32 
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	53                   	push   %ebx
  801a1e:	83 ec 08             	sub    $0x8,%esp
  801a21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801a2c:	53                   	push   %ebx
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	68 04 60 80 00       	push   $0x806004
  801a35:	e8 ef ee ff ff       	call   800929 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801a3a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801a40:	b8 05 00 00 00       	mov    $0x5,%eax
  801a45:	e8 ad fe ff ff       	call   8018f7 <nsipc>
}
  801a4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801a4f:	f3 0f 1e fb          	endbr32 
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a64:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801a69:	b8 06 00 00 00       	mov    $0x6,%eax
  801a6e:	e8 84 fe ff ff       	call   8018f7 <nsipc>
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a75:	f3 0f 1e fb          	endbr32 
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	56                   	push   %esi
  801a7d:	53                   	push   %ebx
  801a7e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801a89:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a92:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a97:	b8 07 00 00 00       	mov    $0x7,%eax
  801a9c:	e8 56 fe ff ff       	call   8018f7 <nsipc>
  801aa1:	89 c3                	mov    %eax,%ebx
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	78 26                	js     801acd <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801aa7:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801aad:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801ab2:	0f 4e c6             	cmovle %esi,%eax
  801ab5:	39 c3                	cmp    %eax,%ebx
  801ab7:	7f 1d                	jg     801ad6 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ab9:	83 ec 04             	sub    $0x4,%esp
  801abc:	53                   	push   %ebx
  801abd:	68 00 60 80 00       	push   $0x806000
  801ac2:	ff 75 0c             	pushl  0xc(%ebp)
  801ac5:	e8 5f ee ff ff       	call   800929 <memmove>
  801aca:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801acd:	89 d8                	mov    %ebx,%eax
  801acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad2:	5b                   	pop    %ebx
  801ad3:	5e                   	pop    %esi
  801ad4:	5d                   	pop    %ebp
  801ad5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ad6:	68 9b 28 80 00       	push   $0x80289b
  801adb:	68 63 28 80 00       	push   $0x802863
  801ae0:	6a 62                	push   $0x62
  801ae2:	68 b0 28 80 00       	push   $0x8028b0
  801ae7:	e8 8b 05 00 00       	call   802077 <_panic>

00801aec <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801aec:	f3 0f 1e fb          	endbr32 
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	53                   	push   %ebx
  801af4:	83 ec 04             	sub    $0x4,%esp
  801af7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801b02:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801b08:	7f 2e                	jg     801b38 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801b0a:	83 ec 04             	sub    $0x4,%esp
  801b0d:	53                   	push   %ebx
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	68 0c 60 80 00       	push   $0x80600c
  801b16:	e8 0e ee ff ff       	call   800929 <memmove>
	nsipcbuf.send.req_size = size;
  801b1b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801b21:	8b 45 14             	mov    0x14(%ebp),%eax
  801b24:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801b29:	b8 08 00 00 00       	mov    $0x8,%eax
  801b2e:	e8 c4 fd ff ff       	call   8018f7 <nsipc>
}
  801b33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    
	assert(size < 1600);
  801b38:	68 bc 28 80 00       	push   $0x8028bc
  801b3d:	68 63 28 80 00       	push   $0x802863
  801b42:	6a 6d                	push   $0x6d
  801b44:	68 b0 28 80 00       	push   $0x8028b0
  801b49:	e8 29 05 00 00       	call   802077 <_panic>

00801b4e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801b4e:	f3 0f 1e fb          	endbr32 
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b63:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801b68:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801b70:	b8 09 00 00 00       	mov    $0x9,%eax
  801b75:	e8 7d fd ff ff       	call   8018f7 <nsipc>
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b7c:	f3 0f 1e fb          	endbr32 
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	56                   	push   %esi
  801b84:	53                   	push   %ebx
  801b85:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b88:	83 ec 0c             	sub    $0xc,%esp
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	e8 f6 f2 ff ff       	call   800e89 <fd2data>
  801b93:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b95:	83 c4 08             	add    $0x8,%esp
  801b98:	68 c8 28 80 00       	push   $0x8028c8
  801b9d:	53                   	push   %ebx
  801b9e:	e8 d0 eb ff ff       	call   800773 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ba3:	8b 46 04             	mov    0x4(%esi),%eax
  801ba6:	2b 06                	sub    (%esi),%eax
  801ba8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bb5:	00 00 00 
	stat->st_dev = &devpipe;
  801bb8:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801bbf:	30 80 00 
	return 0;
}
  801bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bca:	5b                   	pop    %ebx
  801bcb:	5e                   	pop    %esi
  801bcc:	5d                   	pop    %ebp
  801bcd:	c3                   	ret    

00801bce <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bce:	f3 0f 1e fb          	endbr32 
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	53                   	push   %ebx
  801bd6:	83 ec 0c             	sub    $0xc,%esp
  801bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bdc:	53                   	push   %ebx
  801bdd:	6a 00                	push   $0x0
  801bdf:	e8 5e f0 ff ff       	call   800c42 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801be4:	89 1c 24             	mov    %ebx,(%esp)
  801be7:	e8 9d f2 ff ff       	call   800e89 <fd2data>
  801bec:	83 c4 08             	add    $0x8,%esp
  801bef:	50                   	push   %eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	e8 4b f0 ff ff       	call   800c42 <sys_page_unmap>
}
  801bf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <_pipeisclosed>:
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	57                   	push   %edi
  801c00:	56                   	push   %esi
  801c01:	53                   	push   %ebx
  801c02:	83 ec 1c             	sub    $0x1c,%esp
  801c05:	89 c7                	mov    %eax,%edi
  801c07:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c09:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801c0e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c11:	83 ec 0c             	sub    $0xc,%esp
  801c14:	57                   	push   %edi
  801c15:	e8 c1 05 00 00       	call   8021db <pageref>
  801c1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c1d:	89 34 24             	mov    %esi,(%esp)
  801c20:	e8 b6 05 00 00       	call   8021db <pageref>
		nn = thisenv->env_runs;
  801c25:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801c2b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c2e:	83 c4 10             	add    $0x10,%esp
  801c31:	39 cb                	cmp    %ecx,%ebx
  801c33:	74 1b                	je     801c50 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c35:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c38:	75 cf                	jne    801c09 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c3a:	8b 42 58             	mov    0x58(%edx),%eax
  801c3d:	6a 01                	push   $0x1
  801c3f:	50                   	push   %eax
  801c40:	53                   	push   %ebx
  801c41:	68 cf 28 80 00       	push   $0x8028cf
  801c46:	e8 1e e5 ff ff       	call   800169 <cprintf>
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	eb b9                	jmp    801c09 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c50:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c53:	0f 94 c0             	sete   %al
  801c56:	0f b6 c0             	movzbl %al,%eax
}
  801c59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c5c:	5b                   	pop    %ebx
  801c5d:	5e                   	pop    %esi
  801c5e:	5f                   	pop    %edi
  801c5f:	5d                   	pop    %ebp
  801c60:	c3                   	ret    

00801c61 <devpipe_write>:
{
  801c61:	f3 0f 1e fb          	endbr32 
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	57                   	push   %edi
  801c69:	56                   	push   %esi
  801c6a:	53                   	push   %ebx
  801c6b:	83 ec 28             	sub    $0x28,%esp
  801c6e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c71:	56                   	push   %esi
  801c72:	e8 12 f2 ff ff       	call   800e89 <fd2data>
  801c77:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c79:	83 c4 10             	add    $0x10,%esp
  801c7c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c81:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c84:	74 4f                	je     801cd5 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c86:	8b 43 04             	mov    0x4(%ebx),%eax
  801c89:	8b 0b                	mov    (%ebx),%ecx
  801c8b:	8d 51 20             	lea    0x20(%ecx),%edx
  801c8e:	39 d0                	cmp    %edx,%eax
  801c90:	72 14                	jb     801ca6 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c92:	89 da                	mov    %ebx,%edx
  801c94:	89 f0                	mov    %esi,%eax
  801c96:	e8 61 ff ff ff       	call   801bfc <_pipeisclosed>
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	75 3b                	jne    801cda <devpipe_write+0x79>
			sys_yield();
  801c9f:	e8 ee ee ff ff       	call   800b92 <sys_yield>
  801ca4:	eb e0                	jmp    801c86 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ca9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cad:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cb0:	89 c2                	mov    %eax,%edx
  801cb2:	c1 fa 1f             	sar    $0x1f,%edx
  801cb5:	89 d1                	mov    %edx,%ecx
  801cb7:	c1 e9 1b             	shr    $0x1b,%ecx
  801cba:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cbd:	83 e2 1f             	and    $0x1f,%edx
  801cc0:	29 ca                	sub    %ecx,%edx
  801cc2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cc6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cca:	83 c0 01             	add    $0x1,%eax
  801ccd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cd0:	83 c7 01             	add    $0x1,%edi
  801cd3:	eb ac                	jmp    801c81 <devpipe_write+0x20>
	return i;
  801cd5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd8:	eb 05                	jmp    801cdf <devpipe_write+0x7e>
				return 0;
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ce2:	5b                   	pop    %ebx
  801ce3:	5e                   	pop    %esi
  801ce4:	5f                   	pop    %edi
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    

00801ce7 <devpipe_read>:
{
  801ce7:	f3 0f 1e fb          	endbr32 
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	57                   	push   %edi
  801cef:	56                   	push   %esi
  801cf0:	53                   	push   %ebx
  801cf1:	83 ec 18             	sub    $0x18,%esp
  801cf4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cf7:	57                   	push   %edi
  801cf8:	e8 8c f1 ff ff       	call   800e89 <fd2data>
  801cfd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	be 00 00 00 00       	mov    $0x0,%esi
  801d07:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d0a:	75 14                	jne    801d20 <devpipe_read+0x39>
	return i;
  801d0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0f:	eb 02                	jmp    801d13 <devpipe_read+0x2c>
				return i;
  801d11:	89 f0                	mov    %esi,%eax
}
  801d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5e                   	pop    %esi
  801d18:	5f                   	pop    %edi
  801d19:	5d                   	pop    %ebp
  801d1a:	c3                   	ret    
			sys_yield();
  801d1b:	e8 72 ee ff ff       	call   800b92 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d20:	8b 03                	mov    (%ebx),%eax
  801d22:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d25:	75 18                	jne    801d3f <devpipe_read+0x58>
			if (i > 0)
  801d27:	85 f6                	test   %esi,%esi
  801d29:	75 e6                	jne    801d11 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d2b:	89 da                	mov    %ebx,%edx
  801d2d:	89 f8                	mov    %edi,%eax
  801d2f:	e8 c8 fe ff ff       	call   801bfc <_pipeisclosed>
  801d34:	85 c0                	test   %eax,%eax
  801d36:	74 e3                	je     801d1b <devpipe_read+0x34>
				return 0;
  801d38:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3d:	eb d4                	jmp    801d13 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d3f:	99                   	cltd   
  801d40:	c1 ea 1b             	shr    $0x1b,%edx
  801d43:	01 d0                	add    %edx,%eax
  801d45:	83 e0 1f             	and    $0x1f,%eax
  801d48:	29 d0                	sub    %edx,%eax
  801d4a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d52:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d55:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d58:	83 c6 01             	add    $0x1,%esi
  801d5b:	eb aa                	jmp    801d07 <devpipe_read+0x20>

00801d5d <pipe>:
{
  801d5d:	f3 0f 1e fb          	endbr32 
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	56                   	push   %esi
  801d65:	53                   	push   %ebx
  801d66:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6c:	50                   	push   %eax
  801d6d:	e8 32 f1 ff ff       	call   800ea4 <fd_alloc>
  801d72:	89 c3                	mov    %eax,%ebx
  801d74:	83 c4 10             	add    $0x10,%esp
  801d77:	85 c0                	test   %eax,%eax
  801d79:	0f 88 23 01 00 00    	js     801ea2 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	68 07 04 00 00       	push   $0x407
  801d87:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8a:	6a 00                	push   $0x0
  801d8c:	e8 24 ee ff ff       	call   800bb5 <sys_page_alloc>
  801d91:	89 c3                	mov    %eax,%ebx
  801d93:	83 c4 10             	add    $0x10,%esp
  801d96:	85 c0                	test   %eax,%eax
  801d98:	0f 88 04 01 00 00    	js     801ea2 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d9e:	83 ec 0c             	sub    $0xc,%esp
  801da1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801da4:	50                   	push   %eax
  801da5:	e8 fa f0 ff ff       	call   800ea4 <fd_alloc>
  801daa:	89 c3                	mov    %eax,%ebx
  801dac:	83 c4 10             	add    $0x10,%esp
  801daf:	85 c0                	test   %eax,%eax
  801db1:	0f 88 db 00 00 00    	js     801e92 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801db7:	83 ec 04             	sub    $0x4,%esp
  801dba:	68 07 04 00 00       	push   $0x407
  801dbf:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc2:	6a 00                	push   $0x0
  801dc4:	e8 ec ed ff ff       	call   800bb5 <sys_page_alloc>
  801dc9:	89 c3                	mov    %eax,%ebx
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	0f 88 bc 00 00 00    	js     801e92 <pipe+0x135>
	va = fd2data(fd0);
  801dd6:	83 ec 0c             	sub    $0xc,%esp
  801dd9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ddc:	e8 a8 f0 ff ff       	call   800e89 <fd2data>
  801de1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801de3:	83 c4 0c             	add    $0xc,%esp
  801de6:	68 07 04 00 00       	push   $0x407
  801deb:	50                   	push   %eax
  801dec:	6a 00                	push   $0x0
  801dee:	e8 c2 ed ff ff       	call   800bb5 <sys_page_alloc>
  801df3:	89 c3                	mov    %eax,%ebx
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	0f 88 82 00 00 00    	js     801e82 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	ff 75 f0             	pushl  -0x10(%ebp)
  801e06:	e8 7e f0 ff ff       	call   800e89 <fd2data>
  801e0b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e12:	50                   	push   %eax
  801e13:	6a 00                	push   $0x0
  801e15:	56                   	push   %esi
  801e16:	6a 00                	push   $0x0
  801e18:	e8 df ed ff ff       	call   800bfc <sys_page_map>
  801e1d:	89 c3                	mov    %eax,%ebx
  801e1f:	83 c4 20             	add    $0x20,%esp
  801e22:	85 c0                	test   %eax,%eax
  801e24:	78 4e                	js     801e74 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e26:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801e2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e33:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e3d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e42:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e49:	83 ec 0c             	sub    $0xc,%esp
  801e4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4f:	e8 21 f0 ff ff       	call   800e75 <fd2num>
  801e54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e57:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e59:	83 c4 04             	add    $0x4,%esp
  801e5c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5f:	e8 11 f0 ff ff       	call   800e75 <fd2num>
  801e64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e67:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e6a:	83 c4 10             	add    $0x10,%esp
  801e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e72:	eb 2e                	jmp    801ea2 <pipe+0x145>
	sys_page_unmap(0, va);
  801e74:	83 ec 08             	sub    $0x8,%esp
  801e77:	56                   	push   %esi
  801e78:	6a 00                	push   $0x0
  801e7a:	e8 c3 ed ff ff       	call   800c42 <sys_page_unmap>
  801e7f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e82:	83 ec 08             	sub    $0x8,%esp
  801e85:	ff 75 f0             	pushl  -0x10(%ebp)
  801e88:	6a 00                	push   $0x0
  801e8a:	e8 b3 ed ff ff       	call   800c42 <sys_page_unmap>
  801e8f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e92:	83 ec 08             	sub    $0x8,%esp
  801e95:	ff 75 f4             	pushl  -0xc(%ebp)
  801e98:	6a 00                	push   $0x0
  801e9a:	e8 a3 ed ff ff       	call   800c42 <sys_page_unmap>
  801e9f:	83 c4 10             	add    $0x10,%esp
}
  801ea2:	89 d8                	mov    %ebx,%eax
  801ea4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5d                   	pop    %ebp
  801eaa:	c3                   	ret    

00801eab <pipeisclosed>:
{
  801eab:	f3 0f 1e fb          	endbr32 
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb8:	50                   	push   %eax
  801eb9:	ff 75 08             	pushl  0x8(%ebp)
  801ebc:	e8 39 f0 ff ff       	call   800efa <fd_lookup>
  801ec1:	83 c4 10             	add    $0x10,%esp
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	78 18                	js     801ee0 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ece:	e8 b6 ef ff ff       	call   800e89 <fd2data>
  801ed3:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed8:	e8 1f fd ff ff       	call   801bfc <_pipeisclosed>
  801edd:	83 c4 10             	add    $0x10,%esp
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ee2:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  801eeb:	c3                   	ret    

00801eec <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eec:	f3 0f 1e fb          	endbr32 
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ef6:	68 e7 28 80 00       	push   $0x8028e7
  801efb:	ff 75 0c             	pushl  0xc(%ebp)
  801efe:	e8 70 e8 ff ff       	call   800773 <strcpy>
	return 0;
}
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <devcons_write>:
{
  801f0a:	f3 0f 1e fb          	endbr32 
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	57                   	push   %edi
  801f12:	56                   	push   %esi
  801f13:	53                   	push   %ebx
  801f14:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f1a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f1f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f25:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f28:	73 31                	jae    801f5b <devcons_write+0x51>
		m = n - tot;
  801f2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f2d:	29 f3                	sub    %esi,%ebx
  801f2f:	83 fb 7f             	cmp    $0x7f,%ebx
  801f32:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f37:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f3a:	83 ec 04             	sub    $0x4,%esp
  801f3d:	53                   	push   %ebx
  801f3e:	89 f0                	mov    %esi,%eax
  801f40:	03 45 0c             	add    0xc(%ebp),%eax
  801f43:	50                   	push   %eax
  801f44:	57                   	push   %edi
  801f45:	e8 df e9 ff ff       	call   800929 <memmove>
		sys_cputs(buf, m);
  801f4a:	83 c4 08             	add    $0x8,%esp
  801f4d:	53                   	push   %ebx
  801f4e:	57                   	push   %edi
  801f4f:	e8 91 eb ff ff       	call   800ae5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f54:	01 de                	add    %ebx,%esi
  801f56:	83 c4 10             	add    $0x10,%esp
  801f59:	eb ca                	jmp    801f25 <devcons_write+0x1b>
}
  801f5b:	89 f0                	mov    %esi,%eax
  801f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f60:	5b                   	pop    %ebx
  801f61:	5e                   	pop    %esi
  801f62:	5f                   	pop    %edi
  801f63:	5d                   	pop    %ebp
  801f64:	c3                   	ret    

00801f65 <devcons_read>:
{
  801f65:	f3 0f 1e fb          	endbr32 
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	83 ec 08             	sub    $0x8,%esp
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f78:	74 21                	je     801f9b <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f7a:	e8 88 eb ff ff       	call   800b07 <sys_cgetc>
  801f7f:	85 c0                	test   %eax,%eax
  801f81:	75 07                	jne    801f8a <devcons_read+0x25>
		sys_yield();
  801f83:	e8 0a ec ff ff       	call   800b92 <sys_yield>
  801f88:	eb f0                	jmp    801f7a <devcons_read+0x15>
	if (c < 0)
  801f8a:	78 0f                	js     801f9b <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f8c:	83 f8 04             	cmp    $0x4,%eax
  801f8f:	74 0c                	je     801f9d <devcons_read+0x38>
	*(char*)vbuf = c;
  801f91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f94:	88 02                	mov    %al,(%edx)
	return 1;
  801f96:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    
		return 0;
  801f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa2:	eb f7                	jmp    801f9b <devcons_read+0x36>

00801fa4 <cputchar>:
{
  801fa4:	f3 0f 1e fb          	endbr32 
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fb4:	6a 01                	push   $0x1
  801fb6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fb9:	50                   	push   %eax
  801fba:	e8 26 eb ff ff       	call   800ae5 <sys_cputs>
}
  801fbf:	83 c4 10             	add    $0x10,%esp
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <getchar>:
{
  801fc4:	f3 0f 1e fb          	endbr32 
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fce:	6a 01                	push   $0x1
  801fd0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fd3:	50                   	push   %eax
  801fd4:	6a 00                	push   $0x0
  801fd6:	e8 a7 f1 ff ff       	call   801182 <read>
	if (r < 0)
  801fdb:	83 c4 10             	add    $0x10,%esp
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	78 06                	js     801fe8 <getchar+0x24>
	if (r < 1)
  801fe2:	74 06                	je     801fea <getchar+0x26>
	return c;
  801fe4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    
		return -E_EOF;
  801fea:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fef:	eb f7                	jmp    801fe8 <getchar+0x24>

00801ff1 <iscons>:
{
  801ff1:	f3 0f 1e fb          	endbr32 
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ffb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ffe:	50                   	push   %eax
  801fff:	ff 75 08             	pushl  0x8(%ebp)
  802002:	e8 f3 ee ff ff       	call   800efa <fd_lookup>
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	85 c0                	test   %eax,%eax
  80200c:	78 11                	js     80201f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802017:	39 10                	cmp    %edx,(%eax)
  802019:	0f 94 c0             	sete   %al
  80201c:	0f b6 c0             	movzbl %al,%eax
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <opencons>:
{
  802021:	f3 0f 1e fb          	endbr32 
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80202b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80202e:	50                   	push   %eax
  80202f:	e8 70 ee ff ff       	call   800ea4 <fd_alloc>
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	85 c0                	test   %eax,%eax
  802039:	78 3a                	js     802075 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80203b:	83 ec 04             	sub    $0x4,%esp
  80203e:	68 07 04 00 00       	push   $0x407
  802043:	ff 75 f4             	pushl  -0xc(%ebp)
  802046:	6a 00                	push   $0x0
  802048:	e8 68 eb ff ff       	call   800bb5 <sys_page_alloc>
  80204d:	83 c4 10             	add    $0x10,%esp
  802050:	85 c0                	test   %eax,%eax
  802052:	78 21                	js     802075 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802057:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80205d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802062:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802069:	83 ec 0c             	sub    $0xc,%esp
  80206c:	50                   	push   %eax
  80206d:	e8 03 ee ff ff       	call   800e75 <fd2num>
  802072:	83 c4 10             	add    $0x10,%esp
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802077:	f3 0f 1e fb          	endbr32 
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	56                   	push   %esi
  80207f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802080:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802083:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802089:	e8 e1 ea ff ff       	call   800b6f <sys_getenvid>
  80208e:	83 ec 0c             	sub    $0xc,%esp
  802091:	ff 75 0c             	pushl  0xc(%ebp)
  802094:	ff 75 08             	pushl  0x8(%ebp)
  802097:	56                   	push   %esi
  802098:	50                   	push   %eax
  802099:	68 f4 28 80 00       	push   $0x8028f4
  80209e:	e8 c6 e0 ff ff       	call   800169 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8020a3:	83 c4 18             	add    $0x18,%esp
  8020a6:	53                   	push   %ebx
  8020a7:	ff 75 10             	pushl  0x10(%ebp)
  8020aa:	e8 65 e0 ff ff       	call   800114 <vcprintf>
	cprintf("\n");
  8020af:	c7 04 24 8c 24 80 00 	movl   $0x80248c,(%esp)
  8020b6:	e8 ae e0 ff ff       	call   800169 <cprintf>
  8020bb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020be:	cc                   	int3   
  8020bf:	eb fd                	jmp    8020be <_panic+0x47>

008020c1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020c1:	f3 0f 1e fb          	endbr32 
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	56                   	push   %esi
  8020c9:	53                   	push   %ebx
  8020ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8020cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	74 3d                	je     802114 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020d7:	83 ec 0c             	sub    $0xc,%esp
  8020da:	50                   	push   %eax
  8020db:	e8 a1 ec ff ff       	call   800d81 <sys_ipc_recv>
  8020e0:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020e3:	85 f6                	test   %esi,%esi
  8020e5:	74 0b                	je     8020f2 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020e7:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8020ed:	8b 52 74             	mov    0x74(%edx),%edx
  8020f0:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020f2:	85 db                	test   %ebx,%ebx
  8020f4:	74 0b                	je     802101 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020f6:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8020fc:	8b 52 78             	mov    0x78(%edx),%edx
  8020ff:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802101:	85 c0                	test   %eax,%eax
  802103:	78 21                	js     802126 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802105:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80210a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80210d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802110:	5b                   	pop    %ebx
  802111:	5e                   	pop    %esi
  802112:	5d                   	pop    %ebp
  802113:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802114:	83 ec 0c             	sub    $0xc,%esp
  802117:	68 00 00 c0 ee       	push   $0xeec00000
  80211c:	e8 60 ec ff ff       	call   800d81 <sys_ipc_recv>
  802121:	83 c4 10             	add    $0x10,%esp
  802124:	eb bd                	jmp    8020e3 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802126:	85 f6                	test   %esi,%esi
  802128:	74 10                	je     80213a <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80212a:	85 db                	test   %ebx,%ebx
  80212c:	75 df                	jne    80210d <ipc_recv+0x4c>
  80212e:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802135:	00 00 00 
  802138:	eb d3                	jmp    80210d <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80213a:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802141:	00 00 00 
  802144:	eb e4                	jmp    80212a <ipc_recv+0x69>

00802146 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802146:	f3 0f 1e fb          	endbr32 
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	57                   	push   %edi
  80214e:	56                   	push   %esi
  80214f:	53                   	push   %ebx
  802150:	83 ec 0c             	sub    $0xc,%esp
  802153:	8b 7d 08             	mov    0x8(%ebp),%edi
  802156:	8b 75 0c             	mov    0xc(%ebp),%esi
  802159:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80215c:	85 db                	test   %ebx,%ebx
  80215e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802163:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802166:	ff 75 14             	pushl  0x14(%ebp)
  802169:	53                   	push   %ebx
  80216a:	56                   	push   %esi
  80216b:	57                   	push   %edi
  80216c:	e8 e9 eb ff ff       	call   800d5a <sys_ipc_try_send>
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	85 c0                	test   %eax,%eax
  802176:	79 1e                	jns    802196 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802178:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80217b:	75 07                	jne    802184 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80217d:	e8 10 ea ff ff       	call   800b92 <sys_yield>
  802182:	eb e2                	jmp    802166 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802184:	50                   	push   %eax
  802185:	68 17 29 80 00       	push   $0x802917
  80218a:	6a 59                	push   $0x59
  80218c:	68 32 29 80 00       	push   $0x802932
  802191:	e8 e1 fe ff ff       	call   802077 <_panic>
	}
}
  802196:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802199:	5b                   	pop    %ebx
  80219a:	5e                   	pop    %esi
  80219b:	5f                   	pop    %edi
  80219c:	5d                   	pop    %ebp
  80219d:	c3                   	ret    

0080219e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80219e:	f3 0f 1e fb          	endbr32 
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021a8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021ad:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021b0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021b6:	8b 52 50             	mov    0x50(%edx),%edx
  8021b9:	39 ca                	cmp    %ecx,%edx
  8021bb:	74 11                	je     8021ce <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021bd:	83 c0 01             	add    $0x1,%eax
  8021c0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021c5:	75 e6                	jne    8021ad <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cc:	eb 0b                	jmp    8021d9 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021ce:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021d6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021d9:	5d                   	pop    %ebp
  8021da:	c3                   	ret    

008021db <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021db:	f3 0f 1e fb          	endbr32 
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021e5:	89 c2                	mov    %eax,%edx
  8021e7:	c1 ea 16             	shr    $0x16,%edx
  8021ea:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021f1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021f6:	f6 c1 01             	test   $0x1,%cl
  8021f9:	74 1c                	je     802217 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021fb:	c1 e8 0c             	shr    $0xc,%eax
  8021fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802205:	a8 01                	test   $0x1,%al
  802207:	74 0e                	je     802217 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802209:	c1 e8 0c             	shr    $0xc,%eax
  80220c:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802213:	ef 
  802214:	0f b7 d2             	movzwl %dx,%edx
}
  802217:	89 d0                	mov    %edx,%eax
  802219:	5d                   	pop    %ebp
  80221a:	c3                   	ret    
  80221b:	66 90                	xchg   %ax,%ax
  80221d:	66 90                	xchg   %ax,%ax
  80221f:	90                   	nop

00802220 <__udivdi3>:
  802220:	f3 0f 1e fb          	endbr32 
  802224:	55                   	push   %ebp
  802225:	57                   	push   %edi
  802226:	56                   	push   %esi
  802227:	53                   	push   %ebx
  802228:	83 ec 1c             	sub    $0x1c,%esp
  80222b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80222f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802233:	8b 74 24 34          	mov    0x34(%esp),%esi
  802237:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80223b:	85 d2                	test   %edx,%edx
  80223d:	75 19                	jne    802258 <__udivdi3+0x38>
  80223f:	39 f3                	cmp    %esi,%ebx
  802241:	76 4d                	jbe    802290 <__udivdi3+0x70>
  802243:	31 ff                	xor    %edi,%edi
  802245:	89 e8                	mov    %ebp,%eax
  802247:	89 f2                	mov    %esi,%edx
  802249:	f7 f3                	div    %ebx
  80224b:	89 fa                	mov    %edi,%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	76 14                	jbe    802270 <__udivdi3+0x50>
  80225c:	31 ff                	xor    %edi,%edi
  80225e:	31 c0                	xor    %eax,%eax
  802260:	89 fa                	mov    %edi,%edx
  802262:	83 c4 1c             	add    $0x1c,%esp
  802265:	5b                   	pop    %ebx
  802266:	5e                   	pop    %esi
  802267:	5f                   	pop    %edi
  802268:	5d                   	pop    %ebp
  802269:	c3                   	ret    
  80226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802270:	0f bd fa             	bsr    %edx,%edi
  802273:	83 f7 1f             	xor    $0x1f,%edi
  802276:	75 48                	jne    8022c0 <__udivdi3+0xa0>
  802278:	39 f2                	cmp    %esi,%edx
  80227a:	72 06                	jb     802282 <__udivdi3+0x62>
  80227c:	31 c0                	xor    %eax,%eax
  80227e:	39 eb                	cmp    %ebp,%ebx
  802280:	77 de                	ja     802260 <__udivdi3+0x40>
  802282:	b8 01 00 00 00       	mov    $0x1,%eax
  802287:	eb d7                	jmp    802260 <__udivdi3+0x40>
  802289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802290:	89 d9                	mov    %ebx,%ecx
  802292:	85 db                	test   %ebx,%ebx
  802294:	75 0b                	jne    8022a1 <__udivdi3+0x81>
  802296:	b8 01 00 00 00       	mov    $0x1,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	f7 f3                	div    %ebx
  80229f:	89 c1                	mov    %eax,%ecx
  8022a1:	31 d2                	xor    %edx,%edx
  8022a3:	89 f0                	mov    %esi,%eax
  8022a5:	f7 f1                	div    %ecx
  8022a7:	89 c6                	mov    %eax,%esi
  8022a9:	89 e8                	mov    %ebp,%eax
  8022ab:	89 f7                	mov    %esi,%edi
  8022ad:	f7 f1                	div    %ecx
  8022af:	89 fa                	mov    %edi,%edx
  8022b1:	83 c4 1c             	add    $0x1c,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    
  8022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c0:	89 f9                	mov    %edi,%ecx
  8022c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022c7:	29 f8                	sub    %edi,%eax
  8022c9:	d3 e2                	shl    %cl,%edx
  8022cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	89 da                	mov    %ebx,%edx
  8022d3:	d3 ea                	shr    %cl,%edx
  8022d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022d9:	09 d1                	or     %edx,%ecx
  8022db:	89 f2                	mov    %esi,%edx
  8022dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e1:	89 f9                	mov    %edi,%ecx
  8022e3:	d3 e3                	shl    %cl,%ebx
  8022e5:	89 c1                	mov    %eax,%ecx
  8022e7:	d3 ea                	shr    %cl,%edx
  8022e9:	89 f9                	mov    %edi,%ecx
  8022eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022ef:	89 eb                	mov    %ebp,%ebx
  8022f1:	d3 e6                	shl    %cl,%esi
  8022f3:	89 c1                	mov    %eax,%ecx
  8022f5:	d3 eb                	shr    %cl,%ebx
  8022f7:	09 de                	or     %ebx,%esi
  8022f9:	89 f0                	mov    %esi,%eax
  8022fb:	f7 74 24 08          	divl   0x8(%esp)
  8022ff:	89 d6                	mov    %edx,%esi
  802301:	89 c3                	mov    %eax,%ebx
  802303:	f7 64 24 0c          	mull   0xc(%esp)
  802307:	39 d6                	cmp    %edx,%esi
  802309:	72 15                	jb     802320 <__udivdi3+0x100>
  80230b:	89 f9                	mov    %edi,%ecx
  80230d:	d3 e5                	shl    %cl,%ebp
  80230f:	39 c5                	cmp    %eax,%ebp
  802311:	73 04                	jae    802317 <__udivdi3+0xf7>
  802313:	39 d6                	cmp    %edx,%esi
  802315:	74 09                	je     802320 <__udivdi3+0x100>
  802317:	89 d8                	mov    %ebx,%eax
  802319:	31 ff                	xor    %edi,%edi
  80231b:	e9 40 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  802320:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802323:	31 ff                	xor    %edi,%edi
  802325:	e9 36 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__umoddi3>:
  802330:	f3 0f 1e fb          	endbr32 
  802334:	55                   	push   %ebp
  802335:	57                   	push   %edi
  802336:	56                   	push   %esi
  802337:	53                   	push   %ebx
  802338:	83 ec 1c             	sub    $0x1c,%esp
  80233b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80233f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802343:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802347:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80234b:	85 c0                	test   %eax,%eax
  80234d:	75 19                	jne    802368 <__umoddi3+0x38>
  80234f:	39 df                	cmp    %ebx,%edi
  802351:	76 5d                	jbe    8023b0 <__umoddi3+0x80>
  802353:	89 f0                	mov    %esi,%eax
  802355:	89 da                	mov    %ebx,%edx
  802357:	f7 f7                	div    %edi
  802359:	89 d0                	mov    %edx,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	83 c4 1c             	add    $0x1c,%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    
  802365:	8d 76 00             	lea    0x0(%esi),%esi
  802368:	89 f2                	mov    %esi,%edx
  80236a:	39 d8                	cmp    %ebx,%eax
  80236c:	76 12                	jbe    802380 <__umoddi3+0x50>
  80236e:	89 f0                	mov    %esi,%eax
  802370:	89 da                	mov    %ebx,%edx
  802372:	83 c4 1c             	add    $0x1c,%esp
  802375:	5b                   	pop    %ebx
  802376:	5e                   	pop    %esi
  802377:	5f                   	pop    %edi
  802378:	5d                   	pop    %ebp
  802379:	c3                   	ret    
  80237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802380:	0f bd e8             	bsr    %eax,%ebp
  802383:	83 f5 1f             	xor    $0x1f,%ebp
  802386:	75 50                	jne    8023d8 <__umoddi3+0xa8>
  802388:	39 d8                	cmp    %ebx,%eax
  80238a:	0f 82 e0 00 00 00    	jb     802470 <__umoddi3+0x140>
  802390:	89 d9                	mov    %ebx,%ecx
  802392:	39 f7                	cmp    %esi,%edi
  802394:	0f 86 d6 00 00 00    	jbe    802470 <__umoddi3+0x140>
  80239a:	89 d0                	mov    %edx,%eax
  80239c:	89 ca                	mov    %ecx,%edx
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	89 fd                	mov    %edi,%ebp
  8023b2:	85 ff                	test   %edi,%edi
  8023b4:	75 0b                	jne    8023c1 <__umoddi3+0x91>
  8023b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bb:	31 d2                	xor    %edx,%edx
  8023bd:	f7 f7                	div    %edi
  8023bf:	89 c5                	mov    %eax,%ebp
  8023c1:	89 d8                	mov    %ebx,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f5                	div    %ebp
  8023c7:	89 f0                	mov    %esi,%eax
  8023c9:	f7 f5                	div    %ebp
  8023cb:	89 d0                	mov    %edx,%eax
  8023cd:	31 d2                	xor    %edx,%edx
  8023cf:	eb 8c                	jmp    80235d <__umoddi3+0x2d>
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	89 e9                	mov    %ebp,%ecx
  8023da:	ba 20 00 00 00       	mov    $0x20,%edx
  8023df:	29 ea                	sub    %ebp,%edx
  8023e1:	d3 e0                	shl    %cl,%eax
  8023e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023e7:	89 d1                	mov    %edx,%ecx
  8023e9:	89 f8                	mov    %edi,%eax
  8023eb:	d3 e8                	shr    %cl,%eax
  8023ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023f9:	09 c1                	or     %eax,%ecx
  8023fb:	89 d8                	mov    %ebx,%eax
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 e9                	mov    %ebp,%ecx
  802403:	d3 e7                	shl    %cl,%edi
  802405:	89 d1                	mov    %edx,%ecx
  802407:	d3 e8                	shr    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80240f:	d3 e3                	shl    %cl,%ebx
  802411:	89 c7                	mov    %eax,%edi
  802413:	89 d1                	mov    %edx,%ecx
  802415:	89 f0                	mov    %esi,%eax
  802417:	d3 e8                	shr    %cl,%eax
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	89 fa                	mov    %edi,%edx
  80241d:	d3 e6                	shl    %cl,%esi
  80241f:	09 d8                	or     %ebx,%eax
  802421:	f7 74 24 08          	divl   0x8(%esp)
  802425:	89 d1                	mov    %edx,%ecx
  802427:	89 f3                	mov    %esi,%ebx
  802429:	f7 64 24 0c          	mull   0xc(%esp)
  80242d:	89 c6                	mov    %eax,%esi
  80242f:	89 d7                	mov    %edx,%edi
  802431:	39 d1                	cmp    %edx,%ecx
  802433:	72 06                	jb     80243b <__umoddi3+0x10b>
  802435:	75 10                	jne    802447 <__umoddi3+0x117>
  802437:	39 c3                	cmp    %eax,%ebx
  802439:	73 0c                	jae    802447 <__umoddi3+0x117>
  80243b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80243f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802443:	89 d7                	mov    %edx,%edi
  802445:	89 c6                	mov    %eax,%esi
  802447:	89 ca                	mov    %ecx,%edx
  802449:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80244e:	29 f3                	sub    %esi,%ebx
  802450:	19 fa                	sbb    %edi,%edx
  802452:	89 d0                	mov    %edx,%eax
  802454:	d3 e0                	shl    %cl,%eax
  802456:	89 e9                	mov    %ebp,%ecx
  802458:	d3 eb                	shr    %cl,%ebx
  80245a:	d3 ea                	shr    %cl,%edx
  80245c:	09 d8                	or     %ebx,%eax
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	29 fe                	sub    %edi,%esi
  802472:	19 c3                	sbb    %eax,%ebx
  802474:	89 f2                	mov    %esi,%edx
  802476:	89 d9                	mov    %ebx,%ecx
  802478:	e9 1d ff ff ff       	jmp    80239a <__umoddi3+0x6a>
