
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
  80003d:	68 20 1f 80 00       	push   $0x801f20
  800042:	e8 20 01 00 00       	call   800167 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800047:	a1 04 40 80 00       	mov    0x804004,%eax
  80004c:	8b 40 48             	mov    0x48(%eax),%eax
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	50                   	push   %eax
  800053:	68 2e 1f 80 00       	push   $0x801f2e
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
  800083:	a3 04 40 80 00       	mov    %eax,0x804004

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
  8000b6:	e8 f8 0e 00 00       	call   800fb3 <close_all>
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
  8001cd:	e8 de 1a 00 00       	call   801cb0 <__udivdi3>
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
  80020b:	e8 b0 1b 00 00       	call   801dc0 <__umoddi3>
  800210:	83 c4 14             	add    $0x14,%esp
  800213:	0f be 80 4f 1f 80 00 	movsbl 0x801f4f(%eax),%eax
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
  8002ba:	3e ff 24 85 a0 20 80 	notrack jmp *0x8020a0(,%eax,4)
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
  800387:	8b 14 85 00 22 80 00 	mov    0x802200(,%eax,4),%edx
  80038e:	85 d2                	test   %edx,%edx
  800390:	74 18                	je     8003aa <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800392:	52                   	push   %edx
  800393:	68 31 23 80 00       	push   $0x802331
  800398:	53                   	push   %ebx
  800399:	56                   	push   %esi
  80039a:	e8 aa fe ff ff       	call   800249 <printfmt>
  80039f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a5:	e9 66 02 00 00       	jmp    800610 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003aa:	50                   	push   %eax
  8003ab:	68 67 1f 80 00       	push   $0x801f67
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
  8003d2:	b8 60 1f 80 00       	mov    $0x801f60,%eax
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
  800b5c:	68 5f 22 80 00       	push   $0x80225f
  800b61:	6a 23                	push   $0x23
  800b63:	68 7c 22 80 00       	push   $0x80227c
  800b68:	e8 9c 0f 00 00       	call   801b09 <_panic>

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
  800be9:	68 5f 22 80 00       	push   $0x80225f
  800bee:	6a 23                	push   $0x23
  800bf0:	68 7c 22 80 00       	push   $0x80227c
  800bf5:	e8 0f 0f 00 00       	call   801b09 <_panic>

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
  800c2f:	68 5f 22 80 00       	push   $0x80225f
  800c34:	6a 23                	push   $0x23
  800c36:	68 7c 22 80 00       	push   $0x80227c
  800c3b:	e8 c9 0e 00 00       	call   801b09 <_panic>

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
  800c75:	68 5f 22 80 00       	push   $0x80225f
  800c7a:	6a 23                	push   $0x23
  800c7c:	68 7c 22 80 00       	push   $0x80227c
  800c81:	e8 83 0e 00 00       	call   801b09 <_panic>

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
  800cbb:	68 5f 22 80 00       	push   $0x80225f
  800cc0:	6a 23                	push   $0x23
  800cc2:	68 7c 22 80 00       	push   $0x80227c
  800cc7:	e8 3d 0e 00 00       	call   801b09 <_panic>

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
  800d01:	68 5f 22 80 00       	push   $0x80225f
  800d06:	6a 23                	push   $0x23
  800d08:	68 7c 22 80 00       	push   $0x80227c
  800d0d:	e8 f7 0d 00 00       	call   801b09 <_panic>

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
  800d47:	68 5f 22 80 00       	push   $0x80225f
  800d4c:	6a 23                	push   $0x23
  800d4e:	68 7c 22 80 00       	push   $0x80227c
  800d53:	e8 b1 0d 00 00       	call   801b09 <_panic>

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
  800db3:	68 5f 22 80 00       	push   $0x80225f
  800db8:	6a 23                	push   $0x23
  800dba:	68 7c 22 80 00       	push   $0x80227c
  800dbf:	e8 45 0d 00 00       	call   801b09 <_panic>

00800dc4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800dc4:	f3 0f 1e fb          	endbr32 
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	05 00 00 00 30       	add    $0x30000000,%eax
  800dd3:	c1 e8 0c             	shr    $0xc,%eax
}
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800dd8:	f3 0f 1e fb          	endbr32 
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800de7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dec:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800df3:	f3 0f 1e fb          	endbr32 
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800dff:	89 c2                	mov    %eax,%edx
  800e01:	c1 ea 16             	shr    $0x16,%edx
  800e04:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e0b:	f6 c2 01             	test   $0x1,%dl
  800e0e:	74 2d                	je     800e3d <fd_alloc+0x4a>
  800e10:	89 c2                	mov    %eax,%edx
  800e12:	c1 ea 0c             	shr    $0xc,%edx
  800e15:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e1c:	f6 c2 01             	test   $0x1,%dl
  800e1f:	74 1c                	je     800e3d <fd_alloc+0x4a>
  800e21:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e26:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e2b:	75 d2                	jne    800dff <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e36:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e3b:	eb 0a                	jmp    800e47 <fd_alloc+0x54>
			*fd_store = fd;
  800e3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e40:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e49:	f3 0f 1e fb          	endbr32 
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e53:	83 f8 1f             	cmp    $0x1f,%eax
  800e56:	77 30                	ja     800e88 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e58:	c1 e0 0c             	shl    $0xc,%eax
  800e5b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e60:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e66:	f6 c2 01             	test   $0x1,%dl
  800e69:	74 24                	je     800e8f <fd_lookup+0x46>
  800e6b:	89 c2                	mov    %eax,%edx
  800e6d:	c1 ea 0c             	shr    $0xc,%edx
  800e70:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e77:	f6 c2 01             	test   $0x1,%dl
  800e7a:	74 1a                	je     800e96 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7f:	89 02                	mov    %eax,(%edx)
	return 0;
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    
		return -E_INVAL;
  800e88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e8d:	eb f7                	jmp    800e86 <fd_lookup+0x3d>
		return -E_INVAL;
  800e8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e94:	eb f0                	jmp    800e86 <fd_lookup+0x3d>
  800e96:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e9b:	eb e9                	jmp    800e86 <fd_lookup+0x3d>

00800e9d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e9d:	f3 0f 1e fb          	endbr32 
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	83 ec 08             	sub    $0x8,%esp
  800ea7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eaa:	ba 08 23 80 00       	mov    $0x802308,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800eaf:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800eb4:	39 08                	cmp    %ecx,(%eax)
  800eb6:	74 33                	je     800eeb <dev_lookup+0x4e>
  800eb8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ebb:	8b 02                	mov    (%edx),%eax
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	75 f3                	jne    800eb4 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ec1:	a1 04 40 80 00       	mov    0x804004,%eax
  800ec6:	8b 40 48             	mov    0x48(%eax),%eax
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	51                   	push   %ecx
  800ecd:	50                   	push   %eax
  800ece:	68 8c 22 80 00       	push   $0x80228c
  800ed3:	e8 8f f2 ff ff       	call   800167 <cprintf>
	*dev = 0;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ee1:	83 c4 10             	add    $0x10,%esp
  800ee4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ee9:	c9                   	leave  
  800eea:	c3                   	ret    
			*dev = devtab[i];
  800eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eee:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef5:	eb f2                	jmp    800ee9 <dev_lookup+0x4c>

00800ef7 <fd_close>:
{
  800ef7:	f3 0f 1e fb          	endbr32 
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	57                   	push   %edi
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
  800f01:	83 ec 24             	sub    $0x24,%esp
  800f04:	8b 75 08             	mov    0x8(%ebp),%esi
  800f07:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f0a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f0d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f0e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f14:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f17:	50                   	push   %eax
  800f18:	e8 2c ff ff ff       	call   800e49 <fd_lookup>
  800f1d:	89 c3                	mov    %eax,%ebx
  800f1f:	83 c4 10             	add    $0x10,%esp
  800f22:	85 c0                	test   %eax,%eax
  800f24:	78 05                	js     800f2b <fd_close+0x34>
	    || fd != fd2)
  800f26:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f29:	74 16                	je     800f41 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f2b:	89 f8                	mov    %edi,%eax
  800f2d:	84 c0                	test   %al,%al
  800f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f34:	0f 44 d8             	cmove  %eax,%ebx
}
  800f37:	89 d8                	mov    %ebx,%eax
  800f39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f41:	83 ec 08             	sub    $0x8,%esp
  800f44:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f47:	50                   	push   %eax
  800f48:	ff 36                	pushl  (%esi)
  800f4a:	e8 4e ff ff ff       	call   800e9d <dev_lookup>
  800f4f:	89 c3                	mov    %eax,%ebx
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	85 c0                	test   %eax,%eax
  800f56:	78 1a                	js     800f72 <fd_close+0x7b>
		if (dev->dev_close)
  800f58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f5b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f63:	85 c0                	test   %eax,%eax
  800f65:	74 0b                	je     800f72 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f67:	83 ec 0c             	sub    $0xc,%esp
  800f6a:	56                   	push   %esi
  800f6b:	ff d0                	call   *%eax
  800f6d:	89 c3                	mov    %eax,%ebx
  800f6f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f72:	83 ec 08             	sub    $0x8,%esp
  800f75:	56                   	push   %esi
  800f76:	6a 00                	push   $0x0
  800f78:	e8 c3 fc ff ff       	call   800c40 <sys_page_unmap>
	return r;
  800f7d:	83 c4 10             	add    $0x10,%esp
  800f80:	eb b5                	jmp    800f37 <fd_close+0x40>

00800f82 <close>:

int
close(int fdnum)
{
  800f82:	f3 0f 1e fb          	endbr32 
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f8f:	50                   	push   %eax
  800f90:	ff 75 08             	pushl  0x8(%ebp)
  800f93:	e8 b1 fe ff ff       	call   800e49 <fd_lookup>
  800f98:	83 c4 10             	add    $0x10,%esp
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	79 02                	jns    800fa1 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    
		return fd_close(fd, 1);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	6a 01                	push   $0x1
  800fa6:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa9:	e8 49 ff ff ff       	call   800ef7 <fd_close>
  800fae:	83 c4 10             	add    $0x10,%esp
  800fb1:	eb ec                	jmp    800f9f <close+0x1d>

00800fb3 <close_all>:

void
close_all(void)
{
  800fb3:	f3 0f 1e fb          	endbr32 
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	53                   	push   %ebx
  800fbb:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fbe:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fc3:	83 ec 0c             	sub    $0xc,%esp
  800fc6:	53                   	push   %ebx
  800fc7:	e8 b6 ff ff ff       	call   800f82 <close>
	for (i = 0; i < MAXFD; i++)
  800fcc:	83 c3 01             	add    $0x1,%ebx
  800fcf:	83 c4 10             	add    $0x10,%esp
  800fd2:	83 fb 20             	cmp    $0x20,%ebx
  800fd5:	75 ec                	jne    800fc3 <close_all+0x10>
}
  800fd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fdc:	f3 0f 1e fb          	endbr32 
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	57                   	push   %edi
  800fe4:	56                   	push   %esi
  800fe5:	53                   	push   %ebx
  800fe6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fe9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fec:	50                   	push   %eax
  800fed:	ff 75 08             	pushl  0x8(%ebp)
  800ff0:	e8 54 fe ff ff       	call   800e49 <fd_lookup>
  800ff5:	89 c3                	mov    %eax,%ebx
  800ff7:	83 c4 10             	add    $0x10,%esp
  800ffa:	85 c0                	test   %eax,%eax
  800ffc:	0f 88 81 00 00 00    	js     801083 <dup+0xa7>
		return r;
	close(newfdnum);
  801002:	83 ec 0c             	sub    $0xc,%esp
  801005:	ff 75 0c             	pushl  0xc(%ebp)
  801008:	e8 75 ff ff ff       	call   800f82 <close>

	newfd = INDEX2FD(newfdnum);
  80100d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801010:	c1 e6 0c             	shl    $0xc,%esi
  801013:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801019:	83 c4 04             	add    $0x4,%esp
  80101c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80101f:	e8 b4 fd ff ff       	call   800dd8 <fd2data>
  801024:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801026:	89 34 24             	mov    %esi,(%esp)
  801029:	e8 aa fd ff ff       	call   800dd8 <fd2data>
  80102e:	83 c4 10             	add    $0x10,%esp
  801031:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801033:	89 d8                	mov    %ebx,%eax
  801035:	c1 e8 16             	shr    $0x16,%eax
  801038:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80103f:	a8 01                	test   $0x1,%al
  801041:	74 11                	je     801054 <dup+0x78>
  801043:	89 d8                	mov    %ebx,%eax
  801045:	c1 e8 0c             	shr    $0xc,%eax
  801048:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80104f:	f6 c2 01             	test   $0x1,%dl
  801052:	75 39                	jne    80108d <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801054:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801057:	89 d0                	mov    %edx,%eax
  801059:	c1 e8 0c             	shr    $0xc,%eax
  80105c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801063:	83 ec 0c             	sub    $0xc,%esp
  801066:	25 07 0e 00 00       	and    $0xe07,%eax
  80106b:	50                   	push   %eax
  80106c:	56                   	push   %esi
  80106d:	6a 00                	push   $0x0
  80106f:	52                   	push   %edx
  801070:	6a 00                	push   $0x0
  801072:	e8 83 fb ff ff       	call   800bfa <sys_page_map>
  801077:	89 c3                	mov    %eax,%ebx
  801079:	83 c4 20             	add    $0x20,%esp
  80107c:	85 c0                	test   %eax,%eax
  80107e:	78 31                	js     8010b1 <dup+0xd5>
		goto err;

	return newfdnum;
  801080:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801083:	89 d8                	mov    %ebx,%eax
  801085:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801088:	5b                   	pop    %ebx
  801089:	5e                   	pop    %esi
  80108a:	5f                   	pop    %edi
  80108b:	5d                   	pop    %ebp
  80108c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80108d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801094:	83 ec 0c             	sub    $0xc,%esp
  801097:	25 07 0e 00 00       	and    $0xe07,%eax
  80109c:	50                   	push   %eax
  80109d:	57                   	push   %edi
  80109e:	6a 00                	push   $0x0
  8010a0:	53                   	push   %ebx
  8010a1:	6a 00                	push   $0x0
  8010a3:	e8 52 fb ff ff       	call   800bfa <sys_page_map>
  8010a8:	89 c3                	mov    %eax,%ebx
  8010aa:	83 c4 20             	add    $0x20,%esp
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	79 a3                	jns    801054 <dup+0x78>
	sys_page_unmap(0, newfd);
  8010b1:	83 ec 08             	sub    $0x8,%esp
  8010b4:	56                   	push   %esi
  8010b5:	6a 00                	push   $0x0
  8010b7:	e8 84 fb ff ff       	call   800c40 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010bc:	83 c4 08             	add    $0x8,%esp
  8010bf:	57                   	push   %edi
  8010c0:	6a 00                	push   $0x0
  8010c2:	e8 79 fb ff ff       	call   800c40 <sys_page_unmap>
	return r;
  8010c7:	83 c4 10             	add    $0x10,%esp
  8010ca:	eb b7                	jmp    801083 <dup+0xa7>

008010cc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010cc:	f3 0f 1e fb          	endbr32 
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	53                   	push   %ebx
  8010d4:	83 ec 1c             	sub    $0x1c,%esp
  8010d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010dd:	50                   	push   %eax
  8010de:	53                   	push   %ebx
  8010df:	e8 65 fd ff ff       	call   800e49 <fd_lookup>
  8010e4:	83 c4 10             	add    $0x10,%esp
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	78 3f                	js     80112a <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010eb:	83 ec 08             	sub    $0x8,%esp
  8010ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010f1:	50                   	push   %eax
  8010f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f5:	ff 30                	pushl  (%eax)
  8010f7:	e8 a1 fd ff ff       	call   800e9d <dev_lookup>
  8010fc:	83 c4 10             	add    $0x10,%esp
  8010ff:	85 c0                	test   %eax,%eax
  801101:	78 27                	js     80112a <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801103:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801106:	8b 42 08             	mov    0x8(%edx),%eax
  801109:	83 e0 03             	and    $0x3,%eax
  80110c:	83 f8 01             	cmp    $0x1,%eax
  80110f:	74 1e                	je     80112f <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801114:	8b 40 08             	mov    0x8(%eax),%eax
  801117:	85 c0                	test   %eax,%eax
  801119:	74 35                	je     801150 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80111b:	83 ec 04             	sub    $0x4,%esp
  80111e:	ff 75 10             	pushl  0x10(%ebp)
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	52                   	push   %edx
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
}
  80112a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80112f:	a1 04 40 80 00       	mov    0x804004,%eax
  801134:	8b 40 48             	mov    0x48(%eax),%eax
  801137:	83 ec 04             	sub    $0x4,%esp
  80113a:	53                   	push   %ebx
  80113b:	50                   	push   %eax
  80113c:	68 cd 22 80 00       	push   $0x8022cd
  801141:	e8 21 f0 ff ff       	call   800167 <cprintf>
		return -E_INVAL;
  801146:	83 c4 10             	add    $0x10,%esp
  801149:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80114e:	eb da                	jmp    80112a <read+0x5e>
		return -E_NOT_SUPP;
  801150:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801155:	eb d3                	jmp    80112a <read+0x5e>

00801157 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801157:	f3 0f 1e fb          	endbr32 
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	57                   	push   %edi
  80115f:	56                   	push   %esi
  801160:	53                   	push   %ebx
  801161:	83 ec 0c             	sub    $0xc,%esp
  801164:	8b 7d 08             	mov    0x8(%ebp),%edi
  801167:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80116a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116f:	eb 02                	jmp    801173 <readn+0x1c>
  801171:	01 c3                	add    %eax,%ebx
  801173:	39 f3                	cmp    %esi,%ebx
  801175:	73 21                	jae    801198 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801177:	83 ec 04             	sub    $0x4,%esp
  80117a:	89 f0                	mov    %esi,%eax
  80117c:	29 d8                	sub    %ebx,%eax
  80117e:	50                   	push   %eax
  80117f:	89 d8                	mov    %ebx,%eax
  801181:	03 45 0c             	add    0xc(%ebp),%eax
  801184:	50                   	push   %eax
  801185:	57                   	push   %edi
  801186:	e8 41 ff ff ff       	call   8010cc <read>
		if (m < 0)
  80118b:	83 c4 10             	add    $0x10,%esp
  80118e:	85 c0                	test   %eax,%eax
  801190:	78 04                	js     801196 <readn+0x3f>
			return m;
		if (m == 0)
  801192:	75 dd                	jne    801171 <readn+0x1a>
  801194:	eb 02                	jmp    801198 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801196:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801198:	89 d8                	mov    %ebx,%eax
  80119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119d:	5b                   	pop    %ebx
  80119e:	5e                   	pop    %esi
  80119f:	5f                   	pop    %edi
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    

008011a2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011a2:	f3 0f 1e fb          	endbr32 
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	53                   	push   %ebx
  8011aa:	83 ec 1c             	sub    $0x1c,%esp
  8011ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b3:	50                   	push   %eax
  8011b4:	53                   	push   %ebx
  8011b5:	e8 8f fc ff ff       	call   800e49 <fd_lookup>
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	78 3a                	js     8011fb <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011c1:	83 ec 08             	sub    $0x8,%esp
  8011c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c7:	50                   	push   %eax
  8011c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cb:	ff 30                	pushl  (%eax)
  8011cd:	e8 cb fc ff ff       	call   800e9d <dev_lookup>
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	78 22                	js     8011fb <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011dc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011e0:	74 1e                	je     801200 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e5:	8b 52 0c             	mov    0xc(%edx),%edx
  8011e8:	85 d2                	test   %edx,%edx
  8011ea:	74 35                	je     801221 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011ec:	83 ec 04             	sub    $0x4,%esp
  8011ef:	ff 75 10             	pushl  0x10(%ebp)
  8011f2:	ff 75 0c             	pushl  0xc(%ebp)
  8011f5:	50                   	push   %eax
  8011f6:	ff d2                	call   *%edx
  8011f8:	83 c4 10             	add    $0x10,%esp
}
  8011fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801200:	a1 04 40 80 00       	mov    0x804004,%eax
  801205:	8b 40 48             	mov    0x48(%eax),%eax
  801208:	83 ec 04             	sub    $0x4,%esp
  80120b:	53                   	push   %ebx
  80120c:	50                   	push   %eax
  80120d:	68 e9 22 80 00       	push   $0x8022e9
  801212:	e8 50 ef ff ff       	call   800167 <cprintf>
		return -E_INVAL;
  801217:	83 c4 10             	add    $0x10,%esp
  80121a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121f:	eb da                	jmp    8011fb <write+0x59>
		return -E_NOT_SUPP;
  801221:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801226:	eb d3                	jmp    8011fb <write+0x59>

00801228 <seek>:

int
seek(int fdnum, off_t offset)
{
  801228:	f3 0f 1e fb          	endbr32 
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801232:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801235:	50                   	push   %eax
  801236:	ff 75 08             	pushl  0x8(%ebp)
  801239:	e8 0b fc ff ff       	call   800e49 <fd_lookup>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	85 c0                	test   %eax,%eax
  801243:	78 0e                	js     801253 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801245:	8b 55 0c             	mov    0xc(%ebp),%edx
  801248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801253:	c9                   	leave  
  801254:	c3                   	ret    

00801255 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801255:	f3 0f 1e fb          	endbr32 
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	53                   	push   %ebx
  80125d:	83 ec 1c             	sub    $0x1c,%esp
  801260:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801263:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801266:	50                   	push   %eax
  801267:	53                   	push   %ebx
  801268:	e8 dc fb ff ff       	call   800e49 <fd_lookup>
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	78 37                	js     8012ab <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127a:	50                   	push   %eax
  80127b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127e:	ff 30                	pushl  (%eax)
  801280:	e8 18 fc ff ff       	call   800e9d <dev_lookup>
  801285:	83 c4 10             	add    $0x10,%esp
  801288:	85 c0                	test   %eax,%eax
  80128a:	78 1f                	js     8012ab <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80128c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801293:	74 1b                	je     8012b0 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801298:	8b 52 18             	mov    0x18(%edx),%edx
  80129b:	85 d2                	test   %edx,%edx
  80129d:	74 32                	je     8012d1 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	ff 75 0c             	pushl  0xc(%ebp)
  8012a5:	50                   	push   %eax
  8012a6:	ff d2                	call   *%edx
  8012a8:	83 c4 10             	add    $0x10,%esp
}
  8012ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012b0:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012b5:	8b 40 48             	mov    0x48(%eax),%eax
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	53                   	push   %ebx
  8012bc:	50                   	push   %eax
  8012bd:	68 ac 22 80 00       	push   $0x8022ac
  8012c2:	e8 a0 ee ff ff       	call   800167 <cprintf>
		return -E_INVAL;
  8012c7:	83 c4 10             	add    $0x10,%esp
  8012ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012cf:	eb da                	jmp    8012ab <ftruncate+0x56>
		return -E_NOT_SUPP;
  8012d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012d6:	eb d3                	jmp    8012ab <ftruncate+0x56>

008012d8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012d8:	f3 0f 1e fb          	endbr32 
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	53                   	push   %ebx
  8012e0:	83 ec 1c             	sub    $0x1c,%esp
  8012e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e9:	50                   	push   %eax
  8012ea:	ff 75 08             	pushl  0x8(%ebp)
  8012ed:	e8 57 fb ff ff       	call   800e49 <fd_lookup>
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	78 4b                	js     801344 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012f9:	83 ec 08             	sub    $0x8,%esp
  8012fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ff:	50                   	push   %eax
  801300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801303:	ff 30                	pushl  (%eax)
  801305:	e8 93 fb ff ff       	call   800e9d <dev_lookup>
  80130a:	83 c4 10             	add    $0x10,%esp
  80130d:	85 c0                	test   %eax,%eax
  80130f:	78 33                	js     801344 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801314:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801318:	74 2f                	je     801349 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80131a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80131d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801324:	00 00 00 
	stat->st_isdir = 0;
  801327:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80132e:	00 00 00 
	stat->st_dev = dev;
  801331:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801337:	83 ec 08             	sub    $0x8,%esp
  80133a:	53                   	push   %ebx
  80133b:	ff 75 f0             	pushl  -0x10(%ebp)
  80133e:	ff 50 14             	call   *0x14(%eax)
  801341:	83 c4 10             	add    $0x10,%esp
}
  801344:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801347:	c9                   	leave  
  801348:	c3                   	ret    
		return -E_NOT_SUPP;
  801349:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80134e:	eb f4                	jmp    801344 <fstat+0x6c>

00801350 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801350:	f3 0f 1e fb          	endbr32 
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	56                   	push   %esi
  801358:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801359:	83 ec 08             	sub    $0x8,%esp
  80135c:	6a 00                	push   $0x0
  80135e:	ff 75 08             	pushl  0x8(%ebp)
  801361:	e8 fb 01 00 00       	call   801561 <open>
  801366:	89 c3                	mov    %eax,%ebx
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	78 1b                	js     80138a <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80136f:	83 ec 08             	sub    $0x8,%esp
  801372:	ff 75 0c             	pushl  0xc(%ebp)
  801375:	50                   	push   %eax
  801376:	e8 5d ff ff ff       	call   8012d8 <fstat>
  80137b:	89 c6                	mov    %eax,%esi
	close(fd);
  80137d:	89 1c 24             	mov    %ebx,(%esp)
  801380:	e8 fd fb ff ff       	call   800f82 <close>
	return r;
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	89 f3                	mov    %esi,%ebx
}
  80138a:	89 d8                	mov    %ebx,%eax
  80138c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80138f:	5b                   	pop    %ebx
  801390:	5e                   	pop    %esi
  801391:	5d                   	pop    %ebp
  801392:	c3                   	ret    

00801393 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	56                   	push   %esi
  801397:	53                   	push   %ebx
  801398:	89 c6                	mov    %eax,%esi
  80139a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80139c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013a3:	74 27                	je     8013cc <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013a5:	6a 07                	push   $0x7
  8013a7:	68 00 50 80 00       	push   $0x805000
  8013ac:	56                   	push   %esi
  8013ad:	ff 35 00 40 80 00    	pushl  0x804000
  8013b3:	e8 20 08 00 00       	call   801bd8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013b8:	83 c4 0c             	add    $0xc,%esp
  8013bb:	6a 00                	push   $0x0
  8013bd:	53                   	push   %ebx
  8013be:	6a 00                	push   $0x0
  8013c0:	e8 8e 07 00 00       	call   801b53 <ipc_recv>
}
  8013c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c8:	5b                   	pop    %ebx
  8013c9:	5e                   	pop    %esi
  8013ca:	5d                   	pop    %ebp
  8013cb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013cc:	83 ec 0c             	sub    $0xc,%esp
  8013cf:	6a 01                	push   $0x1
  8013d1:	e8 5a 08 00 00       	call   801c30 <ipc_find_env>
  8013d6:	a3 00 40 80 00       	mov    %eax,0x804000
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	eb c5                	jmp    8013a5 <fsipc+0x12>

008013e0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013e0:	f3 0f 1e fb          	endbr32 
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801402:	b8 02 00 00 00       	mov    $0x2,%eax
  801407:	e8 87 ff ff ff       	call   801393 <fsipc>
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <devfile_flush>:
{
  80140e:	f3 0f 1e fb          	endbr32 
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8b 40 0c             	mov    0xc(%eax),%eax
  80141e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801423:	ba 00 00 00 00       	mov    $0x0,%edx
  801428:	b8 06 00 00 00       	mov    $0x6,%eax
  80142d:	e8 61 ff ff ff       	call   801393 <fsipc>
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <devfile_stat>:
{
  801434:	f3 0f 1e fb          	endbr32 
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	53                   	push   %ebx
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8b 40 0c             	mov    0xc(%eax),%eax
  801448:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80144d:	ba 00 00 00 00       	mov    $0x0,%edx
  801452:	b8 05 00 00 00       	mov    $0x5,%eax
  801457:	e8 37 ff ff ff       	call   801393 <fsipc>
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 2c                	js     80148c <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801460:	83 ec 08             	sub    $0x8,%esp
  801463:	68 00 50 80 00       	push   $0x805000
  801468:	53                   	push   %ebx
  801469:	e8 03 f3 ff ff       	call   800771 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80146e:	a1 80 50 80 00       	mov    0x805080,%eax
  801473:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801479:	a1 84 50 80 00       	mov    0x805084,%eax
  80147e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <devfile_write>:
{
  801491:	f3 0f 1e fb          	endbr32 
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 0c             	sub    $0xc,%esp
  80149b:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80149e:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a1:	8b 52 0c             	mov    0xc(%edx),%edx
  8014a4:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8014aa:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014af:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8014b4:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8014b7:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014bc:	50                   	push   %eax
  8014bd:	ff 75 0c             	pushl  0xc(%ebp)
  8014c0:	68 08 50 80 00       	push   $0x805008
  8014c5:	e8 5d f4 ff ff       	call   800927 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8014ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cf:	b8 04 00 00 00       	mov    $0x4,%eax
  8014d4:	e8 ba fe ff ff       	call   801393 <fsipc>
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <devfile_read>:
{
  8014db:	f3 0f 1e fb          	endbr32 
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	56                   	push   %esi
  8014e3:	53                   	push   %ebx
  8014e4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ed:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014f2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fd:	b8 03 00 00 00       	mov    $0x3,%eax
  801502:	e8 8c fe ff ff       	call   801393 <fsipc>
  801507:	89 c3                	mov    %eax,%ebx
  801509:	85 c0                	test   %eax,%eax
  80150b:	78 1f                	js     80152c <devfile_read+0x51>
	assert(r <= n);
  80150d:	39 f0                	cmp    %esi,%eax
  80150f:	77 24                	ja     801535 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801511:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801516:	7f 33                	jg     80154b <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801518:	83 ec 04             	sub    $0x4,%esp
  80151b:	50                   	push   %eax
  80151c:	68 00 50 80 00       	push   $0x805000
  801521:	ff 75 0c             	pushl  0xc(%ebp)
  801524:	e8 fe f3 ff ff       	call   800927 <memmove>
	return r;
  801529:	83 c4 10             	add    $0x10,%esp
}
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801531:	5b                   	pop    %ebx
  801532:	5e                   	pop    %esi
  801533:	5d                   	pop    %ebp
  801534:	c3                   	ret    
	assert(r <= n);
  801535:	68 18 23 80 00       	push   $0x802318
  80153a:	68 1f 23 80 00       	push   $0x80231f
  80153f:	6a 7c                	push   $0x7c
  801541:	68 34 23 80 00       	push   $0x802334
  801546:	e8 be 05 00 00       	call   801b09 <_panic>
	assert(r <= PGSIZE);
  80154b:	68 3f 23 80 00       	push   $0x80233f
  801550:	68 1f 23 80 00       	push   $0x80231f
  801555:	6a 7d                	push   $0x7d
  801557:	68 34 23 80 00       	push   $0x802334
  80155c:	e8 a8 05 00 00       	call   801b09 <_panic>

00801561 <open>:
{
  801561:	f3 0f 1e fb          	endbr32 
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	56                   	push   %esi
  801569:	53                   	push   %ebx
  80156a:	83 ec 1c             	sub    $0x1c,%esp
  80156d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801570:	56                   	push   %esi
  801571:	e8 b8 f1 ff ff       	call   80072e <strlen>
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80157e:	7f 6c                	jg     8015ec <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801580:	83 ec 0c             	sub    $0xc,%esp
  801583:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801586:	50                   	push   %eax
  801587:	e8 67 f8 ff ff       	call   800df3 <fd_alloc>
  80158c:	89 c3                	mov    %eax,%ebx
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	85 c0                	test   %eax,%eax
  801593:	78 3c                	js     8015d1 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801595:	83 ec 08             	sub    $0x8,%esp
  801598:	56                   	push   %esi
  801599:	68 00 50 80 00       	push   $0x805000
  80159e:	e8 ce f1 ff ff       	call   800771 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8015b3:	e8 db fd ff ff       	call   801393 <fsipc>
  8015b8:	89 c3                	mov    %eax,%ebx
  8015ba:	83 c4 10             	add    $0x10,%esp
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	78 19                	js     8015da <open+0x79>
	return fd2num(fd);
  8015c1:	83 ec 0c             	sub    $0xc,%esp
  8015c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c7:	e8 f8 f7 ff ff       	call   800dc4 <fd2num>
  8015cc:	89 c3                	mov    %eax,%ebx
  8015ce:	83 c4 10             	add    $0x10,%esp
}
  8015d1:	89 d8                	mov    %ebx,%eax
  8015d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d6:	5b                   	pop    %ebx
  8015d7:	5e                   	pop    %esi
  8015d8:	5d                   	pop    %ebp
  8015d9:	c3                   	ret    
		fd_close(fd, 0);
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	6a 00                	push   $0x0
  8015df:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e2:	e8 10 f9 ff ff       	call   800ef7 <fd_close>
		return r;
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	eb e5                	jmp    8015d1 <open+0x70>
		return -E_BAD_PATH;
  8015ec:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015f1:	eb de                	jmp    8015d1 <open+0x70>

008015f3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015f3:	f3 0f 1e fb          	endbr32 
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801602:	b8 08 00 00 00       	mov    $0x8,%eax
  801607:	e8 87 fd ff ff       	call   801393 <fsipc>
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80160e:	f3 0f 1e fb          	endbr32 
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	56                   	push   %esi
  801616:	53                   	push   %ebx
  801617:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80161a:	83 ec 0c             	sub    $0xc,%esp
  80161d:	ff 75 08             	pushl  0x8(%ebp)
  801620:	e8 b3 f7 ff ff       	call   800dd8 <fd2data>
  801625:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801627:	83 c4 08             	add    $0x8,%esp
  80162a:	68 4b 23 80 00       	push   $0x80234b
  80162f:	53                   	push   %ebx
  801630:	e8 3c f1 ff ff       	call   800771 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801635:	8b 46 04             	mov    0x4(%esi),%eax
  801638:	2b 06                	sub    (%esi),%eax
  80163a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801640:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801647:	00 00 00 
	stat->st_dev = &devpipe;
  80164a:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801651:	30 80 00 
	return 0;
}
  801654:	b8 00 00 00 00       	mov    $0x0,%eax
  801659:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801660:	f3 0f 1e fb          	endbr32 
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	53                   	push   %ebx
  801668:	83 ec 0c             	sub    $0xc,%esp
  80166b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80166e:	53                   	push   %ebx
  80166f:	6a 00                	push   $0x0
  801671:	e8 ca f5 ff ff       	call   800c40 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801676:	89 1c 24             	mov    %ebx,(%esp)
  801679:	e8 5a f7 ff ff       	call   800dd8 <fd2data>
  80167e:	83 c4 08             	add    $0x8,%esp
  801681:	50                   	push   %eax
  801682:	6a 00                	push   $0x0
  801684:	e8 b7 f5 ff ff       	call   800c40 <sys_page_unmap>
}
  801689:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <_pipeisclosed>:
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	57                   	push   %edi
  801692:	56                   	push   %esi
  801693:	53                   	push   %ebx
  801694:	83 ec 1c             	sub    $0x1c,%esp
  801697:	89 c7                	mov    %eax,%edi
  801699:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80169b:	a1 04 40 80 00       	mov    0x804004,%eax
  8016a0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016a3:	83 ec 0c             	sub    $0xc,%esp
  8016a6:	57                   	push   %edi
  8016a7:	e8 c1 05 00 00       	call   801c6d <pageref>
  8016ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016af:	89 34 24             	mov    %esi,(%esp)
  8016b2:	e8 b6 05 00 00       	call   801c6d <pageref>
		nn = thisenv->env_runs;
  8016b7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8016bd:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	39 cb                	cmp    %ecx,%ebx
  8016c5:	74 1b                	je     8016e2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016c7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016ca:	75 cf                	jne    80169b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016cc:	8b 42 58             	mov    0x58(%edx),%eax
  8016cf:	6a 01                	push   $0x1
  8016d1:	50                   	push   %eax
  8016d2:	53                   	push   %ebx
  8016d3:	68 52 23 80 00       	push   $0x802352
  8016d8:	e8 8a ea ff ff       	call   800167 <cprintf>
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	eb b9                	jmp    80169b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016e2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016e5:	0f 94 c0             	sete   %al
  8016e8:	0f b6 c0             	movzbl %al,%eax
}
  8016eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ee:	5b                   	pop    %ebx
  8016ef:	5e                   	pop    %esi
  8016f0:	5f                   	pop    %edi
  8016f1:	5d                   	pop    %ebp
  8016f2:	c3                   	ret    

008016f3 <devpipe_write>:
{
  8016f3:	f3 0f 1e fb          	endbr32 
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	57                   	push   %edi
  8016fb:	56                   	push   %esi
  8016fc:	53                   	push   %ebx
  8016fd:	83 ec 28             	sub    $0x28,%esp
  801700:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801703:	56                   	push   %esi
  801704:	e8 cf f6 ff ff       	call   800dd8 <fd2data>
  801709:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	bf 00 00 00 00       	mov    $0x0,%edi
  801713:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801716:	74 4f                	je     801767 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801718:	8b 43 04             	mov    0x4(%ebx),%eax
  80171b:	8b 0b                	mov    (%ebx),%ecx
  80171d:	8d 51 20             	lea    0x20(%ecx),%edx
  801720:	39 d0                	cmp    %edx,%eax
  801722:	72 14                	jb     801738 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801724:	89 da                	mov    %ebx,%edx
  801726:	89 f0                	mov    %esi,%eax
  801728:	e8 61 ff ff ff       	call   80168e <_pipeisclosed>
  80172d:	85 c0                	test   %eax,%eax
  80172f:	75 3b                	jne    80176c <devpipe_write+0x79>
			sys_yield();
  801731:	e8 5a f4 ff ff       	call   800b90 <sys_yield>
  801736:	eb e0                	jmp    801718 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801738:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80173b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80173f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801742:	89 c2                	mov    %eax,%edx
  801744:	c1 fa 1f             	sar    $0x1f,%edx
  801747:	89 d1                	mov    %edx,%ecx
  801749:	c1 e9 1b             	shr    $0x1b,%ecx
  80174c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80174f:	83 e2 1f             	and    $0x1f,%edx
  801752:	29 ca                	sub    %ecx,%edx
  801754:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801758:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80175c:	83 c0 01             	add    $0x1,%eax
  80175f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801762:	83 c7 01             	add    $0x1,%edi
  801765:	eb ac                	jmp    801713 <devpipe_write+0x20>
	return i;
  801767:	8b 45 10             	mov    0x10(%ebp),%eax
  80176a:	eb 05                	jmp    801771 <devpipe_write+0x7e>
				return 0;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801771:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801774:	5b                   	pop    %ebx
  801775:	5e                   	pop    %esi
  801776:	5f                   	pop    %edi
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    

00801779 <devpipe_read>:
{
  801779:	f3 0f 1e fb          	endbr32 
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	57                   	push   %edi
  801781:	56                   	push   %esi
  801782:	53                   	push   %ebx
  801783:	83 ec 18             	sub    $0x18,%esp
  801786:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801789:	57                   	push   %edi
  80178a:	e8 49 f6 ff ff       	call   800dd8 <fd2data>
  80178f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801791:	83 c4 10             	add    $0x10,%esp
  801794:	be 00 00 00 00       	mov    $0x0,%esi
  801799:	3b 75 10             	cmp    0x10(%ebp),%esi
  80179c:	75 14                	jne    8017b2 <devpipe_read+0x39>
	return i;
  80179e:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a1:	eb 02                	jmp    8017a5 <devpipe_read+0x2c>
				return i;
  8017a3:	89 f0                	mov    %esi,%eax
}
  8017a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a8:	5b                   	pop    %ebx
  8017a9:	5e                   	pop    %esi
  8017aa:	5f                   	pop    %edi
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    
			sys_yield();
  8017ad:	e8 de f3 ff ff       	call   800b90 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8017b2:	8b 03                	mov    (%ebx),%eax
  8017b4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017b7:	75 18                	jne    8017d1 <devpipe_read+0x58>
			if (i > 0)
  8017b9:	85 f6                	test   %esi,%esi
  8017bb:	75 e6                	jne    8017a3 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8017bd:	89 da                	mov    %ebx,%edx
  8017bf:	89 f8                	mov    %edi,%eax
  8017c1:	e8 c8 fe ff ff       	call   80168e <_pipeisclosed>
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	74 e3                	je     8017ad <devpipe_read+0x34>
				return 0;
  8017ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cf:	eb d4                	jmp    8017a5 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017d1:	99                   	cltd   
  8017d2:	c1 ea 1b             	shr    $0x1b,%edx
  8017d5:	01 d0                	add    %edx,%eax
  8017d7:	83 e0 1f             	and    $0x1f,%eax
  8017da:	29 d0                	sub    %edx,%eax
  8017dc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017e7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017ea:	83 c6 01             	add    $0x1,%esi
  8017ed:	eb aa                	jmp    801799 <devpipe_read+0x20>

008017ef <pipe>:
{
  8017ef:	f3 0f 1e fb          	endbr32 
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	56                   	push   %esi
  8017f7:	53                   	push   %ebx
  8017f8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8017fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017fe:	50                   	push   %eax
  8017ff:	e8 ef f5 ff ff       	call   800df3 <fd_alloc>
  801804:	89 c3                	mov    %eax,%ebx
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	85 c0                	test   %eax,%eax
  80180b:	0f 88 23 01 00 00    	js     801934 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	68 07 04 00 00       	push   $0x407
  801819:	ff 75 f4             	pushl  -0xc(%ebp)
  80181c:	6a 00                	push   $0x0
  80181e:	e8 90 f3 ff ff       	call   800bb3 <sys_page_alloc>
  801823:	89 c3                	mov    %eax,%ebx
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	85 c0                	test   %eax,%eax
  80182a:	0f 88 04 01 00 00    	js     801934 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801830:	83 ec 0c             	sub    $0xc,%esp
  801833:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801836:	50                   	push   %eax
  801837:	e8 b7 f5 ff ff       	call   800df3 <fd_alloc>
  80183c:	89 c3                	mov    %eax,%ebx
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	85 c0                	test   %eax,%eax
  801843:	0f 88 db 00 00 00    	js     801924 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801849:	83 ec 04             	sub    $0x4,%esp
  80184c:	68 07 04 00 00       	push   $0x407
  801851:	ff 75 f0             	pushl  -0x10(%ebp)
  801854:	6a 00                	push   $0x0
  801856:	e8 58 f3 ff ff       	call   800bb3 <sys_page_alloc>
  80185b:	89 c3                	mov    %eax,%ebx
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	85 c0                	test   %eax,%eax
  801862:	0f 88 bc 00 00 00    	js     801924 <pipe+0x135>
	va = fd2data(fd0);
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	ff 75 f4             	pushl  -0xc(%ebp)
  80186e:	e8 65 f5 ff ff       	call   800dd8 <fd2data>
  801873:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801875:	83 c4 0c             	add    $0xc,%esp
  801878:	68 07 04 00 00       	push   $0x407
  80187d:	50                   	push   %eax
  80187e:	6a 00                	push   $0x0
  801880:	e8 2e f3 ff ff       	call   800bb3 <sys_page_alloc>
  801885:	89 c3                	mov    %eax,%ebx
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	85 c0                	test   %eax,%eax
  80188c:	0f 88 82 00 00 00    	js     801914 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	ff 75 f0             	pushl  -0x10(%ebp)
  801898:	e8 3b f5 ff ff       	call   800dd8 <fd2data>
  80189d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018a4:	50                   	push   %eax
  8018a5:	6a 00                	push   $0x0
  8018a7:	56                   	push   %esi
  8018a8:	6a 00                	push   $0x0
  8018aa:	e8 4b f3 ff ff       	call   800bfa <sys_page_map>
  8018af:	89 c3                	mov    %eax,%ebx
  8018b1:	83 c4 20             	add    $0x20,%esp
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	78 4e                	js     801906 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8018b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8018bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8018c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8018cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018cf:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8018d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018db:	83 ec 0c             	sub    $0xc,%esp
  8018de:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e1:	e8 de f4 ff ff       	call   800dc4 <fd2num>
  8018e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018eb:	83 c4 04             	add    $0x4,%esp
  8018ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f1:	e8 ce f4 ff ff       	call   800dc4 <fd2num>
  8018f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801904:	eb 2e                	jmp    801934 <pipe+0x145>
	sys_page_unmap(0, va);
  801906:	83 ec 08             	sub    $0x8,%esp
  801909:	56                   	push   %esi
  80190a:	6a 00                	push   $0x0
  80190c:	e8 2f f3 ff ff       	call   800c40 <sys_page_unmap>
  801911:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801914:	83 ec 08             	sub    $0x8,%esp
  801917:	ff 75 f0             	pushl  -0x10(%ebp)
  80191a:	6a 00                	push   $0x0
  80191c:	e8 1f f3 ff ff       	call   800c40 <sys_page_unmap>
  801921:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801924:	83 ec 08             	sub    $0x8,%esp
  801927:	ff 75 f4             	pushl  -0xc(%ebp)
  80192a:	6a 00                	push   $0x0
  80192c:	e8 0f f3 ff ff       	call   800c40 <sys_page_unmap>
  801931:	83 c4 10             	add    $0x10,%esp
}
  801934:	89 d8                	mov    %ebx,%eax
  801936:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801939:	5b                   	pop    %ebx
  80193a:	5e                   	pop    %esi
  80193b:	5d                   	pop    %ebp
  80193c:	c3                   	ret    

0080193d <pipeisclosed>:
{
  80193d:	f3 0f 1e fb          	endbr32 
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801947:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194a:	50                   	push   %eax
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	e8 f6 f4 ff ff       	call   800e49 <fd_lookup>
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	85 c0                	test   %eax,%eax
  801958:	78 18                	js     801972 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80195a:	83 ec 0c             	sub    $0xc,%esp
  80195d:	ff 75 f4             	pushl  -0xc(%ebp)
  801960:	e8 73 f4 ff ff       	call   800dd8 <fd2data>
  801965:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196a:	e8 1f fd ff ff       	call   80168e <_pipeisclosed>
  80196f:	83 c4 10             	add    $0x10,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801974:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801978:	b8 00 00 00 00       	mov    $0x0,%eax
  80197d:	c3                   	ret    

0080197e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80197e:	f3 0f 1e fb          	endbr32 
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801988:	68 6a 23 80 00       	push   $0x80236a
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	e8 dc ed ff ff       	call   800771 <strcpy>
	return 0;
}
  801995:	b8 00 00 00 00       	mov    $0x0,%eax
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <devcons_write>:
{
  80199c:	f3 0f 1e fb          	endbr32 
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	57                   	push   %edi
  8019a4:	56                   	push   %esi
  8019a5:	53                   	push   %ebx
  8019a6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8019ac:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8019b1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8019b7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019ba:	73 31                	jae    8019ed <devcons_write+0x51>
		m = n - tot;
  8019bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019bf:	29 f3                	sub    %esi,%ebx
  8019c1:	83 fb 7f             	cmp    $0x7f,%ebx
  8019c4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8019c9:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	53                   	push   %ebx
  8019d0:	89 f0                	mov    %esi,%eax
  8019d2:	03 45 0c             	add    0xc(%ebp),%eax
  8019d5:	50                   	push   %eax
  8019d6:	57                   	push   %edi
  8019d7:	e8 4b ef ff ff       	call   800927 <memmove>
		sys_cputs(buf, m);
  8019dc:	83 c4 08             	add    $0x8,%esp
  8019df:	53                   	push   %ebx
  8019e0:	57                   	push   %edi
  8019e1:	e8 fd f0 ff ff       	call   800ae3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8019e6:	01 de                	add    %ebx,%esi
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	eb ca                	jmp    8019b7 <devcons_write+0x1b>
}
  8019ed:	89 f0                	mov    %esi,%eax
  8019ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019f2:	5b                   	pop    %ebx
  8019f3:	5e                   	pop    %esi
  8019f4:	5f                   	pop    %edi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    

008019f7 <devcons_read>:
{
  8019f7:	f3 0f 1e fb          	endbr32 
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 08             	sub    $0x8,%esp
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801a06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0a:	74 21                	je     801a2d <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801a0c:	e8 f4 f0 ff ff       	call   800b05 <sys_cgetc>
  801a11:	85 c0                	test   %eax,%eax
  801a13:	75 07                	jne    801a1c <devcons_read+0x25>
		sys_yield();
  801a15:	e8 76 f1 ff ff       	call   800b90 <sys_yield>
  801a1a:	eb f0                	jmp    801a0c <devcons_read+0x15>
	if (c < 0)
  801a1c:	78 0f                	js     801a2d <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801a1e:	83 f8 04             	cmp    $0x4,%eax
  801a21:	74 0c                	je     801a2f <devcons_read+0x38>
	*(char*)vbuf = c;
  801a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a26:	88 02                	mov    %al,(%edx)
	return 1;
  801a28:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    
		return 0;
  801a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a34:	eb f7                	jmp    801a2d <devcons_read+0x36>

00801a36 <cputchar>:
{
  801a36:	f3 0f 1e fb          	endbr32 
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a46:	6a 01                	push   $0x1
  801a48:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a4b:	50                   	push   %eax
  801a4c:	e8 92 f0 ff ff       	call   800ae3 <sys_cputs>
}
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <getchar>:
{
  801a56:	f3 0f 1e fb          	endbr32 
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a60:	6a 01                	push   $0x1
  801a62:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a65:	50                   	push   %eax
  801a66:	6a 00                	push   $0x0
  801a68:	e8 5f f6 ff ff       	call   8010cc <read>
	if (r < 0)
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	85 c0                	test   %eax,%eax
  801a72:	78 06                	js     801a7a <getchar+0x24>
	if (r < 1)
  801a74:	74 06                	je     801a7c <getchar+0x26>
	return c;
  801a76:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    
		return -E_EOF;
  801a7c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a81:	eb f7                	jmp    801a7a <getchar+0x24>

00801a83 <iscons>:
{
  801a83:	f3 0f 1e fb          	endbr32 
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a90:	50                   	push   %eax
  801a91:	ff 75 08             	pushl  0x8(%ebp)
  801a94:	e8 b0 f3 ff ff       	call   800e49 <fd_lookup>
  801a99:	83 c4 10             	add    $0x10,%esp
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	78 11                	js     801ab1 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801aa9:	39 10                	cmp    %edx,(%eax)
  801aab:	0f 94 c0             	sete   %al
  801aae:	0f b6 c0             	movzbl %al,%eax
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <opencons>:
{
  801ab3:	f3 0f 1e fb          	endbr32 
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801abd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac0:	50                   	push   %eax
  801ac1:	e8 2d f3 ff ff       	call   800df3 <fd_alloc>
  801ac6:	83 c4 10             	add    $0x10,%esp
  801ac9:	85 c0                	test   %eax,%eax
  801acb:	78 3a                	js     801b07 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801acd:	83 ec 04             	sub    $0x4,%esp
  801ad0:	68 07 04 00 00       	push   $0x407
  801ad5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad8:	6a 00                	push   $0x0
  801ada:	e8 d4 f0 ff ff       	call   800bb3 <sys_page_alloc>
  801adf:	83 c4 10             	add    $0x10,%esp
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	78 21                	js     801b07 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801aef:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801afb:	83 ec 0c             	sub    $0xc,%esp
  801afe:	50                   	push   %eax
  801aff:	e8 c0 f2 ff ff       	call   800dc4 <fd2num>
  801b04:	83 c4 10             	add    $0x10,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b09:	f3 0f 1e fb          	endbr32 
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	56                   	push   %esi
  801b11:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b12:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b15:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801b1b:	e8 4d f0 ff ff       	call   800b6d <sys_getenvid>
  801b20:	83 ec 0c             	sub    $0xc,%esp
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	ff 75 08             	pushl  0x8(%ebp)
  801b29:	56                   	push   %esi
  801b2a:	50                   	push   %eax
  801b2b:	68 78 23 80 00       	push   $0x802378
  801b30:	e8 32 e6 ff ff       	call   800167 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b35:	83 c4 18             	add    $0x18,%esp
  801b38:	53                   	push   %ebx
  801b39:	ff 75 10             	pushl  0x10(%ebp)
  801b3c:	e8 d1 e5 ff ff       	call   800112 <vcprintf>
	cprintf("\n");
  801b41:	c7 04 24 b4 23 80 00 	movl   $0x8023b4,(%esp)
  801b48:	e8 1a e6 ff ff       	call   800167 <cprintf>
  801b4d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b50:	cc                   	int3   
  801b51:	eb fd                	jmp    801b50 <_panic+0x47>

00801b53 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b53:	f3 0f 1e fb          	endbr32 
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	56                   	push   %esi
  801b5b:	53                   	push   %ebx
  801b5c:	8b 75 08             	mov    0x8(%ebp),%esi
  801b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b65:	85 c0                	test   %eax,%eax
  801b67:	74 3d                	je     801ba6 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b69:	83 ec 0c             	sub    $0xc,%esp
  801b6c:	50                   	push   %eax
  801b6d:	e8 0d f2 ff ff       	call   800d7f <sys_ipc_recv>
  801b72:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b75:	85 f6                	test   %esi,%esi
  801b77:	74 0b                	je     801b84 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b79:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b7f:	8b 52 74             	mov    0x74(%edx),%edx
  801b82:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b84:	85 db                	test   %ebx,%ebx
  801b86:	74 0b                	je     801b93 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b88:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b8e:	8b 52 78             	mov    0x78(%edx),%edx
  801b91:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801b93:	85 c0                	test   %eax,%eax
  801b95:	78 21                	js     801bb8 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801b97:	a1 04 40 80 00       	mov    0x804004,%eax
  801b9c:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba2:	5b                   	pop    %ebx
  801ba3:	5e                   	pop    %esi
  801ba4:	5d                   	pop    %ebp
  801ba5:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801ba6:	83 ec 0c             	sub    $0xc,%esp
  801ba9:	68 00 00 c0 ee       	push   $0xeec00000
  801bae:	e8 cc f1 ff ff       	call   800d7f <sys_ipc_recv>
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	eb bd                	jmp    801b75 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801bb8:	85 f6                	test   %esi,%esi
  801bba:	74 10                	je     801bcc <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801bbc:	85 db                	test   %ebx,%ebx
  801bbe:	75 df                	jne    801b9f <ipc_recv+0x4c>
  801bc0:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bc7:	00 00 00 
  801bca:	eb d3                	jmp    801b9f <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801bcc:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bd3:	00 00 00 
  801bd6:	eb e4                	jmp    801bbc <ipc_recv+0x69>

00801bd8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bd8:	f3 0f 1e fb          	endbr32 
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	57                   	push   %edi
  801be0:	56                   	push   %esi
  801be1:	53                   	push   %ebx
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801be8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801beb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bee:	85 db                	test   %ebx,%ebx
  801bf0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bf5:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801bf8:	ff 75 14             	pushl  0x14(%ebp)
  801bfb:	53                   	push   %ebx
  801bfc:	56                   	push   %esi
  801bfd:	57                   	push   %edi
  801bfe:	e8 55 f1 ff ff       	call   800d58 <sys_ipc_try_send>
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	79 1e                	jns    801c28 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801c0a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c0d:	75 07                	jne    801c16 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801c0f:	e8 7c ef ff ff       	call   800b90 <sys_yield>
  801c14:	eb e2                	jmp    801bf8 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801c16:	50                   	push   %eax
  801c17:	68 9b 23 80 00       	push   $0x80239b
  801c1c:	6a 59                	push   $0x59
  801c1e:	68 b6 23 80 00       	push   $0x8023b6
  801c23:	e8 e1 fe ff ff       	call   801b09 <_panic>
	}
}
  801c28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5f                   	pop    %edi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    

00801c30 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c30:	f3 0f 1e fb          	endbr32 
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c3a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c3f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c42:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c48:	8b 52 50             	mov    0x50(%edx),%edx
  801c4b:	39 ca                	cmp    %ecx,%edx
  801c4d:	74 11                	je     801c60 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c4f:	83 c0 01             	add    $0x1,%eax
  801c52:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c57:	75 e6                	jne    801c3f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c59:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5e:	eb 0b                	jmp    801c6b <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c60:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c63:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c68:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    

00801c6d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c6d:	f3 0f 1e fb          	endbr32 
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c77:	89 c2                	mov    %eax,%edx
  801c79:	c1 ea 16             	shr    $0x16,%edx
  801c7c:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c83:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c88:	f6 c1 01             	test   $0x1,%cl
  801c8b:	74 1c                	je     801ca9 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c8d:	c1 e8 0c             	shr    $0xc,%eax
  801c90:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c97:	a8 01                	test   $0x1,%al
  801c99:	74 0e                	je     801ca9 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c9b:	c1 e8 0c             	shr    $0xc,%eax
  801c9e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801ca5:	ef 
  801ca6:	0f b7 d2             	movzwl %dx,%edx
}
  801ca9:	89 d0                	mov    %edx,%eax
  801cab:	5d                   	pop    %ebp
  801cac:	c3                   	ret    
  801cad:	66 90                	xchg   %ax,%ax
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
