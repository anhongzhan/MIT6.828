
obj/user/spin:     file format elf32-i386


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
  80002c:	e8 88 00 00 00       	call   8000b9 <libmain>
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
  80003b:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003e:	68 e0 13 80 00       	push   $0x8013e0
  800043:	e8 6e 01 00 00       	call   8001b6 <cprintf>
	if ((env = fork()) == 0) {
  800048:	e8 60 0e 00 00       	call   800ead <fork>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	85 c0                	test   %eax,%eax
  800052:	75 12                	jne    800066 <umain+0x33>
		cprintf("I am the child.  Spinning...\n");
  800054:	83 ec 0c             	sub    $0xc,%esp
  800057:	68 58 14 80 00       	push   $0x801458
  80005c:	e8 55 01 00 00       	call   8001b6 <cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
  800064:	eb fe                	jmp    800064 <umain+0x31>
  800066:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800068:	83 ec 0c             	sub    $0xc,%esp
  80006b:	68 08 14 80 00       	push   $0x801408
  800070:	e8 41 01 00 00       	call   8001b6 <cprintf>
	sys_yield();
  800075:	e8 65 0b 00 00       	call   800bdf <sys_yield>
	sys_yield();
  80007a:	e8 60 0b 00 00       	call   800bdf <sys_yield>
	sys_yield();
  80007f:	e8 5b 0b 00 00       	call   800bdf <sys_yield>
	sys_yield();
  800084:	e8 56 0b 00 00       	call   800bdf <sys_yield>
	sys_yield();
  800089:	e8 51 0b 00 00       	call   800bdf <sys_yield>
	sys_yield();
  80008e:	e8 4c 0b 00 00       	call   800bdf <sys_yield>
	sys_yield();
  800093:	e8 47 0b 00 00       	call   800bdf <sys_yield>
	sys_yield();
  800098:	e8 42 0b 00 00       	call   800bdf <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  80009d:	c7 04 24 30 14 80 00 	movl   $0x801430,(%esp)
  8000a4:	e8 0d 01 00 00       	call   8001b6 <cprintf>
	sys_env_destroy(env);
  8000a9:	89 1c 24             	mov    %ebx,(%esp)
  8000ac:	e8 c6 0a 00 00       	call   800b77 <sys_env_destroy>
}
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b7:	c9                   	leave  
  8000b8:	c3                   	ret    

008000b9 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b9:	f3 0f 1e fb          	endbr32 
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
  8000c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c8:	e8 ef 0a 00 00       	call   800bbc <sys_getenvid>
  8000cd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000da:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000df:	85 db                	test   %ebx,%ebx
  8000e1:	7e 07                	jle    8000ea <libmain+0x31>
		binaryname = argv[0];
  8000e3:	8b 06                	mov    (%esi),%eax
  8000e5:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ea:	83 ec 08             	sub    $0x8,%esp
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	e8 3f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f4:	e8 0a 00 00 00       	call   800103 <exit>
}
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ff:	5b                   	pop    %ebx
  800100:	5e                   	pop    %esi
  800101:	5d                   	pop    %ebp
  800102:	c3                   	ret    

00800103 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800103:	f3 0f 1e fb          	endbr32 
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80010d:	6a 00                	push   $0x0
  80010f:	e8 63 0a 00 00       	call   800b77 <sys_env_destroy>
}
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	c9                   	leave  
  800118:	c3                   	ret    

00800119 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800119:	f3 0f 1e fb          	endbr32 
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
  800120:	53                   	push   %ebx
  800121:	83 ec 04             	sub    $0x4,%esp
  800124:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800127:	8b 13                	mov    (%ebx),%edx
  800129:	8d 42 01             	lea    0x1(%edx),%eax
  80012c:	89 03                	mov    %eax,(%ebx)
  80012e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800131:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800135:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013a:	74 09                	je     800145 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800143:	c9                   	leave  
  800144:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	68 ff 00 00 00       	push   $0xff
  80014d:	8d 43 08             	lea    0x8(%ebx),%eax
  800150:	50                   	push   %eax
  800151:	e8 dc 09 00 00       	call   800b32 <sys_cputs>
		b->idx = 0;
  800156:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	eb db                	jmp    80013c <putch+0x23>

00800161 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800161:	f3 0f 1e fb          	endbr32 
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800175:	00 00 00 
	b.cnt = 0;
  800178:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018e:	50                   	push   %eax
  80018f:	68 19 01 80 00       	push   $0x800119
  800194:	e8 20 01 00 00       	call   8002b9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800199:	83 c4 08             	add    $0x8,%esp
  80019c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 84 09 00 00       	call   800b32 <sys_cputs>

	return b.cnt;
}
  8001ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b6:	f3 0f 1e fb          	endbr32 
  8001ba:	55                   	push   %ebp
  8001bb:	89 e5                	mov    %esp,%ebp
  8001bd:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001c0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001c3:	50                   	push   %eax
  8001c4:	ff 75 08             	pushl  0x8(%ebp)
  8001c7:	e8 95 ff ff ff       	call   800161 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001cc:	c9                   	leave  
  8001cd:	c3                   	ret    

008001ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ce:	55                   	push   %ebp
  8001cf:	89 e5                	mov    %esp,%ebp
  8001d1:	57                   	push   %edi
  8001d2:	56                   	push   %esi
  8001d3:	53                   	push   %ebx
  8001d4:	83 ec 1c             	sub    $0x1c,%esp
  8001d7:	89 c7                	mov    %eax,%edi
  8001d9:	89 d6                	mov    %edx,%esi
  8001db:	8b 45 08             	mov    0x8(%ebp),%eax
  8001de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e1:	89 d1                	mov    %edx,%ecx
  8001e3:	89 c2                	mov    %eax,%edx
  8001e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001f4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001fb:	39 c2                	cmp    %eax,%edx
  8001fd:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800200:	72 3e                	jb     800240 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	ff 75 18             	pushl  0x18(%ebp)
  800208:	83 eb 01             	sub    $0x1,%ebx
  80020b:	53                   	push   %ebx
  80020c:	50                   	push   %eax
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 e4             	pushl  -0x1c(%ebp)
  800213:	ff 75 e0             	pushl  -0x20(%ebp)
  800216:	ff 75 dc             	pushl  -0x24(%ebp)
  800219:	ff 75 d8             	pushl  -0x28(%ebp)
  80021c:	e8 5f 0f 00 00       	call   801180 <__udivdi3>
  800221:	83 c4 18             	add    $0x18,%esp
  800224:	52                   	push   %edx
  800225:	50                   	push   %eax
  800226:	89 f2                	mov    %esi,%edx
  800228:	89 f8                	mov    %edi,%eax
  80022a:	e8 9f ff ff ff       	call   8001ce <printnum>
  80022f:	83 c4 20             	add    $0x20,%esp
  800232:	eb 13                	jmp    800247 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	56                   	push   %esi
  800238:	ff 75 18             	pushl  0x18(%ebp)
  80023b:	ff d7                	call   *%edi
  80023d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800240:	83 eb 01             	sub    $0x1,%ebx
  800243:	85 db                	test   %ebx,%ebx
  800245:	7f ed                	jg     800234 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	56                   	push   %esi
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800251:	ff 75 e0             	pushl  -0x20(%ebp)
  800254:	ff 75 dc             	pushl  -0x24(%ebp)
  800257:	ff 75 d8             	pushl  -0x28(%ebp)
  80025a:	e8 31 10 00 00       	call   801290 <__umoddi3>
  80025f:	83 c4 14             	add    $0x14,%esp
  800262:	0f be 80 80 14 80 00 	movsbl 0x801480(%eax),%eax
  800269:	50                   	push   %eax
  80026a:	ff d7                	call   *%edi
}
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800272:	5b                   	pop    %ebx
  800273:	5e                   	pop    %esi
  800274:	5f                   	pop    %edi
  800275:	5d                   	pop    %ebp
  800276:	c3                   	ret    

00800277 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800277:	f3 0f 1e fb          	endbr32 
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800281:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800285:	8b 10                	mov    (%eax),%edx
  800287:	3b 50 04             	cmp    0x4(%eax),%edx
  80028a:	73 0a                	jae    800296 <sprintputch+0x1f>
		*b->buf++ = ch;
  80028c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028f:	89 08                	mov    %ecx,(%eax)
  800291:	8b 45 08             	mov    0x8(%ebp),%eax
  800294:	88 02                	mov    %al,(%edx)
}
  800296:	5d                   	pop    %ebp
  800297:	c3                   	ret    

00800298 <printfmt>:
{
  800298:	f3 0f 1e fb          	endbr32 
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002a2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002a5:	50                   	push   %eax
  8002a6:	ff 75 10             	pushl  0x10(%ebp)
  8002a9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ac:	ff 75 08             	pushl  0x8(%ebp)
  8002af:	e8 05 00 00 00       	call   8002b9 <vprintfmt>
}
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    

008002b9 <vprintfmt>:
{
  8002b9:	f3 0f 1e fb          	endbr32 
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	57                   	push   %edi
  8002c1:	56                   	push   %esi
  8002c2:	53                   	push   %ebx
  8002c3:	83 ec 3c             	sub    $0x3c,%esp
  8002c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002cc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002cf:	e9 8e 03 00 00       	jmp    800662 <vprintfmt+0x3a9>
		padc = ' ';
  8002d4:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002d8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002df:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ed:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002f2:	8d 47 01             	lea    0x1(%edi),%eax
  8002f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002f8:	0f b6 17             	movzbl (%edi),%edx
  8002fb:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002fe:	3c 55                	cmp    $0x55,%al
  800300:	0f 87 df 03 00 00    	ja     8006e5 <vprintfmt+0x42c>
  800306:	0f b6 c0             	movzbl %al,%eax
  800309:	3e ff 24 85 40 15 80 	notrack jmp *0x801540(,%eax,4)
  800310:	00 
  800311:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800314:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800318:	eb d8                	jmp    8002f2 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80031a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80031d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800321:	eb cf                	jmp    8002f2 <vprintfmt+0x39>
  800323:	0f b6 d2             	movzbl %dl,%edx
  800326:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800329:	b8 00 00 00 00       	mov    $0x0,%eax
  80032e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800331:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800334:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800338:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80033b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80033e:	83 f9 09             	cmp    $0x9,%ecx
  800341:	77 55                	ja     800398 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800343:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800346:	eb e9                	jmp    800331 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800348:	8b 45 14             	mov    0x14(%ebp),%eax
  80034b:	8b 00                	mov    (%eax),%eax
  80034d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800350:	8b 45 14             	mov    0x14(%ebp),%eax
  800353:	8d 40 04             	lea    0x4(%eax),%eax
  800356:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800359:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80035c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800360:	79 90                	jns    8002f2 <vprintfmt+0x39>
				width = precision, precision = -1;
  800362:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800365:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800368:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80036f:	eb 81                	jmp    8002f2 <vprintfmt+0x39>
  800371:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800374:	85 c0                	test   %eax,%eax
  800376:	ba 00 00 00 00       	mov    $0x0,%edx
  80037b:	0f 49 d0             	cmovns %eax,%edx
  80037e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800381:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800384:	e9 69 ff ff ff       	jmp    8002f2 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80038c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800393:	e9 5a ff ff ff       	jmp    8002f2 <vprintfmt+0x39>
  800398:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80039b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039e:	eb bc                	jmp    80035c <vprintfmt+0xa3>
			lflag++;
  8003a0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003a6:	e9 47 ff ff ff       	jmp    8002f2 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ae:	8d 78 04             	lea    0x4(%eax),%edi
  8003b1:	83 ec 08             	sub    $0x8,%esp
  8003b4:	53                   	push   %ebx
  8003b5:	ff 30                	pushl  (%eax)
  8003b7:	ff d6                	call   *%esi
			break;
  8003b9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003bc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003bf:	e9 9b 02 00 00       	jmp    80065f <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c7:	8d 78 04             	lea    0x4(%eax),%edi
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	99                   	cltd   
  8003cd:	31 d0                	xor    %edx,%eax
  8003cf:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d1:	83 f8 08             	cmp    $0x8,%eax
  8003d4:	7f 23                	jg     8003f9 <vprintfmt+0x140>
  8003d6:	8b 14 85 a0 16 80 00 	mov    0x8016a0(,%eax,4),%edx
  8003dd:	85 d2                	test   %edx,%edx
  8003df:	74 18                	je     8003f9 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003e1:	52                   	push   %edx
  8003e2:	68 a1 14 80 00       	push   $0x8014a1
  8003e7:	53                   	push   %ebx
  8003e8:	56                   	push   %esi
  8003e9:	e8 aa fe ff ff       	call   800298 <printfmt>
  8003ee:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003f4:	e9 66 02 00 00       	jmp    80065f <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003f9:	50                   	push   %eax
  8003fa:	68 98 14 80 00       	push   $0x801498
  8003ff:	53                   	push   %ebx
  800400:	56                   	push   %esi
  800401:	e8 92 fe ff ff       	call   800298 <printfmt>
  800406:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800409:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80040c:	e9 4e 02 00 00       	jmp    80065f <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800411:	8b 45 14             	mov    0x14(%ebp),%eax
  800414:	83 c0 04             	add    $0x4,%eax
  800417:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80041f:	85 d2                	test   %edx,%edx
  800421:	b8 91 14 80 00       	mov    $0x801491,%eax
  800426:	0f 45 c2             	cmovne %edx,%eax
  800429:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80042c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800430:	7e 06                	jle    800438 <vprintfmt+0x17f>
  800432:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800436:	75 0d                	jne    800445 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800438:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80043b:	89 c7                	mov    %eax,%edi
  80043d:	03 45 e0             	add    -0x20(%ebp),%eax
  800440:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800443:	eb 55                	jmp    80049a <vprintfmt+0x1e1>
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	ff 75 d8             	pushl  -0x28(%ebp)
  80044b:	ff 75 cc             	pushl  -0x34(%ebp)
  80044e:	e8 46 03 00 00       	call   800799 <strnlen>
  800453:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800456:	29 c2                	sub    %eax,%edx
  800458:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800460:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800464:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800467:	85 ff                	test   %edi,%edi
  800469:	7e 11                	jle    80047c <vprintfmt+0x1c3>
					putch(padc, putdat);
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	53                   	push   %ebx
  80046f:	ff 75 e0             	pushl  -0x20(%ebp)
  800472:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800474:	83 ef 01             	sub    $0x1,%edi
  800477:	83 c4 10             	add    $0x10,%esp
  80047a:	eb eb                	jmp    800467 <vprintfmt+0x1ae>
  80047c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80047f:	85 d2                	test   %edx,%edx
  800481:	b8 00 00 00 00       	mov    $0x0,%eax
  800486:	0f 49 c2             	cmovns %edx,%eax
  800489:	29 c2                	sub    %eax,%edx
  80048b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80048e:	eb a8                	jmp    800438 <vprintfmt+0x17f>
					putch(ch, putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	53                   	push   %ebx
  800494:	52                   	push   %edx
  800495:	ff d6                	call   *%esi
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80049d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049f:	83 c7 01             	add    $0x1,%edi
  8004a2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004a6:	0f be d0             	movsbl %al,%edx
  8004a9:	85 d2                	test   %edx,%edx
  8004ab:	74 4b                	je     8004f8 <vprintfmt+0x23f>
  8004ad:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b1:	78 06                	js     8004b9 <vprintfmt+0x200>
  8004b3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004b7:	78 1e                	js     8004d7 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004bd:	74 d1                	je     800490 <vprintfmt+0x1d7>
  8004bf:	0f be c0             	movsbl %al,%eax
  8004c2:	83 e8 20             	sub    $0x20,%eax
  8004c5:	83 f8 5e             	cmp    $0x5e,%eax
  8004c8:	76 c6                	jbe    800490 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	53                   	push   %ebx
  8004ce:	6a 3f                	push   $0x3f
  8004d0:	ff d6                	call   *%esi
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	eb c3                	jmp    80049a <vprintfmt+0x1e1>
  8004d7:	89 cf                	mov    %ecx,%edi
  8004d9:	eb 0e                	jmp    8004e9 <vprintfmt+0x230>
				putch(' ', putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	53                   	push   %ebx
  8004df:	6a 20                	push   $0x20
  8004e1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004e3:	83 ef 01             	sub    $0x1,%edi
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	85 ff                	test   %edi,%edi
  8004eb:	7f ee                	jg     8004db <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f3:	e9 67 01 00 00       	jmp    80065f <vprintfmt+0x3a6>
  8004f8:	89 cf                	mov    %ecx,%edi
  8004fa:	eb ed                	jmp    8004e9 <vprintfmt+0x230>
	if (lflag >= 2)
  8004fc:	83 f9 01             	cmp    $0x1,%ecx
  8004ff:	7f 1b                	jg     80051c <vprintfmt+0x263>
	else if (lflag)
  800501:	85 c9                	test   %ecx,%ecx
  800503:	74 63                	je     800568 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050d:	99                   	cltd   
  80050e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8d 40 04             	lea    0x4(%eax),%eax
  800517:	89 45 14             	mov    %eax,0x14(%ebp)
  80051a:	eb 17                	jmp    800533 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80051c:	8b 45 14             	mov    0x14(%ebp),%eax
  80051f:	8b 50 04             	mov    0x4(%eax),%edx
  800522:	8b 00                	mov    (%eax),%eax
  800524:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800527:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8d 40 08             	lea    0x8(%eax),%eax
  800530:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800533:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800536:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800539:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80053e:	85 c9                	test   %ecx,%ecx
  800540:	0f 89 ff 00 00 00    	jns    800645 <vprintfmt+0x38c>
				putch('-', putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	53                   	push   %ebx
  80054a:	6a 2d                	push   $0x2d
  80054c:	ff d6                	call   *%esi
				num = -(long long) num;
  80054e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800551:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800554:	f7 da                	neg    %edx
  800556:	83 d1 00             	adc    $0x0,%ecx
  800559:	f7 d9                	neg    %ecx
  80055b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80055e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800563:	e9 dd 00 00 00       	jmp    800645 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800570:	99                   	cltd   
  800571:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 40 04             	lea    0x4(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
  80057d:	eb b4                	jmp    800533 <vprintfmt+0x27a>
	if (lflag >= 2)
  80057f:	83 f9 01             	cmp    $0x1,%ecx
  800582:	7f 1e                	jg     8005a2 <vprintfmt+0x2e9>
	else if (lflag)
  800584:	85 c9                	test   %ecx,%ecx
  800586:	74 32                	je     8005ba <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8b 10                	mov    (%eax),%edx
  80058d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800592:	8d 40 04             	lea    0x4(%eax),%eax
  800595:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800598:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80059d:	e9 a3 00 00 00       	jmp    800645 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8b 10                	mov    (%eax),%edx
  8005a7:	8b 48 04             	mov    0x4(%eax),%ecx
  8005aa:	8d 40 08             	lea    0x8(%eax),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005b5:	e9 8b 00 00 00       	jmp    800645 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8b 10                	mov    (%eax),%edx
  8005bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c4:	8d 40 04             	lea    0x4(%eax),%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ca:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005cf:	eb 74                	jmp    800645 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005d1:	83 f9 01             	cmp    $0x1,%ecx
  8005d4:	7f 1b                	jg     8005f1 <vprintfmt+0x338>
	else if (lflag)
  8005d6:	85 c9                	test   %ecx,%ecx
  8005d8:	74 2c                	je     800606 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	8b 10                	mov    (%eax),%edx
  8005df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e4:	8d 40 04             	lea    0x4(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ea:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005ef:	eb 54                	jmp    800645 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8b 10                	mov    (%eax),%edx
  8005f6:	8b 48 04             	mov    0x4(%eax),%ecx
  8005f9:	8d 40 08             	lea    0x8(%eax),%eax
  8005fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ff:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800604:	eb 3f                	jmp    800645 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800610:	8d 40 04             	lea    0x4(%eax),%eax
  800613:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800616:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80061b:	eb 28                	jmp    800645 <vprintfmt+0x38c>
			putch('0', putdat);
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	53                   	push   %ebx
  800621:	6a 30                	push   $0x30
  800623:	ff d6                	call   *%esi
			putch('x', putdat);
  800625:	83 c4 08             	add    $0x8,%esp
  800628:	53                   	push   %ebx
  800629:	6a 78                	push   $0x78
  80062b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8b 10                	mov    (%eax),%edx
  800632:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800637:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80063a:	8d 40 04             	lea    0x4(%eax),%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800640:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80064c:	57                   	push   %edi
  80064d:	ff 75 e0             	pushl  -0x20(%ebp)
  800650:	50                   	push   %eax
  800651:	51                   	push   %ecx
  800652:	52                   	push   %edx
  800653:	89 da                	mov    %ebx,%edx
  800655:	89 f0                	mov    %esi,%eax
  800657:	e8 72 fb ff ff       	call   8001ce <printnum>
			break;
  80065c:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80065f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800662:	83 c7 01             	add    $0x1,%edi
  800665:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800669:	83 f8 25             	cmp    $0x25,%eax
  80066c:	0f 84 62 fc ff ff    	je     8002d4 <vprintfmt+0x1b>
			if (ch == '\0')
  800672:	85 c0                	test   %eax,%eax
  800674:	0f 84 8b 00 00 00    	je     800705 <vprintfmt+0x44c>
			putch(ch, putdat);
  80067a:	83 ec 08             	sub    $0x8,%esp
  80067d:	53                   	push   %ebx
  80067e:	50                   	push   %eax
  80067f:	ff d6                	call   *%esi
  800681:	83 c4 10             	add    $0x10,%esp
  800684:	eb dc                	jmp    800662 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800686:	83 f9 01             	cmp    $0x1,%ecx
  800689:	7f 1b                	jg     8006a6 <vprintfmt+0x3ed>
	else if (lflag)
  80068b:	85 c9                	test   %ecx,%ecx
  80068d:	74 2c                	je     8006bb <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8b 10                	mov    (%eax),%edx
  800694:	b9 00 00 00 00       	mov    $0x0,%ecx
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006a4:	eb 9f                	jmp    800645 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 10                	mov    (%eax),%edx
  8006ab:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ae:	8d 40 08             	lea    0x8(%eax),%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b4:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006b9:	eb 8a                	jmp    800645 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8b 10                	mov    (%eax),%edx
  8006c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c5:	8d 40 04             	lea    0x4(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006cb:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006d0:	e9 70 ff ff ff       	jmp    800645 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	53                   	push   %ebx
  8006d9:	6a 25                	push   $0x25
  8006db:	ff d6                	call   *%esi
			break;
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	e9 7a ff ff ff       	jmp    80065f <vprintfmt+0x3a6>
			putch('%', putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	53                   	push   %ebx
  8006e9:	6a 25                	push   $0x25
  8006eb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	89 f8                	mov    %edi,%eax
  8006f2:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006f6:	74 05                	je     8006fd <vprintfmt+0x444>
  8006f8:	83 e8 01             	sub    $0x1,%eax
  8006fb:	eb f5                	jmp    8006f2 <vprintfmt+0x439>
  8006fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800700:	e9 5a ff ff ff       	jmp    80065f <vprintfmt+0x3a6>
}
  800705:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800708:	5b                   	pop    %ebx
  800709:	5e                   	pop    %esi
  80070a:	5f                   	pop    %edi
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80070d:	f3 0f 1e fb          	endbr32 
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	83 ec 18             	sub    $0x18,%esp
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80071d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800720:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800724:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800727:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80072e:	85 c0                	test   %eax,%eax
  800730:	74 26                	je     800758 <vsnprintf+0x4b>
  800732:	85 d2                	test   %edx,%edx
  800734:	7e 22                	jle    800758 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800736:	ff 75 14             	pushl  0x14(%ebp)
  800739:	ff 75 10             	pushl  0x10(%ebp)
  80073c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80073f:	50                   	push   %eax
  800740:	68 77 02 80 00       	push   $0x800277
  800745:	e8 6f fb ff ff       	call   8002b9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80074a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80074d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800753:	83 c4 10             	add    $0x10,%esp
}
  800756:	c9                   	leave  
  800757:	c3                   	ret    
		return -E_INVAL;
  800758:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075d:	eb f7                	jmp    800756 <vsnprintf+0x49>

0080075f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80075f:	f3 0f 1e fb          	endbr32 
  800763:	55                   	push   %ebp
  800764:	89 e5                	mov    %esp,%ebp
  800766:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800769:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80076c:	50                   	push   %eax
  80076d:	ff 75 10             	pushl  0x10(%ebp)
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	ff 75 08             	pushl  0x8(%ebp)
  800776:	e8 92 ff ff ff       	call   80070d <vsnprintf>
	va_end(ap);

	return rc;
}
  80077b:	c9                   	leave  
  80077c:	c3                   	ret    

0080077d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80077d:	f3 0f 1e fb          	endbr32 
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800787:	b8 00 00 00 00       	mov    $0x0,%eax
  80078c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800790:	74 05                	je     800797 <strlen+0x1a>
		n++;
  800792:	83 c0 01             	add    $0x1,%eax
  800795:	eb f5                	jmp    80078c <strlen+0xf>
	return n;
}
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800799:	f3 0f 1e fb          	endbr32 
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	39 d0                	cmp    %edx,%eax
  8007ad:	74 0d                	je     8007bc <strnlen+0x23>
  8007af:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007b3:	74 05                	je     8007ba <strnlen+0x21>
		n++;
  8007b5:	83 c0 01             	add    $0x1,%eax
  8007b8:	eb f1                	jmp    8007ab <strnlen+0x12>
  8007ba:	89 c2                	mov    %eax,%edx
	return n;
}
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	5d                   	pop    %ebp
  8007bf:	c3                   	ret    

008007c0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c0:	f3 0f 1e fb          	endbr32 
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
  8007c7:	53                   	push   %ebx
  8007c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d3:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007d7:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007da:	83 c0 01             	add    $0x1,%eax
  8007dd:	84 d2                	test   %dl,%dl
  8007df:	75 f2                	jne    8007d3 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007e1:	89 c8                	mov    %ecx,%eax
  8007e3:	5b                   	pop    %ebx
  8007e4:	5d                   	pop    %ebp
  8007e5:	c3                   	ret    

008007e6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007e6:	f3 0f 1e fb          	endbr32 
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	53                   	push   %ebx
  8007ee:	83 ec 10             	sub    $0x10,%esp
  8007f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f4:	53                   	push   %ebx
  8007f5:	e8 83 ff ff ff       	call   80077d <strlen>
  8007fa:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007fd:	ff 75 0c             	pushl  0xc(%ebp)
  800800:	01 d8                	add    %ebx,%eax
  800802:	50                   	push   %eax
  800803:	e8 b8 ff ff ff       	call   8007c0 <strcpy>
	return dst;
}
  800808:	89 d8                	mov    %ebx,%eax
  80080a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80080d:	c9                   	leave  
  80080e:	c3                   	ret    

0080080f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80080f:	f3 0f 1e fb          	endbr32 
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	56                   	push   %esi
  800817:	53                   	push   %ebx
  800818:	8b 75 08             	mov    0x8(%ebp),%esi
  80081b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081e:	89 f3                	mov    %esi,%ebx
  800820:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800823:	89 f0                	mov    %esi,%eax
  800825:	39 d8                	cmp    %ebx,%eax
  800827:	74 11                	je     80083a <strncpy+0x2b>
		*dst++ = *src;
  800829:	83 c0 01             	add    $0x1,%eax
  80082c:	0f b6 0a             	movzbl (%edx),%ecx
  80082f:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800832:	80 f9 01             	cmp    $0x1,%cl
  800835:	83 da ff             	sbb    $0xffffffff,%edx
  800838:	eb eb                	jmp    800825 <strncpy+0x16>
	}
	return ret;
}
  80083a:	89 f0                	mov    %esi,%eax
  80083c:	5b                   	pop    %ebx
  80083d:	5e                   	pop    %esi
  80083e:	5d                   	pop    %ebp
  80083f:	c3                   	ret    

00800840 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800840:	f3 0f 1e fb          	endbr32 
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	56                   	push   %esi
  800848:	53                   	push   %ebx
  800849:	8b 75 08             	mov    0x8(%ebp),%esi
  80084c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084f:	8b 55 10             	mov    0x10(%ebp),%edx
  800852:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800854:	85 d2                	test   %edx,%edx
  800856:	74 21                	je     800879 <strlcpy+0x39>
  800858:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80085c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80085e:	39 c2                	cmp    %eax,%edx
  800860:	74 14                	je     800876 <strlcpy+0x36>
  800862:	0f b6 19             	movzbl (%ecx),%ebx
  800865:	84 db                	test   %bl,%bl
  800867:	74 0b                	je     800874 <strlcpy+0x34>
			*dst++ = *src++;
  800869:	83 c1 01             	add    $0x1,%ecx
  80086c:	83 c2 01             	add    $0x1,%edx
  80086f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800872:	eb ea                	jmp    80085e <strlcpy+0x1e>
  800874:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800876:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800879:	29 f0                	sub    %esi,%eax
}
  80087b:	5b                   	pop    %ebx
  80087c:	5e                   	pop    %esi
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    

0080087f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80087f:	f3 0f 1e fb          	endbr32 
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
  800886:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800889:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80088c:	0f b6 01             	movzbl (%ecx),%eax
  80088f:	84 c0                	test   %al,%al
  800891:	74 0c                	je     80089f <strcmp+0x20>
  800893:	3a 02                	cmp    (%edx),%al
  800895:	75 08                	jne    80089f <strcmp+0x20>
		p++, q++;
  800897:	83 c1 01             	add    $0x1,%ecx
  80089a:	83 c2 01             	add    $0x1,%edx
  80089d:	eb ed                	jmp    80088c <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80089f:	0f b6 c0             	movzbl %al,%eax
  8008a2:	0f b6 12             	movzbl (%edx),%edx
  8008a5:	29 d0                	sub    %edx,%eax
}
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a9:	f3 0f 1e fb          	endbr32 
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	53                   	push   %ebx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b7:	89 c3                	mov    %eax,%ebx
  8008b9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008bc:	eb 06                	jmp    8008c4 <strncmp+0x1b>
		n--, p++, q++;
  8008be:	83 c0 01             	add    $0x1,%eax
  8008c1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008c4:	39 d8                	cmp    %ebx,%eax
  8008c6:	74 16                	je     8008de <strncmp+0x35>
  8008c8:	0f b6 08             	movzbl (%eax),%ecx
  8008cb:	84 c9                	test   %cl,%cl
  8008cd:	74 04                	je     8008d3 <strncmp+0x2a>
  8008cf:	3a 0a                	cmp    (%edx),%cl
  8008d1:	74 eb                	je     8008be <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d3:	0f b6 00             	movzbl (%eax),%eax
  8008d6:	0f b6 12             	movzbl (%edx),%edx
  8008d9:	29 d0                	sub    %edx,%eax
}
  8008db:	5b                   	pop    %ebx
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    
		return 0;
  8008de:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e3:	eb f6                	jmp    8008db <strncmp+0x32>

008008e5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008e5:	f3 0f 1e fb          	endbr32 
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f3:	0f b6 10             	movzbl (%eax),%edx
  8008f6:	84 d2                	test   %dl,%dl
  8008f8:	74 09                	je     800903 <strchr+0x1e>
		if (*s == c)
  8008fa:	38 ca                	cmp    %cl,%dl
  8008fc:	74 0a                	je     800908 <strchr+0x23>
	for (; *s; s++)
  8008fe:	83 c0 01             	add    $0x1,%eax
  800901:	eb f0                	jmp    8008f3 <strchr+0xe>
			return (char *) s;
	return 0;
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80090a:	f3 0f 1e fb          	endbr32 
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800918:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80091b:	38 ca                	cmp    %cl,%dl
  80091d:	74 09                	je     800928 <strfind+0x1e>
  80091f:	84 d2                	test   %dl,%dl
  800921:	74 05                	je     800928 <strfind+0x1e>
	for (; *s; s++)
  800923:	83 c0 01             	add    $0x1,%eax
  800926:	eb f0                	jmp    800918 <strfind+0xe>
			break;
	return (char *) s;
}
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80092a:	f3 0f 1e fb          	endbr32 
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	57                   	push   %edi
  800932:	56                   	push   %esi
  800933:	53                   	push   %ebx
  800934:	8b 7d 08             	mov    0x8(%ebp),%edi
  800937:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80093a:	85 c9                	test   %ecx,%ecx
  80093c:	74 31                	je     80096f <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80093e:	89 f8                	mov    %edi,%eax
  800940:	09 c8                	or     %ecx,%eax
  800942:	a8 03                	test   $0x3,%al
  800944:	75 23                	jne    800969 <memset+0x3f>
		c &= 0xFF;
  800946:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80094a:	89 d3                	mov    %edx,%ebx
  80094c:	c1 e3 08             	shl    $0x8,%ebx
  80094f:	89 d0                	mov    %edx,%eax
  800951:	c1 e0 18             	shl    $0x18,%eax
  800954:	89 d6                	mov    %edx,%esi
  800956:	c1 e6 10             	shl    $0x10,%esi
  800959:	09 f0                	or     %esi,%eax
  80095b:	09 c2                	or     %eax,%edx
  80095d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80095f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800962:	89 d0                	mov    %edx,%eax
  800964:	fc                   	cld    
  800965:	f3 ab                	rep stos %eax,%es:(%edi)
  800967:	eb 06                	jmp    80096f <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096c:	fc                   	cld    
  80096d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80096f:	89 f8                	mov    %edi,%eax
  800971:	5b                   	pop    %ebx
  800972:	5e                   	pop    %esi
  800973:	5f                   	pop    %edi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800976:	f3 0f 1e fb          	endbr32 
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	57                   	push   %edi
  80097e:	56                   	push   %esi
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	8b 75 0c             	mov    0xc(%ebp),%esi
  800985:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800988:	39 c6                	cmp    %eax,%esi
  80098a:	73 32                	jae    8009be <memmove+0x48>
  80098c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	76 2b                	jbe    8009be <memmove+0x48>
		s += n;
		d += n;
  800993:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800996:	89 fe                	mov    %edi,%esi
  800998:	09 ce                	or     %ecx,%esi
  80099a:	09 d6                	or     %edx,%esi
  80099c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009a2:	75 0e                	jne    8009b2 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009a4:	83 ef 04             	sub    $0x4,%edi
  8009a7:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009aa:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009ad:	fd                   	std    
  8009ae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b0:	eb 09                	jmp    8009bb <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009b2:	83 ef 01             	sub    $0x1,%edi
  8009b5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009b8:	fd                   	std    
  8009b9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009bb:	fc                   	cld    
  8009bc:	eb 1a                	jmp    8009d8 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	09 ca                	or     %ecx,%edx
  8009c2:	09 f2                	or     %esi,%edx
  8009c4:	f6 c2 03             	test   $0x3,%dl
  8009c7:	75 0a                	jne    8009d3 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009c9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009cc:	89 c7                	mov    %eax,%edi
  8009ce:	fc                   	cld    
  8009cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d1:	eb 05                	jmp    8009d8 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009d3:	89 c7                	mov    %eax,%edi
  8009d5:	fc                   	cld    
  8009d6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d8:	5e                   	pop    %esi
  8009d9:	5f                   	pop    %edi
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009dc:	f3 0f 1e fb          	endbr32 
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009e6:	ff 75 10             	pushl  0x10(%ebp)
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	ff 75 08             	pushl  0x8(%ebp)
  8009ef:	e8 82 ff ff ff       	call   800976 <memmove>
}
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009f6:	f3 0f 1e fb          	endbr32 
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	56                   	push   %esi
  8009fe:	53                   	push   %ebx
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a05:	89 c6                	mov    %eax,%esi
  800a07:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a0a:	39 f0                	cmp    %esi,%eax
  800a0c:	74 1c                	je     800a2a <memcmp+0x34>
		if (*s1 != *s2)
  800a0e:	0f b6 08             	movzbl (%eax),%ecx
  800a11:	0f b6 1a             	movzbl (%edx),%ebx
  800a14:	38 d9                	cmp    %bl,%cl
  800a16:	75 08                	jne    800a20 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a18:	83 c0 01             	add    $0x1,%eax
  800a1b:	83 c2 01             	add    $0x1,%edx
  800a1e:	eb ea                	jmp    800a0a <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a20:	0f b6 c1             	movzbl %cl,%eax
  800a23:	0f b6 db             	movzbl %bl,%ebx
  800a26:	29 d8                	sub    %ebx,%eax
  800a28:	eb 05                	jmp    800a2f <memcmp+0x39>
	}

	return 0;
  800a2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2f:	5b                   	pop    %ebx
  800a30:	5e                   	pop    %esi
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a33:	f3 0f 1e fb          	endbr32 
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a40:	89 c2                	mov    %eax,%edx
  800a42:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a45:	39 d0                	cmp    %edx,%eax
  800a47:	73 09                	jae    800a52 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a49:	38 08                	cmp    %cl,(%eax)
  800a4b:	74 05                	je     800a52 <memfind+0x1f>
	for (; s < ends; s++)
  800a4d:	83 c0 01             	add    $0x1,%eax
  800a50:	eb f3                	jmp    800a45 <memfind+0x12>
			break;
	return (void *) s;
}
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a54:	f3 0f 1e fb          	endbr32 
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	57                   	push   %edi
  800a5c:	56                   	push   %esi
  800a5d:	53                   	push   %ebx
  800a5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a64:	eb 03                	jmp    800a69 <strtol+0x15>
		s++;
  800a66:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a69:	0f b6 01             	movzbl (%ecx),%eax
  800a6c:	3c 20                	cmp    $0x20,%al
  800a6e:	74 f6                	je     800a66 <strtol+0x12>
  800a70:	3c 09                	cmp    $0x9,%al
  800a72:	74 f2                	je     800a66 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a74:	3c 2b                	cmp    $0x2b,%al
  800a76:	74 2a                	je     800aa2 <strtol+0x4e>
	int neg = 0;
  800a78:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a7d:	3c 2d                	cmp    $0x2d,%al
  800a7f:	74 2b                	je     800aac <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a81:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a87:	75 0f                	jne    800a98 <strtol+0x44>
  800a89:	80 39 30             	cmpb   $0x30,(%ecx)
  800a8c:	74 28                	je     800ab6 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a8e:	85 db                	test   %ebx,%ebx
  800a90:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a95:	0f 44 d8             	cmove  %eax,%ebx
  800a98:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aa0:	eb 46                	jmp    800ae8 <strtol+0x94>
		s++;
  800aa2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aa5:	bf 00 00 00 00       	mov    $0x0,%edi
  800aaa:	eb d5                	jmp    800a81 <strtol+0x2d>
		s++, neg = 1;
  800aac:	83 c1 01             	add    $0x1,%ecx
  800aaf:	bf 01 00 00 00       	mov    $0x1,%edi
  800ab4:	eb cb                	jmp    800a81 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aba:	74 0e                	je     800aca <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800abc:	85 db                	test   %ebx,%ebx
  800abe:	75 d8                	jne    800a98 <strtol+0x44>
		s++, base = 8;
  800ac0:	83 c1 01             	add    $0x1,%ecx
  800ac3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ac8:	eb ce                	jmp    800a98 <strtol+0x44>
		s += 2, base = 16;
  800aca:	83 c1 02             	add    $0x2,%ecx
  800acd:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ad2:	eb c4                	jmp    800a98 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ad4:	0f be d2             	movsbl %dl,%edx
  800ad7:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ada:	3b 55 10             	cmp    0x10(%ebp),%edx
  800add:	7d 3a                	jge    800b19 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800adf:	83 c1 01             	add    $0x1,%ecx
  800ae2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ae6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ae8:	0f b6 11             	movzbl (%ecx),%edx
  800aeb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aee:	89 f3                	mov    %esi,%ebx
  800af0:	80 fb 09             	cmp    $0x9,%bl
  800af3:	76 df                	jbe    800ad4 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800af5:	8d 72 9f             	lea    -0x61(%edx),%esi
  800af8:	89 f3                	mov    %esi,%ebx
  800afa:	80 fb 19             	cmp    $0x19,%bl
  800afd:	77 08                	ja     800b07 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aff:	0f be d2             	movsbl %dl,%edx
  800b02:	83 ea 57             	sub    $0x57,%edx
  800b05:	eb d3                	jmp    800ada <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b07:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b0a:	89 f3                	mov    %esi,%ebx
  800b0c:	80 fb 19             	cmp    $0x19,%bl
  800b0f:	77 08                	ja     800b19 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b11:	0f be d2             	movsbl %dl,%edx
  800b14:	83 ea 37             	sub    $0x37,%edx
  800b17:	eb c1                	jmp    800ada <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1d:	74 05                	je     800b24 <strtol+0xd0>
		*endptr = (char *) s;
  800b1f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b22:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b24:	89 c2                	mov    %eax,%edx
  800b26:	f7 da                	neg    %edx
  800b28:	85 ff                	test   %edi,%edi
  800b2a:	0f 45 c2             	cmovne %edx,%eax
}
  800b2d:	5b                   	pop    %ebx
  800b2e:	5e                   	pop    %esi
  800b2f:	5f                   	pop    %edi
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b32:	f3 0f 1e fb          	endbr32 
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	57                   	push   %edi
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b41:	8b 55 08             	mov    0x8(%ebp),%edx
  800b44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b47:	89 c3                	mov    %eax,%ebx
  800b49:	89 c7                	mov    %eax,%edi
  800b4b:	89 c6                	mov    %eax,%esi
  800b4d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5f                   	pop    %edi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b54:	f3 0f 1e fb          	endbr32 
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	57                   	push   %edi
  800b5c:	56                   	push   %esi
  800b5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b63:	b8 01 00 00 00       	mov    $0x1,%eax
  800b68:	89 d1                	mov    %edx,%ecx
  800b6a:	89 d3                	mov    %edx,%ebx
  800b6c:	89 d7                	mov    %edx,%edi
  800b6e:	89 d6                	mov    %edx,%esi
  800b70:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b72:	5b                   	pop    %ebx
  800b73:	5e                   	pop    %esi
  800b74:	5f                   	pop    %edi
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b77:	f3 0f 1e fb          	endbr32 
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	57                   	push   %edi
  800b7f:	56                   	push   %esi
  800b80:	53                   	push   %ebx
  800b81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b84:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b89:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b91:	89 cb                	mov    %ecx,%ebx
  800b93:	89 cf                	mov    %ecx,%edi
  800b95:	89 ce                	mov    %ecx,%esi
  800b97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b99:	85 c0                	test   %eax,%eax
  800b9b:	7f 08                	jg     800ba5 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba5:	83 ec 0c             	sub    $0xc,%esp
  800ba8:	50                   	push   %eax
  800ba9:	6a 03                	push   $0x3
  800bab:	68 c4 16 80 00       	push   $0x8016c4
  800bb0:	6a 23                	push   $0x23
  800bb2:	68 e1 16 80 00       	push   $0x8016e1
  800bb7:	e8 dc 04 00 00       	call   801098 <_panic>

00800bbc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bbc:	f3 0f 1e fb          	endbr32 
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	57                   	push   %edi
  800bc4:	56                   	push   %esi
  800bc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	b8 02 00 00 00       	mov    $0x2,%eax
  800bd0:	89 d1                	mov    %edx,%ecx
  800bd2:	89 d3                	mov    %edx,%ebx
  800bd4:	89 d7                	mov    %edx,%edi
  800bd6:	89 d6                	mov    %edx,%esi
  800bd8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bda:	5b                   	pop    %ebx
  800bdb:	5e                   	pop    %esi
  800bdc:	5f                   	pop    %edi
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <sys_yield>:

void
sys_yield(void)
{
  800bdf:	f3 0f 1e fb          	endbr32 
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bee:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bf3:	89 d1                	mov    %edx,%ecx
  800bf5:	89 d3                	mov    %edx,%ebx
  800bf7:	89 d7                	mov    %edx,%edi
  800bf9:	89 d6                	mov    %edx,%esi
  800bfb:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bfd:	5b                   	pop    %ebx
  800bfe:	5e                   	pop    %esi
  800bff:	5f                   	pop    %edi
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c02:	f3 0f 1e fb          	endbr32 
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	57                   	push   %edi
  800c0a:	56                   	push   %esi
  800c0b:	53                   	push   %ebx
  800c0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c0f:	be 00 00 00 00       	mov    $0x0,%esi
  800c14:	8b 55 08             	mov    0x8(%ebp),%edx
  800c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c22:	89 f7                	mov    %esi,%edi
  800c24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c26:	85 c0                	test   %eax,%eax
  800c28:	7f 08                	jg     800c32 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c32:	83 ec 0c             	sub    $0xc,%esp
  800c35:	50                   	push   %eax
  800c36:	6a 04                	push   $0x4
  800c38:	68 c4 16 80 00       	push   $0x8016c4
  800c3d:	6a 23                	push   $0x23
  800c3f:	68 e1 16 80 00       	push   $0x8016e1
  800c44:	e8 4f 04 00 00       	call   801098 <_panic>

00800c49 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c49:	f3 0f 1e fb          	endbr32 
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	57                   	push   %edi
  800c51:	56                   	push   %esi
  800c52:	53                   	push   %ebx
  800c53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c56:	8b 55 08             	mov    0x8(%ebp),%edx
  800c59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5c:	b8 05 00 00 00       	mov    $0x5,%eax
  800c61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c64:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c67:	8b 75 18             	mov    0x18(%ebp),%esi
  800c6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6c:	85 c0                	test   %eax,%eax
  800c6e:	7f 08                	jg     800c78 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c73:	5b                   	pop    %ebx
  800c74:	5e                   	pop    %esi
  800c75:	5f                   	pop    %edi
  800c76:	5d                   	pop    %ebp
  800c77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c78:	83 ec 0c             	sub    $0xc,%esp
  800c7b:	50                   	push   %eax
  800c7c:	6a 05                	push   $0x5
  800c7e:	68 c4 16 80 00       	push   $0x8016c4
  800c83:	6a 23                	push   $0x23
  800c85:	68 e1 16 80 00       	push   $0x8016e1
  800c8a:	e8 09 04 00 00       	call   801098 <_panic>

00800c8f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c8f:	f3 0f 1e fb          	endbr32 
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca7:	b8 06 00 00 00       	mov    $0x6,%eax
  800cac:	89 df                	mov    %ebx,%edi
  800cae:	89 de                	mov    %ebx,%esi
  800cb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb2:	85 c0                	test   %eax,%eax
  800cb4:	7f 08                	jg     800cbe <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb9:	5b                   	pop    %ebx
  800cba:	5e                   	pop    %esi
  800cbb:	5f                   	pop    %edi
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbe:	83 ec 0c             	sub    $0xc,%esp
  800cc1:	50                   	push   %eax
  800cc2:	6a 06                	push   $0x6
  800cc4:	68 c4 16 80 00       	push   $0x8016c4
  800cc9:	6a 23                	push   $0x23
  800ccb:	68 e1 16 80 00       	push   $0x8016e1
  800cd0:	e8 c3 03 00 00       	call   801098 <_panic>

00800cd5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cd5:	f3 0f 1e fb          	endbr32 
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ced:	b8 08 00 00 00       	mov    $0x8,%eax
  800cf2:	89 df                	mov    %ebx,%edi
  800cf4:	89 de                	mov    %ebx,%esi
  800cf6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf8:	85 c0                	test   %eax,%eax
  800cfa:	7f 08                	jg     800d04 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d04:	83 ec 0c             	sub    $0xc,%esp
  800d07:	50                   	push   %eax
  800d08:	6a 08                	push   $0x8
  800d0a:	68 c4 16 80 00       	push   $0x8016c4
  800d0f:	6a 23                	push   $0x23
  800d11:	68 e1 16 80 00       	push   $0x8016e1
  800d16:	e8 7d 03 00 00       	call   801098 <_panic>

00800d1b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d1b:	f3 0f 1e fb          	endbr32 
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	57                   	push   %edi
  800d23:	56                   	push   %esi
  800d24:	53                   	push   %ebx
  800d25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d33:	b8 09 00 00 00       	mov    $0x9,%eax
  800d38:	89 df                	mov    %ebx,%edi
  800d3a:	89 de                	mov    %ebx,%esi
  800d3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3e:	85 c0                	test   %eax,%eax
  800d40:	7f 08                	jg     800d4a <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4a:	83 ec 0c             	sub    $0xc,%esp
  800d4d:	50                   	push   %eax
  800d4e:	6a 09                	push   $0x9
  800d50:	68 c4 16 80 00       	push   $0x8016c4
  800d55:	6a 23                	push   $0x23
  800d57:	68 e1 16 80 00       	push   $0x8016e1
  800d5c:	e8 37 03 00 00       	call   801098 <_panic>

00800d61 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d61:	f3 0f 1e fb          	endbr32 
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	57                   	push   %edi
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d71:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d76:	be 00 00 00 00       	mov    $0x0,%esi
  800d7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d81:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d88:	f3 0f 1e fb          	endbr32 
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
  800d92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d95:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da2:	89 cb                	mov    %ecx,%ebx
  800da4:	89 cf                	mov    %ecx,%edi
  800da6:	89 ce                	mov    %ecx,%esi
  800da8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800daa:	85 c0                	test   %eax,%eax
  800dac:	7f 08                	jg     800db6 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db6:	83 ec 0c             	sub    $0xc,%esp
  800db9:	50                   	push   %eax
  800dba:	6a 0c                	push   $0xc
  800dbc:	68 c4 16 80 00       	push   $0x8016c4
  800dc1:	6a 23                	push   $0x23
  800dc3:	68 e1 16 80 00       	push   $0x8016e1
  800dc8:	e8 cb 02 00 00       	call   801098 <_panic>

00800dcd <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800dcd:	f3 0f 1e fb          	endbr32 
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	53                   	push   %ebx
  800dd5:	83 ec 04             	sub    $0x4,%esp
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ddb:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800ddd:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800de1:	74 74                	je     800e57 <pgfault+0x8a>
  800de3:	89 d8                	mov    %ebx,%eax
  800de5:	c1 e8 0c             	shr    $0xc,%eax
  800de8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800def:	f6 c4 08             	test   $0x8,%ah
  800df2:	74 63                	je     800e57 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800df4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800dfa:	83 ec 0c             	sub    $0xc,%esp
  800dfd:	6a 05                	push   $0x5
  800dff:	68 00 f0 7f 00       	push   $0x7ff000
  800e04:	6a 00                	push   $0x0
  800e06:	53                   	push   %ebx
  800e07:	6a 00                	push   $0x0
  800e09:	e8 3b fe ff ff       	call   800c49 <sys_page_map>
  800e0e:	83 c4 20             	add    $0x20,%esp
  800e11:	85 c0                	test   %eax,%eax
  800e13:	78 59                	js     800e6e <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800e15:	83 ec 04             	sub    $0x4,%esp
  800e18:	6a 07                	push   $0x7
  800e1a:	53                   	push   %ebx
  800e1b:	6a 00                	push   $0x0
  800e1d:	e8 e0 fd ff ff       	call   800c02 <sys_page_alloc>
  800e22:	83 c4 10             	add    $0x10,%esp
  800e25:	85 c0                	test   %eax,%eax
  800e27:	78 5a                	js     800e83 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800e29:	83 ec 04             	sub    $0x4,%esp
  800e2c:	68 00 10 00 00       	push   $0x1000
  800e31:	68 00 f0 7f 00       	push   $0x7ff000
  800e36:	53                   	push   %ebx
  800e37:	e8 3a fb ff ff       	call   800976 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800e3c:	83 c4 08             	add    $0x8,%esp
  800e3f:	68 00 f0 7f 00       	push   $0x7ff000
  800e44:	6a 00                	push   $0x0
  800e46:	e8 44 fe ff ff       	call   800c8f <sys_page_unmap>
  800e4b:	83 c4 10             	add    $0x10,%esp
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	78 46                	js     800e98 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800e52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800e57:	83 ec 04             	sub    $0x4,%esp
  800e5a:	68 ef 16 80 00       	push   $0x8016ef
  800e5f:	68 d3 00 00 00       	push   $0xd3
  800e64:	68 0b 17 80 00       	push   $0x80170b
  800e69:	e8 2a 02 00 00       	call   801098 <_panic>
		panic("pgfault: %e\n", r);
  800e6e:	50                   	push   %eax
  800e6f:	68 16 17 80 00       	push   $0x801716
  800e74:	68 df 00 00 00       	push   $0xdf
  800e79:	68 0b 17 80 00       	push   $0x80170b
  800e7e:	e8 15 02 00 00       	call   801098 <_panic>
		panic("pgfault: %e\n", r);
  800e83:	50                   	push   %eax
  800e84:	68 16 17 80 00       	push   $0x801716
  800e89:	68 e3 00 00 00       	push   $0xe3
  800e8e:	68 0b 17 80 00       	push   $0x80170b
  800e93:	e8 00 02 00 00       	call   801098 <_panic>
		panic("pgfault: %e\n", r);
  800e98:	50                   	push   %eax
  800e99:	68 16 17 80 00       	push   $0x801716
  800e9e:	68 e9 00 00 00       	push   $0xe9
  800ea3:	68 0b 17 80 00       	push   $0x80170b
  800ea8:	e8 eb 01 00 00       	call   801098 <_panic>

00800ead <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ead:	f3 0f 1e fb          	endbr32 
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	57                   	push   %edi
  800eb5:	56                   	push   %esi
  800eb6:	53                   	push   %ebx
  800eb7:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800eba:	68 cd 0d 80 00       	push   $0x800dcd
  800ebf:	e8 1e 02 00 00       	call   8010e2 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800ec4:	b8 07 00 00 00       	mov    $0x7,%eax
  800ec9:	cd 30                	int    $0x30
  800ecb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800ece:	83 c4 10             	add    $0x10,%esp
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	78 2d                	js     800f02 <fork+0x55>
  800ed5:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800ed7:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800edc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee0:	0f 85 81 00 00 00    	jne    800f67 <fork+0xba>
		thisenv = &envs[ENVX(sys_getenvid())];
  800ee6:	e8 d1 fc ff ff       	call   800bbc <sys_getenvid>
  800eeb:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ef0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ef3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ef8:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  800efd:	e9 43 01 00 00       	jmp    801045 <fork+0x198>
		panic("sys_exofork: %e", envid);
  800f02:	50                   	push   %eax
  800f03:	68 23 17 80 00       	push   $0x801723
  800f08:	68 26 01 00 00       	push   $0x126
  800f0d:	68 0b 17 80 00       	push   $0x80170b
  800f12:	e8 81 01 00 00       	call   801098 <_panic>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800f17:	c1 e6 0c             	shl    $0xc,%esi
  800f1a:	83 ec 0c             	sub    $0xc,%esp
  800f1d:	68 05 08 00 00       	push   $0x805
  800f22:	56                   	push   %esi
  800f23:	57                   	push   %edi
  800f24:	56                   	push   %esi
  800f25:	6a 00                	push   $0x0
  800f27:	e8 1d fd ff ff       	call   800c49 <sys_page_map>
  800f2c:	83 c4 20             	add    $0x20,%esp
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	0f 88 a8 00 00 00    	js     800fdf <fork+0x132>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  800f37:	83 ec 0c             	sub    $0xc,%esp
  800f3a:	68 05 08 00 00       	push   $0x805
  800f3f:	56                   	push   %esi
  800f40:	6a 00                	push   $0x0
  800f42:	56                   	push   %esi
  800f43:	6a 00                	push   $0x0
  800f45:	e8 ff fc ff ff       	call   800c49 <sys_page_map>
  800f4a:	83 c4 20             	add    $0x20,%esp
  800f4d:	85 c0                	test   %eax,%eax
  800f4f:	0f 88 9f 00 00 00    	js     800ff4 <fork+0x147>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f5b:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800f61:	0f 84 a2 00 00 00    	je     801009 <fork+0x15c>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  800f67:	89 d8                	mov    %ebx,%eax
  800f69:	c1 e8 16             	shr    $0x16,%eax
  800f6c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f73:	a8 01                	test   $0x1,%al
  800f75:	74 de                	je     800f55 <fork+0xa8>
  800f77:	89 de                	mov    %ebx,%esi
  800f79:	c1 ee 0c             	shr    $0xc,%esi
  800f7c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800f83:	a8 01                	test   $0x1,%al
  800f85:	74 ce                	je     800f55 <fork+0xa8>
  800f87:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800f8e:	a8 04                	test   $0x4,%al
  800f90:	74 c3                	je     800f55 <fork+0xa8>
	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800f92:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800f99:	a8 02                	test   $0x2,%al
  800f9b:	0f 85 76 ff ff ff    	jne    800f17 <fork+0x6a>
  800fa1:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fa8:	f6 c4 08             	test   $0x8,%ah
  800fab:	0f 85 66 ff ff ff    	jne    800f17 <fork+0x6a>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800fb1:	c1 e6 0c             	shl    $0xc,%esi
  800fb4:	83 ec 0c             	sub    $0xc,%esp
  800fb7:	6a 05                	push   $0x5
  800fb9:	56                   	push   %esi
  800fba:	57                   	push   %edi
  800fbb:	56                   	push   %esi
  800fbc:	6a 00                	push   $0x0
  800fbe:	e8 86 fc ff ff       	call   800c49 <sys_page_map>
  800fc3:	83 c4 20             	add    $0x20,%esp
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	79 8b                	jns    800f55 <fork+0xa8>
		panic("duppage: %e\n", r);
  800fca:	50                   	push   %eax
  800fcb:	68 33 17 80 00       	push   $0x801733
  800fd0:	68 08 01 00 00       	push   $0x108
  800fd5:	68 0b 17 80 00       	push   $0x80170b
  800fda:	e8 b9 00 00 00       	call   801098 <_panic>
			panic("duppage: %e\n", r);
  800fdf:	50                   	push   %eax
  800fe0:	68 33 17 80 00       	push   $0x801733
  800fe5:	68 01 01 00 00       	push   $0x101
  800fea:	68 0b 17 80 00       	push   $0x80170b
  800fef:	e8 a4 00 00 00       	call   801098 <_panic>
			panic("duppage: %e\n", r);
  800ff4:	50                   	push   %eax
  800ff5:	68 33 17 80 00       	push   $0x801733
  800ffa:	68 05 01 00 00       	push   $0x105
  800fff:	68 0b 17 80 00       	push   $0x80170b
  801004:	e8 8f 00 00 00       	call   801098 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801009:	83 ec 04             	sub    $0x4,%esp
  80100c:	6a 07                	push   $0x7
  80100e:	68 00 f0 bf ee       	push   $0xeebff000
  801013:	ff 75 e4             	pushl  -0x1c(%ebp)
  801016:	e8 e7 fb ff ff       	call   800c02 <sys_page_alloc>
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	85 c0                	test   %eax,%eax
  801020:	78 2e                	js     801050 <fork+0x1a3>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801022:	83 ec 08             	sub    $0x8,%esp
  801025:	68 55 11 80 00       	push   $0x801155
  80102a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80102d:	57                   	push   %edi
  80102e:	e8 e8 fc ff ff       	call   800d1b <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801033:	83 c4 08             	add    $0x8,%esp
  801036:	6a 02                	push   $0x2
  801038:	57                   	push   %edi
  801039:	e8 97 fc ff ff       	call   800cd5 <sys_env_set_status>
  80103e:	83 c4 10             	add    $0x10,%esp
  801041:	85 c0                	test   %eax,%eax
  801043:	78 20                	js     801065 <fork+0x1b8>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801045:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801048:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104b:	5b                   	pop    %ebx
  80104c:	5e                   	pop    %esi
  80104d:	5f                   	pop    %edi
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801050:	50                   	push   %eax
  801051:	68 40 17 80 00       	push   $0x801740
  801056:	68 3a 01 00 00       	push   $0x13a
  80105b:	68 0b 17 80 00       	push   $0x80170b
  801060:	e8 33 00 00 00       	call   801098 <_panic>
		panic("sys_env_set_status: %e", r);
  801065:	50                   	push   %eax
  801066:	68 53 17 80 00       	push   $0x801753
  80106b:	68 3f 01 00 00       	push   $0x13f
  801070:	68 0b 17 80 00       	push   $0x80170b
  801075:	e8 1e 00 00 00       	call   801098 <_panic>

0080107a <sfork>:

// Challenge!
int
sfork(void)
{
  80107a:	f3 0f 1e fb          	endbr32 
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801084:	68 6a 17 80 00       	push   $0x80176a
  801089:	68 48 01 00 00       	push   $0x148
  80108e:	68 0b 17 80 00       	push   $0x80170b
  801093:	e8 00 00 00 00       	call   801098 <_panic>

00801098 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801098:	f3 0f 1e fb          	endbr32 
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	56                   	push   %esi
  8010a0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010a1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010a4:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8010aa:	e8 0d fb ff ff       	call   800bbc <sys_getenvid>
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	ff 75 0c             	pushl  0xc(%ebp)
  8010b5:	ff 75 08             	pushl  0x8(%ebp)
  8010b8:	56                   	push   %esi
  8010b9:	50                   	push   %eax
  8010ba:	68 80 17 80 00       	push   $0x801780
  8010bf:	e8 f2 f0 ff ff       	call   8001b6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010c4:	83 c4 18             	add    $0x18,%esp
  8010c7:	53                   	push   %ebx
  8010c8:	ff 75 10             	pushl  0x10(%ebp)
  8010cb:	e8 91 f0 ff ff       	call   800161 <vcprintf>
	cprintf("\n");
  8010d0:	c7 04 24 74 14 80 00 	movl   $0x801474,(%esp)
  8010d7:	e8 da f0 ff ff       	call   8001b6 <cprintf>
  8010dc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8010df:	cc                   	int3   
  8010e0:	eb fd                	jmp    8010df <_panic+0x47>

008010e2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8010e2:	f3 0f 1e fb          	endbr32 
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8010ec:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8010f3:	74 0a                	je     8010ff <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	a3 08 20 80 00       	mov    %eax,0x802008
}
  8010fd:	c9                   	leave  
  8010fe:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  8010ff:	83 ec 04             	sub    $0x4,%esp
  801102:	6a 07                	push   $0x7
  801104:	68 00 f0 bf ee       	push   $0xeebff000
  801109:	6a 00                	push   $0x0
  80110b:	e8 f2 fa ff ff       	call   800c02 <sys_page_alloc>
  801110:	83 c4 10             	add    $0x10,%esp
  801113:	85 c0                	test   %eax,%eax
  801115:	78 2a                	js     801141 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	68 55 11 80 00       	push   $0x801155
  80111f:	6a 00                	push   $0x0
  801121:	e8 f5 fb ff ff       	call   800d1b <sys_env_set_pgfault_upcall>
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	85 c0                	test   %eax,%eax
  80112b:	79 c8                	jns    8010f5 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 d0 17 80 00       	push   $0x8017d0
  801135:	6a 25                	push   $0x25
  801137:	68 08 18 80 00       	push   $0x801808
  80113c:	e8 57 ff ff ff       	call   801098 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  801141:	83 ec 04             	sub    $0x4,%esp
  801144:	68 a4 17 80 00       	push   $0x8017a4
  801149:	6a 22                	push   $0x22
  80114b:	68 08 18 80 00       	push   $0x801808
  801150:	e8 43 ff ff ff       	call   801098 <_panic>

00801155 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801155:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801156:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  80115b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80115d:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  801160:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801164:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801168:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80116b:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80116d:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  801171:	83 c4 08             	add    $0x8,%esp
	popal
  801174:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  801175:	83 c4 04             	add    $0x4,%esp
	popfl
  801178:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  801179:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  80117a:	c3                   	ret    
  80117b:	66 90                	xchg   %ax,%ax
  80117d:	66 90                	xchg   %ax,%ax
  80117f:	90                   	nop

00801180 <__udivdi3>:
  801180:	f3 0f 1e fb          	endbr32 
  801184:	55                   	push   %ebp
  801185:	57                   	push   %edi
  801186:	56                   	push   %esi
  801187:	53                   	push   %ebx
  801188:	83 ec 1c             	sub    $0x1c,%esp
  80118b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80118f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801193:	8b 74 24 34          	mov    0x34(%esp),%esi
  801197:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80119b:	85 d2                	test   %edx,%edx
  80119d:	75 19                	jne    8011b8 <__udivdi3+0x38>
  80119f:	39 f3                	cmp    %esi,%ebx
  8011a1:	76 4d                	jbe    8011f0 <__udivdi3+0x70>
  8011a3:	31 ff                	xor    %edi,%edi
  8011a5:	89 e8                	mov    %ebp,%eax
  8011a7:	89 f2                	mov    %esi,%edx
  8011a9:	f7 f3                	div    %ebx
  8011ab:	89 fa                	mov    %edi,%edx
  8011ad:	83 c4 1c             	add    $0x1c,%esp
  8011b0:	5b                   	pop    %ebx
  8011b1:	5e                   	pop    %esi
  8011b2:	5f                   	pop    %edi
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    
  8011b5:	8d 76 00             	lea    0x0(%esi),%esi
  8011b8:	39 f2                	cmp    %esi,%edx
  8011ba:	76 14                	jbe    8011d0 <__udivdi3+0x50>
  8011bc:	31 ff                	xor    %edi,%edi
  8011be:	31 c0                	xor    %eax,%eax
  8011c0:	89 fa                	mov    %edi,%edx
  8011c2:	83 c4 1c             	add    $0x1c,%esp
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    
  8011ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011d0:	0f bd fa             	bsr    %edx,%edi
  8011d3:	83 f7 1f             	xor    $0x1f,%edi
  8011d6:	75 48                	jne    801220 <__udivdi3+0xa0>
  8011d8:	39 f2                	cmp    %esi,%edx
  8011da:	72 06                	jb     8011e2 <__udivdi3+0x62>
  8011dc:	31 c0                	xor    %eax,%eax
  8011de:	39 eb                	cmp    %ebp,%ebx
  8011e0:	77 de                	ja     8011c0 <__udivdi3+0x40>
  8011e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8011e7:	eb d7                	jmp    8011c0 <__udivdi3+0x40>
  8011e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011f0:	89 d9                	mov    %ebx,%ecx
  8011f2:	85 db                	test   %ebx,%ebx
  8011f4:	75 0b                	jne    801201 <__udivdi3+0x81>
  8011f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8011fb:	31 d2                	xor    %edx,%edx
  8011fd:	f7 f3                	div    %ebx
  8011ff:	89 c1                	mov    %eax,%ecx
  801201:	31 d2                	xor    %edx,%edx
  801203:	89 f0                	mov    %esi,%eax
  801205:	f7 f1                	div    %ecx
  801207:	89 c6                	mov    %eax,%esi
  801209:	89 e8                	mov    %ebp,%eax
  80120b:	89 f7                	mov    %esi,%edi
  80120d:	f7 f1                	div    %ecx
  80120f:	89 fa                	mov    %edi,%edx
  801211:	83 c4 1c             	add    $0x1c,%esp
  801214:	5b                   	pop    %ebx
  801215:	5e                   	pop    %esi
  801216:	5f                   	pop    %edi
  801217:	5d                   	pop    %ebp
  801218:	c3                   	ret    
  801219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801220:	89 f9                	mov    %edi,%ecx
  801222:	b8 20 00 00 00       	mov    $0x20,%eax
  801227:	29 f8                	sub    %edi,%eax
  801229:	d3 e2                	shl    %cl,%edx
  80122b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80122f:	89 c1                	mov    %eax,%ecx
  801231:	89 da                	mov    %ebx,%edx
  801233:	d3 ea                	shr    %cl,%edx
  801235:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801239:	09 d1                	or     %edx,%ecx
  80123b:	89 f2                	mov    %esi,%edx
  80123d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801241:	89 f9                	mov    %edi,%ecx
  801243:	d3 e3                	shl    %cl,%ebx
  801245:	89 c1                	mov    %eax,%ecx
  801247:	d3 ea                	shr    %cl,%edx
  801249:	89 f9                	mov    %edi,%ecx
  80124b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80124f:	89 eb                	mov    %ebp,%ebx
  801251:	d3 e6                	shl    %cl,%esi
  801253:	89 c1                	mov    %eax,%ecx
  801255:	d3 eb                	shr    %cl,%ebx
  801257:	09 de                	or     %ebx,%esi
  801259:	89 f0                	mov    %esi,%eax
  80125b:	f7 74 24 08          	divl   0x8(%esp)
  80125f:	89 d6                	mov    %edx,%esi
  801261:	89 c3                	mov    %eax,%ebx
  801263:	f7 64 24 0c          	mull   0xc(%esp)
  801267:	39 d6                	cmp    %edx,%esi
  801269:	72 15                	jb     801280 <__udivdi3+0x100>
  80126b:	89 f9                	mov    %edi,%ecx
  80126d:	d3 e5                	shl    %cl,%ebp
  80126f:	39 c5                	cmp    %eax,%ebp
  801271:	73 04                	jae    801277 <__udivdi3+0xf7>
  801273:	39 d6                	cmp    %edx,%esi
  801275:	74 09                	je     801280 <__udivdi3+0x100>
  801277:	89 d8                	mov    %ebx,%eax
  801279:	31 ff                	xor    %edi,%edi
  80127b:	e9 40 ff ff ff       	jmp    8011c0 <__udivdi3+0x40>
  801280:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801283:	31 ff                	xor    %edi,%edi
  801285:	e9 36 ff ff ff       	jmp    8011c0 <__udivdi3+0x40>
  80128a:	66 90                	xchg   %ax,%ax
  80128c:	66 90                	xchg   %ax,%ax
  80128e:	66 90                	xchg   %ax,%ax

00801290 <__umoddi3>:
  801290:	f3 0f 1e fb          	endbr32 
  801294:	55                   	push   %ebp
  801295:	57                   	push   %edi
  801296:	56                   	push   %esi
  801297:	53                   	push   %ebx
  801298:	83 ec 1c             	sub    $0x1c,%esp
  80129b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80129f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8012a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8012a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	75 19                	jne    8012c8 <__umoddi3+0x38>
  8012af:	39 df                	cmp    %ebx,%edi
  8012b1:	76 5d                	jbe    801310 <__umoddi3+0x80>
  8012b3:	89 f0                	mov    %esi,%eax
  8012b5:	89 da                	mov    %ebx,%edx
  8012b7:	f7 f7                	div    %edi
  8012b9:	89 d0                	mov    %edx,%eax
  8012bb:	31 d2                	xor    %edx,%edx
  8012bd:	83 c4 1c             	add    $0x1c,%esp
  8012c0:	5b                   	pop    %ebx
  8012c1:	5e                   	pop    %esi
  8012c2:	5f                   	pop    %edi
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    
  8012c5:	8d 76 00             	lea    0x0(%esi),%esi
  8012c8:	89 f2                	mov    %esi,%edx
  8012ca:	39 d8                	cmp    %ebx,%eax
  8012cc:	76 12                	jbe    8012e0 <__umoddi3+0x50>
  8012ce:	89 f0                	mov    %esi,%eax
  8012d0:	89 da                	mov    %ebx,%edx
  8012d2:	83 c4 1c             	add    $0x1c,%esp
  8012d5:	5b                   	pop    %ebx
  8012d6:	5e                   	pop    %esi
  8012d7:	5f                   	pop    %edi
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    
  8012da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012e0:	0f bd e8             	bsr    %eax,%ebp
  8012e3:	83 f5 1f             	xor    $0x1f,%ebp
  8012e6:	75 50                	jne    801338 <__umoddi3+0xa8>
  8012e8:	39 d8                	cmp    %ebx,%eax
  8012ea:	0f 82 e0 00 00 00    	jb     8013d0 <__umoddi3+0x140>
  8012f0:	89 d9                	mov    %ebx,%ecx
  8012f2:	39 f7                	cmp    %esi,%edi
  8012f4:	0f 86 d6 00 00 00    	jbe    8013d0 <__umoddi3+0x140>
  8012fa:	89 d0                	mov    %edx,%eax
  8012fc:	89 ca                	mov    %ecx,%edx
  8012fe:	83 c4 1c             	add    $0x1c,%esp
  801301:	5b                   	pop    %ebx
  801302:	5e                   	pop    %esi
  801303:	5f                   	pop    %edi
  801304:	5d                   	pop    %ebp
  801305:	c3                   	ret    
  801306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80130d:	8d 76 00             	lea    0x0(%esi),%esi
  801310:	89 fd                	mov    %edi,%ebp
  801312:	85 ff                	test   %edi,%edi
  801314:	75 0b                	jne    801321 <__umoddi3+0x91>
  801316:	b8 01 00 00 00       	mov    $0x1,%eax
  80131b:	31 d2                	xor    %edx,%edx
  80131d:	f7 f7                	div    %edi
  80131f:	89 c5                	mov    %eax,%ebp
  801321:	89 d8                	mov    %ebx,%eax
  801323:	31 d2                	xor    %edx,%edx
  801325:	f7 f5                	div    %ebp
  801327:	89 f0                	mov    %esi,%eax
  801329:	f7 f5                	div    %ebp
  80132b:	89 d0                	mov    %edx,%eax
  80132d:	31 d2                	xor    %edx,%edx
  80132f:	eb 8c                	jmp    8012bd <__umoddi3+0x2d>
  801331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801338:	89 e9                	mov    %ebp,%ecx
  80133a:	ba 20 00 00 00       	mov    $0x20,%edx
  80133f:	29 ea                	sub    %ebp,%edx
  801341:	d3 e0                	shl    %cl,%eax
  801343:	89 44 24 08          	mov    %eax,0x8(%esp)
  801347:	89 d1                	mov    %edx,%ecx
  801349:	89 f8                	mov    %edi,%eax
  80134b:	d3 e8                	shr    %cl,%eax
  80134d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801351:	89 54 24 04          	mov    %edx,0x4(%esp)
  801355:	8b 54 24 04          	mov    0x4(%esp),%edx
  801359:	09 c1                	or     %eax,%ecx
  80135b:	89 d8                	mov    %ebx,%eax
  80135d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801361:	89 e9                	mov    %ebp,%ecx
  801363:	d3 e7                	shl    %cl,%edi
  801365:	89 d1                	mov    %edx,%ecx
  801367:	d3 e8                	shr    %cl,%eax
  801369:	89 e9                	mov    %ebp,%ecx
  80136b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80136f:	d3 e3                	shl    %cl,%ebx
  801371:	89 c7                	mov    %eax,%edi
  801373:	89 d1                	mov    %edx,%ecx
  801375:	89 f0                	mov    %esi,%eax
  801377:	d3 e8                	shr    %cl,%eax
  801379:	89 e9                	mov    %ebp,%ecx
  80137b:	89 fa                	mov    %edi,%edx
  80137d:	d3 e6                	shl    %cl,%esi
  80137f:	09 d8                	or     %ebx,%eax
  801381:	f7 74 24 08          	divl   0x8(%esp)
  801385:	89 d1                	mov    %edx,%ecx
  801387:	89 f3                	mov    %esi,%ebx
  801389:	f7 64 24 0c          	mull   0xc(%esp)
  80138d:	89 c6                	mov    %eax,%esi
  80138f:	89 d7                	mov    %edx,%edi
  801391:	39 d1                	cmp    %edx,%ecx
  801393:	72 06                	jb     80139b <__umoddi3+0x10b>
  801395:	75 10                	jne    8013a7 <__umoddi3+0x117>
  801397:	39 c3                	cmp    %eax,%ebx
  801399:	73 0c                	jae    8013a7 <__umoddi3+0x117>
  80139b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80139f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8013a3:	89 d7                	mov    %edx,%edi
  8013a5:	89 c6                	mov    %eax,%esi
  8013a7:	89 ca                	mov    %ecx,%edx
  8013a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8013ae:	29 f3                	sub    %esi,%ebx
  8013b0:	19 fa                	sbb    %edi,%edx
  8013b2:	89 d0                	mov    %edx,%eax
  8013b4:	d3 e0                	shl    %cl,%eax
  8013b6:	89 e9                	mov    %ebp,%ecx
  8013b8:	d3 eb                	shr    %cl,%ebx
  8013ba:	d3 ea                	shr    %cl,%edx
  8013bc:	09 d8                	or     %ebx,%eax
  8013be:	83 c4 1c             	add    $0x1c,%esp
  8013c1:	5b                   	pop    %ebx
  8013c2:	5e                   	pop    %esi
  8013c3:	5f                   	pop    %edi
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    
  8013c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8013cd:	8d 76 00             	lea    0x0(%esi),%esi
  8013d0:	29 fe                	sub    %edi,%esi
  8013d2:	19 c3                	sbb    %eax,%ebx
  8013d4:	89 f2                	mov    %esi,%edx
  8013d6:	89 d9                	mov    %ebx,%ecx
  8013d8:	e9 1d ff ff ff       	jmp    8012fa <__umoddi3+0x6a>
