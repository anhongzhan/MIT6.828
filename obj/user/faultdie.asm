
obj/user/faultdie.debug:     file format elf32-i386


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
  800049:	68 e0 1f 80 00       	push   $0x801fe0
  80004e:	e8 3a 01 00 00       	call   80018d <cprintf>
	sys_env_destroy(sys_getenvid());
  800053:	e8 3b 0b 00 00       	call   800b93 <sys_getenvid>
  800058:	89 04 24             	mov    %eax,(%esp)
  80005b:	e8 ee 0a 00 00       	call   800b4e <sys_env_destroy>
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
  800074:	e8 71 0d 00 00       	call   800dea <set_pgfault_handler>
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
  800097:	e8 f7 0a 00 00       	call   800b93 <sys_getenvid>
  80009c:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a9:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ae:	85 db                	test   %ebx,%ebx
  8000b0:	7e 07                	jle    8000b9 <libmain+0x31>
		binaryname = argv[0];
  8000b2:	8b 06                	mov    (%esi),%eax
  8000b4:	a3 00 30 80 00       	mov    %eax,0x803000

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
  8000d9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000dc:	e8 91 0f 00 00       	call   801072 <close_all>
	sys_env_destroy(0);
  8000e1:	83 ec 0c             	sub    $0xc,%esp
  8000e4:	6a 00                	push   $0x0
  8000e6:	e8 63 0a 00 00       	call   800b4e <sys_env_destroy>
}
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	c9                   	leave  
  8000ef:	c3                   	ret    

008000f0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f0:	f3 0f 1e fb          	endbr32 
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000fe:	8b 13                	mov    (%ebx),%edx
  800100:	8d 42 01             	lea    0x1(%edx),%eax
  800103:	89 03                	mov    %eax,(%ebx)
  800105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800108:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800111:	74 09                	je     80011c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800113:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011a:	c9                   	leave  
  80011b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80011c:	83 ec 08             	sub    $0x8,%esp
  80011f:	68 ff 00 00 00       	push   $0xff
  800124:	8d 43 08             	lea    0x8(%ebx),%eax
  800127:	50                   	push   %eax
  800128:	e8 dc 09 00 00       	call   800b09 <sys_cputs>
		b->idx = 0;
  80012d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800133:	83 c4 10             	add    $0x10,%esp
  800136:	eb db                	jmp    800113 <putch+0x23>

00800138 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800138:	f3 0f 1e fb          	endbr32 
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800145:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014c:	00 00 00 
	b.cnt = 0;
  80014f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800156:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800159:	ff 75 0c             	pushl  0xc(%ebp)
  80015c:	ff 75 08             	pushl  0x8(%ebp)
  80015f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800165:	50                   	push   %eax
  800166:	68 f0 00 80 00       	push   $0x8000f0
  80016b:	e8 20 01 00 00       	call   800290 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800170:	83 c4 08             	add    $0x8,%esp
  800173:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800179:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80017f:	50                   	push   %eax
  800180:	e8 84 09 00 00       	call   800b09 <sys_cputs>

	return b.cnt;
}
  800185:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018b:	c9                   	leave  
  80018c:	c3                   	ret    

0080018d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018d:	f3 0f 1e fb          	endbr32 
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800197:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019a:	50                   	push   %eax
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 95 ff ff ff       	call   800138 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	57                   	push   %edi
  8001a9:	56                   	push   %esi
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 1c             	sub    $0x1c,%esp
  8001ae:	89 c7                	mov    %eax,%edi
  8001b0:	89 d6                	mov    %edx,%esi
  8001b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b8:	89 d1                	mov    %edx,%ecx
  8001ba:	89 c2                	mov    %eax,%edx
  8001bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001bf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001d2:	39 c2                	cmp    %eax,%edx
  8001d4:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001d7:	72 3e                	jb     800217 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 18             	pushl  0x18(%ebp)
  8001df:	83 eb 01             	sub    $0x1,%ebx
  8001e2:	53                   	push   %ebx
  8001e3:	50                   	push   %eax
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f3:	e8 78 1b 00 00       	call   801d70 <__udivdi3>
  8001f8:	83 c4 18             	add    $0x18,%esp
  8001fb:	52                   	push   %edx
  8001fc:	50                   	push   %eax
  8001fd:	89 f2                	mov    %esi,%edx
  8001ff:	89 f8                	mov    %edi,%eax
  800201:	e8 9f ff ff ff       	call   8001a5 <printnum>
  800206:	83 c4 20             	add    $0x20,%esp
  800209:	eb 13                	jmp    80021e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	56                   	push   %esi
  80020f:	ff 75 18             	pushl  0x18(%ebp)
  800212:	ff d7                	call   *%edi
  800214:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800217:	83 eb 01             	sub    $0x1,%ebx
  80021a:	85 db                	test   %ebx,%ebx
  80021c:	7f ed                	jg     80020b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021e:	83 ec 08             	sub    $0x8,%esp
  800221:	56                   	push   %esi
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e4             	pushl  -0x1c(%ebp)
  800228:	ff 75 e0             	pushl  -0x20(%ebp)
  80022b:	ff 75 dc             	pushl  -0x24(%ebp)
  80022e:	ff 75 d8             	pushl  -0x28(%ebp)
  800231:	e8 4a 1c 00 00       	call   801e80 <__umoddi3>
  800236:	83 c4 14             	add    $0x14,%esp
  800239:	0f be 80 06 20 80 00 	movsbl 0x802006(%eax),%eax
  800240:	50                   	push   %eax
  800241:	ff d7                	call   *%edi
}
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800249:	5b                   	pop    %ebx
  80024a:	5e                   	pop    %esi
  80024b:	5f                   	pop    %edi
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    

0080024e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80024e:	f3 0f 1e fb          	endbr32 
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800258:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025c:	8b 10                	mov    (%eax),%edx
  80025e:	3b 50 04             	cmp    0x4(%eax),%edx
  800261:	73 0a                	jae    80026d <sprintputch+0x1f>
		*b->buf++ = ch;
  800263:	8d 4a 01             	lea    0x1(%edx),%ecx
  800266:	89 08                	mov    %ecx,(%eax)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	88 02                	mov    %al,(%edx)
}
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <printfmt>:
{
  80026f:	f3 0f 1e fb          	endbr32 
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800279:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80027c:	50                   	push   %eax
  80027d:	ff 75 10             	pushl  0x10(%ebp)
  800280:	ff 75 0c             	pushl  0xc(%ebp)
  800283:	ff 75 08             	pushl  0x8(%ebp)
  800286:	e8 05 00 00 00       	call   800290 <vprintfmt>
}
  80028b:	83 c4 10             	add    $0x10,%esp
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <vprintfmt>:
{
  800290:	f3 0f 1e fb          	endbr32 
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 3c             	sub    $0x3c,%esp
  80029d:	8b 75 08             	mov    0x8(%ebp),%esi
  8002a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002a3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002a6:	e9 8e 03 00 00       	jmp    800639 <vprintfmt+0x3a9>
		padc = ' ';
  8002ab:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002af:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002c4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c9:	8d 47 01             	lea    0x1(%edi),%eax
  8002cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002cf:	0f b6 17             	movzbl (%edi),%edx
  8002d2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d5:	3c 55                	cmp    $0x55,%al
  8002d7:	0f 87 df 03 00 00    	ja     8006bc <vprintfmt+0x42c>
  8002dd:	0f b6 c0             	movzbl %al,%eax
  8002e0:	3e ff 24 85 40 21 80 	notrack jmp *0x802140(,%eax,4)
  8002e7:	00 
  8002e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002eb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002ef:	eb d8                	jmp    8002c9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002f4:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002f8:	eb cf                	jmp    8002c9 <vprintfmt+0x39>
  8002fa:	0f b6 d2             	movzbl %dl,%edx
  8002fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800300:	b8 00 00 00 00       	mov    $0x0,%eax
  800305:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800308:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80030b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80030f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800312:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800315:	83 f9 09             	cmp    $0x9,%ecx
  800318:	77 55                	ja     80036f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80031a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80031d:	eb e9                	jmp    800308 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80031f:	8b 45 14             	mov    0x14(%ebp),%eax
  800322:	8b 00                	mov    (%eax),%eax
  800324:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800327:	8b 45 14             	mov    0x14(%ebp),%eax
  80032a:	8d 40 04             	lea    0x4(%eax),%eax
  80032d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800330:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800333:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800337:	79 90                	jns    8002c9 <vprintfmt+0x39>
				width = precision, precision = -1;
  800339:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80033c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800346:	eb 81                	jmp    8002c9 <vprintfmt+0x39>
  800348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034b:	85 c0                	test   %eax,%eax
  80034d:	ba 00 00 00 00       	mov    $0x0,%edx
  800352:	0f 49 d0             	cmovns %eax,%edx
  800355:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80035b:	e9 69 ff ff ff       	jmp    8002c9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800363:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80036a:	e9 5a ff ff ff       	jmp    8002c9 <vprintfmt+0x39>
  80036f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800372:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800375:	eb bc                	jmp    800333 <vprintfmt+0xa3>
			lflag++;
  800377:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80037a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80037d:	e9 47 ff ff ff       	jmp    8002c9 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800382:	8b 45 14             	mov    0x14(%ebp),%eax
  800385:	8d 78 04             	lea    0x4(%eax),%edi
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	53                   	push   %ebx
  80038c:	ff 30                	pushl  (%eax)
  80038e:	ff d6                	call   *%esi
			break;
  800390:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800393:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800396:	e9 9b 02 00 00       	jmp    800636 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80039b:	8b 45 14             	mov    0x14(%ebp),%eax
  80039e:	8d 78 04             	lea    0x4(%eax),%edi
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	99                   	cltd   
  8003a4:	31 d0                	xor    %edx,%eax
  8003a6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a8:	83 f8 0f             	cmp    $0xf,%eax
  8003ab:	7f 23                	jg     8003d0 <vprintfmt+0x140>
  8003ad:	8b 14 85 a0 22 80 00 	mov    0x8022a0(,%eax,4),%edx
  8003b4:	85 d2                	test   %edx,%edx
  8003b6:	74 18                	je     8003d0 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003b8:	52                   	push   %edx
  8003b9:	68 45 24 80 00       	push   $0x802445
  8003be:	53                   	push   %ebx
  8003bf:	56                   	push   %esi
  8003c0:	e8 aa fe ff ff       	call   80026f <printfmt>
  8003c5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003cb:	e9 66 02 00 00       	jmp    800636 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003d0:	50                   	push   %eax
  8003d1:	68 1e 20 80 00       	push   $0x80201e
  8003d6:	53                   	push   %ebx
  8003d7:	56                   	push   %esi
  8003d8:	e8 92 fe ff ff       	call   80026f <printfmt>
  8003dd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e3:	e9 4e 02 00 00       	jmp    800636 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	83 c0 04             	add    $0x4,%eax
  8003ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003f6:	85 d2                	test   %edx,%edx
  8003f8:	b8 17 20 80 00       	mov    $0x802017,%eax
  8003fd:	0f 45 c2             	cmovne %edx,%eax
  800400:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800403:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800407:	7e 06                	jle    80040f <vprintfmt+0x17f>
  800409:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80040d:	75 0d                	jne    80041c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80040f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800412:	89 c7                	mov    %eax,%edi
  800414:	03 45 e0             	add    -0x20(%ebp),%eax
  800417:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041a:	eb 55                	jmp    800471 <vprintfmt+0x1e1>
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	ff 75 d8             	pushl  -0x28(%ebp)
  800422:	ff 75 cc             	pushl  -0x34(%ebp)
  800425:	e8 46 03 00 00       	call   800770 <strnlen>
  80042a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042d:	29 c2                	sub    %eax,%edx
  80042f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800432:	83 c4 10             	add    $0x10,%esp
  800435:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800437:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80043b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80043e:	85 ff                	test   %edi,%edi
  800440:	7e 11                	jle    800453 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	53                   	push   %ebx
  800446:	ff 75 e0             	pushl  -0x20(%ebp)
  800449:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80044b:	83 ef 01             	sub    $0x1,%edi
  80044e:	83 c4 10             	add    $0x10,%esp
  800451:	eb eb                	jmp    80043e <vprintfmt+0x1ae>
  800453:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800456:	85 d2                	test   %edx,%edx
  800458:	b8 00 00 00 00       	mov    $0x0,%eax
  80045d:	0f 49 c2             	cmovns %edx,%eax
  800460:	29 c2                	sub    %eax,%edx
  800462:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800465:	eb a8                	jmp    80040f <vprintfmt+0x17f>
					putch(ch, putdat);
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	53                   	push   %ebx
  80046b:	52                   	push   %edx
  80046c:	ff d6                	call   *%esi
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800474:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800476:	83 c7 01             	add    $0x1,%edi
  800479:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80047d:	0f be d0             	movsbl %al,%edx
  800480:	85 d2                	test   %edx,%edx
  800482:	74 4b                	je     8004cf <vprintfmt+0x23f>
  800484:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800488:	78 06                	js     800490 <vprintfmt+0x200>
  80048a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80048e:	78 1e                	js     8004ae <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800490:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800494:	74 d1                	je     800467 <vprintfmt+0x1d7>
  800496:	0f be c0             	movsbl %al,%eax
  800499:	83 e8 20             	sub    $0x20,%eax
  80049c:	83 f8 5e             	cmp    $0x5e,%eax
  80049f:	76 c6                	jbe    800467 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	53                   	push   %ebx
  8004a5:	6a 3f                	push   $0x3f
  8004a7:	ff d6                	call   *%esi
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	eb c3                	jmp    800471 <vprintfmt+0x1e1>
  8004ae:	89 cf                	mov    %ecx,%edi
  8004b0:	eb 0e                	jmp    8004c0 <vprintfmt+0x230>
				putch(' ', putdat);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	53                   	push   %ebx
  8004b6:	6a 20                	push   $0x20
  8004b8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	85 ff                	test   %edi,%edi
  8004c2:	7f ee                	jg     8004b2 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ca:	e9 67 01 00 00       	jmp    800636 <vprintfmt+0x3a6>
  8004cf:	89 cf                	mov    %ecx,%edi
  8004d1:	eb ed                	jmp    8004c0 <vprintfmt+0x230>
	if (lflag >= 2)
  8004d3:	83 f9 01             	cmp    $0x1,%ecx
  8004d6:	7f 1b                	jg     8004f3 <vprintfmt+0x263>
	else if (lflag)
  8004d8:	85 c9                	test   %ecx,%ecx
  8004da:	74 63                	je     80053f <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e4:	99                   	cltd   
  8004e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8d 40 04             	lea    0x4(%eax),%eax
  8004ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f1:	eb 17                	jmp    80050a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f6:	8b 50 04             	mov    0x4(%eax),%edx
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8d 40 08             	lea    0x8(%eax),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80050a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80050d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800510:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800515:	85 c9                	test   %ecx,%ecx
  800517:	0f 89 ff 00 00 00    	jns    80061c <vprintfmt+0x38c>
				putch('-', putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	53                   	push   %ebx
  800521:	6a 2d                	push   $0x2d
  800523:	ff d6                	call   *%esi
				num = -(long long) num;
  800525:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800528:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80052b:	f7 da                	neg    %edx
  80052d:	83 d1 00             	adc    $0x0,%ecx
  800530:	f7 d9                	neg    %ecx
  800532:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800535:	b8 0a 00 00 00       	mov    $0xa,%eax
  80053a:	e9 dd 00 00 00       	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80053f:	8b 45 14             	mov    0x14(%ebp),%eax
  800542:	8b 00                	mov    (%eax),%eax
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800547:	99                   	cltd   
  800548:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8d 40 04             	lea    0x4(%eax),%eax
  800551:	89 45 14             	mov    %eax,0x14(%ebp)
  800554:	eb b4                	jmp    80050a <vprintfmt+0x27a>
	if (lflag >= 2)
  800556:	83 f9 01             	cmp    $0x1,%ecx
  800559:	7f 1e                	jg     800579 <vprintfmt+0x2e9>
	else if (lflag)
  80055b:	85 c9                	test   %ecx,%ecx
  80055d:	74 32                	je     800591 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	b9 00 00 00 00       	mov    $0x0,%ecx
  800569:	8d 40 04             	lea    0x4(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800574:	e9 a3 00 00 00       	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8b 10                	mov    (%eax),%edx
  80057e:	8b 48 04             	mov    0x4(%eax),%ecx
  800581:	8d 40 08             	lea    0x8(%eax),%eax
  800584:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800587:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80058c:	e9 8b 00 00 00       	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 10                	mov    (%eax),%edx
  800596:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059b:	8d 40 04             	lea    0x4(%eax),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005a6:	eb 74                	jmp    80061c <vprintfmt+0x38c>
	if (lflag >= 2)
  8005a8:	83 f9 01             	cmp    $0x1,%ecx
  8005ab:	7f 1b                	jg     8005c8 <vprintfmt+0x338>
	else if (lflag)
  8005ad:	85 c9                	test   %ecx,%ecx
  8005af:	74 2c                	je     8005dd <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8b 10                	mov    (%eax),%edx
  8005b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005bb:	8d 40 04             	lea    0x4(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005c6:	eb 54                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	8b 48 04             	mov    0x4(%eax),%ecx
  8005d0:	8d 40 08             	lea    0x8(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d6:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005db:	eb 3f                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 10                	mov    (%eax),%edx
  8005e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ed:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005f2:	eb 28                	jmp    80061c <vprintfmt+0x38c>
			putch('0', putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	53                   	push   %ebx
  8005f8:	6a 30                	push   $0x30
  8005fa:	ff d6                	call   *%esi
			putch('x', putdat);
  8005fc:	83 c4 08             	add    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	6a 78                	push   $0x78
  800602:	ff d6                	call   *%esi
			num = (unsigned long long)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 10                	mov    (%eax),%edx
  800609:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80060e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800611:	8d 40 04             	lea    0x4(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800617:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80061c:	83 ec 0c             	sub    $0xc,%esp
  80061f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800623:	57                   	push   %edi
  800624:	ff 75 e0             	pushl  -0x20(%ebp)
  800627:	50                   	push   %eax
  800628:	51                   	push   %ecx
  800629:	52                   	push   %edx
  80062a:	89 da                	mov    %ebx,%edx
  80062c:	89 f0                	mov    %esi,%eax
  80062e:	e8 72 fb ff ff       	call   8001a5 <printnum>
			break;
  800633:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800636:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800639:	83 c7 01             	add    $0x1,%edi
  80063c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800640:	83 f8 25             	cmp    $0x25,%eax
  800643:	0f 84 62 fc ff ff    	je     8002ab <vprintfmt+0x1b>
			if (ch == '\0')
  800649:	85 c0                	test   %eax,%eax
  80064b:	0f 84 8b 00 00 00    	je     8006dc <vprintfmt+0x44c>
			putch(ch, putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	50                   	push   %eax
  800656:	ff d6                	call   *%esi
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	eb dc                	jmp    800639 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80065d:	83 f9 01             	cmp    $0x1,%ecx
  800660:	7f 1b                	jg     80067d <vprintfmt+0x3ed>
	else if (lflag)
  800662:	85 c9                	test   %ecx,%ecx
  800664:	74 2c                	je     800692 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 10                	mov    (%eax),%edx
  80066b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800670:	8d 40 04             	lea    0x4(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800676:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80067b:	eb 9f                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 10                	mov    (%eax),%edx
  800682:	8b 48 04             	mov    0x4(%eax),%ecx
  800685:	8d 40 08             	lea    0x8(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800690:	eb 8a                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 10                	mov    (%eax),%edx
  800697:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069c:	8d 40 04             	lea    0x4(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006a7:	e9 70 ff ff ff       	jmp    80061c <vprintfmt+0x38c>
			putch(ch, putdat);
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	53                   	push   %ebx
  8006b0:	6a 25                	push   $0x25
  8006b2:	ff d6                	call   *%esi
			break;
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	e9 7a ff ff ff       	jmp    800636 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 25                	push   $0x25
  8006c2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	89 f8                	mov    %edi,%eax
  8006c9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006cd:	74 05                	je     8006d4 <vprintfmt+0x444>
  8006cf:	83 e8 01             	sub    $0x1,%eax
  8006d2:	eb f5                	jmp    8006c9 <vprintfmt+0x439>
  8006d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006d7:	e9 5a ff ff ff       	jmp    800636 <vprintfmt+0x3a6>
}
  8006dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006df:	5b                   	pop    %ebx
  8006e0:	5e                   	pop    %esi
  8006e1:	5f                   	pop    %edi
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006e4:	f3 0f 1e fb          	endbr32 
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	83 ec 18             	sub    $0x18,%esp
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006f7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006fb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800705:	85 c0                	test   %eax,%eax
  800707:	74 26                	je     80072f <vsnprintf+0x4b>
  800709:	85 d2                	test   %edx,%edx
  80070b:	7e 22                	jle    80072f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80070d:	ff 75 14             	pushl  0x14(%ebp)
  800710:	ff 75 10             	pushl  0x10(%ebp)
  800713:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800716:	50                   	push   %eax
  800717:	68 4e 02 80 00       	push   $0x80024e
  80071c:	e8 6f fb ff ff       	call   800290 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800724:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80072a:	83 c4 10             	add    $0x10,%esp
}
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    
		return -E_INVAL;
  80072f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800734:	eb f7                	jmp    80072d <vsnprintf+0x49>

00800736 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800736:	f3 0f 1e fb          	endbr32 
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800740:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800743:	50                   	push   %eax
  800744:	ff 75 10             	pushl  0x10(%ebp)
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 08             	pushl  0x8(%ebp)
  80074d:	e8 92 ff ff ff       	call   8006e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800754:	f3 0f 1e fb          	endbr32 
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80075e:	b8 00 00 00 00       	mov    $0x0,%eax
  800763:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800767:	74 05                	je     80076e <strlen+0x1a>
		n++;
  800769:	83 c0 01             	add    $0x1,%eax
  80076c:	eb f5                	jmp    800763 <strlen+0xf>
	return n;
}
  80076e:	5d                   	pop    %ebp
  80076f:	c3                   	ret    

00800770 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800770:	f3 0f 1e fb          	endbr32 
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80077a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077d:	b8 00 00 00 00       	mov    $0x0,%eax
  800782:	39 d0                	cmp    %edx,%eax
  800784:	74 0d                	je     800793 <strnlen+0x23>
  800786:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80078a:	74 05                	je     800791 <strnlen+0x21>
		n++;
  80078c:	83 c0 01             	add    $0x1,%eax
  80078f:	eb f1                	jmp    800782 <strnlen+0x12>
  800791:	89 c2                	mov    %eax,%edx
	return n;
}
  800793:	89 d0                	mov    %edx,%eax
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800797:	f3 0f 1e fb          	endbr32 
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007aa:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007ae:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007b1:	83 c0 01             	add    $0x1,%eax
  8007b4:	84 d2                	test   %dl,%dl
  8007b6:	75 f2                	jne    8007aa <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007b8:	89 c8                	mov    %ecx,%eax
  8007ba:	5b                   	pop    %ebx
  8007bb:	5d                   	pop    %ebp
  8007bc:	c3                   	ret    

008007bd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007bd:	f3 0f 1e fb          	endbr32 
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	53                   	push   %ebx
  8007c5:	83 ec 10             	sub    $0x10,%esp
  8007c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007cb:	53                   	push   %ebx
  8007cc:	e8 83 ff ff ff       	call   800754 <strlen>
  8007d1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007d4:	ff 75 0c             	pushl  0xc(%ebp)
  8007d7:	01 d8                	add    %ebx,%eax
  8007d9:	50                   	push   %eax
  8007da:	e8 b8 ff ff ff       	call   800797 <strcpy>
	return dst;
}
  8007df:	89 d8                	mov    %ebx,%eax
  8007e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007e6:	f3 0f 1e fb          	endbr32 
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	56                   	push   %esi
  8007ee:	53                   	push   %ebx
  8007ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f5:	89 f3                	mov    %esi,%ebx
  8007f7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007fa:	89 f0                	mov    %esi,%eax
  8007fc:	39 d8                	cmp    %ebx,%eax
  8007fe:	74 11                	je     800811 <strncpy+0x2b>
		*dst++ = *src;
  800800:	83 c0 01             	add    $0x1,%eax
  800803:	0f b6 0a             	movzbl (%edx),%ecx
  800806:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800809:	80 f9 01             	cmp    $0x1,%cl
  80080c:	83 da ff             	sbb    $0xffffffff,%edx
  80080f:	eb eb                	jmp    8007fc <strncpy+0x16>
	}
	return ret;
}
  800811:	89 f0                	mov    %esi,%eax
  800813:	5b                   	pop    %ebx
  800814:	5e                   	pop    %esi
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800817:	f3 0f 1e fb          	endbr32 
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	56                   	push   %esi
  80081f:	53                   	push   %ebx
  800820:	8b 75 08             	mov    0x8(%ebp),%esi
  800823:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800826:	8b 55 10             	mov    0x10(%ebp),%edx
  800829:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80082b:	85 d2                	test   %edx,%edx
  80082d:	74 21                	je     800850 <strlcpy+0x39>
  80082f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800833:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800835:	39 c2                	cmp    %eax,%edx
  800837:	74 14                	je     80084d <strlcpy+0x36>
  800839:	0f b6 19             	movzbl (%ecx),%ebx
  80083c:	84 db                	test   %bl,%bl
  80083e:	74 0b                	je     80084b <strlcpy+0x34>
			*dst++ = *src++;
  800840:	83 c1 01             	add    $0x1,%ecx
  800843:	83 c2 01             	add    $0x1,%edx
  800846:	88 5a ff             	mov    %bl,-0x1(%edx)
  800849:	eb ea                	jmp    800835 <strlcpy+0x1e>
  80084b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80084d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800850:	29 f0                	sub    %esi,%eax
}
  800852:	5b                   	pop    %ebx
  800853:	5e                   	pop    %esi
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800856:	f3 0f 1e fb          	endbr32 
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800860:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800863:	0f b6 01             	movzbl (%ecx),%eax
  800866:	84 c0                	test   %al,%al
  800868:	74 0c                	je     800876 <strcmp+0x20>
  80086a:	3a 02                	cmp    (%edx),%al
  80086c:	75 08                	jne    800876 <strcmp+0x20>
		p++, q++;
  80086e:	83 c1 01             	add    $0x1,%ecx
  800871:	83 c2 01             	add    $0x1,%edx
  800874:	eb ed                	jmp    800863 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800876:	0f b6 c0             	movzbl %al,%eax
  800879:	0f b6 12             	movzbl (%edx),%edx
  80087c:	29 d0                	sub    %edx,%eax
}
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800880:	f3 0f 1e fb          	endbr32 
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	53                   	push   %ebx
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088e:	89 c3                	mov    %eax,%ebx
  800890:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800893:	eb 06                	jmp    80089b <strncmp+0x1b>
		n--, p++, q++;
  800895:	83 c0 01             	add    $0x1,%eax
  800898:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80089b:	39 d8                	cmp    %ebx,%eax
  80089d:	74 16                	je     8008b5 <strncmp+0x35>
  80089f:	0f b6 08             	movzbl (%eax),%ecx
  8008a2:	84 c9                	test   %cl,%cl
  8008a4:	74 04                	je     8008aa <strncmp+0x2a>
  8008a6:	3a 0a                	cmp    (%edx),%cl
  8008a8:	74 eb                	je     800895 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008aa:	0f b6 00             	movzbl (%eax),%eax
  8008ad:	0f b6 12             	movzbl (%edx),%edx
  8008b0:	29 d0                	sub    %edx,%eax
}
  8008b2:	5b                   	pop    %ebx
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    
		return 0;
  8008b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ba:	eb f6                	jmp    8008b2 <strncmp+0x32>

008008bc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008bc:	f3 0f 1e fb          	endbr32 
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ca:	0f b6 10             	movzbl (%eax),%edx
  8008cd:	84 d2                	test   %dl,%dl
  8008cf:	74 09                	je     8008da <strchr+0x1e>
		if (*s == c)
  8008d1:	38 ca                	cmp    %cl,%dl
  8008d3:	74 0a                	je     8008df <strchr+0x23>
	for (; *s; s++)
  8008d5:	83 c0 01             	add    $0x1,%eax
  8008d8:	eb f0                	jmp    8008ca <strchr+0xe>
			return (char *) s;
	return 0;
  8008da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008e1:	f3 0f 1e fb          	endbr32 
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ef:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008f2:	38 ca                	cmp    %cl,%dl
  8008f4:	74 09                	je     8008ff <strfind+0x1e>
  8008f6:	84 d2                	test   %dl,%dl
  8008f8:	74 05                	je     8008ff <strfind+0x1e>
	for (; *s; s++)
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	eb f0                	jmp    8008ef <strfind+0xe>
			break;
	return (char *) s;
}
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800901:	f3 0f 1e fb          	endbr32 
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	57                   	push   %edi
  800909:	56                   	push   %esi
  80090a:	53                   	push   %ebx
  80090b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80090e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800911:	85 c9                	test   %ecx,%ecx
  800913:	74 31                	je     800946 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800915:	89 f8                	mov    %edi,%eax
  800917:	09 c8                	or     %ecx,%eax
  800919:	a8 03                	test   $0x3,%al
  80091b:	75 23                	jne    800940 <memset+0x3f>
		c &= 0xFF;
  80091d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800921:	89 d3                	mov    %edx,%ebx
  800923:	c1 e3 08             	shl    $0x8,%ebx
  800926:	89 d0                	mov    %edx,%eax
  800928:	c1 e0 18             	shl    $0x18,%eax
  80092b:	89 d6                	mov    %edx,%esi
  80092d:	c1 e6 10             	shl    $0x10,%esi
  800930:	09 f0                	or     %esi,%eax
  800932:	09 c2                	or     %eax,%edx
  800934:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800936:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800939:	89 d0                	mov    %edx,%eax
  80093b:	fc                   	cld    
  80093c:	f3 ab                	rep stos %eax,%es:(%edi)
  80093e:	eb 06                	jmp    800946 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
  800943:	fc                   	cld    
  800944:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800946:	89 f8                	mov    %edi,%eax
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5f                   	pop    %edi
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	57                   	push   %edi
  800955:	56                   	push   %esi
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 75 0c             	mov    0xc(%ebp),%esi
  80095c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80095f:	39 c6                	cmp    %eax,%esi
  800961:	73 32                	jae    800995 <memmove+0x48>
  800963:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800966:	39 c2                	cmp    %eax,%edx
  800968:	76 2b                	jbe    800995 <memmove+0x48>
		s += n;
		d += n;
  80096a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096d:	89 fe                	mov    %edi,%esi
  80096f:	09 ce                	or     %ecx,%esi
  800971:	09 d6                	or     %edx,%esi
  800973:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800979:	75 0e                	jne    800989 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80097b:	83 ef 04             	sub    $0x4,%edi
  80097e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800981:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800984:	fd                   	std    
  800985:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800987:	eb 09                	jmp    800992 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800989:	83 ef 01             	sub    $0x1,%edi
  80098c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80098f:	fd                   	std    
  800990:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800992:	fc                   	cld    
  800993:	eb 1a                	jmp    8009af <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800995:	89 c2                	mov    %eax,%edx
  800997:	09 ca                	or     %ecx,%edx
  800999:	09 f2                	or     %esi,%edx
  80099b:	f6 c2 03             	test   $0x3,%dl
  80099e:	75 0a                	jne    8009aa <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009a0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009a3:	89 c7                	mov    %eax,%edi
  8009a5:	fc                   	cld    
  8009a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a8:	eb 05                	jmp    8009af <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009aa:	89 c7                	mov    %eax,%edi
  8009ac:	fc                   	cld    
  8009ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009af:	5e                   	pop    %esi
  8009b0:	5f                   	pop    %edi
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    

008009b3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009b3:	f3 0f 1e fb          	endbr32 
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009bd:	ff 75 10             	pushl  0x10(%ebp)
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	ff 75 08             	pushl  0x8(%ebp)
  8009c6:	e8 82 ff ff ff       	call   80094d <memmove>
}
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    

008009cd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009cd:	f3 0f 1e fb          	endbr32 
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	56                   	push   %esi
  8009d5:	53                   	push   %ebx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	89 c6                	mov    %eax,%esi
  8009de:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e1:	39 f0                	cmp    %esi,%eax
  8009e3:	74 1c                	je     800a01 <memcmp+0x34>
		if (*s1 != *s2)
  8009e5:	0f b6 08             	movzbl (%eax),%ecx
  8009e8:	0f b6 1a             	movzbl (%edx),%ebx
  8009eb:	38 d9                	cmp    %bl,%cl
  8009ed:	75 08                	jne    8009f7 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009ef:	83 c0 01             	add    $0x1,%eax
  8009f2:	83 c2 01             	add    $0x1,%edx
  8009f5:	eb ea                	jmp    8009e1 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009f7:	0f b6 c1             	movzbl %cl,%eax
  8009fa:	0f b6 db             	movzbl %bl,%ebx
  8009fd:	29 d8                	sub    %ebx,%eax
  8009ff:	eb 05                	jmp    800a06 <memcmp+0x39>
	}

	return 0;
  800a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a06:	5b                   	pop    %ebx
  800a07:	5e                   	pop    %esi
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a0a:	f3 0f 1e fb          	endbr32 
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a17:	89 c2                	mov    %eax,%edx
  800a19:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a1c:	39 d0                	cmp    %edx,%eax
  800a1e:	73 09                	jae    800a29 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a20:	38 08                	cmp    %cl,(%eax)
  800a22:	74 05                	je     800a29 <memfind+0x1f>
	for (; s < ends; s++)
  800a24:	83 c0 01             	add    $0x1,%eax
  800a27:	eb f3                	jmp    800a1c <memfind+0x12>
			break;
	return (void *) s;
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a2b:	f3 0f 1e fb          	endbr32 
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	57                   	push   %edi
  800a33:	56                   	push   %esi
  800a34:	53                   	push   %ebx
  800a35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a3b:	eb 03                	jmp    800a40 <strtol+0x15>
		s++;
  800a3d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a40:	0f b6 01             	movzbl (%ecx),%eax
  800a43:	3c 20                	cmp    $0x20,%al
  800a45:	74 f6                	je     800a3d <strtol+0x12>
  800a47:	3c 09                	cmp    $0x9,%al
  800a49:	74 f2                	je     800a3d <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a4b:	3c 2b                	cmp    $0x2b,%al
  800a4d:	74 2a                	je     800a79 <strtol+0x4e>
	int neg = 0;
  800a4f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a54:	3c 2d                	cmp    $0x2d,%al
  800a56:	74 2b                	je     800a83 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a58:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a5e:	75 0f                	jne    800a6f <strtol+0x44>
  800a60:	80 39 30             	cmpb   $0x30,(%ecx)
  800a63:	74 28                	je     800a8d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a65:	85 db                	test   %ebx,%ebx
  800a67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a6c:	0f 44 d8             	cmove  %eax,%ebx
  800a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a74:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a77:	eb 46                	jmp    800abf <strtol+0x94>
		s++;
  800a79:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a7c:	bf 00 00 00 00       	mov    $0x0,%edi
  800a81:	eb d5                	jmp    800a58 <strtol+0x2d>
		s++, neg = 1;
  800a83:	83 c1 01             	add    $0x1,%ecx
  800a86:	bf 01 00 00 00       	mov    $0x1,%edi
  800a8b:	eb cb                	jmp    800a58 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a91:	74 0e                	je     800aa1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a93:	85 db                	test   %ebx,%ebx
  800a95:	75 d8                	jne    800a6f <strtol+0x44>
		s++, base = 8;
  800a97:	83 c1 01             	add    $0x1,%ecx
  800a9a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a9f:	eb ce                	jmp    800a6f <strtol+0x44>
		s += 2, base = 16;
  800aa1:	83 c1 02             	add    $0x2,%ecx
  800aa4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa9:	eb c4                	jmp    800a6f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800aab:	0f be d2             	movsbl %dl,%edx
  800aae:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ab1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ab4:	7d 3a                	jge    800af0 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ab6:	83 c1 01             	add    $0x1,%ecx
  800ab9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800abd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800abf:	0f b6 11             	movzbl (%ecx),%edx
  800ac2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ac5:	89 f3                	mov    %esi,%ebx
  800ac7:	80 fb 09             	cmp    $0x9,%bl
  800aca:	76 df                	jbe    800aab <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800acc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800acf:	89 f3                	mov    %esi,%ebx
  800ad1:	80 fb 19             	cmp    $0x19,%bl
  800ad4:	77 08                	ja     800ade <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ad6:	0f be d2             	movsbl %dl,%edx
  800ad9:	83 ea 57             	sub    $0x57,%edx
  800adc:	eb d3                	jmp    800ab1 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ade:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ae1:	89 f3                	mov    %esi,%ebx
  800ae3:	80 fb 19             	cmp    $0x19,%bl
  800ae6:	77 08                	ja     800af0 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ae8:	0f be d2             	movsbl %dl,%edx
  800aeb:	83 ea 37             	sub    $0x37,%edx
  800aee:	eb c1                	jmp    800ab1 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af4:	74 05                	je     800afb <strtol+0xd0>
		*endptr = (char *) s;
  800af6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800afb:	89 c2                	mov    %eax,%edx
  800afd:	f7 da                	neg    %edx
  800aff:	85 ff                	test   %edi,%edi
  800b01:	0f 45 c2             	cmovne %edx,%eax
}
  800b04:	5b                   	pop    %ebx
  800b05:	5e                   	pop    %esi
  800b06:	5f                   	pop    %edi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b09:	f3 0f 1e fb          	endbr32 
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	57                   	push   %edi
  800b11:	56                   	push   %esi
  800b12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
  800b18:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1e:	89 c3                	mov    %eax,%ebx
  800b20:	89 c7                	mov    %eax,%edi
  800b22:	89 c6                	mov    %eax,%esi
  800b24:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b26:	5b                   	pop    %ebx
  800b27:	5e                   	pop    %esi
  800b28:	5f                   	pop    %edi
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <sys_cgetc>:

int
sys_cgetc(void)
{
  800b2b:	f3 0f 1e fb          	endbr32 
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	57                   	push   %edi
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b35:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b3f:	89 d1                	mov    %edx,%ecx
  800b41:	89 d3                	mov    %edx,%ebx
  800b43:	89 d7                	mov    %edx,%edi
  800b45:	89 d6                	mov    %edx,%esi
  800b47:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5e                   	pop    %esi
  800b4b:	5f                   	pop    %edi
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b4e:	f3 0f 1e fb          	endbr32 
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	57                   	push   %edi
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
  800b58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b60:	8b 55 08             	mov    0x8(%ebp),%edx
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	89 cb                	mov    %ecx,%ebx
  800b6a:	89 cf                	mov    %ecx,%edi
  800b6c:	89 ce                	mov    %ecx,%esi
  800b6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b70:	85 c0                	test   %eax,%eax
  800b72:	7f 08                	jg     800b7c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b77:	5b                   	pop    %ebx
  800b78:	5e                   	pop    %esi
  800b79:	5f                   	pop    %edi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b7c:	83 ec 0c             	sub    $0xc,%esp
  800b7f:	50                   	push   %eax
  800b80:	6a 03                	push   $0x3
  800b82:	68 ff 22 80 00       	push   $0x8022ff
  800b87:	6a 23                	push   $0x23
  800b89:	68 1c 23 80 00       	push   $0x80231c
  800b8e:	e8 35 10 00 00       	call   801bc8 <_panic>

00800b93 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b93:	f3 0f 1e fb          	endbr32 
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	57                   	push   %edi
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba2:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba7:	89 d1                	mov    %edx,%ecx
  800ba9:	89 d3                	mov    %edx,%ebx
  800bab:	89 d7                	mov    %edx,%edi
  800bad:	89 d6                	mov    %edx,%esi
  800baf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <sys_yield>:

void
sys_yield(void)
{
  800bb6:	f3 0f 1e fb          	endbr32 
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	57                   	push   %edi
  800bbe:	56                   	push   %esi
  800bbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bca:	89 d1                	mov    %edx,%ecx
  800bcc:	89 d3                	mov    %edx,%ebx
  800bce:	89 d7                	mov    %edx,%edi
  800bd0:	89 d6                	mov    %edx,%esi
  800bd2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5f                   	pop    %edi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bd9:	f3 0f 1e fb          	endbr32 
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	57                   	push   %edi
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be6:	be 00 00 00 00       	mov    $0x0,%esi
  800beb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf1:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf9:	89 f7                	mov    %esi,%edi
  800bfb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfd:	85 c0                	test   %eax,%eax
  800bff:	7f 08                	jg     800c09 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5f                   	pop    %edi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c09:	83 ec 0c             	sub    $0xc,%esp
  800c0c:	50                   	push   %eax
  800c0d:	6a 04                	push   $0x4
  800c0f:	68 ff 22 80 00       	push   $0x8022ff
  800c14:	6a 23                	push   $0x23
  800c16:	68 1c 23 80 00       	push   $0x80231c
  800c1b:	e8 a8 0f 00 00       	call   801bc8 <_panic>

00800c20 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c20:	f3 0f 1e fb          	endbr32 
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
  800c2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c33:	b8 05 00 00 00       	mov    $0x5,%eax
  800c38:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c3b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c3e:	8b 75 18             	mov    0x18(%ebp),%esi
  800c41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c43:	85 c0                	test   %eax,%eax
  800c45:	7f 08                	jg     800c4f <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4f:	83 ec 0c             	sub    $0xc,%esp
  800c52:	50                   	push   %eax
  800c53:	6a 05                	push   $0x5
  800c55:	68 ff 22 80 00       	push   $0x8022ff
  800c5a:	6a 23                	push   $0x23
  800c5c:	68 1c 23 80 00       	push   $0x80231c
  800c61:	e8 62 0f 00 00       	call   801bc8 <_panic>

00800c66 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c66:	f3 0f 1e fb          	endbr32 
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7e:	b8 06 00 00 00       	mov    $0x6,%eax
  800c83:	89 df                	mov    %ebx,%edi
  800c85:	89 de                	mov    %ebx,%esi
  800c87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	7f 08                	jg     800c95 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	50                   	push   %eax
  800c99:	6a 06                	push   $0x6
  800c9b:	68 ff 22 80 00       	push   $0x8022ff
  800ca0:	6a 23                	push   $0x23
  800ca2:	68 1c 23 80 00       	push   $0x80231c
  800ca7:	e8 1c 0f 00 00       	call   801bc8 <_panic>

00800cac <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cac:	f3 0f 1e fb          	endbr32 
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc9:	89 df                	mov    %ebx,%edi
  800ccb:	89 de                	mov    %ebx,%esi
  800ccd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	7f 08                	jg     800cdb <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdb:	83 ec 0c             	sub    $0xc,%esp
  800cde:	50                   	push   %eax
  800cdf:	6a 08                	push   $0x8
  800ce1:	68 ff 22 80 00       	push   $0x8022ff
  800ce6:	6a 23                	push   $0x23
  800ce8:	68 1c 23 80 00       	push   $0x80231c
  800ced:	e8 d6 0e 00 00       	call   801bc8 <_panic>

00800cf2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf2:	f3 0f 1e fb          	endbr32 
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
  800cfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d0f:	89 df                	mov    %ebx,%edi
  800d11:	89 de                	mov    %ebx,%esi
  800d13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d15:	85 c0                	test   %eax,%eax
  800d17:	7f 08                	jg     800d21 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	50                   	push   %eax
  800d25:	6a 09                	push   $0x9
  800d27:	68 ff 22 80 00       	push   $0x8022ff
  800d2c:	6a 23                	push   $0x23
  800d2e:	68 1c 23 80 00       	push   $0x80231c
  800d33:	e8 90 0e 00 00       	call   801bc8 <_panic>

00800d38 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d38:	f3 0f 1e fb          	endbr32 
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d55:	89 df                	mov    %ebx,%edi
  800d57:	89 de                	mov    %ebx,%esi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d67:	83 ec 0c             	sub    $0xc,%esp
  800d6a:	50                   	push   %eax
  800d6b:	6a 0a                	push   $0xa
  800d6d:	68 ff 22 80 00       	push   $0x8022ff
  800d72:	6a 23                	push   $0x23
  800d74:	68 1c 23 80 00       	push   $0x80231c
  800d79:	e8 4a 0e 00 00       	call   801bc8 <_panic>

00800d7e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d7e:	f3 0f 1e fb          	endbr32 
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d93:	be 00 00 00 00       	mov    $0x0,%esi
  800d98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800da5:	f3 0f 1e fb          	endbr32 
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dba:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dbf:	89 cb                	mov    %ecx,%ebx
  800dc1:	89 cf                	mov    %ecx,%edi
  800dc3:	89 ce                	mov    %ecx,%esi
  800dc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	7f 08                	jg     800dd3 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd3:	83 ec 0c             	sub    $0xc,%esp
  800dd6:	50                   	push   %eax
  800dd7:	6a 0d                	push   $0xd
  800dd9:	68 ff 22 80 00       	push   $0x8022ff
  800dde:	6a 23                	push   $0x23
  800de0:	68 1c 23 80 00       	push   $0x80231c
  800de5:	e8 de 0d 00 00       	call   801bc8 <_panic>

00800dea <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800dea:	f3 0f 1e fb          	endbr32 
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800df4:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800dfb:	74 0a                	je     800e07 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  800e07:	83 ec 04             	sub    $0x4,%esp
  800e0a:	6a 07                	push   $0x7
  800e0c:	68 00 f0 bf ee       	push   $0xeebff000
  800e11:	6a 00                	push   $0x0
  800e13:	e8 c1 fd ff ff       	call   800bd9 <sys_page_alloc>
  800e18:	83 c4 10             	add    $0x10,%esp
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	78 2a                	js     800e49 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	68 5d 0e 80 00       	push   $0x800e5d
  800e27:	6a 00                	push   $0x0
  800e29:	e8 0a ff ff ff       	call   800d38 <sys_env_set_pgfault_upcall>
  800e2e:	83 c4 10             	add    $0x10,%esp
  800e31:	85 c0                	test   %eax,%eax
  800e33:	79 c8                	jns    800dfd <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  800e35:	83 ec 04             	sub    $0x4,%esp
  800e38:	68 58 23 80 00       	push   $0x802358
  800e3d:	6a 25                	push   $0x25
  800e3f:	68 90 23 80 00       	push   $0x802390
  800e44:	e8 7f 0d 00 00       	call   801bc8 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 2c 23 80 00       	push   $0x80232c
  800e51:	6a 22                	push   $0x22
  800e53:	68 90 23 80 00       	push   $0x802390
  800e58:	e8 6b 0d 00 00       	call   801bc8 <_panic>

00800e5d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e5d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e5e:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800e63:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e65:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  800e68:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800e6c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800e70:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800e73:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800e75:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  800e79:	83 c4 08             	add    $0x8,%esp
	popal
  800e7c:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  800e7d:	83 c4 04             	add    $0x4,%esp
	popfl
  800e80:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  800e81:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  800e82:	c3                   	ret    

00800e83 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e83:	f3 0f 1e fb          	endbr32 
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	05 00 00 00 30       	add    $0x30000000,%eax
  800e92:	c1 e8 0c             	shr    $0xc,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e97:	f3 0f 1e fb          	endbr32 
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ea6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eab:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    

00800eb2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800eb2:	f3 0f 1e fb          	endbr32 
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ebe:	89 c2                	mov    %eax,%edx
  800ec0:	c1 ea 16             	shr    $0x16,%edx
  800ec3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800eca:	f6 c2 01             	test   $0x1,%dl
  800ecd:	74 2d                	je     800efc <fd_alloc+0x4a>
  800ecf:	89 c2                	mov    %eax,%edx
  800ed1:	c1 ea 0c             	shr    $0xc,%edx
  800ed4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800edb:	f6 c2 01             	test   $0x1,%dl
  800ede:	74 1c                	je     800efc <fd_alloc+0x4a>
  800ee0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ee5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800eea:	75 d2                	jne    800ebe <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ef5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800efa:	eb 0a                	jmp    800f06 <fd_alloc+0x54>
			*fd_store = fd;
  800efc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eff:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f08:	f3 0f 1e fb          	endbr32 
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f12:	83 f8 1f             	cmp    $0x1f,%eax
  800f15:	77 30                	ja     800f47 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f17:	c1 e0 0c             	shl    $0xc,%eax
  800f1a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f1f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f25:	f6 c2 01             	test   $0x1,%dl
  800f28:	74 24                	je     800f4e <fd_lookup+0x46>
  800f2a:	89 c2                	mov    %eax,%edx
  800f2c:	c1 ea 0c             	shr    $0xc,%edx
  800f2f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f36:	f6 c2 01             	test   $0x1,%dl
  800f39:	74 1a                	je     800f55 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3e:	89 02                	mov    %eax,(%edx)
	return 0;
  800f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    
		return -E_INVAL;
  800f47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f4c:	eb f7                	jmp    800f45 <fd_lookup+0x3d>
		return -E_INVAL;
  800f4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f53:	eb f0                	jmp    800f45 <fd_lookup+0x3d>
  800f55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5a:	eb e9                	jmp    800f45 <fd_lookup+0x3d>

00800f5c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f5c:	f3 0f 1e fb          	endbr32 
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f69:	ba 1c 24 80 00       	mov    $0x80241c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f6e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f73:	39 08                	cmp    %ecx,(%eax)
  800f75:	74 33                	je     800faa <dev_lookup+0x4e>
  800f77:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f7a:	8b 02                	mov    (%edx),%eax
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	75 f3                	jne    800f73 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f80:	a1 04 40 80 00       	mov    0x804004,%eax
  800f85:	8b 40 48             	mov    0x48(%eax),%eax
  800f88:	83 ec 04             	sub    $0x4,%esp
  800f8b:	51                   	push   %ecx
  800f8c:	50                   	push   %eax
  800f8d:	68 a0 23 80 00       	push   $0x8023a0
  800f92:	e8 f6 f1 ff ff       	call   80018d <cprintf>
	*dev = 0;
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fa0:	83 c4 10             	add    $0x10,%esp
  800fa3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    
			*dev = devtab[i];
  800faa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fad:	89 01                	mov    %eax,(%ecx)
			return 0;
  800faf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb4:	eb f2                	jmp    800fa8 <dev_lookup+0x4c>

00800fb6 <fd_close>:
{
  800fb6:	f3 0f 1e fb          	endbr32 
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	57                   	push   %edi
  800fbe:	56                   	push   %esi
  800fbf:	53                   	push   %ebx
  800fc0:	83 ec 24             	sub    $0x24,%esp
  800fc3:	8b 75 08             	mov    0x8(%ebp),%esi
  800fc6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fc9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fcc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fcd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fd3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fd6:	50                   	push   %eax
  800fd7:	e8 2c ff ff ff       	call   800f08 <fd_lookup>
  800fdc:	89 c3                	mov    %eax,%ebx
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	78 05                	js     800fea <fd_close+0x34>
	    || fd != fd2)
  800fe5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fe8:	74 16                	je     801000 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800fea:	89 f8                	mov    %edi,%eax
  800fec:	84 c0                	test   %al,%al
  800fee:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff3:	0f 44 d8             	cmove  %eax,%ebx
}
  800ff6:	89 d8                	mov    %ebx,%eax
  800ff8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffb:	5b                   	pop    %ebx
  800ffc:	5e                   	pop    %esi
  800ffd:	5f                   	pop    %edi
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801000:	83 ec 08             	sub    $0x8,%esp
  801003:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801006:	50                   	push   %eax
  801007:	ff 36                	pushl  (%esi)
  801009:	e8 4e ff ff ff       	call   800f5c <dev_lookup>
  80100e:	89 c3                	mov    %eax,%ebx
  801010:	83 c4 10             	add    $0x10,%esp
  801013:	85 c0                	test   %eax,%eax
  801015:	78 1a                	js     801031 <fd_close+0x7b>
		if (dev->dev_close)
  801017:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80101a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80101d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801022:	85 c0                	test   %eax,%eax
  801024:	74 0b                	je     801031 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801026:	83 ec 0c             	sub    $0xc,%esp
  801029:	56                   	push   %esi
  80102a:	ff d0                	call   *%eax
  80102c:	89 c3                	mov    %eax,%ebx
  80102e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	56                   	push   %esi
  801035:	6a 00                	push   $0x0
  801037:	e8 2a fc ff ff       	call   800c66 <sys_page_unmap>
	return r;
  80103c:	83 c4 10             	add    $0x10,%esp
  80103f:	eb b5                	jmp    800ff6 <fd_close+0x40>

00801041 <close>:

int
close(int fdnum)
{
  801041:	f3 0f 1e fb          	endbr32 
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80104b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80104e:	50                   	push   %eax
  80104f:	ff 75 08             	pushl  0x8(%ebp)
  801052:	e8 b1 fe ff ff       	call   800f08 <fd_lookup>
  801057:	83 c4 10             	add    $0x10,%esp
  80105a:	85 c0                	test   %eax,%eax
  80105c:	79 02                	jns    801060 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80105e:	c9                   	leave  
  80105f:	c3                   	ret    
		return fd_close(fd, 1);
  801060:	83 ec 08             	sub    $0x8,%esp
  801063:	6a 01                	push   $0x1
  801065:	ff 75 f4             	pushl  -0xc(%ebp)
  801068:	e8 49 ff ff ff       	call   800fb6 <fd_close>
  80106d:	83 c4 10             	add    $0x10,%esp
  801070:	eb ec                	jmp    80105e <close+0x1d>

00801072 <close_all>:

void
close_all(void)
{
  801072:	f3 0f 1e fb          	endbr32 
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	53                   	push   %ebx
  80107a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80107d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	53                   	push   %ebx
  801086:	e8 b6 ff ff ff       	call   801041 <close>
	for (i = 0; i < MAXFD; i++)
  80108b:	83 c3 01             	add    $0x1,%ebx
  80108e:	83 c4 10             	add    $0x10,%esp
  801091:	83 fb 20             	cmp    $0x20,%ebx
  801094:	75 ec                	jne    801082 <close_all+0x10>
}
  801096:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80109b:	f3 0f 1e fb          	endbr32 
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	57                   	push   %edi
  8010a3:	56                   	push   %esi
  8010a4:	53                   	push   %ebx
  8010a5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010ab:	50                   	push   %eax
  8010ac:	ff 75 08             	pushl  0x8(%ebp)
  8010af:	e8 54 fe ff ff       	call   800f08 <fd_lookup>
  8010b4:	89 c3                	mov    %eax,%ebx
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	0f 88 81 00 00 00    	js     801142 <dup+0xa7>
		return r;
	close(newfdnum);
  8010c1:	83 ec 0c             	sub    $0xc,%esp
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	e8 75 ff ff ff       	call   801041 <close>

	newfd = INDEX2FD(newfdnum);
  8010cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010cf:	c1 e6 0c             	shl    $0xc,%esi
  8010d2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010d8:	83 c4 04             	add    $0x4,%esp
  8010db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010de:	e8 b4 fd ff ff       	call   800e97 <fd2data>
  8010e3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010e5:	89 34 24             	mov    %esi,(%esp)
  8010e8:	e8 aa fd ff ff       	call   800e97 <fd2data>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010f2:	89 d8                	mov    %ebx,%eax
  8010f4:	c1 e8 16             	shr    $0x16,%eax
  8010f7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010fe:	a8 01                	test   $0x1,%al
  801100:	74 11                	je     801113 <dup+0x78>
  801102:	89 d8                	mov    %ebx,%eax
  801104:	c1 e8 0c             	shr    $0xc,%eax
  801107:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80110e:	f6 c2 01             	test   $0x1,%dl
  801111:	75 39                	jne    80114c <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801113:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801116:	89 d0                	mov    %edx,%eax
  801118:	c1 e8 0c             	shr    $0xc,%eax
  80111b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801122:	83 ec 0c             	sub    $0xc,%esp
  801125:	25 07 0e 00 00       	and    $0xe07,%eax
  80112a:	50                   	push   %eax
  80112b:	56                   	push   %esi
  80112c:	6a 00                	push   $0x0
  80112e:	52                   	push   %edx
  80112f:	6a 00                	push   $0x0
  801131:	e8 ea fa ff ff       	call   800c20 <sys_page_map>
  801136:	89 c3                	mov    %eax,%ebx
  801138:	83 c4 20             	add    $0x20,%esp
  80113b:	85 c0                	test   %eax,%eax
  80113d:	78 31                	js     801170 <dup+0xd5>
		goto err;

	return newfdnum;
  80113f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801142:	89 d8                	mov    %ebx,%eax
  801144:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801147:	5b                   	pop    %ebx
  801148:	5e                   	pop    %esi
  801149:	5f                   	pop    %edi
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80114c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	25 07 0e 00 00       	and    $0xe07,%eax
  80115b:	50                   	push   %eax
  80115c:	57                   	push   %edi
  80115d:	6a 00                	push   $0x0
  80115f:	53                   	push   %ebx
  801160:	6a 00                	push   $0x0
  801162:	e8 b9 fa ff ff       	call   800c20 <sys_page_map>
  801167:	89 c3                	mov    %eax,%ebx
  801169:	83 c4 20             	add    $0x20,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	79 a3                	jns    801113 <dup+0x78>
	sys_page_unmap(0, newfd);
  801170:	83 ec 08             	sub    $0x8,%esp
  801173:	56                   	push   %esi
  801174:	6a 00                	push   $0x0
  801176:	e8 eb fa ff ff       	call   800c66 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80117b:	83 c4 08             	add    $0x8,%esp
  80117e:	57                   	push   %edi
  80117f:	6a 00                	push   $0x0
  801181:	e8 e0 fa ff ff       	call   800c66 <sys_page_unmap>
	return r;
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	eb b7                	jmp    801142 <dup+0xa7>

0080118b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80118b:	f3 0f 1e fb          	endbr32 
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	53                   	push   %ebx
  801193:	83 ec 1c             	sub    $0x1c,%esp
  801196:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801199:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80119c:	50                   	push   %eax
  80119d:	53                   	push   %ebx
  80119e:	e8 65 fd ff ff       	call   800f08 <fd_lookup>
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	78 3f                	js     8011e9 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011aa:	83 ec 08             	sub    $0x8,%esp
  8011ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b0:	50                   	push   %eax
  8011b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b4:	ff 30                	pushl  (%eax)
  8011b6:	e8 a1 fd ff ff       	call   800f5c <dev_lookup>
  8011bb:	83 c4 10             	add    $0x10,%esp
  8011be:	85 c0                	test   %eax,%eax
  8011c0:	78 27                	js     8011e9 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c5:	8b 42 08             	mov    0x8(%edx),%eax
  8011c8:	83 e0 03             	and    $0x3,%eax
  8011cb:	83 f8 01             	cmp    $0x1,%eax
  8011ce:	74 1e                	je     8011ee <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d3:	8b 40 08             	mov    0x8(%eax),%eax
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	74 35                	je     80120f <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011da:	83 ec 04             	sub    $0x4,%esp
  8011dd:	ff 75 10             	pushl  0x10(%ebp)
  8011e0:	ff 75 0c             	pushl  0xc(%ebp)
  8011e3:	52                   	push   %edx
  8011e4:	ff d0                	call   *%eax
  8011e6:	83 c4 10             	add    $0x10,%esp
}
  8011e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8011f3:	8b 40 48             	mov    0x48(%eax),%eax
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	53                   	push   %ebx
  8011fa:	50                   	push   %eax
  8011fb:	68 e1 23 80 00       	push   $0x8023e1
  801200:	e8 88 ef ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80120d:	eb da                	jmp    8011e9 <read+0x5e>
		return -E_NOT_SUPP;
  80120f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801214:	eb d3                	jmp    8011e9 <read+0x5e>

00801216 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801216:	f3 0f 1e fb          	endbr32 
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	57                   	push   %edi
  80121e:	56                   	push   %esi
  80121f:	53                   	push   %ebx
  801220:	83 ec 0c             	sub    $0xc,%esp
  801223:	8b 7d 08             	mov    0x8(%ebp),%edi
  801226:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801229:	bb 00 00 00 00       	mov    $0x0,%ebx
  80122e:	eb 02                	jmp    801232 <readn+0x1c>
  801230:	01 c3                	add    %eax,%ebx
  801232:	39 f3                	cmp    %esi,%ebx
  801234:	73 21                	jae    801257 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801236:	83 ec 04             	sub    $0x4,%esp
  801239:	89 f0                	mov    %esi,%eax
  80123b:	29 d8                	sub    %ebx,%eax
  80123d:	50                   	push   %eax
  80123e:	89 d8                	mov    %ebx,%eax
  801240:	03 45 0c             	add    0xc(%ebp),%eax
  801243:	50                   	push   %eax
  801244:	57                   	push   %edi
  801245:	e8 41 ff ff ff       	call   80118b <read>
		if (m < 0)
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	85 c0                	test   %eax,%eax
  80124f:	78 04                	js     801255 <readn+0x3f>
			return m;
		if (m == 0)
  801251:	75 dd                	jne    801230 <readn+0x1a>
  801253:	eb 02                	jmp    801257 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801255:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801257:	89 d8                	mov    %ebx,%eax
  801259:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125c:	5b                   	pop    %ebx
  80125d:	5e                   	pop    %esi
  80125e:	5f                   	pop    %edi
  80125f:	5d                   	pop    %ebp
  801260:	c3                   	ret    

00801261 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801261:	f3 0f 1e fb          	endbr32 
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	53                   	push   %ebx
  801269:	83 ec 1c             	sub    $0x1c,%esp
  80126c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80126f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801272:	50                   	push   %eax
  801273:	53                   	push   %ebx
  801274:	e8 8f fc ff ff       	call   800f08 <fd_lookup>
  801279:	83 c4 10             	add    $0x10,%esp
  80127c:	85 c0                	test   %eax,%eax
  80127e:	78 3a                	js     8012ba <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801280:	83 ec 08             	sub    $0x8,%esp
  801283:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801286:	50                   	push   %eax
  801287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128a:	ff 30                	pushl  (%eax)
  80128c:	e8 cb fc ff ff       	call   800f5c <dev_lookup>
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	85 c0                	test   %eax,%eax
  801296:	78 22                	js     8012ba <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801298:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80129b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80129f:	74 1e                	je     8012bf <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a4:	8b 52 0c             	mov    0xc(%edx),%edx
  8012a7:	85 d2                	test   %edx,%edx
  8012a9:	74 35                	je     8012e0 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012ab:	83 ec 04             	sub    $0x4,%esp
  8012ae:	ff 75 10             	pushl  0x10(%ebp)
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	50                   	push   %eax
  8012b5:	ff d2                	call   *%edx
  8012b7:	83 c4 10             	add    $0x10,%esp
}
  8012ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012bf:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c4:	8b 40 48             	mov    0x48(%eax),%eax
  8012c7:	83 ec 04             	sub    $0x4,%esp
  8012ca:	53                   	push   %ebx
  8012cb:	50                   	push   %eax
  8012cc:	68 fd 23 80 00       	push   $0x8023fd
  8012d1:	e8 b7 ee ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  8012d6:	83 c4 10             	add    $0x10,%esp
  8012d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012de:	eb da                	jmp    8012ba <write+0x59>
		return -E_NOT_SUPP;
  8012e0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012e5:	eb d3                	jmp    8012ba <write+0x59>

008012e7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012e7:	f3 0f 1e fb          	endbr32 
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f4:	50                   	push   %eax
  8012f5:	ff 75 08             	pushl  0x8(%ebp)
  8012f8:	e8 0b fc ff ff       	call   800f08 <fd_lookup>
  8012fd:	83 c4 10             	add    $0x10,%esp
  801300:	85 c0                	test   %eax,%eax
  801302:	78 0e                	js     801312 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80130d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801314:	f3 0f 1e fb          	endbr32 
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	53                   	push   %ebx
  80131c:	83 ec 1c             	sub    $0x1c,%esp
  80131f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801322:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801325:	50                   	push   %eax
  801326:	53                   	push   %ebx
  801327:	e8 dc fb ff ff       	call   800f08 <fd_lookup>
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 37                	js     80136a <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801333:	83 ec 08             	sub    $0x8,%esp
  801336:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801339:	50                   	push   %eax
  80133a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133d:	ff 30                	pushl  (%eax)
  80133f:	e8 18 fc ff ff       	call   800f5c <dev_lookup>
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	85 c0                	test   %eax,%eax
  801349:	78 1f                	js     80136a <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80134b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801352:	74 1b                	je     80136f <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801354:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801357:	8b 52 18             	mov    0x18(%edx),%edx
  80135a:	85 d2                	test   %edx,%edx
  80135c:	74 32                	je     801390 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80135e:	83 ec 08             	sub    $0x8,%esp
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	50                   	push   %eax
  801365:	ff d2                	call   *%edx
  801367:	83 c4 10             	add    $0x10,%esp
}
  80136a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80136f:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801374:	8b 40 48             	mov    0x48(%eax),%eax
  801377:	83 ec 04             	sub    $0x4,%esp
  80137a:	53                   	push   %ebx
  80137b:	50                   	push   %eax
  80137c:	68 c0 23 80 00       	push   $0x8023c0
  801381:	e8 07 ee ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  801386:	83 c4 10             	add    $0x10,%esp
  801389:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138e:	eb da                	jmp    80136a <ftruncate+0x56>
		return -E_NOT_SUPP;
  801390:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801395:	eb d3                	jmp    80136a <ftruncate+0x56>

00801397 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801397:	f3 0f 1e fb          	endbr32 
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	53                   	push   %ebx
  80139f:	83 ec 1c             	sub    $0x1c,%esp
  8013a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a8:	50                   	push   %eax
  8013a9:	ff 75 08             	pushl  0x8(%ebp)
  8013ac:	e8 57 fb ff ff       	call   800f08 <fd_lookup>
  8013b1:	83 c4 10             	add    $0x10,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	78 4b                	js     801403 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b8:	83 ec 08             	sub    $0x8,%esp
  8013bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013be:	50                   	push   %eax
  8013bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c2:	ff 30                	pushl  (%eax)
  8013c4:	e8 93 fb ff ff       	call   800f5c <dev_lookup>
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 33                	js     801403 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8013d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013d7:	74 2f                	je     801408 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013d9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013dc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013e3:	00 00 00 
	stat->st_isdir = 0;
  8013e6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013ed:	00 00 00 
	stat->st_dev = dev;
  8013f0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013f6:	83 ec 08             	sub    $0x8,%esp
  8013f9:	53                   	push   %ebx
  8013fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8013fd:	ff 50 14             	call   *0x14(%eax)
  801400:	83 c4 10             	add    $0x10,%esp
}
  801403:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801406:	c9                   	leave  
  801407:	c3                   	ret    
		return -E_NOT_SUPP;
  801408:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140d:	eb f4                	jmp    801403 <fstat+0x6c>

0080140f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80140f:	f3 0f 1e fb          	endbr32 
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	56                   	push   %esi
  801417:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801418:	83 ec 08             	sub    $0x8,%esp
  80141b:	6a 00                	push   $0x0
  80141d:	ff 75 08             	pushl  0x8(%ebp)
  801420:	e8 fb 01 00 00       	call   801620 <open>
  801425:	89 c3                	mov    %eax,%ebx
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	85 c0                	test   %eax,%eax
  80142c:	78 1b                	js     801449 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	50                   	push   %eax
  801435:	e8 5d ff ff ff       	call   801397 <fstat>
  80143a:	89 c6                	mov    %eax,%esi
	close(fd);
  80143c:	89 1c 24             	mov    %ebx,(%esp)
  80143f:	e8 fd fb ff ff       	call   801041 <close>
	return r;
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	89 f3                	mov    %esi,%ebx
}
  801449:	89 d8                	mov    %ebx,%eax
  80144b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5d                   	pop    %ebp
  801451:	c3                   	ret    

00801452 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	56                   	push   %esi
  801456:	53                   	push   %ebx
  801457:	89 c6                	mov    %eax,%esi
  801459:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80145b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801462:	74 27                	je     80148b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801464:	6a 07                	push   $0x7
  801466:	68 00 50 80 00       	push   $0x805000
  80146b:	56                   	push   %esi
  80146c:	ff 35 00 40 80 00    	pushl  0x804000
  801472:	e8 20 08 00 00       	call   801c97 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801477:	83 c4 0c             	add    $0xc,%esp
  80147a:	6a 00                	push   $0x0
  80147c:	53                   	push   %ebx
  80147d:	6a 00                	push   $0x0
  80147f:	e8 8e 07 00 00       	call   801c12 <ipc_recv>
}
  801484:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801487:	5b                   	pop    %ebx
  801488:	5e                   	pop    %esi
  801489:	5d                   	pop    %ebp
  80148a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80148b:	83 ec 0c             	sub    $0xc,%esp
  80148e:	6a 01                	push   $0x1
  801490:	e8 5a 08 00 00       	call   801cef <ipc_find_env>
  801495:	a3 00 40 80 00       	mov    %eax,0x804000
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	eb c5                	jmp    801464 <fsipc+0x12>

0080149f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80149f:	f3 0f 1e fb          	endbr32 
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8014af:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c1:	b8 02 00 00 00       	mov    $0x2,%eax
  8014c6:	e8 87 ff ff ff       	call   801452 <fsipc>
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <devfile_flush>:
{
  8014cd:	f3 0f 1e fb          	endbr32 
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8b 40 0c             	mov    0xc(%eax),%eax
  8014dd:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e7:	b8 06 00 00 00       	mov    $0x6,%eax
  8014ec:	e8 61 ff ff ff       	call   801452 <fsipc>
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <devfile_stat>:
{
  8014f3:	f3 0f 1e fb          	endbr32 
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	53                   	push   %ebx
  8014fb:	83 ec 04             	sub    $0x4,%esp
  8014fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	8b 40 0c             	mov    0xc(%eax),%eax
  801507:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80150c:	ba 00 00 00 00       	mov    $0x0,%edx
  801511:	b8 05 00 00 00       	mov    $0x5,%eax
  801516:	e8 37 ff ff ff       	call   801452 <fsipc>
  80151b:	85 c0                	test   %eax,%eax
  80151d:	78 2c                	js     80154b <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	68 00 50 80 00       	push   $0x805000
  801527:	53                   	push   %ebx
  801528:	e8 6a f2 ff ff       	call   800797 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80152d:	a1 80 50 80 00       	mov    0x805080,%eax
  801532:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801538:	a1 84 50 80 00       	mov    0x805084,%eax
  80153d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801543:	83 c4 10             	add    $0x10,%esp
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <devfile_write>:
{
  801550:	f3 0f 1e fb          	endbr32 
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 0c             	sub    $0xc,%esp
  80155a:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80155d:	8b 55 08             	mov    0x8(%ebp),%edx
  801560:	8b 52 0c             	mov    0xc(%edx),%edx
  801563:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801569:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80156e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801573:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801576:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80157b:	50                   	push   %eax
  80157c:	ff 75 0c             	pushl  0xc(%ebp)
  80157f:	68 08 50 80 00       	push   $0x805008
  801584:	e8 c4 f3 ff ff       	call   80094d <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801589:	ba 00 00 00 00       	mov    $0x0,%edx
  80158e:	b8 04 00 00 00       	mov    $0x4,%eax
  801593:	e8 ba fe ff ff       	call   801452 <fsipc>
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <devfile_read>:
{
  80159a:	f3 0f 1e fb          	endbr32 
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	56                   	push   %esi
  8015a2:	53                   	push   %ebx
  8015a3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ac:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015b1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8015c1:	e8 8c fe ff ff       	call   801452 <fsipc>
  8015c6:	89 c3                	mov    %eax,%ebx
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	78 1f                	js     8015eb <devfile_read+0x51>
	assert(r <= n);
  8015cc:	39 f0                	cmp    %esi,%eax
  8015ce:	77 24                	ja     8015f4 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8015d0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015d5:	7f 33                	jg     80160a <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	50                   	push   %eax
  8015db:	68 00 50 80 00       	push   $0x805000
  8015e0:	ff 75 0c             	pushl  0xc(%ebp)
  8015e3:	e8 65 f3 ff ff       	call   80094d <memmove>
	return r;
  8015e8:	83 c4 10             	add    $0x10,%esp
}
  8015eb:	89 d8                	mov    %ebx,%eax
  8015ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5d                   	pop    %ebp
  8015f3:	c3                   	ret    
	assert(r <= n);
  8015f4:	68 2c 24 80 00       	push   $0x80242c
  8015f9:	68 33 24 80 00       	push   $0x802433
  8015fe:	6a 7c                	push   $0x7c
  801600:	68 48 24 80 00       	push   $0x802448
  801605:	e8 be 05 00 00       	call   801bc8 <_panic>
	assert(r <= PGSIZE);
  80160a:	68 53 24 80 00       	push   $0x802453
  80160f:	68 33 24 80 00       	push   $0x802433
  801614:	6a 7d                	push   $0x7d
  801616:	68 48 24 80 00       	push   $0x802448
  80161b:	e8 a8 05 00 00       	call   801bc8 <_panic>

00801620 <open>:
{
  801620:	f3 0f 1e fb          	endbr32 
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	56                   	push   %esi
  801628:	53                   	push   %ebx
  801629:	83 ec 1c             	sub    $0x1c,%esp
  80162c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80162f:	56                   	push   %esi
  801630:	e8 1f f1 ff ff       	call   800754 <strlen>
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80163d:	7f 6c                	jg     8016ab <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80163f:	83 ec 0c             	sub    $0xc,%esp
  801642:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801645:	50                   	push   %eax
  801646:	e8 67 f8 ff ff       	call   800eb2 <fd_alloc>
  80164b:	89 c3                	mov    %eax,%ebx
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	85 c0                	test   %eax,%eax
  801652:	78 3c                	js     801690 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801654:	83 ec 08             	sub    $0x8,%esp
  801657:	56                   	push   %esi
  801658:	68 00 50 80 00       	push   $0x805000
  80165d:	e8 35 f1 ff ff       	call   800797 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801662:	8b 45 0c             	mov    0xc(%ebp),%eax
  801665:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80166a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166d:	b8 01 00 00 00       	mov    $0x1,%eax
  801672:	e8 db fd ff ff       	call   801452 <fsipc>
  801677:	89 c3                	mov    %eax,%ebx
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	85 c0                	test   %eax,%eax
  80167e:	78 19                	js     801699 <open+0x79>
	return fd2num(fd);
  801680:	83 ec 0c             	sub    $0xc,%esp
  801683:	ff 75 f4             	pushl  -0xc(%ebp)
  801686:	e8 f8 f7 ff ff       	call   800e83 <fd2num>
  80168b:	89 c3                	mov    %eax,%ebx
  80168d:	83 c4 10             	add    $0x10,%esp
}
  801690:	89 d8                	mov    %ebx,%eax
  801692:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5d                   	pop    %ebp
  801698:	c3                   	ret    
		fd_close(fd, 0);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	6a 00                	push   $0x0
  80169e:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a1:	e8 10 f9 ff ff       	call   800fb6 <fd_close>
		return r;
  8016a6:	83 c4 10             	add    $0x10,%esp
  8016a9:	eb e5                	jmp    801690 <open+0x70>
		return -E_BAD_PATH;
  8016ab:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016b0:	eb de                	jmp    801690 <open+0x70>

008016b2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016b2:	f3 0f 1e fb          	endbr32 
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8016c6:	e8 87 fd ff ff       	call   801452 <fsipc>
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016cd:	f3 0f 1e fb          	endbr32 
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	56                   	push   %esi
  8016d5:	53                   	push   %ebx
  8016d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8016d9:	83 ec 0c             	sub    $0xc,%esp
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	e8 b3 f7 ff ff       	call   800e97 <fd2data>
  8016e4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8016e6:	83 c4 08             	add    $0x8,%esp
  8016e9:	68 5f 24 80 00       	push   $0x80245f
  8016ee:	53                   	push   %ebx
  8016ef:	e8 a3 f0 ff ff       	call   800797 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016f4:	8b 46 04             	mov    0x4(%esi),%eax
  8016f7:	2b 06                	sub    (%esi),%eax
  8016f9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8016ff:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801706:	00 00 00 
	stat->st_dev = &devpipe;
  801709:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801710:	30 80 00 
	return 0;
}
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
  801718:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171b:	5b                   	pop    %ebx
  80171c:	5e                   	pop    %esi
  80171d:	5d                   	pop    %ebp
  80171e:	c3                   	ret    

0080171f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80171f:	f3 0f 1e fb          	endbr32 
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	53                   	push   %ebx
  801727:	83 ec 0c             	sub    $0xc,%esp
  80172a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80172d:	53                   	push   %ebx
  80172e:	6a 00                	push   $0x0
  801730:	e8 31 f5 ff ff       	call   800c66 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801735:	89 1c 24             	mov    %ebx,(%esp)
  801738:	e8 5a f7 ff ff       	call   800e97 <fd2data>
  80173d:	83 c4 08             	add    $0x8,%esp
  801740:	50                   	push   %eax
  801741:	6a 00                	push   $0x0
  801743:	e8 1e f5 ff ff       	call   800c66 <sys_page_unmap>
}
  801748:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <_pipeisclosed>:
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	57                   	push   %edi
  801751:	56                   	push   %esi
  801752:	53                   	push   %ebx
  801753:	83 ec 1c             	sub    $0x1c,%esp
  801756:	89 c7                	mov    %eax,%edi
  801758:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80175a:	a1 04 40 80 00       	mov    0x804004,%eax
  80175f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801762:	83 ec 0c             	sub    $0xc,%esp
  801765:	57                   	push   %edi
  801766:	e8 c1 05 00 00       	call   801d2c <pageref>
  80176b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80176e:	89 34 24             	mov    %esi,(%esp)
  801771:	e8 b6 05 00 00       	call   801d2c <pageref>
		nn = thisenv->env_runs;
  801776:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80177c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	39 cb                	cmp    %ecx,%ebx
  801784:	74 1b                	je     8017a1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801786:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801789:	75 cf                	jne    80175a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80178b:	8b 42 58             	mov    0x58(%edx),%eax
  80178e:	6a 01                	push   $0x1
  801790:	50                   	push   %eax
  801791:	53                   	push   %ebx
  801792:	68 66 24 80 00       	push   $0x802466
  801797:	e8 f1 e9 ff ff       	call   80018d <cprintf>
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	eb b9                	jmp    80175a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8017a1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017a4:	0f 94 c0             	sete   %al
  8017a7:	0f b6 c0             	movzbl %al,%eax
}
  8017aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ad:	5b                   	pop    %ebx
  8017ae:	5e                   	pop    %esi
  8017af:	5f                   	pop    %edi
  8017b0:	5d                   	pop    %ebp
  8017b1:	c3                   	ret    

008017b2 <devpipe_write>:
{
  8017b2:	f3 0f 1e fb          	endbr32 
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	57                   	push   %edi
  8017ba:	56                   	push   %esi
  8017bb:	53                   	push   %ebx
  8017bc:	83 ec 28             	sub    $0x28,%esp
  8017bf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8017c2:	56                   	push   %esi
  8017c3:	e8 cf f6 ff ff       	call   800e97 <fd2data>
  8017c8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017ca:	83 c4 10             	add    $0x10,%esp
  8017cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8017d2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8017d5:	74 4f                	je     801826 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017d7:	8b 43 04             	mov    0x4(%ebx),%eax
  8017da:	8b 0b                	mov    (%ebx),%ecx
  8017dc:	8d 51 20             	lea    0x20(%ecx),%edx
  8017df:	39 d0                	cmp    %edx,%eax
  8017e1:	72 14                	jb     8017f7 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8017e3:	89 da                	mov    %ebx,%edx
  8017e5:	89 f0                	mov    %esi,%eax
  8017e7:	e8 61 ff ff ff       	call   80174d <_pipeisclosed>
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	75 3b                	jne    80182b <devpipe_write+0x79>
			sys_yield();
  8017f0:	e8 c1 f3 ff ff       	call   800bb6 <sys_yield>
  8017f5:	eb e0                	jmp    8017d7 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017fa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8017fe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801801:	89 c2                	mov    %eax,%edx
  801803:	c1 fa 1f             	sar    $0x1f,%edx
  801806:	89 d1                	mov    %edx,%ecx
  801808:	c1 e9 1b             	shr    $0x1b,%ecx
  80180b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80180e:	83 e2 1f             	and    $0x1f,%edx
  801811:	29 ca                	sub    %ecx,%edx
  801813:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801817:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80181b:	83 c0 01             	add    $0x1,%eax
  80181e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801821:	83 c7 01             	add    $0x1,%edi
  801824:	eb ac                	jmp    8017d2 <devpipe_write+0x20>
	return i;
  801826:	8b 45 10             	mov    0x10(%ebp),%eax
  801829:	eb 05                	jmp    801830 <devpipe_write+0x7e>
				return 0;
  80182b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801830:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801833:	5b                   	pop    %ebx
  801834:	5e                   	pop    %esi
  801835:	5f                   	pop    %edi
  801836:	5d                   	pop    %ebp
  801837:	c3                   	ret    

00801838 <devpipe_read>:
{
  801838:	f3 0f 1e fb          	endbr32 
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	57                   	push   %edi
  801840:	56                   	push   %esi
  801841:	53                   	push   %ebx
  801842:	83 ec 18             	sub    $0x18,%esp
  801845:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801848:	57                   	push   %edi
  801849:	e8 49 f6 ff ff       	call   800e97 <fd2data>
  80184e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	be 00 00 00 00       	mov    $0x0,%esi
  801858:	3b 75 10             	cmp    0x10(%ebp),%esi
  80185b:	75 14                	jne    801871 <devpipe_read+0x39>
	return i;
  80185d:	8b 45 10             	mov    0x10(%ebp),%eax
  801860:	eb 02                	jmp    801864 <devpipe_read+0x2c>
				return i;
  801862:	89 f0                	mov    %esi,%eax
}
  801864:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801867:	5b                   	pop    %ebx
  801868:	5e                   	pop    %esi
  801869:	5f                   	pop    %edi
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    
			sys_yield();
  80186c:	e8 45 f3 ff ff       	call   800bb6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801871:	8b 03                	mov    (%ebx),%eax
  801873:	3b 43 04             	cmp    0x4(%ebx),%eax
  801876:	75 18                	jne    801890 <devpipe_read+0x58>
			if (i > 0)
  801878:	85 f6                	test   %esi,%esi
  80187a:	75 e6                	jne    801862 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80187c:	89 da                	mov    %ebx,%edx
  80187e:	89 f8                	mov    %edi,%eax
  801880:	e8 c8 fe ff ff       	call   80174d <_pipeisclosed>
  801885:	85 c0                	test   %eax,%eax
  801887:	74 e3                	je     80186c <devpipe_read+0x34>
				return 0;
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
  80188e:	eb d4                	jmp    801864 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801890:	99                   	cltd   
  801891:	c1 ea 1b             	shr    $0x1b,%edx
  801894:	01 d0                	add    %edx,%eax
  801896:	83 e0 1f             	and    $0x1f,%eax
  801899:	29 d0                	sub    %edx,%eax
  80189b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8018a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8018a6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8018a9:	83 c6 01             	add    $0x1,%esi
  8018ac:	eb aa                	jmp    801858 <devpipe_read+0x20>

008018ae <pipe>:
{
  8018ae:	f3 0f 1e fb          	endbr32 
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	56                   	push   %esi
  8018b6:	53                   	push   %ebx
  8018b7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8018ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018bd:	50                   	push   %eax
  8018be:	e8 ef f5 ff ff       	call   800eb2 <fd_alloc>
  8018c3:	89 c3                	mov    %eax,%ebx
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	0f 88 23 01 00 00    	js     8019f3 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	68 07 04 00 00       	push   $0x407
  8018d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018db:	6a 00                	push   $0x0
  8018dd:	e8 f7 f2 ff ff       	call   800bd9 <sys_page_alloc>
  8018e2:	89 c3                	mov    %eax,%ebx
  8018e4:	83 c4 10             	add    $0x10,%esp
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	0f 88 04 01 00 00    	js     8019f3 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8018ef:	83 ec 0c             	sub    $0xc,%esp
  8018f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f5:	50                   	push   %eax
  8018f6:	e8 b7 f5 ff ff       	call   800eb2 <fd_alloc>
  8018fb:	89 c3                	mov    %eax,%ebx
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	85 c0                	test   %eax,%eax
  801902:	0f 88 db 00 00 00    	js     8019e3 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	68 07 04 00 00       	push   $0x407
  801910:	ff 75 f0             	pushl  -0x10(%ebp)
  801913:	6a 00                	push   $0x0
  801915:	e8 bf f2 ff ff       	call   800bd9 <sys_page_alloc>
  80191a:	89 c3                	mov    %eax,%ebx
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	85 c0                	test   %eax,%eax
  801921:	0f 88 bc 00 00 00    	js     8019e3 <pipe+0x135>
	va = fd2data(fd0);
  801927:	83 ec 0c             	sub    $0xc,%esp
  80192a:	ff 75 f4             	pushl  -0xc(%ebp)
  80192d:	e8 65 f5 ff ff       	call   800e97 <fd2data>
  801932:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801934:	83 c4 0c             	add    $0xc,%esp
  801937:	68 07 04 00 00       	push   $0x407
  80193c:	50                   	push   %eax
  80193d:	6a 00                	push   $0x0
  80193f:	e8 95 f2 ff ff       	call   800bd9 <sys_page_alloc>
  801944:	89 c3                	mov    %eax,%ebx
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	85 c0                	test   %eax,%eax
  80194b:	0f 88 82 00 00 00    	js     8019d3 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801951:	83 ec 0c             	sub    $0xc,%esp
  801954:	ff 75 f0             	pushl  -0x10(%ebp)
  801957:	e8 3b f5 ff ff       	call   800e97 <fd2data>
  80195c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801963:	50                   	push   %eax
  801964:	6a 00                	push   $0x0
  801966:	56                   	push   %esi
  801967:	6a 00                	push   $0x0
  801969:	e8 b2 f2 ff ff       	call   800c20 <sys_page_map>
  80196e:	89 c3                	mov    %eax,%ebx
  801970:	83 c4 20             	add    $0x20,%esp
  801973:	85 c0                	test   %eax,%eax
  801975:	78 4e                	js     8019c5 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801977:	a1 20 30 80 00       	mov    0x803020,%eax
  80197c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801984:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80198b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801993:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80199a:	83 ec 0c             	sub    $0xc,%esp
  80199d:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a0:	e8 de f4 ff ff       	call   800e83 <fd2num>
  8019a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019a8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8019aa:	83 c4 04             	add    $0x4,%esp
  8019ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8019b0:	e8 ce f4 ff ff       	call   800e83 <fd2num>
  8019b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8019bb:	83 c4 10             	add    $0x10,%esp
  8019be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019c3:	eb 2e                	jmp    8019f3 <pipe+0x145>
	sys_page_unmap(0, va);
  8019c5:	83 ec 08             	sub    $0x8,%esp
  8019c8:	56                   	push   %esi
  8019c9:	6a 00                	push   $0x0
  8019cb:	e8 96 f2 ff ff       	call   800c66 <sys_page_unmap>
  8019d0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8019d3:	83 ec 08             	sub    $0x8,%esp
  8019d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8019d9:	6a 00                	push   $0x0
  8019db:	e8 86 f2 ff ff       	call   800c66 <sys_page_unmap>
  8019e0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8019e3:	83 ec 08             	sub    $0x8,%esp
  8019e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e9:	6a 00                	push   $0x0
  8019eb:	e8 76 f2 ff ff       	call   800c66 <sys_page_unmap>
  8019f0:	83 c4 10             	add    $0x10,%esp
}
  8019f3:	89 d8                	mov    %ebx,%eax
  8019f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f8:	5b                   	pop    %ebx
  8019f9:	5e                   	pop    %esi
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    

008019fc <pipeisclosed>:
{
  8019fc:	f3 0f 1e fb          	endbr32 
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a09:	50                   	push   %eax
  801a0a:	ff 75 08             	pushl  0x8(%ebp)
  801a0d:	e8 f6 f4 ff ff       	call   800f08 <fd_lookup>
  801a12:	83 c4 10             	add    $0x10,%esp
  801a15:	85 c0                	test   %eax,%eax
  801a17:	78 18                	js     801a31 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801a19:	83 ec 0c             	sub    $0xc,%esp
  801a1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a1f:	e8 73 f4 ff ff       	call   800e97 <fd2data>
  801a24:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a29:	e8 1f fd ff ff       	call   80174d <_pipeisclosed>
  801a2e:	83 c4 10             	add    $0x10,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801a33:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801a37:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3c:	c3                   	ret    

00801a3d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801a3d:	f3 0f 1e fb          	endbr32 
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801a47:	68 7e 24 80 00       	push   $0x80247e
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	e8 43 ed ff ff       	call   800797 <strcpy>
	return 0;
}
  801a54:	b8 00 00 00 00       	mov    $0x0,%eax
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <devcons_write>:
{
  801a5b:	f3 0f 1e fb          	endbr32 
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	57                   	push   %edi
  801a63:	56                   	push   %esi
  801a64:	53                   	push   %ebx
  801a65:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801a6b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801a70:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801a76:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a79:	73 31                	jae    801aac <devcons_write+0x51>
		m = n - tot;
  801a7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a7e:	29 f3                	sub    %esi,%ebx
  801a80:	83 fb 7f             	cmp    $0x7f,%ebx
  801a83:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a88:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801a8b:	83 ec 04             	sub    $0x4,%esp
  801a8e:	53                   	push   %ebx
  801a8f:	89 f0                	mov    %esi,%eax
  801a91:	03 45 0c             	add    0xc(%ebp),%eax
  801a94:	50                   	push   %eax
  801a95:	57                   	push   %edi
  801a96:	e8 b2 ee ff ff       	call   80094d <memmove>
		sys_cputs(buf, m);
  801a9b:	83 c4 08             	add    $0x8,%esp
  801a9e:	53                   	push   %ebx
  801a9f:	57                   	push   %edi
  801aa0:	e8 64 f0 ff ff       	call   800b09 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801aa5:	01 de                	add    %ebx,%esi
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	eb ca                	jmp    801a76 <devcons_write+0x1b>
}
  801aac:	89 f0                	mov    %esi,%eax
  801aae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab1:	5b                   	pop    %ebx
  801ab2:	5e                   	pop    %esi
  801ab3:	5f                   	pop    %edi
  801ab4:	5d                   	pop    %ebp
  801ab5:	c3                   	ret    

00801ab6 <devcons_read>:
{
  801ab6:	f3 0f 1e fb          	endbr32 
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 08             	sub    $0x8,%esp
  801ac0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ac5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ac9:	74 21                	je     801aec <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801acb:	e8 5b f0 ff ff       	call   800b2b <sys_cgetc>
  801ad0:	85 c0                	test   %eax,%eax
  801ad2:	75 07                	jne    801adb <devcons_read+0x25>
		sys_yield();
  801ad4:	e8 dd f0 ff ff       	call   800bb6 <sys_yield>
  801ad9:	eb f0                	jmp    801acb <devcons_read+0x15>
	if (c < 0)
  801adb:	78 0f                	js     801aec <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801add:	83 f8 04             	cmp    $0x4,%eax
  801ae0:	74 0c                	je     801aee <devcons_read+0x38>
	*(char*)vbuf = c;
  801ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae5:	88 02                	mov    %al,(%edx)
	return 1;
  801ae7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    
		return 0;
  801aee:	b8 00 00 00 00       	mov    $0x0,%eax
  801af3:	eb f7                	jmp    801aec <devcons_read+0x36>

00801af5 <cputchar>:
{
  801af5:	f3 0f 1e fb          	endbr32 
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801b05:	6a 01                	push   $0x1
  801b07:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b0a:	50                   	push   %eax
  801b0b:	e8 f9 ef ff ff       	call   800b09 <sys_cputs>
}
  801b10:	83 c4 10             	add    $0x10,%esp
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <getchar>:
{
  801b15:	f3 0f 1e fb          	endbr32 
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801b1f:	6a 01                	push   $0x1
  801b21:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b24:	50                   	push   %eax
  801b25:	6a 00                	push   $0x0
  801b27:	e8 5f f6 ff ff       	call   80118b <read>
	if (r < 0)
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	78 06                	js     801b39 <getchar+0x24>
	if (r < 1)
  801b33:	74 06                	je     801b3b <getchar+0x26>
	return c;
  801b35:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    
		return -E_EOF;
  801b3b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801b40:	eb f7                	jmp    801b39 <getchar+0x24>

00801b42 <iscons>:
{
  801b42:	f3 0f 1e fb          	endbr32 
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4f:	50                   	push   %eax
  801b50:	ff 75 08             	pushl  0x8(%ebp)
  801b53:	e8 b0 f3 ff ff       	call   800f08 <fd_lookup>
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 11                	js     801b70 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b62:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b68:	39 10                	cmp    %edx,(%eax)
  801b6a:	0f 94 c0             	sete   %al
  801b6d:	0f b6 c0             	movzbl %al,%eax
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <opencons>:
{
  801b72:	f3 0f 1e fb          	endbr32 
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801b7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b7f:	50                   	push   %eax
  801b80:	e8 2d f3 ff ff       	call   800eb2 <fd_alloc>
  801b85:	83 c4 10             	add    $0x10,%esp
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	78 3a                	js     801bc6 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b8c:	83 ec 04             	sub    $0x4,%esp
  801b8f:	68 07 04 00 00       	push   $0x407
  801b94:	ff 75 f4             	pushl  -0xc(%ebp)
  801b97:	6a 00                	push   $0x0
  801b99:	e8 3b f0 ff ff       	call   800bd9 <sys_page_alloc>
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	78 21                	js     801bc6 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bae:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801bba:	83 ec 0c             	sub    $0xc,%esp
  801bbd:	50                   	push   %eax
  801bbe:	e8 c0 f2 ff ff       	call   800e83 <fd2num>
  801bc3:	83 c4 10             	add    $0x10,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801bc8:	f3 0f 1e fb          	endbr32 
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	56                   	push   %esi
  801bd0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801bd1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801bd4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801bda:	e8 b4 ef ff ff       	call   800b93 <sys_getenvid>
  801bdf:	83 ec 0c             	sub    $0xc,%esp
  801be2:	ff 75 0c             	pushl  0xc(%ebp)
  801be5:	ff 75 08             	pushl  0x8(%ebp)
  801be8:	56                   	push   %esi
  801be9:	50                   	push   %eax
  801bea:	68 8c 24 80 00       	push   $0x80248c
  801bef:	e8 99 e5 ff ff       	call   80018d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801bf4:	83 c4 18             	add    $0x18,%esp
  801bf7:	53                   	push   %ebx
  801bf8:	ff 75 10             	pushl  0x10(%ebp)
  801bfb:	e8 38 e5 ff ff       	call   800138 <vcprintf>
	cprintf("\n");
  801c00:	c7 04 24 c8 24 80 00 	movl   $0x8024c8,(%esp)
  801c07:	e8 81 e5 ff ff       	call   80018d <cprintf>
  801c0c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c0f:	cc                   	int3   
  801c10:	eb fd                	jmp    801c0f <_panic+0x47>

00801c12 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c12:	f3 0f 1e fb          	endbr32 
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	56                   	push   %esi
  801c1a:	53                   	push   %ebx
  801c1b:	8b 75 08             	mov    0x8(%ebp),%esi
  801c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801c24:	85 c0                	test   %eax,%eax
  801c26:	74 3d                	je     801c65 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801c28:	83 ec 0c             	sub    $0xc,%esp
  801c2b:	50                   	push   %eax
  801c2c:	e8 74 f1 ff ff       	call   800da5 <sys_ipc_recv>
  801c31:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801c34:	85 f6                	test   %esi,%esi
  801c36:	74 0b                	je     801c43 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801c38:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c3e:	8b 52 74             	mov    0x74(%edx),%edx
  801c41:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801c43:	85 db                	test   %ebx,%ebx
  801c45:	74 0b                	je     801c52 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801c47:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c4d:	8b 52 78             	mov    0x78(%edx),%edx
  801c50:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801c52:	85 c0                	test   %eax,%eax
  801c54:	78 21                	js     801c77 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801c56:	a1 04 40 80 00       	mov    0x804004,%eax
  801c5b:	8b 40 70             	mov    0x70(%eax),%eax
}
  801c5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c61:	5b                   	pop    %ebx
  801c62:	5e                   	pop    %esi
  801c63:	5d                   	pop    %ebp
  801c64:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801c65:	83 ec 0c             	sub    $0xc,%esp
  801c68:	68 00 00 c0 ee       	push   $0xeec00000
  801c6d:	e8 33 f1 ff ff       	call   800da5 <sys_ipc_recv>
  801c72:	83 c4 10             	add    $0x10,%esp
  801c75:	eb bd                	jmp    801c34 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801c77:	85 f6                	test   %esi,%esi
  801c79:	74 10                	je     801c8b <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801c7b:	85 db                	test   %ebx,%ebx
  801c7d:	75 df                	jne    801c5e <ipc_recv+0x4c>
  801c7f:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801c86:	00 00 00 
  801c89:	eb d3                	jmp    801c5e <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801c8b:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801c92:	00 00 00 
  801c95:	eb e4                	jmp    801c7b <ipc_recv+0x69>

00801c97 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c97:	f3 0f 1e fb          	endbr32 
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	57                   	push   %edi
  801c9f:	56                   	push   %esi
  801ca0:	53                   	push   %ebx
  801ca1:	83 ec 0c             	sub    $0xc,%esp
  801ca4:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ca7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801caa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801cad:	85 db                	test   %ebx,%ebx
  801caf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801cb4:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801cb7:	ff 75 14             	pushl  0x14(%ebp)
  801cba:	53                   	push   %ebx
  801cbb:	56                   	push   %esi
  801cbc:	57                   	push   %edi
  801cbd:	e8 bc f0 ff ff       	call   800d7e <sys_ipc_try_send>
  801cc2:	83 c4 10             	add    $0x10,%esp
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	79 1e                	jns    801ce7 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801cc9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ccc:	75 07                	jne    801cd5 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801cce:	e8 e3 ee ff ff       	call   800bb6 <sys_yield>
  801cd3:	eb e2                	jmp    801cb7 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801cd5:	50                   	push   %eax
  801cd6:	68 af 24 80 00       	push   $0x8024af
  801cdb:	6a 59                	push   $0x59
  801cdd:	68 ca 24 80 00       	push   $0x8024ca
  801ce2:	e8 e1 fe ff ff       	call   801bc8 <_panic>
	}
}
  801ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cea:	5b                   	pop    %ebx
  801ceb:	5e                   	pop    %esi
  801cec:	5f                   	pop    %edi
  801ced:	5d                   	pop    %ebp
  801cee:	c3                   	ret    

00801cef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cef:	f3 0f 1e fb          	endbr32 
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cf9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cfe:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801d01:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d07:	8b 52 50             	mov    0x50(%edx),%edx
  801d0a:	39 ca                	cmp    %ecx,%edx
  801d0c:	74 11                	je     801d1f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801d0e:	83 c0 01             	add    $0x1,%eax
  801d11:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d16:	75 e6                	jne    801cfe <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1d:	eb 0b                	jmp    801d2a <ipc_find_env+0x3b>
			return envs[i].env_id;
  801d1f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801d22:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d27:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    

00801d2c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d2c:	f3 0f 1e fb          	endbr32 
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d36:	89 c2                	mov    %eax,%edx
  801d38:	c1 ea 16             	shr    $0x16,%edx
  801d3b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801d42:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801d47:	f6 c1 01             	test   $0x1,%cl
  801d4a:	74 1c                	je     801d68 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801d4c:	c1 e8 0c             	shr    $0xc,%eax
  801d4f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d56:	a8 01                	test   $0x1,%al
  801d58:	74 0e                	je     801d68 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d5a:	c1 e8 0c             	shr    $0xc,%eax
  801d5d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801d64:	ef 
  801d65:	0f b7 d2             	movzwl %dx,%edx
}
  801d68:	89 d0                	mov    %edx,%eax
  801d6a:	5d                   	pop    %ebp
  801d6b:	c3                   	ret    
  801d6c:	66 90                	xchg   %ax,%ax
  801d6e:	66 90                	xchg   %ax,%ax

00801d70 <__udivdi3>:
  801d70:	f3 0f 1e fb          	endbr32 
  801d74:	55                   	push   %ebp
  801d75:	57                   	push   %edi
  801d76:	56                   	push   %esi
  801d77:	53                   	push   %ebx
  801d78:	83 ec 1c             	sub    $0x1c,%esp
  801d7b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801d7f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d83:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d87:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d8b:	85 d2                	test   %edx,%edx
  801d8d:	75 19                	jne    801da8 <__udivdi3+0x38>
  801d8f:	39 f3                	cmp    %esi,%ebx
  801d91:	76 4d                	jbe    801de0 <__udivdi3+0x70>
  801d93:	31 ff                	xor    %edi,%edi
  801d95:	89 e8                	mov    %ebp,%eax
  801d97:	89 f2                	mov    %esi,%edx
  801d99:	f7 f3                	div    %ebx
  801d9b:	89 fa                	mov    %edi,%edx
  801d9d:	83 c4 1c             	add    $0x1c,%esp
  801da0:	5b                   	pop    %ebx
  801da1:	5e                   	pop    %esi
  801da2:	5f                   	pop    %edi
  801da3:	5d                   	pop    %ebp
  801da4:	c3                   	ret    
  801da5:	8d 76 00             	lea    0x0(%esi),%esi
  801da8:	39 f2                	cmp    %esi,%edx
  801daa:	76 14                	jbe    801dc0 <__udivdi3+0x50>
  801dac:	31 ff                	xor    %edi,%edi
  801dae:	31 c0                	xor    %eax,%eax
  801db0:	89 fa                	mov    %edi,%edx
  801db2:	83 c4 1c             	add    $0x1c,%esp
  801db5:	5b                   	pop    %ebx
  801db6:	5e                   	pop    %esi
  801db7:	5f                   	pop    %edi
  801db8:	5d                   	pop    %ebp
  801db9:	c3                   	ret    
  801dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801dc0:	0f bd fa             	bsr    %edx,%edi
  801dc3:	83 f7 1f             	xor    $0x1f,%edi
  801dc6:	75 48                	jne    801e10 <__udivdi3+0xa0>
  801dc8:	39 f2                	cmp    %esi,%edx
  801dca:	72 06                	jb     801dd2 <__udivdi3+0x62>
  801dcc:	31 c0                	xor    %eax,%eax
  801dce:	39 eb                	cmp    %ebp,%ebx
  801dd0:	77 de                	ja     801db0 <__udivdi3+0x40>
  801dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd7:	eb d7                	jmp    801db0 <__udivdi3+0x40>
  801dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801de0:	89 d9                	mov    %ebx,%ecx
  801de2:	85 db                	test   %ebx,%ebx
  801de4:	75 0b                	jne    801df1 <__udivdi3+0x81>
  801de6:	b8 01 00 00 00       	mov    $0x1,%eax
  801deb:	31 d2                	xor    %edx,%edx
  801ded:	f7 f3                	div    %ebx
  801def:	89 c1                	mov    %eax,%ecx
  801df1:	31 d2                	xor    %edx,%edx
  801df3:	89 f0                	mov    %esi,%eax
  801df5:	f7 f1                	div    %ecx
  801df7:	89 c6                	mov    %eax,%esi
  801df9:	89 e8                	mov    %ebp,%eax
  801dfb:	89 f7                	mov    %esi,%edi
  801dfd:	f7 f1                	div    %ecx
  801dff:	89 fa                	mov    %edi,%edx
  801e01:	83 c4 1c             	add    $0x1c,%esp
  801e04:	5b                   	pop    %ebx
  801e05:	5e                   	pop    %esi
  801e06:	5f                   	pop    %edi
  801e07:	5d                   	pop    %ebp
  801e08:	c3                   	ret    
  801e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e10:	89 f9                	mov    %edi,%ecx
  801e12:	b8 20 00 00 00       	mov    $0x20,%eax
  801e17:	29 f8                	sub    %edi,%eax
  801e19:	d3 e2                	shl    %cl,%edx
  801e1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e1f:	89 c1                	mov    %eax,%ecx
  801e21:	89 da                	mov    %ebx,%edx
  801e23:	d3 ea                	shr    %cl,%edx
  801e25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e29:	09 d1                	or     %edx,%ecx
  801e2b:	89 f2                	mov    %esi,%edx
  801e2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e31:	89 f9                	mov    %edi,%ecx
  801e33:	d3 e3                	shl    %cl,%ebx
  801e35:	89 c1                	mov    %eax,%ecx
  801e37:	d3 ea                	shr    %cl,%edx
  801e39:	89 f9                	mov    %edi,%ecx
  801e3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e3f:	89 eb                	mov    %ebp,%ebx
  801e41:	d3 e6                	shl    %cl,%esi
  801e43:	89 c1                	mov    %eax,%ecx
  801e45:	d3 eb                	shr    %cl,%ebx
  801e47:	09 de                	or     %ebx,%esi
  801e49:	89 f0                	mov    %esi,%eax
  801e4b:	f7 74 24 08          	divl   0x8(%esp)
  801e4f:	89 d6                	mov    %edx,%esi
  801e51:	89 c3                	mov    %eax,%ebx
  801e53:	f7 64 24 0c          	mull   0xc(%esp)
  801e57:	39 d6                	cmp    %edx,%esi
  801e59:	72 15                	jb     801e70 <__udivdi3+0x100>
  801e5b:	89 f9                	mov    %edi,%ecx
  801e5d:	d3 e5                	shl    %cl,%ebp
  801e5f:	39 c5                	cmp    %eax,%ebp
  801e61:	73 04                	jae    801e67 <__udivdi3+0xf7>
  801e63:	39 d6                	cmp    %edx,%esi
  801e65:	74 09                	je     801e70 <__udivdi3+0x100>
  801e67:	89 d8                	mov    %ebx,%eax
  801e69:	31 ff                	xor    %edi,%edi
  801e6b:	e9 40 ff ff ff       	jmp    801db0 <__udivdi3+0x40>
  801e70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e73:	31 ff                	xor    %edi,%edi
  801e75:	e9 36 ff ff ff       	jmp    801db0 <__udivdi3+0x40>
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	66 90                	xchg   %ax,%ax
  801e7e:	66 90                	xchg   %ax,%ax

00801e80 <__umoddi3>:
  801e80:	f3 0f 1e fb          	endbr32 
  801e84:	55                   	push   %ebp
  801e85:	57                   	push   %edi
  801e86:	56                   	push   %esi
  801e87:	53                   	push   %ebx
  801e88:	83 ec 1c             	sub    $0x1c,%esp
  801e8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e8f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e93:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	75 19                	jne    801eb8 <__umoddi3+0x38>
  801e9f:	39 df                	cmp    %ebx,%edi
  801ea1:	76 5d                	jbe    801f00 <__umoddi3+0x80>
  801ea3:	89 f0                	mov    %esi,%eax
  801ea5:	89 da                	mov    %ebx,%edx
  801ea7:	f7 f7                	div    %edi
  801ea9:	89 d0                	mov    %edx,%eax
  801eab:	31 d2                	xor    %edx,%edx
  801ead:	83 c4 1c             	add    $0x1c,%esp
  801eb0:	5b                   	pop    %ebx
  801eb1:	5e                   	pop    %esi
  801eb2:	5f                   	pop    %edi
  801eb3:	5d                   	pop    %ebp
  801eb4:	c3                   	ret    
  801eb5:	8d 76 00             	lea    0x0(%esi),%esi
  801eb8:	89 f2                	mov    %esi,%edx
  801eba:	39 d8                	cmp    %ebx,%eax
  801ebc:	76 12                	jbe    801ed0 <__umoddi3+0x50>
  801ebe:	89 f0                	mov    %esi,%eax
  801ec0:	89 da                	mov    %ebx,%edx
  801ec2:	83 c4 1c             	add    $0x1c,%esp
  801ec5:	5b                   	pop    %ebx
  801ec6:	5e                   	pop    %esi
  801ec7:	5f                   	pop    %edi
  801ec8:	5d                   	pop    %ebp
  801ec9:	c3                   	ret    
  801eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ed0:	0f bd e8             	bsr    %eax,%ebp
  801ed3:	83 f5 1f             	xor    $0x1f,%ebp
  801ed6:	75 50                	jne    801f28 <__umoddi3+0xa8>
  801ed8:	39 d8                	cmp    %ebx,%eax
  801eda:	0f 82 e0 00 00 00    	jb     801fc0 <__umoddi3+0x140>
  801ee0:	89 d9                	mov    %ebx,%ecx
  801ee2:	39 f7                	cmp    %esi,%edi
  801ee4:	0f 86 d6 00 00 00    	jbe    801fc0 <__umoddi3+0x140>
  801eea:	89 d0                	mov    %edx,%eax
  801eec:	89 ca                	mov    %ecx,%edx
  801eee:	83 c4 1c             	add    $0x1c,%esp
  801ef1:	5b                   	pop    %ebx
  801ef2:	5e                   	pop    %esi
  801ef3:	5f                   	pop    %edi
  801ef4:	5d                   	pop    %ebp
  801ef5:	c3                   	ret    
  801ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801efd:	8d 76 00             	lea    0x0(%esi),%esi
  801f00:	89 fd                	mov    %edi,%ebp
  801f02:	85 ff                	test   %edi,%edi
  801f04:	75 0b                	jne    801f11 <__umoddi3+0x91>
  801f06:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0b:	31 d2                	xor    %edx,%edx
  801f0d:	f7 f7                	div    %edi
  801f0f:	89 c5                	mov    %eax,%ebp
  801f11:	89 d8                	mov    %ebx,%eax
  801f13:	31 d2                	xor    %edx,%edx
  801f15:	f7 f5                	div    %ebp
  801f17:	89 f0                	mov    %esi,%eax
  801f19:	f7 f5                	div    %ebp
  801f1b:	89 d0                	mov    %edx,%eax
  801f1d:	31 d2                	xor    %edx,%edx
  801f1f:	eb 8c                	jmp    801ead <__umoddi3+0x2d>
  801f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f28:	89 e9                	mov    %ebp,%ecx
  801f2a:	ba 20 00 00 00       	mov    $0x20,%edx
  801f2f:	29 ea                	sub    %ebp,%edx
  801f31:	d3 e0                	shl    %cl,%eax
  801f33:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f37:	89 d1                	mov    %edx,%ecx
  801f39:	89 f8                	mov    %edi,%eax
  801f3b:	d3 e8                	shr    %cl,%eax
  801f3d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f41:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f45:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f49:	09 c1                	or     %eax,%ecx
  801f4b:	89 d8                	mov    %ebx,%eax
  801f4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f51:	89 e9                	mov    %ebp,%ecx
  801f53:	d3 e7                	shl    %cl,%edi
  801f55:	89 d1                	mov    %edx,%ecx
  801f57:	d3 e8                	shr    %cl,%eax
  801f59:	89 e9                	mov    %ebp,%ecx
  801f5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f5f:	d3 e3                	shl    %cl,%ebx
  801f61:	89 c7                	mov    %eax,%edi
  801f63:	89 d1                	mov    %edx,%ecx
  801f65:	89 f0                	mov    %esi,%eax
  801f67:	d3 e8                	shr    %cl,%eax
  801f69:	89 e9                	mov    %ebp,%ecx
  801f6b:	89 fa                	mov    %edi,%edx
  801f6d:	d3 e6                	shl    %cl,%esi
  801f6f:	09 d8                	or     %ebx,%eax
  801f71:	f7 74 24 08          	divl   0x8(%esp)
  801f75:	89 d1                	mov    %edx,%ecx
  801f77:	89 f3                	mov    %esi,%ebx
  801f79:	f7 64 24 0c          	mull   0xc(%esp)
  801f7d:	89 c6                	mov    %eax,%esi
  801f7f:	89 d7                	mov    %edx,%edi
  801f81:	39 d1                	cmp    %edx,%ecx
  801f83:	72 06                	jb     801f8b <__umoddi3+0x10b>
  801f85:	75 10                	jne    801f97 <__umoddi3+0x117>
  801f87:	39 c3                	cmp    %eax,%ebx
  801f89:	73 0c                	jae    801f97 <__umoddi3+0x117>
  801f8b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801f8f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801f93:	89 d7                	mov    %edx,%edi
  801f95:	89 c6                	mov    %eax,%esi
  801f97:	89 ca                	mov    %ecx,%edx
  801f99:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f9e:	29 f3                	sub    %esi,%ebx
  801fa0:	19 fa                	sbb    %edi,%edx
  801fa2:	89 d0                	mov    %edx,%eax
  801fa4:	d3 e0                	shl    %cl,%eax
  801fa6:	89 e9                	mov    %ebp,%ecx
  801fa8:	d3 eb                	shr    %cl,%ebx
  801faa:	d3 ea                	shr    %cl,%edx
  801fac:	09 d8                	or     %ebx,%eax
  801fae:	83 c4 1c             	add    $0x1c,%esp
  801fb1:	5b                   	pop    %ebx
  801fb2:	5e                   	pop    %esi
  801fb3:	5f                   	pop    %edi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    
  801fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fbd:	8d 76 00             	lea    0x0(%esi),%esi
  801fc0:	29 fe                	sub    %edi,%esi
  801fc2:	19 c3                	sbb    %eax,%ebx
  801fc4:	89 f2                	mov    %esi,%edx
  801fc6:	89 d9                	mov    %ebx,%ecx
  801fc8:	e9 1d ff ff ff       	jmp    801eea <__umoddi3+0x6a>
