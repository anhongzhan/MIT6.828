
obj/user/faultdie:     file format elf32-i386


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
  80002c:	e8 57 00 00 00       	call   800088 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 0c             	sub    $0xc,%esp
  80003d:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800040:	8b 42 04             	mov    0x4(%edx),%eax
  800043:	83 e0 07             	and    $0x7,%eax
  800046:	50                   	push   %eax
  800047:	ff 32                	pushl  (%edx)
  800049:	68 e0 10 80 00       	push   $0x8010e0
  80004e:	e8 32 01 00 00       	call   800185 <cprintf>
	sys_env_destroy(sys_getenvid());
  800053:	e8 33 0b 00 00       	call   800b8b <sys_getenvid>
  800058:	89 04 24             	mov    %eax,(%esp)
  80005b:	e8 e6 0a 00 00       	call   800b46 <sys_env_destroy>
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <umain>:

void
umain(int argc, char **argv)
{
  800065:	f3 0f 1e fb          	endbr32 
  800069:	55                   	push   %ebp
  80006a:	89 e5                	mov    %esp,%ebp
  80006c:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  80006f:	68 33 00 80 00       	push   $0x800033
  800074:	e8 23 0d 00 00       	call   800d9c <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800079:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800080:	00 00 00 
}
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	c9                   	leave  
  800087:	c3                   	ret    

00800088 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800088:	f3 0f 1e fb          	endbr32 
  80008c:	55                   	push   %ebp
  80008d:	89 e5                	mov    %esp,%ebp
  80008f:	56                   	push   %esi
  800090:	53                   	push   %ebx
  800091:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800094:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800097:	e8 ef 0a 00 00       	call   800b8b <sys_getenvid>
  80009c:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a9:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ae:	85 db                	test   %ebx,%ebx
  8000b0:	7e 07                	jle    8000b9 <libmain+0x31>
		binaryname = argv[0];
  8000b2:	8b 06                	mov    (%esi),%eax
  8000b4:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	56                   	push   %esi
  8000bd:	53                   	push   %ebx
  8000be:	e8 a2 ff ff ff       	call   800065 <umain>

	// exit gracefully
	exit();
  8000c3:	e8 0a 00 00 00       	call   8000d2 <exit>
}
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d2:	f3 0f 1e fb          	endbr32 
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000dc:	6a 00                	push   $0x0
  8000de:	e8 63 0a 00 00       	call   800b46 <sys_env_destroy>
}
  8000e3:	83 c4 10             	add    $0x10,%esp
  8000e6:	c9                   	leave  
  8000e7:	c3                   	ret    

008000e8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e8:	f3 0f 1e fb          	endbr32 
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 04             	sub    $0x4,%esp
  8000f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000f6:	8b 13                	mov    (%ebx),%edx
  8000f8:	8d 42 01             	lea    0x1(%edx),%eax
  8000fb:	89 03                	mov    %eax,(%ebx)
  8000fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800100:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800104:	3d ff 00 00 00       	cmp    $0xff,%eax
  800109:	74 09                	je     800114 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80010b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80010f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800112:	c9                   	leave  
  800113:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	68 ff 00 00 00       	push   $0xff
  80011c:	8d 43 08             	lea    0x8(%ebx),%eax
  80011f:	50                   	push   %eax
  800120:	e8 dc 09 00 00       	call   800b01 <sys_cputs>
		b->idx = 0;
  800125:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb db                	jmp    80010b <putch+0x23>

00800130 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800130:	f3 0f 1e fb          	endbr32 
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80013d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800144:	00 00 00 
	b.cnt = 0;
  800147:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80014e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800151:	ff 75 0c             	pushl  0xc(%ebp)
  800154:	ff 75 08             	pushl  0x8(%ebp)
  800157:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80015d:	50                   	push   %eax
  80015e:	68 e8 00 80 00       	push   $0x8000e8
  800163:	e8 20 01 00 00       	call   800288 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800168:	83 c4 08             	add    $0x8,%esp
  80016b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800171:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800177:	50                   	push   %eax
  800178:	e8 84 09 00 00       	call   800b01 <sys_cputs>

	return b.cnt;
}
  80017d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800183:	c9                   	leave  
  800184:	c3                   	ret    

00800185 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800185:	f3 0f 1e fb          	endbr32 
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80018f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800192:	50                   	push   %eax
  800193:	ff 75 08             	pushl  0x8(%ebp)
  800196:	e8 95 ff ff ff       	call   800130 <vcprintf>
	va_end(ap);

	return cnt;
}
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    

0080019d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	57                   	push   %edi
  8001a1:	56                   	push   %esi
  8001a2:	53                   	push   %ebx
  8001a3:	83 ec 1c             	sub    $0x1c,%esp
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 d6                	mov    %edx,%esi
  8001aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b0:	89 d1                	mov    %edx,%ecx
  8001b2:	89 c2                	mov    %eax,%edx
  8001b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001b7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ca:	39 c2                	cmp    %eax,%edx
  8001cc:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001cf:	72 3e                	jb     80020f <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	ff 75 18             	pushl  0x18(%ebp)
  8001d7:	83 eb 01             	sub    $0x1,%ebx
  8001da:	53                   	push   %ebx
  8001db:	50                   	push   %eax
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001eb:	e8 90 0c 00 00       	call   800e80 <__udivdi3>
  8001f0:	83 c4 18             	add    $0x18,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	89 f2                	mov    %esi,%edx
  8001f7:	89 f8                	mov    %edi,%eax
  8001f9:	e8 9f ff ff ff       	call   80019d <printnum>
  8001fe:	83 c4 20             	add    $0x20,%esp
  800201:	eb 13                	jmp    800216 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	56                   	push   %esi
  800207:	ff 75 18             	pushl  0x18(%ebp)
  80020a:	ff d7                	call   *%edi
  80020c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80020f:	83 eb 01             	sub    $0x1,%ebx
  800212:	85 db                	test   %ebx,%ebx
  800214:	7f ed                	jg     800203 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800216:	83 ec 08             	sub    $0x8,%esp
  800219:	56                   	push   %esi
  80021a:	83 ec 04             	sub    $0x4,%esp
  80021d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800220:	ff 75 e0             	pushl  -0x20(%ebp)
  800223:	ff 75 dc             	pushl  -0x24(%ebp)
  800226:	ff 75 d8             	pushl  -0x28(%ebp)
  800229:	e8 62 0d 00 00       	call   800f90 <__umoddi3>
  80022e:	83 c4 14             	add    $0x14,%esp
  800231:	0f be 80 06 11 80 00 	movsbl 0x801106(%eax),%eax
  800238:	50                   	push   %eax
  800239:	ff d7                	call   *%edi
}
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800241:	5b                   	pop    %ebx
  800242:	5e                   	pop    %esi
  800243:	5f                   	pop    %edi
  800244:	5d                   	pop    %ebp
  800245:	c3                   	ret    

00800246 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800246:	f3 0f 1e fb          	endbr32 
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800250:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800254:	8b 10                	mov    (%eax),%edx
  800256:	3b 50 04             	cmp    0x4(%eax),%edx
  800259:	73 0a                	jae    800265 <sprintputch+0x1f>
		*b->buf++ = ch;
  80025b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80025e:	89 08                	mov    %ecx,(%eax)
  800260:	8b 45 08             	mov    0x8(%ebp),%eax
  800263:	88 02                	mov    %al,(%edx)
}
  800265:	5d                   	pop    %ebp
  800266:	c3                   	ret    

00800267 <printfmt>:
{
  800267:	f3 0f 1e fb          	endbr32 
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800271:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800274:	50                   	push   %eax
  800275:	ff 75 10             	pushl  0x10(%ebp)
  800278:	ff 75 0c             	pushl  0xc(%ebp)
  80027b:	ff 75 08             	pushl  0x8(%ebp)
  80027e:	e8 05 00 00 00       	call   800288 <vprintfmt>
}
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	c9                   	leave  
  800287:	c3                   	ret    

00800288 <vprintfmt>:
{
  800288:	f3 0f 1e fb          	endbr32 
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	57                   	push   %edi
  800290:	56                   	push   %esi
  800291:	53                   	push   %ebx
  800292:	83 ec 3c             	sub    $0x3c,%esp
  800295:	8b 75 08             	mov    0x8(%ebp),%esi
  800298:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80029b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029e:	e9 8e 03 00 00       	jmp    800631 <vprintfmt+0x3a9>
		padc = ' ';
  8002a3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002a7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c1:	8d 47 01             	lea    0x1(%edi),%eax
  8002c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c7:	0f b6 17             	movzbl (%edi),%edx
  8002ca:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002cd:	3c 55                	cmp    $0x55,%al
  8002cf:	0f 87 df 03 00 00    	ja     8006b4 <vprintfmt+0x42c>
  8002d5:	0f b6 c0             	movzbl %al,%eax
  8002d8:	3e ff 24 85 c0 11 80 	notrack jmp *0x8011c0(,%eax,4)
  8002df:	00 
  8002e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002e7:	eb d8                	jmp    8002c1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002ec:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002f0:	eb cf                	jmp    8002c1 <vprintfmt+0x39>
  8002f2:	0f b6 d2             	movzbl %dl,%edx
  8002f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800300:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800303:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800307:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80030a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80030d:	83 f9 09             	cmp    $0x9,%ecx
  800310:	77 55                	ja     800367 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800312:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800315:	eb e9                	jmp    800300 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800317:	8b 45 14             	mov    0x14(%ebp),%eax
  80031a:	8b 00                	mov    (%eax),%eax
  80031c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031f:	8b 45 14             	mov    0x14(%ebp),%eax
  800322:	8d 40 04             	lea    0x4(%eax),%eax
  800325:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80032b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80032f:	79 90                	jns    8002c1 <vprintfmt+0x39>
				width = precision, precision = -1;
  800331:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800334:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800337:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80033e:	eb 81                	jmp    8002c1 <vprintfmt+0x39>
  800340:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800343:	85 c0                	test   %eax,%eax
  800345:	ba 00 00 00 00       	mov    $0x0,%edx
  80034a:	0f 49 d0             	cmovns %eax,%edx
  80034d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800353:	e9 69 ff ff ff       	jmp    8002c1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80035b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800362:	e9 5a ff ff ff       	jmp    8002c1 <vprintfmt+0x39>
  800367:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80036a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036d:	eb bc                	jmp    80032b <vprintfmt+0xa3>
			lflag++;
  80036f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800372:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800375:	e9 47 ff ff ff       	jmp    8002c1 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80037a:	8b 45 14             	mov    0x14(%ebp),%eax
  80037d:	8d 78 04             	lea    0x4(%eax),%edi
  800380:	83 ec 08             	sub    $0x8,%esp
  800383:	53                   	push   %ebx
  800384:	ff 30                	pushl  (%eax)
  800386:	ff d6                	call   *%esi
			break;
  800388:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80038b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80038e:	e9 9b 02 00 00       	jmp    80062e <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800393:	8b 45 14             	mov    0x14(%ebp),%eax
  800396:	8d 78 04             	lea    0x4(%eax),%edi
  800399:	8b 00                	mov    (%eax),%eax
  80039b:	99                   	cltd   
  80039c:	31 d0                	xor    %edx,%eax
  80039e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a0:	83 f8 08             	cmp    $0x8,%eax
  8003a3:	7f 23                	jg     8003c8 <vprintfmt+0x140>
  8003a5:	8b 14 85 20 13 80 00 	mov    0x801320(,%eax,4),%edx
  8003ac:	85 d2                	test   %edx,%edx
  8003ae:	74 18                	je     8003c8 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003b0:	52                   	push   %edx
  8003b1:	68 27 11 80 00       	push   $0x801127
  8003b6:	53                   	push   %ebx
  8003b7:	56                   	push   %esi
  8003b8:	e8 aa fe ff ff       	call   800267 <printfmt>
  8003bd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c3:	e9 66 02 00 00       	jmp    80062e <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003c8:	50                   	push   %eax
  8003c9:	68 1e 11 80 00       	push   $0x80111e
  8003ce:	53                   	push   %ebx
  8003cf:	56                   	push   %esi
  8003d0:	e8 92 fe ff ff       	call   800267 <printfmt>
  8003d5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003db:	e9 4e 02 00 00       	jmp    80062e <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e3:	83 c0 04             	add    $0x4,%eax
  8003e6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003ee:	85 d2                	test   %edx,%edx
  8003f0:	b8 17 11 80 00       	mov    $0x801117,%eax
  8003f5:	0f 45 c2             	cmovne %edx,%eax
  8003f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ff:	7e 06                	jle    800407 <vprintfmt+0x17f>
  800401:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800405:	75 0d                	jne    800414 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800407:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80040a:	89 c7                	mov    %eax,%edi
  80040c:	03 45 e0             	add    -0x20(%ebp),%eax
  80040f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800412:	eb 55                	jmp    800469 <vprintfmt+0x1e1>
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	ff 75 d8             	pushl  -0x28(%ebp)
  80041a:	ff 75 cc             	pushl  -0x34(%ebp)
  80041d:	e8 46 03 00 00       	call   800768 <strnlen>
  800422:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800425:	29 c2                	sub    %eax,%edx
  800427:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80042a:	83 c4 10             	add    $0x10,%esp
  80042d:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80042f:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800433:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800436:	85 ff                	test   %edi,%edi
  800438:	7e 11                	jle    80044b <vprintfmt+0x1c3>
					putch(padc, putdat);
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	53                   	push   %ebx
  80043e:	ff 75 e0             	pushl  -0x20(%ebp)
  800441:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800443:	83 ef 01             	sub    $0x1,%edi
  800446:	83 c4 10             	add    $0x10,%esp
  800449:	eb eb                	jmp    800436 <vprintfmt+0x1ae>
  80044b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80044e:	85 d2                	test   %edx,%edx
  800450:	b8 00 00 00 00       	mov    $0x0,%eax
  800455:	0f 49 c2             	cmovns %edx,%eax
  800458:	29 c2                	sub    %eax,%edx
  80045a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80045d:	eb a8                	jmp    800407 <vprintfmt+0x17f>
					putch(ch, putdat);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	53                   	push   %ebx
  800463:	52                   	push   %edx
  800464:	ff d6                	call   *%esi
  800466:	83 c4 10             	add    $0x10,%esp
  800469:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80046e:	83 c7 01             	add    $0x1,%edi
  800471:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800475:	0f be d0             	movsbl %al,%edx
  800478:	85 d2                	test   %edx,%edx
  80047a:	74 4b                	je     8004c7 <vprintfmt+0x23f>
  80047c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800480:	78 06                	js     800488 <vprintfmt+0x200>
  800482:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800486:	78 1e                	js     8004a6 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800488:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80048c:	74 d1                	je     80045f <vprintfmt+0x1d7>
  80048e:	0f be c0             	movsbl %al,%eax
  800491:	83 e8 20             	sub    $0x20,%eax
  800494:	83 f8 5e             	cmp    $0x5e,%eax
  800497:	76 c6                	jbe    80045f <vprintfmt+0x1d7>
					putch('?', putdat);
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	53                   	push   %ebx
  80049d:	6a 3f                	push   $0x3f
  80049f:	ff d6                	call   *%esi
  8004a1:	83 c4 10             	add    $0x10,%esp
  8004a4:	eb c3                	jmp    800469 <vprintfmt+0x1e1>
  8004a6:	89 cf                	mov    %ecx,%edi
  8004a8:	eb 0e                	jmp    8004b8 <vprintfmt+0x230>
				putch(' ', putdat);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	53                   	push   %ebx
  8004ae:	6a 20                	push   $0x20
  8004b0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004b2:	83 ef 01             	sub    $0x1,%edi
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	85 ff                	test   %edi,%edi
  8004ba:	7f ee                	jg     8004aa <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8004c2:	e9 67 01 00 00       	jmp    80062e <vprintfmt+0x3a6>
  8004c7:	89 cf                	mov    %ecx,%edi
  8004c9:	eb ed                	jmp    8004b8 <vprintfmt+0x230>
	if (lflag >= 2)
  8004cb:	83 f9 01             	cmp    $0x1,%ecx
  8004ce:	7f 1b                	jg     8004eb <vprintfmt+0x263>
	else if (lflag)
  8004d0:	85 c9                	test   %ecx,%ecx
  8004d2:	74 63                	je     800537 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004dc:	99                   	cltd   
  8004dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e3:	8d 40 04             	lea    0x4(%eax),%eax
  8004e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e9:	eb 17                	jmp    800502 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8b 50 04             	mov    0x4(%eax),%edx
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 40 08             	lea    0x8(%eax),%eax
  8004ff:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800502:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800505:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800508:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80050d:	85 c9                	test   %ecx,%ecx
  80050f:	0f 89 ff 00 00 00    	jns    800614 <vprintfmt+0x38c>
				putch('-', putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	6a 2d                	push   $0x2d
  80051b:	ff d6                	call   *%esi
				num = -(long long) num;
  80051d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800520:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800523:	f7 da                	neg    %edx
  800525:	83 d1 00             	adc    $0x0,%ecx
  800528:	f7 d9                	neg    %ecx
  80052a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80052d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800532:	e9 dd 00 00 00       	jmp    800614 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053f:	99                   	cltd   
  800540:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800543:	8b 45 14             	mov    0x14(%ebp),%eax
  800546:	8d 40 04             	lea    0x4(%eax),%eax
  800549:	89 45 14             	mov    %eax,0x14(%ebp)
  80054c:	eb b4                	jmp    800502 <vprintfmt+0x27a>
	if (lflag >= 2)
  80054e:	83 f9 01             	cmp    $0x1,%ecx
  800551:	7f 1e                	jg     800571 <vprintfmt+0x2e9>
	else if (lflag)
  800553:	85 c9                	test   %ecx,%ecx
  800555:	74 32                	je     800589 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8b 10                	mov    (%eax),%edx
  80055c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800561:	8d 40 04             	lea    0x4(%eax),%eax
  800564:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800567:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80056c:	e9 a3 00 00 00       	jmp    800614 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8b 10                	mov    (%eax),%edx
  800576:	8b 48 04             	mov    0x4(%eax),%ecx
  800579:	8d 40 08             	lea    0x8(%eax),%eax
  80057c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800584:	e9 8b 00 00 00       	jmp    800614 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8b 10                	mov    (%eax),%edx
  80058e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800593:	8d 40 04             	lea    0x4(%eax),%eax
  800596:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800599:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80059e:	eb 74                	jmp    800614 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005a0:	83 f9 01             	cmp    $0x1,%ecx
  8005a3:	7f 1b                	jg     8005c0 <vprintfmt+0x338>
	else if (lflag)
  8005a5:	85 c9                	test   %ecx,%ecx
  8005a7:	74 2c                	je     8005d5 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8b 10                	mov    (%eax),%edx
  8005ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b3:	8d 40 04             	lea    0x4(%eax),%eax
  8005b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b9:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005be:	eb 54                	jmp    800614 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8b 10                	mov    (%eax),%edx
  8005c5:	8b 48 04             	mov    0x4(%eax),%ecx
  8005c8:	8d 40 08             	lea    0x8(%eax),%eax
  8005cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ce:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005d3:	eb 3f                	jmp    800614 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8b 10                	mov    (%eax),%edx
  8005da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005df:	8d 40 04             	lea    0x4(%eax),%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005e5:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005ea:	eb 28                	jmp    800614 <vprintfmt+0x38c>
			putch('0', putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	53                   	push   %ebx
  8005f0:	6a 30                	push   $0x30
  8005f2:	ff d6                	call   *%esi
			putch('x', putdat);
  8005f4:	83 c4 08             	add    $0x8,%esp
  8005f7:	53                   	push   %ebx
  8005f8:	6a 78                	push   $0x78
  8005fa:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 10                	mov    (%eax),%edx
  800601:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800606:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800609:	8d 40 04             	lea    0x4(%eax),%eax
  80060c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80060f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800614:	83 ec 0c             	sub    $0xc,%esp
  800617:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80061b:	57                   	push   %edi
  80061c:	ff 75 e0             	pushl  -0x20(%ebp)
  80061f:	50                   	push   %eax
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	89 da                	mov    %ebx,%edx
  800624:	89 f0                	mov    %esi,%eax
  800626:	e8 72 fb ff ff       	call   80019d <printnum>
			break;
  80062b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80062e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800631:	83 c7 01             	add    $0x1,%edi
  800634:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800638:	83 f8 25             	cmp    $0x25,%eax
  80063b:	0f 84 62 fc ff ff    	je     8002a3 <vprintfmt+0x1b>
			if (ch == '\0')
  800641:	85 c0                	test   %eax,%eax
  800643:	0f 84 8b 00 00 00    	je     8006d4 <vprintfmt+0x44c>
			putch(ch, putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	53                   	push   %ebx
  80064d:	50                   	push   %eax
  80064e:	ff d6                	call   *%esi
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	eb dc                	jmp    800631 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800655:	83 f9 01             	cmp    $0x1,%ecx
  800658:	7f 1b                	jg     800675 <vprintfmt+0x3ed>
	else if (lflag)
  80065a:	85 c9                	test   %ecx,%ecx
  80065c:	74 2c                	je     80068a <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 10                	mov    (%eax),%edx
  800663:	b9 00 00 00 00       	mov    $0x0,%ecx
  800668:	8d 40 04             	lea    0x4(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80066e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800673:	eb 9f                	jmp    800614 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8b 10                	mov    (%eax),%edx
  80067a:	8b 48 04             	mov    0x4(%eax),%ecx
  80067d:	8d 40 08             	lea    0x8(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800683:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800688:	eb 8a                	jmp    800614 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 10                	mov    (%eax),%edx
  80068f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800694:	8d 40 04             	lea    0x4(%eax),%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80069f:	e9 70 ff ff ff       	jmp    800614 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	53                   	push   %ebx
  8006a8:	6a 25                	push   $0x25
  8006aa:	ff d6                	call   *%esi
			break;
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	e9 7a ff ff ff       	jmp    80062e <vprintfmt+0x3a6>
			putch('%', putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	6a 25                	push   $0x25
  8006ba:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	89 f8                	mov    %edi,%eax
  8006c1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006c5:	74 05                	je     8006cc <vprintfmt+0x444>
  8006c7:	83 e8 01             	sub    $0x1,%eax
  8006ca:	eb f5                	jmp    8006c1 <vprintfmt+0x439>
  8006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cf:	e9 5a ff ff ff       	jmp    80062e <vprintfmt+0x3a6>
}
  8006d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d7:	5b                   	pop    %ebx
  8006d8:	5e                   	pop    %esi
  8006d9:	5f                   	pop    %edi
  8006da:	5d                   	pop    %ebp
  8006db:	c3                   	ret    

008006dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006dc:	f3 0f 1e fb          	endbr32 
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006ef:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006f3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006fd:	85 c0                	test   %eax,%eax
  8006ff:	74 26                	je     800727 <vsnprintf+0x4b>
  800701:	85 d2                	test   %edx,%edx
  800703:	7e 22                	jle    800727 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800705:	ff 75 14             	pushl  0x14(%ebp)
  800708:	ff 75 10             	pushl  0x10(%ebp)
  80070b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80070e:	50                   	push   %eax
  80070f:	68 46 02 80 00       	push   $0x800246
  800714:	e8 6f fb ff ff       	call   800288 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800722:	83 c4 10             	add    $0x10,%esp
}
  800725:	c9                   	leave  
  800726:	c3                   	ret    
		return -E_INVAL;
  800727:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80072c:	eb f7                	jmp    800725 <vsnprintf+0x49>

0080072e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80072e:	f3 0f 1e fb          	endbr32 
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800738:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80073b:	50                   	push   %eax
  80073c:	ff 75 10             	pushl  0x10(%ebp)
  80073f:	ff 75 0c             	pushl  0xc(%ebp)
  800742:	ff 75 08             	pushl  0x8(%ebp)
  800745:	e8 92 ff ff ff       	call   8006dc <vsnprintf>
	va_end(ap);

	return rc;
}
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    

0080074c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80074c:	f3 0f 1e fb          	endbr32 
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800756:	b8 00 00 00 00       	mov    $0x0,%eax
  80075b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80075f:	74 05                	je     800766 <strlen+0x1a>
		n++;
  800761:	83 c0 01             	add    $0x1,%eax
  800764:	eb f5                	jmp    80075b <strlen+0xf>
	return n;
}
  800766:	5d                   	pop    %ebp
  800767:	c3                   	ret    

00800768 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800768:	f3 0f 1e fb          	endbr32 
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800772:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800775:	b8 00 00 00 00       	mov    $0x0,%eax
  80077a:	39 d0                	cmp    %edx,%eax
  80077c:	74 0d                	je     80078b <strnlen+0x23>
  80077e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800782:	74 05                	je     800789 <strnlen+0x21>
		n++;
  800784:	83 c0 01             	add    $0x1,%eax
  800787:	eb f1                	jmp    80077a <strnlen+0x12>
  800789:	89 c2                	mov    %eax,%edx
	return n;
}
  80078b:	89 d0                	mov    %edx,%eax
  80078d:	5d                   	pop    %ebp
  80078e:	c3                   	ret    

0080078f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80078f:	f3 0f 1e fb          	endbr32 
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	53                   	push   %ebx
  800797:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80079a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80079d:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a2:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007a6:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007a9:	83 c0 01             	add    $0x1,%eax
  8007ac:	84 d2                	test   %dl,%dl
  8007ae:	75 f2                	jne    8007a2 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007b0:	89 c8                	mov    %ecx,%eax
  8007b2:	5b                   	pop    %ebx
  8007b3:	5d                   	pop    %ebp
  8007b4:	c3                   	ret    

008007b5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b5:	f3 0f 1e fb          	endbr32 
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	53                   	push   %ebx
  8007bd:	83 ec 10             	sub    $0x10,%esp
  8007c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c3:	53                   	push   %ebx
  8007c4:	e8 83 ff ff ff       	call   80074c <strlen>
  8007c9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	01 d8                	add    %ebx,%eax
  8007d1:	50                   	push   %eax
  8007d2:	e8 b8 ff ff ff       	call   80078f <strcpy>
	return dst;
}
  8007d7:	89 d8                	mov    %ebx,%eax
  8007d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007dc:	c9                   	leave  
  8007dd:	c3                   	ret    

008007de <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007de:	f3 0f 1e fb          	endbr32 
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	56                   	push   %esi
  8007e6:	53                   	push   %ebx
  8007e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ed:	89 f3                	mov    %esi,%ebx
  8007ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f2:	89 f0                	mov    %esi,%eax
  8007f4:	39 d8                	cmp    %ebx,%eax
  8007f6:	74 11                	je     800809 <strncpy+0x2b>
		*dst++ = *src;
  8007f8:	83 c0 01             	add    $0x1,%eax
  8007fb:	0f b6 0a             	movzbl (%edx),%ecx
  8007fe:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800801:	80 f9 01             	cmp    $0x1,%cl
  800804:	83 da ff             	sbb    $0xffffffff,%edx
  800807:	eb eb                	jmp    8007f4 <strncpy+0x16>
	}
	return ret;
}
  800809:	89 f0                	mov    %esi,%eax
  80080b:	5b                   	pop    %ebx
  80080c:	5e                   	pop    %esi
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80080f:	f3 0f 1e fb          	endbr32 
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	56                   	push   %esi
  800817:	53                   	push   %ebx
  800818:	8b 75 08             	mov    0x8(%ebp),%esi
  80081b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80081e:	8b 55 10             	mov    0x10(%ebp),%edx
  800821:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800823:	85 d2                	test   %edx,%edx
  800825:	74 21                	je     800848 <strlcpy+0x39>
  800827:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80082b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80082d:	39 c2                	cmp    %eax,%edx
  80082f:	74 14                	je     800845 <strlcpy+0x36>
  800831:	0f b6 19             	movzbl (%ecx),%ebx
  800834:	84 db                	test   %bl,%bl
  800836:	74 0b                	je     800843 <strlcpy+0x34>
			*dst++ = *src++;
  800838:	83 c1 01             	add    $0x1,%ecx
  80083b:	83 c2 01             	add    $0x1,%edx
  80083e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800841:	eb ea                	jmp    80082d <strlcpy+0x1e>
  800843:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800845:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800848:	29 f0                	sub    %esi,%eax
}
  80084a:	5b                   	pop    %ebx
  80084b:	5e                   	pop    %esi
  80084c:	5d                   	pop    %ebp
  80084d:	c3                   	ret    

0080084e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80084e:	f3 0f 1e fb          	endbr32 
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800858:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80085b:	0f b6 01             	movzbl (%ecx),%eax
  80085e:	84 c0                	test   %al,%al
  800860:	74 0c                	je     80086e <strcmp+0x20>
  800862:	3a 02                	cmp    (%edx),%al
  800864:	75 08                	jne    80086e <strcmp+0x20>
		p++, q++;
  800866:	83 c1 01             	add    $0x1,%ecx
  800869:	83 c2 01             	add    $0x1,%edx
  80086c:	eb ed                	jmp    80085b <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80086e:	0f b6 c0             	movzbl %al,%eax
  800871:	0f b6 12             	movzbl (%edx),%edx
  800874:	29 d0                	sub    %edx,%eax
}
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800878:	f3 0f 1e fb          	endbr32 
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	53                   	push   %ebx
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	8b 55 0c             	mov    0xc(%ebp),%edx
  800886:	89 c3                	mov    %eax,%ebx
  800888:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80088b:	eb 06                	jmp    800893 <strncmp+0x1b>
		n--, p++, q++;
  80088d:	83 c0 01             	add    $0x1,%eax
  800890:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800893:	39 d8                	cmp    %ebx,%eax
  800895:	74 16                	je     8008ad <strncmp+0x35>
  800897:	0f b6 08             	movzbl (%eax),%ecx
  80089a:	84 c9                	test   %cl,%cl
  80089c:	74 04                	je     8008a2 <strncmp+0x2a>
  80089e:	3a 0a                	cmp    (%edx),%cl
  8008a0:	74 eb                	je     80088d <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a2:	0f b6 00             	movzbl (%eax),%eax
  8008a5:	0f b6 12             	movzbl (%edx),%edx
  8008a8:	29 d0                	sub    %edx,%eax
}
  8008aa:	5b                   	pop    %ebx
  8008ab:	5d                   	pop    %ebp
  8008ac:	c3                   	ret    
		return 0;
  8008ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b2:	eb f6                	jmp    8008aa <strncmp+0x32>

008008b4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008b4:	f3 0f 1e fb          	endbr32 
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c2:	0f b6 10             	movzbl (%eax),%edx
  8008c5:	84 d2                	test   %dl,%dl
  8008c7:	74 09                	je     8008d2 <strchr+0x1e>
		if (*s == c)
  8008c9:	38 ca                	cmp    %cl,%dl
  8008cb:	74 0a                	je     8008d7 <strchr+0x23>
	for (; *s; s++)
  8008cd:	83 c0 01             	add    $0x1,%eax
  8008d0:	eb f0                	jmp    8008c2 <strchr+0xe>
			return (char *) s;
	return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    

008008d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008d9:	f3 0f 1e fb          	endbr32 
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008ea:	38 ca                	cmp    %cl,%dl
  8008ec:	74 09                	je     8008f7 <strfind+0x1e>
  8008ee:	84 d2                	test   %dl,%dl
  8008f0:	74 05                	je     8008f7 <strfind+0x1e>
	for (; *s; s++)
  8008f2:	83 c0 01             	add    $0x1,%eax
  8008f5:	eb f0                	jmp    8008e7 <strfind+0xe>
			break;
	return (char *) s;
}
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008f9:	f3 0f 1e fb          	endbr32 
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	57                   	push   %edi
  800901:	56                   	push   %esi
  800902:	53                   	push   %ebx
  800903:	8b 7d 08             	mov    0x8(%ebp),%edi
  800906:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800909:	85 c9                	test   %ecx,%ecx
  80090b:	74 31                	je     80093e <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80090d:	89 f8                	mov    %edi,%eax
  80090f:	09 c8                	or     %ecx,%eax
  800911:	a8 03                	test   $0x3,%al
  800913:	75 23                	jne    800938 <memset+0x3f>
		c &= 0xFF;
  800915:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800919:	89 d3                	mov    %edx,%ebx
  80091b:	c1 e3 08             	shl    $0x8,%ebx
  80091e:	89 d0                	mov    %edx,%eax
  800920:	c1 e0 18             	shl    $0x18,%eax
  800923:	89 d6                	mov    %edx,%esi
  800925:	c1 e6 10             	shl    $0x10,%esi
  800928:	09 f0                	or     %esi,%eax
  80092a:	09 c2                	or     %eax,%edx
  80092c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80092e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800931:	89 d0                	mov    %edx,%eax
  800933:	fc                   	cld    
  800934:	f3 ab                	rep stos %eax,%es:(%edi)
  800936:	eb 06                	jmp    80093e <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	fc                   	cld    
  80093c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80093e:	89 f8                	mov    %edi,%eax
  800940:	5b                   	pop    %ebx
  800941:	5e                   	pop    %esi
  800942:	5f                   	pop    %edi
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    

00800945 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800945:	f3 0f 1e fb          	endbr32 
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	57                   	push   %edi
  80094d:	56                   	push   %esi
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 75 0c             	mov    0xc(%ebp),%esi
  800954:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800957:	39 c6                	cmp    %eax,%esi
  800959:	73 32                	jae    80098d <memmove+0x48>
  80095b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	76 2b                	jbe    80098d <memmove+0x48>
		s += n;
		d += n;
  800962:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800965:	89 fe                	mov    %edi,%esi
  800967:	09 ce                	or     %ecx,%esi
  800969:	09 d6                	or     %edx,%esi
  80096b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800971:	75 0e                	jne    800981 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800973:	83 ef 04             	sub    $0x4,%edi
  800976:	8d 72 fc             	lea    -0x4(%edx),%esi
  800979:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80097c:	fd                   	std    
  80097d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80097f:	eb 09                	jmp    80098a <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800981:	83 ef 01             	sub    $0x1,%edi
  800984:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800987:	fd                   	std    
  800988:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80098a:	fc                   	cld    
  80098b:	eb 1a                	jmp    8009a7 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098d:	89 c2                	mov    %eax,%edx
  80098f:	09 ca                	or     %ecx,%edx
  800991:	09 f2                	or     %esi,%edx
  800993:	f6 c2 03             	test   $0x3,%dl
  800996:	75 0a                	jne    8009a2 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800998:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80099b:	89 c7                	mov    %eax,%edi
  80099d:	fc                   	cld    
  80099e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a0:	eb 05                	jmp    8009a7 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009a2:	89 c7                	mov    %eax,%edi
  8009a4:	fc                   	cld    
  8009a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009a7:	5e                   	pop    %esi
  8009a8:	5f                   	pop    %edi
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009ab:	f3 0f 1e fb          	endbr32 
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009b5:	ff 75 10             	pushl  0x10(%ebp)
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	ff 75 08             	pushl  0x8(%ebp)
  8009be:	e8 82 ff ff ff       	call   800945 <memmove>
}
  8009c3:	c9                   	leave  
  8009c4:	c3                   	ret    

008009c5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009c5:	f3 0f 1e fb          	endbr32 
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	56                   	push   %esi
  8009cd:	53                   	push   %ebx
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d4:	89 c6                	mov    %eax,%esi
  8009d6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009d9:	39 f0                	cmp    %esi,%eax
  8009db:	74 1c                	je     8009f9 <memcmp+0x34>
		if (*s1 != *s2)
  8009dd:	0f b6 08             	movzbl (%eax),%ecx
  8009e0:	0f b6 1a             	movzbl (%edx),%ebx
  8009e3:	38 d9                	cmp    %bl,%cl
  8009e5:	75 08                	jne    8009ef <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009e7:	83 c0 01             	add    $0x1,%eax
  8009ea:	83 c2 01             	add    $0x1,%edx
  8009ed:	eb ea                	jmp    8009d9 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009ef:	0f b6 c1             	movzbl %cl,%eax
  8009f2:	0f b6 db             	movzbl %bl,%ebx
  8009f5:	29 d8                	sub    %ebx,%eax
  8009f7:	eb 05                	jmp    8009fe <memcmp+0x39>
	}

	return 0;
  8009f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009fe:	5b                   	pop    %ebx
  8009ff:	5e                   	pop    %esi
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a02:	f3 0f 1e fb          	endbr32 
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a0f:	89 c2                	mov    %eax,%edx
  800a11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a14:	39 d0                	cmp    %edx,%eax
  800a16:	73 09                	jae    800a21 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a18:	38 08                	cmp    %cl,(%eax)
  800a1a:	74 05                	je     800a21 <memfind+0x1f>
	for (; s < ends; s++)
  800a1c:	83 c0 01             	add    $0x1,%eax
  800a1f:	eb f3                	jmp    800a14 <memfind+0x12>
			break;
	return (void *) s;
}
  800a21:	5d                   	pop    %ebp
  800a22:	c3                   	ret    

00800a23 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a23:	f3 0f 1e fb          	endbr32 
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	57                   	push   %edi
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a30:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a33:	eb 03                	jmp    800a38 <strtol+0x15>
		s++;
  800a35:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a38:	0f b6 01             	movzbl (%ecx),%eax
  800a3b:	3c 20                	cmp    $0x20,%al
  800a3d:	74 f6                	je     800a35 <strtol+0x12>
  800a3f:	3c 09                	cmp    $0x9,%al
  800a41:	74 f2                	je     800a35 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a43:	3c 2b                	cmp    $0x2b,%al
  800a45:	74 2a                	je     800a71 <strtol+0x4e>
	int neg = 0;
  800a47:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a4c:	3c 2d                	cmp    $0x2d,%al
  800a4e:	74 2b                	je     800a7b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a50:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a56:	75 0f                	jne    800a67 <strtol+0x44>
  800a58:	80 39 30             	cmpb   $0x30,(%ecx)
  800a5b:	74 28                	je     800a85 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a5d:	85 db                	test   %ebx,%ebx
  800a5f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a64:	0f 44 d8             	cmove  %eax,%ebx
  800a67:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a6f:	eb 46                	jmp    800ab7 <strtol+0x94>
		s++;
  800a71:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a74:	bf 00 00 00 00       	mov    $0x0,%edi
  800a79:	eb d5                	jmp    800a50 <strtol+0x2d>
		s++, neg = 1;
  800a7b:	83 c1 01             	add    $0x1,%ecx
  800a7e:	bf 01 00 00 00       	mov    $0x1,%edi
  800a83:	eb cb                	jmp    800a50 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a85:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a89:	74 0e                	je     800a99 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a8b:	85 db                	test   %ebx,%ebx
  800a8d:	75 d8                	jne    800a67 <strtol+0x44>
		s++, base = 8;
  800a8f:	83 c1 01             	add    $0x1,%ecx
  800a92:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a97:	eb ce                	jmp    800a67 <strtol+0x44>
		s += 2, base = 16;
  800a99:	83 c1 02             	add    $0x2,%ecx
  800a9c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa1:	eb c4                	jmp    800a67 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800aa3:	0f be d2             	movsbl %dl,%edx
  800aa6:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aa9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aac:	7d 3a                	jge    800ae8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800aae:	83 c1 01             	add    $0x1,%ecx
  800ab1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ab5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ab7:	0f b6 11             	movzbl (%ecx),%edx
  800aba:	8d 72 d0             	lea    -0x30(%edx),%esi
  800abd:	89 f3                	mov    %esi,%ebx
  800abf:	80 fb 09             	cmp    $0x9,%bl
  800ac2:	76 df                	jbe    800aa3 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ac4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ac7:	89 f3                	mov    %esi,%ebx
  800ac9:	80 fb 19             	cmp    $0x19,%bl
  800acc:	77 08                	ja     800ad6 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ace:	0f be d2             	movsbl %dl,%edx
  800ad1:	83 ea 57             	sub    $0x57,%edx
  800ad4:	eb d3                	jmp    800aa9 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ad6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ad9:	89 f3                	mov    %esi,%ebx
  800adb:	80 fb 19             	cmp    $0x19,%bl
  800ade:	77 08                	ja     800ae8 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ae0:	0f be d2             	movsbl %dl,%edx
  800ae3:	83 ea 37             	sub    $0x37,%edx
  800ae6:	eb c1                	jmp    800aa9 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ae8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aec:	74 05                	je     800af3 <strtol+0xd0>
		*endptr = (char *) s;
  800aee:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800af3:	89 c2                	mov    %eax,%edx
  800af5:	f7 da                	neg    %edx
  800af7:	85 ff                	test   %edi,%edi
  800af9:	0f 45 c2             	cmovne %edx,%eax
}
  800afc:	5b                   	pop    %ebx
  800afd:	5e                   	pop    %esi
  800afe:	5f                   	pop    %edi
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b01:	f3 0f 1e fb          	endbr32 
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	57                   	push   %edi
  800b09:	56                   	push   %esi
  800b0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b10:	8b 55 08             	mov    0x8(%ebp),%edx
  800b13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b16:	89 c3                	mov    %eax,%ebx
  800b18:	89 c7                	mov    %eax,%edi
  800b1a:	89 c6                	mov    %eax,%esi
  800b1c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b1e:	5b                   	pop    %ebx
  800b1f:	5e                   	pop    %esi
  800b20:	5f                   	pop    %edi
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b23:	f3 0f 1e fb          	endbr32 
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	57                   	push   %edi
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b32:	b8 01 00 00 00       	mov    $0x1,%eax
  800b37:	89 d1                	mov    %edx,%ecx
  800b39:	89 d3                	mov    %edx,%ebx
  800b3b:	89 d7                	mov    %edx,%edi
  800b3d:	89 d6                	mov    %edx,%esi
  800b3f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b41:	5b                   	pop    %ebx
  800b42:	5e                   	pop    %esi
  800b43:	5f                   	pop    %edi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b46:	f3 0f 1e fb          	endbr32 
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	57                   	push   %edi
  800b4e:	56                   	push   %esi
  800b4f:	53                   	push   %ebx
  800b50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b53:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b58:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b60:	89 cb                	mov    %ecx,%ebx
  800b62:	89 cf                	mov    %ecx,%edi
  800b64:	89 ce                	mov    %ecx,%esi
  800b66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b68:	85 c0                	test   %eax,%eax
  800b6a:	7f 08                	jg     800b74 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5f                   	pop    %edi
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b74:	83 ec 0c             	sub    $0xc,%esp
  800b77:	50                   	push   %eax
  800b78:	6a 03                	push   $0x3
  800b7a:	68 44 13 80 00       	push   $0x801344
  800b7f:	6a 23                	push   $0x23
  800b81:	68 61 13 80 00       	push   $0x801361
  800b86:	e8 aa 02 00 00       	call   800e35 <_panic>

00800b8b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b8b:	f3 0f 1e fb          	endbr32 
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b95:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9a:	b8 02 00 00 00       	mov    $0x2,%eax
  800b9f:	89 d1                	mov    %edx,%ecx
  800ba1:	89 d3                	mov    %edx,%ebx
  800ba3:	89 d7                	mov    %edx,%edi
  800ba5:	89 d6                	mov    %edx,%esi
  800ba7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ba9:	5b                   	pop    %ebx
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <sys_yield>:

void
sys_yield(void)
{
  800bae:	f3 0f 1e fb          	endbr32 
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	57                   	push   %edi
  800bb6:	56                   	push   %esi
  800bb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bc2:	89 d1                	mov    %edx,%ecx
  800bc4:	89 d3                	mov    %edx,%ebx
  800bc6:	89 d7                	mov    %edx,%edi
  800bc8:	89 d6                	mov    %edx,%esi
  800bca:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bcc:	5b                   	pop    %ebx
  800bcd:	5e                   	pop    %esi
  800bce:	5f                   	pop    %edi
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bd1:	f3 0f 1e fb          	endbr32 
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	57                   	push   %edi
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
  800bdb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bde:	be 00 00 00 00       	mov    $0x0,%esi
  800be3:	8b 55 08             	mov    0x8(%ebp),%edx
  800be6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be9:	b8 04 00 00 00       	mov    $0x4,%eax
  800bee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf1:	89 f7                	mov    %esi,%edi
  800bf3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bf5:	85 c0                	test   %eax,%eax
  800bf7:	7f 08                	jg     800c01 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfc:	5b                   	pop    %ebx
  800bfd:	5e                   	pop    %esi
  800bfe:	5f                   	pop    %edi
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c01:	83 ec 0c             	sub    $0xc,%esp
  800c04:	50                   	push   %eax
  800c05:	6a 04                	push   $0x4
  800c07:	68 44 13 80 00       	push   $0x801344
  800c0c:	6a 23                	push   $0x23
  800c0e:	68 61 13 80 00       	push   $0x801361
  800c13:	e8 1d 02 00 00       	call   800e35 <_panic>

00800c18 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c18:	f3 0f 1e fb          	endbr32 
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	57                   	push   %edi
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
  800c22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c25:	8b 55 08             	mov    0x8(%ebp),%edx
  800c28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2b:	b8 05 00 00 00       	mov    $0x5,%eax
  800c30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c33:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c36:	8b 75 18             	mov    0x18(%ebp),%esi
  800c39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3b:	85 c0                	test   %eax,%eax
  800c3d:	7f 08                	jg     800c47 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c47:	83 ec 0c             	sub    $0xc,%esp
  800c4a:	50                   	push   %eax
  800c4b:	6a 05                	push   $0x5
  800c4d:	68 44 13 80 00       	push   $0x801344
  800c52:	6a 23                	push   $0x23
  800c54:	68 61 13 80 00       	push   $0x801361
  800c59:	e8 d7 01 00 00       	call   800e35 <_panic>

00800c5e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c5e:	f3 0f 1e fb          	endbr32 
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c70:	8b 55 08             	mov    0x8(%ebp),%edx
  800c73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c76:	b8 06 00 00 00       	mov    $0x6,%eax
  800c7b:	89 df                	mov    %ebx,%edi
  800c7d:	89 de                	mov    %ebx,%esi
  800c7f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c81:	85 c0                	test   %eax,%eax
  800c83:	7f 08                	jg     800c8d <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c88:	5b                   	pop    %ebx
  800c89:	5e                   	pop    %esi
  800c8a:	5f                   	pop    %edi
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8d:	83 ec 0c             	sub    $0xc,%esp
  800c90:	50                   	push   %eax
  800c91:	6a 06                	push   $0x6
  800c93:	68 44 13 80 00       	push   $0x801344
  800c98:	6a 23                	push   $0x23
  800c9a:	68 61 13 80 00       	push   $0x801361
  800c9f:	e8 91 01 00 00       	call   800e35 <_panic>

00800ca4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ca4:	f3 0f 1e fb          	endbr32 
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	57                   	push   %edi
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
  800cae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbc:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc1:	89 df                	mov    %ebx,%edi
  800cc3:	89 de                	mov    %ebx,%esi
  800cc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc7:	85 c0                	test   %eax,%eax
  800cc9:	7f 08                	jg     800cd3 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd3:	83 ec 0c             	sub    $0xc,%esp
  800cd6:	50                   	push   %eax
  800cd7:	6a 08                	push   $0x8
  800cd9:	68 44 13 80 00       	push   $0x801344
  800cde:	6a 23                	push   $0x23
  800ce0:	68 61 13 80 00       	push   $0x801361
  800ce5:	e8 4b 01 00 00       	call   800e35 <_panic>

00800cea <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cea:	f3 0f 1e fb          	endbr32 
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	57                   	push   %edi
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
  800cf4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d02:	b8 09 00 00 00       	mov    $0x9,%eax
  800d07:	89 df                	mov    %ebx,%edi
  800d09:	89 de                	mov    %ebx,%esi
  800d0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0d:	85 c0                	test   %eax,%eax
  800d0f:	7f 08                	jg     800d19 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d19:	83 ec 0c             	sub    $0xc,%esp
  800d1c:	50                   	push   %eax
  800d1d:	6a 09                	push   $0x9
  800d1f:	68 44 13 80 00       	push   $0x801344
  800d24:	6a 23                	push   $0x23
  800d26:	68 61 13 80 00       	push   $0x801361
  800d2b:	e8 05 01 00 00       	call   800e35 <_panic>

00800d30 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d30:	f3 0f 1e fb          	endbr32 
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d40:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d45:	be 00 00 00 00       	mov    $0x0,%esi
  800d4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d50:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d57:	f3 0f 1e fb          	endbr32 
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	57                   	push   %edi
  800d5f:	56                   	push   %esi
  800d60:	53                   	push   %ebx
  800d61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d64:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d71:	89 cb                	mov    %ecx,%ebx
  800d73:	89 cf                	mov    %ecx,%edi
  800d75:	89 ce                	mov    %ecx,%esi
  800d77:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d79:	85 c0                	test   %eax,%eax
  800d7b:	7f 08                	jg     800d85 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d85:	83 ec 0c             	sub    $0xc,%esp
  800d88:	50                   	push   %eax
  800d89:	6a 0c                	push   $0xc
  800d8b:	68 44 13 80 00       	push   $0x801344
  800d90:	6a 23                	push   $0x23
  800d92:	68 61 13 80 00       	push   $0x801361
  800d97:	e8 99 00 00 00       	call   800e35 <_panic>

00800d9c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800d9c:	f3 0f 1e fb          	endbr32 
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800da6:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800dad:	74 0a                	je     800db9 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  800db9:	83 ec 04             	sub    $0x4,%esp
  800dbc:	6a 07                	push   $0x7
  800dbe:	68 00 f0 bf ee       	push   $0xeebff000
  800dc3:	6a 00                	push   $0x0
  800dc5:	e8 07 fe ff ff       	call   800bd1 <sys_page_alloc>
  800dca:	83 c4 10             	add    $0x10,%esp
  800dcd:	85 c0                	test   %eax,%eax
  800dcf:	78 2a                	js     800dfb <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  800dd1:	83 ec 08             	sub    $0x8,%esp
  800dd4:	68 0f 0e 80 00       	push   $0x800e0f
  800dd9:	6a 00                	push   $0x0
  800ddb:	e8 0a ff ff ff       	call   800cea <sys_env_set_pgfault_upcall>
  800de0:	83 c4 10             	add    $0x10,%esp
  800de3:	85 c0                	test   %eax,%eax
  800de5:	79 c8                	jns    800daf <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  800de7:	83 ec 04             	sub    $0x4,%esp
  800dea:	68 9c 13 80 00       	push   $0x80139c
  800def:	6a 25                	push   $0x25
  800df1:	68 d4 13 80 00       	push   $0x8013d4
  800df6:	e8 3a 00 00 00       	call   800e35 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  800dfb:	83 ec 04             	sub    $0x4,%esp
  800dfe:	68 70 13 80 00       	push   $0x801370
  800e03:	6a 22                	push   $0x22
  800e05:	68 d4 13 80 00       	push   $0x8013d4
  800e0a:	e8 26 00 00 00       	call   800e35 <_panic>

00800e0f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e0f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e10:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800e15:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e17:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  800e1a:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800e1e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800e22:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800e25:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800e27:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  800e2b:	83 c4 08             	add    $0x8,%esp
	popal
  800e2e:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  800e2f:	83 c4 04             	add    $0x4,%esp
	popfl
  800e32:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  800e33:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  800e34:	c3                   	ret    

00800e35 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800e35:	f3 0f 1e fb          	endbr32 
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	56                   	push   %esi
  800e3d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e3e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800e41:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800e47:	e8 3f fd ff ff       	call   800b8b <sys_getenvid>
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	ff 75 0c             	pushl  0xc(%ebp)
  800e52:	ff 75 08             	pushl  0x8(%ebp)
  800e55:	56                   	push   %esi
  800e56:	50                   	push   %eax
  800e57:	68 e4 13 80 00       	push   $0x8013e4
  800e5c:	e8 24 f3 ff ff       	call   800185 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e61:	83 c4 18             	add    $0x18,%esp
  800e64:	53                   	push   %ebx
  800e65:	ff 75 10             	pushl  0x10(%ebp)
  800e68:	e8 c3 f2 ff ff       	call   800130 <vcprintf>
	cprintf("\n");
  800e6d:	c7 04 24 fa 10 80 00 	movl   $0x8010fa,(%esp)
  800e74:	e8 0c f3 ff ff       	call   800185 <cprintf>
  800e79:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e7c:	cc                   	int3   
  800e7d:	eb fd                	jmp    800e7c <_panic+0x47>
  800e7f:	90                   	nop

00800e80 <__udivdi3>:
  800e80:	f3 0f 1e fb          	endbr32 
  800e84:	55                   	push   %ebp
  800e85:	57                   	push   %edi
  800e86:	56                   	push   %esi
  800e87:	53                   	push   %ebx
  800e88:	83 ec 1c             	sub    $0x1c,%esp
  800e8b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e8f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e93:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e97:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e9b:	85 d2                	test   %edx,%edx
  800e9d:	75 19                	jne    800eb8 <__udivdi3+0x38>
  800e9f:	39 f3                	cmp    %esi,%ebx
  800ea1:	76 4d                	jbe    800ef0 <__udivdi3+0x70>
  800ea3:	31 ff                	xor    %edi,%edi
  800ea5:	89 e8                	mov    %ebp,%eax
  800ea7:	89 f2                	mov    %esi,%edx
  800ea9:	f7 f3                	div    %ebx
  800eab:	89 fa                	mov    %edi,%edx
  800ead:	83 c4 1c             	add    $0x1c,%esp
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    
  800eb5:	8d 76 00             	lea    0x0(%esi),%esi
  800eb8:	39 f2                	cmp    %esi,%edx
  800eba:	76 14                	jbe    800ed0 <__udivdi3+0x50>
  800ebc:	31 ff                	xor    %edi,%edi
  800ebe:	31 c0                	xor    %eax,%eax
  800ec0:	89 fa                	mov    %edi,%edx
  800ec2:	83 c4 1c             	add    $0x1c,%esp
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    
  800eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ed0:	0f bd fa             	bsr    %edx,%edi
  800ed3:	83 f7 1f             	xor    $0x1f,%edi
  800ed6:	75 48                	jne    800f20 <__udivdi3+0xa0>
  800ed8:	39 f2                	cmp    %esi,%edx
  800eda:	72 06                	jb     800ee2 <__udivdi3+0x62>
  800edc:	31 c0                	xor    %eax,%eax
  800ede:	39 eb                	cmp    %ebp,%ebx
  800ee0:	77 de                	ja     800ec0 <__udivdi3+0x40>
  800ee2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ee7:	eb d7                	jmp    800ec0 <__udivdi3+0x40>
  800ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ef0:	89 d9                	mov    %ebx,%ecx
  800ef2:	85 db                	test   %ebx,%ebx
  800ef4:	75 0b                	jne    800f01 <__udivdi3+0x81>
  800ef6:	b8 01 00 00 00       	mov    $0x1,%eax
  800efb:	31 d2                	xor    %edx,%edx
  800efd:	f7 f3                	div    %ebx
  800eff:	89 c1                	mov    %eax,%ecx
  800f01:	31 d2                	xor    %edx,%edx
  800f03:	89 f0                	mov    %esi,%eax
  800f05:	f7 f1                	div    %ecx
  800f07:	89 c6                	mov    %eax,%esi
  800f09:	89 e8                	mov    %ebp,%eax
  800f0b:	89 f7                	mov    %esi,%edi
  800f0d:	f7 f1                	div    %ecx
  800f0f:	89 fa                	mov    %edi,%edx
  800f11:	83 c4 1c             	add    $0x1c,%esp
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    
  800f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f20:	89 f9                	mov    %edi,%ecx
  800f22:	b8 20 00 00 00       	mov    $0x20,%eax
  800f27:	29 f8                	sub    %edi,%eax
  800f29:	d3 e2                	shl    %cl,%edx
  800f2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f2f:	89 c1                	mov    %eax,%ecx
  800f31:	89 da                	mov    %ebx,%edx
  800f33:	d3 ea                	shr    %cl,%edx
  800f35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f39:	09 d1                	or     %edx,%ecx
  800f3b:	89 f2                	mov    %esi,%edx
  800f3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f41:	89 f9                	mov    %edi,%ecx
  800f43:	d3 e3                	shl    %cl,%ebx
  800f45:	89 c1                	mov    %eax,%ecx
  800f47:	d3 ea                	shr    %cl,%edx
  800f49:	89 f9                	mov    %edi,%ecx
  800f4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f4f:	89 eb                	mov    %ebp,%ebx
  800f51:	d3 e6                	shl    %cl,%esi
  800f53:	89 c1                	mov    %eax,%ecx
  800f55:	d3 eb                	shr    %cl,%ebx
  800f57:	09 de                	or     %ebx,%esi
  800f59:	89 f0                	mov    %esi,%eax
  800f5b:	f7 74 24 08          	divl   0x8(%esp)
  800f5f:	89 d6                	mov    %edx,%esi
  800f61:	89 c3                	mov    %eax,%ebx
  800f63:	f7 64 24 0c          	mull   0xc(%esp)
  800f67:	39 d6                	cmp    %edx,%esi
  800f69:	72 15                	jb     800f80 <__udivdi3+0x100>
  800f6b:	89 f9                	mov    %edi,%ecx
  800f6d:	d3 e5                	shl    %cl,%ebp
  800f6f:	39 c5                	cmp    %eax,%ebp
  800f71:	73 04                	jae    800f77 <__udivdi3+0xf7>
  800f73:	39 d6                	cmp    %edx,%esi
  800f75:	74 09                	je     800f80 <__udivdi3+0x100>
  800f77:	89 d8                	mov    %ebx,%eax
  800f79:	31 ff                	xor    %edi,%edi
  800f7b:	e9 40 ff ff ff       	jmp    800ec0 <__udivdi3+0x40>
  800f80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f83:	31 ff                	xor    %edi,%edi
  800f85:	e9 36 ff ff ff       	jmp    800ec0 <__udivdi3+0x40>
  800f8a:	66 90                	xchg   %ax,%ax
  800f8c:	66 90                	xchg   %ax,%ax
  800f8e:	66 90                	xchg   %ax,%ax

00800f90 <__umoddi3>:
  800f90:	f3 0f 1e fb          	endbr32 
  800f94:	55                   	push   %ebp
  800f95:	57                   	push   %edi
  800f96:	56                   	push   %esi
  800f97:	53                   	push   %ebx
  800f98:	83 ec 1c             	sub    $0x1c,%esp
  800f9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800f9f:	8b 74 24 30          	mov    0x30(%esp),%esi
  800fa3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800fa7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800fab:	85 c0                	test   %eax,%eax
  800fad:	75 19                	jne    800fc8 <__umoddi3+0x38>
  800faf:	39 df                	cmp    %ebx,%edi
  800fb1:	76 5d                	jbe    801010 <__umoddi3+0x80>
  800fb3:	89 f0                	mov    %esi,%eax
  800fb5:	89 da                	mov    %ebx,%edx
  800fb7:	f7 f7                	div    %edi
  800fb9:	89 d0                	mov    %edx,%eax
  800fbb:	31 d2                	xor    %edx,%edx
  800fbd:	83 c4 1c             	add    $0x1c,%esp
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    
  800fc5:	8d 76 00             	lea    0x0(%esi),%esi
  800fc8:	89 f2                	mov    %esi,%edx
  800fca:	39 d8                	cmp    %ebx,%eax
  800fcc:	76 12                	jbe    800fe0 <__umoddi3+0x50>
  800fce:	89 f0                	mov    %esi,%eax
  800fd0:	89 da                	mov    %ebx,%edx
  800fd2:	83 c4 1c             	add    $0x1c,%esp
  800fd5:	5b                   	pop    %ebx
  800fd6:	5e                   	pop    %esi
  800fd7:	5f                   	pop    %edi
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    
  800fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fe0:	0f bd e8             	bsr    %eax,%ebp
  800fe3:	83 f5 1f             	xor    $0x1f,%ebp
  800fe6:	75 50                	jne    801038 <__umoddi3+0xa8>
  800fe8:	39 d8                	cmp    %ebx,%eax
  800fea:	0f 82 e0 00 00 00    	jb     8010d0 <__umoddi3+0x140>
  800ff0:	89 d9                	mov    %ebx,%ecx
  800ff2:	39 f7                	cmp    %esi,%edi
  800ff4:	0f 86 d6 00 00 00    	jbe    8010d0 <__umoddi3+0x140>
  800ffa:	89 d0                	mov    %edx,%eax
  800ffc:	89 ca                	mov    %ecx,%edx
  800ffe:	83 c4 1c             	add    $0x1c,%esp
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    
  801006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80100d:	8d 76 00             	lea    0x0(%esi),%esi
  801010:	89 fd                	mov    %edi,%ebp
  801012:	85 ff                	test   %edi,%edi
  801014:	75 0b                	jne    801021 <__umoddi3+0x91>
  801016:	b8 01 00 00 00       	mov    $0x1,%eax
  80101b:	31 d2                	xor    %edx,%edx
  80101d:	f7 f7                	div    %edi
  80101f:	89 c5                	mov    %eax,%ebp
  801021:	89 d8                	mov    %ebx,%eax
  801023:	31 d2                	xor    %edx,%edx
  801025:	f7 f5                	div    %ebp
  801027:	89 f0                	mov    %esi,%eax
  801029:	f7 f5                	div    %ebp
  80102b:	89 d0                	mov    %edx,%eax
  80102d:	31 d2                	xor    %edx,%edx
  80102f:	eb 8c                	jmp    800fbd <__umoddi3+0x2d>
  801031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801038:	89 e9                	mov    %ebp,%ecx
  80103a:	ba 20 00 00 00       	mov    $0x20,%edx
  80103f:	29 ea                	sub    %ebp,%edx
  801041:	d3 e0                	shl    %cl,%eax
  801043:	89 44 24 08          	mov    %eax,0x8(%esp)
  801047:	89 d1                	mov    %edx,%ecx
  801049:	89 f8                	mov    %edi,%eax
  80104b:	d3 e8                	shr    %cl,%eax
  80104d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801051:	89 54 24 04          	mov    %edx,0x4(%esp)
  801055:	8b 54 24 04          	mov    0x4(%esp),%edx
  801059:	09 c1                	or     %eax,%ecx
  80105b:	89 d8                	mov    %ebx,%eax
  80105d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801061:	89 e9                	mov    %ebp,%ecx
  801063:	d3 e7                	shl    %cl,%edi
  801065:	89 d1                	mov    %edx,%ecx
  801067:	d3 e8                	shr    %cl,%eax
  801069:	89 e9                	mov    %ebp,%ecx
  80106b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80106f:	d3 e3                	shl    %cl,%ebx
  801071:	89 c7                	mov    %eax,%edi
  801073:	89 d1                	mov    %edx,%ecx
  801075:	89 f0                	mov    %esi,%eax
  801077:	d3 e8                	shr    %cl,%eax
  801079:	89 e9                	mov    %ebp,%ecx
  80107b:	89 fa                	mov    %edi,%edx
  80107d:	d3 e6                	shl    %cl,%esi
  80107f:	09 d8                	or     %ebx,%eax
  801081:	f7 74 24 08          	divl   0x8(%esp)
  801085:	89 d1                	mov    %edx,%ecx
  801087:	89 f3                	mov    %esi,%ebx
  801089:	f7 64 24 0c          	mull   0xc(%esp)
  80108d:	89 c6                	mov    %eax,%esi
  80108f:	89 d7                	mov    %edx,%edi
  801091:	39 d1                	cmp    %edx,%ecx
  801093:	72 06                	jb     80109b <__umoddi3+0x10b>
  801095:	75 10                	jne    8010a7 <__umoddi3+0x117>
  801097:	39 c3                	cmp    %eax,%ebx
  801099:	73 0c                	jae    8010a7 <__umoddi3+0x117>
  80109b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80109f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8010a3:	89 d7                	mov    %edx,%edi
  8010a5:	89 c6                	mov    %eax,%esi
  8010a7:	89 ca                	mov    %ecx,%edx
  8010a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010ae:	29 f3                	sub    %esi,%ebx
  8010b0:	19 fa                	sbb    %edi,%edx
  8010b2:	89 d0                	mov    %edx,%eax
  8010b4:	d3 e0                	shl    %cl,%eax
  8010b6:	89 e9                	mov    %ebp,%ecx
  8010b8:	d3 eb                	shr    %cl,%ebx
  8010ba:	d3 ea                	shr    %cl,%edx
  8010bc:	09 d8                	or     %ebx,%eax
  8010be:	83 c4 1c             	add    $0x1c,%esp
  8010c1:	5b                   	pop    %ebx
  8010c2:	5e                   	pop    %esi
  8010c3:	5f                   	pop    %edi
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    
  8010c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010cd:	8d 76 00             	lea    0x0(%esi),%esi
  8010d0:	29 fe                	sub    %edi,%esi
  8010d2:	19 c3                	sbb    %eax,%ebx
  8010d4:	89 f2                	mov    %esi,%edx
  8010d6:	89 d9                	mov    %ebx,%ecx
  8010d8:	e9 1d ff ff ff       	jmp    800ffa <__umoddi3+0x6a>
