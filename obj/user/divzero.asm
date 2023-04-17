
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
  80003d:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  800044:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800047:	b8 01 00 00 00       	mov    $0x1,%eax
  80004c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800051:	99                   	cltd   
  800052:	f7 f9                	idiv   %ecx
  800054:	50                   	push   %eax
  800055:	68 20 1f 80 00       	push   $0x801f20
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
  800085:	a3 08 40 80 00       	mov    %eax,0x804008

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
  8000b8:	e8 f8 0e 00 00       	call   800fb5 <close_all>
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
  8001cf:	e8 dc 1a 00 00       	call   801cb0 <__udivdi3>
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
  80020d:	e8 ae 1b 00 00       	call   801dc0 <__umoddi3>
  800212:	83 c4 14             	add    $0x14,%esp
  800215:	0f be 80 38 1f 80 00 	movsbl 0x801f38(%eax),%eax
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
  8002bc:	3e ff 24 85 80 20 80 	notrack jmp *0x802080(,%eax,4)
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
  800389:	8b 14 85 e0 21 80 00 	mov    0x8021e0(,%eax,4),%edx
  800390:	85 d2                	test   %edx,%edx
  800392:	74 18                	je     8003ac <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800394:	52                   	push   %edx
  800395:	68 11 23 80 00       	push   $0x802311
  80039a:	53                   	push   %ebx
  80039b:	56                   	push   %esi
  80039c:	e8 aa fe ff ff       	call   80024b <printfmt>
  8003a1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a7:	e9 66 02 00 00       	jmp    800612 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003ac:	50                   	push   %eax
  8003ad:	68 50 1f 80 00       	push   $0x801f50
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
  8003d4:	b8 49 1f 80 00       	mov    $0x801f49,%eax
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
  800b5e:	68 3f 22 80 00       	push   $0x80223f
  800b63:	6a 23                	push   $0x23
  800b65:	68 5c 22 80 00       	push   $0x80225c
  800b6a:	e8 9c 0f 00 00       	call   801b0b <_panic>

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
  800beb:	68 3f 22 80 00       	push   $0x80223f
  800bf0:	6a 23                	push   $0x23
  800bf2:	68 5c 22 80 00       	push   $0x80225c
  800bf7:	e8 0f 0f 00 00       	call   801b0b <_panic>

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
  800c31:	68 3f 22 80 00       	push   $0x80223f
  800c36:	6a 23                	push   $0x23
  800c38:	68 5c 22 80 00       	push   $0x80225c
  800c3d:	e8 c9 0e 00 00       	call   801b0b <_panic>

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
  800c77:	68 3f 22 80 00       	push   $0x80223f
  800c7c:	6a 23                	push   $0x23
  800c7e:	68 5c 22 80 00       	push   $0x80225c
  800c83:	e8 83 0e 00 00       	call   801b0b <_panic>

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
  800cbd:	68 3f 22 80 00       	push   $0x80223f
  800cc2:	6a 23                	push   $0x23
  800cc4:	68 5c 22 80 00       	push   $0x80225c
  800cc9:	e8 3d 0e 00 00       	call   801b0b <_panic>

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
  800d03:	68 3f 22 80 00       	push   $0x80223f
  800d08:	6a 23                	push   $0x23
  800d0a:	68 5c 22 80 00       	push   $0x80225c
  800d0f:	e8 f7 0d 00 00       	call   801b0b <_panic>

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
  800d49:	68 3f 22 80 00       	push   $0x80223f
  800d4e:	6a 23                	push   $0x23
  800d50:	68 5c 22 80 00       	push   $0x80225c
  800d55:	e8 b1 0d 00 00       	call   801b0b <_panic>

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
  800db5:	68 3f 22 80 00       	push   $0x80223f
  800dba:	6a 23                	push   $0x23
  800dbc:	68 5c 22 80 00       	push   $0x80225c
  800dc1:	e8 45 0d 00 00       	call   801b0b <_panic>

00800dc6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800dc6:	f3 0f 1e fb          	endbr32 
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	05 00 00 00 30       	add    $0x30000000,%eax
  800dd5:	c1 e8 0c             	shr    $0xc,%eax
}
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800dda:	f3 0f 1e fb          	endbr32 
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800de9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dee:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800df5:	f3 0f 1e fb          	endbr32 
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e01:	89 c2                	mov    %eax,%edx
  800e03:	c1 ea 16             	shr    $0x16,%edx
  800e06:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e0d:	f6 c2 01             	test   $0x1,%dl
  800e10:	74 2d                	je     800e3f <fd_alloc+0x4a>
  800e12:	89 c2                	mov    %eax,%edx
  800e14:	c1 ea 0c             	shr    $0xc,%edx
  800e17:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e1e:	f6 c2 01             	test   $0x1,%dl
  800e21:	74 1c                	je     800e3f <fd_alloc+0x4a>
  800e23:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e28:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e2d:	75 d2                	jne    800e01 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e38:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e3d:	eb 0a                	jmp    800e49 <fd_alloc+0x54>
			*fd_store = fd;
  800e3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e42:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e4b:	f3 0f 1e fb          	endbr32 
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e55:	83 f8 1f             	cmp    $0x1f,%eax
  800e58:	77 30                	ja     800e8a <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e5a:	c1 e0 0c             	shl    $0xc,%eax
  800e5d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e62:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e68:	f6 c2 01             	test   $0x1,%dl
  800e6b:	74 24                	je     800e91 <fd_lookup+0x46>
  800e6d:	89 c2                	mov    %eax,%edx
  800e6f:	c1 ea 0c             	shr    $0xc,%edx
  800e72:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e79:	f6 c2 01             	test   $0x1,%dl
  800e7c:	74 1a                	je     800e98 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e81:	89 02                	mov    %eax,(%edx)
	return 0;
  800e83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    
		return -E_INVAL;
  800e8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e8f:	eb f7                	jmp    800e88 <fd_lookup+0x3d>
		return -E_INVAL;
  800e91:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e96:	eb f0                	jmp    800e88 <fd_lookup+0x3d>
  800e98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e9d:	eb e9                	jmp    800e88 <fd_lookup+0x3d>

00800e9f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e9f:	f3 0f 1e fb          	endbr32 
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 08             	sub    $0x8,%esp
  800ea9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eac:	ba e8 22 80 00       	mov    $0x8022e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800eb1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800eb6:	39 08                	cmp    %ecx,(%eax)
  800eb8:	74 33                	je     800eed <dev_lookup+0x4e>
  800eba:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ebd:	8b 02                	mov    (%edx),%eax
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	75 f3                	jne    800eb6 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ec3:	a1 08 40 80 00       	mov    0x804008,%eax
  800ec8:	8b 40 48             	mov    0x48(%eax),%eax
  800ecb:	83 ec 04             	sub    $0x4,%esp
  800ece:	51                   	push   %ecx
  800ecf:	50                   	push   %eax
  800ed0:	68 6c 22 80 00       	push   $0x80226c
  800ed5:	e8 8f f2 ff ff       	call   800169 <cprintf>
	*dev = 0;
  800eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ee3:	83 c4 10             	add    $0x10,%esp
  800ee6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    
			*dev = devtab[i];
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef7:	eb f2                	jmp    800eeb <dev_lookup+0x4c>

00800ef9 <fd_close>:
{
  800ef9:	f3 0f 1e fb          	endbr32 
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
  800f03:	83 ec 24             	sub    $0x24,%esp
  800f06:	8b 75 08             	mov    0x8(%ebp),%esi
  800f09:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f0c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f0f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f10:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f16:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f19:	50                   	push   %eax
  800f1a:	e8 2c ff ff ff       	call   800e4b <fd_lookup>
  800f1f:	89 c3                	mov    %eax,%ebx
  800f21:	83 c4 10             	add    $0x10,%esp
  800f24:	85 c0                	test   %eax,%eax
  800f26:	78 05                	js     800f2d <fd_close+0x34>
	    || fd != fd2)
  800f28:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f2b:	74 16                	je     800f43 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f2d:	89 f8                	mov    %edi,%eax
  800f2f:	84 c0                	test   %al,%al
  800f31:	b8 00 00 00 00       	mov    $0x0,%eax
  800f36:	0f 44 d8             	cmove  %eax,%ebx
}
  800f39:	89 d8                	mov    %ebx,%eax
  800f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3e:	5b                   	pop    %ebx
  800f3f:	5e                   	pop    %esi
  800f40:	5f                   	pop    %edi
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f43:	83 ec 08             	sub    $0x8,%esp
  800f46:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f49:	50                   	push   %eax
  800f4a:	ff 36                	pushl  (%esi)
  800f4c:	e8 4e ff ff ff       	call   800e9f <dev_lookup>
  800f51:	89 c3                	mov    %eax,%ebx
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	85 c0                	test   %eax,%eax
  800f58:	78 1a                	js     800f74 <fd_close+0x7b>
		if (dev->dev_close)
  800f5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f5d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f60:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f65:	85 c0                	test   %eax,%eax
  800f67:	74 0b                	je     800f74 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f69:	83 ec 0c             	sub    $0xc,%esp
  800f6c:	56                   	push   %esi
  800f6d:	ff d0                	call   *%eax
  800f6f:	89 c3                	mov    %eax,%ebx
  800f71:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	56                   	push   %esi
  800f78:	6a 00                	push   $0x0
  800f7a:	e8 c3 fc ff ff       	call   800c42 <sys_page_unmap>
	return r;
  800f7f:	83 c4 10             	add    $0x10,%esp
  800f82:	eb b5                	jmp    800f39 <fd_close+0x40>

00800f84 <close>:

int
close(int fdnum)
{
  800f84:	f3 0f 1e fb          	endbr32 
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f91:	50                   	push   %eax
  800f92:	ff 75 08             	pushl  0x8(%ebp)
  800f95:	e8 b1 fe ff ff       	call   800e4b <fd_lookup>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	79 02                	jns    800fa3 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    
		return fd_close(fd, 1);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	6a 01                	push   $0x1
  800fa8:	ff 75 f4             	pushl  -0xc(%ebp)
  800fab:	e8 49 ff ff ff       	call   800ef9 <fd_close>
  800fb0:	83 c4 10             	add    $0x10,%esp
  800fb3:	eb ec                	jmp    800fa1 <close+0x1d>

00800fb5 <close_all>:

void
close_all(void)
{
  800fb5:	f3 0f 1e fb          	endbr32 
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	53                   	push   %ebx
  800fbd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fc0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fc5:	83 ec 0c             	sub    $0xc,%esp
  800fc8:	53                   	push   %ebx
  800fc9:	e8 b6 ff ff ff       	call   800f84 <close>
	for (i = 0; i < MAXFD; i++)
  800fce:	83 c3 01             	add    $0x1,%ebx
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	83 fb 20             	cmp    $0x20,%ebx
  800fd7:	75 ec                	jne    800fc5 <close_all+0x10>
}
  800fd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fdc:	c9                   	leave  
  800fdd:	c3                   	ret    

00800fde <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fde:	f3 0f 1e fb          	endbr32 
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	57                   	push   %edi
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
  800fe8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800feb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fee:	50                   	push   %eax
  800fef:	ff 75 08             	pushl  0x8(%ebp)
  800ff2:	e8 54 fe ff ff       	call   800e4b <fd_lookup>
  800ff7:	89 c3                	mov    %eax,%ebx
  800ff9:	83 c4 10             	add    $0x10,%esp
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	0f 88 81 00 00 00    	js     801085 <dup+0xa7>
		return r;
	close(newfdnum);
  801004:	83 ec 0c             	sub    $0xc,%esp
  801007:	ff 75 0c             	pushl  0xc(%ebp)
  80100a:	e8 75 ff ff ff       	call   800f84 <close>

	newfd = INDEX2FD(newfdnum);
  80100f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801012:	c1 e6 0c             	shl    $0xc,%esi
  801015:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80101b:	83 c4 04             	add    $0x4,%esp
  80101e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801021:	e8 b4 fd ff ff       	call   800dda <fd2data>
  801026:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801028:	89 34 24             	mov    %esi,(%esp)
  80102b:	e8 aa fd ff ff       	call   800dda <fd2data>
  801030:	83 c4 10             	add    $0x10,%esp
  801033:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801035:	89 d8                	mov    %ebx,%eax
  801037:	c1 e8 16             	shr    $0x16,%eax
  80103a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801041:	a8 01                	test   $0x1,%al
  801043:	74 11                	je     801056 <dup+0x78>
  801045:	89 d8                	mov    %ebx,%eax
  801047:	c1 e8 0c             	shr    $0xc,%eax
  80104a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801051:	f6 c2 01             	test   $0x1,%dl
  801054:	75 39                	jne    80108f <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801056:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801059:	89 d0                	mov    %edx,%eax
  80105b:	c1 e8 0c             	shr    $0xc,%eax
  80105e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801065:	83 ec 0c             	sub    $0xc,%esp
  801068:	25 07 0e 00 00       	and    $0xe07,%eax
  80106d:	50                   	push   %eax
  80106e:	56                   	push   %esi
  80106f:	6a 00                	push   $0x0
  801071:	52                   	push   %edx
  801072:	6a 00                	push   $0x0
  801074:	e8 83 fb ff ff       	call   800bfc <sys_page_map>
  801079:	89 c3                	mov    %eax,%ebx
  80107b:	83 c4 20             	add    $0x20,%esp
  80107e:	85 c0                	test   %eax,%eax
  801080:	78 31                	js     8010b3 <dup+0xd5>
		goto err;

	return newfdnum;
  801082:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801085:	89 d8                	mov    %ebx,%eax
  801087:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108a:	5b                   	pop    %ebx
  80108b:	5e                   	pop    %esi
  80108c:	5f                   	pop    %edi
  80108d:	5d                   	pop    %ebp
  80108e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80108f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	25 07 0e 00 00       	and    $0xe07,%eax
  80109e:	50                   	push   %eax
  80109f:	57                   	push   %edi
  8010a0:	6a 00                	push   $0x0
  8010a2:	53                   	push   %ebx
  8010a3:	6a 00                	push   $0x0
  8010a5:	e8 52 fb ff ff       	call   800bfc <sys_page_map>
  8010aa:	89 c3                	mov    %eax,%ebx
  8010ac:	83 c4 20             	add    $0x20,%esp
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	79 a3                	jns    801056 <dup+0x78>
	sys_page_unmap(0, newfd);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	56                   	push   %esi
  8010b7:	6a 00                	push   $0x0
  8010b9:	e8 84 fb ff ff       	call   800c42 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010be:	83 c4 08             	add    $0x8,%esp
  8010c1:	57                   	push   %edi
  8010c2:	6a 00                	push   $0x0
  8010c4:	e8 79 fb ff ff       	call   800c42 <sys_page_unmap>
	return r;
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	eb b7                	jmp    801085 <dup+0xa7>

008010ce <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010ce:	f3 0f 1e fb          	endbr32 
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 1c             	sub    $0x1c,%esp
  8010d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010df:	50                   	push   %eax
  8010e0:	53                   	push   %ebx
  8010e1:	e8 65 fd ff ff       	call   800e4b <fd_lookup>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	78 3f                	js     80112c <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010f3:	50                   	push   %eax
  8010f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f7:	ff 30                	pushl  (%eax)
  8010f9:	e8 a1 fd ff ff       	call   800e9f <dev_lookup>
  8010fe:	83 c4 10             	add    $0x10,%esp
  801101:	85 c0                	test   %eax,%eax
  801103:	78 27                	js     80112c <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801105:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801108:	8b 42 08             	mov    0x8(%edx),%eax
  80110b:	83 e0 03             	and    $0x3,%eax
  80110e:	83 f8 01             	cmp    $0x1,%eax
  801111:	74 1e                	je     801131 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801116:	8b 40 08             	mov    0x8(%eax),%eax
  801119:	85 c0                	test   %eax,%eax
  80111b:	74 35                	je     801152 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80111d:	83 ec 04             	sub    $0x4,%esp
  801120:	ff 75 10             	pushl  0x10(%ebp)
  801123:	ff 75 0c             	pushl  0xc(%ebp)
  801126:	52                   	push   %edx
  801127:	ff d0                	call   *%eax
  801129:	83 c4 10             	add    $0x10,%esp
}
  80112c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112f:	c9                   	leave  
  801130:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801131:	a1 08 40 80 00       	mov    0x804008,%eax
  801136:	8b 40 48             	mov    0x48(%eax),%eax
  801139:	83 ec 04             	sub    $0x4,%esp
  80113c:	53                   	push   %ebx
  80113d:	50                   	push   %eax
  80113e:	68 ad 22 80 00       	push   $0x8022ad
  801143:	e8 21 f0 ff ff       	call   800169 <cprintf>
		return -E_INVAL;
  801148:	83 c4 10             	add    $0x10,%esp
  80114b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801150:	eb da                	jmp    80112c <read+0x5e>
		return -E_NOT_SUPP;
  801152:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801157:	eb d3                	jmp    80112c <read+0x5e>

00801159 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801159:	f3 0f 1e fb          	endbr32 
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	57                   	push   %edi
  801161:	56                   	push   %esi
  801162:	53                   	push   %ebx
  801163:	83 ec 0c             	sub    $0xc,%esp
  801166:	8b 7d 08             	mov    0x8(%ebp),%edi
  801169:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80116c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801171:	eb 02                	jmp    801175 <readn+0x1c>
  801173:	01 c3                	add    %eax,%ebx
  801175:	39 f3                	cmp    %esi,%ebx
  801177:	73 21                	jae    80119a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801179:	83 ec 04             	sub    $0x4,%esp
  80117c:	89 f0                	mov    %esi,%eax
  80117e:	29 d8                	sub    %ebx,%eax
  801180:	50                   	push   %eax
  801181:	89 d8                	mov    %ebx,%eax
  801183:	03 45 0c             	add    0xc(%ebp),%eax
  801186:	50                   	push   %eax
  801187:	57                   	push   %edi
  801188:	e8 41 ff ff ff       	call   8010ce <read>
		if (m < 0)
  80118d:	83 c4 10             	add    $0x10,%esp
  801190:	85 c0                	test   %eax,%eax
  801192:	78 04                	js     801198 <readn+0x3f>
			return m;
		if (m == 0)
  801194:	75 dd                	jne    801173 <readn+0x1a>
  801196:	eb 02                	jmp    80119a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801198:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80119a:	89 d8                	mov    %ebx,%eax
  80119c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119f:	5b                   	pop    %ebx
  8011a0:	5e                   	pop    %esi
  8011a1:	5f                   	pop    %edi
  8011a2:	5d                   	pop    %ebp
  8011a3:	c3                   	ret    

008011a4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011a4:	f3 0f 1e fb          	endbr32 
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 1c             	sub    $0x1c,%esp
  8011af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b5:	50                   	push   %eax
  8011b6:	53                   	push   %ebx
  8011b7:	e8 8f fc ff ff       	call   800e4b <fd_lookup>
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	78 3a                	js     8011fd <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c9:	50                   	push   %eax
  8011ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cd:	ff 30                	pushl  (%eax)
  8011cf:	e8 cb fc ff ff       	call   800e9f <dev_lookup>
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	78 22                	js     8011fd <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011de:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011e2:	74 1e                	je     801202 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e7:	8b 52 0c             	mov    0xc(%edx),%edx
  8011ea:	85 d2                	test   %edx,%edx
  8011ec:	74 35                	je     801223 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	ff 75 10             	pushl  0x10(%ebp)
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	50                   	push   %eax
  8011f8:	ff d2                	call   *%edx
  8011fa:	83 c4 10             	add    $0x10,%esp
}
  8011fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801200:	c9                   	leave  
  801201:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801202:	a1 08 40 80 00       	mov    0x804008,%eax
  801207:	8b 40 48             	mov    0x48(%eax),%eax
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	53                   	push   %ebx
  80120e:	50                   	push   %eax
  80120f:	68 c9 22 80 00       	push   $0x8022c9
  801214:	e8 50 ef ff ff       	call   800169 <cprintf>
		return -E_INVAL;
  801219:	83 c4 10             	add    $0x10,%esp
  80121c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801221:	eb da                	jmp    8011fd <write+0x59>
		return -E_NOT_SUPP;
  801223:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801228:	eb d3                	jmp    8011fd <write+0x59>

0080122a <seek>:

int
seek(int fdnum, off_t offset)
{
  80122a:	f3 0f 1e fb          	endbr32 
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801234:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	ff 75 08             	pushl  0x8(%ebp)
  80123b:	e8 0b fc ff ff       	call   800e4b <fd_lookup>
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	85 c0                	test   %eax,%eax
  801245:	78 0e                	js     801255 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801250:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801255:	c9                   	leave  
  801256:	c3                   	ret    

00801257 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801257:	f3 0f 1e fb          	endbr32 
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	53                   	push   %ebx
  80125f:	83 ec 1c             	sub    $0x1c,%esp
  801262:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801265:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801268:	50                   	push   %eax
  801269:	53                   	push   %ebx
  80126a:	e8 dc fb ff ff       	call   800e4b <fd_lookup>
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	78 37                	js     8012ad <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801276:	83 ec 08             	sub    $0x8,%esp
  801279:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127c:	50                   	push   %eax
  80127d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801280:	ff 30                	pushl  (%eax)
  801282:	e8 18 fc ff ff       	call   800e9f <dev_lookup>
  801287:	83 c4 10             	add    $0x10,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 1f                	js     8012ad <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80128e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801291:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801295:	74 1b                	je     8012b2 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129a:	8b 52 18             	mov    0x18(%edx),%edx
  80129d:	85 d2                	test   %edx,%edx
  80129f:	74 32                	je     8012d3 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012a1:	83 ec 08             	sub    $0x8,%esp
  8012a4:	ff 75 0c             	pushl  0xc(%ebp)
  8012a7:	50                   	push   %eax
  8012a8:	ff d2                	call   *%edx
  8012aa:	83 c4 10             	add    $0x10,%esp
}
  8012ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012b2:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012b7:	8b 40 48             	mov    0x48(%eax),%eax
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	53                   	push   %ebx
  8012be:	50                   	push   %eax
  8012bf:	68 8c 22 80 00       	push   $0x80228c
  8012c4:	e8 a0 ee ff ff       	call   800169 <cprintf>
		return -E_INVAL;
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d1:	eb da                	jmp    8012ad <ftruncate+0x56>
		return -E_NOT_SUPP;
  8012d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012d8:	eb d3                	jmp    8012ad <ftruncate+0x56>

008012da <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012da:	f3 0f 1e fb          	endbr32 
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	53                   	push   %ebx
  8012e2:	83 ec 1c             	sub    $0x1c,%esp
  8012e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012eb:	50                   	push   %eax
  8012ec:	ff 75 08             	pushl  0x8(%ebp)
  8012ef:	e8 57 fb ff ff       	call   800e4b <fd_lookup>
  8012f4:	83 c4 10             	add    $0x10,%esp
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	78 4b                	js     801346 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801301:	50                   	push   %eax
  801302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801305:	ff 30                	pushl  (%eax)
  801307:	e8 93 fb ff ff       	call   800e9f <dev_lookup>
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	85 c0                	test   %eax,%eax
  801311:	78 33                	js     801346 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801316:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80131a:	74 2f                	je     80134b <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80131c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80131f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801326:	00 00 00 
	stat->st_isdir = 0;
  801329:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801330:	00 00 00 
	stat->st_dev = dev;
  801333:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801339:	83 ec 08             	sub    $0x8,%esp
  80133c:	53                   	push   %ebx
  80133d:	ff 75 f0             	pushl  -0x10(%ebp)
  801340:	ff 50 14             	call   *0x14(%eax)
  801343:	83 c4 10             	add    $0x10,%esp
}
  801346:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801349:	c9                   	leave  
  80134a:	c3                   	ret    
		return -E_NOT_SUPP;
  80134b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801350:	eb f4                	jmp    801346 <fstat+0x6c>

00801352 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801352:	f3 0f 1e fb          	endbr32 
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	56                   	push   %esi
  80135a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80135b:	83 ec 08             	sub    $0x8,%esp
  80135e:	6a 00                	push   $0x0
  801360:	ff 75 08             	pushl  0x8(%ebp)
  801363:	e8 fb 01 00 00       	call   801563 <open>
  801368:	89 c3                	mov    %eax,%ebx
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	85 c0                	test   %eax,%eax
  80136f:	78 1b                	js     80138c <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801371:	83 ec 08             	sub    $0x8,%esp
  801374:	ff 75 0c             	pushl  0xc(%ebp)
  801377:	50                   	push   %eax
  801378:	e8 5d ff ff ff       	call   8012da <fstat>
  80137d:	89 c6                	mov    %eax,%esi
	close(fd);
  80137f:	89 1c 24             	mov    %ebx,(%esp)
  801382:	e8 fd fb ff ff       	call   800f84 <close>
	return r;
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	89 f3                	mov    %esi,%ebx
}
  80138c:	89 d8                	mov    %ebx,%eax
  80138e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801391:	5b                   	pop    %ebx
  801392:	5e                   	pop    %esi
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    

00801395 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	56                   	push   %esi
  801399:	53                   	push   %ebx
  80139a:	89 c6                	mov    %eax,%esi
  80139c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80139e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013a5:	74 27                	je     8013ce <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013a7:	6a 07                	push   $0x7
  8013a9:	68 00 50 80 00       	push   $0x805000
  8013ae:	56                   	push   %esi
  8013af:	ff 35 00 40 80 00    	pushl  0x804000
  8013b5:	e8 20 08 00 00       	call   801bda <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013ba:	83 c4 0c             	add    $0xc,%esp
  8013bd:	6a 00                	push   $0x0
  8013bf:	53                   	push   %ebx
  8013c0:	6a 00                	push   $0x0
  8013c2:	e8 8e 07 00 00       	call   801b55 <ipc_recv>
}
  8013c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013ca:	5b                   	pop    %ebx
  8013cb:	5e                   	pop    %esi
  8013cc:	5d                   	pop    %ebp
  8013cd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013ce:	83 ec 0c             	sub    $0xc,%esp
  8013d1:	6a 01                	push   $0x1
  8013d3:	e8 5a 08 00 00       	call   801c32 <ipc_find_env>
  8013d8:	a3 00 40 80 00       	mov    %eax,0x804000
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	eb c5                	jmp    8013a7 <fsipc+0x12>

008013e2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013e2:	f3 0f 1e fb          	endbr32 
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fa:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801404:	b8 02 00 00 00       	mov    $0x2,%eax
  801409:	e8 87 ff ff ff       	call   801395 <fsipc>
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <devfile_flush>:
{
  801410:	f3 0f 1e fb          	endbr32 
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8b 40 0c             	mov    0xc(%eax),%eax
  801420:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801425:	ba 00 00 00 00       	mov    $0x0,%edx
  80142a:	b8 06 00 00 00       	mov    $0x6,%eax
  80142f:	e8 61 ff ff ff       	call   801395 <fsipc>
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <devfile_stat>:
{
  801436:	f3 0f 1e fb          	endbr32 
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8b 40 0c             	mov    0xc(%eax),%eax
  80144a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80144f:	ba 00 00 00 00       	mov    $0x0,%edx
  801454:	b8 05 00 00 00       	mov    $0x5,%eax
  801459:	e8 37 ff ff ff       	call   801395 <fsipc>
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 2c                	js     80148e <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801462:	83 ec 08             	sub    $0x8,%esp
  801465:	68 00 50 80 00       	push   $0x805000
  80146a:	53                   	push   %ebx
  80146b:	e8 03 f3 ff ff       	call   800773 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801470:	a1 80 50 80 00       	mov    0x805080,%eax
  801475:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80147b:	a1 84 50 80 00       	mov    0x805084,%eax
  801480:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <devfile_write>:
{
  801493:	f3 0f 1e fb          	endbr32 
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a3:	8b 52 0c             	mov    0xc(%edx),%edx
  8014a6:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8014ac:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014b1:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8014b6:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8014b9:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014be:	50                   	push   %eax
  8014bf:	ff 75 0c             	pushl  0xc(%ebp)
  8014c2:	68 08 50 80 00       	push   $0x805008
  8014c7:	e8 5d f4 ff ff       	call   800929 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8014cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d1:	b8 04 00 00 00       	mov    $0x4,%eax
  8014d6:	e8 ba fe ff ff       	call   801395 <fsipc>
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <devfile_read>:
{
  8014dd:	f3 0f 1e fb          	endbr32 
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	56                   	push   %esi
  8014e5:	53                   	push   %ebx
  8014e6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ef:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014f4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ff:	b8 03 00 00 00       	mov    $0x3,%eax
  801504:	e8 8c fe ff ff       	call   801395 <fsipc>
  801509:	89 c3                	mov    %eax,%ebx
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 1f                	js     80152e <devfile_read+0x51>
	assert(r <= n);
  80150f:	39 f0                	cmp    %esi,%eax
  801511:	77 24                	ja     801537 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801513:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801518:	7f 33                	jg     80154d <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	50                   	push   %eax
  80151e:	68 00 50 80 00       	push   $0x805000
  801523:	ff 75 0c             	pushl  0xc(%ebp)
  801526:	e8 fe f3 ff ff       	call   800929 <memmove>
	return r;
  80152b:	83 c4 10             	add    $0x10,%esp
}
  80152e:	89 d8                	mov    %ebx,%eax
  801530:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801533:	5b                   	pop    %ebx
  801534:	5e                   	pop    %esi
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    
	assert(r <= n);
  801537:	68 f8 22 80 00       	push   $0x8022f8
  80153c:	68 ff 22 80 00       	push   $0x8022ff
  801541:	6a 7c                	push   $0x7c
  801543:	68 14 23 80 00       	push   $0x802314
  801548:	e8 be 05 00 00       	call   801b0b <_panic>
	assert(r <= PGSIZE);
  80154d:	68 1f 23 80 00       	push   $0x80231f
  801552:	68 ff 22 80 00       	push   $0x8022ff
  801557:	6a 7d                	push   $0x7d
  801559:	68 14 23 80 00       	push   $0x802314
  80155e:	e8 a8 05 00 00       	call   801b0b <_panic>

00801563 <open>:
{
  801563:	f3 0f 1e fb          	endbr32 
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	56                   	push   %esi
  80156b:	53                   	push   %ebx
  80156c:	83 ec 1c             	sub    $0x1c,%esp
  80156f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801572:	56                   	push   %esi
  801573:	e8 b8 f1 ff ff       	call   800730 <strlen>
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801580:	7f 6c                	jg     8015ee <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801582:	83 ec 0c             	sub    $0xc,%esp
  801585:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801588:	50                   	push   %eax
  801589:	e8 67 f8 ff ff       	call   800df5 <fd_alloc>
  80158e:	89 c3                	mov    %eax,%ebx
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	85 c0                	test   %eax,%eax
  801595:	78 3c                	js     8015d3 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801597:	83 ec 08             	sub    $0x8,%esp
  80159a:	56                   	push   %esi
  80159b:	68 00 50 80 00       	push   $0x805000
  8015a0:	e8 ce f1 ff ff       	call   800773 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8015b5:	e8 db fd ff ff       	call   801395 <fsipc>
  8015ba:	89 c3                	mov    %eax,%ebx
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	78 19                	js     8015dc <open+0x79>
	return fd2num(fd);
  8015c3:	83 ec 0c             	sub    $0xc,%esp
  8015c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c9:	e8 f8 f7 ff ff       	call   800dc6 <fd2num>
  8015ce:	89 c3                	mov    %eax,%ebx
  8015d0:	83 c4 10             	add    $0x10,%esp
}
  8015d3:	89 d8                	mov    %ebx,%eax
  8015d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d8:	5b                   	pop    %ebx
  8015d9:	5e                   	pop    %esi
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    
		fd_close(fd, 0);
  8015dc:	83 ec 08             	sub    $0x8,%esp
  8015df:	6a 00                	push   $0x0
  8015e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e4:	e8 10 f9 ff ff       	call   800ef9 <fd_close>
		return r;
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	eb e5                	jmp    8015d3 <open+0x70>
		return -E_BAD_PATH;
  8015ee:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015f3:	eb de                	jmp    8015d3 <open+0x70>

008015f5 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015f5:	f3 0f 1e fb          	endbr32 
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801604:	b8 08 00 00 00       	mov    $0x8,%eax
  801609:	e8 87 fd ff ff       	call   801395 <fsipc>
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801610:	f3 0f 1e fb          	endbr32 
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	56                   	push   %esi
  801618:	53                   	push   %ebx
  801619:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80161c:	83 ec 0c             	sub    $0xc,%esp
  80161f:	ff 75 08             	pushl  0x8(%ebp)
  801622:	e8 b3 f7 ff ff       	call   800dda <fd2data>
  801627:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801629:	83 c4 08             	add    $0x8,%esp
  80162c:	68 2b 23 80 00       	push   $0x80232b
  801631:	53                   	push   %ebx
  801632:	e8 3c f1 ff ff       	call   800773 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801637:	8b 46 04             	mov    0x4(%esi),%eax
  80163a:	2b 06                	sub    (%esi),%eax
  80163c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801642:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801649:	00 00 00 
	stat->st_dev = &devpipe;
  80164c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801653:	30 80 00 
	return 0;
}
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
  80165b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80165e:	5b                   	pop    %ebx
  80165f:	5e                   	pop    %esi
  801660:	5d                   	pop    %ebp
  801661:	c3                   	ret    

00801662 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801662:	f3 0f 1e fb          	endbr32 
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	53                   	push   %ebx
  80166a:	83 ec 0c             	sub    $0xc,%esp
  80166d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801670:	53                   	push   %ebx
  801671:	6a 00                	push   $0x0
  801673:	e8 ca f5 ff ff       	call   800c42 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801678:	89 1c 24             	mov    %ebx,(%esp)
  80167b:	e8 5a f7 ff ff       	call   800dda <fd2data>
  801680:	83 c4 08             	add    $0x8,%esp
  801683:	50                   	push   %eax
  801684:	6a 00                	push   $0x0
  801686:	e8 b7 f5 ff ff       	call   800c42 <sys_page_unmap>
}
  80168b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <_pipeisclosed>:
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	57                   	push   %edi
  801694:	56                   	push   %esi
  801695:	53                   	push   %ebx
  801696:	83 ec 1c             	sub    $0x1c,%esp
  801699:	89 c7                	mov    %eax,%edi
  80169b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80169d:	a1 08 40 80 00       	mov    0x804008,%eax
  8016a2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016a5:	83 ec 0c             	sub    $0xc,%esp
  8016a8:	57                   	push   %edi
  8016a9:	e8 c1 05 00 00       	call   801c6f <pageref>
  8016ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016b1:	89 34 24             	mov    %esi,(%esp)
  8016b4:	e8 b6 05 00 00       	call   801c6f <pageref>
		nn = thisenv->env_runs;
  8016b9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8016bf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	39 cb                	cmp    %ecx,%ebx
  8016c7:	74 1b                	je     8016e4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016c9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016cc:	75 cf                	jne    80169d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016ce:	8b 42 58             	mov    0x58(%edx),%eax
  8016d1:	6a 01                	push   $0x1
  8016d3:	50                   	push   %eax
  8016d4:	53                   	push   %ebx
  8016d5:	68 32 23 80 00       	push   $0x802332
  8016da:	e8 8a ea ff ff       	call   800169 <cprintf>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	eb b9                	jmp    80169d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016e4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016e7:	0f 94 c0             	sete   %al
  8016ea:	0f b6 c0             	movzbl %al,%eax
}
  8016ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f0:	5b                   	pop    %ebx
  8016f1:	5e                   	pop    %esi
  8016f2:	5f                   	pop    %edi
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    

008016f5 <devpipe_write>:
{
  8016f5:	f3 0f 1e fb          	endbr32 
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	57                   	push   %edi
  8016fd:	56                   	push   %esi
  8016fe:	53                   	push   %ebx
  8016ff:	83 ec 28             	sub    $0x28,%esp
  801702:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801705:	56                   	push   %esi
  801706:	e8 cf f6 ff ff       	call   800dda <fd2data>
  80170b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	bf 00 00 00 00       	mov    $0x0,%edi
  801715:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801718:	74 4f                	je     801769 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80171a:	8b 43 04             	mov    0x4(%ebx),%eax
  80171d:	8b 0b                	mov    (%ebx),%ecx
  80171f:	8d 51 20             	lea    0x20(%ecx),%edx
  801722:	39 d0                	cmp    %edx,%eax
  801724:	72 14                	jb     80173a <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801726:	89 da                	mov    %ebx,%edx
  801728:	89 f0                	mov    %esi,%eax
  80172a:	e8 61 ff ff ff       	call   801690 <_pipeisclosed>
  80172f:	85 c0                	test   %eax,%eax
  801731:	75 3b                	jne    80176e <devpipe_write+0x79>
			sys_yield();
  801733:	e8 5a f4 ff ff       	call   800b92 <sys_yield>
  801738:	eb e0                	jmp    80171a <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80173a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80173d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801741:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801744:	89 c2                	mov    %eax,%edx
  801746:	c1 fa 1f             	sar    $0x1f,%edx
  801749:	89 d1                	mov    %edx,%ecx
  80174b:	c1 e9 1b             	shr    $0x1b,%ecx
  80174e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801751:	83 e2 1f             	and    $0x1f,%edx
  801754:	29 ca                	sub    %ecx,%edx
  801756:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80175a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80175e:	83 c0 01             	add    $0x1,%eax
  801761:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801764:	83 c7 01             	add    $0x1,%edi
  801767:	eb ac                	jmp    801715 <devpipe_write+0x20>
	return i;
  801769:	8b 45 10             	mov    0x10(%ebp),%eax
  80176c:	eb 05                	jmp    801773 <devpipe_write+0x7e>
				return 0;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801773:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801776:	5b                   	pop    %ebx
  801777:	5e                   	pop    %esi
  801778:	5f                   	pop    %edi
  801779:	5d                   	pop    %ebp
  80177a:	c3                   	ret    

0080177b <devpipe_read>:
{
  80177b:	f3 0f 1e fb          	endbr32 
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	57                   	push   %edi
  801783:	56                   	push   %esi
  801784:	53                   	push   %ebx
  801785:	83 ec 18             	sub    $0x18,%esp
  801788:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80178b:	57                   	push   %edi
  80178c:	e8 49 f6 ff ff       	call   800dda <fd2data>
  801791:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	be 00 00 00 00       	mov    $0x0,%esi
  80179b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80179e:	75 14                	jne    8017b4 <devpipe_read+0x39>
	return i;
  8017a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a3:	eb 02                	jmp    8017a7 <devpipe_read+0x2c>
				return i;
  8017a5:	89 f0                	mov    %esi,%eax
}
  8017a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017aa:	5b                   	pop    %ebx
  8017ab:	5e                   	pop    %esi
  8017ac:	5f                   	pop    %edi
  8017ad:	5d                   	pop    %ebp
  8017ae:	c3                   	ret    
			sys_yield();
  8017af:	e8 de f3 ff ff       	call   800b92 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8017b4:	8b 03                	mov    (%ebx),%eax
  8017b6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017b9:	75 18                	jne    8017d3 <devpipe_read+0x58>
			if (i > 0)
  8017bb:	85 f6                	test   %esi,%esi
  8017bd:	75 e6                	jne    8017a5 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8017bf:	89 da                	mov    %ebx,%edx
  8017c1:	89 f8                	mov    %edi,%eax
  8017c3:	e8 c8 fe ff ff       	call   801690 <_pipeisclosed>
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	74 e3                	je     8017af <devpipe_read+0x34>
				return 0;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d1:	eb d4                	jmp    8017a7 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017d3:	99                   	cltd   
  8017d4:	c1 ea 1b             	shr    $0x1b,%edx
  8017d7:	01 d0                	add    %edx,%eax
  8017d9:	83 e0 1f             	and    $0x1f,%eax
  8017dc:	29 d0                	sub    %edx,%eax
  8017de:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017e9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017ec:	83 c6 01             	add    $0x1,%esi
  8017ef:	eb aa                	jmp    80179b <devpipe_read+0x20>

008017f1 <pipe>:
{
  8017f1:	f3 0f 1e fb          	endbr32 
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	56                   	push   %esi
  8017f9:	53                   	push   %ebx
  8017fa:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8017fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801800:	50                   	push   %eax
  801801:	e8 ef f5 ff ff       	call   800df5 <fd_alloc>
  801806:	89 c3                	mov    %eax,%ebx
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	85 c0                	test   %eax,%eax
  80180d:	0f 88 23 01 00 00    	js     801936 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801813:	83 ec 04             	sub    $0x4,%esp
  801816:	68 07 04 00 00       	push   $0x407
  80181b:	ff 75 f4             	pushl  -0xc(%ebp)
  80181e:	6a 00                	push   $0x0
  801820:	e8 90 f3 ff ff       	call   800bb5 <sys_page_alloc>
  801825:	89 c3                	mov    %eax,%ebx
  801827:	83 c4 10             	add    $0x10,%esp
  80182a:	85 c0                	test   %eax,%eax
  80182c:	0f 88 04 01 00 00    	js     801936 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801832:	83 ec 0c             	sub    $0xc,%esp
  801835:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801838:	50                   	push   %eax
  801839:	e8 b7 f5 ff ff       	call   800df5 <fd_alloc>
  80183e:	89 c3                	mov    %eax,%ebx
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	85 c0                	test   %eax,%eax
  801845:	0f 88 db 00 00 00    	js     801926 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	68 07 04 00 00       	push   $0x407
  801853:	ff 75 f0             	pushl  -0x10(%ebp)
  801856:	6a 00                	push   $0x0
  801858:	e8 58 f3 ff ff       	call   800bb5 <sys_page_alloc>
  80185d:	89 c3                	mov    %eax,%ebx
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	85 c0                	test   %eax,%eax
  801864:	0f 88 bc 00 00 00    	js     801926 <pipe+0x135>
	va = fd2data(fd0);
  80186a:	83 ec 0c             	sub    $0xc,%esp
  80186d:	ff 75 f4             	pushl  -0xc(%ebp)
  801870:	e8 65 f5 ff ff       	call   800dda <fd2data>
  801875:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801877:	83 c4 0c             	add    $0xc,%esp
  80187a:	68 07 04 00 00       	push   $0x407
  80187f:	50                   	push   %eax
  801880:	6a 00                	push   $0x0
  801882:	e8 2e f3 ff ff       	call   800bb5 <sys_page_alloc>
  801887:	89 c3                	mov    %eax,%ebx
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	85 c0                	test   %eax,%eax
  80188e:	0f 88 82 00 00 00    	js     801916 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801894:	83 ec 0c             	sub    $0xc,%esp
  801897:	ff 75 f0             	pushl  -0x10(%ebp)
  80189a:	e8 3b f5 ff ff       	call   800dda <fd2data>
  80189f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018a6:	50                   	push   %eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	56                   	push   %esi
  8018aa:	6a 00                	push   $0x0
  8018ac:	e8 4b f3 ff ff       	call   800bfc <sys_page_map>
  8018b1:	89 c3                	mov    %eax,%ebx
  8018b3:	83 c4 20             	add    $0x20,%esp
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	78 4e                	js     801908 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8018ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8018bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8018c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8018ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8018d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018dd:	83 ec 0c             	sub    $0xc,%esp
  8018e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e3:	e8 de f4 ff ff       	call   800dc6 <fd2num>
  8018e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018eb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018ed:	83 c4 04             	add    $0x4,%esp
  8018f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f3:	e8 ce f4 ff ff       	call   800dc6 <fd2num>
  8018f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	bb 00 00 00 00       	mov    $0x0,%ebx
  801906:	eb 2e                	jmp    801936 <pipe+0x145>
	sys_page_unmap(0, va);
  801908:	83 ec 08             	sub    $0x8,%esp
  80190b:	56                   	push   %esi
  80190c:	6a 00                	push   $0x0
  80190e:	e8 2f f3 ff ff       	call   800c42 <sys_page_unmap>
  801913:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801916:	83 ec 08             	sub    $0x8,%esp
  801919:	ff 75 f0             	pushl  -0x10(%ebp)
  80191c:	6a 00                	push   $0x0
  80191e:	e8 1f f3 ff ff       	call   800c42 <sys_page_unmap>
  801923:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801926:	83 ec 08             	sub    $0x8,%esp
  801929:	ff 75 f4             	pushl  -0xc(%ebp)
  80192c:	6a 00                	push   $0x0
  80192e:	e8 0f f3 ff ff       	call   800c42 <sys_page_unmap>
  801933:	83 c4 10             	add    $0x10,%esp
}
  801936:	89 d8                	mov    %ebx,%eax
  801938:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193b:	5b                   	pop    %ebx
  80193c:	5e                   	pop    %esi
  80193d:	5d                   	pop    %ebp
  80193e:	c3                   	ret    

0080193f <pipeisclosed>:
{
  80193f:	f3 0f 1e fb          	endbr32 
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801949:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194c:	50                   	push   %eax
  80194d:	ff 75 08             	pushl  0x8(%ebp)
  801950:	e8 f6 f4 ff ff       	call   800e4b <fd_lookup>
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	85 c0                	test   %eax,%eax
  80195a:	78 18                	js     801974 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	ff 75 f4             	pushl  -0xc(%ebp)
  801962:	e8 73 f4 ff ff       	call   800dda <fd2data>
  801967:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196c:	e8 1f fd ff ff       	call   801690 <_pipeisclosed>
  801971:	83 c4 10             	add    $0x10,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801976:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80197a:	b8 00 00 00 00       	mov    $0x0,%eax
  80197f:	c3                   	ret    

00801980 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801980:	f3 0f 1e fb          	endbr32 
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80198a:	68 4a 23 80 00       	push   $0x80234a
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	e8 dc ed ff ff       	call   800773 <strcpy>
	return 0;
}
  801997:	b8 00 00 00 00       	mov    $0x0,%eax
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <devcons_write>:
{
  80199e:	f3 0f 1e fb          	endbr32 
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	57                   	push   %edi
  8019a6:	56                   	push   %esi
  8019a7:	53                   	push   %ebx
  8019a8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8019ae:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8019b3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8019b9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019bc:	73 31                	jae    8019ef <devcons_write+0x51>
		m = n - tot;
  8019be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019c1:	29 f3                	sub    %esi,%ebx
  8019c3:	83 fb 7f             	cmp    $0x7f,%ebx
  8019c6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8019cb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	53                   	push   %ebx
  8019d2:	89 f0                	mov    %esi,%eax
  8019d4:	03 45 0c             	add    0xc(%ebp),%eax
  8019d7:	50                   	push   %eax
  8019d8:	57                   	push   %edi
  8019d9:	e8 4b ef ff ff       	call   800929 <memmove>
		sys_cputs(buf, m);
  8019de:	83 c4 08             	add    $0x8,%esp
  8019e1:	53                   	push   %ebx
  8019e2:	57                   	push   %edi
  8019e3:	e8 fd f0 ff ff       	call   800ae5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8019e8:	01 de                	add    %ebx,%esi
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	eb ca                	jmp    8019b9 <devcons_write+0x1b>
}
  8019ef:	89 f0                	mov    %esi,%eax
  8019f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019f4:	5b                   	pop    %ebx
  8019f5:	5e                   	pop    %esi
  8019f6:	5f                   	pop    %edi
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    

008019f9 <devcons_read>:
{
  8019f9:	f3 0f 1e fb          	endbr32 
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 08             	sub    $0x8,%esp
  801a03:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801a08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0c:	74 21                	je     801a2f <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801a0e:	e8 f4 f0 ff ff       	call   800b07 <sys_cgetc>
  801a13:	85 c0                	test   %eax,%eax
  801a15:	75 07                	jne    801a1e <devcons_read+0x25>
		sys_yield();
  801a17:	e8 76 f1 ff ff       	call   800b92 <sys_yield>
  801a1c:	eb f0                	jmp    801a0e <devcons_read+0x15>
	if (c < 0)
  801a1e:	78 0f                	js     801a2f <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801a20:	83 f8 04             	cmp    $0x4,%eax
  801a23:	74 0c                	je     801a31 <devcons_read+0x38>
	*(char*)vbuf = c;
  801a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a28:	88 02                	mov    %al,(%edx)
	return 1;
  801a2a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    
		return 0;
  801a31:	b8 00 00 00 00       	mov    $0x0,%eax
  801a36:	eb f7                	jmp    801a2f <devcons_read+0x36>

00801a38 <cputchar>:
{
  801a38:	f3 0f 1e fb          	endbr32 
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a48:	6a 01                	push   $0x1
  801a4a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a4d:	50                   	push   %eax
  801a4e:	e8 92 f0 ff ff       	call   800ae5 <sys_cputs>
}
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <getchar>:
{
  801a58:	f3 0f 1e fb          	endbr32 
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a62:	6a 01                	push   $0x1
  801a64:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a67:	50                   	push   %eax
  801a68:	6a 00                	push   $0x0
  801a6a:	e8 5f f6 ff ff       	call   8010ce <read>
	if (r < 0)
  801a6f:	83 c4 10             	add    $0x10,%esp
  801a72:	85 c0                	test   %eax,%eax
  801a74:	78 06                	js     801a7c <getchar+0x24>
	if (r < 1)
  801a76:	74 06                	je     801a7e <getchar+0x26>
	return c;
  801a78:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    
		return -E_EOF;
  801a7e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a83:	eb f7                	jmp    801a7c <getchar+0x24>

00801a85 <iscons>:
{
  801a85:	f3 0f 1e fb          	endbr32 
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a92:	50                   	push   %eax
  801a93:	ff 75 08             	pushl  0x8(%ebp)
  801a96:	e8 b0 f3 ff ff       	call   800e4b <fd_lookup>
  801a9b:	83 c4 10             	add    $0x10,%esp
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 11                	js     801ab3 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801aab:	39 10                	cmp    %edx,(%eax)
  801aad:	0f 94 c0             	sete   %al
  801ab0:	0f b6 c0             	movzbl %al,%eax
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <opencons>:
{
  801ab5:	f3 0f 1e fb          	endbr32 
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801abf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac2:	50                   	push   %eax
  801ac3:	e8 2d f3 ff ff       	call   800df5 <fd_alloc>
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	78 3a                	js     801b09 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801acf:	83 ec 04             	sub    $0x4,%esp
  801ad2:	68 07 04 00 00       	push   $0x407
  801ad7:	ff 75 f4             	pushl  -0xc(%ebp)
  801ada:	6a 00                	push   $0x0
  801adc:	e8 d4 f0 ff ff       	call   800bb5 <sys_page_alloc>
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	78 21                	js     801b09 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aeb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801af1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801afd:	83 ec 0c             	sub    $0xc,%esp
  801b00:	50                   	push   %eax
  801b01:	e8 c0 f2 ff ff       	call   800dc6 <fd2num>
  801b06:	83 c4 10             	add    $0x10,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b0b:	f3 0f 1e fb          	endbr32 
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	56                   	push   %esi
  801b13:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b14:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b17:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801b1d:	e8 4d f0 ff ff       	call   800b6f <sys_getenvid>
  801b22:	83 ec 0c             	sub    $0xc,%esp
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	ff 75 08             	pushl  0x8(%ebp)
  801b2b:	56                   	push   %esi
  801b2c:	50                   	push   %eax
  801b2d:	68 58 23 80 00       	push   $0x802358
  801b32:	e8 32 e6 ff ff       	call   800169 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b37:	83 c4 18             	add    $0x18,%esp
  801b3a:	53                   	push   %ebx
  801b3b:	ff 75 10             	pushl  0x10(%ebp)
  801b3e:	e8 d1 e5 ff ff       	call   800114 <vcprintf>
	cprintf("\n");
  801b43:	c7 04 24 2c 1f 80 00 	movl   $0x801f2c,(%esp)
  801b4a:	e8 1a e6 ff ff       	call   800169 <cprintf>
  801b4f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b52:	cc                   	int3   
  801b53:	eb fd                	jmp    801b52 <_panic+0x47>

00801b55 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b55:	f3 0f 1e fb          	endbr32 
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	56                   	push   %esi
  801b5d:	53                   	push   %ebx
  801b5e:	8b 75 08             	mov    0x8(%ebp),%esi
  801b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b64:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b67:	85 c0                	test   %eax,%eax
  801b69:	74 3d                	je     801ba8 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b6b:	83 ec 0c             	sub    $0xc,%esp
  801b6e:	50                   	push   %eax
  801b6f:	e8 0d f2 ff ff       	call   800d81 <sys_ipc_recv>
  801b74:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b77:	85 f6                	test   %esi,%esi
  801b79:	74 0b                	je     801b86 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b7b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b81:	8b 52 74             	mov    0x74(%edx),%edx
  801b84:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b86:	85 db                	test   %ebx,%ebx
  801b88:	74 0b                	je     801b95 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b8a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b90:	8b 52 78             	mov    0x78(%edx),%edx
  801b93:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801b95:	85 c0                	test   %eax,%eax
  801b97:	78 21                	js     801bba <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801b99:	a1 08 40 80 00       	mov    0x804008,%eax
  801b9e:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ba1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	68 00 00 c0 ee       	push   $0xeec00000
  801bb0:	e8 cc f1 ff ff       	call   800d81 <sys_ipc_recv>
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	eb bd                	jmp    801b77 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801bba:	85 f6                	test   %esi,%esi
  801bbc:	74 10                	je     801bce <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801bbe:	85 db                	test   %ebx,%ebx
  801bc0:	75 df                	jne    801ba1 <ipc_recv+0x4c>
  801bc2:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bc9:	00 00 00 
  801bcc:	eb d3                	jmp    801ba1 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801bce:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bd5:	00 00 00 
  801bd8:	eb e4                	jmp    801bbe <ipc_recv+0x69>

00801bda <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bda:	f3 0f 1e fb          	endbr32 
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	57                   	push   %edi
  801be2:	56                   	push   %esi
  801be3:	53                   	push   %ebx
  801be4:	83 ec 0c             	sub    $0xc,%esp
  801be7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bea:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bf0:	85 db                	test   %ebx,%ebx
  801bf2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bf7:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801bfa:	ff 75 14             	pushl  0x14(%ebp)
  801bfd:	53                   	push   %ebx
  801bfe:	56                   	push   %esi
  801bff:	57                   	push   %edi
  801c00:	e8 55 f1 ff ff       	call   800d5a <sys_ipc_try_send>
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	85 c0                	test   %eax,%eax
  801c0a:	79 1e                	jns    801c2a <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801c0c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c0f:	75 07                	jne    801c18 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801c11:	e8 7c ef ff ff       	call   800b92 <sys_yield>
  801c16:	eb e2                	jmp    801bfa <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801c18:	50                   	push   %eax
  801c19:	68 7b 23 80 00       	push   $0x80237b
  801c1e:	6a 59                	push   $0x59
  801c20:	68 96 23 80 00       	push   $0x802396
  801c25:	e8 e1 fe ff ff       	call   801b0b <_panic>
	}
}
  801c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5f                   	pop    %edi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    

00801c32 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c32:	f3 0f 1e fb          	endbr32 
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c41:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c44:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c4a:	8b 52 50             	mov    0x50(%edx),%edx
  801c4d:	39 ca                	cmp    %ecx,%edx
  801c4f:	74 11                	je     801c62 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c51:	83 c0 01             	add    $0x1,%eax
  801c54:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c59:	75 e6                	jne    801c41 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c60:	eb 0b                	jmp    801c6d <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c62:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c65:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c6a:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    

00801c6f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c6f:	f3 0f 1e fb          	endbr32 
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c79:	89 c2                	mov    %eax,%edx
  801c7b:	c1 ea 16             	shr    $0x16,%edx
  801c7e:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c85:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c8a:	f6 c1 01             	test   $0x1,%cl
  801c8d:	74 1c                	je     801cab <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c8f:	c1 e8 0c             	shr    $0xc,%eax
  801c92:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c99:	a8 01                	test   $0x1,%al
  801c9b:	74 0e                	je     801cab <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c9d:	c1 e8 0c             	shr    $0xc,%eax
  801ca0:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801ca7:	ef 
  801ca8:	0f b7 d2             	movzwl %dx,%edx
}
  801cab:	89 d0                	mov    %edx,%eax
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    
  801caf:	90                   	nop

00801cb0 <__udivdi3>:
  801cb0:	f3 0f 1e fb          	endbr32 
  801cb4:	55                   	push   %ebp
  801cb5:	57                   	push   %edi
  801cb6:	56                   	push   %esi
  801cb7:	53                   	push   %ebx
  801cb8:	83 ec 1c             	sub    $0x1c,%esp
  801cbb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801cbf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801cc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cc7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ccb:	85 d2                	test   %edx,%edx
  801ccd:	75 19                	jne    801ce8 <__udivdi3+0x38>
  801ccf:	39 f3                	cmp    %esi,%ebx
  801cd1:	76 4d                	jbe    801d20 <__udivdi3+0x70>
  801cd3:	31 ff                	xor    %edi,%edi
  801cd5:	89 e8                	mov    %ebp,%eax
  801cd7:	89 f2                	mov    %esi,%edx
  801cd9:	f7 f3                	div    %ebx
  801cdb:	89 fa                	mov    %edi,%edx
  801cdd:	83 c4 1c             	add    $0x1c,%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5e                   	pop    %esi
  801ce2:	5f                   	pop    %edi
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    
  801ce5:	8d 76 00             	lea    0x0(%esi),%esi
  801ce8:	39 f2                	cmp    %esi,%edx
  801cea:	76 14                	jbe    801d00 <__udivdi3+0x50>
  801cec:	31 ff                	xor    %edi,%edi
  801cee:	31 c0                	xor    %eax,%eax
  801cf0:	89 fa                	mov    %edi,%edx
  801cf2:	83 c4 1c             	add    $0x1c,%esp
  801cf5:	5b                   	pop    %ebx
  801cf6:	5e                   	pop    %esi
  801cf7:	5f                   	pop    %edi
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    
  801cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d00:	0f bd fa             	bsr    %edx,%edi
  801d03:	83 f7 1f             	xor    $0x1f,%edi
  801d06:	75 48                	jne    801d50 <__udivdi3+0xa0>
  801d08:	39 f2                	cmp    %esi,%edx
  801d0a:	72 06                	jb     801d12 <__udivdi3+0x62>
  801d0c:	31 c0                	xor    %eax,%eax
  801d0e:	39 eb                	cmp    %ebp,%ebx
  801d10:	77 de                	ja     801cf0 <__udivdi3+0x40>
  801d12:	b8 01 00 00 00       	mov    $0x1,%eax
  801d17:	eb d7                	jmp    801cf0 <__udivdi3+0x40>
  801d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d20:	89 d9                	mov    %ebx,%ecx
  801d22:	85 db                	test   %ebx,%ebx
  801d24:	75 0b                	jne    801d31 <__udivdi3+0x81>
  801d26:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2b:	31 d2                	xor    %edx,%edx
  801d2d:	f7 f3                	div    %ebx
  801d2f:	89 c1                	mov    %eax,%ecx
  801d31:	31 d2                	xor    %edx,%edx
  801d33:	89 f0                	mov    %esi,%eax
  801d35:	f7 f1                	div    %ecx
  801d37:	89 c6                	mov    %eax,%esi
  801d39:	89 e8                	mov    %ebp,%eax
  801d3b:	89 f7                	mov    %esi,%edi
  801d3d:	f7 f1                	div    %ecx
  801d3f:	89 fa                	mov    %edi,%edx
  801d41:	83 c4 1c             	add    $0x1c,%esp
  801d44:	5b                   	pop    %ebx
  801d45:	5e                   	pop    %esi
  801d46:	5f                   	pop    %edi
  801d47:	5d                   	pop    %ebp
  801d48:	c3                   	ret    
  801d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d50:	89 f9                	mov    %edi,%ecx
  801d52:	b8 20 00 00 00       	mov    $0x20,%eax
  801d57:	29 f8                	sub    %edi,%eax
  801d59:	d3 e2                	shl    %cl,%edx
  801d5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d5f:	89 c1                	mov    %eax,%ecx
  801d61:	89 da                	mov    %ebx,%edx
  801d63:	d3 ea                	shr    %cl,%edx
  801d65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d69:	09 d1                	or     %edx,%ecx
  801d6b:	89 f2                	mov    %esi,%edx
  801d6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d71:	89 f9                	mov    %edi,%ecx
  801d73:	d3 e3                	shl    %cl,%ebx
  801d75:	89 c1                	mov    %eax,%ecx
  801d77:	d3 ea                	shr    %cl,%edx
  801d79:	89 f9                	mov    %edi,%ecx
  801d7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d7f:	89 eb                	mov    %ebp,%ebx
  801d81:	d3 e6                	shl    %cl,%esi
  801d83:	89 c1                	mov    %eax,%ecx
  801d85:	d3 eb                	shr    %cl,%ebx
  801d87:	09 de                	or     %ebx,%esi
  801d89:	89 f0                	mov    %esi,%eax
  801d8b:	f7 74 24 08          	divl   0x8(%esp)
  801d8f:	89 d6                	mov    %edx,%esi
  801d91:	89 c3                	mov    %eax,%ebx
  801d93:	f7 64 24 0c          	mull   0xc(%esp)
  801d97:	39 d6                	cmp    %edx,%esi
  801d99:	72 15                	jb     801db0 <__udivdi3+0x100>
  801d9b:	89 f9                	mov    %edi,%ecx
  801d9d:	d3 e5                	shl    %cl,%ebp
  801d9f:	39 c5                	cmp    %eax,%ebp
  801da1:	73 04                	jae    801da7 <__udivdi3+0xf7>
  801da3:	39 d6                	cmp    %edx,%esi
  801da5:	74 09                	je     801db0 <__udivdi3+0x100>
  801da7:	89 d8                	mov    %ebx,%eax
  801da9:	31 ff                	xor    %edi,%edi
  801dab:	e9 40 ff ff ff       	jmp    801cf0 <__udivdi3+0x40>
  801db0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801db3:	31 ff                	xor    %edi,%edi
  801db5:	e9 36 ff ff ff       	jmp    801cf0 <__udivdi3+0x40>
  801dba:	66 90                	xchg   %ax,%ax
  801dbc:	66 90                	xchg   %ax,%ax
  801dbe:	66 90                	xchg   %ax,%ax

00801dc0 <__umoddi3>:
  801dc0:	f3 0f 1e fb          	endbr32 
  801dc4:	55                   	push   %ebp
  801dc5:	57                   	push   %edi
  801dc6:	56                   	push   %esi
  801dc7:	53                   	push   %ebx
  801dc8:	83 ec 1c             	sub    $0x1c,%esp
  801dcb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dcf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801dd3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801dd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	75 19                	jne    801df8 <__umoddi3+0x38>
  801ddf:	39 df                	cmp    %ebx,%edi
  801de1:	76 5d                	jbe    801e40 <__umoddi3+0x80>
  801de3:	89 f0                	mov    %esi,%eax
  801de5:	89 da                	mov    %ebx,%edx
  801de7:	f7 f7                	div    %edi
  801de9:	89 d0                	mov    %edx,%eax
  801deb:	31 d2                	xor    %edx,%edx
  801ded:	83 c4 1c             	add    $0x1c,%esp
  801df0:	5b                   	pop    %ebx
  801df1:	5e                   	pop    %esi
  801df2:	5f                   	pop    %edi
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    
  801df5:	8d 76 00             	lea    0x0(%esi),%esi
  801df8:	89 f2                	mov    %esi,%edx
  801dfa:	39 d8                	cmp    %ebx,%eax
  801dfc:	76 12                	jbe    801e10 <__umoddi3+0x50>
  801dfe:	89 f0                	mov    %esi,%eax
  801e00:	89 da                	mov    %ebx,%edx
  801e02:	83 c4 1c             	add    $0x1c,%esp
  801e05:	5b                   	pop    %ebx
  801e06:	5e                   	pop    %esi
  801e07:	5f                   	pop    %edi
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    
  801e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e10:	0f bd e8             	bsr    %eax,%ebp
  801e13:	83 f5 1f             	xor    $0x1f,%ebp
  801e16:	75 50                	jne    801e68 <__umoddi3+0xa8>
  801e18:	39 d8                	cmp    %ebx,%eax
  801e1a:	0f 82 e0 00 00 00    	jb     801f00 <__umoddi3+0x140>
  801e20:	89 d9                	mov    %ebx,%ecx
  801e22:	39 f7                	cmp    %esi,%edi
  801e24:	0f 86 d6 00 00 00    	jbe    801f00 <__umoddi3+0x140>
  801e2a:	89 d0                	mov    %edx,%eax
  801e2c:	89 ca                	mov    %ecx,%edx
  801e2e:	83 c4 1c             	add    $0x1c,%esp
  801e31:	5b                   	pop    %ebx
  801e32:	5e                   	pop    %esi
  801e33:	5f                   	pop    %edi
  801e34:	5d                   	pop    %ebp
  801e35:	c3                   	ret    
  801e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e3d:	8d 76 00             	lea    0x0(%esi),%esi
  801e40:	89 fd                	mov    %edi,%ebp
  801e42:	85 ff                	test   %edi,%edi
  801e44:	75 0b                	jne    801e51 <__umoddi3+0x91>
  801e46:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4b:	31 d2                	xor    %edx,%edx
  801e4d:	f7 f7                	div    %edi
  801e4f:	89 c5                	mov    %eax,%ebp
  801e51:	89 d8                	mov    %ebx,%eax
  801e53:	31 d2                	xor    %edx,%edx
  801e55:	f7 f5                	div    %ebp
  801e57:	89 f0                	mov    %esi,%eax
  801e59:	f7 f5                	div    %ebp
  801e5b:	89 d0                	mov    %edx,%eax
  801e5d:	31 d2                	xor    %edx,%edx
  801e5f:	eb 8c                	jmp    801ded <__umoddi3+0x2d>
  801e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e68:	89 e9                	mov    %ebp,%ecx
  801e6a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e6f:	29 ea                	sub    %ebp,%edx
  801e71:	d3 e0                	shl    %cl,%eax
  801e73:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e77:	89 d1                	mov    %edx,%ecx
  801e79:	89 f8                	mov    %edi,%eax
  801e7b:	d3 e8                	shr    %cl,%eax
  801e7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e81:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e85:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e89:	09 c1                	or     %eax,%ecx
  801e8b:	89 d8                	mov    %ebx,%eax
  801e8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e91:	89 e9                	mov    %ebp,%ecx
  801e93:	d3 e7                	shl    %cl,%edi
  801e95:	89 d1                	mov    %edx,%ecx
  801e97:	d3 e8                	shr    %cl,%eax
  801e99:	89 e9                	mov    %ebp,%ecx
  801e9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e9f:	d3 e3                	shl    %cl,%ebx
  801ea1:	89 c7                	mov    %eax,%edi
  801ea3:	89 d1                	mov    %edx,%ecx
  801ea5:	89 f0                	mov    %esi,%eax
  801ea7:	d3 e8                	shr    %cl,%eax
  801ea9:	89 e9                	mov    %ebp,%ecx
  801eab:	89 fa                	mov    %edi,%edx
  801ead:	d3 e6                	shl    %cl,%esi
  801eaf:	09 d8                	or     %ebx,%eax
  801eb1:	f7 74 24 08          	divl   0x8(%esp)
  801eb5:	89 d1                	mov    %edx,%ecx
  801eb7:	89 f3                	mov    %esi,%ebx
  801eb9:	f7 64 24 0c          	mull   0xc(%esp)
  801ebd:	89 c6                	mov    %eax,%esi
  801ebf:	89 d7                	mov    %edx,%edi
  801ec1:	39 d1                	cmp    %edx,%ecx
  801ec3:	72 06                	jb     801ecb <__umoddi3+0x10b>
  801ec5:	75 10                	jne    801ed7 <__umoddi3+0x117>
  801ec7:	39 c3                	cmp    %eax,%ebx
  801ec9:	73 0c                	jae    801ed7 <__umoddi3+0x117>
  801ecb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801ecf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801ed3:	89 d7                	mov    %edx,%edi
  801ed5:	89 c6                	mov    %eax,%esi
  801ed7:	89 ca                	mov    %ecx,%edx
  801ed9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ede:	29 f3                	sub    %esi,%ebx
  801ee0:	19 fa                	sbb    %edi,%edx
  801ee2:	89 d0                	mov    %edx,%eax
  801ee4:	d3 e0                	shl    %cl,%eax
  801ee6:	89 e9                	mov    %ebp,%ecx
  801ee8:	d3 eb                	shr    %cl,%ebx
  801eea:	d3 ea                	shr    %cl,%edx
  801eec:	09 d8                	or     %ebx,%eax
  801eee:	83 c4 1c             	add    $0x1c,%esp
  801ef1:	5b                   	pop    %ebx
  801ef2:	5e                   	pop    %esi
  801ef3:	5f                   	pop    %edi
  801ef4:	5d                   	pop    %ebp
  801ef5:	c3                   	ret    
  801ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801efd:	8d 76 00             	lea    0x0(%esi),%esi
  801f00:	29 fe                	sub    %edi,%esi
  801f02:	19 c3                	sbb    %eax,%ebx
  801f04:	89 f2                	mov    %esi,%edx
  801f06:	89 d9                	mov    %ebx,%ecx
  801f08:	e9 1d ff ff ff       	jmp    801e2a <__umoddi3+0x6a>
