
obj/user/hello:     file format elf32-i386


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
  80003d:	68 20 10 80 00       	push   $0x801020
  800042:	e8 18 01 00 00       	call   80015f <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800047:	a1 04 20 80 00       	mov    0x802004,%eax
  80004c:	8b 40 48             	mov    0x48(%eax),%eax
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	50                   	push   %eax
  800053:	68 2e 10 80 00       	push   $0x80102e
  800058:	e8 02 01 00 00       	call   80015f <cprintf>
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
  800071:	e8 ef 0a 00 00       	call   800b65 <sys_getenvid>
  800076:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800083:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800088:	85 db                	test   %ebx,%ebx
  80008a:	7e 07                	jle    800093 <libmain+0x31>
		binaryname = argv[0];
  80008c:	8b 06                	mov    (%esi),%eax
  80008e:	a3 00 20 80 00       	mov    %eax,0x802000

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
  8000b3:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000b6:	6a 00                	push   $0x0
  8000b8:	e8 63 0a 00 00       	call   800b20 <sys_env_destroy>
}
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	c9                   	leave  
  8000c1:	c3                   	ret    

008000c2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c2:	f3 0f 1e fb          	endbr32 
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	53                   	push   %ebx
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d0:	8b 13                	mov    (%ebx),%edx
  8000d2:	8d 42 01             	lea    0x1(%edx),%eax
  8000d5:	89 03                	mov    %eax,(%ebx)
  8000d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000da:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e3:	74 09                	je     8000ee <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000e5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ec:	c9                   	leave  
  8000ed:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000ee:	83 ec 08             	sub    $0x8,%esp
  8000f1:	68 ff 00 00 00       	push   $0xff
  8000f6:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f9:	50                   	push   %eax
  8000fa:	e8 dc 09 00 00       	call   800adb <sys_cputs>
		b->idx = 0;
  8000ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800105:	83 c4 10             	add    $0x10,%esp
  800108:	eb db                	jmp    8000e5 <putch+0x23>

0080010a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80010a:	f3 0f 1e fb          	endbr32 
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800117:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80011e:	00 00 00 
	b.cnt = 0;
  800121:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800128:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80012b:	ff 75 0c             	pushl  0xc(%ebp)
  80012e:	ff 75 08             	pushl  0x8(%ebp)
  800131:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800137:	50                   	push   %eax
  800138:	68 c2 00 80 00       	push   $0x8000c2
  80013d:	e8 20 01 00 00       	call   800262 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800142:	83 c4 08             	add    $0x8,%esp
  800145:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80014b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800151:	50                   	push   %eax
  800152:	e8 84 09 00 00       	call   800adb <sys_cputs>

	return b.cnt;
}
  800157:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80015d:	c9                   	leave  
  80015e:	c3                   	ret    

0080015f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80015f:	f3 0f 1e fb          	endbr32 
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800169:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80016c:	50                   	push   %eax
  80016d:	ff 75 08             	pushl  0x8(%ebp)
  800170:	e8 95 ff ff ff       	call   80010a <vcprintf>
	va_end(ap);

	return cnt;
}
  800175:	c9                   	leave  
  800176:	c3                   	ret    

00800177 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	57                   	push   %edi
  80017b:	56                   	push   %esi
  80017c:	53                   	push   %ebx
  80017d:	83 ec 1c             	sub    $0x1c,%esp
  800180:	89 c7                	mov    %eax,%edi
  800182:	89 d6                	mov    %edx,%esi
  800184:	8b 45 08             	mov    0x8(%ebp),%eax
  800187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018a:	89 d1                	mov    %edx,%ecx
  80018c:	89 c2                	mov    %eax,%edx
  80018e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800191:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800194:	8b 45 10             	mov    0x10(%ebp),%eax
  800197:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80019a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80019d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001a4:	39 c2                	cmp    %eax,%edx
  8001a6:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001a9:	72 3e                	jb     8001e9 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 18             	pushl  0x18(%ebp)
  8001b1:	83 eb 01             	sub    $0x1,%ebx
  8001b4:	53                   	push   %ebx
  8001b5:	50                   	push   %eax
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8001c5:	e8 f6 0b 00 00       	call   800dc0 <__udivdi3>
  8001ca:	83 c4 18             	add    $0x18,%esp
  8001cd:	52                   	push   %edx
  8001ce:	50                   	push   %eax
  8001cf:	89 f2                	mov    %esi,%edx
  8001d1:	89 f8                	mov    %edi,%eax
  8001d3:	e8 9f ff ff ff       	call   800177 <printnum>
  8001d8:	83 c4 20             	add    $0x20,%esp
  8001db:	eb 13                	jmp    8001f0 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	56                   	push   %esi
  8001e1:	ff 75 18             	pushl  0x18(%ebp)
  8001e4:	ff d7                	call   *%edi
  8001e6:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001e9:	83 eb 01             	sub    $0x1,%ebx
  8001ec:	85 db                	test   %ebx,%ebx
  8001ee:	7f ed                	jg     8001dd <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	56                   	push   %esi
  8001f4:	83 ec 04             	sub    $0x4,%esp
  8001f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fd:	ff 75 dc             	pushl  -0x24(%ebp)
  800200:	ff 75 d8             	pushl  -0x28(%ebp)
  800203:	e8 c8 0c 00 00       	call   800ed0 <__umoddi3>
  800208:	83 c4 14             	add    $0x14,%esp
  80020b:	0f be 80 4f 10 80 00 	movsbl 0x80104f(%eax),%eax
  800212:	50                   	push   %eax
  800213:	ff d7                	call   *%edi
}
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021b:	5b                   	pop    %ebx
  80021c:	5e                   	pop    %esi
  80021d:	5f                   	pop    %edi
  80021e:	5d                   	pop    %ebp
  80021f:	c3                   	ret    

00800220 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800220:	f3 0f 1e fb          	endbr32 
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80022a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80022e:	8b 10                	mov    (%eax),%edx
  800230:	3b 50 04             	cmp    0x4(%eax),%edx
  800233:	73 0a                	jae    80023f <sprintputch+0x1f>
		*b->buf++ = ch;
  800235:	8d 4a 01             	lea    0x1(%edx),%ecx
  800238:	89 08                	mov    %ecx,(%eax)
  80023a:	8b 45 08             	mov    0x8(%ebp),%eax
  80023d:	88 02                	mov    %al,(%edx)
}
  80023f:	5d                   	pop    %ebp
  800240:	c3                   	ret    

00800241 <printfmt>:
{
  800241:	f3 0f 1e fb          	endbr32 
  800245:	55                   	push   %ebp
  800246:	89 e5                	mov    %esp,%ebp
  800248:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80024b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80024e:	50                   	push   %eax
  80024f:	ff 75 10             	pushl  0x10(%ebp)
  800252:	ff 75 0c             	pushl  0xc(%ebp)
  800255:	ff 75 08             	pushl  0x8(%ebp)
  800258:	e8 05 00 00 00       	call   800262 <vprintfmt>
}
  80025d:	83 c4 10             	add    $0x10,%esp
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <vprintfmt>:
{
  800262:	f3 0f 1e fb          	endbr32 
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	57                   	push   %edi
  80026a:	56                   	push   %esi
  80026b:	53                   	push   %ebx
  80026c:	83 ec 3c             	sub    $0x3c,%esp
  80026f:	8b 75 08             	mov    0x8(%ebp),%esi
  800272:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800275:	8b 7d 10             	mov    0x10(%ebp),%edi
  800278:	e9 8e 03 00 00       	jmp    80060b <vprintfmt+0x3a9>
		padc = ' ';
  80027d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800281:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800288:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80028f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800296:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80029b:	8d 47 01             	lea    0x1(%edi),%eax
  80029e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002a1:	0f b6 17             	movzbl (%edi),%edx
  8002a4:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002a7:	3c 55                	cmp    $0x55,%al
  8002a9:	0f 87 df 03 00 00    	ja     80068e <vprintfmt+0x42c>
  8002af:	0f b6 c0             	movzbl %al,%eax
  8002b2:	3e ff 24 85 20 11 80 	notrack jmp *0x801120(,%eax,4)
  8002b9:	00 
  8002ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002bd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002c1:	eb d8                	jmp    80029b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002c6:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002ca:	eb cf                	jmp    80029b <vprintfmt+0x39>
  8002cc:	0f b6 d2             	movzbl %dl,%edx
  8002cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002da:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002dd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002e1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002e4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002e7:	83 f9 09             	cmp    $0x9,%ecx
  8002ea:	77 55                	ja     800341 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8002ec:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002ef:	eb e9                	jmp    8002da <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8002f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f4:	8b 00                	mov    (%eax),%eax
  8002f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	8d 40 04             	lea    0x4(%eax),%eax
  8002ff:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800302:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800305:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800309:	79 90                	jns    80029b <vprintfmt+0x39>
				width = precision, precision = -1;
  80030b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80030e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800311:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800318:	eb 81                	jmp    80029b <vprintfmt+0x39>
  80031a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80031d:	85 c0                	test   %eax,%eax
  80031f:	ba 00 00 00 00       	mov    $0x0,%edx
  800324:	0f 49 d0             	cmovns %eax,%edx
  800327:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80032d:	e9 69 ff ff ff       	jmp    80029b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800335:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80033c:	e9 5a ff ff ff       	jmp    80029b <vprintfmt+0x39>
  800341:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800344:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800347:	eb bc                	jmp    800305 <vprintfmt+0xa3>
			lflag++;
  800349:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80034c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80034f:	e9 47 ff ff ff       	jmp    80029b <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800354:	8b 45 14             	mov    0x14(%ebp),%eax
  800357:	8d 78 04             	lea    0x4(%eax),%edi
  80035a:	83 ec 08             	sub    $0x8,%esp
  80035d:	53                   	push   %ebx
  80035e:	ff 30                	pushl  (%eax)
  800360:	ff d6                	call   *%esi
			break;
  800362:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800365:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800368:	e9 9b 02 00 00       	jmp    800608 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80036d:	8b 45 14             	mov    0x14(%ebp),%eax
  800370:	8d 78 04             	lea    0x4(%eax),%edi
  800373:	8b 00                	mov    (%eax),%eax
  800375:	99                   	cltd   
  800376:	31 d0                	xor    %edx,%eax
  800378:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80037a:	83 f8 08             	cmp    $0x8,%eax
  80037d:	7f 23                	jg     8003a2 <vprintfmt+0x140>
  80037f:	8b 14 85 80 12 80 00 	mov    0x801280(,%eax,4),%edx
  800386:	85 d2                	test   %edx,%edx
  800388:	74 18                	je     8003a2 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80038a:	52                   	push   %edx
  80038b:	68 70 10 80 00       	push   $0x801070
  800390:	53                   	push   %ebx
  800391:	56                   	push   %esi
  800392:	e8 aa fe ff ff       	call   800241 <printfmt>
  800397:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80039a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80039d:	e9 66 02 00 00       	jmp    800608 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003a2:	50                   	push   %eax
  8003a3:	68 67 10 80 00       	push   $0x801067
  8003a8:	53                   	push   %ebx
  8003a9:	56                   	push   %esi
  8003aa:	e8 92 fe ff ff       	call   800241 <printfmt>
  8003af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003b5:	e9 4e 02 00 00       	jmp    800608 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	83 c0 04             	add    $0x4,%eax
  8003c0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003c8:	85 d2                	test   %edx,%edx
  8003ca:	b8 60 10 80 00       	mov    $0x801060,%eax
  8003cf:	0f 45 c2             	cmovne %edx,%eax
  8003d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d9:	7e 06                	jle    8003e1 <vprintfmt+0x17f>
  8003db:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003df:	75 0d                	jne    8003ee <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e4:	89 c7                	mov    %eax,%edi
  8003e6:	03 45 e0             	add    -0x20(%ebp),%eax
  8003e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ec:	eb 55                	jmp    800443 <vprintfmt+0x1e1>
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8003f4:	ff 75 cc             	pushl  -0x34(%ebp)
  8003f7:	e8 46 03 00 00       	call   800742 <strnlen>
  8003fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ff:	29 c2                	sub    %eax,%edx
  800401:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800409:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80040d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800410:	85 ff                	test   %edi,%edi
  800412:	7e 11                	jle    800425 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	53                   	push   %ebx
  800418:	ff 75 e0             	pushl  -0x20(%ebp)
  80041b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80041d:	83 ef 01             	sub    $0x1,%edi
  800420:	83 c4 10             	add    $0x10,%esp
  800423:	eb eb                	jmp    800410 <vprintfmt+0x1ae>
  800425:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800428:	85 d2                	test   %edx,%edx
  80042a:	b8 00 00 00 00       	mov    $0x0,%eax
  80042f:	0f 49 c2             	cmovns %edx,%eax
  800432:	29 c2                	sub    %eax,%edx
  800434:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800437:	eb a8                	jmp    8003e1 <vprintfmt+0x17f>
					putch(ch, putdat);
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	53                   	push   %ebx
  80043d:	52                   	push   %edx
  80043e:	ff d6                	call   *%esi
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800446:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800448:	83 c7 01             	add    $0x1,%edi
  80044b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80044f:	0f be d0             	movsbl %al,%edx
  800452:	85 d2                	test   %edx,%edx
  800454:	74 4b                	je     8004a1 <vprintfmt+0x23f>
  800456:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80045a:	78 06                	js     800462 <vprintfmt+0x200>
  80045c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800460:	78 1e                	js     800480 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800462:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800466:	74 d1                	je     800439 <vprintfmt+0x1d7>
  800468:	0f be c0             	movsbl %al,%eax
  80046b:	83 e8 20             	sub    $0x20,%eax
  80046e:	83 f8 5e             	cmp    $0x5e,%eax
  800471:	76 c6                	jbe    800439 <vprintfmt+0x1d7>
					putch('?', putdat);
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	53                   	push   %ebx
  800477:	6a 3f                	push   $0x3f
  800479:	ff d6                	call   *%esi
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	eb c3                	jmp    800443 <vprintfmt+0x1e1>
  800480:	89 cf                	mov    %ecx,%edi
  800482:	eb 0e                	jmp    800492 <vprintfmt+0x230>
				putch(' ', putdat);
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	53                   	push   %ebx
  800488:	6a 20                	push   $0x20
  80048a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80048c:	83 ef 01             	sub    $0x1,%edi
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	85 ff                	test   %edi,%edi
  800494:	7f ee                	jg     800484 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800496:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800499:	89 45 14             	mov    %eax,0x14(%ebp)
  80049c:	e9 67 01 00 00       	jmp    800608 <vprintfmt+0x3a6>
  8004a1:	89 cf                	mov    %ecx,%edi
  8004a3:	eb ed                	jmp    800492 <vprintfmt+0x230>
	if (lflag >= 2)
  8004a5:	83 f9 01             	cmp    $0x1,%ecx
  8004a8:	7f 1b                	jg     8004c5 <vprintfmt+0x263>
	else if (lflag)
  8004aa:	85 c9                	test   %ecx,%ecx
  8004ac:	74 63                	je     800511 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b6:	99                   	cltd   
  8004b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 40 04             	lea    0x4(%eax),%eax
  8004c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8004c3:	eb 17                	jmp    8004dc <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c8:	8b 50 04             	mov    0x4(%eax),%edx
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8d 40 08             	lea    0x8(%eax),%eax
  8004d9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004df:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004e2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8004e7:	85 c9                	test   %ecx,%ecx
  8004e9:	0f 89 ff 00 00 00    	jns    8005ee <vprintfmt+0x38c>
				putch('-', putdat);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	53                   	push   %ebx
  8004f3:	6a 2d                	push   $0x2d
  8004f5:	ff d6                	call   *%esi
				num = -(long long) num;
  8004f7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004fa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004fd:	f7 da                	neg    %edx
  8004ff:	83 d1 00             	adc    $0x0,%ecx
  800502:	f7 d9                	neg    %ecx
  800504:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800507:	b8 0a 00 00 00       	mov    $0xa,%eax
  80050c:	e9 dd 00 00 00       	jmp    8005ee <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800519:	99                   	cltd   
  80051a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80051d:	8b 45 14             	mov    0x14(%ebp),%eax
  800520:	8d 40 04             	lea    0x4(%eax),%eax
  800523:	89 45 14             	mov    %eax,0x14(%ebp)
  800526:	eb b4                	jmp    8004dc <vprintfmt+0x27a>
	if (lflag >= 2)
  800528:	83 f9 01             	cmp    $0x1,%ecx
  80052b:	7f 1e                	jg     80054b <vprintfmt+0x2e9>
	else if (lflag)
  80052d:	85 c9                	test   %ecx,%ecx
  80052f:	74 32                	je     800563 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8b 10                	mov    (%eax),%edx
  800536:	b9 00 00 00 00       	mov    $0x0,%ecx
  80053b:	8d 40 04             	lea    0x4(%eax),%eax
  80053e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800541:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800546:	e9 a3 00 00 00       	jmp    8005ee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8b 10                	mov    (%eax),%edx
  800550:	8b 48 04             	mov    0x4(%eax),%ecx
  800553:	8d 40 08             	lea    0x8(%eax),%eax
  800556:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800559:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80055e:	e9 8b 00 00 00       	jmp    8005ee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800563:	8b 45 14             	mov    0x14(%ebp),%eax
  800566:	8b 10                	mov    (%eax),%edx
  800568:	b9 00 00 00 00       	mov    $0x0,%ecx
  80056d:	8d 40 04             	lea    0x4(%eax),%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800573:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800578:	eb 74                	jmp    8005ee <vprintfmt+0x38c>
	if (lflag >= 2)
  80057a:	83 f9 01             	cmp    $0x1,%ecx
  80057d:	7f 1b                	jg     80059a <vprintfmt+0x338>
	else if (lflag)
  80057f:	85 c9                	test   %ecx,%ecx
  800581:	74 2c                	je     8005af <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8b 10                	mov    (%eax),%edx
  800588:	b9 00 00 00 00       	mov    $0x0,%ecx
  80058d:	8d 40 04             	lea    0x4(%eax),%eax
  800590:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800593:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800598:	eb 54                	jmp    8005ee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 10                	mov    (%eax),%edx
  80059f:	8b 48 04             	mov    0x4(%eax),%ecx
  8005a2:	8d 40 08             	lea    0x8(%eax),%eax
  8005a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005a8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005ad:	eb 3f                	jmp    8005ee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8b 10                	mov    (%eax),%edx
  8005b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b9:	8d 40 04             	lea    0x4(%eax),%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005bf:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005c4:	eb 28                	jmp    8005ee <vprintfmt+0x38c>
			putch('0', putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 30                	push   $0x30
  8005cc:	ff d6                	call   *%esi
			putch('x', putdat);
  8005ce:	83 c4 08             	add    $0x8,%esp
  8005d1:	53                   	push   %ebx
  8005d2:	6a 78                	push   $0x78
  8005d4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8b 10                	mov    (%eax),%edx
  8005db:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005e0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005e3:	8d 40 04             	lea    0x4(%eax),%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005e9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005f5:	57                   	push   %edi
  8005f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	51                   	push   %ecx
  8005fb:	52                   	push   %edx
  8005fc:	89 da                	mov    %ebx,%edx
  8005fe:	89 f0                	mov    %esi,%eax
  800600:	e8 72 fb ff ff       	call   800177 <printnum>
			break;
  800605:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800608:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80060b:	83 c7 01             	add    $0x1,%edi
  80060e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800612:	83 f8 25             	cmp    $0x25,%eax
  800615:	0f 84 62 fc ff ff    	je     80027d <vprintfmt+0x1b>
			if (ch == '\0')
  80061b:	85 c0                	test   %eax,%eax
  80061d:	0f 84 8b 00 00 00    	je     8006ae <vprintfmt+0x44c>
			putch(ch, putdat);
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	53                   	push   %ebx
  800627:	50                   	push   %eax
  800628:	ff d6                	call   *%esi
  80062a:	83 c4 10             	add    $0x10,%esp
  80062d:	eb dc                	jmp    80060b <vprintfmt+0x3a9>
	if (lflag >= 2)
  80062f:	83 f9 01             	cmp    $0x1,%ecx
  800632:	7f 1b                	jg     80064f <vprintfmt+0x3ed>
	else if (lflag)
  800634:	85 c9                	test   %ecx,%ecx
  800636:	74 2c                	je     800664 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 10                	mov    (%eax),%edx
  80063d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800648:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80064d:	eb 9f                	jmp    8005ee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 10                	mov    (%eax),%edx
  800654:	8b 48 04             	mov    0x4(%eax),%ecx
  800657:	8d 40 08             	lea    0x8(%eax),%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80065d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800662:	eb 8a                	jmp    8005ee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8b 10                	mov    (%eax),%edx
  800669:	b9 00 00 00 00       	mov    $0x0,%ecx
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800674:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800679:	e9 70 ff ff ff       	jmp    8005ee <vprintfmt+0x38c>
			putch(ch, putdat);
  80067e:	83 ec 08             	sub    $0x8,%esp
  800681:	53                   	push   %ebx
  800682:	6a 25                	push   $0x25
  800684:	ff d6                	call   *%esi
			break;
  800686:	83 c4 10             	add    $0x10,%esp
  800689:	e9 7a ff ff ff       	jmp    800608 <vprintfmt+0x3a6>
			putch('%', putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	53                   	push   %ebx
  800692:	6a 25                	push   $0x25
  800694:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800696:	83 c4 10             	add    $0x10,%esp
  800699:	89 f8                	mov    %edi,%eax
  80069b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80069f:	74 05                	je     8006a6 <vprintfmt+0x444>
  8006a1:	83 e8 01             	sub    $0x1,%eax
  8006a4:	eb f5                	jmp    80069b <vprintfmt+0x439>
  8006a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a9:	e9 5a ff ff ff       	jmp    800608 <vprintfmt+0x3a6>
}
  8006ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b1:	5b                   	pop    %ebx
  8006b2:	5e                   	pop    %esi
  8006b3:	5f                   	pop    %edi
  8006b4:	5d                   	pop    %ebp
  8006b5:	c3                   	ret    

008006b6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006b6:	f3 0f 1e fb          	endbr32 
  8006ba:	55                   	push   %ebp
  8006bb:	89 e5                	mov    %esp,%ebp
  8006bd:	83 ec 18             	sub    $0x18,%esp
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006c9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006cd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006d7:	85 c0                	test   %eax,%eax
  8006d9:	74 26                	je     800701 <vsnprintf+0x4b>
  8006db:	85 d2                	test   %edx,%edx
  8006dd:	7e 22                	jle    800701 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006df:	ff 75 14             	pushl  0x14(%ebp)
  8006e2:	ff 75 10             	pushl  0x10(%ebp)
  8006e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006e8:	50                   	push   %eax
  8006e9:	68 20 02 80 00       	push   $0x800220
  8006ee:	e8 6f fb ff ff       	call   800262 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006f6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006fc:	83 c4 10             	add    $0x10,%esp
}
  8006ff:	c9                   	leave  
  800700:	c3                   	ret    
		return -E_INVAL;
  800701:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800706:	eb f7                	jmp    8006ff <vsnprintf+0x49>

00800708 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800708:	f3 0f 1e fb          	endbr32 
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800712:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800715:	50                   	push   %eax
  800716:	ff 75 10             	pushl  0x10(%ebp)
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	ff 75 08             	pushl  0x8(%ebp)
  80071f:	e8 92 ff ff ff       	call   8006b6 <vsnprintf>
	va_end(ap);

	return rc;
}
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800726:	f3 0f 1e fb          	endbr32 
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800730:	b8 00 00 00 00       	mov    $0x0,%eax
  800735:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800739:	74 05                	je     800740 <strlen+0x1a>
		n++;
  80073b:	83 c0 01             	add    $0x1,%eax
  80073e:	eb f5                	jmp    800735 <strlen+0xf>
	return n;
}
  800740:	5d                   	pop    %ebp
  800741:	c3                   	ret    

00800742 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800742:	f3 0f 1e fb          	endbr32 
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80074c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80074f:	b8 00 00 00 00       	mov    $0x0,%eax
  800754:	39 d0                	cmp    %edx,%eax
  800756:	74 0d                	je     800765 <strnlen+0x23>
  800758:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80075c:	74 05                	je     800763 <strnlen+0x21>
		n++;
  80075e:	83 c0 01             	add    $0x1,%eax
  800761:	eb f1                	jmp    800754 <strnlen+0x12>
  800763:	89 c2                	mov    %eax,%edx
	return n;
}
  800765:	89 d0                	mov    %edx,%eax
  800767:	5d                   	pop    %ebp
  800768:	c3                   	ret    

00800769 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800769:	f3 0f 1e fb          	endbr32 
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	53                   	push   %ebx
  800771:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800774:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800777:	b8 00 00 00 00       	mov    $0x0,%eax
  80077c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800780:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800783:	83 c0 01             	add    $0x1,%eax
  800786:	84 d2                	test   %dl,%dl
  800788:	75 f2                	jne    80077c <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80078a:	89 c8                	mov    %ecx,%eax
  80078c:	5b                   	pop    %ebx
  80078d:	5d                   	pop    %ebp
  80078e:	c3                   	ret    

0080078f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80078f:	f3 0f 1e fb          	endbr32 
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	53                   	push   %ebx
  800797:	83 ec 10             	sub    $0x10,%esp
  80079a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80079d:	53                   	push   %ebx
  80079e:	e8 83 ff ff ff       	call   800726 <strlen>
  8007a3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	01 d8                	add    %ebx,%eax
  8007ab:	50                   	push   %eax
  8007ac:	e8 b8 ff ff ff       	call   800769 <strcpy>
	return dst;
}
  8007b1:	89 d8                	mov    %ebx,%eax
  8007b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007b8:	f3 0f 1e fb          	endbr32 
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	56                   	push   %esi
  8007c0:	53                   	push   %ebx
  8007c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c7:	89 f3                	mov    %esi,%ebx
  8007c9:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007cc:	89 f0                	mov    %esi,%eax
  8007ce:	39 d8                	cmp    %ebx,%eax
  8007d0:	74 11                	je     8007e3 <strncpy+0x2b>
		*dst++ = *src;
  8007d2:	83 c0 01             	add    $0x1,%eax
  8007d5:	0f b6 0a             	movzbl (%edx),%ecx
  8007d8:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007db:	80 f9 01             	cmp    $0x1,%cl
  8007de:	83 da ff             	sbb    $0xffffffff,%edx
  8007e1:	eb eb                	jmp    8007ce <strncpy+0x16>
	}
	return ret;
}
  8007e3:	89 f0                	mov    %esi,%eax
  8007e5:	5b                   	pop    %ebx
  8007e6:	5e                   	pop    %esi
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007e9:	f3 0f 1e fb          	endbr32 
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	56                   	push   %esi
  8007f1:	53                   	push   %ebx
  8007f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f8:	8b 55 10             	mov    0x10(%ebp),%edx
  8007fb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007fd:	85 d2                	test   %edx,%edx
  8007ff:	74 21                	je     800822 <strlcpy+0x39>
  800801:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800805:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800807:	39 c2                	cmp    %eax,%edx
  800809:	74 14                	je     80081f <strlcpy+0x36>
  80080b:	0f b6 19             	movzbl (%ecx),%ebx
  80080e:	84 db                	test   %bl,%bl
  800810:	74 0b                	je     80081d <strlcpy+0x34>
			*dst++ = *src++;
  800812:	83 c1 01             	add    $0x1,%ecx
  800815:	83 c2 01             	add    $0x1,%edx
  800818:	88 5a ff             	mov    %bl,-0x1(%edx)
  80081b:	eb ea                	jmp    800807 <strlcpy+0x1e>
  80081d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80081f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800822:	29 f0                	sub    %esi,%eax
}
  800824:	5b                   	pop    %ebx
  800825:	5e                   	pop    %esi
  800826:	5d                   	pop    %ebp
  800827:	c3                   	ret    

00800828 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800828:	f3 0f 1e fb          	endbr32 
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800832:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800835:	0f b6 01             	movzbl (%ecx),%eax
  800838:	84 c0                	test   %al,%al
  80083a:	74 0c                	je     800848 <strcmp+0x20>
  80083c:	3a 02                	cmp    (%edx),%al
  80083e:	75 08                	jne    800848 <strcmp+0x20>
		p++, q++;
  800840:	83 c1 01             	add    $0x1,%ecx
  800843:	83 c2 01             	add    $0x1,%edx
  800846:	eb ed                	jmp    800835 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800848:	0f b6 c0             	movzbl %al,%eax
  80084b:	0f b6 12             	movzbl (%edx),%edx
  80084e:	29 d0                	sub    %edx,%eax
}
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800852:	f3 0f 1e fb          	endbr32 
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	53                   	push   %ebx
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800860:	89 c3                	mov    %eax,%ebx
  800862:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800865:	eb 06                	jmp    80086d <strncmp+0x1b>
		n--, p++, q++;
  800867:	83 c0 01             	add    $0x1,%eax
  80086a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80086d:	39 d8                	cmp    %ebx,%eax
  80086f:	74 16                	je     800887 <strncmp+0x35>
  800871:	0f b6 08             	movzbl (%eax),%ecx
  800874:	84 c9                	test   %cl,%cl
  800876:	74 04                	je     80087c <strncmp+0x2a>
  800878:	3a 0a                	cmp    (%edx),%cl
  80087a:	74 eb                	je     800867 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80087c:	0f b6 00             	movzbl (%eax),%eax
  80087f:	0f b6 12             	movzbl (%edx),%edx
  800882:	29 d0                	sub    %edx,%eax
}
  800884:	5b                   	pop    %ebx
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    
		return 0;
  800887:	b8 00 00 00 00       	mov    $0x0,%eax
  80088c:	eb f6                	jmp    800884 <strncmp+0x32>

0080088e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80088e:	f3 0f 1e fb          	endbr32 
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80089c:	0f b6 10             	movzbl (%eax),%edx
  80089f:	84 d2                	test   %dl,%dl
  8008a1:	74 09                	je     8008ac <strchr+0x1e>
		if (*s == c)
  8008a3:	38 ca                	cmp    %cl,%dl
  8008a5:	74 0a                	je     8008b1 <strchr+0x23>
	for (; *s; s++)
  8008a7:	83 c0 01             	add    $0x1,%eax
  8008aa:	eb f0                	jmp    80089c <strchr+0xe>
			return (char *) s;
	return 0;
  8008ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008b3:	f3 0f 1e fb          	endbr32 
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008c4:	38 ca                	cmp    %cl,%dl
  8008c6:	74 09                	je     8008d1 <strfind+0x1e>
  8008c8:	84 d2                	test   %dl,%dl
  8008ca:	74 05                	je     8008d1 <strfind+0x1e>
	for (; *s; s++)
  8008cc:	83 c0 01             	add    $0x1,%eax
  8008cf:	eb f0                	jmp    8008c1 <strfind+0xe>
			break;
	return (char *) s;
}
  8008d1:	5d                   	pop    %ebp
  8008d2:	c3                   	ret    

008008d3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008d3:	f3 0f 1e fb          	endbr32 
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	57                   	push   %edi
  8008db:	56                   	push   %esi
  8008dc:	53                   	push   %ebx
  8008dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008e3:	85 c9                	test   %ecx,%ecx
  8008e5:	74 31                	je     800918 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008e7:	89 f8                	mov    %edi,%eax
  8008e9:	09 c8                	or     %ecx,%eax
  8008eb:	a8 03                	test   $0x3,%al
  8008ed:	75 23                	jne    800912 <memset+0x3f>
		c &= 0xFF;
  8008ef:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008f3:	89 d3                	mov    %edx,%ebx
  8008f5:	c1 e3 08             	shl    $0x8,%ebx
  8008f8:	89 d0                	mov    %edx,%eax
  8008fa:	c1 e0 18             	shl    $0x18,%eax
  8008fd:	89 d6                	mov    %edx,%esi
  8008ff:	c1 e6 10             	shl    $0x10,%esi
  800902:	09 f0                	or     %esi,%eax
  800904:	09 c2                	or     %eax,%edx
  800906:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800908:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80090b:	89 d0                	mov    %edx,%eax
  80090d:	fc                   	cld    
  80090e:	f3 ab                	rep stos %eax,%es:(%edi)
  800910:	eb 06                	jmp    800918 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800912:	8b 45 0c             	mov    0xc(%ebp),%eax
  800915:	fc                   	cld    
  800916:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800918:	89 f8                	mov    %edi,%eax
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5f                   	pop    %edi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80091f:	f3 0f 1e fb          	endbr32 
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	57                   	push   %edi
  800927:	56                   	push   %esi
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80092e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800931:	39 c6                	cmp    %eax,%esi
  800933:	73 32                	jae    800967 <memmove+0x48>
  800935:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800938:	39 c2                	cmp    %eax,%edx
  80093a:	76 2b                	jbe    800967 <memmove+0x48>
		s += n;
		d += n;
  80093c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093f:	89 fe                	mov    %edi,%esi
  800941:	09 ce                	or     %ecx,%esi
  800943:	09 d6                	or     %edx,%esi
  800945:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80094b:	75 0e                	jne    80095b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80094d:	83 ef 04             	sub    $0x4,%edi
  800950:	8d 72 fc             	lea    -0x4(%edx),%esi
  800953:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800956:	fd                   	std    
  800957:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800959:	eb 09                	jmp    800964 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80095b:	83 ef 01             	sub    $0x1,%edi
  80095e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800961:	fd                   	std    
  800962:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800964:	fc                   	cld    
  800965:	eb 1a                	jmp    800981 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800967:	89 c2                	mov    %eax,%edx
  800969:	09 ca                	or     %ecx,%edx
  80096b:	09 f2                	or     %esi,%edx
  80096d:	f6 c2 03             	test   $0x3,%dl
  800970:	75 0a                	jne    80097c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800972:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800975:	89 c7                	mov    %eax,%edi
  800977:	fc                   	cld    
  800978:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80097a:	eb 05                	jmp    800981 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80097c:	89 c7                	mov    %eax,%edi
  80097e:	fc                   	cld    
  80097f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800981:	5e                   	pop    %esi
  800982:	5f                   	pop    %edi
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800985:	f3 0f 1e fb          	endbr32 
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80098f:	ff 75 10             	pushl  0x10(%ebp)
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	ff 75 08             	pushl  0x8(%ebp)
  800998:	e8 82 ff ff ff       	call   80091f <memmove>
}
  80099d:	c9                   	leave  
  80099e:	c3                   	ret    

0080099f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80099f:	f3 0f 1e fb          	endbr32 
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	56                   	push   %esi
  8009a7:	53                   	push   %ebx
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	89 c6                	mov    %eax,%esi
  8009b0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009b3:	39 f0                	cmp    %esi,%eax
  8009b5:	74 1c                	je     8009d3 <memcmp+0x34>
		if (*s1 != *s2)
  8009b7:	0f b6 08             	movzbl (%eax),%ecx
  8009ba:	0f b6 1a             	movzbl (%edx),%ebx
  8009bd:	38 d9                	cmp    %bl,%cl
  8009bf:	75 08                	jne    8009c9 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009c1:	83 c0 01             	add    $0x1,%eax
  8009c4:	83 c2 01             	add    $0x1,%edx
  8009c7:	eb ea                	jmp    8009b3 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009c9:	0f b6 c1             	movzbl %cl,%eax
  8009cc:	0f b6 db             	movzbl %bl,%ebx
  8009cf:	29 d8                	sub    %ebx,%eax
  8009d1:	eb 05                	jmp    8009d8 <memcmp+0x39>
	}

	return 0;
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d8:	5b                   	pop    %ebx
  8009d9:	5e                   	pop    %esi
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009dc:	f3 0f 1e fb          	endbr32 
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009e9:	89 c2                	mov    %eax,%edx
  8009eb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009ee:	39 d0                	cmp    %edx,%eax
  8009f0:	73 09                	jae    8009fb <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009f2:	38 08                	cmp    %cl,(%eax)
  8009f4:	74 05                	je     8009fb <memfind+0x1f>
	for (; s < ends; s++)
  8009f6:	83 c0 01             	add    $0x1,%eax
  8009f9:	eb f3                	jmp    8009ee <memfind+0x12>
			break;
	return (void *) s;
}
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009fd:	f3 0f 1e fb          	endbr32 
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	57                   	push   %edi
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a0d:	eb 03                	jmp    800a12 <strtol+0x15>
		s++;
  800a0f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a12:	0f b6 01             	movzbl (%ecx),%eax
  800a15:	3c 20                	cmp    $0x20,%al
  800a17:	74 f6                	je     800a0f <strtol+0x12>
  800a19:	3c 09                	cmp    $0x9,%al
  800a1b:	74 f2                	je     800a0f <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a1d:	3c 2b                	cmp    $0x2b,%al
  800a1f:	74 2a                	je     800a4b <strtol+0x4e>
	int neg = 0;
  800a21:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a26:	3c 2d                	cmp    $0x2d,%al
  800a28:	74 2b                	je     800a55 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a2a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a30:	75 0f                	jne    800a41 <strtol+0x44>
  800a32:	80 39 30             	cmpb   $0x30,(%ecx)
  800a35:	74 28                	je     800a5f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a37:	85 db                	test   %ebx,%ebx
  800a39:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a3e:	0f 44 d8             	cmove  %eax,%ebx
  800a41:	b8 00 00 00 00       	mov    $0x0,%eax
  800a46:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a49:	eb 46                	jmp    800a91 <strtol+0x94>
		s++;
  800a4b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a4e:	bf 00 00 00 00       	mov    $0x0,%edi
  800a53:	eb d5                	jmp    800a2a <strtol+0x2d>
		s++, neg = 1;
  800a55:	83 c1 01             	add    $0x1,%ecx
  800a58:	bf 01 00 00 00       	mov    $0x1,%edi
  800a5d:	eb cb                	jmp    800a2a <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a5f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a63:	74 0e                	je     800a73 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a65:	85 db                	test   %ebx,%ebx
  800a67:	75 d8                	jne    800a41 <strtol+0x44>
		s++, base = 8;
  800a69:	83 c1 01             	add    $0x1,%ecx
  800a6c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a71:	eb ce                	jmp    800a41 <strtol+0x44>
		s += 2, base = 16;
  800a73:	83 c1 02             	add    $0x2,%ecx
  800a76:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a7b:	eb c4                	jmp    800a41 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a7d:	0f be d2             	movsbl %dl,%edx
  800a80:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a83:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a86:	7d 3a                	jge    800ac2 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a88:	83 c1 01             	add    $0x1,%ecx
  800a8b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a8f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a91:	0f b6 11             	movzbl (%ecx),%edx
  800a94:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a97:	89 f3                	mov    %esi,%ebx
  800a99:	80 fb 09             	cmp    $0x9,%bl
  800a9c:	76 df                	jbe    800a7d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a9e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aa1:	89 f3                	mov    %esi,%ebx
  800aa3:	80 fb 19             	cmp    $0x19,%bl
  800aa6:	77 08                	ja     800ab0 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aa8:	0f be d2             	movsbl %dl,%edx
  800aab:	83 ea 57             	sub    $0x57,%edx
  800aae:	eb d3                	jmp    800a83 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ab0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ab3:	89 f3                	mov    %esi,%ebx
  800ab5:	80 fb 19             	cmp    $0x19,%bl
  800ab8:	77 08                	ja     800ac2 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800aba:	0f be d2             	movsbl %dl,%edx
  800abd:	83 ea 37             	sub    $0x37,%edx
  800ac0:	eb c1                	jmp    800a83 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ac2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac6:	74 05                	je     800acd <strtol+0xd0>
		*endptr = (char *) s;
  800ac8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800acb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800acd:	89 c2                	mov    %eax,%edx
  800acf:	f7 da                	neg    %edx
  800ad1:	85 ff                	test   %edi,%edi
  800ad3:	0f 45 c2             	cmovne %edx,%eax
}
  800ad6:	5b                   	pop    %ebx
  800ad7:	5e                   	pop    %esi
  800ad8:	5f                   	pop    %edi
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800adb:	f3 0f 1e fb          	endbr32 
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	57                   	push   %edi
  800ae3:	56                   	push   %esi
  800ae4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ae5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aea:	8b 55 08             	mov    0x8(%ebp),%edx
  800aed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af0:	89 c3                	mov    %eax,%ebx
  800af2:	89 c7                	mov    %eax,%edi
  800af4:	89 c6                	mov    %eax,%esi
  800af6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800af8:	5b                   	pop    %ebx
  800af9:	5e                   	pop    %esi
  800afa:	5f                   	pop    %edi
  800afb:	5d                   	pop    %ebp
  800afc:	c3                   	ret    

00800afd <sys_cgetc>:

int
sys_cgetc(void)
{
  800afd:	f3 0f 1e fb          	endbr32 
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	57                   	push   %edi
  800b05:	56                   	push   %esi
  800b06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b07:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0c:	b8 01 00 00 00       	mov    $0x1,%eax
  800b11:	89 d1                	mov    %edx,%ecx
  800b13:	89 d3                	mov    %edx,%ebx
  800b15:	89 d7                	mov    %edx,%edi
  800b17:	89 d6                	mov    %edx,%esi
  800b19:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b1b:	5b                   	pop    %ebx
  800b1c:	5e                   	pop    %esi
  800b1d:	5f                   	pop    %edi
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    

00800b20 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b20:	f3 0f 1e fb          	endbr32 
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	57                   	push   %edi
  800b28:	56                   	push   %esi
  800b29:	53                   	push   %ebx
  800b2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b32:	8b 55 08             	mov    0x8(%ebp),%edx
  800b35:	b8 03 00 00 00       	mov    $0x3,%eax
  800b3a:	89 cb                	mov    %ecx,%ebx
  800b3c:	89 cf                	mov    %ecx,%edi
  800b3e:	89 ce                	mov    %ecx,%esi
  800b40:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b42:	85 c0                	test   %eax,%eax
  800b44:	7f 08                	jg     800b4e <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b49:	5b                   	pop    %ebx
  800b4a:	5e                   	pop    %esi
  800b4b:	5f                   	pop    %edi
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b4e:	83 ec 0c             	sub    $0xc,%esp
  800b51:	50                   	push   %eax
  800b52:	6a 03                	push   $0x3
  800b54:	68 a4 12 80 00       	push   $0x8012a4
  800b59:	6a 23                	push   $0x23
  800b5b:	68 c1 12 80 00       	push   $0x8012c1
  800b60:	e8 11 02 00 00       	call   800d76 <_panic>

00800b65 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b65:	f3 0f 1e fb          	endbr32 
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	57                   	push   %edi
  800b6d:	56                   	push   %esi
  800b6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b74:	b8 02 00 00 00       	mov    $0x2,%eax
  800b79:	89 d1                	mov    %edx,%ecx
  800b7b:	89 d3                	mov    %edx,%ebx
  800b7d:	89 d7                	mov    %edx,%edi
  800b7f:	89 d6                	mov    %edx,%esi
  800b81:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5f                   	pop    %edi
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <sys_yield>:

void
sys_yield(void)
{
  800b88:	f3 0f 1e fb          	endbr32 
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	57                   	push   %edi
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b92:	ba 00 00 00 00       	mov    $0x0,%edx
  800b97:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b9c:	89 d1                	mov    %edx,%ecx
  800b9e:	89 d3                	mov    %edx,%ebx
  800ba0:	89 d7                	mov    %edx,%edi
  800ba2:	89 d6                	mov    %edx,%esi
  800ba4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ba6:	5b                   	pop    %ebx
  800ba7:	5e                   	pop    %esi
  800ba8:	5f                   	pop    %edi
  800ba9:	5d                   	pop    %ebp
  800baa:	c3                   	ret    

00800bab <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bab:	f3 0f 1e fb          	endbr32 
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	57                   	push   %edi
  800bb3:	56                   	push   %esi
  800bb4:	53                   	push   %ebx
  800bb5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb8:	be 00 00 00 00       	mov    $0x0,%esi
  800bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc3:	b8 04 00 00 00       	mov    $0x4,%eax
  800bc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bcb:	89 f7                	mov    %esi,%edi
  800bcd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bcf:	85 c0                	test   %eax,%eax
  800bd1:	7f 08                	jg     800bdb <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5f                   	pop    %edi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bdb:	83 ec 0c             	sub    $0xc,%esp
  800bde:	50                   	push   %eax
  800bdf:	6a 04                	push   $0x4
  800be1:	68 a4 12 80 00       	push   $0x8012a4
  800be6:	6a 23                	push   $0x23
  800be8:	68 c1 12 80 00       	push   $0x8012c1
  800bed:	e8 84 01 00 00       	call   800d76 <_panic>

00800bf2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bf2:	f3 0f 1e fb          	endbr32 
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	57                   	push   %edi
  800bfa:	56                   	push   %esi
  800bfb:	53                   	push   %ebx
  800bfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bff:	8b 55 08             	mov    0x8(%ebp),%edx
  800c02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c05:	b8 05 00 00 00       	mov    $0x5,%eax
  800c0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c0d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c10:	8b 75 18             	mov    0x18(%ebp),%esi
  800c13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c15:	85 c0                	test   %eax,%eax
  800c17:	7f 08                	jg     800c21 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c1c:	5b                   	pop    %ebx
  800c1d:	5e                   	pop    %esi
  800c1e:	5f                   	pop    %edi
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c21:	83 ec 0c             	sub    $0xc,%esp
  800c24:	50                   	push   %eax
  800c25:	6a 05                	push   $0x5
  800c27:	68 a4 12 80 00       	push   $0x8012a4
  800c2c:	6a 23                	push   $0x23
  800c2e:	68 c1 12 80 00       	push   $0x8012c1
  800c33:	e8 3e 01 00 00       	call   800d76 <_panic>

00800c38 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c38:	f3 0f 1e fb          	endbr32 
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	57                   	push   %edi
  800c40:	56                   	push   %esi
  800c41:	53                   	push   %ebx
  800c42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c50:	b8 06 00 00 00       	mov    $0x6,%eax
  800c55:	89 df                	mov    %ebx,%edi
  800c57:	89 de                	mov    %ebx,%esi
  800c59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5b:	85 c0                	test   %eax,%eax
  800c5d:	7f 08                	jg     800c67 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c67:	83 ec 0c             	sub    $0xc,%esp
  800c6a:	50                   	push   %eax
  800c6b:	6a 06                	push   $0x6
  800c6d:	68 a4 12 80 00       	push   $0x8012a4
  800c72:	6a 23                	push   $0x23
  800c74:	68 c1 12 80 00       	push   $0x8012c1
  800c79:	e8 f8 00 00 00       	call   800d76 <_panic>

00800c7e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c7e:	f3 0f 1e fb          	endbr32 
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	b8 08 00 00 00       	mov    $0x8,%eax
  800c9b:	89 df                	mov    %ebx,%edi
  800c9d:	89 de                	mov    %ebx,%esi
  800c9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca1:	85 c0                	test   %eax,%eax
  800ca3:	7f 08                	jg     800cad <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cad:	83 ec 0c             	sub    $0xc,%esp
  800cb0:	50                   	push   %eax
  800cb1:	6a 08                	push   $0x8
  800cb3:	68 a4 12 80 00       	push   $0x8012a4
  800cb8:	6a 23                	push   $0x23
  800cba:	68 c1 12 80 00       	push   $0x8012c1
  800cbf:	e8 b2 00 00 00       	call   800d76 <_panic>

00800cc4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cc4:	f3 0f 1e fb          	endbr32 
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	57                   	push   %edi
  800ccc:	56                   	push   %esi
  800ccd:	53                   	push   %ebx
  800cce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdc:	b8 09 00 00 00       	mov    $0x9,%eax
  800ce1:	89 df                	mov    %ebx,%edi
  800ce3:	89 de                	mov    %ebx,%esi
  800ce5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	7f 08                	jg     800cf3 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	50                   	push   %eax
  800cf7:	6a 09                	push   $0x9
  800cf9:	68 a4 12 80 00       	push   $0x8012a4
  800cfe:	6a 23                	push   $0x23
  800d00:	68 c1 12 80 00       	push   $0x8012c1
  800d05:	e8 6c 00 00 00       	call   800d76 <_panic>

00800d0a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d0a:	f3 0f 1e fb          	endbr32 
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d1f:	be 00 00 00 00       	mov    $0x0,%esi
  800d24:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d27:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d2a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d31:	f3 0f 1e fb          	endbr32 
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d43:	8b 55 08             	mov    0x8(%ebp),%edx
  800d46:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d4b:	89 cb                	mov    %ecx,%ebx
  800d4d:	89 cf                	mov    %ecx,%edi
  800d4f:	89 ce                	mov    %ecx,%esi
  800d51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d53:	85 c0                	test   %eax,%eax
  800d55:	7f 08                	jg     800d5f <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5f:	83 ec 0c             	sub    $0xc,%esp
  800d62:	50                   	push   %eax
  800d63:	6a 0c                	push   $0xc
  800d65:	68 a4 12 80 00       	push   $0x8012a4
  800d6a:	6a 23                	push   $0x23
  800d6c:	68 c1 12 80 00       	push   $0x8012c1
  800d71:	e8 00 00 00 00       	call   800d76 <_panic>

00800d76 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d76:	f3 0f 1e fb          	endbr32 
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	56                   	push   %esi
  800d7e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800d7f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d82:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800d88:	e8 d8 fd ff ff       	call   800b65 <sys_getenvid>
  800d8d:	83 ec 0c             	sub    $0xc,%esp
  800d90:	ff 75 0c             	pushl  0xc(%ebp)
  800d93:	ff 75 08             	pushl  0x8(%ebp)
  800d96:	56                   	push   %esi
  800d97:	50                   	push   %eax
  800d98:	68 d0 12 80 00       	push   $0x8012d0
  800d9d:	e8 bd f3 ff ff       	call   80015f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800da2:	83 c4 18             	add    $0x18,%esp
  800da5:	53                   	push   %ebx
  800da6:	ff 75 10             	pushl  0x10(%ebp)
  800da9:	e8 5c f3 ff ff       	call   80010a <vcprintf>
	cprintf("\n");
  800dae:	c7 04 24 2c 10 80 00 	movl   $0x80102c,(%esp)
  800db5:	e8 a5 f3 ff ff       	call   80015f <cprintf>
  800dba:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800dbd:	cc                   	int3   
  800dbe:	eb fd                	jmp    800dbd <_panic+0x47>

00800dc0 <__udivdi3>:
  800dc0:	f3 0f 1e fb          	endbr32 
  800dc4:	55                   	push   %ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 1c             	sub    $0x1c,%esp
  800dcb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800dcf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800dd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800dd7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ddb:	85 d2                	test   %edx,%edx
  800ddd:	75 19                	jne    800df8 <__udivdi3+0x38>
  800ddf:	39 f3                	cmp    %esi,%ebx
  800de1:	76 4d                	jbe    800e30 <__udivdi3+0x70>
  800de3:	31 ff                	xor    %edi,%edi
  800de5:	89 e8                	mov    %ebp,%eax
  800de7:	89 f2                	mov    %esi,%edx
  800de9:	f7 f3                	div    %ebx
  800deb:	89 fa                	mov    %edi,%edx
  800ded:	83 c4 1c             	add    $0x1c,%esp
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    
  800df5:	8d 76 00             	lea    0x0(%esi),%esi
  800df8:	39 f2                	cmp    %esi,%edx
  800dfa:	76 14                	jbe    800e10 <__udivdi3+0x50>
  800dfc:	31 ff                	xor    %edi,%edi
  800dfe:	31 c0                	xor    %eax,%eax
  800e00:	89 fa                	mov    %edi,%edx
  800e02:	83 c4 1c             	add    $0x1c,%esp
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    
  800e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e10:	0f bd fa             	bsr    %edx,%edi
  800e13:	83 f7 1f             	xor    $0x1f,%edi
  800e16:	75 48                	jne    800e60 <__udivdi3+0xa0>
  800e18:	39 f2                	cmp    %esi,%edx
  800e1a:	72 06                	jb     800e22 <__udivdi3+0x62>
  800e1c:	31 c0                	xor    %eax,%eax
  800e1e:	39 eb                	cmp    %ebp,%ebx
  800e20:	77 de                	ja     800e00 <__udivdi3+0x40>
  800e22:	b8 01 00 00 00       	mov    $0x1,%eax
  800e27:	eb d7                	jmp    800e00 <__udivdi3+0x40>
  800e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e30:	89 d9                	mov    %ebx,%ecx
  800e32:	85 db                	test   %ebx,%ebx
  800e34:	75 0b                	jne    800e41 <__udivdi3+0x81>
  800e36:	b8 01 00 00 00       	mov    $0x1,%eax
  800e3b:	31 d2                	xor    %edx,%edx
  800e3d:	f7 f3                	div    %ebx
  800e3f:	89 c1                	mov    %eax,%ecx
  800e41:	31 d2                	xor    %edx,%edx
  800e43:	89 f0                	mov    %esi,%eax
  800e45:	f7 f1                	div    %ecx
  800e47:	89 c6                	mov    %eax,%esi
  800e49:	89 e8                	mov    %ebp,%eax
  800e4b:	89 f7                	mov    %esi,%edi
  800e4d:	f7 f1                	div    %ecx
  800e4f:	89 fa                	mov    %edi,%edx
  800e51:	83 c4 1c             	add    $0x1c,%esp
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    
  800e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e60:	89 f9                	mov    %edi,%ecx
  800e62:	b8 20 00 00 00       	mov    $0x20,%eax
  800e67:	29 f8                	sub    %edi,%eax
  800e69:	d3 e2                	shl    %cl,%edx
  800e6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e6f:	89 c1                	mov    %eax,%ecx
  800e71:	89 da                	mov    %ebx,%edx
  800e73:	d3 ea                	shr    %cl,%edx
  800e75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e79:	09 d1                	or     %edx,%ecx
  800e7b:	89 f2                	mov    %esi,%edx
  800e7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e81:	89 f9                	mov    %edi,%ecx
  800e83:	d3 e3                	shl    %cl,%ebx
  800e85:	89 c1                	mov    %eax,%ecx
  800e87:	d3 ea                	shr    %cl,%edx
  800e89:	89 f9                	mov    %edi,%ecx
  800e8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e8f:	89 eb                	mov    %ebp,%ebx
  800e91:	d3 e6                	shl    %cl,%esi
  800e93:	89 c1                	mov    %eax,%ecx
  800e95:	d3 eb                	shr    %cl,%ebx
  800e97:	09 de                	or     %ebx,%esi
  800e99:	89 f0                	mov    %esi,%eax
  800e9b:	f7 74 24 08          	divl   0x8(%esp)
  800e9f:	89 d6                	mov    %edx,%esi
  800ea1:	89 c3                	mov    %eax,%ebx
  800ea3:	f7 64 24 0c          	mull   0xc(%esp)
  800ea7:	39 d6                	cmp    %edx,%esi
  800ea9:	72 15                	jb     800ec0 <__udivdi3+0x100>
  800eab:	89 f9                	mov    %edi,%ecx
  800ead:	d3 e5                	shl    %cl,%ebp
  800eaf:	39 c5                	cmp    %eax,%ebp
  800eb1:	73 04                	jae    800eb7 <__udivdi3+0xf7>
  800eb3:	39 d6                	cmp    %edx,%esi
  800eb5:	74 09                	je     800ec0 <__udivdi3+0x100>
  800eb7:	89 d8                	mov    %ebx,%eax
  800eb9:	31 ff                	xor    %edi,%edi
  800ebb:	e9 40 ff ff ff       	jmp    800e00 <__udivdi3+0x40>
  800ec0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800ec3:	31 ff                	xor    %edi,%edi
  800ec5:	e9 36 ff ff ff       	jmp    800e00 <__udivdi3+0x40>
  800eca:	66 90                	xchg   %ax,%ax
  800ecc:	66 90                	xchg   %ax,%ax
  800ece:	66 90                	xchg   %ax,%ax

00800ed0 <__umoddi3>:
  800ed0:	f3 0f 1e fb          	endbr32 
  800ed4:	55                   	push   %ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	53                   	push   %ebx
  800ed8:	83 ec 1c             	sub    $0x1c,%esp
  800edb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800edf:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ee3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ee7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	75 19                	jne    800f08 <__umoddi3+0x38>
  800eef:	39 df                	cmp    %ebx,%edi
  800ef1:	76 5d                	jbe    800f50 <__umoddi3+0x80>
  800ef3:	89 f0                	mov    %esi,%eax
  800ef5:	89 da                	mov    %ebx,%edx
  800ef7:	f7 f7                	div    %edi
  800ef9:	89 d0                	mov    %edx,%eax
  800efb:	31 d2                	xor    %edx,%edx
  800efd:	83 c4 1c             	add    $0x1c,%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
  800f05:	8d 76 00             	lea    0x0(%esi),%esi
  800f08:	89 f2                	mov    %esi,%edx
  800f0a:	39 d8                	cmp    %ebx,%eax
  800f0c:	76 12                	jbe    800f20 <__umoddi3+0x50>
  800f0e:	89 f0                	mov    %esi,%eax
  800f10:	89 da                	mov    %ebx,%edx
  800f12:	83 c4 1c             	add    $0x1c,%esp
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    
  800f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f20:	0f bd e8             	bsr    %eax,%ebp
  800f23:	83 f5 1f             	xor    $0x1f,%ebp
  800f26:	75 50                	jne    800f78 <__umoddi3+0xa8>
  800f28:	39 d8                	cmp    %ebx,%eax
  800f2a:	0f 82 e0 00 00 00    	jb     801010 <__umoddi3+0x140>
  800f30:	89 d9                	mov    %ebx,%ecx
  800f32:	39 f7                	cmp    %esi,%edi
  800f34:	0f 86 d6 00 00 00    	jbe    801010 <__umoddi3+0x140>
  800f3a:	89 d0                	mov    %edx,%eax
  800f3c:	89 ca                	mov    %ecx,%edx
  800f3e:	83 c4 1c             	add    $0x1c,%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    
  800f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f4d:	8d 76 00             	lea    0x0(%esi),%esi
  800f50:	89 fd                	mov    %edi,%ebp
  800f52:	85 ff                	test   %edi,%edi
  800f54:	75 0b                	jne    800f61 <__umoddi3+0x91>
  800f56:	b8 01 00 00 00       	mov    $0x1,%eax
  800f5b:	31 d2                	xor    %edx,%edx
  800f5d:	f7 f7                	div    %edi
  800f5f:	89 c5                	mov    %eax,%ebp
  800f61:	89 d8                	mov    %ebx,%eax
  800f63:	31 d2                	xor    %edx,%edx
  800f65:	f7 f5                	div    %ebp
  800f67:	89 f0                	mov    %esi,%eax
  800f69:	f7 f5                	div    %ebp
  800f6b:	89 d0                	mov    %edx,%eax
  800f6d:	31 d2                	xor    %edx,%edx
  800f6f:	eb 8c                	jmp    800efd <__umoddi3+0x2d>
  800f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f78:	89 e9                	mov    %ebp,%ecx
  800f7a:	ba 20 00 00 00       	mov    $0x20,%edx
  800f7f:	29 ea                	sub    %ebp,%edx
  800f81:	d3 e0                	shl    %cl,%eax
  800f83:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f87:	89 d1                	mov    %edx,%ecx
  800f89:	89 f8                	mov    %edi,%eax
  800f8b:	d3 e8                	shr    %cl,%eax
  800f8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f91:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f95:	8b 54 24 04          	mov    0x4(%esp),%edx
  800f99:	09 c1                	or     %eax,%ecx
  800f9b:	89 d8                	mov    %ebx,%eax
  800f9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fa1:	89 e9                	mov    %ebp,%ecx
  800fa3:	d3 e7                	shl    %cl,%edi
  800fa5:	89 d1                	mov    %edx,%ecx
  800fa7:	d3 e8                	shr    %cl,%eax
  800fa9:	89 e9                	mov    %ebp,%ecx
  800fab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800faf:	d3 e3                	shl    %cl,%ebx
  800fb1:	89 c7                	mov    %eax,%edi
  800fb3:	89 d1                	mov    %edx,%ecx
  800fb5:	89 f0                	mov    %esi,%eax
  800fb7:	d3 e8                	shr    %cl,%eax
  800fb9:	89 e9                	mov    %ebp,%ecx
  800fbb:	89 fa                	mov    %edi,%edx
  800fbd:	d3 e6                	shl    %cl,%esi
  800fbf:	09 d8                	or     %ebx,%eax
  800fc1:	f7 74 24 08          	divl   0x8(%esp)
  800fc5:	89 d1                	mov    %edx,%ecx
  800fc7:	89 f3                	mov    %esi,%ebx
  800fc9:	f7 64 24 0c          	mull   0xc(%esp)
  800fcd:	89 c6                	mov    %eax,%esi
  800fcf:	89 d7                	mov    %edx,%edi
  800fd1:	39 d1                	cmp    %edx,%ecx
  800fd3:	72 06                	jb     800fdb <__umoddi3+0x10b>
  800fd5:	75 10                	jne    800fe7 <__umoddi3+0x117>
  800fd7:	39 c3                	cmp    %eax,%ebx
  800fd9:	73 0c                	jae    800fe7 <__umoddi3+0x117>
  800fdb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  800fdf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800fe3:	89 d7                	mov    %edx,%edi
  800fe5:	89 c6                	mov    %eax,%esi
  800fe7:	89 ca                	mov    %ecx,%edx
  800fe9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fee:	29 f3                	sub    %esi,%ebx
  800ff0:	19 fa                	sbb    %edi,%edx
  800ff2:	89 d0                	mov    %edx,%eax
  800ff4:	d3 e0                	shl    %cl,%eax
  800ff6:	89 e9                	mov    %ebp,%ecx
  800ff8:	d3 eb                	shr    %cl,%ebx
  800ffa:	d3 ea                	shr    %cl,%edx
  800ffc:	09 d8                	or     %ebx,%eax
  800ffe:	83 c4 1c             	add    $0x1c,%esp
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    
  801006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80100d:	8d 76 00             	lea    0x0(%esi),%esi
  801010:	29 fe                	sub    %edi,%esi
  801012:	19 c3                	sbb    %eax,%ebx
  801014:	89 f2                	mov    %esi,%edx
  801016:	89 d9                	mov    %ebx,%ecx
  801018:	e9 1d ff ff ff       	jmp    800f3a <__umoddi3+0x6a>
