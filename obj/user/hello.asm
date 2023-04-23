
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 31 00 00 00       	call   800062 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  80003d:	68 80 24 80 00       	push   $0x802480
  800042:	e8 20 01 00 00       	call   800167 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800047:	a1 08 40 80 00       	mov    0x804008,%eax
  80004c:	8b 40 48             	mov    0x48(%eax),%eax
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	50                   	push   %eax
  800053:	68 8e 24 80 00       	push   $0x80248e
  800058:	e8 0a 01 00 00       	call   800167 <cprintf>
}
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	c9                   	leave  
  800061:	c3                   	ret    

00800062 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800062:	f3 0f 1e fb          	endbr32 
  800066:	55                   	push   %ebp
  800067:	89 e5                	mov    %esp,%ebp
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800071:	e8 f7 0a 00 00       	call   800b6d <sys_getenvid>
  800076:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800083:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800088:	85 db                	test   %ebx,%ebx
  80008a:	7e 07                	jle    800093 <libmain+0x31>
		binaryname = argv[0];
  80008c:	8b 06                	mov    (%esi),%eax
  80008e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	e8 96 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009d:	e8 0a 00 00 00       	call   8000ac <exit>
}
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a8:	5b                   	pop    %ebx
  8000a9:	5e                   	pop    %esi
  8000aa:	5d                   	pop    %ebp
  8000ab:	c3                   	ret    

008000ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ac:	f3 0f 1e fb          	endbr32 
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b6:	e8 ac 0f 00 00       	call   801067 <close_all>
	sys_env_destroy(0);
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	6a 00                	push   $0x0
  8000c0:	e8 63 0a 00 00       	call   800b28 <sys_env_destroy>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ca:	f3 0f 1e fb          	endbr32 
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	53                   	push   %ebx
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d8:	8b 13                	mov    (%ebx),%edx
  8000da:	8d 42 01             	lea    0x1(%edx),%eax
  8000dd:	89 03                	mov    %eax,(%ebx)
  8000df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000e2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000eb:	74 09                	je     8000f6 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ed:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	68 ff 00 00 00       	push   $0xff
  8000fe:	8d 43 08             	lea    0x8(%ebx),%eax
  800101:	50                   	push   %eax
  800102:	e8 dc 09 00 00       	call   800ae3 <sys_cputs>
		b->idx = 0;
  800107:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	eb db                	jmp    8000ed <putch+0x23>

00800112 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800112:	f3 0f 1e fb          	endbr32 
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80011f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800126:	00 00 00 
	b.cnt = 0;
  800129:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800130:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800133:	ff 75 0c             	pushl  0xc(%ebp)
  800136:	ff 75 08             	pushl  0x8(%ebp)
  800139:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80013f:	50                   	push   %eax
  800140:	68 ca 00 80 00       	push   $0x8000ca
  800145:	e8 20 01 00 00       	call   80026a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80014a:	83 c4 08             	add    $0x8,%esp
  80014d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800153:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800159:	50                   	push   %eax
  80015a:	e8 84 09 00 00       	call   800ae3 <sys_cputs>

	return b.cnt;
}
  80015f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800167:	f3 0f 1e fb          	endbr32 
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800171:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800174:	50                   	push   %eax
  800175:	ff 75 08             	pushl  0x8(%ebp)
  800178:	e8 95 ff ff ff       	call   800112 <vcprintf>
	va_end(ap);

	return cnt;
}
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    

0080017f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	57                   	push   %edi
  800183:	56                   	push   %esi
  800184:	53                   	push   %ebx
  800185:	83 ec 1c             	sub    $0x1c,%esp
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 d6                	mov    %edx,%esi
  80018c:	8b 45 08             	mov    0x8(%ebp),%eax
  80018f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800192:	89 d1                	mov    %edx,%ecx
  800194:	89 c2                	mov    %eax,%edx
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800199:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ac:	39 c2                	cmp    %eax,%edx
  8001ae:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001b1:	72 3e                	jb     8001f1 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	ff 75 18             	pushl  0x18(%ebp)
  8001b9:	83 eb 01             	sub    $0x1,%ebx
  8001bc:	53                   	push   %ebx
  8001bd:	50                   	push   %eax
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cd:	e8 4e 20 00 00       	call   802220 <__udivdi3>
  8001d2:	83 c4 18             	add    $0x18,%esp
  8001d5:	52                   	push   %edx
  8001d6:	50                   	push   %eax
  8001d7:	89 f2                	mov    %esi,%edx
  8001d9:	89 f8                	mov    %edi,%eax
  8001db:	e8 9f ff ff ff       	call   80017f <printnum>
  8001e0:	83 c4 20             	add    $0x20,%esp
  8001e3:	eb 13                	jmp    8001f8 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	56                   	push   %esi
  8001e9:	ff 75 18             	pushl  0x18(%ebp)
  8001ec:	ff d7                	call   *%edi
  8001ee:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001f1:	83 eb 01             	sub    $0x1,%ebx
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7f ed                	jg     8001e5 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001f8:	83 ec 08             	sub    $0x8,%esp
  8001fb:	56                   	push   %esi
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800202:	ff 75 e0             	pushl  -0x20(%ebp)
  800205:	ff 75 dc             	pushl  -0x24(%ebp)
  800208:	ff 75 d8             	pushl  -0x28(%ebp)
  80020b:	e8 20 21 00 00       	call   802330 <__umoddi3>
  800210:	83 c4 14             	add    $0x14,%esp
  800213:	0f be 80 af 24 80 00 	movsbl 0x8024af(%eax),%eax
  80021a:	50                   	push   %eax
  80021b:	ff d7                	call   *%edi
}
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800223:	5b                   	pop    %ebx
  800224:	5e                   	pop    %esi
  800225:	5f                   	pop    %edi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800228:	f3 0f 1e fb          	endbr32 
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800232:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800236:	8b 10                	mov    (%eax),%edx
  800238:	3b 50 04             	cmp    0x4(%eax),%edx
  80023b:	73 0a                	jae    800247 <sprintputch+0x1f>
		*b->buf++ = ch;
  80023d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800240:	89 08                	mov    %ecx,(%eax)
  800242:	8b 45 08             	mov    0x8(%ebp),%eax
  800245:	88 02                	mov    %al,(%edx)
}
  800247:	5d                   	pop    %ebp
  800248:	c3                   	ret    

00800249 <printfmt>:
{
  800249:	f3 0f 1e fb          	endbr32 
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800253:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800256:	50                   	push   %eax
  800257:	ff 75 10             	pushl  0x10(%ebp)
  80025a:	ff 75 0c             	pushl  0xc(%ebp)
  80025d:	ff 75 08             	pushl  0x8(%ebp)
  800260:	e8 05 00 00 00       	call   80026a <vprintfmt>
}
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <vprintfmt>:
{
  80026a:	f3 0f 1e fb          	endbr32 
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	57                   	push   %edi
  800272:	56                   	push   %esi
  800273:	53                   	push   %ebx
  800274:	83 ec 3c             	sub    $0x3c,%esp
  800277:	8b 75 08             	mov    0x8(%ebp),%esi
  80027a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80027d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800280:	e9 8e 03 00 00       	jmp    800613 <vprintfmt+0x3a9>
		padc = ' ';
  800285:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800289:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800290:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800297:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80029e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a3:	8d 47 01             	lea    0x1(%edi),%eax
  8002a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002a9:	0f b6 17             	movzbl (%edi),%edx
  8002ac:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002af:	3c 55                	cmp    $0x55,%al
  8002b1:	0f 87 df 03 00 00    	ja     800696 <vprintfmt+0x42c>
  8002b7:	0f b6 c0             	movzbl %al,%eax
  8002ba:	3e ff 24 85 00 26 80 	notrack jmp *0x802600(,%eax,4)
  8002c1:	00 
  8002c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002c5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002c9:	eb d8                	jmp    8002a3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002ce:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002d2:	eb cf                	jmp    8002a3 <vprintfmt+0x39>
  8002d4:	0f b6 d2             	movzbl %dl,%edx
  8002d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002da:	b8 00 00 00 00       	mov    $0x0,%eax
  8002df:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002e2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002e9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002ec:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002ef:	83 f9 09             	cmp    $0x9,%ecx
  8002f2:	77 55                	ja     800349 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8002f4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002f7:	eb e9                	jmp    8002e2 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	8b 00                	mov    (%eax),%eax
  8002fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800301:	8b 45 14             	mov    0x14(%ebp),%eax
  800304:	8d 40 04             	lea    0x4(%eax),%eax
  800307:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80030d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800311:	79 90                	jns    8002a3 <vprintfmt+0x39>
				width = precision, precision = -1;
  800313:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800316:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800319:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800320:	eb 81                	jmp    8002a3 <vprintfmt+0x39>
  800322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800325:	85 c0                	test   %eax,%eax
  800327:	ba 00 00 00 00       	mov    $0x0,%edx
  80032c:	0f 49 d0             	cmovns %eax,%edx
  80032f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800335:	e9 69 ff ff ff       	jmp    8002a3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80033d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800344:	e9 5a ff ff ff       	jmp    8002a3 <vprintfmt+0x39>
  800349:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80034c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034f:	eb bc                	jmp    80030d <vprintfmt+0xa3>
			lflag++;
  800351:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800354:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800357:	e9 47 ff ff ff       	jmp    8002a3 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80035c:	8b 45 14             	mov    0x14(%ebp),%eax
  80035f:	8d 78 04             	lea    0x4(%eax),%edi
  800362:	83 ec 08             	sub    $0x8,%esp
  800365:	53                   	push   %ebx
  800366:	ff 30                	pushl  (%eax)
  800368:	ff d6                	call   *%esi
			break;
  80036a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80036d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800370:	e9 9b 02 00 00       	jmp    800610 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800375:	8b 45 14             	mov    0x14(%ebp),%eax
  800378:	8d 78 04             	lea    0x4(%eax),%edi
  80037b:	8b 00                	mov    (%eax),%eax
  80037d:	99                   	cltd   
  80037e:	31 d0                	xor    %edx,%eax
  800380:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800382:	83 f8 0f             	cmp    $0xf,%eax
  800385:	7f 23                	jg     8003aa <vprintfmt+0x140>
  800387:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  80038e:	85 d2                	test   %edx,%edx
  800390:	74 18                	je     8003aa <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800392:	52                   	push   %edx
  800393:	68 95 28 80 00       	push   $0x802895
  800398:	53                   	push   %ebx
  800399:	56                   	push   %esi
  80039a:	e8 aa fe ff ff       	call   800249 <printfmt>
  80039f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a5:	e9 66 02 00 00       	jmp    800610 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003aa:	50                   	push   %eax
  8003ab:	68 c7 24 80 00       	push   $0x8024c7
  8003b0:	53                   	push   %ebx
  8003b1:	56                   	push   %esi
  8003b2:	e8 92 fe ff ff       	call   800249 <printfmt>
  8003b7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ba:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003bd:	e9 4e 02 00 00       	jmp    800610 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c5:	83 c0 04             	add    $0x4,%eax
  8003c8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ce:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003d0:	85 d2                	test   %edx,%edx
  8003d2:	b8 c0 24 80 00       	mov    $0x8024c0,%eax
  8003d7:	0f 45 c2             	cmovne %edx,%eax
  8003da:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e1:	7e 06                	jle    8003e9 <vprintfmt+0x17f>
  8003e3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003e7:	75 0d                	jne    8003f6 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ec:	89 c7                	mov    %eax,%edi
  8003ee:	03 45 e0             	add    -0x20(%ebp),%eax
  8003f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f4:	eb 55                	jmp    80044b <vprintfmt+0x1e1>
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8003fc:	ff 75 cc             	pushl  -0x34(%ebp)
  8003ff:	e8 46 03 00 00       	call   80074a <strnlen>
  800404:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800407:	29 c2                	sub    %eax,%edx
  800409:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80040c:	83 c4 10             	add    $0x10,%esp
  80040f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800411:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800415:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800418:	85 ff                	test   %edi,%edi
  80041a:	7e 11                	jle    80042d <vprintfmt+0x1c3>
					putch(padc, putdat);
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	53                   	push   %ebx
  800420:	ff 75 e0             	pushl  -0x20(%ebp)
  800423:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800425:	83 ef 01             	sub    $0x1,%edi
  800428:	83 c4 10             	add    $0x10,%esp
  80042b:	eb eb                	jmp    800418 <vprintfmt+0x1ae>
  80042d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800430:	85 d2                	test   %edx,%edx
  800432:	b8 00 00 00 00       	mov    $0x0,%eax
  800437:	0f 49 c2             	cmovns %edx,%eax
  80043a:	29 c2                	sub    %eax,%edx
  80043c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80043f:	eb a8                	jmp    8003e9 <vprintfmt+0x17f>
					putch(ch, putdat);
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	53                   	push   %ebx
  800445:	52                   	push   %edx
  800446:	ff d6                	call   *%esi
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80044e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800450:	83 c7 01             	add    $0x1,%edi
  800453:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800457:	0f be d0             	movsbl %al,%edx
  80045a:	85 d2                	test   %edx,%edx
  80045c:	74 4b                	je     8004a9 <vprintfmt+0x23f>
  80045e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800462:	78 06                	js     80046a <vprintfmt+0x200>
  800464:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800468:	78 1e                	js     800488 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80046a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80046e:	74 d1                	je     800441 <vprintfmt+0x1d7>
  800470:	0f be c0             	movsbl %al,%eax
  800473:	83 e8 20             	sub    $0x20,%eax
  800476:	83 f8 5e             	cmp    $0x5e,%eax
  800479:	76 c6                	jbe    800441 <vprintfmt+0x1d7>
					putch('?', putdat);
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	53                   	push   %ebx
  80047f:	6a 3f                	push   $0x3f
  800481:	ff d6                	call   *%esi
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	eb c3                	jmp    80044b <vprintfmt+0x1e1>
  800488:	89 cf                	mov    %ecx,%edi
  80048a:	eb 0e                	jmp    80049a <vprintfmt+0x230>
				putch(' ', putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	53                   	push   %ebx
  800490:	6a 20                	push   $0x20
  800492:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800494:	83 ef 01             	sub    $0x1,%edi
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	85 ff                	test   %edi,%edi
  80049c:	7f ee                	jg     80048c <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80049e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a4:	e9 67 01 00 00       	jmp    800610 <vprintfmt+0x3a6>
  8004a9:	89 cf                	mov    %ecx,%edi
  8004ab:	eb ed                	jmp    80049a <vprintfmt+0x230>
	if (lflag >= 2)
  8004ad:	83 f9 01             	cmp    $0x1,%ecx
  8004b0:	7f 1b                	jg     8004cd <vprintfmt+0x263>
	else if (lflag)
  8004b2:	85 c9                	test   %ecx,%ecx
  8004b4:	74 63                	je     800519 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004be:	99                   	cltd   
  8004bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c5:	8d 40 04             	lea    0x4(%eax),%eax
  8004c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cb:	eb 17                	jmp    8004e4 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	8b 50 04             	mov    0x4(%eax),%edx
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 40 08             	lea    0x8(%eax),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004ea:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8004ef:	85 c9                	test   %ecx,%ecx
  8004f1:	0f 89 ff 00 00 00    	jns    8005f6 <vprintfmt+0x38c>
				putch('-', putdat);
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	53                   	push   %ebx
  8004fb:	6a 2d                	push   $0x2d
  8004fd:	ff d6                	call   *%esi
				num = -(long long) num;
  8004ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800502:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800505:	f7 da                	neg    %edx
  800507:	83 d1 00             	adc    $0x0,%ecx
  80050a:	f7 d9                	neg    %ecx
  80050c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80050f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800514:	e9 dd 00 00 00       	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800521:	99                   	cltd   
  800522:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800525:	8b 45 14             	mov    0x14(%ebp),%eax
  800528:	8d 40 04             	lea    0x4(%eax),%eax
  80052b:	89 45 14             	mov    %eax,0x14(%ebp)
  80052e:	eb b4                	jmp    8004e4 <vprintfmt+0x27a>
	if (lflag >= 2)
  800530:	83 f9 01             	cmp    $0x1,%ecx
  800533:	7f 1e                	jg     800553 <vprintfmt+0x2e9>
	else if (lflag)
  800535:	85 c9                	test   %ecx,%ecx
  800537:	74 32                	je     80056b <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800539:	8b 45 14             	mov    0x14(%ebp),%eax
  80053c:	8b 10                	mov    (%eax),%edx
  80053e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800543:	8d 40 04             	lea    0x4(%eax),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800549:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80054e:	e9 a3 00 00 00       	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 10                	mov    (%eax),%edx
  800558:	8b 48 04             	mov    0x4(%eax),%ecx
  80055b:	8d 40 08             	lea    0x8(%eax),%eax
  80055e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800561:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800566:	e9 8b 00 00 00       	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8b 10                	mov    (%eax),%edx
  800570:	b9 00 00 00 00       	mov    $0x0,%ecx
  800575:	8d 40 04             	lea    0x4(%eax),%eax
  800578:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800580:	eb 74                	jmp    8005f6 <vprintfmt+0x38c>
	if (lflag >= 2)
  800582:	83 f9 01             	cmp    $0x1,%ecx
  800585:	7f 1b                	jg     8005a2 <vprintfmt+0x338>
	else if (lflag)
  800587:	85 c9                	test   %ecx,%ecx
  800589:	74 2c                	je     8005b7 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80058b:	8b 45 14             	mov    0x14(%ebp),%eax
  80058e:	8b 10                	mov    (%eax),%edx
  800590:	b9 00 00 00 00       	mov    $0x0,%ecx
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80059b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005a0:	eb 54                	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8b 10                	mov    (%eax),%edx
  8005a7:	8b 48 04             	mov    0x4(%eax),%ecx
  8005aa:	8d 40 08             	lea    0x8(%eax),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005b5:	eb 3f                	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 10                	mov    (%eax),%edx
  8005bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c1:	8d 40 04             	lea    0x4(%eax),%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005cc:	eb 28                	jmp    8005f6 <vprintfmt+0x38c>
			putch('0', putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	53                   	push   %ebx
  8005d2:	6a 30                	push   $0x30
  8005d4:	ff d6                	call   *%esi
			putch('x', putdat);
  8005d6:	83 c4 08             	add    $0x8,%esp
  8005d9:	53                   	push   %ebx
  8005da:	6a 78                	push   $0x78
  8005dc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005e8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005eb:	8d 40 04             	lea    0x4(%eax),%eax
  8005ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005f1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005f6:	83 ec 0c             	sub    $0xc,%esp
  8005f9:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005fd:	57                   	push   %edi
  8005fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800601:	50                   	push   %eax
  800602:	51                   	push   %ecx
  800603:	52                   	push   %edx
  800604:	89 da                	mov    %ebx,%edx
  800606:	89 f0                	mov    %esi,%eax
  800608:	e8 72 fb ff ff       	call   80017f <printnum>
			break;
  80060d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800610:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800613:	83 c7 01             	add    $0x1,%edi
  800616:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061a:	83 f8 25             	cmp    $0x25,%eax
  80061d:	0f 84 62 fc ff ff    	je     800285 <vprintfmt+0x1b>
			if (ch == '\0')
  800623:	85 c0                	test   %eax,%eax
  800625:	0f 84 8b 00 00 00    	je     8006b6 <vprintfmt+0x44c>
			putch(ch, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	53                   	push   %ebx
  80062f:	50                   	push   %eax
  800630:	ff d6                	call   *%esi
  800632:	83 c4 10             	add    $0x10,%esp
  800635:	eb dc                	jmp    800613 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800637:	83 f9 01             	cmp    $0x1,%ecx
  80063a:	7f 1b                	jg     800657 <vprintfmt+0x3ed>
	else if (lflag)
  80063c:	85 c9                	test   %ecx,%ecx
  80063e:	74 2c                	je     80066c <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8b 10                	mov    (%eax),%edx
  800645:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064a:	8d 40 04             	lea    0x4(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800650:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800655:	eb 9f                	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 10                	mov    (%eax),%edx
  80065c:	8b 48 04             	mov    0x4(%eax),%ecx
  80065f:	8d 40 08             	lea    0x8(%eax),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800665:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80066a:	eb 8a                	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 10                	mov    (%eax),%edx
  800671:	b9 00 00 00 00       	mov    $0x0,%ecx
  800676:	8d 40 04             	lea    0x4(%eax),%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800681:	e9 70 ff ff ff       	jmp    8005f6 <vprintfmt+0x38c>
			putch(ch, putdat);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	53                   	push   %ebx
  80068a:	6a 25                	push   $0x25
  80068c:	ff d6                	call   *%esi
			break;
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	e9 7a ff ff ff       	jmp    800610 <vprintfmt+0x3a6>
			putch('%', putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 25                	push   $0x25
  80069c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 f8                	mov    %edi,%eax
  8006a3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006a7:	74 05                	je     8006ae <vprintfmt+0x444>
  8006a9:	83 e8 01             	sub    $0x1,%eax
  8006ac:	eb f5                	jmp    8006a3 <vprintfmt+0x439>
  8006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b1:	e9 5a ff ff ff       	jmp    800610 <vprintfmt+0x3a6>
}
  8006b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b9:	5b                   	pop    %ebx
  8006ba:	5e                   	pop    %esi
  8006bb:	5f                   	pop    %edi
  8006bc:	5d                   	pop    %ebp
  8006bd:	c3                   	ret    

008006be <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006be:	f3 0f 1e fb          	endbr32 
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	83 ec 18             	sub    $0x18,%esp
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006d1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006df:	85 c0                	test   %eax,%eax
  8006e1:	74 26                	je     800709 <vsnprintf+0x4b>
  8006e3:	85 d2                	test   %edx,%edx
  8006e5:	7e 22                	jle    800709 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e7:	ff 75 14             	pushl  0x14(%ebp)
  8006ea:	ff 75 10             	pushl  0x10(%ebp)
  8006ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f0:	50                   	push   %eax
  8006f1:	68 28 02 80 00       	push   $0x800228
  8006f6:	e8 6f fb ff ff       	call   80026a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800704:	83 c4 10             	add    $0x10,%esp
}
  800707:	c9                   	leave  
  800708:	c3                   	ret    
		return -E_INVAL;
  800709:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070e:	eb f7                	jmp    800707 <vsnprintf+0x49>

00800710 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800710:	f3 0f 1e fb          	endbr32 
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80071a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80071d:	50                   	push   %eax
  80071e:	ff 75 10             	pushl  0x10(%ebp)
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	e8 92 ff ff ff       	call   8006be <vsnprintf>
	va_end(ap);

	return rc;
}
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    

0080072e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80072e:	f3 0f 1e fb          	endbr32 
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800738:	b8 00 00 00 00       	mov    $0x0,%eax
  80073d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800741:	74 05                	je     800748 <strlen+0x1a>
		n++;
  800743:	83 c0 01             	add    $0x1,%eax
  800746:	eb f5                	jmp    80073d <strlen+0xf>
	return n;
}
  800748:	5d                   	pop    %ebp
  800749:	c3                   	ret    

0080074a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80074a:	f3 0f 1e fb          	endbr32 
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800754:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800757:	b8 00 00 00 00       	mov    $0x0,%eax
  80075c:	39 d0                	cmp    %edx,%eax
  80075e:	74 0d                	je     80076d <strnlen+0x23>
  800760:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800764:	74 05                	je     80076b <strnlen+0x21>
		n++;
  800766:	83 c0 01             	add    $0x1,%eax
  800769:	eb f1                	jmp    80075c <strnlen+0x12>
  80076b:	89 c2                	mov    %eax,%edx
	return n;
}
  80076d:	89 d0                	mov    %edx,%eax
  80076f:	5d                   	pop    %ebp
  800770:	c3                   	ret    

00800771 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800771:	f3 0f 1e fb          	endbr32 
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	53                   	push   %ebx
  800779:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80077c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80077f:	b8 00 00 00 00       	mov    $0x0,%eax
  800784:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800788:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80078b:	83 c0 01             	add    $0x1,%eax
  80078e:	84 d2                	test   %dl,%dl
  800790:	75 f2                	jne    800784 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800792:	89 c8                	mov    %ecx,%eax
  800794:	5b                   	pop    %ebx
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800797:	f3 0f 1e fb          	endbr32 
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	83 ec 10             	sub    $0x10,%esp
  8007a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a5:	53                   	push   %ebx
  8007a6:	e8 83 ff ff ff       	call   80072e <strlen>
  8007ab:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	01 d8                	add    %ebx,%eax
  8007b3:	50                   	push   %eax
  8007b4:	e8 b8 ff ff ff       	call   800771 <strcpy>
	return dst;
}
  8007b9:	89 d8                	mov    %ebx,%eax
  8007bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007c0:	f3 0f 1e fb          	endbr32 
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
  8007c7:	56                   	push   %esi
  8007c8:	53                   	push   %ebx
  8007c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8007cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cf:	89 f3                	mov    %esi,%ebx
  8007d1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007d4:	89 f0                	mov    %esi,%eax
  8007d6:	39 d8                	cmp    %ebx,%eax
  8007d8:	74 11                	je     8007eb <strncpy+0x2b>
		*dst++ = *src;
  8007da:	83 c0 01             	add    $0x1,%eax
  8007dd:	0f b6 0a             	movzbl (%edx),%ecx
  8007e0:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007e3:	80 f9 01             	cmp    $0x1,%cl
  8007e6:	83 da ff             	sbb    $0xffffffff,%edx
  8007e9:	eb eb                	jmp    8007d6 <strncpy+0x16>
	}
	return ret;
}
  8007eb:	89 f0                	mov    %esi,%eax
  8007ed:	5b                   	pop    %ebx
  8007ee:	5e                   	pop    %esi
  8007ef:	5d                   	pop    %ebp
  8007f0:	c3                   	ret    

008007f1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007f1:	f3 0f 1e fb          	endbr32 
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	56                   	push   %esi
  8007f9:	53                   	push   %ebx
  8007fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8007fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800800:	8b 55 10             	mov    0x10(%ebp),%edx
  800803:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800805:	85 d2                	test   %edx,%edx
  800807:	74 21                	je     80082a <strlcpy+0x39>
  800809:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80080d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80080f:	39 c2                	cmp    %eax,%edx
  800811:	74 14                	je     800827 <strlcpy+0x36>
  800813:	0f b6 19             	movzbl (%ecx),%ebx
  800816:	84 db                	test   %bl,%bl
  800818:	74 0b                	je     800825 <strlcpy+0x34>
			*dst++ = *src++;
  80081a:	83 c1 01             	add    $0x1,%ecx
  80081d:	83 c2 01             	add    $0x1,%edx
  800820:	88 5a ff             	mov    %bl,-0x1(%edx)
  800823:	eb ea                	jmp    80080f <strlcpy+0x1e>
  800825:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800827:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80082a:	29 f0                	sub    %esi,%eax
}
  80082c:	5b                   	pop    %ebx
  80082d:	5e                   	pop    %esi
  80082e:	5d                   	pop    %ebp
  80082f:	c3                   	ret    

00800830 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800830:	f3 0f 1e fb          	endbr32 
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80083d:	0f b6 01             	movzbl (%ecx),%eax
  800840:	84 c0                	test   %al,%al
  800842:	74 0c                	je     800850 <strcmp+0x20>
  800844:	3a 02                	cmp    (%edx),%al
  800846:	75 08                	jne    800850 <strcmp+0x20>
		p++, q++;
  800848:	83 c1 01             	add    $0x1,%ecx
  80084b:	83 c2 01             	add    $0x1,%edx
  80084e:	eb ed                	jmp    80083d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800850:	0f b6 c0             	movzbl %al,%eax
  800853:	0f b6 12             	movzbl (%edx),%edx
  800856:	29 d0                	sub    %edx,%eax
}
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80085a:	f3 0f 1e fb          	endbr32 
  80085e:	55                   	push   %ebp
  80085f:	89 e5                	mov    %esp,%ebp
  800861:	53                   	push   %ebx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	8b 55 0c             	mov    0xc(%ebp),%edx
  800868:	89 c3                	mov    %eax,%ebx
  80086a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80086d:	eb 06                	jmp    800875 <strncmp+0x1b>
		n--, p++, q++;
  80086f:	83 c0 01             	add    $0x1,%eax
  800872:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800875:	39 d8                	cmp    %ebx,%eax
  800877:	74 16                	je     80088f <strncmp+0x35>
  800879:	0f b6 08             	movzbl (%eax),%ecx
  80087c:	84 c9                	test   %cl,%cl
  80087e:	74 04                	je     800884 <strncmp+0x2a>
  800880:	3a 0a                	cmp    (%edx),%cl
  800882:	74 eb                	je     80086f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800884:	0f b6 00             	movzbl (%eax),%eax
  800887:	0f b6 12             	movzbl (%edx),%edx
  80088a:	29 d0                	sub    %edx,%eax
}
  80088c:	5b                   	pop    %ebx
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    
		return 0;
  80088f:	b8 00 00 00 00       	mov    $0x0,%eax
  800894:	eb f6                	jmp    80088c <strncmp+0x32>

00800896 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800896:	f3 0f 1e fb          	endbr32 
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a4:	0f b6 10             	movzbl (%eax),%edx
  8008a7:	84 d2                	test   %dl,%dl
  8008a9:	74 09                	je     8008b4 <strchr+0x1e>
		if (*s == c)
  8008ab:	38 ca                	cmp    %cl,%dl
  8008ad:	74 0a                	je     8008b9 <strchr+0x23>
	for (; *s; s++)
  8008af:	83 c0 01             	add    $0x1,%eax
  8008b2:	eb f0                	jmp    8008a4 <strchr+0xe>
			return (char *) s;
	return 0;
  8008b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008bb:	f3 0f 1e fb          	endbr32 
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008cc:	38 ca                	cmp    %cl,%dl
  8008ce:	74 09                	je     8008d9 <strfind+0x1e>
  8008d0:	84 d2                	test   %dl,%dl
  8008d2:	74 05                	je     8008d9 <strfind+0x1e>
	for (; *s; s++)
  8008d4:	83 c0 01             	add    $0x1,%eax
  8008d7:	eb f0                	jmp    8008c9 <strfind+0xe>
			break;
	return (char *) s;
}
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008db:	f3 0f 1e fb          	endbr32 
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	57                   	push   %edi
  8008e3:	56                   	push   %esi
  8008e4:	53                   	push   %ebx
  8008e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008eb:	85 c9                	test   %ecx,%ecx
  8008ed:	74 31                	je     800920 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008ef:	89 f8                	mov    %edi,%eax
  8008f1:	09 c8                	or     %ecx,%eax
  8008f3:	a8 03                	test   $0x3,%al
  8008f5:	75 23                	jne    80091a <memset+0x3f>
		c &= 0xFF;
  8008f7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008fb:	89 d3                	mov    %edx,%ebx
  8008fd:	c1 e3 08             	shl    $0x8,%ebx
  800900:	89 d0                	mov    %edx,%eax
  800902:	c1 e0 18             	shl    $0x18,%eax
  800905:	89 d6                	mov    %edx,%esi
  800907:	c1 e6 10             	shl    $0x10,%esi
  80090a:	09 f0                	or     %esi,%eax
  80090c:	09 c2                	or     %eax,%edx
  80090e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800910:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800913:	89 d0                	mov    %edx,%eax
  800915:	fc                   	cld    
  800916:	f3 ab                	rep stos %eax,%es:(%edi)
  800918:	eb 06                	jmp    800920 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80091a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091d:	fc                   	cld    
  80091e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800920:	89 f8                	mov    %edi,%eax
  800922:	5b                   	pop    %ebx
  800923:	5e                   	pop    %esi
  800924:	5f                   	pop    %edi
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800927:	f3 0f 1e fb          	endbr32 
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	57                   	push   %edi
  80092f:	56                   	push   %esi
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 75 0c             	mov    0xc(%ebp),%esi
  800936:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800939:	39 c6                	cmp    %eax,%esi
  80093b:	73 32                	jae    80096f <memmove+0x48>
  80093d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800940:	39 c2                	cmp    %eax,%edx
  800942:	76 2b                	jbe    80096f <memmove+0x48>
		s += n;
		d += n;
  800944:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800947:	89 fe                	mov    %edi,%esi
  800949:	09 ce                	or     %ecx,%esi
  80094b:	09 d6                	or     %edx,%esi
  80094d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800953:	75 0e                	jne    800963 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800955:	83 ef 04             	sub    $0x4,%edi
  800958:	8d 72 fc             	lea    -0x4(%edx),%esi
  80095b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80095e:	fd                   	std    
  80095f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800961:	eb 09                	jmp    80096c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800963:	83 ef 01             	sub    $0x1,%edi
  800966:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800969:	fd                   	std    
  80096a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80096c:	fc                   	cld    
  80096d:	eb 1a                	jmp    800989 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096f:	89 c2                	mov    %eax,%edx
  800971:	09 ca                	or     %ecx,%edx
  800973:	09 f2                	or     %esi,%edx
  800975:	f6 c2 03             	test   $0x3,%dl
  800978:	75 0a                	jne    800984 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80097a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80097d:	89 c7                	mov    %eax,%edi
  80097f:	fc                   	cld    
  800980:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800982:	eb 05                	jmp    800989 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800984:	89 c7                	mov    %eax,%edi
  800986:	fc                   	cld    
  800987:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800989:	5e                   	pop    %esi
  80098a:	5f                   	pop    %edi
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80098d:	f3 0f 1e fb          	endbr32 
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800997:	ff 75 10             	pushl  0x10(%ebp)
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	ff 75 08             	pushl  0x8(%ebp)
  8009a0:	e8 82 ff ff ff       	call   800927 <memmove>
}
  8009a5:	c9                   	leave  
  8009a6:	c3                   	ret    

008009a7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009a7:	f3 0f 1e fb          	endbr32 
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	56                   	push   %esi
  8009af:	53                   	push   %ebx
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b6:	89 c6                	mov    %eax,%esi
  8009b8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009bb:	39 f0                	cmp    %esi,%eax
  8009bd:	74 1c                	je     8009db <memcmp+0x34>
		if (*s1 != *s2)
  8009bf:	0f b6 08             	movzbl (%eax),%ecx
  8009c2:	0f b6 1a             	movzbl (%edx),%ebx
  8009c5:	38 d9                	cmp    %bl,%cl
  8009c7:	75 08                	jne    8009d1 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009c9:	83 c0 01             	add    $0x1,%eax
  8009cc:	83 c2 01             	add    $0x1,%edx
  8009cf:	eb ea                	jmp    8009bb <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009d1:	0f b6 c1             	movzbl %cl,%eax
  8009d4:	0f b6 db             	movzbl %bl,%ebx
  8009d7:	29 d8                	sub    %ebx,%eax
  8009d9:	eb 05                	jmp    8009e0 <memcmp+0x39>
	}

	return 0;
  8009db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5e                   	pop    %esi
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009e4:	f3 0f 1e fb          	endbr32 
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009f1:	89 c2                	mov    %eax,%edx
  8009f3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009f6:	39 d0                	cmp    %edx,%eax
  8009f8:	73 09                	jae    800a03 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009fa:	38 08                	cmp    %cl,(%eax)
  8009fc:	74 05                	je     800a03 <memfind+0x1f>
	for (; s < ends; s++)
  8009fe:	83 c0 01             	add    $0x1,%eax
  800a01:	eb f3                	jmp    8009f6 <memfind+0x12>
			break;
	return (void *) s;
}
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a05:	f3 0f 1e fb          	endbr32 
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	57                   	push   %edi
  800a0d:	56                   	push   %esi
  800a0e:	53                   	push   %ebx
  800a0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a12:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a15:	eb 03                	jmp    800a1a <strtol+0x15>
		s++;
  800a17:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a1a:	0f b6 01             	movzbl (%ecx),%eax
  800a1d:	3c 20                	cmp    $0x20,%al
  800a1f:	74 f6                	je     800a17 <strtol+0x12>
  800a21:	3c 09                	cmp    $0x9,%al
  800a23:	74 f2                	je     800a17 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a25:	3c 2b                	cmp    $0x2b,%al
  800a27:	74 2a                	je     800a53 <strtol+0x4e>
	int neg = 0;
  800a29:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a2e:	3c 2d                	cmp    $0x2d,%al
  800a30:	74 2b                	je     800a5d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a32:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a38:	75 0f                	jne    800a49 <strtol+0x44>
  800a3a:	80 39 30             	cmpb   $0x30,(%ecx)
  800a3d:	74 28                	je     800a67 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a3f:	85 db                	test   %ebx,%ebx
  800a41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a46:	0f 44 d8             	cmove  %eax,%ebx
  800a49:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a51:	eb 46                	jmp    800a99 <strtol+0x94>
		s++;
  800a53:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a56:	bf 00 00 00 00       	mov    $0x0,%edi
  800a5b:	eb d5                	jmp    800a32 <strtol+0x2d>
		s++, neg = 1;
  800a5d:	83 c1 01             	add    $0x1,%ecx
  800a60:	bf 01 00 00 00       	mov    $0x1,%edi
  800a65:	eb cb                	jmp    800a32 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a67:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a6b:	74 0e                	je     800a7b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a6d:	85 db                	test   %ebx,%ebx
  800a6f:	75 d8                	jne    800a49 <strtol+0x44>
		s++, base = 8;
  800a71:	83 c1 01             	add    $0x1,%ecx
  800a74:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a79:	eb ce                	jmp    800a49 <strtol+0x44>
		s += 2, base = 16;
  800a7b:	83 c1 02             	add    $0x2,%ecx
  800a7e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a83:	eb c4                	jmp    800a49 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a85:	0f be d2             	movsbl %dl,%edx
  800a88:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a8b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a8e:	7d 3a                	jge    800aca <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a90:	83 c1 01             	add    $0x1,%ecx
  800a93:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a97:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a99:	0f b6 11             	movzbl (%ecx),%edx
  800a9c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a9f:	89 f3                	mov    %esi,%ebx
  800aa1:	80 fb 09             	cmp    $0x9,%bl
  800aa4:	76 df                	jbe    800a85 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800aa6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aa9:	89 f3                	mov    %esi,%ebx
  800aab:	80 fb 19             	cmp    $0x19,%bl
  800aae:	77 08                	ja     800ab8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ab0:	0f be d2             	movsbl %dl,%edx
  800ab3:	83 ea 57             	sub    $0x57,%edx
  800ab6:	eb d3                	jmp    800a8b <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ab8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800abb:	89 f3                	mov    %esi,%ebx
  800abd:	80 fb 19             	cmp    $0x19,%bl
  800ac0:	77 08                	ja     800aca <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ac2:	0f be d2             	movsbl %dl,%edx
  800ac5:	83 ea 37             	sub    $0x37,%edx
  800ac8:	eb c1                	jmp    800a8b <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ace:	74 05                	je     800ad5 <strtol+0xd0>
		*endptr = (char *) s;
  800ad0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	f7 da                	neg    %edx
  800ad9:	85 ff                	test   %edi,%edi
  800adb:	0f 45 c2             	cmovne %edx,%eax
}
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5f                   	pop    %edi
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ae3:	f3 0f 1e fb          	endbr32 
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	57                   	push   %edi
  800aeb:	56                   	push   %esi
  800aec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
  800af2:	8b 55 08             	mov    0x8(%ebp),%edx
  800af5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af8:	89 c3                	mov    %eax,%ebx
  800afa:	89 c7                	mov    %eax,%edi
  800afc:	89 c6                	mov    %eax,%esi
  800afe:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b00:	5b                   	pop    %ebx
  800b01:	5e                   	pop    %esi
  800b02:	5f                   	pop    %edi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b05:	f3 0f 1e fb          	endbr32 
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	57                   	push   %edi
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b14:	b8 01 00 00 00       	mov    $0x1,%eax
  800b19:	89 d1                	mov    %edx,%ecx
  800b1b:	89 d3                	mov    %edx,%ebx
  800b1d:	89 d7                	mov    %edx,%edi
  800b1f:	89 d6                	mov    %edx,%esi
  800b21:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b23:	5b                   	pop    %ebx
  800b24:	5e                   	pop    %esi
  800b25:	5f                   	pop    %edi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b28:	f3 0f 1e fb          	endbr32 
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	57                   	push   %edi
  800b30:	56                   	push   %esi
  800b31:	53                   	push   %ebx
  800b32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b35:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b42:	89 cb                	mov    %ecx,%ebx
  800b44:	89 cf                	mov    %ecx,%edi
  800b46:	89 ce                	mov    %ecx,%esi
  800b48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b4a:	85 c0                	test   %eax,%eax
  800b4c:	7f 08                	jg     800b56 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5f                   	pop    %edi
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	50                   	push   %eax
  800b5a:	6a 03                	push   $0x3
  800b5c:	68 bf 27 80 00       	push   $0x8027bf
  800b61:	6a 23                	push   $0x23
  800b63:	68 dc 27 80 00       	push   $0x8027dc
  800b68:	e8 08 15 00 00       	call   802075 <_panic>

00800b6d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b6d:	f3 0f 1e fb          	endbr32 
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	57                   	push   %edi
  800b75:	56                   	push   %esi
  800b76:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b77:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7c:	b8 02 00 00 00       	mov    $0x2,%eax
  800b81:	89 d1                	mov    %edx,%ecx
  800b83:	89 d3                	mov    %edx,%ebx
  800b85:	89 d7                	mov    %edx,%edi
  800b87:	89 d6                	mov    %edx,%esi
  800b89:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b8b:	5b                   	pop    %ebx
  800b8c:	5e                   	pop    %esi
  800b8d:	5f                   	pop    %edi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <sys_yield>:

void
sys_yield(void)
{
  800b90:	f3 0f 1e fb          	endbr32 
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ba4:	89 d1                	mov    %edx,%ecx
  800ba6:	89 d3                	mov    %edx,%ebx
  800ba8:	89 d7                	mov    %edx,%edi
  800baa:	89 d6                	mov    %edx,%esi
  800bac:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5f                   	pop    %edi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb3:	f3 0f 1e fb          	endbr32 
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	57                   	push   %edi
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc0:	be 00 00 00 00       	mov    $0x0,%esi
  800bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcb:	b8 04 00 00 00       	mov    $0x4,%eax
  800bd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bd3:	89 f7                	mov    %esi,%edi
  800bd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd7:	85 c0                	test   %eax,%eax
  800bd9:	7f 08                	jg     800be3 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be3:	83 ec 0c             	sub    $0xc,%esp
  800be6:	50                   	push   %eax
  800be7:	6a 04                	push   $0x4
  800be9:	68 bf 27 80 00       	push   $0x8027bf
  800bee:	6a 23                	push   $0x23
  800bf0:	68 dc 27 80 00       	push   $0x8027dc
  800bf5:	e8 7b 14 00 00       	call   802075 <_panic>

00800bfa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bfa:	f3 0f 1e fb          	endbr32 
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c07:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0d:	b8 05 00 00 00       	mov    $0x5,%eax
  800c12:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c15:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c18:	8b 75 18             	mov    0x18(%ebp),%esi
  800c1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	7f 08                	jg     800c29 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c24:	5b                   	pop    %ebx
  800c25:	5e                   	pop    %esi
  800c26:	5f                   	pop    %edi
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c29:	83 ec 0c             	sub    $0xc,%esp
  800c2c:	50                   	push   %eax
  800c2d:	6a 05                	push   $0x5
  800c2f:	68 bf 27 80 00       	push   $0x8027bf
  800c34:	6a 23                	push   $0x23
  800c36:	68 dc 27 80 00       	push   $0x8027dc
  800c3b:	e8 35 14 00 00       	call   802075 <_panic>

00800c40 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c40:	f3 0f 1e fb          	endbr32 
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c58:	b8 06 00 00 00       	mov    $0x6,%eax
  800c5d:	89 df                	mov    %ebx,%edi
  800c5f:	89 de                	mov    %ebx,%esi
  800c61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c63:	85 c0                	test   %eax,%eax
  800c65:	7f 08                	jg     800c6f <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6a:	5b                   	pop    %ebx
  800c6b:	5e                   	pop    %esi
  800c6c:	5f                   	pop    %edi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6f:	83 ec 0c             	sub    $0xc,%esp
  800c72:	50                   	push   %eax
  800c73:	6a 06                	push   $0x6
  800c75:	68 bf 27 80 00       	push   $0x8027bf
  800c7a:	6a 23                	push   $0x23
  800c7c:	68 dc 27 80 00       	push   $0x8027dc
  800c81:	e8 ef 13 00 00       	call   802075 <_panic>

00800c86 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c86:	f3 0f 1e fb          	endbr32 
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9e:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca3:	89 df                	mov    %ebx,%edi
  800ca5:	89 de                	mov    %ebx,%esi
  800ca7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	7f 08                	jg     800cb5 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb5:	83 ec 0c             	sub    $0xc,%esp
  800cb8:	50                   	push   %eax
  800cb9:	6a 08                	push   $0x8
  800cbb:	68 bf 27 80 00       	push   $0x8027bf
  800cc0:	6a 23                	push   $0x23
  800cc2:	68 dc 27 80 00       	push   $0x8027dc
  800cc7:	e8 a9 13 00 00       	call   802075 <_panic>

00800ccc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ccc:	f3 0f 1e fb          	endbr32 
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	57                   	push   %edi
  800cd4:	56                   	push   %esi
  800cd5:	53                   	push   %ebx
  800cd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cde:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce4:	b8 09 00 00 00       	mov    $0x9,%eax
  800ce9:	89 df                	mov    %ebx,%edi
  800ceb:	89 de                	mov    %ebx,%esi
  800ced:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cef:	85 c0                	test   %eax,%eax
  800cf1:	7f 08                	jg     800cfb <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5f                   	pop    %edi
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfb:	83 ec 0c             	sub    $0xc,%esp
  800cfe:	50                   	push   %eax
  800cff:	6a 09                	push   $0x9
  800d01:	68 bf 27 80 00       	push   $0x8027bf
  800d06:	6a 23                	push   $0x23
  800d08:	68 dc 27 80 00       	push   $0x8027dc
  800d0d:	e8 63 13 00 00       	call   802075 <_panic>

00800d12 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d12:	f3 0f 1e fb          	endbr32 
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d2f:	89 df                	mov    %ebx,%edi
  800d31:	89 de                	mov    %ebx,%esi
  800d33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	7f 08                	jg     800d41 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5f                   	pop    %edi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d41:	83 ec 0c             	sub    $0xc,%esp
  800d44:	50                   	push   %eax
  800d45:	6a 0a                	push   $0xa
  800d47:	68 bf 27 80 00       	push   $0x8027bf
  800d4c:	6a 23                	push   $0x23
  800d4e:	68 dc 27 80 00       	push   $0x8027dc
  800d53:	e8 1d 13 00 00       	call   802075 <_panic>

00800d58 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d58:	f3 0f 1e fb          	endbr32 
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d6d:	be 00 00 00 00       	mov    $0x0,%esi
  800d72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d75:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d78:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d7a:	5b                   	pop    %ebx
  800d7b:	5e                   	pop    %esi
  800d7c:	5f                   	pop    %edi
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    

00800d7f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d7f:	f3 0f 1e fb          	endbr32 
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d91:	8b 55 08             	mov    0x8(%ebp),%edx
  800d94:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d99:	89 cb                	mov    %ecx,%ebx
  800d9b:	89 cf                	mov    %ecx,%edi
  800d9d:	89 ce                	mov    %ecx,%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 0d                	push   $0xd
  800db3:	68 bf 27 80 00       	push   $0x8027bf
  800db8:	6a 23                	push   $0x23
  800dba:	68 dc 27 80 00       	push   $0x8027dc
  800dbf:	e8 b1 12 00 00       	call   802075 <_panic>

00800dc4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dc4:	f3 0f 1e fb          	endbr32 
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dce:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dd8:	89 d1                	mov    %edx,%ecx
  800dda:	89 d3                	mov    %edx,%ebx
  800ddc:	89 d7                	mov    %edx,%edi
  800dde:	89 d6                	mov    %edx,%esi
  800de0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800de7:	f3 0f 1e fb          	endbr32 
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	57                   	push   %edi
  800def:	56                   	push   %esi
  800df0:	53                   	push   %ebx
  800df1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dff:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e04:	89 df                	mov    %ebx,%edi
  800e06:	89 de                	mov    %ebx,%esi
  800e08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0a:	85 c0                	test   %eax,%eax
  800e0c:	7f 08                	jg     800e16 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e11:	5b                   	pop    %ebx
  800e12:	5e                   	pop    %esi
  800e13:	5f                   	pop    %edi
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e16:	83 ec 0c             	sub    $0xc,%esp
  800e19:	50                   	push   %eax
  800e1a:	6a 0f                	push   $0xf
  800e1c:	68 bf 27 80 00       	push   $0x8027bf
  800e21:	6a 23                	push   $0x23
  800e23:	68 dc 27 80 00       	push   $0x8027dc
  800e28:	e8 48 12 00 00       	call   802075 <_panic>

00800e2d <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800e2d:	f3 0f 1e fb          	endbr32 
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	57                   	push   %edi
  800e35:	56                   	push   %esi
  800e36:	53                   	push   %ebx
  800e37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	b8 10 00 00 00       	mov    $0x10,%eax
  800e4a:	89 df                	mov    %ebx,%edi
  800e4c:	89 de                	mov    %ebx,%esi
  800e4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e50:	85 c0                	test   %eax,%eax
  800e52:	7f 08                	jg     800e5c <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	50                   	push   %eax
  800e60:	6a 10                	push   $0x10
  800e62:	68 bf 27 80 00       	push   $0x8027bf
  800e67:	6a 23                	push   $0x23
  800e69:	68 dc 27 80 00       	push   $0x8027dc
  800e6e:	e8 02 12 00 00       	call   802075 <_panic>

00800e73 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e73:	f3 0f 1e fb          	endbr32 
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	05 00 00 00 30       	add    $0x30000000,%eax
  800e82:	c1 e8 0c             	shr    $0xc,%eax
}
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    

00800e87 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e87:	f3 0f 1e fb          	endbr32 
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e9b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ea2:	f3 0f 1e fb          	endbr32 
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800eae:	89 c2                	mov    %eax,%edx
  800eb0:	c1 ea 16             	shr    $0x16,%edx
  800eb3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800eba:	f6 c2 01             	test   $0x1,%dl
  800ebd:	74 2d                	je     800eec <fd_alloc+0x4a>
  800ebf:	89 c2                	mov    %eax,%edx
  800ec1:	c1 ea 0c             	shr    $0xc,%edx
  800ec4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ecb:	f6 c2 01             	test   $0x1,%dl
  800ece:	74 1c                	je     800eec <fd_alloc+0x4a>
  800ed0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ed5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800eda:	75 d2                	jne    800eae <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ee5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800eea:	eb 0a                	jmp    800ef6 <fd_alloc+0x54>
			*fd_store = fd;
  800eec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eef:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ef1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ef8:	f3 0f 1e fb          	endbr32 
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f02:	83 f8 1f             	cmp    $0x1f,%eax
  800f05:	77 30                	ja     800f37 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f07:	c1 e0 0c             	shl    $0xc,%eax
  800f0a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f0f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f15:	f6 c2 01             	test   $0x1,%dl
  800f18:	74 24                	je     800f3e <fd_lookup+0x46>
  800f1a:	89 c2                	mov    %eax,%edx
  800f1c:	c1 ea 0c             	shr    $0xc,%edx
  800f1f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f26:	f6 c2 01             	test   $0x1,%dl
  800f29:	74 1a                	je     800f45 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2e:	89 02                	mov    %eax,(%edx)
	return 0;
  800f30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    
		return -E_INVAL;
  800f37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f3c:	eb f7                	jmp    800f35 <fd_lookup+0x3d>
		return -E_INVAL;
  800f3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f43:	eb f0                	jmp    800f35 <fd_lookup+0x3d>
  800f45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f4a:	eb e9                	jmp    800f35 <fd_lookup+0x3d>

00800f4c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f4c:	f3 0f 1e fb          	endbr32 
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 08             	sub    $0x8,%esp
  800f56:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f59:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f63:	39 08                	cmp    %ecx,(%eax)
  800f65:	74 38                	je     800f9f <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800f67:	83 c2 01             	add    $0x1,%edx
  800f6a:	8b 04 95 68 28 80 00 	mov    0x802868(,%edx,4),%eax
  800f71:	85 c0                	test   %eax,%eax
  800f73:	75 ee                	jne    800f63 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f75:	a1 08 40 80 00       	mov    0x804008,%eax
  800f7a:	8b 40 48             	mov    0x48(%eax),%eax
  800f7d:	83 ec 04             	sub    $0x4,%esp
  800f80:	51                   	push   %ecx
  800f81:	50                   	push   %eax
  800f82:	68 ec 27 80 00       	push   $0x8027ec
  800f87:	e8 db f1 ff ff       	call   800167 <cprintf>
	*dev = 0;
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f95:	83 c4 10             	add    $0x10,%esp
  800f98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    
			*dev = devtab[i];
  800f9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa2:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa9:	eb f2                	jmp    800f9d <dev_lookup+0x51>

00800fab <fd_close>:
{
  800fab:	f3 0f 1e fb          	endbr32 
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	57                   	push   %edi
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
  800fb5:	83 ec 24             	sub    $0x24,%esp
  800fb8:	8b 75 08             	mov    0x8(%ebp),%esi
  800fbb:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fbe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fc1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fc8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fcb:	50                   	push   %eax
  800fcc:	e8 27 ff ff ff       	call   800ef8 <fd_lookup>
  800fd1:	89 c3                	mov    %eax,%ebx
  800fd3:	83 c4 10             	add    $0x10,%esp
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	78 05                	js     800fdf <fd_close+0x34>
	    || fd != fd2)
  800fda:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fdd:	74 16                	je     800ff5 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800fdf:	89 f8                	mov    %edi,%eax
  800fe1:	84 c0                	test   %al,%al
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe8:	0f 44 d8             	cmove  %eax,%ebx
}
  800feb:	89 d8                	mov    %ebx,%eax
  800fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff0:	5b                   	pop    %ebx
  800ff1:	5e                   	pop    %esi
  800ff2:	5f                   	pop    %edi
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ff5:	83 ec 08             	sub    $0x8,%esp
  800ff8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ffb:	50                   	push   %eax
  800ffc:	ff 36                	pushl  (%esi)
  800ffe:	e8 49 ff ff ff       	call   800f4c <dev_lookup>
  801003:	89 c3                	mov    %eax,%ebx
  801005:	83 c4 10             	add    $0x10,%esp
  801008:	85 c0                	test   %eax,%eax
  80100a:	78 1a                	js     801026 <fd_close+0x7b>
		if (dev->dev_close)
  80100c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80100f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801012:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801017:	85 c0                	test   %eax,%eax
  801019:	74 0b                	je     801026 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80101b:	83 ec 0c             	sub    $0xc,%esp
  80101e:	56                   	push   %esi
  80101f:	ff d0                	call   *%eax
  801021:	89 c3                	mov    %eax,%ebx
  801023:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	56                   	push   %esi
  80102a:	6a 00                	push   $0x0
  80102c:	e8 0f fc ff ff       	call   800c40 <sys_page_unmap>
	return r;
  801031:	83 c4 10             	add    $0x10,%esp
  801034:	eb b5                	jmp    800feb <fd_close+0x40>

00801036 <close>:

int
close(int fdnum)
{
  801036:	f3 0f 1e fb          	endbr32 
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801040:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801043:	50                   	push   %eax
  801044:	ff 75 08             	pushl  0x8(%ebp)
  801047:	e8 ac fe ff ff       	call   800ef8 <fd_lookup>
  80104c:	83 c4 10             	add    $0x10,%esp
  80104f:	85 c0                	test   %eax,%eax
  801051:	79 02                	jns    801055 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801053:	c9                   	leave  
  801054:	c3                   	ret    
		return fd_close(fd, 1);
  801055:	83 ec 08             	sub    $0x8,%esp
  801058:	6a 01                	push   $0x1
  80105a:	ff 75 f4             	pushl  -0xc(%ebp)
  80105d:	e8 49 ff ff ff       	call   800fab <fd_close>
  801062:	83 c4 10             	add    $0x10,%esp
  801065:	eb ec                	jmp    801053 <close+0x1d>

00801067 <close_all>:

void
close_all(void)
{
  801067:	f3 0f 1e fb          	endbr32 
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	53                   	push   %ebx
  80106f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801072:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801077:	83 ec 0c             	sub    $0xc,%esp
  80107a:	53                   	push   %ebx
  80107b:	e8 b6 ff ff ff       	call   801036 <close>
	for (i = 0; i < MAXFD; i++)
  801080:	83 c3 01             	add    $0x1,%ebx
  801083:	83 c4 10             	add    $0x10,%esp
  801086:	83 fb 20             	cmp    $0x20,%ebx
  801089:	75 ec                	jne    801077 <close_all+0x10>
}
  80108b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80108e:	c9                   	leave  
  80108f:	c3                   	ret    

00801090 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801090:	f3 0f 1e fb          	endbr32 
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
  80109a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80109d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010a0:	50                   	push   %eax
  8010a1:	ff 75 08             	pushl  0x8(%ebp)
  8010a4:	e8 4f fe ff ff       	call   800ef8 <fd_lookup>
  8010a9:	89 c3                	mov    %eax,%ebx
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	0f 88 81 00 00 00    	js     801137 <dup+0xa7>
		return r;
	close(newfdnum);
  8010b6:	83 ec 0c             	sub    $0xc,%esp
  8010b9:	ff 75 0c             	pushl  0xc(%ebp)
  8010bc:	e8 75 ff ff ff       	call   801036 <close>

	newfd = INDEX2FD(newfdnum);
  8010c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010c4:	c1 e6 0c             	shl    $0xc,%esi
  8010c7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010cd:	83 c4 04             	add    $0x4,%esp
  8010d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d3:	e8 af fd ff ff       	call   800e87 <fd2data>
  8010d8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010da:	89 34 24             	mov    %esi,(%esp)
  8010dd:	e8 a5 fd ff ff       	call   800e87 <fd2data>
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010e7:	89 d8                	mov    %ebx,%eax
  8010e9:	c1 e8 16             	shr    $0x16,%eax
  8010ec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010f3:	a8 01                	test   $0x1,%al
  8010f5:	74 11                	je     801108 <dup+0x78>
  8010f7:	89 d8                	mov    %ebx,%eax
  8010f9:	c1 e8 0c             	shr    $0xc,%eax
  8010fc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801103:	f6 c2 01             	test   $0x1,%dl
  801106:	75 39                	jne    801141 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801108:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80110b:	89 d0                	mov    %edx,%eax
  80110d:	c1 e8 0c             	shr    $0xc,%eax
  801110:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801117:	83 ec 0c             	sub    $0xc,%esp
  80111a:	25 07 0e 00 00       	and    $0xe07,%eax
  80111f:	50                   	push   %eax
  801120:	56                   	push   %esi
  801121:	6a 00                	push   $0x0
  801123:	52                   	push   %edx
  801124:	6a 00                	push   $0x0
  801126:	e8 cf fa ff ff       	call   800bfa <sys_page_map>
  80112b:	89 c3                	mov    %eax,%ebx
  80112d:	83 c4 20             	add    $0x20,%esp
  801130:	85 c0                	test   %eax,%eax
  801132:	78 31                	js     801165 <dup+0xd5>
		goto err;

	return newfdnum;
  801134:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801137:	89 d8                	mov    %ebx,%eax
  801139:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113c:	5b                   	pop    %ebx
  80113d:	5e                   	pop    %esi
  80113e:	5f                   	pop    %edi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801141:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801148:	83 ec 0c             	sub    $0xc,%esp
  80114b:	25 07 0e 00 00       	and    $0xe07,%eax
  801150:	50                   	push   %eax
  801151:	57                   	push   %edi
  801152:	6a 00                	push   $0x0
  801154:	53                   	push   %ebx
  801155:	6a 00                	push   $0x0
  801157:	e8 9e fa ff ff       	call   800bfa <sys_page_map>
  80115c:	89 c3                	mov    %eax,%ebx
  80115e:	83 c4 20             	add    $0x20,%esp
  801161:	85 c0                	test   %eax,%eax
  801163:	79 a3                	jns    801108 <dup+0x78>
	sys_page_unmap(0, newfd);
  801165:	83 ec 08             	sub    $0x8,%esp
  801168:	56                   	push   %esi
  801169:	6a 00                	push   $0x0
  80116b:	e8 d0 fa ff ff       	call   800c40 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801170:	83 c4 08             	add    $0x8,%esp
  801173:	57                   	push   %edi
  801174:	6a 00                	push   $0x0
  801176:	e8 c5 fa ff ff       	call   800c40 <sys_page_unmap>
	return r;
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	eb b7                	jmp    801137 <dup+0xa7>

00801180 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801180:	f3 0f 1e fb          	endbr32 
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	53                   	push   %ebx
  801188:	83 ec 1c             	sub    $0x1c,%esp
  80118b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80118e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801191:	50                   	push   %eax
  801192:	53                   	push   %ebx
  801193:	e8 60 fd ff ff       	call   800ef8 <fd_lookup>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	85 c0                	test   %eax,%eax
  80119d:	78 3f                	js     8011de <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80119f:	83 ec 08             	sub    $0x8,%esp
  8011a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a5:	50                   	push   %eax
  8011a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a9:	ff 30                	pushl  (%eax)
  8011ab:	e8 9c fd ff ff       	call   800f4c <dev_lookup>
  8011b0:	83 c4 10             	add    $0x10,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	78 27                	js     8011de <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011ba:	8b 42 08             	mov    0x8(%edx),%eax
  8011bd:	83 e0 03             	and    $0x3,%eax
  8011c0:	83 f8 01             	cmp    $0x1,%eax
  8011c3:	74 1e                	je     8011e3 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c8:	8b 40 08             	mov    0x8(%eax),%eax
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	74 35                	je     801204 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011cf:	83 ec 04             	sub    $0x4,%esp
  8011d2:	ff 75 10             	pushl  0x10(%ebp)
  8011d5:	ff 75 0c             	pushl  0xc(%ebp)
  8011d8:	52                   	push   %edx
  8011d9:	ff d0                	call   *%eax
  8011db:	83 c4 10             	add    $0x10,%esp
}
  8011de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011e3:	a1 08 40 80 00       	mov    0x804008,%eax
  8011e8:	8b 40 48             	mov    0x48(%eax),%eax
  8011eb:	83 ec 04             	sub    $0x4,%esp
  8011ee:	53                   	push   %ebx
  8011ef:	50                   	push   %eax
  8011f0:	68 2d 28 80 00       	push   $0x80282d
  8011f5:	e8 6d ef ff ff       	call   800167 <cprintf>
		return -E_INVAL;
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801202:	eb da                	jmp    8011de <read+0x5e>
		return -E_NOT_SUPP;
  801204:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801209:	eb d3                	jmp    8011de <read+0x5e>

0080120b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80120b:	f3 0f 1e fb          	endbr32 
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	57                   	push   %edi
  801213:	56                   	push   %esi
  801214:	53                   	push   %ebx
  801215:	83 ec 0c             	sub    $0xc,%esp
  801218:	8b 7d 08             	mov    0x8(%ebp),%edi
  80121b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80121e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801223:	eb 02                	jmp    801227 <readn+0x1c>
  801225:	01 c3                	add    %eax,%ebx
  801227:	39 f3                	cmp    %esi,%ebx
  801229:	73 21                	jae    80124c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80122b:	83 ec 04             	sub    $0x4,%esp
  80122e:	89 f0                	mov    %esi,%eax
  801230:	29 d8                	sub    %ebx,%eax
  801232:	50                   	push   %eax
  801233:	89 d8                	mov    %ebx,%eax
  801235:	03 45 0c             	add    0xc(%ebp),%eax
  801238:	50                   	push   %eax
  801239:	57                   	push   %edi
  80123a:	e8 41 ff ff ff       	call   801180 <read>
		if (m < 0)
  80123f:	83 c4 10             	add    $0x10,%esp
  801242:	85 c0                	test   %eax,%eax
  801244:	78 04                	js     80124a <readn+0x3f>
			return m;
		if (m == 0)
  801246:	75 dd                	jne    801225 <readn+0x1a>
  801248:	eb 02                	jmp    80124c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80124a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80124c:	89 d8                	mov    %ebx,%eax
  80124e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801251:	5b                   	pop    %ebx
  801252:	5e                   	pop    %esi
  801253:	5f                   	pop    %edi
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801256:	f3 0f 1e fb          	endbr32 
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	53                   	push   %ebx
  80125e:	83 ec 1c             	sub    $0x1c,%esp
  801261:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801264:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801267:	50                   	push   %eax
  801268:	53                   	push   %ebx
  801269:	e8 8a fc ff ff       	call   800ef8 <fd_lookup>
  80126e:	83 c4 10             	add    $0x10,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	78 3a                	js     8012af <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127b:	50                   	push   %eax
  80127c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127f:	ff 30                	pushl  (%eax)
  801281:	e8 c6 fc ff ff       	call   800f4c <dev_lookup>
  801286:	83 c4 10             	add    $0x10,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	78 22                	js     8012af <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80128d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801290:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801294:	74 1e                	je     8012b4 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801299:	8b 52 0c             	mov    0xc(%edx),%edx
  80129c:	85 d2                	test   %edx,%edx
  80129e:	74 35                	je     8012d5 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012a0:	83 ec 04             	sub    $0x4,%esp
  8012a3:	ff 75 10             	pushl  0x10(%ebp)
  8012a6:	ff 75 0c             	pushl  0xc(%ebp)
  8012a9:	50                   	push   %eax
  8012aa:	ff d2                	call   *%edx
  8012ac:	83 c4 10             	add    $0x10,%esp
}
  8012af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012b4:	a1 08 40 80 00       	mov    0x804008,%eax
  8012b9:	8b 40 48             	mov    0x48(%eax),%eax
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	53                   	push   %ebx
  8012c0:	50                   	push   %eax
  8012c1:	68 49 28 80 00       	push   $0x802849
  8012c6:	e8 9c ee ff ff       	call   800167 <cprintf>
		return -E_INVAL;
  8012cb:	83 c4 10             	add    $0x10,%esp
  8012ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d3:	eb da                	jmp    8012af <write+0x59>
		return -E_NOT_SUPP;
  8012d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012da:	eb d3                	jmp    8012af <write+0x59>

008012dc <seek>:

int
seek(int fdnum, off_t offset)
{
  8012dc:	f3 0f 1e fb          	endbr32 
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e9:	50                   	push   %eax
  8012ea:	ff 75 08             	pushl  0x8(%ebp)
  8012ed:	e8 06 fc ff ff       	call   800ef8 <fd_lookup>
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	78 0e                	js     801307 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8012f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ff:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801302:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801309:	f3 0f 1e fb          	endbr32 
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	53                   	push   %ebx
  801311:	83 ec 1c             	sub    $0x1c,%esp
  801314:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801317:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131a:	50                   	push   %eax
  80131b:	53                   	push   %ebx
  80131c:	e8 d7 fb ff ff       	call   800ef8 <fd_lookup>
  801321:	83 c4 10             	add    $0x10,%esp
  801324:	85 c0                	test   %eax,%eax
  801326:	78 37                	js     80135f <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132e:	50                   	push   %eax
  80132f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801332:	ff 30                	pushl  (%eax)
  801334:	e8 13 fc ff ff       	call   800f4c <dev_lookup>
  801339:	83 c4 10             	add    $0x10,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	78 1f                	js     80135f <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801347:	74 1b                	je     801364 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801349:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134c:	8b 52 18             	mov    0x18(%edx),%edx
  80134f:	85 d2                	test   %edx,%edx
  801351:	74 32                	je     801385 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801353:	83 ec 08             	sub    $0x8,%esp
  801356:	ff 75 0c             	pushl  0xc(%ebp)
  801359:	50                   	push   %eax
  80135a:	ff d2                	call   *%edx
  80135c:	83 c4 10             	add    $0x10,%esp
}
  80135f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801362:	c9                   	leave  
  801363:	c3                   	ret    
			thisenv->env_id, fdnum);
  801364:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801369:	8b 40 48             	mov    0x48(%eax),%eax
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	53                   	push   %ebx
  801370:	50                   	push   %eax
  801371:	68 0c 28 80 00       	push   $0x80280c
  801376:	e8 ec ed ff ff       	call   800167 <cprintf>
		return -E_INVAL;
  80137b:	83 c4 10             	add    $0x10,%esp
  80137e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801383:	eb da                	jmp    80135f <ftruncate+0x56>
		return -E_NOT_SUPP;
  801385:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80138a:	eb d3                	jmp    80135f <ftruncate+0x56>

0080138c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80138c:	f3 0f 1e fb          	endbr32 
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	53                   	push   %ebx
  801394:	83 ec 1c             	sub    $0x1c,%esp
  801397:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139d:	50                   	push   %eax
  80139e:	ff 75 08             	pushl  0x8(%ebp)
  8013a1:	e8 52 fb ff ff       	call   800ef8 <fd_lookup>
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	78 4b                	js     8013f8 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b3:	50                   	push   %eax
  8013b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b7:	ff 30                	pushl  (%eax)
  8013b9:	e8 8e fb ff ff       	call   800f4c <dev_lookup>
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	78 33                	js     8013f8 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8013c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013cc:	74 2f                	je     8013fd <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013ce:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013d1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013d8:	00 00 00 
	stat->st_isdir = 0;
  8013db:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013e2:	00 00 00 
	stat->st_dev = dev;
  8013e5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013eb:	83 ec 08             	sub    $0x8,%esp
  8013ee:	53                   	push   %ebx
  8013ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8013f2:	ff 50 14             	call   *0x14(%eax)
  8013f5:	83 c4 10             	add    $0x10,%esp
}
  8013f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    
		return -E_NOT_SUPP;
  8013fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801402:	eb f4                	jmp    8013f8 <fstat+0x6c>

00801404 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801404:	f3 0f 1e fb          	endbr32 
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	56                   	push   %esi
  80140c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	6a 00                	push   $0x0
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	e8 fb 01 00 00       	call   801615 <open>
  80141a:	89 c3                	mov    %eax,%ebx
  80141c:	83 c4 10             	add    $0x10,%esp
  80141f:	85 c0                	test   %eax,%eax
  801421:	78 1b                	js     80143e <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	50                   	push   %eax
  80142a:	e8 5d ff ff ff       	call   80138c <fstat>
  80142f:	89 c6                	mov    %eax,%esi
	close(fd);
  801431:	89 1c 24             	mov    %ebx,(%esp)
  801434:	e8 fd fb ff ff       	call   801036 <close>
	return r;
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	89 f3                	mov    %esi,%ebx
}
  80143e:	89 d8                	mov    %ebx,%eax
  801440:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801443:	5b                   	pop    %ebx
  801444:	5e                   	pop    %esi
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    

00801447 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	56                   	push   %esi
  80144b:	53                   	push   %ebx
  80144c:	89 c6                	mov    %eax,%esi
  80144e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801450:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801457:	74 27                	je     801480 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801459:	6a 07                	push   $0x7
  80145b:	68 00 50 80 00       	push   $0x805000
  801460:	56                   	push   %esi
  801461:	ff 35 00 40 80 00    	pushl  0x804000
  801467:	e8 d8 0c 00 00       	call   802144 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80146c:	83 c4 0c             	add    $0xc,%esp
  80146f:	6a 00                	push   $0x0
  801471:	53                   	push   %ebx
  801472:	6a 00                	push   $0x0
  801474:	e8 46 0c 00 00       	call   8020bf <ipc_recv>
}
  801479:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80147c:	5b                   	pop    %ebx
  80147d:	5e                   	pop    %esi
  80147e:	5d                   	pop    %ebp
  80147f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801480:	83 ec 0c             	sub    $0xc,%esp
  801483:	6a 01                	push   $0x1
  801485:	e8 12 0d 00 00       	call   80219c <ipc_find_env>
  80148a:	a3 00 40 80 00       	mov    %eax,0x804000
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	eb c5                	jmp    801459 <fsipc+0x12>

00801494 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801494:	f3 0f 1e fb          	endbr32 
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b6:	b8 02 00 00 00       	mov    $0x2,%eax
  8014bb:	e8 87 ff ff ff       	call   801447 <fsipc>
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <devfile_flush>:
{
  8014c2:	f3 0f 1e fb          	endbr32 
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8014d2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014dc:	b8 06 00 00 00       	mov    $0x6,%eax
  8014e1:	e8 61 ff ff ff       	call   801447 <fsipc>
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <devfile_stat>:
{
  8014e8:	f3 0f 1e fb          	endbr32 
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	53                   	push   %ebx
  8014f0:	83 ec 04             	sub    $0x4,%esp
  8014f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8014fc:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801501:	ba 00 00 00 00       	mov    $0x0,%edx
  801506:	b8 05 00 00 00       	mov    $0x5,%eax
  80150b:	e8 37 ff ff ff       	call   801447 <fsipc>
  801510:	85 c0                	test   %eax,%eax
  801512:	78 2c                	js     801540 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801514:	83 ec 08             	sub    $0x8,%esp
  801517:	68 00 50 80 00       	push   $0x805000
  80151c:	53                   	push   %ebx
  80151d:	e8 4f f2 ff ff       	call   800771 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801522:	a1 80 50 80 00       	mov    0x805080,%eax
  801527:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80152d:	a1 84 50 80 00       	mov    0x805084,%eax
  801532:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801540:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <devfile_write>:
{
  801545:	f3 0f 1e fb          	endbr32 
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	83 ec 0c             	sub    $0xc,%esp
  80154f:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801552:	8b 55 08             	mov    0x8(%ebp),%edx
  801555:	8b 52 0c             	mov    0xc(%edx),%edx
  801558:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80155e:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801563:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801568:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80156b:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801570:	50                   	push   %eax
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	68 08 50 80 00       	push   $0x805008
  801579:	e8 a9 f3 ff ff       	call   800927 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80157e:	ba 00 00 00 00       	mov    $0x0,%edx
  801583:	b8 04 00 00 00       	mov    $0x4,%eax
  801588:	e8 ba fe ff ff       	call   801447 <fsipc>
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <devfile_read>:
{
  80158f:	f3 0f 1e fb          	endbr32 
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
  801596:	56                   	push   %esi
  801597:	53                   	push   %ebx
  801598:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
  80159e:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015a6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8015b6:	e8 8c fe ff ff       	call   801447 <fsipc>
  8015bb:	89 c3                	mov    %eax,%ebx
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	78 1f                	js     8015e0 <devfile_read+0x51>
	assert(r <= n);
  8015c1:	39 f0                	cmp    %esi,%eax
  8015c3:	77 24                	ja     8015e9 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8015c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015ca:	7f 33                	jg     8015ff <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015cc:	83 ec 04             	sub    $0x4,%esp
  8015cf:	50                   	push   %eax
  8015d0:	68 00 50 80 00       	push   $0x805000
  8015d5:	ff 75 0c             	pushl  0xc(%ebp)
  8015d8:	e8 4a f3 ff ff       	call   800927 <memmove>
	return r;
  8015dd:	83 c4 10             	add    $0x10,%esp
}
  8015e0:	89 d8                	mov    %ebx,%eax
  8015e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e5:	5b                   	pop    %ebx
  8015e6:	5e                   	pop    %esi
  8015e7:	5d                   	pop    %ebp
  8015e8:	c3                   	ret    
	assert(r <= n);
  8015e9:	68 7c 28 80 00       	push   $0x80287c
  8015ee:	68 83 28 80 00       	push   $0x802883
  8015f3:	6a 7c                	push   $0x7c
  8015f5:	68 98 28 80 00       	push   $0x802898
  8015fa:	e8 76 0a 00 00       	call   802075 <_panic>
	assert(r <= PGSIZE);
  8015ff:	68 a3 28 80 00       	push   $0x8028a3
  801604:	68 83 28 80 00       	push   $0x802883
  801609:	6a 7d                	push   $0x7d
  80160b:	68 98 28 80 00       	push   $0x802898
  801610:	e8 60 0a 00 00       	call   802075 <_panic>

00801615 <open>:
{
  801615:	f3 0f 1e fb          	endbr32 
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	56                   	push   %esi
  80161d:	53                   	push   %ebx
  80161e:	83 ec 1c             	sub    $0x1c,%esp
  801621:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801624:	56                   	push   %esi
  801625:	e8 04 f1 ff ff       	call   80072e <strlen>
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801632:	7f 6c                	jg     8016a0 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801634:	83 ec 0c             	sub    $0xc,%esp
  801637:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163a:	50                   	push   %eax
  80163b:	e8 62 f8 ff ff       	call   800ea2 <fd_alloc>
  801640:	89 c3                	mov    %eax,%ebx
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 3c                	js     801685 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801649:	83 ec 08             	sub    $0x8,%esp
  80164c:	56                   	push   %esi
  80164d:	68 00 50 80 00       	push   $0x805000
  801652:	e8 1a f1 ff ff       	call   800771 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80165f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801662:	b8 01 00 00 00       	mov    $0x1,%eax
  801667:	e8 db fd ff ff       	call   801447 <fsipc>
  80166c:	89 c3                	mov    %eax,%ebx
  80166e:	83 c4 10             	add    $0x10,%esp
  801671:	85 c0                	test   %eax,%eax
  801673:	78 19                	js     80168e <open+0x79>
	return fd2num(fd);
  801675:	83 ec 0c             	sub    $0xc,%esp
  801678:	ff 75 f4             	pushl  -0xc(%ebp)
  80167b:	e8 f3 f7 ff ff       	call   800e73 <fd2num>
  801680:	89 c3                	mov    %eax,%ebx
  801682:	83 c4 10             	add    $0x10,%esp
}
  801685:	89 d8                	mov    %ebx,%eax
  801687:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80168a:	5b                   	pop    %ebx
  80168b:	5e                   	pop    %esi
  80168c:	5d                   	pop    %ebp
  80168d:	c3                   	ret    
		fd_close(fd, 0);
  80168e:	83 ec 08             	sub    $0x8,%esp
  801691:	6a 00                	push   $0x0
  801693:	ff 75 f4             	pushl  -0xc(%ebp)
  801696:	e8 10 f9 ff ff       	call   800fab <fd_close>
		return r;
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	eb e5                	jmp    801685 <open+0x70>
		return -E_BAD_PATH;
  8016a0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016a5:	eb de                	jmp    801685 <open+0x70>

008016a7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016a7:	f3 0f 1e fb          	endbr32 
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8016bb:	e8 87 fd ff ff       	call   801447 <fsipc>
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8016c2:	f3 0f 1e fb          	endbr32 
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8016cc:	68 af 28 80 00       	push   $0x8028af
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	e8 98 f0 ff ff       	call   800771 <strcpy>
	return 0;
}
  8016d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <devsock_close>:
{
  8016e0:	f3 0f 1e fb          	endbr32 
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	53                   	push   %ebx
  8016e8:	83 ec 10             	sub    $0x10,%esp
  8016eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8016ee:	53                   	push   %ebx
  8016ef:	e8 e5 0a 00 00       	call   8021d9 <pageref>
  8016f4:	89 c2                	mov    %eax,%edx
  8016f6:	83 c4 10             	add    $0x10,%esp
		return 0;
  8016f9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8016fe:	83 fa 01             	cmp    $0x1,%edx
  801701:	74 05                	je     801708 <devsock_close+0x28>
}
  801703:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801706:	c9                   	leave  
  801707:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801708:	83 ec 0c             	sub    $0xc,%esp
  80170b:	ff 73 0c             	pushl  0xc(%ebx)
  80170e:	e8 e3 02 00 00       	call   8019f6 <nsipc_close>
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	eb eb                	jmp    801703 <devsock_close+0x23>

00801718 <devsock_write>:
{
  801718:	f3 0f 1e fb          	endbr32 
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801722:	6a 00                	push   $0x0
  801724:	ff 75 10             	pushl  0x10(%ebp)
  801727:	ff 75 0c             	pushl  0xc(%ebp)
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	ff 70 0c             	pushl  0xc(%eax)
  801730:	e8 b5 03 00 00       	call   801aea <nsipc_send>
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <devsock_read>:
{
  801737:	f3 0f 1e fb          	endbr32 
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801741:	6a 00                	push   $0x0
  801743:	ff 75 10             	pushl  0x10(%ebp)
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	ff 70 0c             	pushl  0xc(%eax)
  80174f:	e8 1f 03 00 00       	call   801a73 <nsipc_recv>
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <fd2sockid>:
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80175c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80175f:	52                   	push   %edx
  801760:	50                   	push   %eax
  801761:	e8 92 f7 ff ff       	call   800ef8 <fd_lookup>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 10                	js     80177d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801770:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801776:	39 08                	cmp    %ecx,(%eax)
  801778:	75 05                	jne    80177f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80177a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    
		return -E_NOT_SUPP;
  80177f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801784:	eb f7                	jmp    80177d <fd2sockid+0x27>

00801786 <alloc_sockfd>:
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	56                   	push   %esi
  80178a:	53                   	push   %ebx
  80178b:	83 ec 1c             	sub    $0x1c,%esp
  80178e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801790:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801793:	50                   	push   %eax
  801794:	e8 09 f7 ff ff       	call   800ea2 <fd_alloc>
  801799:	89 c3                	mov    %eax,%ebx
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	78 43                	js     8017e5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	68 07 04 00 00       	push   $0x407
  8017aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ad:	6a 00                	push   $0x0
  8017af:	e8 ff f3 ff ff       	call   800bb3 <sys_page_alloc>
  8017b4:	89 c3                	mov    %eax,%ebx
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	78 28                	js     8017e5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8017bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017c6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8017d2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8017d5:	83 ec 0c             	sub    $0xc,%esp
  8017d8:	50                   	push   %eax
  8017d9:	e8 95 f6 ff ff       	call   800e73 <fd2num>
  8017de:	89 c3                	mov    %eax,%ebx
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	eb 0c                	jmp    8017f1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8017e5:	83 ec 0c             	sub    $0xc,%esp
  8017e8:	56                   	push   %esi
  8017e9:	e8 08 02 00 00       	call   8019f6 <nsipc_close>
		return r;
  8017ee:	83 c4 10             	add    $0x10,%esp
}
  8017f1:	89 d8                	mov    %ebx,%eax
  8017f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f6:	5b                   	pop    %ebx
  8017f7:	5e                   	pop    %esi
  8017f8:	5d                   	pop    %ebp
  8017f9:	c3                   	ret    

008017fa <accept>:
{
  8017fa:	f3 0f 1e fb          	endbr32 
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	e8 4a ff ff ff       	call   801756 <fd2sockid>
  80180c:	85 c0                	test   %eax,%eax
  80180e:	78 1b                	js     80182b <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	ff 75 10             	pushl  0x10(%ebp)
  801816:	ff 75 0c             	pushl  0xc(%ebp)
  801819:	50                   	push   %eax
  80181a:	e8 22 01 00 00       	call   801941 <nsipc_accept>
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	85 c0                	test   %eax,%eax
  801824:	78 05                	js     80182b <accept+0x31>
	return alloc_sockfd(r);
  801826:	e8 5b ff ff ff       	call   801786 <alloc_sockfd>
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <bind>:
{
  80182d:	f3 0f 1e fb          	endbr32 
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	e8 17 ff ff ff       	call   801756 <fd2sockid>
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 12                	js     801855 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	ff 75 10             	pushl  0x10(%ebp)
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	50                   	push   %eax
  80184d:	e8 45 01 00 00       	call   801997 <nsipc_bind>
  801852:	83 c4 10             	add    $0x10,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <shutdown>:
{
  801857:	f3 0f 1e fb          	endbr32 
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	e8 ed fe ff ff       	call   801756 <fd2sockid>
  801869:	85 c0                	test   %eax,%eax
  80186b:	78 0f                	js     80187c <shutdown+0x25>
	return nsipc_shutdown(r, how);
  80186d:	83 ec 08             	sub    $0x8,%esp
  801870:	ff 75 0c             	pushl  0xc(%ebp)
  801873:	50                   	push   %eax
  801874:	e8 57 01 00 00       	call   8019d0 <nsipc_shutdown>
  801879:	83 c4 10             	add    $0x10,%esp
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <connect>:
{
  80187e:	f3 0f 1e fb          	endbr32 
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	e8 c6 fe ff ff       	call   801756 <fd2sockid>
  801890:	85 c0                	test   %eax,%eax
  801892:	78 12                	js     8018a6 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	ff 75 10             	pushl  0x10(%ebp)
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	50                   	push   %eax
  80189e:	e8 71 01 00 00       	call   801a14 <nsipc_connect>
  8018a3:	83 c4 10             	add    $0x10,%esp
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <listen>:
{
  8018a8:	f3 0f 1e fb          	endbr32 
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	e8 9c fe ff ff       	call   801756 <fd2sockid>
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 0f                	js     8018cd <listen+0x25>
	return nsipc_listen(r, backlog);
  8018be:	83 ec 08             	sub    $0x8,%esp
  8018c1:	ff 75 0c             	pushl  0xc(%ebp)
  8018c4:	50                   	push   %eax
  8018c5:	e8 83 01 00 00       	call   801a4d <nsipc_listen>
  8018ca:	83 c4 10             	add    $0x10,%esp
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <socket>:

int
socket(int domain, int type, int protocol)
{
  8018cf:	f3 0f 1e fb          	endbr32 
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8018d9:	ff 75 10             	pushl  0x10(%ebp)
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	ff 75 08             	pushl  0x8(%ebp)
  8018e2:	e8 65 02 00 00       	call   801b4c <nsipc_socket>
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	78 05                	js     8018f3 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8018ee:	e8 93 fe ff ff       	call   801786 <alloc_sockfd>
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	53                   	push   %ebx
  8018f9:	83 ec 04             	sub    $0x4,%esp
  8018fc:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8018fe:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801905:	74 26                	je     80192d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801907:	6a 07                	push   $0x7
  801909:	68 00 60 80 00       	push   $0x806000
  80190e:	53                   	push   %ebx
  80190f:	ff 35 04 40 80 00    	pushl  0x804004
  801915:	e8 2a 08 00 00       	call   802144 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80191a:	83 c4 0c             	add    $0xc,%esp
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	e8 97 07 00 00       	call   8020bf <ipc_recv>
}
  801928:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80192d:	83 ec 0c             	sub    $0xc,%esp
  801930:	6a 02                	push   $0x2
  801932:	e8 65 08 00 00       	call   80219c <ipc_find_env>
  801937:	a3 04 40 80 00       	mov    %eax,0x804004
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	eb c6                	jmp    801907 <nsipc+0x12>

00801941 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801941:	f3 0f 1e fb          	endbr32 
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	56                   	push   %esi
  801949:	53                   	push   %ebx
  80194a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801955:	8b 06                	mov    (%esi),%eax
  801957:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80195c:	b8 01 00 00 00       	mov    $0x1,%eax
  801961:	e8 8f ff ff ff       	call   8018f5 <nsipc>
  801966:	89 c3                	mov    %eax,%ebx
  801968:	85 c0                	test   %eax,%eax
  80196a:	79 09                	jns    801975 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80196c:	89 d8                	mov    %ebx,%eax
  80196e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801971:	5b                   	pop    %ebx
  801972:	5e                   	pop    %esi
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801975:	83 ec 04             	sub    $0x4,%esp
  801978:	ff 35 10 60 80 00    	pushl  0x806010
  80197e:	68 00 60 80 00       	push   $0x806000
  801983:	ff 75 0c             	pushl  0xc(%ebp)
  801986:	e8 9c ef ff ff       	call   800927 <memmove>
		*addrlen = ret->ret_addrlen;
  80198b:	a1 10 60 80 00       	mov    0x806010,%eax
  801990:	89 06                	mov    %eax,(%esi)
  801992:	83 c4 10             	add    $0x10,%esp
	return r;
  801995:	eb d5                	jmp    80196c <nsipc_accept+0x2b>

00801997 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801997:	f3 0f 1e fb          	endbr32 
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	53                   	push   %ebx
  80199f:	83 ec 08             	sub    $0x8,%esp
  8019a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8019ad:	53                   	push   %ebx
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	68 04 60 80 00       	push   $0x806004
  8019b6:	e8 6c ef ff ff       	call   800927 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8019bb:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8019c1:	b8 02 00 00 00       	mov    $0x2,%eax
  8019c6:	e8 2a ff ff ff       	call   8018f5 <nsipc>
}
  8019cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8019d0:	f3 0f 1e fb          	endbr32 
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8019e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8019ea:	b8 03 00 00 00       	mov    $0x3,%eax
  8019ef:	e8 01 ff ff ff       	call   8018f5 <nsipc>
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <nsipc_close>:

int
nsipc_close(int s)
{
  8019f6:	f3 0f 1e fb          	endbr32 
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801a08:	b8 04 00 00 00       	mov    $0x4,%eax
  801a0d:	e8 e3 fe ff ff       	call   8018f5 <nsipc>
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a14:	f3 0f 1e fb          	endbr32 
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	53                   	push   %ebx
  801a1c:	83 ec 08             	sub    $0x8,%esp
  801a1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801a2a:	53                   	push   %ebx
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	68 04 60 80 00       	push   $0x806004
  801a33:	e8 ef ee ff ff       	call   800927 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801a38:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801a3e:	b8 05 00 00 00       	mov    $0x5,%eax
  801a43:	e8 ad fe ff ff       	call   8018f5 <nsipc>
}
  801a48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801a4d:	f3 0f 1e fb          	endbr32 
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a62:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801a67:	b8 06 00 00 00       	mov    $0x6,%eax
  801a6c:	e8 84 fe ff ff       	call   8018f5 <nsipc>
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a73:	f3 0f 1e fb          	endbr32 
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	56                   	push   %esi
  801a7b:	53                   	push   %ebx
  801a7c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801a87:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a90:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a95:	b8 07 00 00 00       	mov    $0x7,%eax
  801a9a:	e8 56 fe ff ff       	call   8018f5 <nsipc>
  801a9f:	89 c3                	mov    %eax,%ebx
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	78 26                	js     801acb <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801aa5:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801aab:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801ab0:	0f 4e c6             	cmovle %esi,%eax
  801ab3:	39 c3                	cmp    %eax,%ebx
  801ab5:	7f 1d                	jg     801ad4 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ab7:	83 ec 04             	sub    $0x4,%esp
  801aba:	53                   	push   %ebx
  801abb:	68 00 60 80 00       	push   $0x806000
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	e8 5f ee ff ff       	call   800927 <memmove>
  801ac8:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801acb:	89 d8                	mov    %ebx,%eax
  801acd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad0:	5b                   	pop    %ebx
  801ad1:	5e                   	pop    %esi
  801ad2:	5d                   	pop    %ebp
  801ad3:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ad4:	68 bb 28 80 00       	push   $0x8028bb
  801ad9:	68 83 28 80 00       	push   $0x802883
  801ade:	6a 62                	push   $0x62
  801ae0:	68 d0 28 80 00       	push   $0x8028d0
  801ae5:	e8 8b 05 00 00       	call   802075 <_panic>

00801aea <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801aea:	f3 0f 1e fb          	endbr32 
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	53                   	push   %ebx
  801af2:	83 ec 04             	sub    $0x4,%esp
  801af5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801b00:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801b06:	7f 2e                	jg     801b36 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801b08:	83 ec 04             	sub    $0x4,%esp
  801b0b:	53                   	push   %ebx
  801b0c:	ff 75 0c             	pushl  0xc(%ebp)
  801b0f:	68 0c 60 80 00       	push   $0x80600c
  801b14:	e8 0e ee ff ff       	call   800927 <memmove>
	nsipcbuf.send.req_size = size;
  801b19:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b22:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801b27:	b8 08 00 00 00       	mov    $0x8,%eax
  801b2c:	e8 c4 fd ff ff       	call   8018f5 <nsipc>
}
  801b31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    
	assert(size < 1600);
  801b36:	68 dc 28 80 00       	push   $0x8028dc
  801b3b:	68 83 28 80 00       	push   $0x802883
  801b40:	6a 6d                	push   $0x6d
  801b42:	68 d0 28 80 00       	push   $0x8028d0
  801b47:	e8 29 05 00 00       	call   802075 <_panic>

00801b4c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801b4c:	f3 0f 1e fb          	endbr32 
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b61:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801b66:	8b 45 10             	mov    0x10(%ebp),%eax
  801b69:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801b6e:	b8 09 00 00 00       	mov    $0x9,%eax
  801b73:	e8 7d fd ff ff       	call   8018f5 <nsipc>
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b7a:	f3 0f 1e fb          	endbr32 
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	56                   	push   %esi
  801b82:	53                   	push   %ebx
  801b83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b86:	83 ec 0c             	sub    $0xc,%esp
  801b89:	ff 75 08             	pushl  0x8(%ebp)
  801b8c:	e8 f6 f2 ff ff       	call   800e87 <fd2data>
  801b91:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b93:	83 c4 08             	add    $0x8,%esp
  801b96:	68 e8 28 80 00       	push   $0x8028e8
  801b9b:	53                   	push   %ebx
  801b9c:	e8 d0 eb ff ff       	call   800771 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ba1:	8b 46 04             	mov    0x4(%esi),%eax
  801ba4:	2b 06                	sub    (%esi),%eax
  801ba6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bac:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bb3:	00 00 00 
	stat->st_dev = &devpipe;
  801bb6:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801bbd:	30 80 00 
	return 0;
}
  801bc0:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc8:	5b                   	pop    %ebx
  801bc9:	5e                   	pop    %esi
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    

00801bcc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bcc:	f3 0f 1e fb          	endbr32 
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 0c             	sub    $0xc,%esp
  801bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bda:	53                   	push   %ebx
  801bdb:	6a 00                	push   $0x0
  801bdd:	e8 5e f0 ff ff       	call   800c40 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801be2:	89 1c 24             	mov    %ebx,(%esp)
  801be5:	e8 9d f2 ff ff       	call   800e87 <fd2data>
  801bea:	83 c4 08             	add    $0x8,%esp
  801bed:	50                   	push   %eax
  801bee:	6a 00                	push   $0x0
  801bf0:	e8 4b f0 ff ff       	call   800c40 <sys_page_unmap>
}
  801bf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <_pipeisclosed>:
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	57                   	push   %edi
  801bfe:	56                   	push   %esi
  801bff:	53                   	push   %ebx
  801c00:	83 ec 1c             	sub    $0x1c,%esp
  801c03:	89 c7                	mov    %eax,%edi
  801c05:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c07:	a1 08 40 80 00       	mov    0x804008,%eax
  801c0c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	57                   	push   %edi
  801c13:	e8 c1 05 00 00       	call   8021d9 <pageref>
  801c18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c1b:	89 34 24             	mov    %esi,(%esp)
  801c1e:	e8 b6 05 00 00       	call   8021d9 <pageref>
		nn = thisenv->env_runs;
  801c23:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c29:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c2c:	83 c4 10             	add    $0x10,%esp
  801c2f:	39 cb                	cmp    %ecx,%ebx
  801c31:	74 1b                	je     801c4e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c33:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c36:	75 cf                	jne    801c07 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c38:	8b 42 58             	mov    0x58(%edx),%eax
  801c3b:	6a 01                	push   $0x1
  801c3d:	50                   	push   %eax
  801c3e:	53                   	push   %ebx
  801c3f:	68 ef 28 80 00       	push   $0x8028ef
  801c44:	e8 1e e5 ff ff       	call   800167 <cprintf>
  801c49:	83 c4 10             	add    $0x10,%esp
  801c4c:	eb b9                	jmp    801c07 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c4e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c51:	0f 94 c0             	sete   %al
  801c54:	0f b6 c0             	movzbl %al,%eax
}
  801c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c5a:	5b                   	pop    %ebx
  801c5b:	5e                   	pop    %esi
  801c5c:	5f                   	pop    %edi
  801c5d:	5d                   	pop    %ebp
  801c5e:	c3                   	ret    

00801c5f <devpipe_write>:
{
  801c5f:	f3 0f 1e fb          	endbr32 
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	57                   	push   %edi
  801c67:	56                   	push   %esi
  801c68:	53                   	push   %ebx
  801c69:	83 ec 28             	sub    $0x28,%esp
  801c6c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c6f:	56                   	push   %esi
  801c70:	e8 12 f2 ff ff       	call   800e87 <fd2data>
  801c75:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c77:	83 c4 10             	add    $0x10,%esp
  801c7a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c7f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c82:	74 4f                	je     801cd3 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c84:	8b 43 04             	mov    0x4(%ebx),%eax
  801c87:	8b 0b                	mov    (%ebx),%ecx
  801c89:	8d 51 20             	lea    0x20(%ecx),%edx
  801c8c:	39 d0                	cmp    %edx,%eax
  801c8e:	72 14                	jb     801ca4 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c90:	89 da                	mov    %ebx,%edx
  801c92:	89 f0                	mov    %esi,%eax
  801c94:	e8 61 ff ff ff       	call   801bfa <_pipeisclosed>
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	75 3b                	jne    801cd8 <devpipe_write+0x79>
			sys_yield();
  801c9d:	e8 ee ee ff ff       	call   800b90 <sys_yield>
  801ca2:	eb e0                	jmp    801c84 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ca4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ca7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cab:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cae:	89 c2                	mov    %eax,%edx
  801cb0:	c1 fa 1f             	sar    $0x1f,%edx
  801cb3:	89 d1                	mov    %edx,%ecx
  801cb5:	c1 e9 1b             	shr    $0x1b,%ecx
  801cb8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cbb:	83 e2 1f             	and    $0x1f,%edx
  801cbe:	29 ca                	sub    %ecx,%edx
  801cc0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cc4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cc8:	83 c0 01             	add    $0x1,%eax
  801ccb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cce:	83 c7 01             	add    $0x1,%edi
  801cd1:	eb ac                	jmp    801c7f <devpipe_write+0x20>
	return i;
  801cd3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd6:	eb 05                	jmp    801cdd <devpipe_write+0x7e>
				return 0;
  801cd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5e                   	pop    %esi
  801ce2:	5f                   	pop    %edi
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    

00801ce5 <devpipe_read>:
{
  801ce5:	f3 0f 1e fb          	endbr32 
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	57                   	push   %edi
  801ced:	56                   	push   %esi
  801cee:	53                   	push   %ebx
  801cef:	83 ec 18             	sub    $0x18,%esp
  801cf2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cf5:	57                   	push   %edi
  801cf6:	e8 8c f1 ff ff       	call   800e87 <fd2data>
  801cfb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cfd:	83 c4 10             	add    $0x10,%esp
  801d00:	be 00 00 00 00       	mov    $0x0,%esi
  801d05:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d08:	75 14                	jne    801d1e <devpipe_read+0x39>
	return i;
  801d0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0d:	eb 02                	jmp    801d11 <devpipe_read+0x2c>
				return i;
  801d0f:	89 f0                	mov    %esi,%eax
}
  801d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d14:	5b                   	pop    %ebx
  801d15:	5e                   	pop    %esi
  801d16:	5f                   	pop    %edi
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    
			sys_yield();
  801d19:	e8 72 ee ff ff       	call   800b90 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d1e:	8b 03                	mov    (%ebx),%eax
  801d20:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d23:	75 18                	jne    801d3d <devpipe_read+0x58>
			if (i > 0)
  801d25:	85 f6                	test   %esi,%esi
  801d27:	75 e6                	jne    801d0f <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d29:	89 da                	mov    %ebx,%edx
  801d2b:	89 f8                	mov    %edi,%eax
  801d2d:	e8 c8 fe ff ff       	call   801bfa <_pipeisclosed>
  801d32:	85 c0                	test   %eax,%eax
  801d34:	74 e3                	je     801d19 <devpipe_read+0x34>
				return 0;
  801d36:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3b:	eb d4                	jmp    801d11 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d3d:	99                   	cltd   
  801d3e:	c1 ea 1b             	shr    $0x1b,%edx
  801d41:	01 d0                	add    %edx,%eax
  801d43:	83 e0 1f             	and    $0x1f,%eax
  801d46:	29 d0                	sub    %edx,%eax
  801d48:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d50:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d53:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d56:	83 c6 01             	add    $0x1,%esi
  801d59:	eb aa                	jmp    801d05 <devpipe_read+0x20>

00801d5b <pipe>:
{
  801d5b:	f3 0f 1e fb          	endbr32 
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d67:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6a:	50                   	push   %eax
  801d6b:	e8 32 f1 ff ff       	call   800ea2 <fd_alloc>
  801d70:	89 c3                	mov    %eax,%ebx
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	85 c0                	test   %eax,%eax
  801d77:	0f 88 23 01 00 00    	js     801ea0 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d7d:	83 ec 04             	sub    $0x4,%esp
  801d80:	68 07 04 00 00       	push   $0x407
  801d85:	ff 75 f4             	pushl  -0xc(%ebp)
  801d88:	6a 00                	push   $0x0
  801d8a:	e8 24 ee ff ff       	call   800bb3 <sys_page_alloc>
  801d8f:	89 c3                	mov    %eax,%ebx
  801d91:	83 c4 10             	add    $0x10,%esp
  801d94:	85 c0                	test   %eax,%eax
  801d96:	0f 88 04 01 00 00    	js     801ea0 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d9c:	83 ec 0c             	sub    $0xc,%esp
  801d9f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801da2:	50                   	push   %eax
  801da3:	e8 fa f0 ff ff       	call   800ea2 <fd_alloc>
  801da8:	89 c3                	mov    %eax,%ebx
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	85 c0                	test   %eax,%eax
  801daf:	0f 88 db 00 00 00    	js     801e90 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801db5:	83 ec 04             	sub    $0x4,%esp
  801db8:	68 07 04 00 00       	push   $0x407
  801dbd:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc0:	6a 00                	push   $0x0
  801dc2:	e8 ec ed ff ff       	call   800bb3 <sys_page_alloc>
  801dc7:	89 c3                	mov    %eax,%ebx
  801dc9:	83 c4 10             	add    $0x10,%esp
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	0f 88 bc 00 00 00    	js     801e90 <pipe+0x135>
	va = fd2data(fd0);
  801dd4:	83 ec 0c             	sub    $0xc,%esp
  801dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dda:	e8 a8 f0 ff ff       	call   800e87 <fd2data>
  801ddf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801de1:	83 c4 0c             	add    $0xc,%esp
  801de4:	68 07 04 00 00       	push   $0x407
  801de9:	50                   	push   %eax
  801dea:	6a 00                	push   $0x0
  801dec:	e8 c2 ed ff ff       	call   800bb3 <sys_page_alloc>
  801df1:	89 c3                	mov    %eax,%ebx
  801df3:	83 c4 10             	add    $0x10,%esp
  801df6:	85 c0                	test   %eax,%eax
  801df8:	0f 88 82 00 00 00    	js     801e80 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dfe:	83 ec 0c             	sub    $0xc,%esp
  801e01:	ff 75 f0             	pushl  -0x10(%ebp)
  801e04:	e8 7e f0 ff ff       	call   800e87 <fd2data>
  801e09:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e10:	50                   	push   %eax
  801e11:	6a 00                	push   $0x0
  801e13:	56                   	push   %esi
  801e14:	6a 00                	push   $0x0
  801e16:	e8 df ed ff ff       	call   800bfa <sys_page_map>
  801e1b:	89 c3                	mov    %eax,%ebx
  801e1d:	83 c4 20             	add    $0x20,%esp
  801e20:	85 c0                	test   %eax,%eax
  801e22:	78 4e                	js     801e72 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e24:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801e29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e31:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e3b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e40:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e47:	83 ec 0c             	sub    $0xc,%esp
  801e4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4d:	e8 21 f0 ff ff       	call   800e73 <fd2num>
  801e52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e55:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e57:	83 c4 04             	add    $0x4,%esp
  801e5a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5d:	e8 11 f0 ff ff       	call   800e73 <fd2num>
  801e62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e65:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e70:	eb 2e                	jmp    801ea0 <pipe+0x145>
	sys_page_unmap(0, va);
  801e72:	83 ec 08             	sub    $0x8,%esp
  801e75:	56                   	push   %esi
  801e76:	6a 00                	push   $0x0
  801e78:	e8 c3 ed ff ff       	call   800c40 <sys_page_unmap>
  801e7d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e80:	83 ec 08             	sub    $0x8,%esp
  801e83:	ff 75 f0             	pushl  -0x10(%ebp)
  801e86:	6a 00                	push   $0x0
  801e88:	e8 b3 ed ff ff       	call   800c40 <sys_page_unmap>
  801e8d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e90:	83 ec 08             	sub    $0x8,%esp
  801e93:	ff 75 f4             	pushl  -0xc(%ebp)
  801e96:	6a 00                	push   $0x0
  801e98:	e8 a3 ed ff ff       	call   800c40 <sys_page_unmap>
  801e9d:	83 c4 10             	add    $0x10,%esp
}
  801ea0:	89 d8                	mov    %ebx,%eax
  801ea2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea5:	5b                   	pop    %ebx
  801ea6:	5e                   	pop    %esi
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    

00801ea9 <pipeisclosed>:
{
  801ea9:	f3 0f 1e fb          	endbr32 
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb6:	50                   	push   %eax
  801eb7:	ff 75 08             	pushl  0x8(%ebp)
  801eba:	e8 39 f0 ff ff       	call   800ef8 <fd_lookup>
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	78 18                	js     801ede <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801ec6:	83 ec 0c             	sub    $0xc,%esp
  801ec9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ecc:	e8 b6 ef ff ff       	call   800e87 <fd2data>
  801ed1:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	e8 1f fd ff ff       	call   801bfa <_pipeisclosed>
  801edb:	83 c4 10             	add    $0x10,%esp
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ee0:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee9:	c3                   	ret    

00801eea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eea:	f3 0f 1e fb          	endbr32 
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ef4:	68 07 29 80 00       	push   $0x802907
  801ef9:	ff 75 0c             	pushl  0xc(%ebp)
  801efc:	e8 70 e8 ff ff       	call   800771 <strcpy>
	return 0;
}
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <devcons_write>:
{
  801f08:	f3 0f 1e fb          	endbr32 
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	57                   	push   %edi
  801f10:	56                   	push   %esi
  801f11:	53                   	push   %ebx
  801f12:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f18:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f1d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f23:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f26:	73 31                	jae    801f59 <devcons_write+0x51>
		m = n - tot;
  801f28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f2b:	29 f3                	sub    %esi,%ebx
  801f2d:	83 fb 7f             	cmp    $0x7f,%ebx
  801f30:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f35:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	53                   	push   %ebx
  801f3c:	89 f0                	mov    %esi,%eax
  801f3e:	03 45 0c             	add    0xc(%ebp),%eax
  801f41:	50                   	push   %eax
  801f42:	57                   	push   %edi
  801f43:	e8 df e9 ff ff       	call   800927 <memmove>
		sys_cputs(buf, m);
  801f48:	83 c4 08             	add    $0x8,%esp
  801f4b:	53                   	push   %ebx
  801f4c:	57                   	push   %edi
  801f4d:	e8 91 eb ff ff       	call   800ae3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f52:	01 de                	add    %ebx,%esi
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	eb ca                	jmp    801f23 <devcons_write+0x1b>
}
  801f59:	89 f0                	mov    %esi,%eax
  801f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f5e:	5b                   	pop    %ebx
  801f5f:	5e                   	pop    %esi
  801f60:	5f                   	pop    %edi
  801f61:	5d                   	pop    %ebp
  801f62:	c3                   	ret    

00801f63 <devcons_read>:
{
  801f63:	f3 0f 1e fb          	endbr32 
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 08             	sub    $0x8,%esp
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f76:	74 21                	je     801f99 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f78:	e8 88 eb ff ff       	call   800b05 <sys_cgetc>
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	75 07                	jne    801f88 <devcons_read+0x25>
		sys_yield();
  801f81:	e8 0a ec ff ff       	call   800b90 <sys_yield>
  801f86:	eb f0                	jmp    801f78 <devcons_read+0x15>
	if (c < 0)
  801f88:	78 0f                	js     801f99 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f8a:	83 f8 04             	cmp    $0x4,%eax
  801f8d:	74 0c                	je     801f9b <devcons_read+0x38>
	*(char*)vbuf = c;
  801f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f92:	88 02                	mov    %al,(%edx)
	return 1;
  801f94:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    
		return 0;
  801f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa0:	eb f7                	jmp    801f99 <devcons_read+0x36>

00801fa2 <cputchar>:
{
  801fa2:	f3 0f 1e fb          	endbr32 
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fb2:	6a 01                	push   $0x1
  801fb4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fb7:	50                   	push   %eax
  801fb8:	e8 26 eb ff ff       	call   800ae3 <sys_cputs>
}
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <getchar>:
{
  801fc2:	f3 0f 1e fb          	endbr32 
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fcc:	6a 01                	push   $0x1
  801fce:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fd1:	50                   	push   %eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	e8 a7 f1 ff ff       	call   801180 <read>
	if (r < 0)
  801fd9:	83 c4 10             	add    $0x10,%esp
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	78 06                	js     801fe6 <getchar+0x24>
	if (r < 1)
  801fe0:	74 06                	je     801fe8 <getchar+0x26>
	return c;
  801fe2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    
		return -E_EOF;
  801fe8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fed:	eb f7                	jmp    801fe6 <getchar+0x24>

00801fef <iscons>:
{
  801fef:	f3 0f 1e fb          	endbr32 
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ffc:	50                   	push   %eax
  801ffd:	ff 75 08             	pushl  0x8(%ebp)
  802000:	e8 f3 ee ff ff       	call   800ef8 <fd_lookup>
  802005:	83 c4 10             	add    $0x10,%esp
  802008:	85 c0                	test   %eax,%eax
  80200a:	78 11                	js     80201d <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802015:	39 10                	cmp    %edx,(%eax)
  802017:	0f 94 c0             	sete   %al
  80201a:	0f b6 c0             	movzbl %al,%eax
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <opencons>:
{
  80201f:	f3 0f 1e fb          	endbr32 
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802029:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80202c:	50                   	push   %eax
  80202d:	e8 70 ee ff ff       	call   800ea2 <fd_alloc>
  802032:	83 c4 10             	add    $0x10,%esp
  802035:	85 c0                	test   %eax,%eax
  802037:	78 3a                	js     802073 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	68 07 04 00 00       	push   $0x407
  802041:	ff 75 f4             	pushl  -0xc(%ebp)
  802044:	6a 00                	push   $0x0
  802046:	e8 68 eb ff ff       	call   800bb3 <sys_page_alloc>
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	85 c0                	test   %eax,%eax
  802050:	78 21                	js     802073 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80205b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802067:	83 ec 0c             	sub    $0xc,%esp
  80206a:	50                   	push   %eax
  80206b:	e8 03 ee ff ff       	call   800e73 <fd2num>
  802070:	83 c4 10             	add    $0x10,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802075:	f3 0f 1e fb          	endbr32 
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	56                   	push   %esi
  80207d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80207e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802081:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802087:	e8 e1 ea ff ff       	call   800b6d <sys_getenvid>
  80208c:	83 ec 0c             	sub    $0xc,%esp
  80208f:	ff 75 0c             	pushl  0xc(%ebp)
  802092:	ff 75 08             	pushl  0x8(%ebp)
  802095:	56                   	push   %esi
  802096:	50                   	push   %eax
  802097:	68 14 29 80 00       	push   $0x802914
  80209c:	e8 c6 e0 ff ff       	call   800167 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8020a1:	83 c4 18             	add    $0x18,%esp
  8020a4:	53                   	push   %ebx
  8020a5:	ff 75 10             	pushl  0x10(%ebp)
  8020a8:	e8 65 e0 ff ff       	call   800112 <vcprintf>
	cprintf("\n");
  8020ad:	c7 04 24 50 29 80 00 	movl   $0x802950,(%esp)
  8020b4:	e8 ae e0 ff ff       	call   800167 <cprintf>
  8020b9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020bc:	cc                   	int3   
  8020bd:	eb fd                	jmp    8020bc <_panic+0x47>

008020bf <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020bf:	f3 0f 1e fb          	endbr32 
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	56                   	push   %esi
  8020c7:	53                   	push   %ebx
  8020c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8020cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	74 3d                	je     802112 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	50                   	push   %eax
  8020d9:	e8 a1 ec ff ff       	call   800d7f <sys_ipc_recv>
  8020de:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020e1:	85 f6                	test   %esi,%esi
  8020e3:	74 0b                	je     8020f0 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020e5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020eb:	8b 52 74             	mov    0x74(%edx),%edx
  8020ee:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020f0:	85 db                	test   %ebx,%ebx
  8020f2:	74 0b                	je     8020ff <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020f4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020fa:	8b 52 78             	mov    0x78(%edx),%edx
  8020fd:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8020ff:	85 c0                	test   %eax,%eax
  802101:	78 21                	js     802124 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802103:	a1 08 40 80 00       	mov    0x804008,%eax
  802108:	8b 40 70             	mov    0x70(%eax),%eax
}
  80210b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210e:	5b                   	pop    %ebx
  80210f:	5e                   	pop    %esi
  802110:	5d                   	pop    %ebp
  802111:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802112:	83 ec 0c             	sub    $0xc,%esp
  802115:	68 00 00 c0 ee       	push   $0xeec00000
  80211a:	e8 60 ec ff ff       	call   800d7f <sys_ipc_recv>
  80211f:	83 c4 10             	add    $0x10,%esp
  802122:	eb bd                	jmp    8020e1 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802124:	85 f6                	test   %esi,%esi
  802126:	74 10                	je     802138 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802128:	85 db                	test   %ebx,%ebx
  80212a:	75 df                	jne    80210b <ipc_recv+0x4c>
  80212c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802133:	00 00 00 
  802136:	eb d3                	jmp    80210b <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802138:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80213f:	00 00 00 
  802142:	eb e4                	jmp    802128 <ipc_recv+0x69>

00802144 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802144:	f3 0f 1e fb          	endbr32 
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	57                   	push   %edi
  80214c:	56                   	push   %esi
  80214d:	53                   	push   %ebx
  80214e:	83 ec 0c             	sub    $0xc,%esp
  802151:	8b 7d 08             	mov    0x8(%ebp),%edi
  802154:	8b 75 0c             	mov    0xc(%ebp),%esi
  802157:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80215a:	85 db                	test   %ebx,%ebx
  80215c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802161:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802164:	ff 75 14             	pushl  0x14(%ebp)
  802167:	53                   	push   %ebx
  802168:	56                   	push   %esi
  802169:	57                   	push   %edi
  80216a:	e8 e9 eb ff ff       	call   800d58 <sys_ipc_try_send>
  80216f:	83 c4 10             	add    $0x10,%esp
  802172:	85 c0                	test   %eax,%eax
  802174:	79 1e                	jns    802194 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802176:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802179:	75 07                	jne    802182 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80217b:	e8 10 ea ff ff       	call   800b90 <sys_yield>
  802180:	eb e2                	jmp    802164 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802182:	50                   	push   %eax
  802183:	68 37 29 80 00       	push   $0x802937
  802188:	6a 59                	push   $0x59
  80218a:	68 52 29 80 00       	push   $0x802952
  80218f:	e8 e1 fe ff ff       	call   802075 <_panic>
	}
}
  802194:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802197:	5b                   	pop    %ebx
  802198:	5e                   	pop    %esi
  802199:	5f                   	pop    %edi
  80219a:	5d                   	pop    %ebp
  80219b:	c3                   	ret    

0080219c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80219c:	f3 0f 1e fb          	endbr32 
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021a6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021ab:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021ae:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021b4:	8b 52 50             	mov    0x50(%edx),%edx
  8021b7:	39 ca                	cmp    %ecx,%edx
  8021b9:	74 11                	je     8021cc <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021bb:	83 c0 01             	add    $0x1,%eax
  8021be:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021c3:	75 e6                	jne    8021ab <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ca:	eb 0b                	jmp    8021d7 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021cc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021cf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021d4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021d7:	5d                   	pop    %ebp
  8021d8:	c3                   	ret    

008021d9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021d9:	f3 0f 1e fb          	endbr32 
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021e3:	89 c2                	mov    %eax,%edx
  8021e5:	c1 ea 16             	shr    $0x16,%edx
  8021e8:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021ef:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021f4:	f6 c1 01             	test   $0x1,%cl
  8021f7:	74 1c                	je     802215 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021f9:	c1 e8 0c             	shr    $0xc,%eax
  8021fc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802203:	a8 01                	test   $0x1,%al
  802205:	74 0e                	je     802215 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802207:	c1 e8 0c             	shr    $0xc,%eax
  80220a:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802211:	ef 
  802212:	0f b7 d2             	movzwl %dx,%edx
}
  802215:	89 d0                	mov    %edx,%eax
  802217:	5d                   	pop    %ebp
  802218:	c3                   	ret    
  802219:	66 90                	xchg   %ax,%ax
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
