
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
  800049:	68 40 25 80 00       	push   $0x802540
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
  800074:	e8 20 0e 00 00       	call   800e99 <set_pgfault_handler>
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
  8000a9:	a3 08 40 80 00       	mov    %eax,0x804008

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
  8000dc:	e8 45 10 00 00       	call   801126 <close_all>
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
  8001f3:	e8 e8 20 00 00       	call   8022e0 <__udivdi3>
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
  800231:	e8 ba 21 00 00       	call   8023f0 <__umoddi3>
  800236:	83 c4 14             	add    $0x14,%esp
  800239:	0f be 80 66 25 80 00 	movsbl 0x802566(%eax),%eax
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
  8002e0:	3e ff 24 85 a0 26 80 	notrack jmp *0x8026a0(,%eax,4)
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
  8003ad:	8b 14 85 00 28 80 00 	mov    0x802800(,%eax,4),%edx
  8003b4:	85 d2                	test   %edx,%edx
  8003b6:	74 18                	je     8003d0 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003b8:	52                   	push   %edx
  8003b9:	68 a9 29 80 00       	push   $0x8029a9
  8003be:	53                   	push   %ebx
  8003bf:	56                   	push   %esi
  8003c0:	e8 aa fe ff ff       	call   80026f <printfmt>
  8003c5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003cb:	e9 66 02 00 00       	jmp    800636 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003d0:	50                   	push   %eax
  8003d1:	68 7e 25 80 00       	push   $0x80257e
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
  8003f8:	b8 77 25 80 00       	mov    $0x802577,%eax
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
  800b82:	68 5f 28 80 00       	push   $0x80285f
  800b87:	6a 23                	push   $0x23
  800b89:	68 7c 28 80 00       	push   $0x80287c
  800b8e:	e8 a1 15 00 00       	call   802134 <_panic>

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
  800c0f:	68 5f 28 80 00       	push   $0x80285f
  800c14:	6a 23                	push   $0x23
  800c16:	68 7c 28 80 00       	push   $0x80287c
  800c1b:	e8 14 15 00 00       	call   802134 <_panic>

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
  800c55:	68 5f 28 80 00       	push   $0x80285f
  800c5a:	6a 23                	push   $0x23
  800c5c:	68 7c 28 80 00       	push   $0x80287c
  800c61:	e8 ce 14 00 00       	call   802134 <_panic>

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
  800c9b:	68 5f 28 80 00       	push   $0x80285f
  800ca0:	6a 23                	push   $0x23
  800ca2:	68 7c 28 80 00       	push   $0x80287c
  800ca7:	e8 88 14 00 00       	call   802134 <_panic>

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
  800ce1:	68 5f 28 80 00       	push   $0x80285f
  800ce6:	6a 23                	push   $0x23
  800ce8:	68 7c 28 80 00       	push   $0x80287c
  800ced:	e8 42 14 00 00       	call   802134 <_panic>

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
  800d27:	68 5f 28 80 00       	push   $0x80285f
  800d2c:	6a 23                	push   $0x23
  800d2e:	68 7c 28 80 00       	push   $0x80287c
  800d33:	e8 fc 13 00 00       	call   802134 <_panic>

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
  800d6d:	68 5f 28 80 00       	push   $0x80285f
  800d72:	6a 23                	push   $0x23
  800d74:	68 7c 28 80 00       	push   $0x80287c
  800d79:	e8 b6 13 00 00       	call   802134 <_panic>

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
  800dd9:	68 5f 28 80 00       	push   $0x80285f
  800dde:	6a 23                	push   $0x23
  800de0:	68 7c 28 80 00       	push   $0x80287c
  800de5:	e8 4a 13 00 00       	call   802134 <_panic>

00800dea <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dea:	f3 0f 1e fb          	endbr32 
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	57                   	push   %edi
  800df2:	56                   	push   %esi
  800df3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df4:	ba 00 00 00 00       	mov    $0x0,%edx
  800df9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dfe:	89 d1                	mov    %edx,%ecx
  800e00:	89 d3                	mov    %edx,%ebx
  800e02:	89 d7                	mov    %edx,%edi
  800e04:	89 d6                	mov    %edx,%esi
  800e06:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5f                   	pop    %edi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800e0d:	f3 0f 1e fb          	endbr32 
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	57                   	push   %edi
  800e15:	56                   	push   %esi
  800e16:	53                   	push   %ebx
  800e17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e25:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e2a:	89 df                	mov    %ebx,%edi
  800e2c:	89 de                	mov    %ebx,%esi
  800e2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e30:	85 c0                	test   %eax,%eax
  800e32:	7f 08                	jg     800e3c <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e37:	5b                   	pop    %ebx
  800e38:	5e                   	pop    %esi
  800e39:	5f                   	pop    %edi
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3c:	83 ec 0c             	sub    $0xc,%esp
  800e3f:	50                   	push   %eax
  800e40:	6a 0f                	push   $0xf
  800e42:	68 5f 28 80 00       	push   $0x80285f
  800e47:	6a 23                	push   $0x23
  800e49:	68 7c 28 80 00       	push   $0x80287c
  800e4e:	e8 e1 12 00 00       	call   802134 <_panic>

00800e53 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800e53:	f3 0f 1e fb          	endbr32 
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	57                   	push   %edi
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
  800e5d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e60:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e65:	8b 55 08             	mov    0x8(%ebp),%edx
  800e68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6b:	b8 10 00 00 00       	mov    $0x10,%eax
  800e70:	89 df                	mov    %ebx,%edi
  800e72:	89 de                	mov    %ebx,%esi
  800e74:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e76:	85 c0                	test   %eax,%eax
  800e78:	7f 08                	jg     800e82 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e82:	83 ec 0c             	sub    $0xc,%esp
  800e85:	50                   	push   %eax
  800e86:	6a 10                	push   $0x10
  800e88:	68 5f 28 80 00       	push   $0x80285f
  800e8d:	6a 23                	push   $0x23
  800e8f:	68 7c 28 80 00       	push   $0x80287c
  800e94:	e8 9b 12 00 00       	call   802134 <_panic>

00800e99 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e99:	f3 0f 1e fb          	endbr32 
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800ea3:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800eaa:	74 0a                	je     800eb6 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  800eb6:	83 ec 04             	sub    $0x4,%esp
  800eb9:	6a 07                	push   $0x7
  800ebb:	68 00 f0 bf ee       	push   $0xeebff000
  800ec0:	6a 00                	push   $0x0
  800ec2:	e8 12 fd ff ff       	call   800bd9 <sys_page_alloc>
  800ec7:	83 c4 10             	add    $0x10,%esp
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	78 2a                	js     800ef8 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  800ece:	83 ec 08             	sub    $0x8,%esp
  800ed1:	68 0c 0f 80 00       	push   $0x800f0c
  800ed6:	6a 00                	push   $0x0
  800ed8:	e8 5b fe ff ff       	call   800d38 <sys_env_set_pgfault_upcall>
  800edd:	83 c4 10             	add    $0x10,%esp
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	79 c8                	jns    800eac <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  800ee4:	83 ec 04             	sub    $0x4,%esp
  800ee7:	68 b8 28 80 00       	push   $0x8028b8
  800eec:	6a 25                	push   $0x25
  800eee:	68 f0 28 80 00       	push   $0x8028f0
  800ef3:	e8 3c 12 00 00       	call   802134 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  800ef8:	83 ec 04             	sub    $0x4,%esp
  800efb:	68 8c 28 80 00       	push   $0x80288c
  800f00:	6a 22                	push   $0x22
  800f02:	68 f0 28 80 00       	push   $0x8028f0
  800f07:	e8 28 12 00 00       	call   802134 <_panic>

00800f0c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f0c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f0d:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800f12:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f14:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  800f17:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800f1b:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800f1f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800f22:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800f24:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  800f28:	83 c4 08             	add    $0x8,%esp
	popal
  800f2b:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  800f2c:	83 c4 04             	add    $0x4,%esp
	popfl
  800f2f:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  800f30:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  800f31:	c3                   	ret    

00800f32 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f32:	f3 0f 1e fb          	endbr32 
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	05 00 00 00 30       	add    $0x30000000,%eax
  800f41:	c1 e8 0c             	shr    $0xc,%eax
}
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f46:	f3 0f 1e fb          	endbr32 
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f55:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f5a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f61:	f3 0f 1e fb          	endbr32 
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f6d:	89 c2                	mov    %eax,%edx
  800f6f:	c1 ea 16             	shr    $0x16,%edx
  800f72:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f79:	f6 c2 01             	test   $0x1,%dl
  800f7c:	74 2d                	je     800fab <fd_alloc+0x4a>
  800f7e:	89 c2                	mov    %eax,%edx
  800f80:	c1 ea 0c             	shr    $0xc,%edx
  800f83:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f8a:	f6 c2 01             	test   $0x1,%dl
  800f8d:	74 1c                	je     800fab <fd_alloc+0x4a>
  800f8f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f94:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f99:	75 d2                	jne    800f6d <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800fa4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fa9:	eb 0a                	jmp    800fb5 <fd_alloc+0x54>
			*fd_store = fd;
  800fab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fae:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fb7:	f3 0f 1e fb          	endbr32 
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fc1:	83 f8 1f             	cmp    $0x1f,%eax
  800fc4:	77 30                	ja     800ff6 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fc6:	c1 e0 0c             	shl    $0xc,%eax
  800fc9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fce:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fd4:	f6 c2 01             	test   $0x1,%dl
  800fd7:	74 24                	je     800ffd <fd_lookup+0x46>
  800fd9:	89 c2                	mov    %eax,%edx
  800fdb:	c1 ea 0c             	shr    $0xc,%edx
  800fde:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fe5:	f6 c2 01             	test   $0x1,%dl
  800fe8:	74 1a                	je     801004 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fed:	89 02                	mov    %eax,(%edx)
	return 0;
  800fef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    
		return -E_INVAL;
  800ff6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ffb:	eb f7                	jmp    800ff4 <fd_lookup+0x3d>
		return -E_INVAL;
  800ffd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801002:	eb f0                	jmp    800ff4 <fd_lookup+0x3d>
  801004:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801009:	eb e9                	jmp    800ff4 <fd_lookup+0x3d>

0080100b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80100b:	f3 0f 1e fb          	endbr32 
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801018:	ba 00 00 00 00       	mov    $0x0,%edx
  80101d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801022:	39 08                	cmp    %ecx,(%eax)
  801024:	74 38                	je     80105e <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801026:	83 c2 01             	add    $0x1,%edx
  801029:	8b 04 95 7c 29 80 00 	mov    0x80297c(,%edx,4),%eax
  801030:	85 c0                	test   %eax,%eax
  801032:	75 ee                	jne    801022 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801034:	a1 08 40 80 00       	mov    0x804008,%eax
  801039:	8b 40 48             	mov    0x48(%eax),%eax
  80103c:	83 ec 04             	sub    $0x4,%esp
  80103f:	51                   	push   %ecx
  801040:	50                   	push   %eax
  801041:	68 00 29 80 00       	push   $0x802900
  801046:	e8 42 f1 ff ff       	call   80018d <cprintf>
	*dev = 0;
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801054:	83 c4 10             	add    $0x10,%esp
  801057:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    
			*dev = devtab[i];
  80105e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801061:	89 01                	mov    %eax,(%ecx)
			return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
  801068:	eb f2                	jmp    80105c <dev_lookup+0x51>

0080106a <fd_close>:
{
  80106a:	f3 0f 1e fb          	endbr32 
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	57                   	push   %edi
  801072:	56                   	push   %esi
  801073:	53                   	push   %ebx
  801074:	83 ec 24             	sub    $0x24,%esp
  801077:	8b 75 08             	mov    0x8(%ebp),%esi
  80107a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80107d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801080:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801081:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801087:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80108a:	50                   	push   %eax
  80108b:	e8 27 ff ff ff       	call   800fb7 <fd_lookup>
  801090:	89 c3                	mov    %eax,%ebx
  801092:	83 c4 10             	add    $0x10,%esp
  801095:	85 c0                	test   %eax,%eax
  801097:	78 05                	js     80109e <fd_close+0x34>
	    || fd != fd2)
  801099:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80109c:	74 16                	je     8010b4 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80109e:	89 f8                	mov    %edi,%eax
  8010a0:	84 c0                	test   %al,%al
  8010a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a7:	0f 44 d8             	cmove  %eax,%ebx
}
  8010aa:	89 d8                	mov    %ebx,%eax
  8010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010af:	5b                   	pop    %ebx
  8010b0:	5e                   	pop    %esi
  8010b1:	5f                   	pop    %edi
  8010b2:	5d                   	pop    %ebp
  8010b3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010b4:	83 ec 08             	sub    $0x8,%esp
  8010b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010ba:	50                   	push   %eax
  8010bb:	ff 36                	pushl  (%esi)
  8010bd:	e8 49 ff ff ff       	call   80100b <dev_lookup>
  8010c2:	89 c3                	mov    %eax,%ebx
  8010c4:	83 c4 10             	add    $0x10,%esp
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	78 1a                	js     8010e5 <fd_close+0x7b>
		if (dev->dev_close)
  8010cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010ce:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	74 0b                	je     8010e5 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010da:	83 ec 0c             	sub    $0xc,%esp
  8010dd:	56                   	push   %esi
  8010de:	ff d0                	call   *%eax
  8010e0:	89 c3                	mov    %eax,%ebx
  8010e2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010e5:	83 ec 08             	sub    $0x8,%esp
  8010e8:	56                   	push   %esi
  8010e9:	6a 00                	push   $0x0
  8010eb:	e8 76 fb ff ff       	call   800c66 <sys_page_unmap>
	return r;
  8010f0:	83 c4 10             	add    $0x10,%esp
  8010f3:	eb b5                	jmp    8010aa <fd_close+0x40>

008010f5 <close>:

int
close(int fdnum)
{
  8010f5:	f3 0f 1e fb          	endbr32 
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801102:	50                   	push   %eax
  801103:	ff 75 08             	pushl  0x8(%ebp)
  801106:	e8 ac fe ff ff       	call   800fb7 <fd_lookup>
  80110b:	83 c4 10             	add    $0x10,%esp
  80110e:	85 c0                	test   %eax,%eax
  801110:	79 02                	jns    801114 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801112:	c9                   	leave  
  801113:	c3                   	ret    
		return fd_close(fd, 1);
  801114:	83 ec 08             	sub    $0x8,%esp
  801117:	6a 01                	push   $0x1
  801119:	ff 75 f4             	pushl  -0xc(%ebp)
  80111c:	e8 49 ff ff ff       	call   80106a <fd_close>
  801121:	83 c4 10             	add    $0x10,%esp
  801124:	eb ec                	jmp    801112 <close+0x1d>

00801126 <close_all>:

void
close_all(void)
{
  801126:	f3 0f 1e fb          	endbr32 
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	53                   	push   %ebx
  80112e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801131:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801136:	83 ec 0c             	sub    $0xc,%esp
  801139:	53                   	push   %ebx
  80113a:	e8 b6 ff ff ff       	call   8010f5 <close>
	for (i = 0; i < MAXFD; i++)
  80113f:	83 c3 01             	add    $0x1,%ebx
  801142:	83 c4 10             	add    $0x10,%esp
  801145:	83 fb 20             	cmp    $0x20,%ebx
  801148:	75 ec                	jne    801136 <close_all+0x10>
}
  80114a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80114d:	c9                   	leave  
  80114e:	c3                   	ret    

0080114f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80114f:	f3 0f 1e fb          	endbr32 
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	57                   	push   %edi
  801157:	56                   	push   %esi
  801158:	53                   	push   %ebx
  801159:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80115c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80115f:	50                   	push   %eax
  801160:	ff 75 08             	pushl  0x8(%ebp)
  801163:	e8 4f fe ff ff       	call   800fb7 <fd_lookup>
  801168:	89 c3                	mov    %eax,%ebx
  80116a:	83 c4 10             	add    $0x10,%esp
  80116d:	85 c0                	test   %eax,%eax
  80116f:	0f 88 81 00 00 00    	js     8011f6 <dup+0xa7>
		return r;
	close(newfdnum);
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	e8 75 ff ff ff       	call   8010f5 <close>

	newfd = INDEX2FD(newfdnum);
  801180:	8b 75 0c             	mov    0xc(%ebp),%esi
  801183:	c1 e6 0c             	shl    $0xc,%esi
  801186:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80118c:	83 c4 04             	add    $0x4,%esp
  80118f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801192:	e8 af fd ff ff       	call   800f46 <fd2data>
  801197:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801199:	89 34 24             	mov    %esi,(%esp)
  80119c:	e8 a5 fd ff ff       	call   800f46 <fd2data>
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011a6:	89 d8                	mov    %ebx,%eax
  8011a8:	c1 e8 16             	shr    $0x16,%eax
  8011ab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011b2:	a8 01                	test   $0x1,%al
  8011b4:	74 11                	je     8011c7 <dup+0x78>
  8011b6:	89 d8                	mov    %ebx,%eax
  8011b8:	c1 e8 0c             	shr    $0xc,%eax
  8011bb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011c2:	f6 c2 01             	test   $0x1,%dl
  8011c5:	75 39                	jne    801200 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011ca:	89 d0                	mov    %edx,%eax
  8011cc:	c1 e8 0c             	shr    $0xc,%eax
  8011cf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011d6:	83 ec 0c             	sub    $0xc,%esp
  8011d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8011de:	50                   	push   %eax
  8011df:	56                   	push   %esi
  8011e0:	6a 00                	push   $0x0
  8011e2:	52                   	push   %edx
  8011e3:	6a 00                	push   $0x0
  8011e5:	e8 36 fa ff ff       	call   800c20 <sys_page_map>
  8011ea:	89 c3                	mov    %eax,%ebx
  8011ec:	83 c4 20             	add    $0x20,%esp
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	78 31                	js     801224 <dup+0xd5>
		goto err;

	return newfdnum;
  8011f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011f6:	89 d8                	mov    %ebx,%eax
  8011f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5f                   	pop    %edi
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801200:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801207:	83 ec 0c             	sub    $0xc,%esp
  80120a:	25 07 0e 00 00       	and    $0xe07,%eax
  80120f:	50                   	push   %eax
  801210:	57                   	push   %edi
  801211:	6a 00                	push   $0x0
  801213:	53                   	push   %ebx
  801214:	6a 00                	push   $0x0
  801216:	e8 05 fa ff ff       	call   800c20 <sys_page_map>
  80121b:	89 c3                	mov    %eax,%ebx
  80121d:	83 c4 20             	add    $0x20,%esp
  801220:	85 c0                	test   %eax,%eax
  801222:	79 a3                	jns    8011c7 <dup+0x78>
	sys_page_unmap(0, newfd);
  801224:	83 ec 08             	sub    $0x8,%esp
  801227:	56                   	push   %esi
  801228:	6a 00                	push   $0x0
  80122a:	e8 37 fa ff ff       	call   800c66 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80122f:	83 c4 08             	add    $0x8,%esp
  801232:	57                   	push   %edi
  801233:	6a 00                	push   $0x0
  801235:	e8 2c fa ff ff       	call   800c66 <sys_page_unmap>
	return r;
  80123a:	83 c4 10             	add    $0x10,%esp
  80123d:	eb b7                	jmp    8011f6 <dup+0xa7>

0080123f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80123f:	f3 0f 1e fb          	endbr32 
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	53                   	push   %ebx
  801247:	83 ec 1c             	sub    $0x1c,%esp
  80124a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80124d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801250:	50                   	push   %eax
  801251:	53                   	push   %ebx
  801252:	e8 60 fd ff ff       	call   800fb7 <fd_lookup>
  801257:	83 c4 10             	add    $0x10,%esp
  80125a:	85 c0                	test   %eax,%eax
  80125c:	78 3f                	js     80129d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125e:	83 ec 08             	sub    $0x8,%esp
  801261:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801264:	50                   	push   %eax
  801265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801268:	ff 30                	pushl  (%eax)
  80126a:	e8 9c fd ff ff       	call   80100b <dev_lookup>
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	78 27                	js     80129d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801276:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801279:	8b 42 08             	mov    0x8(%edx),%eax
  80127c:	83 e0 03             	and    $0x3,%eax
  80127f:	83 f8 01             	cmp    $0x1,%eax
  801282:	74 1e                	je     8012a2 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801287:	8b 40 08             	mov    0x8(%eax),%eax
  80128a:	85 c0                	test   %eax,%eax
  80128c:	74 35                	je     8012c3 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80128e:	83 ec 04             	sub    $0x4,%esp
  801291:	ff 75 10             	pushl  0x10(%ebp)
  801294:	ff 75 0c             	pushl  0xc(%ebp)
  801297:	52                   	push   %edx
  801298:	ff d0                	call   *%eax
  80129a:	83 c4 10             	add    $0x10,%esp
}
  80129d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012a2:	a1 08 40 80 00       	mov    0x804008,%eax
  8012a7:	8b 40 48             	mov    0x48(%eax),%eax
  8012aa:	83 ec 04             	sub    $0x4,%esp
  8012ad:	53                   	push   %ebx
  8012ae:	50                   	push   %eax
  8012af:	68 41 29 80 00       	push   $0x802941
  8012b4:	e8 d4 ee ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c1:	eb da                	jmp    80129d <read+0x5e>
		return -E_NOT_SUPP;
  8012c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c8:	eb d3                	jmp    80129d <read+0x5e>

008012ca <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012ca:	f3 0f 1e fb          	endbr32 
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	57                   	push   %edi
  8012d2:	56                   	push   %esi
  8012d3:	53                   	push   %ebx
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012da:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e2:	eb 02                	jmp    8012e6 <readn+0x1c>
  8012e4:	01 c3                	add    %eax,%ebx
  8012e6:	39 f3                	cmp    %esi,%ebx
  8012e8:	73 21                	jae    80130b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	89 f0                	mov    %esi,%eax
  8012ef:	29 d8                	sub    %ebx,%eax
  8012f1:	50                   	push   %eax
  8012f2:	89 d8                	mov    %ebx,%eax
  8012f4:	03 45 0c             	add    0xc(%ebp),%eax
  8012f7:	50                   	push   %eax
  8012f8:	57                   	push   %edi
  8012f9:	e8 41 ff ff ff       	call   80123f <read>
		if (m < 0)
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	85 c0                	test   %eax,%eax
  801303:	78 04                	js     801309 <readn+0x3f>
			return m;
		if (m == 0)
  801305:	75 dd                	jne    8012e4 <readn+0x1a>
  801307:	eb 02                	jmp    80130b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801309:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80130b:	89 d8                	mov    %ebx,%eax
  80130d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801310:	5b                   	pop    %ebx
  801311:	5e                   	pop    %esi
  801312:	5f                   	pop    %edi
  801313:	5d                   	pop    %ebp
  801314:	c3                   	ret    

00801315 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801315:	f3 0f 1e fb          	endbr32 
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	53                   	push   %ebx
  80131d:	83 ec 1c             	sub    $0x1c,%esp
  801320:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801323:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801326:	50                   	push   %eax
  801327:	53                   	push   %ebx
  801328:	e8 8a fc ff ff       	call   800fb7 <fd_lookup>
  80132d:	83 c4 10             	add    $0x10,%esp
  801330:	85 c0                	test   %eax,%eax
  801332:	78 3a                	js     80136e <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801334:	83 ec 08             	sub    $0x8,%esp
  801337:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133a:	50                   	push   %eax
  80133b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133e:	ff 30                	pushl  (%eax)
  801340:	e8 c6 fc ff ff       	call   80100b <dev_lookup>
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	78 22                	js     80136e <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80134c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801353:	74 1e                	je     801373 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801355:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801358:	8b 52 0c             	mov    0xc(%edx),%edx
  80135b:	85 d2                	test   %edx,%edx
  80135d:	74 35                	je     801394 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80135f:	83 ec 04             	sub    $0x4,%esp
  801362:	ff 75 10             	pushl  0x10(%ebp)
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	50                   	push   %eax
  801369:	ff d2                	call   *%edx
  80136b:	83 c4 10             	add    $0x10,%esp
}
  80136e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801371:	c9                   	leave  
  801372:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801373:	a1 08 40 80 00       	mov    0x804008,%eax
  801378:	8b 40 48             	mov    0x48(%eax),%eax
  80137b:	83 ec 04             	sub    $0x4,%esp
  80137e:	53                   	push   %ebx
  80137f:	50                   	push   %eax
  801380:	68 5d 29 80 00       	push   $0x80295d
  801385:	e8 03 ee ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801392:	eb da                	jmp    80136e <write+0x59>
		return -E_NOT_SUPP;
  801394:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801399:	eb d3                	jmp    80136e <write+0x59>

0080139b <seek>:

int
seek(int fdnum, off_t offset)
{
  80139b:	f3 0f 1e fb          	endbr32 
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a8:	50                   	push   %eax
  8013a9:	ff 75 08             	pushl  0x8(%ebp)
  8013ac:	e8 06 fc ff ff       	call   800fb7 <fd_lookup>
  8013b1:	83 c4 10             	add    $0x10,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	78 0e                	js     8013c6 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8013b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013be:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013c8:	f3 0f 1e fb          	endbr32 
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	53                   	push   %ebx
  8013d0:	83 ec 1c             	sub    $0x1c,%esp
  8013d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d9:	50                   	push   %eax
  8013da:	53                   	push   %ebx
  8013db:	e8 d7 fb ff ff       	call   800fb7 <fd_lookup>
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 37                	js     80141e <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ed:	50                   	push   %eax
  8013ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f1:	ff 30                	pushl  (%eax)
  8013f3:	e8 13 fc ff ff       	call   80100b <dev_lookup>
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	78 1f                	js     80141e <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801402:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801406:	74 1b                	je     801423 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801408:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140b:	8b 52 18             	mov    0x18(%edx),%edx
  80140e:	85 d2                	test   %edx,%edx
  801410:	74 32                	je     801444 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801412:	83 ec 08             	sub    $0x8,%esp
  801415:	ff 75 0c             	pushl  0xc(%ebp)
  801418:	50                   	push   %eax
  801419:	ff d2                	call   *%edx
  80141b:	83 c4 10             	add    $0x10,%esp
}
  80141e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801421:	c9                   	leave  
  801422:	c3                   	ret    
			thisenv->env_id, fdnum);
  801423:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801428:	8b 40 48             	mov    0x48(%eax),%eax
  80142b:	83 ec 04             	sub    $0x4,%esp
  80142e:	53                   	push   %ebx
  80142f:	50                   	push   %eax
  801430:	68 20 29 80 00       	push   $0x802920
  801435:	e8 53 ed ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801442:	eb da                	jmp    80141e <ftruncate+0x56>
		return -E_NOT_SUPP;
  801444:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801449:	eb d3                	jmp    80141e <ftruncate+0x56>

0080144b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80144b:	f3 0f 1e fb          	endbr32 
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	53                   	push   %ebx
  801453:	83 ec 1c             	sub    $0x1c,%esp
  801456:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801459:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145c:	50                   	push   %eax
  80145d:	ff 75 08             	pushl  0x8(%ebp)
  801460:	e8 52 fb ff ff       	call   800fb7 <fd_lookup>
  801465:	83 c4 10             	add    $0x10,%esp
  801468:	85 c0                	test   %eax,%eax
  80146a:	78 4b                	js     8014b7 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146c:	83 ec 08             	sub    $0x8,%esp
  80146f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801472:	50                   	push   %eax
  801473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801476:	ff 30                	pushl  (%eax)
  801478:	e8 8e fb ff ff       	call   80100b <dev_lookup>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	78 33                	js     8014b7 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801487:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80148b:	74 2f                	je     8014bc <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80148d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801490:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801497:	00 00 00 
	stat->st_isdir = 0;
  80149a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014a1:	00 00 00 
	stat->st_dev = dev;
  8014a4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	53                   	push   %ebx
  8014ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b1:	ff 50 14             	call   *0x14(%eax)
  8014b4:	83 c4 10             	add    $0x10,%esp
}
  8014b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    
		return -E_NOT_SUPP;
  8014bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c1:	eb f4                	jmp    8014b7 <fstat+0x6c>

008014c3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014c3:	f3 0f 1e fb          	endbr32 
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	56                   	push   %esi
  8014cb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014cc:	83 ec 08             	sub    $0x8,%esp
  8014cf:	6a 00                	push   $0x0
  8014d1:	ff 75 08             	pushl  0x8(%ebp)
  8014d4:	e8 fb 01 00 00       	call   8016d4 <open>
  8014d9:	89 c3                	mov    %eax,%ebx
  8014db:	83 c4 10             	add    $0x10,%esp
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	78 1b                	js     8014fd <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014e2:	83 ec 08             	sub    $0x8,%esp
  8014e5:	ff 75 0c             	pushl  0xc(%ebp)
  8014e8:	50                   	push   %eax
  8014e9:	e8 5d ff ff ff       	call   80144b <fstat>
  8014ee:	89 c6                	mov    %eax,%esi
	close(fd);
  8014f0:	89 1c 24             	mov    %ebx,(%esp)
  8014f3:	e8 fd fb ff ff       	call   8010f5 <close>
	return r;
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	89 f3                	mov    %esi,%ebx
}
  8014fd:	89 d8                	mov    %ebx,%eax
  8014ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801502:	5b                   	pop    %ebx
  801503:	5e                   	pop    %esi
  801504:	5d                   	pop    %ebp
  801505:	c3                   	ret    

00801506 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	56                   	push   %esi
  80150a:	53                   	push   %ebx
  80150b:	89 c6                	mov    %eax,%esi
  80150d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80150f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801516:	74 27                	je     80153f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801518:	6a 07                	push   $0x7
  80151a:	68 00 50 80 00       	push   $0x805000
  80151f:	56                   	push   %esi
  801520:	ff 35 00 40 80 00    	pushl  0x804000
  801526:	e8 d8 0c 00 00       	call   802203 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80152b:	83 c4 0c             	add    $0xc,%esp
  80152e:	6a 00                	push   $0x0
  801530:	53                   	push   %ebx
  801531:	6a 00                	push   $0x0
  801533:	e8 46 0c 00 00       	call   80217e <ipc_recv>
}
  801538:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153b:	5b                   	pop    %ebx
  80153c:	5e                   	pop    %esi
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80153f:	83 ec 0c             	sub    $0xc,%esp
  801542:	6a 01                	push   $0x1
  801544:	e8 12 0d 00 00       	call   80225b <ipc_find_env>
  801549:	a3 00 40 80 00       	mov    %eax,0x804000
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	eb c5                	jmp    801518 <fsipc+0x12>

00801553 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801553:	f3 0f 1e fb          	endbr32 
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8b 40 0c             	mov    0xc(%eax),%eax
  801563:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801570:	ba 00 00 00 00       	mov    $0x0,%edx
  801575:	b8 02 00 00 00       	mov    $0x2,%eax
  80157a:	e8 87 ff ff ff       	call   801506 <fsipc>
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <devfile_flush>:
{
  801581:	f3 0f 1e fb          	endbr32 
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8b 40 0c             	mov    0xc(%eax),%eax
  801591:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801596:	ba 00 00 00 00       	mov    $0x0,%edx
  80159b:	b8 06 00 00 00       	mov    $0x6,%eax
  8015a0:	e8 61 ff ff ff       	call   801506 <fsipc>
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <devfile_stat>:
{
  8015a7:	f3 0f 1e fb          	endbr32 
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	53                   	push   %ebx
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bb:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c5:	b8 05 00 00 00       	mov    $0x5,%eax
  8015ca:	e8 37 ff ff ff       	call   801506 <fsipc>
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 2c                	js     8015ff <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015d3:	83 ec 08             	sub    $0x8,%esp
  8015d6:	68 00 50 80 00       	push   $0x805000
  8015db:	53                   	push   %ebx
  8015dc:	e8 b6 f1 ff ff       	call   800797 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015e1:	a1 80 50 80 00       	mov    0x805080,%eax
  8015e6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015ec:	a1 84 50 80 00       	mov    0x805084,%eax
  8015f1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015f7:	83 c4 10             	add    $0x10,%esp
  8015fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <devfile_write>:
{
  801604:	f3 0f 1e fb          	endbr32 
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	83 ec 0c             	sub    $0xc,%esp
  80160e:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801611:	8b 55 08             	mov    0x8(%ebp),%edx
  801614:	8b 52 0c             	mov    0xc(%edx),%edx
  801617:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80161d:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801622:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801627:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80162a:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80162f:	50                   	push   %eax
  801630:	ff 75 0c             	pushl  0xc(%ebp)
  801633:	68 08 50 80 00       	push   $0x805008
  801638:	e8 10 f3 ff ff       	call   80094d <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80163d:	ba 00 00 00 00       	mov    $0x0,%edx
  801642:	b8 04 00 00 00       	mov    $0x4,%eax
  801647:	e8 ba fe ff ff       	call   801506 <fsipc>
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <devfile_read>:
{
  80164e:	f3 0f 1e fb          	endbr32 
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	56                   	push   %esi
  801656:	53                   	push   %ebx
  801657:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	8b 40 0c             	mov    0xc(%eax),%eax
  801660:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801665:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80166b:	ba 00 00 00 00       	mov    $0x0,%edx
  801670:	b8 03 00 00 00       	mov    $0x3,%eax
  801675:	e8 8c fe ff ff       	call   801506 <fsipc>
  80167a:	89 c3                	mov    %eax,%ebx
  80167c:	85 c0                	test   %eax,%eax
  80167e:	78 1f                	js     80169f <devfile_read+0x51>
	assert(r <= n);
  801680:	39 f0                	cmp    %esi,%eax
  801682:	77 24                	ja     8016a8 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801684:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801689:	7f 33                	jg     8016be <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	50                   	push   %eax
  80168f:	68 00 50 80 00       	push   $0x805000
  801694:	ff 75 0c             	pushl  0xc(%ebp)
  801697:	e8 b1 f2 ff ff       	call   80094d <memmove>
	return r;
  80169c:	83 c4 10             	add    $0x10,%esp
}
  80169f:	89 d8                	mov    %ebx,%eax
  8016a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a4:	5b                   	pop    %ebx
  8016a5:	5e                   	pop    %esi
  8016a6:	5d                   	pop    %ebp
  8016a7:	c3                   	ret    
	assert(r <= n);
  8016a8:	68 90 29 80 00       	push   $0x802990
  8016ad:	68 97 29 80 00       	push   $0x802997
  8016b2:	6a 7c                	push   $0x7c
  8016b4:	68 ac 29 80 00       	push   $0x8029ac
  8016b9:	e8 76 0a 00 00       	call   802134 <_panic>
	assert(r <= PGSIZE);
  8016be:	68 b7 29 80 00       	push   $0x8029b7
  8016c3:	68 97 29 80 00       	push   $0x802997
  8016c8:	6a 7d                	push   $0x7d
  8016ca:	68 ac 29 80 00       	push   $0x8029ac
  8016cf:	e8 60 0a 00 00       	call   802134 <_panic>

008016d4 <open>:
{
  8016d4:	f3 0f 1e fb          	endbr32 
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	56                   	push   %esi
  8016dc:	53                   	push   %ebx
  8016dd:	83 ec 1c             	sub    $0x1c,%esp
  8016e0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016e3:	56                   	push   %esi
  8016e4:	e8 6b f0 ff ff       	call   800754 <strlen>
  8016e9:	83 c4 10             	add    $0x10,%esp
  8016ec:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016f1:	7f 6c                	jg     80175f <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016f3:	83 ec 0c             	sub    $0xc,%esp
  8016f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f9:	50                   	push   %eax
  8016fa:	e8 62 f8 ff ff       	call   800f61 <fd_alloc>
  8016ff:	89 c3                	mov    %eax,%ebx
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	85 c0                	test   %eax,%eax
  801706:	78 3c                	js     801744 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801708:	83 ec 08             	sub    $0x8,%esp
  80170b:	56                   	push   %esi
  80170c:	68 00 50 80 00       	push   $0x805000
  801711:	e8 81 f0 ff ff       	call   800797 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80171e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801721:	b8 01 00 00 00       	mov    $0x1,%eax
  801726:	e8 db fd ff ff       	call   801506 <fsipc>
  80172b:	89 c3                	mov    %eax,%ebx
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	85 c0                	test   %eax,%eax
  801732:	78 19                	js     80174d <open+0x79>
	return fd2num(fd);
  801734:	83 ec 0c             	sub    $0xc,%esp
  801737:	ff 75 f4             	pushl  -0xc(%ebp)
  80173a:	e8 f3 f7 ff ff       	call   800f32 <fd2num>
  80173f:	89 c3                	mov    %eax,%ebx
  801741:	83 c4 10             	add    $0x10,%esp
}
  801744:	89 d8                	mov    %ebx,%eax
  801746:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801749:	5b                   	pop    %ebx
  80174a:	5e                   	pop    %esi
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    
		fd_close(fd, 0);
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	6a 00                	push   $0x0
  801752:	ff 75 f4             	pushl  -0xc(%ebp)
  801755:	e8 10 f9 ff ff       	call   80106a <fd_close>
		return r;
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	eb e5                	jmp    801744 <open+0x70>
		return -E_BAD_PATH;
  80175f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801764:	eb de                	jmp    801744 <open+0x70>

00801766 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801766:	f3 0f 1e fb          	endbr32 
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801770:	ba 00 00 00 00       	mov    $0x0,%edx
  801775:	b8 08 00 00 00       	mov    $0x8,%eax
  80177a:	e8 87 fd ff ff       	call   801506 <fsipc>
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801781:	f3 0f 1e fb          	endbr32 
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80178b:	68 c3 29 80 00       	push   $0x8029c3
  801790:	ff 75 0c             	pushl  0xc(%ebp)
  801793:	e8 ff ef ff ff       	call   800797 <strcpy>
	return 0;
}
  801798:	b8 00 00 00 00       	mov    $0x0,%eax
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <devsock_close>:
{
  80179f:	f3 0f 1e fb          	endbr32 
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 10             	sub    $0x10,%esp
  8017aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017ad:	53                   	push   %ebx
  8017ae:	e8 e5 0a 00 00       	call   802298 <pageref>
  8017b3:	89 c2                	mov    %eax,%edx
  8017b5:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8017bd:	83 fa 01             	cmp    $0x1,%edx
  8017c0:	74 05                	je     8017c7 <devsock_close+0x28>
}
  8017c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8017c7:	83 ec 0c             	sub    $0xc,%esp
  8017ca:	ff 73 0c             	pushl  0xc(%ebx)
  8017cd:	e8 e3 02 00 00       	call   801ab5 <nsipc_close>
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	eb eb                	jmp    8017c2 <devsock_close+0x23>

008017d7 <devsock_write>:
{
  8017d7:	f3 0f 1e fb          	endbr32 
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8017e1:	6a 00                	push   $0x0
  8017e3:	ff 75 10             	pushl  0x10(%ebp)
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	ff 70 0c             	pushl  0xc(%eax)
  8017ef:	e8 b5 03 00 00       	call   801ba9 <nsipc_send>
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <devsock_read>:
{
  8017f6:	f3 0f 1e fb          	endbr32 
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801800:	6a 00                	push   $0x0
  801802:	ff 75 10             	pushl  0x10(%ebp)
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	ff 70 0c             	pushl  0xc(%eax)
  80180e:	e8 1f 03 00 00       	call   801b32 <nsipc_recv>
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <fd2sockid>:
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80181b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80181e:	52                   	push   %edx
  80181f:	50                   	push   %eax
  801820:	e8 92 f7 ff ff       	call   800fb7 <fd_lookup>
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	85 c0                	test   %eax,%eax
  80182a:	78 10                	js     80183c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80182c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182f:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801835:	39 08                	cmp    %ecx,(%eax)
  801837:	75 05                	jne    80183e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801839:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    
		return -E_NOT_SUPP;
  80183e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801843:	eb f7                	jmp    80183c <fd2sockid+0x27>

00801845 <alloc_sockfd>:
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	56                   	push   %esi
  801849:	53                   	push   %ebx
  80184a:	83 ec 1c             	sub    $0x1c,%esp
  80184d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80184f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801852:	50                   	push   %eax
  801853:	e8 09 f7 ff ff       	call   800f61 <fd_alloc>
  801858:	89 c3                	mov    %eax,%ebx
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	78 43                	js     8018a4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801861:	83 ec 04             	sub    $0x4,%esp
  801864:	68 07 04 00 00       	push   $0x407
  801869:	ff 75 f4             	pushl  -0xc(%ebp)
  80186c:	6a 00                	push   $0x0
  80186e:	e8 66 f3 ff ff       	call   800bd9 <sys_page_alloc>
  801873:	89 c3                	mov    %eax,%ebx
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	85 c0                	test   %eax,%eax
  80187a:	78 28                	js     8018a4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80187c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801885:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801891:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801894:	83 ec 0c             	sub    $0xc,%esp
  801897:	50                   	push   %eax
  801898:	e8 95 f6 ff ff       	call   800f32 <fd2num>
  80189d:	89 c3                	mov    %eax,%ebx
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	eb 0c                	jmp    8018b0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018a4:	83 ec 0c             	sub    $0xc,%esp
  8018a7:	56                   	push   %esi
  8018a8:	e8 08 02 00 00       	call   801ab5 <nsipc_close>
		return r;
  8018ad:	83 c4 10             	add    $0x10,%esp
}
  8018b0:	89 d8                	mov    %ebx,%eax
  8018b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b5:	5b                   	pop    %ebx
  8018b6:	5e                   	pop    %esi
  8018b7:	5d                   	pop    %ebp
  8018b8:	c3                   	ret    

008018b9 <accept>:
{
  8018b9:	f3 0f 1e fb          	endbr32 
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	e8 4a ff ff ff       	call   801815 <fd2sockid>
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 1b                	js     8018ea <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018cf:	83 ec 04             	sub    $0x4,%esp
  8018d2:	ff 75 10             	pushl  0x10(%ebp)
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	50                   	push   %eax
  8018d9:	e8 22 01 00 00       	call   801a00 <nsipc_accept>
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	78 05                	js     8018ea <accept+0x31>
	return alloc_sockfd(r);
  8018e5:	e8 5b ff ff ff       	call   801845 <alloc_sockfd>
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <bind>:
{
  8018ec:	f3 0f 1e fb          	endbr32 
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	e8 17 ff ff ff       	call   801815 <fd2sockid>
  8018fe:	85 c0                	test   %eax,%eax
  801900:	78 12                	js     801914 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801902:	83 ec 04             	sub    $0x4,%esp
  801905:	ff 75 10             	pushl  0x10(%ebp)
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	50                   	push   %eax
  80190c:	e8 45 01 00 00       	call   801a56 <nsipc_bind>
  801911:	83 c4 10             	add    $0x10,%esp
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <shutdown>:
{
  801916:	f3 0f 1e fb          	endbr32 
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	e8 ed fe ff ff       	call   801815 <fd2sockid>
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 0f                	js     80193b <shutdown+0x25>
	return nsipc_shutdown(r, how);
  80192c:	83 ec 08             	sub    $0x8,%esp
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	50                   	push   %eax
  801933:	e8 57 01 00 00       	call   801a8f <nsipc_shutdown>
  801938:	83 c4 10             	add    $0x10,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <connect>:
{
  80193d:	f3 0f 1e fb          	endbr32 
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	e8 c6 fe ff ff       	call   801815 <fd2sockid>
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 12                	js     801965 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801953:	83 ec 04             	sub    $0x4,%esp
  801956:	ff 75 10             	pushl  0x10(%ebp)
  801959:	ff 75 0c             	pushl  0xc(%ebp)
  80195c:	50                   	push   %eax
  80195d:	e8 71 01 00 00       	call   801ad3 <nsipc_connect>
  801962:	83 c4 10             	add    $0x10,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <listen>:
{
  801967:	f3 0f 1e fb          	endbr32 
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	e8 9c fe ff ff       	call   801815 <fd2sockid>
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 0f                	js     80198c <listen+0x25>
	return nsipc_listen(r, backlog);
  80197d:	83 ec 08             	sub    $0x8,%esp
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	50                   	push   %eax
  801984:	e8 83 01 00 00       	call   801b0c <nsipc_listen>
  801989:	83 c4 10             	add    $0x10,%esp
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <socket>:

int
socket(int domain, int type, int protocol)
{
  80198e:	f3 0f 1e fb          	endbr32 
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801998:	ff 75 10             	pushl  0x10(%ebp)
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	ff 75 08             	pushl  0x8(%ebp)
  8019a1:	e8 65 02 00 00       	call   801c0b <nsipc_socket>
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	78 05                	js     8019b2 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8019ad:	e8 93 fe ff ff       	call   801845 <alloc_sockfd>
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	53                   	push   %ebx
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019bd:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019c4:	74 26                	je     8019ec <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019c6:	6a 07                	push   $0x7
  8019c8:	68 00 60 80 00       	push   $0x806000
  8019cd:	53                   	push   %ebx
  8019ce:	ff 35 04 40 80 00    	pushl  0x804004
  8019d4:	e8 2a 08 00 00       	call   802203 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019d9:	83 c4 0c             	add    $0xc,%esp
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	e8 97 07 00 00       	call   80217e <ipc_recv>
}
  8019e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8019ec:	83 ec 0c             	sub    $0xc,%esp
  8019ef:	6a 02                	push   $0x2
  8019f1:	e8 65 08 00 00       	call   80225b <ipc_find_env>
  8019f6:	a3 04 40 80 00       	mov    %eax,0x804004
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	eb c6                	jmp    8019c6 <nsipc+0x12>

00801a00 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a00:	f3 0f 1e fb          	endbr32 
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	56                   	push   %esi
  801a08:	53                   	push   %ebx
  801a09:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a14:	8b 06                	mov    (%esi),%eax
  801a16:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a1b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a20:	e8 8f ff ff ff       	call   8019b4 <nsipc>
  801a25:	89 c3                	mov    %eax,%ebx
  801a27:	85 c0                	test   %eax,%eax
  801a29:	79 09                	jns    801a34 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a2b:	89 d8                	mov    %ebx,%eax
  801a2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a30:	5b                   	pop    %ebx
  801a31:	5e                   	pop    %esi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	ff 35 10 60 80 00    	pushl  0x806010
  801a3d:	68 00 60 80 00       	push   $0x806000
  801a42:	ff 75 0c             	pushl  0xc(%ebp)
  801a45:	e8 03 ef ff ff       	call   80094d <memmove>
		*addrlen = ret->ret_addrlen;
  801a4a:	a1 10 60 80 00       	mov    0x806010,%eax
  801a4f:	89 06                	mov    %eax,(%esi)
  801a51:	83 c4 10             	add    $0x10,%esp
	return r;
  801a54:	eb d5                	jmp    801a2b <nsipc_accept+0x2b>

00801a56 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a56:	f3 0f 1e fb          	endbr32 
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	53                   	push   %ebx
  801a5e:	83 ec 08             	sub    $0x8,%esp
  801a61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a6c:	53                   	push   %ebx
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	68 04 60 80 00       	push   $0x806004
  801a75:	e8 d3 ee ff ff       	call   80094d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a7a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a80:	b8 02 00 00 00       	mov    $0x2,%eax
  801a85:	e8 2a ff ff ff       	call   8019b4 <nsipc>
}
  801a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a8f:	f3 0f 1e fb          	endbr32 
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801aa9:	b8 03 00 00 00       	mov    $0x3,%eax
  801aae:	e8 01 ff ff ff       	call   8019b4 <nsipc>
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <nsipc_close>:

int
nsipc_close(int s)
{
  801ab5:	f3 0f 1e fb          	endbr32 
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ac7:	b8 04 00 00 00       	mov    $0x4,%eax
  801acc:	e8 e3 fe ff ff       	call   8019b4 <nsipc>
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ad3:	f3 0f 1e fb          	endbr32 
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	53                   	push   %ebx
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ae9:	53                   	push   %ebx
  801aea:	ff 75 0c             	pushl  0xc(%ebp)
  801aed:	68 04 60 80 00       	push   $0x806004
  801af2:	e8 56 ee ff ff       	call   80094d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801af7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801afd:	b8 05 00 00 00       	mov    $0x5,%eax
  801b02:	e8 ad fe ff ff       	call   8019b4 <nsipc>
}
  801b07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b0c:	f3 0f 1e fb          	endbr32 
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b21:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b26:	b8 06 00 00 00       	mov    $0x6,%eax
  801b2b:	e8 84 fe ff ff       	call   8019b4 <nsipc>
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b32:	f3 0f 1e fb          	endbr32 
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	56                   	push   %esi
  801b3a:	53                   	push   %ebx
  801b3b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b46:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b54:	b8 07 00 00 00       	mov    $0x7,%eax
  801b59:	e8 56 fe ff ff       	call   8019b4 <nsipc>
  801b5e:	89 c3                	mov    %eax,%ebx
  801b60:	85 c0                	test   %eax,%eax
  801b62:	78 26                	js     801b8a <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801b64:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801b6a:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801b6f:	0f 4e c6             	cmovle %esi,%eax
  801b72:	39 c3                	cmp    %eax,%ebx
  801b74:	7f 1d                	jg     801b93 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	53                   	push   %ebx
  801b7a:	68 00 60 80 00       	push   $0x806000
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	e8 c6 ed ff ff       	call   80094d <memmove>
  801b87:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b8a:	89 d8                	mov    %ebx,%eax
  801b8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8f:	5b                   	pop    %ebx
  801b90:	5e                   	pop    %esi
  801b91:	5d                   	pop    %ebp
  801b92:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b93:	68 cf 29 80 00       	push   $0x8029cf
  801b98:	68 97 29 80 00       	push   $0x802997
  801b9d:	6a 62                	push   $0x62
  801b9f:	68 e4 29 80 00       	push   $0x8029e4
  801ba4:	e8 8b 05 00 00       	call   802134 <_panic>

00801ba9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ba9:	f3 0f 1e fb          	endbr32 
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	53                   	push   %ebx
  801bb1:	83 ec 04             	sub    $0x4,%esp
  801bb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bbf:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bc5:	7f 2e                	jg     801bf5 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	53                   	push   %ebx
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	68 0c 60 80 00       	push   $0x80600c
  801bd3:	e8 75 ed ff ff       	call   80094d <memmove>
	nsipcbuf.send.req_size = size;
  801bd8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bde:	8b 45 14             	mov    0x14(%ebp),%eax
  801be1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801be6:	b8 08 00 00 00       	mov    $0x8,%eax
  801beb:	e8 c4 fd ff ff       	call   8019b4 <nsipc>
}
  801bf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    
	assert(size < 1600);
  801bf5:	68 f0 29 80 00       	push   $0x8029f0
  801bfa:	68 97 29 80 00       	push   $0x802997
  801bff:	6a 6d                	push   $0x6d
  801c01:	68 e4 29 80 00       	push   $0x8029e4
  801c06:	e8 29 05 00 00       	call   802134 <_panic>

00801c0b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c0b:	f3 0f 1e fb          	endbr32 
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c20:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c25:	8b 45 10             	mov    0x10(%ebp),%eax
  801c28:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c2d:	b8 09 00 00 00       	mov    $0x9,%eax
  801c32:	e8 7d fd ff ff       	call   8019b4 <nsipc>
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c39:	f3 0f 1e fb          	endbr32 
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	56                   	push   %esi
  801c41:	53                   	push   %ebx
  801c42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c45:	83 ec 0c             	sub    $0xc,%esp
  801c48:	ff 75 08             	pushl  0x8(%ebp)
  801c4b:	e8 f6 f2 ff ff       	call   800f46 <fd2data>
  801c50:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c52:	83 c4 08             	add    $0x8,%esp
  801c55:	68 fc 29 80 00       	push   $0x8029fc
  801c5a:	53                   	push   %ebx
  801c5b:	e8 37 eb ff ff       	call   800797 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c60:	8b 46 04             	mov    0x4(%esi),%eax
  801c63:	2b 06                	sub    (%esi),%eax
  801c65:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c6b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c72:	00 00 00 
	stat->st_dev = &devpipe;
  801c75:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c7c:	30 80 00 
	return 0;
}
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c87:	5b                   	pop    %ebx
  801c88:	5e                   	pop    %esi
  801c89:	5d                   	pop    %ebp
  801c8a:	c3                   	ret    

00801c8b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c8b:	f3 0f 1e fb          	endbr32 
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	53                   	push   %ebx
  801c93:	83 ec 0c             	sub    $0xc,%esp
  801c96:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c99:	53                   	push   %ebx
  801c9a:	6a 00                	push   $0x0
  801c9c:	e8 c5 ef ff ff       	call   800c66 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ca1:	89 1c 24             	mov    %ebx,(%esp)
  801ca4:	e8 9d f2 ff ff       	call   800f46 <fd2data>
  801ca9:	83 c4 08             	add    $0x8,%esp
  801cac:	50                   	push   %eax
  801cad:	6a 00                	push   $0x0
  801caf:	e8 b2 ef ff ff       	call   800c66 <sys_page_unmap>
}
  801cb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <_pipeisclosed>:
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	57                   	push   %edi
  801cbd:	56                   	push   %esi
  801cbe:	53                   	push   %ebx
  801cbf:	83 ec 1c             	sub    $0x1c,%esp
  801cc2:	89 c7                	mov    %eax,%edi
  801cc4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cc6:	a1 08 40 80 00       	mov    0x804008,%eax
  801ccb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cce:	83 ec 0c             	sub    $0xc,%esp
  801cd1:	57                   	push   %edi
  801cd2:	e8 c1 05 00 00       	call   802298 <pageref>
  801cd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cda:	89 34 24             	mov    %esi,(%esp)
  801cdd:	e8 b6 05 00 00       	call   802298 <pageref>
		nn = thisenv->env_runs;
  801ce2:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ce8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ceb:	83 c4 10             	add    $0x10,%esp
  801cee:	39 cb                	cmp    %ecx,%ebx
  801cf0:	74 1b                	je     801d0d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cf2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf5:	75 cf                	jne    801cc6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cf7:	8b 42 58             	mov    0x58(%edx),%eax
  801cfa:	6a 01                	push   $0x1
  801cfc:	50                   	push   %eax
  801cfd:	53                   	push   %ebx
  801cfe:	68 03 2a 80 00       	push   $0x802a03
  801d03:	e8 85 e4 ff ff       	call   80018d <cprintf>
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	eb b9                	jmp    801cc6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d0d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d10:	0f 94 c0             	sete   %al
  801d13:	0f b6 c0             	movzbl %al,%eax
}
  801d16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d19:	5b                   	pop    %ebx
  801d1a:	5e                   	pop    %esi
  801d1b:	5f                   	pop    %edi
  801d1c:	5d                   	pop    %ebp
  801d1d:	c3                   	ret    

00801d1e <devpipe_write>:
{
  801d1e:	f3 0f 1e fb          	endbr32 
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	57                   	push   %edi
  801d26:	56                   	push   %esi
  801d27:	53                   	push   %ebx
  801d28:	83 ec 28             	sub    $0x28,%esp
  801d2b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d2e:	56                   	push   %esi
  801d2f:	e8 12 f2 ff ff       	call   800f46 <fd2data>
  801d34:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d36:	83 c4 10             	add    $0x10,%esp
  801d39:	bf 00 00 00 00       	mov    $0x0,%edi
  801d3e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d41:	74 4f                	je     801d92 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d43:	8b 43 04             	mov    0x4(%ebx),%eax
  801d46:	8b 0b                	mov    (%ebx),%ecx
  801d48:	8d 51 20             	lea    0x20(%ecx),%edx
  801d4b:	39 d0                	cmp    %edx,%eax
  801d4d:	72 14                	jb     801d63 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d4f:	89 da                	mov    %ebx,%edx
  801d51:	89 f0                	mov    %esi,%eax
  801d53:	e8 61 ff ff ff       	call   801cb9 <_pipeisclosed>
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	75 3b                	jne    801d97 <devpipe_write+0x79>
			sys_yield();
  801d5c:	e8 55 ee ff ff       	call   800bb6 <sys_yield>
  801d61:	eb e0                	jmp    801d43 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d66:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d6a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d6d:	89 c2                	mov    %eax,%edx
  801d6f:	c1 fa 1f             	sar    $0x1f,%edx
  801d72:	89 d1                	mov    %edx,%ecx
  801d74:	c1 e9 1b             	shr    $0x1b,%ecx
  801d77:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d7a:	83 e2 1f             	and    $0x1f,%edx
  801d7d:	29 ca                	sub    %ecx,%edx
  801d7f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d83:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d87:	83 c0 01             	add    $0x1,%eax
  801d8a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d8d:	83 c7 01             	add    $0x1,%edi
  801d90:	eb ac                	jmp    801d3e <devpipe_write+0x20>
	return i;
  801d92:	8b 45 10             	mov    0x10(%ebp),%eax
  801d95:	eb 05                	jmp    801d9c <devpipe_write+0x7e>
				return 0;
  801d97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9f:	5b                   	pop    %ebx
  801da0:	5e                   	pop    %esi
  801da1:	5f                   	pop    %edi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <devpipe_read>:
{
  801da4:	f3 0f 1e fb          	endbr32 
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	57                   	push   %edi
  801dac:	56                   	push   %esi
  801dad:	53                   	push   %ebx
  801dae:	83 ec 18             	sub    $0x18,%esp
  801db1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801db4:	57                   	push   %edi
  801db5:	e8 8c f1 ff ff       	call   800f46 <fd2data>
  801dba:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	be 00 00 00 00       	mov    $0x0,%esi
  801dc4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc7:	75 14                	jne    801ddd <devpipe_read+0x39>
	return i;
  801dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcc:	eb 02                	jmp    801dd0 <devpipe_read+0x2c>
				return i;
  801dce:	89 f0                	mov    %esi,%eax
}
  801dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd3:	5b                   	pop    %ebx
  801dd4:	5e                   	pop    %esi
  801dd5:	5f                   	pop    %edi
  801dd6:	5d                   	pop    %ebp
  801dd7:	c3                   	ret    
			sys_yield();
  801dd8:	e8 d9 ed ff ff       	call   800bb6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ddd:	8b 03                	mov    (%ebx),%eax
  801ddf:	3b 43 04             	cmp    0x4(%ebx),%eax
  801de2:	75 18                	jne    801dfc <devpipe_read+0x58>
			if (i > 0)
  801de4:	85 f6                	test   %esi,%esi
  801de6:	75 e6                	jne    801dce <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801de8:	89 da                	mov    %ebx,%edx
  801dea:	89 f8                	mov    %edi,%eax
  801dec:	e8 c8 fe ff ff       	call   801cb9 <_pipeisclosed>
  801df1:	85 c0                	test   %eax,%eax
  801df3:	74 e3                	je     801dd8 <devpipe_read+0x34>
				return 0;
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfa:	eb d4                	jmp    801dd0 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dfc:	99                   	cltd   
  801dfd:	c1 ea 1b             	shr    $0x1b,%edx
  801e00:	01 d0                	add    %edx,%eax
  801e02:	83 e0 1f             	and    $0x1f,%eax
  801e05:	29 d0                	sub    %edx,%eax
  801e07:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e0f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e12:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e15:	83 c6 01             	add    $0x1,%esi
  801e18:	eb aa                	jmp    801dc4 <devpipe_read+0x20>

00801e1a <pipe>:
{
  801e1a:	f3 0f 1e fb          	endbr32 
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	56                   	push   %esi
  801e22:	53                   	push   %ebx
  801e23:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e29:	50                   	push   %eax
  801e2a:	e8 32 f1 ff ff       	call   800f61 <fd_alloc>
  801e2f:	89 c3                	mov    %eax,%ebx
  801e31:	83 c4 10             	add    $0x10,%esp
  801e34:	85 c0                	test   %eax,%eax
  801e36:	0f 88 23 01 00 00    	js     801f5f <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3c:	83 ec 04             	sub    $0x4,%esp
  801e3f:	68 07 04 00 00       	push   $0x407
  801e44:	ff 75 f4             	pushl  -0xc(%ebp)
  801e47:	6a 00                	push   $0x0
  801e49:	e8 8b ed ff ff       	call   800bd9 <sys_page_alloc>
  801e4e:	89 c3                	mov    %eax,%ebx
  801e50:	83 c4 10             	add    $0x10,%esp
  801e53:	85 c0                	test   %eax,%eax
  801e55:	0f 88 04 01 00 00    	js     801f5f <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e5b:	83 ec 0c             	sub    $0xc,%esp
  801e5e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e61:	50                   	push   %eax
  801e62:	e8 fa f0 ff ff       	call   800f61 <fd_alloc>
  801e67:	89 c3                	mov    %eax,%ebx
  801e69:	83 c4 10             	add    $0x10,%esp
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	0f 88 db 00 00 00    	js     801f4f <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e74:	83 ec 04             	sub    $0x4,%esp
  801e77:	68 07 04 00 00       	push   $0x407
  801e7c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7f:	6a 00                	push   $0x0
  801e81:	e8 53 ed ff ff       	call   800bd9 <sys_page_alloc>
  801e86:	89 c3                	mov    %eax,%ebx
  801e88:	83 c4 10             	add    $0x10,%esp
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	0f 88 bc 00 00 00    	js     801f4f <pipe+0x135>
	va = fd2data(fd0);
  801e93:	83 ec 0c             	sub    $0xc,%esp
  801e96:	ff 75 f4             	pushl  -0xc(%ebp)
  801e99:	e8 a8 f0 ff ff       	call   800f46 <fd2data>
  801e9e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea0:	83 c4 0c             	add    $0xc,%esp
  801ea3:	68 07 04 00 00       	push   $0x407
  801ea8:	50                   	push   %eax
  801ea9:	6a 00                	push   $0x0
  801eab:	e8 29 ed ff ff       	call   800bd9 <sys_page_alloc>
  801eb0:	89 c3                	mov    %eax,%ebx
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	0f 88 82 00 00 00    	js     801f3f <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebd:	83 ec 0c             	sub    $0xc,%esp
  801ec0:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec3:	e8 7e f0 ff ff       	call   800f46 <fd2data>
  801ec8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ecf:	50                   	push   %eax
  801ed0:	6a 00                	push   $0x0
  801ed2:	56                   	push   %esi
  801ed3:	6a 00                	push   $0x0
  801ed5:	e8 46 ed ff ff       	call   800c20 <sys_page_map>
  801eda:	89 c3                	mov    %eax,%ebx
  801edc:	83 c4 20             	add    $0x20,%esp
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	78 4e                	js     801f31 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801ee3:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eeb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ef7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801efa:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eff:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f06:	83 ec 0c             	sub    $0xc,%esp
  801f09:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0c:	e8 21 f0 ff ff       	call   800f32 <fd2num>
  801f11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f14:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f16:	83 c4 04             	add    $0x4,%esp
  801f19:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1c:	e8 11 f0 ff ff       	call   800f32 <fd2num>
  801f21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f24:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f2f:	eb 2e                	jmp    801f5f <pipe+0x145>
	sys_page_unmap(0, va);
  801f31:	83 ec 08             	sub    $0x8,%esp
  801f34:	56                   	push   %esi
  801f35:	6a 00                	push   $0x0
  801f37:	e8 2a ed ff ff       	call   800c66 <sys_page_unmap>
  801f3c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f3f:	83 ec 08             	sub    $0x8,%esp
  801f42:	ff 75 f0             	pushl  -0x10(%ebp)
  801f45:	6a 00                	push   $0x0
  801f47:	e8 1a ed ff ff       	call   800c66 <sys_page_unmap>
  801f4c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f4f:	83 ec 08             	sub    $0x8,%esp
  801f52:	ff 75 f4             	pushl  -0xc(%ebp)
  801f55:	6a 00                	push   $0x0
  801f57:	e8 0a ed ff ff       	call   800c66 <sys_page_unmap>
  801f5c:	83 c4 10             	add    $0x10,%esp
}
  801f5f:	89 d8                	mov    %ebx,%eax
  801f61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f64:	5b                   	pop    %ebx
  801f65:	5e                   	pop    %esi
  801f66:	5d                   	pop    %ebp
  801f67:	c3                   	ret    

00801f68 <pipeisclosed>:
{
  801f68:	f3 0f 1e fb          	endbr32 
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f75:	50                   	push   %eax
  801f76:	ff 75 08             	pushl  0x8(%ebp)
  801f79:	e8 39 f0 ff ff       	call   800fb7 <fd_lookup>
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	85 c0                	test   %eax,%eax
  801f83:	78 18                	js     801f9d <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8b:	e8 b6 ef ff ff       	call   800f46 <fd2data>
  801f90:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f95:	e8 1f fd ff ff       	call   801cb9 <_pipeisclosed>
  801f9a:	83 c4 10             	add    $0x10,%esp
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f9f:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa8:	c3                   	ret    

00801fa9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fa9:	f3 0f 1e fb          	endbr32 
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fb3:	68 1b 2a 80 00       	push   $0x802a1b
  801fb8:	ff 75 0c             	pushl  0xc(%ebp)
  801fbb:	e8 d7 e7 ff ff       	call   800797 <strcpy>
	return 0;
}
  801fc0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <devcons_write>:
{
  801fc7:	f3 0f 1e fb          	endbr32 
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	57                   	push   %edi
  801fcf:	56                   	push   %esi
  801fd0:	53                   	push   %ebx
  801fd1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fd7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fdc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fe2:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fe5:	73 31                	jae    802018 <devcons_write+0x51>
		m = n - tot;
  801fe7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fea:	29 f3                	sub    %esi,%ebx
  801fec:	83 fb 7f             	cmp    $0x7f,%ebx
  801fef:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ff4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ff7:	83 ec 04             	sub    $0x4,%esp
  801ffa:	53                   	push   %ebx
  801ffb:	89 f0                	mov    %esi,%eax
  801ffd:	03 45 0c             	add    0xc(%ebp),%eax
  802000:	50                   	push   %eax
  802001:	57                   	push   %edi
  802002:	e8 46 e9 ff ff       	call   80094d <memmove>
		sys_cputs(buf, m);
  802007:	83 c4 08             	add    $0x8,%esp
  80200a:	53                   	push   %ebx
  80200b:	57                   	push   %edi
  80200c:	e8 f8 ea ff ff       	call   800b09 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802011:	01 de                	add    %ebx,%esi
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	eb ca                	jmp    801fe2 <devcons_write+0x1b>
}
  802018:	89 f0                	mov    %esi,%eax
  80201a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80201d:	5b                   	pop    %ebx
  80201e:	5e                   	pop    %esi
  80201f:	5f                   	pop    %edi
  802020:	5d                   	pop    %ebp
  802021:	c3                   	ret    

00802022 <devcons_read>:
{
  802022:	f3 0f 1e fb          	endbr32 
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 08             	sub    $0x8,%esp
  80202c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802031:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802035:	74 21                	je     802058 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802037:	e8 ef ea ff ff       	call   800b2b <sys_cgetc>
  80203c:	85 c0                	test   %eax,%eax
  80203e:	75 07                	jne    802047 <devcons_read+0x25>
		sys_yield();
  802040:	e8 71 eb ff ff       	call   800bb6 <sys_yield>
  802045:	eb f0                	jmp    802037 <devcons_read+0x15>
	if (c < 0)
  802047:	78 0f                	js     802058 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802049:	83 f8 04             	cmp    $0x4,%eax
  80204c:	74 0c                	je     80205a <devcons_read+0x38>
	*(char*)vbuf = c;
  80204e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802051:	88 02                	mov    %al,(%edx)
	return 1;
  802053:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    
		return 0;
  80205a:	b8 00 00 00 00       	mov    $0x0,%eax
  80205f:	eb f7                	jmp    802058 <devcons_read+0x36>

00802061 <cputchar>:
{
  802061:	f3 0f 1e fb          	endbr32 
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802071:	6a 01                	push   $0x1
  802073:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802076:	50                   	push   %eax
  802077:	e8 8d ea ff ff       	call   800b09 <sys_cputs>
}
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <getchar>:
{
  802081:	f3 0f 1e fb          	endbr32 
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80208b:	6a 01                	push   $0x1
  80208d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802090:	50                   	push   %eax
  802091:	6a 00                	push   $0x0
  802093:	e8 a7 f1 ff ff       	call   80123f <read>
	if (r < 0)
  802098:	83 c4 10             	add    $0x10,%esp
  80209b:	85 c0                	test   %eax,%eax
  80209d:	78 06                	js     8020a5 <getchar+0x24>
	if (r < 1)
  80209f:	74 06                	je     8020a7 <getchar+0x26>
	return c;
  8020a1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    
		return -E_EOF;
  8020a7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020ac:	eb f7                	jmp    8020a5 <getchar+0x24>

008020ae <iscons>:
{
  8020ae:	f3 0f 1e fb          	endbr32 
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bb:	50                   	push   %eax
  8020bc:	ff 75 08             	pushl  0x8(%ebp)
  8020bf:	e8 f3 ee ff ff       	call   800fb7 <fd_lookup>
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	78 11                	js     8020dc <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020d4:	39 10                	cmp    %edx,(%eax)
  8020d6:	0f 94 c0             	sete   %al
  8020d9:	0f b6 c0             	movzbl %al,%eax
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <opencons>:
{
  8020de:	f3 0f 1e fb          	endbr32 
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020eb:	50                   	push   %eax
  8020ec:	e8 70 ee ff ff       	call   800f61 <fd_alloc>
  8020f1:	83 c4 10             	add    $0x10,%esp
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	78 3a                	js     802132 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	68 07 04 00 00       	push   $0x407
  802100:	ff 75 f4             	pushl  -0xc(%ebp)
  802103:	6a 00                	push   $0x0
  802105:	e8 cf ea ff ff       	call   800bd9 <sys_page_alloc>
  80210a:	83 c4 10             	add    $0x10,%esp
  80210d:	85 c0                	test   %eax,%eax
  80210f:	78 21                	js     802132 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80211a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802126:	83 ec 0c             	sub    $0xc,%esp
  802129:	50                   	push   %eax
  80212a:	e8 03 ee ff ff       	call   800f32 <fd2num>
  80212f:	83 c4 10             	add    $0x10,%esp
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802134:	f3 0f 1e fb          	endbr32 
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	56                   	push   %esi
  80213c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80213d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802140:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802146:	e8 48 ea ff ff       	call   800b93 <sys_getenvid>
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	ff 75 0c             	pushl  0xc(%ebp)
  802151:	ff 75 08             	pushl  0x8(%ebp)
  802154:	56                   	push   %esi
  802155:	50                   	push   %eax
  802156:	68 28 2a 80 00       	push   $0x802a28
  80215b:	e8 2d e0 ff ff       	call   80018d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802160:	83 c4 18             	add    $0x18,%esp
  802163:	53                   	push   %ebx
  802164:	ff 75 10             	pushl  0x10(%ebp)
  802167:	e8 cc df ff ff       	call   800138 <vcprintf>
	cprintf("\n");
  80216c:	c7 04 24 64 2a 80 00 	movl   $0x802a64,(%esp)
  802173:	e8 15 e0 ff ff       	call   80018d <cprintf>
  802178:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80217b:	cc                   	int3   
  80217c:	eb fd                	jmp    80217b <_panic+0x47>

0080217e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80217e:	f3 0f 1e fb          	endbr32 
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	56                   	push   %esi
  802186:	53                   	push   %ebx
  802187:	8b 75 08             	mov    0x8(%ebp),%esi
  80218a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802190:	85 c0                	test   %eax,%eax
  802192:	74 3d                	je     8021d1 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802194:	83 ec 0c             	sub    $0xc,%esp
  802197:	50                   	push   %eax
  802198:	e8 08 ec ff ff       	call   800da5 <sys_ipc_recv>
  80219d:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8021a0:	85 f6                	test   %esi,%esi
  8021a2:	74 0b                	je     8021af <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8021a4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8021aa:	8b 52 74             	mov    0x74(%edx),%edx
  8021ad:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8021af:	85 db                	test   %ebx,%ebx
  8021b1:	74 0b                	je     8021be <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8021b3:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8021b9:	8b 52 78             	mov    0x78(%edx),%edx
  8021bc:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 21                	js     8021e3 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8021c2:	a1 08 40 80 00       	mov    0x804008,%eax
  8021c7:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021cd:	5b                   	pop    %ebx
  8021ce:	5e                   	pop    %esi
  8021cf:	5d                   	pop    %ebp
  8021d0:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8021d1:	83 ec 0c             	sub    $0xc,%esp
  8021d4:	68 00 00 c0 ee       	push   $0xeec00000
  8021d9:	e8 c7 eb ff ff       	call   800da5 <sys_ipc_recv>
  8021de:	83 c4 10             	add    $0x10,%esp
  8021e1:	eb bd                	jmp    8021a0 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8021e3:	85 f6                	test   %esi,%esi
  8021e5:	74 10                	je     8021f7 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8021e7:	85 db                	test   %ebx,%ebx
  8021e9:	75 df                	jne    8021ca <ipc_recv+0x4c>
  8021eb:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021f2:	00 00 00 
  8021f5:	eb d3                	jmp    8021ca <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8021f7:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021fe:	00 00 00 
  802201:	eb e4                	jmp    8021e7 <ipc_recv+0x69>

00802203 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802203:	f3 0f 1e fb          	endbr32 
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	57                   	push   %edi
  80220b:	56                   	push   %esi
  80220c:	53                   	push   %ebx
  80220d:	83 ec 0c             	sub    $0xc,%esp
  802210:	8b 7d 08             	mov    0x8(%ebp),%edi
  802213:	8b 75 0c             	mov    0xc(%ebp),%esi
  802216:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802219:	85 db                	test   %ebx,%ebx
  80221b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802220:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802223:	ff 75 14             	pushl  0x14(%ebp)
  802226:	53                   	push   %ebx
  802227:	56                   	push   %esi
  802228:	57                   	push   %edi
  802229:	e8 50 eb ff ff       	call   800d7e <sys_ipc_try_send>
  80222e:	83 c4 10             	add    $0x10,%esp
  802231:	85 c0                	test   %eax,%eax
  802233:	79 1e                	jns    802253 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802235:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802238:	75 07                	jne    802241 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80223a:	e8 77 e9 ff ff       	call   800bb6 <sys_yield>
  80223f:	eb e2                	jmp    802223 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802241:	50                   	push   %eax
  802242:	68 4b 2a 80 00       	push   $0x802a4b
  802247:	6a 59                	push   $0x59
  802249:	68 66 2a 80 00       	push   $0x802a66
  80224e:	e8 e1 fe ff ff       	call   802134 <_panic>
	}
}
  802253:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802256:	5b                   	pop    %ebx
  802257:	5e                   	pop    %esi
  802258:	5f                   	pop    %edi
  802259:	5d                   	pop    %ebp
  80225a:	c3                   	ret    

0080225b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80225b:	f3 0f 1e fb          	endbr32 
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802265:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80226a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80226d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802273:	8b 52 50             	mov    0x50(%edx),%edx
  802276:	39 ca                	cmp    %ecx,%edx
  802278:	74 11                	je     80228b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80227a:	83 c0 01             	add    $0x1,%eax
  80227d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802282:	75 e6                	jne    80226a <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
  802289:	eb 0b                	jmp    802296 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80228b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80228e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802293:	8b 40 48             	mov    0x48(%eax),%eax
}
  802296:	5d                   	pop    %ebp
  802297:	c3                   	ret    

00802298 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802298:	f3 0f 1e fb          	endbr32 
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022a2:	89 c2                	mov    %eax,%edx
  8022a4:	c1 ea 16             	shr    $0x16,%edx
  8022a7:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8022ae:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8022b3:	f6 c1 01             	test   $0x1,%cl
  8022b6:	74 1c                	je     8022d4 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8022b8:	c1 e8 0c             	shr    $0xc,%eax
  8022bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8022c2:	a8 01                	test   $0x1,%al
  8022c4:	74 0e                	je     8022d4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022c6:	c1 e8 0c             	shr    $0xc,%eax
  8022c9:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8022d0:	ef 
  8022d1:	0f b7 d2             	movzwl %dx,%edx
}
  8022d4:	89 d0                	mov    %edx,%eax
  8022d6:	5d                   	pop    %ebp
  8022d7:	c3                   	ret    
  8022d8:	66 90                	xchg   %ax,%ax
  8022da:	66 90                	xchg   %ax,%ax
  8022dc:	66 90                	xchg   %ax,%ax
  8022de:	66 90                	xchg   %ax,%ax

008022e0 <__udivdi3>:
  8022e0:	f3 0f 1e fb          	endbr32 
  8022e4:	55                   	push   %ebp
  8022e5:	57                   	push   %edi
  8022e6:	56                   	push   %esi
  8022e7:	53                   	push   %ebx
  8022e8:	83 ec 1c             	sub    $0x1c,%esp
  8022eb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022fb:	85 d2                	test   %edx,%edx
  8022fd:	75 19                	jne    802318 <__udivdi3+0x38>
  8022ff:	39 f3                	cmp    %esi,%ebx
  802301:	76 4d                	jbe    802350 <__udivdi3+0x70>
  802303:	31 ff                	xor    %edi,%edi
  802305:	89 e8                	mov    %ebp,%eax
  802307:	89 f2                	mov    %esi,%edx
  802309:	f7 f3                	div    %ebx
  80230b:	89 fa                	mov    %edi,%edx
  80230d:	83 c4 1c             	add    $0x1c,%esp
  802310:	5b                   	pop    %ebx
  802311:	5e                   	pop    %esi
  802312:	5f                   	pop    %edi
  802313:	5d                   	pop    %ebp
  802314:	c3                   	ret    
  802315:	8d 76 00             	lea    0x0(%esi),%esi
  802318:	39 f2                	cmp    %esi,%edx
  80231a:	76 14                	jbe    802330 <__udivdi3+0x50>
  80231c:	31 ff                	xor    %edi,%edi
  80231e:	31 c0                	xor    %eax,%eax
  802320:	89 fa                	mov    %edi,%edx
  802322:	83 c4 1c             	add    $0x1c,%esp
  802325:	5b                   	pop    %ebx
  802326:	5e                   	pop    %esi
  802327:	5f                   	pop    %edi
  802328:	5d                   	pop    %ebp
  802329:	c3                   	ret    
  80232a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802330:	0f bd fa             	bsr    %edx,%edi
  802333:	83 f7 1f             	xor    $0x1f,%edi
  802336:	75 48                	jne    802380 <__udivdi3+0xa0>
  802338:	39 f2                	cmp    %esi,%edx
  80233a:	72 06                	jb     802342 <__udivdi3+0x62>
  80233c:	31 c0                	xor    %eax,%eax
  80233e:	39 eb                	cmp    %ebp,%ebx
  802340:	77 de                	ja     802320 <__udivdi3+0x40>
  802342:	b8 01 00 00 00       	mov    $0x1,%eax
  802347:	eb d7                	jmp    802320 <__udivdi3+0x40>
  802349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802350:	89 d9                	mov    %ebx,%ecx
  802352:	85 db                	test   %ebx,%ebx
  802354:	75 0b                	jne    802361 <__udivdi3+0x81>
  802356:	b8 01 00 00 00       	mov    $0x1,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	f7 f3                	div    %ebx
  80235f:	89 c1                	mov    %eax,%ecx
  802361:	31 d2                	xor    %edx,%edx
  802363:	89 f0                	mov    %esi,%eax
  802365:	f7 f1                	div    %ecx
  802367:	89 c6                	mov    %eax,%esi
  802369:	89 e8                	mov    %ebp,%eax
  80236b:	89 f7                	mov    %esi,%edi
  80236d:	f7 f1                	div    %ecx
  80236f:	89 fa                	mov    %edi,%edx
  802371:	83 c4 1c             	add    $0x1c,%esp
  802374:	5b                   	pop    %ebx
  802375:	5e                   	pop    %esi
  802376:	5f                   	pop    %edi
  802377:	5d                   	pop    %ebp
  802378:	c3                   	ret    
  802379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802380:	89 f9                	mov    %edi,%ecx
  802382:	b8 20 00 00 00       	mov    $0x20,%eax
  802387:	29 f8                	sub    %edi,%eax
  802389:	d3 e2                	shl    %cl,%edx
  80238b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80238f:	89 c1                	mov    %eax,%ecx
  802391:	89 da                	mov    %ebx,%edx
  802393:	d3 ea                	shr    %cl,%edx
  802395:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802399:	09 d1                	or     %edx,%ecx
  80239b:	89 f2                	mov    %esi,%edx
  80239d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023a1:	89 f9                	mov    %edi,%ecx
  8023a3:	d3 e3                	shl    %cl,%ebx
  8023a5:	89 c1                	mov    %eax,%ecx
  8023a7:	d3 ea                	shr    %cl,%edx
  8023a9:	89 f9                	mov    %edi,%ecx
  8023ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023af:	89 eb                	mov    %ebp,%ebx
  8023b1:	d3 e6                	shl    %cl,%esi
  8023b3:	89 c1                	mov    %eax,%ecx
  8023b5:	d3 eb                	shr    %cl,%ebx
  8023b7:	09 de                	or     %ebx,%esi
  8023b9:	89 f0                	mov    %esi,%eax
  8023bb:	f7 74 24 08          	divl   0x8(%esp)
  8023bf:	89 d6                	mov    %edx,%esi
  8023c1:	89 c3                	mov    %eax,%ebx
  8023c3:	f7 64 24 0c          	mull   0xc(%esp)
  8023c7:	39 d6                	cmp    %edx,%esi
  8023c9:	72 15                	jb     8023e0 <__udivdi3+0x100>
  8023cb:	89 f9                	mov    %edi,%ecx
  8023cd:	d3 e5                	shl    %cl,%ebp
  8023cf:	39 c5                	cmp    %eax,%ebp
  8023d1:	73 04                	jae    8023d7 <__udivdi3+0xf7>
  8023d3:	39 d6                	cmp    %edx,%esi
  8023d5:	74 09                	je     8023e0 <__udivdi3+0x100>
  8023d7:	89 d8                	mov    %ebx,%eax
  8023d9:	31 ff                	xor    %edi,%edi
  8023db:	e9 40 ff ff ff       	jmp    802320 <__udivdi3+0x40>
  8023e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023e3:	31 ff                	xor    %edi,%edi
  8023e5:	e9 36 ff ff ff       	jmp    802320 <__udivdi3+0x40>
  8023ea:	66 90                	xchg   %ax,%ax
  8023ec:	66 90                	xchg   %ax,%ax
  8023ee:	66 90                	xchg   %ax,%ax

008023f0 <__umoddi3>:
  8023f0:	f3 0f 1e fb          	endbr32 
  8023f4:	55                   	push   %ebp
  8023f5:	57                   	push   %edi
  8023f6:	56                   	push   %esi
  8023f7:	53                   	push   %ebx
  8023f8:	83 ec 1c             	sub    $0x1c,%esp
  8023fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802403:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802407:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80240b:	85 c0                	test   %eax,%eax
  80240d:	75 19                	jne    802428 <__umoddi3+0x38>
  80240f:	39 df                	cmp    %ebx,%edi
  802411:	76 5d                	jbe    802470 <__umoddi3+0x80>
  802413:	89 f0                	mov    %esi,%eax
  802415:	89 da                	mov    %ebx,%edx
  802417:	f7 f7                	div    %edi
  802419:	89 d0                	mov    %edx,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	83 c4 1c             	add    $0x1c,%esp
  802420:	5b                   	pop    %ebx
  802421:	5e                   	pop    %esi
  802422:	5f                   	pop    %edi
  802423:	5d                   	pop    %ebp
  802424:	c3                   	ret    
  802425:	8d 76 00             	lea    0x0(%esi),%esi
  802428:	89 f2                	mov    %esi,%edx
  80242a:	39 d8                	cmp    %ebx,%eax
  80242c:	76 12                	jbe    802440 <__umoddi3+0x50>
  80242e:	89 f0                	mov    %esi,%eax
  802430:	89 da                	mov    %ebx,%edx
  802432:	83 c4 1c             	add    $0x1c,%esp
  802435:	5b                   	pop    %ebx
  802436:	5e                   	pop    %esi
  802437:	5f                   	pop    %edi
  802438:	5d                   	pop    %ebp
  802439:	c3                   	ret    
  80243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802440:	0f bd e8             	bsr    %eax,%ebp
  802443:	83 f5 1f             	xor    $0x1f,%ebp
  802446:	75 50                	jne    802498 <__umoddi3+0xa8>
  802448:	39 d8                	cmp    %ebx,%eax
  80244a:	0f 82 e0 00 00 00    	jb     802530 <__umoddi3+0x140>
  802450:	89 d9                	mov    %ebx,%ecx
  802452:	39 f7                	cmp    %esi,%edi
  802454:	0f 86 d6 00 00 00    	jbe    802530 <__umoddi3+0x140>
  80245a:	89 d0                	mov    %edx,%eax
  80245c:	89 ca                	mov    %ecx,%edx
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	89 fd                	mov    %edi,%ebp
  802472:	85 ff                	test   %edi,%edi
  802474:	75 0b                	jne    802481 <__umoddi3+0x91>
  802476:	b8 01 00 00 00       	mov    $0x1,%eax
  80247b:	31 d2                	xor    %edx,%edx
  80247d:	f7 f7                	div    %edi
  80247f:	89 c5                	mov    %eax,%ebp
  802481:	89 d8                	mov    %ebx,%eax
  802483:	31 d2                	xor    %edx,%edx
  802485:	f7 f5                	div    %ebp
  802487:	89 f0                	mov    %esi,%eax
  802489:	f7 f5                	div    %ebp
  80248b:	89 d0                	mov    %edx,%eax
  80248d:	31 d2                	xor    %edx,%edx
  80248f:	eb 8c                	jmp    80241d <__umoddi3+0x2d>
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	ba 20 00 00 00       	mov    $0x20,%edx
  80249f:	29 ea                	sub    %ebp,%edx
  8024a1:	d3 e0                	shl    %cl,%eax
  8024a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a7:	89 d1                	mov    %edx,%ecx
  8024a9:	89 f8                	mov    %edi,%eax
  8024ab:	d3 e8                	shr    %cl,%eax
  8024ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024b9:	09 c1                	or     %eax,%ecx
  8024bb:	89 d8                	mov    %ebx,%eax
  8024bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c1:	89 e9                	mov    %ebp,%ecx
  8024c3:	d3 e7                	shl    %cl,%edi
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	d3 e8                	shr    %cl,%eax
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024cf:	d3 e3                	shl    %cl,%ebx
  8024d1:	89 c7                	mov    %eax,%edi
  8024d3:	89 d1                	mov    %edx,%ecx
  8024d5:	89 f0                	mov    %esi,%eax
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 fa                	mov    %edi,%edx
  8024dd:	d3 e6                	shl    %cl,%esi
  8024df:	09 d8                	or     %ebx,%eax
  8024e1:	f7 74 24 08          	divl   0x8(%esp)
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	89 f3                	mov    %esi,%ebx
  8024e9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ed:	89 c6                	mov    %eax,%esi
  8024ef:	89 d7                	mov    %edx,%edi
  8024f1:	39 d1                	cmp    %edx,%ecx
  8024f3:	72 06                	jb     8024fb <__umoddi3+0x10b>
  8024f5:	75 10                	jne    802507 <__umoddi3+0x117>
  8024f7:	39 c3                	cmp    %eax,%ebx
  8024f9:	73 0c                	jae    802507 <__umoddi3+0x117>
  8024fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802503:	89 d7                	mov    %edx,%edi
  802505:	89 c6                	mov    %eax,%esi
  802507:	89 ca                	mov    %ecx,%edx
  802509:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80250e:	29 f3                	sub    %esi,%ebx
  802510:	19 fa                	sbb    %edi,%edx
  802512:	89 d0                	mov    %edx,%eax
  802514:	d3 e0                	shl    %cl,%eax
  802516:	89 e9                	mov    %ebp,%ecx
  802518:	d3 eb                	shr    %cl,%ebx
  80251a:	d3 ea                	shr    %cl,%edx
  80251c:	09 d8                	or     %ebx,%eax
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	29 fe                	sub    %edi,%esi
  802532:	19 c3                	sbb    %eax,%ebx
  802534:	89 f2                	mov    %esi,%edx
  802536:	89 d9                	mov    %ebx,%ecx
  802538:	e9 1d ff ff ff       	jmp    80245a <__umoddi3+0x6a>
