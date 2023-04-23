
obj/user/spin.debug:     file format elf32-i386


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
  80003e:	68 80 28 80 00       	push   $0x802880
  800043:	e8 76 01 00 00       	call   8001be <cprintf>
	if ((env = fork()) == 0) {
  800048:	e8 5d 0f 00 00       	call   800faa <fork>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	85 c0                	test   %eax,%eax
  800052:	75 12                	jne    800066 <umain+0x33>
		cprintf("I am the child.  Spinning...\n");
  800054:	83 ec 0c             	sub    $0xc,%esp
  800057:	68 f8 28 80 00       	push   $0x8028f8
  80005c:	e8 5d 01 00 00       	call   8001be <cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
  800064:	eb fe                	jmp    800064 <umain+0x31>
  800066:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800068:	83 ec 0c             	sub    $0xc,%esp
  80006b:	68 a8 28 80 00       	push   $0x8028a8
  800070:	e8 49 01 00 00       	call   8001be <cprintf>
	sys_yield();
  800075:	e8 6d 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  80007a:	e8 68 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  80007f:	e8 63 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800084:	e8 5e 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800089:	e8 59 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  80008e:	e8 54 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800093:	e8 4f 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800098:	e8 4a 0b 00 00       	call   800be7 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  80009d:	c7 04 24 d0 28 80 00 	movl   $0x8028d0,(%esp)
  8000a4:	e8 15 01 00 00       	call   8001be <cprintf>
	sys_env_destroy(env);
  8000a9:	89 1c 24             	mov    %ebx,(%esp)
  8000ac:	e8 ce 0a 00 00       	call   800b7f <sys_env_destroy>
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
  8000c8:	e8 f7 0a 00 00       	call   800bc4 <sys_getenvid>
  8000cd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000da:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000df:	85 db                	test   %ebx,%ebx
  8000e1:	7e 07                	jle    8000ea <libmain+0x31>
		binaryname = argv[0];
  8000e3:	8b 06                	mov    (%esi),%eax
  8000e5:	a3 00 30 80 00       	mov    %eax,0x803000

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
  80010a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80010d:	e8 a5 12 00 00       	call   8013b7 <close_all>
	sys_env_destroy(0);
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	6a 00                	push   $0x0
  800117:	e8 63 0a 00 00       	call   800b7f <sys_env_destroy>
}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	c9                   	leave  
  800120:	c3                   	ret    

00800121 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800121:	f3 0f 1e fb          	endbr32 
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	53                   	push   %ebx
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012f:	8b 13                	mov    (%ebx),%edx
  800131:	8d 42 01             	lea    0x1(%edx),%eax
  800134:	89 03                	mov    %eax,(%ebx)
  800136:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800139:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80013d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800142:	74 09                	je     80014d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800144:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80014d:	83 ec 08             	sub    $0x8,%esp
  800150:	68 ff 00 00 00       	push   $0xff
  800155:	8d 43 08             	lea    0x8(%ebx),%eax
  800158:	50                   	push   %eax
  800159:	e8 dc 09 00 00       	call   800b3a <sys_cputs>
		b->idx = 0;
  80015e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	eb db                	jmp    800144 <putch+0x23>

00800169 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800169:	f3 0f 1e fb          	endbr32 
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800176:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80017d:	00 00 00 
	b.cnt = 0;
  800180:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800187:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80018a:	ff 75 0c             	pushl  0xc(%ebp)
  80018d:	ff 75 08             	pushl  0x8(%ebp)
  800190:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800196:	50                   	push   %eax
  800197:	68 21 01 80 00       	push   $0x800121
  80019c:	e8 20 01 00 00       	call   8002c1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a1:	83 c4 08             	add    $0x8,%esp
  8001a4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001aa:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 84 09 00 00       	call   800b3a <sys_cputs>

	return b.cnt;
}
  8001b6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    

008001be <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001be:	f3 0f 1e fb          	endbr32 
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001c8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001cb:	50                   	push   %eax
  8001cc:	ff 75 08             	pushl  0x8(%ebp)
  8001cf:	e8 95 ff ff ff       	call   800169 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001d4:	c9                   	leave  
  8001d5:	c3                   	ret    

008001d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	57                   	push   %edi
  8001da:	56                   	push   %esi
  8001db:	53                   	push   %ebx
  8001dc:	83 ec 1c             	sub    $0x1c,%esp
  8001df:	89 c7                	mov    %eax,%edi
  8001e1:	89 d6                	mov    %edx,%esi
  8001e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e9:	89 d1                	mov    %edx,%ecx
  8001eb:	89 c2                	mov    %eax,%edx
  8001ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001f0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800203:	39 c2                	cmp    %eax,%edx
  800205:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800208:	72 3e                	jb     800248 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	ff 75 18             	pushl  0x18(%ebp)
  800210:	83 eb 01             	sub    $0x1,%ebx
  800213:	53                   	push   %ebx
  800214:	50                   	push   %eax
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021b:	ff 75 e0             	pushl  -0x20(%ebp)
  80021e:	ff 75 dc             	pushl  -0x24(%ebp)
  800221:	ff 75 d8             	pushl  -0x28(%ebp)
  800224:	e8 e7 23 00 00       	call   802610 <__udivdi3>
  800229:	83 c4 18             	add    $0x18,%esp
  80022c:	52                   	push   %edx
  80022d:	50                   	push   %eax
  80022e:	89 f2                	mov    %esi,%edx
  800230:	89 f8                	mov    %edi,%eax
  800232:	e8 9f ff ff ff       	call   8001d6 <printnum>
  800237:	83 c4 20             	add    $0x20,%esp
  80023a:	eb 13                	jmp    80024f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	56                   	push   %esi
  800240:	ff 75 18             	pushl  0x18(%ebp)
  800243:	ff d7                	call   *%edi
  800245:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800248:	83 eb 01             	sub    $0x1,%ebx
  80024b:	85 db                	test   %ebx,%ebx
  80024d:	7f ed                	jg     80023c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	56                   	push   %esi
  800253:	83 ec 04             	sub    $0x4,%esp
  800256:	ff 75 e4             	pushl  -0x1c(%ebp)
  800259:	ff 75 e0             	pushl  -0x20(%ebp)
  80025c:	ff 75 dc             	pushl  -0x24(%ebp)
  80025f:	ff 75 d8             	pushl  -0x28(%ebp)
  800262:	e8 b9 24 00 00       	call   802720 <__umoddi3>
  800267:	83 c4 14             	add    $0x14,%esp
  80026a:	0f be 80 20 29 80 00 	movsbl 0x802920(%eax),%eax
  800271:	50                   	push   %eax
  800272:	ff d7                	call   *%edi
}
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027a:	5b                   	pop    %ebx
  80027b:	5e                   	pop    %esi
  80027c:	5f                   	pop    %edi
  80027d:	5d                   	pop    %ebp
  80027e:	c3                   	ret    

0080027f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80027f:	f3 0f 1e fb          	endbr32 
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800289:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80028d:	8b 10                	mov    (%eax),%edx
  80028f:	3b 50 04             	cmp    0x4(%eax),%edx
  800292:	73 0a                	jae    80029e <sprintputch+0x1f>
		*b->buf++ = ch;
  800294:	8d 4a 01             	lea    0x1(%edx),%ecx
  800297:	89 08                	mov    %ecx,(%eax)
  800299:	8b 45 08             	mov    0x8(%ebp),%eax
  80029c:	88 02                	mov    %al,(%edx)
}
  80029e:	5d                   	pop    %ebp
  80029f:	c3                   	ret    

008002a0 <printfmt>:
{
  8002a0:	f3 0f 1e fb          	endbr32 
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002aa:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ad:	50                   	push   %eax
  8002ae:	ff 75 10             	pushl  0x10(%ebp)
  8002b1:	ff 75 0c             	pushl  0xc(%ebp)
  8002b4:	ff 75 08             	pushl  0x8(%ebp)
  8002b7:	e8 05 00 00 00       	call   8002c1 <vprintfmt>
}
  8002bc:	83 c4 10             	add    $0x10,%esp
  8002bf:	c9                   	leave  
  8002c0:	c3                   	ret    

008002c1 <vprintfmt>:
{
  8002c1:	f3 0f 1e fb          	endbr32 
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	57                   	push   %edi
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 3c             	sub    $0x3c,%esp
  8002ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002d4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002d7:	e9 8e 03 00 00       	jmp    80066a <vprintfmt+0x3a9>
		padc = ' ';
  8002dc:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002e0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002e7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002f5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	8d 47 01             	lea    0x1(%edi),%eax
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800300:	0f b6 17             	movzbl (%edi),%edx
  800303:	8d 42 dd             	lea    -0x23(%edx),%eax
  800306:	3c 55                	cmp    $0x55,%al
  800308:	0f 87 df 03 00 00    	ja     8006ed <vprintfmt+0x42c>
  80030e:	0f b6 c0             	movzbl %al,%eax
  800311:	3e ff 24 85 60 2a 80 	notrack jmp *0x802a60(,%eax,4)
  800318:	00 
  800319:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80031c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800320:	eb d8                	jmp    8002fa <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800325:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800329:	eb cf                	jmp    8002fa <vprintfmt+0x39>
  80032b:	0f b6 d2             	movzbl %dl,%edx
  80032e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800331:	b8 00 00 00 00       	mov    $0x0,%eax
  800336:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800339:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80033c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800340:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800343:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800346:	83 f9 09             	cmp    $0x9,%ecx
  800349:	77 55                	ja     8003a0 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80034b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80034e:	eb e9                	jmp    800339 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800350:	8b 45 14             	mov    0x14(%ebp),%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800358:	8b 45 14             	mov    0x14(%ebp),%eax
  80035b:	8d 40 04             	lea    0x4(%eax),%eax
  80035e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800364:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800368:	79 90                	jns    8002fa <vprintfmt+0x39>
				width = precision, precision = -1;
  80036a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80036d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800370:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800377:	eb 81                	jmp    8002fa <vprintfmt+0x39>
  800379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	ba 00 00 00 00       	mov    $0x0,%edx
  800383:	0f 49 d0             	cmovns %eax,%edx
  800386:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80038c:	e9 69 ff ff ff       	jmp    8002fa <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800394:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80039b:	e9 5a ff ff ff       	jmp    8002fa <vprintfmt+0x39>
  8003a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a6:	eb bc                	jmp    800364 <vprintfmt+0xa3>
			lflag++;
  8003a8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ae:	e9 47 ff ff ff       	jmp    8002fa <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b6:	8d 78 04             	lea    0x4(%eax),%edi
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	53                   	push   %ebx
  8003bd:	ff 30                	pushl  (%eax)
  8003bf:	ff d6                	call   *%esi
			break;
  8003c1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003c4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003c7:	e9 9b 02 00 00       	jmp    800667 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cf:	8d 78 04             	lea    0x4(%eax),%edi
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	99                   	cltd   
  8003d5:	31 d0                	xor    %edx,%eax
  8003d7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d9:	83 f8 0f             	cmp    $0xf,%eax
  8003dc:	7f 23                	jg     800401 <vprintfmt+0x140>
  8003de:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  8003e5:	85 d2                	test   %edx,%edx
  8003e7:	74 18                	je     800401 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003e9:	52                   	push   %edx
  8003ea:	68 85 2d 80 00       	push   $0x802d85
  8003ef:	53                   	push   %ebx
  8003f0:	56                   	push   %esi
  8003f1:	e8 aa fe ff ff       	call   8002a0 <printfmt>
  8003f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003fc:	e9 66 02 00 00       	jmp    800667 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800401:	50                   	push   %eax
  800402:	68 38 29 80 00       	push   $0x802938
  800407:	53                   	push   %ebx
  800408:	56                   	push   %esi
  800409:	e8 92 fe ff ff       	call   8002a0 <printfmt>
  80040e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800411:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800414:	e9 4e 02 00 00       	jmp    800667 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	83 c0 04             	add    $0x4,%eax
  80041f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800427:	85 d2                	test   %edx,%edx
  800429:	b8 31 29 80 00       	mov    $0x802931,%eax
  80042e:	0f 45 c2             	cmovne %edx,%eax
  800431:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800434:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800438:	7e 06                	jle    800440 <vprintfmt+0x17f>
  80043a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80043e:	75 0d                	jne    80044d <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800440:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800443:	89 c7                	mov    %eax,%edi
  800445:	03 45 e0             	add    -0x20(%ebp),%eax
  800448:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044b:	eb 55                	jmp    8004a2 <vprintfmt+0x1e1>
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	ff 75 d8             	pushl  -0x28(%ebp)
  800453:	ff 75 cc             	pushl  -0x34(%ebp)
  800456:	e8 46 03 00 00       	call   8007a1 <strnlen>
  80045b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80045e:	29 c2                	sub    %eax,%edx
  800460:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800463:	83 c4 10             	add    $0x10,%esp
  800466:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800468:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80046c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80046f:	85 ff                	test   %edi,%edi
  800471:	7e 11                	jle    800484 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	53                   	push   %ebx
  800477:	ff 75 e0             	pushl  -0x20(%ebp)
  80047a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80047c:	83 ef 01             	sub    $0x1,%edi
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	eb eb                	jmp    80046f <vprintfmt+0x1ae>
  800484:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800487:	85 d2                	test   %edx,%edx
  800489:	b8 00 00 00 00       	mov    $0x0,%eax
  80048e:	0f 49 c2             	cmovns %edx,%eax
  800491:	29 c2                	sub    %eax,%edx
  800493:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800496:	eb a8                	jmp    800440 <vprintfmt+0x17f>
					putch(ch, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	53                   	push   %ebx
  80049c:	52                   	push   %edx
  80049d:	ff d6                	call   *%esi
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a7:	83 c7 01             	add    $0x1,%edi
  8004aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004ae:	0f be d0             	movsbl %al,%edx
  8004b1:	85 d2                	test   %edx,%edx
  8004b3:	74 4b                	je     800500 <vprintfmt+0x23f>
  8004b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b9:	78 06                	js     8004c1 <vprintfmt+0x200>
  8004bb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004bf:	78 1e                	js     8004df <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004c5:	74 d1                	je     800498 <vprintfmt+0x1d7>
  8004c7:	0f be c0             	movsbl %al,%eax
  8004ca:	83 e8 20             	sub    $0x20,%eax
  8004cd:	83 f8 5e             	cmp    $0x5e,%eax
  8004d0:	76 c6                	jbe    800498 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	53                   	push   %ebx
  8004d6:	6a 3f                	push   $0x3f
  8004d8:	ff d6                	call   *%esi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	eb c3                	jmp    8004a2 <vprintfmt+0x1e1>
  8004df:	89 cf                	mov    %ecx,%edi
  8004e1:	eb 0e                	jmp    8004f1 <vprintfmt+0x230>
				putch(' ', putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	6a 20                	push   $0x20
  8004e9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004eb:	83 ef 01             	sub    $0x1,%edi
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	85 ff                	test   %edi,%edi
  8004f3:	7f ee                	jg     8004e3 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fb:	e9 67 01 00 00       	jmp    800667 <vprintfmt+0x3a6>
  800500:	89 cf                	mov    %ecx,%edi
  800502:	eb ed                	jmp    8004f1 <vprintfmt+0x230>
	if (lflag >= 2)
  800504:	83 f9 01             	cmp    $0x1,%ecx
  800507:	7f 1b                	jg     800524 <vprintfmt+0x263>
	else if (lflag)
  800509:	85 c9                	test   %ecx,%ecx
  80050b:	74 63                	je     800570 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800515:	99                   	cltd   
  800516:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 40 04             	lea    0x4(%eax),%eax
  80051f:	89 45 14             	mov    %eax,0x14(%ebp)
  800522:	eb 17                	jmp    80053b <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8b 50 04             	mov    0x4(%eax),%edx
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800532:	8b 45 14             	mov    0x14(%ebp),%eax
  800535:	8d 40 08             	lea    0x8(%eax),%eax
  800538:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80053b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800541:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800546:	85 c9                	test   %ecx,%ecx
  800548:	0f 89 ff 00 00 00    	jns    80064d <vprintfmt+0x38c>
				putch('-', putdat);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	53                   	push   %ebx
  800552:	6a 2d                	push   $0x2d
  800554:	ff d6                	call   *%esi
				num = -(long long) num;
  800556:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800559:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80055c:	f7 da                	neg    %edx
  80055e:	83 d1 00             	adc    $0x0,%ecx
  800561:	f7 d9                	neg    %ecx
  800563:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800566:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056b:	e9 dd 00 00 00       	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800578:	99                   	cltd   
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	eb b4                	jmp    80053b <vprintfmt+0x27a>
	if (lflag >= 2)
  800587:	83 f9 01             	cmp    $0x1,%ecx
  80058a:	7f 1e                	jg     8005aa <vprintfmt+0x2e9>
	else if (lflag)
  80058c:	85 c9                	test   %ecx,%ecx
  80058e:	74 32                	je     8005c2 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8b 10                	mov    (%eax),%edx
  800595:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059a:	8d 40 04             	lea    0x4(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005a5:	e9 a3 00 00 00       	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8b 10                	mov    (%eax),%edx
  8005af:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b2:	8d 40 08             	lea    0x8(%eax),%eax
  8005b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b8:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005bd:	e9 8b 00 00 00       	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8b 10                	mov    (%eax),%edx
  8005c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cc:	8d 40 04             	lea    0x4(%eax),%eax
  8005cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005d7:	eb 74                	jmp    80064d <vprintfmt+0x38c>
	if (lflag >= 2)
  8005d9:	83 f9 01             	cmp    $0x1,%ecx
  8005dc:	7f 1b                	jg     8005f9 <vprintfmt+0x338>
	else if (lflag)
  8005de:	85 c9                	test   %ecx,%ecx
  8005e0:	74 2c                	je     80060e <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 10                	mov    (%eax),%edx
  8005e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ec:	8d 40 04             	lea    0x4(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005f2:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005f7:	eb 54                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8b 10                	mov    (%eax),%edx
  8005fe:	8b 48 04             	mov    0x4(%eax),%ecx
  800601:	8d 40 08             	lea    0x8(%eax),%eax
  800604:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800607:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80060c:	eb 3f                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 10                	mov    (%eax),%edx
  800613:	b9 00 00 00 00       	mov    $0x0,%ecx
  800618:	8d 40 04             	lea    0x4(%eax),%eax
  80061b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80061e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800623:	eb 28                	jmp    80064d <vprintfmt+0x38c>
			putch('0', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	53                   	push   %ebx
  800629:	6a 30                	push   $0x30
  80062b:	ff d6                	call   *%esi
			putch('x', putdat);
  80062d:	83 c4 08             	add    $0x8,%esp
  800630:	53                   	push   %ebx
  800631:	6a 78                	push   $0x78
  800633:	ff d6                	call   *%esi
			num = (unsigned long long)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 10                	mov    (%eax),%edx
  80063a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80063f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800648:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80064d:	83 ec 0c             	sub    $0xc,%esp
  800650:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800654:	57                   	push   %edi
  800655:	ff 75 e0             	pushl  -0x20(%ebp)
  800658:	50                   	push   %eax
  800659:	51                   	push   %ecx
  80065a:	52                   	push   %edx
  80065b:	89 da                	mov    %ebx,%edx
  80065d:	89 f0                	mov    %esi,%eax
  80065f:	e8 72 fb ff ff       	call   8001d6 <printnum>
			break;
  800664:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066a:	83 c7 01             	add    $0x1,%edi
  80066d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800671:	83 f8 25             	cmp    $0x25,%eax
  800674:	0f 84 62 fc ff ff    	je     8002dc <vprintfmt+0x1b>
			if (ch == '\0')
  80067a:	85 c0                	test   %eax,%eax
  80067c:	0f 84 8b 00 00 00    	je     80070d <vprintfmt+0x44c>
			putch(ch, putdat);
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	53                   	push   %ebx
  800686:	50                   	push   %eax
  800687:	ff d6                	call   *%esi
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	eb dc                	jmp    80066a <vprintfmt+0x3a9>
	if (lflag >= 2)
  80068e:	83 f9 01             	cmp    $0x1,%ecx
  800691:	7f 1b                	jg     8006ae <vprintfmt+0x3ed>
	else if (lflag)
  800693:	85 c9                	test   %ecx,%ecx
  800695:	74 2c                	je     8006c3 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 10                	mov    (%eax),%edx
  80069c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a1:	8d 40 04             	lea    0x4(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006ac:	eb 9f                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8b 10                	mov    (%eax),%edx
  8006b3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b6:	8d 40 08             	lea    0x8(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006c1:	eb 8a                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 10                	mov    (%eax),%edx
  8006c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cd:	8d 40 04             	lea    0x4(%eax),%eax
  8006d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d3:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006d8:	e9 70 ff ff ff       	jmp    80064d <vprintfmt+0x38c>
			putch(ch, putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	6a 25                	push   $0x25
  8006e3:	ff d6                	call   *%esi
			break;
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	e9 7a ff ff ff       	jmp    800667 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	6a 25                	push   $0x25
  8006f3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	89 f8                	mov    %edi,%eax
  8006fa:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006fe:	74 05                	je     800705 <vprintfmt+0x444>
  800700:	83 e8 01             	sub    $0x1,%eax
  800703:	eb f5                	jmp    8006fa <vprintfmt+0x439>
  800705:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800708:	e9 5a ff ff ff       	jmp    800667 <vprintfmt+0x3a6>
}
  80070d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800710:	5b                   	pop    %ebx
  800711:	5e                   	pop    %esi
  800712:	5f                   	pop    %edi
  800713:	5d                   	pop    %ebp
  800714:	c3                   	ret    

00800715 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800715:	f3 0f 1e fb          	endbr32 
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	83 ec 18             	sub    $0x18,%esp
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800725:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800728:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80072c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80072f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800736:	85 c0                	test   %eax,%eax
  800738:	74 26                	je     800760 <vsnprintf+0x4b>
  80073a:	85 d2                	test   %edx,%edx
  80073c:	7e 22                	jle    800760 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80073e:	ff 75 14             	pushl  0x14(%ebp)
  800741:	ff 75 10             	pushl  0x10(%ebp)
  800744:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800747:	50                   	push   %eax
  800748:	68 7f 02 80 00       	push   $0x80027f
  80074d:	e8 6f fb ff ff       	call   8002c1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800752:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800755:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075b:	83 c4 10             	add    $0x10,%esp
}
  80075e:	c9                   	leave  
  80075f:	c3                   	ret    
		return -E_INVAL;
  800760:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800765:	eb f7                	jmp    80075e <vsnprintf+0x49>

00800767 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800767:	f3 0f 1e fb          	endbr32 
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800771:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800774:	50                   	push   %eax
  800775:	ff 75 10             	pushl  0x10(%ebp)
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	ff 75 08             	pushl  0x8(%ebp)
  80077e:	e8 92 ff ff ff       	call   800715 <vsnprintf>
	va_end(ap);

	return rc;
}
  800783:	c9                   	leave  
  800784:	c3                   	ret    

00800785 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800785:	f3 0f 1e fb          	endbr32 
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80078f:	b8 00 00 00 00       	mov    $0x0,%eax
  800794:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800798:	74 05                	je     80079f <strlen+0x1a>
		n++;
  80079a:	83 c0 01             	add    $0x1,%eax
  80079d:	eb f5                	jmp    800794 <strlen+0xf>
	return n;
}
  80079f:	5d                   	pop    %ebp
  8007a0:	c3                   	ret    

008007a1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a1:	f3 0f 1e fb          	endbr32 
  8007a5:	55                   	push   %ebp
  8007a6:	89 e5                	mov    %esp,%ebp
  8007a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b3:	39 d0                	cmp    %edx,%eax
  8007b5:	74 0d                	je     8007c4 <strnlen+0x23>
  8007b7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007bb:	74 05                	je     8007c2 <strnlen+0x21>
		n++;
  8007bd:	83 c0 01             	add    $0x1,%eax
  8007c0:	eb f1                	jmp    8007b3 <strnlen+0x12>
  8007c2:	89 c2                	mov    %eax,%edx
	return n;
}
  8007c4:	89 d0                	mov    %edx,%eax
  8007c6:	5d                   	pop    %ebp
  8007c7:	c3                   	ret    

008007c8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c8:	f3 0f 1e fb          	endbr32 
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007db:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007df:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007e2:	83 c0 01             	add    $0x1,%eax
  8007e5:	84 d2                	test   %dl,%dl
  8007e7:	75 f2                	jne    8007db <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007e9:	89 c8                	mov    %ecx,%eax
  8007eb:	5b                   	pop    %ebx
  8007ec:	5d                   	pop    %ebp
  8007ed:	c3                   	ret    

008007ee <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007ee:	f3 0f 1e fb          	endbr32 
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	53                   	push   %ebx
  8007f6:	83 ec 10             	sub    $0x10,%esp
  8007f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007fc:	53                   	push   %ebx
  8007fd:	e8 83 ff ff ff       	call   800785 <strlen>
  800802:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	01 d8                	add    %ebx,%eax
  80080a:	50                   	push   %eax
  80080b:	e8 b8 ff ff ff       	call   8007c8 <strcpy>
	return dst;
}
  800810:	89 d8                	mov    %ebx,%eax
  800812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800817:	f3 0f 1e fb          	endbr32 
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	56                   	push   %esi
  80081f:	53                   	push   %ebx
  800820:	8b 75 08             	mov    0x8(%ebp),%esi
  800823:	8b 55 0c             	mov    0xc(%ebp),%edx
  800826:	89 f3                	mov    %esi,%ebx
  800828:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80082b:	89 f0                	mov    %esi,%eax
  80082d:	39 d8                	cmp    %ebx,%eax
  80082f:	74 11                	je     800842 <strncpy+0x2b>
		*dst++ = *src;
  800831:	83 c0 01             	add    $0x1,%eax
  800834:	0f b6 0a             	movzbl (%edx),%ecx
  800837:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80083a:	80 f9 01             	cmp    $0x1,%cl
  80083d:	83 da ff             	sbb    $0xffffffff,%edx
  800840:	eb eb                	jmp    80082d <strncpy+0x16>
	}
	return ret;
}
  800842:	89 f0                	mov    %esi,%eax
  800844:	5b                   	pop    %ebx
  800845:	5e                   	pop    %esi
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800848:	f3 0f 1e fb          	endbr32 
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	56                   	push   %esi
  800850:	53                   	push   %ebx
  800851:	8b 75 08             	mov    0x8(%ebp),%esi
  800854:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800857:	8b 55 10             	mov    0x10(%ebp),%edx
  80085a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80085c:	85 d2                	test   %edx,%edx
  80085e:	74 21                	je     800881 <strlcpy+0x39>
  800860:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800864:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800866:	39 c2                	cmp    %eax,%edx
  800868:	74 14                	je     80087e <strlcpy+0x36>
  80086a:	0f b6 19             	movzbl (%ecx),%ebx
  80086d:	84 db                	test   %bl,%bl
  80086f:	74 0b                	je     80087c <strlcpy+0x34>
			*dst++ = *src++;
  800871:	83 c1 01             	add    $0x1,%ecx
  800874:	83 c2 01             	add    $0x1,%edx
  800877:	88 5a ff             	mov    %bl,-0x1(%edx)
  80087a:	eb ea                	jmp    800866 <strlcpy+0x1e>
  80087c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80087e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800881:	29 f0                	sub    %esi,%eax
}
  800883:	5b                   	pop    %ebx
  800884:	5e                   	pop    %esi
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800887:	f3 0f 1e fb          	endbr32 
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800891:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800894:	0f b6 01             	movzbl (%ecx),%eax
  800897:	84 c0                	test   %al,%al
  800899:	74 0c                	je     8008a7 <strcmp+0x20>
  80089b:	3a 02                	cmp    (%edx),%al
  80089d:	75 08                	jne    8008a7 <strcmp+0x20>
		p++, q++;
  80089f:	83 c1 01             	add    $0x1,%ecx
  8008a2:	83 c2 01             	add    $0x1,%edx
  8008a5:	eb ed                	jmp    800894 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a7:	0f b6 c0             	movzbl %al,%eax
  8008aa:	0f b6 12             	movzbl (%edx),%edx
  8008ad:	29 d0                	sub    %edx,%eax
}
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b1:	f3 0f 1e fb          	endbr32 
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	53                   	push   %ebx
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bf:	89 c3                	mov    %eax,%ebx
  8008c1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c4:	eb 06                	jmp    8008cc <strncmp+0x1b>
		n--, p++, q++;
  8008c6:	83 c0 01             	add    $0x1,%eax
  8008c9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008cc:	39 d8                	cmp    %ebx,%eax
  8008ce:	74 16                	je     8008e6 <strncmp+0x35>
  8008d0:	0f b6 08             	movzbl (%eax),%ecx
  8008d3:	84 c9                	test   %cl,%cl
  8008d5:	74 04                	je     8008db <strncmp+0x2a>
  8008d7:	3a 0a                	cmp    (%edx),%cl
  8008d9:	74 eb                	je     8008c6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008db:	0f b6 00             	movzbl (%eax),%eax
  8008de:	0f b6 12             	movzbl (%edx),%edx
  8008e1:	29 d0                	sub    %edx,%eax
}
  8008e3:	5b                   	pop    %ebx
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    
		return 0;
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	eb f6                	jmp    8008e3 <strncmp+0x32>

008008ed <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ed:	f3 0f 1e fb          	endbr32 
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fb:	0f b6 10             	movzbl (%eax),%edx
  8008fe:	84 d2                	test   %dl,%dl
  800900:	74 09                	je     80090b <strchr+0x1e>
		if (*s == c)
  800902:	38 ca                	cmp    %cl,%dl
  800904:	74 0a                	je     800910 <strchr+0x23>
	for (; *s; s++)
  800906:	83 c0 01             	add    $0x1,%eax
  800909:	eb f0                	jmp    8008fb <strchr+0xe>
			return (char *) s;
	return 0;
  80090b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800912:	f3 0f 1e fb          	endbr32 
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800920:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800923:	38 ca                	cmp    %cl,%dl
  800925:	74 09                	je     800930 <strfind+0x1e>
  800927:	84 d2                	test   %dl,%dl
  800929:	74 05                	je     800930 <strfind+0x1e>
	for (; *s; s++)
  80092b:	83 c0 01             	add    $0x1,%eax
  80092e:	eb f0                	jmp    800920 <strfind+0xe>
			break;
	return (char *) s;
}
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800932:	f3 0f 1e fb          	endbr32 
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	57                   	push   %edi
  80093a:	56                   	push   %esi
  80093b:	53                   	push   %ebx
  80093c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80093f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800942:	85 c9                	test   %ecx,%ecx
  800944:	74 31                	je     800977 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800946:	89 f8                	mov    %edi,%eax
  800948:	09 c8                	or     %ecx,%eax
  80094a:	a8 03                	test   $0x3,%al
  80094c:	75 23                	jne    800971 <memset+0x3f>
		c &= 0xFF;
  80094e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800952:	89 d3                	mov    %edx,%ebx
  800954:	c1 e3 08             	shl    $0x8,%ebx
  800957:	89 d0                	mov    %edx,%eax
  800959:	c1 e0 18             	shl    $0x18,%eax
  80095c:	89 d6                	mov    %edx,%esi
  80095e:	c1 e6 10             	shl    $0x10,%esi
  800961:	09 f0                	or     %esi,%eax
  800963:	09 c2                	or     %eax,%edx
  800965:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800967:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80096a:	89 d0                	mov    %edx,%eax
  80096c:	fc                   	cld    
  80096d:	f3 ab                	rep stos %eax,%es:(%edi)
  80096f:	eb 06                	jmp    800977 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800971:	8b 45 0c             	mov    0xc(%ebp),%eax
  800974:	fc                   	cld    
  800975:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800977:	89 f8                	mov    %edi,%eax
  800979:	5b                   	pop    %ebx
  80097a:	5e                   	pop    %esi
  80097b:	5f                   	pop    %edi
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    

0080097e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80097e:	f3 0f 1e fb          	endbr32 
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	57                   	push   %edi
  800986:	56                   	push   %esi
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80098d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800990:	39 c6                	cmp    %eax,%esi
  800992:	73 32                	jae    8009c6 <memmove+0x48>
  800994:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800997:	39 c2                	cmp    %eax,%edx
  800999:	76 2b                	jbe    8009c6 <memmove+0x48>
		s += n;
		d += n;
  80099b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099e:	89 fe                	mov    %edi,%esi
  8009a0:	09 ce                	or     %ecx,%esi
  8009a2:	09 d6                	or     %edx,%esi
  8009a4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009aa:	75 0e                	jne    8009ba <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009ac:	83 ef 04             	sub    $0x4,%edi
  8009af:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009b2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009b5:	fd                   	std    
  8009b6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b8:	eb 09                	jmp    8009c3 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ba:	83 ef 01             	sub    $0x1,%edi
  8009bd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009c0:	fd                   	std    
  8009c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009c3:	fc                   	cld    
  8009c4:	eb 1a                	jmp    8009e0 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c6:	89 c2                	mov    %eax,%edx
  8009c8:	09 ca                	or     %ecx,%edx
  8009ca:	09 f2                	or     %esi,%edx
  8009cc:	f6 c2 03             	test   $0x3,%dl
  8009cf:	75 0a                	jne    8009db <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009d1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009d4:	89 c7                	mov    %eax,%edi
  8009d6:	fc                   	cld    
  8009d7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d9:	eb 05                	jmp    8009e0 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009db:	89 c7                	mov    %eax,%edi
  8009dd:	fc                   	cld    
  8009de:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009e0:	5e                   	pop    %esi
  8009e1:	5f                   	pop    %edi
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e4:	f3 0f 1e fb          	endbr32 
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009ee:	ff 75 10             	pushl  0x10(%ebp)
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	ff 75 08             	pushl  0x8(%ebp)
  8009f7:	e8 82 ff ff ff       	call   80097e <memmove>
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009fe:	f3 0f 1e fb          	endbr32 
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0d:	89 c6                	mov    %eax,%esi
  800a0f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a12:	39 f0                	cmp    %esi,%eax
  800a14:	74 1c                	je     800a32 <memcmp+0x34>
		if (*s1 != *s2)
  800a16:	0f b6 08             	movzbl (%eax),%ecx
  800a19:	0f b6 1a             	movzbl (%edx),%ebx
  800a1c:	38 d9                	cmp    %bl,%cl
  800a1e:	75 08                	jne    800a28 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	83 c2 01             	add    $0x1,%edx
  800a26:	eb ea                	jmp    800a12 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a28:	0f b6 c1             	movzbl %cl,%eax
  800a2b:	0f b6 db             	movzbl %bl,%ebx
  800a2e:	29 d8                	sub    %ebx,%eax
  800a30:	eb 05                	jmp    800a37 <memcmp+0x39>
	}

	return 0;
  800a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a37:	5b                   	pop    %ebx
  800a38:	5e                   	pop    %esi
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a3b:	f3 0f 1e fb          	endbr32 
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a48:	89 c2                	mov    %eax,%edx
  800a4a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a4d:	39 d0                	cmp    %edx,%eax
  800a4f:	73 09                	jae    800a5a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a51:	38 08                	cmp    %cl,(%eax)
  800a53:	74 05                	je     800a5a <memfind+0x1f>
	for (; s < ends; s++)
  800a55:	83 c0 01             	add    $0x1,%eax
  800a58:	eb f3                	jmp    800a4d <memfind+0x12>
			break;
	return (void *) s;
}
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a5c:	f3 0f 1e fb          	endbr32 
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	57                   	push   %edi
  800a64:	56                   	push   %esi
  800a65:	53                   	push   %ebx
  800a66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a6c:	eb 03                	jmp    800a71 <strtol+0x15>
		s++;
  800a6e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a71:	0f b6 01             	movzbl (%ecx),%eax
  800a74:	3c 20                	cmp    $0x20,%al
  800a76:	74 f6                	je     800a6e <strtol+0x12>
  800a78:	3c 09                	cmp    $0x9,%al
  800a7a:	74 f2                	je     800a6e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a7c:	3c 2b                	cmp    $0x2b,%al
  800a7e:	74 2a                	je     800aaa <strtol+0x4e>
	int neg = 0;
  800a80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a85:	3c 2d                	cmp    $0x2d,%al
  800a87:	74 2b                	je     800ab4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a89:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a8f:	75 0f                	jne    800aa0 <strtol+0x44>
  800a91:	80 39 30             	cmpb   $0x30,(%ecx)
  800a94:	74 28                	je     800abe <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a96:	85 db                	test   %ebx,%ebx
  800a98:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a9d:	0f 44 d8             	cmove  %eax,%ebx
  800aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aa8:	eb 46                	jmp    800af0 <strtol+0x94>
		s++;
  800aaa:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aad:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab2:	eb d5                	jmp    800a89 <strtol+0x2d>
		s++, neg = 1;
  800ab4:	83 c1 01             	add    $0x1,%ecx
  800ab7:	bf 01 00 00 00       	mov    $0x1,%edi
  800abc:	eb cb                	jmp    800a89 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abe:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ac2:	74 0e                	je     800ad2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	75 d8                	jne    800aa0 <strtol+0x44>
		s++, base = 8;
  800ac8:	83 c1 01             	add    $0x1,%ecx
  800acb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ad0:	eb ce                	jmp    800aa0 <strtol+0x44>
		s += 2, base = 16;
  800ad2:	83 c1 02             	add    $0x2,%ecx
  800ad5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ada:	eb c4                	jmp    800aa0 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800adc:	0f be d2             	movsbl %dl,%edx
  800adf:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ae2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ae5:	7d 3a                	jge    800b21 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ae7:	83 c1 01             	add    $0x1,%ecx
  800aea:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aee:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800af0:	0f b6 11             	movzbl (%ecx),%edx
  800af3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800af6:	89 f3                	mov    %esi,%ebx
  800af8:	80 fb 09             	cmp    $0x9,%bl
  800afb:	76 df                	jbe    800adc <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800afd:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b00:	89 f3                	mov    %esi,%ebx
  800b02:	80 fb 19             	cmp    $0x19,%bl
  800b05:	77 08                	ja     800b0f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b07:	0f be d2             	movsbl %dl,%edx
  800b0a:	83 ea 57             	sub    $0x57,%edx
  800b0d:	eb d3                	jmp    800ae2 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b0f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b12:	89 f3                	mov    %esi,%ebx
  800b14:	80 fb 19             	cmp    $0x19,%bl
  800b17:	77 08                	ja     800b21 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b19:	0f be d2             	movsbl %dl,%edx
  800b1c:	83 ea 37             	sub    $0x37,%edx
  800b1f:	eb c1                	jmp    800ae2 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b25:	74 05                	je     800b2c <strtol+0xd0>
		*endptr = (char *) s;
  800b27:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b2c:	89 c2                	mov    %eax,%edx
  800b2e:	f7 da                	neg    %edx
  800b30:	85 ff                	test   %edi,%edi
  800b32:	0f 45 c2             	cmovne %edx,%eax
}
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5f                   	pop    %edi
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    

00800b3a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b3a:	f3 0f 1e fb          	endbr32 
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	57                   	push   %edi
  800b42:	56                   	push   %esi
  800b43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4f:	89 c3                	mov    %eax,%ebx
  800b51:	89 c7                	mov    %eax,%edi
  800b53:	89 c6                	mov    %eax,%esi
  800b55:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <sys_cgetc>:

int
sys_cgetc(void)
{
  800b5c:	f3 0f 1e fb          	endbr32 
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	57                   	push   %edi
  800b64:	56                   	push   %esi
  800b65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b66:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b70:	89 d1                	mov    %edx,%ecx
  800b72:	89 d3                	mov    %edx,%ebx
  800b74:	89 d7                	mov    %edx,%edi
  800b76:	89 d6                	mov    %edx,%esi
  800b78:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5f                   	pop    %edi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b7f:	f3 0f 1e fb          	endbr32 
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b91:	8b 55 08             	mov    0x8(%ebp),%edx
  800b94:	b8 03 00 00 00       	mov    $0x3,%eax
  800b99:	89 cb                	mov    %ecx,%ebx
  800b9b:	89 cf                	mov    %ecx,%edi
  800b9d:	89 ce                	mov    %ecx,%esi
  800b9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	7f 08                	jg     800bad <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ba5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5f                   	pop    %edi
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bad:	83 ec 0c             	sub    $0xc,%esp
  800bb0:	50                   	push   %eax
  800bb1:	6a 03                	push   $0x3
  800bb3:	68 1f 2c 80 00       	push   $0x802c1f
  800bb8:	6a 23                	push   $0x23
  800bba:	68 3c 2c 80 00       	push   $0x802c3c
  800bbf:	e8 01 18 00 00       	call   8023c5 <_panic>

00800bc4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bce:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd3:	b8 02 00 00 00       	mov    $0x2,%eax
  800bd8:	89 d1                	mov    %edx,%ecx
  800bda:	89 d3                	mov    %edx,%ebx
  800bdc:	89 d7                	mov    %edx,%edi
  800bde:	89 d6                	mov    %edx,%esi
  800be0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <sys_yield>:

void
sys_yield(void)
{
  800be7:	f3 0f 1e fb          	endbr32 
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	57                   	push   %edi
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bfb:	89 d1                	mov    %edx,%ecx
  800bfd:	89 d3                	mov    %edx,%ebx
  800bff:	89 d7                	mov    %edx,%edi
  800c01:	89 d6                	mov    %edx,%esi
  800c03:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c05:	5b                   	pop    %ebx
  800c06:	5e                   	pop    %esi
  800c07:	5f                   	pop    %edi
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c0a:	f3 0f 1e fb          	endbr32 
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
  800c14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c17:	be 00 00 00 00       	mov    $0x0,%esi
  800c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c22:	b8 04 00 00 00       	mov    $0x4,%eax
  800c27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2a:	89 f7                	mov    %esi,%edi
  800c2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	7f 08                	jg     800c3a <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	50                   	push   %eax
  800c3e:	6a 04                	push   $0x4
  800c40:	68 1f 2c 80 00       	push   $0x802c1f
  800c45:	6a 23                	push   $0x23
  800c47:	68 3c 2c 80 00       	push   $0x802c3c
  800c4c:	e8 74 17 00 00       	call   8023c5 <_panic>

00800c51 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c51:	f3 0f 1e fb          	endbr32 
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c64:	b8 05 00 00 00       	mov    $0x5,%eax
  800c69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c6f:	8b 75 18             	mov    0x18(%ebp),%esi
  800c72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c74:	85 c0                	test   %eax,%eax
  800c76:	7f 08                	jg     800c80 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c80:	83 ec 0c             	sub    $0xc,%esp
  800c83:	50                   	push   %eax
  800c84:	6a 05                	push   $0x5
  800c86:	68 1f 2c 80 00       	push   $0x802c1f
  800c8b:	6a 23                	push   $0x23
  800c8d:	68 3c 2c 80 00       	push   $0x802c3c
  800c92:	e8 2e 17 00 00       	call   8023c5 <_panic>

00800c97 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c97:	f3 0f 1e fb          	endbr32 
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 06 00 00 00       	mov    $0x6,%eax
  800cb4:	89 df                	mov    %ebx,%edi
  800cb6:	89 de                	mov    %ebx,%esi
  800cb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7f 08                	jg     800cc6 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	50                   	push   %eax
  800cca:	6a 06                	push   $0x6
  800ccc:	68 1f 2c 80 00       	push   $0x802c1f
  800cd1:	6a 23                	push   $0x23
  800cd3:	68 3c 2c 80 00       	push   $0x802c3c
  800cd8:	e8 e8 16 00 00       	call   8023c5 <_panic>

00800cdd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cdd:	f3 0f 1e fb          	endbr32 
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
  800ce7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cef:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf5:	b8 08 00 00 00       	mov    $0x8,%eax
  800cfa:	89 df                	mov    %ebx,%edi
  800cfc:	89 de                	mov    %ebx,%esi
  800cfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7f 08                	jg     800d0c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	50                   	push   %eax
  800d10:	6a 08                	push   $0x8
  800d12:	68 1f 2c 80 00       	push   $0x802c1f
  800d17:	6a 23                	push   $0x23
  800d19:	68 3c 2c 80 00       	push   $0x802c3c
  800d1e:	e8 a2 16 00 00       	call   8023c5 <_panic>

00800d23 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d23:	f3 0f 1e fb          	endbr32 
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 09 00 00 00       	mov    $0x9,%eax
  800d40:	89 df                	mov    %ebx,%edi
  800d42:	89 de                	mov    %ebx,%esi
  800d44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d46:	85 c0                	test   %eax,%eax
  800d48:	7f 08                	jg     800d52 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	50                   	push   %eax
  800d56:	6a 09                	push   $0x9
  800d58:	68 1f 2c 80 00       	push   $0x802c1f
  800d5d:	6a 23                	push   $0x23
  800d5f:	68 3c 2c 80 00       	push   $0x802c3c
  800d64:	e8 5c 16 00 00       	call   8023c5 <_panic>

00800d69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d69:	f3 0f 1e fb          	endbr32 
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d86:	89 df                	mov    %ebx,%edi
  800d88:	89 de                	mov    %ebx,%esi
  800d8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	7f 08                	jg     800d98 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d98:	83 ec 0c             	sub    $0xc,%esp
  800d9b:	50                   	push   %eax
  800d9c:	6a 0a                	push   $0xa
  800d9e:	68 1f 2c 80 00       	push   $0x802c1f
  800da3:	6a 23                	push   $0x23
  800da5:	68 3c 2c 80 00       	push   $0x802c3c
  800daa:	e8 16 16 00 00       	call   8023c5 <_panic>

00800daf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800daf:	f3 0f 1e fb          	endbr32 
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dc4:	be 00 00 00 00       	mov    $0x0,%esi
  800dc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dcf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dd6:	f3 0f 1e fb          	endbr32 
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800df0:	89 cb                	mov    %ecx,%ebx
  800df2:	89 cf                	mov    %ecx,%edi
  800df4:	89 ce                	mov    %ecx,%esi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 0d                	push   $0xd
  800e0a:	68 1f 2c 80 00       	push   $0x802c1f
  800e0f:	6a 23                	push   $0x23
  800e11:	68 3c 2c 80 00       	push   $0x802c3c
  800e16:	e8 aa 15 00 00       	call   8023c5 <_panic>

00800e1b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e1b:	f3 0f 1e fb          	endbr32 
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e25:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e2f:	89 d1                	mov    %edx,%ecx
  800e31:	89 d3                	mov    %edx,%ebx
  800e33:	89 d7                	mov    %edx,%edi
  800e35:	89 d6                	mov    %edx,%esi
  800e37:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e39:	5b                   	pop    %ebx
  800e3a:	5e                   	pop    %esi
  800e3b:	5f                   	pop    %edi
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    

00800e3e <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800e3e:	f3 0f 1e fb          	endbr32 
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e56:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e5b:	89 df                	mov    %ebx,%edi
  800e5d:	89 de                	mov    %ebx,%esi
  800e5f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e61:	85 c0                	test   %eax,%eax
  800e63:	7f 08                	jg     800e6d <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e68:	5b                   	pop    %ebx
  800e69:	5e                   	pop    %esi
  800e6a:	5f                   	pop    %edi
  800e6b:	5d                   	pop    %ebp
  800e6c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6d:	83 ec 0c             	sub    $0xc,%esp
  800e70:	50                   	push   %eax
  800e71:	6a 0f                	push   $0xf
  800e73:	68 1f 2c 80 00       	push   $0x802c1f
  800e78:	6a 23                	push   $0x23
  800e7a:	68 3c 2c 80 00       	push   $0x802c3c
  800e7f:	e8 41 15 00 00       	call   8023c5 <_panic>

00800e84 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800e84:	f3 0f 1e fb          	endbr32 
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
  800e8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9c:	b8 10 00 00 00       	mov    $0x10,%eax
  800ea1:	89 df                	mov    %ebx,%edi
  800ea3:	89 de                	mov    %ebx,%esi
  800ea5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	7f 08                	jg     800eb3 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb3:	83 ec 0c             	sub    $0xc,%esp
  800eb6:	50                   	push   %eax
  800eb7:	6a 10                	push   $0x10
  800eb9:	68 1f 2c 80 00       	push   $0x802c1f
  800ebe:	6a 23                	push   $0x23
  800ec0:	68 3c 2c 80 00       	push   $0x802c3c
  800ec5:	e8 fb 14 00 00       	call   8023c5 <_panic>

00800eca <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800eca:	f3 0f 1e fb          	endbr32 
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	53                   	push   %ebx
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ed8:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800eda:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ede:	74 74                	je     800f54 <pgfault+0x8a>
  800ee0:	89 d8                	mov    %ebx,%eax
  800ee2:	c1 e8 0c             	shr    $0xc,%eax
  800ee5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800eec:	f6 c4 08             	test   $0x8,%ah
  800eef:	74 63                	je     800f54 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800ef1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800ef7:	83 ec 0c             	sub    $0xc,%esp
  800efa:	6a 05                	push   $0x5
  800efc:	68 00 f0 7f 00       	push   $0x7ff000
  800f01:	6a 00                	push   $0x0
  800f03:	53                   	push   %ebx
  800f04:	6a 00                	push   $0x0
  800f06:	e8 46 fd ff ff       	call   800c51 <sys_page_map>
  800f0b:	83 c4 20             	add    $0x20,%esp
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	78 59                	js     800f6b <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800f12:	83 ec 04             	sub    $0x4,%esp
  800f15:	6a 07                	push   $0x7
  800f17:	53                   	push   %ebx
  800f18:	6a 00                	push   $0x0
  800f1a:	e8 eb fc ff ff       	call   800c0a <sys_page_alloc>
  800f1f:	83 c4 10             	add    $0x10,%esp
  800f22:	85 c0                	test   %eax,%eax
  800f24:	78 5a                	js     800f80 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f26:	83 ec 04             	sub    $0x4,%esp
  800f29:	68 00 10 00 00       	push   $0x1000
  800f2e:	68 00 f0 7f 00       	push   $0x7ff000
  800f33:	53                   	push   %ebx
  800f34:	e8 45 fa ff ff       	call   80097e <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800f39:	83 c4 08             	add    $0x8,%esp
  800f3c:	68 00 f0 7f 00       	push   $0x7ff000
  800f41:	6a 00                	push   $0x0
  800f43:	e8 4f fd ff ff       	call   800c97 <sys_page_unmap>
  800f48:	83 c4 10             	add    $0x10,%esp
  800f4b:	85 c0                	test   %eax,%eax
  800f4d:	78 46                	js     800f95 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800f4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f52:	c9                   	leave  
  800f53:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800f54:	83 ec 04             	sub    $0x4,%esp
  800f57:	68 4a 2c 80 00       	push   $0x802c4a
  800f5c:	68 d3 00 00 00       	push   $0xd3
  800f61:	68 66 2c 80 00       	push   $0x802c66
  800f66:	e8 5a 14 00 00       	call   8023c5 <_panic>
		panic("pgfault: %e\n", r);
  800f6b:	50                   	push   %eax
  800f6c:	68 71 2c 80 00       	push   $0x802c71
  800f71:	68 df 00 00 00       	push   $0xdf
  800f76:	68 66 2c 80 00       	push   $0x802c66
  800f7b:	e8 45 14 00 00       	call   8023c5 <_panic>
		panic("pgfault: %e\n", r);
  800f80:	50                   	push   %eax
  800f81:	68 71 2c 80 00       	push   $0x802c71
  800f86:	68 e3 00 00 00       	push   $0xe3
  800f8b:	68 66 2c 80 00       	push   $0x802c66
  800f90:	e8 30 14 00 00       	call   8023c5 <_panic>
		panic("pgfault: %e\n", r);
  800f95:	50                   	push   %eax
  800f96:	68 71 2c 80 00       	push   $0x802c71
  800f9b:	68 e9 00 00 00       	push   $0xe9
  800fa0:	68 66 2c 80 00       	push   $0x802c66
  800fa5:	e8 1b 14 00 00       	call   8023c5 <_panic>

00800faa <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800faa:	f3 0f 1e fb          	endbr32 
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	57                   	push   %edi
  800fb2:	56                   	push   %esi
  800fb3:	53                   	push   %ebx
  800fb4:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800fb7:	68 ca 0e 80 00       	push   $0x800eca
  800fbc:	e8 4e 14 00 00       	call   80240f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fc1:	b8 07 00 00 00       	mov    $0x7,%eax
  800fc6:	cd 30                	int    $0x30
  800fc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800fcb:	83 c4 10             	add    $0x10,%esp
  800fce:	85 c0                	test   %eax,%eax
  800fd0:	78 2d                	js     800fff <fork+0x55>
  800fd2:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fd4:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800fd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fdd:	0f 85 9b 00 00 00    	jne    80107e <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fe3:	e8 dc fb ff ff       	call   800bc4 <sys_getenvid>
  800fe8:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fed:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ff0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ff5:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800ffa:	e9 71 01 00 00       	jmp    801170 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  800fff:	50                   	push   %eax
  801000:	68 7e 2c 80 00       	push   $0x802c7e
  801005:	68 2a 01 00 00       	push   $0x12a
  80100a:	68 66 2c 80 00       	push   $0x802c66
  80100f:	e8 b1 13 00 00       	call   8023c5 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801014:	c1 e6 0c             	shl    $0xc,%esi
  801017:	83 ec 0c             	sub    $0xc,%esp
  80101a:	68 07 0e 00 00       	push   $0xe07
  80101f:	56                   	push   %esi
  801020:	57                   	push   %edi
  801021:	56                   	push   %esi
  801022:	6a 00                	push   $0x0
  801024:	e8 28 fc ff ff       	call   800c51 <sys_page_map>
  801029:	83 c4 20             	add    $0x20,%esp
  80102c:	eb 3e                	jmp    80106c <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80102e:	c1 e6 0c             	shl    $0xc,%esi
  801031:	83 ec 0c             	sub    $0xc,%esp
  801034:	68 05 08 00 00       	push   $0x805
  801039:	56                   	push   %esi
  80103a:	57                   	push   %edi
  80103b:	56                   	push   %esi
  80103c:	6a 00                	push   $0x0
  80103e:	e8 0e fc ff ff       	call   800c51 <sys_page_map>
  801043:	83 c4 20             	add    $0x20,%esp
  801046:	85 c0                	test   %eax,%eax
  801048:	0f 88 bc 00 00 00    	js     80110a <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  80104e:	83 ec 0c             	sub    $0xc,%esp
  801051:	68 05 08 00 00       	push   $0x805
  801056:	56                   	push   %esi
  801057:	6a 00                	push   $0x0
  801059:	56                   	push   %esi
  80105a:	6a 00                	push   $0x0
  80105c:	e8 f0 fb ff ff       	call   800c51 <sys_page_map>
  801061:	83 c4 20             	add    $0x20,%esp
  801064:	85 c0                	test   %eax,%eax
  801066:	0f 88 b3 00 00 00    	js     80111f <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80106c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801072:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801078:	0f 84 b6 00 00 00    	je     801134 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  80107e:	89 d8                	mov    %ebx,%eax
  801080:	c1 e8 16             	shr    $0x16,%eax
  801083:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80108a:	a8 01                	test   $0x1,%al
  80108c:	74 de                	je     80106c <fork+0xc2>
  80108e:	89 de                	mov    %ebx,%esi
  801090:	c1 ee 0c             	shr    $0xc,%esi
  801093:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80109a:	a8 01                	test   $0x1,%al
  80109c:	74 ce                	je     80106c <fork+0xc2>
  80109e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010a5:	a8 04                	test   $0x4,%al
  8010a7:	74 c3                	je     80106c <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  8010a9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010b0:	f6 c4 04             	test   $0x4,%ah
  8010b3:	0f 85 5b ff ff ff    	jne    801014 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  8010b9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010c0:	a8 02                	test   $0x2,%al
  8010c2:	0f 85 66 ff ff ff    	jne    80102e <fork+0x84>
  8010c8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010cf:	f6 c4 08             	test   $0x8,%ah
  8010d2:	0f 85 56 ff ff ff    	jne    80102e <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8010d8:	c1 e6 0c             	shl    $0xc,%esi
  8010db:	83 ec 0c             	sub    $0xc,%esp
  8010de:	6a 05                	push   $0x5
  8010e0:	56                   	push   %esi
  8010e1:	57                   	push   %edi
  8010e2:	56                   	push   %esi
  8010e3:	6a 00                	push   $0x0
  8010e5:	e8 67 fb ff ff       	call   800c51 <sys_page_map>
  8010ea:	83 c4 20             	add    $0x20,%esp
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	0f 89 77 ff ff ff    	jns    80106c <fork+0xc2>
		panic("duppage: %e\n", r);
  8010f5:	50                   	push   %eax
  8010f6:	68 8e 2c 80 00       	push   $0x802c8e
  8010fb:	68 0c 01 00 00       	push   $0x10c
  801100:	68 66 2c 80 00       	push   $0x802c66
  801105:	e8 bb 12 00 00       	call   8023c5 <_panic>
			panic("duppage: %e\n", r);
  80110a:	50                   	push   %eax
  80110b:	68 8e 2c 80 00       	push   $0x802c8e
  801110:	68 05 01 00 00       	push   $0x105
  801115:	68 66 2c 80 00       	push   $0x802c66
  80111a:	e8 a6 12 00 00       	call   8023c5 <_panic>
			panic("duppage: %e\n", r);
  80111f:	50                   	push   %eax
  801120:	68 8e 2c 80 00       	push   $0x802c8e
  801125:	68 09 01 00 00       	push   $0x109
  80112a:	68 66 2c 80 00       	push   $0x802c66
  80112f:	e8 91 12 00 00       	call   8023c5 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801134:	83 ec 04             	sub    $0x4,%esp
  801137:	6a 07                	push   $0x7
  801139:	68 00 f0 bf ee       	push   $0xeebff000
  80113e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801141:	e8 c4 fa ff ff       	call   800c0a <sys_page_alloc>
  801146:	83 c4 10             	add    $0x10,%esp
  801149:	85 c0                	test   %eax,%eax
  80114b:	78 2e                	js     80117b <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80114d:	83 ec 08             	sub    $0x8,%esp
  801150:	68 82 24 80 00       	push   $0x802482
  801155:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801158:	57                   	push   %edi
  801159:	e8 0b fc ff ff       	call   800d69 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80115e:	83 c4 08             	add    $0x8,%esp
  801161:	6a 02                	push   $0x2
  801163:	57                   	push   %edi
  801164:	e8 74 fb ff ff       	call   800cdd <sys_env_set_status>
  801169:	83 c4 10             	add    $0x10,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	78 20                	js     801190 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801170:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801173:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801176:	5b                   	pop    %ebx
  801177:	5e                   	pop    %esi
  801178:	5f                   	pop    %edi
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80117b:	50                   	push   %eax
  80117c:	68 9b 2c 80 00       	push   $0x802c9b
  801181:	68 3e 01 00 00       	push   $0x13e
  801186:	68 66 2c 80 00       	push   $0x802c66
  80118b:	e8 35 12 00 00       	call   8023c5 <_panic>
		panic("sys_env_set_status: %e", r);
  801190:	50                   	push   %eax
  801191:	68 ae 2c 80 00       	push   $0x802cae
  801196:	68 43 01 00 00       	push   $0x143
  80119b:	68 66 2c 80 00       	push   $0x802c66
  8011a0:	e8 20 12 00 00       	call   8023c5 <_panic>

008011a5 <sfork>:

// Challenge!
int
sfork(void)
{
  8011a5:	f3 0f 1e fb          	endbr32 
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011af:	68 c5 2c 80 00       	push   $0x802cc5
  8011b4:	68 4c 01 00 00       	push   $0x14c
  8011b9:	68 66 2c 80 00       	push   $0x802c66
  8011be:	e8 02 12 00 00       	call   8023c5 <_panic>

008011c3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011c3:	f3 0f 1e fb          	endbr32 
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	05 00 00 00 30       	add    $0x30000000,%eax
  8011d2:	c1 e8 0c             	shr    $0xc,%eax
}
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    

008011d7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011d7:	f3 0f 1e fb          	endbr32 
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011eb:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    

008011f2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011f2:	f3 0f 1e fb          	endbr32 
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011fe:	89 c2                	mov    %eax,%edx
  801200:	c1 ea 16             	shr    $0x16,%edx
  801203:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80120a:	f6 c2 01             	test   $0x1,%dl
  80120d:	74 2d                	je     80123c <fd_alloc+0x4a>
  80120f:	89 c2                	mov    %eax,%edx
  801211:	c1 ea 0c             	shr    $0xc,%edx
  801214:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80121b:	f6 c2 01             	test   $0x1,%dl
  80121e:	74 1c                	je     80123c <fd_alloc+0x4a>
  801220:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801225:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80122a:	75 d2                	jne    8011fe <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801235:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80123a:	eb 0a                	jmp    801246 <fd_alloc+0x54>
			*fd_store = fd;
  80123c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801241:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801246:	5d                   	pop    %ebp
  801247:	c3                   	ret    

00801248 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801248:	f3 0f 1e fb          	endbr32 
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801252:	83 f8 1f             	cmp    $0x1f,%eax
  801255:	77 30                	ja     801287 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801257:	c1 e0 0c             	shl    $0xc,%eax
  80125a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80125f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801265:	f6 c2 01             	test   $0x1,%dl
  801268:	74 24                	je     80128e <fd_lookup+0x46>
  80126a:	89 c2                	mov    %eax,%edx
  80126c:	c1 ea 0c             	shr    $0xc,%edx
  80126f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801276:	f6 c2 01             	test   $0x1,%dl
  801279:	74 1a                	je     801295 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80127b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127e:	89 02                	mov    %eax,(%edx)
	return 0;
  801280:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    
		return -E_INVAL;
  801287:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128c:	eb f7                	jmp    801285 <fd_lookup+0x3d>
		return -E_INVAL;
  80128e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801293:	eb f0                	jmp    801285 <fd_lookup+0x3d>
  801295:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129a:	eb e9                	jmp    801285 <fd_lookup+0x3d>

0080129c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80129c:	f3 0f 1e fb          	endbr32 
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	83 ec 08             	sub    $0x8,%esp
  8012a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ae:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012b3:	39 08                	cmp    %ecx,(%eax)
  8012b5:	74 38                	je     8012ef <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8012b7:	83 c2 01             	add    $0x1,%edx
  8012ba:	8b 04 95 58 2d 80 00 	mov    0x802d58(,%edx,4),%eax
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	75 ee                	jne    8012b3 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8012ca:	8b 40 48             	mov    0x48(%eax),%eax
  8012cd:	83 ec 04             	sub    $0x4,%esp
  8012d0:	51                   	push   %ecx
  8012d1:	50                   	push   %eax
  8012d2:	68 dc 2c 80 00       	push   $0x802cdc
  8012d7:	e8 e2 ee ff ff       	call   8001be <cprintf>
	*dev = 0;
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    
			*dev = devtab[i];
  8012ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f9:	eb f2                	jmp    8012ed <dev_lookup+0x51>

008012fb <fd_close>:
{
  8012fb:	f3 0f 1e fb          	endbr32 
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	57                   	push   %edi
  801303:	56                   	push   %esi
  801304:	53                   	push   %ebx
  801305:	83 ec 24             	sub    $0x24,%esp
  801308:	8b 75 08             	mov    0x8(%ebp),%esi
  80130b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80130e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801311:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801312:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801318:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80131b:	50                   	push   %eax
  80131c:	e8 27 ff ff ff       	call   801248 <fd_lookup>
  801321:	89 c3                	mov    %eax,%ebx
  801323:	83 c4 10             	add    $0x10,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	78 05                	js     80132f <fd_close+0x34>
	    || fd != fd2)
  80132a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80132d:	74 16                	je     801345 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80132f:	89 f8                	mov    %edi,%eax
  801331:	84 c0                	test   %al,%al
  801333:	b8 00 00 00 00       	mov    $0x0,%eax
  801338:	0f 44 d8             	cmove  %eax,%ebx
}
  80133b:	89 d8                	mov    %ebx,%eax
  80133d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801340:	5b                   	pop    %ebx
  801341:	5e                   	pop    %esi
  801342:	5f                   	pop    %edi
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801345:	83 ec 08             	sub    $0x8,%esp
  801348:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80134b:	50                   	push   %eax
  80134c:	ff 36                	pushl  (%esi)
  80134e:	e8 49 ff ff ff       	call   80129c <dev_lookup>
  801353:	89 c3                	mov    %eax,%ebx
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	85 c0                	test   %eax,%eax
  80135a:	78 1a                	js     801376 <fd_close+0x7b>
		if (dev->dev_close)
  80135c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80135f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801362:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801367:	85 c0                	test   %eax,%eax
  801369:	74 0b                	je     801376 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80136b:	83 ec 0c             	sub    $0xc,%esp
  80136e:	56                   	push   %esi
  80136f:	ff d0                	call   *%eax
  801371:	89 c3                	mov    %eax,%ebx
  801373:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801376:	83 ec 08             	sub    $0x8,%esp
  801379:	56                   	push   %esi
  80137a:	6a 00                	push   $0x0
  80137c:	e8 16 f9 ff ff       	call   800c97 <sys_page_unmap>
	return r;
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	eb b5                	jmp    80133b <fd_close+0x40>

00801386 <close>:

int
close(int fdnum)
{
  801386:	f3 0f 1e fb          	endbr32 
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801390:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801393:	50                   	push   %eax
  801394:	ff 75 08             	pushl  0x8(%ebp)
  801397:	e8 ac fe ff ff       	call   801248 <fd_lookup>
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	79 02                	jns    8013a5 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    
		return fd_close(fd, 1);
  8013a5:	83 ec 08             	sub    $0x8,%esp
  8013a8:	6a 01                	push   $0x1
  8013aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ad:	e8 49 ff ff ff       	call   8012fb <fd_close>
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	eb ec                	jmp    8013a3 <close+0x1d>

008013b7 <close_all>:

void
close_all(void)
{
  8013b7:	f3 0f 1e fb          	endbr32 
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	53                   	push   %ebx
  8013bf:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013c2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013c7:	83 ec 0c             	sub    $0xc,%esp
  8013ca:	53                   	push   %ebx
  8013cb:	e8 b6 ff ff ff       	call   801386 <close>
	for (i = 0; i < MAXFD; i++)
  8013d0:	83 c3 01             	add    $0x1,%ebx
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	83 fb 20             	cmp    $0x20,%ebx
  8013d9:	75 ec                	jne    8013c7 <close_all+0x10>
}
  8013db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013e0:	f3 0f 1e fb          	endbr32 
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	57                   	push   %edi
  8013e8:	56                   	push   %esi
  8013e9:	53                   	push   %ebx
  8013ea:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013ed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013f0:	50                   	push   %eax
  8013f1:	ff 75 08             	pushl  0x8(%ebp)
  8013f4:	e8 4f fe ff ff       	call   801248 <fd_lookup>
  8013f9:	89 c3                	mov    %eax,%ebx
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	85 c0                	test   %eax,%eax
  801400:	0f 88 81 00 00 00    	js     801487 <dup+0xa7>
		return r;
	close(newfdnum);
  801406:	83 ec 0c             	sub    $0xc,%esp
  801409:	ff 75 0c             	pushl  0xc(%ebp)
  80140c:	e8 75 ff ff ff       	call   801386 <close>

	newfd = INDEX2FD(newfdnum);
  801411:	8b 75 0c             	mov    0xc(%ebp),%esi
  801414:	c1 e6 0c             	shl    $0xc,%esi
  801417:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80141d:	83 c4 04             	add    $0x4,%esp
  801420:	ff 75 e4             	pushl  -0x1c(%ebp)
  801423:	e8 af fd ff ff       	call   8011d7 <fd2data>
  801428:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80142a:	89 34 24             	mov    %esi,(%esp)
  80142d:	e8 a5 fd ff ff       	call   8011d7 <fd2data>
  801432:	83 c4 10             	add    $0x10,%esp
  801435:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801437:	89 d8                	mov    %ebx,%eax
  801439:	c1 e8 16             	shr    $0x16,%eax
  80143c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801443:	a8 01                	test   $0x1,%al
  801445:	74 11                	je     801458 <dup+0x78>
  801447:	89 d8                	mov    %ebx,%eax
  801449:	c1 e8 0c             	shr    $0xc,%eax
  80144c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801453:	f6 c2 01             	test   $0x1,%dl
  801456:	75 39                	jne    801491 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801458:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80145b:	89 d0                	mov    %edx,%eax
  80145d:	c1 e8 0c             	shr    $0xc,%eax
  801460:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	25 07 0e 00 00       	and    $0xe07,%eax
  80146f:	50                   	push   %eax
  801470:	56                   	push   %esi
  801471:	6a 00                	push   $0x0
  801473:	52                   	push   %edx
  801474:	6a 00                	push   $0x0
  801476:	e8 d6 f7 ff ff       	call   800c51 <sys_page_map>
  80147b:	89 c3                	mov    %eax,%ebx
  80147d:	83 c4 20             	add    $0x20,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	78 31                	js     8014b5 <dup+0xd5>
		goto err;

	return newfdnum;
  801484:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801487:	89 d8                	mov    %ebx,%eax
  801489:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80148c:	5b                   	pop    %ebx
  80148d:	5e                   	pop    %esi
  80148e:	5f                   	pop    %edi
  80148f:	5d                   	pop    %ebp
  801490:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801491:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801498:	83 ec 0c             	sub    $0xc,%esp
  80149b:	25 07 0e 00 00       	and    $0xe07,%eax
  8014a0:	50                   	push   %eax
  8014a1:	57                   	push   %edi
  8014a2:	6a 00                	push   $0x0
  8014a4:	53                   	push   %ebx
  8014a5:	6a 00                	push   $0x0
  8014a7:	e8 a5 f7 ff ff       	call   800c51 <sys_page_map>
  8014ac:	89 c3                	mov    %eax,%ebx
  8014ae:	83 c4 20             	add    $0x20,%esp
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	79 a3                	jns    801458 <dup+0x78>
	sys_page_unmap(0, newfd);
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	56                   	push   %esi
  8014b9:	6a 00                	push   $0x0
  8014bb:	e8 d7 f7 ff ff       	call   800c97 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014c0:	83 c4 08             	add    $0x8,%esp
  8014c3:	57                   	push   %edi
  8014c4:	6a 00                	push   $0x0
  8014c6:	e8 cc f7 ff ff       	call   800c97 <sys_page_unmap>
	return r;
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	eb b7                	jmp    801487 <dup+0xa7>

008014d0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014d0:	f3 0f 1e fb          	endbr32 
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	53                   	push   %ebx
  8014d8:	83 ec 1c             	sub    $0x1c,%esp
  8014db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e1:	50                   	push   %eax
  8014e2:	53                   	push   %ebx
  8014e3:	e8 60 fd ff ff       	call   801248 <fd_lookup>
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 3f                	js     80152e <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f5:	50                   	push   %eax
  8014f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f9:	ff 30                	pushl  (%eax)
  8014fb:	e8 9c fd ff ff       	call   80129c <dev_lookup>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	85 c0                	test   %eax,%eax
  801505:	78 27                	js     80152e <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801507:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80150a:	8b 42 08             	mov    0x8(%edx),%eax
  80150d:	83 e0 03             	and    $0x3,%eax
  801510:	83 f8 01             	cmp    $0x1,%eax
  801513:	74 1e                	je     801533 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801518:	8b 40 08             	mov    0x8(%eax),%eax
  80151b:	85 c0                	test   %eax,%eax
  80151d:	74 35                	je     801554 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	ff 75 10             	pushl  0x10(%ebp)
  801525:	ff 75 0c             	pushl  0xc(%ebp)
  801528:	52                   	push   %edx
  801529:	ff d0                	call   *%eax
  80152b:	83 c4 10             	add    $0x10,%esp
}
  80152e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801531:	c9                   	leave  
  801532:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801533:	a1 08 40 80 00       	mov    0x804008,%eax
  801538:	8b 40 48             	mov    0x48(%eax),%eax
  80153b:	83 ec 04             	sub    $0x4,%esp
  80153e:	53                   	push   %ebx
  80153f:	50                   	push   %eax
  801540:	68 1d 2d 80 00       	push   $0x802d1d
  801545:	e8 74 ec ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801552:	eb da                	jmp    80152e <read+0x5e>
		return -E_NOT_SUPP;
  801554:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801559:	eb d3                	jmp    80152e <read+0x5e>

0080155b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80155b:	f3 0f 1e fb          	endbr32 
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	57                   	push   %edi
  801563:	56                   	push   %esi
  801564:	53                   	push   %ebx
  801565:	83 ec 0c             	sub    $0xc,%esp
  801568:	8b 7d 08             	mov    0x8(%ebp),%edi
  80156b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80156e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801573:	eb 02                	jmp    801577 <readn+0x1c>
  801575:	01 c3                	add    %eax,%ebx
  801577:	39 f3                	cmp    %esi,%ebx
  801579:	73 21                	jae    80159c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	89 f0                	mov    %esi,%eax
  801580:	29 d8                	sub    %ebx,%eax
  801582:	50                   	push   %eax
  801583:	89 d8                	mov    %ebx,%eax
  801585:	03 45 0c             	add    0xc(%ebp),%eax
  801588:	50                   	push   %eax
  801589:	57                   	push   %edi
  80158a:	e8 41 ff ff ff       	call   8014d0 <read>
		if (m < 0)
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	78 04                	js     80159a <readn+0x3f>
			return m;
		if (m == 0)
  801596:	75 dd                	jne    801575 <readn+0x1a>
  801598:	eb 02                	jmp    80159c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80159a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80159c:	89 d8                	mov    %ebx,%eax
  80159e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5e                   	pop    %esi
  8015a3:	5f                   	pop    %edi
  8015a4:	5d                   	pop    %ebp
  8015a5:	c3                   	ret    

008015a6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015a6:	f3 0f 1e fb          	endbr32 
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 1c             	sub    $0x1c,%esp
  8015b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b7:	50                   	push   %eax
  8015b8:	53                   	push   %ebx
  8015b9:	e8 8a fc ff ff       	call   801248 <fd_lookup>
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	78 3a                	js     8015ff <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cb:	50                   	push   %eax
  8015cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cf:	ff 30                	pushl  (%eax)
  8015d1:	e8 c6 fc ff ff       	call   80129c <dev_lookup>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 22                	js     8015ff <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015e4:	74 1e                	je     801604 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8015ec:	85 d2                	test   %edx,%edx
  8015ee:	74 35                	je     801625 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	ff 75 10             	pushl  0x10(%ebp)
  8015f6:	ff 75 0c             	pushl  0xc(%ebp)
  8015f9:	50                   	push   %eax
  8015fa:	ff d2                	call   *%edx
  8015fc:	83 c4 10             	add    $0x10,%esp
}
  8015ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801602:	c9                   	leave  
  801603:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801604:	a1 08 40 80 00       	mov    0x804008,%eax
  801609:	8b 40 48             	mov    0x48(%eax),%eax
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	53                   	push   %ebx
  801610:	50                   	push   %eax
  801611:	68 39 2d 80 00       	push   $0x802d39
  801616:	e8 a3 eb ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801623:	eb da                	jmp    8015ff <write+0x59>
		return -E_NOT_SUPP;
  801625:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80162a:	eb d3                	jmp    8015ff <write+0x59>

0080162c <seek>:

int
seek(int fdnum, off_t offset)
{
  80162c:	f3 0f 1e fb          	endbr32 
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801636:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801639:	50                   	push   %eax
  80163a:	ff 75 08             	pushl  0x8(%ebp)
  80163d:	e8 06 fc ff ff       	call   801248 <fd_lookup>
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 0e                	js     801657 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801649:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801659:	f3 0f 1e fb          	endbr32 
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	53                   	push   %ebx
  801661:	83 ec 1c             	sub    $0x1c,%esp
  801664:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801667:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80166a:	50                   	push   %eax
  80166b:	53                   	push   %ebx
  80166c:	e8 d7 fb ff ff       	call   801248 <fd_lookup>
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	78 37                	js     8016af <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167e:	50                   	push   %eax
  80167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801682:	ff 30                	pushl  (%eax)
  801684:	e8 13 fc ff ff       	call   80129c <dev_lookup>
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	85 c0                	test   %eax,%eax
  80168e:	78 1f                	js     8016af <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801693:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801697:	74 1b                	je     8016b4 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801699:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169c:	8b 52 18             	mov    0x18(%edx),%edx
  80169f:	85 d2                	test   %edx,%edx
  8016a1:	74 32                	je     8016d5 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016a3:	83 ec 08             	sub    $0x8,%esp
  8016a6:	ff 75 0c             	pushl  0xc(%ebp)
  8016a9:	50                   	push   %eax
  8016aa:	ff d2                	call   *%edx
  8016ac:	83 c4 10             	add    $0x10,%esp
}
  8016af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016b4:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016b9:	8b 40 48             	mov    0x48(%eax),%eax
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	53                   	push   %ebx
  8016c0:	50                   	push   %eax
  8016c1:	68 fc 2c 80 00       	push   $0x802cfc
  8016c6:	e8 f3 ea ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  8016cb:	83 c4 10             	add    $0x10,%esp
  8016ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d3:	eb da                	jmp    8016af <ftruncate+0x56>
		return -E_NOT_SUPP;
  8016d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016da:	eb d3                	jmp    8016af <ftruncate+0x56>

008016dc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016dc:	f3 0f 1e fb          	endbr32 
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	53                   	push   %ebx
  8016e4:	83 ec 1c             	sub    $0x1c,%esp
  8016e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ed:	50                   	push   %eax
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 52 fb ff ff       	call   801248 <fd_lookup>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	78 4b                	js     801748 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801703:	50                   	push   %eax
  801704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801707:	ff 30                	pushl  (%eax)
  801709:	e8 8e fb ff ff       	call   80129c <dev_lookup>
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	78 33                	js     801748 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801718:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80171c:	74 2f                	je     80174d <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80171e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801721:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801728:	00 00 00 
	stat->st_isdir = 0;
  80172b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801732:	00 00 00 
	stat->st_dev = dev;
  801735:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80173b:	83 ec 08             	sub    $0x8,%esp
  80173e:	53                   	push   %ebx
  80173f:	ff 75 f0             	pushl  -0x10(%ebp)
  801742:	ff 50 14             	call   *0x14(%eax)
  801745:	83 c4 10             	add    $0x10,%esp
}
  801748:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    
		return -E_NOT_SUPP;
  80174d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801752:	eb f4                	jmp    801748 <fstat+0x6c>

00801754 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801754:	f3 0f 1e fb          	endbr32 
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	56                   	push   %esi
  80175c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80175d:	83 ec 08             	sub    $0x8,%esp
  801760:	6a 00                	push   $0x0
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	e8 fb 01 00 00       	call   801965 <open>
  80176a:	89 c3                	mov    %eax,%ebx
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	85 c0                	test   %eax,%eax
  801771:	78 1b                	js     80178e <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801773:	83 ec 08             	sub    $0x8,%esp
  801776:	ff 75 0c             	pushl  0xc(%ebp)
  801779:	50                   	push   %eax
  80177a:	e8 5d ff ff ff       	call   8016dc <fstat>
  80177f:	89 c6                	mov    %eax,%esi
	close(fd);
  801781:	89 1c 24             	mov    %ebx,(%esp)
  801784:	e8 fd fb ff ff       	call   801386 <close>
	return r;
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	89 f3                	mov    %esi,%ebx
}
  80178e:	89 d8                	mov    %ebx,%eax
  801790:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801793:	5b                   	pop    %ebx
  801794:	5e                   	pop    %esi
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    

00801797 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	56                   	push   %esi
  80179b:	53                   	push   %ebx
  80179c:	89 c6                	mov    %eax,%esi
  80179e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017a0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017a7:	74 27                	je     8017d0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017a9:	6a 07                	push   $0x7
  8017ab:	68 00 50 80 00       	push   $0x805000
  8017b0:	56                   	push   %esi
  8017b1:	ff 35 00 40 80 00    	pushl  0x804000
  8017b7:	e8 71 0d 00 00       	call   80252d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017bc:	83 c4 0c             	add    $0xc,%esp
  8017bf:	6a 00                	push   $0x0
  8017c1:	53                   	push   %ebx
  8017c2:	6a 00                	push   $0x0
  8017c4:	e8 df 0c 00 00       	call   8024a8 <ipc_recv>
}
  8017c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017cc:	5b                   	pop    %ebx
  8017cd:	5e                   	pop    %esi
  8017ce:	5d                   	pop    %ebp
  8017cf:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017d0:	83 ec 0c             	sub    $0xc,%esp
  8017d3:	6a 01                	push   $0x1
  8017d5:	e8 ab 0d 00 00       	call   802585 <ipc_find_env>
  8017da:	a3 00 40 80 00       	mov    %eax,0x804000
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	eb c5                	jmp    8017a9 <fsipc+0x12>

008017e4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017e4:	f3 0f 1e fb          	endbr32 
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fc:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801801:	ba 00 00 00 00       	mov    $0x0,%edx
  801806:	b8 02 00 00 00       	mov    $0x2,%eax
  80180b:	e8 87 ff ff ff       	call   801797 <fsipc>
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <devfile_flush>:
{
  801812:	f3 0f 1e fb          	endbr32 
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8b 40 0c             	mov    0xc(%eax),%eax
  801822:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801827:	ba 00 00 00 00       	mov    $0x0,%edx
  80182c:	b8 06 00 00 00       	mov    $0x6,%eax
  801831:	e8 61 ff ff ff       	call   801797 <fsipc>
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <devfile_stat>:
{
  801838:	f3 0f 1e fb          	endbr32 
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	53                   	push   %ebx
  801840:	83 ec 04             	sub    $0x4,%esp
  801843:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8b 40 0c             	mov    0xc(%eax),%eax
  80184c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
  801856:	b8 05 00 00 00       	mov    $0x5,%eax
  80185b:	e8 37 ff ff ff       	call   801797 <fsipc>
  801860:	85 c0                	test   %eax,%eax
  801862:	78 2c                	js     801890 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801864:	83 ec 08             	sub    $0x8,%esp
  801867:	68 00 50 80 00       	push   $0x805000
  80186c:	53                   	push   %ebx
  80186d:	e8 56 ef ff ff       	call   8007c8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801872:	a1 80 50 80 00       	mov    0x805080,%eax
  801877:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80187d:	a1 84 50 80 00       	mov    0x805084,%eax
  801882:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <devfile_write>:
{
  801895:	f3 0f 1e fb          	endbr32 
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 0c             	sub    $0xc,%esp
  80189f:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a5:	8b 52 0c             	mov    0xc(%edx),%edx
  8018a8:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8018ae:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8018b3:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8018b8:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8018bb:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8018c0:	50                   	push   %eax
  8018c1:	ff 75 0c             	pushl  0xc(%ebp)
  8018c4:	68 08 50 80 00       	push   $0x805008
  8018c9:	e8 b0 f0 ff ff       	call   80097e <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8018ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d3:	b8 04 00 00 00       	mov    $0x4,%eax
  8018d8:	e8 ba fe ff ff       	call   801797 <fsipc>
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <devfile_read>:
{
  8018df:	f3 0f 1e fb          	endbr32 
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
  8018e8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018f6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801901:	b8 03 00 00 00       	mov    $0x3,%eax
  801906:	e8 8c fe ff ff       	call   801797 <fsipc>
  80190b:	89 c3                	mov    %eax,%ebx
  80190d:	85 c0                	test   %eax,%eax
  80190f:	78 1f                	js     801930 <devfile_read+0x51>
	assert(r <= n);
  801911:	39 f0                	cmp    %esi,%eax
  801913:	77 24                	ja     801939 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801915:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80191a:	7f 33                	jg     80194f <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	50                   	push   %eax
  801920:	68 00 50 80 00       	push   $0x805000
  801925:	ff 75 0c             	pushl  0xc(%ebp)
  801928:	e8 51 f0 ff ff       	call   80097e <memmove>
	return r;
  80192d:	83 c4 10             	add    $0x10,%esp
}
  801930:	89 d8                	mov    %ebx,%eax
  801932:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801935:	5b                   	pop    %ebx
  801936:	5e                   	pop    %esi
  801937:	5d                   	pop    %ebp
  801938:	c3                   	ret    
	assert(r <= n);
  801939:	68 6c 2d 80 00       	push   $0x802d6c
  80193e:	68 73 2d 80 00       	push   $0x802d73
  801943:	6a 7c                	push   $0x7c
  801945:	68 88 2d 80 00       	push   $0x802d88
  80194a:	e8 76 0a 00 00       	call   8023c5 <_panic>
	assert(r <= PGSIZE);
  80194f:	68 93 2d 80 00       	push   $0x802d93
  801954:	68 73 2d 80 00       	push   $0x802d73
  801959:	6a 7d                	push   $0x7d
  80195b:	68 88 2d 80 00       	push   $0x802d88
  801960:	e8 60 0a 00 00       	call   8023c5 <_panic>

00801965 <open>:
{
  801965:	f3 0f 1e fb          	endbr32 
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	56                   	push   %esi
  80196d:	53                   	push   %ebx
  80196e:	83 ec 1c             	sub    $0x1c,%esp
  801971:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801974:	56                   	push   %esi
  801975:	e8 0b ee ff ff       	call   800785 <strlen>
  80197a:	83 c4 10             	add    $0x10,%esp
  80197d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801982:	7f 6c                	jg     8019f0 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801984:	83 ec 0c             	sub    $0xc,%esp
  801987:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198a:	50                   	push   %eax
  80198b:	e8 62 f8 ff ff       	call   8011f2 <fd_alloc>
  801990:	89 c3                	mov    %eax,%ebx
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	85 c0                	test   %eax,%eax
  801997:	78 3c                	js     8019d5 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801999:	83 ec 08             	sub    $0x8,%esp
  80199c:	56                   	push   %esi
  80199d:	68 00 50 80 00       	push   $0x805000
  8019a2:	e8 21 ee ff ff       	call   8007c8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019aa:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b7:	e8 db fd ff ff       	call   801797 <fsipc>
  8019bc:	89 c3                	mov    %eax,%ebx
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	78 19                	js     8019de <open+0x79>
	return fd2num(fd);
  8019c5:	83 ec 0c             	sub    $0xc,%esp
  8019c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cb:	e8 f3 f7 ff ff       	call   8011c3 <fd2num>
  8019d0:	89 c3                	mov    %eax,%ebx
  8019d2:	83 c4 10             	add    $0x10,%esp
}
  8019d5:	89 d8                	mov    %ebx,%eax
  8019d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019da:	5b                   	pop    %ebx
  8019db:	5e                   	pop    %esi
  8019dc:	5d                   	pop    %ebp
  8019dd:	c3                   	ret    
		fd_close(fd, 0);
  8019de:	83 ec 08             	sub    $0x8,%esp
  8019e1:	6a 00                	push   $0x0
  8019e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e6:	e8 10 f9 ff ff       	call   8012fb <fd_close>
		return r;
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	eb e5                	jmp    8019d5 <open+0x70>
		return -E_BAD_PATH;
  8019f0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019f5:	eb de                	jmp    8019d5 <open+0x70>

008019f7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019f7:	f3 0f 1e fb          	endbr32 
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a01:	ba 00 00 00 00       	mov    $0x0,%edx
  801a06:	b8 08 00 00 00       	mov    $0x8,%eax
  801a0b:	e8 87 fd ff ff       	call   801797 <fsipc>
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a12:	f3 0f 1e fb          	endbr32 
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a1c:	68 9f 2d 80 00       	push   $0x802d9f
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	e8 9f ed ff ff       	call   8007c8 <strcpy>
	return 0;
}
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <devsock_close>:
{
  801a30:	f3 0f 1e fb          	endbr32 
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	53                   	push   %ebx
  801a38:	83 ec 10             	sub    $0x10,%esp
  801a3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a3e:	53                   	push   %ebx
  801a3f:	e8 7e 0b 00 00       	call   8025c2 <pageref>
  801a44:	89 c2                	mov    %eax,%edx
  801a46:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a49:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801a4e:	83 fa 01             	cmp    $0x1,%edx
  801a51:	74 05                	je     801a58 <devsock_close+0x28>
}
  801a53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a58:	83 ec 0c             	sub    $0xc,%esp
  801a5b:	ff 73 0c             	pushl  0xc(%ebx)
  801a5e:	e8 e3 02 00 00       	call   801d46 <nsipc_close>
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	eb eb                	jmp    801a53 <devsock_close+0x23>

00801a68 <devsock_write>:
{
  801a68:	f3 0f 1e fb          	endbr32 
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a72:	6a 00                	push   $0x0
  801a74:	ff 75 10             	pushl  0x10(%ebp)
  801a77:	ff 75 0c             	pushl  0xc(%ebp)
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	ff 70 0c             	pushl  0xc(%eax)
  801a80:	e8 b5 03 00 00       	call   801e3a <nsipc_send>
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <devsock_read>:
{
  801a87:	f3 0f 1e fb          	endbr32 
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	ff 75 10             	pushl  0x10(%ebp)
  801a96:	ff 75 0c             	pushl  0xc(%ebp)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	ff 70 0c             	pushl  0xc(%eax)
  801a9f:	e8 1f 03 00 00       	call   801dc3 <nsipc_recv>
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <fd2sockid>:
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801aac:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801aaf:	52                   	push   %edx
  801ab0:	50                   	push   %eax
  801ab1:	e8 92 f7 ff ff       	call   801248 <fd_lookup>
  801ab6:	83 c4 10             	add    $0x10,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	78 10                	js     801acd <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac0:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801ac6:	39 08                	cmp    %ecx,(%eax)
  801ac8:	75 05                	jne    801acf <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801aca:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    
		return -E_NOT_SUPP;
  801acf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad4:	eb f7                	jmp    801acd <fd2sockid+0x27>

00801ad6 <alloc_sockfd>:
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	56                   	push   %esi
  801ada:	53                   	push   %ebx
  801adb:	83 ec 1c             	sub    $0x1c,%esp
  801ade:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ae0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae3:	50                   	push   %eax
  801ae4:	e8 09 f7 ff ff       	call   8011f2 <fd_alloc>
  801ae9:	89 c3                	mov    %eax,%ebx
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	85 c0                	test   %eax,%eax
  801af0:	78 43                	js     801b35 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801af2:	83 ec 04             	sub    $0x4,%esp
  801af5:	68 07 04 00 00       	push   $0x407
  801afa:	ff 75 f4             	pushl  -0xc(%ebp)
  801afd:	6a 00                	push   $0x0
  801aff:	e8 06 f1 ff ff       	call   800c0a <sys_page_alloc>
  801b04:	89 c3                	mov    %eax,%ebx
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	78 28                	js     801b35 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b10:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b16:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b22:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b25:	83 ec 0c             	sub    $0xc,%esp
  801b28:	50                   	push   %eax
  801b29:	e8 95 f6 ff ff       	call   8011c3 <fd2num>
  801b2e:	89 c3                	mov    %eax,%ebx
  801b30:	83 c4 10             	add    $0x10,%esp
  801b33:	eb 0c                	jmp    801b41 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b35:	83 ec 0c             	sub    $0xc,%esp
  801b38:	56                   	push   %esi
  801b39:	e8 08 02 00 00       	call   801d46 <nsipc_close>
		return r;
  801b3e:	83 c4 10             	add    $0x10,%esp
}
  801b41:	89 d8                	mov    %ebx,%eax
  801b43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5e                   	pop    %esi
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    

00801b4a <accept>:
{
  801b4a:	f3 0f 1e fb          	endbr32 
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	e8 4a ff ff ff       	call   801aa6 <fd2sockid>
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	78 1b                	js     801b7b <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	ff 75 10             	pushl  0x10(%ebp)
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	50                   	push   %eax
  801b6a:	e8 22 01 00 00       	call   801c91 <nsipc_accept>
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	85 c0                	test   %eax,%eax
  801b74:	78 05                	js     801b7b <accept+0x31>
	return alloc_sockfd(r);
  801b76:	e8 5b ff ff ff       	call   801ad6 <alloc_sockfd>
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <bind>:
{
  801b7d:	f3 0f 1e fb          	endbr32 
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	e8 17 ff ff ff       	call   801aa6 <fd2sockid>
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	78 12                	js     801ba5 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	ff 75 10             	pushl  0x10(%ebp)
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	50                   	push   %eax
  801b9d:	e8 45 01 00 00       	call   801ce7 <nsipc_bind>
  801ba2:	83 c4 10             	add    $0x10,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <shutdown>:
{
  801ba7:	f3 0f 1e fb          	endbr32 
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	e8 ed fe ff ff       	call   801aa6 <fd2sockid>
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	78 0f                	js     801bcc <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801bbd:	83 ec 08             	sub    $0x8,%esp
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	50                   	push   %eax
  801bc4:	e8 57 01 00 00       	call   801d20 <nsipc_shutdown>
  801bc9:	83 c4 10             	add    $0x10,%esp
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <connect>:
{
  801bce:	f3 0f 1e fb          	endbr32 
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	e8 c6 fe ff ff       	call   801aa6 <fd2sockid>
  801be0:	85 c0                	test   %eax,%eax
  801be2:	78 12                	js     801bf6 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	ff 75 10             	pushl  0x10(%ebp)
  801bea:	ff 75 0c             	pushl  0xc(%ebp)
  801bed:	50                   	push   %eax
  801bee:	e8 71 01 00 00       	call   801d64 <nsipc_connect>
  801bf3:	83 c4 10             	add    $0x10,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <listen>:
{
  801bf8:	f3 0f 1e fb          	endbr32 
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	e8 9c fe ff ff       	call   801aa6 <fd2sockid>
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	78 0f                	js     801c1d <listen+0x25>
	return nsipc_listen(r, backlog);
  801c0e:	83 ec 08             	sub    $0x8,%esp
  801c11:	ff 75 0c             	pushl  0xc(%ebp)
  801c14:	50                   	push   %eax
  801c15:	e8 83 01 00 00       	call   801d9d <nsipc_listen>
  801c1a:	83 c4 10             	add    $0x10,%esp
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <socket>:

int
socket(int domain, int type, int protocol)
{
  801c1f:	f3 0f 1e fb          	endbr32 
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c29:	ff 75 10             	pushl  0x10(%ebp)
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	e8 65 02 00 00       	call   801e9c <nsipc_socket>
  801c37:	83 c4 10             	add    $0x10,%esp
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	78 05                	js     801c43 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801c3e:	e8 93 fe ff ff       	call   801ad6 <alloc_sockfd>
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	53                   	push   %ebx
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c4e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c55:	74 26                	je     801c7d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c57:	6a 07                	push   $0x7
  801c59:	68 00 60 80 00       	push   $0x806000
  801c5e:	53                   	push   %ebx
  801c5f:	ff 35 04 40 80 00    	pushl  0x804004
  801c65:	e8 c3 08 00 00       	call   80252d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c6a:	83 c4 0c             	add    $0xc,%esp
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	e8 30 08 00 00       	call   8024a8 <ipc_recv>
}
  801c78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c7d:	83 ec 0c             	sub    $0xc,%esp
  801c80:	6a 02                	push   $0x2
  801c82:	e8 fe 08 00 00       	call   802585 <ipc_find_env>
  801c87:	a3 04 40 80 00       	mov    %eax,0x804004
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	eb c6                	jmp    801c57 <nsipc+0x12>

00801c91 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c91:	f3 0f 1e fb          	endbr32 
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	56                   	push   %esi
  801c99:	53                   	push   %ebx
  801c9a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ca5:	8b 06                	mov    (%esi),%eax
  801ca7:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cac:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb1:	e8 8f ff ff ff       	call   801c45 <nsipc>
  801cb6:	89 c3                	mov    %eax,%ebx
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	79 09                	jns    801cc5 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801cbc:	89 d8                	mov    %ebx,%eax
  801cbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc1:	5b                   	pop    %ebx
  801cc2:	5e                   	pop    %esi
  801cc3:	5d                   	pop    %ebp
  801cc4:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cc5:	83 ec 04             	sub    $0x4,%esp
  801cc8:	ff 35 10 60 80 00    	pushl  0x806010
  801cce:	68 00 60 80 00       	push   $0x806000
  801cd3:	ff 75 0c             	pushl  0xc(%ebp)
  801cd6:	e8 a3 ec ff ff       	call   80097e <memmove>
		*addrlen = ret->ret_addrlen;
  801cdb:	a1 10 60 80 00       	mov    0x806010,%eax
  801ce0:	89 06                	mov    %eax,(%esi)
  801ce2:	83 c4 10             	add    $0x10,%esp
	return r;
  801ce5:	eb d5                	jmp    801cbc <nsipc_accept+0x2b>

00801ce7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ce7:	f3 0f 1e fb          	endbr32 
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	53                   	push   %ebx
  801cef:	83 ec 08             	sub    $0x8,%esp
  801cf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801cfd:	53                   	push   %ebx
  801cfe:	ff 75 0c             	pushl  0xc(%ebp)
  801d01:	68 04 60 80 00       	push   $0x806004
  801d06:	e8 73 ec ff ff       	call   80097e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d0b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d11:	b8 02 00 00 00       	mov    $0x2,%eax
  801d16:	e8 2a ff ff ff       	call   801c45 <nsipc>
}
  801d1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d20:	f3 0f 1e fb          	endbr32 
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d35:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d3a:	b8 03 00 00 00       	mov    $0x3,%eax
  801d3f:	e8 01 ff ff ff       	call   801c45 <nsipc>
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <nsipc_close>:

int
nsipc_close(int s)
{
  801d46:	f3 0f 1e fb          	endbr32 
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d50:	8b 45 08             	mov    0x8(%ebp),%eax
  801d53:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d58:	b8 04 00 00 00       	mov    $0x4,%eax
  801d5d:	e8 e3 fe ff ff       	call   801c45 <nsipc>
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d64:	f3 0f 1e fb          	endbr32 
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	53                   	push   %ebx
  801d6c:	83 ec 08             	sub    $0x8,%esp
  801d6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d7a:	53                   	push   %ebx
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	68 04 60 80 00       	push   $0x806004
  801d83:	e8 f6 eb ff ff       	call   80097e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d88:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d8e:	b8 05 00 00 00       	mov    $0x5,%eax
  801d93:	e8 ad fe ff ff       	call   801c45 <nsipc>
}
  801d98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d9d:	f3 0f 1e fb          	endbr32 
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801da7:	8b 45 08             	mov    0x8(%ebp),%eax
  801daa:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801db7:	b8 06 00 00 00       	mov    $0x6,%eax
  801dbc:	e8 84 fe ff ff       	call   801c45 <nsipc>
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801dc3:	f3 0f 1e fb          	endbr32 
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	56                   	push   %esi
  801dcb:	53                   	push   %ebx
  801dcc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dd7:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ddd:	8b 45 14             	mov    0x14(%ebp),%eax
  801de0:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801de5:	b8 07 00 00 00       	mov    $0x7,%eax
  801dea:	e8 56 fe ff ff       	call   801c45 <nsipc>
  801def:	89 c3                	mov    %eax,%ebx
  801df1:	85 c0                	test   %eax,%eax
  801df3:	78 26                	js     801e1b <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801df5:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801dfb:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801e00:	0f 4e c6             	cmovle %esi,%eax
  801e03:	39 c3                	cmp    %eax,%ebx
  801e05:	7f 1d                	jg     801e24 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e07:	83 ec 04             	sub    $0x4,%esp
  801e0a:	53                   	push   %ebx
  801e0b:	68 00 60 80 00       	push   $0x806000
  801e10:	ff 75 0c             	pushl  0xc(%ebp)
  801e13:	e8 66 eb ff ff       	call   80097e <memmove>
  801e18:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e1b:	89 d8                	mov    %ebx,%eax
  801e1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5e                   	pop    %esi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e24:	68 ab 2d 80 00       	push   $0x802dab
  801e29:	68 73 2d 80 00       	push   $0x802d73
  801e2e:	6a 62                	push   $0x62
  801e30:	68 c0 2d 80 00       	push   $0x802dc0
  801e35:	e8 8b 05 00 00       	call   8023c5 <_panic>

00801e3a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e3a:	f3 0f 1e fb          	endbr32 
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	53                   	push   %ebx
  801e42:	83 ec 04             	sub    $0x4,%esp
  801e45:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e50:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e56:	7f 2e                	jg     801e86 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e58:	83 ec 04             	sub    $0x4,%esp
  801e5b:	53                   	push   %ebx
  801e5c:	ff 75 0c             	pushl  0xc(%ebp)
  801e5f:	68 0c 60 80 00       	push   $0x80600c
  801e64:	e8 15 eb ff ff       	call   80097e <memmove>
	nsipcbuf.send.req_size = size;
  801e69:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e72:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e77:	b8 08 00 00 00       	mov    $0x8,%eax
  801e7c:	e8 c4 fd ff ff       	call   801c45 <nsipc>
}
  801e81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    
	assert(size < 1600);
  801e86:	68 cc 2d 80 00       	push   $0x802dcc
  801e8b:	68 73 2d 80 00       	push   $0x802d73
  801e90:	6a 6d                	push   $0x6d
  801e92:	68 c0 2d 80 00       	push   $0x802dc0
  801e97:	e8 29 05 00 00       	call   8023c5 <_panic>

00801e9c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e9c:	f3 0f 1e fb          	endbr32 
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb1:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ebe:	b8 09 00 00 00       	mov    $0x9,%eax
  801ec3:	e8 7d fd ff ff       	call   801c45 <nsipc>
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801eca:	f3 0f 1e fb          	endbr32 
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	56                   	push   %esi
  801ed2:	53                   	push   %ebx
  801ed3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ed6:	83 ec 0c             	sub    $0xc,%esp
  801ed9:	ff 75 08             	pushl  0x8(%ebp)
  801edc:	e8 f6 f2 ff ff       	call   8011d7 <fd2data>
  801ee1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ee3:	83 c4 08             	add    $0x8,%esp
  801ee6:	68 d8 2d 80 00       	push   $0x802dd8
  801eeb:	53                   	push   %ebx
  801eec:	e8 d7 e8 ff ff       	call   8007c8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ef1:	8b 46 04             	mov    0x4(%esi),%eax
  801ef4:	2b 06                	sub    (%esi),%eax
  801ef6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801efc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f03:	00 00 00 
	stat->st_dev = &devpipe;
  801f06:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f0d:	30 80 00 
	return 0;
}
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
  801f15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f18:	5b                   	pop    %ebx
  801f19:	5e                   	pop    %esi
  801f1a:	5d                   	pop    %ebp
  801f1b:	c3                   	ret    

00801f1c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f1c:	f3 0f 1e fb          	endbr32 
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	53                   	push   %ebx
  801f24:	83 ec 0c             	sub    $0xc,%esp
  801f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f2a:	53                   	push   %ebx
  801f2b:	6a 00                	push   $0x0
  801f2d:	e8 65 ed ff ff       	call   800c97 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f32:	89 1c 24             	mov    %ebx,(%esp)
  801f35:	e8 9d f2 ff ff       	call   8011d7 <fd2data>
  801f3a:	83 c4 08             	add    $0x8,%esp
  801f3d:	50                   	push   %eax
  801f3e:	6a 00                	push   $0x0
  801f40:	e8 52 ed ff ff       	call   800c97 <sys_page_unmap>
}
  801f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <_pipeisclosed>:
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	57                   	push   %edi
  801f4e:	56                   	push   %esi
  801f4f:	53                   	push   %ebx
  801f50:	83 ec 1c             	sub    $0x1c,%esp
  801f53:	89 c7                	mov    %eax,%edi
  801f55:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f57:	a1 08 40 80 00       	mov    0x804008,%eax
  801f5c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	57                   	push   %edi
  801f63:	e8 5a 06 00 00       	call   8025c2 <pageref>
  801f68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f6b:	89 34 24             	mov    %esi,(%esp)
  801f6e:	e8 4f 06 00 00       	call   8025c2 <pageref>
		nn = thisenv->env_runs;
  801f73:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f79:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f7c:	83 c4 10             	add    $0x10,%esp
  801f7f:	39 cb                	cmp    %ecx,%ebx
  801f81:	74 1b                	je     801f9e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f83:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f86:	75 cf                	jne    801f57 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f88:	8b 42 58             	mov    0x58(%edx),%eax
  801f8b:	6a 01                	push   $0x1
  801f8d:	50                   	push   %eax
  801f8e:	53                   	push   %ebx
  801f8f:	68 df 2d 80 00       	push   $0x802ddf
  801f94:	e8 25 e2 ff ff       	call   8001be <cprintf>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	eb b9                	jmp    801f57 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f9e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fa1:	0f 94 c0             	sete   %al
  801fa4:	0f b6 c0             	movzbl %al,%eax
}
  801fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801faa:	5b                   	pop    %ebx
  801fab:	5e                   	pop    %esi
  801fac:	5f                   	pop    %edi
  801fad:	5d                   	pop    %ebp
  801fae:	c3                   	ret    

00801faf <devpipe_write>:
{
  801faf:	f3 0f 1e fb          	endbr32 
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	57                   	push   %edi
  801fb7:	56                   	push   %esi
  801fb8:	53                   	push   %ebx
  801fb9:	83 ec 28             	sub    $0x28,%esp
  801fbc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801fbf:	56                   	push   %esi
  801fc0:	e8 12 f2 ff ff       	call   8011d7 <fd2data>
  801fc5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	bf 00 00 00 00       	mov    $0x0,%edi
  801fcf:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fd2:	74 4f                	je     802023 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fd4:	8b 43 04             	mov    0x4(%ebx),%eax
  801fd7:	8b 0b                	mov    (%ebx),%ecx
  801fd9:	8d 51 20             	lea    0x20(%ecx),%edx
  801fdc:	39 d0                	cmp    %edx,%eax
  801fde:	72 14                	jb     801ff4 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801fe0:	89 da                	mov    %ebx,%edx
  801fe2:	89 f0                	mov    %esi,%eax
  801fe4:	e8 61 ff ff ff       	call   801f4a <_pipeisclosed>
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	75 3b                	jne    802028 <devpipe_write+0x79>
			sys_yield();
  801fed:	e8 f5 eb ff ff       	call   800be7 <sys_yield>
  801ff2:	eb e0                	jmp    801fd4 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ff4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ff7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ffb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ffe:	89 c2                	mov    %eax,%edx
  802000:	c1 fa 1f             	sar    $0x1f,%edx
  802003:	89 d1                	mov    %edx,%ecx
  802005:	c1 e9 1b             	shr    $0x1b,%ecx
  802008:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80200b:	83 e2 1f             	and    $0x1f,%edx
  80200e:	29 ca                	sub    %ecx,%edx
  802010:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802014:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802018:	83 c0 01             	add    $0x1,%eax
  80201b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80201e:	83 c7 01             	add    $0x1,%edi
  802021:	eb ac                	jmp    801fcf <devpipe_write+0x20>
	return i;
  802023:	8b 45 10             	mov    0x10(%ebp),%eax
  802026:	eb 05                	jmp    80202d <devpipe_write+0x7e>
				return 0;
  802028:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80202d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802030:	5b                   	pop    %ebx
  802031:	5e                   	pop    %esi
  802032:	5f                   	pop    %edi
  802033:	5d                   	pop    %ebp
  802034:	c3                   	ret    

00802035 <devpipe_read>:
{
  802035:	f3 0f 1e fb          	endbr32 
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	57                   	push   %edi
  80203d:	56                   	push   %esi
  80203e:	53                   	push   %ebx
  80203f:	83 ec 18             	sub    $0x18,%esp
  802042:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802045:	57                   	push   %edi
  802046:	e8 8c f1 ff ff       	call   8011d7 <fd2data>
  80204b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80204d:	83 c4 10             	add    $0x10,%esp
  802050:	be 00 00 00 00       	mov    $0x0,%esi
  802055:	3b 75 10             	cmp    0x10(%ebp),%esi
  802058:	75 14                	jne    80206e <devpipe_read+0x39>
	return i;
  80205a:	8b 45 10             	mov    0x10(%ebp),%eax
  80205d:	eb 02                	jmp    802061 <devpipe_read+0x2c>
				return i;
  80205f:	89 f0                	mov    %esi,%eax
}
  802061:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802064:	5b                   	pop    %ebx
  802065:	5e                   	pop    %esi
  802066:	5f                   	pop    %edi
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    
			sys_yield();
  802069:	e8 79 eb ff ff       	call   800be7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80206e:	8b 03                	mov    (%ebx),%eax
  802070:	3b 43 04             	cmp    0x4(%ebx),%eax
  802073:	75 18                	jne    80208d <devpipe_read+0x58>
			if (i > 0)
  802075:	85 f6                	test   %esi,%esi
  802077:	75 e6                	jne    80205f <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802079:	89 da                	mov    %ebx,%edx
  80207b:	89 f8                	mov    %edi,%eax
  80207d:	e8 c8 fe ff ff       	call   801f4a <_pipeisclosed>
  802082:	85 c0                	test   %eax,%eax
  802084:	74 e3                	je     802069 <devpipe_read+0x34>
				return 0;
  802086:	b8 00 00 00 00       	mov    $0x0,%eax
  80208b:	eb d4                	jmp    802061 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80208d:	99                   	cltd   
  80208e:	c1 ea 1b             	shr    $0x1b,%edx
  802091:	01 d0                	add    %edx,%eax
  802093:	83 e0 1f             	and    $0x1f,%eax
  802096:	29 d0                	sub    %edx,%eax
  802098:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80209d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020a0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020a3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020a6:	83 c6 01             	add    $0x1,%esi
  8020a9:	eb aa                	jmp    802055 <devpipe_read+0x20>

008020ab <pipe>:
{
  8020ab:	f3 0f 1e fb          	endbr32 
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	56                   	push   %esi
  8020b3:	53                   	push   %ebx
  8020b4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ba:	50                   	push   %eax
  8020bb:	e8 32 f1 ff ff       	call   8011f2 <fd_alloc>
  8020c0:	89 c3                	mov    %eax,%ebx
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	0f 88 23 01 00 00    	js     8021f0 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020cd:	83 ec 04             	sub    $0x4,%esp
  8020d0:	68 07 04 00 00       	push   $0x407
  8020d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d8:	6a 00                	push   $0x0
  8020da:	e8 2b eb ff ff       	call   800c0a <sys_page_alloc>
  8020df:	89 c3                	mov    %eax,%ebx
  8020e1:	83 c4 10             	add    $0x10,%esp
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	0f 88 04 01 00 00    	js     8021f0 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8020ec:	83 ec 0c             	sub    $0xc,%esp
  8020ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020f2:	50                   	push   %eax
  8020f3:	e8 fa f0 ff ff       	call   8011f2 <fd_alloc>
  8020f8:	89 c3                	mov    %eax,%ebx
  8020fa:	83 c4 10             	add    $0x10,%esp
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	0f 88 db 00 00 00    	js     8021e0 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802105:	83 ec 04             	sub    $0x4,%esp
  802108:	68 07 04 00 00       	push   $0x407
  80210d:	ff 75 f0             	pushl  -0x10(%ebp)
  802110:	6a 00                	push   $0x0
  802112:	e8 f3 ea ff ff       	call   800c0a <sys_page_alloc>
  802117:	89 c3                	mov    %eax,%ebx
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	85 c0                	test   %eax,%eax
  80211e:	0f 88 bc 00 00 00    	js     8021e0 <pipe+0x135>
	va = fd2data(fd0);
  802124:	83 ec 0c             	sub    $0xc,%esp
  802127:	ff 75 f4             	pushl  -0xc(%ebp)
  80212a:	e8 a8 f0 ff ff       	call   8011d7 <fd2data>
  80212f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802131:	83 c4 0c             	add    $0xc,%esp
  802134:	68 07 04 00 00       	push   $0x407
  802139:	50                   	push   %eax
  80213a:	6a 00                	push   $0x0
  80213c:	e8 c9 ea ff ff       	call   800c0a <sys_page_alloc>
  802141:	89 c3                	mov    %eax,%ebx
  802143:	83 c4 10             	add    $0x10,%esp
  802146:	85 c0                	test   %eax,%eax
  802148:	0f 88 82 00 00 00    	js     8021d0 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80214e:	83 ec 0c             	sub    $0xc,%esp
  802151:	ff 75 f0             	pushl  -0x10(%ebp)
  802154:	e8 7e f0 ff ff       	call   8011d7 <fd2data>
  802159:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802160:	50                   	push   %eax
  802161:	6a 00                	push   $0x0
  802163:	56                   	push   %esi
  802164:	6a 00                	push   $0x0
  802166:	e8 e6 ea ff ff       	call   800c51 <sys_page_map>
  80216b:	89 c3                	mov    %eax,%ebx
  80216d:	83 c4 20             	add    $0x20,%esp
  802170:	85 c0                	test   %eax,%eax
  802172:	78 4e                	js     8021c2 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802174:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80217e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802181:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802188:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80218b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80218d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802190:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802197:	83 ec 0c             	sub    $0xc,%esp
  80219a:	ff 75 f4             	pushl  -0xc(%ebp)
  80219d:	e8 21 f0 ff ff       	call   8011c3 <fd2num>
  8021a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021a5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021a7:	83 c4 04             	add    $0x4,%esp
  8021aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8021ad:	e8 11 f0 ff ff       	call   8011c3 <fd2num>
  8021b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021b5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021b8:	83 c4 10             	add    $0x10,%esp
  8021bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021c0:	eb 2e                	jmp    8021f0 <pipe+0x145>
	sys_page_unmap(0, va);
  8021c2:	83 ec 08             	sub    $0x8,%esp
  8021c5:	56                   	push   %esi
  8021c6:	6a 00                	push   $0x0
  8021c8:	e8 ca ea ff ff       	call   800c97 <sys_page_unmap>
  8021cd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021d0:	83 ec 08             	sub    $0x8,%esp
  8021d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8021d6:	6a 00                	push   $0x0
  8021d8:	e8 ba ea ff ff       	call   800c97 <sys_page_unmap>
  8021dd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8021e0:	83 ec 08             	sub    $0x8,%esp
  8021e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e6:	6a 00                	push   $0x0
  8021e8:	e8 aa ea ff ff       	call   800c97 <sys_page_unmap>
  8021ed:	83 c4 10             	add    $0x10,%esp
}
  8021f0:	89 d8                	mov    %ebx,%eax
  8021f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f5:	5b                   	pop    %ebx
  8021f6:	5e                   	pop    %esi
  8021f7:	5d                   	pop    %ebp
  8021f8:	c3                   	ret    

008021f9 <pipeisclosed>:
{
  8021f9:	f3 0f 1e fb          	endbr32 
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802203:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802206:	50                   	push   %eax
  802207:	ff 75 08             	pushl  0x8(%ebp)
  80220a:	e8 39 f0 ff ff       	call   801248 <fd_lookup>
  80220f:	83 c4 10             	add    $0x10,%esp
  802212:	85 c0                	test   %eax,%eax
  802214:	78 18                	js     80222e <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802216:	83 ec 0c             	sub    $0xc,%esp
  802219:	ff 75 f4             	pushl  -0xc(%ebp)
  80221c:	e8 b6 ef ff ff       	call   8011d7 <fd2data>
  802221:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	e8 1f fd ff ff       	call   801f4a <_pipeisclosed>
  80222b:	83 c4 10             	add    $0x10,%esp
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802230:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802234:	b8 00 00 00 00       	mov    $0x0,%eax
  802239:	c3                   	ret    

0080223a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80223a:	f3 0f 1e fb          	endbr32 
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802244:	68 f7 2d 80 00       	push   $0x802df7
  802249:	ff 75 0c             	pushl  0xc(%ebp)
  80224c:	e8 77 e5 ff ff       	call   8007c8 <strcpy>
	return 0;
}
  802251:	b8 00 00 00 00       	mov    $0x0,%eax
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <devcons_write>:
{
  802258:	f3 0f 1e fb          	endbr32 
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	57                   	push   %edi
  802260:	56                   	push   %esi
  802261:	53                   	push   %ebx
  802262:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802268:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80226d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802273:	3b 75 10             	cmp    0x10(%ebp),%esi
  802276:	73 31                	jae    8022a9 <devcons_write+0x51>
		m = n - tot;
  802278:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80227b:	29 f3                	sub    %esi,%ebx
  80227d:	83 fb 7f             	cmp    $0x7f,%ebx
  802280:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802285:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802288:	83 ec 04             	sub    $0x4,%esp
  80228b:	53                   	push   %ebx
  80228c:	89 f0                	mov    %esi,%eax
  80228e:	03 45 0c             	add    0xc(%ebp),%eax
  802291:	50                   	push   %eax
  802292:	57                   	push   %edi
  802293:	e8 e6 e6 ff ff       	call   80097e <memmove>
		sys_cputs(buf, m);
  802298:	83 c4 08             	add    $0x8,%esp
  80229b:	53                   	push   %ebx
  80229c:	57                   	push   %edi
  80229d:	e8 98 e8 ff ff       	call   800b3a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022a2:	01 de                	add    %ebx,%esi
  8022a4:	83 c4 10             	add    $0x10,%esp
  8022a7:	eb ca                	jmp    802273 <devcons_write+0x1b>
}
  8022a9:	89 f0                	mov    %esi,%eax
  8022ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022ae:	5b                   	pop    %ebx
  8022af:	5e                   	pop    %esi
  8022b0:	5f                   	pop    %edi
  8022b1:	5d                   	pop    %ebp
  8022b2:	c3                   	ret    

008022b3 <devcons_read>:
{
  8022b3:	f3 0f 1e fb          	endbr32 
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 08             	sub    $0x8,%esp
  8022bd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022c6:	74 21                	je     8022e9 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8022c8:	e8 8f e8 ff ff       	call   800b5c <sys_cgetc>
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	75 07                	jne    8022d8 <devcons_read+0x25>
		sys_yield();
  8022d1:	e8 11 e9 ff ff       	call   800be7 <sys_yield>
  8022d6:	eb f0                	jmp    8022c8 <devcons_read+0x15>
	if (c < 0)
  8022d8:	78 0f                	js     8022e9 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8022da:	83 f8 04             	cmp    $0x4,%eax
  8022dd:	74 0c                	je     8022eb <devcons_read+0x38>
	*(char*)vbuf = c;
  8022df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e2:	88 02                	mov    %al,(%edx)
	return 1;
  8022e4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    
		return 0;
  8022eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f0:	eb f7                	jmp    8022e9 <devcons_read+0x36>

008022f2 <cputchar>:
{
  8022f2:	f3 0f 1e fb          	endbr32 
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802302:	6a 01                	push   $0x1
  802304:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802307:	50                   	push   %eax
  802308:	e8 2d e8 ff ff       	call   800b3a <sys_cputs>
}
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <getchar>:
{
  802312:	f3 0f 1e fb          	endbr32 
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80231c:	6a 01                	push   $0x1
  80231e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802321:	50                   	push   %eax
  802322:	6a 00                	push   $0x0
  802324:	e8 a7 f1 ff ff       	call   8014d0 <read>
	if (r < 0)
  802329:	83 c4 10             	add    $0x10,%esp
  80232c:	85 c0                	test   %eax,%eax
  80232e:	78 06                	js     802336 <getchar+0x24>
	if (r < 1)
  802330:	74 06                	je     802338 <getchar+0x26>
	return c;
  802332:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802336:	c9                   	leave  
  802337:	c3                   	ret    
		return -E_EOF;
  802338:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80233d:	eb f7                	jmp    802336 <getchar+0x24>

0080233f <iscons>:
{
  80233f:	f3 0f 1e fb          	endbr32 
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802349:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80234c:	50                   	push   %eax
  80234d:	ff 75 08             	pushl  0x8(%ebp)
  802350:	e8 f3 ee ff ff       	call   801248 <fd_lookup>
  802355:	83 c4 10             	add    $0x10,%esp
  802358:	85 c0                	test   %eax,%eax
  80235a:	78 11                	js     80236d <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802365:	39 10                	cmp    %edx,(%eax)
  802367:	0f 94 c0             	sete   %al
  80236a:	0f b6 c0             	movzbl %al,%eax
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <opencons>:
{
  80236f:	f3 0f 1e fb          	endbr32 
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802379:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80237c:	50                   	push   %eax
  80237d:	e8 70 ee ff ff       	call   8011f2 <fd_alloc>
  802382:	83 c4 10             	add    $0x10,%esp
  802385:	85 c0                	test   %eax,%eax
  802387:	78 3a                	js     8023c3 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802389:	83 ec 04             	sub    $0x4,%esp
  80238c:	68 07 04 00 00       	push   $0x407
  802391:	ff 75 f4             	pushl  -0xc(%ebp)
  802394:	6a 00                	push   $0x0
  802396:	e8 6f e8 ff ff       	call   800c0a <sys_page_alloc>
  80239b:	83 c4 10             	add    $0x10,%esp
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	78 21                	js     8023c3 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023ab:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023b7:	83 ec 0c             	sub    $0xc,%esp
  8023ba:	50                   	push   %eax
  8023bb:	e8 03 ee ff ff       	call   8011c3 <fd2num>
  8023c0:	83 c4 10             	add    $0x10,%esp
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023c5:	f3 0f 1e fb          	endbr32 
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	56                   	push   %esi
  8023cd:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8023ce:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023d1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8023d7:	e8 e8 e7 ff ff       	call   800bc4 <sys_getenvid>
  8023dc:	83 ec 0c             	sub    $0xc,%esp
  8023df:	ff 75 0c             	pushl  0xc(%ebp)
  8023e2:	ff 75 08             	pushl  0x8(%ebp)
  8023e5:	56                   	push   %esi
  8023e6:	50                   	push   %eax
  8023e7:	68 04 2e 80 00       	push   $0x802e04
  8023ec:	e8 cd dd ff ff       	call   8001be <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8023f1:	83 c4 18             	add    $0x18,%esp
  8023f4:	53                   	push   %ebx
  8023f5:	ff 75 10             	pushl  0x10(%ebp)
  8023f8:	e8 6c dd ff ff       	call   800169 <vcprintf>
	cprintf("\n");
  8023fd:	c7 04 24 14 29 80 00 	movl   $0x802914,(%esp)
  802404:	e8 b5 dd ff ff       	call   8001be <cprintf>
  802409:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80240c:	cc                   	int3   
  80240d:	eb fd                	jmp    80240c <_panic+0x47>

0080240f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80240f:	f3 0f 1e fb          	endbr32 
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802419:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802420:	74 0a                	je     80242c <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  80242c:	83 ec 04             	sub    $0x4,%esp
  80242f:	6a 07                	push   $0x7
  802431:	68 00 f0 bf ee       	push   $0xeebff000
  802436:	6a 00                	push   $0x0
  802438:	e8 cd e7 ff ff       	call   800c0a <sys_page_alloc>
  80243d:	83 c4 10             	add    $0x10,%esp
  802440:	85 c0                	test   %eax,%eax
  802442:	78 2a                	js     80246e <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802444:	83 ec 08             	sub    $0x8,%esp
  802447:	68 82 24 80 00       	push   $0x802482
  80244c:	6a 00                	push   $0x0
  80244e:	e8 16 e9 ff ff       	call   800d69 <sys_env_set_pgfault_upcall>
  802453:	83 c4 10             	add    $0x10,%esp
  802456:	85 c0                	test   %eax,%eax
  802458:	79 c8                	jns    802422 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	68 54 2e 80 00       	push   $0x802e54
  802462:	6a 25                	push   $0x25
  802464:	68 8c 2e 80 00       	push   $0x802e8c
  802469:	e8 57 ff ff ff       	call   8023c5 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  80246e:	83 ec 04             	sub    $0x4,%esp
  802471:	68 28 2e 80 00       	push   $0x802e28
  802476:	6a 22                	push   $0x22
  802478:	68 8c 2e 80 00       	push   $0x802e8c
  80247d:	e8 43 ff ff ff       	call   8023c5 <_panic>

00802482 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802482:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802483:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802488:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80248a:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  80248d:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802491:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802495:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802498:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80249a:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  80249e:	83 c4 08             	add    $0x8,%esp
	popal
  8024a1:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8024a2:	83 c4 04             	add    $0x4,%esp
	popfl
  8024a5:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8024a6:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8024a7:	c3                   	ret    

008024a8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024a8:	f3 0f 1e fb          	endbr32 
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	56                   	push   %esi
  8024b0:	53                   	push   %ebx
  8024b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8024b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	74 3d                	je     8024fb <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8024be:	83 ec 0c             	sub    $0xc,%esp
  8024c1:	50                   	push   %eax
  8024c2:	e8 0f e9 ff ff       	call   800dd6 <sys_ipc_recv>
  8024c7:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8024ca:	85 f6                	test   %esi,%esi
  8024cc:	74 0b                	je     8024d9 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8024ce:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8024d4:	8b 52 74             	mov    0x74(%edx),%edx
  8024d7:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8024d9:	85 db                	test   %ebx,%ebx
  8024db:	74 0b                	je     8024e8 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8024dd:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8024e3:	8b 52 78             	mov    0x78(%edx),%edx
  8024e6:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8024e8:	85 c0                	test   %eax,%eax
  8024ea:	78 21                	js     80250d <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8024ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8024f1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8024f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024f7:	5b                   	pop    %ebx
  8024f8:	5e                   	pop    %esi
  8024f9:	5d                   	pop    %ebp
  8024fa:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8024fb:	83 ec 0c             	sub    $0xc,%esp
  8024fe:	68 00 00 c0 ee       	push   $0xeec00000
  802503:	e8 ce e8 ff ff       	call   800dd6 <sys_ipc_recv>
  802508:	83 c4 10             	add    $0x10,%esp
  80250b:	eb bd                	jmp    8024ca <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80250d:	85 f6                	test   %esi,%esi
  80250f:	74 10                	je     802521 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802511:	85 db                	test   %ebx,%ebx
  802513:	75 df                	jne    8024f4 <ipc_recv+0x4c>
  802515:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80251c:	00 00 00 
  80251f:	eb d3                	jmp    8024f4 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802521:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802528:	00 00 00 
  80252b:	eb e4                	jmp    802511 <ipc_recv+0x69>

0080252d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80252d:	f3 0f 1e fb          	endbr32 
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	57                   	push   %edi
  802535:	56                   	push   %esi
  802536:	53                   	push   %ebx
  802537:	83 ec 0c             	sub    $0xc,%esp
  80253a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80253d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802540:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802543:	85 db                	test   %ebx,%ebx
  802545:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80254a:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80254d:	ff 75 14             	pushl  0x14(%ebp)
  802550:	53                   	push   %ebx
  802551:	56                   	push   %esi
  802552:	57                   	push   %edi
  802553:	e8 57 e8 ff ff       	call   800daf <sys_ipc_try_send>
  802558:	83 c4 10             	add    $0x10,%esp
  80255b:	85 c0                	test   %eax,%eax
  80255d:	79 1e                	jns    80257d <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80255f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802562:	75 07                	jne    80256b <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802564:	e8 7e e6 ff ff       	call   800be7 <sys_yield>
  802569:	eb e2                	jmp    80254d <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80256b:	50                   	push   %eax
  80256c:	68 9a 2e 80 00       	push   $0x802e9a
  802571:	6a 59                	push   $0x59
  802573:	68 b5 2e 80 00       	push   $0x802eb5
  802578:	e8 48 fe ff ff       	call   8023c5 <_panic>
	}
}
  80257d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802580:	5b                   	pop    %ebx
  802581:	5e                   	pop    %esi
  802582:	5f                   	pop    %edi
  802583:	5d                   	pop    %ebp
  802584:	c3                   	ret    

00802585 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802585:	f3 0f 1e fb          	endbr32 
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
  80258c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80258f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802594:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802597:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80259d:	8b 52 50             	mov    0x50(%edx),%edx
  8025a0:	39 ca                	cmp    %ecx,%edx
  8025a2:	74 11                	je     8025b5 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8025a4:	83 c0 01             	add    $0x1,%eax
  8025a7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025ac:	75 e6                	jne    802594 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b3:	eb 0b                	jmp    8025c0 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8025b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025bd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025c0:	5d                   	pop    %ebp
  8025c1:	c3                   	ret    

008025c2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025c2:	f3 0f 1e fb          	endbr32 
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025cc:	89 c2                	mov    %eax,%edx
  8025ce:	c1 ea 16             	shr    $0x16,%edx
  8025d1:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8025d8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8025dd:	f6 c1 01             	test   $0x1,%cl
  8025e0:	74 1c                	je     8025fe <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8025e2:	c1 e8 0c             	shr    $0xc,%eax
  8025e5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025ec:	a8 01                	test   $0x1,%al
  8025ee:	74 0e                	je     8025fe <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025f0:	c1 e8 0c             	shr    $0xc,%eax
  8025f3:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8025fa:	ef 
  8025fb:	0f b7 d2             	movzwl %dx,%edx
}
  8025fe:	89 d0                	mov    %edx,%eax
  802600:	5d                   	pop    %ebp
  802601:	c3                   	ret    
  802602:	66 90                	xchg   %ax,%ax
  802604:	66 90                	xchg   %ax,%ax
  802606:	66 90                	xchg   %ax,%ax
  802608:	66 90                	xchg   %ax,%ax
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	66 90                	xchg   %ax,%ax
  80260e:	66 90                	xchg   %ax,%ax

00802610 <__udivdi3>:
  802610:	f3 0f 1e fb          	endbr32 
  802614:	55                   	push   %ebp
  802615:	57                   	push   %edi
  802616:	56                   	push   %esi
  802617:	53                   	push   %ebx
  802618:	83 ec 1c             	sub    $0x1c,%esp
  80261b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80261f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802623:	8b 74 24 34          	mov    0x34(%esp),%esi
  802627:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80262b:	85 d2                	test   %edx,%edx
  80262d:	75 19                	jne    802648 <__udivdi3+0x38>
  80262f:	39 f3                	cmp    %esi,%ebx
  802631:	76 4d                	jbe    802680 <__udivdi3+0x70>
  802633:	31 ff                	xor    %edi,%edi
  802635:	89 e8                	mov    %ebp,%eax
  802637:	89 f2                	mov    %esi,%edx
  802639:	f7 f3                	div    %ebx
  80263b:	89 fa                	mov    %edi,%edx
  80263d:	83 c4 1c             	add    $0x1c,%esp
  802640:	5b                   	pop    %ebx
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	39 f2                	cmp    %esi,%edx
  80264a:	76 14                	jbe    802660 <__udivdi3+0x50>
  80264c:	31 ff                	xor    %edi,%edi
  80264e:	31 c0                	xor    %eax,%eax
  802650:	89 fa                	mov    %edi,%edx
  802652:	83 c4 1c             	add    $0x1c,%esp
  802655:	5b                   	pop    %ebx
  802656:	5e                   	pop    %esi
  802657:	5f                   	pop    %edi
  802658:	5d                   	pop    %ebp
  802659:	c3                   	ret    
  80265a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802660:	0f bd fa             	bsr    %edx,%edi
  802663:	83 f7 1f             	xor    $0x1f,%edi
  802666:	75 48                	jne    8026b0 <__udivdi3+0xa0>
  802668:	39 f2                	cmp    %esi,%edx
  80266a:	72 06                	jb     802672 <__udivdi3+0x62>
  80266c:	31 c0                	xor    %eax,%eax
  80266e:	39 eb                	cmp    %ebp,%ebx
  802670:	77 de                	ja     802650 <__udivdi3+0x40>
  802672:	b8 01 00 00 00       	mov    $0x1,%eax
  802677:	eb d7                	jmp    802650 <__udivdi3+0x40>
  802679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802680:	89 d9                	mov    %ebx,%ecx
  802682:	85 db                	test   %ebx,%ebx
  802684:	75 0b                	jne    802691 <__udivdi3+0x81>
  802686:	b8 01 00 00 00       	mov    $0x1,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	f7 f3                	div    %ebx
  80268f:	89 c1                	mov    %eax,%ecx
  802691:	31 d2                	xor    %edx,%edx
  802693:	89 f0                	mov    %esi,%eax
  802695:	f7 f1                	div    %ecx
  802697:	89 c6                	mov    %eax,%esi
  802699:	89 e8                	mov    %ebp,%eax
  80269b:	89 f7                	mov    %esi,%edi
  80269d:	f7 f1                	div    %ecx
  80269f:	89 fa                	mov    %edi,%edx
  8026a1:	83 c4 1c             	add    $0x1c,%esp
  8026a4:	5b                   	pop    %ebx
  8026a5:	5e                   	pop    %esi
  8026a6:	5f                   	pop    %edi
  8026a7:	5d                   	pop    %ebp
  8026a8:	c3                   	ret    
  8026a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026b0:	89 f9                	mov    %edi,%ecx
  8026b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026b7:	29 f8                	sub    %edi,%eax
  8026b9:	d3 e2                	shl    %cl,%edx
  8026bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026bf:	89 c1                	mov    %eax,%ecx
  8026c1:	89 da                	mov    %ebx,%edx
  8026c3:	d3 ea                	shr    %cl,%edx
  8026c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026c9:	09 d1                	or     %edx,%ecx
  8026cb:	89 f2                	mov    %esi,%edx
  8026cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026d1:	89 f9                	mov    %edi,%ecx
  8026d3:	d3 e3                	shl    %cl,%ebx
  8026d5:	89 c1                	mov    %eax,%ecx
  8026d7:	d3 ea                	shr    %cl,%edx
  8026d9:	89 f9                	mov    %edi,%ecx
  8026db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026df:	89 eb                	mov    %ebp,%ebx
  8026e1:	d3 e6                	shl    %cl,%esi
  8026e3:	89 c1                	mov    %eax,%ecx
  8026e5:	d3 eb                	shr    %cl,%ebx
  8026e7:	09 de                	or     %ebx,%esi
  8026e9:	89 f0                	mov    %esi,%eax
  8026eb:	f7 74 24 08          	divl   0x8(%esp)
  8026ef:	89 d6                	mov    %edx,%esi
  8026f1:	89 c3                	mov    %eax,%ebx
  8026f3:	f7 64 24 0c          	mull   0xc(%esp)
  8026f7:	39 d6                	cmp    %edx,%esi
  8026f9:	72 15                	jb     802710 <__udivdi3+0x100>
  8026fb:	89 f9                	mov    %edi,%ecx
  8026fd:	d3 e5                	shl    %cl,%ebp
  8026ff:	39 c5                	cmp    %eax,%ebp
  802701:	73 04                	jae    802707 <__udivdi3+0xf7>
  802703:	39 d6                	cmp    %edx,%esi
  802705:	74 09                	je     802710 <__udivdi3+0x100>
  802707:	89 d8                	mov    %ebx,%eax
  802709:	31 ff                	xor    %edi,%edi
  80270b:	e9 40 ff ff ff       	jmp    802650 <__udivdi3+0x40>
  802710:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802713:	31 ff                	xor    %edi,%edi
  802715:	e9 36 ff ff ff       	jmp    802650 <__udivdi3+0x40>
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	66 90                	xchg   %ax,%ax
  80271e:	66 90                	xchg   %ax,%ax

00802720 <__umoddi3>:
  802720:	f3 0f 1e fb          	endbr32 
  802724:	55                   	push   %ebp
  802725:	57                   	push   %edi
  802726:	56                   	push   %esi
  802727:	53                   	push   %ebx
  802728:	83 ec 1c             	sub    $0x1c,%esp
  80272b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80272f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802733:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802737:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80273b:	85 c0                	test   %eax,%eax
  80273d:	75 19                	jne    802758 <__umoddi3+0x38>
  80273f:	39 df                	cmp    %ebx,%edi
  802741:	76 5d                	jbe    8027a0 <__umoddi3+0x80>
  802743:	89 f0                	mov    %esi,%eax
  802745:	89 da                	mov    %ebx,%edx
  802747:	f7 f7                	div    %edi
  802749:	89 d0                	mov    %edx,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	83 c4 1c             	add    $0x1c,%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	89 f2                	mov    %esi,%edx
  80275a:	39 d8                	cmp    %ebx,%eax
  80275c:	76 12                	jbe    802770 <__umoddi3+0x50>
  80275e:	89 f0                	mov    %esi,%eax
  802760:	89 da                	mov    %ebx,%edx
  802762:	83 c4 1c             	add    $0x1c,%esp
  802765:	5b                   	pop    %ebx
  802766:	5e                   	pop    %esi
  802767:	5f                   	pop    %edi
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    
  80276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802770:	0f bd e8             	bsr    %eax,%ebp
  802773:	83 f5 1f             	xor    $0x1f,%ebp
  802776:	75 50                	jne    8027c8 <__umoddi3+0xa8>
  802778:	39 d8                	cmp    %ebx,%eax
  80277a:	0f 82 e0 00 00 00    	jb     802860 <__umoddi3+0x140>
  802780:	89 d9                	mov    %ebx,%ecx
  802782:	39 f7                	cmp    %esi,%edi
  802784:	0f 86 d6 00 00 00    	jbe    802860 <__umoddi3+0x140>
  80278a:	89 d0                	mov    %edx,%eax
  80278c:	89 ca                	mov    %ecx,%edx
  80278e:	83 c4 1c             	add    $0x1c,%esp
  802791:	5b                   	pop    %ebx
  802792:	5e                   	pop    %esi
  802793:	5f                   	pop    %edi
  802794:	5d                   	pop    %ebp
  802795:	c3                   	ret    
  802796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80279d:	8d 76 00             	lea    0x0(%esi),%esi
  8027a0:	89 fd                	mov    %edi,%ebp
  8027a2:	85 ff                	test   %edi,%edi
  8027a4:	75 0b                	jne    8027b1 <__umoddi3+0x91>
  8027a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ab:	31 d2                	xor    %edx,%edx
  8027ad:	f7 f7                	div    %edi
  8027af:	89 c5                	mov    %eax,%ebp
  8027b1:	89 d8                	mov    %ebx,%eax
  8027b3:	31 d2                	xor    %edx,%edx
  8027b5:	f7 f5                	div    %ebp
  8027b7:	89 f0                	mov    %esi,%eax
  8027b9:	f7 f5                	div    %ebp
  8027bb:	89 d0                	mov    %edx,%eax
  8027bd:	31 d2                	xor    %edx,%edx
  8027bf:	eb 8c                	jmp    80274d <__umoddi3+0x2d>
  8027c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027c8:	89 e9                	mov    %ebp,%ecx
  8027ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8027cf:	29 ea                	sub    %ebp,%edx
  8027d1:	d3 e0                	shl    %cl,%eax
  8027d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027d7:	89 d1                	mov    %edx,%ecx
  8027d9:	89 f8                	mov    %edi,%eax
  8027db:	d3 e8                	shr    %cl,%eax
  8027dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027e9:	09 c1                	or     %eax,%ecx
  8027eb:	89 d8                	mov    %ebx,%eax
  8027ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027f1:	89 e9                	mov    %ebp,%ecx
  8027f3:	d3 e7                	shl    %cl,%edi
  8027f5:	89 d1                	mov    %edx,%ecx
  8027f7:	d3 e8                	shr    %cl,%eax
  8027f9:	89 e9                	mov    %ebp,%ecx
  8027fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027ff:	d3 e3                	shl    %cl,%ebx
  802801:	89 c7                	mov    %eax,%edi
  802803:	89 d1                	mov    %edx,%ecx
  802805:	89 f0                	mov    %esi,%eax
  802807:	d3 e8                	shr    %cl,%eax
  802809:	89 e9                	mov    %ebp,%ecx
  80280b:	89 fa                	mov    %edi,%edx
  80280d:	d3 e6                	shl    %cl,%esi
  80280f:	09 d8                	or     %ebx,%eax
  802811:	f7 74 24 08          	divl   0x8(%esp)
  802815:	89 d1                	mov    %edx,%ecx
  802817:	89 f3                	mov    %esi,%ebx
  802819:	f7 64 24 0c          	mull   0xc(%esp)
  80281d:	89 c6                	mov    %eax,%esi
  80281f:	89 d7                	mov    %edx,%edi
  802821:	39 d1                	cmp    %edx,%ecx
  802823:	72 06                	jb     80282b <__umoddi3+0x10b>
  802825:	75 10                	jne    802837 <__umoddi3+0x117>
  802827:	39 c3                	cmp    %eax,%ebx
  802829:	73 0c                	jae    802837 <__umoddi3+0x117>
  80282b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80282f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802833:	89 d7                	mov    %edx,%edi
  802835:	89 c6                	mov    %eax,%esi
  802837:	89 ca                	mov    %ecx,%edx
  802839:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80283e:	29 f3                	sub    %esi,%ebx
  802840:	19 fa                	sbb    %edi,%edx
  802842:	89 d0                	mov    %edx,%eax
  802844:	d3 e0                	shl    %cl,%eax
  802846:	89 e9                	mov    %ebp,%ecx
  802848:	d3 eb                	shr    %cl,%ebx
  80284a:	d3 ea                	shr    %cl,%edx
  80284c:	09 d8                	or     %ebx,%eax
  80284e:	83 c4 1c             	add    $0x1c,%esp
  802851:	5b                   	pop    %ebx
  802852:	5e                   	pop    %esi
  802853:	5f                   	pop    %edi
  802854:	5d                   	pop    %ebp
  802855:	c3                   	ret    
  802856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80285d:	8d 76 00             	lea    0x0(%esi),%esi
  802860:	29 fe                	sub    %edi,%esi
  802862:	19 c3                	sbb    %eax,%ebx
  802864:	89 f2                	mov    %esi,%edx
  802866:	89 d9                	mov    %ebx,%ecx
  802868:	e9 1d ff ff ff       	jmp    80278a <__umoddi3+0x6a>
